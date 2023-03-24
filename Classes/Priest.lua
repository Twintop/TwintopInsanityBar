local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
	TRB.Functions.Class = TRB.Functions.Class or {}
	TRB.Functions.Character:ResetSnapshotData()
	
	TRB.Frames.passiveFrame.thresholds[1] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[2] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[3] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[4] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[5] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[6] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.resourceFrame.thresholds[1] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[2] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[3] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[4] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[5] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[6] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[7] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[8] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)

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
				isActive = false,
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
				isActive = false,
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

		specCache.holy.snapshotData.manaRegen = 0
		specCache.holy.snapshotData.audio = {
			innervateCue = false,
			resonantWordsCue = false,
			lightweaverCue = false,
			surgeOfLightCue = false,
			surgeOfLight2Cue = false
		}
		specCache.holy.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			shadowWordPain = 0,
			targets = {}
		}
		specCache.holy.snapshotData.innervate = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.holy.snapshotData.potionOfChilledClarity = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.holy.snapshotData.manaTideTotem = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.holy.snapshotData.shadowfiend = {
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
		specCache.holy.snapshotData.resonantWords = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.holy.snapshotData.lightweaver = {
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
		specCache.holy.snapshotData.channeledManaPotion = {
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
		specCache.holy.snapshotData.conjuredChillglobe = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.holy.snapshotData.divineConversation = {
			isActive = false
		}
		specCache.holy.snapshotData.prayerFocus = {
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
				baseline = true
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
			shadowyApparition = {
				id = 341491,
				name = "",
				icon = "",
				isTalent = true
			},
			auspiciousSpirits = {
				id = 155271,
				idSpawn = 341263,
				idImpact = 148859,
				insanity = 2,
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
				insanity = -5
			},
			distortedReality = {
				id = 409044,
				name = "",
				icon = "",
				isTalent = true,
				insanity = 10
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
				id = 391403,
				name = "",
				icon = "",
				buffId = 407468,
				insanity = 6,
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
				isActive = false,
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

			-- T30 4P
			weakeningReality = {
				id = 409502,
				name = "",
				icon = "",
				maxStacks = 7 -- 0 - 7, at 8 it triggers SF/Mb and goes back to 0 TODO: verify this doesn't change to something like Arcano Pulsar for Balance
			},
		}

		specCache.shadow.snapshotData.voidform = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.shadow.snapshotData.darkAscension = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.shadow.snapshotData.audio = {
			playedDpCue = false,
			playedMdCue = false,
			overcapCue = false
		}
		specCache.shadow.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			auspiciousSpirits = 0,
			shadowWordPain = 0,
			vampiricTouch = 0,
			devouringPlague = 0,
			targets = {}
		}
		specCache.shadow.snapshotData.shadowfiend = {
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
		specCache.shadow.snapshotData.shadowfiendTier30 = {
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
		specCache.shadow.snapshotData.devouredDespair = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0,
			insanity = 0,
			ticks = 0
		}
		specCache.shadow.snapshotData.voidTendrils = {
			numberActive = 0,
			resourceRaw = 0,
			resourceFinal = 0,
			maxTicksRemaining = 0,
			activeList = {}
		}
		specCache.shadow.snapshotData.mindDevourer = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			consumedTime = nil
		}
		specCache.shadow.snapshotData.mindFlayInsanity = {
			spellId = nil,
			endTime = nil,
			remainingTime = 0,
			duration = 0
		}
		specCache.shadow.snapshotData.twistOfFate = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshotData.mindMelt = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
		}
		specCache.shadow.snapshotData.shadowyInsight = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
		}
		specCache.shadow.snapshotData.voidBolt = {
			lastSuccess = nil,
			flightTime = 1.0
		}
		specCache.shadow.snapshotData.mindBlast = {
			startTime = nil,
			duration = 0,
			charges = 1,
			maxCharges = 1
		}
		specCache.shadow.snapshotData.weakeningReality = {
			stacks = 0,
			lastDevouringPlagueCastTime = nil
		}
	end

	local function Setup_Holy()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "priest", "holy")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.holy)
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
			
			{ variable = "$mttMana", description = "Bonus passive mana regen while Mana Tide Totem is active", printInSettings = true, color = false },
			{ variable = "$mttTime", description = "Time left on Mana Tide Totem", printInSettings = true, color = false },

			{ variable = "$channeledMana", description = "Mana while channeling of Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTicks", description = "Number of ticks left channeling Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Frozen Focus", printInSettings = true, color = false },
			
			{ variable = "$potionCooldown", description = "How long, in seconds, is left on your potion's cooldown in MM:SS format", printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = "How long, in seconds, is left on your potion's cooldown in seconds", printInSettings = true, color = false },

			{ variable = "$swpCount", description = "Number of Shadow Word: Pains active on targets", printInSettings = true, color = false },
			{ variable = "$swpTime", description = "Time remaining on Shadow Word: Pain on your current target", printInSettings = true, color = false },
			
			{ variable = "$sfMana", description = "Mana from Shadowfiend (per settings)", printInSettings = true, color = false },
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
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.shadow)
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

			{ variable = "#sf", icon = spells.shadowfiend.icon, description = "Shadowfiend / Mindbender", printInSettings = true },
			{ variable = "#mindbender", icon = spells.mindbender.icon, description = "Mindbender", printInSettings = false },
			{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = "Shadowfiend", printInSettings = false },
																						  
			{ variable = "#si", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = true },
			{ variable = "#shadowyInsight", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = false },
																															  
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

			{ variable = "$mbInsanity", description = "Insanity from Mindbender/Shadowfiend (per settings)", printInSettings = true, color = false },
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

			{ variable = "$mfiTime", description = "Time remaining on Mind Flay: Insanity buff", printInSettings = true, color = false },
			
			{ variable = "$siTime", description = "Time remaining on Shadowy Insight buff", printInSettings = true, color = false },
			
			{ variable = "$mindBlastCharges", description = "Current number of Mind Blast charges", printInSettings = true, color = false },
			{ variable = "$mindBlastMaxCharges", description = "Maximum number of Mind Blast charges", printInSettings = true, color = false },
			

			{ variable = "$mmTime", description = "Time remaining on Mind Melt buff", printInSettings = true, color = false },
			{ variable = "$mmStacks", description = "Time remaining on Mind Melt stacks", printInSettings = true, color = false },

			{ variable = "$vfTime", description = "Duration remaining of Voidform", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.shadow.spells = spells
	end

	local function CheckVoidTendrilExists(guid)
		if guid == nil or (not TRB.Data.snapshotData.voidTendrils.activeList[guid] or TRB.Data.snapshotData.voidTendrils.activeList[guid] == nil) then
			return false
		end
		return true
	end

	local function InitializeVoidTendril(guid)
		if guid ~= nil and not CheckVoidTendrilExists(guid) then
			TRB.Data.snapshotData.voidTendrils.activeList[guid] = {}
			TRB.Data.snapshotData.voidTendrils.activeList[guid].startTime = nil
			TRB.Data.snapshotData.voidTendrils.activeList[guid].tickTime = nil
			TRB.Data.snapshotData.voidTendrils.activeList[guid].type = nil
			TRB.Data.snapshotData.voidTendrils.activeList[guid].targetsHit = 0
			TRB.Data.snapshotData.voidTendrils.activeList[guid].hasStruckTargets = false
		end
	end

	local function RemoveVoidTendril(guid)
		if guid ~= nil and CheckVoidTendrilExists(guid) then
			TRB.Data.snapshotData.voidTendrils.activeList[guid] = nil
		end
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

		if specId == 2 then -- Holy
			local swpTotal = 0
			for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain = false
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPainRemaining = 0
				else
					if TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain == true then
						swpTotal = swpTotal + 1
					end
				end
			end

			TRB.Data.snapshotData.targetData.shadowWordPain = swpTotal
		elseif specId == 3 then -- Shadow
			local swpTotal = 0
			local vtTotal = 0
			local asTotal = 0
			local dpTotal = 0
			for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[tguid].auspiciousSpirits = 0
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain = false
					TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPainRemaining = 0
					TRB.Data.snapshotData.targetData.targets[tguid].vampiricTouch = false
					TRB.Data.snapshotData.targetData.targets[tguid].vampiricTouchRemaining = 0
					TRB.Data.snapshotData.targetData.targets[tguid].devouringPlague = false
					TRB.Data.snapshotData.targetData.targets[tguid].devouringPlagueRemaining = 0
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
				end
			end

			TRB.Data.snapshotData.targetData.auspiciousSpirits = asTotal
			if TRB.Data.snapshotData.targetData.auspiciousSpirits < 0 then
				TRB.Data.snapshotData.targetData.auspiciousSpirits = 0
			end

			TRB.Data.snapshotData.targetData.shadowWordPain = swpTotal
			TRB.Data.snapshotData.targetData.vampiricTouch = vtTotal
			TRB.Data.snapshotData.targetData.devouringPlague = dpTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.Target:TargetsCleanup(clearAll)
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
		end
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		if specId == 2 then
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], TRB.Data.spells.shadowfiend.settingKey, TRB.Data.settings.priest.holy)
		elseif specId == 3 then
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.devouringPlague.settingKey, TRB.Data.settings.priest.shadow)
		end

		TRB.Functions.Bar:Construct(settings)
		if specId == 2 or specId == 3 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end
	
	local function GetVoidformRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.voidform)
	end
	
	local function GetDarkAscensionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.darkAscension)
	end

	local function GetShadowfiendCooldownRemainingTime(shadowfiend)
		if shadowfiend then
			return TRB.Functions.Spell:GetRemainingTime(shadowfiend)
		else
			return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.shadowfiend)
		end
	end
	
	local function GetApotheosisRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.apotheosis)
	end

	local function GetInnervateRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.innervate)
	end

	local function GetPotionOfChilledClarityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.potionOfChilledClarity)
	end

	local function GetManaTideTotemRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.manaTideTotem)
	end

	local function GetSymbolOfHopeRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.symbolOfHope)
	end

	local function GetSurgeOfLightRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.surgeOfLight)
	end	

	local function GetResonantWordsRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.resonantWords)
	end

	local function GetLightweaverRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.lightweaver)
	end

	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.channeledManaPotion)
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
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData.holyWordSerenity)
	end

	local function GetHolyWordSanctifyCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData.holyWordSanctify)
	end

	local function GetHolyWordChastiseCooldownRemainingTime()
		return GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData.holyWordChastise)
	end

	local function CalculateHolyWordCooldown(base, spellId)
		local mod = 1
		local divineConversationValue = 0
		local prayerFocusValue = 0

		if TRB.Data.snapshotData.divineConversation.isActive then
			if TRB.Data.character.isPvp then
				divineConversationValue = TRB.Data.spells.divineConversation.reductionPvp
			else
				divineConversationValue = TRB.Data.spells.divineConversation.reduction
			end
		end

		if TRB.Data.snapshotData.prayerFocus.isActive and (spellId == TRB.Data.spells.heal.id or spellId == TRB.Data.spells.prayerOfHealing.id) then
			prayerFocusValue = TRB.Data.spells.prayerFocus.holyWordReduction
		end

		if TRB.Data.spells.apotheosis.isActive then
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
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshotData.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.priest.holy.colors.text.current
		local castingManaColor = TRB.Data.settings.priest.holy.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.priest.holy.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = TRB.Data.snapshotData.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		--$sohMana
		local _sohMana = TRB.Data.snapshotData.symbolOfHope.resourceFinal
		local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
		--$sohTicks
		local _sohTicks = TRB.Data.snapshotData.symbolOfHope.ticksRemaining or 0
		local sohTicks = string.format("%.0f", _sohTicks)
		--$sohTime
		local _sohTime = GetSymbolOfHopeRemainingTime()
		local sohTime = string.format("%.1f", _sohTime)

		--$innervateMana
		local _innervateMana = TRB.Data.snapshotData.innervate.mana
		local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
		--$innervateTime
		local _innervateTime = GetInnervateRemainingTime()
		local innervateTime = string.format("%.1f", _innervateTime)

		--$potionOfChilledClarityMana
		local _potionOfChilledClarityMana = TRB.Data.snapshotData.potionOfChilledClarity.mana
		local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
		--$potionOfChilledClarityTime
		local _potionOfChilledClarityTime = GetPotionOfChilledClarityRemainingTime()
		local potionOfChilledClarityTime = string.format("%.1f", _potionOfChilledClarityTime)

		--$mttMana
		local _mttMana = TRB.Data.snapshotData.symbolOfHope.resourceFinal
		local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
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
		local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
		--$potionOfFrozenFocusTicks
		local _potionOfFrozenFocusTicks = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining or 0
		local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
		--$potionOfFrozenFocusTime
		local _potionOfFrozenFocusTime = GetChanneledPotionRemainingTime()
		local potionOfFrozenFocusTime = string.format("%.1f", _potionOfFrozenFocusTime)
		
		--$sfMana
		local _sfMana = TRB.Data.snapshotData.shadowfiend.resourceFinal
		local sfMana = string.format("|c%s%s|r", TRB.Data.settings.priest.holy.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
		--$sfGcds
		local _sfGcds = TRB.Data.snapshotData.shadowfiend.remaining.gcds
		local sfGcds = string.format("%.0f", _sfGcds)
		--$sfSwings
		local _sfSwings = TRB.Data.snapshotData.shadowfiend.remaining.swings
		local sfSwings = string.format("%.0f", _sfSwings)
		--$sfTime
		local _sfTime = TRB.Data.snapshotData.shadowfiend.remaining.time
		local sfTime = string.format("%.1f", _sfTime)

		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.priest.holy.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
		--$manaTotal
		local _manaTotal = math.min(_passiveMana + TRB.Data.snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
		--$manaPlusCasting
		local _manaPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
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
		local _apotheosisTime = TRB.Data.snapshotData.apotheosis.remainingTime
		local apotheosisTime = string.format("%.1f", _apotheosisTime)

		--$solStacks
		local _solStacks = TRB.Data.snapshotData.surgeOfLight.stacks or 0
		local solStacks = string.format("%.0f", _solStacks)
		--$solTime
		local _solTime = TRB.Data.snapshotData.surgeOfLight.remainingTime or 0
		local solTime = string.format("%.1f", _solTime)

		--$lightweaverStacks
		local _lightweaverStacks = TRB.Data.snapshotData.lightweaver.stacks or 0
		local lightweaverStacks = string.format("%.0f", _lightweaverStacks)
		--$lightweaverTime
		local _lightweaverTime = TRB.Data.snapshotData.lightweaver.remainingTime or 0
		local lightweaverTime = string.format("%.1f", _lightweaverTime)
		
		--$rwTime
		local _rwTime = TRB.Data.snapshotData.resonantWords.remainingTime or 0
		local rwTime = string.format("%.1f", _rwTime)

		-----------
		--$swpCount and $swpTime
		local _shadowWordPainCount = TRB.Data.snapshotData.targetData.shadowWordPain or 0
		local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
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
		Global_TwintopResourceBar.resource.channeledPotion = _channeledMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.potionOfChilledClarity = _potionOfChilledClarityMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.channeledPotion = {
			mana = _channeledMana,
			ticks = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = TRB.Data.snapshotData.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.shadowfiend = {
			mana = TRB.Data.snapshotData.shadowfiend.resourceFinal or 0,
			gcds = TRB.Data.snapshotData.shadowfiend.remaining.gcds or 0,
			swings = TRB.Data.snapshotData.shadowfiend.remaining.swings or 0,
			time = TRB.Data.snapshotData.shadowfiend.remaining.time or 0
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#apotheosis"] = TRB.Data.spells.apotheosis.icon
		lookup["#coh"] = TRB.Data.spells.circleOfHealing.icon
		lookup["#circleOfHealing"] = TRB.Data.spells.circleOfHealing.icon
		lookup["#flashHeal"] = TRB.Data.spells.flashHeal.icon
		lookup["#ha"] = TRB.Data.spells.harmoniousApparatus.icon
		lookup["#harmoniousApparatus"] = TRB.Data.spells.harmoniousApparatus.icon
		lookup["#heal"] = TRB.Data.spells.heal.icon
		lookup["#hf"] = TRB.Data.spells.holyFire.icon
		lookup["#holyFire"] = TRB.Data.spells.holyFire.icon
		lookup["#hwChastise"] = TRB.Data.spells.holyWordChastise.icon
		lookup["#chastise"] = TRB.Data.spells.holyWordChastise.icon
		lookup["#holyWordChastise"] = TRB.Data.spells.holyWordChastise.icon
		lookup["#hwSanctify"] = TRB.Data.spells.holyWordSanctify.icon
		lookup["#sanctify"] = TRB.Data.spells.holyWordSanctify.icon
		lookup["#holyWordSanctify"] = TRB.Data.spells.holyWordSanctify.icon
		lookup["#hwSerenity"] = TRB.Data.spells.holyWordSerenity.icon
		lookup["#serenity"] = TRB.Data.spells.holyWordSerenity.icon
		lookup["#holyWordSerenity"] = TRB.Data.spells.holyWordSerenity.icon
		lookup["#lightweaver"] = TRB.Data.spells.lightweaver.icon
		lookup["#rw"] = TRB.Data.spells.resonantWords.icon
		lookup["#resonantWords"] = TRB.Data.spells.resonantWords.icon
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
		lookup["#amp"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = TRB.Data.spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = TRB.Data.spells.potionOfChilledClarity.icon
		lookup["#swp"] = TRB.Data.spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = TRB.Data.spells.shadowWordPain.icon
		lookup["#shadowfiend"] = TRB.Data.spells.shadowfiend.icon
		lookup["#sf"] = TRB.Data.spells.shadowfiend.icon

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
		local currentTime = GetTime()
		local normalizedInsanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		--$vfTime
		local _voidformTime = TRB.Data.snapshotData.voidform.remainingTime

		--TODO: not use this hacky workaroud for timers
		if TRB.Data.snapshotData.darkAscension.remainingTime > 0 then
			_voidformTime = TRB.Data.snapshotData.darkAscension.remainingTime
		end

		local voidformTime = string.format("%.1f", _voidformTime)
		----------

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.currentInsanity
		local castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.castingInsanity

		local insanityThreshold = TRB.Data.character.devouringPlagueThreshold

		if TRB.Data.snapshotData.mindDevourer.spellId ~= nil then
			insanityThreshold = 0
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
		local _currentInsanity = normalizedInsanity
		local currentInsanity = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_currentInsanity, insanityPrecision, "floor"))
		--$casting
		local _castingInsanity = TRB.Data.snapshotData.casting.resourceFinal
		local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_castingInsanity, insanityPrecision, "floor"))
		--$mbInsanity
		local _mbInsanity = TRB.Data.snapshotData.shadowfiend.resourceFinal + TRB.Data.snapshotData.shadowfiendTier30.resourceFinal + TRB.Data.snapshotData.devouredDespair.resourceFinal
		local mbInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_mbInsanity, insanityPrecision, "floor"))
		--$mbGcds
		local _mbGcds = TRB.Data.snapshotData.shadowfiend.remaining.gcds
		local mbGcds = string.format("%.0f", _mbGcds)
		--$mbSwings
		local _mbSwings = TRB.Data.snapshotData.shadowfiend.remaining.swings
		local mbSwings = string.format("%.0f", _mbSwings)
		--$mbTime
		local _mbTime = TRB.Data.snapshotData.shadowfiend.remaining.time
		local mbTime = string.format("%.1f", _mbTime)
		--$loiInsanity
		local _loiInsanity = TRB.Data.snapshotData.voidTendrils.resourceFinal
		local loiInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_loiInsanity, insanityPrecision, "floor"))
		--$loiTicks
		local _loiTicks = TRB.Data.snapshotData.voidTendrils.maxTicksRemaining
		local loiTicks = string.format("%.0f", _loiTicks)
		--$ecttvCount
		local _ecttvCount = TRB.Data.snapshotData.voidTendrils.numberActive
		local ecttvCount = string.format("%.0f", _ecttvCount)
		--$asCount
		local _asCount = TRB.Data.snapshotData.targetData.auspiciousSpirits
		local asCount = string.format("%.0f", _asCount)
		--$asInsanity
		local _asInsanity = CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits
		local asInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_asInsanity, insanityPrecision, "floor"))
		--$passive
		local _passiveInsanity = _asInsanity + _mbInsanity + _loiInsanity
		local passiveInsanity = string.format("|c%s%s|r", TRB.Data.settings.priest.shadow.colors.text.passiveInsanity, TRB.Functions.Number:RoundTo(_passiveInsanity, insanityPrecision, "floor"))
		--$insanityTotal
		local _insanityTotal = math.min(_passiveInsanity + TRB.Data.snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityTotal = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_insanityTotal, insanityPrecision, "floor"))
		--$insanityPlusCasting
		local _insanityPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusCasting = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_insanityPlusCasting, insanityPrecision, "floor"))
		--$insanityPlusPassive
		local _insanityPlusPassive = math.min(_passiveInsanity + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusPassive = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_insanityPlusPassive, insanityPrecision, "floor"))


		----------
		--$swpCount and $swpTime
		local _shadowWordPainCount = TRB.Data.snapshotData.targetData.shadowWordPain or 0
		local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
		local _shadowWordPainTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_shadowWordPainTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining or 0
		end

		local shadowWordPainTime

		--$vtCount and $vtTime
		local _vampiricTouchCount = TRB.Data.snapshotData.targetData.vampiricTouch or 0
		local vampiricTouchCount = string.format("%s", _vampiricTouchCount)
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
		if TRB.Data.snapshotData.mindDevourer.endTime then
			_mdTime = math.abs(TRB.Data.snapshotData.mindDevourer.endTime - currentTime)
		end
		local mdTime = string.format("%.1f", _mdTime)
		
		--$mfiTime
		local _mfiTime = 0
		if TRB.Data.snapshotData.mindFlayInsanity.endTime then
			_mfiTime = math.abs(TRB.Data.snapshotData.mindFlayInsanity.endTime - currentTime)
		end
		local mfiTime = string.format("%.1f", _mfiTime)

		--$tofTime
		local _tofTime = 0
		if TRB.Data.snapshotData.twistOfFate.endTime then
			_tofTime = math.abs(TRB.Data.snapshotData.twistOfFate.endTime - currentTime)
		end
		local tofTime = string.format("%.1f", _tofTime)
		
		--$mindBlastCharges
		local mindBlastCharges = TRB.Data.snapshotData.mindBlast.charges or 0
		
		--$mindBlastMaxCharges
		local mindBlastMaxCharges = TRB.Data.snapshotData.mindBlast.maxCharges or 0

		--$siTime
		local _siTime = 0
		if TRB.Data.snapshotData.shadowyInsight.endTime then
			_siTime = math.abs(TRB.Data.snapshotData.shadowyInsight.endTime - currentTime)
		end
		local siTime = string.format("%.1f", _siTime)
		
		--$mmTime
		local _mmTime = 0
		if TRB.Data.snapshotData.mindMelt.endTime then
			_mmTime = math.abs(TRB.Data.snapshotData.mindMelt.endTime - currentTime)
		end
		local mmTime = string.format("%.1f", _mmTime)
		--$mmStacks
		local mmStacks = TRB.Data.snapshotData.mindMelt.stacks or 0

		--$cttvEquipped
		local cttvEquipped = TRB.Functions.Class:IsValidVariableForSpec("$cttvEquipped")

		----------------------------

		Global_TwintopResourceBar.voidform = {
		}
		Global_TwintopResourceBar.resource.passive = _passiveInsanity
		Global_TwintopResourceBar.resource.auspiciousSpirits = _asInsanity
		Global_TwintopResourceBar.resource.shadowfiend = _mbInsanity or 0
		Global_TwintopResourceBar.resource.mindbender = _mbInsanity or 0
		Global_TwintopResourceBar.resource.ecttv = TRB.Data.snapshotData.voidTendrils.resourceFinal or 0
		Global_TwintopResourceBar.auspiciousSpirits = {
			count = TRB.Data.snapshotData.targetData.auspiciousSpirits or 0,
			insanity = _asInsanity
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0,
			vtCount = _vampiricTouchCount or 0,
			dpCount = devouringPlagueCount or 0
		}
		Global_TwintopResourceBar.shadowfiend = {
			insanity = _mbInsanity or 0,
			gcds = TRB.Data.snapshotData.shadowfiend.remaining.gcds or 0,
			swings = TRB.Data.snapshotData.shadowfiend.remaining.swings or 0,
			time = TRB.Data.snapshotData.shadowfiend.remaining.time or 0
		}
		Global_TwintopResourceBar.mindbender = {
			insanity = _mbInsanity,
			gcds = TRB.Data.snapshotData.shadowfiend.remaining.gcds or 0,
			swings = TRB.Data.snapshotData.shadowfiend.remaining.swings or 0,
			time = TRB.Data.snapshotData.shadowfiend.remaining.time or 0
		}
		Global_TwintopResourceBar.eternalCallToTheVoid = {
			insanity = TRB.Data.snapshotData.voidTendrils.resourceFinal or 0,
			ticks = TRB.Data.snapshotData.voidTendrils.maxTicksRemaining or 0,
			count = TRB.Data.snapshotData.voidTendrils.numberActive or 0
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
		lookup["#mfi"] = TRB.Data.spells.mindFlayInsanity.icon
		lookup["#mindFlayInsanity"] = TRB.Data.spells.mindFlayInsanity.icon
		lookup["#mindgames"] = TRB.Data.spells.mindgames.icon
		lookup["#mindbender"] = TRB.Data.spells.mindbender.icon
		lookup["#shadowfiend"] = TRB.Data.spells.shadowfiend.icon
		lookup["#sf"] = TRB.Data.spells.shadowfiend.icon
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
		lookup["#si"] = TRB.Data.spells.shadowyInsight.icon
		lookup["#shadowyInsight"] = TRB.Data.spells.shadowyInsight.icon
		lookup["#mm"] = TRB.Data.spells.mindMelt.icon
		lookup["#mindMelt"] = TRB.Data.spells.mindMelt.icon
		lookup["#md"] = TRB.Data.spells.massDispel.icon
		lookup["#massDispel"] = TRB.Data.spells.massDispel.icon
		lookup["#cthun"] = TRB.Data.spells.idolOfCthun.icon
		lookup["#idolOfCthun"] = TRB.Data.spells.idolOfCthun.icon
		lookup["#loi"] = TRB.Data.spells.idolOfCthun.icon
		lookup["$swpCount"] = shadowWordPainCount
		lookup["$swpTime"] = shadowWordPainTime
		lookup["$vtCount"] = vampiricTouchCount
		lookup["$vtTime"] = vampiricTouchTime
		lookup["$dpCount"] = devouringPlagueCount
		lookup["$dpTime"] = devouringPlagueTime
		lookup["$mdTime"] = mdTime
		lookup["$mfiTime"] = mfiTime
		lookup["$tofTime"] = tofTime
		lookup["$vfTime"] = voidformTime
		lookup["$mmTime"] = mmTime
		lookup["$mmStacks"] = mmStacks
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
		lookupLogic["$tofTime"] = _tofTime
		lookupLogic["$vfTime"] = _voidformTime
		lookupLogic["$mmTime"] = _mmTime
		lookupLogic["$mmStacks"] = mmStacks
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
		TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw * TRB.Data.snapshotData.innervate.modifier * TRB.Data.snapshotData.potionOfChilledClarity.modifier
	end

	local function UpdateCastingResourceFinal_Shadow()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function CastingSpell()
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
					if currentChannelId == TRB.Data.spells.symbolOfHope.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.symbolOfHope.id
						TRB.Data.snapshotData.casting.startTime = currentChannelStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentChannelEndTime / 1000
						TRB.Data.snapshotData.casting.resourceRaw = 0
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.symbolOfHope.icon
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

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
						elseif TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.harmoniousApparatus) then
							if currentSpellId == TRB.Data.spells.circleOfHealing.id then --Harmonious Apparatus / This shouldn't happen
								TRB.Data.snapshotData.casting.spellKey = "circleOfHealing"
							elseif currentSpellId == TRB.Data.spells.prayerOfMending.id then --Harmonious Apparatus / This shouldn't happen
								TRB.Data.snapshotData.casting.spellKey = "prayerOfMending"
							elseif currentSpellId == TRB.Data.spells.holyFire.id then --Harmonious Apparatus
								TRB.Data.snapshotData.casting.spellKey = "holyFire"
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
					if currentChannelId == TRB.Data.spells.mindFlay.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindFlay.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindFlay.insanity
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindFlay.icon
					elseif currentChannelId == TRB.Data.spells.mindFlayInsanity.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindFlayInsanity.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindFlayInsanity.insanity
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindFlayInsanity.icon
					elseif currentChannelId == TRB.Data.spells.voidTorrent.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.voidTorrent.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.voidTorrent.insanity
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.voidTorrent.icon
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
					UpdateCastingResourceFinal_Shadow()
				else
					if currentSpellId == TRB.Data.spells.mindBlast.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindBlast.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindBlast.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindBlast.icon
					elseif currentSpellId == TRB.Data.spells.mindSpike.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindSpike.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindSpike.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindSpike.icon
					elseif currentSpellId == TRB.Data.spells.darkAscension.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.darkAscension.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.darkAscension.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.darkAscension.icon
					elseif currentSpellId == TRB.Data.spells.vampiricTouch.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.vampiricTouch.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.vampiricTouch.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.vampiricTouch.icon
					elseif currentSpellId == TRB.Data.spells.mindgames.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindgames.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindgames.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindgames.icon
					elseif currentSpellId == TRB.Data.spells.halo.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.halo.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.halo.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.halo.icon
					elseif currentSpellId == TRB.Data.spells.massDispel.id and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.hallucinations) and affectingCombat then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.hallucinations.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.massDispel.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.massDispel.icon
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

		local swingTime = TRB.Data.snapshotData.shadowfiend.swingTime

		local currentTime = GetTime()
		local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
		local timeRemaining = startTime+duration-currentTime

		if not haveTotem then
			if specId == 2 then
				timeRemaining = TRB.Data.spells.shadowfiend.duration
				swingTime = currentTime
			end
		end

		local swingSpeed = 1.5 / (1 + (TRB.Data.snapshotData.haste / 100))
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

		UpdateSpecificShadowfiendValues(TRB.Data.snapshotData.shadowfiend)

		if specId == 3 then
			UpdateSpecificShadowfiendValues(TRB.Data.snapshotData.shadowfiendTier30)
		end
		
		---@diagnostic disable-next-line: redundant-parameter
		if specId == 2 and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.shadowfiend) then
			TRB.Data.snapshotData.shadowfiend.onCooldown = not (GetSpellCooldown(TRB.Data.spells.shadowfiend.id) == 0)
		elseif specId == 3 then
			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.mindbender) then
				TRB.Data.snapshotData.shadowfiend.onCooldown = not (GetSpellCooldown(TRB.Data.spells.mindbender.id) == 0)
			else
				TRB.Data.snapshotData.shadowfiend.onCooldown = not (GetSpellCooldown(TRB.Data.spells.shadowfiend.id) == 0)
			end
			
			if TRB.Data.snapshotData.devouredDespair.isActive and TRB.Data.snapshotData.devouredDespair.endTime ~= nil and TRB.Data.snapshotData.devouredDespair.endTime > currentTime then
				_, _, _, _, TRB.Data.snapshotData.devouredDespair.duration, TRB.Data.snapshotData.devouredDespair.endTime, _, _, _, TRB.Data.snapshotData.devouredDespair.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.devouredDespair.id)
				TRB.Data.snapshotData.devouredDespair.ticks = TRB.Functions.Number:RoundTo(TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.devouredDespair), 0, "ceil")
				TRB.Data.snapshotData.devouredDespair.resourceRaw = TRB.Data.snapshotData.devouredDespair.ticks * TRB.Data.spells.devouredDespair.insanity
				TRB.Data.snapshotData.devouredDespair.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.devouredDespair.resourceRaw)
			else
				TRB.Data.snapshotData.devouredDespair.resourceRaw = 0
				TRB.Data.snapshotData.devouredDespair.resourceFinal = 0
				TRB.Data.snapshotData.devouredDespair.isActive = false
				TRB.Data.snapshotData.devouredDespair.endTime = nil
				TRB.Data.snapshotData.devouredDespair.spellId = nil
				TRB.Data.snapshotData.devouredDespair.duration = 0
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
		if TRB.Functions.Table:Length(TRB.Data.snapshotData.voidTendrils.activeList) > 0 then
			for vtGuid,v in pairs(TRB.Data.snapshotData.voidTendrils.activeList) do
				if TRB.Data.snapshotData.voidTendrils.activeList[vtGuid] ~= nil and TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].startTime ~= nil then
					local endTime = TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].startTime + TRB.Data.spells.lashOfInsanity_Tendril.duration
					local timeRemaining = endTime - currentTime

					if timeRemaining < 0 then
						RemoveVoidTendril(vtGuid)
					else
						if TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].type == "Lasher" then
							if TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].tickTime ~= nil and currentTime > (TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].tickTime + 5) then
								TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].targetsHit = 0
							end

							local nextTick = TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Lasher.tickDuration

							if nextTick < currentTime then
								nextTick = currentTime --There should be a tick. ANY second now. Maybe.
								totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + 1
							end
							-- NOTE: Might need to be math.floor()
							local ticksRemaining = math.ceil((endTime - nextTick) / TRB.Data.spells.lashOfInsanity_Lasher.tickDuration)

							totalInsanity_Lasher = totalInsanity_Lasher + (ticksRemaining * TRB.Data.spells.lashOfInsanity_Lasher.insanity)
							totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + ticksRemaining
						else
							local nextTick = TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Tendril.tickDuration

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

		TRB.Data.snapshotData.voidTendrils.maxTicksRemaining = totalTicksRemaining_Tendril + totalTicksRemaining_Lasher
		TRB.Data.snapshotData.voidTendrils.numberActive = totalActive
		TRB.Data.snapshotData.voidTendrils.resourceRaw = totalInsanity_Tendril + totalInsanity_Lasher
		-- Fortress of the Mind does not apply but other Insanity boosting effects do.
		TRB.Data.snapshotData.voidTendrils.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.voidTendrils.resourceRaw)
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
			if forceCleanup or
				TRB.Data.snapshotData.symbolOfHope.endTime == nil or
				currentTime > TRB.Data.snapshotData.symbolOfHope.endTime or
				currentTime > TRB.Data.snapshotData.symbolOfHope.firstTickTime + TRB.Data.spells.symbolOfHope.duration or
				currentTime > TRB.Data.snapshotData.symbolOfHope.firstTickTime + (TRB.Data.spells.symbolOfHope.ticks * TRB.Data.snapshotData.symbolOfHope.tickRate)
				then
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

	local function UpdatePotionOfChilledClarity()
		local currentTime = GetTime()

		if TRB.Data.snapshotData.potionOfChilledClarity.endTime ~= nil and currentTime > TRB.Data.snapshotData.potionOfChilledClarity.endTime then
			TRB.Data.snapshotData.potionOfChilledClarity.endTime = nil
			TRB.Data.snapshotData.potionOfChilledClarity.duration = 0
			TRB.Data.snapshotData.potionOfChilledClarity.remainingTime = 0
			TRB.Data.snapshotData.potionOfChilledClarity.mana = 0
			TRB.Data.snapshotData.audio.potionOfChilledClarityCue = false
		else
			TRB.Data.snapshotData.potionOfChilledClarity.remainingTime = GetPotionOfChilledClarityRemainingTime()
			TRB.Data.snapshotData.potionOfChilledClarity.mana = TRB.Data.snapshotData.potionOfChilledClarity.remainingTime * TRB.Data.snapshotData.manaRegen
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
		UpdateShadowfiendValues()

		local currentTime = GetTime()
		local _

		if TRB.Data.snapshotData.apotheosis.startTime ~= nil and currentTime > (TRB.Data.snapshotData.apotheosis.startTime + TRB.Data.snapshotData.apotheosis.duration) then
			TRB.Data.snapshotData.apotheosis.startTime = nil
			TRB.Data.snapshotData.apotheosis.duration = 0
			TRB.Data.snapshotData.apotheosis.remainingTime = 0
		else
			TRB.Data.snapshotData.apotheosis.remainingTime = GetApotheosisRemainingTime()
		end

		if TRB.Data.snapshotData.holyWordSerenity.startTime ~= nil then
