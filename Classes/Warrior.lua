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
			barTextVariables = {}
		},
		fury = {
			snapshotData = {},
			barTextVariables = {}
		}
	}

	local function FillSpecCache()
		-- Arms

		specCache.arms.Global_TwintopResourceBar = {
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

		specCache.arms.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			petGuid = UnitGUID("pet"),
			specId = 1,
			maxResource = 100,
			covenantId = 0,
			talents = {
				suddenDeath = {
					isSelected = false
				},
				skullsplitter = {
					isSelected = false
				},
				impendingVictory = {
					isSelected = false
				},
				massacre = {
					isSelected = false
				},
				rend = {
					isSelected = false
				},
				cleave = {
					isSelected = false
				},
				deadlyCalm = {
					isSelected = false
				},
				ravager = {
					isSelected = false
				},				
			},
			items = {
			}
		}

		specCache.arms.spells = {
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
				rage = -20,
				rageMax = -40,
				thresholdId = 1,
				settingKey = "execute",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true
			},
			ignorePain = {
				id = 190456,
				name = "",
				icon = "",
				rage = -40,
				thresholdId = 2,
				settingKey = "ignorePain",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false
			},
			shieldBlock = {
				id = 2565,
				name = "",
				icon = "",
				rage = -30,
				thresholdId = 3,
				settingKey = "shieldBlock",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false			
			},
			slam = {
				id = 1464,
				name = "",
				icon = "",
				rage = -20,
				thresholdId = 4,
				settingKey = "slam",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false				
			},
			whirlwind = {
				id = 1680,
				name = "",
				icon = "",
				rage = -30,
				thresholdId = 5,
				settingKey = "whirlwind",
				isTalent = false,
				hasCooldown = false,
				thresholdUsable = false				
			},
			
			--Arms base abilities
			mortalStrike = {
				id = 12294,
				name = "",
				icon = "",
				rage = -30,
				thresholdId = 6,
				settingKey = "mortalStrike",
				isTalent = false,
				hasCooldown = true,
				thresholdUsable = false	
			},			
			
			--Talents
			suddenDeath = {
				id = 52437,
				name = "",
				icon = ""				
			},
			skullsplitter = {
				id = 100,
				name = "",
				icon = "",
				rage = 20				
			},
			impendingVictory = {
				id = 202168,
				name = "",
				icon = "",
				rage = -10,
				thresholdId = 7,
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
				id = 281001,
				name = "",
				icon = "",
				healthMinimum = 0.35			
			},
			rend = {
				id = 772,
				name = "",
				icon = "",
				rage = -30,
				thresholdId = 8,
				settingKey = "rend",
				isTalent = true,
				hasCooldown = false,
				thresholdUsable = false					
			},
			cleave = {
				id = 845,
				name = "",
				icon = "",
				rage = -20,
				thresholdId = 9,
				settingKey = "cleave",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false					
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
			spearOfBastion = {
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
				thresholdId = 10,
				settingKey = "condemn",
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
				rage = 4
			},
			ancientAftershock = {
				id = 325886,
				name = "",
				icon = "",
				duration = 12,
				ticks = 4,
				rage = 4
			}
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
		specCache.arms.snapshotData.mortalStrike = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.impendingVictory = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.victoryRush = {
			endTime = nil,
			duration = 0,
			spellId = nil
		}
		specCache.arms.snapshotData.ignorePain = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.arms.snapshotData.cleave = {
			startTime = nil,
			duration = 0,
			enabled = false
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
		TRB.Data.snapshotData.conquerorsBanner = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil
		}
		TRB.Data.snapshotData.ancientAftershock = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil,
			targetsHit = 0,
			hitTime = nil,
			hasStruckTargets = false
		}

        specCache.arms.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Arms()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.arms)
	end

	local function FillSpellData_Arms()
		Setup_Arms()
		local spells = TRB.Functions.FillSpellData(specCache.arms.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.arms.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the rage generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via it's spell ID (e.g.: #spell_2691_).", printInSettings = true },

            --[[
			{ variable = "#aMurderOfCrows", icon = spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#arcaneShot", icon = spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barbedShot", icon = spells.barbedShot.icon, description = "Barbed Shot", printInSettings = true },
			{ variable = "#barrage", icon = spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#beastialWrath", icon = spells.beastialWrath.icon, description = "Beastial Wrath", printInSettings = true },
			{ variable = "#chimaeraShot", icon = spells.chimaeraShot.icon, description = "Chimaera Shot", printInSettings = true },
			{ variable = "#cobraShot", icon = spells.cobraShot.icon, description = "Cobra Shot", printInSettings = true },
			{ variable = "#flayedShot", icon = spells.flayedShot.icon, description = "Flayed Shot", printInSettings = true },
			{ variable = "#flayersMark", icon = spells.flayersMark.icon, description = "Flayer's Mark", printInSettings = true },
			{ variable = "#frenzy", icon = spells.frenzy.icon, description = "Frenzy", printInSettings = true },
			{ variable = "#killCommand", icon = spells.killCommand.icon, description = "Kill Command", printInSettings = true },
			{ variable = "#killShot", icon = spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#multiShot", icon = spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#nesingwarys", icon = spells.nesingwarysTrappingApparatus.icon, description = "Nesingwary'ss Trapping Apparatus", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
            { variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
            ]]
        }
		specCache.arms.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },

			{ variable = "$rage", description = "Current Rage", printInSettings = true, color = false },
            { variable = "$resource", description = "Current Rage", printInSettings = false, color = false },
			{ variable = "$rageMax", description = "Maximum Rage", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Rage", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Rage from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$casting", description = "Spender Rage from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Rage from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$ragePlusCasting", description = "Current + Casting Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$ragePlusPassive", description = "Current + Passive Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Rage Total", printInSettings = false, color = false },
			{ variable = "$rageTotal", description = "Current + Passive + Casting Rage Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Rage Total", printInSettings = false, color = false },   
            --[[
			{ variable = "$frenzyTime", description = "Time remaining on your pet's Frenzy buff", printInSettings = true, color = false }, 
			{ variable = "$frenzyStacks", description = "Current stack count on your pet's Frenzy buff", printInSettings = true, color = false },   

			{ variable = "$barbedShotTicks", description = "Total number of Barbed Shot buff ticks remaining", printInSettings = true, color = false },
			{ variable = "$barbedShotTime", description = "Time remaining until the most recent Barbed Shot buff expires", printInSettings = true, color = false },

			{ variable = "$flayersMarkTime", description = "Time remaining on Flayer's Mark buff", printInSettings = true, color = false },

			{ variable = "$nesingwarysTime", description = "Time remaining on Nesingwary's Trapping Apparatus buff", printInSettings = true, color = false },
            ]]
			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
            { variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.arms.spells = spells
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "warrior"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage)
		TRB.Data.character.covenantId = C_Covenants.GetActiveCovenantID()

        if GetSpecialization() == 1 then		
			TRB.Data.character.specName = "arms"            
			TRB.Data.character.talents.suddenDeath.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.skullsplitter.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.impendingVictory.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.massacre.isSelected = select(4, GetTalentInfo(3, 1, TRB.Data.character.specGroup))
            TRB.Data.character.talents.rend.isSelected = select(4, GetTalentInfo(3, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.cleave.isSelected = select(4, GetTalentInfo(5, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.deadlyCalm.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.ravager.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))
        elseif GetSpecialization() == 2 then
		elseif GetSpecialization() == 3 then
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

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
		if specId == 1 then
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
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
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
            CheckCharacter()
            
			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true			
		end
	end

	local function InitializeTarget(guid)
		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
			TRB.Data.snapshotData.targetData.targets[guid].rend = false
		end
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function GetSuddenDeathRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.suddenDeath)
	end

    local function CalculateAbilityResourceValue(resource, includeDeadlyCalm)
        if includeDeadlyCalm == nil then
			includeDeadlyCalm = false
		end

		local modifier = 1.0
		
		if resource > 0 then
			--[[if GetSpecialization() == 1 then
				if TRB.Data.spells.trueshot.isActive then
					modifier = modifier * TRB.Data.spells.trueshot.modifier
				end
			end

			if TRB.Data.spells.nesingwarysTrappingApparatus.isActive then
				modifier = modifier * TRB.Data.spells.nesingwarysTrappingApparatus.modifier
			end]]
		else
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

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local rendTotal = 0
    	for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
				TRB.Data.snapshotData.targetData.targets[guid].rend = false
				TRB.Data.snapshotData.targetData.targets[guid].rendRemaining = 0
			else
				if TRB.Data.snapshotData.targetData.targets[guid].rend == true then
					rendTotal = rendTotal + 1
				end
			end
		end
		TRB.Data.snapshotData.targetData.rend = rendTotal
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.rend = 0
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
            if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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
		local normalizedRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.warrior.arms
		end

        if specId == 1 then --Arms
            --[[
			if var == "$barbedShotRage" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.rage > 0 then
					valid = true
				end
			elseif var == "$barbedShotTicks" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.rage > 0 then
					valid = true
				end
			elseif var == "$barbedShotTime" then
				if TRB.Data.snapshotData.barbedShot.isActive or TRB.Data.snapshotData.barbedShot.count > 0 or TRB.Data.snapshotData.barbedShot.rage > 0 then
					valid = true
				end
			elseif var == "$frenzyTime" then
				if TRB.Data.snapshotData.frenzy.endTime ~= nil then
					valid = true
				end
			elseif var == "$frenzyStacks" then
				if TRB.Data.snapshotData.frenzy.stacks ~= nil and TRB.Data.snapshotData.frenzy.stacks > 0 then
					valid = true
				end
            end
            ]]
		end

		if var == "$resource" or var == "$rage" then
			if normalizedRage > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$rageMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$rageTotal" then
			if normalizedRage > 0 or TRB.Data.snapshotData.ravager.rage > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$ragePlusCasting" then
			if normalizedRage > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$rageOvercap" or var == "$resourceOvercap" then
			if ((normalizedRage / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
			if normalizedRage > 0 or TRB.Data.snapshotData.ravager.rage > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			--[[if normalizedRage < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then]]
			if TRB.Data.snapshotData.ravager.rage > 0 then
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
				if	spell ~= nil and spell.thresholdUsable == true then
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

		local _ravagerRage = TRB.Data.snapshotData.ravager.rage
		local ravagerRage = string.format("%.0f", TRB.Data.snapshotData.ravager.rage)
		local ravagerTicks = string.format("%.0f", TRB.Data.snapshotData.ravager.ticksRemaining)
        
		--$rage
		local ragePrecision = TRB.Data.settings.warrior.arms.ragePrecision or 0
		local currentRage = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(normalizedRage, ragePrecision, "floor"))
		--$casting
		local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, ragePrecision, "floor"))
		--$passive
		local _passiveRage = _ravagerRage

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

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveRage

		lookup = TRB.Data.lookup or {}
		--[[lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
		lookup["#arcaneShot"] = TRB.Data.spells.arcaneShot.icon
		lookup["#barbedShot"] = TRB.Data.spells.barbedShot.icon
		lookup["#barrage"] = TRB.Data.spells.barrage.icon
		lookup["#beastialWrath"] = TRB.Data.spells.beastialWrath.icon
		lookup["#chimaeraShot"] = TRB.Data.spells.chimaeraShot.icon
		lookup["#cobraShot"] = TRB.Data.spells.cobraShot.icon
		lookup["#flayedShot"] = TRB.Data.spells.flayedShot.icon
		lookup["#flayersMark"] = TRB.Data.spells.flayersMark.icon
		lookup["#frenzy"] = TRB.Data.spells.frenzy.icon
		lookup["#killCommand"] = TRB.Data.spells.killCommand.icon
		lookup["#killShot"] = TRB.Data.spells.killShot.icon
		lookup["#multiShot"] = TRB.Data.spells.multiShot.icon
		lookup["#nesingwarys"] = TRB.Data.spells.nesingwarysTrappingApparatus.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon]]
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
		local specId = GetSpecialization()
		local currentSpell = UnitCastingInfo("player")
		local currentChannel = UnitChannelInfo("player")
        TRB.Functions.ResetCastingSnapshotData()

		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpell == nil then
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
			end
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()
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
			TRB.Data.snapshotData.mortalStrike.startTime, TRB.Data.snapshotData.mortalStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.mortalStrike.id)
        end

		if TRB.Data.snapshotData.impendingVictory.startTime ~= nil and currentTime > (TRB.Data.snapshotData.impendingVictory.startTime + TRB.Data.snapshotData.impendingVictory.duration) then
			TRB.Data.snapshotData.impendingVictory.startTime = nil
            TRB.Data.snapshotData.impendingVictory.duration = 0
		elseif TRB.Data.snapshotData.impendingVictory.startTime ~= nil then
			TRB.Data.snapshotData.impendingVictory.startTime, TRB.Data.snapshotData.impendingVictory.duration, _, _ = GetSpellCooldown(TRB.Data.spells.impendingVictory.id)
        end

		if TRB.Data.snapshotData.ignorePain.startTime ~= nil and currentTime > (TRB.Data.snapshotData.ignorePain.startTime + TRB.Data.snapshotData.ignorePain.duration) then
            TRB.Data.snapshotData.ignorePain.startTime = nil
            TRB.Data.snapshotData.ignorePain.duration = 0
		elseif TRB.Data.snapshotData.ignorePain.startTime ~= nil then
			TRB.Data.snapshotData.ignorePain.startTime, TRB.Data.snapshotData.ignorePain.duration, _, _ = GetSpellCooldown(TRB.Data.spells.ignorePain.id)
        end

		if TRB.Data.snapshotData.cleave.startTime ~= nil and currentTime > (TRB.Data.snapshotData.cleave.startTime + TRB.Data.snapshotData.cleave.duration) then
            TRB.Data.snapshotData.cleave.startTime = nil
            TRB.Data.snapshotData.cleave.duration = 0
		elseif TRB.Data.snapshotData.cleave.startTime ~= nil then
			TRB.Data.snapshotData.cleave.startTime, TRB.Data.snapshotData.cleave.duration, _, _ = GetSpellCooldown(TRB.Data.spells.cleave.id)
        end

		_, _, TRB.Data.snapshotData.suddenDeath.stacks, _, TRB.Data.snapshotData.suddenDeath.duration, TRB.Data.snapshotData.suddenDeath.endTime, _, _, _, TRB.Data.snapshotData.suddenDeath.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.suddenDeath.id, "player")
		_, _, TRB.Data.snapshotData.deadlyCalm.stacks, _, TRB.Data.snapshotData.deadlyCalm.duration, TRB.Data.snapshotData.deadlyCalm.endTime, _, _, _, TRB.Data.snapshotData.deadlyCalm.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.deadlyCalm.id, "player")
	end  

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if force or ((not affectingCombat) and
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
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.warrior.arms.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					local currentRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor	

					local passiveValue = 0
					if TRB.Data.settings.warrior.arms.bar.showPassive then
						if TRB.Data.snapshotData.ravager.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.ravager.rage
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

					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then							
							local rageAmount = CalculateAbilityResourceValue(spell.rage)
							local normalizedRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

							if spell.id ~= TRB.Data.spells.execute.id then
								TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholdWidth, -rageAmount, TRB.Data.character.maxResource)
							end

							local showThreshold = true
							local isUsable = true -- Could use it if we had enough rage, e.g. not on CD
							local thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
							local frameLevel = 129

							if spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
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
									local healthThreshold = TRB.Data.spells.execute.healthThreshold
									
									if TRB.Data.character.talents.massacre.isSelected then
										healthThreshold = TRB.Data.spells.massacre.healthThreshold
									end

									if GetSuddenDeathRemainingTime() > 0 then
										TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholdWidth, -TRB.Data.spells.execute.rageMax, TRB.Data.character.maxResource)
									else
										TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholdWidth, math.min(math.max(-rageAmount, normalizedRage), -TRB.Data.spells.execute.rageMax), TRB.Data.character.maxResource)
									end

									if not showThis then
										showThreshold = false
										isUsable = false
									elseif spell.id == TRB.Data.spells.condemn.id and (UnitIsDeadOrGhost("target") or targetUnitHealth == nil or (targetUnitHealth <= TRB.Data.spells.condemn.healthAbove and targetUnitHealth >= TRB.Data.spells.execute.healthMinimum)) then
										showThreshold = false
										isUsable = false
									elseif spell.id == TRB.Data.spells.execute.id and (UnitIsDeadOrGhost("target") or targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.execute.healthMinimum) then
										showThreshold = false
										isUsable = false
									elseif currentRage >= -rageAmount then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.impendingVictory.id then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
										frameLevel = 127
									elseif currentRage >= -rageAmount or TRB.Data.spells.victoryRush.isActive then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
										frameLevel = 128
									end
								end
							elseif spell.hasCooldown then
								if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
									frameLevel = 127
									isUsable = false
								elseif currentRage >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if currentRage >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.warrior.arms.thresholds[spell.settingKey].enabled and showThreshold then								
								if isUsable and TRB.Data.snapshotData.deadlyCalm.stacks ~= nil and TRB.Data.snapshotData.deadlyCalm.stacks > 0 then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									frameLevel = 129
								end

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
					local barColor = TRB.Data.settings.warrior.arms.colors.bar.base

					local latency = TRB.Functions.GetLatency()

					local barBorderColor = TRB.Data.settings.warrior.arms.colors.bar.border

					if TRB.Data.settings.warrior.arms.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderColor = TRB.Data.settings.warrior.arms.colors.bar.borderOvercap

						if TRB.Data.settings.warrior.arms.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
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
							TRB.Data.snapshotData.mortalStrike.startTime, TRB.Data.snapshotData.mortalStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.mortalStrike.id)
						end
					elseif spellId == TRB.Data.spells.impendingVictory.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.impendingVictory.startTime, TRB.Data.snapshotData.impendingVictory.duration, _, _ = GetSpellCooldown(TRB.Data.spells.impendingVictory.id)
						end
					elseif spellId == TRB.Data.spells.victoryRush.id then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, _, _, TRB.Data.snapshotData.victoryRush.duration, TRB.Data.snapshotData.victoryRush.endTime, _, _, _, TRB.Data.snapshotData.victoryRush.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.victoryRush.id)
							TRB.Data.spells.victoryRush.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.victoryRush.endTime = nil
							TRB.Data.snapshotData.victoryRush.duration = 0
							TRB.Data.snapshotData.victoryRush.stacks = 0
							TRB.Data.spells.victoryRush.isActive = false
						end
					elseif spellId == TRB.Data.spells.ignorePain.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.ignorePain.startTime, TRB.Data.snapshotData.ignorePain.duration, _, _ = GetSpellCooldown(TRB.Data.spells.ignorePain.id)
						end
					elseif spellId == TRB.Data.spells.cleave.id then
						if type == "SPELL_CAST_SUCCESS" then
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
								PlaySoundFile(TRB.Data.settings.hunter.marksmanship.audio.aimedShot.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.deadlyCalm.endTime = nil
							TRB.Data.snapshotData.deadlyCalm.duration = 0
							TRB.Data.snapshotData.deadlyCalm.spellId = nil
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
							end
						end
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
		if classIndex == 1 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Warrior.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					FillSpecCache()
					FillSpellData_Arms()

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
					TRB.Options.Warrior.ConstructOptionsPanel(specCache)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "PLAYER_SPECIALIZATION_CHANGED" then
					if specId == 1 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.warrior.arms)
						TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
						FillSpellData_Arms()
						TRB.Functions.LoadFromSpecCache(specCache.arms)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Arms
						
						if TRB.Data.barConstructedForSpec ~= "arms" then
							TRB.Data.barConstructedForSpec = "arms"
							ConstructResourceBar(TRB.Data.settings.warrior.arms)
						end
					end
					EventRegistration()
					TRB.Functions.HideResourceBar()
				end
			end
		end
	end)
end
