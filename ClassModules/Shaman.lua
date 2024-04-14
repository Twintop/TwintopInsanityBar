local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 7 then --Only do this if we're on a Shaman!
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
		elemental = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
		enhancement = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
		restoration = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
	}

	local function CalculateManaGain(mana, isPotion)
		local spells = TRB.Data.spells
		if isPotion == nil then
			isPotion = false
		end

		local modifier = 1.0

		if isPotion then
			if TRB.Data.character.items.alchemyStone then
				modifier = modifier * spells.alchemistStone.manaModifier
			end
		end

		return mana * modifier
	end

	local function FillSpecializationCache()
		-- Elemental
		Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0
			},
			dots = {
				fsCount = 0
			},
			chainLightning = {
				targetsHit = 0
			}
		}
		
		specCache.elemental.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			earthShockThreshold = 60,
			earthquakeThreshold = 60,
			effects = {
			},
			items = {
			}
		}

		specCache.elemental.spells = {
			-- Shaman Class Baseline Abilities
			lightningBolt = {
				id = 188196,
				name = "",
				icon = "",
				resource = 8,
				overload = 3,
				baseline = true,
				primalFracture = true
			},
			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},

			-- Elemental Baseline Abilities


			-- Shaman Class Talent Abilities
			lavaBurst = {
				id = 51505,
				name = "",
				icon = "",
				resource = 10,
				isTalent = true,
				baseline = true,
				primalFracture = true
			},
			chainLightning = {
				id = 188443,
				name = "",
				icon = "",
				resource = 4,
				overload = 3,
				isTalent = true,
				baseline = true
			},
			frostShock = {
				id = 196840,
				name = "",
				icon = "",
				resource = 14,
				isTalent = true,
				primalFracture = true
			},
			hex = {
				id = 51514,
				name = "",
				icon = "",
				resource = 8,
				isTalent = true
			},


			-- Elemental Talent Abilities
			earthShock = {
				id = 8042,
				name = "",
				icon = "",
				resource = -60,
				texture = "",
				thresholdId = 1,
				settingKey = "earthShock",
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			earthquake = {
				id = 61882,
				name = "",
				icon = "",
				resource = -60,
				texture = "",
				thresholdId = 2,
				settingKey = "earthquake",
				isTalent = true,
				isSnowflake = true
			},
			inundate = {
				id = 378776,
				name = "",
				icon = "",
				resource = 8,
				isTalent = true
			},
			flowOfPower = {
				id = 385923,
				name = "",
				icon = "",
				resourceMod = {
					base = {
						[0] = {
							lightningBolt = 0,
							lavaBurst = 0
						},
						[1] = {
							lightningBolt = 2,
							lavaBurst = 2
						}
					},
					overload = {
						[0] = {
							lightningBolt = 0,
							lavaBurst = 0
						},
						[1] = {
							lightningBolt = 1,
							lavaBurst = 1
						}
					}
				},
				isTalent = true
			},
			icefury = {
				id = 210714,
				name = "",
				icon = "",
				resource = 25,
				overload = 12,
				stacks = 4,
				duration = 15,
				isTalent = true,
				primalFracture = true
			},
			stormkeeper = {
				id = 191634,
				name = "",
				icon = "",
				stacks = 2,
				duration = 15
			},
			surgeOfPower = {
				id = 285514,
				name = "",
				icon = "",
				isTalent = true
			},
			eyeOfTheStorm = {
				id = 381708,
				name = "",
				icon = "",
				resourceMod = {
					[0] = {
						earthShock = 0,
						earthquake = 0,
						elementalBlast = 0
					},
					[1] = {
						earthShock = -5,
						earthquake = -5,
						elementalBlast = -7
					},
					[2] = {
						earthShock = -10,
						earthquake = -10,
						elementalBlast = -15
					}
				},
				isTalent = true
			},
			powerOfTheMaelstrom = {
				id = 191877,
				name = "",
				icon = "",
				isTalent = true
			},
			elementalBlast = {
				id = 117014,
				name = "",
				icon = "",
				resource = -90,
				thresholdId = 3,
				settingKey = "elementalBlast",
				isTalent = true,
				isSnowflake = true
			},
			echoesOfGreatSundering = {
				id = 384088,
				name = "",
				icon = "",
				isTalent = true
			},
			ascendance = {
				id = 114050,
				name = "",
				icon = "",
				isTalent = true
			},
			lavaBeam = {
				id = 114074,
				name = "",
				icon = "",
				resource = 4, --Tooltip says 3, but spell ID 217891 and in game says 4
				overload = 3
			},

			lightningShield = {
				id = 192106,
				name = "",
				icon = "",
				resource = 5
			},

			--TODO: Add Searing Flames passive resource

			primalFracture = { -- T30 4P
				id = 410018,
				name = "",
				icon = "",
				resourceMod = 1.5
			}
		}
		
		specCache.elemental.snapshotData.audio = {
			playedEsCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.ascendance.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.ascendance)
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.chainLightning.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.chainLightning, {
			targetsHit = 0,
			hitTime = nil,
			hasStruckTargets = false
		})
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.surgeOfPower.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.surgeOfPower, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.powerOfTheMaelstrom.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.powerOfTheMaelstrom, nil, true)
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.icefury.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.icefury, {
			resource = 0
		})
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.stormkeeper.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.stormkeeper)
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.echoesOfGreatSundering.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.echoesOfGreatSundering)
		---@type TRB.Classes.Snapshot
		specCache.elemental.snapshotData.snapshots[specCache.elemental.spells.primalFracture.id] = TRB.Classes.Snapshot:New(specCache.elemental.spells.primalFracture)


		-- Enhancement
		specCache.enhancement.Global_TwintopResourceBar = {
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

		specCache.enhancement.character = {
			guid = UnitGUID("player"),
		---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 10000,
			maxResource2 = 10,
			effects = {
			},
			items = {}
		}

		specCache.enhancement.spells = {
			-- Shaman Class Baseline Abilities
			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},

			-- Enhancement Spec Baseline Abilities

			-- Shaman Class Talents
			
			-- Enhancement Spec Talent Abilities
			ascendance = {
				id = 114051,
				name = "",
				icon = "",
				isTalent = true
			},

		}

		specCache.enhancement.snapshotData.attributes.manaRegen = 0
		specCache.enhancement.snapshotData.audio = {
		}
		---@type TRB.Classes.Snapshot
		specCache.enhancement.snapshotData.snapshots[specCache.enhancement.spells.ascendance.id] = TRB.Classes.Snapshot:New(specCache.enhancement.spells.ascendance)

		specCache.enhancement.barTextVariables = {
			icons = {},
			values = {}
		}

		
		-- Restoration
		specCache.restoration.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0
			},
			dots = {
				--swpCount = 0
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
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8
			},

			resonantWaters = {
				id = 404539,
				name = "",
				icon = "",
				isTalent = true,
				duration = 4,
			},

			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			ascendance = {
				id = 114052,
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
				manaPercent = 0.02,
				ticks = 4,
				tickId = 265144
			},
			innervate = {
				id = 29166,
				name = "",
				icon = "",
				duration = 10
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
				id = 370607,
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

		specCache.restoration.snapshotData.attributes.manaRegen = 0
		specCache.restoration.snapshotData.audio = {
			innervateCue = false
		}
		---@type TRB.Classes.Healer.Innervate
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.innervate.id] = TRB.Classes.Healer.Innervate:New(specCache.restoration.spells.innervate)
		---@type TRB.Classes.Healer.PotionOfChilledClarity
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(specCache.restoration.spells.potionOfChilledClarity)
		---@type TRB.Classes.Healer.ManaTideTotem
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(specCache.restoration.spells.manaTideTotem)
		---@type TRB.Classes.Healer.SymbolOfHope
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(specCache.restoration.spells.symbolOfHope, CalculateManaGain)
		---@type TRB.Classes.Healer.ChanneledManaPotion
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(specCache.restoration.spells.potionOfFrozenFocusRank1, CalculateManaGain)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.aeratedManaPotionRank1)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.conjuredChillglobe)
		---@type TRB.Classes.Healer.MoltenRadiance
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(specCache.restoration.spells.moltenRadiance)
		---@type TRB.Classes.Healer.BlessingOfWinter
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(specCache.restoration.spells.blessingOfWinter)
		---@type TRB.Classes.Snapshot
		specCache.restoration.snapshotData.snapshots[specCache.restoration.spells.ascendance.id] = TRB.Classes.Snapshot:New(specCache.restoration.spells.ascendance)

		specCache.restoration.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Elemental()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "elemental")
	end

	local function Setup_Enhancement()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "enhancement")
	end

	local function Setup_Restoration()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "restoration")
	end

	local function FillSpellData_Elemental()
		Setup_Elemental()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.elemental.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.elemental.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

			{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
			{ variable = "#chainLightning", icon = spells.chainLightning.icon, description = spells.chainLightning.name, printInSettings = true },
			{ variable = "#elementalBlast", icon = spells.elementalBlast.icon, description = spells.elementalBlast.name, printInSettings = true },
			{ variable = "#eogs", icon = spells.echoesOfGreatSundering.icon, description = spells.echoesOfGreatSundering.name, printInSettings = true },
			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
			{ variable = "#frostShock", icon = spells.frostShock.icon, description = spells.frostShock.name, printInSettings = true },
			{ variable = "#icefury", icon = spells.icefury.icon, description = spells.icefury.name, printInSettings = true },
			{ variable = "#lavaBeam", icon = spells.lavaBeam.icon, description = spells.lavaBeam.name, printInSettings = true },
			{ variable = "#lavaBurst", icon = spells.lavaBurst.icon, description = spells.lavaBurst.name, printInSettings = true },
			{ variable = "#lightningBolt", icon = spells.lightningBolt.icon, description = spells.lightningBolt.name, printInSettings = true },
			{ variable = "#lightningShield", icon = spells.lightningShield.icon, description = spells.lightningShield.name, printInSettings = true },
			{ variable = "#primalFracture", icon = spells.primalFracture.icon, description = spells.primalFracture.name, printInSettings = true },
			{ variable = "#stormkeeper", icon = spells.stormkeeper.icon, description = spells.stormkeeper.name, printInSettings = true },
		}
		specCache.elemental.barTextVariables.values = {
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

			{ variable = "$maelstrom", description = L["ShamanElementalBarTextVariable_maelstrom"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$maelstromMax", description = L["ShamanElementalBarTextVariable_maelstromMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["ShamanElementalBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["ShamanElementalBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$maelstromPlusCasting", description = L["ShamanElementalBarTextVariable_maelstromPlusCasting"], printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$maelstromPlusPassive", description = L["ShamanElementalBarTextVariable_maelstromPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$maelstromTotal", description = L["ShamanElementalBarTextVariable_maelstromTotal"], printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },   

			{ variable = "$fsCount", description = L["ShamanElementalBarTextVariable_fsCount"], printInSettings = true, color = false },
			{ variable = "$fsTime", description = L["ShamanElementalBarTextVariable_fsTime"], printInSettings = true, color = false },

			{ variable = "$ifStacks", description = L["ShamanElementalBarTextVariable_ifStacks"], printInSettings = true, color = false },
			{ variable = "$ifMaelstrom", description = L["ShamanElementalBarTextVariable_ifMaelstrom"], printInSettings = true, color = false },
			{ variable = "$ifTime", description = L["ShamanElementalBarTextVariable_ifTime"], printInSettings = true, color = false },

			{ variable = "$skStacks", description = L["ShamanElementalBarTextVariable_skStacks"], printInSettings = true, color = false },
			{ variable = "$skTime", description = L["ShamanElementalBarTextVariable_skTime"], printInSettings = true, color = false },

			{ variable = "$ascendanceTime", description = L["ShamanElementalBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

			{ variable = "$eogsTime", description = L["ShamanElementalBarTextVariable_eogsTime"], printInSettings = true, color = false },

			{ variable = "$pfTime", description = L["ShamanElementalBarTextVariable_pfTime"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}
		
		specCache.elemental.spells = spells
	end

	local function FillSpellData_Enhancement()
		Setup_Enhancement()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.enhancement.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.enhancement.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
			
			{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
		}
		specCache.enhancement.barTextVariables.values = {
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

			{ variable = "$mana", description = L["ShamanEnhancementBarTextVariable_mana"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$manaMax", description = L["ShamanEnhancementBarTextVariable_manaMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			
			{ variable = "$maelstromWeapon", description = L["ShamanEnhancementBarTextVariable_maelstromWeapon"], printInSettings = true, color = false },
			{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
			{ variable = "$maelstromWeaponMax", description = L["ShamanEnhancementBarTextVariable_maelstromWeaponMax"], printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

			{ variable = "$ascendanceTime", description = L["ShamanEnhancementBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

			{ variable = "$fsCount", description = L["ShamanEnhancementBarTextVariable_fsCount"], printInSettings = true, color = false },
			{ variable = "$fsTime", description = L["ShamanEnhancementBarTextVariable_fsTime"], printInSettings = true, color = false },
			
			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}

		specCache.enhancement.spells = spells
	end

	local function FillSpellData_Restoration()
		Setup_Restoration()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.restoration.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.restoration.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
			
			{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

			{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
			{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },
			
			{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
			{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

			{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
			{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
			{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
			{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
			{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = false },
			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
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

			{ variable = "$mana", description = L["ShamanRestorationBarTextVariable_mana"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$manaPercent", description = L["ShamanRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$manaMax", description = L["ShamanRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["ShamanRestorationBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["ShamanRestorationBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$manaPlusCasting", description = L["ShamanRestorationBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$manaPlusPassive", description = L["ShamanRestorationBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$manaTotal", description = L["ShamanRestorationBarTextVariable_manaTotal"], printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
			
			{ variable = "$bowMana", description = L["ShamanRestorationBarTextVariable_bowMana"], printInSettings = true, color = false },
			{ variable = "$bowTime", description = L["ShamanRestorationBarTextVariable_bowTime"], printInSettings = true, color = false },
			{ variable = "$bowTicks", description = L["ShamanRestorationBarTextVariable_bowTicks"], printInSettings = true, color = false },

			{ variable = "$sohMana", description = L["ShamanRestorationBarTextVariable_sohMana"], printInSettings = true, color = false },
			{ variable = "$sohTime", description = L["ShamanRestorationBarTextVariable_sohTime"], printInSettings = true, color = false },
			{ variable = "$sohTicks", description = L["ShamanRestorationBarTextVariable_sohTicks"], printInSettings = true, color = false },

			{ variable = "$innervateMana", description = L["ShamanRestorationBarTextVariable_innervateMana"], printInSettings = true, color = false },
			{ variable = "$innervateTime", description = L["ShamanRestorationBarTextVariable_innervateTime"], printInSettings = true, color = false },
									
			{ variable = "$mrMana", description = L["ShamanRestorationBarTextVariable_mrMana"], printInSettings = true, color = false },
			{ variable = "$mrTime", description = L["ShamanRestorationBarTextVariable_mrTime"], printInSettings = true, color = false },

			{ variable = "$mttMana", description = L["ShamanRestorationBarTextVariable_mttMana"], printInSettings = true, color = false },
			{ variable = "$mttTime", description = L["ShamanRestorationBarTextVariable_mttTime"], printInSettings = true, color = false },
			
			{ variable = "$channeledMana", description = L["ShamanRestorationBarTextVariable_channeledMana"], printInSettings = true, color = false },

			{ variable = "$potionOfChilledClarityMana", description = L["ShamanRestorationBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = L["ShamanRestorationBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

			{ variable = "$potionOfFrozenFocusTicks", description = L["ShamanRestorationBarTextVariable_potionOfFrozenFocusTicks"], printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = L["ShamanRestorationBarTextVariable_potionOfFrozenFocusTime"], printInSettings = true, color = false },
			
			{ variable = "$potionCooldown", description = L["ShamanRestorationBarTextVariable_potionCooldown"], printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = L["ShamanRestorationBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

			{ variable = "$fsCount", description = L["ShamanRestorationBarTextVariable_fsCount"], printInSettings = true, color = false },
			{ variable = "$fsTime", description = L["ShamanRestorationBarTextVariable_fsTime"], printInSettings = true, color = false },
			
			{ variable = "$ascendanceTime", description = L["ShamanRestorationBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}

		specCache.restoration.spells = spells
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		targetData:UpdateTrackedSpells(currentTime)
	end

	local function TargetsCleanup(clearAll)
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
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
		
		local entriesPassive = TRB.Functions.Table:Length(passiveFrame.thresholds)
		if entriesPassive > 0 then
			for x = 1, entriesPassive do
				passiveFrame.thresholds[x]:Hide()
			end
		end

		if specId == 1 then
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
			TRB.Frames.resource2ContainerFrame:Hide()
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
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
		elseif specId == 3 then
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
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Frames.resource2ContainerFrame:Hide()
		end

		TRB.Functions.Class:CheckCharacter()
		TRB.Functions.Bar:Construct(settings)

		if specId == 1 or
		(specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement) or
		specId == 3 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function RefreshLookupData_Elemental()
		local specSettings = TRB.Data.settings.shaman.elemental
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local target = targetData.targets[targetData.currentTargetGuid]
		local currentTime = GetTime()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentMaelstromColor = specSettings.colors.text.currentMaelstrom
		local castingMaelstromColor = specSettings.colors.text.castingMaelstrom

		local maelstromThreshold = TRB.Data.character.earthShockThreshold

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then 
				currentMaelstromColor = specSettings.colors.text.overcapMaelstrom
				castingMaelstromColor = specSettings.colors.text.overcapMaelstrom
			elseif specSettings.colors.text.overThresholdEnabled and snapshotData.attributes.resource >= maelstromThreshold then
				currentMaelstromColor = specSettings.colors.text.overThreshold
				castingMaelstromColor = specSettings.colors.text.overThreshold
			end
		end

		--$maelstrom
		local currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, snapshotData.attributes.resource)
		--$casting
		local castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, snapshotData.casting.resourceFinal)
		--$passive
		local _passiveMaelstrom = 0

		local passiveMaelstrom = string.format("|c%s%.0f|r", specSettings.colors.text.passiveMaelstrom, _passiveMaelstrom)
		--$maelstromTotal
		local _maelstromTotal = math.min(_passiveMaelstrom + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local maelstromTotal = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromTotal)
		--$maelstromPlusCasting
		local _maelstromPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local maelstromPlusCasting = string.format("|c%s%.0f|r", castingMaelstromColor, _maelstromPlusCasting)
		--$maelstromPlusPassive
		local _maelstromPlusPassive = math.min(_passiveMaelstrom + snapshotData.attributes.resource, TRB.Data.character.maxResource)
		local maelstromPlusPassive = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromPlusPassive)

		----------
		--$fsCount and $fsTime
		local _flameShockCount = targetData.count[spells.flameShock.id] or 0
		local flameShockCount = string.format("%s", _flameShockCount)
		local _flameShockTime = 0
		
		if target ~= nil then
			_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
		end

		local flameShockTime

		if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.flameShock.id].active then
				if _flameShockTime > spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
				else
					flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end
		else
			flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
		end

		----------
		--Icefury
		--$ifMaelstrom
		local icefuryMaelstrom = snapshots[spells.icefury.id].attributes.resource or 0
		--$ifStacks
		local icefuryStacks = snapshots[spells.icefury.id].buff.applications or 0
		--$ifStacks
		local _icefuryTime = snapshots[spells.icefury.id].buff:GetRemainingTime(currentTime)
		local icefuryTime = TRB.Functions.BarText:TimerPrecision(_icefuryTime)

		--$skStacks
		local stormkeeperStacks = snapshots[spells.stormkeeper.id].buff.applications or 0
		--$skStacks
		local _stormkeeperTime = snapshots[spells.stormkeeper.id].buff:GetRemainingTime(currentTime)
		local stormkeeperTime = TRB.Functions.BarText:TimerPrecision(_stormkeeperTime)

		--$eogsTime
		local _eogsTime = snapshots[spells.echoesOfGreatSundering.id].buff:GetRemainingTime(currentTime)
		local eogsTime = TRB.Functions.BarText:TimerPrecision(_eogsTime)

		--$pfTime
		local _pfTime = snapshots[spells.primalFracture.id].buff:GetRemainingTime(currentTime)
		local pfTime = TRB.Functions.BarText:TimerPrecision(_pfTime)

		--$ascendanceTime
		local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
		local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveMaelstrom
		Global_TwintopResourceBar.resource.icefury = icefuryMaelstrom
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}
		Global_TwintopResourceBar.chainLightning = {
			targetsHit = snapshots[spells.chainLightning.id].attributes.targetsHit or 0
		}
		Global_TwintopResourceBar.icefury = {
			maelstrom = icefuryMaelstrom,
			stacks = icefuryStacks,
			remaining = icefuryTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		lookup["#chainLightning"] = spells.chainLightning.icon
		lookup["#elementalBlast"] = spells.elementalBlast.icon
		lookup["#eogs"] = spells.echoesOfGreatSundering.icon
		lookup["#flameShock"] = spells.flameShock.icon
		lookup["#frostShock"] = spells.frostShock.icon
		lookup["#icefury"] = spells.icefury.icon
		lookup["#lavaBeam"] = spells.lavaBeam.icon
		lookup["#lavaBurst"] = spells.lavaBurst.icon
		lookup["#lightningBolt"] = spells.lightningBolt.icon
		lookup["#lightningShield"] = spells.lightningShield.icon
		lookup["#primalFracture"] = spells.primalFracture.icon
		lookup["#stormkeeper"] = spells.stormkeeper.icon
		lookup["$maelstromPlusCasting"] = maelstromPlusCasting
		lookup["$maelstromPlusPassive"] = maelstromPlusPassive
		lookup["$maelstromTotal"] = maelstromTotal
		lookup["$maelstromMax"] = TRB.Data.character.maxResource
		lookup["$maelstrom"] = currentMaelstrom
		lookup["$resourcePlusCasting"] = maelstromPlusCasting
		lookup["$resourcePlusPassive"] = maelstromPlusPassive
		lookup["$resourceTotal"] = maelstromTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentMaelstrom
		lookup["$casting"] = castingMaelstrom
		lookup["$passive"] = passiveMaelstrom
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$maelstromOvercap"] = overcap
		lookup["$ifMaelstrom"] = icefuryMaelstrom
		lookup["$ifStacks"] = icefuryStacks
		lookup["$ifTime"] = icefuryTime
		lookup["$skStacks"] = stormkeeperStacks
		lookup["$skTime"] = stormkeeperTime
		lookup["$eogsTime"] = eogsTime
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
		lookup["$ascendanceTime"] = ascendanceTime
		lookup["$pfTime"] = pfTime
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$maelstromPlusCasting"] = _maelstromPlusCasting
		lookupLogic["$maelstromPlusPassive"] = _maelstromPlusPassive
		lookupLogic["$maelstromTotal"] = _maelstromTotal
		lookupLogic["$maelstromMax"] = TRB.Data.character.maxResource
		lookupLogic["$maelstrom"] = snapshotData.attributes.resource
		lookupLogic["$resourcePlusCasting"] = _maelstromPlusCasting
		lookupLogic["$resourcePlusPassive"] = _maelstromPlusPassive
		lookupLogic["$resourceTotal"] = _maelstromTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		lookupLogic["$passive"] = _passiveMaelstrom
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$maelstromOvercap"] = overcap
		lookupLogic["$ifMaelstrom"] = icefuryMaelstrom
		lookupLogic["$ifStacks"] = icefuryStacks
		lookupLogic["$ifTime"] = icefuryTime
		lookupLogic["$skStacks"] = stormkeeperStacks
		lookupLogic["$skTime"] = _stormkeeperTime
		lookupLogic["$eogsTime"] = _eogsTime
		lookupLogic["$fsCount"] = _flameShockCount
		lookupLogic["$fsTime"] = _flameShockTime
		lookupLogic["$ascendanceTime"] = _ascendanceTime
		lookupLogic["$pfTime"] = _pfTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Enhancement()
		local specSettings = TRB.Data.settings.shaman.enhancement
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local target = targetData.targets[targetData.currentTargetGuid]
		--Spec specific implementation
		local currentTime = GetTime()
		local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		snapshotData.attributes.manaRegen, _ = GetPowerRegen()
		local currentManaColor = specSettings.colors.text.current
		--$mana
		local manaPrecision = specSettings.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))

		----------
		--$fsCount and $fsTime
		local _flameShockCount = targetData.count[spells.flameShock.id] or 0
		local flameShockCount = string.format("%s", _flameShockCount)
		local _flameShockTime = 0
		
		if target ~= nil then
			_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
		end

		local flameShockTime

		if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.flameShock.id].active then
				if _flameShockTime > spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
				else
					flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end
		else
			flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
		end

		--$ascendanceTime
		local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
		local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

		----------------------------
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		lookup["#flameShock"] = spells.flameShock.icon
		lookup["$manaMax"] = TRB.Data.character.maxResource
		lookup["$mana"] = currentMana
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentMana
		lookup["$maelstromWeapon"] = snapshotData.attributes.resource2
		lookup["$comboPoints"] = snapshotData.attributes.resource2
		lookup["$maelstromWeaponMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$ascendanceTime"] = ascendanceTime
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = snapshotData.attributes.resource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		lookupLogic["$maelstromWeapon"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$maelstromWeaponMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$ascendanceTime"] = _ascendanceTime
		lookupLogic["$fsCount"] = _flameShockCount
		lookupLogic["$fsTime"] = _flameShockTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Restoration()
		local specSettings = TRB.Data.settings.shaman.restoration
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData
		local target = targetData.targets[targetData.currentTargetGuid]
		local currentTime = GetTime()
		local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		snapshotData.attributes.manaRegen, _ = GetPowerRegen()

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

		----------
		--$fsCount and $fsTime
		local _flameShockCount = snapshotData.targetData.count[spells.flameShock.id] or 0
		local flameShockCount = string.format("%s", _flameShockCount)
		local _flameShockTime = 0
		
		if target ~= nil then
			_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
		end

		local flameShockTime

		if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if target ~= nil and target.spells[spells.flameShock.id].active then
				if _flameShockTime > spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
				else
					flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
			end
		else
			flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
		end

		--$ascendanceTime
		local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
		local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _channeledMana,
			ticks = _potionOfFrozenFocusTicks
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = _sohTicks
		}
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		lookup["#flameShock"] = spells.flameShock.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
		lookup["#bow"] = spells.blessingOfWinter.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
		lookup["$manaPlusCasting"] = manaPlusCasting
		lookup["$manaPlusPassive"] = manaPlusPassive
		lookup["$manaTotal"] = manaTotal
		lookup["$manaMax"] = manaMax
		lookup["$mana"] = currentMana
		lookup["$resourcePlusCasting"] = manaPlusCasting
		lookup["$resourcePlusPassive"] = manaPlusPassive
		lookup["$resourceTotal"] = manaTotal
		lookup["$resourceMax"] = maxResource
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
		lookup["$ascendanceTime"] = ascendanceTime
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
		lookupLogic["$bowMana"] = _bowMana
		lookupLogic["$bowTime"] = _bowTime
		lookupLogic["$bowTicks"] = _bowTicks
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
		lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
		lookupLogic["$fsCount"] = _flameShockCount
		lookupLogic["$fsTime"] = _flameShockTime
		lookupLogic["$ascendanceTime"] = _ascendanceTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell, resourceMod)
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		resourceMod = resourceMod or 0
		local resourceMultMod = 1

		if snapshotData.snapshots[spells.primalFracture.id].buff.isActive then
			if spell.id == spells.lavaBurst.id or
				spell.id == spells.lightningBolt.id or
				spell.id == spells.icefury.id or
				spell.id == spells.frostShock.id
				then
				resourceMultMod = spells.primalFracture.resourceMod
			end
		end

		local currentTime = GetTime()
		snapshotData.casting.startTime = currentTime
		snapshotData.casting.resourceRaw = (spell.resource + resourceMod) * resourceMultMod
		snapshotData.casting.resourceFinal = (spell.resource + resourceMod) * resourceMultMod
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
		local snapshots = snapshotData.snapshots
		local specId = GetSpecialization()
		local affectingCombat = UnitAffectingCombat("player")
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
					--See Priest implementation for handling channeled spells
				else
					if currentSpellId == spells.lightningBolt.id then
						FillSnapshotDataCasting(spells.lightningBolt, spells.flowOfPower.resourceMod.base[talents.talents[spells.flowOfPower.id].currentRank].lightningBolt)

						if snapshots[spells.surgeOfPower.id].buff.isActive then
							snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + ((spells.lightningBolt.overload + spells.flowOfPower.resourceMod.overload[talents.talents[spells.flowOfPower.id].currentRank].lightningBolt) * 2)
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + ((spells.lightningBolt.overload + spells.flowOfPower.resourceMod.overload[talents.talents[spells.flowOfPower.id].currentRank].lightningBolt) * 2)
						end
						
						if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive then
							snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + spells.lightningBolt.overload + spells.flowOfPower.resourceMod.overload[talents.talents[spells.flowOfPower.id].currentRank].lightningBolt
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.lightningBolt.overload + spells.flowOfPower.resourceMod.overload[talents.talents[spells.flowOfPower.id].currentRank].lightningBolt
						end
					elseif currentSpellId == spells.lavaBurst.id then
						FillSnapshotDataCasting(spells.lavaBurst, spells.flowOfPower.resourceMod.base[talents.talents[spells.flowOfPower.id].currentRank].lavaBurst)
					elseif currentSpellId == spells.elementalBlast.id then
						FillSnapshotDataCasting(spells.elementalBlast)
					elseif currentSpellId == spells.icefury.id then
						FillSnapshotDataCasting(spells.icefury)
					elseif currentSpellId == spells.chainLightning.id or currentSpellId == spells.lavaBeam.id then
						local spell = nil
						if currentSpellId == spells.lavaBeam.id then
							spell = spells.lavaBeam
						else
							spell = spells.chainLightning
						end
						FillSnapshotDataCasting(spell)
						
						local currentTime = GetTime()
						local down, up, lagHome, lagWorld = GetNetStats()
						local latency = lagWorld / 1000

						if snapshots[spells.chainLightning.id].attributes.hitTime == nil then
							snapshots[spells.chainLightning.id].attributes.targetsHit = 1
							snapshots[spells.chainLightning.id].attributes.hitTime = currentTime
							snapshots[spells.chainLightning.id].attributes.hasStruckTargets = false
						elseif currentTime > (snapshots[spells.chainLightning.id].attributes.hitTime + (TRB.Functions.Character:GetCurrentGCDTime(true) * 4) + latency) then
							snapshots[spells.chainLightning.id].attributes.targetsHit = 1
						end

						if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive and currentSpellId == spells.chainLightning.id then
							snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + spells.chainLightning.overload
							snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.chainLightning.overload
						end

						snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw * snapshots[spells.chainLightning.id].attributes.targetsHit
						snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * snapshots[spells.chainLightning.id].attributes.targetsHit
					elseif currentSpellId == spells.hex.id and talents:IsTalentActive(spells.inundate) and affectingCombat then
						FillSnapshotDataCasting(spells.hex)
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 2 then
				--[[if currentSpellName == nil then
					return true
				else]]
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				--end
			elseif specId == 3 then	
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

	local function UpdateSnapshot()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local currentTime = GetTime()
		TRB.Functions.Character:UpdateSnapshot()

		snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	end

	local function UpdateSnapshot_Elemental()
		local currentTime = GetTime()
		UpdateSnapshot()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots

		snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
		snapshots[spells.icefury.id].buff:GetRemainingTime(currentTime)

		TRB.Data.character.earthShockThreshold = TRB.Data.character.earthShockThreshold
		TRB.Data.character.earthquakeThreshold = -(spells.earthquake.resource - spells.eyeOfTheStorm.resourceMod[talents.talents[spells.eyeOfTheStorm.id].currentRank].earthquake)
	end

	local function UpdateSnapshot_Enhancement()
		UpdateSnapshot()
	end

	local function UpdateSnapshot_Restoration()
		UpdateSnapshot()
		local _
		local spells = TRB.Data.spells
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
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.shaman
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots

		if specId == 1 then
			local specSettings = classSettings.elemental
			UpdateSnapshot_Elemental()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					local passiveValue = 0

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.overcapCue = false
					end					

					if specSettings.colors.bar.primalFracture.enabled and TRB.Functions.Class:IsValidVariableForSpec("$pfTime") then
						barBorderColor = specSettings.colors.bar.primalFracture.color
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentResource + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

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

					local barColor = specSettings.colors.bar.base

					local pairOffset = 0
					for k, v in pairs(spells) do
						local spell = spells[k]
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							pairOffset = (spell.thresholdId - 1) * 3
							local resourceAmount = spell.resource
							--TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.earthShock.id then
									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif talents:IsTalentActive(spells.elementalBlast) then
										showThreshold = false
									else
										resourceAmount = resourceAmount - spells.eyeOfTheStorm.resourceMod[talents.talents[spells.eyeOfTheStorm.id].currentRank].earthShock
										
										if currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.elementalBlast.id then
									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									else
										resourceAmount = resourceAmount - spells.eyeOfTheStorm.resourceMod[talents.talents[spells.eyeOfTheStorm.id].currentRank].elementalBlast
										
										if currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.earthquake.id then
									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									else
										resourceAmount = resourceAmount - spells.eyeOfTheStorm.resourceMod[talents.talents[spells.eyeOfTheStorm.id].currentRank].earthquake

										if snapshots[spells.echoesOfGreatSundering.id].buff.isActive then
											thresholdColor = specSettings.colors.threshold.echoesOfGreatSundering
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										elseif currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
											frameLevel = TRB.Data.constants.frameLevels.thresholdOver
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
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
							
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
						end
					end

					if currentResource >= TRB.Data.character.earthShockThreshold then
						if specSettings.colors.bar.flashEnabled then
							TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if specSettings.audio.esReady.enabled and snapshotData.audio.playedEsCue == false then
							snapshotData.audio.playedEsCue = true
							PlaySoundFile(specSettings.audio.esReady.sound, coreSettings.audio.channel.channel)
						end
					else
						barContainerFrame:SetAlpha(1.0)
						snapshotData.audio.playedEsCue = false
					end

					if snapshots[spells.ascendance.id].buff.isActive then
						local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
						local timeThreshold = 0
						local useEndOfAscendanceColor = false

						if specSettings.endOfAscendance.enabled then
							useEndOfAscendanceColor = true
							if specSettings.endOfAscendance.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
							elseif specSettings.endOfAscendance.mode == "time" then
								timeThreshold = specSettings.endOfAscendance.timeMax
							end
						end

						if useEndOfAscendanceColor and timeLeft <= timeThreshold then
							barColor = specSettings.colors.bar.inAscendance1GCD
						else
							barColor = specSettings.colors.bar.inAscendance
						end
					end
					
					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.enhancement
			UpdateSnapshot_Enhancement()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local barColor = specSettings.colors.bar.base
					local barBorderColor = specSettings.colors.bar.border

					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))
					
					if snapshots[spells.ascendance.id].buff.isActive then
						local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
						local timeThreshold = 0
						local useEndOfAscendanceColor = false

						if specSettings.endOfAscendance.enabled then
							useEndOfAscendanceColor = true
							if specSettings.endOfAscendance.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
							elseif specSettings.endOfAscendance.mode == "time" then
								timeThreshold = specSettings.endOfAscendance.timeMax
							end
						end

						if useEndOfAscendanceColor and timeLeft <= timeThreshold then
							barColor = specSettings.colors.bar.inAscendance1GCD
						else
							barColor = specSettings.colors.bar.inAscendance
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
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
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 3 then
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

					local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

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

					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentResource, castingBarValue, specSettings, snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

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

					local barColor = specSettings.colors.bar.base

					if snapshots[spells.ascendance.id].buff.isActive then
						local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
						local timeThreshold = 0
						local useEndOfAscendanceColor = false

						if specSettings.endOfAscendance.enabled then
							useEndOfAscendanceColor = true
							if specSettings.endOfAscendance.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
							elseif specSettings.endOfAscendance.mode == "time" then
								timeThreshold = specSettings.endOfAscendance.timeMax
							end
						end

						if useEndOfAscendanceColor and timeLeft <= timeThreshold then
							barColor = specSettings.colors.bar.inAscendance1GCD
						else
							barColor = specSettings.colors.bar.inAscendance
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
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
		local snapshots = snapshotData.snapshots
		local targetData = snapshotData.targetData

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

			local settings
			if specId == 1 then
				settings = TRB.Data.settings.shaman.elemental
			elseif specId == 2 then
				settings = TRB.Data.settings.shaman.enhancement
			elseif specId == 3 then
				settings = TRB.Data.settings.shaman.restoration
			end

			if entry.destinationGuid == TRB.Data.character.guid then
				if specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
					if settings.passiveGeneration.symbolOfHope and (entry.spellId == spells.symbolOfHope.tickId or entry.spellId == spells.symbolOfHope.id) then
						local castByToken = UnitTokenFromGUID(entry.sourceGuid)
						local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
						symbolOfHope.buff:Initialize(entry.type, nil, castByToken)
					elseif settings.passiveGeneration.innervate and entry.spellId == spells.innervate.id then
						local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
						innervate.buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							snapshotData.audio.innervateCue = false
						elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshotData.audio.innervateCue = false
						end
					elseif settings.passiveGeneration.manaTideTotem and entry.spellId == spells.manaTideTotem.id then
						local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
						local duration = spells.manaTideTotem.duration
						if entry.sourceGuid == TRB.Data.character.guid and TRB.Functions.Table:IsTalentActive(spells.resonantWaters) then
							duration = spells.manaTideTotem.duration + spells.resonantWaters.duration
						end
						manaTideTotem:Initialize(entry.type, duration)
					elseif entry.spellId == spells.potionOfChilledClarity.id then
						local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
						potionOfChilledClarity.buff:Initialize(entry.type)
					elseif entry.spellId == spells.moltenRadiance.id then
						local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
						moltenRadiance.buff:Initialize(entry.type)
					elseif settings.passiveGeneration.blessingOfWinter and entry.spellId == spells.blessingOfWinter.id then
						local blessingOfWinter = snapshotData.snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
						blessingOfWinter.buff:Initialize(entry.type)
					end
				end
			end

			if entry.sourceGuid == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "elemental" then
					if entry.spellId == spells.chainLightning.id or entry.spellId == spells.lavaBeam.id then
						if entry.type == "SPELL_DAMAGE" then
							local chainLightning = snapshots[spells.chainLightning.id]
							if chainLightning.attributes.hitTime == nil or currentTime > (chainLightning.attributes.hitTime + 0.1) then --This is a new hit
								chainLightning.attributes.targetsHit = 0
							end
							chainLightning.attributes.targetsHit = chainLightning.attributes.targetsHit + 1
							chainLightning.attributes.hitTime = currentTime
							chainLightning.attributes.hasStruckTargets = true
						end
					elseif entry.spellId == spells.icefury.id then
						snapshots[spells.icefury.id].buff:Initialize(entry.type)
						snapshots[spells.icefury.id].attributes.resource = snapshots[spells.icefury.id].buff.applications * spells.frostShock.resource
					elseif entry.spellId == spells.stormkeeper.id then
						snapshots[spells.stormkeeper.id].buff:Initialize(entry.type)
					elseif entry.spellId == spells.surgeOfPower.id then
						snapshots[spells.surgeOfPower.id].buff:Initialize(entry.type)
					elseif entry.spellId == spells.powerOfTheMaelstrom.id then
						snapshots[spells.powerOfTheMaelstrom.id].buff:Initialize(entry.type)
					elseif entry.spellId == spells.echoesOfGreatSundering.id then
						snapshots[spells.echoesOfGreatSundering.id].buff:Initialize(entry.type)
					elseif entry.spellId == spells.primalFracture.id then
						snapshots[spells.primalFracture.id].buff:Initialize(entry.type)
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "enhancement" then
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then
					if entry.spellId == spells.potionOfFrozenFocusRank1.spellId or entry.spellId == spells.potionOfFrozenFocusRank2.spellId or entry.spellId == spells.potionOfFrozenFocusRank3.spellId then
						local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
						channeledManaPotion.buff:Initialize(entry.type)
					end
				end

				-- Spec agnostic abilities
				if entry.spellId == spells.ascendance.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.flameShock.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
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
			specCache.elemental.talents:GetTalents()
			FillSpellData_Elemental()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.elemental)

			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.flameShock)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Elemental
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.elemental)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)
			
			if TRB.Data.barConstructedForSpec ~= "elemental" then
				talents = specCache.elemental.talents
				TRB.Data.barConstructedForSpec = "elemental"
				ConstructResourceBar(specCache.elemental.settings)
			end
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			specCache.enhancement.talents:GetTalents()
			FillSpellData_Enhancement()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.enhancement)
						
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.flameShock)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Enhancement
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.enhancement)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)

			if TRB.Data.barConstructedForSpec ~= "enhancement" then
				talents = specCache.enhancement.talents
				TRB.Data.barConstructedForSpec = "enhancement"
				ConstructResourceBar(specCache.enhancement.settings)
			end
		elseif specId == 3 then
			specCache.restoration.talents:GetTalents()
			FillSpellData_Restoration()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)

			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
			local targetData = TRB.Data.snapshotData.targetData
			targetData:AddSpellTracking(spells.flameShock)

			TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.restoration)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)

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
	resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local specId = GetSpecialization() or 0
		if classIndexId == 7 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
						TRB.Options:PortForwardSettings()

						local settings = TRB.Options.Shaman.LoadDefaultSettings(false)

						if TwintopInsanityBarSettings.shaman == nil or
							TwintopInsanityBarSettings.shaman.elemental == nil or
							TwintopInsanityBarSettings.shaman.elemental.displayText == nil then
							settings.shaman.elemental.displayText.barText = TRB.Options.Shaman.ElementalLoadDefaultBarTextSimpleSettings()
						end

						if TwintopInsanityBarSettings.core.experimental.specs.shaman.enhancement and
							(TwintopInsanityBarSettings.shaman == nil or
							TwintopInsanityBarSettings.shaman.enhancement == nil or
							TwintopInsanityBarSettings.shaman.enhancement.displayText == nil) then
							settings.shaman.enhancement.displayText.barText = TRB.Options.Shaman.EnhancementLoadDefaultBarTextSimpleSettings()
						end

						if TwintopInsanityBarSettings.shaman == nil or
							TwintopInsanityBarSettings.shaman.restoration == nil or
							TwintopInsanityBarSettings.shaman.restoration.displayText == nil then
							settings.shaman.restoration.displayText.barText = TRB.Options.Shaman.RestorationLoadDefaultBarTextSimpleSettings()
						end

						TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
					else
						local settings = TRB.Options.Shaman.LoadDefaultSettings(true)
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
							TRB.Data.settings.shaman.elemental = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.elemental)
							TRB.Data.settings.shaman.enhancement = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.enhancement)
							TRB.Data.settings.shaman.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues("Restoration Shaman", TRB.Data.settings.shaman.restoration)
							FillSpellData_Elemental()
							FillSpellData_Enhancement()
							FillSpellData_Restoration()

							SwitchSpec()
							TRB.Options.Shaman.ConstructOptionsPanel(specCache)
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
		TRB.Data.character.className = "shaman"
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		
		if specId == 1 then
			TRB.Data.character.specName = "elemental"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom)

			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[spells.earthShock.thresholdId], spells.earthShock.settingKey, TRB.Data.settings.shaman.elemental)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[spells.elementalBlast.thresholdId], spells.elementalBlast.settingKey, TRB.Data.settings.shaman.elemental)

			if (talents:IsTalentActive(spells.elementalBlast) and spells.elementalBlast.resource < TRB.Data.character.maxResource) then
				TRB.Data.character.earthShockThreshold = -(spells.elementalBlast.resource - spells.eyeOfTheStorm.resourceMod[talents.talents[spells.eyeOfTheStorm.id].currentRank].elementalBlast)
			else
				TRB.Data.character.earthShockThreshold = -(spells.earthShock.resource - spells.eyeOfTheStorm.resourceMod[talents.talents[spells.eyeOfTheStorm.id].currentRank].earthShock)
			end
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			TRB.Data.character.specName = "enhancement"
			local maxComboPoints = 10
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(TRB.Data.settings.shaman.enhancement, TRB.Frames.barContainerFrame)
			end
		elseif specId == 3 then
			TRB.Data.character.specName = "restoration"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.Spell:FillSpellDataManaCost(spells)

			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeMana = ""
						
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, spells.alchemistStone.itemIds[x])
					else
						break
					end
				end

				if alchemyStone == false then
					conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
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
				conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket2ItemLink)
			end

			TRB.Data.character.items.alchemyStone = alchemyStone
			TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
			TRB.Data.character.items.conjuredChillglobe.mana = conjuredChillglobeMana
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.shaman.elemental then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Maelstrom
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = nil
			TRB.Data.resource2Id = nil
		elseif specId == 2 and TRB.Data.settings.core.enabled.shaman.enhancement and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = "SPELL"
			TRB.Data.resource2Id = 344179
			TRB.Data.resource2Factor = 1
		elseif specId == 3 and TRB.Data.settings.core.enabled.shaman.restoration then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = nil
			TRB.Data.resource2Id = nil
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
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]] or TRB.Classes.SnapshotData:New()

		if specId == 1 then
			if not TRB.Data.specSupported or force or GetSpecialization() ~= 1 or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.elemental.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.elemental.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.elemental.displayBar.notZeroShow and snapshotData.attributes.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.shaman.elemental.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.enhancement.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.enhancement.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.enhancement.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource and snapshotData.attributes.resource2 == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.shaman.enhancement.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 3 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.restoration.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.restoration.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.restoration.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.shaman.restoration.displayBar.neverShow == true then
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
			settings = TRB.Data.settings.shaman.elemental
		elseif specId == 2 then
			settings = TRB.Data.settings.shaman.enhancement
		elseif specId == 3 then
			settings = TRB.Data.settings.shaman.restoration
		else
			return false
		end

		if specId == 1 then
			if var == "$resource" or var == "$maelstrom" then
				if snapshotData.attributes.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$maelstromMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$maelstromTotal" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id or snapshotData.casting.spellId == spells.lavaBeam.id)) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$maelstromPlusCasting" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id or snapshotData.casting.spellId == spells.lavaBeam.id)) then
					valid = true
				end
			elseif var == "$overcap" or var == "$maelstromOvercap" or var == "$resourceOvercap" then
				local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
				if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$maelstromPlusPassive" then
				if snapshotData.attributes.resource > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id) then
					valid = true
				end
			elseif var == "$passive" then
			elseif var == "$ifMaelstrom" then
				if snapshots[spells.icefury.id].attributes.resource > 0 then
					valid = true
				end
			elseif var == "$ifStacks" then
				if snapshots[spells.icefury.id].buff.isActive then
					valid = true
				end
			elseif var == "$ifTime" then
				if snapshots[spells.icefury.id].buff.isActive then
					valid = true
				end
			elseif var == "$skStacks" then
				if snapshots[spells.stormkeeper.id].buff.isActive then
					valid = true
				end
			elseif var == "$skTime" then
				if snapshots[spells.stormkeeper.id].buff.isActive then
					valid = true
				end
			elseif var == "$eogsTime" then
				if snapshots[spells.echoesOfGreatSundering.id].buff.isActive then
					valid = true
				end
			elseif var == "$pfTime" then
				if snapshots[spells.primalFracture.id].buff.isActive then
					valid = true
				end
			end
		elseif specId == 2 then --Enhancement
			if var == "$casting" then
				if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
					valid = true
				end
			elseif var == "$passive" then
				if snapshotData.attributes.resource < TRB.Data.character.maxResource and
					settings.generation.enabled and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$resource" or var == "$mana" then
				valid = true
			elseif var == "$resourceMax" or var == "$manaMax" then
				valid = true
			elseif var == "$resourcePercent" or var == "$manaPercent" then
				valid = true
			elseif var == "$resourceTotal" or var == "$manaTotal" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
				if snapshotData.attributes.resource > 0 or
					(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
				if snapshotData.attributes.resource > 0 then
					valid = true
				end
			elseif var == "$regen" then
				if snapshotData.attributes.resource < TRB.Data.character.maxResource and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$comboPoints" or var == "$maelstromWeapon" then
				valid = true
			elseif var == "$comboPointsMax"or var == "$maelstromWeaponMax" then
				valid = true
			end
		elseif specId == 3 then
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
			end
		else
			valid = false
		end
		
		-- Spec Agnostic
		if var == "$fsCount" then
			if snapshotData.targetData.count[spells.flameShock.id] > 0 then
				valid = true
			end
		elseif var == "$fsTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.flameShock.id] ~= nil and
				target.spells[spells.flameShock.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		end

		return valid
	end

	function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
		local specId = GetSpecialization()
		local settings = TRB.Data.settings.shaman
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if specId == 1 then
		elseif specId == 2 then
		elseif specId == 3 then
		end
		return nil
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if (specId ~= 1 and specId ~= 2 and specId ~= 3) or
			(specId == 2 and not TRB.Data.settings.core.experimental.specs.shaman.enhancement) then
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