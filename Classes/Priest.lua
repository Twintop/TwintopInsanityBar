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
	TRB.Frames.resourceFrame.thresholds[5] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[6] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[7] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)

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

	local function FillSpecCache()
		-- Holy
		specCache.holy.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
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
						bonusId = 2161,
						mana = 10877
					},
					normal = {
						bonusId = 2158,
						mana = 11735
					},
					heroic = {
						bonusId = 2159,
						mana = 14430
					},
					mythic = {
						bonusId = 2160,
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


			-- TODO: Pontiflex

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
			divineConversation = { -- T29 4P
				id = 363727,
				name = "",
				icon = "",
				reduction = 15,
				reductionPvp = 10
			},
			prayerFocus = { -- T30 2P
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
				mindbender = 0,
				deathAndMadness = 0,
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
			}
		}

		specCache.shadow.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			devouringPlagueThreshold = 50,
			mindSearThreshold = 50,
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
				insanity = 12,
				isTalent = false,
				baseline = true
			},


			-- Priest Talent Abilities			
			shadowfiend = {
				id = 34433,
				name = "",
				icon = "",
				insanity = 3,
				isTalent = true,
				baseline = true
			},
			deathAndMadness = {
				id = 321973,
				name = "",
				icon = "",
				insanity = 7.5,
				ticks = 4,
				duration = 4,
				isTalent = true
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
				isTalent = true
			},
			shadowyApparition = {
				id = 78203,
				name = "",
				icon = "",
				isTalent = true
			},
			darkVoid = {
				id = 263346,
				name = "",
				icon = "",
				insanity = 15,
				isTalent = true
			},
			auspiciousSpirits = {
				id = 155271,
				idSpawn = 147193,
				idImpact = 148859,
				insanity = 1,
				name = "",
				icon = "",
				isTalent = true
			},
			mindSear = {
				id = 48045,
				idTick = 49821,
				name = "",
				icon = "",
				texture = "",
				insanity = -50,
				insanityTick = -25,
				thresholdId = 2,
				settingKey = "mindSear",
				thresholdUsable = false,
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
			surgeOfDarkness = {
				id = 73510,
				name = "",
				icon = "",
				maxStacks = 3,
				isTalent = true
			},
			darkEvangelism = {
				id = 73510,
				name = "",
				icon = "",
				maxStacks = 5,
				isTalent = true
			},
			mindFlayInsanity = {
				id = 391403,
				name = "",
				icon = "",
				buffId = 391401,
				insanity = 4,
				isTalent = false,
				baseline = true
			},
			voidTorrent = {
				id = 263165,
				name = "",
				icon = "",
				insanity = 15,
				isTalent = true
			},
			shadowCrash = {
				id = 205385,
				name = "",
				icon = "",
				insanity = 15,
				isTalent = true
			},
			maddeningTouch = {
				id = 73510,
				name = "",
				icon = "",
				insanity = 1,
				perRank = 0.5,
				isTalent = true
			},
			piercingShadows = {
				id = 73510,
				name = "",
				icon = "",
				maxStacks = 5,
				isTalent = true
			},
			mindbender = {
				id = 34433,
				talentId = 200174,
				energizeId = 200010,
				name = "",
				icon = "",
				insanity = 3,
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
				insanity = 3,
				fotm = false,
				duration = 15,
				ticks = 15,
				tickDuration = 1, --This is NOT hasted
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
		specCache.shadow.snapshotData.devouredDespair = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0,
			insanity = 0
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
			consumedTime = nil,
			mindSearWithMindDevourer = false,
			mindSearChannelStartTime = nil
		}
		specCache.shadow.snapshotData.mindFlayInsanity = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshotData.twistOfFate = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.shadow.snapshotData.voidBolt = {
			lastSuccess = nil,
			flightTime = 1.0
		}
	end

	local function Setup_Holy()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "priest", "holy")
		TRB.Functions.LoadFromSpecCache(specCache.holy)
	end

	local function FillSpellData_Holy()
		Setup_Holy()
		local spells = TRB.Functions.FillSpellData(specCache.holy.spells)

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

			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = false },
			{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
			{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
			{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = false },

			{ variable = "#swp", icon = spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = true },
			{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = false },
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
			
			{ variable = "$mttMana", description = "Bonus passive mana regen while Mana Tide Totem is active", printInSettings = true, color = false },
			{ variable = "$mttTime", description = "Time left on Mana Tide Totem", printInSettings = true, color = false },

			{ variable = "$channeledMana", description = "Mana while channeling of Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTicks", description = "Number of ticks left channeling Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Frozen Focus", printInSettings = true, color = false },
			
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

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "priest", "shadow")
		TRB.Functions.LoadFromSpecCache(specCache.shadow)
	end

	local function FillSpellData_Shadow()
		Setup_Shadow()
		local spells = TRB.Functions.FillSpellData(specCache.shadow.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.shadow.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Insanity generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#vb", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = true },
			{ variable = "#voidBolt", icon = spells.voidBolt.icon, description = spells.voidBolt.name, printInSettings = false },
			{ variable = "#vf", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = true },
			{ variable = "#voidform", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = false },
																															  
			{ variable = "#mb", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = true },
			{ variable = "#mindBlast", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = false },
			{ variable = "#mfi", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = true },
			{ variable = "#mindFlayInsanity", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = false },
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
			
			{ variable = "#cthun", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = true },
			{ variable = "#idolOfCthun", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = false },
			{ variable = "#loi", icon = spells.idolOfCthun.icon, description = spells.idolOfCthun.name, printInSettings = false },
			
			{ variable = "#md", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = true },
			{ variable = "#massDispel", icon = spells.massDispel.icon, description = spells.massDispel.name, printInSettings = false }
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

			{ variable = "$damInsanity", description = "Insanity from Death and Madness", printInSettings = true, color = false },
			{ variable = "$damTicks", description = "Number of ticks left on Death and Madness", printInSettings = true, color = false },

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

			{ variable = "$vfTime", description = "Duration remaining of Voidform", printInSettings = true, color = false },

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
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.FillSpellDataManaCost(TRB.Data.spells)
			TRB.Data.character.isPvp = TRB.Functions.ArePvpTalentsActive()

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
		elseif specId == 3 then
			TRB.Data.character.specName = "shadow"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity)

			TRB.Data.character.devouringPlagueThreshold = -TRB.Data.spells.devouringPlague.insanity
			TRB.Data.character.mindSearThreshold = -TRB.Data.spells.mindSear.insanity

			-- Threshold lines
			if TRB.Data.settings.priest.shadow.thresholds.devouringPlague.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.devouringPlague) and TRB.Data.character.devouringPlagueThreshold < TRB.Data.character.maxResource then
				TRB.Frames.resourceFrame.thresholds[1]:Show()
				TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.priest.shadow.thresholds.width, TRB.Data.character.devouringPlagueThreshold, TRB.Data.character.maxResource)
			else
				TRB.Frames.resourceFrame.thresholds[1]:Hide()
			end

			if TRB.Data.settings.priest.shadow.thresholds.mindSear.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.mindSear) and TRB.Data.character.devouringPlagueThreshold < TRB.Data.character.maxResource then
				TRB.Frames.resourceFrame.thresholds[2]:Show()
				TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, resourceFrame.thresholds[2], resourceFrame, TRB.Data.settings.priest.shadow.thresholds.width, TRB.Data.character.mindSearThreshold, TRB.Data.character.maxResource)				
			else
				TRB.Frames.resourceFrame.thresholds[2]:Hide()
			end

			TRB.Frames.resourceFrame.thresholds[3]:Hide()
			TRB.Frames.resourceFrame.thresholds[4]:Hide()
			TRB.Frames.resourceFrame.thresholds[5]:Hide()
			TRB.Frames.resourceFrame.thresholds[6]:Hide()
			TRB.Frames.resourceFrame.thresholds[7]:Hide()
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

	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()

		if guid ~= nil and guid ~= "" then
			if not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
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
	TRB.Functions.InitializeTarget_Class = InitializeTarget

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
		end
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		if specId == 2 then
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.priest.holy)
		elseif specId == 3 then
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.devouringPlague.settingKey, TRB.Data.settings.priest.shadow)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.mindSear.settingKey, TRB.Data.settings.priest.shadow)
		end

		TRB.Functions.ConstructResourceBar(settings)
		if specId == 2 or specId == 3 then
			TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
		end
	end
	
	local function GetVoidformRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.voidform)
	end
	
	local function GetDarkAscensionRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.darkAscension)
	end
	
	local function GetApotheosisRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.apotheosis)
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

	local function GetResonantWordsRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.resonantWords)
	end

	local function GetLightweaverRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.lightweaver)
	end

	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.channeledManaPotion)
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

		if TRB.Functions.IsTalentActive(TRB.Data.spells.lightOfTheNaaru) then
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
				if IsValidVariableForSpec("$channeledMana") or
					IsValidVariableForSpec("$sohMana") or
					IsValidVariableForSpec("$innervateMana") or
					IsValidVariableForSpec("$mttMana") then
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
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id)) or
					(((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.voidTendrils.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity)) > 0) then
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
					((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.voidTendrils.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity)) > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id) then
					valid = true
				end
			elseif var == "$passive" then
				if ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.voidTendrils.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity)) > 0 then
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
			elseif var == "$loiInsanity" then
				if TRB.Data.snapshotData.voidTendrils.resourceFinal > 0 then
					valid = true
				end
			elseif var == "$loiTicks" then
				if TRB.Data.snapshotData.voidTendrils.maxTicksRemaining > 0 then
					valid = true
				end
			elseif var == "$cttvEquipped" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and (TRB.Functions.IsTalentActive(TRB.Data.spells.idolOfCthun) or TRB.Data.character.items.callToTheVoid == true) then
					valid = true
				end
			elseif var == "$ecttvCount" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and TRB.Data.snapshotData.voidTendrils.numberActive > 0 then
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
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

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
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.priest.holy.colors.text.passive, TRB.Functions.ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.channeledPotion = {
			mana = _channeledMana,
			ticks = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining or 0
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
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#amp"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
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
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		lookup["$solStacks"] = solStacks
		lookup["$solTime"] = solTime
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
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$solStacks"] = _solStacks
		lookupLogic["$solTime"] = _solTime
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
		local overcap = IsValidVariableForSpec("$overcap")

		local currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.currentInsanity
		local castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.castingInsanity

		local insanityThreshold = TRB.Data.character.devouringPlagueThreshold

		if TRB.Data.snapshotData.mindDevourer.spellId ~= nil then
			insanityThreshold = 0
		elseif TRB.Data.settings.priest.shadow.mindSearThreshold and TRB.Functions.IsTalentActive(TRB.Data.spells.mindSear) then
			insanityThreshold = TRB.Data.character.mindSearThreshold
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
		local currentInsanity = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.RoundTo(_currentInsanity, insanityPrecision, "floor"))
		--$casting
		local _castingInsanity = TRB.Data.snapshotData.casting.resourceFinal
		local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.RoundTo(_castingInsanity, insanityPrecision, "floor"))
		--$mbInsanity
		local _mbInsanity = TRB.Data.snapshotData.mindbender.resourceFinal
		local mbInsanity = string.format("%s", TRB.Functions.RoundTo(_mbInsanity, insanityPrecision, "floor"))
		--$mbGcds
		local _mbGcds = TRB.Data.snapshotData.mindbender.remaining.gcds
		local mbGcds = string.format("%.0f", _mbGcds)
		--$mbSwings
		local _mbSwings = TRB.Data.snapshotData.mindbender.remaining.swings
		local mbSwings = string.format("%.0f", _mbSwings)
		--$mbTime
		local _mbTime = TRB.Data.snapshotData.mindbender.remaining.time
		local mbTime = string.format("%.1f", _mbTime)
		--$loiInsanity
		local _loiInsanity = TRB.Data.snapshotData.voidTendrils.resourceFinal
		local loiInsanity = string.format("%s", TRB.Functions.RoundTo(_loiInsanity, insanityPrecision, "floor"))
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
		local asInsanity = string.format("%s", TRB.Functions.RoundTo(_asInsanity, insanityPrecision, "floor"))
		--$damInsanity
		local _damInsanity = CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity)
		local damInsanity = string.format("%s", TRB.Functions.RoundTo(_damInsanity, insanityPrecision, "floor"))
		--$damStacks
		local _damTicks = TRB.Data.snapshotData.deathAndMadness.ticksRemaining
		local damTicks = string.format("%.0f", _damTicks)
		--$passive
		local _passiveInsanity = _asInsanity + TRB.Data.snapshotData.mindbender.resourceFinal + _damInsanity + TRB.Data.snapshotData.voidTendrils.resourceFinal
		local passiveInsanity = string.format("|c%s%s|r", TRB.Data.settings.priest.shadow.colors.text.passiveInsanity, TRB.Functions.RoundTo(_passiveInsanity, insanityPrecision, "floor"))
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

		--$cttvEquipped
		local cttvEquipped = IsValidVariableForSpec("$cttvEquipped")

		----------------------------

		Global_TwintopResourceBar.voidform = {
		}
		Global_TwintopResourceBar.resource.passive = _passiveInsanity
		Global_TwintopResourceBar.resource.auspiciousSpirits = _asInsanity
		Global_TwintopResourceBar.resource.mindbender = TRB.Data.snapshotData.mindbender.resourceFinal or 0
		Global_TwintopResourceBar.resource.deathAndMadness = _damInsanity
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
		Global_TwintopResourceBar.mindbender = {
			insanity = TRB.Data.snapshotData.mindbender.resourceFinal or 0,
			gcds = TRB.Data.snapshotData.mindbender.remaining.gcds or 0,
			swings = TRB.Data.snapshotData.mindbender.remaining.swings or 0,
			time = TRB.Data.snapshotData.mindbender.remaining.time or 0
		}
		Global_TwintopResourceBar.deathAndMadness = {
			insanity = _damInsanity,
			ticks = TRB.Data.snapshotData.deathAndMadness.ticksRemaining or 0
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
		lookup["#ms"] = TRB.Data.spells.mindSear.icon
		lookup["#mindSear"] = TRB.Data.spells.mindSear.icon
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
		lookup["#md"] = TRB.Data.spells.massDispel.icon
		lookup["#massDispel"] = TRB.Data.spells.massDispel.icon
		lookup["#dam"] = TRB.Data.spells.deathAndMadness.icon
		lookup["#deathAndMadness"] = TRB.Data.spells.deathAndMadness.icon
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
		lookup["$damInsanity"] = damInsanity
		lookup["$damTicks"] = damTicks
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
		lookupLogic["$damInsanity"] = _damInsanity
		lookupLogic["$damTicks"] = _damTicks
		lookupLogic["$asCount"] = _asCount
		lookupLogic["$asInsanity"] = _asInsanity
		TRB.Data.lookupLogic = lookupLogic
	end

	local function UpdateCastingResourceFinal_Holy()
		-- Do nothing for now
		TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw * TRB.Data.snapshotData.innervate.modifier
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
						local manaCost = -TRB.Functions.GetSpellManaCost(spellId)

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
						elseif TRB.Functions.IsTalentActive(TRB.Data.spells.harmoniousApparatus) then
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
					elseif currentChannelId == TRB.Data.spells.mindFlayInsanity.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindFlayInsanity.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindFlayInsanity.insanity
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindFlayInsanity.icon
					elseif currentChannelId == TRB.Data.spells.mindSear.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindSear.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindSear.icon
						
						if TRB.Data.snapshotData.mindDevourer.consumedTime ~= nil then
							if math.abs(TRB.Data.snapshotData.mindDevourer.consumedTime - (currentChannelStartTime/1000)) < 0.3 then
								TRB.Data.snapshotData.mindDevourer.mindSearWithMindDevourer = true
								TRB.Data.snapshotData.mindDevourer.mindSearChannelStartTime = currentChannelStartTime/1000
								TRB.Data.snapshotData.mindDevourer.consumedTime = nil
							end
						elseif TRB.Data.snapshotData.mindDevourer.mindSearChannelStartTime ~= currentChannelStartTime/1000 then
							TRB.Data.snapshotData.mindDevourer.mindSearWithMindDevourer = false
							TRB.Data.snapshotData.mindDevourer.mindSearChannelStartTime = nil
						end

						if TRB.Data.snapshotData.mindDevourer.mindSearWithMindDevourer then
							TRB.Data.snapshotData.casting.resourceRaw = 0
						else
							TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindSear.insanityTick
						end

						if -TRB.Data.snapshotData.casting.resourceRaw > (TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) then
							TRB.Data.snapshotData.casting.resourceRaw = 0
							TRB.Data.snapshotData.casting.resourceFinal = 0
						end
					elseif currentChannelId == TRB.Data.spells.voidTorrent.id then
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.voidTorrent.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.voidTorrent.insanity
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.voidTorrent.icon
					else
						TRB.Functions.ResetCastingSnapshotData()
						TRB.Data.snapshotData.casting.mindSearWithMindDevourer = false
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
					elseif currentSpellId == TRB.Data.spells.darkVoid.id then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.darkVoid.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.darkVoid.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.darkVoid.icon
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
					elseif currentSpellId == TRB.Data.spells.massDispel.id and TRB.Functions.IsTalentActive(TRB.Data.spells.hallucinations) and affectingCombat then
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.hallucinations.insanity
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.massDispel.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.massDispel.icon
					else
						TRB.Functions.ResetCastingSnapshotData()
						TRB.Data.snapshotData.casting.mindSearWithMindDevourer = false
						return false
					end
					UpdateCastingResourceFinal_Shadow()
				end
				
				if currentChannelId ~= TRB.Data.spells.mindSear.id then
					TRB.Data.snapshotData.casting.mindSearWithMindDevourer = false
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
				local swingSpeed = 1.5 / (1 + (TRB.Data.snapshotData.haste / 100))

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

				if TRB.Functions.IsTalentActive(TRB.Data.spells.mindbender) then
					TRB.Data.snapshotData.mindbender.resourceRaw = countValue * TRB.Data.spells.mindbender.insanity
					if TRB.Data.snapshotData.devouredDespair.isActive and TRB.Data.snapshotData.devouredDespair.endTime ~= nil and TRB.Data.snapshotData.devouredDespair.endTime > currentTime then
						local ddTicks = TRB.Functions.RoundTo(TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.devouredDespair), 0, "ceil")
						TRB.Data.snapshotData.mindbender.resourceRaw = TRB.Data.snapshotData.mindbender.resourceRaw + (ddTicks * TRB.Data.spells.devouredDespair.insanity)
					end
				else
					TRB.Data.snapshotData.mindbender.resourceRaw = countValue * TRB.Data.spells.shadowfiend.insanity
				end
				TRB.Data.snapshotData.mindbender.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.mindbender.resourceRaw)
			end
		else
