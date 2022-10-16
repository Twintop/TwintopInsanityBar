local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 4 then --Only do this if we're on a Rogue!
	local barContainerFrame = TRB.Frames.barContainerFrame
    local resource2Frame = TRB.Frames.resource2Frame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
    local combatFrame = TRB.Frames.combatFrame

	Global_TwintopResourceBar = {}
	TRB.Data.character = {}

	local specCache = {
		assassination = {
			snapshotData = {},
			barTextVariables = {
				icons = {},
				values = {}
			},
			spells = {},
			talents = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		},
		outlaw = {
			snapshotData = {},
			barTextVariables = {
				icons = {},
				values = {}
			},
			spells = {},
			talents = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		}
	}

	local function FillSpecCache()
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
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
            maxResource2 = 5,
			effects = {
				overgrowthSeedling = 1.0,
				nimbleFingersReduction = 0,
				rushedSetupModifier = 0
			},
			items = {
				tinyToxicBlade = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
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
                --isSnowflake = true,
				thresholdUsable = false,
				isBaseline = true
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
				--isSnowflake = false,
				rushedSetup = true,
				thresholdUsable = false,
				isBaseline = true
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
				isBaseline = true
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
				isBaseline = true
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
				isBaseline = true
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
					42 * 0.3
				},
				isBaseline = true
			},

			--Rogue Talent Abilities
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 1,
				texture = "",
				thresholdId = 7,
				settingKey = "shiv",
                hasCooldown = true,
				isSnowflake = true,
                cooldown = 25,
				thresholdUsable = false,
				idLegendaryBonus = 7112,
				isTalent = true,
				isBaseline = true
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
                stealth = true,
				texture = "",
				thresholdId = 8,
				settingKey = "sap",
				rushedSetup = true,
				thresholdUsable = false,
				isTalent = true
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
				texture = "",
				thresholdId = 9,
				settingKey = "feint",
                hasCooldown = true,
                cooldown = 15,
				nimbleFingers = true,
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
				isActive = false,
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
				isSnowflake = true,
				thresholdUsable = false,
				isActive = false,
				cooldown = 45,
				buffId = {
					323558, -- 2
					323559, -- 3
					323560, -- 4
					354835, -- 4
					354838, -- 5
				}
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
                hasCooldown = false,
				thresholdUsable = false,
				isBaseline = true
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
                hasCooldown = false,
				thresholdUsable = false,
				isBaseline = true
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
				isBaseline = true
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
                hasCooldown = false,
				thresholdUsable = false,
				isBaseline = true
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
                hasCooldown = false,
				thresholdUsable = false,
				isBaseline = true
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
                hasCooldown = false,
				thresholdUsable = false,
				pandemicTimes = {
					8 * 0.3, -- 0 CP, show same as if we had 1
					8 * 0.3,
					12 * 0.3,
					16 * 0.3,
					20 * 0.3,
					24 * 0.3,
					28 * 0.3,
					32 * 0.3, -- 7 CP Kyrian ability buff
				},
				isBaseline = true
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
				energy = -35,
				comboPoints = true,
				texture = "",
				thresholdId = 18,
				settingKey = "crimsonTempest",
				hasCooldown = false,
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
				isActive = false,
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
				isSnowflake = true,
				debuffId = 324073,
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
				isSnowflake = true,
				cooldown = 90,
				buffId = 375939,
				isActive = false,
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

			-- Conduits
			nimbleFingersConduit = {
				id = 341311,
				name = "",
				icon = "",
				conduitId = 230,
				conduitRanks = {}
			},
			rushedSetupConduit = {
				id = 341534,
				name = "",
				icon = "",
				conduitId = 235,
				conduitRanks = {}
			},

			adrenalineRush = {
				id = 13750,
				name = "",
				icon = "",
			},
		}

		specCache.assassination.snapshotData.energyRegen = 0
		specCache.assassination.snapshotData.comboPoints = 0
		specCache.assassination.snapshotData.audio = {
			overcapCue = false
		}
		specCache.assassination.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			--Bleeds
			garrote = 0,
			rupture = 0,
			internalBleeding = 0,
			crimsonTempest = 0,
			serratedBoneSpike = 0,
			--Poisons
			deadlyPoison = 0,
			cripplingPoison = 0,
			woundPoison = 0,
			numbingPoison = 0,
			atrophicPoison = 0,
			amplifyingPoison = 0,
			targets = {}
		}
		specCache.assassination.snapshotData.crimsonVial = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.distract = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.feint = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.kidneyShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.shiv = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.outlaw.snapshotData.gouge = {
			startTime = nil,
			duration = 0
		}
		specCache.assassination.snapshotData.garrote = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.exsanguinate = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.blindside = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.assassination.snapshotData.sliceAndDice = {
			spellId = nil,
			endTime = nil
		}
		specCache.assassination.snapshotData.kingsbane = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}

		specCache.assassination.snapshotData.echoingReprimand = {
			startTime = nil,
			duration = 0,
		}
		for x = 1, 6 do -- 1 and 6 CPs doesn't get it, but including it just in case it gets added/changed
			specCache.assassination.snapshotData.echoingReprimand[x] = {
				endTime = nil,
				duration = 0,
				enabled = false,
				comboPoints = 0
			}
		end
		
		specCache.assassination.snapshotData.sepsis = {
			startTime = nil,
			endTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.serratedBoneSpike = {
			isActive = false,
			-- Charges
			charges = 0,
			startTime = nil,
			duration = 0
		}
		
		specCache.assassination.snapshotData.deathFromAbove = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.dismantle = {
			startTime = nil,
			duration = 0,
			enabled = false
		}

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
				overgrowthSeedling = 1.0
			},
			items = {
				tinyToxicBlade = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
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
                --isSnowflake = true,
				thresholdUsable = false,
				isBaseline = true
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
				--isSnowflake = false,
				rushedSetup = true,
				thresholdUsable = false,
				isBaseline = true
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
				isBaseline = true
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
				isBaseline = true
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
				isBaseline = true
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
					42 * 0.3
				},
				isBaseline = true
			},

			--Rogue Talent Abilities
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 1,
				texture = "",
				thresholdId = 7,
				settingKey = "shiv",
                hasCooldown = true,
				isSnowflake = true,
                cooldown = 25,
				thresholdUsable = false,
				idLegendaryBonus = 7112,
				isTalent = true,
				isBaseline = true
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
                stealth = true,
				texture = "",
				thresholdId = 8,
				settingKey = "sap",
				rushedSetup = true,
				thresholdUsable = false,
				isTalent = true
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
				texture = "",
				thresholdId = 9,
				settingKey = "feint",
                hasCooldown = true,
                cooldown = 15,
				nimbleFingers = true,
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
				isActive = false,
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
				isSnowflake = true,
				thresholdUsable = false,
				isActive = false,
				cooldown = 45,
				buffId = {
					323558, -- 2
					323559, -- 3
					323560, -- 4
					354835, -- 4
					354838, -- 5
				}
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
				restlessBlades=true,
				isBaseline = true
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
				isBaseline = true
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
				isBaseline = true
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
				isBaseline = true
			},
			opportunity = {
				id = 195627,
				name = "",
				icon = "",
				isActive = false,
				energyModifier = 0.5,
				isBaseline = true,
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
				restlessBlades=true,
				isBaseline = true,
				isTalent = true
			},

			-- Outlaw Spec Abilities
			adrenalineRush = {
				id = 13750,
				name = "",
				icon = "",
				restlessBlades=true,
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
				isTalent = true,
				isActive = false
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
				restlessBlades=true
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
				isSnowflake = true,
				cooldown = 90,
				buffId = 375939,
				isActive = false,
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
				restlessBlades=true
			},
			bladeRush = {
				id = 271877,
				name = "",
				icon = "",
				isTalent = true,
				energy = 25,
                duration = 5,
				cooldown = 45
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
				cooldown = 90
			},
			-- TODO: Implement this!
			keepItRolling = {
				id = 381989,
				name = "",
				icon = "",
				isTalent = true,
				cooldown = 60 * 7
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

			-- Conduits
			nimbleFingersConduit = {
				id = 341311,
				name = "",
				icon = "",
				conduitId = 230,
				conduitRanks = {}
			},
			rushedSetupConduit = {
				id = 341534,
				name = "",
				icon = "",
				conduitId = 235,
				conduitRanks = {}
			},
			countTheOddsConduit = {
				id = 341546,
				name = "",
				icon = "",
				duration = 5
			},
		}

		specCache.outlaw.snapshotData.energyRegen = 0
		specCache.outlaw.snapshotData.comboPoints = 0
		specCache.outlaw.snapshotData.audio = {
			overcapCue = false
		}
		specCache.outlaw.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			--Poisons
			cripplingPoison = 0,
			woundPoison = 0,
			numbingPoison = 0,
			targets = {}
		}
		specCache.outlaw.snapshotData.crimsonVial = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.distract = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.feint = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.kidneyShot = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.shiv = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.gouge = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.betweenTheEyes = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.bladeFlurry = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.bladeRush = {
			spellId = nil,
			endTime = nil,
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.ghostlyStrike = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.dreadblades = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.sliceAndDice = {
			spellId = nil,
			endTime = nil
		}
		specCache.outlaw.snapshotData.opportunity = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}

		specCache.outlaw.snapshotData.echoingReprimand = {
			startTime = nil,
			duration = 0,
		}
		for x = 1, 6 do -- 1 and 6 CPs doesn't get it, but including it just in case it gets added/changed
			specCache.outlaw.snapshotData.echoingReprimand[x] = {
				endTime = nil,
				duration = 0,
				enabled = false,
				comboPoints = 0
			}
		end
		
		specCache.outlaw.snapshotData.sepsis = {
			startTime = nil,
			endTime = nil,
			duration = 0,
			enabled = false
		}

		specCache.outlaw.snapshotData.deathFromAbove = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.dismantle = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.rollTheBones = {
			buffs = {
				broadside = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				buriedTreasure = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				grandMelee = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				ruthlessPrecision = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				skullAndCrossbones = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				trueBearing = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				}
			},
			count = 0,
			temporaryCount = 0,
			startTime = nil,
			duration = 0,
			goodBuffs = false,
			remaining = 0
		}

		specCache.outlaw.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Assassination()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "rogue", "assassination")
		TRB.Functions.LoadFromSpecCache(specCache.assassination)
	end

	local function Setup_Outlaw()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "rogue", "outlaw")
		TRB.Functions.LoadFromSpecCache(specCache.outlaw)
	end

	local function FillSpellData_Assassination()
		Setup_Assassination()
		local spells = TRB.Functions.FillSpellData(specCache.assassination.spells)
		
		-- Conduit Ranks
		spells.nimbleFingersConduit.conduitRanks[0] = 0
		spells.nimbleFingersConduit.conduitRanks[1] = 5
		spells.nimbleFingersConduit.conduitRanks[2] = 6
		spells.nimbleFingersConduit.conduitRanks[3] = 7
		spells.nimbleFingersConduit.conduitRanks[4] = 8
		spells.nimbleFingersConduit.conduitRanks[5] = 9
		spells.nimbleFingersConduit.conduitRanks[6] = 10
		spells.nimbleFingersConduit.conduitRanks[7] = 11
		spells.nimbleFingersConduit.conduitRanks[8] = 12
		spells.nimbleFingersConduit.conduitRanks[9] = 13
		spells.nimbleFingersConduit.conduitRanks[10] = 14
		spells.nimbleFingersConduit.conduitRanks[11] = 15
		spells.nimbleFingersConduit.conduitRanks[12] = 16
		spells.nimbleFingersConduit.conduitRanks[13] = 17
		spells.nimbleFingersConduit.conduitRanks[14] = 18
		spells.nimbleFingersConduit.conduitRanks[15] = 19

		spells.rushedSetupConduit.conduitRanks[0] = 0
		spells.rushedSetupConduit.conduitRanks[1] = 0.2
		spells.rushedSetupConduit.conduitRanks[2] = 0.22
		spells.rushedSetupConduit.conduitRanks[3] = 0.24
		spells.rushedSetupConduit.conduitRanks[4] = 0.26
		spells.rushedSetupConduit.conduitRanks[5] = 0.28
		spells.rushedSetupConduit.conduitRanks[6] = 0.3
		spells.rushedSetupConduit.conduitRanks[7] = 0.32
		spells.rushedSetupConduit.conduitRanks[8] = 0.34
		spells.rushedSetupConduit.conduitRanks[9] = 0.36
		spells.rushedSetupConduit.conduitRanks[10] = 0.38
		spells.rushedSetupConduit.conduitRanks[11] = 0.4
		spells.rushedSetupConduit.conduitRanks[12] = 0.42
		spells.rushedSetupConduit.conduitRanks[13] = 0.44
		spells.rushedSetupConduit.conduitRanks[14] = 0.46
		spells.rushedSetupConduit.conduitRanks[15] = 0.48

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
			{ variable = "$dVers", description = "Current Versatilit y% (damage reduction/defensive)", printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = "Current Versatility % (damage reduction/defensive)", printInSettings = false, color = false },
			{ variable = "$versRating", description = "Current Versatility rating", printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = "Current Versatility rating", printInSettings = false, color = false },

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
		
			{ variable = "$sbsCount", description = "Number of Serrated Bone Spike bleeds active on targets (if |cFF40BF40Necrolord|r)", printInSettings = true, color = false },
			{ variable = "$serratedBoneSpikeCount", description = "Number of Serrated Bone Spike bleeds active on targets (if |cFF40BF40Necrolord|r)", printInSettings = false, color = false },

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
		local spells = TRB.Functions.FillSpellData(specCache.outlaw.spells)

		-- Conduit Ranks
		spells.nimbleFingersConduit.conduitRanks[0] = 0
		spells.nimbleFingersConduit.conduitRanks[1] = 5
		spells.nimbleFingersConduit.conduitRanks[2] = 6
		spells.nimbleFingersConduit.conduitRanks[3] = 7
		spells.nimbleFingersConduit.conduitRanks[4] = 8
		spells.nimbleFingersConduit.conduitRanks[5] = 9
		spells.nimbleFingersConduit.conduitRanks[6] = 10
		spells.nimbleFingersConduit.conduitRanks[7] = 11
		spells.nimbleFingersConduit.conduitRanks[8] = 12
		spells.nimbleFingersConduit.conduitRanks[9] = 13
		spells.nimbleFingersConduit.conduitRanks[10] = 14
		spells.nimbleFingersConduit.conduitRanks[11] = 15
		spells.nimbleFingersConduit.conduitRanks[12] = 16
		spells.nimbleFingersConduit.conduitRanks[13] = 17
		spells.nimbleFingersConduit.conduitRanks[14] = 18
		spells.nimbleFingersConduit.conduitRanks[15] = 19

		spells.rushedSetupConduit.conduitRanks[0] = 0
		spells.rushedSetupConduit.conduitRanks[1] = 0.2
		spells.rushedSetupConduit.conduitRanks[2] = 0.22
		spells.rushedSetupConduit.conduitRanks[3] = 0.24
		spells.rushedSetupConduit.conduitRanks[4] = 0.26
		spells.rushedSetupConduit.conduitRanks[5] = 0.28
		spells.rushedSetupConduit.conduitRanks[6] = 0.3
		spells.rushedSetupConduit.conduitRanks[7] = 0.32
		spells.rushedSetupConduit.conduitRanks[8] = 0.34
		spells.rushedSetupConduit.conduitRanks[9] = 0.36
		spells.rushedSetupConduit.conduitRanks[10] = 0.38
		spells.rushedSetupConduit.conduitRanks[11] = 0.4
		spells.rushedSetupConduit.conduitRanks[12] = 0.42
		spells.rushedSetupConduit.conduitRanks[13] = 0.44
		spells.rushedSetupConduit.conduitRanks[14] = 0.46
		spells.rushedSetupConduit.conduitRanks[15] = 0.48

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
			{ variable = "$dVers", description = "Current Versatilit y% (damage reduction/defensive)", printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = "Current Versatility % (damage reduction/defensive)", printInSettings = false, color = false },
			{ variable = "$versRating", description = "Current Versatility rating", printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = "Current Versatility rating", printInSettings = false, color = false },

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

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.outlaw.spells = spells
	end

	local function CheckCharacter()
		local specId = GetSpecialization()
