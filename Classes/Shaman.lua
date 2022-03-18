local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 7 then --Only do this if we're on a Shaman!
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
		elemental = {
			snapshotData = {},
			barTextVariables = {
				icons = {},
				values = {}
			}
		},
		restoration = {
			snapshotData = {},
			barTextVariables = {
				icons = {},
				values = {}
			}
		}
	}

	local function FillSpecCache()
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
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			earthShockThreshold = 60,
			effects = {
				overgrowthSeedling = 1.0
			},
			talents = {
				echoingShock = {
					isSelected = false,
					modifier = 2,
					duration = 1.0
				},
				elementalBlast = {
					isSelected = false
				},
				surgeOfPower = {
					isSelected = false
				},
				icefury = {
					isSelected = false
				},
				stormkeeper = {
					isSelected = false
				},
				ascendance = {
					isSelected = false
				}
			},
			items = {
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				},
				depletedTeslaCoil = false
			}
		}

		specCache.elemental.spells = {
			earthShock = {
				id = 8042,
				name = "",
				icon = "",
				maelstrom = -60,
				texture = "",
				thresholdId = 1,
				settingKey = "earthShock",
				thresholdUsable = false
			},

			lightningBolt = {
				id = 188196,
				name = "",
				icon = "",
				maelstrom = 8,
				overload = 3,
				echoingShock = true
			},
			lavaBurst = {
				id = 51505,
				name = "",
				icon = "",
				maelstrom = 10,
				echoingShock = true
			},

			chainLightning = {
				id = 188443,
				name = "",
				icon = "",
				maelstrom = 4,
				overload = 3,
				echoingShock = true
			},
			lavaBeam = {
				id = 114074,
				name = "",
				icon = "",
				maelstrom = 4, --Tooltip says 3, but spell ID 217891 and in game says 4
				overload = 3,
				echoingShock = false
			},

			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			frostShock = {
				id = 196840,
				name = "",
				icon = "",
				maelstrom = 8,
				echoingShock = false
			},
			lightningShield = {
				id = 192106,
				name = "",
				icon = "",
				maelstrom = 5,
				echoingShock = false
			},

			elementalBlast = {
				id = 117014,
				name = "",
				icon = "",
				maelstrom = 30,
				overload = 15,
				echoingShock = false --Is this possible to do?
			},
			echoingShock = {
				id = 320125,
				name = "", 
				icon = ""
			},


			surgeOfPower = {
				id = 285514,
				name = "", 
				icon = "",
				isActive = false
			},
			icefury = {
				id = 210714,
				name = "",
				icon = "",
				maelstrom = 25,
				overload = 12,
				echoingShock = true,
				stacks = 4,
				duration = 15
			},

			stormkeeper = {
				id = 191634,
				name = "",
				icon = "",
				stacks = 2,
				duration = 15
			},
			ascendance = {
				id = 114050,
				name = "", 
				icon = ""
			},

			-- Legendaries
			echoesOfGreatSundering = {
				id = 336217,
				name = "", 
				icon = ""
			},

			-- Torghast
			depletedTeslaCoil = {
				id = 350248,
				name = "",
				icon = "",
				duration = 25
			}
		}
		
		specCache.elemental.snapshotData.audio = {
			playedEsCue = false
		}
		specCache.elemental.snapshotData.chainLightning = {
			targetsHit = 0,
			hitTime = nil,
			hasStruckTargets = false
		}
		specCache.elemental.snapshotData.surgeOfPower = {
			isActive = false
		}
		specCache.elemental.snapshotData.icefury = {
			isActive = false,
			stacks = 0,
			startTime = nil,
			maelstrom = 0
		}
		specCache.elemental.snapshotData.stormkeeper = {
			isActive = false,
			stacks = 0,
			duration = 0,
			endTime = nil,
			spell = nil
		}
		specCache.elemental.snapshotData.echoingShock = {
			isActive = false,
			spell = nil
		}
		specCache.elemental.snapshotData.echoesOfGreatSundering = {
			isActive = false,
			duration = 0,
			endTime = nil
		}
		specCache.elemental.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			flameShock = 0,
			targets = {}
		}


		
		-- Restoration
		specCache.restoration.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				wrathfulFaerie = 0
			},
			dots = {
				--swpCount = 0
			},
		}

		specCache.restoration.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			effects = {
				overgrowthSeedlingModifier = 1
			},
			talents = {
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
				alchemyStone = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.restoration.spells = {
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8,
				isActive = false
			},

			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
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

			-- Covenant

			-- Conduit

			-- Potions
			potionOfSpiritualClarity = {
				itemId = 171272,
				spellId = 307161,
				name = "",
				icon = "",
				texture = "",
				thresholdId = 1,
				settingKey = "potionOfSpiritualClarity",
				thresholdUsable = false,
				mana = 1000,
				duration = 10,
				ticks = 10
			},
			spiritualRejuvenationPotion = {
				itemId = 171269,
				name = "",
				icon = "",
				texture = "",
				thresholdId = 2,
				settingKey = "spiritualRejuvenationPotion",
				thresholdUsable = false
			},
			spiritualManaPotion = {
				itemId = 171268,
				name = "",
				icon = "",
				texture = "",
				thresholdId = 3,
				settingKey = "spiritualManaPotion",
				thresholdUsable = false
			},
			soulfulManaPotion = {
				itemId = 180318,
				name = "",
				icon = "",
				texture = "",
				thresholdId = 4,
				settingKey = "soulfulManaPotion",
				thresholdUsable = false
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

			-- Torghast
			elethiumMuzzle = {
				id = 319276,
				name = "",
				icon = ""
			}
		}

		specCache.restoration.snapshotData.manaRegen = 0
		specCache.restoration.snapshotData.audio = {
			innervateCue = false
		}
		specCache.restoration.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			flameShock = 0,
			targets = {}
		}
		specCache.restoration.snapshotData.innervate = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
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
		specCache.restoration.snapshotData.potionOfSpiritualClarity = {
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

		specCache.restoration.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Elemental()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.elemental)
	end

	local function FillSpellData_Elemental()
		Setup_Elemental()
		local spells = TRB.Functions.FillSpellData(specCache.elemental.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.elemental.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Maelstrom generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
			{ variable = "#chainLightning", icon = spells.chainLightning.icon, description = spells.chainLightning.name, printInSettings = true },
			{ variable = "#echoingShock", icon = spells.echoingShock.icon, description = spells.echoingShock.name, printInSettings = true },
			{ variable = "#elementalBlast", icon = spells.elementalBlast.icon, description = spells.elementalBlast.name, printInSettings = true },
			{ variable = "#eogs", icon = spells.echoesOfGreatSundering.icon, description = spells.echoesOfGreatSundering.name, printInSettings = true },
			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
			{ variable = "#frostShock", icon = spells.frostShock.icon, description = spells.frostShock.name, printInSettings = true },
			{ variable = "#icefury", icon = spells.icefury.icon, description = spells.icefury.name, printInSettings = true },
			{ variable = "#lavaBeam", icon = spells.lavaBeam.icon, description = spells.lavaBeam.name, printInSettings = true },
			{ variable = "#lavaBurst", icon = spells.lavaBurst.icon, description = spells.lavaBurst.name, printInSettings = true },
			{ variable = "#lightningBolt", icon = spells.lightningBolt.icon, description = spells.lightningBolt.name, printInSettings = true },
			{ variable = "#lightningShield", icon = spells.lightningShield.icon, description = spells.lightningShield.name, printInSettings = true },
			{ variable = "#stormkeeper", icon = spells.stormkeeper.icon, description = spells.stormkeeper.name, printInSettings = true },
		}
		specCache.elemental.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility% (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versatility", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility% (damage reduction/defensive)", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the |cFF68CCEFKyrian|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the |cFF40BF40Necrolord|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the |cFFA330C9Night Fae|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the |cFFFF4040Venthyr|r Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$maelstrom", description = "Current Maelstrom", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Maelstrom", printInSettings = false, color = false },
			{ variable = "$maelstromMax", description = "Maximum Maelstrom", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Maelstrom", printInSettings = false, color = false },
			{ variable = "$casting", description = "Maelstrom from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Maelstrom from Passive Sources", printInSettings = true, color = false },
			{ variable = "$maelstromPlusCasting", description = "Current + Casting Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Maelstrom Total", printInSettings = false, color = false },
			{ variable = "$maelstromPlusPassive", description = "Current + Passive Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Maelstrom Total", printInSettings = false, color = false },
			{ variable = "$maelstromTotal", description = "Current + Passive + Casting Maelstrom Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Maelstrom Total", printInSettings = false, color = false },   

			{ variable = "$fsCount", description = "Number of Flame Shocks active on targets", printInSettings = true, color = false },
			{ variable = "$fsTime", description = "Time remaining on Flame Shock on your current target", printInSettings = true, color = false },

			{ variable = "$ifStacks", description = "Number of Icefury Frost Shock stacks remaining", printInSettings = true, color = false },
			{ variable = "$ifMaelstrom", description = "Total Maelstrom from available Icefury Frost Shock stacks", printInSettings = true, color = false },
			{ variable = "$ifTime", description = "Time remaining on Icefury buff", printInSettings = true, color = false },

			{ variable = "$skStacks", description = "Number of Stormkeeper stacks remaining", printInSettings = true, color = false },
			{ variable = "$skTime", description = "Time remaining on Stormkeeper buff", printInSettings = true, color = false },

			{ variable = "$eogsTime", description = "Time remaining on Echoes of Great Sundering buff", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}
		
		specCache.elemental.spells = spells
	end

	local function Setup_Restoration()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.restoration)
	end

	local function FillSpellData_Restoration()
		Setup_Restoration()
		local spells = TRB.Functions.FillSpellData(specCache.restoration.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.restoration.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },
			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

			{ variable = "#psc", icon = spells.potionOfSpiritualClarity.icon, description = spells.potionOfSpiritualClarity.name, printInSettings = true },
			{ variable = "#potionOfSpiritualClarity", icon = spells.potionOfSpiritualClarity.icon, description = spells.potionOfSpiritualClarity.name, printInSettings = false },
			{ variable = "#srp", icon = spells.spiritualRejuvenationPotion.icon, description = spells.spiritualRejuvenationPotion.name, printInSettings = true },
			{ variable = "#spiritualRejuvenationPotion", icon = spells.spiritualRejuvenationPotion.icon, description = spells.spiritualRejuvenationPotion.name, printInSettings = false },
			{ variable = "#spiritualManaPotion", icon = spells.spiritualManaPotion.icon, description = spells.spiritualManaPotion.name, printInSettings = true },
			{ variable = "#soulfulManaPotion", icon = spells.soulfulManaPotion.icon, description = spells.soulfulManaPotion.name, printInSettings = true },

			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
		}
		specCache.restoration.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility% (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versatility", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility% (damage reduction/defensive)", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the |cFF68CCEFKyrian|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the |cFF40BF40Necrolord|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the |cFFA330C9Night Fae|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the |cFFFF4040Venthyr|r Covenant? Logic variable only!", printInSettings = true, color = false },

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

			{ variable = "$fsCount", description = "Number of Flame Shocks active on targets", printInSettings = true, color = false },
			{ variable = "$fsTime", description = "Time remaining on Flame Shock on your current target", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.restoration.spells = spells
	end

	local function CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "shaman"
		
		if specId == 1 then
			TRB.Data.character.specName = "elemental"
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom)
			TRB.Data.character.talents.echoingShock.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.elementalBlast.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.surgeOfPower.isSelected = select(4, GetTalentInfo(6, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.icefury.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.stormkeeper.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.ascendance.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))

			if TRB.Data.settings.shaman ~= nil and TRB.Data.settings.shaman.elemental ~= nil and TRB.Data.settings.shaman.elemental.thresholds.earthShock.enabled and TRB.Data.character.earthShockThreshold < TRB.Data.character.maxResource then
				resourceFrame.thresholds[1]:Show()
				TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.elemental, resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.shaman.elemental.thresholds.width, TRB.Data.character.earthShockThreshold, TRB.Data.character.maxResource)
			else
				resourceFrame.thresholds[1]:Hide()
			end
			
			-- Torghast
			if IsInJailersTower() then			
				if TRB.Functions.FindAuraById(TRB.Data.spells.depletedTeslaCoil.id, "player", "MAW") then
					TRB.Data.character.torghast.depletedTeslaCoil = true
				else
					TRB.Data.character.torghast.depletedTeslaCoil = false
				end
			else -- Elsewhere
				TRB.Data.character.torghast.depletedTeslaCoil = false
			end
		elseif specId == 3 then
			TRB.Data.character.specName = "restoration"
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.FillSpellDataManaCost(TRB.Data.spells)


			-- Legendaries
			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)
			
			local alchemyStone = false
			
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
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.shaman.elemental then
			TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.elemental)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Maelstrom
			TRB.Data.resourceFactor = 1
		elseif specId == 3 and TRB.Data.settings.core.enabled.shaman.restoration and TRB.Data.settings.core.experimental.specs.shaman.restoration then
			TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.restoration)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
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

	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()

		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			if specId == 1 then -- Elemental
				TRB.Functions.InitializeTarget(guid)
				TRB.Data.snapshotData.targetData.targets[guid].flameShock = false
				TRB.Data.snapshotData.targetData.targets[guid].flameShockRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell = nil
			elseif specId == 3 then -- Restoration
				TRB.Functions.InitializeTarget(guid)
				TRB.Data.snapshotData.targetData.targets[guid].flameShock = false
				TRB.Data.snapshotData.targetData.targets[guid].flameShockRemaining = 0
			end
		end
		TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()

		return true
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

		if specId == 1 then
			local fsTotal = 0
			local echoingShockSpell = nil
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[guid].flameShock = false
					TRB.Data.snapshotData.targetData.targets[guid].flameShockRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell = nil
				else
					if TRB.Data.snapshotData.targetData.targets[guid].flameShock == true then
						fsTotal = fsTotal + 1
					end

					if TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell ~= nil then
						if currentTime > TRB.Data.snapshotData.targetData.targets[guid].echoingShockExpiration then
							TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell = nil
							TRB.Data.snapshotData.targetData.targets[guid].echoingShockExpiration = nil
						else
							echoingShockSpell = TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell
						end
					end
				end
			end
			TRB.Data.snapshotData.targetData.flameShock = fsTotal
			TRB.Data.snapshotData.echoingShock.spell = echoingShockSpell
		elseif specId == 3 then -- Restoration
			local fsTotal = 0
			for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[tguid].flameShock = false
					TRB.Data.snapshotData.targetData.targets[tguid].flameShockRemaining = 0
				else
					if TRB.Data.snapshotData.targetData.targets[tguid].flameShock == true then
						fsTotal = fsTotal + 1
					end
				end
			end

			TRB.Data.snapshotData.targetData.flameShock = fsTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		local specId = GetSpecialization()

		if specId == 1 then
			if clearAll == true then
				TRB.Data.snapshotData.targetData.flameShock = 0
				TRB.Data.snapshotData.echoingShock.spell = nil
			end
		elseif specId == 3 then
			if clearAll == true then
				TRB.Data.snapshotData.targetData.flameShock = 0
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
		
		local entriesPassive = TRB.Functions.TableLength(passiveFrame.thresholds)
		if entriesPassive > 0 then
			for x = 1, entriesPassive do
				passiveFrame.thresholds[x]:Hide()
			end
		end

		if specId == 1 then
			for x = 1, 1 do -- ES
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(0)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.earthShock.settingKey, settings)
		elseif specId == 3 and TRB.Data.settings.core.experimental.specs.shaman.restoration then
			for x = 1, 4 do
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(0)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end

			for x = 1, 4 do
				if TRB.Frames.passiveFrame.thresholds[x] == nil then
					TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
				end

				TRB.Frames.passiveFrame.thresholds[x]:Show()
				TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(0)
				TRB.Frames.passiveFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.potionOfSpiritualClarity.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.spiritualRejuvenationPotion.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.spiritualManaPotion.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.soulfulManaPotion.settingKey, TRB.Data.settings.shaman.restoration)		
		end

		TRB.Functions.ConstructResourceBar(settings)

		if specId == 1 or (specId == 3 and TRB.Data.settings.core.experimental.specs.shaman.restoration) then
			TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
		end
	end
	
	local function GetStormkeeperRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.stormkeeper)
	end
	
	local function GetEchoesOfGreatSunderingRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.echoesOfGreatSundering)
	end

	local function GetPotionOfSpiritualClarityRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.potionOfSpiritualClarity)
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

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.shaman.elemental
		elseif specId == 2 then
			settings = TRB.Data.settings.shaman.restoration
		end

		if specId == 1 then
			if var == "$resource" or var == "$maelstrom" then
				if TRB.Data.snapshotData.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$maelstromMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$maelstromTotal" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.lavaBeam.id)) or
					(TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0)then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$maelstromPlusCasting" then
				if TRB.Data.snapshotData.resource > 0 or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.lavaBeam.id)) then
					valid = true
				end
			elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
				if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.settings.shaman.elemental.overcapThreshold then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$maelstromPlusPassive" then
				if TRB.Data.snapshotData.resource > 0 or (TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0) then
					valid = true
				end
			elseif var == "$casting" then
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id) then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0 then
					valid = true
				end
			elseif var == "$ifMaelstrom" then
				if TRB.Data.snapshotData.icefury.maelstrom > 0 then
					valid = true
				end
			elseif var == "$ifStacks" then
				if TRB.Data.snapshotData.icefury.stacks > 0 then
					valid = true
				end
			elseif var == "$ifTime" then
				if TRB.Data.snapshotData.icefury.startTime ~= nil and TRB.Data.snapshotData.icefury.startTime > 0 then
					valid = true
				end
			elseif var == "$skStacks" then
				if TRB.Data.snapshotData.stormkeeper.stacks ~= nil and TRB.Data.snapshotData.stormkeeper.stacks > 0 then
					valid = true
				end
			elseif var == "$skTime" then
				if TRB.Data.snapshotData.stormkeeper.stacks ~= nil and TRB.Data.snapshotData.stormkeeper.stacks > 0 then
					valid = true
				end
			elseif var == "$eogsTime" then
				if GetEchoesOfGreatSunderingRemainingTime() > 0 then
					valid = true
				end
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
				if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$passive" then
				if IsValidVariableForSpec("$pscMana") or
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
			end
		else
			valid = false
		end
		
		-- Spec Agnostic
		if var == "$fsCount" then
			if TRB.Data.snapshotData.targetData.flameShock > 0 then
				valid = true
			end
		elseif var == "$fsTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining > 0 then
				valid = true
			end
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Elemental()
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom
		local castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.castingMaelstrom

		local maelstromThreshold = TRB.Data.character.earthShockThreshold

		if TRB.Data.settings.shaman.elemental.colors.text.overcapEnabled and overcap then 
			currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom
			castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom
		elseif TRB.Data.settings.shaman.elemental.colors.text.overThresholdEnabled and TRB.Data.snapshotData.resource >= maelstromThreshold then
			currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overThreshold
			castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overThreshold
		end

		--$maelstrom
		local currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _passiveMaelstrom = 0

		if TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0 then
			_passiveMaelstrom = _passiveMaelstrom + TRB.Data.snapshotData.echoingShock.spell.maelstrom
		end

		local passiveMaelstrom = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.passiveMaelstrom, _passiveMaelstrom)
		--$maelstromTotal
		local _maelstromTotal = math.min(_passiveMaelstrom + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromTotal = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromTotal)
		--$maelstromPlusCasting
		local _maelstromPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromPlusCasting = string.format("|c%s%.0f|r", castingMaelstromColor, _maelstromPlusCasting)
		--$maelstromPlusPassive
		local _maelstromPlusPassive = math.min(_passiveMaelstrom + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromPlusPassive = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromPlusPassive)

		----------
		--$fsCount and $fsTime
		local _flameShockCount = TRB.Data.snapshotData.targetData.flameShock or 0
		local flameShockCount = _flameShockCount
		local _flameShockTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_flameShockTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining or 0
		end

		local flameShockTime

		if TRB.Data.settings.shaman.elemental.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShock then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining > TRB.Data.spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining)
				else
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining)
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, 0)
			end
		else
			flameShockTime = string.format("%.1f", _flameShockTime)
		end

		----------
		--Icefury
		--$ifMaelstrom
		local icefuryMaelstrom = TRB.Data.snapshotData.icefury.maelstrom or 0
		--$ifStacks
		local icefuryStacks = TRB.Data.snapshotData.icefury.stacks or 0
		--$ifStacks
		local icefuryTime = 0
		if TRB.Data.snapshotData.icefury.startTime ~= nil then
			icefuryTime = string.format("%.1f", math.abs(currentTime - (TRB.Data.snapshotData.icefury.startTime + TRB.Data.spells.icefury.duration)))
		end

		--$skStacks
		local stormkeeperStacks = TRB.Data.snapshotData.stormkeeper.stacks or 0
		--$skStacks
		local stormkeeperTime = 0
		if stormkeeperStacks > 0 then
			stormkeeperTime = string.format("%.1f", GetStormkeeperRemainingTime())
		end

		--$eogsTime
		local eogsTime = 0
		if GetEchoesOfGreatSunderingRemainingTime() > 0 then
			eogsTime = string.format("%.1f", GetEchoesOfGreatSunderingRemainingTime())
		end
		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveMaelstrom
		Global_TwintopResourceBar.resource.icefury = icefuryMaelstrom
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}
		Global_TwintopResourceBar.chainLightning = {
			targetsHit = TRB.Data.snapshotData.chainLightning.targetsHit or 0
		}
		Global_TwintopResourceBar.icefury = {
			maelstrom = icefuryMaelstrom,
			stacks = icefuryStacks,
			remaining = icefuryTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = TRB.Data.spells.ascendance.icon
		lookup["#chainLightning"] = TRB.Data.spells.chainLightning.icon
		lookup["#echoingShock"] = TRB.Data.spells.echoingShock.icon
		lookup["#elementalBlast"] = TRB.Data.spells.elementalBlast.icon
		lookup["#eogs"] = TRB.Data.spells.echoesOfGreatSundering.icon
		lookup["#flameShock"] = TRB.Data.spells.flameShock.icon
		lookup["#frostShock"] = TRB.Data.spells.frostShock.icon
		lookup["#icefury"] = TRB.Data.spells.icefury.icon
		lookup["#lavaBeam"] = TRB.Data.spells.lavaBeam.icon
		lookup["#lavaBurst"] = TRB.Data.spells.lavaBurst.icon
		lookup["#lightningBolt"] = TRB.Data.spells.lightningBolt.icon
		lookup["#lightningShield"] = TRB.Data.spells.lightningShield.icon
		lookup["#stormkeeper"] = TRB.Data.spells.stormkeeper.icon
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
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
		TRB.Data.lookup = lookup
	end

	local function RefreshLookupData_Restoration()
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.shaman.restoration.colors.text.current
		local castingManaColor = TRB.Data.settings.shaman.restoration.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.shaman.restoration.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor"))
		--$casting
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.ConvertToShortNumberNotation(TRB.Data.snapshotData.casting.resourceFinal, manaPrecision, "floor"))

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
		local _passiveMana = _sohMana + _pscMana + _innervateMana + _mttMana
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.shaman.restoration.colors.text.passive, TRB.Functions.ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor"))
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

		----------
		--$fsCount and $fsTime
		local _flameShockCount = TRB.Data.snapshotData.targetData.flameShock or 0
		local flameShockCount = _flameShockCount
		local _flameShockTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_flameShockTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining or 0
		end

		local flameShockTime

		if TRB.Data.settings.shaman.elemental.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShock then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining > TRB.Data.spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining)
				else
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining)
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, 0)
			end
		else
			flameShockTime = string.format("%.1f", _flameShockTime)
		end

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _pscMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _pscMana,
			ticks = TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = TRB.Data.snapshotData.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#flameShock"] = TRB.Data.spells.flameShock.icon
		lookup["#innervate"] = TRB.Data.spells.innervate.icon
		lookup["#mtt"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#soh"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#psc"] = TRB.Data.spells.potionOfSpiritualClarity.icon
		lookup["#potionOfSpiritualClarity"] = TRB.Data.spells.potionOfSpiritualClarity.icon
		lookup["#srp"] = TRB.Data.spells.spiritualRejuvenationPotion.icon
		lookup["#spiritualRejuvenationPotion"] = TRB.Data.spells.spiritualRejuvenationPotion.icon
		lookup["#spiritualManaPotion"] = TRB.Data.spells.spiritualManaPotion.icon
		lookup["#soulfulManaPotion"] = TRB.Data.spells.soulfulManaPotion.icon
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
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$pscMana"] = pscMana
		lookup["$pscTicks"] = pscTicks
		lookup["$pscTime"] = pscTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		TRB.Data.lookup = lookup
	end

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.maelstrom
        TRB.Data.snapshotData.casting.resourceFinal = spell.maelstrom
        TRB.Data.snapshotData.casting.spellId = spell.id
        TRB.Data.snapshotData.casting.icon = spell.icon
    end


	local function UpdateCastingResourceFinal_Restoration()
		-- Do nothing for now
		TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw
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
					--See Priest implementation for handling channeled spells
				else
					if currentSpellId == TRB.Data.spells.lightningBolt.id then
						FillSnapshotDataCasting(TRB.Data.spells.lightningBolt)

						if TRB.Data.spells.surgeOfPower.isActive then
							TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.snapshotData.casting.resourceRaw + TRB.Data.spells.lightningBolt.overload
							TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.spells.lightningBolt.overload
						end
					elseif currentSpellId == TRB.Data.spells.lavaBurst.id then
						FillSnapshotDataCasting(TRB.Data.spells.lavaBurst)
					elseif currentSpellId == TRB.Data.spells.elementalBlast.id then
						FillSnapshotDataCasting(TRB.Data.spells.elementalBlast)
					elseif currentSpellId == TRB.Data.spells.icefury.id then
						FillSnapshotDataCasting(TRB.Data.spells.icefury)
					elseif currentSpellId == TRB.Data.spells.chainLightning.id or currentSpellId == TRB.Data.spells.lavaBeam.id then 
						local spell = nil
						if currentSpellId == TRB.Data.spells.lavaBeam.id then
							spell = TRB.Data.spells.lavaBeam
						else
							spell = TRB.Data.spells.chainLightning
						end
						FillSnapshotDataCasting(spell)
						
						local currentTime = GetTime()
						local down, up, lagHome, lagWorld = GetNetStats()
						local latency = lagWorld / 1000

						if TRB.Data.snapshotData.chainLightning.hitTime == nil then
							TRB.Data.snapshotData.chainLightning.targetsHit = 1
							TRB.Data.snapshotData.chainLightning.hitTime = currentTime
							TRB.Data.snapshotData.chainLightning.hasStruckTargets = false
						elseif currentTime > (TRB.Data.snapshotData.chainLightning.hitTime + (TRB.Functions.GetCurrentGCDTime(true) * 3) + latency) then
							TRB.Data.snapshotData.chainLightning.targetsHit = 0
						end

						TRB.Data.snapshotData.casting.resourceRaw = spell.maelstrom * TRB.Data.snapshotData.chainLightning.targetsHit
						TRB.Data.snapshotData.casting.resourceFinal = spell.maelstrom * TRB.Data.snapshotData.chainLightning.targetsHit
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 3 then	
				if currentSpellName == nil then
					TRB.Functions.ResetCastingSnapshotData()
					return false
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.GetSpellManaCost(spellId) * TRB.Data.character.effects.overgrowthSeedlingModifier * TRB.Data.character.torghast.rampaging.spellCostModifier

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

	local function UpdateIcefury()
		if TRB.Data.snapshotData.icefury.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.icefury.startTime == nil or currentTime > (TRB.Data.snapshotData.icefury.startTime + TRB.Data.spells.icefury.duration) then
				TRB.Data.snapshotData.icefury.stacks = 0
				TRB.Data.snapshotData.icefury.startTime = nil
				TRB.Data.snapshotData.icefury.astralPower = 0
				TRB.Data.snapshotData.icefury.isActive = false
			end
		end
	end

	local function UpdateStormkeeper()
		_, _, TRB.Data.snapshotData.stormkeeper.stacks, _, TRB.Data.snapshotData.stormkeeper.duration, TRB.Data.snapshotData.stormkeeper.endTime, _, _, _, TRB.Data.snapshotData.stormkeeper.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.stormkeeper.id)
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
	end

	local function UpdateSnapshot_Elemental()
		UpdateSnapshot()

		local currentTime = GetTime()
		UpdateIcefury()

		if IsInJailersTower() then
			TRB.Data.character.torghast.rampaging.spellCostModifier = 1
			-- Doesn't change ability costs for Maelstrom abilities.
			_, TRB.Data.character.torghast.rampaging.coolDownReduction = TRB.Functions.GetRampagingBuff()
		else
			TRB.Data.character.torghast.rampaging.spellCostModifier = 1
			TRB.Data.character.torghast.rampaging.coolDownReduction = 1
		end
		

		TRB.Data.character.earthShockThreshold = 60 * TRB.Data.character.effects.overgrowthSeedlingModifier * TRB.Data.character.torghast.rampaging.spellCostModifier
		
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShock then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.flameShock.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining = expiration - currentTime
				end
			end
		end

		if TRB.Data.character.torghast.depletedTeslaCoil then
			UpdateStormkeeper()
		end
	end

	local function UpdateSnapshot_Restoration()
		UpdateSnapshot()
		UpdateSymbolOfHope()
		UpdatePotionOfSpiritualClarity()
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
		TRB.Data.snapshotData.potion.startTime, TRB.Data.snapshotData.potion.duration, _ = GetItemCooldown(TRB.Data.character.items.potions.potionOfSpiritualClarity.id)
		if TRB.Data.snapshotData.potion.startTime > 0 and TRB.Data.snapshotData.potion.duration > 0 then
			TRB.Data.snapshotData.potion.onCooldown = true
		else
			TRB.Data.snapshotData.potion.onCooldown = false
		end
				
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShock then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.flameShock.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining = expiration - currentTime
				end
			end
		end
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or GetSpecialization() ~= 1 or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.elemental.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.elemental.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.elemental.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.shaman.elemental.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 3 then
			if not TRB.Data.settings.core.experimental.specs.shaman.restoration or
				not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.restoration.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.restoration.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.restoration.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.shaman.restoration.displayBar.neverShow == true then
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

		if specId == 1 then
			UpdateSnapshot_Elemental()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.shaman.elemental, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.shaman.elemental.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0

					if TRB.Data.settings.shaman.elemental.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.borderOvercap, true))

						if TRB.Data.settings.shaman.elemental.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.shaman.elemental.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.elemental, resourceFrame, TRB.Data.snapshotData.resource)

					if CastingSpell() and TRB.Data.settings.shaman.elemental.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.elemental, castingFrame, castingBarValue)

					if TRB.Data.settings.shaman.elemental.bar.showPassive then
						if TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0 then
							passiveBarValue = TRB.Data.snapshotData.echoingShock.spell.maelstrom + castingBarValue
						else
							passiveBarValue = castingBarValue
						end
					else
						passiveBarValue = castingBarValue
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.elemental, passiveFrame, passiveBarValue)

					if TRB.Data.settings.shaman.elemental.thresholds.earthShock.enabled then
						resourceFrame.thresholds[1]:Show()
					else
						resourceFrame.thresholds[1]:Hide()
					end

					local thresholdColor = TRB.Data.settings.shaman.elemental.colors.threshold.under

					if TRB.Data.snapshotData.resource >= TRB.Data.character.earthShockThreshold then
						resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.earthShock, true))
						thresholdColor = TRB.Data.settings.shaman.elemental.colors.threshold.over
						if TRB.Data.settings.shaman.elemental.colors.bar.flashEnabled then
							TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.shaman.elemental.colors.bar.flashAlpha, TRB.Data.settings.shaman.elemental.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if TRB.Data.settings.shaman.elemental.audio.esReady.enabled and TRB.Data.snapshotData.audio.playedEsCue == false then
							TRB.Data.snapshotData.audio.playedEsCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.shaman.elemental.audio.esReady.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						thresholdColor = TRB.Data.settings.shaman.elemental.colors.threshold.under
						barContainerFrame:SetAlpha(1.0)
						resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.base, true))
						TRB.Data.snapshotData.audio.playedEsCue = false
					end

					if TRB.Data.snapshotData.echoesOfGreatSundering.isActive then
						thresholdColor = TRB.Data.settings.shaman.elemental.colors.threshold.echoesOfGreatSundering
					end

	---@diagnostic disable-next-line: undefined-field
					resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))---@diagnostic disable-next-line: undefined-field
	---@diagnostic disable-next-line: undefined-field
					resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(thresholdColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.shaman.elemental, refreshText)
		elseif specId == 3 then
			UpdateSnapshot_Restoration()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.shaman.restoration, TRB.Frames.barContainerFrame)
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.shaman.restoration.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local barBorderColor = TRB.Data.settings.shaman.restoration.colors.bar.border

					if TRB.Data.spells.innervate.isActive and TRB.Data.settings.shaman.restoration.colors.bar.innervateBorderChange then
						barBorderColor = TRB.Data.settings.shaman.restoration.colors.bar.innervate

						if TRB.Data.settings.shaman.restoration.audio.innervate.enabled and TRB.Data.snapshotData.audio.innervateCue == false then
							TRB.Data.snapshotData.audio.innervateCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.shaman.restoration.audio.innervate.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, resourceFrame, currentMana)

					if CastingSpell() and TRB.Data.settings.shaman.restoration.bar.showCasting  then
						castingBarValue = currentMana + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentMana
					end

					TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, castingFrame, castingBarValue)

					local potionCooldownThreshold = 0
					local potionThresholdColor = TRB.Data.settings.shaman.restoration.colors.threshold.over
					if TRB.Data.snapshotData.potion.onCooldown then
						if TRB.Data.settings.shaman.restoration.thresholds.potionCooldown.enabled then
							if TRB.Data.settings.shaman.restoration.thresholds.potionCooldown.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								potionCooldownThreshold = gcd * TRB.Data.settings.shaman.restoration.thresholds.potionCooldown.gcdsMax
							elseif TRB.Data.settings.shaman.restoration.thresholds.potionCooldown.mode == "time" then
								potionCooldownThreshold = TRB.Data.settings.shaman.restoration.thresholds.potionCooldown.timeMax
							end
						end
					end

					if not TRB.Data.snapshotData.potion.onCooldown or (potionCooldownThreshold > math.abs(TRB.Data.snapshotData.potion.startTime + TRB.Data.snapshotData.potion.duration - currentTime))then
						if TRB.Data.snapshotData.potion.onCooldown then
							potionThresholdColor = TRB.Data.settings.shaman.restoration.colors.threshold.unusable
						end
						local poscTotal = CalculateManaGain(TRB.Data.character.items.potions.potionOfSpiritualClarity.mana, true) + (TRB.Data.spells.potionOfSpiritualClarity.duration * TRB.Data.snapshotData.manaRegen)
						if TRB.Data.settings.shaman.restoration.thresholds.potionOfSpiritualClarity.enabled and (castingBarValue + poscTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (castingBarValue + poscTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[1].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[1]:Show()
						else
							TRB.Frames.resourceFrame.thresholds[1]:Hide()
						end

						local srpTotal = CalculateManaGain(TRB.Data.character.items.potions.spiritualRejuvenationPotion.mana, true)
						if TRB.Data.settings.shaman.restoration.thresholds.spiritualRejuvenationPotion.enabled and (castingBarValue + srpTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.resourceFrame.thresholds[2], resourceFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (castingBarValue + srpTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[2].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[2]:Show()
						else
							TRB.Frames.resourceFrame.thresholds[2]:Hide()
						end

						local smpTotal = CalculateManaGain(TRB.Data.character.items.potions.spiritualManaPotion.mana, true)
						if TRB.Data.settings.shaman.restoration.thresholds.spiritualManaPotion.enabled and (castingBarValue + smpTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.resourceFrame.thresholds[3], resourceFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (castingBarValue + smpTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[3].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
							TRB.Frames.resourceFrame.thresholds[3]:Show()
						else
							TRB.Frames.resourceFrame.thresholds[3]:Hide()
						end

						local sompTotal = CalculateManaGain(TRB.Data.character.items.potions.soulfulManaPotion.mana, true)
						if TRB.Data.settings.shaman.restoration.thresholds.soulfulManaPotion.enabled and (castingBarValue + sompTotal) < TRB.Data.character.maxResource then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.resourceFrame.thresholds[4], resourceFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (castingBarValue + sompTotal), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
---@diagnostic disable-next-line: undefined-field
							TRB.Frames.resourceFrame.thresholds[4].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(potionThresholdColor, true))
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
					if TRB.Data.settings.shaman.restoration.bar.showPassive then
						if TRB.Data.snapshotData.potionOfSpiritualClarity.isActive then
							passiveValue = passiveValue + TRB.Data.snapshotData.potionOfSpiritualClarity.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.threshold.mindbender, true))
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
								TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.passiveFrame.thresholds[3], passiveFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.threshold.mindbender, true))
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
								TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.threshold.mindbender, true))
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
								TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.restoration, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, TRB.Data.settings.shaman.restoration.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.threshold.mindbender, true))
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
						--TRB.Frames.passiveFrame.thresholds[5]:Hide()
					end

					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.bar.spending, true))
						else
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.bar.passive, true))
						end
					else
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.restoration, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.restoration.colors.bar.passive, true))
					end

					local resourceBarColor = nil

					resourceBarColor = TRB.Data.settings.shaman.restoration.colors.bar.base

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(resourceBarColor, true))
				end

				TRB.Functions.UpdateResourceBar(TRB.Data.settings.shaman.restoration, refreshText)
			end
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 3 then
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
				if specId == 3 then -- Let's check raid effect mana stuff
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
				end
			end

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 then
					if spellId == TRB.Data.spells.chainLightning.id or spellId == TRB.Data.spells.lavaBeam.id then
						if type == "SPELL_DAMAGE" then
							if TRB.Data.snapshotData.chainLightning.hitTime == nil or currentTime > (TRB.Data.snapshotData.chainLightning.hitTime + 0.1) then --This is a new hit
								TRB.Data.snapshotData.chainLightning.targetsHit = 0
							end
							TRB.Data.snapshotData.chainLightning.targetsHit = TRB.Data.snapshotData.chainLightning.targetsHit + 1
							TRB.Data.snapshotData.chainLightning.hitTime = currentTime
							TRB.Data.snapshotData.chainLightning.hasStruckTargets = true
						end
					elseif spellId == TRB.Data.spells.icefury.id then
						if type == "SPELL_AURA_APPLIED" then -- Icefury
							TRB.Data.snapshotData.icefury.isActive = true
							TRB.Data.snapshotData.icefury.stacks = TRB.Data.spells.icefury.stacks
							TRB.Data.snapshotData.icefury.maelstrom = TRB.Data.snapshotData.icefury.stacks * TRB.Data.spells.frostShock.maelstrom
							TRB.Data.snapshotData.icefury.startTime = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.icefury.isActive = false
							TRB.Data.snapshotData.icefury.stacks = 0
							TRB.Data.snapshotData.icefury.maelstrom = 0
							TRB.Data.snapshotData.icefury.startTime = nil
						elseif type == "SPELL_AURA_REMOVED_DOSE" then
							TRB.Data.snapshotData.icefury.stacks = TRB.Data.snapshotData.icefury.stacks - 1
							TRB.Data.snapshotData.icefury.maelstrom = TRB.Data.snapshotData.icefury.stacks * TRB.Data.spells.frostShock.maelstrom
						end
					elseif spellId == TRB.Data.spells.stormkeeper.id then
						if type == "SPELL_AURA_APPLIED" then -- Stormkeeper
							TRB.Data.snapshotData.stormkeeper.isActive = true
							UpdateStormkeeper()
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.stormkeeper.isActive = false
							UpdateStormkeeper()
						elseif type == "SPELL_AURA_REMOVED_DOSE" then
							UpdateStormkeeper()
						end
					elseif spellId == TRB.Data.spells.surgeOfPower.id then
						if type == "SPELL_AURA_APPLIED" then -- Surge of Power
							TRB.Data.spells.surgeOfPower.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.spells.surgeOfPower.isActive = false
						end
					elseif spellId == TRB.Data.spells.echoingShock.id then
						if type == "SPELL_AURA_APPLIED" then -- Echoing Shock
							TRB.Data.snapshotData.echoingShock.isActive = true
						end
					elseif spellId == TRB.Data.spells.echoesOfGreatSundering.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.echoesOfGreatSundering.isActive = true
							_, _, _, _, TRB.Data.snapshotData.echoesOfGreatSundering.duration, TRB.Data.snapshotData.echoesOfGreatSundering.endTime, _, _, _, TRB.Data.snapshotData.echoesOfGreatSundering.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.echoesOfGreatSundering.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.echoesOfGreatSundering.isActive = false
							TRB.Data.snapshotData.echoesOfGreatSundering.spellId = nil
							TRB.Data.snapshotData.echoesOfGreatSundering.duration = 0
							TRB.Data.snapshotData.echoesOfGreatSundering.endTime = nil
						end
					end

					if type == "SPELL_CAST_SUCCESS" and TRB.Data.snapshotData.echoingShock.isActive and spellId ~= TRB.Data.spells.echoingShock.id then
						local spell = nil

						if spellId == TRB.Data.spells.lightningBolt.id then
							spell = TRB.Data.spells.lightningBolt
						elseif spellId == TRB.Data.spells.lavaBurst.id then
							spell = TRB.Data.spells.lavaBurst
						elseif spellId == TRB.Data.spells.elementalBlast.id then
							spell = TRB.Data.spells.elementalBlast
						elseif spellId == TRB.Data.spells.icefury.id then
							spell = TRB.Data.spells.icefury
						elseif spellId == TRB.Data.spells.chainLightning.id then
							spell = TRB.Data.spells.chainLightning
						elseif spellId == TRB.Data.spells.lavaBeam.id then 
							spell = TRB.Data.spells.lavaBeam
						end

						if InitializeTarget(destGUID) then
							TRB.Data.snapshotData.targetData.targets[destGUID].echoingShockSpell = spell
							TRB.Data.snapshotData.targetData.targets[destGUID].echoingShockExpiration = currentTime + TRB.Data.character.talents.echoingShock.duration - TRB.Functions.GetLatency()
							TRB.Data.snapshotData.echoingShock.isActive = false
							TRB.Data.snapshotData.echoingShock.spell = spell
						end
					end
				elseif specId == 3 then
					if spellId == TRB.Data.spells.symbolOfHope.id then
						if type == "SPELL_AURA_REMOVED" then -- Lost Symbol of Hope
							-- Let UpdateSymbolOfHope() clean this up
							UpdateSymbolOfHope(true)
						end
					elseif spellId == TRB.Data.spells.potionOfSpiritualClarity.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Spiritual Clarity
							TRB.Data.snapshotData.potionOfSpiritualClarity.isActive = true
							TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining = TRB.Data.spells.potionOfSpiritualClarity.ticks
							TRB.Data.snapshotData.potionOfSpiritualClarity.mana = TRB.Data.snapshotData.potionOfSpiritualClarity.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfSpiritualClarity.mana, true)
							TRB.Data.snapshotData.potionOfSpiritualClarity.endTime = currentTime + TRB.Data.spells.potionOfSpiritualClarity.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Spiritual Clarity channel
							-- Let UpdatePotionOfSpiritualClarity() clean this up
							UpdatePotionOfSpiritualClarity(true)
						end
					end
				end

				-- Spec agnostic abilities				
				if spellId == TRB.Data.spells.flameShock.id then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- FS Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].flameShock = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshotData.targetData.flameShock = TRB.Data.snapshotData.targetData.flameShock + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].flameShock = false
							TRB.Data.snapshotData.targetData.targets[destGUID].flameShockRemaining = 0
							TRB.Data.snapshotData.targetData.flameShock = TRB.Data.snapshotData.targetData.flameShock - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
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
		local specId = GetSpecialization()
		if specId == 1 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.shaman.elemental)
			TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.elemental)
			FillSpellData_Elemental()
			TRB.Functions.LoadFromSpecCache(specCache.elemental)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Elemental

			if TRB.Data.barConstructedForSpec ~= "elemental" then
				TRB.Data.barConstructedForSpec = "elemental"
				ConstructResourceBar(TRB.Data.settings.shaman.elemental)
			end
		elseif specId == 2 then
		elseif specId == 3 and TRB.Data.settings.core.experimental.specs.shaman.restoration then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.shaman.restoration)
			TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.restoration)
			FillSpellData_Restoration()
			TRB.Functions.LoadFromSpecCache(specCache.restoration)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration

			if TRB.Data.barConstructedForSpec ~= "restoration" then
				TRB.Data.barConstructedForSpec = "restoration"
				ConstructResourceBar(TRB.Data.settings.shaman.restoration)
			end
		end
		EventRegistration()
	end

	resourceFrame:RegisterEvent("ADDON_LOADED")
	resourceFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local specId = GetSpecialization() or 0
		if classIndexId == 7 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Shaman.LoadDefaultSettings()
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
							TRB.Data.barConstructedForSpec = nil
							TRB.Data.settings.shaman.elemental = TRB.Functions.ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.elemental)
							FillSpellData_Elemental()
							
							if TRB.Data.settings.core.experimental.specs.shaman.restoration then
								TRB.Data.settings.shaman.restoration = TRB.Functions.ValidateLsmValues("Restoration Shaman", TRB.Data.settings.shaman.restoration)
								FillSpellData_Restoration()
							end

							SwitchSpec()
							TRB.Options.Shaman.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							ConstructResourceBar(TRB.Data.settings.shaman[TRB.Data.barConstructedForSpec])
							EventRegistration()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					SwitchSpec()
				end
			end
		end
	end)
end
