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
    
	Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0
		},
		dots = {
		}
    }
    
	TRB.Data.character = {
		guid = UnitGUID("player"),
		specGroup = GetActiveSpecGroup(),
		maxResource = 100,
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

	TRB.Data.spells = {
        aimedShot = {
			id = 19434,
			name = "",
			icon = "",
			focus = -35,
            thresholdId = 1,
            settingKey = "aimedShot",
            isSnowflake = true
        },
		arcaneShot = {
			id = 185358,
			name = "",
			icon = "",
            focus = -20,
            thresholdId = 2,
            settingKey = "arcaneShot"
        },
        killShot = {
            id = 53351,
            name = "",
            icon = "",
            focus = -10,
            thresholdId = 5,
            settingKey = "killShot",
            healthMinimum = 0.2,
            isSnowflake = true
        },
        multiShot = {
            id = 257620,
            name = "",
            icon = "",
            focus = -20,
            thresholdId = 6,
            settingKey = "multiShot"
        },
        scareBeast = {
			id = 1513,
			name = "",
			icon = "",
			focus = -25,
            thresholdId = 9,
            settingKey = "scareBeast"
        },
        burstingShot = {
			id = 186387,
			name = "",
			icon = "",
			focus = -10,
            thresholdId = 10,
            settingKey = "burstingShot",
            hasCooldown = true
        },
        revivePet = {
			id = 982,
			name = "",
			icon = "",
            focus = -35,
            thresholdId = 11,
            settingKey = "revivePet"
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
            isTalent = true
        },
        barrage = {
			id = 120360,
			name = "",
			icon = "",
            focus = -30, -- -60 for non Marksmanship,
            thresholdId = 4,
            settingKey = "barrage",
            isTalent = true,
            hasCooldown = true
        },
        aMurderOfCrows = {
			id = 131894,
			name = "",
			icon = "",
            focus = -20, -- -30 for non Marksmanship,
            thresholdId = 7,
            settingKey = "aMurderOfCrows",
            isTalent = true,
            hasCooldown = true
        },
        explosiveShot = {
			id = 212431,
			name = "",
			icon = "",
            focus = -20,
            thresholdId = 8,
            settingKey = "explosiveShot",
            isTalent = true,
            hasCooldown = true
        },
        chimaeraShot = {
			id = 342049,
			name = "",
			icon = "",
            focus = -20,
            isTalent = true--[[,
            thresholdId = 12,
            settingKey = "arcaneShot"]] --Commenting out for now since it is the same focus as Arcane Shot
        },

    }
	
	TRB.Data.snapshotData.focusRegen = 0
	TRB.Data.snapshotData.audio = {
    }
	TRB.Data.snapshotData.doubleTap = {
        isActive = false,
        spell = nil
    }
	TRB.Data.snapshotData.trueshot = {
        spellId = nil,
        duration = 0,
		endTime = nil
    }
    TRB.Data.snapshotData.aimedShot = {
        charges = 0,
        startTime = nil,
        duration = 0
    }
    TRB.Data.snapshotData.killShot = {
        charges = 0,
        startTime = nil,
        duration = 0
    }
    TRB.Data.snapshotData.burstingShot = {
        startTime = nil,
        duration = 0,
        enabled = false
    }
    TRB.Data.snapshotData.barrage = {
        startTime = nil,
        duration = 0,
        enabled = false
    }
    TRB.Data.snapshotData.aMurderOfCrows = {
        startTime = nil,
        duration = 0,
        enabled = false
    }
    TRB.Data.snapshotData.explosiveShot = {
        startTime = nil,
        duration = 0,
        enabled = false
    }
	TRB.Data.snapshotData.targetData = {
		ttdIsActive = false,
		currentTargetGuid = nil,
		serpentSting = 0,
		targets = {}
	}

	local function FillSpellData()
		TRB.Functions.FillSpellData()

		-- This is done here so that we can get icons for the options menu!
		TRB.Data.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the focus generating spell you are currently hardcasting", printInSettings = true },

			{ variable = "#aMurderOfCrows", icon = TRB.Data.spells.aMurderOfCrows.icon, description = "A Murder of Crows", printInSettings = true },
			{ variable = "#aimedShot", icon = TRB.Data.spells.aimedShot.icon, description = "Aimed Shot", printInSettings = true },
			{ variable = "#arcaneShot", icon = TRB.Data.spells.arcaneShot.icon, description = "Arcane Shot", printInSettings = true },
			{ variable = "#barrage", icon = TRB.Data.spells.barrage.icon, description = "Barrage", printInSettings = true },
			{ variable = "#burstingShot", icon = TRB.Data.spells.burstingShot.icon, description = "Bursting Shot", printInSettings = true },
			{ variable = "#chimaeraShot", icon = TRB.Data.spells.chimaeraShot.icon, description = "Chimaera Shot", printInSettings = true },
			{ variable = "#explosiveShot", icon = TRB.Data.spells.explosiveShot.icon, description = "Explosive Shot", printInSettings = true },
			{ variable = "#killShot", icon = TRB.Data.spells.killShot.icon, description = "Kill Shot", printInSettings = true },
			{ variable = "#multiShot", icon = TRB.Data.spells.multiShot.icon, description = "Multi-Shot", printInSettings = true },
			{ variable = "#rapidFire", icon = TRB.Data.spells.rapidFire.icon, description = "Rapid Fire", printInSettings = true },
			{ variable = "#revivePet", icon = TRB.Data.spells.revivePet.icon, description = "Revive Pet", printInSettings = true },
			{ variable = "#scareBeast", icon = TRB.Data.spells.scareBeast.icon, description = "Scare Beast", printInSettings = true },
			{ variable = "#serpentSting", icon = TRB.Data.spells.serpentSting.icon, description = "Serpent Sting", printInSettings = true },
			{ variable = "#steadyShot", icon = TRB.Data.spells.steadyShot.icon, description = "Steady Shot", printInSettings = true },
			{ variable = "#trickShots", icon = TRB.Data.spells.trickShots.icon, description = "Trick Shots", printInSettings = true },
			{ variable = "#trueshot", icon = TRB.Data.spells.trueshot.icon, description = "Trueshot", printInSettings = true },
        }
		TRB.Data.barTextVariables.values = {
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
			{ variable = "$passive", description = "Focus from Passive Sources", printInSettings = true, color = false },
			{ variable = "$focusPlusCasting", description = "Current + Casting Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Focus Total", printInSettings = false, color = false },
			{ variable = "$focusPlusPassive", description = "Current + Passive Focus Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Focus Total", printInSettings = false, color = false },
			{ variable = "$focusTotal", description = "Current + Passive + Casting Focus Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Focus Total", printInSettings = false, color = false },   

			{ variable = "$trueshotTime", description = "Time remaining on Trueshot buff", printInSettings = true, color = false },   
			{ variable = "$ssCount", description = "Number of Serpent Stings active on targets", printInSettings = true, color = false },
			{ variable = "$serpentSting", description = "Is Serpent Sting talented? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Focus)
		TRB.Data.character.talents.serpentSting.isSelected = select(4, GetTalentInfo(1, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.aMurderOfCrows.isSelected = select(4, GetTalentInfo(1, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.barrage.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.explosiveShot.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.chimaeraShot.isSelected = select(4, GetTalentInfo(4, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.deadEye.isSelected = select(4, GetTalentInfo(6, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.doubleTap.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
	end
	
	local function IsTtdActive()
		if TRB.Data.settings.hunter ~= nil and TRB.Data.settings.hunter.marksmanship ~= nil and TRB.Data.settings.hunter.marksmanship.displayText ~= nil then
			if string.find(TRB.Data.settings.hunter.marksmanship.displayText.left.text, "$ttd") or
				string.find(TRB.Data.settings.hunter.marksmanship.displayText.middle.text, "$ttd") or
				string.find(TRB.Data.settings.hunter.marksmanship.displayText.right.text, "$ttd") then
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
		if GetSpecialization() == 2 then		
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

    local function CalculateResourceGain(resource)
        local modifier = 1.0
                
        if resource > 0 and TRB.Data.spells.trueshot.isActive then
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

    local function ConstructResourceBar()
        local resourceFrameCounter = 1
        for k, v in pairs(TRB.Data.spells) do
            local spell = TRB.Data.spells[k]
            if spell ~= nil and spell.id ~= nil and spell.focus ~= nil and spell.focus < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
                TRB.Frames.resourceFrame.thresholds[resourceFrameCounter] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
                resourceFrameCounter = resourceFrameCounter + 1
            end
        end

		TRB.Functions.ConstructResourceBar(TRB.Data.settings.hunter.marksmanship)
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
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
			if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.character.maxResource then
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
				((TRB.Data.settings.hunter.marksmanship.generation.mode == "time" and TRB.Data.settings.hunter.marksmanship.generation.time > 0) or
				(TRB.Data.settings.hunter.marksmanship.generation.mode == "gcd" and TRB.Data.settings.hunter.marksmanship.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$trueshotTime" then
			if GetTrueshotRemainingTime() > 0 then
				valid = true
			end
		elseif var == "$ssCount" then
			if TRB.Data.snapshotData.targetData.serpentSting > 0 then
				valid = true
			end
		elseif var == "$serpentSting" then
			if TRB.Data.character.talents.serpentSting.isSelected then
				valid = true
			end
		else
			valid = false					
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData()
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
        elseif TRB.Data.snapshotData.casting.resourceFinal < 0 then
            castingFocusColor = TRB.Data.settings.hunter.marksmanship.colors.text.spending
		end
        
		--$focus
		local currentfocus = string.format("|c%s%.0f|r", currentFocusColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingfocus = string.format("|c%s%.0f|r", castingFocusColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _passivefocus = TRB.Data.snapshotData.focusRegen
		
		local _gcd = TRB.Functions.GetCurrentGCDTime(true)

		if TRB.Data.settings.hunter.marksmanship.generation.mode == "time" then
			_passivefocus = _passivefocus * (TRB.Data.settings.hunter.marksmanship.generation.time or 3.0)
		else
			_passivefocus = _passivefocus * ((TRB.Data.settings.hunter.marksmanship.generation.gcds or 2) * _gcd)
		end

		local passivefocus = string.format("|c%s%.0f|r", TRB.Data.settings.hunter.marksmanship.colors.text.passive, _passivefocus)
		--$focusTotal
		local _focusTotal = math.min(_passivefocus + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusTotal = string.format("|c%s%.0f|r", currentFocusColor, _focusTotal)
		--$focusPlusCasting
		local _focusPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusCasting = string.format("|c%s%.0f|r", castingFocusColor, _focusPlusCasting)
		--$focusPlusPassive
		local _focusPlusPassive = math.min(_passivefocus + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local focusPlusPassive = string.format("|c%s%.0f|r", currentFocusColor, _focusPlusPassive)

		local _trueshotTime = GetTrueshotRemainingTime()
		local trueshotTime = 0
		if _trueshotTime ~= nil then
			trueshotTime = string.format("%.1f", _trueshotTime)
		end

		--$ssCount
		local serpentStingCount = TRB.Data.snapshotData.targetData.serpentSting or 0

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passivefocus
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
		lookup["$trueshotTime"] = trueshotTime
		lookup["$focusPlusCasting"] = focusPlusCasting
		lookup["$ssCount"] = serpentStingCount
		lookup["$focusTotal"] = focusTotal
		lookup["$focusMax"] = TRB.Data.character.maxResource
		lookup["$focus"] = currentfocus
		lookup["$resourcePlusCasting"] = focusPlusCasting
		lookup["$resourcePlusPassive"] = focusPlusPassive
		lookup["$resourceTotal"] = focusTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentfocus
		lookup["$casting"] = castingfocus
		lookup["$passive"] = passivefocus
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$focusOvercap"] = overcap
		TRB.Data.lookup = lookup
	end
	TRB.Functions.RefreshLookupData = RefreshLookupData

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.focus
        TRB.Data.snapshotData.casting.resourceFinal = spell.focus
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
		end
	end

	local function UpdateSnapshot()
        TRB.Functions.UpdateSnapshot()
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

        if TRB.Data.snapshotData.aMurderOfCrows.startTime ~= nil and currentTime > (TRB.Data.snapshotData.aMurderOfCrows.startTime + TRB.Data.snapshotData.aMurderOfCrows.duration) then
            TRB.Data.snapshotData.aMurderOfCrows.startTime = nil
            TRB.Data.snapshotData.aMurderOfCrows.duration = 0
        end

        if TRB.Data.snapshotData.explosiveShot.startTime ~= nil and currentTime > (TRB.Data.snapshotData.explosiveShot.startTime + TRB.Data.snapshotData.explosiveShot.duration) then
            TRB.Data.snapshotData.explosiveShot.startTime = nil
            TRB.Data.snapshotData.explosiveShot.duration = 0
        end
	end    

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		
		if force or GetSpecialization() ~= 2 or ((not affectingCombat) and
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
	end
	TRB.Functions.HideResourceBar = HideResourceBar

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		UpdateSnapshot()

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

                        if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
                            if spell.id == TRB.Data.spells.aimedShot.id then
                                if TRB.Data.snapshotData.aimedShot.charges == 0 then
                                    thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
                                elseif TRB.Data.snapshotData.resource >= -spell.focus then
                                    thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
                                else
                                    thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
                                end
                            elseif spell.id == TRB.Data.spells.killShot.id then
                                local targetUnitHealth = TRB.Functions.GetUnitHealthPercent("target")
                                if targetUnitHealth == nil or targetUnitHealth >= TRB.Data.spells.killShot.healthMinimum then
                                    showThreshold = false
                                elseif TRB.Data.snapshotData.killShot.charges == 0 then
                                    thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
                                elseif TRB.Data.snapshotData.resource >= -spell.focus then
                                    thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
                                else
                                    thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
                                end
                            end
                        elseif spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
                            showThreshold = false
                        elseif spell.hasCooldown then
                            if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
                                thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.unusable
                            elseif TRB.Data.snapshotData.resource >= -spell.focus then
                                thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
                            else
                                thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
                            end
                        else -- This is an active/available/normal spell threshold
                            if TRB.Data.snapshotData.resource >= -spell.focus then
                                thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.over
                            else
                                thresholdColor = TRB.Data.settings.hunter.marksmanship.colors.threshold.under
                            end
                        end                        

                        if TRB.Data.settings.hunter.marksmanship.thresholds[spell.settingKey].enabled and showThreshold then
                            TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()                            
                            resourceFrame.thresholds[spell.thresholdId].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(thresholdColor, true))
                        else
                            TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
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
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		if GetSpecialization() ~= 2 then
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
			--[[if TRB.Data.snapshotData.chainLightning.hitTime ~= nil and currentTime > (TRB.Data.snapshotData.chainLightning.hitTime + 6) then
				TRB.Data.snapshotData.chainLightning.hitTime = nil
				TRB.Data.snapshotData.chainLightning.targetsHit = 0
			end]]
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
				if spellId == TRB.Data.spells.burstingShot.id then
					TRB.Data.snapshotData.burstingShot.startTime, TRB.Data.snapshotData.burstingShot.duration, _, _ = GetSpellCooldown(TRB.Data.spells.burstingShot.id)
				elseif spellId == TRB.Data.spells.barrage.id then
                    TRB.Data.snapshotData.barrage.startTime, TRB.Data.snapshotData.barrage.duration, _, _ = GetSpellCooldown(TRB.Data.spells.barrage.id)
				elseif spellId == TRB.Data.spells.aMurderOfCrows.id then
                    TRB.Data.snapshotData.aMurderOfCrows.startTime, TRB.Data.snapshotData.aMurderOfCrows.duration, _, _ = GetSpellCooldown(TRB.Data.spells.aMurderOfCrows.id)
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

					TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.hunter.marksmanship)
					TRB.Functions.IsTtdActive()		
					FillSpellData()
					ConstructResourceBar()
					TRB.Options.Hunter.ConstructOptionsPanel()

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