local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 3 then --Only do this if we're on a Hunter!
	local barContainerFrame = TRB.Frames.barContainerFrame
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
		beastMastery = {
			snapshotData = {},
			barTextVariables = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		},
		marksmanship = {
			snapshotData = {},
			barTextVariables = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		},
		survival = {
			snapshotData = {},
			barTextVariables = {},
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
		-- Beast Mastery
		specCache.beastMastery.Global_TwintopResourceBar = {
			ttd = 0,
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
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			petGuid = UnitGUID("pet"),
			specId = 1,
			maxResource = 100,
			covenantId = 0
		}

		specCache.beastMastery.spells = {
			-- Hunter Class Baseline Abilities
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				focus = -40,
				texture = "",
				thresholdId = 1,
				settingKey = "arcaneShot",
				thresholdUsable = false,
				baseline = true
			},
			revivePet = {
				id = 982,
				name = "",
				icon = "",
				focus = -35,
				texture = "",
				thresholdId = 2,
				settingKey = "revivePet",
				thresholdUsable = false,
				baseline = true
			},
			wingClip = {
				id = 195645,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 3,
				settingKey = "wingClip",
				thresholdUsable = false,
				baseline = true
			},

			-- Hunter Talent Abilities	
			killCommand = {
				id = 34026,
				name = "",
				icon = "",
				focus = -30,
				texture = "",
				thresholdId = 4,
				settingKey = "killCommand",
				isSnowflake = true,
				hasCooldown = true,
				thresholdUsable = false,
				baseline = true,
				isTalent = true
			},
			concussiveShot = {
				id = 5116,
				name = "",
				icon = "",
				isTalent = true
			},
			killShot = {
				id = 53351,
				name = "",
				icon = "",
				focus = -10,
				texture = "",
				thresholdId = 5,
				settingKey = "killShot",
				healthMinimum = 0.2,
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false
			},
			scareBeast = {
				id = 1513,
				name = "",
				icon = "",
				focus = -25,
				texture = "",
				thresholdId = 6,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 7,
				settingKey = "explosiveShot",
				hasCooldown = true,
				cooldown = 30,
				thresholdUsable = false,
				isTalent = true
			},
			barrage = {
				id = 120360,
				name = "",
				icon = "",
				focus = -60,
				texture = "",
				thresholdId = 8,
				settingKey = "barrage",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 20
			},
			serpentSting = {
				id = 271788,
				name = "",
				icon = "",
				focus = -10,
				texture = "",
				thresholdId = 9,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false,
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			-- TODO: Add charges support for Kill Command
			alphaPredator = {
				id = 269737,
				name = "",
				icon = "",
				isTalent = true
			},
			-- TODO: Add Death Chakram?

			-- Beast Mastery Spec Baseline Abilities

			-- Beast Mastery Spec Talents			
			cobraShot = {
				id = 193455,
				name = "",
				icon = "",
				focus = -35,
				texture = "",
				thresholdId = 10,
				settingKey = "cobraShot",
				killCommandCooldownReduction = 2,
				isSnowflake = true,
				thresholdUsable = false,
				isTalent = true
			},
			multiShot = {
				id = 2643,
				name = "",
				icon = "",
				focus = -40,
				texture = "",
				thresholdId = 11,
				settingKey = "multiShot",
				thresholdUsable = false,
				isTalent = true
			},
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
				focus = 5,
				ticks = 4,
				duration = 8,
				beastialWrathCooldownReduction = 12,
				isTalent = true
			},
			frenzy = {
				id = 272790,
				name = "",
				icon = "",
				duration = 8,
				isActive = false
			},
			cobraSting = {
				id = 378750,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
			cobraSenses = {
				id = 378244,
				name = "",
				icon = "",
				killCommandCooldownReductionModifier = 1,
				isTalent = true
			},
			aMurderOfCrows = {
				id = 131894,
				name = "",
				icon = "",
				focus = -30,
				texture = "",
				thresholdId = 12,
				settingKey = "aMurderOfCrows",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 60,
				isTalent = true
			},
			warOrders = {
				id = 393933,
				name = "",
				icon = "",
				perRankMod = 0.5, --Needed?
				isTalent = true
			},
			huntersPrey = {
				id = 378210,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
			beastialWrath = {
				id = 19574,
				name = "",
				icon = "",
				isTalent = true
			},
			barbedWrath = {
				id = 19574,
				name = "",
				icon = "",
				beastialWrathCooldownReduction = 12,
				isTalent = true
			},
			wailingArrow = {
				id = 392060,
				name = "",
				icon = "",
				focus = -15,
				texture = "",
				thresholdId = 13,
				settingKey = "wailingArrow",
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 60,
				isTalent = true
			},
			scentOfBlood = {
				id = 193532,
				name = "",
				icon = "",
				isTalent = true
			},
			direPack = {
				id = 378745,
				name = "",
				icon = "",
				isTalent = true,
				focusMod = 0.5
			},
			aspectOfTheWild = {
				id = 193530,
				name = "",
				icon = "",
				isTalent = true,
				focusMod = -10
			},
		}

		specCache.beastMastery.snapshotData.focusRegen = 0
		specCache.beastMastery.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false
		}
		specCache.beastMastery.snapshotData.killShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.beastMastery.snapshotData.killCommand = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.beastMastery.snapshotData.barrage = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.beastMastery.snapshotData.aMurderOfCrows = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.beastMastery.snapshotData.explosiveShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			serpentSting = 0,
			targets = {}
		}
		specCache.beastMastery.snapshotData.barbedShot = {
			-- Buff/Focus gain
			isActive = false,
			count = 0,
			ticksRemaining = 0,
			focus = 0,
			endTime = nil,
			list = {},
			-- Charges
			charges = 0,
			maxCharges = 3,
			startTime = nil,
			duration = 0
		}
		specCache.beastMastery.snapshotData.beastialWrath = {
			startTime = nil,
			duration = 0
		}
		specCache.beastMastery.snapshotData.wailingArrow = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.beastMastery.snapshotData.direPack = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.beastMastery.snapshotData.aspectOfTheWild = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}

		specCache.beastMastery.snapshotData.frenzy = {
			endTime = nil,
			duration = 0,
			stacks = 0,
			spellId = 0
		}

		specCache.beastMastery.barTextVariables = {
			icons = {},
			values = {}
		}


		-- Marksmanship

		specCache.marksmanship.Global_TwintopResourceBar = {
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

		specCache.marksmanship.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 2,
			maxResource = 100,
			covenantId = 0
		}

		specCache.marksmanship.spells = {
			
			-- Hunter Class Baseline Abilities
			arcaneShot = {
				id = 185358,
				iconName = "ability_impalingbolt",
				name = "",
				icon = "",
				focus = -40,
				texture = "",
				thresholdId = 1,
				settingKey = "arcaneShot",
				thresholdUsable = false,
				baseline = true
			},
			revivePet = {
				id = 982,
				name = "",
				icon = "",
				focus = -35,
				texture = "",
				thresholdId = 2,
				settingKey = "revivePet",
				thresholdUsable = false,
				baseline = true
			},
			wingClip = {
				id = 195645,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 3,
				settingKey = "wingClip",
				thresholdUsable = false,
				baseline = true
			},

			-- Hunter Talent Abilities	
			killCommand = {
				id = 34026,
				name = "",
				icon = "",
				focus = -30,
				texture = "",
				thresholdId = 4,
				settingKey = "killCommand",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true,
				baseline = false
			},
			concussiveShot = {
				id = 5116,
				name = "",
				icon = "",
				isTalent = true
			},
			killShot = {
				id = 53351,
				name = "",
				icon = "",
				focus = -10,
				texture = "",
				thresholdId = 5,
				settingKey = "killShot",
				healthMinimum = 0.2,
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				baseline = true,
				isTalent = true
			},
			scareBeast = {
				id = 1513,
				name = "",
				icon = "",
				focus = -25,
				texture = "",
				thresholdId = 6,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 7,
				settingKey = "explosiveShot",
				hasCooldown = true,
				cooldown = 30,
				thresholdUsable = false,
				isTalent = true
			},
			barrage = {
				id = 120360,
				name = "",
				icon = "",
				focus = -60,
				texture = "",
				thresholdId = 8,
				settingKey = "barrage",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 20
			},
			serpentSting = {
				id = 271788,
				name = "",
				icon = "",
				focus = -10,
				texture = "",
				thresholdId = 9,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false,
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			-- TODO: Add charges support for Kill Command
			alphaPredator = {
				id = 269737,
				name = "",
				icon = "",
				isTalent = true
			},
			-- TODO: Add Death Chakram?

			-- Marksmanship Spec Baseline Abilities
			steadyShot = {
				id = 56641,
				name = "",
				icon = "",
				focus = 0,
				baseline = true
			},

			-- Marksmanship Spec Talents
			aimedShot = {
				id = 19434,
				name = "",
				icon = "",
				focus = -35,
				texture = "",
				thresholdId = 10,
				settingKey = "aimedShot",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				isTalent = true
			},
			crackShot = {
				id = 321293,
				name = "",
				icon = "",
				focus = -20, --Arcane Shot and Chimaera Shot
				isTalent = true
			},
			improvedSteadyShot = {
				id = 321018,
				name = "",
				icon = "",
				focus = 10,
				isTalent = true
			},
			rapidFire = {
				id = 257044,
				name = "",
				icon = "",
				isActive = false,
				focus = 1,
				shots = 7,
				duration = 2, --On cast then every 1/3 sec, hasted
				isTalent = true
			},
			chimaeraShot = {
				id = 342049,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 11,
				settingKey = "chimaeraShot",
				thresholdUsable = false,
				isTalent = true
			},
			-- TODO: Add Deathblow support
			deathblow = {
				id = 378769,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
			multiShot = {
				id = 257620,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 12,
				settingKey = "multiShot",
				thresholdUsable = false,
				isTalent = true
			},
			burstingShot = {
				id = 186387,
				name = "",
				icon = "",
				focus = -10,
				texture = "",
				thresholdId = 13,
				settingKey = "burstingShot",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},
			-- TODO: Add Deadeye implementation
			deadeye = {
				id = 321460,
				name = "",
				icon = "",
				isTalent = true
			},
			-- TODO:Quick Load implementation. May not be needed?
			quickLoad = {
				id = 378771,
				name = "",
				icon = "",
				isTalent = true
			},
			trickShots = { --TODO: Do these ricochets generate Focus from Rapid Fire Rank 2?
				id = 257044,
				name = "",
				icon = "",
				shots = 5,
				isTalent = true
			},
			steadyFocus = {
				id = 193534,
				name = "",
				icon = "",
				duration = 15,
				isActive = false,
				isTalent = true
			},
			trueshot = {
				id = 288613,
				name = "",
				icon = "",
				isActive = false,
				modifier = 1.5,
				isTalent = true
			},

			-- TODO: Bulletstorm support?
			lockAndLoad = {
				id = 194594,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
			-- TODO: Apply this to Arcane Shot, Chimaera Shot, Multi-Shot, and Aimed Shot.
			eagletalonsTrueFocus = {
				id = 336851,
				name = "",
				icon = "",
				isActive = false,
				modifier = 0.75,
				isTalent = true
			},

			-- Sylvanas Bow
			wailingArrow = {
				id = 355589,
				name = "",
				icon = "",
				focus = -15,
				texture = "",
				thresholdId = 14,
				settingKey = "wailingArrow",
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 60,
				isTalent = true
			},

		}

		specCache.marksmanship.snapshotData.focusRegen = 0
		specCache.marksmanship.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false,
			playedAimedShotCue = true
		}
		specCache.marksmanship.snapshotData.killCommand = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.wailingArrow = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.lockAndLoad = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.marksmanship.snapshotData.trueshot = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.marksmanship.snapshotData.steadyFocus = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.marksmanship.snapshotData.aimedShot = {
			charges = 0,
			maxCharges = 2,
			startTime = nil,
			duration = 0
		}
		specCache.marksmanship.snapshotData.killShot = {
			charges = 0,
			maxCharges = 1,
			startTime = nil,
			duration = 0
		}
		specCache.marksmanship.snapshotData.burstingShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.barrage = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.explosiveShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.rapidFire = {
			startTime = nil,
			duration = 0,
			enabled = false,
			ticksRemaining = 0,
			focus = 0
		}
		specCache.beastMastery.snapshotData.wailingArrow = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			serpentSting = 0,
			targets = {}
		}

		specCache.marksmanship.barTextVariables = {
			icons = {},
			values = {}
		}

		-- Survival
		specCache.survival.Global_TwintopResourceBar = {
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
				focus = 0,
				ticks = 0
			}
		}

		specCache.survival.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 3,
			maxResource = 100,
			covenantId = 0
		}

		specCache.survival.spells = {
			-- Hunter Class Baseline Abilities
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				focus = -40,
				texture = "",
				thresholdId = 1,
				settingKey = "arcaneShot",
				thresholdUsable = false,
				baseline = true
			},
			revivePet = {
				id = 982,
				name = "",
				icon = "",
				focus = -35,
				texture = "",
				thresholdId = 2,
				settingKey = "revivePet",
				thresholdUsable = false,
				baseline = true
			},
			wingClip = {
				id = 195645,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 3,
				settingKey = "wingClip",
				thresholdUsable = false,
				baseline = true
			},

			-- Hunter Talent Abilities	
			killCommand = {
				id = 34026,
				name = "",
				icon = "",
				focus = 21,
				texture = "",
				--thresholdId = 4,
				--settingKey = "killCommand",
				isSnowflake = true,
				hasCooldown = true,
				thresholdUsable = false,
				baseline = true,
				isTalent = true
			},
			concussiveShot = {
				id = 5116,
				name = "",
				icon = "",
				isTalent = true
			},
			killShot = {
				id = 53351,
				name = "",
				icon = "",
				focus = -10,
				texture = "",
				thresholdId = 5,
				settingKey = "killShot",
				healthMinimum = 0.2,
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false
			},
			scareBeast = {
				id = 1513,
				name = "",
				icon = "",
				focus = -25,
				texture = "",
				thresholdId = 6,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				focus = -20,
				texture = "",
				thresholdId = 7,
				settingKey = "explosiveShot",
				hasCooldown = true,
				cooldown = 30,
				thresholdUsable = false,
				isTalent = true
			},
			barrage = {
				id = 120360,
				name = "",
				icon = "",
				focus = -60,
				texture = "",
				thresholdId = 8,
				settingKey = "barrage",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 20
			},
			serpentSting = {
				id = 271788,
				name = "",
				icon = "",
				focus = -10,
				texture = "",
				thresholdId = 9,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false,
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			-- TODO: Add charges support for Kill Command
			alphaPredator = {
				id = 269737,
				name = "",
				icon = "",
				isTalent = true
			},
			-- TODO: Add Death Chakram?

			-- Survival Spec Baseline Abilities

			-- Survival Spec Talents
			raptorStrike = {
				id = 186270,
				name = "",
				icon = "",
				focus = -30,
				texture = "",
				thresholdId = 10,
				isSnowflake = true,
				settingKey = "raptorStrike",
				thresholdUsable = false,
				isTalent = true
			},
			guerrillaTactics = {
				id = 264332,
				name = "",
				icon = "",
				isTalent = true
			},
			wildfireBomb = {
				id = 259495,
				name = "",
				icon = "",
				isTalent = true
			},
			harpoon = {
				id = 190925,
				name = "",
				icon = "",
				isTalent = true
			},
			termsOfEngagement = {
				id = 265898,
				name = "",
				icon = "",
				focus = 2,
				ticks = 10,
				duration = 10,
				isTalent = true
			},
			carve = {
				id = 187708,
				name = "",
				icon = "",
				focus = -35,
				texture = "",
				thresholdId = 11,
				settingKey = "carve",
				--isSnowflake = true,
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},
			butchery = {
				id = 212436,
				name = "",
				icon = "",
				focus = -30,
				isTalent = true,
				hasCooldown = true,
				--isSnowflake = true,
				texture = "",
				thresholdId = 12,
				settingKey = "butchery",
				thresholdUsable = false
			},
			mongooseBite = {
				id = 259387,
				name = "",
				icon = "",
				focus = -30,
				isSnowflake = true,
				texture = "",
				thresholdId = 4, --NOTE this take's Kill Command's stypical threshold ID only so all the rest at the class level stay consistent!
				settingKey = "mongooseBite",
				thresholdUsable = false,
				isTalent = true
			},
			flankingStrike = {
				id = 269751,
				name = "",
				icon = "",
				focus = 30,
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},
			coordinatedAssault = {
				id = 266779,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
		}

		specCache.survival.snapshotData.focusRegen = 0
		specCache.survival.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false
		}
		specCache.survival.snapshotData.coordinatedAssault = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.survival.snapshotData.termsOfEngagement = {
			isActive = false,
			ticksRemaining = 0,
			focus = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.survival.snapshotData.carve = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.killShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.killCommand = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.barrage = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.explosiveShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.butchery = {
			charges = 0,
			maxCharges = 3,
			startTime = nil,
			duration = 0
		}
		specCache.survival.snapshotData.flankingStrike = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.wildfireBomb = {
			charges = 0,
			maxCharges = 1,
			startTime = nil,
			duration = 0
		}
		specCache.survival.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			serpentSting = 0,
			targets = {}
		}

		specCache.survival.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_BeastMastery()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "hunter", "beastMastery")
		TRB.Functions.LoadFromSpecCache(specCache.beastMastery)
	end

	local function Setup_Marksmanship()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "hunter", "marksmanship")
		TRB.Functions.LoadFromSpecCache(specCache.marksmanship)
	end

	local function Setup_Survival()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "hunter", "survival")
		TRB.Functions.LoadFromSpecCache(specCache.survival)
	end

	local function FillSpellData_BeastMastery()
		Setup_BeastMastery()
		local spells = TRB.Functions.FillSpellData(specCache.beastMastery.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.beastMastery.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Focus generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barbedShot", icon = spells.barbedShot.icon, description = "Barbed Shot", printInSettings = true },
			{ variable = "#barrage", icon = spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#beastialWrath", icon = spells.beastialWrath.icon, description = "Beastial Wrath", printInSettings = true },
			{ variable = "#cobraShot", icon = spells.cobraShot.icon, description = "Cobra Shot", printInSettings = true },
			{ variable = "#frenzy", icon = spells.frenzy.icon, description = "Frenzy", printInSettings = true },
			{ variable = "#killCommand", icon = spells.killCommand.icon, description = "Kill Command", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#multiShot", icon = spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#wailingArrow", icon = spells.wailingArrow.icon, description = "Wailing Arrow", printInSettings = true },
        }
		specCache.beastMastery.barTextVariables.values = {
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

			{ variable = "$focus", description = "Current Focus", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Focus", printInSettings = false, color = false },
			{ variable = "$focusMax", description = "Maximum Focus", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Focus", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Focus from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$barbedShotFocus", description = "Focus from Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$regen", description = "Focus from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenFocus", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusRegen", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusPlusCasting", description = "Current + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Focus Total", printInSettings = false, color = false },
			{ variable = "$focusPlusPassive", description = "Current + Passive Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Focus Total", printInSettings = false, color = false },
			{ variable = "$focusTotal", description = "Current + Passive + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Focus Total", printInSettings = false, color = false },

			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$ssTime", description = "Time remaining on Serpent Sting on your current target", printInSettings = true, color = false },

			{ variable = "$frenzyTime", description = "Time remaining on your pet's Frenzy buff", printInSettings = true, color = false },
			{ variable = "$frenzyStacks", description = "Current stack count on your pet's Frenzy buff", printInSettings = true, color = false },

			{ variable = "$barbedShotTicks", description = "Total number of Barbed Shot buff ticks remaining", printInSettings = true, color = false },
			{ variable = "$barbedShotTime", description = "Time remaining until the most recent Barbed Shot buff expires", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.beastMastery.spells = spells
	end

	local function FillSpellData_Marksmanship()
		Setup_Marksmanship()
		local spells = TRB.Functions.FillSpellData(specCache.marksmanship.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.marksmanship.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Focus generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#aimedShot", icon = spells.aimedShot.icon, description = "Aimed Shot", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barrage", icon = spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#burstingShot", icon = spells.burstingShot.icon, description = "Bursting Shot", printInSettings = true },
			{ variable = "#chimaeraShot", icon = spells.chimaeraShot.icon, description = "Chimaera Shot", printInSettings = true },
			{ variable = "#explosiveShot", icon = spells.explosiveShot.icon, description = "Explosive Shot", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#lockAndLoad", icon = spells.lockAndLoad.icon, description = "Lock and Load", printInSettings = true },
			{ variable = "#multiShot", icon = spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = "Rapid Fire", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#steadyFocus", icon = spells.steadyFocus.icon, description = "Steady Focus", printInSettings = true },
			{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = "Steady Shot", printInSettings = true },
			{ variable = "#trickShots", icon = spells.trickShots.icon, description = "Trick Shots", printInSettings = true },
			{ variable = "#trueshot", icon = spells.trueshot.icon, description = "Trueshot", printInSettings = true },
			{ variable = "#wailingArrow", icon = spells.wailingArrow.icon, description = "Wailing Arrow", printInSettings = true }
        }
		specCache.marksmanship.barTextVariables.values = {
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

			{ variable = "$focus", description = "Current Focus", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Focus", printInSettings = false, color = false },
			{ variable = "$focusMax", description = "Maximum Focus", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Focus", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Focus from Passive Sources including Regen", printInSettings = true, color = false },
			{ variable = "$regen", description = "Focus from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenFocus", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusRegen", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusPlusCasting", description = "Current + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Focus Total", printInSettings = false, color = false },
			{ variable = "$focusPlusPassive", description = "Current + Passive Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Focus Total", printInSettings = false, color = false },
			{ variable = "$focusTotal", description = "Current + Passive + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Focus Total", printInSettings = false, color = false },

			{ variable = "$trueshotTime", description = "Time remaining on Trueshot buff", printInSettings = true, color = false },
			{ variable = "$lockAndLoadTime", description = "Time remaining on Lock and Load buff", printInSettings = true, color = false },

			{ variable = "$steadyFocusTime", description = "Time remaining on Steady Focus buff", printInSettings = true, color = false },
			
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$ssTime", description = "Time remaining on Serpent Sting on your current target", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.marksmanship.spells = spells
	end

	local function FillSpellData_Survival()
		Setup_Survival()
		local spells = TRB.Functions.FillSpellData(specCache.survival.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.survival.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Focus generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#butchery", icon = spells.butchery.icon, description = "Butchery", printInSettings = true },
			{ variable = "#carve", icon = spells.carve.icon, description = "Carve", printInSettings = true },
			{ variable = "#coordinatedAssault", icon = spells.coordinatedAssault.icon, description = "Coordinated Assault", printInSettings = true },
			{ variable = "#ca", icon = spells.coordinatedAssault.icon, description = "Coordinated Assault", printInSettings = false },
			{ variable = "#flankingStrike", icon = spells.flankingStrike.icon, description = "Flanking Strike", printInSettings = true },
			{ variable = "#harpoon", icon = spells.harpoon.icon, description = "Harpoon", printInSettings = true },
			{ variable = "#killCommand", icon = spells.killCommand.icon, description = "Kill Command", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#mongooseBite", icon = spells.mongooseBite.icon, description = "Mongoose Bite", printInSettings = true },
			{ variable = "#raptorStrike", icon = spells.raptorStrike.icon, description = "Raptor Strike", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#termsOfEngagement", icon = spells.termsOfEngagement.icon, description = "Terms of Engagement", printInSettings = true },
			{ variable = "#wildfireBomb", icon = spells.wildfireBomb.icon, description = "Wildfire Bomb", printInSettings = true },
			{ variable = "#wingClip", icon = spells.wingClip.icon, description = "Wing Clip", printInSettings = true },
        }
		specCache.survival.barTextVariables.values = {
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

			{ variable = "$focus", description = "Current Focus", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Focus", printInSettings = false, color = false },
			{ variable = "$focusMax", description = "Maximum Focus", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Focus", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Focus from Passive Sources including Regen", printInSettings = true, color = false },
			{ variable = "$regen", description = "Focus from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenFocus", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusRegen", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusPlusCasting", description = "Current + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Focus Total", printInSettings = false, color = false },
			{ variable = "$focusPlusPassive", description = "Current + Passive Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Focus Total", printInSettings = false, color = false },
			{ variable = "$focusTotal", description = "Current + Passive + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Focus Total", printInSettings = false, color = false },

			{ variable = "$coordinatedAssaultTime", description = "Time remaining on Coordinated Assault buff", printInSettings = true, color = false },

			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$ssTime", description = "Time remaining on Serpent Sting on your current target", printInSettings = true, color = false },

			{ variable = "$toeFocus", description = "Focus from Terms of Engagement", printInSettings = true, color = false },
			{ variable = "$toeTicks", description = "Number of ticks left on Terms of Engagement", printInSettings = true, color = false },

			{ variable = "$wildfireBombCharges", description = "Number of charges of Wildfire Bomb available", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.survival.spells = spells
	end

	local function CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "hunter"
		TRB.Data.character.petGuid = UnitGUID("pet")
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Focus)

		if specId == 1 then
			TRB.Data.character.specName = "beastMastery"
		elseif specId == 2 then
			TRB.Data.character.specName = "marksmanship"
		elseif specId == 3 then
			TRB.Data.character.specName = "survival"
		
			if TRB.Functions.IsTalentActive(TRB.Data.spells.guerrillaTactics) then
				TRB.Data.snapshotData.wildfireBomb.maxCharges = 2
			else
				TRB.Data.snapshotData.wildfireBomb.maxCharges = 1
			end
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.hunter.beastMastery == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.beastMastery)
			TRB.Data.specSupported = true
		elseif specId == 2 and TRB.Data.settings.core.enabled.hunter.marksmanship == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.marksmanship)
			TRB.Data.specSupported = true
		elseif specId == 3 and TRB.Data.settings.core.enabled.hunter.survival == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.survival)
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
			TRB.Data.resource = Enum.PowerType.Focus
			TRB.Data.resourceFactor = 1

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

		local specId = GetSpecialization()

		if guid ~= nil and guid ~= "" then
			if not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
				TRB.Data.snapshotData.targetData.targets[guid].serpentSting = false
				TRB.Data.snapshotData.targetData.targets[guid].serpentStingRemaining = 0
			end
			TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()
			return true
		end
		return false
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget
	

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

	local function GetTrueshotRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.trueshot)
	end

	local function GetSteadyFocusRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.steadyFocus)
	end

	local function GetCoordinatedAssaultRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.coordinatedAssault)
	end

	local function GetLockAndLoadRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.lockAndLoad)
	end

    local function CalculateAbilityResourceValue(resource, threshold)
        local modifier = 1.0
		if GetSpecialization() == 2 then
			if resource > 0 then
				if TRB.Data.spells.trueshot.isActive and not threshold then
					modifier = modifier * TRB.Data.spells.trueshot.modifier
				end
			end
		end

        return resource * modifier
    end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

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

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.serpentSting = 0
		end
	end

	local function ConstructResourceBar(settings)
		local entries = TRB.Functions.TableLength(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end

        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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

		TRB.Functions.ConstructResourceBar(settings)
		TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.hunter.beastMastery
		elseif specId == 2 then
			settings = TRB.Data.settings.hunter.marksmanship
		elseif specId == 3 then
			settings = TRB.Data.settings.hunter.survival
		end

		if specId == 1 then --Beast Mastery
			if var == "$barbedShotFocus" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.focus > 0 then
					valid = true
				end
			elseif var == "$barbedShotTicks" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.focus > 0 then
					valid = true
				end
			elseif var == "$barbedShotTime" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.focus > 0 then
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
			end
		elseif specId == 2 then --Marksmanship
			if var == "$trueshotTime" then
				if GetTrueshotRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$steadyFocusTime" then
				if GetSteadyFocusRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$lockAndLoadTime" then
				if GetLockAndLoadRemainingTime() > 0 then
					valid = true
				end
			end
		elseif specId == 3 then --Survivial
			if var == "$coordinatedAssaultTime" then
				if GetCoordinatedAssaultRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$toeFocus" then
				if TRB.Data.snapshotData.termsOfEngagement.focus > 0 then
					valid = true
				end
			elseif var == "$toeTicks" then
				if TRB.Data.snapshotData.termsOfEngagement.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$wildfireBombCharges" then
				if TRB.Data.snapshotData.wildfireBomb.charges > 0 then
					valid = true
				end
			end
		end

		if var == "$resource" or var == "$focus" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$focusMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$focusTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$focusPlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$focusOvercap" or var == "$resourceOvercap" then
			if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$focusPlusPassive" then
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
			elseif specId == 1 and IsValidVariableForSpec("$barbedShotFocus") then
				valid = true
			elseif specId == 3 and TRB.Data.snapshotData.termsOfEngagement.focus > 0 then
				valid = true
			end
		elseif var == "$regen" or var == "$regenFocus" or var == "$focusRegen" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
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
			end
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_BeastMastery()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.focusRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentFocusColor = TRB.Data.settings.hunter.beastMastery.colors.text.current
		local castingFocusColor = TRB.Data.settings.hunter.beastMastery.colors.text.casting

		if TRB.Data.settings.hunter.beastMastery.colors.text.overcapEnabled and overcap then
			currentFocusColor = TRB.Data.settings.hunter.beastMastery.colors.text.overcap
            castingFocusColor = TRB.Data.settings.hunter.beastMastery.colors.text.overcap
		elseif TRB.Data.settings.hunter.beastMastery.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFocusColor = TRB.Data.settings.hunter.beastMastery.colors.text.overThreshold
				castingFocusColor = TRB.Data.settings.hunter.beastMastery.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = TRB.Data.settings.hunter.beastMastery.colors.text.spending
		end

		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _regenFocus = 0
		local _passiveFocus
		local _passiveFocusMinusRegen

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.hunter.beastMastery.generation.enabled then
			if TRB.Data.settings.hunter.beastMastery.generation.mode == "time" then
				_regenFocus = TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.beastMastery.generation.time or 3.0)
			else
				_regenFocus = TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.beastMastery.generation.gcds or 2) * _gcd)
			end
		end

		--$regenFocus
		local regenFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.beastMastery.colors.text.passive, _regenFocus)

		--$barbedShotFocus
		local _barbedShotFocus = TRB.Data.snapshotData.barbedShot.focus
		local barbedShotFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.beastMastery.colors.text.passive, _barbedShotFocus)

		--$barbedShotTicks
		local barbedShotTicks = string.format("%.0f", TRB.Data.snapshotData.barbedShot.ticksRemaining)

		--$barbedShotTime
		local barbedShotTime = "0.0"
		local _barbedShotTime = (TRB.Data.snapshotData.barbedShot.endTime or 0) - currentTime
		if _barbedShotTime > 0 then
			barbedShotTime = string.format("%.1f", _barbedShotTime)
		end

		_passiveFocus = _regenFocus + _barbedShotFocus
		_passiveFocusMinusRegen = _passiveFocus - _regenFocus

		local passiveFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.beastMastery.colors.text.passive, _passiveFocus)
		local passiveFocusMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.beastMastery.colors.text.passive, _passiveFocusMinusRegen)
		--$focusTotal
		local _focusTotal = math.min(_passiveFocus + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passiveFocus + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		--$frenzyTime
		local _frenzyTime = GetFrenzyRemainingTime()
		local frenzyTime = "0.0"
		if _frenzyTime ~= nil then
			frenzyTime = string.format("%.1f", _frenzyTime)
		end

		--$frenzyStacks
		local frenzyStacks = TRB.Data.snapshotData.frenzy.stacks or 0


		--$ssCount and $ssTime
		local _serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0
		local serpentStingCount = tostring(_serpentStingCount)
		local _serpentStingTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_serpentStingTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining or 0
		end

		local serpentStingTime

		if TRB.Data.settings.hunter.beastMastery.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining > TRB.Data.spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.beastMastery.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.beastMastery.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				else
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.beastMastery.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.beastMastery.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				end
			else
				serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.beastMastery.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.beastMastery.colors.text.dots.down, 0)
			end
		else
			serpentStingTime = string.format("%.1f", _serpentStingTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveFocus
		Global_TwintopResourceBar.resource.regen = _regenFocus
		Global_TwintopResourceBar.resource.barbedShot = _barbedShotFocus
		Global_TwintopResourceBar.barbedShot = {
			count = TRB.Data.snapshotData.barbedShot.count,
			focus = TRB.Data.snapshotData.barbedShot.focus,
			ticks = TRB.Data.snapshotData.barbedShot.ticksRemaining,
			remaining = _barbedShotTime
		}
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#barbedShot"] = TRB.Data.spells.barbedShot.icon
		lookup["#barrage"] = TRB.Data.spells.barrage.icon
		lookup["#beastialWrath"] = TRB.Data.spells.beastialWrath.icon
		lookup["#cobraShot"] = TRB.Data.spells.cobraShot.icon
		lookup["#frenzy"] = TRB.Data.spells.frenzy.icon
		lookup["#killCommand"] = TRB.Data.spells.killCommand.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#multiShot"] = TRB.Data.spells.multiShot.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon		
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["$frenzyTime"] = frenzyTime
		lookup["$frenzyStacks"] = frenzyStacks
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$focusTotal"] = focusTotal
		lookup["$focusMax"] = TRB.Data.character.maxResource
		lookup["$focus"] = currentFocus
		lookup["$resourcePlusCasting"] = focusPlusCasting
		lookup["$resourcePlusPassive"] = focusPlusPassive
		lookup["$resourceTotal"] = focusTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentFocus
		lookup["$casting"] = castingFocus

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
			lookup["$passive"] = passiveFocusMinusRegen
		else
			lookup["$passive"] = passiveFocus
		end

		lookup["$barbedShotFocus"] = barbedShotFocus
		lookup["$barbedShotTicks"] = barbedShotTicks
		lookup["$barbedShotTime"] = barbedShotTime
		lookup["$ssCount"] = serpentStingCount
		lookup["$ssTime"] = serpentStingTime
		lookup["$regen"] = regenFocus
		lookup["$regenFocus"] = regenFocus
		lookup["$focusRegen"] = regenFocus
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$focusOvercap"] = overcap
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$frenzyTime"] = _frenzyTime
		lookupLogic["$frenzyStacks"] = frenzyStacks
		lookupLogic["$focusPlusCasting"] = _focusPlusCasting
		lookupLogic["$focusTotal"] = _focusTotal
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$focus"] = TRB.Data.snapshotData.resource
		lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
		lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
		lookupLogic["$resourceTotal"] = _focusTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshotData.resource
		lookupLogic["$casting"] = TRB.Data.snapshotData.casting.resourceFinal

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
			lookupLogic["$passive"] = _passiveFocusMinusRegen
		else
			lookupLogic["$passive"] = _passiveFocus
		end

		lookupLogic["$barbedShotFocus"] = _barbedShotFocus
		lookupLogic["$barbedShotTicks"] = TRB.Data.snapshotData.barbedShot.ticksRemaining
		lookupLogic["$barbedShotTime"] = _barbedShotTime
		lookupLogic["$ssCount"] = _serpentStingCount
		lookupLogic["$ssTime"] = _serpentStingTime
		lookupLogic["$regen"] = _regenFocus
		lookupLogic["$regenFocus"] = _regenFocus
		lookupLogic["$focusRegen"] = _regenFocus
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$focusOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Marksmanship()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.focusRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.current
		local castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.casting

		if TRB.Data.settings.hunter.marksmanship.colors.text.overcapEnabled and overcap then
			currentFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overcap
            castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overcap
		elseif TRB.Data.settings.hunter.marksmanship.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overThreshold
				castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.spending
		end

		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _regenFocus = 0
		local _passiveFocus

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.hunter.marksmanship.generation.enabled then
			if TRB.Data.settings.hunter.marksmanship.generation.mode == "time" then
				_regenFocus = TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.marksmanship.generation.time or 3.0)
			else
				_regenFocus = TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.marksmanship.generation.gcds or 2) * _gcd)
			end
		end

		--$regenFocus
		local regenFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.marksmanship.colors.text.passive, _regenFocus)
		_passiveFocus = _regenFocus

		local passiveFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.marksmanship.colors.text.passive, _passiveFocus)
		--$focusTotal
		local _focusTotal = math.min(_passiveFocus + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passiveFocus + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		--$trueshotTime
		local _trueshotTime = GetTrueshotRemainingTime()
		local trueshotTime = "0.0"
		if _trueshotTime ~= nil then
			trueshotTime = string.format("%.1f", _trueshotTime)
		end

		--$steadyFocusTime
		local _steadyFocusTime = GetSteadyFocusRemainingTime()
		local steadyFocusTime = "0.0"
		if _steadyFocusTime ~= nil then
			steadyFocusTime = string.format("%.1f", _steadyFocusTime)
		end

		--$lockAndLoadTime
		local _lockAndLoadTime = GetLockAndLoadRemainingTime()
		local lockAndLoadTime = "0.0"
		if _lockAndLoadTime ~= nil then
			lockAndLoadTime = string.format("%.1f", _lockAndLoadTime)
		end

		--$ssCount and $ssTime
		local _serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0
		local serpentStingCount = tostring(_serpentStingCount)
		local _serpentStingTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_serpentStingTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining or 0
		end

		local serpentStingTime

		if TRB.Data.settings.hunter.marksmanship.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining > TRB.Data.spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.marksmanship.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.marksmanship.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				else
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.marksmanship.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.marksmanship.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				end
			else
				serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.marksmanship.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.marksmanship.colors.text.dots.down, 0)
			end
		else
			serpentStingTime = string.format("%.1f", _serpentStingTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveFocus
		Global_TwintopResourceBar.resource.regen = _regenFocus
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#aimedShot"] = TRB.Data.spells.aimedShot.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#barrage"] = TRB.Data.spells.barrage.icon
		lookup["#burstingShot"] = TRB.Data.spells.burstingShot.icon
		lookup["#chimaeraShot"] = TRB.Data.spells.chimaeraShot.icon
		lookup["#explosiveShot"] = TRB.Data.spells.explosiveShot.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#lockAndLoad"] = TRB.Data.spells.lockAndLoad.icon
		lookup["#multiShot"] = TRB.Data.spells.multiShot.icon
		lookup["#rapidFire"] = TRB.Data.spells.rapidFire.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["#steadyFocus"] = TRB.Data.spells.steadyFocus.icon
		lookup["#steadyShot"] = TRB.Data.spells.steadyShot.icon
		lookup["#trickShots"] = TRB.Data.spells.trickShots.icon
		lookup["#trueshot"] = TRB.Data.spells.trueshot.icon
		lookup["$steadyFocusTime"] = steadyFocusTime
		lookup["$trueshotTime"] = trueshotTime
		lookup["$lockAndLoadTime"] = lockAndLoadTime
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$ssCount"] = serpentStingCount
		lookup["$ssTime"] = serpentStingTime
		lookup["$focusTotal"] = focusTotal
		lookup["$focusMax"] = TRB.Data.character.maxResource
		lookup["$focus"] = currentFocus
		lookup["$resourcePlusCasting"] = focusPlusCasting
		lookup["$resourcePlusPassive"] = focusPlusPassive
		lookup["$resourceTotal"] = focusTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentFocus
		lookup["$casting"] = castingFocus
		lookup["$passive"] = passiveFocus
		lookup["$regen"] = regenFocus
		lookup["$regenFocus"] = regenFocus
		lookup["$focusRegen"] = regenFocus
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$focusOvercap"] = overcap
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$steadyFocusTime"] = _steadyFocusTime
		lookupLogic["$trueshotTime"] = _trueshotTime
		lookupLogic["$lockAndLoadTime"] = _lockAndLoadTime
		lookupLogic["$focusPlusCasting"] = _focusPlusCasting
		lookupLogic["$ssCount"] = _serpentStingCount
		lookupLogic["$ssTime"] = _serpentStingTime
		lookupLogic["$focusTotal"] = _focusTotal
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$focus"] = TRB.Data.snapshotData.resource
		lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
		lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
		lookupLogic["$resourceTotal"] = _focusTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshotData.resource
		lookupLogic["$casting"] = TRB.Data.snapshotData.casting.resourceFinal
		lookupLogic["$passive"] = _passiveFocus
		lookupLogic["$regen"] = _regenFocus
		lookupLogic["$regenFocus"] = _regenFocus
		lookupLogic["$focusRegen"] = _regenFocus
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$focusOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Survival()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.focusRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentFocusColor = TRB.Data.settings.hunter.survival.colors.text.current
		local castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.casting

		if TRB.Data.settings.hunter.survival.colors.text.overcapEnabled and overcap then
			currentFocusColor = TRB.Data.settings.hunter.survival.colors.text.overcap
            castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.overcap
		elseif TRB.Data.settings.hunter.survival.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentFocusColor = TRB.Data.settings.hunter.survival.colors.text.overThreshold
				castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.spending
		end

		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, TRB.Data.snapshotData.casting.resourceFinal)

		--$toeFocus
		local _toeFocus = TRB.Data.snapshotData.termsOfEngagement.focus
		local toeFocus = string.format("%.0f", _toeFocus)
		--$toeTicks
		local toeTicks = string.format("%.0f", TRB.Data.snapshotData.termsOfEngagement.ticksRemaining)

		local _regenFocus = 0
		local _passiveFocus

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.hunter.survival.generation.enabled then
			if TRB.Data.settings.hunter.survival.generation.mode == "time" then
				_regenFocus = TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.survival.generation.time or 3.0)
			else
				_regenFocus = TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.survival.generation.gcds or 2) * _gcd)
			end
		end

		--$regenFocus
		local regenFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.passive, _regenFocus)
		_passiveFocus = _regenFocus + _toeFocus

		--$passive
		local passiveFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.passive, _passiveFocus)
		--$focusTotal
		local _focusTotal = math.min(_passiveFocus + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passiveFocus + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		--$coordinatedAssaultTime
		local _coordinatedAssaultTime = GetCoordinatedAssaultRemainingTime()
		local coordinatedAssaultTime = "0.0"
		if _coordinatedAssaultTime ~= nil then
			coordinatedAssaultTime = string.format("%.1f", _coordinatedAssaultTime)
		end

		--$wildfireBombCharges
		local wildfireBombCharges = TRB.Data.snapshotData.wildfireBomb.charges or 0

		--$ssCount and $ssTime
		local _serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0
		local serpentStingCount = tostring(_serpentStingCount)
		local _serpentStingTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_serpentStingTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining or 0
		end

		local serpentStingTime

		if TRB.Data.settings.hunter.survival.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining > TRB.Data.spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.survival.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				else
					serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.survival.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining)
				end
			else
				serpentStingCount = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", TRB.Data.settings.hunter.survival.colors.text.dots.down, 0)
			end
		else
			serpentStingTime = string.format("%.1f", _serpentStingTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveFocus
		Global_TwintopResourceBar.resource.regen = _regenFocus
		Global_TwintopResourceBar.resource.termsOfEngagement = _toeFocus
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}
		Global_TwintopResourceBar.termsOfEngagement = {
			focus = _toeFocus,
			ticks = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining or 0
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#butchery"] = TRB.Data.spells.butchery.icon
		lookup["#carve"] = TRB.Data.spells.carve.icon
		lookup["#coordinatedAssault"] = TRB.Data.spells.coordinatedAssault.icon
		lookup["#ca"] = TRB.Data.spells.coordinatedAssault.icon
		lookup["#flankingStrike"] = TRB.Data.spells.flankingStrike.icon
		lookup["#harpoon"] = TRB.Data.spells.harpoon.icon
		lookup["#killCommand"] = TRB.Data.spells.killCommand.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#mongooseBite"] = TRB.Data.spells.mongooseBite.icon
		lookup["#raptorStrike"] = TRB.Data.spells.raptorStrike.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["#termsOfEngagement"] = TRB.Data.spells.termsOfEngagement.icon
		lookup["#wingClip"] = TRB.Data.spells.wingClip.icon
		lookup["#wildfireBomb"] = TRB.Data.spells.wildfireBomb.icon
		lookup["$coordinatedAssaultTime"] = coordinatedAssaultTime
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$ssCount"] = serpentStingCount
		lookup["$ssTime"] = serpentStingTime
		lookup["$wildfireBombCharges"] = wildfireBombCharges
		lookup["$focusTotal"] = focusTotal
		lookup["$focusMax"] = TRB.Data.character.maxResource
		lookup["$focus"] = currentFocus
		lookup["$resourcePlusCasting"] = focusPlusCasting
		lookup["$resourcePlusPassive"] = focusPlusPassive
		lookup["$resourceTotal"] = focusTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentFocus
		lookup["$casting"] = castingFocus
		lookup["$passive"] = passiveFocus
		lookup["$regen"] = regenFocus
		lookup["$regenFocus"] = regenFocus
		lookup["$focusRegen"] = regenFocus
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$focusOvercap"] = overcap
		lookup["$toeFocus"] = toeFocus
		lookup["$toeTicks"] = toeTicks
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}

		lookupLogic["$coordinatedAssaultTime"] = _coordinatedAssaultTime
		lookupLogic["$focusPlusCasting"] = _focusPlusCasting
		lookupLogic["$ssCount"] = _serpentStingCount
		lookupLogic["$ssTime"] = _serpentStingTime
		lookupLogic["$wildfireBombCharges"] = wildfireBombCharges
		lookupLogic["$focusTotal"] = _focusTotal
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$focus"] = TRB.Data.snapshotData.resource
		lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
		lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
		lookupLogic["$resourceTotal"] = _focusTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshotData.resource
		lookupLogic["$casting"] = TRB.Data.snapshotData.casting.resourceFinal
		lookupLogic["$passive"] = _passiveFocus
		lookupLogic["$regen"] = _regenFocus
		lookupLogic["$regenFocus"] = _regenFocus
		lookupLogic["$focusRegen"] = _regenFocus
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$focusOvercap"] = overcap
		lookupLogic["$toeFocus"] = _toeFocus
		lookupLogic["$toeTicks"] = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining
		TRB.Data.lookupLogic = lookupLogic
	end

	local function UpdateRapidFire()
		if TRB.Data.snapshotData.rapidFire.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.rapidFire.endTime == nil or currentTime > TRB.Data.snapshotData.rapidFire.endTime then
				TRB.Data.snapshotData.rapidFire.ticksRemaining = 0
				TRB.Data.snapshotData.rapidFire.endTime = nil
				TRB.Data.snapshotData.rapidFire.focus = 0
				TRB.Data.snapshotData.rapidFire.isActive = false
			else
				TRB.Data.snapshotData.rapidFire.ticksRemaining = math.ceil((TRB.Data.snapshotData.rapidFire.endTime - currentTime) / (TRB.Data.snapshotData.rapidFire.duration / (TRB.Data.spells.rapidFire.shots - 1)))
				TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.snapshotData.rapidFire.ticksRemaining * TRB.Data.spells.rapidFire.focus
				TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
				TRB.Data.snapshotData.rapidFire.focus = TRB.Data.snapshotData.casting.resourceFinal
			end
		end
	end

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.focus
        TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.focus)
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
					if spellName == TRB.Data.spells.barrage.name then
						TRB.Data.spells.barrage.thresholdUsable = false
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					if spellName == TRB.Data.spells.scareBeast.name then
						FillSnapshotDataCasting(TRB.Data.spells.scareBeast)
					elseif spellName == TRB.Data.spells.revivePet.name then
						FillSnapshotDataCasting(TRB.Data.spells.revivePet)
					else
						return false
					end
				end
			elseif specId == 2 then
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
						if TRB.Functions.IsTalentActive(TRB.Data.spells.improvedSteadyShot) then
							FillSnapshotDataCasting(TRB.Data.spells.improvedSteadyShot)
						else
						FillSnapshotDataCasting(TRB.Data.spells.steadyShot)
						end
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
				end
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateTermsOfEngagement()
		if TRB.Data.snapshotData.termsOfEngagement.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.termsOfEngagement.endTime == nil or currentTime > TRB.Data.snapshotData.termsOfEngagement.endTime then
				TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = 0
				TRB.Data.snapshotData.termsOfEngagement.endTime = nil
				TRB.Data.snapshotData.termsOfEngagement.focus = 0
				TRB.Data.snapshotData.termsOfEngagement.isActive = false
			else
				TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = math.ceil((TRB.Data.snapshotData.termsOfEngagement.endTime - currentTime) / (TRB.Data.spells.termsOfEngagement.duration / TRB.Data.spells.termsOfEngagement.ticks))
				TRB.Data.snapshotData.termsOfEngagement.focus = CalculateAbilityResourceValue(TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus)
			end
		end
	end

	local function UpdateBarbedShot()
		local entries = TRB.Functions.TableLength(TRB.Data.snapshotData.barbedShot.list)
		local totalFocus = 0
		local totalTicksRemaining = 0
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
					TRB.Data.snapshotData.barbedShot.list[x].focus = CalculateAbilityResourceValue(TRB.Data.snapshotData.barbedShot.list[x].ticksRemaining * TRB.Data.spells.barbedShot.focus)
					totalFocus = totalFocus + TRB.Data.snapshotData.barbedShot.list[x].focus
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
		TRB.Data.snapshotData.barbedShot.focus = totalFocus
		TRB.Data.snapshotData.barbedShot.ticksRemaining = totalTicksRemaining
		TRB.Data.snapshotData.barbedShot.endTime = maxEndTime

		-- Recharge info
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
		TRB.Data.snapshotData.barbedShot.charges, TRB.Data.snapshotData.barbedShot.maxCharges, TRB.Data.snapshotData.barbedShot.startTime, TRB.Data.snapshotData.barbedShot.duration, _ = GetSpellCharges(TRB.Data.spells.barbedShot.id)
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentSting then
			local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.serpentSting.id, "target", "player"))

			if expiration ~= nil then
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serpentStingRemaining = expiration - currentTime
			end
		end

		if TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration) then
            TRB.Data.snapshotData.killShot.startTime = nil
            TRB.Data.snapshotData.killShot.duration = 0
        end

		if TRB.Data.snapshotData.killCommand.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killCommand.startTime + TRB.Data.snapshotData.killCommand.duration) then
            TRB.Data.snapshotData.killCommand.startTime = nil
            TRB.Data.snapshotData.killCommand.duration = 0
		elseif TRB.Data.snapshotData.killCommand.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshotData.killCommand.startTime, TRB.Data.snapshotData.killCommand.duration, _, _ = GetSpellCooldown(TRB.Data.spells.killCommand.id)
        end
	end

	local function UpdateSnapshot_BeastMastery()
		UpdateSnapshot()
		UpdateBarbedShot()
		local currentTime = GetTime()
		local _

        if TRB.Data.snapshotData.aMurderOfCrows.startTime ~= nil and currentTime > (TRB.Data.snapshotData.aMurderOfCrows.startTime + TRB.Data.snapshotData.aMurderOfCrows.duration) then
            TRB.Data.snapshotData.aMurderOfCrows.startTime = nil
            TRB.Data.snapshotData.aMurderOfCrows.duration = 0
        end

        if TRB.Data.snapshotData.barrage.startTime ~= nil and currentTime > (TRB.Data.snapshotData.barrage.startTime + TRB.Data.snapshotData.barrage.duration) then
			TRB.Data.snapshotData.barrage.startTime = nil
            TRB.Data.snapshotData.barrage.duration = 0
		end

		if TRB.Data.snapshotData.wailingArrow.startTime ~= nil and currentTime > (TRB.Data.snapshotData.wailingArrow.startTime + TRB.Data.snapshotData.wailingArrow.duration) then
			TRB.Data.snapshotData.wailingArrow.startTime = nil
			TRB.Data.snapshotData.wailingArrow.duration = 0
		end

		_, _, TRB.Data.snapshotData.frenzy.stacks, _, TRB.Data.snapshotData.frenzy.duration, TRB.Data.snapshotData.frenzy.endTime, _, _, _, TRB.Data.snapshotData.frenzy.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.frenzy.id, "pet")
		---@diagnostic disable-next-line: redundant-parameter
		TRB.Data.snapshotData.beastialWrath.startTime, TRB.Data.snapshotData.beastialWrath.duration, _, _ = GetSpellCooldown(TRB.Data.spells.beastialWrath.id)
	end

	local function UpdateSnapshot_Marksmanship()
		UpdateSnapshot()
		UpdateRapidFire()
		local currentTime = GetTime()
		local _

