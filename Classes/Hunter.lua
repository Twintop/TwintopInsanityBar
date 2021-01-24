local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 3 then --Only do this if we're on a Hunter!
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
		marksmanship = {
			snapshotData = {},
			barTextVariables = {}
		},
		survival = {
			snapshotData = {},
			barTextVariables = {}
		}
	}

	local function FillSpecCache()
		-- Marksmanship
		
		specCache.marksmanship.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				regen = 0
			},
			dots = {
			}
		}
		
		specCache.marksmanship.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 2,
			maxResource = 100,
			covenantId = 0,
			talents = {
				serpentSting = {
					isSelected = false
				},
				barrage = {
					isSelected = false
				},
				aMurderOfCrows = {
					isSelected = false
				},
				explosiveShot = {
					isSelected = false
				},
				chimaeraShot = {
					isSelected = false
				},
				deadEye = {
					isSelected = false
				},
				doubleTap = {
					isSelected = false
				}            
			},
			items = {
			}
		}

		specCache.marksmanship.spells = {
			aimedShot = {
				id = 19434,
				name = "",
				icon = "",
				focus = -35,
				thresholdId = 1,
				settingKey = "aimedShot",
				isSnowflake = true,
				thresholdUsable = false
			},
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				focus = -20,
				thresholdId = 2,
				settingKey = "arcaneShot",
				thresholdUsable = false
			},
			killShot = {
				id = 53351,
				name = "",
				icon = "",
				focus = -10,
				thresholdId = 5,
				settingKey = "killShot",
				healthMinimum = 0.2,
				isSnowflake = true,
				thresholdUsable = false
			},
			multiShot = {
				id = 257620,
				name = "",
				icon = "",
				focus = -20,
				thresholdId = 6,
				settingKey = "multiShot",
				thresholdUsable = false
			},
			scareBeast = {
				id = 1513,
				name = "",
				icon = "",
				focus = -25,
				thresholdId = 9,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			burstingShot = {
				id = 186387,
				name = "",
				icon = "",
				focus = -10,
				thresholdId = 10,
				settingKey = "burstingShot",
				hasCooldown = true,
				thresholdUsable = false
			},
			revivePet = {
				id = 982,
				name = "",
				icon = "",
				focus = -35,
				thresholdId = 11,
				settingKey = "revivePet",
				thresholdUsable = false
			},

			steadyShot = {
				id = 56641,
				name = "",
				icon = "",
				focus = 10
			},
			rapidFire = {
				id = 257044,
				name = "",
				icon = "",
				focus = 1,
				shots = 7,
				duration = 2 --On cast then every 1/3 sec?
			},
			trickShots = { --TODO: Do these ricochets generate Focus from Rapid Fire Rank 2?
				id = 257044,
				name = "",
				icon = "",
				shots = 5
			},
			trueshot = {
				id = 288613,
				name = "",
				icon = "",
				isActive = false,
				modifier = 1.5
			},

			serpentSting = {
				id = 271788,
				name = "",
				icon = "",
				focus = -10,
				thresholdId = 3,
				settingKey = "serpentSting",
				isTalent = true,
				thresholdUsable = false
			},
			barrage = {
				id = 120360,
				name = "",
				icon = "",
				focus = -30, -- -60 for non Marksmanship,
				thresholdId = 4,
				settingKey = "barrage",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			aMurderOfCrows = {
				id = 131894,
				name = "",
				icon = "",
				focus = -20, -- -30 for non Marksmanship,
				thresholdId = 7,
				settingKey = "aMurderOfCrows",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			explosiveShot = {
				id = 212431,
				name = "",
				icon = "",
				focus = -20,
				thresholdId = 8,
				settingKey = "explosiveShot",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			chimaeraShot = {
				id = 342049,
				name = "",
				icon = "",
				focus = -20,
				isTalent = true--[[,
				thresholdId = 13,
				settingKey = "arcaneShot",
				thresholdUsable = false]] --Commenting out for now since it is the same focus as Arcane Shot
			},
			
			flayedShot = {
				id = 324149,
				name = "",
				icon = "",
				focus = -10,
				thresholdId = 12,
				settingKey = "flayedShot",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false
			},
			flayersMark = {
				id = 324156,
				name = "",
				icon = "",
				isActive = false
			},

			secretsOfTheUnblinkingVigil = {
				id = 336892,
				name = "", 
				icon = "",
				isActive = false
			}
		}

		specCache.marksmanship.snapshotData.focusRegen = 0
		specCache.marksmanship.snapshotData.audio = {
		}
		specCache.marksmanship.snapshotData.doubleTap = {
			isActive = false,
			spell = nil
		}
		specCache.marksmanship.snapshotData.trueshot = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.marksmanship.snapshotData.flayersMark = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.marksmanship.snapshotData.aimedShot = {
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.marksmanship.snapshotData.killShot = {
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.marksmanship.snapshotData.burstingShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.barrage = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.aMurderOfCrows = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.explosiveShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.marksmanship.snapshotData.flayedShot = {
			startTime = nil,
			duration = 0
		}
		specCache.marksmanship.snapshotData.secretsOfTheUnblinkingVigil = {
			spellId = nil,
			duration = 0
		}
		specCache.marksmanship.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			serpentSting = 0,
			targets = {}
		}

		specCache.marksmanship.barTextVariables = {
			icons = {},
			values = {}
		}

		-- Survival
		specCache.survival.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				regen = 0,
				termsOfEngagement = 0
			},
			dots = {
				serpentSting = 0
			},
			termsOfEngagement = {
				focus = 0,
				ticks = 0
			}
		}
		
		specCache.survival.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 3,
			maxResource = 100,
			covenantId = 0,
			talents = {
				vipersVenom = {
					isSelected = false
				},
				termsOfEngagement = {
					isSelected = false
				},
				butchery = {
					isSelected = false
				},
				aMurderOfCrows = {
					isSelected = false
				},
				mongooseBite = {
					isSelected = false
				},
				flankingStrike = {
					isSelected = false
				},
				chakrams = {
					isSelected = false
				}            
			},
			items = {
			}
		}

		specCache.survival.spells = {
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				focus = -40,
				thresholdId = 1,
				settingKey = "arcaneShot",
				thresholdUsable = false
			},
			killShot = {
				id = 320976,
				name = "",
				icon = "",
				focus = -10,
				thresholdId = 2,
				settingKey = "killShot",
				healthMinimum = 0.2,
				isSnowflake = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			scareBeast = {
				id = 1513,
				name = "",
				icon = "",
				focus = -25,
				thresholdId = 3,
				settingKey = "scareBeast",
				thresholdUsable = false
			},
			revivePet = {
				id = 982,
				name = "",
				icon = "",
				focus = -10,
				thresholdId = 4,
				settingKey = "revivePet",
				thresholdUsable = false
			},
			wingClip = {
				id = 195645,
				name = "",
				icon = "",
				focus = -20,
				thresholdId = 5,
				settingKey = "wingClip",
				thresholdUsable = false
			},

			steadyShot = {
				id = 56641,
				name = "",
				icon = ""
			},
			carve = {
				id = 187708,
				name = "",
				icon = "",
				focus = -35,
				thresholdId = 6,
				settingKey = "carve",
				isSnowflake = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			butchery = {
				id = 212436,
				name = "",
				icon = "",
				focus = -30,
				isTalent = true,
				hasCooldown = true,
				isSnowflake = true,
				thresholdId = 7,
				settingKey = "carve",
				thresholdUsable = false
			},
			raptorStrike = {
				id = 186270,
				name = "",
				icon = "",
				focus = -30,
				thresholdId = 8,
				settingKey = "raptorStrike",
				thresholdUsable = false
			},
			mongooseBite = {
				id = 259387,
				name = "",
				icon = "",
				focus = -30,
				isTalent = true--[[,
				thresholdId = 8,
				settingKey = "raptorStrike",
				thresholdUsable = false]] --Commenting out for now since it is the same focus as Raptor Strike
			},
			harpoon = {
				id = 190925,
				name = "",
				icon = "",
				focus = 2,
				duration = 10 --2*10 = 20 total focus
			},
			killCommand = {
				id = 259489,
				name = "",
				icon = "",
				focus = 15
			},
			coordinatedAssault = {
				id = 266779,
				name = "",
				icon = "",
				isActive = false
			},

			serpentSting = {
				id = 259491,
				name = "",
				icon = "",
				focus = -20,
				thresholdId = 9,
				settingKey = "serpentSting",
				thresholdUsable = false
			},
			flankingStrike = {
				id = 269751,
				name = "",
				icon = "",
				focus = 30,
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			aMurderOfCrows = {
				id = 131894,
				name = "",
				icon = "",
				focus = -30,
				thresholdId = 10,
				settingKey = "aMurderOfCrows",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			chakrams = {
				id = 259391,
				name = "",
				icon = "",
				focus = -15,
				thresholdId = 11,
				settingKey = "chakrams",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},

			flayedShot = {
				id = 324149,
				name = "",
				icon = "",
				focus = -10,
				thresholdId = 12,
				settingKey = "flayedShot",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false
			},
			flayersMark = {
				id = 324156,
				name = "",
				icon = "",
				isActive = false
			},

			termsOfEngagement = {
				id = 265898,
				name = "",
				icon = "",
				focus = 2,
				ticks = 10,
				duration = 10,
				fotm = false
			},
		}

		specCache.survival.snapshotData.focusRegen = 0
		specCache.survival.snapshotData.audio = {
		}
		specCache.survival.snapshotData.coordinatedAssault = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.survival.snapshotData.termsOfEngagement = {
			isActive = false,
			ticksRemaining = 0,
			focus = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.survival.snapshotData.carve = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.flayersMark = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.survival.snapshotData.flayedShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.killShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.aMurderOfCrows = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.butchery = {
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.survival.snapshotData.chakrams = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.flankingStrike = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.survival.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			serpentSting = 0,
			targets = {}
		}

		specCache.survival.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Marksmanship()	
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.marksmanship)
	end

	local function Setup_Survival()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end		

		TRB.Functions.LoadFromSpecCache(specCache.survival)
	end

	local function FillSpellData_Marksmanship()
		Setup_Marksmanship()
		local spells = TRB.Functions.FillSpellData(specCache.marksmanship.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.marksmanship.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the focus generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via it's spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#aimedShot", icon = spells.aimedShot.icon, description = "Aimed Shot", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barrage", icon = spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#burstingShot", icon = spells.burstingShot.icon, description = "Bursting Shot", printInSettings = true },
			{ variable = "#chimaeraShot", icon = spells.chimaeraShot.icon, description = "Chimaera Shot", printInSettings = true },
			{ variable = "#explosiveShot", icon = spells.explosiveShot.icon, description = "Explosive Shot", printInSettings = true },
			{ variable = "#flayedShot", icon = spells.flayedShot.icon, description = "Flayed Shot", printInSettings = true },
			{ variable = "#flayersMark", icon = spells.flayersMark.icon, description = "Flayer's Mark", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#multiShot", icon = spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = "Rapid Fire", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = "Steady Shot", printInSettings = true },
			{ variable = "#trickShots", icon = spells.trickShots.icon, description = "Trick Shots", printInSettings = true },
			{ variable = "#trueshot", icon = spells.trueshot.icon, description = "Trueshot", printInSettings = true },
        }
		specCache.marksmanship.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
	
			{ variable = "$focus", description = "Current Focus", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Focus", printInSettings = false, color = false },
			{ variable = "$focusMax", description = "Maximum Focus", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Focus", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Focus from Passive Sources including Regen", printInSettings = true, color = false },
			{ variable = "$regen", description = "Focus from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenFocus", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusRegen", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusPlusCasting", description = "Current + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Focus Total", printInSettings = false, color = false },
			{ variable = "$focusPlusPassive", description = "Current + Passive Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Focus Total", printInSettings = false, color = false },
			{ variable = "$focusTotal", description = "Current + Passive + Casting Focus Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Focus Total", printInSettings = false, color = false },   

			{ variable = "$trueshotTime", description = "Time remaining on Trueshot buff", printInSettings = true, color = false },   
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$serpentSting", description = "Is Serpent Sting talented? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$flayersMarkTime", description = "Time remaining on Flayer's Mark buff", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.marksmanship.spells = spells
	end

	local function FillSpellData_Survival()
		Setup_Survival()
		local spells = TRB.Functions.FillSpellData(specCache.survival.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.survival.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the focus generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via it's spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#butchery", icon = spells.butchery.icon, description = "Butchery", printInSettings = true },
			{ variable = "#carve", icon = spells.carve.icon, description = "Carve", printInSettings = true },
			{ variable = "#chakrams", icon = spells.chakrams.icon, description = "Chakrams", printInSettings = true },
			{ variable = "#coordinatedAssault", icon = spells.coordinatedAssault.icon, description = "Coordinated Assault", printInSettings = true },
			{ variable = "#ca", icon = spells.coordinatedAssault.icon, description = "Coordinated Assault", printInSettings = false },
			{ variable = "#flankingStrike", icon = spells.flankingStrike.icon, description = "Flanking Strike", printInSettings = true },
			{ variable = "#flayedShot", icon = spells.flayedShot.icon, description = "Flayed Shot", printInSettings = true },
			{ variable = "#flayersMark", icon = spells.flayersMark.icon, description = "Flayer's Mark", printInSettings = true },
			{ variable = "#harpoon", icon = spells.harpoon.icon, description = "Harpoon", printInSettings = true },
			{ variable = "#killCommand", icon = spells.killCommand.icon, description = "Kill Command", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#mongooseBite", icon = spells.mongooseBite.icon, description = "Mongoose Bite", printInSettings = true },
			{ variable = "#raptorStrike", icon = spells.raptorStrike.icon, description = "Raptor Strike", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = "Steady Shot", printInSettings = true },
			{ variable = "#termsOfEngagement", icon = spells.termsOfEngagement.icon, description = "Terms of Engagement", printInSettings = true },
			{ variable = "#wingClip", icon = spells.wingClip.icon, description = "Wing Clip", printInSettings = true },			
        }
		specCache.survival.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
	
			{ variable = "$focus", description = "Current Focus", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Focus", printInSettings = false, color = false },
			{ variable = "$focusMax", description = "Maximum Focus", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Focus", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Focus from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Focus from Passive Sources including Regen", printInSettings = true, color = false },
			{ variable = "$regen", description = "Focus from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenFocus", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusRegen", description = "Focus from Passive Regen", printInSettings = false, color = false },
			{ variable = "$focusPlusCasting", description = "Current + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Focus Total", printInSettings = false, color = false },
			{ variable = "$focusPlusPassive", description = "Current + Passive Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Focus Total", printInSettings = false, color = false },
			{ variable = "$focusTotal", description = "Current + Passive + Casting Focus Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Focus Total", printInSettings = false, color = false },   

			{ variable = "$coordinatedAssaultTime", description = "Time remaining on Coordinated Assault buff", printInSettings = true, color = false },   
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$serpentSting", description = "Is Serpent Sting talented? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$toeFocus", description = "Focus from Terms of Engagement", printInSettings = true, color = false },
			{ variable = "$toeTicks", description = "Number of ticks left on Terms of Engagement", printInSettings = true, color = false },

			{ variable = "$flayersMarkTime", description = "Time remaining on Flayer's Mark buff", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.survival.spells = spells
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Focus)
		TRB.Data.character.covenantId = C_Covenants.GetActiveCovenantID()
		
		if GetSpecialization() == 1 then
		elseif GetSpecialization() == 2 then
			TRB.Data.character.talents.serpentSting.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.barrage.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.explosiveShot.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.chimaeraShot.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.deadEye.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.doubleTap.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
		elseif GetSpecialization() == 3 then
			TRB.Data.character.talents.vipersVenom.isSelected = select(4, GetTalentInfo(1, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.termsOfEngagement.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.butchery.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.mongooseBite.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.flankingStrike.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.chakrams.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))
		end
	end
	
	local function IsTtdActive(settings)
		if settings ~= nil and settings.displayText ~= nil then
			if string.find(settings.displayText.left.text, "$ttd") or
				string.find(settings.displayText.middle.text, "$ttd") or
				string.find(settings.displayText.right.text, "$ttd") then
				TRB.Data.snapshotData.targetData.ttdIsActive = true
			else
				TRB.Data.snapshotData.targetData.ttdIsActive = false
			end
		else
			TRB.Data.snapshotData.targetData.ttdIsActive = false
		end
    end
	TRB.Functions.IsTtdActive = IsTtdActive

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 2 then
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.marksmanship)
			TRB.Data.resource = Enum.PowerType.Focus
			TRB.Data.resourceFactor = 1
			TRB.Data.specSupported = true
            CheckCharacter()
            
			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
            
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = true
		elseif specId == 3 then
			TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.survival)
			TRB.Data.resource = Enum.PowerType.Focus
			TRB.Data.resourceFactor = 1
			TRB.Data.specSupported = true
            CheckCharacter()
            
			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
            
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = true
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
	end

	local function InitializeTarget(guid)
		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
			TRB.Data.snapshotData.targetData.targets[guid].serpentSting = false
		end	
	end

	local function GetTrueshotRemainingTime()		
		local currentTime = GetTime()
		local remainingTime = 0

		if TRB.Data.spells.trueshot.isActive then
			remainingTime = TRB.Data.snapshotData.trueshot.endTime - currentTime
		end

		return remainingTime
	end

	local function GetCoordinatedAssaultRemainingTime()		
		local currentTime = GetTime()
		local remainingTime = 0

		if TRB.Data.spells.coordinatedAssault.isActive then
			remainingTime = TRB.Data.snapshotData.coordinatedAssault.endTime - currentTime
		end

		return remainingTime
	end

	local function GetFlayersMarkRemainingTime()		
		local currentTime = GetTime()
		local remainingTime = 0

		if TRB.Data.spells.flayersMark.isActive then
			remainingTime = TRB.Data.snapshotData.flayersMark.endTime - currentTime
		end

		return remainingTime
	end
	
    local function CalculateResourceGain(resource)
        local modifier = 1.0
                
        if resource > 0 and GetSpecialization() == 2 and TRB.Data.spells.trueshot.isActive then
            modifier = modifier * TRB.Data.spells.trueshot.modifier
        end

        return resource * modifier
    end

	local function UpdateCastingResourceFinal()	
		TRB.Data.snapshotData.casting.resourceFinal = CalculateResourceGain(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local ssTotal = 0
		for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
				TRB.Data.snapshotData.targetData.targets[guid].serpentSting = false
			else
				if TRB.Data.snapshotData.targetData.targets[guid].serpentSting == true then
					ssTotal = ssTotal + 1
				end
			end
		end	
		TRB.Data.snapshotData.targetData.serpentSting = ssTotal
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.serpentSting = 0
		end
	end

    local function ConstructResourceBar(settings)
		local resourceFrameCounter = 1
        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
				TRB.Frames.resourceFrame.thresholds[resourceFrameCounter] = TRB.Frames.resourceFrame.thresholds[resourceFrameCounter] or CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
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
		if specId == 2 then
			settings = TRB.Data.settings.hunter.marksmanship
		elseif specId == 3 then
			settings = TRB.Data.settings.hunter.survival
		end

		if specId == 2 then --Marksmanship
			if var == "$trueshotTime" then
				if GetTrueshotRemainingTime() > 0 then
					valid = true
				end		
			elseif var == "$serpentSting" then
				if TRB.Data.character.talents.serpentSting.isSelected then
					valid = true
				end
			end
		elseif specId == 3 then --Survivial
			if var == "$coordinatedAssaultTime" then
				if GetCoordinatedAssaultRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$toeFocus" then
				if TRB.Data.snapshotData.termsOfEngagement.focus > 0 then
					valid = true
				end
			elseif var == "$toeTicks" then
				if TRB.Data.snapshotData.termsOfEngagement.ticksRemaining > 0 then
					valid = true
				end
			end
		end

		if var == "$resource" or var == "$focus" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$focusMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$focusTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$focusPlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$focusOvercap" or var == "$resourceOvercap" then
			if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$focusPlusPassive" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			elseif specId == 3 and TRB.Data.snapshotData.termsOfEngagement.focus > 0 then
				valid = true
			end
		elseif var == "$regen" or var == "$regenFocus" or var == "$focusRegen" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$flayersMark" then
			if GetFlayersMarkRemainingTime() > 0 then
				valid = true
			end
		elseif var == "$ssCount" then
			if TRB.Data.snapshotData.targetData.serpentSting > 0 then
				valid = true
			end				
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Marksmanship()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.focusRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.current
		local castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.casting

		if TRB.Data.settings.hunter.marksmanship.colors.text.overcapEnabled and overcap then 
			currentFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overcap
            castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overcap
		elseif TRB.Data.settings.hunter.marksmanship.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end	
			end

			if _overThreshold then
				currentFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overThreshold
				castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.overThreshold
			end
		end
		
		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.spending
		end
        
		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _regenFocus = TRB.Data.snapshotData.focusRegen
		local _passiveFocus
		
		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.hunter.marksmanship.generation.mode == "time" then
			_regenFocus = _regenFocus * (TRB.Data.settings.hunter.marksmanship.generation.time or 3.0)
		else
			_regenFocus = _regenFocus * ((TRB.Data.settings.hunter.marksmanship.generation.gcds or 2) * _gcd)
		end

		--$reginFocus
		local regenFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.passive, _regenFocus)
		_passiveFocus = _regenFocus

		local passiveFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.marksmanship.colors.text.passive, _passiveFocus)
		--$focusTotal
		local _focusTotal = math.min(_passiveFocus + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passiveFocus + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		--$trueshotTime
		local _trueshotTime = GetTrueshotRemainingTime()
		local trueshotTime = 0
		if _trueshotTime ~= nil then
			trueshotTime = string.format("%.1f", _trueshotTime)
		end
		
		--$flayersMarkTime
		local _flayersMarkTime = GetFlayersMarkRemainingTime()
		local flayersMarkTime = 0
		if _flayersMarkTime ~= nil then
			flayersMarkTime = string.format("%.1f", _flayersMarkTime)
		end

		--$ssCount
		local serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveFocus
		Global_TwintopResourceBar.resource.regen = _regenFocus
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}

		lookup = TRB.Data.lookup or {}	
		lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
		lookup["#aimedShot"] = TRB.Data.spells.aimedShot.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#barrage"] = TRB.Data.spells.barrage.icon
		lookup["#burstingShot"] = TRB.Data.spells.burstingShot.icon
		lookup["#chimaeraShot"] = TRB.Data.spells.chimaeraShot.icon
		lookup["#explosiveShot"] = TRB.Data.spells.explosiveShot.icon
		lookup["#flayedShot"] = TRB.Data.spells.flayedShot.icon
		lookup["#flayersMark"] = TRB.Data.spells.flayersMark.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#multiShot"] = TRB.Data.spells.multiShot.icon
		lookup["#rapidFire"] = TRB.Data.spells.rapidFire.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["#steadyShot"] = TRB.Data.spells.steadyShot.icon
		lookup["#trickShots"] = TRB.Data.spells.trickShots.icon
		lookup["#trueshot"] = TRB.Data.spells.trueshot.icon
		lookup["$trueshotTime"] = trueshotTime
		lookup["$flayersMarkTime"] = flayersMarkTime
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$ssCount"] = serpentStingCount
		lookup["$focusTotal"] = focusTotal
		lookup["$focusMax"] = TRB.Data.character.maxResource
		lookup["$focus"] = currentFocus
		lookup["$resourcePlusCasting"] = focusPlusCasting
		lookup["$resourcePlusPassive"] = focusPlusPassive
		lookup["$resourceTotal"] = focusTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentFocus
		lookup["$casting"] = castingFocus
		lookup["$passive"] = passiveFocus
		lookup["$regen"] = regenFocus
		lookup["$regenFocus"] = regenFocus
		lookup["$focusRegen"] = regenFocus
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$focusOvercap"] = overcap
		TRB.Data.lookup = lookup
	end

	local function RefreshLookupData_Survival()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.focusRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentFocusColor = TRB.Data.settings.hunter.survival.colors.text.current
		local castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.casting

		if TRB.Data.settings.hunter.survival.colors.text.overcapEnabled and overcap then 
			currentFocusColor = TRB.Data.settings.hunter.survival.colors.text.overcap
            castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.overcap
		elseif TRB.Data.settings.hunter.survival.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end	
			end

			if _overThreshold then
				currentFocusColor = TRB.Data.settings.hunter.survival.colors.text.overThreshold
				castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.overThreshold
			end
		end
		
		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFocusColor = TRB.Data.settings.hunter.survival.colors.text.spending
		end
        
		--$focus
		local currentFocus = string.format("|c%s%.0f|r", currentFocusColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingFocus = string.format("|c%s%.0f|r", castingFocusColor, TRB.Data.snapshotData.casting.resourceFinal)

		--$toeFocus
		local _toeFocus = TRB.Data.snapshotData.termsOfEngagement.focus
		local toeFocus = string.format("%.0f", _toeFocus)
		--$toeTicks 
		local toeTicks = string.format("%.0f", TRB.Data.snapshotData.termsOfEngagement.ticksRemaining)

		local _regenFocus = TRB.Data.snapshotData.focusRegen
		local _passiveFocus
		
		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.hunter.survival.generation.mode == "time" then
			_regenFocus = _regenFocus * (TRB.Data.settings.hunter.survival.generation.time or 3.0)
		else
			_regenFocus = _regenFocus * ((TRB.Data.settings.hunter.survival.generation.gcds or 2) * _gcd)
		end

		--$reginFocus
		local regenFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.passive, _regenFocus)
		_passiveFocus = _regenFocus + _toeFocus

		--$passive
		local passiveFocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.survival.colors.text.passive, _passiveFocus)
		--$focusTotal
		local _focusTotal = math.min(_passiveFocus + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passiveFocus + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		--$coordinatedAssaultTime
		local _coordinatedAssaultTime = GetCoordinatedAssaultRemainingTime()
		local coordinatedAssaultTime = 0
		if _coordinatedAssaultTime ~= nil then
			coordinatedAssaultTime = string.format("%.1f", _coordinatedAssaultTime)
		end
		
		--$flayersMarkTime
		local _flayersMarkTime = GetFlayersMarkRemainingTime()
		local flayersMarkTime = 0
		if _flayersMarkTime ~= nil then
			flayersMarkTime = string.format("%.1f", _flayersMarkTime)
		end

		--$ssCount
		local serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveFocus
		Global_TwintopResourceBar.resource.regen = _regenFocus
		Global_TwintopResourceBar.resource.termsOfEngagement = _toeFocus
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}		
		Global_TwintopResourceBar.termsOfEngagement = {
			focus = _toeFocus,
			ticks = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining or 0
		}

		lookup = TRB.Data.lookup or {}
		lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#butchery"] = TRB.Data.spells.butchery.icon
		lookup["#carve"] = TRB.Data.spells.carve.icon
		lookup["#chakrams"] = TRB.Data.spells.chakrams.icon
		lookup["#coordinatedAssault"] = TRB.Data.spells.coordinatedAssault.icon
		lookup["#ca"] = TRB.Data.spells.coordinatedAssault.icon
		lookup["#flankingStrike"] = TRB.Data.spells.flankingStrike.icon
		lookup["#flayedShot"] = TRB.Data.spells.flayedShot.icon
		lookup["#flayersMark"] = TRB.Data.spells.flayersMark.icon
		lookup["#harpoon"] = TRB.Data.spells.harpoon.icon
		lookup["#killCommand"] = TRB.Data.spells.killCommand.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#mongooseBite"] = TRB.Data.spells.mongooseBite.icon
		lookup["#raptorStrike"] = TRB.Data.spells.raptorStrike.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["#steadyShot"] = TRB.Data.spells.steadyShot.icon
		lookup["#termsOfEngagement"] = TRB.Data.spells.termsOfEngagement.icon
		lookup["#wingClip"] = TRB.Data.spells.wingClip.icon
		lookup["$coordinatedAssaultTime"] = coordinatedAssaultTime
		lookup["$flayersMarkTime"] = flayersMarkTime
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$ssCount"] = serpentStingCount
		lookup["$focusTotal"] = focusTotal
		lookup["$focusMax"] = TRB.Data.character.maxResource
		lookup["$focus"] = currentFocus
		lookup["$resourcePlusCasting"] = focusPlusCasting
		lookup["$resourcePlusPassive"] = focusPlusPassive
		lookup["$resourceTotal"] = focusTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentFocus
		lookup["$casting"] = castingFocus
		lookup["$passive"] = passiveFocus		
		lookup["$regen"] = regenFocus
		lookup["$regenFocus"] = regenFocus
		lookup["$focusRegen"] = regenFocus
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$focusOvercap"] = overcap
		lookup["$toeFocus"] = toeFocus
		lookup["$toeTicks"] = toeTicks
		TRB.Data.lookup = lookup
	end

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.focus
        TRB.Data.snapshotData.casting.resourceFinal = spell.focus
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
			if specId == 2 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					if spellName == TRB.Data.spells.aimedShot.name then
						FillSnapshotDataCasting(TRB.Data.spells.aimedShot)
					elseif spellName == TRB.Data.spells.steadyShot.name then
						FillSnapshotDataCasting(TRB.Data.spells.steadyShot)
					elseif spellName == TRB.Data.spells.scareBeast.name then
						FillSnapshotDataCasting(TRB.Data.spells.scareBeast)
					elseif spellName == TRB.Data.spells.revivePet.name then
						FillSnapshotDataCasting(TRB.Data.spells.revivePet)
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false				
					end
					UpdateCastingResourceFinal()
				end
				return true
			elseif specId == 3 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					--See Priest implementation for handling channeled spells
				else
					if spellName == TRB.Data.spells.scareBeast.name then
						FillSnapshotDataCasting(TRB.Data.spells.scareBeast)
					elseif spellName == TRB.Data.spells.revivePet.name then
						FillSnapshotDataCasting(TRB.Data.spells.revivePet)
					else
						return false
					end
				end
			end
			return false
		end
	end

	local function UpdateTermsOfEngagement()
		if TRB.Data.snapshotData.termsOfEngagement.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.termsOfEngagement.endTime == nil or currentTime > TRB.Data.snapshotData.termsOfEngagement.endTime then
				TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = 0
				TRB.Data.snapshotData.termsOfEngagement.endTime = nil
				TRB.Data.snapshotData.termsOfEngagement.focus = 0			
				TRB.Data.snapshotData.termsOfEngagement.isActive = false
			else
				TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = math.ceil(TRB.Data.snapshotData.termsOfEngagement.endTime - currentTime) / (TRB.Data.spells.termsOfEngagement.duration / TRB.Data.spells.termsOfEngagement.ticks)
				TRB.Data.snapshotData.termsOfEngagement.focus = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus
			end
		end
	end

	local function UpdateSnapshot()
		local currentTime = GetTime()

        if TRB.Data.snapshotData.aMurderOfCrows.startTime ~= nil and currentTime > (TRB.Data.snapshotData.aMurderOfCrows.startTime + TRB.Data.snapshotData.aMurderOfCrows.duration) then
            TRB.Data.snapshotData.aMurderOfCrows.startTime = nil
            TRB.Data.snapshotData.aMurderOfCrows.duration = 0
        end

        if TRB.Data.snapshotData.flayedShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.flayedShot.startTime + TRB.Data.snapshotData.flayedShot.duration) then
            TRB.Data.snapshotData.flayedShot.startTime = nil
            TRB.Data.snapshotData.flayedShot.duration = 0
        end
	end

	local function UpdateSnapshot_Marksmanship()
		TRB.Functions.UpdateSnapshot()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _
		
        TRB.Data.snapshotData.aimedShot.charges, _, TRB.Data.snapshotData.aimedShot.startTime, TRB.Data.snapshotData.aimedShot.duration, _ = GetSpellCharges(TRB.Data.spells.aimedShot.id)
        TRB.Data.snapshotData.killShot.charges, _, TRB.Data.snapshotData.killShot.startTime, TRB.Data.snapshotData.killShot.duration, _ = GetSpellCharges(TRB.Data.spells.killShot.id)

        if TRB.Data.snapshotData.burstingShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.burstingShot.startTime + TRB.Data.snapshotData.burstingShot.duration) then
            TRB.Data.snapshotData.burstingShot.startTime = nil
            TRB.Data.snapshotData.burstingShot.duration = 0
        end

        if TRB.Data.snapshotData.barrage.startTime ~= nil and currentTime > (TRB.Data.snapshotData.barrage.startTime + TRB.Data.snapshotData.barrage.duration) then
            TRB.Data.snapshotData.barrage.startTime = nil
            TRB.Data.snapshotData.barrage.duration = 0
        end

        if TRB.Data.snapshotData.explosiveShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.explosiveShot.startTime + TRB.Data.snapshotData.explosiveShot.duration) then
            TRB.Data.snapshotData.explosiveShot.startTime = nil
            TRB.Data.snapshotData.explosiveShot.duration = 0
        end

        if TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime ~= nil and currentTime > (TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime + TRB.Data.snapshotData.flayedShot.duration) then
            TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime = nil
            TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration = 0
        end
	end    

	local function UpdateSnapshot_Survival()
        TRB.Functions.UpdateSnapshot()
		UpdateSnapshot()
		UpdateTermsOfEngagement()
		local currentTime = GetTime()
        local _
		
		TRB.Data.snapshotData.butchery.charges, _, TRB.Data.snapshotData.butchery.startTime, TRB.Data.snapshotData.butchery.duration, _ = GetSpellCharges(TRB.Data.spells.butchery.id)

		if TRB.Data.snapshotData.carve.startTime ~= nil and currentTime > (TRB.Data.snapshotData.carve.startTime + TRB.Data.snapshotData.carve.duration) then
            TRB.Data.snapshotData.carve.startTime = nil
            TRB.Data.snapshotData.carve.duration = 0
        end

		if TRB.Data.snapshotData.chakrams.startTime ~= nil and currentTime > (TRB.Data.snapshotData.chakrams.startTime + TRB.Data.snapshotData.chakrams.duration) then
            TRB.Data.snapshotData.chakrams.startTime = nil
            TRB.Data.snapshotData.chakrams.duration = 0
        end

		if TRB.Data.snapshotData.flankingStrike.startTime ~= nil and currentTime > (TRB.Data.snapshotData.flankingStrike.startTime + TRB.Data.snapshotData.flankingStrike.duration) then
            TRB.Data.snapshotData.flankingStrike.startTime = nil
            TRB.Data.snapshotData.flankingStrike.duration = 0
        end

		if TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration) then
            TRB.Data.snapshotData.killShot.startTime = nil
            TRB.Data.snapshotData.killShot.duration = 0
        end
	end   

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 2 then
			if force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.hunter.marksmanship.displayBar.alwaysShow) and (
						(not TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow) or
						(TRB.Data.settings.hunter.marksmanship.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()	
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.hunter.marksmanship.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()	
				else
					TRB.Frames.barContainerFrame:Show()	
				end
			end
		elseif specId == 3 then
			if force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.hunter.survival.displayBar.alwaysShow) and (
						(not TRB.Data.settings.hunter.survival.displayBar.notZeroShow) or
						(TRB.Data.settings.hunter.survival.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()	
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.hunter.survival.displayBar.neverShow == true then
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

		if specId == 2 then
			UpdateSnapshot_Marksmanship()

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()	
				
				if TRB.Data.settings.hunter.marksmanship.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)	
					if TRB.Data.settings.hunter.marksmanship.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.borderOvercap, true))
						
						if TRB.Data.settings.hunter.marksmanship.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					local passiveValue = 0
					if TRB.Data.settings.hunter.marksmanship.generation.mode == "time" then
						passiveValue = (TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.marksmanship.generation.time or 3.0))
					else
						passiveValue = (TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.marksmanship.generation.gcds or 2) * gcd))
					end

					if CastingSpell() then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end
					
					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, resourceFrame, castingBarValue) 
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.marksmanship, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.marksmanship.colors.bar.passive, true))
					end

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.marksmanship, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.hunter.marksmanship.thresholdWidth, -spell.focus, TRB.Data.character.maxResource)
							
							local showThreshold = true
							local thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
							local frameLevel = 129

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.aimedShot.id then
									if TRB.Data.snapshotData.aimedShot.charges == 0 then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -spell.focus or TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration > 0 then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local flayersMarkTime = GetFlayersMarkRemainingTime()
									if (targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum) and flayersMarkTime == 0 then
										showThreshold = false
									elseif TRB.Data.snapshotData.killShot.charges == 0 and flayersMarkTime == 0 then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -spell.focus or flayersMarkTime > 0 then
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.flayedShot.id then
									local flayersMarkTime = GetFlayersMarkRemainingTime() -- Change this to layer stacking if the cost of Kill Shot or Flayed Shot changes from 10 Focus!
									if TRB.Data.character.covenantId == 2 and flayersMarkTime == 0 then -- Venthyr and Flayer's Mark buff isn't up
										if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -spell.focus then
											thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
											frameLevel = 128
										end
									else
										showThreshold = false
									end
								end
							elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
									frameLevel = 127
								elseif TRB.Data.snapshotData.resource >= -spell.focus then
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -spell.focus then
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.hunter.marksmanship.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
								resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
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

					local barColor = TRB.Data.settings.hunter.marksmanship.colors.bar.base

					if TRB.Data.spells.trueshot.isActive then
						local timeThreshold = 0
						local useEndOfTrueshotColor = false

						if TRB.Data.settings.hunter.marksmanship.endOfTrueshot.enabled then
							useEndOfTrueshotColor = true
							if TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.hunter.marksmanship.endOfTrueshot.gcdsMax
							elseif TRB.Data.settings.hunter.marksmanship.endOfTrueshot.mode == "time" then
								timeThreshold = TRB.Data.settings.hunter.marksmanship.endOfTrueshot.timeMax
							end
						end
						
						if useEndOfTrueshotColor and GetTrueshotRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.hunter.marksmanship.colors.bar.trueshotEnding
						else
							barColor = TRB.Data.settings.hunter.marksmanship.colors.bar.trueshot
						end
					end
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end		
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.hunter.marksmanship, refreshText)
		elseif specId == 3 then
			UpdateSnapshot_Survival()

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()	
				
				if TRB.Data.settings.hunter.survival.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)	
					if TRB.Data.settings.hunter.survival.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.borderOvercap, true))
						
						if TRB.Data.settings.hunter.survival.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.hunter.survival.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					local passiveValue = 0
					if TRB.Data.settings.hunter.survival.generation.mode == "time" then
						passiveValue = (TRB.Data.snapshotData.focusRegen * (TRB.Data.settings.hunter.survival.generation.time or 3.0))
					else
						passiveValue = (TRB.Data.snapshotData.focusRegen * ((TRB.Data.settings.hunter.survival.generation.gcds or 2) * gcd))
					end

					if CastingSpell() then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end
					
					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, resourceFrame, castingBarValue) 
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.hunter.survival, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.hunter.survival.colors.bar.passive, true))
					end

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local showThreshold = true
							local thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
							local frameLevel = 129

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local flayersMarkTime = GetFlayersMarkRemainingTime()
									if (targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum) and flayersMarkTime == 0 then
										showThreshold = false
									elseif flayersMarkTime == 0 and (TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime < (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration)) then
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -spell.focus or flayersMarkTime > 0 then
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.flayedShot.id then
									local flayersMarkTime = GetFlayersMarkRemainingTime() -- Change this to layer stacking if the cost of Kill Shot or Flayed Shot changes from 10 Focus!
									if TRB.Data.character.covenantId == 2 and flayersMarkTime == 0 then -- Venthyr and Flayer's Mark buff isn't up
										if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -spell.focus then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
											frameLevel = 128
										end
									else
										showThreshold = false
									end
								elseif spell.id == TRB.Data.spells.carve.id then
									if TRB.Data.character.talents.butchery.isSelected then
										showThreshold = false
									else
										if TRB.Data.snapshotData.carve.startTime ~= nil and currentTime < (TRB.Data.snapshotData.carve.startTime + TRB.Data.snapshotData.carve.duration) then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -spell.focus then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
											frameLevel = 128
										end
									end
								elseif spell.id == TRB.Data.spells.butchery.id then
									if not TRB.Data.character.talents.butchery.isSelected then
										showThreshold = false
									else
										if TRB.Data.snapshotData.butchery.charges == 0 then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -spell.focus then
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
											frameLevel = 128
										end
									end
								end
							elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
								showThreshold = false
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.unusable
									frameLevel = 127
								elseif TRB.Data.snapshotData.resource >= -spell.focus then
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -spell.focus then
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.hunter.survival.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.hunter.survival.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.hunter.survival, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.hunter.survival.thresholdWidth, -spell.focus, TRB.Data.character.maxResource)
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
								resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
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

					local barColor = TRB.Data.settings.hunter.survival.colors.bar.base

					if TRB.Data.spells.coordinatedAssault.isActive then
						local timeThreshold = 0
						local useEndOfCoordinatedAssaultColor = false

						if TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.enabled then
							useEndOfCoordinatedAssaultColor = true
							if TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.gcdsMax
							elseif TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.mode == "time" then
								timeThreshold = TRB.Data.settings.hunter.survival.endOfCoordinatedAssault.timeMax
							end
						end
						
						if useEndOfCoordinatedAssaultColor and GetCoordinatedAssaultRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssaultEnding
						else
							barColor = TRB.Data.settings.hunter.survival.colors.bar.coordinatedAssault
						end
					end
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.hunter.survival, refreshText)
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		if GetSpecialization() ~= 2 and GetSpecialization() ~= 3 then
			TRB.Functions.HideResourceBar(true)
			return
		end	

		local currentTime = GetTime()
		
		if updateRateLimit + 0.05 < currentTime then
			updateRateLimit = currentTime
			UpdateResourceBar()
		end
	end
    
    -- TODO: Combine this in a shared resource!
	function timerFrame:onUpdate(sinceLastUpdate)
		local currentTime = GetTime()
		self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
		self.ttdSinceLastUpdate = self.ttdSinceLastUpdate + sinceLastUpdate
		self.characterCheckSinceLastUpdate  = self.characterCheckSinceLastUpdate  + sinceLastUpdate
		if self.sinceLastUpdate >= 0.05 then -- in seconds
			TriggerResourceBarUpdates()
			self.sinceLastUpdate = 0
		end

		if self.characterCheckSinceLastUpdate >= TRB.Data.settings.core.dataRefreshRate then -- in seconds
			CheckCharacter()
			self.characterCheckSinceLastUpdate  = 0
		end

		if TRB.Data.snapshotData.targetData.ttdIsActive and self.ttdSinceLastUpdate >= TRB.Data.settings.core.ttd.sampleRate then -- in seconds
			local currentTime = GetTime()
			local guid = UnitGUID("target")
			if TRB.Data.snapshotData.targetData.currentTargetGuid ~= guid then
				TRB.Data.snapshotData.targetData.currentTargetGuid = guid
			end

			if guid ~= nil then
				InitializeTarget(guid)
				
				local isDead = UnitIsDeadOrGhost("target")
				local currentHealth = UnitHealth("target")
				local maxHealth = UnitHealthMax("target")
				local healthDelta = 0
				local timeDelta = 0
				local dps = 0
				local ttd = 0

				local count = TRB.Functions.TableLength(TRB.Data.snapshotData.targetData.targets[guid].snapshot)
				if count > 0 and TRB.Data.snapshotData.targetData.targets[guid].snapshot[1] ~= nil then
					healthDelta = math.max(TRB.Data.snapshotData.targetData.targets[guid].snapshot[1].health - currentHealth, 0)
					timeDelta = math.max(currentTime - TRB.Data.snapshotData.targetData.targets[guid].snapshot[1].time, 0)
				end

				if isDead then
					TRB.Functions.RemoveTarget(guid)
				elseif currentHealth <= 0 or maxHealth <= 0 then
					dps = 0
					ttd = 0
				else
					if count == 0 or TRB.Data.snapshotData.targetData.targets[guid].snapshot[count] == nil or
						(TRB.Data.snapshotData.targetData.targets[guid].snapshot[1].health == currentHealth and count == TRB.Data.settings.core.ttd.numEntries) then
						dps = 0
					elseif healthDelta == 0 or timeDelta == 0 then
						dps = TRB.Data.snapshotData.targetData.targets[guid].snapshot[count].dps
					else
						dps = healthDelta / timeDelta
					end

					if dps == nil or dps == 0 then
						ttd = 0
					else
						ttd = currentHealth / dps
					end
				end

				if not isDead then
					TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = currentTime

					if count >= TRB.Data.settings.core.ttd.numEntries then
						table.remove(TRB.Data.snapshotData.targetData.targets[guid].snapshot, 1)
					end

					table.insert(TRB.Data.snapshotData.targetData.targets[guid].snapshot, {
						health=currentHealth,
						time=currentTime,
						dps=dps
					})

					TRB.Data.snapshotData.targetData.targets[guid].ttd = ttd
				end
			end
			self.ttdSinceLastUpdate = 0
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
				if specId == 2 then --Marksmanship
					if spellId == TRB.Data.spells.burstingShot.id then
						TRB.Data.snapshotData.burstingShot.startTime, TRB.Data.snapshotData.burstingShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.burstingShot.id)
					elseif spellId == TRB.Data.spells.barrage.id then
						TRB.Data.snapshotData.barrage.startTime, TRB.Data.snapshotData.barrage.duration, _, _ = GetSpellCooldown(TRB.Data.spells.barrage.id)
					elseif spellId == TRB.Data.spells.explosiveShot.id then
						TRB.Data.snapshotData.explosiveShot.startTime, TRB.Data.snapshotData.explosiveShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.explosiveShot.id)
					elseif spellId == TRB.Data.spells.trueshot.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.trueshot.isActive = true
							_, _, _, _, TRB.Data.snapshotData.trueshot.duration, TRB.Data.snapshotData.trueshot.endTime, _, _, _, TRB.Data.snapshotData.trueshot.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.trueshot.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.trueshot.isActive = false
							TRB.Data.snapshotData.trueshot.spellId = nil
							TRB.Data.snapshotData.trueshot.duration = 0
							TRB.Data.snapshotData.trueshot.endTime = nil
						end
					elseif spellId == TRB.Data.spells.secretsOfTheUnblinkingVigil.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime, TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration, _, _ = GetSpellCooldown(TRB.Data.spells.secretsOfTheUnblinkingVigil.id)
							
							if TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.enabled then
								PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.secretsOfTheUnblinkingVigil.isActive = false
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.spellId = nil
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration = 0
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.endTime = nil
						end
					end
				elseif specId == 3 then --Survival
					if spellId == TRB.Data.spells.carve.id then
						TRB.Data.snapshotData.carve.startTime, TRB.Data.snapshotData.carve.duration, _, _ = GetSpellCooldown(TRB.Data.spells.carve.id)
					elseif spellId == TRB.Data.spells.chakrams.id then
						TRB.Data.snapshotData.chakrams.startTime, TRB.Data.snapshotData.chakrams.duration, _, _ = GetSpellCooldown(TRB.Data.spells.chakrams.id)
					elseif spellId == TRB.Data.spells.flankingStrike.id then
						TRB.Data.snapshotData.flankingStrike.startTime, TRB.Data.snapshotData.flankingStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.flankingStrike.id)
					elseif spellId == TRB.Data.spells.termsOfEngagement.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Terms of Engagement
							TRB.Data.snapshotData.termsOfEngagement.isActive = true
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.spells.termsOfEngagement.ticks
							TRB.Data.snapshotData.termsOfEngagement.focus = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus
							TRB.Data.snapshotData.termsOfEngagement.endTime = currentTime + TRB.Data.spells.termsOfEngagement.duration
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.spells.termsOfEngagement.ticks + 1
							TRB.Data.snapshotData.termsOfEngagement.focus = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus
							TRB.Data.snapshotData.termsOfEngagement.endTime = currentTime + TRB.Data.spells.termsOfEngagement.duration + ((TRB.Data.spells.termsOfEngagement.duration / TRB.Data.spells.termsOfEngagement.ticks) - (currentTime - TRB.Data.snapshotData.termsOfEngagement.lastTick))
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.termsOfEngagement.isActive = false
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = 0
							TRB.Data.snapshotData.termsOfEngagement.focus = 0
							TRB.Data.snapshotData.termsOfEngagement.endTime = nil
							TRB.Data.snapshotData.termsOfEngagement.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.termsOfEngagement.ticksRemaining = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining - 1
							TRB.Data.snapshotData.termsOfEngagement.focus = TRB.Data.snapshotData.termsOfEngagement.ticksRemaining * TRB.Data.spells.termsOfEngagement.focus
							TRB.Data.snapshotData.termsOfEngagement.lastTick = currentTime
						end	
					elseif spellId == TRB.Data.spells.coordinatedAssault.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.coordinatedAssault.isActive = true
							_, _, _, _, TRB.Data.snapshotData.coordinatedAssault.duration, TRB.Data.snapshotData.coordinatedAssault.endTime, _, _, _, TRB.Data.snapshotData.coordinatedAssault.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.coordinatedAssault.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.coordinatedAssault.isActive = false
							TRB.Data.snapshotData.coordinatedAssault.spellId = nil
							TRB.Data.snapshotData.coordinatedAssault.duration = 0
							TRB.Data.snapshotData.coordinatedAssault.endTime = nil
						end
					end
				end

				-- Spec agnostic		
				if spellId == TRB.Data.spells.flayedShot.id then
					TRB.Data.snapshotData.flayedShot.startTime, TRB.Data.snapshotData.flayedShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.flayedShot.id)
				elseif spellId == TRB.Data.spells.aMurderOfCrows.id then
					TRB.Data.snapshotData.aMurderOfCrows.startTime, TRB.Data.snapshotData.aMurderOfCrows.duration, _, _ = GetSpellCooldown(TRB.Data.spells.aMurderOfCrows.id)
				elseif spellId == TRB.Data.spells.flayersMark.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.flayersMark.isActive = true
						_, _, _, _, TRB.Data.snapshotData.flayersMark.duration, TRB.Data.snapshotData.flayersMark.endTime, _, _, _, TRB.Data.snapshotData.flayersMark.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.flayersMark.id)
						
						if specId == 2 and TRB.Data.settings.hunter.marksmanship.audio.flayersMark.enabled then
							PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 3 and TRB.Data.settings.hunter.survival.audio.flayersMark.enabled then
							PlaySoundFile(TRB.Data.settings.hunter.survival.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.flayersMark.isActive = false
						TRB.Data.snapshotData.flayersMark.spellId = nil
						TRB.Data.snapshotData.flayersMark.duration = 0
						TRB.Data.snapshotData.flayersMark.endTime = nil
					end			
				elseif spellId == TRB.Data.spells.serpentSting.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- SS Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].serpentSting = true
						TRB.Data.snapshotData.targetData.serpentSting = TRB.Data.snapshotData.targetData.serpentSting + 1
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.targetData.targets[destGUID].serpentSting = false
						TRB.Data.snapshotData.targetData.serpentSting = TRB.Data.snapshotData.targetData.serpentSting - 1
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end	
				end
            end
			
			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				TRB.Functions.RemoveTarget(guid)
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
		if classIndex == 3 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Hunter.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end	
					FillSpecCache()
					FillSpellData_Marksmanship()
					FillSpellData_Survival()

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
					TRB.Options.Hunter.ConstructOptionsPanel(specCache)
				end
						
				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					if specId == 1 then
					elseif specId == 2 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.hunter.marksmanship)
						TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.marksmanship)
						FillSpellData_Marksmanship()
						TRB.Functions.LoadFromSpecCache(specCache.marksmanship)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Marksmanship
						ConstructResourceBar(TRB.Data.settings.hunter.marksmanship)
					elseif specId == 3 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.hunter.survival)
						TRB.Functions.IsTtdActive(TRB.Data.settings.hunter.survival)
						FillSpellData_Survival()
						TRB.Functions.LoadFromSpecCache(specCache.survival)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Survival
						ConstructResourceBar(TRB.Data.settings.hunter.survival)
					end
					EventRegistration()
					TRB.Functions.HideResourceBar()
				end
			end
		end
	end)
end
