local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 4 then --Only do this if we're on a Rogue!
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
		assassination = {
			snapshotData = {},
			barTextVariables = {}
		},
		outlaw = {
			snapshotData = {},
			barTextVariables = {}
		},
		subtlety = {
			snapshotData = {},
			barTextVariables = {}
		}
	}

	local function FillSpecCache()
		-- Assassination
		specCache.assassination.Global_TwintopResourceBar = {
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

		specCache.assassination.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
            maxResource2 = 5,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
			talents = {
				blindside = {
					isSelected = false
				},
				subterfuge = {
					isSelected = false
				},
				internalBleeding = {
					isSelected = false
				},
				exsanguinate = {
					isSelected = false
				},
				hiddenBlades = {
					isSelected = false
				},
				crimsonTempest = {
					isSelected = false
				}
			},
			items = {
				tinyToxicBlade = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.assassination.spells = {
			-- Poisons
			cripplingPoison = {
				id = 3409,
				name = "",
				icon = ""
			},
			deadlyPoison = {
				id = 2818,
				name = "",
				icon = ""
			},
			numbingPoison = {
				id = 5760,
				name = "",
				icon = ""
			},
			woundPoison = {
				id = 8680,
				name = "",
				icon = ""
			},

			-- Rogue Class Abilities
            ambush = {
				id = 8676,
				name = "",
				icon = "",
				energy = -50,
                comboPointsGenerated = 2,
                stealth = true,
				thresholdId = 1,
				settingKey = "ambush",
                --isSnowflake = true,
				thresholdUsable = false
			},
			cheapShot = {
				id = 1833,
				name = "",
				icon = "",
				energy = -40,
                comboPointsGenerated = 1,
                stealth = true,
				thresholdId = 2,
				settingKey = "cheapShot",
				--isSnowflake = false,
				thresholdUsable = false
			},
			crimsonVial = {
				id = 185311,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 0,
				thresholdId = 3,
				settingKey = "crimsonVial",
				hasCooldown = true,
                cooldown = 30,
				thresholdUsable = false
			},
			distract = {
				id = 1725,
				name = "",
				icon = "",
				energy = -30,
                comboPointsGenerated = 0,
				thresholdId = 4,
				settingKey = "distract",
				hasCooldown = true,
                cooldown = 30,
				thresholdUsable = false
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
				thresholdId = 5,
				settingKey = "feint",
                hasCooldown = true,
                cooldown = 15,
				thresholdUsable = false
			},
			kidneyShot = {
				id = 408,
				name = "",
				icon = "",
				energy = -25,
                comboPoints = true,
				thresholdId = 6,
				settingKey = "kidneyShot",
                hasCooldown = true,
                cooldown = 20,
				thresholdUsable = false
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 0,
                stealth = true,
				thresholdId = 7,
				settingKey = "sap",
				thresholdUsable = false
			},
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 1,
				thresholdId = 8,
				settingKey = "shiv",
                hasCooldown = true,
				isSnowflake = true,
                cooldown = 25,
				thresholdUsable = false,
				idLegendaryBonus = 7112
			},
			sliceAndDice = {
				id = 315496,
				name = "",
				icon = "",
				energy = -25,
                comboPoints = true,
				thresholdId = 9,
				settingKey = "sliceAndDice",
                hasCooldown = false,
				thresholdUsable = false,
				pandemicTimes = {
					12 * 0.3, -- 0 CP, show same as if we had 1
					12 * 0.3,
					18 * 0.3,
					24 * 0.3,
					30 * 0.3,
					36 * 0.3,
					42 * 0.3
				}
			},

            -- Assassination Spec Abilities

			envenom = {
				id = 32645,
				name = "",
				icon = "",
				energy = -35,
                comboPoints = true,
				thresholdId = 10,
				settingKey = "envenom",
                hasCooldown = false,
				thresholdUsable = false
			},
			fanOfKnives = {
				id = 51723,
				name = "",
				icon = "",
				energy = -35,
                comboPointsGenerated = 1,
				thresholdId = 11,
				settingKey = "fanOfKnives",
                hasCooldown = false,
				thresholdUsable = false
			},
			garrote = {
				id = 703,
				name = "",
				icon = "",
				energy = -45,
                comboPointsGenerated = 1,
				thresholdId = 12,
				settingKey = "garrote",
                hasCooldown = true,
                cooldown = 6,
				thresholdUsable = false,
				pandemicTime = 18 * 0.3
			},
			mutilate = {
				id = 1329,
				name = "",
				icon = "",
				energy = -50,
                comboPointsGenerated = 2,
				thresholdId = 13,
				settingKey = "mutilate",
                hasCooldown = false,
				thresholdUsable = false
			},
			poisonedKnife = {
				id = 185565,
				name = "",
				icon = "",
				energy = -40,
                comboPointsGenerated = 1,
				thresholdId = 14,
				settingKey = "poisonedKnife",
                hasCooldown = false,
				thresholdUsable = false
			},
			rupture = {
				id = 1943,
				name = "",
				icon = "",
				energy = -25,
                comboPoints = true,
				thresholdId = 15,
				settingKey = "rupture",
                hasCooldown = false,
				thresholdUsable = false,
				pandemicTimes = {
					8 * 0.3, -- 0 CP, show same as if we had 1
					8 * 0.3,
					12 * 0.3,
					16 * 0.3,
					20 * 0.3,
					24 * 0.3,
					28 * 0.3,
					32 * 0.3, -- 7 CP Kyrian ability buff
				}
			},
			vendetta = {
				id = 79140,
				name = "",
				icon = "",
				energy = 60,
                duration = 3
			},

			-- Talents
			blindside = {
				id = 121153,
				name = "",
				icon = "",
				duration = 10,
				isActive = false,
			},
			subterfuge = {
				id = 115192,
				name = "",
				icon = "",
				isActive = false
			},
			internalBleeding = {
				id = 154953,
				name = "",
				icon = ""
			},
			exsanguinate = {
				id = 200806,
				name = "",
				icon = "",
				energy = -25,
				thresholdId = 16,
				settingKey = "exsanguinate",
				hasCooldown = true,
				isTalent = true,
				isSnowflake = true,
				thresholdUsable = false,
				cooldown = 45
			},
			hiddenBlades = {
				id = 270061,
				name = "",
				icon = ""
			},
			crimsonTempest = {
				id = 121411,
				name = "",
				icon = "",
				energy = -35,
				comboPoints = true,
				thresholdId = 17,
				settingKey = "crimsonTempest",
				hasCooldown = false,
				isTalent = true,
				thresholdUsable = false,
				pandemicTimes = {
					4 * 0.3, -- 0 CP, show same as if we had 1
					4 * 0.3,
					6 * 0.3,
					8 * 0.3,
					10 * 0.3,
					12 * 0.3,
					14 * 0.3,
					16 * 0.3, -- Kyrian ability buff
				}
			},

			-- Covenants
			echoingReprimand = { -- Kyrian
				id = 323547,
				name = "",
				icon = "",
				energy = -10,
				comboPointsGenerated = 2,
				thresholdId = 18,
				settingKey = "echoingReprimand",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				isActive = false,
				cooldown = 45,
				buffId = {
					323558, -- 2
					323559, -- 3
					323560, -- 4
					354835, -- 4
					354838, -- 5
				}
			},
			sepsis = { -- Night Fae
				id = 328305,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				thresholdId = 19,
				settingKey = "sepsis",
				hasCooldown = true,
				isSnowflake = true,
				cooldown = 90,
				buffId = 347037,
				isActive = false
			},
			adrenalineRush = {
				id = 13750,
				name = "",
				icon = "",
			},
			serratedBoneSpike = {
				id = 328547,
				name = "",
				icon = "",
				energy = -15,
				comboPointsGenerated = 2,
				thresholdId = 20,
				settingKey = "serratedBoneSpike",
				hasCooldown = true,
				isSnowflake = true,
				debuffId = 324073
			},
			flagellation = {
				id = 323654,
				name = "",
				icon = ""
			},

			-- PvP
			deathFromAbove = {
				id = 269513,
				name = "",
				icon = "",
				energy = -25,
				thresholdId = 21,
				settingKey = "deathFromAbove",
				comboPoints = true,
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 30
			},
			dismantle = {
				id = 207777,
				name = "",
				icon = "",
				energy = -25,
				thresholdId = 22,
				settingKey = "dismantle",
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 45
			},
		}

		specCache.assassination.snapshotData.energyRegen = 0
		specCache.assassination.snapshotData.comboPoints = 0
		specCache.assassination.snapshotData.audio = {
			overcapCue = false
		}
		specCache.assassination.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			--Bleeds
			garrote = 0,
			rupture = 0,
			internalBleeding = 0,
			crimsonTempest = 0,
			--Poisons
			deadlyPoison = 0,
			cripplingPoison = 0,
			woundPoison = 0,
			numbingPoison = 0,
			--Covenant
			serratedBoneSpike = 0,
			targets = {}
		}
		specCache.assassination.snapshotData.crimsonVial = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.distract = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.feint = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.kidneyShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.shiv = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.garrote = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.exsanguinate = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.blindside = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.assassination.snapshotData.sliceAndDice = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}

		specCache.assassination.snapshotData.echoingReprimand = {
			startTime = nil,
			duration = 0,
		}
		for x = 1, 6 do -- 1 and 6 CPs doesn't get it, but including it just in case it gets added/changed
			specCache.assassination.snapshotData.echoingReprimand[x] = {
				endTime = nil,
				duration = 0,
				enabled = false,
				comboPoints = 0
			}
		end
		
		specCache.assassination.snapshotData.sepsis = {
			startTime = nil,
			endTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.serratedBoneSpike = {
			isActive = false,
			-- Charges
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.assassination.snapshotData.deathFromAbove = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshotData.dismantle = {
			startTime = nil,
			duration = 0,
			enabled = false
		}

		specCache.assassination.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Assassination()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.assassination)
	end

	local function FillSpellData_Assassination()
		Setup_Assassination()
		local spells = TRB.Functions.FillSpellData(specCache.assassination.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.assassination.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#blindside", icon = spells.blindside.icon, description = spells.blindside.name, printInSettings = true },
			{ variable = "#covenantAbility", icon = spells.echoingReprimand.icon .. spells.flagellation.icon .. spells.sepsis.icon .. spells.serratedBoneSpike.icon, description = "Covenant on-use Ability", printInSettings = true},
			{ variable = "#crimsonTempest", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = true },
			{ variable = "#ct", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = false },
			{ variable = "#cripplingPoison", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = true },
			{ variable = "#cp", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = false },
			{ variable = "#deadlyPoison", icon = spells.deadlyPoison.icon, description = spells.deadlyPoison.name, printInSettings = true },
			{ variable = "#dp", icon = spells.deadlyPoison.icon, description = spells.deadlyPoison.name, printInSettings = false },
			{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
			{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
			{ variable = "#echoingReprimand", icon = spells.echoingReprimand.icon, description = spells.echoingReprimand.name, printInSettings = true },
			{ variable = "#garrote", icon = spells.garrote.icon, description = spells.garrote.name, printInSettings = true },
			{ variable = "#internalBleeding", icon = spells.internalBleeding.icon, description = spells.internalBleeding.name, printInSettings = true },
			{ variable = "#ib", icon = spells.internalBleeding.icon, description = spells.internalBleeding.name, printInSettings = false },
			{ variable = "#numbingPoison", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = true },
			{ variable = "#np", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = false },
			{ variable = "#rupture", icon = spells.rupture.icon, description = spells.rupture.name, printInSettings = true },
			{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
			{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
			{ variable = "#sepsis", icon = spells.sepsis.icon, description = spells.sepsis.name, printInSettings = true },
			{ variable = "#serratedBoneSpike", icon = spells.serratedBoneSpike.icon, description = spells.serratedBoneSpike.name, printInSettings = true },
			{ variable = "#woundPoison", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = true },
			{ variable = "#wp", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = false },
        }
		specCache.assassination.barTextVariables.values = {
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
			
			{ variable = "$sadTime", description = "Time remaining on Slice and Dice buff", printInSettings = true, color = false },
			{ variable = "$sliceAndDiceTime", description = "Time remaining on Slice and Dice buff", printInSettings = false, color = false },

			-- Bleeds
			{ variable = "$isBleeding", description = "Does your current target have a bleed active on it? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$ctCount", description = "Number of Crimson Tempest bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$crimsonTempestCount", description = "Number of Crimson Tempest bleeds active on targets", printInSettings = false, color = false },
			{ variable = "$ctTime", description = "Time remaining on Crimson Tempest on your current target", printInSettings = true, color = false },
			{ variable = "$crimsonTempestTime", description = "Time remaining on Crimson Tempest on your current target", printInSettings = false, color = false },

			{ variable = "$garroteCount", description = "Number of Garrote bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$garroteTime", description = "Time remaining on Garrote on your current target", printInSettings = true, color = false },

			{ variable = "$ibCount", description = "Number of Internal Bleeding bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$internalBleedingCount", description = "Number of Internal Bleeding bleeds active on targets", printInSettings = false, color = false },
			{ variable = "$ibTime", description = "Time remaining on Internal Bleeding on your current target", printInSettings = true, color = false },
			{ variable = "$internalBleedingTime", description = "Time remaining on Internal Bleeding on your current target", printInSettings = false, color = false },

			{ variable = "$ruptureCount", description = "Number of Rupture bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$ruptureTime", description = "Time remaining on Rupture on your current target", printInSettings = true, color = false },
		
			{ variable = "$sbsCount", description = "Number of Serrated Bone Spike bleeds active on targets (if |cFF40BF40Necrolord|r)", printInSettings = true, color = false },
			{ variable = "$serratedBoneSpikeCount", description = "Number of Serrated Bone Spike bleeds active on targets (if |cFF40BF40Necrolord|r)", printInSettings = false, color = false },

			-- Poisons
			{ variable = "$cpCount", description = "Number of Crippling Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonCount", description = "Number of Crippling Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$cpTime", description = "Time remaining on Crippling Poison on your current target", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonTime", description = "Time remaining on Crippling Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$dpCount", description = "Number of Deadly Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonCount", description = "Number of Deadly Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$dpTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$npCount", description = "Number of Numbing Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$numbingPoisonCount", description = "Number of Numbing Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$npTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = true, color = false },
			{ variable = "$numbingPoisonTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = false, color = false },

			{ variable = "$wpCount", description = "Number of Wound Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$woundPoisonCount", description = "Number of Wound Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$wpTime", description = "Time remaining on Wound Poison on your current target", printInSettings = true, color = false },
			{ variable = "$woundPoisonTime", description = "Time remaining on Wound Poison on your current target", printInSettings = false, color = false },

			-- Proc
			{ variable = "$blindsideTime", description = "Time remaining on Blindside proc", printInSettings = true, color = false },


			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.assassination.spells = spells
	end

	local function CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "rogue"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
        local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
        local settings = nil

		if specId == 1 then
            settings = TRB.Data.settings.rogue.assassination
			TRB.Data.character.specName = "assassination"
			TRB.Data.character.talents.blindside.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.subterfuge.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.internalBleeding.isSelected = select(4, GetTalentInfo(5, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.exsanguinate.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.hiddenBlades.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.crimsonTempest.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))
			
			-- Legendaries
			local waistItemLink = GetInventoryItemLink("player", 6)
			local feetItemLink = GetInventoryItemLink("player", 8)

			local tinyToxicBlade = false
			if waistItemLink ~= nil then
				tinyToxicBlade = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(waistItemLink, 172320, TRB.Data.spells.shiv.idLegendaryBonus)
			end

			if tinyToxicBlade == false and waistItemLink ~= nil then
				tinyToxicBlade = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(feetItemLink, 173244, TRB.Data.spells.shiv.idLegendaryBonus)
			end
			TRB.Data.character.items.tinyToxicBlade = tinyToxicBlade			
		end

        
        if settings ~= nil then
			TRB.Data.character.isPvp = TRB.Functions.ArePvpTalentsActive()
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
            	TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
			end
        end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.rogue.assassination == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
			TRB.Data.specSupported = true
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
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.ComboPoints
			TRB.Data.resource2Factor = 1

            CheckCharacter()

			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		end
		TRB.Functions.HideResourceBar()
	end
	TRB.Functions.EventRegistration = EventRegistration

	local function IsTargetBleeding(guid)
		if guid == nil then
			guid = TRB.Data.snapshotData.targetData.currentTargetGuid
		end

		if TRB.Data.snapshotData.targetData.targets[guid] == nil then
			return false
		end

		local specId = GetSpecialization()

		if specId == 1 then -- Assassination
			return TRB.Data.snapshotData.targetData.targets[guid].garrote or TRB.Data.snapshotData.targetData.targets[guid].rupture or TRB.Data.snapshotData.targetData.targets[guid].internalBleeding or TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest
		end
	end
	
	local function GetSliceAndDiceRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.sliceAndDice)
	end

	local function GetBlindsideRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.blindside)
	end

    local function CalculateAbilityResourceValue(resource, threshold)
        local modifier = 1.0

		modifier = modifier * TRB.Data.character.effects.overgrowthSeedlingModifier * TRB.Data.character.torghast.rampaging.spellCostModifier

        return resource * modifier
    end
	
	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()
		
		if specId == 1 then
			if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
				--Bleeds
				TRB.Data.snapshotData.targetData.targets[guid].garrote = false
				TRB.Data.snapshotData.targetData.targets[guid].garroteRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].rupture = false
				TRB.Data.snapshotData.targetData.targets[guid].ruptureRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].internalBleeding = false
				TRB.Data.snapshotData.targetData.targets[guid].internalBleedingRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest = false
				TRB.Data.snapshotData.targetData.targets[guid].crimsonTempestRemaining = 0
				--Poisons
				TRB.Data.snapshotData.targetData.targets[guid].deadlyPoison = false
				TRB.Data.snapshotData.targetData.targets[guid].deadlyPoisonRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison = false
				TRB.Data.snapshotData.targetData.targets[guid].cripplingPoisonRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].woundPoison = false
				TRB.Data.snapshotData.targetData.targets[guid].woundPoisonRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].numbingPoison = false
				TRB.Data.snapshotData.targetData.targets[guid].numbingPoisonRemaining = 0
				-- Covenant
				TRB.Data.snapshotData.targetData.targets[guid].serratedBoneSpike = false
			end
		end
		TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()

		return true
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget


	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
        
		if specId == 1 then -- Assassination
			-- Bleeds
			local garroteTotal = 0
			local ruptureTotal = 0
			local internalBleedingTotal = 0
			local crimsonTempestTotal = 0
			-- Poisons
			local deadlyPoisonTotal = 0
			local cripplingPoisonTotal = 0
			local woundPoisonTotal = 0
			local numbingPoisonTotal = 0
			-- Covenant
			local serratedBoneSpikeTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
					-- Bleeds
					TRB.Data.snapshotData.targetData.targets[guid].garrote = false
					TRB.Data.snapshotData.targetData.targets[guid].garroteRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].rupture = false
					TRB.Data.snapshotData.targetData.targets[guid].ruptureRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].internalBleeding = false
					TRB.Data.snapshotData.targetData.targets[guid].internalBleedingRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest = false
					TRB.Data.snapshotData.targetData.targets[guid].crimsonTempestRemaining = 0
					-- Poisons
					TRB.Data.snapshotData.targetData.targets[guid].deadlyPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].deadlyPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].woundPoisonRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshotData.targetData.targets[guid].numbingPoisonRemaining = 0
					-- Covenant
					TRB.Data.snapshotData.targetData.targets[guid].serratedBoneSpike = false
				else
					-- Bleeds
					if TRB.Data.snapshotData.targetData.targets[guid].garrote == true then
						garroteTotal = garroteTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].rupture == true then
						ruptureTotal = ruptureTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].internalBleeding == true then
						internalBleedingTotal = internalBleedingTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].crimsonTempest == true then
						crimsonTempestTotal = crimsonTempestTotal + 1
					end
					-- Poisons
					if TRB.Data.snapshotData.targetData.targets[guid].deadlyPoison == true then
						deadlyPoisonTotal = deadlyPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].cripplingPoison == true then
						cripplingPoisonTotal = cripplingPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].woundPoison == true then
						woundPoisonTotal = woundPoisonTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].numbingPoison == true then
						numbingPoisonTotal = numbingPoisonTotal + 1
					end
					-- Covenant
					if TRB.Data.snapshotData.targetData.targets[guid].serratedBoneSpike == true then
						serratedBoneSpikeTotal = serratedBoneSpikeTotal + 1
					end
				end
			end
			--Bleeds
			TRB.Data.snapshotData.targetData.garrote = garroteTotal
			TRB.Data.snapshotData.targetData.rupture = ruptureTotal
			TRB.Data.snapshotData.targetData.internalBleeding = internalBleedingTotal
			TRB.Data.snapshotData.targetData.crimsonTempest = crimsonTempestTotal
			--Poisons
			TRB.Data.snapshotData.targetData.deadlyPoison = deadlyPoisonTotal
			TRB.Data.snapshotData.targetData.cripplingPoison = cripplingPoisonTotal
			TRB.Data.snapshotData.targetData.woundPoison = woundPoisonTotal
			TRB.Data.snapshotData.targetData.numbingPoison = numbingPoisonTotal
			--Covenant
			TRB.Data.snapshotData.targetData.serratedBoneSpike = serratedBoneSpikeTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 1 then			 
				--Bleeds
				TRB.Data.snapshotData.targetData.garrote = 0
				TRB.Data.snapshotData.targetData.rupture = 0
				TRB.Data.snapshotData.targetData.internalBleeding = 0
				TRB.Data.snapshotData.targetData.crimsonTempest = 0
				--Poisons
				TRB.Data.snapshotData.targetData.deadlyPoison = 0
				TRB.Data.snapshotData.targetData.cripplingPoison = 0
				TRB.Data.snapshotData.targetData.woundPoison = 0
				TRB.Data.snapshotData.targetData.numbingPoison = 0
				--Covenant
				TRB.Data.snapshotData.targetData.serratedBoneSpike = 0
			end
		end
	end

	local function ConstructResourceBar(settings)
		local entries = TRB.Functions.TableLength(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end

		local resourceFrameCounter = 1
        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
				if TRB.Frames.resourceFrame.thresholds[resourceFrameCounter] == nil then
					TRB.Frames.resourceFrame.thresholds[resourceFrameCounter] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[resourceFrameCounter]:Show()
				TRB.Frames.resourceFrame.thresholds[resourceFrameCounter]:SetFrameLevel(0)
				TRB.Frames.resourceFrame.thresholds[resourceFrameCounter]:Hide()
                resourceFrameCounter = resourceFrameCounter + 1
            end
        end

		TRB.Functions.ConstructResourceBar(settings)
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.rogue.assassination
		end

		if specId == 1 then --Assassination
			-- Bleeds
			if var == "$isBleeding" then
				if IsTargetBleeding() then
					valid = true
				end
			elseif var == "$ctCount" or var == "$crimsonTempestCount" then
				if TRB.Data.snapshotData.targetData.crimsonTempest > 0 then
					valid = true
				end
			elseif var == "$ctTime" or var == "$crimsonTempestTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempestRemaining > 0 then
					valid = true
				end
			elseif var == "$garroteCount" then
				if TRB.Data.snapshotData.targetData.garrote > 0 then
					valid = true
				end
			elseif var == "$garroteTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garroteRemaining > 0 then
					valid = true
				end
			elseif var == "$ibCount" or var == "$internalBleedingCount" then
				if TRB.Data.snapshotData.targetData.internalBleeding > 0 then
					valid = true
				end
			elseif var == "$ibTime" or var == "$internalBleedingTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleedingRemaining > 0 then
					valid = true
				end
			elseif var == "$ruptureCount" then
				if TRB.Data.snapshotData.targetData.rupture > 0 then
					valid = true
				end
			elseif var == "$ruptureTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ruptureRemaining > 0 then
					valid = true
				end
			-- Poisons
			elseif var == "$cpCount" or var == "$cripplingPoisonCount" then
				if TRB.Data.snapshotData.targetData.cripplingPoison > 0 then
					valid = true
				end
			elseif var == "$cpTime" or var == "$cripplingPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoisonRemaining > 0 then
					valid = true
				end
			elseif var == "$dpCount" or var == "$deadlyPoisonCount" then
				if TRB.Data.snapshotData.targetData.deadlyPoison > 0 then
					valid = true
				end
			elseif var == "$dpTime" or var == "$deadlyPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoisonRemaining > 0 then
					valid = true
				end
			elseif var == "$npCount" or var == "$numbingPoisonCount" then
				if TRB.Data.snapshotData.targetData.numbingPoison > 0 then
					valid = true
				end
			elseif var == "$npTime" or var == "$numbingPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoisonRemaining > 0 then
					valid = true
				end
			elseif var == "$wpCount" or var == "$woundPoisonCount" then
				if TRB.Data.snapshotData.targetData.woundPoison > 0 then
					valid = true
				end
			elseif var == "$wpTime" or var == "$woundPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoisonRemaining > 0 then
					valid = true
				end
			-- Other abilities
			elseif var == "$blindsideTime" then
				if TRB.Data.snapshotData.blindside.spellId ~= nil then
					valid = true
				end
			end
		--[[elseif specId == 2 then --Outlaw
		elseif specId == 3 then --Survivial]]
		end

		if var == "$resource" or var == "$energy" then
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
			if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
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
		elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$sadTime" or var == "$sliceAndDiceTime" then
			if TRB.Data.snapshotData.sliceAndDice.spellId ~= nil then
				valid = true
			end
		elseif var == "$sbsCount" or var == "$serratedBoneSpikeCount" then
			if TRB.Data.snapshotData.targetData.serratedBoneSpike > 0 then
				valid = true
			end
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Assassination()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.current
		local castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.casting

		if TRB.Data.settings.rogue.assassination.colors.text.overcapEnabled and overcap then
			currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overcap
            castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overcap
		elseif TRB.Data.settings.rogue.assassination.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overThreshold
				castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _regenEnergy = TRB.Data.snapshotData.energyRegen
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.assassination.generation.enabled then
			if TRB.Data.settings.rogue.assassination.generation.mode == "time" then
				_regenEnergy = _regenEnergy * (TRB.Data.settings.rogue.assassination.generation.time or 3.0)
			else
				_regenEnergy = _regenEnergy * ((TRB.Data.settings.rogue.assassination.generation.gcds or 2) * _gcd)
			end
		else
			_regenEnergy = 0
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy --+ _barbedShotEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)


		-- Bleeds
		-- TODO: Somehow account for pandemic being variable
		--$ctCount and $ctTime
		local _ctCount = TRB.Data.snapshotData.targetData.crimsonTempest or 0
		local ctCount = _ctCount
		local _ctTime = 0
		local ctTime
		
		--$garroteCount and $garroteTime
		local _garroteCount = TRB.Data.snapshotData.targetData.garrote or 0
		local garroteCount = _garroteCount
		local _garroteTime = 0
		local garroteTime
		
		--$ibCount and $ibTime
		local _ibCount = TRB.Data.snapshotData.targetData.internalBleeding or 0
		local ibCount = _ibCount
		local _ibTime = 0
		local ibTime
		
		--$ruptureCount and $ruptureTime
		local _ruptureCount = TRB.Data.snapshotData.targetData.rupture or 0
		local ruptureCount = _ruptureCount
		local _ruptureTime = 0
		local ruptureTime
		
		-- Poisons
		--$cpCount and $cpTime
		local _cpCount = TRB.Data.snapshotData.targetData.cripplingPoison or 0
		local cpCount = _cpCount
		local _cpTime = 0
		local cpTime
				
		--$dpCount and $cpTime
		local _dpCount = TRB.Data.snapshotData.targetData.deadlyPoison or 0
		local dpCount = _dpCount
		local _dpTime = 0
		local dpTime
				
		--$npCount and $npTime
		local _npCount = TRB.Data.snapshotData.targetData.numbingPoison or 0
		local npCount = _npCount
		local _npTime = 0
		local npTime
				
		--$wpCount and $wpTime
		local _wpCount = TRB.Data.snapshotData.targetData.woundPoison or 0
		local wpCount = _wpCount
		local _wpTime = 0
		local wpTime
		
		--$sbsCount
		local _sbsCount = TRB.Data.snapshotData.targetData.serratedBoneSpike or 0
		local sbsCount = _sbsCount
		local _sbsOnTarget = false


		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_ctTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempestRemaining or 0
			_garroteTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garroteRemaining or 0
			_ibTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleedingRemaining or 0
			_ruptureTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ruptureRemaining or 0
			_cpTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoisonRemaining or 0
			_dpTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoisonRemaining or 0
			_npTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoisonRemaining or 0
			_wpTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoisonRemaining or 0
			_sbsOnTarget = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serratedBoneSpike or false
		end


		if TRB.Data.settings.rogue.assassination.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			-- Bleeds
			if _ctTime > TRB.Data.spells.crimsonTempest.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ctTime)
			elseif _ctTime > 0 then
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ctTime)
			else
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _garroteTime > TRB.Data.spells.garrote.pandemicTime then
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _garroteTime)
			elseif _garroteTime > 0 then
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _garroteTime)
			else
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end
						
			if _ibTime > 0 then
				ibCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ibCount)
				ibTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ibTime)
			else
				ibCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ibCount)
				ibTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _ruptureTime > TRB.Data.spells.rupture.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ruptureTime)
			elseif _ruptureTime > 0 then
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ruptureTime)
			else
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			--Poisons
			if _cpTime > 0 then
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _cpTime)
			else
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _dpTime > 0 then
				dpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _dpCount)
				dpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _dpTime)
			else
				dpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _dpCount)
				dpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _npTime > 0 then
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _npTime)
			else
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _wpTime > 0 then
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _wpTime)
			else
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _sbsOnTarget == false and TRB.Data.character.covenantId == 4 then
				sbsCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _sbsCount)
			else
				sbsCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _sbsCount)
			end
		else
			-- Bleeds
			ctTime = string.format("%.1f", _ctTime)
			garroteTime = string.format("%.1f", _garroteTime)
			ibTime = string.format("%.1f", _ibTime)
			ruptureTime = string.format("%.1f", _ruptureTime)

			-- Poisons
			cpTime = string.format("%.1f", _cpTime)
			dpTime = string.format("%.1f", _dpTime)
			npTime = string.format("%.1f", _npTime)
			wpTime = string.format("%.1f", _wpTime)
		end
		

		--$sadTime
		local _sadTime = 0
		local sadTime
		if TRB.Data.snapshotData.sliceAndDice.spellId ~= nil then
			_sadTime = GetSliceAndDiceRemainingTime()
		end
		
		if _sadTime > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _sadTime)
		elseif _sadTime > 0 then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _sadTime)
		else
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
		end

		
		--$blindsideTime
		local _blindsideTime = GetBlindsideRemainingTime()
		local blindsideTime = 0
		if _blindsideTime ~= nil then
			blindsideTime = string.format("%.1f", _blindsideTime)
		end

		--#covenantAbility
		local covenantAbilityIcon = ""

		if TRB.Data.character.covenantId == 1 then
			covenantAbilityIcon = TRB.Data.spells.echoingReprimand.icon
		elseif TRB.Data.character.covenantId == 2 then
			covenantAbilityIcon = TRB.Data.spells.flagellation.icon
		elseif TRB.Data.character.covenantId == 3 then
			covenantAbilityIcon = TRB.Data.spells.sepsis.icon
		elseif TRB.Data.character.covenantId == 4 then
			covenantAbilityIcon = TRB.Data.spells.serratedBoneSpike.icon
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.dots = {
			cripplingPoisonCount = _cpCount,
			deadlyPoisonCount = _dpCount,
			numbingPoisonCount = _npCount,
			woundPoisonCount = _wpCount,
			crimsonTempestCount = _ctCount,
			garroteCount = _garroteCount,
			internalBleedingCount = _ibCount,
			ruptureCount = _ruptureCount,
			serratedBoneSpikeCount = _sbsCount
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#blindside"] = TRB.Data.spells.blindside.icon
		lookup["#covenantAbility"] = covenantAbilityIcon
		lookup["#crimsonTempest"] = TRB.Data.spells.crimsonTempest.icon
		lookup["#ct"] = TRB.Data.spells.crimsonTempest.icon
		lookup["#cripplingPoison"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#cp"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#deadlyPoison"] = TRB.Data.spells.deadlyPoison.icon
		lookup["#dp"] = TRB.Data.spells.deadlyPoison.icon
		lookup["#deathFromAbove"] = TRB.Data.spells.deathFromAbove.icon
		lookup["#dismantle"] = TRB.Data.spells.dismantle.icon
		lookup["#echoingReprimand"] = TRB.Data.spells.echoingReprimand.icon
		lookup["#garrote"] = TRB.Data.spells.garrote.icon
		lookup["#internalBleeding"] = TRB.Data.spells.internalBleeding.icon
		lookup["#ib"] = TRB.Data.spells.internalBleeding.icon
		lookup["#numbingPoison"] = TRB.Data.spells.numbingPoison.icon
		lookup["#np"] = TRB.Data.spells.numbingPoison.icon
		lookup["#rupture"] = TRB.Data.spells.rupture.icon
		lookup["#sad"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sepsis"] = TRB.Data.spells.sepsis.icon
		lookup["#serratedBoneSpike"] = TRB.Data.spells.serratedBoneSpike.icon
		lookup["#woundPoison"] = TRB.Data.spells.woundPoison.icon
		lookup["#wp"] = TRB.Data.spells.woundPoison.icon

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
		lookup["$cpCount"] = cpCount
		lookup["$cripplingPoisonCount"] = cpCount
		lookup["$cpTime"] = cpTime
		lookup["$cripplingPoisonTime"] = cpTime
		lookup["$dpCount"] = dpCount
		lookup["$deadlyPoisonCount"] = dpCount
		lookup["$dpTime"] = dpTime
		lookup["$deadlyPoisonTime"] = dpTime
		lookup["$npCount"] = npCount
		lookup["$numbingPoisonCount"] = npCount
		lookup["$npTime"] = npTime
		lookup["$numbingPoisonTime"] = npTime
		lookup["$wpCount"] = wpCount
		lookup["$woundPoisonCount"] = wpCount
		lookup["$wpTime"] = wpTime
		lookup["$woundPoisonTime"] = wpTime
		lookup["$ctCount"] = ctCount
		lookup["$crimsonTempestCount"] = ctCount
		lookup["$ctTime"] = ctTime
		lookup["$crimsonTempestTime"] = ctTime
		lookup["$garroteCount"] = garroteCount
		lookup["$garroteTime"] = garroteTime
		lookup["$ibCount"] = ibCount
		lookup["$internalBleedingCount"] = ibCount
		lookup["$ibTime"] = ibTime
		lookup["$internalBleedingTime"] = ibTime
		lookup["$ruptureCount"] = ruptureCount
		lookup["$ruptureTime"] = ruptureTime
		lookup["$sbsCount"] = sbsCount
		lookup["$serratedBoneSpikeCount"] = sbsCount
		lookup["$sadTime"] = sadTime
		lookup["$sliceAndDiceTime"] = sadTime
		lookup["$blindsideTime"] = blindsideTime
		lookup["$isBleeding"] = ""

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
		TRB.Data.lookup = lookup
	end

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.energy
        TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.energy)
        TRB.Data.snapshotData.casting.spellId = spell.id
        TRB.Data.snapshotData.casting.icon = spell.icon
    end

	local function CastingSpell()
		local specId = GetSpecialization()
		local currentSpell = UnitCastingInfo("player")
		local currentChannel = UnitChannelInfo("player")

		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
						TRB.Functions.ResetCastingSnapshotData()
						return false
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					return false
				end
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()

		_, _, _, _, TRB.Data.snapshotData.sliceAndDice.duration, TRB.Data.snapshotData.sliceAndDice.endTime, _, _, _, TRB.Data.snapshotData.sliceAndDice.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.sliceAndDice.id)

		if TRB.Data.character.covenantId == 4 then
			TRB.Data.snapshotData.serratedBoneSpike.charges, _, TRB.Data.snapshotData.serratedBoneSpike.startTime, TRB.Data.snapshotData.serratedBoneSpike.duration, _ = GetSpellCharges(TRB.Data.spells.serratedBoneSpike.id)
		else
			TRB.Data.snapshotData.serratedBoneSpike.charges = 0
			TRB.Data.snapshotData.serratedBoneSpike.startTime = nil
			TRB.Data.snapshotData.serratedBoneSpike.duration = 0
		end

        if TRB.Data.snapshotData.distract.startTime ~= nil and currentTime > (TRB.Data.snapshotData.distract.startTime + TRB.Data.snapshotData.distract.duration) then
            TRB.Data.snapshotData.distract.startTime = nil
            TRB.Data.snapshotData.distract.duration = 0
        end

        if TRB.Data.snapshotData.feint.startTime ~= nil and currentTime > (TRB.Data.snapshotData.feint.startTime + TRB.Data.snapshotData.feint.duration) then
            TRB.Data.snapshotData.feint.startTime = nil
            TRB.Data.snapshotData.feint.duration = 0
        end

        if TRB.Data.snapshotData.kidneyShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.kidneyShot.startTime + TRB.Data.snapshotData.kidneyShot.duration) then
            TRB.Data.snapshotData.kidneyShot.startTime = nil
            TRB.Data.snapshotData.kidneyShot.duration = 0
        end

        if TRB.Data.snapshotData.shiv.startTime ~= nil and currentTime > (TRB.Data.snapshotData.shiv.startTime + TRB.Data.snapshotData.shiv.duration) then
            TRB.Data.snapshotData.shiv.startTime = nil
            TRB.Data.snapshotData.shiv.duration = 0
        end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.cripplingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].cripplingPoisonRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.deadlyPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deadlyPoisonRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.numbingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].numbingPoisonRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoison then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.woundPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].woundPoisonRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Assassination()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _

        if TRB.Data.snapshotData.crimsonVial.startTime ~= nil and currentTime > (TRB.Data.snapshotData.crimsonVial.startTime + TRB.Data.snapshotData.crimsonVial.duration) then
            TRB.Data.snapshotData.crimsonVial.startTime = nil
            TRB.Data.snapshotData.crimsonVial.duration = 0
        end

        if TRB.Data.snapshotData.exsanguinate.startTime ~= nil and currentTime > (TRB.Data.snapshotData.exsanguinate.startTime + TRB.Data.snapshotData.exsanguinate.duration) then
            TRB.Data.snapshotData.exsanguinate.startTime = nil
            TRB.Data.snapshotData.exsanguinate.duration = 0
        end

        if TRB.Data.snapshotData.garrote.startTime ~= nil and currentTime > (TRB.Data.snapshotData.garrote.startTime + TRB.Data.snapshotData.garrote.duration) then
            TRB.Data.snapshotData.garrote.startTime = nil
            TRB.Data.snapshotData.garrote.duration = 0
        end

        if TRB.Data.snapshotData.echoingReprimand.startTime ~= nil and currentTime > (TRB.Data.snapshotData.echoingReprimand.startTime + TRB.Data.snapshotData.echoingReprimand.duration) then
            TRB.Data.snapshotData.echoingReprimand.startTime = nil
            TRB.Data.snapshotData.echoingReprimand.duration = 0
        end

		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempest then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.crimsonTempest.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].crimsonTempestRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garrote then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.garrote.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].garroteRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleeding then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.internalBleeding.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].internalBleedingRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rupture then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.rupture.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ruptureRemaining = expiration - currentTime
				end
			end
		end
	
        if TRB.Data.snapshotData.deathFromAbove.startTime ~= nil and currentTime > (TRB.Data.snapshotData.deathFromAbove.startTime + TRB.Data.snapshotData.deathFromAbove.duration) then
            TRB.Data.snapshotData.deathFromAbove.startTime = nil
            TRB.Data.snapshotData.deathFromAbove.duration = 0
        end

        if TRB.Data.snapshotData.dismantle.startTime ~= nil and currentTime > (TRB.Data.snapshotData.dismantle.startTime + TRB.Data.snapshotData.dismantle.duration) then
            TRB.Data.snapshotData.dismantle.startTime = nil
            TRB.Data.snapshotData.dismantle.duration = 0
        end
	end

	local function UpdateSnapshot_Outlaw()
		UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Subtlety()
		UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.rogue.assassination.displayBar.alwaysShow) and (
						(not TRB.Data.settings.rogue.assassination.displayBar.notZeroShow) or
						(TRB.Data.settings.rogue.assassination.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.rogue.assassination.displayBar.neverShow == true then
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
			UpdateSnapshot_Assassination()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.rogue.assassination.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)

					local passiveValue = 0
					if TRB.Data.settings.rogue.assassination.bar.showPassive then
						if TRB.Data.settings.rogue.assassination.generation.enabled then
							if TRB.Data.settings.rogue.assassination.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.rogue.assassination.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.rogue.assassination.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and TRB.Data.settings.rogue.assassination.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.bar.passive, true))
					end

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then	
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.rogue.assassination, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.rogue.assassination.thresholdWidth, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
							local frameLevel = 129

							if spell.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed. TODO: add override check for certain buffs.
								if spell.id == TRB.Data.spells.ambush.id then
									if TRB.Data.spells.subterfuge.isActive then
										if TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = 128
										end
									elseif TRB.Data.spells.blindside.isActive then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										showThreshold = false
									end
								elseif TRB.Data.spells.subterfuge.isActive or TRB.Data.spells.sepsis.isActive then
									if TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = 128
									end
								else
									showThreshold = false
								end
							else
								if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
									if spell.id == TRB.Data.spells.exsanguinate.id then
										if not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
											showThreshold = false
										elseif not IsTargetBleeding(TRB.Data.snapshotData.targetData.currentTargetGuid) or (TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration)) then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = 128
										end
									elseif spell.id == TRB.Data.spells.shiv.id then
										if TRB.Data.character.items.tinyToxicBlade == true then -- Don't show this threshold
											showThreshold = false
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = 128
										end
									elseif spell.id == TRB.Data.spells.echoingReprimand.id then
										if TRB.Data.character.covenantId ~= 1 then -- Not Kyrian
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
												thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
												frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = 128
										end
									elseif spell.id == TRB.Data.spells.sepsis.id then
										if TRB.Data.character.covenantId ~= 3 then -- Not Night Fae
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
												thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
												frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = 128
										end
									elseif spell.id == TRB.Data.spells.serratedBoneSpike.id then
										if TRB.Data.character.covenantId ~= 4 then -- Not Necrolord
											showThreshold = false
										elseif TRB.Data.snapshotData[spell.settingKey].charges == 0 then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
											frameLevel = 128
										end
									end
								elseif spell.isPvp and not TRB.Data.character.isPvp then
									showThreshold = false
								elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
									showThreshold = false
								elseif spell.hasCooldown then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = 128
									end
								else -- This is an active/available/normal spell threshold
									if TRB.Data.snapshotData.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.under
										frameLevel = 128
									end
								end
							end

							if spell.comboPoints == true and TRB.Data.snapshotData.resource2 == 0 then
								thresholdColor = TRB.Data.settings.rogue.assassination.colors.threshold.unusable
								frameLevel = 127
							end

							if TRB.Data.settings.rogue.assassination.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == 129 then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
					end

					local barColor = TRB.Data.settings.rogue.assassination.colors.bar.base

					local latency = TRB.Functions.GetLatency()

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat then
						local sadTime = GetSliceAndDiceRemainingTime()
						if sadTime == 0 then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.noSliceAndDice
						elseif sadTime < TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshotData.resource2 + 1] then
							barColor = TRB.Data.settings.rogue.assassination.colors.bar.sliceAndDicePandemic
						end
					end

					local barBorderColor = TRB.Data.settings.rogue.assassination.colors.bar.border

					if TRB.Data.settings.rogue.assassination.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.rogue.assassination.colors.bar.borderOvercap

						if TRB.Data.settings.rogue.assassination.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
					
					local sbsCp = 0
					
					if TRB.Data.character.covenantId == 4 and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.serratedBoneSpike.charges > 0 then
						sbsCp = 1 + TRB.Data.snapshotData.targetData.serratedBoneSpike

						if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] == nil or
							TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].serratedBoneSpike == false then
							sbsCp = sbsCp + 1
						end
					end

					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.background, true)

                    for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.border
						local cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

                        if TRB.Data.snapshotData.resource2 >= x then
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if x == (TRB.Data.character.maxResource2 - 1) then
								cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.penultimate
							elseif x == TRB.Data.character.maxResource2 then
								cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.final
							end
                        else
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.rogue.assassination, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
                        end

						if TRB.Data.snapshotData.echoingReprimand[x].enabled then
							cpColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.echoingReprimand
							cpBorderColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.echoingReprimand
							cpBR, cpBG, cpBB, _ = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.echoingReprimand, true)
						elseif sbsCp > 0 and x > TRB.Data.snapshotData.resource2 and x <= (TRB.Data.snapshotData.resource2 + sbsCp) then
							cpBorderColor = TRB.Data.settings.rogue.assassination.colors.comboPoints.serratedBoneSpike
							cpBR, cpBG, cpBB, _ = TRB.Functions.GetRGBAFromString(TRB.Data.settings.rogue.assassination.colors.comboPoints.serratedBoneSpike, true)
						end
						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
                    end
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.rogue.assassination, refreshText)
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 and specId ~= 3 then
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

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 then --Assassination
					if spellId == TRB.Data.spells.exsanguinate.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.exsanguinate.startTime = currentTime
							TRB.Data.snapshotData.exsanguinate.duration = TRB.Data.spells.exsanguinate.cooldown
						end
					elseif spellId == TRB.Data.spells.blindside.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.blindside.isActive = true
							_, _, _, _, TRB.Data.snapshotData.blindside.duration, TRB.Data.snapshotData.blindside.endTime, _, _, _, TRB.Data.snapshotData.blindside.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.blindside.id)
							if TRB.Data.settings.rogue.assassination.audio.blindside.enabled then
								PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.blindside.isActive = false
							TRB.Data.snapshotData.blindside.spellId = nil
							TRB.Data.snapshotData.blindside.duration = 0
							TRB.Data.snapshotData.blindside.endTime = nil
						end
					elseif spellId == TRB.Data.spells.subterfuge.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.subterfuge.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.subterfuge.isActive = false
						end
					elseif spellId == TRB.Data.spells.garrote.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" then
								if not((TRB.Data.character.talents.subterfuge.isSelected and IsStealthed()) or TRB.Data.spells.subterfuge.isActive) then
									TRB.Data.snapshotData.garrote.startTime = currentTime
									TRB.Data.snapshotData.garrote.duration = TRB.Data.spells.garrote.cooldown
								end
							elseif type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Garrote Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].garrote = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.garrote = TRB.Data.snapshotData.targetData.garrote + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].garrote = false
								TRB.Data.snapshotData.targetData.targets[destGUID].garroteRemaining = 0
								TRB.Data.snapshotData.targetData.garrote = TRB.Data.snapshotData.targetData.garrote - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.rupture.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rupture Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].rupture = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.rupture = TRB.Data.snapshotData.targetData.rupture + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].rupture = false
								TRB.Data.snapshotData.targetData.targets[destGUID].ruptureRemaining = 0
								TRB.Data.snapshotData.targetData.rupture = TRB.Data.snapshotData.targetData.rupture - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.internalBleeding.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- IB Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].internalBleeding = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.internalBleeding = TRB.Data.snapshotData.targetData.internalBleeding + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].internalBleeding = false
								TRB.Data.snapshotData.targetData.targets[destGUID].internalBleedingRemaining = 0
								TRB.Data.snapshotData.targetData.internalBleeding = TRB.Data.snapshotData.targetData.internalBleeding - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.crimsonTempest.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- CT Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].crimsonTempest = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.crimsonTempest = TRB.Data.snapshotData.targetData.crimsonTempest + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].crimsonTempest = false
								TRB.Data.snapshotData.targetData.targets[destGUID].crimsonTempestRemaining = 0
								TRB.Data.snapshotData.targetData.crimsonTempest = TRB.Data.snapshotData.targetData.crimsonTempest - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.deadlyPoison.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- DP Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].deadlyPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.deadlyPoison = TRB.Data.snapshotData.targetData.deadlyPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].deadlyPoison = false
								TRB.Data.snapshotData.targetData.targets[destGUID].deadlyPoisonRemaining = 0
								TRB.Data.snapshotData.targetData.deadlyPoison = TRB.Data.snapshotData.targetData.deadlyPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.cripplingPoison.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- CP Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].cripplingPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.cripplingPoison = TRB.Data.snapshotData.targetData.cripplingPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].cripplingPoison = false
								TRB.Data.snapshotData.targetData.targets[destGUID].cripplingPoisonRemaining = 0
								TRB.Data.snapshotData.targetData.cripplingPoison = TRB.Data.snapshotData.targetData.cripplingPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.woundPoison.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- WP Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].woundPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.woundPoison = TRB.Data.snapshotData.targetData.woundPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].woundPoison = false
								TRB.Data.snapshotData.targetData.targets[destGUID].woundPoisonRemaining = 0
								TRB.Data.snapshotData.targetData.woundPoison = TRB.Data.snapshotData.targetData.woundPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.numbingPoison.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- NP Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].numbingPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.numbingPoison = TRB.Data.snapshotData.targetData.numbingPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].numbingPoison = false
								TRB.Data.snapshotData.targetData.targets[destGUID].numbingPoisonRemaining = 0
								TRB.Data.snapshotData.targetData.numbingPoison = TRB.Data.snapshotData.targetData.numbingPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.deathFromAbove.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.deathFromAbove.startTime = currentTime
							TRB.Data.snapshotData.deathFromAbove.duration = TRB.Data.spells.deathFromAbove.cooldown
						end
					elseif spellId == TRB.Data.spells.dismantle.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.dismantle.startTime = currentTime
							TRB.Data.snapshotData.dismantle.duration = TRB.Data.spells.dismantle.cooldown
						end
					end
				end

				-- Spec agnostic
				if spellId == TRB.Data.spells.crimsonVial.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.crimsonVial.startTime = currentTime
						TRB.Data.snapshotData.crimsonVial.duration = TRB.Data.spells.crimsonVial.cooldown
					end
				elseif spellId == TRB.Data.spells.sliceAndDice.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff
						TRB.Data.spells.sliceAndDice.isActive = true
						_, _, _, _, TRB.Data.snapshotData.sliceAndDice.duration, TRB.Data.snapshotData.sliceAndDice.endTime, _, _, _, TRB.Data.snapshotData.sliceAndDice.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.sliceAndDice.id)
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.sliceAndDice.isActive = false
						TRB.Data.snapshotData.sliceAndDice.spellId = nil
						TRB.Data.snapshotData.sliceAndDice.duration = 0
						TRB.Data.snapshotData.sliceAndDice.endTime = nil
					end
				elseif spellId == TRB.Data.spells.distract.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.distract.startTime = currentTime
						TRB.Data.snapshotData.distract.duration = TRB.Data.spells.distract.cooldown
					end
				elseif spellId == TRB.Data.spells.feint.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.feint.startTime = currentTime
						TRB.Data.snapshotData.feint.duration = TRB.Data.spells.feint.cooldown
					end
				elseif spellId == TRB.Data.spells.kidneyShot.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.kidneyShot.startTime = currentTime
						TRB.Data.snapshotData.kidneyShot.duration = TRB.Data.spells.kidneyShot.cooldown
					end
				elseif spellId == TRB.Data.spells.shiv.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.shiv.startTime = currentTime
						TRB.Data.snapshotData.shiv.duration = TRB.Data.spells.shiv.cooldown
					end
				elseif spellId == TRB.Data.spells.adrenalineRush.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" then -- For right now, just redo the CheckCharacter() to get update Energy values
						CheckCharacter()
					end
				elseif spellId == TRB.Data.spells.echoingReprimand.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.echoingReprimand.startTime = currentTime
						TRB.Data.snapshotData.echoingReprimand.duration = TRB.Data.spells.echoingReprimand.cooldown
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end
				elseif spellId == TRB.Data.spells.echoingReprimand.buffId[1] or spellId == TRB.Data.spells.echoingReprimand.buffId[2] or spellId == TRB.Data.spells.echoingReprimand.buffId[3] or spellId == TRB.Data.spells.echoingReprimand.buffId[4] or spellId == TRB.Data.spells.echoingReprimand.buffId[5] then
					local cpEntry = 1

					if spellId == TRB.Data.spells.echoingReprimand.buffId[1] then
						cpEntry = 2
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[2] then
						cpEntry = 3
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[3] or spellId == TRB.Data.spells.echoingReprimand.buffId[4] then 
						cpEntry = 4
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[5] then
						cpEntry = 5
					end

					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Echoing Reprimand Applied to Target
						TRB.Data.snapshotData.echoingReprimand[cpEntry].enabled = true
						_, _, TRB.Data.snapshotData.echoingReprimand[cpEntry].comboPoints, _, TRB.Data.snapshotData.echoingReprimand[cpEntry].duration, TRB.Data.snapshotData.echoingReprimand[cpEntry].endTime, _, _, _, TRB.Data.snapshotData.echoingReprimand[cpEntry].spellId = TRB.Functions.FindBuffById(spellId)
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.echoingReprimand[cpEntry].enabled = false
						TRB.Data.snapshotData.echoingReprimand[cpEntry].spellId = nil
						TRB.Data.snapshotData.echoingReprimand[cpEntry].endTime = nil
						TRB.Data.snapshotData.echoingReprimand[cpEntry].comboPoints = 0
					end
				elseif spellId == TRB.Data.spells.sepsis.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.sepsis.startTime = currentTime
						TRB.Data.snapshotData.sepsis.duration = TRB.Data.spells.sepsis.cooldown
					end
				elseif spellId == TRB.Data.spells.sepsis.buffId then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.sepsis.isActive = true
						if TRB.Data.settings.rogue.assassination.audio.sepsis.enabled then
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.sepsis.isActive = false
					end
				elseif spellId == TRB.Data.spells.serratedBoneSpike.id then
					if type == "SPELL_CAST_SUCCESS" then -- Barbed Shot
						TRB.Data.snapshotData.serratedBoneSpike.charges, _, TRB.Data.snapshotData.serratedBoneSpike.startTime, TRB.Data.snapshotData.serratedBoneSpike.duration, _ = GetSpellCharges(TRB.Data.spells.serratedBoneSpike.id)
					end
				elseif spellId == TRB.Data.spells.serratedBoneSpike.debuffId then
					if InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- NP Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].serratedBoneSpike = true
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].serratedBoneSpike = false
							TRB.Data.snapshotData.targetData.serratedBoneSpike = TRB.Data.snapshotData.targetData.serratedBoneSpike - 1
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

	resourceFrame:RegisterEvent("ADDON_LOADED")
	resourceFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local _, _, classIndex = UnitClass("player")
		local specId = GetSpecialization() or 0
		if classIndex == 4 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Rogue.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					FillSpecCache()
					FillSpellData_Assassination()
					--FillSpellData_Outlaw()
					--FillSpellData_Subtlety()

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
							TRB.Data.settings.rogue.assassination = TRB.Functions.ValidateLsmValues("Assassination Rogue", TRB.Data.settings.rogue.assassination)
							--TRB.Data.settings.rogue.outlaw = TRB.Functions.ValidateLsmValues("Outlaw Rogue", TRB.Data.settings.rogue.outlaw)
							--TRB.Data.settings.rogue.subtlety = TRB.Functions.ValidateLsmValues("Subtlety Rogue", TRB.Data.settings.rogue.subtlety)
							TRB.Options.Rogue.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							ConstructResourceBar(TRB.Data.settings.rogue[TRB.Data.barConstructedForSpec])
							EventRegistration()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					if specId == 1 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.rogue.assassination)
						TRB.Functions.IsTtdActive(TRB.Data.settings.rogue.assassination)
						FillSpellData_Assassination()
						TRB.Functions.LoadFromSpecCache(specCache.assassination)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Assassination

						if TRB.Data.barConstructedForSpec ~= "assassination" then
							TRB.Data.barConstructedForSpec = "assassination"
							ConstructResourceBar(TRB.Data.settings.rogue.assassination)
                        else
                            TRB.Functions.RepositionBar(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
						end
					end
					EventRegistration()
				end
			end
		end
	end)
end
