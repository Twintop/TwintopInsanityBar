local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 12 then --Only do this if we're on a DemonHunter!
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
			}
		}
	}

	local function FillSpecCache()
		-- Havoc

		specCache.havoc.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0,
				burningHatred = 0,
			},
			dots = {
			},
			burningHatred = {
				fury = 0,
				ticks = 0
			}
		}

		specCache.havoc.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 120,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
			talents = {
				blindFury = {
					isSelected = false
				},
				demonicAppetite = {
					isSelected = false
				},
				felBlade = {
					isSelected = false
				},
				burningHatred = {
					isSelected = false
				},
				trailOfRuin = {
					isSelected = false
				},
				unboundChaos = {
					isSelected = false
				},
				glaiveTempest = {
					isSelected = false
				},
				firstBlood = {
					isSelected = false
				},
				unleashedPower = {
					isSelected = false
				},
				felEruption = {
					isSelected = false
				},
				momentum = {
					isSelected = false
				},
			},
			items = {
			}
		}

		specCache.havoc.spells = {
			--Demon Hunter base abilities
			immolationAura = {
				id = 258920,
				name = "",
				icon = "",
				fury = 20,
                cooldown = 30
			},
			metamorphosis = {
				id = 162264,
				name = "",
				icon = "",
			},

			--Havoc base abilities
            annihilation = {
				id = 201427,
				name = "",
				icon = "",
				fury = -40,
				thresholdId = 1,
				settingKey = "annihilation",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false,
				demonForm = true
			},
			bladeDance = {
				id = 188499,
				name = "",
				icon = "",
				fury = -35,
                cooldown = 9,
				thresholdId = 2,
				settingKey = "bladeDance",
				isTalent = false,
				hasCooldown = true,
				thresholdUsable = false,
				demonForm = false
			},
            chaosNova = {
               id = 179057,
               name = "",
               icon = "",
               fury = -30,
			   thresholdId = 3,
			   settingKey = "chaosNova",
			   isTalent = false,
			   hasCooldown = true,
			   thresholdUsable = false
            },
            chaosStrike = {
               id = 162794,
               name = "",
               icon = "",
               fury = -40,
			   thresholdId = 4,
			   settingKey = "chaosStrike",
			   isTalent = false,
			   hasCooldown = false,
			   thresholdUsable = false,
			   demonForm = false
            },
			deathSweep = {
				id = 210152,
				name = "",
				icon = "",
				fury = -35,
                cooldown = 9,
				thresholdId = 5,
				settingKey = "bladeDance", --Same as bladeDance
				isTalent = false,
				hasCooldown = true,
				thresholdUsable = false,
				demonForm = true
			},
            demonsBite = {
               id = 162243,
               name = "",
               icon = "",
               fury = 20,
               furyMax = 30
            },
            eyeBeam = {
               id = 198013,
               name = "",
               icon = "",
               fury = -30,
               duration = 2,
			   thresholdId = 6,
			   settingKey = "eyeBeam",
			   isTalent = false,
			   hasCooldown = true,
			   thresholdUsable = false
            },

			--Talents
			blindFury = {
				id = 203550,
				name = "",
				icon = "",
                durationModifier = 1.5,
                tickRate = 0.1,
                fury = 4,
                isHasted = true
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
			burningHatred = {
				id = 258920,
				name = "",
				icon = "",
                fury = 5,
                ticks = 12,
                duration = 12
			},
			trailOfRuin = {
				id = 258881,
				name = "",
				icon = "",
				fury = 5,
				furyMax = 10
			},
			unboundChaos = {
				id = 347462,
				name = "",
				icon = "",
                duration = 20
			},
			glaiveTempest = {
				id = 342817,
				name = "",
				icon = "",
                fury = -30,
                cooldown = 20,
				thresholdId = 7,
				settingKey = "glaiveTempest",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			firstBlood = {
				id = 206416,
				name = "",
				icon = "",
                furyAdjustment = -20
			},
			unleashedPower = {
				id = 206477,
				name = "",
				icon = "",
                furyModifier = 0
			},
			felEruption = {
				id = 211881,
				name = "",
				icon = "",
				fury = -10,
				cooldown = 30,
				thresholdId = 8,
				settingKey = "felEruption",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			momentum = {
				id = 206476,
				name = "",
				icon = "",
			},
			prepared = {
				id = 203650,
				name = "",
				icon = "",
                fury = 1,
                ticks = 80,
                duration = 10
			},
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
		specCache.havoc.snapshotData.eyeBeam = {
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
		specCache.havoc.snapshotData.prepared = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil
		}
		--[[
		specCache.havoc.snapshotData.deadlyCalm = {
			endTime = nil,
			duration = 0,
			stacks = 0
		}
		specCache.havoc.snapshotData.suddenDeath = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.havoc.snapshotData.ravager = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil,
			totalDuration = 0
		}
		specCache.havoc.snapshotData.condemn = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.havoc.snapshotData.conquerorsBanner = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.havoc.snapshotData.ancientAftershock = {
			isActive = false,
			ticksRemaining = 0,
			fury = 0,
			endTime = nil,
			lastTick = nil,
			targetsHit = 0,
			hitTime = nil
		}
        ]]
	end

	local function Setup_Havoc()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.havoc)
	end

	local function FillSpellData_Havoc()
		Setup_Havoc()
		local spells = TRB.Functions.FillSpellData(specCache.havoc.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.havoc.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Fury generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
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
			{ variable = "#prepared", icon = spells.prepared.icon, description = spells.prepared.name, printInSettings = true },
			{ variable = "#trailOfRuin", icon = spells.trailOfRuin.icon, description = spells.trailOfRuin.name, printInSettings = true },
			{ variable = "#unboundChaos", icon = spells.unboundChaos.icon, description = spells.unboundChaos.name, printInSettings = true },
			{ variable = "#unleashedPower", icon = spells.unleashedPower.icon, description = spells.unleashedPower.name, printInSettings = true },

        }
		specCache.havoc.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility% (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versatility", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility% (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility% (damage reduction/defensive)", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

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

			{ variable = "$preparedFury", description = "Fury from Prepared (if talented)", printInSettings = true, color = false },
			{ variable = "$preparedTicks", description = "Number of ticks left on Prepared (if talented)", printInSetting = true, color = false },
			{ variable = "$preparedTime", description = "Time remaining on Prepared (if talented)", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
            { variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.havoc.spells = spells
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "demonhunter"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Fury)

        if GetSpecialization() == 1 then
			TRB.Data.character.specName = "havoc"
            TRB.Data.character.talents.blindFury.isSelected = select(4, GetTalentInfo(1, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.demonicAppetite.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.felBlade.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.trailOfRuin.isSelected = select(4, GetTalentInfo(2, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.burningHatred.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
            TRB.Data.character.talents.unboundChaos.isSelected = select(4, GetTalentInfo(3, 2, TRB.Data.character.specGroup))
            TRB.Data.character.talents.glaiveTempest.isSelected = select(4, GetTalentInfo(3, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.firstBlood.isSelected = select(4, GetTalentInfo(5, 2, TRB.Data.character.specGroup))
            TRB.Data.character.talents.unleashedPower.isSelected = select(4, GetTalentInfo(6, 1, TRB.Data.character.specGroup))
            TRB.Data.character.talents.felEruption.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.momentum.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.demonhunter.havoc == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.demonhunter.havoc)
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

	local function InitializeTarget(guid)
		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
			TRB.Data.snapshotData.targetData.targets[guid].rend = false
		end
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function GetImmolationAuraRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.immolationAura)
	end

	local function GetMetamorphosisRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.metamorphosis)
	end
	local function GetPreparedRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.prepared)
	end
	
	local function GetUnboundChaosRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.unboundChaos)
	end

    local function CalculateAbilityResourceValue(resource)
		local modifier = 1.0 * TRB.Data.character.effects.overgrowthSeedlingModifier

        return resource * modifier
    end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function InitializeTarget(guid)
		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
		end
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.rend = 0
		end
	end

	local function ConstructResourceBar(settings)
		local entries = TRB.Functions.TableLength(TRB.Frames.resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end
		end

		local resourceFrameCounter = 1
        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.fury ~= nil and spell.fury < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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
			elseif var == "$preparedFury" then
				if TRB.Data.snapshotData.prepared.fury > 0 then
					valid = true
				end
			elseif var == "$preparedTicks" then
				if TRB.Data.snapshotData.prepared.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$preparedTime" then
				if GetPreparedRemainingTime() > 0 then
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
			if normalizedFury > 0  or IsValidVariableForSpec("$passive") or IsValidVariableForSpec("$bhFury") or
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
			local lowerBoundFury = TRB.Data.spells.demonsBite.fury

			if TRB.Data.character.talents.trailOfRuin.isSelected then
				lowerBoundFury = lowerBoundFury + TRB.Data.spells.trailOfRuin.fury
			end

			if TRB.Data.snapshotData.casting.resourceFinal == 0 and ((normalizedFury / TRB.Data.resourceFactor) + lowerBoundFury) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$furyPlusPassive" then
			if normalizedFury > 0 or IsValidVariableForSpec("$passive") or IsValidVariableForSpec("$bhFury") then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if IsValidVariableForSpec("$bhFury") then
				valid = true
			end
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Havoc()
		local _
		local normalizedFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.current
		local castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.casting

		if TRB.Data.settings.demonhunter.havoc.colors.text.overcapEnabled and overcap then
			currentFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.overcap
            --castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.overcap
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
				--castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.spending
		end

		--$metamorphosisTime
		local _metamorphosisTime = GetMetamorphosisRemainingTime()
		local metamorphosisTime = 0
		if _metamorphosisTime ~= nil then
			metamorphosisTime = string.format("%.1f", _metamorphosisTime)
		end

		--$metamorphosisTime
		local _unboundChaosTime = GetUnboundChaosRemainingTime()
		local unboundChaosTime = 0
		if _unboundChaosTime ~= nil then
			unboundChaosTime = string.format("%.1f", _unboundChaosTime)
		end

		--$bhFury
		local bhFury = TRB.Data.snapshotData.immolationAura.fury

		--$bhTicks and $iaTicks
		local bhTicks = TRB.Data.snapshotData.immolationAura.ticksRemaining

		--$bhTime and $iaTime
		local _bhTime = GetImmolationAuraRemainingTime()
		local bhTime = 0
		if _bhTime ~= nil then
			bhTime = string.format("%.1f", _bhTime)
		end

		--$preparedFury
		local preparedFury = TRB.Data.snapshotData.prepared.fury

		--$preparedTicks
		local preparedTicks = TRB.Data.snapshotData.prepared.ticksRemaining

		--$preparedTime
		local _preparedTime = GetPreparedRemainingTime()
		local preparedTime = 0
		if _preparedTime ~= nil then
			preparedTime = string.format("%.1f", _preparedTime)
		end

		--$fury
		local furyPrecision = TRB.Data.settings.demonhunter.havoc.furyPrecision or 0
		local currentFury = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.RoundTo(normalizedFury, furyPrecision, "floor"))
		--$casting
		local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, furyPrecision, "floor"))
		--$passive
		local _passiveFury = bhFury + preparedFury

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		local passiveFury = string.format("|c%s%s|r", TRB.Data.settings.demonhunter.havoc.colors.text.passive, TRB.Functions.RoundTo(_passiveFury, furyPrecision, "floor"))
		
		--$furyTotal
		local _furyTotal = math.min(_passiveFury + TRB.Data.snapshotData.casting.resourceFinal + normalizedFury, TRB.Data.character.maxResource)
		local furyTotal = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.RoundTo(_furyTotal, furyPrecision, "floor"))
		--$furyPlusCasting
		local _furyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedFury, TRB.Data.character.maxResource)
		local furyPlusCasting = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.RoundTo(_furyPlusCasting, furyPrecision, "floor"))
		--$furyPlusPassive
		local _furyPlusPassive = math.min(_passiveFury + normalizedFury, TRB.Data.character.maxResource)
		local furyPlusPassive = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.RoundTo(_furyPlusPassive, furyPrecision, "floor"))
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedFury
		Global_TwintopResourceBar.resource.passive = _passiveFury
		Global_TwintopResourceBar.resource.burningHatred = bhFury
		Global_TwintopResourceBar.resource.prepared = preparedFury
		Global_TwintopResourceBar.burningHatred = {
			fury = bhFury,
			ticks = bhTicks,
			time = bhTime
		}
		Global_TwintopResourceBar.prepared = {
			fury = preparedFury,
			ticks = preparedTicks,
			time = preparedTime
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
		lookup["#prepared"] = TRB.Data.spells.prepared.icon
		lookup["#trailOfRuin"] = TRB.Data.spells.trailOfRuin.icon
		lookup["#unboundChaos"] = TRB.Data.spells.unboundChaos.icon
		lookup["#unleashedPower"] = TRB.Data.spells.unleashedPower.icon
		lookup["$metaTime"] = metamorphosisTime
		lookup["$metamorphosisTime"] = metamorphosisTime
		lookup["$bhFury"] = bhFury
		lookup["$bhTicks"] = bhTicks
		lookup["$iaTicks"] = bhTicks
		lookup["$iaTime"] = bhTime
		lookup["$bhTime"] = bhTime
		lookup["$preparedFury"] = preparedFury
		lookup["$preparedTicks"] = preparedTicks
		lookup["$preparedTime"] = preparedTime
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
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.eyeBeam.id and TRB.Data.character.talents.blindFury.isSelected then
						local gcd = TRB.Functions.GetCurrentGCDTime(true)
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.eyeBeam.id
						TRB.Data.snapshotData.casting.startTime = currentChannelStartTime / 1000
						TRB.Data.snapshotData.casting.endTime = currentChannelEndTime / 1000
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.eyeBeam.icon
						local remainingTime = TRB.Data.snapshotData.casting.endTime - currentTime
						local ticks = TRB.Functions.RoundTo(remainingTime / (TRB.Data.spells.blindFury.tickRate * (gcd / 1.5)), 0, "ceil")
						local fury = ticks * TRB.Data.spells.blindFury.fury
						TRB.Data.snapshotData.casting.resourceRaw = fury
						TRB.Data.snapshotData.casting.resourceFinal = fury
						TRB.Data.snapshotData.eyeBeam.ticksRemaining = ticks
						TRB.Data.snapshotData.eyeBeam.fury = fury
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
						--See Priest implementation for handling channeled spells
					end
					return true
				else
					TRB.Functions.ResetCastingSnapshotData()
					return false
				end
			end
			TRB.Functions.ResetCastingSnapshotData()
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
				if TRB.Data.character.talents.burningHatred.isSelected then
					TRB.Data.snapshotData.immolationAura.fury = TRB.Data.snapshotData.immolationAura.ticksRemaining * TRB.Data.spells.burningHatred.fury
				else
					TRB.Data.snapshotData.immolationAura.fury = 0
				end
			end
		end
	end

	local function UpdatePrepared()
		if TRB.Data.snapshotData.prepared.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.prepared.endTime == nil or currentTime > TRB.Data.snapshotData.prepared.endTime then
				TRB.Data.snapshotData.prepared.ticksRemaining = 0
				TRB.Data.snapshotData.prepared.endTime = nil
				TRB.Data.snapshotData.prepared.fury = 0
				TRB.Data.snapshotData.prepared.isActive = false
			else
				TRB.Data.snapshotData.prepared.ticksRemaining = math.ceil((TRB.Data.snapshotData.prepared.endTime - currentTime) / (TRB.Data.spells.prepared.duration / TRB.Data.spells.prepared.ticks))
				TRB.Data.snapshotData.prepared.fury = TRB.Data.snapshotData.prepared.ticksRemaining * TRB.Data.spells.prepared.fury
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
				_, _, _, _, TRB.Data.snapshotData.metamorphosis.duration, TRB.Data.snapshotData.metamorphosis.endTime, _, _, _, TRB.Data.snapshotData.metamorphosis.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.metamorphosis.id)
			end
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Havoc()
		UpdateSnapshot()
		UpdateMetamorphosis()
		UpdateBurningHatred()
		UpdatePrepared()

		local currentTime = GetTime()
		local _

        if TRB.Data.snapshotData.bladeDance.startTime ~= nil and currentTime > (TRB.Data.snapshotData.bladeDance.startTime + TRB.Data.snapshotData.bladeDance.duration) then
			TRB.Data.snapshotData.bladeDance.startTime = nil
            TRB.Data.snapshotData.bladeDance.duration = 0
		elseif TRB.Data.snapshotData.bladeDance.startTime ~= nil then
			if GetMetamorphosisRemainingTime() > 0 then
				TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.deathSweep.id)
			else
				TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeDance.id)
			end
        end

        if TRB.Data.snapshotData.chaosNova.startTime ~= nil and currentTime > (TRB.Data.snapshotData.chaosNova.startTime + TRB.Data.snapshotData.chaosNova.duration) then
			TRB.Data.snapshotData.chaosNova.startTime = nil
            TRB.Data.snapshotData.chaosNova.duration = 0
		elseif TRB.Data.snapshotData.chaosNova.startTime ~= nil then
			TRB.Data.snapshotData.chaosNova.startTime, TRB.Data.snapshotData.chaosNova.duration, _, _ = GetSpellCooldown(TRB.Data.spells.chaosNova.id)
        end

		if TRB.Data.snapshotData.eyeBeam.startTime ~= nil and currentTime > (TRB.Data.snapshotData.eyeBeam.startTime + TRB.Data.snapshotData.eyeBeam.duration) then
            TRB.Data.snapshotData.eyeBeam.startTime = nil
            TRB.Data.snapshotData.eyeBeam.duration = 0
		elseif TRB.Data.snapshotData.eyeBeam.startTime ~= nil then
			TRB.Data.snapshotData.eyeBeam.startTime, TRB.Data.snapshotData.eyeBeam.duration, _, _ = GetSpellCooldown(TRB.Data.spells.eyeBeam.id)
        end

		if TRB.Data.snapshotData.glaiveTempest.startTime ~= nil and currentTime > (TRB.Data.snapshotData.glaiveTempest.startTime + TRB.Data.snapshotData.glaiveTempest.duration) then
            TRB.Data.snapshotData.glaiveTempest.startTime = nil
            TRB.Data.snapshotData.glaiveTempest.duration = 0
		elseif TRB.Data.snapshotData.glaiveTempest.startTime ~= nil then
			TRB.Data.snapshotData.glaiveTempest.startTime, TRB.Data.snapshotData.glaiveTempest.duration, _, _ = GetSpellCooldown(TRB.Data.spells.glaiveTempest.id)
        end

		if TRB.Data.snapshotData.felEruption.startTime ~= nil and currentTime > (TRB.Data.snapshotData.felEruption.startTime + TRB.Data.snapshotData.felEruption.duration) then
            TRB.Data.snapshotData.felEruption.startTime = nil
            TRB.Data.snapshotData.felEruption.duration = 0
		elseif TRB.Data.snapshotData.felEruption.startTime ~= nil then
			TRB.Data.snapshotData.felEruption.startTime, TRB.Data.snapshotData.felEruption.duration, _, _ = GetSpellCooldown(TRB.Data.spells.felEruption.id)
        end
	end

	local function HideResourceBar(force)
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
	TRB.Functions.HideResourceBar = HideResourceBar

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()

		if specId == 1 then
			UpdateSnapshot_Havoc()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.demonhunter.havoc)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.demonhunter.havoc.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
					local metaTime = GetMetamorphosisRemainingTime()

					local passiveValue = 0
					if TRB.Data.settings.demonhunter.havoc.bar.showPassive then
						if TRB.Data.snapshotData.immolationAura.fury > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.immolationAura.fury
						end

						if TRB.Data.snapshotData.prepared.fury > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.prepared.fury
						end
					end

					if CastingSpell() and TRB.Data.settings.demonhunter.havoc.bar.showCasting then
						castingBarValue = currentFury + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = currentFury
					end

					if castingBarValue < currentFury then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, resourceFrame, castingBarValue) 
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, passiveFrame, currentFury)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.demonhunter.havoc.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.demonhunter.havoc.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, castingFrame, currentFury)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.demonhunter.havoc.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.demonhunter.havoc.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, resourceFrame, currentFury)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.demonhunter.havoc, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.demonhunter.havoc.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.demonhunter.havoc.colors.bar.passive, true))
					end

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.fury ~= nil and spell.fury < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local furyAmount = CalculateAbilityResourceValue(spell.fury)
							local normalizedFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
							
							if spell.id == TRB.Data.spells.bladeDance.id and TRB.Data.character.talents.firstBlood.isSelected then
								furyAmount = furyAmount - TRB.Data.spells.firstBlood.furyAdjustment
							end

							TRB.Functions.RepositionThreshold(TRB.Data.settings.demonhunter.havoc, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.demonhunter.havoc.thresholdWidth, -furyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local isUsable = true -- Could use it if we had enough fury, e.g. not on CD
							local thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.over
							local frameLevel = 129
							if metaTime > 0 and (spell.demonForm ~= nil and spell.demonForm == false) then
								showThreshold = false
								isUsable = false
							elseif metaTime == 0 and (spell.demonForm ~= nil and spell.demonForm == true) then
								showThreshold = false
								isUsable = false
							elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
								showThreshold = false
								isUsable = false
							elseif spell.id == TRB.Data.spells.chaosNova.id and TRB.Data.character.talents.unleashedPower.isSelected then
								showThreshold = false
								isUsable = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.unusable
									frameLevel = 127
									isUsable = false
								elseif currentFury >= -furyAmount then
									thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if currentFury >= -furyAmount then
									thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.demonhunter.havoc.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
---@diagnostic disable-next-line: undefined-field
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
					
					local barColor = TRB.Data.settings.demonhunter.havoc.colors.bar.base
					if TRB.Data.snapshotData.metamorphosis.isActive then
						local timeThreshold = 0
						local useEndOfMetamorphosisColor = false

						if TRB.Data.settings.demonhunter.havoc.endOfMetamorphosis.enabled then
							useEndOfMetamorphosisColor = true
							if TRB.Data.settings.demonhunter.havoc.endOfMetamorphosis.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.demonhunter.havoc.endOfMetamorphosis.gcdsMax
							elseif TRB.Data.settings.demonhunter.havoc.endOfMetamorphosis.mode == "time" then
								timeThreshold = TRB.Data.settings.demonhunter.havoc.endOfMetamorphosis.timeMax
							end
						end

						if useEndOfMetamorphosisColor and metaTime <= timeThreshold then
							barColor = TRB.Data.settings.demonhunter.havoc.colors.bar.metamorphosisEnding
						else
							barColor = TRB.Data.settings.demonhunter.havoc.colors.bar.metamorphosis
						end
					end

					local barBorderColor = TRB.Data.settings.demonhunter.havoc.colors.bar.border

					if TRB.Data.settings.demonhunter.havoc.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.demonhunter.havoc.colors.bar.borderOvercap

						if TRB.Data.settings.demonhunter.havoc.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.demonhunter.havoc.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.demonhunter.havoc, refreshText)
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		if GetSpecialization() ~= 1 then
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
				if specId == 1 then --Havoc
                    if spellId == TRB.Data.spells.bladeDance.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeDance.id)
						end
					elseif spellId == TRB.Data.spells.deathSweep.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.deathSweep.id)
						end
					elseif spellId == TRB.Data.spells.chaosNova.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.chaosNova.startTime, TRB.Data.snapshotData.chaosNova.duration, _, _ = GetSpellCooldown(TRB.Data.spells.chaosNova.id)
						end
					elseif spellId == TRB.Data.spells.eyeBeam.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.eyeBeam.startTime, TRB.Data.snapshotData.eyeBeam.duration, _, _ = GetSpellCooldown(TRB.Data.spells.eyeBeam.id)
						end
					elseif spellId == TRB.Data.spells.glaiveTempest.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.glaiveTempest.startTime, TRB.Data.snapshotData.glaiveTempest.duration, _, _ = GetSpellCooldown(TRB.Data.spells.glaiveTempest.id)
						end
					elseif spellId == TRB.Data.spells.felEruption.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.felEruption.startTime, TRB.Data.snapshotData.felEruption.duration, _, _ = GetSpellCooldown(TRB.Data.spells.felEruption.id)
						end
					elseif spellId == TRB.Data.spells.metamorphosis.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.metamorphosis.isActive = true
							_, _, _, _, TRB.Data.snapshotData.metamorphosis.duration, TRB.Data.snapshotData.metamorphosis.endTime, _, _, _, TRB.Data.snapshotData.metamorphosis.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.metamorphosis.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.metamorphosis.isActive = false
							TRB.Data.snapshotData.metamorphosis.spellId = nil
							TRB.Data.snapshotData.metamorphosis.duration = 0
							TRB.Data.snapshotData.metamorphosis.endTime = nil
						end
					elseif spellId == TRB.Data.spells.burningHatred.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Burning Hatred
							TRB.Data.snapshotData.immolationAura.isActive = true
							TRB.Data.snapshotData.immolationAura.ticksRemaining = TRB.Data.spells.burningHatred.ticks
								
							if TRB.Data.character.talents.burningHatred.isSelected then
								TRB.Data.snapshotData.immolationAura.fury = TRB.Data.snapshotData.immolationAura.ticksRemaining * TRB.Data.spells.burningHatred.fury
							else
								TRB.Data.snapshotData.immolationAura.fury = 0
							end

							TRB.Data.snapshotData.immolationAura.endTime = currentTime + TRB.Data.spells.burningHatred.duration
							TRB.Data.snapshotData.immolationAura.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then -- It shouldn't refresh but let's check for it anyway
							TRB.Data.snapshotData.immolationAura.ticksRemaining = TRB.Data.spells.burningHatred.ticks + 1
							
							if TRB.Data.character.talents.burningHatred.isSelected then
								TRB.Data.snapshotData.immolationAura.fury = TRB.Data.snapshotData.immolationAura.ticksRemaining * TRB.Data.spells.burningHatred.fury
							else
								TRB.Data.snapshotData.immolationAura.fury = 0
							end

							TRB.Data.snapshotData.immolationAura.endTime = currentTime + TRB.Data.spells.burningHatred.duration + ((TRB.Data.spells.burningHatred.duration / TRB.Data.spells.burningHatred.ticks) - (currentTime - TRB.Data.snapshotData.immolationAura.lastTick))
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
							_, _, _, _, TRB.Data.snapshotData.unboundChaos.duration, TRB.Data.snapshotData.unboundChaos.endTime, _, _, _, TRB.Data.snapshotData.unboundChaos.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.unboundChaos.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.unboundChaos.isActive = false
							TRB.Data.snapshotData.unboundChaos.spellId = nil
							TRB.Data.snapshotData.unboundChaos.duration = 0
							TRB.Data.snapshotData.unboundChaos.endTime = nil
						end
					elseif spellId == TRB.Data.spells.prepared.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Prepared
							TRB.Data.snapshotData.prepared.isActive = true
							TRB.Data.snapshotData.prepared.ticksRemaining = TRB.Data.spells.prepared.ticks								
							TRB.Data.snapshotData.prepared.fury = TRB.Data.snapshotData.prepared.ticksRemaining * TRB.Data.spells.prepared.fury
							TRB.Data.snapshotData.prepared.endTime = currentTime + TRB.Data.spells.prepared.duration
							TRB.Data.snapshotData.prepared.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then -- It shouldn't refresh but let's check for it anyway
							TRB.Data.snapshotData.prepared.ticksRemaining = TRB.Data.spells.prepared.ticks + 1
							TRB.Data.snapshotData.prepared.fury = TRB.Data.snapshotData.prepared.ticksRemaining * TRB.Data.spells.prepared.fury
							TRB.Data.snapshotData.prepared.endTime = currentTime + TRB.Data.spells.prepared.duration + ((TRB.Data.spells.prepared.duration / TRB.Data.spells.prepared.ticks) - (currentTime - TRB.Data.snapshotData.prepared.lastTick))
							TRB.Data.snapshotData.prepared.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.prepared.isActive = false
							TRB.Data.snapshotData.prepared.ticksRemaining = 0
							TRB.Data.snapshotData.prepared.fury = 0
							TRB.Data.snapshotData.prepared.endTime = nil
							TRB.Data.snapshotData.prepared.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.prepared.ticksRemaining = TRB.Data.snapshotData.prepared.ticksRemaining - 1
							TRB.Data.snapshotData.prepared.fury = TRB.Data.snapshotData.prepared.ticksRemaining * TRB.Data.spells.prepared.fury
							TRB.Data.snapshotData.prepared.lastTick = currentTime
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
		if classIndex == 12 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.DemonHunter.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					FillSpecCache()
					FillSpellData_Havoc()

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
						C_Timer.After(5, function()
						TRB.Data.settings.demonhunter.havoc = TRB.Functions.ValidateLsmValues("Havoc Demon Hunter", TRB.Data.settings.demonhunter.havoc)
							TRB.Options.DemonHunter.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							ConstructResourceBar(TRB.Data.settings.demonhunter[TRB.Data.barConstructedForSpec])
							EventRegistration()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					if specId == 1 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.demonhunter.havoc)
						TRB.Functions.IsTtdActive(TRB.Data.settings.demonhunter.havoc)
						FillSpellData_Havoc()
						TRB.Functions.LoadFromSpecCache(specCache.havoc)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Havoc
						
						if TRB.Data.barConstructedForSpec ~= "havoc" then
							TRB.Data.barConstructedForSpec = "havoc"
							ConstructResourceBar(TRB.Data.settings.demonhunter.havoc)
						end
					end
					EventRegistration()
				end
			end
		end
	end)
end
