local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
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
		discipline = {
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
		holy = {
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

	---@type TRB.Classes.SnapshotData
	specCache.discipline.snapshotData = TRB.Classes.SnapshotData:New()

	---@type TRB.Classes.SnapshotData
	specCache.holy.snapshotData = TRB.Classes.SnapshotData:New()
	
	---@type TRB.Classes.SnapshotData
	specCache.shadow.snapshotData = TRB.Classes.SnapshotData:New()

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
		-- Discipline
		specCache.discipline.Global_TwintopResourceBar = {
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

		specCache.discipline.character = {
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

		specCache.discipline.spells = {
			-- Priest Class Baseline Abilities
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

			-- Discipline Baseline Abilities

			-- Priest Talent Abilities
			shadowfiend = {
				id = 34433,
				iconName = "spell_shadow_shadowfiend",
				name = "",
				icon = "",
				energizeId = 343727,
				texture = "",
				thresholdId = 8,
				settingKey = "shadowfiend",
				isTalent = true,
				baseline = true,
				manaPercent = 0.005,
				duration = 15
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

			-- Discipline Talent Abilities
			purgeTheWicked = {
				id = 204213,
				icon = "",
				name = "",
				talentId = 204197,
				baseDuration = 20,
				pandemic = true,
				pandemicTime = 20 * 0.3,
				isTalent = true,
			},
			mindbender = {
				id = 123040,
				iconName = "spell_shadow_soulleech_3",
				name = "",
				icon = "",
				energizeId = 123051,
				texture = "",
				thresholdId = 9, -- Really piggybacking off of #8
				settingKey = "mindbender",
				isTalent = true,
				duration = 12,
				manaPercent = 0.002
			},

			-- External mana
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 4.0, --Hasted
				manaPercent = 0.03,
				ticks = 4,
				tickId = 265144
			},
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
				id = 370607,
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

			-- Imbued Frostweave Slippers
			imbuedFrostweaveSlippers = {
				id = 419273,
				name = "",
				icon = "",
				itemId = 207817,
				manaModifier = 0.0006
			}
		}

		specCache.discipline.snapshotData.attributes.manaRegen = 0
		specCache.discipline.snapshotData.audio = {
			innervateCue = false,
			surgeOfLightCue = false,
			surgeOfLight2Cue = false
		}
		---@type TRB.Classes.Healer.Innervate
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.innervate.id] = TRB.Classes.Healer.Innervate:New(specCache.discipline.spells.innervate)
		---@type TRB.Classes.Healer.PotionOfChilledClarity
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(specCache.discipline.spells.potionOfChilledClarity)
		---@type TRB.Classes.Healer.ManaTideTotem
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(specCache.discipline.spells.manaTideTotem)
		---@type TRB.Classes.Healer.SymbolOfHope
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(specCache.discipline.spells.symbolOfHope, CalculateManaGain)
		---@type TRB.Classes.Healer.ChanneledManaPotion
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(specCache.discipline.spells.potionOfFrozenFocusRank1, CalculateManaGain)
		---@type TRB.Classes.Snapshot
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(specCache.discipline.spells.aeratedManaPotionRank1)
		---@type TRB.Classes.Snapshot
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(specCache.discipline.spells.conjuredChillglobe)
		---@type TRB.Classes.Healer.MoltenRadiance
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(specCache.discipline.spells.moltenRadiance)
		---@type TRB.Classes.Snapshot
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.shadowfiend.id] = TRB.Classes.Snapshot:New(specCache.discipline.spells.shadowfiend, {
			guid = nil,
			totemId = nil,
			onCooldown = false,
			swingTime = 0,
			remaining = {
				swings = 0,
				gcds = 0,
				time = 0
			},
			resourceRaw = 0,
			resourceFinal = 0
		})
		---@type TRB.Classes.Snapshot
		specCache.discipline.snapshotData.snapshots[specCache.discipline.spells.surgeOfLight.id] = TRB.Classes.Snapshot:New(specCache.discipline.spells.surgeOfLight)

		specCache.discipline.barTextVariables = {
			icons = {},
			values = {}
		}

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
				iconName = "spell_shadow_shadowfiend",
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
				duration = 60,
				hasCharges = true
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
				isTalent = true,
				hasCharges = true
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
				manaPercent = 0.03,
				ticks = 4,
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
			miracleWorker = {
				id = 235587,
				name = "",
				icon = "",
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
				id = 370607,
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

			-- Imbued Frostweave Slippers
			imbuedFrostweaveSlippers = {
				id = 419273,
				name = "",
				icon = "",
				itemId = 207817,
				manaModifier = 0.0006
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

		specCache.holy.snapshotData.attributes.manaRegen = 0
		specCache.holy.snapshotData.audio = {
			innervateCue = false,
			resonantWordsCue = false,
			lightweaverCue = false,
			surgeOfLightCue = false,
			surgeOfLight2Cue = false
		}
		---@type TRB.Classes.Healer.Innervate
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.innervate.id] = TRB.Classes.Healer.Innervate:New(specCache.holy.spells.innervate)
		---@type TRB.Classes.Healer.PotionOfChilledClarity
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(specCache.holy.spells.potionOfChilledClarity)
		---@type TRB.Classes.Healer.ManaTideTotem
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(specCache.holy.spells.manaTideTotem)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.shadowfiend.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.shadowfiend, {
			guid = nil,
			totemId = nil,
			onCooldown = false,
			swingTime = 0,
			remaining = {
				swings = 0,
				gcds = 0,
				time = 0
			},
			resourceRaw = 0,
			resourceFinal = 0
		})
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.apotheosis.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.apotheosis)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.surgeOfLight.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.surgeOfLight)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.resonantWords.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.resonantWords)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.lightweaver.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.lightweaver)
		---@type TRB.Classes.Healer.SymbolOfHope
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(specCache.holy.spells.symbolOfHope, CalculateManaGain)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.holyWordSerenity.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.holyWordSerenity)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.holyWordSanctify.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.holyWordSanctify)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.holyWordChastise.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.holyWordChastise)
		---@type TRB.Classes.Healer.ChanneledManaPotion
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(specCache.holy.spells.potionOfFrozenFocusRank1, CalculateManaGain)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.aeratedManaPotionRank1)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.conjuredChillglobe)
		---@type TRB.Classes.Healer.MoltenRadiance
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(specCache.holy.spells.moltenRadiance)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.divineConversation.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.divineConversation)
		---@type TRB.Classes.Snapshot
		specCache.holy.snapshotData.snapshots[specCache.holy.spells.prayerFocus.id] = TRB.Classes.Snapshot:New(specCache.holy.spells.prayerFocus)

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
				baseline = true,
				hasCharges = true
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
				iconName = "spell_shadow_shadowfiend",
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
				id = 390978,
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
			surgeOfInsanity = {
				id = 391399,
				name = "",
				icon = "",
				isTalent = true
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
				iconName = "spell_shadow_soulleech_3",
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
				talentId = 373273,
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

		specCache.shadow.snapshotData.audio = {
			playedDpCue = false,
			playedMdCue = false,
			overcapCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.voidform.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.voidform)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.darkAscension.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.darkAscension)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.shadowfiend.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.shadowfiend, {
			guid = nil,
			totemId = nil,
			onCooldown = false,
			swingTime = 0,
			remaining = {
				swings = 0,
				gcds = 0,
				time = 0
			},
			resourceRaw = 0,
			resourceFinal = 0
		})
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.devouredDespair.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.devouredDespair, {
			insanity = 0,
			ticks = 0
		})
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.idolOfCthun.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.idolOfCthun, {
			numberActive = 0,
			resourceRaw = 0,
			resourceFinal = 0,
			maxTicksRemaining = 0,
			activeList = {}
		})
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.mindDevourer.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.mindDevourer)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.surgeOfInsanity.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.mindFlayInsanity)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.deathspeaker.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.deathspeaker)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.twistOfFate.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.twistOfFate)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.mindMelt.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.mindMelt)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.shadowyInsight.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.shadowyInsight)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.voidBolt.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.voidBolt, {
			lastSuccess = nil,
			flightTime = 1.0
		})
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.mindBlast.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.mindBlast)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.idolOfYoggSaron.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.idolOfYoggSaron)
		---@type TRB.Classes.Snapshot
		specCache.shadow.snapshotData.snapshots[specCache.shadow.spells.thingFromBeyond.id] = TRB.Classes.Snapshot:New(specCache.shadow.spells.thingFromBeyond)
	end

	local function Setup_Discipline()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "priest", "discipline")
	end


	local function FillSpellData_Discipline()
		Setup_Discipline()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.discipline.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.discipline.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#sol", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = true },
			{ variable = "#surgeOfLight", icon = spells.surgeOfLight.icon, description = spells.surgeOfLight.name, printInSettings = false },
			
			{ variable = "#swp", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = true },
			{ variable = "#shadowWordPain", icon = spells.shadowWordPain.icon, description = spells.shadowWordPain.name, printInSettings = false },

			{ variable = "#ptw", icon = spells.purgeTheWicked.icon, description = spells.purgeTheWicked.name, printInSettings = true },
			{ variable = "#purgeTheWicked", icon = spells.purgeTheWicked.icon, description = spells.purgeTheWicked.name, printInSettings = false },
			
			{ variable = "#sf", icon = spells.shadowfiend.icon, description = "Shadowfiend / Mindbender", printInSettings = true },
			{ variable = "#mindbender", icon = spells.mindbender.icon, description = "Mindbender", printInSettings = false },
			{ variable = "#shadowfiend", icon = spells.shadowfiend.icon, description = "Shadowfiend", printInSettings = false },

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
		specCache.discipline.barTextVariables.values = {
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

			{ variable = "$solStacks", description = "Number of Surge of Light stacks", printInSettings = true, color = false },
			{ variable = "$solTime", description = "Time left on Surge of Light", printInSettings = true, color = false },
			
			{ variable = "$sohMana", description = "Mana from Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTime", description = "Time left on Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTicks", description = "Number of ticks left from Symbol of Hope", printInSettings = true, color = false },

			{ variable = "$innervateMana", description = "Passive mana regen while Innervate is active", printInSettings = true, color = false },
			{ variable = "$innervateTime", description = "Time left on Innervate", printInSettings = true, color = false },
			
			{ variable = "$mttMana", description = "Bonus passive mana regen while Mana Tide Totem is active", printInSettings = true, color = false },
			{ variable = "$mttTime", description = "Time left on Mana Tide Totem", printInSettings = true, color = false },
						
			{ variable = "$mrMana", description = "Mana from Molten Radiance", printInSettings = true, color = false },
			{ variable = "$mrTime", description = "Time left on Molten Radiance", printInSettings = true, color = false },

			{ variable = "$channeledMana", description = "Mana while channeling of Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTicks", description = "Number of ticks left channeling Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Frozen Focus", printInSettings = true, color = false },
			
			{ variable = "$potionOfChilledClarityMana", description = "Passive mana regen while Potion of Chilled Clarity's effect is active", printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = "Time left on Potion of Chilled Clarity's effect", printInSettings = true, color = false },

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

		specCache.discipline.spells = spells
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
		local spells = TRB.Data.spells
		if guid == nil or (not TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid] or TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid] == nil) then
			return false
		end
		return true
	end

	local function InitializeVoidTendril(guid)
		if guid ~= nil and not CheckVoidTendrilExists(guid) then
			local spells = TRB.Data.spells
			TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid] = {}
			TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid].startTime = nil
			TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid].tickTime = nil
			TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid].type = nil
			TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid].targetsHit = 0
			TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid].hasStruckTargets = false
		end
	end

	local function RemoveVoidTendril(guid)
		if guid ~= nil and CheckVoidTendrilExists(guid) then
			local spells = TRB.Data.spells
			TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[guid] = nil
		end
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData

		---@type TRB.Classes.TargetData
		local targetData = snapshotData.targetData

		if specId == 1 then -- Discipline
			targetData:UpdateDebuffs(currentTime)
		elseif specId == 2 then -- Holy
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
		local targetData = TRB.Data.snapshotData.targetData
		targetData:Cleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 2 then
			elseif specId == 2 then
			elseif specId == 3 then
				targetData.custom.auspiciousSpiritsGenerate = 0
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

		entries = TRB.Functions.Table:Length(passiveFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				passiveFrame.thresholds[x]:Hide()
			end
		end

		if specId == 1 and TRB.Data.settings.core.experimental.specs.priest.discipline then
			for x = 1, 9 do
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
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.priest.discipline)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.priest.discipline)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.priest.discipline)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.priest.discipline)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.priest.discipline)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.priest.discipline)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe.settingKey, TRB.Data.settings.priest.discipline)
			
			if TRB.Functions.Talent:IsTalentActive(spells.mindbender) then
				TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], spells.mindbender.settingKey, TRB.Data.settings.priest.discipline)
			else
				TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], spells.shadowfiend.settingKey, TRB.Data.settings.priest.discipline)
			end
		elseif specId == 2 then
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
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe.settingKey, TRB.Data.settings.priest.holy)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[8], spells.shadowfiend.settingKey, TRB.Data.settings.priest.holy)
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

		if (specId == 1 and TRB.Data.settings.core.experimental.specs.priest.discipline) or
			specId == 2 or
			specId == 3 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function CalculateHolyWordCooldown(base, spellId)
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots
		local mod = 1
		local divineConversationValue = 0
		local prayerFocusValue = 0

		if snapshots[spells.divineConversation.id].buff.isActive then
			if TRB.Data.character.isPvp then
				divineConversationValue = spells.divineConversation.reductionPvp
			else
				divineConversationValue = spells.divineConversation.reduction
			end
		end

		if snapshots[spells.prayerFocus.id].buff.isActive and (spellId == spells.heal.id or spellId == spells.prayerOfHealing.id) then
			prayerFocusValue = spells.prayerFocus.holyWordReduction
		end

		if snapshots[spells.apotheosis.id].buff.isActive then
			mod = mod * spells.apotheosis.holyWordModifier
		end

		if TRB.Functions.Talent:IsTalentActive(spells.lightOfTheNaaru) then
			mod = mod * (1 + (spells.lightOfTheNaaru.holyWordModifier * TRB.Data.talents[spells.lightOfTheNaaru.id].currentRank))
		end

		return mod * (base + prayerFocusValue) + divineConversationValue
	end

	local function CalculateInsanityGain(insanity)
		local modifier = 1.0

		return insanity * modifier
	end

	local function RefreshLookupData_Discipline()
		local specSettings = TRB.Data.settings.priest.discipline
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.manaRegen, _ = GetPowerRegen()
		
		if TRB.Data.character.items.imbuedFrostweaveSlippers then
			snapshotData.attributes.manaRegen = snapshotData.attributes.manaRegen + (TRB.Data.character.maxResource * spells.imbuedFrostweaveSlippers.manaModifier)
		end

		local currentManaColor = specSettings.colors.text.current
		local castingManaColor = specSettings.colors.text.casting

		--$mana
		local manaPrecision = specSettings.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = snapshotData.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
		--$sohMana
		local _sohMana = symbolOfHope.buff.mana
		local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
		--$sohTicks
		local _sohTicks = symbolOfHope.buff.ticks or 0
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
		
		--$sfMana
		local _sfMana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0
		local sfMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
		--$sfGcds
		local _sfGcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds
		local sfGcds = string.format("%.0f", _sfGcds)
		--$sfSwings
		local _sfSwings = snapshots[spells.shadowfiend.id].attributes.remaining.swings
		local sfSwings = string.format("%.0f", _sfSwings)
		--$sfTime
		local _sfTime = snapshots[spells.shadowfiend.id].attributes.remaining.time
		local sfTime = string.format("%.1f", _sfTime)

		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana + _mrMana
		local passiveMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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

		--$solStacks
		local _solStacks = snapshots[spells.surgeOfLight.id].buff.stacks or 0
		local solStacks = string.format("%.0f", _solStacks)
		--$solTime
		local _solTime = snapshots[spells.surgeOfLight.id].buff:GetRemainingTime(currentTime) or 0
		local solTime = string.format("%.1f", _solTime)

		-----------
		--$swpCount and $swpTime		
		local _shadowWordPainCount
		if TRB.Functions.Talent:IsTalentActive(spells.purgeTheWicked) then
			_shadowWordPainCount = snapshotData.targetData.count[spells.purgeTheWicked.id] or 0
		else
			_shadowWordPainCount = snapshotData.targetData.count[spells.shadowWordPain.id] or 0
		end
		local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
		local _shadowWordPainTime = 0
		
		if target ~= nil then
			if TRB.Functions.Talent:IsTalentActive(spells.purgeTheWicked) then
				_shadowWordPainTime = target.spells[spells.purgeTheWicked.id].remainingTime or 0
			else
				_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
			end
		end

		local shadowWordPainTime

		if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and (target.spells[spells.shadowWordPain.id].active or target.spells[spells.purgeTheWicked.id].active) then
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
			ticks = _potionOfFrozenFocusTicks
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = _sohTicks,
		}
		Global_TwintopResourceBar.shadowfiend = {
			mana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0,
			gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
			swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
			time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0
		}


		local lookup = TRB.Data.lookup
		
		if TRB.Functions.Talent:IsTalentActive(spells.mindbender) then
			lookup["#sf"] = spells.mindbender.icon
			lookup["#mindbender"] = spells.mindbender.icon
			lookup["#shadowfiend"] = spells.mindbender.icon
		else
			lookup["#sf"] = spells.shadowfiend.icon
			lookup["#mindbender"] = spells.shadowfiend.icon
			lookup["#shadowfiend"] = spells.shadowfiend.icon
		end

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
		lookup["$solStacks"] = solStacks
		lookup["$solTime"] = solTime
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
		lookup["$sfMana"] = sfMana
		lookup["$sfGcds"] = sfGcds
		lookup["$sfSwings"] = sfSwings
		lookup["$sfTime"] = sfTime
		lookup["$swpCount"] = shadowWordPainCount
		lookup["$swpTime"] = shadowWordPainTime
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
		lookupLogic["$solStacks"] = _solStacks
		lookupLogic["$solTime"] = _solTime
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
		lookupLogic["$sfMana"] = _sfMana
		lookupLogic["$sfGcds"] = _sfGcds
		lookupLogic["$sfSwings"] = _sfSwings
		lookupLogic["$sfTime"] = _sfTime
		lookupLogic["$swpCount"] = _shadowWordPainCount
		lookupLogic["$swpTime"] = _shadowWordPainTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Holy()
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local snapshots = snapshotData.snapshots
		local specSettings = TRB.Data.settings.priest.holy
		---@type TRB.Classes.Target
		local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.manaRegen, _ = GetPowerRegen()
		
		if TRB.Data.character.items.imbuedFrostweaveSlippers then
			snapshotData.attributes.manaRegen = snapshotData.attributes.manaRegen + (TRB.Data.character.maxResource * spells.imbuedFrostweaveSlippers.manaModifier)
		end

		local currentManaColor = specSettings.colors.text.current
		local castingManaColor = specSettings.colors.text.casting

		--$mana
		local manaPrecision = specSettings.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = snapshotData.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
		--$sohMana
		local _sohMana = symbolOfHope.buff.mana
		local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
		--$sohTicks
		local _sohTicks = symbolOfHope.buff.ticks or 0
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
		
		--$sfMana
		local _sfMana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0
		local sfMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_sfMana, manaPrecision, "floor", true))
		--$sfGcds
		local _sfGcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds
		local sfGcds = string.format("%.0f", _sfGcds)
		--$sfSwings
		local _sfSwings = snapshots[spells.shadowfiend.id].attributes.remaining.swings
		local sfSwings = string.format("%.0f", _sfSwings)
		--$sfTime
		local _sfTime = snapshots[spells.shadowfiend.id].attributes.remaining.time
		local sfTime = string.format("%.1f", _sfTime)

		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _sfMana + _mrMana
		local passiveMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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

		--$hwChastiseTime
		local _hwChastiseTime = snapshots[spells.holyWordChastise.id].cooldown.remaining
		local hwChastiseTime = string.format("%.1f", _hwChastiseTime)

		--$hwSanctifyTime
		local _hwSanctifyTime = snapshots[spells.holyWordSanctify.id].cooldown.remaining
		local hwSanctifyTime = string.format("%.1f", _hwSanctifyTime)

		--$hwSerenityTime
		local _hwSerenityTime = snapshots[spells.holyWordSerenity.id].cooldown.remaining
		local hwSerenityTime = string.format("%.1f", _hwSerenityTime)

		--$apotheosisTime
		local _apotheosisTime = snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)
		local apotheosisTime = string.format("%.1f", _apotheosisTime)

		--$solStacks
		local _solStacks = snapshots[spells.surgeOfLight.id].buff.stacks or 0
		local solStacks = string.format("%.0f", _solStacks)
		--$solTime
		local _solTime = snapshots[spells.surgeOfLight.id].buff:GetRemainingTime(currentTime) or 0
		local solTime = string.format("%.1f", _solTime)

		--$lightweaverStacks
		local _lightweaverStacks = snapshots[spells.lightweaver.id].buff.stacks or 0
		local lightweaverStacks = string.format("%.0f", _lightweaverStacks)
		--$lightweaverTime
		local _lightweaverTime = snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime) or 0
		local lightweaverTime = string.format("%.1f", _lightweaverTime)
		
		--$rwTime
		local _rwTime = snapshots[spells.resonantWords.id].buff:GetRemainingTime(currentTime) or 0
		local rwTime = string.format("%.1f", _rwTime)

		-----------
		--$swpCount and $swpTime
		local _shadowWordPainCount = snapshotData.targetData.count[spells.shadowWordPain.id] or 0
		local shadowWordPainCount = string.format("%s", _shadowWordPainCount)
		local _shadowWordPainTime = 0
		
		if target ~= nil then
			_shadowWordPainTime = target.spells[spells.shadowWordPain.id].remainingTime or 0
		end

		local shadowWordPainTime

		if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
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
			ticks = _potionOfFrozenFocusTicks
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = _sohTicks
		}
		Global_TwintopResourceBar.shadowfiend = {
			mana = snapshots[spells.shadowfiend.id].attributes.resourceFinal or 0,
			gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
			swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
			time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
		}
		Global_TwintopResourceBar.dots = {
			swpCount = _shadowWordPainCount or 0
		}


		local lookup = TRB.Data.lookup
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
		local specSettings = TRB.Data.settings.priest.shadow
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local target = targetData.targets[targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedInsanity = snapshotData.attributes.resource / TRB.Data.resourceFactor
		--$vfTime
		local _voidformTime = snapshots[spells.voidform.id].buff:GetRemainingTime(currentTime)

		--TODO: not use this hacky workaroud for timers
		if snapshots[spells.darkAscension.id].buff:GetRemainingTime(currentTime) > 0 then
			_voidformTime = snapshots[spells.darkAscension.id].buff.remaining
		end

		local voidformTime = string.format("%.1f", _voidformTime)
		----------

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentInsanityColor = specSettings.colors.text.currentInsanity
		local castingInsanityColor = specSettings.colors.text.castingInsanity

		local insanityThreshold = TRB.Data.character.devouringPlagueThreshold

		if snapshots[spells.mindDevourer.id].buff.isActive then
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
		local _castingInsanity = snapshotData.casting.resourceFinal
		local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_castingInsanity, insanityPrecision, "floor"))
		--$mbInsanity
		local _mbInsanity = snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal
		local mbInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_mbInsanity, insanityPrecision, "floor"))
		--$mbGcds
		local _mbGcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds
		local mbGcds = string.format("%.0f", _mbGcds)
		--$mbSwings
		local _mbSwings = snapshots[spells.shadowfiend.id].attributes.remaining.swings
		local mbSwings = string.format("%.0f", _mbSwings)
		--$mbTime
		local _mbTime = snapshots[spells.shadowfiend.id].attributes.remaining.time
		local mbTime = string.format("%.1f", _mbTime)
		--$loiInsanity
		local _loiInsanity = snapshots[spells.idolOfCthun.id].attributes.resourceFinal
		local loiInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_loiInsanity, insanityPrecision, "floor"))
		--$loiTicks
		local _loiTicks = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining
		local loiTicks = string.format("%.0f", _loiTicks)
		--$ecttvCount
		local _ecttvCount = snapshots[spells.idolOfCthun.id].attributes.numberActive
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
		local _insanityTotal = math.min(_passiveInsanity + snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityTotal = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.Number:RoundTo(_insanityTotal, insanityPrecision, "floor"))
		--$insanityPlusCasting
		local _insanityPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
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
		local _mdTime = snapshots[spells.mindDevourer.id].buff:GetRemainingTime(currentTime)
		local mdTime = string.format("%.1f", _mdTime)
		
		--$mfiTime
		local _mfiTime = snapshots[spells.surgeOfInsanity.id].buff:GetRemainingTime(currentTime)
		local mfiTime = string.format("%.1f", _mfiTime)

		--$mfiStacks
		local _mfiStacks = snapshots[spells.surgeOfInsanity.id].buff.stacks or 0
		local mfiStacks = string.format("%.0f", _mfiStacks)
		
		--$deathspeakerTime
		local _deathspeakerTime = snapshots[spells.deathspeaker.id].buff:GetRemainingTime(currentTime)
		local deathspeakerTime = string.format("%.1f", _deathspeakerTime)

		--$tofTime
		local _tofTime = snapshots[spells.twistOfFate.id].buff:GetRemainingTime(currentTime)
		local tofTime = string.format("%.1f", _tofTime)
		
		--$mindBlastCharges
		local mindBlastCharges = snapshots[spells.mindBlast.id].cooldown.charges or 0
		
		--$mindBlastMaxCharges
		local mindBlastMaxCharges = snapshots[spells.mindBlast.id].cooldown.maxCharges or 0

		--$siTime
		local _siTime = snapshots[spells.shadowyInsight.id].buff:GetRemainingTime(currentTime)
		local siTime = string.format("%.1f", _siTime)
		
		--$mmTime
		local _mmTime = snapshots[spells.mindMelt.id].buff:GetRemainingTime(currentTime)
		local mmTime = string.format("%.1f", _mmTime)
		--$mmStacks
		local mmStacks = snapshots[spells.mindMelt.id].buff.stacks or 0
		
		--$ysTime
		local _ysTime = snapshots[spells.idolOfYoggSaron.id].buff:GetRemainingTime(currentTime)
		local ysTime = string.format("%.1f", _ysTime)
		--$ysStacks
		local ysStacks = snapshots[spells.idolOfYoggSaron.id].buff.stacks or 0
		--$ysRemainingStacks
		local ysRemainingStacks = (TRB.Data.spells.idolOfYoggSaron.requiredStacks - ysStacks) or TRB.Data.spells.idolOfYoggSaron.requiredStacks
		--$tfbTime
		local _tfbTime = snapshots[spells.thingFromBeyond.id].buff:GetRemainingTime(currentTime)
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
		Global_TwintopResourceBar.resource.ecttv = snapshots[spells.idolOfCthun.id].attributes.resourceFinal or 0
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
			gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
			swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
			time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
		}
		Global_TwintopResourceBar.mindbender = {
			insanity = _mbInsanity,
			gcds = snapshots[spells.shadowfiend.id].attributes.remaining.gcds or 0,
			swings = snapshots[spells.shadowfiend.id].attributes.remaining.swings or 0,
			time = snapshots[spells.shadowfiend.id].attributes.remaining.time or 0
		}
		Global_TwintopResourceBar.eternalCallToTheVoid = {
			insanity = snapshots[spells.idolOfCthun.id].attributes.resourceFinal or 0,
			ticks = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining or 0,
			count = snapshots[spells.idolOfCthun.id].attributes.numberActive or 0
		}

		local lookup = TRB.Data.lookup
		
		if TRB.Functions.Talent:IsTalentActive(spells.mindbender) then
			lookup["#sf"] = spells.mindbender.icon
			lookup["#mindbender"] = spells.mindbender.icon
			lookup["#shadowfiend"] = spells.mindbender.icon
		else
			lookup["#sf"] = spells.shadowfiend.icon
			lookup["#mindbender"] = spells.shadowfiend.icon
			lookup["#shadowfiend"] = spells.shadowfiend.icon
		end

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

	local function UpdateCastingResourceFinal_Discipline()
		-- Do nothing for now
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
		local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		-- Do nothing for now
		snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
	end

	local function UpdateCastingResourceFinal_Holy()
		-- Do nothing for now
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
		local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
		-- Do nothing for now
		snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
	end

	local function UpdateCastingResourceFinal_Shadow()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function CastingSpell()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local currentTime = GetTime()
		local affectingCombat = UnitAffectingCombat("player")
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
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

						UpdateCastingResourceFinal_Discipline()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 2 then
				if currentSpellName == nil then
					if currentChannelId == spells.symbolOfHope.id then
						snapshotData.casting.spellId = spells.symbolOfHope.id
						snapshotData.casting.startTime = currentChannelStartTime / 1000
						snapshotData.casting.endTime = currentChannelEndTime / 1000
						snapshotData.casting.resourceRaw = 0
						snapshotData.casting.icon = spells.symbolOfHope.icon
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

						snapshotData.casting.startTime = currentSpellStartTime / 1000
						snapshotData.casting.endTime = currentSpellEndTime / 1000
						snapshotData.casting.resourceRaw = manaCost
						snapshotData.casting.spellId = spellId
						snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Holy()
						if currentSpellId == spells.heal.id then
							snapshotData.casting.spellKey = "heal"
						elseif currentSpellId == spells.flashHeal.id then
							snapshotData.casting.spellKey = "flashHeal"
						elseif currentSpellId == spells.prayerOfHealing.id then
							snapshotData.casting.spellKey = "prayerOfHealing"
						elseif currentSpellId == spells.renew.id then --This shouldn't happen
							snapshotData.casting.spellKey = "renew"
						elseif currentSpellId == spells.smite.id then
							snapshotData.casting.spellKey = "smite"
						elseif TRB.Functions.Talent:IsTalentActive(spells.harmoniousApparatus) then
							if currentSpellId == spells.circleOfHealing.id then --Harmonious Apparatus / This shouldn't happen
								snapshotData.casting.spellKey = "circleOfHealing"
							elseif currentSpellId == spells.prayerOfMending.id then --Harmonious Apparatus / This shouldn't happen
								snapshotData.casting.spellKey = "prayerOfMending"
							elseif currentSpellId == spells.holyFire.id then --Harmonious Apparatus
								snapshotData.casting.spellKey = "holyFire"
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
						snapshotData.casting.spellId = spells.mindFlay.id
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.mindFlay.insanity
						snapshotData.casting.icon = spells.mindFlay.icon
					elseif currentChannelId == spells.mindFlayInsanity.id then
						snapshotData.casting.spellId = spells.mindFlayInsanity.id
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.mindFlayInsanity.insanity
						snapshotData.casting.icon = spells.mindFlayInsanity.icon
					elseif currentChannelId == spells.voidTorrent.id then
						snapshotData.casting.spellId = spells.voidTorrent.id
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.voidTorrent.insanity
						snapshotData.casting.icon = spells.voidTorrent.icon
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
					UpdateCastingResourceFinal_Shadow()
				else
					if currentSpellId == spells.mindBlast.id then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.mindBlast.insanity
						snapshotData.casting.spellId = spells.mindBlast.id
						snapshotData.casting.icon = spells.mindBlast.icon
					elseif currentSpellId == spells.mindSpike.id then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.mindSpike.insanity
						snapshotData.casting.spellId = spells.mindSpike.id
						snapshotData.casting.icon = spells.mindSpike.icon
					elseif currentSpellId == spells.mindSpikeInsanity.id then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.mindSpikeInsanity.insanity
						snapshotData.casting.spellId = spells.mindSpikeInsanity.id
						snapshotData.casting.icon = spells.mindSpikeInsanity.icon
					elseif currentSpellId == spells.darkAscension.id then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.darkAscension.insanity
						snapshotData.casting.spellId = spells.darkAscension.id
						snapshotData.casting.icon = spells.darkAscension.icon
					elseif currentSpellId == spells.vampiricTouch.id then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.vampiricTouch.insanity
						snapshotData.casting.spellId = spells.vampiricTouch.id
						snapshotData.casting.icon = spells.vampiricTouch.icon
					elseif currentSpellId == spells.mindgames.id then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.mindgames.insanity
						snapshotData.casting.spellId = spells.mindgames.id
						snapshotData.casting.icon = spells.mindgames.icon
					elseif currentSpellId == spells.halo.id then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.halo.insanity
						snapshotData.casting.spellId = spells.halo.id
						snapshotData.casting.icon = spells.halo.icon
					elseif currentSpellId == spells.massDispel.id and TRB.Functions.Talent:IsTalentActive(spells.hallucinations) and affectingCombat then
						snapshotData.casting.startTime = currentTime
						snapshotData.casting.resourceRaw = spells.hallucinations.insanity
						snapshotData.casting.spellId = spells.massDispel.id
						snapshotData.casting.icon = spells.massDispel.icon
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
		local spells = TRB.Data.spells
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 and specId ~= 3 then
			return false, 0, 0, 0, 0, 0
		end

		---@type TRB.Classes.Snapshot
		local shadowfiend = TRB.Data.snapshotData.snapshots[spells.shadowfiend.id]

		local swingTime = shadowfiend.attributes.swingTime

		local currentTime = GetTime()
		local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
		local timeRemaining = startTime+duration-currentTime

		if not haveTotem then
			if specId == 1 then
				if TRB.Functions.Talent:IsTalentActive(spells.mindbender) then
					timeRemaining = TRB.Data.spells.mindbender.duration
				else
					timeRemaining = TRB.Data.spells.shadowfiend.duration
				end
				swingTime = currentTime
			elseif specId == 2 then
				timeRemaining = TRB.Data.spells.shadowfiend.duration
				swingTime = currentTime
			end
		end

		local swingSpeed = 1.5 / (1 + (TRB.Data.snapshotData.attributes.haste / 100))
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

	---Update a specific Shadowfiend's values
	---@param shadowfiend TRB.Classes.Snapshot
	local function UpdateSpecificShadowfiendValues(shadowfiend)
		if shadowfiend.attributes.totemId == nil then
			return
		end
		
		local specId = GetSpecialization()
		local currentTime = GetTime()
		local settings
		local _
		
		if specId == 1 then
			settings = TRB.Data.settings.priest.discipline.shadowfiend
		elseif specId == 2 and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.shadowfiend) then
			settings = TRB.Data.settings.priest.holy.shadowfiend
		elseif specId == 3 then
			settings = TRB.Data.settings.priest.shadow.mindbender
		else
			return
		end

		local haveTotem, name, startTime, duration, icon = GetTotemInfo(shadowfiend.attributes.totemId)
		local timeRemaining = startTime+duration-currentTime

		if settings.enabled and haveTotem and timeRemaining > 0 then
			shadowfiend.buff.isActive = true
			if settings.enabled then
				local _, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
				shadowfiend.attributes.remaining.time = timeRemaining
				shadowfiend.attributes.remaining.swings = swingsRemaining
				shadowfiend.attributes.remaining.gcds = gcdsRemaining

				shadowfiend.attributes.swingTime = currentTime

				local countValue = 0

				if settings.mode == "swing" then
					if shadowfiend.attributes.remaining.swings > settings.swingsMax then
						countValue = settings.swingsMax
					else
						countValue = shadowfiend.attributes.remaining.swings
					end
				elseif settings.mode == "time" then
					if shadowfiend.attributes.remaining.time > settings.timeMax then
						countValue = math.ceil((settings.timeMax - timeToNextSwing) / swingSpeed)
					else
						countValue = math.ceil((shadowfiend.attributes.remaining.time - timeToNextSwing) / swingSpeed)
					end
				else --assume GCD
					if shadowfiend.attributes.remaining.gcds > settings.gcdsMax then
						countValue = settings.gcdsMax
					else
						countValue = shadowfiend.attributes.remaining.gcds
					end
				end

				if specId == 1 then
					shadowfiend.attributes.resourceRaw = countValue * shadowfiend.spell.manaPercent * TRB.Data.character.maxResource
					shadowfiend.attributes.resourceFinal = CalculateManaGain(shadowfiend.attributes.resourceRaw, false)
				elseif specId == 2 then
					shadowfiend.attributes.resourceRaw = countValue * shadowfiend.spell.manaPercent * TRB.Data.character.maxResource
					shadowfiend.attributes.resourceFinal = CalculateManaGain(shadowfiend.attributes.resourceRaw, false)
				elseif specId == 3 then
					shadowfiend.attributes.resourceRaw = countValue * shadowfiend.spell.insanity
					shadowfiend.attributes.resourceFinal = CalculateInsanityGain(shadowfiend.attributes.resourceRaw)
				end
			end
		else
			shadowfiend.buff:Reset()
			shadowfiend.attributes.swingTime = 0
			shadowfiend.attributes.remaining.swings = 0
			shadowfiend.attributes.remaining.gcds = 0
			shadowfiend.attributes.remaining.time = 0
			shadowfiend.attributes.resourceRaw = 0
			shadowfiend.attributes.resourceFinal = 0
			if specId == 3 then
				shadowfiend.attributes.totemId = nil
				shadowfiend.attributes.guid = nil
			end
		end

		shadowfiend.cooldown:Refresh()
	end

	local function UpdateShadowfiendValues()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		local _
		local spells = TRB.Data.spells
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData
		local shadowfiend = snapshotData.snapshots[spells.shadowfiend.id]

		UpdateSpecificShadowfiendValues(shadowfiend)
		
		if specId == 3 then
			local devouredDespair = snapshotData.snapshots[spells.devouredDespair.id]
			if devouredDespair.buff.isActive and devouredDespair.buff.endTime ~= nil and devouredDespair.buff.endTime > currentTime then				
				devouredDespair.attributes.ticks = TRB.Functions.Number:RoundTo(TRB.Functions.Spell:GetRemainingTime(devouredDespair, 0, "ceil", true))
			else
				devouredDespair:Reset()
				devouredDespair.attributes.ticks = 0
			end
			devouredDespair.attributes.resourceRaw = devouredDespair.attributes.ticks * TRB.Data.spells.devouredDespair.insanity
			devouredDespair.attributes.resourceFinal = CalculateInsanityGain(devouredDespair.attributes.resourceRaw)
		end
	end

	local function UpdateExternalCallToTheVoidValues()
		local spells = TRB.Data.spells
		local currentTime = GetTime()
		local totalTicksRemaining_Lasher = 0
		local totalTicksRemaining_Tendril = 0
		local totalInsanity_Lasher = 0
		local totalInsanity_Tendril = 0
		local totalActive = 0

		-- TODO: Add separate counts for Tendril vs Lasher?
		if TRB.Functions.Table:Length(TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList) > 0 then
			for vtGuid,v in pairs(TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList) do
				if TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid] ~= nil and TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].startTime ~= nil then
					local endTime = TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].startTime + TRB.Data.spells.lashOfInsanity_Tendril.duration
					local timeRemaining = endTime - currentTime

					if timeRemaining < 0 then
						RemoveVoidTendril(vtGuid)
					else
						if TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].type == "Lasher" then
							if TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].tickTime ~= nil and currentTime > (TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].tickTime + 5) then
								TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].targetsHit = 0
							end

							local nextTick = TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Lasher.tickDuration

							if nextTick < currentTime then
								nextTick = currentTime --There should be a tick. ANY second now. Maybe.
								totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + 1
							end
							-- NOTE: Might need to be math.floor()
							local ticksRemaining = math.ceil((endTime - nextTick) / TRB.Data.spells.lashOfInsanity_Lasher.tickDuration)

							totalInsanity_Lasher = totalInsanity_Lasher + (ticksRemaining * TRB.Data.spells.lashOfInsanity_Lasher.insanity)
							totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + ticksRemaining
						else
							local nextTick = TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.activeList[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Tendril.tickDuration

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

		TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining = totalTicksRemaining_Tendril + totalTicksRemaining_Lasher
		TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.numberActive = totalActive
		TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.resourceRaw = totalInsanity_Tendril + totalInsanity_Lasher
		-- Fortress of the Mind does not apply but other Insanity boosting effects do.
		TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.snapshots[spells.idolOfCthun.id].attributes.resourceRaw)
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
		UpdateShadowfiendValues()
	end

	local function UpdateSnapshot_Healers()
		local _
		local spells = TRB.Data.spells
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

		snapshots[spells.surgeOfLight.id].buff:GetRemainingTime(currentTime)

		-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
		snapshots[spells.aeratedManaPotionRank1.id].cooldown.startTime, snapshots[spells.aeratedManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
		snapshots[spells.aeratedManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)

		snapshots[spells.conjuredChillglobe.id].cooldown.startTime, snapshots[spells.conjuredChillglobe.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
		snapshots[spells.conjuredChillglobe.id].cooldown:GetRemainingTime(currentTime)
	end

	local function UpdateSnapshot_Discipline()
		UpdateSnapshot()
		UpdateSnapshot_Healers()
	end

	local function UpdateSnapshot_Holy()
		local currentTime = GetTime()
		UpdateSnapshot()
		UpdateSnapshot_Healers()
		
		local _
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots

		snapshots[spells.holyWordSerenity.id].cooldown:Refresh(true)
		snapshots[spells.holyWordSanctify.id].cooldown:Refresh(true)
		snapshots[spells.holyWordChastise.id].cooldown:Refresh()
		snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.resonantWords.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime)
	end

	local function UpdateSnapshot_Shadow()
		local currentTime = GetTime()
		UpdateSnapshot()
		UpdateExternalCallToTheVoidValues()
		local spells = TRB.Data.spells
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots
		
		snapshots[spells.voidform.id].buff:Refresh()
		snapshots[spells.darkAscension.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.surgeOfInsanity.id].buff:Refresh()
		snapshots[spells.deathspeaker.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.mindDevourer.id].buff:GetRemainingTime(currentTime)

		snapshots[spells.mindBlast.id].cooldown:Refresh()
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.priest
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots

		if specId == 1 then
			local specSettings = classSettings.discipline
			UpdateSnapshot_Discipline()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
					local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
					local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
					local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]

					if snapshots[spells.surgeOfLight.id].buff.isActive then
						if snapshots[spells.surgeOfLight.id].buff.stacks == 1 then
							if specSettings.colors.bar.surgeOfLightBorderChange1 then
								barBorderColor = specSettings.colors.bar.surgeOfLight1
							end

							if specSettings.audio.surgeOfLight.enabled and not snapshotData.audio.surgeOfLightCue then
								snapshotData.audio.surgeOfLightCue = true
								PlaySoundFile(specSettings.audio.surgeOfLight.sound, coreSettings.audio.channel.channel)
							end
						end

						if snapshots[spells.surgeOfLight.id].buff.stacks == 2 then
							if specSettings.colors.bar.surgeOfLightBorderChange2 then
								barBorderColor = specSettings.colors.bar.surgeOfLight2
							end

							if specSettings.audio.surgeOfLight2.enabled and not snapshotData.audio.surgeOfLight2Cue then
								snapshotData.audio.surgeOfLight2Cue = true
								PlaySoundFile(specSettings.audio.surgeOfLight2.sound, coreSettings.audio.channel.channel)
							end
						end
					end

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
					
					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

					local shadowfiend = snapshots[spells.shadowfiend.id]

					if TRB.Functions.Talent:IsTalentActive(spells.shadowfiend) and not shadowfiend.buff.isActive then
						local shadowfiendThresholdColor = specSettings.colors.threshold.over
						if specSettings.thresholds.shadowfiend.enabled and (not shadowfiend.cooldown:IsUnusable() or specSettings.thresholds.shadowfiend.cooldown) then
							local haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
							local shadowfiendMana = swingsRemaining * shadowfiend.spell.manaPercent * TRB.Data.character.maxResource

							if shadowfiend.cooldown:IsUnusable() then
								shadowfiendThresholdColor = specSettings.colors.threshold.unusable
							end

							if not haveTotem and shadowfiendMana > 0 and (castingBarValue + shadowfiendMana) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[8], resourceFrame, specSettings.thresholds.width, (castingBarValue + shadowfiendMana), TRB.Data.character.maxResource)
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
								resourceFrame.thresholds[8]:Show()

								if specSettings.thresholds.icons.showCooldown and shadowfiend.cooldown.remaining > 0 then
									resourceFrame.thresholds[8].icon.cooldown:SetCooldown(shadowfiend.cooldown.startTime, shadowfiend.cooldown.duration)
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

						if shadowfiend.buff.isActive then
							passiveValue = passiveValue + shadowfiend.attributes.resourceFinal

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

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				end

				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		elseif specId == 2 then
			local specSettings = classSettings.holy
			UpdateSnapshot_Holy()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
					local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
					local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
					local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]

					if snapshots[spells.lightweaver.id].buff.isActive then
						if specSettings.colors.bar.lightweaverBorderChange then
							barBorderColor = specSettings.colors.bar.lightweaver
						end

						if specSettings.audio.lightweaver.enabled and snapshotData.audio.lightweaverCue == false then
							snapshotData.audio.lightweaverCue = true
							PlaySoundFile(specSettings.audio.lightweaver.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.lightweaverCue = false
					end

					if snapshots[spells.resonantWords.id].buff.isActive then
						if specSettings.colors.bar.resonantWordsBorderChange then
							barBorderColor = specSettings.colors.bar.resonantWords
						end

						if specSettings.audio.resonantWords.enabled and snapshotData.audio.resonantWordsCue == false then
							snapshotData.audio.resonantWordsCue = true
							PlaySoundFile(specSettings.audio.resonantWords.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.resonantWordsCue = false
					end

					if snapshots[spells.surgeOfLight.id].buff.isActive then
						if snapshots[spells.surgeOfLight.id].buff.stacks == 1 then
							if specSettings.colors.bar.surgeOfLightBorderChange1 then
								barBorderColor = specSettings.colors.bar.surgeOfLight1
							end

							if specSettings.audio.surgeOfLight.enabled and not snapshotData.audio.surgeOfLightCue then
								snapshotData.audio.surgeOfLightCue = true
								PlaySoundFile(specSettings.audio.surgeOfLight.sound, coreSettings.audio.channel.channel)
							end
						end

						if snapshots[spells.surgeOfLight.id].buff.stacks == 2 then
							if specSettings.colors.bar.surgeOfLightBorderChange2 then
								barBorderColor = specSettings.colors.bar.surgeOfLight2
							end

							if specSettings.audio.surgeOfLight2.enabled and not snapshotData.audio.surgeOfLight2Cue then
								snapshotData.audio.surgeOfLight2Cue = true
								PlaySoundFile(specSettings.audio.surgeOfLight2.sound, coreSettings.audio.channel.channel)
							end
						end
					end

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
					
					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

					local shadowfiend = snapshots[spells.shadowfiend.id]

					if TRB.Functions.Talent:IsTalentActive(spells.shadowfiend) and not shadowfiend.buff.isActive then
						local shadowfiendThresholdColor = specSettings.colors.threshold.over
						if specSettings.thresholds.shadowfiend.enabled and (not shadowfiend.cooldown:IsUnusable() or specSettings.thresholds.shadowfiend.cooldown) then
							local haveTotem, timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = GetMaximumShadowfiendResults()
							local shadowfiendMana = swingsRemaining * shadowfiend.spell.manaPercent * TRB.Data.character.maxResource

							if shadowfiend.cooldown:IsUnusable() then
								shadowfiendThresholdColor = specSettings.colors.threshold.unusable
							end

							if not haveTotem and shadowfiendMana > 0 and (castingBarValue + shadowfiendMana) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[8], resourceFrame, specSettings.thresholds.width, (castingBarValue + shadowfiendMana), TRB.Data.character.maxResource)
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
					---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[8].icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(shadowfiendThresholdColor, true))
								resourceFrame.thresholds[8]:Show()

								if specSettings.thresholds.icons.showCooldown and shadowfiend.cooldown.remaining > 0 then
									resourceFrame.thresholds[8].icon.cooldown:SetCooldown(shadowfiend.cooldown.startTime, shadowfiend.cooldown.duration)
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

						if shadowfiend.buff.isActive then
							passiveValue = passiveValue + shadowfiend.attributes.resourceFinal

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[6], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)

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

					local resourceBarColor = nil
					local holyWordCooldownCompletes = false
					local holyWordCooldownCompletesKey = nil

					if snapshotData.casting.spellKey ~= nil then
						if spells[snapshotData.casting.spellKey] ~= nil and
							spells[snapshotData.casting.spellKey].holyWordKey ~= nil and
							spells[snapshotData.casting.spellKey].holyWordReduction ~= nil and
							spells[snapshotData.casting.spellKey].holyWordReduction >= 0 and
							TRB.Functions.Talent:IsTalentActive(spells[spells[snapshotData.casting.spellKey].holyWordKey]) then

							local castTimeRemains = snapshotData.casting.endTime - currentTime
							local holyWordCooldownRemaining = snapshots[spells[spells[snapshotData.casting.spellKey].holyWordKey].id].cooldown:GetRemainingTime(currentTime)

							if (holyWordCooldownRemaining - CalculateHolyWordCooldown(spells[snapshotData.casting.spellKey].holyWordReduction, spells[snapshotData.casting.spellKey].id) - castTimeRemains) <= 0 then
								holyWordCooldownCompletes = true
								holyWordCooldownCompletesKey = spells[snapshotData.casting.spellKey].holyWordKey
								if specSettings.bar[spells[snapshotData.casting.spellKey].holyWordKey .. "Enabled"] then
									resourceBarColor = specSettings.colors.bar[spells[snapshotData.casting.spellKey].holyWordKey]
								end
							end
						end
					end

					if snapshots[spells.apotheosis.id].buff.isActive and resourceBarColor == nil then
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

						if useEndOfApotheosisColor and snapshots[spells.apotheosis.id].buff.remaining <= timeThreshold then
							resourceBarColor = specSettings.colors.bar.apotheosisEnd
						else
							resourceBarColor = specSettings.colors.bar.apotheosis
						end
					elseif resourceBarColor == nil then
						resourceBarColor = specSettings.colors.bar.base
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))

					local cpBR, cpBG, cpBB, cpBA = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpCompleteColor = specSettings.colors.comboPoints.completeCooldown
					local currentCp = 1
					
					for x = 1, 3, 1 do
						local spell
						local completes = false
						local holyWordBarsEnabled = false
						if x == 1 then
							spell = spells.holyWordSerenity
							cpColor = specSettings.colors.comboPoints.holyWordSerenity
							holyWordBarsEnabled = specSettings.colors.comboPoints.holyWordSerenityEnabled
						elseif x == 2 then
							spell = spells.holyWordSanctify
							cpColor = specSettings.colors.comboPoints.holyWordSanctify
							holyWordBarsEnabled = specSettings.colors.comboPoints.holyWordSanctifyEnabled
						else
							spell = spells.holyWordChastise
							cpColor = specSettings.colors.comboPoints.holyWordChastise
							holyWordBarsEnabled = specSettings.colors.comboPoints.holyWordChastiseEnabled
						end
						local cooldown = snapshots[spell.id].cooldown

						if holyWordCooldownCompletes and spells[holyWordCooldownCompletesKey].id == spell.id then
							completes = true
						end

						if TRB.Functions.Talent:IsTalentActive(spell) and holyWordBarsEnabled then
							local cp1Time = 1
							local cp1Duration = 1
							local cp1Color = cpColor
							local cp2Time = 1
							local cp2Duration = 1
							local cp2Color = cpColor
							local hasCp2 = false
							if cooldown.maxCharges == 2 then -- Miracle Worker for Serenity and Sanctify
								if cooldown.charges == 2 then
									cp1Time = 1
									cp1Duration = 1
									cp2Time = 1
									cp2Duration = 1
									hasCp2 = true
								elseif cooldown.charges == 1 then
									cp1Time = 1
									cp1Duration = 1
									cp2Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
									cp2Duration = cooldown.duration
									if completes then
										cp2Color = cpCompleteColor
									end
									hasCp2 = true
								else
									cp1Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
									cp1Duration = cooldown.duration
									if completes then
										cp1Color = cpCompleteColor
									end
									cp2Time = 0
									cp2Duration = 1
									hasCp2 = true
								end
							else -- Chastise or baseline Serenity and Sanctify
								hasCp2 = false
								if cooldown.onCooldown then
									cp1Time = cooldown.duration - cooldown:GetRemainingTime(currentTime)
									cp1Duration = cooldown.duration
									if completes then
										cp1Color = cpCompleteColor
									end
								else
									cp1Time = 1
									cp1Duration = 1
								end
							end
							
							if cp1Time < 0 then
								cp1Time = cp1Duration
							end
							
							if cp2Time < 0 then
								cp2Time = cp2Duration
							end

							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp1Time, cp1Duration)
							TRB.Frames.resource2Frames[currentCp].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cp1Color, true))
							TRB.Frames.resource2Frames[currentCp].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
							TRB.Frames.resource2Frames[currentCp].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBA)
							currentCp = currentCp + 1

							if hasCp2 then
								TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[currentCp].resourceFrame, cp2Time, cp2Duration)
								TRB.Frames.resource2Frames[currentCp].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cp2Color, true))
								TRB.Frames.resource2Frames[currentCp].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
								TRB.Frames.resource2Frames[currentCp].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBA)
								currentCp = currentCp + 1
							end
						end
					end
				end

				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		elseif specId == 3 then
			local specSettings = classSettings.shadow
			UpdateSnapshot_Shadow()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentInsanity = snapshotData.attributes.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					local barBorderColor = specSettings.colors.bar.border
					local barColor = specSettings.colors.bar.base

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap
						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						barBorderColor = specSettings.colors.bar.border
						snapshotData.audio.overcapCue = false
					end

					if specSettings.colors.bar.mindFlayInsanityBorderChange and TRB.Functions.Class:IsValidVariableForSpec("$mfiTime") then
						barBorderColor = specSettings.colors.bar.borderMindFlayInsanity
					end

					if specSettings.colors.bar.deathspeaker.enabled and TRB.Functions.Class:IsValidVariableForSpec("$deathspeakerTime") then
						barBorderColor = specSettings.colors.bar.deathspeaker.color
					end
					
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = snapshotData.casting.resourceFinal + currentInsanity
					else
						castingBarValue = currentInsanity
					end

					if specSettings.bar.showPassive and
						(TRB.Functions.Talent:IsTalentActive(spells.auspiciousSpirits) or
						(snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal) > 0 or
						snapshots[spells.idolOfCthun.id].attributes.resourceFinal > 0) then
						passiveValue = ((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * (snapshotData.targetData.custom.auspiciousSpiritsGenerate or 0)) + snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal + snapshots[spells.idolOfCthun.id].attributes.resourceFinal)
						if (snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal) > 0 and (castingBarValue + (snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal)) < TRB.Data.character.maxResource then
							TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, specSettings.thresholds.width, (castingBarValue + (snapshots[spells.shadowfiend.id].attributes.resourceFinal + snapshots[spells.devouredDespair.id].attributes.resourceFinal)), TRB.Data.character.maxResource)
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
									elseif snapshots[spells.mindDevourer.id].buff.endTime ~= nil and currentTime < snapshots[spells.mindDevourer.id].buff.endTime then
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
									elseif snapshots[spells.mindDevourer.id].buff.endTime ~= nil and
										currentTime < snapshots[spells.mindDevourer.id].buff.endTime and
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
									elseif snapshots[spells.mindDevourer.id].buff.endTime ~= nil and
										currentTime < snapshots[spells.mindDevourer.id].buff.endTime and
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

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spells[spell.settingKey].id], specSettings)
						end
					end

					if snapshots[spells.mindDevourer.id].buff.isActive or currentInsanity >= TRB.Data.character.devouringPlagueThreshold or snapshots[spells.mindDevourer.id].buff.isActive then
						if specSettings.colors.bar.flashEnabled then
							TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if snapshots[spells.mindDevourer.id].buff.isActive and specSettings.audio.mdProc.enabled and snapshotData.audio.playedMdCue == false then
							snapshotData.audio.playedDpCue = true
							snapshotData.audio.playedMdCue = true
							PlaySoundFile(specSettings.audio.mdProc.sound, coreSettings.audio.channel.channel)
						elseif specSettings.audio.dpReady.enabled and snapshotData.audio.playedDpCue == false then
							snapshotData.audio.playedDpCue = true
							PlaySoundFile(specSettings.audio.dpReady.sound, coreSettings.audio.channel.channel)
						end
					else
						barContainerFrame:SetAlpha(1.0)
						snapshotData.audio.playedDpCue = false
						snapshotData.audio.playedMdCue = false
					end

					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < currentInsanity then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
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

					if snapshots[spells.mindDevourer.id].buff.isActive or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.devouringPlagueUsableCasting, true))
					else
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					end
					
					if specSettings.colors.bar.instantMindBlast.enabled and snapshots[spells.mindBlast.id].cooldown.charges > 0 and snapshots[spells.shadowyInsight.id].buff.isActive then
						barColor = specSettings.colors.bar.instantMindBlast.color
					elseif snapshots[spells.voidform.id].buff.isActive or snapshots[spells.darkAscension.id].buff.isActive then
						local timeLeft = snapshots[spells.voidform.id].buff.remaining
						if snapshots[spells.darkAscension.id].buff.isActive then
							timeLeft = snapshots[spells.darkAscension.id].buff.remaining
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
						elseif snapshots[spells.mindDevourer.id].buff.isActive or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
							barColor = specSettings.colors.bar.devouringPlagueUsable
						else
							barColor = specSettings.colors.bar.inVoidform
						end
					else
						if snapshots[spells.mindDevourer.id].buff.isActive or currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
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
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName, _, auraType = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			local settings
			if specId == 1 then
				settings = TRB.Data.settings.priest.discipline
			elseif specId == 2 then
				settings = TRB.Data.settings.priest.holy
			elseif specId == 3 then
				settings = TRB.Data.settings.priest.shadow
			end

			if destGUID == TRB.Data.character.guid then
				if (specId == 1 and TRB.Data.barConstructedForSpec == "discipline") or (specId == 2 and TRB.Data.barConstructedForSpec == "holy") then -- Let's check raid effect mana stuff
					if settings.passiveGeneration.symbolOfHope and (spellId == spells.symbolOfHope.tickId or spellId == spells.symbolOfHope.id) then
						local castByToken = UnitTokenFromGUID(sourceGUID)
						local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
						symbolOfHope.buff:Initialize(type, nil, castByToken)
					elseif settings.passiveGeneration.innervate and spellId == spells.innervate.id then
						local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
						innervate.buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshotData.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshotData.audio.innervateCue = false
						end
					elseif settings.passiveGeneration.manaTideTotem and spellId == spells.manaTideTotem.id then
						local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
						manaTideTotem.buff:Initialize(type)
					elseif spellId == spells.potionOfChilledClarity.id then
						local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
						potionOfChilledClarity.buff:Initialize(type)
					elseif spellId == spells.moltenRadiance.id then
						local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
						moltenRadiance.buff:Initialize(type)
					elseif settings.shadowfiend.enabled and type == "SPELL_ENERGIZE" and spellId == snapshots[spells.shadowfiend.id].spell.energizeId and sourceName == snapshots[spells.shadowfiend.id].spell.name then
						snapshots[spells.shadowfiend.id].attributes.swingTime = currentTime
						snapshots[spells.shadowfiend.id].cooldown:Refresh(true)
						triggerUpdate = true
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
					if settings.mindbender.enabled and type == "SPELL_ENERGIZE" and (spellId == spells.mindbender.energizeId or spellId == spells.shadowfiend.energizeId) and sourceName == spells.shadowfiend.name then
						if sourceGUID == snapshots[spells.shadowfiend.id].attributes.guid then
							snapshots[spells.shadowfiend.id].attributes.swingTime = currentTime
							snapshots[spells.shadowfiend.id].cooldown:Refresh(true)
						end
						triggerUpdate = true
					end
				end
			end
			
			if sourceGUID == TRB.Data.character.guid then
				if (specId == 1 and TRB.Data.barConstructedForSpec == "discipline") or (specId == 2 and TRB.Data.barConstructedForSpec == "holy") then -- Let's check raid effect mana stuff
					if spellId == spells.potionOfFrozenFocusRank1.spellId or spellId == spells.potionOfFrozenFocusRank2.spellId or spellId == spells.potionOfFrozenFocusRank3.spellId then
						local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
						channeledManaPotion.buff:Initialize(type)
					elseif spellId == spells.surgeOfLight.id then
						snapshots[spellId].buff:Initialize(type)
						if type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
							snapshotData.audio.surgeOfLight2Cue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshotData.audio.surgeOfLightCue = false
							snapshotData.audio.surgeOfLight2Cue = false
						end
					elseif type == "SPELL_SUMMON" and (spellId == spells.shadowfiend.id or (specId == 1 and spellId == spells.mindbender.id)) then
						local currentSf = snapshots[spells.shadowfiend.id].attributes
						local totemId = 1
						currentSf.guid = sourceGUID
						currentSf.totemId = totemId
					end
				end

				if specId == 1 and TRB.Data.barConstructedForSpec == "discipline" then
					if spellId == spells.purgeTheWicked.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "holy" then
					if spellId == spells.apotheosis.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.lightweaver.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.resonantWords.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.holyWordSerenity.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Serenity
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.holyWordSanctify.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Sanctify
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.holyWordChastise.id then
						if type == "SPELL_CAST_SUCCESS" then -- Cast HW: Chastise
							snapshots[spellId].cooldown:Initialize()
						end
					elseif spellId == spells.divineConversation.id then
						snapshots[spellId].buff:Initialize(type, true)
					elseif spellId == spells.prayerFocus.id then
						snapshots[spellId].buff:Initialize(type, true)
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" then
					if spellId == spells.voidform.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.darkAscension.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.vampiricTouch.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif spellId == spells.devouringPlague.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
						end
					elseif settings.auspiciousSpiritsTracker and TRB.Functions.Talent:IsTalentActive(spells.auspiciousSpirits) and spellId == spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
						for guid, _ in pairs(targetData.targets) do
							if targetData.targets[guid].spells[spells.vampiricTouch.id].active then
								targetData.targets[guid].spells[spells.auspiciousSpirits.id].active = true
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
						snapshots[spells.mindDevourer.id].buff:Initialize(type)
					elseif spellId == spells.devouredDespair.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.mindFlayInsanity.buffId or spellId == spells.mindSpikeInsanity.buffId then
						snapshots[spells.surgeOfInsanity.id].buff:Initialize(type)
					elseif spellId == spells.deathspeaker.buffId then
						snapshots[spells.deathspeaker.id].buff:Initialize(type)
						if type == "SPELL_AURA_APPLIED" then
							if TRB.Data.settings.priest.shadow.audio.deathspeaker.enabled then
								PlaySoundFile(TRB.Data.settings.priest.shadow.audio.deathspeaker.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == spells.twistOfFate.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.shadowyInsight.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.mindMelt.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.idolOfYoggSaron.id then
						snapshots[spellId].buff:Initialize(type)
					elseif spellId == spells.thingFromBeyond.id then
						snapshots[spellId].buff:Initialize(type)
					elseif type == "SPELL_SUMMON" and settings.voidTendrilTracker and (spellId == spells.idolOfCthun_Tendril.id or spellId == spells.idolOfCthun_Lasher.id) then
						InitializeVoidTendril(destGUID)
						if spellId == spells.idolOfCthun_Tendril.id then
							snapshots[spells.idolOfCthun.id].attributes.activeList[destGUID].type = "Tendril"
						elseif spellId == spells.idolOfCthun_Lasher.id then
							snapshots[spells.idolOfCthun.id].attributes.activeList[destGUID].type = "Lasher"
							snapshots[spells.idolOfCthun.id].attributes.activeList[destGUID].targetsHit = 0
							snapshots[spells.idolOfCthun.id].attributes.activeList[destGUID].hasStruckTargets = true
						end

						snapshots[spells.idolOfCthun.id].attributes.numberActive = snapshots[spells.idolOfCthun.id].attributes.numberActive + 1
						snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining + spells.lashOfInsanity_Tendril.ticks
						snapshots[spells.idolOfCthun.id].attributes.activeList[destGUID].startTime = currentTime
						snapshots[spells.idolOfCthun.id].attributes.activeList[destGUID].tickTime = currentTime
					elseif type == "SPELL_SUMMON" and settings.mindbender.enabled and (spellId == spells.shadowfiend.id or spellId == spells.mindbender.id) then
						local currentSf = snapshots[spells.shadowfiend.id].attributes
						local totemId = 1
						currentSf.guid = sourceGUID
						currentSf.totemId = totemId
					end
				end

				-- Spec agnostic
				if spellId == spells.shadowWordPain.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						triggerUpdate = targetData:HandleCombatLogDebuff(spellId, type, destGUID)
					end
				end
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "shadow" and settings.voidTendrilTracker and (spellId == spells.idolOfCthun_Tendril.idTick or spellId == spells.idolOfCthun_Lasher.idTick) and CheckVoidTendrilExists(sourceGUID) then
				if spellId == spells.idolOfCthun_Lasher.idTick and type == "SPELL_DAMAGE" then
					if currentTime > (snapshots[spells.idolOfCthun.id].attributes.activeList[sourceGUID].tickTime + 0.1) then --This is a new tick
						snapshots[spells.idolOfCthun.id].attributes.activeList[sourceGUID].targetsHit = 0
					end
					snapshots[spells.idolOfCthun.id].attributes.activeList[sourceGUID].targetsHit = snapshots[spells.idolOfCthun.id].attributes.activeList[sourceGUID].targetsHit + 1
					snapshots[spells.idolOfCthun.id].attributes.activeList[sourceGUID].tickTime = currentTime
					snapshots[spells.idolOfCthun.id].attributes.activeList[sourceGUID].hasStruckTargets = true
				else
					snapshots[spells.idolOfCthun.id].attributes.activeList[sourceGUID].tickTime = currentTime
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
		if specId == 1 and TRB.Data.settings.core.experimental.specs.priest.discipline then
			specCache.discipline.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Discipline()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.discipline)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.shadowWordPain)
			targetData:AddSpellTracking(spells.purgeTheWicked)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Discipline
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.discipline)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.discipline)

			local lookup = TRB.Data.lookup or {}
			lookup["#ptw"] = spells.purgeTheWicked.icon
			lookup["#purgeTheWicked"] = spells.purgeTheWicked.icon
			lookup["#swp"] = spells.shadowWordPain.icon
			lookup["#shadowWordPain"] = spells.shadowWordPain.icon
			lookup["#innervate"] = spells.innervate.icon
			lookup["#mr"] = spells.moltenRadiance.icon
			lookup["#moltenRadiance"] = spells.moltenRadiance.icon
			lookup["#mtt"] = spells.manaTideTotem.icon
			lookup["#manaTideTotem"] = spells.manaTideTotem.icon
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
			TRB.Data.lookup = lookup
			TRB.Data.lookupLogic = {}

			if TRB.Data.barConstructedForSpec ~= "discipline" then
				TRB.Data.barConstructedForSpec = "discipline"
				ConstructResourceBar(specCache.discipline.settings)
			end
		elseif specId == 2 then
			specCache.holy.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Holy()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.holy)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.shadowWordPain)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Holy
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.holy)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.holy)

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
			TRB.Data.lookup = lookup
			TRB.Data.lookupLogic = {}

			if TRB.Data.barConstructedForSpec ~= "holy" then
				TRB.Data.barConstructedForSpec = "holy"
				ConstructResourceBar(specCache.holy.settings)
			end
		elseif specId == 3 then
			specCache.shadow.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Shadow()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.shadow)

			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.auspiciousSpirits, false, true)
			targetData:AddSpellTracking(spells.devouringPlague)
			targetData:AddSpellTracking(spells.shadowWordPain)
			targetData:AddSpellTracking(spells.vampiricTouch)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.priest.shadow)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.shadow)

			local lookup = {}
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
			TRB.Data.lookup = lookup
			TRB.Data.lookupLogic = {}

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
							TRB.Data.settings.priest.discipline = TRB.Functions.LibSharedMedia:ValidateLsmValues("Discipline Priest", TRB.Data.settings.priest.discipline)
							TRB.Data.settings.priest.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues("Holy Priest", TRB.Data.settings.priest.holy)
							TRB.Data.settings.priest.shadow = TRB.Functions.LibSharedMedia:ValidateLsmValues("Shadow Priest", TRB.Data.settings.priest.shadow)
							
							FillSpellData_Discipline()
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
		---@type TRB.Classes.Snapshot[]
		local snapshots = TRB.Data.snapshotData.snapshots

		if specId == 1 and TRB.Data.settings.core.experimental.specs.priest.discipline then
			TRB.Data.character.specName = "discipline"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.Spell:FillSpellDataManaCost(spells)

			local bootsItemLink = GetInventoryItemLink("player", 8)
			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeVersion = ""
			local imbuedFrostweaveSlippers = false
			
			if bootsItemLink ~= nil then
				imbuedFrostweaveSlippers = TRB.Functions.Item:DoesItemLinkMatchId(bootsItemLink, spells.imbuedFrostweaveSlippers.itemId)
			end

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
			TRB.Data.character.items.imbuedFrostweaveSlippers = imbuedFrostweaveSlippers

			if TRB.Functions.Talent:IsTalentActive(spells.mindbender) then
				snapshots[spells.shadowfiend.id].spell = spells.mindbender
			else
				snapshots[spells.shadowfiend.id].spell = spells.shadowfiend
			end
		elseif specId == 2 then
			TRB.Data.character.specName = "holy"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.Spell:FillSpellDataManaCost(spells)

			local bootsItemLink = GetInventoryItemLink("player", 8)
			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeVersion = ""
			local imbuedFrostweaveSlippers = false
			
			if bootsItemLink ~= nil then
				imbuedFrostweaveSlippers = TRB.Functions.Item:DoesItemLinkMatchId(bootsItemLink, spells.imbuedFrostweaveSlippers.itemId)
			end
						
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
			TRB.Data.character.items.imbuedFrostweaveSlippers = imbuedFrostweaveSlippers

			local totalHolyWordCharges = 0
			
			if TRB.Functions.Talent:IsTalentActive(spells.holyWordSerenity) and TRB.Data.settings.priest.holy.colors.comboPoints.holyWordSerenityEnabled then
				totalHolyWordCharges = totalHolyWordCharges + 1
				if TRB.Functions.Talent:IsTalentActive(spells.miracleWorker) then
					totalHolyWordCharges = totalHolyWordCharges + 1
				end
			end
			
			if TRB.Functions.Talent:IsTalentActive(spells.holyWordSanctify) and TRB.Data.settings.priest.holy.colors.comboPoints.holyWordSanctifyEnabled then
				totalHolyWordCharges = totalHolyWordCharges + 1
				if TRB.Functions.Talent:IsTalentActive(spells.miracleWorker) then
					totalHolyWordCharges = totalHolyWordCharges + 1
				end
			end
			
			if TRB.Functions.Talent:IsTalentActive(spells.holyWordChastise) and TRB.Data.settings.priest.holy.colors.comboPoints.holyWordChastiseEnabled then
				totalHolyWordCharges = totalHolyWordCharges + 1
			end

			TRB.Data.character.maxResource2 = totalHolyWordCharges
			TRB.Functions.Bar:SetPosition(TRB.Data.settings.priest.holy, TRB.Frames.barContainerFrame)
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
			
			if TRB.Functions.Talent:IsTalentActive(spells.mindbender) then
				snapshots[spells.shadowfiend.id].spell = spells.mindbender
			else
				snapshots[spells.shadowfiend.id].spell = spells.shadowfiend
			end
			
			if TRB.Functions.Talent:IsTalentActive(spells.mindSpike) then
				snapshots[spells.surgeOfInsanity.id].spell = spells.mindSpikeInsanity
			else
				snapshots[spells.surgeOfInsanity.id].spell = spells.mindFlayInsanity
			end
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.priest.discipline == true and TRB.Data.settings.core.experimental.specs.priest.discipline then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.discipline)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
		elseif specId == 2 and TRB.Data.settings.core.enabled.priest.holy == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.priest.holy)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = "CUSTOM"
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
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

		if specId == 1 and TRB.Data.settings.core.experimental.specs.priest.discipline then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.priest.discipline.displayBar.alwaysShow) and (
						(not TRB.Data.settings.priest.discipline.displayBar.notZeroShow) or
						(TRB.Data.settings.priest.discipline.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.priest.discipline.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.priest.holy.displayBar.alwaysShow) and (
						(not TRB.Data.settings.priest.holy.displayBar.notZeroShow) or
						(TRB.Data.settings.priest.holy.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
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
						(TRB.Data.settings.priest.shadow.displayBar.notZeroShow and snapshotData.attributes.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.priest.shadow.displayBar.neverShow == true then
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
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
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
			settings = TRB.Data.settings.priest.discipline
		elseif specId == 2 then
			settings = TRB.Data.settings.priest.holy
		elseif specId == 3 then
			settings = TRB.Data.settings.priest.shadow
		else
			return false
		end

		if specId == 1 or specId == 2 then
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
			elseif var == "$solStacks" then
				if snapshots[spells.surgeOfLight.id].buff.isActive then
					valid = true
				end
			elseif var == "$solTime" then
				if snapshots[spells.surgeOfLight.id].buff.isActive then
					valid = true
				end
			elseif var == "$sfMana" then
				if snapshots[spells.shadowfiend.id].attributes.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$sfGcds" then
				if snapshots[spells.shadowfiend.id].attributes.remaining.gcds > 0 then
					valid = true
				end
			elseif var == "$sfSwings" then
				if snapshots[spells.shadowfiend.id].attributes.remaining.swings > 0 then
					valid = true
				end
			elseif var == "$sfTime" then
				if snapshots[spells.shadowfiend.id].attributes.remaining.time > 0 then
					valid = true
				end
			end
		end

		if specId == 1 then
			if var == "$passive" then
				if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
					valid = true
				end
			end
		elseif specId == 2 then
			if var == "$passive" then
				if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
					valid = true
				end
			elseif var == "$lightweaverTime" then
				if snapshots[spells.lightweaver.id].buff.isActive then
					valid = true
				end
			elseif var == "$lightweaverStacks" then
				if snapshots[spells.lightweaver.id].buff.isActive then
					valid = true
				end
			elseif var == "$rwTime" then
				if snapshots[spells.resonantWords.id].buff.isActive then
					valid = true
				end
			elseif var == "$apotheosisTime" then
				if snapshots[spells.apotheosis.id].buff.isActive then
					valid = true
				end
			elseif var == "$hwChastiseTime" then
				if snapshots[spells.holyWordChastise.id].cooldown.remaining > 0 then
					valid = true
				end
			elseif var == "$hwSerenityTime" then
				if snapshots[spells.holyWordSerenity.id].cooldown.remaining > 0 then
					valid = true
				end
			elseif var == "$hwSanctifyTime" then
				if snapshots[spells.holyWordSanctify.id].cooldown.remaining > 0 then
					valid = true
				end
			end
		elseif specId == 3 then
			if var == "$vfTime" then
				if (snapshots[spells.voidform.id].buff.remaining ~= nil and snapshots[spells.voidform.id].buff.remaining > 0) or
					(snapshots[spells.darkAscension.id].buff.remaining ~= nil and snapshots[spells.darkAscension.id].buff.remaining > 0) then
					valid = true
				end
			elseif var == "$resource" or var == "$insanity" then
				if snapshotData.attributes.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$insanityMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$insanityTotal" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) or
					(((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + snapshots[spells.shadowfiend.id].attributes.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$insanityPlusCasting" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
				local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
				if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$insanityPlusPassive" then
				if snapshotData.attributes.resource > 0 or
					((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + snapshots[spells.shadowfiend.id].attributes.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$passive" then
				if ((CalculateInsanityGain(spells.auspiciousSpirits.insanity) * snapshotData.targetData.count[spells.auspiciousSpirits.id]) + snapshots[spells.shadowfiend.id].attributes.resourceRaw + snapshots[spells.idolOfCthun.id].attributes.resourceFinal) > 0 then
					valid = true
				end
			elseif var == "$mbInsanity" then
				if snapshots[spells.shadowfiend.id].attributes.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$mbGcds" then
				if snapshots[spells.shadowfiend.id].attributes.remaining.gcds > 0 then
					valid = true
				end
			elseif var == "$mbSwings" then
				if snapshots[spells.shadowfiend.id].attributes.remaining.swings > 0 then
					valid = true
				end
			elseif var == "$mbTime" then
				if snapshots[spells.shadowfiend.id].attributes.remaining.time > 0 then
					valid = true
				end
			elseif var == "$loiInsanity" then
				if snapshots[spells.idolOfCthun.id].attributes.resourceFinal > 0 then
					valid = true
				end
			elseif var == "$loiTicks" then
				if snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining > 0 then
					valid = true
				end
			elseif var == "$cttvEquipped" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and (TRB.Functions.Talent:IsTalentActive(spells.idolOfCthun) or TRB.Data.character.items.callToTheVoid == true) then
					valid = true
				end
			elseif var == "$ecttvCount" then
				if TRB.Data.settings.priest.shadow.voidTendrilTracker and snapshots[spells.idolOfCthun.id].attributes.numberActive > 0 then
					valid = true
				end
			elseif var == "$asCount" then
				if snapshotData.targetData.count[spells.auspiciousSpirits.id] > 0 then
					valid = true
				end
			elseif var == "$asInsanity" then
				if snapshotData.targetData.count[spells.auspiciousSpirits.id] > 0 then
					valid = true
				end
			elseif var == "$vtCount" then
				if snapshotData.targetData.count[spells.vampiricTouch.id] > 0 then
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
				if snapshotData.targetData.count[spells.devouringPlague.id] > 0 then
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
				if snapshots[spells.mindDevourer.id].buff.isActive then
					valid = true
				end
			elseif var == "$mfiTime" then
				if snapshots[spells.surgeOfInsanity.id].buff.isActive then
					valid = true
				end
			elseif var == "$mfiStacks" then
				if snapshots[spells.surgeOfInsanity.id].buff.isActive then
					valid = true
				end
			elseif var == "$deathspeakerTime" then
				if snapshots[spells.deathspeaker.id].buff.isActive then
					valid = true
				end
			elseif var == "$tofTime" then
				if snapshots[spells.twistOfFate.id].buff.isActive then
					valid = true
				end
			elseif var == "$siTime" then
				if snapshots[spells.shadowyInsight.id].buff.isActive then
					valid = true
				end
			elseif var == "$mmTime" then
				if snapshots[spells.mindMelt.id].buff.isActive then
					valid = true
				end
			elseif var == "$mmStacks" then
				if snapshots[spells.mindMelt.id].buff.isActive then
					valid = true
				end
			elseif var == "$ysTime" then
				if snapshots[spells.idolOfYoggSaron.id].buff.isActive then
					valid = true
				end
			elseif var == "$ysStacks" then
				if snapshots[spells.idolOfYoggSaron.id].buff.isActive then
					valid = true
				end
			elseif var == "$ysRemainingStacks" then
				if TRB.Functions.Talent:IsTalentActive(spells.idolOfYoggSaron) then
					valid = true
				end
			elseif var == "$tfbTime" then
				if snapshots[spells.thingFromBeyond.id].buff.isActive then
					valid = true
				end
			else
				valid = false
			end
		end

		-- Spec Agnostic
		if var == "$swpCount" then
			if snapshotData.targetData.count[spells.shadowWordPain.id] > 0 or snapshotData.targetData.count[spells.purgeTheWicked.id] > 0 then
				valid = true
			end
		elseif var == "$swpTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				((target.spells[spells.shadowWordPain.id] ~= nil and
				target.spells[spells.shadowWordPain.id].remainingTime > 0) or
				(specId == 1 and target.spells[spells.purgeTheWicked.id] ~= nil and
				target.spells[spells.purgeTheWicked.id].remainingTime > 0)) then
				valid = true
			end
		end
		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if (specId ~= 1 and specId ~= 2 and specId ~= 3) or
			(specId == 1 and not TRB.Data.settings.core.experimental.specs.priest.discipline) then
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