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
			barTextVariables = {}
		},
		outlaw = {
			snapshotData = {},
			barTextVariables = {}
		},
		subtlety = {
			snapshotData = {},
			barTextVariables = {}
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
			}
		}

		specCache.assassination.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
            maxResource2 = 5,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
			talents = {
				--[[scentOfBlood = {
					isSelected = false
				},
				chimaeraShot = {
					isSelected = false
				},
				aMurderOfCrows = {
					isSelected = false
				},
				barrage = {
					isSelected = false
				}]]
			},
			items = {
				--raeshalareDeathsWhisper = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.assassination.spells = {
			-- Rogue Class Abilities
            ambush = {
				id = 8676,
				name = "",
				icon = "",
				energy = -50,
                comboPointsGenerated = 2,
                stealth = true,
				thresholdId = 1,
				settingKey = "ambush",
                --isSnowflake = true
				thresholdUsable = false
			},
			cheapShot = {
				id = 1833,
				name = "",
				icon = "",
				energy = -40,
                comboPointsGenerated = 1,
                stealth = true,
				thresholdId = 2,
				settingKey = "cheapShot",
				--isSnowflake = false,
				thresholdUsable = false
			},
			crimsonVial = {
				id = 185311,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 0,
				thresholdId = 3,
				settingKey = "crimsonVial",
				hasCooldown = true,
                cooldown = 30,
				thresholdUsable = false
			},
			distract = {
				id = 1725,
				name = "",
				icon = "",
				energy = -30,
                comboPointsGenerated = 0,
				thresholdId = 4,
				settingKey = "distract",
				hasCooldown = true,
                cooldown = 30,
				thresholdUsable = false
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
				thresholdId = 5,
				settingKey = "feint",
                hasCooldown = true,
                cooldown = 15,
				thresholdUsable = false
			},
			kidneyShot = {
				id = 408,
				name = "",
				icon = "",
				energy = -25,
                comboPoints = true,
				thresholdId = 6,
				settingKey = "kidneyShot",
                hasCooldown = true,
                cooldown = 20,
				thresholdUsable = false
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
				thresholdId = 7,
				settingKey = "sap",
				thresholdUsable = false
			},
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 1,
				thresholdId = 8,
				settingKey = "shiv",
                hasCooldown = true,
                cooldown = 25,
				thresholdUsable = false
			},
			sliceAndDice = {
				id = 315496,
				name = "",
				icon = "",
				energy = -25,
                comboPoints = true,
				thresholdId = 9,
				settingKey = "sliceAndDice",
                hasCooldown = false,
				thresholdUsable = false
			},

            -- Assassination Spec Abilities

			envenom = {
				id = 32645,
				name = "",
				icon = "",
				energy = -35,
                comboPoints = true,
				thresholdId = 10,
				settingKey = "envenom",
                hasCooldown = false,
				thresholdUsable = false
			},
			fanOfKnives = {
				id = 51723,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 1,
				thresholdId = 11,
				settingKey = "fanOfKnives",
                hasCooldown = false,
				thresholdUsable = false
			},
			garrote = {
				id = 703,
				name = "",
				icon = "",
				energy = -45,
                comboPointsGenerated = 1,
				thresholdId = 12,
				settingKey = "garrote",
                hasCooldown = true,
                cooldown = 6,
				thresholdUsable = false
			},
			mutilate = {
				id = 1329,
				name = "",
				icon = "",
				energy = -50,
                comboPointsGenerated = 2,
				thresholdId = 13,
				settingKey = "mutilate",
                hasCooldown = false,
				thresholdUsable = false
			},
			poisonedKnife = {
				id = 185565,
				name = "",
				icon = "",
				energy = -40,
                comboPointsGenerated = 1,
				thresholdId = 14,
				settingKey = "poisonedKnife",
                hasCooldown = false,
				thresholdUsable = false
			},
			rupture = {
				id = 1943,
				name = "",
				icon = "",
				energy = -25,
                comboPoints = true,
				thresholdId = 15,
				settingKey = "rupture",
                hasCooldown = false,
				thresholdUsable = false
			},
			vendetta = {
				id = 79140,
				name = "",
				icon = "",
				energy = 60,
                duration = 3
			},

            --[[
			barbedShot = {
				id = 217200,
				buffId = {
					246152,
					246851,
					246852,
					246853,
					246854
				},
				name = "",
				icon = "",
				energy = 5,
				ticks = 4,
				duration = 8,
				beastialWrathCooldownReduction = 12
			},

			aMurderOfCrows = {
				id = 131894,
				name = "",
				icon = "",
				energy = -30,
				thresholdId = 2,
				settingKey = "aMurderOfCrows",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 60
			},
			barrage = {
				id = 120360,
				name = "",
				icon = "",
				energy = -60,
				thresholdId = 3,
				settingKey = "barrage",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 20
			},


			chimaeraShot = {
				id = 342049,
				name = "",
				icon = "",
				energy = 10,
				isTalent = true
			},

			flayedShot = {
				id = 324149,
				name = "",
				icon = "",
			},
			flayersMark = {
				id = 324156,
				name = "",
				icon = "",
				isActive = false
			},

			nesingwarysTrappingApparatus = {
				id = 336744,
				name = "",
				icon = "",
				isActive = false,
				modifier = 2.0
			},

			frenzy = {
				id = 272790,
				name = "",
				icon = "",
				duration = 8,
				isActive = false
			},

			bloodletting = {
				id = 341440,
				name = "",
				icon = "",
				conduitId = 253
			},

			flamewakersCobraSting = {
				id = 336826,
				name = "",
				icon = "",
				isActive = false
			},

			-- Sylvanas Bow
			wailingArrow = {
				id = 355589,
				name = "",
				icon = "",
				energy = -15,
				thresholdId = 10,
				settingKey = "wailingArrow",
				isSnowflake = true,
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 60,
				itemId = 186414
			},
            ]]
		}

		specCache.assassination.snapshotData.energyRegen = 0
		specCache.assassination.snapshotData.comboPoints = 0
		specCache.assassination.snapshotData.audio = {
			overcapCue = false,
			--playedKillShotCue = false
		}
		specCache.assassination.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {}
		}
		--[[specCache.assassination.snapshotData.flayersMark = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}]]
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
		specCache.assassination.snapshotData.garrote = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		--[[specCache.assassination.snapshotData.flayedShot = {
			startTime = nil,
			duration = 0
		}
		specCache.assassination.snapshotData.nesingwarysTrappingApparatus = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.assassination.snapshotData.barbedShot = {
			-- Buff/Energy gain
			isActive = false,
			count = 0,
			ticksRemaining = 0,
			energy = 0,
			endTime = nil,
			list = {},
			-- Charges
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.assassination.snapshotData.beastialWrath = {
			startTime = nil,
			duration = 0
		}
		specCache.assassination.snapshotData.wailingArrow = {
			startTime = nil,
			duration = 0,
			enabled = false
		}

		specCache.assassination.snapshotData.frenzy = {
			endTime = nil,
			duration = 0,
			stacks = 0,
			spellId = 0
		}
        ]]

		specCache.assassination.barTextVariables = {
			icons = {},
			values = {}
		}


		-- Outlaw

        --[[
		specCache.outlaw.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				regen = 0
			},
			dots = {
			}
		}

		specCache.outlaw.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 2,
			maxResource = 100,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
			talents = {
				serpentSting = {
					isSelected = false
				},
				barrage = {
					isSelected = false
				},
				aMurderOfCrows = {
					isSelected = false
				},
				explosiveShot = {
					isSelected = false
				},
				steadyEnergy = {
					isSelected = false
				},
				chimaeraShot = {
					isSelected = false
				},
				deadEye = {
					isSelected = false
				},
				lockAndLoad = {
					isSelected = false
				}
			},
			items = {
				raeshalareDeathsWhisper = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.outlaw.spells = {
			aimedShot = {
				id = 19434,
				name = "",
				icon = "",
				energy = -35,
				thresholdId = 1,
				settingKey = "aimedShot",
				isSnowflake = true,
				thresholdUsable = false
			},
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				energy = -20,
				thresholdId = 2,
				settingKey = "arcaneShot",
				thresholdUsable = false
			},
			killShot = {
				id = 53351,
				name = "",
				icon = "",
				energy = -10,
				thresholdId = 5,
				settingKey = "killShot",
				healthMinimum = 0.2,
				isSnowflake = true,
				thresholdUsable = false
			},
			multiShot = {
				id = 257620,
				name = "",
				icon = "",
				energy = -20,
				thresholdId = 6,
				settingKey = "multiShot",
				thresholdUsable = false
			},
			scareBeast = {
				id = 1513,
				name = "",
				icon = "",
				energy = -25,
				thresholdId = 9,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			burstingShot = {
				id = 186387,
				name = "",
				icon = "",
				energy = -10,
				thresholdId = 10,
				settingKey = "burstingShot",
				hasCooldown = true,
				thresholdUsable = false
			},
			revivePet = {
				id = 982,
				name = "",
				icon = "",
				energy = -35,
				thresholdId = 11,
				settingKey = "revivePet",
				thresholdUsable = false
			},

			steadyShot = {
				id = 56641,
				name = "",
				icon = "",
				energy = 10
			},
			rapidFire = {
				id = 257044,
				name = "",
				icon = "",
				isActive = false,
				energy = 1,
				shots = 7,
				duration = 2 --On cast then every 1/3 sec, hasted
			},
			trickShots = { --TODO: Do these ricochets generate Energy from Rapid Fire Rank 2?
				id = 257044,
				name = "",
				icon = "",
				shots = 5
			},
			trueshot = {
				id = 288613,
				name = "",
				icon = "",
				isActive = false,
				modifier = 1.5
			},

			serpentSting = {
				id = 271788,
				name = "",
				icon = "",
				energy = -10,
				thresholdId = 3,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false,
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			barrage = {
				id = 120360,
				name = "",
				icon = "",
				energy = -30, -- -60 for non Outlaw,
				thresholdId = 4,
				settingKey = "barrage",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 20
			},
			aMurderOfCrows = {
				id = 131894,
				name = "",
				icon = "",
				energy = -20,
				thresholdId = 7,
				settingKey = "aMurderOfCrows",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 60
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				energy = -20,
				thresholdId = 8,
				settingKey = "explosiveShot",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			steadyEnergy = {
				id = 193534,
				name = "",
				icon = "",
				duration = 15,
				isActive = false
			},
			chimaeraShot = {
				id = 342049,
				name = "",
				icon = "",
				energy = -20,
				isTalent = true,
				thresholdId = 13,
				settingKey = "arcaneShot",
				thresholdUsable = false --Commenting out for now since it is the same energy as Arcane Shot
			},
			lockAndLoad = {
				id = 194594,
				name = "",
				icon = "",
				isActive = false
			},

			flayedShot = {
				id = 324149,
				name = "",
				icon = ""
			},
			flayersMark = {
				id = 324156,
				name = "",
				icon = "",
				isActive = false
			},

			nesingwarysTrappingApparatus = {
				id = 336744,
				name = "",
				icon = "",
				isActive = false,
				modifier = 2.0
			},

			secretsOfTheUnblinkingVigil = {
				id = 336892,
				name = "",
				icon = "",
				isActive = false
			},
			eagletalonsTrueEnergy = {
				id = 336851,
				name = "",
				icon = "",
				isActive = false,
				modifier = 0.25
			},

			-- Sylvanas Bow
			wailingArrow = {
				id = 355589,
				name = "",
				icon = "",
				energy = -15,
				thresholdId = 10,
				settingKey = "wailingArrow",
				isSnowflake = true,
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 60
			},

		}

		specCache.outlaw.snapshotData.energyRegen = 0
		specCache.outlaw.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false,
			playedAimedShotCue = true
		}
		specCache.outlaw.snapshotData.lockAndLoad = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.outlaw.snapshotData.trueshot = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.outlaw.snapshotData.steadyEnergy = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.outlaw.snapshotData.flayersMark = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.outlaw.snapshotData.aimedShot = {
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.killShot = {
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.burstingShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.outlaw.snapshotData.barrage = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.outlaw.snapshotData.aMurderOfCrows = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.outlaw.snapshotData.explosiveShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.outlaw.snapshotData.rapidFire = {
			startTime = nil,
			duration = 0,
			enabled = false,
			ticksRemaining = 0,
			energy = 0
		}
		specCache.outlaw.snapshotData.flayedShot = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshotData.secretsOfTheUnblinkingVigil = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.outlaw.snapshotData.nesingwarysTrappingApparatus = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.assassination.snapshotData.wailingArrow = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.outlaw.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			serpentSting = 0,
			targets = {}
		}

		specCache.outlaw.barTextVariables = {
			icons = {},
			values = {}
		}
        ]]

		-- Subtlety
		--[[
        specCache.subtlety.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				regen = 0,
				termsOfEngagement = 0
			},
			dots = {
				serpentSting = 0
			},
			termsOfEngagement = {
				energy = 0,
				ticks = 0
			}
		}

		specCache.subtlety.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 3,
			maxResource = 100,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
			talents = {
				vipersVenom = {
					isSelected = false
				},
				termsOfEngagement = {
					isSelected = false
				},
				butchery = {
					isSelected = false
				},
				aMurderOfCrows = {
					isSelected = false
				},
				mongooseBite = {
					isSelected = false
				},
				flankingStrike = {
					isSelected = false
				},
				chakrams = {
					isSelected = false
				}
			},
			items = {
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.subtlety.spells = {
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				energy = -40,
				thresholdId = 1,
				settingKey = "arcaneShot",
				thresholdUsable = false
			},
			killShot = {
				id = 320976,
				name = "",
				icon = "",
				energy = -10,
				thresholdId = 2,
				settingKey = "killShot",
				healthMinimum = 0.2,
				isSnowflake = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			scareBeast = {
				id = 1513,
				name = "",
				icon = "",
				energy = -25,
				thresholdId = 3,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			revivePet = {
				id = 982,
				name = "",
				icon = "",
				energy = -10,
				thresholdId = 4,
				settingKey = "revivePet",
				thresholdUsable = false
			},
			wingClip = {
				id = 195645,
				name = "",
				icon = "",
				energy = -20,
				thresholdId = 5,
				settingKey = "wingClip",
				thresholdUsable = false
			},

			steadyShot = {
				id = 56641,
				name = "",
				icon = ""
			},
			carve = {
				id = 187708,
				name = "",
				icon = "",
				energy = -35,
				thresholdId = 6,
				settingKey = "carve",
				isSnowflake = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			butchery = {
				id = 212436,
				name = "",
				icon = "",
				energy = -30,
				isTalent = true,
				hasCooldown = true,
				isSnowflake = true,
				thresholdId = 7,
				settingKey = "carve",
				thresholdUsable = false
			},
			raptorStrike = {
				id = 186270,
				name = "",
				icon = "",
				energy = -30,
				thresholdId = 8,
				settingKey = "raptorStrike",
				thresholdUsable = false
			},
			mongooseBite = {
				id = 259387,
				name = "",
				icon = "",
				energy = -30,
				isTalent = true,
				thresholdId = 8,
				settingKey = "raptorStrike",
				thresholdUsable = false --Commenting out for now since it is the same energy as Raptor Strike
			},
			harpoon = {
				id = 190925,
				name = "",
				icon = "",
				energy = 2,
				duration = 10 --2*10 = 20 total energy
			},
			killCommand = {
				id = 259489,
				name = "",
				icon = "",
				energy = 15
			},
			coordinatedAssault = {
				id = 266779,
				name = "",
				icon = "",
				isActive = false
			},

			serpentSting = {
				id = 259491,
				name = "",
				icon = "",
				energy = -20,
				thresholdId = 9,
				settingKey = "serpentSting",
				thresholdUsable = false,
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			flankingStrike = {
				id = 269751,
				name = "",
				icon = "",
				energy = 30,
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			aMurderOfCrows = {
				id = 131894,
				name = "",
				icon = "",
				energy = -30,
				thresholdId = 10,
				settingKey = "aMurderOfCrows",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 60
			},
			chakrams = {
				id = 259391,
				name = "",
				icon = "",
				energy = -15,
				thresholdId = 11,
				settingKey = "chakrams",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 20
			},

			flayedShot = {
				id = 324149,
				name = "",
				icon = ""
			},
			flayersMark = {
				id = 324156,
				name = "",
				icon = "",
				isActive = false
			},

			termsOfEngagement = {
				id = 265898,
				name = "",
				icon = "",
				energy = 2,
				ticks = 10,
				duration = 10
			},

			nesingwarysTrappingApparatus = {
				id = 336744,
				name = "",
				icon = "",
				isActive = false,
				modifier = 2.0
			},
		}

		specCache.subtlety.snapshotData.energyRegen = 0
		specCache.subtlety.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false
		}
		specCache.subtlety.snapshotData.coordinatedAssault = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.subtlety.snapshotData.termsOfEngagement = {
			isActive = false,
			ticksRemaining = 0,
			energy = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.subtlety.snapshotData.carve = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.subtlety.snapshotData.flayersMark = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.subtlety.snapshotData.flayedShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.subtlety.snapshotData.killShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.subtlety.snapshotData.aMurderOfCrows = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.subtlety.snapshotData.butchery = {
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.subtlety.snapshotData.chakrams = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.subtlety.snapshotData.flankingStrike = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.subtlety.snapshotData.nesingwarysTrappingApparatus = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.subtlety.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			serpentSting = 0,
			targets = {}
		}

		specCache.subtlety.barTextVariables = {
			icons = {},
			values = {}
		}
        ]]
	end

	local function Setup_Assassination()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.assassination)
	end

	local function Setup_Outlaw()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.outlaw)
	end

	local function Setup_Subtlety()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.subtlety)
	end

	local function FillSpellData_Assassination()
		Setup_Assassination()
		local spells = TRB.Functions.FillSpellData(specCache.assassination.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.assassination.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

            --[[
			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barbedShot", icon = spells.barbedShot.icon, description = "Barbed Shot", printInSettings = true },
			{ variable = "#barrage", icon = spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#beastialWrath", icon = spells.beastialWrath.icon, description = "Beastial Wrath", printInSettings = true },
			{ variable = "#chimaeraShot", icon = spells.chimaeraShot.icon, description = "Chimaera Shot", printInSettings = true },
			{ variable = "#cobraShot", icon = spells.cobraShot.icon, description = "Cobra Shot", printInSettings = true },
			{ variable = "#flayedShot", icon = spells.flayedShot.icon, description = "Flayed Shot", printInSettings = true },
			{ variable = "#flayersMark", icon = spells.flayersMark.icon, description = "Flayer's Mark", printInSettings = true },
			{ variable = "#frenzy", icon = spells.frenzy.icon, description = "Frenzy", printInSettings = true },
			{ variable = "#killCommand", icon = spells.killCommand.icon, description = "Kill Command", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#multiShot", icon = spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#nesingwarys", icon = spells.nesingwarysTrappingApparatus.icon, description = "Nesingwary'ss Trapping Apparatus", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#wailingArrow", icon = spells.wailingArrow.icon, description = "Wailing Arrow", printInSettings = true }
            ]]
        }
		specCache.assassination.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility% (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versatility", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility% (damage reduction/defensive)", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$energy", description = "Current Energy", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Energy", printInSettings = false, color = false },
			{ variable = "$energyMax", description = "Maximum Energy", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Energy", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			--{ variable = "$barbedShotEnergy", description = "Energy from Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },

            --[[
			{ variable = "$frenzyTime", description = "Time remaining on your pet's Frenzy buff", printInSettings = true, color = false },
			{ variable = "$frenzyStacks", description = "Current stack count on your pet's Frenzy buff", printInSettings = true, color = false },

			{ variable = "$barbedShotTicks", description = "Total number of Barbed Shot buff ticks remaining", printInSettings = true, color = false },
			{ variable = "$barbedShotTime", description = "Time remaining until the most recent Barbed Shot buff expires", printInSettings = true, color = false },

			{ variable = "$flayersMarkTime", description = "Time remaining on Flayer's Mark buff", printInSettings = true, color = false },

			{ variable = "$nesingwarysTime", description = "Time remaining on Nesingwary's Trapping Apparatus buff", printInSettings = true, color = false },

			{ variable = "$raeshalareEquipped", description = "Checks if you have Rae'shalare, Death's Whisper equipped. Logic variable only!", printInSettings = true, color = false },
            ]]

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.assassination.spells = spells
	end

	local function FillSpellData_Outlaw()
		Setup_Outlaw()
		local spells = TRB.Functions.FillSpellData(specCache.outlaw.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.outlaw.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#aimedShot", icon = spells.aimedShot.icon, description = "Aimed Shot", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barrage", icon = spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#burstingShot", icon = spells.burstingShot.icon, description = "Bursting Shot", printInSettings = true },
			{ variable = "#chimaeraShot", icon = spells.chimaeraShot.icon, description = "Chimaera Shot", printInSettings = true },
			{ variable = "#explosiveShot", icon = spells.explosiveShot.icon, description = "Explosive Shot", printInSettings = true },
			{ variable = "#flayedShot", icon = spells.flayedShot.icon, description = "Flayed Shot", printInSettings = true },
			{ variable = "#flayersMark", icon = spells.flayersMark.icon, description = "Flayer's Mark", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#lockAndLoad", icon = spells.lockAndLoad.icon, description = "Lock and Load", printInSettings = true },
			{ variable = "#multiShot", icon = spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#nesingwarys", icon = spells.nesingwarysTrappingApparatus.icon, description = "Nesingwary'ss Trapping Apparatus", printInSettings = true },
			{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = "Rapid Fire", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#steadyEnergy", icon = spells.steadyEnergy.icon, description = "Steady Energy", printInSettings = true },
			{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = "Steady Shot", printInSettings = true },
			{ variable = "#trickShots", icon = spells.trickShots.icon, description = "Trick Shots", printInSettings = true },
			{ variable = "#trueshot", icon = spells.trueshot.icon, description = "Trueshot", printInSettings = true },
			{ variable = "#vigil", icon = spells.secretsOfTheUnblinkingVigil.icon, description = "Secrets of the Unblinking Vigil", printInSettings = true },
			{ variable = "#wailingArrow", icon = spells.wailingArrow.icon, description = "Wailing Arrow", printInSettings = true }
        }
		specCache.outlaw.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility% (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versatility", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility% (damage reduction/defensive)", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$energy", description = "Current Energy", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Energy", printInSettings = false, color = false },
			{ variable = "$energyMax", description = "Maximum Energy", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Energy", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },

			{ variable = "$trueshotTime", description = "Time remaining on Trueshot buff", printInSettings = true, color = false },
			{ variable = "$lockAndLoadTime", description = "Time remaining on Lock and Load buff", printInSettings = true, color = false },

			{ variable = "$steadyEnergyTime", description = "Time remaining on Steady Energy buff", printInSettings = true, color = false },

			{ variable = "$serpentSting", description = "Is Serpent Sting talented? Logic variable only!", printInSettings = true, color = false },
			
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$ssTime", description = "Time remaining on Serpent Sting on your current target", printInSettings = true, color = false },

			{ variable = "$flayersMarkTime", description = "Time remaining on Flayer's Mark buff", printInSettings = true, color = false },

			{ variable = "$vigilTime", description = "Time remaining on Secrets of the Unblinking Vigil buff", printInSettings = true, color = false },
			{ variable = "$nesingwarysTime", description = "Time remaining on Nesingwary's Trapping Apparatus buff", printInSettings = true, color = false },

			{ variable = "$raeshalareEquipped", description = "Checks if you have Rae'shalare, Death's Whisper equipped. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.outlaw.spells = spells
	end

	local function FillSpellData_Subtlety()
		Setup_Subtlety()
		local spells = TRB.Functions.FillSpellData(specCache.subtlety.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.subtlety.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#butchery", icon = spells.butchery.icon, description = "Butchery", printInSettings = true },
			{ variable = "#carve", icon = spells.carve.icon, description = "Carve", printInSettings = true },
			{ variable = "#chakrams", icon = spells.chakrams.icon, description = "Chakrams", printInSettings = true },
			{ variable = "#coordinatedAssault", icon = spells.coordinatedAssault.icon, description = "Coordinated Assault", printInSettings = true },
			{ variable = "#ca", icon = spells.coordinatedAssault.icon, description = "Coordinated Assault", printInSettings = false },
			{ variable = "#flankingStrike", icon = spells.flankingStrike.icon, description = "Flanking Strike", printInSettings = true },
			{ variable = "#flayedShot", icon = spells.flayedShot.icon, description = "Flayed Shot", printInSettings = true },
			{ variable = "#flayersMark", icon = spells.flayersMark.icon, description = "Flayer's Mark", printInSettings = true },
			{ variable = "#harpoon", icon = spells.harpoon.icon, description = "Harpoon", printInSettings = true },
			{ variable = "#killCommand", icon = spells.killCommand.icon, description = "Kill Command", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#mongooseBite", icon = spells.mongooseBite.icon, description = "Mongoose Bite", printInSettings = true },
			{ variable = "#nesingwarys", icon = spells.nesingwarysTrappingApparatus.icon, description = "Nesingwary'ss Trapping Apparatus", printInSettings = true },
			{ variable = "#raptorStrike", icon = spells.raptorStrike.icon, description = "Raptor Strike", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = "Steady Shot", printInSettings = true },
			{ variable = "#termsOfEngagement", icon = spells.termsOfEngagement.icon, description = "Terms of Engagement", printInSettings = true },
			{ variable = "#wingClip", icon = spells.wingClip.icon, description = "Wing Clip", printInSettings = true },
        }
		specCache.subtlety.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility% (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versatility", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility% (damage reduction/defensive)", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$energy", description = "Current Energy", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Energy", printInSettings = false, color = false },
			{ variable = "$energyMax", description = "Maximum Energy", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Energy", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },

			{ variable = "$coordinatedAssaultTime", description = "Time remaining on Coordinated Assault buff", printInSettings = true, color = false },

			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$ssTime", description = "Time remaining on Serpent Sting on your current target", printInSettings = true, color = false },

			{ variable = "$toeEnergy", description = "Energy from Terms of Engagement", printInSettings = true, color = false },
			{ variable = "$toeTicks", description = "Number of ticks left on Terms of Engagement", printInSettings = true, color = false },

			{ variable = "$flayersMarkTime", description = "Time remaining on Flayer's Mark buff", printInSettings = true, color = false },

			{ variable = "$nesingwarysTime", description = "Time remaining on Nesingwary's Trapping Apparatus buff", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.subtlety.spells = spells
	end

	local function CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "rogue"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
        local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
        local settings = nil

		if specId == 1 then
            settings = TRB.Data.settings.rogue.assassination
			TRB.Data.character.specName = "assassination"
			--TRB.Data.character.talents.scentOfBlood.isSelected = select(4, GetTalentInfo(2, 1, TRB.Data.character.specGroup))
			--TRB.Data.character.talents.chimaeraShot.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			--TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
			--TRB.Data.character.talents.barrage.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
		--[[elseif specId == 2 then
			TRB.Data.character.specName = "outlaw"
			TRB.Data.character.talents.serpentSting.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.barrage.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.explosiveShot.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.steadyEnergy.isSelected = select(4, GetTalentInfo(4, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.chimaeraShot.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.deadEye.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.lockAndLoad.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
		elseif specId == 3 then
			TRB.Data.character.specName = "subtlety"
			TRB.Data.character.talents.vipersVenom.isSelected = select(4, GetTalentInfo(1, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.termsOfEngagement.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.butchery.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.mongooseBite.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.flankingStrike.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.chakrams.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))]]
		end

        
        if settings ~= nil and maxComboPoints ~= TRB.Data.character.maxResource2 then
            TRB.Data.character.maxResource2 = maxComboPoints
            TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
        end

        --[[
		if specId == 1 or specId == 2 then
			-- Legendaries
			local weaponItemLink = GetInventoryItemLink("player", 16)

			local raeshalareDeathsWhisper = false
			if weaponItemLink ~= nil  then
				raeshalareDeathsWhisper = TRB.Functions.DoesItemLinkMatchId(weaponItemLink, TRB.Data.spells.wailingArrow.itemId)
			end

			TRB.Data.character.items.raeshalareDeathsWhisper = raeshalareDeathsWhisper
		end
        ]]
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.rogue.assassination == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
			TRB.Data.specSupported = true
		--[[elseif specId == 2 and TRB.Data.settings.core.enabled.rogue.outlaw == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.outlaw)
			TRB.Data.specSupported = true
		elseif specId == 3 and TRB.Data.settings.core.enabled.rogue.subtlety == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.subtlety)
			TRB.Data.specSupported = true]]
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

	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
			--TRB.Data.snapshotData.targetData.targets[guid].serpentSting = false
			--TRB.Data.snapshotData.targetData.targets[guid].serpentStingRemaining = 0
		end
		TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()

		return true
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

    --[[
	local function GetNesingwarysRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.nesingwarysTrappingApparatus)
	end

	local function GetFrenzyRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.frenzy)
	end

	local function GetBeastialWrathCooldownRemainingTime()
		local currentTime = GetTime()
		local gcd = TRB.Functions.GetCurrentGCDTime(true)
		local remainingTime = 0

		if TRB.Data.snapshotData.beastialWrath.duration == gcd or TRB.Data.snapshotData.beastialWrath.startTime == 0 or TRB.Data.snapshotData.beastialWrath.duration == 0 then
			remainingTime = 0
		else
			remainingTime = (TRB.Data.snapshotData.beastialWrath.startTime + TRB.Data.snapshotData.beastialWrath.duration) - currentTime
		end

		return remainingTime
	end

	local function GetVigilRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.secretsOfTheUnblinkingVigil)
	end

	local function GetTrueshotRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.trueshot)
	end

	local function GetSteadyEnergyRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.steadyEnergy)
	end

	local function GetCoordinatedAssaultRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.coordinatedAssault)
	end

	local function GetLockAndLoadRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.lockAndLoad)
	end

	local function GetFlayersMarkRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.flayersMark)
	end
    ]]

    local function CalculateAbilityResourceValue(resource, threshold)
        local modifier = 1.0
		--[[if GetSpecialization() == 2 then
			if resource > 0 then
				if TRB.Data.spells.trueshot.isActive and not threshold then
					modifier = modifier * TRB.Data.spells.trueshot.modifier
				end
			end
		end

		if resource > 0 then
			if TRB.Data.spells.nesingwarysTrappingApparatus.isActive and not threshold then
				modifier = modifier * TRB.Data.spells.nesingwarysTrappingApparatus.modifier
			end
		else]]
			modifier = modifier * TRB.Data.character.effects.overgrowthSeedlingModifier * TRB.Data.character.torghast.rampaging.spellCostModifier
		--end

        return resource * modifier
    end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

        --[[
		if specId == 2 or specId == 3 then -- Outlaw or Subtlety
			local ssTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[guid].serpentSting = false
					TRB.Data.snapshotData.targetData.targets[guid].serpentStingRemaining = 0
				else
					if TRB.Data.snapshotData.targetData.targets[guid].serpentSting == true then
						ssTotal = ssTotal + 1
					end
				end
			end
			TRB.Data.snapshotData.targetData.serpentSting = ssTotal
		end
        ]]
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			--TRB.Data.snapshotData.targetData.serpentSting = 0
		end
	end

	local function ConstructResourceBar(settings)
		local entries = TRB.Functions.TableLength(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end

		local resourceFrameCounter = 1
        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
				if TRB.Frames.resourceFrame.thresholds[resourceFrameCounter] == nil then
					TRB.Frames.resourceFrame.thresholds[resourceFrameCounter] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[resourceFrameCounter]:Show()
				TRB.Frames.resourceFrame.thresholds[resourceFrameCounter]:SetFrameLevel(0)
				TRB.Frames.resourceFrame.thresholds[resourceFrameCounter]:Hide()
                resourceFrameCounter = resourceFrameCounter + 1
            end
        end

		TRB.Functions.ConstructResourceBar(settings)
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
		--[[elseif specId == 2 then
			settings = TRB.Data.settings.rogue.outlaw
		elseif specId == 3 then
			settings = TRB.Data.settings.rogue.subtlety]]
		end

		if specId == 1 then --Assassination
			--[[if var == "$barbedShotEnergy" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.energy > 0 then
					valid = true
				end
			elseif var == "$barbedShotTicks" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.energy > 0 then
					valid = true
				end
			elseif var == "$barbedShotTime" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.energy > 0 then
					valid = true
				end
			elseif var == "$frenzyTime" then
				if TRB.Data.snapshotData.frenzy.endTime ~= nil then
					valid = true
				end
			elseif var == "$frenzyStacks" then
				if TRB.Data.snapshotData.frenzy.stacks ~= nil and TRB.Data.snapshotData.frenzy.stacks > 0 then
					valid = true
				end
			end]]
		--[[elseif specId == 2 then --Outlaw
			if var == "$trueshotTime" then
				if GetTrueshotRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$steadyEnergyTime" then
				if GetSteadyEnergyRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$lockAndLoadTime" then
				if GetLockAndLoadRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$vigilTime" then
				if GetVigilRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$serpentSting" then
				if TRB.Data.character.talents.serpentSting.isSelected then
					valid = true
				end
			end
		elseif specId == 3 then --Survivial
			if var == "$coordinatedAssaultTime" then
				if GetCoordinatedAssaultRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$toeEnergy" then
				if TRB.Data.snapshotData.termsOfEngagement.energy > 0 then
					valid = true
				end
			elseif var == "$toeTicks" then
				if TRB.Data.snapshotData.termsOfEngagement.ticksRemaining > 0 then
					valid = true
				end
			end]]
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
			--[[elseif specId == 1 and IsValidVariableForSpec("$barbedShotEnergy") then
				valid = true
			elseif specId == 3 and TRB.Data.snapshotData.termsOfEngagement.energy > 0 then
				valid = true]]
			end
		elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		--[[elseif var == "$flayersMarkTime" or var == "$flayersMark" then
			if GetFlayersMarkRemainingTime() > 0 then
				valid = true
			end
		elseif var == "$nesingwarysTime" then
			if GetNesingwarysRemainingTime() > 0 then
				valid = true
			end
		elseif var == "$ssCount" then
			if TRB.Data.snapshotData.targetData.serpentSting > 0 then
				valid = true
			end
		elseif var == "$ssTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining > 0 then
				valid = true
			end]]
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
		local _regenEnergy = TRB.Data.snapshotData.energyRegen
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.assassination.generation.enabled then
			if TRB.Data.settings.rogue.assassination.generation.mode == "time" then
				_regenEnergy = _regenEnergy * (TRB.Data.settings.rogue.assassination.generation.time or 3.0)
			else
				_regenEnergy = _regenEnergy * ((TRB.Data.settings.rogue.assassination.generation.gcds or 2) * _gcd)
			end
		else
			_regenEnergy = 0
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _regenEnergy)

        --[[
		--$barbedShotEnergy
		local _barbedShotEnergy = TRB.Data.snapshotData.barbedShot.energy
		local barbedShotEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _barbedShotEnergy)

		--$barbedShotTicks
		local barbedShotTicks = string.format("%.0f", TRB.Data.snapshotData.barbedShot.ticksRemaining)

		--$barbedShotTime
		local barbedShotTime = 0
		local _barbedShotTime = (TRB.Data.snapshotData.barbedShot.endTime or 0) - currentTime
		if _barbedShotTime > 0 then
			barbedShotTime = string.format("%.1f", _barbedShotTime)
		end]]

		_passiveEnergy = _regenEnergy --+ _barbedShotEnergy
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

        --[[
		--$frenzyTime
		local _frenzyTime = GetFrenzyRemainingTime()
		local frenzyTime = 0
		if _frenzyTime ~= nil then
			frenzyTime = string.format("%.1f", _frenzyTime)
		end

		--$frenzyStacks
		local frenzyStacks = TRB.Data.snapshotData.frenzy.stacks or 0

		--$flayersMarkTime
		local _flayersMarkTime = GetFlayersMarkRemainingTime()
		local flayersMarkTime = 0
		if _flayersMarkTime ~= nil then
			flayersMarkTime = string.format("%.1f", _flayersMarkTime)
		end

		--$nesingwarysTime
		local _nesingwarysTime = GetNesingwarysRemainingTime()
		local nesingwarysTime = 0
		if _nesingwarysTime ~= nil then
			nesingwarysTime = string.format("%.1f", _nesingwarysTime)
		end
        ]]
		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		--[[Global_TwintopResourceBar.resource.barbedShot = _barbedShotEnergy
		Global_TwintopResourceBar.barbedShot = {
			count = TRB.Data.snapshotData.barbedShot.count,
			energy = TRB.Data.snapshotData.barbedShot.energy,
			ticks = TRB.Data.snapshotData.barbedShot.ticksRemaining,
			remaining = _barbedShotTime
		}]]

		local lookup = TRB.Data.lookup or {}
		--[[lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#barbedShot"] = TRB.Data.spells.barbedShot.icon
		lookup["#barrage"] = TRB.Data.spells.barrage.icon
		lookup["#beastialWrath"] = TRB.Data.spells.beastialWrath.icon
		lookup["#chimaeraShot"] = TRB.Data.spells.chimaeraShot.icon
		lookup["#cobraShot"] = TRB.Data.spells.cobraShot.icon
		lookup["#flayedShot"] = TRB.Data.spells.flayedShot.icon
		lookup["#flayersMark"] = TRB.Data.spells.flayersMark.icon
		lookup["#frenzy"] = TRB.Data.spells.frenzy.icon
		lookup["#killCommand"] = TRB.Data.spells.killCommand.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#multiShot"] = TRB.Data.spells.multiShot.icon
		lookup["#nesingwarys"] = TRB.Data.spells.nesingwarysTrappingApparatus.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["$frenzyTime"] = frenzyTime
		lookup["$frenzyStacks"] = frenzyStacks
		lookup["$nesingwarysTime"] = nesingwarysTime
		lookup["$flayersMarkTime"] = flayersMarkTime]]
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

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
			lookup["$passive"] = passiveEnergyMinusRegen
		else
			lookup["$passive"] = passiveEnergy
		end

		--lookup["$barbedShotEnergy"] = barbedShotEnergy
		--lookup["$barbedShotTicks"] = barbedShotTicks
		--lookup["$barbedShotTime"] = barbedShotTime
		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		TRB.Data.lookup = lookup
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
		local _regenEnergy = TRB.Data.snapshotData.energyRegen
		local _passiveEnergy

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.outlaw.generation.enabled then
			if TRB.Data.settings.rogue.outlaw.generation.mode == "time" then
				_regenEnergy = _regenEnergy * (TRB.Data.settings.rogue.outlaw.generation.time or 3.0)
			else
				_regenEnergy = _regenEnergy * ((TRB.Data.settings.rogue.outlaw.generation.gcds or 2) * _gcd)
			end
		else
			_regenEnergy = 0
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _regenEnergy)
		_passiveEnergy = _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _passiveEnergy)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)

		--$trueshotTime
		local _trueshotTime = GetTrueshotRemainingTime()
		local trueshotTime = 0
		if _trueshotTime ~= nil then
			trueshotTime = string.format("%.1f", _trueshotTime)
		end

		--$steadyEnergyTime
		local _steadyEnergyTime = GetSteadyEnergyRemainingTime()
		local steadyEnergyTime = 0
		if _steadyEnergyTime ~= nil then
			steadyEnergyTime = string.format("%.1f", _steadyEnergyTime)
		end

		--$lockAndLoadTime
		local _lockAndLoadTime = GetLockAndLoadRemainingTime()
		local lockAndLoadTime = 0
		if _lockAndLoadTime ~= nil then
			lockAndLoadTime = string.format("%.1f", _lockAndLoadTime)
		end

		--$flayersMarkTime
		local _flayersMarkTime = GetFlayersMarkRemainingTime()
		local flayersMarkTime = 0
		if _flayersMarkTime ~= nil then
			flayersMarkTime = string.format("%.1f", _flayersMarkTime)
		end

		--$nesingwarysTime
		local _nesingwarysTime = GetNesingwarysRemainingTime()
		local nesingwarysTime = 0
		if _nesingwarysTime ~= nil then
			nesingwarysTime = string.format("%.1f", _nesingwarysTime)
		end

		--$vigilTime
		local _vigilTime = GetVigilRemainingTime()
		local vigilTime = 0
		if _vigilTime ~= nil then
			vigilTime = string.format("%.1f", _vigilTime)
		end

		--$ssCount and $ssTime
		local _serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0
		local serpentStingCount = _serpentStingCount
		local _serpentStingTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_serpentStingTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining or 0
		end

		local serpentStingTime

		if TRB.Data.settings.rogue.outlaw.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining > TRB.Data.spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				else
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				end
			else
				serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
			end
		else
			serpentStingTime = string.format("%.1f", _serpentStingTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
		lookup["#aimedShot"] = TRB.Data.spells.aimedShot.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#barrage"] = TRB.Data.spells.barrage.icon
		lookup["#burstingShot"] = TRB.Data.spells.burstingShot.icon
		lookup["#chimaeraShot"] = TRB.Data.spells.chimaeraShot.icon
		lookup["#explosiveShot"] = TRB.Data.spells.explosiveShot.icon
		lookup["#flayedShot"] = TRB.Data.spells.flayedShot.icon
		lookup["#flayersMark"] = TRB.Data.spells.flayersMark.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#lockAndLoad"] = TRB.Data.spells.lockAndLoad.icon
		lookup["#multiShot"] = TRB.Data.spells.multiShot.icon
		lookup["#nesingwarys"] = TRB.Data.spells.nesingwarysTrappingApparatus.icon
		lookup["#rapidFire"] = TRB.Data.spells.rapidFire.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["#steadyEnergy"] = TRB.Data.spells.steadyEnergy.icon
		lookup["#steadyShot"] = TRB.Data.spells.steadyShot.icon
		lookup["#trickShots"] = TRB.Data.spells.trickShots.icon
		lookup["#trueshot"] = TRB.Data.spells.trueshot.icon
		lookup["#vigil"] = TRB.Data.spells.secretsOfTheUnblinkingVigil.icon
		lookup["$steadyEnergyTime"] = steadyEnergyTime
		lookup["$trueshotTime"] = trueshotTime
		lookup["$lockAndLoadTime"] = lockAndLoadTime
		lookup["$vigilTime"] = vigilTime
		lookup["$nesingwarysTime"] = nesingwarysTime
		lookup["$flayersMarkTime"] = flayersMarkTime
		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$ssCount"] = serpentStingCount
		lookup["$ssTime"] = serpentStingTime
		lookup["$energyTotal"] = energyTotal
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$energy"] = currentEnergy
		lookup["$resourcePlusCasting"] = energyPlusCasting
		lookup["$resourcePlusPassive"] = energyPlusPassive
		lookup["$resourceTotal"] = energyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentEnergy
		lookup["$casting"] = castingEnergy
		lookup["$passive"] = passiveEnergy
		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		TRB.Data.lookup = lookup
	end

	local function RefreshLookupData_Subtlety()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.rogue.subtlety.colors.text.current
		local castingEnergyColor = TRB.Data.settings.rogue.subtlety.colors.text.casting

		if TRB.Data.settings.rogue.subtlety.colors.text.overcapEnabled and overcap then
			currentEnergyColor = TRB.Data.settings.rogue.subtlety.colors.text.overcap
            castingEnergyColor = TRB.Data.settings.rogue.subtlety.colors.text.overcap
		elseif TRB.Data.settings.rogue.subtlety.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = TRB.Data.settings.rogue.subtlety.colors.text.overThreshold
				castingEnergyColor = TRB.Data.settings.rogue.subtlety.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.rogue.subtlety.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, TRB.Data.snapshotData.casting.resourceFinal)

		--$toeEnergy
		local _toeEnergy = TRB.Data.snapshotData.termsOfEngagement.energy
		local toeEnergy = string.format("%.0f", _toeEnergy)
		--$toeTicks
		local toeTicks = string.format("%.0f", TRB.Data.snapshotData.termsOfEngagement.ticksRemaining)

		local _regenEnergy = TRB.Data.snapshotData.energyRegen
		local _passiveEnergy

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.subtlety.generation.enabled then
			if TRB.Data.settings.rogue.subtlety.generation.mode == "time" then
				_regenEnergy = _regenEnergy * (TRB.Data.settings.rogue.subtlety.generation.time or 3.0)
			else
				_regenEnergy = _regenEnergy * ((TRB.Data.settings.rogue.subtlety.generation.gcds or 2) * _gcd)
			end
		else
			_regenEnergy = 0
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.subtlety.colors.text.passive, _regenEnergy)
		_passiveEnergy = _regenEnergy + _toeEnergy

		--$passive
		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.subtlety.colors.text.passive, _passiveEnergy)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)

		--$coordinatedAssaultTime
		local _coordinatedAssaultTime = GetCoordinatedAssaultRemainingTime()
		local coordinatedAssaultTime = 0
		if _coordinatedAssaultTime ~= nil then
			coordinatedAssaultTime = string.format("%.1f", _coordinatedAssaultTime)
		end

		--$flayersMarkTime
		local _flayersMarkTime = GetFlayersMarkRemainingTime()
		local flayersMarkTime = 0
		if _flayersMarkTime ~= nil then
			flayersMarkTime = string.format("%.1f", _flayersMarkTime)
		end

		--$nesingwarysTime
		local _nesingwarysTime = GetNesingwarysRemainingTime()
		local nesingwarysTime = 0
		if _nesingwarysTime ~= nil then
			nesingwarysTime = string.format("%.1f", _nesingwarysTime)
		end

		--$ssCount

		--$ssCount and $ssTime
		local _serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0
		local serpentStingCount = _serpentStingCount
		local _serpentStingTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_serpentStingTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining or 0
		end

		local serpentStingTime

		if TRB.Data.settings.rogue.subtlety.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining > TRB.Data.spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.subtlety.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.subtlety.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				else
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.subtlety.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.subtlety.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				end
			else
				serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.subtlety.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.subtlety.colors.text.dots.down, 0)
			end
		else
			serpentStingTime = string.format("%.1f", _serpentStingTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.resource.termsOfEngagement = _toeEnergy
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}
		Global_TwintopResourceBar.termsOfEngagement = {
			energy = _toeEnergy,
			ticks = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining or 0
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#butchery"] = TRB.Data.spells.butchery.icon
		lookup["#carve"] = TRB.Data.spells.carve.icon
		lookup["#chakrams"] = TRB.Data.spells.chakrams.icon
		lookup["#coordinatedAssault"] = TRB.Data.spells.coordinatedAssault.icon
		lookup["#ca"] = TRB.Data.spells.coordinatedAssault.icon
		lookup["#flankingStrike"] = TRB.Data.spells.flankingStrike.icon
		lookup["#flayedShot"] = TRB.Data.spells.flayedShot.icon
		lookup["#flayersMark"] = TRB.Data.spells.flayersMark.icon
		lookup["#harpoon"] = TRB.Data.spells.harpoon.icon
		lookup["#killCommand"] = TRB.Data.spells.killCommand.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#mongooseBite"] = TRB.Data.spells.mongooseBite.icon
		lookup["#nesingwarys"] = TRB.Data.spells.nesingwarysTrappingApparatus.icon
		lookup["#raptorStrike"] = TRB.Data.spells.raptorStrike.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["#steadyShot"] = TRB.Data.spells.steadyShot.icon
		lookup["#termsOfEngagement"] = TRB.Data.spells.termsOfEngagement.icon
		lookup["#wingClip"] = TRB.Data.spells.wingClip.icon
		lookup["$coordinatedAssaultTime"] = coordinatedAssaultTime
		lookup["$flayersMarkTime"] = flayersMarkTime
		lookup["$nesingwarysTime"] = nesingwarysTime
		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$ssCount"] = serpentStingCount
		lookup["$ssTime"] = serpentStingTime
		lookup["$energyTotal"] = energyTotal
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$energy"] = currentEnergy
		lookup["$resourcePlusCasting"] = energyPlusCasting
		lookup["$resourcePlusPassive"] = energyPlusPassive
		lookup["$resourceTotal"] = energyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentEnergy
		lookup["$casting"] = castingEnergy
		lookup["$passive"] = passiveEnergy
		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		lookup["$toeEnergy"] = toeEnergy
		lookup["$toeTicks"] = toeTicks
		TRB.Data.lookup = lookup
	end

    --[[
	local function UpdateRapidFire()
		if TRB.Data.snapshotData.rapidFire.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.rapidFire.endTime == nil or currentTime > TRB.Data.snapshotData.rapidFire.endTime then
				TRB.Data.snapshotData.rapidFire.ticksRemaining = 0
				TRB.Data.snapshotData.rapidFire.endTime = nil
				TRB.Data.snapshotData.rapidFire.energy = 0
				TRB.Data.snapshotData.rapidFire.isActive = false
			else
				TRB.Data.snapshotData.rapidFire.ticksRemaining = math.ceil((TRB.Data.snapshotData.rapidFire.endTime - currentTime) / (TRB.Data.snapshotData.rapidFire.duration / (TRB.Data.spells.rapidFire.shots - 1)))
				TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.snapshotData.rapidFire.ticksRemaining * TRB.Data.spells.rapidFire.energy
				TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
				TRB.Data.snapshotData.rapidFire.energy = TRB.Data.snapshotData.casting.resourceFinal
			end
		end
	end
    ]]

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
			if specId == 1 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					--[[if spellName == TRB.Data.spells.barrage.name then
						TRB.Data.spells.barrage.thresholdUsable = false
					else]]
						TRB.Functions.ResetCastingSnapshotData()
						return false
					--end
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					--[[if spellName == TRB.Data.spells.scareBeast.name then
						FillSnapshotDataCasting(TRB.Data.spells.scareBeast)
					elseif spellName == TRB.Data.spells.revivePet.name then
						FillSnapshotDataCasting(TRB.Data.spells.revivePet)
					else]]
						return false
					--end
				end
			--[[elseif specId == 2 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					if spellName == TRB.Data.spells.rapidFire.name then
						TRB.Data.snapshotData.rapidFire.isActive = true
						TRB.Data.snapshotData.rapidFire.duration = (select(5, UnitChannelInfo("player")) - select(4, UnitChannelInfo("player"))) / 1000
						TRB.Data.snapshotData.rapidFire.endTime = select(5, UnitChannelInfo("player")) / 1000
						TRB.Data.snapshotData.casting.startTime = select(4, UnitChannelInfo("player")) / 1000
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.rapidFire.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.rapidFire.icon
						UpdateRapidFire()
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				else
					local spellName = select(1, currentSpell)
					if spellName == TRB.Data.spells.aimedShot.name then
						FillSnapshotDataCasting(TRB.Data.spells.aimedShot)
					elseif spellName == TRB.Data.spells.steadyShot.name then
						FillSnapshotDataCasting(TRB.Data.spells.steadyShot)
					elseif spellName == TRB.Data.spells.scareBeast.name then
						FillSnapshotDataCasting(TRB.Data.spells.scareBeast)
					elseif spellName == TRB.Data.spells.revivePet.name then
						FillSnapshotDataCasting(TRB.Data.spells.revivePet)
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
					UpdateCastingResourceFinal()
				end
				return true
			elseif specId == 3 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					TRB.Functions.ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					if spellName == TRB.Data.spells.scareBeast.name then
						FillSnapshotDataCasting(TRB.Data.spells.scareBeast)
					elseif spellName == TRB.Data.spells.revivePet.name then
						FillSnapshotDataCasting(TRB.Data.spells.revivePet)
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				end]]
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		end
	end

    --[[
	local function UpdateTermsOfEngagement()
		if TRB.Data.snapshotData.termsOfEngagement.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.termsOfEngagement.endTime == nil or currentTime > TRB.Data.snapshotData.termsOfEngagement.endTime then
				TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = 0
				TRB.Data.snapshotData.termsOfEngagement.endTime = nil
				TRB.Data.snapshotData.termsOfEngagement.energy = 0
				TRB.Data.snapshotData.termsOfEngagement.isActive = false
			else
				TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = math.ceil((TRB.Data.snapshotData.termsOfEngagement.endTime - currentTime) / (TRB.Data.spells.termsOfEngagement.duration / TRB.Data.spells.termsOfEngagement.ticks))
				TRB.Data.snapshotData.termsOfEngagement.energy = CalculateAbilityResourceValue(TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.energy)
			end
		end
	end

	local function UpdateBarbedShot()
		local entries = TRB.Functions.TableLength(TRB.Data.snapshotData.barbedShot.list)
		local totalEnergy = 0
		local totalTicksRemaining = 0
		local longestRemaining = 0
		local maxEndTime = nil
		local activeCount = 0
		if entries > 0 then
			local currentTime = GetTime()

			for x = entries, 1, -1 do
				if TRB.Data.snapshotData.barbedShot.list[x].endTime == nil or currentTime > TRB.Data.snapshotData.barbedShot.list[x].endTime then
					table.remove(TRB.Data.snapshotData.barbedShot.list, x)
				else
					activeCount = activeCount + 1
					TRB.Data.snapshotData.barbedShot.isActive = true
					TRB.Data.snapshotData.barbedShot.list[x].ticksRemaining = math.ceil((TRB.Data.snapshotData.barbedShot.list[x].endTime - currentTime) / (TRB.Data.spells.barbedShot.duration / TRB.Data.spells.barbedShot.ticks))
					TRB.Data.snapshotData.barbedShot.list[x].energy = CalculateAbilityResourceValue(TRB.Data.snapshotData.barbedShot.list[x].ticksRemaining * TRB.Data.spells.barbedShot.energy)
					totalEnergy = totalEnergy + TRB.Data.snapshotData.barbedShot.list[x].energy
					totalTicksRemaining = totalTicksRemaining + TRB.Data.snapshotData.barbedShot.list[x].ticksRemaining

					if TRB.Data.snapshotData.barbedShot.list[x].endTime > (maxEndTime or 0) then
						maxEndTime = TRB.Data.snapshotData.barbedShot.list[x].endTime
					end
				end
			end
		end

		if activeCount > 0 then
			TRB.Data.snapshotData.barbedShot.isActive = true
		else
			TRB.Data.snapshotData.barbedShot.isActive = false
		end
		TRB.Data.snapshotData.barbedShot.count = activeCount
		TRB.Data.snapshotData.barbedShot.energy = totalEnergy
		TRB.Data.snapshotData.barbedShot.ticksRemaining = totalTicksRemaining
		TRB.Data.snapshotData.barbedShot.endTime = maxEndTime

		-- Recharge info
		TRB.Data.snapshotData.barbedShot.charges, _, TRB.Data.snapshotData.barbedShot.startTime, TRB.Data.snapshotData.barbedShot.duration, _ = GetSpellCharges(TRB.Data.spells.barbedShot.id)
	end
    ]]

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()

        --[[
        if TRB.Data.snapshotData.aMurderOfCrows.startTime ~= nil and currentTime > (TRB.Data.snapshotData.aMurderOfCrows.startTime + TRB.Data.snapshotData.aMurderOfCrows.duration) then
            TRB.Data.snapshotData.aMurderOfCrows.startTime = nil
            TRB.Data.snapshotData.aMurderOfCrows.duration = 0
        end

        if TRB.Data.snapshotData.flayedShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.flayedShot.startTime + TRB.Data.snapshotData.flayedShot.duration) then
            TRB.Data.snapshotData.flayedShot.startTime = nil
            TRB.Data.snapshotData.flayedShot.duration = 0
        end
        ]]
	end

	local function UpdateSnapshot_Assassination()
		UpdateSnapshot()
		--UpdateBarbedShot()
		local currentTime = GetTime()
		local _

        --[[
        if TRB.Data.snapshotData.barrage.startTime ~= nil and currentTime > (TRB.Data.snapshotData.barrage.startTime + TRB.Data.snapshotData.barrage.duration) then
			TRB.Data.snapshotData.barrage.startTime = nil
            TRB.Data.snapshotData.barrage.duration = 0
		end

		if TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration) then
            TRB.Data.snapshotData.killShot.startTime = nil
            TRB.Data.snapshotData.killShot.duration = 0
        end

		if TRB.Data.snapshotData.killCommand.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killCommand.startTime + TRB.Data.snapshotData.killCommand.duration) then
            TRB.Data.snapshotData.killCommand.startTime = nil
            TRB.Data.snapshotData.killCommand.duration = 0
		elseif TRB.Data.snapshotData.killCommand.startTime ~= nil then
			TRB.Data.snapshotData.killCommand.startTime, TRB.Data.snapshotData.killCommand.duration, _, _ = GetSpellCooldown(TRB.Data.spells.killCommand.id)
        end

		if TRB.Data.character.items.raeshalareDeathsWhisper then
			if TRB.Data.snapshotData.wailingArrow.startTime ~= nil and currentTime > (TRB.Data.snapshotData.wailingArrow.startTime + TRB.Data.snapshotData.wailingArrow.duration) then
				TRB.Data.snapshotData.wailingArrow.startTime = nil
				TRB.Data.snapshotData.wailingArrow.duration = 0
			end
		end

		_, _, TRB.Data.snapshotData.frenzy.stacks, _, TRB.Data.snapshotData.frenzy.duration, TRB.Data.snapshotData.frenzy.endTime, _, _, _, TRB.Data.snapshotData.frenzy.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.frenzy.id, "pet")
		TRB.Data.snapshotData.beastialWrath.startTime, TRB.Data.snapshotData.beastialWrath.duration, _, _ = GetSpellCooldown(TRB.Data.spells.beastialWrath.id)
        ]]
	end

	local function UpdateSnapshot_Outlaw()
		UpdateSnapshot()
		UpdateRapidFire()
		local currentTime = GetTime()
		local _

        TRB.Data.snapshotData.aimedShot.charges, _, TRB.Data.snapshotData.aimedShot.startTime, TRB.Data.snapshotData.aimedShot.duration, _ = GetSpellCharges(TRB.Data.spells.aimedShot.id)
        TRB.Data.snapshotData.killShot.charges, _, TRB.Data.snapshotData.killShot.startTime, TRB.Data.snapshotData.killShot.duration, _ = GetSpellCharges(TRB.Data.spells.killShot.id)

        if TRB.Data.snapshotData.burstingShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.burstingShot.startTime + TRB.Data.snapshotData.burstingShot.duration) then
            TRB.Data.snapshotData.burstingShot.startTime = nil
            TRB.Data.snapshotData.burstingShot.duration = 0
        end

        if TRB.Data.snapshotData.barrage.startTime ~= nil and currentTime > (TRB.Data.snapshotData.barrage.startTime + TRB.Data.snapshotData.barrage.duration) then
            TRB.Data.snapshotData.barrage.startTime = nil
            TRB.Data.snapshotData.barrage.duration = 0
        end

        if TRB.Data.snapshotData.explosiveShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.explosiveShot.startTime + TRB.Data.snapshotData.explosiveShot.duration) then
            TRB.Data.snapshotData.explosiveShot.startTime = nil
            TRB.Data.snapshotData.explosiveShot.duration = 0
        end

        if TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime ~= nil and currentTime > (TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime + TRB.Data.snapshotData.flayedShot.duration) then
            TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime = nil
            TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration = 0
        end

		if TRB.Data.character.items.raeshalareDeathsWhisper then
			if TRB.Data.snapshotData.wailingArrow.startTime ~= nil and currentTime > (TRB.Data.snapshotData.wailingArrow.startTime + TRB.Data.snapshotData.wailingArrow.duration) then
				TRB.Data.snapshotData.wailingArrow.startTime = nil
				TRB.Data.snapshotData.wailingArrow.duration = 0
			end
		end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
			local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.serpentSting.id, "target", "player"))

			if expiration ~= nil then
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining = expiration - currentTime
			end
		end
	end

	local function UpdateSnapshot_Subtlety()
		UpdateSnapshot()
		UpdateTermsOfEngagement()
		local currentTime = GetTime()
        local _

		TRB.Data.snapshotData.butchery.charges, _, TRB.Data.snapshotData.butchery.startTime, TRB.Data.snapshotData.butchery.duration, _ = GetSpellCharges(TRB.Data.spells.butchery.id)

		if TRB.Data.snapshotData.carve.startTime ~= nil and currentTime > (TRB.Data.snapshotData.carve.startTime + TRB.Data.snapshotData.carve.duration) then
            TRB.Data.snapshotData.carve.startTime = nil
            TRB.Data.snapshotData.carve.duration = 0
        end

		if TRB.Data.snapshotData.chakrams.startTime ~= nil and currentTime > (TRB.Data.snapshotData.chakrams.startTime + TRB.Data.snapshotData.chakrams.duration) then
            TRB.Data.snapshotData.chakrams.startTime = nil
            TRB.Data.snapshotData.chakrams.duration = 0
        end

		if TRB.Data.snapshotData.flankingStrike.startTime ~= nil and currentTime > (TRB.Data.snapshotData.flankingStrike.startTime + TRB.Data.snapshotData.flankingStrike.duration) then
            TRB.Data.snapshotData.flankingStrike.startTime = nil
            TRB.Data.snapshotData.flankingStrike.duration = 0
        end

		if TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration) then
            TRB.Data.snapshotData.killShot.startTime = nil
            TRB.Data.snapshotData.killShot.duration = 0
        end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
			local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.serpentSting.id, "target", "player"))

			if expiration ~= nil then
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining = expiration - currentTime
			end
		end
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
		--[[elseif specId == 2 then
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
		elseif specId == 3 then			
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.rogue.subtlety.displayBar.alwaysShow) and (
						(not TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow) or
						(TRB.Data.settings.rogue.subtlety.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.rogue.subtlety.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end]]
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

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.assassination, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.rogue.assassination.thresholdWidth, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
							local frameLevel = 129

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								--[[if spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local flayersMarkTime = GetFlayersMarkRemainingTime()
									if (UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum) and flayersMarkTime == 0 then
										showThreshold = false
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif flayersMarkTime == 0 and (TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime < (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration)) then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
										frameLevel = 127
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.resource >= -energyAmount or flayersMarkTime > 0 then
										if TRB.Data.settings.rogue.assassination.audio.killShot.enabled and not TRB.Data.snapshotData.audio.playedKillShotCue then
											TRB.Data.snapshotData.audio.playedKillShotCue = true
											PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = 128
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									end
								elseif spell.id == TRB.Data.spells.killCommand.id then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -energyAmount or TRB.Data.spells.flamewakersCobraSting.isActive then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.wailingArrow.id then
									if TRB.Data.character.items.raeshalareDeathsWhisper then
										if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = 128
										end
									else
										showThreshold = false
									end
								end]]
							elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
									frameLevel = 127
								elseif TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
									frameLevel = 128
								end
							end

                            if spell.comboPoints == true and TRB.Data.snapshotData.resource2 == 0 then
                                thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
                                frameLevel = 127
                            end

							if TRB.Data.settings.rogue.assassination.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == 129 then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
					end

					local barColor = TRB.Data.settings.rogue.assassination.colors.bar.base

					local latency = TRB.Functions.GetLatency()

					local affectingCombat = UnitAffectingCombat("player")
					--[[local barbedShotRechargeRemaining = -(currentTime - (TRB.Data.snapshotData.barbedShot.startTime + TRB.Data.snapshotData.barbedShot.duration))
					local barbedShotTotalRechargeRemaining = barbedShotRechargeRemaining + ((1 - TRB.Data.snapshotData.barbedShot.charges) * TRB.Data.snapshotData.barbedShot.duration)
					local barbedShotPartialCharges = TRB.Data.snapshotData.barbedShot.charges + (barbedShotRechargeRemaining / TRB.Data.snapshotData.barbedShot.duration)
					local beastialWrathCooldownRemaining = GetBeastialWrathCooldownRemainingTime()
					local frenzyRemainingTime = GetFrenzyRemainingTime()
					local reactionTimeGcds = math.min(gcd * 1.5, 2)

					if TRB.Data.spells.frenzy.isActive then
						if TRB.Data.snapshotData.barbedShot.charges == 2 then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
						elseif TRB.Data.snapshotData.barbedShot.charges == 1 and frenzyRemainingTime <= reactionTimeGcds then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
						elseif barbedShotTotalRechargeRemaining <= reactionTimeGcds and beastialWrathCooldownRemaining > 0 then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
						elseif barbedShotRechargeRemaining <= reactionTimeGcds and TRB.Data.snapshotData.barbedShot.charges == 1 then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
						elseif TRB.Data.character.talents.scentOfBlood.isSelected and barbedShotTotalRechargeRemaining <= reactionTimeGcds and beastialWrathCooldownRemaining < (TRB.Data.spells.barbedShot.beastialWrathCooldownReduction + reactionTimeGcds) then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
						elseif TRB.Data.character.talents.scentOfBlood.isSelected and TRB.Data.snapshotData.barbedShot.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * TRB.Data.spells.barbedShot.beastialWrathCooldownReduction) then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
						end
					else]]
						if affectingCombat then
							--[[if TRB.Data.snapshotData.barbedShot.charges == 2 then
								barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
							elseif TRB.Data.character.talents.scentOfBlood.isSelected and TRB.Data.snapshotData.barbedShot.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * TRB.Data.spells.barbedShot.beastialWrathCooldownReduction) then
								barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
							elseif barbedShotTotalRechargeRemaining <= reactionTimeGcds then
								barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyUse
							else
								barColor = TRB.Data.settings.rogue.assassination.colors.bar.frenzyHold
							end]]
						end
					--end

					local barBorderColor = TRB.Data.settings.rogue.assassination.colors.bar.border

					if TRB.Data.settings.rogue.assassination.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.rogue.assassination.colors.bar.borderOvercap

						if TRB.Data.settings.rogue.assassination.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					--[[if beastialWrathCooldownRemaining <= gcd and affectingCombat then
						if TRB.Data.settings.rogue.assassination.bar.beastialWrathEnabled then
							barBorderColor = TRB.Data.settings.rogue.assassination.colors.bar.borderBeastialWrath
						end

						if TRB.Data.settings.rogue.assassination.colors.bar.flashEnabled then
							TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.rogue.assassination.colors.bar.flashAlpha, TRB.Data.settings.rogue.assassination.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end
					else]]
						barContainerFrame:SetAlpha(1.0)
					--end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
            
                    for x = 1, TRB.Data.character.maxResource2 do
                        if TRB.Data.snapshotData.resource2 >= x then
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if x == (TRB.Data.character.maxResource2 - 1) then
								TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.penultimate, true))
							elseif x == TRB.Data.character.maxResource2 then
								TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.final, true))
							else
								TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.base, true))
							end
                        else
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
                        end
                    end
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.rogue.assassination, refreshText)
		--[[elseif specId == 2 then
			UpdateSnapshot_Outlaw()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.rogue.outlaw, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.rogue.outlaw.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					local borderColor = TRB.Data.settings.rogue.outlaw.colors.bar.border
					if TRB.Data.settings.rogue.outlaw.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						borderColor = TRB.Data.settings.rogue.outlaw.colors.bar.borderOvercap

						if TRB.Data.settings.rogue.outlaw.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					if UnitAffectingCombat("player") and TRB.Data.settings.rogue.outlaw.steadyEnergy.enabled and TRB.Data.character.talents.steadyEnergy.isSelected then
						local timeThreshold = 0

						if TRB.Data.settings.rogue.outlaw.steadyEnergy.mode == "gcd" then
							local gcd = TRB.Functions.GetCurrentGCDTime()
							timeThreshold = gcd * TRB.Data.settings.rogue.outlaw.steadyEnergy.gcdsMax
						elseif TRB.Data.settings.rogue.outlaw.steadyEnergy.mode == "time" then
							timeThreshold = TRB.Data.settings.rogue.outlaw.steadyEnergy.timeMax
						end

						if GetSteadyEnergyRemainingTime() <= timeThreshold then
							borderColor = TRB.Data.settings.rogue.outlaw.colors.bar.borderSteadyEnergy
						end
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(borderColor, true))

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

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.outlaw, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.rogue.outlaw.thresholdWidth, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
							local frameLevel = 129

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.aimedShot.id then
									if TRB.Data.snapshotData.aimedShot.charges == 0 and not TRB.Data.spells.lockAndLoad.isActive then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.spells.lockAndLoad.isActive or TRB.Data.snapshotData.resource >= -energyAmount or TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration > 0 then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
										frameLevel = 128
									end

									if TRB.Data.settings.rogue.outlaw.audio.aimedShot.enabled and (not TRB.Data.snapshotData.audio.playedAimedShotCue) and TRB.Data.snapshotData.aimedShot.charges >= 1 then
										local remainingCd = ((TRB.Data.snapshotData.aimedShot.startTime + TRB.Data.snapshotData.aimedShot.duration) - currentTime)
										local timeThreshold = 0
										local castTime = select(4, GetSpellInfo(spell.id)) / 1000
										if TRB.Data.settings.rogue.outlaw.audio.aimedShot.mode == "gcd" then
											timeThreshold = gcd * TRB.Data.settings.rogue.outlaw.audio.aimedShot.gcds
										elseif TRB.Data.settings.rogue.outlaw.audio.aimedShot.mode == "time" then
											timeThreshold = TRB.Data.settings.rogue.outlaw.audio.aimedShot.time
										end

										timeThreshold = timeThreshold + castTime

										if TRB.Data.snapshotData.aimedShot.charges == 2 or timeThreshold >= remainingCd then
											TRB.Data.snapshotData.audio.playedAimedShotCue = true
											PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
									elseif TRB.Data.snapshotData.aimedShot.charges == 2 then
										TRB.Data.snapshotData.audio.playedAimedShotCue = true
									end
								elseif spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local flayersMarkTime = GetFlayersMarkRemainingTime()
									if (UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum) and flayersMarkTime == 0 then
										showThreshold = false
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.killShot.charges == 0 and flayersMarkTime == 0 then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
										frameLevel = 127
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.resource >= -energyAmount or flayersMarkTime > 0 then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										if TRB.Data.settings.rogue.outlaw.audio.killShot.enabled and not TRB.Data.snapshotData.audio.playedKillShotCue then
											TRB.Data.snapshotData.audio.playedKillShotCue = true
											PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
									else
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
										frameLevel = 128
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									end
								elseif spell.id == TRB.Data.spells.wailingArrow.id then
									if TRB.Data.character.items.raeshalareDeathsWhisper then
										if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
											frameLevel = 128
										end
									else
										showThreshold = false
									end
								end
							elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.unusable
									frameLevel = 127
								elseif TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.rogue.outlaw.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == 129 then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
					end

					local barColor = TRB.Data.settings.rogue.outlaw.colors.bar.base

					if TRB.Data.spells.trueshot.isActive then
						local timeThreshold = 0
						local useEndOfTrueshotColor = false

						if TRB.Data.settings.rogue.outlaw.endOfTrueshot.enabled then
							useEndOfTrueshotColor = true
							if TRB.Data.settings.rogue.outlaw.endOfTrueshot.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.rogue.outlaw.endOfTrueshot.gcdsMax
							elseif TRB.Data.settings.rogue.outlaw.endOfTrueshot.mode == "time" then
								timeThreshold = TRB.Data.settings.rogue.outlaw.endOfTrueshot.timeMax
							end
						end

						if useEndOfTrueshotColor and GetTrueshotRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.rogue.outlaw.colors.bar.trueshotEnding
						else
							barColor = TRB.Data.settings.rogue.outlaw.colors.bar.trueshot
						end
					end
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.rogue.outlaw, refreshText)
		elseif specId == 3 then
			UpdateSnapshot_Subtlety()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.rogue.subtlety, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.rogue.subtlety.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					if TRB.Data.settings.rogue.subtlety.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.borderOvercap, true))

						if TRB.Data.settings.rogue.subtlety.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					local passiveValue = 0
					if TRB.Data.settings.rogue.subtlety.bar.showPassive then
						if TRB.Data.settings.rogue.subtlety.generation.enabled then
							if TRB.Data.settings.rogue.subtlety.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.rogue.subtlety.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.rogue.subtlety.generation.gcds or 2) * gcd))
							end
						end

						passiveValue = passiveValue + TRB.Data.snapshotData.termsOfEngagement.energy
					end

					if CastingSpell() and TRB.Data.settings.rogue.subtlety.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.subtlety, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.subtlety.colors.bar.passive, true))
					end

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.subtlety, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.rogue.subtlety.thresholdWidth, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.over
							local frameLevel = 129

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local flayersMarkTime = GetFlayersMarkRemainingTime()
									if (UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum) and flayersMarkTime == 0 then
										showThreshold = false
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif flayersMarkTime == 0 and (TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime < (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration)) then
										thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.unusable
										frameLevel = 127
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.resource >= -energyAmount or flayersMarkTime > 0 then
										if TRB.Data.settings.rogue.subtlety.audio.killShot.enabled and not TRB.Data.snapshotData.audio.playedKillShotCue then
											TRB.Data.snapshotData.audio.playedKillShotCue = true
											PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
										thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.under
										frameLevel = 128
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									end
								elseif spell.id == TRB.Data.spells.carve.id then
									if TRB.Data.character.talents.butchery.isSelected then
										showThreshold = false
									else
										if TRB.Data.snapshotData.carve.startTime ~= nil and currentTime < (TRB.Data.snapshotData.carve.startTime + TRB.Data.snapshotData.carve.duration) then
											thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.under
											frameLevel = 128
										end
									end
								elseif spell.id == TRB.Data.spells.butchery.id then
									if not TRB.Data.character.talents.butchery.isSelected then
										showThreshold = false
									else
										if TRB.Data.snapshotData.butchery.charges == 0 then
											thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.under
											frameLevel = 128
										end
									end
								end
							elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.unusable
									frameLevel = 127
								elseif TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.rogue.subtlety.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.rogue.subtlety.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == 129 then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
					end

					local barColor = TRB.Data.settings.rogue.subtlety.colors.bar.base
					if TRB.Data.settings.rogue.subtlety.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						if TRB.Data.settings.rogue.subtlety.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					if TRB.Data.spells.coordinatedAssault.isActive then
						local timeThreshold = 0
						local useEndOfCoordinatedAssaultColor = false

						if TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.enabled then
							useEndOfCoordinatedAssaultColor = true
							if TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.gcdsMax
							elseif TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.mode == "time" then
								timeThreshold = TRB.Data.settings.rogue.subtlety.endOfCoordinatedAssault.timeMax
							end
						end

						if useEndOfCoordinatedAssaultColor and GetCoordinatedAssaultRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssaultEnding
						else
							barColor = TRB.Data.settings.rogue.subtlety.colors.bar.coordinatedAssault
						end
					end
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.rogue.subtlety, refreshText)
            ]]
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 and specId ~= 3 then
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
					if spellId == TRB.Data.spells.crimsonVial.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.crimsonVial.startTime = currentTime
							TRB.Data.snapshotData.crimsonVial.duration = TRB.Data.spells.crimsonVial.cooldown
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
                    elseif spellId == TRB.Data.spells.garrote.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.garrote.startTime = currentTime
							TRB.Data.snapshotData.garrote.duration = TRB.Data.spells.garrote.cooldown
						end
                    end
					--[[elseif spellId == TRB.Data.spells.barbedShot.id then
						if type == "SPELL_CAST_SUCCESS" then -- Barbed Shot
							TRB.Data.snapshotData.barbedShot.charges, _, TRB.Data.snapshotData.barbedShot.startTime, TRB.Data.snapshotData.barbedShot.duration, _ = GetSpellCharges(TRB.Data.spells.barbedShot.id)
						end
					elseif spellId == TRB.Data.spells.barbedShot.buffId[1] or spellId == TRB.Data.spells.barbedShot.buffId[2] or spellId == TRB.Data.spells.barbedShot.buffId[3] or spellId == TRB.Data.spells.barbedShot.buffId[4] or spellId == TRB.Data.spells.barbedShot.buffId[5] then
						if type == "SPELL_AURA_APPLIED" then -- Gain Barbed Shot buff
							table.insert(TRB.Data.snapshotData.barbedShot.list, {
								ticksRemaining = TRB.Data.spells.barbedShot.ticks,
								energy = TRB.Data.snapshotData.barbedShot.ticksRemaining * TRB.Data.spells.barbedShot.energy,
								endTime = currentTime + TRB.Data.spells.barbedShot.duration,
								lastTick = currentTime
							})
						end
					elseif spellId == TRB.Data.spells.frenzy.id and destGUID == TRB.Data.character.petGuid then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, TRB.Data.snapshotData.frenzy.stacks, _, TRB.Data.snapshotData.frenzy.duration, TRB.Data.snapshotData.frenzy.endTime, _, _, _, TRB.Data.snapshotData.frenzy.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.frenzy.id, "pet")
							TRB.Data.spells.frenzy.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.frenzy.endTime = nil
							TRB.Data.snapshotData.frenzy.duration = 0
							TRB.Data.snapshotData.frenzy.stacks = 0
							TRB.Data.spells.frenzy.isActive = false
						end
					elseif spellId == TRB.Data.spells.killCommand.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.killCommand.startTime, TRB.Data.snapshotData.killCommand.duration, _, _ = GetSpellCooldown(TRB.Data.spells.killCommand.id)
						end
					elseif spellId == TRB.Data.spells.beastialWrath.id then
						TRB.Data.snapshotData.beastialWrath.startTime, TRB.Data.snapshotData.beastialWrath.duration, _, _ = GetSpellCooldown(TRB.Data.spells.beastialWrath.id)
					elseif spellId == TRB.Data.spells.flamewakersCobraSting.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.flamewakersCobraSting.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.flamewakersCobraSting.isActive = false
						end
					elseif spellId == TRB.Data.spells.wailingArrow.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.wailingArrow.startTime = currentTime
							TRB.Data.snapshotData.wailingArrow.duration = TRB.Data.spells.wailingArrow.cooldown
						end
					end]]
				--[[elseif specId == 2 then --Outlaw
					if spellId == TRB.Data.spells.burstingShot.id then
						TRB.Data.snapshotData.burstingShot.startTime, TRB.Data.snapshotData.burstingShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.burstingShot.id)
					elseif spellId == TRB.Data.spells.aimedShot.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.aimedShot.charges, _, TRB.Data.snapshotData.aimedShot.startTime, TRB.Data.snapshotData.aimedShot.duration, _ = GetSpellCharges(TRB.Data.spells.aimedShot.id)
							TRB.Data.snapshotData.audio.playedAimedShotCue = false
						end
					elseif spellId == TRB.Data.spells.barrage.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.barrage.startTime = currentTime
							TRB.Data.snapshotData.barrage.duration = TRB.Data.spells.barrage.cooldown
						end
					elseif spellId == TRB.Data.spells.explosiveShot.id then
						TRB.Data.snapshotData.explosiveShot.startTime, TRB.Data.snapshotData.explosiveShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.explosiveShot.id)
					elseif spellId == TRB.Data.spells.trueshot.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.trueshot.isActive = true
							_, _, _, _, TRB.Data.snapshotData.trueshot.duration, TRB.Data.snapshotData.trueshot.endTime, _, _, _, TRB.Data.snapshotData.trueshot.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.trueshot.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.trueshot.isActive = false
							TRB.Data.snapshotData.trueshot.spellId = nil
							TRB.Data.snapshotData.trueshot.duration = 0
							TRB.Data.snapshotData.trueshot.endTime = nil
						end
					elseif spellId == TRB.Data.spells.steadyEnergy.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.steadyEnergy.isActive = true
							_, _, _, _, TRB.Data.snapshotData.steadyEnergy.duration, TRB.Data.snapshotData.steadyEnergy.endTime, _, _, _, TRB.Data.snapshotData.steadyEnergy.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.steadyEnergy.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.steadyEnergy.isActive = false
							TRB.Data.snapshotData.steadyEnergy.spellId = nil
							TRB.Data.snapshotData.steadyEnergy.duration = 0
							TRB.Data.snapshotData.steadyEnergy.endTime = nil
						end
					elseif spellId == TRB.Data.spells.lockAndLoad.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.lockAndLoad.isActive = true
							_, _, _, _, TRB.Data.snapshotData.lockAndLoad.duration, TRB.Data.snapshotData.lockAndLoad.endTime, _, _, _, TRB.Data.snapshotData.lockAndLoad.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.lockAndLoad.id)

							if TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.enabled then
								PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.lockAndLoad.isActive = false
							TRB.Data.snapshotData.lockAndLoad.spellId = nil
							TRB.Data.snapshotData.lockAndLoad.duration = 0
							TRB.Data.snapshotData.lockAndLoad.endTime = nil
						end
					elseif spellId == TRB.Data.spells.rapidFire.id then
						if type == "SPELL_AURA_APPLIED" then -- Gained buff
							TRB.Data.snapshotData.rapidFire.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rapidFire.duration, TRB.Data.snapshotData.rapidFire.endTime, _, _, _, TRB.Data.snapshotData.rapidFire.spellId = TRB.Functions.FindDebuffById(TRB.Data.spells.rapidFire.id, destGUID, TRB.Data.character.guid)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.rapidFire.isActive = false
							TRB.Data.snapshotData.rapidFire.spellId = nil
							TRB.Data.snapshotData.rapidFire.duration = 0
							TRB.Data.snapshotData.rapidFire.endTime = nil
							TRB.Data.snapshotData.rapidFire.ticksRemaining = 0
							TRB.Data.snapshotData.rapidFire.energy = 0
						end
					elseif spellId == TRB.Data.spells.eagletalonsTrueEnergy.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.eagletalonsTrueEnergy.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.eagletalonsTrueEnergy.isActive = false
						end
					elseif spellId == TRB.Data.spells.secretsOfTheUnblinkingVigil.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime, TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration, _, _ = GetSpellCooldown(TRB.Data.spells.secretsOfTheUnblinkingVigil.id)

							if TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.enabled then
								PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.secretsOfTheUnblinkingVigil.isActive = false
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.spellId = nil
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration = 0
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.endTime = nil
						end
					elseif spellId == TRB.Data.spells.serpentSting.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- SS Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].serpentSting = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.serpentSting = TRB.Data.snapshotData.targetData.serpentSting + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].serpentSting = false
								TRB.Data.snapshotData.targetData.targets[destGUID].serpentStingRemaining = 0
								TRB.Data.snapshotData.targetData.serpentSting = TRB.Data.snapshotData.targetData.serpentSting - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.wailingArrow.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.wailingArrow.startTime = currentTime
							TRB.Data.snapshotData.wailingArrow.duration = TRB.Data.spells.wailingArrow.cooldown
						end
					end
				elseif specId == 3 then --Subtlety
					if spellId == TRB.Data.spells.carve.id then
						TRB.Data.snapshotData.carve.startTime, TRB.Data.snapshotData.carve.duration, _, _ = GetSpellCooldown(TRB.Data.spells.carve.id)
					elseif spellId == TRB.Data.spells.chakrams.id then
						TRB.Data.snapshotData.chakrams.startTime = currentTime
						TRB.Data.snapshotData.chakrams.duration = TRB.Data.spells.chakrams.cooldown
					elseif spellId == TRB.Data.spells.flankingStrike.id then
						TRB.Data.snapshotData.flankingStrike.startTime, TRB.Data.snapshotData.flankingStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.flankingStrike.id)
					elseif spellId == TRB.Data.spells.termsOfEngagement.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Terms of Engagement
							TRB.Data.snapshotData.termsOfEngagement.isActive = true
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.spells.termsOfEngagement.ticks
							TRB.Data.snapshotData.termsOfEngagement.energy = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.energy
							TRB.Data.snapshotData.termsOfEngagement.endTime = currentTime + TRB.Data.spells.termsOfEngagement.duration
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.spells.termsOfEngagement.ticks + 1
							TRB.Data.snapshotData.termsOfEngagement.energy = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.energy
							TRB.Data.snapshotData.termsOfEngagement.endTime = currentTime + TRB.Data.spells.termsOfEngagement.duration + ((TRB.Data.spells.termsOfEngagement.duration / TRB.Data.spells.termsOfEngagement.ticks) - (currentTime - TRB.Data.snapshotData.termsOfEngagement.lastTick))
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.termsOfEngagement.isActive = false
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = 0
							TRB.Data.snapshotData.termsOfEngagement.energy = 0
							TRB.Data.snapshotData.termsOfEngagement.endTime = nil
							TRB.Data.snapshotData.termsOfEngagement.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining - 1
							TRB.Data.snapshotData.termsOfEngagement.energy = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.energy
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						end
					elseif spellId == TRB.Data.spells.coordinatedAssault.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.coordinatedAssault.isActive = true
							_, _, _, _, TRB.Data.snapshotData.coordinatedAssault.duration, TRB.Data.snapshotData.coordinatedAssault.endTime, _, _, _, TRB.Data.snapshotData.coordinatedAssault.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.coordinatedAssault.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.coordinatedAssault.isActive = false
							TRB.Data.snapshotData.coordinatedAssault.spellId = nil
							TRB.Data.snapshotData.coordinatedAssault.duration = 0
							TRB.Data.snapshotData.coordinatedAssault.endTime = nil
						end
					elseif spellId == TRB.Data.spells.serpentSting.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- SS Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].serpentSting = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.serpentSting = TRB.Data.snapshotData.targetData.serpentSting + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].serpentSting = false
								TRB.Data.snapshotData.targetData.targets[destGUID].serpentStingRemaining = 0
								TRB.Data.snapshotData.targetData.serpentSting = TRB.Data.snapshotData.targetData.serpentSting - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					end]]
				end

				-- Spec agnostic
                --[[
				if spellId == TRB.Data.spells.flayedShot.id then
					TRB.Data.snapshotData.flayedShot.startTime, TRB.Data.snapshotData.flayedShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.flayedShot.id)
				elseif spellId == TRB.Data.spells.killShot.id then
					TRB.Data.snapshotData.audio.playedKillShotCue = false
				elseif spellId == TRB.Data.spells.aMurderOfCrows.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.aMurderOfCrows.startTime = currentTime
						TRB.Data.snapshotData.aMurderOfCrows.duration = TRB.Data.spells.aMurderOfCrows.cooldown
					end
				elseif spellId == TRB.Data.spells.flayersMark.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.flayersMark.isActive = true
						TRB.Data.snapshotData.audio.playedKillShotCue = false
						_, _, _, _, TRB.Data.snapshotData.flayersMark.duration, TRB.Data.snapshotData.flayersMark.endTime, _, _, _, TRB.Data.snapshotData.flayersMark.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.flayersMark.id)

						if specId == 1 and TRB.Data.settings.rogue.assassination.audio.flayersMark.enabled then
							TRB.Data.snapshotData.audio.playedKillShotCue = true
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 2 and TRB.Data.settings.rogue.outlaw.audio.flayersMark.enabled then
							TRB.Data.snapshotData.audio.playedKillShotCue = true
							PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 3 and TRB.Data.settings.rogue.subtlety.audio.flayersMark.enabled then
							TRB.Data.snapshotData.audio.playedKillShotCue = true
							PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
						end

						if specId == 1 and not TRB.Data.snapshotData.audio.playedKillShotCue and TRB.Data.settings.rogue.assassination.audio.killShot.enabled then
							TRB.Data.snapshotData.audio.playedKillShotCue = true
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 2 and not TRB.Data.snapshotData.audio.playedKillShotCue and TRB.Data.settings.rogue.outlaw.audio.killShot.enabled then
							TRB.Data.snapshotData.audio.playedKillShotCue = true
							PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 3 and not TRB.Data.snapshotData.audio.playedKillShotCue and TRB.Data.settings.rogue.subtlety.audio.killShot.enabled then
							TRB.Data.snapshotData.audio.playedKillShotCue = true
							PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.flayersMark.isActive = false
						TRB.Data.snapshotData.flayersMark.spellId = nil
						TRB.Data.snapshotData.flayersMark.duration = 0
						TRB.Data.snapshotData.flayersMark.endTime = nil
					end
				elseif spellId == TRB.Data.spells.nesingwarysTrappingApparatus.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.nesingwarysTrappingApparatus.isActive = true
						_, _, _, _, TRB.Data.snapshotData.nesingwarysTrappingApparatus.duration, TRB.Data.snapshotData.nesingwarysTrappingApparatus.endTime, _, _, _, TRB.Data.snapshotData.nesingwarysTrappingApparatus.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.nesingwarysTrappingApparatus.id)

						if specId == 2 and TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.enabled then
							PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 3 and TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.enabled then
							PlaySoundFile(TRB.Data.settings.rogue.subtlety.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.nesingwarysTrappingApparatus.isActive = false
						TRB.Data.snapshotData.nesingwarysTrappingApparatus.spellId = nil
						TRB.Data.snapshotData.nesingwarysTrappingApparatus.duration = 0
						TRB.Data.snapshotData.nesingwarysTrappingApparatus.endTime = nil
					end
				end]]
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

	resourceFrame:RegisterEvent("ADDON_LOADED")
	resourceFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local _, _, classIndex = UnitClass("player")
		local specId = GetSpecialization() or 0
		if classIndex == 4 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Rogue.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					FillSpecCache()
					FillSpellData_Assassination()
					--FillSpellData_Outlaw()
					--FillSpellData_Subtlety()

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
						C_Timer.After(5, function()
							TRB.Data.settings.rogue.assassination = TRB.Functions.ValidateLsmValues("Assassination Rogue", TRB.Data.settings.rogue.assassination)
							--TRB.Data.settings.rogue.outlaw = TRB.Functions.ValidateLsmValues("Outlaw Rogue", TRB.Data.settings.rogue.outlaw)
							--TRB.Data.settings.rogue.subtlety = TRB.Functions.ValidateLsmValues("Subtlety Rogue", TRB.Data.settings.rogue.subtlety)
							TRB.Options.Rogue.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							ConstructResourceBar(TRB.Data.settings.rogue[TRB.Data.barConstructedForSpec])
							EventRegistration()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					if specId == 1 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.rogue.assassination)
						TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
						FillSpellData_Assassination()
						TRB.Functions.LoadFromSpecCache(specCache.assassination)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Assassination

						if TRB.Data.barConstructedForSpec ~= "assassination" then
							TRB.Data.barConstructedForSpec = "assassination"
							ConstructResourceBar(TRB.Data.settings.rogue.assassination)
                        else
                            TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
						end
					--[[elseif specId == 2 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.rogue.outlaw)
						TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.outlaw)
						FillSpellData_Outlaw()
						TRB.Functions.LoadFromSpecCache(specCache.outlaw)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Outlaw

						if TRB.Data.barConstructedForSpec ~= "outlaw" then
							TRB.Data.barConstructedForSpec = "outlaw"
							ConstructResourceBar(TRB.Data.settings.rogue.outlaw)
						end
					elseif specId == 3 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.rogue.subtlety)
						TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.subtlety)
						FillSpellData_Subtlety()
						TRB.Functions.LoadFromSpecCache(specCache.subtlety)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Subtlety

						if TRB.Data.barConstructedForSpec ~= "subtlety" then
							TRB.Data.barConstructedForSpec = "subtlety"
							ConstructResourceBar(TRB.Data.settings.rogue.subtlety)
						end]]
					end
					EventRegistration()
				end
			end
		end
	end)
end
