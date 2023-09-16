local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 11 then --Only do this if we're on a Druid!
	TRB.Functions.Class = TRB.Functions.Class or {}
	
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
		balance = {
			snapshot = {},
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
		feral = {
			snapshot = {},
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
		guardian = {
			snapshot = {},
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
		restoration = {
			snapshot = {},
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
	

	---@type TRB.Classes.SnapshotData
	specCache.balance.snapshotData = TRB.Classes.SnapshotData:New()

	---@type TRB.Classes.SnapshotData
	specCache.feral.snapshotData = TRB.Classes.SnapshotData:New({
		bleeds = {}
	})
	
	---@type TRB.Classes.SnapshotData
	specCache.guardian.snapshotData = TRB.Classes.SnapshotData:New()
	
	---@type TRB.Classes.SnapshotData
	specCache.restoration.snapshotData = TRB.Classes.SnapshotData:New()

	local function CalculateManaGain(mana, isPotion)
		if isPotion == nil then
			isPotion = false
		end

		local modifier = 1.0

		if isPotion then
			if TRB.Data.character.items.alchemyStone then
				modifier = modifier * TRB.Data.spells.alchemistStone.manaModifier
			end
		end

		return mana * modifier
	end

	local function FillSpecializationCache()
		-- Balance
		specCache.balance.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0
			},
			dots = {
				sunfireCount = 0,
				moonfireCount = 0,
				stellarFlareCount = 0
			},
			furyOfElune = {
				astralPower = 0,
				ticks = 0,
				remaining = 0
			}
		}
		
		specCache.balance.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			starsurgeThreshold = 40,
			starfallThreshold = 50,
			pandemicModifier = 1.0,
			effects = {
			}
		}

		specCache.balance.spells = {
			-- Druid Class Baseline Abilities
			moonfire = {
				id = 164812,
				name = "",
				icon = "",
				astralPower = 6,
				pandemic = true,
				pandemicTime = 22 * 0.3,
				baseline = true
			},
		
			-- Druid Class Talents
			starfire = {
				id = 194153,
				name = "",
				icon = "",
				astralPower = 10,
				baseline = true,
				isTalent = true
			},
			starsurge = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				astralPower = -40,
				thresholdId = 1,
				settingKey = "starsurge",
				thresholdUsable = false,
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			starsurge2 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				astralPower = -80,
				thresholdId = 2,
				settingKey = "starsurge2",
				thresholdUsable = false,
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			starsurge3 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				astralPower = -120,
				thresholdId = 3,
				settingKey = "starsurge3",
				thresholdUsable = false,
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			moonkinForm = {
				id = 24858,
				name = "",
				icon = "",
				isTalent = true
			},
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				astralPower = 6,
				pandemic = true,
				pandemicTime = 18 * 0.3,
				isTalent = true
			},

			-- Balance Spec Baseline Abilities
			wrath = {
				id = 190984,
				name = "",
				icon = "",
				astralPower = 8
			},

			-- Balance Spec Talents
			eclipse = {
				id = 79577,
				name = "",
				icon = "",
				isTalent = true
			},
			eclipseSolar = {
				id = 48517,
				name = "",
				icon = ""
			},
			eclipseLunar = {
				id = 48518,
				name = "",
				icon = ""
			},
			naturesBalance = {
				id = 202430,
				name = "",
				icon = "",
				astralPower = 2,
				outOfCombatAstralPower = 6,
				tickRate = 3,
				isTalent = true
			},
			starfall = {
				id = 191034,
				name = "",
				icon = "",
				texture = "",
				astralPower = -50,
				thresholdId = 4,
				settingKey = "starfall",
				thresholdUsable = false,
				pandemic = true,
				pandemicTime = 8 * 0.3,
				isTalent = true,
				isSnowflake = true
			},
			stellarFlare = {
				id = 202347,
				name = "",
				icon = "",
				astralPower = 10,
				pandemic = true,
				pandemicTime = 24 * 0.3,
				isTalent = true
			},
			wildSurges = {
				id = 406890,
				name = "",
				icon = "",
				isTalent = true,
				modifier = 2
			},
			rattleTheStars = {
				id = 340049,
				name = "",
				icon = "",
				buffId = 393955,
				modifier = -0.05,
				isTalent = true
			},
			starweaver = {
				id = 393940,
				name = "",
				icon = "",
				isTalent = true
			},
			starweaversWarp = { --Free Starfall
				id = 393942,
				name = "",
				icon = ""
			},
			starweaversWeft = { --Free Starsurge
				id = 393944,
				name = "",
				icon = ""
			},
			celestialAlignment = {
				id = 194223,
				name = "",
				icon = "",
				isTalent = true
			},
			primordialArcanicPulsar = {
				id = 393961,
				name = "",
				icon = "",
				talentId = 393960,
				maxAstralPower = 600,
				isTalent = true
			},
			soulOfTheForest = {
				id = 114107,
				name = "",
				icon = "",
				modifier = {
					wrath = 0.3,
					starfire = 0.2
				},
				isTalent = true
			},
			-- TODO: Add Wild Mushroom + associated tracking
			incarnationChosenOfElune = {
				id = 102560,
				talentId = 394013,
				name = "",
				icon = "",
				isTalent = true
			},
			elunesGuidance = {
				id = 393991,
				name = "",
				icon = "",
				modifierStarsurge = -8,
				modifierStarfall = -10,
				isTalent = true
			},
			furyOfElune = {
				id = 202770,
				name = "",
				icon = "",
				duration = 8,
				resourcePerTick = 2.5,
				hasTicks = true,
				tickRate = 0.5,
				isTalent = true
			},
			newMoon = {
				id = 274281,
				name = "",
				icon = "",
				astralPower = 12,
				recharge = 20,
				isTalent = true
			},
			halfMoon = {
				id = 274282,
				name = "",
				icon = "",
				astralPower = 24
			},
			fullMoon = {
				id = 274283,
				name = "",
				icon = "",
				astralPower = 50
			},
			sunderedFirmament = {
				id = 394094,
				name = "",
				icon = "",
				buffId = 394108,
				hasTicks = true,
				resourcePerTick = 0.5,
				tickRate = 0.5,
				isTalent = true
			},
			touchTheCosmos = { -- T29 4P
				id = 394414,
				name = "",
				icon = "",
				astralPowerMod = -5
			}
		}
		
		specCache.balance.snapshotData.audio = {
			playedSsCue = false,
			playedSfCue = false,
			playedstarweaverCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.moonkinForm.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.moonkinForm, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.furyOfElune.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.furyOfElune)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.sunderedFirmament.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.sunderedFirmament)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.eclipseSolar.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.eclipseSolar)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.eclipseLunar.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.eclipseLunar)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.celestialAlignment.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.celestialAlignment)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.incarnationChosenOfElune.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.incarnationChosenOfElune)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.starfall.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.starfall)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.newMoon.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.newMoon, {
			currentSpellId = nil,
			currentIcon = "",
			currentKey = "",
			checkAfter = nil
		})
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.starweaversWarp.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.starweaversWarp)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.starweaversWeft.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.starweaversWeft)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.rattleTheStars.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.rattleTheStars)
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.primordialArcanicPulsar.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.primordialArcanicPulsar, nil, true)
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.primordialArcanicPulsar.id].buff:SetCustomProperties({
			{
				name = "currentAstralPower",
				dataType = "number",
				index = 16
			}
		})
		---@type TRB.Classes.Snapshot
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.touchTheCosmos.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.touchTheCosmos)

		-- Feral
		specCache.feral.Global_TwintopResourceBar = {
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

		specCache.feral.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			maxResource2 = 5,
			pandemicModifier = 1.0,
			effects = {
			}
		}

		specCache.feral.spells = {
			-- Racial abilities
			shadowmeld = {
				id = 58984,
				name = "",
				icon = ""
			},

			-- Druid Class Baseline Abilities
			catForm = {
				id = 768,
				name = "",
				icon = "",
				baseline = true
			},

			-- Druid Class Talents
			rake = {
				id = 155722,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 1,
				settingKey = "rake",
				thresholdUsable = false,
				hasSnapshot = true,
				pandemic = true,
				pandemicTime = 15 * 0.3,
				bonuses = {
					stealth = true,
					tigersFury = true
				},
				isTalent = true,
				baseline = true
			},
			thrash = {
				id = 405233,
				talentId = 106830,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				thresholdId = 2,
				texture = "",
				settingKey = "thrash",
				thresholdUsable = false,
				hasSnapshot = true,
				pandemic = true,
				pandemicTime = 15 * 0.3,
				bonuses = {
					momentOfClarity = true,
					tigersFury = true
				},
				isTalent = true
			},
			rip = {
				id = 1079,
				name = "",
				icon = "",
				energy = -20,
				comboPoints = true,
				thresholdId = 4,
				texture = "",
				settingKey = "rip",
				thresholdUsable = false,
				hasSnapshot = true,
				pandemicTimes = {
					8 * 0.3, -- 0 CP, show same as if we had 1
					8 * 0.3,
					12 * 0.3,
					16 * 0.3,
					20 * 0.3,
					24 * 0.3
				},
				bonuses = {
					bloodtalons = true,
					tigersFury = true
				},
				isTalent = true,
				baseline = true
			},
			maim = {
				id = 22570,
				name = "",
				icon = "",
				energy = -30,
				comboPoints = true,
				texture = "",
				thresholdId = 5,
				settingKey = "maim",
				hasCooldown = true,
				cooldown = 20,
				thresholdUsable = false,
				isTalent = true
			},
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				astralPower = 2,
				pandemic = true,
				pandemicTime = 13.5 * 0.3,
				isTalent = true
			},

			-- Feral Spec Baseline Abilities
			ferociousBite = {
				id = 22568,
				name = "",
				icon = "",
				energy = -25,
				energyMax = -50,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "ferociousBite",
				isSnowflake = true, -- Really between 25-50 energy, minus Relentless Predator
				thresholdUsable = false,
				relentlessPredator = true
			},
			ferociousBiteMinimum = {
				id = 22568,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 7,
				settingKey = "ferociousBiteMinimum",
				isSnowflake = true,
				thresholdUsable = false,
				relentlessPredator = true
			},
			ferociousBiteMaximum = {
				id = 22568,
				name = "",
				icon = "",
				energy = -50,
				comboPoints = true,
				texture = "",
				thresholdId = 8,
				settingKey = "ferociousBiteMaximum",
				isSnowflake = true,
				thresholdUsable = false,
				relentlessPredator = true
			},
			prowl = {
				id = 5215,
				name = "",
				icon = "",
				idIncarnation = 102547,
				modifier = 1.6
			},
			shred = {
				id = 5221,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 9,
				settingKey = "shred",
				thresholdUsable = false,
				isClearcasting = true
			},
			swipe = {
				id = 106785,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				thresholdId = 3,
				texture = "",
				settingKey = "swipe",
				thresholdUsable = false,
				isSnowflake = true,
				isTalent = false,
				baseline = true
			},

			-- Feral Spec Talents
			tigersFury = {
				id = 5217,
				name = "",
				icon = "",
				modifier = 1.15,
				hasCooldown = true,
				isTalent = true
			},
			omenOfClarity = {
				id = 16864,
				name = "",
				icon = "",
				isTalent = true
			},
			momentOfClarity = {
				id = 236068,
				name = "",
				icon = "",
				modifier = 1.15,
				isTalent = true
			},
			clearcasting = {
				id = 135700,
				name = "",
				icon = ""
			},
			primalWrath = {
				id = 285381,
				name = "",
				icon = "",
				energy = -20,
				comboPoints = true,
				thresholdId = 10,
				texture = "",
				settingKey = "primalWrath",
				isTalent = true,
				thresholdUsable = false
			},
			lunarInspiration = {
				id = 155580,
				name = "",
				icon = "",
				isTalent = true
			},
			moonfire = {
				id = 155625,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 1,
				thresholdId = 11,
				texture = "",
				settingKey = "moonfire",
				isSnowflake = true,
				thresholdUsable = false,
				hasSnapshot = true,
				pandemic = true,
				pandemicTime = 16 * 0.3,
				bonuses = {
					tigersFury = true
				}
			},
			suddenAmbush = {
				id = 384667,
				name = "",
				icon = "",
				isTalent = true
			},
			berserk = {
				id = 106951,
				name = "",
				icon = "",
				isTalent = true,
				energizeId = 343216,
				tickRate = 1.5
			},
			predatorySwiftness = {
				id = 69369,
				name = "",
				icon = "",
				isTalent = true
			},
			brutalSlash = {
				id = 202028,
				name = "",
				icon = "",
				cooldown = 8,
				isHasted = true,
				energy = -25,
				comboPointsGenerated = 1,
				thresholdId = 12,
				texture = "",
				settingKey = "brutalSlash",
				isSnowflake = true,
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				isClearcasting = true,
				hasCharges = true
			},
			carnivorousInstinct = {
				id = 390902,
				name = "",
				icon = "",
				modifierPerStack = 0.06,
				isTalent = true
			},
			bloodtalons = {
				id = 145152,
				name = "",
				icon = "",
				window = 4,
				energy = -80, --Make this dynamic
				thresholdId = 13,
				texture = "",
				settingKey = "bloodtalons",
				isTalent = true,
				--isSnowflake = true,
				thresholdUsable = false,
				modifier = 1.25
			},
			feralFrenzy = {
				id = 274837,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 5,
				thresholdId = 14,
				texture = "",
				settingKey = "feralFrenzy",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			incarnationAvatarOfAshamane = {
				id = 102543,
				name = "",
				icon = "",
				energyModifier = 0.8
			}, 
			relentlessPredator = {
				id = 393771,
				name = "",
				icon = "",
				isTalent = true,
				energyModifier = 0.8
			},
			circleOfLifeAndDeath = {
				id = 391969,
				name = "",
				icon = "",
				isTalent = true,
				modifier = 0.75
			},
			apexPredatorsCraving = {
				id = 391882,
				name = "",
				icon = ""
			},
			
			-- T30 4P
			predatorRevealed = {
				id = 408468,
				name = "",
				icon = "",
				energizeId = 411344,
				tickRate = 2.0,
				spellKey = "predatorRevealed"
			}
		}

		specCache.feral.snapshotData.attributes.energyRegen = 0
		specCache.feral.snapshotData.attributes.comboPoints = 0
		specCache.feral.snapshotData.audio = {
			overcapCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.maim.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.maim)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.brutalSlash.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.brutalSlash)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.feralFrenzy.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.feralFrenzy)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.clearcasting.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.clearcasting)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.tigersFury.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.tigersFury)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.shadowmeld.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.shadowmeld, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.prowl.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.prowl, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.suddenAmbush.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.suddenAmbush)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.berserk.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.berserk, {
			lastTick = nil,
			nextTick = nil,
			untilNextTick = 0,
			ticks = 0,
		})
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.incarnationAvatarOfAshamane.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.incarnationAvatarOfAshamane)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.bloodtalons.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.bloodtalons)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.apexPredatorsCraving.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.apexPredatorsCraving)
		---@type TRB.Classes.Snapshot
		specCache.feral.snapshotData.snapshots[specCache.feral.spells.predatorRevealed.id] = TRB.Classes.Snapshot:New(specCache.feral.spells.predatorRevealed, {
			lastTick = nil,
			nextTick = nil,
			untilNextTick = 0,
			ticks = 0
		})



		-- Guardian
		specCache.guardian.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
			}
		}

		specCache.guardian.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			effects = {},
			items = {}
		}

		specCache.guardian.spells = {
			-- Druid Class Baseline Abilities
			rebirth = {
				id = 20484,
				name = "",
				icon = "",
				rage = -30,
				baseline = true,
				thresholdId = 1,
				texture = "",
				settingKey = "rebirth",
				thresholdUsable = false,
				hasCooldown = true,
				hasCharges = true
			},
			moonfire = {
				id = 164812,
				name = "",
				icon = "",
				pandemic = true,
				pandemicTime = 18 * 0.3
			},

			-- Druid Class Talents
			frenziedRegeneration = {
				id = 22842,
				name = "",
				icon = "",
				rage = -10,
				baseline = true,
				hasCharges = true,
				hasCooldown = true,
				thresholdId = 2,
				texture = "",
				settingKey = "frenziedRegeneration",
				thresholdUsable = false
			},
			ironfur = {
				id = 192081,
				name = "",
				icon = "",
				isTalent = true,
				rage = -40,
				thresholdId = 3,
				texture = "",
				settingKey = "ironfur",
				thresholdUsable = false
			},

			-- Guardian Spec Baseline Abilities
			-- Guardian Spec Talents
			maul = {
				id = 6807,
				name = "",
				icon = "",
				rage = -40,
				isTalent = true,
				thresholdId = 4,
				texture = "",
				settingKey = "maul",
				thresholdUsable = false,
				--isSnowflake = true
			},
			berserk = {
				id = 50334,
				name = "",
				icon = "",
				isTalent = true
			},
			berserkPersistence = {
				id = 50334,
				name = "",
				icon = "",
				isTalent = true,
				nodeId = 82144
			},
			berserkUncheckedAggression = {
				id = 50334,
				name = "",
				icon = "",
				isTalent = true,
				nodeId = 82155
			},
			incarnationGuardianOfUrsoc = {
				id = 102558,
				name = "",
				icon = "",
				isTalent = true
			},
			raze = {
				id = 400254,
				name = "",
				icon = "",
				rage = -40,
				isTalent = true,
				thresholdId = 5,
				texture = "",
				settingKey = "raze",
				thresholdUsable = false,
				--isSnowflake = true
			},
			afterTheWildfire = {
				id = 371905,
				name = "",
				icon = "",
				isTalent = true,
				maxRage = 200
			},
		}

		specCache.guardian.snapshotData.audio = {
		}
		---@type TRB.Classes.Snapshot
		specCache.guardian.snapshotData.snapshots[specCache.guardian.spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(specCache.guardian.spells.frenziedRegeneration)
		---@type TRB.Classes.Snapshot
		specCache.guardian.snapshotData.snapshots[specCache.guardian.spells.rebirth.id] = TRB.Classes.Snapshot:New(specCache.guardian.spells.rebirth)
		---@type TRB.Classes.Snapshot
		specCache.guardian.snapshotData.snapshots[specCache.guardian.spells.ironfur.id] = TRB.Classes.Snapshot:New(specCache.guardian.spells.ironfur)
		---@type TRB.Classes.Snapshot
		specCache.guardian.snapshotData.snapshots[specCache.guardian.spells.berserk.id] = TRB.Classes.Snapshot:New(specCache.guardian.spells.berserk)
		---@type TRB.Classes.Snapshot
		specCache.guardian.snapshotData.snapshots[specCache.guardian.spells.incarnationGuardianOfUrsoc.id] = TRB.Classes.Snapshot:New(specCache.guardian.spells.incarnationGuardianOfUrsoc)
		---@type TRB.Classes.Snapshot
		specCache.guardian.snapshotData.snapshots[specCache.guardian.spells.afterTheWildfire.id] = TRB.Classes.Snapshot:New(specCache.guardian.spells.afterTheWildfire, nil, true)
		specCache.guardian.snapshotData.snapshots[specCache.guardian.spells.afterTheWildfire.id].buff:SetCustomProperties({
			{
				name = "currentRage",
				dataType = "number",
				index = 16
			}
		})

		specCache.guardian.barTextVariables = {
			icons = {},
			values = {}
		}

		-- Restoration
		specCache.restoration.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
			},
			dots = {
			},
		}

		specCache.restoration.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			effects = {
			},
			items = {
				potions = {
					aeratedManaPotionRank3 = {
						id = 191386,
						mana = 27600
					},
					aeratedManaPotionRank2 = {
						id = 191385,
						mana = 24000
					},
					aeratedManaPotionRank1 = {
						id = 191384,
						mana = 20869
					},
					potionOfFrozenFocusRank3 = {
						id = 191365,
						mana = 48300
					},
					potionOfFrozenFocusRank2 = {
						id = 191364,
						mana = 42000
					},
					potionOfFrozenFocusRank1 = {
						id = 191363,
						mana = 36521
					},
				},
				conjuredChillglobe = {
					id = 194300,
					isEquipped = false,
					equippedVersion = "lfr",
					manaThresholdPercent = 0.65,
					lfr = {
						bonusId = 7982,
						mana = 10877
					},
					normal = {
						bonusId = 7979,
						mana = 11735
					},
					heroic = {
						bonusId = 7980,
						mana = 14430
					},
					mythic = {
						bonusId = 7981,
						mana = 17625
					}
				},
				alchemyStone = false
			}
		}

		specCache.restoration.spells = {
			-- Druid Class Baseline Abilities
			moonfire = {
				id = 164812,
				name = "",
				icon = "",
				astralPower = 2,
				pandemic = true,
				pandemicTime = 16 * 0.3
			},

			-- Druid Class Talents
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				isTalent = true,
				pandemic = true,
				pandemicTime = 12 * 0.3
			},

			-- Restoration Spec Baseline Abilities
			-- Restoration Spec Talents
			efflorescence = {
				id = 145205,
				name = "",
				icon = "",
				duration = 30,
				isTalent = true
			},
			incarnationTreeOfLife = {
				id = 117679,
				name = "",
				icon = ""
			},
			cenariusGuidance = {
				id = 393371,
				name = "",
				icon = "",
				isTalent = true
			},
			reforestation = {
				id = 392360,
				name = "",
				icon = "",
				--isTalent = true
			},
			clearcasting = {
				id = 16870,
				name = "",
				icon = ""
			},

			-- External mana
			innervate = { -- Technically a talent but we can get it from outside/don't do any talent checks with it
				id = 29166,
				name = "",
				icon = ""
			},
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 4.0, --Hasted
				manaPercent = 0.03,
				ticks = 4,
				tickId = 265144
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8
			},

			-- Potions
			aeratedManaPotionRank1 = {
				id = 191384,
				itemId = 191384,
				spellId = 370607,
				iconName = "inv_10_alchemy_bottle_shape1_blue",
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 1,
				settingKey = "aeratedManaPotionRank1",
				thresholdUsable = false
			},
			aeratedManaPotionRank2 = {
				itemId = 191385,
				spellId = 370607,
				iconName = "inv_10_alchemy_bottle_shape1_blue",
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 2,
				settingKey = "aeratedManaPotionRank2",
				thresholdUsable = false
			},
			aeratedManaPotionRank3 = {
				itemId = 191386,
				spellId = 370607,
				iconName = "inv_10_alchemy_bottle_shape1_blue",
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 3,
				settingKey = "aeratedManaPotionRank3",
				thresholdUsable = false
			},
			potionOfFrozenFocusRank1 = {
				id = 371033,
				itemId = 191363,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 4,
				settingKey = "potionOfFrozenFocusRank1",
				thresholdUsable = false
			},
			potionOfFrozenFocusRank2 = {
				itemId = 191364,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 5,
				settingKey = "potionOfFrozenFocusRank2",
				thresholdUsable = false
			},
			potionOfFrozenFocusRank3 = {
				itemId = 191365,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 6,
				settingKey = "potionOfFrozenFocusRank3",
				thresholdUsable = false
			},
			potionOfChilledClarity = {
				id = 371052,
				name = "",
				icon = ""
			},

			-- Conjured Chillglobe
			conjuredChillglobe = {
				id = 396391,
				itemId = 194300,
				spellId = 396391,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 7,
				settingKey = "conjuredChillglobe",
				thresholdUsable = false,
			},

			-- Alchemist Stone
			alchemistStone = {
				id = 17619,
				name = "",
				icon = "",
				manaModifier = 1.4,
				itemIds = {
					171323,
					175941,
					175942,
					175943
				}
			},

			-- Rashok's Molten Heart
			moltenRadiance = {
				id = 409898,
				name = "",
				icon = "",
			}

		}

		specCache.restoration.snapshotData.attributes.manaRegen = 0
		specCache.restoration.snapshotData.audio = {
			innervateCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.efflorescence.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.efflorescence)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.clearcasting.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.clearcasting)
		---@type TRB.Classes.Healer.Innervate
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.innervate.id] = TRB.Classes.Healer.Innervate:New(specCache.restoration.spells.innervate)
		---@type TRB.Classes.Healer.ManaTideTotem
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(specCache.restoration.spells.manaTideTotem)
		---@type TRB.Classes.Healer.SymbolOfHope
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(specCache.restoration.spells.symbolOfHope, CalculateManaGain)
		---@type TRB.Classes.Healer.ChanneledManaPotion
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(specCache.restoration.spells.potionOfFrozenFocusRank1, CalculateManaGain)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.aeratedManaPotionRank1)
		---@type TRB.Classes.Healer.PotionOfChilledClarity
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(specCache.restoration.spells.potionOfChilledClarity)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.reforestation.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.reforestation)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.conjuredChillglobe)
		---@type TRB.Classes.Healer.MoltenRadiance
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(specCache.restoration.spells.moltenRadiance)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.incarnationTreeOfLife.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.incarnationTreeOfLife)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.reforestation.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.reforestation)

		specCache.restoration.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Balance()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "druid", "balance")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.balance)
	end

	local function FillSpellData_Balance()
		Setup_Balance()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.balance.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.balance.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Astral Power generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#moonkinForm", icon = spells.moonkinForm.icon, description = "Moonkin Form", printInSettings = true },

			{ variable = "#wrath", icon = spells.wrath.icon, description = "Wrath", printInSettings = true },
			{ variable = "#starfire", icon = spells.starfire.icon, description = "Starfire", printInSettings = true },
			
			{ variable = "#sunfire", icon = spells.sunfire.icon, description = "Sunfire", printInSettings = true },
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = "Moonfire", printInSettings = true },
			
			{ variable = "#starsurge", icon = spells.starsurge.icon, description = "Starsurge", printInSettings = true },
			{ variable = "#starfall", icon = spells.fullMoon.icon, description = "Starfall", printInSettings = true },
			{ variable = "#starweaver", icon = spells.starweaversWarp.icon .. " or " .. spells.starweaversWeft.icon, description = "Starweaver's Warp or Weft, whichever is active", printInSettings = true },
			{ variable = "#starweaversWarp", icon = spells.starweaversWarp.icon, description = spells.starweaversWarp.name, printInSettings = true },
			{ variable = "#starweaversWeft", icon = spells.starweaversWeft.icon, description = spells.starweaversWeft.name, printInSettings = true },

			{ variable = "#pulsar", icon = spells.primordialArcanicPulsar.icon, description = "Primordial Arcanic Pulsar", printInSettings = true },
			{ variable = "#pap", icon = spells.primordialArcanicPulsar.icon, description = "Primordial Arcanic Pulsar", printInSettings = false },
			{ variable = "#primordialArcanicPulsar", icon = spells.primordialArcanicPulsar.icon, description = "Primordial Arcanic Pulsar", printInSettings = false },

			{ variable = "#eclipse", icon = spells.incarnationChosenOfElune.icon .. spells.celestialAlignment.icon .. spells.eclipseSolar.icon .. " or " .. spells.eclipseLunar.icon, description = "Current active Eclipse", printInSettings = true },
			{ variable = "#celestialAlignment", icon = spells.celestialAlignment.icon, description = "Celestial Alignment", printInSettings = true },			
			{ variable = "#icoe", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = true },			
			{ variable = "#coe", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = false },			
			{ variable = "#incarnation", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = false },			
			{ variable = "#incarnationChosenOfElune", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = false },			
			{ variable = "#solar", icon = spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = true },
			{ variable = "#eclipseSolar", icon = spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = false },
			{ variable = "#solarEclipse", icon = spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = false },
			{ variable = "#lunar", icon = spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = true },
			{ variable = "#eclipseLunar", icon = spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = false },
			{ variable = "#lunarEclipse", icon = spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = false },
			
			{ variable = "#naturesBalance", icon = spells.naturesBalance.icon, description = "Nature's Balance", printInSettings = true },
			
			{ variable = "#soulOfTheForest", icon = spells.soulOfTheForest.icon, description = "Soul of the Forest", printInSettings = true },
			
			{ variable = "#stellarFlare", icon = spells.stellarFlare.icon, description = "Stellar Flare", printInSettings = true },

			{ variable = "#foe", icon = spells.furyOfElune.icon, description = "Fury Of Elune", printInSettings = false },
			{ variable = "#furyOfElune", icon = spells.furyOfElune.icon, description = "Fury Of Elune", printInSettings = true },
			
			{ variable = "#sunderedFirmament", icon = spells.sunderedFirmament.icon, description = spells.sunderedFirmament.name, printInSettings = true },
			
			{ variable = "#newMoon", icon = spells.newMoon.icon, description = "New Moon", printInSettings = true },
			{ variable = "#halfMoon", icon = spells.halfMoon.icon, description = "Half Moon", printInSettings = true },
			{ variable = "#fullMoon", icon = spells.fullMoon.icon, description = "Full Moon", printInSettings = true },
			{ variable = "#moon", icon = spells.newMoon.icon .. spells.halfMoon.icon .. spells.fullMoon.icon, description = "Current Moon", printInSettings = true },
		}
		specCache.balance.barTextVariables.values = {
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

			{ variable = "$moonkinForm", description = "Currently in Moonkin Form. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$eclipse", description = "Currently in any kind of Eclipse. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$eclipseTime", description = "Remaining duration of Eclipse.", printInSettings = true, color = false },
			{ variable = "$lunar", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = true, color = false },
			{ variable = "$lunarEclipse", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$eclipseLunar", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$solar", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = true, color = false },
			{ variable = "$solarEclipse", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$eclipseSolar", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$celestialAlignment", description = "Currently in/using CA/I: CoE. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$pulsarCollected", description = "Current amount of Astral Power that Primordial Arcanic Pulsar has collected", printInSettings = true, color = false },
			{ variable = "$pulsarCollectedPercent", description = "Current percentage of Astral Power that Primordial Arcanic Pulsar has collected before triggering", printInSettings = true, color = false },
			{ variable = "$pulsarRemaining", description = "Amount of Astral Power remaining until Primordial Arcanic Pulsar grants Celestial Alignment", printInSettings = true, color = false },
			{ variable = "$pulsarRemainingPercent", description = "Percentage of Astral Power remaining until Primordial Arcanic Pulsar grants Celestial Alignment", printInSettings = true, color = false },
			{ variable = "$pulsarNextStarsurge", description = "Will the next Starsurge grant Celestial Alignment from Pulsar? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$pulsarNextStarfall", description = "Will the next Starfall grant Celestial Alignment from Pulsar? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$pulsarStarsurgeCount", description = "How many more Starsurges are required to grant Celestial Alignment from Pulsar", printInSettings = true, color = false },
			{ variable = "$pulsarStarfallCount", description = "How many more Starfalls are required to grant Celestial Alignment from Pulsar", printInSettings = true, color = false },

			{ variable = "$astralPower", description = "Current Astral Power", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Astral Power", printInSettings = false, color = false },
			{ variable = "$astralPowerMax", description = "Maximum Astral Power", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Astral Power", printInSettings = false, color = false },
			{ variable = "$casting", description = "Astral Power from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Astral Power from Passive Sources", printInSettings = true, color = false },
			{ variable = "$astralPowerPlusCasting", description = "Current + Casting Astral Power Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Astral Power Total", printInSettings = false, color = false },
			{ variable = "$astralPowerPlusPassive", description = "Current + Passive Astral Power Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Astral Power Total", printInSettings = false, color = false },
			{ variable = "$astralPowerTotal", description = "Current + Passive + Casting Astral Power Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Astral Power Total", printInSettings = false, color = false },	 
			{ variable = "$foeAstralPower", description = "Passive Astral Power incoming from Fury of Elune", printInSettings = true, color = false },   
			{ variable = "$foeTicks", description = "Number of ticks of Fury of Elune remaining", printInSettings = true, color = false },   
			{ variable = "$foeTime", description = "Amount of time remaining on Fury of Elune's effect", printInSettings = true, color = false },		
			{ variable = "$sunderedFirmamentAstralPower", description = "Passive Astral Power incoming from Sundered Firmament", printInSettings = true, color = false },   
			{ variable = "$sunderedFirmamentTicks", description = "Number of ticks of Sundered Firmament remaining", printInSettings = true, color = false },   
			{ variable = "$sunderedFirmamentTime", description = "Amount of time remaining on Sundered Firmament's effect", printInSettings = true, color = false },   

			{ variable = "$sunfireCount", description = "Number of Sunfires active on targets", printInSettings = true, color = false },
			{ variable = "$sunfireTime", description = "Time remaining on Sunfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = "Number of Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$stellarFlareCount", description = "Number of Stellar Flares active on targets", printInSettings = true, color = false },
			{ variable = "$stellarFlareTime", description = "Time remaining on Stellar Flare on your current target", printInSettings = true, color = false },

			{ variable = "$moonAstralPower", description = "Amount of Astral Power your next New/Half/Full Moon cast will generate", printInSettings = true, color = false },   
			{ variable = "$moonCharges", description = "Number of charges you currently have for New/Half/Full Moon", printInSettings = true, color = false },   
			{ variable = "$moonCooldown", description = "Time remaining until your next New/Half/Full Moon recharge", printInSettings = true, color = false },
			{ variable = "$moonCooldownTotal", description = "Time remaining until New/Half/Full Moon has full charges", printInSettings = true, color = false },

			{ variable = "$starweaverTime", description = "Time remaining on Starweaver's Warp/Weft buff", printInSettings = true, color = false },
			{ variable = "$starweaver", description = "Starweaver's Warp/Weft proc is active. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$starweaversWarp", description = "Starweaver's Warp proc is active. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$starweaversWeft", description = "Starweaver's Warp proc is active. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.balance.spells = spells
	end

	local function Setup_Feral()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "druid", "feral")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.feral)
	end

	local function FillSpellData_Feral()
		Setup_Feral()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.feral.spells)
		

		-- This is done here so that we can get icons for the options menu!
		specCache.feral.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Astral Power generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#apexPredatorsCraving", icon = spells.apexPredatorsCraving.icon, description = spells.apexPredatorsCraving.name, printInSettings = true },
			{ variable = "#berserk", icon = spells.berserk.icon, description = spells.berserk.name, printInSettings = true },
			{ variable = "#bloodtalons", icon = spells.bloodtalons.icon, description = spells.bloodtalons.name, printInSettings = true },
			{ variable = "#brutalSlash", icon = spells.brutalSlash.icon, description = spells.brutalSlash.name, printInSettings = true },
			{ variable = "#carnivorousInstinct", icon = spells.carnivorousInstinct.icon, description = spells.carnivorousInstinct.name, printInSettings = true },
			{ variable = "#catForm", icon = spells.catForm.icon, description = spells.catForm.name, printInSettings = true },
			{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
			{ variable = "#feralFrenzy", icon = spells.feralFrenzy.icon, description = spells.feralFrenzy.name, printInSettings = true },
			{ variable = "#ferociousBite", icon = spells.ferociousBite.icon, description = spells.ferociousBite.name, printInSettings = true },
			{ variable = "#incarnation", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = true },
			{ variable = "#incarnationAvatarOfAshamane", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = false },
			{ variable = "#lunarInspiration", icon = spells.lunarInspiration.icon, description = spells.lunarInspiration.name, printInSettings = true },
			{ variable = "#maim", icon = spells.maim.icon, description = spells.maim.name, printInSettings = true },
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = spells.moonfire.name, printInSettings = true },
			{ variable = "#predatorySwiftness", icon = spells.predatorySwiftness.icon, description = spells.predatorySwiftness.name, printInSettings = true },
			{ variable = "#predatorRevealed", icon = spells.predatorRevealed.icon, description = spells.predatorRevealed.name, printInSettings = true },
			{ variable = "#primalWrath", icon = spells.primalWrath.icon, description = spells.primalWrath.name, printInSettings = true },
			{ variable = "#prowl", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = true },
			{ variable = "#stealth", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = false },
			{ variable = "#rake", icon = spells.rake.icon, description = spells.rake.name, printInSettings = true },
			{ variable = "#rip", icon = spells.rip.icon, description = spells.rip.name, printInSettings = true },
			{ variable = "#shadowmeld", icon = spells.shadowmeld.icon, description = spells.shadowmeld.name, printInSettings = true },
			{ variable = "#shred", icon = spells.shred.icon, description = spells.shred.name, printInSettings = true },
			{ variable = "#suddenAmbush", icon = spells.suddenAmbush.icon, description = spells.suddenAmbush.name, printInSettings = true },
			{ variable = "#swipe", icon = spells.swipe.icon, description = spells.swipe.name, printInSettings = true },
			{ variable = "#thrash", icon = spells.thrash.icon, description = spells.thrash.name, printInSettings = true },
			{ variable = "#tigersFury", icon = spells.tigersFury.icon, description = spells.tigersFury.name, printInSettings = true },
		}
		specCache.feral.barTextVariables.values = {
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
			{ variable = "$casting", description = "Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources", printInSettings = true, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },	 
			
			{ variable = "$comboPoints", description = "Current Combo Points", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Combo Points", printInSettings = true, color = false },

			{ variable = "$ripCount", description = "Number of Rips active on targets", printInSettings = true, color = false },
			{ variable = "$ripTime", description = "Time remaining on Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripSnapshot", description = "Snapshot percentage of Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripPercent", description = "Snapshot percentage vs. recasting of Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripCurrent", description = "Current snapshot percentage damage if Rip was used right now", printInSettings = true, color = false },

			{ variable = "$rakeCount", description = "Number of Rakes active on targets", printInSettings = true, color = false },
			{ variable = "$rakeTime", description = "Time remaining on Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakeSnapshot", description = "Snapshot percentage of Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakePercent", description = "Snapshot percentage vs. recasting of Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakeCurrent", description = "Current snapshot percentage damage if Rake was used right now", printInSettings = true, color = false },
			
			{ variable = "$thrashCount", description = "Number of Thrashs active on targets", printInSettings = true, color = false },
			{ variable = "$thrashTime", description = "Time remaining on Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashSnapshot", description = "Snapshot percentage of Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashPercent", description = "Snapshot percentage vs. recasting of Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashCurrent", description = "Current snapshot percentage damage if Thrash was used right now", printInSettings = true, color = false },
			
			{ variable = "$moonfireCount", description = "Number of Lunar Inspiration's Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireSnapshot", description = "Snapshot percentage of Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfirePercent", description = "Snapshot percentage vs. recasting of Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCurrent", description = "Current snapshot percentage damage if Lunar Inspiration's Moonfire was used right now", printInSettings = true, color = false },
			
			{ variable = "$lunarInspiration", description = "Is Lunar Inspiration currently talented. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$brutalSlashCharges", description = "Number of charges you currently have for Brutal Slash (if talented)", printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldown", description = "Time remaining until your next Brutal Slash recharge (if talented)", printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldownTotal", description = "Time remaining until Brutal Slash has full charges (if talented)", printInSettings = true, color = false },  
			
			{ variable = "$bloodtalonsStacks", description = "Number of stacks of Bloodtalons available to use (if talented)", printInSettings = true, color = false },
			{ variable = "$bloodtalonsTime", description = "Time remaining on your Bloodtalons proc (if talented)", printInSettings = true, color = false },
			
			{ variable = "$clearcastingStacks", description = "Number of stacks of Clearcasting available to use", printInSettings = true, color = false },
			{ variable = "$clearcastingTime", description = "Time remaining on your Clearcasting proc", printInSettings = true, color = false },
			
			{ variable = "$berserkTime", description = "Time remaining on your Berserk or Incarnation: King of the Jungle buff", printInSettings = true, color = false },
			{ variable = "$incarnationTime", description = "Time remaining on your Berserk or Incarnation: King of the Jungle buff", printInSettings = false, color = false },

			{ variable = "$suddenAmbushTime", description = "Time remaining on your Sudden Ambush proc", printInSettings = true, color = false },
			
			{ variable = "$apexPredatorsCravingTime", description = "Time remaining on your Apex Predator's Craving proc (if equipped)", printInSettings = true, color = false },
			
			{ variable = "$tigersFuryTime", description = "Time remaining on your Tiger's Fury buff", printInSettings = true, color = false },
			{ variable = "$tigersFuryCooldownTime", description = "Time remaining on your Tiger's Fury ability cooldown", printInSettings = true, color = false },

			{ variable = "$predatorRevealedTime", description = "Time remaining on your Predator Revealed proc", printInSettings = true, color = false },
			{ variable = "$predatorRevealedTicks", description = "Number of remaining ticks / incoming Combo Points from your Predator Revealed proc", printInSettings = true, color = false },
			{ variable = "$predatorRevealedTickTime", description = "Time until the next tick / Combo Point generation occurs from your Predator Revealed proc", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.feral.spells = spells
	end

	local function Setup_Guardian()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "druid", "guardian")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.guardian)
	end

	local function FillSpellData_Guardian()
		Setup_Guardian()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.guardian.spells)
		

		-- This is done here so that we can get icons for the options menu!
		specCache.guardian.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Astral Power generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			--[[
			{ variable = "#apexPredatorsCraving", icon = spells.apexPredatorsCraving.icon, description = spells.apexPredatorsCraving.name, printInSettings = true },
			{ variable = "#berserk", icon = spells.berserk.icon, description = spells.berserk.name, printInSettings = true },
			{ variable = "#bloodtalons", icon = spells.bloodtalons.icon, description = spells.bloodtalons.name, printInSettings = true },
			{ variable = "#brutalSlash", icon = spells.brutalSlash.icon, description = spells.brutalSlash.name, printInSettings = true },
			{ variable = "#carnivorousInstinct", icon = spells.carnivorousInstinct.icon, description = spells.carnivorousInstinct.name, printInSettings = true },
			{ variable = "#catForm", icon = spells.catForm.icon, description = spells.catForm.name, printInSettings = true },
			{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
			{ variable = "#guardianFrenzy", icon = spells.guardianFrenzy.icon, description = spells.guardianFrenzy.name, printInSettings = true },
			{ variable = "#ferociousBite", icon = spells.ferociousBite.icon, description = spells.ferociousBite.name, printInSettings = true },
			{ variable = "#incarnation", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = true },
			{ variable = "#incarnationAvatarOfAshamane", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = false },
			{ variable = "#lunarInspiration", icon = spells.lunarInspiration.icon, description = spells.lunarInspiration.name, printInSettings = true },
			{ variable = "#maim", icon = spells.maim.icon, description = spells.maim.name, printInSettings = true },
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = spells.moonfire.name, printInSettings = true },
			{ variable = "#predatorySwiftness", icon = spells.predatorySwiftness.icon, description = spells.predatorySwiftness.name, printInSettings = true },
			{ variable = "#predatorRevealed", icon = spells.predatorRevealed.icon, description = spells.predatorRevealed.name, printInSettings = true },
			{ variable = "#primalWrath", icon = spells.primalWrath.icon, description = spells.primalWrath.name, printInSettings = true },
			{ variable = "#prowl", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = true },
			{ variable = "#stealth", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = false },
			{ variable = "#rake", icon = spells.rake.icon, description = spells.rake.name, printInSettings = true },
			{ variable = "#rip", icon = spells.rip.icon, description = spells.rip.name, printInSettings = true },
			{ variable = "#shadowmeld", icon = spells.shadowmeld.icon, description = spells.shadowmeld.name, printInSettings = true },
			{ variable = "#shred", icon = spells.shred.icon, description = spells.shred.name, printInSettings = true },
			{ variable = "#suddenAmbush", icon = spells.suddenAmbush.icon, description = spells.suddenAmbush.name, printInSettings = true },
			{ variable = "#swipe", icon = spells.swipe.icon, description = spells.swipe.name, printInSettings = true },
			{ variable = "#thrash", icon = spells.thrash.icon, description = spells.thrash.name, printInSettings = true },
			{ variable = "#tigersFury", icon = spells.tigersFury.icon, description = spells.tigersFury.name, printInSettings = true },]]
		}
		specCache.guardian.barTextVariables.values = {
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

			{ variable = "$rage", description = "Current Rage", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Rage", printInSettings = false, color = false },
			{ variable = "$rageMax", description = "Maximum Rage", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Rage", printInSettings = false, color = false },
			{ variable = "$casting", description = "Rage from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Rage from Passive Sources", printInSettings = true, color = false },
			{ variable = "$ragePlusCasting", description = "Current + Casting Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$ragePlusPassive", description = "Current + Passive Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Rage Total", printInSettings = false, color = false },
			{ variable = "$rageTotal", description = "Current + Passive + Casting Rage Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Rage Total", printInSettings = false, color = false },	 
			--[[
			{ variable = "$comboPoints", description = "Current Combo Points", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Combo Points", printInSettings = true, color = false },

			{ variable = "$ripCount", description = "Number of Rips active on targets", printInSettings = true, color = false },
			{ variable = "$ripTime", description = "Time remaining on Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripSnapshot", description = "Snapshot percentage of Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripPercent", description = "Snapshot percentage vs. recasting of Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripCurrent", description = "Current snapshot percentage damage if Rip was used right now", printInSettings = true, color = false },

			{ variable = "$rakeCount", description = "Number of Rakes active on targets", printInSettings = true, color = false },
			{ variable = "$rakeTime", description = "Time remaining on Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakeSnapshot", description = "Snapshot percentage of Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakePercent", description = "Snapshot percentage vs. recasting of Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakeCurrent", description = "Current snapshot percentage damage if Rake was used right now", printInSettings = true, color = false },
			
			{ variable = "$thrashCount", description = "Number of Thrashs active on targets", printInSettings = true, color = false },
			{ variable = "$thrashTime", description = "Time remaining on Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashSnapshot", description = "Snapshot percentage of Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashPercent", description = "Snapshot percentage vs. recasting of Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashCurrent", description = "Current snapshot percentage damage if Thrash was used right now", printInSettings = true, color = false },
			
			{ variable = "$moonfireCount", description = "Number of Lunar Inspiration's Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireSnapshot", description = "Snapshot percentage of Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfirePercent", description = "Snapshot percentage vs. recasting of Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCurrent", description = "Current snapshot percentage damage if Lunar Inspiration's Moonfire was used right now", printInSettings = true, color = false },
			
			{ variable = "$lunarInspiration", description = "Is Lunar Inspiration currently talented. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$brutalSlashCharges", description = "Number of charges you currently have for Brutal Slash (if talented)", printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldown", description = "Time remaining until your next Brutal Slash recharge (if talented)", printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldownTotal", description = "Time remaining until Brutal Slash has full charges (if talented)", printInSettings = true, color = false },  
			
			{ variable = "$bloodtalonsStacks", description = "Number of stacks of Bloodtalons available to use (if talented)", printInSettings = true, color = false },
			{ variable = "$bloodtalonsTime", description = "Time remaining on your Bloodtalons proc (if talented)", printInSettings = true, color = false },
			
			{ variable = "$clearcastingStacks", description = "Number of stacks of Clearcasting available to use", printInSettings = true, color = false },
			{ variable = "$clearcastingTime", description = "Time remaining on your Clearcasting proc", printInSettings = true, color = false },
			
			{ variable = "$berserkTime", description = "Time remaining on your Berserk or Incarnation: King of the Jungle buff", printInSettings = true, color = false },
			{ variable = "$incarnationTime", description = "Time remaining on your Berserk or Incarnation: King of the Jungle buff", printInSettings = false, color = false },

			{ variable = "$suddenAmbushTime", description = "Time remaining on your Sudden Ambush proc", printInSettings = true, color = false },
			
			{ variable = "$apexPredatorsCravingTime", description = "Time remaining on your Apex Predator's Craving proc (if equipped)", printInSettings = true, color = false },
			
			{ variable = "$tigersFuryTime", description = "Time remaining on your Tiger's Fury buff", printInSettings = true, color = false },
			{ variable = "$tigersFuryCooldownTime", description = "Time remaining on your Tiger's Fury ability cooldown", printInSettings = true, color = false },

			{ variable = "$predatorRevealedTime", description = "Time remaining on your Predator Revealed proc", printInSettings = true, color = false },
			{ variable = "$predatorRevealedTicks", description = "Number of remaining ticks / incoming Combo Points from your Predator Revealed proc", printInSettings = true, color = false },
			{ variable = "$predatorRevealedTickTime", description = "Time until the next tick / Combo Point generation occurs from your Predator Revealed proc", printInSettings = true, color = false },]]

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.guardian.spells = spells
	end

	local function Setup_Restoration()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "druid", "restoration")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)
	end

	local function FillSpellData_Restoration()
		Setup_Restoration()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.restoration.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.restoration.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#efflorescence", icon = spells.efflorescence.icon, description = spells.efflorescence.name, printInSettings = true },
			{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
			{ variable = "#incarnation", icon = spells.incarnationTreeOfLife.icon, description = spells.incarnationTreeOfLife.name, printInSettings = true },
			{ variable = "#reforestation", icon = spells.reforestation.icon, description = spells.reforestation.name, printInSettings = true },
			
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = "Moonfire", printInSettings = true },
			{ variable = "#sunfire", icon = spells.sunfire.icon, description = "Sunfire", printInSettings = true },
			
			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

			{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
			{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },

			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

			{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
			{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },			
			{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
			{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
			{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
		}
		specCache.restoration.barTextVariables.values = {
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

			{ variable = "$mana", description = "Current Mana", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Mana", printInSettings = false, color = false },
			{ variable = "$manaPercent", description = "Current Mana Percentage", printInSettings = true, color = false },
			{ variable = "$resourcePercent", description = "Current Mana Percentage", printInSettings = false, color = false },
			{ variable = "$manaMax", description = "Maximum Mana", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Mana", printInSettings = false, color = false },
			{ variable = "$casting", description = "Mana from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Mana from Passive Sources", printInSettings = true, color = false },
			{ variable = "$manaPlusCasting", description = "Current + Casting Mana Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Mana Total", printInSettings = false, color = false },
			{ variable = "$manaPlusPassive", description = "Current + Passive Mana Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Mana Total", printInSettings = false, color = false },
			{ variable = "$manaTotal", description = "Current + Passive + Casting Mana Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Mana Total", printInSettings = false, color = false },

			{ variable = "$incarnationTime", description = "Time remaining on Incarnation: Tree of Life", printInSettings = false, color = false },

			{ variable = "$reforestationStacks", description = "Current stacks of Reforestation", printInSettings = false, color = false },

			{ variable = "$sunfireCount", description = "Number of Sunfires active on targets", printInSettings = true, color = false },
			{ variable = "$sunfireTime", description = "Time remaining on Sunfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = "Number of Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Moonfire on your current target", printInSettings = true, color = false },

			{ variable = "$sohMana", description = "Mana from Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTime", description = "Time left on Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTicks", description = "Number of ticks left from Symbol of Hope", printInSettings = true, color = false },

			{ variable = "$innervateMana", description = "Passive mana regen while Innervate is active", printInSettings = true, color = false },
			{ variable = "$innervateTime", description = "Time left on Innervate", printInSettings = true, color = false },
									
			{ variable = "$mrMana", description = "Mana from Molten Radiance", printInSettings = true, color = false },
			{ variable = "$mrTime", description = "Time left on Molten Radiance", printInSettings = true, color = false },

			{ variable = "$mttMana", description = "Bonus passive mana regen while Mana Tide Totem is active", printInSettings = true, color = false },
			{ variable = "$mttTime", description = "Time left on Mana Tide Totem", printInSettings = true, color = false },

			{ variable = "$channeledMana", description = "Mana while channeling of Potion of Frozen Focus", printInSettings = true, color = false },

			{ variable = "$potionOfChilledClarityMana", description = "Passive mana regen while Potion of Chilled Clarity's effect is active", printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = "Time left on Potion of Chilled Clarity's effect", printInSettings = true, color = false },

			{ variable = "$potionOfFrozenFocusTicks", description = "Number of ticks left channeling Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Frozen Focus", printInSettings = true, color = false },
			
			{ variable = "$potionCooldown", description = "How long, in seconds, is left on your potion's cooldown in MM:SS format", printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = "How long, in seconds, is left on your potion's cooldown in seconds", printInSettings = true, color = false },

			{ variable = "$efflorescenceTime", description = "Time remaining on Efflorescence", printInSettings = true, color = false },

			{ variable = "$clearcastingTime", description = "Time remaining on your Clearcasting proc", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.restoration.spells = spells
	end

	local function GetCurrentMoonSpell()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local moon = snapshotData.snapshots[spells.newMoon.id]
		local currentTime = GetTime()
		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.newMoon) and (moon.attributes.checkAfter == nil or currentTime >= moon.attributes.checkAfter) then
			---@diagnostic disable-next-line: redundant-parameter
			moon.attributes.currentSpellId = select(7, GetSpellInfo(TRB.Data.spells.newMoon.name))

			if moon.attributes.currentSpellId == TRB.Data.spells.newMoon.id then
				moon.attributes.currentKey = "newMoon"
			elseif moon.attributes.currentSpellId == TRB.Data.spells.halfMoon.id then
				moon.attributes.currentKey = "halfMoon"
			elseif moon.attributes.currentSpellId == TRB.Data.spells.fullMoon.id then
				moon.attributes.currentKey = "fullMoon"
			else
				moon.attributes.currentKey = "newMoon"
			end
			moon.attributes.checkAfter = nil
			moon.attributes.currentIcon = TRB.Data.spells[moon.attributes.currentKey].icon
		else
			moon.attributes.currentSpellId = TRB.Data.spells.newMoon.id
			moon.attributes.currentKey = "newMoon"
			moon.attributes.checkAfter = nil
		end
		moon.cooldown:GetRemainingTime(currentTime)
	end
	
	local function CalculateAbilityEnergyValue(resource, threshold, relentlessPredator)
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local modifier = 1.0
		local specId = GetSpecialization()

		if specId == 2 then
			if snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				modifier = modifier * TRB.Data.spells.incarnationAvatarOfAshamane.energyModifier
			end
			
			if relentlessPredator and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.relentlessPredator) then
				modifier = modifier * TRB.Data.spells.relentlessPredator.energyModifier
			end
		end

		return resource * modifier
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData

		---@type TRB.Classes.TargetData
		local targetData = snapshotData.targetData
		targetData:UpdateDebuffs(currentTime)
	end

	local function TargetsCleanup(clearAll)
		---@type TRB.Classes.Snapshot
		local snapshotData = TRB.Data.snapshotDataData
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshotData.targetData
		local specId = GetSpecialization()

		if specId == 1 then
			targetData:Cleanup(clearAll)
		elseif specId == 2 then
			targetData:Cleanup(clearAll)
		elseif specId == 3 then
			targetData:Cleanup(clearAll)
		elseif specId == 4 then
			targetData:Cleanup(clearAll)
		end
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

		if specId == 1 then
			for x = 1, 4 do -- SS30, SS60, SS90, SF50
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.starsurge.settingKey, settings)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.starsurge2.settingKey, settings)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.starsurge3.settingKey, settings)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.starfall.settingKey, settings)
			TRB.Frames.resource2ContainerFrame:Hide()
		elseif specId == 2 then
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
		elseif specId == 3 then
			for k, v in pairs(spells) do
				local spell = spells[k]
				if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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
		elseif specId == 4 then
			for x = 1, 7 do
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end

			for x = 1, 5 do
				if TRB.Frames.passiveFrame.thresholds[x] == nil then
					TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
				end

				TRB.Frames.passiveFrame.thresholds[x]:Show()
				TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.passiveFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Frames.resource2ContainerFrame:Hide()
		end

		TRB.Functions.Bar:Construct(settings)

		if specId == 1 or
			specId == 2 or
			(specId == 3 and TRB.Data.settings.core.experimental.specs.druid.guardian) or
			specId == 4 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function GetBerserkRemainingTime()
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		
		if specId == 2 then
			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.incarnationAvatarOfAshamane) then
				return snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].cooldown.remaining
			else
				return snapshotData.snapshots[spells.berserk.id].cooldown.remaining
			end
		elseif specId == 3 then
			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.incarnationGuardianOfUrsoc) then
				return snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].cooldown.remaining
			else
				return snapshotData.snapshots[spells.berserk.id].cooldown.remaining
			end
		end

		return 0
	end

	local function GetEclipseRemainingTime()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local remainingTime = 0
		local icon = nil

		if snapshotData.snapshots[spells.celestialAlignment.id].buff.isActive then
			remainingTime = snapshotData.snapshots[spells.celestialAlignment.id].buff.remaining
			icon = TRB.Data.spells.celestialAlignment.icon
		elseif snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
			remainingTime = snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.remaining
			icon = TRB.Data.spells.incarnationChosenOfElune.icon
		elseif snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive then
			remainingTime = snapshotData.snapshots[spells.eclipseSolar.id].buff.remaining
			icon = TRB.Data.spells.eclipseSolar.icon
		elseif snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive then
			remainingTime = snapshotData.snapshots[spells.eclipseLunar.id].buff.remaining
			icon = TRB.Data.spells.eclipseLunar.icon
		end

		return remainingTime, icon
	end

	local function GetCurrentSnapshot(bonuses)
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local snapshotValue = 1.0

		if bonuses.tigersFury == true and snapshotData.snapshots[spells.tigersFury.id].buff.isActive then
			local tfBonus = spells.carnivorousInstinct.modifierPerStack * TRB.Data.talents.bySpellId[TRB.Data.spells.carnivorousInstinct.id].currentRank

			snapshotValue = snapshotValue * (TRB.Data.spells.tigersFury.modifier + tfBonus)
		end

		if bonuses.momentOfClarity == true and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.momentOfClarity) == true and ((snapshotData.snapshots[spells.clearcasting.id].buff.stacks ~= nil and snapshotData.snapshots[spells.clearcasting.id].buff.stacks > 0) or snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(nil, true) > 0) then
			snapshotValue = snapshotValue * TRB.Data.spells.momentOfClarity.modifier
		end

		if bonuses.bloodtalons == true and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.bloodtalons) == true and ((snapshotData.snapshots[spells.bloodtalons.id].buff.stacks ~= nil and snapshotData.snapshots[spells.bloodtalons.id].buff.stacks > 0) or snapshotData.snapshots[spells.bloodtalons.id].buff:GetRemainingTime(nil, true) > 0) then
			snapshotValue = snapshotValue * TRB.Data.spells.bloodtalons.modifier
		end

		if bonuses.stealth == true and (
			snapshotData.snapshots[spells.shadowmeld.id].buff.isActive or
			snapshotData.snapshots[spells.prowl.id].buff.isActive or
			GetBerserkRemainingTime() > 0 or
			snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(nil, true) > 0 or
			snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive) then
			snapshotValue = snapshotValue * TRB.Data.spells.prowl.modifier
		end

		return snapshotValue
	end

	local function RefreshLookupData_Balance()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local specSettings = TRB.Data.settings.druid.balance
		---@type TRB.Classes.Target
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedAstralPower = snapshotData.attributes.resource / TRB.Data.resourceFactor

		--local moonkinFormActive = snapshot.moonkinForm.isActive

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentAstralPowerColor = specSettings.colors.text.current
		local castingAstralPowerColor = specSettings.colors.text.casting

		local astralPowerThreshold = math.min(TRB.Data.character.starsurgeThreshold, TRB.Data.character.starfallThreshold)

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then 
				currentAstralPowerColor = specSettings.colors.text.overcap
				castingAstralPowerColor = specSettings.colors.text.overcap
			elseif specSettings.colors.text.overThresholdEnabled and normalizedAstralPower >= astralPowerThreshold then
				currentAstralPowerColor = specSettings.colors.text.overThreshold
				castingAstralPowerColor = specSettings.colors.text.overThreshold
			end
		end

		--$astralPower
		local astralPowerPrecision = specSettings.astralPowerPrecision or 0
		local currentAstralPower = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(normalizedAstralPower, astralPowerPrecision, "floor"))
		--$casting
		local castingAstralPower = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, astralPowerPrecision, "floor"))
		--$passive
		local _passiveAstralPower = snapshotData.snapshots[spells.furyOfElune.id].buff.resource + snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource
		if TRB.Functions.Talent:IsTalentActive(spells.naturesBalance) then
			if UnitAffectingCombat("player") then
				_passiveAstralPower = _passiveAstralPower + spells.naturesBalance.astralPower
			elseif normalizedAstralPower < 50 then
				_passiveAstralPower = _passiveAstralPower + spells.naturesBalance.outOfCombatAstralPower
			end
		end

		local passiveAstralPower = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveAstralPower, astralPowerPrecision, "ceil"))
		--$astralPowerTotal
		local _astralPowerTotal = math.min(_passiveAstralPower + snapshotData.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerTotal = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerTotal, astralPowerPrecision, "floor"))
		--$astralPowerPlusCasting
		local _astralPowerPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusCasting = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerPlusCasting, astralPowerPrecision, "floor"))
		--$astralPowerPlusPassive
		local _astralPowerPlusPassive = math.min(_passiveAstralPower + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusPassive = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerPlusPassive, astralPowerPrecision, "floor"))

		----------
		--$sunfireCount and $sunfireTime
		local _sunfireCount = snapshotData.targetData.count[spells.sunfire.id] or 0
		local sunfireCount = tostring(_sunfireCount)
		local _sunfireTime = 0
		
		if target ~= nil then
			_sunfireTime = target.spells[spells.sunfire.id].remainingTime or 0.0
		end

		local sunfireTime

		--$moonfireCount and $moonfireTime
		local _moonfireCount = snapshotData.targetData.count[spells.moonfire.id] or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		
		if target ~= nil then
			_moonfireTime = target.spells[spells.moonfire.id].remainingTime or 0.0
		end

		local moonfireTime

		--$stellarFlareCount and $stellarFlareTime
		local _stellarFlareCount = snapshotData.targetData.count[spells.stellarFlare.id] or 0
		local stellarFlareCount = tostring(_stellarFlareCount)
		local _stellarFlareTime = 0
		
		if target ~= nil then
			_stellarFlareTime = target.spells[spells.stellarFlare.id].remainingTime or 0.0
		end

		local stellarFlareTime

		if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.moonfire.id].active then
				if _moonfireTime > (TRB.Data.character.pandemicModifier * spells.moonfire.pandemicTime) then
					moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _moonfireTime)
				else
					moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _moonfireTime)
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.stellarFlare.id].active then
				if _stellarFlareTime > (TRB.Data.character.pandemicModifier * spells.stellarFlare.pandemicTime) then
					stellarFlareCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _stellarFlareTime)
				else
					stellarFlareCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _stellarFlareTime)
				end
			else
				stellarFlareCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _stellarFlareCount)
				stellarFlareTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.sunfire.id].active then
				if _sunfireTime > (TRB.Data.character.pandemicModifier * spells.sunfire.pandemicTime) then
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _sunfireTime)
				else
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _sunfireTime)
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			sunfireTime = string.format("%.1f", _sunfireTime)
			moonfireTime = string.format("%.1f", _moonfireTime)
			stellarFlareTime = string.format("%.1f", _stellarFlareTime)
		end


		--$mdTime
		local _starweaverTime = 0
		if snapshotData.snapshots[spells.starweaversWarp.id].buff.isActive then
			_starweaverTime = snapshotData.snapshots[spells.starweaversWarp.id].buff:GetRemainingTime(currentTime)
		elseif snapshotData.snapshots[spells.starweaversWarp.id].buff.isActive then
			_starweaverTime = snapshotData.snapshots[spells.starweaversWeft.id].buff:GetRemainingTime(currentTime)
		end
		local starweaverTime = string.format("%.1f", _starweaverTime)

		----------
		--$foeAstralPower
		local foeAstralPower = snapshotData.snapshots[spells.furyOfElune.id].buff.resource
		--$foeTicks
		local foeTicks = snapshotData.snapshots[spells.furyOfElune.id].buff.ticks
		--$foeTime
		local _foeTime = snapshotData.snapshots[spells.furyOfElune.id].buff:GetRemainingTime(currentTime)
		local foeTime = string.format("%.1f", _foeTime)
		
		----------
		--$foeAstralPower
		local sunderedFirmamentAstralPower = snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource
		--$foeTicks
		local sunderedFirmamentTicks = snapshotData.snapshots[spells.sunderedFirmament.id].buff.ticks
		--$foeTime
		local _sunderedFirmamentTime = snapshotData.snapshots[spells.sunderedFirmament.id].buff:GetRemainingTime(currentTime)
		local sunderedFirmamentTime = string.format("%.1f",_sunderedFirmamentTime)
		
		--New Moon
		local currentMoonIcon = spells.newMoon.icon
		--$moonAstralPower
		local moonAstralPower = 0
		--$moonCharges
		local moonCharges = snapshotData.snapshots[spells.newMoon.id].cooldown.charges
		--$moonCooldown
		local _moonCooldown = 0
		--$moonCooldownTotal
		local _moonCooldownTotal = 0
		if snapshotData.snapshots[spells.newMoon.id].attributes.currentKey ~= "" and snapshotData.snapshots[spells.newMoon.id].attributes.currentSpellId ~= nil then
			currentMoonIcon = spells[snapshotData.snapshots[spells.newMoon.id].attributes.currentKey].icon
			moonAstralPower = spells[snapshotData.snapshots[spells.newMoon.id].attributes.currentKey].astralPower

			if snapshotData.snapshots[spells.newMoon.id].cooldown.onCooldown and snapshotData.snapshots[spells.newMoon.id].cooldown.charges < snapshotData.snapshots[spells.newMoon.id].cooldown.maxCharges then
				_moonCooldown = snapshotData.snapshots[spells.newMoon.id].cooldown:GetRemainingTime(currentTime)
				_moonCooldownTotal = snapshotData.snapshots[spells.newMoon.id].cooldown.remainingTotal
			end
		end
		local moonCooldown = string.format("%.1f", _moonCooldown)
		local moonCooldownTotal = string.format("%.1f", _moonCooldownTotal)

		--$eclipseTime
		local _eclispeTime, eclipseIcon = GetEclipseRemainingTime()
		local eclipseTime = string.format("%.1f", _eclispeTime)

		--#starweaver

		local starweaverIcon = spells.starweaversWarp.icon
		if snapshotData.snapshots[spells.starweaversWeft.id].buff.isActive then
			starweaverIcon = spells.starweaversWeft.icon
		end

		--$pulsar variables
		local pulsarCollected = snapshotData.snapshots[spells.primordialArcanicPulsar.id].buff.customProperties["currentAstralPower"]
		local _pulsarCollectedPercent = pulsarCollected / spells.primordialArcanicPulsar.maxAstralPower
		local pulsarCollectedPercent = string.format("%.1f", TRB.Functions.Number:RoundTo(_pulsarCollectedPercent * 100, 1))
		local pulsarRemaining = spells.primordialArcanicPulsar.maxAstralPower - pulsarCollected
		local _pulsarRemainingPercent = pulsarRemaining / spells.primordialArcanicPulsar.maxAstralPower
		local pulsarRemainingPercent = string.format("%.1f", TRB.Functions.Number:RoundTo(_pulsarRemainingPercent * 100, 1))
		local pulsarStarsurgeCount = TRB.Functions.Number:RoundTo(pulsarRemaining / -spells.starsurge.astralPower, 0, ceil, true)
		local pulsarStarfallCount = TRB.Functions.Number:RoundTo(pulsarRemaining / -spells.starfall.astralPower, 0, ceil, true)
		
		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveAstralPower or 0
		Global_TwintopResourceBar.resource.furyOfElune = foeAstralPower or 0
		Global_TwintopResourceBar.resource.sunderedFirmament = sunderedFirmamentAstralPower or 0
		Global_TwintopResourceBar.dots = {
			sunfireCount = _sunfireCount or 0,
			moonfireCount = _moonfireCount or 0,
			stellarFlareCount = _stellarFlareCount or 0
		}
		Global_TwintopResourceBar.furyOfElune = {
			astralPower = foeAstralPower or 0,
			ticks = foeTicks or 0,
			remaining = foeTime or 0
		}
		Global_TwintopResourceBar.sunderedFirmament = {
			astralPower = sunderedFirmamentAstralPower or 0,
			ticks = sunderedFirmamentTicks or 0,
			remaining = sunderedFirmamentTime or 0
		}
		
		local lookup = TRB.Data.lookup or {}
		lookup["#wrath"] = spells.wrath.icon
		lookup["#moonkinForm"] = spells.moonkinForm.icon
		lookup["#starfire"] = spells.starfire.icon
		lookup["#sunfire"] = spells.sunfire.icon
		lookup["#moonfire"] = spells.moonfire.icon
		lookup["#starsurge"] = spells.starsurge.icon
		lookup["#starfall"] = spells.starfall.icon
		lookup["#eclipse"] = eclipseIcon or spells.celestialAlignment.icon
		lookup["#celestialAlignment"] = spells.celestialAlignment.icon
		lookup["#icoe"] = spells.incarnationChosenOfElune.icon
		lookup["#coe"] = spells.incarnationChosenOfElune.icon
		lookup["#incarnation"] = spells.incarnationChosenOfElune.icon
		lookup["#incarnationChosenOfElune"] = spells.incarnationChosenOfElune.icon
		lookup["#solar"] = spells.eclipseSolar.icon
		lookup["#eclipseSolar"] = spells.eclipseSolar.icon
		lookup["#solarEclipse"] = spells.eclipseSolar.icon
		lookup["#lunar"] = spells.eclipseLunar.icon
		lookup["#eclipseLunar"] = spells.eclipseLunar.icon
		lookup["#lunarEclipse"] = spells.eclipseLunar.icon
		lookup["#naturesBalance"] = spells.naturesBalance.icon
		lookup["#soulOfTheForest"] = spells.soulOfTheForest.icon
		lookup["#foe"] = spells.furyOfElune.icon
		lookup["#furyOfElune"] = spells.furyOfElune.icon
		lookup["#sunderedFirmament"] = spells.sunderedFirmament.icon
		lookup["#stellarFlare"] = spells.stellarFlare.icon
		lookup["#newMoon"] = spells.newMoon.icon
		lookup["#halfMoon"] = spells.halfMoon.icon
		lookup["#fullMoon"] = spells.fullMoon.icon
		lookup["#moon"] = currentMoonIcon
		lookup["#starweaver"] = starweaverIcon
		lookup["#starweaversWarp"] = spells.starweaversWarp.icon
		lookup["#starweaversWeft"] = spells.starweaversWeft.icon
		lookup["#pulsar"] = spells.primordialArcanicPulsar.icon
		lookup["#pap"] = spells.primordialArcanicPulsar.icon
		lookup["#primordialArcanicPulsar"] = spells.primordialArcanicPulsar.icon
		lookup["$pulsarCollected"] = pulsarCollected
		lookup["$pulsarCollectedPercent"] = pulsarCollectedPercent
		lookup["$pulsarRemaining"] = pulsarRemaining
		lookup["$pulsarRemainingPercent"] = pulsarRemainingPercent
		lookup["$pulsarNextStarsurge"] = ""
		lookup["$pulsarNextStarfall"] = ""
		lookup["$pulsarStarsurgeCount"] = pulsarStarsurgeCount
		lookup["$pulsarStarfallCount"] = pulsarStarfallCount
		lookup["$moonkinForm"] = ""
		lookup["$eclipseTime"] = eclipseTime
		lookup["$eclipse"] = ""
		lookup["$lunar"] = ""
		lookup["$lunarEclipse"] = ""
		lookup["$eclipseLunar"] = ""
		lookup["$solar"] = ""
		lookup["$solarEclipse"] = ""
		lookup["$eclipseSolar"] = ""
		lookup["$celestialAlignment"] = ""
		lookup["$starweaverTime"] = starweaverTime
		lookup["$starweaversWarp"] = ""
		lookup["$starweaversWeft"] = ""
		lookup["$moonAstralPower"] = moonAstralPower
		lookup["$moonCharges"] = moonCharges
		lookup["$moonCooldown"] = moonCooldown
		lookup["$moonCooldownTotal"] = moonCooldownTotal
		lookup["$sunfireCount"] = sunfireCount
		lookup["$sunfireTime"] = sunfireTime
		lookup["$moonfireCount"] = moonfireCount
		lookup["$moonfireTime"] = moonfireTime
		lookup["$stellarFlareCount"] = stellarFlareCount
		lookup["$stellarFlareTime"] = stellarFlareTime
		lookup["$astralPowerPlusCasting"] = astralPowerPlusCasting
		lookup["$astralPowerPlusPassive"] = astralPowerPlusPassive
		lookup["$astralPowerTotal"] = astralPowerTotal
		lookup["$astralPowerMax"] = TRB.Data.character.maxResource
		lookup["$astralPower"] = currentAstralPower
		lookup["$resourcePlusCasting"] = astralPowerPlusCasting
		lookup["$resourcePlusPassive"] = astralPowerPlusPassive
		lookup["$resourceTotal"] = astralPowerTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentAstralPower
		lookup["$casting"] = castingAstralPower
		lookup["$passive"] = passiveAstralPower
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$astralPowerOvercap"] = overcap
		lookup["$foeAstralPower"] = foeAstralPower
		lookup["$foeTicks"] = foeTicks
		lookup["$foeTime"] = foeTime
		lookup["$sunderedFirmamentAstralPower"] = sunderedFirmamentAstralPower
		lookup["$sunderedFirmamentTicks"] = sunderedFirmamentTicks
		lookup["$sunderedFirmamentTime"] = sunderedFirmamentTime
		lookup["$talentStellarFlare"] = ""
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$pulsarCollected"] = pulsarCollected
		lookupLogic["$pulsarCollectedPercent"] = _pulsarCollectedPercent
		lookupLogic["$pulsarRemaining"] = pulsarRemaining
		lookupLogic["$pulsarRemainingPercent"] = _pulsarRemainingPercent
		lookupLogic["$pulsarStarsurgeCount"] = pulsarStarsurgeCount
		lookupLogic["$pulsarStarfallCount"] = pulsarStarfallCount
		lookupLogic["$eclipseTime"] = _eclispeTime
		lookupLogic["$starweaverTime"] = _starweaverTime
		lookupLogic["$moonAstralPower"] = moonAstralPower
		lookupLogic["$moonCharges"] = moonCharges
		lookupLogic["$moonCooldown"] = _moonCooldown
		lookupLogic["$moonCooldownTotal"] = _moonCooldownTotal
		lookupLogic["$sunfireCount"] = _sunfireCount
		lookupLogic["$sunfireTime"] = _sunfireTime
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		lookupLogic["$stellarFlareCount"] = _stellarFlareCount
		lookupLogic["$stellarFlareTime"] = _stellarFlareTime
		lookupLogic["$astralPowerPlusCasting"] = _astralPowerPlusCasting
		lookupLogic["$astralPowerPlusPassive"] = _astralPowerPlusPassive
		lookupLogic["$astralPowerTotal"] = _astralPowerTotal
		lookupLogic["$astralPowerMax"] = TRB.Data.character.maxResource
		lookupLogic["$astralPower"] = normalizedAstralPower
		lookupLogic["$resourcePlusCasting"] = _astralPowerPlusCasting
		lookupLogic["$resourcePlusPassive"] = _astralPowerPlusPassive
		lookupLogic["$resourceTotal"] = _astralPowerTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedAstralPower
		lookupLogic["$casting"] = currentAstralPower
		lookupLogic["$passive"] = _passiveAstralPower
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$astralPowerOvercap"] = overcap
		lookupLogic["$foeAstralPower"] = foeAstralPower
		lookupLogic["$foeTicks"] = foeTicks
		lookupLogic["$foeTime"] = _foeTime
		lookupLogic["$sunderedFirmamentAstralPower"] = sunderedFirmamentAstralPower
		lookupLogic["$sunderedFirmamentTicks"] = sunderedFirmamentTicks
		lookupLogic["$sunderedFirmamentTime"] = _sunderedFirmamentTime
		TRB.Data.lookupLogic = lookupLogic
	end
	
	local function RefreshLookupData_Feral()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local specSettings = TRB.Data.settings.druid.feral
		---@type TRB.Classes.Target
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()

		--Spec specific implementation

		-- Curren snapshot values if they were applied now
		local _currentSnapshotRip = snapshotData.attributes.bleeds.rip
		local _currentSnapshotRake = snapshotData.attributes.bleeds.rake
		local _currentSnapshotThrash = snapshotData.attributes.bleeds.thrash
		local _currentSnapshotMoonfire = snapshotData.attributes.bleeds.moonfire

		-- This probably needs to be pulled every refresh
		---@diagnostic disable-next-line: cast-local-type
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
					if	spell ~= nil and spells.thresholdUsable == true then
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

		
		----------
		--$ripCount and $ripTime
		local _ripCount = snapshotData.targetData.count[spells.rip.id] or 0
		local ripCount = tostring(_ripCount)
		local _ripTime = 0
		local ripTime
		local _ripSnapshot = 0
		local ripSnapshot
		local _ripPercent = 0
		local ripPercent
		local ripCurrent

		--$rakeCount and $rakeTime
		local _rakeCount = snapshotData.targetData.count[spells.rake.id] or 0
		local rakeCount = tostring(_rakeCount)
		local _rakeTime = 0
		local rakeTime
		local _rakeSnapshot = 0
		local rakeSnapshot
		local _rakePercent = 0
		local rakePercent
		local rakeCurrent

		--$thrashCount and $thrashTime
		local _thrashCount = snapshotData.targetData.count[spells.thrash.id] or 0
		local thrashCount = tostring(_thrashCount)
		local _thrashTime = 0
		local thrashTime
		local _thrashSnapshot = 0
		local thrashSnapshot
		local _thrashPercent = 0
		local thrashPercent
		local thrashCurrent

		--$moonfireCount and $moonfireTime
		local _moonfireCount = snapshotData.targetData.count[spells.moonfire.id] or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		local moonfireTime
		local _moonfireSnapshot = 0
		local moonfireSnapshot
		local _moonfirePercent = 0
		local moonfirePercent
		local moonfireCurrent
		
		if target ~= nil then
			_moonfireTime = target.spells[spells.moonfire.id].remainingTime or 0
			_moonfireSnapshot = target.spells[spells.moonfire.id].snapshot or 0
			_moonfirePercent = (_moonfireSnapshot / _currentSnapshotMoonfire)
			_ripTime = target.spells[spells.rip.id].remainingTime or 0
			_ripSnapshot = target.spells[spells.rip.id].snapshot or 0
			_ripPercent = (_ripSnapshot / _currentSnapshotRip)
			_rakeTime = target.spells[spells.rake.id].remainingTime or 0
			_rakeSnapshot = target.spells[spells.rake.id].snapshot or 0
			_rakePercent = (_rakeSnapshot / _currentSnapshotRake)
			_thrashTime = target.spells[spells.thrash.id].remainingTime or 0
			_thrashSnapshot = target.spells[spells.thrash.id].snapshot or 0
			_thrashPercent = (_thrashSnapshot / _currentSnapshotThrash)
		end

		if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.rip.id].active then
				local ripColor = specSettings.colors.text.dots.same
				if _ripPercent > 1 then
					ripColor = specSettings.colors.text.dots.better
				elseif _ripPercent < 1 then
					ripColor = specSettings.colors.text.dots.worse
				else
					ripColor = specSettings.colors.text.dots.same
				end

				ripCount = string.format("|c%s%.0f|r", ripColor, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _ripSnapshot, 0, "floor"))
				ripCurrent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _ripPercent, 0, "floor"))
				ripTime = string.format("|c%s%.1f|r", ripColor, _ripTime)
			else
				ripCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				ripCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				ripTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.rake.id].active then
				local rakeColor = specSettings.colors.text.dots.same
				if _rakePercent > 1 then
					rakeColor = specSettings.colors.text.dots.better
				elseif _rakePercent < 1 then
					rakeColor = specSettings.colors.text.dots.worse
				else
					rakeColor = specSettings.colors.text.dots.same
				end

				rakeCount = string.format("|c%s%.0f|r", rakeColor, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _rakeSnapshot, 0, "floor"))
				rakeCurrent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _rakePercent, 0, "floor"))
				rakeTime = string.format("|c%s%.1f|r", rakeColor, _rakeTime)
			else
				rakeCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				rakeCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				rakeTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.thrash.id].active then
				local thrashColor = specSettings.colors.text.dots.same
				if _thrashPercent > 1 then
					thrashColor = specSettings.colors.text.dots.better
				elseif _thrashPercent < 1 then
					thrashColor = specSettings.colors.text.dots.worse
				else
					thrashColor = specSettings.colors.text.dots.same
				end

				thrashCount = string.format("|c%s%.0f|r", thrashColor, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _thrashSnapshot, 0, "floor"))
				thrashCurrent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _thrashPercent, 0, "floor"))
				thrashTime = string.format("|c%s%.1f|r", thrashColor, _thrashTime)
			else
				thrashCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				thrashCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				thrashTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true and target ~= nil and target.spells[spells.moonfire.id].active then
				local moonfireColor = specSettings.colors.text.dots.same
				if _moonfirePercent > 1 then
					moonfireColor = specSettings.colors.text.dots.better
				elseif _moonfirePercent < 1 then
					moonfireColor = specSettings.colors.text.dots.worse
				else
					moonfireColor = specSettings.colors.text.dots.same
				end

				moonfireCount = string.format("|c%s%.0f|r", moonfireColor, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _moonfireSnapshot, 0, "floor"))
				moonfireCurrent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _moonfirePercent, 0, "floor"))
				moonfireTime = string.format("|c%s%.1f|r", moonfireColor, _moonfireTime)
			else
				moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				moonfireCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			ripTime = string.format("%.1f", _ripTime)
			rakeTime = string.format("%.1f", _rakeTime)
			thrashTime = string.format("%.1f", _thrashTime)

			ripSnapshot = TRB.Functions.Number:RoundTo(100 * _ripSnapshot, 0, "floor", true)
			rakeSnapshot = TRB.Functions.Number:RoundTo(100 * _rakeSnapshot, 0, "floor", true)
			thrashSnapshot = TRB.Functions.Number:RoundTo(100 * _thrashSnapshot, 0, "floor", true)

			ripCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor", true)
			rakeCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor", true)
			thrashCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor", true)

			ripPercent = TRB.Functions.Number:RoundTo(100 * _ripPercent, 0, "floor", true)
			rakePercent = TRB.Functions.Number:RoundTo(100 * _rakePercent, 0, "floor", true)
			thrashPercent = TRB.Functions.Number:RoundTo(100 * _thrashPercent, 0, "floor", true)

			if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true then
				moonfireTime = string.format("%.1f", _moonfireTime)
				moonfireSnapshot = TRB.Functions.Number:RoundTo(100 * _moonfireSnapshot, 0, "floor", true)
				moonfireCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor", true)
				moonfirePercent = TRB.Functions.Number:RoundTo(100 * _moonfirePercent, 0, "floor", true)
			else
				moonfireTime = string.format("%.1f", 0)
				moonfireSnapshot = 0
				moonfireCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor", true)
				moonfirePercent = 0
			end
		end
		
		--$brutalSlashCharges
		local brutalSlashCharges = snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges
		--$brutalSlashCooldown
		local _brutalSlashCooldown = snapshotData.snapshots[spells.brutalSlash.id].cooldown:GetRemainingTime(currentTime)
		--$brutalSlashCooldownTotal
		local _brutalSlashCooldownTotal = snapshotData.snapshots[spells.brutalSlash.id].cooldown.remainingTotal

		local brutalSlashCooldown = string.format("%.1f", _brutalSlashCooldown)
		local brutalSlashCooldownTotal = string.format("%.1f", _brutalSlashCooldownTotal)
		
		--$bloodtalonsStacks
		local bloodtalonsStacks = snapshotData.snapshots[spells.bloodtalons.id].buff.stacks or 0

		--$bloodtalonsTime
		local _bloodtalonsTime = snapshotData.snapshots[spells.bloodtalons.id].buff:GetRemainingTime(currentTime)
		local bloodtalonsTime = string.format("%.1f", _bloodtalonsTime)
		
		--$tigersFuryTime
		local _tigersFuryTime = snapshotData.snapshots[spells.tigersFury.id].buff:GetRemainingTime(currentTime)
		local tigersFuryTime = string.format("%.1f", _tigersFuryTime)
		
		--$tigersFuryCooldownTime
		local _tigersFuryCooldownTime = snapshotData.snapshots[spells.tigersFury.id].cooldown:GetRemainingTime(currentTime)
		local tigersFuryCooldownTime = string.format("%.1f", _tigersFuryCooldownTime)

		--$suddenAmbushTime
		local _suddenAmbushTime = snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)
		local suddenAmbushTime = string.format("%.1f", _suddenAmbushTime)
		
		--$clearcastingStacks
		local clearcastingStacks = snapshotData.snapshots[spells.clearcasting.id].buff.stacks

		--$clearcastingTime
		local _clearcastingTime = snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		local clearcastingTime = string.format("%.1f", _clearcastingTime)

		--$berserkTime (and $incarnationTime)
		local _berserkTime = GetBerserkRemainingTime()
		local berserkTime = string.format("%.1f", _berserkTime)

		--$apexPredatorsCravingTime
		local _apexPredatorsCravingTime = snapshotData.snapshots[spells.apexPredatorsCraving.id].buff:GetRemainingTime(currentTime)
		local apexPredatorsCravingTime = string.format("%.1f", _apexPredatorsCravingTime)
		
		--$predatorRevealedTime
		local _predatorRevealedTime = snapshotData.snapshots[spells.predatorRevealed.id].buff:GetRemainingTime(currentTime)
		local predatorRevealedTime = string.format("%.1f", _predatorRevealedTime)

		--$predatorRevealedTicks 
		local _predatorRevealedTicks = snapshotData.snapshots[spells.predatorRevealed.id].attributes.ticks
		
		--$predatorRevealedTickTime
		local _predatorRevealedTickTime = snapshotData.snapshots[spells.predatorRevealed.id].attributes.untilNextTick
		local predatorRevealedTickTime = string.format("%.1f", _predatorRevealedTickTime)

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy or 0
		Global_TwintopResourceBar.dots = {
			ripCount = _ripCount or 0,
			rakeCount = _rakeCount or 0,
			thrashCount = _thrashCount or 0,
			moonfireCount = _moonfireCount or 0,
			ripPercent = _ripPercent or 0,
			rakePercent = _rakePercent or 0,
			thrashPercent = _thrashPercent or 0,
			moonfirePercent = _moonfirePercent or 0,
			ripSnapshot = _ripSnapshot or 0,
			rakeSnapshot = _rakeSnapshot or 0,
			thrashSnapshot = _thrashSnapshot or 0,
			moonfireSnapshot = _moonfireSnapshot or 0,
			ripCurrent = _currentSnapshotRip or 1,
			rakeCurrent = _currentSnapshotRake or 1,
			thrashCurrent = _currentSnapshotThrash or 1,
			moonfireCurrent = _currentSnapshotMoonfire or 0,
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#berserk"] = spells.berserk.icon
		lookup["#bloodtalons"] = spells.bloodtalons.icon
		lookup["#brutalSlash"] = spells.brutalSlash.icon
		lookup["#carnivorousInstinct"] = spells.carnivorousInstinct.icon
		lookup["#catForm"] = spells.catForm.icon
		lookup["#clearcasting"] = spells.clearcasting.icon
		lookup["#feralFrenzy"] = spells.feralFrenzy.icon
		lookup["#ferociousBite"] = spells.ferociousBite.icon
		lookup["#incarnation"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#incarnationAvatarOfAshamane"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#lunarInspiration"] = spells.lunarInspiration.icon
		lookup["#maim"] = spells.maim.icon
		lookup["#moonfire"] = spells.moonfire.icon
		lookup["#predatorRevealed"] = spells.predatorRevealed.icon
		lookup["#predatorySwiftness"] = spells.predatorySwiftness.icon
		lookup["#primalWrath"] = spells.primalWrath.icon
		lookup["#prowl"] = spells.prowl.icon
		lookup["#stealth"] = spells.prowl.icon
		lookup["#rake"] = spells.rake.icon
		lookup["#rip"] = spells.rip.icon
		lookup["#shadowmeld"] = spells.shadowmeld.icon
		lookup["#shred"] = spells.shred.icon
		lookup["#suddenAmbush"] = spells.suddenAmbush.icon
		lookup["#swipe"] = spells.swipe.icon
		lookup["#thrash"] = spells.thrash.icon
		lookup["#tigersFury"] = spells.tigersFury.icon
		lookup["$ripCount"] = ripCount
		lookup["$ripTime"] = ripTime
		lookup["$ripSnapshot"] = ripSnapshot
		lookup["$ripCurrent"] = ripCurrent
		lookup["$ripPercent"] = ripPercent
		lookup["$rakeCount"] = rakeCount
		lookup["$rakeTime"] = rakeTime
		lookup["$rakeSnapshot"] = rakeSnapshot
		lookup["$rakeCurrent"] = rakeCurrent
		lookup["$rakePercent"] = rakePercent
		lookup["$thrashCount"] = thrashCount
		lookup["$thrashTime"] = thrashTime
		lookup["$thrashSnapshot"] = thrashSnapshot
		lookup["$thrashCurrent"] = thrashCurrent
		lookup["$thrashPercent"] = thrashPercent
		lookup["$moonfireCount"] = moonfireCount
		lookup["$moonfireTime"] = moonfireTime
		lookup["$moonfireSnapshot"] = moonfireSnapshot
		lookup["$moonfireCurrent"] = moonfireCurrent
		lookup["$moonfirePercent"] = moonfirePercent
		lookup["$lunarInspiration"] = ""

		lookup["$brutalSlashCharges"] = brutalSlashCharges
		lookup["$brutalSlashCooldown"] = brutalSlashCooldown
		lookup["$brutalSlashCooldownTotal"] = brutalSlashCooldownTotal
		lookup["$bloodtalonsStacks"] = bloodtalonsStacks
		lookup["$bloodtalonsTime"] = bloodtalonsTime
		lookup["$suddenAmbushTime"] = suddenAmbushTime
		lookup["$clearcastingStacks"] = clearcastingStacks
		lookup["$clearcastingTime"] = clearcastingTime
		lookup["$berserkTime"] = berserkTime
		lookup["$incarnationTime"] = berserkTime
		lookup["$apexPredatorsCravingTime"] = apexPredatorsCravingTime
		lookup["$tigersFuryTime"] = tigersFuryTime
		lookup["$tigersFuryCooldownTime"] = tigersFuryCooldownTime

		lookup["$predatorRevealedTime"] = predatorRevealedTime
		lookup["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookup["$predatorRevealedTickTime"] = predatorRevealedTickTime

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
		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$inStealth"] = ""
		TRB.Data.lookup = lookup
		

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$ripCount"] = _ripCount
		lookupLogic["$ripTime"] = _ripTime
		lookupLogic["$ripSnapshot"] = _ripSnapshot
		lookupLogic["$ripCurrent"] = _currentSnapshotRip
		lookupLogic["$ripPercent"] = _ripPercent
		lookupLogic["$rakeCount"] = _rakeCount
		lookupLogic["$rakeTime"] = _rakeTime
		lookupLogic["$rakeSnapshot"] = _rakeSnapshot
		lookupLogic["$rakeCurrent"] = _currentSnapshotRake
		lookupLogic["$rakePercent"] = _rakePercent
		lookupLogic["$thrashCount"] = _thrashCount
		lookupLogic["$thrashTime"] = _thrashTime
		lookupLogic["$thrashSnapshot"] = _thrashSnapshot
		lookupLogic["$thrashCurrent"] = _currentSnapshotThrash
		lookupLogic["$thrashPercent"] = _thrashPercent
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		lookupLogic["$moonfireSnapshot"] = _moonfireSnapshot
		lookupLogic["$moonfireCurrent"] = _currentSnapshotMoonfire
		lookupLogic["$moonfirePercent"] = _moonfirePercent
		lookupLogic["$brutalSlashCharges"] = brutalSlashCharges
		lookupLogic["$brutalSlashCooldown"] = _brutalSlashCooldown
		lookupLogic["$brutalSlashCooldownTotal"] = _brutalSlashCooldownTotal
		lookupLogic["$bloodtalonsStacks"] = bloodtalonsStacks
		lookupLogic["$bloodtalonsTime"] = _bloodtalonsTime
		lookupLogic["$suddenAmbushTime"] = _suddenAmbushTime
		lookupLogic["$clearcastingStacks"] = clearcastingStacks
		lookupLogic["$clearcastingTime"] = _clearcastingTime
		lookupLogic["$berserkTime"] = _berserkTime
		lookupLogic["$incarnationTime"] = _berserkTime
		lookupLogic["$apexPredatorsCravingTime"] = _apexPredatorsCravingTime
		lookupLogic["$tigersFuryTime"] = _tigersFuryTime
		lookupLogic["$tigersFuryCooldownTime"] = _tigersFuryCooldownTime
		lookupLogic["$predatorRevealedTime"] = _predatorRevealedTime
		lookupLogic["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookupLogic["$predatorRevealedTickTime"] = _predatorRevealedTickTime
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
		lookupLogic["$regen"] = _regenEnergy
		lookupLogic["$regenEnergy"] = _regenEnergy
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$inStealth"] = ""
		TRB.Data.lookupLogic = lookupLogic
	end
	
	local function RefreshLookupData_Guardian()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local specSettings = TRB.Data.settings.druid.guardian
		---@type TRB.Classes.Target
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()

		--Spec specific implementation

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentRageColor = specSettings.colors.text.current
		local castingRageColor = specSettings.colors.text.casting
		
		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then
				currentRageColor = specSettings.colors.text.overcap
				castingRageColor = specSettings.colors.text.overcap
			elseif specSettings.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(spells) do
					local spell = spells[k]
					if	spell ~= nil and spells.thresholdUsable == true then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentRageColor = specSettings.colors.text.overThreshold
					castingRageColor = specSettings.colors.text.overThreshold
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingRageColor = specSettings.colors.text.spending
		end

		--$rage
		local currentRage = string.format("|c%s%.0f|r", currentRageColor, snapshotData.attributes.resource)
		--$casting
		local castingRage = string.format("|c%s%.0f|r", castingRageColor, snapshotData.casting.resourceFinal)

		local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

		--$rageTotal
		local _rageTotal = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local rageTotal = string.format("|c%s%.0f|r", currentRageColor, _rageTotal)
		--$ragePlusCasting
		local _ragePlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local ragePlusCasting = string.format("|c%s%.0f|r", castingRageColor, _ragePlusCasting)
		--$ragePlusPassive
		local _ragePlusPassive = math.min(snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local ragePlusPassive = string.format("|c%s%.0f|r", currentRageColor, _ragePlusPassive)

		--[[
		----------
		--$ripCount and $ripTime
		local _ripCount = snapshotData.targetData.count[spells.rip.id] or 0
		local ripCount = tostring(_ripCount)
		local _ripTime = 0
		local ripTime
		local _ripSnapshot = 0
		local ripSnapshot
		local _ripPercent = 0
		local ripPercent
		local ripCurrent

		--$rakeCount and $rakeTime
		local _rakeCount = snapshotData.targetData.count[spells.rake.id] or 0
		local rakeCount = tostring(_rakeCount)
		local _rakeTime = 0
		local rakeTime
		local _rakeSnapshot = 0
		local rakeSnapshot
		local _rakePercent = 0
		local rakePercent
		local rakeCurrent

		--$thrashCount and $thrashTime
		local _thrashCount = snapshotData.targetData.count[spells.thrash.id] or 0
		local thrashCount = tostring(_thrashCount)
		local _thrashTime = 0
		local thrashTime
		local _thrashSnapshot = 0
		local thrashSnapshot
		local _thrashPercent = 0
		local thrashPercent
		local thrashCurrent

		--$moonfireCount and $moonfireTime
		local _moonfireCount = snapshotData.targetData.count[spells.moonfire.id] or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		local moonfireTime
		local _moonfireSnapshot = 0
		local moonfireSnapshot
		local _moonfirePercent = 0
		local moonfirePercent
		local moonfireCurrent
		
		if target ~= nil then
			_moonfireTime = target.spells[spells.moonfire.id].remainingTime or 0
			_moonfireSnapshot = target.spells[spells.moonfire.id].snapshot or 0
			_moonfirePercent = (_moonfireSnapshot / _currentSnapshotMoonfire)
			_ripTime = target.spells[spells.rip.id].remainingTime or 0
			_ripSnapshot = target.spells[spells.rip.id].snapshot or 0
			_ripPercent = (_ripSnapshot / _currentSnapshotRip)
			_rakeTime = target.spells[spells.rake.id].remainingTime or 0
			_rakeSnapshot = target.spells[spells.rake.id].snapshot or 0
			_rakePercent = (_rakeSnapshot / _currentSnapshotRake)
			_thrashTime = target.spells[spells.thrash.id].remainingTime or 0
			_thrashSnapshot = target.spells[spells.thrash.id].snapshot or 0
			_thrashPercent = (_thrashSnapshot / _currentSnapshotThrash)
		end

		if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.rip.id].active then
				local ripColor = specSettings.colors.text.dots.same
				if _ripPercent > 1 then
					ripColor = specSettings.colors.text.dots.better
				elseif _ripPercent < 1 then
					ripColor = specSettings.colors.text.dots.worse
				else
					ripColor = specSettings.colors.text.dots.same
				end

				ripCount = string.format("|c%s%.0f|r", ripColor, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _ripSnapshot, 0, "floor"))
				ripCurrent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _ripPercent, 0, "floor"))
				ripTime = string.format("|c%s%.1f|r", ripColor, _ripTime)
			else
				ripCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				ripCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				ripTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.rake.id].active then
				local rakeColor = specSettings.colors.text.dots.same
				if _rakePercent > 1 then
					rakeColor = specSettings.colors.text.dots.better
				elseif _rakePercent < 1 then
					rakeColor = specSettings.colors.text.dots.worse
				else
					rakeColor = specSettings.colors.text.dots.same
				end

				rakeCount = string.format("|c%s%.0f|r", rakeColor, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _rakeSnapshot, 0, "floor"))
				rakeCurrent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _rakePercent, 0, "floor"))
				rakeTime = string.format("|c%s%.1f|r", rakeColor, _rakeTime)
			else
				rakeCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				rakeCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				rakeTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.thrash.id].active then
				local thrashColor = specSettings.colors.text.dots.same
				if _thrashPercent > 1 then
					thrashColor = specSettings.colors.text.dots.better
				elseif _thrashPercent < 1 then
					thrashColor = specSettings.colors.text.dots.worse
				else
					thrashColor = specSettings.colors.text.dots.same
				end

				thrashCount = string.format("|c%s%.0f|r", thrashColor, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _thrashSnapshot, 0, "floor"))
				thrashCurrent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _thrashPercent, 0, "floor"))
				thrashTime = string.format("|c%s%.1f|r", thrashColor, _thrashTime)
			else
				thrashCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				thrashCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				thrashTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true and target ~= nil and target.spells[spells.moonfire.id].active then
				local moonfireColor = specSettings.colors.text.dots.same
				if _moonfirePercent > 1 then
					moonfireColor = specSettings.colors.text.dots.better
				elseif _moonfirePercent < 1 then
					moonfireColor = specSettings.colors.text.dots.worse
				else
					moonfireColor = specSettings.colors.text.dots.same
				end

				moonfireCount = string.format("|c%s%.0f|r", moonfireColor, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _moonfireSnapshot, 0, "floor"))
				moonfireCurrent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _moonfirePercent, 0, "floor"))
				moonfireTime = string.format("|c%s%.1f|r", moonfireColor, _moonfireTime)
			else
				moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				moonfireCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			ripTime = string.format("%.1f", _ripTime)
			rakeTime = string.format("%.1f", _rakeTime)
			thrashTime = string.format("%.1f", _thrashTime)

			ripSnapshot = TRB.Functions.Number:RoundTo(100 * _ripSnapshot, 0, "floor", true)
			rakeSnapshot = TRB.Functions.Number:RoundTo(100 * _rakeSnapshot, 0, "floor", true)
			thrashSnapshot = TRB.Functions.Number:RoundTo(100 * _thrashSnapshot, 0, "floor", true)

			ripCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor", true)
			rakeCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor", true)
			thrashCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor", true)

			ripPercent = TRB.Functions.Number:RoundTo(100 * _ripPercent, 0, "floor", true)
			rakePercent = TRB.Functions.Number:RoundTo(100 * _rakePercent, 0, "floor", true)
			thrashPercent = TRB.Functions.Number:RoundTo(100 * _thrashPercent, 0, "floor", true)

			if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true then
				moonfireTime = string.format("%.1f", _moonfireTime)
				moonfireSnapshot = TRB.Functions.Number:RoundTo(100 * _moonfireSnapshot, 0, "floor", true)
				moonfireCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor", true)
				moonfirePercent = TRB.Functions.Number:RoundTo(100 * _moonfirePercent, 0, "floor", true)
			else
				moonfireTime = string.format("%.1f", 0)
				moonfireSnapshot = 0
				moonfireCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor", true)
				moonfirePercent = 0
			end
		end
		]]

		--[[
		--$brutalSlashCharges
		local brutalSlashCharges = snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges
		--$brutalSlashCooldown
		local _brutalSlashCooldown = snapshotData.snapshots[spells.brutalSlash.id].cooldown:GetRemainingTime(currentTime)
		--$brutalSlashCooldownTotal
		local _brutalSlashCooldownTotal = snapshotData.snapshots[spells.brutalSlash.id].cooldown.remainingTotal

		local brutalSlashCooldown = string.format("%.1f", _brutalSlashCooldown)
		local brutalSlashCooldownTotal = string.format("%.1f", _brutalSlashCooldownTotal)
		
		--$bloodtalonsStacks
		local bloodtalonsStacks = snapshotData.snapshots[spells.bloodtalons.id].buff.stacks or 0

		--$bloodtalonsTime
		local _bloodtalonsTime = snapshotData.snapshots[spells.bloodtalons.id].buff:GetRemainingTime(currentTime)
		local bloodtalonsTime = string.format("%.1f", _bloodtalonsTime)
		
		--$tigersFuryTime
		local _tigersFuryTime = snapshotData.snapshots[spells.tigersFury.id].buff:GetRemainingTime(currentTime)
		local tigersFuryTime = string.format("%.1f", _tigersFuryTime)
		
		--$tigersFuryCooldownTime
		local _tigersFuryCooldownTime = snapshotData.snapshots[spells.tigersFury.id].cooldown:GetRemainingTime(currentTime)
		local tigersFuryCooldownTime = string.format("%.1f", _tigersFuryCooldownTime)

		--$suddenAmbushTime
		local _suddenAmbushTime = snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)
		local suddenAmbushTime = string.format("%.1f", _suddenAmbushTime)
		
		--$clearcastingStacks
		local clearcastingStacks = snapshotData.snapshots[spells.clearcasting.id].buff.stacks

		--$clearcastingTime
		local _clearcastingTime = snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		local clearcastingTime = string.format("%.1f", _clearcastingTime)

		--$berserkTime (and $incarnationTime)
		local _berserkTime = GetBerserkRemainingTime()
		local berserkTime = string.format("%.1f", _berserkTime)

		--$apexPredatorsCravingTime
		local _apexPredatorsCravingTime = snapshotData.snapshots[spells.apexPredatorsCraving.id].buff:GetRemainingTime(currentTime)
		local apexPredatorsCravingTime = string.format("%.1f", _apexPredatorsCravingTime)
		
		--$predatorRevealedTime
		local _predatorRevealedTime = snapshotData.snapshots[spells.predatorRevealed.id].buff:GetRemainingTime(currentTime)
		local predatorRevealedTime = string.format("%.1f", _predatorRevealedTime)

		--$predatorRevealedTicks 
		local _predatorRevealedTicks = snapshotData.snapshots[spells.predatorRevealed.id].attributes.ticks
		
		--$predatorRevealedTickTime
		local _predatorRevealedTickTime = snapshotData.snapshots[spells.predatorRevealed.id].attributes.untilNextTick
		local predatorRevealedTickTime = string.format("%.1f", _predatorRevealedTickTime)
		]]
		----------------------------

		--[[Global_TwintopResourceBar.resource.passive = _passiveRage or 0
		Global_TwintopResourceBar.dots = {
			ripCount = _ripCount or 0,
			rakeCount = _rakeCount or 0,
			thrashCount = _thrashCount or 0,
			moonfireCount = _moonfireCount or 0,
			ripPercent = _ripPercent or 0,
			rakePercent = _rakePercent or 0,
			thrashPercent = _thrashPercent or 0,
			moonfirePercent = _moonfirePercent or 0,
			ripSnapshot = _ripSnapshot or 0,
			rakeSnapshot = _rakeSnapshot or 0,
			thrashSnapshot = _thrashSnapshot or 0,
			moonfireSnapshot = _moonfireSnapshot or 0,
			ripCurrent = _currentSnapshotRip or 1,
			rakeCurrent = _currentSnapshotRake or 1,
			thrashCurrent = _currentSnapshotThrash or 1,
			moonfireCurrent = _currentSnapshotMoonfire or 0,
		}]]

		local lookup = TRB.Data.lookup or {}
		--[[lookup["#berserk"] = spells.berserk.icon
		lookup["#bloodtalons"] = spells.bloodtalons.icon
		lookup["#brutalSlash"] = spells.brutalSlash.icon
		lookup["#carnivorousInstinct"] = spells.carnivorousInstinct.icon
		lookup["#catForm"] = spells.catForm.icon
		lookup["#clearcasting"] = spells.clearcasting.icon
		lookup["#guardianFrenzy"] = spells.guardianFrenzy.icon
		lookup["#ferociousBite"] = spells.ferociousBite.icon
		lookup["#incarnation"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#incarnationAvatarOfAshamane"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#lunarInspiration"] = spells.lunarInspiration.icon
		lookup["#maim"] = spells.maim.icon
		lookup["#moonfire"] = spells.moonfire.icon
		lookup["#predatorRevealed"] = spells.predatorRevealed.icon
		lookup["#predatorySwiftness"] = spells.predatorySwiftness.icon
		lookup["#primalWrath"] = spells.primalWrath.icon
		lookup["#prowl"] = spells.prowl.icon
		lookup["#stealth"] = spells.prowl.icon
		lookup["#rake"] = spells.rake.icon
		lookup["#rip"] = spells.rip.icon
		lookup["#shadowmeld"] = spells.shadowmeld.icon
		lookup["#shred"] = spells.shred.icon
		lookup["#suddenAmbush"] = spells.suddenAmbush.icon
		lookup["#swipe"] = spells.swipe.icon
		lookup["#thrash"] = spells.thrash.icon
		lookup["#tigersFury"] = spells.tigersFury.icon
		lookup["$ripCount"] = ripCount
		lookup["$ripTime"] = ripTime
		lookup["$ripSnapshot"] = ripSnapshot
		lookup["$ripCurrent"] = ripCurrent
		lookup["$ripPercent"] = ripPercent
		lookup["$rakeCount"] = rakeCount
		lookup["$rakeTime"] = rakeTime
		lookup["$rakeSnapshot"] = rakeSnapshot
		lookup["$rakeCurrent"] = rakeCurrent
		lookup["$rakePercent"] = rakePercent
		lookup["$thrashCount"] = thrashCount
		lookup["$thrashTime"] = thrashTime
		lookup["$thrashSnapshot"] = thrashSnapshot
		lookup["$thrashCurrent"] = thrashCurrent
		lookup["$thrashPercent"] = thrashPercent
		lookup["$moonfireCount"] = moonfireCount
		lookup["$moonfireTime"] = moonfireTime
		lookup["$moonfireSnapshot"] = moonfireSnapshot
		lookup["$moonfireCurrent"] = moonfireCurrent
		lookup["$moonfirePercent"] = moonfirePercent
		lookup["$lunarInspiration"] = ""

		lookup["$brutalSlashCharges"] = brutalSlashCharges
		lookup["$brutalSlashCooldown"] = brutalSlashCooldown
		lookup["$brutalSlashCooldownTotal"] = brutalSlashCooldownTotal
		lookup["$bloodtalonsStacks"] = bloodtalonsStacks
		lookup["$bloodtalonsTime"] = bloodtalonsTime
		lookup["$suddenAmbushTime"] = suddenAmbushTime
		lookup["$clearcastingStacks"] = clearcastingStacks
		lookup["$clearcastingTime"] = clearcastingTime
		lookup["$berserkTime"] = berserkTime
		lookup["$incarnationTime"] = berserkTime
		lookup["$apexPredatorsCravingTime"] = apexPredatorsCravingTime
		lookup["$tigersFuryTime"] = tigersFuryTime
		lookup["$tigersFuryCooldownTime"] = tigersFuryCooldownTime

		lookup["$predatorRevealedTime"] = predatorRevealedTime
		lookup["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookup["$predatorRevealedTickTime"] = predatorRevealedTickTime]]

		lookup["$ragePlusCasting"] = ragePlusCasting
		lookup["$rageTotal"] = rageTotal
		lookup["$rageMax"] = TRB.Data.character.maxResource
		lookup["$rage"] = currentRage
		lookup["$resourcePlusCasting"] = ragePlusCasting
		--lookup["$resourcePlusPassive"] = ragePlusPassive
		lookup["$resourceTotal"] = rageTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentRage
		lookup["$casting"] = castingRage
		--[[lookup["$regen"] = regenRage
		lookup["$regenRage"] = regenRage
		lookup["$rageRegen"] = regenRage]]
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$rageOvercap"] = overcap
		--[[lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$inStealth"] = ""]]
		TRB.Data.lookup = lookup
		

		local lookupLogic = TRB.Data.lookupLogic or {}
		--[[lookupLogic["$ripCount"] = _ripCount
		lookupLogic["$ripTime"] = _ripTime
		lookupLogic["$ripSnapshot"] = _ripSnapshot
		lookupLogic["$ripCurrent"] = _currentSnapshotRip
		lookupLogic["$ripPercent"] = _ripPercent
		lookupLogic["$rakeCount"] = _rakeCount
		lookupLogic["$rakeTime"] = _rakeTime
		lookupLogic["$rakeSnapshot"] = _rakeSnapshot
		lookupLogic["$rakeCurrent"] = _currentSnapshotRake
		lookupLogic["$rakePercent"] = _rakePercent
		lookupLogic["$thrashCount"] = _thrashCount
		lookupLogic["$thrashTime"] = _thrashTime
		lookupLogic["$thrashSnapshot"] = _thrashSnapshot
		lookupLogic["$thrashCurrent"] = _currentSnapshotThrash
		lookupLogic["$thrashPercent"] = _thrashPercent
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		lookupLogic["$moonfireSnapshot"] = _moonfireSnapshot
		lookupLogic["$moonfireCurrent"] = _currentSnapshotMoonfire
		lookupLogic["$moonfirePercent"] = _moonfirePercent
		lookupLogic["$brutalSlashCharges"] = brutalSlashCharges
		lookupLogic["$brutalSlashCooldown"] = _brutalSlashCooldown
		lookupLogic["$brutalSlashCooldownTotal"] = _brutalSlashCooldownTotal
		lookupLogic["$bloodtalonsStacks"] = bloodtalonsStacks
		lookupLogic["$bloodtalonsTime"] = _bloodtalonsTime
		lookupLogic["$suddenAmbushTime"] = _suddenAmbushTime
		lookupLogic["$clearcastingStacks"] = clearcastingStacks
		lookupLogic["$clearcastingTime"] = _clearcastingTime
		lookupLogic["$berserkTime"] = _berserkTime
		lookupLogic["$incarnationTime"] = _berserkTime
		lookupLogic["$apexPredatorsCravingTime"] = _apexPredatorsCravingTime
		lookupLogic["$tigersFuryTime"] = _tigersFuryTime
		lookupLogic["$tigersFuryCooldownTime"] = _tigersFuryCooldownTime
		lookupLogic["$predatorRevealedTime"] = _predatorRevealedTime
		lookupLogic["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookupLogic["$predatorRevealedTickTime"] = _predatorRevealedTickTime]]
		lookupLogic["$ragePlusCasting"] = _ragePlusCasting
		lookupLogic["$rageTotal"] = _rageTotal
		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$rage"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
		--lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
		lookupLogic["$resourceTotal"] = _rageTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		--[[lookupLogic["$regen"] = _regenRage
		lookupLogic["$regenRage"] = _regenRage
		lookupLogic["$rageRegen"] = _regenRage]]
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$rageOvercap"] = overcap
		--[[lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$inStealth"] = ""]]
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Restoration()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local snapshots = snapshotData.snapshots
		local specSettings = TRB.Data.settings.druid.restoration
		---@type TRB.Classes.Target
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		snapshotData.attributes.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.druid.restoration.colors.text.current
		local castingManaColor = TRB.Data.settings.druid.restoration.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.druid.restoration.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = snapshotData.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
		--$sohMana
		local _sohMana = symbolOfHope.buff.mana
		local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
		--$sohTicks
		local _sohTicks = symbolOfHope.buff.ticks
		local sohTicks = string.format("%.0f", _sohTicks)
		--$sohTime
		local _sohTime = symbolOfHope.buff:GetRemainingTime(currentTime)
		local sohTime = string.format("%.1f", _sohTime)

		local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
		--$innervateMana
		local _innervateMana = innervate.mana
		local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
		--$innervateTime
		local _innervateTime = innervate.buff:GetRemainingTime(currentTime)
		local innervateTime = string.format("%.1f", _innervateTime)

		local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		--$potionOfChilledClarityMana
		local _potionOfChilledClarityMana = potionOfChilledClarity.mana
		local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
		--$potionOfChilledClarityTime
		local _potionOfChilledClarityTime = potionOfChilledClarity.buff:GetRemainingTime(currentTime)
		local potionOfChilledClarityTime = string.format("%.1f", _potionOfChilledClarityTime)
		
		local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
		--$mttMana
		local _mttMana = manaTideTotem.mana
		local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
		--$mttTime
		local _mttTime = manaTideTotem.buff:GetRemainingTime(currentTime)
		local mttTime = string.format("%.1f", _mttTime)
		
		local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
		--$mrMana
		local _mrMana = moltenRadiance.mana
		local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
		--$mrTime
		local _mrTime = moltenRadiance.buff.remaining
		local mrTime = string.format("%.1f", _mrTime)

		--$potionCooldownSeconds
		local _potionCooldown = snapshots[spells.aeratedManaPotionRank1.id].cooldown.remaining
		local potionCooldownSeconds = string.format("%.1f", _potionCooldown)
		local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
		local _potionCooldownSeconds = _potionCooldown % 60
		--$potionCooldown
		local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
		
		local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
		--$channeledMana
		local _channeledMana = channeledManaPotion.mana
		local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
		--$potionOfFrozenFocusTicks
		local _potionOfFrozenFocusTicks = channeledManaPotion.ticks or 0
		local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
		--$potionOfFrozenFocusTime
		local _potionOfFrozenFocusTime = channeledManaPotion.buff:GetRemainingTime(currentTime)
		local potionOfFrozenFocusTime = string.format("%.1f", _potionOfFrozenFocusTime)

		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.druid.restoration.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
		--$manaTotal
		local _manaTotal = math.min(_passiveMana + snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
		--$manaPlusCasting
		local _manaPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor", true))
		--$manaPlusPassive
		local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor", true))

		--$manaMax
		local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

		--$manaPercent
		local maxResource = TRB.Data.character.maxResource

		if maxResource == 0 then
			maxResource = 1
		end
		local _manaPercent = (normalizedMana/maxResource)
		local manaPercent = string.format("|c%s%s|r", currentManaColor, TRB.Functions.Number:RoundTo(_manaPercent*100, manaPrecision, "floor"))

		--$efflorescenceTime
		local _efflorescenceTime = snapshots[spells.efflorescence.id].buff:GetRemainingTime(currentTime) --TODO: This isn't actually how this works, double check/fix it
		local efflorescenceTime = string.format("%.1f", _efflorescenceTime)
	
		--$clearcastingTime
		local _clearcastingTime = snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		local clearcastingTime = string.format("%.1f", _clearcastingTime)

		--$incarnationTime
		local _incarnationTime = snapshots[spells.incarnationTreeOfLife.id].buff:GetRemainingTime(currentTime)
		local incarnationTime = string.format("%.1f", _incarnationTime)

		--$reforestationStacks
		local reforestationStacks = snapshots[spells.reforestation.id].buff.stacks

		----------
		--$sunfireCount and $sunfireTime
		local _sunfireCount = snapshotData.targetData.count[spells.sunfire.id] or 0
		local sunfireCount = tostring(_sunfireCount)
		local _sunfireTime = 0
		
		if target ~= nil then
			_sunfireTime = target.spells[spells.sunfire.id].remainingTime or 0
		end

		local sunfireTime

		--$moonfireCount and $moonfireTime
		local _moonfireCount = snapshotData.targetData.count[spells.moonfire.id] or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		
		if target ~= nil then
			_moonfireTime = target.spells[spells.moonfire.id].remainingTime or 0
		end

		local moonfireTime

		if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.moonfire.id].active then
				if _moonfireTime > spells.moonfire.pandemicTime then
					moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _moonfireTime)
				else
					moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _moonfireTime)
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.sunfire.id].active then
				if _sunfireTime > spells.sunfire.pandemicTime then
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _sunfireTime)
				else
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _sunfireTime)
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			sunfireTime = string.format("%.1f", _sunfireTime)
			moonfireTime = string.format("%.1f", _moonfireTime)
		end


		----------

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _channeledMana,
			ticks = _potionOfFrozenFocusTicks or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = _sohTicks or 0
		}
		Global_TwintopResourceBar.dots = {
			sunfireCount = _sunfireCount or 0,
			moonfireCount = _moonfireCount or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#efflorescence"] = spells.efflorescence.icon
		lookup["#incarnation"] = spells.incarnationTreeOfLife.icon
		lookup["#clearcasting"] = spells.clearcasting.icon
		lookup["#sunfire"] = spells.sunfire.icon
		lookup["#moonfire"] = spells.moonfire.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#reforestation"] = spells.reforestation.icon
		lookup["$manaPlusCasting"] = manaPlusCasting
		lookup["$manaPlusPassive"] = manaPlusPassive
		lookup["$manaTotal"] = manaTotal
		lookup["$manaMax"] = manaMax
		lookup["$mana"] = currentMana
		lookup["$resourcePlusCasting"] = manaPlusCasting
		lookup["$resourcePlusPassive"] = manaPlusPassive
		lookup["$resourceTotal"] = manaTotal
		lookup["$resourceMax"] = manaMax
		lookup["$manaPercent"] = manaPercent
		lookup["$resourcePercent"] = manaPercent
		lookup["$resource"] = currentMana
		lookup["$casting"] = castingMana
		lookup["$passive"] = passiveMana
		lookup["$efflorescenceTime"] = efflorescenceTime
		lookup["$clearcastingTime"] = clearcastingTime
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$sunfireCount"] = sunfireCount
		lookup["$sunfireTime"] = sunfireTime
		lookup["$moonfireCount"] = moonfireCount
		lookup["$moonfireTime"] = moonfireTime
		lookup["$incarnationTime"] = incarnationTime
		lookup["$reforestationStacks"] = reforestationStacks
		lookup["$mrMana"] = mrMana
		lookup["$mrTime"] = mrTime
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
		lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
		lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$manaPlusCasting"] = _manaPlusCasting
		lookupLogic["$manaPlusPassive"] = _manaPlusPassive
		lookupLogic["$manaTotal"] = _manaTotal
		lookupLogic["$manaMax"] = maxResource
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
		lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
		lookupLogic["$resourceTotal"] = _manaTotal
		lookupLogic["$resourceMax"] = maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$casting"] = _castingMana
		lookupLogic["$passive"] = _passiveMana
		lookupLogic["$sohMana"] = _sohMana
		lookupLogic["$sohTime"] = _sohTime
		lookupLogic["$sohTicks"] = _sohTicks
		lookupLogic["$innervateMana"] = _innervateMana
		lookupLogic["$innervateTime"] = _innervateTime
		lookupLogic["$mrMana"] = _mrMana
		lookupLogic["$mrTime"] = _mrTime
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
		lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$efflorescenceTime"] = _efflorescenceTime
		lookupLogic["$clearcastingTime"] = _clearcastingTime
		lookupLogic["$sunfireCount"] = _sunfireCount
		lookupLogic["$sunfireTime"] = _sunfireTime
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		lookupLogic["$incarnationTime"] = _incarnationTime
		lookupLogic["$reforestationStacks"] = reforestationStacks
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting_Balance(spell)
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local currentTime = GetTime()
		snapshotData.casting.startTime = currentTime
		snapshotData.casting.resourceRaw = spell.astralPower
		snapshotData.casting.resourceFinal = spell.astralPower
		snapshotData.casting.spellId = spell.id
		snapshotData.casting.icon = spell.icon
	end

	local function UpdateCastingResourceFinal_Restoration()
		-- Do nothing for now
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
		local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		-- Do nothing for now
		snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
	end

	local function CastingSpell()
		local spells = TRB.Data.spells		
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local specId = GetSpecialization()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See druid implementation for handling channeled spells
				else
					if currentSpellId == spells.wrath.id then
						FillSnapshotDataCasting_Balance(spells.wrath)
						if TRB.Functions.Talent:IsTalentActive(spells.wildSurges) then
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.wildSurges.modifier
						end
						if TRB.Functions.Talent:IsTalentActive(spells.soulOfTheForest) and spells.eclipseSolar.isActive then
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * (1 + spells.soulOfTheForest.modifier.wrath)
						end
					elseif currentSpellId == spells.starfire.id then
						FillSnapshotDataCasting_Balance(spells.starfire)
						if TRB.Functions.Talent:IsTalentActive(spells.wildSurges) then
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.wildSurges.modifier
						end
						--TODO: Track how many targets were hit by the last Starfire to guess how much bonus AP you'll get?
						--snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * (1 + spells.soulOfTheForest.modifier.wrath)
						--Warrior of Elune logic would go here if it didn't make it instant cast!
					elseif currentSpellId == spells.sunfire.id then
						FillSnapshotDataCasting_Balance(spells.sunfire)
					elseif currentSpellId == spells.moonfire.id then
						FillSnapshotDataCasting_Balance(spells.moonfire)
					elseif currentSpellId == spells.stellarFlare.id then
						FillSnapshotDataCasting_Balance(spells.stellarFlare)
					elseif currentSpellId == spells.newMoon.id then
						FillSnapshotDataCasting_Balance(spells.newMoon)
					elseif currentSpellId == spells.halfMoon.id then
						FillSnapshotDataCasting_Balance(spells.halfMoon)
					elseif currentSpellId == spells.fullMoon.id then
						FillSnapshotDataCasting_Balance(spells.fullMoon)
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 2 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			elseif specId == 3 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			elseif specId == 4 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

						snapshotData.casting.startTime = currentSpellStartTime / 1000
						snapshotData.casting.endTime = currentSpellEndTime / 1000
						snapshotData.casting.resourceRaw = manaCost
						snapshotData.casting.spellId = spellId
						snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Restoration()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	---Calculates the incoming combo points for a given effect
	---@param spell any
	---@param buffSnapshot TRB.Classes.Snapshot
	---@param cpSnapshot TRB.Classes.Snapshot
	local function CalculateIncomingComboPointsForEffect(spell, buffSnapshot, cpSnapshot)
		local currentTime = GetTime()
		local remainingTime = buffSnapshot.buff.remaining

		if remainingTime > 0 then
			local untilNextTick = spell.tickRate - (currentTime - (cpSnapshot.attributes.lastTick or currentTime))
			local totalCps = TRB.Functions.Number:RoundTo(remainingTime / spell.tickRate, 0, "ceil", true) or 0

			if buffSnapshot.buff.endTime < currentTime then
				totalCps = 1
				untilNextTick = 0
			elseif untilNextTick < 0 then
				totalCps = totalCps + 1
				untilNextTick = 0
			end

			cpSnapshot.attributes.ticks = totalCps
			cpSnapshot.attributes.nextTick = currentTime + untilNextTick
			cpSnapshot.attributes.untilNextTick = untilNextTick
		elseif cpSnapshot.attributes.lastTick ~= nil and buffSnapshot.buff.endTime ~= nil then
			if (currentTime - buffSnapshot.buff.endTime) < 0.2 then
				cpSnapshot.attributes.lastTick = nil
				cpSnapshot.attributes.ticks = 0
				cpSnapshot.attributes.nextTick = nil
				cpSnapshot.attributes.untilNextTick = 0
			end
		else
			buffSnapshot.buff:Reset()
			cpSnapshot.attributes.lastTick = nil
			cpSnapshot.attributes.ticks = 0
			cpSnapshot.attributes.nextTick = nil
			cpSnapshot.attributes.untilNextTick = 0
		end
	end

	local function UpdatePredatorRevealed()
		local spells = TRB.Data.spells
		local predatorRevealed = TRB.Data.snapshotData.snapshots[spells.predatorRevealed.id] --[[@as TRB.Classes.Snapshot]]
		CalculateIncomingComboPointsForEffect(spells.predatorRevealed, predatorRevealed, predatorRevealed)
	end

	local function UpdateBerserkIncomingComboPoints()
		local spells = TRB.Data.spells
		local berserk = TRB.Data.snapshotData.snapshots[spells.berserk.id] --[[@as TRB.Classes.Snapshot]]
		local incarnationAvatarOfAshamane = TRB.Data.snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id] --[[@as TRB.Classes.Snapshot]]
		if incarnationAvatarOfAshamane.buff.isActive then
			CalculateIncomingComboPointsForEffect(spells.berserk, incarnationAvatarOfAshamane, berserk)
		else
			CalculateIncomingComboPointsForEffect(spells.berserk, berserk, berserk)
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
	end

	local function UpdateSnapshot_Balance()
		UpdateSnapshot()
		GetCurrentMoonSpell()

		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local currentTime = GetTime()

		local rattleTheStarsModifier = snapshotData.snapshots[spells.rattleTheStars.id].buff.stacks * spells.rattleTheStars.modifier
		local incarnationChosenOfEluneStarfallModifier = 0
		local incarnationChosenOfEluneStarsurgeModifier = 0

		if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and TRB.Functions.Talent:IsTalentActive(spells.elunesGuidance) then
			incarnationChosenOfEluneStarfallModifier = spells.elunesGuidance.modifierStarfall
			incarnationChosenOfEluneStarsurgeModifier = spells.elunesGuidance.modifierStarsurge
		end

		TRB.Data.character.starsurgeThreshold = (-spells.starsurge.astralPower + incarnationChosenOfEluneStarsurgeModifier) * (1+rattleTheStarsModifier)
		TRB.Data.character.starfallThreshold = (-spells.starfall.astralPower + incarnationChosenOfEluneStarfallModifier) * (1+rattleTheStarsModifier)

		snapshotData.snapshots[spells.moonkinForm.id].buff:Refresh()
		snapshotData.snapshots[spells.furyOfElune.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.sunderedFirmament.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.celestialAlignment.id].buff:Refresh()
		snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff:Refresh()
		snapshotData.snapshots[spells.eclipseSolar.id].buff:Refresh()
		snapshotData.snapshots[spells.eclipseLunar.id].buff:Refresh()
		snapshotData.snapshots[spells.starfall.id].buff:GetRemainingTime(currentTime)

		if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) then
			snapshotData.snapshots[spells.primordialArcanicPulsar.id].buff:Refresh()
		end
	end

	local function UpdateSnapshot_Feral()
		UpdateSnapshot()
		UpdateBerserkIncomingComboPoints()
		UpdatePredatorRevealed()
		
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local currentTime = GetTime()

		snapshotData.attributes.bleeds.moonfire = GetCurrentSnapshot(spells.moonfire.bonuses)
		snapshotData.attributes.bleeds.rake = GetCurrentSnapshot(spells.rake.bonuses)
		snapshotData.attributes.bleeds.rip = GetCurrentSnapshot(spells.rip.bonuses)
		snapshotData.attributes.bleeds.thrash = GetCurrentSnapshot(spells.thrash.bonuses)

		snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)
		
		-- Incarnation: King of the Jungle doesn't show up in-game as a combat log event. Check for it manually instead.
		if TRB.Functions.Talent:IsTalentActive(spells.incarnationAvatarOfAshamane) then
			snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff:Refresh()
		else
			snapshotData.snapshots[spells.berserk.id].buff:Refresh()
		end

		snapshotData.snapshots[spells.tigersFury.id].buff:Refresh()
		snapshotData.snapshots[spells.tigersFury.id].cooldown:Refresh(true)

		snapshotData.snapshots[spells.feralFrenzy.id].cooldown:Refresh()
		snapshotData.snapshots[spells.maim.id].cooldown:Refresh()
		
		if TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
			snapshotData.snapshots[spells.brutalSlash.id].cooldown:Refresh()
		end
		
		if TRB.Functions.Talent:IsTalentActive(spells.bloodtalons) then
			snapshotData.snapshots[spells.bloodtalons.id].cooldown:Refresh()
		end
	end

	local function UpdateSnapshot_Guardian()
		UpdateSnapshot()
		
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local currentTime = GetTime()


		--[[snapshotData.snapshots[spells.maim.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.feralFrenzy.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)]]
		
		if TRB.Functions.Talent:IsTalentActive(spells.incarnationGuardianOfUrsoc) then
			snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].cooldown:Refresh(true)
			snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff:Refresh()
		else
			snapshotData.snapshots[spells.berserk.id].buff:Refresh()
		end

		snapshotData.snapshots[spells.ironfur.id].buff:Refresh()
		snapshotData.snapshots[spells.ironfur.id].cooldown:Refresh(true)
		
		if TRB.Functions.Talent:IsTalentActive(spells.afterTheWildfire) then
			snapshotData.snapshots[spells.afterTheWildfire.id].cooldown:Refresh()
		end
		
		if TRB.Functions.Talent:IsTalentActive(spells.frenziedRegeneration) then
			snapshotData.snapshots[spells.frenziedRegeneration.id].cooldown:Refresh()
		end
	end

	local function UpdateSnapshot_Restoration()
		UpdateSnapshot()

		local spells = TRB.Data.spells
		local _

		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots

		local currentTime = GetTime()
		
		local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
		innervate:Update()

		local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
		manaTideTotem:Update()

		local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
		symbolOfHope:Update()

		local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
		moltenRadiance:Update()
		
		local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		potionOfChilledClarity:Update()

		local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
		channeledManaPotion:Update()

		-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
		snapshots[spells.aeratedManaPotionRank1.id].cooldown.startTime, snapshots[spells.aeratedManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
		snapshots[spells.aeratedManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)

		snapshots[spells.conjuredChillglobe.id].cooldown.startTime, snapshots[spells.conjuredChillglobe.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
		snapshots[spells.conjuredChillglobe.id].cooldown:GetRemainingTime(currentTime)

		snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.incarnationTreeOfLife.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.reforestation.id].buff:GetRemainingTime(currentTime)
	end

	local function UpdateResourceBar()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.druid
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData

		if specId == 1 then
			local specSettings = classSettings.balance
			UpdateSnapshot_Balance()

			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local affectingCombat = UnitAffectingCombat("player")
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local flashBar = false

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

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentResource)

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentResource + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)

					if specSettings.bar.showPassive then
						passiveBarValue = currentResource + snapshotData.casting.resourceFinal + snapshotData.snapshots[spells.furyOfElune.id].buff.resource + snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource

						if TRB.Functions.Talent:IsTalentActive(spells.naturesBalance) then
							if affectingCombat then
								passiveBarValue = passiveBarValue + spells.naturesBalance.astralPower
							elseif currentResource < 50 then
								passiveBarValue = passiveBarValue + spells.naturesBalance.outOfCombatAstralPower
							end
						end

						if TRB.Functions.Talent:IsTalentActive(spells.naturesBalance) and (affectingCombat or (not affectingCombat and currentResource < 50)) then

						else
							passiveBarValue = currentResource + snapshotData.casting.resourceFinal + snapshotData.snapshots[spells.furyOfElune.id].buff.resource + snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource
						end
					else
						passiveBarValue = castingBarValue
					end

					TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
						if spell ~= nil and spell.id ~= nil and spell.astralPower ~= nil and spell.astralPower < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							pairOffset = (spell.thresholdId - 1) * 3
							local resourceAmount = spell.astralPower * (1 + (snapshotData.snapshots[spells.rattleTheStars.id].buff.stacks * spells.rattleTheStars.modifier))
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.settingKey == spells.starsurge.settingKey then
									local redrawThreshold = false

									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and TRB.Functions.Talent:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - spells.elunesGuidance.modifierStarsurge
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
									end

									if redrawThreshold then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end
									
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif snapshotData.snapshots[spells.starweaversWeft.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.over
									elseif currentResource >= TRB.Data.character.starsurgeThreshold then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
									
									if showThreshold then
										if snapshotData.snapshots[spells.starweaversWeft.id].buff.isActive and specSettings.audio.starweaversReady.enabled and snapshotData.audio.playedstarweaverCue == false then
											snapshotData.audio.playedstarweaverCue = true
											snapshotData.audio.playedSfCue = true
											PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
										elseif specSettings.audio.ssReady.enabled and snapshotData.audio.playedSsCue == false then
											snapshotData.audio.playedSsCue = true
											PlaySoundFile(specSettings.audio.ssReady.sound, coreSettings.audio.channel.channel)
										end
									else
										snapshotData.audio.playedSsCue = false
										snapshotData.audio.playedstarweaverCue = false
									end
								elseif spell.settingKey == spells.starsurge2.settingKey then
									local redrawThreshold = false
									local touchTheCosmosMod = 0
									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and TRB.Functions.Talent:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - (spells.elunesGuidance.modifierStarsurge * 2)
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
										touchTheCosmosMod = spells.touchTheCosmos.astralPowerMod
									end

									if redrawThreshold then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif -resourceAmount >= TRB.Data.character.maxResource then
										showThreshold = false
									elseif specSettings.thresholds.starsurgeThresholdOnlyOverShow and
										   -(TRB.Data.character.starsurgeThreshold - touchTheCosmosMod) > currentResource then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.settingKey == spells.starsurge3.settingKey then
									local redrawThreshold = false
									local touchTheCosmosMod = 0
									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and TRB.Functions.Talent:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - (spells.elunesGuidance.modifierStarsurge * 3)
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
										touchTheCosmosMod = spells.touchTheCosmos.astralPowerMod
									end

									if redrawThreshold then	
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif -resourceAmount >= TRB.Data.character.maxResource then
										showThreshold = false
									elseif specSettings.thresholds.starsurgeThresholdOnlyOverShow and
										   -((TRB.Data.character.starsurgeThreshold * 2) - touchTheCosmosMod) > currentResource then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.starfall.id then
									local redrawThreshold = false
									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and TRB.Functions.Talent:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - spells.elunesGuidance.modifierStarfall
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
									end

									if redrawThreshold then										
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif currentResource >= TRB.Data.character.starfallThreshold then
										if snapshotData.snapshots[spells.starfall.id].buff.isActive and (snapshotData.snapshots[spells.starfall.id].buff.remaining) > (TRB.Data.character.pandemicModifier * spells.starfall.pandemicTime) then
											thresholdColor = specSettings.colors.threshold.starfallPandemic
										else
											thresholdColor = specSettings.colors.threshold.over
										end
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									if showThreshold then
										if snapshotData.snapshots[spells.starweaversWarp.id].buff.isActive and specSettings.audio.starweaversReady.enabled and snapshotData.audio.playedstarweaverCue == false then
											snapshotData.audio.playedstarweaverCue = true
											snapshotData.audio.playedSfCue = true
											PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
										elseif specSettings.audio.sfReady.enabled and snapshotData.audio.playedSfCue == false then
											snapshotData.audio.playedSfCue = true
											PlaySoundFile(specSettings.audio.sfReady.sound, coreSettings.audio.channel.channel)
										end
									end
								end
							--The rest isn't used. Keeping it here for consistency until I can finish abstracting this whole mess out
							elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
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

							local snapshotCooldown = nil
							if snapshotData.snapshots[spell.id] ~= nil then
								snapshotCooldown = snapshotData.snapshots[spell.id].cooldown
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshotCooldown, specSettings)
						end
					end
					
					if specSettings.colors.bar.flashSsEnabled and currentResource >= TRB.Data.character.starsurgeThreshold then
						flashBar = true
					end

					local barColor = specSettings.colors.bar.base

					if not snapshotData.snapshots[spells.moonkinForm.id].buff.isActive and affectingCombat then
						barColor = specSettings.colors.bar.moonkinFormMissing
						if specSettings.colors.bar.flashEnabled then
							flashBar = true
						end
					elseif snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive or snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive or snapshotData.snapshots[spells.celestialAlignment.id].buff.isActive or snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
						local timeThreshold = 0
						local useEndOfEclipseColor = false

						if specSettings.endOfEclipse.enabled and (not specSettings.endOfEclipse.celestialAlignmentOnly or snapshotData.snapshots[spells.celestialAlignment.id].buff.isActive or snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive) then
							useEndOfEclipseColor = true
							if specSettings.endOfEclipse.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfEclipse.gcdsMax
							elseif specSettings.endOfEclipse.mode == "time" then
								timeThreshold = specSettings.endOfEclipse.timeMax
							end
						end

						if useEndOfEclipseColor and GetEclipseRemainingTime() <= timeThreshold then
							barColor = specSettings.colors.bar.eclipse1GCD
						else
							if snapshotData.snapshots[spells.celestialAlignment.id].buff.isActive or snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive or (snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive and snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive) then
								barColor = specSettings.colors.bar.celestial
							elseif snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive then
								barColor = specSettings.colors.bar.solar
							else
								barColor = specSettings.colors.bar.lunar
							end
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
					barContainerFrame:SetAlpha(1.0)

					if flashBar then
						TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					end
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.feral
			UpdateSnapshot_Feral()

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
							local energyAmount = CalculateAbilityEnergyValue(spell.energy, true, spell.relentlessPredator)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							local overrideOk = true

							if spell.hasSnapshot and specSettings.thresholds.bleedColors then
								showThreshold = true
								overrideOk = false

								if UnitIsDeadOrGhost("target") or not UnitCanAttack("player", "target") or snapshotData.targetData.currentTargetGuid == nil then
									thresholdColor = specSettings.colors.text.dots.same
									frameLevel = TRB.Data.constants.frameLevels.thresholdBleedSame
								elseif snapshotData.targetData.targets == nil or snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid] == nil then
									thresholdColor = specSettings.colors.text.dots.down
									frameLevel = TRB.Data.constants.frameLevels.thresholdBleedDownOrWorse
								else
									local snapshotValue = (snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid].spells[spell.id].snapshot or 1) / TRB.Data.snapshotData.attributes.bleeds[spell.settingKey]
									local bleedUp = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid].spells[spell.id].active
									
									if not bleedUp then
										thresholdColor = specSettings.colors.text.dots.down
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedDownOrWorse
									elseif snapshotValue > 1 then
										thresholdColor = specSettings.colors.text.dots.better
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedBetter
									elseif snapshotValue < 1 then
										thresholdColor = specSettings.colors.text.dots.worse
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedDownOrWorse
									else
										thresholdColor = specSettings.colors.text.dots.same
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedSame
									end
								end

								if spell.id == spells.moonfire.id and not TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) then
									showThreshold = false
								end
							elseif spell.isClearcasting and snapshotData.snapshots[spells.clearcasting.id].buff.stacks ~= nil and snapshotData.snapshots[spells.clearcasting.id].buff.stacks > 0 then
								if spell.id == spells.brutalSlash.id then
									if not TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges > 0 then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									end
								elseif spell.id == spells.swipe.id then
									if TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									else
										thresholdColor = specSettings.colors.threshold.over
									end
								else
									thresholdColor = specSettings.colors.threshold.over
								end
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.ferociousBite.id and spell.settingKey == "ferociousBite" then
									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, math.min(math.max(-energyAmount, snapshotData.attributes.resource), -CalculateAbilityEnergyValue(spells.ferociousBite.energyMax, true, true)), TRB.Data.character.maxResource)
									
									if snapshotData.attributes.resource >= -energyAmount or snapshotData.snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.ferociousBiteMinimum.id and spell.settingKey == "ferociousBiteMinimum" then
									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)
									
									if snapshotData.attributes.resource >= -energyAmount or snapshotData.snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.ferociousBiteMaximum.id and spell.settingKey == "ferociousBiteMaximum" then
									if snapshotData.attributes.resource >= -energyAmount or snapshotData.snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.moonfire.id then
									if not TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) then
										showThreshold = false
									elseif snapshotData.attributes.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.swipe.id then
									if TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif snapshotData.attributes.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.brutalSlash.id then
									if not TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges == 0 then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif snapshotData.attributes.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.bloodtalons.id then
									--TODO: How much energy is required to start this? Then do we move it?
								end
							elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
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

							if overrideOk == true and spell.comboPoints == true and snapshotData.attributes.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshotData.snapshots[spell.id], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base
					
					if snapshotData.snapshots[spells.clearcasting.id].buff.remaining > 0 then
						barColor = specSettings.colors.bar.clearcasting
					end

					if snapshotData.attributes.resource2 == 5 and snapshotData.attributes.resource >= -CalculateAbilityEnergyValue(spells.ferociousBiteMaximum.energy, true, true) then
						barColor = specSettings.colors.bar.maxBite
					end

					if snapshotData.snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
						barColor = specSettings.colors.bar.apexPredator
					end

					local barBorderColor = specSettings.colors.bar.border
					if IsStealthed() then
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

					local berserkTotalCps = snapshotData.snapshots[spells.berserk.id].attributes.ticks
					local berserkNextTick = spells.berserk.tickRate - snapshotData.snapshots[spells.berserk.id].attributes.untilNextTick

					local prTime = snapshotData.snapshots[spells.predatorRevealed.id].buff.remaining
					local prTotalCps = snapshotData.snapshots[spells.predatorRevealed.id].attributes.ticks
					local prNextTick = spells.predatorRevealed.tickRate - snapshotData.snapshots[spells.predatorRevealed.id].attributes.untilNextTick

					local prTickShown = 0
					local berserkTickShown = 0

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
							if specSettings.comboPoints.generation and berserkTickShown == 0 and berserkTotalCps > 0 and (snapshotData.snapshots[spells.berserk.id].attributes.untilNextTick <= snapshotData.snapshots[spells.predatorRevealed.id].attributes.untilNextTick or prTickShown > 0 or prTotalCps == 0) then
								TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, berserkNextTick * 1000, spells.berserk.tickRate * 1000)
								berserkTickShown = 1

								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							elseif specSettings.comboPoints.generation and prTime ~= nil and prTime > 0 and x <= (snapshotData.attributes.resource2 + prTotalCps) then
								if x == snapshotData.attributes.resource2 + berserkTickShown + 1 then
									TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, prNextTick * 1000, spells.predatorRevealed.tickRate * 1000)
								else
									TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
								end

								prTickShown = prTickShown + 1

								if specSettings.comboPoints.spec.predatorRevealedColor and x > snapshotData.attributes.resource2 and x <= (snapshotData.attributes.resource2 + prTotalCps) then
									cpBorderColor = specSettings.colors.comboPoints.predatorRevealed
	
									if specSettings.comboPoints.sameColor ~= true then
										cpColor = specSettings.colors.comboPoints.predatorRevealed
									end
	
									if not specSettings.comboPoints.consistentUnfilledColor then
										cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.predatorRevealed, true)
									end
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							else
								TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
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
			local specSettings = classSettings.guardian
			UpdateSnapshot_Guardian()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0				
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
				if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.borderOvercap, true))
			
					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						---@diagnostic disable-next-line: redundant-parameter
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.border, true))
					snapshotData.audio.overcapCue = false
				end
			
				local passiveValue = 0
				--[[if specSettings.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshot.rageRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshot.rageRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
			
					passiveValue = passiveValue + snapshot.termsOfEngagement.rage
				end]]
			
				--[[if CastingSpell() and specSettings.bar.showCasting then
					castingBarValue = snapshot.resource + snapshot.casting.resourceFinal
				else
					castingBarValue = snapshot.resource
				end]]
			
				castingBarValue = currentResource
			
				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					passiveBarValue = castingBarValue + passiveValue
					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end
			
				local pairOffset = 0
				for k, v in pairs(spells) do
					local spell = spells[k]
					if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
						local rageAmount = spell.rage -- CalculateRageResourceValue(spell.rage, true)
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -rageAmount, TRB.Data.character.maxResource)
			
						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
						
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							--[[if spell.id == spells.maul.id then
								local targetUnitHealth
								if target ~= nil then
									targetUnitHealth = target:GetHealthPercent()
								end
								
								if UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= spells.killShot.healthMinimum then
									showThreshold = false
									snapshot.audio.playedKillShotCue = false
								elseif snapshot.killShot.startTime ~= nil and currentTime < (snapshot.killShot.startTime + snapshot.killShot.duration) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									snapshot.audio.playedKillShotCue = false
								elseif snapshot.resource >= -rageAmount then
									if specSettings.audio.killShot.enabled and not snapshot.audio.playedKillShotCue then
										snapshot.audio.playedKillShotCue = true
										---@diagnostic disable-next-line: redundant-parameter
										PlaySoundFile(specSettings.audio.killShot.sound, coreSettings.audio.channel.channel)
									end
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									snapshot.audio.playedKillShotCue = false
								end
							elseif spell.id == spells.carve.id then
								if snapshot.carve.startTime ~= nil and currentTime < (snapshot.carve.startTime + snapshot.carve.duration) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif snapshot.resource >= -rageAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							elseif spell.id == spells.raptorStrike.id then
								if TRB.Functions.Talent:IsTalentActive(spells.mongooseBite) then
									showThreshold = false
								else
									if snapshot.resource >= -rageAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.mongooseBite.id then
								if not TRB.Functions.Talent:IsTalentActive(spells.mongooseBite) then
									showThreshold = false
								else
									if snapshot.resource >= -rageAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end]]
						elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.hasCooldown then
							if (snapshotData.snapshots[spell.id].cooldown.charges == nil or snapshotData.snapshots[spell.id].cooldown.charges == 0) and	snapshotData.snapshots[spell.id].cooldown.remaining then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif currentResource >= -rageAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else -- This is an active/available/normal spell threshold
							if currentResource >= -rageAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end

						local snapshotCooldown = nil
						if snapshotData.snapshots[spell.id] ~= nil then
							snapshotCooldown = snapshotData.snapshots[spell.id].cooldown
						end

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshotCooldown, specSettings)
					end
					pairOffset = pairOffset + 3
				end
			
				local barColor = specSettings.colors.bar.base
				if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						---@diagnostic disable-next-line: redundant-parameter
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end
			
				--[[if snapshot.coordinatedAssault.isActive then
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
			
					if useEndOfCoordinatedAssaultColor and GetCoordinatedAssaultRemainingTime() <= timeThreshold then
						barColor = specSettings.colors.bar.coordinatedAssaultEnding
					else
						barColor = specSettings.colors.bar.coordinatedAssault
					end
				end]]
				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
			end
		elseif specId == 4 then
			local specSettings = classSettings.restoration
			UpdateSnapshot_Restoration()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()
		
				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					local manaTideTotem = snapshotData.snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
					local symbolOfHope = snapshotData.snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
					local moltenRadiance = snapshotData.snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
					local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					local channeledManaPotion = snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
		
					if potionOfChilledClarity.buff.isActive then
						if specSettings.colors.bar.potionOfChilledClarityBorderChange then
							barBorderColor = specSettings.colors.bar.potionOfChilledClarity
						end
					elseif innervate.buff.isActive then
						if specSettings.colors.bar.innervateBorderChange then
							barBorderColor = specSettings.colors.bar.innervate
						end
		
						if specSettings.audio.innervate.enabled and snapshotData.audio.innervateCue == false then
							snapshotData.audio.innervateCue = true
							PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
						end
					end
		
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))
		
					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentMana)
		
					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = currentMana + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentMana
					end
		
					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
		
					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, snapshotData.snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshotData.snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)
		
					local passiveValue = 0
					if specSettings.bar.showPassive then
						if channeledManaPotion.buff.isActive then
							passiveValue = passiveValue + channeledManaPotion.mana
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[1]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[1]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end

						if innervate.mana > 0 or potionOfChilledClarity.mana > 0 then
							passiveValue = passiveValue + math.max(innervate.mana, potionOfChilledClarity.mana)
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[2], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[2]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[2]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[2]:Hide()
						end
		
						if symbolOfHope.buff.mana > 0 then
							passiveValue = passiveValue + symbolOfHope.buff.mana
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[3], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[3]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[3]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[3]:Hide()
						end
		
						if manaTideTotem.mana > 0 then
							passiveValue = passiveValue + manaTideTotem.mana
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[4]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[4]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[4]:Hide()
						end

						if moltenRadiance.mana > 0 then
							passiveValue = passiveValue + moltenRadiance.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[5], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[5].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[5]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[5]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[5]:Hide()
						end
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						TRB.Frames.passiveFrame.thresholds[2]:Hide()
						TRB.Frames.passiveFrame.thresholds[3]:Hide()
						TRB.Frames.passiveFrame.thresholds[4]:Hide()
						TRB.Frames.passiveFrame.thresholds[5]:Hide()
					end
		
					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < snapshotData.attributes.resource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, snapshotData.attributes.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, snapshotData.attributes.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, snapshotData.attributes.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
					
					local resourceBarColor = specSettings.colors.bar.base

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat and TRB.Functions.Talent:IsTalentActive(spells.efflorescence) and not snapshotData.snapshots[spells.efflorescence.id].buff.isActive then
						resourceBarColor = specSettings.colors.bar.noEfflorescence
					elseif snapshotData.snapshots[spells.clearcasting.id].buff.isActive then
						resourceBarColor = specSettings.colors.bar.clearcasting
					elseif snapshotData.snapshots[spells.incarnationTreeOfLife.id].buff.isActive and (TRB.Functions.Talent:IsTalentActive(spells.cenariusGuidance) or snapshotData.snapshots[spells.clearcasting.id].buff.isActive) then
						local timeThreshold = 0
						local useEndOfIncarnationColor = false

						if specSettings.endOfIncarnation.enabled then
							useEndOfIncarnationColor = true
							if specSettings.endOfIncarnation.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfIncarnation.gcdsMax
							elseif specSettings.endOfIncarnation.mode == "time" then
								timeThreshold = specSettings.endOfIncarnation.timeMax
							end
						end

						if useEndOfIncarnationColor and snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.remaining <= timeThreshold then
							resourceBarColor = specSettings.colors.bar.incarnationEnd
						else
							resourceBarColor = specSettings.colors.bar.incarnation
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				end
		
				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		end
	end

	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local targetData = snapshotData.targetData --[[@as TRB.Classes.TargetData]]

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			local settings
			if specId == 1 then
				settings = TRB.Data.settings.druid.balance
			elseif specId == 2 then
				settings = TRB.Data.settings.druid.feral
			elseif specId == 3 then
				settings = TRB.Data.settings.druid.guardian
			elseif specId == 4 then
				settings = TRB.Data.settings.druid.restoration
			end

			if destGUID == TRB.Data.character.guid then
				if specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
					if settings.passiveGeneration.symbolOfHope and (spellId == spells.symbolOfHope.tickId or spellId == spells.symbolOfHope.id) then
						local symbolOfHope = snapshotData.snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
						local castByToken = UnitTokenFromGUID(sourceGUID)
						symbolOfHope.buff:Initialize(type, nil, castByToken)
					elseif settings.passiveGeneration.innervate and spellId == spells.innervate.id then
						local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
						innervate.buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshotData.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshotData.audio.innervateCue = false
						end
					elseif settings.passiveGeneration.manaTideTotem and spellId == spells.manaTideTotem.id then
						local manaTideTotem = snapshotData.snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
						manaTideTotem:Initialize(type)
					elseif spellId == spells.moltenRadiance.id then
						local moltenRadiance = snapshotData.snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
						moltenRadiance.buff:Initialize(type)
					end
				end
			end

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "balance" then
					if spellId == spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.stellarFlare.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.sunfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.furyOfElune.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Fury of Elune
							snapshotData.snapshots[spellId].buff:InitializeCustom(spells.furyOfElune.duration)
							snapshotData.snapshots[spellId].buff:UpdateTicks(currentTime)
							print(snapshotData.snapshots[spellId].buff.ticks, snapshotData.snapshots[spellId].buff.resource)
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							snapshotData.snapshots[spellId].buff:UpdateTicks(currentTime)
						end
					elseif spellId == spells.sunderedFirmament.buffId then
						snapshotData.snapshots[spells.sunderedFirmament.id].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" then -- Gain Fury of Elune
							snapshotData.snapshots[spells.sunderedFirmament.id].buff:UpdateTicks(currentTime)
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							snapshotData.snapshots[spells.sunderedFirmament.id].buff:UpdateTicks(currentTime)
						end
					elseif spellId == spells.eclipseSolar.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.eclipseLunar.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.celestialAlignment.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.incarnationChosenOfElune.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.starfall.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.starweaversWarp.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.starweaversWeft.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.rattleTheStars.buffId then
						snapshotData.snapshots[spells.rattleTheStars.id].buff:Initialize(type)
						TRB.Functions.Class:CheckCharacter()
						triggerUpdate = true
					elseif spellId == spells.newMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[spellId].attributes.currentSpellId = spells.halfMoon.id
							snapshotData.snapshots[spellId].attributes.currentKey = "halfMoon"
							snapshotData.snapshots[spellId].attributes.checkAfter = currentTime + 20
						end
					elseif spellId == spells.halfMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[spellId].attributes.currentSpellId = spells.fullMoon.id
							snapshotData.snapshots[spellId].attributes.currentKey = "fullMoon"
							snapshotData.snapshots[spellId].attributes.checkAfter = currentTime + 20
						end
					elseif spellId == spells.fullMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							-- New Moon doesn't like to behave when we do this
							snapshotData.snapshots[spellId].attributes.currentSpellId = spells.newMoon.id
							snapshotData.snapshots[spellId].attributes.currentKey = "newMoon"
							snapshotData.snapshots[spellId].attributes.checkAfter = currentTime + 20
							spells.newMoon.currentIcon = select(3, GetSpellInfo(202767)) -- Use the old Legion artifact spell ID since New Moon's icon returns incorrect for several seconds after casting Full Moon
						end
					elseif spellId == spells.touchTheCosmos.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "feral" then
					if spellId == spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = GetCurrentSnapshot(spells.moonfire.bonuses)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif spellId == spells.rake.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = GetCurrentSnapshot(spells.rake.bonuses)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif spellId == spells.rip.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = GetCurrentSnapshot(spells.rip.bonuses)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif spellId == spells.thrash.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = GetCurrentSnapshot(spells.thrash.bonuses)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[destGUID].spells[spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif spellId == spells.shadowmeld.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.prowl.id or spellId == spells.prowl.idIncarnation then
						snapshotData.snapshots[spells.prowl.id].buff:Initialize(type)
					elseif spellId == spells.suddenAmbush.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_REMOVED" then
							snapshotData.snapshots[spellId].attributes.endTimeLeeway = currentTime + 0.1
						end
					elseif spellId == spells.berserk.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_REMOVED" then
							if type == "SPELL_AURA_APPLIED" then
								snapshotData.snapshots[spells.berserk.id].attributes.lastTick = currentTime
							end
							UpdateBerserkIncomingComboPoints()
						end
					elseif spellId == spells.incarnationAvatarOfAshamane.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_REMOVED" then
							if type == "SPELL_AURA_APPLIED" then
								snapshotData.snapshots[spells.berserk.id].attributes.lastTick = currentTime
							end
							UpdateBerserkIncomingComboPoints()
						end
					elseif spellId == spells.berserk.energizeId then
						if type == "SPELL_ENERGIZE" then
							snapshotData.snapshots[spells.berserk.id].attributes.lastTick = currentTime
						end
					elseif spellId == spells.clearcasting.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.tigersFury.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.bloodtalons.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[spellId].cooldown:Initialize()
						elseif type == "SPELL_AURA_REMOVED" then
							snapshotData.snapshots[spellId].attributes.endTimeLeeway = currentTime + 0.1
						end
					elseif spellId == spells.apexPredatorsCraving.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if settings.audio.apexPredatorsCraving.enabled then
								PlaySoundFile(settings.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == spells.predatorRevealed.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_REMOVED" then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								snapshotData.snapshots[spells.predatorRevealed.id].attributes.lastTick = currentTime
							end
							UpdatePredatorRevealed()
						end
					elseif spellId == spells.predatorRevealed.energizeId then
						if type == "SPELL_ENERGIZE" then
							snapshotData.snapshots[spells.predatorRevealed.id].attributes.lastTick = currentTime
						end
					elseif spellId == spells.brutalSlash.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[spellId].cooldown:Initialize()
						end
					end
				elseif specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then
					if spellId == spells.potionOfFrozenFocusRank1.spellId or spellId == spells.potionOfFrozenFocusRank2.spellId or spellId == spells.potionOfFrozenFocusRank3.spellId then
						local channeledManaPotion = snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
						channeledManaPotion.buff:Initialize(type)
					elseif spellId == spells.potionOfChilledClarity.id then
						local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
						potionOfChilledClarity.buff:Initialize(type)
					elseif spellId == spells.efflorescence.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[spellId].buff:InitializeCustom(spells.efflorescence.duration)
						end
					elseif spellId == spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.sunfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.clearcasting.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.incarnationTreeOfLife.id then
						snapshotData.snapshots[spellId].buff:Initialize(type)
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
			specCache.balance.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Balance()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.balance)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.moonfire)
			targetData:AddSpellTracking(spells.stellarFlare)
			targetData:AddSpellTracking(spells.sunfire)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Balance
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.druid.balance)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.balance)

			Twintop_Spells = spells
			Twintop_SnapshotData = TRB.Data.snapshotData
			if TRB.Data.barConstructedForSpec ~= "balance" then
				TRB.Data.barConstructedForSpec = "balance"
				ConstructResourceBar(specCache.balance.settings)
			end
		elseif specId == 2 then
			specCache.feral.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Feral()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.feral)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.moonfire, true, false, true)
			targetData:AddSpellTracking(spells.rake, true, false, true)
			targetData:AddSpellTracking(spells.rip, true, false, true)
			targetData:AddSpellTracking(spells.thrash, true, false, true)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Feral
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.druid.feral)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.feral)

			if TRB.Data.barConstructedForSpec ~= "feral" then
				TRB.Data.barConstructedForSpec = "feral"
				ConstructResourceBar(specCache.feral.settings)
			end
		elseif specId == 3 then
			specCache.guardian.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Guardian()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.guardian)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			--[[targetData:AddSpellTracking(spells.moonfire, true, false, true)
			targetData:AddSpellTracking(spells.rake, true, false, true)
			targetData:AddSpellTracking(spells.rip, true, false, true)
			targetData:AddSpellTracking(spells.thrash, true, false, true)]]

			TRB.Functions.RefreshLookupData = RefreshLookupData_Guardian
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.druid.guardian)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.guardian)

			if TRB.Data.barConstructedForSpec ~= "guardian" then
				TRB.Data.barConstructedForSpec = "guardian"
				ConstructResourceBar(specCache.guardian.settings)
			end
		elseif specId == 4 then
			specCache.restoration.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Restoration()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.moonfire)
			targetData:AddSpellTracking(spells.sunfire)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.druid.restoration)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.restoration)

			if TRB.Data.barConstructedForSpec ~= "restoration" then
				TRB.Data.barConstructedForSpec = "restoration"
				ConstructResourceBar(specCache.restoration.settings)
			end
		else
			TRB.Data.barConstructedForSpec = nil
		end
		

		TRB.Functions.Class:EventRegistration()
	end

	resourceFrame:RegisterEvent("ADDON_LOADED")
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local specId = GetSpecialization() or 0
		if classIndexId == 11 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Druid.LoadDefaultSettings()
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
							TRB.Data.settings.druid.balance = TRB.Functions.LibSharedMedia:ValidateLsmValues("Balance Druid", TRB.Data.settings.druid.balance)
							TRB.Data.settings.druid.feral = TRB.Functions.LibSharedMedia:ValidateLsmValues("Feral Druid", TRB.Data.settings.druid.feral)
							TRB.Data.settings.druid.guardian = TRB.Functions.LibSharedMedia:ValidateLsmValues("Guardian Druid", TRB.Data.settings.druid.guardian)
							TRB.Data.settings.druid.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues("Restoration Druid", TRB.Data.settings.druid.restoration)
							
							FillSpellData_Balance()
							FillSpellData_Feral()
							FillSpellData_Guardian()
							FillSpellData_Restoration()

							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Druid.ConstructOptionsPanel(specCache)
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
		TRB.Functions.Character:CheckCharacter()
		TRB.Data.character.className = "druid"

		if specId == 1 then
			TRB.Data.character.specName = "balance"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.LunarPower)
			GetCurrentMoonSpell()
		elseif specId == 2 then
			TRB.Data.character.specName = "feral"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
