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
		mistweaver = {
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
			vivaciousVivification = {
				id = 392883,
				name = "", 
				icon = ""
			},

			-- Mistweaver Spec Talents
			manaTea = {
				id = 197908,
				name = "",
				icon = "",
				isTalent = true
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
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8,
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
			},

			-- Tier Bonuses
			soulfangInfusion = { -- T30 2P
				id = 410007,
				name = "",
				icon = "",
				ticks = 3,
				manaPerTick = 0.01,
				duration = 3
			}

		}

		specCache.mistweaver.snapshot.manaRegen = 0
		specCache.mistweaver.snapshot.audio = {
			innervateCue = false
		}
		specCache.mistweaver.snapshot.innervate = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.mistweaver.snapshot.manaTea = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.mistweaver.snapshot.manaTideTotem = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.mistweaver.snapshot.symbolOfHope = {
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
		specCache.mistweaver.snapshot.channeledManaPotion = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.mistweaver.snapshot.potion = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.mistweaver.snapshot.potionOfChilledClarity = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.mistweaver.snapshot.conjuredChillglobe = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.mistweaver.snapshot.moltenRadiance = {
			spellId = nil,
			startTime = nil,
			duration = 0,
			manaPerTick = 0,
			mana = 0
		}
		specCache.mistweaver.snapshot.soulfangInfusion = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.mistweaver.snapshot.vivaciousVivification = {
			isActive = false
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

		specCache.windwalker.snapshot.energyRegen = 0
		specCache.windwalker.snapshot.audio = {
			overcapCue = false,
			playedDanceOfChiJiCue = false
		}
		specCache.windwalker.snapshot.detox = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshot.expelHarm = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshot.paralysis = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshot.strikeOfTheWindlord = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshot.serenity = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.windwalker.snapshot.danceOfChiJi = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.windwalker.snapshot.markOfTheCrane = {
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
	end

	local function Setup_Windwalker()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "monk", "windwalker")
	end

	local function FillSpellData_Mistweaver()
		Setup_Mistweaver()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.mistweaver.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.mistweaver.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },
			
			{ variable = "#manaTea", icon = spells.manaTea.icon, description = spells.manaTea.name, printInSettings = true },

			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

			{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
			{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },

			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

			{ variable = "#si", icon = spells.soulfangInfusion.icon, description = spells.soulfangInfusion.name, printInSettings = true },
			{ variable = "#soulfangInfusion", icon = spells.soulfangInfusion.icon, description = spells.soulfangInfusion.name, printInSettings = false },

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

			{ variable = "$mtTime", description = "Time left on Mana Tea", printInSettings = true, color = false },
			{ variable = "$manaTeaTime", description = "Time left on Mana Tea", printInSettings = false, color = false },

			{ variable = "$siMana", description = "Mana from Soulfang Infusion", printInSettings = true, color = false },
			{ variable = "$siTime", description = "Time left on Soulfang Infusion", printInSettings = true, color = false },
			{ variable = "$siTicks", description = "Number of ticks left from Soulfang Infusion", printInSettings = true, color = false },

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
		local snapshot = TRB.Data.snapshot

		---@type TRB.Classes.TargetData
		local targetData = snapshot.targetData
		
		if specId == 2 then -- Mistweaver
		elseif specId == 3 then -- Windwalker
			targetData:UpdateDebuffs(currentTime)
		end
	end

	local function TargetsCleanup(clearAll)
		local snapshot = TRB.Data.snapshot
		---@type TRB.Classes.TargetData
		local targetData = snapshot.targetData
		targetData:Cleanup(clearAll)
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

		if specId == 2 then
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
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe.settingKey, TRB.Data.settings.monk.mistweaver)
			TRB.Frames.resource2ContainerFrame:Hide()
		elseif specId == 3 then
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
		end

		TRB.Functions.Bar:Construct(settings)

		if specId == 2  or specId == 3 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function GetSerenityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.serenity)
	end

	local function GetDanceOfChiJiRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.danceOfChiJi)
	end
	
	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.channeledManaPotion)
	end

	local function GetInnervateRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.innervate)
	end

	local function GetManaTideTotemRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.manaTideTotem)
	end

	local function GetManaTeaRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.manaTea)
	end

	local function GetMoltenRadianceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.moltenRadiance)
	end

	local function GetSymbolOfHopeRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.symbolOfHope)
	end

	local function GetPotionOfChilledClarityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.potionOfChilledClarity)
	end

	local function GetSoulfangInfusionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.soulfangInfusion)
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
		local snapshot = TRB.Data.snapshot
		local entries = TRB.Functions.Table:Length(snapshot.markOfTheCrane.list)
		for x = 1, entries do
			if snapshot.markOfTheCrane.list[x].guid == guid then
				return x
			end
		end
		return 0
	end

	local function ApplyMarkOfTheCrane(guid)
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local currentTime = GetTime()
		snapshot.targetData.targets[guid].spells[spells.markOfTheCrane.id].active = true
		snapshot.targetData.targets[guid].spells[spells.markOfTheCrane.id].remainingTime = spells.markOfTheCrane.duration
		local listPosition = GetGuidPositionInMarkOfTheCraneList(guid)
		if listPosition > 0 then
			snapshot.markOfTheCrane.list[listPosition].startTime = currentTime
			snapshot.markOfTheCrane.list[listPosition].endTime = currentTime + spells.markOfTheCrane.duration
			print("refresh", guid, snapshot.markOfTheCrane.list[listPosition].endTime)
		else
			snapshot.targetData.count[spells.markOfTheCrane.id] = snapshot.targetData.count[spells.markOfTheCrane.id] + 1
			table.insert(snapshot.markOfTheCrane.list, {
				guid = guid,
				endTime = currentTime + spells.markOfTheCrane.duration
			})
			print("new", guid, currentTime + spells.markOfTheCrane.duration)
		end
	end

	local function GetOldestOrExpiredMarkOfTheCraneListEntry(any, aliveOnly)
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local currentTime = GetTime()
		local entries = TRB.Functions.Table:Length(snapshot.markOfTheCrane.list)
		local oldestTime = currentTime
		local oldestId = 0

		if any then
			oldestTime = oldestTime + spells.markOfTheCrane.duration
		end

		--print("----------------")

		for x = 1, entries do
			local listItem = snapshot.markOfTheCrane.list[x]
			local target = snapshot.targetData.targets[listItem.guid]

			if target ~= nil and target.spells[spells.markOfTheCrane.id].active and listItem.endTime > currentTime then
				snapshot.targetData.targets[listItem.guid].spells[spells.markOfTheCrane.id].remainingTime = listItem.endTime - currentTime
			end

			if listItem.endTime < oldestTime and (not aliveOnly or target ~= nil) then
				oldestId = x
				oldestTime = listItem.endTime
			end
			--print(listItem.guid, listItem.guid == snapshot.targetData.currentTargetGuid, listItem.endTime)
		end
		return oldestId
	end

	local function RemoveExcessMarkOfTheCraneEntries()
		local spells = TRB.Data.spells
		while true do
			local id = GetOldestOrExpiredMarkOfTheCraneListEntry(false)
			local snapshot = TRB.Data.snapshot

			if id == 0 then
				return
			else
				if snapshot.targetData.targets[snapshot.markOfTheCrane.list[id].guid] ~= nil then
					snapshot.targetData.targets[snapshot.markOfTheCrane.list[id].guid].spells[spells.markOfTheCrane.id].active = false
					snapshot.targetData.targets[snapshot.markOfTheCrane.list[id].guid].spells[spells.markOfTheCrane.id].remainingTime = 0
				end
				table.remove(snapshot.markOfTheCrane.list, id)
			end
		end
	end
	
	local function IsTargetLowestInMarkOfTheCraneList()
		local snapshot = TRB.Data.snapshot
		if snapshot.targetData.currentTargetGuid == nil then
			return false
		end

		local oldest = GetOldestOrExpiredMarkOfTheCraneListEntry(true, true)
		if oldest > 0 and snapshot.markOfTheCrane.list[oldest].guid == snapshot.targetData.currentTargetGuid then
			return true
		end

		return false
	end

	local function RefreshLookupData_Mistweaver()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local specSettings = TRB.Data.settings.monk.mistweaver
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

		--$mttMana
		local _mttMana = snapshot.manaTideTotem.mana
		local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
		--$mttTime
		local _mttTime = GetManaTideTotemRemainingTime()
		local mttTime = string.format("%.1f", _mttTime)
		
		--$mtTime
		local _mtTime = GetManaTeaRemainingTime()
		local mtTime = string.format("%.1f", _mtTime)

		--$mrMana
		local _mrMana = snapshot.moltenRadiance.mana
		local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
		--$mrTime
		local _mrTime = GetMoltenRadianceRemainingTime()
		local mrTime = string.format("%.1f", _mrTime)

		--$siMana
		local _siMana = snapshot.soulfangInfusion.mana
		local siMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_siMana, manaPrecision, "floor", true))
		--$siTicks
		local _siTicks = snapshot.soulfangInfusion.ticksRemaining or 0
		local siTicks = string.format("%.0f", _siTicks)
		--$siTime
		local _siTime = GetSoulfangInfusionRemainingTime()
		local siTime = string.format("%.1f", _siTime)

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

		--$potionOfChilledClarityMana
		local _potionOfChilledClarityMana = snapshot.potionOfChilledClarity.mana
		local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
		--$potionOfChilledClarityTime
		local _potionOfChilledClarityTime = GetPotionOfChilledClarityRemainingTime()
		local potionOfChilledClarityTime = string.format("%.1f", _potionOfChilledClarityTime)

		--$channeledMana
		local _channeledMana = CalculateManaGain(snapshot.channeledManaPotion.mana, true)
		local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
		--$potionOfFrozenFocusTicks
		local _potionOfFrozenFocusTicks = snapshot.channeledManaPotion.ticksRemaining or 0
		local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
		--$potionOfFrozenFocusTime
		local _potionOfFrozenFocusTime = GetChanneledPotionRemainingTime()
		local potionOfFrozenFocusTime = string.format("%.1f", _potionOfFrozenFocusTime)
		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana + _siMana
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

		----------

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
		Global_TwintopResourceBar.resource.soulfangInfusion = _siMana or 0
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _channeledMana,
			ticks = snapshot.channeledManaPotion.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = snapshot.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.soulfangInfusion = {
			mana = _siMana,
			ticks = snapshot.soulfangInfusion.ticksRemaining or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#manaTea"] = spells.manaTea.icon
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
		lookup["#si"] = spells.soulfangInfusion.icon
		lookup["#soulfangInfusion"] = spells.soulfangInfusion.icon
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
		lookup["$mtTime"] = mtTime
		lookup["$manaTeaTime"] = mtTime
		lookup["$siMana"] = siMana
		lookup["$siTicks"] = siTicks
		lookup["$siTime"] = siTime
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
		lookupLogic["$mtTime"] = _mtTime
		lookupLogic["$manaTeaTime"] = _mtTime
		lookupLogic["$siMana"] = _siMana
		lookupLogic["$siTicks"] = _siTicks
		lookupLogic["$siTime"] = _siTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Windwalker()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local specSettings = TRB.Data.settings.monk.windwalker
		---@type TRB.Classes.Target
		local target = snapshot.targetData.targets[snapshot.targetData.currentTargetGuid]
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		snapshot.energyRegen, _ = GetPowerRegen()

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
					if	spell ~= nil and spell.thresholdUsable == true then
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

		if snapshot.casting.resourceFinal < 0 then
			castingEnergyColor = specSettings.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, snapshot.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, snapshot.casting.resourceFinal)
		--$passive
		local _regenEnergy = 0
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

		if specSettings.generation.enabled then
			if specSettings.generation.mode == "time" then
				_regenEnergy = snapshot.energyRegen * (specSettings.generation.time or 3.0)
			else
				_regenEnergy = snapshot.energyRegen * ((specSettings.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy --+ _markOfTheCraneEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + snapshot.casting.resourceFinal + snapshot.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(snapshot.casting.resourceFinal + snapshot.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + snapshot.resource, TRB.Data.character.maxResource)
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
		local _motcMinTime = (snapshot.markOfTheCrane.minEndTime or 0) - currentTime
		local motcMinTime = "0.0"
		if _motcMinTime > 0 then
			motcMinTime = string.format("%.1f", _motcMinTime)
		end
		
		--$motcMaxTime
		local _motcMaxTime = (snapshot.markOfTheCrane.maxEndTime or 0) - currentTime
		local motcMaxTime = "0.0"
		if _motcMaxTime > 0 then
			motcMaxTime = string.format("%.1f", _motcMaxTime)
		end

		
		local targetMotcId = GetGuidPositionInMarkOfTheCraneList(snapshot.targetData.currentTargetGuid)
		--$motcTime
		local _motcTime = 0

		if targetMotcId > 0 and target ~= nil then
			_motcTime = snapshot.markOfTheCrane.list[targetMotcId].endTime - currentTime
		end

		local _motcCount = snapshot.markOfTheCrane.count or 0
		local motcCount = tostring(_motcCount)
		local _motcActiveCount = snapshot.markOfTheCrane.activeCount or 0
		local motcActiveCount = tostring(_motcActiveCount)

		local motcTime

		if specSettings.colors.text.dots.enabled and snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if targetMotcId > 0 and target ~= nil and target.spells[spells.markOfTheCrane.id].active then
				if not IsTargetLowestInMarkOfTheCraneList() then
					motcCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, snapshot.markOfTheCrane.count)
					motcActiveCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, snapshot.markOfTheCrane.activeCount)
					motcTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.up, _motcTime)
				else
					motcCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, snapshot.markOfTheCrane.count)
					motcActiveCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, snapshot.markOfTheCrane.activeCount)
					motcTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.pandemic, _motcTime)
				end
			else
				motcCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, snapshot.markOfTheCrane.count)
				motcActiveCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, snapshot.markOfTheCrane.activeCount)
				motcTime = string.format("|c%s%.1f|r", specSettings.colors.text.dots.down, 0)
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
		lookup["#blackoutKick"] = spells.blackoutKick.icon
		lookup["#cracklingJadeLightning"] = spells.cracklingJadeLightning.icon
		lookup["#cjl"] = spells.cracklingJadeLightning.icon
		lookup["#danceOfChiJi"] = spells.danceOfChiJi.icon
		lookup["#detox"] = spells.detox.icon
		lookup["#disable"] = spells.disable.icon
		lookup["#energizingElixir"] = spells.energizingElixir.icon
		lookup["#expelHarm"] = spells.expelHarm.icon
		lookup["#fistsOfFury"] = spells.fistsOfFury.icon
		lookup["#fof"] = spells.fistsOfFury.icon
		lookup["#strikeOfTheWindlord"] = spells.strikeOfTheWindlord.icon
		lookup["#paralysis"] = spells.paralysis.icon
		lookup["#risingSunKick"] = spells.risingSunKick.icon
		lookup["#rsk"] = spells.risingSunKick.icon
		lookup["#serenity"] = spells.serenity.icon
		lookup["#spinningCraneKick"] = spells.spinningCraneKick.icon
		lookup["#sck"] = spells.spinningCraneKick.icon
		lookup["#tigerPalm"] = spells.tigerPalm.icon
		lookup["#touchOfDeath"] = spells.touchOfDeath.icon
		lookup["#vivify"] = spells.vivify.icon

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

		if TRB.Data.character.maxResource == snapshot.resource then
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
		lookupLogic["$energy"] = snapshot.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshot.resource
		lookupLogic["$casting"] = snapshot.casting.resourceFinal
		lookupLogic["$chi"] = TRB.Data.character.resource2
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$chiMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		if TRB.Data.character.maxResource == snapshot.resource then
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
		local snapshot = TRB.Data.snapshot
		snapshot.casting.startTime = currentTime
		snapshot.casting.resourceRaw = spell.energy
		snapshot.casting.resourceFinal = CalculateAbilityResourceValue(spell.energy)
		snapshot.casting.spellId = spell.id
		snapshot.casting.icon = spell.icon
	end

	local function UpdateCastingResourceFinal()
		local snapshot = TRB.Data.snapshot
		snapshot.casting.resourceFinal = CalculateAbilityResourceValue(snapshot.casting.resourceRaw)
	end

	local function UpdateCastingResourceFinal_Mistweaver()
		-- Do nothing for now
		local snapshot = TRB.Data.snapshot
		snapshot.casting.resourceFinal = snapshot.casting.resourceRaw * snapshot.innervate.modifier * snapshot.potionOfChilledClarity.modifier
	end

	local function CastingSpell()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
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
					if currentChannelId == spells.soothingMist.id then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCostPerSecond(currentChannelId)

						snapshot.casting.spellId = spells.soothingMist.id
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = manaCost
						snapshot.casting.icon = spells.soothingMist.icon

						UpdateCastingResourceFinal_Mistweaver()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
					end
					return false
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

						snapshot.casting.startTime = currentSpellStartTime / 1000
						snapshot.casting.endTime = currentSpellEndTime / 1000
						snapshot.casting.resourceRaw = manaCost
						snapshot.casting.spellId = spellId
						snapshot.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Mistweaver()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 3 then
				if currentSpellName == nil then
					if currentChannelId == spells.cracklingJadeLightning.id then
						snapshot.casting.cracklingJadeLightning = spells.cracklingJadeLightning.id
						snapshot.casting.startTime = currentTime
						snapshot.casting.resourceRaw = spells.cracklingJadeLightning.energy
						snapshot.casting.icon = spells.cracklingJadeLightning.icon
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
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local entries = TRB.Functions.Table:Length(snapshot.markOfTheCrane.list)
		local minEndTime = nil
		local maxEndTime = nil
		local activeCount = 0
		local currentTime = GetTime()
		if entries > 0 then
			for x = 1, entries do
				activeCount = activeCount + 1
				snapshot.markOfTheCrane.isActive = true

				if snapshot.markOfTheCrane.list[x].endTime > (maxEndTime or 0) then
					maxEndTime = snapshot.markOfTheCrane.list[x].endTime
				end
				
				if snapshot.markOfTheCrane.list[x].endTime < (minEndTime or currentTime+999) then
					minEndTime = snapshot.markOfTheCrane.list[x].endTime
				end
			end
		end

		if activeCount > 0 then
			snapshot.markOfTheCrane.isActive = true
		else
			snapshot.markOfTheCrane.isActive = false
		end