---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.holyWordSerenity.startTime, TRB.Data.snapshotData.holyWordSerenity.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSerenity.id)
			
			if TRB.Data.snapshotData.holyWordSerenity.startTime == 0 then
				TRB.Data.snapshotData.holyWordSerenity.startTime = nil
			end
		end

		if TRB.Data.snapshotData.holyWordSanctify.startTime ~= nil then
---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.holyWordSanctify.startTime, TRB.Data.snapshotData.holyWordSanctify.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSanctify.id)
			
			if TRB.Data.snapshotData.holyWordSanctify.startTime == 0 then
				TRB.Data.snapshotData.holyWordSanctify.startTime = nil
			end
		end

		if TRB.Data.snapshotData.holyWordChastise.startTime ~= nil then
---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.holyWordChastise.startTime, TRB.Data.snapshotData.holyWordChastise.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordChastise.id)

			if TRB.Data.snapshotData.holyWordChastise.startTime == 0 then
				TRB.Data.snapshotData.holyWordChastise.startTime = nil
			end
		end

		_, _, _, _, TRB.Data.snapshotData.resonantWords.duration, TRB.Data.snapshotData.resonantWords.endTime, _, _, _, TRB.Data.snapshotData.resonantWords.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.resonantWords.id)
		TRB.Data.snapshotData.resonantWords.remainingTime = GetResonantWordsRemainingTime()

		_, _, TRB.Data.snapshotData.lightweaver.stacks, _, TRB.Data.snapshotData.lightweaver.duration, TRB.Data.snapshotData.lightweaver.endTime, _, _, _, TRB.Data.snapshotData.lightweaver.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.lightweaver.id)
		TRB.Data.snapshotData.lightweaver.remainingTime = GetLightweaverRemainingTime()

		_, _, TRB.Data.snapshotData.surgeOfLight.stacks, _, TRB.Data.snapshotData.surgeOfLight.duration, TRB.Data.snapshotData.surgeOfLight.endTime, _, _, _, TRB.Data.snapshotData.surgeOfLight.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.surgeOfLight.id)
		TRB.Data.snapshotData.surgeOfLight.remainingTime = GetSurgeOfLightRemainingTime()

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
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPain then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.shadowWordPain.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Shadow()
		UpdateSnapshot()
		UpdateShadowfiendValues()
		UpdateExternalCallToTheVoidValues()

		local currentTime = GetTime()
		local _

		
		if TRB.Data.snapshotData.voidform.startTime ~= nil and currentTime > (TRB.Data.snapshotData.voidform.startTime + TRB.Data.snapshotData.voidform.duration) then
			TRB.Data.snapshotData.voidform.startTime = nil
			TRB.Data.snapshotData.voidform.duration = 0
			TRB.Data.snapshotData.voidform.remainingTime = 0
		else
			_, _, _, _, TRB.Data.snapshotData.voidform.duration, TRB.Data.snapshotData.voidform.endTime, _, _, _, TRB.Data.snapshotData.voidform.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.voidform.id)
			TRB.Data.snapshotData.voidform.remainingTime = GetVoidformRemainingTime()
		end

		if TRB.Data.snapshotData.darkAscension.startTime ~= nil and currentTime > (TRB.Data.snapshotData.darkAscension.startTime + TRB.Data.snapshotData.darkAscension.duration) then
			TRB.Data.snapshotData.darkAscension.startTime = nil
			TRB.Data.snapshotData.darkAscension.duration = 0
			TRB.Data.snapshotData.darkAscension.remainingTime = 0
		else
			TRB.Data.snapshotData.darkAscension.remainingTime = GetDarkAscensionRemainingTime()
		end

		if TRB.Data.snapshotData.mindFlayInsanity.endTime ~= nil and currentTime > (TRB.Data.snapshotData.mindFlayInsanity.endTime) then
			TRB.Data.snapshotData.mindFlayInsanity.endTime = nil
			TRB.Data.snapshotData.mindFlayInsanity.duration = 0
			TRB.Data.snapshotData.mindFlayInsanity.spellId = nil
		else
			
		end

		if TRB.Data.snapshotData.mindDevourer.endTime ~= nil and currentTime > (TRB.Data.snapshotData.mindDevourer.endTime) then
			TRB.Data.snapshotData.mindDevourer.endTime = nil
			TRB.Data.snapshotData.mindDevourer.duration = 0
			TRB.Data.snapshotData.mindDevourer.spellId = nil
		end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPain then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.shadowWordPain.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouch then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.vampiricTouch.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].vampiricTouchRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].devouringPlague then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.devouringPlague.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].devouringPlagueRemaining = expiration - currentTime
				end
			end
		end

		TRB.Data.snapshotData.mindBlast.charges, TRB.Data.snapshotData.mindBlast.maxCharges, TRB.Data.snapshotData.mindBlast.startTime, TRB.Data.snapshotData.mindBlast.duration, _ = GetSpellCharges(TRB.Data.spells.mindBlast.id)
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.priest

		if specId == 2 then
			local specSettings = classSettings.holy
			UpdateSnapshot_Holy()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					if TRB.Data.snapshotData.lightweaver.remainingTime ~= nil and TRB.Data.snapshotData.lightweaver.remainingTime > 0 then
						if specSettings.colors.bar.lightweaverBorderChange then
							barBorderColor = specSettings.colors.bar.lightweaver
						end

						if specSettings.audio.lightweaver.enabled and TRB.Data.snapshotData.audio.lightweaverCue == false then
							TRB.Data.snapshotData.audio.lightweaverCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.lightweaver.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.lightweaverCue = false
					end

					if TRB.Data.snapshotData.resonantWords.remainingTime ~= nil and TRB.Data.snapshotData.resonantWords.remainingTime > 0 then
						if specSettings.colors.bar.resonantWordsBorderChange then
							barBorderColor = specSettings.colors.bar.resonantWords
						end

						if specSettings.audio.resonantWords.enabled and TRB.Data.snapshotData.audio.resonantWordsCue == false then
							TRB.Data.snapshotData.audio.resonantWordsCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.resonantWords.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.resonantWordsCue = false
					end

					if TRB.Data.snapshotData.surgeOfLight.stacks == 1 then
						if specSettings.colors.bar.surgeOfLightBorderChange1 then
							barBorderColor = specSettings.colors.bar.surgeOfLight1
						end

						if specSettings.audio.surgeOfLight.enabled and not TRB.Data.snapshotData.audio.surgeOfLightCue then
							TRB.Data.snapshotData.audio.surgeOfLightCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.surgeOfLight.sound, coreSettings.audio.channel.channel)
						end
					end

					if TRB.Data.snapshotData.surgeOfLight.stacks == 2 then
						if specSettings.colors.bar.surgeOfLightBorderChange2 then
							barBorderColor = specSettings.colors.bar.surgeOfLight2
						end

						if specSettings.audio.surgeOfLight2.enabled and not TRB.Data.snapshotData.audio.surgeOfLight2Cue then
							TRB.Data.snapshotData.audio.surgeOfLight2Cue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.surgeOfLight2.sound, coreSettings.audio.channel.channel)
						end
					end

					if TRB.Data.spells.potionOfChilledClarity.isActive then
						if specSettings.colors.bar.potionOfChilledClarityBorderChange then
							barBorderColor = specSettings.colors.bar.potionOfChilledClarity
						end
					elseif TRB.Data.spells.innervate.isActive then
						if specSettings.colors.bar.innervateBorderChange then
							barBorderColor = specSettings.colors.bar.innervate
						end

						if specSettings.audio.innervate.enabled and TRB.Data.snapshotData.audio.innervateCue == false then
							TRB.Data.snapshotData.audio.innervateCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
						end
					end
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentMana)

					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = currentMana + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentMana
					end

					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
					
					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, TRB.Data.snapshotData.potion, TRB.Data.snapshotData.conjuredChillglobe, TRB.Data.character, resourceFrame, CalculateManaGain)

					if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.shadowfiend) and not TRB.Data.snapshotData.shadowfiend.isActive and TRB.Data.snapshotData.shadowfiend.resourceFinal == 0 then
						local shadowfiendThresholdColor = specSettings.colors.threshold.over
						if specSettings.thresholds.shadowfiend.enabled and (TRB.Data.snapshotData.shadowfiend.remainingTime == 0 or specSettings.thresholds.shadowfiend.cooldown) then
							local haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
							local shadowfiendMana = swingsRemaining * TRB.Data.spells.shadowfiend.manaPercent * TRB.Data.character.maxResource

							if TRB.Data.snapshotData.shadowfiend.remainingTime > 0 then
								shadowfiendThresholdColor = specSettings.colors.threshold.unusable
							end

							if not haveTotem and shadowfiendMana > 0 and (castingBarValue + shadowfiendMana) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[8], resourceFrame, specSettings.thresholds.width, (castingBarValue + shadowfiendMana), TRB.Data.character.maxResource)
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
								resourceFrame.thresholds[8]:Show()

								if specSettings.thresholds.icons.showCooldown and TRB.Data.snapshotData.shadowfiend.remainingTime > 0 then
									resourceFrame.thresholds[8].icon.cooldown:SetCooldown(TRB.Data.snapshotData.shadowfiend.startTime, TRB.Data.snapshotData.shadowfiend.duration)
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
						if TRB.Data.snapshotData.channeledManaPotion.isActive then
							passiveValue = passiveValue + TRB.Data.snapshotData.channeledManaPotion.mana

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

						-- Old Wrathful Faerie threshold. TODO: remove
						TRB.Frames.passiveFrame.thresholds[2]:Hide()

						if TRB.Data.snapshotData.innervate.mana > 0 or TRB.Data.snapshotData.potionOfChilledClarity.mana > 0 then
							passiveValue = passiveValue + math.max(TRB.Data.snapshotData.innervate.mana, TRB.Data.snapshotData.potionOfChilledClarity.mana)

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

						if TRB.Data.snapshotData.symbolOfHope.resourceFinal > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.symbolOfHope.resourceFinal

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

						if TRB.Data.snapshotData.manaTideTotem.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.manaTideTotem.mana

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

						if TRB.Data.snapshotData.shadowfiend.resourceFinal > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.shadowfiend.resourceFinal

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
					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local resourceBarColor = nil

					if TRB.Data.snapshotData.casting.spellKey ~= nil then
						if TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey] ~= nil and
							TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey ~= nil and
							TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction ~= nil and
							TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction >= 0 and
							TRB.Functions.Talent:IsTalentActive(TRB.Data.spells[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey]) then

							local castTimeRemains = TRB.Data.snapshotData.casting.endTime - currentTime
							local holyWordCooldownRemaining = GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey])

							if (holyWordCooldownRemaining - CalculateHolyWordCooldown(TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction, TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].id) - castTimeRemains) <= 0 and specSettings.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey .. "Enabled"] then
								resourceBarColor = specSettings.colors.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey]
							end
						end
					end

					if TRB.Data.snapshotData.apotheosis.spellId and resourceBarColor == nil then
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

						if useEndOfApotheosisColor and TRB.Data.snapshotData.apotheosis.remainingTime <= timeThreshold then
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

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentInsanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					local barBorderColor = specSettings.colors.bar.border
					local barColor = specSettings.colors.bar.base

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") then
						barBorderColor = specSettings.colors.bar.borderOvercap
						if specSettings.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						barBorderColor = specSettings.colors.bar.border
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					if specSettings.colors.bar.mindFlayInsanityBorderChange and TRB.Functions.Class:IsValidVariableForSpec("$mfiTime") then
						barBorderColor = specSettings.colors.bar.borderMindFlayInsanity
					end
					
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = TRB.Data.snapshotData.casting.resourceFinal + currentInsanity
					else
						castingBarValue = currentInsanity
					end

					if specSettings.bar.showPassive and
						(TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.auspiciousSpirits) or
						(TRB.Data.snapshotData.shadowfiend.resourceFinal + TRB.Data.snapshotData.shadowfiendTier30.resourceFinal + TRB.Data.snapshotData.devouredDespair.resourceFinal) > 0 or
						TRB.Data.snapshotData.voidTendrils.resourceFinal > 0) then
						passiveValue = ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.shadowfiend.resourceFinal + TRB.Data.snapshotData.shadowfiendTier30.resourceFinal + TRB.Data.snapshotData.devouredDespair.resourceFinal + TRB.Data.snapshotData.voidTendrils.resourceFinal)
						if (TRB.Data.snapshotData.shadowfiend.resourceFinal + TRB.Data.snapshotData.shadowfiendTier30.resourceFinal + TRB.Data.snapshotData.devouredDespair.resourceFinal) > 0 and (castingBarValue + (TRB.Data.snapshotData.shadowfiend.resourceFinal + TRB.Data.snapshotData.shadowfiendTier30.resourceFinal + TRB.Data.snapshotData.devouredDespair.resourceFinal)) < TRB.Data.character.maxResource then
							TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, specSettings.thresholds.width, (castingBarValue + (TRB.Data.snapshotData.shadowfiend.resourceFinal + TRB.Data.snapshotData.shadowfiendTier30.resourceFinal + TRB.Data.snapshotData.devouredDespair.resourceFinal)), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
							TRB.Frames.passiveFrame.thresholds[1]:Show()
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end

						-- Old Wrathful Faerie threshold. TODO: remove
						TRB.Frames.passiveFrame.thresholds[2]:Hide()
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						TRB.Frames.passiveFrame.thresholds[2]:Hide()
						passiveValue = 0
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.insanity ~= nil and spell.insanity < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							pairOffset = (spell.thresholdId - 1) * 3
							local resourceAmount = spell.insanity
							local currentResource = currentInsanity
							--TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.devouringPlague.id then
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.mindsEye) then
										resourceAmount = resourceAmount - TRB.Data.spells.mindsEye.insanity
									end

									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.distortedReality) then
										resourceAmount = resourceAmount - TRB.Data.spells.distortedReality.insanity
									end

									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif TRB.Data.snapshotData.mindDevourer.endTime ~= nil and currentTime < TRB.Data.snapshotData.mindDevourer.endTime then
										thresholdColor = specSettings.colors.threshold.over
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
							elseif spell.isPvp and not TRB.Data.character.isPvp then
								showThreshold = false
							elseif spell.hasCooldown then
								if (TRB.Data.snapshotData[spell.settingKey].charges == nil or TRB.Data.snapshotData[spell.settingKey].charges == 0) and
									(TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration)) then
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

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshotData[spell.settingKey], specSettings)
						end
					end

					if TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold or TRB.Data.spells.mindDevourer.isActive then
						if specSettings.colors.bar.flashEnabled then
							TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if TRB.Data.spells.mindDevourer.isActive and specSettings.audio.mdProc.enabled and TRB.Data.snapshotData.audio.playedMdCue == false then
							TRB.Data.snapshotData.audio.playedDpCue = true
							TRB.Data.snapshotData.audio.playedMdCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.mdProc.sound, coreSettings.audio.channel.channel)
						elseif specSettings.audio.dpReady.enabled and TRB.Data.snapshotData.audio.playedDpCue == false then
							TRB.Data.snapshotData.audio.playedDpCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.dpReady.sound, coreSettings.audio.channel.channel)
						end
					else
						barContainerFrame:SetAlpha(1.0)
						TRB.Data.snapshotData.audio.playedDpCue = false
						TRB.Data.snapshotData.audio.playedMdCue = false
					end

					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < currentInsanity then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
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

					if TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.devouringPlagueUsableCasting, true))
					else
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					end

					if specSettings.colors.bar.instantMindBlast.enabled and TRB.Data.snapshotData.mindBlast.charges > 0 and TRB.Data.snapshotData.shadowyInsight.duration > 0 then
						barColor = specSettings.colors.bar.instantMindBlast.color
					elseif TRB.Data.snapshotData.voidform.remainingTime > 0 or TRB.Data.snapshotData.darkAscension.remainingTime > 0 then
						local timeLeft = TRB.Data.snapshotData.voidform.remainingTime
						if TRB.Data.snapshotData.darkAscension.remainingTime > 0 then
							timeLeft = TRB.Data.snapshotData.darkAscension.remainingTime
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
						elseif TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							barColor = specSettings.colors.bar.devouringPlagueUsable
						else
							barColor = specSettings.colors.bar.inVoidform
						end
					else
						if TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
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
		--local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local currentTime, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, auraType = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			local settings

			if specId == 2 then
				settings = TRB.Data.settings.priest.holy
			elseif specId == 3 then
				settings = TRB.Data.settings.priest.shadow
			end

			if destGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "holy" then -- Let's check raid effect mana stuff
					if type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.symbolOfHope.tickId then
						TRB.Data.snapshotData.symbolOfHope.isActive = true
						if TRB.Data.snapshotData.symbolOfHope.firstTickTime == nil then
							TRB.Data.snapshotData.symbolOfHope.firstTickTime = currentTime
							TRB.Data.snapshotData.symbolOfHope.previousTickTime = currentTime
							TRB.Data.snapshotData.symbolOfHope.ticksRemaining = TRB.Data.spells.symbolOfHope.ticks
							if sourceGUID == TRB.Data.character.guid then
								TRB.Data.snapshotData.symbolOfHope.endTime = currentTime + (TRB.Data.spells.symbolOfHope.duration / (1.5 / TRB.Functions.Character:GetCurrentGCDTime(true)))
								TRB.Data.snapshotData.symbolOfHope.tickRate = (TRB.Data.spells.symbolOfHope.duration / TRB.Data.spells.symbolOfHope.ticks) / (1.5 / TRB.Functions.Character:GetCurrentGCDTime(true))
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
							_, _, _, _, TRB.Data.snapshotData.innervate.duration, TRB.Data.snapshotData.innervate.endTime, _, _, _, TRB.Data.snapshotData.innervate.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.innervate.id)
							TRB.Data.snapshotData.innervate.modifier = 0
							TRB.Data.snapshotData.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.innervate.isActive = false
							TRB.Data.snapshotData.innervate.spellId = nil
							TRB.Data.snapshotData.innervate.duration = 0
							TRB.Data.snapshotData.innervate.endTime = nil
							TRB.Data.snapshotData.innervate.modifier = 1
							TRB.Data.snapshotData.audio.innervateCue = false
						end
					elseif spellId == TRB.Data.spells.potionOfChilledClarity.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.potionOfChilledClarity.isActive = true
							_, _, _, _, TRB.Data.snapshotData.potionOfChilledClarity.duration, TRB.Data.snapshotData.potionOfChilledClarity.endTime, _, _, _, TRB.Data.snapshotData.potionOfChilledClarity.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.potionOfChilledClarity.id)
							TRB.Data.snapshotData.potionOfChilledClarity.modifier = 0
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.potionOfChilledClarity.isActive = false
							TRB.Data.snapshotData.potionOfChilledClarity.spellId = nil
							TRB.Data.snapshotData.potionOfChilledClarity.duration = 0
							TRB.Data.snapshotData.potionOfChilledClarity.endTime = nil
							TRB.Data.snapshotData.potionOfChilledClarity.modifier = 1
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
					elseif settings.shadowfiend.enabled and type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.shadowfiend.energizeId and sourceName == TRB.Data.spells.shadowfiend.name then
						TRB.Data.snapshotData.shadowfiend.swingTime = currentTime
						TRB.Data.snapshotData.shadowfiend.startTime, TRB.Data.snapshotData.shadowfiend.duration, _, _ = GetSpellCooldown(TRB.Data.spells.shadowfiend.id)
						triggerUpdate = true
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
					if settings.mindbender.enabled and type == "SPELL_ENERGIZE" and (spellId == TRB.Data.spells.mindbender.energizeId or spellId == TRB.Data.spells.shadowfiend.energizeId) and sourceName == TRB.Data.spells.shadowfiend.name then
						if sourceGUID == TRB.Data.snapshotData.shadowfiend.guid then
							TRB.Data.snapshotData.shadowfiend.swingTime = currentTime
						
							if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.mindbender) then
								TRB.Data.snapshotData.shadowfiend.startTime, TRB.Data.snapshotData.shadowfiend.duration, _, _ = GetSpellCooldown(TRB.Data.spells.mindbender.id)
							else
								TRB.Data.snapshotData.shadowfiend.startTime, TRB.Data.snapshotData.shadowfiend.duration, _, _ = GetSpellCooldown(TRB.Data.spells.shadowfiend.id)
							end
						elseif sourceGUID == TRB.Data.snapshotData.shadowfiendTier30.guid then
							TRB.Data.snapshotData.shadowfiendTier30.swingTime = currentTime
						end
						triggerUpdate = true
					end
				end
			end
			
			if sourceGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "holy" then
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
					elseif spellId == TRB.Data.spells.apotheosis.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.apotheosis.isActive = true
							_, _, _, _, TRB.Data.snapshotData.apotheosis.duration, TRB.Data.snapshotData.apotheosis.endTime, _, _, _, TRB.Data.snapshotData.apotheosis.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.apotheosis.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.apotheosis.isActive = false
							TRB.Data.snapshotData.apotheosis.spellId = nil
							TRB.Data.snapshotData.apotheosis.duration = 0
							TRB.Data.snapshotData.apotheosis.endTime = nil
						end
					elseif spellId == TRB.Data.spells.surgeOfLight.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.surgeOfLight.isActive = true
							_, _, TRB.Data.snapshotData.surgeOfLight.stacks, _, TRB.Data.snapshotData.surgeOfLight.duration, TRB.Data.snapshotData.surgeOfLight.endTime, _, _, _, TRB.Data.snapshotData.surgeOfLight.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.surgeOfLight.id)
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
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.holyWordSerenity.startTime, TRB.Data.snapshotData.holyWordSerenity.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSerenity.id)
						end
					elseif spellId == TRB.Data.spells.holyWordSanctify.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Sanctify
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.holyWordSanctify.startTime, TRB.Data.snapshotData.holyWordSanctify.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordSanctify.id)
						end
					elseif spellId == TRB.Data.spells.holyWordChastise.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Chastise
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.holyWordChastise.startTime, TRB.Data.snapshotData.holyWordChastise.duration, _, _ = GetSpellCooldown(TRB.Data.spells.holyWordChastise.id)
						end
					elseif spellId == TRB.Data.spells.divineConversation.id then
						if type == "SPELL_AURA_APPLIED" then -- Gained buff
							TRB.Data.snapshotData.divineConversation.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.divineConversation.isActive = false
						end
					elseif spellId == TRB.Data.spells.prayerFocus.id then
						if type == "SPELL_AURA_APPLIED" then -- Gained buff
							TRB.Data.snapshotData.prayerFocus.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.prayerFocus.isActive = false
						end
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
					if spellId == TRB.Data.spells.voidform.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.voidform.isActive = true
							_, _, _, _, TRB.Data.snapshotData.voidform.duration, TRB.Data.snapshotData.voidform.endTime, _, _, _, TRB.Data.snapshotData.voidform.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.voidform.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.voidform.isActive = false
							TRB.Data.snapshotData.voidform.spellId = nil
							TRB.Data.snapshotData.voidform.duration = 0
							TRB.Data.snapshotData.voidform.endTime = nil
						end
					elseif spellId == TRB.Data.spells.darkAscension.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.darkAscension.isActive = true
							_, _, _, _, TRB.Data.snapshotData.darkAscension.duration, TRB.Data.snapshotData.darkAscension.endTime, _, _, _, TRB.Data.snapshotData.darkAscension.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.darkAscension.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.darkAscension.isActive = false
							TRB.Data.snapshotData.darkAscension.spellId = nil
							TRB.Data.snapshotData.darkAscension.duration = 0
							TRB.Data.snapshotData.darkAscension.endTime = nil
						end
					elseif spellId == TRB.Data.spells.vampiricTouch.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
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
							end
						end
					elseif spellId == TRB.Data.spells.devouringPlague.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								TRB.Data.snapshotData.weakeningReality.lastDevouringPlagueCastTime = currentTime
							end

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
							end
						end
					elseif settings.auspiciousSpiritsTracker and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.auspiciousSpirits) and spellId == TRB.Data.spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
						for guid, _ in pairs(TRB.Data.snapshotData.targetData.targets) do
							if TRB.Data.snapshotData.targetData.targets[guid].vampiricTouch then
								TRB.Data.snapshotData.targetData.targets[guid].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[guid].auspiciousSpirits + 1
							end
							TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits + 1
						end
						triggerUpdate = true
					elseif settings.auspiciousSpiritsTracker and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.auspiciousSpirits) and spellId == TRB.Data.spells.auspiciousSpirits.idImpact and (type == "SPELL_DAMAGE" or type == "SPELL_MISSED" or type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
						if TRB.Functions.Target:CheckTargetExists(destGUID) then
							TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits - 1
							TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits - 1
						end
						triggerUpdate = true
					elseif type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.shadowCrash.id then
						triggerUpdate = true
					elseif spellId == TRB.Data.spells.mindDevourer.buffId then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.mindDevourer.isActive = true
							_, _, _, _, TRB.Data.snapshotData.mindDevourer.duration, TRB.Data.snapshotData.mindDevourer.endTime, _, _, _, TRB.Data.snapshotData.mindDevourer.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.mindDevourer.buffId)
						elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
							if type == "SPELL_AURA_REMOVED" and TRB.Data.snapshotData.mindDevourer.endTime ~= nil and TRB.Data.snapshotData.mindDevourer.endTime > currentTime then
								TRB.Data.snapshotData.mindDevourer.consumedTime = currentTime
							end
							TRB.Data.spells.mindDevourer.isActive = false
							TRB.Data.snapshotData.mindDevourer.spellId = nil
							TRB.Data.snapshotData.mindDevourer.duration = 0
							TRB.Data.snapshotData.mindDevourer.endTime = nil
						end
					elseif spellId == TRB.Data.spells.devouredDespair.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.snapshotData.devouredDespair.isActive = true
							_, _, _, _, TRB.Data.snapshotData.devouredDespair.duration, TRB.Data.snapshotData.devouredDespair.endTime, _, _, _, TRB.Data.snapshotData.devouredDespair.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.devouredDespair.id)
						elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
							TRB.Data.snapshotData.devouredDespair.isActive = false
							TRB.Data.snapshotData.devouredDespair.spellId = nil
							TRB.Data.snapshotData.devouredDespair.duration = 0
							TRB.Data.snapshotData.devouredDespair.endTime = nil
						end
					elseif spellId == TRB.Data.spells.mindFlayInsanity.buffId or spellId == TRB.Data.spells.mindSpikeInsanity.buffId then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.mindFlayInsanity.isActive = true
							_, _, _, _, TRB.Data.snapshotData.mindFlayInsanity.duration, TRB.Data.snapshotData.mindFlayInsanity.endTime, _, _, _, TRB.Data.snapshotData.mindFlayInsanity.spellId = TRB.Functions.Aura:FindBuffById(spellId)
						elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
							TRB.Data.spells.mindFlayInsanity.isActive = false
							TRB.Data.snapshotData.mindFlayInsanity.spellId = nil
							TRB.Data.snapshotData.mindFlayInsanity.duration = 0
							TRB.Data.snapshotData.mindFlayInsanity.endTime = nil
						end
					elseif spellId == TRB.Data.spells.twistOfFate.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.twistOfFate.isActive = true
							_, _, _, _, TRB.Data.snapshotData.twistOfFate.duration, TRB.Data.snapshotData.twistOfFate.endTime, _, _, _, TRB.Data.snapshotData.twistOfFate.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.twistOfFate.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.twistOfFate.isActive = false
							TRB.Data.snapshotData.twistOfFate.spellId = nil
							TRB.Data.snapshotData.twistOfFate.duration = 0
							TRB.Data.snapshotData.twistOfFate.endTime = nil
						end
					elseif spellId == TRB.Data.spells.shadowyInsight.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.shadowyInsight.isActive = true
							_, _, _, _, TRB.Data.snapshotData.shadowyInsight.duration, TRB.Data.snapshotData.shadowyInsight.endTime, _, _, _, TRB.Data.snapshotData.shadowyInsight.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.shadowyInsight.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.shadowyInsight.isActive = false
							TRB.Data.snapshotData.shadowyInsight.spellId = nil
							TRB.Data.snapshotData.shadowyInsight.duration = 0
							TRB.Data.snapshotData.shadowyInsight.endTime = nil
						end
					elseif spellId == TRB.Data.spells.mindMelt.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.mindMelt.isActive = true
							_, _, TRB.Data.snapshotData.mindMelt.stacks, _, TRB.Data.snapshotData.mindMelt.duration, TRB.Data.snapshotData.mindMelt.endTime, _, _, _, TRB.Data.snapshotData.mindMelt.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.mindMelt.id)
						elseif type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
							--TRB.Data.snapshotData.audio.mindMelt2Cue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.mindMelt.isActive = false
							TRB.Data.snapshotData.mindMelt.spellId = nil
							TRB.Data.snapshotData.mindMelt.duration = 0
							TRB.Data.snapshotData.mindMelt.stacks = 0
							TRB.Data.snapshotData.mindMelt.endTime = nil
							TRB.Data.snapshotData.audio.mindMeltCue = false
							TRB.Data.snapshotData.audio.mindMelt2Cue = false
						end
					elseif spellId == TRB.Data.spells.weakeningReality.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" then
							TRB.Data.snapshotData.weakeningReality.stacks = TRB.Data.snapshotData.weakeningReality.stacks + 1							
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.weakeningReality.stacks = 0
						end
					elseif type == "SPELL_SUMMON" and settings.voidTendrilTracker and (spellId == TRB.Data.spells.idolOfCthun_Tendril.id or spellId == TRB.Data.spells.idolOfCthun_Lasher.id) then
						InitializeVoidTendril(destGUID)
						if spellId == TRB.Data.spells.idolOfCthun_Tendril.id then
							TRB.Data.snapshotData.voidTendrils.activeList[destGUID].type = "Tendril"
						elseif spellId == TRB.Data.spells.idolOfCthun_Lasher.id then
							TRB.Data.snapshotData.voidTendrils.activeList[destGUID].type = "Lasher"
							TRB.Data.snapshotData.voidTendrils.activeList[destGUID].targetsHit = 0
							TRB.Data.snapshotData.voidTendrils.activeList[destGUID].hasStruckTargets = true
						end

						TRB.Data.snapshotData.voidTendrils.numberActive = TRB.Data.snapshotData.voidTendrils.numberActive + 1
						TRB.Data.snapshotData.voidTendrils.maxTicksRemaining = TRB.Data.snapshotData.voidTendrils.maxTicksRemaining + TRB.Data.spells.lashOfInsanity_Tendril.ticks
						TRB.Data.snapshotData.voidTendrils.activeList[destGUID].startTime = currentTime
						TRB.Data.snapshotData.voidTendrils.activeList[destGUID].tickTime = currentTime
					elseif type == "SPELL_SUMMON" and settings.mindbender.enabled and (spellId == TRB.Data.spells.shadowfiend.id or spellId == TRB.Data.spells.mindbender.id) then
						local currentSf = TRB.Data.snapshotData.shadowfiend
						local totemId = 1
						if TRB.Data.snapshotData.weakeningReality.lastDevouringPlagueCastTime == currentTime then
							print("T30")
							currentSf = TRB.Data.snapshotData.shadowfiendTier30
							if TRB.Data.snapshotData.shadowfiend.totemId ~= nil and TRB.Data.snapshotData.shadowfiend.totemId == 1 then
								totemId = 2
							end
						else
							print("Ability")
							if TRB.Data.snapshotData.shadowfiendTier30.totemId ~= nil and TRB.Data.snapshotData.shadowfiendTier30.totemId == 1 then
								totemId = 2
							end
						end

						currentSf.guid = sourceGUID
						currentSf.totemId = totemId
						print(currentSf.guid, currentSf.totemId)
					elseif type == "SPELL_SUMMON" then
					print(spellId)
					end
				end

				-- Spec agnostic
				if spellId == TRB.Data.spells.shadowWordPain.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
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
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" and settings.voidTendrilTracker and (spellId == TRB.Data.spells.idolOfCthun_Tendril.idTick or spellId == TRB.Data.spells.idolOfCthun_Lasher.idTick) and CheckVoidTendrilExists(sourceGUID) then
				if spellId == TRB.Data.spells.idolOfCthun_Lasher.idTick and type == "SPELL_DAMAGE" then
					if currentTime > (TRB.Data.snapshotData.voidTendrils.activeList[sourceGUID].tickTime + 0.1) then --This is a new tick
						TRB.Data.snapshotData.voidTendrils.activeList[sourceGUID].targetsHit = 0
					end
					TRB.Data.snapshotData.voidTendrils.activeList[sourceGUID].targetsHit = TRB.Data.snapshotData.voidTendrils.activeList[sourceGUID].targetsHit + 1
					TRB.Data.snapshotData.voidTendrils.activeList[sourceGUID].tickTime = currentTime
					TRB.Data.snapshotData.voidTendrils.activeList[sourceGUID].hasStruckTargets = true
				else
					TRB.Data.snapshotData.voidTendrils.activeList[sourceGUID].tickTime = currentTime
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				TRB.Functions.Target:RemoveTarget(destGUID)
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

		if specId == 1 then
		elseif specId == 2 then
			TRB.Data.character.specName = "holy"
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
		elseif specId == 3 then
			TRB.Data.character.specName = "shadow"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity)

			TRB.Data.character.devouringPlagueThreshold = -TRB.Data.spells.devouringPlague.insanity
			
			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.mindsEye) then
				TRB.Data.character.devouringPlagueThreshold = TRB.Data.character.devouringPlagueThreshold + TRB.Data.spells.mindsEye.insanity
			end
			
			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.distortedReality) then
				TRB.Data.character.devouringPlagueThreshold = TRB.Data.character.devouringPlagueThreshold + TRB.Data.spells.distortedReality.insanity
			end

			TRB.Frames.resourceFrame.thresholds[2]:Hide()
			TRB.Frames.resourceFrame.thresholds[3]:Hide()
			TRB.Frames.resourceFrame.thresholds[4]:Hide()
			TRB.Frames.resourceFrame.thresholds[5]:Hide()
			TRB.Frames.resourceFrame.thresholds[6]:Hide()
			TRB.Frames.resourceFrame.thresholds[7]:Hide()
			TRB.Frames.resourceFrame.thresholds[8]:Hide()
			TRB.Frames.passiveFrame.thresholds[3]:Hide()
			TRB.Frames.passiveFrame.thresholds[4]:Hide()
			TRB.Frames.passiveFrame.thresholds[5]:Hide()
			TRB.Frames.passiveFrame.thresholds[6]:Hide()
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

	function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()

		if guid ~= nil and guid ~= "" then
			if not TRB.Functions.Target:CheckTargetExists(guid) then
				TRB.Functions.Target:InitializeTarget(guid)
				if specId == 2 then
					TRB.Data.snapshotData.targetData.targets[guid].shadowWordPain = false
					TRB.Data.snapshotData.targetData.targets[guid].shadowWordPainRemaining = 0
				elseif specId == 3 then
					TRB.Data.snapshotData.targetData.targets[guid].auspiciousSpirits = 0
					TRB.Data.snapshotData.targetData.targets[guid].shadowWordPain = false
					TRB.Data.snapshotData.targetData.targets[guid].shadowWordPainRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].vampiricTouch = false
					TRB.Data.snapshotData.targetData.targets[guid].vampiricTouchRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].devouringPlague = false
					TRB.Data.snapshotData.targetData.targets[guid].devouringPlagueRemaining = 0
				end
			end
			TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()
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
				if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") then
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
			elseif var == "$lightweaverTime" then
				if TRB.Data.snapshotData.lightweaver.remainingTime > 0 then
					valid = true
				end
			elseif var == "$lightweaverStacks" then
				if TRB.Data.snapshotData.lightweaver.remainingTime > 0 then
					valid = true
				end
			elseif var == "$rwTime" then
				if TRB.Data.snapshotData.resonantWords.remainingTime > 0 then
					valid = true
				end
			elseif var == "$innervateMana" then
				if TRB.Data.snapshotData.innervate.mana > 0 then
					valid = true
				end
			elseif var == "$innervateTime" then
				if TRB.Data.snapshotData.innervate.remainingTime > 0 then
					valid = true
				end
			elseif var == "$potionOfChilledClarityMana" then
				if TRB.Data.snapshotData.potionOfChilledClarity.mana > 0 then
					valid = true
				end
			elseif var == "$potionOfChilledClarityTime" then
				if TRB.Data.snapshotData.potionOfChilledClarity.remainingTime > 0 then
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
			elseif var == "$sfMana" then
				if TRB.Data.snapshotData.shadowfiend.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$sfGcds" then
				if TRB.Data.snapshotData.shadowfiend.remaining.gcds > 0 then
					valid = true
				end
			elseif var == "$sfSwings" then
				if TRB.Data.snapshotData.shadowfiend.remaining.swings > 0 then
					valid = true
				end
			elseif var == "$sfTime" then
				if TRB.Data.snapshotData.shadowfiend.remaining.time > 0 then
					valid = true
				end
			end
		elseif specId == 3 then
			if var == "$vfTime" then
				if (TRB.Data.snapshotData.voidform.remainingTime ~= nil and TRB.Data.snapshotData.voidform.remainingTime > 0) or
					(TRB.Data.snapshotData.darkAscension.remainingTime ~= nil and TRB.Data.snapshotData.darkAscension.remainingTime > 0) then
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
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) or
					(((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.shadowfiend.resourceRaw + TRB.Data.snapshotData.shadowfiendTier30.resourceRaw + TRB.Data.snapshotData.voidTendrils.resourceFinal) > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$insanityPlusCasting" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
				if ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.settings.priest.shadow.overcapThreshold then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$insanityPlusPassive" then
				if TRB.Data.snapshotData.resource > 0 or
					((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.shadowfiend.resourceRaw + TRB.Data.snapshotData.shadowfiendTier30.resourceRaw + TRB.Data.snapshotData.voidTendrils.resourceFinal) > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$passive" then
				if ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.shadowfiend.resourceRaw + TRB.Data.snapshotData.shadowfiendTier30.resourceRaw + TRB.Data.snapshotData.voidTendrils.resourceFinal) > 0 then
					valid = true
				end
			elseif var == "$mbInsanity" then
				if TRB.Data.snapshotData.shadowfiend.resourceRaw + TRB.Data.snapshotData.shadowfiendTier30.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$mbGcds" then
				if TRB.Data.snapshotData.shadowfiend.remaining.gcds > 0 then
					valid = true
				end
			elseif var == "$mbSwings" then
				if TRB.Data.snapshotData.shadowfiend.remaining.swings > 0 then
					valid = true
				end
			elseif var == "$mbTime" then
				if TRB.Data.snapshotData.shadowfiend.remaining.time > 0 then
					valid = true
				end
			elseif var == "$loiInsanity" then
				if TRB.Data.snapshotData.voidTendrils.resourceFinal > 0 then
					valid = true
				end
			elseif var == "$loiTicks" then
				if TRB.Data.snapshotData.voidTendrils.maxTicksRemaining > 0 then
					valid = true
				end
			elseif var == "$cttvEquipped" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and (TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.idolOfCthun) or TRB.Data.character.items.callToTheVoid == true) then
					valid = true
				end
			elseif var == "$ecttvCount" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and TRB.Data.snapshotData.voidTendrils.numberActive > 0 then
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
				if TRB.Data.spells.mindDevourer.isActive then
					valid = true
				end
			elseif var == "$mfiTime" then
				if TRB.Data.spells.mindFlayInsanity.isActive then
					valid = true
				end
			elseif var == "$tofTime" then
				if TRB.Data.snapshotData.twistOfFate.spellId ~= nil then
					valid = true
				end
			elseif var == "$siTime" then
				if TRB.Data.snapshotData.shadowyInsight.duration > 0 then
					valid = true
				end
			elseif var == "$mmTime" then
				if TRB.Data.snapshotData.mindMelt.duration > 0 then
					valid = true
				end
			elseif var == "$mmStacks" then
				if TRB.Data.snapshotData.mindMelt.stacks > 0 then
					valid = true
				end
			else
				valid = false
			end
		end

		-- Spec Agnostic
		if var == "$swpCount" then
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