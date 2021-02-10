local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 5 then --Only do this if we're on a Priest!
	TRB.Frames.passiveFrame.thresholds[1] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.passiveFrame.thresholds[2] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
	TRB.Frames.resourceFrame.thresholds[1] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
	TRB.Frames.resourceFrame.thresholds[2] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)

	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame

	--[[
	local mindbenderAudioCueFrame = CreateFrame("Frame")
	mindbenderAudioCueFrame.sinceLastPlay = 0
	mindbenderAudioCueFrame.sinceLastUpdate = 0
	]]--

	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer

	Global_TwintopInsanityBar = {
		ttd = 0,
		voidform = {
		},
		insanity = {
			insanity = 0,
			casting = 0,
			passive = 0
		},
		auspiciousSpirits = {
			count = 0,
			insanity = 0
		},
		dots = {
			swpCount = 0,
			vtCount = 0
		},
		mindbender = {
			insanity = 0,
			gcds = 0,
			swings = 0,
			time = 0
		},
		wrathfulFaerie = {
			insanity = 0,
			gcds = 0,
			ticks = 0,
			time = 0
		}		
	}

	Global_TwintopResourceBar = {
		ttd = 0,
		voidform = {
		},
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			auspiciousSpirits = 0,
			mindbender = 0,
			deathAndMadness = 0,
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
		mindbender = {			
			insanity = 0,
			gcds = 0,
			swings = 0,
			time = 0
		},
		mindSear = {
			targetsHit = 0
		},
		deathAndMadness = {
			insanity = 0,
			ticks = 0
		},
		eternalCallToTheVoid = {
			insanity = 0,
			ticks = 0,
			count = 0
		}
	}

	TRB.Data.character = {
		guid = UnitGUID("player"),
		specGroup = GetActiveSpecGroup(),
		maxResource = 100,
		devouringPlagueThreshold = 50,
		searingNightmareThreshold = 30,
		talents = {
			fotm = {
				isSelected = false,
				modifier = 1.2
			},
			as = {
				isSelected = false
			},
			mindbender = {
				isSelected = false
			},
			hungeringVoid = {
				isSelected = false
			},
			surrenderToMadeness = {
				isSelected = false
			},
			searingNightmare = {
				isSelected = false
			}
		},
		items = {
			callToTheVoid = false
		},
		torghast = {
			dreamspunMushroomsModifier = 1,
			elethiumMuzzleModifier = 1,
		}
	}

	TRB.Data.spells = {
		voidBolt = {
			id = 205448,
			name = "",
			icon = "",
			insanity = 12,
			fotm = false
		},
		voidform = {
			id = 194249,
			name = "",
			icon = ""
		},
		voidTorrent = {
			id = 263165,
			name = "",
			icon = "",
			insanity = 15,
			fotm = false
		},
		s2m = {
			isActive = false,
			isDebuffActive = false,
			modifier = 2.0,
			modifierDebuff = 0.0,
			id = 319952,
			name = "",
			icon = ""
		},
		shadowWordPain = {
			id = 589,
			icon = "",
			name = "",
			insanity = 4,
			fotm = false
		},
		vampiricTouch = {
			id = 34914,
			name = "",
			icon = "",
			insanity = 5,
			fotm = false
		},
		mindBlast = {
			id = 8092,
			name = "",
			icon = "",
			insanity = 8,
			fotm = true
		},
		devouringPlague = {
			id = 335467,
			name = "",
			icon = "",
			insanity = 0,
			fotm = true
		},
		mindFlay = {
			id = 15407,
			name = "",
			icon = "",
			insanity = 3,
			fotm = true
		},
		mindSear = {
			id = 48045,
			idTick = 49821,
			name = "",
			icon = "",
			insanity = 1, -- Per tick per target
			fotm = false
		},
		shadowfiend = {
			id = 34433,
			name = "",
			icon = "",
			insanity = 3,
			fotm = false
		},
		mindbender = {
			id = 34433,
			name = "",
			icon = "",
			insanity = 5,
			fotm = false
		},
		deathAndMadness = {
			id = 321973,
			name = "",
			icon = "",
			insanity = 10,
			ticks = 4,
			duration = 4,
			fotm = false
		},
		auspiciousSpirits = {
			id = 155271,
			idSpawn = 147193,
			idImpact = 148859,
			insanity = 2,
			fotm = false,
			name = "",
			icon = ""
		},
		shadowCrash = {
			id = 205385,
			name = "",
			icon = "",
			insanity = 15,
			fotm = false
		},
		hungeringVoid = {
			id = 345218,
			idDebuff = 345219,
			name = "",
			icon = ""
		},
		shadowyApparition = {
			id = 78203,
			name = "",
			icon = ""		
		},
		massDispel = {
			id = 32375,
			name = "",
			icon = "",
			insanity = 6,
			fotm = false
		},
		memoryOfLucidDreams = {
			id = 298357,
			name = "",
			isActive = false,
			modifier = 2.0
		},
		mindDevourer = {
			id = 338333,
			--id = 17, --PWS for testing
			name = "",
			icon = "",
			isActive = false
		},
		eternalCallToTheVoid_Tendril = {
			id = 336216,
			idTick = 193473,
			idLegendaryBonus = 6983,
			name = "",
			icon = "",
			tocMinVersion = 90001
		},
		eternalCallToTheVoid_Lasher = {
			id = 344753,
			idTick = 344752,
			idLegendaryBonus = 6983,
			name = "",
			icon = "",
			tocMinVersion = 90002
		},
		lashOfInsanity_Tendril = {
			id = 344838,
			name = "",
			icon = "",
			insanity = 3,
			fotm = false,
			duration = 15,
			ticks = 15,
			tickDuration = 1, --This is NOT hasted
			tocMinVersion = 90001
		},
		lashOfInsanity_Lasher = {
			id = 344838, --Doesn't actually exist / unused? 
			name = "",
			icon = "",
			insanity = 1,
			fotm = false,
			duration = 15,
			ticks = 15,
			tickDuration = 1, --This is hasted
			tocMinVersion = 90002
		},

		wrathfulFaerie = {
			id = 342132,
			name = "",
			icon = "",
			insanity = 3,
			fotm = false,
			duration = 20,
			icd = 0.75,
			energizeId = 327703
		},

		wrathfulFaerieFermata = {
			id = 345452,
			name = "",
			icon = "",
			insanity = 0, -- We'll use modifier against wrathfulFaerie instead
			fotm = false,
			modifier = 0.8,
			icd = 0.75,
			energizeId = 345456,
			conduitId = 101,
			conduitRanks = {}
		},
		rabidShadows = {
			id = 338338,
			name = "",
			icon = "",
			conduitId = 114,
			conduitRanks = {}
		},
		dissonantEchoes = {
			id = 338342,
			name = "",
			icon = "",
			conduitId = 72,
			conduitRanks = {}
		},

		dreamspunMushrooms = {
			id = 342409,
			name = "",
			icon = ""
		},
		elethiumMuzzle = {
			id = 319276,
			name = "",
			icon = ""
		}
	}

	TRB.Data.snapshotData.voidform = {
		spellId = nil,
		remainingTime = 0,
		remainingHvTime = 0,
		additionalVbCasts = 0,
		remainingHvAvgTime = 0,
		additionalVbAvgCasts = 0,
		isInfinite = false,
		isAverageInfinite = false,
		s2m = {
			startTime = nil,
			active = false
		}
	}
	TRB.Data.snapshotData.audio = {
		playedDpCue = false,
		playedMdCue = false,
		overcapCue = false
	}
	TRB.Data.snapshotData.mindSear = {
		targetsHit = 0,
		hitTime = nil,
		hasStruckTargets = false
	}
	TRB.Data.snapshotData.targetData = {
		ttdIsActive = false,
		currentTargetGuid = nil,
		auspiciousSpirits = 0,
		shadowWordPain = 0,
		vampiricTouch = 0,
		devouringPlague = 0,
		wrathfulFaerieGuid = nil,
		targets = {}
	}
	TRB.Data.snapshotData.deathAndMadness = {
		isActive = false,
		ticksRemaining = 0,
		insanity = 0,
		endTime = nil,
		lastTick = nil
	}
	TRB.Data.snapshotData.mindbender = {
		isActive = false,
		onCooldown = false,
		swingTime = 0,
		remaining = {
			swings = 0,
			gcds = 0,
			time = 0
		},
		resourceRaw = 0,
		resourceFinal = 0
	}
	TRB.Data.snapshotData.eternalCallToTheVoid = {
		numberActive = 0,
		resourceRaw = 0,
		resourceFinal = 0,
		maxTicksRemaining = 0,		
		voidTendrils = {}
	}
	TRB.Data.snapshotData.mindDevourer = {
		spellId = nil,
		endTime = nil,
		duration = 0
	}
	TRB.Data.snapshotData.wrathfulFaerie = {
		main = {
			isActive = false,
			procTime = 0,
			remaining = {
				procs = 0,
				gcds = 0,
				time = 0
			},
			resourceRaw = 0,
			resourceFinal = 0
		},
		fermata = {
			isActive = false,
			procTime = 0,
			remaining = {
				procs = 0,
				gcds = 0,
				time = 0
			},
			resourceRaw = 0,
			resourceFinal = 0
		},
		resourceRaw = 0,
		resourceFinal = 0,
	}

	local function FillSpellData()
		TRB.Data.spells.mindbender.name = select(2, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
		TRB.Data.spells.s2m.name = select(2, GetTalentInfo(7, 3, TRB.Data.character.specGroup))

		TRB.Functions.FillSpellData()
		
		-- Conduit Ranks
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[0] = 0
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[1] = 3.8		
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[2] = 4.18
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[3] = 4.56
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[4] = 4.94
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[5] = 5.32
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[6] = 5.7
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[7] = 6.08
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[8] = 6.46
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[9] = 6.84
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[10] = 7.22
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[11] = 7.6
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[12] = 7.98
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[13] = 8.36
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[14] = 8.74
		TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[15] = 9.12

		TRB.Data.spells.rabidShadows.conduitRanks[0] = 0
		TRB.Data.spells.rabidShadows.conduitRanks[1] = 0.12
		TRB.Data.spells.rabidShadows.conduitRanks[2] = 0.209
		TRB.Data.spells.rabidShadows.conduitRanks[3] = 0.228
		TRB.Data.spells.rabidShadows.conduitRanks[4] = 0.247
		TRB.Data.spells.rabidShadows.conduitRanks[5] = 0.266
		TRB.Data.spells.rabidShadows.conduitRanks[6] = 0.285
		TRB.Data.spells.rabidShadows.conduitRanks[7] = 0.304
		TRB.Data.spells.rabidShadows.conduitRanks[8] = 0.323
		TRB.Data.spells.rabidShadows.conduitRanks[9] = 0.342
		TRB.Data.spells.rabidShadows.conduitRanks[10] = 0.361
		TRB.Data.spells.rabidShadows.conduitRanks[11] = 0.38
		TRB.Data.spells.rabidShadows.conduitRanks[12] = 0.399
		TRB.Data.spells.rabidShadows.conduitRanks[13] = 0.418
		TRB.Data.spells.rabidShadows.conduitRanks[14] = 0.437
		TRB.Data.spells.rabidShadows.conduitRanks[15] = 0.456
		
		TRB.Data.spells.dissonantEchoes.conduitRanks[0] = 0
		TRB.Data.spells.dissonantEchoes.conduitRanks[1] = 0.031
		TRB.Data.spells.dissonantEchoes.conduitRanks[2] = 0.034
		TRB.Data.spells.dissonantEchoes.conduitRanks[3] = 0.037
		TRB.Data.spells.dissonantEchoes.conduitRanks[4] = 0.04
		TRB.Data.spells.dissonantEchoes.conduitRanks[5] = 0.043
		TRB.Data.spells.dissonantEchoes.conduitRanks[6] = 0.047
		TRB.Data.spells.dissonantEchoes.conduitRanks[7] = 0.05
		TRB.Data.spells.dissonantEchoes.conduitRanks[8] = 0.053
		TRB.Data.spells.dissonantEchoes.conduitRanks[9] = 0.056
		TRB.Data.spells.dissonantEchoes.conduitRanks[10] = 0.059
		TRB.Data.spells.dissonantEchoes.conduitRanks[11] = 0.062
		TRB.Data.spells.dissonantEchoes.conduitRanks[12] = 0.065
		TRB.Data.spells.dissonantEchoes.conduitRanks[13] = 0.068
		TRB.Data.spells.dissonantEchoes.conduitRanks[14] = 0.071
		TRB.Data.spells.dissonantEchoes.conduitRanks[15] = 0.074
		-- TODO: Add these conduits to the bar icon variables too!


		-- This is done here so that we can get icons for the options menu!
		TRB.Data.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Insanity generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via it's spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#vf", icon = TRB.Data.spells.voidform.icon, description = "Voidform", printInSettings = true },
			{ variable = "#voidform", icon = TRB.Data.spells.voidform.icon, description = "Voidform", printInSettings = false },
			{ variable = "#vb", icon = TRB.Data.spells.voidBolt.icon, description = "Void Bolt", printInSettings = true },
			{ variable = "#voidBolt", icon = TRB.Data.spells.voidBolt.icon, description = "Void Bolt", printInSettings = false },

			{ variable = "#mb", icon = TRB.Data.spells.mindBlast.icon, description = "Mind Blast", printInSettings = true },
			{ variable = "#mindBlast", icon = TRB.Data.spells.mindBlast.icon, description = "Mind Blast", printInSettings = false },
			{ variable = "#mf", icon = TRB.Data.spells.mindFlay.icon, description = "Mind Flay", printInSettings = true },
			{ variable = "#mindFlay", icon = TRB.Data.spells.mindFlay.icon, description = "Mind Flay", printInSettings = false },
			{ variable = "#ms", icon = TRB.Data.spells.mindSear.icon, description = "Mind Sear", printInSettings = true },
			{ variable = "#mindSear", icon = TRB.Data.spells.mindSear.icon, description = "Mind Sear", printInSettings = false },
			{ variable = "#voit", icon = TRB.Data.spells.voidTorrent.icon, description = "Void Torrent", printInSettings = true },
			{ variable = "#voidTorrent", icon = TRB.Data.spells.voidTorrent.icon, description = "Void Torrent", printInSettings = false },
			{ variable = "#dam", icon = TRB.Data.spells.deathAndMadness.icon, description = "Death and Madness", printInSettings = true },
			{ variable = "#deathAndMadness", icon = TRB.Data.spells.deathAndMadness.icon, description = "Death and Madness", printInSettings = false },

			{ variable = "#swp", icon = TRB.Data.spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = true },
			{ variable = "#shadowWordPain", icon = TRB.Data.spells.shadowWordPain.icon, description = "Shadow Word: Pain", printInSettings = false },
			{ variable = "#vt", icon = TRB.Data.spells.vampiricTouch.icon, description = "Vampiric Touch", printInSettings = true },
			{ variable = "#vampiricTouch", icon = TRB.Data.spells.vampiricTouch.icon, description = "Vampiric Touch", printInSettings = false },
			{ variable = "#dp", icon = TRB.Data.spells.devouringPlague.icon, description = "Devouring Plague", printInSettings = true },
			{ variable = "#devouringPlague", icon = TRB.Data.spells.devouringPlague.icon, description = "Devouring Plague", printInSettings = false },
			{ variable = "#mDev", icon = TRB.Data.spells.mindDevourer.icon, description = "Mind Devourer", printInSettings = true },
			{ variable = "#mindDevourer", icon = TRB.Data.spells.mindDevourer.icon, description = "Mind Devourer", printInSettings = false },

			{ variable = "#as", icon = TRB.Data.spells.auspiciousSpirits.icon, description = "Auspicious Spirits", printInSettings = true },
			{ variable = "#auspiciousSpirits", icon = TRB.Data.spells.auspiciousSpirits.icon, description = "Auspicious Spirits", printInSettings = false },
			{ variable = "#sa", icon = TRB.Data.spells.shadowyApparition.icon, description = "Shadowy Apparition", printInSettings = true },
			{ variable = "#shadowyApparition", icon = TRB.Data.spells.shadowyApparition.icon, description = "Shadowy Apparition", printInSettings = false },

			{ variable = "#mindbender", icon = TRB.Data.spells.mindbender.icon, description = "Mindbender/Shadowfiend", printInSettings = false },
			{ variable = "#shadowfiend", icon = TRB.Data.spells.shadowfiend.icon, description = "Mindbender/Shadowfiend", printInSettings = false },
			{ variable = "#sf", icon = TRB.Data.spells.shadowfiend.icon, description = "Mindbender/Shadowfiend", printInSettings = true },

			{ variable = "#wf", icon = TRB.Data.spells.wrathfulFaerie.icon, description = "Wrathful Faerie", printInSettings = true },
			{ variable = "#wrathfulFaerie", icon = TRB.Data.spells.wrathfulFaerie.icon, description = "Wrathful Faerie", printInSettings = false },
			
			{ variable = "#s2m", icon = TRB.Data.spells.s2m.icon, description = "Surrender to Madness", printInSettings = true },
			{ variable = "#surrenderToMadness", icon = TRB.Data.spells.s2m.icon, description = "Surrender to Madness", printInSettings = false },
			
			{ variable = "#ecttv", icon = TRB.Data.spells.eternalCallToTheVoid_Tendril.icon, description = "Eternal Call to the Void", printInSettings = true },
			{ variable = "#tb", icon = TRB.Data.spells.eternalCallToTheVoid_Tendril.icon, description = "Eternal Call to the Void", printInSettings = false },
			{ variable = "#loi", icon = TRB.Data.spells.lashOfInsanity_Tendril.icon, description = "Lash of Insanity", printInSettings = true },

			{ variable = "#md", icon = TRB.Data.spells.massDispel.icon, description = "Mass Dispel", printInSettings = true },
			{ variable = "#massDispel", icon = TRB.Data.spells.massDispel.icon, description = "Mass Dispel", printInSettings = false }
		}
		TRB.Data.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },

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

			{ variable = "$damInsanity", description = "Insanity from Death and Madness", printInSettings = true, color = false },
			{ variable = "$damTicks", description = "Number of ticks left on Death and Madness", printInSettings = true, color = false },

			{ variable = "$mbInsanity", description = "Insanity from Mindbender/Shadowfiend (per settings)", printInSettings = true, color = false },
			{ variable = "$mbGcds", description = "Number of GCDs left on Mindbender/Shadowfiend", printInSettings = true, color = false },
			{ variable = "$mbSwings", description = "Number of Swings left on Mindbender/Shadowfiend", printInSettings = true, color = false },
			{ variable = "$mbTime", description = "Time left on Mindbender/Shadowfiend", printInSettings = true, color = false },

			{ variable = "$wfInsanity", description = "Insanity from Wrathful Faerie (per settings)", printInSettings = true, color = false },
			{ variable = "$wfGcds", description = "Number of GCDs left on Wrathful Faerie", printInSettings = true, color = false },
			{ variable = "$wfProcs", description = "Number of Procs left on Wrathful Faerie", printInSettings = true, color = false },
			{ variable = "$wfTime", description = "Time left on Wrathful Faerie", printInSettings = true, color = false },
			
			{ variable = "$cttvEquipped", description = "Checks if you have Call of the Void equipped. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$ecttvCount", description = "Number of active Void Tendrils/Void Lashers", printInSettings = true, color = false },
			{ variable = "$loiInsanity", description = "Insanity from all Void Tendrils and Void Lashers", printInSettings = true, color = false },
			{ variable = "$loiTicks", description = "Number of ticks remaining for all active Void Tendrils/Void Lashers", printInSettings = true, color = false },

			{ variable = "$asInsanity", description = "Insanity from Auspicious Spirits", printInSettings = true, color = false },
			{ variable = "$asCount", description = "Number of Auspicious Spirits in flight", printInSettings = true, color = false },

			{ variable = "$swpCount", description = "Number of Shadow Word: Pains active on targets", printInSettings = true, color = false },
			{ variable = "$vtCount", description = "Number of Vampiric Touches active on targets", printInSettings = true, color = false },
			{ variable = "$dpCount", description = "Number of Devouring Plagues active on targets", printInSettings = true, color = false },

			{ variable = "$mdTime", description = "Time remaining on Mind Devourer buff", printInSettings = true, color = false },

			{ variable = "$vfTime", description = "Duration remaining of Voidform", printInSettings = true, color = false },
			{ variable = "$hvTime", description = "Duration remaining of VF w/max VB casts in Hungering Void", printInSettings = true, color = false },
			{ variable = "$vbCasts", description = "Max Void Bolt casts remaining in Hungering Void", printInSettings = true, color = false },
			{ variable = "$hvAvgTime", description = "Duration of VF w/max VB casts in Hungering Void, includes crits", printInSettings = true, color = false },
			{ variable = "$vbAvgCasts", description = "Max Void Bolt casts remaining in Hungering Void, includes crits", printInSettings = true, color = false },

			{ variable = "$s2m", description = "Is Surrender to Madness currently talented. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$surrenderToMadness", description = "Is Surrender to Madness currently talented. Logic variable only!", printInSettings = true, color = false },
				
			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity)
		TRB.Data.character.talents.searingNightmare.isSelected = select(4, GetTalentInfo(3, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.fotm.isSelected = select(4, GetTalentInfo(1, 1, TRB.Data.character.specGroup))
		TRB.Data.character.talents.as.isSelected = select(4, GetTalentInfo(5, 1, TRB.Data.character.specGroup))
		TRB.Data.character.talents.mindbender.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))	
		TRB.Data.character.talents.hungeringVoid.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.surrenderToMadeness.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))
		
		TRB.Data.character.devouringPlagueThreshold = 50
		TRB.Data.character.searingNightmareThreshold = 30
		
		if TRB.Data.settings.priest ~= nil and TRB.Data.settings.priest.shadow ~= nil then
			-- Threshold lines
			if TRB.Data.settings.priest.shadow.devouringPlagueThreshold and TRB.Data.character.devouringPlagueThreshold < TRB.Data.character.maxResource then
				resourceFrame.thresholds[1]:Show()
				TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.priest.shadow.thresholdWidth, TRB.Data.character.devouringPlagueThreshold, TRB.Data.character.maxResource)
			else
				resourceFrame.thresholds[1]:Hide()
			end
			
			if TRB.Data.settings.priest.shadow.searingNightmareThreshold and TRB.Data.character.talents.searingNightmare.isSelected == true and TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id then
				resourceFrame.thresholds[2]:Show()		
				TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, resourceFrame.thresholds[2], resourceFrame, TRB.Data.settings.priest.shadow.thresholdWidth, TRB.Data.character.searingNightmareThreshold, TRB.Data.character.maxResource)
			else
				resourceFrame.thresholds[2]:Hide()
			end

			-- Legendaries
			local wristItemLink = GetInventoryItemLink("player", 9)
			local handsItemLink = GetInventoryItemLink("player", 10)

			local callToTheVoid = false
			if wristItemLink ~= nil then
				callToTheVoid = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(wristItemLink, 173249, TRB.Data.spells.eternalCallToTheVoid_Tendril.idLegendaryBonus)
			end
			
			if callToTheVoid == false and handsItemLink ~= nil then
				callToTheVoid = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(handsItemLink, 173244, TRB.Data.spells.eternalCallToTheVoid_Tendril.idLegendaryBonus)
			end
			TRB.Data.character.items.callToTheVoid = callToTheVoid

			-- Torghast
			if IsInJailersTower() then
				TRB.Data.character.torghast.dreamspunMushroomsModifier = 1 + ((select(16, TRB.Functions.FindAuraById(TRB.Data.spells.dreamspunMushrooms.id, "player", "MAW")) or 0) / 100)
				if TRB.Functions.FindAuraById(TRB.Data.spells.elethiumMuzzle.id, "player", "MAW") then
					TRB.Data.character.torghast.elethiumMuzzleModifier = 0.75
				else
					TRB.Data.character.torghast.elethiumMuzzleModifier = 1
				end
			else
				TRB.Data.character.torghast.dreamspunMushroomsModifier = 1
				TRB.Data.character.torghast.elethiumMuzzleModifier = 1
			end
		end
	end
	
	local function IsTtdActive()
		if TRB.Data.settings.priest ~= nil and TRB.Data.settings.priest.shadow ~= nil and TRB.Data.settings.priest.shadow.displayText ~= nil then
			if string.find(TRB.Data.settings.priest.shadow.displayText.left.outVoidformText, "$ttd") or
				string.find(TRB.Data.settings.priest.shadow.displayText.left.inVoidformText, "$ttd") or
				string.find(TRB.Data.settings.priest.shadow.displayText.middle.outVoidformText, "$ttd") or
				string.find(TRB.Data.settings.priest.shadow.displayText.middle.inVoidformText, "$ttd") or
				string.find(TRB.Data.settings.priest.shadow.displayText.right.outVoidformText, "$ttd") or
				string.find(TRB.Data.settings.priest.shadow.displayText.right.inVoidformText, "$ttd") then
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
		if GetSpecialization() == 3 then		
			TRB.Data.resource = Enum.PowerType.Insanity
			TRB.Data.resourceFactor = 100
			TRB.Data.specSupported = true
			CheckCharacter()
			
			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			
			--[[
			if TRB.Data.settings.priest.shadow.mindbender.useNotification.enabled then
				mindbenderAudioCueFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) mindbenderAudioCueFrame:onUpdate(sinceLastUpdate) end)
			else
				mindbenderAudioCueFrame:SetScript("OnUpdate", nil)
			end
			]]--
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
			--mindbenderAudioCueFrame:SetScript("OnUpdate", nil)
			timerFrame:SetScript("OnUpdate", nil)			
			barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = false			
			barContainerFrame:Hide()
		end	
	end

	local function CheckVoidTendrilExists(guid)
		if guid == nil or (not TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] or TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] == nil) then
			return false
		end
		return true
	end

	local function InitializeVoidTendril(guid)
		if guid ~= nil and not CheckVoidTendrilExists(guid) then
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] = {}
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].startTime = nil
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].tickTime = nil
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].type = nil
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].targetsHit = 0
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid].hasStruckTargets = false
		end	
	end

	local function RemoveVoidTendril(guid)
		if guid ~= nil and CheckVoidTendrilExists(guid) then
			TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[guid] = nil
		end
	end

	local function InitializeTarget(guid)
		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
			TRB.Data.snapshotData.targetData.targets[guid].auspiciousSpirits = 0
			TRB.Data.snapshotData.targetData.targets[guid].shadowWordPain = false
			TRB.Data.snapshotData.targetData.targets[guid].vampiricTouch = false
			TRB.Data.snapshotData.targetData.targets[guid].devouringPlague = false
		end	
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local swpTotal = 0
		local vtTotal = 0
		local asTotal = 0
		local dpTotal = 0
		for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
				TRB.Data.snapshotData.targetData.targets[tguid].auspiciousSpirits = 0
				TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain = false
				TRB.Data.snapshotData.targetData.targets[tguid].vampiricTouch = false
				TRB.Data.snapshotData.targetData.targets[tguid].devouringPlague = false
			else
				asTotal = asTotal + TRB.Data.snapshotData.targetData.targets[tguid].auspiciousSpirits
				if TRB.Data.snapshotData.targetData.targets[tguid].shadowWordPain == true then
					swpTotal = swpTotal + 1
				end
				if TRB.Data.snapshotData.targetData.targets[tguid].vampiricTouch == true then
					vtTotal = vtTotal + 1
				end
				if TRB.Data.snapshotData.targetData.targets[tguid].devouringPlague == true then
					dpTotal = dpTotal + 1
				end
			end
		end

		TRB.Data.snapshotData.targetData.auspiciousSpirits = asTotal		
		if TRB.Data.snapshotData.targetData.auspiciousSpirits < 0 then
			TRB.Data.snapshotData.targetData.auspiciousSpirits = 0
		end

		TRB.Data.snapshotData.targetData.shadowWordPain = swpTotal		
		TRB.Data.snapshotData.targetData.vampiricTouch = vtTotal		
		TRB.Data.snapshotData.targetData.devouringPlague = dpTotal
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.shadowWordPain = 0
			TRB.Data.snapshotData.targetData.vampiricTouch = 0		
			TRB.Data.snapshotData.targetData.devouringPlague = 0
			TRB.Data.snapshotData.targetData.auspiciousSpirits = 0
		end
	end

	local function ConstructResourceBar()
		TRB.Functions.ConstructResourceBar(TRB.Data.settings.priest.shadow)
	end

	local function CalculateRemainingHungeringVoidTime()
		local currentTime = GetTime()
		local _
		local expirationTime
		_, _, _, _, TRB.Data.snapshotData.voidform.duration, expirationTime, _, _, _, TRB.Data.snapshotData.voidform.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.voidform.id)

		if TRB.Data.snapshotData.voidform.spellId == nil then		
			TRB.Data.snapshotData.voidform.remainingTime = 0
			TRB.Data.snapshotData.voidform.remainingHvTime = 0	
			TRB.Data.snapshotData.voidform.additionalVbCasts = 0
			TRB.Data.snapshotData.voidform.remainingHvAvgTime = 0	
			TRB.Data.snapshotData.voidform.additionalVbAvgCasts = 0
			TRB.Data.snapshotData.voidform.isInfinite = false
			TRB.Data.snapshotData.voidform.isAverageInfinite = false
		else
			local remainingTime = (expirationTime - currentTime) or 0

			if TRB.Data.character.talents.hungeringVoid.isSelected == true then
				local latency = TRB.Functions.GetLatency()
				local vbStart, vbDuration, _, _ = GetSpellCooldown(TRB.Data.spells.voidBolt.id)
				local vbBaseCooldown, vbBaseGcd = GetSpellBaseCooldown(TRB.Data.spells.voidBolt.id)
				local vbCooldown = math.max(((vbBaseCooldown / (((TRB.Data.snapshotData.haste / 100) + 1) * 1000)) * TRB.Data.character.torghast.elethiumMuzzleModifier), 0.75) + latency
				local gcdLockRemaining = TRB.Functions.GetCurrentGCDLockRemaining()
				local targetDebuffId = select(10, TRB.Functions.FindDebuffById(TRB.Data.spells.hungeringVoid.idDebuff, "target"))
				
				local castGrantsExtension = true
				--[[
				Issue #107 - Twintop 2021-01-03
					Hungering Void doesn't require the target to actually be debuffed to grant extensions.
					Change back to the code below once this is fixed by Blizz.
				----
				local castGrantsExtension = false

				if targetDebuffId ~= nil then
					castGrantsExtension = true
				end
				]]

				local remainingTimeTmp = remainingTime
				local remainingTimeTotal = remainingTime
				local remainingTimeTmpAverage = remainingTime
				local remainingTimeTotalAverage = remainingTime
				local moreCasts = 0
				local moreCastsAverage = 0
				local critValue = math.min((1.0 + (TRB.Data.snapshotData.crit / 100)), 2)

				if vbDuration > 0 or gcdLockRemaining > 0 then
					local vbRemaining = vbStart + vbDuration - currentTime
					local castDelay = vbRemaining

					if gcdLockRemaining > vbRemaining then
						castDelay = gcdLockRemaining
					end

					castDelay = castDelay + latency

					if remainingTimeTmp > castDelay then
						if castGrantsExtension == true then
							moreCasts = moreCasts + 1
							remainingTimeTmp = remainingTimeTmp + 1.0 - castDelay
							remainingTimeTotal = remainingTimeTotal + 1.0

							moreCastsAverage = moreCastsAverage + 1
							remainingTimeTmpAverage = remainingTimeTmpAverage + critValue - castDelay
							remainingTimeTotalAverage = remainingTimeTotalAverage + critValue
						else
							remainingTimeTmp = remainingTimeTmp - castDelay

							remainingTimeTmpAverage = remainingTimeTmpAverage - castDelay
							castGrantsExtension = true
						end
					end
				end

				-- With extremely high Haste and Crit it is possible to remain in Voidform for literally forever.

				local infiniteExtensions = false
				if vbCooldown <= 1 then
					infiniteExtensions = true
				end

				local infiniteAverageExtensions = false
				if ((2 - (2 / (vbCooldown))) * 100) < TRB.Data.snapshotData.crit then
					infiniteAverageExtensions = true
				end

				local infinityHasteRequired = vbBaseCooldown - 1

				local sanityCheckCounter = 0
				local infinityCounter = 0
				local infinityAverageCounter = 0
				local maxCounter = 25
				while (not (infiniteExtensions and infiniteAverageExtensions)) and 
					  (remainingTimeTmpAverage >= vbCooldown or remainingTimeTmp >= vbCooldown) and
					  infinityCounter < maxCounter and
					  infinityAverageCounter < maxCounter and 
					  sanityCheckCounter < maxCounter
				do
					sanityCheckCounter = sanityCheckCounter + 1
					if not infiniteExtensions and remainingTimeTmp >= vbCooldown then
						infinityCounter = infinityCounter + 1					
						local castsRaw = math.floor(remainingTimeTmp / vbCooldown)
						local additionalCasts = castsRaw

						if castGrantsExtension == false then
							additionalCasts = math.max(additionalCasts - 1, 0)
						end
						moreCasts = moreCasts + additionalCasts
						remainingTimeTmp = remainingTimeTmp + additionalCasts - (castsRaw * vbCooldown)
						remainingTimeTotal = remainingTimeTotal + additionalCasts
					end
					
					if not infiniteAverageExtensions and remainingTimeTmpAverage >= vbCooldown then
						infinityAverageCounter = infinityAverageCounter + 1					
						local castsAverageRaw =  math.floor(remainingTimeTmpAverage / vbCooldown)
						local additionalCastsAverage = castsAverageRaw
						
						if castGrantsExtension == false then
							additionalCastsAverage = math.max(additionalCastsAverage - 1, 0)
						end
						moreCastsAverage = moreCastsAverage + additionalCastsAverage
						remainingTimeTmpAverage = remainingTimeTmpAverage + (critValue * additionalCastsAverage) - (castsAverageRaw * vbCooldown)
						remainingTimeTotalAverage = remainingTimeTotalAverage + (critValue * additionalCastsAverage)
					end

					castGrantsExtension = true
				end
				
				TRB.Data.snapshotData.voidform.remainingTime = remainingTime or 0
				TRB.Data.snapshotData.voidform.remainingHvTime = remainingTimeTotal	
				TRB.Data.snapshotData.voidform.additionalVbCasts = moreCasts
				TRB.Data.snapshotData.voidform.remainingHvAvgTime = remainingTimeTotalAverage
				TRB.Data.snapshotData.voidform.additionalVbAvgCasts = moreCastsAverage
				
				if sanityCheckCounter == maxCounter and sanityCheckCounter ~= infinityCounter and sanityCheckCounter ~= infinityAverageCounter then
					TRB.Data.snapshotData.voidform.isInfinite = true
					TRB.Data.snapshotData.voidform.isAverageInfinite = true
				end

				if infiniteExtensions or infinityCounter == maxCounter then
					TRB.Data.snapshotData.voidform.isInfinite = true
				end
				
				if infiniteAverageExtensions or infinityAverageCounter == maxCounter then
					TRB.Data.snapshotData.voidform.isAverageInfinite = true
				end
			else
				TRB.Data.snapshotData.voidform.remainingTime = remainingTime or 0
				TRB.Data.snapshotData.voidform.remainingHvTime = 0	
				TRB.Data.snapshotData.voidform.additionalVbCasts = 0
				TRB.Data.snapshotData.voidform.remainingHvAvgTime = 0	
				TRB.Data.snapshotData.voidform.additionalVbAvgCasts = 0
				TRB.Data.snapshotData.voidform.isInfinite = false
				TRB.Data.snapshotData.voidform.isAverageInfinite = false
			end		
		end  
	end

	local function CalculateInsanityGain(insanity, fotm)
		local modifier = 1.0
		
		if fotm and TRB.Data.character.talents.fotm.isSelected then
			modifier = modifier * TRB.Data.character.talents.fotm.modifier
		end
		
		if TRB.Data.spells.memoryOfLucidDreams.isActive then
			modifier = modifier * TRB.Data.spells.memoryOfLucidDreams.modifier
		end

		if TRB.Data.spells.s2m.isActive then
			modifier = modifier * TRB.Data.spells.s2m.modifier
		end
		
		return insanity * modifier	
	end

	local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end

		if var == "$vfTime" then
			if TRB.Data.snapshotData.voidform.remainingTime ~= nil and TRB.Data.snapshotData.voidform.remainingTime > 0 then
				valid = true
			end
		elseif var == "$hvAvgTime" then
			if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvAvgTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvAvgTime > 0 or TRB.Data.snapshotData.voidform.isAverageInfinite) then
				valid = true
			end
		elseif var == "$vbAvgCasts" then
			if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvAvgTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvAvgTime > 0 or TRB.Data.snapshotData.voidform.isAverageInfinite) then
				valid = true
			end
		elseif var == "$hvTime" then
			if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvTime > 0 or TRB.Data.snapshotData.voidform.isInfinite) then
				valid = true
			end
		elseif var == "$vbCasts" then
			if TRB.Data.character.talents.hungeringVoid.isSelected and TRB.Data.snapshotData.voidform.remainingHvTime ~= nil and (TRB.Data.snapshotData.voidform.remainingHvTime > 0 or TRB.Data.snapshotData.voidform.isInfinite) then
				valid = true
			end
		elseif var == "$resource" or var == "$insanity" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$insanityMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$insanityTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id)) or
				(((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false)) > 0) then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$insanityPlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id)) then
				valid = true
			end
		elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
			if ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.settings.priest.shadow.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$insanityPlusPassive" then
			if TRB.Data.snapshotData.resource > 0 or
				((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false)) > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id) then
				valid = true
			end
		elseif var == "$passive" then
			if ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceRaw + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false)) > 0 then
				valid = true
			end
		elseif var == "$mbInsanity" then
			if TRB.Data.snapshotData.mindbender.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$mbGcds" then
			if TRB.Data.snapshotData.mindbender.remaining.gcds > 0 then
				valid = true
			end
		elseif var == "$mbSwings" then
			if TRB.Data.snapshotData.mindbender.remaining.swings > 0 then
				valid = true
			end
		elseif var == "$mbTime" then
			if TRB.Data.snapshotData.mindbender.remaining.time > 0 then
				valid = true
			end
		elseif var == "$wfInsanity" then
			if TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$wfGcds" then
			if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds > 0 then
				valid = true
			end
		elseif var == "$wfProcs" then
			if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs > 0 then
				valid = true
			end
		elseif var == "$wfTime" then
			if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time > 0 then
				valid = true
			end
		elseif var == "$loiInsanity" then
			if TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal > 0 then
				valid = true
			end
		elseif var == "$loiTicks" then
			if TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining > 0 then
				valid = true
			end
		elseif var == "$cttvEquipped" then
			if TRB.Data.settings.priest.shadow.voidTendrilTracker and TRB.Data.character.items.callToTheVoid == true then
				valid = true
			end
		elseif var == "$ecttvCount" then
			if TRB.Data.settings.priest.shadow.voidTendrilTracker and TRB.Data.snapshotData.eternalCallToTheVoid.numberActive > 0 then
				valid = true
			end
		elseif var == "$damInsanity" then
			if TRB.Data.snapshotData.deathAndMadness.insanity > 0 then
				valid = true
			end
		elseif var == "$damTicks" then
			if TRB.Data.snapshotData.deathAndMadness.ticksRemaining > 0 then
				valid = true
			end
		elseif var == "$asCount" then
			if TRB.Data.snapshotData.targetData.auspiciousSpirits > 0 then
				valid = true
			end
		elseif var == "$asInsanity" then
			if TRB.Data.snapshotData.targetData.auspiciousSpirits > 0 then
				valid = true
			end
		elseif var == "$swpCount" then
			if TRB.Data.snapshotData.targetData.shadowWordPain > 0 then
				valid = true
			end
		elseif var == "$vtCount" then
			if TRB.Data.snapshotData.targetData.vampiricTouch > 0 then
				valid = true
			end
		elseif var == "$dpCount" then
			if TRB.Data.snapshotData.targetData.devouringPlague > 0 then
				valid = true
			end
		elseif var == "$mdTime" then
			if TRB.Data.snapshotData.mindDevourer.spellId ~= nil then
				valid = true
			end
		elseif var == "$s2m" or var == "$surrenderToMadness" then
			if TRB.Data.character.talents.surrenderToMadeness.isSelected then
				valid = true
			end
		else
			valid = false
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData()
		local currentTime = GetTime()
		local normalizedInsanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		--$vfTime
		local voidformTime = string.format("%.1f", TRB.Data.snapshotData.voidform.remainingTime)
		--$hvTime
		local hungeringVoidTime = string.format("%.1f", TRB.Data.snapshotData.voidform.remainingHvTime)
		--$vbCasts
		local voidBoltCasts = string.format("%.0f", TRB.Data.snapshotData.voidform.additionalVbCasts)
		--$hvAvgTime
		local hungeringVoidTimeAvg = string.format("%.1f", TRB.Data.snapshotData.voidform.remainingHvAvgTime)
		--$vbAvgCasts
		local voidBoltCastsAvg = string.format("%.0f", TRB.Data.snapshotData.voidform.additionalVbAvgCasts)

		if TRB.Data.snapshotData.voidform.isInfinite then
			hungeringVoidTime = "∞"
			voidBoltCasts = "∞"
		end
		
		if TRB.Data.snapshotData.voidform.isAverageInfinite then
			hungeringVoidTimeAvg = "∞"
			voidBoltCastsAvg = "∞"
		end

		----------

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.currentInsanity
		local castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.castingInsanity

		local insanityThreshold = TRB.Data.character.devouringPlagueThreshold

		if TRB.Data.settings.priest.shadow.searingNightmareThreshold and TRB.Data.character.talents.searingNightmare.isSelected == true and TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id then
			insanityThreshold = TRB.Data.character.searingNightmareThreshold
		end
		
		if TRB.Data.settings.priest.shadow.colors.text.overcapEnabled and overcap then 
			currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overcapInsanity
			castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overcapInsanity	
		elseif TRB.Data.settings.priest.shadow.colors.text.overThresholdEnabled and normalizedInsanity >= insanityThreshold then
			currentInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overThreshold
			castingInsanityColor = TRB.Data.settings.priest.shadow.colors.text.overThreshold
		end

		--$insanity
		local insanityPrecision = TRB.Data.settings.priest.shadow.insanityPrecision or 0
		local currentInsanity = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.RoundTo(normalizedInsanity, insanityPrecision, "floor"))
		--$casting
		local castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, insanityPrecision, "floor"))
		--$mbInsanity
		local mbInsanity = string.format("%.0f", TRB.Data.snapshotData.mindbender.resourceFinal)
		--$mbGcds
		local mbGcds = string.format("%.0f", TRB.Data.snapshotData.mindbender.remaining.gcds)
		--$mbSwings
		local mbSwings = string.format("%.0f", TRB.Data.snapshotData.mindbender.remaining.swings)
		--$mbTime
		local mbTime = string.format("%.1f", TRB.Data.snapshotData.mindbender.remaining.time)
		--$wfInsanity
		local _wfInsanity = TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal
		local wfInsanity = string.format("%s", TRB.Functions.RoundTo(_wfInsanity, insanityPrecision, "floor"))
		--$wfGcds
		local wfGcds = string.format("%.0f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds))
		--$wfProcs
		local wfProcs = string.format("%.0f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs))
		--$wfTime
		local wfTime = string.format("%.1f", math.max(TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time, TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds))
		--$loiInsanity
		local loiInsanity = string.format("%.0f", TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal)
		--$loiTicks
		local loiTicks = string.format("%.0f", TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining)
		--$ecttvCount
		local ecttvCount = string.format("%.0f", TRB.Data.snapshotData.eternalCallToTheVoid.numberActive)
		--$asCount
		local asCount = string.format("%.0f", TRB.Data.snapshotData.targetData.auspiciousSpirits)
		--$damInsanity
		local _damInsanity = CalculateInsanityGain(TRB.Data.snapshotData.deathAndMadness.insanity, false)
		local damInsanity = string.format("%.0f", _damInsanity)
		--$damStacks
		local damTicks = string.format("%.0f", TRB.Data.snapshotData.deathAndMadness.ticksRemaining)
		--$asInsanity
		local _asInsanity = CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits
		local asInsanity = string.format("%.0f", _asInsanity)
		--$passive
		local _passiveInsanity = _asInsanity + TRB.Data.snapshotData.mindbender.resourceFinal + _damInsanity + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal
		local passiveInsanity = string.format("|c%s%.0f|r", TRB.Data.settings.priest.shadow.colors.text.passiveInsanity, _passiveInsanity)
		--$insanityTotal
		local _insanityTotal = math.min(_passiveInsanity + TRB.Data.snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityTotal = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.RoundTo(_insanityTotal, insanityPrecision, "floor"))
		--$insanityPlusCasting
		local _insanityPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusCasting = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.RoundTo(_insanityPlusCasting, insanityPrecision, "floor"))
		--$insanityPlusPassive
		local _insanityPlusPassive = math.min(_passiveInsanity + normalizedInsanity, TRB.Data.character.maxResource)
		local insanityPlusPassive = string.format("|c%s%s|r", currentInsanityColor, TRB.Functions.RoundTo(_insanityPlusPassive, insanityPrecision, "floor"))


		----------
		--$swpCount
		local shadowWordPainCount = TRB.Data.snapshotData.targetData.shadowWordPain or 0
		--$vtCount
		local vampiricTouchCount = TRB.Data.snapshotData.targetData.vampiricTouch or 0
		--$dpCount	
		local devouringPlagueCount = TRB.Data.snapshotData.targetData.devouringPlague or 0

		--$mdTime
		local _mdTime = 0
		if TRB.Data.snapshotData.mindDevourer.spellId ~= nil then
			_mdTime = math.abs(TRB.Data.snapshotData.mindDevourer.endTime - currentTime)
		end
		local mdTime = string.format("%.1f", _mdTime)

		----------

		--We have extra custom stuff we want to do with TTD for Priests
		--$ttd
		local _ttd = ""
		local ttd = ""
		local ttdTotalSeconds = 0

		if TRB.Data.snapshotData.targetData.ttdIsActive and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ttd ~= 0 then
			local target = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid]
			local ttdMinutes = math.floor(target.ttd / 60)
			local ttdSeconds = target.ttd % 60
			_ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)
			
			local _ttdColor = TRB.Data.settings.priest.shadow.colors.text.left
			local s2mStart, s2mDuration, _, _ = GetSpellCooldown(TRB.Data.spells.s2m.id)
					
			if TRB.Data.character.talents.surrenderToMadeness.isSelected and not TRB.Data.snapshotData.voidform.s2m.active then
				if TRB.Data.settings.priest.shadow.s2mThreshold <= target.ttd then
					_ttdColor = TRB.Data.settings.priest.shadow.colors.text.s2mAbove
				elseif TRB.Data.settings.priest.shadow.s2mApproachingThreshold <= target.ttd then
					_ttdColor = TRB.Data.settings.priest.shadow.colors.text.s2mApproaching    
				else
					_ttdColor = TRB.Data.settings.priest.shadow.colors.text.s2mBelow
				end
				
				ttd = string.format("|c%s%d:%0.2d|c%s", _ttdColor, ttdMinutes, ttdSeconds, TRB.Data.settings.priest.shadow.colors.text.left)
				ttdTotalSeconds = string.format("|c%s%s|c%s", _ttdColor, TRB.Functions.RoundTo(target.ttd, TRB.Data.settings.core.ttd.precision or 1, "floor"), TRB.Data.settings.priest.shadow.colors.text.left)
			else
				ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)			
				ttdTotalSeconds = string.format("%s", TRB.Functions.RoundTo(target.ttd, TRB.Data.settings.core.ttd.precision or 1, "floor"))
			end
		else
			ttd = "--"
			ttdTotalSeconds = string.format("%s", TRB.Functions.RoundTo(0, TRB.Data.settings.core.ttd.precision or 1, "floor"))
		end

		--#castingIcon
		local castingIcon = TRB.Data.snapshotData.casting.icon or ""
		----------------------------

		Global_TwintopInsanityBar = {
			ttd = ttd or "--",
			voidform = {
				hungeringVoid = {
					timeRemaining = TRB.Data.snapshotData.voidform.remainingHvTime,
					voidBoltCasts = TRB.Data.snapshotData.voidform.additionalVbCasts,
					TimeRemainingAverage = TRB.Data.snapshotData.voidform.remainingHvAvgTime,
					voidBoltCastsAverage = TRB.Data.snapshotData.voidform.additionalVbAvgCasts
				}
			},
			insanity = {
				insanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor or 0,
				casting = TRB.Data.snapshotData.casting.resourceFinal or 0,
				passive = _passiveInsanity,
				auspiciousSpirits = _asInsanity,
				mindbender = TRB.Data.snapshotData.mindbender.resourceFinal or 0,
				deathAndMadness = _damInsanity,
				ecttv = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0
			},
			auspiciousSpirits = {
				count = TRB.Data.snapshotData.targetData.auspiciousSpirits or 0,
				insanity = _asInsanity
			},
			dots = {
				swpCount = shadowWordPainCount or 0,
				vtCount = vampiricTouchCount or 0,
				dpCount = devouringPlagueCount or 0
			},
			mindbender = {			
				insanity = TRB.Data.snapshotData.mindbender.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.mindbender.remaining.gcds or 0,
				swings = TRB.Data.snapshotData.mindbender.remaining.swings or 0,
				time = TRB.Data.snapshotData.mindbender.remaining.time or 0
			},
			mindSear = {
				targetsHit = TRB.Data.snapshotData.mindSear.targetsHit or 0
			},
			deathAndMadness = {
				insanity = _damInsanity,
				ticks = TRB.Data.snapshotData.deathAndMadness.ticksRemaining or 0
			},
			eternalCallToTheVoid = {
				insanity = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0,
				ticks = TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining or 0,
				count = TRB.Data.snapshotData.eternalCallToTheVoid.numberActive or 0
			}
		}
		
		Global_TwintopResourceBar.voidform = {
			hungeringVoid = {
				timeRemaining = TRB.Data.snapshotData.voidform.remainingHvTime,
				voidBoltCasts = TRB.Data.snapshotData.voidform.additionalVbCasts,
				TimeRemainingAverage = TRB.Data.snapshotData.voidform.remainingHvAvgTime,
				voidBoltCastsAverage = TRB.Data.snapshotData.voidform.additionalVbAvgCasts,
				isInfinite = TRB.Data.snapshotData.voidform.isInfinite,
				isAverageInfinite = TRB.Data.snapshotData.voidform.isAverageInfinite
			}
		}
		Global_TwintopResourceBar.resource.passive = _passiveInsanity
		Global_TwintopResourceBar.resource.auspiciousSpirits = _asInsanity
		Global_TwintopResourceBar.resource.mindbender = TRB.Data.snapshotData.mindbender.resourceFinal or 0
		Global_TwintopResourceBar.resource.deathAndMadness = _damInsanity
		Global_TwintopResourceBar.resource.ecttv = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0
		Global_TwintopResourceBar.resource.wrathfulFaerie = _wfInsanity or 0
		Global_TwintopResourceBar.auspiciousSpirits = {
			count = TRB.Data.snapshotData.targetData.auspiciousSpirits or 0,
			insanity = _asInsanity
		}
		Global_TwintopResourceBar.dots = {
			swpCount = shadowWordPainCount or 0,
			vtCount = vampiricTouchCount or 0,
			dpCount = devouringPlagueCount or 0
		}
		Global_TwintopResourceBar.mindbender = {			
			insanity = TRB.Data.snapshotData.mindbender.resourceFinal or 0,
			gcds = TRB.Data.snapshotData.mindbender.remaining.gcds or 0,
			swings = TRB.Data.snapshotData.mindbender.remaining.swings or 0,
			time = TRB.Data.snapshotData.mindbender.remaining.time or 0
		}
		Global_TwintopResourceBar.mindSear = {
			targetsHit = TRB.Data.snapshotData.mindSear.targetsHit or 0
		}
		Global_TwintopResourceBar.deathAndMadness = {
			insanity = _damInsanity,
			ticks = TRB.Data.snapshotData.deathAndMadness.ticksRemaining or 0
		}
		Global_TwintopResourceBar.eternalCallToTheVoid = {
			insanity = TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal or 0,
			ticks = TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining or 0,
			count = TRB.Data.snapshotData.eternalCallToTheVoid.numberActive or 0
		}
		Global_TwintopResourceBar.wrathfulFaerie = {
			insanity = _wfInsanity,
			main = {			
				insanity = TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds or 0,
				procs = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs or 0,
				time = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time or 0
			},
			fermata = {				
				insanity = TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal or 0,
				gcds = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds or 0,
				procs = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs or 0,
				time = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time or 0
			}
		}

		
		local lookup = TRB.Data.lookup or {}
		lookup["#as"] = TRB.Data.spells.auspiciousSpirits.icon
		lookup["#auspiciousSpirits"] = TRB.Data.spells.auspiciousSpirits.icon
		lookup["#sa"] = TRB.Data.spells.shadowyApparition.icon
		lookup["#shadowyApparition"] = TRB.Data.spells.shadowyApparition.icon
		lookup["#mb"] = TRB.Data.spells.mindBlast.icon
		lookup["#mindBlast"] = TRB.Data.spells.mindBlast.icon
		lookup["#mf"] = TRB.Data.spells.mindFlay.icon
		lookup["#mindFlay"] = TRB.Data.spells.mindFlay.icon
		lookup["#ms"] = TRB.Data.spells.mindSear.icon
		lookup["#mindSear"] = TRB.Data.spells.mindSear.icon
		lookup["#mindbender"] = TRB.Data.spells.mindbender.icon
		lookup["#shadowfiend"] = TRB.Data.spells.shadowfiend.icon
		lookup["#wf"] = TRB.Data.spells.wrathfulFaerie.icon
		lookup["#wrathfulFaerie"] = TRB.Data.spells.wrathfulFaerie.icon
		lookup["#sf"] = TRB.Data.spells.shadowfiend.icon
		lookup["#ecttv"] = TRB.Data.spells.eternalCallToTheVoid_Tendril.icon
		lookup["#tb"] = TRB.Data.spells.eternalCallToTheVoid_Tendril.icon
		lookup["#loi"] = TRB.Data.spells.lashOfInsanity_Tendril.icon
		lookup["#vf"] = TRB.Data.spells.voidform.icon
		lookup["#voidform"] = TRB.Data.spells.voidform.icon
		lookup["#vb"] = TRB.Data.spells.voidBolt.icon
		lookup["#voidBolt"] = TRB.Data.spells.voidBolt.icon
		lookup["#vt"] = TRB.Data.spells.vampiricTouch.icon
		lookup["#vampiricTouch"] = TRB.Data.spells.vampiricTouch.icon
		lookup["#swp"] = TRB.Data.spells.shadowWordPain.icon
		lookup["#shadowWordPain"] = TRB.Data.spells.shadowWordPain.icon
		lookup["#dp"] = TRB.Data.spells.devouringPlague.icon
		lookup["#devouringPlague"] = TRB.Data.spells.devouringPlague.icon
		lookup["#mDev"] = TRB.Data.spells.mindDevourer.icon
		lookup["#mindDevourer"] = TRB.Data.spells.mindDevourer.icon
		lookup["#md"] = TRB.Data.spells.massDispel.icon
		lookup["#massDispel"] = TRB.Data.spells.massDispel.icon
		lookup["#dam"] = TRB.Data.spells.deathAndMadness.icon
		lookup["#deathAndMadness"] = TRB.Data.spells.deathAndMadness.icon
		lookup["$swpCount"] = shadowWordPainCount
		lookup["$vtCount"] = vampiricTouchCount
		lookup["$dpCount"] = devouringPlagueCount
		lookup["$mdTime"] = mdTime
		lookup["$vfTime"] = voidformTime
		lookup["$hvTime"] = hungeringVoidTime
		lookup["$vbCasts"] = voidBoltCasts
		lookup["$hvAvgTime"] = hungeringVoidTimeAvg
		lookup["$vbAvgCasts"] = voidBoltCastsAvg
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
		lookup["$wfInsanity"] = wfInsanity 
		lookup["$wfGcds"] = wfGcds
		lookup["$wfProcs"] = wfProcs
		lookup["$wfTime"] = wfTime
		lookup["$loiInsanity"] = loiInsanity
		lookup["$loiTicks"] = loiTicks
		lookup["$cttvEquipped"] = ""
		lookup["$ecttvCount"] = ecttvCount
		lookup["$damInsanity"] = damInsanity
		lookup["$damTicks"] = damTicks
		lookup["$asCount"] = asCount
		lookup["$asInsanity"] = asInsanity
		lookup["$ttd"] = ttd --Custom TTD for Shadow
		lookup["$ttdSeconds"] = ttdTotalSeconds
		lookup["$s2m"] = ""
		lookup["$surrenderToMadness"] = ""
		TRB.Data.lookup = lookup
	end
	TRB.Functions.RefreshLookupData = RefreshLookupData

	local function UpdateResourceBarShadow(settings, refreshText)
		TRB.Functions.RefreshLookupDataBase(settings)
		TRB.Functions.RefreshLookupData()
		local leftText, middleText, rightText = "", "", ""

		if refreshText then
			local returnText = {}
			returnText[0] = {}
			returnText[1] = {}
			returnText[2] = {}
			if TRB.Data.snapshotData.voidform.spellId then
				returnText[0].text = settings.displayText.left.inVoidformText
				returnText[1].text = settings.displayText.middle.inVoidformText
				returnText[2].text = settings.displayText.right.inVoidformText
			else
				returnText[0].text = settings.displayText.left.outVoidformText
				returnText[1].text = settings.displayText.middle.outVoidformText
				returnText[2].text = settings.displayText.right.outVoidformText
			end

			returnText[0].color = string.format("|c%s", settings.colors.text.left)
			returnText[1].color = string.format("|c%s", settings.colors.text.middle)
			returnText[2].color = string.format("|c%s", settings.colors.text.right)

			leftText, middleText, rightText = TRB.Functions.GetReturnText(returnText[0]), TRB.Functions.GetReturnText(returnText[1]), TRB.Functions.GetReturnText(returnText[2])
		end

		TRB.Functions.UpdateResourceBarText(settings, leftText, middleText, rightText)
	end

	local function UpdateCastingResourceFinal(fotm)	
		TRB.Data.snapshotData.casting.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.casting.resourceRaw, fotm)
		CalculateRemainingHungeringVoidTime()
	end

	local function CastingSpell()
		local currentTime = GetTime()	
		local currentSpell = UnitCastingInfo("player")
		local currentChannel = UnitChannelInfo("player")
		
		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if currentSpell == nil then
				local spellName = select(1, currentChannel)
				if spellName == TRB.Data.spells.mindFlay.name then
					TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindFlay.id
					TRB.Data.snapshotData.casting.startTime = currentTime
					TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindFlay.insanity
					TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindFlay.icon
					UpdateCastingResourceFinal(TRB.Data.spells.mindFlay.fotm)
				elseif spellName == TRB.Data.spells.mindSear.name then
					local latency = TRB.Functions.GetLatency()

					if TRB.Data.snapshotData.mindSear.hitTime == nil then
						TRB.Data.snapshotData.mindSear.targetsHit = 1
						TRB.Data.snapshotData.mindSear.hitTime = currentTime
						TRB.Data.snapshotData.mindSear.hasStruckTargets = false
					elseif currentTime > (TRB.Data.snapshotData.mindSear.hitTime + (TRB.Functions.GetCurrentGCDTime(true) / 2) + latency) then
						TRB.Data.snapshotData.mindSear.targetsHit = 0
					end

					TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindSear.id
					TRB.Data.snapshotData.casting.startTime = currentTime				
					TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindSear.insanity * TRB.Data.snapshotData.mindSear.targetsHit
					TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindSear.icon
					UpdateCastingResourceFinal(TRB.Data.spells.mindSear.fotm)
				elseif spellName == TRB.Data.spells.voidTorrent.name then
					TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.voidTorrent.id
					TRB.Data.snapshotData.casting.startTime = currentTime
					TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.voidTorrent.insanity
					TRB.Data.snapshotData.casting.icon = TRB.Data.spells.voidTorrent.icon
					UpdateCastingResourceFinal(TRB.Data.spells.voidTorrent.fotm)
				else
					TRB.Functions.ResetCastingSnapshotData()
					return false
				end
			else	
				local spellName = select(1, currentSpell)
				if spellName == TRB.Data.spells.mindBlast.name then
					TRB.Data.snapshotData.casting.startTime = currentTime
					TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.mindBlast.insanity
					TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.mindBlast.id
					TRB.Data.snapshotData.casting.icon = TRB.Data.spells.mindBlast.icon
					UpdateCastingResourceFinal(TRB.Data.spells.mindBlast.fotm)
				elseif spellName == TRB.Data.spells.vampiricTouch.name then
					TRB.Data.snapshotData.casting.startTime = currentTime
					TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.vampiricTouch.insanity
					TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.vampiricTouch.id
					TRB.Data.snapshotData.casting.icon = TRB.Data.spells.vampiricTouch.icon
					UpdateCastingResourceFinal(TRB.Data.spells.vampiricTouch.fotm)
				elseif spellName == TRB.Data.spells.massDispel.name then
					TRB.Data.snapshotData.casting.startTime = currentTime
					TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.massDispel.insanity
					TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.massDispel.id
					TRB.Data.snapshotData.casting.icon = TRB.Data.spells.massDispel.icon
					UpdateCastingResourceFinal(TRB.Data.spells.massDispel.fotm)
				else
					TRB.Functions.ResetCastingSnapshotData()
					return false				
				end
			end
			return true
		end
	end

	local function UpdateMindbenderValues()
		local currentTime = GetTime()
		local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
		local timeRemaining = startTime+duration-currentTime
		if TRB.Data.settings.priest.shadow.mindbender.enabled and haveTotem and timeRemaining > 0 then
			TRB.Data.snapshotData.mindbender.isActive = true
			if TRB.Data.settings.priest.shadow.mindbender.enabled then				
				local rabidShadowsPercent = 1 + TRB.Data.spells.rabidShadows.conduitRanks[TRB.Functions.GetSoulbindRank(TRB.Data.spells.rabidShadows.conduitId)]
				local swingSpeed = 1.5 / (1 + (TRB.Data.snapshotData.haste / 100)) / rabidShadowsPercent
				
				if swingSpeed > 1.5 then
					swingSpeed = 1.5
				end
				
				local timeToNextSwing = swingSpeed - (currentTime - TRB.Data.snapshotData.mindbender.swingTime)
				
				if timeToNextSwing < 0 then
					timeToNextSwing = 0
				elseif timeToNextSwing > 1.5 then
					timeToNextSwing = 1.5
				end        

				TRB.Data.snapshotData.mindbender.remaining.time = timeRemaining
				TRB.Data.snapshotData.mindbender.remaining.swings = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
				
				local gcd = swingSpeed				
				if gcd < 0.75 then
					gcd = 0.75
				end
				
				if timeRemaining > (gcd * TRB.Data.snapshotData.mindbender.remaining.swings) then
					TRB.Data.snapshotData.mindbender.remaining.gcds = math.ceil(((gcd * TRB.Data.snapshotData.mindbender.remaining.swings) - timeToNextSwing) / swingSpeed)
				else
					TRB.Data.snapshotData.mindbender.remaining.gcds = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
				end	
					
				TRB.Data.snapshotData.mindbender.swingTime = currentTime
				
				local countValue = 0

				if TRB.Data.settings.priest.shadow.mindbender.mode == "swing" then
					if TRB.Data.snapshotData.mindbender.remaining.swings > TRB.Data.settings.priest.shadow.mindbender.swingsMax then
						countValue = TRB.Data.settings.priest.shadow.mindbender.swingsMax
					else
						countValue = TRB.Data.snapshotData.mindbender.remaining.swings
					end
				elseif TRB.Data.settings.priest.shadow.mindbender.mode == "time" then
					if TRB.Data.snapshotData.mindbender.remaining.time > TRB.Data.settings.priest.shadow.mindbender.timeMax then
						countValue = math.ceil((TRB.Data.settings.priest.shadow.mindbender.timeMax - timeToNextSwing) / swingSpeed)                
					else
						countValue = math.ceil((TRB.Data.snapshotData.mindbender.remaining.time - timeToNextSwing) / swingSpeed)
					end
				else --assume GCD
					if TRB.Data.snapshotData.mindbender.remaining.gcds > TRB.Data.settings.priest.shadow.mindbender.gcdsMax then
						countValue = TRB.Data.settings.priest.shadow.mindbender.gcdsMax
					else
						countValue = TRB.Data.snapshotData.mindbender.remaining.gcds
					end
				end

				if TRB.Data.character.talents.mindbender.isSelected then
					TRB.Data.snapshotData.mindbender.resourceRaw = countValue * TRB.Data.spells.mindbender.insanity
				else
					TRB.Data.snapshotData.mindbender.resourceRaw = countValue * TRB.Data.spells.shadowfiend.insanity
				end
				TRB.Data.snapshotData.mindbender.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.mindbender.resourceRaw, false)
			end
		else
			TRB.Data.snapshotData.mindbender.onCooldown = not (GetSpellCooldown(TRB.Data.spells.mindbender.id) == 0)
			TRB.Data.snapshotData.mindbender.isActive = false
			TRB.Data.snapshotData.mindbender.swingTime = 0
			TRB.Data.snapshotData.mindbender.remaining = {}
			TRB.Data.snapshotData.mindbender.remaining.swings = 0
			TRB.Data.snapshotData.mindbender.remaining.gcds = 0
			TRB.Data.snapshotData.mindbender.remaining.time = 0
			TRB.Data.snapshotData.mindbender.resourceRaw = 0
			TRB.Data.snapshotData.mindbender.resourceFinal = 0		
		end
	end

	local function UpdateExternalCallToTheVoidValues()
		local currentTime = GetTime()
		local totalTicksRemaining_Lasher = 0
		local totalTicksRemaining_Tendril = 0
		local totalInsanity_Lasher = 0
		local totalInsanity_Tendril = 0
		local totalActive = 0

		-- TODO: Add separate counts for Tendril vs Lasher?
		if TRB.Functions.TableLength(TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils) > 0 then
			for vtGuid,v in pairs(TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils) do
				if TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid] ~= nil and TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].startTime ~= nil then
					local endTime = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].startTime + TRB.Data.spells.lashOfInsanity_Tendril.duration
					local timeRemaining = endTime - currentTime

					if timeRemaining < 0 then
						RemoveVoidTendril(vtGuid)
					else						
						if TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].type == "Lasher" then
							if TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime ~= nil and currentTime > (TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime + 5) then
								TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].targetsHit = 0
							end
							
							local nextTick = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime + (TRB.Data.spells.lashOfInsanity_Lasher.tickDuration / ((TRB.Data.snapshotData.haste / 100) + 1))

							if nextTick < currentTime then
								nextTick = currentTime --There should be a tick. ANY second now. Maybe.
								totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + 1
							end
							-- NOTE: Might need to be math.floor()
							local ticksRemaining = math.ceil((endTime - nextTick) / TRB.Data.spells.lashOfInsanity_Lasher.tickDuration / ((TRB.Data.snapshotData.haste / 100) + 1)) -- This is hasted

							totalInsanity_Lasher = totalInsanity_Lasher + (ticksRemaining * TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].targetsHit * TRB.Data.spells.lashOfInsanity_Lasher.insanity)
							totalTicksRemaining_Lasher = totalTicksRemaining_Lasher + ticksRemaining
						else							
							local nextTick = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[vtGuid].tickTime + TRB.Data.spells.lashOfInsanity_Tendril.tickDuration

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

		TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining = totalTicksRemaining_Tendril + totalTicksRemaining_Lasher
		TRB.Data.snapshotData.eternalCallToTheVoid.numberActive = totalActive
		TRB.Data.snapshotData.eternalCallToTheVoid.resourceRaw = totalInsanity_Tendril + totalInsanity_Lasher
		-- Fortress of the Mind does not apply but other Insanity boosting effects do.
		TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.eternalCallToTheVoid.resourceRaw, TRB.Data.spells.lashOfInsanity_Tendril.fotm)
	end

	local function UpdateDeathAndMadness()
		if TRB.Data.snapshotData.deathAndMadness.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.deathAndMadness.endTime == nil or currentTime > TRB.Data.snapshotData.deathAndMadness.endTime then
				TRB.Data.snapshotData.deathAndMadness.ticksRemaining = 0
				TRB.Data.snapshotData.deathAndMadness.endTime = nil
				TRB.Data.snapshotData.deathAndMadness.insanity = 0			
				TRB.Data.snapshotData.deathAndMadness.isActive = false
			else
				TRB.Data.snapshotData.deathAndMadness.ticksRemaining = math.ceil(TRB.Data.snapshotData.deathAndMadness.endTime - currentTime) / (TRB.Data.spells.deathAndMadness.duration / TRB.Data.spells.deathAndMadness.ticks)
				TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
			end
		end
	end

	local function UpdateWrathfulFaerieValues()
		local currentTime = GetTime()
		if TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled and TRB.Data.snapshotData.wrathfulFaerie.main.endTime and TRB.Data.snapshotData.wrathfulFaerie.main.endTime > currentTime then
			local timeRemaining = TRB.Data.snapshotData.wrathfulFaerie.main.endTime - currentTime
			--TRB.Data.snapshotData.wrathfulFaerie.main.isActive = true
			if TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled then
				local tickRate = (TRB.Data.spells.wrathfulFaerie.icd or 0.75) + (TRB.Data.settings.priest.shadow.wrathfulFaerie.procDelay or 0.15)
				
				local timeToNextProc = tickRate - (currentTime - TRB.Data.snapshotData.wrathfulFaerie.main.procTime)
				
				if timeToNextProc < 0 then
					timeToNextProc = 0
				elseif timeToNextProc > tickRate then
					timeToNextProc = tickRate
				end        
				
				local gcd = TRB.Functions.GetCurrentGCDTime(true)

				TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time = timeRemaining
				TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs = math.ceil((timeRemaining - timeToNextProc) / tickRate)
				TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds = math.ceil(timeRemaining / gcd)
					
				TRB.Data.snapshotData.wrathfulFaerie.main.procTime = currentTime
				
				local countValue = 0

				if TRB.Data.settings.priest.shadow.wrathfulFaerie.mode == "procs" then
					if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs > TRB.Data.settings.priest.shadow.wrathfulFaerie.procsMax then
						countValue = TRB.Data.settings.priest.shadow.wrathfulFaerie.procsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs
					end
				elseif TRB.Data.settings.priest.shadow.wrathfulFaerie.mode == "time" then
					if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time > TRB.Data.settings.priest.shadow.wrathfulFaerie.timeMax then
						countValue = math.ceil((TRB.Data.settings.priest.shadow.wrathfulFaerie.timeMax - timeToNextProc) / tickRate)                
					else
						countValue = math.ceil((TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time - timeToNextProc) / tickRate)
					end
				else --assume GCD
					if TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds > TRB.Data.settings.priest.shadow.wrathfulFaerie.gcdsMax then
						countValue = TRB.Data.settings.priest.shadow.wrathfulFaerie.gcdsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds
					end
				end

				if TRB.Data.snapshotData.targetData.wrathfulFaerieGuid then
					TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw = countValue * TRB.Data.spells.wrathfulFaerie.insanity
					TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw, false)
				else
					TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw = 0
					TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal = 0
				end
			end
		else
			TRB.Data.snapshotData.wrathfulFaerie.main.onCooldown = not (GetSpellCooldown(TRB.Data.spells.wrathfulFaerie.id) == 0)
			TRB.Data.snapshotData.wrathfulFaerie.main.isActive = false
			TRB.Data.snapshotData.wrathfulFaerie.main.endTime = nil
			TRB.Data.snapshotData.wrathfulFaerie.main.procTime = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining = {}
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining.procs = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining.gcds = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.remaining.time = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.resourceRaw = 0
			TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal = 0		
		end
		
		if TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled and TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime and TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime > currentTime then
			local timeRemaining = TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime - currentTime
			
			if TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled then
				local tickRate = (TRB.Data.spells.wrathfulFaerie.icd or 0.75) + (TRB.Data.settings.priest.shadow.wrathfulFaerie.procDelay or 0.15)
				
				local timeToNextProc = tickRate - (currentTime - TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime)
				
				if timeToNextProc < 0 then
					timeToNextProc = 0
				elseif timeToNextProc > tickRate then
					timeToNextProc = tickRate
				end        
				
				local gcd = TRB.Functions.GetCurrentGCDTime(true)

				TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time = timeRemaining
				TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs = math.ceil((timeRemaining - timeToNextProc) / tickRate)
				TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds = math.ceil(timeRemaining / gcd)
					
				TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime = currentTime
				
				local countValue = 0

				if TRB.Data.settings.priest.shadow.wrathfulFaerie.mode == "procs" then
					if TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs > TRB.Data.settings.priest.shadow.wrathfulFaerie.procsMax then
						countValue = TRB.Data.settings.priest.shadow.wrathfulFaerie.procsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs
					end
				elseif TRB.Data.settings.priest.shadow.wrathfulFaerie.mode == "time" then
					if TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time > TRB.Data.settings.priest.shadow.wrathfulFaerie.timeMax then
						countValue = math.ceil((TRB.Data.settings.priest.shadow.wrathfulFaerie.timeMax - timeToNextProc) / tickRate)                
					else
						countValue = math.ceil((TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time - timeToNextProc) / tickRate)
					end
				else --assume GCD
					if TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds > TRB.Data.settings.priest.shadow.wrathfulFaerie.gcdsMax then
						countValue = TRB.Data.settings.priest.shadow.wrathfulFaerie.gcdsMax
					else
						countValue = TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds
					end
				end

				if TRB.Data.snapshotData.targetData.wrathfulFaerieFermataGuid then
					TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw = countValue * TRB.Data.spells.wrathfulFaerie.insanity * TRB.Data.spells.wrathfulFaerieFermata.modifier
					TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal = CalculateInsanityGain(TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw, false)
				else
					TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw = 0
					TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal = 0
				end
			end
		else
			TRB.Data.snapshotData.wrathfulFaerie.fermata.isActive = false
			TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime = nil
			TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining = {}
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.procs = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.gcds = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.remaining.time = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceRaw = 0
			TRB.Data.snapshotData.wrathfulFaerie.fermata.resourceFinal = 0		
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		TRB.Data.spells.s2m.isActive = select(10, TRB.Functions.FindBuffById(TRB.Data.spells.s2m.id))
		UpdateMindbenderValues()
		UpdateExternalCallToTheVoidValues()
		UpdateDeathAndMadness()
		UpdateWrathfulFaerieValues()
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
	
		if force or GetSpecialization() ~= 3 or ((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.priest.shadow.displayBar.alwaysShow) and (
					(not TRB.Data.settings.priest.shadow.displayBar.notZeroShow) or
					(TRB.Data.settings.priest.shadow.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
				)
			 )) then
			TRB.Frames.barContainerFrame:Hide()	
			TRB.Data.snapshotData.isTracking = false
		else
			TRB.Data.snapshotData.isTracking = true
			if TRB.Data.settings.priest.shadow.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()	
			else
				TRB.Frames.barContainerFrame:Show()	
			end
		end
	end
	TRB.Functions.HideResourceBar = HideResourceBar

	local function UpdateResourceBar()
		local refreshText = false
		UpdateSnapshot()

		if TRB.Data.snapshotData.isTracking then
			TRB.Functions.HideResourceBar()

			CalculateRemainingHungeringVoidTime()
			
			if TRB.Data.settings.priest.shadow.displayBar.neverShow == false then
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentInsanity = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

				if TRB.Data.settings.priest.shadow.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.borderOvercap, true))
					
					if TRB.Data.settings.priest.shadow.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
						TRB.Data.snapshotData.audio.overcapCue = true
						PlaySoundFile(TRB.Data.settings.priest.shadow.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
					end
				else
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.border, true))
					TRB.Data.snapshotData.audio.overcapCue = false
				end

				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, resourceFrame, currentInsanity)
				
				if CastingSpell() then
					castingBarValue = currentInsanity + TRB.Data.snapshotData.casting.resourceFinal
				else
					castingBarValue = currentInsanity
				end
				
				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, castingFrame, castingBarValue)

				if TRB.Data.character.talents.as.isSelected or TRB.Data.snapshotData.mindbender.resourceFinal > 0 or TRB.Data.snapshotData.deathAndMadness.isActive or TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal > 0 then
					passiveBarValue = castingBarValue + ((CalculateInsanityGain(TRB.Data.spells.auspiciousSpirits.insanity, false) * TRB.Data.snapshotData.targetData.auspiciousSpirits) + TRB.Data.snapshotData.mindbender.resourceFinal + TRB.Data.snapshotData.deathAndMadness.insanity + TRB.Data.snapshotData.eternalCallToTheVoid.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal)
					if TRB.Data.snapshotData.mindbender.resourceFinal > 0 and (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal) < TRB.Data.character.maxResource then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, passiveFrame.thresholds[1], passiveFrame, TRB.Data.settings.priest.shadow.thresholdWidth, (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal), TRB.Data.character.maxResource)
						passiveFrame.thresholds[1].texture:Show()
					else
						passiveFrame.thresholds[1].texture:Hide()
					end
					
					if TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal > 0 and (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal) < TRB.Data.character.maxResource then
						TRB.Functions.RepositionThreshold(TRB.Data.settings.priest.shadow, passiveFrame.thresholds[2], passiveFrame, TRB.Data.settings.priest.shadow.thresholdWidth, (castingBarValue + TRB.Data.snapshotData.mindbender.resourceFinal + TRB.Data.snapshotData.wrathfulFaerie.main.resourceFinal), TRB.Data.character.maxResource)
						passiveFrame.thresholds[2].texture:Show()
					else
						passiveFrame.thresholds[2].texture:Hide()
					end
				else
					passiveFrame.thresholds[1].texture:Hide()
					passiveFrame.thresholds[2].texture:Hide()
					passiveBarValue = castingBarValue
				end

				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.priest.shadow, passiveFrame, passiveBarValue)

				if TRB.Data.settings.priest.shadow.devouringPlagueThreshold then
					resourceFrame.thresholds[1]:Show()
				else
					resourceFrame.thresholds[1]:Hide()
				end

				if TRB.Data.settings.priest.shadow.searingNightmareThreshold and TRB.Data.character.talents.searingNightmare.isSelected == true and TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.mindSear.id then			
					if currentInsanity >= TRB.Data.character.searingNightmareThreshold then
						resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
					else
						resourceFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
					end
					resourceFrame.thresholds[2]:Show()
				else
					resourceFrame.thresholds[2]:Hide()
				end
				
				if currentInsanity >= TRB.Data.character.devouringPlagueThreshold or TRB.Data.spells.mindDevourer.isActive then
					resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.over, true))
					if TRB.Data.settings.priest.shadow.colors.bar.flashEnabled then
						TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.priest.shadow.colors.bar.flashAlpha, TRB.Data.settings.priest.shadow.colors.bar.flashPeriod)
					else
						barContainerFrame:SetAlpha(1.0)
					end	
			
					if TRB.Data.spells.mindDevourer.isActive and TRB.Data.settings.priest.shadow.audio.mdProc.enabled and TRB.Data.snapshotData.audio.playedMdCue == false then				
						TRB.Data.snapshotData.audio.playedDpCue = true
						TRB.Data.snapshotData.audio.playedMdCue = true
						PlaySoundFile(TRB.Data.settings.priest.shadow.audio.mdProc.sound, TRB.Data.settings.core.audio.channel.channel)
					elseif TRB.Data.settings.priest.shadow.audio.dpReady.enabled and TRB.Data.snapshotData.audio.playedDpCue == false then
						TRB.Data.snapshotData.audio.playedDpCue = true
						PlaySoundFile(TRB.Data.settings.priest.shadow.audio.dpReady.sound, TRB.Data.settings.core.audio.channel.channel)
					end
				else
					resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.threshold.under, true))
					barContainerFrame:SetAlpha(1.0)
					TRB.Data.snapshotData.audio.playedDpCue = false
					TRB.Data.snapshotData.audio.playedMdCue = false
				end
				
				if TRB.Data.snapshotData.voidform.spellId then
					local timeThreshold = 0
					local useEndOfVoidformColor = false

					if TRB.Data.settings.priest.shadow.endOfVoidform.enabled and (not TRB.Data.settings.priest.shadow.endOfVoidform.hungeringVoidOnly or TRB.Data.character.talents.hungeringVoid.isSelected) then
						useEndOfVoidformColor = true
						if TRB.Data.settings.priest.shadow.endOfVoidform.mode == "gcd" then
							local gcd = TRB.Functions.GetCurrentGCDTime()
							timeThreshold = gcd * TRB.Data.settings.priest.shadow.endOfVoidform.gcdsMax
						elseif TRB.Data.settings.priest.shadow.endOfVoidform.mode == "time" then
							timeThreshold = TRB.Data.settings.priest.shadow.endOfVoidform.timeMax
						end
					end
					
					if useEndOfVoidformColor and TRB.Data.snapshotData.voidform.remainingTime <= timeThreshold then
						resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform1GCD, true))
					elseif currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
						resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.enterVoidform, true))
					else
						resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.inVoidform, true))	
					end
				else
					if currentInsanity >= TRB.Data.character.devouringPlagueThreshold then
						resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.enterVoidform, true))
					else
						resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.priest.shadow.colors.bar.base, true))
					end
				end
			end
		end
		--Normally we'd just call the base, but Shadow has special dual text output because of Voidform. Make manual calls instead
		--TRB.Functions.UpdateResourceBar(TRB.Data.settings.priest.shadow, not TRB.Data.settings.priest.shadow.displayBar.neverShow)
		UpdateResourceBarShadow(TRB.Data.settings.priest.shadow, refreshText)
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		if GetSpecialization() ~= 3 then
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
			if TRB.Data.snapshotData.mindSear.hitTime ~= nil and currentTime > (TRB.Data.snapshotData.mindSear.hitTime + 5) then
				TRB.Data.snapshotData.mindSear.hitTime = nil
				TRB.Data.snapshotData.mindSear.targetsHit = 0
			end
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

	--[[
	function mindbenderAudioCueFrame:onUpdate(sinceLastUpdate)
		self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
		self.sinceLastPlay = self.sinceLastPlay + sinceLastUpdate
		if self.sinceLastUpdate >= 0.05 then -- in seconds	
			if self.sinceLastPlay >= 0.75 and not TRB.Data.snapshotData.mindbender.isActive then -- in seconds
				if TRB.Data.settings.priest.shadow.mindbender.useNotification.useVoidformStacks == true and not TRB.Data.snapshotData.mindbender.onCooldown and TRB.Data.snapshotData.voidform.totalStacks >= TRB.Data.settings.priest.shadow.mindbender.useNotification.thresholdStacks then
					PlaySoundFile(TRB.Data.settings.priest.shadow.audio.mindbender.sound, TRB.Data.settings.core.audio.channel.channel, false)
					self.sinceLastPlay = 0
				elseif TRB.Data.settings.priest.shadow.mindbender.useNotification.useVoidformStacks == false and not TRB.Data.snapshotData.mindbender.onCooldown and TRB.Data.snapshotData.voidform.drainStacks >= TRB.Data.settings.priest.shadow.mindbender.useNotification.thresholdStacks then
					PlaySoundFile(TRB.Data.settings.priest.shadow.audio.mindbender.sound, TRB.Data.settings.core.audio.channel.channel, false)
					self.sinceLastPlay = 0
				end
			end
			
			self.sinceLastUpdate = 0
		end
	end
	]]

	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false	
		local _
			
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			local s2mDeath = false
			
			if destGUID == TRB.Data.character.guid then
				if TRB.Data.settings.priest.shadow.mindbender.enabled and type == "SPELL_ENERGIZE" and
					((TRB.Data.character.talents.mindbender.isSelected and sourceName == TRB.Data.spells.mindbender.name) or 
					(not TRB.Data.character.talents.mindbender.isSelected and sourceName == TRB.Data.spells.shadowfiend.name)) then 
					TRB.Data.snapshotData.mindbender.swingTime = currentTime
				elseif (type == "SPELL_INSTAKILL" or type == "UNIT_DIED" or type == "UNIT_DESTROYED") then
					if TRB.Data.snapshotData.voidform.s2m.active then -- Surrender to Madness ended
						s2mDeath = true
					end
				end	
			end

			if sourceGUID == TRB.Data.character.guid then 
				if spellId == TRB.Data.spells.s2m.id then                
					if type == "SPELL_AURA_APPLIED" then -- Gain Surrender to Madness   
						TRB.Data.snapshotData.voidform.s2m.active = true
						TRB.Data.snapshotData.voidform.s2m.startTime = currentTime
						UpdateCastingResourceFinal()					
						triggerUpdate = true
					elseif type == "SPELL_AURA_REMOVED" and TRB.Data.snapshotData.voidform.s2m.active then -- Lose Surrender to Madness
						if destGUID == TRB.Data.character.guid then -- You died
							s2mDeath = true
						end
						TRB.Data.snapshotData.voidform.s2m.startTime = nil
						TRB.Data.snapshotData.voidform.s2m.active = false
					end
				elseif spellId == TRB.Data.spells.deathAndMadness.id then
					if type == "SPELL_AURA_APPLIED" then -- Gain Death and Madness
						TRB.Data.snapshotData.deathAndMadness.isActive = true
						TRB.Data.snapshotData.deathAndMadness.ticksRemaining = TRB.Data.spells.deathAndMadness.ticks
						TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
						TRB.Data.snapshotData.deathAndMadness.endTime = currentTime + TRB.Data.spells.deathAndMadness.duration
						TRB.Data.snapshotData.deathAndMadness.lastTick = currentTime
					elseif type == "SPELL_AURA_REFRESH" then
						TRB.Data.snapshotData.deathAndMadness.ticksRemaining = TRB.Data.spells.deathAndMadness.ticks + 1
						TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
						TRB.Data.snapshotData.deathAndMadness.endTime = currentTime + TRB.Data.spells.deathAndMadness.duration + ((TRB.Data.spells.deathAndMadness.duration / TRB.Data.spells.deathAndMadness.ticks) - (currentTime - TRB.Data.snapshotData.deathAndMadness.lastTick))
						TRB.Data.snapshotData.deathAndMadness.lastTick = currentTime
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.deathAndMadness.isActive = false
						TRB.Data.snapshotData.deathAndMadness.ticksRemaining = 0
						TRB.Data.snapshotData.deathAndMadness.insanity = 0
						TRB.Data.snapshotData.deathAndMadness.endTime = nil
						TRB.Data.snapshotData.deathAndMadness.lastTick = nil
					elseif type == "SPELL_PERIODIC_ENERGIZE" then
						TRB.Data.snapshotData.deathAndMadness.ticksRemaining = TRB.Data.snapshotData.deathAndMadness.ticksRemaining - 1
						TRB.Data.snapshotData.deathAndMadness.insanity = TRB.Data.snapshotData.deathAndMadness.ticksRemaining * TRB.Data.spells.deathAndMadness.insanity
						TRB.Data.snapshotData.deathAndMadness.lastTick = currentTime
					end				
				elseif spellId == TRB.Data.spells.shadowWordPain.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- SWP Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].shadowWordPain = true
						TRB.Data.snapshotData.targetData.shadowWordPain = TRB.Data.snapshotData.targetData.shadowWordPain + 1
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.targetData.targets[destGUID].shadowWordPain = false
						TRB.Data.snapshotData.targetData.shadowWordPain = TRB.Data.snapshotData.targetData.shadowWordPain - 1
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end			
				elseif spellId == TRB.Data.spells.mindSear.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_CAST_SUCCESS" then
						if TRB.Data.snapshotData.mindSear.hitTime == nil then --This is a new cast without target data
							TRB.Data.snapshotData.mindSear.targetsHit = 1
						end
						TRB.Data.snapshotData.mindSear.hitTime = currentTime
					end		
				elseif spellId == TRB.Data.spells.mindSear.idTick then
					if type == "SPELL_DAMAGE" then
						if currentTime > (TRB.Data.snapshotData.mindSear.hitTime + 0.1) then --This is a new tick
							TRB.Data.snapshotData.mindSear.targetsHit = 0
						end
						TRB.Data.snapshotData.mindSear.targetsHit = TRB.Data.snapshotData.mindSear.targetsHit + 1
						TRB.Data.snapshotData.mindSear.hitTime = currentTime					
						TRB.Data.snapshotData.mindSear.hasStruckTargets = true
					end
				elseif spellId == TRB.Data.spells.vampiricTouch.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- VT Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].vampiricTouch = true
						TRB.Data.snapshotData.targetData.vampiricTouch = TRB.Data.snapshotData.targetData.vampiricTouch + 1
					elseif type == "SPELL_AURA_REMOVED" then				
						TRB.Data.snapshotData.targetData.targets[destGUID].vampiricTouch = false
						TRB.Data.snapshotData.targetData.vampiricTouch = TRB.Data.snapshotData.targetData.vampiricTouch - 1
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end
				elseif spellId == TRB.Data.spells.devouringPlague.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- DP Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].devouringPlague = true
						TRB.Data.snapshotData.targetData.devouringPlague = TRB.Data.snapshotData.targetData.devouringPlague + 1
					elseif type == "SPELL_AURA_REMOVED" then				
						TRB.Data.snapshotData.targetData.targets[destGUID].devouringPlague = false
						TRB.Data.snapshotData.targetData.devouringPlague = TRB.Data.snapshotData.targetData.devouringPlague - 1
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end
				elseif TRB.Data.settings.priest.shadow.auspiciousSpiritsTracker and TRB.Data.character.talents.as.isSelected and spellId == TRB.Data.spells.auspiciousSpirits.idSpawn and type == "SPELL_CAST_SUCCESS" then -- Shadowy Apparition Spawned
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits + 1
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits + 1
					triggerUpdate = true
				elseif TRB.Data.settings.priest.shadow.auspiciousSpiritsTracker and TRB.Data.character.talents.as.isSelected and spellId == TRB.Data.spells.auspiciousSpirits.idImpact and (type == "SPELL_DAMAGE" or type == "SPELL_MISSED" or type == "SPELL_ABSORBED") then --Auspicious Spirit Hit
					if TRB.Functions.CheckTargetExists(destGUID) then
						TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits = TRB.Data.snapshotData.targetData.targets[destGUID].auspiciousSpirits - 1
						TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
						TRB.Data.snapshotData.targetData.auspiciousSpirits = TRB.Data.snapshotData.targetData.auspiciousSpirits - 1
					end
					triggerUpdate = true
				elseif type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.shadowCrash.id then
					triggerUpdate = true
				elseif spellId == TRB.Data.spells.memoryOfLucidDreams.id then
					if type == "SPELL_AURA_APPLIED" then -- Gained buff
						TRB.Data.spells.memoryOfLucidDreams.isActive = true
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.memoryOfLucidDreams.isActive = false
					end	
				elseif spellId == TRB.Data.spells.mindDevourer.id then
					if type == "SPELL_AURA_APPLIED" then -- Gained buff
						TRB.Data.spells.mindDevourer.isActive = true
						_, _, _, _, TRB.Data.snapshotData.mindDevourer.duration, TRB.Data.snapshotData.mindDevourer.endTime, _, _, _, TRB.Data.snapshotData.mindDevourer.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.mindDevourer.id)
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.mindDevourer.isActive = false
						TRB.Data.snapshotData.mindDevourer.spellId = nil
						TRB.Data.snapshotData.mindDevourer.duration = 0
						TRB.Data.snapshotData.mindDevourer.endTime = nil
					end
				elseif TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerie.id then
					if type == "SPELL_AURA_APPLIED" then -- Gained buff
						if TRB.Data.snapshotData.wrathfulFaerie.main.isActive == false then
							TRB.Data.snapshotData.wrathfulFaerie.main.isActive = true
							TRB.Data.snapshotData.wrathfulFaerie.main.endTime = currentTime + (TRB.Data.spells.wrathfulFaerie.duration * TRB.Data.character.torghast.dreamspunMushroomsModifier)
						end
						TRB.Data.snapshotData.targetData.wrathfulFaerieGuid = destGUID
					-- We're not doing much in these case because it could have been moved or refreshed via SWP on a new target.
					--elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
					--elseif type == "SPELL_AURA_REFRESH" then -- Refreshed buff
					end	
				elseif TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerie.energizeId and type == "SPELL_ENERGIZE" then
					TRB.Data.snapshotData.wrathfulFaerie.main.procTime = currentTime
				elseif TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerieFermata.id then
					if type == "SPELL_AURA_APPLIED" then -- Gained buff
						if TRB.Data.snapshotData.wrathfulFaerie.fermata.isActive == false or TRB.Data.snapshotData.targetData.wrathfulFaerieFermataGuid ~= destGUID then
							TRB.Data.snapshotData.wrathfulFaerie.fermata.isActive = true
							local duration = TRB.Data.spells.wrathfulFaerieFermata.conduitRanks[TRB.Functions.GetSoulbindRank(TRB.Data.spells.wrathfulFaerieFermata.conduitId)] * TRB.Data.character.torghast.dreamspunMushroomsModifier
							TRB.Data.snapshotData.wrathfulFaerie.fermata.endTime = currentTime + duration
						end
						TRB.Data.snapshotData.targetData.wrathfulFaerieFermataGuid = destGUID
					-- We're not doing much in these case because it could have been moved or refreshed via SWP on a new target.
					--elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
					--elseif type == "SPELL_AURA_REFRESH" then -- Refreshed buff
					end
				elseif TRB.Data.settings.priest.shadow.wrathfulFaerie.enabled and spellId == TRB.Data.spells.wrathfulFaerieFermata.energizeId and type == "SPELL_ENERGIZE" then
					TRB.Data.snapshotData.wrathfulFaerie.fermata.procTime = currentTime
				elseif type == "SPELL_SUMMON" and TRB.Data.settings.priest.shadow.voidTendrilTracker and (spellId == TRB.Data.spells.eternalCallToTheVoid_Tendril.id or spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.id) then
					InitializeVoidTendril(destGUID)
					if spellId == TRB.Data.spells.eternalCallToTheVoid_Tendril.id then
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].type = "Tendril"
					elseif spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.id then
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].type = "Lasher"
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].targetsHit = 0
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].hasStruckTargets = true
					end

					TRB.Data.snapshotData.eternalCallToTheVoid.numberActive = TRB.Data.snapshotData.eternalCallToTheVoid.numberActive + 1
					TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining = TRB.Data.snapshotData.eternalCallToTheVoid.maxTicksRemaining + TRB.Data.spells.lashOfInsanity_Tendril.ticks
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].startTime = currentTime
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[destGUID].tickTime = currentTime
				end
			elseif TRB.Data.settings.priest.shadow.voidTendrilTracker and (spellId == TRB.Data.spells.eternalCallToTheVoid_Tendril.idTick or spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.idTick) and CheckVoidTendrilExists(sourceGUID) then
				if spellId == TRB.Data.spells.eternalCallToTheVoid_Lasher.idTick and type == "SPELL_DAMAGE" then
					if currentTime > (TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].tickTime + 0.1) then --This is a new tick
						TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].targetsHit = 0
					end
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].targetsHit = TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].targetsHit + 1
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].tickTime = currentTime					
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].hasStruckTargets = true
				else
					TRB.Data.snapshotData.eternalCallToTheVoid.voidTendrils[sourceGUID].tickTime = currentTime
				end
			end
			
			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				TRB.Functions.RemoveTarget(destGUID)
				RefreshTargetTracking()

				if destGUID == TRB.Data.snapshotData.targetData.wrathfulFaerieGuid then
					TRB.Data.snapshotData.targetData.wrathfulFaerieGuid = nil
				end
				triggerUpdate = true
			end
				
			if UnitIsDeadOrGhost("player") then -- We died/are dead go ahead and purge the list
			--if UnitIsDeadOrGhost("player") or not UnitAffectingCombat("player") or event == "PLAYER_REGEN_ENABLED" then -- We died, or, exited combat, go ahead and purge the list
				TargetsCleanup(true)
				triggerUpdate = true
			end
			
			if s2mDeath then
				if TRB.Data.settings.priest.shadow.audio.s2mDeath.enabled then
					PlaySoundFile(TRB.Data.settings.priest.shadow.audio.s2mDeath.sound, TRB.Data.settings.core.audio.channel.channel)
				end
				TRB.Data.snapshotData.voidform.s2m.startTime = nil
				TRB.Data.snapshotData.voidform.s2m.active = false	
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
		if classIndex == 5 then
			if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true
					local settings = TRB.Options.Priest.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.priest.shadow)
					TRB.Functions.IsTtdActive()		
					FillSpellData()
					ConstructResourceBar()
					TRB.Options.Priest.ConstructOptionsPanel()

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
					
			if TRB.Details.addonData.registered == true and event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
				EventRegistration()
				TRB.Functions.HideResourceBar()
			end
		end
	end)
end

