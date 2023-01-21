local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 11 then --Only do this if we're on a Druid!
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
    local combatFrame = TRB.Frames.combatFrame
    
    local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	Global_TwintopResourceBar = {}
	TRB.Data.character = {}
    
	local specCache = {
		balance = {
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
		feral = {
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
		restoration = {
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
				astralPower = 2,
				pandemic = true,
				pandemicTime = 22 * 0.3,
				baseline = true
			},
		
			-- Druid Class Talents
			starfire = {
				id = 194153,
				name = "",
				icon = "",
				astralPower = 8,
				baseline = true,
				isTalent = true
			},
			starsurge = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				astralPower = 40,
				thresholdId = 1,
				settingKey = "starsurge",
				thresholdUsable = false,
				isTalent = true,
				baseline = true
			},
			starsurge2 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				thresholdId = 2,
				settingKey = "starsurge2",
				thresholdUsable = false
			},
			starsurge3 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				thresholdId = 3,
				settingKey = "starsurge3",
				thresholdUsable = false
			},
			moonkinForm = {
				id = 24858,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				astralPower = 2,
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
				icon = "",
				isActive = false
			},
			eclipseLunar = {
				id = 48518,
				name = "",
				icon = "",
				isActive = false
			},
			naturesBalance = {
				id = 202430,
				name = "",
				icon = "",
				astralPower = 0.5,
				outOfCombatAstralPower = 1.5,
				tickRate = 1,
				isTalent = true
			},
			starfall = {
				id = 191034,
				name = "",
				icon = "",
				texture = "",
				astralPower = 50,
				thresholdId = 4,
				settingKey = "starfall",
				thresholdUsable = false,
				isActive = false,
				pandemic = true,
				pandemicTime = 8 * 0.3,
				isTalent = true
			},
			stellarFlare = {
				id = 202347,
				name = "",
				icon = "",
				astralPower = 8,
				pandemic = true,
				pandemicTime = 24 * 0.3,
				isTalent = true
			},
			rattleTheStars = {
				id = 340049,
				name = "",
				icon = "",
				buffId = 393955,
				isActive = false,
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
				icon = "",
				isActive = false
			},
			starweaversWeft = { --Free Starsurge
				id = 393944,
				name = "",
				icon = "",
				isActive = false
			},
			celestialAlignment = {
				id = 194223,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
			primordialArcanicPulsar = {
				id = 393960,
				name = "",
				icon = "",
				maxAstralPower = 600,
				isTalent = true
			},
			soulOfTheForest = {
				id = 114107,
				name = "",
				icon = "",
				modifier = 1.5,
				isTalent = true
			},
			-- TODO: Add Wild Mushroom + associated tracking
			circleOfLifeAndDeath = {
				id = 391969,
				name = "",
				icon = "",
				isTalent = true,
				modifier = 0.75
			},
			incarnationChosenOfElune = {
				id = 394013,
				name = "",
				icon = "",
				isActive = false,
				isTalent = true
			},
			elunesGuidance = {
				id = 393991,
				name = "",
				icon = "",
				modifierStarsurge = -5,
				modifierStarfall = -8,
				isTalent = true,
				isActive = false
			},
			furyOfElune = {
				id = 202770,
				name = "",
				icon = "",
				astralPower = 2.5,
				duration = 8,
				ticks = 16,
				tickRate = 0.5,
				isTalent = true
			},
			newMoon = {
				id = 274281,
				name = "",
				icon = "",
				astralPower = 10,
				recharge = 20,
				isTalent = true
			},
			halfMoon = {
				id = 274282,
				name = "",
				icon = "",
				astralPower = 20
			},
			fullMoon = {
				id = 274283,
				name = "",
				icon = "",
				astralPower = 40
			},
			sunderedFirmament = {
				id = 394094,
				name = "",
				icon = "",
				buffId = 394108,
				astralPower = 0.5,
				duration = 8,
				ticks = 16,
				tickRate = 0.5,
				isTalent = true
			}
		}
		
		specCache.balance.snapshotData.audio = {
			playedSsCue = false,
			playedSfCue = false,
			playedstarweaverCue = false
		}

		specCache.balance.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			sunfire = 0,
			moonfire = 0,
			stellarFlare = 0,
			targets = {}
		}
		specCache.balance.snapshotData.furyOfElune = {
			isActive = false,
			ticksRemaining = 0,
			startTime = nil,
			astralPower = 0
		}
		specCache.balance.snapshotData.sunderedFirmament = {
			isActive = false,
			ticksRemaining = 0,
			startTime = nil,
			astralPower = 0
		}

		specCache.balance.snapshotData.eclipseSolar = {
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshotData.eclipseLunar = {
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshotData.celestialAlignment = {
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshotData.incarnationChosenOfElune = {
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshotData.starfall = {
			spellId = nil,
			endTime = nil, --End of buff
			duration = 0, --Duration of buff
		}
		specCache.balance.snapshotData.newMoon = {
			currentSpellId = nil,
			currentIcon = "",
			currentKey = "",
			checkAfter = nil,
			charges = 3,
			maxCharges = 3,
			startTime = nil,
			duration = 0
		}
		specCache.balance.snapshotData.starweaversWarp = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.balance.snapshotData.starweaversWeft = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.balance.snapshotData.rattleTheStars = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			stacks = 0
		}
		specCache.balance.snapshotData.primordialArcanicPulsar = {
			currentAstralPower = 0
		}

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
				id = 106830,
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
				isTalent = true,
				baseline = true
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
				isTalent = true
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

			-- Feral Spec Talents
			tigersFury = {
				id = 5217,
				name = "",
				icon = "",
				modifier = 1.15,
				cooldown = 30,
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
				icon = "",
				isActive = false
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
				isTalent = true
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
				isClearcasting = true
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
			}
		}

		specCache.feral.snapshotData.energyRegen = 0
		specCache.feral.snapshotData.comboPoints = 0
		specCache.feral.snapshotData.audio = {
			overcapCue = false
		}
		specCache.feral.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			--Bleeds
			rake = 0,
			rip = 0,
			thrash = 0,
			--Other
			moonfire = 0,
			targets = {}
		}
		specCache.feral.snapshotData.maim = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.feral.snapshotData.brutalSlash = {
			startTime = nil,
			duration = 0,
			charges = 0,
			maxCharges = 3
		}
		specCache.feral.snapshotData.feralFrenzy = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.feral.snapshotData.clearcasting = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0,
			endTimeLeeway = nil
		}
		specCache.feral.snapshotData.tigersFury = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			cooldown = {
				startTime = nil,
				duration = 0
			}
		}
		specCache.feral.snapshotData.shadowmeld = {
			isActive = false
		}
		specCache.feral.snapshotData.prowl = {
			isActive = false
		}
		specCache.feral.snapshotData.suddenAmbush = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			endTimeLeeway = nil
		}
		specCache.feral.snapshotData.berserk = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.feral.snapshotData.incarnationAvatarOfAshamane = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.feral.snapshotData.bloodtalons = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			stacks = 0,
			endTimeLeeway = nil
		}
		specCache.feral.snapshotData.apexPredatorsCraving = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.feral.snapshotData.snapshots = {
			rake = 100,
			rip = 100,
			thrash = 100,
			moonfire = 100
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
			efflorescence = {
				id = 145205,
				name = "",
				icon = "",
				duration = 30
			},
			innervate = {
				id = 29166,
				name = "",
				icon = "",
				duration = 10,
				isActive = false
			},
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				pandemic = true,
				pandemicTime = 12 * 0.3
			},
			moonfire = {
				id = 164812,
				name = "",
				icon = "",
				astralPower = 2,
				pandemic = true,
				pandemicTime = 16 * 0.3
			},
			clearcasting = {
				id = 16870,
				name = "",
				icon = ""
			},

			-- External mana
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 4.0, --Hasted
				manaPercent = 0.03,
				ticks = 3,
				tickId = 265144
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8,
				isActive = false
			},

			-- Potions
			aeratedManaPotionRank1 = {
				itemId = 191384,
				spellId = 370607,
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
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 3,
				settingKey = "aeratedManaPotionRank3",
				thresholdUsable = false
			},
			potionOfFrozenFocusRank1 = {
				itemId = 191363,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 4,
				settingKey = "potionOfFrozenFocusRank1",
				thresholdUsable = false,
				mana = 3652,
				duration = 10,
				ticks = 10
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
				thresholdUsable = false,
				mana = 4200,
				duration = 10,
				ticks = 10
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
				thresholdUsable = false,
				mana = 4830,
				duration = 10,
				ticks = 10
			},

			-- Conjured Chillglobe
			conjuredChillglobe = {
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
			}
		}

		specCache.restoration.snapshotData.manaRegen = 0
		specCache.restoration.snapshotData.audio = {
			innervateCue = false
		}
		specCache.restoration.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			sunfire = 0,
			moonfire = 0,
			targets = {}
		}
		specCache.restoration.snapshotData.efflorescence = {
			endTime = nil
		}
		specCache.restoration.snapshotData.clearcasting = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.restoration.snapshotData.innervate = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.restoration.snapshotData.manaTideTotem = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.restoration.snapshotData.symbolOfHope = {
			isActive = false,
			ticksRemaining = 0,
			tickRate = 0,
			tickRateFound = false,
			previousTickTime = nil,
			firstTickTime = nil, -- First time we saw a tick.
			endTime = nil,
			resourceRaw = 0,
			resourceFinal = 0
		}
		specCache.restoration.snapshotData.channeledManaPotion = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.restoration.snapshotData.potion = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.restoration.snapshotData.conjuredChillglobe = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}

		specCache.restoration.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Balance()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "druid", "balance")
		TRB.Functions.LoadFromSpecCache(specCache.balance)
	end

	local function Setup_Feral()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "druid", "feral")
		TRB.Functions.LoadFromSpecCache(specCache.feral)
	end

	local function Setup_Restoration()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "druid", "restoration")
		TRB.Functions.LoadFromSpecCache(specCache.restoration)
	end

	local function FillSpellData_Balance()
		Setup_Balance()
		local spells = TRB.Functions.FillSpellData(specCache.balance.spells)

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

	local function FillSpellData_Feral()
		Setup_Feral()
		local spells = TRB.Functions.FillSpellData(specCache.feral.spells)
		

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
            { variable = "#primalWrath", icon = spells.primalWrath.icon, description = spells.primalWrath.name, printInSettings = true },
            { variable = "#prowl", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = true },
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

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.feral.spells = spells
	end

	local function FillSpellData_Restoration()
		Setup_Restoration()
		local spells = TRB.Functions.FillSpellData(specCache.restoration.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.restoration.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#efflorescence", icon = spells.efflorescence.icon, description = spells.efflorescence.name, printInSettings = true },
            { variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
            
            { variable = "#moonfire", icon = spells.moonfire.icon, description = "Moonfire", printInSettings = true },
			{ variable = "#sunfire", icon = spells.sunfire.icon, description = "Sunfire", printInSettings = true },
            
			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },
			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = false },
			{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
			{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
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

			{ variable = "$sunfireCount", description = "Number of Sunfires active on targets", printInSettings = true, color = false },
			{ variable = "$sunfireTime", description = "Time remaining on Sunfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = "Number of Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Moonfire on your current target", printInSettings = true, color = false },

			{ variable = "$sohMana", description = "Mana from Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTime", description = "Time left on Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTicks", description = "Number of ticks left from Symbol of Hope", printInSettings = true, color = false },

			{ variable = "$innervateMana", description = "Passive mana regen while Innervate is active", printInSettings = true, color = false },
			{ variable = "$innervateTime", description = "Time left on Innervate", printInSettings = true, color = false },
			
			{ variable = "$mttMana", description = "Bonus passive mana regen while Mana Tide Totem is active", printInSettings = true, color = false },
			{ variable = "$mttTime", description = "Time left on Mana Tide Totem", printInSettings = true, color = false },

			{ variable = "$wfMana", description = "Mana from Wrathful Faerie (per settings)", printInSettings = true, color = false },
			{ variable = "$wfGcds", description = "Number of GCDs left on Wrathful Faerie", printInSettings = true, color = false },
			{ variable = "$wfProcs", description = "Number of Procs left on Wrathful Faerie", printInSettings = true, color = false },
			{ variable = "$wfTime", description = "Time left on Wrathful Faerie", printInSettings = true, color = false },
			
			{ variable = "$channeledMana", description = "Mana while channeling of Potion of Frozen Focus", printInSettings = true, color = false },
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
		local currentTime = GetTime()
		if GetSpecialization() == 1 and TRB.Functions.IsTalentActive(TRB.Data.spells.newMoon) and (TRB.Data.snapshotData.newMoon.checkAfter == nil or currentTime >= TRB.Data.snapshotData.newMoon.checkAfter) then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.newMoon.currentSpellId = select(7, GetSpellInfo(TRB.Data.spells.newMoon.name))

			if TRB.Data.snapshotData.newMoon.currentSpellId == TRB.Data.spells.newMoon.id then
				TRB.Data.snapshotData.newMoon.currentKey = "newMoon"
			elseif TRB.Data.snapshotData.newMoon.currentSpellId == TRB.Data.spells.halfMoon.id then
				TRB.Data.snapshotData.newMoon.currentKey = "halfMoon"
			elseif TRB.Data.snapshotData.newMoon.currentSpellId == TRB.Data.spells.fullMoon.id then
				TRB.Data.snapshotData.newMoon.currentKey = "fullMoon"
			else
				TRB.Data.snapshotData.newMoon.currentKey = "newMoon"
			end
			TRB.Data.snapshotData.newMoon.checkAfter = nil
			TRB.Data.snapshotData.newMoon.currentIcon = TRB.Data.spells[TRB.Data.snapshotData.newMoon.currentKey].icon
		else
			TRB.Data.snapshotData.newMoon.currentSpellId = TRB.Data.spells.newMoon.id
			TRB.Data.snapshotData.newMoon.currentKey = "newMoon"
			TRB.Data.snapshotData.newMoon.checkAfter = nil
		end
	end

	local function CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "druid"

		if specId == 1 then
			TRB.Data.character.specName = "balance"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.LunarPower)
			GetCurrentMoonSpell()

			if TRB.Functions.IsTalentActive(TRB.Data.spells.circleOfLifeAndDeath) then
				TRB.Data.character.pandemicModifier = TRB.Data.spells.circleOfLifeAndDeath.modifier
			end
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
					TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
				end
			end

			if TRB.Functions.IsTalentActive(TRB.Data.spells.circleOfLifeAndDeath) then
				TRB.Data.character.pandemicModifier = TRB.Data.spells.circleOfLifeAndDeath.modifier
			end
		elseif specId == 4 then
			TRB.Data.character.specName = "restoration"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.FillSpellDataManaCost(TRB.Data.spells)

			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeVersion = ""
						
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.TableLength(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.DoesItemLinkMatchId(trinket1ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
				end

				if alchemyStone == false then
					conjuredChillglobe, conjuredChillglobeVersion = TRB.Functions.CheckTrinketForConjuredChillglobe(trinket1ItemLink)
				end
			end

			if alchemyStone == false and trinket2ItemLink ~= nil then
				for x = 1, TRB.Functions.TableLength(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.DoesItemLinkMatchId(trinket2ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
				end
			end

			if conjuredChillglobe == false and trinket2ItemLink ~= nil then
				conjuredChillglobe, conjuredChillglobeVersion = TRB.Functions.CheckTrinketForConjuredChillglobe(trinket2ItemLink)
			end

			TRB.Data.character.items.alchemyStone = alchemyStone
			TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
			TRB.Data.character.items.conjuredChillglobe.equippedVersion = conjuredChillglobeVersion
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.druid.balance == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.druid.balance)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.LunarPower
			TRB.Data.resourceFactor = 10
			TRB.Data.resource2 = nil
			TRB.Data.resource2Factor = nil
		elseif specId == 2 and TRB.Data.settings.core.enabled.druid.feral == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.druid.feral)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.ComboPoints
			TRB.Data.resource2Factor = 1
		elseif specId == 4 and TRB.Data.settings.core.enabled.druid.restoration then
			TRB.Functions.IsTtdActive(TRB.Data.settings.druid.restoration)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
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
	
    local function CalculateAbilityResourceValue(resource, threshold, relentlessPredator)
        local modifier = 1.0
		local specId = GetSpecialization()

		if specId == 2 then
			if TRB.Data.spells.incarnationAvatarOfAshamane.isActive then
				modifier = modifier * TRB.Data.spells.incarnationAvatarOfAshamane.energyModifier
			end
			
			if relentlessPredator and TRB.Functions.IsTalentActive(TRB.Data.spells.relentlessPredator) then
				modifier = modifier * TRB.Data.spells.relentlessPredator.energyModifier
			end
		end

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
				if specId == 1 then -- Balance
					TRB.Data.snapshotData.targetData.targets[guid].sunfire = false
					TRB.Data.snapshotData.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfire = false
					TRB.Data.snapshotData.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].stellarFlare = false
					TRB.Data.snapshotData.targetData.targets[guid].stellarFlareRemaining = 0
				elseif specId == 2 then -- Feral
					TRB.Data.snapshotData.targetData.targets[guid].rake = false
					TRB.Data.snapshotData.targetData.targets[guid].rakeRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].rakeSnapshot = 0
					TRB.Data.snapshotData.targetData.targets[guid].rip = false
					TRB.Data.snapshotData.targetData.targets[guid].ripRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].ripSnapshot = 0
					TRB.Data.snapshotData.targetData.targets[guid].thrash = false
					TRB.Data.snapshotData.targetData.targets[guid].thrashRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].thrashSnapshot = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfire = false
					TRB.Data.snapshotData.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfireSnapshot = 0
				elseif specId == 4 then -- Restoration
					TRB.Data.snapshotData.targetData.targets[guid].sunfire = false
					TRB.Data.snapshotData.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfire = false
					TRB.Data.snapshotData.targetData.targets[guid].moonfireRemaining = 0
				end
			end
			TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()
			return true
		end
		return false
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

		if specId == 1 then
			local sunfireTotal = 0
			local moonfireTotal = 0
			local stellarFlareTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[guid].sunfire = false
					TRB.Data.snapshotData.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfire = false
					TRB.Data.snapshotData.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].stellarFlare = false
					TRB.Data.snapshotData.targetData.targets[guid].stellarFlareRemaining = 0
				else
					if TRB.Data.snapshotData.targetData.targets[guid].sunfire == true then
						sunfireTotal = sunfireTotal + 1
					end
					
					if TRB.Data.snapshotData.targetData.targets[guid].moonfire == true then
						moonfireTotal = moonfireTotal + 1
					end
					
					if TRB.Data.snapshotData.targetData.targets[guid].stellarFlare == true then
						stellarFlareTotal = stellarFlareTotal + 1
					end
				end
			end

			TRB.Data.snapshotData.targetData.sunfire = sunfireTotal
			TRB.Data.snapshotData.targetData.moonfire = moonfireTotal
			TRB.Data.snapshotData.targetData.stellarFlare = stellarFlareTotal
		elseif specId == 2 then
			local rakeTotal = 0
			local ripTotal = 0
			local thrashTotal = 0
			local moonfireTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[guid].rake = false
					TRB.Data.snapshotData.targetData.targets[guid].rakeRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].rakeSnapshot = 0
					TRB.Data.snapshotData.targetData.targets[guid].rip = false
					TRB.Data.snapshotData.targetData.targets[guid].ripRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].ripSnapshot = 0
					TRB.Data.snapshotData.targetData.targets[guid].thrash = false
					TRB.Data.snapshotData.targetData.targets[guid].thrashRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].thrashSnapshot = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfire = false
					TRB.Data.snapshotData.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfireSnapshot = 0
				else
					if TRB.Data.snapshotData.targetData.targets[guid].rake == true then
						rakeTotal = rakeTotal + 1
					end
					
					if TRB.Data.snapshotData.targetData.targets[guid].rip == true then
						ripTotal = ripTotal + 1
					end
					
					if TRB.Data.snapshotData.targetData.targets[guid].thrash == true then
						thrashTotal = thrashTotal + 1
					end
					
					if TRB.Data.snapshotData.targetData.targets[guid].moonfire == true then
						moonfireTotal = moonfireTotal + 1
					end
				end
			end

			TRB.Data.snapshotData.targetData.rake = rakeTotal
			TRB.Data.snapshotData.targetData.rip = ripTotal
			TRB.Data.snapshotData.targetData.thrash = thrashTotal
			TRB.Data.snapshotData.targetData.moonfire = moonfireTotal			
		elseif specId == 4 then -- Restoration
			local sunfireTotal = 0
			local moonfireTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[guid].sunfire = false
					TRB.Data.snapshotData.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].moonfire = false
					TRB.Data.snapshotData.targetData.targets[guid].moonfireRemaining = 0
				else
					if TRB.Data.snapshotData.targetData.targets[guid].sunfire == true then
						sunfireTotal = sunfireTotal + 1
					end
					
					if TRB.Data.snapshotData.targetData.targets[guid].moonfire == true then
						moonfireTotal = moonfireTotal + 1
					end
				end
			end

			TRB.Data.snapshotData.targetData.sunfire = sunfireTotal
			TRB.Data.snapshotData.targetData.moonfire = moonfireTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		local specId = GetSpecialization()

		if specId == 1 then
			if clearAll == true then
				TRB.Data.snapshotData.targetData.sunfire = 0
				TRB.Data.snapshotData.targetData.moonfire = 0
				TRB.Data.snapshotData.targetData.stellarFlare = 0
			end
		elseif specId == 2 then
			if clearAll == true then
				TRB.Data.snapshotData.targetData.rake = 0
				TRB.Data.snapshotData.targetData.rip = 0
				TRB.Data.snapshotData.targetData.thrash = 0
				TRB.Data.snapshotData.targetData.moonfire = 0
			end
		elseif specId == 4 then
			if clearAll == true then
				TRB.Data.snapshotData.targetData.sunfire = 0
				TRB.Data.snapshotData.targetData.moonfire = 0
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

		if specId == 1 then
			for x = 1, 4 do -- SS30, SS60, SS90, SF50
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.starsurge.settingKey, settings)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.starsurge2.settingKey, settings)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.starsurge3.settingKey, settings)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.starfall.settingKey, settings)
			TRB.Frames.resource2ContainerFrame:Hide()
		elseif specId == 2 then
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
		elseif specId == 4 then
			for x = 1, 7 do
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end

			for x = 1, 4 do
				if TRB.Frames.passiveFrame.thresholds[x] == nil then
					TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
				end

				TRB.Frames.passiveFrame.thresholds[x]:Show()
				TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.passiveFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Frames.resource2ContainerFrame:Hide()
		end

		TRB.Functions.ConstructResourceBar(settings)

		if specId == 1 or specId == 2 or specId == 4 then
			TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
		end
	end
	
	local function GetTigersFuryCooldownRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.tigersFury.cooldown)
	end

	local function GetTigersFuryRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.tigersFury)
	end
	
	local function GetClearcastingRemainingTime(leeway)
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.clearcasting, leeway)
	end
	
	local function GetBloodtalonsRemainingTime(leeway)
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.bloodtalons, leeway)
	end
	
	local function GetBerserkRemainingTime()
		if TRB.Functions.IsTalentActive(TRB.Data.spells.incarnationAvatarOfAshamane) then
			return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.incarnationAvatarOfAshamane)
		else
			return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.berserk)
		end
	end
		
	local function GetSuddenAmbushRemainingTime(leeway)
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.suddenAmbush, leeway)
	end
	
	local function GetApexPredatorsCravingRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.apexPredatorsCraving)
	end

	local function GetEclipseRemainingTime()
		local remainingTime = 0
		local icon = nil

		if TRB.Data.spells.celestialAlignment.isActive then
			remainingTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.celestialAlignment)
			icon = TRB.Data.spells.celestialAlignment.icon
		elseif TRB.Data.spells.incarnationChosenOfElune.isActive then
			remainingTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.incarnationChosenOfElune)
			icon = TRB.Data.spells.incarnationChosenOfElune.icon
		elseif TRB.Data.spells.eclipseSolar.isActive then
			remainingTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.eclipseSolar)
			icon = TRB.Data.spells.eclipseSolar.icon
		elseif TRB.Data.spells.eclipseLunar.isActive then
			remainingTime = TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.eclipseLunar)
			icon = TRB.Data.spells.eclipseLunar.icon
		end

		if remainingTime < 0 then
			remainingTime = 0
		end

		return remainingTime, icon
	end

	local function GetStarfallCooldownRemainingTime()
		if TRB.Data.snapshotData.starfall.cdStartTime == nil then
			return 0
		end

		local currentTime = GetTime()
		local cdRemaining = math.max(0, TRB.Data.snapshotData.starfall.cdDuration - (currentTime - TRB.Data.snapshotData.starfall.cdStartTime))
		return cdRemaining
	end
	
	local function GetFuryOfEluneRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.furyOfElune)
	end
	
	local function GetSunderedFirmamentRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.sunderedFirmament)
	end

	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.channeledManaPotion)
	end

	local function GetInnervateRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.innervate)
	end

	local function GetManaTideTotemRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.manaTideTotem)
	end

	local function GetSymbolOfHopeRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.symbolOfHope)
	end

	local function GetEfflorescenceRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.efflorescence)
	end

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

	local function GetCurrentSnapshot(bonuses)
		local snapshot = 1.0

		if bonuses.tigersFury == true and GetTigersFuryRemainingTime() > 0 then
			local tfBonus = TRB.Data.spells.carnivorousInstinct.modifierPerStack * TRB.Data.talents[TRB.Data.spells.carnivorousInstinct.id].currentRank

			snapshot = snapshot * (TRB.Data.spells.tigersFury.modifier + tfBonus)
		end

		if bonuses.momentOfClarity == true and TRB.Functions.IsTalentActive(TRB.Data.spells.momentOfClarity) == true and ((TRB.Data.snapshotData.clearcasting.stacks ~= nil and TRB.Data.snapshotData.clearcasting.stacks > 0) or GetClearcastingRemainingTime(true) > 0) then
			snapshot = snapshot * TRB.Data.spells.momentOfClarity.modifier
		end

		if bonuses.bloodtalons == true and TRB.Functions.IsTalentActive(TRB.Data.spells.bloodtalons) == true and ((TRB.Data.snapshotData.bloodtalons.stacks ~= nil and TRB.Data.snapshotData.bloodtalons.stacks > 0) or GetBloodtalonsRemainingTime(true) > 0) then
			snapshot = snapshot * TRB.Data.spells.bloodtalons.modifier
		end
		if bonuses.stealth == true and (
			TRB.Data.snapshotData.shadowmeld.isActive or
			TRB.Data.snapshotData.prowl.isActive or
			GetBerserkRemainingTime() > 0 or
			GetSuddenAmbushRemainingTime(true) > 0 or
			TRB.Data.spells.incarnationAvatarOfAshamane.isActive) then
			snapshot = snapshot * TRB.Data.spells.prowl.modifier
		end

		return snapshot
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.druid.balance
		elseif specId == 2 then
			settings = TRB.Data.settings.druid.feral
		elseif specId == 4 then
			settings = TRB.Data.settings.druid.restoration
		end

        local affectingCombat = UnitAffectingCombat("player")

		if specId == 1 then -- Balance
			if var == "$moonkinForm" then
				if TRB.Data.spells.moonkinForm.isActive then
					valid = true
				end
			elseif var == "$eclipse" then
				if TRB.Data.spells.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
					valid = true
				end
			elseif var == "$solar" or var == "$eclipseSolar" or var == "$solarEclipse" then
				if TRB.Data.spells.eclipseSolar.isActive then
					valid = true
				end
			elseif var == "$lunar" or var == "$eclipseLunar" or var == "$lunarEclipse" then
				if TRB.Data.spells.eclipseLunar.isActive then
					valid = true
				end
			elseif var == "$celestialAlignment" then
				if TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
					valid = true
				end
			elseif var == "$eclipseTime" then
				if TRB.Data.spells.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
					valid = true
				end
			elseif var == "$resource" or var == "$astralPower" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$astralPowerMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$astralPowerTotal" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$astralPowerPlusCasting" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$astralPowerOvercap" or var == "$resourceOvercap" then
				if ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.settings.druid.balance.overcapThreshold then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$astralPowerPlusPassive" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$passive" then
				if (TRB.Functions.IsTalentActive(TRB.Data.spells.naturesBalance) and (affectingCombat or (TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) < 50)) or TRB.Data.snapshotData.furyOfElune.astralPower > 0 or TRB.Data.snapshotData.sunderedFirmament.astralPower > 0 then
					valid = true
				end
			elseif var == "$sunfireCount" then
				if TRB.Data.snapshotData.targetData.sunfire > 0 then
					valid = true
				end
			elseif var == "$sunfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if TRB.Data.snapshotData.targetData.moonfire > 0 then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining > 0 then
					valid = true
				end
			elseif var == "$stellarFlareCount" then
				if TRB.Data.snapshotData.targetData.stellarFlare > 0 then
					valid = true
				end
			elseif var == "$stellarFlareTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlareRemaining > 0 then
					valid = true
				end
			elseif var == "$talentStellarFlare" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.stellarFlare) then
					valid = true
				end
			elseif var == "$foeAstralPower" then
				if TRB.Data.snapshotData.furyOfElune.astralPower > 0 then
					valid = true
				end
			elseif var == "$foeTicks" then
				if TRB.Data.snapshotData.furyOfElune.remainingTicks > 0 then
					valid = true
				end
			elseif var == "$foeTime" then
				if TRB.Data.snapshotData.furyOfElune.startTime ~= nil then
					valid = true
				end
			elseif var == "$sunderedFirmamentAstralPower" then
				if TRB.Data.snapshotData.sunderedFirmament.astralPower > 0 then
					valid = true
				end
			elseif var == "$sunderedFirmamentTicks" then
				if TRB.Data.snapshotData.sunderedFirmament.remainingTicks > 0 then
					valid = true
				end
			elseif var == "$sunderedFirmamentTime" then
				if TRB.Data.snapshotData.sunderedFirmament.startTime ~= nil then
					valid = true
				end				
			elseif var == "$starweaverTime" then
				if TRB.Data.spells.starweaversWarp.isActive or TRB.Data.spells.starweaversWarp.isActive  then
					valid = true
				end
			elseif var == "$starweaversWarp" then
				if TRB.Data.spells.starweaversWarp.isActive then
					valid = true
				end
			elseif var == "$starweaversWeft" then
				if TRB.Data.spells.starweaversWarp.isActive then
					valid = true
				end
			elseif var == "$moonAstralPower" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.newMoon) then
					valid = true
				end
			elseif var == "$moonCharges" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.newMoon) then
					if TRB.Data.snapshotData.newMoon.charges > 0 then
						valid = true
					end
				end
			elseif var == "$moonCooldown" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.newMoon) then
					if TRB.Data.snapshotData.newMoon.cooldown > 0 then
						valid = true
					end
				end
			elseif var == "$moonCooldownTotal" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.newMoon) then
					if TRB.Data.snapshotData.newMoon.charges < TRB.Data.snapshotData.newMoon.maxCharges then
						valid = true
					end
				end
			elseif var == "$pulsarCollected" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarCollectedPercent" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemaining" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemainingPercent" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarsurgeCount" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarfallCount" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarNextStarsurge" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) and
					(((TRB.Data.spells.primordialArcanicPulsar.maxAstralPower or 0) - (TRB.Data.snapshotData.primordialArcanicPulsar.currentAstralPower or 0)) <= TRB.Data.character.starsurgeThreshold) then
					valid = true
				end
			elseif var == "$pulsarNextStarfall" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) and
					(((TRB.Data.spells.primordialArcanicPulsar.maxAstralPower or 0) - (TRB.Data.snapshotData.primordialArcanicPulsar.currentAstralPower or 0)) <= TRB.Data.character.starfallThreshold) then
					valid = true
				end
			end
		elseif specId == 2 then -- Feral
			if var == "$resource" or var == "$energy" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$energyMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$energyTotal" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$energyOvercap" or var == "$resourceOvercap" then
				if ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.settings.druid.feral.overcapThreshold then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$comboPoints" then
				valid = true
			elseif var == "$comboPointsMax" then
				valid = true
			elseif var == "$ripCount" then
				if TRB.Data.snapshotData.targetData.rip > 0 then
					valid = true
				end
			elseif var == "$ripCurrent" then
				valid = true
			elseif var == "$ripTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ripRemaining > 0 then
					valid = true
				end
			elseif var == "$ripPercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ripSnapshot > 0 then
					valid = true
				end
			elseif var == "$ripSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ripSnapshot > 0 then
					valid = true
				end
			elseif var == "$rakeCount" then
				if TRB.Data.snapshotData.targetData.rake > 0 then
					valid = true
				end
			elseif var == "$rakeCurrent" then
				valid = true
			elseif var == "$rakeTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rakeRemaining > 0 then
					valid = true
				end
			elseif var == "$rakePercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rakeSnapshot > 0 then
					valid = true
				end
			elseif var == "$rakeSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rakeSnapshot > 0 then
					valid = true
				end
			elseif var == "$thrashCount" then
				if TRB.Data.snapshotData.targetData.thrash > 0 then
					valid = true
				end
			elseif var == "$thrashCurrent" then
				valid = true
			elseif var == "$thrashTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrashRemaining > 0 then
					valid = true
				end
			elseif var == "$thrashPercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrashSnapshot > 0 then
					valid = true
				end
			elseif var == "$thrashSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrashSnapshot > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true and TRB.Data.snapshotData.targetData.moonfire > 0 then
					valid = true
				end
			elseif var == "$moonfireCurrent" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining > 0 then
					valid = true
				end
			elseif var == "$moonfirePercent" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireSnapshot > 0 then
					valid = true
				end
			elseif var == "$moonfireSnapshot" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireSnapshot > 0 then
					valid = true
				end
			elseif var == "$lunarInspiration" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$brutalSlashCharges" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
					if TRB.Data.snapshotData.brutalSlash.charges > 0 then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldown" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
					if TRB.Data.snapshotData.brutalSlash.cooldown > 0 then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldownTotal" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
					if TRB.Data.snapshotData.brutalSlash.charges < TRB.Data.snapshotData.brutalSlash.maxCharges then
						valid = true
					end
				end
			elseif var == "$bloodtalonsStacks" then
				if TRB.Data.snapshotData.bloodtalons.stacks > 0 then
					valid = true
				end
			elseif var == "$bloodtalonsTime" then
				if TRB.Data.snapshotData.bloodtalons.remainingTime > 0 then
					valid = true
				end
			elseif var == "$suddenAmbushTime" then
				if GetSuddenAmbushRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$clearcastingStacks" then
				if TRB.Data.snapshotData.clearcasting.stacks > 0 then
					valid = true
				end
			elseif var == "$clearcastingTime" then
				if TRB.Data.snapshotData.clearcastingTime.remainingTime > 0 then
					valid = true
				end
			elseif var == "$berserkTime" or var == "$incarnationTime" then
				if GetBerserkRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$apexPredatorsCravingTime" then
				if GetApexPredatorsCravingRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$tigersFuryTime" then
				if TRB.Data.snapshotData.tigersFury.duration > 0 then
					valid = true
				end
			elseif var == "$tigersFuryCooldownTime" then
				if TRB.Data.snapshotData.tigersFury.cooldown.duration > 0 then
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
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$passive" then
				if IsValidVariableForSpec("$channeledMana") or
					IsValidVariableForSpec("$sohMana") or
					IsValidVariableForSpec("$innervateMana") or
					IsValidVariableForSpec("$mttMana") then
					valid = true
				end
			elseif var == "$efflorescenceTime" then
				if GetEfflorescenceRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$sunfireCount" then
				if TRB.Data.snapshotData.targetData.sunfire > 0 then
					valid = true
				end
			elseif var == "$clearcastingTime" then
				if TRB.Data.snapshotData.clearcasting.remainingTime > 0 then
					valid = true
				end
			elseif var == "$sunfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if TRB.Data.snapshotData.targetData.moonfire > 0 then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining > 0 then
					valid = true
				end
			elseif var == "$sohMana" then
				if TRB.Data.snapshotData.symbolOfHope.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$sohTime" then
				if TRB.Data.snapshotData.symbolOfHope.isActive then
					valid = true
				end
			elseif var == "$sohTicks" then
				if TRB.Data.snapshotData.symbolOfHope.isActive then
					valid = true
				end
			elseif var == "$innervateMana" then
				if TRB.Data.snapshotData.innervate.mana > 0 then
					valid = true
				end
			elseif var == "$innervateTime" then
				if TRB.Data.snapshotData.innervate.isActive then
					valid = true
				end
			elseif var == "$mttMana" or var == "$manaTideTotemMana" then
				if TRB.Data.snapshotData.manaTideTotem.mana > 0 then
					valid = true
				end
			elseif var == "$mttTime" or var == "$manaTideTotemTime" then
				if TRB.Data.snapshotData.manaTideTotem.isActive then
					valid = true
				end
			elseif var == "$channeledMana" then
				if TRB.Data.snapshotData.channeledManaPotion.mana > 0 then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTicks" then
				if TRB.Data.snapshotData.channeledManaPotion.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTime" then
				if GetChanneledPotionRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$potionCooldown" then
				if TRB.Data.snapshotData.potion.onCooldown then
					valid = true
				end
			elseif var == "$potionCooldownSeconds" then
				if TRB.Data.snapshotData.potion.onCooldown then
					valid = true
				end
			end
		else
			valid = false
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Balance()
		local currentTime = GetTime()
		local normalizedAstralPower = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

		--local moonkinFormActive = TRB.Data.spells.moonkinForm.isActive

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.current
		local castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.casting

		local astralPowerThreshold = math.min(TRB.Data.character.starsurgeThreshold, TRB.Data.character.starfallThreshold)

		if TRB.Data.settings.druid.balance.colors.text.overcapEnabled and overcap then 
			currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overcap
			castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overcap
		elseif TRB.Data.settings.druid.balance.colors.text.overThresholdEnabled and normalizedAstralPower >= astralPowerThreshold then
			currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overThreshold
			castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overThreshold
		end

		--$astralPower
		local astralPowerPrecision = TRB.Data.settings.druid.balance.astralPowerPrecision or 0
		local currentAstralPower = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.RoundTo(normalizedAstralPower, astralPowerPrecision, "floor"))
		--$casting
		local castingAstralPower = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, astralPowerPrecision, "floor"))
		--$passive
        local _passiveAstralPower = TRB.Data.snapshotData.furyOfElune.astralPower + TRB.Data.snapshotData.sunderedFirmament.astralPower
		if TRB.Functions.IsTalentActive(TRB.Data.spells.naturesBalance) then
			if UnitAffectingCombat("player") then
				_passiveAstralPower = _passiveAstralPower + TRB.Data.spells.naturesBalance.astralPower
			elseif normalizedAstralPower < 50 then
				_passiveAstralPower = _passiveAstralPower + TRB.Data.spells.naturesBalance.outOfCombatAstralPower
			end
		end

		local passiveAstralPower = string.format("|c%s%s|r", TRB.Data.settings.druid.balance.colors.text.passive, TRB.Functions.RoundTo(_passiveAstralPower, astralPowerPrecision, "ceil"))
		--$astralPowerTotal
		local _astralPowerTotal = math.min(_passiveAstralPower + TRB.Data.snapshotData.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerTotal = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.RoundTo(_astralPowerTotal, astralPowerPrecision, "floor"))
		--$astralPowerPlusCasting
		local _astralPowerPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusCasting = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.RoundTo(_astralPowerPlusCasting, astralPowerPrecision, "floor"))
		--$astralPowerPlusPassive
		local _astralPowerPlusPassive = math.min(_passiveAstralPower + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusPassive = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.RoundTo(_astralPowerPlusPassive, astralPowerPrecision, "floor"))

		----------
		--$sunfireCount and $sunfireTime
        local _sunfireCount = TRB.Data.snapshotData.targetData.sunfire or 0
		local sunfireCount = tostring(_sunfireCount)
		local _sunfireTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_sunfireTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining or 0
		end

		local sunfireTime

        --$moonfireCount and $moonfireTime
        local _moonfireCount = TRB.Data.snapshotData.targetData.moonfire or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_moonfireTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining or 0
		end

		local moonfireTime

        --$stellarFlareCount and $stellarFlareTime
		local _stellarFlareCount = TRB.Data.snapshotData.targetData.stellarFlare or 0
		local stellarFlareCount = tostring(_stellarFlareCount)
		local _stellarFlareTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_stellarFlareTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlareRemaining or 0
		end

		local stellarFlareTime

		if TRB.Data.settings.druid.balance.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfire then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining > (TRB.Data.character.pandemicModifier * TRB.Data.spells.sunfire.pandemicTime) then
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining)
				else
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining)
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfire then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining > (TRB.Data.character.pandemicModifier * TRB.Data.spells.moonfire.pandemicTime) then
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining)
				else
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining)
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlare then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlareRemaining > (TRB.Data.character.pandemicModifier * TRB.Data.spells.stellarFlare.pandemicTime) then
					stellarFlareCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlareRemaining)
				else
					stellarFlareCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlareRemaining)
				end
			else
				stellarFlareCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, _stellarFlareCount)
				stellarFlareTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, 0)
			end
		else
			sunfireTime = string.format("%.1f", _sunfireTime)
			moonfireTime = string.format("%.1f", _moonfireTime)
			stellarFlareTime = string.format("%.1f", _stellarFlareTime)
		end


		--$mdTime
		local _starweaverTime = 0
		if TRB.Data.snapshotData.starweaversWarp.spellId ~= nil then
			_starweaverTime = math.abs(TRB.Data.snapshotData.starweaversWarp.endTime - currentTime)
		elseif TRB.Data.snapshotData.starweaversWarp.spellId ~= nil then
			_starweaverTime = math.abs(TRB.Data.snapshotData.starweaversWeft.endTime - currentTime)
		end
		local starweaverTime = string.format("%.1f", _starweaverTime)

        ----------
        --$foeAstralPower
        local foeAstralPower = TRB.Data.snapshotData.furyOfElune.astralPower or 0
        --$foeTicks
		local foeTicks = TRB.Data.snapshotData.furyOfElune.ticksRemaining or 0
		--$foeTime
		local _foeTime = GetFuryOfEluneRemainingTime()
		local foeTime = "0.0"
		if TRB.Data.snapshotData.furyOfElune.startTime ~= nil then
			foeTime = string.format("%.1f", _foeTime)
		end
		
        ----------
        --$foeAstralPower
        local sunderedFirmamentAstralPower = TRB.Data.snapshotData.sunderedFirmament.astralPower or 0
        --$foeTicks
		local sunderedFirmamentTicks = TRB.Data.snapshotData.sunderedFirmament.ticksRemaining or 0
		--$foeTime
		local _sunderedFirmamentTime = GetSunderedFirmamentRemainingTime()
		local sunderedFirmamentTime = "0.0"
		if TRB.Data.snapshotData.sunderedFirmament.startTime ~= nil then
			sunderedFirmamentTime = string.format("%.1f",_sunderedFirmamentTime)
		end
		
		--New Moon
		local currentMoonIcon = TRB.Data.spells.newMoon.icon
		--$moonAstralPower
		local moonAstralPower = 0
		--$moonCharges
		local moonCharges = TRB.Data.snapshotData.newMoon.charges
		--$moonCooldown
		local _moonCooldown = 0
		--$moonCooldownTotal
		local _moonCooldownTotal = 0
		if TRB.Data.snapshotData.newMoon.currentKey ~= "" and TRB.Data.snapshotData.newMoon.currentSpellId ~= nil then
			currentMoonIcon = TRB.Data.spells[TRB.Data.snapshotData.newMoon.currentKey].icon
			moonAstralPower = TRB.Data.spells[TRB.Data.snapshotData.newMoon.currentKey].astralPower

			if TRB.Data.snapshotData.newMoon.startTime ~= nil and TRB.Data.snapshotData.newMoon.charges < TRB.Data.snapshotData.newMoon.maxCharges then
				_moonCooldown = math.max(0, TRB.Data.snapshotData.newMoon.startTime + TRB.Data.snapshotData.newMoon.duration - currentTime)
				_moonCooldownTotal = _moonCooldown + ((TRB.Data.snapshotData.newMoon.maxCharges - TRB.Data.snapshotData.newMoon.charges - 1) * TRB.Data.snapshotData.newMoon.duration)
			end
		end
		local moonCooldown = string.format("%.1f", _moonCooldown)
		local moonCooldownTotal = string.format("%.1f", _moonCooldownTotal)

		--$eclipseTime
		local _eclispeTime, eclipseIcon = GetEclipseRemainingTime()
		local eclipseTime = "0.0"
		if _eclispeTime ~= nil then
			eclipseTime = string.format("%.1f", _eclispeTime)
		end

		--#starweaver

		local starweaverIcon = TRB.Data.spells.starweaversWarp.icon
		if TRB.Data.spells.starweaversWeft.isActive then
			starweaverIcon = TRB.Data.spells.starweaversWeft.icon
		end

		--$pulsar variables
		local pulsarCollected = TRB.Data.snapshotData.primordialArcanicPulsar.currentAstralPower or 0
		local _pulsarCollectedPercent = pulsarCollected / TRB.Data.spells.primordialArcanicPulsar.maxAstralPower
		local pulsarCollectedPercent = string.format("%.1f", TRB.Functions.RoundTo(_pulsarCollectedPercent * 100, 1))
		local pulsarRemaining = TRB.Data.spells.primordialArcanicPulsar.maxAstralPower - pulsarCollected
		local _pulsarRemainingPercent = pulsarRemaining / TRB.Data.spells.primordialArcanicPulsar.maxAstralPower
		local pulsarRemainingPercent = string.format("%.1f", TRB.Functions.RoundTo(_pulsarRemainingPercent * 100, 1))
		--local pulsarNextStarsurge = ""
		--local pulsarNextStarfall = ""
		local pulsarStarsurgeCount = TRB.Functions.RoundTo(pulsarRemaining / TRB.Data.spells.starsurge.astralPower, 0, ceil)
		local pulsarStarfallCount = TRB.Functions.RoundTo(pulsarRemaining / TRB.Data.spells.starfall.astralPower, 0, ceil)
		
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
		lookup["#wrath"] = TRB.Data.spells.wrath.icon
		lookup["#moonkinForm"] = TRB.Data.spells.moonkinForm.icon
		lookup["#starfire"] = TRB.Data.spells.starfire.icon
		lookup["#sunfire"] = TRB.Data.spells.sunfire.icon
		lookup["#moonfire"] = TRB.Data.spells.moonfire.icon
		lookup["#starsurge"] = TRB.Data.spells.starsurge.icon
		lookup["#starfall"] = TRB.Data.spells.starfall.icon
		lookup["#eclipse"] = eclipseIcon or TRB.Data.spells.celestialAlignment.icon
		lookup["#celestialAlignment"] = TRB.Data.spells.celestialAlignment.icon
		lookup["#icoe"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#coe"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#incarnation"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#incarnationChosenOfElune"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#solar"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#eclipseSolar"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#solarEclipse"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#lunar"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#eclipseLunar"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#lunarEclipse"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#naturesBalance"] = TRB.Data.spells.naturesBalance.icon
		lookup["#soulOfTheForest"] = TRB.Data.spells.soulOfTheForest.icon
		lookup["#foe"] = TRB.Data.spells.furyOfElune.icon
		lookup["#furyOfElune"] = TRB.Data.spells.furyOfElune.icon
		lookup["#sunderedFirmament"] = TRB.Data.spells.sunderedFirmament.icon
		lookup["#stellarFlare"] = TRB.Data.spells.stellarFlare.icon
		lookup["#newMoon"] = TRB.Data.spells.newMoon.icon
		lookup["#halfMoon"] = TRB.Data.spells.halfMoon.icon
		lookup["#fullMoon"] = TRB.Data.spells.fullMoon.icon
		lookup["#moon"] = currentMoonIcon
		lookup["#starweaver"] = starweaverIcon
		lookup["#starweaversWarp"] = TRB.Data.spells.starweaversWarp.icon
		lookup["#starweaversWeft"] = TRB.Data.spells.starweaversWeft.icon
		lookup["#pulsar"] = TRB.Data.spells.primordialArcanicPulsar.icon
		lookup["#pap"] = TRB.Data.spells.primordialArcanicPulsar.icon
		lookup["#primordialArcanicPulsar"] = TRB.Data.spells.primordialArcanicPulsar.icon
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
		--lookupLogic["$pulsarNextStarsurge"] = pulsarNextStarsurge
		--lookupLogic["$pulsarNextStarfall"] = pulsarNextStarfall
		lookupLogic["$pulsarStarsurgeCount"] = pulsarStarsurgeCount
		lookupLogic["$pulsarStarfallCount"] = pulsarStarfallCount
		--lookupLogic["$moonkinForm"] = moonkinFormActive
		lookupLogic["$eclipseTime"] = _eclispeTime
		--[[lookupLogic["$eclipse"] = ""
		lookupLogic["$lunar"] = ""
		lookupLogic["$lunarEclipse"] = ""
		lookupLogic["$eclipseLunar"] = ""
		lookupLogic["$solar"] = ""
		lookupLogic["$solarEclipse"] = ""
		lookupLogic["$eclipseSolar"] = ""
		lookupLogic["$celestialAlignment"] = ""]]
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
		local _

		-- Curren snapshot values if they were applied now
		local _currentSnapshotRip = TRB.Data.snapshotData.snapshots.rip
		local _currentSnapshotRake = TRB.Data.snapshotData.snapshots.rake
		local _currentSnapshotThrash = TRB.Data.snapshotData.snapshots.thrash
		local _currentSnapshotMoonfire = TRB.Data.snapshotData.snapshots.moonfire		

		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.druid.feral.colors.text.current
		local castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.casting

		if TRB.Data.settings.druid.feral.colors.text.overcapEnabled and overcap then
			currentEnergyColor = TRB.Data.settings.druid.feral.colors.text.overcap
            castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.overcap
		elseif TRB.Data.settings.druid.feral.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = TRB.Data.settings.druid.feral.colors.text.overThreshold
				castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.spending
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

		if TRB.Data.settings.druid.feral.generation.enabled then
			if TRB.Data.settings.druid.feral.generation.mode == "time" then
				_regenEnergy = TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.druid.feral.generation.time or 3.0)
			else
				_regenEnergy = TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.druid.feral.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy --+ _barbedShotEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)

		
		----------
		--$ripCount and $ripTime
        local _ripCount = TRB.Data.snapshotData.targetData.rip or 0
		local ripCount = tostring(_ripCount)
		local _ripTime = 0
		local ripTime
		local _ripSnapshot = 0
		local ripSnapshot
		local _ripPercent = 0
		local ripPercent
		local ripCurrent

		--$rakeCount and $rakeTime
        local _rakeCount = TRB.Data.snapshotData.targetData.rake or 0
		local rakeCount = tostring(_rakeCount)
		local _rakeTime = 0
		local rakeTime
		local _rakeSnapshot = 0
		local rakeSnapshot
		local _rakePercent = 0
		local rakePercent
		local rakeCurrent

		--$thrashCount and $thrashTime
        local _thrashCount = TRB.Data.snapshotData.targetData.thrash or 0
		local thrashCount = tostring(_thrashCount)
		local _thrashTime = 0
		local thrashTime
		local _thrashSnapshot = 0
		local thrashSnapshot
		local _thrashPercent = 0
		local thrashPercent
		local thrashCurrent

        --$moonfireCount and $moonfireTime
        local _moonfireCount = TRB.Data.snapshotData.targetData.moonfire or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		local moonfireTime
		local _moonfireSnapshot = 0
		local moonfireSnapshot
		local _moonfirePercent = 0
		local moonfirePercent
		local moonfireCurrent
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_ripTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ripRemaining or 0
			_ripSnapshot = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ripSnapshot or 0
			_ripPercent = (_ripSnapshot / _currentSnapshotRip)
			_rakeTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rakeRemaining or 0
			_rakeSnapshot = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rakeSnapshot or 0
			_rakePercent = (_rakeSnapshot / _currentSnapshotRake)
			_thrashTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrashRemaining or 0
			_thrashSnapshot = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrashSnapshot or 0
			_thrashPercent = (_thrashSnapshot / _currentSnapshotThrash)
			_moonfireTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining or 0
			_moonfireSnapshot = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireSnapshot or 0
			_moonfirePercent = (_moonfireSnapshot / _currentSnapshotMoonfire)
		end

		if TRB.Data.settings.druid.feral.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rip then
				local ripColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _ripPercent > 1 then
					ripColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _ripPercent < 1 then
					ripColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					ripColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				ripCount = string.format("|c%s%.0f|r", ripColor, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", ripColor, TRB.Functions.RoundTo(100 * _ripSnapshot, 0, "floor"))
				ripCurrent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.RoundTo(100 * _ripPercent, 0, "floor"))
				ripTime = string.format("|c%s%.1f|r", ripColor, _ripTime)
			else
				ripCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				ripCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				ripTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rake then
				local rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _rakePercent > 1 then
					rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _rakePercent < 1 then
					rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				rakeCount = string.format("|c%s%.0f|r", rakeColor, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.RoundTo(100 * _rakeSnapshot, 0, "floor"))
				rakeCurrent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.RoundTo(100 * _rakePercent, 0, "floor"))
				rakeTime = string.format("|c%s%.1f|r", rakeColor, _rakeTime)
			else
				rakeCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				rakeCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				rakeTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrash then
				local thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _thrashPercent > 1 then
					thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _thrashPercent < 1 then
					thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				thrashCount = string.format("|c%s%.0f|r", thrashColor, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.RoundTo(100 * _thrashSnapshot, 0, "floor"))
				thrashCurrent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.RoundTo(100 * _thrashPercent, 0, "floor"))
				thrashTime = string.format("|c%s%.1f|r", thrashColor, _thrashTime)
			else
				thrashCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				thrashCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				thrashTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end

			if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfire then
				local moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _moonfirePercent > 1 then
					moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _moonfirePercent < 1 then
					moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				moonfireCount = string.format("|c%s%.0f|r", moonfireColor, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.RoundTo(100 * _moonfireSnapshot, 0, "floor"))
				moonfireCurrent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.RoundTo(100 * _moonfirePercent, 0, "floor"))
				moonfireTime = string.format("|c%s%.1f|r", moonfireColor, _moonfireTime)
			else
				moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				moonfireCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end
		else
			ripTime = string.format("%.1f", _ripTime)
			rakeTime = string.format("%.1f", _rakeTime)
			thrashTime = string.format("%.1f", _thrashTime)

			ripSnapshot = TRB.Functions.RoundTo(100 * _ripSnapshot, 0, "floor")
			rakeSnapshot = TRB.Functions.RoundTo(100 * _rakeSnapshot, 0, "floor")
			thrashSnapshot = TRB.Functions.RoundTo(100 * _thrashSnapshot, 0, "floor")

			ripCurrent = TRB.Functions.RoundTo(100 * _currentSnapshotRip, 0, "floor")
			rakeCurrent = TRB.Functions.RoundTo(100 * _currentSnapshotRake, 0, "floor")
			thrashCurrent = TRB.Functions.RoundTo(100 * _currentSnapshotThrash, 0, "floor")

			ripPercent = TRB.Functions.RoundTo(100 * _ripPercent, 0, "floor")
			rakePercent = TRB.Functions.RoundTo(100 * _rakePercent, 0, "floor")
			thrashPercent = TRB.Functions.RoundTo(100 * _thrashPercent, 0, "floor")

			if TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) == true then
				moonfireTime = string.format("%.1f", _moonfireTime)
				moonfireSnapshot = TRB.Functions.RoundTo(100 * _moonfireSnapshot, 0, "floor")
				moonfireCurrent = TRB.Functions.RoundTo(100 * _currentSnapshotMoonfire, 0, "floor")
				moonfirePercent = TRB.Functions.RoundTo(100 * _moonfirePercent, 0, "floor")
			else
				moonfireTime = string.format("%.1f", 0)
				moonfireSnapshot = 0
				moonfireCurrent = TRB.Functions.RoundTo(100 * _currentSnapshotMoonfire, 0, "floor")
				moonfirePercent = 0
			end
		end
		
		--$brutalSlashCharges
		local brutalSlashCharges = TRB.Data.snapshotData.brutalSlash.charges
		--$brutalSlashCooldown
		local _brutalSlashCooldown = 0
		--$brutalSlashCooldownTotal
		local _brutalSlashCooldownTotal = 0

		if TRB.Data.snapshotData.brutalSlash.startTime ~= nil and TRB.Data.snapshotData.brutalSlash.charges < TRB.Data.snapshotData.brutalSlash.maxCharges then
			local _brutalSlashHastedCooldown = (TRB.Data.snapshotData.brutalSlash.duration / (1 + (TRB.Data.snapshotData.haste / 100)))
			_brutalSlashCooldown = math.max(0, TRB.Data.snapshotData.brutalSlash.startTime + _brutalSlashHastedCooldown - currentTime)
			_brutalSlashCooldownTotal = _brutalSlashCooldown + ((TRB.Data.snapshotData.brutalSlash.maxCharges - TRB.Data.snapshotData.brutalSlash.charges - 1) * _brutalSlashHastedCooldown)
		end

		local brutalSlashCooldown = string.format("%.1f", _brutalSlashCooldown)
		local brutalSlashCooldownTotal = string.format("%.1f", _brutalSlashCooldownTotal)
		
		--$bloodtalonsStacks
		local bloodtalonsStacks = TRB.Data.snapshotData.bloodtalons.stacks or 0

		--$bloodtalonsTime
		local _bloodtalonsTime = TRB.Data.snapshotData.bloodtalons.remainingTime or 0
		local bloodtalonsTime = string.format("%.1f", _bloodtalonsTime)
		
		--$tigersFuryTime
		local _tigersFuryTime = GetTigersFuryRemainingTime()
		local tigersFuryTime = "0"
		if _tigersFuryTime ~= nil then
			tigersFuryTime = string.format("%.1f", _tigersFuryTime)
		end
		
		--$tigersFuryCooldownTime
		local _tigersFuryCooldownTime = GetTigersFuryCooldownRemainingTime()
		local tigersFuryCooldownTime = "0"
		if _tigersFuryCooldownTime ~= nil then
			tigersFuryCooldownTime = string.format("%.1f", _tigersFuryCooldownTime)
		end

		--$suddenAmbushTime
		local _suddenAmbushTime = GetSuddenAmbushRemainingTime()
		local suddenAmbushTime = "0"
		if _suddenAmbushTime ~= nil then
			suddenAmbushTime = string.format("%.1f", _suddenAmbushTime)
		end
		
		--$clearcastingStacks
		local clearcastingStacks = TRB.Data.snapshotData.clearcasting.stacks or 0

		--$clearcastingTime
		local _clearcastingTime = TRB.Data.snapshotData.clearcasting.remainingTime or 0
		local clearcastingTime = string.format("%.1f", _clearcastingTime)

		--$berserkTime (and $incarnationTime)
		local _berserkTime = GetBerserkRemainingTime()
		local berserkTime = string.format("%.1f", _berserkTime)

		--$apexPredatorsCravingTime
		local _apexPredatorsCravingTime = GetApexPredatorsCravingRemainingTime()
		local apexPredatorsCravingTime = "0"
		if _apexPredatorsCravingTime ~= nil then
			apexPredatorsCravingTime = string.format("%.1f", _apexPredatorsCravingTime)
		end
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
		lookup["#berserk"] = TRB.Data.spells.berserk.icon
		lookup["#bloodtalons"] = TRB.Data.spells.bloodtalons.icon
		lookup["#brutalSlash"] = TRB.Data.spells.brutalSlash.icon
		lookup["#carnivorousInstinct"] = TRB.Data.spells.carnivorousInstinct.icon
		lookup["#catForm"] = TRB.Data.spells.catForm.icon
		lookup["#clearcasting"] = TRB.Data.spells.clearcasting.icon
		lookup["#feralFrenzy"] = TRB.Data.spells.feralFrenzy.icon
		lookup["#ferociousBite"] = TRB.Data.spells.ferociousBite.icon
		lookup["#incarnation"] = TRB.Data.spells.incarnationAvatarOfAshamane.icon
		lookup["#incarnationAvatarOfAshamane"] = TRB.Data.spells.incarnationAvatarOfAshamane.icon
		lookup["#lunarInspiration"] = TRB.Data.spells.lunarInspiration.icon
		lookup["#maim"] = TRB.Data.spells.maim.icon
		lookup["#moonfire"] = TRB.Data.spells.moonfire.icon
		lookup["#predatorySwiftness"] = TRB.Data.spells.predatorySwiftness.icon
		lookup["#primalWrath"] = TRB.Data.spells.primalWrath.icon
		lookup["#prowl"] = TRB.Data.spells.prowl.icon
		lookup["#rake"] = TRB.Data.spells.rake.icon
		lookup["#rip"] = TRB.Data.spells.rip.icon
		lookup["#shadowmeld"] = TRB.Data.spells.shadowmeld.icon
		lookup["#shred"] = TRB.Data.spells.shred.icon
		lookup["#suddenAmbush"] = TRB.Data.spells.suddenAmbush.icon
		lookup["#swipe"] = TRB.Data.spells.swipe.icon
		lookup["#thrash"] = TRB.Data.spells.thrash.icon
		lookup["#tigersFury"] = TRB.Data.spells.tigersFury.icon
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
		--lookupLogic["$lunarInspiration"] = ""
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
		lookupLogic["$regen"] = _regenEnergy
		lookupLogic["$regenEnergy"] = _regenEnergy
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Restoration()
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshotData.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.druid.restoration.colors.text.current
		local castingManaColor = TRB.Data.settings.druid.restoration.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.druid.restoration.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = TRB.Data.snapshotData.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		--$sohMana
		local _sohMana = TRB.Data.snapshotData.symbolOfHope.resourceFinal
		local sohMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
		--$sohTicks
		local _sohTicks = TRB.Data.snapshotData.symbolOfHope.ticksRemaining or 0
		local sohTicks = string.format("%.0f", _sohTicks)
		--$sohTime
		local _sohTime = GetSymbolOfHopeRemainingTime()
		local sohTime = string.format("%.1f", _sohTime)

		--$innervateMana
		local _innervateMana = TRB.Data.snapshotData.innervate.mana
		local innervateMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
		--$innervateTime
		local _innervateTime = GetInnervateRemainingTime()
		local innervateTime = string.format("%.1f", _innervateTime)

		--$mttMana
		local _mttMana = TRB.Data.snapshotData.symbolOfHope.resourceFinal
		local mttMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
		--$mttTime
		local _mttTime = GetManaTideTotemRemainingTime()
		local mttTime = string.format("%.1f", _mttTime)

		--$potionCooldownSeconds
		local _potionCooldown = 0
		if TRB.Data.snapshotData.potion.onCooldown then
			_potionCooldown = math.abs(TRB.Data.snapshotData.potion.startTime + TRB.Data.snapshotData.potion.duration - currentTime)
		end
		local potionCooldownSeconds = string.format("%.1f", _potionCooldown)
		local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
		local _potionCooldownSeconds = _potionCooldown % 60
		--$potionCooldown
		local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)

		--$channeledMana
		local _channeledMana = CalculateManaGain(TRB.Data.snapshotData.channeledManaPotion.mana, true)
		local channeledMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
		--$potionOfFrozenFocusTicks
		local _potionOfFrozenFocusTicks = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining or 0
		local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
		--$potionOfFrozenFocusTime
		local _potionOfFrozenFocusTime = GetChanneledPotionRemainingTime()
		local potionOfFrozenFocusTime = string.format("%.1f", _potionOfFrozenFocusTime)
		--$passive
		local _passiveMana = _sohMana + _channeledMana + _innervateMana + _mttMana
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.druid.restoration.colors.text.passive, TRB.Functions.ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
		--$manaTotal
		local _manaTotal = math.min(_passiveMana + TRB.Data.snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
		--$manaPlusCasting
		local _manaPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor", true))
		--$manaPlusPassive
		local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor", true))

		--$manaMax
		local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

		--$manaPercent
		local maxResource = TRB.Data.character.maxResource

		if maxResource == 0 then
			maxResource = 1
		end
		local _manaPercent = (normalizedMana/maxResource)
		local manaPercent = string.format("|c%s%s|r", currentManaColor, TRB.Functions.RoundTo(_manaPercent*100, manaPrecision, "floor"))

		--$efflorescenceTime
		local _efflorescenceTime = GetEfflorescenceRemainingTime()
		local efflorescenceTime = string.format("%.1f", _efflorescenceTime)
	
		--$clearcastingTime
		local _clearcastingTime = TRB.Data.snapshotData.clearcasting.remainingTime or 0
		local clearcastingTime = string.format("%.1f", _clearcastingTime)

		----------
		--$sunfireCount and $sunfireTime
        local _sunfireCount = TRB.Data.snapshotData.targetData.sunfire or 0
		local sunfireCount = tostring(_sunfireCount)
		local _sunfireTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_sunfireTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining or 0
		end

		local sunfireTime

        --$moonfireCount and $moonfireTime
        local _moonfireCount = TRB.Data.snapshotData.targetData.moonfire or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_moonfireTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining or 0
		end

		local moonfireTime

		if TRB.Data.settings.druid.restoration.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfire then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining > TRB.Data.spells.sunfire.pandemicTime then
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining)
				else
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining)
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfire then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining > TRB.Data.spells.moonfire.pandemicTime then
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining)
				else
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining)
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, 0)
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
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _channeledMana,
			ticks = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = TRB.Data.snapshotData.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.dots = {
			sunfireCount = _sunfireCount or 0,
			moonfireCount = _moonfireCount or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#efflorescence"] = TRB.Data.spells.efflorescence.icon
		lookup["#clearcasting"] = TRB.Data.spells.clearcasting.icon
		lookup["#sunfire"] = TRB.Data.spells.sunfire.icon
		lookup["#moonfire"] = TRB.Data.spells.moonfire.icon
		lookup["#innervate"] = TRB.Data.spells.innervate.icon
		lookup["#mtt"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#soh"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#amp"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
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
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
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
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$efflorescenceTime"] = _efflorescenceTime
		lookupLogic["$clearcastingTime"] = _clearcastingTime
		lookupLogic["$sunfireCount"] = _sunfireCount
		lookupLogic["$sunfireTime"] = _sunfireTime
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		TRB.Data.lookupLogic = lookupLogic
	end

    local function FillSnapshotDataCasting_Balance(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.astralPower
        TRB.Data.snapshotData.casting.resourceFinal = spell.astralPower
        TRB.Data.snapshotData.casting.spellId = spell.id
        TRB.Data.snapshotData.casting.icon = spell.icon
    end	

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function UpdateCastingResourceFinal_Restoration()
		-- Do nothing for now
		TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw * TRB.Data.snapshotData.innervate.modifier
	end

	local function CastingSpell()
		local specId = GetSpecialization()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					TRB.Functions.ResetCastingSnapshotData()
					return false
					--See druid implementation for handling channeled spells
				else
					if currentSpellId == TRB.Data.spells.wrath.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.wrath)
						if TRB.Functions.IsTalentActive(TRB.Data.spells.soulOfTheForest) and TRB.Data.spells.eclipseSolar.isActive then
							TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceFinal * TRB.Data.spells.soulOfTheForest.modifier
						end
					elseif currentSpellId == TRB.Data.spells.starfire.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.starfire)
						--Warrior of Elune logic would go here if it didn't make it instant cast!
					elseif currentSpellId == TRB.Data.spells.sunfire.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.sunfire)
					elseif currentSpellId == TRB.Data.spells.moonfire.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.moonfire)
					elseif currentSpellId == TRB.Data.spells.stellarFlare.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.stellarFlare)
					elseif currentSpellId == TRB.Data.spells.newMoon.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.newMoon)
					elseif currentSpellId == TRB.Data.spells.halfMoon.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.halfMoon)
					elseif currentSpellId == TRB.Data.spells.fullMoon.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.fullMoon)
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 2 then
				if currentSpellName == nil then
					TRB.Functions.ResetCastingSnapshotData()
					return false
					--See druid implementation for handling channeled spells
				else
					TRB.Functions.ResetCastingSnapshotData()
					return false
				end
			elseif specId == 4 then
				if currentSpellName == nil then
					TRB.Functions.ResetCastingSnapshotData()
					return false
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.GetSpellManaCost(spellId)

						TRB.Data.snapshotData.casting.startTime = currentSpellStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentSpellEndTime / 1000
						TRB.Data.snapshotData.casting.resourceRaw = manaCost
						TRB.Data.snapshotData.casting.spellId = spellId
						TRB.Data.snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Restoration()
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				end
				return true
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateFuryOfElune()
		if TRB.Data.snapshotData.furyOfElune.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.furyOfElune.startTime == nil or currentTime > (TRB.Data.snapshotData.furyOfElune.startTime + TRB.Data.spells.furyOfElune.duration) then
				TRB.Data.snapshotData.furyOfElune.ticksRemaining = 0
				TRB.Data.snapshotData.furyOfElune.startTime = nil
				TRB.Data.snapshotData.furyOfElune.astralPower = 0
				TRB.Data.snapshotData.furyOfElune.isActive = false
			end
		end
	end

	local function UpdateSunderedFirmament()
		if TRB.Data.snapshotData.sunderedFirmament.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.sunderedFirmament.startTime == nil or currentTime > (TRB.Data.snapshotData.sunderedFirmament.startTime + TRB.Data.spells.sunderedFirmament.duration) then
				TRB.Data.snapshotData.sunderedFirmament.ticksRemaining = 0
				TRB.Data.snapshotData.sunderedFirmament.startTime = nil
				TRB.Data.snapshotData.sunderedFirmament.astralPower = 0
				TRB.Data.snapshotData.sunderedFirmament.isActive = false
			end
		end
	end

	local function UpdateChanneledManaPotion(forceCleanup)
		if TRB.Data.snapshotData.channeledManaPotion.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or TRB.Data.snapshotData.channeledManaPotion.endTime == nil or currentTime > TRB.Data.snapshotData.channeledManaPotion.endTime then
				TRB.Data.snapshotData.channeledManaPotion.ticksRemaining = 0
				TRB.Data.snapshotData.channeledManaPotion.endTime = nil
				TRB.Data.snapshotData.channeledManaPotion.mana = 0
				TRB.Data.snapshotData.channeledManaPotion.isActive = false
				TRB.Data.snapshotData.channeledManaPotion.spellKey = nil
			else
				TRB.Data.snapshotData.channeledManaPotion.ticksRemaining = math.ceil((TRB.Data.snapshotData.channeledManaPotion.endTime - currentTime) / (TRB.Data.spells[TRB.Data.snapshotData.channeledManaPotion.spellKey].duration / TRB.Data.spells[TRB.Data.snapshotData.channeledManaPotion.spellKey].ticks))
				local nextTickRemaining = TRB.Data.snapshotData.channeledManaPotion.endTime - currentTime - math.floor((TRB.Data.snapshotData.channeledManaPotion.endTime - currentTime) / (TRB.Data.spells[TRB.Data.snapshotData.channeledManaPotion.spellKey].duration / TRB.Data.spells[TRB.Data.snapshotData.channeledManaPotion.spellKey].ticks))
				TRB.Data.snapshotData.channeledManaPotion.mana = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells[TRB.Data.snapshotData.channeledManaPotion.spellKey].mana, true) + ((TRB.Data.snapshotData.channeledManaPotion.ticksRemaining - 1 + nextTickRemaining) * TRB.Data.snapshotData.manaRegen)
			end
		end
	end

	local function UpdateSymbolOfHope(forceCleanup)
		if TRB.Data.snapshotData.symbolOfHope.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or TRB.Data.snapshotData.symbolOfHope.endTime == nil or currentTime > TRB.Data.snapshotData.symbolOfHope.endTime or currentTime > TRB.Data.snapshotData.symbolOfHope.firstTickTime + TRB.Data.spells.symbolOfHope.duration or currentTime > TRB.Data.snapshotData.symbolOfHope.firstTickTime + (TRB.Data.spells.symbolOfHope.ticks * TRB.Data.snapshotData.symbolOfHope.tickRate) then
				TRB.Data.snapshotData.symbolOfHope.ticksRemaining = 0
				TRB.Data.snapshotData.symbolOfHope.tickRate = 0
				TRB.Data.snapshotData.symbolOfHope.previousTickTime = nil
				TRB.Data.snapshotData.symbolOfHope.firstTickTime = nil
				TRB.Data.snapshotData.symbolOfHope.endTime = nil
				TRB.Data.snapshotData.symbolOfHope.resourceRaw = 0
				TRB.Data.snapshotData.symbolOfHope.resourceFinal = 0
				TRB.Data.snapshotData.symbolOfHope.isActive = false
				TRB.Data.snapshotData.symbolOfHope.tickRateFound = false
			else
				TRB.Data.snapshotData.symbolOfHope.ticksRemaining = math.ceil((TRB.Data.snapshotData.symbolOfHope.endTime - currentTime) / TRB.Data.snapshotData.symbolOfHope.tickRate)
				local nextTickRemaining = TRB.Data.snapshotData.symbolOfHope.endTime - currentTime - math.floor((TRB.Data.snapshotData.symbolOfHope.endTime - currentTime) / TRB.Data.snapshotData.symbolOfHope.tickRate)
				TRB.Data.snapshotData.symbolOfHope.resourceRaw = 0

				for x = 1, TRB.Data.snapshotData.symbolOfHope.ticksRemaining do
					local casterRegen = 0
					if TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.symbolOfHope.id then
						if x == 1 then
							casterRegen = nextTickRemaining * TRB.Data.snapshotData.manaRegen
						else
							casterRegen = TRB.Data.snapshotData.manaRegen
						end
					end

					local estimatedMana = TRB.Data.character.maxResource + TRB.Data.snapshotData.symbolOfHope.resourceRaw + casterRegen - (TRB.Data.snapshotData.resource / TRB.Data.resourceFactor)
					local nextTick = TRB.Data.spells.symbolOfHope.manaPercent * math.max(0, math.min(TRB.Data.character.maxResource, estimatedMana))
					TRB.Data.snapshotData.symbolOfHope.resourceRaw = TRB.Data.snapshotData.symbolOfHope.resourceRaw + nextTick + casterRegen
				end

				--Revisit if we get mana modifiers added
				TRB.Data.snapshotData.symbolOfHope.resourceFinal = CalculateManaGain(TRB.Data.snapshotData.symbolOfHope.resourceRaw, false)
			end
		end
	end

	local function UpdateInnervate()
		local currentTime = GetTime()

		if TRB.Data.snapshotData.innervate.endTime ~= nil and currentTime > TRB.Data.snapshotData.innervate.endTime then
            TRB.Data.snapshotData.innervate.endTime = nil
            TRB.Data.snapshotData.innervate.duration = 0
			TRB.Data.snapshotData.innervate.remainingTime = 0
			TRB.Data.snapshotData.innervate.mana = 0
			TRB.Data.snapshotData.audio.innervateCue = false
		else
			TRB.Data.snapshotData.innervate.remainingTime = GetInnervateRemainingTime()
			TRB.Data.snapshotData.innervate.mana = TRB.Data.snapshotData.innervate.remainingTime * TRB.Data.snapshotData.manaRegen * (1-TRB.Data.snapshotData.innervate.modifier)
        end
	end

	local function UpdateManaTideTotem(forceCleanup)
		local currentTime = GetTime()

		if forceCleanup or (TRB.Data.snapshotData.manaTideTotem.endTime ~= nil and currentTime > TRB.Data.snapshotData.manaTideTotem.endTime) then
            TRB.Data.snapshotData.manaTideTotem.endTime = nil
            TRB.Data.snapshotData.manaTideTotem.duration = 0
			TRB.Data.snapshotData.manaTideTotem.remainingTime = 0
			TRB.Data.snapshotData.manaTideTotem.mana = 0
			TRB.Data.snapshotData.audio.manaTideTotemCue = false
		else
			TRB.Data.snapshotData.manaTideTotem.remainingTime = GetManaTideTotemRemainingTime()
			TRB.Data.snapshotData.manaTideTotem.mana = TRB.Data.snapshotData.manaTideTotem.remainingTime * (TRB.Data.snapshotData.manaRegen / 2) --Only half of this is considered bonus
        end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
	end

	local function UpdateSnapshot_Balance()
		UpdateSnapshot()

		local currentTime = GetTime()

		local rattleTheStarsModifier = TRB.Data.snapshotData.rattleTheStars.stacks * TRB.Data.spells.rattleTheStars.modifier
		local incarnationChosenOfEluneStarfallModifier = 0
		local incarnationChosenOfEluneStarsurgeModifier = 0

		if TRB.Data.spells.incarnationChosenOfElune.isActive and TRB.Functions.IsTalentActive(TRB.Data.spells.elunesGuidance) then
			incarnationChosenOfEluneStarfallModifier = TRB.Data.spells.elunesGuidance.modifierStarfall
			incarnationChosenOfEluneStarsurgeModifier = TRB.Data.spells.elunesGuidance.modifierStarsurge
		end

		TRB.Data.character.starsurgeThreshold = (TRB.Data.spells.starsurge.astralPower + incarnationChosenOfEluneStarsurgeModifier) * (1+rattleTheStarsModifier)
		TRB.Data.character.starfallThreshold = (TRB.Data.spells.starfall.astralPower + incarnationChosenOfEluneStarfallModifier) * (1+rattleTheStarsModifier)

		TRB.Data.spells.moonkinForm.isActive = select(10, TRB.Functions.FindBuffById(TRB.Data.spells.moonkinForm.id))

        UpdateFuryOfElune()
        UpdateSunderedFirmament()
		GetCurrentMoonSpell()

		_, _, _, _, _, TRB.Data.snapshotData.celestialAlignment.endTime, _, _, _, TRB.Data.snapshotData.celestialAlignment.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.celestialAlignment.id)
		_, _, _, _, _, TRB.Data.snapshotData.incarnationChosenOfElune.endTime, _, _, _, TRB.Data.snapshotData.incarnationChosenOfElune.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.incarnationChosenOfElune.id)
		_, _, _, _, _, TRB.Data.snapshotData.eclipseSolar.endTime, _, _, _, TRB.Data.snapshotData.eclipseSolar.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.eclipseSolar.id)
		_, _, _, _, _, TRB.Data.snapshotData.eclipseLunar.endTime, _, _, _, TRB.Data.snapshotData.eclipseLunar.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.eclipseLunar.id)

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfire then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.sunfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfire then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.moonfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlare then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.stellarFlare.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].stellarFlareRemaining = expiration - currentTime
				end
			end
		end

