local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 12 then --Only do this if we're on a DemonHunter!
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
		havoc = {
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
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
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
				fury = 20,
				cooldown = 30,
				isTalent = false,
				baseline = true
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
				fury = -25,
				thresholdId = 9,
				settingKey = "throwGlaive",
				hasCooldown = true,
				thresholdUsable = false,
				isSnowflake = true,
				isTalent = false,
				baseline = true
			},

			--Havoc Baseline Abilities
			bladeDance = {
				id = 188499,
				name = "",
				icon = "",
				fury = -35,
				cooldown = 9,
				texture = "",
				thresholdId = 2,
				settingKey = "bladeDance",
				hasCooldown = true,
				thresholdUsable = false,
				demonForm = false,
				isTalent = false,
				baseline = true
			},
			chaosStrike = {
			   id = 162794,
			   name = "",
			   icon = "",
			   fury = -40,
			   texture = "",
			   thresholdId = 4,
			   settingKey = "chaosStrike",
			   hasCooldown = false,
			   thresholdUsable = false,
			   isSnowflake = true,
			   demonForm = false,
			   isTalent = false,
			   baseline = true
			},
			annihilation = {
				id = 201427,
				name = "",
				icon = "",
				fury = -40,
				texture = "",
				thresholdId = 1,
				settingKey = "annihilation",
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true,
				demonForm = true,
				isTalent = false,
				baseline = true
			},
			deathSweep = {
				id = 210152,
				name = "",
				icon = "",
				fury = -35,
				cooldown = 9,
				texture = "",
				thresholdId = 5,
				settingKey = "deathSweep",
				hasCooldown = true,
				thresholdUsable = false,
				demonForm = true,
				isSnowflake = true,
				isTalent = false,
				baseline = true
			},

			-- Demon Hunter Talent Abilities
			chaosNova = {
			   id = 179057,
			   name = "",
			   icon = "",
			   fury = -30,
			   texture = "",
			   thresholdId = 3,
			   settingKey = "chaosNova",
			   hasCooldown = true,
			   isSnowflake = true,
			   thresholdUsable = false,
			   isTalent = true
			},
			unleashedPower = {
				id = 206477,
				name = "",
				icon = "",
				furyModifier = 0.5,
				isTalent = true
			},

			-- Havoc Talent Abilities
			eyeBeam = {
				id = 198013,
				name = "",
				icon = "",
				fury = -30,
				duration = 2,
				texture = "",
				thresholdId = 6,
				settingKey = "eyeBeam",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},
			burningHatred = {
				id = 258922,
				talentId = 320374,
				name = "",
				icon = "",
				fury = 5,
				ticks = 12,
				duration = 12,
				isTalent = true
			},
			furiousThrows = {
				id = 393029,
				name = "",
				icon = "",
				fury = -25,
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
				fury = -10,
				cooldown = 30,
				texture = "",
				thresholdId = 8,
				settingKey = "felEruption",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},
			blindFury = {
				id = 203550,
				name = "",
				icon = "",
				durationModifier = 1.5,
				tickRate = 0.1,
				fury = 4,
				isHasted = true,
				isTalent = true
			},
			glaiveTempest = {
				id = 342817,
				name = "",
				icon = "",
				fury = -30,
				cooldown = 20,
				texture = "",
				thresholdId = 7,
				settingKey = "glaiveTempest",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true
			},

			demonsBite = {
				id = 162243,
				name = "",
				icon = "",
				fury = 20,
				furyMax = 30
			},
			demonicAppetite = {
				id = 206478,
				name = "",
				icon = "",
				fury = 30
			},
			felBlade = {
				id = 232893,
				name = "",
				icon = "",
				fury = 40
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
				furyAdjustment = -20
			},
			tacticalRetreat = {
				id = 389890,
				name = "",
				icon = "",
				fury = 8,
				ticks = 10,
				duration = 10,
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
			}
		}

		specCache.havoc.snapshotData.audio = {
			overcapCue = false
		}
		specCache.havoc.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {},
		}
		specCache.havoc.snapshotData.bladeDance = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshotData.chaosNova = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshotData.deathSweep = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshotData.eyeBeam = {
			startTime = nil,
			endTime = nil,
			duration = 0,
			spellId = nil,
			ticksRemaining = 0,
			fury = 0
		}
		specCache.havoc.snapshotData.glaiveTempest = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshotData.felEruption = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshotData.metamorphosis = {
			spellId = nil,
			isActive = false,
			duration = 0,
			endTime = nil
		}
		specCache.havoc.snapshotData.immolationAura = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.havoc.snapshotData.unboundChaos = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.havoc.snapshotData.throwGlaive = {
			charges = 0,
			maxCharges = 2,
			startTime = nil,
			duration = 0
		}
		specCache.havoc.snapshotData.tacticalRetreat = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.havoc.snapshotData.chaosTheory = {
			spellId = nil,
			isActive = false,
			duration = 0,
			endTime = nil
		}
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
			{ variable = "#casting", icon = "", description = "The icon of the Fury generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

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
			{ variable = "#unleashedPower", icon = spells.unleashedPower.icon, description = spells.unleashedPower.name, printInSettings = true },
		}
		specCache.havoc.barTextVariables.values = {
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
			
			{ variable = "$fury", description = "Current Fury", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Fury", printInSettings = false, color = false },
			{ variable = "$furyMax", description = "Maximum Fury", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Fury", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Fury from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Fury from Passive Sources", printInSettings = true, color = false },
			{ variable = "$furyPlusCasting", description = "Current + Casting Fury Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Fury Total", printInSettings = false, color = false },
			{ variable = "$furyPlusPassive", description = "Current + Passive Fury Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Fury Total", printInSettings = false, color = false },
			{ variable = "$furyTotal", description = "Current + Passive + Casting Fury Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Fury Total", printInSettings = false, color = false },   
		   
			{ variable = "$metaTime", description = "Time remaining on Metamorphosis buff", printInSettings = true, color = false },
			{ variable = "$metamorphosisTime", description = "Time remaining on Metamorphosis buff", printInSettings = false, color = false },

			{ variable = "$bhFury", description = "Fury from Burning Hatred (if talented)", printInSettings = true, color = false },
			{ variable = "$bhTicks", description = "Number of ticks left on Immolation Aura / Burning Hatred", printInSettings = false, color = false },
			{ variable = "$iaTicks", description = "Number of ticks left on Immolation Aura / Burning Hatred", printInSettings = true, color = false },
			{ variable = "$bhTime", description = "Time remaining on Immolation Aura / Burning Hatred", printInSettings = false, color = false },
			{ variable = "$iaTime", description = "Time remaining on Immolation Aura / Burning Hatred", printInSettings = true, color = false },

			{ variable = "$ucTime", description = "Time remaining on Unbound Chaos", printInSettings = true, color = false },

			{ variable = "$tacticalRetreatFury", description = "Fury from Tactical Retreat (if talented)", printInSettings = true, color = false },
			{ variable = "$tacticalRetreatTicks", description = "Number of ticks left on Tactical Retreat (if talented)", printInSetting = true, color = false },
			{ variable = "$tacticalRetreatTime", description = "Time remaining on Tactical Retreat (if talented)", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.havoc.spells = spells
	end

	local function GetImmolationAuraRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.immolationAura)
	end

	local function GetMetamorphosisRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.metamorphosis)
	end

	local function GetTacticalRetreatRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.tacticalRetreat)
	end
	
	local function GetUnboundChaosRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshotData.unboundChaos)
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
		TRB.Functions.Target:TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.rend = 0
		end
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		local entries = TRB.Functions.Table:Length(TRB.Frames.resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end
		end

		if specId == 1 then
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if spell ~= nil and spell.id ~= nil and spell.fury ~= nil and spell.fury < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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
		end

		if specId == 1 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function RefreshLookupData_Havoc()
		local _
		local normalizedFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		--Spec specific implementation

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.current
		local castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.casting
		
		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if TRB.Data.settings.demonhunter.havoc.colors.text.overcapEnabled and overcap then
				currentFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.overcap
			elseif TRB.Data.settings.demonhunter.havoc.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(TRB.Data.spells) do
					local spell = TRB.Data.spells[k]
					if	spell ~= nil and spell.thresholdUsable == true then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.overThreshold
				end
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.spending
		end

		--$metamorphosisTime
		local _metamorphosisTime = GetMetamorphosisRemainingTime()
		local metamorphosisTime = "0.0"
		if _metamorphosisTime ~= nil then
			metamorphosisTime = string.format("%.1f", _metamorphosisTime)
		end

		--$metamorphosisTime
		local _unboundChaosTime = GetUnboundChaosRemainingTime()
		local unboundChaosTime = "0.0"
		if _unboundChaosTime ~= nil then
			unboundChaosTime = string.format("%.1f", _unboundChaosTime)
		end

		--$bhFury
		local bhFury = TRB.Data.snapshotData.immolationAura.fury

		--$bhTicks and $iaTicks
		local bhTicks = TRB.Data.snapshotData.immolationAura.ticksRemaining

		--$bhTime and $iaTime
		local _bhTime = GetImmolationAuraRemainingTime()
		local bhTime = "0.0"
		if _bhTime ~= nil then
			bhTime = string.format("%.1f", _bhTime)
		end

		--$tacticalRetreatFury
		local tacticalRetreatFury = TRB.Data.snapshotData.tacticalRetreat.fury

		--$tacticalRetreatTicks
		local tacticalRetreatTicks = TRB.Data.snapshotData.tacticalRetreat.ticksRemaining

		--$tacticalRetreatTime
		local _tacticalRetreatTime = GetTacticalRetreatRemainingTime()
		local tacticalRetreatTime = "0.0"
		if _tacticalRetreatTime ~= nil then
			tacticalRetreatTime = string.format("%.1f", _tacticalRetreatTime)
		end

		--$fury
		local furyPrecision = TRB.Data.settings.demonhunter.havoc.furyPrecision or 0
		local currentFury = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(normalizedFury, furyPrecision, "floor"))
		--$casting
		local _castingFury = TRB.Data.snapshotData.casting.resourceFinal
		local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, furyPrecision, "floor"))
		--$passive
		local _passiveFury = bhFury + tacticalRetreatFury
		local passiveFury = string.format("|c%s%s|r", TRB.Data.settings.demonhunter.havoc.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveFury, furyPrecision, "floor"))
		
		--$furyTotal
		local _furyTotal = math.min(_passiveFury + TRB.Data.snapshotData.casting.resourceFinal + normalizedFury, TRB.Data.character.maxResource)
		local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyTotal, furyPrecision, "floor"))
		--$furyPlusCasting
		local _furyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedFury, TRB.Data.character.maxResource)
		local furyPlusCasting = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_furyPlusCasting, furyPrecision, "floor"))
		--$furyPlusPassive
		local _furyPlusPassive = math.min(_passiveFury + normalizedFury, TRB.Data.character.maxResource)
		local furyPlusPassive = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyPlusPassive, furyPrecision, "floor"))
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedFury
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
		lookup["#annihilation"] = TRB.Data.spells.annihilation.icon
		lookup["#bladeDance"] = TRB.Data.spells.bladeDance.icon
		lookup["#blindFury"] = TRB.Data.spells.blindFury.icon
		lookup["#bh"] = TRB.Data.spells.burningHatred.icon
		lookup["#burningHatred"] = TRB.Data.spells.burningHatred.icon
		lookup["#chaosNova"] = TRB.Data.spells.chaosNova.icon
		lookup["#chaosStrike"] = TRB.Data.spells.chaosStrike.icon
		lookup["#deathSweep"] = TRB.Data.spells.deathSweep.icon
		lookup["#demonicAppetite"] = TRB.Data.spells.demonicAppetite.icon
		lookup["#demonsBite"] = TRB.Data.spells.demonsBite.icon
		lookup["#eyeBeam"] = TRB.Data.spells.eyeBeam.icon
		lookup["#felBlade"] = TRB.Data.spells.felBlade.icon
		lookup["#felEruption"] = TRB.Data.spells.felEruption.icon
		lookup["#firstBlood"] = TRB.Data.spells.firstBlood.icon
		lookup["#glaiveTempest"] = TRB.Data.spells.glaiveTempest.icon
		lookup["#immolationAura"] = TRB.Data.spells.immolationAura.icon
		lookup["#meta"] = TRB.Data.spells.metamorphosis.icon
		lookup["#metamorphosis"] = TRB.Data.spells.metamorphosis.icon
		lookup["#momentum"] = TRB.Data.spells.momentum.icon
		lookup["#tacticalRetreat"] = TRB.Data.spells.tacticalRetreat.icon
		lookup["#unboundChaos"] = TRB.Data.spells.unboundChaos.icon
		lookup["#unleashedPower"] = TRB.Data.spells.unleashedPower.icon
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
		lookup["$resourcePlusPassive"] = furyPlusPassive
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
		lookupLogic["$fury"] = normalizedFury
		lookupLogic["$resourcePlusCasting"] = _furyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _furyPlusPassive
		lookupLogic["$resourceTotal"] = _furyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedFury
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
		TRB.Data.snapshotData.casting.resourceRaw = spell.fury
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.fury)
		TRB.Data.snapshotData.casting.spellId = spell.id
		TRB.Data.snapshotData.casting.icon = spell.icon
	end

	local function CastingSpell()
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
					if currentChannelId == TRB.Data.spells.eyeBeam.id and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.blindFury) then
						local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.eyeBeam.id
						--TRB.Data.snapshotData.casting.startTime = currentChannelStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentChannelEndTime / 1000
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.eyeBeam.icon
						local remainingTime = TRB.Data.snapshotData.casting.endTime - currentTime
						local ticks = TRB.Functions.Number:RoundTo(remainingTime / (TRB.Data.spells.blindFury.tickRate * (gcd / 1.5)), 0, "ceil", true)
						local fury = ticks * TRB.Data.spells.blindFury.fury
						TRB.Data.snapshotData.casting.resourceRaw = fury
						TRB.Data.snapshotData.casting.resourceFinal = fury
						TRB.Data.snapshotData.eyeBeam.ticksRemaining = ticks
						TRB.Data.snapshotData.eyeBeam.fury = fury
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
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateBurningHatred()
		if TRB.Data.snapshotData.immolationAura.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.immolationAura.endTime == nil or currentTime > TRB.Data.snapshotData.immolationAura.endTime then
				TRB.Data.snapshotData.immolationAura.ticksRemaining = 0
				TRB.Data.snapshotData.immolationAura.endTime = nil
				TRB.Data.snapshotData.immolationAura.fury = 0
				TRB.Data.snapshotData.immolationAura.isActive = false
			else
				TRB.Data.snapshotData.immolationAura.ticksRemaining = math.ceil((TRB.Data.snapshotData.immolationAura.endTime - currentTime) / (TRB.Data.spells.burningHatred.duration / TRB.Data.spells.burningHatred.ticks))
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.burningHatred) then
					TRB.Data.snapshotData.immolationAura.fury = TRB.Data.snapshotData.immolationAura.ticksRemaining * TRB.Data.spells.burningHatred.fury
				else
					TRB.Data.snapshotData.immolationAura.fury = 0
				end
			end
		end
	end

	local function UpdateTacticalRetreat()
		if TRB.Data.snapshotData.tacticalRetreat.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.tacticalRetreat.endTime == nil or currentTime > TRB.Data.snapshotData.tacticalRetreat.endTime then
				TRB.Data.snapshotData.tacticalRetreat.ticksRemaining = 0
				TRB.Data.snapshotData.tacticalRetreat.endTime = nil
				TRB.Data.snapshotData.tacticalRetreat.fury = 0
				TRB.Data.snapshotData.tacticalRetreat.isActive = false
			else
				TRB.Data.snapshotData.tacticalRetreat.ticksRemaining = math.ceil((TRB.Data.snapshotData.tacticalRetreat.endTime - currentTime) / (TRB.Data.spells.tacticalRetreat.duration / TRB.Data.spells.tacticalRetreat.ticks))
				TRB.Data.snapshotData.tacticalRetreat.fury = TRB.Data.snapshotData.tacticalRetreat.ticksRemaining * TRB.Data.spells.tacticalRetreat.fury
			end
		end
	end

	local function UpdateMetamorphosis()
		if TRB.Data.snapshotData.metamorphosis.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.metamorphosis.endTime ~= nil and currentTime > TRB.Data.snapshotData.metamorphosis.endTime then
				TRB.Data.snapshotData.metamorphosis.endTime = nil
				TRB.Data.snapshotData.metamorphosis.duration = 0
				TRB.Data.snapshotData.metamorphosis.isActive = false
			elseif TRB.Data.snapshotData.metamorphosis.endTime ~= nil then
				_, _, _, _, TRB.Data.snapshotData.metamorphosis.duration, TRB.Data.snapshotData.metamorphosis.endTime, _, _, _, TRB.Data.snapshotData.metamorphosis.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.metamorphosis.id)
			end
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Havoc()
		UpdateSnapshot()
		UpdateMetamorphosis()
		UpdateBurningHatred()
		UpdateTacticalRetreat()

		local currentTime = GetTime()
		local _

		if TRB.Data.snapshotData.bladeDance.startTime ~= nil and currentTime > (TRB.Data.snapshotData.bladeDance.startTime + TRB.Data.snapshotData.bladeDance.duration) then
			TRB.Data.snapshotData.bladeDance.startTime = nil
			TRB.Data.snapshotData.bladeDance.duration = 0
		elseif TRB.Data.snapshotData.bladeDance.startTime ~= nil then
			if GetMetamorphosisRemainingTime() > 0 then
				---@diagnostic disable-next-line: redundant-parameter
				TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.deathSweep.id)
				TRB.Data.snapshotData.deathSweep.startTime, TRB.Data.snapshotData.deathSweep.duration, _, _ = GetSpellCooldown(TRB.Data.spells.deathSweep.id)
			else
				---@diagnostic disable-next-line: redundant-parameter
				TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeDance.id)
				TRB.Data.snapshotData.deathSweep.startTime, TRB.Data.snapshotData.deathSweep.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeDance.id)
			end
		end

		if TRB.Data.snapshotData.chaosNova.startTime ~= nil and currentTime > (TRB.Data.snapshotData.chaosNova.startTime + TRB.Data.snapshotData.chaosNova.duration) then
			TRB.Data.snapshotData.chaosNova.startTime = nil
			TRB.Data.snapshotData.chaosNova.duration = 0
		elseif TRB.Data.snapshotData.chaosNova.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.chaosNova.startTime, TRB.Data.snapshotData.chaosNova.duration, _, _ = GetSpellCooldown(TRB.Data.spells.chaosNova.id)
		end

		if TRB.Data.snapshotData.eyeBeam.startTime ~= nil and currentTime > (TRB.Data.snapshotData.eyeBeam.startTime + TRB.Data.snapshotData.eyeBeam.duration) then
			TRB.Data.snapshotData.eyeBeam.startTime = nil
			TRB.Data.snapshotData.eyeBeam.duration = 0
		elseif TRB.Data.snapshotData.eyeBeam.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.eyeBeam.startTime, TRB.Data.snapshotData.eyeBeam.duration, _, _ = GetSpellCooldown(TRB.Data.spells.eyeBeam.id)
		end

		if TRB.Data.snapshotData.glaiveTempest.startTime ~= nil and currentTime > (TRB.Data.snapshotData.glaiveTempest.startTime + TRB.Data.snapshotData.glaiveTempest.duration) then
			TRB.Data.snapshotData.glaiveTempest.startTime = nil
			TRB.Data.snapshotData.glaiveTempest.duration = 0
		elseif TRB.Data.snapshotData.glaiveTempest.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.glaiveTempest.startTime, TRB.Data.snapshotData.glaiveTempest.duration, _, _ = GetSpellCooldown(TRB.Data.spells.glaiveTempest.id)
		end

		if TRB.Data.snapshotData.felEruption.startTime ~= nil and currentTime > (TRB.Data.snapshotData.felEruption.startTime + TRB.Data.snapshotData.felEruption.duration) then
			TRB.Data.snapshotData.felEruption.startTime = nil
			TRB.Data.snapshotData.felEruption.duration = 0
		elseif TRB.Data.snapshotData.felEruption.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshotData.felEruption.startTime, TRB.Data.snapshotData.felEruption.duration, _, _ = GetSpellCooldown(TRB.Data.spells.felEruption.id)
		end

		TRB.Data.snapshotData.throwGlaive.charges, TRB.Data.snapshotData.throwGlaive.maxCharges, TRB.Data.snapshotData.throwGlaive.startTime, TRB.Data.snapshotData.throwGlaive.duration, _ = GetSpellCharges(TRB.Data.spells.throwGlaive.id)
		if TRB.Data.snapshotData.throwGlaive.charges == TRB.Data.snapshotData.throwGlaive.maxCharges then
			TRB.Data.snapshotData.throwGlaive.startTime = nil
			TRB.Data.snapshotData.throwGlaive.duration = 0
		end
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.demonhunter

		if specId == 1 then
			local specSettings = classSettings.havoc
			UpdateSnapshot_Havoc()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local metaTime = GetMetamorphosisRemainingTime()

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if TRB.Data.snapshotData.immolationAura.fury > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.immolationAura.fury
						end

						if TRB.Data.snapshotData.tacticalRetreat.fury > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.tacticalRetreat.fury
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentFury + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentFury
					end

					if castingBarValue < currentFury then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue) 
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, currentFury)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, currentFury)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentFury)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.fury ~= nil and spell.fury < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local furyAmount = CalculateAbilityResourceValue(spell.fury)
							local normalizedFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -furyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							if metaTime > 0 and (spell.demonForm ~= nil and spell.demonForm == false) then
								showThreshold = false
							elseif metaTime == 0 and (spell.demonForm ~= nil and spell.demonForm == true) then
								showThreshold = false
							elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.deathSweep.id then
									if TRB.Data.snapshotData.bladeDance.startTime ~= nil and currentTime < (TRB.Data.snapshotData.bladeDance.startTime + TRB.Data.snapshotData.bladeDance.duration) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentFury >= -furyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.chaosNova.id then
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.unleashedPower) then
										furyAmount = furyAmount * TRB.Data.spells.unleashedPower.furyModifier
									end

									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -furyAmount, TRB.Data.character.maxResource)

									if TRB.Data.snapshotData.chaosNova.startTime ~= nil and currentTime < (TRB.Data.snapshotData.chaosNova.startTime + TRB.Data.snapshotData.chaosNova.duration) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif currentFury >= -furyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.throwGlaive.id then
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.furiousThrows) then
										furyAmount = TRB.Data.spells.furiousThrows.fury
										if TRB.Data.snapshotData.throwGlaive.charges == 0 then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshotData.resource >= -furyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									else
										showThreshold = false
									end
								elseif spell.id == TRB.Data.spells.chaosStrike.id or spell.id == TRB.Data.spells.annihilation.id then
									if TRB.Data.snapshotData.chaosTheory.endTime ~= nil and currentTime < TRB.Data.snapshotData.chaosTheory.endTime then
										thresholdColor = specSettings.colors.threshold.special
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentFury >= -furyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							elseif spell.hasCooldown then
								if (TRB.Data.snapshotData[spell.settingKey].charges == nil or TRB.Data.snapshotData[spell.settingKey].charges == 0) and
									(TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration)) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif currentFury >= -furyAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentFury >= -furyAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshotData[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end
					
					local barColor = specSettings.colors.bar.base
					if TRB.Data.snapshotData.metamorphosis.isActive then
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

						if specSettings.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
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
				if specId == 1 and TRB.Data.barConstructedForSpec == "havoc" then --Havoc
					if spellId == TRB.Data.spells.bladeDance.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeDance.id)
						end
					elseif spellId == TRB.Data.spells.deathSweep.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.deathSweep.id)
						end
					elseif spellId == TRB.Data.spells.chaosNova.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.chaosNova.startTime, TRB.Data.snapshotData.chaosNova.duration, _, _ = GetSpellCooldown(TRB.Data.spells.chaosNova.id)
						end
					elseif spellId == TRB.Data.spells.eyeBeam.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.eyeBeam.startTime, TRB.Data.snapshotData.eyeBeam.duration, _, _ = GetSpellCooldown(TRB.Data.spells.eyeBeam.id)
						end
					elseif spellId == TRB.Data.spells.glaiveTempest.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.glaiveTempest.startTime, TRB.Data.snapshotData.glaiveTempest.duration, _, _ = GetSpellCooldown(TRB.Data.spells.glaiveTempest.id)
						end
					elseif spellId == TRB.Data.spells.throwGlaive.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.throwGlaive.charges, TRB.Data.snapshotData.throwGlaive.maxCharges, TRB.Data.snapshotData.throwGlaive.startTime, TRB.Data.snapshotData.throwGlaive.duration, _ = GetSpellCharges(TRB.Data.spells.throwGlaive.id)
						end
					elseif spellId == TRB.Data.spells.felEruption.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshotData.felEruption.startTime, TRB.Data.snapshotData.felEruption.duration, _, _ = GetSpellCooldown(TRB.Data.spells.felEruption.id)
						end
					elseif spellId == TRB.Data.spells.metamorphosis.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.metamorphosis.isActive = true
							_, _, _, _, TRB.Data.snapshotData.metamorphosis.duration, TRB.Data.snapshotData.metamorphosis.endTime, _, _, _, TRB.Data.snapshotData.metamorphosis.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.metamorphosis.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.metamorphosis.isActive = false
							TRB.Data.snapshotData.metamorphosis.spellId = nil
							TRB.Data.snapshotData.metamorphosis.duration = 0
							TRB.Data.snapshotData.metamorphosis.endTime = nil
						end
					elseif spellId == TRB.Data.spells.immolationAura.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							local felfireHeartDurationMod = 0
							local felfireHeartTicksMod = 0
							
							if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.felfireHeart) then
								felfireHeartDurationMod = TRB.Data.spells.felfireHeart.duration * TRB.Data.talents[TRB.Data.spells.felfireHeart.id].currentRank
								felfireHeartTicksMod = TRB.Data.spells.felfireHeart.ticks * TRB.Data.talents[TRB.Data.spells.felfireHeart.id].currentRank
							end

							TRB.Data.snapshotData.immolationAura.isActive = true
							TRB.Data.snapshotData.immolationAura.ticksRemaining = TRB.Data.spells.burningHatred.ticks + felfireHeartTicksMod
							
							if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.burningHatred) then
								TRB.Data.snapshotData.immolationAura.fury = TRB.Data.snapshotData.immolationAura.ticksRemaining * TRB.Data.spells.burningHatred.fury
							else
								TRB.Data.snapshotData.immolationAura.fury = 0
							end

							TRB.Data.snapshotData.immolationAura.endTime = currentTime + TRB.Data.spells.burningHatred.duration + felfireHeartDurationMod
							TRB.Data.snapshotData.immolationAura.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.immolationAura.isActive = false
							TRB.Data.snapshotData.immolationAura.ticksRemaining = 0
							TRB.Data.snapshotData.immolationAura.fury = 0
							TRB.Data.snapshotData.immolationAura.endTime = nil
							TRB.Data.snapshotData.immolationAura.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.immolationAura.ticksRemaining = TRB.Data.snapshotData.immolationAura.ticksRemaining - 1
							TRB.Data.snapshotData.immolationAura.fury = TRB.Data.snapshotData.immolationAura.ticksRemaining * TRB.Data.spells.burningHatred.fury
							TRB.Data.snapshotData.immolationAura.lastTick = currentTime
						end
					elseif spellId == TRB.Data.spells.unboundChaos.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.unboundChaos.isActive = true
							_, _, _, _, TRB.Data.snapshotData.unboundChaos.duration, TRB.Data.snapshotData.unboundChaos.endTime, _, _, _, TRB.Data.snapshotData.unboundChaos.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.unboundChaos.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.unboundChaos.isActive = false
							TRB.Data.snapshotData.unboundChaos.spellId = nil
							TRB.Data.snapshotData.unboundChaos.duration = 0
							TRB.Data.snapshotData.unboundChaos.endTime = nil
						end
					elseif spellId == TRB.Data.spells.chaosTheory.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.chaosTheory.isActive = true
							_, _, _, _, TRB.Data.snapshotData.chaosTheory.duration, TRB.Data.snapshotData.chaosTheory.endTime, _, _, _, TRB.Data.snapshotData.chaosTheory.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.chaosTheory.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.chaosTheory.isActive = false
							TRB.Data.snapshotData.chaosTheory.spellId = nil
							TRB.Data.snapshotData.chaosTheory.duration = 0
							TRB.Data.snapshotData.chaosTheory.endTime = nil
						end
					elseif spellId == TRB.Data.spells.tacticalRetreat.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Tactical Retreat
							TRB.Data.snapshotData.tacticalRetreat.isActive = true
							TRB.Data.snapshotData.tacticalRetreat.ticksRemaining = TRB.Data.spells.tacticalRetreat.ticks								
							TRB.Data.snapshotData.tacticalRetreat.fury = TRB.Data.snapshotData.tacticalRetreat.ticksRemaining * TRB.Data.spells.tacticalRetreat.fury
							TRB.Data.snapshotData.tacticalRetreat.endTime = currentTime + TRB.Data.spells.tacticalRetreat.duration
							TRB.Data.snapshotData.tacticalRetreat.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then -- It shouldn't refresh but let's check for it anyway
							TRB.Data.snapshotData.tacticalRetreat.ticksRemaining = TRB.Data.spells.tacticalRetreat.ticks + 1
							TRB.Data.snapshotData.tacticalRetreat.fury = TRB.Data.snapshotData.tacticalRetreat.ticksRemaining * TRB.Data.spells.tacticalRetreat.fury
							TRB.Data.snapshotData.tacticalRetreat.endTime = currentTime + TRB.Data.spells.tacticalRetreat.duration + ((TRB.Data.spells.tacticalRetreat.duration / TRB.Data.spells.tacticalRetreat.ticks) - (currentTime - TRB.Data.snapshotData.tacticalRetreat.lastTick))
							TRB.Data.snapshotData.tacticalRetreat.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.tacticalRetreat.isActive = false
							TRB.Data.snapshotData.tacticalRetreat.ticksRemaining = 0
							TRB.Data.snapshotData.tacticalRetreat.fury = 0
							TRB.Data.snapshotData.tacticalRetreat.endTime = nil
							TRB.Data.snapshotData.tacticalRetreat.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.tacticalRetreat.ticksRemaining = TRB.Data.snapshotData.tacticalRetreat.ticksRemaining - 1
							TRB.Data.snapshotData.tacticalRetreat.fury = TRB.Data.snapshotData.tacticalRetreat.ticksRemaining * TRB.Data.spells.tacticalRetreat.fury
							TRB.Data.snapshotData.tacticalRetreat.lastTick = currentTime
						end
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
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.demonhunter.havoc)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.havoc)
			specCache.havoc.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Havoc()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.havoc)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Havoc

			if TRB.Data.barConstructedForSpec ~= "havoc" then
				TRB.Data.barConstructedForSpec = "havoc"
				ConstructResourceBar(specCache.havoc.settings)
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

					local settings = TRB.Options.DemonHunter.LoadDefaultSettings()
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
							TRB.Data.settings.demonhunter.havoc = TRB.Functions.LibSharedMedia:ValidateLsmValues("Havoc Demon Hunter", TRB.Data.settings.demonhunter.havoc)
							FillSpellData_Havoc()

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
		TRB.Functions.Character:CheckCharacter()
		TRB.Data.character.className = "demonhunter"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Fury)

		if GetSpecialization() == 1 then
			TRB.Data.character.specName = "havoc"
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.demonhunter.havoc == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.havoc)
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
			TRB.Data.resource = Enum.PowerType.Fury
			TRB.Data.resourceFactor = 1
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
					(not TRB.Data.settings.demonhunter.havoc.displayBar.alwaysShow) and (
						(not TRB.Data.settings.demonhunter.havoc.displayBar.notZeroShow) or
						(TRB.Data.settings.demonhunter.havoc.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.demonhunter.havoc.displayBar.neverShow == true then
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

	function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		if guid ~= nil then
			if not TRB.Functions.Target:CheckTargetExists(guid) then
				TRB.Functions.Target:InitializeTarget(guid)
			end
			TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()
			return true
		end
		return false
	end

	function TRB.Functions.Class:IsValidVariableForSpec(var)
		local valid = TRB.Functions.BarText:IsValidVariableBase(var)
		local normalizedFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.demonhunter.havoc
		end

		
		if specId == 1 then --Havoc
			if var == "$metamorphosisTime" then
				if GetMetamorphosisRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$bhFury" then
				if TRB.Data.snapshotData.immolationAura.fury > 0 then
					valid = true
				end
			elseif var == "$bhTicks" or var == "$iaTicks" then
				if TRB.Data.snapshotData.immolationAura.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$bhTime" or var == "$iaTime" then
				if GetImmolationAuraRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$ucTime" then
				if GetUnboundChaosRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$tacticalRetreatFury" then
				if TRB.Data.snapshotData.tacticalRetreat.fury > 0 then
					valid = true
				end
			elseif var == "$tacticalRetreatTicks" then
				if TRB.Data.snapshotData.tacticalRetreat.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$tacticalRetreatTime" then
				if GetTacticalRetreatRemainingTime() > 0 then
					valid = true
				end
			end
		end

		if var == "$resource" or var == "$fury" then
			if normalizedFury > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$furyMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$furyTotal" then
			if normalizedFury > 0  or TRB.Functions.Class:IsValidVariableForSpec("$passive") or TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$furyPlusCasting" then
			if normalizedFury > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$furyOvercap" or var == "$resourceOvercap" then
			local threshold = ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$furyPlusPassive" then
			if normalizedFury > 0 or TRB.Functions.Class:IsValidVariableForSpec("$passive") or TRB.Functions.Class:IsValidVariableForSpec("$bhFury") then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$bhFury") or TRB.Functions.Class:IsValidVariableForSpec("$tacticalRetreatFury") then
				valid = true
			end
		end

		return valid
	end


	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		if GetSpecialization() ~= 1 then
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