---@diagnostic disable-next-line: missing-parameter
			local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
			local settings = TRB.Data.settings.druid.feral

			if settings ~= nil then
				if maxComboPoints ~= TRB.Data.character.maxResource2 then
					TRB.Data.character.maxResource2 = maxComboPoints
					TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
				end
			end

			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.circleOfLifeAndDeath) then
				TRB.Data.character.pandemicModifier = TRB.Data.spells.circleOfLifeAndDeath.modifier
			end
		elseif specId == 3 then
			TRB.Data.character.specName = "guardian"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage)
		elseif specId == 4 then
			TRB.Data.character.specName = "restoration"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.Spell:FillSpellDataManaCost(TRB.Data.spells)

			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeVersion = ""
						
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
				end

				if alchemyStone == false then
					conjuredChillglobe, conjuredChillglobeVersion = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
				end
			end

			if alchemyStone == false and trinket2ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
				end
			end

			if conjuredChillglobe == false and trinket2ItemLink ~= nil then
				conjuredChillglobe, conjuredChillglobeVersion = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket2ItemLink)
			end

			TRB.Data.character.items.alchemyStone = alchemyStone
			TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
			TRB.Data.character.items.conjuredChillglobe.equippedVersion = conjuredChillglobeVersion
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.druid.balance == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.balance)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.LunarPower
			TRB.Data.resourceFactor = 10
			TRB.Data.resource2 = nil
			TRB.Data.resource2Factor = nil
		elseif specId == 2 and TRB.Data.settings.core.enabled.druid.feral == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.feral)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.ComboPoints
			TRB.Data.resource2Factor = 1
		elseif specId == 3 and TRB.Data.settings.core.enabled.druid.guardian == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.guardian)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
		elseif specId == 4 and TRB.Data.settings.core.enabled.druid.restoration then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.restoration)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
		else
			TRB.Data.specSupported = false
		end

		if TRB.Data.specSupported then
			TRB.Functions.Class:CheckCharacter()
			
			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		else
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

		TRB.Functions.Bar:HideResourceBar()
	end

	function TRB.Functions.Class:HideResourceBar(force)
		local spells = TRB.Data.spells
		local affectingCombat = UnitAffectingCombat("player")
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or GetSpecialization() ~= 1 or (not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.balance.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.balance.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.balance.displayBar.notZeroShow and
							((not TRB.Functions.Talent:IsTalentActive(spells.naturesBalance) and snapshotData.attributes.resource == 0) or
							(TRB.Functions.Talent:IsTalentActive(spells.naturesBalance) and (snapshotData.attributes.resource / TRB.Data.resourceFactor) >= 50))
						)
					)
				) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.druid.balance.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.feral.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.feral.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.feral.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.druid.feral.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 3 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.guardian.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.guardian.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.guardian.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.druid.guardian.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 4 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.restoration.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.restoration.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.restoration.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.druid.restoration.displayBar.neverShow == true then
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

		if guid ~= nil and guid ~= "" then
			local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
			local targets = targetData.targets
			if not targetData:CheckTargetExists(guid) then
				targetData:InitializeTarget(guid)
			end
			targets[guid].lastUpdate = GetTime()
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
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.druid.balance
		elseif specId == 2 then
			settings = TRB.Data.settings.druid.feral
		elseif specId == 3 then
			settings = TRB.Data.settings.druid.guardian
		elseif specId == 4 then
			settings = TRB.Data.settings.druid.restoration
		else
			return false
		end

		local affectingCombat = UnitAffectingCombat("player")

		if specId == 1 then -- Balance
			if var == "$moonkinForm" then
				if snapshots[spells.moonkinForm.id].buff.isActive then
					valid = true
				end
			elseif var == "$eclipse" then
				if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
					valid = true
				end
			elseif var == "$solar" or var == "$eclipseSolar" or var == "$solarEclipse" then
				if snapshots[spells.eclipseSolar.id].buff.isActive then
					valid = true
				end
			elseif var == "$lunar" or var == "$eclipseLunar" or var == "$lunarEclipse" then
				if snapshots[spells.eclipseLunar.id].buff.isActive then
					valid = true
				end
			elseif var == "$celestialAlignment" then
				if snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
					valid = true
				end
			elseif var == "$eclipseTime" then
				if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
					valid = true
				end
			elseif var == "$resource" or var == "$astralPower" then
				if snapshotData.attributes.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$astralPowerMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$astralPowerTotal" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$astralPowerPlusCasting" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$astralPowerOvercap" or var == "$resourceOvercap" then
				local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
				if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$astralPowerPlusPassive" then
				if snapshotData.attributes.resource > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$passive" then
				if (TRB.Functions.Talent:IsTalentActive(spells.naturesBalance) and (affectingCombat or (snapshotData.attributes.resource / TRB.Data.resourceFactor) < 50)) or snapshots[spells.furyOfElune.id].buff.resource > 0 or snapshots[spells.sunderedFirmament.id].buff.resource > 0 then
					valid = true
				end
			elseif var == "$sunfireCount" then
				if snapshotData.targetData.count[spells.sunfire.id] > 0 then
					valid = true
				end
			elseif var == "$sunfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.sunfire.id] ~= nil and
					target.spells[spells.sunfire.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if snapshotData.targetData.count[spells.moonfire.id] > 0 then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$stellarFlareCount" then
				if snapshotData.targetData.count[spells.stellarFlare.id] > 0 then
					valid = true
				end
			elseif var == "$stellarFlareTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.stellarFlare.id] ~= nil and
					target.spells[spells.stellarFlare.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$talentStellarFlare" then
				if TRB.Functions.Talent:IsTalentActive(spells.stellarFlare) then
					valid = true
				end
			elseif var == "$foeAstralPower" then
				if snapshots[spells.furyOfElune.id].buff.resource > 0 then
					valid = true
				end
			elseif var == "$foeTicks" then
				if snapshots[spells.furyOfElune.id].buff.isActive then
					valid = true
				end
			elseif var == "$foeTime" then
				if snapshots[spells.furyOfElune.id].buff.isActive then
					valid = true
				end
			elseif var == "$sunderedFirmamentAstralPower" then
				if snapshots[spells.sunderedFirmament.id].buff.isActive then
					valid = true
				end
			elseif var == "$sunderedFirmamentTicks" then
				if snapshots[spells.sunderedFirmament.id].buff.isActive then
					valid = true
				end
			elseif var == "$sunderedFirmamentTime" then
				if snapshots[spells.sunderedFirmament.id].buff.isActive then
					valid = true
				end				
			elseif var == "$starweaverTime" then
				if snapshots[spells.starweaversWarp.id].buff.isActive or snapshots[spells.starweaversWarp.id].buff.isActive  then
					valid = true
				end
			elseif var == "$starweaversWarp" then
				if snapshots[spells.starweaversWarp.id].buff.isActive then
					valid = true
				end
			elseif var == "$starweaversWeft" then
				if snapshots[spells.starweaversWarp.id].buff.isActive then
					valid = true
				end
			elseif var == "$moonAstralPower" then
				if TRB.Functions.Talent:IsTalentActive(spells.newMoon) then
					valid = true
				end
			elseif var == "$moonCharges" then
				if TRB.Functions.Talent:IsTalentActive(spells.newMoon) then
					if snapshots[spells.newMoon.id].cooldown.charges > 0 then
						valid = true
					end
				end
			elseif var == "$moonCooldown" then
				if TRB.Functions.Talent:IsTalentActive(spells.newMoon) then
					if snapshots[spells.newMoon.id].cooldown.onCooldown then
						valid = true
					end
				end
			elseif var == "$moonCooldownTotal" then
				if TRB.Functions.Talent:IsTalentActive(spells.newMoon) then
					if snapshots[spells.newMoon.id].cooldown.charges < snapshots[spells.newMoon.id].cooldown.maxCharges then
						valid = true
					end
				end
			elseif var == "$pulsarCollected" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarCollectedPercent" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemaining" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemainingPercent" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarsurgeCount" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarfallCount" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarNextStarsurge" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) and
					(((spells.primordialArcanicPulsar.maxAstralPower or 0) - (snapshots[spells.primordialArcanicPulsar.id].buff.customProperties["currentAstralPower"])) <= TRB.Data.character.starsurgeThreshold) then
					valid = true
				end
			elseif var == "$pulsarNextStarfall" then
				if TRB.Functions.Talent:IsTalentActive(spells.primordialArcanicPulsar) and
					(((spells.primordialArcanicPulsar.maxAstralPower or 0) - (snapshots[spells.primordialArcanicPulsar.id].buff.customProperties["currentAstralPower"])) <= TRB.Data.character.starfallThreshold) then
					valid = true
				end
			end
		elseif specId == 2 then -- Feral
			if var == "$resource" or var == "$energy" then
				if snapshotData.attributes.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$energyMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$energyTotal" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) then
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
			elseif var == "$comboPoints" then
				valid = true
			elseif var == "$comboPointsMax" then
				valid = true
			elseif var == "$ripCount" then
				if snapshotData.targetData.count[spells.rip.id] > 0 then
					valid = true
				end
			elseif var == "$ripCurrent" then
				valid = true
			elseif var == "$ripTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.rip.id] ~= nil and
					target.spells[spells.rip.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$ripPercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.rip.id] ~= nil and
					target.spells[spells.rip.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$ripSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.rip.id] ~= nil and
					target.spells[spells.rip.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$rakeCount" then
				if snapshotData.targetData.count[spells.rake.id] > 0 then
					valid = true
				end
			elseif var == "$rakeCurrent" then
				valid = true
			elseif var == "$rakeTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.rake.id] ~= nil and
					target.spells[spells.rake.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$rakePercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.rake.id] ~= nil and
					target.spells[spells.rake.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$rakeSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.rake.id] ~= nil and
					target.spells[spells.rake.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$thrashCount" then
				if snapshotData.targetData.count[spells.thrash.id] > 0 then
					valid = true
				end
			elseif var == "$thrashCurrent" then
				valid = true
			elseif var == "$thrashTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.thrash.id] ~= nil and
					target.spells[spells.thrash.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$thrashPercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.thrash.id] ~= nil and
					target.spells[spells.thrash.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$thrashSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.thrash.id] ~= nil and
					target.spells[spells.thrash.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true and snapshotData.targetData.count[spells.moonfire.id] > 0 then
					valid = true
				end
			elseif var == "$moonfireCurrent" then
				if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$moonfirePercent" then
				if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$moonfireSnapshot" then
				if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$lunarInspiration" then
				if TRB.Functions.Talent:IsTalentActive(spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$brutalSlashCharges" then
				if TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
					if snapshotData.attributes.brutalSlash.charges > 0 then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldown" then
				if TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
					if snapshotData.attributes.brutalSlash.cooldown > 0 then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldownTotal" then
				if TRB.Functions.Talent:IsTalentActive(spells.brutalSlash) then
					if snapshotData.attributes.brutalSlash.charges < snapshotData.attributes.brutalSlash.maxCharges then
						valid = true
					end
				end
			elseif var == "$bloodtalonsStacks" then
				if snapshots[spells.bloodtalons.id].buff.stacks > 0 then
					valid = true
				end
			elseif var == "$bloodtalonsTime" then
				if snapshots[spells.bloodtalons.id].buff.isActive then
					valid = true
				end
			elseif var == "$suddenAmbushTime" then
				if snapshots[spells.suddenAmbush.id].buff.isActive then
					valid = true
				end
			elseif var == "$clearcastingStacks" then
				if snapshots[spells.clearcasting.id].buff.stacks > 0 then
					valid = true
				end
			elseif var == "$clearcastingTime" then
				if snapshots[spells.clearcasting.id].buff.isActive then
					valid = true
				end
			elseif var == "$berserkTime" or var == "$incarnationTime" then
				if GetBerserkRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$apexPredatorsCravingTime" then
				if snapshots[spells.apexPredatorsCraving.id].buff.isActive then
					valid = true
				end
			elseif var == "$tigersFuryTime" then
				if snapshots[spells.tigersFury.id].buff.isActive then
					valid = true
				end
			elseif var == "$tigersFuryCooldownTime" then
				if snapshots[spells.tigersFury.id].cooldown:IsUnusable() then
					valid = true
				end
			elseif var == "$predatorRevealedTime" then
				if snapshots[spells.predatorRevealed.id].buff.isActive then
					valid = true
				end
			elseif var == "$predatorRevealedTicks" then
				if snapshots[spells.predatorRevealed.id].buff.isActive then
					valid = true
				end
			elseif var == "$predatorRevealedTickTime" then
				if snapshots[spells.predatorRevealed.id].buff.isActive then
					valid = true
				end
			elseif var == "$inStealth" then
				if IsStealthed() then
					valid = true
				end
			end
		elseif specId == 3 then --Guardian
			if var == "$resource" or var == "$rage" then
				valid = true
			elseif var == "$resourceMax" or var == "$rageMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$rageTotal" then
				valid = true
			elseif var == "$resourcePlusCasting" or var == "$ragePlusCasting" then
				valid = true
			elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
				valid = true
			elseif var == "$casting" then
				if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
					valid = true
				end
			end
		elseif specId == 4 then --Restoration
			if var == "$resource" or var == "$mana" then
				valid = true
			elseif var == "$resourceMax" or var == "$manaMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$manaTotal" then
				valid = true
			elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
				valid = true
			elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
				valid = true
			elseif var == "$casting" then
				if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
					valid = true
				end
			elseif var == "$efflorescenceTime" then
				if snapshots[spells.efflorescence.id].buff.isActive then
					valid = true
				end
			elseif var == "$clearcastingTime" then
				if snapshots[spells.clearcasting.id].buff.isActive then
					valid = true
				end
			elseif var == "$sunfireCount" then
				if snapshotData.targetData.count[spells.sunfire.id] > 0 then
					valid = true
				end
			elseif var == "$sunfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.sunfire.id] ~= nil and
					target.spells[spells.sunfire.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if snapshotData.targetData.count[spells.moonfire.id] > 0 then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$sohMana" then
				local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
				if symbolOfHope.buff.isActive then
					valid = true
				end
			elseif var == "$sohTime" then
				local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
				if symbolOfHope.buff.isActive then
					valid = true
				end
			elseif var == "$sohTicks" then
				local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
				if symbolOfHope.buff.isActive then
					valid = true
				end
			elseif var == "$innervateMana" then
				local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				if innervate.buff.isActive then
					valid = true
				end
			elseif var == "$innervateTime" then
				local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				if innervate.buff.isActive then
					valid = true
				end
			elseif var == "$potionOfChilledClarityMana" then
				local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
				if potionOfChilledClarity.buff.isActive then
					valid = true
				end
			elseif var == "$potionOfChilledClarityTime" then
				local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
				if potionOfChilledClarity.buff.isActive then
					valid = true
				end
			elseif var == "$mttMana" then
				local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
				if manaTideTotem.buff.isActive then
					valid = true
				end
			elseif var == "$mttTime" then
				local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
				if manaTideTotem.buff.isActive then
					valid = true
				end
			elseif var == "$mrMana" then
				local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
				if moltenRadiance.buff.isActive then
					valid = true
				end
			elseif var == "$mrTime" then
				local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
				if moltenRadiance.buff.isActive then
					valid = true
				end
			elseif var == "$channeledMana" then
				local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
				if channeledManaPotion.buff.isActive then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTicks" then
				local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
				if channeledManaPotion.buff.isActive then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTime" then
				local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
				if channeledManaPotion.buff.isActive then
					valid = true
				end
			elseif var == "$potionCooldown" then
				if snapshots[spells.aeratedManaPotionRank1.id].cooldown:IsUnusable() then
					valid = true
				end
			elseif var == "$potionCooldownSeconds" then
				if snapshots[spells.aeratedManaPotionRank1.id].cooldown:IsUnusable() then
					valid = true
				end
			elseif var == "$incarnationTime" then
				if snapshots[spells.incarnationChosenOfElune.id].buff.isActive  then
					valid = true
				end
			elseif var == "$reforestationStacks" then
				if snapshots[spells.reforestation.id].buff.stacks > 0 then
					valid = true
				end
			end
		else
			valid = false
		end

		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 and specId ~= 3 and specId ~= 4 then
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