---@diagnostic disable-next-line: missing-parameter
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "rogue"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
        local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
        local settings = nil

		if specId == 1 then
            settings = TRB.Data.settings.rogue.assassination
		elseif specId == 2 then
            settings = TRB.Data.settings.rogue.outlaw
		end
        
        if settings ~= nil then
			-- Legendaries
			local waistItemLink = GetInventoryItemLink("player", 6)
			local feetItemLink = GetInventoryItemLink("player", 8)

			local tinyToxicBlade = false
			if waistItemLink ~= nil then
				tinyToxicBlade = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(waistItemLink, 172320, TRB.Data.spells.shiv.idLegendaryBonus)
			end

			if tinyToxicBlade == false and waistItemLink ~= nil then
				tinyToxicBlade = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(feetItemLink, 173244, TRB.Data.spells.shiv.idLegendaryBonus)
			end
			TRB.Data.character.items.tinyToxicBlade = tinyToxicBlade

			TRB.Data.character.effects.nimbleFingersConduitReduction = TRB.Data.spells.nimbleFingersConduit.conduitRanks[TRB.Functions.GetSoulbindEquippedConduitRank(TRB.Data.spells.nimbleFingersConduit.conduitId)]
			TRB.Data.character.effects.rushedSetupConduitModifier = 1 - TRB.Data.spells.rushedSetupConduit.conduitRanks[TRB.Functions.GetSoulbindEquippedConduitRank(TRB.Data.spells.rushedSetupConduit.conduitId)]
			TRB.Data.character.isPvp = TRB.Functions.ArePvpTalentsActive()
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
            	TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
			end
        end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.rogue.assassination == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
			TRB.Data.specSupported = true
		elseif specId == 2 and TRB.Data.settings.core.enabled.rogue.outlaw == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.outlaw)
			TRB.Data.specSupported = true
		else
			--TRB.Data.resource = MANA
			TRB.Data.specSupported = false
			targetsTimerFrame:SetScript("OnUpdate", nil)
			timerFrame:SetScript("OnUpdate", nil)
			barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = false
			barContainerFrame:Hide()
		end

		if TRB.Data.specSupported then
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.ComboPoints
			TRB.Data.resource2Factor = 1

            CheckCharacter()

			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		end
		TRB.Functions.HideResourceBar()
	end
	TRB.Functions.EventRegistration = EventRegistration

	local function IsTargetBleeding(guid)
		if guid == nil then
			guid = TRB.Data.snapshotData.targetData.currentTargetGuid
		end

		if TRB.Data.snapshotData.targetData.targets[guid] == nil then
			return false
		end

		local specId = GetSpecialization()

		if specId == 1 then -- Assassination
			return TRB.Data.snapshotData.targetData.targets[guid].garrote or TRB.Data.snapshotData.targetData.targets[guid].rupture or TRB.Data.snapshotData.targetData.targets[guid].internalBleeding or TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest
		end
		return false
	end
	
	local function GetSliceAndDiceRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.sliceAndDice)
	end

	local function GetBlindsideRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.blindside)
	end

	local function GetOpportunityRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.opportunity)
	end
	
    local function CalculateAbilityResourceValue(resource, threshold, nimbleFingers, rushedSetup)
        local modifier = 1.0

		-- TODO: validate how Nimble Fingers reduces energy costs. Is it before or after percentage modifiers? Assuming before for now
		if nimbleFingers == true then
			resource = resource + TRB.Data.character.effects.nimbleFingersConduitReduction
		end

		if rushedSetup == true then
			modifier = modifier * TRB.Data.character.effects.rushedSetupConduitModifier
		end

		modifier = modifier * TRB.Data.character.effects.overgrowthSeedlingModifier * TRB.Data.character.torghast.rampaging.spellCostModifier

        return resource * modifier
    end
	
	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()
		
		if guid ~= nil and guid ~= "" then
			if not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
				if specId == 1 then
					--Bleeds
					TRB.Data.snapshotData.targetData.targets[guid].garrote = false
					TRB.Data.snapshotData.targetData.targets[guid].garroteRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].rupture = false
					TRB.Data.snapshotData.targetData.targets[guid].ruptureRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].internalBleeding = false
					TRB.Data.snapshotData.targetData.targets[guid].internalBleedingRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest = false
					TRB.Data.snapshotData.targetData.targets[guid].crimsonTempestRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].serratedBoneSpike = false
					--Poisons
					TRB.Data.snapshotData.targetData.targets[guid].amplifyingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].amplifyingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].atrophicPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].atrophicPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].deadlyPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].deadlyPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].woundPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoisonRemaining = 0
				elseif specId == 2 then
					--Poisons
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].woundPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoisonRemaining = 0
				end
			end
			TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()
			return true
		end
		return false
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget


	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
        
		if specId == 1 then -- Assassination
			-- Bleeds
			local crimsonTempestTotal = 0
			local garroteTotal = 0
			local internalBleedingTotal = 0
			local ruptureTotal = 0
			local serratedBoneSpikeTotal = 0
			-- Poisons
			local amplifyingPoisonTotal = 0
			local atrophicPoisonTotal = 0
			local cripplingPoisonTotal = 0
			local deadlyPoisonTotal = 0
			local numbingPoisonTotal = 0
			local woundPoisonTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 20 then
					-- Bleeds
					TRB.Data.snapshotData.targetData.targets[guid].garrote = false
					TRB.Data.snapshotData.targetData.targets[guid].garroteRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].rupture = false
					TRB.Data.snapshotData.targetData.targets[guid].ruptureRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].internalBleeding = false
					TRB.Data.snapshotData.targetData.targets[guid].internalBleedingRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest = false
					TRB.Data.snapshotData.targetData.targets[guid].crimsonTempestRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].serratedBoneSpike = false
					-- Poisons
					TRB.Data.snapshotData.targetData.targets[guid].amplifyingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].amplifyingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].atrophicPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].atrophicPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].deadlyPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].deadlyPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].woundPoisonRemaining = 0
				else
					-- Bleeds
					if TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest == true then
						crimsonTempestTotal = crimsonTempestTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].garrote == true then
						garroteTotal = garroteTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].internalBleeding == true then
						internalBleedingTotal = internalBleedingTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].rupture == true then
						ruptureTotal = ruptureTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].serratedBoneSpike == true then
						serratedBoneSpikeTotal = serratedBoneSpikeTotal + 1
					end
					-- Poisons
					if TRB.Data.snapshotData.targetData.targets[guid].amplifyingPoison == true then
						amplifyingPoisonTotal = amplifyingPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].atrophicPoison == true then
						atrophicPoisonTotal = atrophicPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison == true then
						cripplingPoisonTotal = cripplingPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].deadlyPoison == true then
						deadlyPoisonTotal = deadlyPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].numbingPoison == true then
						numbingPoisonTotal = numbingPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].woundPoison == true then
						woundPoisonTotal = woundPoisonTotal + 1
					end
				end
			end
			--Bleeds
			TRB.Data.snapshotData.targetData.crimsonTempest = crimsonTempestTotal
			TRB.Data.snapshotData.targetData.garrote = garroteTotal
			TRB.Data.snapshotData.targetData.internalBleeding = internalBleedingTotal
			TRB.Data.snapshotData.targetData.rupture = ruptureTotal
			TRB.Data.snapshotData.targetData.serratedBoneSpike = serratedBoneSpikeTotal
			--Poisons
			TRB.Data.snapshotData.targetData.amplifyingPoison = amplifyingPoisonTotal
			TRB.Data.snapshotData.targetData.atrophicPoison = atrophicPoisonTotal
			TRB.Data.snapshotData.targetData.cripplingPoison = cripplingPoisonTotal
			TRB.Data.snapshotData.targetData.deadlyPoison = deadlyPoisonTotal
			TRB.Data.snapshotData.targetData.numbingPoison = numbingPoisonTotal
			TRB.Data.snapshotData.targetData.woundPoison = woundPoisonTotal
		elseif specId == 2 then -- Outlaw
			-- Poisons
			local cripplingPoisonTotal = 0
			local woundPoisonTotal = 0
			local numbingPoisonTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 20 then
					-- Poisons
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].woundPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoisonRemaining = 0
				else
					-- Poisons
					if TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison == true then
						cripplingPoisonTotal = cripplingPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].woundPoison == true then
						woundPoisonTotal = woundPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].numbingPoison == true then
						numbingPoisonTotal = numbingPoisonTotal + 1
					end
				end
			end
			--Poisons
			TRB.Data.snapshotData.targetData.cripplingPoison = cripplingPoisonTotal
			TRB.Data.snapshotData.targetData.woundPoison = woundPoisonTotal
			TRB.Data.snapshotData.targetData.numbingPoison = numbingPoisonTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 1 then
				--Bleeds
				TRB.Data.snapshotData.targetData.crimsonTempest = 0
				TRB.Data.snapshotData.targetData.internalBleeding = 0
				TRB.Data.snapshotData.targetData.garrote = 0
				TRB.Data.snapshotData.targetData.rupture = 0
				TRB.Data.snapshotData.targetData.serratedBoneSpike = 0
				--Poisons
				TRB.Data.snapshotData.targetData.atrophicPoison = 0
				TRB.Data.snapshotData.targetData.amplifyingPoison = 0
				TRB.Data.snapshotData.targetData.cripplingPoison = 0
				TRB.Data.snapshotData.targetData.deadlyPoison = 0
				TRB.Data.snapshotData.targetData.numbingPoison = 0
				TRB.Data.snapshotData.targetData.woundPoison = 0
			elseif specId == 2 then
				--Poisons
				TRB.Data.snapshotData.targetData.atrophicPoison = 0
				TRB.Data.snapshotData.targetData.cripplingPoison = 0
				TRB.Data.snapshotData.targetData.woundPoison = 0
				TRB.Data.snapshotData.targetData.numbingPoison = 0
			end
		end
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		local entries = TRB.Functions.TableLength(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end

        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
				if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
				TRB.Functions.SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell.settingKey, settings)

				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
            end
        end
		TRB.Frames.resource2ContainerFrame:Show()

		TRB.Functions.ConstructResourceBar(settings)
		
		if specId == 1 or specId == 2 then
			TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
		end
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.rogue.assassination
		elseif specId == 2 then
			settings = TRB.Data.settings.rogue.outlaw
		end

		if specId == 1 then --Assassination
			-- Bleeds
			if var == "$isBleeding" then
				if IsTargetBleeding() then
					valid = true
				end
			elseif var == "$ctCount" or var == "$crimsonTempestCount" then
				if TRB.Data.snapshotData.targetData.crimsonTempest > 0 then
					valid = true
				end
			elseif var == "$ctTime" or var == "$crimsonTempestTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempestRemaining > 0 then
					valid = true
				end
			elseif var == "$garroteCount" then
				if TRB.Data.snapshotData.targetData.garrote > 0 then
					valid = true
				end
			elseif var == "$garroteTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garroteRemaining > 0 then
					valid = true
				end
			elseif var == "$ibCount" or var == "$internalBleedingCount" then
				if TRB.Data.snapshotData.targetData.internalBleeding > 0 then
					valid = true
				end
			elseif var == "$ibTime" or var == "$internalBleedingTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleedingRemaining > 0 then
					valid = true
				end
			elseif var == "$ruptureCount" then
				if TRB.Data.snapshotData.targetData.rupture > 0 then
					valid = true
				end
			elseif var == "$ruptureTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ruptureRemaining > 0 then
					valid = true
				end
			elseif var == "$dpCount" or var == "$deadlyPoisonCount" then
				if TRB.Data.snapshotData.targetData.deadlyPoison > 0 then
					valid = true
				end
			elseif var == "$dpTime" or var == "$deadlyPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoisonRemaining > 0 then
					valid = true
				end
			elseif var == "$amplifyingPoisonCount" then
				if TRB.Data.snapshotData.targetData.amplifyingPoison > 0 then
					valid = true
				end
			elseif var == "$amplifyingPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].amplifyingPoisonRemaining > 0 then
					valid = true
				end
			-- Other abilities
			elseif var == "$blindsideTime" then
				if TRB.Data.snapshotData.blindside.spellId ~= nil then
					valid = true
				end
			end
		elseif specId == 2 then --Outlaw
			-- Roll the Bones buff counts
			if var == "$rtbCount" or var == "$rollTheBonesCount" then
				if TRB.Data.snapshotData.rollTheBones.count > 0 then
					valid = true
				end
			elseif var == "$rtbTemporaryCount" or var == "$rollTheBonesTemporaryCount" then
				if TRB.Data.snapshotData.rollTheBones.temporaryCount > 0 then
					valid = true
				end
			elseif var == "$rtbAllCount" or var == "$rollTheBonesAllCount" then
				if TRB.Data.snapshotData.rollTheBones.count > 0 or TRB.Data.snapshotData.rollTheBones.temporaryCount > 0 then
					valid = true
				end
			elseif var == "$rtbBuffTime" or var == "$rollTheBonesBuffTime" then
				if TRB.Data.snapshotData.rollTheBones.remaining > 0 then
					valid = true
				end
			-- Roll the Bones Buffs
			elseif var == "$broadsideTime" then
				if TRB.Data.snapshotData.rollTheBones.buffs.broadside.duration > 0 then
					valid = true
				end
			elseif var == "$buriedTreasureTime" then
				if TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.duration > 0 then
					valid = true
				end
			elseif var == "$grandMeleeTime" then
				if TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.duration > 0 then
					valid = true
				end
			elseif var == "$ruthlessPrecisionTime" then
				if TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.duration > 0 then
					valid = true
				end
			elseif var == "$skullAndCrossbonesTime" then
				if TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.duration > 0 then
					valid = true
				end
			elseif var == "$trueBearingTime" then
				if TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.duration > 0 then
					valid = true
				end
			-- Other abilities
			elseif var == "$opportunityTime" then
				if TRB.Data.snapshotData.opportunity.spellId ~= nil then
					valid = true
				end
			elseif var == "$rtbGoodBuff" or var == "$rollTheBonesGoodBuff" then
				if TRB.Data.snapshotData.rollTheBones.goodBuffs == true then
					valid = true
				end
			end
		--[[elseif specId == 3 then --Survivial]]
		end

		if var == "$resource" or var == "$energy" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$energyTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$energyOvercap" or var == "$resourceOvercap" then
			if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
				settings.generation.enabled and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$comboPoints" then
			valid = true
		elseif var == "$comboPointsMax" then
			valid = true
		elseif var == "$sadTime" or var == "$sliceAndDiceTime" then
			if TRB.Data.snapshotData.sliceAndDice.spellId ~= nil then
				valid = true
			end
		elseif var == "$sbsCount" or var == "$serratedBoneSpikeCount" then
			if TRB.Data.snapshotData.targetData.serratedBoneSpike > 0 then
				valid = true
			end
		-- Poisons
		elseif var == "$cpCount" or var == "$cripplingPoisonCount" then
			if TRB.Data.snapshotData.targetData.cripplingPoison > 0 then
				valid = true
			end
		elseif var == "$cpTime" or var == "$cripplingPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoisonRemaining > 0 then
				valid = true
			end
		elseif var == "$npCount" or var == "$numbingPoisonCount" then
			if TRB.Data.snapshotData.targetData.numbingPoison > 0 then
				valid = true
			end
		elseif var == "$npTime" or var == "$numbingPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoisonRemaining > 0 then
				valid = true
			end
		elseif var == "$atrophicPoisonCount" then
			if TRB.Data.snapshotData.targetData.atrophicPoison > 0 then
				valid = true
			end
		elseif var == "$atrophicPoisonPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].atrophicPoisonRemaining > 0 then
				valid = true
			end
		elseif var == "$wpCount" or var == "$woundPoisonCount" then
			if TRB.Data.snapshotData.targetData.woundPoison > 0 then
				valid = true
			end
		elseif var == "$wpTime" or var == "$woundPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoisonRemaining > 0 then
				valid = true
			end
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Assassination()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.current
		local castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.casting

		if TRB.Data.settings.rogue.assassination.colors.text.overcapEnabled and overcap then
			currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overcap
            castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overcap
		elseif TRB.Data.settings.rogue.assassination.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overThreshold
				castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _regenEnergy = 0
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.assassination.generation.enabled then
			if TRB.Data.settings.rogue.assassination.generation.mode == "time" then
				_regenEnergy = TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.rogue.assassination.generation.time or 3.0)
			else
				_regenEnergy = TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.rogue.assassination.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)


		-- Bleeds
		-- TODO: Somehow account for pandemic being variable
		--$ctCount and $ctTime
		local _ctCount = TRB.Data.snapshotData.targetData.crimsonTempest or 0
		local ctCount = tostring(_ctCount)
		local _ctTime = 0
		local ctTime
		
		--$garroteCount and $garroteTime
		local _garroteCount = TRB.Data.snapshotData.targetData.garrote or 0
		local garroteCount = tostring(_garroteCount)
		local _garroteTime = 0
		local garroteTime
		
		--$ibCount and $ibTime
		local _ibCount = TRB.Data.snapshotData.targetData.internalBleeding or 0
		local ibCount = tostring(_ibCount)
		local _ibTime = 0
		local ibTime
		
		--$ruptureCount and $ruptureTime
		local _ruptureCount = TRB.Data.snapshotData.targetData.rupture or 0
		local ruptureCount = tostring(_ruptureCount)
		local _ruptureTime = 0
		local ruptureTime
		
		-- Poisons
		--$cpCount and $cpTime
		local _cpCount = TRB.Data.snapshotData.targetData.cripplingPoison or 0
		local cpCount = tostring(_cpCount)
		local _cpTime = 0
		local cpTime
				
		--$dpCount and $cpTime
		local _dpCount = TRB.Data.snapshotData.targetData.deadlyPoison or 0
		local dpCount = tostring(_dpCount)
		local _dpTime = 0
		local dpTime
				
		--$amplifyingPoisonCount and $amplifyingPoisonTime
		local _amplifyingPoisonCount = TRB.Data.snapshotData.targetData.amplifyingPoison or 0
		local amplifyingPoisonCount = tostring(_amplifyingPoisonCount)
		local _amplifyingPoisonTime = 0
		local amplifyingPoisonTime
				
		--$npCount and $npTime
		local _npCount = TRB.Data.snapshotData.targetData.numbingPoison or 0
		local npCount = tostring(_npCount)
		local _npTime = 0
		local npTime
				
		--$npCount and $npTime
		local _atrophicPoisonCount = TRB.Data.snapshotData.targetData.atrophicPoison or 0
		local atrophicPoisonCount = tostring(_atrophicPoisonCount)
		local _atrophicPoisonTime = 0
		local atrophicPoisonTime
				
		--$wpCount and $wpTime
		local _wpCount = TRB.Data.snapshotData.targetData.woundPoison or 0
		local wpCount = tostring(_wpCount)
		local _wpTime = 0
		local wpTime
		
		--$sbsCount
		local _sbsCount = TRB.Data.snapshotData.targetData.serratedBoneSpike or 0
		local sbsCount = tostring(_sbsCount)
		local _sbsOnTarget = false


		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_ctTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempestRemaining or 0
			_garroteTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garroteRemaining or 0
			_ibTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleedingRemaining or 0
			_ruptureTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ruptureRemaining or 0
			_cpTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoisonRemaining or 0
			_dpTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoisonRemaining or 0
			_npTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoisonRemaining or 0
			_atrophicPoisonTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].atrophicPoisonRemaining or 0
			_amplifyingPoisonTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].amplifyingPoisonRemaining or 0
			_wpTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoisonRemaining or 0
			_sbsOnTarget = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serratedBoneSpike or false
		end


		if TRB.Data.settings.rogue.assassination.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			-- Bleeds
			if _ctTime > TRB.Data.spells.crimsonTempest.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ctTime)
			elseif _ctTime > 0 then
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ctTime)
			else
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _garroteTime > TRB.Data.spells.garrote.pandemicTime then
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _garroteTime)
			elseif _garroteTime > 0 then
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _garroteTime)
			else
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end
						
			if _ibTime > 0 then
				ibCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ibCount)
				ibTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ibTime)
			else
				ibCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ibCount)
				ibTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _ruptureTime > TRB.Data.spells.rupture.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ruptureTime)
			elseif _ruptureTime > 0 then
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ruptureTime)
			else
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			--Poisons
			if _cpTime > 0 then
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _cpTime)
			else
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _dpTime > 0 then
				dpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _dpCount)
				dpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _dpTime)
			else
				dpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _dpCount)
				dpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _npTime > 0 then
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _npTime)
			else
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _wpTime > 0 then
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _wpTime)
			else
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _atrophicPoisonTime > 0 then
				atrophicPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _atrophicPoisonCount)
				atrophicPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _atrophicPoisonTime)
			else
				atrophicPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _atrophicPoisonCount)
				atrophicPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _amplifyingPoisonTime > 0 then
				amplifyingPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _amplifyingPoisonCount)
				amplifyingPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _amplifyingPoisonTime)
			else
				amplifyingPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _amplifyingPoisonCount)
				amplifyingPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _sbsOnTarget == false and TRB.Functions.IsTalentActive(TRB.Data.spells.serratedBoneSpike) then
				sbsCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _sbsCount)
			else
				sbsCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _sbsCount)
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
		local _sadTime = 0
		local sadTime
		if TRB.Data.snapshotData.sliceAndDice.spellId ~= nil then
			_sadTime = GetSliceAndDiceRemainingTime()
		end
		
		if _sadTime > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _sadTime)
		elseif _sadTime > 0 then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _sadTime)
		else
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
		end

		
		--$blindsideTime
		local _blindsideTime = GetBlindsideRemainingTime()
		local blindsideTime = "0.0"
		if _blindsideTime ~= nil then
			blindsideTime = string.format("%.1f", _blindsideTime)
		end

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
		lookup["#amplifyingPoison"] = TRB.Data.spells.amplifyingPoison.icon
		lookup["#atrophicPoison"] = TRB.Data.spells.atrophicPoison.icon
		lookup["#blindside"] = TRB.Data.spells.blindside.icon
		lookup["#crimsonTempest"] = TRB.Data.spells.crimsonTempest.icon
		lookup["#ct"] = TRB.Data.spells.crimsonTempest.icon
		lookup["#cripplingPoison"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#cp"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#deadlyPoison"] = TRB.Data.spells.deadlyPoison.icon
		lookup["#dp"] = TRB.Data.spells.deadlyPoison.icon
		lookup["#deathFromAbove"] = TRB.Data.spells.deathFromAbove.icon
		lookup["#dismantle"] = TRB.Data.spells.dismantle.icon
		lookup["#echoingReprimand"] = TRB.Data.spells.echoingReprimand.icon
		lookup["#garrote"] = TRB.Data.spells.garrote.icon
		lookup["#internalBleeding"] = TRB.Data.spells.internalBleeding.icon
		lookup["#ib"] = TRB.Data.spells.internalBleeding.icon
		lookup["#numbingPoison"] = TRB.Data.spells.numbingPoison.icon
		lookup["#np"] = TRB.Data.spells.numbingPoison.icon
		lookup["#rupture"] = TRB.Data.spells.rupture.icon
		lookup["#sad"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sepsis"] = TRB.Data.spells.sepsis.icon
		lookup["#serratedBoneSpike"] = TRB.Data.spells.serratedBoneSpike.icon
		lookup["#woundPoison"] = TRB.Data.spells.woundPoison.icon
		lookup["#wp"] = TRB.Data.spells.woundPoison.icon

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

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
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
		lookupLogic["$energy"] = TRB.Data.snapshotData.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshotData.resource
		lookupLogic["$casting"] = TRB.Data.snapshotData.casting.resourceFinal
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

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
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
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.current
		local castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.casting

		if TRB.Data.settings.rogue.outlaw.colors.text.overcapEnabled and overcap then
			currentEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overcap
            castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overcap
		elseif TRB.Data.settings.rogue.outlaw.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overThreshold
				castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _regenEnergy = 0
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.outlaw.generation.enabled then
			if TRB.Data.settings.rogue.outlaw.generation.mode == "time" then
				_regenEnergy = TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.rogue.outlaw.generation.time or 3.0)
			else
				_regenEnergy = TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.rogue.outlaw.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)

		-- Poisons
		--$cpCount and $cpTime
		local _cpCount = TRB.Data.snapshotData.targetData.cripplingPoison or 0
		local cpCount = tostring(_cpCount)
		local _cpTime = 0
		local cpTime
			
		--$npCount and $npTime
		local _npCount = TRB.Data.snapshotData.targetData.numbingPoison or 0
		local npCount = tostring(_npCount)
		local _npTime = 0
		local npTime
				
		--$wpCount and $wpTime
		local _wpCount = TRB.Data.snapshotData.targetData.woundPoison or 0
		local wpCount = tostring(_wpCount)
		local _wpTime = 0
		local wpTime


		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_npTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoisonRemaining or 0
			_wpTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoisonRemaining or 0
		end


		if TRB.Data.settings.rogue.outlaw.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			--Poisons
			if _cpTime > 0 then
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _cpTime)
			else
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
			end

			if _npTime > 0 then
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _npTime)
			else
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
			end

			if _wpTime > 0 then
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _wpTime)
			else
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
			end
		else
			-- Poisons
			cpTime = string.format("%.1f", _cpTime)
			npTime = string.format("%.1f", _npTime)
			wpTime = string.format("%.1f", _wpTime)
		end

		local rollTheBonesCount = TRB.Data.snapshotData.rollTheBones.count
		local rollTheBonesTemporaryCount = TRB.Data.snapshotData.rollTheBones.temporaryCount
		local rollTheBonesAllCount = TRB.Data.snapshotData.rollTheBones.count + TRB.Data.snapshotData.rollTheBones.temporaryCount

		--$sadTime
		local _sadTime = 0
		local sadTime
		if TRB.Data.snapshotData.sliceAndDice.spellId ~= nil then
			_sadTime = GetSliceAndDiceRemainingTime()
		end
		
		if _sadTime > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _sadTime)
		elseif _sadTime > 0 then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.pandemic, _sadTime)
		else
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
		end

		--$rtbBuffTime
		local _rtbBuffTime = TRB.Data.snapshotData.rollTheBones.remaining
		local rtbBuffTime = string.format("%.1f", _rtbBuffTime)

		--$broadsideTime
		local _broadsideTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.broadside)
		local broadsideTime = string.format("%.1f", _broadsideTime)

		--$buriedTreasureTime
		local _buriedTreasureTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure)
		local buriedTreasureTime = string.format("%.1f", _buriedTreasureTime)

		--$grandMeleeTime
		local _grandMeleeTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.grandMelee)
		local grandMeleeTime = string.format("%.1f", _grandMeleeTime)

		--$ruthlessPrecisionTime
		local _ruthlessPrecisionTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision)
		local ruthlessPrecisionTime = string.format("%.1f", _ruthlessPrecisionTime)

		--$skullAndCrossbonesTime
		local _skullAndCrossbonesTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones)
		local skullAndCrossbonesTime = string.format("%.1f", _skullAndCrossbonesTime)

		--$trueBearingTime
		local _trueBearingTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.trueBearing)
		local trueBearingTime = string.format("%.1f", _trueBearingTime)
		
		--$opportunityTime
		local _opportunityTime = GetOpportunityRemainingTime()
		local opportunityTime = string.format("%.1f", _opportunityTime)

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.dots = {
			cripplingPoisonCount = _cpCount,
			numbingPoisonCount = _npCount,
			woundPoisonCount = _wpCount
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#adrenalineRush"] = TRB.Data.spells.adrenalineRush.icon
		lookup["#betweenTheEyes"] = TRB.Data.spells.betweenTheEyes.icon
		lookup["#bladeFlurry"] = TRB.Data.spells.bladeFlurry.icon
		lookup["#bladeRush"] = TRB.Data.spells.bladeRush.icon
		lookup["#broadside"] = TRB.Data.spells.broadside.icon
		lookup["#buriedTreasure"] = TRB.Data.spells.buriedTreasure.icon
		lookup["#deathFromAbove"] = TRB.Data.spells.numbingPoison.icon
		lookup["#dirtyTricks"] = TRB.Data.spells.dirtyTricks.icon
		lookup["#dispatch"] = TRB.Data.spells.dispatch.icon
		lookup["#dismantle"] = TRB.Data.spells.numbingPoison.icon
		lookup["#dreadblades"] = TRB.Data.spells.dreadblades.icon
		lookup["#cripplingPoison"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#cp"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#dismantle"] = TRB.Data.spells.dismantle.icon
		lookup["#echoingReprimand"] = TRB.Data.spells.echoingReprimand.icon
		lookup["#ghostlyStrike"] = TRB.Data.spells.ghostlyStrike.icon
		lookup["#grandMelee"] = TRB.Data.spells.grandMelee.icon
		lookup["#numbingPoison"] = TRB.Data.spells.numbingPoison.icon
		lookup["#np"] = TRB.Data.spells.numbingPoison.icon
		lookup["#opportunity"] = TRB.Data.spells.opportunity.icon
		lookup["#pistolShot"] = TRB.Data.spells.pistolShot.icon
		lookup["#rollTheBones"] = TRB.Data.spells.rollTheBones.icon
		lookup["#ruthlessPrecision"] = TRB.Data.spells.ruthlessPrecision.icon
		lookup["#sad"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sepsis"] = TRB.Data.spells.sepsis.icon
		lookup["#sinisterStrike"] = TRB.Data.spells.sinisterStrike.icon
		lookup["#skullAndCrossbones"] = TRB.Data.spells.skullAndCrossbones.icon
		lookup["#trueBearing"] = TRB.Data.spells.trueBearing.icon
		lookup["#woundPoison"] = TRB.Data.spells.woundPoison.icon
		lookup["#wp"] = TRB.Data.spells.woundPoison.icon

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

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
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
		lookupLogic["$energy"] = TRB.Data.snapshotData.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshotData.resource
		lookupLogic["$casting"] = TRB.Data.snapshotData.casting.resourceFinal
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
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

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
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

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.energy
        TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.energy)
        TRB.Data.snapshotData.casting.spellId = spell.id
        TRB.Data.snapshotData.casting.icon = spell.icon
    end

	local function CastingSpell()
		local specId = GetSpecialization()
		local currentSpell = UnitCastingInfo("player")
		local currentChannel = UnitChannelInfo("player")

		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 1 or specId == 2 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
						TRB.Functions.ResetCastingSnapshotData()
						return false
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					return false
				end
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()

		_, _, _, _, _, TRB.Data.snapshotData.sliceAndDice.endTime, _, _, _, TRB.Data.snapshotData.sliceAndDice.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.sliceAndDice.id)

        if TRB.Data.snapshotData.distract.startTime ~= nil and currentTime > (TRB.Data.snapshotData.distract.startTime + TRB.Data.snapshotData.distract.duration) then
            TRB.Data.snapshotData.distract.startTime = nil
            TRB.Data.snapshotData.distract.duration = 0
        end

        if TRB.Data.snapshotData.feint.startTime ~= nil and currentTime > (TRB.Data.snapshotData.feint.startTime + TRB.Data.snapshotData.feint.duration) then
            TRB.Data.snapshotData.feint.startTime = nil
            TRB.Data.snapshotData.feint.duration = 0
        end

        if TRB.Data.snapshotData.kidneyShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.kidneyShot.startTime + TRB.Data.snapshotData.kidneyShot.duration) then
            TRB.Data.snapshotData.kidneyShot.startTime = nil
            TRB.Data.snapshotData.kidneyShot.duration = 0
        end

        if TRB.Data.snapshotData.shiv.startTime ~= nil and currentTime > (TRB.Data.snapshotData.shiv.startTime + TRB.Data.snapshotData.shiv.duration) then
            TRB.Data.snapshotData.shiv.startTime = nil
            TRB.Data.snapshotData.shiv.duration = 0
        end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].atrophicPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.atrophicPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].atrophicPoisonRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.cripplingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoisonRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.numbingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoisonRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.woundPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoisonRemaining = expiration - currentTime
				end
			end
		end

        if TRB.Data.snapshotData.echoingReprimand.startTime ~= nil and currentTime > (TRB.Data.snapshotData.echoingReprimand.startTime + TRB.Data.snapshotData.echoingReprimand.duration) then
            TRB.Data.snapshotData.echoingReprimand.startTime = nil
            TRB.Data.snapshotData.echoingReprimand.duration = 0
        end
	
        if TRB.Data.snapshotData.deathFromAbove.startTime ~= nil and currentTime > (TRB.Data.snapshotData.deathFromAbove.startTime + TRB.Data.snapshotData.deathFromAbove.duration) then
            TRB.Data.snapshotData.deathFromAbove.startTime = nil
            TRB.Data.snapshotData.deathFromAbove.duration = 0
        end

        if TRB.Data.snapshotData.dismantle.startTime ~= nil and currentTime > (TRB.Data.snapshotData.dismantle.startTime + TRB.Data.snapshotData.dismantle.duration) then
            TRB.Data.snapshotData.dismantle.startTime = nil
            TRB.Data.snapshotData.dismantle.duration = 0
        end

        if TRB.Data.snapshotData.crimsonVial.startTime ~= nil and currentTime > (TRB.Data.snapshotData.crimsonVial.startTime + TRB.Data.snapshotData.crimsonVial.duration) then
            TRB.Data.snapshotData.crimsonVial.startTime = nil
            TRB.Data.snapshotData.crimsonVial.duration = 0
        end
	end

	local function UpdateSnapshot_Assassination()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _

		if TRB.Functions.IsTalentActive(TRB.Data.spells.serratedBoneSpike) then
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshotData.serratedBoneSpike.charges, TRB.Data.snapshotData.serratedBoneSpike.maxCharges, TRB.Data.snapshotData.serratedBoneSpike.startTime, TRB.Data.snapshotData.serratedBoneSpike.duration, _ = GetSpellCharges(TRB.Data.spells.serratedBoneSpike.id)
		else
			TRB.Data.snapshotData.serratedBoneSpike.charges = 0
			TRB.Data.snapshotData.serratedBoneSpike.startTime = nil
			TRB.Data.snapshotData.serratedBoneSpike.duration = 0
		end

        if TRB.Data.snapshotData.exsanguinate.startTime ~= nil and currentTime > (TRB.Data.snapshotData.exsanguinate.startTime + TRB.Data.snapshotData.exsanguinate.duration) then
            TRB.Data.snapshotData.exsanguinate.startTime = nil
            TRB.Data.snapshotData.exsanguinate.duration = 0
        end

        if TRB.Data.snapshotData.garrote.startTime ~= nil and currentTime > (TRB.Data.snapshotData.garrote.startTime + TRB.Data.snapshotData.garrote.duration) then
            TRB.Data.snapshotData.garrote.startTime = nil
            TRB.Data.snapshotData.garrote.duration = 0
        end

        if TRB.Data.snapshotData.kingsbane.startTime ~= nil and currentTime > (TRB.Data.snapshotData.kingsbane.startTime + TRB.Data.snapshotData.kingsbane.duration) then
            TRB.Data.snapshotData.kingsbane.startTime = nil
            TRB.Data.snapshotData.kingsbane.duration = 0
        end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].amplifyingPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.amplifyingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].amplifyingPoisonRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.deadlyPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoisonRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempest then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.crimsonTempest.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempestRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garrote then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.garrote.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garroteRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleeding then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.internalBleeding.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleedingRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rupture then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.rupture.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ruptureRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Outlaw()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _
		
		if TRB.Data.snapshotData.bladeRush.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.bladeRush.startTime, TRB.Data.snapshotData.bladeRush.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeRush.id)
			if TRB.Data.snapshotData.bladeRush.startTime ~= nil and currentTime > (TRB.Data.snapshotData.bladeRush.startTime + TRB.Data.snapshotData.bladeRush.duration) then
				TRB.Data.snapshotData.bladeRush.startTime = nil
				TRB.Data.snapshotData.bladeRush.duration = 0
			end
		end

		if TRB.Data.snapshotData.bladeFlurry.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.bladeFlurry.startTime, TRB.Data.snapshotData.bladeFlurry.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeFlurry.id)
			if TRB.Data.snapshotData.bladeFlurry.startTime ~= nil and currentTime > (TRB.Data.snapshotData.bladeFlurry.startTime + TRB.Data.snapshotData.bladeFlurry.duration) then
				TRB.Data.snapshotData.bladeFlurry.startTime = nil
				TRB.Data.snapshotData.bladeFlurry.duration = 0
			end
		end

		if TRB.Data.snapshotData.betweenTheEyes.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.betweenTheEyes.startTime, TRB.Data.snapshotData.betweenTheEyes.duration, _, _ = GetSpellCooldown(TRB.Data.spells.betweenTheEyes.id)
			if TRB.Data.snapshotData.betweenTheEyes.startTime ~= nil and currentTime > (TRB.Data.snapshotData.betweenTheEyes.startTime + TRB.Data.snapshotData.betweenTheEyes.duration) then
				TRB.Data.snapshotData.betweenTheEyes.startTime = nil
				TRB.Data.snapshotData.betweenTheEyes.duration = 0
			end
		end

		if TRB.Data.snapshotData.dreadblades.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.dreadblades.startTime, TRB.Data.snapshotData.dreadblades.duration, _, _ = GetSpellCooldown(TRB.Data.spells.dreadblades.id)
			if TRB.Data.snapshotData.dreadblades.startTime ~= nil and currentTime > (TRB.Data.snapshotData.dreadblades.startTime + TRB.Data.snapshotData.dreadblades.duration) then
				TRB.Data.snapshotData.dreadblades.startTime = nil
				TRB.Data.snapshotData.dreadblades.duration = 0
			end
		end

		if TRB.Data.snapshotData.ghostlyStrike.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.ghostlyStrike.startTime, TRB.Data.snapshotData.ghostlyStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.ghostlyStrike.id)
			if TRB.Data.snapshotData.ghostlyStrike.startTime ~= nil and currentTime > (TRB.Data.snapshotData.ghostlyStrike.startTime + TRB.Data.snapshotData.ghostlyStrike.duration) then
				TRB.Data.snapshotData.ghostlyStrike.startTime = nil
				TRB.Data.snapshotData.ghostlyStrike.duration = 0
			end
		end

        if TRB.Data.snapshotData.gouge.startTime ~= nil and currentTime > (TRB.Data.snapshotData.gouge.startTime + TRB.Data.snapshotData.gouge.duration) then
            TRB.Data.snapshotData.gouge.startTime = nil
            TRB.Data.snapshotData.gouge.duration = 0
        end

		if TRB.Data.snapshotData.rollTheBones.startTime ~= nil then	
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.rollTheBones.startTime, TRB.Data.snapshotData.rollTheBones.duration, _, _ = GetSpellCooldown(TRB.Data.spells.rollTheBones.id)

			if TRB.Data.snapshotData.rollTheBones.startTime ~= nil and currentTime > (TRB.Data.snapshotData.rollTheBones.startTime + TRB.Data.snapshotData.rollTheBones.duration) then
				TRB.Data.snapshotData.rollTheBones.startTime = nil
				TRB.Data.snapshotData.rollTheBones.duration = 0
			end
		end
		
		local rollTheBonesCount = 0
		local rollTheBonesTemporaryCount = 0
		local highestRemaining = 0
		for _, v in pairs(TRB.Data.snapshotData.rollTheBones.buffs) do
			local remaining = TRB.Functions.GetSpellRemainingTime(v)
			if remaining > 0 then
				if v.fromCountTheOdds then
					rollTheBonesTemporaryCount = rollTheBonesTemporaryCount + 1
				else
					rollTheBonesCount = rollTheBonesCount + 1
					if remaining > highestRemaining then
						highestRemaining = remaining
					end
				end
			end
		end
		TRB.Data.snapshotData.rollTheBones.count = rollTheBonesCount
		TRB.Data.snapshotData.rollTheBones.temporaryCount = rollTheBonesTemporaryCount
		TRB.Data.snapshotData.rollTheBones.remaining = highestRemaining

		if TRB.Data.snapshotData.rollTheBones.count >= 2 or TRB.Data.snapshotData.rollTheBones.buffs.broadside.duration > 0 or TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.duration > 0 then
			TRB.Data.snapshotData.rollTheBones.goodBuffs = true
		else
			TRB.Data.snapshotData.rollTheBones.goodBuffs = false
		end
	end

	local function UpdateSnapshot_Subtlety()
		UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.rogue.assassination.displayBar.alwaysShow) and (
						(not TRB.Data.settings.rogue.assassination.displayBar.notZeroShow) or
						(TRB.Data.settings.rogue.assassination.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
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
						(TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.rogue.outlaw.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		else
			TRB.Frames.barContainerFrame:Hide()
			TRB.Data.snapshotData.isTracking = false
		end
	end
	TRB.Functions.HideResourceBar = HideResourceBar

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()

		if specId == 1 then
			UpdateSnapshot_Assassination()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.rogue.assassination.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)

					local passiveValue = 0
					if TRB.Data.settings.rogue.assassination.bar.showPassive then
						if TRB.Data.settings.rogue.assassination.generation.enabled then
							if TRB.Data.settings.rogue.assassination.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.rogue.assassination.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.rogue.assassination.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and TRB.Data.settings.rogue.assassination.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true, spell.nimbleFingersConduit, spell.rushedSetupConduit)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.assassination, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.rogue.assassination.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed. TODO: add override check for certain buffs.
								if spell.id == TRB.Data.spells.ambush.id then
									if TRB.Data.spells.subterfuge.isActive or TRB.Data.spells.sepsis.isActive then
										if TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif TRB.Data.spells.blindside.isActive then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										showThreshold = false
									end
								elseif TRB.Data.spells.subterfuge.isActive or TRB.Data.spells.sepsis.isActive then
									if TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else
									showThreshold = false
								end
							else
								if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
									if spell.id == TRB.Data.spells.exsanguinate.id then
										if not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif not IsTargetBleeding(TRB.Data.snapshotData.targetData.currentTargetGuid) or (TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration)) then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.shiv.id then
										if not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.character.items.tinyToxicBlade == true or TRB.Functions.IsTalentActive(TRB.Data.spells.tinyToxicBlade) then -- Don't show this threshold
											showThreshold = false
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.echoingReprimand.id then
										if not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sepsis.id then
										if not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.serratedBoneSpike.id then
										if not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].charges == 0 then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sliceAndDice.id then
										if TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end

										if GetSliceAndDiceRemainingTime() > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
											frameLevel = TRB.Data.constants.frameLevels.thresholdBase
										else
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										end
									end
								elseif spell.isPvp and not TRB.Data.character.isPvp then
									showThreshold = false
								elseif spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif spell.hasCooldown then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else -- This is an active/available/normal spell threshold
									if TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end

							if spell.comboPoints == true and TRB.Data.snapshotData.resource2 == 0 then
								thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							if TRB.Data.settings.rogue.assassination.thresholds[spell.settingKey].enabled and showThreshold then
								if not spell.hasCooldown then
									frameLevel = frameLevel - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown
								end

								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == TRB.Data.constants.frameLevels.thresholdOver then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
								
                                if TRB.Data.settings.rogue.assassination.thresholds.icons.showCooldown and spell.hasCooldown and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) and (TRB.Data.snapshotData[spell.settingKey].maxCharges == nil or TRB.Data.snapshotData[spell.settingKey].charges < TRB.Data.snapshotData[spell.settingKey].maxCharges) then
									TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetCooldown(TRB.Data.snapshotData[spell.settingKey].startTime, TRB.Data.snapshotData[spell.settingKey].duration)
								else
									TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetCooldown(0, 0)
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
						pairOffset = pairOffset + 3
					end

					local barColor = TRB.Data.settings.rogue.assassination.colors.bar.base

					local latency = TRB.Functions.GetLatency()

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat then
						local sadTime = GetSliceAndDiceRemainingTime()
						if sadTime == 0 then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.noSliceAndDice
						elseif sadTime < TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.sliceAndDicePandemic
						end
					end

					local barBorderColor = TRB.Data.settings.rogue.assassination.colors.bar.border

					if TRB.Data.settings.rogue.assassination.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.rogue.assassination.colors.bar.borderOvercap

						if TRB.Data.settings.rogue.assassination.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
					
					local sbsCp = 0
					
					if TRB.Functions.IsTalentActive(TRB.Data.spells.serratedBoneSpike) and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.serratedBoneSpike.charges > 0 then
						sbsCp = 1 + TRB.Data.snapshotData.targetData.serratedBoneSpike

						if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] == nil or
							TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serratedBoneSpike == false then
							sbsCp = sbsCp + 1
						end
					end

					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.background, true)

                    for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.border
						local cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

                        if TRB.Data.snapshotData.resource2 >= x then
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (TRB.Data.settings.rogue.assassination.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not TRB.Data.settings.rogue.assassination.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.penultimate
							elseif (TRB.Data.settings.rogue.assassination.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
								cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.final
							end
                        else
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
                        end

						if TRB.Data.snapshotData.echoingReprimand[x].enabled then
							cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.echoingReprimand
							if sbsCp > 0 and x > TRB.Data.snapshotData.resource2 and x <= (TRB.Data.snapshotData.resource2 + sbsCp) then
								cpBorderColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.serratedBoneSpike
							else
								cpBorderColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.echoingReprimand
							end
							cpBR, cpBG, cpBB, _ = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.echoingReprimand, true)
						elseif sbsCp > 0 and x > TRB.Data.snapshotData.resource2 and x <= (TRB.Data.snapshotData.resource2 + sbsCp) then
							cpBorderColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.serratedBoneSpike
							cpBR, cpBG, cpBB, _ = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.serratedBoneSpike, true)
						end
						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.rogue.assassination, refreshText)
		elseif specId == 2 then
			UpdateSnapshot_Outlaw()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.rogue.outlaw, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.rogue.outlaw.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)

					local passiveValue = 0
					if TRB.Data.settings.rogue.outlaw.bar.showPassive then
						if TRB.Data.settings.rogue.outlaw.generation.enabled then
							if TRB.Data.settings.rogue.outlaw.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.rogue.outlaw.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.rogue.outlaw.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and TRB.Data.settings.rogue.outlaw.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then	
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true, spell.nimbleFingersConduit, spell.rushedSetupConduit)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.outlaw, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.rogue.outlaw.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed. TODO: add override check for certain buffs.
								showThreshold = false
							else
								if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
									if spell.id == TRB.Data.spells.shiv.id then
										if TRB.Data.character.items.tinyToxicBlade == true then -- Don't show this threshold
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.echoingReprimand.id then
										if not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sepsis.id then
										if not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sinisterStrike.id then
										if TRB.Data.snapshotData.resource >= -energyAmount then
											if TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones) > 0 then
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
											end
										else
											if TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones) > 0 then
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									elseif spell.id == TRB.Data.spells.pistolShot.id then
										local opportunityTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.opportunity)

										if opportunityTime > 0 then
											energyAmount = energyAmount * TRB.Data.spells.opportunity.energyModifier
											TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.outlaw, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.rogue.outlaw.thresholds.width, -energyAmount, TRB.Data.character.maxResource)
										end

										if TRB.Data.snapshotData.resource >= -energyAmount then
											if opportunityTime > 0 then
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
											end
										else
											if opportunityTime > 0 then
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									elseif spell.id == TRB.Data.spells.betweenTheEyes.id then
										if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											if TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision) > 0 then
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
											end
										else
											if TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision) > 0 then
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									elseif spell.id == TRB.Data.spells.sliceAndDice.id then
										if TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end

										if GetSliceAndDiceRemainingTime() > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
											frameLevel = TRB.Data.constants.frameLevels.thresholdBase
										else
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										end
									end
								elseif spell.isPvp and not TRB.Data.character.isPvp then
									showThreshold = false
								elseif spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif spell.hasCooldown then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else -- This is an active/available/normal spell threshold
									if TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end

							if spell.comboPoints == true and TRB.Data.snapshotData.resource2 == 0 then
								thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							if TRB.Data.settings.rogue.outlaw.thresholds[spell.settingKey].enabled and showThreshold then
								if not spell.hasCooldown then
									frameLevel = frameLevel - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown
								end

								if spell.restlessBlades == true and TRB.Functions.IsTalentActive(TRB.Data.spells.restlessBlades) and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil then
									local cdRemaining = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData[spell.settingKey])
									if (TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.startTime == nil and cdRemaining < TRB.Data.snapshotData.resource2) or (TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.startTime ~= nil and cdRemaining < (TRB.Data.snapshotData.resource2 * 2)) then 
										frameLevel = TRB.Data.constants.frameLevels.thresholdOver - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown	
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.restlessBlades
									end
								end

								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == TRB.Data.constants.frameLevels.thresholdOver then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
								
                                if TRB.Data.settings.rogue.outlaw.thresholds.icons.showCooldown and spell.hasCooldown and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) and (TRB.Data.snapshotData[spell.settingKey].maxCharges == nil or TRB.Data.snapshotData[spell.settingKey].charges < TRB.Data.snapshotData[spell.settingKey].maxCharges) then
									TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetCooldown(TRB.Data.snapshotData[spell.settingKey].startTime, TRB.Data.snapshotData[spell.settingKey].duration)
								else
									TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetCooldown(0, 0)
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
						pairOffset = pairOffset + 3
					end

					local barColor = TRB.Data.settings.rogue.outlaw.colors.bar.base

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat then
						local sadTime = GetSliceAndDiceRemainingTime()
						if sadTime == 0 then
							barColor = TRB.Data.settings.rogue.outlaw.colors.bar.noSliceAndDice
						elseif sadTime < TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
							barColor = TRB.Data.settings.rogue.outlaw.colors.bar.sliceAndDicePandemic
						end
					end

					local barBorderColor = TRB.Data.settings.rogue.outlaw.colors.bar.border

					if TRB.Data.snapshotData.rollTheBones.goodBuffs == true and TRB.Data.snapshotData.rollTheBones.startTime == nil then
						barBorderColor = TRB.Data.settings.rogue.outlaw.colors.bar.borderRtbGood
					elseif TRB.Data.snapshotData.rollTheBones.goodBuffs == false and TRB.Data.snapshotData.rollTheBones.startTime == nil then
						barBorderColor = TRB.Data.settings.rogue.outlaw.colors.bar.borderRtbBad
					elseif TRB.Data.settings.rogue.outlaw.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.rogue.outlaw.colors.bar.borderOvercap

						if TRB.Data.settings.rogue.outlaw.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.comboPoints.background, true)

                    for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = TRB.Data.settings.rogue.outlaw.colors.comboPoints.border
						local cpColor = TRB.Data.settings.rogue.outlaw.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

                        if TRB.Data.snapshotData.resource2 >= x then
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (TRB.Data.settings.rogue.outlaw.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not TRB.Data.settings.rogue.outlaw.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = TRB.Data.settings.rogue.outlaw.colors.comboPoints.penultimate
							elseif (TRB.Data.settings.rogue.outlaw.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
								cpColor = TRB.Data.settings.rogue.outlaw.colors.comboPoints.final
							end
                        else
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.outlaw, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
                        end

						if TRB.Data.snapshotData.echoingReprimand[x].enabled then
							cpColor = TRB.Data.settings.rogue.outlaw.colors.comboPoints.echoingReprimand
							cpBorderColor = TRB.Data.settings.rogue.outlaw.colors.comboPoints.echoingReprimand
							cpBR, cpBG, cpBB, _ = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.outlaw.colors.comboPoints.echoingReprimand, true)
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
                    end
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.rogue.outlaw, refreshText)
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 then
			TRB.Functions.HideResourceBar(true)
			return
		end

		local currentTime = GetTime()

		if updateRateLimit + 0.05 < currentTime then
			updateRateLimit = currentTime
			UpdateResourceBar()
		end
	end
	TRB.Functions.TriggerResourceBarUpdates = TriggerResourceBarUpdates

	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 then --Assassination
					if spellId == TRB.Data.spells.exsanguinate.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.exsanguinate.startTime = currentTime
							TRB.Data.snapshotData.exsanguinate.duration = TRB.Data.spells.exsanguinate.cooldown
						end
					elseif spellId == TRB.Data.spells.blindside.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.blindside.isActive = true
							_, _, _, _, TRB.Data.snapshotData.blindside.duration, TRB.Data.snapshotData.blindside.endTime, _, _, _, TRB.Data.snapshotData.blindside.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.blindside.id)
							if TRB.Data.settings.rogue.assassination.audio.blindside.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.blindside.isActive = false
							TRB.Data.snapshotData.blindside.spellId = nil
							TRB.Data.snapshotData.blindside.duration = 0
							TRB.Data.snapshotData.blindside.endTime = nil
						end
					elseif spellId == TRB.Data.spells.subterfuge.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.subterfuge.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.subterfuge.isActive = false
						end
					elseif spellId == TRB.Data.spells.garrote.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" then
								if not((TRB.Functions.IsTalentActive(TRB.Data.spells.subterfuge) and IsStealthed()) or TRB.Data.spells.subterfuge.isActive) then
									TRB.Data.snapshotData.garrote.startTime = currentTime
									TRB.Data.snapshotData.garrote.duration = TRB.Data.spells.garrote.cooldown
								end
							elseif type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Garrote Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].garrote = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.garrote = TRB.Data.snapshotData.targetData.garrote + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].garrote = false
								TRB.Data.snapshotData.targetData.targets[destGUID].garroteRemaining = 0
								TRB.Data.snapshotData.targetData.garrote = TRB.Data.snapshotData.targetData.garrote - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.rupture.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rupture Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].rupture = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.rupture = TRB.Data.snapshotData.targetData.rupture + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].rupture = false
								TRB.Data.snapshotData.targetData.targets[destGUID].ruptureRemaining = 0
								TRB.Data.snapshotData.targetData.rupture = TRB.Data.snapshotData.targetData.rupture - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.internalBleeding.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- IB Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].internalBleeding = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.internalBleeding = TRB.Data.snapshotData.targetData.internalBleeding + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].internalBleeding = false
								TRB.Data.snapshotData.targetData.targets[destGUID].internalBleedingRemaining = 0
								TRB.Data.snapshotData.targetData.internalBleeding = TRB.Data.snapshotData.targetData.internalBleeding - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.crimsonTempest.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- CT Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].crimsonTempest = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.crimsonTempest = TRB.Data.snapshotData.targetData.crimsonTempest + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].crimsonTempest = false
								TRB.Data.snapshotData.targetData.targets[destGUID].crimsonTempestRemaining = 0
								TRB.Data.snapshotData.targetData.crimsonTempest = TRB.Data.snapshotData.targetData.crimsonTempest - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.deadlyPoison.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- DP Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].deadlyPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.deadlyPoison = TRB.Data.snapshotData.targetData.deadlyPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].deadlyPoison = false
								TRB.Data.snapshotData.targetData.targets[destGUID].deadlyPoisonRemaining = 0
								TRB.Data.snapshotData.targetData.deadlyPoison = TRB.Data.snapshotData.targetData.deadlyPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.amplifyingPoison.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Amplifying Poison Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].amplifyingPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.amplifyingPoison = TRB.Data.snapshotData.targetData.amplifyingPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].amplifyingPoison = false
								TRB.Data.snapshotData.targetData.targets[destGUID].amplifyingPoisonRemaining = 0
								TRB.Data.snapshotData.targetData.amplifyingPoison = TRB.Data.snapshotData.targetData.amplifyingPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.kingsbane.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.kingsbane.startTime = currentTime
							TRB.Data.snapshotData.kingsbane.duration = TRB.Data.spells.kingsbane.cooldown
						end
					elseif spellId == TRB.Data.spells.serratedBoneSpike.id then
						if type == "SPELL_CAST_SUCCESS" then -- Serrated Bone Spike
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.serratedBoneSpike.charges, TRB.Data.snapshotData.serratedBoneSpike.maxCharges, TRB.Data.snapshotData.serratedBoneSpike.startTime, TRB.Data.snapshotData.serratedBoneSpike.duration, _ = GetSpellCharges(TRB.Data.spells.serratedBoneSpike.id)
						end
					elseif spellId == TRB.Data.spells.serratedBoneSpike.debuffId then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].serratedBoneSpike = true
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].serratedBoneSpike = false
								TRB.Data.snapshotData.targetData.serratedBoneSpike = TRB.Data.snapshotData.targetData.serratedBoneSpike - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end	
					end
				elseif specId == 2 then
					if spellId == TRB.Data.spells.betweenTheEyes.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.betweenTheEyes.startTime = currentTime
							TRB.Data.snapshotData.betweenTheEyes.duration = TRB.Data.spells.betweenTheEyes.cooldown
						end
					elseif spellId == TRB.Data.spells.bladeFlurry.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.bladeFlurry.startTime = currentTime
							TRB.Data.snapshotData.bladeFlurry.duration = TRB.Data.spells.bladeFlurry.cooldown
						end
					elseif spellId == TRB.Data.spells.dreadblades.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.dreadblades.startTime = currentTime
							TRB.Data.snapshotData.dreadblades.duration = TRB.Data.spells.dreadblades.cooldown
						end
					elseif spellId == TRB.Data.spells.ghostlyStrike.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.ghostlyStrike.startTime = currentTime
							TRB.Data.snapshotData.ghostlyStrike.duration = TRB.Data.spells.ghostlyStrike.cooldown
						end
					elseif spellId == TRB.Data.spells.gouge.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.gouge.startTime = currentTime
							TRB.Data.snapshotData.gouge.duration = TRB.Data.spells.gouge.cooldown
						end
					elseif spellId == TRB.Data.spells.rollTheBones.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.rollTheBones.startTime = currentTime
							TRB.Data.snapshotData.rollTheBones.duration = TRB.Data.spells.rollTheBones.cooldown
						end
					elseif spellId == TRB.Data.spells.opportunity.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.opportunity.isActive = true
							_, _, _, _, TRB.Data.snapshotData.opportunity.duration, TRB.Data.snapshotData.opportunity.endTime, _, _, _, TRB.Data.snapshotData.opportunity.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.opportunity.id)
							
							if TRB.Data.settings.rogue.outlaw.audio.opportunity.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.opportunity.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.broadside.isActive = false
							TRB.Data.snapshotData.opportunity.spellId = nil
							TRB.Data.snapshotData.opportunity.duration = 0
							TRB.Data.snapshotData.opportunity.endTime = nil
						end
					elseif spellId == TRB.Data.spells.broadside.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.broadside.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.broadside.duration, TRB.Data.snapshotData.rollTheBones.buffs.broadside.endTime, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.broadside.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.broadside.id)
							
							if TRB.Data.snapshotData.rollTheBones.buffs.broadside.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshotData.rollTheBones.buffs.broadside.fromCountTheOdds = false
							else
								TRB.Data.snapshotData.rollTheBones.buffs.broadside.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.broadside.isActive = false
							TRB.Data.snapshotData.rollTheBones.buffs.broadside.spellId = nil
							TRB.Data.snapshotData.rollTheBones.buffs.broadside.duration = 0
							TRB.Data.snapshotData.rollTheBones.buffs.broadside.endTime = nil
							TRB.Data.snapshotData.rollTheBones.buffs.broadside.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.buriedTreasure.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.buriedTreasure.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.duration, TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.endTime, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.buriedTreasure.id)
							
							if TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.fromCountTheOdds = false
							else
								TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.buriedTreasure.isActive = false
							TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.spellId = nil
							TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.duration = 0
							TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.endTime = nil
							TRB.Data.snapshotData.rollTheBones.buffs.buriedTreasure.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.grandMelee.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.grandMelee.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.duration, TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.endTime, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.grandMelee.id)
							
							if TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.fromCountTheOdds = false
							else
								TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.grandMelee.isActive = false
							TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.spellId = nil
							TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.duration = 0
							TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.endTime = nil
							TRB.Data.snapshotData.rollTheBones.buffs.grandMelee.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.ruthlessPrecision.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.ruthlessPrecision.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.duration, TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.endTime, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.ruthlessPrecision.id)
							
							if TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.fromCountTheOdds = false
							else
								TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.ruthlessPrecision.isActive = false
							TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.spellId = nil
							TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.duration = 0
							TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.endTime = nil
							TRB.Data.snapshotData.rollTheBones.buffs.ruthlessPrecision.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.skullAndCrossbones.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.skullAndCrossbones.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.duration, TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.endTime, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.skullAndCrossbones.id)
							
							if TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.fromCountTheOdds = false
							else
								TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.skullAndCrossbones.isActive = false
							TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.spellId = nil
							TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.duration = 0
							TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.endTime = nil
							TRB.Data.snapshotData.rollTheBones.buffs.skullAndCrossbones.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.trueBearing.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.trueBearing.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.duration, TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.endTime, _, _, _, TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.trueBearing.id)

							if TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.fromCountTheOdds = false
							else
								TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.trueBearing.isActive = false
							TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.spellId = nil
							TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.duration = 0
							TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.endTime = nil
							TRB.Data.snapshotData.rollTheBones.buffs.trueBearing.fromCountTheOdds = false
						end
					end
				end

				-- Spec agnostic
				if spellId == TRB.Data.spells.crimsonVial.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.crimsonVial.startTime = currentTime
						TRB.Data.snapshotData.crimsonVial.duration = TRB.Data.spells.crimsonVial.cooldown
					end
				elseif spellId == TRB.Data.spells.sliceAndDice.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
						TRB.Data.spells.sliceAndDice.isActive = true
						_, _, _, _, _, TRB.Data.snapshotData.sliceAndDice.endTime, _, _, _, TRB.Data.snapshotData.sliceAndDice.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.sliceAndDice.id)
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.sliceAndDice.isActive = false
						TRB.Data.snapshotData.sliceAndDice.spellId = nil
						TRB.Data.snapshotData.sliceAndDice.endTime = nil
					end
				elseif spellId == TRB.Data.spells.distract.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.distract.startTime = currentTime
						TRB.Data.snapshotData.distract.duration = TRB.Data.spells.distract.cooldown
					end
				elseif spellId == TRB.Data.spells.feint.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.feint.startTime = currentTime
						TRB.Data.snapshotData.feint.duration = TRB.Data.spells.feint.cooldown
					end
				elseif spellId == TRB.Data.spells.kidneyShot.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.kidneyShot.startTime = currentTime
						TRB.Data.snapshotData.kidneyShot.duration = TRB.Data.spells.kidneyShot.cooldown
					end
				elseif spellId == TRB.Data.spells.shiv.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.shiv.startTime = currentTime
						TRB.Data.snapshotData.shiv.duration = TRB.Data.spells.shiv.cooldown
					end
				elseif spellId == TRB.Data.spells.adrenalineRush.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" then -- For right now, just redo the CheckCharacter() to get update Energy values
						CheckCharacter()
					end
				elseif spellId == TRB.Data.spells.echoingReprimand.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.echoingReprimand.startTime = currentTime
						TRB.Data.snapshotData.echoingReprimand.duration = TRB.Data.spells.echoingReprimand.cooldown
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end
				elseif spellId == TRB.Data.spells.echoingReprimand.buffId[1] or spellId == TRB.Data.spells.echoingReprimand.buffId[2] or spellId == TRB.Data.spells.echoingReprimand.buffId[3] or spellId == TRB.Data.spells.echoingReprimand.buffId[4] or spellId == TRB.Data.spells.echoingReprimand.buffId[5] then
					local cpEntry = 1

					if spellId == TRB.Data.spells.echoingReprimand.buffId[1] then
						cpEntry = 2
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[2] then
						cpEntry = 3
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[3] or spellId == TRB.Data.spells.echoingReprimand.buffId[4] then
						cpEntry = 4
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[5] then
						cpEntry = 5
					end

					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Echoing Reprimand Applied to Target
						TRB.Data.snapshotData.echoingReprimand[cpEntry].enabled = true
						_, _, TRB.Data.snapshotData.echoingReprimand[cpEntry].comboPoints, _, TRB.Data.snapshotData.echoingReprimand[cpEntry].duration, TRB.Data.snapshotData.echoingReprimand[cpEntry].endTime, _, _, _, TRB.Data.snapshotData.echoingReprimand[cpEntry].spellId = TRB.Functions.FindBuffById(spellId)
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.echoingReprimand[cpEntry].enabled = false
						TRB.Data.snapshotData.echoingReprimand[cpEntry].spellId = nil
						TRB.Data.snapshotData.echoingReprimand[cpEntry].endTime = nil
						TRB.Data.snapshotData.echoingReprimand[cpEntry].comboPoints = 0
					end	
				elseif spellId == TRB.Data.spells.sepsis.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.sepsis.startTime = currentTime
						TRB.Data.snapshotData.sepsis.duration = TRB.Data.spells.sepsis.cooldown
					end
				elseif spellId == TRB.Data.spells.sepsis.buffId then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.sepsis.isActive = true
						if TRB.Data.settings.rogue.assassination.audio.sepsis.enabled then
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.sepsis.isActive = false
					end		
				elseif spellId == TRB.Data.spells.cripplingPoison.id then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- CP Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].cripplingPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshotData.targetData.cripplingPoison = TRB.Data.snapshotData.targetData.cripplingPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].cripplingPoison = false
							TRB.Data.snapshotData.targetData.targets[destGUID].cripplingPoisonRemaining = 0
							TRB.Data.snapshotData.targetData.cripplingPoison = TRB.Data.snapshotData.targetData.cripplingPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.woundPoison.id then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- WP Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].woundPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshotData.targetData.woundPoison = TRB.Data.snapshotData.targetData.woundPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].woundPoison = false
							TRB.Data.snapshotData.targetData.targets[destGUID].woundPoisonRemaining = 0
							TRB.Data.snapshotData.targetData.woundPoison = TRB.Data.snapshotData.targetData.woundPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.numbingPoison.id then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- NP Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].numbingPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshotData.targetData.numbingPoison = TRB.Data.snapshotData.targetData.numbingPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].numbingPoison = false
							TRB.Data.snapshotData.targetData.targets[destGUID].numbingPoisonRemaining = 0
							TRB.Data.snapshotData.targetData.numbingPoison = TRB.Data.snapshotData.targetData.numbingPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.atrophicPoison.id then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Atrophic Poison Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].atrophicPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshotData.targetData.atrophicPoison = TRB.Data.snapshotData.targetData.atrophicPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].atrophicPoison = false
							TRB.Data.snapshotData.targetData.targets[destGUID].atrophicPoisonRemaining = 0
							TRB.Data.snapshotData.targetData.atrophicPoison = TRB.Data.snapshotData.targetData.atrophicPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.deathFromAbove.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.deathFromAbove.startTime = currentTime
						TRB.Data.snapshotData.deathFromAbove.duration = TRB.Data.spells.deathFromAbove.cooldown
					end
				elseif spellId == TRB.Data.spells.dismantle.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.dismantle.startTime = currentTime
						TRB.Data.snapshotData.dismantle.duration = TRB.Data.spells.dismantle.cooldown
					end
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				TRB.Functions.RemoveTarget(destGUID)
				RefreshTargetTracking()
				triggerUpdate = true
			end

			if UnitIsDeadOrGhost("player") then -- We died/are dead go ahead and purge the list
				TargetsCleanup(true)
				triggerUpdate = true
			end
		end

		if triggerUpdate then
			TriggerResourceBarUpdates()
		end
	end)

	function targetsTimerFrame:onUpdate(sinceLastUpdate)
		local currentTime = GetTime()
		self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
		if self.sinceLastUpdate >= 1 then -- in seconds
			TargetsCleanup()
			RefreshTargetTracking()
			TriggerResourceBarUpdates()
			self.sinceLastUpdate = 0
		end
	end

	combatFrame:SetScript("OnEvent", function(self, event, ...)
		if event =="PLAYER_REGEN_DISABLED" then
			TRB.Functions.ShowResourceBar()
		else
			TRB.Functions.HideResourceBar()
		end
	end)

	local function SwitchSpec()
		local specId = GetSpecialization()
		if specId == 1 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.rogue.assassination)
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
			specCache.assassination.talents = TRB.Functions.GetTalents()
			FillSpellData_Assassination()
			TRB.Functions.LoadFromSpecCache(specCache.assassination)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Assassination

			if TRB.Data.barConstructedForSpec ~= "assassination" then
				TRB.Data.barConstructedForSpec = "assassination"
				ConstructResourceBar(specCache.assassination.settings)
			else
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		elseif specId == 2 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.rogue.outlaw)
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.outlaw)
			specCache.outlaw.talents = TRB.Functions.GetTalents()
			FillSpellData_Outlaw()
			TRB.Functions.LoadFromSpecCache(specCache.outlaw)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Outlaw

			if TRB.Data.barConstructedForSpec ~= "outlaw" then
				TRB.Data.barConstructedForSpec = "outlaw"
				ConstructResourceBar(specCache.outlaw.settings)
			else
				TRB.Functions.RepositionBar(TRB.Data.settings.rogue.outlaw, TRB.Frames.barContainerFrame)
			end
		end
		EventRegistration()
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
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					FillSpecCache()

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
							TRB.Data.settings.rogue.assassination = TRB.Functions.ValidateLsmValues("Assassination Rogue", TRB.Data.settings.rogue.assassination)
							TRB.Data.settings.rogue.outlaw = TRB.Functions.ValidateLsmValues("Outlaw Rogue", TRB.Data.settings.rogue.outlaw)
							--TRB.Data.settings.rogue.subtlety = TRB.Functions.ValidateLsmValues("Subtlety Rogue", TRB.Data.settings.rogue.subtlety)
							
							FillSpellData_Assassination()
							FillSpellData_Outlaw()
							--FillSpellData_Subtlety()
							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Rogue.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
							EventRegistration()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
					SwitchSpec()
				end
			end
		end
	end)
end
