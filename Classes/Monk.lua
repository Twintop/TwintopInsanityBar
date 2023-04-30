local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 10 then --Only do this if we're on a Monk!
	TRB.Functions.Class = TRB.Functions.Class or {}
	TRB.Functions.Character:ResetSnapshotData()
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resource2Frame = TRB.Frames.resource2Frame
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
		windwalker = {
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
		mistweaver = {
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
		-- Mistweaver
		specCache.mistweaver.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
			},
			dots = {
			},
		}

		specCache.mistweaver.character = {
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

		specCache.mistweaver.spells = {
			-- Monk Class Talents		
			soothingMist = {
				id = 115175,
				name = "",
				icon = "",
				isTalent = true,
				baseline = true
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
			}

		}

		specCache.mistweaver.snapshotData.manaRegen = 0
		specCache.mistweaver.snapshotData.audio = {
			innervateCue = false
		}
		specCache.mistweaver.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {}
		}
		specCache.mistweaver.snapshotData.innervate = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.mistweaver.snapshotData.manaTideTotem = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.mistweaver.snapshotData.symbolOfHope = {
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
		specCache.mistweaver.snapshotData.channeledManaPotion = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.mistweaver.snapshotData.potion = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.mistweaver.snapshotData.potionOfChilledClarity = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.mistweaver.snapshotData.conjuredChillglobe = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.preservation.snapshotData.moltenRadiance = {
			spellId = nil,
			startTime = nil,
			duration = 0,
			manaPerTick = 0,
			mana = 0
		}

		specCache.mistweaver.barTextVariables = {
			icons = {},
			values = {}
		}


		-- Windwalker
		specCache.windwalker.Global_TwintopResourceBar = {
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

		specCache.windwalker.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			maxResource2 = 5,
			effects = {
			},
			items = {}
		}

		specCache.windwalker.spells = {
			-- Monk Class Baseline Abilities
			blackoutKick = {
				id = 100784,
				name = "",
				icon = "",
				comboPoints = 1,
				isTalent = false,
				baseline = true
			},
			cracklingJadeLightning = {
				id = 117952,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 1,
				settingKey = "cracklingJadeLightning",
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},
			expelHarm = {
				id = 322101,
				name = "",
				icon = "",
				energy = -15,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 2,
				settingKey = "expelHarm",
				hasCooldown = true,
				cooldown = 15,
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},
			markOfTheCrane = {
				id = 228287,
				name = "",
				icon = "",
				duration = 20,
				isTalent = false,
				baseline = true
			},
			spinningCraneKick = {
				id = 101546,
				name = "",
				icon = "",
				comboPoints = 2,
				isTalent = false,
				baseline = true
			},
			tigerPalm = {
				id = 100780,
				name = "",
				icon = "",
				energy = -50,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 3,
				settingKey = "tigerPalm",
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},
			touchOfDeath = {
				id = 322109,
				name = "",
				icon = "",
				healthPercent = 0.35,
				eliteHealthPercent = 0.15,
				isTalent = false,
				baseline = true
			},
			vivify = {
				id = 116670,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 4,
				settingKey = "vivify",
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},

			-- Windwalker Spec Baseline Abilities

			-- Monk Class Talents
			risingSunKick = {
				id = 107428,
				name = "",
				icon = "",
				comboPoints = 2,
				isTalent = true,
				baseline = true
			},
			detox = {
				id = 218164,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 5,
				settingKey = "detox",
				hasCooldown = true,
				cooldown = 8,
				thresholdUsable = false,
				isTalent = true,
				baseline = true -- TODO: Check this in a future build
			},
			disable = {
				id = 116095,
				name = "",
				icon = "",
				energy = -15,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "disable",
				hasCooldown = false,
				thresholdUsable = false
			},
			paralysis = {
				id = 115078,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 7,
				settingKey = "paralysis",
				hasCooldown = true,
				cooldown = 45,
				thresholdUsable = false,
				isTalent = true,
			},
			paralysisRank2 = {
				id = 344359,
				name = "",
				icon = "",
				cooldownMod = -15,
				isTalent = true,
			},
			
			-- Windwalker Spec Talent Abilities

			fistsOfFury = {
				id = 113656,
				name = "",
				icon = "",
				comboPoints = 3,
				isTalent = true
			},

			-- Talents
			strikeOfTheWindlord = {
				id = 392983,
				name = "",
				icon = "",
				hasCooldown = true,
				isTalent = true,
				cooldown = 40
			},
			energizingElixir = {
				id = 115288,
				name = "",
				icon = "",
				comboPointsGenerated = 2,
				energyPerTick = 15,
				ticks = 5,
				tickRate = 1,
				isTalent = true
			},
			danceOfChiJi = {
				id = 325202,
				name = "",
				icon = "",
				isTalent = true
			},
			serenity = {
				id = 152173,
				name = "",
				icon = "",
				isTalent = true
			},
		}

		specCache.windwalker.snapshotData.energyRegen = 0
		specCache.windwalker.snapshotData.audio = {
			overcapCue = false,
			playedDanceOfChiJiCue = false
		}
		specCache.windwalker.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {},
			markOfTheCrane = 0
		}
		specCache.windwalker.snapshotData.detox = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.expelHarm = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.paralysis = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.strikeOfTheWindlord = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.serenity = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.windwalker.snapshotData.danceOfChiJi = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.windwalker.snapshotData.markOfTheCrane = {
			isActive = false,
			count = 0,
			activeCount = 0,
			minEndTime = nil,
			maxEndTime = nil,
			list = {}
		}

		specCache.windwalker.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Mistweaver()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "monk", "mistweaver")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.mistweaver)
	end

	local function Setup_Windwalker()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "monk", "windwalker")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.windwalker)
	end

	local function FillSpellData_Mistweaver()
		Setup_Mistweaver()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.mistweaver.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.mistweaver.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

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
		specCache.mistweaver.barTextVariables.values = {
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
			{ variable = "$potionOfFrozenFocusTicks", description = "Number of ticks left channeling Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Frozen Focus", printInSettings = true, color = false },
			
			{ variable = "$potionOfChilledClarityMana", description = "Passive mana regen while Potion of Chilled Clarity's effect is active", printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = "Time left on Potion of Chilled Clarity's effect", printInSettings = true, color = false },

			{ variable = "$potionCooldown", description = "How long, in seconds, is left on your potion's cooldown in MM:SS format", printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = "How long, in seconds, is left on your potion's cooldown in seconds", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.mistweaver.spells = spells
	end

	local function FillSpellData_Windwalker()
		Setup_Windwalker()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.windwalker.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.windwalker.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#blackoutKick", icon = spells.blackoutKick.icon, description = spells.blackoutKick.name, printInSettings = true },
			{ variable = "#cracklingJadeLightning", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = true },
			{ variable = "#cjl", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = false },
			{ variable = "#danceOfChiJi", icon = spells.danceOfChiJi.icon, description = spells.danceOfChiJi.name, printInSettings = true },
			{ variable = "#detox", icon = spells.detox.icon, description = spells.detox.name, printInSettings = true },
			{ variable = "#disable", icon = spells.disable.icon, description = spells.disable.name, printInSettings = true },
			{ variable = "#energizingElixir", icon = spells.energizingElixir.icon, description = spells.energizingElixir.name, printInSettings = true },
			{ variable = "#expelHarm", icon = spells.expelHarm.icon, description = spells.expelHarm.name, printInSettings = true },
			{ variable = "#fistsOfFury", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = true },
			{ variable = "#fof", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = false },
			{ variable = "#strikeOfTheWindlord", icon = spells.strikeOfTheWindlord.icon, description = spells.strikeOfTheWindlord.name, printInSettings = true },
			{ variable = "#paralysis", icon = spells.paralysis.icon, description = spells.paralysis.name, printInSettings = true },
			{ variable = "#risingSunKick", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = true },
			{ variable = "#rsk", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = false },
			{ variable = "#serenity", icon = spells.serenity.icon, description = spells.serenity.name, printInSettings = true },
			{ variable = "#spinningCraneKick", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = true },
			{ variable = "#sck", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = false },
			{ variable = "#tigerPalm", icon = spells.tigerPalm.icon, description = spells.tigerPalm.name, printInSettings = true },
			{ variable = "#touchOfDeath", icon = spells.touchOfDeath.icon, description = spells.touchOfDeath.name, printInSettings = true },
			{ variable = "#vivify", icon = spells.vivify.icon, description = spells.vivify.name, printInSettings = true },
		}
		specCache.windwalker.barTextVariables.values = {
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
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },
			
			{ variable = "$chi", description = "Current Chi", printInSettings = true, color = false },
			{ variable = "$comboPoints", description = "Current Chi", printInSettings = false, color = false },
			{ variable = "$chiMax", description = "Maximum Chi", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Chi", printInSettings = false, color = false },

			{ variable = "$serenityTime", description = "Time remaining on Serenity buff", printInSettings = true, color = false },

			{ variable = "$danceOfChiJiTime", description = "Time remaining on Dance of Chi-Ji proc", printInSettings = true, color = false },

			{ variable = "$motcCount", description = "Number of unique targets contributing to Mark of the Crane", printInSettings = true, color = false },
			{ variable = "$motcActiveCount", description = "Number of still alive unique targets contributing to Mark of the Crane", printInSettings = true, color = false },
			{ variable = "$motcTime", description = "Time until your Mark of the Crane debuff expires on your current target", printInSettings = true, color = false },
			{ variable = "$motcMinTime", description = "Time until your oldest Mark of the Crane debuff expires", printInSettings = true, color = false },
			{ variable = "$motcMaxTime", description = "Time until your newest Mark of the Crane debuff expires", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.windwalker.spells = spells
	end

	local function CalculateAbilityResourceValue(resource, threshold)
		local modifier = 1.0

		return resource * modifier
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		
		if specId == 2 then -- Mistweaver
		elseif specId == 3 then -- Windwalker
			local motcTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 20 then
					TRB.Data.snapshotData.targetData.targets[guid].markOfTheCrane = false
					TRB.Data.snapshotData.targetData.targets[guid].markOfTheCraneRemaining = 0
				else
					if TRB.Data.snapshotData.targetData.targets[guid].serpentSting == true then
						motcTotal = motcTotal + 1
					end
				end
			end
			TRB.Data.snapshotData.targetData.markOfTheCrane = motcTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.Target:TargetsCleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 2 then
			elseif specId == 3 then
			end
		end
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end

		if specId == 2 then
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
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.monk.mistweaver)
		TRB.Frames.resource2ContainerFrame:Hide()
		elseif specId == 3 then
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
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
		end

		TRB.Functions.Bar:Construct(settings)

		if specId == 2  or specId == 3 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function GetSerenityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.serenity)
	end

	local function GetDanceOfChiJiRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.danceOfChiJi)
	end
	
	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.channeledManaPotion)
	end

	local function GetInnervateRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.innervate)
	end

	local function GetManaTideTotemRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.manaTideTotem)
	end

	local function GetMoltenRadianceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.moltenRadiance)
	end

	local function GetSymbolOfHopeRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.symbolOfHope)
	end

	local function GetPotionOfChilledClarityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.potionOfChilledClarity)
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

	local function GetGuidPositionInMarkOfTheCraneList(guid)
		local entries = TRB.Functions.Table:Length(TRB.Data.snapshotData.markOfTheCrane.list)
		for x = 1, entries do
			if TRB.Data.snapshotData.markOfTheCrane.list[x].guid == guid then
				return x
			end
		end
		return 0
	end

	local function ApplyMarkOfTheCrane(guid)
		local currentTime = GetTime()
		TRB.Data.snapshotData.targetData.targets[guid].markOfTheCrane = true
		TRB.Data.snapshotData.targetData.targets[guid].markOfTheCraneRemaining = TRB.Data.spells.markOfTheCrane.duration
		local listPosition = GetGuidPositionInMarkOfTheCraneList(guid)
		if listPosition > 0 then
			TRB.Data.snapshotData.markOfTheCrane.list[listPosition].startTime = currentTime
			TRB.Data.snapshotData.markOfTheCrane.list[listPosition].endTime = currentTime + TRB.Data.spells.markOfTheCrane.duration
		else
			TRB.Data.snapshotData.targetData.markOfTheCrane = TRB.Data.snapshotData.targetData.markOfTheCrane + 1
			table.insert(TRB.Data.snapshotData.markOfTheCrane.list, {
				guid = guid,
				endTime = currentTime + TRB.Data.spells.markOfTheCrane.duration
			})
		end
	end

	local function GetOldestOrExpiredMarkOfTheCraneListEntry(any, aliveOnly)
		local currentTime = GetTime()
		local entries = TRB.Functions.Table:Length(TRB.Data.snapshotData.markOfTheCrane.list)
		local oldestTime = currentTime
		local oldestId = 0

		if any then
			oldestTime = oldestTime + TRB.Data.spells.markOfTheCrane.duration
		end

		for x = 1, entries do
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.markOfTheCrane.list[x].guid] ~= nil and TRB.Data.snapshotData.markOfTheCrane.list[x].endTime > currentTime then
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.markOfTheCrane.list[x].guid].markOfTheCraneRemaining = TRB.Data.snapshotData.markOfTheCrane.list[x].endTime - currentTime
			end

			if TRB.Data.snapshotData.markOfTheCrane.list[x].endTime == nil or TRB.Data.snapshotData.markOfTheCrane.list[x].endTime < oldestTime and (not aliveOnly or TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.markOfTheCrane.list[x].guid] ~= nil) then
				oldestId = x
				oldestTime = TRB.Data.snapshotData.markOfTheCrane.list[x].endTime
			end
		end
		return oldestId
	end

	local function RemoveExcessMarkOfTheCraneEntries()
		while true do
			local id = GetOldestOrExpiredMarkOfTheCraneListEntry(false)

			if id == 0 then
				return
			else
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.markOfTheCrane.list[id].guid] ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.markOfTheCrane.list[id].guid].markOfTheCrane = false
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.markOfTheCrane.list[id].guid].markOfTheCraneRemaining = 0
				end
				table.remove(TRB.Data.snapshotData.markOfTheCrane.list, id)
			end
		end
	end
	
	local function IsTargetLowestInMarkOfTheCraneList()
		if TRB.Data.snapshotData.targetData.currentTargetGuid == nil then
			return false
		end

		local oldest = GetOldestOrExpiredMarkOfTheCraneListEntry(true, true)
		if oldest > 0 and TRB.Data.snapshotData.markOfTheCrane.list[oldest].guid == TRB.Data.snapshotData.targetData.currentTargetGuid then
			return true
		end

		return false
	end

	local function RefreshLookupData_Mistweaver()
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshotData.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.monk.mistweaver.colors.text.current
		local castingManaColor = TRB.Data.settings.monk.mistweaver.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.monk.mistweaver.manaPrecision or 1
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

		--$mttMana
		local _mttMana = TRB.Data.snapshotData.manaTideTotem.mana
		local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
		--$mttTime
		local _mttTime = GetManaTideTotemRemainingTime()
		local mttTime = string.format("%.1f", _mttTime)

		--$mrMana
		local _mrMana = TRB.Data.snapshotData.moltenRadiance.mana
		local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
		--$mrTime
		local _mrTime = GetMoltenRadianceRemainingTime()
		local mrTime = string.format("%.1f", _mrTime)

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

		--$potionOfChilledClarityMana
		local _potionOfChilledClarityMana = TRB.Data.snapshotData.potionOfChilledClarity.mana
		local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
		--$potionOfChilledClarityTime
		local _potionOfChilledClarityTime = GetPotionOfChilledClarityRemainingTime()
		local potionOfChilledClarityTime = string.format("%.1f", _potionOfChilledClarityTime)

		--$channeledMana
		local _channeledMana = CalculateManaGain(TRB.Data.snapshotData.channeledManaPotion.mana, true)
		local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
		--$potionOfFrozenFocusTicks
		local _potionOfFrozenFocusTicks = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining or 0
		local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
		--$potionOfFrozenFocusTime
		local _potionOfFrozenFocusTime = GetChanneledPotionRemainingTime()
		local potionOfFrozenFocusTime = string.format("%.1f", _potionOfFrozenFocusTime)
		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.monk.mistweaver.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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

		----------

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _channeledMana,
			ticks = TRB.Data.snapshotData.channeledManaPotion.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = TRB.Data.snapshotData.symbolOfHope.ticksRemaining or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#innervate"] = TRB.Data.spells.innervate.icon
		lookup["#mr"] = TRB.Data.spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = TRB.Data.spells.moltenRadiance.icon
		lookup["#mtt"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#soh"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#amp"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = TRB.Data.spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = TRB.Data.spells.potionOfChilledClarity.icon
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
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Windwalker()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.current
		local castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.casting

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if TRB.Data.settings.monk.windwalker.colors.text.overcapEnabled and overcap then
				currentEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overcap
				castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overcap
			elseif TRB.Data.settings.monk.windwalker.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(TRB.Data.spells) do
					local spell = TRB.Data.spells[k]
					if	spell ~= nil and spell.thresholdUsable == true then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overThreshold
					castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overThreshold
				end
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _regenEnergy = 0
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

		if TRB.Data.settings.monk.windwalker.generation.enabled then
			if TRB.Data.settings.monk.windwalker.generation.mode == "time" then
				_regenEnergy = TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.monk.windwalker.generation.time or 3.0)
			else
				_regenEnergy = TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.monk.windwalker.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy --+ _markOfTheCraneEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)
		
		--$serenityTime
		local _serenityTime = GetSerenityRemainingTime()
		local serenityTime = "0.0"
		if _serenityTime ~= nil then
			serenityTime = string.format("%.1f", _serenityTime)
		end
		
		--$danceOfChiJiTime
		local _danceOfChiJiTime = GetDanceOfChiJiRemainingTime()
		local danceOfChiJiTime = "0.0"
		if _danceOfChiJiTime ~= nil then
			danceOfChiJiTime = string.format("%.1f", _danceOfChiJiTime)
		end
		
		--$motcMinTime
		local _motcMinTime = (TRB.Data.snapshotData.markOfTheCrane.minEndTime or 0) - currentTime
		local motcMinTime = "0.0"
		if _motcMinTime > 0 then
			motcMinTime = string.format("%.1f", _motcMinTime)
		end
		
		--$motcMaxTime
		local _motcMaxTime = (TRB.Data.snapshotData.markOfTheCrane.maxEndTime or 0) - currentTime
		local motcMaxTime = "0.0"
		if _motcMaxTime > 0 then
			motcMaxTime = string.format("%.1f", _motcMaxTime)
		end

		
		local targetMotcId = GetGuidPositionInMarkOfTheCraneList(TRB.Data.snapshotData.targetData.currentTargetGuid)
		--$motcTime
		local _motcTime = 0

		if targetMotcId > 0 and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_motcTime = TRB.Data.snapshotData.markOfTheCrane.list[targetMotcId].endTime - currentTime
		end

		local _motcCount = TRB.Data.snapshotData.markOfTheCrane.count or 0
		local motcCount = tostring(_motcCount)
		local _motcActiveCount = TRB.Data.snapshotData.markOfTheCrane.activeCount or 0
		local motcActiveCount = tostring(_motcActiveCount)

		local motcTime

		if TRB.Data.settings.monk.windwalker.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if targetMotcId > 0 and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].markOfTheCrane then
				if not IsTargetLowestInMarkOfTheCraneList() then
					motcCount = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.up, TRB.Data.snapshotData.markOfTheCrane.count)
					motcActiveCount = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.up, TRB.Data.snapshotData.markOfTheCrane.activeCount)
					motcTime = string.format("|c%s%.1f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.up, _motcTime)
				else
					motcCount = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.pandemic, TRB.Data.snapshotData.markOfTheCrane.count)
					motcActiveCount = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.pandemic, TRB.Data.snapshotData.markOfTheCrane.activeCount)
					motcTime = string.format("|c%s%.1f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.pandemic, _motcTime)
				end
			else
				motcCount = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.down, TRB.Data.snapshotData.markOfTheCrane.count)
				motcActiveCount = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.down, TRB.Data.snapshotData.markOfTheCrane.activeCount)
				motcTime = string.format("|c%s%.1f|r", TRB.Data.settings.monk.windwalker.colors.text.dots.down, 0)
			end
		else
			motcTime = string.format("%.1f", _motcTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.dots = {
			motcCount = _motcCount,
			motcActiveCount = _motcActiveCount
		}
		Global_TwintopResourceBar.markOfTheCrane = {
			count = _motcCount,
			activeCount = _motcActiveCount,
			targetTime = _motcTime,
			minTime = _motcMinTime,
			maxTime = _motcMaxTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#blackoutKick"] = TRB.Data.spells.blackoutKick.icon
		lookup["#cracklingJadeLightning"] = TRB.Data.spells.cracklingJadeLightning.icon
		lookup["#cjl"] = TRB.Data.spells.cracklingJadeLightning.icon
		lookup["#danceOfChiJi"] = TRB.Data.spells.danceOfChiJi.icon
		lookup["#detox"] = TRB.Data.spells.detox.icon
		lookup["#disable"] = TRB.Data.spells.disable.icon
		lookup["#energizingElixir"] = TRB.Data.spells.energizingElixir.icon
		lookup["#expelHarm"] = TRB.Data.spells.expelHarm.icon
		lookup["#fistsOfFury"] = TRB.Data.spells.fistsOfFury.icon
		lookup["#fof"] = TRB.Data.spells.fistsOfFury.icon
		lookup["#strikeOfTheWindlord"] = TRB.Data.spells.strikeOfTheWindlord.icon
		lookup["#paralysis"] = TRB.Data.spells.paralysis.icon
		lookup["#risingSunKick"] = TRB.Data.spells.risingSunKick.icon
		lookup["#rsk"] = TRB.Data.spells.risingSunKick.icon
		lookup["#serenity"] = TRB.Data.spells.serenity.icon
		lookup["#spinningCraneKick"] = TRB.Data.spells.spinningCraneKick.icon
		lookup["#sck"] = TRB.Data.spells.spinningCraneKick.icon
		lookup["#tigerPalm"] = TRB.Data.spells.tigerPalm.icon
		lookup["#touchOfDeath"] = TRB.Data.spells.touchOfDeath.icon
		lookup["#vivify"] = TRB.Data.spells.vivify.icon

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
		lookup["$chi"] = TRB.Data.character.resource2
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$chiMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
			lookup["$passive"] = passiveEnergyMinusRegen
		else
			lookup["$passive"] = passiveEnergy
		end

		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		lookup["$serenityTime"] = serenityTime
		lookup["$danceOfChiJiTime"] = danceOfChiJiTime
		lookup["$motcMinTime"] = motcMinTime
		lookup["$motcMaxTime"] = motcMaxTime
		lookup["$motcTime"] = motcTime
		lookup["$motcCount"] = motcCount
		lookup["$motcActiveCount"] = motcActiveCount
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
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
		lookupLogic["$chi"] = TRB.Data.character.resource2
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$chiMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		if TRB.Data.character.maxResource == TRB.Data.snapshotData.resource then
			lookupLogic["$passive"] = _passiveEnergyMinusRegen
		else
			lookupLogic["$passive"] = _passiveEnergy
		end

		lookupLogic["$regen"] = _regenEnergy
		lookupLogic["$regenEnergy"] = _regenEnergy
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		lookupLogic["$serenityTime"] = _serenityTime
		lookupLogic["$danceOfChiJiTime"] = _danceOfChiJiTime
		lookupLogic["$motcMinTime"] = _motcMinTime
		lookupLogic["$motcMaxTime"] = _motcMaxTime
		lookupLogic["$motcTime"] = _motcTime
		lookupLogic["$motcCount"] = _motcCount
		lookupLogic["$motcActiveCount"] = _motcActiveCount
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
		TRB.Data.snapshotData.casting.startTime = currentTime
		TRB.Data.snapshotData.casting.resourceRaw = spell.energy
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.energy)
		TRB.Data.snapshotData.casting.spellId = spell.id
		TRB.Data.snapshotData.casting.icon = spell.icon
	end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function UpdateCastingResourceFinal_Mistweaver()
		-- Do nothing for now
		TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw * TRB.Data.snapshotData.innervate.modifier * TRB.Data.snapshotData.potionOfChilledClarity.modifier
	end

	local function CastingSpell()
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 2 then
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.soothingMist.id then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCostPerSecond(currentChannelId)

						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.soothingMist.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = manaCost
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.soothingMist.icon

						UpdateCastingResourceFinal_Mistweaver()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
					end
					return false
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

						TRB.Data.snapshotData.casting.startTime = currentSpellStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentSpellEndTime / 1000
						TRB.Data.snapshotData.casting.resourceRaw = manaCost
						TRB.Data.snapshotData.casting.spellId = spellId
						TRB.Data.snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Mistweaver()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 3 then
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.cracklingJadeLightning.id then
						TRB.Data.snapshotData.casting.cracklingJadeLightning = TRB.Data.spells.cracklingJadeLightning.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.cracklingJadeLightning.energy
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.cracklingJadeLightning.icon
						UpdateCastingResourceFinal()
					end
					return true
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateMarkOfTheCrane()
		RemoveExcessMarkOfTheCraneEntries()
		local entries = TRB.Functions.Table:Length(TRB.Data.snapshotData.markOfTheCrane.list)
		local minEndTime = nil
		local maxEndTime = nil
		local activeCount = 0
		local currentTime = GetTime()
		if entries > 0 then
			for x = 1, entries do
				activeCount = activeCount + 1
				TRB.Data.snapshotData.markOfTheCrane.isActive = true

				if TRB.Data.snapshotData.markOfTheCrane.list[x].endTime > (maxEndTime or 0) then
					maxEndTime = TRB.Data.snapshotData.markOfTheCrane.list[x].endTime
				end
				
				if TRB.Data.snapshotData.markOfTheCrane.list[x].endTime < (minEndTime or currentTime+999) then
					minEndTime = TRB.Data.snapshotData.markOfTheCrane.list[x].endTime
				end
			end
		end

		if activeCount > 0 then
			TRB.Data.snapshotData.markOfTheCrane.isActive = true
		else
			TRB.Data.snapshotData.markOfTheCrane.isActive = false
		end
---@diagnostic disable-next-line: redundant-parameter
		TRB.Data.snapshotData.markOfTheCrane.count = GetSpellCount(TRB.Data.spells.spinningCraneKick.id)

		-- Avoid race conditions from combat log events saying we have 6 marks when 5 is the max
		if TRB.Data.snapshotData.markOfTheCrane.count < activeCount then
			TRB.Data.snapshotData.markOfTheCrane.activeCount = TRB.Data.snapshotData.markOfTheCrane.count
		else
			TRB.Data.snapshotData.markOfTheCrane.activeCount = activeCount
		end

		TRB.Data.snapshotData.markOfTheCrane.minEndTime = minEndTime
		TRB.Data.snapshotData.markOfTheCrane.maxEndTime = maxEndTime
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

	local function UpdateMoltenRadiance(forceCleanup)
		local currentTime = GetTime()

		if forceCleanup or (TRB.Data.snapshotData.moltenRadiance.endTime ~= nil and currentTime > TRB.Data.snapshotData.moltenRadiance.endTime) then
			TRB.Data.snapshotData.moltenRadiance.endTime = nil
			TRB.Data.snapshotData.moltenRadiance.duration = 0
			TRB.Data.snapshotData.moltenRadiance.remainingTime = 0
			TRB.Data.snapshotData.moltenRadiance.mana = 0
			TRB.Data.snapshotData.moltenRadiance.manaPerTick = 0
		elseif TRB.Data.snapshotData.moltenRadiance.endTime ~= nil then
			TRB.Data.snapshotData.moltenRadiance.remainingTime = GetMoltenRadianceRemainingTime()
			TRB.Data.snapshotData.moltenRadiance.mana = TRB.Data.snapshotData.moltenRadiance.manaPerTick * TRB.Functions.Number:RoundTo(TRB.Data.snapshotData.moltenRadiance.remainingTime, 0, "ceil", true)
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Mistweaver()
		UpdateSnapshot()
		UpdateSymbolOfHope()
		UpdateChanneledManaPotion()
		UpdateInnervate()
		UpdatePotionOfChilledClarity()
		UpdateManaTideTotem()
		UpdateMoltenRadiance()

		local currentTime = GetTime()
		local _

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
	end

	local function UpdateSnapshot_Windwalker()
		UpdateSnapshot()
		UpdateMarkOfTheCrane()
		
		local currentTime = GetTime()
		local _

		if TRB.Data.snapshotData.strikeOfTheWindlord.startTime ~= nil and currentTime > (TRB.Data.snapshotData.strikeOfTheWindlord.startTime + TRB.Data.snapshotData.strikeOfTheWindlord.duration) then
			TRB.Data.snapshotData.strikeOfTheWindlord.startTime = nil
			TRB.Data.snapshotData.strikeOfTheWindlord.duration = 0
		end
		
		if TRB.Data.snapshotData.detox.startTime ~= nil and currentTime > (TRB.Data.snapshotData.detox.startTime + TRB.Data.snapshotData.detox.duration) then
			TRB.Data.snapshotData.detox.startTime = nil
			TRB.Data.snapshotData.detox.duration = 0
		end

		if TRB.Data.snapshotData.expelHarm.startTime ~= nil and currentTime > (TRB.Data.snapshotData.expelHarm.startTime + TRB.Data.snapshotData.expelHarm.duration) then
			TRB.Data.snapshotData.expelHarm.startTime = nil
			TRB.Data.snapshotData.expelHarm.duration = 0
		end

		if TRB.Data.snapshotData.paralysis.startTime ~= nil and currentTime > (TRB.Data.snapshotData.paralysis.startTime + TRB.Data.snapshotData.paralysis.duration) then
			TRB.Data.snapshotData.paralysis.startTime = nil
			TRB.Data.snapshotData.paralysis.duration = 0
		end
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.monk
		
		if specId == 2 then
			local specSettings = classSettings.mistweaver
			UpdateSnapshot_Mistweaver()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

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

						if TRB.Data.snapshotData.innervate.mana > 0 or TRB.Data.snapshotData.potionOfChilledClarity.mana > 0 then
							passiveValue = passiveValue + math.max(TRB.Data.snapshotData.innervate.mana, TRB.Data.snapshotData.potionOfChilledClarity.mana)
		
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

						if TRB.Data.snapshotData.symbolOfHope.resourceFinal > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.symbolOfHope.resourceFinal

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

						if TRB.Data.snapshotData.manaTideTotem.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.manaTideTotem.mana

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

						if TRB.Data.snapshotData.moltenRadiance.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.moltenRadiance.mana

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

					resourceBarColor = specSettings.colors.bar.base

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				end

				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		elseif specId == 3 then
			local specSettings = classSettings.windwalker
			UpdateSnapshot_Windwalker()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
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
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then	
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if (TRB.Data.snapshotData[spell.settingKey].charges == nil or TRB.Data.snapshotData[spell.settingKey].charges == 0) and
									(TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration)) then
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

							if spell.comboPoints == true and TRB.Data.snapshotData.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshotData[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base
					if TRB.Data.snapshotData.serenity.spellId and specSettings.endOfSerenity.enabled then
						local timeThreshold = 0
						if specSettings.endOfSerenity.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfSerenity.gcdsMax
						elseif specSettings.endOfSerenity.mode == "time" then
							timeThreshold = specSettings.endOfSerenity.timeMax
						end
						
						if GetSerenityRemainingTime() <= timeThreshold then
							barColor = specSettings.colors.bar.serenityEnd
						else
							barColor = specSettings.colors.bar.serenity
						end
					end

					local barBorderColor = specSettings.colors.bar.border
					if GetDanceOfChiJiRemainingTime() > 0 then
						barBorderColor = specSettings.colors.bar.borderChiJi
					elseif specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
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

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

					for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = specSettings.colors.comboPoints.border
						local cpColor = specSettings.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

						if TRB.Data.snapshotData.resource2 >= x then
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (specSettings.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = specSettings.colors.comboPoints.penultimate
							elseif (specSettings.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
								cpColor = specSettings.colors.comboPoints.final
							end
						else
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
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

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...
			
			if destGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "mistweaver" then -- Let's check raid effect mana stuff
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
					elseif spellId == TRB.Data.spells.moltenRadiance.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							local _
							_, _, _, _, TRB.Data.snapshotData.moltenRadiance.duration, TRB.Data.snapshotData.moltenRadiance.endTime, _, _, _, TRB.Data.snapshotData.moltenRadiance.spellId, _, _, _, _, _, _, _, TRB.Data.snapshotData.moltenRadiance.manaPerTick = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.moltenRadiance.id)
							TRB.Data.snapshotData.moltenRadiance.isActive = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.moltenRadiance.isActive = false
							TRB.Data.snapshotData.moltenRadiance.spellId = nil
							TRB.Data.snapshotData.moltenRadiance.duration = 0
							TRB.Data.snapshotData.moltenRadiance.endTime = nil
							TRB.Data.snapshotData.moltenRadiance.manaPerTick = 0
							TRB.Data.snapshotData.moltenRadiance.mana = 0
						end
					end
				end
			end

			if sourceGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "mistweaver" then
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
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "windwalker" then --Windwalker
					if spellId == TRB.Data.spells.strikeOfTheWindlord.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.strikeOfTheWindlord.startTime = currentTime
							TRB.Data.snapshotData.strikeOfTheWindlord.duration = TRB.Data.spells.strikeOfTheWindlord.cooldown
						end
					elseif spellId == TRB.Data.spells.serenity.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.serenity.isActive = true
							_, _, _, _, TRB.Data.snapshotData.serenity.duration, TRB.Data.snapshotData.serenity.endTime, _, _, _, TRB.Data.snapshotData.serenity.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.serenity.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.serenity.isActive = false
							TRB.Data.snapshotData.serenity.spellId = nil
							TRB.Data.snapshotData.serenity.duration = 0
							TRB.Data.snapshotData.serenity.endTime = nil
						end
					elseif spellId == TRB.Data.spells.danceOfChiJi.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.danceOfChiJi.isActive = true
							_, _, _, _, TRB.Data.snapshotData.danceOfChiJi.duration, TRB.Data.snapshotData.danceOfChiJi.endTime, _, _, _, TRB.Data.snapshotData.danceOfChiJi.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.danceOfChiJi.id)

							if TRB.Data.settings.monk.windwalker.audio.danceOfChiJi.enabled and not TRB.Data.snapshotData.audio.playedDanceOfChiJiCue then
								TRB.Data.snapshotData.audio.playedDanceOfChiJiCue = true
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.monk.windwalker.audio.danceOfChiJi.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.danceOfChiJi.isActive = false
							TRB.Data.snapshotData.danceOfChiJi.spellId = nil
							TRB.Data.snapshotData.danceOfChiJi.duration = 0
							TRB.Data.snapshotData.danceOfChiJi.endTime = nil
							TRB.Data.snapshotData.audio.playedDanceOfChiJiCue = false
						end
					elseif spellId == TRB.Data.spells.markOfTheCrane.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].markOfTheCrane = false
								TRB.Data.snapshotData.targetData.targets[destGUID].markOfTheCraneRemaining = 0
								TRB.Data.snapshotData.targetData.markOfTheCrane = TRB.Data.snapshotData.targetData.markOfTheCrane - 1
								triggerUpdate = true
							end
						end
					elseif spellId == TRB.Data.spells.tigerPalm.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							end
						end
					elseif spellId == TRB.Data.spells.blackoutKick.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							end
						end
					elseif spellId == TRB.Data.spells.risingSunKick.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							end
						end
					elseif spellId == TRB.Data.spells.detox.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.detox.startTime = currentTime
							TRB.Data.snapshotData.detox.duration = TRB.Data.spells.detox.cooldown
						end
					elseif spellId == TRB.Data.spells.expelHarm.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.expelHarm.startTime = currentTime
							TRB.Data.snapshotData.expelHarm.duration = TRB.Data.spells.expelHarm.cooldown
						end
					elseif spellId == TRB.Data.spells.paralysis.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.paralysis.startTime = currentTime
							TRB.Data.snapshotData.paralysis.duration = TRB.Data.spells.paralysis.cooldown

							if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.paralysisRank2) then
								TRB.Data.snapshotData.paralysis.duration = TRB.Data.snapshotData.paralysis.duration + TRB.Data.spells.paralysisRank2.cooldownMod
							end
						end
					end
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				TRB.Functions.Target:RemoveTarget(destGUID)
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
		elseif specId == 2 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.monk.mistweaver)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.mistweaver)
			specCache.mistweaver.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Mistweaver()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.mistweaver)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Mistweaver

			if TRB.Data.barConstructedForSpec ~= "mistweaver" then
				TRB.Data.barConstructedForSpec = "mistweaver"
				ConstructResourceBar(specCache.mistweaver.settings)
			end
		elseif specId == 3 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.monk.windwalker)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.windwalker)
			specCache.windwalker.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Windwalker()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.windwalker)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Windwalker

			if TRB.Data.barConstructedForSpec ~= "windwalker" then
				TRB.Data.barConstructedForSpec = "windwalker"
				ConstructResourceBar(specCache.windwalker.settings)
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
		if classIndexId == 10 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Monk.LoadDefaultSettings()
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
							TRB.Data.barConstructedForSpec = nil
							TRB.Data.settings.monk.windwalker = TRB.Functions.LibSharedMedia:ValidateLsmValues("Windwalker Monk", TRB.Data.settings.monk.windwalker)
							TRB.Data.settings.monk.mistweaver = TRB.Functions.LibSharedMedia:ValidateLsmValues("Mistweaver Monk", TRB.Data.settings.monk.mistweaver)
							FillSpellData_Windwalker()
							FillSpellData_Mistweaver()

							SwitchSpec()
							TRB.Options.Monk.ConstructOptionsPanel(specCache)
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
		TRB.Data.character.className = "monk"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
		local maxComboPoints = 0
		local settings = nil
		
		if specId == 2 then
			TRB.Data.character.specName = "mistweaver"
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
---@diagnostic disable-next-line: missing-parameter, missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
---@diagnostic disable-next-line: missing-parameter, missing-parameter
			maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
			settings = TRB.Data.settings.monk.windwalker
			TRB.Data.character.specName = "windwalker"
		end
		
		if settings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
			end
		end
	end
	
	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 2 and TRB.Data.settings.core.enabled.monk.mistweaver then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.mistweaver)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
		elseif specId == 3 and TRB.Data.settings.core.enabled.monk.windwalker then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.windwalker)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.Chi
			TRB.Data.resource2Factor = 1
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
			TRB.Functions.Class:CheckCharacter()

			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		end
		TRB.Functions.Bar:HideResourceBar()
	end

	function TRB.Functions.Class:HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.monk.mistweaver.displayBar.alwaysShow) and (
						(not TRB.Data.settings.monk.mistweaver.displayBar.notZeroShow) or
						(TRB.Data.settings.monk.mistweaver.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.monk.mistweaver.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 3 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.monk.windwalker.displayBar.alwaysShow) and (
						(not TRB.Data.settings.monk.windwalker.displayBar.notZeroShow) or
						(TRB.Data.settings.monk.windwalker.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.monk.windwalker.displayBar.neverShow == true then
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
				elseif specId == 3 then
					TRB.Data.snapshotData.targetData.targets[guid].markOfTheCrane = false
					TRB.Data.snapshotData.targetData.targets[guid].markOfTheCraneRemaining = 0
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
		local settings = nil
		if specId == 2 then
			settings = TRB.Data.settings.monk.mistweaver
		elseif specId == 3 then
			settings = TRB.Data.settings.monk.windwalker
		end

		if specId == 2 then --Mistweaver
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
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
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
			elseif var == "$mttMana" then
				if TRB.Data.snapshotData.manaTideTotem.mana > 0 then
					valid = true
				end
			elseif var == "$mttTime" then
				if TRB.Data.snapshotData.manaTideTotem.isActive then
					valid = true
				end
			elseif var == "$mrMana" then
				if TRB.Data.snapshotData.moltenRadiance.mana > 0 then
					valid = true
				end
			elseif var == "$mrTime" then
				if TRB.Data.snapshotData.moltenRadiance.isActive then
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
		elseif specId == 3 then --Windwalker
			if var == "$casting" then
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
					settings.generation.enabled and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$serenityTime" then
				if GetSerenityRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$danceOfChiJiTime" then
				if GetDanceOfChiJiRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$motcCount" then
				if TRB.Data.snapshotData.markOfTheCrane.count > 0 then
					valid = true
				end
			elseif var == "$motcActiveCount" then
				if TRB.Data.snapshotData.markOfTheCrane.activeCount > 0 then
					valid = true
				end
			elseif var == "$motcMinTime" then
				if TRB.Data.snapshotData.markOfTheCrane.minEndTime ~= nil then
					valid = true
				end
			elseif var == "$motcMaxTime" then
				if TRB.Data.snapshotData.markOfTheCrane.maxEndTime ~= nil then
					valid = true
				end
			elseif var == "$motcTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].markOfTheCraneRemaining > 0 then
					valid = true
				end
			elseif var == "$resource" or var == "$energy" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$energyMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$energyTotal" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$energyOvercap" or var == "$resourceOvercap" then
				local threshold = ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal)
				if TRB.Data.settings.priest.shadow.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif TRB.Data.settings.priest.shadow.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
				if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$comboPoints" or var == "$chi" then
				valid = true
			elseif var == "$comboPointsMax"or var == "$chiMax" then
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