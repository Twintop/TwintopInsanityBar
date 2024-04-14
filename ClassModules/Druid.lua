local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 11 then --Only do this if we're on a Druid!
	local L = TRB.Localization
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
		balance = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
		feral = TRB.Classes.SpecCache:New({
			bleeds = {}
		}) --[[@as TRB.Classes.SpecCache]],
		restoration = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
	}

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
				resource = 6,
				pandemic = true,
				pandemicTime = 22 * 0.3,
				baseline = true
			},
		
			-- Druid Class Talents
			starfire = {
				id = 194153,
				name = "",
				icon = "",
				resource = 10,
				baseline = true,
				isTalent = true
			},
			starsurge = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				resource = -40,
				thresholdId = 1,
				settingKey = "starsurge",
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			starsurge2 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				resource = -80,
				thresholdId = 2,
				settingKey = "starsurge2",
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			starsurge3 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				resource = -120,
				thresholdId = 3,
				settingKey = "starsurge3",
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
				resource = 6,
				pandemic = true,
				pandemicTime = 18 * 0.3,
				isTalent = true
			},

			-- Balance Spec Baseline Abilities
			wrath = {
				id = 190984,
				name = "",
				icon = "",
				resource = 8
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
				resource = 2,
				outOfCombatResource = 6,
				tickRate = 3,
				isTalent = true
			},
			starfall = {
				id = 191034,
				name = "",
				icon = "",
				texture = "",
				resource = -50,
				thresholdId = 4,
				settingKey = "starfall",
				pandemic = true,
				pandemicTime = 8 * 0.3,
				isTalent = true,
				isSnowflake = true
			},
			stellarFlare = {
				id = 202347,
				name = "",
				icon = "",
				resource = 10,
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
				id = 393954,
				name = "",
				icon = "",
				modifier = -0.10,
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
				maxResource = 600,
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
				resource = 12,
				recharge = 20,
				isTalent = true
			},
			halfMoon = {
				id = 274282,
				name = "",
				icon = "",
				resource = 24
			},
			fullMoon = {
				id = 274283,
				name = "",
				icon = "",
				resource = 50
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
				resourceMod = -15
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
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.primordialArcanicPulsar.id] = TRB.Classes.Snapshot:New(specCache.balance.spells.primordialArcanicPulsar, nil, true)
		specCache.balance.snapshotData.snapshots[specCache.balance.spells.primordialArcanicPulsar.id].buff:SetCustomProperties({
			{
				name = "currentResource",
				dataType = "number",
				index = 1
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
				resource = -35,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 1,
				settingKey = "rake",
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
				resource = -40,
				comboPointsGenerated = 1,
				thresholdId = 2,
				texture = "",
				settingKey = "thrash",
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
				resource = -20,
				comboPoints = true,
				thresholdId = 4,
				texture = "",
				settingKey = "rip",
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
				resource = -30,
				comboPoints = true,
				texture = "",
				thresholdId = 5,
				settingKey = "maim",
				hasCooldown = true,
				cooldown = 20,
				isTalent = true
			},
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				resource = 2,
				pandemic = true,
				pandemicTime = 13.5 * 0.3,
				isTalent = true
			},

			-- Feral Spec Baseline Abilities
			ferociousBite = {
				id = 22568,
				name = "",
				icon = "",
				resource = -25,
				resourceMax = -50,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "ferociousBite",
				isSnowflake = true, -- Really between 25-50 energy, minus Relentless Predator
				relentlessPredator = true
			},
			ferociousBiteMinimum = {
				id = 22568,
				name = "",
				icon = "",
				resource = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 7,
				settingKey = "ferociousBiteMinimum",
				isSnowflake = true,
				relentlessPredator = true
			},
			ferociousBiteMaximum = {
				id = 22568,
				name = "",
				icon = "",
				resource = -50,
				comboPoints = true,
				texture = "",
				thresholdId = 8,
				settingKey = "ferociousBiteMaximum",
				isSnowflake = true,
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
				resource = -40,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 9,
				settingKey = "shred",
				isClearcasting = true
			},
			swipe = {
				id = 106785,
				name = "",
				icon = "",
				resource = -35,
				comboPointsGenerated = 1,
				thresholdId = 3,
				texture = "",
				settingKey = "swipe",
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
				resource = -20,
				comboPoints = true,
				thresholdId = 10,
				texture = "",
				settingKey = "primalWrath",
				isTalent = true
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
				resource = -30,
				comboPointsGenerated = 1,
				thresholdId = 11,
				texture = "",
				settingKey = "moonfire",
				isSnowflake = true,
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
				resource = -25,
				comboPointsGenerated = 1,
				thresholdId = 12,
				texture = "",
				settingKey = "brutalSlash",
				isSnowflake = true,
				isTalent = true,
				hasCooldown = true,
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
				resource = -80, --Make this dynamic
				thresholdId = 13,
				texture = "",
				settingKey = "bloodtalons",
				isTalent = true,
				--isSnowflake = true,
				modifier = 1.25
			},
			feralFrenzy = {
				id = 274837,
				name = "",
				icon = "",
				resource = -25,
				comboPointsGenerated = 5,
				thresholdId = 14,
				texture = "",
				settingKey = "feralFrenzy",
				isTalent = true,
				hasCooldown = true
			},
			incarnationAvatarOfAshamane = {
				id = 102543,
				name = "",
				icon = "",
				resourceModifier = 0.8
			}, 
			relentlessPredator = {
				id = 393771,
				name = "",
				icon = "",
				isTalent = true,
				resourceModifier = 0.9
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

		specCache.feral.snapshotData.attributes.resourceRegen = 0
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
					manaThresholdPercent = 0.65,
					mana = 0
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
				resource = 2,
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
				manaPercent = 0.02,
				ticks = 4,
				tickId = 265144
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8
			},
			blessingOfWinter = {
				id = 388011,
				name = "",
				icon = "",
				tickRate = 2,
				hasTicks = true,
				resourcePerTick = 0,
				manaPercent = 0.01
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
				settingKey = "aeratedManaPotionRank1"
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
				settingKey = "aeratedManaPotionRank2"
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
				settingKey = "aeratedManaPotionRank3"
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
				settingKey = "potionOfFrozenFocusRank1"
			},
			potionOfFrozenFocusRank2 = {
				itemId = 191364,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 5,
				settingKey = "potionOfFrozenFocusRank2"
			},
			potionOfFrozenFocusRank3 = {
				itemId = 191365,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 6,
				settingKey = "potionOfFrozenFocusRank3"
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
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.reforestation.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.reforestation, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.conjuredChillglobe)
		---@type TRB.Classes.Healer.MoltenRadiance
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(specCache.restoration.spells.moltenRadiance)
		---@type TRB.Classes.Healer.BlessingOfWinter
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(specCache.restoration.spells.blessingOfWinter)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.incarnationTreeOfLife.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.incarnationTreeOfLife)

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
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

			{ variable = "#moonkinForm", icon = spells.moonkinForm.icon, description = spells.moonkinForm.name, printInSettings = true },

			{ variable = "#wrath", icon = spells.wrath.icon, description = spells.wrath.name, printInSettings = true },
			{ variable = "#starfire", icon = spells.starfire.icon, description = spells.starfire.name, printInSettings = true },
			
			{ variable = "#sunfire", icon = spells.sunfire.icon, description = spells.sunfire.name, printInSettings = true },
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = spells.moonfire.name, printInSettings = true },
			
			{ variable = "#starsurge", icon = spells.starsurge.icon, description = spells.starsurge.name, printInSettings = true },
			{ variable = "#starfall", icon = spells.fullMoon.icon, description = spells.fullMoon.name, printInSettings = true },
			{ variable = "#starweaver", icon = string.format(L["DruidBalanceIcon_starweaver"], spells.starweaversWarp.icon, spells.starweaversWeft.icon), description = L["DruidBalanceIconDescription_starweaver"], printInSettings = true },
			{ variable = "#starweaversWarp", icon = spells.starweaversWarp.icon, description = spells.starweaversWarp.name, printInSettings = true },
			{ variable = "#starweaversWeft", icon = spells.starweaversWeft.icon, description = spells.starweaversWeft.name, printInSettings = true },

			{ variable = "#pulsar", icon = spells.primordialArcanicPulsar.icon, description = spells.primordialArcanicPulsar.name, printInSettings = true },
			{ variable = "#pap", icon = spells.primordialArcanicPulsar.icon, description = spells.primordialArcanicPulsar.name, printInSettings = false },
			{ variable = "#primordialArcanicPulsar", icon = spells.primordialArcanicPulsar.icon, description = spells.primordialArcanicPulsar.name, printInSettings = false },

			{ variable = "#eclipse", icon = string.format(L["DruidBalanceIcon_eclipse"], spells.incarnationChosenOfElune.icon, spells.celestialAlignment.icon, spells.eclipseSolar.icon, spells.eclipseLunar.icon), description = L["DruidBalanceIconDescription_eclipse"], printInSettings = true },
			{ variable = "#celestialAlignment", icon = spells.celestialAlignment.icon, description = spells.celestialAlignment.name, printInSettings = true },			
			{ variable = "#icoe", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = true },			
			{ variable = "#coe", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
			{ variable = "#incarnation", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
			{ variable = "#incarnationChosenOfElune", icon = spells.incarnationChosenOfElune.icon, description = spells.incarnationChosenOfElune.name, printInSettings = false },			
			{ variable = "#solar", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = true },
			{ variable = "#eclipseSolar", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = false },
			{ variable = "#solarEclipse", icon = spells.eclipseSolar.icon, description = spells.eclipseSolar.name, printInSettings = false },
			{ variable = "#lunar", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = true },
			{ variable = "#eclipseLunar", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = false },
			{ variable = "#lunarEclipse", icon = spells.eclipseLunar.icon, description = spells.eclipseLunar.name, printInSettings = false },
			
			{ variable = "#naturesBalance", icon = spells.naturesBalance.icon, description = spells.naturesBalance.name, printInSettings = true },
			
			{ variable = "#soulOfTheForest", icon = spells.soulOfTheForest.icon, description = spells.soulOfTheForest.name, printInSettings = true },
			
			{ variable = "#stellarFlare", icon = spells.stellarFlare.icon, description = spells.stellarFlare.name, printInSettings = true },

			{ variable = "#foe", icon = spells.furyOfElune.icon, description = spells.furyOfElune.name, printInSettings = false },
			{ variable = "#furyOfElune", icon = spells.furyOfElune.icon, description = spells.furyOfElune.name, printInSettings = true },
			
			{ variable = "#sunderedFirmament", icon = spells.sunderedFirmament.icon, description = spells.sunderedFirmament.name, printInSettings = true },
			
			{ variable = "#newMoon", icon = spells.newMoon.icon, description = spells.newMoon.name, printInSettings = true },
			{ variable = "#halfMoon", icon = spells.halfMoon.icon, description = spells.halfMoon.name, printInSettings = true },
			{ variable = "#fullMoon", icon = spells.fullMoon.icon, description = spells.fullMoon.name, printInSettings = true },
			{ variable = "#moon", icon = string.format(L["DruidBalanceIcon_moon"], spells.newMoon.icon, spells.halfMoon.icon, spells.fullMoon.icon), description = L["DruidBalanceIconDescription_moon"], printInSettings = true },
		}
		specCache.balance.barTextVariables.values = {
			{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
			{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
			{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
			{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
			{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
			{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
			{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
			{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
			{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
			{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
			{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
			{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

			{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
			{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
			{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
			{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
			{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
			{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
			{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
			{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

			{ variable = "$moonkinForm", description = L["DruidBalanceBarTextVariable_moonkinForm"], printInSettings = true, color = false },
			{ variable = "$eclipse", description = L["DruidBalanceBarTextVariable_eclipse"], printInSettings = true, color = false },
			{ variable = "$eclipseTime", description = L["DruidBalanceBarTextVariable_eclipseTime"], printInSettings = true, color = false },
			{ variable = "$lunar", description = L["DruidBalanceBarTextVariable_lunar"], printInSettings = true, color = false },
			{ variable = "$lunarEclipse", description = "", printInSettings = false, color = false },
			{ variable = "$eclipseLunar", description = "", printInSettings = false, color = false },
			{ variable = "$solar", description = L["DruidBalanceBarTextVariable_solar"], printInSettings = true, color = false },
			{ variable = "$solarEclipse", description = "", printInSettings = false, color = false },
			{ variable = "$eclipseSolar", description = "", printInSettings = false, color = false },
			{ variable = "$celestialAlignment", description = L["DruidBalanceBarTextVariable_celestialAlignment"], printInSettings = true, color = false },

			{ variable = "$pulsarCollected", description = L["DruidBalanceBarTextVariable_pulsarCollected"], printInSettings = true, color = false },
			{ variable = "$pulsarCollectedPercent", description = L["DruidBalanceBarTextVariable_pulsarCollectedPercent"], printInSettings = true, color = false },
			{ variable = "$pulsarRemaining", description = L["DruidBalanceBarTextVariable_pulsarRemaining"], printInSettings = true, color = false },
			{ variable = "$pulsarRemainingPercent", description = L["DruidBalanceBarTextVariable_pulsarRemainingPercent"], printInSettings = true, color = false },
			{ variable = "$pulsarNextStarsurge", description = L["DruidBalanceBarTextVariable_pulsarNextStarsurge"], printInSettings = true, color = false },
			{ variable = "$pulsarNextStarfall", description = L["DruidBalanceBarTextVariable_pulsarNextStarfall"], printInSettings = true, color = false },
			{ variable = "$pulsarStarsurgeCount", description = L["DruidBalanceBarTextVariable_pulsarStarsurgeCount"], printInSettings = true, color = false },
			{ variable = "$pulsarStarfallCount", description = L["DruidBalanceBarTextVariable_pulsarStarfallCount"], printInSettings = true, color = false },

			{ variable = "$astralPower", description = L["DruidBalanceBarTextVariable_astralPower"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$astralPowerMax", description = L["DruidBalanceBarTextVariable_astralPowerMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["DruidBalanceBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["DruidBalanceBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$astralPowerPlusCasting", description = L["DruidBalanceBarTextVariable_astralPowerPlusCasting"], printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$astralPowerPlusPassive", description = L["DruidBalanceBarTextVariable_astralPowerPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$astralPowerTotal", description = L["DruidBalanceBarTextVariable_astralPowerTotal"], printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },	 
			{ variable = "$foeAstralPower", description = L["DruidBalanceBarTextVariable_foeAstralPower"], printInSettings = true, color = false },   
			{ variable = "$foeTicks", description = L["DruidBalanceBarTextVariable_foeTicks"], printInSettings = true, color = false },   
			{ variable = "$foeTime", description = L["DruidBalanceBarTextVariable_foeTime"], printInSettings = true, color = false },		
			{ variable = "$sunderedFirmamentAstralPower", description = L["DruidBalanceBarTextVariable_sunderedFirmamentAstralPower"], printInSettings = true, color = false },   
			{ variable = "$sunderedFirmamentTicks", description = L["DruidBalanceBarTextVariable_sunderedFirmamentTicks"], printInSettings = true, color = false },   
			{ variable = "$sunderedFirmamentTime", description = L["DruidBalanceBarTextVariable_sunderedFirmamentTime"], printInSettings = true, color = false },   

			{ variable = "$sunfireCount", description = L["DruidBalanceBarTextVariable_sunfireCount"], printInSettings = true, color = false },
			{ variable = "$sunfireTime", description = L["DruidBalanceBarTextVariable_sunfireTime"], printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = L["DruidBalanceBarTextVariable_moonfireCount"], printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = L["DruidBalanceBarTextVariable_moonfireTime"], printInSettings = true, color = false },
			{ variable = "$stellarFlareCount", description = L["DruidBalanceBarTextVariable_stellarFlareCount"], printInSettings = true, color = false },
			{ variable = "$stellarFlareTime", description = L["DruidBalanceBarTextVariable_stellarFlareTime"], printInSettings = true, color = false },

			{ variable = "$moonAstralPower", description = L["DruidBalanceBarTextVariable_moonAstralPower"], printInSettings = true, color = false },   
			{ variable = "$moonCharges", description = L["DruidBalanceBarTextVariable_moonCharges"], printInSettings = true, color = false },   
			{ variable = "$moonCooldown", description = L["DruidBalanceBarTextVariable_moonCooldown"], printInSettings = true, color = false },
			{ variable = "$moonCooldownTotal", description = L["DruidBalanceBarTextVariable_moonCooldownTotal"], printInSettings = true, color = false },

			{ variable = "$starweaverTime", description = L["DruidBalanceBarTextVariable_starweaverTime"], printInSettings = true, color = false },
			{ variable = "$starweaver", description = L["DruidBalanceBarTextVariable_starweaver"], printInSettings = true, color = false },
			{ variable = "$starweaversWarp", description = L["DruidBalanceBarTextVariable_starweaversWarp"], printInSettings = true, color = false },
			{ variable = "$starweaversWeft", description = L["DruidBalanceBarTextVariable_starweaversWeft"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
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
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

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
			{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
			{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
			{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
			{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
			{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
			{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
			{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
			{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
			{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
			{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
			{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
			{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

			{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
			{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
			{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
			{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
			{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
			{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
			{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
			{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },
			{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },

			{ variable = "$energy", description = L["DruidFeralBarTextVariable_energy"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$energyMax", description = L["DruidFeralBarTextVariable_energyMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["DruidFeralBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["DruidFeralBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$regen", description = L["DruidFeralBarTextVariable_regen"], printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = L["DruidFeralBarTextVariable_energyPlusCasting"], printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = L["DruidFeralBarTextVariable_energyPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = L["DruidFeralBarTextVariable_energyTotal"], printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },	 
			
			{ variable = "$comboPoints", description = L["DruidFeralBarTextVariable_comboPoints"], printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = L["DruidFeralBarTextVariable_comboPointsMax"], printInSettings = true, color = false },

			{ variable = "$ripCount", description = L["DruidFeralBarTextVariable_ripCount"], printInSettings = true, color = false },
			{ variable = "$ripTime", description = L["DruidFeralBarTextVariable_ripTime"], printInSettings = true, color = false },
			{ variable = "$ripSnapshot", description = L["DruidFeralBarTextVariable_ripSnapshot"], printInSettings = true, color = false },
			{ variable = "$ripPercent", description = L["DruidFeralBarTextVariable_ripPercent"], printInSettings = true, color = false },
			{ variable = "$ripCurrent", description = L["DruidFeralBarTextVariable_ripCurrent"], printInSettings = true, color = false },

			{ variable = "$rakeCount", description = L["DruidFeralBarTextVariable_rakeCount"], printInSettings = true, color = false },
			{ variable = "$rakeTime", description = L["DruidFeralBarTextVariable_rakeTime"], printInSettings = true, color = false },
			{ variable = "$rakeSnapshot", description = L["DruidFeralBarTextVariable_rakeSnapshot"], printInSettings = true, color = false },
			{ variable = "$rakePercent", description = L["DruidFeralBarTextVariable_rakePercent"], printInSettings = true, color = false },
			{ variable = "$rakeCurrent", description = L["DruidFeralBarTextVariable_rakeCurrent"], printInSettings = true, color = false },
			
			{ variable = "$thrashCount", description = L["DruidFeralBarTextVariable_thrashCount"], printInSettings = true, color = false },
			{ variable = "$thrashTime", description = L["DruidFeralBarTextVariable_thrashTime"], printInSettings = true, color = false },
			{ variable = "$thrashSnapshot", description = L["DruidFeralBarTextVariable_thrashSnapshot"], printInSettings = true, color = false },
			{ variable = "$thrashPercent", description = L["DruidFeralBarTextVariable_thrashPercent"], printInSettings = true, color = false },
			{ variable = "$thrashCurrent", description = L["DruidFeralBarTextVariable_thrashCurrent"], printInSettings = true, color = false },
			
			{ variable = "$moonfireCount", description = L["DruidFeralBarTextVariable_moonfireCount"], printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = L["DruidFeralBarTextVariable_moonfireTime"], printInSettings = true, color = false },
			{ variable = "$moonfireSnapshot", description = L["DruidFeralBarTextVariable_moonfireSnapshot"], printInSettings = true, color = false },
			{ variable = "$moonfirePercent", description = L["DruidFeralBarTextVariable_moonfirePercent"], printInSettings = true, color = false },
			{ variable = "$moonfireCurrent", description = L["DruidFeralBarTextVariable_moonfireCurrent"], printInSettings = true, color = false },
			
			{ variable = "$lunarInspiration", description = L["DruidFeralBarTextVariable_lunarInspiration"], printInSettings = true, color = false },

			{ variable = "$brutalSlashCharges", description = L["DruidFeralBarTextVariable_brutalSlashCharges"], printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldown", description = L["DruidFeralBarTextVariable_brutalSlashCooldown"], printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldownTotal", description = L["DruidFeralBarTextVariable_brutalSlashCooldownTotal"], printInSettings = true, color = false },  
			
			{ variable = "$bloodtalonsStacks", description = L["DruidFeralBarTextVariable_bloodtalonsStacks"], printInSettings = true, color = false },
			{ variable = "$bloodtalonsTime", description = L["DruidFeralBarTextVariable_bloodtalonsTime"], printInSettings = true, color = false },
			
			{ variable = "$clearcastingStacks", description = L["DruidFeralBarTextVariable_clearcastingStacks"], printInSettings = true, color = false },
			{ variable = "$clearcastingTime", description = L["DruidFeralBarTextVariable_clearcastingTime"], printInSettings = true, color = false },
			
			{ variable = "$berserkTime", description = L["DruidFeralBarTextVariable_berserkTime"], printInSettings = true, color = false },
			{ variable = "$incarnationTime", description = "", printInSettings = false, color = false },
			{ variable = "$incarnationTicks", description = L["DruidFeralBarTextVariable_incarnationTicks"], printInSettings = true, color = false },
			{ variable = "$incarnationTickTime", description = L["DruidFeralBarTextVariable_incarnationTickTime"], printInSettings = true, color = false },
			{ variable = "$incarnationNextCp", description = L["DruidFeralBarTextVariable_incarnationNextCp"], printInSettings = true, color = false },

			{ variable = "$suddenAmbushTime", description = L["DruidFeralBarTextVariable_suddenAmbushTime"], printInSettings = true, color = false },
			
			{ variable = "$apexPredatorsCravingTime", description = L["DruidFeralBarTextVariable_apexPredatorsCravingTime"], printInSettings = true, color = false },
			
			{ variable = "$tigersFuryTime", description = L["DruidFeralBarTextVariable_tigersFuryTime"], printInSettings = true, color = false },
			{ variable = "$tigersFuryCooldownTime", description = L["DruidFeralBarTextVariable_tigersFuryCooldownTime"], printInSettings = true, color = false },

			{ variable = "$predatorRevealedTime", description = L["DruidFeralBarTextVariable_predatorRevealedTime"], printInSettings = true, color = false },
			{ variable = "$predatorRevealedTicks", description = L["DruidFeralBarTextVariable_predatorRevealedTicks"], printInSettings = true, color = false },
			{ variable = "$predatorRevealedTickTime", description = L["DruidFeralBarTextVariable_predatorRevealedTickTime"], printInSettings = true, color = false },
			{ variable = "$predatorRevealedNextCp", description = L["DruidFeralBarTextVariable_predatorRevealedNextCp"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}

		specCache.feral.spells = spells
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
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

			{ variable = "#efflorescence", icon = spells.efflorescence.icon, description = spells.efflorescence.name, printInSettings = true },
			{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
			{ variable = "#incarnation", icon = spells.incarnationTreeOfLife.icon, description = spells.incarnationTreeOfLife.name, printInSettings = true },
			{ variable = "#reforestation", icon = spells.reforestation.icon, description = spells.reforestation.name, printInSettings = true },
			
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = spells.moonfire.name, printInSettings = true },
			{ variable = "#sunfire", icon = spells.sunfire.icon, description = spells.sunfire.name, printInSettings = true },			
			
			{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
			{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

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
			{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
			{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
			{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
			{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
			{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
			{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
			{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
			{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
			{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
			{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
			{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
			{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
			{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

			{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
			{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
			{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
			{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
			{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
			{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
			{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
			{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

			{ variable = "$mana", description = L["DruidRestorationBarTextVariable_mana"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$manaPercent", description = L["DruidRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
			{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
			{ variable = "$manaMax", description = L["DruidRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["DruidRestorationBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["DruidRestorationBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$manaPlusCasting", description = L["DruidRestorationBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$manaPlusPassive", description = L["DruidRestorationBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$manaTotal", description = L["DruidRestorationBarTextVariable_manaTotal"], printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },

			{ variable = "$incarnationTime", description = L["DruidRestorationBarTextVariable_incarnationTime"], printInSettings = false, color = false },

			{ variable = "$reforestationStacks", description = L["DruidRestorationBarTextVariable_reforestationStacks"], printInSettings = false, color = false },

			{ variable = "$sunfireCount", description = L["DruidRestorationBarTextVariable_sunfireCount"], printInSettings = true, color = false },
			{ variable = "$sunfireTime", description = L["DruidRestorationBarTextVariable_sunfireTime"], printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = L["DruidRestorationBarTextVariable_moonfireCount"], printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = L["DruidRestorationBarTextVariable_moonfireTime"], printInSettings = true, color = false },
			
			{ variable = "$bowMana", description = L["DruidRestorationBarTextVariable_bowMana"], printInSettings = true, color = false },
			{ variable = "$bowTime", description = L["DruidRestorationBarTextVariable_bowTime"], printInSettings = true, color = false },
			{ variable = "$bowTicks", description = L["DruidRestorationBarTextVariable_bowTicks"], printInSettings = true, color = false },

			{ variable = "$sohMana", description = L["DruidRestorationBarTextVariable_sohMana"], printInSettings = true, color = false },
			{ variable = "$sohTime", description = L["DruidRestorationBarTextVariable_sohTime"], printInSettings = true, color = false },
			{ variable = "$sohTicks", description = L["DruidRestorationBarTextVariable_sohTicks"], printInSettings = true, color = false },

			{ variable = "$innervateMana", description = L["DruidRestorationBarTextVariable_innervateMana"], printInSettings = true, color = false },
			{ variable = "$innervateTime", description = L["DruidRestorationBarTextVariable_innervateTime"], printInSettings = true, color = false },
									
			{ variable = "$mrMana", description = L["DruidRestorationBarTextVariable_mrMana"], printInSettings = true, color = false },
			{ variable = "$mrTime", description = L["DruidRestorationBarTextVariable_mrTime"], printInSettings = true, color = false },

			{ variable = "$mttMana", description = L["DruidRestorationBarTextVariable_mttMana"], printInSettings = true, color = false },
			{ variable = "$mttTime", description = L["DruidRestorationBarTextVariable_mttTime"], printInSettings = true, color = false },

			{ variable = "$channeledMana", description = L["DruidRestorationBarTextVariable_channeledMana"], printInSettings = true, color = false },

			{ variable = "$potionOfChilledClarityMana", description = L["DruidRestorationBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = L["DruidRestorationBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

			{ variable = "$potionOfFrozenFocusTicks", description = L["DruidRestorationBarTextVariable_potionOfFrozenFocusTicks"], printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = L["DruidRestorationBarTextVariable_potionOfFrozenFocusTime"], printInSettings = true, color = false },
			
			{ variable = "$potionCooldown", description = L["DruidRestorationBarTextVariable_potionCooldown"], printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = L["DruidRestorationBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

			{ variable = "$efflorescenceTime", description = L["DruidRestorationBarTextVariable_efflorescenceTime"], printInSettings = true, color = false },

			{ variable = "$clearcastingTime", description = L["DruidRestorationBarTextVariable_clearcastingTime"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}

		specCache.restoration.spells = spells
	end

	local function GetCurrentMoonSpell()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local moon = snapshotData.snapshots[spells.newMoon.id]
		local currentTime = GetTime()
		if talents:IsTalentActive(TRB.Data.spells.newMoon) and (moon.attributes.checkAfter == nil or currentTime >= moon.attributes.checkAfter) then
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
	
	local function CalculateAbilityResourceValue(resource, threshold, relentlessPredator)
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local modifier = 1.0
		local specId = GetSpecialization()

		if specId == 2 then
			if snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				modifier = modifier * TRB.Data.spells.incarnationAvatarOfAshamane.resourceModifier
			end
			
			if relentlessPredator and talents:IsTalentActive(TRB.Data.spells.relentlessPredator) then
				modifier = modifier * TRB.Data.spells.relentlessPredator.resourceModifier
			end
		end

		return resource * modifier
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		---@type TRB.Classes.TargetData
		local targetData = snapshotData.targetData
		targetData:UpdateTrackedSpells(currentTime)
	end

	local function TargetsCleanup(clearAll)
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local targetData = snapshotData.targetData
		local specId = GetSpecialization()

		if specId == 1 then
			targetData:Cleanup(clearAll)
		elseif specId == 2 then
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
			TRB.Frames.resource2ContainerFrame:Hide()
		end

		TRB.Functions.Class:CheckCharacter()
		TRB.Functions.Bar:Construct(settings)

		if specId == 1 or specId == 2 or specId == 4 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function GetBerserkRemainingTime()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		if talents:IsTalentActive(TRB.Data.spells.incarnationAvatarOfAshamane) then
			return snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].cooldown.remaining
		else
			return snapshotData.snapshots[spells.berserk.id].cooldown.remaining
		end
	end

	local function GetEclipseRemainingTime()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
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
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshotValue = 1.0

		if bonuses.tigersFury == true and snapshotData.snapshots[spells.tigersFury.id].buff.isActive then
			local tfBonus = spells.carnivorousInstinct.modifierPerStack * talents.talents[TRB.Data.spells.carnivorousInstinct.id].currentRank

			snapshotValue = snapshotValue * (TRB.Data.spells.tigersFury.modifier + tfBonus)
		end

		if bonuses.momentOfClarity == true and talents:IsTalentActive(TRB.Data.spells.momentOfClarity) == true and ((snapshotData.snapshots[spells.clearcasting.id].buff.applications ~= nil and snapshotData.snapshots[spells.clearcasting.id].buff.applications > 0) or snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(nil, true) > 0) then
			snapshotValue = snapshotValue * TRB.Data.spells.momentOfClarity.modifier
		end

		if bonuses.bloodtalons == true and talents:IsTalentActive(TRB.Data.spells.bloodtalons) == true and ((snapshotData.snapshots[spells.bloodtalons.id].buff.applications ~= nil and snapshotData.snapshots[spells.bloodtalons.id].buff.applications > 0) or snapshotData.snapshots[spells.bloodtalons.id].buff:GetRemainingTime(nil, true) > 0) then
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
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
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
		local resourcePrecision = specSettings.resourcePrecision or 0
		local currentAstralPower = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(normalizedAstralPower, resourcePrecision, "floor"))
		--$casting
		local castingAstralPower = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
		--$passive
		local _passiveAstralPower = snapshotData.snapshots[spells.furyOfElune.id].buff.resource + snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource
		if talents:IsTalentActive(spells.naturesBalance) then
			if UnitAffectingCombat("player") then
				_passiveAstralPower = _passiveAstralPower + spells.naturesBalance.resource
			elseif normalizedAstralPower < 50 then
				_passiveAstralPower = _passiveAstralPower + spells.naturesBalance.outOfCombatResource
			end
		end

		local passiveAstralPower = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveAstralPower, resourcePrecision, "ceil"))
		--$astralPowerTotal
		local _astralPowerTotal = math.min(_passiveAstralPower + snapshotData.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerTotal = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerTotal, resourcePrecision, "floor"))
		--$astralPowerPlusCasting
		local _astralPowerPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusCasting = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerPlusCasting, resourcePrecision, "floor"))
		--$astralPowerPlusPassive
		local _astralPowerPlusPassive = math.min(_passiveAstralPower + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusPassive = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerPlusPassive, resourcePrecision, "floor"))

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
					moonfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_moonfireTime))
				else
					moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_moonfireTime))
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end

			if target ~= nil and target.spells[spells.stellarFlare.id].active then
				if _stellarFlareTime > (TRB.Data.character.pandemicModifier * spells.stellarFlare.pandemicTime) then
					stellarFlareCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_stellarFlareTime))
				else
					stellarFlareCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_stellarFlareTime))
				end
			else
				stellarFlareCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _stellarFlareCount)
				stellarFlareTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end

			if target ~= nil and target.spells[spells.sunfire.id].active then
				if _sunfireTime > (TRB.Data.character.pandemicModifier * spells.sunfire.pandemicTime) then
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_sunfireTime))
				else
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_sunfireTime))
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end
		else
			sunfireTime = TRB.Functions.BarText:TimerPrecision(_sunfireTime)
			moonfireTime = TRB.Functions.BarText:TimerPrecision(_moonfireTime)
			stellarFlareTime = TRB.Functions.BarText:TimerPrecision(_stellarFlareTime)
		end


		--$statweaverTime
		local _starweaverTime = 0
		local _starweaver = false
		local _starweaversWarp = false
		local _starweaversWeft = false

		if snapshotData.snapshots[spells.starweaversWarp.id].buff.isActive then
			_starweaverTime = snapshotData.snapshots[spells.starweaversWarp.id].buff:GetRemainingTime(currentTime)
			_starweaver = true
			_starweaversWarp = true
		elseif snapshotData.snapshots[spells.starweaversWarp.id].buff.isActive then
			_starweaverTime = snapshotData.snapshots[spells.starweaversWeft.id].buff:GetRemainingTime(currentTime)
			_starweaver = true
			_starweaversWeft = true
		end
		local starweaverTime = TRB.Functions.BarText:TimerPrecision(_starweaverTime)

		----------
		--$foeAstralPower
		local foeAstralPower = snapshotData.snapshots[spells.furyOfElune.id].buff.resource
		--$foeTicks
		local foeTicks = snapshotData.snapshots[spells.furyOfElune.id].buff.ticks
		--$foeTime
		local _foeTime = snapshotData.snapshots[spells.furyOfElune.id].buff:GetRemainingTime(currentTime)
		local foeTime = TRB.Functions.BarText:TimerPrecision(_foeTime)
		
		----------
		--$foeAstralPower
		local sunderedFirmamentAstralPower = snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource
		--$foeTicks
		local sunderedFirmamentTicks = snapshotData.snapshots[spells.sunderedFirmament.id].buff.ticks
		--$foeTime
		local _sunderedFirmamentTime = snapshotData.snapshots[spells.sunderedFirmament.id].buff:GetRemainingTime(currentTime)
		local sunderedFirmamentTime = TRB.Functions.BarText:TimerPrecision(_sunderedFirmamentTime)
		
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
			moonAstralPower = spells[snapshotData.snapshots[spells.newMoon.id].attributes.currentKey].resource

			if snapshotData.snapshots[spells.newMoon.id].cooldown.onCooldown and snapshotData.snapshots[spells.newMoon.id].cooldown.charges < snapshotData.snapshots[spells.newMoon.id].cooldown.maxCharges then
				_moonCooldown = snapshotData.snapshots[spells.newMoon.id].cooldown:GetRemainingTime(currentTime)
				_moonCooldownTotal = snapshotData.snapshots[spells.newMoon.id].cooldown.remainingTotal
			end
		end
		local moonCooldown = TRB.Functions.BarText:TimerPrecision(_moonCooldown)
		local moonCooldownTotal = TRB.Functions.BarText:TimerPrecision(_moonCooldownTotal)

		--$eclipseTime
		local _eclispeTime, eclipseIcon = GetEclipseRemainingTime()
		local eclipseTime = TRB.Functions.BarText:TimerPrecision(_eclispeTime)

		--#starweaver

		local starweaverIcon = spells.starweaversWarp.icon
		if snapshotData.snapshots[spells.starweaversWeft.id].buff.isActive then
			starweaverIcon = spells.starweaversWeft.icon
		end

		--$pulsar variables
		local pulsarCollected = snapshotData.snapshots[spells.primordialArcanicPulsar.id].buff.customProperties["currentResource"]
		local _pulsarCollectedPercent = pulsarCollected / spells.primordialArcanicPulsar.maxResource
		local pulsarCollectedPercent = string.format("%.1f", TRB.Functions.Number:RoundTo(_pulsarCollectedPercent * 100, 1))
		local pulsarRemaining = spells.primordialArcanicPulsar.maxResource - pulsarCollected
		local _pulsarRemainingPercent = pulsarRemaining / spells.primordialArcanicPulsar.maxResource
		local pulsarRemainingPercent = string.format("%.1f", TRB.Functions.Number:RoundTo(_pulsarRemainingPercent * 100, 1))
		local pulsarStarsurgeCount = TRB.Functions.Number:RoundTo(pulsarRemaining / -spells.starsurge.resource, 0, ceil, true)
		local pulsarStarfallCount = TRB.Functions.Number:RoundTo(pulsarRemaining / -spells.starfall.resource, 0, ceil, true)
		
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
		lookup["$starweaver"] = ""
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
		lookup["$astralPowerTotal"] = astralPowerTotal
		lookup["$astralPowerMax"] = TRB.Data.character.maxResource
		lookup["$astralPower"] = currentAstralPower
		lookup["$resourcePlusCasting"] = astralPowerPlusCasting
		lookup["$astralPowerPlusCasting"] = astralPowerPlusCasting
		lookup["$resourcePlusPassive"] = astralPowerPlusPassive
		lookup["$astralPowerPlusPassive"] = astralPowerPlusPassive
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
		lookupLogic["$starweaver"] = _starweaver
		lookupLogic["$starweaverTime"] = _starweaverTime
		lookupLogic["$starweaversWarp"] = _starweaversWarp
		lookupLogic["$starweaversWeft"] = _starweaversWeft
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
		lookupLogic["$astralPowerTotal"] = _astralPowerTotal
		lookupLogic["$astralPowerMax"] = TRB.Data.character.maxResource
		lookupLogic["$astralPower"] = normalizedAstralPower
		lookupLogic["$resourcePlusCasting"] = _astralPowerPlusCasting
		lookupLogic["$astralPowerPlusCasting"] = _astralPowerPlusCasting
		lookupLogic["$resourcePlusPassive"] = _astralPowerPlusPassive
		lookupLogic["$astralPowerPlusPassive"] = _astralPowerPlusPassive
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
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
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
		snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

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
					if spell ~= nil and spell.resource ~= nil and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell.resource >= snapshotData.attributes.resource then
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
				_regenEnergy = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
			else
				_regenEnergy = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
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
				ripTime = string.format("|c%s%s|r", ripColor, TRB.Functions.BarText:TimerPrecision(_ripTime))
			else
				ripCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				ripCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				ripTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
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
				rakeTime = string.format("|c%s%s|r", rakeColor, TRB.Functions.BarText:TimerPrecision(_rakeTime))
			else
				rakeCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				rakeCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				rakeTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
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
				thrashTime = string.format("|c%s%s|r", thrashColor, TRB.Functions.BarText:TimerPrecision(_thrashTime))
			else
				thrashCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				thrashCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				thrashTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end

			if talents:IsTalentActive(spells.lunarInspiration) == true and target ~= nil and target.spells[spells.moonfire.id].active then
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
				moonfireTime = string.format("|c%s%s|r", moonfireColor, TRB.Functions.BarText:TimerPrecision(_moonfireTime))
			else
				moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				moonfireCurrent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, 0)
				moonfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end
		else
			ripTime = TRB.Functions.BarText:TimerPrecision(_ripTime)
			rakeTime = TRB.Functions.BarText:TimerPrecision(_rakeTime)
			thrashTime = TRB.Functions.BarText:TimerPrecision(_thrashTime)

			ripSnapshot = TRB.Functions.Number:RoundTo(100 * _ripSnapshot, 0, "floor", true)
			rakeSnapshot = TRB.Functions.Number:RoundTo(100 * _rakeSnapshot, 0, "floor", true)
			thrashSnapshot = TRB.Functions.Number:RoundTo(100 * _thrashSnapshot, 0, "floor", true)

			ripCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor", true)
			rakeCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor", true)
			thrashCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor", true)

			ripPercent = TRB.Functions.Number:RoundTo(100 * _ripPercent, 0, "floor", true)
			rakePercent = TRB.Functions.Number:RoundTo(100 * _rakePercent, 0, "floor", true)
			thrashPercent = TRB.Functions.Number:RoundTo(100 * _thrashPercent, 0, "floor", true)

			if talents:IsTalentActive(spells.lunarInspiration) == true then
				moonfireTime = TRB.Functions.BarText:TimerPrecision(_moonfireTime)
				moonfireSnapshot = TRB.Functions.Number:RoundTo(100 * _moonfireSnapshot, 0, "floor", true)
				moonfireCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor", true)
				moonfirePercent = TRB.Functions.Number:RoundTo(100 * _moonfirePercent, 0, "floor", true)
			else
				moonfireTime = TRB.Functions.BarText:TimerPrecision(0)
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

		local brutalSlashCooldown = TRB.Functions.BarText:TimerPrecision(_brutalSlashCooldown)
		local brutalSlashCooldownTotal = TRB.Functions.BarText:TimerPrecision(_brutalSlashCooldownTotal)
		
		--$bloodtalonsStacks
		local bloodtalonsStacks = snapshotData.snapshots[spells.bloodtalons.id].buff.applications or 0

		--$bloodtalonsTime
		local _bloodtalonsTime = snapshotData.snapshots[spells.bloodtalons.id].buff:GetRemainingTime(currentTime)
		local bloodtalonsTime = TRB.Functions.BarText:TimerPrecision(_bloodtalonsTime)
		
		--$tigersFuryTime
		local _tigersFuryTime = snapshotData.snapshots[spells.tigersFury.id].buff:GetRemainingTime(currentTime)
		local tigersFuryTime = TRB.Functions.BarText:TimerPrecision(_tigersFuryTime)
		
		--$tigersFuryCooldownTime
		local _tigersFuryCooldownTime = snapshotData.snapshots[spells.tigersFury.id].cooldown:GetRemainingTime(currentTime)
		local tigersFuryCooldownTime = TRB.Functions.BarText:TimerPrecision(_tigersFuryCooldownTime)

		--$suddenAmbushTime
		local _suddenAmbushTime = snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)
		local suddenAmbushTime = TRB.Functions.BarText:TimerPrecision(_suddenAmbushTime)
		
		--$clearcastingStacks
		local clearcastingStacks = snapshotData.snapshots[spells.clearcasting.id].buff.applications

		--$clearcastingTime
		local _clearcastingTime = snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		local clearcastingTime = TRB.Functions.BarText:TimerPrecision(_clearcastingTime)

		--$berserkTime (and $incarnationTime)
		local _berserkTime = GetBerserkRemainingTime()
		local berserkTime = TRB.Functions.BarText:TimerPrecision(_berserkTime)

		--$incarnationTicks 
		local _incarnationTicks = snapshotData.snapshots[spells.berserk.id].attributes.ticks
		
		--$incarnationTickTime
		local _incarnationTickTime = snapshotData.snapshots[spells.berserk.id].attributes.untilNextTick
		local incarnationTickTime = TRB.Functions.BarText:TimerPrecision(_incarnationTickTime)

		--$apexPredatorsCravingTime
		local _apexPredatorsCravingTime = snapshotData.snapshots[spells.apexPredatorsCraving.id].buff:GetRemainingTime(currentTime)
		local apexPredatorsCravingTime = TRB.Functions.BarText:TimerPrecision(_apexPredatorsCravingTime)
		
		--$predatorRevealedTime
		local _predatorRevealedTime = snapshotData.snapshots[spells.predatorRevealed.id].buff:GetRemainingTime(currentTime)
		local predatorRevealedTime = TRB.Functions.BarText:TimerPrecision(_predatorRevealedTime)

		--$predatorRevealedTicks 
		local _predatorRevealedTicks = snapshotData.snapshots[spells.predatorRevealed.id].attributes.ticks
		
		--$predatorRevealedTickTime
		local _predatorRevealedTickTime = snapshotData.snapshots[spells.predatorRevealed.id].attributes.untilNextTick
		local predatorRevealedTickTime = TRB.Functions.BarText:TimerPrecision(_predatorRevealedTickTime)

		--$incarnationNextCp
		local incarnationNextCp = 0
		
		--$predatorRevealedNextCp
		local predatorRevealedNextCp = 0

		for x = 1, TRB.Data.character.maxResource2 do
			if snapshotData.attributes.resource2 < x then
				if incarnationNextCp == 0 and _incarnationTicks > 0 and (_incarnationTickTime <= _predatorRevealedTickTime or predatorRevealedNextCp > 0 or _predatorRevealedTicks == 0) then
					incarnationNextCp = x
				elseif _predatorRevealedTickTime > 0 and predatorRevealedNextCp == 0 then
					predatorRevealedNextCp = x
				end
			end
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
		lookup["#apexPredatorsCraving"] = spells.apexPredatorsCraving.icon
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
		lookup["$incarnationTicks"] = _incarnationTicks
		lookup["$incarnationTickTime"] = incarnationTickTime
		lookup["$incarnationNextCp"] = incarnationNextCp

		lookup["$apexPredatorsCravingTime"] = apexPredatorsCravingTime
		lookup["$tigersFuryTime"] = tigersFuryTime
		lookup["$tigersFuryCooldownTime"] = tigersFuryCooldownTime

		lookup["$predatorRevealedTime"] = predatorRevealedTime
		lookup["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookup["$predatorRevealedTickTime"] = predatorRevealedTickTime
		lookup["$predatorRevealedNextCp"] = predatorRevealedNextCp
		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$energyTotal"] = energyTotal
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$energy"] = currentEnergy
		lookup["$resourcePlusCasting"] = energyPlusCasting
		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$resourcePlusPassive"] = energyPlusPassive
		lookup["$energyPlusPassive"] = energyPlusPassive
		lookup["$resourceTotal"] = energyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentEnergy
		lookup["$casting"] = castingEnergy

		if TRB.Data.character.maxResource == snapshotData.attributes.resource then
			lookup["$passive"] = passiveEnergyMinusRegen
		else
			lookup["$passive"] = passiveEnergy
		end

		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$resourceRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		lookup["$comboPoints"] = snapshotData.attributes.resource2
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
		lookupLogic["$incarnationTicks"] = _incarnationTicks
		lookupLogic["$incarnationTickTime"] = _incarnationTickTime
		lookupLogic["$incarnationNextCp"] = incarnationNextCp
		lookupLogic["$apexPredatorsCravingTime"] = _apexPredatorsCravingTime
		lookupLogic["$tigersFuryTime"] = _tigersFuryTime
		lookupLogic["$tigersFuryCooldownTime"] = _tigersFuryCooldownTime
		lookupLogic["$predatorRevealedTime"] = _predatorRevealedTime
		lookupLogic["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookupLogic["$predatorRevealedTickTime"] = _predatorRevealedTickTime
		lookupLogic["$predatorRevealedNextCp"] = predatorRevealedNextCp
		lookupLogic["$energyPlusCasting"] = _energyPlusCasting
		lookupLogic["$energyTotal"] = _energyTotal
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$energyPlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$energyPlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal

		if TRB.Data.character.maxResource == snapshotData.attributes.resource then
			lookupLogic["$passive"] = _passiveEnergyMinusRegen
		else
			lookupLogic["$passive"] = _passiveEnergy
		end

		lookupLogic["$regen"] = _regenEnergy
		lookupLogic["$regenEnergy"] = _regenEnergy
		lookupLogic["$resourceRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$inStealth"] = ""
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Restoration()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
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
		local sohTime = TRB.Functions.BarText:TimerPrecision(_sohTime)

		local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
		--$innervateMana
		local _innervateMana = innervate.mana
		local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
		--$innervateTime
		local _innervateTime = innervate.buff:GetRemainingTime(currentTime)
		local innervateTime = TRB.Functions.BarText:TimerPrecision(_innervateTime)

		local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		--$potionOfChilledClarityMana
		local _potionOfChilledClarityMana = potionOfChilledClarity.mana
		local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
		--$potionOfChilledClarityTime
		local _potionOfChilledClarityTime = potionOfChilledClarity.buff:GetRemainingTime(currentTime)
		local potionOfChilledClarityTime = TRB.Functions.BarText:TimerPrecision(_potionOfChilledClarityTime)
		
		local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
		--$mttMana
		local _mttMana = manaTideTotem.mana
		local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
		--$mttTime
		local _mttTime = manaTideTotem.buff:GetRemainingTime(currentTime)
		local mttTime = TRB.Functions.BarText:TimerPrecision(_mttTime)
		
		local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
		--$mrMana
		local _mrMana = moltenRadiance.mana
		local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
		--$mrTime
		local _mrTime = moltenRadiance.buff.remaining
		local mrTime = TRB.Functions.BarText:TimerPrecision(_mrTime)
		
		local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
		--$bowMana
		local _bowMana = blessingOfWinter.mana
		local bowMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_bowMana, manaPrecision, "floor", true))
		--$bowTime
		local _bowTime = blessingOfWinter.buff.remaining
		local bowTime = TRB.Functions.BarText:TimerPrecision(_bowTime)
		--$bowTicks
		local _bowTicks = blessingOfWinter.buff.ticks or 0
		local bowTicks = string.format("%.0f", _bowTicks)

		--$potionCooldownSeconds
		local _potionCooldown = snapshots[spells.aeratedManaPotionRank1.id].cooldown.remaining
		local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
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
		local potionOfFrozenFocusTime = TRB.Functions.BarText:TimerPrecision(_potionOfFrozenFocusTime)

		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana + _bowMana
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
		local efflorescenceTime = TRB.Functions.BarText:TimerPrecision(_efflorescenceTime)
	
		--$clearcastingTime
		local _clearcastingTime = snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		local clearcastingTime = TRB.Functions.BarText:TimerPrecision(_clearcastingTime)

		--$incarnationTime
		local _incarnationTime = snapshots[spells.incarnationTreeOfLife.id].buff:GetRemainingTime(currentTime)
		local incarnationTime = TRB.Functions.BarText:TimerPrecision(_incarnationTime)

		--$reforestationStacks
		local reforestationStacks = snapshots[spells.reforestation.id].buff.applications

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
					moonfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_moonfireTime))
				else
					moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_moonfireTime))
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end

			if target ~= nil and target.spells[spells.sunfire.id].active then
				if _sunfireTime > spells.sunfire.pandemicTime then
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_sunfireTime))
				else
					sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_sunfireTime))
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end
		else
			sunfireTime = TRB.Functions.BarText:TimerPrecision(_sunfireTime)
			moonfireTime = TRB.Functions.BarText:TimerPrecision(_moonfireTime)
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
		lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
		lookup["#bow"] = spells.blessingOfWinter.icon
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#reforestation"] = spells.reforestation.icon
		lookup["$manaTotal"] = manaTotal
		lookup["$manaMax"] = manaMax
		lookup["$mana"] = currentMana
		lookup["$resourcePlusCasting"] = manaPlusCasting
		lookup["$manaPlusCasting"] = manaPlusCasting
		lookup["$resourcePlusPassive"] = manaPlusPassive
		lookup["$manaPlusPassive"] = manaPlusPassive
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
		lookup["$bowMana"] = bowMana
		lookup["$bowTime"] = bowTime
		lookup["$bowTicks"] = bowTicks
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
		lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
		lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$manaTotal"] = _manaTotal
		lookupLogic["$manaMax"] = maxResource
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
		lookupLogic["$manaPlusCasting"] = _manaPlusCasting
		lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
		lookupLogic["$manaPlusPassive"] = _manaPlusPassive
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
		lookupLogic["$bowMana"] = _bowMana
		lookupLogic["$bowTime"] = _bowTime
		lookupLogic["$bowTicks"] = _bowTicks
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
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local currentTime = GetTime()
		snapshotData.casting.startTime = currentTime
		snapshotData.casting.resourceRaw = spell.resource
		snapshotData.casting.resourceFinal = spell.resource
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
						if talents:IsTalentActive(spells.wildSurges) then
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.wildSurges.modifier
						end
						if talents:IsTalentActive(spells.soulOfTheForest) and spells.eclipseSolar.isActive then
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * (1 + spells.soulOfTheForest.modifier.wrath)
						end
					elseif currentSpellId == spells.starfire.id then
						FillSnapshotDataCasting_Balance(spells.starfire)
						if talents:IsTalentActive(spells.wildSurges) then
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
					--See druid implementation for handling channeled spells
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

		local rattleTheStarsModifier = 1

		if talents:IsTalentActive(spells.rattleTheStars) then
			rattleTheStarsModifier = 1+spells.rattleTheStars.modifier
		end

		local incarnationChosenOfEluneStarfallModifier = 0
		local incarnationChosenOfEluneStarsurgeModifier = 0

		if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and talents:IsTalentActive(spells.elunesGuidance) then
			incarnationChosenOfEluneStarfallModifier = spells.elunesGuidance.modifierStarfall
			incarnationChosenOfEluneStarsurgeModifier = spells.elunesGuidance.modifierStarsurge
		end

		TRB.Data.character.starsurgeThreshold = (-spells.starsurge.resource + incarnationChosenOfEluneStarsurgeModifier) * rattleTheStarsModifier
		TRB.Data.character.starfallThreshold = (-spells.starfall.resource + incarnationChosenOfEluneStarfallModifier) * rattleTheStarsModifier

		snapshotData.snapshots[spells.moonkinForm.id].buff:Refresh()
		snapshotData.snapshots[spells.furyOfElune.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.sunderedFirmament.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.celestialAlignment.id].buff:Refresh()
		snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff:Refresh()
		snapshotData.snapshots[spells.eclipseSolar.id].buff:Refresh()
		snapshotData.snapshots[spells.eclipseLunar.id].buff:Refresh()
		snapshotData.snapshots[spells.starfall.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.primordialArcanicPulsar.id].buff:Refresh()
	end

	local function UpdateSnapshot_Feral()
		UpdateSnapshot()
		UpdateBerserkIncomingComboPoints()
		UpdatePredatorRevealed()
		
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local currentTime = GetTime()

		snapshotData.attributes.bleeds.moonfire = GetCurrentSnapshot(spells.moonfire.bonuses)
		snapshotData.attributes.bleeds.rake = GetCurrentSnapshot(spells.rake.bonuses)
		snapshotData.attributes.bleeds.rip = GetCurrentSnapshot(spells.rip.bonuses)
		snapshotData.attributes.bleeds.thrash = GetCurrentSnapshot(spells.thrash.bonuses)

		snapshotData.snapshots[spells.clearcasting.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.suddenAmbush.id].buff:GetRemainingTime(currentTime)
		
		-- Incarnation: King of the Jungle doesn't show up in-game as a combat log event. Check for it manually instead.
		if talents:IsTalentActive(spells.incarnationAvatarOfAshamane) then
			snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff:Refresh()
		end

		snapshotData.snapshots[spells.tigersFury.id].buff:Refresh()
		snapshotData.snapshots[spells.tigersFury.id].cooldown:Refresh(true)

		snapshotData.snapshots[spells.feralFrenzy.id].cooldown:Refresh()
		snapshotData.snapshots[spells.maim.id].cooldown:Refresh()
		
		if talents:IsTalentActive(spells.brutalSlash) then
			snapshotData.snapshots[spells.brutalSlash.id].cooldown:Refresh()
		end
		
		if talents:IsTalentActive(spells.bloodtalons) then
			snapshotData.snapshots[spells.bloodtalons.id].cooldown:Refresh()
		end
	end

	local function UpdateSnapshot_Restoration()
		UpdateSnapshot()

		local spells = TRB.Data.spells
		local _

		---@type table<integer, TRB.Classes.Snapshot>
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

		local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
		blessingOfWinter:Update()
		
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
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.druid
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

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

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentResource + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					local passiveValue = 0
					if specSettings.bar.showPassive then
						passiveValue = snapshotData.snapshots[spells.furyOfElune.id].buff.resource + snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource

						if talents:IsTalentActive(spells.naturesBalance) then
							if affectingCombat then
								passiveValue = passiveValue + spells.naturesBalance.resource
							elseif currentResource < 50 then
								passiveValue = passiveValue + spells.naturesBalance.outOfCombatResource
							end
						end

						if talents:IsTalentActive(spells.naturesBalance) and (affectingCombat or (not affectingCombat and currentResource < 50)) then
						else
							passiveValue = snapshotData.snapshots[spells.furyOfElune.id].buff.resource + snapshotData.snapshots[spells.sunderedFirmament.id].buff.resource
						end
					end

					if castingBarValue < currentResource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local rattleTheStarsModifier = 1
					
					if talents:IsTalentActive(spells.rattleTheStars) then
						rattleTheStarsModifier = 1 + spells.rattleTheStars.modifier
					end

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							pairOffset = (spell.thresholdId - 1) * 3

							local resourceAmount = spell.resource * rattleTheStarsModifier
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.settingKey == spells.starsurge.settingKey then
									local redrawThreshold = false

									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and talents:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - spells.elunesGuidance.modifierStarsurge
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.resourceMod
										redrawThreshold = true
									end

									if redrawThreshold then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)
									end
									
									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
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
									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and talents:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - (spells.elunesGuidance.modifierStarsurge * 2)
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.resourceMod
										redrawThreshold = true
										touchTheCosmosMod = spells.touchTheCosmos.resourceMod
									end

									if redrawThreshold then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
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
									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and talents:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - (spells.elunesGuidance.modifierStarsurge * 3)
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.resourceMod
										redrawThreshold = true
										touchTheCosmosMod = spells.touchTheCosmos.resourceMod
									end

									if redrawThreshold then	
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
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
									if snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive and talents:IsTalentActive(spells.elunesGuidance) then
										resourceAmount = resourceAmount - spells.elunesGuidance.modifierStarfall
										redrawThreshold = true
									end

									if snapshotData.snapshots[spells.touchTheCosmos.id].buff.isActive then
										resourceAmount = resourceAmount - spells.touchTheCosmos.resourceMod
										redrawThreshold = true
									end

									if redrawThreshold then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
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
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
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
					local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
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
						castingBarValue = currentResource + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					if castingBarValue < currentResource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local resourceAmount = CalculateAbilityResourceValue(spell.resource, true, spell.relentlessPredator)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

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

								if spell.id == spells.moonfire.id and not talents:IsTalentActive(spells.lunarInspiration) then
									showThreshold = false
								end
							elseif spell.isClearcasting and snapshotData.snapshots[spells.clearcasting.id].buff.applications ~= nil and snapshotData.snapshots[spells.clearcasting.id].buff.applications > 0 then
								if spell.id == spells.brutalSlash.id then
									if not talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges > 0 then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									end
								elseif spell.id == spells.swipe.id then
									if talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									else
										thresholdColor = specSettings.colors.threshold.over
									end
								else
									thresholdColor = specSettings.colors.threshold.over
								end
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.ferociousBite.id and spell.settingKey == "ferociousBite" then
									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, math.min(math.max(-resourceAmount, currentResource), -CalculateAbilityResourceValue(spells.ferociousBite.resourceMax, true, true)), TRB.Data.character.maxResource)
									
									if currentResource >= -resourceAmount or snapshotData.snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.ferociousBiteMinimum.id and spell.settingKey == "ferociousBiteMinimum" then
									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)
									
									if currentResource >= -resourceAmount or snapshotData.snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.ferociousBiteMaximum.id and spell.settingKey == "ferociousBiteMaximum" then
									if currentResource >= -resourceAmount or snapshotData.snapshots[spells.apexPredatorsCraving.id].buff.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.moonfire.id then
									if not talents:IsTalentActive(spells.lunarInspiration) then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.swipe.id then
									if talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.brutalSlash.id then
									if not talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges == 0 then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.bloodtalons.id then
									--TODO: How much resource is required to start this? Then do we move it?
								end
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
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

					if snapshotData.attributes.resource2 == 5 and currentResource >= -CalculateAbilityResourceValue(spells.ferociousBiteMaximum.resource, true, true) then
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
					local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		
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
				
					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = currentResource + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentResource, castingBarValue, specSettings, snapshotData.snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshotData.snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)
		
					local passiveValue, _ = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
		
					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < currentResource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
					
					local resourceBarColor = specSettings.colors.bar.base

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat and talents:IsTalentActive(spells.efflorescence) and not snapshotData.snapshots[spells.efflorescence.id].buff.isActive then
						resourceBarColor = specSettings.colors.bar.noEfflorescence
					elseif snapshotData.snapshots[spells.clearcasting.id].buff.isActive then
						resourceBarColor = specSettings.colors.bar.clearcasting
					elseif snapshotData.snapshots[spells.incarnationTreeOfLife.id].buff.isActive and (talents:IsTalentActive(spells.cenariusGuidance) or snapshotData.snapshots[spells.clearcasting.id].buff.isActive) then
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

						if useEndOfIncarnationColor and snapshotData.snapshots[spells.incarnationTreeOfLife.id].buff.remaining <= timeThreshold then
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
			local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

			local settings
			if specId == 1 then
				settings = TRB.Data.settings.druid.balance
			elseif specId == 2 then
				settings = TRB.Data.settings.druid.feral
			elseif specId == 4 then
				settings = TRB.Data.settings.druid.restoration
			end

			if entry.destinationGuid == TRB.Data.character.guid then
				if specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
					if settings.passiveGeneration.symbolOfHope and (entry.spellId == spells.symbolOfHope.tickId or entry.spellId == spells.symbolOfHope.id) then
						local symbolOfHope = snapshotData.snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
						local castByToken = UnitTokenFromGUID(entry.sourceGuid)
						symbolOfHope.buff:Initialize(entry.type, nil, castByToken)
					elseif settings.passiveGeneration.innervate and entry.spellId == spells.innervate.id then
						local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
						innervate.buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshotData.audio.innervateCue = false
						elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshotData.audio.innervateCue = false
						end
					elseif settings.passiveGeneration.manaTideTotem and entry.spellId == spells.manaTideTotem.id then
						local manaTideTotem = snapshotData.snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
						manaTideTotem:Initialize(entry.type)
					elseif entry.spellId == spells.moltenRadiance.id then
						local moltenRadiance = snapshotData.snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
						moltenRadiance.buff:Initialize(entry.type)
					elseif settings.passiveGeneration.blessingOfWinter and entry.spellId == spells.blessingOfWinter.id then
						local blessingOfWinter = snapshotData.snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
						blessingOfWinter.buff:Initialize(entry.type)
					end
				end
			end

			if entry.sourceGuid == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "balance" then
					if entry.spellId == spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					elseif entry.spellId == spells.stellarFlare.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					elseif entry.spellId == spells.sunfire.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					elseif entry.spellId == spells.furyOfElune.id then
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Fury of Elune
							snapshotData.snapshots[entry.spellId].buff:InitializeCustom(spells.furyOfElune.duration)
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						elseif entry.type == "SPELL_PERIODIC_ENERGIZE" then
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.sunderedFirmament.buffId then
						snapshotData.snapshots[spells.sunderedFirmament.id].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Fury of Elune
							snapshotData.snapshots[spells.sunderedFirmament.id].buff:UpdateTicks(currentTime)
						elseif entry.type == "SPELL_PERIODIC_ENERGIZE" then
							snapshotData.snapshots[spells.sunderedFirmament.id].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.eclipseSolar.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.eclipseLunar.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.celestialAlignment.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.incarnationChosenOfElune.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.starfall.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.starweaversWarp.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.starweaversWeft.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.newMoon.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].attributes.currententry.spellId = spells.halfMoon.id
							snapshotData.snapshots[entry.spellId].attributes.currentKey = "halfMoon"
							snapshotData.snapshots[entry.spellId].attributes.checkAfter = currentTime + 20
						end
					elseif entry.spellId == spells.halfMoon.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].attributes.currententry.spellId = spells.fullMoon.id
							snapshotData.snapshots[entry.spellId].attributes.currentKey = "fullMoon"
							snapshotData.snapshots[entry.spellId].attributes.checkAfter = currentTime + 20
						end
					elseif entry.spellId == spells.fullMoon.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							-- New Moon doesn't like to behave when we do this
							snapshotData.snapshots[entry.spellId].attributes.currententry.spellId = spells.newMoon.id
							snapshotData.snapshots[entry.spellId].attributes.currentKey = "newMoon"
							snapshotData.snapshots[entry.spellId].attributes.checkAfter = currentTime + 20
							spells.newMoon.currentIcon = select(3, GetSpellInfo(202767)) -- Use the old Legion artifact spell ID since New Moon's icon returns incorrect for several seconds after casting Full Moon
						end
					elseif entry.spellId == spells.touchTheCosmos.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "feral" then
					if entry.spellId == spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
							if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = GetCurrentSnapshot(spells.moonfire.bonuses)
								triggerUpdate = true
							elseif entry.type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif entry.spellId == spells.rake.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
							if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = GetCurrentSnapshot(spells.rake.bonuses)
								triggerUpdate = true
							elseif entry.type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif entry.spellId == spells.rip.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
							if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = GetCurrentSnapshot(spells.rip.bonuses)
								triggerUpdate = true
							elseif entry.type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif entry.spellId == spells.thrash.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
							if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = GetCurrentSnapshot(spells.thrash.bonuses)
								triggerUpdate = true
							elseif entry.type == "SPELL_AURA_REMOVED" then
								snapshotData.targetData.targets[entry.destinationGuid].spells[entry.spellId].snapshot = 0
								triggerUpdate = true
							end
						end
					elseif entry.spellId == spells.shadowmeld.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.prowl.id or entry.spellId == spells.prowl.idIncarnation then
						snapshotData.snapshots[spells.prowl.id].buff:Initialize(entry.type)
					elseif entry.spellId == spells.suddenAmbush.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_REMOVED" then
							snapshotData.snapshots[entry.spellId].attributes.endTimeLeeway = currentTime + 0.1
						end
					elseif entry.spellId == spells.berserk.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" or entry.type == "SPELL_AURA_REMOVED" then
							if entry.type == "SPELL_AURA_APPLIED" then
								snapshotData.snapshots[spells.berserk.id].attributes.lastTick = currentTime
							end
							UpdateBerserkIncomingComboPoints()
						end
					elseif entry.spellId == spells.incarnationAvatarOfAshamane.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" or entry.type == "SPELL_AURA_REMOVED" then
							if entry.type == "SPELL_AURA_APPLIED" then
								snapshotData.snapshots[spells.berserk.id].attributes.lastTick = currentTime
							end
							UpdateBerserkIncomingComboPoints()
						end
					elseif entry.spellId == spells.berserk.energizeId then
						if entry.type == "SPELL_ENERGIZE" then
							snapshotData.snapshots[spells.berserk.id].attributes.lastTick = currentTime
						end
					elseif entry.spellId == spells.clearcasting.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.tigersFury.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.bloodtalons.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						elseif entry.type == "SPELL_AURA_REMOVED" then
							snapshotData.snapshots[entry.spellId].attributes.endTimeLeeway = currentTime + 0.1
						end
					elseif entry.spellId == spells.apexPredatorsCraving.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
							if settings.audio.apexPredatorsCraving.enabled then
								PlaySoundFile(settings.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif entry.spellId == spells.predatorRevealed.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" or entry.type == "SPELL_AURA_REMOVED" then
							if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
								snapshotData.snapshots[spells.predatorRevealed.id].attributes.lastTick = currentTime
							end
							UpdatePredatorRevealed()
						end
					elseif entry.spellId == spells.predatorRevealed.energizeId then
						if entry.type == "SPELL_ENERGIZE" then
							snapshotData.snapshots[spells.predatorRevealed.id].attributes.lastTick = currentTime
						end
					elseif entry.spellId == spells.brutalSlash.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					end
				elseif specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then
					if entry.spellId == spells.potionOfFrozenFocusRank1.spellId or entry.spellId == spells.potionOfFrozenFocusRank2.spellId or entry.spellId == spells.potionOfFrozenFocusRank3.spellId then
						local channeledManaPotion = snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
						channeledManaPotion.buff:Initialize(entry.type)
					elseif entry.spellId == spells.potionOfChilledClarity.id then
						local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
						potionOfChilledClarity.buff:Initialize(entry.type)
					elseif entry.spellId == spells.efflorescence.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].buff:InitializeCustom(spells.efflorescence.duration)
						end
					elseif entry.spellId == spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					elseif entry.spellId == spells.sunfire.id then
						if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					elseif entry.spellId == spells.clearcasting.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.incarnationTreeOfLife.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.reforestation.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					end
				end
			end

			if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				targetData:Remove(entry.destinationGuid)
				RefreshTargetTracking()
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
			specCache.balance.talents:GetTalents()
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

			if TRB.Data.barConstructedForSpec ~= "balance" then
				talents = specCache.balance.talents
				TRB.Data.barConstructedForSpec = "balance"
				ConstructResourceBar(specCache.balance.settings)
			end
		elseif specId == 2 then
			specCache.feral.talents:GetTalents()
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
				talents = specCache.feral.talents
				TRB.Data.barConstructedForSpec = "feral"
				ConstructResourceBar(specCache.feral.settings)
			end
		elseif specId == 4 then
			specCache.restoration.talents:GetTalents()
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
				talents = specCache.restoration.talents
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
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local specId = GetSpecialization() or 0
		if classIndexId == 11 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
						TRB.Options:PortForwardSettings()

						local settings = TRB.Options.Druid.LoadDefaultSettings(false)

						if TwintopInsanityBarSettings.druid == nil or
							TwintopInsanityBarSettings.druid.balance == nil or
							TwintopInsanityBarSettings.druid.balance.displayText == nil then
							settings.druid.balance.displayText.barText = TRB.Options.Druid.BalanceLoadDefaultBarTextSimpleSettings()
						end

						if TwintopInsanityBarSettings.druid == nil or
							TwintopInsanityBarSettings.druid.feral == nil or
							TwintopInsanityBarSettings.druid.feral.displayText == nil then
							settings.druid.feral.displayText.barText = TRB.Options.Druid.FeralLoadDefaultBarTextSimpleSettings()
						end

						if TwintopInsanityBarSettings.druid == nil or
							TwintopInsanityBarSettings.druid.restoration == nil or
							TwintopInsanityBarSettings.druid.restoration.displayText == nil then
							settings.druid.restoration.displayText.barText = TRB.Options.Druid.RestorationLoadDefaultBarTextSimpleSettings()
						end

						TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
					else
						local settings = TRB.Options.Druid.LoadDefaultSettings(true)
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
							TRB.Data.settings.druid.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues("Restoration Druid", TRB.Data.settings.druid.restoration)
							
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
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.LunarPower)
			GetCurrentMoonSpell()
		elseif specId == 2 then
			TRB.Data.character.specName = "feral"
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
			local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
			local settings = TRB.Data.settings.druid.feral

			if settings ~= nil then
				if maxComboPoints ~= TRB.Data.character.maxResource2 then
					TRB.Data.character.maxResource2 = maxComboPoints
					TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
				end
			end

			if talents:IsTalentActive(TRB.Data.spells.circleOfLifeAndDeath) then
				TRB.Data.character.pandemicModifier = TRB.Data.spells.circleOfLifeAndDeath.modifier
			end
		elseif specId == 4 then
			TRB.Data.character.specName = "restoration"
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.Spell:FillSpellDataManaCost(TRB.Data.spells)

			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeMana = ""
						
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
				end

				if alchemyStone == false then
					conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
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
				conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket2ItemLink)
			end

			TRB.Data.character.items.alchemyStone = alchemyStone
			TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
			TRB.Data.character.items.conjuredChillglobe.mana = conjuredChillglobeMana
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
		elseif specId == 4 and TRB.Data.settings.core.enabled.druid.restoration then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.restoration)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = nil
			TRB.Data.resource2Factor = nil
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
							((not talents:IsTalentActive(spells.naturesBalance) and snapshotData.attributes.resource == 0) or
							(talents:IsTalentActive(spells.naturesBalance) and (snapshotData.attributes.resource / TRB.Data.resourceFactor) >= 50))
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
				if (talents:IsTalentActive(spells.naturesBalance) and (affectingCombat or (snapshotData.attributes.resource / TRB.Data.resourceFactor) < 50)) or snapshots[spells.furyOfElune.id].buff.resource > 0 or snapshots[spells.sunderedFirmament.id].buff.resource > 0 then
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
				if talents:IsTalentActive(spells.stellarFlare) then
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
				if talents:IsTalentActive(spells.newMoon) then
					valid = true
				end
			elseif var == "$moonCharges" then
				if talents:IsTalentActive(spells.newMoon) then
					if snapshots[spells.newMoon.id].cooldown.charges > 0 then
						valid = true
					end
				end
			elseif var == "$moonCooldown" then
				if talents:IsTalentActive(spells.newMoon) then
					if snapshots[spells.newMoon.id].cooldown.onCooldown then
						valid = true
					end
				end
			elseif var == "$moonCooldownTotal" then
				if talents:IsTalentActive(spells.newMoon) then
					if snapshots[spells.newMoon.id].cooldown.charges < snapshots[spells.newMoon.id].cooldown.maxCharges then
						valid = true
					end
				end
			elseif var == "$pulsarCollected" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarCollectedPercent" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemaining" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemainingPercent" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarsurgeCount" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarfallCount" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarNextStarsurge" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) and
					(((spells.primordialArcanicPulsar.maxResource or 0) - (snapshots[spells.primordialArcanicPulsar.id].buff.customProperties["currentResource"])) <= TRB.Data.character.starsurgeThreshold) then
					valid = true
				end
			elseif var == "$pulsarNextStarfall" then
				if talents:IsTalentActive(spells.primordialArcanicPulsar) and
					(((spells.primordialArcanicPulsar.maxResource or 0) - (snapshots[spells.primordialArcanicPulsar.id].buff.customProperties["currentResource"])) <= TRB.Data.character.starfallThreshold) then
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
			elseif var == "$regen" or var == "$regenEnergy" or var == "$resourceRegen" then
				if settings.generation.enabled and
					snapshotData.attributes.resource < TRB.Data.character.maxResource and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$passive" then
				if snapshotData.attributes.resource < TRB.Data.character.maxResource and
					settings.generation.enabled and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
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
				if talents:IsTalentActive(spells.lunarInspiration) == true and snapshotData.targetData.count[spells.moonfire.id] > 0 then
					valid = true
				end
			elseif var == "$moonfireCurrent" then
				if talents:IsTalentActive(spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if talents:IsTalentActive(spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$moonfirePercent" then
				if talents:IsTalentActive(spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$moonfireSnapshot" then
				if talents:IsTalentActive(spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.moonfire.id] ~= nil and
					target.spells[spells.moonfire.id].snapshot > 0 then
					valid = true
				end
			elseif var == "$lunarInspiration" then
				if talents:IsTalentActive(spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$brutalSlashCharges" then
				if talents:IsTalentActive(spells.brutalSlash) then
					if snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges > 0 then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldown" then
				if talents:IsTalentActive(spells.brutalSlash) then
					if snapshotData.snapshots[spells.brutalSlash.id].cooldown.onCooldown then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldownTotal" then
				if talents:IsTalentActive(spells.brutalSlash) then
					if snapshotData.snapshots[spells.brutalSlash.id].cooldown.charges < snapshotData.snapshots[spells.brutalSlash.id].cooldown.maxCharges then
						valid = true
					end
				end
			elseif var == "$bloodtalonsStacks" then
				if snapshots[spells.bloodtalons.id].buff.applications > 0 then
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
				if snapshots[spells.clearcasting.id].buff.applications > 0 then
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
			elseif var == "$incarnationTicks" then
				if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
					valid = true
				end
			elseif var == "$incarnationTickTime" then
				if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
					valid = true
				end
			elseif var == "$incarnationNextCp" then
				if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
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
			elseif var == "$predatorRevealedNextCp" then
				if snapshots[spells.predatorRevealed.id].buff.isActive then
					valid = true
				end
			elseif var == "$inStealth" then
				if IsStealthed() then
					valid = true
				end
			end
		elseif specId == 4 then --Restoration
			if var == "$resource" or var == "$mana" then
				valid = true
			elseif var == "$resourceMax" or var == "$manaMax" then
				valid = true
			elseif var == "$resourcePercent" or var == "$manaPercent" then
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
			elseif var == "$bowMana" then
				local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
				if moltenRadiance.buff.isActive then
					valid = true
				end
			elseif var == "$bowTime" then
				local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
				if moltenRadiance.buff.isActive then
					valid = true
				end
			elseif var == "$bowTicks" then
				local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
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
				if snapshots[spells.incarnationTreeOfLife.id].buff.isActive  then
					valid = true
				end
			elseif var == "$reforestationStacks" then
				if snapshots[spells.reforestation.id].buff.applications > 0 then
					valid = true
				end
			end
		else
			valid = false
		end

		return valid
	end

	function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
		local specId = GetSpecialization()
		local settings = TRB.Data.settings.druid
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if specId == 1 then
		elseif specId == 2 then
		elseif specId == 3 then
		elseif specId == 4 then
		end
		return nil
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 and specId ~= 4 then
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