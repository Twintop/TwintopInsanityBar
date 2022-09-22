local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 1 then --Only do this if we're on a Warrior!
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
		arms = {
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
		fury = {
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
		-- Arms
		specCache.arms.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0,
				ravager = 0,
				ancientAftershock = 0,
				conquerorsBanner = 0
			},
			dots = {
				rendCount = 0,
				deepWoundsCount = 0
			},
			ravager = {
				rage = 0,
				ticks = 0
			},
			ancientAftershock = {
				rage = 0,
				ticks = 0
			},
			conquerorsBanner = {
				rage = 0,
				ticks = 0
			}
		}

		specCache.arms.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
			items = {
				glory = false,
				naturesFury = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.arms.spells = {
			--Warrior Class Baseline Abilities
			charge = {
				id = 100,
				name = "",
				icon = "",
				rage = 20,
				isTalent = false,
				isBaseline = true,
			},
			execute = {
				id = 163201,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				rage = -20,
				rageMax = -40,
				texture = "",
				thresholdId = 1,
				settingKey = "execute",
				isTalent = false,
				isBaseline = true,
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true
			},
			executeMinimum = {
				id = 163201,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				rage = -20,
				texture = "",
				thresholdId = 2,
				settingKey = "executeMinimum",
				isTalent = false,
				isBaseline = true,
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true
			},
			executeMaximum = {
				id = 163201,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				rage = -40,
				texture = "",
				thresholdId = 3,
				settingKey = "executeMaximum",
				isTalent = false,
				isBaseline = true,
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true
			},
			hamstring = {
				id = 1715,
				name = "",
				icon = "",
				rage = -10,
				texture = "",
				thresholdId = 4,
				settingKey = "hamstring",
				isTalent = false,
				isBaseline = true,
				thresholdUsable = false
			},
			shieldBlock = {
				id = 2565,
				name = "",
				icon = "",
				rage = -30,
				texture = "",
				thresholdId = 5,
				settingKey = "shieldBlock",
				isTalent = false,
				isBaseline = true,
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true
			},
			slam = {
				id = 1464,
				name = "",
				icon = "",
				rage = -20,
				texture = "",
				thresholdId = 6,
				settingKey = "slam",
				isTalent = false,
				isBaseline = true,
				hasCooldown = false,
				thresholdUsable = false
			},
			victoryRush = {
				id = 34428,
				name = "",
				icon = "",
				isTalent = false,
				isBaseline = true,
			},
			whirlwind = {
				id = 1680,
				name = "",
				icon = "",
				rage = -30,
				texture = "",
				thresholdId = 7,
				settingKey = "whirlwind",
				isTalent = false,
				isBaseline = true,
				hasCooldown = true,
				thresholdUsable = false
			},

			-- Arms Baseline Abilities
			deepWounds = {
				id = 262115,
				name = "",
				icon = "",
				baseDuration = 10,
				pandemic = true,
				pandemicTime = 3 --Refreshes add 12sec, capping at 15? --10 * 0.3				
			},

			-- Warrior Class Talents
			impendingVictory = {
				id = 202168,
				name = "",
				icon = "",
				rage = -10,
				texture = "",
				thresholdId = 8,
				settingKey = "impendingVictory",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true
			},
			thunderClap = {
				id = 6343,
				name = "",
				icon = "",
				rage = -30,
				texture = "",
				thresholdId = 9,
				settingKey = "thunderClap",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},

			--Arms Talent abilities
			mortalStrike = {
				id = 12294,
				name = "",
				icon = "",
				rage = -30,
				texture = "",
				thresholdId = 10,
				settingKey = "mortalStrike",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			improvedExecute = {
				id = 316405,
				name = "",
				icon = "",
				isTalent = true
			},
			rend = {
				id = 772,
				name = "",
				icon = "",
				rage = -30,
				texture = "",
				thresholdId = 11,
				settingKey = "rend",
				isTalent = true,
				hasCooldown = false,
				thresholdUsable = false,
				baseDuration = 15,
				pandemic = true,
				pandemicTime = 15 * 0.3
			},
			cleave = {
				id = 845,
				name = "",
				icon = "",
				rage = -20,
				texture = "",
				thresholdId = 12,
				settingKey = "cleave",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			massacre = {
				id = 281001,
				name = "",
				icon = "",
				healthMinimum = 0.35,
				isTalent = true
			},

			--Talents
			suddenDeath = {
				id = 29725,
				name = "",
				icon = ""				
			},
			skullsplitter = {
				id = 100,
				name = "",
				icon = "",
				rage = 20				
			},
			deadlyCalm = {
				id = 262228,
				name = "",
				icon = "",
				abilityCount = 4,
				modifier = 0, -- 100% for next abilityCount abilities
				rageIncrease = 30
			},
			ravager = {
				id = 152277,
				name = "",
				icon = "",
				rage = 7,
				ticks = 6, -- Sometimes 5, sometimes 6, sometimes 7?!
				duration = 12,
				isHasted = true,
				energizeId = 248439
			},
			
			-- Covenant
			spearOfBastionCovenant = {
				id = 307865,
				name = "",
				icon = "",
				rage = 25
			},
			condemn = {
				id = 317349,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				healthAbove = 0.8,
				rage = -20,
				rageMax = -40,
				texture = "",
				thresholdId = 13,
				settingKey = "condemn",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true
			},
			condemnMinimum = {
				id = 317349,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				healthAbove = 0.8,
				rage = -20,
				texture = "",
				thresholdId = 14,
				settingKey = "condemnMinimum",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true
			},
			condemnMaximum = {
				id = 317349,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				healthAbove = 0.8,
				rage = -40,
				texture = "",
				thresholdId = 15,
				settingKey = "condemnMaximum",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true
			},
			conquerorsBanner = {
				id = 324143,
				name = "",
				icon = "",
				duration = 15,
				ticks = 15,
				rage = 4,
				idLegendaryBonus = 7469
			},
			ancientAftershock = {
				id = 325886,
				name = "",
				icon = "",
				duration = 12,
				ticks = 4,
				rage = 4,
				idTick = 326062,
				idLegendaryBonus = 7471,
				legendaryDuration = 3,
				legendaryTicks = 1
			},

			-- Torghast
			voraciousCullingBlade = {
				id = 329214, --Maybe 329213
				name = "",
				icon = ""
			},
		}

		specCache.arms.snapshotData.audio = {
			overcapCue = false
		}
		specCache.arms.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {},
			rend = 0,
		}
		specCache.arms.snapshotData.execute = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.shieldBlock = {
			charges = 0,
			maxCharges = 2,
			startTime = nil,
			duration = 0
		}
		specCache.arms.snapshotData.impendingVictory = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.thunderClap = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.whirlwind = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.mortalStrike = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.cleave = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.victoryRush = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.arms.snapshotData.deadlyCalm = {
			endTime = nil,
			duration = 0,
			stacks = 0
		}
		specCache.arms.snapshotData.suddenDeath = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.arms.snapshotData.ravager = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil,
			totalDuration = 0
		}
		specCache.arms.snapshotData.condemn = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.conquerorsBanner = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.arms.snapshotData.ancientAftershock = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil,
			targetsHit = 0,
			hitTime = nil
		}
		specCache.arms.snapshotData.voraciousCullingBlade = {
			isActive = false
		}


		-- Fury

		specCache.fury.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0,
				ancientAftershock = 0,
				conquerorsBanner = 0
			},
			ancientAftershock = {
				rage = 0,
				ticks = 0
			},
			conquerorsBanner = {
				rage = 0,
				ticks = 0
			}
		}

		specCache.fury.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
			items = {
				glory = false,
				naturesFury = false
			},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.fury.spells = {
			--Warrior base abilities
			charge = {
				id = 100,
				name = "",
				icon = "",
				rage = 20
			},
			execute = {
				id = 163201,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				rage = 20,
				isTalent = false,
				hasCooldown = false
			},
			shieldBlock = {
				id = 2565,
				name = "",
				icon = "",
				rage = -30,
				texture = "",
				thresholdId = 2,
				settingKey = "shieldBlock",
				isTalent = false,
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true
			},
			slam = {
				id = 1464,
				name = "",
				icon = "",
				rage = -20,
				texture = "",
				thresholdId = 3,
				settingKey = "slam",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false
			},
			whirlwind = {
				id = 85739, --buff ID
				name = "",
				icon = ""
			},
			
			--Fury base abilities
			rampage = {
				id = 184367,
				name = "",
				icon = "",
				rage = -80,
				texture = "",
				thresholdId = 4,
				settingKey = "rampage",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false
			},
			enrage = {
				id = 184362,
				name = "",
				icon = ""
			},
			
			--Talents
			suddenDeath = {
				id = 52437,
				name = "",
				icon = ""				
			},
			impendingVictory = {
				id = 202168,
				name = "",
				icon = "",
				rage = -10,
				texture = "",
				thresholdId = 5,
				settingKey = "impendingVictory",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true
			},
			victoryRush = {
				id = 32216,
				name = "",
				icon = "",
				isActive = false
			},
			massacre = {
				id = 206315,
				name = "",
				icon = "",
				healthMinimum = 0.35
			},
			bladestorm = {
				id = 46924,
				name = "",
				icon = "",
				rage = 5,
				duration = 4,
				ticks = 4 -- On hit + 4 = 5
			},

			-- Covenant
			spearOfBastionCovenant = {
				id = 307865,
				name = "",
				icon = "",
				rage = 25
			},
			condemn = {
				id = 317349,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				healthAbove = 0.8
			},
			conquerorsBanner = {
				id = 324143,
				name = "",
				icon = "",
				duration = 15,
				ticks = 15,
				rage = 4,
				idLegendaryBonus = 7469
			},
			ancientAftershock = {
				id = 325886,
				name = "",
				icon = "",
				duration = 12,
				ticks = 4,
				rage = 4,
				idTick = 326062,
				idLegendaryBonus = 7471,
				legendaryDuration = 3,
				legendaryTicks = 1
			},

			-- Torghast
			voraciousCullingBlade = {
				id = 329214, --Maybe 329213
				name = "",
				icon = ""
			},
		}

		specCache.fury.snapshotData.audio = {
			overcapCue = false
		}
		specCache.fury.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {},
			rend = 0,
		}
		specCache.fury.snapshotData.impendingVictory = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.fury.snapshotData.victoryRush = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.fury.snapshotData.enrage = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.fury.snapshotData.whirlwind = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			stacks = 0
		}
		specCache.fury.snapshotData.bladestorm = {
			endTime = nil,
			duration = 0,
			originalDuration = 0,
			spellId = nil,
			ticksRemaining = 0,
			rage = 0
		}
		specCache.fury.snapshotData.shieldBlock = {
			charges = 0,
			maxCharges = 2,
			startTime = nil,
			duration = 0
		}
		specCache.fury.snapshotData.condemn = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.fury.snapshotData.conquerorsBanner = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.fury.snapshotData.ancientAftershock = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil,
			targetsHit = 0,
			hitTime = nil
		}
		specCache.fury.snapshotData.voraciousCullingBlade = {
			isActive = false
		}
	end

	local function Setup_Arms()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "warrior", "arms")
		TRB.Functions.LoadFromSpecCache(specCache.arms)
	end

	local function Setup_Fury()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.FillSpecCacheSettings(TRB.Data.settings, specCache, "warrior", "fury")
		TRB.Functions.LoadFromSpecCache(specCache.fury)
	end

	local function FillSpellData_Arms()
		Setup_Arms()
		local spells = TRB.Functions.FillSpellData(specCache.arms.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.arms.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Rage generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

            { variable = "#ancientAftershock", icon = spells.ancientAftershock.icon, description = "Ancient Aftershock", printInSettings = true },
			{ variable = "#charge", icon = spells.charge.icon, description = "Charge", printInSettings = true },
			{ variable = "#cleave", icon = spells.cleave.icon, description = "Cleave", printInSettings = true },
            { variable = "#condemn", icon = spells.condemn.icon, description = "Condemn", printInSettings = true },
            { variable = "#conquerorsBanner", icon = spells.conquerorsBanner.icon, description = "Conqueror's Banner", printInSettings = true },
			{ variable = "#covenantAbility", icon = spells.spearOfBastionCovenant.icon .. spells.condemn.icon .. spells.ancientAftershock.icon .. spells.conquerorsBanner.icon, description = "Covenant on-use Ability", printInSettings = true},
			{ variable = "#deadlyCalm", icon = spells.deadlyCalm.icon, description = "Deadly Calm", printInSettings = true },
			{ variable = "#deepWounds", icon = spells.deepWounds.icon, description = "Deep Wounds", printInSettings = true },
			{ variable = "#execute", icon = spells.execute.icon, description = "Execute", printInSettings = true },			
			{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = "Impending Victory", printInSettings = true },
			{ variable = "#mortalStrike", icon = spells.mortalStrike.icon, description = "Mortal Strike", printInSettings = true },
			{ variable = "#ravager", icon = spells.ravager.icon, description = "Ravager", printInSettings = true },
			{ variable = "#rend", icon = spells.rend.icon, description = "Rend", printInSettings = true },
			{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = "Shield Block", printInSettings = true },
			{ variable = "#skullsplitter", icon = spells.skullsplitter.icon, description = "Skullsplitter", printInSettings = true },
			{ variable = "#slam", icon = spells.slam.icon, description = "Slam", printInSettings = true },
            { variable = "#spearOfBastionCovenant", icon = spells.spearOfBastionCovenant.icon, description = "Spear of Bastion", printInSettings = true },
			{ variable = "#victoryRush", icon = spells.victoryRush.icon, description = "Victory Rush", printInSettings = true },
			{ variable = "#voraciousCullingBlade", icon = spells.voraciousCullingBlade.icon, description = spells.voraciousCullingBlade.name, printInSettings = true },
			{ variable = "#whirlwind", icon = spells.whirlwind.icon, description = "Whirlwind", printInSettings = true },			
        }
		specCache.arms.barTextVariables.values = {
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
			{ variable = "$dVers", description = "Current Versatilit y% (damage reduction/defensive)", printInSettings = true, color = false },
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

			{ variable = "$isKyrian", description = "Is the character a member of the |cFF68CCEFKyrian|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the |cFF40BF40Necrolord|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the |cFFA330C9Night Fae|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the |cFFFF4040Venthyr|r Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$rage", description = "Current Rage", printInSettings = true, color = false },
            { variable = "$resource", description = "Current Rage", printInSettings = false, color = false },
			{ variable = "$rageMax", description = "Maximum Rage", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Rage", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Rage from Passive Sources including Ravager and Covenant abilities", printInSettings = true, color = false },
			{ variable = "$ragePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$ragePlusPassive", description = "Current + Passive Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Rage Total", printInSettings = false, color = false },
			{ variable = "$rageTotal", description = "Current + Passive + Casting Rage Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Rage Total", printInSettings = false, color = false },   

			{ variable = "$rend", description = "Is Rend currently talented. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$deepWoundsCount", description = "Number of Deep Wounds active on targets", printInSettings = true, color = false },
			{ variable = "$deepWoundsTime", description = "Time remaining on Deep Wounds on your current target", printInSettings = true, color = false },
			{ variable = "$rendCount", description = "Number of Rends active on targets", printInSettings = true, color = false },
			{ variable = "$rendTime", description = "Time remaining on Rend on your current target", printInSettings = true, color = false },

			{ variable = "$ravagerTicks", description = "Number of expected ticks remaining on Ravager", printInSettings = true, color = false }, 
			{ variable = "$ravagerRage", description = "Rage from Ravager", printInSettings = true, color = false },   

			{ variable = "$ancientAftershockTicks", description = "Number of ticks remaining on Ancient Aftershock", printInSettings = true, color = false }, 
			{ variable = "$ancientAftershockRage", description = "Rage from Ancient Aftershock", printInSettings = true, color = false },   

			{ variable = "$conquerorsBannerRage", description = "Rage from Conqueror's Banner", printInSettings = true, color = false },
			{ variable = "$conquerorsBannerTicks", description = "Number of ticks remaining on Conqueror's Banner", printInSettings = true, color = false },

			{ variable = "$covenantRage", description = "Rage from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityRage", description = "Rage from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },
			{ variable = "$covenantTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },

			{ variable = "$suddenDeathTime", description = "Time remaining on Sudden Death proc", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
            { variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.arms.spells = spells
	end

	local function FillSpellData_Fury()
		Setup_Fury()
		local spells = TRB.Functions.FillSpellData(specCache.fury.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.fury.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Rage generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

            { variable = "#ancientAftershock", icon = spells.ancientAftershock.icon, description = "Ancient Aftershock", printInSettings = true },
			{ variable = "#bladestorm", icon = spells.bladestorm.icon, description = "Bladestorm", printInSettings = true },
			{ variable = "#charge", icon = spells.charge.icon, description = "Charge", printInSettings = true },
            { variable = "#condemn", icon = spells.condemn.icon, description = "Condemn", printInSettings = true },
            { variable = "#conquerorsBanner", icon = spells.conquerorsBanner.icon, description = "Conqueror's Banner", printInSettings = true },
			{ variable = "#covenantAbility", icon = spells.spearOfBastionCovenant.icon .. spells.condemn.icon .. spells.ancientAftershock.icon .. spells.conquerorsBanner.icon, description = "Covenant on-use Ability", printInSettings = true},
			{ variable = "#enrage", icon = spells.enrage.icon, description = "Enrage", printInSettings = true },
			{ variable = "#execute", icon = spells.execute.icon, description = "Execute", printInSettings = true },
			{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = "Impending Victory", printInSettings = true },
			{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = "Shield Block", printInSettings = true },
			{ variable = "#slam", icon = spells.slam.icon, description = "Slam", printInSettings = true },
            { variable = "#spearOfBastionCovenant", icon = spells.spearOfBastionCovenant.icon, description = "Spear of Bastion", printInSettings = true },
			{ variable = "#victoryRush", icon = spells.victoryRush.icon, description = "Victory Rush", printInSettings = true },
			{ variable = "#whirlwind", icon = spells.whirlwind.icon, description = "Whirlwind", printInSettings = true }
        }

		specCache.fury.barTextVariables.values = {
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
			{ variable = "$dVers", description = "Current Versatilit y% (damage reduction/defensive)", printInSettings = true, color = false },
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

			{ variable = "$isKyrian", description = "Is the character a member of the |cFF68CCEFKyrian|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the |cFF40BF40Necrolord|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the |cFFA330C9Night Fae|r Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the |cFFFF4040Venthyr|r Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$rage", description = "Current Rage", printInSettings = true, color = false },
            { variable = "$resource", description = "Current Rage", printInSettings = false, color = false },
			{ variable = "$rageMax", description = "Maximum Rage", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Rage", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Rage from Passive Sources including Ravager and Covenant abilities", printInSettings = true, color = false },
			{ variable = "$ragePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$ragePlusPassive", description = "Current + Passive Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Rage Total", printInSettings = false, color = false },
			{ variable = "$rageTotal", description = "Current + Passive + Casting Rage Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Rage Total", printInSettings = false, color = false },   

			{ variable = "$enrageTime", description = "Time remaining on Enrage", printInSettings = true, color = false },
			
			{ variable = "$whirlwindTime", description = "Time remaining on Whirlwind buff", printInSettings = true, color = false },
			{ variable = "$whirlwindStacks", description = "Number of stacks remaining on Whirlwind buff", printInSettings = true, color = false },
			
			{ variable = "$ancientAftershockTicks", description = "Number of ticks remaining on Ancient Aftershock", printInSettings = true, color = false }, 
			{ variable = "$ancientAftershockRage", description = "Rage from Ancient Aftershock", printInSettings = true, color = false },   

			{ variable = "$conquerorsBannerRage", description = "Rage from Conqueror's Banner", printInSettings = true, color = false },
			{ variable = "$conquerorsBannerTicks", description = "Number of ticks remaining on Conqueror's Banner", printInSettings = true, color = false },

			{ variable = "$covenantRage", description = "Rage from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityRage", description = "Rage from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },
			{ variable = "$covenantTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
            { variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.fury.spells = spells
	end


	local function CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "warrior"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage)

        if specId == 1 then		
			TRB.Data.character.specName = "arms"
			-- Legendaries
			local headItemLink = GetInventoryItemLink("player", 1)
			local neckItemLink = GetInventoryItemLink("player", 2)
			local shoulderItemLink = GetInventoryItemLink("player", 3)
			local chestItemLink = GetInventoryItemLink("player", 5)
			local waistItemLink = GetInventoryItemLink("player", 6)
			local legItemLink = GetInventoryItemLink("player", 7)
			local feetItemLink = GetInventoryItemLink("player", 8)
			local wristItemLink = GetInventoryItemLink("player", 9)
			local handItemLink = GetInventoryItemLink("player", 10)
			local ring1ItemLink = GetInventoryItemLink("player", 11)
			local ring2ItemLink = GetInventoryItemLink("player", 12)
			local backItemLink = GetInventoryItemLink("player", 15)

			local naturesFury = false
			local glory = false

			if TRB.Data.character.covenantId == 3 then
				if headItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(headItemLink, 171415, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
				
				if naturesFury == false and neckItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(neckItemLink, 178927, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
				
				if naturesFury == false and shoulderItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(shoulderItemLink, 171417, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end

				if naturesFury == false and chestItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(chestItemLink, 171412, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
				
				if naturesFury == false and waistItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(waistItemLink, 171418, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end

				if naturesFury == false and legItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(legItemLink, 171416, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end

				if naturesFury == false and feetItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(feetItemLink, 171413, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end

				if naturesFury == false and wristItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(wristItemLink, 171419, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
				
				if naturesFury == false and handItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(handItemLink, 171414, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
				
				if naturesFury == false and ring1ItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(ring1ItemLink, 178926, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
				
				if naturesFury == false and ring2ItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(ring2ItemLink, 178926, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
				
				if naturesFury == false and backItemLink ~= nil  then
					naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(backItemLink, 173242, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
				end
			elseif TRB.Data.character.covenantId == 4 then
				if headItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(headItemLink, 171415, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
				
				if glory == false and neckItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(neckItemLink, 178927, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
				
				if glory == false and shoulderItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(shoulderItemLink, 171417, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end

				if glory == false and chestItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(chestItemLink, 171412, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
				
				if glory == false and waistItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(waistItemLink, 171418, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end

				if glory == false and legItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(legItemLink, 171416, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end

				if glory == false and feetItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(feetItemLink, 171413, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end

				if glory == false and wristItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(wristItemLink, 171419, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
				
				if glory == false and handItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(handItemLink, 171414, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
				
				if glory == false and ring1ItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(ring1ItemLink, 178926, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
				
				if glory == false and ring2ItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(ring2ItemLink, 178926, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
				
				if glory == false and backItemLink ~= nil  then
					glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(backItemLink, 173242, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
				end
			end

			TRB.Data.character.items.naturesFury = naturesFury
			TRB.Data.character.items.glory = glory
        elseif specId == 2 then
			TRB.Data.character.specName = "fury"

			-- Legendaries
			local chestItemLink = GetInventoryItemLink("player", 5)
			local waistItemLink = GetInventoryItemLink("player", 6)
			local wristItemLink = GetInventoryItemLink("player", 9)
			local handItemLink = GetInventoryItemLink("player", 10)
			local backItemLink = GetInventoryItemLink("player", 15)

			local naturesFury = false
			if wristItemLink ~= nil  then
				naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(wristItemLink, 171419, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
			end
			
			if naturesFury == false and handItemLink ~= nil  then
				naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(handItemLink, 171414, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
			end
			
			if naturesFury == false and backItemLink ~= nil  then
				naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(backItemLink, 173242, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
			end
			
			if naturesFury == false and waistItemLink ~= nil  then
				naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(waistItemLink, 171418, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
			end

			local glory = false
			if chestItemLink ~= nil  then
				glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(chestItemLink, 171412, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
			end
			
			if glory == false and waistItemLink ~= nil  then
				glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(waistItemLink, 171418, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
			end

			TRB.Data.character.items.naturesFury = naturesFury
			TRB.Data.character.items.glory = glory
		elseif specId == 3 then
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.warrior.arms == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
			TRB.Data.specSupported = true
		elseif specId == 2 and TRB.Data.settings.core.enabled.warrior.fury == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.fury)
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
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

	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end
		
		local specId = GetSpecialization()

		if guid ~= nil then
			if not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
				if specId == 1 then
					TRB.Data.snapshotData.targetData.targets[guid].rend = false
				elseif specId == 2 then
				end
			end
			TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()
			return true
		end
		return false
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function GetSuddenDeathRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.suddenDeath)
	end
	
	local function GetEnrageRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.enrage)
	end
	
	local function GetWhirlwindRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.whirlwind)
	end

    local function CalculateAbilityResourceValue(resource, includeDeadlyCalm)
        if includeDeadlyCalm == nil then
			includeDeadlyCalm = false
		end

		local modifier = 1.0

		if resource > 0 then

		else
			modifier = modifier * TRB.Data.character.effects.overgrowthSeedlingModifier * TRB.Data.character.torghast.rampaging.spellCostModifier
			if GetSpecialization() == 1 then
				if TRB.Data.spells.deadlyCalm.isActive and includeDeadlyCalm then
					modifier = modifier * TRB.Data.spells.deadlyCalm.modifier
				end
			end
		end

        return resource * modifier
    end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()

		if guid ~= nil and guid ~= "" then
			if not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
				if specId == 1 then
					TRB.Data.snapshotData.targetData.targets[guid].rend = false
					TRB.Data.snapshotData.targetData.targets[guid].rendRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].deepWounds = false
					TRB.Data.snapshotData.targetData.targets[guid].deepWoundsRemaining = 0
				end
			end
			TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()
		end

		return true
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		
		local specId = GetSpecialization()

		if specId == 1 then
			local rendTotal = 0
			local deepWoundsTotal = 0
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshotData.targetData.targets[guid].rend = false
					TRB.Data.snapshotData.targetData.targets[guid].rendRemaining = 0
					TRB.Data.snapshotData.targetData.targets[guid].deepWounds = false
					TRB.Data.snapshotData.targetData.targets[guid].deepWoundsRemaining = 0
				else
					if TRB.Data.snapshotData.targetData.targets[guid].rend == true then
						rendTotal = rendTotal + 1
					end
					if TRB.Data.snapshotData.targetData.targets[guid].deepWounds == true then
						deepWoundsTotal = deepWoundsTotal + 1
					end
				end
			end
			TRB.Data.snapshotData.targetData.rend = rendTotal
			TRB.Data.snapshotData.targetData.deepWounds = deepWoundsTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		local specId = GetSpecialization()

		if specId == 1 then
			if clearAll == true then
				TRB.Data.snapshotData.targetData.rend = 0
				TRB.Data.snapshotData.targetData.deepWounds = 0
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

        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
				if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
				TRB.Functions.SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell.settingKey, settings)

				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
            end
        end

		TRB.Functions.ConstructResourceBar(settings)

		if specId == 1 or specId == 2 then
			TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
		end
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		local normalizedRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.warrior.arms
		elseif specId == 2 then
			settings = TRB.Data.settings.warrior.fury
		end

        if specId == 1 then --Arms
			--[[if var == "$ravagerTicks" then
				if TRB.Data.snapshotData.ravager.isActive then
					valid = true
				end
			elseif var == "$ravagerRage" then
				if TRB.Data.snapshotData.ravager.isActive then
					valid = true
				end
			else]]
			if var == "$suddenDeathTime" then
				if TRB.Data.snapshotData.suddenDeath.isActive then
					valid = true
				end
			elseif var == "$rend" then
				if TRB.Functions.IsTalentActive(TRB.Data.spells.rend) then
					valid = true
				end
			elseif var == "$rendCount" then
				if TRB.Data.snapshotData.targetData.rend > 0 then
					valid = true
				end
			elseif var == "$rendTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining > 0 then
					valid = true
				end
			elseif var == "$deepWoundsCount" then
				if TRB.Data.snapshotData.targetData.deepWounds > 0 then
					valid = true
				end
			elseif var == "$deepWoundsTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining > 0 then
					valid = true
				end
			elseif var == "$resourceTotal" or var == "$rageTotal" then
				if normalizedRage > 0 or TRB.Data.snapshotData.ravager.rage > 0 or TRB.Data.snapshotData.ancientAftershock.rage > 0 or TRB.Data.snapshotData.conquerorsBanner.isActive or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Data.snapshotData.ravager.rage > 0 or TRB.Data.snapshotData.ancientAftershock.rage > 0 or TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
            end
		elseif specId == 2 then --Fury
			if var == "$resourceTotal" or var == "$rageTotal" then
				if normalizedRage > 0 or TRB.Data.snapshotData.ancientAftershock.rage > 0 or TRB.Data.snapshotData.conquerorsBanner.isActive or
					(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Data.snapshotData.ancientAftershock.rage > 0 or TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$enrageTime" then
				if GetEnrageRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$whirlwindTime" then
				if GetWhirlwindRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$whirlwindStacks" then
				if TRB.Data.snapshotData.whirlwind.stacks ~= nil and TRB.Data.snapshotData.whirlwind.stacks > 0 then
					valid = true
				end
			end
		end

		if valid == true then
			return valid
		end

		if var == "$resource" or var == "$rage" then
			if normalizedRage > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$rageMax" then
			valid = true
		elseif var == "$resourcePlusCasting" or var == "$ragePlusCasting" then
			if normalizedRage > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$rageOvercap" or var == "$resourceOvercap" then
			if (normalizedRage + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
			if normalizedRage > 0 or TRB.Data.snapshotData.ravager.rage > 0 or TRB.Data.snapshotData.ancientAftershock.rage > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$ancientAftershockTicks" then
			if TRB.Data.snapshotData.ancientAftershock.isActive then
				valid = true
			end
		elseif var == "$ancientAftershockRage" then
			if TRB.Data.snapshotData.ancientAftershock.isActive then
				valid = true
			end
		elseif var == "$conquerorsBannerTicks" then
			if TRB.Data.snapshotData.conquerorsBanner.isActive then
				valid = true
			end
		elseif var == "$conquerorsBannerRage" then
			if TRB.Data.snapshotData.conquerorsBanner.isActive then
				valid = true
			end
		elseif var == "$covenantTicks" then
			if TRB.Data.snapshotData.ancientAftershock.isActive or TRB.Data.snapshotData.conquerorsBanner.isActive then
				valid = true
			end
		elseif var == "$covenantRage" then
			if TRB.Data.snapshotData.ancientAftershock.isActive or TRB.Data.snapshotData.conquerorsBanner.isActive then
				valid = true
			end
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Arms()
		local _
		local normalizedRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentRageColor = TRB.Data.settings.warrior.arms.colors.text.current
		local castingRageColor = TRB.Data.settings.warrior.arms.colors.text.casting

		if TRB.Data.settings.warrior.arms.colors.text.overcapEnabled and overcap then
			currentRageColor = TRB.Data.settings.warrior.arms.colors.text.overcap
            castingRageColor = TRB.Data.settings.warrior.arms.colors.text.overcap
		elseif TRB.Data.settings.warrior.arms.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentRageColor = TRB.Data.settings.warrior.arms.colors.text.overThreshold
				castingRageColor = TRB.Data.settings.warrior.arms.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingRageColor = TRB.Data.settings.warrior.arms.colors.text.spending
		end

		--$ravagerRage
		local _ravagerRage = TRB.Data.snapshotData.ravager.rage
		local ravagerRage = string.format("%.0f", TRB.Data.snapshotData.ravager.rage)
		--$ravagerTicks
		local ravagerTicks = string.format("%.0f", TRB.Data.snapshotData.ravager.ticksRemaining)
		
		--$ancientAftershockRage
		local _ancientAftershockRage = TRB.Data.snapshotData.ancientAftershock.rage
		local ancientAftershockRage = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.rage)
		--$ancientAftershockTicks
		local ancientAftershockTicks = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.ticksRemaining)
        
		--$conquerorsBannerRage
		local _conquerorsBannerRage = TRB.Data.snapshotData.conquerorsBanner.rage
		local conquerorsBannerRage = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.rage)
		--$conquerorsBannerTicks
		local conquerorsBannerTicks = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.ticksRemaining)
        
		--$suddenDeathTime
		local _suddenDeathTime = GetSuddenDeathRemainingTime()
		local suddenDeathTime
		if _suddenDeathTime ~= nil then
			suddenDeathTime = string.format("%.1f", _suddenDeathTime)
		end

		--$rage
		local ragePrecision = TRB.Data.settings.warrior.arms.ragePrecision or 0
		local currentRage = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(normalizedRage, ragePrecision, "floor"))
		--$casting
		local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, ragePrecision, "floor"))
		--$passive
		local _passiveRage = _ravagerRage + _ancientAftershockRage + _conquerorsBannerRage

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		local passiveRage = string.format("|c%s%s|r", TRB.Data.settings.warrior.arms.colors.text.passive, TRB.Functions.RoundTo(_passiveRage, ragePrecision, "floor"))
		
		--$rageTotal
		local _rageTotal = math.min(_passiveRage + TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local rageTotal = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(_rageTotal, ragePrecision, "floor"))
		--$ragePlusCasting
		local _ragePlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusCasting = string.format("|c%s%s|r", castingRageColor, TRB.Functions.RoundTo(_ragePlusCasting, ragePrecision, "floor"))
		--$ragePlusPassive
		local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusPassive = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(_ragePlusPassive, ragePrecision, "floor"))

		
		--$rendCount and $rendTime
		local _rendCount = TRB.Data.snapshotData.targetData.rend or 0
		local rendCount = tostring(_rendCount)
		local _rendTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_rendTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining or 0
		end

		local rendTime

		local _deepWoundsCount = TRB.Data.snapshotData.targetData.deepWounds or 0
		local deepWoundsCount = tostring(_deepWoundsCount)
		local _deepWoundsTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_deepWoundsTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining or 0
		end

		local deepWoundsTime

		if TRB.Data.settings.warrior.arms.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rend then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining > TRB.Data.spells.rend.pandemicTime then
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining)
				else
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining)
				end
			else
				rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, _rendCount)
				rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWounds then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining > TRB.Data.spells.deepWounds.pandemicTime then
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining)
				else
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining)
				end
			else
				deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, 0)
			end
		else
			rendTime = string.format("%.1f", _rendTime)
			deepWoundsTime = string.format("%.1f", _deepWoundsTime)
		end

		--#covenantAbility
		local covenantAbilityIcon = ""
		local covenantAbilityTicks = "0.0"
		local covenantAbilityRage = "0.0"

		if TRB.Data.character.covenantId == 1 then
			covenantAbilityIcon = TRB.Data.spells.spearOfBastionCovenant.icon
		elseif TRB.Data.character.covenantId == 2 then
			covenantAbilityIcon = TRB.Data.spells.condemn.icon
		elseif TRB.Data.character.covenantId == 3 then
			covenantAbilityIcon = TRB.Data.spells.ancientAftershock.icon
			covenantAbilityRage = ancientAftershockRage
			covenantAbilityTicks = ancientAftershockTicks
		elseif TRB.Data.character.covenantId == 4 then
			covenantAbilityIcon = TRB.Data.spells.conquerorsBanner.icon
			covenantAbilityRage = conquerorsBannerRage
			covenantAbilityTicks = conquerorsBannerTicks
		end
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedRage
		Global_TwintopResourceBar.resource.passive = _passiveRage
		Global_TwintopResourceBar.resource.ravager = _ravagerRage
		Global_TwintopResourceBar.resource.ancientAftershock = _ancientAftershockRage
		Global_TwintopResourceBar.resource.conquerorsBanner = _conquerorsBannerRage
		Global_TwintopResourceBar.dots = {
			rendCount = _rendCount,
			deepWoundsCount = _deepWoundsCount
		}
		Global_TwintopResourceBar.ravager = {
			rage = _ravagerRage,
			ticks = TRB.Data.snapshotData.ravager.ticksRemaining or 0
		}
		Global_TwintopResourceBar.conquerorsBanner = {
			rage = _conquerorsBannerRage,
			ticks = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining or 0
		}
		Global_TwintopResourceBar.ancientAftershock = {
			rage = _ancientAftershockRage,
			ticks = TRB.Data.snapshotData.ancientAftershock.ticksRemaining or 0,
			targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#ancientAftershock"] = TRB.Data.spells.ancientAftershock.icon
		lookup["#charge"] = TRB.Data.spells.charge.icon
		lookup["#cleave"] = TRB.Data.spells.cleave.icon
		lookup["#condemn"] = TRB.Data.spells.condemn.icon
		lookup["#conquerorsBanner"] = TRB.Data.spells.conquerorsBanner.icon
		lookup["#covenantAbility"] = covenantAbilityIcon
		lookup["#deadlyCalm"] = TRB.Data.spells.deadlyCalm.icon
		lookup["#deepWounds"] = TRB.Data.spells.deepWounds.icon
		lookup["#execute"] = TRB.Data.spells.execute.icon
		lookup["#impendingVictory"] = TRB.Data.spells.impendingVictory.icon
		lookup["#mortalStrike"] = TRB.Data.spells.mortalStrike.icon
		lookup["#ravager"] = TRB.Data.spells.ravager.icon
		lookup["#rend"] = TRB.Data.spells.rend.icon
		lookup["#shieldBlock"] = TRB.Data.spells.shieldBlock.icon
		lookup["#skullsplitter"] = TRB.Data.spells.skullsplitter.icon
		lookup["#slam"] = TRB.Data.spells.slam.icon
		lookup["#spearOfBastionCovenant"] = TRB.Data.spells.spearOfBastionCovenant.icon
		lookup["#victoryRush"] = TRB.Data.spells.victoryRush.icon
		lookup["#whirlwind"] = TRB.Data.spells.whirlwind.icon
		lookup["$rend"] = TRB.Functions.IsTalentActive(TRB.Data.spells.rend)
		lookup["$rendCount"] = rendCount
		lookup["$rendTime"] = rendTime
		lookup["$deepWoundsCount"] = deepWoundsCount
		lookup["$deepWoundsTime"] = deepWoundsTime
		lookup["$suddenDeathTime"] = suddenDeathTime
		lookup["$ravagerRage"] = ravagerRage
		lookup["$ravagerTicks"] = ravagerTicks
		lookup["$ancientAftershockRage"] = ancientAftershockRage
		lookup["$ancientAftershockTicks"] = ancientAftershockTicks
		lookup["$conquerorsBannerRage"] = conquerorsBannerRage
		lookup["$conquerorsBannerTicks"] = conquerorsBannerTicks
		lookup["$covenantAbilityRage"] = covenantAbilityRage
		lookup["$covenantRage"] = covenantAbilityRage
		lookup["$covenantAbilityTicks"] = covenantAbilityTicks
		lookup["$covenantTicks"] = covenantAbilityTicks
		lookup["$ragePlusCasting"] = ragePlusCasting
		lookup["$rageTotal"] = rageTotal
		lookup["$rageMax"] = TRB.Data.character.maxResource
		lookup["$rage"] = currentRage
		lookup["$resourcePlusCasting"] = ragePlusCasting
		lookup["$resourcePlusPassive"] = ragePlusPassive
		lookup["$resourceTotal"] = rageTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentRage
		lookup["$casting"] = castingRage
		lookup["$passive"] = passiveRage
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$rageOvercap"] = overcap
		TRB.Data.lookup = lookup
		
		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$rend"] = TRB.Functions.IsTalentActive(TRB.Data.spells.rend)
		lookupLogic["$rendCount"] = _rendCount
		lookupLogic["$rendTime"] = _rendTime
		lookupLogic["$deepWoundsCount"] = _deepWoundsCount
		lookupLogic["$deepWoundsTime"] = _deepWoundsTime
		lookupLogic["$suddenDeathTime"] = _suddenDeathTime
		lookupLogic["$ravagerRage"] = _ravagerRage
		lookupLogic["$ravagerTicks"] = ravagerTicks
		lookupLogic["$ancientAftershockRage"] = _ancientAftershockRage
		lookupLogic["$ancientAftershockTicks"] = ancientAftershockTicks
		lookupLogic["$conquerorsBannerRage"] = _conquerorsBannerRage
		lookupLogic["$conquerorsBannerTicks"] = conquerorsBannerTicks
		lookupLogic["$covenantAbilityRage"] = covenantAbilityRage
		lookupLogic["$covenantRage"] = covenantAbilityRage
		lookupLogic["$covenantAbilityTicks"] = covenantAbilityTicks
		lookupLogic["$covenantTicks"] = covenantAbilityTicks
		lookupLogic["$ragePlusCasting"] = _ragePlusCasting
		lookupLogic["$rageTotal"] = _rageTotal
		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$rage"] = normalizedRage
		lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
		lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
		lookupLogic["$resourceTotal"] = _rageTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedRage
		lookupLogic["$casting"] = TRB.Data.snapshotData.casting.resourceFinal
		lookupLogic["$passive"] = _passiveRage
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$rageOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Fury()
		local _
		local normalizedRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentRageColor = TRB.Data.settings.warrior.fury.colors.text.current
		local castingRageColor = TRB.Data.settings.warrior.fury.colors.text.casting

		if TRB.Data.settings.warrior.fury.colors.text.overcapEnabled and overcap then
			currentRageColor = TRB.Data.settings.warrior.fury.colors.text.overcap
            castingRageColor = TRB.Data.settings.warrior.fury.colors.text.overcap
		elseif TRB.Data.settings.warrior.fury.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentRageColor = TRB.Data.settings.warrior.fury.colors.text.overThreshold
				castingRageColor = TRB.Data.settings.warrior.fury.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingRageColor = TRB.Data.settings.warrior.fury.colors.text.spending
		end

		--$ancientAftershockRage
		local _ancientAftershockRage = TRB.Data.snapshotData.ancientAftershock.rage
		local ancientAftershockRage = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.rage)
		--$ancientAftershockTicks
		local ancientAftershockTicks = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.ticksRemaining)
        
		--$conquerorsBannerRage
		local _conquerorsBannerRage = TRB.Data.snapshotData.conquerorsBanner.rage
		local conquerorsBannerRage = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.rage)
		--$conquerorsBannerTicks
		local conquerorsBannerTicks = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.ticksRemaining)
        
		--$rage
		local ragePrecision = TRB.Data.settings.warrior.fury.ragePrecision or 0
		local currentRage = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(normalizedRage, ragePrecision, "floor"))
		--$casting
		local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, ragePrecision, "floor"))
		--$passive
		local _passiveRage = _ancientAftershockRage + _conquerorsBannerRage

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		local passiveRage = string.format("|c%s%s|r", TRB.Data.settings.warrior.fury.colors.text.passive, TRB.Functions.RoundTo(_passiveRage, ragePrecision, "floor"))
		
		--$rageTotal
		local _rageTotal = math.min(_passiveRage + TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local rageTotal = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(_rageTotal, ragePrecision, "floor"))
		--$ragePlusCasting
		local _ragePlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusCasting = string.format("|c%s%s|r", castingRageColor, TRB.Functions.RoundTo(_ragePlusCasting, ragePrecision, "floor"))
		--$ragePlusPassive
		local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusPassive = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(_ragePlusPassive, ragePrecision, "floor"))

		--$enrageTime
		local _enrageTime = GetEnrageRemainingTime()
		local enrageTime = string.format("%.1f", _enrageTime)
		
		--$whirlwindTime
		local _whirlwindTime = GetWhirlwindRemainingTime()
		local whirlwindTime = string.format("%.1f", _whirlwindTime)
		--$whirlwindStacks
		local whirlwindStacks = TRB.Data.snapshotData.whirlwind.stacks or 0

		--#covenantAbility
		local covenantAbilityIcon = ""
		local covenantAbilityTicks = "0.0"
		local covenantAbilityRage = "0.0"

		if TRB.Data.character.covenantId == 1 then
			covenantAbilityIcon = TRB.Data.spells.spearOfBastionCovenant.icon
		elseif TRB.Data.character.covenantId == 2 then
			covenantAbilityIcon = TRB.Data.spells.condemn.icon
		elseif TRB.Data.character.covenantId == 3 then
			covenantAbilityIcon = TRB.Data.spells.ancientAftershock.icon
			covenantAbilityRage = ancientAftershockRage
			covenantAbilityTicks = ancientAftershockTicks
		elseif TRB.Data.character.covenantId == 4 then
			covenantAbilityIcon = TRB.Data.spells.conquerorsBanner.icon
			covenantAbilityRage = conquerorsBannerRage
			covenantAbilityTicks = conquerorsBannerTicks
		end
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedRage
		Global_TwintopResourceBar.resource.passive = _passiveRage
		Global_TwintopResourceBar.resource.ancientAftershock = _ancientAftershockRage
		Global_TwintopResourceBar.resource.conquerorsBanner = _conquerorsBannerRage
		Global_TwintopResourceBar.conquerorsBanner = {
			rage = _conquerorsBannerRage,
			ticks = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining or 0
		}
		Global_TwintopResourceBar.ancientAftershock = {
			rage = _ancientAftershockRage,
			ticks = TRB.Data.snapshotData.ancientAftershock.ticksRemaining or 0,
			targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#ancientAftershock"] = TRB.Data.spells.ancientAftershock.icon
		lookup["#bladestorm"] = TRB.Data.spells.bladestorm.icon
		lookup["#charge"] = TRB.Data.spells.charge.icon
		lookup["#condemn"] = TRB.Data.spells.condemn.icon
		lookup["#conquerorsBanner"] = TRB.Data.spells.conquerorsBanner.icon
		lookup["#covenantAbility"] = covenantAbilityIcon
		lookup["#enrage"] = TRB.Data.spells.enrage.icon
		lookup["#execute"] = TRB.Data.spells.execute.icon
		lookup["#impendingVictory"] = TRB.Data.spells.impendingVictory.icon
		lookup["#shieldBlock"] = TRB.Data.spells.shieldBlock.icon
		lookup["#slam"] = TRB.Data.spells.slam.icon
		lookup["#spearOfBastionCovenant"] = TRB.Data.spells.spearOfBastionCovenant.icon
		lookup["#victoryRush"] = TRB.Data.spells.victoryRush.icon
		lookup["#whirlwind"] = TRB.Data.spells.whirlwind.icon
		lookup["$enrageTime"] = enrageTime
		lookup["$whirlwindTime"] = whirlwindTime
		lookup["$whirlwindStacks"] = whirlwindStacks
		lookup["$ancientAftershockRage"] = ancientAftershockRage
		lookup["$ancientAftershockTicks"] = ancientAftershockTicks
		lookup["$conquerorsBannerRage"] = conquerorsBannerRage
		lookup["$conquerorsBannerTicks"] = conquerorsBannerTicks
		lookup["$covenantAbilityRage"] = covenantAbilityRage
		lookup["$covenantRage"] = covenantAbilityRage
		lookup["$covenantAbilityTicks"] = covenantAbilityTicks
		lookup["$covenantTicks"] = covenantAbilityTicks
		lookup["$ragePlusCasting"] = ragePlusCasting
		lookup["$rageTotal"] = rageTotal
		lookup["$rageMax"] = TRB.Data.character.maxResource
		lookup["$rage"] = currentRage
		lookup["$resourcePlusCasting"] = ragePlusCasting
		lookup["$resourcePlusPassive"] = ragePlusPassive
		lookup["$resourceTotal"] = rageTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentRage
		lookup["$casting"] = castingRage
		lookup["$passive"] = passiveRage
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$rageOvercap"] = overcap
		TRB.Data.lookup = lookup


		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$enrageTime"] = _enrageTime
		lookupLogic["$whirlwindTime"] = _whirlwindTime
		lookupLogic["$whirlwindStacks"] = whirlwindStacks
		lookupLogic["$ancientAftershockRage"] = _ancientAftershockRage
		lookupLogic["$ancientAftershockTicks"] = ancientAftershockTicks
		lookupLogic["$conquerorsBannerRage"] = _conquerorsBannerRage
		lookupLogic["$conquerorsBannerTicks"] = conquerorsBannerTicks
		lookupLogic["$covenantAbilityRage"] = covenantAbilityRage
		lookupLogic["$covenantRage"] = covenantAbilityRage
		lookupLogic["$covenantAbilityTicks"] = covenantAbilityTicks
		lookupLogic["$covenantTicks"] = covenantAbilityTicks
		lookupLogic["$ragePlusCasting"] = _ragePlusCasting
		lookupLogic["$rageTotal"] = _rageTotal
		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$rage"] = normalizedRage
		lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
		lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
		lookupLogic["$resourceTotal"] = _rageTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedRage
		lookupLogic["$casting"] = TRB.Data.snapshotData.casting.resourceFinal
		lookupLogic["$passive"] = _passiveRage
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$rageOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.rage
        TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.rage)
        TRB.Data.snapshotData.casting.spellId = spell.id
        TRB.Data.snapshotData.casting.icon = spell.icon
    end

	local function CastingSpell()
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			if specId == 2 and TRB.Data.snapshotData.bladestorm.isActive then
				return true
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					TRB.Functions.ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					TRB.Functions.ResetCastingSnapshotData()
					return false
				end
			elseif specId == 2 then
				if currentSpellName == nil then
					TRB.Functions.ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					TRB.Functions.ResetCastingSnapshotData()
					return false
				end
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateRavager()
		if TRB.Data.snapshotData.ravager.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.ravager.endTime == nil or currentTime > TRB.Data.snapshotData.ravager.endTime then
				TRB.Data.snapshotData.ravager.ticksRemaining = 0
				TRB.Data.snapshotData.ravager.endTime = nil
				TRB.Data.snapshotData.ravager.rage = 0
				TRB.Data.snapshotData.ravager.isActive = false
				TRB.Data.snapshotData.ravager.totalDuration = 0
			else
				local ticksRemaining = math.ceil((TRB.Data.snapshotData.ravager.endTime - currentTime) / (TRB.Data.snapshotData.ravager.totalDuration / TRB.Data.spells.ravager.ticks))
				
				if ticksRemaining < TRB.Data.snapshotData.ravager.ticksRemaining then
					TRB.Data.snapshotData.ravager.ticksRemaining = ticksRemaining
				end

				TRB.Data.snapshotData.ravager.rage = TRB.Data.snapshotData.ravager.ticksRemaining * TRB.Data.spells.ravager.rage				
				if TRB.Data.snapshotData.ravager.rage < 0 then
					TRB.Data.snapshotData.ravager.rage = 0
				end
			end
		end
	end

	local function UpdateAncientAftershock()
		if TRB.Data.snapshotData.ancientAftershock.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.ancientAftershock.endTime == nil or currentTime > TRB.Data.snapshotData.ancientAftershock.endTime then
				TRB.Data.snapshotData.ancientAftershock.ticksRemaining = 0
				TRB.Data.snapshotData.ancientAftershock.endTime = nil
				TRB.Data.snapshotData.ancientAftershock.rage = 0
				TRB.Data.snapshotData.ancientAftershock.isActive = false
				TRB.Data.snapshotData.ancientAftershock.hitTime = nil
				TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
				TRB.Data.snapshotData.ancientAftershock.lastTick = nil
			else
				local ticksRemaining = math.ceil((TRB.Data.snapshotData.ancientAftershock.endTime - currentTime) / (TRB.Data.spells.ancientAftershock.duration / TRB.Data.spells.ancientAftershock.ticks))
				TRB.Data.snapshotData.ancientAftershock.ticksRemaining = ticksRemaining
				TRB.Data.snapshotData.ancientAftershock.rage = TRB.Data.snapshotData.ancientAftershock.ticksRemaining * TRB.Data.spells.ancientAftershock.rage * TRB.Data.snapshotData.ancientAftershock.targetsHit
			end
		end
	end

	local function UpdateConquerorsBanner()
		if TRB.Data.snapshotData.conquerorsBanner.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.conquerorsBanner.endTime ~= nil and currentTime > TRB.Data.snapshotData.conquerorsBanner.endTime then
				TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = 0
				TRB.Data.snapshotData.conquerorsBanner.endTime = nil
				TRB.Data.snapshotData.conquerorsBanner.duration = 0
				TRB.Data.snapshotData.conquerorsBanner.rage = 0
				TRB.Data.snapshotData.conquerorsBanner.isActive = false
			elseif TRB.Data.snapshotData.conquerorsBanner.endTime ~= nil then
				_, _, _, _, TRB.Data.snapshotData.conquerorsBanner.duration, TRB.Data.snapshotData.conquerorsBanner.endTime, _, _, _, TRB.Data.snapshotData.conquerorsBanner.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.conquerorsBanner.id)
				TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = math.ceil((TRB.Data.snapshotData.conquerorsBanner.endTime - currentTime) / (TRB.Data.spells.conquerorsBanner.duration / TRB.Data.spells.conquerorsBanner.ticks))
				TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.rage
			end
		end
	end

	local function UpdateBladestorm()
		if TRB.Data.snapshotData.bladestorm.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.bladestorm.endTime ~= nil and currentTime > TRB.Data.snapshotData.bladestorm.endTime then
				TRB.Data.snapshotData.bladestorm.ticksRemaining = 0
				TRB.Data.snapshotData.bladestorm.endTime = nil
				TRB.Data.snapshotData.bladestorm.duration = 0
				TRB.Data.snapshotData.bladestorm.rage = 0
				TRB.Data.snapshotData.bladestorm.isActive = false
			elseif TRB.Data.snapshotData.bladestorm.endTime ~= nil then
				_, _, _, _, TRB.Data.snapshotData.bladestorm.duration, TRB.Data.snapshotData.bladestorm.endTime, _, _, _, TRB.Data.snapshotData.bladestorm.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.bladestorm.id)
				TRB.Data.snapshotData.bladestorm.ticksRemaining = math.ceil((TRB.Data.snapshotData.bladestorm.endTime - currentTime) / (TRB.Data.snapshotData.bladestorm.originalDuration / TRB.Data.spells.bladestorm.ticks))
				TRB.Data.snapshotData.bladestorm.rage = TRB.Data.snapshotData.bladestorm.ticksRemaining * TRB.Data.spells.bladestorm.rage
				TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.snapshotData.bladestorm.rage
				TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.bladestorm.rage
			end
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		UpdateAncientAftershock()
		UpdateConquerorsBanner()
		local currentTime = GetTime()
		TRB.Data.spells.voraciousCullingBlade.isActive = select(10, TRB.Functions.FindBuffById(TRB.Data.spells.voraciousCullingBlade.id))

		if TRB.Data.snapshotData.impendingVictory.startTime ~= nil and currentTime > (TRB.Data.snapshotData.impendingVictory.startTime + TRB.Data.snapshotData.impendingVictory.duration) then
			TRB.Data.snapshotData.impendingVictory.startTime = nil
            TRB.Data.snapshotData.impendingVictory.duration = 0
		elseif TRB.Data.snapshotData.impendingVictory.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshotData.impendingVictory.startTime, TRB.Data.snapshotData.impendingVictory.duration, _, _ = GetSpellCooldown(TRB.Data.spells.impendingVictory.id)
        end

---@diagnostic disable-next-line: redundant-parameter, cast-local-type
		TRB.Data.snapshotData.shieldBlock.charges, TRB.Data.snapshotData.shieldBlock.maxCharges, TRB.Data.snapshotData.shieldBlock.startTime, TRB.Data.snapshotData.shieldBlock.duration, _ = GetSpellCharges(TRB.Data.spells.shieldBlock.id)
	end

	local function UpdateSnapshot_Arms()
		UpdateSnapshot()
		UpdateRavager()

		local currentTime = GetTime()
		local _

        if TRB.Data.snapshotData.mortalStrike.startTime ~= nil and currentTime > (TRB.Data.snapshotData.mortalStrike.startTime + TRB.Data.snapshotData.mortalStrike.duration) then
			TRB.Data.snapshotData.mortalStrike.startTime = nil
            TRB.Data.snapshotData.mortalStrike.duration = 0
		elseif TRB.Data.snapshotData.mortalStrike.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.mortalStrike.startTime, TRB.Data.snapshotData.mortalStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.mortalStrike.id)
        end

		if TRB.Data.snapshotData.cleave.startTime ~= nil and currentTime > (TRB.Data.snapshotData.cleave.startTime + TRB.Data.snapshotData.cleave.duration) then
            TRB.Data.snapshotData.cleave.startTime = nil
            TRB.Data.snapshotData.cleave.duration = 0
		elseif TRB.Data.snapshotData.cleave.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.cleave.startTime, TRB.Data.snapshotData.cleave.duration, _, _ = GetSpellCooldown(TRB.Data.spells.cleave.id)
        end

		_, _, _, _, TRB.Data.snapshotData.suddenDeath.duration, TRB.Data.snapshotData.suddenDeath.endTime, _, _, _, TRB.Data.snapshotData.suddenDeath.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.suddenDeath.id, "player")
		_, _, TRB.Data.snapshotData.deadlyCalm.stacks, _, TRB.Data.snapshotData.deadlyCalm.duration, TRB.Data.snapshotData.deadlyCalm.endTime, _, _, _, TRB.Data.snapshotData.deadlyCalm.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.deadlyCalm.id, "player")
		
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rend then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.rend.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWounds then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.deepWounds.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Fury()
		UpdateSnapshot()
		UpdateBladestorm()

		local currentTime = GetTime()
		local _

		_, _, TRB.Data.snapshotData.whirlwind.stacks, _, TRB.Data.snapshotData.whirlwind.duration, TRB.Data.snapshotData.whirlwind.endTime, _, _, _, TRB.Data.snapshotData.whirlwind.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.whirlwind.id, "player")
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.warrior.arms.displayBar.alwaysShow) and (
						(not TRB.Data.settings.warrior.arms.displayBar.notZeroShow) or
						(TRB.Data.settings.warrior.arms.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.warrior.arms.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.warrior.fury.displayBar.alwaysShow) and (
						(not TRB.Data.settings.warrior.fury.displayBar.notZeroShow) or
						(TRB.Data.settings.warrior.fury.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.warrior.fury.displayBar.neverShow == true then
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
			UpdateSnapshot_Arms()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.warrior.arms, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.warrior.arms.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					if TRB.Data.settings.warrior.arms.bar.showPassive then
						if TRB.Data.snapshotData.ravager.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.ravager.rage
						end

						if TRB.Data.snapshotData.ancientAftershock.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.ancientAftershock.rage
						end

						if TRB.Data.snapshotData.conquerorsBanner.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.conquerorsBanner.rage
						end
					end

					if CastingSpell() and TRB.Data.settings.warrior.arms.bar.showCasting then
						castingBarValue = currentRage + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentRage
					end

					if castingBarValue < currentRage then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, resourceFrame, castingBarValue) 
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, passiveFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, castingFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, resourceFrame, currentRage)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.arms, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.arms.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local rageAmount = CalculateAbilityResourceValue(spell.rage)
							local normalizedRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

							if not (spell.id == TRB.Data.spells.execute.id or spell.id == TRB.Data.spells.condemn.id) then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholds.width, -rageAmount, TRB.Data.character.maxResource)
							end

							local showThreshold = true
							local isUsable = true -- Could use it if we had enough rage, e.g. not on CD
							local thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
								isUsable = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.execute.id or spell.id == TRB.Data.spells.condemn.id then
									local showThis = true
									if spell.id == TRB.Data.spells.execute.id and TRB.Data.character.covenantId == 2 then
										showThis = false
									elseif spell.id == TRB.Data.spells.condemn.id and TRB.Data.character.covenantId ~= 2 then
										showThis = false
									end

									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local healthMinimum = TRB.Data.spells.execute.healthMinimum
									
									if TRB.Functions.IsTalentActive(TRB.Data.spells.massacre) then
										healthMinimum = TRB.Data.spells.massacre.healthMinimum
									end

									if spell.settingKey == "condemn" or spell.settingKey == "execute" then
										if GetSuddenDeathRemainingTime() > 0 then
											TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholds.width, -TRB.Data.spells.execute.rageMax, TRB.Data.character.maxResource)
										else
											TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholds.width, math.min(math.max(-rageAmount, normalizedRage), -TRB.Data.spells.execute.rageMax), TRB.Data.character.maxResource)
										end
									else
										TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholds.width, -rageAmount, TRB.Data.character.maxResource)
									end

									if not showThis or UnitIsDeadOrGhost("target") or targetUnitHealth == nil then
										showThreshold = false
										isUsable = false
									elseif spell.settingKey == "condemnMinimum" and not TRB.Data.spells.voraciousCullingBlade.isActive and ((targetUnitHealth <= TRB.Data.spells.condemnMinimum.healthAbove and targetUnitHealth >= healthMinimum)) then
										showThreshold = false
										isUsable = false
									elseif spell.settingKey == "executeMinimum" and not TRB.Data.spells.voraciousCullingBlade.isActive and (targetUnitHealth >= healthMinimum) then
										showThreshold = false
										isUsable = false
									elseif spell.settingKey == "condemnMaximum" and not TRB.Data.spells.voraciousCullingBlade.isActive and ((targetUnitHealth <= TRB.Data.spells.condemnMaximum.healthAbove and targetUnitHealth >= healthMinimum)) then
										showThreshold = false
										isUsable = false
									elseif spell.settingKey == "executeMaximum" and not TRB.Data.spells.voraciousCullingBlade.isActive and (targetUnitHealth >= healthMinimum) then
										showThreshold = false
										isUsable = false
									elseif spell.settingKey == "condemn" and not TRB.Data.spells.voraciousCullingBlade.isActive and ((targetUnitHealth <= TRB.Data.spells.condemn.healthAbove and targetUnitHealth >= healthMinimum)) then
										showThreshold = false
										isUsable = false
									elseif spell.settingKey == "execute" and not TRB.Data.spells.voraciousCullingBlade.isActive and (targetUnitHealth >= healthMinimum) then
										showThreshold = false
										isUsable = false
									elseif currentRage >= -rageAmount then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.impendingVictory.id then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount or TRB.Data.spells.victoryRush.isActive then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.shieldBlock.id then
									if TRB.Data.snapshotData.shieldBlock.charges == 0 then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									isUsable = false
								elseif currentRage >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentRage >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							if TRB.Data.settings.warrior.arms.thresholds[spell.settingKey].enabled and showThreshold then
								if isUsable and TRB.Data.snapshotData.deadlyCalm.stacks ~= nil and TRB.Data.snapshotData.deadlyCalm.stacks > 0 then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									frameLevel = TRB.Data.constants.frameLevels.thresholdOver
								end

								if not spell.hasCooldown then
									frameLevel = frameLevel - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown
								end

								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == TRB.Data.constants.frameLevels.thresholdOver then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
								
                                if TRB.Data.settings.warrior.arms.thresholds.icons.showCooldown and spell.hasCooldown and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) and (TRB.Data.snapshotData[spell.settingKey].maxCharges == nil or TRB.Data.snapshotData[spell.settingKey].charges < TRB.Data.snapshotData[spell.settingKey].maxCharges) then
									TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetCooldown(TRB.Data.snapshotData[spell.settingKey].startTime, TRB.Data.snapshotData[spell.settingKey].duration)
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
						pairOffset = pairOffset + 3
					end

					local barColor = TRB.Data.settings.warrior.arms.colors.bar.base
					local barBorderColor = TRB.Data.settings.warrior.arms.colors.bar.border

					if TRB.Data.settings.warrior.arms.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.warrior.arms.colors.bar.borderOvercap

						if TRB.Data.settings.warrior.arms.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.warrior.arms.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.warrior.arms, refreshText)
		elseif specId == 2 then
			UpdateSnapshot_Fury()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.warrior.fury, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.warrior.fury.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					if TRB.Data.settings.warrior.fury.bar.showPassive then
						if TRB.Data.snapshotData.ancientAftershock.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.ancientAftershock.rage
						end

						if TRB.Data.snapshotData.conquerorsBanner.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.conquerorsBanner.rage
						end
					end

					if CastingSpell() and TRB.Data.settings.warrior.fury.bar.showCasting then
						castingBarValue = currentRage + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentRage
					end

					if castingBarValue < currentRage then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, passiveFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, castingFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, resourceFrame, currentRage)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.warrior.fury, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then							
							local rageAmount = CalculateAbilityResourceValue(spell.rage)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.fury, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.fury.thresholds.width, -rageAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local isUsable = true -- Could use it if we had enough rage, e.g. not on CD
							local thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isTalent and not TRB.Functions.IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
								isUsable = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.impendingVictory.id then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount or TRB.Data.spells.victoryRush.isActive then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.shieldBlock.id then
									if TRB.Data.snapshotData.shieldBlock.charges == 0 then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									isUsable = false
								elseif currentRage >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentRage >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							if TRB.Data.settings.warrior.fury.thresholds[spell.settingKey].enabled and showThreshold then
								if not spell.hasCooldown then
									frameLevel = frameLevel - TRB.Data.constants.frameLevels.thresholdOffsetNoCooldown
								end

								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetLine)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetIcon)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetFrameLevel(frameLevel-pairOffset-TRB.Data.constants.frameLevels.thresholdOffsetCooldown)
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
---@diagnostic disable-next-line: undefined-field
								resourceFrame.thresholds[spell.thresholdId].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(thresholdColor, true))
								if frameLevel == TRB.Data.constants.frameLevels.thresholdOver then
									spell.thresholdUsable = true
								else
									spell.thresholdUsable = false
								end
								
                                if TRB.Data.settings.warrior.fury.thresholds.icons.showCooldown and spell.hasCooldown and TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) and (TRB.Data.snapshotData[spell.settingKey].maxCharges == nil or TRB.Data.snapshotData[spell.settingKey].charges < TRB.Data.snapshotData[spell.settingKey].maxCharges) then
									TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetCooldown(TRB.Data.snapshotData[spell.settingKey].startTime, TRB.Data.snapshotData[spell.settingKey].duration)
								else
									TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon.cooldown:SetCooldown(0, 0)
								end
							else
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
								spell.thresholdUsable = false
							end
						end
						pairOffset = pairOffset + 3
					end

					local barColor = TRB.Data.settings.warrior.fury.colors.bar.base

					if GetEnrageRemainingTime() > 0 then
						barColor = TRB.Data.settings.warrior.fury.colors.bar.enrage
					end

					local barBorderColor = TRB.Data.settings.warrior.fury.colors.bar.border

					if TRB.Data.settings.warrior.fury.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.warrior.fury.colors.bar.borderOvercap

						if TRB.Data.settings.warrior.fury.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.warrior.fury.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.warrior.fury, refreshText)
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		if GetSpecialization() ~= 1 and GetSpecialization() ~= 2 then
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
				if specId == 1 then --Arms
					if spellId == TRB.Data.spells.mortalStrike.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.mortalStrike.startTime, TRB.Data.snapshotData.mortalStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.mortalStrike.id)
						end
					elseif spellId == TRB.Data.spells.cleave.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.cleave.startTime, TRB.Data.snapshotData.cleave.duration, _, _ = GetSpellCooldown(TRB.Data.spells.cleave.id)
						end
					elseif spellId == TRB.Data.spells.deadlyCalm.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, TRB.Data.snapshotData.deadlyCalm.stacks, _, TRB.Data.snapshotData.deadlyCalm.duration, TRB.Data.snapshotData.deadlyCalm.endTime, _, _, _, TRB.Data.snapshotData.deadlyCalm.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.deadlyCalm.id, "player")
							TRB.Data.spells.deadlyCalm.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.deadlyCalm.endTime = nil
							TRB.Data.snapshotData.deadlyCalm.duration = 0
							TRB.Data.snapshotData.deadlyCalm.stacks = 0
							TRB.Data.spells.deadlyCalm.isActive = false
						end
					elseif spellId == TRB.Data.spells.suddenDeath.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, _, _, TRB.Data.snapshotData.suddenDeath.duration, TRB.Data.snapshotData.suddenDeath.endTime, _, _, _, TRB.Data.snapshotData.suddenDeath.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.suddenDeath.id)
							TRB.Data.spells.suddenDeath.isActive = true
							
							if TRB.Data.settings.warrior.arms.audio.suddenDeath.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.suddenDeath.endTime = nil
							TRB.Data.snapshotData.suddenDeath.duration = 0
							TRB.Data.snapshotData.suddenDeath.spellId = nil
							TRB.Data.spells.suddenDeath.isActive = false
						end
					elseif spellId == TRB.Data.spells.ravager.id then
						if type == "SPELL_CAST_SUCCESS" then -- Ravager used
							TRB.Data.snapshotData.ravager.isActive = true
							TRB.Data.snapshotData.ravager.totalDuration = TRB.Data.spells.ravager.duration * (TRB.Functions.GetCurrentGCDTime(true) / 1.5)
							TRB.Data.snapshotData.ravager.ticksRemaining = TRB.Data.spells.ravager.ticks
							TRB.Data.snapshotData.ravager.rage = TRB.Data.snapshotData.ravager.ticksRemaining * TRB.Data.spells.ravager.rage
							TRB.Data.snapshotData.ravager.endTime = currentTime + TRB.Data.snapshotData.ravager.totalDuration
							TRB.Data.snapshotData.ravager.lastTick = currentTime
							if TRB.Data.snapshotData.ravager.rage < 0 then
								TRB.Data.snapshotData.ravager.rage = 0
							end
						end
					elseif spellId == TRB.Data.spells.ravager.energizeId then
						if type == "SPELL_ENERGIZE" then						
							TRB.Data.snapshotData.ravager.ticksRemaining = TRB.Data.snapshotData.ravager.ticksRemaining - 1
							if TRB.Data.snapshotData.ravager.ticksRemaining == 0 then
								TRB.Data.snapshotData.ravager.ticksRemaining = 0
								TRB.Data.snapshotData.ravager.endTime = nil
								TRB.Data.snapshotData.ravager.rage = 0
								TRB.Data.snapshotData.ravager.isActive = false
								TRB.Data.snapshotData.ravager.totalDuration = 0
							else
								TRB.Data.snapshotData.ravager.rage = TRB.Data.snapshotData.ravager.ticksRemaining * TRB.Data.spells.ravager.rage
								TRB.Data.snapshotData.ravager.lastTick = currentTime
								if TRB.Data.snapshotData.ravager.rage < 0 then
									TRB.Data.snapshotData.ravager.rage = 0
								end
							end
						end
					elseif spellId == TRB.Data.spells.rend.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rend Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].rend = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.rend = TRB.Data.snapshotData.targetData.rend + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].rend = false
								TRB.Data.snapshotData.targetData.targets[destGUID].rendRemaining = 0
								TRB.Data.snapshotData.targetData.rend = TRB.Data.snapshotData.targetData.rend - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.deepWounds.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Deep Wounds Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].deepWounds = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshotData.targetData.deepWounds = TRB.Data.snapshotData.targetData.deepWounds + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].deepWounds = false
								TRB.Data.snapshotData.targetData.targets[destGUID].deepWoundsRemaining = 0
								TRB.Data.snapshotData.targetData.deepWounds = TRB.Data.snapshotData.targetData.deepWounds - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					end
				elseif specId == 2 then
					if spellId == TRB.Data.spells.bladestorm.id then
						if type == "SPELL_AURA_APPLIED" then
							_, _, _, _, TRB.Data.snapshotData.bladestorm.duration, TRB.Data.snapshotData.bladestorm.endTime, _, _, _, TRB.Data.snapshotData.bladestorm.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.bladestorm.id)
							TRB.Data.snapshotData.bladestorm.originalDuration = TRB.Data.snapshotData.bladestorm.duration
							TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.bladestorm.id
							TRB.Data.snapshotData.casting.icon = TRB.Data.spells.bladestorm.icon
							TRB.Data.snapshotData.bladestorm.isActive = true
							UpdateBladestorm()
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.bladestorm.ticksRemaining = 0
							TRB.Data.snapshotData.bladestorm.endTime = nil
							TRB.Data.snapshotData.bladestorm.duration = 0
							TRB.Data.snapshotData.bladestorm.originalDuration = 0
							TRB.Data.snapshotData.bladestorm.rage = 0
							TRB.Data.snapshotData.bladestorm.isActive = false
						end
					elseif spellId == TRB.Data.spells.enrage.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, _, _, TRB.Data.snapshotData.enrage.duration, TRB.Data.snapshotData.enrage.endTime, _, _, _, TRB.Data.snapshotData.enrage.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.enrage.id)
							TRB.Data.spells.enrage.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.enrage.endTime = nil
							TRB.Data.snapshotData.enrage.duration = 0
							TRB.Data.spells.enrage.isActive = false
						end
					elseif spellId == TRB.Data.spells.whirlwind.id then
						if type == "SPELL_CAST_SUCCESS" then
							_, _, TRB.Data.snapshotData.whirlwind.stacks, _, TRB.Data.snapshotData.whirlwind.duration, TRB.Data.snapshotData.whirlwind.endTime, _, _, _, TRB.Data.snapshotData.whirlwind.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.whirlwind.id, "player")
						end
					end
				end

				-- Spec Agnostic
				if spellId == TRB.Data.spells.impendingVictory.id then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.impendingVictory.startTime, TRB.Data.snapshotData.impendingVictory.duration, _, _ = GetSpellCooldown(TRB.Data.spells.impendingVictory.id)
					end
				elseif spellId == TRB.Data.spells.thunderClap.id then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.thunderClap.startTime, TRB.Data.snapshotData.thunderClap.duration, _, _ = GetSpellCooldown(TRB.Data.spells.thunderClap.id)
					end
				elseif spellId == TRB.Data.spells.execute.id and not TRB.Functions.IsTalentActive(TRB.Data.spells.improvedExecute) then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.execute.startTime, TRB.Data.snapshotData.execute.duration, _, _ = GetSpellCooldown(TRB.Data.spells.execute.id)
					end
				elseif spellId == TRB.Data.spells.whirlwind.id then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.whirlwind.startTime, TRB.Data.snapshotData.whirlwind.duration, _, _ = GetSpellCooldown(TRB.Data.spells.whirlwind.id)
					end
				elseif spellId == TRB.Data.spells.victoryRush.id then
					if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
						_, _, _, _, TRB.Data.snapshotData.victoryRush.duration, TRB.Data.snapshotData.victoryRush.endTime, _, _, _, TRB.Data.snapshotData.victoryRush.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.victoryRush.id)
						TRB.Data.spells.victoryRush.isActive = true
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.snapshotData.victoryRush.endTime = nil
						TRB.Data.snapshotData.victoryRush.duration = 0
						TRB.Data.spells.victoryRush.isActive = false
					end
				elseif spellId == TRB.Data.spells.shieldBlock.id then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshotData.shieldBlock.charges, TRB.Data.snapshotData.shieldBlock.maxCharges, TRB.Data.snapshotData.shieldBlock.startTime, TRB.Data.snapshotData.shieldBlock.duration, _ = GetSpellCharges(TRB.Data.spells.shieldBlock.id)
					end
				elseif spellId == TRB.Data.spells.ancientAftershock.id then
					local legendaryDuration = 0
					local legendaryTicks = 0
					if TRB.Data.character.items.naturesFury == true then
						legendaryDuration = TRB.Data.snapshotData.ancientAftershock.legendaryDuration
						legendaryTicks = TRB.Data.snapshotData.ancientAftershock.legendaryTicks
					end

					if type == "SPELL_CAST_SUCCESS" then -- This is incase it doesn't hit any targets
						if TRB.Data.snapshotData.ancientAftershock.hitTime == nil then --This is a new cast without target data. Use the initial number hit to seed predictions
							TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
						end
						TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
						TRB.Data.snapshotData.ancientAftershock.endTime = currentTime + TRB.Data.spells.ancientAftershock.duration + legendaryDuration
						TRB.Data.snapshotData.ancientAftershock.ticksRemaining = TRB.Data.spells.ancientAftershock.ticks + legendaryTicks
						TRB.Data.snapshotData.ancientAftershock.isActive = true
					elseif type == "SPELL_AURA_APPLIED" then
						if TRB.Data.snapshotData.ancientAftershock.hitTime == nil then --This is a new cast without target data. Use the initial number hit to seed predictions
							TRB.Data.snapshotData.ancientAftershock.targetsHit = 1
						else
							TRB.Data.snapshotData.ancientAftershock.targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit + 1
						end
						TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
						TRB.Data.snapshotData.ancientAftershock.endTime = currentTime + TRB.Data.spells.ancientAftershock.duration + legendaryDuration
						TRB.Data.snapshotData.ancientAftershock.isActive = true
					end
				elseif spellId == TRB.Data.spells.ancientAftershock.idTick then
					if type == "SPELL_DAMAGE" and TRB.Data.snapshotData.ancientAftershock.hitTime ~= nil then
						if currentTime > (TRB.Data.snapshotData.ancientAftershock.hitTime + 0.1) then --This is a new tick
							TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
						end
						TRB.Data.snapshotData.ancientAftershock.targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit + 1
						TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
					end
				elseif spellId == TRB.Data.spells.conquerorsBanner.id then
					if type == "SPELL_AURA_APPLIED" then -- Gain Conqueror's Banner
						TRB.Data.snapshotData.conquerorsBanner.isActive = true
						TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.spells.conquerorsBanner.ticks
						TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.rage
						TRB.Data.snapshotData.conquerorsBanner.endTime = currentTime + TRB.Data.spells.conquerorsBanner.duration
						TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
					elseif type == "SPELL_AURA_REFRESH" then
						TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.spells.conquerorsBanner.ticks + 1
						TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.rage * TRB.Data.spells.conquerorsBanner.rage
						TRB.Data.snapshotData.conquerorsBanner.endTime = currentTime + TRB.Data.spells.conquerorsBanner.duration + ((TRB.Data.spells.conquerorsBanner.duration / TRB.Data.spells.conquerorsBanner.ticks) - (currentTime - TRB.Data.snapshotData.conquerorsBanner.lastTick))
						TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.conquerorsBanner.isActive = false
						TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = 0
						TRB.Data.snapshotData.conquerorsBanner.rage = 0
						TRB.Data.snapshotData.conquerorsBanner.endTime = nil
						TRB.Data.snapshotData.conquerorsBanner.lastTick = nil
					elseif type == "SPELL_PERIODIC_ENERGIZE" then
						TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining - 1
						TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.rage
						TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
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
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.warrior.arms)
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
			specCache.arms.talents = TRB.Functions.GetTalents()
			FillSpellData_Arms()
			TRB.Functions.LoadFromSpecCache(specCache.arms)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Arms
			
			if TRB.Data.barConstructedForSpec ~= "arms" then
				TRB.Data.barConstructedForSpec = "arms"
				ConstructResourceBar(specCache.arms.settings)
			end
		elseif specId == 2 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.warrior.fury)
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.fury)
			specCache.fury.talents = TRB.Functions.GetTalents()
			FillSpellData_Fury()
			TRB.Functions.LoadFromSpecCache(specCache.fury)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Fury
			
			if TRB.Data.barConstructedForSpec ~= "fury" then
				TRB.Data.barConstructedForSpec = "fury"
				ConstructResourceBar(specCache.fury.settings)
			end
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
		if classIndexId == 1 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Warrior.LoadDefaultSettings()
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
							TRB.Data.settings.warrior.arms = TRB.Functions.ValidateLsmValues("Arms Warrior", TRB.Data.settings.warrior.arms)
							TRB.Data.settings.warrior.fury = TRB.Functions.ValidateLsmValues("Fury Warrior", TRB.Data.settings.warrior.fury)
							
							FillSpellData_Arms()
							FillSpellData_Fury()
							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Warrior.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
							EventRegistration()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
					SwitchSpec()
				end
			end
		end
	end)
end
