local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
	TRB.Functions.Class = TRB.Functions.Class or {}
	TRB.Functions.Character:ResetSnapshotData()
	
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
			snapshot = {},
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
		shadow = {
			snapshot = {},
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

	local function FillSpecializationCache()
		-- Holy
		specCache.holy.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				channeledPotion = 0,
				manaTideTotem = 0,
				innervate = 0,
				potionOfChilledClarity = 0,
				symbolOfHope = 0,
				shadowfiend = 0,
			},
			dots = {
				swpCount = 0
			},
			isPvp = false
		}

		specCache.holy.character = {
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

		specCache.holy.spells = {
			-- Priest Class Baseline Abilities
			flashHeal = {
				id = 2061,
				name = "",
				icon = "",
				holyWordKey = "holyWordSerenity",
				holyWordReduction = 6,
				isTalent = false,
				baseline = true
			},
			shadowWordPain = {
				id = 589,
				icon = "",
				name = "",
				baseDuration = 16,
				pandemic = true,
				pandemicTime = 16 * 0.3,
				isTalent = false,
				baseline = true
			},
			smite = {
				id = 585,
				name = "",
				icon = "",
				holyWordKey = "holyWordChastise",
				holyWordReduction = 4,
				isTalent = false,
				baseline = true
			},

			-- Holy Baseline Abilities
			heal = {
				id = 2060,
				name = "",
				icon = "",
				holyWordKey = "holyWordSerenity",
				holyWordReduction = 6,
				isTalent = false,
				baseline = true
			},

			-- Priest Talent Abilities
			shadowfiend = {
				id = 34433,
				name = "",
				icon = "",
				energizeId = 343727,
				texture = "",
				thresholdId = 8,
				settingKey = "shadowfiend",
				isTalent = true,
				manaPercent = 0.005,
				duration = 15
			},
			prayerOfMending = {
				id = 33076,
				name = "",
				icon = "",
				holyWordKey = "holyWordSerenity",
				holyWordReduction = 2, -- Per rank of Harmonious Apparatus
				isTalent = true,
				baseline = true
			},
			renew = {
				id = 139,
				name = "",
				icon = "",
				holyWordKey = "holyWordSanctify",
				holyWordReduction = 2,
				isTalent = true,
				baseline = true
			},
			surgeOfLight = {
				id = 114255,
				name = "",
				icon = "",
				duration = 20,
				isTalent = true
			},
			powerWordLife = {
				id = 88625,
				name = "",
				icon = "",
				duration = 30,
				isTalent = true
			},

			-- Holy Talent Abilities
			holyWordSerenity = {
				id = 2050,
				name = "",
				icon = "",
				duration = 60
			},
			prayerOfHealing = {
				id = 596,
				name = "",
				icon = "",
				holyWordKey = "holyWordSanctify",
				holyWordReduction = 6,
				isTalent = true
			},
			holyWordChastise = {
				id = 88625,
				name = "",
				icon = "",
				duration = 60,
				isTalent = true
			},
			holyWordSanctify = {
				id = 34861,
				name = "",
				icon = "",
				duration = 60,
				isTalent = true
			},
			holyFire = {
				id = 14914,
				name = "",
				icon = "",
				holyWordKey = "holyWordChastise",
				holyWordReduction = 2, -- Per rank of Harmonious Apparatus
				isTalent = true
			},
			circleOfHealing = {
				id = 204883,
				name = "",
				icon = "",
				holyWordKey = "holyWordSanctify",
				holyWordReduction = 2, -- Per rank of Harmonious Apparatus
				isTalent = true
			},
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 4.0, --Hasted
				manaPercent = 0.05,
				ticks = 3,
				tickId = 265144,
				isTalent = true
			},
			lightOfTheNaaru = {
				id = 196985,
				name = "",
				icon = "",
				holyWordModifier = 0.1, -- Per rank
				isTalent = true
			},
			harmoniousApparatus = {
				id = 196985,
				name = "",
				icon = "",
				holyWordModifier = 0.1, -- Per rank
				isTalent = true
			},
			apotheosis = {
				id = 200183,
				name = "",
				icon = "",
				holyWordModifier = 4, -- 300% more
				duration = 20,
				isTalent = true
			},
			resonantWords = {
				id = 372313,
				talentId = 372309,
				name = "",
				icon = "",
				isTalent = true
			},
			lightweaver = {
				id = 390993,
				talentId = 390992,
				name = "",
				icon = "",
				maxStacks = 2,
				isTalent = true
			},

			-- External mana
			innervate = {
				id = 29166,
				name = "",
				icon = "",
				duration = 10
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8
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
			potionOfChilledClarity = {
				id = 371052,
				name = "",
				icon = ""
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
				mana = 4830,
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

			-- Rashok's Molten Heart
			moltenRadiance = {
				id = 409898,
				name = "",
				icon = "",
			},

			-- Set Bonuses
			divineConversation = { -- T28 4P
				id = 363727,
				name = "",
				icon = "",
				reduction = 15,
				reductionPvp = 10
			},
			prayerFocus = { -- T29 2P
				id = 394729,
				name = "",
				icon = "",
				holyWordReduction = 2
			}
		}

		specCache.holy.snapshot.manaRegen = 0
		specCache.holy.snapshot.audio = {
			innervateCue = false,
			resonantWordsCue = false,
			lightweaverCue = false,
			surgeOfLightCue = false,
			surgeOfLight2Cue = false
		}
		specCache.holy.snapshot.innervate = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.holy.snapshot.potionOfChilledClarity = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.holy.snapshot.manaTideTotem = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.holy.snapshot.shadowfiend = {
			isActive = false,
			startTime = nil,
			guid = nil,
			totemId = nil,
			duration = 0,
			remainingTime = 0,
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
		specCache.holy.snapshot.apotheosis = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.holy.snapshot.surgeOfLight = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.holy.snapshot.resonantWords = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.holy.snapshot.lightweaver = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.holy.snapshot.symbolOfHope = {
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
		specCache.holy.snapshot.holyWordSerenity = {
			startTime = nil,
			duration = 0,
			onCooldown = false
		}
		specCache.holy.snapshot.holyWordSanctify = {
			startTime = nil,
			duration = 0,
			onCooldown = false
		}
		specCache.holy.snapshot.holyWordChastise = {
			startTime = nil,
			duration = 0,
			onCooldown = false
		}
		specCache.holy.snapshot.channeledManaPotion = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.holy.snapshot.potion = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.holy.snapshot.conjuredChillglobe = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.holy.snapshot.moltenRadiance = {
			spellId = nil,
			startTime = nil,
			duration = 0,
			manaPerTick = 0,
			mana = 0
		}
		specCache.holy.snapshot.divineConversation = {
			isActive = false
		}
		specCache.holy.snapshot.prayerFocus = {
			isActive = false
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
				shadowfiend = 0,
				ecttv = 0
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
			shadowfiend = {
				insanity = 0,
				gcds = 0,
				swings = 0,
				time = 0
			}
		}

		specCache.shadow.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			devouringPlagueThreshold = 50,
			effects = {
			},
			items = {
				callToTheVoid = false
			}
		}

		specCache.shadow.spells = {
			-- Priest Class Baseline Abilities
			mindBlast = {
				id = 8092,
				name = "",
				icon = "",
				insanity = 6,
				isTalent = false,
				baseline = true
			},
			shadowWordPain = {
				id = 589,
				icon = "",
				name = "",
				insanity = 3,
				baseDuration = 16,
				pandemic = true,
				pandemicTime = 16 * 0.3,
				isTalent = false,
				baseline = true,
				miseryPandemic = 21,
				miseryPandemicTime = 21 * 0.3,
			},


			-- Shadow Baseline Abilities
			mindFlay = {
				id = 15407,
				name = "",
				icon = "",
				insanity = 2,
				isTalent = false,
				baseline = true
			},
			vampiricTouch = {
				id = 34914,
				name = "",
				icon = "",
				insanity = 4,
				baseDuration = 21,
				pandemic = true,
				pandemicTime = 21 * 0.3,
				isTalent = false,
				baseline = true
			},
			voidBolt = {
				id = 205448,
				name = "",
				icon = "",
				insanity = 10,
				isTalent = false,
				baseline = true
			},


			-- Priest Talent Abilities			
			shadowfiend = {
				id = 34433,
				energizeId = 279420,
				name = "",
				icon = "",
				insanity = 2,
				isTalent = true,
				baseline = true
			},
			massDispel = {
				id = 32375,
				name = "",
				icon = "",
				isTalent = true
			},
			twistOfFate = {
				id = 123254,
				name = "",
				icon = "",
				isTalent = true
			},
			halo = {
				id = 120644,
				name = "",
				icon = "",
				isTalent = true,
				insanity = 10
			},
			mindgames = {
				id = 375901,
				name = "",
				icon = "",
				isTalent = true,
				insanity = 10
			},


			-- Shadow Talent Abilities			
			devouringPlague = {
				id = 335467,
				name = "",
				icon = "",
				texture = "",
				insanity = -50,
				thresholdId = 1,
				settingKey = "devouringPlague",
				thresholdUsable = false,
				isTalent = true,
				isSnowflake = true
			},			
			devouringPlague2 = {
				id = 335467,
				name = "",
				icon = "",
				texture = "",
				insanity = -100,
				thresholdId = 2,
				settingKey = "devouringPlague2",
				thresholdUsable = false,
				isTalent = true,
				isSnowflake = true
			},			
			devouringPlague3 = {
				id = 335467,
				name = "",
				icon = "",
				texture = "",
				insanity = -150,
				thresholdId = 3,
				settingKey = "devouringPlague3",
				thresholdUsable = false,
				isTalent = true,
				isSnowflake = true
			},
			shadowyApparition = {
				id = 341491,
				name = "",
				icon = "",
				isTalent = true
			},
			auspiciousSpirits = {
				id = 155271,
				idSpawn = 341263,
				idImpact = 413231,
				insanity = 1,
				targetChance = function(num)
					if num == 0 then
						return 0
					else
						return 0.8*(num^(-0.8))
					end
				end,
				name = "",
				icon = "",
				isTalent = true
			},
			misery = {
				id = 238558,
				name = "",
				icon = "",
				isTalent = true
			},
			hallucinations = {
				id = 280752,
				name = "",
				icon = "",
				insanity = 4,
				isTalent = true
			},
			voidEruption = {
				id = 228260,
				name = "",
				icon = "",
				isTalent = true
			},
			voidform = {
				id = 194249,
				name = "",
				icon = "",
				isTalent = true
			},
			darkAscension = {
				id = 391109,
				name = "",
				icon = "",
				insanity = 30,
				isTalent = true
			},
			mindSpike = {
				id = 73510,
				name = "",
				icon = "",
				insanity = 4,
				isTalent = true
			},
			darkEvangelism = {
				id = 73510,
				name = "",
				icon = "",
				maxStacks = 5,
				isTalent = true
			},
			mindsEye = {
				id = 407470,
				name = "",
				icon = "",
				isTalent = true,
				insanityMod = -5
			},
			distortedReality = {
				id = 409044,
				name = "",
				icon = "",
				isTalent = true,
				insanityMod = 5
			},
			mindFlayInsanity = {
				id = 391403,
				name = "",
				icon = "",
				buffId = 391401,
				insanity = 3,
				isTalent = true
			},
			mindSpikeInsanity = {
				id = 407466,
				name = "",
				icon = "",
				buffId = 407468,
				talentId = 391403,
				insanity = 6,
				isTalent = true
			},
			deathspeaker = {
				id = 392507,
				name = "",
				icon = "",
				buffId = 392511,
				isTalent = true
			},
			voidTorrent = {
				id = 263165,
				name = "",
				icon = "",
				insanity = 6,
				isTalent = true
			},
			shadowCrash = {
				id = 205385,
				name = "",
				icon = "",
				insanity = 6,
				isTalent = true
			},
			shadowyInsight = {
				id = 375981,
				name = "",
				icon = "",
				isTalent = true
			},
			mindMelt = {
				id = 391092,
				name = "",
				icon = "",
				isTalent = true,
				maxStacks = 4
			},
			maddeningTouch = {
				id = 73510,
				name = "",
				icon = "",
				insanity = 1,
				perRank = 0.5,
				isTalent = true
			},
			mindbender = {
				id = 200174,
				energizeId = 200010,
				name = "",
				icon = "",
				insanity = 2,
				isTalent = true
			},
			devouredDespair = { -- Idol of Y'Shaarj proc
				id = 373317,
				name = "",
				icon = "",
				insanity = 5,
				duration = 15,
				ticks = 15
			},
			mindDevourer = {
				id = 373202,
				buffId = 373204,
				name = "",
				icon = "",
				isTalent = true
			},
			idolOfCthun = {
				id = 377349,
				name = "",
				icon = "",
			},
			idolOfCthun_Tendril = {
				id = 377355,
				idTick = 193473,
				name = "",
				icon = "",
			},
			idolOfCthun_Lasher = {
				id = 377357,
				idTick = 394979,
				name = "",
				icon = "",
			},
			lashOfInsanity_Tendril = {
				id = 344838,
				name = "",
				icon = "",
				insanity = 1,
				duration = 15,
				ticks = 15,
				tickDuration = 1
			},
			lashOfInsanity_Lasher = {
				id = 344838, --Doesn't actually exist / unused?
				name = "",
				icon = "",
				insanity = 1,
				duration = 15,
				ticks = 15,
				tickDuration = 1
			},
			idolOfYoggSaron = {
				id = 373276,
				name = "",
				icon = "",
				isTalent = true,
				maxStacks = 24,
				requiredStacks = 25
			},
			thingFromBeyond = {
				id = 373277,
				name = "",
				icon = "",
				isTalent = true,
				duration = 20
			},
		}

		specCache.shadow.snapshot.voidform = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.shadow.snapshot.darkAscension = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.shadow.snapshot.audio = {
			playedDpCue = false,
			playedMdCue = false,
			playedDeathspeakerCue = false,
			overcapCue = false
		}
		specCache.shadow.snapshot.shadowfiend = {
			isActive = false,
			guid = nil,
			totemId = nil,
			startTime = nil,
			duration = 0,
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
		specCache.shadow.snapshot.devouredDespair = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0,
			insanity = 0,
			ticks = 0
		}
		specCache.shadow.snapshot.voidTendrils = {
			numberActive = 0,
			resourceRaw = 0,
			resourceFinal = 0,
			maxTicksRemaining = 0,
			activeList = {}
		}
		specCache.shadow.snapshot.mindDevourer = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshot.mindFlayInsanity = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			remainingTime = 0,
			duration = 0
		}
		specCache.shadow.snapshot.deathspeaker = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshot.twistOfFate = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshot.mindMelt = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.shadow.snapshot.shadowyInsight = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
		}
		specCache.shadow.snapshot.voidBolt = {
			lastSuccess = nil,
			flightTime = 1.0
		}
		specCache.shadow.snapshot.mindBlast = {
			startTime = nil,
			duration = 0,
			charges = 1,
			maxCharges = 1
		}
		specCache.shadow.snapshot.idolOfYoggSaron = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.shadow.snapshot.thingFromBeyond = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
	end

	local function Setup_Holy()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "priest", "holy")
	end

	local function FillSpellData_Holy()
		Setup_Holy()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.holy.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.holy.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#apotheosis", icon = spells.apotheosis.icon, description = spells.apotheosis.name, printInSettings = true },
			{ variable = "#coh", icon = spells.circleOfHealing.icon, description = spells.circleOfHealing.name, printInSettings = true },
			{ variable = "#circleOfHealing", icon = spells.circleOfHealing.icon, description = spells.circleOfHealing.name, printInSettings = false },
			{ variable = "#flashHeal", icon = spells.flashHeal.icon, description = spells.flashHeal.name, printInSettings = true },
			{ variable = "#ha", icon = spells.harmoniousApparatus.icon, description = spells.harmoniousApparatus.name, printInSettings = true },
			{ variable = "#harmoniousApparatus", icon = spells.harmoniousApparatus.icon, description = spells.harmoniousApparatus.name, printInSettings = false },
			{ variable = "#heal", icon = spells.heal.icon, description = spells.heal.name, printInSettings = true },
			{ variable = "#hf", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = true },
			{ variable = "#holyFire", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = false },
			{ variable = "#hwChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = true },
			{ variable = "#chastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
			{ variable = "#holyWordChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
			{ variable = "#hwSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = true },
			{ variable = "#sanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
			{ variable = "#holyWordSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
			{ variable = "#hwSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = true },
			{ variable = "#serenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
			{ variable = "#holyWordSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
			{ variable = "#lightweaver", icon = spells.lightweaver.icon, description = spells.lightweaver.name, printInSettings = true },
			{ variable = "#rw", icon = spells.resonantWords.icon, description = spells.resonantWords.name, printInSettings = true },
			{ variable = "#resonantWords", icon = spells.resonantWords.icon, description = spells.resonantWords.name, printInSettings = false },
			{ variable = "#innervate", icon = spells.innervate.icon, description = spells.innervate.name, printInSettings = true },
			{ variable = "#lotn", icon = spells.lightOfTheNaaru.icon, description = spells.lightOfTheNaaru.name, printInSettings = true },
			{ variable = "#lightOfTheNaaru", icon = spells.lightOfTheNaaru.icon, description = spells.lightOfTheNaaru.name, printInSettings = false },
			{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
			{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },
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

			{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
			{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
			{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
			{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
			{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = false },

			{ variable = "#swp", icon = spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = true },
			{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = false },
			
			{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = "Shadowfiend", printInSettings = false },
			{ variable = "#sf", icon = spells.shadowfiend.icon, description = "Shadowfiend", printInSettings = true },
		}
		specCache.holy.barTextVariables.values = {
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
			
			{ variable = "$lightweaverStacks", description = "Number of Lightweaver stacks", printInSettings = true, color = false },
			{ variable = "$lightweaverTime", description = "Time left on Lightweaver", printInSettings = true, color = false },

			{ variable = "$rwTime", description = "Time left on Resonant Words", printInSettings = true, color = false },

			{ variable = "$sohMana", description = "Mana from Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTime", description = "Time left on Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTicks", description = "Number of ticks left from Symbol of Hope", printInSettings = true, color = false },

			{ variable = "$innervateMana", description = "Passive mana regen while Innervate is active", printInSettings = true, color = false },
			{ variable = "$innervateTime", description = "Time left on Innervate", printInSettings = true, color = false },

			{ variable = "$potionOfChilledClarityMana", description = "Passive mana regen while Potion of Chilled Clarity's effect is active", printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = "Time left on Potion of Chilled Clarity's effect", printInSettings = true, color = false },
									
			{ variable = "$mrMana", description = "Mana from Molten Radiance", printInSettings = true, color = false },
			{ variable = "$mrTime", description = "Time left on Molten Radiance", printInSettings = true, color = false },

			{ variable = "$mttMana", description = "Bonus passive mana regen while Mana Tide Totem is active", printInSettings = true, color = false },
			{ variable = "$mttTime", description = "Time left on Mana Tide Totem", printInSettings = true, color = false },

			{ variable = "$channeledMana", description = "Mana while channeling of Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTicks", description = "Number of ticks left channeling Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Frozen Focus", printInSettings = true, color = false },
			
			{ variable = "$potionCooldown", description = "How long, in seconds, is left on your potion's cooldown in MM:SS format", printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = "How long, in seconds, is left on your potion's cooldown in seconds", printInSettings = true, color = false },

			{ variable = "$swpCount", description = "Number of Shadow Word: Pains active on targets", printInSettings = true, color = false },
			{ variable = "$swpTime", description = "Time remaining on Shadow Word: Pain on your current target", printInSettings = true, color = false },
			
			{ variable = "$sfMana", description = "Mana from Shadowfiend (as configured)", printInSettings = true, color = false },
			{ variable = "$sfGcds", description = "Number of GCDs left on Shadowfiend", printInSettings = true, color = false },
			{ variable = "$sfSwings", description = "Number of Swings left on Shadowfiend", printInSettings = true, color = false },
			{ variable = "$sfTime", description = "Time left on Shadowfiend", printInSettings = true, color = false },


			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.holy.spells = spells
	end


	local function Setup_Shadow()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "priest", "shadow")
	end

	local function FillSpellData_Shadow()
		Setup_Shadow()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.shadow.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.shadow.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Insanity generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#as", icon = spells.auspiciousSpirits.icon, description = spells.auspiciousSpirits.name, printInSettings = true },
			{ variable = "#auspiciousSpirits", icon = spells.auspiciousSpirits.icon, description = spells.auspiciousSpirits.name, printInSettings = false },
			
			{ variable = "#cthun", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = true },
			{ variable = "#idolOfCthun", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = false },
			{ variable = "#loi", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = false },

			{ variable = "#dp", icon = spells.devouringPlague.icon, description = spells.devouringPlague.name, printInSettings = true },
			{ variable = "#devouringPlague", icon = spells.devouringPlague.icon, description = spells.devouringPlague.name, printInSettings = false },

			{ variable = "#halo", icon = spells.halo.icon, description = spells.halo.name, printInSettings = true },

			{ variable = "#mDev", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = true },
			{ variable = "#mindDevourer", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = false },

			{ variable = "#mindgames", icon = spells.mindgames.icon, description = spells.mindgames.name, printInSettings = true },

			{ variable = "#mb", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = true },
			{ variable = "#mindBlast", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = false },
			
			{ variable = "#md", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = true },
			{ variable = "#massDispel", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = false },
			
			{ variable = "#mfi", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = true },
			{ variable = "#mindFlayInsanity", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = false },

			{ variable = "#mf", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = true },
			{ variable = "#mindFlay", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = false },
			
			{ variable = "#mm", icon = spells.mindMelt.icon, description = spells.mindMelt.name, printInSettings = true },
			{ variable = "#mindMelt", icon = spells.mindMelt.icon, description = spells.mindMelt.name, printInSettings = false },
																  
			{ variable = "#sa", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = true },
			{ variable = "#shadowyApparition", icon = spells.shadowyApparition.icon, description = spells.shadowyApparition.name, printInSettings = false },
																					  																															  
			{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
			{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },

			{ variable = "#swd", icon = spells.deathspeaker.icon, description = spells.deathspeaker.name, printInSettings = true },
			{ variable = "#shadowWordDeath", icon = spells.deathspeaker.icon, description = spells.deathspeaker.name, printInSettings = false },
			{ variable = "#deathspeaker", icon = spells.deathspeaker.icon, description = spells.deathspeaker.name, printInSettings = false },

			{ variable = "#sf", icon = spells.shadowfiend.icon, description = "Shadowfiend / Mindbender", printInSettings = true },
			{ variable = "#mindbender", icon = spells.mindbender.icon, description = "Mindbender", printInSettings = false },
			{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = "Shadowfiend", printInSettings = false },
																						  
			{ variable = "#si", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = true },
			{ variable = "#shadowyInsight", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = false },
			
			{ variable = "#tfb", icon = spells.thingFromBeyond.icon, description = spells.thingFromBeyond.name, printInSettings = true },
			{ variable = "#thingFromBeyond", icon = spells.thingFromBeyond.icon, description = spells.thingFromBeyond.name, printInSettings = false },
			
			{ variable = "#tof", icon = spells.twistOfFate.icon, description = spells.twistOfFate.name, printInSettings = true },
			{ variable = "#twistOfFate", icon = spells.twistOfFate.icon, description = spells.twistOfFate.name, printInSettings = false },

			{ variable = "#vb", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = true },
			{ variable = "#voidBolt", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = false },
			{ variable = "#vf", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = true },
			{ variable = "#voidform", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = false },
																															  
			{ variable = "#voit", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = true },
			{ variable = "#voidTorrent", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = false },

			{ variable = "#vt", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = true },
			{ variable = "#vampiricTouch", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = false },
			
			{ variable = "#ys", icon = spells.idolOfYoggSaron.icon, description = spells.idolOfYoggSaron.name, printInSettings = true },
			{ variable = "#idolOfYoggSaron", icon = spells.idolOfYoggSaron.icon, description = spells.idolOfYoggSaron.name, printInSettings = false },
		}
		specCache.shadow.barTextVariables.values = {
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

			{ variable = "$mbInsanity", description = "Insanity from Mindbender/Shadowfiend (as configured)", printInSettings = true, color = false },
			{ variable = "$mbGcds", description = "Number of GCDs left on Mindbender/Shadowfiend", printInSettings = true, color = false },
			{ variable = "$mbSwings", description = "Number of Swings left on Mindbender/Shadowfiend", printInSettings = true, color = false },
			{ variable = "$mbTime", description = "Time left on Mindbender/Shadowfiend", printInSettings = true, color = false },

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

			{ variable = "$mfiTime", description = "Time remaining on Mind Flay: Insanity/Mind Spike: Insanity buff", printInSettings = true, color = false },
			{ variable = "$mfiStacks", description = "Number of stacks of Mind Flay: Insanity/Mind Spike: Insanity buff", printInSettings = true, color = false },
			
			{ variable = "$deathspeakerTime", description = "Time remaining on Deathspeaker proc", printInSettings = true, color = false },
			
			{ variable = "$siTime", description = "Time remaining on Shadowy Insight buff", printInSettings = true, color = false },
			
			{ variable = "$mindBlastCharges", description = "Current number of Mind Blast charges", printInSettings = true, color = false },
			{ variable = "$mindBlastMaxCharges", description = "Maximum number of Mind Blast charges", printInSettings = true, color = false },

			{ variable = "$mmTime", description = "Time remaining on Mind Melt buff", printInSettings = true, color = false },
			{ variable = "$mmStacks", description = "Time remaining on Mind Melt stacks", printInSettings = true, color = false },

			{ variable = "$vfTime", description = "Duration remaining of Voidform", printInSettings = true, color = false },

			{ variable = "$ysTime", description = "Time remaining on Yogg Saron buff", printInSettings = true, color = false },
			{ variable = "$ysStacks", description = "Number of Yogg Saron stacks", printInSettings = true, color = false },
			{ variable = "$ysRemainingStacks", description = "Number of Yogg Saron stacks until next Thing from Beyond", printInSettings = true, color = false },
			{ variable = "$tfbTime", description = "Time remaining on Thing from Beyond", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.shadow.spells = spells
	end

	local function CheckVoidTendrilExists(guid)
		if guid == nil or (not TRB.Data.snapshot.voidTendrils.activeList[guid] or TRB.Data.snapshot.voidTendrils.activeList[guid] == nil) then
			return false
		end
		return true
	end

	local function InitializeVoidTendril(guid)
		if guid ~= nil and not CheckVoidTendrilExists(guid) then
			TRB.Data.snapshot.voidTendrils.activeList[guid] = {}
			TRB.Data.snapshot.voidTendrils.activeList[guid].startTime = nil
			TRB.Data.snapshot.voidTendrils.activeList[guid].tickTime = nil
			TRB.Data.snapshot.voidTendrils.activeList[guid].type = nil
			TRB.Data.snapshot.voidTendrils.activeList[guid].targetsHit = 0
			TRB.Data.snapshot.voidTendrils.activeList[guid].hasStruckTargets = false
		end
	end

	local function RemoveVoidTendril(guid)
		if guid ~= nil and CheckVoidTendrilExists(guid) then
			TRB.Data.snapshot.voidTendrils.activeList[guid] = nil
		end
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot

		---@type TRB.Classes.TargetData
		local targetData = snapshot.targetData

		if specId == 2 then -- Holy
			targetData:UpdateDebuffs(currentTime)
		elseif specId == 3 then -- Shadow
			targetData:UpdateDebuffs(currentTime)

			targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] or 0

			if targetData.count[spells.auspiciousSpirits.id] < 0 then
				targetData.count[spells.auspiciousSpirits.id] = 0
				targetData.custom.auspiciousSpiritsGenerate = 0
			else
				targetData.custom.auspiciousSpiritsGenerate = spells.auspiciousSpirits.targetChance(targetData.count[spells.auspiciousSpirits.id]) * targetData.count[spells.auspiciousSpirits.id]
			end
		end
	end

	local function TargetsCleanup(clearAll)
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshot.targetData
		targetData:Cleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 2 then
			elseif specId == 3 then
				TRB.Data.snapshot.targetData.custom.auspiciousSpiritsGenerate = 0
			end
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

		local entries = TRB.Functions.Table:Length(passiveFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				passiveFrame.thresholds[x]:Hide()
			end
		end

		if specId == 2 then
			for x = 1, 8 do
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end

			for x = 1, 6 do
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
		elseif specId == 3 then
			for x = 1, 3 do
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end

			for x = 1, 1 do
				if TRB.Frames.passiveFrame.thresholds[x] == nil then
					TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
				end

				TRB.Frames.passiveFrame.thresholds[x]:Show()
				TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.passiveFrame.thresholds[x]:Hide()
			end

			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.devouringPlague.settingKey, TRB.Data.settings.priest.shadow)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.devouringPlague2.settingKey, TRB.Data.settings.priest.shadow)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.devouringPlague3.settingKey, TRB.Data.settings.priest.shadow)
		end

		TRB.Functions.Bar:Construct(settings)

		if specId == 2 or specId == 3 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end
	
	local function GetVoidformRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.voidform)
	end
	
	local function GetDarkAscensionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.darkAscension)
	end

	local function GetShadowfiendCooldownRemainingTime(shadowfiend)
		if shadowfiend then
			return TRB.Functions.Spell:GetRemainingTime(shadowfiend)
		else
			return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.shadowfiend)
		end
	end
	
	local function GetApotheosisRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.apotheosis)
	end

	local function GetInnervateRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.innervate)
	end

	local function GetPotionOfChilledClarityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.potionOfChilledClarity)
	end

	local function GetManaTideTotemRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.manaTideTotem)
	end

	local function GetMoltenRadianceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.moltenRadiance)
	end

	local function GetSymbolOfHopeRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.symbolOfHope)
	end

	local function GetSurgeOfLightRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.surgeOfLight)
	end	

	local function GetResonantWordsRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.resonantWords)
	end

	local function GetLightweaverRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.lightweaver)
	end

	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.channeledManaPotion)
	end

	local function GetHolyWordCooldownTimeRemaining(holyWord)
		local currentTime = GetTime()
		local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
		local remainingTime = 0

		if holyWord.duration == gcd or holyWord.startTime == nil or holyWord.startTime == 0 or holyWord.duration == 0 then
			remainingTime = 0
		else
			remainingTime = (holyWord.startTime + holyWord.duration) - currentTime
		end

		return remainingTime
	end

	local function GetHolyWordSerenityCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshot.holyWordSerenity)
	end

	local function GetHolyWordSanctifyCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshot.holyWordSanctify)
	end

	local function GetHolyWordChastiseCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshot.holyWordChastise)
	end

	local function CalculateHolyWordCooldown(base, spellId)
		local mod = 1
		local divineConversationValue = 0
		local prayerFocusValue = 0

		if TRB.Data.snapshot.divineConversation.isActive then
			if TRB.Data.character.isPvp then
				divineConversationValue = TRB.Data.spells.divineConversation.reductionPvp
			else
				divineConversationValue = TRB.Data.spells.divineConversation.reduction
			end
		end

		if TRB.Data.snapshot.prayerFocus.isActive and (spellId == TRB.Data.spells.heal.id or spellId == TRB.Data.spells.prayerOfHealing.id) then
			prayerFocusValue = TRB.Data.spells.prayerFocus.holyWordReduction
		end

		if TRB.Data.snapshot.apotheosis.isActive then
			mod = mod * TRB.Data.spells.apotheosis.holyWordModifier
		end

		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lightOfTheNaaru) then
			mod = mod * (1 + (TRB.Data.spells.lightOfTheNaaru.holyWordModifier * TRB.Data.talents[TRB.Data.spells.lightOfTheNaaru.id].currentRank))
		end

		return mod * (base + prayerFocusValue) + divineConversationValue
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

	local function CalculateInsanityGain(insanity)
		local modifier = 1.0

		return insanity * modifier
	end

	local function RefreshLookupData_Holy()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local specSettings = TRB.Data.settings.priest.holy
		---@type TRB.Classes.Target
		local target = snapshot.targetData.targets[snapshot.targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedMana = snapshot.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		snapshot.manaRegen, _ = GetPowerRegen()

		local currentManaColor = specSettings.colors.text.current
		local castingManaColor = specSettings.colors.text.casting

		--$mana
		local manaPrecision = specSettings.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = snapshot.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		--$sohMana
		local _sohMana = snapshot.symbolOfHope.resourceFinal
		local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
		--$sohTicks
		local _sohTicks = snapshot.symbolOfHope.ticksRemaining or 0
		local sohTicks = string.format("%.0f", _sohTicks)
		--$sohTime
		local _sohTime = GetSymbolOfHopeRemainingTime()
		local sohTime = string.format("%.1f", _sohTime)

		--$innervateMana
		local _innervateMana = snapshot.innervate.mana
		local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
		--$innervateTime
		local _innervateTime = GetInnervateRemainingTime()
		local innervateTime = string.format("%.1f", _innervateTime)

		--$potionOfChilledClarityMana
		local _potionOfChilledClarityMana = snapshot.potionOfChilledClarity.mana
		local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
		--$potionOfChilledClarityTime
		local _potionOfChilledClarityTime = GetPotionOfChilledClarityRemainingTime()
		local potionOfChilledClarityTime = string.format("%.1f", _potionOfChilledClarityTime)

		--$mttMana
		local _mttMana = snapshot.manaTideTotem.mana
		local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
		--$mttTime
		local _mttTime = GetManaTideTotemRemainingTime()
		local mttTime = string.format("%.1f", _mttTime)

		--$mrMana
		local _mrMana = snapshot.moltenRadiance.mana
		local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
		--$mrTime
		local _mrTime = GetMoltenRadianceRemainingTime()
		local mrTime = string.format("%.1f", _mrTime)

		--$potionCooldownSeconds
		local _potionCooldown = 0
		if snapshot.potion.onCooldown then
			_potionCooldown = math.abs(snapshot.potion.startTime + snapshot.potion.duration - currentTime)
		end
		local potionCooldownSeconds = string.format("%.1f", _potionCooldown)
		local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
		local _potionCooldownSeconds = _potionCooldown % 60
		--$potionCooldown
		local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)

		--$channeledMana
		local _channeledMana = CalculateManaGain(snapshot.channeledManaPotion.mana, true)
		local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
		--$potionOfFrozenFocusTicks
		local _potionOfFrozenFocusTicks = snapshot.channeledManaPotion.ticksRemaining or 0
		local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
		--$potionOfFrozenFocusTime
		local _potionOfFrozenFocusTime = GetChanneledPotionRemainingTime()
		local potionOfFrozenFocusTime = string.format("%.1f", _potionOfFrozenFocusTime)
		
		--$sfMana
		local _sfMana = snapshot.shadowfiend.resourceFinal
		local sfMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
		--$sfGcds
		local _sfGcds = snapshot.shadowfiend.remaining.gcds
		local sfGcds = string.format("%.0f", _sfGcds)
		--$sfSwings
		local _sfSwings = snapshot.shadowfiend.remaining.swings
		local sfSwings = string.format("%.0f", _sfSwings)
		--$sfTime
		local _sfTime = snapshot.shadowfiend.remaining.time
		local sfTime = string.format("%.1f", _sfTime)

		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana + _mrMana
		local passiveMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
		--$manaTotal
		local _manaTotal = math.min(_passiveMana + snapshot.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
		--$manaPlusCasting
		local _manaPlusCasting = math.min(snapshot.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
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
		local _apotheosisTime = snapshot.apotheosis.remainingTime
		local apotheosisTime = string.format("%.1f", _apotheosisTime)

		--$solStacks
		local _solStacks = snapshot.surgeOfLight.stacks or 0
		local solStacks = string.format("%.0f", _solStacks)
		--$solTime
		local _solTime = snapshot.surgeOfLight.remainingTime or 0
		local solTime = string.format("%.1f", _solTime)

		--$lightweaverStacks
		local _lightweaverStacks = snapshot.lightweaver.stacks or 0
		local lightweaverStacks = string.format("%.0f", _lightweaverStacks)
		--$lightweaverTime
		local _lightweaverTime = snapshot.lightweaver.remainingTime or 0
		local lightweaverTime = string.format("%.1f", _lightweaverTime)
		
		--$rwTime
		local _rwTime = snapshot.resonantWords.remainingTime or 0
		local rwTime = string.format("%.1f", _rwTime)

		-----------
		--$swpCount and $swpTime
		local _shadowWordPainCount = snapshot.targetData.count[spells.shadowWordPain.id] or 0
		local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
		local _shadowWordPainTime = 0
		
		if target ~= nil then
			_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
		end

		local shadowWordPainTime

		if specSettings.colors.text.dots.enabled and snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.shadowWordPain.id].active then
				if _shadowWordPainTime > spells.shadowWordPain.pandemicTime then
					shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _shadowWordPainTime)
				else
					shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _shadowWordPainTime)
				end
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			shadowWordPainTime = string.format("%.1f", _shadowWordPainTime)
		end

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.channeledPotion = _channeledMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.potionOfChilledClarity = _potionOfChilledClarityMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
		Global_TwintopResourceBar.channeledPotion = {
			mana = _channeledMana,
			ticks = snapshot.channeledManaPotion.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = snapshot.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.shadowfiend = {
			mana = snapshot.shadowfiend.resourceFinal or 0,
			gcds = snapshot.shadowfiend.remaining.gcds or 0,
			swings = snapshot.shadowfiend.remaining.swings or 0,
			time = snapshot.shadowfiend.remaining.time or 0
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#apotheosis"] = spells.apotheosis.icon
		lookup["#coh"] = spells.circleOfHealing.icon
		lookup["#circleOfHealing"] = spells.circleOfHealing.icon
		lookup["#flashHeal"] = spells.flashHeal.icon
		lookup["#ha"] = spells.harmoniousApparatus.icon
		lookup["#harmoniousApparatus"] = spells.harmoniousApparatus.icon
		lookup["#heal"] = spells.heal.icon
		lookup["#hf"] = spells.holyFire.icon
		lookup["#holyFire"] = spells.holyFire.icon
		lookup["#hwChastise"] = spells.holyWordChastise.icon
		lookup["#chastise"] = spells.holyWordChastise.icon
		lookup["#holyWordChastise"] = spells.holyWordChastise.icon
		lookup["#hwSanctify"] = spells.holyWordSanctify.icon
		lookup["#sanctify"] = spells.holyWordSanctify.icon
		lookup["#holyWordSanctify"] = spells.holyWordSanctify.icon
		lookup["#hwSerenity"] = spells.holyWordSerenity.icon
		lookup["#serenity"] = spells.holyWordSerenity.icon
		lookup["#holyWordSerenity"] = spells.holyWordSerenity.icon
		lookup["#lightweaver"] = spells.lightweaver.icon
		lookup["#rw"] = spells.resonantWords.icon
		lookup["#resonantWords"] = spells.resonantWords.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#lotn"] = spells.lightOfTheNaaru.icon
		lookup["#lightOfTheNaaru"] = spells.lightOfTheNaaru.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#poh"] = spells.prayerOfHealing.icon
		lookup["#prayerOfHealing"] = spells.prayerOfHealing.icon
		lookup["#pom"] = spells.prayerOfMending.icon
		lookup["#prayerOfMending"] = spells.prayerOfMending.icon
		lookup["#renew"] = spells.renew.icon
		lookup["#smite"] = spells.smite.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#sol"] = spells.surgeOfLight.icon
		lookup["#surgeOfLight"] = spells.surgeOfLight.icon
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#swp"] = spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = spells.shadowWordPain.icon
		lookup["#shadowfiend"] = spells.shadowfiend.icon
		lookup["#sf"] = spells.shadowfiend.icon

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
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
		lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
		lookup["$mrMana"] = mrMana
		lookup["$mrTime"] = mrTime
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		lookup["$solStacks"] = solStacks
		lookup["$solTime"] = solTime
		lookup["$sfMana"] = sfMana
		lookup["$sfGcds"] = sfGcds
		lookup["$sfSwings"] = sfSwings
		lookup["$sfTime"] = sfTime
		lookup["$lightweaverStacks"] = lightweaverStacks
		lookup["$lightweaverTime"] = lightweaverTime
		lookup["$apotheosisTime"] = apotheosisTime
		lookup["$swpCount"] = shadowWordPainCount
		lookup["$swpTime"] = shadowWordPainTime
		lookup["$rwTime"] = rwTime
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
		lookupLogic["$hwChastiseTime"] = _hwChastiseTime
		lookupLogic["$chastiseTime"] = _hwChastiseTime
		lookupLogic["$holyWordChastiseTime"] = _hwChastiseTime
		lookupLogic["$hwSanctifyTime"] = _hwSanctifyTime
		lookupLogic["$sanctifyTime"] = _hwSanctifyTime
		lookupLogic["$holyWordSanctifyTime"] = _hwSanctifyTime
		lookupLogic["$hwSerenityTime"] = _hwSerenityTime
		lookupLogic["$serenityTime"] = _hwSerenityTime
		lookupLogic["$holyWordSerenityTime"] = _hwSerenityTime
		lookupLogic["$sohMana"] = _sohMana
		lookupLogic["$sohTime"] = _sohTime
		lookupLogic["$sohTicks"] = _sohTicks
		lookupLogic["$innervateMana"] = _innervateMana
		lookupLogic["$innervateTime"] = _innervateTime
		lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
		lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
		lookupLogic["$mrMana"] = _mrMana
		lookupLogic["$mrTime"] = _mrTime
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$solStacks"] = _solStacks
		lookupLogic["$solTime"] = _solTime
		lookupLogic["$sfMana"] = _sfMana
		lookupLogic["$sfGcds"] = _sfGcds
		lookupLogic["$sfSwings"] = _sfSwings
		lookupLogic["$sfTime"] = _sfTime
		lookupLogic["$lightweaverStacks"] = _lightweaverStacks
		lookupLogic["$lightweaverTime"] = _lightweaverTime
		lookupLogic["$apotheosisTime"] = _apotheosisTime
		lookupLogic["$swpCount"] = _shadowWordPainCount
		lookupLogic["$swpTime"] = _shadowWordPainTime
		lookupLogic["$rwTime"] = rwTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Shadow()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local specSettings = TRB.Data.settings.priest.shadow
		---@type TRB.Classes.TargetData
		local targetData = snapshot.targetData
		local target = targetData.targets[targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedInsanity = snapshot.resource / TRB.Data.resourceFactor
		--$vfTime
		local _voidformTime = snapshot.voidform.remainingTime

		--TODO: not use this hacky workaroud for timers
		if snapshot.darkAscension.remainingTime > 0 then
			_voidformTime = snapshot.darkAscension.remainingTime
		end

		local voidformTime = string.format("%.1f", _voidformTime)
		----------

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentInsanityColor = specSettings.colors.text.currentInsanity
		local castingInsanityColor = specSettings.colors.text.castingInsanity

		local insanityThreshold = TRB.Data.character.devouringPlagueThreshold

		if snapshot.mindDevourer.spellId ~= nil then
			insanityThreshold = 0
		end

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then
				currentInsanityColor = specSettings.colors.text.overcapInsanity
				castingInsanityColor = specSettings.colors.text.overcapInsanity
			elseif specSettings.colors.text.overThresholdEnabled and normalizedInsanity >= insanityThreshold then
				currentInsanityColor = specSettings.colors.text.overThreshold
				castingInsanityColor = specSettings.colors.text.overThreshold
			end
		end

		--$insanity
		local insanityPrecision = specSettings.insanityPrecision or 0
		local _currentInsanity = normalizedInsanity
		local currentInsanity = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_currentInsanity, insanityPrecision, "floor"))
		--$casting
		local _castingInsanity = snapshot.casting.resourceFinal
		local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_castingInsanity, insanityPrecision, "floor"))
		--$mbInsanity
		local _mbInsanity = snapshot.shadowfiend.resourceFinal + snapshot.devouredDespair.resourceFinal
		local mbInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_mbInsanity, insanityPrecision, "floor"))
		--$mbGcds
		local _mbGcds = snapshot.shadowfiend.remaining.gcds
		local mbGcds = string.format("%.0f", _mbGcds)
		--$mbSwings
		local _mbSwings = snapshot.shadowfiend.remaining.swings
		local mbSwings = string.format("%.0f", _mbSwings)
		--$mbTime
		local _mbTime = snapshot.shadowfiend.remaining.time
		local mbTime = string.format("%.1f", _mbTime)
		--$loiInsanity
		local _loiInsanity = snapshot.voidTendrils.resourceFinal
		local loiInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_loiInsanity, insanityPrecision, "floor"))
		--$loiTicks
		local _loiTicks = snapshot.voidTendrils.maxTicksRemaining
		local loiTicks = string.format("%.0f", _loiTicks)
		--$ecttvCount
		local _ecttvCount = snapshot.voidTendrils.numberActive
		local ecttvCount = string.format("%.0f", _ecttvCount)
		--$asCount
		local _asCount = targetData.count[spells.auspiciousSpirits.id] or 0
		local asCount = string.format("%.0f", _asCount)
		--$asInsanity
		local _asInsanity = CalculateInsanityGain(spells.auspiciousSpirits.insanity) * (targetData.custom.auspiciousSpiritsGenerate or 0)
		local asInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_asInsanity, insanityPrecision, "ceil"))
		--$passive
		local _passiveInsanity = _asInsanity + _mbInsanity + _loiInsanity
		local passiveInsanity = string.format("|c%s%s|r", specSettings.colors.text.passiveInsanity, TRB.Functions.Number:RoundTo(_passiveInsanity, insanityPrecision, "floor"))
		--$insanityTotal
		local _insanityTotal = math.min(_passiveInsanity + snapshot.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityTotal = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_insanityTotal, insanityPrecision, "floor"))
		--$insanityPlusCasting
		local _insanityPlusCasting = math.min(snapshot.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusCasting = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_insanityPlusCasting, insanityPrecision, "floor"))
		--$insanityPlusPassive
		local _insanityPlusPassive = math.min(_passiveInsanity + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusPassive = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_insanityPlusPassive, insanityPrecision, "floor"))


		----------
		--$swpCount and $swpTime
		local _shadowWordPainCount = targetData.count[spells.shadowWordPain.id] or 0
		local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
		local _shadowWordPainTime = 0
		
		if target ~= nil then
			_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
		end

		local shadowWordPainTime

		--$vtCount and $vtTime
		local _vampiricTouchCount = targetData.count[spells.vampiricTouch.id] or 0
		local vampiricTouchCount = string.format("%s", _vampiricTouchCount)
		local _vampiricTouchTime = 0
		
		if target ~= nil then
			_vampiricTouchTime = target.spells[spells.vampiricTouch.id].remainingTime or 0
		end

		local vampiricTouchTime

		--$dpTime
		local devouringPlagueTime
		if target ~= nil then
			devouringPlagueTime = string.format("%.1f", target.spells[spells.devouringPlague.id].remainingTime or 0)
		else
			devouringPlagueTime = string.format("%.1f", 0)
		end

		if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.shadowWordPain.id].active then
				if (not TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.misery) and target.spells[spells.shadowWordPain.id].remainingTime > spells.shadowWordPain.pandemicTime) or
					(TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.misery) and target.spells[spells.shadowWordPain.id].remainingTime > spells.shadowWordPain.miseryPandemicTime) then
					shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _shadowWordPainTime)
				else
					shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _shadowWordPainCount)
					shadowWordPainTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _shadowWordPainTime)
				end
			else
				shadowWordPainCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _shadowWordPainCount)
				shadowWordPainTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end

			if target ~= nil and target.spells[spells.vampiricTouch.id].active then
				if target.spells[spells.vampiricTouch.id].remainingTime > spells.vampiricTouch.pandemicTime then
					vampiricTouchCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _vampiricTouchCount)
					vampiricTouchTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _vampiricTouchTime)
				else
					vampiricTouchCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _vampiricTouchCount)
					vampiricTouchTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _vampiricTouchTime)
				end
			else
				vampiricTouchCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _vampiricTouchCount)
				vampiricTouchTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
			end
		else
			shadowWordPainTime = string.format("%.1f", _shadowWordPainTime)
			vampiricTouchTime = string.format("%.1f", _vampiricTouchTime)
		end

		--$dpCount
		local devouringPlagueCount = targetData.count[spells.devouringPlague.id] or 0

		--$mdTime
		local _mdTime = 0
		if snapshot.mindDevourer.endTime then
			_mdTime = math.abs(snapshot.mindDevourer.endTime - currentTime)
		end
		local mdTime = string.format("%.1f", _mdTime)
		
		--$mfiTime
		local _mfiTime = 0
		if snapshot.mindFlayInsanity.endTime then
			_mfiTime = math.abs(snapshot.mindFlayInsanity.endTime - currentTime)
		end
		local mfiTime = string.format("%.1f", _mfiTime)

		--$mfiStacks
		local _mfiStacks = snapshot.mindFlayInsanity.stacks or 0
		local mfiStacks = string.format("%.0f", _mfiStacks)
		
		--$deathspeakerTime
		local _deathspeakerTime = 0
		if snapshot.deathspeaker.endTime then
			_deathspeakerTime = math.abs(snapshot.deathspeaker.endTime - currentTime)
		end
		local deathspeakerTime = string.format("%.1f", _deathspeakerTime)

		--$tofTime
		local _tofTime = 0
		if snapshot.twistOfFate.endTime then
			_tofTime = math.abs(snapshot.twistOfFate.endTime - currentTime)
		end
		local tofTime = string.format("%.1f", _tofTime)
		
		--$mindBlastCharges
		local mindBlastCharges = snapshot.mindBlast.charges or 0
		
		--$mindBlastMaxCharges
		local mindBlastMaxCharges = snapshot.mindBlast.maxCharges or 0

		--$siTime
		local _siTime = 0
		if snapshot.shadowyInsight.endTime then
			_siTime = math.abs(snapshot.shadowyInsight.endTime - currentTime)
		end
		local siTime = string.format("%.1f", _siTime)
		
		--$mmTime
		local _mmTime = 0
		if snapshot.mindMelt.endTime then
			_mmTime = math.abs(snapshot.mindMelt.endTime - currentTime)
		end
		local mmTime = string.format("%.1f", _mmTime)
		--$mmStacks
		local mmStacks = snapshot.mindMelt.stacks or 0
		
		--$ysTime
		local _ysTime = 0
		if TRB.Data.snapshot.idolOfYoggSaron.endTime then
			_ysTime = math.abs(TRB.Data.snapshot.idolOfYoggSaron.endTime - currentTime)
		end
		local ysTime = string.format("%.1f", _ysTime)
		--$ysStacks
		local ysStacks = TRB.Data.snapshot.idolOfYoggSaron.stacks or 0
		--$ysRemainingStacks
		local ysRemainingStacks = (TRB.Data.spells.idolOfYoggSaron.requiredStacks - ysStacks) or TRB.Data.spells.idolOfYoggSaron.requiredStacks
		--$tfbTime
		local _tfbTime = 0
		if TRB.Data.snapshot.thingFromBeyond.endTime then
			_tfbTime = math.abs(TRB.Data.snapshot.thingFromBeyond.endTime - currentTime)
		end
		local tfbTime = string.format("%.1f", _tfbTime)

		--$cttvEquipped
		local cttvEquipped = TRB.Functions.Class:IsValidVariableForSpec("$cttvEquipped")

		----------------------------

		Global_TwintopResourceBar.voidform = {
		}
		Global_TwintopResourceBar.resource.passive = _passiveInsanity
		Global_TwintopResourceBar.resource.auspiciousSpirits = _asInsanity
		Global_TwintopResourceBar.resource.shadowfiend = _mbInsanity or 0
		Global_TwintopResourceBar.resource.mindbender = _mbInsanity or 0
		Global_TwintopResourceBar.resource.ecttv = snapshot.voidTendrils.resourceFinal or 0
		Global_TwintopResourceBar.auspiciousSpirits = {
			count = targetData.count[spells.auspiciousSpirits.id] or 0,
			insanity = _asInsanity
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0,
			vtCount = _vampiricTouchCount or 0,
			dpCount = devouringPlagueCount or 0
		}
		Global_TwintopResourceBar.shadowfiend = {
			insanity = _mbInsanity or 0,
			gcds = snapshot.shadowfiend.remaining.gcds or 0,
			swings = snapshot.shadowfiend.remaining.swings or 0,
			time = snapshot.shadowfiend.remaining.time or 0
		}
		Global_TwintopResourceBar.mindbender = {
			insanity = _mbInsanity,
			gcds = snapshot.shadowfiend.remaining.gcds or 0,
			swings = snapshot.shadowfiend.remaining.swings or 0,
			time = snapshot.shadowfiend.remaining.time or 0
		}
		Global_TwintopResourceBar.eternalCallToTheVoid = {
			insanity = snapshot.voidTendrils.resourceFinal or 0,
			ticks = snapshot.voidTendrils.maxTicksRemaining or 0,
			count = snapshot.voidTendrils.numberActive or 0
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#as"] = spells.auspiciousSpirits.icon
		lookup["#auspiciousSpirits"] = spells.auspiciousSpirits.icon
		lookup["#sa"] = spells.shadowyApparition.icon
		lookup["#shadowyApparition"] = spells.shadowyApparition.icon
		lookup["#mb"] = spells.mindBlast.icon
		lookup["#mindBlast"] = spells.mindBlast.icon
		lookup["#mf"] = spells.mindFlay.icon
		lookup["#mindFlay"] = spells.mindFlay.icon
		lookup["#mfi"] = spells.mindFlayInsanity.icon
		lookup["#mindFlayInsanity"] = spells.mindFlayInsanity.icon
		lookup["#mindgames"] = spells.mindgames.icon
		lookup["#mindbender"] = spells.mindbender.icon
		lookup["#shadowfiend"] = spells.shadowfiend.icon
		lookup["#sf"] = spells.shadowfiend.icon
		lookup["#vf"] = spells.voidform.icon
		lookup["#voidform"] = spells.voidform.icon
		lookup["#vb"] = spells.voidBolt.icon
		lookup["#voidBolt"] = spells.voidBolt.icon
		lookup["#vt"] = spells.vampiricTouch.icon
		lookup["#vampiricTouch"] = spells.vampiricTouch.icon
		lookup["#swp"] = spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = spells.shadowWordPain.icon
		lookup["#dp"] = spells.devouringPlague.icon
		lookup["#devouringPlague"] = spells.devouringPlague.icon
		lookup["#mDev"] = spells.mindDevourer.icon
		lookup["#mindDevourer"] = spells.mindDevourer.icon
		lookup["#tof"] = spells.twistOfFate.icon
		lookup["#twistOfFate"] = spells.twistOfFate.icon
		lookup["#si"] = spells.shadowyInsight.icon
		lookup["#shadowyInsight"] = spells.shadowyInsight.icon
		lookup["#mm"] = spells.mindMelt.icon
		lookup["#mindMelt"] = spells.mindMelt.icon
		lookup["#ys"] = TRB.Data.spells.idolOfYoggSaron.icon
		lookup["#idolOfYoggSaron"] = TRB.Data.spells.idolOfYoggSaron.icon
		lookup["#tfb"] = TRB.Data.spells.thingFromBeyond.icon
		lookup["#thingFromBeyond"] = TRB.Data.spells.thingFromBeyond.icon
		lookup["#md"] = spells.massDispel.icon
		lookup["#massDispel"] = spells.massDispel.icon
		lookup["#cthun"] = spells.idolOfCthun.icon
		lookup["#idolOfCthun"] = spells.idolOfCthun.icon
		lookup["#loi"] = spells.idolOfCthun.icon
		lookup["#swd"] = spells.deathspeaker.icon
		lookup["#shadowWordDeath"] = spells.deathspeaker.icon
		lookup["#deathspeaker"] = spells.deathspeaker.icon
		lookup["$swpCount"] = shadowWordPainCount
		lookup["$swpTime"] = shadowWordPainTime
		lookup["$vtCount"] = vampiricTouchCount
		lookup["$vtTime"] = vampiricTouchTime
		lookup["$dpCount"] = devouringPlagueCount
		lookup["$dpTime"] = devouringPlagueTime
		lookup["$mdTime"] = mdTime
		lookup["$mfiTime"] = mfiTime
		lookup["$mfiStacks"] = mfiStacks
		lookup["$deathspeakerTime"] = deathspeakerTime
		lookup["$tofTime"] = tofTime
		lookup["$vfTime"] = voidformTime
		lookup["$mmTime"] = mmTime
		lookup["$mmStacks"] = mmStacks
		lookup["$ysTime"] = ysTime
		lookup["$ysStacks"] = ysStacks
		lookup["$ysRemainingStacks"] = ysRemainingStacks
		lookup["$tfbTime"] = tfbTime
		lookup["$siTime"] = siTime
		lookup["$mindBlastCharges"] = mindBlastCharges
		lookup["$mindBlastMaxCharges"] = mindBlastMaxCharges
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
		lookup["$loiInsanity"] = loiInsanity
		lookup["$loiTicks"] = loiTicks
		lookup["$cttvEquipped"] = ""
		lookup["$ecttvCount"] = ecttvCount
		lookup["$asCount"] = asCount
		lookup["$asInsanity"] = asInsanity
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$swpCount"] = _shadowWordPainCount
		lookupLogic["$swpTime"] = _shadowWordPainTime
		lookupLogic["$vtCount"] = _vampiricTouchCount
		lookupLogic["$vtTime"] = _vampiricTouchTime
		lookupLogic["$dpCount"] = devouringPlagueCount
		lookupLogic["$dpTime"] = devouringPlagueTime
		lookupLogic["$mdTime"] = _mdTime
		lookupLogic["$mfiTime"] = _mfiTime
		lookupLogic["$mfiStacks"] = _mfiStacks
		lookupLogic["$deathspeakerTime"] = _deathspeakerTime
		lookupLogic["$tofTime"] = _tofTime
		lookupLogic["$vfTime"] = _voidformTime
		lookupLogic["$mmTime"] = _mmTime
		lookupLogic["$mmStacks"] = mmStacks
		lookupLogic["$ysTime"] = _ysTime
		lookupLogic["$ysStacks"] = ysStacks
		lookupLogic["$ysRemainingStacks"] = ysRemainingStacks
		lookupLogic["$tfbTime"] = _tfbTime
		lookupLogic["$siTime"] = _siTime
		lookupLogic["$mindBlastCharges"] = mindBlastCharges
		lookupLogic["$mindBlastMaxCharges"] = mindBlastMaxCharges
		lookupLogic["$insanityPlusCasting"] = _insanityPlusCasting
		lookupLogic["$insanityPlusPassive"] = _insanityPlusPassive
		lookupLogic["$insanityTotal"] = _insanityTotal
		lookupLogic["$insanityMax"] = TRB.Data.character.maxResource
		lookupLogic["$insanity"] = _currentInsanity
		lookupLogic["$resourcePlusCasting"] = _insanityPlusCasting
		lookupLogic["$resourcePlusPassive"] = _insanityPlusPassive
		lookupLogic["$resourceTotal"] = _insanityTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = _currentInsanity
		lookupLogic["$casting"] = _castingInsanity
		lookupLogic["$passive"] = _passiveInsanity
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$insanityOvercap"] = overcap
		lookupLogic["$mbInsanity"] = _mbInsanity
		lookupLogic["$mbGcds"] = _mbGcds
		lookupLogic["$mbSwings"] = _mbSwings
		lookupLogic["$mbTime"] = _mbTime
		lookupLogic["$loiInsanity"] = _loiInsanity
		lookupLogic["$loiTicks"] = _loiTicks
		lookupLogic["$cttvEquipped"] = cttvEquipped
		lookupLogic["$ecttvCount"] = _ecttvCount
		lookupLogic["$asCount"] = _asCount
		lookupLogic["$asInsanity"] = _asInsanity
		TRB.Data.lookupLogic = lookupLogic
	end

	local function UpdateCastingResourceFinal_Holy()
		-- Do nothing for now
		TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceRaw * TRB.Data.snapshot.innervate.modifier * TRB.Data.snapshot.potionOfChilledClarity.modifier
	end

	local function UpdateCastingResourceFinal_Shadow()
		TRB.Data.snapshot.casting.resourceFinal = CalculateInsanityGain(TRB.Data.snapshot.casting.resourceRaw)
	end

	local function CastingSpell()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local currentTime = GetTime()
		local affectingCombat = UnitAffectingCombat("player")
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 2 then
				if currentSpellName == nil then
					if currentChannelId == spells.symbolOfHope.id then
						snapshot.casting.spellId = spells.symbolOfHope.id
						snapshot.casting.startTime = currentChannelStartTime / 1000
						snapshot.casting.endTime = currentChannelEndTime / 1000
						snapshot.casting.resourceRaw = 0
						snapshot.casting.icon = spells.symbolOfHope.icon
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

						snapshot.casting.startTime = currentSpellStartTime / 1000
						snapshot.casting.endTime = currentSpellEndTime / 1000
						snapshot.casting.resourceRaw = manaCost
						snapshot.casting.spellId = spellId
						snapshot.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Holy()
						if currentSpellId == spells.heal.id then
							snapshot.casting.spellKey = "heal"
						elseif currentSpellId == spells.flashHeal.id then
							snapshot.casting.spellKey = "flashHeal"
						elseif currentSpellId == spells.prayerOfHealing.id then
							snapshot.casting.spellKey = "prayerOfHealing"
						elseif currentSpellId == spells.renew.id then --This shouldn't happen
							snapshot.casting.spellKey = "renew"
						elseif currentSpellId == spells.smite.id then
							snapshot.casting.spellKey = "smite"
						elseif TRB.Functions.Talent:IsTalentActive(spells.harmoniousApparatus) then
							if currentSpellId == spells.circleOfHealing.id then --Harmonious Apparatus / This shouldn't happen
								snapshot.casting.spellKey = "circleOfHealing"
							elseif currentSpellId == spells.prayerOfMending.id then --Harmonious Apparatus / This shouldn't happen
								snapshot.casting.spellKey = "prayerOfMending"
							elseif currentSpellId == spells.holyFire.id then --Harmonious Apparatus
								snapshot.casting.spellKey = "holyFire"
							end
						end
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 3 then
				if currentSpellName == nil then
					if currentChannelId == spells.mindFlay.id then
						snapshot.casting.spellId = spells.mindFlay.id
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.mindFlay.insanity
						snapshot.casting.icon = spells.mindFlay.icon
					elseif currentChannelId == spells.mindFlayInsanity.id then
						snapshot.casting.spellId = spells.mindFlayInsanity.id
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.mindFlayInsanity.insanity
						snapshot.casting.icon = spells.mindFlayInsanity.icon
					elseif currentChannelId == spells.voidTorrent.id then
						snapshot.casting.spellId = spells.voidTorrent.id
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.voidTorrent.insanity
						snapshot.casting.icon = spells.voidTorrent.icon
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
					UpdateCastingResourceFinal_Shadow()
				else
					if currentSpellId == spells.mindBlast.id then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.mindBlast.insanity
						snapshot.casting.spellId = spells.mindBlast.id
						snapshot.casting.icon = spells.mindBlast.icon
					elseif currentSpellId == spells.mindSpike.id then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.mindSpike.insanity
						snapshot.casting.spellId = spells.mindSpike.id
						snapshot.casting.icon = spells.mindSpike.icon
					elseif currentSpellId == spells.mindSpikeInsanity.id then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.mindSpikeInsanity.insanity
						snapshot.casting.spellId = spells.mindSpikeInsanity.id
						snapshot.casting.icon = spells.mindSpikeInsanity.icon
					elseif currentSpellId == spells.darkAscension.id then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.darkAscension.insanity
						snapshot.casting.spellId = spells.darkAscension.id
						snapshot.casting.icon = spells.darkAscension.icon
					elseif currentSpellId == spells.vampiricTouch.id then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.vampiricTouch.insanity
						snapshot.casting.spellId = spells.vampiricTouch.id
						snapshot.casting.icon = spells.vampiricTouch.icon
					elseif currentSpellId == spells.mindgames.id then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.mindgames.insanity
						snapshot.casting.spellId = spells.mindgames.id
						snapshot.casting.icon = spells.mindgames.icon
					elseif currentSpellId == spells.halo.id then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.halo.insanity
						snapshot.casting.spellId = spells.halo.id
						snapshot.casting.icon = spells.halo.icon
					elseif currentSpellId == spells.massDispel.id and TRB.Functions.Talent:IsTalentActive(spells.hallucinations) and affectingCombat then
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.hallucinations.insanity
						snapshot.casting.spellId = spells.massDispel.id
						snapshot.casting.icon = spells.massDispel.icon
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
					UpdateCastingResourceFinal_Shadow()
				end
				
				return true
			end
		end
	end

	local function GetMaximumShadowfiendResults()
		local specId = GetSpecialization()
		if specId ~= 2 and specId ~= 3 then
			return false, 0, 0, 0, 0, 0
		end

		local swingTime = TRB.Data.snapshot.shadowfiend.swingTime

		local currentTime = GetTime()
		local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
		local timeRemaining = startTime+duration-currentTime

		if not haveTotem then
			if specId == 2 then
				timeRemaining = TRB.Data.spells.shadowfiend.duration
				swingTime = currentTime
			end
		end

		local swingSpeed = 1.5 / (1 + (TRB.Data.snapshot.haste / 100))
		local swingsRemaining = 0
		local gcdsRemaining = 0

		if swingSpeed > 1.5 then
			swingSpeed = 1.5
		end

		local timeToNextSwing = swingSpeed - (currentTime - swingTime)

		if timeToNextSwing < 0 then
			timeToNextSwing = 0
		elseif timeToNextSwing > 1.5 then
			timeToNextSwing = 1.5
		end

		swingsRemaining = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)

		local gcd = swingSpeed
		if gcd < 0.75 then
			gcd = 0.75
		end

		if timeRemaining > (gcd * swingsRemaining) then
			gcdsRemaining = math.ceil(((gcd * swingsRemaining) - timeToNextSwing) / swingSpeed)
		else
			gcdsRemaining = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
		end

		return haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed
	end

	local function UpdateSpecificShadowfiendValues(shadowfiend)
		if shadowfiend.totemId == nil then
			return
		end
		
		local specId = GetSpecialization()
		local currentTime = GetTime()
		local settings
		local _
		
		if specId == 2 and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.shadowfiend) then
			settings = TRB.Data.settings.priest.holy.shadowfiend
		elseif specId == 3 then
			settings = TRB.Data.settings.priest.shadow.mindbender
		else
			return
		end

		local haveTotem, name, startTime, duration, icon = GetTotemInfo(shadowfiend.totemId)
		local timeRemaining = startTime+duration-currentTime

		if settings.enabled and haveTotem and timeRemaining > 0 then
			shadowfiend.isActive = true
			if settings.enabled then
				local _, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
				shadowfiend.remaining.time = timeRemaining
				shadowfiend.remaining.swings = swingsRemaining
				shadowfiend.remaining.gcds = gcdsRemaining

				shadowfiend.swingTime = currentTime

				local countValue = 0

				if settings.mode == "swing" then
					if shadowfiend.remaining.swings > settings.swingsMax then
						countValue = settings.swingsMax
					else
						countValue = shadowfiend.remaining.swings
					end
				elseif settings.mode == "time" then
					if shadowfiend.remaining.time > settings.timeMax then
						countValue = math.ceil((settings.timeMax - timeToNextSwing) / swingSpeed)
					else
						countValue = math.ceil((shadowfiend.remaining.time - timeToNextSwing) / swingSpeed)
					end
				else --assume GCD
					if shadowfiend.remaining.gcds > settings.gcdsMax then
						countValue = settings.gcdsMax
					else
						countValue = shadowfiend.remaining.gcds
					end
				end

				if specId == 2 then
					shadowfiend.resourceRaw = countValue * TRB.Data.spells.shadowfiend.manaPercent * TRB.Data.character.maxResource
					shadowfiend.resourceFinal = CalculateManaGain(shadowfiend.resourceRaw, false)
				elseif specId == 3 then
					if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.mindbender) then
						shadowfiend.resourceRaw = countValue * TRB.Data.spells.mindbender.insanity
					else
						shadowfiend.resourceRaw = countValue * TRB.Data.spells.shadowfiend.insanity
					end
					shadowfiend.resourceFinal = CalculateInsanityGain(shadowfiend.resourceRaw)
				end
			end
		else
			shadowfiend.isActive = false
			shadowfiend.swingTime = 0
			shadowfiend.remaining = {}
			shadowfiend.remaining.swings = 0
			shadowfiend.remaining.gcds = 0
			shadowfiend.remaining.time = 0
			shadowfiend.resourceRaw = 0
			shadowfiend.resourceFinal = 0
			if specId == 3 then
				shadowfiend.totemId = nil
				shadowfiend.guid = nil
			end
		end

		if shadowfiend.startTime ~= nil and shadowfiend.startTime > 0 and shadowfiend.duration > 0 and currentTime > (shadowfiend.startTime + shadowfiend.duration) then
			shadowfiend.startTime = nil
			shadowfiend.duration = 0
			shadowfiend.remainingTime = 0
		elseif shadowfiend.startTime ~= nil then
			shadowfiend.remainingTime = GetShadowfiendCooldownRemainingTime(shadowfiend)
		end
	end

	local function UpdateShadowfiendValues()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		local _

		UpdateSpecificShadowfiendValues(TRB.Data.snapshot.shadowfiend)
		
		---@diagnostic disable-next-line: redundant-parameter
		if specId == 2 and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.shadowfiend) then
			TRB.Data.snapshot.shadowfiend.onCooldown = not (GetSpellCooldown(TRB.Data.spells.shadowfiend.id) == 0)
		elseif specId == 3 then
			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.mindbender) then
				TRB.Data.snapshot.shadowfiend.onCooldown = not (GetSpellCooldown(TRB.Data.spells.mindbender.id) == 0)
			else
				TRB.Data.snapshot.shadowfiend.onCooldown = not (GetSpellCooldown(TRB.Data.spells.shadowfiend.id) == 0)
			end
			
			if TRB.Data.snapshot.devouredDespair.isActive and TRB.Data.snapshot.devouredDespair.endTime ~= nil and TRB.Data.snapshot.devouredDespair.endTime > currentTime then				
				TRB.Functions.Aura:SnapshotGenericAura(TRB.Data.spells.devouredDespair.id, nil, TRB.Data.snapshot.devouredDespair)
				TRB.Data.snapshot.devouredDespair.ticks = TRB.Functions.Number:RoundTo(TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.devouredDespair), 0, "ceil", true)
				TRB.Data.snapshot.devouredDespair.resourceRaw = TRB.Data.snapshot.devouredDespair.ticks * TRB.Data.spells.devouredDespair.insanity
				TRB.Data.snapshot.devouredDespair.resourceFinal = CalculateInsanityGain(TRB.Data.snapshot.devouredDespair.resourceRaw)
			else
				TRB.Data.snapshot.devouredDespair.resourceRaw = 0
				TRB.Data.snapshot.devouredDespair.resourceFinal = 0
				TRB.Data.snapshot.devouredDespair.isActive = false
				TRB.Data.snapshot.devouredDespair.endTime = nil
				TRB.Data.snapshot.devouredDespair.spellId = nil
				TRB.Data.snapshot.devouredDespair.duration = 0
			end
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
		if TRB.Functions.Table:Length(TRB.Data.snapshot.voidTendrils.activeList) > 0 then
			for vtGuid,v in pairs(TRB.Data.snapshot.voidTendrils.activeList) do
				if TRB.Data.snapshot.voidTendrils.activeList[vtGuid] ~= nil and TRB.Data.snapshot.voidTendrils.activeList[vtGuid].startTime ~= nil then
					local endTime = TRB.Data.snapshot.voidTendrils.activeList[vtGuid].startTime + TRB.Data.spells.lashOfInsanity_Tendril.duration
					local timeRemaining = endTime - currentTime

					if timeRemaining < 0 then
						RemoveVoidTendril(vtGuid)
					else
						if TRB.Data.snapshot.voidTendrils.activeList[vtGuid].type == "Lasher" then
							if TRB.Data.snapshot.voidTendrils.activeList[vtGuid].tickTime ~= nil and currentTime > (TRB.Data.snapshot.voidTendrils.activeList[vtGuid].tickTime + 5) then
								TRB.Data.snapshot.voidTendrils.activeList[vtGuid].targetsHit = 0
							end

							local nextTick = TRB.Data.snapshot.voidTendrils.activeList[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Lasher.tickDuration

							if nextTick < currentTime then
								nextTick = currentTime --There should be a tick. ANY second now. Maybe.
								totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + 1
							end
							-- NOTE: Might need to be math.floor()
							local ticksRemaining = math.ceil((endTime - nextTick) / TRB.Data.spells.lashOfInsanity_Lasher.tickDuration)

							totalInsanity_Lasher = totalInsanity_Lasher + (ticksRemaining * TRB.Data.spells.lashOfInsanity_Lasher.insanity)
							totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + ticksRemaining
						else
							local nextTick = TRB.Data.snapshot.voidTendrils.activeList[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Tendril.tickDuration

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

		TRB.Data.snapshot.voidTendrils.maxTicksRemaining = totalTicksRemaining_Tendril + totalTicksRemaining_Lasher
		TRB.Data.snapshot.voidTendrils.numberActive = totalActive
		TRB.Data.snapshot.voidTendrils.resourceRaw = totalInsanity_Tendril + totalInsanity_Lasher
		-- Fortress of the Mind does not apply but other Insanity boosting effects do.
		TRB.Data.snapshot.voidTendrils.resourceFinal = CalculateInsanityGain(TRB.Data.snapshot.voidTendrils.resourceRaw)
	end

	local function UpdateChanneledManaPotion(forceCleanup)
		if TRB.Data.snapshot.channeledManaPotion.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or TRB.Data.snapshot.channeledManaPotion.endTime == nil or currentTime > TRB.Data.snapshot.channeledManaPotion.endTime then
				TRB.Data.snapshot.channeledManaPotion.ticksRemaining = 0
				TRB.Data.snapshot.channeledManaPotion.endTime = nil
				TRB.Data.snapshot.channeledManaPotion.mana = 0
				TRB.Data.snapshot.channeledManaPotion.isActive = false
				TRB.Data.snapshot.channeledManaPotion.spellKey = nil
			else
				TRB.Data.snapshot.channeledManaPotion.ticksRemaining = math.ceil((TRB.Data.snapshot.channeledManaPotion.endTime - currentTime) / (TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].duration / TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].ticks))
				local nextTickRemaining = TRB.Data.snapshot.channeledManaPotion.endTime - currentTime - math.floor((TRB.Data.snapshot.channeledManaPotion.endTime - currentTime) / (TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].duration / TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].ticks))
				TRB.Data.snapshot.channeledManaPotion.mana = TRB.Data.snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].mana, true) + ((TRB.Data.snapshot.channeledManaPotion.ticksRemaining - 1 + nextTickRemaining) * TRB.Data.snapshot.manaRegen)
			end
		end
	end

	local function UpdateSymbolOfHope(forceCleanup)
		if TRB.Data.snapshot.symbolOfHope.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or
				TRB.Data.snapshot.symbolOfHope.endTime == nil or
				currentTime > TRB.Data.snapshot.symbolOfHope.endTime or
				currentTime > TRB.Data.snapshot.symbolOfHope.firstTickTime + TRB.Data.spells.symbolOfHope.duration or
				currentTime > TRB.Data.snapshot.symbolOfHope.firstTickTime + (TRB.Data.spells.symbolOfHope.ticks * TRB.Data.snapshot.symbolOfHope.tickRate)
				then
				TRB.Data.snapshot.symbolOfHope.ticksRemaining = 0
				TRB.Data.snapshot.symbolOfHope.tickRate = 0
				TRB.Data.snapshot.symbolOfHope.previousTickTime = nil
				TRB.Data.snapshot.symbolOfHope.firstTickTime = nil
				TRB.Data.snapshot.symbolOfHope.endTime = nil
				TRB.Data.snapshot.symbolOfHope.resourceRaw = 0
				TRB.Data.snapshot.symbolOfHope.resourceFinal = 0
				TRB.Data.snapshot.symbolOfHope.isActive = false
				TRB.Data.snapshot.symbolOfHope.tickRateFound = false
			else
				TRB.Data.snapshot.symbolOfHope.ticksRemaining = math.ceil((TRB.Data.snapshot.symbolOfHope.endTime - currentTime) / TRB.Data.snapshot.symbolOfHope.tickRate)
				local nextTickRemaining = TRB.Data.snapshot.symbolOfHope.endTime - currentTime - math.floor((TRB.Data.snapshot.symbolOfHope.endTime - currentTime) / TRB.Data.snapshot.symbolOfHope.tickRate)
				TRB.Data.snapshot.symbolOfHope.resourceRaw = 0

				for x = 1, TRB.Data.snapshot.symbolOfHope.ticksRemaining do
					local casterRegen = 0
					if TRB.Data.snapshot.casting.spellId == TRB.Data.spells.symbolOfHope.id then
						if x == 1 then
							casterRegen = nextTickRemaining * TRB.Data.snapshot.manaRegen
						else
							casterRegen = TRB.Data.snapshot.manaRegen
						end
					end

					local estimatedMana = TRB.Data.character.maxResource + TRB.Data.snapshot.symbolOfHope.resourceRaw + casterRegen - (TRB.Data.snapshot.resource / TRB.Data.resourceFactor)
					local nextTick = TRB.Data.spells.symbolOfHope.manaPercent * math.max(0, math.min(TRB.Data.character.maxResource, estimatedMana))
					TRB.Data.snapshot.symbolOfHope.resourceRaw = TRB.Data.snapshot.symbolOfHope.resourceRaw + nextTick + casterRegen
				end

				--Revisit if we get mana modifiers added
				TRB.Data.snapshot.symbolOfHope.resourceFinal = CalculateManaGain(TRB.Data.snapshot.symbolOfHope.resourceRaw, false)
			end
		end
	end

	local function UpdateInnervate()
		local currentTime = GetTime()

		if TRB.Data.snapshot.innervate.endTime ~= nil and currentTime > TRB.Data.snapshot.innervate.endTime then
			TRB.Data.snapshot.innervate.endTime = nil
			TRB.Data.snapshot.innervate.duration = 0
			TRB.Data.snapshot.innervate.remainingTime = 0
			TRB.Data.snapshot.innervate.mana = 0
			TRB.Data.snapshot.audio.innervateCue = false
		else
			TRB.Data.snapshot.innervate.remainingTime = GetInnervateRemainingTime()
			TRB.Data.snapshot.innervate.mana = TRB.Data.snapshot.innervate.remainingTime * TRB.Data.snapshot.manaRegen
		end
	end

	local function UpdatePotionOfChilledClarity()
		local currentTime = GetTime()

		if TRB.Data.snapshot.potionOfChilledClarity.endTime ~= nil and currentTime > TRB.Data.snapshot.potionOfChilledClarity.endTime then
			TRB.Data.snapshot.potionOfChilledClarity.endTime = nil
			TRB.Data.snapshot.potionOfChilledClarity.duration = 0
			TRB.Data.snapshot.potionOfChilledClarity.remainingTime = 0
			TRB.Data.snapshot.potionOfChilledClarity.mana = 0
			TRB.Data.snapshot.audio.potionOfChilledClarityCue = false
		else
			TRB.Data.snapshot.potionOfChilledClarity.remainingTime = GetPotionOfChilledClarityRemainingTime()
			TRB.Data.snapshot.potionOfChilledClarity.mana = TRB.Data.snapshot.potionOfChilledClarity.remainingTime * TRB.Data.snapshot.manaRegen
		end
	end

	local function UpdateManaTideTotem(forceCleanup)
		local currentTime = GetTime()

		if forceCleanup or (TRB.Data.snapshot.manaTideTotem.endTime ~= nil and currentTime > TRB.Data.snapshot.manaTideTotem.endTime) then
			TRB.Data.snapshot.manaTideTotem.endTime = nil
			TRB.Data.snapshot.manaTideTotem.duration = 0
			TRB.Data.snapshot.manaTideTotem.remainingTime = 0
			TRB.Data.snapshot.manaTideTotem.mana = 0
			TRB.Data.snapshot.audio.manaTideTotemCue = false
		else
			TRB.Data.snapshot.manaTideTotem.remainingTime = GetManaTideTotemRemainingTime()
			TRB.Data.snapshot.manaTideTotem.mana = TRB.Data.snapshot.manaTideTotem.remainingTime * (TRB.Data.snapshot.manaRegen / 2) --Only half of this is considered bonus
		end
	end

	local function UpdateMoltenRadiance(forceCleanup)
		local currentTime = GetTime()

		if forceCleanup or (TRB.Data.snapshot.moltenRadiance.endTime ~= nil and currentTime > TRB.Data.snapshot.moltenRadiance.endTime) then
			TRB.Data.snapshot.moltenRadiance.endTime = nil
			TRB.Data.snapshot.moltenRadiance.duration = 0
			TRB.Data.snapshot.moltenRadiance.remainingTime = 0
			TRB.Data.snapshot.moltenRadiance.mana = 0
			TRB.Data.snapshot.moltenRadiance.manaPerTick = 0
		elseif TRB.Data.snapshot.moltenRadiance.endTime ~= nil then
			TRB.Data.snapshot.moltenRadiance.remainingTime = GetMoltenRadianceRemainingTime()
			TRB.Data.snapshot.moltenRadiance.mana = TRB.Data.snapshot.moltenRadiance.manaPerTick * TRB.Functions.Number:RoundTo(TRB.Data.snapshot.moltenRadiance.remainingTime, 0, "ceil", true)
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Holy()
		UpdateSnapshot()
		UpdateSymbolOfHope()
		UpdateChanneledManaPotion()
		UpdateInnervate()
		UpdatePotionOfChilledClarity()
		UpdateManaTideTotem()
		UpdateMoltenRadiance()
		UpdateShadowfiendValues()
		
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		---@type TRB.Classes.Target
		local target = snapshot.targetData.targets[snapshot.targetData.currentTargetGuid]

		local currentTime = GetTime()
		local _

		if snapshot.apotheosis.startTime ~= nil and currentTime > (snapshot.apotheosis.startTime + snapshot.apotheosis.duration) then
			snapshot.apotheosis.startTime = nil
			snapshot.apotheosis.duration = 0
			snapshot.apotheosis.remainingTime = 0
		else
			snapshot.apotheosis.remainingTime = GetApotheosisRemainingTime()
		end

		if snapshot.holyWordSerenity.startTime ~= nil then
