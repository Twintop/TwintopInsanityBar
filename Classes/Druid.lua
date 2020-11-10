local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 11 then --Only do this if we're on a Druid!
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
    local combatFrame = TRB.Frames.combatFrame
    
    local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
    
	Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0
		},
		dots = {
            sunfireCount = 0,
            moonfireCount = 0,
            stellarFlareCount = 0
		},
		furyOfElune = {
			astralPower = 0,
			ticks = 0,
			remaining = 0
		}
    }
    
	TRB.Data.character = {
		guid = UnitGUID("player"),
		specGroup = GetActiveSpecGroup(),
		maxResource = 100,
		starsurgeThreshold = 30,
		starfallThreshold = 50,
		talents = {
            naturesBalance = {
                isSelected = false
            },
            warriorOfElune = {
                isSelected = false
            },
            forceOfNature = {
                isSelected = false
            },
            soulOfTheForest = {
                isSelected = false
            },
            stellarFlare = {
                isSelected = false
            },
            furyOfElune = {
                isSelected = false
            },
            newMoon = {
                isSelected = false
            }
		},
		items = {
		}
	}

	TRB.Data.spells = {
		moonkinForm = {
			id = 24858,
			name = "",
			icon = "",
			isActive = false
		},

		wrath = {
			id = 190984,
			name = "",
			icon = "",
			astralPower = 6
        },
        starfire = {
			id = 194153,
			name = "",
			icon = "",
			astralPower = 8
		},
		sunfire = {
			id = 164815,
			name = "",
			icon = "",
			astralPower = 2
		},
		moonfire = {
			id = 164812,
			name = "",
			icon = "",
			astralPower = 2
        },

		starsurge = {
			id = 78674,
			name = "",
			icon = "",
			astralPower = 30
		},
		starfall = {
			id = 191034,
			name = "",
			icon = "",
			astralPower = 50,
			isActive = false
        },
        
        celestialAlignment = {
			id = 194223,
			name = "",
			icon = "",
			isActive = false,
			remainingTime = 0
        },        
        eclipseSolar = {
			id = 48517,
			name = "",
            icon = "",
			isActive = false,
			remainingTime = 0
        },
        eclipseLunar = {
			id = 48518,
			name = "",
			icon = "",
            isActive = false,
			remainingTime = 0
        },

        naturesBalance = {
			id = 202430,
			name = "",
			icon = "",
            astralPower = 1,
            tickRate = 2
        },
        warriorOfElune = {
            id = 202425,
            name = "",
            icon = "",
            modifier = 1.4
        },
        forceOfNature = {
            id = 205636,
            name = "",
            icon = "",
            astralPower = 20
        },

        soulOfTheForest = {
            id = 114107,
            name = "",
            icon = "",
            modifier = 1.5
        },        
        incarnationChosenOfElune = {
			id = 102560,
			name = "",
			icon = "",
			isActive = false,
			remainingTime = 0
        }, 

        stellarFlare = {
            id = 202347,
            name = "",
            icon = "",
            astralPower = 8
        },

        furyOfElune = {
            id = 202770,
            name = "",
            icon = "",
            astralPower = 2.5,
            duration = 10,
            ticks = 16,
			tickRate = 0.625
        },
        newMoon = {
            id = 274281,
            name = "",
            icon = "",
            astralPower = 10
        },
        halfMoon = {
            id = 274282,
            name = "",
            icon = "",
            astralPower = 20
        },
        fullMoon = {
            id = 274283,
            name = "",
            icon = "",
            astralPower = 40
        }
    }
    
	TRB.Data.snapshotData.audio = {
		playedSsCue = false,
		playedSfCue = false
	}
	
	TRB.Data.snapshotData.targetData = {
		ttdIsActive = false,
        currentTargetGuid = nil,
        sunfire = 0,
        moonfire = 0,
		stellarFlare = 0,
		targets = {}
	}
	TRB.Data.snapshotData.furyOfElune = {
		isActive = false,
		ticksRemaining = 0,
		startTime = nil,
		astralPower = 0
	}
	TRB.Data.snapshotData.starfall = {
		spellId = nil,
		ticksRemaining = 0,
		endTime = nil
	}

	local function FillSpellData()
		TRB.Functions.FillSpellData()
		
		-- This is done here so that we can get icons for the options menu!
		TRB.Data.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Astral Power generating spell you are currently hardcasting", printInSettings = true },

			{ variable = "#moonkinForm", icon = TRB.Data.spells.moonkinForm.icon, description = "Moonkin Form", printInSettings = true },
			
			{ variable = "#wrath", icon = TRB.Data.spells.wrath.icon, description = "Wrath", printInSettings = true },
			{ variable = "#starfire", icon = TRB.Data.spells.starfire.icon, description = "Starfire", printInSettings = true },
            
            { variable = "#sunfire", icon = TRB.Data.spells.sunfire.icon, description = "Sunfire", printInSettings = true },
            { variable = "#moonfire", icon = TRB.Data.spells.moonfire.icon, description = "Moonfire", printInSettings = true },
            
			{ variable = "#starsurge", icon = TRB.Data.spells.starsurge.icon, description = "Starsurge", printInSettings = true },
			{ variable = "#starfall", icon = TRB.Data.spells.fullMoon.icon, description = "Starfall", printInSettings = true },
            
            { variable = "#celestialAlignment", icon = TRB.Data.spells.celestialAlignment.icon, description = "Celestial Alignment", printInSettings = true },            
            { variable = "#solar", icon = TRB.Data.spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = true },
            { variable = "#eclipseSolar", icon = TRB.Data.spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = false },
            { variable = "#solarEclipse", icon = TRB.Data.spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = false },
            { variable = "#lunar", icon = TRB.Data.spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = true },
            { variable = "#eclipseLunar", icon = TRB.Data.spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = false },
            { variable = "#lunarEclipse", icon = TRB.Data.spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = false },
            
			{ variable = "#naturesBalance", icon = TRB.Data.spells.naturesBalance.icon, description = "Nature's Balance", printInSettings = true },
			{ variable = "#woe", icon = TRB.Data.spells.warriorOfElune.icon, description = "Warrior of Elune", printInSettings = false },
			{ variable = "#warriorOfElune", icon = TRB.Data.spells.warriorOfElune.icon, description = "Warrior of Elune", printInSettings = true },
			{ variable = "#forceOfNature", icon = TRB.Data.spells.forceOfNature.icon, description = "Force of Nature", printInSettings = true },
			{ variable = "#fon", icon = TRB.Data.spells.forceOfNature.icon, description = "Force of Nature", printInSettings = false },
            
            { variable = "#soulOfTheForest", icon = TRB.Data.spells.soulOfTheForest.icon, description = "Soul of the Forest", printInSettings = true },
            
            { variable = "#stellarFlare", icon = TRB.Data.spells.stellarFlare.icon, description = "Stellar Flare", printInSettings = true },

			{ variable = "#foe", icon = TRB.Data.spells.furyOfElune.icon, description = "Fury Of Elune", printInSettings = false },
			{ variable = "#furyOfElune", icon = TRB.Data.spells.furyOfElune.icon, description = "Fury Of Elune", printInSettings = true },
			
			{ variable = "#newMoon", icon = TRB.Data.spells.newMoon.icon, description = "New Moon", printInSettings = true },
			{ variable = "#halfMoon", icon = TRB.Data.spells.halfMoon.icon, description = "Half Moon", printInSettings = true },
			{ variable = "#fullMoon", icon = TRB.Data.spells.fullMoon.icon, description = "Full Moon", printInSettings = true }
		}
		TRB.Data.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
	
			{ variable = "$moonkinForm", description = "Currently in Moonkin Form. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$eclipse", description = "Currently in any kind of Eclipse. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$lunar", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = true, color = false },
			{ variable = "$lunarEclipse", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$eclipseLunar", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$solar", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = true, color = false },
			{ variable = "$solarEclipse", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$eclipseSolar", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$celestialAlignment", description = "Currently in/using Celestial Alignment or Incarnation: Chosen of Elune. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$astralPower", description = "Current Astral Power", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Astral Power", printInSettings = false, color = false },
			{ variable = "$astralPowerMax", description = "Maximum Astral Power", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Astral Power", printInSettings = false, color = false },
			{ variable = "$casting", description = "Astral Power from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Astral Power from Passive Sources", printInSettings = true, color = false },
			{ variable = "$astralPowerPlusCasting", description = "Current + Casting Astral Power Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Astral Power Total", printInSettings = false, color = false },
			{ variable = "$astralPowerPlusPassive", description = "Current + Passive Astral Power Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Astral Power Total", printInSettings = false, color = false },
			{ variable = "$astralPowerTotal", description = "Current + Passive + Casting Astral Power Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Astral Power Total", printInSettings = false, color = false },     
			{ variable = "$foeAstralPower", description = "Passive Astral Power incoming from Fury of Elune", printInSettings = true, color = false },   
			{ variable = "$foeTicks", description = "Number of ticks of Fury of Elune remaining", printInSettings = true, color = false },   
			{ variable = "$foeTime", description = "Amount of time remaining on Fury of Elune's effect", printInSettings = true, color = false },   

			{ variable = "$sunfireCount", description = "Number of Sunfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = "Number of Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$stellarFlareCount", description = "Number of Stellar Flares active on targets", printInSettings = true, color = false },
				
			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true }
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.LunarPower)
		TRB.Data.character.talents.naturesBalance.isSelected = select(4, GetTalentInfo(1, 1, TRB.Data.character.specGroup))
		TRB.Data.character.talents.warriorOfElune.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.forceOfNature.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.soulOfTheForest.isSelected = select(4, GetTalentInfo(5, 1, TRB.Data.character.specGroup))
		TRB.Data.character.talents.stellarFlare.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.furyOfElune.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.newMoon.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))
		
		TRB.Data.character.starsurgeThreshold = TRB.Data.spells.starsurge.astralPower
		TRB.Data.character.starfallThreshold = TRB.Data.spells.starfall.astralPower
		
		if TRB.Data.settings.druid ~= nil and TRB.Data.settings.druid.balance ~= nil and TRB.Data.settings.druid.balance.starsurgeThreshold and TRB.Data.character.starsurgeThreshold < TRB.Data.character.maxResource then
			resourceFrame.threshold1:Show()
			TRB.Functions.RepositionThreshold(TRB.Data.settings.druid.balance, resourceFrame.threshold1, resourceFrame, TRB.Data.settings.druid.balance.thresholdWidth, TRB.Data.character.starsurgeThreshold, TRB.Data.character.maxResource)
		else
			resourceFrame.threshold1:Hide()
        end
        
		if TRB.Data.settings.druid ~= nil and TRB.Data.settings.druid.balance ~= nil and TRB.Data.settings.druid.balance.starfallThreshold and TRB.Data.character.starfallThreshold < TRB.Data.character.maxResource then
			resourceFrame.threshold2:Show()
			TRB.Functions.RepositionThreshold(TRB.Data.settings.druid.balance, resourceFrame.threshold2, resourceFrame, TRB.Data.settings.druid.balance.thresholdWidth, TRB.Data.character.starfallThreshold, TRB.Data.character.maxResource)
		else
			resourceFrame.threshold2:Hide()
		end
	end
	
	local function IsTtdActive()
		if TRB.Data.settings.druid ~= nil and TRB.Data.settings.druid.balance ~= nil and TRB.Data.settings.druid.balance.displayText ~= nil then
			if string.find(TRB.Data.settings.druid.balance.displayText.left.text, "$ttd") or
				string.find(TRB.Data.settings.druid.balance.displayText.middle.text, "$ttd") or
				string.find(TRB.Data.settings.druid.balance.displayText.right.text, "$ttd") then
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
		if GetSpecialization() == 1 then		
			TRB.Data.resource = Enum.PowerType.LunarPower
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
			TRB.Data.snapshotData.targetData.targets[guid].sunfire = false
			TRB.Data.snapshotData.targetData.targets[guid].moonfire = false
			TRB.Data.snapshotData.targetData.targets[guid].stellarFlare = false
		end	
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local sunfireTotal = 0
		local moonfireTotal = 0
		local stellarFlareTotal = 0
        for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
            if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
                TRB.Data.snapshotData.targetData.targets[tguid].sunfire = false
                TRB.Data.snapshotData.targetData.targets[tguid].moonfire = false
                TRB.Data.snapshotData.targetData.targets[tguid].stellarFlare = false
            else
                if TRB.Data.snapshotData.targetData.targets[tguid].sunfire == true then
                    sunfireTotal = sunfireTotal + 1
                end
                
                if TRB.Data.snapshotData.targetData.targets[tguid].moonfire == true then
                    moonfireTotal = moonfireTotal + 1
                end
                
                if TRB.Data.snapshotData.targetData.targets[tguid].stellarFlare == true then
                    stellarFlareTotal = stellarFlareTotal + 1
                end
            end
        end

		TRB.Data.snapshotData.targetData.sunfire = sunfireTotal
		TRB.Data.snapshotData.targetData.moonfire = moonfireTotal
		TRB.Data.snapshotData.targetData.stellarFlare = stellarFlareTotal
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
            TRB.Data.snapshotData.targetData.sunfire = 0
            TRB.Data.snapshotData.targetData.moonfire = 0
            TRB.Data.snapshotData.targetData.stellarFlare = 0
		end
	end

	local function ConstructResourceBar()
		TRB.Functions.ConstructResourceBar(TRB.Data.settings.druid.balance)
		
		resourceFrame.threshold1:SetWidth(TRB.Data.settings.druid.balance.thresholdWidth)
		resourceFrame.threshold1:SetHeight(TRB.Data.settings.druid.balance.bar.height)
		resourceFrame.threshold1.texture = resourceFrame.threshold1:CreateTexture(nil, TRB.Data.settings.core.strata.level)
		resourceFrame.threshold1.texture:SetAllPoints(resourceFrame.threshold1)
		resourceFrame.threshold1.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.under, true))
		resourceFrame.threshold1:SetFrameStrata(TRB.Data.settings.core.strata.level)
		resourceFrame.threshold1:SetFrameLevel(128)
		resourceFrame.threshold1:Show()
		
		resourceFrame.threshold2:SetWidth(TRB.Data.settings.druid.balance.thresholdWidth)
		resourceFrame.threshold2:SetHeight(TRB.Data.settings.druid.balance.bar.height)
		resourceFrame.threshold2.texture = resourceFrame.threshold2:CreateTexture(nil, TRB.Data.settings.core.strata.level)
		resourceFrame.threshold2.texture:SetAllPoints(resourceFrame.threshold2)
		resourceFrame.threshold2.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.under, true))
		resourceFrame.threshold2:SetFrameStrata(TRB.Data.settings.core.strata.level)
		resourceFrame.threshold2:SetFrameLevel(128)
		resourceFrame.threshold2:Show()
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end

        local affectingCombat = UnitAffectingCombat("player")

		if var == "$moonkinForm" then
			if TRB.Data.spells.moonkinForm.isActive then
				valid = true
			end
		elseif var == "$eclipse" then
			if TRB.Data.spells.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
				valid = true
			end
		elseif var == "$solar" or var == "$eclipseSolar" or var == "$solarEclipse" then
			if TRB.Data.spells.eclipseSolar.isActive then
				valid = true
			end
		elseif var == "$lunar" or var == "$eclipseLunar" or var == "$lunarEclipse" then
			if TRB.Data.spells.eclipseLunar.isActive then
				valid = true
			end
		elseif var == "$celestialAlignment" then
			if TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
				valid = true
			end
		elseif var == "$resource" or var == "$astralPower" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$astralPowerMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$astralPowerTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$astralPowerPlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
			if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.character.maxResource then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$astralPowerPlusPassive" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw > 0 then
				valid = true
			end
        elseif var == "$passive" then
            if TRB.Data.character.talents.naturesBalance.isSelected and affectingCombat then
                valid = true
            end
		elseif var == "$sunfireCount" then
			if TRB.Data.snapshotData.targetData.sunfire > 0 then
				valid = true
			end
		elseif var == "$moonfireCount" then
			if TRB.Data.snapshotData.targetData.moonfire > 0 then
				valid = true
			end
		elseif var == "$stellarFlareCount" then
			if TRB.Data.snapshotData.targetData.stellarFlare > 0 then
				valid = true
            end
        elseif var == "$talentStellarFlare" then
            if TRB.Data.character.talents.stellarFlare.isSelected then
                valid = true
			end
		elseif var == "$foeAstralPower" then
			if TRB.Data.snapshotData.furyOfElune.astralPower > 0 then
				valid = true
			end
		elseif var == "$foeTicks" then
			if TRB.Data.snapshotData.furyOfElune.remainingTicks > 0 then
				valid = true
			end
		elseif var == "$foeTime" then
			if TRB.Data.snapshotData.furyOfElune.startTime ~= nil then
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

		local moonkinFormActive = TRB.Data.spells.moonkinForm.isActive

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.current
		local castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.casting
		
		local astralPowerThreshold = math.min(TRB.Data.character.starsurgeThreshold, TRB.Data.character.starfallThreshold)
		
		if TRB.Data.settings.druid.balance.colors.text.overcapEnabled and overcap then 
			currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overcap
			castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overcap	
		elseif TRB.Data.settings.druid.balance.colors.text.overThresholdEnabled and TRB.Data.snapshotData.resource >= astralPowerThreshold then
			currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overThreshold
		end
		
		--$astralPower
		local currentAstralPower = string.format("|c%s%.0f|r", currentAstralPowerColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingAstralPower = string.format("|c%s%.0f|r", castingAstralPowerColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
        local _passiveAstralPower = TRB.Data.snapshotData.furyOfElune.astralPower
        
        if TRB.Data.character.talents.naturesBalance.isSelected then
            _passiveAstralPower = _passiveAstralPower + TRB.Data.spells.naturesBalance.astralPower
		end

		local passiveAstralPower = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.passive, _passiveAstralPower)
		--$astralPowerTotal
		local _astralPowerTotal = math.min(_passiveAstralPower + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local astralPowerTotal = string.format("|c%s%.0f|r", currentAstralPowerColor, _astralPowerTotal)
		--$astralPowerPlusCasting
		local _astralPowerPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local astralPowerPlusCasting = string.format("|c%s%.0f|r", castingAstralPowerColor, _astralPowerPlusCasting)
		--$astralPowerPlusPassive
		local _astralPowerPlusPassive = math.min(_passiveAstralPower + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local astralPowerPlusPassive = string.format("|c%s%.0f|r", castingAstralPowerColor, _astralPowerPlusPassive)

		----------
		--$sfCount
        local sunfireCount = TRB.Data.snapshotData.targetData.sunfire or 0
        --$mfCount
        local moonfireCount = TRB.Data.snapshotData.targetData.moonfire or 0
        --$sFlareCount
		local stellarFlareCount = TRB.Data.snapshotData.targetData.stellarFlare or 0

        ----------
        --$foeAstralPower
        local foeAstralPower = TRB.Data.snapshotData.furyOfElune.astralPower or 0
        --$foeTicks
		local foeTicks = TRB.Data.snapshotData.furyOfElune.ticksRemaining or 0
		--$foeTime
		local foeTime = 0
		if TRB.Data.snapshotData.furyOfElune.startTime ~= nil then
			foeTime = string.format("%.1f", math.abs(currentTime - (TRB.Data.snapshotData.furyOfElune.startTime + TRB.Data.spells.furyOfElune.duration)))
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveAstralPower or 0
		Global_TwintopResourceBar.resource.furyOfElune = foeAstralPower or 0
		Global_TwintopResourceBar.dots = {
			sunfireCount = sunfireCount or 0,
			moonfireCount = moonfireCount or 0,
			stellarFlareCount = stellarFlareCount or 0
		}
		Global_TwintopResourceBar.furyOfElune = {
			astralPower = foeAstralPower or 0,
			ticks = foeTicks or 0,
			remaining = foeTime or 0
		}
		
		local lookup = TRB.Data.lookup or {}
		lookup["#wrath"] = TRB.Data.spells.wrath.icon
		lookup["#moonkinForm"] = TRB.Data.spells.moonkinForm.icon
		lookup["#starfire"] = TRB.Data.spells.starfire.icon
		lookup["#sunfire"] = TRB.Data.spells.sunfire.icon
		lookup["#moonfire"] = TRB.Data.spells.moonfire.icon
		lookup["#starsurge"] = TRB.Data.spells.starsurge.icon
		lookup["#starfall"] = TRB.Data.spells.starfall.icon
		lookup["#celestialAlignment"] = TRB.Data.spells.celestialAlignment.icon
		lookup["#solar"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#eclipseSolar"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#solarEclipse"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#lunar"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#eclipseLunar"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#lunarEclipse"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#naturesBalance"] = TRB.Data.spells.naturesBalance.icon
		lookup["#woe"] = TRB.Data.spells.warriorOfElune.icon
		lookup["#warriorOfElune"] = TRB.Data.spells.warriorOfElune.icon
		lookup["#forceOfNature"] = TRB.Data.spells.forceOfNature.icon
		lookup["#fon"] = TRB.Data.spells.forceOfNature.icon
		lookup["#soulOfTheForest"] = TRB.Data.spells.soulOfTheForest.icon
		lookup["#foe"] = TRB.Data.spells.furyOfElune.icon
		lookup["#furyOfElune"] = TRB.Data.spells.furyOfElune.icon
		lookup["#stellarFlare"] = TRB.Data.spells.stellarFlare.icon
		lookup["#newMoon"] = TRB.Data.spells.newMoon.icon
		lookup["#halfMoon"] = TRB.Data.spells.halfMoon.icon
		lookup["#fullMoon"] = TRB.Data.spells.fullMoon.icon
		lookup["$moonkinForm"] = ""
		lookup["$eclipse"] = ""
		lookup["$lunar"] = ""
		lookup["$lunarEclipse"] = ""
		lookup["$eclipseLunar"] = ""
		lookup["$solar"] = ""
		lookup["$solarEclipse"] = ""
		lookup["$eclipseSolar"] = ""
		lookup["$celestialAlignment"] = ""
		lookup["$sunfireCount"] = sunfireCount
		lookup["$moonfireCount"] = moonfireCount
		lookup["$stellarFlareCount"] = stellarFlareCount
		lookup["$astralPowerPlusCasting"] = astralPowerPlusCasting
		lookup["$astralPowerPlusPassive"] = astralPowerPlusPassive
		lookup["$astralPowerTotal"] = astralPowerTotal
		lookup["$astralPowerMax"] = TRB.Data.character.maxResource
		lookup["$astralPower"] = currentAstralPower
		lookup["$resourcePlusCasting"] = astralPowerPlusCasting
		lookup["$resourcePlusPassive"] = astralPowerPlusPassive
		lookup["$resourceTotal"] = astralPowerTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentAstralPower
		lookup["$casting"] = castingAstralPower
		lookup["$passive"] = passiveAstralPower
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$astralPowerOvercap"] = overcap
		lookup["$foeAstralPower"] = foeAstralPower
		lookup["$foeTicks"] = foeTicks
		lookup["$foeTime"] = foeTime
		lookup["$talentStellarFlare"] = TRB.Data.character.talents.stellarFlare.isSelected
		TRB.Data.lookup = lookup	
	end
	TRB.Functions.RefreshLookupData = RefreshLookupData

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.astralPower
        TRB.Data.snapshotData.casting.resourceFinal = spell.astralPower
        TRB.Data.snapshotData.casting.spellId = spell.id
        TRB.Data.snapshotData.casting.icon = spell.icon
    end

	local function CastingSpell()
		local currentSpell = UnitCastingInfo("player")
		local currentChannel = UnitChannelInfo("player")
		
		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.ResetCastingSnapshotData()
			return false
		else
			if currentSpell == nil then
                local spellName = select(1, currentChannel)
                --See Priest implementation for handling channeled spells
			else	
				local spellName = select(1, currentSpell)
				if spellName == TRB.Data.spells.wrath.name then
                    FillSnapshotDataCasting(TRB.Data.spells.wrath)
                    if TRB.Data.character.talents.soulOfTheForest and TRB.Data.spells.eclipseSolar.isActive then
                        TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceFinal * TRB.Data.spells.soulOfTheForest.modifier
                    end
				elseif spellName == TRB.Data.spells.starfire.name then
                    FillSnapshotDataCasting(TRB.Data.spells.starfire)
                    --Warrior of Elune logic would go here if it didn't make it instant cast!
				elseif spellName == TRB.Data.spells.sunfire.name then
                    FillSnapshotDataCasting(TRB.Data.spells.sunfire)
				elseif spellName == TRB.Data.spells.moonfire.name then
                    FillSnapshotDataCasting(TRB.Data.spells.moonfire)
				elseif spellName == TRB.Data.spells.forceOfNature.name then
                    FillSnapshotDataCasting(TRB.Data.spells.forceOfNature)
				elseif spellName == TRB.Data.spells.stellarFlare.name then
                    FillSnapshotDataCasting(TRB.Data.spells.stellarFlare)
				elseif spellName == TRB.Data.spells.newMoon.name then
                    FillSnapshotDataCasting(TRB.Data.spells.newMoon)
				elseif spellName == TRB.Data.spells.halfMoon.name then
                    FillSnapshotDataCasting(TRB.Data.spells.halfMoon)
				elseif spellName == TRB.Data.spells.fullMoon.name then
                    FillSnapshotDataCasting(TRB.Data.spells.fullMoon)
                else
					TRB.Functions.ResetCastingSnapshotData()
					return false				
				end
			end
			return true
		end
	end

	local function UpdateFuryOfElune()
		if TRB.Data.snapshotData.furyOfElune.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.furyOfElune.startTime == nil or currentTime > (TRB.Data.snapshotData.furyOfElune.startTime + TRB.Data.spells.furyOfElune.duration) then
				TRB.Data.snapshotData.furyOfElune.ticksRemaining = 0
				TRB.Data.snapshotData.furyOfElune.startTime = nil
				TRB.Data.snapshotData.furyOfElune.astralPower = 0			
				TRB.Data.snapshotData.furyOfElune.isActive = false
			end
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()
		local _
		local expirationTime
		_, _, _, _, _, expirationTime, _, _, _, TRB.Data.spells.eclipseSolar.isActive = TRB.Functions.FindBuffById(TRB.Data.spells.eclipseSolar.id)
		if TRB.Data.spells.eclipseSolar.isActive then
			TRB.Data.spells.eclipseSolar.remainingTime = expirationTime - currentTime
		else
			TRB.Data.spells.eclipseSolar.remainingTime = 0
		end
		_, _, _, _, _, expirationTime, _, _, _, TRB.Data.spells.eclipseLunar.isActive = TRB.Functions.FindBuffById(TRB.Data.spells.eclipseLunar.id)
		if TRB.Data.spells.eclipseLunar.isActive then
			TRB.Data.spells.eclipseLunar.remainingTime = expirationTime - currentTime
		else
			TRB.Data.spells.eclipseLunar.remainingTime = 0
		end
		_, _, _, _, _, expirationTime, _, _, _, TRB.Data.spells.celestialAlignment.isActive = TRB.Functions.FindBuffById(TRB.Data.spells.celestialAlignment.id)
		if TRB.Data.spells.celestialAlignment.isActive then
			TRB.Data.spells.celestialAlignment.remainingTime = expirationTime - currentTime
		else
			TRB.Data.spells.celestialAlignment.remainingTime = 0
		end
		_, _, _, _, _, expirationTime, _, _, _, TRB.Data.spells.incarnationChosenOfElune.isActive = TRB.Functions.FindBuffById(TRB.Data.spells.incarnationChosenOfElune.id)
		if TRB.Data.spells.incarnationChosenOfElune.isActive then
			TRB.Data.spells.incarnationChosenOfElune.remainingTime = expirationTime - currentTime
		else
			TRB.Data.spells.incarnationChosenOfElune.remainingTime = 0
		end		

        TRB.Data.spells.moonkinForm.isActive = select(10, TRB.Functions.FindBuffById(TRB.Data.spells.moonkinForm.id))
        UpdateFuryOfElune()
	end    

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
	
		if force or GetSpecialization() ~= 1 or (not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.druid.balance.displayBar.alwaysShow) and (
					(not TRB.Data.settings.druid.balance.displayBar.notZeroShow) or
                    (TRB.Data.settings.druid.balance.displayBar.notZeroShow and
                        ((not TRB.Data.character.talents.naturesBalance.isSelected and TRB.Data.snapshotData.resource == 0) or
                         (TRB.Data.character.talents.naturesBalance.isSelected and TRB.Data.snapshotData.resource >= 50))
                    )
				)
			 ) then
			TRB.Frames.barContainerFrame:Hide()	
			TRB.Data.snapshotData.isTracking = false
		else
			TRB.Data.snapshotData.isTracking = true
			if TRB.Data.settings.druid.balance.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()	
			else
				TRB.Frames.barContainerFrame:Show()	
			end
		end
	end
	TRB.Functions.HideResourceBar = HideResourceBar

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		UpdateSnapshot()

		if TRB.Data.snapshotData.isTracking then
			TRB.Functions.HideResourceBar()
			
			if TRB.Data.settings.druid.balance.displayBar.neverShow == false then
				refreshText = true
				local affectingCombat = UnitAffectingCombat("player")
				local passiveBarValue = 0
				local castingBarValue = 0
				local flashBar = false

				if TRB.Data.settings.druid.balance.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.borderOvercap, true))
					
					if TRB.Data.settings.druid.balance.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
						TRB.Data.snapshotData.audio.overcapCue = true
						PlaySoundFile(TRB.Data.settings.druid.balance.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
					end
				else
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.bar.border, true))
					TRB.Data.snapshotData.audio.overcapCue = false
				end
				
				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.druid.balance, resourceFrame, TRB.Data.snapshotData.resource)
							
				if CastingSpell() then
					castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
				else
					castingBarValue = TRB.Data.snapshotData.resource
				end
				
				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.druid.balance, castingFrame, castingBarValue)

				if TRB.Data.character.talents.naturesBalance.isSelected and (affectingCombat or (not affectingCombat and TRB.Data.snapshotData.resource < 50)) then
					passiveBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.spells.naturesBalance.astralPower + TRB.Data.snapshotData.furyOfElune.astralPower
				else
					passiveBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.furyOfElune.astralPower
				end
							
				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.druid.balance, passiveFrame, passiveBarValue)
				
				-- Balance doesn't use the passive threshold right now. Hide it
				passiveFrame.threshold1.texture:Hide()

				if TRB.Data.settings.druid.balance.starsurgeThreshold then
					resourceFrame.threshold1:Show()                
					if TRB.Data.snapshotData.resource >= TRB.Data.character.starsurgeThreshold then
						resourceFrame.threshold1.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.over, true))
						if TRB.Data.settings.druid.balance.audio.ssReady.enabled and TRB.Data.snapshotData.audio.playedSsCue == false then
							TRB.Data.snapshotData.audio.playedSsCue = true
							PlaySoundFile(TRB.Data.settings.druid.balance.audio.ssReady.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						resourceFrame.threshold1.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.under, true))
						TRB.Data.snapshotData.audio.playedSsCue = false
					end
				else
					resourceFrame.threshold1:Hide()
				end
				
				if TRB.Data.settings.druid.balance.starfallThreshold then
					resourceFrame.threshold2:Show()
					if TRB.Data.snapshotData.resource >= TRB.Data.character.starfallThreshold then
						if TRB.Data.spells.starfall.isActive and (TRB.Data.snapshotData.starfall.endTime - currentTime) > 2.4 then -- 8 * 0.3 = pandemic range
							resourceFrame.threshold2.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.starfallPandemic, true))
						else
							resourceFrame.threshold2.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.over, true))
						end

						if TRB.Data.settings.druid.balance.audio.sfReady.enabled and TRB.Data.snapshotData.audio.playedSfCue == false then
							TRB.Data.snapshotData.audio.playedSfCue = true
							PlaySoundFile(TRB.Data.settings.druid.balance.audio.sfReady.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					else
						resourceFrame.threshold2.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.druid.balance.colors.threshold.under, true))
						TRB.Data.snapshotData.audio.playedSfCue = false
					end
				else
					resourceFrame.threshold2:Hide()
				end
								
				if TRB.Data.settings.druid.balance.colors.bar.flashSsEnabled and TRB.Data.snapshotData.resource >= TRB.Data.character.starsurgeThreshold then
					flashBar = true
				end

				local barColor = TRB.Data.settings.druid.balance.colors.bar.base

				if not TRB.Data.spells.moonkinForm.isActive and affectingCombat then
					barColor = TRB.Data.settings.druid.balance.colors.bar.moonkinFormMissing
					if TRB.Data.settings.druid.balance.colors.bar.flashEnabled then
						flashBar = true
					end
				elseif TRB.Data.spells.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
					local timeThreshold = 0
					local useEndOfEclipseColor = false
					local remainingTime = 0

					if TRB.Data.spells.celestialAlignment.isActive then
						remainingTime = TRB.Data.spells.celestialAlignment.remainingTime
					elseif TRB.Data.spells.incarnationChosenOfElune.isActive then
						remainingTime = TRB.Data.spells.incarnationChosenOfElune.remainingTime
					elseif TRB.Data.spells.eclipseSolar.isActive then
						remainingTime = TRB.Data.spells.eclipseSolar.remainingTime
					elseif TRB.Data.spells.eclipseLunar.isActive then
						remainingTime = TRB.Data.spells.eclipseLunar.remainingTime
					end

					if TRB.Data.settings.druid.balance.endOfEclipse.enabled and (not TRB.Data.settings.druid.balance.endOfEclipse.celestialAlignmentOnly or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive) then
						useEndOfEclipseColor = true
						if TRB.Data.settings.druid.balance.endOfEclipse.mode == "gcd" then
							local gcd = TRB.Functions.GetCurrentGCDTime()
							timeThreshold = gcd * TRB.Data.settings.druid.balance.endOfEclipse.gcdsMax
						elseif TRB.Data.settings.druid.balance.endOfEclipse.mode == "time" then
							timeThreshold = TRB.Data.settings.druid.balance.endOfEclipse.timeMax
						end
					end
					
					if useEndOfEclipseColor and remainingTime <= timeThreshold then
						barColor = TRB.Data.settings.druid.balance.colors.bar.eclipse1GCD
					else
						if TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive or (TRB.Data.spells.eclipseSolar.isActive and TRB.Data.spells.eclipseLunar.isActive) then
							barColor = TRB.Data.settings.druid.balance.colors.bar.celestial
						elseif TRB.Data.spells.eclipseSolar.isActive then
							barColor = TRB.Data.settings.druid.balance.colors.bar.solar
						else--if TRB.Data.spells.eclipseLunar.isActive then
							barColor = TRB.Data.settings.druid.balance.colors.bar.lunar
						end
					end
				end

				resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(barColor, true))	
				barContainerFrame:SetAlpha(1.0)

				if flashBar then
					TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.druid.balance.colors.bar.flashAlpha, TRB.Data.settings.druid.balance.colors.bar.flashPeriod)
				end				
			end
		end
		TRB.Functions.UpdateResourceBar(TRB.Data.settings.druid.balance, refreshText)
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
			
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if sourceGUID == TRB.Data.character.guid then 
				if spellId == TRB.Data.spells.sunfire.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- Sunfire Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].sunfire = true
						TRB.Data.snapshotData.targetData.sunfire = TRB.Data.snapshotData.targetData.sunfire + 1
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.targetData.targets[destGUID].sunfire = false
						TRB.Data.snapshotData.targetData.sunfire = TRB.Data.snapshotData.targetData.sunfire - 1
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end
				elseif spellId == TRB.Data.spells.moonfire.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- Moonfire Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = true
						TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire + 1
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.targetData.targets[destGUID].moonfire = false
						TRB.Data.snapshotData.targetData.moonfire = TRB.Data.snapshotData.targetData.moonfire - 1
                    --elseif type == "SPELL_PERIODIC_DAMAGE" then
					end		
				elseif spellId == TRB.Data.spells.stellarFlare.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- Stellar Flare Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].stellarFlare = true
						TRB.Data.snapshotData.targetData.stellarFlare = TRB.Data.snapshotData.targetData.stellarFlare + 1
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.targetData.targets[destGUID].stellarFlare = false
						TRB.Data.snapshotData.targetData.stellarFlare = TRB.Data.snapshotData.targetData.stellarFlare - 1
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end	
				elseif spellId == TRB.Data.spells.furyOfElune.id then
					if type == "SPELL_AURA_APPLIED" then -- Gain Death and Madness
						TRB.Data.snapshotData.furyOfElune.isActive = true
						TRB.Data.snapshotData.furyOfElune.ticksRemaining = TRB.Data.spells.furyOfElune.ticks
						TRB.Data.snapshotData.furyOfElune.astralPower = TRB.Data.snapshotData.furyOfElune.ticksRemaining * TRB.Data.spells.furyOfElune.astralPower
						TRB.Data.snapshotData.furyOfElune.startTime = currentTime
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.furyOfElune.isActive = false
						TRB.Data.snapshotData.furyOfElune.ticksRemaining = 0
						TRB.Data.snapshotData.furyOfElune.astralPower = 0
						TRB.Data.snapshotData.furyOfElune.startTime = nil
					elseif type == "SPELL_PERIODIC_ENERGIZE" then
						TRB.Data.snapshotData.furyOfElune.ticksRemaining = TRB.Data.snapshotData.furyOfElune.ticksRemaining - 1
						TRB.Data.snapshotData.furyOfElune.astralPower = TRB.Data.snapshotData.furyOfElune.ticksRemaining * TRB.Data.spells.furyOfElune.astralPower
					end
				elseif spellId == TRB.Data.spells.starfall.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						TRB.Data.spells.starfall.isActive = true
						_, _, _, _, TRB.Data.snapshotData.starfall.duration, TRB.Data.snapshotData.starfall.endTime, _, _, _, TRB.Data.snapshotData.starfall.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.starfall.id)
					elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
						TRB.Data.spells.starfall.isActive = false
						TRB.Data.snapshotData.starfall.spellId = nil
						TRB.Data.snapshotData.starfall.duration = 0
						TRB.Data.snapshotData.starfall.endTime = nil
					end
				else
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
		if classIndex == 11 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true
					local settings = TRB.Options.Druid.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end	

					TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.druid.balance)
					TRB.Functions.IsTtdActive()		
					FillSpellData()
					ConstructResourceBar()
					TRB.Options.Druid.ConstructOptionsPanel()

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