---@diagnostic disable-next-line: redundant-parameter, cast-local-type
		TRB.Data.snapshotData.newMoon.charges, TRB.Data.snapshotData.newMoon.maxCharges, TRB.Data.snapshotData.newMoon.startTime, TRB.Data.snapshotData.newMoon.duration, _ = GetSpellCharges(TRB.Data.spells.newMoon.id)

		if TRB.Functions.IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
			TRB.Data.snapshotData.primordialArcanicPulsar.currentAstralPower = select(16, TRB.Functions.FindBuffById(TRB.Data.spells.primordialArcanicPulsar.id))
		end
	end

	local function UpdateSnapshot_Feral()
		UpdateSnapshot()
		local currentTime = GetTime()
		
		if TRB.Functions.IsTalentActive(TRB.Data.spells.incarnationAvatarOfAshamane) then
			-- Incarnation: King of the Jungle doesn't show up in-game as a combat log event. Check for it manually instead.
			local _, _, _, _, incDuration, incEndTime, _, _, _, incSpellId = TRB.Functions.FindBuffById(TRB.Data.spells.incarnationAvatarOfAshamane.id)
			if incDuration ~= nil then			
				TRB.Data.spells.incarnationAvatarOfAshamane.isActive = true
				TRB.Data.snapshotData.incarnationAvatarOfAshamane.duration = incDuration
				TRB.Data.snapshotData.incarnationAvatarOfAshamane.endTime = incEndTime
				TRB.Data.snapshotData.incarnationAvatarOfAshamane.spellId = incSpellId
			else
				TRB.Data.spells.incarnationAvatarOfAshamane.isActive = false
				TRB.Data.snapshotData.incarnationAvatarOfAshamane.spellId = nil
				TRB.Data.snapshotData.incarnationAvatarOfAshamane.duration = 0
				TRB.Data.snapshotData.incarnationAvatarOfAshamane.endTime = nil
			end
		end

		TRB.Data.snapshotData.snapshots.rip = GetCurrentSnapshot(TRB.Data.spells.rip.bonuses)
		TRB.Data.snapshotData.snapshots.rake = GetCurrentSnapshot(TRB.Data.spells.rake.bonuses)
		TRB.Data.snapshotData.snapshots.thrash = GetCurrentSnapshot(TRB.Data.spells.thrash.bonuses)
		TRB.Data.snapshotData.snapshots.moonfire = GetCurrentSnapshot(TRB.Data.spells.moonfire.bonuses)

        if TRB.Data.snapshotData.maim.startTime ~= nil and currentTime > (TRB.Data.snapshotData.maim.startTime + TRB.Data.snapshotData.maim.duration) then
            TRB.Data.snapshotData.maim.startTime = nil
            TRB.Data.snapshotData.maim.duration = 0
        end

        if TRB.Data.snapshotData.feralFrenzy.startTime ~= nil and currentTime > (TRB.Data.snapshotData.feralFrenzy.startTime + TRB.Data.snapshotData.feralFrenzy.duration) then
            TRB.Data.snapshotData.feralFrenzy.startTime = nil
            TRB.Data.snapshotData.feralFrenzy.duration = 0
        end