---@diagnostic disable-next-line: redundant-parameter
		snapshot.markOfTheCrane.count = GetSpellCount(spells.spinningCraneKick.id)

		-- Avoid race conditions from combat log events saying we have 6 marks when 5 is the max
		if snapshot.markOfTheCrane.count < activeCount then
			snapshot.markOfTheCrane.activeCount = snapshot.markOfTheCrane.count
		else
			snapshot.markOfTheCrane.activeCount = activeCount
		end

		snapshot.markOfTheCrane.minEndTime = minEndTime
		snapshot.markOfTheCrane.maxEndTime = maxEndTime
	end

	local function UpdateChanneledManaPotion(forceCleanup)
		local snapshot = TRB.Data.snapshot
		if snapshot.channeledManaPotion.isActive or forceCleanup then
			local spells = TRB.Data.spells
			local currentTime = GetTime()
			if forceCleanup or snapshot.channeledManaPotion.endTime == nil or currentTime > snapshot.channeledManaPotion.endTime then
				snapshot.channeledManaPotion.ticksRemaining = 0
				snapshot.channeledManaPotion.endTime = nil
				snapshot.channeledManaPotion.mana = 0
				snapshot.channeledManaPotion.isActive = false
				snapshot.channeledManaPotion.spellKey = nil
			else
				snapshot.channeledManaPotion.ticksRemaining = math.ceil((snapshot.channeledManaPotion.endTime - currentTime) / (spells[snapshot.channeledManaPotion.spellKey].duration / spells[snapshot.channeledManaPotion.spellKey].ticks))
				local nextTickRemaining = snapshot.channeledManaPotion.endTime - currentTime - math.floor((snapshot.channeledManaPotion.endTime - currentTime) / (spells[snapshot.channeledManaPotion.spellKey].duration / spells[snapshot.channeledManaPotion.spellKey].ticks))
				snapshot.channeledManaPotion.mana = snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(spells[snapshot.channeledManaPotion.spellKey].mana, true) + ((snapshot.channeledManaPotion.ticksRemaining - 1 + nextTickRemaining) * snapshot.manaRegen)
			end
		end
	end

	local function UpdateSoulfangInfusion(forceCleanup)
		local snapshot = TRB.Data.snapshot
		if snapshot.soulfangInfusion.isActive or forceCleanup then
			local currentTime = GetTime()
			local spells = TRB.Data.spells
			if forceCleanup or snapshot.soulfangInfusion.endTime == nil or currentTime > snapshot.soulfangInfusion.endTime then
				snapshot.soulfangInfusion.ticksRemaining = 0
				snapshot.soulfangInfusion.endTime = nil
				snapshot.soulfangInfusion.mana = 0
				snapshot.soulfangInfusion.isActive = false
			else
				snapshot.soulfangInfusion.ticksRemaining = math.ceil((snapshot.soulfangInfusion.endTime - currentTime) / (spells.soulfangInfusion.duration / spells.soulfangInfusion.ticks))
				snapshot.soulfangInfusion.mana = snapshot.soulfangInfusion.ticksRemaining * CalculateManaGain(TRB.Data.character.maxResource * spells.soulfangInfusion.manaPerTick, false)
			end
		end
	end
	
	local function UpdateSymbolOfHope(forceCleanup)
		local snapshot = TRB.Data.snapshot
		if snapshot.symbolOfHope.isActive or forceCleanup then
			local spells = TRB.Data.spells
			local currentTime = GetTime()
			if forceCleanup or snapshot.symbolOfHope.endTime == nil or currentTime > snapshot.symbolOfHope.endTime or currentTime > snapshot.symbolOfHope.firstTickTime + spells.symbolOfHope.duration or currentTime > snapshot.symbolOfHope.firstTickTime + (spells.symbolOfHope.ticks * snapshot.symbolOfHope.tickRate) then
				snapshot.symbolOfHope.ticksRemaining = 0
				snapshot.symbolOfHope.tickRate = 0
				snapshot.symbolOfHope.previousTickTime = nil
				snapshot.symbolOfHope.firstTickTime = nil
				snapshot.symbolOfHope.endTime = nil
				snapshot.symbolOfHope.resourceRaw = 0
				snapshot.symbolOfHope.resourceFinal = 0
				snapshot.symbolOfHope.isActive = false
				snapshot.symbolOfHope.tickRateFound = false
			else
				snapshot.symbolOfHope.ticksRemaining = math.ceil((snapshot.symbolOfHope.endTime - currentTime) / snapshot.symbolOfHope.tickRate)
				local nextTickRemaining = snapshot.symbolOfHope.endTime - currentTime - math.floor((snapshot.symbolOfHope.endTime - currentTime) / snapshot.symbolOfHope.tickRate)
				snapshot.symbolOfHope.resourceRaw = 0

				for x = 1, snapshot.symbolOfHope.ticksRemaining do
					local casterRegen = 0
					if snapshot.casting.spellId == spells.symbolOfHope.id then
						if x == 1 then
							casterRegen = nextTickRemaining * snapshot.manaRegen
						else
							casterRegen = snapshot.manaRegen
						end
					end

					local estimatedMana = TRB.Data.character.maxResource + snapshot.symbolOfHope.resourceRaw + casterRegen - (snapshot.resource / TRB.Data.resourceFactor)
					local nextTick = spells.symbolOfHope.manaPercent * math.max(0, math.min(TRB.Data.character.maxResource, estimatedMana))
					snapshot.symbolOfHope.resourceRaw = snapshot.symbolOfHope.resourceRaw + nextTick + casterRegen
				end

				--Revisit if we get mana modifiers added
				snapshot.symbolOfHope.resourceFinal = CalculateManaGain(snapshot.symbolOfHope.resourceRaw, false)
			end
		end
	end

	local function UpdateInnervate()
		local currentTime = GetTime()
		local snapshot = TRB.Data.snapshot

		if snapshot.innervate.endTime ~= nil and currentTime > snapshot.innervate.endTime then
			snapshot.innervate.endTime = nil
			snapshot.innervate.duration = 0
			snapshot.innervate.remainingTime = 0
			snapshot.innervate.mana = 0
			snapshot.audio.innervateCue = false
		else
			snapshot.innervate.remainingTime = GetInnervateRemainingTime()
			snapshot.innervate.mana = snapshot.innervate.remainingTime * snapshot.manaRegen
		end
	end
	
	local function UpdatePotionOfChilledClarity()
		local currentTime = GetTime()
		local snapshot = TRB.Data.snapshot

		if snapshot.potionOfChilledClarity.endTime ~= nil and currentTime > snapshot.potionOfChilledClarity.endTime then
			snapshot.potionOfChilledClarity.endTime = nil
			snapshot.potionOfChilledClarity.duration = 0
			snapshot.potionOfChilledClarity.remainingTime = 0
			snapshot.potionOfChilledClarity.mana = 0
			snapshot.audio.potionOfChilledClarityCue = false
		else
			snapshot.potionOfChilledClarity.remainingTime = GetPotionOfChilledClarityRemainingTime()
			snapshot.potionOfChilledClarity.mana = snapshot.potionOfChilledClarity.remainingTime * snapshot.manaRegen
		end
	end

	local function UpdateManaTideTotem(forceCleanup)
		local currentTime = GetTime()
		local snapshot = TRB.Data.snapshot

		if forceCleanup or (snapshot.manaTideTotem.endTime ~= nil and currentTime > snapshot.manaTideTotem.endTime) then
			snapshot.manaTideTotem.endTime = nil
			snapshot.manaTideTotem.duration = 0
			snapshot.manaTideTotem.remainingTime = 0
			snapshot.manaTideTotem.mana = 0
			snapshot.audio.manaTideTotemCue = false
		else
			snapshot.manaTideTotem.remainingTime = GetManaTideTotemRemainingTime()
			snapshot.manaTideTotem.mana = snapshot.manaTideTotem.remainingTime * (snapshot.manaRegen / 2) --Only half of this is considered bonus
		end
	end

	local function UpdateMoltenRadiance(forceCleanup)
		local currentTime = GetTime()
		local snapshot = TRB.Data.snapshot

		if forceCleanup or (snapshot.moltenRadiance.endTime ~= nil and currentTime > snapshot.moltenRadiance.endTime) then
			snapshot.moltenRadiance.endTime = nil
			snapshot.moltenRadiance.duration = 0
			snapshot.moltenRadiance.remainingTime = 0
			snapshot.moltenRadiance.mana = 0
			snapshot.moltenRadiance.manaPerTick = 0
		elseif snapshot.moltenRadiance.endTime ~= nil then
			snapshot.moltenRadiance.remainingTime = GetMoltenRadianceRemainingTime()
			snapshot.moltenRadiance.mana = snapshot.moltenRadiance.manaPerTick * TRB.Functions.Number:RoundTo(snapshot.moltenRadiance.remainingTime, 0, "ceil", true)
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
		UpdateSoulfangInfusion()
		UpdateInnervate()
		UpdatePotionOfChilledClarity()
		UpdateManaTideTotem()
		UpdateMoltenRadiance()

		local currentTime = GetTime()
		local _
		local snapshot = TRB.Data.snapshot

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

	local function UpdateSnapshot_Windwalker()
		UpdateSnapshot()
		UpdateMarkOfTheCrane()
		
		local snapshot = TRB.Data.snapshot
		local currentTime = GetTime()
		local _

		if snapshot.strikeOfTheWindlord.startTime ~= nil and currentTime > (snapshot.strikeOfTheWindlord.startTime + snapshot.strikeOfTheWindlord.duration) then
			snapshot.strikeOfTheWindlord.startTime = nil
			snapshot.strikeOfTheWindlord.duration = 0
		end
		
		if snapshot.detox.startTime ~= nil and currentTime > (snapshot.detox.startTime + snapshot.detox.duration) then
			snapshot.detox.startTime = nil
			snapshot.detox.duration = 0
		end

		if snapshot.expelHarm.startTime ~= nil and currentTime > (snapshot.expelHarm.startTime + snapshot.expelHarm.duration) then
			snapshot.expelHarm.startTime = nil
			snapshot.expelHarm.duration = 0
		end

		if snapshot.paralysis.startTime ~= nil and currentTime > (snapshot.paralysis.startTime + snapshot.paralysis.duration) then
			snapshot.paralysis.startTime = nil
			snapshot.paralysis.duration = 0
		end
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.monk
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		
		if specId == 2 then
			local specSettings = classSettings.mistweaver
			UpdateSnapshot_Mistweaver()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = snapshot.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					if snapshot.potionOfChilledClarity.isActive and specSettings.colors.bar.potionOfChilledClarityBorderChange then
						barBorderColor = specSettings.colors.bar.potionOfChilledClarity
					elseif snapshot.innervate.isActive and (specSettings.colors.bar.innervateBorderChange or specSettings.audio.innervate.enabled)  then
						if specSettings.colors.bar.innervateBorderChange then
							barBorderColor = specSettings.colors.bar.innervate
						end

						if specSettings.audio.innervate.enabled and snapshot.audio.innervateCue == false then
							snapshot.audio.innervateCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
						end
					elseif snapshot.manaTea.isActive then
						barBorderColor = specSettings.colors.bar.manaTea.color
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

						if snapshot.soulfangInfusion.isActive then
							passiveValue = passiveValue + snapshot.soulfangInfusion.mana

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

					local affectingCombat = UnitAffectingCombat("player")
					local resourceBarColor = nil

					resourceBarColor = specSettings.colors.bar.base

					if specSettings.colors.bar.vivaciousVivification.enabled and affectingCombat and snapshot.vivaciousVivification.isActive then
						resourceBarColor = specSettings.colors.bar.vivaciousVivification.color
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				end

				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		elseif specId == 3 then
			local specSettings = classSettings.windwalker
			UpdateSnapshot_Windwalker()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshot.isTracking then
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
								passiveValue = (snapshot.energyRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (snapshot.energyRegen * ((specSettings.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = snapshot.resource + snapshot.casting.resourceFinal
					else
						castingBarValue = snapshot.resource
					end

					if castingBarValue < snapshot.resource then --Using a spender
						if -snapshot.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, snapshot.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
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
								if (snapshot[spell.settingKey].charges == nil or snapshot[spell.settingKey].charges == 0) and
									(snapshot[spell.settingKey].startTime ~= nil and currentTime < (snapshot[spell.settingKey].startTime + snapshot[spell.settingKey].duration)) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif snapshot.resource >= -energyAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if snapshot.resource >= -energyAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							if spell.comboPoints == true and snapshot.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base
					if snapshot.serenity.spellId and specSettings.endOfSerenity.enabled then
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

						if specSettings.audio.overcap.enabled and snapshot.audio.overcapCue == false then
							snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshot.audio.overcapCue = false
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

						if snapshot.resource2 >= x then
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (specSettings.comboPoints.sameColor and snapshot.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = specSettings.colors.comboPoints.penultimate
							elseif (specSettings.comboPoints.sameColor and snapshot.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
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
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshot.targetData

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...
			
			if targetData.targets[destGUID] ~= nil then
				targetData.targets[destGUID].lastUpdate = currentTime
			end

			if destGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "mistweaver" then -- Let's check raid effect mana stuff
					if type == "SPELL_ENERGIZE" and spellId == spells.symbolOfHope.tickId then
						snapshot.symbolOfHope.isActive = true
						if snapshot.symbolOfHope.firstTickTime == nil then
							snapshot.symbolOfHope.firstTickTime = currentTime
							snapshot.symbolOfHope.previousTickTime = currentTime
							snapshot.symbolOfHope.ticksRemaining = spells.symbolOfHope.ticks
							snapshot.symbolOfHope.tickRate = (spells.symbolOfHope.duration / spells.symbolOfHope.ticks)
							snapshot.symbolOfHope.endTime = currentTime + spells.symbolOfHope.duration
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
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							snapshot.innervate.modifier = 0
							snapshot.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then
							snapshot.innervate.modifier = 1
							snapshot.audio.innervateCue = false
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
							snapshot.moltenRadiance.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshot.moltenRadiance.isActive = false
							snapshot.moltenRadiance.spellId = nil
							snapshot.moltenRadiance.duration = 0
							snapshot.moltenRadiance.endTime = nil
							snapshot.moltenRadiance.manaPerTick = 0
							snapshot.moltenRadiance.mana = 0
						end
					elseif spellId == spells.vivaciousVivification.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.vivaciousVivification, true)
					end
				end
			end

			if sourceGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "mistweaver" then
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
					elseif spellId == spells.soulfangInfusion.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Soulfang Infusion
							snapshot.soulfangInfusion.isActive = true
							snapshot.soulfangInfusion.ticksRemaining = spells.soulfangInfusion.ticks
							snapshot.soulfangInfusion.mana = snapshot.soulfangInfusion.ticksRemaining * CalculateManaGain(TRB.Data.character.maxResource * spells.soulfangInfusion.manaPerTick, false)
							snapshot.soulfangInfusion.endTime = currentTime + spells.soulfangInfusion.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateSoulfangInfusion() clean this up
							UpdateSoulfangInfusion(true)
						end
					elseif spellId == spells.potionOfChilledClarity.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.potionOfChilledClarity)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							snapshot.potionOfChilledClarity.modifier = 0
						elseif type == "SPELL_AURA_REMOVED" then
							snapshot.potionOfChilledClarity.modifier = 1
						end
					elseif spellId == spells.manaTea.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.manaTea)
					end
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "windwalker" then --Windwalker
					if spellId == spells.strikeOfTheWindlord.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshot.strikeOfTheWindlord.startTime = currentTime
							snapshot.strikeOfTheWindlord.duration = spells.strikeOfTheWindlord.cooldown
						end
					elseif spellId == spells.serenity.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.serenity)
					elseif spellId == spells.danceOfChiJi.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.danceOfChiJi)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.monk.windwalker.audio.danceOfChiJi.enabled and not TRB.Data.snapshot.audio.playedDanceOfChiJiCue then
								TRB.Data.snapshot.audio.playedDanceOfChiJiCue = true
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.monk.windwalker.audio.danceOfChiJi.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then
							snapshot.audio.playedDanceOfChiJiCue = false
						end
					elseif spellId == spells.markOfTheCrane.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								snapshot.targetData.targets[destGUID].spells[spells.markOfTheCrane.id].active = false
								snapshot.targetData.targets[destGUID].spells[spells.markOfTheCrane.id].remainingTime = 0
								snapshot.targetData.count[spells.markOfTheCrane.id] = snapshot.targetData.count[spells.markOfTheCrane.id] - 1
								triggerUpdate = true
							end
						end
					elseif spellId == spells.tigerPalm.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_DAMAGE" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							end
						end
					elseif spellId == spells.blackoutKick.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_DAMAGE" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							end
						end
					elseif spellId == spells.risingSunKick.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_DAMAGE" then
								ApplyMarkOfTheCrane(destGUID)
								triggerUpdate = true
							end
						end
					elseif spellId == spells.detox.id then
						if type == "SPELL_DISPEL" then
							snapshot.detox.startTime = currentTime
							snapshot.detox.duration = spells.detox.cooldown
						end
					elseif spellId == spells.expelHarm.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshot.expelHarm.startTime = currentTime
							snapshot.expelHarm.duration = spells.expelHarm.cooldown
						end
					elseif spellId == spells.paralysis.id then
						if type == "SPELL_CAST_SUCCESS" then
							snapshot.paralysis.startTime = currentTime
							snapshot.paralysis.duration = spells.paralysis.cooldown

							if TRB.Functions.Talent:IsTalentActive(spells.paralysisRank2) then
								snapshot.paralysis.duration = snapshot.paralysis.duration + spells.paralysisRank2.cooldownMod
							end
						end
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
		elseif specId == 2 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.monk.mistweaver)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.mistweaver)
			specCache.mistweaver.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Mistweaver()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.mistweaver)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshot.targetData = TRB.Classes.TargetData:New()

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
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshot.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshot.targetData
			targetData:AddSpellTracking(spells.markOfTheCrane, nil, nil, nil, true)

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
		local spells = TRB.Data.spells
		
		if specId == 2 then
			TRB.Data.character.specName = "mistweaver"
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
		local snapshot = TRB.Data.snapshot

		if specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.monk.mistweaver.displayBar.alwaysShow) and (
						(not TRB.Data.settings.monk.mistweaver.displayBar.notZeroShow) or
						(TRB.Data.settings.monk.mistweaver.displayBar.notZeroShow and snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshot.isTracking = false
			else
				snapshot.isTracking = true
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
						(TRB.Data.settings.monk.windwalker.displayBar.notZeroShow and snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshot.isTracking = false
			else
				snapshot.isTracking = true
				if TRB.Data.settings.monk.windwalker.displayBar.neverShow == true then
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
			elseif var == "$mtTime" or var == "$manaTeaTime" then
				if snapshot.manaTea.isActive then
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
			elseif var == "$siMana" then
				if snapshot.soulfangInfusion.isActive then
					valid = true
				end
			elseif var == "$siTicks" then
				if snapshot.soulfangInfusion.isActive then
					valid = true
				end
			elseif var == "$siTime" then
				if snapshot.soulfangInfusion.isActive then
					valid = true
				end
			end
		elseif specId == 3 then --Windwalker
			if var == "$casting" then
				if snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0 then
					valid = true
				end
			elseif var == "$passive" then
				if snapshot.resource < TRB.Data.character.maxResource and
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
				if snapshot.markOfTheCrane.count > 0 then
					valid = true
				end
			elseif var == "$motcActiveCount" then
				if snapshot.markOfTheCrane.activeCount > 0 then
					valid = true
				end
			elseif var == "$motcMinTime" then
				if snapshot.markOfTheCrane.minEndTime ~= nil then
					valid = true
				end
			elseif var == "$motcMaxTime" then
				if snapshot.markOfTheCrane.maxEndTime ~= nil then
					valid = true
				end
			elseif var == "$motcTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					target ~= nil and
					target.spells[spells.markOfTheCrane.id] ~= nil and
					target.spells[spells.markOfTheCrane.id].remainingTime > 0 then
					valid = true
				end
			elseif var == "$resource" or var == "$energy" then
				if snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$energyMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$energyTotal" then
				if snapshot.resource > 0 or
					(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
				if snapshot.resource > 0 or
					(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$energyOvercap" or var == "$resourceOvercap" then
				local threshold = ((snapshot.resource / TRB.Data.resourceFactor) + snapshot.casting.resourceFinal)
				if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
				if snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
				if snapshot.resource < TRB.Data.character.maxResource and
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