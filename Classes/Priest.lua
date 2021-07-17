local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
	TRB.Frames.passiveFrame.thresholds[1] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[2] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[3] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[4] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[5] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.resourceFrame.thresholds[1] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[2] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[3] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[4] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)

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
		holy = {
			snapshotData = {},
			barTextVariables = {}
		},
		shadow = {
			snapshotData = {},
			barTextVariables = {}
		}
	}

	local function FillSpecCache()
		-- Holy
		specCache.holy.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				wrathfulFaerie = 0
			},
			wrathfulFaerie = {
				mana = 0,
				main = {
					mana = 0,
					gcds = 0,
					procs = 0,
					time = 0
				},
				fermata = {
					mana = 0,
					gcds = 0,
					procs = 0,
					time = 0
				}
			},
			dots = {
				swpCount = 0
			},
		}

		specCache.holy.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			effects = {
				overgrowthSeedlingModifier = 1
			},
			talents = {
				surgeOfLight = {
					isSelected = false
				},
				bindingHeal = {
					isSelected = false
				},
				lightOfTheNaaru = {
					isSelected = false
				},
				apotheosis = {
					isSelected = false
				}
			},
			items = {
				potions = {
					potionOfSpiritualClarity = {
						id = 171272,
						mana = 10000
					},
					spiritualRejuvenationPotion = {
						id = 171269,
						mana = 2500
					},
					spiritualManaPotion = {
						id = 171268,
						mana = 6000
					},
					soulfulManaPotion = {
						id = 180318,
						mana = 4000
					}
				},
				harmoniousApparatus = false,
				flashConcentration = false,
				alchemyStone = false
			},
			torghast = {
				dreamspunMushroomsModifier = 1,
				phantasmicInfuserModifier = 1
			}
		}

		specCache.holy.spells = {
			holyWordSerenity = {
				id = 2050,
				name = "",
				icon = "",
				duration = 60
			},
			heal = {
				id = 2060,
				name = "",
				icon = "",
				holyWordKey = "holyWordSerenity",
				holyWordReduction = 6
			},
			flashHeal = {
				id = 2061,
				name = "",
				icon = "",
				holyWordKey = "holyWordSerenity",
				holyWordReduction = 6
			},
			prayerOfMending = {
				id = 33076,
				name = "",
				icon = "",
				holyWordKey = "holyWordSerenity",
				holyWordReduction = 4
			},
			holyWordSanctify = {
				id = 34861,
				name = "",
				icon = "",
				duration = 60
			},
			prayerOfHealing = {
				id = 596,
				name = "",
				icon = "",
				holyWordKey = "holyWordSanctify",
				holyWordReduction = 6
			},
			circleOfHealing = {
				id = 204883,
				name = "",
				icon = "",
				holyWordKey = "holyWordSanctify",
				holyWordReduction = 4
			},
			renew = {
				id = 139,
				name = "",
				icon = "",
				holyWordKey = "holyWordSanctify",
				holyWordReduction = 2
			},
			holyWordChastise = {
				id = 88625,
				name = "",
				icon = "",
				duration = 60
			},
			smite = {
				id = 585,
				name = "",
				icon = "",
				holyWordKey = "holyWordChastise",
				holyWordReduction = 4
			},
			holyFire = {
				id = 14914,
				name = "",
				icon = "",
				holyWordKey = "holyWordChastise",
				holyWordReduction = 4
			},
			shadowWordPain = {
				id = 589,
				icon = "",
				name = "",
				baseDuration = 16,
				pandemic = true,
				pandemicTime = 16 * 0.3
			},
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 5.0, --Hasted
				manaPercent = 0.03,
				ticks = 5, -- initial + 5 ticks, 18% total restored
				tickId = 265144
			},

			-- Talents

			surgeOfLight = {
				id = 114255,
				name = "",
				icon = "",
				duration = 20,
				isActive = false
			},
			bindingHeal = {
				id = 32546,
				name = "",
				icon = "",
				holyWordKey = "holyWordSerenity",
				holyWordReduction = 3,
				holyWordKey2 = "holyWordSanctify",
				holyWordReduction2 = 3
			},
			lightOfTheNaaru = {
				id = 196985,
				name = "",
				icon = "",
				holyWordModifier = (4/3), -- 33% more
			},
			apotheosis = {
				id = 200183,
				name = "",
				icon = "",
				holyWordModifier = 4, -- 300% more
				duration = 20,
				isActive = false
			},

			-- External mana
			innervate = {
				id = 29166,
				name = "",
				icon = "",
				duration = 10,
				isActive = false
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8,
				isActive = false
			},

			-- Covenant
			wrathfulFaerie = {
				id = 342132,
				name = "",
				icon = "",
				manaPercent = 0.005,
				duration = 20,
				icd = 0.75,
				energizeId = 327703
			},

			-- Conduit
			wrathfulFaerieFermata = {
				id = 345452,
				name = "",
				icon = "",
				manaPercent = 0, -- We'll use modifier against wrathfulFaerie instead
				modifier = 0.8,
				icd = 0.75,
				energizeId = 345456,
				conduitId = 101,
				conduitRanks = {}
			},
			holyOration = {
				id = 338345,
				name = "",
				icon = "",
				conduitId = 116,
				conduitRanks = {}
			},

			-- Legendary
			harmoniousApparatus = {
				id = 336314,
				name = "",
				icon = "",
				idLegendaryBonus = 6977
			},
			flashConcentration = {
				id = 336267,
				name = "",
				icon = "",
				idLegendaryBonus = 6974,
				maxStacks = 5
			},
			hauntedMask = {
				id = 356968,
				name = "",
				icon = "",
				manaPercent = 0.005,
				duration = 20,
				icd = 0.75,
				--energizeId = 327703
			},

			-- Potions
			potionOfSpiritualClarity = {
				id = 307161,
				--itemId = 171272,
				name = "",
				icon = "",
				mana = 1000,
				duration = 10,
				ticks = 10
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
			--[[
			spiritualRejuvenationPotion = {
				itemId = 171269,
				name = "",
				icon = "",
			},
			spiritualManaPotion = {
				itemId = 171268,
				name = "",
				icon = "",
			},
			soulfulManaPotion = {
				itemId = 180318,
				name = "",
				icon = "",
			},
			]]

			-- Torghast
			dreamspunMushrooms = {
				id = 342409,
				name = "",
				icon = ""
			},
			elethiumMuzzle = {
				id = 319276,
				name = "",
				icon = ""
			}
		}

		specCache.holy.snapshotData.manaRegen = 0
		specCache.holy.snapshotData.audio = {
			innervateCue = false,
			surgeOfLightCue = false,
			surgeOfLight2Cue = false,
			flashConcentrationCue = false
		}
		specCache.holy.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			wrathfulFaerieGuid = nil,
			shadowWordPain = 0,
			targets = {}
		}
		specCache.holy.snapshotData.innervate = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.holy.snapshotData.manaTideTotem = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.holy.snapshotData.apotheosis = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.holy.snapshotData.surgeOfLight = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.holy.snapshotData.flashConcentration = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.holy.snapshotData.symbolOfHope = {
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
		specCache.holy.snapshotData.holyWordSerenity = {
			startTime = nil,
			duration = 0,
			onCooldown = false
		}
		specCache.holy.snapshotData.holyWordSanctify = {
			startTime = nil,
			duration = 0,
			onCooldown = false
		}
		specCache.holy.snapshotData.holyWordChastise = {
			startTime = nil,
			duration = 0,
			onCooldown = false
		}
		specCache.holy.snapshotData.wrathfulFaerie = {
			main = {
				isActive = false,
				procTime = 0,
				remaining = {
					procs = 0,
					gcds = 0,
					time = 0
				},
				resourceRaw = 0,
				resourceFinal = 0
			},
			fermata = {
				isActive = false,
				procTime = 0,
				remaining = {
					procs = 0,
					gcds = 0,
					time = 0
				},
				resourceRaw = 0,
				resourceFinal = 0
			},
			hauntedMask = {
				isActive = false
			},
			resourceRaw = 0,
			resourceFinal = 0,
		}
		specCache.holy.snapshotData.potionOfSpiritualClarity = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.holy.snapshotData.potion = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}

		specCache.holy.barTextVariables = {
			icons = {},
			values = {}
		}

		-- Shadow
		specCache.shadow.Global_TwintopResourceBar = {
			ttd = 0,
			voidform = {
			},
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				auspiciousSpirits = 0,
				mindbender = 0,
				deathAndMadness = 0,
				ecttv = 0,
				wrathfulFaerie = 0
			},
			auspiciousSpirits = {
				count = 0,
				insanity = 0
			},
			dots = {
				swpCount = 0,
				vtCount = 0,
				dpCount = 0
			},
			mindbender = {
				insanity = 0,
				gcds = 0,
				swings = 0,
				time = 0
			},
			mindSear = {
				targetsHit = 0
			},
			deathAndMadness = {
				insanity = 0,
				ticks = 0
			},
			eternalCallToTheVoid = {
				insanity = 0,
				ticks = 0,
				count = 0
			},
			wrathfulFaerie = {
				insanity = 0,
				main = {
					insanity = 0,
					gcds = 0,
					procs = 0,
					time = 0
				},
				fermata = {
					insanity = 0,
					gcds = 0,
					procs = 0,
					time = 0
				}
			}
		}

		specCache.shadow.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			devouringPlagueThreshold = 50,
			searingNightmareThreshold = 30,
			effects = {
				overgrowthSeedlingModifier = 1
			},
			talents = {
				fotm = {
					isSelected = false,
					modifier = 1.2
				},
				as = {
					isSelected = false
				},
				mindbender = {
					isSelected = false
				},
				hungeringVoid = {
					isSelected = false
				},
				surrenderToMadeness = {
					isSelected = false
				},
				searingNightmare = {
					isSelected = false
				}
			},
			items = {
				callToTheVoid = false
			},
			torghast = {
				dreamspunMushroomsModifier = 1,
				elethiumMuzzleModifier = 1,
				phantasmicInfuserModifier = 1
			}
		}

		specCache.shadow.spells = {
			-- Priest Class Abilities
			massDispel = {
				id = 32375,
				name = "",
				icon = "",
				insanity = 6,
				fotm = false
			},
			mindBlast = {
				id = 8092,
				name = "",
				icon = "",
				insanity = 8,
				fotm = true
			},
			shadowWordPain = {
				id = 589,
				icon = "",
				name = "",
				insanity = 4,
				fotm = false,
				baseDuration = 16,
				pandemic = true,
				pandemicTime = 16 * 0.3
			},

			-- Shadow Baseline Abilities
			devouringPlague = {
				id = 335467,
				name = "",
				icon = "",
				insanity = 0,
				fotm = true
			},
			mindFlay = {
				id = 15407,
				name = "",
				icon = "",
				insanity = 3,
				fotm = true
			},
			mindSear = {
				id = 48045,
				idTick = 49821,
				name = "",
				icon = "",
				insanity = 1, -- Per tick per target
				fotm = false
			},
			shadowfiend = {
				id = 34433,
				name = "",
				icon = "",
				insanity = 3,
				fotm = false
			},
			shadowyApparition = {
				id = 78203,
				name = "",
				icon = ""
			},
			vampiricTouch = {
				id = 34914,
				name = "",
				icon = "",
				insanity = 5,
				fotm = false,
				baseDuration = 21,
				pandemic = true,
				pandemicTime = 21 * 0.3
			},
			voidBolt = {
				id = 205448,
				name = "",
				icon = "",
				insanity = 12,
				fotm = false
			},
			voidform = {
				id = 194249,
				name = "",
				icon = ""
			},

			-- Talents
			deathAndMadness = {
				id = 321973,
				name = "",
				icon = "",
				insanity = 10,
				ticks = 4,
				duration = 4,
				fotm = false
			},
			voidTorrent = {
				id = 263165,
				name = "",
				icon = "",
				insanity = 15,
				fotm = false
			},
			auspiciousSpirits = {
				id = 155271,
				idSpawn = 147193,
				idImpact = 148859,
				insanity = 2,
				fotm = false,
				name = "",
				icon = ""
			},
			twistOfFate = {
				id = 123254,
				name = "",
				icon = ""
			},
			shadowCrash = {
				id = 205385,
				name = "",
				icon = "",
				insanity = 15,
				fotm = false
			},
			mindbender = {
				id = 34433,
				name = "",
				icon = "",
				insanity = 5,
				fotm = false
			},
			hungeringVoid = {
				id = 345218,
				idDebuff = 345219,
				name = "",
				icon = ""
			},
			s2m = {
				isActive = false,
				isDebuffActive = false,
				modifier = 2.0,
				modifierDebuff = 0.0,
				id = 319952,
				name = "",
				icon = ""
			},
			
			-- Item Buffs
			memoryOfLucidDreams = {
				id = 298357,
				name = "",
				isActive = false,
				modifier = 2.0
			},

			-- Conduits
			mindDevourer = {
				id = 338333,
				--id = 17, --PWS for testing
				name = "",
				icon = "",
				isActive = false
			},
			rabidShadows = {
				id = 338338,
				name = "",
				icon = "",
				conduitId = 114,
				conduitRanks = {}
			},
			dissonantEchoes = {
				id = 338342,
				name = "",
				icon = "",
				conduitId = 72,
				conduitRanks = {}
			},

			-- Covenant
			wrathfulFaerie = {
				id = 342132,
				name = "",
				icon = "",
				insanity = 3,
				fotm = false,
				duration = 20,
				icd = 0.75,
				energizeId = 327703
			},
			wrathfulFaerieFermata = {
				id = 345452,
				name = "",
				icon = "",
				insanity = 0, -- We'll use modifier against wrathfulFaerie instead
				fotm = false,
				modifier = 0.8,
				icd = 0.75,
				energizeId = 345456,
				conduitId = 101,
				conduitRanks = {}
			},

			-- Legendaries
			hauntedMask = {
				id = 356968,
				name = "",
				icon = "",
				insanity = 3,
				fotm = false,
				duration = 20,
				icd = 0.75,
				--energizeId = 327703
			},
			eternalCallToTheVoid_Tendril = {
				id = 336216,
				idTick = 193473,
				idLegendaryBonus = 6983,
				name = "",
				icon = "",
				tocMinVersion = 90001
			},
			eternalCallToTheVoid_Lasher = {
				id = 344753,
				idTick = 344752,
				idLegendaryBonus = 6983,
				name = "",
				icon = "",
				tocMinVersion = 90002
			},
			lashOfInsanity_Tendril = {
				id = 344838,
				name = "",
				icon = "",
				insanity = 3,
				fotm = false,
				duration = 15,
				ticks = 15,
				tickDuration = 1, --This is NOT hasted
				tocMinVersion = 90001
			},
			lashOfInsanity_Lasher = {
				id = 344838, --Doesn't actually exist / unused?
				name = "",
				icon = "",
				insanity = 1,
				fotm = false,
				duration = 15,
				ticks = 15,
				tickDuration = 1, --This is hasted
				tocMinVersion = 90002
			},

			-- Torghast
			dreamspunMushrooms = {
				id = 342409,
				name = "",
				icon = ""
			},
			elethiumMuzzle = {
				id = 319276,
				name = "",
				icon = ""
			},
			phantasmicInfuser = {
				id = 347240,
				name = "",
				icon = ""
			}
		}

		specCache.shadow.snapshotData.voidform = {
			spellId = nil,
			remainingTime = 0,
			remainingHvTime = 0,
			additionalVbCasts = 0,
			remainingHvAvgTime = 0,
			additionalVbAvgCasts = 0,
			isInfinite = false,
			isAverageInfinite = false,
			s2m = {
				startTime = nil,
				active = false
			}
		}
		specCache.shadow.snapshotData.audio = {
			playedDpCue = false,
			playedMdCue = false,
			overcapCue = false
		}
		specCache.shadow.snapshotData.mindSear = {
			targetsHit = 0,
			hitTime = nil,
			hasStruckTargets = false
		}
		specCache.shadow.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			auspiciousSpirits = 0,
			shadowWordPain = 0,
			vampiricTouch = 0,
			devouringPlague = 0,
			wrathfulFaerieGuid = nil,
			targets = {}
		}
		specCache.shadow.snapshotData.deathAndMadness = {
			isActive = false,
			ticksRemaining = 0,
			insanity = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.shadow.snapshotData.mindbender = {
			isActive = false,
			onCooldown = false,
			swingTime = 0,
			remaining = {
				swings = 0,
				gcds = 0,
				time = 0
			},
			resourceRaw = 0,
			resourceFinal = 0
		}
		specCache.shadow.snapshotData.eternalCallToTheVoid = {
			numberActive = 0,
			resourceRaw = 0,
			resourceFinal = 0,
			maxTicksRemaining = 0,
			voidTendrils = {}
		}
		specCache.shadow.snapshotData.mindDevourer = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshotData.twistOfFate = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshotData.wrathfulFaerie = {
			main = {
				isActive = false,
				procTime = 0,
				remaining = {
					procs = 0,
					gcds = 0,
					time = 0
				},
				resourceRaw = 0,
				resourceFinal = 0
			},
			fermata = {
				isActive = false,
				procTime = 0,
				remaining = {
					procs = 0,
					gcds = 0,
					time = 0
				},
				resourceRaw = 0,
				resourceFinal = 0
			},
			resourceRaw = 0,
			resourceFinal = 0,
		}

		specCache.shadow.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Holy()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.holy)
	end

	local function FillSpellData_Holy()
		Setup_Holy()
		local spells = TRB.Functions.FillSpellData(specCache.holy.spells)

		-- Conduit Ranks
		spells.wrathfulFaerieFermata.conduitRanks[0] = 0
		spells.wrathfulFaerieFermata.conduitRanks[1] = 3.8
		spells.wrathfulFaerieFermata.conduitRanks[2] = 4.18
		spells.wrathfulFaerieFermata.conduitRanks[3] = 4.56
		spells.wrathfulFaerieFermata.conduitRanks[4] = 4.94
		spells.wrathfulFaerieFermata.conduitRanks[5] = 5.32
		spells.wrathfulFaerieFermata.conduitRanks[6] = 5.7
		spells.wrathfulFaerieFermata.conduitRanks[7] = 6.08
		spells.wrathfulFaerieFermata.conduitRanks[8] = 6.46
		spells.wrathfulFaerieFermata.conduitRanks[9] = 6.84
		spells.wrathfulFaerieFermata.conduitRanks[10] = 7.22
		spells.wrathfulFaerieFermata.conduitRanks[11] = 7.6
		spells.wrathfulFaerieFermata.conduitRanks[12] = 7.98
		spells.wrathfulFaerieFermata.conduitRanks[13] = 8.36
		spells.wrathfulFaerieFermata.conduitRanks[14] = 8.74
		spells.wrathfulFaerieFermata.conduitRanks[15] = 9.12
		
		spells.holyOration.conduitRanks[0] = 0
		spells.holyOration.conduitRanks[1] = 0.06
		spells.holyOration.conduitRanks[2] = 0.088
		spells.holyOration.conduitRanks[3] = 0.096
		spells.holyOration.conduitRanks[4] = 0.104
		spells.holyOration.conduitRanks[5] = 0.112
		spells.holyOration.conduitRanks[6] = 0.120
		spells.holyOration.conduitRanks[7] = 0.128
		spells.holyOration.conduitRanks[8] = 0.136
		spells.holyOration.conduitRanks[9] = 0.144
		spells.holyOration.conduitRanks[10] = 0.152
		spells.holyOration.conduitRanks[11] = 0.16
		spells.holyOration.conduitRanks[12] = 0.168
		spells.holyOration.conduitRanks[13] = 0.176
		spells.holyOration.conduitRanks[14] = 0.184
		spells.holyOration.conduitRanks[15] = 0.192
		-- TODO: Add these conduits to the bar icon variables too!


		-- This is done here so that we can get icons for the options menu!
		specCache.holy.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#apotheosis", icon = spells.apotheosis.icon, description = spells.apotheosis.name, printInSettings = true },
			{ variable = "#bh", icon = spells.bindingHeal.icon, description = spells.bindingHeal.name, printInSettings = true },
			{ variable = "#bindingHeal", icon = spells.bindingHeal.icon, description = spells.bindingHeal.name, printInSettings = false },
			{ variable = "#coh", icon = spells.circleOfHealing.icon, description = spells.circleOfHealing.name, printInSettings = true },
			{ variable = "#circleOfHealing", icon = spells.circleOfHealing.icon, description = spells.circleOfHealing.name, printInSettings = false },
			{ variable = "#fc", icon = spells.flashConcentration.icon, description = spells.flashConcentration.name, printInSettings = true },
			{ variable = "#flashConcentration", icon = spells.flashConcentration.icon, description = spells.flashConcentration.name, printInSettings = false },
			{ variable = "#flashHeal", icon = spells.flashHeal.icon, description = spells.flashHeal.name, printInSettings = true },
			{ variable = "#ha", icon = spells.harmoniousApparatus.icon, description = spells.harmoniousApparatus.name, printInSettings = true },
			{ variable = "#harmoniousApparatus", icon = spells.harmoniousApparatus.icon, description = spells.harmoniousApparatus.name, printInSettings = false },
			{ variable = "#heal", icon = spells.heal.icon, description = spells.heal.name, printInSettings = true },
			{ variable = "#hf", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = true },
			{ variable = "#holyFire", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = false },
			{ variable = "#ho", icon = spells.holyOration.icon, description = spells.holyOration.name, printInSettings = true },
			{ variable = "#holyOration", icon = spells.holyOration.icon, description = spells.holyOration.name, printInSettings = false },
			{ variable = "#hwChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = true },
			{ variable = "#chastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
			{ variable = "#holyWordChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
			{ variable = "#hwSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = true },
			{ variable = "#sanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
			{ variable = "#holyWordSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
			{ variable = "#hwSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = true },
			{ variable = "#serenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
			{ variable = "#holyWordSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
			{ variable = "#innervate", icon = spells.innervate.icon, description = spells.innervate.name, printInSettings = true },
			{ variable = "#lotn", icon = spells.lightOfTheNaaru.icon, description = spells.lightOfTheNaaru.name, printInSettings = true },
			{ variable = "#lightOfTheNaaru", icon = spells.lightOfTheNaaru.icon, description = spells.lightOfTheNaaru.name, printInSettings = false },
			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },
			{ variable = "#poh", icon = spells.prayerOfHealing.icon, description = spells.prayerOfHealing.name, printInSettings = true },
			{ variable = "#prayerOfHealing", icon = spells.prayerOfHealing.icon, description = spells.prayerOfHealing.name, printInSettings = false },
			{ variable = "#pom", icon = spells.prayerOfMending.icon, description = spells.prayerOfMending.name, printInSettings = true },
			{ variable = "#prayerOfMending", icon = spells.prayerOfMending.icon, description = spells.prayerOfMending.name, printInSettings = false },
			{ variable = "#renew", icon = spells.renew.icon, description = spells.renew.name, printInSettings = true },
			{ variable = "#smite", icon = spells.smite.icon, description = spells.smite.name, printInSettings = true },
			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },
			{ variable = "#sol", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = true },
			{ variable = "#surgeOfLight", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = false },
			{ variable = "#wf", icon = spells.wrathfulFaerie.icon, description = spells.wrathfulFaerie.name, printInSettings = true },
			{ variable = "#wrathfulFaerie", icon = spells.wrathfulFaerie.icon, description = spells.wrathfulFaerie.name, printInSettings = false },

			{ variable = "#psc", icon = spells.potionOfSpiritualClarity.icon, description = spells.potionOfSpiritualClarity.name, printInSettings = true },
			{ variable = "#potionOfSpiritualClarity", icon = spells.potionOfSpiritualClarity.icon, description = spells.potionOfSpiritualClarity.name, printInSettings = false },
			--[[{ variable = "#srp", icon = spells.spiritualRejuvenationPotion.icon, description = spells.spiritualRejuvenationPotion.name, printInSettings = true },
			{ variable = "#spiritualRejuvenationPotion", icon = spells.spiritualRejuvenationPotion.icon, description = spells.spiritualRejuvenationPotion.name, printInSettings = false },
			{ variable = "#spiritualManaPotion", icon = spells.spiritualManaPotion.icon, description = spells.spiritualManaPotion.name, printInSettings = true },
			{ variable = "#soulfulManaPotion", icon = spells.soulfulManaPotion.icon, description = spells.soulfulManaPotion.name, printInSettings = true },
			]]

			{ variable = "#swp", icon = spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = true },
			{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = false },
		}
		specCache.holy.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

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
			
			{ variable = "$hwChastiseTime", description = "Time left on Holy Word: Chastise's cooldown", printInSettings = true, color = false },
			{ variable = "$chastiseTime", description = "Time left on Holy Word: Chastise's cooldown", printInSettings = false, color = false },
			{ variable = "$holyWordChastiseTime", description = "Time left on Holy Word: Chastise's cooldown", printInSettings = false, color = false },
			
			{ variable = "$hwSanctifyTime", description = "Time left on Holy Word: Sanctify's cooldown", printInSettings = true, color = false },
			{ variable = "$sanctifyTime", description = "Time left on Holy Word: Sanctify's cooldown", printInSettings = false, color = false },
			{ variable = "$holyWordSanctifyTime", description = "Time left on Holy Word: Sanctify's cooldown", printInSettings = false, color = false },
			
			{ variable = "$hwSerenityTime", description = "Time left on Holy Word: Serenity's cooldown", printInSettings = true, color = false },
			{ variable = "$serenityTime", description = "Time left on Holy Word: Serenity's cooldown", printInSettings = false, color = false },
			{ variable = "$holyWordSerenityTime", description = "Time left on Holy Word: Serenity's cooldown", printInSettings = false, color = false },

			{ variable = "$apotheosisTime", description = "Time remaining on Apotheosis", printInSettings = true, color = false },
			
			{ variable = "$solStacks", description = "Number of Surge of Light stacks", printInSettings = true, color = false },
			{ variable = "$solTime", description = "Time left on Surge of Light", printInSettings = true, color = false },

			{ variable = "$fcEquipped", description = "Checks if you have Flash Concentration equipped. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$fcStacks", description = "Number of Flash Concentration stacks", printInSettings = true, color = false },
			{ variable = "$fcTime", description = "Time left on Flash Concentration", printInSettings = true, color = false },

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
			
			{ variable = "$pscMana", description = "Mana while channeling of Potion of Spiritual Clarity", printInSettings = true, color = false },
			{ variable = "$pscTicks", description = "Number of ticks left channeling Potion of Spiritual Clarity", printInSettings = true, color = false },
			{ variable = "$pscTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Spiritual Clarity", printInSettings = true, color = false },
			
			{ variable = "$potionCooldown", description = "How long, in seconds, is left on your potion's cooldown in MM:SS format", printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = "How long, in seconds, is left on your potion's cooldown in seconds", printInSettings = true, color = false },

			{ variable = "$swpCount", description = "Number of Shadow Word: Pains active on targets", printInSettings = true, color = false },
			{ variable = "$swpTime", description = "Time remaining on Shadow Word: Pain on your current target", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.holy.spells = spells
	end


	local function Setup_Shadow()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.shadow)
	end

	local function FillSpellData_Shadow()
		Setup_Shadow()
		local spells = TRB.Functions.FillSpellData(specCache.shadow.spells)

		spells.mindbender.name = select(2, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
		spells.s2m.name = select(2, GetTalentInfo(7, 3, TRB.Data.character.specGroup))

		-- Conduit Ranks
		spells.wrathfulFaerieFermata.conduitRanks[0] = 0
		spells.wrathfulFaerieFermata.conduitRanks[1] = 3.8
		spells.wrathfulFaerieFermata.conduitRanks[2] = 4.18
		spells.wrathfulFaerieFermata.conduitRanks[3] = 4.56
		spells.wrathfulFaerieFermata.conduitRanks[4] = 4.94
		spells.wrathfulFaerieFermata.conduitRanks[5] = 5.32
		spells.wrathfulFaerieFermata.conduitRanks[6] = 5.7
		spells.wrathfulFaerieFermata.conduitRanks[7] = 6.08
		spells.wrathfulFaerieFermata.conduitRanks[8] = 6.46
		spells.wrathfulFaerieFermata.conduitRanks[9] = 6.84
		spells.wrathfulFaerieFermata.conduitRanks[10] = 7.22
		spells.wrathfulFaerieFermata.conduitRanks[11] = 7.6
		spells.wrathfulFaerieFermata.conduitRanks[12] = 7.98
		spells.wrathfulFaerieFermata.conduitRanks[13] = 8.36
		spells.wrathfulFaerieFermata.conduitRanks[14] = 8.74
		spells.wrathfulFaerieFermata.conduitRanks[15] = 9.12

		spells.rabidShadows.conduitRanks[0] = 0
		spells.rabidShadows.conduitRanks[1] = 0.12
		spells.rabidShadows.conduitRanks[2] = 0.209
		spells.rabidShadows.conduitRanks[3] = 0.228
		spells.rabidShadows.conduitRanks[4] = 0.247
		spells.rabidShadows.conduitRanks[5] = 0.266
		spells.rabidShadows.conduitRanks[6] = 0.285
		spells.rabidShadows.conduitRanks[7] = 0.304
		spells.rabidShadows.conduitRanks[8] = 0.323
		spells.rabidShadows.conduitRanks[9] = 0.342
		spells.rabidShadows.conduitRanks[10] = 0.361
		spells.rabidShadows.conduitRanks[11] = 0.38
		spells.rabidShadows.conduitRanks[12] = 0.399
		spells.rabidShadows.conduitRanks[13] = 0.418
		spells.rabidShadows.conduitRanks[14] = 0.437
		spells.rabidShadows.conduitRanks[15] = 0.456

		spells.dissonantEchoes.conduitRanks[0] = 0
		spells.dissonantEchoes.conduitRanks[1] = 0.031
		spells.dissonantEchoes.conduitRanks[2] = 0.034
		spells.dissonantEchoes.conduitRanks[3] = 0.037
		spells.dissonantEchoes.conduitRanks[4] = 0.04
		spells.dissonantEchoes.conduitRanks[5] = 0.043
		spells.dissonantEchoes.conduitRanks[6] = 0.047
		spells.dissonantEchoes.conduitRanks[7] = 0.05
		spells.dissonantEchoes.conduitRanks[8] = 0.053
		spells.dissonantEchoes.conduitRanks[9] = 0.056
		spells.dissonantEchoes.conduitRanks[10] = 0.059
		spells.dissonantEchoes.conduitRanks[11] = 0.062
		spells.dissonantEchoes.conduitRanks[12] = 0.065
		spells.dissonantEchoes.conduitRanks[13] = 0.068
		spells.dissonantEchoes.conduitRanks[14] = 0.071
		spells.dissonantEchoes.conduitRanks[15] = 0.074
		-- TODO: Add these conduits to the bar icon variables too!


		-- This is done here so that we can get icons for the options menu!
		specCache.shadow.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Insanity generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#vb", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = true },
			{ variable = "#voidBolt", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = false },
			{ variable = "#vf", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = true },
			{ variable = "#voidform", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = false },
																															  
			{ variable = "#mb", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = true },
			{ variable = "#mindBlast", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = false },
			{ variable = "#mf", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = true },
			{ variable = "#mindFlay", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = false },
			{ variable = "#ms", icon = spells.mindSear.icon, description = spells.mindSear.name, printInSettings = true },
			{ variable = "#mindSear", icon = spells.mindSear.icon, description = spells.mindSear.name, printInSettings = false },
			{ variable = "#voit", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = true },
			{ variable = "#voidTorrent", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = false },
			{ variable = "#dam", icon = spells.deathAndMadness.icon, description = spells.deathAndMadness.name, printInSettings = true },
			{ variable = "#deathAndMadness", icon = spells.deathAndMadness.icon, description = spells.deathAndMadness.name, printInSettings = false },
																															  
			{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
			{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },
			{ variable = "#vt", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = true },
			{ variable = "#vampiricTouch", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = false },
			{ variable = "#dp", icon = spells.devouringPlague.icon, description = spells.devouringPlague.name, printInSettings = true },
			{ variable = "#devouringPlague", icon = spells.devouringPlague.icon, description = spells.devouringPlague.name, printInSettings = false },
			{ variable = "#mDev", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = true },
			{ variable = "#mindDevourer", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = false },
																															  
			{ variable = "#as", icon = spells.auspiciousSpirits.icon, description = spells.auspiciousSpirits.name, printInSettings = true },
			{ variable = "#auspiciousSpirits", icon = spells.auspiciousSpirits.icon, description = spells.auspiciousSpirits.name, printInSettings = false },
			{ variable = "#sa", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = true },
			{ variable = "#shadowyApparition", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = false },
																					  
			{ variable = "#mindbender", icon = spells.mindbender.icon, description = "Mindbender", printInSettings = false },
			{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = "Shadowfiend", printInSettings = false },
			{ variable = "#sf", icon = spells.shadowfiend.icon, description = "Shadowfiend / Mindbender", printInSettings = true },
																															  
			{ variable = "#tof", icon = spells.twistOfFate.icon, description = spells.twistOfFate.name, printInSettings = true },
			{ variable = "#twistOfFate", icon = spells.twistOfFate.icon, description = spells.twistOfFate.name, printInSettings = false },

			{ variable = "#wf", icon = spells.wrathfulFaerie.icon, description = spells.wrathfulFaerie.name, printInSettings = true },
			{ variable = "#wrathfulFaerie", icon = spells.wrathfulFaerie.icon, description = spells.wrathfulFaerie.name, printInSettings = false },
																															  
			{ variable = "#s2m", icon = spells.s2m.icon, description = "Surrender to Madness", printInSettings = true },
			{ variable = "#surrenderToMadness", icon = spells.s2m.icon, description = "Surrender to Madness", printInSettings = false },
																															  
			{ variable = "#ecttv", icon = spells.eternalCallToTheVoid_Tendril.icon, description = spells.eternalCallToTheVoid_Tendril.name, printInSettings = true },
			{ variable = "#tb", icon = spells.eternalCallToTheVoid_Tendril.icon, description = spells.eternalCallToTheVoid_Tendril.name, printInSettings = false },
			{ variable = "#loi", icon = spells.lashOfInsanity_Tendril.icon, description = spells.lashOfInsanity_Tendril.name, printInSettings = true },
																															  
			{ variable = "#md", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = true },
			{ variable = "#massDispel", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = false }
		}
		specCache.shadow.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$insanity", description = "Current Insanity", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Insanity", printInSettings = false, color = false },
			{ variable = "$insanityMax", description = "Maximum Insanity", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Insanity", printInSettings = false, color = false },
			{ variable = "$casting", description = "Insanity from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Insanity from Passive Sources", printInSettings = true, color = false },
			{ variable = "$insanityPlusCasting", description = "Current + Casting Insanity Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Insanity Total", printInSettings = false, color = false },
			{ variable = "$insanityPlusPassive", description = "Current + Passive Insanity Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Insanity Total", printInSettings = false, color = false },
			{ variable = "$insanityTotal", description = "Current + Passive + Casting Insanity Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Insanity Total", printInSettings = false, color = false },
			{ variable = "$overcap", description = "Will hardcast spell will overcap Insanity? Logic variable only!", printInSettings = false, color = false },
			{ variable = "$resourceOvercap", description = "Will hardcast spell will overcap Insanity? Logic variable only!", printInSettings = false, color = false },
			{ variable = "$insanityOvercap", description = "Will hardcast spell will overcap Insanity? Logic variable only!", printInSettings = false, color = false },

			{ variable = "$damInsanity", description = "Insanity from Death and Madness", printInSettings = true, color = false },
			{ variable = "$damTicks", description = "Number of ticks left on Death and Madness", printInSettings = true, color = false },

			{ variable = "$mbInsanity", description = "Insanity from Mindbender/Shadowfiend (per settings)", printInSettings = true, color = false },
			{ variable = "$mbGcds", description = "Number of GCDs left on Mindbender/Shadowfiend", printInSettings = true, color = false },
			{ variable = "$mbSwings", description = "Number of Swings left on Mindbender/Shadowfiend", printInSettings = true, color = false },
			{ variable = "$mbTime", description = "Time left on Mindbender/Shadowfiend", printInSettings = true, color = false },

			{ variable = "$wfInsanity", description = "Insanity from Wrathful Faerie (per settings)", printInSettings = true, color = false },
			{ variable = "$wfGcds", description = "Number of GCDs left on Wrathful Faerie", printInSettings = true, color = false },
			{ variable = "$wfProcs", description = "Number of Procs left on Wrathful Faerie", printInSettings = true, color = false },
			{ variable = "$wfTime", description = "Time left on Wrathful Faerie", printInSettings = true, color = false },

			{ variable = "$cttvEquipped", description = "Checks if you have Call of the Void equipped. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$ecttvCount", description = "Number of active Void Tendrils/Void Lashers", printInSettings = true, color = false },
			{ variable = "$loiInsanity", description = "Insanity from all Void Tendrils and Void Lashers", printInSettings = true, color = false },
			{ variable = "$loiTicks", description = "Number of ticks remaining for all active Void Tendrils/Void Lashers", printInSettings = true, color = false },

			{ variable = "$asInsanity", description = "Insanity from Auspicious Spirits", printInSettings = true, color = false },
			{ variable = "$asCount", description = "Number of Auspicious Spirits in flight", printInSettings = true, color = false },

			{ variable = "$swpCount", description = "Number of Shadow Word: Pains active on targets", printInSettings = true, color = false },
			{ variable = "$swpTime", description = "Time remaining on Shadow Word: Pain on your current target", printInSettings = true, color = false },
			{ variable = "$vtCount", description = "Number of Vampiric Touches active on targets", printInSettings = true, color = false },
			{ variable = "$vtTime", description = "Time remaining on Vampiric Touch on your current target", printInSettings = true, color = false },
			{ variable = "$dpCount", description = "Number of Devouring Plagues active on targets", printInSettings = true, color = false },
			{ variable = "$dpTime", description = "Time remaining on Devouring Plague on your current target", printInSettings = true, color = false },

			{ variable = "$tofTime", description = "Time remaining on Twist of Fate buff", printInSettings = true, color = false },

			{ variable = "$mdTime", description = "Time remaining on Mind Devourer buff", printInSettings = true, color = false },

			{ variable = "$vfTime", description = "Duration remaining of Voidform", printInSettings = true, color = false },
			{ variable = "$hvTime", description = "Duration remaining of VF w/max VB casts in Hungering Void", printInSettings = true, color = false },
			{ variable = "$vbCasts", description = "Max Void Bolt casts remaining in Hungering Void", printInSettings = true, color = false },
			{ variable = "$hvAvgTime", description = "Duration of VF w/max VB casts in Hungering Void, includes crits", printInSettings = true, color = false },
			{ variable = "$vbAvgCasts", description = "Max Void Bolt casts remaining in Hungering Void, includes crits", printInSettings = true, color = false },

			{ variable = "$s2m", description = "Is Surrender to Madness currently talented. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$surrenderToMadness", description = "Is Surrender to Madness currently talented. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.shadow.spells = spells
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "priest"
		local specId = GetSpecialization()

		if specId == 1 then
		elseif specId == 2 then
			TRB.Data.character.specName = "holy"
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.FillSpellDataManaCost(TRB.Data.spells)

			TRB.Data.character.talents.surgeOfLight.isSelected = select(4, GetTalentInfo(5, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.bindingHeal.isSelected = select(4, GetTalentInfo(5, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.lightOfTheNaaru.isSelected = select(4, GetTalentInfo(7, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.apotheosis.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
			
			-- Legendaries
			local neckItemLink = GetInventoryItemLink("player", 2)
			local shoulderItemLink = GetInventoryItemLink("player", 3)
			local wristItemLink = GetInventoryItemLink("player", 9)
			local ring1ItemLink = GetInventoryItemLink("player", 11)
			local ring2ItemLink = GetInventoryItemLink("player", 12)
			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local harmoniousApparatus = false
			local flashConcentration = false
			local alchemyStone = false
			if neckItemLink ~= nil then
				flashConcentration = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(neckItemLink, 178927, TRB.Data.spells.flashConcentration.idLegendaryBonus)
			end

			if flashConcentration == false and wristItemLink ~= nil then
				flashConcentration = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(wristItemLink, 173249, TRB.Data.spells.flashConcentration.idLegendaryBonus)
			end
			TRB.Data.character.items.flashConcentration = flashConcentration

			if shoulderItemLink ~= nil then
				harmoniousApparatus = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(shoulderItemLink, 173247, TRB.Data.spells.harmoniousApparatus.idLegendaryBonus)
			end

			if harmoniousApparatus == false and ring1ItemLink ~= nil then
				harmoniousApparatus = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(ring1ItemLink, 178926, TRB.Data.spells.harmoniousApparatus.idLegendaryBonus)
			end

			if harmoniousApparatus == false and ring2ItemLink ~= nil then
				harmoniousApparatus = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(ring2ItemLink, 178926, TRB.Data.spells.harmoniousApparatus.idLegendaryBonus)
			end
			TRB.Data.character.items.harmoniousApparatus = harmoniousApparatus
			
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.TableLength(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.DoesItemLinkMatchId(trinket1ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
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

			TRB.Data.character.items.alchemyStone = alchemyStone
			-- Torghast
			if IsInJailersTower() then
				TRB.Data.character.torghast.dreamspunMushroomsModifier = 1 + ((select(16, TRB.Functions.FindAuraById(TRB.Data.spells.dreamspunMushrooms.id, "player", "MAW")) or 0) / 100)
			else -- Elsewhere
				TRB.Data.character.torghast.dreamspunMushroomsModifier = 1
			end
		elseif specId == 3 then
			TRB.Data.character.specName = "shadow"
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity)
			TRB.Data.character.talents.searingNightmare.isSelected = select(4, GetTalentInfo(3, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.fotm.isSelected = select(4, GetTalentInfo(1, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.as.isSelected = select(4, GetTalentInfo(5, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.mindbender.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.hungeringVoid.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.surrenderToMadeness.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))

			-- Legendaries
			local wristItemLink = GetInventoryItemLink("player", 9)
			local handsItemLink = GetInventoryItemLink("player", 10)

			local callToTheVoid = false
			if wristItemLink ~= nil then
				callToTheVoid = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(wristItemLink, 173249, TRB.Data.spells.eternalCallToTheVoid_Tendril.idLegendaryBonus)
			end

			if callToTheVoid == false and handsItemLink ~= nil then
				callToTheVoid = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(handsItemLink, 173244, TRB.Data.spells.eternalCallToTheVoid_Tendril.idLegendaryBonus)
			end
			TRB.Data.character.items.callToTheVoid = callToTheVoid
			
			-- Torghast
			if IsInJailersTower() then
				TRB.Data.character.torghast.dreamspunMushroomsModifier = 1 + ((select(16, TRB.Functions.FindAuraById(TRB.Data.spells.dreamspunMushrooms.id, "player", "MAW")) or 0) / 100)
				if TRB.Functions.FindAuraById(TRB.Data.spells.elethiumMuzzle.id, "player", "MAW") then
					TRB.Data.character.torghast.elethiumMuzzleModifier = 0.75
				else
					TRB.Data.character.torghast.elethiumMuzzleModifier = 1
				end

				if TRB.Functions.FindAuraById(TRB.Data.spells.phantasmicInfuser.id, "player", "MAW") then
					TRB.Data.character.torghast.phantasmicInfuserModifier = 0.9
				else
					TRB.Data.character.torghast.phantasmicInfuserModifier = 1
				end
			else -- Elsewhere
				TRB.Data.character.torghast.dreamspunMushroomsModifier = 1
				TRB.Data.character.torghast.elethiumMuzzleModifier = 1
				TRB.Data.character.torghast.phantasmicInfuserModifier = 1
			end

			-- Don't include Overgrowth Seedling until Blizzard fixes it to scale with Insanity.
			TRB.Data.character.devouringPlagueThreshold = 50 --* TRB.Data.character.effects.overgrowthSeedlingModifier
			TRB.Data.character.searingNightmareThreshold = 30 --* TRB.Data.character.effects.overgrowthSeedlingModifier

			-- Threshold lines
			if TRB.Data.settings.priest.shadow.devouringPlagueThreshold and TRB.Data.character.devouringPlagueThreshold < TRB.Data.character.maxResource then
				TRB.Frames.resourceFrame.thresholds[1]:Show()
				TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.priest.shadow.thresholdWidth, TRB.Data.character.devouringPlagueThreshold, TRB.Data.character.maxResource)
			else
				TRB.Frames.resourceFrame.thresholds[1]:Hide()
			end

			if TRB.Data.settings.priest.shadow.searingNightmareThreshold and TRB.Data.character.talents.searingNightmare.isSelected == true and TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id then
				TRB.Frames.resourceFrame.thresholds[2]:Show()
				TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, resourceFrame.thresholds[2], resourceFrame, TRB.Data.settings.priest.shadow.thresholdWidth, TRB.Data.character.searingNightmareThreshold, TRB.Data.character.maxResource)
			else
				TRB.Frames.resourceFrame.thresholds[2]:Hide()
			end

			TRB.Frames.resourceFrame.thresholds[3]:Hide()
			TRB.Frames.resourceFrame.thresholds[4]:Hide()
			TRB.Frames.passiveFrame.thresholds[3]:Hide()
			TRB.Frames.passiveFrame.thresholds[4]:Hide()
			TRB.Frames.passiveFrame.thresholds[5]:Hide()

		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 2 and TRB.Data.settings.core.enabled.priest.holy == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.priest.holy)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
		elseif specId == 3 and TRB.Data.settings.core.enabled.priest.shadow == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.priest.shadow)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Insanity
			TRB.Data.resourceFactor = 100
		else
			TRB.Data.specSupported = false
		end

		if TRB.Data.specSupported then
            CheckCharacter()

			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			TRB.Frames.barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			TRB.Frames.barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		else
			--TRB.Data.resource = MANA
			TRB.Data.specSupported = false
			targetsTimerFrame:SetScript("OnUpdate", nil)
			timerFrame:SetScript("OnUpdate", nil)
			TRB.Frames.barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
			TRB.Frames.barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = false
			TRB.Frames.barContainerFrame:Hide()
		end
		TRB.Functions.HideResourceBar()
	end
	TRB.Functions.EventRegistration = EventRegistration

	local function CheckVoidTendrilExists(guid)
		if guid == nil or (not TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] or TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] == nil) then
			return false
		end
		return true
	end

	local function InitializeVoidTendril(guid)
		if guid ~= nil and not CheckVoidTendrilExists(guid) then
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] = {}
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].startTime = nil
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].tickTime = nil
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].type = nil
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].targetsHit = 0
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].hasStruckTargets = false
		end
	end

	local function RemoveVoidTendril(guid)
		if guid ~= nil and CheckVoidTendrilExists(guid) then
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] = nil
		end
	end

	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()

		if specId == 2 then
			if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
				TRB.Data.snapshotData.targetData.targets[guid].shadowWordPain = false
				TRB.Data.snapshotData.targetData.targets[guid].shadowWordPainRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].hauntedMask = false
			end
		elseif specId == 3 then
			if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
				TRB.Data.snapshotData.targetData.targets[guid].auspiciousSpirits = 0
				TRB.Data.snapshotData.targetData.targets[guid].shadowWordPain = false
				TRB.Data.snapshotData.targetData.targets[guid].shadowWordPainRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].vampiricTouch = false
				TRB.Data.snapshotData.targetData.targets[guid].vampiricTouchRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].devouringPlague = false
				TRB.Data.snapshotData.targetData.targets[guid].devouringPlagueRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].hauntedMask = false
			end
		end
		TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()

		return true
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

		if specId == 2 then -- Holy
			local swpTotal = 0
			local hauntedMask = false
			for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain = false
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPainRemaining = 0
					TRB.Data.snapshotData.targetData.targets[tguid].hauntedMask = false
				else
					if TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain == true then
						swpTotal = swpTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[tguid].hauntedMask == true then
						hauntedMask = true
					end
				end
			end

			TRB.Data.snapshotData.targetData.shadowWordPain = swpTotal
			specCache.holy.snapshotData.wrathfulFaerie.hauntedMask.isActive = hauntedMask
		elseif specId == 3 then -- Shadow
			local swpTotal = 0
			local vtTotal = 0
			local asTotal = 0
			local dpTotal = 0
			local hauntedMask = false
			for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[tguid].auspiciousSpirits = 0
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain = false
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPainRemaining = 0
					TRB.Data.snapshotData.targetData.targets[tguid].vampiricTouch = false
					TRB.Data.snapshotData.targetData.targets[tguid].vampiricTouchRemaining = 0
					TRB.Data.snapshotData.targetData.targets[tguid].devouringPlague = false
					TRB.Data.snapshotData.targetData.targets[tguid].devouringPlagueRemaining = 0
					TRB.Data.snapshotData.targetData.targets[tguid].hauntedMask = false
				else
					asTotal = asTotal + TRB.Data.snapshotData.targetData.targets[tguid].auspiciousSpirits
					if TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain == true then
						swpTotal = swpTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[tguid].vampiricTouch == true then
						vtTotal = vtTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[tguid].devouringPlague == true then
						dpTotal = dpTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[tguid].hauntedMask == true then
						hauntedMask = true
					end
				end
			end

			TRB.Data.snapshotData.targetData.auspiciousSpirits = asTotal
			if TRB.Data.snapshotData.targetData.auspiciousSpirits < 0 then
				TRB.Data.snapshotData.targetData.auspiciousSpirits = 0
			end

			TRB.Data.snapshotData.targetData.shadowWordPain = swpTotal
			TRB.Data.snapshotData.targetData.vampiricTouch = vtTotal
			TRB.Data.snapshotData.targetData.devouringPlague = dpTotal
			specCache.holy.snapshotData.wrathfulFaerie.hauntedMask.isActive = hauntedMask
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 2 then
				TRB.Data.snapshotData.targetData.shadowWordPain = 0
			elseif specId == 3 then
				TRB.Data.snapshotData.targetData.shadowWordPain = 0
				TRB.Data.snapshotData.targetData.vampiricTouch = 0
				TRB.Data.snapshotData.targetData.devouringPlague = 0
				TRB.Data.snapshotData.targetData.auspiciousSpirits = 0
			end
			specCache.holy.snapshotData.wrathfulFaerie.hauntedMask.isActive = false
		end
	end

	local function ConstructResourceBar(settings)
		TRB.Functions.ConstructResourceBar(settings)
	end

	local function CalculateRemainingHungeringVoidTime()
		local currentTime = GetTime()
		local _
		local expirationTime
		_, _, _, _, TRB.Data.snapshotData.voidform.duration, expirationTime, _, _, _, TRB.Data.snapshotData.voidform.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.voidform.id)

		if TRB.Data.snapshotData.voidform.spellId == nil then
			TRB.Data.snapshotData.voidform.remainingTime = 0
			TRB.Data.snapshotData.voidform.remainingHvTime = 0
			TRB.Data.snapshotData.voidform.additionalVbCasts = 0
			TRB.Data.snapshotData.voidform.remainingHvAvgTime = 0
			TRB.Data.snapshotData.voidform.additionalVbAvgCasts = 0
			TRB.Data.snapshotData.voidform.isInfinite = false
			TRB.Data.snapshotData.voidform.isAverageInfinite = false
		else
			local remainingTime = (expirationTime - currentTime) or 0

			if TRB.Data.character.talents.hungeringVoid.isSelected == true then
				local latency = TRB.Functions.GetLatency()
				local vbStart, vbDuration, _, _ = GetSpellCooldown(TRB.Data.spells.voidBolt.id)
				local vbBaseCooldown, vbBaseGcd = GetSpellBaseCooldown(TRB.Data.spells.voidBolt.id)
				local vbCooldown = math.max(((vbBaseCooldown / (((TRB.Data.snapshotData.haste / 100) + 1) * 1000)) * TRB.Data.character.torghast.elethiumMuzzleModifier * TRB.Data.character.torghast.phantasmicInfuserModifier), 0.75) + latency
				local gcdLockRemaining = TRB.Functions.GetCurrentGCDLockRemaining()

				local castGrantsExtension = true
				--[[
				Issue #107 - Twintop 2021-01-03
					Hungering Void doesn't require the target to actually be debuffed to grant extensions.
					Change back to the code below once this is fixed by Blizz.
				----
				local targetDebuffId = select(10, TRB.Functions.FindDebuffById(TRB.Data.spells.hungeringVoid.idDebuff, "target", TRB.Data.character.guid))
				local castGrantsExtension = false

				if targetDebuffId ~= nil then
					castGrantsExtension = true
				end
				]]

				local remainingTimeTmp = remainingTime
				local remainingTimeTotal = remainingTime
				local remainingTimeTmpAverage = remainingTime
				local remainingTimeTotalAverage = remainingTime
				local moreCasts = 0
				local moreCastsAverage = 0
				local critValue = math.min((1.0 + (TRB.Data.snapshotData.crit / 100)), 2)

				if vbDuration > 0 or gcdLockRemaining > 0 then
					local vbRemaining = vbStart + vbDuration - currentTime
					local castDelay = vbRemaining

					if gcdLockRemaining > vbRemaining then
						castDelay = gcdLockRemaining
					end

					castDelay = castDelay + latency

					if remainingTimeTmp > castDelay then
						if castGrantsExtension == true then
							moreCasts = moreCasts + 1
							remainingTimeTmp = remainingTimeTmp + 1.0 - castDelay
							remainingTimeTotal = remainingTimeTotal + 1.0

							moreCastsAverage = moreCastsAverage + 1
							remainingTimeTmpAverage = remainingTimeTmpAverage + critValue - castDelay
							remainingTimeTotalAverage = remainingTimeTotalAverage + critValue
						else
							remainingTimeTmp = remainingTimeTmp - castDelay

							remainingTimeTmpAverage = remainingTimeTmpAverage - castDelay
							castGrantsExtension = true
						end
					end
				end

				-- With extremely high Haste and Crit it is possible to remain in Voidform for literally forever.

				local infiniteExtensions = false
				if vbCooldown <= 1 then
					infiniteExtensions = true
				end

				local infiniteAverageExtensions = false
				if ((2 - (2 / (vbCooldown))) * 100) < TRB.Data.snapshotData.crit then
					infiniteAverageExtensions = true
				end

				local infinityHasteRequired = vbBaseCooldown - 1

				local sanityCheckCounter = 0
				local infinityCounter = 0
				local infinityAverageCounter = 0
				local maxCounter = 25
				while (not (infiniteExtensions and infiniteAverageExtensions)) and
					  (remainingTimeTmpAverage >= vbCooldown or remainingTimeTmp >= vbCooldown) and
					  infinityCounter < maxCounter and
					  infinityAverageCounter < maxCounter and
					  sanityCheckCounter < maxCounter
				do
					sanityCheckCounter = sanityCheckCounter + 1
					if not infiniteExtensions and remainingTimeTmp >= vbCooldown then
						infinityCounter = infinityCounter + 1
						local castsRaw = math.floor(remainingTimeTmp / vbCooldown)
						local additionalCasts = castsRaw

						if castGrantsExtension == false then
							additionalCasts = math.max(additionalCasts - 1, 0)
						end
						moreCasts = moreCasts + additionalCasts
						remainingTimeTmp = remainingTimeTmp + additionalCasts - (castsRaw * vbCooldown)
						remainingTimeTotal = remainingTimeTotal + additionalCasts
					end

					if not infiniteAverageExtensions and remainingTimeTmpAverage >= vbCooldown then
						infinityAverageCounter = infinityAverageCounter + 1
						local castsAverageRaw =  math.floor(remainingTimeTmpAverage / vbCooldown)
						local additionalCastsAverage = castsAverageRaw

						if castGrantsExtension == false then
							additionalCastsAverage = math.max(additionalCastsAverage - 1, 0)
						end
						moreCastsAverage = moreCastsAverage + additionalCastsAverage
						remainingTimeTmpAverage = remainingTimeTmpAverage + (critValue * additionalCastsAverage) - (castsAverageRaw * vbCooldown)
						remainingTimeTotalAverage = remainingTimeTotalAverage + (critValue * additionalCastsAverage)
					end

					castGrantsExtension = true
				end

				TRB.Data.snapshotData.voidform.remainingTime = remainingTime or 0
				TRB.Data.snapshotData.voidform.remainingHvTime = remainingTimeTotal
				TRB.Data.snapshotData.voidform.additionalVbCasts = moreCasts
				TRB.Data.snapshotData.voidform.remainingHvAvgTime = remainingTimeTotalAverage
				TRB.Data.snapshotData.voidform.additionalVbAvgCasts = moreCastsAverage

				if sanityCheckCounter == maxCounter and sanityCheckCounter ~= infinityCounter and sanityCheckCounter ~= infinityAverageCounter then
					TRB.Data.snapshotData.voidform.isInfinite = true
					TRB.Data.snapshotData.voidform.isAverageInfinite = true
				end

				if infiniteExtensions or infinityCounter == maxCounter then
					TRB.Data.snapshotData.voidform.isInfinite = true
				end

				if infiniteAverageExtensions or infinityAverageCounter == maxCounter then
					TRB.Data.snapshotData.voidform.isAverageInfinite = true
				end
			else
				TRB.Data.snapshotData.voidform.remainingTime = remainingTime or 0
				TRB.Data.snapshotData.voidform.remainingHvTime = 0
				TRB.Data.snapshotData.voidform.additionalVbCasts = 0
				TRB.Data.snapshotData.voidform.remainingHvAvgTime = 0
				TRB.Data.snapshotData.voidform.additionalVbAvgCasts = 0
				TRB.Data.snapshotData.voidform.isInfinite = false
				TRB.Data.snapshotData.voidform.isAverageInfinite = false
			end
		end
	end

	local function GetApotheosisRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.apotheosis)
	end

	local function GetFlashConcentrationRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.flashConcentration)
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

	local function GetSurgeOfLightRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.surgeOfLight)
	end

	local function GetPotionOfSpiritualClarityRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.potionOfSpiritualClarity)
	end

	local function GetHolyWordCooldownTimeRemaining(holyWord)
		local currentTime = GetTime()
		local gcd = TRB.Functions.GetCurrentGCDTime(true)
		local remainingTime = 0

		if holyWord.duration == gcd or holyWord.startTime == nil or holyWord.startTime == 0 or holyWord.duration == 0 then
			remainingTime = 0
		else
			remainingTime = (holyWord.startTime + holyWord.duration) - currentTime
		end

		return remainingTime
	end

	local function GetHolyWordSerenityCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData.holyWordSerenity)
	end

	local function GetHolyWordSanctifyCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData.holyWordSanctify)
	end

	local function GetHolyWordChastiseCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData.holyWordChastise)
	end

	local function CalculateHolyWordCooldown(base)
		local holyOrationValue = TRB.Data.spells.holyOration.conduitRanks[TRB.Functions.GetSoulbindRank(TRB.Data.spells.holyOration.conduitId)]
		local mod = 1

		if TRB.Data.spells.apotheosis.isActive then
			mod = mod * TRB.Data.spells.apotheosis.holyWordModifier
		end

		if TRB.Data.character.talents.lightOfTheNaaru.isSelected then
			mod = mod * TRB.Data.spells.lightOfTheNaaru.holyWordModifier
		end

		mod = mod + holyOrationValue

		return mod * base
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

	local function CalculateInsanityGain(insanity, fotm)
		local modifier = 1.0

		if fotm and TRB.Data.character.talents.fotm.isSelected then
			modifier = modifier * TRB.Data.character.talents.fotm.modifier
		end

		if TRB.Data.spells.memoryOfLucidDreams.isActive then
			modifier = modifier * TRB.Data.spells.memoryOfLucidDreams.modifier
		end

		if TRB.Data.spells.s2m.isActive then
			modifier = modifier * TRB.Data.spells.s2m.modifier
		end

		return insanity * modifier
	end

	local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()

		if specId == 2 then
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
				if IsValidVariableForSpec("$pscMana") or
					IsValidVariableForSpec("$sohMana") or
					IsValidVariableForSpec("$innervateMana") or
					IsValidVariableForSpec("$wfMana") or
					IsValidVariableForSpec("$mttMana") then
					valid = true
				end
			elseif var == "$wfMana" then
				if TRB.Data.snapshotData.wrathfulFaerie.resourceRaw > 0 then
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
			elseif var == "$pscMana" then
				if TRB.Data.snapshotData.potionOfSpiritualClarity.mana > 0 then
					valid = true
				end
			elseif var == "$pscTicks" then
				if TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$pscTime" then
				if GetPotionOfSpiritualClarityRemainingTime() > 0 then
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
			elseif var == "$fcEquipped" then
				if TRB.Data.character.items.flashConcentration then
					valid = true
				end
			elseif var == "$fcStacks" then
				if TRB.Data.snapshotData.flashConcentration.stacks > 0 then
					valid = true
				end
			elseif var == "$fcTime" then
				if TRB.Data.snapshotData.flashConcentration.remainingTime > 0 then
					valid = true
				end
			elseif var == "$solStacks" then
				if TRB.Data.snapshotData.surgeOfLight.stacks > 0 then
					valid = true
				end
			elseif var == "$solTime" then
				if TRB.Data.snapshotData.surgeOfLight.remainingTime > 0 then
					valid = true
				end
			elseif var == "$apotheosisTime" then
				if TRB.Data.snapshotData.apotheosis.remainingTime > 0 then
					valid = true
				end
			elseif var == "$hwChastiseTime" then
				if GetHolyWordChastiseCooldownRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$hwSerenityTime" then
				if GetHolyWordSerenityCooldownRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$hwSanctifyTime" then
				if GetHolyWordSanctifyCooldownRemainingTime() > 0 then
					valid = true
				end
			end
		elseif specId == 3 then
			if var == "$vfTime" then
				if TRB.Data.snapshotData.voidform.remainingTime ~= nil and TRB.Data.snapshotData.voidform.remainingTime > 0 then
					valid = true
				end
			elseif var == "$hvAvgTime" then
				if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvAvgTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvAvgTime > 0 or TRB.Data.snapshotData.voidform.isAverageInfinite) then
					valid = true
				end
			elseif var == "$vbAvgCasts" then
				if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvAvgTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvAvgTime > 0 or TRB.Data.snapshotData.voidform.isAverageInfinite) then
					valid = true
				end
			elseif var == "$hvTime" then
				if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvTime > 0 or TRB.Data.snapshotData.voidform.isInfinite) then
					valid = true
				end
			elseif var == "$vbCasts" then
				if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvTime > 0 or TRB.Data.snapshotData.voidform.isInfinite) then
					valid = true
				end
			elseif var == "$resource" or var == "$insanity" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$insanityMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$insanityTotal" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id)) or
					(((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false) + TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw) > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$insanityPlusCasting" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id)) then
					valid = true
				end
			elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
				if ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.settings.priest.shadow.overcapThreshold then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$insanityPlusPassive" then
				if TRB.Data.snapshotData.resource > 0 or
					((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false) + TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw) > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id) then
					valid = true
				end
			elseif var == "$passive" then
				if ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false) + TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw) > 0 then
					valid = true
				end
			elseif var == "$mbInsanity" then
				if TRB.Data.snapshotData.mindbender.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$mbGcds" then
				if TRB.Data.snapshotData.mindbender.remaining.gcds > 0 then
					valid = true
				end
			elseif var == "$mbSwings" then
				if TRB.Data.snapshotData.mindbender.remaining.swings > 0 then
					valid = true
				end
			elseif var == "$mbTime" then
				if TRB.Data.snapshotData.mindbender.remaining.time > 0 then
					valid = true
				end
			elseif var == "$wfInsanity" then
				if TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$loiInsanity" then
				if TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal > 0 then
					valid = true
				end
			elseif var == "$loiTicks" then
				if TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining > 0 then
					valid = true
				end
			elseif var == "$cttvEquipped" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and TRB.Data.character.items.callToTheVoid == true then
					valid = true
				end
			elseif var == "$ecttvCount" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and TRB.Data.snapshotData.eternalCallToTheVoid.numberActive > 0 then
					valid = true
				end
			elseif var == "$damInsanity" then
				if TRB.Data.snapshotData.deathAndMadness.insanity > 0 then
					valid = true
				end
			elseif var == "$damTicks" then
				if TRB.Data.snapshotData.deathAndMadness.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$asCount" then
				if TRB.Data.snapshotData.targetData.auspiciousSpirits > 0 then
					valid = true
				end
			elseif var == "$asInsanity" then
				if TRB.Data.snapshotData.targetData.auspiciousSpirits > 0 then
					valid = true
				end
			elseif var == "$vtCount" then
				if TRB.Data.snapshotData.targetData.vampiricTouch > 0 then
					valid = true
				end
			elseif var == "$vtTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouchRemaining > 0 then
					valid = true
				end
			elseif var == "$dpCount" then
				if TRB.Data.snapshotData.targetData.devouringPlague > 0 then
					valid = true
				end
			elseif var == "$dpTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].devouringPlagueRemaining > 0 then
					valid = true
				end
			elseif var == "$mdTime" then
				if TRB.Data.snapshotData.mindDevourer.spellId ~= nil then
					valid = true
				end
			elseif var == "$tofTime" then
				if TRB.Data.snapshotData.twistOfFate.spellId ~= nil then
					valid = true
				end
			elseif var == "$s2m" or var == "$surrenderToMadness" then
				if TRB.Data.character.talents.surrenderToMadeness.isSelected then
					valid = true
				end
			else
				valid = false
			end
		end

		-- Spec Agnostic
		if var == "$wfGcds" then
			if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds > 0 then
				valid = true
			end
		elseif var == "$wfProcs" then
			if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs > 0 then
				valid = true
			end
		elseif var == "$wfTime" then
			if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time > 0 then
				valid = true
			end
		elseif var == "$swpCount" then
			if TRB.Data.snapshotData.targetData.shadowWordPain > 0 then
				valid = true
			end
		elseif var == "$swpTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining > 0 then
				valid = true
			end
		end
		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Holy()
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.priest.holy.colors.text.current
		local castingManaColor = TRB.Data.settings.priest.holy.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.priest.holy.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor"))
		--$casting
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.ConvertToShortNumberNotation(TRB.Data.snapshotData.casting.resourceFinal, manaPrecision, "floor"))

		--$wfMana
		local _wfMana = TRB.Data.snapshotData.wrathfulFaerie.resourceFinal
		local wfMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_wfMana, manaPrecision, "floor"))
		--$wfGcds
		local wfGcds = string.format("%.0f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds))
		--$wfProcs
		local wfProcs = string.format("%.0f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs))
		--$wfTime
		local wfTime = string.format("%.1f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds))

		--$sohMana
		local _sohMana = TRB.Data.snapshotData.symbolOfHope.resourceFinal
		local sohMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor"))
		--$sohTicks
		local sohTicks = string.format("%.0f", TRB.Data.snapshotData.symbolOfHope.ticksRemaining)
		--$sohTime
		local sohTime = string.format("%.1f", GetSymbolOfHopeRemainingTime())

		--$innervateMana
		local _innervateMana = TRB.Data.snapshotData.innervate.mana
		local innervateMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor"))
		--$innervateTime
		local innervateTime = string.format("%.1f", GetInnervateRemainingTime())

		--$mttMana
		local _mttMana = TRB.Data.snapshotData.symbolOfHope.resourceFinal
		local mttMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor"))
		--$mttTime
		local mttTime = string.format("%.1f", GetManaTideTotemRemainingTime())

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

		--$pscMana
		local _pscMana = CalculateManaGain(TRB.Data.snapshotData.potionOfSpiritualClarity.mana, true)
		local pscMana = string.format("%s", TRB.Functions.ConvertToShortNumberNotation(_pscMana, manaPrecision, "floor"))
		--$pscTicks
		local pscTicks = string.format("%.0f", TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining)
		--$pscTime
		local _pscTime = GetPotionOfSpiritualClarityRemainingTime()
		local pscTime = string.format("%.1f", _pscTime)
		--$passive
		local _passiveMana = _wfMana + _sohMana + _pscMana + _innervateMana + _mttMana
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.priest.holy.colors.text.passive, TRB.Functions.ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor"))
		--$manaTotal
		local _manaTotal = math.min(_passiveMana + TRB.Data.snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor"))
		--$manaPlusCasting
		local _manaPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor"))
		--$manaPlusPassive
		local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor"))

		--$manaMax
		local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor"))

		--$manaPercent
		local maxResource = TRB.Data.character.maxResource

		if maxResource == 0 then
			maxResource = 1
		end
		local manaPercent = string.format("|c%s%s|r", currentManaColor, TRB.Functions.RoundTo((normalizedMana/maxResource)*100, manaPrecision, "floor"))

		--$hwChastiseTime
		local _hwChastiseTime = GetHolyWordChastiseCooldownRemainingTime()
		local hwChastiseTime = string.format("%.1f", _hwChastiseTime)

		--$hwSanctifyTime
		local _hwSanctifyTime = GetHolyWordSanctifyCooldownRemainingTime()
		local hwSanctifyTime = string.format("%.1f", _hwSanctifyTime)

		--$hwSerenityTime
		local _hwSerenityTime = GetHolyWordSerenityCooldownRemainingTime()
		local hwSerenityTime = string.format("%.1f", _hwSerenityTime)

		--$apotheosisTime
		local _apotheosisTime = TRB.Data.snapshotData.apotheosis.remainingTime
		local apotheosisTime = string.format("%.1f", _apotheosisTime)

		--$solStacks
		local solStacks = string.format("%.0f", TRB.Data.snapshotData.surgeOfLight.stacks or 0)
		--$solTime
		local solTime = string.format("%.1f", TRB.Data.snapshotData.surgeOfLight.remainingTime or 0)

		--$fcStacks
		local fcStacks = string.format("%.0f", TRB.Data.snapshotData.flashConcentration.stacks or 0)
		--$fcTime
		local fcTime = string.format("%.1f", TRB.Data.snapshotData.flashConcentration.remainingTime or 0)

		-----------
		--$swpCount and $swpTime
		local _shadowWordPainCount = TRB.Data.snapshotData.targetData.shadowWordPain or 0
		local shadowWordPainCount = _shadowWordPainCount
		local _shadowWordPainTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_shadowWordPainTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining or 0
		end

		local shadowWordPainTime

		if TRB.Data.settings.priest.holy.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPain then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining > TRB.Data.spells.shadowWordPain.pandemicTime then
					shadowWordPainCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.holy.colors.text.dots.up, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.holy.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining)
				else
					shadowWordPainCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.holy.colors.text.dots.pandemic, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.holy.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining)
				end
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.holy.colors.text.dots.down, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.holy.colors.text.dots.down, 0)
			end
		else
			shadowWordPainTime = string.format("%.1f", _shadowWordPainTime)
		end

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.wrathfulFaerie = _wfMana or 0
		Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _pscMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.wrathfulFaerie = {
			mana = _wfMana,
			main = {
				mana = TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds or 0,
				procs = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs or 0,
				time = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time or 0
			},
			fermata = {
				mana = TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds or 0,
				procs = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs or 0,
				time = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time or 0
			}
		}
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _pscMana,
			ticks = TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = TRB.Data.snapshotData.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#apotheosis"] = TRB.Data.spells.apotheosis.icon
		lookup["#bh"] = TRB.Data.spells.bindingHeal.icon
		lookup["#bindingHeal"] = TRB.Data.spells.bindingHeal.icon
		lookup["#coh"] = TRB.Data.spells.circleOfHealing.icon
		lookup["#circleOfHealing"] = TRB.Data.spells.circleOfHealing.icon
		lookup["#fc"] = TRB.Data.spells.flashConcentration.icon
		lookup["#flashConcentration"] = TRB.Data.spells.flashConcentration.icon
		lookup["#flashHeal"] = TRB.Data.spells.flashHeal.icon
		lookup["#ha"] = TRB.Data.spells.harmoniousApparatus.icon
		lookup["#harmoniousApparatus"] = TRB.Data.spells.harmoniousApparatus.icon
		lookup["#heal"] = TRB.Data.spells.heal.icon
		lookup["#hf"] = TRB.Data.spells.holyFire.icon
		lookup["#holyFire"] = TRB.Data.spells.holyFire.icon
		lookup["#ho"] = TRB.Data.spells.holyOration.icon
		lookup["#holyOration"] = TRB.Data.spells.holyOration.icon
		lookup["#hwChastise"] = TRB.Data.spells.holyWordChastise.icon
		lookup["#chastise"] = TRB.Data.spells.holyWordChastise.icon
		lookup["#holyWordChastise"] = TRB.Data.spells.holyWordChastise.icon
		lookup["#hwSanctify"] = TRB.Data.spells.holyWordSanctify.icon
		lookup["#sanctify"] = TRB.Data.spells.holyWordSanctify.icon
		lookup["#holyWordSanctify"] = TRB.Data.spells.holyWordSanctify.icon
		lookup["#hwSerenity"] = TRB.Data.spells.holyWordSerenity.icon
		lookup["#serenity"] = TRB.Data.spells.holyWordSerenity.icon
		lookup["#holyWordSerenity"] = TRB.Data.spells.holyWordSerenity.icon
		lookup["#innervate"] = TRB.Data.spells.innervate.icon
		lookup["#lotn"] = TRB.Data.spells.lightOfTheNaaru.icon
		lookup["#lightOfTheNaaru"] = TRB.Data.spells.lightOfTheNaaru.icon
		lookup["#mtt"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#poh"] = TRB.Data.spells.prayerOfHealing.icon
		lookup["#prayerOfHealing"] = TRB.Data.spells.prayerOfHealing.icon
		lookup["#pom"] = TRB.Data.spells.prayerOfMending.icon
		lookup["#prayerOfMending"] = TRB.Data.spells.prayerOfMending.icon
		lookup["#renew"] = TRB.Data.spells.renew.icon
		lookup["#smite"] = TRB.Data.spells.smite.icon
		lookup["#soh"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#sol"] = TRB.Data.spells.surgeOfLight.icon
		lookup["#surgeOfLight"] = TRB.Data.spells.surgeOfLight.icon
		lookup["#wf"] = TRB.Data.spells.wrathfulFaerie.icon
		lookup["#wrathfulFaerie"] = TRB.Data.spells.wrathfulFaerie.icon
		lookup["#psc"] = TRB.Data.spells.potionOfSpiritualClarity.icon
		lookup["#potionOfSpiritualClarity"] = TRB.Data.spells.potionOfSpiritualClarity.icon
		--lookup["#srp"] = TRB.Data.spells.spiritualRejuvenationPotion.icon
		--lookup["#spiritualRejuvenationPotion"] = TRB.Data.spells.spiritualRejuvenationPotion.icon
		--lookup["#spiritualManaPotion"] = TRB.Data.spells.spiritualManaPotion.icon
		--lookup["#soulfulManaPotion"] = TRB.Data.spells.soulfulManaPotion.icon
		
		lookup["#swp"] = TRB.Data.spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = TRB.Data.spells.shadowWordPain.icon

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

		lookup["$hwChastiseTime"] = hwChastiseTime
		lookup["$chastiseTime"] = hwChastiseTime
		lookup["$holyWordChastiseTime"] = hwChastiseTime

		lookup["$hwSanctifyTime"] = hwSanctifyTime
		lookup["$sanctifyTime"] = hwSanctifyTime
		lookup["$holyWordSanctifyTime"] = hwSanctifyTime

		lookup["$hwSerenityTime"] = hwSerenityTime
		lookup["$serenityTime"] = hwSerenityTime
		lookup["$holyWordSerenityTime"] = hwSerenityTime

		lookup["$wfMana"] = wfMana
		lookup["$wfGcds"] = wfGcds
		lookup["$wfProcs"] = wfProcs
		lookup["$wfTime"] = wfTime
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$pscMana"] = pscMana
		lookup["$pscTicks"] = pscTicks
		lookup["$pscTime"] = pscTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		
		lookup["$fcEquipped"] = TRB.Data.character.items.flashConcentration
		lookup["$fcStacks"] = fcStacks
		lookup["$fcTime"] = fcTime

		lookup["$solStacks"] = solStacks
		lookup["$solTime"] = solTime
		lookup["$apotheosisTime"] = apotheosisTime

		lookup["$swpCount"] = shadowWordPainCount
		lookup["$swpTime"] = shadowWordPainTime

		TRB.Data.lookup = lookup
	end

	local function RefreshLookupData_Shadow()
		local currentTime = GetTime()
		local normalizedInsanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		--$vfTime
		local voidformTime = string.format("%.1f", TRB.Data.snapshotData.voidform.remainingTime)
		--$hvTime
		local hungeringVoidTime = string.format("%.1f", TRB.Data.snapshotData.voidform.remainingHvTime)
		--$vbCasts
		local voidBoltCasts = string.format("%.0f", TRB.Data.snapshotData.voidform.additionalVbCasts)
		--$hvAvgTime
		local hungeringVoidTimeAvg = string.format("%.1f", TRB.Data.snapshotData.voidform.remainingHvAvgTime)
		--$vbAvgCasts
		local voidBoltCastsAvg = string.format("%.0f", TRB.Data.snapshotData.voidform.additionalVbAvgCasts)

		if TRB.Data.snapshotData.voidform.isInfinite then
			hungeringVoidTime = "∞"
			voidBoltCasts = "∞"
		end

		if TRB.Data.snapshotData.voidform.isAverageInfinite then
			hungeringVoidTimeAvg = "∞"
			voidBoltCastsAvg = "∞"
		end

		----------

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.currentInsanity
		local castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.castingInsanity

		local insanityThreshold = TRB.Data.character.devouringPlagueThreshold

		if TRB.Data.settings.priest.shadow.searingNightmareThreshold and TRB.Data.character.talents.searingNightmare.isSelected == true and TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id then
			insanityThreshold = TRB.Data.character.searingNightmareThreshold
		end

		if TRB.Data.settings.priest.shadow.colors.text.overcapEnabled and overcap then
			currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overcapInsanity
			castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overcapInsanity
		elseif TRB.Data.settings.priest.shadow.colors.text.overThresholdEnabled and normalizedInsanity >= insanityThreshold then
			currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overThreshold
			castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overThreshold
		end

		--$insanity
		local insanityPrecision = TRB.Data.settings.priest.shadow.insanityPrecision or 0
		local currentInsanity = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.RoundTo(normalizedInsanity, insanityPrecision, "floor"))
		--$casting
		local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, insanityPrecision, "floor"))
		--$mbInsanity
		local mbInsanity = string.format("%.0f", TRB.Data.snapshotData.mindbender.resourceFinal)
		--$mbGcds
		local mbGcds = string.format("%.0f", TRB.Data.snapshotData.mindbender.remaining.gcds)
		--$mbSwings
		local mbSwings = string.format("%.0f", TRB.Data.snapshotData.mindbender.remaining.swings)
		--$mbTime
		local mbTime = string.format("%.1f", TRB.Data.snapshotData.mindbender.remaining.time)
		--$wfInsanity
		local _wfInsanity = TRB.Data.snapshotData.wrathfulFaerie.resourceFinal
		local wfInsanity = string.format("%s", TRB.Functions.RoundTo(_wfInsanity, insanityPrecision, "floor"))
		--$wfGcds
		local wfGcds = string.format("%.0f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds))
		--$wfProcs
		local wfProcs = string.format("%.0f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs))
		--$wfTime
		local wfTime = string.format("%.1f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds))
		--$loiInsanity
		local loiInsanity = string.format("%.0f", TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal)
		--$loiTicks
		local loiTicks = string.format("%.0f", TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining)
		--$ecttvCount
		local ecttvCount = string.format("%.0f", TRB.Data.snapshotData.eternalCallToTheVoid.numberActive)
		--$asCount
		local asCount = string.format("%.0f", TRB.Data.snapshotData.targetData.auspiciousSpirits)
		--$damInsanity
		local _damInsanity = CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false)
		local damInsanity = string.format("%.0f", _damInsanity)
		--$damStacks
		local damTicks = string.format("%.0f", TRB.Data.snapshotData.deathAndMadness.ticksRemaining)
		--$asInsanity
		local _asInsanity = CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits
		local asInsanity = string.format("%.0f", _asInsanity)
		--$passive
		local _passiveInsanity = _asInsanity + TRB.Data.snapshotData.mindbender.resourceFinal + _damInsanity + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal
		local passiveInsanity = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.passiveInsanity, _passiveInsanity)
		--$insanityTotal
		local _insanityTotal = math.min(_passiveInsanity + TRB.Data.snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityTotal = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.RoundTo(_insanityTotal, insanityPrecision, "floor"))
		--$insanityPlusCasting
		local _insanityPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusCasting = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.RoundTo(_insanityPlusCasting, insanityPrecision, "floor"))
		--$insanityPlusPassive
		local _insanityPlusPassive = math.min(_passiveInsanity + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusPassive = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.RoundTo(_insanityPlusPassive, insanityPrecision, "floor"))


		----------
		--$swpCount and $swpTime
		local _shadowWordPainCount = TRB.Data.snapshotData.targetData.shadowWordPain or 0
		local shadowWordPainCount = _shadowWordPainCount
		local _shadowWordPainTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_shadowWordPainTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining or 0
		end

		local shadowWordPainTime

		--$vtCount and $vtTime
		local _vampiricTouchCount = TRB.Data.snapshotData.targetData.vampiricTouch or 0
		local vampiricTouchCount = _vampiricTouchCount
		local _vampiricTouchTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_vampiricTouchTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouchRemaining or 0
		end

		local vampiricTouchTime

		--$dpTime
		local devouringPlagueTime
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			devouringPlagueTime = string.format("%.1f", TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].devouringPlagueRemaining or 0)
		else
			devouringPlagueTime = string.format("%.1f", 0)
		end

		if TRB.Data.settings.priest.shadow.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPain then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining > TRB.Data.spells.shadowWordPain.pandemicTime then
					shadowWordPainCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.dots.up, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.shadow.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining)
				else
					shadowWordPainCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.dots.pandemic, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.shadow.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining)
				end
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.dots.down, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.shadow.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouch then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouchRemaining > TRB.Data.spells.vampiricTouch.pandemicTime then
					vampiricTouchCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.dots.up, _vampiricTouchCount)
					vampiricTouchTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.shadow.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouchRemaining)
				else
					vampiricTouchCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.dots.pandemic, _vampiricTouchCount)
					vampiricTouchTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.shadow.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouchRemaining)
				end
			else
				vampiricTouchCount = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.dots.down, _vampiricTouchCount)
				vampiricTouchTime = string.format("|c%s%.1f|r", TRB.Data.settings.priest.shadow.colors.text.dots.down, 0)
			end
		else
			shadowWordPainTime = string.format("%.1f", _shadowWordPainTime)
			vampiricTouchTime = string.format("%.1f", _vampiricTouchTime)
		end

		--$dpCount
		local devouringPlagueCount = TRB.Data.snapshotData.targetData.devouringPlague or 0

		--$mdTime
		local _mdTime = 0
		if TRB.Data.snapshotData.mindDevourer.spellId ~= nil then
			_mdTime = math.abs(TRB.Data.snapshotData.mindDevourer.endTime - currentTime)
		end
		local mdTime = string.format("%.1f", _mdTime)

		--$tofTime
		local _tofTime = 0
		if TRB.Data.snapshotData.twistOfFate.spellId ~= nil then
			_tofTime = math.abs(TRB.Data.snapshotData.twistOfFate.endTime - currentTime)
		end
		local tofTime = string.format("%.1f", _tofTime)

		----------

		--We have extra custom stuff we want to do with TTD for Priests
		--$ttd
		local _ttd = ""
		local ttd = ""
		local ttdTotalSeconds = 0

		if TRB.Data.snapshotData.targetData.ttdIsActive and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ttd ~= 0 then
			local target = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid]
			local ttdMinutes = math.floor(target.ttd / 60)
			local ttdSeconds = target.ttd % 60
			_ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)

			local _ttdColor = TRB.Data.settings.priest.shadow.colors.text.left
			local s2mStart, s2mDuration, _, _ = GetSpellCooldown(TRB.Data.spells.s2m.id)

			if TRB.Data.character.talents.surrenderToMadeness.isSelected and not TRB.Data.snapshotData.voidform.s2m.active then
				if TRB.Data.settings.priest.shadow.s2mThreshold <= target.ttd then
					_ttdColor = TRB.Data.settings.priest.shadow.colors.text.s2mAbove
				elseif TRB.Data.settings.priest.shadow.s2mApproachingThreshold <= target.ttd then
					_ttdColor = TRB.Data.settings.priest.shadow.colors.text.s2mApproaching
				else
					_ttdColor = TRB.Data.settings.priest.shadow.colors.text.s2mBelow
				end

				ttd = string.format("|c%s%d:%0.2d|c%s", _ttdColor, ttdMinutes, ttdSeconds, TRB.Data.settings.priest.shadow.colors.text.left)
				ttdTotalSeconds = string.format("|c%s%s|c%s", _ttdColor, TRB.Functions.RoundTo(target.ttd, TRB.Data.settings.core.ttd.precision or 1, "floor"), TRB.Data.settings.priest.shadow.colors.text.left)
			else
				ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)
				ttdTotalSeconds = string.format("%s", TRB.Functions.RoundTo(target.ttd, TRB.Data.settings.core.ttd.precision or 1, "floor"))
			end
		else
			ttd = "--"
			ttdTotalSeconds = string.format("%s", TRB.Functions.RoundTo(0, TRB.Data.settings.core.ttd.precision or 1, "floor"))
		end

		----------------------------

		Global_TwintopInsanityBar = {
			ttd = ttd or "--",
			voidform = {
				hungeringVoid = {
					timeRemaining = TRB.Data.snapshotData.voidform.remainingHvTime,
					voidBoltCasts = TRB.Data.snapshotData.voidform.additionalVbCasts,
					TimeRemainingAverage = TRB.Data.snapshotData.voidform.remainingHvAvgTime,
					voidBoltCastsAverage = TRB.Data.snapshotData.voidform.additionalVbAvgCasts
				}
			},
			insanity = {
				insanity = (TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) or 0,
				casting = TRB.Data.snapshotData.casting.resourceFinal or 0,
				passive = _passiveInsanity,
				auspiciousSpirits = _asInsanity,
				mindbender = TRB.Data.snapshotData.mindbender.resourceFinal or 0,
				deathAndMadness = _damInsanity,
				ecttv = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0
			},
			auspiciousSpirits = {
				count = TRB.Data.snapshotData.targetData.auspiciousSpirits or 0,
				insanity = _asInsanity
			},
			dots = {
				swpCount = _shadowWordPainCount or 0,
				vtCount = _vampiricTouchCount or 0,
				dpCount = devouringPlagueCount or 0
			},
			mindbender = {
				insanity = TRB.Data.snapshotData.mindbender.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.mindbender.remaining.gcds or 0,
				swings = TRB.Data.snapshotData.mindbender.remaining.swings or 0,
				time = TRB.Data.snapshotData.mindbender.remaining.time or 0
			},
			mindSear = {
				targetsHit = TRB.Data.snapshotData.mindSear.targetsHit or 0
			},
			deathAndMadness = {
				insanity = _damInsanity,
				ticks = TRB.Data.snapshotData.deathAndMadness.ticksRemaining or 0
			},
			eternalCallToTheVoid = {
				insanity = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0,
				ticks = TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining or 0,
				count = TRB.Data.snapshotData.eternalCallToTheVoid.numberActive or 0
			}
		}

		Global_TwintopResourceBar.voidform = {
			hungeringVoid = {
				timeRemaining = TRB.Data.snapshotData.voidform.remainingHvTime,
				voidBoltCasts = TRB.Data.snapshotData.voidform.additionalVbCasts,
				TimeRemainingAverage = TRB.Data.snapshotData.voidform.remainingHvAvgTime,
				voidBoltCastsAverage = TRB.Data.snapshotData.voidform.additionalVbAvgCasts,
				isInfinite = TRB.Data.snapshotData.voidform.isInfinite,
				isAverageInfinite = TRB.Data.snapshotData.voidform.isAverageInfinite
			}
		}
		Global_TwintopResourceBar.resource.passive = _passiveInsanity
		Global_TwintopResourceBar.resource.auspiciousSpirits = _asInsanity
		Global_TwintopResourceBar.resource.mindbender = TRB.Data.snapshotData.mindbender.resourceFinal or 0
		Global_TwintopResourceBar.resource.deathAndMadness = _damInsanity
		Global_TwintopResourceBar.resource.ecttv = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0
		Global_TwintopResourceBar.resource.wrathfulFaerie = _wfInsanity or 0
		Global_TwintopResourceBar.auspiciousSpirits = {
			count = TRB.Data.snapshotData.targetData.auspiciousSpirits or 0,
			insanity = _asInsanity
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0,
			vtCount = _vampiricTouchCount or 0,
			dpCount = devouringPlagueCount or 0
		}
		Global_TwintopResourceBar.mindbender = {
			insanity = TRB.Data.snapshotData.mindbender.resourceFinal or 0,
			gcds = TRB.Data.snapshotData.mindbender.remaining.gcds or 0,
			swings = TRB.Data.snapshotData.mindbender.remaining.swings or 0,
			time = TRB.Data.snapshotData.mindbender.remaining.time or 0
		}
		Global_TwintopResourceBar.mindSear = {
			targetsHit = TRB.Data.snapshotData.mindSear.targetsHit or 0
		}
		Global_TwintopResourceBar.deathAndMadness = {
			insanity = _damInsanity,
			ticks = TRB.Data.snapshotData.deathAndMadness.ticksRemaining or 0
		}
		Global_TwintopResourceBar.eternalCallToTheVoid = {
			insanity = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0,
			ticks = TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining or 0,
			count = TRB.Data.snapshotData.eternalCallToTheVoid.numberActive or 0
		}
		Global_TwintopResourceBar.wrathfulFaerie = {
			insanity = _wfInsanity,
			main = {
				insanity = TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds or 0,
				procs = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs or 0,
				time = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time or 0
			},
			fermata = {
				insanity = TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds or 0,
				procs = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs or 0,
				time = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time or 0
			}
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#as"] = TRB.Data.spells.auspiciousSpirits.icon
		lookup["#auspiciousSpirits"] = TRB.Data.spells.auspiciousSpirits.icon
		lookup["#sa"] = TRB.Data.spells.shadowyApparition.icon
		lookup["#shadowyApparition"] = TRB.Data.spells.shadowyApparition.icon
		lookup["#mb"] = TRB.Data.spells.mindBlast.icon
		lookup["#mindBlast"] = TRB.Data.spells.mindBlast.icon
		lookup["#mf"] = TRB.Data.spells.mindFlay.icon
		lookup["#mindFlay"] = TRB.Data.spells.mindFlay.icon
		lookup["#ms"] = TRB.Data.spells.mindSear.icon
		lookup["#mindSear"] = TRB.Data.spells.mindSear.icon
		lookup["#mindbender"] = TRB.Data.spells.mindbender.icon
		lookup["#shadowfiend"] = TRB.Data.spells.shadowfiend.icon
		lookup["#wf"] = TRB.Data.spells.wrathfulFaerie.icon
		lookup["#wrathfulFaerie"] = TRB.Data.spells.wrathfulFaerie.icon
		lookup["#sf"] = TRB.Data.spells.shadowfiend.icon
		lookup["#ecttv"] = TRB.Data.spells.eternalCallToTheVoid_Tendril.icon
		lookup["#tb"] = TRB.Data.spells.eternalCallToTheVoid_Tendril.icon
		lookup["#loi"] = TRB.Data.spells.lashOfInsanity_Tendril.icon
		lookup["#vf"] = TRB.Data.spells.voidform.icon
		lookup["#voidform"] = TRB.Data.spells.voidform.icon
		lookup["#vb"] = TRB.Data.spells.voidBolt.icon
		lookup["#voidBolt"] = TRB.Data.spells.voidBolt.icon
		lookup["#vt"] = TRB.Data.spells.vampiricTouch.icon
		lookup["#vampiricTouch"] = TRB.Data.spells.vampiricTouch.icon
		lookup["#swp"] = TRB.Data.spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = TRB.Data.spells.shadowWordPain.icon
		lookup["#dp"] = TRB.Data.spells.devouringPlague.icon
		lookup["#devouringPlague"] = TRB.Data.spells.devouringPlague.icon
		lookup["#mDev"] = TRB.Data.spells.mindDevourer.icon
		lookup["#mindDevourer"] = TRB.Data.spells.mindDevourer.icon
		lookup["#tof"] = TRB.Data.spells.twistOfFate.icon
		lookup["#twistOfFate"] = TRB.Data.spells.twistOfFate.icon
		lookup["#md"] = TRB.Data.spells.massDispel.icon
		lookup["#massDispel"] = TRB.Data.spells.massDispel.icon
		lookup["#dam"] = TRB.Data.spells.deathAndMadness.icon
		lookup["#deathAndMadness"] = TRB.Data.spells.deathAndMadness.icon
		lookup["$swpCount"] = shadowWordPainCount
		lookup["$swpTime"] = shadowWordPainTime
		lookup["$vtCount"] = vampiricTouchCount
		lookup["$vtTime"] = vampiricTouchTime
		lookup["$dpCount"] = devouringPlagueCount
		lookup["$dpTime"] = devouringPlagueTime
		lookup["$mdTime"] = mdTime
		lookup["$tofTime"] = tofTime
		lookup["$vfTime"] = voidformTime
		lookup["$hvTime"] = hungeringVoidTime
		lookup["$vbCasts"] = voidBoltCasts
		lookup["$hvAvgTime"] = hungeringVoidTimeAvg
		lookup["$vbAvgCasts"] = voidBoltCastsAvg
		lookup["$insanityPlusCasting"] = insanityPlusCasting
		lookup["$insanityPlusPassive"] = insanityPlusPassive
		lookup["$insanityTotal"] = insanityTotal
		lookup["$insanityMax"] = TRB.Data.character.maxResource
		lookup["$insanity"] = currentInsanity
		lookup["$resourcePlusCasting"] = insanityPlusCasting
		lookup["$resourcePlusPassive"] = insanityPlusPassive
		lookup["$resourceTotal"] = insanityTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentInsanity
		lookup["$casting"] = castingInsanity
		lookup["$passive"] = passiveInsanity
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$insanityOvercap"] = overcap
		lookup["$mbInsanity"] = mbInsanity
		lookup["$mbGcds"] = mbGcds
		lookup["$mbSwings"] = mbSwings
		lookup["$mbTime"] = mbTime
		lookup["$wfInsanity"] = wfInsanity
		lookup["$wfGcds"] = wfGcds
		lookup["$wfProcs"] = wfProcs
		lookup["$wfTime"] = wfTime
		lookup["$loiInsanity"] = loiInsanity
		lookup["$loiTicks"] = loiTicks
		lookup["$cttvEquipped"] = ""
		lookup["$ecttvCount"] = ecttvCount
		lookup["$damInsanity"] = damInsanity
		lookup["$damTicks"] = damTicks
		lookup["$asCount"] = asCount
		lookup["$asInsanity"] = asInsanity
		lookup["$ttd"] = ttd --Custom TTD for Shadow
		lookup["$ttdSeconds"] = ttdTotalSeconds
		lookup["$s2m"] = ""
		lookup["$surrenderToMadness"] = ""
		TRB.Data.lookup = lookup
	end

	local function UpdateCastingResourceFinal_Holy()
		-- Do nothing for now
		TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw
	end

	local function UpdateCastingResourceFinal_Shadow(fotm)
		TRB.Data.snapshotData.casting.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.casting.resourceRaw, fotm)
		CalculateRemainingHungeringVoidTime()
	end

	local function CastingSpell()
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 2 then				
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.symbolOfHope.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.symbolOfHope.id
						TRB.Data.snapshotData.casting.startTime = currentChannelStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentChannelEndTime / 1000
						TRB.Data.snapshotData.casting.resourceRaw = 0
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.symbolOfHope.icon
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.GetSpellManaCost(spellId) * TRB.Data.character.effects.overgrowthSeedlingModifier

						TRB.Data.snapshotData.casting.startTime = currentSpellStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentSpellEndTime / 1000
						TRB.Data.snapshotData.casting.resourceRaw = manaCost
						TRB.Data.snapshotData.casting.spellId = spellId
						TRB.Data.snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Holy()
						if currentSpellId == TRB.Data.spells.heal.id then
							TRB.Data.snapshotData.casting.spellKey = "heal"
						elseif currentSpellId == TRB.Data.spells.flashHeal.id then
							TRB.Data.snapshotData.casting.spellKey = "flashHeal"
						elseif currentSpellId == TRB.Data.spells.prayerOfHealing.id then
							TRB.Data.snapshotData.casting.spellKey = "prayerOfHealing"
						elseif currentSpellId == TRB.Data.spells.renew.id then --This shouldn't happen
							TRB.Data.snapshotData.casting.spellKey = "renew"
						elseif currentSpellId == TRB.Data.spells.smite.id then
							TRB.Data.snapshotData.casting.spellKey = "smite"
						elseif currentSpellId == TRB.Data.spells.bindingHeal.id then --If talented
							TRB.Data.snapshotData.casting.spellKey = "bindingHeal"
						elseif TRB.Data.character.items.harmoniousApparatus then
							if currentSpellId == TRB.Data.spells.circleOfHealing.id then --Harmonious Apparatus / This shouldn't happen
								TRB.Data.snapshotData.casting.spellKey = "circleOfHealing"
							elseif currentSpellId == TRB.Data.spells.prayerOfMending.id then --Harmonious Apparatus / This shouldn't happen
								TRB.Data.snapshotData.casting.spellKey = "prayerOfMending"
							elseif currentSpellId == TRB.Data.spells.holyFire.id then --Harmonious Apparatus
								TRB.Data.snapshotData.casting.spellKey = "holyFire"
							end
						end
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 3 then
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.mindFlay.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindFlay.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindFlay.insanity
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindFlay.icon
						UpdateCastingResourceFinal_Shadow(TRB.Data.spells.mindFlay.fotm)
					elseif currentChannelId == TRB.Data.spells.mindSear.id then
						local latency = TRB.Functions.GetLatency()

						if TRB.Data.snapshotData.mindSear.hitTime == nil then
							TRB.Data.snapshotData.mindSear.targetsHit = 1
							TRB.Data.snapshotData.mindSear.hitTime = currentTime
							TRB.Data.snapshotData.mindSear.hasStruckTargets = false
						elseif currentTime > (TRB.Data.snapshotData.mindSear.hitTime + (TRB.Functions.GetCurrentGCDTime(true) / 2) + latency) then
							TRB.Data.snapshotData.mindSear.targetsHit = 0
						end

						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindSear.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindSear.insanity * TRB.Data.snapshotData.mindSear.targetsHit
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindSear.icon
						UpdateCastingResourceFinal_Shadow(TRB.Data.spells.mindSear.fotm)
					elseif currentChannelId == TRB.Data.spells.voidTorrent.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.voidTorrent.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.voidTorrent.insanity
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.voidTorrent.icon
						UpdateCastingResourceFinal_Shadow(TRB.Data.spells.voidTorrent.fotm)
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				else
					if currentSpellId == TRB.Data.spells.mindBlast.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindBlast.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindBlast.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindBlast.icon
						UpdateCastingResourceFinal_Shadow(TRB.Data.spells.mindBlast.fotm)
					elseif currentSpellId == TRB.Data.spells.vampiricTouch.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.vampiricTouch.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.vampiricTouch.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.vampiricTouch.icon
						UpdateCastingResourceFinal_Shadow(TRB.Data.spells.vampiricTouch.fotm)
					elseif currentSpellId == TRB.Data.spells.massDispel.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.massDispel.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.massDispel.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.massDispel.icon
						UpdateCastingResourceFinal_Shadow(TRB.Data.spells.massDispel.fotm)
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				end
				return true
			end
		end
	end

	local function UpdateMindbenderValues()
		local currentTime = GetTime()
		local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
		local timeRemaining = startTime+duration-currentTime
		if TRB.Data.settings.priest.shadow.mindbender.enabled and haveTotem and timeRemaining > 0 then
			TRB.Data.snapshotData.mindbender.isActive = true
			if TRB.Data.settings.priest.shadow.mindbender.enabled then
				local rabidShadowsPercent = 1 + TRB.Data.spells.rabidShadows.conduitRanks[TRB.Functions.GetSoulbindRank(TRB.Data.spells.rabidShadows.conduitId)]
				local swingSpeed = 1.5 / (1 + (TRB.Data.snapshotData.haste / 100)) / rabidShadowsPercent

				if swingSpeed > 1.5 then
					swingSpeed = 1.5
				end

				local timeToNextSwing = swingSpeed - (currentTime - TRB.Data.snapshotData.mindbender.swingTime)

				if timeToNextSwing < 0 then
					timeToNextSwing = 0
				elseif timeToNextSwing > 1.5 then
					timeToNextSwing = 1.5
				end

				TRB.Data.snapshotData.mindbender.remaining.time = timeRemaining
				TRB.Data.snapshotData.mindbender.remaining.swings = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)

				local gcd = swingSpeed
				if gcd < 0.75 then
					gcd = 0.75
				end

				if timeRemaining > (gcd * TRB.Data.snapshotData.mindbender.remaining.swings) then
					TRB.Data.snapshotData.mindbender.remaining.gcds = math.ceil(((gcd * TRB.Data.snapshotData.mindbender.remaining.swings) - timeToNextSwing) / swingSpeed)
				else
					TRB.Data.snapshotData.mindbender.remaining.gcds = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
				end

				TRB.Data.snapshotData.mindbender.swingTime = currentTime

				local countValue = 0

				if TRB.Data.settings.priest.shadow.mindbender.mode == "swing" then
					if TRB.Data.snapshotData.mindbender.remaining.swings > TRB.Data.settings.priest.shadow.mindbender.swingsMax then
						countValue = TRB.Data.settings.priest.shadow.mindbender.swingsMax
					else
						countValue = TRB.Data.snapshotData.mindbender.remaining.swings
					end
				elseif TRB.Data.settings.priest.shadow.mindbender.mode == "time" then
					if TRB.Data.snapshotData.mindbender.remaining.time > TRB.Data.settings.priest.shadow.mindbender.timeMax then
						countValue = math.ceil((TRB.Data.settings.priest.shadow.mindbender.timeMax - timeToNextSwing) / swingSpeed)
					else
						countValue = math.ceil((TRB.Data.snapshotData.mindbender.remaining.time - timeToNextSwing) / swingSpeed)
					end
				else --assume GCD
					if TRB.Data.snapshotData.mindbender.remaining.gcds > TRB.Data.settings.priest.shadow.mindbender.gcdsMax then
						countValue = TRB.Data.settings.priest.shadow.mindbender.gcdsMax
					else
						countValue = TRB.Data.snapshotData.mindbender.remaining.gcds
					end
				end

				if TRB.Data.character.talents.mindbender.isSelected then
					TRB.Data.snapshotData.mindbender.resourceRaw = countValue * TRB.Data.spells.mindbender.insanity
				else
					TRB.Data.snapshotData.mindbender.resourceRaw = countValue * TRB.Data.spells.shadowfiend.insanity
				end
				TRB.Data.snapshotData.mindbender.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.mindbender.resourceRaw, false)
			end
		else
			TRB.Data.snapshotData.mindbender.onCooldown = not (GetSpellCooldown(TRB.Data.spells.mindbender.id) == 0)
			TRB.Data.snapshotData.mindbender.isActive = false
			TRB.Data.snapshotData.mindbender.swingTime = 0
			TRB.Data.snapshotData.mindbender.remaining = {}
			TRB.Data.snapshotData.mindbender.remaining.swings = 0
			TRB.Data.snapshotData.mindbender.remaining.gcds = 0
			TRB.Data.snapshotData.mindbender.remaining.time = 0
			TRB.Data.snapshotData.mindbender.resourceRaw = 0
			TRB.Data.snapshotData.mindbender.resourceFinal = 0
		end
	end

	local function UpdateExternalCallToTheVoidValues()
		local currentTime = GetTime()
		local totalTicksRemaining_Lasher = 0
		local totalTicksRemaining_Tendril = 0
		local totalInsanity_Lasher = 0
		local totalInsanity_Tendril = 0
		local totalActive = 0

		-- TODO: Add separate counts for Tendril vs Lasher?
		if TRB.Functions.TableLength(TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils) > 0 then
			for vtGuid,v in pairs(TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils) do
				if TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid] ~= nil and TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].startTime ~= nil then
					local endTime = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].startTime + TRB.Data.spells.lashOfInsanity_Tendril.duration
					local timeRemaining = endTime - currentTime

					if timeRemaining < 0 then
						RemoveVoidTendril(vtGuid)
					else
						if TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].type == "Lasher" then
							if TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime ~= nil and currentTime > (TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime + 5) then
								TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].targetsHit = 0
							end

							local nextTick = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime + (TRB.Data.spells.lashOfInsanity_Lasher.tickDuration / ((TRB.Data.snapshotData.haste / 100) + 1))

							if nextTick < currentTime then
								nextTick = currentTime --There should be a tick. ANY second now. Maybe.
								totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + 1
							end
							-- NOTE: Might need to be math.floor()
							local ticksRemaining = math.ceil((endTime - nextTick) / TRB.Data.spells.lashOfInsanity_Lasher.tickDuration / ((TRB.Data.snapshotData.haste / 100) + 1)) -- This is hasted

							totalInsanity_Lasher = totalInsanity_Lasher + (ticksRemaining * TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].targetsHit * TRB.Data.spells.lashOfInsanity_Lasher.insanity)
							totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + ticksRemaining
						else
							local nextTick = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Tendril.tickDuration

							if nextTick < currentTime then
								nextTick = currentTime --There should be a tick. ANY second now. Maybe.
								totalTicksRemaining_Tendril = totalTicksRemaining_Tendril + 1
							end

							-- NOTE: Might need to be math.floor()
							local ticksRemaining = math.ceil((endTime - nextTick) / TRB.Data.spells.lashOfInsanity_Tendril.tickDuration) --Not needed as it is 1sec, but adding in case it changes

							totalInsanity_Tendril = totalInsanity_Tendril + (ticksRemaining * TRB.Data.spells.lashOfInsanity_Tendril.insanity)
							totalTicksRemaining_Tendril = totalTicksRemaining_Tendril + ticksRemaining
						end

						totalActive = totalActive + 1
					end
				end
			end
		end

		TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining = totalTicksRemaining_Tendril + totalTicksRemaining_Lasher
		TRB.Data.snapshotData.eternalCallToTheVoid.numberActive = totalActive
		TRB.Data.snapshotData.eternalCallToTheVoid.resourceRaw = totalInsanity_Tendril + totalInsanity_Lasher
		-- Fortress of the Mind does not apply but other Insanity boosting effects do.
		TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.eternalCallToTheVoid.resourceRaw, TRB.Data.spells.lashOfInsanity_Tendril.fotm)
	end

	local function UpdateDeathAndMadness()
		if TRB.Data.snapshotData.deathAndMadness.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.deathAndMadness.endTime == nil or currentTime > TRB.Data.snapshotData.deathAndMadness.endTime then
				TRB.Data.snapshotData.deathAndMadness.ticksRemaining = 0
				TRB.Data.snapshotData.deathAndMadness.endTime = nil
				TRB.Data.snapshotData.deathAndMadness.insanity = 0
				TRB.Data.snapshotData.deathAndMadness.isActive = false
			else
				TRB.Data.snapshotData.deathAndMadness.ticksRemaining = math.ceil((TRB.Data.snapshotData.deathAndMadness.endTime - currentTime) / (TRB.Data.spells.deathAndMadness.duration / TRB.Data.spells.deathAndMadness.ticks))
				TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
			end
		end
	end

	local function UpdateWrathfulFaerieValues()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		local settings

		local mainMod = 1

		-- We can't actually track procs from Haunted Mask as there's no SPELL_ENERGIZE event for them as of 9.1 RC.
		-- We'll piggy back off the main Wrathful Faerie and double it's value instead.
		-- Twintop 2021-06-19
		if specCache.holy.snapshotData.wrathfulFaerie.hauntedMask.isActive == true then
			mainMod = 2
		end

		if specId == 2 then
			settings = TRB.Data.settings.priest.holy
		elseif specId == 3 then
			settings = TRB.Data.settings.priest.shadow
		end

		if settings.wrathfulFaerie.enabled and TRB.Data.snapshotData.wrathfulFaerie.main.endTime and TRB.Data.snapshotData.wrathfulFaerie.main.endTime > currentTime then
			local timeRemaining = TRB.Data.snapshotData.wrathfulFaerie.main.endTime - currentTime
			--TRB.Data.snapshotData.wrathfulFaerie.main.isActive = true
			if settings.wrathfulFaerie.enabled then
				local tickRate = (TRB.Data.spells.wrathfulFaerie.icd or 0.75) + (settings.wrathfulFaerie.procDelay or 0.15)

				local timeToNextProc = tickRate - (currentTime - TRB.Data.snapshotData.wrathfulFaerie.main.procTime)

				if timeToNextProc < 0 then
					timeToNextProc = 0
				elseif timeToNextProc > tickRate then
					timeToNextProc = tickRate
				end

				local gcd = TRB.Functions.GetCurrentGCDTime(true)

				TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time = timeRemaining
				TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs = math.ceil((timeRemaining - timeToNextProc) / tickRate)
				TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds = math.ceil(timeRemaining / gcd)

				TRB.Data.snapshotData.wrathfulFaerie.main.procTime = currentTime

				local countValue = 0

				if settings.wrathfulFaerie.mode == "procs" then
					if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs > settings.wrathfulFaerie.procsMax then
						countValue = settings.wrathfulFaerie.procsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs
					end
				elseif settings.wrathfulFaerie.mode == "time" then
					if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time > settings.wrathfulFaerie.timeMax then
						countValue = math.ceil((settings.wrathfulFaerie.timeMax - timeToNextProc) / tickRate)
					else
						countValue = math.ceil((TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time - timeToNextProc) / tickRate)
					end
				else --assume GCD
					if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds > settings.wrathfulFaerie.gcdsMax then
						countValue = settings.wrathfulFaerie.gcdsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds
					end
				end

				if TRB.Data.snapshotData.targetData.wrathfulFaerieGuid then
					if specId == 2 then
						TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw = countValue * TRB.Data.spells.wrathfulFaerie.manaPercent * TRB.Data.character.maxResource * mainMod
						TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal = TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw
					elseif specId == 3 then
						TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw = countValue * TRB.Data.spells.wrathfulFaerie.insanity * mainMod
						TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw, false)
					end
				else
					TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw = 0
					TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal = 0
				end
			end
		else
			TRB.Data.snapshotData.wrathfulFaerie.main.onCooldown = not (GetSpellCooldown(TRB.Data.spells.wrathfulFaerie.id) == 0)
			TRB.Data.snapshotData.wrathfulFaerie.main.isActive = false
			TRB.Data.snapshotData.wrathfulFaerie.main.endTime = nil
			TRB.Data.snapshotData.wrathfulFaerie.main.procTime = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining = {}
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal = 0
		end
		
		if settings.wrathfulFaerie.enabled and TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime and TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime > currentTime then
			local timeRemaining = TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime - currentTime

			if settings.wrathfulFaerie.enabled then
				local tickRate = (TRB.Data.spells.wrathfulFaerie.icd or 0.75) + (settings.wrathfulFaerie.procDelay or 0.15)

				local timeToNextProc = tickRate - (currentTime - TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime)

				if timeToNextProc < 0 then
					timeToNextProc = 0
				elseif timeToNextProc > tickRate then
					timeToNextProc = tickRate
				end

				local gcd = TRB.Functions.GetCurrentGCDTime(true)

				TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time = timeRemaining
				TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs = math.ceil((timeRemaining - timeToNextProc) / tickRate)
				TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds = math.ceil(timeRemaining / gcd)

				TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime = currentTime

				local countValue = 0

				if settings.wrathfulFaerie.mode == "procs" then
					if TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs > settings.wrathfulFaerie.procsMax then
						countValue = settings.wrathfulFaerie.procsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs
					end
				elseif settings.wrathfulFaerie.mode == "time" then
					if TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time > settings.wrathfulFaerie.timeMax then
						countValue = math.ceil((settings.wrathfulFaerie.timeMax - timeToNextProc) / tickRate)
					else
						countValue = math.ceil((TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time - timeToNextProc) / tickRate)
					end
				else --assume GCD
					if TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds > settings.wrathfulFaerie.gcdsMax then
						countValue = settings.wrathfulFaerie.gcdsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds
					end
				end

				if TRB.Data.snapshotData.targetData.wrathfulFaerieFermataGuid then
					if specId == 2 then
						TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw = countValue * TRB.Data.spells.wrathfulFaerie.manaPercent * TRB.Data.character.maxResource * TRB.Data.spells.wrathfulFaerieFermata.modifier
						TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal = TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw
					elseif specId == 3 then
						TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw = countValue * TRB.Data.spells.wrathfulFaerie.insanity * TRB.Data.spells.wrathfulFaerieFermata.modifier
						TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw, false)
					end
				else
					TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw = 0
					TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal = 0
				end
			end
		else
			TRB.Data.snapshotData.wrathfulFaerie.fermata.isActive = false
			TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime = nil
			TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining = {}
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal = 0
		end

		TRB.Data.snapshotData.wrathfulFaerie.resourceRaw = TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw + TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw
		TRB.Data.snapshotData.wrathfulFaerie.resourceFinal = TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal
	end

	local function UpdatePotionOfSpiritualClarity(forceCleanup)
		if TRB.Data.snapshotData.potionOfSpiritualClarity.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or TRB.Data.snapshotData.potionOfSpiritualClarity.endTime == nil or currentTime > TRB.Data.snapshotData.potionOfSpiritualClarity.endTime then
				TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining = 0
				TRB.Data.snapshotData.potionOfSpiritualClarity.endTime = nil
				TRB.Data.snapshotData.potionOfSpiritualClarity.mana = 0
				TRB.Data.snapshotData.potionOfSpiritualClarity.isActive = false
			else
				TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining = math.ceil((TRB.Data.snapshotData.potionOfSpiritualClarity.endTime - currentTime) / (TRB.Data.spells.potionOfSpiritualClarity.duration / TRB.Data.spells.potionOfSpiritualClarity.ticks))
				local nextTickRemaining = TRB.Data.snapshotData.potionOfSpiritualClarity.endTime - currentTime - math.floor((TRB.Data.snapshotData.potionOfSpiritualClarity.endTime - currentTime) / (TRB.Data.spells.potionOfSpiritualClarity.duration / TRB.Data.spells.potionOfSpiritualClarity.ticks))
				TRB.Data.snapshotData.potionOfSpiritualClarity.mana = TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfSpiritualClarity.mana, true) + ((TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining - 1 + nextTickRemaining) * TRB.Data.snapshotData.manaRegen)
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
			TRB.Data.snapshotData.innervate.mana = TRB.Data.snapshotData.innervate.remainingTime * TRB.Data.snapshotData.manaRegen
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
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Holy()
		UpdateSnapshot()
		UpdateWrathfulFaerieValues()
		UpdateSymbolOfHope()
		UpdatePotionOfSpiritualClarity()
		UpdateInnervate()
		UpdateManaTideTotem()

		local currentTime = GetTime()
		local _

		if TRB.Data.snapshotData.apotheosis.startTime ~= nil and currentTime > (TRB.Data.snapshotData.apotheosis.startTime + TRB.Data.snapshotData.apotheosis.duration) then
            TRB.Data.snapshotData.apotheosis.startTime = nil
            TRB.Data.snapshotData.apotheosis.duration = 0
			TRB.Data.snapshotData.apotheosis.remainingTime = 0
		else
			TRB.Data.snapshotData.apotheosis.remainingTime = GetApotheosisRemainingTime()
        end

		if TRB.Data.snapshotData.innervate.startTime ~= nil and currentTime > (TRB.Data.snapshotData.innervate.startTime + TRB.Data.snapshotData.innervate.duration) then
            TRB.Data.snapshotData.innervate.startTime = nil
            TRB.Data.snapshotData.innervate.duration = 0
			TRB.Data.snapshotData.innervate.remainingTime = 0
		else
			TRB.Data.snapshotData.innervate.remainingTime = GetInnervateRemainingTime()
        end

		if TRB.Data.snapshotData.holyWordSerenity.startTime ~= nil then
			TRB.Data.snapshotData.holyWordSerenity.startTime, TRB.Data.snapshotData.holyWordSerenity.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSerenity.id)
			
			if TRB.Data.snapshotData.holyWordSerenity.startTime == 0 then
				TRB.Data.snapshotData.holyWordSerenity.startTime = nil
			end
		end

		if TRB.Data.snapshotData.holyWordSanctify.startTime ~= nil then
			TRB.Data.snapshotData.holyWordSanctify.startTime, TRB.Data.snapshotData.holyWordSanctify.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSanctify.id)
			
			if TRB.Data.snapshotData.holyWordSanctify.startTime == 0 then
				TRB.Data.snapshotData.holyWordSanctify.startTime = nil
			end
		end

		if TRB.Data.snapshotData.holyWordChastise.startTime ~= nil then
			TRB.Data.snapshotData.holyWordChastise.startTime, TRB.Data.snapshotData.holyWordChastise.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordChastise.id)

			if TRB.Data.snapshotData.holyWordChastise.startTime == 0 then
				TRB.Data.snapshotData.holyWordChastise.startTime = nil
			end
		end

		if TRB.Data.character.items.flashConcentration then
			_, _, TRB.Data.snapshotData.flashConcentration.stacks, _, TRB.Data.snapshotData.flashConcentration.duration, TRB.Data.snapshotData.flashConcentration.endTime, _, _, _, TRB.Data.snapshotData.flashConcentration.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.flashConcentration.id)
			TRB.Data.snapshotData.flashConcentration.remainingTime = GetFlashConcentrationRemainingTime()
		end

		_, _, TRB.Data.snapshotData.surgeOfLight.stacks, _, TRB.Data.snapshotData.surgeOfLight.duration, TRB.Data.snapshotData.surgeOfLight.endTime, _, _, _, TRB.Data.snapshotData.surgeOfLight.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.surgeOfLight.id)
		TRB.Data.snapshotData.surgeOfLight.remainingTime = GetSurgeOfLightRemainingTime()

		-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldownMS
		TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration, _ = GetItemCooldown(TRB.Data.character.items.potions.potionOfSpiritualClarity.id)
		if TRB.Data.snapshotData.potion.startTime > 0 and TRB.Data.snapshotData.potion.duration > 0 then
			TRB.Data.snapshotData.potion.onCooldown = true
		else
			TRB.Data.snapshotData.potion.onCooldown = false
		end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPain then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.shadowWordPain.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Shadow()
		UpdateSnapshot()
		TRB.Data.spells.s2m.isActive = select(10, TRB.Functions.FindBuffById(TRB.Data.spells.s2m.id))
		UpdateMindbenderValues()
		UpdateExternalCallToTheVoidValues()
		UpdateDeathAndMadness()
		UpdateWrathfulFaerieValues()

		local currentTime = GetTime()
		local _

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPain then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.shadowWordPain.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouch then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.vampiricTouch.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouchRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].devouringPlague then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.devouringPlague.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].devouringPlagueRemaining = expiration - currentTime
				end
			end
		end
	end

	local function HideResourceBar(force)
		local specId = GetSpecialization()
		local affectingCombat = UnitAffectingCombat("player")

		if specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.priest.holy.displayBar.alwaysShow) and (
						(not TRB.Data.settings.priest.holy.displayBar.notZeroShow) or
						(TRB.Data.settings.priest.holy.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.priest.holy.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 3 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.priest.shadow.displayBar.alwaysShow) and (
						(not TRB.Data.settings.priest.shadow.displayBar.notZeroShow) or
						(TRB.Data.settings.priest.shadow.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.priest.shadow.displayBar.neverShow == true then
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

		if specId == 2 then
			UpdateSnapshot_Holy()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.priest.holy)
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.priest.holy.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local barBorderColor = TRB.Data.settings.priest.holy.colors.bar.border

					if TRB.Data.snapshotData.surgeOfLight.stacks == 1 and TRB.Data.settings.priest.holy.colors.bar.surgeOfLightBorderChange1 then
						barBorderColor = TRB.Data.settings.priest.holy.colors.bar.surgeOfLight1

						if TRB.Data.settings.priest.holy.audio.surgeOfLight.enabled and not TRB.Data.snapshotData.audio.surgeOfLightCue then
							TRB.Data.snapshotData.audio.surgeOfLightCue = true
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end

					if TRB.Data.snapshotData.surgeOfLight.stacks == 2 and TRB.Data.settings.priest.holy.colors.bar.surgeOfLightBorderChange2 then
						barBorderColor = TRB.Data.settings.priest.holy.colors.bar.surgeOfLight2

						if TRB.Data.settings.priest.holy.audio.surgeOfLight2.enabled and not TRB.Data.snapshotData.audio.surgeOfLight2Cue then
							TRB.Data.snapshotData.audio.surgeOfLight2Cue = true
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end

					if TRB.Data.spells.innervate.isActive and TRB.Data.settings.priest.holy.colors.bar.innervateBorderChange then
						barBorderColor = TRB.Data.settings.priest.holy.colors.bar.innervate

						if TRB.Data.settings.priest.holy.audio.innervate.enabled and TRB.Data.snapshotData.audio.innervateCue == false then
							TRB.Data.snapshotData.audio.innervateCue = true
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end

					if TRB.Data.character.items.flashConcentration then
						local affectingCombat = UnitAffectingCombat("player")
						if TRB.Data.settings.priest.holy.flashConcentration.enabledUncapped and (affectingCombat or TRB.Data.settings.priest.holy.flashConcentration.enabledUncappedOutOfCombat) and (TRB.Data.snapshotData.flashConcentration.stacks == nil or TRB.Data.snapshotData.flashConcentration.stacks < TRB.Data.spells.flashConcentration.maxStacks) then
							barBorderColor = TRB.Data.settings.priest.holy.colors.bar.flashConcentration
						end

						if TRB.Data.snapshotData.flashConcentration.remainingTime ~= nil and TRB.Data.snapshotData.flashConcentration.remainingTime > 0 then
							local fcTimeThreshold = 0
							if TRB.Data.settings.priest.holy.flashConcentration.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								fcTimeThreshold = gcd * TRB.Data.settings.priest.holy.flashConcentration.gcdsMax
							elseif TRB.Data.settings.priest.holy.flashConcentration.mode == "time" then
								fcTimeThreshold = TRB.Data.settings.priest.holy.flashConcentration.timeMax
							end

							if TRB.Data.snapshotData.flashConcentration.remainingTime <= fcTimeThreshold then
								if TRB.Data.settings.priest.holy.flashConcentration.enabled and (affectingCombat or TRB.Data.settings.priest.holy.flashConcentration.enabledUncappedOutOfCombat) then
									barBorderColor = TRB.Data.settings.priest.holy.colors.bar.flashConcentration
								end

								if TRB.Data.settings.priest.holy.audio.flashConcentration.enabled and TRB.Data.snapshotData.audio.flashConcentrationCue == false then
									TRB.Data.snapshotData.audio.flashConcentrationCue = true
									PlaySoundFile(TRB.Data.settings.priest.holy.audio.flashConcentration.sound, TRB.Data.settings.core.audio.channel.channel)
								end
							else
								TRB.Data.snapshotData.audio.flashConcentrationCue = false
							end
						end
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, resourceFrame, currentMana)

					if CastingSpell() and TRB.Data.settings.priest.holy.bar.showCasting  then
						castingBarValue = currentMana + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentMana
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, castingFrame, castingBarValue)

					local potionCooldownThreshold = 0
					local potionThresholdColor = TRB.Data.settings.priest.holy.colors.threshold.over
					if TRB.Data.snapshotData.potion.onCooldown then
						if TRB.Data.settings.priest.holy.thresholds.potionCooldown.enabled then
							if TRB.Data.settings.priest.holy.thresholds.potionCooldown.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								potionCooldownThreshold = gcd * TRB.Data.settings.priest.holy.thresholds.potionCooldown.gcdsMax
							elseif TRB.Data.settings.priest.holy.thresholds.potionCooldown.mode == "time" then
								potionCooldownThreshold = TRB.Data.settings.priest.holy.thresholds.potionCooldown.timeMax
							end
						end
					end

					if not TRB.Data.snapshotData.potion.onCooldown or (potionCooldownThreshold > math.abs(TRB.Data.snapshotData.potion.startTime + TRB.Data.snapshotData.potion.duration - currentTime))then
						if TRB.Data.snapshotData.potion.onCooldown then
							potionThresholdColor = TRB.Data.settings.priest.holy.colors.threshold.unusable
						end
						local poscTotal = CalculateManaGain(TRB.Data.character.items.potions.potionOfSpiritualClarity.mana, true) + (TRB.Data.spells.potionOfSpiritualClarity.duration * TRB.Data.snapshotData.manaRegen)
						if TRB.Data.settings.priest.holy.thresholds.potionOfSpiritualClarity.enabled and (castingBarValue + poscTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.priest.holy.thresholdWidth, (castingBarValue + poscTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[1]:Show()
						else
							TRB.Frames.resourceFrame.thresholds[1]:Hide()
						end

						local srpTotal = CalculateManaGain(TRB.Data.character.items.potions.spiritualRejuvenationPotion.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.spiritualRejuvenationPotion.enabled and (castingBarValue + srpTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[2], resourceFrame, TRB.Data.settings.priest.holy.thresholdWidth, (castingBarValue + srpTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[2]:Show()
						else
							TRB.Frames.resourceFrame.thresholds[2]:Hide()
						end

						local smpTotal = CalculateManaGain(TRB.Data.character.items.potions.spiritualManaPotion.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.spiritualManaPotion.enabled and (castingBarValue + smpTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[3], resourceFrame, TRB.Data.settings.priest.holy.thresholdWidth, (castingBarValue + smpTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[3]:Show()
						else
							TRB.Frames.resourceFrame.thresholds[3]:Hide()
						end

						local sompTotal = CalculateManaGain(TRB.Data.character.items.potions.soulfulManaPotion.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.soulfulManaPotion.enabled and (castingBarValue + sompTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[4], resourceFrame, TRB.Data.settings.priest.holy.thresholdWidth, (castingBarValue + sompTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[4]:Show()
						else
							TRB.Frames.resourceFrame.thresholds[4]:Hide()
						end
					else
						TRB.Frames.resourceFrame.thresholds[1]:Hide()
						TRB.Frames.resourceFrame.thresholds[2]:Hide()
						TRB.Frames.resourceFrame.thresholds[3]:Hide()
						TRB.Frames.resourceFrame.thresholds[4]:Hide()
					end

					local passiveValue = 0
					if TRB.Data.settings.priest.holy.bar.showPassive then
						if TRB.Data.snapshotData.potionOfSpiritualClarity.isActive then
							passiveValue = passiveValue + TRB.Data.snapshotData.potionOfSpiritualClarity.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, TRB.Data.settings.priest.holy.thresholdWidth, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[1]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[1]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end

						if TRB.Data.snapshotData.wrathfulFaerie.resourceFinal > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.wrathfulFaerie.resourceFinal

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[2], passiveFrame, TRB.Data.settings.priest.holy.thresholdWidth, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[2]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[2]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[2]:Hide()
						end

						if TRB.Data.snapshotData.innervate.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.innervate.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[3], passiveFrame, TRB.Data.settings.priest.holy.thresholdWidth, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[3]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[3]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[3]:Hide()
						end

						if TRB.Data.snapshotData.symbolOfHope.resourceFinal > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.symbolOfHope.resourceFinal

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, TRB.Data.settings.priest.holy.thresholdWidth, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[4]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[4]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[4]:Hide()
						end

						if TRB.Data.snapshotData.manaTideTotem.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.manaTideTotem.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[5], passiveFrame, TRB.Data.settings.priest.holy.thresholdWidth, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[5].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.threshold.mindbender, true))
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
					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.bar.spending, true))
						else
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.bar.passive, true))
						end
					else
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.holy, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.bar.passive, true))
					end

					local resourceBarColor = nil

					if TRB.Data.snapshotData.casting.spellKey ~= nil then
						if TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey] ~= nil and
							TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey ~= nil and
							TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction ~= nil and
							TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction >= 0 then

							local castTimeRemains = TRB.Data.snapshotData.casting.endTime - currentTime

							if TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey2 ~= nil and
								TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction2 ~= nil and
								TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction2 >= 0 then --We have an edge case, boiz
								local holyWordCooldownRemaining1 = GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey])
								local holyWordCooldownRemaining2 = GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey2])

								local remaining1 = holyWordCooldownRemaining1 - CalculateHolyWordCooldown(TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction) - castTimeRemains
								local remaining2 = holyWordCooldownRemaining2 - CalculateHolyWordCooldown(TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction2) - castTimeRemains

								if remaining1 <= 0 and remaining2 > 0 and TRB.Data.settings.priest.holy.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey .. "Enabled"] then
									resourceBarColor = TRB.Data.settings.priest.holy.colors.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey]
								elseif remaining1 > 0 and remaining2 <= 0 and TRB.Data.settings.priest.holy.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey2 .. "Enabled"] then
									resourceBarColor = TRB.Data.settings.priest.holy.colors.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey2]
								elseif remaining1 <= 0 and remaining2 <= 0 and TRB.Data.settings.priest.holy.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey .. "Enabled"] then
									resourceBarColor = TRB.Data.settings.priest.holy.colors.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey]
								end
							else
								local holyWordCooldownRemaining = GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey])

								if (holyWordCooldownRemaining - CalculateHolyWordCooldown(TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction) - castTimeRemains) <= 0 and TRB.Data.settings.priest.holy.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey .. "Enabled"] then
									resourceBarColor = TRB.Data.settings.priest.holy.colors.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey]
								end
							end
						end
					end

					if TRB.Data.snapshotData.apotheosis.spellId and resourceBarColor == nil then
						local timeThreshold = 0
						local useEndOfApotheosisColor = false

						if TRB.Data.settings.priest.holy.endOfApotheosis.enabled then
							useEndOfApotheosisColor = true
							if TRB.Data.settings.priest.holy.endOfApotheosis.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.priest.holy.endOfApotheosis.gcdsMax
							elseif TRB.Data.settings.priest.holy.endOfApotheosis.mode == "time" then
								timeThreshold = TRB.Data.settings.priest.holy.endOfApotheosis.timeMax
							end
						end

						if useEndOfApotheosisColor and TRB.Data.snapshotData.apotheosis.remainingTime <= timeThreshold then
							resourceBarColor = TRB.Data.settings.priest.holy.colors.bar.apotheosisEnd
						else
							resourceBarColor = TRB.Data.settings.priest.holy.colors.bar.apotheosis
						end
					elseif resourceBarColor == nil then
						resourceBarColor = TRB.Data.settings.priest.holy.colors.bar.base
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(resourceBarColor, true))
				end

				TRB.Functions.UpdateResourceBar(TRB.Data.settings.priest.holy, refreshText)
			end
		elseif specId == 3 then
			UpdateSnapshot_Shadow()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.priest.shadow)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				CalculateRemainingHungeringVoidTime()

				if TRB.Data.settings.priest.shadow.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentInsanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

					if TRB.Data.settings.priest.shadow.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.borderOvercap, true))

						if TRB.Data.settings.priest.shadow.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, resourceFrame, currentInsanity)

					if CastingSpell() and TRB.Data.settings.priest.shadow.bar.showCasting  then
						castingBarValue = currentInsanity + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentInsanity
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, castingFrame, castingBarValue)

					if TRB.Data.settings.priest.shadow.bar.showPassive and
						(TRB.Data.character.talents.as.isSelected or
						TRB.Data.snapshotData.mindbender.resourceFinal > 0 or
						TRB.Data.snapshotData.deathAndMadness.isActive or
						TRB.Data.snapshotData.wrathfulFaerie.resourceFinal > 0 or
						TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal > 0) then
						passiveBarValue = castingBarValue + ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceFinal + TRB.Data.snapshotData.deathAndMadness.insanity + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.resourceFinal)
						if TRB.Data.snapshotData.mindbender.resourceFinal > 0 and (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, TRB.Data.settings.priest.shadow.thresholdWidth, (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.mindbender, true))
							TRB.Frames.passiveFrame.thresholds[1]:Show()
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end

						if TRB.Data.snapshotData.wrathfulFaerie.resourceFinal > 0 and (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.resourceFinal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, TRB.Frames.passiveFrame.thresholds[2], passiveFrame, TRB.Data.settings.priest.shadow.thresholdWidth, (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.resourceFinal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.passiveFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.mindbender, true))
							TRB.Frames.passiveFrame.thresholds[2]:Show()
						else
							TRB.Frames.passiveFrame.thresholds[2]:Hide()
						end
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						TRB.Frames.passiveFrame.thresholds[2]:Hide()
						passiveBarValue = castingBarValue
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, passiveFrame, passiveBarValue)

					if TRB.Data.settings.priest.shadow.devouringPlagueThreshold then
						TRB.Frames.resourceFrame.thresholds[1]:Show()
					else
						TRB.Frames.resourceFrame.thresholds[1]:Hide()
					end

					if TRB.Data.settings.priest.shadow.searingNightmareThreshold and TRB.Data.character.talents.searingNightmare.isSelected == true and TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id then
						if currentInsanity >= TRB.Data.character.searingNightmareThreshold then
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
						else
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
						end
						TRB.Frames.resourceFrame.thresholds[2]:Show()
					else
						TRB.Frames.resourceFrame.thresholds[2]:Hide()
					end

					if currentInsanity >= TRB.Data.character.devouringPlagueThreshold or TRB.Data.spells.mindDevourer.isActive then
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
						if TRB.Data.settings.priest.shadow.colors.bar.flashEnabled then
							TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.priest.shadow.colors.bar.flashAlpha, TRB.Data.settings.priest.shadow.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if TRB.Data.spells.mindDevourer.isActive and TRB.Data.settings.priest.shadow.audio.mdProc.enabled and TRB.Data.snapshotData.audio.playedMdCue == false then
							TRB.Data.snapshotData.audio.playedDpCue = true
							TRB.Data.snapshotData.audio.playedMdCue = true
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.mdProc.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif TRB.Data.settings.priest.shadow.audio.dpReady.enabled and TRB.Data.snapshotData.audio.playedDpCue == false then
							TRB.Data.snapshotData.audio.playedDpCue = true
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.dpReady.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
						barContainerFrame:SetAlpha(1.0)
						TRB.Data.snapshotData.audio.playedDpCue = false
						TRB.Data.snapshotData.audio.playedMdCue = false
					end

					if TRB.Data.snapshotData.voidform.spellId then
						local timeThreshold = 0
						local useEndOfVoidformColor = false

						if TRB.Data.settings.priest.shadow.endOfVoidform.enabled and (not TRB.Data.settings.priest.shadow.endOfVoidform.hungeringVoidOnly or TRB.Data.character.talents.hungeringVoid.isSelected) then
							useEndOfVoidformColor = true
							if TRB.Data.settings.priest.shadow.endOfVoidform.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.priest.shadow.endOfVoidform.gcdsMax
							elseif TRB.Data.settings.priest.shadow.endOfVoidform.mode == "time" then
								timeThreshold = TRB.Data.settings.priest.shadow.endOfVoidform.timeMax
							end
						end

						if useEndOfVoidformColor and TRB.Data.snapshotData.voidform.remainingTime <= timeThreshold then
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform1GCD, true))
						elseif currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.enterVoidform, true))
						else
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform, true))
						end
					else
						if currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.enterVoidform, true))
						else
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.base, true))
						end
					end
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.priest.shadow, refreshText)
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 2 and specId ~= 3 then
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
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, auraType = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			local s2mDeath = false

			local settings

			if specId == 2 then
				settings = TRB.Data.settings.priest.holy
			elseif specId == 3 then
				settings = TRB.Data.settings.priest.shadow
			end

			if destGUID == TRB.Data.character.guid then
				if specId == 2 then -- Let's check raid effect mana stuff
					if type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.symbolOfHope.tickId then
						local diff = 0
						if TRB.Data.snapshotData.symbolOfHope.previousTickTime ~= nil then
							diff = currentTime - TRB.Data.snapshotData.symbolOfHope.previousTickTime
						end

						TRB.Data.snapshotData.symbolOfHope.isActive = true
						if TRB.Data.snapshotData.symbolOfHope.firstTickTime == nil then
							TRB.Data.snapshotData.symbolOfHope.firstTickTime = currentTime
							TRB.Data.snapshotData.symbolOfHope.previousTickTime = currentTime
							TRB.Data.snapshotData.symbolOfHope.ticksRemaining = TRB.Data.spells.symbolOfHope.ticks
							if sourceGUID == TRB.Data.character.guid then
								TRB.Data.snapshotData.symbolOfHope.endTime = currentTime + (TRB.Data.spells.symbolOfHope.duration / (1.5 / TRB.Functions.GetCurrentGCDTime(true)))
								TRB.Data.snapshotData.symbolOfHope.tickRate = (TRB.Data.spells.symbolOfHope.duration / TRB.Data.spells.symbolOfHope.ticks) / (1.5 / TRB.Functions.GetCurrentGCDTime(true))
								TRB.Data.snapshotData.symbolOfHope.tickRateFound = true
							else -- If the player isn't the one casting this, we can't know the tickrate until there are multiple ticks.
								TRB.Data.snapshotData.symbolOfHope.tickRate = (TRB.Data.spells.symbolOfHope.duration / TRB.Data.spells.symbolOfHope.ticks)
								TRB.Data.snapshotData.symbolOfHope.endTime = currentTime + TRB.Data.spells.symbolOfHope.duration
							end
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
							TRB.Data.spells.innervate.isActive = true
							_, _, _, _, TRB.Data.snapshotData.innervate.duration, TRB.Data.snapshotData.innervate.endTime, _, _, _, TRB.Data.snapshotData.innervate.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.innervate.id)
							TRB.Data.snapshotData.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.innervate.isActive = false
							TRB.Data.snapshotData.innervate.spellId = nil
							TRB.Data.snapshotData.innervate.duration = 0
							TRB.Data.snapshotData.innervate.endTime = nil
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
				elseif specId == 3 then
					if settings.mindbender.enabled and type == "SPELL_ENERGIZE" and
						((TRB.Data.character.talents.mindbender.isSelected and sourceName == TRB.Data.spells.mindbender.name) or
						(not TRB.Data.character.talents.mindbender.isSelected and sourceName == TRB.Data.spells.shadowfiend.name)) then
						TRB.Data.snapshotData.mindbender.swingTime = currentTime
					elseif (type == "SPELL_INSTAKILL" or type == "UNIT_DIED" or type == "UNIT_DESTROYED") then
						if TRB.Data.snapshotData.voidform.s2m.active then -- Surrender to Madness ended
							s2mDeath = true
						end
					end
				end
			end

			if sourceGUID == TRB.Data.character.guid then
				if specId == 2 then
					if spellId == TRB.Data.spells.symbolOfHope.id then
						if type == "SPELL_AURA_REMOVED" then -- Lost Symbol of Hope
							-- Let UpdateSymbolOfHope() clean this up
							UpdateSymbolOfHope(true)
						end
					elseif spellId == TRB.Data.spells.potionOfSpiritualClarity.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Spiritual Clarity
							TRB.Data.snapshotData.potionOfSpiritualClarity.isActive = true
							TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining = TRB.Data.spells.potionOfSpiritualClarity.ticks
							TRB.Data.snapshotData.potionOfSpiritualClarity.mana = TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfSpiritualClarity.mana, true)
							TRB.Data.snapshotData.potionOfSpiritualClarity.endTime = currentTime + TRB.Data.spells.potionOfSpiritualClarity.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Spiritual Clarity channel
							-- Let UpdatePotionOfSpiritualClarity() clean this up
							UpdatePotionOfSpiritualClarity(true)
						end
					elseif spellId == TRB.Data.spells.apotheosis.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.apotheosis.isActive = true
							_, _, _, _, TRB.Data.snapshotData.apotheosis.duration, TRB.Data.snapshotData.apotheosis.endTime, _, _, _, TRB.Data.snapshotData.apotheosis.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.apotheosis.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.apotheosis.isActive = false
							TRB.Data.snapshotData.apotheosis.spellId = nil
							TRB.Data.snapshotData.apotheosis.duration = 0
							TRB.Data.snapshotData.apotheosis.endTime = nil
						end
					elseif spellId == TRB.Data.spells.surgeOfLight.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.surgeOfLight.isActive = true
							_, _, TRB.Data.snapshotData.surgeOfLight.stacks, _, TRB.Data.snapshotData.surgeOfLight.duration, TRB.Data.snapshotData.surgeOfLight.endTime, _, _, _, TRB.Data.snapshotData.surgeOfLight.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.surgeOfLight.id)
						elseif type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
							TRB.Data.snapshotData.audio.surgeOfLight2Cue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.surgeOfLight.isActive = false
							TRB.Data.snapshotData.surgeOfLight.spellId = nil
							TRB.Data.snapshotData.surgeOfLight.duration = 0
							TRB.Data.snapshotData.surgeOfLight.stacks = 0
							TRB.Data.snapshotData.surgeOfLight.endTime = nil
							TRB.Data.snapshotData.audio.surgeOfLightCue = false
							TRB.Data.snapshotData.audio.surgeOfLight2Cue = false
						end
					elseif spellId == TRB.Data.spells.holyWordSerenity.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Serenity
							TRB.Data.snapshotData.holyWordSerenity.startTime, TRB.Data.snapshotData.holyWordSerenity.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSerenity.id)
						end
					elseif spellId == TRB.Data.spells.holyWordSanctify.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Sanctify
							TRB.Data.snapshotData.holyWordSanctify.startTime, TRB.Data.snapshotData.holyWordSanctify.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSanctify.id)
						end
					elseif spellId == TRB.Data.spells.holyWordChastise.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Chastise
							TRB.Data.snapshotData.holyWordChastise.startTime, TRB.Data.snapshotData.holyWordChastise.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordChastise.id)
						end
					end
				elseif specId == 3 then
					if spellId == TRB.Data.spells.s2m.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Surrender to Madness
							TRB.Data.snapshotData.voidform.s2m.active = true
							TRB.Data.snapshotData.voidform.s2m.startTime = currentTime
							UpdateCastingResourceFinal_Shadow()
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" and TRB.Data.snapshotData.voidform.s2m.active then -- Lose Surrender to Madness
							if destGUID == TRB.Data.character.guid then -- You died
								s2mDeath = true
							end
							TRB.Data.snapshotData.voidform.s2m.startTime = nil
							TRB.Data.snapshotData.voidform.s2m.active = false
						end
					elseif spellId == TRB.Data.spells.deathAndMadness.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Death and Madness
							TRB.Data.snapshotData.deathAndMadness.isActive = true
							TRB.Data.snapshotData.deathAndMadness.ticksRemaining = TRB.Data.spells.deathAndMadness.ticks
							TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
							TRB.Data.snapshotData.deathAndMadness.endTime = currentTime + TRB.Data.spells.deathAndMadness.duration
							TRB.Data.snapshotData.deathAndMadness.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshotData.deathAndMadness.ticksRemaining = TRB.Data.spells.deathAndMadness.ticks + 1
							TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
							TRB.Data.snapshotData.deathAndMadness.endTime = currentTime + TRB.Data.spells.deathAndMadness.duration + ((TRB.Data.spells.deathAndMadness.duration / TRB.Data.spells.deathAndMadness.ticks) - (currentTime - TRB.Data.snapshotData.deathAndMadness.lastTick))
							TRB.Data.snapshotData.deathAndMadness.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.deathAndMadness.isActive = false
							TRB.Data.snapshotData.deathAndMadness.ticksRemaining = 0
							TRB.Data.snapshotData.deathAndMadness.insanity = 0
							TRB.Data.snapshotData.deathAndMadness.endTime = nil
							TRB.Data.snapshotData.deathAndMadness.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.deathAndMadness.ticksRemaining = TRB.Data.snapshotData.deathAndMadness.ticksRemaining - 1
							TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
							TRB.Data.snapshotData.deathAndMadness.lastTick = currentTime
						end
					elseif spellId == TRB.Data.spells.mindSear.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_CAST_SUCCESS" then
							if TRB.Data.snapshotData.mindSear.hitTime == nil then --This is a new cast without target data
								TRB.Data.snapshotData.mindSear.targetsHit = 1
							end
							TRB.Data.snapshotData.mindSear.hitTime = currentTime
						end
					elseif spellId == TRB.Data.spells.mindSear.idTick then
						if type == "SPELL_DAMAGE" then
							if currentTime > (TRB.Data.snapshotData.mindSear.hitTime + 0.1) then --This is a new tick
								TRB.Data.snapshotData.mindSear.targetsHit = 0
							end
							TRB.Data.snapshotData.mindSear.targetsHit = TRB.Data.snapshotData.mindSear.targetsHit + 1
							TRB.Data.snapshotData.mindSear.hitTime = currentTime
							TRB.Data.snapshotData.mindSear.hasStruckTargets = true
						end
					elseif spellId == TRB.Data.spells.vampiricTouch.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- VT Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].vampiricTouch = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.vampiricTouch = TRB.Data.snapshotData.targetData.vampiricTouch + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].vampiricTouch = false
								TRB.Data.snapshotData.targetData.targets[destGUID].vampiricTouchRemaining = 0
								TRB.Data.snapshotData.targetData.vampiricTouch = TRB.Data.snapshotData.targetData.vampiricTouch - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.devouringPlague.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- DP Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].devouringPlague = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.devouringPlague = TRB.Data.snapshotData.targetData.devouringPlague + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].devouringPlague = false
								TRB.Data.snapshotData.targetData.targets[destGUID].devouringPlagueRemaining = 0
								TRB.Data.snapshotData.targetData.devouringPlague = TRB.Data.snapshotData.targetData.devouringPlague - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif settings.auspiciousSpiritsTracker and TRB.Data.character.talents.as.isSelected and spellId == TRB.Data.spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
						InitializeTarget(destGUID)
						TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits + 1
						TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits + 1
						triggerUpdate = true
					elseif settings.auspiciousSpiritsTracker and TRB.Data.character.talents.as.isSelected and spellId == TRB.Data.spells.auspiciousSpirits.idImpact and (type == "SPELL_DAMAGE" or type == "SPELL_MISSED" or type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
						if TRB.Functions.CheckTargetExists(destGUID) then
							TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits - 1
							TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits - 1
						end
						triggerUpdate = true
					elseif type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.shadowCrash.id then
						triggerUpdate = true
					elseif spellId == TRB.Data.spells.memoryOfLucidDreams.id then
						if type == "SPELL_AURA_APPLIED" then -- Gained buff
							TRB.Data.spells.memoryOfLucidDreams.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.memoryOfLucidDreams.isActive = false
						end
					elseif spellId == TRB.Data.spells.mindDevourer.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.mindDevourer.isActive = true
							_, _, _, _, TRB.Data.snapshotData.mindDevourer.duration, TRB.Data.snapshotData.mindDevourer.endTime, _, _, _, TRB.Data.snapshotData.mindDevourer.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.mindDevourer.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.mindDevourer.isActive = false
							TRB.Data.snapshotData.mindDevourer.spellId = nil
							TRB.Data.snapshotData.mindDevourer.duration = 0
							TRB.Data.snapshotData.mindDevourer.endTime = nil
						end
					elseif spellId == TRB.Data.spells.twistOfFate.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.twistOfFate.isActive = true
							_, _, _, _, TRB.Data.snapshotData.twistOfFate.duration, TRB.Data.snapshotData.twistOfFate.endTime, _, _, _, TRB.Data.snapshotData.twistOfFate.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.twistOfFate.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.twistOfFate.isActive = false
							TRB.Data.snapshotData.twistOfFate.spellId = nil
							TRB.Data.snapshotData.twistOfFate.duration = 0
							TRB.Data.snapshotData.twistOfFate.endTime = nil
						end
					elseif type == "SPELL_SUMMON" and settings.voidTendrilTracker and (spellId == TRB.Data.spells.eternalCallToTheVoid_Tendril.id or spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.id) then
						InitializeVoidTendril(destGUID)
						if spellId == TRB.Data.spells.eternalCallToTheVoid_Tendril.id then
							TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].type = "Tendril"
						elseif spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.id then
							TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].type = "Lasher"
							TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].targetsHit = 0
							TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].hasStruckTargets = true
						end

						TRB.Data.snapshotData.eternalCallToTheVoid.numberActive = TRB.Data.snapshotData.eternalCallToTheVoid.numberActive + 1
						TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining = TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining + TRB.Data.spells.lashOfInsanity_Tendril.ticks
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].startTime = currentTime
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].tickTime = currentTime
					end
				end

				-- Spec agnostic
				if settings.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerie.id then
					if type == "SPELL_AURA_APPLIED" then -- Gained buff
						if TRB.Data.snapshotData.wrathfulFaerie.main.isActive == false then
							TRB.Data.snapshotData.wrathfulFaerie.main.isActive = true
							TRB.Data.snapshotData.wrathfulFaerie.main.endTime = currentTime + (TRB.Data.spells.wrathfulFaerie.duration * TRB.Data.character.torghast.dreamspunMushroomsModifier)
						end
						TRB.Data.snapshotData.targetData.wrathfulFaerieGuid = destGUID
					-- We're not doing much in these case because it could have been moved or refreshed via SWP on a new target.
					--elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
					--elseif type == "SPELL_AURA_REFRESH" then -- Refreshed buff
					end
				elseif settings.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerie.energizeId and type == "SPELL_ENERGIZE" then
					TRB.Data.snapshotData.wrathfulFaerie.main.procTime = currentTime
				elseif settings.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerieFermata.id then
					if type == "SPELL_AURA_APPLIED" then -- Gained buff
						if TRB.Data.snapshotData.wrathfulFaerie.fermata.isActive == false or TRB.Data.snapshotData.targetData.wrathfulFaerieFermataGuid ~= destGUID then
							TRB.Data.snapshotData.wrathfulFaerie.fermata.isActive = true
							local duration = TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[TRB.Functions.GetSoulbindRank(TRB.Data.spells.wrathfulFaerieFermata.conduitId)] * TRB.Data.character.torghast.dreamspunMushroomsModifier
							TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime = currentTime + duration
						end
						TRB.Data.snapshotData.targetData.wrathfulFaerieFermataGuid = destGUID
					-- We're not doing much in these case because it could have been moved or refreshed via SWP on a new target.
					--elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
					--elseif type == "SPELL_AURA_REFRESH" then -- Refreshed buff
					end
				elseif settings.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerieFermata.energizeId and type == "SPELL_ENERGIZE" then
					TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime = currentTime
				elseif settings.wrathfulFaerie.enabled and spellId == TRB.Data.spells.hauntedMask.id then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" and auraType == "DEBUFF" then
							TRB.Data.snapshotData.targetData.targets[destGUID].hauntedMask = true
						elseif type == "SPELL_AURA_REMOVED" and auraType == "DEBUFF" then
							TRB.Data.snapshotData.targetData.targets[destGUID].hauntedMask = false
						end
					end
				elseif spellId == TRB.Data.spells.shadowWordPain.id then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- SWP Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].shadowWordPain = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshotData.targetData.shadowWordPain = TRB.Data.snapshotData.targetData.shadowWordPain + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].shadowWordPain = false
							TRB.Data.snapshotData.targetData.targets[destGUID].shadowWordPainRemaining = 0
							TRB.Data.snapshotData.targetData.shadowWordPain = TRB.Data.snapshotData.targetData.shadowWordPain - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				end
			elseif specId == 3 and settings.voidTendrilTracker and (spellId == TRB.Data.spells.eternalCallToTheVoid_Tendril.idTick or spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.idTick) and CheckVoidTendrilExists(sourceGUID) then
				if spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.idTick and type == "SPELL_DAMAGE" then
					if currentTime > (TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].tickTime + 0.1) then --This is a new tick
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].targetsHit = 0
					end
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].targetsHit = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].targetsHit + 1
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].tickTime = currentTime
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].hasStruckTargets = true
				else
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].tickTime = currentTime
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				TRB.Functions.RemoveTarget(destGUID)
				RefreshTargetTracking()

				if destGUID == TRB.Data.snapshotData.targetData.wrathfulFaerieGuid then
					TRB.Data.snapshotData.targetData.wrathfulFaerieGuid = nil
				end
				triggerUpdate = true
			end

			if UnitIsDeadOrGhost("player") then -- We died/are dead go ahead and purge the list
			--if UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player") or event == "PLAYER_REGEN_ENABLED" then -- We died, or, exited combat, go ahead and purge the list
				TargetsCleanup(true)
				triggerUpdate = true
			end

			if s2mDeath then
				if settings.audio.s2mDeath.enabled then
					PlaySoundFile(settings.audio.s2mDeath.sound, TRB.Data.settings.core.audio.channel.channel)
				end
				TRB.Data.snapshotData.voidform.s2m.startTime = nil
				TRB.Data.snapshotData.voidform.s2m.active = false
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
		if classIndex == 5 then
			if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Priest.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					FillSpecCache()
					FillSpellData_Holy()
					FillSpellData_Shadow()

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
					TRB.Data.settings.priest.holy = TRB.Functions.ValidateLsmValues("Holy Priest", TRB.Data.settings.priest.holy)
					TRB.Data.settings.priest.shadow = TRB.Functions.ValidateLsmValues("Shadow Priest", TRB.Data.settings.priest.shadow)
					TRB.Options.Priest.ConstructOptionsPanel(specCache)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					if specId == 1 then
					elseif specId == 2 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.priest.holy)
						TRB.Functions.IsTtdActive(TRB.Data.settings.priest.holy)
						FillSpellData_Shadow()
						TRB.Functions.LoadFromSpecCache(specCache.holy)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Holy

						if TRB.Data.barConstructedForSpec ~= "holy" then
							TRB.Data.barConstructedForSpec = "holy"
							ConstructResourceBar(TRB.Data.settings.priest.holy)
						end
					elseif specId == 3 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.priest.shadow)
						TRB.Functions.IsTtdActive(TRB.Data.settings.priest.shadow)
						FillSpellData_Shadow()
						TRB.Functions.LoadFromSpecCache(specCache.shadow)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow

						if TRB.Data.barConstructedForSpec ~= "shadow" then							
							TRB.Data.barConstructedForSpec = "shadow"
							ConstructResourceBar(TRB.Data.settings.priest.shadow)
						end
					end
					EventRegistration()
				end
			end
		end
	end)
end

