local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 3 then --Only do this if we're on a Hunter!
	TRB.Functions.Class = TRB.Functions.Class or {}
	
	local barContainerFrame = TRB.Frames.barContainerFrame
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
		beastMastery = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
		marksmanship = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
		survival = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
	}

	local function FillSpecializationCache()
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
			specGroup = GetActiveSpecGroup(),
			petGuid = UnitGUID("pet"),
			specId = 1,
			maxResource = 100
		}

		specCache.beastMastery.spells = {
			-- Hunter Class Baseline Abilities
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				resource = -40,
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
				resource = -35,
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
				resource = -20,
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
				resource = -30,
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
				resource = -10,
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
				resource = -25,
				texture = "",
				thresholdId = 6,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				resource = -20,
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
				resource = -60,
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
				resource = -10,
				texture = "",
				thresholdId = 9,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false,
				baseDuration = 18,
				--pandemic = true,
				--pandemicTime = 18 * 0.3
			},
			alphaPredator = {
				id = 269737,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Beast Mastery Spec Baseline Abilities

			-- Beast Mastery Spec Talents			
			cobraShot = {
				id = 193455,
				name = "",
				icon = "",
				resource = -35,
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
				resource = -40,
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
				resource = 5,
				ticks = 4,
				duration = 8,
				hasCharges = true,
				hasCooldown = true,
				beastialWrathCooldownReduction = 12,
				isTalent = true
			},
			frenzy = {
				id = 272790,
				name = "",
				icon = "",
				duration = 8
			},
			cobraSting = {
				id = 392296,
				name = "",
				icon = "",
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
				resource = -30,
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
				resource = -15,
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
				resourceMod = 0.5
			},
			aspectOfTheWild = {
				id = 193530,
				name = "",
				icon = "",
				isTalent = true,
				resourceMod = -10
			},
			beastCleave = {
				id = 115939,
				name = "",
				icon = "",
				buffId = 268877,
				isTalent = true
			},
			callOfTheWild = {
				id = 359844,
				name = "",
				icon = "",
				isTalent = true
			},
			bloodFrenzy = {
				id = 407412,
				name = "",
				icon = "",
				isTalent = true
			},

			-- PvP
			direBeastBasilisk = {
				id = 205691,
				name = "",
				icon = "",
				resource = -60,
				texture = "",
				thresholdId = 14,
				settingKey = "direBeastBasilisk",
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 120,
				isPvp = true,
			},
			direBeastHawk = {
				id = 208652,
				name = "",
				icon = "",
				resource = -30,
				texture = "",
				thresholdId = 15,
				settingKey = "direBeastHawk",
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 30,
				isPvp = true,
			}
		}

		specCache.beastMastery.snapshotData.attributes.resourceRegen = 0
		specCache.beastMastery.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.killShot.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.killShot)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.killCommand.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.killCommand)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.barrage.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.barrage)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.aMurderOfCrows.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.aMurderOfCrows)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.explosiveShot.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.explosiveShot)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.beastialWrath.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.beastialWrath)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.wailingArrow.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.wailingArrow)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.direPack.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.direPack)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.aspectOfTheWild.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.aspectOfTheWild)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.callOfTheWild.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.callOfTheWild)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.beastCleave.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.beastCleave)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.frenzy.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.frenzy)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.cobraSting.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.cobraSting, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.direBeastBasilisk.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.direBeastBasilisk)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.direBeastHawk.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.direBeastHawk)
		---@type TRB.Classes.Snapshot
		specCache.beastMastery.snapshotData.snapshots[specCache.beastMastery.spells.barbedShot.id] = TRB.Classes.Snapshot:New(specCache.beastMastery.spells.barbedShot, {
			count = 0,
			ticksRemaining = 0,
			resource = 0,
			list = {}
		})

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
			specGroup = GetActiveSpecGroup(),
			specId = 2,
			maxResource = 100
		}

		specCache.marksmanship.spells = {
			
			-- Hunter Class Baseline Abilities
			arcaneShot = {
				id = 185358,
				iconName = "ability_impalingbolt",
				name = "",
				icon = "",
				resource = -40,
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
				resource = -35,
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
				resource = -20,
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
				resource = -30,
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
				resource = -10,
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
				resource = -25,
				texture = "",
				thresholdId = 6,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				resource = -20,
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
				resource = -30,
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
				resource = -10,
				texture = "",
				thresholdId = 9,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false,
				baseDuration = 18,
				--pandemic = true,
				--pandemicTime = 18 * 0.3
			},
			alphaPredator = {
				id = 269737,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Marksmanship Spec Baseline Abilities
			steadyShot = {
				id = 56641,
				name = "",
				icon = "",
				resource = 0,
				baseline = true
			},

			-- Marksmanship Spec Talents
			aimedShot = {
				id = 19434,
				name = "",
				icon = "",
				resource = -35,
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
				resource = -20, --Arcane Shot and Chimaera Shot
				isTalent = true
			},
			improvedSteadyShot = {
				id = 321018,
				name = "",
				icon = "",
				resource = 10,
				isTalent = true
			},
			rapidFire = {
				id = 257044,
				name = "",
				icon = "",
				resource = 1,
				shots = 7,
				duration = 2, --On cast then every 1/3 sec, hasted
				isTalent = true
			},
			chimaeraShot = {
				id = 342049,
				name = "",
				icon = "",
				resource = -20,
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
				isTalent = true
			},
			multiShot = {
				id = 257620,
				name = "",
				icon = "",
				resource = -20,
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
				resource = -10,
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
				talentId = 193533,
				name = "",
				icon = "",
				duration = 15,
				isTalent = true
			},
			trueshot = {
				id = 288613,
				name = "",
				icon = "",
				modifier = 1.5,
				isTalent = true
			},

			-- TODO: Bulletstorm support?
			lockAndLoad = {
				id = 194594,
				name = "",
				icon = "",
				isTalent = true
			},
			-- TODO: Apply this to Arcane Shot, Chimaera Shot, Multi-Shot, and Aimed Shot.
			eagletalonsTrueFocus = {
				id = 336851,
				name = "",
				icon = "",
				modifier = 0.75,
				isTalent = true
			},

			-- Sylvanas Bow
			wailingArrow = {
				id = 355589,
				name = "",
				icon = "",
				resource = -15,
				texture = "",
				thresholdId = 14,
				settingKey = "wailingArrow",
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 60,
				isTalent = true
			},

			-- PvP
			sniperShot = {
				id = 203155,
				name = "", 
				icon = "",
				resource = -40,
				texture = "",
				thresholdId = 15,
				settingKey = "sniperShot",
				thresholdUsable = false,
				hasCooldown = true,
				cooldown = 10,
				isPvp = true,
			}

		}

		specCache.marksmanship.snapshotData.attributes.resourceRegen = 0
		specCache.marksmanship.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false,
			playedAimedShotCue = true
		}
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.killCommand.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.killCommand)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.wailingArrow.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.wailingArrow)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.lockAndLoad.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.lockAndLoad)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.trueshot.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.trueshot)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.steadyFocus.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.steadyFocus)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.aimedShot.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.aimedShot)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.killShot.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.killShot)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.burstingShot.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.burstingShot)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.explosiveShot.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.explosiveShot)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.wailingArrow.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.wailingArrow)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.sniperShot.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.sniperShot)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.eagletalonsTrueFocus.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.eagletalonsTrueFocus, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.marksmanship.snapshotData.snapshots[specCache.marksmanship.spells.barrage.id] = TRB.Classes.Snapshot:New(specCache.marksmanship.spells.barrage)

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
				resource = 0,
				ticks = 0
			}
		}

		specCache.survival.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 3,
			maxResource = 100
		}

		specCache.survival.spells = {
			-- Hunter Class Baseline Abilities
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				resource = -40,
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
				resource = -35,
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
				resource = -20,
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
				resource = 21,
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
				resource = -10,
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
				resource = -25,
				texture = "",
				thresholdId = 6,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				resource = -20,
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
				resource = -60,
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
				resource = -10,
				texture = "",
				thresholdId = 9,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false,
				baseDuration = 18,
				--pandemic = true,
				--pandemicTime = 18 * 0.3
			},
			alphaPredator = {
				id = 269737,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Survival Spec Baseline Abilities

			-- Survival Spec Talents
			raptorStrike = {
				id = 186270,
				name = "",
				icon = "",
				resource = -30,
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
				isTalent = true,
				hasCharges = true,
				hasCooldown = true
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
				hasTicks = true,
				resourcePerTick = 2,
				tickRate = 1,
				isTalent = true
			},
			carve = {
				id = 187708,
				name = "",
				icon = "",
				resource = -35,
				texture = "",
				thresholdId = 11,
				settingKey = "carve",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},
			butchery = {
				id = 212436,
				name = "",
				icon = "",
				resource = -30,
				isTalent = true,
				hasCooldown = true,
				hasCharges = true,
				texture = "",
				thresholdId = 12,
				settingKey = "butchery",
				thresholdUsable = false
			},
			mongooseBite = {
				id = 259387,
				name = "",
				icon = "",
				resource = -30,
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
				resource = 30,
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},
			coordinatedAssault = {
				id = 266779,
				name = "",
				icon = "",
				isTalent = true
			},
		}

		specCache.survival.snapshotData.attributes.resourceRegen = 0
		specCache.survival.snapshotData.audio = {
			overcapCue = false,
			playedKillShotCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.coordinatedAssault.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.coordinatedAssault)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.termsOfEngagement.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.termsOfEngagement)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.carve.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.carve)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.killShot.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.killShot)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.killCommand.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.killCommand)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.barrage.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.barrage)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.explosiveShot.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.explosiveShot)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.butchery.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.butchery)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.flankingStrike.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.flankingStrike)
		---@type TRB.Classes.Snapshot
		specCache.survival.snapshotData.snapshots[specCache.survival.spells.wildfireBomb.id] = TRB.Classes.Snapshot:New(specCache.survival.spells.wildfireBomb)

		specCache.survival.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_BeastMastery()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "hunter", "beastMastery")
	end

	local function Setup_Marksmanship()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "hunter", "marksmanship")
	end

	local function Setup_Survival()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "hunter", "survival")
	end

	local function FillSpellData_BeastMastery()
		Setup_BeastMastery()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.beastMastery.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.beastMastery.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Focus generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barbedShot", icon = spells.barbedShot.icon, description = "Barbed Shot", printInSettings = true },
			{ variable = "#barrage", icon = spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#beastCleave", icon = spells.beastCleave.icon, description = "Beast Cleave", printInSettings = true },
			{ variable = "#beastailWrath", icon = spells.beastialWrath.icon, description = "Beastial Wrath", printInSettings = true },
			{ variable = "#cobraShot", icon = spells.cobraShot.icon, description = "Cobra Shot", printInSettings = true },
			{ variable = "#frenzy", icon = spells.frenzy.icon, description = "Frenzy", printInSettings = true },
			{ variable = "#killCommand", icon = spells.killCommand.icon, description = "Kill Command", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#multiShot", icon = spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
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

			{ variable = "$serpentSting", description = "Is Serpent Sting talented? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$ssTime", description = "Time remaining on Serpent Sting on your current target", printInSettings = true, color = false },

			{ variable = "$frenzyTime", description = "Time remaining on your pet's Frenzy buff", printInSettings = true, color = false },
			{ variable = "$frenzyStacks", description = "Current stack count on your pet's Frenzy buff", printInSettings = true, color = false },

			{ variable = "$barbedShotTicks", description = "Total number of Barbed Shot buff ticks remaining", printInSettings = true, color = false },
			{ variable = "$barbedShotTime", description = "Time remaining until the most recent Barbed Shot buff expires", printInSettings = true, color = false },
			
			{ variable = "$beastCleaveTime", description = "Time remaining on the Beast Cleave effect, either from Beast Cleave itself or from Call of the Wild with Bloody Frenzy", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.beastMastery.spells = spells
	end

	local function FillSpellData_Marksmanship()
		Setup_Marksmanship()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.marksmanship.spells)

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

			{ variable = "$serpentSting", description = "Is Serpent Sting talented? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$ssTime", description = "Time remaining on Serpent Sting on your current target", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.marksmanship.spells = spells
	end

	local function FillSpellData_Survival()
		Setup_Survival()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.survival.spells)

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

			{ variable = "$serpentSting", description = "Is Serpent Sting talented? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },
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

	--[[
	local function GetBeastialWrathCooldownRemainingTime()
		local currentTime = GetTime()
		local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[ [@as TRB.Classes.SnapshotData] ]
		local remainingTime = 0

		if TRB.Data.snapshotData.beastialWrath.duration == gcd or TRB.Data.snapshotData.beastialWrath.startTime == 0 or TRB.Data.snapshotData.beastialWrath.duration == 0 then
			remainingTime = 0
		else
			remainingTime = (TRB.Data.snapshotData.beastialWrath.startTime + TRB.Data.snapshotData.beastialWrath.duration) - currentTime
		end

		return remainingTime
	end]]

	local function CalculateAbilityResourceValue(resource, threshold)
		local modifier = 1.0
		if GetSpecialization() == 2 then
			if resource > 0 then
				local spells = TRB.Data.spells
				local trueshot = TRB.Data.snapshotData.snapshots[spells.trueshot.id] --[[@as TRB.Classes.Snapshot]]
				if trueshot.buff.isActive and not threshold then
					modifier = modifier * trueshot.spell.modifier
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
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		targetData:UpdateDebuffs(currentTime)
	end

	local function TargetsCleanup(clearAll)
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		targetData:Cleanup(clearAll)
	end

	local function ConstructResourceBar(settings)
		local spells = TRB.Data.spells

		local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end

		for k, v in pairs(spells) do
			local spell = spells[k]
			if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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

		TRB.Functions.Bar:Construct(settings)
		TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
	end

	local function RefreshLookupData_BeastMastery()
		local specSettings = TRB.Data.settings.hunter.beastMastery
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local target = targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentFocusColor = specSettings.colors.text.current
		local castingFocusColor = specSettings.colors.text.casting
		
		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then
				currentFocusColor = specSettings.colors.text.overcap
				castingFocusColor = specSettings.colors.text.overcap
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
					currentFocusColor = specSettings.colors.text.overThreshold
					castingFocusColor = specSettings.colors.text.overThreshold
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = specSettings.colors.text.spending
		end

		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, snapshotData.attributes.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)
		--$passive
		local _regenFocus = 0
		local _passiveFocus
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
		local regenFocus = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenFocus)

		--$barbedShotFocus
		local _barbedShotFocus = snapshots[spells.barbedShot.id].attributes.resource
		local barbedShotFocus = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _barbedShotFocus)

		--$barbedShotTicks
		local barbedShotTicks = string.format("%.0f", snapshots[spells.barbedShot.id].attributes.ticksRemaining)

		--$barbedShotTime
		local _barbedShotTime = snapshots[spells.barbedShot.id].buff:GetRemainingTime(currentTime)
		local barbedShotTime = string.format("%.1f", _barbedShotTime)
		
		--$beastCleaveTime
		local _beastCleaveTime = snapshots[spells.beastCleave.id].buff:GetRemainingTime(currentTime)
		local beastCleaveTime = string.format("%.1f", _beastCleaveTime)

		if talents:IsTalentActive(spells.bloodFrenzy) and (snapshots[spells.callOfTheWild.id].buff:GetRemainingTime(currentTime)) > (snapshots[spells.beastCleave.id].buff.remaining) then
			_beastCleaveTime = snapshots[spells.callOfTheWild.id].buff.remaining
		end

		beastCleaveTime = string.format("%.1f", _beastCleaveTime)
		
		_passiveFocus = _regenFocus + _barbedShotFocus
		_passiveFocusMinusRegen = _passiveFocus - _regenFocus

		local passiveFocus = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveFocus)
		local passiveFocusMinusRegen = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveFocusMinusRegen)
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
		local frenzyTime = string.format("%.1f", _frenzyTime)

		--$frenzyStacks
		local frenzyStacks = snapshots[spells.frenzy.id].buff.stacks or 0


		--$ssCount and $ssTime
		local _serpentStingCount = targetData.count[spells.serpentSting.id] or 0
		local serpentStingCount = tostring(_serpentStingCount)
		local _serpentStingTime = 0
		
		if target ~= nil then
			_serpentStingTime = target.spells[spells.serpentSting.id].remainingTime or 0
		end

		local serpentStingTime

		if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.serpentSting.id].active then
				--if target.spells[spells.serpentSting.id].remainingTime > spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _serpentStingTime)
				--[[else
					serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _serpentStingTime)
				end]]
			else
				serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			serpentStingTime = string.format("%.1f", _serpentStingTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveFocus
		Global_TwintopResourceBar.resource.regen = _regenFocus
		Global_TwintopResourceBar.resource.barbedShot = _barbedShotFocus
		Global_TwintopResourceBar.barbedShot = {
			count = snapshots[spells.barbedShot.id].attributes.count,
			focus = snapshots[spells.barbedShot.id].attributes.resource,
			ticks = snapshots[spells.barbedShot.id].attributes.ticksRemaining,
			remaining = _barbedShotTime
		}
		Global_TwintopResourceBar.dots = {
			ssCount = _serpentStingCount
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#aMurderOfCrows"] = spells.aMurderOfCrows.icon
		lookup["#arcaneShot"] = spells.arcaneShot.icon
		lookup["#barbedShot"] = spells.barbedShot.icon
		lookup["#barrage"] = spells.barrage.icon
		lookup["#beastCleave"] = spells.beastCleave.icon
		lookup["#beastialWrath"] = spells.beastialWrath.icon
		lookup["#cobraShot"] = spells.cobraShot.icon
		lookup["#frenzy"] = spells.frenzy.icon
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#killShot"] = spells.killShot.icon
		lookup["#multiShot"] = spells.multiShot.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#serpentSting"] = spells.serpentSting.icon
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

		if TRB.Data.character.maxResource == snapshotData.attributes.resource then
			lookup["$passive"] = passiveFocusMinusRegen
		else
			lookup["$passive"] = passiveFocus
		end

		lookup["$barbedShotFocus"] = barbedShotFocus
		lookup["$barbedShotTicks"] = barbedShotTicks
		lookup["$barbedShotTime"] = barbedShotTime
		lookup["$beastCleaveTime"] = beastCleaveTime
		lookup["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
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
		lookupLogic["$focus"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
		lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
		lookupLogic["$resourceTotal"] = _focusTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal

		if TRB.Data.character.maxResource == snapshotData.attributes.resource then
			lookupLogic["$passive"] = _passiveFocusMinusRegen
		else
			lookupLogic["$passive"] = _passiveFocus
		end

		lookupLogic["$barbedShotFocus"] = _barbedShotFocus
		lookupLogic["$barbedShotTicks"] = snapshots[spells.barbedShot.id].attributes.ticksRemaining
		lookupLogic["$barbedShotTime"] = _barbedShotTime
		lookupLogic["$beastCleaveTime"] = _beastCleaveTime
		lookupLogic["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
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
		local specSettings = TRB.Data.settings.hunter.marksmanship
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local target = targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentFocusColor = specSettings.colors.text.current
		local castingFocusColor = specSettings.colors.text.casting

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then
				currentFocusColor = specSettings.colors.text.overcap
				castingFocusColor = specSettings.colors.text.overcap
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
					currentFocusColor = specSettings.colors.text.overThreshold
					castingFocusColor = specSettings.colors.text.overThreshold
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = specSettings.colors.text.spending
		end

		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, snapshotData.attributes.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)
		--$passive
		local _regenFocus = 0
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
		local regenFocus = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenFocus)
		_passiveFocus = _regenFocus

		local passiveFocus = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveFocus)
		--$focusTotal
		local _focusTotal = math.min(_passiveFocus + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passiveFocus + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		--$trueshotTime
		local _trueshotTime = snapshots[spells.trueshot.id].buff:GetRemainingTime(currentTime)
		local trueshotTime = string.format("%.1f", _trueshotTime)

		--$steadyFocusTime
		local _steadyFocusTime = snapshots[spells.steadyFocus.id].buff:GetRemainingTime(currentTime)
		local steadyFocusTime = string.format("%.1f", _steadyFocusTime)

		--$lockAndLoadTime
		local _lockAndLoadTime = snapshots[spells.lockAndLoad.id].buff:GetRemainingTime(currentTime)
		local lockAndLoadTime = string.format("%.1f", _lockAndLoadTime)

		--$ssCount and $ssTime
		local _serpentStingCount = targetData.count[spells.serpentSting.id] or 0
		local serpentStingCount = tostring(_serpentStingCount)
		local _serpentStingTime = 0
		
		if target ~= nil then
			_serpentStingTime = target.spells[spells.serpentSting.id].remainingTime or 0
		end

		local serpentStingTime

		if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.serpentSting.id].active then
				--if _serpentStingTime > spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _serpentStingTime)
				--[[else
					serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _serpentStingTime)
				end]]
			else
				serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
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
		lookup["#aimedShot"] = spells.aimedShot.icon
		lookup["#arcaneShot"] = spells.arcaneShot.icon
		lookup["#barrage"] = spells.barrage.icon
		lookup["#burstingShot"] = spells.burstingShot.icon
		lookup["#chimaeraShot"] = spells.chimaeraShot.icon
		lookup["#explosiveShot"] = spells.explosiveShot.icon
		lookup["#killShot"] = spells.killShot.icon
		lookup["#lockAndLoad"] = spells.lockAndLoad.icon
		lookup["#multiShot"] = spells.multiShot.icon
		lookup["#rapidFire"] = spells.rapidFire.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#serpentSting"] = spells.serpentSting.icon
		lookup["#steadyFocus"] = spells.steadyFocus.icon
		lookup["#steadyShot"] = spells.steadyShot.icon
		lookup["#trickShots"] = spells.trickShots.icon
		lookup["#trueshot"] = spells.trueshot.icon
		lookup["$steadyFocusTime"] = steadyFocusTime
		lookup["$trueshotTime"] = trueshotTime
		lookup["$lockAndLoadTime"] = lockAndLoadTime
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
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
		lookupLogic["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
		lookupLogic["$ssCount"] = _serpentStingCount
		lookupLogic["$ssTime"] = _serpentStingTime
		lookupLogic["$focusTotal"] = _focusTotal
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$focus"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
		lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
		lookupLogic["$resourceTotal"] = _focusTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
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
		local specSettings = TRB.Data.settings.hunter.survival
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local target = targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentFocusColor = specSettings.colors.text.current
		local castingFocusColor = specSettings.colors.text.casting

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then
				currentFocusColor = specSettings.colors.text.overcap
				castingFocusColor = specSettings.colors.text.overcap
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
					currentFocusColor = specSettings.colors.text.overThreshold
					castingFocusColor = specSettings.colors.text.overThreshold
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = specSettings.colors.text.spending
		end

		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, snapshotData.attributes.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, snapshotData.casting.resourceFinal)

		--$toeFocus
		local _toeFocus = snapshots[spells.termsOfEngagement.id].buff.resource
		local toeFocus = string.format("%.0f", _toeFocus)
		--$toeTicks
		local _toeTicks = snapshots[spells.termsOfEngagement.id].buff.ticks
		local toeTicks = string.format("%.0f", _toeTicks)

		local _regenFocus = 0
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
		local regenFocus = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenFocus)
		_passiveFocus = _regenFocus + _toeFocus

		--$passive
		local passiveFocus = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveFocus)
		--$focusTotal
		local _focusTotal = math.min(_passiveFocus + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passiveFocus + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		--$coordinatedAssaultTime
		local _coordinatedAssaultTime = snapshots[spells.coordinatedAssault.id].buff:GetRemainingTime(currentTime)
		local coordinatedAssaultTime = string.format("%.1f", _coordinatedAssaultTime)

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

		if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.serpentSting.id].active then
				--if _serpentStingTime > spells.serpentSting.pandemicTime then
					serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _serpentStingTime)
				--[[else
					serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _serpentStingCount)
					serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _serpentStingTime)
				end]]
			else
				serpentStingCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _serpentStingCount)
				serpentStingTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
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
			ticks = _toeTicks
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#arcaneShot"] = spells.arcaneShot.icon
		lookup["#butchery"] = spells.butchery.icon
		lookup["#carve"] = spells.carve.icon
		lookup["#coordinatedAssault"] = spells.coordinatedAssault.icon
		lookup["#ca"] = spells.coordinatedAssault.icon
		lookup["#flankingStrike"] = spells.flankingStrike.icon
		lookup["#harpoon"] = spells.harpoon.icon
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#killShot"] = spells.killShot.icon
		lookup["#mongooseBite"] = spells.mongooseBite.icon
		lookup["#raptorStrike"] = spells.raptorStrike.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#serpentSting"] = spells.serpentSting.icon
		lookup["#termsOfEngagement"] = spells.termsOfEngagement.icon
		lookup["#wingClip"] = spells.wingClip.icon
		lookup["#wildfireBomb"] = spells.wildfireBomb.icon
		lookup["$coordinatedAssaultTime"] = coordinatedAssaultTime
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
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
		lookupLogic["$serpentSting"] = talents:IsTalentActive(spells.serpentSting)
		lookupLogic["$ssCount"] = _serpentStingCount
		lookupLogic["$ssTime"] = _serpentStingTime
		lookupLogic["$wildfireBombCharges"] = wildfireBombCharges
		lookupLogic["$focusTotal"] = _focusTotal
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$focus"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _focusPlusCasting
		lookupLogic["$resourcePlusPassive"] = _focusPlusPassive
		lookupLogic["$resourceTotal"] = _focusTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		lookupLogic["$passive"] = _passiveFocus
		lookupLogic["$regen"] = _regenFocus
		lookupLogic["$regenFocus"] = _regenFocus
		lookupLogic["$focusRegen"] = _regenFocus
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$focusOvercap"] = overcap
		lookupLogic["$toeFocus"] = _toeFocus
		lookupLogic["$toeTicks"] = _toeTicks
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
		local casting = TRB.Data.snapshotData.casting --[[@as TRB.Classes.SnapshotCasting]]
		casting.startTime = currentTime
		casting.resourceRaw = spell.resource
		casting.resourceFinal = CalculateAbilityResourceValue(spell.resource)
		casting.spellId = spell.id
		casting.icon = spell.icon
	end

	--TODO Refactor this to match other modules
	local function CastingSpell()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local casting = snapshotData.casting
		local specId = GetSpecialization()
		local currentSpell = UnitCastingInfo("player")
		local currentChannel = UnitChannelInfo("player")

		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					if spellName == spells.barrage.name then
						spells.barrage.thresholdUsable = false
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					if spellName == spells.scareBeast.name then
						FillSnapshotDataCasting(spells.scareBeast)
					elseif spellName == spells.revivePet.name then
						FillSnapshotDataCasting(spells.revivePet)
					else
						return false
					end
				end
			elseif specId == 2 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					if spellName == spells.rapidFire.name then
						local currentTime = GetTime()
						casting.spellId = spells.rapidFire.id
						casting.icon = spells.rapidFire.icon
						casting.startTime = select(4, UnitChannelInfo("player")) / 1000
						casting.endTime = select(5, UnitChannelInfo("player")) / 1000

						local duration = casting.endTime - casting.startTime
						local remainingTime = casting.endTime - currentTime
						local ticksRemaining = math.ceil(remainingTime / (duration / (spells.rapidFire.shots - 1)))

						casting.resourceRaw = ticksRemaining * spells.rapidFire.resource
						casting.resourceFinal = CalculateAbilityResourceValue(casting.resourceRaw)
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				else
					local spellName = select(1, currentSpell)
					if spellName == spells.aimedShot.name then
						FillSnapshotDataCasting(spells.aimedShot)
					elseif spellName == spells.steadyShot.name then
						if talents:IsTalentActive(spells.improvedSteadyShot) then
							FillSnapshotDataCasting(spells.improvedSteadyShot)
						else
						FillSnapshotDataCasting(spells.steadyShot)
						end
					elseif spellName == spells.scareBeast.name then
						FillSnapshotDataCasting(spells.scareBeast)
					elseif spellName == spells.revivePet.name then
						FillSnapshotDataCasting(spells.revivePet)
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
					UpdateCastingResourceFinal()
				end
				return true
			elseif specId == 3 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					if spellName == spells.scareBeast.name then
						FillSnapshotDataCasting(spells.scareBeast)
					elseif spellName == spells.revivePet.name then
						FillSnapshotDataCasting(spells.revivePet)
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	---Updates Barbed Shot buffs and cooldown
	---@param currentTime number? # Timestamp to use for calculations
	local function UpdateBarbedShot(currentTime)
		currentTime = currentTime or GetTime()
		local spells = TRB.Data.spells
		local barbedShot = TRB.Data.snapshotData.snapshots[spells.barbedShot.id] --[[@as TRB.Classes.Snapshot]]
		local entries = TRB.Functions.Table:Length(barbedShot.attributes.list)
		local totalResource = 0
		local totalTicksRemaining = 0
		local maxEndTime = nil
		local activeCount = 0
		if entries > 0 then
			for x = entries, 1, -1 do
				if barbedShot.attributes.list[x].endTime == nil or currentTime > barbedShot.attributes.list[x].endTime then
					table.remove(barbedShot.attributes.list, x)
				else
					activeCount = activeCount + 1
					barbedShot.attributes.list[x].ticksRemaining = math.ceil((barbedShot.attributes.list[x].endTime - currentTime) / (spells.barbedShot.duration / spells.barbedShot.ticks))
					barbedShot.attributes.list[x].resource = CalculateAbilityResourceValue(barbedShot.attributes.list[x].ticksRemaining * spells.barbedShot.resource)
					totalResource = totalResource + barbedShot.attributes.list[x].resource
					totalTicksRemaining = totalTicksRemaining + barbedShot.attributes.list[x].ticksRemaining

					if barbedShot.attributes.list[x].endTime > (maxEndTime or 0) then
						maxEndTime = barbedShot.attributes.list[x].endTime
					end
				end
			end
		end

		if activeCount > 0 then
			local duration = maxEndTime - currentTime
			barbedShot.buff:InitializeCustom(duration)
		else
			barbedShot.buff:Reset()
		end
		barbedShot.attributes.count = activeCount
		barbedShot.attributes.resource = totalResource
		barbedShot.attributes.ticksRemaining = totalTicksRemaining

		-- Recharge info
		barbedShot.cooldown:Refresh()
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()

		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots
		
		snapshots[spells.killShot.id].cooldown:Refresh()
		snapshots[spells.killCommand.id].cooldown:Refresh()
	end

	local function UpdateSnapshot_BeastMastery()
		UpdateSnapshot()
		UpdateBarbedShot()

		local currentTime = GetTime()
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots

		snapshots[spells.beastialWrath.id].cooldown:Refresh()
		snapshots[spells.aMurderOfCrows.id].cooldown:Refresh()
		snapshots[spells.barrage.id].cooldown:Refresh()
		snapshots[spells.wailingArrow.id].cooldown:Refresh()
		
		snapshots[spells.frenzy.id].buff:Refresh(currentTime, false, "pet")
	end

	local function UpdateSnapshot_Marksmanship()
		UpdateSnapshot()
		
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots

		snapshots[spells.aimedShot.id].cooldown:Refresh()
		snapshots[spells.burstingShot.id].cooldown:Refresh()
		snapshots[spells.barrage.id].cooldown:Refresh()
		snapshots[spells.wailingArrow.id].cooldown:Refresh()
		snapshots[spells.explosiveShot.id].cooldown:Refresh()
	end

	local function UpdateSnapshot_Survival()
		UpdateSnapshot()
		
		local currentTime = GetTime()
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots

		snapshots[spells.termsOfEngagement.id].buff:UpdateTicks(currentTime)

		snapshots[spells.butchery.id].cooldown:Refresh()
		snapshots[spells.wildfireBomb.id].cooldown:Refresh()
		snapshots[spells.carve.id].cooldown:Refresh()
		snapshots[spells.flankingStrike.id].cooldown:Refresh()
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.hunter
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]

		if specId == 1 then
			local specSettings = classSettings.beastMastery
			UpdateSnapshot_BeastMastery()
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
								passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
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
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local resourceAmount = CalculateAbilityResourceValue(spell.resource, true)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.killShot.id then
									local targetUnitHealth
									if target ~= nil then
										targetUnitHealth = target:GetHealthPercent()
									end

									if UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= spell.healthMinimum then
										showThreshold = false
										snapshotData.audio.playedKillShotCue = false
									elseif snapshots[spell.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										snapshotData.audio.playedKillShotCue = false
									elseif snapshotData.attributes.resource >= -resourceAmount then
										if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
											snapshotData.audio.playedKillShotCue = true
											PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
										end
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										snapshotData.audio.playedKillShotCue = false
									end
								elseif spell.id == spells.killCommand.id then
									if snapshots[spells.direPack.id].buff.isActive then
										resourceAmount = resourceAmount * spells.direPack.resourceMod
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif snapshotData.attributes.resource >= -resourceAmount or snapshots[spells.cobraSting.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.cobraShot.id then
									if snapshots[spells.aspectOfTheWild.id].buff.isActive then
										resourceAmount = resourceAmount - spells.aspectOfTheWild.resourceMod
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if snapshotData.attributes.resource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
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
								elseif snapshotData.attributes.resource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if snapshotData.attributes.resource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base

					local bsPartial = 0

					if snapshots[spells.barbedShot.id].cooldown.remaining > 0 and snapshots[spells.barbedShot.id].cooldown.duration > 0 then
						bsPartial = snapshots[spells.barbedShot.id].cooldown.remaining / snapshots[spells.barbedShot.id].cooldown.duration
					end

					local barbedShotPartialCharges = snapshots[spells.barbedShot.id].cooldown.charges + bsPartial
					local beastialWrathCooldownRemaining = snapshots[spells.beastialWrath.id].cooldown:GetRemainingTime(currentTime)
					local affectingCombat = UnitAffectingCombat("player")
					local reactionTimeGcds = math.min(gcd * 1.5, 2)

					if snapshots[spells.frenzy.id].buff.isActive then
						if snapshots[spells.barbedShot.id].cooldown.charges == 2 then
							barColor = specSettings.colors.bar.frenzyUse
						elseif snapshots[spells.barbedShot.id].cooldown.charges == 1 and snapshots[spells.frenzy.id].buff:GetRemainingTime(currentTime) <= reactionTimeGcds then
							barColor = specSettings.colors.bar.frenzyUse
						elseif snapshots[spells.barbedShot.id].cooldown.remainingTotal <= reactionTimeGcds and beastialWrathCooldownRemaining > 0 then
							barColor = specSettings.colors.bar.frenzyUse
						elseif snapshots[spells.barbedShot.id].cooldown.remaining <= reactionTimeGcds and snapshots[spells.barbedShot.id].cooldown.charges == 1 then
							barColor = specSettings.colors.bar.frenzyUse
						elseif talents:IsTalentActive(spells.scentOfBlood) and snapshots[spells.barbedShot.id].cooldown.remainingTotal <= reactionTimeGcds and beastialWrathCooldownRemaining < (spells.barbedWrath.beastialWrathCooldownReduction + reactionTimeGcds) then
							barColor = specSettings.colors.bar.frenzyUse
						elseif talents:IsTalentActive(spells.scentOfBlood) and snapshots[spells.barbedShot.id].cooldown.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * spells.barbedWrath.beastialWrathCooldownReduction) then
							barColor = specSettings.colors.bar.frenzyUse
						end
					else
						if affectingCombat then
							if snapshots[spells.barbedShot.id].cooldown.charges == 2 then
								barColor = specSettings.colors.bar.frenzyUse
							elseif talents:IsTalentActive(spells.scentOfBlood) and snapshots[spells.barbedShot.id].cooldown.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * spells.barbedWrath.beastialWrathCooldownReduction) then
								barColor = specSettings.colors.bar.frenzyUse
							elseif snapshots[spells.barbedShot.id].cooldown.remainingTotal <= reactionTimeGcds then
								barColor = specSettings.colors.bar.frenzyUse
							else
								barColor = specSettings.colors.bar.frenzyHold
							end
						end
					end

					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.beastCleave.enabled and TRB.Functions.Class:IsValidVariableForSpec("$beastCleaveTime") then
						barBorderColor = specSettings.colors.bar.beastCleave.color
					end

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.overcapCue = false
					end

					if beastialWrathCooldownRemaining <= gcd and affectingCombat then
						if specSettings.colors.bar.beastialWrathEnabled then
							barBorderColor = specSettings.colors.bar.borderBeastialWrath
						end

						if specSettings.colors.bar.flashEnabled then
							TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end
					else
						barContainerFrame:SetAlpha(1.0)
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.marksmanship
			UpdateSnapshot_Marksmanship()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
					local borderColor = specSettings.colors.bar.border
					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						borderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.overcapCue = false
					end

					if UnitAffectingCombat("player") and specSettings.steadyFocus.enabled and talents:IsTalentActive(spells.steadyFocus) then
						local timeThreshold = 0

						if specSettings.steadyFocus.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.steadyFocus.gcdsMax
						elseif specSettings.steadyFocus.mode == "time" then
							timeThreshold = specSettings.steadyFocus.timeMax
						end

						if snapshots[spells.steadyFocus.id].buff:GetRemainingTime(currentTime) <= timeThreshold then
							borderColor = specSettings.colors.bar.borderSteadyFocus
						end
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(borderColor, true))

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
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local resourceAmount = CalculateAbilityResourceValue(spell.resource, true)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.arcaneShot.id then
									if talents:IsTalentActive(spells.chimaeraShot) == true then
										showThreshold = false
									elseif snapshotData.attributes.resource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.aimedShot.id then
									if snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif snapshots[spells.lockAndLoad.id].buff.isActive or snapshotData.attributes.resource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									if specSettings.audio.aimedShot.enabled and (not snapshotData.audio.playedAimedShotCue) and snapshots[spells.aimedShot.id].cooldown:IsUsable() then
										local remainingCd = snapshots[spells.aimedShot.id].cooldown.GetRemainingTime(currentTime)
										local timeThreshold = 0
										local castTime = select(4, GetSpellInfo(spell.id)) / 1000
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
								elseif spell.id == spells.killShot.id then
									local targetUnitHealth
									if target ~= nil then
										targetUnitHealth = target:GetHealthPercent()
									end

									if UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= spells.killShot.healthMinimum then
										showThreshold = false
										snapshotData.audio.playedKillShotCue = false
									elseif snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										snapshotData.audio.playedKillShotCue = false
									elseif snapshotData.attributes.resource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
										if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
											snapshotData.audio.playedKillShotCue = true
											PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
										end
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										snapshotData.audio.playedKillShotCue = false
									end
								end
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.hasCooldown then
								if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif snapshotData.attributes.resource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if snapshotData.attributes.resource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
						end
						pairOffset = pairOffset + 3
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
					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 3 then
			local specSettings = classSettings.survival
			UpdateSnapshot_Survival()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.borderOvercap, true))

						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.border, true))
						snapshotData.audio.overcapCue = false
					end

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if specSettings.generation.enabled then
							if specSettings.generation.mode == "time" then
								passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
							end
						end

						passiveValue = passiveValue + snapshots[spells.termsOfEngagement.id].buff.resource
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
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local resourceAmount = CalculateAbilityResourceValue(spell.resource, true)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.killShot.id then
									local targetUnitHealth
									if target ~= nil then
										targetUnitHealth = target:GetHealthPercent()
									end
									
									if UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= spells.killShot.healthMinimum then
										showThreshold = false
										snapshotData.audio.playedKillShotCue = false
									elseif snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										snapshotData.audio.playedKillShotCue = false
									elseif snapshotData.attributes.resource >= -resourceAmount then
										if specSettings.audio.killShot.enabled and not snapshotData.audio.playedKillShotCue then
											snapshotData.audio.playedKillShotCue = true
											PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
										end
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										snapshotData.audio.playedKillShotCue = false
									end
								elseif spell.id == spells.raptorStrike.id then
									if talents:IsTalentActive(spells.mongooseBite) then
										showThreshold = false
									else
										if snapshotData.attributes.resource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.mongooseBite.id then
									if not talents:IsTalentActive(spells.mongooseBite) then
										showThreshold = false
									else
										if snapshotData.attributes.resource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								end
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.hasCooldown then
								if snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif snapshotData.attributes.resource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if snapshotData.attributes.resource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base
					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.overcapCue = false
					end

					if snapshots[spells.coordinatedAssault.id].buff.isActive then
						local timeThreshold = 0
						local useEndOfCoordinatedAssaultColor = false

						if specSettings.endOfCoordinatedAssault.enabled then
							useEndOfCoordinatedAssaultColor = true
							if specSettings.endOfCoordinatedAssault.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfCoordinatedAssault.gcdsMax
							elseif specSettings.endOfCoordinatedAssault.mode == "time" then
								timeThreshold = specSettings.endOfCoordinatedAssault.timeMax
							end
						end

						if useEndOfCoordinatedAssaultColor and snapshots[spells.coordinatedAssault.id].buff:GetRemainingTime(currentTime) <= timeThreshold then
							barColor = specSettings.colors.bar.coordinatedAssaultEnding
						else
							barColor = specSettings.colors.bar.coordinatedAssault
						end
					end
					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
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
				if specId == 1 and TRB.Data.barConstructedForSpec == "beastMastery" then --Beast Mastery
					if spellId == spells.barrage.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.barbedShot.id then
						snapshots[spellId].cooldown:Initialize()
					elseif spellId == spells.barbedShot.buffId[1] or spellId == spells.barbedShot.buffId[2] or spellId == spells.barbedShot.buffId[3] or spellId == spells.barbedShot.buffId[4] or spellId == spells.barbedShot.buffId[5] then
						if type == "SPELL_AURA_APPLIED" then -- Gain Barbed Shot buff
							table.insert(snapshots[spells.barbedShot.id].attributes.list, {
								ticksRemaining = spells.barbedShot.ticks,
								resource = snapshots[spells.barbedShot.id].attributes.ticksRemaining * spells.barbedShot.resource,
								endTime = currentTime + spells.barbedShot.duration
							})
						end
					elseif spellId == spells.frenzy.id and destGUID == TRB.Data.character.petGuid then
						snapshots[spellId].buff:Initialize(type, nil, "pet")
					elseif spellId == spells.killCommand.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.beastialWrath.id then
						snapshots[spellId].cooldown:Initialize()
					elseif spellId == spells.cobraSting.id then
						snapshots[spellId].buff:Initialize(type, true)
					elseif spellId == spells.wailingArrow.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.aMurderOfCrows.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.direPack.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.aspectOfTheWild.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.callOfTheWild.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.beastCleave.buffId then
						snapshots[spells.beastCleave.id].buff:Initialize(type)
					elseif spellId == spells.direBeastBasilisk.id then
						snapshots[spellId].cooldown:Initialize()
					elseif spellId == spells.direBeastHawk.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "marksmanship" then --Marksmanship
					if spellId == spells.burstingShot.id then
						snapshots[spellId].cooldown:Initialize()
					elseif spellId == spells.aimedShot.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
							snapshotData.audio.playedAimedShotCue = false
						end
					elseif spellId == spells.barrage.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.explosiveShot.id then
						snapshots[spellId].cooldown:Initialize()
					elseif spellId == spells.trueshot.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.steadyFocus.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.lockAndLoad.id then
						snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.enabled then
								PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.lockAndLoad.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == spells.eagletalonsTrueFocus.id then
						snapshots[spellId].buff:Initialize(type, true)
					elseif spellId == spells.wailingArrow.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.sniperShot.id then
						snapshots[spellId].cooldown:Initialize()
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "survival" then --Survival
					if spellId == spells.carve.id then
						snapshots[spellId].cooldown:Initialize()
					elseif spellId == spells.flankingStrike.id then
						snapshots[spellId].cooldown:Initialize()
					elseif spellId == spells.termsOfEngagement.id then
						snapshots[spells.termsOfEngagement.id].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" then
							snapshots[spells.termsOfEngagement.id].buff:UpdateTicks(currentTime)
						end
					elseif spellId == spells.coordinatedAssault.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.wildfireBomb.id then
						snapshots[spellId].cooldown:Initialize()
					end
				end

				-- Spec agnostic

				if spellId == spells.killShot.id then
					snapshotData.audio.playedKillShotCue = false
				elseif spellId == spells.serpentSting.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
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
			specCache.beastMastery.talents:GetTalents()
			FillSpellData_BeastMastery()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.beastMastery)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.serpentSting)

			TRB.Functions.RefreshLookupData = RefreshLookupData_BeastMastery
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.hunter.beastMastery)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.beastMastery)

			if TRB.Data.barConstructedForSpec ~= "beastMastery" then
				talents = specCache.beastMastery.talents
				TRB.Data.barConstructedForSpec = "beastMastery"
				ConstructResourceBar(specCache.beastMastery.settings)
			end
		elseif specId == 2 then
			specCache.marksmanship.talents:GetTalents()
			FillSpellData_Marksmanship()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.marksmanship)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.serpentSting)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Marksmanship
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.hunter.marksmanship)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.marksmanship)

			if TRB.Data.barConstructedForSpec ~= "marksmanship" then
				talents = specCache.marksmanship.talents
				TRB.Data.barConstructedForSpec = "marksmanship"
				ConstructResourceBar(specCache.marksmanship.settings)
			end
		elseif specId == 3 then
			specCache.survival.talents:GetTalents()
			FillSpellData_Survival()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.survival)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.serpentSting)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Survival
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.hunter.survival)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.survival)


			if TRB.Data.barConstructedForSpec ~= "survival" then
				talents = specCache.survival.talents
				TRB.Data.barConstructedForSpec = "survival"
				ConstructResourceBar(specCache.survival.settings)
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
		if classIndexId == 3 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
						TRB.Options:PortForwardSettings()

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
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
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

			if TRB.Details.addonData.loaded and specId > 0 then
				if not TRB.Details.addonData.optionsPanel then
					TRB.Details.addonData.optionsPanel = true
					-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
					C_Timer.After(0, function()
						C_Timer.After(1, function()
							TRB.Data.settings.hunter.beastMastery = TRB.Functions.LibSharedMedia:ValidateLsmValues("Beast Mastery Hunter", TRB.Data.settings.hunter.beastMastery)
							TRB.Data.settings.hunter.marksmanship = TRB.Functions.LibSharedMedia:ValidateLsmValues("Marksmanship Hunter", TRB.Data.settings.hunter.marksmanship)
							TRB.Data.settings.hunter.survival = TRB.Functions.LibSharedMedia:ValidateLsmValues("Survival Hunter", TRB.Data.settings.hunter.survival)
							
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
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshotData
		TRB.Functions.Character:CheckCharacter()
		TRB.Data.character.className = "hunter"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Focus)

		if specId == 1 then
			TRB.Data.character.specName = "beastMastery"
		elseif specId == 2 then
			TRB.Data.character.specName = "marksmanship"
		elseif specId == 3 then
			TRB.Data.character.specName = "survival"
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.hunter.beastMastery == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.beastMastery)
			TRB.Data.specSupported = true
		elseif specId == 2 and TRB.Data.settings.core.enabled.hunter.marksmanship == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.marksmanship)
			TRB.Data.specSupported = true
		elseif specId == 3 and TRB.Data.settings.core.enabled.hunter.survival == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.hunter.survival)
			TRB.Data.specSupported = true
		else
			TRB.Data.specSupported = false
		end

		if TRB.Data.specSupported then
			TRB.Data.resource = Enum.PowerType.Focus
			TRB.Data.resourceFactor = 1

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
					(not TRB.Data.settings.hunter.beastMastery.displayBar.alwaysShow) and (
						(not TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow) or
						(TRB.Data.settings.hunter.beastMastery.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
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
						(TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
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
						(TRB.Data.settings.hunter.survival.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.hunter.survival.displayBar.neverShow == true then
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
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshotData.targetData
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
			settings = TRB.Data.settings.hunter.beastMastery
		elseif specId == 2 then
			settings = TRB.Data.settings.hunter.marksmanship
		elseif specId == 3 then
			settings = TRB.Data.settings.hunter.survival
		else
			return false
		end

		if specId == 1 then --Beast Mastery
			if var == "$barbedShotFocus" then
				if snapshots[spells.barbedShot.id].buff.isActive then
					valid = true
				end
			elseif var == "$barbedShotTicks" then
				if snapshots[spells.barbedShot.id].buff.isActive then
					valid = true
				end
			elseif var == "$barbedShotTime" then
				if snapshots[spells.barbedShot.id].buff.isActive then
					valid = true
				end
			elseif var == "$frenzyTime" then
				if snapshots[spells.frenzy.id].buff.isActive then
					valid = true
				end
			elseif var == "$frenzyStacks" then
				if snapshots[spells.frenzy.id].buff.isActive then
					valid = true
				end
			elseif var == "$beastCleaveTime" then
				if snapshots[spells.beastCleave.id].buff.isActive or snapshots[spells.callOfTheWild.id].buff.isActive then
					valid = true
				end
			end
		elseif specId == 2 then --Marksmanship
			if var == "$trueshotTime" then
				if snapshots[spells.trueshot.id].buff.isActive then
					valid = true
				end
			elseif var == "$steadyFocusTime" then
				if snapshots[spells.steadyFocus.id].buff.isActive then
					valid = true
				end
			elseif var == "$lockAndLoadTime" then
				if snapshots[spells.lockAndLoad.id].buff.isActive then
					valid = true
				end
			end
		elseif specId == 3 then --Survivial
			if var == "$coordinatedAssaultTime" then
				if snapshots[spells.coordinatedAssault.id].buff.isActive then
					valid = true
				end
			elseif var == "$toeFocus" then
				if snapshots[spells.termsOfEngagement.id].buff.isActive then
					valid = true
				end
			elseif var == "$toeTicks" then
				if snapshots[spells.termsOfEngagement.id].buff.isActive then
					valid = true
				end
			elseif var == "$wildfireBombCharges" then
				if snapshots[spells.wildfireBomb.id].cooldown:IsUsable() then
					valid = true
				end
			end
		end

		if var == "$resource" or var == "$focus" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$focusMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$focusTotal" then
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
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$focusPlusPassive" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if settings.generation.enabled then
				if snapshotData.attributes.resource < TRB.Data.character.maxResource and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				elseif specId == 1 and TRB.Functions.Class:IsValidVariableForSpec("$barbedShotFocus") then
					valid = true
				elseif specId == 3 and snapshots[spells.termsOfEngagement.id].buff.isActive then
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
			end
		end

		return valid
	end

	function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
		local specId = GetSpecialization()
		local settings = TRB.Data.settings.hunter
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if specId == 1 then
		elseif specId == 2 then
		elseif specId == 3 then
		end
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
end