---@diagnostic disable-next-line: redundant-parameter
		_, _, TRB.Data.snapshotData.clearcasting.stacks, _, TRB.Data.snapshotData.clearcasting.duration, TRB.Data.snapshotData.clearcasting.endTime, _, _, _, TRB.Data.snapshotData.clearcasting.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.clearcasting.id)
		TRB.Data.snapshotData.clearcasting.remainingTime = GetClearcastingRemainingTime()
		
		if TRB.Data.snapshotData.clearcasting.endTimeLeeway ~= nil and TRB.Data.snapshotData.clearcasting.endTimeLeeway < currentTime then
			TRB.Data.snapshotData.clearcasting.endTimeLeeway = nil
		end

		if TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshotData.brutalSlash.charges, TRB.Data.snapshotData.brutalSlash.maxCharges, TRB.Data.snapshotData.brutalSlash.startTime, TRB.Data.snapshotData.brutalSlash.duration, _ = GetSpellCharges(TRB.Data.spells.brutalSlash.id)
		end
		
		if TRB.Functions.IsTalentActive(TRB.Data.spells.bloodtalons) then
---@diagnostic disable-next-line: redundant-parameter
			_, _, TRB.Data.snapshotData.bloodtalons.stacks, _, TRB.Data.snapshotData.bloodtalons.duration, TRB.Data.snapshotData.bloodtalons.endTime, _, _, _, TRB.Data.snapshotData.bloodtalons.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.bloodtalons.id)
			TRB.Data.snapshotData.bloodtalons.remainingTime = GetBloodtalonsRemainingTime()
			
			if TRB.Data.snapshotData.bloodtalons.endTimeLeeway ~= nil and TRB.Data.snapshotData.bloodtalons.endTimeLeeway < currentTime then
				TRB.Data.snapshotData.bloodtalons.endTimeLeeway = nil
			end
		end

		if TRB.Data.snapshotData.suddenAmbush.endTimeLeeway ~= nil and TRB.Data.snapshotData.suddenAmbush.endTimeLeeway < currentTime then
			TRB.Data.snapshotData.suddenAmbush.endTimeLeeway = nil
		end

