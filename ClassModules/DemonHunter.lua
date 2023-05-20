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

		specCache.havoc.snapshot.audio = {
			overcapCue = false
		}
		specCache.havoc.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			---@type TRB.Classes.Target[]
			targets = {}
		}
		--[[---@type TRB.Classes.Target[]
		specCache.havoc.snapshot.targetData.targets = {}		]]
		specCache.havoc.snapshot.bladeDance = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshot.chaosNova = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshot.deathSweep = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshot.eyeBeam = {
			startTime = nil,
			endTime = nil,
			duration = 0,
			spellId = nil,
			ticksRemaining = 0,
			fury = 0
		}
		specCache.havoc.snapshot.glaiveTempest = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshot.felEruption = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshot.metamorphosis = {
			spellId = nil,
			isActive = false,
			duration = 0,
			endTime = nil
		}
		specCache.havoc.snapshot.immolationAura = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.havoc.snapshot.unboundChaos = {
			spellId = nil,
			duration = 0,
			endTime = nil
		}
		specCache.havoc.snapshot.throwGlaive = {
			charges = 0,
			maxCharges = 2,
			startTime = nil,
			duration = 0
		}
		specCache.havoc.snapshot.tacticalRetreat = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.havoc.snapshot.chaosTheory = {
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
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.immolationAura)
	end

	local function GetMetamorphosisRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.metamorphosis)
	end

	local function GetTacticalRetreatRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.tacticalRetreat)
	end
	
	local function GetUnboundChaosRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.unboundChaos)
	end

	local function CalculateAbilityResourceValue(resource)
		local modifier = 1.0

		return resource * modifier
	end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshot.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
	end

	local function TargetsCleanup(clearAll)
		---@type TRB.Classes.TargetData
		local targetData = TRB.Data.snapshot.targetData
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
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot
		local specSettings = TRB.Data.settings.demonhunter.havoc
		local normalizedFury = snapshot.resource / TRB.Data.resourceFactor
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
					if	spell ~= nil and spell.thresholdUsable == true then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFuryColor = specSettings.colors.text.overThreshold
				end
			end
		end

		if snapshot.casting.resourceFinal < 0 then
			castingFuryColor = specSettings.colors.text.spending
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
		local bhFury = snapshot.immolationAura.fury

		--$bhTicks and $iaTicks
		local bhTicks = snapshot.immolationAura.ticksRemaining

		--$bhTime and $iaTime
		local _bhTime = GetImmolationAuraRemainingTime()
		local bhTime = "0.0"
		if _bhTime ~= nil then
			bhTime = string.format("%.1f", _bhTime)
		end

		--$tacticalRetreatFury
		local tacticalRetreatFury = snapshot.tacticalRetreat.fury

		--$tacticalRetreatTicks
		local tacticalRetreatTicks = snapshot.tacticalRetreat.ticksRemaining

		--$tacticalRetreatTime
		local _tacticalRetreatTime = GetTacticalRetreatRemainingTime()
		local tacticalRetreatTime = "0.0"
		if _tacticalRetreatTime ~= nil then
			tacticalRetreatTime = string.format("%.1f", _tacticalRetreatTime)
		end

		--$fury
		local furyPrecision = specSettings.furyPrecision or 0
		local currentFury = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(normalizedFury, furyPrecision, "floor"))
		--$casting
		local _castingFury = snapshot.casting.resourceFinal
		local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, furyPrecision, "floor"))
		--$passive
		local _passiveFury = bhFury + tacticalRetreatFury
		local passiveFury = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveFury, furyPrecision, "floor"))
		
		--$furyTotal
		local _furyTotal = math.min(_passiveFury + snapshot.casting.resourceFinal + normalizedFury, TRB.Data.character.maxResource)
		local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.Number:RoundTo(_furyTotal, furyPrecision, "floor"))
		--$furyPlusCasting
		local _furyPlusCasting = math.min(snapshot.casting.resourceFinal + normalizedFury, TRB.Data.character.maxResource)
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
		lookup["#felBlade"] = spells.felBlade.icon
		lookup["#felEruption"] = spells.felEruption.icon
		lookup["#firstBlood"] = spells.firstBlood.icon
		lookup["#glaiveTempest"] = spells.glaiveTempest.icon
		lookup["#immolationAura"] = spells.immolationAura.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#momentum"] = spells.momentum.icon
		lookup["#tacticalRetreat"] = spells.tacticalRetreat.icon
		lookup["#unboundChaos"] = spells.unboundChaos.icon
		lookup["#unleashedPower"] = spells.unleashedPower.icon
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
		TRB.Data.snapshot.casting.startTime = currentTime
		TRB.Data.snapshot.casting.resourceRaw = spell.fury
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(spell.fury)
		TRB.Data.snapshot.casting.spellId = spell.id
		TRB.Data.snapshot.casting.icon = spell.icon
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
						TRB.Data.snapshot.casting.spellId = TRB.Data.spells.eyeBeam.id
						--TRB.Data.snapshot.casting.startTime = currentChannelStartTime / 1000
						TRB.Data.snapshot.casting.endTime = currentChannelEndTime / 1000
						TRB.Data.snapshot.casting.icon = TRB.Data.spells.eyeBeam.icon
						local remainingTime = TRB.Data.snapshot.casting.endTime - currentTime
						local ticks = TRB.Functions.Number:RoundTo(remainingTime / (TRB.Data.spells.blindFury.tickRate * (gcd / 1.5)), 0, "ceil", true)
						local fury = ticks * TRB.Data.spells.blindFury.fury
						TRB.Data.snapshot.casting.resourceRaw = fury
						TRB.Data.snapshot.casting.resourceFinal = fury
						TRB.Data.snapshot.eyeBeam.ticksRemaining = ticks
						TRB.Data.snapshot.eyeBeam.fury = fury
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
		if TRB.Data.snapshot.immolationAura.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.immolationAura.endTime == nil or currentTime > TRB.Data.snapshot.immolationAura.endTime then
				TRB.Data.snapshot.immolationAura.ticksRemaining = 0
				TRB.Data.snapshot.immolationAura.endTime = nil
				TRB.Data.snapshot.immolationAura.fury = 0
				TRB.Data.snapshot.immolationAura.isActive = false
			else
				TRB.Data.snapshot.immolationAura.ticksRemaining = math.ceil((TRB.Data.snapshot.immolationAura.endTime - currentTime) / (TRB.Data.spells.burningHatred.duration / TRB.Data.spells.burningHatred.ticks))
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.burningHatred) then
					TRB.Data.snapshot.immolationAura.fury = TRB.Data.snapshot.immolationAura.ticksRemaining * TRB.Data.spells.burningHatred.fury
				else
					TRB.Data.snapshot.immolationAura.fury = 0
				end
			end
		end
	end

	local function UpdateTacticalRetreat()
		if TRB.Data.snapshot.tacticalRetreat.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.tacticalRetreat.endTime == nil or currentTime > TRB.Data.snapshot.tacticalRetreat.endTime then
				TRB.Data.snapshot.tacticalRetreat.ticksRemaining = 0
				TRB.Data.snapshot.tacticalRetreat.endTime = nil
				TRB.Data.snapshot.tacticalRetreat.fury = 0
				TRB.Data.snapshot.tacticalRetreat.isActive = false
			else
				TRB.Data.snapshot.tacticalRetreat.ticksRemaining = math.ceil((TRB.Data.snapshot.tacticalRetreat.endTime - currentTime) / (TRB.Data.spells.tacticalRetreat.duration / TRB.Data.spells.tacticalRetreat.ticks))
				TRB.Data.snapshot.tacticalRetreat.fury = TRB.Data.snapshot.tacticalRetreat.ticksRemaining * TRB.Data.spells.tacticalRetreat.fury
			end
		end
	end

	local function UpdateMetamorphosis()
		if TRB.Data.snapshot.metamorphosis.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.metamorphosis.endTime ~= nil and currentTime > TRB.Data.snapshot.metamorphosis.endTime then
				TRB.Data.snapshot.metamorphosis.endTime = nil
				TRB.Data.snapshot.metamorphosis.duration = 0
				TRB.Data.snapshot.metamorphosis.isActive = false
			elseif TRB.Data.snapshot.metamorphosis.endTime ~= nil then
				_, _, _, _, TRB.Data.snapshot.metamorphosis.duration, TRB.Data.snapshot.metamorphosis.endTime, _, _, _, TRB.Data.snapshot.metamorphosis.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.metamorphosis.id)
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
		
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot

		local currentTime = GetTime()
		local _

		if snapshot.bladeDance.startTime ~= nil and currentTime > (snapshot.bladeDance.startTime + snapshot.bladeDance.duration) then
			snapshot.bladeDance.startTime = nil
			snapshot.bladeDance.duration = 0
		elseif snapshot.bladeDance.startTime ~= nil then
			if GetMetamorphosisRemainingTime() > 0 then
				---@diagnostic disable-next-line: redundant-parameter
				snapshot.bladeDance.startTime, snapshot.bladeDance.duration, _, _ = GetSpellCooldown(spells.deathSweep.id)
				snapshot.deathSweep.startTime, snapshot.deathSweep.duration, _, _ = GetSpellCooldown(spells.deathSweep.id)
			else
				---@diagnostic disable-next-line: redundant-parameter
				snapshot.bladeDance.startTime, snapshot.bladeDance.duration, _, _ = GetSpellCooldown(spells.bladeDance.id)
				snapshot.deathSweep.startTime, snapshot.deathSweep.duration, _, _ = GetSpellCooldown(spells.bladeDance.id)
			end
		end

		if snapshot.chaosNova.startTime ~= nil and currentTime > (snapshot.chaosNova.startTime + snapshot.chaosNova.duration) then
			snapshot.chaosNova.startTime = nil
			snapshot.chaosNova.duration = 0
		elseif snapshot.chaosNova.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			snapshot.chaosNova.startTime, snapshot.chaosNova.duration, _, _ = GetSpellCooldown(spells.chaosNova.id)
		end

		if snapshot.eyeBeam.startTime ~= nil and currentTime > (snapshot.eyeBeam.startTime + snapshot.eyeBeam.duration) then
			snapshot.eyeBeam.startTime = nil
			snapshot.eyeBeam.duration = 0
		elseif snapshot.eyeBeam.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			snapshot.eyeBeam.startTime, snapshot.eyeBeam.duration, _, _ = GetSpellCooldown(spells.eyeBeam.id)
		end

		if snapshot.glaiveTempest.startTime ~= nil and currentTime > (snapshot.glaiveTempest.startTime + snapshot.glaiveTempest.duration) then
			snapshot.glaiveTempest.startTime = nil
			snapshot.glaiveTempest.duration = 0
		elseif snapshot.glaiveTempest.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			snapshot.glaiveTempest.startTime, snapshot.glaiveTempest.duration, _, _ = GetSpellCooldown(spells.glaiveTempest.id)
		end

		if snapshot.felEruption.startTime ~= nil and currentTime > (snapshot.felEruption.startTime + snapshot.felEruption.duration) then
			snapshot.felEruption.startTime = nil
			snapshot.felEruption.duration = 0
		elseif snapshot.felEruption.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			snapshot.felEruption.startTime, snapshot.felEruption.duration, _, _ = GetSpellCooldown(spells.felEruption.id)
		end

		snapshot.throwGlaive.charges, snapshot.throwGlaive.maxCharges, snapshot.throwGlaive.startTime, snapshot.throwGlaive.duration, _ = GetSpellCharges(spells.throwGlaive.id)
		if snapshot.throwGlaive.charges == snapshot.throwGlaive.maxCharges then
			snapshot.throwGlaive.startTime = nil
			snapshot.throwGlaive.duration = 0
		end
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.demonhunter
		local snapshot = TRB.Data.snapshot

		if specId == 1 then
			local specSettings = classSettings.havoc
			UpdateSnapshot_Havoc()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentFury = snapshot.resource / TRB.Data.resourceFactor
					local metaTime = GetMetamorphosisRemainingTime()

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if snapshot.immolationAura.fury > 0 then
							passiveValue = passiveValue + snapshot.immolationAura.fury
						end

						if snapshot.tacticalRetreat.fury > 0 then
							passiveValue = passiveValue + snapshot.tacticalRetreat.fury
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentFury + snapshot.casting.resourceFinal
					else
						castingBarValue = currentFury
					end

					if castingBarValue < currentFury then --Using a spender
						if -snapshot.casting.resourceFinal > passiveValue then
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
							local normalizedFury = snapshot.resource / TRB.Data.resourceFactor

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
									if snapshot.bladeDance.startTime ~= nil and currentTime < (snapshot.bladeDance.startTime + snapshot.bladeDance.duration) then
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

									if snapshot.chaosNova.startTime ~= nil and currentTime < (snapshot.chaosNova.startTime + snapshot.chaosNova.duration) then
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
										if snapshot.throwGlaive.charges == 0 then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif snapshot.resource >= -furyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									else
										showThreshold = false
									end
								elseif spell.id == TRB.Data.spells.chaosStrike.id or spell.id == TRB.Data.spells.annihilation.id then
									if snapshot.chaosTheory.endTime ~= nil and currentTime < snapshot.chaosTheory.endTime then
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
								if (snapshot[spell.settingKey].charges == nil or snapshot[spell.settingKey].charges == 0) and
									(snapshot[spell.settingKey].startTime ~= nil and currentTime < (snapshot[spell.settingKey].startTime + snapshot[spell.settingKey].duration)) then
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

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end
					
					local barColor = specSettings.colors.bar.base
					if snapshot.metamorphosis.isActive then
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

						if specSettings.audio.overcap.enabled and snapshot.audio.overcapCue == false then
							snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						snapshot.audio.overcapCue = false
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
		local spells = TRB.Data.spells
		local snapshot = TRB.Data.snapshot

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if sourceGUID == TRB.Data.character.guid then 
				if specId == 1 and TRB.Data.barConstructedForSpec == "havoc" then --Havoc
					if spellId == spells.bladeDance.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.bladeDance.startTime, snapshot.bladeDance.duration, _, _ = GetSpellCooldown(spells.bladeDance.id)
						end
					elseif spellId == spells.deathSweep.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.bladeDance.startTime, snapshot.bladeDance.duration, _, _ = GetSpellCooldown(spells.deathSweep.id)
						end
					elseif spellId == spells.chaosNova.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.chaosNova.startTime, snapshot.chaosNova.duration, _, _ = GetSpellCooldown(spells.chaosNova.id)
						end
					elseif spellId == spells.eyeBeam.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.eyeBeam.startTime, snapshot.eyeBeam.duration, _, _ = GetSpellCooldown(spells.eyeBeam.id)
						end
					elseif spellId == spells.glaiveTempest.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.glaiveTempest.startTime, snapshot.glaiveTempest.duration, _, _ = GetSpellCooldown(spells.glaiveTempest.id)
						end
					elseif spellId == spells.throwGlaive.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.throwGlaive.charges, snapshot.throwGlaive.maxCharges, snapshot.throwGlaive.startTime, snapshot.throwGlaive.duration, _ = GetSpellCharges(spells.throwGlaive.id)
						end
					elseif spellId == spells.felEruption.id then
						if type == "SPELL_CAST_SUCCESS" then
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							snapshot.felEruption.startTime, snapshot.felEruption.duration, _, _ = GetSpellCooldown(spells.felEruption.id)
						end
					elseif spellId == spells.metamorphosis.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.metamorphosis)
					elseif spellId == spells.immolationAura.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							local felfireHeartDurationMod = 0
							local felfireHeartTicksMod = 0
							
							if TRB.Functions.Talent:IsTalentActive(spells.felfireHeart) then
								felfireHeartDurationMod = spells.felfireHeart.duration * TRB.Data.talents[spells.felfireHeart.id].currentRank
								felfireHeartTicksMod = spells.felfireHeart.ticks * TRB.Data.talents[spells.felfireHeart.id].currentRank
							end

							snapshot.immolationAura.isActive = true
							snapshot.immolationAura.ticksRemaining = spells.burningHatred.ticks + felfireHeartTicksMod
							
							if TRB.Functions.Talent:IsTalentActive(spells.burningHatred) then
								snapshot.immolationAura.fury = snapshot.immolationAura.ticksRemaining * spells.burningHatred.fury
							else
								snapshot.immolationAura.fury = 0
							end

							snapshot.immolationAura.endTime = currentTime + spells.burningHatred.duration + felfireHeartDurationMod
							snapshot.immolationAura.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							snapshot.immolationAura.isActive = false
							snapshot.immolationAura.ticksRemaining = 0
							snapshot.immolationAura.fury = 0
							snapshot.immolationAura.endTime = nil
							snapshot.immolationAura.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							snapshot.immolationAura.ticksRemaining = snapshot.immolationAura.ticksRemaining - 1
							snapshot.immolationAura.fury = snapshot.immolationAura.ticksRemaining * spells.burningHatred.fury
							snapshot.immolationAura.lastTick = currentTime
						end
					elseif spellId == spells.unboundChaos.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.unboundChaos)
					elseif spellId == spells.chaosTheory.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, snapshot.chaosTheory)
					elseif spellId == spells.tacticalRetreat.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Tactical Retreat
							snapshot.tacticalRetreat.isActive = true
							snapshot.tacticalRetreat.ticksRemaining = spells.tacticalRetreat.ticks
							snapshot.tacticalRetreat.fury = snapshot.tacticalRetreat.ticksRemaining * spells.tacticalRetreat.fury
							snapshot.tacticalRetreat.endTime = currentTime + spells.tacticalRetreat.duration
							snapshot.tacticalRetreat.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then -- It shouldn't refresh but let's check for it anyway
							snapshot.tacticalRetreat.ticksRemaining = spells.tacticalRetreat.ticks + 1
							snapshot.tacticalRetreat.fury = snapshot.tacticalRetreat.ticksRemaining * spells.tacticalRetreat.fury
							snapshot.tacticalRetreat.endTime = currentTime + spells.tacticalRetreat.duration + ((spells.tacticalRetreat.duration / spells.tacticalRetreat.ticks) - (currentTime - snapshot.tacticalRetreat.lastTick))
							snapshot.tacticalRetreat.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							snapshot.tacticalRetreat.isActive = false
							snapshot.tacticalRetreat.ticksRemaining = 0
							snapshot.tacticalRetreat.fury = 0
							snapshot.tacticalRetreat.endTime = nil
							snapshot.tacticalRetreat.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							snapshot.tacticalRetreat.ticksRemaining = snapshot.tacticalRetreat.ticksRemaining - 1
							snapshot.tacticalRetreat.fury = snapshot.tacticalRetreat.ticksRemaining * spells.tacticalRetreat.fury
							snapshot.tacticalRetreat.lastTick = currentTime
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
		if specId == 1 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.demonhunter.havoc)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.demonhunter.havoc)
			specCache.havoc.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Havoc()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.havoc)
			
			local spells = TRB.Data.spells
			---@type TRB.Classes.TargetData
			TRB.Data.snapshot.targetData = TRB.Classes.TargetData:New()
			
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
		local snapshot = TRB.Data.snapshot

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.demonhunter.havoc.displayBar.alwaysShow) and (
						(not TRB.Data.settings.demonhunter.havoc.displayBar.notZeroShow) or
						(TRB.Data.settings.demonhunter.havoc.displayBar.notZeroShow and snapshot.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				snapshot.isTracking = false
			else
				snapshot.isTracking = true
				if TRB.Data.settings.demonhunter.havoc.displayBar.neverShow == true then
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

		if guid ~= nil and guid ~= "" then
			---@type TRB.Classes.TargetData
			local targetData = TRB.Data.snapshot.targetData
			if not targetData:CheckTargetExists(guid) then
				targetData:InitializeTarget(guid)
			end
			TRB.Data.snapshot.targetData.targets[guid].lastUpdate = GetTime()
			return true
		end
		return false
	end

	function TRB.Functions.Class:IsValidVariableForSpec(var)
		local valid = TRB.Functions.BarText:IsValidVariableBase(var)
		local normalizedFury = TRB.Data.snapshot.resource / TRB.Data.resourceFactor
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local snapshot = TRB.Data.snapshot
		--local spells = TRB.Data.spells
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
				if snapshot.immolationAura.fury > 0 then
					valid = true
				end
			elseif var == "$bhTicks" or var == "$iaTicks" then
				if snapshot.immolationAura.ticksRemaining > 0 then
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
				if snapshot.tacticalRetreat.fury > 0 then
					valid = true
				end
			elseif var == "$tacticalRetreatTicks" then
				if snapshot.tacticalRetreat.ticksRemaining > 0 then
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
				(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$furyPlusCasting" then
			if normalizedFury > 0 or
				(snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$furyOvercap" or var == "$resourceOvercap" then
			local threshold = ((snapshot.resource / TRB.Data.resourceFactor) + snapshot.casting.resourceFinal)
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
			if snapshot.casting.resourceRaw ~= nil and snapshot.casting.resourceRaw ~= 0 then
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