---@diagnostic disable-next-line: redundant-parameter
			snapshot.holyWordSerenity.startTime, snapshot.holyWordSerenity.duration, _, _ = GetSpellCooldown(spells.holyWordSerenity.id)
			
			if snapshot.holyWordSerenity.startTime == 0 then
				snapshot.holyWordSerenity.startTime = nil
			end
		end

		if snapshot.holyWordSanctify.startTime ~= nil then
---@diagnostic disable-next-line: redundant-parameter
			snapshot.holyWordSanctify.startTime, snapshot.holyWordSanctify.duration, _, _ = GetSpellCooldown(spells.holyWordSanctify.id)
			
			if snapshot.holyWordSanctify.startTime == 0 then
				snapshot.holyWordSanctify.startTime = nil
			end
		end

		if snapshot.holyWordChastise.startTime ~= nil then
---@diagnostic disable-next-line: redundant-parameter
			snapshot.holyWordChastise.startTime, snapshot.holyWordChastise.duration, _, _ = GetSpellCooldown(spells.holyWordChastise.id)

			if snapshot.holyWordChastise.startTime == 0 then
				snapshot.holyWordChastise.startTime = nil
			end
		end

		TRB.Functions.Aura:SnapshotGenericAura(spells.resonantWords.id, nil, snapshot.resonantWords)
		TRB.Functions.Aura:SnapshotGenericAura(spells.lightweaver.id, nil, snapshot.lightweaver)
		TRB.Functions.Aura:SnapshotGenericAura(spells.surgeOfLight.id, nil, snapshot.surgeOfLight)

		-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
		snapshot.potion.startTime, snapshot.potion.duration, _ = GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
		if snapshot.potion.startTime > 0 and snapshot.potion.duration > 0 then
			snapshot.potion.onCooldown = true
		else
			snapshot.potion.onCooldown = false
		end

		snapshot.conjuredChillglobe.startTime, snapshot.conjuredChillglobe.duration, _ = GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
		if snapshot.conjuredChillglobe.startTime > 0 and snapshot.conjuredChillglobe.duration > 0 then
			snapshot.conjuredChillglobe.onCooldown = true
		else
			snapshot.conjuredChillglobe.onCooldown = false
		end
	end

	local function UpdateSnapshot_Shadow()
		UpdateSnapshot()
		UpdateShadowfiendValues()
		UpdateExternalCallToTheVoidValues()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local currentTime = GetTime()
		local _

		
		if snapshot.voidform.startTime ~= nil and currentTime > (snapshot.voidform.startTime + snapshot.voidform.duration) then
			snapshot.voidform.startTime = nil
			snapshot.voidform.duration = 0
			snapshot.voidform.remainingTime = 0
		else
			TRB.Functions.Aura:SnapshotGenericAura(spells.voidform.id, nil, snapshot.voidform)
		end

		if snapshot.darkAscension.startTime ~= nil and currentTime > (snapshot.darkAscension.startTime + snapshot.darkAscension.duration) then
			snapshot.darkAscension.startTime = nil
			snapshot.darkAscension.duration = 0
			snapshot.darkAscension.remainingTime = 0
		else
			snapshot.darkAscension.remainingTime = GetDarkAscensionRemainingTime()
		end

		if snapshot.mindFlayInsanity.endTime ~= nil and currentTime > (snapshot.mindFlayInsanity.endTime) then
			snapshot.mindFlayInsanity.endTime = nil
			snapshot.mindFlayInsanity.duration = 0
			snapshot.mindFlayInsanity.stacks = 0
			snapshot.mindFlayInsanity.spellId = nil
		elseif snapshot.mindFlayInsanity.spellId ~= nil then			
			TRB.Functions.Aura:SnapshotGenericAura(snapshot.mindFlayInsanity.spellId, nil, snapshot.mindFlayInsanity)
		end

		if snapshot.deathspeaker.endTime ~= nil and currentTime > (snapshot.deathspeaker.endTime) then
			snapshot.deathspeaker.endTime = nil
			snapshot.deathspeaker.duration = 0
			snapshot.deathspeaker.spellId = nil
		end

		if snapshot.mindDevourer.endTime ~= nil and currentTime > (snapshot.mindDevourer.endTime) then
			snapshot.mindDevourer.endTime = nil
			snapshot.mindDevourer.duration = 0
			snapshot.mindDevourer.spellId = nil
		end

		snapshot.mindBlast.charges, snapshot.mindBlast.maxCharges, snapshot.mindBlast.startTime, snapshot.mindBlast.duration, _ = GetSpellCharges(spells.mindBlast.id)
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.priest
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot

		if specId == 2 then
			local specSettings = classSettings.holy
			UpdateSnapshot_Holy()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = snapshot.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					if snapshot.lightweaver.remainingTime ~= nil and snapshot.lightweaver.remainingTime > 0 then
						if specSettings.colors.bar.lightweaverBorderChange then
							barBorderColor = specSettings.colors.bar.lightweaver
						end

						if specSettings.audio.lightweaver.enabled and snapshot.audio.lightweaverCue == false then
							snapshot.audio.lightweaverCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.lightweaver.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshot.audio.lightweaverCue = false
					end

					if snapshot.resonantWords.remainingTime ~= nil and snapshot.resonantWords.remainingTime > 0 then
						if specSettings.colors.bar.resonantWordsBorderChange then
							barBorderColor = specSettings.colors.bar.resonantWords
						end

						if specSettings.audio.resonantWords.enabled and snapshot.audio.resonantWordsCue == false then
							snapshot.audio.resonantWordsCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.resonantWords.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshot.audio.resonantWordsCue = false
					end

					if snapshot.surgeOfLight.stacks == 1 then
						if specSettings.colors.bar.surgeOfLightBorderChange1 then
							barBorderColor = specSettings.colors.bar.surgeOfLight1
						end

						if specSettings.audio.surgeOfLight.enabled and not snapshot.audio.surgeOfLightCue then
							snapshot.audio.surgeOfLightCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.surgeOfLight.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshot.surgeOfLight.stacks == 2 then
						if specSettings.colors.bar.surgeOfLightBorderChange2 then
							barBorderColor = specSettings.colors.bar.surgeOfLight2
						end

						if specSettings.audio.surgeOfLight2.enabled and not snapshot.audio.surgeOfLight2Cue then
							snapshot.audio.surgeOfLight2Cue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.surgeOfLight2.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshot.potionOfChilledClarity.isActive then
						if specSettings.colors.bar.potionOfChilledClarityBorderChange then
							barBorderColor = specSettings.colors.bar.potionOfChilledClarity
						end
					elseif snapshot.innervate.isActive then
						if specSettings.colors.bar.innervateBorderChange then
							barBorderColor = specSettings.colors.bar.innervate
						end

						if specSettings.audio.innervate.enabled and snapshot.audio.innervateCue == false then
							snapshot.audio.innervateCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
						end
					end
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentMana)

					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = currentMana + snapshot.casting.resourceFinal
					else
						castingBarValue = currentMana
					end

					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
					
					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, snapshot.potion, snapshot.conjuredChillglobe, TRB.Data.character, resourceFrame, CalculateManaGain)

					if TRB.Functions.Talent:IsTalentActive(spells.shadowfiend) and not snapshot.shadowfiend.isActive and snapshot.shadowfiend.resourceFinal == 0 then
						local shadowfiendThresholdColor = specSettings.colors.threshold.over
						if specSettings.thresholds.shadowfiend.enabled and (snapshot.shadowfiend.remainingTime == 0 or specSettings.thresholds.shadowfiend.cooldown) then
							local haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
							local shadowfiendMana = swingsRemaining * spells.shadowfiend.manaPercent * TRB.Data.character.maxResource

							if snapshot.shadowfiend.remainingTime > 0 then
								shadowfiendThresholdColor = specSettings.colors.threshold.unusable
							end

							if not haveTotem and shadowfiendMana > 0 and (castingBarValue + shadowfiendMana) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[8], resourceFrame, specSettings.thresholds.width, (castingBarValue + shadowfiendMana), TRB.Data.character.maxResource)
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
								resourceFrame.thresholds[8]:Show()

								if specSettings.thresholds.icons.showCooldown and snapshot.shadowfiend.remainingTime > 0 then
									resourceFrame.thresholds[8].icon.cooldown:SetCooldown(snapshot.shadowfiend.startTime, snapshot.shadowfiend.duration)
								else
									resourceFrame.thresholds[8].icon.cooldown:SetCooldown(0, 0)
								end
							else
								resourceFrame.thresholds[8]:Hide()
							end
						else
							resourceFrame.thresholds[8]:Hide()
						end
					else
						resourceFrame.thresholds[8]:Hide()
					end

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if snapshot.channeledManaPotion.isActive then
							passiveValue = passiveValue + snapshot.channeledManaPotion.mana

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

						if snapshot.innervate.mana > 0 or snapshot.potionOfChilledClarity.mana > 0 then
							passiveValue = passiveValue + math.max(snapshot.innervate.mana, snapshot.potionOfChilledClarity.mana)
		
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

						if snapshot.symbolOfHope.resourceFinal > 0 then
							passiveValue = passiveValue + snapshot.symbolOfHope.resourceFinal

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

						if snapshot.manaTideTotem.mana > 0 then
							passiveValue = passiveValue + snapshot.manaTideTotem.mana

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

						if snapshot.moltenRadiance.mana > 0 then
							passiveValue = passiveValue + snapshot.moltenRadiance.mana

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

						if snapshot.shadowfiend.resourceFinal > 0 then
							passiveValue = passiveValue + snapshot.shadowfiend.resourceFinal

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[6], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[6].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[6]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[6]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[6]:Hide()
						end
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						TRB.Frames.passiveFrame.thresholds[2]:Hide()
						TRB.Frames.passiveFrame.thresholds[3]:Hide()
						TRB.Frames.passiveFrame.thresholds[4]:Hide()
						TRB.Frames.passiveFrame.thresholds[5]:Hide()
						TRB.Frames.passiveFrame.thresholds[6]:Hide()
					end

					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < snapshot.resource then --Using a spender
						if -snapshot.casting.resourceFinal > passiveValue then
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, snapshot.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local resourceBarColor = nil

					if snapshot.casting.spellKey ~= nil then
						if spells[snapshot.casting.spellKey] ~= nil and
							spells[snapshot.casting.spellKey].holyWordKey ~= nil and
							spells[snapshot.casting.spellKey].holyWordReduction ~= nil and
							spells[snapshot.casting.spellKey].holyWordReduction >= 0 and
							TRB.Functions.Talent:IsTalentActive(spells[spells[snapshot.casting.spellKey].holyWordKey]) then

							local castTimeRemains = snapshot.casting.endTime - currentTime
							local holyWordCooldownRemaining = GetHolyWordCooldownTimeRemaining(TRB.Data.snapshot[spells[snapshot.casting.spellKey].holyWordKey])

							if (holyWordCooldownRemaining - CalculateHolyWordCooldown(spells[snapshot.casting.spellKey].holyWordReduction, spells[snapshot.casting.spellKey].id) - castTimeRemains) <= 0 and specSettings.bar[spells[snapshot.casting.spellKey].holyWordKey .. "Enabled"] then
								resourceBarColor = specSettings.colors.bar[spells[snapshot.casting.spellKey].holyWordKey]
							end
						end
					end

					if snapshot.apotheosis.spellId and resourceBarColor == nil then
						local timeThreshold = 0
						local useEndOfApotheosisColor = false

						if specSettings.endOfApotheosis.enabled then
							useEndOfApotheosisColor = true
							if specSettings.endOfApotheosis.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfApotheosis.gcdsMax
							elseif specSettings.endOfApotheosis.mode == "time" then
								timeThreshold = specSettings.endOfApotheosis.timeMax
							end
						end

						if useEndOfApotheosisColor and snapshot.apotheosis.remainingTime <= timeThreshold then
							resourceBarColor = specSettings.colors.bar.apotheosisEnd
						else
							resourceBarColor = specSettings.colors.bar.apotheosis
						end
					elseif resourceBarColor == nil then
						resourceBarColor = specSettings.colors.bar.base
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				end

				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		elseif specId == 3 then
			local specSettings = classSettings.shadow
			UpdateSnapshot_Shadow()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentInsanity = snapshot.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					local barBorderColor = specSettings.colors.bar.border
					local barColor = specSettings.colors.bar.base

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap
						if specSettings.audio.overcap.enabled and snapshot.audio.overcapCue == false then
							snapshot.audio.overcapCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						barBorderColor = specSettings.colors.bar.border
						snapshot.audio.overcapCue = false
					end

					if specSettings.colors.bar.mindFlayInsanityBorderChange and TRB.Functions.Class:IsValidVariableForSpec("$mfiTime") then
						barBorderColor = specSettings.colors.bar.borderMindFlayInsanity
					end

					if specSettings.colors.bar.deathspeaker.enabled and TRB.Functions.Class:IsValidVariableForSpec("$deathspeakerTime") then
						barBorderColor = specSettings.colors.bar.deathspeaker.color
					end
					
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = snapshot.casting.resourceFinal + currentInsanity
					else
						castingBarValue = currentInsanity
					end

					if specSettings.bar.showPassive and
						(TRB.Functions.Talent:IsTalentActive(spells.auspiciousSpirits) or
						(snapshot.shadowfiend.resourceFinal + snapshot.devouredDespair.resourceFinal) > 0 or
						snapshot.voidTendrils.resourceFinal > 0) then
						passiveValue = ((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * (snapshot.targetData.custom.auspiciousSpiritsGenerate or 0)) + snapshot.shadowfiend.resourceFinal + snapshot.devouredDespair.resourceFinal + snapshot.voidTendrils.resourceFinal)
						if (snapshot.shadowfiend.resourceFinal + snapshot.devouredDespair.resourceFinal) > 0 and (castingBarValue + (snapshot.shadowfiend.resourceFinal + snapshot.devouredDespair.resourceFinal)) < TRB.Data.character.maxResource then
							TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, specSettings.thresholds.width, (castingBarValue + (snapshot.shadowfiend.resourceFinal + snapshot.devouredDespair.resourceFinal)), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
							TRB.Frames.passiveFrame.thresholds[1]:Show()
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						passiveValue = 0
					end

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
						if spell ~= nil and spell.id ~= nil and spell.insanity ~= nil and spell.insanity < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							pairOffset = (spell.thresholdId - 1) * 3
							local resourceAmount = spell.insanity
							local currentResource = currentInsanity
							--TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.settingKey == spells.devouringPlague.settingKey then
									if TRB.Functions.Talent:IsTalentActive(spells.mindsEye) then
										resourceAmount = resourceAmount - spells.mindsEye.insanityMod
									end

									if TRB.Functions.Talent:IsTalentActive(spells.distortedReality) then
										resourceAmount = resourceAmount - spells.distortedReality.insanityMod
									end

									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif resourceAmount >= TRB.Data.character.maxResource then
										showThreshold = false
									elseif snapshot.mindDevourer.endTime ~= nil and currentTime < snapshot.mindDevourer.endTime then
										thresholdColor = specSettings.colors.threshold.over
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.settingKey == spells.devouringPlague2.settingKey then
									local previousResourceAmount = spells.devouringPlague.insanity
									if TRB.Functions.Talent:IsTalentActive(spells.mindsEye) then
										resourceAmount = resourceAmount - (spells.mindsEye.insanityMod*2)
										previousResourceAmount = previousResourceAmount - (spells.mindsEye.insanityMod)
									end

									if TRB.Functions.Talent:IsTalentActive(spells.distortedReality) then
										resourceAmount = resourceAmount - (spells.distortedReality.insanityMod*2)
										previousResourceAmount = previousResourceAmount - (spells.distortedReality.insanityMod)
									end

									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif -resourceAmount >= TRB.Data.character.maxResource then
										showThreshold = false
									elseif snapshot.mindDevourer.endTime ~= nil and
										currentTime < snapshot.mindDevourer.endTime and
										currentResource >= -previousResourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									elseif specSettings.thresholds.devouringPlagueThresholdOnlyOverShow and
										   -previousResourceAmount > currentResource  then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.settingKey == spells.devouringPlague3.settingKey then
									local previousResourceAmount = spells.devouringPlague2.insanity
									if TRB.Functions.Talent:IsTalentActive(spells.mindsEye) then
										resourceAmount = resourceAmount - (spells.mindsEye.insanityMod*3)
										previousResourceAmount = previousResourceAmount - (spells.mindsEye.insanityMod*2)
									end

									if TRB.Functions.Talent:IsTalentActive(spells.distortedReality) then
										resourceAmount = resourceAmount - (spells.distortedReality.insanityMod*3)
										previousResourceAmount = previousResourceAmount - (spells.distortedReality.insanityMod*2)
									end

									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif -resourceAmount >= TRB.Data.character.maxResource then
										showThreshold = false
									elseif snapshot.mindDevourer.endTime ~= nil and
										currentTime < snapshot.mindDevourer.endTime and
										currentResource >= -previousResourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									elseif specSettings.thresholds.devouringPlagueThresholdOnlyOverShow and
										-previousResourceAmount > currentResource then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							--The rest isn't used. Keeping it here for consistency until I can finish abstracting this whole mess out
							elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.hasCooldown then
								if (TRB.Data.snapshot[spell.settingKey].charges == nil or TRB.Data.snapshot[spell.settingKey].charges == 0) and
									(TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration)) then
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

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[spell.settingKey], specSettings)
						end
					end

					if snapshot.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold or snapshot.mindDevourer.isActive then
						if specSettings.colors.bar.flashEnabled then
							TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if snapshot.mindDevourer.isActive and specSettings.audio.mdProc.enabled and snapshot.audio.playedMdCue == false then
							snapshot.audio.playedDpCue = true
							snapshot.audio.playedMdCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.mdProc.sound, coreSettings.audio.channel.channel)
						elseif specSettings.audio.dpReady.enabled and snapshot.audio.playedDpCue == false then
							snapshot.audio.playedDpCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.dpReady.sound, coreSettings.audio.channel.channel)
						end
					else
						barContainerFrame:SetAlpha(1.0)
						snapshot.audio.playedDpCue = false
						snapshot.audio.playedMdCue = false
					end

					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < currentInsanity then --Using a spender
						if -snapshot.casting.resourceFinal > passiveValue then
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, currentInsanity)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, currentInsanity)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentInsanity)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					if snapshot.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.devouringPlagueUsableCasting, true))
					else
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					end

					if specSettings.colors.bar.instantMindBlast.enabled and snapshot.mindBlast.charges > 0 and snapshot.shadowyInsight.duration > 0 then
						barColor = specSettings.colors.bar.instantMindBlast.color
					elseif snapshot.voidform.remainingTime > 0 or snapshot.darkAscension.remainingTime > 0 then
						local timeLeft = snapshot.voidform.remainingTime
						if snapshot.darkAscension.remainingTime > 0 then
							timeLeft = snapshot.darkAscension.remainingTime
						end
						local timeThreshold = 0
						local useEndOfVoidformColor = false

						if specSettings.endOfVoidform.enabled then
							useEndOfVoidformColor = true
							if specSettings.endOfVoidform.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfVoidform.gcdsMax
							elseif specSettings.endOfVoidform.mode == "time" then
								timeThreshold = specSettings.endOfVoidform.timeMax
							end
						end

						if useEndOfVoidformColor and timeLeft <= timeThreshold then
							barColor = specSettings.colors.bar.inVoidform1GCD
						elseif snapshot.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							barColor = specSettings.colors.bar.devouringPlagueUsable
						else
							barColor = specSettings.colors.bar.inVoidform
						end
					else
						if snapshot.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							barColor = specSettings.colors.bar.devouringPlagueUsable
						else
							barColor = specSettings.colors.bar.base
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
		local snapshot = TRB.Data.snapshot
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshot.targetData

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, auraType = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			local settings

			if specId == 2 then
				settings = TRB.Data.settings.priest.holy
			elseif specId == 3 then
				settings = TRB.Data.settings.priest.shadow
			end

			if destGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "holy" then -- Let's check raid effect mana stuff
					if type == "SPELL_ENERGIZE" and spellId == spells.symbolOfHope.tickId then
						snapshot.symbolOfHope.isActive = true
						if snapshot.symbolOfHope.firstTickTime == nil then
							snapshot.symbolOfHope.firstTickTime = currentTime
							snapshot.symbolOfHope.previousTickTime = currentTime
							snapshot.symbolOfHope.ticksRemaining = spells.symbolOfHope.ticks
							if sourceGUID == TRB.Data.character.guid then
								snapshot.symbolOfHope.endTime = currentTime + (spells.symbolOfHope.duration / (1.5 / TRB.Functions.Character:GetCurrentGCDTime(true)))
								snapshot.symbolOfHope.tickRate = (spells.symbolOfHope.duration / spells.symbolOfHope.ticks) / (1.5 / TRB.Functions.Character:GetCurrentGCDTime(true))
								snapshot.symbolOfHope.tickRateFound = true
							else -- If the player isn't the one casting this, we can't know the tickrate until there are multiple ticks.
								snapshot.symbolOfHope.tickRate = (spells.symbolOfHope.duration / spells.symbolOfHope.ticks)
								snapshot.symbolOfHope.endTime = currentTime + spells.symbolOfHope.duration
							end
						else
							if snapshot.symbolOfHope.ticksRemaining >= 1 then
								if sourceGUID ~= TRB.Data.character.guid then
									if not snapshot.symbolOfHope.tickRateFound then
										snapshot.symbolOfHope.tickRate = currentTime - snapshot.symbolOfHope.previousTickTime
										snapshot.symbolOfHope.tickRateFound = true
										snapshot.symbolOfHope.endTime = currentTime + (snapshot.symbolOfHope.tickRate * (snapshot.symbolOfHope.ticksRemaining - 1))
									end

									if snapshot.symbolOfHope.tickRate > (1.75 * 1.5) then -- Assume if its taken this long for a tick to happen, the rate is really half this and one was missed
										snapshot.symbolOfHope.tickRate = snapshot.symbolOfHope.tickRate / 2
										snapshot.symbolOfHope.endTime = currentTime + (snapshot.symbolOfHope.tickRate * (snapshot.symbolOfHope.ticksRemaining - 2))
										snapshot.symbolOfHope.tickRateFound = false
									end
								end
							end
							snapshot.symbolOfHope.previousTickTime = currentTime
						end
						snapshot.symbolOfHope.resourceRaw = snapshot.symbolOfHope.ticksRemaining * spells.symbolOfHope.manaPercent * TRB.Data.character.maxResource
						snapshot.symbolOfHope.resourceFinal = CalculateManaGain(snapshot.symbolOfHope.resourceRaw, false)
					elseif spellId == spells.innervate.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.innervate)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshot.innervate.modifier = 0
							snapshot.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshot.innervate.modifier = 1
							snapshot.audio.innervateCue = false
						end
					elseif spellId == spells.potionOfChilledClarity.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.potionOfChilledClarity)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshot.potionOfChilledClarity.modifier = 0
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshot.potionOfChilledClarity.modifier = 1
						end
					elseif spellId == spells.manaTideTotem.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshot.manaTideTotem.isActive = true
							snapshot.manaTideTotem.duration = spells.manaTideTotem.duration
							snapshot.manaTideTotem.endTime = spells.manaTideTotem.duration + currentTime
							snapshot.audio.manaTideTotemCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshot.manaTideTotem.isActive = false
							snapshot.manaTideTotem.spellId = nil
							snapshot.manaTideTotem.duration = 0
							snapshot.manaTideTotem.endTime = nil
							snapshot.audio.manaTideTotemCue = false
						end
					elseif spellId == spells.moltenRadiance.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							local _
							_, _, _, _, snapshot.moltenRadiance.duration, snapshot.moltenRadiance.endTime, _, _, _, snapshot.moltenRadiance.spellId, _, _, _, _, _, _, _, snapshot.moltenRadiance.manaPerTick = TRB.Functions.Aura:FindBuffById(spells.moltenRadiance.id)
							snapshot.moltenRadiance.isActive = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshot.moltenRadiance.isActive = false
							snapshot.moltenRadiance.spellId = nil
							snapshot.moltenRadiance.duration = 0
							snapshot.moltenRadiance.endTime = nil
							snapshot.moltenRadiance.manaPerTick = 0
							snapshot.moltenRadiance.mana = 0
						end
					elseif settings.shadowfiend.enabled and type == "SPELL_ENERGIZE" and spellId == spells.shadowfiend.energizeId and sourceName == spells.shadowfiend.name then
						snapshot.shadowfiend.swingTime = currentTime
						snapshot.shadowfiend.startTime, snapshot.shadowfiend.duration, _, _ = GetSpellCooldown(spells.shadowfiend.id)
						triggerUpdate = true
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
					if settings.mindbender.enabled and type == "SPELL_ENERGIZE" and (spellId == spells.mindbender.energizeId or spellId == spells.shadowfiend.energizeId) and sourceName == spells.shadowfiend.name then
						if sourceGUID == snapshot.shadowfiend.guid then
							snapshot.shadowfiend.swingTime = currentTime
						
							if TRB.Functions.Talent:IsTalentActive(spells.mindbender) then
								snapshot.shadowfiend.startTime, snapshot.shadowfiend.duration, _, _ = GetSpellCooldown(spells.mindbender.id)
							else
								snapshot.shadowfiend.startTime, snapshot.shadowfiend.duration, _, _ = GetSpellCooldown(spells.shadowfiend.id)
							end
						end
						triggerUpdate = true
					end
				end
			end
			
			if sourceGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "holy" then
					if spellId == spells.symbolOfHope.id then
						if type == "SPELL_AURA_REMOVED" then -- Lost Symbol of Hope
							-- Let UpdateSymbolOfHope() clean this up
							UpdateSymbolOfHope(true)
						end
					elseif spellId == spells.potionOfFrozenFocusRank1.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							snapshot.channeledManaPotion.spellKey = "potionOfFrozenFocusRank1"
							snapshot.channeledManaPotion.isActive = true
							snapshot.channeledManaPotion.ticksRemaining = spells.potionOfFrozenFocusRank1.ticks
							snapshot.channeledManaPotion.mana = snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(spells.potionOfFrozenFocusRank1.mana, true)
							snapshot.channeledManaPotion.endTime = currentTime + spells.potionOfFrozenFocusRank1.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == spells.potionOfFrozenFocusRank2.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							snapshot.channeledManaPotion.spellKey = "potionOfFrozenFocusRank2"
							snapshot.channeledManaPotion.isActive = true
							snapshot.channeledManaPotion.ticksRemaining = spells.potionOfFrozenFocusRank2.ticks
							snapshot.channeledManaPotion.mana = snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(spells.potionOfFrozenFocusRank2.mana, true)
							snapshot.channeledManaPotion.endTime = currentTime + spells.potionOfFrozenFocusRank2.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == spells.potionOfFrozenFocusRank3.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							snapshot.channeledManaPotion.spellKey = "potionOfFrozenFocusRank3"
							snapshot.channeledManaPotion.isActive = true
							snapshot.channeledManaPotion.ticksRemaining = spells.potionOfFrozenFocusRank3.ticks
							snapshot.channeledManaPotion.mana = snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(spells.potionOfFrozenFocusRank3.mana, true)
							snapshot.channeledManaPotion.endTime = currentTime + spells.potionOfFrozenFocusRank3.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == spells.apotheosis.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.apotheosis)
					elseif spellId == spells.surgeOfLight.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.surgeOfLight)
						if type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
							snapshot.audio.surgeOfLight2Cue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshot.audio.surgeOfLightCue = false
							snapshot.audio.surgeOfLight2Cue = false
						end
					elseif spellId == spells.holyWordSerenity.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Serenity
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.holyWordSerenity.startTime, snapshot.holyWordSerenity.duration, _, _ = GetSpellCooldown(spells.holyWordSerenity.id)
						end
					elseif spellId == spells.holyWordSanctify.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Sanctify
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.holyWordSanctify.startTime, snapshot.holyWordSanctify.duration, _, _ = GetSpellCooldown(spells.holyWordSanctify.id)
						end
					elseif spellId == spells.holyWordChastise.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Chastise
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.holyWordChastise.startTime, snapshot.holyWordChastise.duration, _, _ = GetSpellCooldown(spells.holyWordChastise.id)
						end
					elseif spellId == spells.divineConversation.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.divineConversation, true)
					elseif spellId == spells.prayerFocus.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.prayerFocus, true)
					elseif type == "SPELL_SUMMON" and spellId == spells.shadowfiend.id then
						local currentSf = snapshot.shadowfiend
						local totemId = 1
						currentSf.guid = sourceGUID
						currentSf.totemId = totemId
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
					if spellId == spells.voidform.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.voidform)
					elseif spellId == spells.darkAscension.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.darkAscension)
					elseif spellId == spells.vampiricTouch.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- VT Applied to Target
								targetData.targets[destGUID].spells[spells.vampiricTouch.id].active = true
								if type == "SPELL_AURA_APPLIED" then
									targetData.count[spells.vampiricTouch.id] = targetData.count[spells.vampiricTouch.id] + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								targetData.targets[destGUID].spells[spells.vampiricTouch.id].active = false
								targetData.targets[destGUID].spells[spells.vampiricTouch.id].remainingTime = 0
								targetData.count[spells.vampiricTouch.id] = targetData.count[spells.vampiricTouch.id] - 1
								triggerUpdate = true
							end
						end
					elseif spellId == spells.devouringPlague.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- DP Applied to Target
								targetData.targets[destGUID].spells[spells.devouringPlague.id].active = true
								if type == "SPELL_AURA_APPLIED" then
									targetData.count[spells.devouringPlague.id] = targetData.count[spells.devouringPlague.id] + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								targetData.targets[destGUID].spells[spells.devouringPlague.id].active = false
								targetData.targets[destGUID].spells[spells.devouringPlague.id].remainingTime = 0
								targetData.count[spells.devouringPlague.id] = targetData.count[spells.devouringPlague.id] - 1
								triggerUpdate = true
							end
						end
					elseif settings.auspiciousSpiritsTracker and TRB.Functions.Talent:IsTalentActive(spells.auspiciousSpirits) and spellId == spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
						for guid, _ in pairs(targetData.targets) do
							if targetData.targets[guid].spells[spells.vampiricTouch.id].active then
								targetData.targets[guid].spells[spells.auspiciousSpirits.id].count = targetData.targets[guid].spells[spells.auspiciousSpirits.id].count + 1
							end
							targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] + 1
						end
						triggerUpdate = true
					elseif settings.auspiciousSpiritsTracker and TRB.Functions.Talent:IsTalentActive(spells.auspiciousSpirits) and spellId == spells.auspiciousSpirits.idImpact and (type == "SPELL_DAMAGE" or type == "SPELL_MISSED" or type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
						if targetData:CheckTargetExists(destGUID) then
							targetData.targets[destGUID].spells[spells.auspiciousSpirits.id].count = targetData.targets[destGUID].spells[spells.auspiciousSpirits.id].count - 1
							targetData.count[spells.auspiciousSpirits.id] = targetData.count[spells.auspiciousSpirits.id] - 1
						end
						triggerUpdate = true
					elseif type == "SPELL_ENERGIZE" and spellId == spells.shadowCrash.id then
						triggerUpdate = true
					elseif spellId == spells.mindDevourer.buffId then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.mindDevourer)
					elseif spellId == spells.devouredDespair.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.devouredDespair)
					elseif spellId == spells.mindFlayInsanity.buffId or spellId == spells.mindSpikeInsanity.buffId then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.mindFlayInsanity)
					elseif spellId == spells.deathspeaker.buffId then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.deathspeaker)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							if TRB.Data.settings.priest.shadow.audio.deathspeaker.enabled and snapshot.audio.playedDeathspeakerCue == false then
								snapshot.audio.playedDeathspeakerCue = true
								PlaySoundFile(TRB.Data.settings.priest.shadow.audio.deathspeaker.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == spells.twistOfFate.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.twistOfFate)
					elseif spellId == spells.shadowyInsight.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.shadowyInsight)
					elseif spellId == spells.mindMelt.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.mindMelt)
					elseif spellId == spells.idolOfYoggSaron.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.idolOfYoggSaron)
					elseif spellId == spells.thingFromBeyond.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.thingFromBeyond)
					elseif type == "SPELL_SUMMON" and settings.voidTendrilTracker and (spellId == spells.idolOfCthun_Tendril.id or spellId == spells.idolOfCthun_Lasher.id) then
						InitializeVoidTendril(destGUID)
						if spellId == spells.idolOfCthun_Tendril.id then
							snapshot.voidTendrils.activeList[destGUID].type = "Tendril"
						elseif spellId == spells.idolOfCthun_Lasher.id then
							snapshot.voidTendrils.activeList[destGUID].type = "Lasher"
							snapshot.voidTendrils.activeList[destGUID].targetsHit = 0
							snapshot.voidTendrils.activeList[destGUID].hasStruckTargets = true
						end

						snapshot.voidTendrils.numberActive = snapshot.voidTendrils.numberActive + 1
						snapshot.voidTendrils.maxTicksRemaining = snapshot.voidTendrils.maxTicksRemaining + spells.lashOfInsanity_Tendril.ticks
						snapshot.voidTendrils.activeList[destGUID].startTime = currentTime
						snapshot.voidTendrils.activeList[destGUID].tickTime = currentTime
					elseif type == "SPELL_SUMMON" and settings.mindbender.enabled and (spellId == spells.shadowfiend.id or spellId == spells.mindbender.id) then
						local currentSf = snapshot.shadowfiend
						local totemId = 1
						currentSf.guid = sourceGUID
						currentSf.totemId = totemId
					end
				end

				-- Spec agnostic
				if spellId == spells.shadowWordPain.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- SWP Applied to Target
							targetData.targets[destGUID].spells[spells.shadowWordPain.id].active = true
							if type == "SPELL_AURA_APPLIED" then
								targetData.count[spells.shadowWordPain.id] = targetData.count[spells.shadowWordPain.id] + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							targetData.targets[destGUID].spells[spells.shadowWordPain.id].active = false
							targetData.targets[destGUID].spells[spells.shadowWordPain.id].remainingTime = 0
							targetData.count[spells.shadowWordPain.id] = targetData.count[spells.shadowWordPain.id] - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				end
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" and settings.voidTendrilTracker and (spellId == spells.idolOfCthun_Tendril.idTick or spellId == spells.idolOfCthun_Lasher.idTick) and CheckVoidTendrilExists(sourceGUID) then
				if spellId == spells.idolOfCthun_Lasher.idTick and type == "SPELL_DAMAGE" then
					if currentTime > (snapshot.voidTendrils.activeList[sourceGUID].tickTime + 0.1) then --This is a new tick
						snapshot.voidTendrils.activeList[sourceGUID].targetsHit = 0
					end
					snapshot.voidTendrils.activeList[sourceGUID].targetsHit = snapshot.voidTendrils.activeList[sourceGUID].targetsHit + 1
					snapshot.voidTendrils.activeList[sourceGUID].tickTime = currentTime
					snapshot.voidTendrils.activeList[sourceGUID].hasStruckTargets = true
				else
					snapshot.voidTendrils.activeList[sourceGUID].tickTime = currentTime
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				targetData:Remove(destGUID)
				RefreshTargetTracking()
				triggerUpdate = true
			end

			if UnitIsDeadOrGhost("player") then -- We died/are dead go ahead and purge the list
			--if UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player") or event == "PLAYER_REGEN_ENABLED" then -- We died, or, exited combat, go ahead and purge the list
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
		if specId == 2 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.holy)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.holy)
			specCache.holy.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Holy()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.holy)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshot.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshot.targetData
			targetData:AddSpellTracking(spells.shadowWordPain)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Holy

			if TRB.Data.barConstructedForSpec ~= "holy" then
				TRB.Data.barConstructedForSpec = "holy"
				ConstructResourceBar(specCache.holy.settings)
			end
		elseif specId == 3 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.shadow)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.shadow)
			specCache.shadow.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Shadow()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.shadow)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshot.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshot.targetData
			targetData:AddSpellTracking(spells.auspiciousSpirits, false, true)
			targetData:AddSpellTracking(spells.devouringPlague)
			targetData:AddSpellTracking(spells.shadowWordPain)
			targetData:AddSpellTracking(spells.vampiricTouch)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow

			if TRB.Data.barConstructedForSpec ~= "shadow" then
				TRB.Data.barConstructedForSpec = "shadow"
				ConstructResourceBar(specCache.shadow.settings)
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
		if classIndexId == 5 then
			if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Priest.LoadDefaultSettings()
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
							TRB.Data.settings.priest.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues("Holy Priest", TRB.Data.settings.priest.holy)
							TRB.Data.settings.priest.shadow = TRB.Functions.LibSharedMedia:ValidateLsmValues("Shadow Priest", TRB.Data.settings.priest.shadow)
							
							FillSpellData_Holy()
							FillSpellData_Shadow()
							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Priest.ConstructOptionsPanel(specCache)
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
		TRB.Data.character.className = "priest"
		local specId = GetSpecialization()
		local spells = TRB.Data.spells

		if specId == 1 then
		elseif specId == 2 then
			TRB.Data.character.specName = "holy"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.Spell:FillSpellDataManaCost(spells)

			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeVersion = ""
						
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, spells.alchemistStone.itemIds[x])
					else
						break
					end
				end

				if alchemyStone == false then
					conjuredChillglobe, conjuredChillglobeVersion = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
				end
			end

			if alchemyStone == false and trinket2ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, spells.alchemistStone.itemIds[x])
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
		elseif specId == 3 then
			TRB.Data.character.specName = "shadow"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity)

			TRB.Data.character.devouringPlagueThreshold = -spells.devouringPlague.insanity
			
			if TRB.Functions.Talent:IsTalentActive(spells.mindsEye) then
				TRB.Data.character.devouringPlagueThreshold = TRB.Data.character.devouringPlagueThreshold + spells.mindsEye.insanityMod
			end
			
			if TRB.Functions.Talent:IsTalentActive(spells.distortedReality) then
				TRB.Data.character.devouringPlagueThreshold = TRB.Data.character.devouringPlagueThreshold + spells.distortedReality.insanityMod
			end
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 2 and TRB.Data.settings.core.enabled.priest.holy == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.holy)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
		elseif specId == 3 and TRB.Data.settings.core.enabled.priest.shadow == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.shadow)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Insanity
			TRB.Data.resourceFactor = 100
		else
			TRB.Data.specSupported = false
		end

		if TRB.Data.specSupported then
			TRB.Functions.Class:CheckCharacter()

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
		TRB.Functions.Bar:HideResourceBar()
	end

	function TRB.Functions.Class:HideResourceBar(force)
		local specId = GetSpecialization()
		local affectingCombat = UnitAffectingCombat("player")
		local snapshot = TRB.Data.snapshot

		if specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.priest.holy.displayBar.alwaysShow) and (
						(not TRB.Data.settings.priest.holy.displayBar.notZeroShow) or
						(TRB.Data.settings.priest.holy.displayBar.notZeroShow and snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshot.isTracking = false
			else
				snapshot.isTracking = true
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
						(TRB.Data.settings.priest.shadow.displayBar.notZeroShow and snapshot.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshot.isTracking = false
			else
				snapshot.isTracking = true
				if TRB.Data.settings.priest.shadow.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		else
			TRB.Frames.barContainerFrame:Hide()
			snapshot.isTracking = false
		end
	end

	function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end
		
		local currentTime = GetTime()
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshot.targetData
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
		local snapshot = TRB.Data.snapshot
		local spells = TRB.Data.spells
		---@type TRB.Classes.Target
		local target = snapshot.targetData.targets[snapshot.targetData.currentTargetGuid]
		local settings = nil
		if specId == 2 then
			settings = TRB.Data.settings.priest.holy
		elseif specId == 3 then
			settings = TRB.Data.settings.priest.shadow
		end

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
				if snapshot.casting.resourceRaw ~= nil and (snapshot.casting.resourceRaw ~= 0) then
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
			elseif var == "$sohMana" then
				if snapshot.symbolOfHope.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$sohTime" then
				if snapshot.symbolOfHope.isActive then
					valid = true
				end
			elseif var == "$sohTicks" then
				if snapshot.symbolOfHope.isActive then
					valid = true
				end
			elseif var == "$lightweaverTime" then
				if snapshot.lightweaver.remainingTime > 0 then
					valid = true
				end
			elseif var == "$lightweaverStacks" then
				if snapshot.lightweaver.remainingTime > 0 then
					valid = true
				end
			elseif var == "$rwTime" then
				if snapshot.resonantWords.remainingTime > 0 then
					valid = true
				end
			elseif var == "$innervateMana" then
				if snapshot.innervate.mana > 0 then
					valid = true
				end
			elseif var == "$innervateTime" then
				if snapshot.innervate.remainingTime > 0 then
					valid = true
				end
			elseif var == "$potionOfChilledClarityMana" then
				if snapshot.potionOfChilledClarity.mana > 0 then
					valid = true
				end
			elseif var == "$potionOfChilledClarityTime" then
				if snapshot.potionOfChilledClarity.remainingTime > 0 then
					valid = true
				end
			elseif var == "$mttMana" then
				if snapshot.manaTideTotem.mana > 0 then
					valid = true
				end
			elseif var == "$mttTime" then
				if snapshot.manaTideTotem.isActive then
					valid = true
				end
			elseif var == "$mrMana" then
				if snapshot.moltenRadiance.mana > 0 then
					valid = true
				end
			elseif var == "$mrTime" then
				if snapshot.moltenRadiance.isActive then
					valid = true
				end
			elseif var == "$channeledMana" then
				if snapshot.channeledManaPotion.mana > 0 then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTicks" then
				if snapshot.channeledManaPotion.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTime" then
				if GetChanneledPotionRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$potionCooldown" then
				if snapshot.potion.onCooldown then
					valid = true
				end
			elseif var == "$potionCooldownSeconds" then
				if snapshot.potion.onCooldown then
					valid = true
				end
			elseif var == "$solStacks" then
				if snapshot.surgeOfLight.stacks > 0 then
					valid = true
				end
			elseif var == "$solTime" then
				if snapshot.surgeOfLight.remainingTime > 0 then
					valid = true
				end
			elseif var == "$apotheosisTime" then
				if snapshot.apotheosis.remainingTime > 0 then
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
			elseif var == "$sfMana" then
				if snapshot.shadowfiend.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$sfGcds" then
				if snapshot.shadowfiend.remaining.gcds > 0 then
					valid = true
				end
			elseif var == "$sfSwings" then
				if snapshot.shadowfiend.remaining.swings > 0 then
					valid = true
				end
			elseif var == "$sfTime" then
				if snapshot.shadowfiend.remaining.time > 0 then
					valid = true
				end
			end
		elseif specId == 3 then
			if var == "$vfTime" then
				if (snapshot.voidform.remainingTime ~= nil and snapshot.voidform.remainingTime > 0) or
					(snapshot.darkAscension.remainingTime ~= nil and snapshot.darkAscension.remainingTime > 0) then
					valid = true
				end
			elseif var == "$resource" or var == "$insanity" then
				if snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$insanityMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$insanityTotal" then
				if snapshot.resource > 0 or
					(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw > 0) or
					(((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * snapshot.targetData.count[spells.auspiciousSpirits.id]) + snapshot.shadowfiend.resourceRaw + snapshot.voidTendrils.resourceFinal) > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$insanityPlusCasting" then
				if snapshot.resource > 0 or
					(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
				local threshold = ((snapshot.resource / TRB.Data.resourceFactor) + snapshot.casting.resourceFinal)
				if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$insanityPlusPassive" then
				if snapshot.resource > 0 or
					((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * snapshot.targetData.count[spells.auspiciousSpirits.id]) + snapshot.shadowfiend.resourceRaw + snapshot.voidTendrils.resourceFinal) > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$passive" then
				if ((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * snapshot.targetData.count[spells.auspiciousSpirits.id]) + snapshot.shadowfiend.resourceRaw + snapshot.voidTendrils.resourceFinal) > 0 then
					valid = true
				end
			elseif var == "$mbInsanity" then
				if snapshot.shadowfiend.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$mbGcds" then
				if snapshot.shadowfiend.remaining.gcds > 0 then
					valid = true
				end
			elseif var == "$mbSwings" then
				if snapshot.shadowfiend.remaining.swings > 0 then
					valid = true
				end
			elseif var == "$mbTime" then
				if snapshot.shadowfiend.remaining.time > 0 then
					valid = true
				end
			elseif var == "$loiInsanity" then
				if snapshot.voidTendrils.resourceFinal > 0 then
					valid = true
				end
			elseif var == "$loiTicks" then
				if snapshot.voidTendrils.maxTicksRemaining > 0 then
					valid = true
				end
			elseif var == "$cttvEquipped" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and (TRB.Functions.Talent:IsTalentActive(spells.idolOfCthun) or TRB.Data.character.items.callToTheVoid == true) then
					valid = true
				end
			elseif var == "$ecttvCount" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and snapshot.voidTendrils.numberActive > 0 then
					valid = true
				end
			elseif var == "$asCount" then
				if snapshot.targetData.count[spells.auspiciousSpirits.id] > 0 then
					valid = true
				end
			elseif var == "$asInsanity" then
				if snapshot.targetData.count[spells.auspiciousSpirits.id] > 0 then
					valid = true
				end
			elseif var == "$vtCount" then
				if snapshot.targetData.count[spells.vampiricTouch.id] > 0 then
					valid = true
				end
			elseif var == "$vtTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.vampiricTouch.id] ~= nil and
					target.spells[spells.vampiricTouch.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$dpCount" then
				if snapshot.targetData.count[spells.devouringPlague.id] > 0 then
					valid = true
				end
			elseif var == "$dpTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.devouringPlague.id] ~= nil and
					target.spells[spells.devouringPlague.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$mdTime" then
				if snapshot.mindDevourer.isActive then
					valid = true
				end
			elseif var == "$mfiTime" then
				if snapshot.mindFlayInsanity.isActive then
					valid = true
				end
			elseif var == "$mfiStacks" then
				if snapshot.mindFlayInsanity.isActive then
					valid = true
				end
			elseif var == "$deathspeakerTime" then
				if snapshot.deathspeaker.isActive then
					valid = true
				end
			elseif var == "$tofTime" then
				if snapshot.twistOfFate.spellId ~= nil then
					valid = true
				end
			elseif var == "$siTime" then
				if snapshot.shadowyInsight.duration > 0 then
					valid = true
				end
			elseif var == "$mmTime" then
				if snapshot.mindMelt.duration > 0 then
					valid = true
				end
			elseif var == "$mmStacks" then
				if snapshot.mindMelt.stacks > 0 then
					valid = true
				end
			elseif var == "$ysTime" then
				if snapshot.idolOfYoggSaron.duration > 0 then
					valid = true
				end
			elseif var == "$ysStacks" then
				if snapshot.idolOfYoggSaron.stacks > 0 then
					valid = true
				end
			elseif var == "$ysRemainingStacks" then
				if snapshot.idolOfYoggSaron.stacks > 0 then
					valid = true
				end
			elseif var == "$tfbTime" then
				if snapshot.thingFromBeyond.duration > 0 then
					valid = true
				end
			else
				valid = false
			end
		end

		-- Spec Agnostic
		if var == "$swpCount" then
			if snapshot.targetData.count[spells.shadowWordPain.id] > 0 then
				valid = true
			end
		elseif var == "$swpTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.shadowWordPain.id] ~= nil and
				target.spells[spells.shadowWordPain.id].remainingTime > 0 then
				valid = true
			end
		end
		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 2 and specId ~= 3 then
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