---@diagnostic disable-next-line: redundant-parameter
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
		if TRB.Functions.TableLength(TRB.Data.snapshotData.voidTendrils.activeList) > 0 then
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

							local nextTick = TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].tickTime + (TRB.Data.spells.lashOfInsanity_Lasher.tickDuration / ((TRB.Data.snapshotData.haste / 100) + 1))

							if nextTick < currentTime then
								nextTick = currentTime --There should be a tick. ANY second now. Maybe.
								totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + 1
							end
							-- NOTE: Might need to be math.floor()
							local ticksRemaining = math.ceil((endTime - nextTick) / TRB.Data.spells.lashOfInsanity_Lasher.tickDuration / ((TRB.Data.snapshotData.haste / 100) + 1)) -- This is hasted

							totalInsanity_Lasher = totalInsanity_Lasher + (ticksRemaining * TRB.Data.snapshotData.voidTendrils.activeList[vtGuid].targetsHit * TRB.Data.spells.lashOfInsanity_Lasher.insanity)
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
		UpdateSymbolOfHope()
		UpdateChanneledManaPotion()
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

		_, _, _, _, TRB.Data.snapshotData.resonantWords.duration, TRB.Data.snapshotData.resonantWords.endTime, _, _, _, TRB.Data.snapshotData.resonantWords.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.resonantWords.id)
		TRB.Data.snapshotData.resonantWords.remainingTime = GetResonantWordsRemainingTime()

		_, _, TRB.Data.snapshotData.lightweaver.stacks, _, TRB.Data.snapshotData.lightweaver.duration, TRB.Data.snapshotData.lightweaver.endTime, _, _, _, TRB.Data.snapshotData.lightweaver.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.lightweaver.id)
		TRB.Data.snapshotData.lightweaver.remainingTime = GetLightweaverRemainingTime()

		_, _, TRB.Data.snapshotData.surgeOfLight.stacks, _, TRB.Data.snapshotData.surgeOfLight.duration, TRB.Data.snapshotData.surgeOfLight.endTime, _, _, _, TRB.Data.snapshotData.surgeOfLight.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.surgeOfLight.id)
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
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.shadowWordPain.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].shadowWordPainRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Shadow()
		UpdateSnapshot()
		UpdateMindbenderValues()
		UpdateExternalCallToTheVoidValues()
		UpdateDeathAndMadness()

		local currentTime = GetTime()
		local _

		
		if TRB.Data.snapshotData.voidform.startTime ~= nil and currentTime > (TRB.Data.snapshotData.voidform.startTime + TRB.Data.snapshotData.voidform.duration) then
            TRB.Data.snapshotData.voidform.startTime = nil
            TRB.Data.snapshotData.voidform.duration = 0
			TRB.Data.snapshotData.voidform.remainingTime = 0
		else
			_, _, _, _, TRB.Data.snapshotData.voidform.duration, TRB.Data.snapshotData.voidform.endTime, _, _, _, TRB.Data.snapshotData.voidform.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.voidform.id)
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
		end

		if TRB.Data.snapshotData.mindDevourer.endTime ~= nil and currentTime > (TRB.Data.snapshotData.mindDevourer.endTime) then
            TRB.Data.snapshotData.mindDevourer.endTime = nil
            TRB.Data.snapshotData.mindDevourer.duration = 0
			TRB.Data.snapshotData.mindDevourer.spellId = nil
		end

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
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.priest.holy, TRB.Frames.barContainerFrame)
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.priest.holy.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local barBorderColor = TRB.Data.settings.priest.holy.colors.bar.border

					if TRB.Data.snapshotData.lightweaver.remainingTime ~= nil and TRB.Data.snapshotData.lightweaver.remainingTime > 0 then
						if TRB.Data.settings.priest.holy.colors.bar.lightweaverBorderChange then
							barBorderColor = TRB.Data.settings.priest.holy.colors.bar.lightweaver
						end

						if TRB.Data.settings.priest.holy.audio.lightweaver.enabled and TRB.Data.snapshotData.audio.lightweaverCue == false then
							TRB.Data.snapshotData.audio.lightweaverCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.lightweaver.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.lightweaverCue = false
					end

					if TRB.Data.snapshotData.resonantWords.remainingTime ~= nil and TRB.Data.snapshotData.resonantWords.remainingTime > 0 then
						if TRB.Data.settings.priest.holy.colors.bar.resonantWordsBorderChange then
							barBorderColor = TRB.Data.settings.priest.holy.colors.bar.resonantWords
						end

						if TRB.Data.settings.priest.holy.audio.resonantWords.enabled and TRB.Data.snapshotData.audio.resonantWordsCue == false then
							TRB.Data.snapshotData.audio.resonantWordsCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.resonantWords.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.resonantWordsCue = false
					end

					if TRB.Data.snapshotData.surgeOfLight.stacks == 1 then
						if TRB.Data.settings.priest.holy.colors.bar.surgeOfLightBorderChange1 then
							barBorderColor = TRB.Data.settings.priest.holy.colors.bar.surgeOfLight1
						end

						if TRB.Data.settings.priest.holy.audio.surgeOfLight.enabled and not TRB.Data.snapshotData.audio.surgeOfLightCue then
							TRB.Data.snapshotData.audio.surgeOfLightCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end

					if TRB.Data.snapshotData.surgeOfLight.stacks == 2 then
						if TRB.Data.settings.priest.holy.colors.bar.surgeOfLightBorderChange2 then
							barBorderColor = TRB.Data.settings.priest.holy.colors.bar.surgeOfLight2
						end

						if TRB.Data.settings.priest.holy.audio.surgeOfLight2.enabled and not TRB.Data.snapshotData.audio.surgeOfLight2Cue then
							TRB.Data.snapshotData.audio.surgeOfLight2Cue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.surgeOfLight2.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end

					if TRB.Data.spells.innervate.isActive then
						if TRB.Data.settings.priest.holy.colors.bar.innervateBorderChange then
							barBorderColor = TRB.Data.settings.priest.holy.colors.bar.innervate
						end

						if TRB.Data.settings.priest.holy.audio.innervate.enabled and TRB.Data.snapshotData.audio.innervateCue == false then
							TRB.Data.snapshotData.audio.innervateCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.holy.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
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
						local ampr1Total = CalculateManaGain(TRB.Data.character.items.potions.aeratedManaPotionRank1.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.aeratedManaPotionRank1.enabled and (castingBarValue + ampr1Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.priest.holy.thresholds.width, (castingBarValue + ampr1Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[1]:Show()
								
							if TRB.Data.settings.priest.holy.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[1].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[1].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[1]:Hide()
						end
						
						local ampr2Total = CalculateManaGain(TRB.Data.character.items.potions.aeratedManaPotionRank2.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.aeratedManaPotionRank2.enabled and (castingBarValue + ampr2Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[2], resourceFrame, TRB.Data.settings.priest.holy.thresholds.width, (castingBarValue + ampr2Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[2]:Show()
								
							if TRB.Data.settings.priest.holy.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[2].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[2].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[2]:Hide()
						end
						
						local ampr3Total = CalculateManaGain(TRB.Data.character.items.potions.aeratedManaPotionRank3.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.aeratedManaPotionRank3.enabled and (castingBarValue + ampr3Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[3], resourceFrame, TRB.Data.settings.priest.holy.thresholds.width, (castingBarValue + ampr3Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[3]:Show()
								
							if TRB.Data.settings.priest.holy.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[3].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[3].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[3]:Hide()
						end

						local poffr1Total = CalculateManaGain(TRB.Data.character.items.potions.potionOfFrozenFocusRank1.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.potionOfFrozenFocusRank1.enabled and (castingBarValue + poffr1Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[4], resourceFrame, TRB.Data.settings.priest.holy.thresholds.width, (castingBarValue + poffr1Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[4]:Show()
								
							if TRB.Data.settings.priest.holy.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[4].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[4].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[4]:Hide()
						end

						local poffr2Total = CalculateManaGain(TRB.Data.character.items.potions.potionOfFrozenFocusRank2.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.potionOfFrozenFocusRank2.enabled and (castingBarValue + poffr2Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[5], resourceFrame, TRB.Data.settings.priest.holy.thresholds.width, (castingBarValue + poffr2Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[5].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[5].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[5]:Show()
								
							if TRB.Data.settings.priest.holy.thresholds.icons.showCooldown then
								TRB.Frames.resourceFrame.thresholds[5].icon.cooldown:SetCooldown(TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration)
							else
								TRB.Frames.resourceFrame.thresholds[5].icon.cooldown:SetCooldown(0, 0)
							end
						else
							TRB.Frames.resourceFrame.thresholds[5]:Hide()
						end

						local poffr3Total = CalculateManaGain(TRB.Data.character.items.potions.potionOfFrozenFocusRank3.mana, true)
						if TRB.Data.settings.priest.holy.thresholds.potionOfFrozenFocusRank3.enabled and (castingBarValue + poffr3Total) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[6], resourceFrame, TRB.Data.settings.priest.holy.thresholds.width, (castingBarValue + poffr3Total), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[6].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[6].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[6]:Show()
								
							if TRB.Data.settings.priest.holy.thresholds.icons.showCooldown then
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
						if TRB.Data.settings.priest.holy.thresholds.conjuredChillglobe.enabled and (castingBarValue + conjuredChillglobeTotal) < TRB.Data.character.maxResource then
							if TRB.Data.snapshotData.conjuredChillglobe.onCooldown then
								potionThresholdColor = TRB.Data.settings.priest.holy.colors.threshold.unusable
							end
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.resourceFrame.thresholds[7], resourceFrame, TRB.Data.settings.priest.holy.thresholds.width, (castingBarValue + conjuredChillglobeTotal), TRB.Data.character.maxResource)
	---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[7].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
	---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[7].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[7]:Show()
								
							if TRB.Data.settings.priest.holy.thresholds.icons.showCooldown then
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
					if TRB.Data.settings.priest.holy.bar.showPassive then
						if TRB.Data.snapshotData.channeledManaPotion.isActive then
							passiveValue = passiveValue + TRB.Data.snapshotData.channeledManaPotion.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, TRB.Data.settings.priest.holy.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.holy.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[1]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[1]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end

						-- Old Wrathful Faerie threshold. TODO: remove
						TRB.Frames.passiveFrame.thresholds[2]:Hide()

						if TRB.Data.snapshotData.innervate.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.innervate.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[3], passiveFrame, TRB.Data.settings.priest.holy.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
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
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, TRB.Data.settings.priest.holy.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
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
								TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.holy, TRB.Frames.passiveFrame.thresholds[5], passiveFrame, TRB.Data.settings.priest.holy.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
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
							TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction >= 0 and
							TRB.Functions.IsTalentActive(TRB.Data.spells[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey]) then

							local castTimeRemains = TRB.Data.snapshotData.casting.endTime - currentTime
							local holyWordCooldownRemaining = GetHolyWordCooldownTimeRemaining(TRB.Data.snapshotData[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey])

							if (holyWordCooldownRemaining - CalculateHolyWordCooldown(TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordReduction, TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].id) - castTimeRemains) <= 0 and TRB.Data.settings.priest.holy.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey .. "Enabled"] then
								resourceBarColor = TRB.Data.settings.priest.holy.colors.bar[TRB.Data.spells[TRB.Data.snapshotData.casting.spellKey].holyWordKey]
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
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.priest.shadow, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.priest.shadow.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentInsanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					local barBorderColor = TRB.Data.settings.priest.shadow.colors.bar.border

					if TRB.Data.settings.priest.shadow.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.priest.shadow.colors.bar.borderOvercap
						if TRB.Data.settings.priest.shadow.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderColor = TRB.Data.settings.priest.shadow.colors.bar.border
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					if TRB.Data.settings.priest.shadow.colors.bar.mindFlayInsanityBorderChange and IsValidVariableForSpec("$mfiTime") then
						barBorderColor = TRB.Data.settings.priest.shadow.colors.bar.borderMindFlayInsanity
					end
					
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					if CastingSpell() and TRB.Data.settings.priest.shadow.bar.showCasting  then
						castingBarValue = TRB.Data.snapshotData.casting.resourceFinal + currentInsanity
					else
						castingBarValue = currentInsanity
					end

					if TRB.Data.settings.priest.shadow.bar.showPassive and
						(TRB.Functions.IsTalentActive(TRB.Data.spells.auspiciousSpirits) or
						TRB.Data.snapshotData.mindbender.resourceFinal > 0 or
						TRB.Data.snapshotData.deathAndMadness.isActive or
						TRB.Data.snapshotData.voidTendrils.resourceFinal > 0) then
						passiveValue = ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceFinal + TRB.Data.snapshotData.deathAndMadness.insanity + TRB.Data.snapshotData.voidTendrils.resourceFinal)
						if TRB.Data.snapshotData.mindbender.resourceFinal > 0 and (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, TRB.Data.settings.priest.shadow.thresholds.width, (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.mindbender, true))
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

					if TRB.Data.settings.priest.shadow.thresholds.devouringPlague.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.devouringPlague) then
						TRB.Frames.resourceFrame.thresholds[1]:Show()
						TRB.Frames.resourceFrame.thresholds[1]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdUnusable-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].icon:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdUnusable-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].icon.cooldown:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdUnusable-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)						
					else
						TRB.Frames.resourceFrame.thresholds[1]:Hide()
					end

					if TRB.Data.settings.priest.shadow.thresholds.mindSear.enabled and TRB.Functions.IsTalentActive(TRB.Data.spells.mindSear) then
						if TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.mindSearThreshold then
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
						else
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
						end
						TRB.Frames.resourceFrame.thresholds[2]:Show()
						TRB.Frames.resourceFrame.thresholds[2]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdUnusable-3-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[2].icon:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdUnusable-3-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[2].icon.cooldown:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdUnusable-3-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
					else
						TRB.Frames.resourceFrame.thresholds[2]:Hide()
					end

					if TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold or TRB.Data.spells.mindDevourer.isActive then
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
						if TRB.Data.settings.priest.shadow.colors.bar.flashEnabled then
							TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.priest.shadow.colors.bar.flashAlpha, TRB.Data.settings.priest.shadow.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if TRB.Data.spells.mindDevourer.isActive and TRB.Data.settings.priest.shadow.audio.mdProc.enabled and TRB.Data.snapshotData.audio.playedMdCue == false then
							TRB.Data.snapshotData.audio.playedDpCue = true
							TRB.Data.snapshotData.audio.playedMdCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.mdProc.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif TRB.Data.settings.priest.shadow.audio.dpReady.enabled and TRB.Data.snapshotData.audio.playedDpCue == false then
							TRB.Data.snapshotData.audio.playedDpCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.priest.shadow.audio.dpReady.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
---@diagnostic disable-next-line: undefined-field
						TRB.Frames.resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
						barContainerFrame:SetAlpha(1.0)
						TRB.Data.snapshotData.audio.playedDpCue = false
						TRB.Data.snapshotData.audio.playedMdCue = false
					end

					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < currentInsanity then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, passiveFrame, currentInsanity)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.spending, true))
						else
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, castingFrame, currentInsanity)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.passive, true))
						end
					else
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, resourceFrame, currentInsanity)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.passive, true))
					end

					if TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.devouringPlagueUsableCasting, true))
					else
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.casting, true))
					end

					if TRB.Data.snapshotData.voidform.remainingTime > 0 or TRB.Data.snapshotData.darkAscension.remainingTime > 0 then
						local timeLeft = TRB.Data.snapshotData.voidform.remainingTime
						if TRB.Data.snapshotData.darkAscension.remainingTime > 0 then
							timeLeft = TRB.Data.snapshotData.darkAscension.remainingTime
						end
						local timeThreshold = 0
						local useEndOfVoidformColor = false

						if TRB.Data.settings.priest.shadow.endOfVoidform.enabled then
							useEndOfVoidformColor = true
							if TRB.Data.settings.priest.shadow.endOfVoidform.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.priest.shadow.endOfVoidform.gcdsMax
							elseif TRB.Data.settings.priest.shadow.endOfVoidform.mode == "time" then
								timeThreshold = TRB.Data.settings.priest.shadow.endOfVoidform.timeMax
							end
						end

						if useEndOfVoidformColor and timeLeft <= timeThreshold then
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform1GCD, true))
						elseif TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.devouringPlagueUsable, true))
						else
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform, true))
						end
					else
						if TRB.Data.snapshotData.mindDevourer.spellId ~= nil or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.devouringPlagueUsable, true))
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
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
					if settings.mindbender.enabled and type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.mindbender.energizeId and sourceName == TRB.Data.spells.mindbender.name then
						--((TRB.Functions.IsTalentActive(TRB.Data.spells.mindbender) and sourceName == TRB.Data.spells.mindbender.name)) then
						--(not TRB.Functions.IsTalentActive(TRB.Data.spells.mindbender) and sourceName == TRB.Data.spells.shadowfiend.name)						
						TRB.Data.snapshotData.mindbender.swingTime = currentTime
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
							_, _, _, _, TRB.Data.snapshotData.voidform.duration, TRB.Data.snapshotData.voidform.endTime, _, _, _, TRB.Data.snapshotData.voidform.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.voidform.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.voidform.isActive = false
							TRB.Data.snapshotData.voidform.spellId = nil
							TRB.Data.snapshotData.voidform.duration = 0
							TRB.Data.snapshotData.voidform.endTime = nil
						end
					elseif spellId == TRB.Data.spells.darkAscension.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.darkAscension.isActive = true
							_, _, _, _, TRB.Data.snapshotData.darkAscension.duration, TRB.Data.snapshotData.darkAscension.endTime, _, _, _, TRB.Data.snapshotData.darkAscension.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.darkAscension.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.darkAscension.isActive = false
							TRB.Data.snapshotData.darkAscension.spellId = nil
							TRB.Data.snapshotData.darkAscension.duration = 0
							TRB.Data.snapshotData.darkAscension.endTime = nil
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
						if type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.casting.mindSearWithMindDevourer = false
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
							end
						end
					elseif settings.auspiciousSpiritsTracker and TRB.Functions.IsTalentActive(TRB.Data.spells.auspiciousSpirits) and spellId == TRB.Data.spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
						InitializeTarget(destGUID)
						TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits + 1
						TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits + 1
						triggerUpdate = true
					elseif settings.auspiciousSpiritsTracker and TRB.Functions.IsTalentActive(TRB.Data.spells.auspiciousSpirits) and spellId == TRB.Data.spells.auspiciousSpirits.idImpact and (type == "SPELL_DAMAGE" or type == "SPELL_MISSED" or type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
						if TRB.Functions.CheckTargetExists(destGUID) then
							TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits - 1
							TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits - 1
						end
						triggerUpdate = true
					elseif type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.shadowCrash.id then
						triggerUpdate = true
					elseif spellId == TRB.Data.spells.mindDevourer.buffId then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.mindDevourer.isActive = true
							_, _, _, _, TRB.Data.snapshotData.mindDevourer.duration, TRB.Data.snapshotData.mindDevourer.endTime, _, _, _, TRB.Data.snapshotData.mindDevourer.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.mindDevourer.buffId)
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
							_, _, _, _, TRB.Data.snapshotData.devouredDespair.duration, TRB.Data.snapshotData.devouredDespair.endTime, _, _, _, TRB.Data.snapshotData.devouredDespair.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.devouredDespair.id)
						elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
							TRB.Data.snapshotData.devouredDespair.isActive = false
							TRB.Data.snapshotData.devouredDespair.spellId = nil
							TRB.Data.snapshotData.devouredDespair.duration = 0
							TRB.Data.snapshotData.devouredDespair.endTime = nil
						end
					elseif spellId == TRB.Data.spells.mindFlayInsanity.buffId then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
							TRB.Data.spells.mindFlayInsanity.isActive = true
							_, _, _, _, TRB.Data.snapshotData.mindFlayInsanity.duration, TRB.Data.snapshotData.mindFlayInsanity.endTime, _, _, _, TRB.Data.snapshotData.mindFlayInsanity.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.mindFlayInsanity.buffId)
						elseif type == "SPELL_AURA_REMOVED" or type == "SPELL_DISPEL" then -- Lost buff
							TRB.Data.spells.mindFlayInsanity.isActive = false
							TRB.Data.snapshotData.mindFlayInsanity.spellId = nil
							TRB.Data.snapshotData.mindFlayInsanity.duration = 0
							TRB.Data.snapshotData.mindFlayInsanity.endTime = nil
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
					end
				end

				-- Spec agnostic
				if spellId == TRB.Data.spells.shadowWordPain.id then
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
				TRB.Functions.RemoveTarget(destGUID)
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
		if specId == 2 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.priest.holy)
			TRB.Functions.IsTtdActive(TRB.Data.settings.priest.holy)
			specCache.holy.talents = TRB.Functions.GetTalents()
			FillSpellData_Holy()
			TRB.Functions.LoadFromSpecCache(specCache.holy)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Holy

			if TRB.Data.barConstructedForSpec ~= "holy" then
				TRB.Data.barConstructedForSpec = "holy"
				ConstructResourceBar(specCache.holy.settings)
			end
		elseif specId == 3 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.priest.shadow)
			TRB.Functions.IsTtdActive(TRB.Data.settings.priest.shadow)
			specCache.shadow.talents = TRB.Functions.GetTalents()
			FillSpellData_Shadow()
			TRB.Functions.LoadFromSpecCache(specCache.shadow)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow

			if TRB.Data.barConstructedForSpec ~= "shadow" then
				TRB.Data.barConstructedForSpec = "shadow"
				ConstructResourceBar(specCache.shadow.settings)
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
		if classIndexId == 5 then
			if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Priest.LoadDefaultSettings()
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
							TRB.Data.settings.priest.holy = TRB.Functions.ValidateLsmValues("Holy Priest", TRB.Data.settings.priest.holy)
							TRB.Data.settings.priest.shadow = TRB.Functions.ValidateLsmValues("Shadow Priest", TRB.Data.settings.priest.shadow)
							
							FillSpellData_Holy()
							FillSpellData_Shadow()
							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Priest.ConstructOptionsPanel(specCache)
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