---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshotData.tigersFury.cooldown.startTime, TRB.Data.snapshotData.tigersFury.cooldown.duration, _, _ = GetSpellCooldown(TRB.Data.spells.tigersFury.id)
		
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rip then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.rip.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ripRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rake then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.rake.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rakeRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrash then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.thrash.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].thrashRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfire then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.moonfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Restoration()
		UpdateSnapshot()
		UpdateSymbolOfHope()
		UpdateChanneledManaPotion()
		UpdateInnervate()
		UpdateManaTideTotem()

		local currentTime = GetTime()
		local _

		if TRB.Data.snapshotData.innervate.startTime ~= nil and currentTime > (TRB.Data.snapshotData.innervate.startTime + TRB.Data.snapshotData.innervate.duration) then
            TRB.Data.snapshotData.innervate.startTime = nil
            TRB.Data.snapshotData.innervate.duration = 0
			TRB.Data.snapshotData.innervate.remainingTime = 0
		else
			TRB.Data.snapshotData.innervate.remainingTime = GetInnervateRemainingTime()
        end

		-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
		TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration, _ = GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
		if TRB.Data.snapshotData.potion.startTime > 0 and TRB.Data.snapshotData.potion.duration > 0 then
			TRB.Data.snapshotData.potion.onCooldown = true
		else
			TRB.Data.snapshotData.potion.onCooldown = false
		end

		TRB.Data.snapshotData.conjuredChillglobe.startTime, TRB.Data.snapshotData.conjuredChillglobe.duration, _ = GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
		if TRB.Data.snapshotData.conjuredChillglobe.startTime > 0 and TRB.Data.snapshotData.conjuredChillglobe.duration > 0 then
			TRB.Data.snapshotData.conjuredChillglobe.onCooldown = true
		else
			TRB.Data.snapshotData.conjuredChillglobe.onCooldown = false
		end
		
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfire then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.sunfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].sunfireRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfire then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.moonfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].moonfireRemaining = expiration - currentTime
				end
			end
		end

		TRB.Data.snapshotData.clearcasting.remainingTime = GetClearcastingRemainingTime()
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or GetSpecialization() ~= 1 or (not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.balance.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.balance.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.balance.displayBar.notZeroShow and
							((not TRB.Functions.IsTalentActive(TRB.Data.spells.naturesBalance) and TRB.Data.snapshotData.resource == 0) or
							(TRB.Functions.IsTalentActive(TRB.Data.spells.naturesBalance) and (TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) >= 50))
						)
					)
				) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
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
						(TRB.Data.settings.druid.feral.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.druid.feral.displayBar.neverShow == true then
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
						(TRB.Data.settings.druid.restoration.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.druid.restoration.displayBar.neverShow == true then
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
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.druid

		if specId == 1 then
			local specSettings = classSettings.balance
			UpdateSnapshot_Balance()

			TRB.Functions.RepositionBarForPRD(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local affectingCombat = UnitAffectingCombat("player")
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentResource = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local flashBar = false

					if specSettings.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.borderOvercap, true))

						if specSettings.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, currentResource)

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentResource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, castingBarValue)

					if specSettings.bar.showPassive then
						passiveBarValue = currentResource + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.furyOfElune.astralPower + TRB.Data.snapshotData.sunderedFirmament.astralPower

						if TRB.Functions.IsTalentActive(TRB.Data.spells.naturesBalance) then
							if affectingCombat then
								passiveBarValue = passiveBarValue + TRB.Data.spells.naturesBalance.astralPower
							elseif currentResource < 50 then
								passiveBarValue = passiveBarValue + TRB.Data.spells.naturesBalance.outOfCombatAstralPower
							end
						end

						if TRB.Functions.IsTalentActive(TRB.Data.spells.naturesBalance) and (affectingCombat or (not affectingCombat and currentResource < 50)) then

						else
							passiveBarValue = currentResource + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.furyOfElune.astralPower + TRB.Data.snapshotData.sunderedFirmament.astralPower
						end
					else
						passiveBarValue = castingBarValue
					end

					TRB.Functions.SetBarCurrentValue(specSettings, passiveFrame, passiveBarValue)

					if specSettings.thresholds.starsurge.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.starsurge) and TRB.Data.character.starsurgeThreshold < TRB.Data.character.maxResource then
						resourceFrame.thresholds[1]:Show()
						TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[1], resourceFrame, specSettings.thresholds.width, TRB.Data.character.starsurgeThreshold, TRB.Data.character.maxResource)

						if currentResource >= TRB.Data.character.starsurgeThreshold or TRB.Data.spells.starweaversWeft.isActive then
		---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))
		---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))

							if TRB.Data.spells.starweaversWeft.isActive and specSettings.audio.starweaversReady.enabled and TRB.Data.snapshotData.audio.playedstarweaverCue == false then
								TRB.Data.snapshotData.audio.playedstarweaverCue = true
								TRB.Data.snapshotData.audio.playedSfCue = true
		---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
							elseif specSettings.audio.ssReady.enabled and TRB.Data.snapshotData.audio.playedSsCue == false then
								TRB.Data.snapshotData.audio.playedSsCue = true
		---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(specSettings.audio.ssReady.sound, coreSettings.audio.channel.channel)
							end
						else
		---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
		---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
							TRB.Data.snapshotData.audio.playedSsCue = false
							TRB.Data.snapshotData.audio.playedstarweaverCue = false
						end
					else
						resourceFrame.thresholds[1]:Hide()
					end

					if specSettings.thresholds.starsurge2.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.starsurge) and
						(not specSettings.thresholds.starsurgeThresholdOnlyOverShow or currentResource > TRB.Data.character.starsurgeThreshold) and
						(TRB.Data.character.starsurgeThreshold * 2) < TRB.Data.character.maxResource then
						resourceFrame.thresholds[2]:Show()
						TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[2], resourceFrame, specSettings.thresholds.width, TRB.Data.character.starsurgeThreshold*2, TRB.Data.character.maxResource)

						if currentResource >= TRB.Data.character.starsurgeThreshold * 2 then
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))
						else
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
						end
					else
						resourceFrame.thresholds[2]:Hide()
					end

					if specSettings.thresholds.starsurge3.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.starsurge) and 
						(not specSettings.thresholds.starsurgeThresholdOnlyOverShow or currentResource > TRB.Data.character.starsurgeThreshold*2) and
						(TRB.Data.character.starsurgeThreshold * 3) < TRB.Data.character.maxResource then
						resourceFrame.thresholds[3]:Show()
						TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[3], resourceFrame, specSettings.thresholds.width, TRB.Data.character.starsurgeThreshold*3, TRB.Data.character.maxResource)

						if currentResource >= TRB.Data.character.starsurgeThreshold * 3 then
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))
						else
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
	---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
						end
					else
						resourceFrame.thresholds[3]:Hide()
					end

					if specSettings.thresholds.starfall.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.starfall) and TRB.Data.character.starfallThreshold < TRB.Data.character.maxResource then
						resourceFrame.thresholds[4]:Show()
						TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[4], resourceFrame, specSettings.thresholds.width, TRB.Data.character.starfallThreshold, TRB.Data.character.maxResource)

						if currentResource >= TRB.Data.character.starfallThreshold or TRB.Data.spells.starweaversWarp.isActive then
							if TRB.Data.spells.starfall.isActive and (TRB.Data.snapshotData.starfall.endTime - currentTime) > (TRB.Data.character.pandemicModifier * TRB.Data.spells.starfall.pandemicTime) then
		---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.starfallPandemic, true))
		---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.starfallPandemic, true))
							else
		---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))
		---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.over, true))
							end

							if TRB.Data.spells.starweaversWarp.isActive and specSettings.audio.starweaversReady.enabled and TRB.Data.snapshotData.audio.playedstarweaverCue == false then
								TRB.Data.snapshotData.audio.playedstarweaverCue = true
								TRB.Data.snapshotData.audio.playedSfCue = true
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
							elseif specSettings.audio.sfReady.enabled and TRB.Data.snapshotData.audio.playedSfCue == false then
								TRB.Data.snapshotData.audio.playedSfCue = true
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(specSettings.audio.sfReady.sound, coreSettings.audio.channel.channel)
							end
						else
		---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
		---@diagnostic disable-next-line: undefined-field
							resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.under, true))
							TRB.Data.snapshotData.audio.playedSfCue = false
							TRB.Data.snapshotData.audio.playedstarweaverCue = false
						end
					else
						resourceFrame.thresholds[4]:Hide()
					end
					
					if specSettings.colors.bar.flashSsEnabled and currentResource >= TRB.Data.character.starsurgeThreshold then
						flashBar = true
					end

					local barColor = specSettings.colors.bar.base

					if not TRB.Data.spells.moonkinForm.isActive and affectingCombat then
						barColor = specSettings.colors.bar.moonkinFormMissing
						if specSettings.colors.bar.flashEnabled then
							flashBar = true
						end
					elseif TRB.Data.spells.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
						local timeThreshold = 0
						local useEndOfEclipseColor = false

						if specSettings.endOfEclipse.enabled and (not specSettings.endOfEclipse.celestialAlignmentOnly or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive) then
							useEndOfEclipseColor = true
							if specSettings.endOfEclipse.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfEclipse.gcdsMax
							elseif specSettings.endOfEclipse.mode == "time" then
								timeThreshold = specSettings.endOfEclipse.timeMax
							end
						end

						if useEndOfEclipseColor and GetEclipseRemainingTime() <= timeThreshold then
							barColor = specSettings.colors.bar.eclipse1GCD
						else
							if TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive or (TRB.Data.spells.eclipseSolar.isActive and TRB.Data.spells.eclipseLunar.isActive) then
								barColor = specSettings.colors.bar.celestial
							elseif TRB.Data.spells.eclipseSolar.isActive then
								barColor = specSettings.colors.bar.solar
							else
								barColor = specSettings.colors.bar.lunar
							end
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
					barContainerFrame:SetAlpha(1.0)

					if flashBar then
						TRB.Functions.PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					end
				end
			end
			TRB.Functions.UpdateResourceBar(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.feral
			UpdateSnapshot_Feral()

			TRB.Functions.RepositionBarForPRD(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if specSettings.generation.enabled then
							if specSettings.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.energyRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.energyRegen * ((specSettings.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true, spell.relentlessPredator)
							TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							local overrideOk = true

							if spell.hasSnapshot and specSettings.thresholds.bleedColors then
								showThreshold = true
								overrideOk = false

								if UnitIsDeadOrGhost("target") or not UnitCanAttack("player", "target") or TRB.Data.snapshotData.targetData.currentTargetGuid == nil then
									thresholdColor = specSettings.colors.text.dots.same
									frameLevel = TRB.Data.constants.frameLevels.thresholdBleedSame
								elseif TRB.Data.snapshotData.targetData.targets == nil or TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] == nil then
									thresholdColor = specSettings.colors.text.dots.down
									frameLevel = TRB.Data.constants.frameLevels.thresholdBleedDownOrWorse
								else
									local snapshotValue = (TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid][spell.settingKey .. "Snapshot"] or 1) / TRB.Data.snapshotData.snapshots[spell.settingKey]
									local bleedUp = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid][spell.settingKey]
									
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

								if spell.id == TRB.Data.spells.moonfire.id and not TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) then
									showThreshold = false
								end
							elseif spell.isClearcasting and TRB.Data.snapshotData.clearcasting.stacks ~= nil and TRB.Data.snapshotData.clearcasting.stacks > 0 then
								if spell.id == TRB.Data.spells.brutalSlash.id then
									if not TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									elseif TRB.Data.snapshotData.brutalSlash.charges > 0 then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									end
								elseif spell.id == TRB.Data.spells.swipe.id then
									if TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									else
										thresholdColor = specSettings.colors.threshold.over
									end
								else
									thresholdColor = specSettings.colors.threshold.over
								end
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.ferociousBite.id and spell.settingKey == "ferociousBite" then
									TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, math.min(math.max(-energyAmount, TRB.Data.snapshotData.resource), -CalculateAbilityResourceValue(TRB.Data.spells.ferociousBite.energyMax, true, true)), TRB.Data.character.maxResource)
									
									if TRB.Data.snapshotData.resource >= -energyAmount or TRB.Data.spells.apexPredatorsCraving.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.ferociousBiteMinimum.id and spell.settingKey == "ferociousBiteMinimum" then
									TRB.Functions.RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)
									
									if TRB.Data.snapshotData.resource >= -energyAmount or TRB.Data.spells.apexPredatorsCraving.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.ferociousBiteMaximum.id and spell.settingKey == "ferociousBiteMaximum" then
									if TRB.Data.snapshotData.resource >= -energyAmount or TRB.Data.spells.apexPredatorsCraving.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.moonfire.id then
									if not TRB.Functions.IsTalentActive(TRB.Data.spells.lunarInspiration) then
										showThreshold = false
									elseif TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.swipe.id then
									if TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									elseif TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.brutalSlash.id then
									if not TRB.Functions.IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									elseif TRB.Data.snapshotData.brutalSlash.charges == 0 then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.bloodtalons.id then
									--TODO: How much energy is required to start this? Then do we move it?
								end
							elseif spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -energyAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							if overrideOk == true and spell.comboPoints == true and TRB.Data.snapshotData.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshotData[spell.settingKey], specSettings.thresholds)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base
					
					if GetClearcastingRemainingTime() > 0 then
						barColor = specSettings.colors.bar.clearcasting
					end

					if (TRB.Data.snapshotData.resource2 == 5 and TRB.Data.snapshotData.resource >= -CalculateAbilityResourceValue(TRB.Data.spells.ferociousBiteMaximum.energy, true, true)) then
						barColor = specSettings.colors.bar.maxBite
					end

					if TRB.Data.spells.apexPredatorsCraving.isActive == true then
						barColor = specSettings.colors.bar.apexPredator
					end

					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.GetRGBAFromString(specSettings.colors.comboPoints.background, true)
					
					for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = specSettings.colors.comboPoints.border
						local cpColor = specSettings.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

						if TRB.Data.snapshotData.resource2 >= x then
							TRB.Functions.SetBarCurrentValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (specSettings.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = specSettings.colors.comboPoints.penultimate
							elseif (specSettings.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
								cpColor = specSettings.colors.comboPoints.final
							end
						else
							TRB.Functions.SetBarCurrentValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			TRB.Functions.UpdateResourceBar(specSettings, refreshText)
		elseif specId == 4 then
			local specSettings = classSettings.restoration
			UpdateSnapshot_Restoration()
			TRB.Functions.RepositionBarForPRD(specSettings, TRB.Frames.barContainerFrame)
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()
		
				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border
		
					if TRB.Data.spells.innervate.isActive then
						if specSettings.colors.bar.innervateBorderChange then
							barBorderColor = specSettings.colors.bar.innervate
						end
		
						if specSettings.audio.innervate.enabled and TRB.Data.snapshotData.audio.innervateCue == false then
							TRB.Data.snapshotData.audio.innervateCue = true
		---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
						end
					end
		
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))
		
					TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, currentMana)
		
					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = currentMana + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentMana
					end
		
					TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, castingBarValue)
		
					local potionCooldownThreshold = 0
					local potionThresholdColor = specSettings.colors.threshold.over
					if TRB.Data.snapshotData.potion.onCooldown then
						if specSettings.thresholds.potionCooldown.enabled then
							if specSettings.thresholds.potionCooldown.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								potionCooldownThreshold = gcd * specSettings.thresholds.potionCooldown.gcdsMax
							elseif specSettings.thresholds.potionCooldown.mode == "time" then
								potionCooldownThreshold = specSettings.thresholds.potionCooldown.timeMax
							end
						end
					end
		
					if not TRB.Data.snapshotData.potion.onCooldown or (potionCooldownThreshold > math.abs(TRB.Data.snapshotData.potion.startTime + TRB.Data.snapshotData.potion.duration - currentTime))then
						if TRB.Data.snapshotData.potion.onCooldown then
							potionThresholdColor = specSettings.colors.threshold.unusable
						end
						local ampr1Total = CalculateManaGain(TRB.Data.character.items.potions.aeratedManaPotionRank1.mana, true)
						if specSettings.thresholds.aeratedManaPotionRank1.enabled and (castingBarValue + ampr1Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.resourceFrame.thresholds[1], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr1Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[1]:Show()
								
							if specSettings.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[1].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[1].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[1]:Hide()
						end
						
						local ampr2Total = CalculateManaGain(TRB.Data.character.items.potions.aeratedManaPotionRank2.mana, true)
						if specSettings.thresholds.aeratedManaPotionRank2.enabled and (castingBarValue + ampr2Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.resourceFrame.thresholds[2], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr2Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[2]:Show()
								
							if specSettings.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[2].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[2].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[2]:Hide()
						end
						
						local ampr3Total = CalculateManaGain(TRB.Data.character.items.potions.aeratedManaPotionRank3.mana, true)
						if specSettings.thresholds.aeratedManaPotionRank3.enabled and (castingBarValue + ampr3Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.resourceFrame.thresholds[3], resourceFrame, specSettings.thresholds.width, (castingBarValue + ampr3Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[3]:Show()
								
							if specSettings.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[3].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[3].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[3]:Hide()
						end

						local poffr1Total = CalculateManaGain(TRB.Data.character.items.potions.potionOfFrozenFocusRank1.mana, true)
						if specSettings.thresholds.potionOfFrozenFocusRank1.enabled and (castingBarValue + poffr1Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.resourceFrame.thresholds[4], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr1Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[4]:Show()
								
							if specSettings.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[4].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[4].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[4]:Hide()
						end

						local poffr2Total = CalculateManaGain(TRB.Data.character.items.potions.potionOfFrozenFocusRank2.mana, true)
						if specSettings.thresholds.potionOfFrozenFocusRank2.enabled and (castingBarValue + poffr2Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.resourceFrame.thresholds[5], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr2Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[5].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[5].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[5]:Show()
								
							if specSettings.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[5].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[5].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[5]:Hide()
						end

						local poffr3Total = CalculateManaGain(TRB.Data.character.items.potions.potionOfFrozenFocusRank3.mana, true)
						if specSettings.thresholds.potionOfFrozenFocusRank3.enabled and (castingBarValue + poffr3Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.resourceFrame.thresholds[6], resourceFrame, specSettings.thresholds.width, (castingBarValue + poffr3Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[6].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[6].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[6]:Show()
								
							if specSettings.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[6].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[6].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[6]:Hide()
						end
					else
						TRB.Frames.resourceFrame.thresholds[1]:Hide()
						TRB.Frames.resourceFrame.thresholds[2]:Hide()
						TRB.Frames.resourceFrame.thresholds[3]:Hide()
						TRB.Frames.resourceFrame.thresholds[4]:Hide()
						TRB.Frames.resourceFrame.thresholds[5]:Hide()
						TRB.Frames.resourceFrame.thresholds[6]:Hide()
					end
					
					if TRB.Data.character.items.conjuredChillglobe.isEquipped and (currentMana / TRB.Data.character.maxResource) < TRB.Data.character.items.conjuredChillglobe.manaThresholdPercent then
						local conjuredChillglobeTotal = CalculateManaGain(TRB.Data.character.items.conjuredChillglobe[TRB.Data.character.items.conjuredChillglobe.equippedVersion].mana, true)
						if specSettings.thresholds.conjuredChillglobe.enabled and (castingBarValue + conjuredChillglobeTotal) < TRB.Data.character.maxResource then
							if TRB.Data.snapshotData.conjuredChillglobe.onCooldown then
								potionThresholdColor = specSettings.colors.threshold.unusable
							end
							TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.resourceFrame.thresholds[7], resourceFrame, specSettings.thresholds.width, (castingBarValue + conjuredChillglobeTotal), TRB.Data.character.maxResource)
	---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[7].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
	---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[7].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[7]:Show()
								
							if specSettings.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[7].icon.cooldown:SetCooldown(TRB.Data.snapshotData.conjuredChillglobe.startTime, TRB.Data.snapshotData.conjuredChillglobe.duration)
							else
								TRB.Frames.resourceFrame.thresholds[7].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[7]:Hide()
						end
					else
						TRB.Frames.resourceFrame.thresholds[7]:Hide()
					end
		
					local passiveValue = 0
					if specSettings.bar.showPassive then
						if TRB.Data.snapshotData.channeledManaPotion.isActive then
							passiveValue = passiveValue + TRB.Data.snapshotData.channeledManaPotion.mana
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[1]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[1]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end
		
						if TRB.Data.snapshotData.innervate.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.innervate.mana
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[3], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[2]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[2]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[2]:Hide()
						end
		
						if TRB.Data.snapshotData.symbolOfHope.resourceFinal > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.symbolOfHope.resourceFinal
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[3]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[3]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[3]:Hide()
						end
		
						if TRB.Data.snapshotData.manaTideTotem.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.manaTideTotem.mana
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[4]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[4]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[4]:Hide()
						end
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						TRB.Frames.passiveFrame.thresholds[2]:Hide()
						TRB.Frames.passiveFrame.thresholds[3]:Hide()
						TRB.Frames.passiveFrame.thresholds[4]:Hide()
					end
		
					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						TRB.Functions.SetBarCurrentValue(specSettings, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
		
					local resourceBarColor = specSettings.colors.bar.base
							
					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat and GetEfflorescenceRemainingTime() == 0 then
						resourceBarColor = specSettings.colors.bar.noEfflorescence
					elseif GetClearcastingRemainingTime() > 0 then
						resourceBarColor = specSettings.colors.bar.clearcasting
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(resourceBarColor, true))
				end
		
				TRB.Functions.UpdateResourceBar(specSettings, refreshText)
			end
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 and specId ~= 4 then
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

			if destGUID == TRB.Data.character.guid then
				if specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
					if type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.symbolOfHope.tickId then
						TRB.Data.snapshotData.symbolOfHope.isActive = true
						if TRB.Data.snapshotData.symbolOfHope.firstTickTime == nil then
							TRB.Data.snapshotData.symbolOfHope.firstTickTime = currentTime
							TRB.Data.snapshotData.symbolOfHope.previousTickTime = currentTime
							TRB.Data.snapshotData.symbolOfHope.ticksRemaining = TRB.Data.spells.symbolOfHope.ticks
							TRB.Data.snapshotData.symbolOfHope.tickRate = (TRB.Data.spells.symbolOfHope.duration / TRB.Data.spells.symbolOfHope.ticks)
							TRB.Data.snapshotData.symbolOfHope.endTime = currentTime + TRB.Data.spells.symbolOfHope.duration
						else
							if TRB.Data.snapshotData.symbolOfHope.ticksRemaining >= 1 then
								if sourceGUID ~= TRB.Data.character.guid then
									if not TRB.Data.snapshotData.symbolOfHope.tickRateFound then
										TRB.Data.snapshotData.symbolOfHope.tickRate = currentTime - TRB.Data.snapshotData.symbolOfHope.previousTickTime
										TRB.Data.snapshotData.symbolOfHope.tickRateFound = true
										TRB.Data.snapshotData.symbolOfHope.endTime = currentTime + (TRB.Data.snapshotData.symbolOfHope.tickRate * (TRB.Data.snapshotData.symbolOfHope.ticksRemaining - 1))
									end

									if TRB.Data.snapshotData.symbolOfHope.tickRate > (1.75 * 1.5) then -- Assume if its taken this long for a tick to happen, the rate is really half this and one was missed
										TRB.Data.snapshotData.symbolOfHope.tickRate = TRB.Data.snapshotData.symbolOfHope.tickRate / 2
										TRB.Data.snapshotData.symbolOfHope.endTime = currentTime + (TRB.Data.snapshotData.symbolOfHope.tickRate * (TRB.Data.snapshotData.symbolOfHope.ticksRemaining - 2))
										TRB.Data.snapshotData.symbolOfHope.tickRateFound = false
									end
								end
							end
							TRB.Data.snapshotData.symbolOfHope.previousTickTime = currentTime
						end
						TRB.Data.snapshotData.symbolOfHope.resourceRaw = TRB.Data.snapshotData.symbolOfHope.ticksRemaining * TRB.Data.spells.symbolOfHope.manaPercent * TRB.Data.character.maxResource
						TRB.Data.snapshotData.symbolOfHope.resourceFinal = CalculateManaGain(TRB.Data.snapshotData.symbolOfHope.resourceRaw, false)
					elseif spellId == TRB.Data.spells.innervate.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							local modifier = 0
							TRB.Data.spells.innervate.isActive = true
							_, _, _, _, TRB.Data.snapshotData.innervate.duration, TRB.Data.snapshotData.innervate.endTime, _, _, _, TRB.Data.snapshotData.innervate.spellId, _, _, _, _, _, modifier  = TRB.Functions.FindBuffById(TRB.Data.spells.innervate.id)
							TRB.Data.snapshotData.innervate.modifier = (100 + modifier) / 100
							TRB.Data.snapshotData.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.innervate.isActive = false
							TRB.Data.snapshotData.innervate.spellId = nil
							TRB.Data.snapshotData.innervate.duration = 0
							TRB.Data.snapshotData.innervate.endTime = nil
							TRB.Data.snapshotData.innervate.modifier = 1
							TRB.Data.snapshotData.audio.innervateCue = false
						end
					elseif spellId == TRB.Data.spells.manaTideTotem.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.manaTideTotem.isActive = true
							TRB.Data.snapshotData.manaTideTotem.duration = TRB.Data.spells.manaTideTotem.duration
							TRB.Data.snapshotData.manaTideTotem.endTime = TRB.Data.spells.manaTideTotem.duration + currentTime
							TRB.Data.snapshotData.audio.manaTideTotemCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.manaTideTotem.isActive = false
							TRB.Data.snapshotData.manaTideTotem.spellId = nil
							TRB.Data.snapshotData.manaTideTotem.duration = 0
							TRB.Data.snapshotData.manaTideTotem.endTime = nil
							TRB.Data.snapshotData.audio.manaTideTotemCue = false
						end
					end
				end
			end

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "balance" then
					if spellId == TRB.Data.spells.sunfire.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Sunfire Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].sunfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.sunfire = TRB.Data.snapshotData.targetData.sunfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].sunfire = false
								TRB.Data.snapshotData.targetData.targets[destGUID].sunfireRemaining = 0
								TRB.Data.snapshotData.targetData.sunfire = TRB.Data.snapshotData.targetData.sunfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.moonfire.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = false
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfireRemaining = 0
								TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.stellarFlare.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Stellar Flare Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].stellarFlare = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.stellarFlare = TRB.Data.snapshotData.targetData.stellarFlare + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].stellarFlare = false
								TRB.Data.snapshotData.targetData.targets[destGUID].stellarFlareRemaining = 0
								TRB.Data.snapshotData.targetData.stellarFlare = TRB.Data.snapshotData.targetData.stellarFlare - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.furyOfElune.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Fury of Elune
							TRB.Data.snapshotData.furyOfElune.isActive = true
							TRB.Data.snapshotData.furyOfElune.ticksRemaining = TRB.Data.spells.furyOfElune.ticks
							TRB.Data.snapshotData.furyOfElune.astralPower = TRB.Data.snapshotData.furyOfElune.ticksRemaining * TRB.Data.spells.furyOfElune.astralPower
							TRB.Data.snapshotData.furyOfElune.startTime = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.furyOfElune.isActive = false
							TRB.Data.snapshotData.furyOfElune.ticksRemaining = 0
							TRB.Data.snapshotData.furyOfElune.astralPower = 0
							TRB.Data.snapshotData.furyOfElune.startTime = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.furyOfElune.ticksRemaining = TRB.Data.snapshotData.furyOfElune.ticksRemaining - 1
							TRB.Data.snapshotData.furyOfElune.astralPower = TRB.Data.snapshotData.furyOfElune.ticksRemaining * TRB.Data.spells.furyOfElune.astralPower
						end
					elseif spellId == TRB.Data.spells.sunderedFirmament.buffId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Sundered Firmament
							TRB.Data.snapshotData.sunderedFirmament.isActive = true
							TRB.Data.snapshotData.sunderedFirmament.ticksRemaining = TRB.Data.spells.sunderedFirmament.ticks
							TRB.Data.snapshotData.sunderedFirmament.astralPower = TRB.Data.snapshotData.sunderedFirmament.ticksRemaining * TRB.Data.spells.sunderedFirmament.astralPower
							TRB.Data.snapshotData.sunderedFirmament.startTime = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.sunderedFirmament.isActive = false
							TRB.Data.snapshotData.sunderedFirmament.ticksRemaining = 0
							TRB.Data.snapshotData.sunderedFirmament.astralPower = 0
							TRB.Data.snapshotData.sunderedFirmament.startTime = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.sunderedFirmament.ticksRemaining = TRB.Data.snapshotData.sunderedFirmament.ticksRemaining - 1
							TRB.Data.snapshotData.sunderedFirmament.astralPower = TRB.Data.snapshotData.sunderedFirmament.ticksRemaining * TRB.Data.spells.sunderedFirmament.astralPower
						end
					elseif spellId == TRB.Data.spells.eclipseSolar.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.eclipseSolar.isActive = true
							_, _, _, _, _, TRB.Data.snapshotData.eclipseSolar.endTime, _, _, _, TRB.Data.snapshotData.eclipseSolar.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.eclipseSolar.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.eclipseSolar.isActive = false
							TRB.Data.snapshotData.eclipseSolar.spellId = nil
							TRB.Data.snapshotData.eclipseSolar.endTime = nil
						end
					elseif spellId == TRB.Data.spells.eclipseLunar.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.eclipseLunar.isActive = true
							_, _, _, _, _, TRB.Data.snapshotData.eclipseLunar.endTime, _, _, _, TRB.Data.snapshotData.eclipseLunar.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.eclipseLunar.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.eclipseLunar.isActive = false
							TRB.Data.snapshotData.eclipseLunar.spellId = nil
							TRB.Data.snapshotData.eclipseLunar.endTime = nil
						end
					elseif spellId == TRB.Data.spells.celestialAlignment.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.celestialAlignment.isActive = true
							_, _, _, _, _, TRB.Data.snapshotData.celestialAlignment.endTime, _, _, _, TRB.Data.snapshotData.celestialAlignment.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.celestialAlignment.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.celestialAlignment.isActive = false
							TRB.Data.snapshotData.celestialAlignment.spellId = nil
							TRB.Data.snapshotData.celestialAlignment.endTime = nil
						end
					elseif spellId == TRB.Data.spells.incarnationChosenOfElune.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.incarnationChosenOfElune.isActive = true
							_, _, _, _, _, TRB.Data.snapshotData.incarnationChosenOfElune.endTime, _, _, _, TRB.Data.snapshotData.incarnationChosenOfElune.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.incarnationChosenOfElune.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.incarnationChosenOfElune.isActive = false
							TRB.Data.snapshotData.incarnationChosenOfElune.spellId = nil
							TRB.Data.snapshotData.incarnationChosenOfElune.endTime = nil
						end
					elseif spellId == TRB.Data.spells.starfall.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.starfall.isActive = true
							_, _, _, _, TRB.Data.snapshotData.starfall.duration, TRB.Data.snapshotData.starfall.endTime, _, _, _, TRB.Data.snapshotData.starfall.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.starfall.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.starfall.isActive = false
							TRB.Data.snapshotData.starfall.spellId = nil
							TRB.Data.snapshotData.starfall.duration = 0
							TRB.Data.snapshotData.starfall.endTime = nil
						end
					elseif spellId == TRB.Data.spells.starweaversWarp.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.starweaversWarp.isActive = true
							_, _, _, _, TRB.Data.snapshotData.starweaversWarp.duration, TRB.Data.snapshotData.starweaversWarp.endTime, _, _, _, TRB.Data.snapshotData.starweaversWarp.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.starweaversWarp.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.starweaversWarp.isActive = false
							TRB.Data.snapshotData.starweaversWarp.spellId = nil
							TRB.Data.snapshotData.starweaversWarp.duration = 0
							TRB.Data.snapshotData.starweaversWarp.endTime = nil
						end
					elseif spellId == TRB.Data.spells.starweaversWeft.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.starweaversWeft.isActive = true
							_, _, _, _, TRB.Data.snapshotData.starweaversWeft.duration, TRB.Data.snapshotData.starweaversWeft.endTime, _, _, _, TRB.Data.snapshotData.starweaversWeft.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.starweaversWeft.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.starweaversWeft.isActive = false
							TRB.Data.snapshotData.starweaversWeft.spellId = nil
							TRB.Data.snapshotData.starweaversWeft.duration = 0
							TRB.Data.snapshotData.starweaversWeft.endTime = nil
						end
					elseif spellId == TRB.Data.spells.rattleTheStars.buffId then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.rattleTheStars.isActive = true
							_, _, TRB.Data.snapshotData.rattleTheStars.stacks, _, TRB.Data.snapshotData.rattleTheStars.duration, TRB.Data.snapshotData.rattleTheStars.endTime, _, _, _, TRB.Data.snapshotData.rattleTheStars.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.rattleTheStars.buffId)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.rattleTheStars.isActive = false
							TRB.Data.snapshotData.rattleTheStars.spellId = nil
							TRB.Data.snapshotData.rattleTheStars.duration = 0
							TRB.Data.snapshotData.rattleTheStars.endTime = nil
							TRB.Data.snapshotData.rattleTheStars.stacks = 0
						end
						CheckCharacter()
						triggerUpdate = true
					elseif spellId == TRB.Data.spells.newMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.newMoon.currentSpellId = TRB.Data.spells.halfMoon.id
							TRB.Data.snapshotData.newMoon.currentKey = "halfMoon"
							TRB.Data.snapshotData.newMoon.checkAfter = currentTime + 20
						end
					elseif spellId == TRB.Data.spells.halfMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.newMoon.currentSpellId = TRB.Data.spells.fullMoon.id
							TRB.Data.snapshotData.newMoon.currentKey = "fullMoon"
							TRB.Data.snapshotData.newMoon.checkAfter = currentTime + 20
						end
					elseif spellId == TRB.Data.spells.fullMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							-- New Moon doesn't like to behave when we do this
							TRB.Data.snapshotData.newMoon.currentSpellId = TRB.Data.spells.newMoon.id
							TRB.Data.snapshotData.newMoon.currentKey = "newMoon"
							TRB.Data.snapshotData.newMoon.checkAfter = currentTime + 20
---@diagnostic disable-next-line: redundant-parameter
							TRB.Data.spells.newMoon.currentIcon = select(3, GetSpellInfo(202767)) -- Use the old Legion artiface spell ID since New Moon's icon returns incorrect for several seconds after casting Full Moon
						end
					else
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "feral" then
					if spellId == TRB.Data.spells.rip.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rip Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].rip = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.rip = TRB.Data.snapshotData.targetData.rip + 1
								end
								TRB.Data.snapshotData.targetData.targets[destGUID].ripSnapshot = GetCurrentSnapshot(TRB.Data.spells.rip.bonuses)
								
								if TRB.Data.snapshotData.bloodtalons.stacks == 0 then
									TRB.Data.snapshotData.bloodtalons.endTimeLeeway = nil
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].rip = false
								TRB.Data.snapshotData.targetData.targets[destGUID].ripRemaining = 0
								TRB.Data.snapshotData.targetData.targets[destGUID].ripSnapshot = 0
								TRB.Data.snapshotData.targetData.rip = TRB.Data.snapshotData.targetData.rip - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.rake.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rake Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].rake = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.rake = TRB.Data.snapshotData.targetData.rake + 1
								end
								TRB.Data.snapshotData.targetData.targets[destGUID].rakeSnapshot = GetCurrentSnapshot(TRB.Data.spells.rake.bonuses)
								TRB.Data.snapshotData.suddenAmbush.endTimeLeeway = nil
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].rake = false
								TRB.Data.snapshotData.targetData.targets[destGUID].rakeRemaining = 0
								TRB.Data.snapshotData.targetData.targets[destGUID].rakeSnapshot = 0
								TRB.Data.snapshotData.targetData.rake = TRB.Data.snapshotData.targetData.rake - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.thrash.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Thrash Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].thrash = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.thrash = TRB.Data.snapshotData.targetData.thrash + 1
								end
								TRB.Data.snapshotData.targetData.targets[destGUID].thrashSnapshot = GetCurrentSnapshot(TRB.Data.spells.thrash.bonuses)
								
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].thrash = false
								TRB.Data.snapshotData.targetData.targets[destGUID].thrashRemaining = 0
								TRB.Data.snapshotData.targetData.targets[destGUID].thrashSnapshot = 0
								TRB.Data.snapshotData.targetData.thrash = TRB.Data.snapshotData.targetData.thrash - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.moonfire.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire + 1
								end
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfireSnapshot = GetCurrentSnapshot(TRB.Data.spells.moonfire.bonuses)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = false
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfireRemaining = 0
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfireSnapshot = 0
								TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.shadowmeld.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
							TRB.Data.snapshotData.shadowmeld.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.shadowmeld.isActive = false
						end
					elseif spellId == TRB.Data.spells.prowl.id or spellId == TRB.Data.spells.prowl.idIncarnation then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
							TRB.Data.snapshotData.prowl.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.prowl.isActive = false
						end
					elseif spellId == TRB.Data.spells.suddenAmbush.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.suddenAmbush.isActive = true
							_, _, _, _, TRB.Data.snapshotData.suddenAmbush.duration, TRB.Data.snapshotData.suddenAmbush.endTime, _, _, _, TRB.Data.snapshotData.suddenAmbush.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.suddenAmbush.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.suddenAmbush.isActive = false		
							TRB.Data.snapshotData.suddenAmbush.endTimeLeeway = currentTime + 0.1
							TRB.Data.snapshotData.suddenAmbush.spellId = nil
							TRB.Data.snapshotData.suddenAmbush.duration = 0
							TRB.Data.snapshotData.suddenAmbush.endTime = nil
						end
					elseif spellId == TRB.Data.spells.berserk.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.berserk.isActive = true
							_, _, _, _, TRB.Data.snapshotData.berserk.duration, TRB.Data.snapshotData.berserk.endTime, _, _, _, TRB.Data.snapshotData.berserk.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.berserk.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.berserk.isActive = false
							TRB.Data.snapshotData.berserk.spellId = nil
							TRB.Data.snapshotData.berserk.duration = 0
							TRB.Data.snapshotData.berserk.endTime = nil
						end
					elseif spellId == TRB.Data.spells.incarnationAvatarOfAshamane.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.incarnationAvatarOfAshamane.isActive = true
							_, _, _, _, TRB.Data.snapshotData.incarnationAvatarOfAshamane.duration, TRB.Data.snapshotData.incarnationAvatarOfAshamane.endTime, _, _, _, TRB.Data.snapshotData.incarnationAvatarOfAshamane.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.incarnationAvatarOfAshamane.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.incarnationAvatarOfAshamane.isActive = false
							TRB.Data.snapshotData.incarnationAvatarOfAshamane.spellId = nil
							TRB.Data.snapshotData.incarnationAvatarOfAshamane.duration = 0
							TRB.Data.snapshotData.incarnationAvatarOfAshamane.endTime = nil
						end
					elseif spellId == TRB.Data.spells.clearcasting.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, TRB.Data.snapshotData.clearcasting.stacks, _, TRB.Data.snapshotData.clearcasting.duration, TRB.Data.snapshotData.clearcasting.endTime, _, _, _, TRB.Data.snapshotData.clearcasting.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.clearcasting.id)
							TRB.Data.spells.clearcasting.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff							
							TRB.Data.snapshotData.clearcasting.endTimeLeeway = currentTime + 0.1
							TRB.Data.snapshotData.clearcasting.endTime = nil
							TRB.Data.snapshotData.clearcasting.duration = 0
							TRB.Data.snapshotData.clearcasting.stacks = 0
							TRB.Data.spells.clearcasting.isActive = false
						end
					elseif spellId == TRB.Data.spells.tigersFury.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.tigersFury.isActive = true
							_, _, _, _, TRB.Data.snapshotData.tigersFury.duration, TRB.Data.snapshotData.tigersFury.endTime, _, _, _, TRB.Data.snapshotData.tigersFury.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.tigersFury.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.tigersFury.isActive = false
							TRB.Data.snapshotData.tigersFury.spellId = nil
							TRB.Data.snapshotData.tigersFury.duration = 0
							TRB.Data.snapshotData.tigersFury.endTime = nil
						end
					elseif spellId == TRB.Data.spells.bloodtalons.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, TRB.Data.snapshotData.bloodtalons.stacks, _, TRB.Data.snapshotData.bloodtalons.duration, TRB.Data.snapshotData.bloodtalons.endTime, _, _, _, TRB.Data.snapshotData.bloodtalons.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.bloodtalons.id)
							TRB.Data.spells.bloodtalons.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff		
							TRB.Data.snapshotData.bloodtalons.endTimeLeeway = currentTime + 0.1
							TRB.Data.snapshotData.bloodtalons.endTime = nil
							TRB.Data.snapshotData.bloodtalons.duration = 0
							TRB.Data.snapshotData.bloodtalons.stacks = 0
							TRB.Data.spells.bloodtalons.isActive = false
						end
					elseif spellId == TRB.Data.spells.apexPredatorsCraving.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.apexPredatorsCraving.isActive = true
							_, _, _, _, TRB.Data.snapshotData.apexPredatorsCraving.duration, TRB.Data.snapshotData.apexPredatorsCraving.endTime, _, _, _, TRB.Data.snapshotData.apexPredatorsCraving.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.apexPredatorsCraving.id)

							if TRB.Data.settings.druid.feral.audio.apexPredatorsCraving.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.druid.feral.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.apexPredatorsCraving.isActive = false
							TRB.Data.snapshotData.apexPredatorsCraving.spellId = nil
							TRB.Data.snapshotData.apexPredatorsCraving.duration = 0
							TRB.Data.snapshotData.apexPredatorsCraving.endTime = nil
						end
					else
					end
				elseif specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then
					if spellId == TRB.Data.spells.symbolOfHope.id then
						if type == "SPELL_AURA_REMOVED" then -- Lost Symbol of Hope
							-- Let UpdateSymbolOfHope() clean this up
							UpdateSymbolOfHope(true)
						end
					elseif spellId == TRB.Data.spells.potionOfFrozenFocusRank1.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							TRB.Data.snapshotData.channeledManaPotion.spellKey = "potionOfFrozenFocusRank1"
							TRB.Data.snapshotData.channeledManaPotion.isActive = true
							TRB.Data.snapshotData.channeledManaPotion.ticksRemaining = TRB.Data.spells.potionOfFrozenFocusRank1.ticks
							TRB.Data.snapshotData.channeledManaPotion.mana = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfFrozenFocusRank1.mana, true)
							TRB.Data.snapshotData.channeledManaPotion.endTime = currentTime + TRB.Data.spells.potionOfFrozenFocusRank1.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == TRB.Data.spells.potionOfFrozenFocusRank2.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							TRB.Data.snapshotData.channeledManaPotion.spellKey = "potionOfFrozenFocusRank2"
							TRB.Data.snapshotData.channeledManaPotion.isActive = true
							TRB.Data.snapshotData.channeledManaPotion.ticksRemaining = TRB.Data.spells.potionOfFrozenFocusRank2.ticks
							TRB.Data.snapshotData.channeledManaPotion.mana = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfFrozenFocusRank2.mana, true)
							TRB.Data.snapshotData.channeledManaPotion.endTime = currentTime + TRB.Data.spells.potionOfFrozenFocusRank2.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == TRB.Data.spells.potionOfFrozenFocusRank3.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							TRB.Data.snapshotData.channeledManaPotion.spellKey = "potionOfFrozenFocusRank3"
							TRB.Data.snapshotData.channeledManaPotion.isActive = true
							TRB.Data.snapshotData.channeledManaPotion.ticksRemaining = TRB.Data.spells.potionOfFrozenFocusRank3.ticks
							TRB.Data.snapshotData.channeledManaPotion.mana = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfFrozenFocusRank3.mana, true)
							TRB.Data.snapshotData.channeledManaPotion.endTime = currentTime + TRB.Data.spells.potionOfFrozenFocusRank3.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == TRB.Data.spells.efflorescence.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.efflorescence.endTime = currentTime + TRB.Data.spells.efflorescence.duration
						end
					elseif spellId == TRB.Data.spells.sunfire.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Sunfire Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].sunfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.sunfire = TRB.Data.snapshotData.targetData.sunfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].sunfire = false
								TRB.Data.snapshotData.targetData.targets[destGUID].sunfireRemaining = 0
								TRB.Data.snapshotData.targetData.sunfire = TRB.Data.snapshotData.targetData.sunfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.moonfire.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = false
								TRB.Data.snapshotData.targetData.targets[destGUID].moonfireRemaining = 0
								TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.clearcasting.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, TRB.Data.snapshotData.clearcasting.stacks, _, TRB.Data.snapshotData.clearcasting.duration, TRB.Data.snapshotData.clearcasting.endTime, _, _, _, TRB.Data.snapshotData.clearcasting.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.clearcasting.id)
							TRB.Data.spells.clearcasting.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.clearcasting.endTime = nil
							TRB.Data.snapshotData.clearcasting.duration = 0
							TRB.Data.snapshotData.clearcasting.stacks = 0
							TRB.Data.spells.clearcasting.isActive = false
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
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.druid.balance)
			TRB.Functions.IsTtdActive(TRB.Data.settings.druid.balance)
			specCache.balance.talents = TRB.Functions.GetTalents()
			FillSpellData_Balance()
			TRB.Functions.LoadFromSpecCache(specCache.balance)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Balance

			if TRB.Data.barConstructedForSpec ~= "balance" then
				TRB.Data.barConstructedForSpec = "balance"
				ConstructResourceBar(specCache.balance.settings)
			end
		elseif specId == 2 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.druid.feral)
			TRB.Functions.IsTtdActive(TRB.Data.settings.druid.feral)
			specCache.feral.talents = TRB.Functions.GetTalents()
			FillSpellData_Feral()
			TRB.Functions.LoadFromSpecCache(specCache.feral)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Feral

			if TRB.Data.barConstructedForSpec ~= "feral" then
				TRB.Data.barConstructedForSpec = "feral"
				ConstructResourceBar(specCache.feral.settings)
			end
		elseif specId == 4 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.druid.restoration)
			TRB.Functions.IsTtdActive(TRB.Data.settings.druid.restoration)
			specCache.restoration.talents = TRB.Functions.GetTalents()
			FillSpellData_Restoration()
			TRB.Functions.LoadFromSpecCache(specCache.restoration)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration

			if TRB.Data.barConstructedForSpec ~= "restoration" then
				TRB.Data.barConstructedForSpec = "restoration"
				ConstructResourceBar(specCache.restoration.settings)
			end
		else
			TRB.Data.barConstructedForSpec = nil
		end
		EventRegistration()
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
							TRB.Data.settings.druid.balance = TRB.Functions.ValidateLsmValues("Balance Druid", TRB.Data.settings.druid.balance)
							TRB.Data.settings.druid.feral = TRB.Functions.ValidateLsmValues("Feral Druid", TRB.Data.settings.druid.feral)
							TRB.Data.settings.druid.restoration = TRB.Functions.ValidateLsmValues("Restoration Druid", TRB.Data.settings.druid.restoration)
							
							FillSpellData_Balance()
							FillSpellData_Feral()
							FillSpellData_Restoration()

							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Druid.ConstructOptionsPanel(specCache)
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
