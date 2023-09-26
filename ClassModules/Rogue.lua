local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 4 then --Only do this if we're on a Rogue!
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

	local specCache = {
		assassination = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
		outlaw = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
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
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			maxResource2 = 5,
			effects = {
			}
		}

		specCache.assassination.spells = {
			-- Class Poisons
			cripplingPoison = {
				id = 3409,
				name = "",
				icon = "",
				isTalent = false
			},
			woundPoison = {
				id = 8680,
				name = "",
				icon = "",
				isTalent = false
			},
			numbingPoison = {
				id = 5760,
				name = "",
				icon = "",
				isTalent = true
			},
			atrophicPoison = {
				id = 392388,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Assassination Poisons
			deadlyPoison = {
				id = 2818,
				name = "",
				icon = "",
				isTalent = true
			},
			amplifyingPoison = {
				id = 383414,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Rogue Class Baseline Abilities
			stealth = {
				id = 1784,
				name = "",
				icon = ""
			},
			ambush = {
				id = 8676,
				name = "",
				icon = "",
				energy = -50,
				comboPointsGenerated = 2,
				stealth = true,
				texture = "",
				thresholdId = 1,
				settingKey = "ambush",
				thresholdUsable = false,
				baseline = true
			},
			cheapShot = {
				id = 1833,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				stealth = true,
				texture = "",
				thresholdId = 2,
				settingKey = "cheapShot",
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			crimsonVial = {
				id = 185311,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 3,
				settingKey = "crimsonVial",
				hasCooldown = true,
				cooldown = 30,
				nimbleFingers = true,
				thresholdUsable = false,
				baseline = true
			},
			distract = {
				id = 1725,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 4,
				settingKey = "distract",
				hasCooldown = true,
				cooldown = 30,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			kidneyShot = {
				id = 408,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 5,
				settingKey = "kidneyShot",
				hasCooldown = true,
				cooldown = 20,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			sliceAndDice = {
				id = 315496,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "sliceAndDice",
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true,
				pandemicTimes = {
					12 * 0.3, -- 0 CP, show same as if we had 1
					12 * 0.3,
					18 * 0.3,
					24 * 0.3,
					30 * 0.3,
					36 * 0.3,
					42 * 0.3,
					48 * 0.3
				},
				baseline = true
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 7,
				settingKey = "feint",
				hasCooldown = true,
				cooldown = 15,
				nimbleFingers = true,
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},

			--Rogue Talent Abilities
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 8,
				settingKey = "shiv",
				hasCooldown = true,
				isSnowflake = true,
				cooldown = 25,
				thresholdUsable = false,
				isTalent = true,
				baseline = true
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				stealth = true,
				texture = "",
				thresholdId = 9,
				settingKey = "sap",
				rushedSetup = true,
				thresholdUsable = false,
				isTalent = true
			},
			nimbleFingers = {
				id = 378427,
				name = "",
				icon = "",
				energyMod = -10,
				isTalent = true
			},
			gouge = {
				id = 1776,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 10,
				settingKey = "gouge",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 15,
				isTalent = true
			},
			subterfuge = {
				id = 108208,
				name = "",
				icon = "",
				isTalent = true
			},
			rushedSetup = {
				id = 378803,
				name = "",
				icon = "",
				energyMod = 0.8,
				isTalent = true
			},
			tightSpender = {
				id = 381621,
				name = "",
				icon = "",
				energyMod = 0.9,
				isTalent = true
			},
			echoingReprimand = {
				id = 385616,
				name = "",
				icon = "",
				energy = -10,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 11,
				settingKey = "echoingReprimand",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 45,
				buffId = {					
					323558, -- 2
					323559, -- 3
					323560, -- 4
					354835, -- 4
					354838, -- 5
				}
			},
			echoingReprimand_2CP = {
				id = 323558,
				name = "",
				icon = "",
				comboPoint = 2
			},
			echoingReprimand_3CP = {
				id = 323559,
				name = "",
				icon = "",
				comboPoint = 3
			},
			echoingReprimand_4CP = {
				id = 323560,
				name = "",
				icon = "",
				comboPoint = 4
			},
			echoingReprimand_4CP2 = {
				id = 354835,
				name = "",
				icon = "",
				comboPoint = 4
			},
			echoingReprimand_5CP = {
				id = 354838,
				name = "",
				icon = "",
				comboPoint = 5
			},
			--TODO: Finish implementing Shadow Dance
			shadowDance = {
				id = 185313,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Assassination Baseline Abilities
			envenom = {
				id = 32645,
				name = "",
				icon = "",
				energy = -35,
				comboPoints = true,
				texture = "",
				thresholdId = 12,
				settingKey = "envenom",
				thresholdUsable = false,
				baseline = true
			},
			fanOfKnives = {
				id = 51723,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 13,
				settingKey = "fanOfKnives",
				thresholdUsable = false,
				baseline = true
			},
			garrote = {
				id = 703,
				name = "",
				icon = "",
				energy = -45,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 14,
				settingKey = "garrote",
				hasCooldown = true,
				cooldown = 6,
				thresholdUsable = false,
				pandemicTime = 18 * 0.3,
				baseline = true,
				isSnowflake = true
			},
			mutilate = {
				id = 1329,
				name = "",
				icon = "",
				energy = -50,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 15,
				settingKey = "mutilate",
				thresholdUsable = false,
				baseline = true
			},
			poisonedKnife = {
				id = 185565,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 16,
				settingKey = "poisonedKnife",
				thresholdUsable = false,
				baseline = true
			},
			rupture = {
				id = 1943,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 17,
				settingKey = "rupture",
				thresholdUsable = false,
				pandemicTimes = {
					8 * 0.3, -- 0 CP, show same as if we had 1
					8 * 0.3,
					12 * 0.3,
					16 * 0.3,
					20 * 0.3,
					24 * 0.3,
					28 * 0.3,
					32 * 0.3,
				},
				baseline = true
			},

			-- Assassination Spec Abilities
			internalBleeding = {
				id = 381627,
				name = "",
				icon = "",
				isTalent = true
			},
			lightweightShiv = {
				id = 394983,
				name = "",
				icon = "",
				isTalent = true
			},
			crimsonTempest = {
				id = 121411,
				name = "",
				icon = "",
				energy = -30,
				comboPoints = true,
				texture = "",
				thresholdId = 18,
				settingKey = "crimsonTempest",
				thresholdUsable = false,
				pandemicTimes = {
					4 * 0.3, -- 0 CP, show same as if we had 1
					4 * 0.3,
					6 * 0.3,
					8 * 0.3,
					10 * 0.3,
					12 * 0.3,
					14 * 0.3,
					16 * 0.3, -- Kyrian ability buff
				},
				isTalent = true
			},
			improvedGarrote = {
				id = 381632,
				name = "",
				icon = "",
				stealthBuffId = 392401,
				buffId = 392403,
				isTalent = true
			},
			exsanguinate = {
				id = 200806,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 19,
				settingKey = "exsanguinate",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				cooldown = 45,
				isTalent = true
			},
			-- TODO: Add Doomblade as a bleed
			blindside = {
				id = 121153,
				name = "",
				icon = "",
				duration = 10,
				isTalent = true
			},
			tinyToxicBlade = {
				id = 381800,
				name = "",
				icon = "",
				isTalent = true
			},
			serratedBoneSpike = {
				id = 385424,
				name = "",
				icon = "",
				energy = -15,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 20,
				settingKey = "serratedBoneSpike",
				hasCooldown = true,
				debuffId = 394036,
				isTalent = true
			},
			sepsis = {
				id = 385408,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 21,
				settingKey = "sepsis",
				hasCooldown = true,
				cooldown = 90,
				buffId = 375939,
				isTalent = true
			},
			kingsbane = {
				id = 385627,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 22,
				settingKey = "kingsbane",
				hasCooldown = true,
				cooldown = 60,
				isTalent = true
			},

			-- PvP
			deathFromAbove = {
				id = 269513,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 23,
				settingKey = "deathFromAbove",
				comboPoints = true,
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 30
			},
			dismantle = {
				id = 207777,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 24,
				settingKey = "dismantle",
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 45
			},

			adrenalineRush = {
				id = 13750,
				name = "",
				icon = "",
			},
		}

		specCache.assassination.snapshotData.attributes.energyRegen = 0
		specCache.assassination.snapshotData.attributes.comboPoints = 0
		specCache.assassination.snapshotData.audio = {
			overcapCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.crimsonVial.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.crimsonVial)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.distract.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.distract)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.kidneyShot.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.kidneyShot)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.sliceAndDice)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.shiv.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.shiv)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.feint.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.feint)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.gouge.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.gouge)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.garrote.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.garrote)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.improvedGarrote.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.improvedGarrote, {
			isActiveStealth = false
		})
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.echoingReprimand,
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
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.echoingReprimand_2CP.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.echoingReprimand_2CP)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.echoingReprimand_3CP.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.echoingReprimand_3CP)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.echoingReprimand_4CP.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.echoingReprimand_4CP)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.echoingReprimand_4CP2.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.echoingReprimand_4CP2)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.echoingReprimand_5CP.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.echoingReprimand_5CP)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.exsanguinate.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.exsanguinate)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.serratedBoneSpike.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.serratedBoneSpike)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.sepsis.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.sepsis)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.kingsbane.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.kingsbane)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.deathFromAbove)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.blindside.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.blindside)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.dismantle.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.dismantle)
		---@type TRB.Classes.Snapshot
		specCache.assassination.snapshotData.snapshots[specCache.assassination.spells.subterfuge.id] = TRB.Classes.Snapshot:New(specCache.assassination.spells.subterfuge, nil, true)

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
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			maxResource2 = 5,
			effects = {
			}
		}

		specCache.outlaw.spells = {
			-- Class Poisons
			cripplingPoison = {
				id = 3409,
				name = "",
				icon = "",
				isTalent = false
			},
			woundPoison = {
				id = 8680,
				name = "",
				icon = "",
				isTalent = false
			},
			numbingPoison = {
				id = 5760,
				name = "",
				icon = "",
				isTalent = true
			},
			atrophicPoison = {
				id = 392388,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Outlaw Poisons
			
			-- Rogue Class Baseline Abilities
			stealth = {
				id = 1784,
				name = "",
				icon = ""
			},
			ambush = {
				id = 8676,
				name = "",
				icon = "",
				energy = -50,
				comboPointsGenerated = 2,
				stealth = true,
				texture = "",
				thresholdId = 1,
				settingKey = "ambush",
				thresholdUsable = false,
				baseline = true
			},
			cheapShot = {
				id = 1833,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				stealth = true,
				texture = "",
				thresholdId = 2,
				settingKey = "cheapShot",
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			crimsonVial = {
				id = 185311,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 3,
				settingKey = "crimsonVial",
				hasCooldown = true,
				cooldown = 30,
				nimbleFingers = true,
				thresholdUsable = false,
				baseline = true
			},
			distract = {
				id = 1725,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 4,
				settingKey = "distract",
				hasCooldown = true,
				cooldown = 30,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			kidneyShot = {
				id = 408,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 5,
				settingKey = "kidneyShot",
				hasCooldown = true,
				cooldown = 20,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			sliceAndDice = {
				id = 315496,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "sliceAndDice",
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true,
				pandemicTimes = {
					12 * 0.3, -- 0 CP, show same as if we had 1
					12 * 0.3,
					18 * 0.3,
					24 * 0.3,
					30 * 0.3,
					36 * 0.3,
					42 * 0.3,
					48 * 0.3
				},
				baseline = true
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 7,
				settingKey = "feint",
				hasCooldown = true,
				cooldown = 15,
				nimbleFingers = true,
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},

			--Rogue Talent Abilities
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 8,
				settingKey = "shiv",
				hasCooldown = true,
				cooldown = 25,
				thresholdUsable = false,
				isTalent = true,
				baseline = true
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				stealth = true,
				texture = "",
				thresholdId = 9,
				settingKey = "sap",
				rushedSetup = true,
				thresholdUsable = false,
				isTalent = true
			},
			nimbleFingers = {
				id = 378427,
				name = "",
				icon = "",
				energyMod = -10,
				isTalent = true
			},
			gouge = {
				id = 1776,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 10,
				settingKey = "gouge",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 15,
				dirtyTricks = true,
				isTalent = true
			},
			subterfuge = {
				id = 108208,
				name = "",
				icon = "",
				isTalent = true
			},
			rushedSetup = {
				id = 378803,
				name = "",
				icon = "",
				energyMod = 0.8,
				isTalent = true
			},
			tightSpender = {
				id = 381621,
				name = "",
				icon = "",
				energyMod = 0.9,
				isTalent = true
			},
			echoingReprimand = {
				id = 385616,
				name = "",
				icon = "",
				energy = -10,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 11,
				settingKey = "echoingReprimand",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 45,
				buffId = {
					323558, -- 2
					323559, -- 3
					323560, -- 4
					354835, -- 4
					354838, -- 5
				}
			},
			echoingReprimand_2CP = {
				id = 323558,
				name = "",
				icon = "",
				comboPoint = 2
			},
			echoingReprimand_3CP = {
				id = 323559,
				name = "",
				icon = "",
				comboPoint = 3
			},
			echoingReprimand_4CP = {
				id = 323560,
				name = "",
				icon = "",
				comboPoint = 4
			},
			echoingReprimand_4CP2 = {
				id = 354835,
				name = "",
				icon = "",
				comboPoint = 4
			},
			echoingReprimand_5CP = {
				id = 354838,
				name = "",
				icon = "",
				comboPoint = 5
			},
			--TODO: Finish implementing Shadow Dance
			shadowDance = {
				id = 185313,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Outlaw Baseline Abilities
			betweenTheEyes = {
				id = 315341,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 12,
				settingKey = "betweenTheEyes",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				cooldown = 45,
				restlessBlades = true,
				baseline = true
			},
			dispatch = {
				id = 2098,
				name = "",
				icon = "",
				energy = -35,
				comboPoints = true,
				texture = "",
				thresholdId = 13,
				settingKey = "dispatch",
				thresholdUsable = false,
				baseline = true
			},
			pistolShot = {
				id = 185763,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 14,
				settingKey = "pistolShot",
				hasCooldown = false,
				isSnowflake = true,
				thresholdUsable = false,
				baseline = true
			},
			sinisterStrike = {
				id = 193315,
				name = "",
				icon = "",
				energy = -45,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 15,
				settingKey = "sinisterStrike",
				hasCooldown = false,
				isSnowflake = true,
				thresholdUsable = false,
				baseline = true
			},
			opportunity = {
				id = 195627,
				name = "",
				icon = "",
				energyModifier = 0.5,
				baseline = true,
				isTalent = true
			},
			bladeFlurry = {
				id = 13877,
				name = "",
				icon = "",
				energy = -15,
				texture = "",
				thresholdId = 16,
				settingKey = "bladeFlurry",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 30,
				restlessBlades = true,
				baseline = true,
				isTalent = true
			},

			-- Outlaw Spec Abilities
			adrenalineRush = {
				id = 13750,
				name = "",
				icon = "",
				restlessBlades = true,
				isTalent = true
			},
			restlessBlades = {
				id = 79096,
				name = "",
				icon = "",
				isTalent = true
			},
			dirtyTricks = {
				id = 108216,
				name = "",
				icon = "",
				isTalent = true
			},
			rollTheBones = {
				id = 315508,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 17,
				settingKey = "rollTheBones",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 45,
				restlessBlades = true
			},

			-- Roll the Bones
			broadside = {
				id = 193356,
				name = "",
				icon = "",
			},
			buriedTreasure = {
				id = 199600,
				name = "",
				icon = "",
			},
			grandMelee = {
				id = 193358,
				name = "",
				icon = "",
			},
			ruthlessPrecision = {
				id = 193357,
				name = "",
				icon = "",
			},
			skullAndCrossbones = {
				id = 199603,
				name = "",
				icon = "",
			},
			trueBearing = {
				id = 193359,
				name = "",
				icon = "",
			},
			countTheOdds = {
				id = 381982,
				name = "",
				icon = "",
				duration = 5
			},

			sepsis = {
				id = 385408,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 18,
				settingKey = "sepsis",
				hasCooldown = true,
				cooldown = 90,
				buffId = 375939,
				restlessBlades = true,
				isTalent = true
			},
			ghostlyStrike = {
				id = 196937,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 19,
				settingKey = "ghostlyStrike",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true,
				cooldown = 35,
				restlessBlades = true
			},
			bladeRush = {
				id = 271877,
				name = "",
				icon = "",
				isTalent = true,
				energy = 25,
				duration = 5,
				cooldown = 45,
				restlessBlades = true
			},
			dreadblades = {
				id = 343142,
				name = "",
				icon = "",
				energy = -50,
				texture = "",
				thresholdId = 20,
				settingKey = "dreadblades",
				hasCooldown = true,
				isTalent = true,
				thresholdUsable = false,
				cooldown = 90,
				restlessBlades = true
			},
			keepItRolling = {
				id = 381989,
				name = "",
				icon = "",
				isTalent = true,
				duration = 30,
				cooldown = 60 * 7,
				restlessBlades = true
			},
			-- TODO: Implement this!
			greenskinsWickers = {
				id = 386823,
				name = "",
				icon = "",
				isTalent = true
			},

			-- PvP
			deathFromAbove = {
				id = 269513,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 21,
				settingKey = "deathFromAbove",
				comboPoints = true,
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 30
			},
			dismantle = {
				id = 207777,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 22,
				settingKey = "dismantle",
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 45
			},
		}

		specCache.outlaw.snapshotData.attributes.energyRegen = 0
		specCache.outlaw.snapshotData.attributes.comboPoints = 0
		specCache.outlaw.snapshotData.audio = {
			overcapCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.crimsonVial.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.crimsonVial)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.distract.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.distract)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.feint.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.feint)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.kidneyShot.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.kidneyShot)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.shiv.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.shiv)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.gouge.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.gouge)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.betweenTheEyes.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.betweenTheEyes)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.bladeFlurry.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.bladeFlurry)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.bladeRush.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.bladeRush)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.ghostlyStrike.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.ghostlyStrike)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.dreadblades.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.dreadblades)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.sliceAndDice)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.opportunity.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.opportunity)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.subterfuge.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.subterfuge, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.echoingReprimand,
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
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.echoingReprimand_2CP.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.echoingReprimand_2CP)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.echoingReprimand_3CP.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.echoingReprimand_3CP)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.echoingReprimand_4CP.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.echoingReprimand_4CP)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.echoingReprimand_4CP2.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.echoingReprimand_4CP2)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.echoingReprimand_5CP.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.echoingReprimand_5CP)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.sepsis.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.sepsis)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.deathFromAbove)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.dismantle.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.dismantle)
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.rollTheBones.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.rollTheBones, {
			---@type TRB.Classes.Snapshot[]
			buffs = {
				[specCache.outlaw.spells.broadside.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.broadside, {
					fromCountTheOdds = false
				}),
				[specCache.outlaw.spells.buriedTreasure.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.buriedTreasure, {
					fromCountTheOdds = false
				}),
				[specCache.outlaw.spells.grandMelee.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.grandMelee, {
					fromCountTheOdds = false
				}),
				[specCache.outlaw.spells.ruthlessPrecision.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.ruthlessPrecision, {
					fromCountTheOdds = false
				}),
				[specCache.outlaw.spells.skullAndCrossbones.id] = TRB.Classes.Snapshot:New(specCache.outlaw.spells.skullAndCrossbones, {
					fromCountTheOdds = false
				}),
				[specCache.outlaw.spells.trueBearing.id] =TRB.Classes.Snapshot:New(specCache.outlaw.spells.trueBearing, {
					fromCountTheOdds = false
				})
			},
			count = 0,
			temporaryCount = 0,
			goodBuffs = false
		})
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.broadside.id] = specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.rollTheBones.id].attributes.buffs[specCache.outlaw.spells.broadside.id]
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.buriedTreasure.id] = specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.rollTheBones.id].attributes.buffs[specCache.outlaw.spells.buriedTreasure.id]
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.grandMelee.id] = specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.rollTheBones.id].attributes.buffs[specCache.outlaw.spells.grandMelee.id]
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.ruthlessPrecision.id] = specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.rollTheBones.id].attributes.buffs[specCache.outlaw.spells.ruthlessPrecision.id]
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.skullAndCrossbones.id] = specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.rollTheBones.id].attributes.buffs[specCache.outlaw.spells.skullAndCrossbones.id]
		---@type TRB.Classes.Snapshot
		specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.trueBearing.id] = specCache.outlaw.snapshotData.snapshots[specCache.outlaw.spells.rollTheBones.id].attributes.buffs[specCache.outlaw.spells.trueBearing.id]

		specCache.outlaw.barTextVariables = {
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

	local function Setup_Outlaw()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "rogue", "outlaw")
	end

	local function FillSpellData_Assassination()
		Setup_Assassination()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.assassination.spells)
		
		-- This is done here so that we can get icons for the options menu!
		specCache.assassination.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

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
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste %", printInSettings = true, color = false },
			{ variable = "$hastePercent", description = "Current Haste %", printInSettings = false, color = false },
			{ variable = "$hasteRating", description = "Current Haste rating", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Critical Strike %", printInSettings = true, color = false },
			{ variable = "$critPercent", description = "Current Critical Strike %", printInSettings = false, color = false },
			{ variable = "$critRating", description = "Current Critical Strike rating", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery %", printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = "Current Mastery %", printInSettings = false, color = false },
			{ variable = "$masteryRating", description = "Current Mastery rating", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility % (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$versatility", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility % (damage reduction/defensive)", printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = "Current Versatility % (damage reduction/defensive)", printInSettings = false, color = false },
			{ variable = "$versRating", description = "Current Versatility rating", printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = "Current Versatility rating", printInSettings = false, color = false },

			{ variable = "$int", description = "Current Intellect", printInSettings = true, color = false },
			{ variable = "$intellect", description = "Current Intellect", printInSettings = false, color = false },
			{ variable = "$agi", description = "Current Agility", printInSettings = true, color = false },
			{ variable = "$agility", description = "Current Agility", printInSettings = false, color = false },
			{ variable = "$str", description = "Current Strength", printInSettings = true, color = false },
			{ variable = "$strength", description = "Current Strength", printInSettings = false, color = false },
			{ variable = "$stam", description = "Current Stamina", printInSettings = true, color = false },
			{ variable = "$stamina", description = "Current Stamina", printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = "Are you currently in combat? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },
			{ variable = "$inStealth", description = "Are you currently considered to be in stealth? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },


			{ variable = "$energy", description = "Current Energy", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Energy", printInSettings = false, color = false },
			{ variable = "$energyMax", description = "Maximum Energy", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Energy", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },
			
			{ variable = "$comboPoints", description = "Current Combo Points", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Combo Points", printInSettings = true, color = false },

			{ variable = "$sadTime", description = "Time remaining on Slice and Dice buff", printInSettings = true, color = false },
			{ variable = "$sliceAndDiceTime", description = "Time remaining on Slice and Dice buff", printInSettings = false, color = false },

			-- Bleeds
			{ variable = "$isBleeding", description = "Does your current target have a bleed active on it? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$ctCount", description = "Number of Crimson Tempest bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$crimsonTempestCount", description = "Number of Crimson Tempest bleeds active on targets", printInSettings = false, color = false },
			{ variable = "$ctTime", description = "Time remaining on Crimson Tempest on your current target", printInSettings = true, color = false },
			{ variable = "$crimsonTempestTime", description = "Time remaining on Crimson Tempest on your current target", printInSettings = false, color = false },

			{ variable = "$garroteCount", description = "Number of Garrote bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$garroteTime", description = "Time remaining on Garrote on your current target", printInSettings = true, color = false },

			{ variable = "$ibCount", description = "Number of Internal Bleeding bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$internalBleedingCount", description = "Number of Internal Bleeding bleeds active on targets", printInSettings = false, color = false },
			{ variable = "$ibTime", description = "Time remaining on Internal Bleeding on your current target", printInSettings = true, color = false },
			{ variable = "$internalBleedingTime", description = "Time remaining on Internal Bleeding on your current target", printInSettings = false, color = false },

			{ variable = "$ruptureCount", description = "Number of Rupture bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$ruptureTime", description = "Time remaining on Rupture on your current target", printInSettings = true, color = false },
		
			{ variable = "$sbsCount", description = "Number of Serrated Bone Spike bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$serratedBoneSpikeCount", description = "Number of Serrated Bone Spike bleeds active on targets", printInSettings = false, color = false },

			-- Poisons
			
			{ variable = "$amplifyingPoisonCount", description = "Number of Amplifying Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$amplifyingPoisonTime", description = "Time remaining on Amplifying Poison on your current target", printInSettings = false, color = false },

			{ variable = "$atrophicPoisonCount", description = "Number of Atrophic Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$atrophicPoisonTime", description = "Time remaining on Atrophic Poison on your current target", printInSettings = false, color = false },

			{ variable = "$cpCount", description = "Number of Crippling Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonCount", description = "Number of Crippling Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$cpTime", description = "Time remaining on Crippling Poison on your current target", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonTime", description = "Time remaining on Crippling Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$dpCount", description = "Number of Deadly Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonCount", description = "Number of Deadly Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$dpTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$npCount", description = "Number of Numbing Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$numbingPoisonCount", description = "Number of Numbing Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$npTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = true, color = false },
			{ variable = "$numbingPoisonTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = false, color = false },

			{ variable = "$wpCount", description = "Number of Wound Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$woundPoisonCount", description = "Number of Wound Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$wpTime", description = "Time remaining on Wound Poison on your current target", printInSettings = true, color = false },
			{ variable = "$woundPoisonTime", description = "Time remaining on Wound Poison on your current target", printInSettings = false, color = false },

			-- Proc
			{ variable = "$blindsideTime", description = "Time remaining on Blindside proc", printInSettings = true, color = false },


			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.assassination.spells = spells
	end

	local function FillSpellData_Outlaw()
		Setup_Outlaw()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.outlaw.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.outlaw.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#adrenalineRush", icon = spells.adrenalineRush.icon, description = spells.adrenalineRush.name, printInSettings = true },
			{ variable = "#betweenTheEyes", icon = spells.betweenTheEyes.icon, description = spells.betweenTheEyes.name, printInSettings = true },
			{ variable = "#bladeFlurry", icon = spells.bladeFlurry.icon, description = spells.bladeFlurry.name, printInSettings = true },
			{ variable = "#bladeRush", icon = spells.bladeRush.icon, description = spells.bladeRush.name, printInSettings = true },
			{ variable = "#broadside", icon = spells.broadside.icon, description = spells.broadside.name, printInSettings = true },
			{ variable = "#buriedTreasure", icon = spells.buriedTreasure.icon, description = spells.buriedTreasure.name, printInSettings = true },
			{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
			{ variable = "#dirtyTricks", icon = spells.dirtyTricks.icon, description = spells.dirtyTricks.name, printInSettings = true },
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
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste %", printInSettings = true, color = false },
			{ variable = "$hastePercent", description = "Current Haste %", printInSettings = false, color = false },
			{ variable = "$hasteRating", description = "Current Haste rating", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Critical Strike %", printInSettings = true, color = false },
			{ variable = "$critPercent", description = "Current Critical Strike %", printInSettings = false, color = false },
			{ variable = "$critRating", description = "Current Critical Strike rating", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery %", printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = "Current Mastery %", printInSettings = false, color = false },
			{ variable = "$masteryRating", description = "Current Mastery rating", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility % (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$versatility", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility % (damage reduction/defensive)", printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = "Current Versatility % (damage reduction/defensive)", printInSettings = false, color = false },
			{ variable = "$versRating", description = "Current Versatility rating", printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = "Current Versatility rating", printInSettings = false, color = false },

			{ variable = "$int", description = "Current Intellect", printInSettings = true, color = false },
			{ variable = "$intellect", description = "Current Intellect", printInSettings = false, color = false },
			{ variable = "$agi", description = "Current Agility", printInSettings = true, color = false },
			{ variable = "$agility", description = "Current Agility", printInSettings = false, color = false },
			{ variable = "$str", description = "Current Strength", printInSettings = true, color = false },
			{ variable = "$strength", description = "Current Strength", printInSettings = false, color = false },
			{ variable = "$stam", description = "Current Stamina", printInSettings = true, color = false },
			{ variable = "$stamina", description = "Current Stamina", printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = "Are you currently in combat? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },
			{ variable = "$inStealth", description = "Are you currently considered to be in stealth? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },


			{ variable = "$energy", description = "Current Energy", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Energy", printInSettings = false, color = false },
			{ variable = "$energyMax", description = "Maximum Energy", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Energy", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },
			
			{ variable = "$comboPoints", description = "Current Combo Points", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Combo Points", printInSettings = true, color = false },

			{ variable = "$rtbCount", description = "Current number of Roll the Bones buffs active", printInSettings = true, color = false },
			{ variable = "$rollTheBonesCount", description = "Current number of Roll the Bones buffs active", printInSettings = false, color = false },

			{ variable = "$rtbTemporaryCount", description = "Current number of full Roll the Bones buffs active", printInSettings = true, color = false },
			{ variable = "$rollTheBonesTemporaryCount", description = "Current number of temporary Roll the Bones buffs (from Count the Odds) active", printInSettings = false, color = false },

			{ variable = "$rtbAllCount", description = "Current number of Roll the Bones buffs active from all sources", printInSettings = true, color = false },
			{ variable = "$rollTheBonesAllCount", description = "Current number of Roll the Bones buffs active from all sources", printInSettings = false, color = false },
			
			{ variable = "$rtbBuffTime", description = "Time remaining on your Roll the Bones buffs (not from Count the Odds)", printInSettings = true, color = false },
			{ variable = "$rollTheBonesBuffTime", description = "Time remaining on your Roll the Bones buffs (not from Count the Odds)", printInSettings = false, color = false },
			
			{ variable = "$rtbGoodBuff", description = "Are the current Roll the Bones buffs good or not? Good is defined as any two buffs, Broadside, or True Bearing. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$rollTheBonesGoodBuff", description = "Are the current Roll the Bones buffs good or not? Good is defined as any two buffs, Broadside, or True Bearing. Logic variable only!", printInSettings = false, color = false },

			{ variable = "$broadsideTime", description = "Time remaining on Broadside buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$buriedTreasureTime", description = "Time remaining on Burried Treasure buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$grandMeleeTime", description = "Time remaining on Grand Melee buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$ruthlessPrecisionTime", description = "Time remaining on Ruthless Precision buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$skullAndCrossbonesTime", description = "Time remaining on Skull and Crossbones buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$trueBearingTime", description = "Time remaining on True Bearing buff (from Roll the Bones)", printInSettings = true, color = false },

			{ variable = "$sadTime", description = "Time remaining on Slice and Dice buff", printInSettings = true, color = false },
			{ variable = "$sliceAndDiceTime", description = "Time remaining on Slice and Dice buff", printInSettings = false, color = false },

			-- Proc
			{ variable = "$opportunityTime", description = "Time remaining on Opportunity proc", printInSettings = true, color = false },

			-- Poisons
			{ variable = "$atrophicPoisonCount", description = "Number of Atrophic Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$atrophicPoisonTime", description = "Time remaining on Atrophic Poison on your current target", printInSettings = false, color = false },

			{ variable = "$cpCount", description = "Number of Crippling Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonCount", description = "Number of Crippling Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$cpTime", description = "Time remaining on Crippling Poison on your current target", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonTime", description = "Time remaining on Crippling Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$npCount", description = "Number of Numbing Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$numbingPoisonCount", description = "Number of Numbing Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$npTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = true, color = false },
			{ variable = "$numbingPoisonTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = false, color = false },
			
			{ variable = "$wpCount", description = "Number of Wound Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$woundPoisonCount", description = "Number of Wound Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$wpTime", description = "Time remaining on Wound Poison on your current target", printInSettings = true, color = false },
			{ variable = "$woundPoisonTime", description = "Time remaining on Wound Poison on your current target", printInSettings = false, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.outlaw.spells = spells
	end

	local function IsTargetBleeding(guid)
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		if guid == nil then
			guid = snapshotData.targetData.currentTargetGuid
		end
		
		local target = snapshotData.targetData.targets[guid] --[[@as TRB.Classes.Target]]

		if target == nil then
			return false
		end

		local specId = GetSpecialization()
		if specId == 1 then -- Assassination
			return target.spells[spells.garrote.id].active or target.spells[spells.rupture.id].active or target.spells[spells.internalBleeding.id].active or target.spells[spells.crimsonTempest.id].active
		end
		return false
	end
	
	local function CalculateAbilityResourceValue(resource, nimbleFingers, rushedSetup, comboPoints)
		local spells = TRB.Data.spells
		local modifier = 1.0

		if comboPoints == true and talents:IsTalentActive(spells.tightSpender) then
			modifier = modifier * spells.tightSpender.energyMod
		end

		-- TODO: validate how Nimble Fingers reduces energy costs. Is it before or after percentage modifiers? Assuming before for now
		if nimbleFingers == true and talents:IsTalentActive(spells.nimbleFingers) then
			resource = resource + spells.nimbleFingers.energyMod
		end

		if rushedSetup == true and talents:IsTalentActive(spells.rushedSetup) then
			modifier = modifier * spells.rushedSetup.energyMod
		end

		return resource * modifier
	end

	local function UpdateCastingResourceFinal()
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		
		if specId == 1 then -- Assassination
			targetData:UpdateDebuffs(currentTime)
		elseif specId == 2 then -- Outlaw
			targetData:UpdateDebuffs(currentTime)
		end
	end

	local function TargetsCleanup(clearAll)
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		targetData:Cleanup(clearAll)
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		local spells = TRB.Data.spells

		local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end

		for k, v in pairs(spells) do
			local spell = spells[k]
			if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
				if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
				TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell.settingKey, settings)

				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
			end
		end
		TRB.Frames.resource2ContainerFrame:Show()

		TRB.Functions.Bar:Construct(settings)
		
		if specId == 1 or specId == 2 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function RefreshLookupData_Assassination()
		local specSettings = TRB.Data.settings.rogue.assassination
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.energyRegen, _ = GetPowerRegen()

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
				for k, v in pairs(spells) do
					local spell = spells[k]
					if	spell ~= nil and spell.thresholdUsable == true then
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
				_regenEnergy = snapshotData.attributes.energyRegen * (specSettings.generation.time or 3.0)
			else
				_regenEnergy = snapshotData.attributes.energyRegen * ((specSettings.generation.gcds or 2) * _gcd)
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
			if _ctTime > spells.crimsonTempest.pandemicTimes[snapshotData.attributes.resource2 + 1] then
				ctCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _ctCount)
				ctTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _ctTime)
			elseif _ctTime > 0 then
				ctCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _ctCount)
				ctTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _ctTime)
			else
				ctCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ctCount)
				ctTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _garroteTime > spells.garrote.pandemicTime then
				garroteCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _garroteTime)
			elseif _garroteTime > 0 then
				garroteCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _garroteTime)
			else
				garroteCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
						
			if _ibTime > 0 then
				ibCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _ibCount)
				ibTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _ibTime)
			else
				ibCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ibCount)
				ibTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _ruptureTime > spells.rupture.pandemicTimes[snapshotData.attributes.resource2 + 1] then
				ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _ruptureTime)
			elseif _ruptureTime > 0 then
				ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _ruptureTime)
			else
				ruptureCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			--Poisons
			if _cpTime > 0 then
				cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _cpCount)
				cpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _cpTime)
			else
				cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _cpCount)
				cpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _dpTime > 0 then
				dpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _dpCount)
				dpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _dpTime)
			else
				dpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _dpCount)
				dpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _npTime > 0 then
				npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _npCount)
				npTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _npTime)
			else
				npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _npCount)
				npTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _wpTime > 0 then
				wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _wpCount)
				wpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _wpTime)
			else
				wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _wpCount)
				wpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _atrophicPoisonTime > 0 then
				atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _atrophicPoisonCount)
				atrophicPoisonTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _atrophicPoisonTime)
			else
				atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _atrophicPoisonCount)
				atrophicPoisonTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _amplifyingPoisonTime > 0 then
				amplifyingPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _amplifyingPoisonCount)
				amplifyingPoisonTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _amplifyingPoisonTime)
			else
				amplifyingPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _amplifyingPoisonCount)
				amplifyingPoisonTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _sbsOnTarget == false and talents:IsTalentActive(spells.serratedBoneSpike) then
				sbsCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _sbsCount)
			else
				sbsCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _sbsCount)
			end
		else
			-- Bleeds
			ctTime = string.format("%.1f", _ctTime)
			garroteTime = string.format("%.1f", _garroteTime)
			ibTime = string.format("%.1f", _ibTime)
			ruptureTime = string.format("%.1f", _ruptureTime)

			-- Poisons
			amplifyingPoisonTime = string.format("%.1f", _amplifyingPoisonTime)
			atrophicPoisonTime = string.format("%.1f", _atrophicPoisonTime)
			cpTime = string.format("%.1f", _cpTime)
			dpTime = string.format("%.1f", _dpTime)
			npTime = string.format("%.1f", _npTime)
			wpTime = string.format("%.1f", _wpTime)
		end
		

		--$sadTime
		local _sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
		local sadTime
		
		if _sadTime > spells.sliceAndDice.pandemicTimes[snapshotData.attributes.resource2 + 1] then
			sadTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _sadTime)
		elseif _sadTime > 0 then
			sadTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _sadTime)
		else
			sadTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
		end

		
		--$blindsideTime
		local _blindsideTime = snapshots[spells.blindside.id].buff:GetRemainingTime(currentTime)
		local blindsideTime = string.format("%.1f", _blindsideTime)

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

		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$energyTotal"] = energyTotal
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$energy"] = currentEnergy
		lookup["$resourcePlusCasting"] = energyPlusCasting
		lookup["$resourcePlusPassive"] = energyPlusPassive
		lookup["$resourceTotal"] = energyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentEnergy
		lookup["$casting"] = castingEnergy
		lookup["$comboPoints"] = TRB.Data.character.resource2
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
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$energyPlusCasting"] = _energyPlusCasting
		lookupLogic["$energyTotal"] = _energyTotal
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
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
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Outlaw()
		local specSettings = TRB.Data.settings.rogue.outlaw
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.energyRegen, _ = GetPowerRegen()

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
				for k, v in pairs(spells) do
					local spell = spells[k]
					if	spell ~= nil and spell.thresholdUsable == true then
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
				_regenEnergy = snapshotData.attributes.energyRegen * (specSettings.generation.time or 3.0)
			else
				_regenEnergy = snapshotData.attributes.energyRegen * ((specSettings.generation.gcds or 2) * _gcd)
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
				atrophicPoisonTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _atrophicPoisonTime)
			else
				atrophicPoisonCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _atrophicPoisonCount)
				atrophicPoisonTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _cpTime > 0 then
				cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _cpCount)
				cpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _cpTime)
			else
				cpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _cpCount)
				cpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _npTime > 0 then
				npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _npCount)
				npTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _npTime)
			else
				npCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _npCount)
				npTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if _wpTime > 0 then
				wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _wpCount)
				wpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _wpTime)
			else
				wpCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _wpCount)
				wpTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			-- Poisons
			atrophicPoisonTime = string.format("%.1f", _atrophicPoisonTime)
			cpTime = string.format("%.1f", _cpTime)
			npTime = string.format("%.1f", _npTime)
			wpTime = string.format("%.1f", _wpTime)
		end

		--$sadTime
		local _sadTime = snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
		local sadTime
		
		if _sadTime > spells.sliceAndDice.pandemicTimes[snapshotData.attributes.resource2 + 1] then
			sadTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _sadTime)
		elseif _sadTime > 0 then
			sadTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _sadTime)
		else
			sadTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
		end

		local rollTheBones = snapshots[spells.rollTheBones.id]
		local rollTheBonesCount = rollTheBones.attributes.count
		local rollTheBonesTemporaryCount = rollTheBones.attributes.temporaryCount
		local rollTheBonesAllCount = rollTheBones.attributes.count + rollTheBones.attributes.temporaryCount

		--$rtbBuffTime
		local _rtbBuffTime = snapshots[spells.rollTheBones.id].buff.remaining
		local rtbBuffTime = string.format("%.1f", _rtbBuffTime)

		--$broadsideTime
		local _broadsideTime = snapshots[spells.broadside.id].buff:GetRemainingTime(currentTime)
		local broadsideTime = string.format("%.1f", _broadsideTime)

		--$buriedTreasureTime
		local _buriedTreasureTime = snapshots[spells.buriedTreasure.id].buff:GetRemainingTime(currentTime)
		local buriedTreasureTime = string.format("%.1f", _buriedTreasureTime)

		--$grandMeleeTime
		local _grandMeleeTime = snapshots[spells.grandMelee.id].buff:GetRemainingTime(currentTime)
		local grandMeleeTime = string.format("%.1f", _grandMeleeTime)

		--$ruthlessPrecisionTime
		local _ruthlessPrecisionTime = snapshots[spells.ruthlessPrecision.id].buff:GetRemainingTime(currentTime)
		local ruthlessPrecisionTime = string.format("%.1f", _ruthlessPrecisionTime)

		--$skullAndCrossbonesTime
		local _skullAndCrossbonesTime = snapshots[spells.skullAndCrossbones.id].buff:GetRemainingTime(currentTime)
		local skullAndCrossbonesTime = string.format("%.1f", _skullAndCrossbonesTime)

		--$trueBearingTime
		local _trueBearingTime = snapshots[spells.trueBearing.id].buff:GetRemainingTime(currentTime)
		local trueBearingTime = string.format("%.1f", _trueBearingTime)

		
		--$opportunityTime
		local _opportunityTime = snapshots[spells.opportunity.id].buff:GetRemainingTime(currentTime)
		local opportunityTime = string.format("%.1f", _opportunityTime)

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
		lookup["#dirtyTricks"] = spells.dirtyTricks.icon
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

		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$energyTotal"] = energyTotal
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$energy"] = currentEnergy
		lookup["$resourcePlusCasting"] = energyPlusCasting
		lookup["$resourcePlusPassive"] = energyPlusPassive
		lookup["$resourceTotal"] = energyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentEnergy
		lookup["$casting"] = castingEnergy
		lookup["$comboPoints"] = TRB.Data.character.resource2
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
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		lookup["$inStealth"] = ""
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$energyPlusCasting"] = _energyPlusCasting
		lookupLogic["$energyTotal"] = _energyTotal
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
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
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		lookupLogic["$inStealth"] = ""
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local currentTime = GetTime()
		snapshotData.casting.startTime = currentTime
		snapshotData.casting.resourceRaw = spell.energy
		snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.energy)
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
			if specId == 1 or specId == 2 then
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
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot
		local rollTheBones = TRB.Data.snapshotData.snapshots[spells.rollTheBones.id]
		---@type TRB.Classes.Snapshot[]
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
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots
		local currentTime = GetTime()
		
		snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime)
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
		snapshots[spells.kidneyShot.id].cooldown:Refresh()
		snapshots[spells.shiv.id].cooldown:Refresh()
		snapshots[spells.deathFromAbove.id].cooldown:Refresh()
		snapshots[spells.dismantle.id].cooldown:Refresh()
		snapshots[spells.crimsonVial.id].cooldown:Refresh()
	end

	local function UpdateSnapshot_Assassination()
		UpdateSnapshot()
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots
		local currentTime = GetTime()

		snapshots[spells.improvedGarrote.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.blindside.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.sepsis.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.subterfuge.id].buff:GetRemainingTime(currentTime)

		snapshots[spells.serratedBoneSpike.id].cooldown:Refresh()
		snapshots[spells.exsanguinate.id].cooldown:Refresh()
		snapshots[spells.garrote.id].cooldown:Refresh()
		snapshots[spells.kingsbane.id].cooldown:Refresh()
	end

	local function UpdateSnapshot_Outlaw()
		UpdateSnapshot()
		UpdateRollTheBones()
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots

		snapshots[spells.bladeRush.id].cooldown:Refresh()
		snapshots[spells.bladeFlurry.id].cooldown:Refresh()
		snapshots[spells.betweenTheEyes.id].cooldown:Refresh()
		snapshots[spells.dreadblades.id].cooldown:Refresh()
		snapshots[spells.ghostlyStrike.id].cooldown:Refresh()
		snapshots[spells.gouge.id].cooldown:Refresh()
		snapshots[spells.rollTheBones.id].cooldown:Refresh()
	end

	local function UpdateSnapshot_Subtlety()
		UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.rogue
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]

		if specId == 1 then
			local specSettings = classSettings.assassination
			UpdateSnapshot_Assassination()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if specSettings.generation.enabled then
							if specSettings.generation.mode == "time" then
								passiveValue = (snapshotData.attributes.energyRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (snapshotData.attributes.energyRegen * ((specSettings.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = snapshotData.attributes.resource + snapshotData.casting.resourceFinal
					else
						castingBarValue = snapshotData.attributes.resource
					end

					if castingBarValue < snapshotData.attributes.resource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, snapshotData.attributes.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, snapshotData.attributes.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, snapshotData.attributes.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local energyAmount = CalculateAbilityResourceValue(spell.energy, spell.nimbleFingers, spell.rushedSetup, spell.comboPoints)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
								if spell.id == spells.ambush.id then		
									if snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.sepsis.id].buff.isActive then
										if snapshotData.attributes.resource >= -energyAmount then
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
								elseif snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.sepsis.id].buff.isActive then
									if snapshotData.attributes.resource >= -energyAmount then
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
									if spell.id == spells.exsanguinate.id then
										if not talents:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif not IsTargetBleeding(snapshotData.targetData.currentTargetGuid) or snapshots[spell.id].cooldown:IsUnusable() then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif snapshotData.attributes.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == spells.shiv.id then
										if not talents:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif talents:IsTalentActive(spells.tinyToxicBlade) then -- Don't show this threshold
											showThreshold = false
										elseif snapshots[spell.id].cooldown.charges == 0 then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif snapshotData.attributes.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == spells.sliceAndDice.id then
										if snapshotData.attributes.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end

										if snapshots[spell.id].buff:GetRemainingTime(currentTime) > spells.sliceAndDice.pandemicTimes[snapshotData.attributes.resource2 + 1] then
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
											elseif snapshotData.attributes.resource >= -energyAmount then
												thresholdColor = specSettings.colors.threshold.over
											else
												thresholdColor = specSettings.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									end
								elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
									showThreshold = false
								elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif spell.hasCooldown then
									if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif snapshotData.attributes.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else -- This is an active/available/normal spell threshold
									if snapshotData.attributes.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end

							if spell.comboPoints == true and snapshotData.attributes.resource2 == 0 then
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
						elseif sadTime < spells.sliceAndDice.pandemicTimes[snapshotData.attributes.resource2 + 1] then
							barColor = specSettings.colors.bar.sliceAndDicePandemic
						end
					end

					local barBorderColor = specSettings.colors.bar.border
					if IsStealthed() or snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.sepsis.id].buff.isActive then
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
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if specSettings.generation.enabled then
							if specSettings.generation.mode == "time" then
								passiveValue = (snapshotData.attributes.energyRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (snapshotData.attributes.energyRegen * ((specSettings.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = snapshotData.attributes.resource + snapshotData.casting.resourceFinal
					else
						castingBarValue = snapshotData.attributes.resource
					end

					if castingBarValue < snapshotData.attributes.resource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, snapshotData.attributes.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, snapshotData.attributes.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, snapshotData.attributes.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then	
							local energyAmount = CalculateAbilityResourceValue(spell.energy, spell.nimbleFingers, spell.rushedSetup, spell.comboPoints)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
								if spell.id == spells.ambush.id then
									if snapshots[spells.sepsis.id].buff.isActive then
										if snapshotData.attributes.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									else
										showThreshold = false
									end
								elseif snapshots[spells.sepsis.id].buff.isActive then
									if snapshotData.attributes.resource >= -energyAmount then
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
										if snapshotData.attributes.resource >= -energyAmount then
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
										if snapshots[spells.opportunity.id].buff.isActive then
											energyAmount = energyAmount * spells.opportunity.energyModifier
											TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)
										end

										if snapshotData.attributes.resource >= -energyAmount then
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
										elseif snapshotData.attributes.resource >= -energyAmount then
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
										if snapshotData.attributes.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end

										if snapshots[spells.sliceAndDice.id].buff:GetRemainingTime(currentTime) > spells.sliceAndDice.pandemicTimes[snapshotData.attributes.resource2 + 1] then
											frameLevel = TRB.Data.constants.frameLevels.thresholdBase
										else
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										end
									end
								elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
									showThreshold = false
								elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif spell.hasCooldown then
									if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif snapshotData.attributes.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else -- This is an active/available/normal spell threshold
									if snapshotData.attributes.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end

							if spell.comboPoints == true and snapshotData.attributes.resource2 == 0 then
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
						elseif sadTime < spells.sliceAndDice.pandemicTimes[snapshotData.attributes.resource2 + 1] then
							barColor = specSettings.colors.bar.sliceAndDicePandemic
						end
					end

					local barBorderColor = specSettings.colors.bar.border

					if IsStealthed() or snapshots[spells.sepsis.id].buff.isActive then
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
		end
	end

	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "assassination" then --Assassination
					if spellId == spells.exsanguinate.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.blindside.id then
						snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.rogue.assassination.audio.blindside.enabled then
								PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == spells.subterfuge.id then
						snapshots[spellId].buff:Initialize(type, true)
					elseif spellId == spells.garrote.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" then
								if not((talents:IsTalentActive(spells.subterfuge) and IsStealthed()) or snapshots[spells.subterfuge.id].buff.isActive) then
									snapshots[spellId].cooldown:Initialize()
								end

								if snapshots[spells.improvedGarrote.id].attributes.isActiveStealth or snapshots[spells.improvedGarrote.id].attributes.isActiveStealth then									
									snapshots[spellId].cooldown:Reset()
								end
							end
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.rupture.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.internalBleeding.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.crimsonTempest.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.deadlyPoison.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.amplifyingPoison.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.kingsbane.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.serratedBoneSpike.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.serratedBoneSpike.debuffId then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.crimsonVial.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.improvedGarrote.stealthBuffId then
						snapshots[spells.improvedGarrote.id].buff:Initialize(type, true)
					elseif spellId == spells.improvedGarrote.buffId then
						snapshots[spells.improvedGarrote.id].buff:Initialize(type)
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "outlaw" then
					if spellId == spells.betweenTheEyes.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.bladeFlurry.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.dreadblades.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.ghostlyStrike.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.gouge.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.rollTheBones.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.opportunity.id then
						snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.rogue.outlaw.audio.opportunity.enabled then
								PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.opportunity.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == spells.broadside.id or spellId == spells.buriedTreasure.id or spellId == spells.grandMelee.id or spellId == spells.ruthlessPrecision.id or spellId == spells.skullAndCrossbones.id or spellId == spells.trueBearing.id then
						snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if snapshots[spellId].buff.duration > spells.countTheOdds.duration then
								snapshots[spellId].attributes.fromCountTheOdds = false
							else
								snapshots[spellId].attributes.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then
							snapshots[spellId].attributes.fromCountTheOdds = false
						end
					elseif spellId == spells.keepItRolling.id then
						if type == "SPELL_CAST_SUCCESS" then
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
				end

				-- Spec agnostic
				if spellId == spells.crimsonVial.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.sliceAndDice.id then
					snapshots[spellId].buff:Initialize(type)
				elseif spellId == spells.distract.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.feint.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.kidneyShot.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.shiv.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.adrenalineRush.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" then -- For right now, just redo the CheckCharacter() to get update Energy values
						TRB.Functions.Class:CheckCharacter()
					end
				elseif spellId == spells.echoingReprimand.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.echoingReprimand_2CP.id or spellId == spells.echoingReprimand_3CP.id or spellId == spells.echoingReprimand_4CP.id or spellId == spells.echoingReprimand_4CP2.id or spellId == spells.echoingReprimand_5CP.id then
					snapshots[spellId].buff:Initialize(type)
				elseif spellId == spells.sepsis.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.sepsis.buffId then
					snapshots[spellId].buff:Initialize(type)
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
						if TRB.Data.settings.rogue.assassination.audio.sepsis.enabled then
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end
				elseif spellId == spells.cripplingPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
					end
				elseif spellId == spells.woundPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
					end
				elseif spellId == spells.numbingPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
					end
				elseif spellId == spells.atrophicPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
					end
				elseif spellId == spells.deathFromAbove.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif spellId == spells.dismantle.id then
					if type == "SPELL_CAST_SUCCESS" then
						snapshots[spellId].cooldown:Initialize()
					end
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				targetData:Remove(destGUID)
				RefreshTargetTracking()
				triggerUpdate = true
			end

			if UnitIsDeadOrGhost("player") then -- We died/are dead go ahead and purge the list
				TargetsCleanup(true)
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
			
			local spells = TRB.Data.spells
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
			
			local spells = TRB.Data.spells
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

					local settings = TRB.Options.Rogue.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options:PortForwardSettings()
						TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
					else
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
							--TRB.Data.settings.rogue.subtlety = TRB.Functions.LibSharedMedia:ValidateLsmValues("Subtlety Rogue", TRB.Data.settings.rogue.subtlety)
							
							FillSpellData_Assassination()
							FillSpellData_Outlaw()
							--FillSpellData_Subtlety()
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
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
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
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
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
		local spells = TRB.Data.spells
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.rogue.assassination
		elseif specId == 2 then
			settings = TRB.Data.settings.rogue.outlaw
		else
			return false
		end

		if specId == 1 then --Assassination
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
					target.spells[spells.shadowWordPain.id].remainingTime > 0 then
					valid = true
				end
			-- Other abilities
			elseif var == "$blindsideTime" then
				if snapshots[spells.blindside.id].buff.isActive then
					valid = true
				end
			end
		elseif specId == 2 then --Outlaw
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
		--[[elseif specId == 3 then --Survivial]]
		end

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
		elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
			if snapshotData.attributes.resource < TRB.Data.character.maxResource and
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
		elseif var == "$sbsCount" or var == "$serratedBoneSpikeCount" then
			if snapshotData.targetData.count[spells.serratedBoneSpike.debuffId] > 0 then
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

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 then
			TRB.Functions.Bar:HideResourceBar(true)
			return
		end

		local currentTime = GetTime()

		if updateRateLimit + 0.05 < currentTime then
			updateRateLimit = currentTime
			UpdateResourceBar()
		end
	end
end