---@diagnostic disable-next-line: redundant-parameter
        TRB.Data.snapshotData.aimedShot.charges, TRB.Data.snapshotData.aimedShot.maxCharges, TRB.Data.snapshotData.aimedShot.startTime, TRB.Data.snapshotData.aimedShot.duration, _ = GetSpellCharges(TRB.Data.spells.aimedShot.id)
		---@diagnostic disable-next-line: redundant-parameter
        TRB.Data.snapshotData.killShot.charges, TRB.Data.snapshotData.killShot.maxCharges, TRB.Data.snapshotData.killShot.startTime, TRB.Data.snapshotData.killShot.duration, _ = GetSpellCharges(TRB.Data.spells.killShot.id)

        if TRB.Data.snapshotData.burstingShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.burstingShot.startTime + TRB.Data.snapshotData.burstingShot.duration) then
            TRB.Data.snapshotData.burstingShot.startTime = nil
            TRB.Data.snapshotData.burstingShot.duration = 0
        end

        if TRB.Data.snapshotData.barrage.startTime ~= nil and currentTime > (TRB.Data.snapshotData.barrage.startTime + TRB.Data.snapshotData.barrage.duration) then
            TRB.Data.snapshotData.barrage.startTime = nil
            TRB.Data.snapshotData.barrage.duration = 0
        end

		if TRB.Data.snapshotData.wailingArrow.startTime ~= nil and currentTime > (TRB.Data.snapshotData.wailingArrow.startTime + TRB.Data.snapshotData.wailingArrow.duration) then
			TRB.Data.snapshotData.wailingArrow.startTime = nil
			TRB.Data.snapshotData.wailingArrow.duration = 0
		end

        if TRB.Data.snapshotData.explosiveShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.explosiveShot.startTime + TRB.Data.snapshotData.explosiveShot.duration) then
            TRB.Data.snapshotData.explosiveShot.startTime = nil
            TRB.Data.snapshotData.explosiveShot.duration = 0
        end
	end

	local function UpdateSnapshot_Survival()
		UpdateSnapshot()
		UpdateTermsOfEngagement()
		local currentTime = GetTime()
        local _

		---@diagnostic disable-next-line: redundant-parameter
		TRB.Data.snapshotData.butchery.charges, TRB.Data.snapshotData.butchery.maxCharges, TRB.Data.snapshotData.butchery.startTime, TRB.Data.snapshotData.butchery.duration, _ = GetSpellCharges(TRB.Data.spells.butchery.id)
						
		---@diagnostic disable-next-line: redundant-parameter
		TRB.Data.snapshotData.wildfireBomb.charges, TRB.Data.snapshotData.wildfireBomb.maxCharges, TRB.Data.snapshotData.wildfireBomb.startTime, TRB.Data.snapshotData.wildfireBomb.duration, _ = GetSpellCharges(TRB.Data.spells.wildfireBomb.id)

		if TRB.Data.snapshotData.carve.startTime ~= nil and currentTime > (TRB.Data.snapshotData.carve.startTime + TRB.Data.snapshotData.carve.duration) then
            TRB.Data.snapshotData.carve.startTime = nil
            TRB.Data.snapshotData.carve.duration = 0
        end

		if TRB.Data.snapshotData.flankingStrike.startTime ~= nil and currentTime > (TRB.Data.snapshotData.flankingStrike.startTime + TRB.Data.snapshotData.flankingStrike.duration) then
            TRB.Data.snapshotData.flankingStrike.startTime = nil
            TRB.Data.snapshotData.flankingStrike.duration = 0
        end
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow) and (
						(not TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow) or
						(TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.hunter.beastMastery.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow) and (
						(not TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow) or
						(TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.hunter.marksmanship.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 3 then			
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.hunter.survival.displayBar.alwaysShow) and (
						(not TRB.Data.settings.hunter.survival.displayBar.notZeroShow) or
						(TRB.Data.settings.hunter.survival.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.hunter.survival.displayBar.neverShow == true then
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
			UpdateSnapshot_BeastMastery()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.hunter.beastMastery, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.hunter.beastMastery.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)

					local passiveValue = 0
					if TRB.Data.settings.hunter.beastMastery.bar.showPassive then
						if TRB.Data.settings.hunter.beastMastery.generation.enabled then
							if TRB.Data.settings.hunter.beastMastery.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.beastMastery.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.beastMastery.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and TRB.Data.settings.hunter.beastMastery.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.beastMastery, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.beastMastery.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local focusAmount = CalculateAbilityResourceValue(spell.focus, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.beastMastery, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.hunter.beastMastery.thresholds.width, -focusAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									if UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum then
										showThreshold = false
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime < (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration) then
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.resource >= -focusAmount then
										if TRB.Data.settings.hunter.beastMastery.audio.killShot.enabled and not TRB.Data.snapshotData.audio.playedKillShotCue then
											TRB.Data.snapshotData.audio.playedKillShotCue = true
											---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									end
								elseif spell.id == TRB.Data.spells.killCommand.id then
									if TRB.Data.spells.direPack.isActive then
										focusAmount = focusAmount * TRB.Data.spells.direPack.focusMod
										TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.beastMastery, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.hunter.beastMastery.thresholds.width, -focusAmount, TRB.Data.character.maxResource)
									end

									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshotData.resource >= -focusAmount or TRB.Data.spells.cobraSting.isActive then
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.cobraShot.id then
									if TRB.Data.spells.aspectOfTheWild.isActive then
										focusAmount = focusAmount - TRB.Data.spells.aspectOfTheWild.focusMod
										TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.beastMastery, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.hunter.beastMastery.thresholds.width, -focusAmount, TRB.Data.character.maxResource)
									end

									if TRB.Data.snapshotData.resource >= -focusAmount then
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif TRB.Data.snapshotData.resource >= -focusAmount then
									thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -focusAmount then
									thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.beastMastery.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							if TRB.Data.settings.hunter.beastMastery.thresholds[spell.settingKey].enabled and showThreshold then
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
								
                                if TRB.Data.settings.hunter.beastMastery.thresholds.icons.showCooldown and spell.hasCooldown and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) and (TRB.Data.snapshotData[spell.settingKey].maxCharges == nil or TRB.Data.snapshotData[spell.settingKey].charges < TRB.Data.snapshotData[spell.settingKey].maxCharges) then
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

					local barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.base

					local latency = TRB.Functions.GetLatency()

					local barbedShotRechargeRemaining = -(currentTime - (TRB.Data.snapshotData.barbedShot.startTime + TRB.Data.snapshotData.barbedShot.duration))
					local barbedShotTotalRechargeRemaining = barbedShotRechargeRemaining + ((1 - TRB.Data.snapshotData.barbedShot.charges) * TRB.Data.snapshotData.barbedShot.duration)
					local barbedShotPartialCharges = TRB.Data.snapshotData.barbedShot.charges + (barbedShotRechargeRemaining / TRB.Data.snapshotData.barbedShot.duration)
					local beastialWrathCooldownRemaining = GetBeastialWrathCooldownRemainingTime()
					local frenzyRemainingTime = GetFrenzyRemainingTime()
					local affectingCombat = UnitAffectingCombat("player")
					local reactionTimeGcds = math.min(gcd * 1.5, 2)

					if TRB.Data.spells.frenzy.isActive then
						if TRB.Data.snapshotData.barbedShot.charges == 2 then
							barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
						elseif TRB.Data.snapshotData.barbedShot.charges == 1 and frenzyRemainingTime <= reactionTimeGcds then
							barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
						elseif barbedShotTotalRechargeRemaining <= reactionTimeGcds and beastialWrathCooldownRemaining > 0 then
							barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
						elseif barbedShotRechargeRemaining <= reactionTimeGcds and TRB.Data.snapshotData.barbedShot.charges == 1 then
							barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
						elseif TRB.Functions.IsTalentActive(TRB.Data.spells.scentOfBlood) and barbedShotTotalRechargeRemaining <= reactionTimeGcds and beastialWrathCooldownRemaining < (TRB.Data.spells.barbedWrath.beastialWrathCooldownReduction + reactionTimeGcds) then
							barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
						elseif TRB.Functions.IsTalentActive(TRB.Data.spells.scentOfBlood) and TRB.Data.snapshotData.barbedShot.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * TRB.Data.spells.barbedWrath.beastialWrathCooldownReduction) then
							barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
						end
					else
						if affectingCombat then
							if TRB.Data.snapshotData.barbedShot.charges == 2 then
								barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
							elseif TRB.Functions.IsTalentActive(TRB.Data.spells.scentOfBlood) and TRB.Data.snapshotData.barbedShot.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * TRB.Data.spells.barbedWrath.beastialWrathCooldownReduction) then
								barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
							elseif barbedShotTotalRechargeRemaining <= reactionTimeGcds then
								barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyUse
							else
								barColor = TRB.Data.settings.hunter.beastMastery.colors.bar.frenzyHold
							end
						end
					end

					local barBorderColor = TRB.Data.settings.hunter.beastMastery.colors.bar.border

					if TRB.Data.settings.hunter.beastMastery.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.hunter.beastMastery.colors.bar.borderOvercap

						if TRB.Data.settings.hunter.beastMastery.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.hunter.beastMastery.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					if beastialWrathCooldownRemaining <= gcd and affectingCombat then
						if TRB.Data.settings.hunter.beastMastery.bar.beastialWrathEnabled then
							barBorderColor = TRB.Data.settings.hunter.beastMastery.colors.bar.borderBeastialWrath
						end

						if TRB.Data.settings.hunter.beastMastery.colors.bar.flashEnabled then
							TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.hunter.beastMastery.colors.bar.flashAlpha, TRB.Data.settings.hunter.beastMastery.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end
					else
						barContainerFrame:SetAlpha(1.0)
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.hunter.beastMastery, refreshText)
		elseif specId == 2 then
			UpdateSnapshot_Marksmanship()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.hunter.marksmanship, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.hunter.marksmanship.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					local borderColor = TRB.Data.settings.hunter.marksmanship.colors.bar.border
					if TRB.Data.settings.hunter.marksmanship.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						borderColor = TRB.Data.settings.hunter.marksmanship.colors.bar.borderOvercap

						if TRB.Data.settings.hunter.marksmanship.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					if UnitAffectingCombat("player") and TRB.Data.settings.hunter.marksmanship.steadyFocus.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.steadyFocus) then
						local timeThreshold = 0

						if TRB.Data.settings.hunter.marksmanship.steadyFocus.mode == "gcd" then
							local gcd = TRB.Functions.GetCurrentGCDTime()
							timeThreshold = gcd * TRB.Data.settings.hunter.marksmanship.steadyFocus.gcdsMax
						elseif TRB.Data.settings.hunter.marksmanship.steadyFocus.mode == "time" then
							timeThreshold = TRB.Data.settings.hunter.marksmanship.steadyFocus.timeMax
						end

						if GetSteadyFocusRemainingTime() <= timeThreshold then
							borderColor = TRB.Data.settings.hunter.marksmanship.colors.bar.borderSteadyFocus
						end
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(borderColor, true))

					local passiveValue = 0
					if TRB.Data.settings.hunter.marksmanship.bar.showPassive then
						if TRB.Data.settings.hunter.marksmanship.generation.enabled then
							if TRB.Data.settings.hunter.marksmanship.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.marksmanship.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.marksmanship.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and TRB.Data.settings.hunter.marksmanship.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local focusAmount = CalculateAbilityResourceValue(spell.focus, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.marksmanship, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.hunter.marksmanship.thresholds.width, -focusAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.arcaneShot.id then
									if TRB.Functions.IsTalentActive(TRB.Data.spells.chimaeraShot) == true then
										showThreshold = false
									elseif TRB.Data.snapshotData.resource >= -focusAmount then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.aimedShot.id then
									if TRB.Data.snapshotData.aimedShot.charges == 0 and not TRB.Data.spells.lockAndLoad.isActive then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.spells.lockAndLoad.isActive or TRB.Data.snapshotData.resource >= -focusAmount then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									if TRB.Data.settings.hunter.marksmanship.audio.aimedShot.enabled and (not TRB.Data.snapshotData.audio.playedAimedShotCue) and TRB.Data.snapshotData.aimedShot.charges >= 1 then
										local remainingCd = ((TRB.Data.snapshotData.aimedShot.startTime + TRB.Data.snapshotData.aimedShot.duration) - currentTime)
										local timeThreshold = 0
										local castTime = select(4, GetSpellInfo(spell.id)) / 1000
										if TRB.Data.settings.hunter.marksmanship.audio.aimedShot.mode == "gcd" then
											timeThreshold = gcd * TRB.Data.settings.hunter.marksmanship.audio.aimedShot.gcds
										elseif TRB.Data.settings.hunter.marksmanship.audio.aimedShot.mode == "time" then
											timeThreshold = TRB.Data.settings.hunter.marksmanship.audio.aimedShot.time
										end

										timeThreshold = timeThreshold + castTime

										if TRB.Data.snapshotData.aimedShot.charges == 2 or timeThreshold >= remainingCd then
											TRB.Data.snapshotData.audio.playedAimedShotCue = true
											---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
									elseif TRB.Data.snapshotData.aimedShot.charges == 2 then
										TRB.Data.snapshotData.audio.playedAimedShotCue = true
									end
								elseif spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									if UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum then
										showThreshold = false
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.killShot.charges == 0 then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.resource >= -focusAmount then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
										if TRB.Data.settings.hunter.marksmanship.audio.killShot.enabled and not TRB.Data.snapshotData.audio.playedKillShotCue then
											TRB.Data.snapshotData.audio.playedKillShotCue = true
											---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
									else
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									end
								end
							elseif spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif TRB.Data.snapshotData.resource >= -focusAmount then
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -focusAmount then
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							if TRB.Data.settings.hunter.marksmanship.thresholds[spell.settingKey].enabled and showThreshold then
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
								
                                if TRB.Data.settings.hunter.marksmanship.thresholds.icons.showCooldown and spell.hasCooldown and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) and (TRB.Data.snapshotData[spell.settingKey].maxCharges == nil or TRB.Data.snapshotData[spell.settingKey].charges < TRB.Data.snapshotData[spell.settingKey].maxCharges) then
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

					local barColor = TRB.Data.settings.hunter.marksmanship.colors.bar.base

					if TRB.Data.spells.trueshot.isActive then
						local timeThreshold = 0
						local useEndOfTrueshotColor = false

						if TRB.Data.settings.hunter.marksmanship.endOfTrueshot.enabled then
							useEndOfTrueshotColor = true
							if TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.hunter.marksmanship.endOfTrueshot.gcdsMax
							elseif TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode == "time" then
								timeThreshold = TRB.Data.settings.hunter.marksmanship.endOfTrueshot.timeMax
							end
						end

						if useEndOfTrueshotColor and GetTrueshotRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.hunter.marksmanship.colors.bar.trueshotEnding
						else
							barColor = TRB.Data.settings.hunter.marksmanship.colors.bar.trueshot
						end
					end
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.hunter.marksmanship, refreshText)
		elseif specId == 3 then
			UpdateSnapshot_Survival()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.hunter.survival, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.hunter.survival.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					if TRB.Data.settings.hunter.survival.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.borderOvercap, true))

						if TRB.Data.settings.hunter.survival.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.hunter.survival.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					local passiveValue = 0
					if TRB.Data.settings.hunter.survival.bar.showPassive then
						if TRB.Data.settings.hunter.survival.generation.enabled then
							if TRB.Data.settings.hunter.survival.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.survival.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.survival.generation.gcds or 2) * gcd))
							end
						end

						passiveValue = passiveValue + TRB.Data.snapshotData.termsOfEngagement.focus
					end

					if CastingSpell() and TRB.Data.settings.hunter.survival.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local focusAmount = CalculateAbilityResourceValue(spell.focus, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.survival, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.hunter.survival.thresholds.width, -focusAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									if UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum then
										showThreshold = false
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime < (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration) then
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									elseif TRB.Data.snapshotData.resource >= -focusAmount then
										if TRB.Data.settings.hunter.survival.audio.killShot.enabled and not TRB.Data.snapshotData.audio.playedKillShotCue then
											TRB.Data.snapshotData.audio.playedKillShotCue = true
											---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(TRB.Data.settings.hunter.survival.audio.killShot.sound, TRB.Data.settings.core.audio.channel.channel)
										end
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										TRB.Data.snapshotData.audio.playedKillShotCue = false
									end
								elseif spell.id == TRB.Data.spells.carve.id then
									if TRB.Data.snapshotData.carve.startTime ~= nil and currentTime < (TRB.Data.snapshotData.carve.startTime + TRB.Data.snapshotData.carve.duration) then
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshotData.resource >= -focusAmount then
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.butchery.id then
									if TRB.Data.snapshotData.butchery.charges == 0 then
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshotData.resource >= -focusAmount then
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.raptorStrike.id then
									if TRB.Functions.IsTalentActive(TRB.Data.spells.mongooseBite) then
										showThreshold = false
									else
										if TRB.Data.snapshotData.resource >= -focusAmount then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == TRB.Data.spells.mongooseBite.id then
									if not TRB.Functions.IsTalentActive(TRB.Data.spells.mongooseBite) then
										showThreshold = false
									else
										if TRB.Data.snapshotData.resource >= -focusAmount then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								end
							elseif spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif TRB.Data.snapshotData.resource >= -focusAmount then
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -focusAmount then
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							if TRB.Data.settings.hunter.survival.thresholds[spell.settingKey].enabled and showThreshold then
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
								
                                if TRB.Data.settings.hunter.survival.thresholds.icons.showCooldown and spell.hasCooldown and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) and (TRB.Data.snapshotData[spell.settingKey].maxCharges == nil or TRB.Data.snapshotData[spell.settingKey].charges < TRB.Data.snapshotData[spell.settingKey].maxCharges) then
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

					local barColor = TRB.Data.settings.hunter.survival.colors.bar.base
					if TRB.Data.settings.hunter.survival.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						if TRB.Data.settings.hunter.survival.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.hunter.survival.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					if TRB.Data.spells.coordinatedAssault.isActive then
						local timeThreshold = 0
						local useEndOfCoordinatedAssaultColor = false

						if TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.enabled then
							useEndOfCoordinatedAssaultColor = true
							if TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.gcdsMax
							elseif TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode == "time" then
								timeThreshold = TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.timeMax
							end
						end

						if useEndOfCoordinatedAssaultColor and GetCoordinatedAssaultRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssaultEnding
						else
							barColor = TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssault
						end
					end
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.hunter.survival, refreshText)
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
				if specId == 1 and TRB.Data.barConstructedForSpec == "beastMastery" then --Beast Mastery
					if spellId == TRB.Data.spells.barrage.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.barrage.startTime = currentTime
							TRB.Data.snapshotData.barrage.duration = TRB.Data.spells.barrage.cooldown
						end
					elseif spellId == TRB.Data.spells.barbedShot.id then
						if type == "SPELL_CAST_SUCCESS" then -- Barbed Shot
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.barbedShot.charges, TRB.Data.snapshotData.barbedShot.maxCharges, TRB.Data.snapshotData.barbedShot.startTime, TRB.Data.snapshotData.barbedShot.duration, _ = GetSpellCharges(TRB.Data.spells.barbedShot.id)
						end
					elseif spellId == TRB.Data.spells.barbedShot.buffId[1] or spellId == TRB.Data.spells.barbedShot.buffId[2] or spellId == TRB.Data.spells.barbedShot.buffId[3] or spellId == TRB.Data.spells.barbedShot.buffId[4] or spellId == TRB.Data.spells.barbedShot.buffId[5] then
						if type == "SPELL_AURA_APPLIED" then -- Gain Barbed Shot buff
							table.insert(TRB.Data.snapshotData.barbedShot.list, {
								ticksRemaining = TRB.Data.spells.barbedShot.ticks,
								focus = TRB.Data.snapshotData.barbedShot.ticksRemaining * TRB.Data.spells.barbedShot.focus,
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
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.killCommand.startTime, TRB.Data.snapshotData.killCommand.duration, _, _ = GetSpellCooldown(TRB.Data.spells.killCommand.id)
						end
					elseif spellId == TRB.Data.spells.beastialWrath.id then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.beastialWrath.startTime, TRB.Data.snapshotData.beastialWrath.duration, _, _ = GetSpellCooldown(TRB.Data.spells.beastialWrath.id)
					elseif spellId == TRB.Data.spells.cobraSting.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.cobraSting.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.cobraSting.isActive = false
						end
					elseif spellId == TRB.Data.spells.wailingArrow.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.wailingArrow.startTime = currentTime
							TRB.Data.snapshotData.wailingArrow.duration = TRB.Data.spells.wailingArrow.cooldown
						end
					elseif spellId == TRB.Data.spells.aMurderOfCrows.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.aMurderOfCrows.startTime = currentTime
							TRB.Data.snapshotData.aMurderOfCrows.duration = TRB.Data.spells.aMurderOfCrows.cooldown
						end
					elseif spellId == TRB.Data.spells.direPack.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, _, _, TRB.Data.snapshotData.direPack.duration, TRB.Data.snapshotData.direPack.endTime, _, _, _, TRB.Data.snapshotData.direPack.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.direPack.id)
							TRB.Data.spells.direPack.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.direPack.endTime = nil
							TRB.Data.snapshotData.direPack.duration = 0
							TRB.Data.spells.direPack.isActive = false
						end
					elseif spellId == TRB.Data.spells.aspectOfTheWild.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, _, _, TRB.Data.snapshotData.aspectOfTheWild.duration, TRB.Data.snapshotData.aspectOfTheWild.endTime, _, _, _, TRB.Data.snapshotData.aspectOfTheWild.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.aspectOfTheWild.id)
							TRB.Data.spells.aspectOfTheWild.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.aspectOfTheWild.endTime = nil
							TRB.Data.snapshotData.aspectOfTheWild.duration = 0
							TRB.Data.spells.aspectOfTheWild.isActive = false
						end
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "marksmanship" then --Marksmanship
					if spellId == TRB.Data.spells.burstingShot.id then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.burstingShot.startTime, TRB.Data.snapshotData.burstingShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.burstingShot.id)
					elseif spellId == TRB.Data.spells.aimedShot.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.aimedShot.charges, TRB.Data.snapshotData.aimedShot.maxCharges, TRB.Data.snapshotData.aimedShot.startTime, TRB.Data.snapshotData.aimedShot.duration, _ = GetSpellCharges(TRB.Data.spells.aimedShot.id)
							TRB.Data.snapshotData.audio.playedAimedShotCue = false
						end
					elseif spellId == TRB.Data.spells.barrage.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.barrage.startTime = currentTime
							TRB.Data.snapshotData.barrage.duration = TRB.Data.spells.barrage.cooldown
						end
					elseif spellId == TRB.Data.spells.explosiveShot.id then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
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
					elseif spellId == TRB.Data.spells.steadyFocus.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.steadyFocus.isActive = true
							_, _, _, _, TRB.Data.snapshotData.steadyFocus.duration, TRB.Data.snapshotData.steadyFocus.endTime, _, _, _, TRB.Data.snapshotData.steadyFocus.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.steadyFocus.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.steadyFocus.isActive = false
							TRB.Data.snapshotData.steadyFocus.spellId = nil
							TRB.Data.snapshotData.steadyFocus.duration = 0
							TRB.Data.snapshotData.steadyFocus.endTime = nil
						end
					elseif spellId == TRB.Data.spells.lockAndLoad.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.lockAndLoad.isActive = true
							_, _, _, _, TRB.Data.snapshotData.lockAndLoad.duration, TRB.Data.snapshotData.lockAndLoad.endTime, _, _, _, TRB.Data.snapshotData.lockAndLoad.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.lockAndLoad.id)

							if TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
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
							TRB.Data.snapshotData.rapidFire.focus = 0
						end
					elseif spellId == TRB.Data.spells.eagletalonsTrueFocus.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.eagletalonsTrueFocus.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.eagletalonsTrueFocus.isActive = false
						end
					elseif spellId == TRB.Data.spells.wailingArrow.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.wailingArrow.startTime = currentTime
							TRB.Data.snapshotData.wailingArrow.duration = TRB.Data.spells.wailingArrow.cooldown
						end
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "survival" then --Survival
					if spellId == TRB.Data.spells.carve.id then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.carve.startTime, TRB.Data.snapshotData.carve.duration, _, _ = GetSpellCooldown(TRB.Data.spells.carve.id)
					elseif spellId == TRB.Data.spells.flankingStrike.id then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.flankingStrike.startTime, TRB.Data.snapshotData.flankingStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.flankingStrike.id)
					elseif spellId == TRB.Data.spells.termsOfEngagement.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Terms of Engagement
							TRB.Data.snapshotData.termsOfEngagement.isActive = true
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.spells.termsOfEngagement.ticks
							TRB.Data.snapshotData.termsOfEngagement.focus = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus
							TRB.Data.snapshotData.termsOfEngagement.endTime = currentTime + TRB.Data.spells.termsOfEngagement.duration
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.spells.termsOfEngagement.ticks + 1
							TRB.Data.snapshotData.termsOfEngagement.focus = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus
							TRB.Data.snapshotData.termsOfEngagement.endTime = currentTime + TRB.Data.spells.termsOfEngagement.duration + ((TRB.Data.spells.termsOfEngagement.duration / TRB.Data.spells.termsOfEngagement.ticks) - (currentTime - TRB.Data.snapshotData.termsOfEngagement.lastTick))
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.termsOfEngagement.isActive = false
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = 0
							TRB.Data.snapshotData.termsOfEngagement.focus = 0
							TRB.Data.snapshotData.termsOfEngagement.endTime = nil
							TRB.Data.snapshotData.termsOfEngagement.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining - 1
							TRB.Data.snapshotData.termsOfEngagement.focus = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus
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
					elseif spellId == TRB.Data.spells.wildfireBomb.id then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.wildfireBomb.charges, TRB.Data.snapshotData.wildfireBomb.maxCharges, TRB.Data.snapshotData.wildfireBomb.startTime, TRB.Data.snapshotData.wildfireBomb.duration, _ = GetSpellCharges(TRB.Data.spells.wildfireBomb.id)
					end
				end

				-- Spec agnostic

				if spellId == TRB.Data.spells.killShot.id then
					TRB.Data.snapshotData.audio.playedKillShotCue = false
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
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		local specId = GetSpecialization()
		if specId == 1 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.hunter.beastMastery)
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.beastMastery)
			specCache.beastMastery.talents = TRB.Functions.GetTalents()
			FillSpellData_BeastMastery()
			TRB.Functions.LoadFromSpecCache(specCache.beastMastery)
			TRB.Functions.RefreshLookupData = RefreshLookupData_BeastMastery

			if TRB.Data.barConstructedForSpec ~= "beastMastery" then
				TRB.Data.barConstructedForSpec = "beastMastery"
				ConstructResourceBar(specCache.beastMastery.settings)
			end
		elseif specId == 2 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.hunter.marksmanship)
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.marksmanship)
			specCache.marksmanship.talents = TRB.Functions.GetTalents()
			FillSpellData_Marksmanship()
			TRB.Functions.LoadFromSpecCache(specCache.marksmanship)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Marksmanship

			if TRB.Data.barConstructedForSpec ~= "marksmanship" then
				TRB.Data.barConstructedForSpec = "marksmanship"
				ConstructResourceBar(specCache.marksmanship.settings)
			end
		elseif specId == 3 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.hunter.survival)
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.survival)
			specCache.survival.talents = TRB.Functions.GetTalents()
			FillSpellData_Survival()
			TRB.Functions.LoadFromSpecCache(specCache.survival)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Survival

			if TRB.Data.barConstructedForSpec ~= "survival" then
				TRB.Data.barConstructedForSpec = "survival"
				ConstructResourceBar(specCache.survival.settings)
			end
		else
			TRB.Data.barConstructedForSpec = nil
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
		if classIndexId == 3 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Hunter.LoadDefaultSettings()
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
							TRB.Data.settings.hunter.beastMastery = TRB.Functions.ValidateLsmValues("Beast Mastery Hunter", TRB.Data.settings.hunter.beastMastery)
							TRB.Data.settings.hunter.marksmanship = TRB.Functions.ValidateLsmValues("Marksmanship Hunter", TRB.Data.settings.hunter.marksmanship)
							TRB.Data.settings.hunter.survival = TRB.Functions.ValidateLsmValues("Survival Hunter", TRB.Data.settings.hunter.survival)
							
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
