local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 1 then --Only do this if we're on a Warrior!
	TRB.Functions.Class = TRB.Functions.Class or {}
	TRB.Functions.Character:ResetSnapshotData()
	
	TRB.Functions.Class = TRB.Functions.Class or {}
	TRB.Functions.Character:ResetSnapshotData()
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
		fury = {
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
		-- Arms
		specCache.arms.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0
			},
			dots = {
				rendCount = 0,
				deepWoundsCount = 0
			}
		}

		specCache.arms.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			effects = {
			},
			pandemicModifier = 0
		}

		specCache.arms.spells = {
			--Warrior Class Baseline Abilities
			charge = {
				id = 100,
				name = "",
				icon = "",
				rage = 20,
				isTalent = false,
				baseline = true,
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
				baseline = true,
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
				baseline = true,
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
				baseline = true,
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
				baseline = true,
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
				baseline = true,
				hasCooldown = true,
				thresholdUsable = false
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
				baseline = true,
				hasCooldown = false,
				thresholdUsable = false
			},
			victoryRush = {
				id = 34428,
				name = "",
				icon = "",
				isTalent = false,
				baseline = true,
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
				baseline = true,
				isSnowflake = true,
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
			
			spearOfBastion = {
				id = 376079,
				name = "",
				icon = "",
				rage = 20
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
				thresholdUsable = false,
				isSnowflake = true
			},
			improvedExecute = {
				id = 316405,
				name = "",
				icon = "",
				isTalent = true
			},
			rend = {
				id = 388539,
				talentId = 772,
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
				thresholdUsable = false,
				isSnowflake = true
			},
			ignorePain = {
				id = 190456,
				name = "",
				icon = "",
				rage = -40,
				texture = "",
				thresholdId = 13,
				settingKey = "ignorePain",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				duration = 11
			},
			suddenDeath = {
				id = 29725,
				name = "",
				icon = ""	
			},
			massacre = {
				id = 281001,
				name = "",
				icon = "",
				healthMinimum = 0.35,
				isTalent = true
			},
			bloodletting = {
				id = 383154,
				name = "",
				icon = "",
				modifier = 6,
				isTalent = true
			},
			stormOfSwords = {
				id = 385512,
				name = "",
				icon = "",
				isTalent = true,
				rageMod = -20
			},
			battlelord = {
				id = 386631,
				name = "",
				icon = "",
				rageMod = -10
			}
		}

		specCache.arms.snapshot.audio = {
			overcapCue = false
		}
		specCache.arms.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {},
			rend = 0,
			deepWounds = 0
		}
		specCache.arms.snapshot.execute = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshot.shieldBlock = {
			charges = 0,
			maxCharges = 2,
			startTime = nil,
			duration = 0
		}
		specCache.arms.snapshot.impendingVictory = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshot.thunderClap = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshot.whirlwind = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshot.mortalStrike = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshot.cleave = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshot.ignorePain = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshot.victoryRush = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.arms.snapshot.suddenDeath = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.arms.snapshot.battlelord = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}

		-- Fury

		specCache.fury.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0,
				ravager = 0
			},
			ravager = {
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
			effects = {
			}
		}

		specCache.fury.spells = {
			--Warrior base abilities
			charge = {
				id = 100,
				name = "",
				icon = "",
				rage = 20,
				isTalent = false,
				baseline = true,
			},
			execute = {
				id = 280735,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				rage = -20,
				rageMax = -40,
				texture = "",
				thresholdId = 1,
				settingKey = "execute",
				isTalent = false,
				baseline = true,
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true
			},
			executeMinimum = {
				id = 280735,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				rage = -20,
				texture = "",
				thresholdId = 2,
				settingKey = "executeMinimum",
				isTalent = false,
				baseline = true,
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true
			},
			executeMaximum = {
				id = 280735,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				rage = -40,
				texture = "",
				thresholdId = 3,
				settingKey = "executeMaximum",
				isTalent = false,
				baseline = true,
				hasCooldown = true,
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
				baseline = true,
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
				baseline = true,
				hasCooldown = true,
				thresholdUsable = false
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
				baseline = true,
				hasCooldown = false,
				thresholdUsable = false
			},
			victoryRush = {
				id = 34428,
				name = "",
				icon = "",
				isTalent = false,
				baseline = true,
			},
			whirlwind = {
				id = 85739, --buff ID
				name = "",
				icon = ""
			},
			
			--Fury base abilities
			enrage = {
				id = 184362,
				name = "",
				icon = "",
				isTalent = false,
				baseline = true,
			},

			-- Warrior Class Talents
			impendingVictory = {
				id = 202168,
				name = "",
				icon = "",
				rage = -10,
				texture = "",
				thresholdId = 7,
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
				thresholdId = 8,
				settingKey = "thunderClap",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			spearOfBastion = {
				id = 376079,
				name = "",
				icon = "",
				rage = 20
			},

			-- Fury Talent abilities
			
			--Talents
			rampage = {
				id = 184367,
				name = "",
				icon = "",
				rage = -80,
				texture = "",
				thresholdId = 9,
				settingKey = "rampage",
				isTalent = true,
				hasCooldown = false,
				thresholdUsable = false
			},
			improvedExecute = {
				id = 316402,
				name = "",
				icon = "",
				isTalent = true
			},
			suddenDeath = {
				id = 280776,
				name = "",
				icon = "",
				isTalent = true
			},
			massacre = {
				id = 206315,
				name = "",
				icon = "",
				isTalent = true,
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
			ravager = {
				id = 228920,
				name = "",
				icon = "",
				rage = 10,
				ticks = 6, -- Sometimes 5, sometimes 6, sometimes 7?!
				duration = 12,
				isHasted = true,
				energizeId = 334934
			},
			stormOfSteel = {
				id = 382953,
				name = "",
				icon = "",
				rage = 10,
				charges = 2,
				isTalent = true
			}
		}

		specCache.fury.snapshot.audio = {
			overcapCue = false
		}
		specCache.fury.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {},
			rend = 0,
		}
		specCache.fury.snapshot.shieldBlock = {
			charges = 0,
			maxCharges = 2,
			startTime = nil,
			duration = 0
		}
		specCache.fury.snapshot.thunderClap = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.fury.snapshot.impendingVictory = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.fury.snapshot.victoryRush = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.fury.snapshot.enrage = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.fury.snapshot.whirlwind = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			stacks = 0
		}
		specCache.fury.snapshot.ravager = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil,
			totalDuration = 0
		}
		specCache.fury.snapshot.bladestorm = {
			endTime = nil,
			duration = 0,
			originalDuration = 0,
			spellId = nil,
			ticksRemaining = 0,
			rage = 0
		}
		specCache.fury.snapshot.execute = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.fury.snapshot.suddenDeath = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
	end

	local function Setup_Arms()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "warrior", "arms")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.arms)
	end

	local function Setup_Fury()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "warrior", "fury")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.fury)
	end

	local function FillSpellData_Arms()
		Setup_Arms()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.arms.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.arms.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Rage generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#charge", icon = spells.charge.icon, description = "Charge", printInSettings = true },
			{ variable = "#cleave", icon = spells.cleave.icon, description = "Cleave", printInSettings = true },
			{ variable = "#deepWounds", icon = spells.deepWounds.icon, description = "Deep Wounds", printInSettings = true },
			{ variable = "#execute", icon = spells.execute.icon, description = "Execute", printInSettings = true },			
			{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = "Impending Victory", printInSettings = true },
			{ variable = "#mortalStrike", icon = spells.mortalStrike.icon, description = "Mortal Strike", printInSettings = true },
			{ variable = "#rend", icon = spells.rend.icon, description = "Rend", printInSettings = true },
			{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = "Shield Block", printInSettings = true },
			{ variable = "#slam", icon = spells.slam.icon, description = "Slam", printInSettings = true },
			{ variable = "#spearOfBastion", icon = spells.spearOfBastion.icon, description = "Spear of Bastion", printInSettings = true },
			{ variable = "#victoryRush", icon = spells.victoryRush.icon, description = "Victory Rush", printInSettings = true },
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

			{ variable = "$rage", description = "Current Rage", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Rage", printInSettings = false, color = false },
			{ variable = "$rageMax", description = "Maximum Rage", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Rage", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Rage from Passive Sources", printInSettings = true, color = false },
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

			{ variable = "$suddenDeathTime", description = "Time remaining on Sudden Death proc", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.arms.spells = spells
	end

	local function FillSpellData_Fury()
		Setup_Fury()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.fury.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.fury.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Rage generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#bladestorm", icon = spells.bladestorm.icon, description = "Bladestorm", printInSettings = true },
			{ variable = "#charge", icon = spells.charge.icon, description = "Charge", printInSettings = true },
			{ variable = "#enrage", icon = spells.enrage.icon, description = "Enrage", printInSettings = true },
			{ variable = "#execute", icon = spells.execute.icon, description = "Execute", printInSettings = true },
			{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = "Impending Victory", printInSettings = true },
			{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = "Shield Block", printInSettings = true },
			{ variable = "#slam", icon = spells.slam.icon, description = "Slam", printInSettings = true },
			{ variable = "#spearOfBastion", icon = spells.spearOfBastion.icon, description = "Spear of Bastion", printInSettings = true },
			{ variable = "#ravager", icon = spells.ravager.icon, description = "Ravager", printInSettings = true },
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

			{ variable = "$rage", description = "Current Rage", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Rage", printInSettings = false, color = false },
			{ variable = "$rageMax", description = "Maximum Rage", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Rage", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Rage from Passive Sources including Ravager", printInSettings = true, color = false },
			{ variable = "$ragePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$ragePlusPassive", description = "Current + Passive Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Rage Total", printInSettings = false, color = false },
			{ variable = "$rageTotal", description = "Current + Passive + Casting Rage Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Rage Total", printInSettings = false, color = false },   

			{ variable = "$enrageTime", description = "Time remaining on Enrage", printInSettings = true, color = false },

			{ variable = "$suddenDeathTime", description = "Time remaining on Sudden Death proc", printInSettings = true, color = false },
			
			{ variable = "$ravagerTicks", description = "Number of expected ticks remaining on Ravager", printInSettings = true, color = false }, 
			{ variable = "$ravagerRage", description = "Rage from Ravager", printInSettings = true, color = false }, 

			{ variable = "$whirlwindTime", description = "Time remaining on Whirlwind buff", printInSettings = true, color = false },
			{ variable = "$whirlwindStacks", description = "Number of stacks remaining on Whirlwind buff", printInSettings = true, color = false },
			
			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.fury.spells = spells
	end

	local function GetSuddenDeathRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.suddenDeath)
	end
	
	local function GetEnrageRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.enrage)
	end
	
	local function GetWhirlwindRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.whirlwind)
	end

	local function CalculateAbilityResourceValue(resource)
		local modifier = 1.0
		return resource * modifier
	end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshot.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		
		local specId = GetSpecialization()

		if specId == 1 then
			local rendTotal = 0
			local deepWoundsTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshot.targetData.targets[guid].rend = false
					TRB.Data.snapshot.targetData.targets[guid].rendRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].deepWounds = false
					TRB.Data.snapshot.targetData.targets[guid].deepWoundsRemaining = 0
				else
					if TRB.Data.snapshot.targetData.targets[guid].rend == true then
						rendTotal = rendTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].deepWounds == true then
						deepWoundsTotal = deepWoundsTotal + 1
					end
				end
			end
			TRB.Data.snapshot.targetData.rend = rendTotal
			TRB.Data.snapshot.targetData.deepWounds = deepWoundsTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.Target:TargetsCleanup(clearAll)
		local specId = GetSpecialization()

		if specId == 1 then
			if clearAll == true then
				TRB.Data.snapshot.targetData.rend = 0
				TRB.Data.snapshot.targetData.deepWounds = 0
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

		for k, v in pairs(TRB.Data.spells) do
			local spell = TRB.Data.spells[k]
			if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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

		TRB.Functions.Bar:Construct(settings)

		if specId == 1 or specId == 2 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function RefreshLookupData_Arms()
		local _
		local normalizedRage = TRB.Data.snapshot.resource / TRB.Data.resourceFactor
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentRageColor = TRB.Data.settings.warrior.arms.colors.text.current
		local castingRageColor = TRB.Data.settings.warrior.arms.colors.text.casting

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
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
		end

		if TRB.Data.snapshot.casting.resourceFinal < 0 then
			castingRageColor = TRB.Data.settings.warrior.arms.colors.text.spending
		end

		--$suddenDeathTime
		local _suddenDeathTime = GetSuddenDeathRemainingTime()
		local suddenDeathTime
		if _suddenDeathTime ~= nil then
			suddenDeathTime = string.format("%.1f", _suddenDeathTime)
		end

		--$rage
		local ragePrecision = TRB.Data.settings.warrior.arms.ragePrecision or 0
		local currentRage = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(normalizedRage, ragePrecision, "floor"))
		--$casting
		local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(TRB.Data.snapshot.casting.resourceFinal, ragePrecision, "floor"))
		--$passive
		local _passiveRage = 0

		local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

		local passiveRage = string.format("|c%s%s|r", TRB.Data.settings.warrior.arms.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveRage, ragePrecision, "floor"))
		
		--$rageTotal
		local _rageTotal = math.min(_passiveRage + TRB.Data.snapshot.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local rageTotal = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_rageTotal, ragePrecision, "floor"))
		--$ragePlusCasting
		local _ragePlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusCasting = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(_ragePlusCasting, ragePrecision, "floor"))
		--$ragePlusPassive
		local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusPassive = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_ragePlusPassive, ragePrecision, "floor"))

		
		--$rendCount and $rendTime
		local _rendCount = TRB.Data.snapshot.targetData.rend or 0
		local rendCount = tostring(_rendCount)
		local _rendTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_rendTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rendRemaining or 0
		end

		local rendTime

		local _deepWoundsCount = TRB.Data.snapshot.targetData.deepWounds or 0
		local deepWoundsCount = tostring(_deepWoundsCount)
		local _deepWoundsTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_deepWoundsTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWoundsRemaining or 0
		end

		local deepWoundsTime

		if TRB.Data.settings.warrior.arms.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rend then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rendRemaining > ((TRB.Data.spells.rend.baseDuration + TRB.Data.character.pandemicModifier) * 0.3) then
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rendRemaining)
				else
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rendRemaining)
				end
			else
				rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, _rendCount)
				rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWounds then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWoundsRemaining > ((TRB.Data.spells.deepWounds.baseDuration + TRB.Data.character.pandemicModifier) * 0.3) then
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWoundsRemaining)
				else
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWoundsRemaining)
				end
			else
				deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, 0)
			end
		else
			rendTime = string.format("%.1f", _rendTime)
			deepWoundsTime = string.format("%.1f", _deepWoundsTime)
		end
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedRage
		Global_TwintopResourceBar.resource.passive = _passiveRage
		Global_TwintopResourceBar.dots = {
			rendCount = _rendCount,
			deepWoundsCount = _deepWoundsCount
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#charge"] = TRB.Data.spells.charge.icon
		lookup["#cleave"] = TRB.Data.spells.cleave.icon
		lookup["#deepWounds"] = TRB.Data.spells.deepWounds.icon
		lookup["#execute"] = TRB.Data.spells.execute.icon
		lookup["#impendingVictory"] = TRB.Data.spells.impendingVictory.icon
		lookup["#mortalStrike"] = TRB.Data.spells.mortalStrike.icon
		lookup["#rend"] = TRB.Data.spells.rend.icon
		lookup["#shieldBlock"] = TRB.Data.spells.shieldBlock.icon
		lookup["#slam"] = TRB.Data.spells.slam.icon
		lookup["#spearOfBastion"] = TRB.Data.spells.spearOfBastion.icon
		lookup["#victoryRush"] = TRB.Data.spells.victoryRush.icon
		lookup["#whirlwind"] = TRB.Data.spells.whirlwind.icon
		lookup["$rend"] = TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.rend)
		lookup["$rendCount"] = rendCount
		lookup["$rendTime"] = rendTime
		lookup["$deepWoundsCount"] = deepWoundsCount
		lookup["$deepWoundsTime"] = deepWoundsTime
		lookup["$suddenDeathTime"] = suddenDeathTime
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
		lookupLogic["$rend"] = TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.rend)
		lookupLogic["$rendCount"] = _rendCount
		lookupLogic["$rendTime"] = _rendTime
		lookupLogic["$deepWoundsCount"] = _deepWoundsCount
		lookupLogic["$deepWoundsTime"] = _deepWoundsTime
		lookupLogic["$suddenDeathTime"] = _suddenDeathTime
		lookupLogic["$ragePlusCasting"] = _ragePlusCasting
		lookupLogic["$rageTotal"] = _rageTotal
		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$rage"] = normalizedRage
		lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
		lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
		lookupLogic["$resourceTotal"] = _rageTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedRage
		lookupLogic["$casting"] = TRB.Data.snapshot.casting.resourceFinal
		lookupLogic["$passive"] = _passiveRage
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$rageOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Fury()
		local _
		local normalizedRage = TRB.Data.snapshot.resource / TRB.Data.resourceFactor
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentRageColor = TRB.Data.settings.warrior.fury.colors.text.current
		local castingRageColor = TRB.Data.settings.warrior.fury.colors.text.casting

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
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
		end

		if TRB.Data.snapshot.casting.resourceFinal < 0 then
			castingRageColor = TRB.Data.settings.warrior.fury.colors.text.spending
		end

		--$ravagerRage
		local _ravagerRage = TRB.Data.snapshot.ravager.rage
		local ravagerRage = string.format("%.0f", TRB.Data.snapshot.ravager.rage)
		--$ravagerTicks
		local ravagerTicks = string.format("%.0f", TRB.Data.snapshot.ravager.ticksRemaining)

		--$rage
		local ragePrecision = TRB.Data.settings.warrior.fury.ragePrecision or 0
		local currentRage = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(normalizedRage, ragePrecision, "floor"))
		--$casting
		local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(TRB.Data.snapshot.casting.resourceFinal, ragePrecision, "floor"))
		--$passive
		local _passiveRage = _ravagerRage

		local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

		local passiveRage = string.format("|c%s%s|r", TRB.Data.settings.warrior.fury.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveRage, ragePrecision, "floor"))
		
		--$rageTotal
		local _rageTotal = math.min(_passiveRage + TRB.Data.snapshot.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local rageTotal = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_rageTotal, ragePrecision, "floor"))
		--$ragePlusCasting
		local _ragePlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusCasting = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(_ragePlusCasting, ragePrecision, "floor"))
		--$ragePlusPassive
		local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusPassive = string.format("|c%s%s|r", currentRageColor, TRB.Functions.Number:RoundTo(_ragePlusPassive, ragePrecision, "floor"))

		--$enrageTime
		local _enrageTime = GetEnrageRemainingTime()
		local enrageTime = string.format("%.1f", _enrageTime)
		
		--$whirlwindTime
		local _whirlwindTime = GetWhirlwindRemainingTime()
		local whirlwindTime = string.format("%.1f", _whirlwindTime)
		--$whirlwindStacks
		local whirlwindStacks = TRB.Data.snapshot.whirlwind.stacks or 0

		--$suddenDeathTime
		local _suddenDeathTime = GetSuddenDeathRemainingTime()
		local suddenDeathTime
		if _suddenDeathTime ~= nil then
			suddenDeathTime = string.format("%.1f", _suddenDeathTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedRage
		Global_TwintopResourceBar.resource.passive = _passiveRage
		Global_TwintopResourceBar.ravager = {
			rage = _ravagerRage,
			ticks = TRB.Data.snapshot.ravager.ticksRemaining or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#bladestorm"] = TRB.Data.spells.bladestorm.icon
		lookup["#charge"] = TRB.Data.spells.charge.icon
		lookup["#enrage"] = TRB.Data.spells.enrage.icon
		lookup["#execute"] = TRB.Data.spells.execute.icon
		lookup["#impendingVictory"] = TRB.Data.spells.impendingVictory.icon
		lookup["#ravager"] = TRB.Data.spells.ravager.icon
		lookup["#shieldBlock"] = TRB.Data.spells.shieldBlock.icon
		lookup["#slam"] = TRB.Data.spells.slam.icon
		lookup["#spearOfBastion"] = TRB.Data.spells.spearOfBastion.icon
		lookup["#victoryRush"] = TRB.Data.spells.victoryRush.icon
		lookup["#whirlwind"] = TRB.Data.spells.whirlwind.icon
		lookup["$suddenDeathTime"] = suddenDeathTime
		lookup["$enrageTime"] = enrageTime
		lookup["$whirlwindTime"] = whirlwindTime
		lookup["$whirlwindStacks"] = whirlwindStacks
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
		lookup["$ravagerRage"] = _ravagerRage
		lookup["$ravagerTicks"] = ravagerTicks
		TRB.Data.lookup = lookup


		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$enrageTime"] = _enrageTime
		lookupLogic["$suddenDeathTime"] = _suddenDeathTime
		lookupLogic["$whirlwindTime"] = _whirlwindTime
		lookupLogic["$whirlwindStacks"] = whirlwindStacks
		lookupLogic["$ragePlusCasting"] = _ragePlusCasting
		lookupLogic["$rageTotal"] = _rageTotal
		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$rage"] = normalizedRage
		lookupLogic["$resourcePlusCasting"] = _ragePlusCasting
		lookupLogic["$resourcePlusPassive"] = _ragePlusPassive
		lookupLogic["$resourceTotal"] = _rageTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedRage
		lookupLogic["$casting"] = TRB.Data.snapshot.casting.resourceFinal
		lookupLogic["$passive"] = _passiveRage
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$rageOvercap"] = overcap
		lookupLogic["$ravagerRage"] = _ravagerRage
		lookupLogic["$ravagerTicks"] = ravagerTicks
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
		TRB.Data.snapshot.casting.startTime = currentTime
		TRB.Data.snapshot.casting.resourceRaw = spell.rage
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(spell.rage)
		TRB.Data.snapshot.casting.spellId = spell.id
		TRB.Data.snapshot.casting.icon = spell.icon
	end

	local function CastingSpell()
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			if specId == 2 and TRB.Data.snapshot.bladestorm.isActive then
				return true
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			elseif specId == 2 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateRavager()
		if TRB.Data.snapshot.ravager.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.ravager.endTime == nil or currentTime > TRB.Data.snapshot.ravager.endTime then
				TRB.Data.snapshot.ravager.ticksRemaining = 0
				TRB.Data.snapshot.ravager.endTime = nil
				TRB.Data.snapshot.ravager.rage = 0
				TRB.Data.snapshot.ravager.isActive = false
				TRB.Data.snapshot.ravager.totalDuration = 0
			else
				local ticksRemaining = math.ceil((TRB.Data.snapshot.ravager.endTime - currentTime) / (TRB.Data.snapshot.ravager.totalDuration / TRB.Data.spells.ravager.ticks))

				if ticksRemaining < TRB.Data.snapshot.ravager.ticksRemaining then
					TRB.Data.snapshot.ravager.ticksRemaining = ticksRemaining
				end

				TRB.Data.snapshot.ravager.rage = TRB.Data.snapshot.ravager.ticksRemaining * TRB.Data.spells.ravager.rage				
				if TRB.Data.snapshot.ravager.rage < 0 then
					TRB.Data.snapshot.ravager.rage = 0
				end
			end
		end
	end

	local function UpdateBladestorm()
		if TRB.Data.snapshot.bladestorm.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.bladestorm.endTime ~= nil and currentTime > TRB.Data.snapshot.bladestorm.endTime then
				TRB.Data.snapshot.bladestorm.ticksRemaining = 0
				TRB.Data.snapshot.bladestorm.endTime = nil
				TRB.Data.snapshot.bladestorm.duration = 0
				TRB.Data.snapshot.bladestorm.rage = 0
				TRB.Data.snapshot.bladestorm.isActive = false
			elseif TRB.Data.snapshot.bladestorm.endTime ~= nil then
				_, _, _, _, TRB.Data.snapshot.bladestorm.duration, TRB.Data.snapshot.bladestorm.endTime, _, _, _, TRB.Data.snapshot.bladestorm.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.bladestorm.id)
				TRB.Data.snapshot.bladestorm.ticksRemaining = math.ceil((TRB.Data.snapshot.bladestorm.endTime - currentTime) / (TRB.Data.snapshot.bladestorm.originalDuration / TRB.Data.spells.bladestorm.ticks))
				TRB.Data.snapshot.bladestorm.rage = TRB.Data.snapshot.bladestorm.ticksRemaining * TRB.Data.spells.bladestorm.rage
				TRB.Data.snapshot.casting.resourceRaw = TRB.Data.snapshot.bladestorm.rage
				TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.bladestorm.rage
			end
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
		local currentTime = GetTime()

		if TRB.Data.snapshot.impendingVictory.startTime ~= nil and currentTime > (TRB.Data.snapshot.impendingVictory.startTime + TRB.Data.snapshot.impendingVictory.duration) then
			TRB.Data.snapshot.impendingVictory.startTime = nil
			TRB.Data.snapshot.impendingVictory.duration = 0
		elseif TRB.Data.snapshot.impendingVictory.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshot.impendingVictory.startTime, TRB.Data.snapshot.impendingVictory.duration, _, _ = GetSpellCooldown(TRB.Data.spells.impendingVictory.id)
		end


		if TRB.Data.snapshot.thunderClap.startTime ~= nil and currentTime > (TRB.Data.snapshot.thunderClap.startTime + TRB.Data.snapshot.thunderClap.duration) then
			TRB.Data.snapshot.thunderClap.startTime = nil
			TRB.Data.snapshot.thunderClap.duration = 0
		elseif TRB.Data.snapshot.thunderClap.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshot.thunderClap.startTime, TRB.Data.snapshot.thunderClap.duration, _, _ = GetSpellCooldown(TRB.Data.spells.thunderClap.id)
		end

---@diagnostic disable-next-line: redundant-parameter, cast-local-type
		TRB.Data.snapshot.shieldBlock.charges, TRB.Data.snapshot.shieldBlock.maxCharges, TRB.Data.snapshot.shieldBlock.startTime, TRB.Data.snapshot.shieldBlock.duration, _ = GetSpellCharges(TRB.Data.spells.shieldBlock.id)
	end

	local function UpdateSnapshot_Arms()
		UpdateSnapshot()

		local currentTime = GetTime()
		local _

		if TRB.Data.snapshot.mortalStrike.startTime ~= nil and currentTime > (TRB.Data.snapshot.mortalStrike.startTime + TRB.Data.snapshot.mortalStrike.duration) then
			TRB.Data.snapshot.mortalStrike.startTime = nil
			TRB.Data.snapshot.mortalStrike.duration = 0
		elseif TRB.Data.snapshot.mortalStrike.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.mortalStrike.startTime, TRB.Data.snapshot.mortalStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.mortalStrike.id)
		end

		if TRB.Data.snapshot.cleave.startTime ~= nil and currentTime > (TRB.Data.snapshot.cleave.startTime + TRB.Data.snapshot.cleave.duration) then
			TRB.Data.snapshot.cleave.startTime = nil
			TRB.Data.snapshot.cleave.duration = 0
		elseif TRB.Data.snapshot.cleave.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.cleave.startTime, TRB.Data.snapshot.cleave.duration, _, _ = GetSpellCooldown(TRB.Data.spells.cleave.id)
		end

		if TRB.Data.snapshot.ignorePain.startTime ~= nil and currentTime > (TRB.Data.snapshot.ignorePain.startTime + TRB.Data.snapshot.ignorePain.duration) then
			TRB.Data.snapshot.ignorePain.startTime = nil
			TRB.Data.snapshot.ignorePain.duration = 0
		elseif TRB.Data.snapshot.ignorePain.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.ignorePain.startTime, TRB.Data.snapshot.ignorePain.duration, _, _ = GetSpellCooldown(TRB.Data.spells.ignorePain.id)
		end

		if TRB.Data.snapshot.whirlwind.startTime ~= nil and currentTime > (TRB.Data.snapshot.whirlwind.startTime + TRB.Data.snapshot.whirlwind.duration) then
			TRB.Data.snapshot.whirlwind.startTime = nil
			TRB.Data.snapshot.whirlwind.duration = 0
		elseif TRB.Data.snapshot.whirlwind.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.whirlwind.startTime, TRB.Data.snapshot.whirlwind.duration, _, _ = GetSpellCooldown(TRB.Data.spells.whirlwind.id)
		end

		_, _, _, _, TRB.Data.snapshot.suddenDeath.duration, TRB.Data.snapshot.suddenDeath.endTime, _, _, _, TRB.Data.snapshot.suddenDeath.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.suddenDeath.id, "player")
		
		if TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rend then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.rend.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rendRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWounds then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.deepWounds.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWoundsRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Fury()
		UpdateSnapshot()
		UpdateBladestorm()
		UpdateRavager()

		local currentTime = GetTime()
		local _

		_, _, _, _, TRB.Data.snapshot.suddenDeath.duration, TRB.Data.snapshot.suddenDeath.endTime, _, _, _, TRB.Data.snapshot.suddenDeath.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.suddenDeath.id, "player")
		
		_, _, TRB.Data.snapshot.whirlwind.stacks, _, TRB.Data.snapshot.whirlwind.duration, TRB.Data.snapshot.whirlwind.endTime, _, _, _, TRB.Data.snapshot.whirlwind.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.whirlwind.id, "player")
		
		if TRB.Data.snapshot.execute.startTime ~= nil and currentTime > (TRB.Data.snapshot.execute.startTime + TRB.Data.snapshot.execute.duration) then
			TRB.Data.snapshot.execute.startTime = nil
			TRB.Data.snapshot.execute.duration = 0
		elseif TRB.Data.snapshot.execute.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.execute.startTime, TRB.Data.snapshot.execute.duration, _, _ = GetSpellCooldown(TRB.Data.spells.execute.id)
		end
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.warrior

		if specId == 1 then
			local specSettings = classSettings.arms
			UpdateSnapshot_Arms()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentRage = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					if specSettings.bar.showPassive then
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentRage + TRB.Data.snapshot.casting.resourceFinal
					else
						castingBarValue = currentRage
					end

					if castingBarValue < currentRage then --Using a spender
						if -TRB.Data.snapshot.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue) 
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentRage)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local showCooldown = false
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local rageAmount = CalculateAbilityResourceValue(spell.rage)
							local normalizedRage = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

							if not (spell.id == TRB.Data.spells.execute.id or spell.id == TRB.Data.spells.whirlwind.id) then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -rageAmount, TRB.Data.character.maxResource)
							end

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.execute.id then
									local targetUnitHealth = TRB.Functions.Target:GetUnitHealthPercent("target")
									local healthMinimum = TRB.Data.spells.execute.healthMinimum
									
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.massacre) then
										healthMinimum = TRB.Data.spells.massacre.healthMinimum
									end

									local suddenDeathTime = GetSuddenDeathRemainingTime()

									if suddenDeathTime > 0 then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -TRB.Data.spells.execute.rageMax, TRB.Data.character.maxResource)
									else
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, math.min(math.max(-rageAmount, normalizedRage), -TRB.Data.spells.execute.rageMax), TRB.Data.character.maxResource)
									end

									if UnitIsDeadOrGhost("target") or targetUnitHealth == nil then
										showThreshold = false
									elseif spell.settingKey == "executeMinimum" and (targetUnitHealth >= healthMinimum) and suddenDeathTime == 0 then
										showThreshold = false
									elseif spell.settingKey == "executeMaximum"  and (targetUnitHealth >= healthMinimum) and suddenDeathTime == 0 then
										showThreshold = false
									elseif spell.settingKey == "execute" and (targetUnitHealth >= healthMinimum) and suddenDeathTime == 0 then
										showThreshold = false
									elseif currentRage >= -rageAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.impendingVictory.id then
									if TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount or TRB.Data.snapshot.victoryRush.isActive then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.mortalStrike.id then
									if TRB.Data.snapshot.battlelord.isActive then
										rageAmount = rageAmount - TRB.Data.spells.battlelord.rageMod
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -rageAmount, TRB.Data.character.maxResource)
									end

									if TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.cleave.id then
									if TRB.Data.snapshot.battlelord.isActive then
										rageAmount = rageAmount - TRB.Data.spells.battlelord.rageMod
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -rageAmount, TRB.Data.character.maxResource)
									end

									if TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.whirlwind.id then
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.stormOfSwords) then
										rageAmount = rageAmount + TRB.Data.spells.stormOfSwords.rageMod
									end 
									
									if TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
										showCooldown = true
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount or TRB.Data.snapshot.victoryRush.isActive then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -rageAmount, TRB.Data.character.maxResource)
								end
							elseif spell.hasCooldown then
								if (TRB.Data.snapshot[spell.settingKey].charges == nil or TRB.Data.snapshot[spell.settingKey].charges == 0) and
									(TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration)) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif currentRage >= -rageAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentRage >= -rageAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base
					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and TRB.Data.snapshot.audio.overcapCue == false then
							TRB.Data.snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshot.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.fury
			UpdateSnapshot_Fury()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentRage = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if TRB.Data.snapshot.ravager.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshot.ravager.rage
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentRage + TRB.Data.snapshot.casting.resourceFinal
					else
						castingBarValue = currentRage
					end

					if castingBarValue < currentRage then --Using a spender
						if -TRB.Data.snapshot.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, currentRage)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentRage)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then							
							local rageAmount = CalculateAbilityResourceValue(spell.rage)
							local normalizedRage = TRB.Data.snapshot.resource / TRB.Data.resourceFactor
							
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -rageAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							local cooldownSettingKey = spell.settingKey

							if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.execute.id then
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.improvedExecute) then
										showThreshold = false
									else
										local targetUnitHealth = TRB.Functions.Target:GetUnitHealthPercent("target")
										local healthMinimum = TRB.Data.spells.execute.healthMinimum
										
										if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.massacre) then
											healthMinimum = TRB.Data.spells.massacre.healthMinimum
										end

										local suddenDeathTime = GetSuddenDeathRemainingTime()

										if UnitIsDeadOrGhost("target") or targetUnitHealth == nil then
											showThreshold = false
										elseif spell.settingKey == "executeMinimum" and (targetUnitHealth >= healthMinimum) and suddenDeathTime == 0 then
											showThreshold = false
										elseif spell.settingKey == "executeMaximum"  and (targetUnitHealth >= healthMinimum) and suddenDeathTime == 0 then
											showThreshold = false
										elseif spell.settingKey == "execute" and (targetUnitHealth >= healthMinimum) and suddenDeathTime == 0 then
											showThreshold = false
										else
											if spell.settingKey == "execute" then
												TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, math.min(math.max(-rageAmount, normalizedRage), -TRB.Data.spells.execute.rageMax), TRB.Data.character.maxResource)
											end
											
											cooldownSettingKey = TRB.Data.spells.execute.settingKey

											if TRB.Data.snapshot[cooldownSettingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[cooldownSettingKey].startTime + TRB.Data.snapshot[cooldownSettingKey].duration) then
												thresholdColor = specSettings.colors.threshold.unusable
											elseif currentRage >= -rageAmount then
												thresholdColor = specSettings.colors.threshold.over
											else
												thresholdColor = specSettings.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									end
								elseif spell.id == TRB.Data.spells.impendingVictory.id then
									if TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentRage >= -rageAmount or TRB.Data.snapshot.victoryRush.isActive then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.hasCooldown then
								if (TRB.Data.snapshot[spell.settingKey].charges == nil or TRB.Data.snapshot[spell.settingKey].charges == 0) and
									(TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration)) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif currentRage >= -rageAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentRage >= -rageAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[cooldownSettingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base

					if GetEnrageRemainingTime() > 0 then
						barColor = specSettings.colors.bar.enrage
					end

					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and TRB.Data.snapshot.audio.overcapCue == false then
							TRB.Data.snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshot.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

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

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "arms" then --Arms
					if spellId == TRB.Data.spells.mortalStrike.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshot.mortalStrike.startTime, TRB.Data.snapshot.mortalStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.mortalStrike.id)
						end
					elseif spellId == TRB.Data.spells.cleave.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshot.cleave.startTime, TRB.Data.snapshot.cleave.duration, _, _ = GetSpellCooldown(TRB.Data.spells.cleave.id)
						end
					elseif spellId == TRB.Data.spells.ignorePain.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							-- This API call isn't working. Manual override for now.
							--TRB.Data.snapshot.ignorePain.startTime, TRB.Data.snapshot.ignorePain.duration, _, _ = GetSpellCooldown(TRB.Data.spells.ignorePain.id)
							TRB.Data.snapshot.ignorePain.startTime = currentTime
							TRB.Data.snapshot.ignorePain.duration = TRB.Data.spells.ignorePain.duration
						end
					elseif spellId == TRB.Data.spells.suddenDeath.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.suddenDeath)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.warrior.arms.audio.suddenDeath.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.warrior.arms.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == TRB.Data.spells.battlelord.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.battlelord)
					elseif spellId == TRB.Data.spells.rend.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rend Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].rend = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.rend = (TRB.Data.snapshot.targetData.rend or 0) + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].rend = false
								TRB.Data.snapshot.targetData.targets[destGUID].rendRemaining = 0
								TRB.Data.snapshot.targetData.rend = (TRB.Data.snapshot.targetData.rend or 0) - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.deepWounds.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Deep Wounds Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].deepWounds = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.deepWounds = (TRB.Data.snapshot.targetData.deepWounds or 0) + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].deepWounds = false
								TRB.Data.snapshot.targetData.targets[destGUID].deepWoundsRemaining = 0
								TRB.Data.snapshot.targetData.deepWounds = (TRB.Data.snapshot.targetData.deepWounds or 0) - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.whirlwind.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.whirlwind.startTime, TRB.Data.snapshot.whirlwind.duration, _, _ = GetSpellCooldown(TRB.Data.spells.whirlwind.id)
						end
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "fury" then
					if spellId == TRB.Data.spells.bladestorm.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.bladestorm, true)
						if type == "SPELL_AURA_APPLIED" then
							TRB.Data.snapshot.bladestorm.originalDuration = TRB.Data.snapshot.bladestorm.duration
							TRB.Data.snapshot.casting.spellId = TRB.Data.spells.bladestorm.id
							TRB.Data.snapshot.casting.icon = TRB.Data.spells.bladestorm.icon
							UpdateBladestorm()
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.bladestorm.ticksRemaining = 0
							TRB.Data.snapshot.bladestorm.originalDuration = 0
							TRB.Data.snapshot.bladestorm.rage = 0
						end
					elseif spellId == TRB.Data.spells.enrage.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.enrage)
					elseif spellId == TRB.Data.spells.whirlwind.id then
						if type == "SPELL_CAST_SUCCESS" then
							_, _, TRB.Data.snapshot.whirlwind.stacks, _, TRB.Data.snapshot.whirlwind.duration, TRB.Data.snapshot.whirlwind.endTime, _, _, _, TRB.Data.snapshot.whirlwind.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.whirlwind.id, "player")
						end
					elseif spellId == TRB.Data.spells.suddenDeath.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.suddenDeath)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.warrior.fury.audio.suddenDeath.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.warrior.fury.audio.suddenDeath.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == TRB.Data.spells.ravager.id then
						if type == "SPELL_CAST_SUCCESS" then -- Ravager used
							local ravagerRage = TRB.Data.spells.ravager.rage
							if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.stormOfSteel) then
								ravagerRage = ravagerRage + TRB.Data.spells.stormOfSteel.rage
							end
							TRB.Data.snapshot.ravager.isActive = true
							TRB.Data.snapshot.ravager.totalDuration = TRB.Data.spells.ravager.duration * (TRB.Functions.Character:GetCurrentGCDTime(true) / 1.5)
							TRB.Data.snapshot.ravager.ticksRemaining = TRB.Data.spells.ravager.ticks
							TRB.Data.snapshot.ravager.rage = TRB.Data.snapshot.ravager.ticksRemaining * ravagerRage
							TRB.Data.snapshot.ravager.endTime = currentTime + TRB.Data.snapshot.ravager.totalDuration
							TRB.Data.snapshot.ravager.lastTick = currentTime
							if TRB.Data.snapshot.ravager.rage < 0 then
								TRB.Data.snapshot.ravager.rage = 0
							end
						end
					elseif spellId == TRB.Data.spells.ravager.energizeId then
						if type == "SPELL_ENERGIZE" then
							local ravagerRage = TRB.Data.spells.ravager.rage
							if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.stormOfSteel) then
								ravagerRage = ravagerRage + TRB.Data.spells.stormOfSteel.rage
							end

							TRB.Data.snapshot.ravager.ticksRemaining = TRB.Data.snapshot.ravager.ticksRemaining - 1
							if TRB.Data.snapshot.ravager.ticksRemaining == 0 then
								TRB.Data.snapshot.ravager.ticksRemaining = 0
								TRB.Data.snapshot.ravager.endTime = nil
								TRB.Data.snapshot.ravager.rage = 0
								TRB.Data.snapshot.ravager.isActive = false
								TRB.Data.snapshot.ravager.totalDuration = 0
							else
								TRB.Data.snapshot.ravager.rage = TRB.Data.snapshot.ravager.ticksRemaining * ravagerRage
								TRB.Data.snapshot.ravager.lastTick = currentTime
								if TRB.Data.snapshot.ravager.rage < 0 then
									TRB.Data.snapshot.ravager.rage = 0
								end
							end
						end
					end
				end

				-- Spec Agnostic
				if spellId == TRB.Data.spells.impendingVictory.id then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshot.impendingVictory.startTime, TRB.Data.snapshot.impendingVictory.duration, _, _ = GetSpellCooldown(TRB.Data.spells.impendingVictory.id)
					end
				elseif spellId == TRB.Data.spells.thunderClap.id then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshot.thunderClap.startTime, TRB.Data.snapshot.thunderClap.duration, _, _ = GetSpellCooldown(TRB.Data.spells.thunderClap.id)
					end
				elseif spellId == TRB.Data.spells.execute.id and not TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.improvedExecute) then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshot.execute.startTime, TRB.Data.snapshot.execute.duration, _, _ = GetSpellCooldown(TRB.Data.spells.execute.id)
					end
				elseif spellId == TRB.Data.spells.victoryRush.id then
					TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.victoryRush)
				elseif spellId == TRB.Data.spells.shieldBlock.id then
					if type == "SPELL_CAST_SUCCESS" then
						---@diagnostic disable-next-line: redundant-parameter, cast-local-type
						TRB.Data.snapshot.shieldBlock.charges, TRB.Data.snapshot.shieldBlock.maxCharges, TRB.Data.snapshot.shieldBlock.startTime, TRB.Data.snapshot.shieldBlock.duration, _ = GetSpellCharges(TRB.Data.spells.shieldBlock.id)
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
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.warrior.arms)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.arms)
			specCache.arms.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Arms()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.arms)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Arms
			
			if TRB.Data.barConstructedForSpec ~= "arms" then
				TRB.Data.barConstructedForSpec = "arms"
				ConstructResourceBar(specCache.arms.settings)
			end
		elseif specId == 2 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.warrior.fury)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.fury)
			specCache.fury.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Fury()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.fury)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Fury
			
			if TRB.Data.barConstructedForSpec ~= "fury" then
				TRB.Data.barConstructedForSpec = "fury"
				ConstructResourceBar(specCache.fury.settings)
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
		if classIndexId == 1 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Warrior.LoadDefaultSettings()
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
							TRB.Data.settings.warrior.arms = TRB.Functions.LibSharedMedia:ValidateLsmValues("Arms Warrior", TRB.Data.settings.warrior.arms)
							TRB.Data.settings.warrior.fury = TRB.Functions.LibSharedMedia:ValidateLsmValues("Fury Warrior", TRB.Data.settings.warrior.fury)
							
							FillSpellData_Arms()
							FillSpellData_Fury()
							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Warrior.ConstructOptionsPanel(specCache)
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
		TRB.Data.character.className = "warrior"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage)

		if specId == 1 then		
			TRB.Data.character.specName = "arms"

			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.bloodletting) then
				TRB.Data.character.pandemicModifier = TRB.Data.spells.bloodletting.modifier
			end
		elseif specId == 2 then
			TRB.Data.character.specName = "fury"
		elseif specId == 3 then
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.warrior.arms == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.arms)
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
			TRB.Data.specSupported = true
		elseif specId == 2 and TRB.Data.settings.core.enabled.warrior.fury == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warrior.fury)
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

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.warrior.arms.displayBar.alwaysShow) and (
						(not TRB.Data.settings.warrior.arms.displayBar.notZeroShow) or
						(TRB.Data.settings.warrior.arms.displayBar.notZeroShow and TRB.Data.snapshot.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
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
						(TRB.Data.settings.warrior.fury.displayBar.notZeroShow and TRB.Data.snapshot.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.warrior.fury.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		else
			TRB.Frames.barContainerFrame:Hide()
			TRB.Data.snapshot.isTracking = false
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
				if specId == 1 then
					TRB.Data.snapshot.targetData.targets[guid].rend = false
					TRB.Data.snapshot.targetData.targets[guid].rendRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].deepWounds = false
					TRB.Data.snapshot.targetData.targets[guid].deepWoundsRemaining = 0
				elseif specId == 2 then
				end
			end
			TRB.Data.snapshot.targetData.targets[guid].lastUpdate = GetTime()
		end

		return true
	end
	function TRB.Functions.Class:IsValidVariableForSpec(var)
		local valid = TRB.Functions.BarText:IsValidVariableBase(var)
		local normalizedRage = TRB.Data.snapshot.resource / TRB.Data.resourceFactor
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
			if var == "$suddenDeathTime" then
				if TRB.Data.snapshot.suddenDeath.isActive then
					valid = true
				end
			elseif var == "$rend" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.rend) then
					valid = true
				end
			elseif var == "$rendCount" then
				if TRB.Data.snapshot.targetData.rend > 0 then
					valid = true
				end
			elseif var == "$rendTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rendRemaining > 0 then
					valid = true
				end
			elseif var == "$deepWoundsCount" then
				if TRB.Data.snapshot.targetData.deepWounds > 0 then
					valid = true
				end
			elseif var == "$deepWoundsTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deepWoundsRemaining > 0 then
					valid = true
				end
			elseif var == "$resourceTotal" or var == "$rageTotal" then
				if normalizedRage > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$passive" then
				valid = false
			elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
				if normalizedRage > 0 then
					valid = true
				end
			end
		elseif specId == 2 then --Fury
			if var == "$suddenDeathTime" then
				if TRB.Data.snapshot.suddenDeath.isActive then
					valid = true
				end
			elseif var == "$resourceTotal" or var == "$rageTotal" then
				if normalizedRage > 0 or TRB.Data.snapshot.ravager.rage > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Data.snapshot.ravager.rage > 0 then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
				if normalizedRage > 0 or TRB.Data.snapshot.ravager.rage > 0 then
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
				if TRB.Data.snapshot.whirlwind.stacks ~= nil and TRB.Data.snapshot.whirlwind.stacks > 0 then
					valid = true
				end
			elseif var == "$ravagerTicks" then
				if TRB.Data.snapshot.ravager.isActive then
					valid = true
				end
			elseif var == "$ravagerRage" then
				if TRB.Data.snapshot.ravager.isActive then
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
				(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$rageOvercap" or var == "$resourceOvercap" then
			local threshold = ((TRB.Data.snapshot.resource / TRB.Data.resourceFactor) + TRB.Data.snapshot.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0 then
				valid = true
			end
		end

		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		if GetSpecialization() ~= 1 and GetSpecialization() ~= 2 then
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