local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 13 then --Only do this if we're on a Evoker!
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
		devastation = {
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
		preservation = {
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
		-- Devastation
		specCache.devastation.Global_TwintopResourceBar = {
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

		specCache.devastation.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 10000,
			maxResource2 = 5,
			maxResource2Resource = 0,
			maxResource2ResourceMax = 1000,
			effects = {
			},
			items = {}
		}

		specCache.devastation.spells = {
		}

		specCache.devastation.snapshot.manaRegen = 0
		specCache.devastation.snapshot.audio = {
		}

		specCache.devastation.barTextVariables = {
			icons = {},
			values = {}
		}

		-- Preservation
		specCache.preservation.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				symbolOfHope = 0,
			},
			dots = {
			},
		}

		specCache.preservation.character = {
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

		specCache.preservation.spells = {
			-- Evoker Class Talents		
			
			-- Preservation Spec Talents			
			emeraldCommunion = {
				id = 370960,
				name = "",
				icon = "",
				duration = 5.0, --Hasted
				manaPercent = 0.02,
				ticks = 5
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

		specCache.preservation.snapshot.manaRegen = 0
		specCache.preservation.snapshot.audio = {
			innervateCue = false
		}
		specCache.preservation.snapshot.emeraldCommunion = {
			isActive = false,
			duration = 0,
			endTime = nil,
			spellId = nil,
			firstTickTime = nil,
			previousTickTime = nil,
			ticksRemaining = 0,
			tickRate = 0,
			resourceRaw = 0,
			resourceFinal = 0
		}
		specCache.preservation.snapshot.innervate = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.preservation.snapshot.manaTideTotem = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.preservation.snapshot.symbolOfHope = {
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
		specCache.preservation.snapshot.channeledManaPotion = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.preservation.snapshot.potion = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.preservation.snapshot.potionOfChilledClarity = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.preservation.snapshot.conjuredChillglobe = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.preservation.snapshot.moltenRadiance = {
			isActive = false,
			spellId = nil,
			startTime = nil,
			duration = 0,
			manaPerTick = 0,
			mana = 0
		}

		specCache.preservation.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Devastation()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "evoker", "devastation")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.devastation)
	end

	local function Setup_Preservation()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "evoker", "preservation")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.preservation)
	end

	local function FillSpellData_Devastation()
		Setup_Devastation()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.devastation.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.devastation.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Mana generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },
		}
		specCache.devastation.barTextVariables.values = {
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
			{ variable = "$manaMax", description = "Maximum Mana", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Mana", printInSettings = false, color = false },
			
			{ variable = "$essence", description = "Current Essence", printInSettings = true, color = false },
			{ variable = "$comboPoints", description = "Current Essence", printInSettings = false, color = false },
			{ variable = "$essenceMax", description = "Maximum Essence", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Essence", printInSettings = false, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.devastation.spells = spells
	end

	local function FillSpellData_Preservation()
		Setup_Preservation()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.preservation.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.preservation.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#ec", icon = spells.emeraldCommunion.icon, description = spells.emeraldCommunion.name, printInSettings = true },
			{ variable = "#emeraldCommunion", icon = spells.emeraldCommunion.icon, description = spells.emeraldCommunion.name, printInSettings = false },

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
		specCache.preservation.barTextVariables.values = {
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

			{ variable = "$ecMana", description = "Mana from Emerald Communion", printInSettings = true, color = false },
			{ variable = "$ecTime", description = "Time left on Emerald Communion", printInSettings = true, color = false },
			{ variable = "$ecTicks", description = "Number of ticks left from Emerald Communion", printInSettings = true, color = false },

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

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.preservation.spells = spells
	end

	local function CalculateAbilityResourceValue(resource, threshold)
		local modifier = 1.0

		return resource * modifier
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		
		if specId == 1 then -- Devastation
		elseif specId == 2 then -- Preservation
		end
	end

	local function TargetsCleanup(clearAll)
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshot.targetData
		targetData:Cleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 1 then
			elseif specId == 2 then
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

		if specId == 1 then
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if spell ~= nil and spell.id ~= nil and spell.mana ~= nil and spell.mana < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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
		elseif specId == 2 then
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
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.evoker.preservation)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.evoker.preservation)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.evoker.preservation)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.evoker.preservation)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.evoker.preservation)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.evoker.preservation)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.evoker.preservation)
		end

		
		if (specId == 1 and TRB.Data.settings.core.experimental.specs.evoker.devastation) or
		(specId == 2 and TRB.Data.settings.core.experimental.specs.evoker.preservation) then
			TRB.Frames.resource2ContainerFrame:Show()
			TRB.Functions.Bar:Construct(settings)
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
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

	local function GetMoltenRadianceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.moltenRadiance)
	end
	
	local function GetSymbolOfHopeRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.symbolOfHope)
	end

	local function GetEmeraldCommunionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.emeraldCommunion)
	end

	local function GetPotionOfChilledClarityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.potionOfChilledClarity)
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
		local entries = TRB.Functions.Table:Length(TRB.Data.snapshot.markOfTheCrane.list)
		for x = 1, entries do
			if TRB.Data.snapshot.markOfTheCrane.list[x].guid == guid then
				return x
			end
		end
		return 0
	end

	local function RefreshLookupData_Devastation()
		local _
		local snapshot = TRB.Data.snapshot
		local specSettings = TRB.Data.settings.evoker.devastation
		--Spec specific implementation
		local normalizedMana = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshot.manaRegen, _ = GetPowerRegen()
		local currentManaColor = specSettings.colors.text.current
		--$mana
		local manaPrecision = specSettings.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		----------------------------

		local lookup = TRB.Data.lookup or {}
		lookup["$manaMax"] = TRB.Data.character.maxResource
		lookup["$mana"] = currentMana
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentMana
		lookup["$essence"] = TRB.Data.character.resource2
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$essenceMax"] = TRB.Data.character.maxResource2Raw
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2Raw
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = snapshot.resource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshot.resource
		lookupLogic["$casting"] = snapshot.casting.resourceFinal
		lookupLogic["$essence"] = TRB.Data.character.resource2
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2Raw
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2Raw
		TRB.Data.lookupLogic = lookupLogic
	end

	
	local function RefreshLookupData_Preservation()
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local specSettings = TRB.Data.settings.evoker.preservation
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

		--$ecMana
		local _ecMana = snapshot.emeraldCommunion.resourceFinal
		local ecMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_ecMana, manaPrecision, "floor", true))
		--$ecTicks
		local _ecTicks = snapshot.emeraldCommunion.ticksRemaining or 0
		local ecTicks = string.format("%.0f", _ecTicks)
		--$ecTime
		local _ecTime = GetEmeraldCommunionRemainingTime()
		local ecTime = string.format("%.1f", _ecTime)

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
		local _passiveMana = _ecMana + _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana
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
		Global_TwintopResourceBar.resource.emeraldCommunion = _ecMana or 0
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _channeledMana,
			ticks = snapshot.channeledManaPotion.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = snapshot.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.emeraldCommunion = {
			mana = _ecMana,
			ticks = snapshot.emeraldCommunion.ticksRemaining or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#ec"] = spells.emeraldCommunion.icon
		lookup["#emeraldCommunion"] = spells.emeraldCommunion.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#amp"] = spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
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
		lookup["$ecMana"] = ecMana
		lookup["$ecTime"] = ecTime
		lookup["$ecTicks"] = ecTicks
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
		lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$mrMana"] = mrMana
		lookup["$mrTime"] = mrTime
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		lookup["$essence"] = TRB.Data.character.resource2
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$essenceMax"] = TRB.Data.character.maxResource2Raw
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2Raw
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
		lookupLogic["$ecMana"] = _ecMana
		lookupLogic["$ecTime"] = _ecTime
		lookupLogic["$ecTicks"] = _ecTicks
		lookupLogic["$sohMana"] = _sohMana
		lookupLogic["$sohTime"] = _sohTime
		lookupLogic["$sohTicks"] = _sohTicks
		lookupLogic["$innervateMana"] = _innervateMana
		lookupLogic["$innervateTime"] = _innervateTime
		lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
		lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$mrMana"] = _mrMana
		lookupLogic["$mrTime"] = _mrTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$essence"] = TRB.Data.character.resource2
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2Raw
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2Raw
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
		TRB.Data.snapshot.casting.startTime = currentTime
		TRB.Data.snapshot.casting.resourceRaw = spell.mana
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(spell.mana)
		TRB.Data.snapshot.casting.spellId = spell.id
		TRB.Data.snapshot.casting.icon = spell.icon
	end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshot.casting.resourceRaw)
	end

	local function UpdateCastingResourceFinal_Preservation()
		-- Do nothing for now
		TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceRaw * TRB.Data.snapshot.innervate.modifier * TRB.Data.snapshot.potionOfChilledClarity.modifier
	end

	local function CastingSpell()
		local snapshot = TRB.Data.snapshot
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				--[[if currentSpellName == nil then
					return true
				else]]
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				--end
			elseif specId == 2 then
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.emeraldCommunion.id then
						snapshot.casting.spellId = TRB.Data.spells.emeraldCommunion.id
						snapshot.casting.startTime = currentChannelStartTime / 1000
						snapshot.casting.endTime = currentChannelEndTime / 1000
						snapshot.casting.resourceRaw = 0
						snapshot.casting.icon = TRB.Data.spells.emeraldCommunion.icon
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

						UpdateCastingResourceFinal_Preservation()
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

	local function UpdateEmeraldCommunion(forceCleanup)
		if TRB.Data.snapshot.emeraldCommunion.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or TRB.Data.snapshot.emeraldCommunion.endTime == nil or currentTime > TRB.Data.snapshot.channeledManaPotion.endTime then
				TRB.Data.snapshot.emeraldCommunion.isActive = false
				TRB.Data.snapshot.emeraldCommunion.duration = 0
				TRB.Data.snapshot.emeraldCommunion.endTime = nil
				TRB.Data.snapshot.emeraldCommunion.spellId = nil
				TRB.Data.snapshot.emeraldCommunion.firstTickTime = nil
				TRB.Data.snapshot.emeraldCommunion.previousTickTime = nil
				TRB.Data.snapshot.emeraldCommunion.ticksRemaining = 0
				TRB.Data.snapshot.emeraldCommunion.tickRate = 0
				TRB.Data.snapshot.emeraldCommunion.resourceRaw = 0
				TRB.Data.snapshot.emeraldCommunion.resourceFinal = 0
			else
				local regenRemaining = (TRB.Data.snapshot.emeraldCommunion.endTime - currentTime) * TRB.Data.snapshot.manaRegen
				local incomingMana = (TRB.Data.snapshot.emeraldCommunion.ticksRemaining * TRB.Data.spells.emeraldCommunion.manaPercent * TRB.Data.character.maxResource) + regenRemaining
				TRB.Data.snapshot.emeraldCommunion.resourceRaw = incomingMana
				TRB.Data.snapshot.emeraldCommunion.resourceFinal = CalculateManaGain(TRB.Data.snapshot.emeraldCommunion.resourceRaw, false)
			end
		end
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
			if forceCleanup or TRB.Data.snapshot.symbolOfHope.endTime == nil or currentTime > TRB.Data.snapshot.symbolOfHope.endTime or currentTime > TRB.Data.snapshot.symbolOfHope.firstTickTime + TRB.Data.spells.symbolOfHope.duration or currentTime > TRB.Data.snapshot.symbolOfHope.firstTickTime + (TRB.Data.spells.symbolOfHope.ticks * TRB.Data.snapshot.symbolOfHope.tickRate) then
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
		elseif TRB.Data.snapshot.manaTideTotem.endTime ~= nil then
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

	local function UpdateSnapshot_Devastation()
		UpdateSnapshot()
		
		local currentTime = GetTime()
		local _
	end

	local function UpdateSnapshot_Preservation()
		UpdateSnapshot()
		UpdateSymbolOfHope()
		UpdateChanneledManaPotion()
		UpdateInnervate()
		UpdatePotionOfChilledClarity()
		UpdateManaTideTotem()
		UpdateMoltenRadiance()
		
		local snapshot = TRB.Data.snapshot

		local _

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

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.evoker
		local snapshot = TRB.Data.snapshot

		if specId == 1 then
			local specSettings = classSettings.devastation
			UpdateSnapshot_Devastation()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local barColor = specSettings.colors.bar.base
					local barBorderColor = specSettings.colors.bar.border

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, snapshot.resource)
					TRB.Functions.Bar:SetValue(specSettings, castingFrame, 0, 1)
					TRB.Functions.Bar:SetValue(specSettings, passiveFrame, 0, 1)

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))

					--[[
					local partial = UnitPartialPower("player", Enum.PowerType.Essence) / 1000
					local totalEssence = math.min(partial + snapshot.resource2, TRB.Data.character.maxResource2Raw)
					--print(partial, partial + snapshot.resource2, snapshot.resource2)

					TRB.Frames.resource2Frames[1].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.base, true))
					TRB.Frames.resource2Frames[1].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.border, true))
					TRB.Frames.resource2Frames[1].containerFrame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true))
					TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[1].resourceFrame, totalEssence, TRB.Data.character.maxResource2Raw)
					]]
					
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
						elseif snapshot.resource2+1 == x then
							local partial = UnitPartialPower("player", Enum.PowerType.Essence)
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, partial, 1000)
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
		elseif specId == 2 then
			local specSettings = classSettings.preservation
			UpdateSnapshot_Preservation()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = snapshot.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

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
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[3], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
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

						if snapshot.emeraldCommunion.resourceFinal > 0 then
							passiveValue = passiveValue + snapshot.emeraldCommunion.resourceFinal

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

					resourceBarColor = specSettings.colors.bar.base

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
					
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
--[[
					for x = 2, TRB.Data.character.maxResource2 do
						TRB.Frames.resource2Frames[x]:Hide()
					end]]

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
						elseif snapshot.resource2+1 == x then
							local partial = UnitPartialPower("player", Enum.PowerType.Essence)
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, partial, 1000)
						else
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
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
		local snapshot = TRB.Data.snapshot

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...
			
			if destGUID == TRB.Data.character.guid then
				if specId == 2 and TRB.Data.barConstructedForSpec == "preservation" then -- Let's check raid effect mana stuff
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
							snapshot.moltenRadiance.isActive = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							snapshot.moltenRadiance.isActive = false
							snapshot.moltenRadiance.spellId = nil
							snapshot.moltenRadiance.duration = 0
							snapshot.moltenRadiance.endTime = nil
							snapshot.moltenRadiance.manaPerTick = 0
							snapshot.moltenRadiance.mana = 0
						end
					end
				end
			end			

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "devastation" then --Devastation					
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "preservation" then
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
					elseif spellId == spells.potionOfChilledClarity.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.potionOfChilledClarity)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							snapshot.potionOfChilledClarity.modifier = 0
						elseif type == "SPELL_AURA_REMOVED" then 
							snapshot.potionOfChilledClarity.modifier = 1
						end
					elseif spellId == spells.emeraldCommunion.id then
						if type == "SPELL_PERIODIC_ENERGIZE" then
							if snapshot.emeraldCommunion.firstTickTime == nil then
								TRB.Functions.Aura:SnapshotGenericAura(spellId, nil, TRB.Data.snapshot.metamorphosis)
								snapshot.emeraldCommunion.firstTickTime = currentTime
								snapshot.emeraldCommunion.previousTickTime = currentTime
								snapshot.emeraldCommunion.ticksRemaining = spells.emeraldCommunion.ticks
								snapshot.emeraldCommunion.tickRate = (snapshot.emeraldCommunion.duration / spells.emeraldCommunion.ticks)
							else
								snapshot.emeraldCommunion.previousTickTime = currentTime
								snapshot.emeraldCommunion.ticksRemaining = snapshot.emeraldCommunion.ticksRemaining - 1
							end
							snapshot.emeraldCommunion.resourceRaw = snapshot.emeraldCommunion.ticksRemaining * spells.emeraldCommunion.manaPercent * TRB.Data.character.maxResource
							snapshot.emeraldCommunion.resourceFinal = CalculateManaGain(snapshot.emeraldCommunion.resourceRaw, false)
						elseif type == "SPELL_AURA_REMOVED" then
							-- Let UpdateEmeraldCommunion() handle this
							UpdateEmeraldCommunion(true)
						end
					end
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				---@type TRB.Classes.TargetData
				local targetData = TRB.Data.snapshot.targetData
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
		if specId == 1 and TRB.Data.settings.core.experimental.specs.evoker.devastation then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.evoker.devastation)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.devastation)
			specCache.devastation.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Devastation()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.devastation)
			
			---@type TRB.Classes.TargetData
			TRB.Data.snapshot.targetData = TRB.Classes.TargetData:New()

			TRB.Functions.RefreshLookupData = RefreshLookupData_Devastation

			if TRB.Data.barConstructedForSpec ~= "devastation" then
				TRB.Data.barConstructedForSpec = "devastation"
				ConstructResourceBar(specCache.devastation.settings)
			end
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.evoker.preservation then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.evoker.preservation)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.preservation)
			specCache.preservation.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Preservation()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.preservation)
			
			---@type TRB.Classes.TargetData
			TRB.Data.snapshot.targetData = TRB.Classes.TargetData:New()

			TRB.Functions.RefreshLookupData = RefreshLookupData_Preservation

			if TRB.Data.barConstructedForSpec ~= "preservation" then
				TRB.Data.barConstructedForSpec = "preservation"
				ConstructResourceBar(specCache.preservation.settings)
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
		if classIndexId == 13 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Evoker.LoadDefaultSettings()
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
							TRB.Data.settings.evoker.devastation = TRB.Functions.LibSharedMedia:ValidateLsmValues("Devastation Evoker", TRB.Data.settings.evoker.devastation)
							TRB.Data.settings.evoker.preservation = TRB.Functions.LibSharedMedia:ValidateLsmValues("Preservation Evoker", TRB.Data.settings.evoker.preservation)
							FillSpellData_Devastation()
							FillSpellData_Preservation()

							if TRB.Data.settings.core.experimental.specs.evoker.devastation or TRB.Data.settings.core.experimental.specs.evoker.preservation then
								SwitchSpec()
							end

							TRB.Options.Evoker.ConstructOptionsPanel(specCache)
							
							if TRB.Data.settings.core.experimental.specs.evoker.devastation or TRB.Data.settings.core.experimental.specs.evoker.preservation then
								-- Reconstruct just in case
								if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
									ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
								end
								TRB.Functions.Class:EventRegistration()
							end
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
					if TRB.Data.settings.core.experimental.specs.evoker.devastation or TRB.Data.settings.core.experimental.specs.evoker.preservation then
						SwitchSpec()
					end
				end
			end
		end
	end)
	
	function TRB.Functions.Class:CheckCharacter()
		local spells = TRB.Data.spells
		local specId = GetSpecialization()
		TRB.Functions.Character:CheckCharacter()
		TRB.Data.character.className = "evoker"
		TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
		TRB.Data.character.maxResource2 = 1
		local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
		local settings = nil
		if specId == 1 and TRB.Data.settings.core.experimental.specs.evoker.devastation then
			settings = TRB.Data.settings.evoker.devastation
			TRB.Data.character.specName = "devastation"
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.evoker.preservation then
			settings = TRB.Data.settings.evoker.preservation
			TRB.Data.character.specName = "preservation"
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
		end
		
		if settings ~= nil then
			--[[if maxComboPoints ~= TRB.Data.character.maxResource2Raw then
				TRB.Data.character.maxResource2Raw = maxComboPoints
				TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
			end]]
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
			end
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.evoker.devastation and TRB.Data.settings.core.experimental.specs.evoker.devastation then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.devastation)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.Essence
			TRB.Data.resource2Factor = 1
		elseif specId == 2 and TRB.Data.settings.core.enabled.evoker.preservation and TRB.Data.settings.core.experimental.specs.evoker.preservation then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.preservation)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.Essence
			TRB.Data.resourceFactor = 1
		else -- This should never happen
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

		if specId == 1 and TRB.Data.settings.core.experimental.specs.evoker.devastation then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.evoker.devastation.displayBar.alwaysShow) and (
						(not TRB.Data.settings.evoker.devastation.displayBar.notZeroShow) or
						(TRB.Data.settings.evoker.devastation.displayBar.notZeroShow and snapshot.resource == TRB.Data.character.maxResource and snapshot.resource2 == TRB.Data.character.maxResource2)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshot.isTracking = false
			else
				snapshot.isTracking = true
				if TRB.Data.settings.evoker.devastation.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.evoker.preservation then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.evoker.preservation.displayBar.alwaysShow) and (
						(not TRB.Data.settings.evoker.preservation.displayBar.notZeroShow) or
						(TRB.Data.settings.evoker.preservation.displayBar.notZeroShow and snapshot.resource == TRB.Data.character.maxResource and snapshot.resource2 == TRB.Data.character.maxResource2)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshot.isTracking = false
			else
				snapshot.isTracking = true
				if TRB.Data.settings.evoker.preservation.displayBar.neverShow == true then
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

		local specId = GetSpecialization()
		
		if guid ~= nil and guid ~= "" then
			---@type TRB.Classes.TargetData
			local targetData = TRB.Data.snapshot.targetData
			if not targetData:CheckTargetExists(guid) then
				targetData:InitializeTarget(guid)
				if specId == 1 then
				elseif specId == 2 then
				end
			end
			TRB.Data.snapshot.targetData.targets[guid].lastUpdate = GetTime()
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
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.evoker.devastation
		elseif specId == 2 then
			settings = TRB.Data.settings.evoker.preservation
		end

		if specId == 1 then --Devastation
			if var == "$casting" then
				if snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0 then
					valid = true
				end
			--[[elseif var == "$passive" then
				if snapshot.resource < TRB.Data.character.maxResource and
					settings.generation.enabled and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end]]
			elseif var == "$resource" or var == "$mana" then
				if snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$manaMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$manaTotal" then
				if snapshot.resource > 0 or
					(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
				if snapshot.resource > 0 or
					(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0) then
					valid = true
				end
			--[[elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
				if snapshot.resource > 0 then
					valid = true
				end]]
			elseif var == "$regen" or var == "$regenMana" or var == "$manaRegen" then
				if snapshot.resource < TRB.Data.character.maxResource and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$comboPoints" or var == "$essence" then
				valid = true
			elseif var == "$comboPointsMax"or var == "$essenceMax" then
				valid = true
			end
		elseif specId == 2 then --Preservation
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
					TRB.Functions.Class:IsValidVariableForSpec("$ecMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
					valid = true
				end
			elseif var == "$ecMana" then
				if snapshot.emeraldCommunion.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$ecTime" then
				if snapshot.emeraldCommunion.isActive then
					valid = true
				end
			elseif var == "$ecTicks" then
				if snapshot.emeraldCommunion.isActive then
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
			end
		end

		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if (specId ~= 1 and specId ~= 2) or
			(specId == 1 and not TRB.Data.settings.core.experimental.specs.evoker.devastation) or
			(specId == 2 and not TRB.Data.settings.core.experimental.specs.evoker.preservation) then
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