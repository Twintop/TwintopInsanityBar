local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 10 then --Only do this if we're on a Monk!
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
		windwalker = {
			snapshotData = {},
			barTextVariables = {}
		}
	}

	local function FillSpecCache()
		-- Windwalker
		specCache.windwalker.Global_TwintopResourceBar = {
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

		specCache.windwalker.character = {
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
				fistOfTheWhiteTiger = {
					isSelected = false
				},
				serenity = {
					isSelected = false
				}
			},
			items = {},
			torghast = {
				rampaging = {
					spellCostModifier = 1.0,
					coolDownReduction = 1.0
				}
			}
		}

		specCache.windwalker.spells = {
			-- Monk Class Abilities
            blackoutKick = {
				id = 100784,
				name = "",
				icon = "",
                comboPoints = 1,
			},
			cracklingJadeLightning = {
				id = 117952,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 0,
				texture = "",
				thresholdId = 1,
				settingKey = "cracklingJadeLightning",
				thresholdUsable = false
			},
			detox = {
				id = 218164,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 0,
				texture = "",
				thresholdId = 2,
				settingKey = "detox",
				hasCooldown = true,
				cooldown = 8,
				thresholdUsable = false
			},
			expelHarm = {
				id = 322101,
				name = "",
				icon = "",
				energy = -15,
                comboPointsGenerated = 1,
				texture = "",
				thresholdId = 3,
				settingKey = "expelHarm",
				hasCooldown = true,
                cooldown = 15,
				thresholdUsable = false
			},
			paralysis = {
				id = 115078,
				name = "",
				icon = "",
				energy = -20,
                comboPointsGenerated = 0,
				texture = "",
				thresholdId = 4,
				settingKey = "paralysis",
				hasCooldown = true,
                cooldown = 30, -- Assumes Rank2
				thresholdUsable = false
			},
			spinningCraneKick = {
				id = 101546,
				name = "",
				icon = "",
                comboPoints = 2,
			},
			tigerPalm = {
				id = 100780,
				name = "",
				icon = "",
				energy = -50,
                comboPointsGenerated = 2,
				texture = "",
				thresholdId = 5,
				settingKey = "tigerPalm",
				thresholdUsable = false
			},
			touchOfDeath = {
				id = 322109,
				name = "",
				icon = "",
				healthPercent = 0.35,
				eliteHealthPercent = 0.15
			},
			vivify = {
				id = 116670,
				name = "",
				icon = "",
				energy = -30,
                comboPointsGenerated = 0,
				texture = "",
				thresholdId = 6,
				settingKey = "vivify",
				thresholdUsable = false
			},

            -- Windwalker Spec Abilities

			disable = {
				id = 116095,
				name = "",
				icon = "",
				energy = -15,
                comboPoints = true,
				texture = "",
				thresholdId = 7,
				settingKey = "disable",
                hasCooldown = false,
				thresholdUsable = false
			},
			fistsOfFury = {
				id = 113656,
				name = "",
				icon = "",
                comboPoints = 3
			},
			invokeXuenTheWhiteTiger = {
				id = 123904,
				name = "",
				icon = ""
			},
			risingSunKick = {
				id = 107428,
				name = "",
				icon = "",
                comboPoints = 2
			},
			stormEarthAndFire = {
				id = 137639,
				name = "",
				icon = ""
			},

			-- Talents
			fistOfTheWhiteTiger = {
				id = 261947,
				name = "",
				icon = "",
				energy = -40,
				texture = "",
				comboPointsGenerated = 3,
				thresholdId = 8,
				settingKey = "fistOfTheWhiteTiger",
				hasCooldown = true,
				isTalent = true,
				thresholdUsable = false,
				cooldown = 30
			},
			energizingElixir = {
				id = 115288,
				name = "",
				icon = "",
				comboPointsGenerated = 2,
				energyPerTick = 15,
				ticks = 5,
				tickRate = 1,
				isTalent = true
			},
			rushingJadeWind = {
				id = 116847,
				name = "",
				icon = "",
				comboPoints = 1,
				isTalent = true
			},
			danceOfChiJi = {
				id = 325201,
				name = "",
				icon = ""
			},
			serenity = {
				id = 152173,
				name = "",
				icon = ""
			},
		}

		specCache.windwalker.snapshotData.energyRegen = 0
		specCache.windwalker.snapshotData.audio = {
			overcapCue = false
		}
		specCache.windwalker.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {}
		}
		specCache.windwalker.snapshotData.detox = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.expelHarm = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.paralysis = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.fistOfTheWhiteTiger = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.windwalker.snapshotData.serenity = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil
		}

		specCache.windwalker.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Windwalker()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.windwalker)
	end

	local function FillSpellData_Windwalker()
		Setup_Windwalker()
		local spells = TRB.Functions.FillSpellData(specCache.windwalker.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.windwalker.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#blackoutKick", icon = spells.blackoutKick.icon, description = spells.blackoutKick.name, printInSettings = true },
			{ variable = "#cracklingJadeLightning", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = true },
			{ variable = "#cjl", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = false },
			{ variable = "#danceOfChiJi", icon = spells.danceOfChiJi.icon, description = spells.danceOfChiJi.name, printInSettings = true },
			{ variable = "#detox", icon = spells.detox.icon, description = spells.detox.name, printInSettings = true },
			{ variable = "#disable", icon = spells.disable.icon, description = spells.disable.name, printInSettings = true },
			{ variable = "#energizingElixir", icon = spells.energizingElixir.icon, description = spells.energizingElixir.name, printInSettings = true },
			{ variable = "#expelHarm", icon = spells.expelHarm.icon, description = spells.expelHarm.name, printInSettings = true },
			{ variable = "#fistsOfFury", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = true },
			{ variable = "#fof", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = false },
			{ variable = "#fistOfTheWhiteTiger", icon = spells.fistOfTheWhiteTiger.icon, description = spells.fistOfTheWhiteTiger.name, printInSettings = true },
			{ variable = "#fotwt", icon = spells.fistOfTheWhiteTiger.icon, description = spells.fistOfTheWhiteTiger.name, printInSettings = false },
			{ variable = "#paralysis", icon = spells.paralysis.icon, description = spells.paralysis.name, printInSettings = true },
			{ variable = "#risingSunKick", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = true },
			{ variable = "#rsk", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = false },
			{ variable = "#rushingJadeWind", icon = spells.rushingJadeWind.icon, description = spells.rushingJadeWind.name, printInSettings = true },
			{ variable = "#rjw", icon = spells.rushingJadeWind.icon, description = spells.rushingJadeWind.name, printInSettings = false },
			{ variable = "#serenity", icon = spells.serenity.icon, description = spells.serenity.name, printInSettings = true },
			{ variable = "#spinningCraneKick", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = true },
			{ variable = "#sck", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = false },
			{ variable = "#stormEarthAndFire", icon = spells.stormEarthAndFire.icon, description = spells.stormEarthAndFire.name, printInSettings = true },
			{ variable = "#sef", icon = spells.stormEarthAndFire.icon, description = spells.stormEarthAndFire.name, printInSettings = false },			
			{ variable = "#tigerPalm", icon = spells.tigerPalm.icon, description = spells.tigerPalm.name, printInSettings = true },
			{ variable = "#touchOfDeath", icon = spells.touchOfDeath.icon, description = spells.touchOfDeath.name, printInSettings = true },
			{ variable = "#vivify", icon = spells.vivify.icon, description = spells.vivify.name, printInSettings = true },
			{ variable = "#xuen", icon = spells.invokeXuenTheWhiteTiger.icon, description = spells.invokeXuenTheWhiteTiger.name, printInSettings = true },
			{ variable = "#invokeXuenTheWhiteTiger", icon = spells.invokeXuenTheWhiteTiger.icon, description = spells.invokeXuenTheWhiteTiger.name, printInSettings = false },
        }
		specCache.windwalker.barTextVariables.values = {
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
			
			{ variable = "$chi", description = "Current Chi", printInSettings = true, color = false },
			{ variable = "$comboPoints", description = "Current Chi", printInSettings = false, color = false },
			{ variable = "$chiMax", description = "Maximum Chi", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Chi", printInSettings = false, color = false },

			{ variable = "$serenityTime", description = "Time remaining on Serenity buff", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.windwalker.spells = spells
	end

	local function CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "monk"
		TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
        local maxComboPoints = 0
        local settings = nil

		if specId == 3 then
			TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
			maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
            settings = TRB.Data.settings.monk.windwalker
			TRB.Data.character.specName = "windwalker"
			TRB.Data.character.talents.fistOfTheWhiteTiger.isSelected = select(4, GetTalentInfo(3, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.serenity.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))
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
		if specId == 3 and TRB.Data.settings.core.enabled.monk.windwalker == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.monk.windwalker)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.Chi
			TRB.Data.resource2Factor = 1
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
		
		if specId == 3 then
			if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
				TRB.Functions.InitializeTarget(guid)
			end
		end
		TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()

		return true
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget


	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end	

	local function GetSerenityRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.serenity)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
        
		if specId == 3 then -- Windwalker
			for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
				if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
				else
				end
			end
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 3 then
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
            if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
				if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
				TRB.Functions.SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell.settingKey, settings)

				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(0)
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
            end
        end
		TRB.Frames.resource2ContainerFrame:Show()

		TRB.Functions.ConstructResourceBar(settings)
		
		TRB.Functions.RepositionBar(settings, TRB.Frames.barContainerFrame)
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 3 then
			settings = TRB.Data.settings.monk.windwalker
		end

		if specId == 3 then --Windwalker
			if var == "$serenityTime" then
				if GetSerenityRemainingTime() > 0 then
					valid = true
				end			
			elseif var == "$resource" or var == "$energy" then
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
			elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
				if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$comboPoints" or var == "$chi" then
				valid = true
			elseif var == "$comboPointsMax"or var == "$chiMax" then
				valid = true
			end
		end

		if var == "$casting" then
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
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData_Windwalker()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshotData.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.current
		local castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.casting

		if TRB.Data.settings.monk.windwalker.colors.text.overcapEnabled and overcap then
			currentEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overcap
            castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overcap
		elseif TRB.Data.settings.monk.windwalker.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if	spell ~= nil and spell.thresholdUsable == true then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overThreshold
				castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.monk.windwalker.colors.text.spending
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

		if TRB.Data.settings.monk.windwalker.generation.enabled then
			if TRB.Data.settings.monk.windwalker.generation.mode == "time" then
				_regenEnergy = _regenEnergy * (TRB.Data.settings.monk.windwalker.generation.time or 3.0)
			else
				_regenEnergy = _regenEnergy * ((TRB.Data.settings.monk.windwalker.generation.gcds or 2) * _gcd)
			end
		else
			_regenEnergy = 0
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy --+ _barbedShotEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.monk.windwalker.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)
		
		--$serenityTime
		local _serenityTime = GetSerenityRemainingTime()
		local serenityTime = 0
		if _serenityTime ~= nil then
			serenityTime = string.format("%.1f", _serenityTime)
		end
		
		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.dots = {
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#blackoutKick"] = TRB.Data.spells.blackoutKick.icon
		lookup["#cracklingJadeLightning"] = TRB.Data.spells.cracklingJadeLightning.icon
		lookup["#cjl"] = TRB.Data.spells.cracklingJadeLightning.icon
		lookup["#danceOfChiJi"] = TRB.Data.spells.danceOfChiJi.icon
		lookup["#detox"] = TRB.Data.spells.detox.icon
		lookup["#disable"] = TRB.Data.spells.disable.icon
		lookup["#energizingElixir"] = TRB.Data.spells.energizingElixir.icon
		lookup["#expelHarm"] = TRB.Data.spells.expelHarm.icon
		lookup["#fistsOfFury"] = TRB.Data.spells.fistsOfFury.icon
		lookup["#fof"] = TRB.Data.spells.fistsOfFury.icon
		lookup["#fistOfTheWhiteTiger"] = TRB.Data.spells.fistOfTheWhiteTiger.icon
		lookup["#fotwt"] = TRB.Data.spells.fistOfTheWhiteTiger.icon
		lookup["#paralysis"] = TRB.Data.spells.paralysis.icon
		lookup["#risingSunKick"] = TRB.Data.spells.risingSunKick.icon
		lookup["#rsk"] = TRB.Data.spells.risingSunKick.icon
		lookup["#rushingJadeWind"] = TRB.Data.spells.rushingJadeWind.icon
		lookup["#rjw"] = TRB.Data.spells.rushingJadeWind.icon
		lookup["#serenity"] = TRB.Data.spells.serenity.icon
		lookup["#spinningCraneKick"] = TRB.Data.spells.spinningCraneKick.icon
		lookup["#sck"] = TRB.Data.spells.spinningCraneKick.icon
		lookup["#stormEarthAndFire"] = TRB.Data.spells.stormEarthAndFire.icon
		lookup["#sef"] = TRB.Data.spells.stormEarthAndFire.icon
		lookup["#tigerPalm"] = TRB.Data.spells.tigerPalm.icon
		lookup["#touchOfDeath"] = TRB.Data.spells.touchOfDeath.icon
		lookup["#vivify"] = TRB.Data.spells.vivify.icon
		lookup["#xuen"] = TRB.Data.spells.invokeXuenTheWhiteTiger.icon
		lookup["#invokeXuenTheWhiteTiger"] = TRB.Data.spells.invokeXuenTheWhiteTiger.icon

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
		lookup["$chi"] = TRB.Data.character.resource2
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$chiMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2

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
		lookup["$serenityTime"] = serenityTime
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
		local currentTime = GetTime()
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
		local specId = GetSpecialization()

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 3 then
				if currentSpellName == nil then
					if currentChannelId == TRB.Data.spells.cracklingJadeLightning.id then
						TRB.Data.snapshotData.casting.cracklingJadeLightning = TRB.Data.spells.cracklingJadeLightning.id
						TRB.Data.snapshotData.casting.startTime = currentTime
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.spells.cracklingJadeLightning.energy
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.cracklingJadeLightning.icon
						UpdateCastingResourceFinal()
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

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()

        if TRB.Data.snapshotData.detox.startTime ~= nil and currentTime > (TRB.Data.snapshotData.detox.startTime + TRB.Data.snapshotData.detox.duration) then
            TRB.Data.snapshotData.detox.startTime = nil
            TRB.Data.snapshotData.detox.duration = 0
        end

        if TRB.Data.snapshotData.expelHarm.startTime ~= nil and currentTime > (TRB.Data.snapshotData.expelHarm.startTime + TRB.Data.snapshotData.expelHarm.duration) then
            TRB.Data.snapshotData.expelHarm.startTime = nil
            TRB.Data.snapshotData.expelHarm.duration = 0
        end

        if TRB.Data.snapshotData.paralysis.startTime ~= nil and currentTime > (TRB.Data.snapshotData.paralysis.startTime + TRB.Data.snapshotData.paralysis.duration) then
            TRB.Data.snapshotData.paralysis.startTime = nil
            TRB.Data.snapshotData.paralysis.duration = 0
        end
	end

	local function UpdateSnapshot_Windwalker()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _
		
        if TRB.Data.snapshotData.fistOfTheWhiteTiger.startTime ~= nil and currentTime > (TRB.Data.snapshotData.fistOfTheWhiteTiger.startTime + TRB.Data.snapshotData.fistOfTheWhiteTiger.duration) then
            TRB.Data.snapshotData.fistOfTheWhiteTiger.startTime = nil
            TRB.Data.snapshotData.fistOfTheWhiteTiger.duration = 0
        end
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 3 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.monk.windwalker.displayBar.alwaysShow) and (
						(not TRB.Data.settings.monk.windwalker.displayBar.notZeroShow) or
						(TRB.Data.settings.monk.windwalker.displayBar.notZeroShow and TRB.Data.snapshotData.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshotData.isTracking = false
			else
				TRB.Data.snapshotData.isTracking = true
				if TRB.Data.settings.monk.windwalker.displayBar.neverShow == true then
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

		if specId == 3 then
			UpdateSnapshot_Windwalker()
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.monk.windwalker, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.monk.windwalker.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)

					local passiveValue = 0
					if TRB.Data.settings.monk.windwalker.bar.showPassive then
						if TRB.Data.settings.monk.windwalker.generation.enabled then
							if TRB.Data.settings.monk.windwalker.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshotData.energyRegen * (TRB.Data.settings.monk.windwalker.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshotData.energyRegen * ((TRB.Data.settings.monk.windwalker.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and TRB.Data.settings.monk.windwalker.bar.showCasting then
						castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshotData.resource
					end

					if castingBarValue < TRB.Data.snapshotData.resource then --Using a spender
						if -TRB.Data.snapshotData.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, castingFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, passiveFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, resourceFrame, castingBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, passiveFrame, passiveBarValue)
							TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, castingFrame, TRB.Data.snapshotData.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, resourceFrame, TRB.Data.snapshotData.resource)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, passiveFrame, passiveBarValue)
						TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.bar.passive, true))
					end

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then	
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.monk.windwalker, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.monk.windwalker.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.monk.windwalker.colors.threshold.over
							local frameLevel = 129

                            if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
                            elseif spell.isPvp and not TRB.Data.character.isPvp then
                                showThreshold = false
                            elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
                                showThreshold = false
                            elseif spell.hasCooldown then
                                if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
                                    thresholdColor = TRB.Data.settings.monk.windwalker.colors.threshold.unusable
                                    frameLevel = 127
                                elseif TRB.Data.snapshotData.resource >= -energyAmount then
                                    thresholdColor = TRB.Data.settings.monk.windwalker.colors.threshold.over
                                else
                                    thresholdColor = TRB.Data.settings.monk.windwalker.colors.threshold.under
                                    frameLevel = 128
                                end
                            else -- This is an active/available/normal spell threshold
                                if TRB.Data.snapshotData.resource >= -energyAmount then
                                    thresholdColor = TRB.Data.settings.monk.windwalker.colors.threshold.over
                                else
                                    thresholdColor = TRB.Data.settings.monk.windwalker.colors.threshold.under
                                    frameLevel = 128
                                end
                            end

							if spell.comboPoints == true and TRB.Data.snapshotData.resource2 == 0 then
								thresholdColor = TRB.Data.settings.monk.windwalker.colors.threshold.unusable
								frameLevel = 127
							end

							if TRB.Data.settings.monk.windwalker.thresholds[spell.settingKey].enabled and showThreshold then
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(frameLevel)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon:SetFrameLevel(frameLevel+10)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.resourceFrame.thresholds[spell.thresholdId].icon:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(thresholdColor, true))
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

					local barColor = TRB.Data.settings.monk.windwalker.colors.bar.base
					if TRB.Data.snapshotData.serenity.spellId and TRB.Data.settings.monk.windwalker.endOfSerenity.enabled then
						local timeThreshold = 0
						if TRB.Data.settings.monk.windwalker.endOfSerenity.mode == "gcd" then
							local gcd = TRB.Functions.GetCurrentGCDTime()
							timeThreshold = gcd * TRB.Data.settings.monk.windwalker.endOfSerenity.gcdsMax
						elseif TRB.Data.settings.monk.windwalker.endOfSerenity.mode == "time" then
							timeThreshold = TRB.Data.settings.monk.windwalker.endOfSerenity.timeMax
						end
						
						if GetSerenityRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.monk.windwalker.colors.bar.serenityEnd
						else
							barColor = TRB.Data.settings.monk.windwalker.colors.bar.serenity
						end
					end

					local barBorderColor = TRB.Data.settings.monk.windwalker.colors.bar.border
					if TRB.Data.settings.monk.windwalker.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.monk.windwalker.colors.bar.borderOvercap

						if TRB.Data.settings.monk.windwalker.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.monk.windwalker.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.GetRGBAFromString(TRB.Data.settings.monk.windwalker.colors.comboPoints.background, true)

                    for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = TRB.Data.settings.monk.windwalker.colors.comboPoints.border
						local cpColor = TRB.Data.settings.monk.windwalker.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

                        if TRB.Data.snapshotData.resource2 >= x then
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (TRB.Data.settings.monk.windwalker.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not TRB.Data.settings.monk.windwalker.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = TRB.Data.settings.monk.windwalker.colors.comboPoints.penultimate
							elseif (TRB.Data.settings.monk.windwalker.comboPoints.sameColor and TRB.Data.snapshotData.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
								cpColor = TRB.Data.settings.monk.windwalker.colors.comboPoints.final
							end
                        else
                            TRB.Functions.SetBarCurrentValue(TRB.Data.settings.monk.windwalker, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
                        end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
                    end
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.monk.windwalker, refreshText)
		end
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 3 then
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
				if specId == 3 then --Windwalker
					if spellId == TRB.Data.spells.fistOfTheWhiteTiger.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.fistOfTheWhiteTiger.startTime = currentTime
							TRB.Data.snapshotData.fistOfTheWhiteTiger.duration = TRB.Data.spells.fistOfTheWhiteTiger.cooldown
						end
					elseif spellId == TRB.Data.spells.serenity.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.serenity.isActive = true
							_, _, _, _, TRB.Data.snapshotData.serenity.duration, TRB.Data.snapshotData.serenity.endTime, _, _, _, TRB.Data.snapshotData.serenity.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.serenity.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.serenity.isActive = false
							TRB.Data.snapshotData.serenity.spellId = nil
							TRB.Data.snapshotData.serenity.duration = 0
							TRB.Data.snapshotData.serenity.endTime = nil
						end
					end
				end

				-- Spec agnostic
				if spellId == TRB.Data.spells.detox.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.detox.startTime = currentTime
						TRB.Data.snapshotData.detox.duration = TRB.Data.spells.detox.cooldown
					end
				elseif spellId == TRB.Data.spells.expelHarm.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.expelHarm.startTime = currentTime
						TRB.Data.snapshotData.expelHarm.duration = TRB.Data.spells.expelHarm.cooldown
					end
				elseif spellId == TRB.Data.spells.paralysis.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.paralysis.startTime = currentTime
						TRB.Data.snapshotData.paralysis.duration = TRB.Data.spells.paralysis.cooldown
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
		elseif specId == 2 then
		elseif specId == 3 then
			TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.monk.windwalker)
			TRB.Functions.IsTtdActive(TRB.Data.settings.monk.windwalker)
			FillSpellData_Windwalker()
			TRB.Functions.LoadFromSpecCache(specCache.windwalker)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Windwalker

			if TRB.Data.barConstructedForSpec ~= "windwalker" then
				TRB.Data.barConstructedForSpec = "windwalker"
				ConstructResourceBar(TRB.Data.settings.monk.windwalker)
			end
		end
		EventRegistration()
	end

	resourceFrame:RegisterEvent("ADDON_LOADED")
	resourceFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local specId = GetSpecialization() or 0
		if classIndexId == 10 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Monk.LoadDefaultSettings()
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
							TRB.Data.barConstructedForSpec = nil
							TRB.Data.settings.monk.windwalker = TRB.Functions.ValidateLsmValues("Windwalker Monk", TRB.Data.settings.monk.windwalker)
							FillSpellData_Windwalker()
							SwitchSpec()

							TRB.Options.Monk.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							if TRB.Data.barConstructedForSpec ~= nil then
								ConstructResourceBar(TRB.Data.settings.monk[TRB.Data.barConstructedForSpec])
							end
							EventRegistration()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					SwitchSpec()
				end
			end
		end
	end)
end
