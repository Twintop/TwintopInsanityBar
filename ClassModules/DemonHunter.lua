local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 12 then --Only do this if we're on a DemonHunter!
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
		havoc = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
		vengeance = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
	}

	local function FillSpecializationCache()
		-- Havoc
		specCache.havoc.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0,
				burningHatred = 0,
				tacticalRetreat = 0
			},
			dots = {
			},
			burningHatred = {
				fury = 0,
				ticks = 0
			},
			tacticalRetreat = {
				fury = 0,
				ticks = 0
			}
		}

		specCache.havoc.character = {
			guid = UnitGUID("player"),
			specId = 1,
			maxResource = 120,
			effects = {
			},
			items = {
			}
		}

		specCache.havoc.spells = {
			--Demon Hunter Class Baseline Abilities
			immolationAura = {
				id = 258920,
				name = "",
				icon = "",
				resource = 20,
				cooldown = 30,
				isTalent = false,
				baseline = true
			},
			immolationAura1 = {
				id = 427912,
				name = "",
				icon = "",
			},
			immolationAura2 = {
				id = 427913,
				name = "",
				icon = "",
			},
			immolationAura3 = {
				id = 427914,
				name = "",
				icon = "",
			},
			immolationAura4 = {
				id = 427915,
				name = "",
				icon = "",
			},
			immolationAura5 = {
				id = 427916,
				name = "",
				icon = "",
			},
			immolationAura6 = {
				id = 427917,
				name = "",
				icon = "",
			},
			metamorphosis = {
				id = 162264,
				name = "",
				icon = "",
				isTalent = false,
				baseline = true
			},
			throwGlaive = {
				id = 185123,
				name = "",
				icon = "",
				texture = "",
				resource = -25,
				thresholdId = 9,
				settingKey = "throwGlaive",
				hasCooldown = true,
				hasCharges = true,
				isSnowflake = true,
				isTalent = false,
				baseline = true
			},

			--Havoc Baseline Abilities
			bladeDance = {
				id = 188499,
				name = "",
				icon = "",
				resource = -35,
				cooldown = 9,
				texture = "",
				thresholdId = 2,
				settingKey = "bladeDance",
				hasCooldown = true,
				demonForm = false,
				isTalent = false,
				baseline = true
			},
			chaosStrike = {
			   id = 162794,
			   name = "",
			   icon = "",
			   resource = -40,
			   texture = "",
			   thresholdId = 4,
			   settingKey = "chaosStrike",
			   hasCooldown = false,
			   isSnowflake = true,
			   demonForm = false,
			   isTalent = false,
			   baseline = true
			},
			annihilation = {
				id = 201427,
				name = "",
				icon = "",
				resource = -40,
				texture = "",
				thresholdId = 1,
				settingKey = "annihilation",
				hasCooldown = false,
				demonForm = true,
				isTalent = false,
				baseline = true
			},
			deathSweep = {
				id = 210152,
				name = "",
				icon = "",
				resource = -35,
				cooldown = 9,
				texture = "",
				thresholdId = 5,
				settingKey = "deathSweep",
				hasCooldown = true,
				demonForm = true,
				isTalent = false,
				baseline = true
			},

			-- Demon Hunter Talent Abilities
			chaosNova = {
			   id = 179057,
			   name = "",
			   icon = "",
			   resource = -25,
			   texture = "",
			   thresholdId = 3,
			   settingKey = "chaosNova",
			   hasCooldown = true,
			   isTalent = true
			},

			-- Havoc Talent Abilities
			eyeBeam = {
				id = 198013,
				name = "",
				icon = "",
				resource = -30,
				duration = 2,
				texture = "",
				thresholdId = 6,
				settingKey = "eyeBeam",
				hasCooldown = true,
				isTalent = true
			},
			burningHatred = {
				id = 258922,
				talentId = 320374,
				name = "",
				icon = "",
				resourcePerTick = 4,
				tickRate = 1,
				hasTicks = true,
				duration = 12,
				isTalent = true
			},
			furiousThrows = {
				id = 393029,
				name = "",
				icon = "",
				resource = -25,
				isTalent = true
			},
			felfireHeart = { --TODO: figure out how this plays with Burning Hatred
				id = 388109,
				name = "",
				icon = "",
				duration = 4, -- These don't match what's seen on the PTR, should be 2,
				ticks = 4, --2,
				isTalent = true
			},
			felEruption = {
				id = 211881,
				name = "",
				icon = "",
				resource = -10,
				cooldown = 30,
				texture = "",
				thresholdId = 8,
				settingKey = "felEruption",
				hasCooldown = true,
				isTalent = false,
				baseline = true
			},
			blindFury = {
				id = 203550,
				name = "",
				icon = "",
				durationModifier = 1.5,
				tickRate = 0.1,
				resource = 4,
				isHasted = true,
				isTalent = true
			},
			glaiveTempest = {
				id = 342817,
				name = "",
				icon = "",
				resource = -30,
				cooldown = 20,
				texture = "",
				thresholdId = 7,
				settingKey = "glaiveTempest",
				hasCooldown = true,
				isTalent = true
			},

			demonsBite = {
				id = 162243,
				name = "",
				icon = "",
				resource = 20,
				resourceMax = 30
			},
			demonicAppetite = {
				id = 206478,
				name = "",
				icon = "",
				resource = 30
			},
			felBlade = {
				id = 232893,
				name = "",
				icon = "",
				resource = 40
			},
			unboundChaos = {
				id = 347462,
				name = "",
				icon = "",
				duration = 20
			},
			firstBlood = {
				id = 206416,
				name = "",
				icon = "",
				resourceAdjustment = -20
			},
			tacticalRetreat = {
				id = 389890,
				name = "",
				icon = "",
				resourcePerTick = 8,
				tickRate = 1,
				hasTicks = true,
				isTalent = true
			},
			momentum = {
				id = 206476,
				name = "",
				icon = "",
			},
			chaosTheory = {
				id = 390195,
				name = "",
				icon = ""
			},
			felBarrage = {
				id = 258925,
				name = "",
				icon = "",
				resource = -10,
				cooldown = 90,
				texture = "",
				thresholdId = 10,
				settingKey = "felBarrage",
				hasCooldown = true,
				isTalent = true
			}
		}

		specCache.havoc.snapshotData.audio = {
			overcapCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.bladeDance.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.bladeDance)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.chaosNova.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.chaosNova)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.deathSweep.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.deathSweep)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.eyeBeam.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.eyeBeam)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.glaiveTempest.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.glaiveTempest)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.felEruption.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.felEruption)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.metamorphosis.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.metamorphosis)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.immolationAura.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.immolationAura)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.immolationAura1.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.immolationAura1)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.immolationAura2.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.immolationAura2)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.immolationAura3.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.immolationAura3)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.immolationAura4.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.immolationAura4)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.immolationAura5.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.immolationAura5)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.immolationAura6.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.immolationAura6)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.unboundChaos.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.unboundChaos)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.throwGlaive.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.throwGlaive)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.tacticalRetreat.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.tacticalRetreat)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.chaosTheory.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.chaosTheory)
		---@type TRB.Classes.Snapshot
		specCache.havoc.snapshotData.snapshots[specCache.havoc.spells.felBarrage.id] = TRB.Classes.Snapshot:New(specCache.havoc.spells.felBarrage)
	
		-- vengeance
		specCache.vengeance.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0,
				burningHatred = 0,
				tacticalRetreat = 0
			},
			dots = {
			},
			burningHatred = {
				fury = 0,
				ticks = 0
			},
			tacticalRetreat = {
				fury = 0,
				ticks = 0
			}
		}

		specCache.vengeance.character = {
			guid = UnitGUID("player"),
			specId = 2,
			maxResource = 120,
			effects = {
			},
			items = {
			}
		}

		specCache.vengeance.spells = {
			--Resource
			soulFragments = {
				id = 203981,
				name = "",
				icon = "",
				maxResource = 5
			},

			--Demon Hunter Class Baseline Abilities
			immolationAura = {
				id = 258920,
				name = "",
				icon = "",
				resourcePerTick = 2,
				tickRate = 1,
				hasTicks = true,
				isTalent = false,
				baseline = true
			},
			metamorphosis = {
				id = 187827,
				name = "",
				icon = "",
				isTalent = false,
				baseline = true
			},

			--Vengeance Baseline Abilities
			soulCleave = {
				id = 228477,
				name = "",
				icon = "",
				resource = -30,
				texture = "",
				thresholdId = 1,
				settingKey = "soulCleave",
				isTalent = false,
				baseline = true,
				isSnowflake = true
			},

			-- Demon Hunter Talent Abilities
			chaosNova = {
				id = 179057,
				name = "",
				icon = "",
				resource = -25,
				texture = "",
				thresholdId = 2,
				settingKey = "chaosNova",
				hasCooldown = true,
				isTalent = true
			},

			-- Vengeance Talent Abilities
			felDevastation = {
				id = 212084,
				name = "",
				icon = "",
				resource = -50,
				texture = "",
				thresholdId = 3,
				settingKey = "felDevastation",
				hasCooldown = true,
				isTalent = true
			},
			spiritBomb = {
				id = 247454,
				name = "",
				icon = "",
				resource = -40,
				texture = "",
				thresholdId = 4,
				settingKey = "spiritBomb",
				comboPoints = true,
				isTalent = true,
				isSnowflake = true
			},
			soulFurnace = {
				id = 391172,
				name = "",
				icon = "",
				isTalent = true
			}
		}

		specCache.vengeance.snapshotData.audio = {
			overcapCue = false
		}
		---@type TRB.Classes.Snapshot
		specCache.vengeance.snapshotData.snapshots[specCache.vengeance.spells.chaosNova.id] = TRB.Classes.Snapshot:New(specCache.vengeance.spells.chaosNova)
		---@type TRB.Classes.Snapshot
		specCache.vengeance.snapshotData.snapshots[specCache.vengeance.spells.felDevastation.id] = TRB.Classes.Snapshot:New(specCache.vengeance.spells.felDevastation)
		---@type TRB.Classes.Snapshot
		specCache.vengeance.snapshotData.snapshots[specCache.vengeance.spells.metamorphosis.id] = TRB.Classes.Snapshot:New(specCache.vengeance.spells.metamorphosis)
		---@type TRB.Classes.Snapshot
		specCache.vengeance.snapshotData.snapshots[specCache.vengeance.spells.immolationAura.id] = TRB.Classes.Snapshot:New(specCache.vengeance.spells.immolationAura)
		---@type TRB.Classes.Snapshot
		specCache.vengeance.snapshotData.snapshots[specCache.vengeance.spells.soulFurnace.id] = TRB.Classes.Snapshot:New(specCache.vengeance.spells.soulFurnace)
	end

	local function Setup_Havoc()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "demonhunter", "havoc")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.havoc)
	end

	local function FillSpellData_Havoc()
		Setup_Havoc()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.havoc.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.havoc.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

			{ variable = "#annihilation", icon = spells.annihilation.icon, description = spells.annihilation.name, printInSettings = true },
			{ variable = "#bladeDance", icon = spells.bladeDance.icon, description = spells.bladeDance.name, printInSettings = true },
			{ variable = "#blindFury", icon = spells.blindFury.icon, description = spells.blindFury.name, printInSettings = true },
			{ variable = "#bh", icon = spells.burningHatred.icon, description = spells.burningHatred.name, printInSettings = false },
			{ variable = "#burningHatred", icon = spells.burningHatred.icon, description = spells.burningHatred.name, printInSettings = true },
			{ variable = "#chaosNova", icon = spells.chaosNova.icon, description = spells.chaosNova.name, printInSettings = true },
			{ variable = "#chaosStrike", icon = spells.chaosStrike.icon, description = spells.chaosStrike.name, printInSettings = true },
			{ variable = "#deathSweep", icon = spells.deathSweep.icon, description = spells.deathSweep.name, printInSettings = true },
			{ variable = "#demonicAppetite", icon = spells.demonicAppetite.icon, description = spells.demonicAppetite.name, printInSettings = true },
			{ variable = "#demonsBite", icon = spells.demonsBite.icon, description = spells.demonsBite.name, printInSettings = true },
			{ variable = "#eyeBeam", icon = spells.eyeBeam.icon, description = spells.eyeBeam.name, printInSettings = true },
			{ variable = "#felBarrage", icon = spells.felBarrage.icon, description = spells.felBarrage.name, printInSettings = true },
			{ variable = "#felBlade", icon = spells.felBlade.icon, description = spells.felBlade.name, printInSettings = true },
			{ variable = "#felEruption", icon = spells.felEruption.icon, description = spells.felEruption.name, printInSettings = true },
			{ variable = "#firstBlood", icon = spells.firstBlood.icon, description = spells.firstBlood.name, printInSettings = true },
			{ variable = "#glaiveTempest", icon = spells.glaiveTempest.icon, description = spells.glaiveTempest.name, printInSettings = true },
			{ variable = "#immolationAura", icon = spells.immolationAura.icon, description = spells.immolationAura.name, printInSettings = true },
			{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },			
			{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
			{ variable = "#momentum", icon = spells.momentum.icon, description = spells.momentum.name, printInSettings = true },
			{ variable = "#tacticalRetreat", icon = spells.tacticalRetreat.icon, description = spells.tacticalRetreat.name, printInSettings = true },
			{ variable = "#unboundChaos", icon = spells.unboundChaos.icon, description = spells.unboundChaos.name, printInSettings = true },
		}
		specCache.havoc.barTextVariables.values = {
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
			
			{ variable = "$fury", description = L["DemonHunterHavocBarTextVariable_fury"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$furyMax", description = L["DemonHunterHavocBarTextVariable_furyMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["DemonHunterHavocBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["DemonHunterHavocBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$furyPlusCasting", description = L["DemonHunterHavocBarTextVariable_furyPlusCasting"], printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$furyPlusPassive", description = L["DemonHunterHavocBarTextVariable_furyPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$furyTotal", description = L["DemonHunterHavocBarTextVariable_furyTotal"], printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },   		   
			{ variable = "$metaTime", description = L["DemonHunterHavocBarTextVariable_metaTime"], printInSettings = true, color = false },
			{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
			{ variable = "$bhFury", description = L["DemonHunterHavocBarTextVariable_bhFury"], printInSettings = true, color = false },
			{ variable = "$bhTicks", description = "", printInSettings = false, color = false },
			{ variable = "$iaTicks", description = L["DemonHunterHavocBarTextVariable_iaTicks"], printInSettings = true, color = false },
			{ variable = "$bhTime", description = "", printInSettings = false, color = false },
			{ variable = "$iaTime", description = L["DemonHunterHavocBarTextVariable_iaTime"], printInSettings = true, color = false },
			{ variable = "$ucTime", description = L["DemonHunterHavocBarTextVariable_ucTime"], printInSettings = true, color = false },
			{ variable = "$tacticalRetreatFury", description = L["DemonHunterHavocBarTextVariable_tacticalRetreatFury"], printInSettings = true, color = false },
			{ variable = "$tacticalRetreatTicks", description = L["DemonHunterHavocBarTextVariable_tacticalRetreatTicks"], printInSettings = true, color = false },
			{ variable = "$tacticalRetreatTime", description = L["DemonHunterHavocBarTextVariable_tacticalRetreatTime"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}

		specCache.havoc.spells = spells
	end

	local function Setup_Vengeance()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "demonhunter", "vengeance")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.vengeance)
	end

	local function FillSpellData_Vengeance()
		Setup_Vengeance()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.vengeance.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.vengeance.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

			{ variable = "#immolationAura", icon = spells.immolationAura.icon, description = spells.immolationAura.name, printInSettings = true },
			{ variable = "#ia", icon = spells.immolationAura.icon, description = spells.immolationAura.name, printInSettings = false },
			{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },			
			{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
			{ variable = "#soulFragments", icon = spells.soulFragments.icon, description = spells.soulFragments.name, printInSettings = true },
		}
		specCache.vengeance.barTextVariables.values = {
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
			
			{ variable = "$fury", description = L["DemonHunterVengeanceBarTextVariable_fury"], printInSettings = true, color = false },
			{ variable = "$resource", description = "", printInSettings = false, color = false },
			{ variable = "$furyMax", description = L["DemonHunterVengeanceBarTextVariable_furyMax"], printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
			{ variable = "$casting", description = L["DemonHunterVengeanceBarTextVariable_casting"], printInSettings = true, color = false },
			{ variable = "$passive", description = L["DemonHunterVengeanceBarTextVariable_passive"], printInSettings = true, color = false },
			{ variable = "$furyPlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
			{ variable = "$furyPlusPassive", description = L["DemonHunterVengeanceBarTextVariable_furyPlusPassive"], printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
			{ variable = "$furyTotal", description = L["DemonHunterVengeanceBarTextVariable_furyTotal"], printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },   
		   
			{ variable = "$soulFragments", description = L["DemonHunterVengeanceBarTextVariable_soulFragments"], printInSettings = true, color = false },
			{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
			{ variable = "$soulFragmentsMax", description = L["DemonHunterVengeanceBarTextVariable_soulFragmentsMax"], printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

			{ variable = "$metaTime", description = L["DemonHunterVengeanceBarTextVariable_metaTime"], printInSettings = true, color = false },
			{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },

			{ variable = "$iaFury", description = L["DemonHunterVengeanceBarTextVariable_iaFury"], printInSettings = true, color = false },
			{ variable = "$iaTicks", description = L["DemonHunterVengeanceBarTextVariable_iaTicks"], printInSettings = true, color = false },
			{ variable = "$iaTime", description = L["DemonHunterVengeanceBarTextVariable_iaTime"], printInSettings = true, color = false },

			{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
		}

		specCache.vengeance.spells = spells
	end

	local function CalculateAbilityResourceValue(resource)
		local modifier = 1.0

		return resource * modifier
	end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
	end

	local function TargetsCleanup(clearAll)
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshotData.targetData
		targetData:Cleanup(clearAll)
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		local entries = TRB.Functions.Table:Length(TRB.Frames.resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end
		end

		for k, v in pairs(TRB.Data.spells) do
			local spell = TRB.Data.spells[k]
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

		if specId == 1 then
			TRB.Frames.resource2ContainerFrame:Hide()
		elseif specId == 2 then
			TRB.Frames.resource2ContainerFrame:Show()
		end

		TRB.Functions.Class:CheckCharacter()
		TRB.Functions.Bar:Construct(settings)
		TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
	end

	local function RefreshLookupData_Havoc()
		local currentTime = GetTime()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local specSettings = TRB.Data.settings.demonhunter.havoc
		local normalizedResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
		--Spec specific implementation

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentFuryColor = specSettings.colors.text.current
		local castingFuryColor = specSettings.colors.text.casting
		
		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then
				currentFuryColor = specSettings.colors.text.overcap
			elseif specSettings.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(spells) do
					local spell = spells[k]
					if spell ~= nil and spell.resource ~= nil and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell.resource >= normalizedResource then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFuryColor = specSettings.colors.text.overThreshold
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingFuryColor = specSettings.colors.text.spending
		end

		--$metamorphosisTime
		local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
		local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)

		--$unboundChaosTime
		local _unboundChaosTime = snapshotData.snapshots[spells.unboundChaos.id].buff:GetRemainingTime(currentTime)
		local unboundChaosTime = TRB.Functions.BarText:TimerPrecision(_unboundChaosTime)

		--$bhFury
		local bhFury = snapshotData.snapshots[spells.immolationAura.id].buff.resource + snapshotData.snapshots[spells.immolationAura1.id].buff.resource + snapshotData.snapshots[spells.immolationAura2.id].buff.resource + snapshotData.snapshots[spells.immolationAura3.id].buff.resource + snapshotData.snapshots[spells.immolationAura4.id].buff.resource + snapshotData.snapshots[spells.immolationAura5.id].buff.resource + snapshotData.snapshots[spells.immolationAura6.id].buff.resource

		--$bhTicks and $iaTicks
		local bhTicks = snapshotData.snapshots[spells.immolationAura.id].buff.ticks + snapshotData.snapshots[spells.immolationAura1.id].buff.ticks + snapshotData.snapshots[spells.immolationAura2.id].buff.ticks + snapshotData.snapshots[spells.immolationAura3.id].buff.ticks + snapshotData.snapshots[spells.immolationAura4.id].buff.ticks + snapshotData.snapshots[spells.immolationAura5.id].buff.ticks + snapshotData.snapshots[spells.immolationAura6.id].buff.ticks

		--$bhTime and $iaTime
		local _bhTime = math.max(snapshotData.snapshots[spells.immolationAura.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura1.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura2.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura3.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura4.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura5.id].buff:GetRemainingTime(currentTime), snapshotData.snapshots[spells.immolationAura6.id].buff:GetRemainingTime(currentTime))
		local bhTime = TRB.Functions.BarText:TimerPrecision(_bhTime)

		--$tacticalRetreatFury
		local tacticalRetreatFury = snapshotData.snapshots[spells.tacticalRetreat.id].buff.resource

		--$tacticalRetreatTicks
		local tacticalRetreatTicks = snapshotData.snapshots[spells.tacticalRetreat.id].buff.ticks

		--$tacticalRetreatTime
		local _tacticalRetreatTime = snapshotData.snapshots[spells.tacticalRetreat.id].buff:GetRemainingTime(currentTime)
		local tacticalRetreatTime = TRB.Functions.BarText:TimerPrecision(_tacticalRetreatTime)

		--$fury
		local resourcePrecision = specSettings.resourcePrecision or 0
		local currentFury = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(normalizedResource, resourcePrecision, "floor"))
		--$casting
		local _castingFury = snapshotData.casting.resourceFinal
		local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
		--$passive
		local _passiveFury = bhFury + tacticalRetreatFury
		local passiveFury = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveFury, resourcePrecision, "floor"))
		
		--$furyTotal
		local _furyTotal = math.min(_passiveFury + snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
		local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyTotal, resourcePrecision, "floor"))
		--$furyPlusCasting
		local _furyPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
		local furyPlusCasting = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_furyPlusCasting, resourcePrecision, "floor"))
		--$furyPlusPassive
		local _furyPlusPassive = math.min(_passiveFury + normalizedResource, TRB.Data.character.maxResource)
		local furyPlusPassive = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyPlusPassive, resourcePrecision, "floor"))
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedResource
		Global_TwintopResourceBar.resource.passive = _passiveFury
		Global_TwintopResourceBar.resource.burningHatred = bhFury
		Global_TwintopResourceBar.resource.tacticalRetreat = tacticalRetreatFury
		Global_TwintopResourceBar.burningHatred = {
			fury = bhFury,
			ticks = bhTicks,
			time = bhTime
		}
		Global_TwintopResourceBar.tacticalRetreat = {
			fury = tacticalRetreatFury,
			ticks = tacticalRetreatTicks,
			time = tacticalRetreatTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#annihilation"] = spells.annihilation.icon
		lookup["#bladeDance"] = spells.bladeDance.icon
		lookup["#blindFury"] = spells.blindFury.icon
		lookup["#bh"] = spells.burningHatred.icon
		lookup["#burningHatred"] = spells.burningHatred.icon
		lookup["#chaosNova"] = spells.chaosNova.icon
		lookup["#chaosStrike"] = spells.chaosStrike.icon
		lookup["#deathSweep"] = spells.deathSweep.icon
		lookup["#demonicAppetite"] = spells.demonicAppetite.icon
		lookup["#demonsBite"] = spells.demonsBite.icon
		lookup["#eyeBeam"] = spells.eyeBeam.icon
		lookup["#felBarrage"] = spells.felBarrage.icon
		lookup["#felBlade"] = spells.felBlade.icon
		lookup["#felEruption"] = spells.felEruption.icon
		lookup["#firstBlood"] = spells.firstBlood.icon
		lookup["#glaiveTempest"] = spells.glaiveTempest.icon
		lookup["#immolationAura"] = spells.immolationAura.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#momentum"] = spells.momentum.icon
		lookup["#tacticalRetreat"] = spells.tacticalRetreat.icon
		lookup["#unboundChaos"] = spells.unboundChaos.icon
		lookup["$metaTime"] = metamorphosisTime
		lookup["$metamorphosisTime"] = metamorphosisTime
		lookup["$bhFury"] = bhFury
		lookup["$bhTicks"] = bhTicks
		lookup["$iaTicks"] = bhTicks
		lookup["$iaTime"] = bhTime
		lookup["$bhTime"] = bhTime
		lookup["$tacticalRetreatFury"] = tacticalRetreatFury
		lookup["$tacticalRetreatTicks"] = tacticalRetreatTicks
		lookup["$tacticalRetreatTime"] = _tacticalRetreatTime
		lookup["$ucTime"] = unboundChaosTime
		lookup["$furyPlusCasting"] = furyPlusCasting
		lookup["$furyTotal"] = furyTotal
		lookup["$furyMax"] = TRB.Data.character.maxResource
		lookup["$fury"] = currentFury
		lookup["$resourcePlusCasting"] = furyPlusCasting
		lookup["$furyPlusCasting"] = furyPlusCasting
		lookup["$resourcePlusPassive"] = furyPlusPassive
		lookup["$furyPlusPassive"] = furyPlusPassive
		lookup["$resourceTotal"] = furyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentFury
		lookup["$casting"] = castingFury
		lookup["$passive"] = passiveFury
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$furyOvercap"] = overcap
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$metaTime"] = _metamorphosisTime
		lookupLogic["$metamorphosisTime"] = _metamorphosisTime
		lookupLogic["$bhFury"] = bhFury
		lookupLogic["$bhTicks"] = bhTicks
		lookupLogic["$iaTicks"] = bhTicks
		lookupLogic["$iaTime"] = _bhTime
		lookupLogic["$bhTime"] = _bhTime
		lookupLogic["$tacticalRetreatFury"] = tacticalRetreatFury
		lookupLogic["$tacticalRetreatTicks"] = tacticalRetreatTicks
		lookupLogic["$tacticalRetreatTime"] = _tacticalRetreatTime
		lookupLogic["$ucTime"] = _unboundChaosTime
		lookupLogic["$furyPlusCasting"] = _furyPlusCasting
		lookupLogic["$furyTotal"] = _furyTotal
		lookupLogic["$furyMax"] = TRB.Data.character.maxResource
		lookupLogic["$fury"] = normalizedResource
		lookupLogic["$resourcePlusCasting"] = _furyPlusCasting
		lookupLogic["$furyPlusCasting"] = _furyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _furyPlusPassive
		lookupLogic["$furyPlusPassive"] = _furyPlusPassive
		lookupLogic["$resourceTotal"] = _furyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedResource
		lookupLogic["$casting"] = _castingFury
		lookupLogic["$passive"] = _passiveFury
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$furyOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Vengeance()
		local currentTime = GetTime()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local specSettings = TRB.Data.settings.demonhunter.vengeance
		local normalizedResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
		--Spec specific implementation

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentFuryColor = specSettings.colors.text.current
		local castingFuryColor = specSettings.colors.text.casting
		
		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if specSettings.colors.text.overcapEnabled and overcap then
				currentFuryColor = specSettings.colors.text.overcap
			elseif specSettings.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(spells) do
					local spell = spells[k]
					if spell ~= nil and spell.resource ~= nil and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell.resource >= normalizedResource then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFuryColor = specSettings.colors.text.overThreshold
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingFuryColor = specSettings.colors.text.spending
		end

		--$metamorphosisTime
		local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
		local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)

		--$iaFury
		local iaFury = snapshotData.snapshots[spells.immolationAura.id].buff.resource

		--$iaTicks and $iaTicks
		local iaTicks = snapshotData.snapshots[spells.immolationAura.id].buff.ticks

		--$iaTime and $iaTime
		local _iaTime = snapshotData.snapshots[spells.immolationAura.id].buff:GetRemainingTime(currentTime)
		local iaTime = TRB.Functions.BarText:TimerPrecision(_iaTime)

		--$fury
		local resourcePrecision = specSettings.resourcePrecision or 0
		local currentFury = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(normalizedResource, resourcePrecision, "floor"))
		--$casting
		local _castingFury = snapshotData.casting.resourceFinal
		local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
		--$passive
		local _passiveFury = iaFury
		local passiveFury = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveFury, resourcePrecision, "floor"))
		
		--$furyTotal
		local _furyTotal = math.min(_passiveFury + snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
		local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyTotal, resourcePrecision, "floor"))
		--$furyPlusCasting
		local _furyPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedResource, TRB.Data.character.maxResource)
		local furyPlusCasting = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_furyPlusCasting, resourcePrecision, "floor"))
		--$furyPlusPassive
		local _furyPlusPassive = math.min(_passiveFury + normalizedResource, TRB.Data.character.maxResource)
		local furyPlusPassive = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyPlusPassive, resourcePrecision, "floor"))
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedResource
		Global_TwintopResourceBar.resource.passive = _passiveFury
		Global_TwintopResourceBar.resource.immolationAura = iaFury
		Global_TwintopResourceBar.immolationAura = {
			fury = iaFury,
			ticks = iaTicks,
			time = iaTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#ia"] = spells.immolationAura.icon
		lookup["#immolationAura"] = spells.immolationAura.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#soulFragments"] = spells.soulFragments.icon
		lookup["$metaTime"] = metamorphosisTime
		lookup["$metamorphosisTime"] = metamorphosisTime
		lookup["$iaFury"] = iaFury
		lookup["$iaTicks"] = iaTicks
		lookup["$iaTime"] = iaTime
		lookup["$furyPlusCasting"] = furyPlusCasting
		lookup["$furyTotal"] = furyTotal
		lookup["$furyMax"] = TRB.Data.character.maxResource
		lookup["$fury"] = currentFury
		lookup["$resourcePlusCasting"] = furyPlusCasting
		lookup["$furyPlusCasting"] = furyPlusCasting
		lookup["$resourcePlusPassive"] = furyPlusPassive
		lookup["$furyPlusPassive"] = furyPlusPassive
		lookup["$resourceTotal"] = furyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentFury
		lookup["$soulFragments"] = snapshotData.attributes.resource2
		lookup["$comboPoints"] = snapshotData.attributes.resource2
		lookup["$soulFragmentsMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$casting"] = castingFury
		lookup["$passive"] = passiveFury
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$furyOvercap"] = overcap
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$metaTime"] = _metamorphosisTime
		lookupLogic["$metamorphosisTime"] = _metamorphosisTime
		lookupLogic["$iaFury"] = iaFury
		lookupLogic["$iaTicks"] = iaTicks
		lookupLogic["$iaTime"] = _iaTime
		lookupLogic["$furyPlusCasting"] = _furyPlusCasting
		lookupLogic["$furyTotal"] = _furyTotal
		lookupLogic["$furyMax"] = TRB.Data.character.maxResource
		lookupLogic["$fury"] = normalizedResource
		lookupLogic["$resourcePlusCasting"] = _furyPlusCasting
		lookupLogic["$furyPlusCasting"] = _furyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _furyPlusPassive
		lookupLogic["$furyPlusPassive"] = _furyPlusPassive
		lookupLogic["$resourceTotal"] = _furyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedResource
		lookupLogic["$soulFragments"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$soulFragmentsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$casting"] = _castingFury
		lookupLogic["$passive"] = _passiveFury
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$furyOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
		TRB.Data.snapshotData.casting.startTime = currentTime
		TRB.Data.snapshotData.casting.resourceRaw = spell.resource
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.resource)
		TRB.Data.snapshotData.casting.spellId = spell.id
		TRB.Data.snapshotData.casting.icon = spell.icon
	end

	local function CastingSpell()
		local spells = TRB.Data.spells
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.eyeBeam.id and talents:IsTalentActive(TRB.Data.spells.blindFury) then
						local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.eyeBeam.id
						--TRB.Data.snapshotData.casting.startTime = currentChannelStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentChannelEndTime / 1000
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.eyeBeam.icon
						local remainingTime = TRB.Data.snapshotData.casting.endTime - currentTime
						--TODO: use SnapshotBuff:UpdateTicks() instead?
						local ticks = TRB.Functions.Number:RoundTo(remainingTime / (TRB.Data.spells.blindFury.tickRate * (gcd / 1.5)), 0, "ceil", true)
						local resource = ticks * TRB.Data.spells.blindFury.resource
						TRB.Data.snapshotData.casting.resourceRaw = resource
						TRB.Data.snapshotData.casting.resourceFinal = resource
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
						--See Priest implementation for handling channeled spells
					end
					return true
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			elseif specId == 2 then
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
	end

	local function UpdateSnapshot_Havoc()
		local currentTime = GetTime()
		UpdateSnapshot()
		
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local _
		snapshotData.snapshots[spells.chaosNova.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.felEruption.id].buff:GetRemainingTime(currentTime)
		snapshotData.snapshots[spells.throwGlaive.id].buff:GetRemainingTime(currentTime)
		
		if talents:IsTalentActive(TRB.Data.spells.burningHatred) then
			snapshotData.snapshots[spells.immolationAura.id].buff:UpdateTicks(currentTime)
			snapshotData.snapshots[spells.immolationAura1.id].buff:UpdateTicks(currentTime)
			snapshotData.snapshots[spells.immolationAura2.id].buff:UpdateTicks(currentTime)
			snapshotData.snapshots[spells.immolationAura3.id].buff:UpdateTicks(currentTime)
			snapshotData.snapshots[spells.immolationAura4.id].buff:UpdateTicks(currentTime)
			snapshotData.snapshots[spells.immolationAura5.id].buff:UpdateTicks(currentTime)
			snapshotData.snapshots[spells.immolationAura6.id].buff:UpdateTicks(currentTime)
		else
			snapshotData.snapshots[spells.immolationAura.id].buff:GetRemainingTime(currentTime)
			snapshotData.snapshots[spells.immolationAura1.id].buff:GetRemainingTime(currentTime)
			snapshotData.snapshots[spells.immolationAura2.id].buff:GetRemainingTime(currentTime)
			snapshotData.snapshots[spells.immolationAura3.id].buff:GetRemainingTime(currentTime)
			snapshotData.snapshots[spells.immolationAura4.id].buff:GetRemainingTime(currentTime)
			snapshotData.snapshots[spells.immolationAura5.id].buff:GetRemainingTime(currentTime)
			snapshotData.snapshots[spells.immolationAura6.id].buff:GetRemainingTime(currentTime)
		end

		snapshotData.snapshots[spells.tacticalRetreat.id].buff:UpdateTicks(currentTime)

		snapshotData.snapshots[spells.metamorphosis.id].buff:Refresh()

		if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive and 
				snapshotData.snapshots[spells.deathSweep.id].spell.id == spells.bladeDance.id then
			snapshotData.snapshots[spells.bladeDance.id].spell = spells.deathSweep
			snapshotData.snapshots[spells.deathSweep.id].spell = spells.deathSweep
			snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh(true)
			snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh(true)
		elseif not snapshotData.snapshots[spells.metamorphosis.id].buff.isActive and 
			    snapshotData.snapshots[spells.bladeDance.id].spell.id == spells.deathSweep.id then
			snapshotData.snapshots[spells.bladeDance.id].spell = spells.bladeDance
			snapshotData.snapshots[spells.deathSweep.id].spell = spells.bladeDance
			snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh(true)
			snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh(true)
		else
			snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh()
			snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh()
		end

		snapshotData.snapshots[spells.eyeBeam.id].cooldown:Refresh(true)
		snapshotData.snapshots[spells.bladeDance.id].cooldown:Refresh(true)
		snapshotData.snapshots[spells.deathSweep.id].cooldown:Refresh(true)
		snapshotData.snapshots[spells.chaosNova.id].cooldown:Refresh()
		snapshotData.snapshots[spells.glaiveTempest.id].cooldown:Refresh()
		snapshotData.snapshots[spells.throwGlaive.id].cooldown:Refresh()
		snapshotData.snapshots[spells.felBarrage.id].cooldown:Refresh()
	end

	local function UpdateSnapshot_Vengeance()
		local currentTime = GetTime()
		UpdateSnapshot()
		
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local _

		snapshotData.snapshots[spells.immolationAura.id].buff:UpdateTicks(currentTime)
		snapshotData.snapshots[spells.metamorphosis.id].buff:Refresh()

		snapshotData.snapshots[spells.chaosNova.id].cooldown:Refresh()
		snapshotData.snapshots[spells.felDevastation.id].cooldown:Refresh()
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.demonhunter
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if specId == 1 then
			local specSettings = classSettings.havoc
			UpdateSnapshot_Havoc()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local metaTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if snapshotData.snapshots[spells.immolationAura.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura1.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura2.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura3.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura4.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura5.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura6.id].buff.resource > 0 then
							passiveValue = passiveValue + snapshotData.snapshots[spells.immolationAura.id].buff.resource + snapshotData.snapshots[spells.immolationAura1.id].buff.resource + snapshotData.snapshots[spells.immolationAura2.id].buff.resource + snapshotData.snapshots[spells.immolationAura3.id].buff.resource + snapshotData.snapshots[spells.immolationAura4.id].buff.resource + snapshotData.snapshots[spells.immolationAura5.id].buff.resource + snapshotData.snapshots[spells.immolationAura6.id].buff.resource
						end

						if snapshotData.snapshots[spells.tacticalRetreat.id].buff.resource > 0 then
							passiveValue = passiveValue + snapshotData.snapshots[spells.tacticalRetreat.id].buff.resource
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentResource + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					if castingBarValue < currentResource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local resourceAmount = CalculateAbilityResourceValue(spell.resource)

							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							if metaTime > 0 and (spell.demonForm ~= nil and spell.demonForm == false) then
								showThreshold = false
							elseif metaTime == 0 and (spell.demonForm ~= nil and spell.demonForm == true) then
								showThreshold = false
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.throwGlaive.id then
									if talents:IsTalentActive(TRB.Data.spells.furiousThrows) then
										resourceAmount = TRB.Data.spells.furiousThrows.resource
										if snapshotData.snapshots[spells.throwGlaive.id].cooldown.charges == 0 then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									else
										showThreshold = false
									end
								elseif spell.id == TRB.Data.spells.chaosStrike.id or spell.id == TRB.Data.spells.annihilation.id then
									if snapshotData.snapshots[spells.chaosTheory.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.special
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
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

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshotData.snapshots[spell.id], specSettings)
						end
						pairOffset = pairOffset + 3
					end
					
					local barColor = specSettings.colors.bar.base
					if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
						local timeThreshold = 0
						local useEndOfMetamorphosisColor = false

						if specSettings.endOfMetamorphosis.enabled then
							useEndOfMetamorphosisColor = true
							if specSettings.endOfMetamorphosis.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfMetamorphosis.gcdsMax
							elseif specSettings.endOfMetamorphosis.mode == "time" then
								timeThreshold = specSettings.endOfMetamorphosis.timeMax
							end
						end

						if useEndOfMetamorphosisColor and metaTime <= timeThreshold then
							barColor = specSettings.colors.bar.metamorphosisEnding
						else
							barColor = specSettings.colors.bar.metamorphosis
						end
					end

					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true			
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.vengeance
			UpdateSnapshot_Vengeance()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshotData.attributes.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
					local metaTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if snapshotData.snapshots[spells.immolationAura.id].buff.resource then
							passiveValue = passiveValue + snapshotData.snapshots[spells.immolationAura.id].buff.resource
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentResource + snapshotData.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					if castingBarValue < currentResource then --Using a spender
						if -snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.resource ~= nil and spell.resource < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local resourceAmount = CalculateAbilityResourceValue(spell.resource)

							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							if metaTime > 0 and (spell.demonForm ~= nil and spell.demonForm == false) then
								showThreshold = false
							elseif metaTime == 0 and (spell.demonForm ~= nil and spell.demonForm == true) then
								showThreshold = false
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.soulCleave.id or spell.id == TRB.Data.spells.spiritBomb.id then
									if snapshotData.snapshots[spells.soulFurnace.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.special
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
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

							if spell.comboPoints == true and snapshotData.attributes.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshotData.snapshots[spell.id], specSettings)
						end
						pairOffset = pairOffset + 3
					end
					
					local barColor = specSettings.colors.bar.base
					if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
						local timeThreshold = 0
						local useEndOfMetamorphosisColor = false

						if specSettings.endOfMetamorphosis.enabled then
							useEndOfMetamorphosisColor = true
							if specSettings.endOfMetamorphosis.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfMetamorphosis.gcdsMax
							elseif specSettings.endOfMetamorphosis.mode == "time" then
								timeThreshold = specSettings.endOfMetamorphosis.timeMax
							end
						end

						if useEndOfMetamorphosisColor and metaTime <= timeThreshold then
							barColor = specSettings.colors.bar.metamorphosisEnding
						else
							barColor = specSettings.colors.bar.metamorphosis
						end
					end

					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
							snapshotData.audio.overcapCue = true			
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshotData.audio.overcapCue = false
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
		end
	end
	
	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

			if entry.sourceGuid == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "havoc" then --Havoc
					if entry.spellId == spells.bladeDance.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.deathSweep.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.chaosNova.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.eyeBeam.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.glaiveTempest.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.throwGlaive.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.felEruption.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.felBarrage.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.immolationAura.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.immolationAura1.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.immolationAura2.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.immolationAura3.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.immolationAura4.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.immolationAura5.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.immolationAura6.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					elseif entry.spellId == spells.unboundChaos.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.chaosTheory.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.tacticalRetreat.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
						if entry.type == "SPELL_AURA_APPLIED" then -- Gain Tactical Retreat
							snapshotData.snapshots[entry.spellId].buff:UpdateTicks(currentTime)
						end
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "vengeance" then --Vengeance
					if entry.spellId == spells.immolationAura.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.soulFurnace.id then
						snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
					elseif entry.spellId == spells.felDevastation.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					elseif entry.spellId == spells.chaosNova.id then
						if entry.type == "SPELL_CAST_SUCCESS" then
							snapshotData.snapshots[entry.spellId].cooldown:Initialize()
						end
					end
				end

				-- All specs
				if entry.spellId == spells.metamorphosis.id then
				snapshotData.snapshots[entry.spellId].buff:Initialize(entry.type)
				end
			end

			if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				---@type TRB.Classes.TargetData
				local targetData = TRB.Data.snapshotData.targetData
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
			specCache.havoc.talents:GetTalents()
			FillSpellData_Havoc()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.havoc)

			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

			TRB.Functions.RefreshLookupData = RefreshLookupData_Havoc
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.demonhunter.havoc)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.havoc)

			if TRB.Data.barConstructedForSpec ~= "havoc" then
				talents = specCache.havoc.talents
				TRB.Data.barConstructedForSpec = "havoc"
				ConstructResourceBar(specCache.havoc.settings)
			end
		elseif specId == 2 then
			specCache.vengeance.talents:GetTalents()
			FillSpellData_Vengeance()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.vengeance)

			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

			TRB.Functions.RefreshLookupData = RefreshLookupData_Vengeance
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.demonhunter.vengeance)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.vengeance)

			if TRB.Data.barConstructedForSpec ~= "vengeance" then
				talents = specCache.vengeance.talents
				TRB.Data.barConstructedForSpec = "vengeance"
				ConstructResourceBar(specCache.vengeance.settings)
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
		if classIndexId == 12 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
						TRB.Options:PortForwardSettings()

						local settings = TRB.Options.DemonHunter.LoadDefaultSettings(false)

						if TwintopInsanityBarSettings.demonhunter == nil or
							TwintopInsanityBarSettings.demonhunter.havoc == nil or
							TwintopInsanityBarSettings.demonhunter.havoc.displayText == nil then
							settings.demonhunter.havoc.displayText.barText = TRB.Options.DemonHunter.HavocLoadDefaultBarTextSimpleSettings()
						end

						if TwintopInsanityBarSettings.demonhunter == nil or
							TwintopInsanityBarSettings.demonhunter.vengeance == nil or
							TwintopInsanityBarSettings.demonhunter.vengeance.displayText == nil then
							settings.demonhunter.vengeance.displayText.barText = TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSimpleSettings()
						end

						TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
					else
						local settings = TRB.Options.DemonHunter.LoadDefaultSettings(true)
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
							TRB.Data.settings.demonhunter.havoc = TRB.Functions.LibSharedMedia:ValidateLsmValues("Havoc Demon Hunter", TRB.Data.settings.demonhunter.havoc)
							TRB.Data.settings.demonhunter.vengeance = TRB.Functions.LibSharedMedia:ValidateLsmValues("Vengeance Demon Hunter", TRB.Data.settings.demonhunter.vengeance)

							FillSpellData_Havoc()
							FillSpellData_Vengeance()

							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.DemonHunter.ConstructOptionsPanel(specCache)
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
		TRB.Data.character.className = "demonhunter"
		
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Fury)
		
		local spells = TRB.Data.spells
		---@type table<integer, TRB.Classes.Snapshot>
		local snapshots = TRB.Data.snapshotData.snapshots

		if specId == 1 then
			TRB.Data.character.specName = "havoc"

			if talents:IsTalentActive(spells.burningHatred) then
				snapshots[spells.immolationAura.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred.tickRate)
				snapshots[spells.immolationAura1.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred.tickRate)
				snapshots[spells.immolationAura2.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred.tickRate)
				snapshots[spells.immolationAura3.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred.tickRate)
				snapshots[spells.immolationAura4.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred.tickRate)
				snapshots[spells.immolationAura5.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred.tickRate)
				snapshots[spells.immolationAura6.id].buff:SetTickData(true, spells.burningHatred.resourcePerTick, spells.burningHatred.tickRate)
			else
				snapshots[spells.immolationAura.id].buff:SetTickData(false, 0, 0)
				snapshots[spells.immolationAura1.id].buff:SetTickData(false, 0, 0)
				snapshots[spells.immolationAura2.id].buff:SetTickData(false, 0, 0)
				snapshots[spells.immolationAura3.id].buff:SetTickData(false, 0, 0)
				snapshots[spells.immolationAura4.id].buff:SetTickData(false, 0, 0)
				snapshots[spells.immolationAura5.id].buff:SetTickData(false, 0, 0)
				snapshots[spells.immolationAura6.id].buff:SetTickData(false, 0, 0)
			end
		elseif specId == 2 then
			TRB.Data.character.specName = "vengeance"
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Fury)
			local maxComboPoints = spells.soulFragments.maxResource
			local settings = TRB.Data.settings.druid.feral

			if settings ~= nil then
				if maxComboPoints ~= TRB.Data.character.maxResource2 then
					TRB.Data.character.maxResource2 = maxComboPoints
					TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
				end
			end
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.demonhunter.havoc == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.havoc)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Fury
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = nil
			TRB.Data.resource2Factor = nil
		elseif specId == 2 and TRB.Data.settings.core.enabled.demonhunter.vengeance == true then
			local spells = TRB.Data.spells
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.vengeance)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Fury
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = "SPELL"
			TRB.Data.resource2Id = spells.soulFragments.id
			TRB.Data.resource2Factor = 1
		else
			TRB.Data.specSupported = false
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
		else
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

		TRB.Functions.Bar:HideResourceBar()
	end

	function TRB.Functions.Class:HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()
		---@type TRB.Classes.SnapshotData
		local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

		if specId == 1 then
			if not TRB.Data.specSupported or force or
			(TRB.Data.character.advancedFlight and not TRB.Data.settings.demonhunter.havoc.displayBar.dragonriding) or 
			((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.demonhunter.havoc.displayBar.alwaysShow) and (
						(not TRB.Data.settings.demonhunter.havoc.displayBar.notZeroShow) or
						(TRB.Data.settings.demonhunter.havoc.displayBar.notZeroShow and snapshotData.attributes.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.demonhunter.havoc.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or
			(TRB.Data.character.advancedFlight and not TRB.Data.settings.demonhunter.vengeance.displayBar.dragonriding) or 
			((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.demonhunter.vengeance.displayBar.alwaysShow) and (
						(not TRB.Data.settings.demonhunter.vengeance.displayBar.notZeroShow) or
						(TRB.Data.settings.demonhunter.vengeance.displayBar.notZeroShow and snapshotData.attributes.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshotData.attributes.isTracking = false
			else
				snapshotData.attributes.isTracking = true
				if TRB.Data.settings.demonhunter.vengeance.displayBar.neverShow == true then
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

		if guid ~= nil and guid ~= "" then
			---@type TRB.Classes.TargetData
			local targetData = TRB.Data.snapshotData.targetData
			if not targetData:CheckTargetExists(guid) then
				targetData:InitializeTarget(guid)
			end
			targetData.targets[guid].lastUpdate = GetTime()
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
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local settings = nil
		local normalizedResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
		if specId == 1 then
			settings = TRB.Data.settings.demonhunter.havoc
		elseif specId == 2 then
			settings = TRB.Data.settings.demonhunter.vengeance
		else
			return false
		end
		
		if specId == 1 then --Havoc
			if var == "$bhFury" then
				if snapshotData.snapshots[spells.immolationAura.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura1.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura2.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura3.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura4.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura5.id].buff.resource > 0 or snapshotData.snapshots[spells.immolationAura6.id].buff.resource > 0 then
					valid = true
				end
			elseif var == "$bhTicks" or var == "$iaTicks" then
				if snapshotData.snapshots[spells.immolationAura.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura1.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura2.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura3.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura4.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura5.id].buff.ticks > 0 or snapshotData.snapshots[spells.immolationAura6.id].buff.ticks > 0 then
					valid = true
				end
			elseif var == "$bhTime" or var == "$iaTime" then
				if snapshotData.snapshots[spells.immolationAura.id].buff.isActive or snapshotData.snapshots[spells.immolationAura1.id].buff.isActive or snapshotData.snapshots[spells.immolationAura2.id].buff.isActive or snapshotData.snapshots[spells.immolationAura3.id].buff.isActive or snapshotData.snapshots[spells.immolationAura4.id].buff.isActive or snapshotData.snapshots[spells.immolationAura5.id].buff.isActive or snapshotData.snapshots[spells.immolationAura6.id].buff.isActive then
					valid = true
				end
			elseif var == "$ucTime" then
				if snapshotData.snapshots[spells.immolationAura.id].buff.isActive or snapshotData.snapshots[spells.immolationAura1.id].buff.isActive or snapshotData.snapshots[spells.immolationAura2.id].buff.isActive or snapshotData.snapshots[spells.immolationAura3.id].buff.isActive or snapshotData.snapshots[spells.immolationAura4.id].buff.isActive or snapshotData.snapshots[spells.immolationAura5.id].buff.isActive or snapshotData.snapshots[spells.immolationAura6.id].buff.isActive then
					valid = true
				end
			elseif var == "$tacticalRetreatFury" then
				if snapshotData.snapshots[spells.tacticalRetreat.id].buff.resource > 0 then
					valid = true
				end
			elseif var == "$tacticalRetreatTicks" then
				if snapshotData.snapshots[spells.tacticalRetreat.id].buff.ticks > 0 then
					valid = true
				end
			elseif var == "$tacticalRetreatTime" then
				if snapshotData.snapshots[spells.tacticalRetreat.id].buff.isActive then
					valid = true
				end
			end
		elseif specId == 2 then --Vengeance
			if var == "$iaFury" then
				if snapshotData.snapshots[spells.immolationAura.id].buff.resource > 0 then
					valid = true
				end
			elseif var == "$iaTicks" then
				if snapshotData.snapshots[spells.immolationAura.id].buff.ticks > 0 then
					valid = true
				end
			elseif var == "$iaTime" then
				if snapshotData.snapshots[spells.immolationAura.id].buff.isActive then
					valid = true
				end
			elseif var == "$comboPoints" or var == "$soulFragments" then
				valid = true
			elseif var == "$comboPointsMax"or var == "$soulFragmentsMax" then
				valid = true
			end
		end
		
		if var == "$metamorphosisTime" or var == "$metaTime" then
			if snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
				valid = true
			end
		elseif var == "$resource" or var == "$fury" then
			if normalizedResource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$furyMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$furyTotal" then
			if normalizedResource > 0  or TRB.Functions.Class:IsValidVariableForSpec("$passive") or TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$furyPlusCasting" then
			if normalizedResource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$furyOvercap" or var == "$resourceOvercap" then
			local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$furyPlusPassive" then
			if normalizedResource > 0 or TRB.Functions.Class:IsValidVariableForSpec("$passive") or TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or TRB.Functions.Class:IsValidVariableForSpec("$iaFury") then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or TRB.Functions.Class:IsValidVariableForSpec("$tacticalRetreatFury") or TRB.Functions.Class:IsValidVariableForSpec("$iaFury") then
				valid = true
			end
		end

		return valid
	end

	function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
		local specId = GetSpecialization()
		local settings = TRB.Data.settings.demonhunter
		local spells = TRB.Data.spells
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if specId == 1 then
		elseif specId == 2 then
		end
		return nil
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 then
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