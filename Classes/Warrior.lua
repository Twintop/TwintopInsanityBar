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
				scentOfBlood = {
					isSelected = false
				},
			},
			items = {
			}
		}

		specCache.arms.spells = {
			arcaneShot = {
				id = 185358,
				name = "",
				icon = "",
				rage = -20,
				thresholdId = 1,
				settingKey = "arcaneShot",
				thresholdUsable = false
			},
		}

		specCache.arms.snapshotData.audio = {
		}
		specCache.arms.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {}
		}

        specCache.arms.barTextVariables = {
			icons = {},
			values = {}
		}


		-- Fury

		specCache.fury.Global_TwintopResourceBar = {
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

		specCache.fury.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 2,
			maxResource = 100,
			covenantId = 0,
			talents = {
				serpentSting = {
					isSelected = false
				},           
			},
			items = {
			}
		}

		specCache.fury.spells = {
			aimedShot = {
				id = 19434,
				name = "",
				icon = "",
				rage = -35,
				thresholdId = 1,
				settingKey = "aimedShot",
				isSnowflake = true,
				thresholdUsable = false
			},
		}

		specCache.fury.snapshotData.audio = {
		}
		specCache.fury.snapshotData.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {}
		}

		specCache.fury.barTextVariables = {
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

	local function Setup_Fury()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.LoadFromSpecCache(specCache.fury)
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

	local function FillSpellData_Fury()
		Setup_Fury()
		local spells = TRB.Functions.FillSpellData(specCache.fury.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.fury.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the rage generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via it's spell ID (e.g.: #spell_2691_).", printInSettings = true },
            --[[
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
			{ variable = "#nesingwarys", icon = spells.nesingwarysTrappingApparatus.icon, description = "Nesingwary'ss Trapping Apparatus", printInSettings = true },
			{ variable = "#rapidFire", icon = spells.rapidFire.icon, description = "Rapid Fire", printInSettings = true },
			{ variable = "#revivePet", icon = spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#steadyShot", icon = spells.steadyShot.icon, description = "Steady Shot", printInSettings = true },
			{ variable = "#trickShots", icon = spells.trickShots.icon, description = "Trick Shots", printInSettings = true },
			{ variable = "#trueshot", icon = spells.trueshot.icon, description = "Trueshot", printInSettings = true },
            { variable = "#vigil", icon = spells.secretsOfTheUnblinkingVigil.icon, description = "Secrets of the Unblinking Vigil", printInSettings = true },
            ]]
        }
		specCache.fury.barTextVariables.values = {
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
			{ variable = "$passive", description = "Rage from Passive Sources including Regen", printInSettings = true, color = false },
			{ variable = "$ragePlusCasting", description = "Current + Casting Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$ragePlusPassive", description = "Current + Passive Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Rage Total", printInSettings = false, color = false },
			{ variable = "$rageTotal", description = "Current + Passive + Casting Rage Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Rage Total", printInSettings = false, color = false },   

            --[[
			{ variable = "$trueshotTime", description = "Time remaining on Trueshot buff", printInSettings = true, color = false },   
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$serpentSting", description = "Is Serpent Sting talented? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$flayersMarkTime", description = "Time remaining on Flayer's Mark buff", printInSettings = true, color = false },

			{ variable = "$vigilTime", description = "Time remaining on Secrets of the Unblinking Vigil buff", printInSettings = true, color = false },
			{ variable = "$nesingwarysTime", description = "Time remaining on Nesingwary's Trapping Apparatus buff", printInSettings = true, color = false },
            ]]
			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.fury.spells = spells
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "warrior"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage)
		TRB.Data.character.covenantId = C_Covenants.GetActiveCovenantID()

        if GetSpecialization() == 1 then		
			TRB.Data.character.specName = "arms"
            --[[
			TRB.Data.character.talents.scentOfBlood.isSelected = select(4, GetTalentInfo(2, 1, TRB.Data.character.specGroup))
			TRB.Data.character.talents.chimaeraShot.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.barrage.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
            ]]
        elseif GetSpecialization() == 2 then
			TRB.Data.character.specName = "fury"
            --[[
			TRB.Data.character.talents.serpentSting.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.barrage.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
			TRB.Data.character.talents.explosiveShot.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.chimaeraShot.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
			TRB.Data.character.talents.deadEye.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
            TRB.Data.character.talents.doubleTap.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
            ]]
		elseif GetSpecialization() == 3 then
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
		if specId == 1 then
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
			TRB.Data.specSupported = true
            CheckCharacter()
            
			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
            
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = true
		elseif specId == 2 then
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.fury)
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
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

    local function CalculateAbilityResourceValue(resource)
        local modifier = 1.0
        --[[
		if resource > 0 then
			if GetSpecialization() == 2 then
				if TRB.Data.spells.trueshot.isActive then
					modifier = modifier * TRB.Data.spells.trueshot.modifier
				end
			end

			if TRB.Data.spells.nesingwarysTrappingApparatus.isActive then
				modifier = modifier * TRB.Data.spells.nesingwarysTrappingApparatus.modifier
			end
		else
			if GetSpecialization() == 2 then
				if TRB.Data.spells.eagletalonsTrueRage.isActive then
					modifier = modifier * TRB.Data.spells.eagletalonsTrueRage.modifier
				end
			end
		end
        ]]
        return resource * modifier
    end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
        --[[
    	for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
			else
			end
		end
		]]
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
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
        elseif specId == 2 then --Fury
            --[[
			if var == "$trueshotTime" then
				if GetTrueshotRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$vigilTime" then
				if GetVigilRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$serpentSting" then
				if TRB.Data.character.talents.serpentSting.isSelected then
					valid = true
				end
            end
            ]]
		end

		if var == "$resource" or var == "$rage" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$rageMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$rageTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$ragePlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$rageOvercap" or var == "$resourceOvercap" then
			if ((TRB.Data.snapshotData.resource / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$ragePlusPassive" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if TRB.Data.snapshotData.resource < TRB.Data.character.maxResource--[[and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0))]] then
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
        
		--$rage
		local currentRage = string.format("|c%s%.0f|r", currentRageColor, normalizedRage)
		--$casting
		local castingRage = string.format("|c%s%.0f|r", castingRageColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _passiveRage

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

        _passiveRage = 0

		local passiveRage = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.passive, _passiveRage)
		
		--$rageTotal
		local _rageTotal = math.min(_passiveRage + TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local rageTotal = string.format("|c%s%.0f|r", currentRageColor, _rageTotal)
		--$ragePlusCasting
		local _ragePlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusCasting = string.format("|c%s%.0f|r", castingRageColor, _ragePlusCasting)
		--$ragePlusPassive
		local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusPassive = string.format("|c%s%.0f|r", currentRageColor, _ragePlusPassive)

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
				if	spell ~= nil and spell.thresholdUsable == true then
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
        
		--$rage
		local currentRage = string.format("|c%s%.0f|r", currentRageColor, normalizedRage)
		--$casting
		local castingRage = string.format("|c%s%.0f|r", castingRageColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _passiveRage = 0

		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		local passiveRage = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.fury.colors.text.passive, _passiveRage)
		--$rageTotal
		local _rageTotal = math.min(_passiveRage + TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local rageTotal = string.format("|c%s%.0f|r", currentRageColor, _rageTotal)
		--$ragePlusCasting
		local _ragePlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusCasting = string.format("|c%s%.0f|r", castingRageColor, _ragePlusCasting)
		--$ragePlusPassive
		local _ragePlusPassive = math.min(_passiveRage + normalizedRage, TRB.Data.character.maxResource)
		local ragePlusPassive = string.format("|c%s%.0f|r", currentRageColor, _ragePlusPassive)

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveRage
		Global_TwintopResourceBar.resource.regen = _regenRage
		Global_TwintopResourceBar.dots = {
			ssCount = serpentStingCount or 0
		}

		lookup = TRB.Data.lookup or {}
		--[[lookup["#aMurderOfCrows"] = TRB.Data.spells.aMurderOfCrows.icon
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
		lookup["#nesingwarys"] = TRB.Data.spells.nesingwarysTrappingApparatus.icon
		lookup["#rapidFire"] = TRB.Data.spells.rapidFire.icon
		lookup["#revivePet"] = TRB.Data.spells.revivePet.icon
		lookup["#scareBeast"] = TRB.Data.spells.scareBeast.icon
		lookup["#serpentSting"] = TRB.Data.spells.serpentSting.icon
		lookup["#steadyShot"] = TRB.Data.spells.steadyShot.icon
		lookup["#trickShots"] = TRB.Data.spells.trickShots.icon
		lookup["#trueshot"] = TRB.Data.spells.trueshot.icon
		lookup["#vigil"] = TRB.Data.spells.secretsOfTheUnblinkingVigil.icon]]
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
        return false
        --[[
		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					if spellName == TRB.Data.spells.barrage.name then
						TRB.Data.spells.barrage.thresholdUsable = false
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
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
			elseif specId == 2 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
					if spellName == TRB.Data.spells.rapidFire.name then
						TRB.Data.snapshotData.rapidFire.isActive = true
						TRB.Data.snapshotData.rapidFire.duration = (select(5, UnitChannelInfo("player")) - select(4, UnitChannelInfo("player"))) / 1000
						TRB.Data.snapshotData.rapidFire.endTime = select(5, UnitChannelInfo("player")) / 1000
						TRB.Data.snapshotData.casting.startTime = select(4, UnitChannelInfo("player")) / 1000
						TRB.Data.snapshotData.casting.spellId = TRB.Data.spells.rapidFire.id
						TRB.Data.snapshotData.casting.icon = TRB.Data.spells.rapidFire.icon
						UpdateRapidFire()
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
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
					TRB.Functions.ResetCastingSnapshotData()
					return false
					--See Priest implementation for handling channeled spells
				else
					if spellName == TRB.Data.spells.scareBeast.name then
						FillSnapshotDataCasting(TRB.Data.spells.scareBeast)
					elseif spellName == TRB.Data.spells.revivePet.name then
						FillSnapshotDataCasting(TRB.Data.spells.revivePet)
					else
						TRB.Functions.ResetCastingSnapshotData()
						return false
					end
				end
			end
			TRB.Functions.ResetCastingSnapshotData()
			return false
		end]]
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()

        --[[
        if TRB.Data.snapshotData.aMurderOfCrows.startTime ~= nil and currentTime > (TRB.Data.snapshotData.aMurderOfCrows.startTime + TRB.Data.snapshotData.aMurderOfCrows.duration) then
            TRB.Data.snapshotData.aMurderOfCrows.startTime = nil
            TRB.Data.snapshotData.aMurderOfCrows.duration = 0
        end

        if TRB.Data.snapshotData.flayedShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.flayedShot.startTime + TRB.Data.snapshotData.flayedShot.duration) then
            TRB.Data.snapshotData.flayedShot.startTime = nil
            TRB.Data.snapshotData.flayedShot.duration = 0
        end
        ]]
	end

	local function UpdateSnapshot_Arms()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _

        --[[
        if TRB.Data.snapshotData.barrage.startTime ~= nil and currentTime > (TRB.Data.snapshotData.barrage.startTime + TRB.Data.snapshotData.barrage.duration) then
			TRB.Data.snapshotData.barrage.startTime = nil
            TRB.Data.snapshotData.barrage.duration = 0
		end

		if TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration) then
            TRB.Data.snapshotData.killShot.startTime = nil
            TRB.Data.snapshotData.killShot.duration = 0
        end
		
		if TRB.Data.snapshotData.killCommand.startTime ~= nil and currentTime > (TRB.Data.snapshotData.killCommand.startTime + TRB.Data.snapshotData.killCommand.duration) then
            TRB.Data.snapshotData.killCommand.startTime = nil
            TRB.Data.snapshotData.killCommand.duration = 0
		elseif TRB.Data.snapshotData.killCommand.startTime ~= nil then
			TRB.Data.snapshotData.killCommand.startTime, TRB.Data.snapshotData.killCommand.duration, _, _ = GetSpellCooldown(TRB.Data.spells.killCommand.id)
        end

		_, _, TRB.Data.snapshotData.frenzy.stacks, _, TRB.Data.snapshotData.frenzy.duration, TRB.Data.snapshotData.frenzy.endTime, _, _, _, TRB.Data.snapshotData.frenzy.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.frenzy.id, "pet")
        TRB.Data.snapshotData.beastialWrath.startTime, TRB.Data.snapshotData.beastialWrath.duration, _, _ = GetSpellCooldown(TRB.Data.spells.beastialWrath.id)
        ]]
	end  

	local function UpdateSnapshot_Fury()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _

        --[[
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
        ]]
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
		elseif specId == 2 then
			if force or ((not affectingCombat) and
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
			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.warrior.arms.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					local currentRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor	

					local passiveValue = 0

					if CastingSpell() then
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

                    --[[
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local rageAmount = CalculateAbilityResourceValue(spell.rage)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.arms, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.arms.thresholdWidth, -rageAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
							local frameLevel = 129

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local flayersMarkTime = GetFlayersMarkRemainingTime()
									if (targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum) and flayersMarkTime == 0 then
										showThreshold = false
									elseif flayersMarkTime == 0 and (TRB.Data.snapshotData.killShot.startTime ~= nil and currentTime < (TRB.Data.snapshotData.killShot.startTime + TRB.Data.snapshotData.killShot.duration)) then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -rageAmount or flayersMarkTime > 0 then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.killCommand.id then	
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -rageAmount or TRB.Data.spells.flamewakersCobraSting.isActive then
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.flayedShot.id then
									local flayersMarkTime = GetFlayersMarkRemainingTime() -- Change this to layer stacking if the cost of Kill Shot or Flayed Shot changes from 10 Rage!
									if TRB.Data.character.covenantId == 2 and flayersMarkTime == 0 then -- Venthyr and Flayer's Mark buff isn't up
										if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -rageAmount then
											thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
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
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.unusable
									frameLevel = 127
								elseif TRB.Data.snapshotData.resource >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.arms.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.warrior.arms.thresholds[spell.settingKey].enabled and showThreshold then
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
                    ]]
					local barColor = TRB.Data.settings.warrior.arms.colors.bar.base

					local latency = TRB.Functions.GetLatency()

                    --[[
					local barbedShotRechargeRemaining = -(currentTime - (TRB.Data.snapshotData.barbedShot.startTime + TRB.Data.snapshotData.barbedShot.duration))
					local barbedShotTotalRechargeRemaining = barbedShotRechargeRemaining + ((1 - TRB.Data.snapshotData.barbedShot.charges) * TRB.Data.snapshotData.barbedShot.duration)
					local barbedShotPartialCharges = TRB.Data.snapshotData.barbedShot.charges + (barbedShotRechargeRemaining / TRB.Data.snapshotData.barbedShot.duration)
					local beastialWrathCooldownRemaining = GetBeastialWrathCooldownRemainingTime()
					local frenzyRemainingTime = GetFrenzyRemainingTime()
					local affectingCombat = UnitAffectingCombat("player")
					local reactionTimeGcds = math.min(gcd * 1.5, 2)

					if TRB.Data.spells.frenzy.isActive then
						if TRB.Data.snapshotData.barbedShot.charges == 2 then
							barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
						elseif TRB.Data.snapshotData.barbedShot.charges == 1 and frenzyRemainingTime <= reactionTimeGcds then
							barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
						elseif barbedShotTotalRechargeRemaining <= reactionTimeGcds and beastialWrathCooldownRemaining > 0 then
							barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
						elseif barbedShotRechargeRemaining <= reactionTimeGcds and TRB.Data.snapshotData.barbedShot.charges == 1 then
							barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
						elseif TRB.Data.character.talents.scentOfBlood.isSelected and barbedShotTotalRechargeRemaining <= reactionTimeGcds and beastialWrathCooldownRemaining < (TRB.Data.spells.barbedShot.beastialWrathCooldownReduction + reactionTimeGcds) then
							barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
						elseif TRB.Data.character.talents.scentOfBlood.isSelected and TRB.Data.snapshotData.barbedShot.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * TRB.Data.spells.barbedShot.beastialWrathCooldownReduction) then
							barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
						end
					else
						if affectingCombat then
							if TRB.Data.snapshotData.barbedShot.charges == 2 then
								barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
							elseif TRB.Data.character.talents.scentOfBlood.isSelected and TRB.Data.snapshotData.barbedShot.charges > 0 and beastialWrathCooldownRemaining < (barbedShotPartialCharges * TRB.Data.spells.barbedShot.beastialWrathCooldownReduction) then
								barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
							elseif barbedShotTotalRechargeRemaining <= reactionTimeGcds then
								barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyUse
							else
								barColor = TRB.Data.settings.warrior.arms.colors.bar.frenzyHold
							end
						end
					end
                    ]]

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

                    --[[
					if beastialWrathCooldownRemaining <= gcd and affectingCombat then
						if TRB.Data.settings.warrior.arms.bar.beastialWrathEnabled then
							barBorderColor = TRB.Data.settings.warrior.arms.colors.bar.borderBeastialWrath
						end

						if TRB.Data.settings.warrior.arms.colors.bar.flashEnabled then
							TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.warrior.arms.colors.bar.flashAlpha, TRB.Data.settings.warrior.arms.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end
					else]]
						barContainerFrame:SetAlpha(1.0)
					--end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))
				end
			end
			TRB.Functions.UpdateResourceBar(TRB.Data.settings.warrior.arms, refreshText)
		elseif specId == 2 then
			UpdateSnapshot_Fury()

			if TRB.Data.snapshotData.isTracking then
				TRB.Functions.HideResourceBar()

				if TRB.Data.settings.warrior.fury.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					local currentRage = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

					if TRB.Data.settings.warrior.fury.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.borderOvercap, true))

						if TRB.Data.settings.warrior.fury.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
							TRB.Data.snapshotData.audio.overcapCue = true
							PlaySoundFile(TRB.Data.settings.warrior.fury.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.warrior.fury.colors.bar.border, true))
						TRB.Data.snapshotData.audio.overcapCue = false
					end

					local passiveValue = 0

					if CastingSpell() then
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

                    --[[
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.rage ~= nil and spell.rage < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local rageAmount = CalculateAbilityResourceValue(spell.rage)
							TRB.Functions.RepositionThreshold(TRB.Data.settings.warrior.fury, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.warrior.fury.thresholdWidth, -rageAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
							local frameLevel = 129

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.aimedShot.id then
									if TRB.Data.snapshotData.aimedShot.charges == 0 then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -rageAmount or TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration > 0 then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.killShot.id then
									local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
									local flayersMarkTime = GetFlayersMarkRemainingTime()
									if (targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum) and flayersMarkTime == 0 then
										showThreshold = false
									elseif TRB.Data.snapshotData.killShot.charges == 0 and flayersMarkTime == 0 then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.unusable
										frameLevel = 127
									elseif TRB.Data.snapshotData.resource >= -rageAmount or flayersMarkTime > 0 then
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.flayedShot.id then
									local flayersMarkTime = GetFlayersMarkRemainingTime() -- Change this to layer stacking if the cost of Kill Shot or Flayed Shot changes from 10 Rage!
									if TRB.Data.character.covenantId == 2 and flayersMarkTime == 0 then -- Venthyr and Flayer's Mark buff isn't up
										if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
											thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.unusable
											frameLevel = 127
										elseif TRB.Data.snapshotData.resource >= -rageAmount then
											thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
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
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.unusable
									frameLevel = 127
								elseif TRB.Data.snapshotData.resource >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
									frameLevel = 128
								end
							else -- This is an active/available/normal spell threshold
								if TRB.Data.snapshotData.resource >= -rageAmount then
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.over
								else
									thresholdColor = TRB.Data.settings.warrior.fury.colors.threshold.under
									frameLevel = 128
								end
							end

							if TRB.Data.settings.warrior.fury.thresholds[spell.settingKey].enabled and showThreshold then
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
                    ]]
					local barColor = TRB.Data.settings.warrior.fury.colors.bar.base

                    --[[
					if TRB.Data.spells.trueshot.isActive then
						local timeThreshold = 0
						local useEndOfTrueshotColor = false

						if TRB.Data.settings.warrior.fury.endOfTrueshot.enabled then
							useEndOfTrueshotColor = true
							if TRB.Data.settings.warrior.fury.endOfTrueshot.mode == "gcd" then
								local gcd = TRB.Functions.GetCurrentGCDTime()
								timeThreshold = gcd * TRB.Data.settings.warrior.fury.endOfTrueshot.gcdsMax
							elseif TRB.Data.settings.warrior.fury.endOfTrueshot.mode == "time" then
								timeThreshold = TRB.Data.settings.warrior.fury.endOfTrueshot.timeMax
							end
						end

						if useEndOfTrueshotColor and GetTrueshotRemainingTime() <= timeThreshold then
							barColor = TRB.Data.settings.warrior.fury.colors.bar.trueshotEnding
						else
							barColor = TRB.Data.settings.warrior.fury.colors.bar.trueshot
						end
                    end
                    ]]
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
				if specId == 1 then --Arms
					--[[if spellId == TRB.Data.spells.barrage.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.barrage.startTime = currentTime
							TRB.Data.snapshotData.barrage.duration = TRB.Data.spells.barrage.cooldown
						end
					elseif spellId == TRB.Data.spells.barbedShot.id then
						if type == "SPELL_CAST_SUCCESS" then -- Barbed Shot
							TRB.Data.snapshotData.barbedShot.charges, _, TRB.Data.snapshotData.barbedShot.startTime, TRB.Data.snapshotData.barbedShot.duration, _ = GetSpellCharges(TRB.Data.spells.barbedShot.id)
						end
					elseif spellId == TRB.Data.spells.barbedShot.buffId[1] or spellId == TRB.Data.spells.barbedShot.buffId[2] or spellId == TRB.Data.spells.barbedShot.buffId[3] or spellId == TRB.Data.spells.barbedShot.buffId[4] or spellId == TRB.Data.spells.barbedShot.buffId[5] then
						if type == "SPELL_AURA_APPLIED" then -- Gain Barbed Shot buff
							table.insert(TRB.Data.snapshotData.barbedShot.list, {
								ticksRemaining = TRB.Data.spells.barbedShot.ticks,
								rage = TRB.Data.snapshotData.barbedShot.ticksRemaining * TRB.Data.spells.barbedShot.rage,
								endTime = currentTime + TRB.Data.spells.barbedShot.duration,
								lastTick = currentTime
							})
						end
					elseif spellId == TRB.Data.spells.frenzy.id and destGUID == TRB.Data.character.petGuid then
						if type == "SPELL_CAST_SUCCESS" or type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_APPLIED_DOSE" or type == "SPELL_AURA_REFRESH" then
							_, _, TRB.Data.snapshotData.frenzy.stacks, _, TRB.Data.snapshotData.frenzy.duration, TRB.Data.snapshotData.frenzy.endTime, _, _, _, TRB.Data.snapshotData.frenzy.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.frenzy.id, "pet")
							TRB.Data.spells.frenzy.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.frenzy.startTime = nil
							TRB.Data.snapshotData.frenzy.duration = 0
							TRB.Data.snapshotData.frenzy.stacks = 0
							TRB.Data.spells.frenzy.isActive = false
						end
					elseif spellId == TRB.Data.spells.killCommand.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.killCommand.startTime, TRB.Data.snapshotData.killCommand.duration, _, _ = GetSpellCooldown(TRB.Data.spells.killCommand.id)
						end
					elseif spellId == TRB.Data.spells.beastialWrath.id then
						TRB.Data.snapshotData.beastialWrath.startTime, TRB.Data.snapshotData.beastialWrath.duration, _, _ = GetSpellCooldown(TRB.Data.spells.beastialWrath.id)
					elseif spellId == TRB.Data.spells.flamewakersCobraSting.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.flamewakersCobraSting.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.flamewakersCobraSting.isActive = false
						end
					end]]
				elseif specId == 2 then --Fury
					--[[if spellId == TRB.Data.spells.burstingShot.id then
						TRB.Data.snapshotData.burstingShot.startTime, TRB.Data.snapshotData.burstingShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.burstingShot.id)
					elseif spellId == TRB.Data.spells.barrage.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshotData.barrage.startTime = currentTime
							TRB.Data.snapshotData.barrage.duration = TRB.Data.spells.barrage.cooldown
						end
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
					elseif spellId == TRB.Data.spells.rapidFire.id then
						if type == "SPELL_AURA_APPLIED" then -- Gained buff 
							TRB.Data.snapshotData.rapidFire.isActive = true
							_, _, _, _, TRB.Data.snapshotData.rapidFire.duration, TRB.Data.snapshotData.rapidFire.endTime, _, _, _, TRB.Data.snapshotData.rapidFire.spellId = TRB.Functions.FindDebuffById(TRB.Data.spells.rapidFire.id, destGUID)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshotData.rapidFire.isActive = false
							TRB.Data.snapshotData.rapidFire.spellId = nil
							TRB.Data.snapshotData.rapidFire.duration = 0
							TRB.Data.snapshotData.rapidFire.endTime = nil
							TRB.Data.snapshotData.rapidFire.ticksRemaining = 0
							TRB.Data.snapshotData.rapidFire.rage = 0
						end
					elseif spellId == TRB.Data.spells.eagletalonsTrueRage.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.spells.eagletalonsTrueRage.isActive = true
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.eagletalonsTrueRage.isActive = false
						end
					elseif spellId == TRB.Data.spells.secretsOfTheUnblinkingVigil.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.startTime, TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration, _, _ = GetSpellCooldown(TRB.Data.spells.secretsOfTheUnblinkingVigil.id)

							if TRB.Data.settings.warrior.fury.audio.secretsOfTheUnblinkingVigil.enabled then
								PlaySoundFile(TRB.Data.settings.warrior.fury.audio.secretsOfTheUnblinkingVigil.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.spells.secretsOfTheUnblinkingVigil.isActive = false
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.spellId = nil
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.duration = 0
							TRB.Data.snapshotData.secretsOfTheUnblinkingVigil.endTime = nil
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
					end]]
				end

				-- Spec agnostic
                --[[
                if spellId == TRB.Data.spells.flayedShot.id then
					TRB.Data.snapshotData.flayedShot.startTime, TRB.Data.snapshotData.flayedShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.flayedShot.id)
				elseif spellId == TRB.Data.spells.aMurderOfCrows.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshotData.aMurderOfCrows.startTime = currentTime
						TRB.Data.snapshotData.aMurderOfCrows.duration = TRB.Data.spells.aMurderOfCrows.cooldown
					end
				elseif spellId == TRB.Data.spells.flayersMark.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.flayersMark.isActive = true
						_, _, _, _, TRB.Data.snapshotData.flayersMark.duration, TRB.Data.snapshotData.flayersMark.endTime, _, _, _, TRB.Data.snapshotData.flayersMark.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.flayersMark.id)

						if specId == 2 and TRB.Data.settings.warrior.fury.audio.flayersMark.enabled then
							PlaySoundFile(TRB.Data.settings.warrior.fury.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 3 and TRB.Data.settings.warrior.protection.audio.flayersMark.enabled then
							PlaySoundFile(TRB.Data.settings.warrior.protection.audio.flayersMark.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.flayersMark.isActive = false
						TRB.Data.snapshotData.flayersMark.spellId = nil
						TRB.Data.snapshotData.flayersMark.duration = 0
						TRB.Data.snapshotData.flayersMark.endTime = nil
					end
				elseif spellId == TRB.Data.spells.nesingwarysTrappingApparatus.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.nesingwarysTrappingApparatus.isActive = true
						_, _, _, _, TRB.Data.snapshotData.nesingwarysTrappingApparatus.duration, TRB.Data.snapshotData.nesingwarysTrappingApparatus.endTime, _, _, _, TRB.Data.snapshotData.nesingwarysTrappingApparatus.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.nesingwarysTrappingApparatus.id)

						if specId == 2 and TRB.Data.settings.warrior.fury.audio.nesingwarysTrappingApparatus.enabled then
							PlaySoundFile(TRB.Data.settings.warrior.fury.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
						elseif specId == 3 and TRB.Data.settings.warrior.protection.audio.nesingwarysTrappingApparatus.enabled then
							PlaySoundFile(TRB.Data.settings.warrior.protection.audio.nesingwarysTrappingApparatus.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.nesingwarysTrappingApparatus.isActive = false
						TRB.Data.snapshotData.nesingwarysTrappingApparatus.spellId = nil
						TRB.Data.snapshotData.nesingwarysTrappingApparatus.duration = 0
						TRB.Data.snapshotData.nesingwarysTrappingApparatus.endTime = nil
					end
                end
                ]]
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
					FillSpellData_Fury()

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
						ConstructResourceBar(TRB.Data.settings.warrior.arms)
					elseif specId == 2 then
						TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.warrior.fury)
						TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.fury)
						FillSpellData_Fury()
						TRB.Functions.LoadFromSpecCache(specCache.fury)
						TRB.Functions.RefreshLookupData = RefreshLookupData_Fury
						ConstructResourceBar(TRB.Data.settings.warrior.fury)
					end
					EventRegistration()
					TRB.Functions.HideResourceBar()
				end
			end
		end
	end)
end
