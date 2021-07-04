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
			},
			dots = {
			}
		}

		specCache.havoc.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 120,
			covenantId = 0,
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
				glaiveTempest = {
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
			--DemonHunter base abilities
			immolationAura = {
				id = 258920,
				name = "",
				icon = "",
				fury = 20,
                cooldown = 30
			},

			--Havoc base abilities
			bladeDance = {
				id = 188499,
				name = "",
				icon = "",
				fury = -35,
                cooldown = 9,
				thresholdId = 1,
				settingKey = "bladeDance",
				isTalent = false,
				hasCooldown = true,
				thresholdUsable = false
			},
            chaosStrike = {
               id = 162794,
               name = "",
               icon = "",
               fury = -40,
			   thresholdId = 2,
			   settingKey = "chaosStrike",
			   isTalent = false,
			   hasCooldown = false,
			   thresholdUsable = false
            },
            demonsBite = {
               id = 162243,
               name = "",
               icon = "",
               fury = 25,
               furyMax = 40
            },
            eyeBeam = {
               id = 198013,
               name = "",
               icon = "",
               fury = -30,
               duration = 2,
			   thresholdId = 3,
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
				id = 320374,
				name = "",
				icon = "",
                fury = 5,
                ticks = 12,
                duration = 12
			},
			glaiveTempest = {
				id = 342817,
				name = "",
				icon = "",
                fury = -30,
                cooldown = 20,
				thresholdId = 4,
				settingKey = "glaiveTempest",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
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
				thresholdId = 5,
				settingKey = "felEruption",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			momentum = {
				id = 206476,
				name = "",
				icon = "",
                fury = 80,
                ticks = 8,
                duration = 10
			},

			-- Covenant
            --[[
			spearOfBastion = {
				id = 307865,
				name = "",
				icon = "",
				fury = 25
			},
			condemn = {
				id = 317349,
				name = "",
				icon = "",
				healthMinimum = 0.2,
				healthAbove = 0.8,
				fury = -20,
				furyMax = -40,
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
				fury = 4
			},
			ancientAftershock = {
				id = 325886,
				name = "",
				icon = "",
				duration = 12,
				ticks = 4,
				fury = 4,
				idTick = 326062
			}
            ]]
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
		specCache.havoc.snapshotData.eyeBeam = {
			endTime = nil,
			duration = 0,
			spellId = nil
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

            --[[
            { variable = "#ancientAftershock", icon = spells.ancientAftershock.icon, description = "Ancient Aftershock", printInSettings = true },
			{ variable = "#charge", icon = spells.charge.icon, description = "Charge", printInSettings = true },
			{ variable = "#cleave", icon = spells.cleave.icon, description = "Cleave", printInSettings = true },
            { variable = "#condemn", icon = spells.condemn.icon, description = "Condemn", printInSettings = true },
            { variable = "#conquerorsBanner", icon = spells.conquerorsBanner.icon, description = "Conqueror's Banner", printInSettings = true },
			{ variable = "#covenantAbility", icon = spells.spearOfBastion.icon .. spells.condemn.icon .. spells.ancientAftershock.icon .. spells.conquerorsBanner.icon, description = "Covenant on-use Ability", printInSettings = true},
			{ variable = "#deadlyCalm", icon = spells.deadlyCalm.icon, description = "Deadly Calm", printInSettings = true },
			{ variable = "#deepWounds", icon = spells.deepWounds.icon, description = "Deep Wounds", printInSettings = true },
			{ variable = "#execute", icon = spells.execute.icon, description = "Execute", printInSettings = true },
			{ variable = "#ignorePain", icon = spells.ignorePain.icon, description = "Ignore Pain", printInSettings = true },
			{ variable = "#impendingVictory", icon = spells.impendingVictory.icon, description = "Impending Victory", printInSettings = true },
			{ variable = "#massacre", icon = spells.massacre.icon, description = "Massacre", printInSettings = true },
			{ variable = "#mortalStrike", icon = spells.mortalStrike.icon, description = "Mortal Strike", printInSettings = true },
			{ variable = "#ravager", icon = spells.ravager.icon, description = "Ravager", printInSettings = true },
			{ variable = "#rend", icon = spells.rend.icon, description = "Rend", printInSettings = true },
			{ variable = "#shieldBlock", icon = spells.shieldBlock.icon, description = "Shield Block", printInSettings = true },
			{ variable = "#skullsplitter", icon = spells.skullsplitter.icon, description = "Skullsplitter", printInSettings = true },
			{ variable = "#slam", icon = spells.slam.icon, description = "Slam", printInSettings = true },
            { variable = "#spearOfBastion", icon = spells.spearOfBastion.icon, description = "Spear of Bastion", printInSettings = true },
			{ variable = "#victoryRush", icon = spells.victoryRush.icon, description = "Victory Rush", printInSettings = true },
			{ variable = "#whirlwind", icon = spells.whirlwind.icon, description = "Whirlwind", printInSettings = true },
            ]]		
        }
		specCache.havoc.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$fury", description = "Current Fury", printInSettings = true, color = false },
            { variable = "$resource", description = "Current Fury", printInSettings = false, color = false },
			{ variable = "$furyMax", description = "Maximum Fury", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Fury", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Fury from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Fury from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Fury from Passive Sources including Ravager and Covenant abilities", printInSettings = true, color = false },
			{ variable = "$furyPlusCasting", description = "Current + Casting Fury Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Fury Total", printInSettings = false, color = false },
			{ variable = "$furyPlusPassive", description = "Current + Passive Fury Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Fury Total", printInSettings = false, color = false },
			{ variable = "$furyTotal", description = "Current + Passive + Casting Fury Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Fury Total", printInSettings = false, color = false },   
            --[[
			{ variable = "$rend", description = "Is Rend currently talented. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$deepWoundsCount", description = "Number of Deep Wounds active on targets", printInSettings = true, color = false },
			{ variable = "$deepWoundsTime", description = "Time remaining on Deep Wounds on your current target", printInSettings = true, color = false },
			{ variable = "$rendCount", description = "Number of Rends active on targets", printInSettings = true, color = false },
			{ variable = "$rendTime", description = "Time remaining on Rend on your current target", printInSettings = true, color = false },

			{ variable = "$ravagerTicks", description = "Number of expected ticks remaining on Ravager", printInSettings = true, color = false }, 
			{ variable = "$ravagerFury", description = "Fury from Ravager", printInSettings = true, color = false },   

			{ variable = "$ancientAftershockTicks", description = "Number of ticks remaining on Ancient Aftershock", printInSettings = true, color = false }, 
			{ variable = "$ancientAftershockFury", description = "Fury from Ancient Aftershock", printInSettings = true, color = false },   

			{ variable = "$conquerorsBannerFury", description = "Fury from Conqueror's Banner", printInSettings = true, color = false },
			{ variable = "$conquerorsBannerTicks", description = "Number of ticks remaining on Conqueror's Banner", printInSettings = true, color = false },

			{ variable = "$covenantFury", description = "Fury from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityFury", description = "Fury from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },
			{ variable = "$covenantTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },

			{ variable = "$suddenDeathTime", description = "Time remaining on Sudden Death proc", printInSettings = true, color = false },
            ]]
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
			TRB.Data.character.talents.burningHatred.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
            TRB.Data.character.talents.glaiveTempest.isSelected = select(4, GetTalentInfo(3, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.unleashedPower.isSelected = select(4, GetTalentInfo(6, 1, TRB.Data.character.specGroup))
            TRB.Data.character.talents.felEruption.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
            TRB.Data.character.talents.momentum.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 then
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
	end
	TRB.Functions.EventRegistration = EventRegistration

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

    local function CalculateAbilityResourceValue(resource)
		local modifier = 1.0
		
		if resource > 0 then

		else
			
		end

        return resource * modifier
    end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
	end

	local function InitializeTarget(guid)
		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
			--TRB.Data.snapshotData.targetData.targets[guid].rend = false
			--TRB.Data.snapshotData.targetData.targets[guid].rendRemaining = 0
			--TRB.Data.snapshotData.targetData.targets[guid].deepWounds = false
			--TRB.Data.snapshotData.targetData.targets[guid].deepWoundsRemaining = 0
		end
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
		--[[local currentTime = GetTime()
		local rendTotal = 0
		local deepWoundsTotal = 0
    	for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
				TRB.Data.snapshotData.targetData.targets[guid].rend = false
				TRB.Data.snapshotData.targetData.targets[guid].rendRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].deepWounds = false
				TRB.Data.snapshotData.targetData.targets[guid].deepWoundsRemaining = 0
			else
				if TRB.Data.snapshotData.targetData.targets[guid].rend == true then
					rendTotal = rendTotal + 1
				end
				if TRB.Data.snapshotData.targetData.targets[guid].deepWounds == true then
					deepWoundsTotal = deepWoundsTotal + 1
				end
			end
		end
		TRB.Data.snapshotData.targetData.rend = rendTotal
		TRB.Data.snapshotData.targetData.deepWounds = deepWoundsTotal]]
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

        --[[
        if specId == 1 then --Havoc
			if var == "$ravagerTicks" then
				if TRB.Data.snapshotData.ravager.isActive then
					valid = true
				end
			elseif var == "$ravagerFury" then
				if TRB.Data.snapshotData.ravager.isActive then
					valid = true
				end
			elseif var == "$ancientAftershockTicks" then
				if TRB.Data.snapshotData.ancientAftershock.isActive then
					valid = true
				end
			elseif var == "$ancientAftershockFury" then
				if TRB.Data.snapshotData.ancientAftershock.isActive then
					valid = true
				end
			elseif var == "$conquerorsBannerTicks" then
				if TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$conquerorsBannerFury" then
				if TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$covenantTicks" then
				if TRB.Data.snapshotData.ancientAftershock.isActive or TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$covenantFury" then
				if TRB.Data.snapshotData.ancientAftershock.isActive or TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$suddenDeathTime" then
				if TRB.Data.snapshotData.suddenDeath.isActive then
					valid = true
				end
			elseif var == "$rend" then
				if TRB.Data.character.talents.rend.isSelected then
					valid = true
				end
			elseif var == "$rendCount" then
				if TRB.Data.snapshotData.targetData.rend > 0 then
					valid = true
				end
			elseif var == "$rendTime" then
				if not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining > 0 then
					valid = true
				end
			elseif var == "$deepWoundsCount" then
				if TRB.Data.snapshotData.targetData.deepWounds > 0 then
					valid = true
				end
			elseif var == "$deepWoundsTime" then
				if not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining > 0 then
					valid = true
				end
            end
		end]]

		if var == "$resource" or var == "$fury" then
			if normalizedFury > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$furyMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$furyTotal" then
			if normalizedFury > 0  or IsValidVariableForSpec("$passive") or
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
			if ((normalizedFury / TRB.Data.resourceFactor) + TRB.Data.snapshotData.casting.resourceFinal) > settings.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$furyPlusPassive" then
			if normalizedFury > 0 or IsValidVariableForSpec("$passive") then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			--[[if TRB.Data.snapshotData.ravager.fury > 0 or TRB.Data.snapshotData.ancientAftershock.fury > 0 then
				valid = true
			end]]
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
            castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.overcap
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
				castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.overThreshold
			end
		end

		if TRB.Data.snapshotData.casting.resourceFinal < 0 then
			castingFuryColor = TRB.Data.settings.demonhunter.havoc.colors.text.spending
		end

        --[[
		--$ravagerFury
		local _ravagerFury = TRB.Data.snapshotData.ravager.fury
		local ravagerFury = string.format("%.0f", TRB.Data.snapshotData.ravager.fury)
		--$ravagerTicks
		local ravagerTicks = string.format("%.0f", TRB.Data.snapshotData.ravager.ticksRemaining)
		
		--$ancientAftershockFury
		local _ancientAftershockFury = TRB.Data.snapshotData.ancientAftershock.fury
		local ancientAftershockFury = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.fury)
		--$ancientAftershockTicks
		local ancientAftershockTicks = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.ticksRemaining)
        
		--$conquerorsBannerFury
		local _conquerorsBannerFury = TRB.Data.snapshotData.conquerorsBanner.fury
		local conquerorsBannerFury = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.fury)
		--$conquerorsBannerTicks
		local conquerorsBannerTicks = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.ticksRemaining)
        
		--$suddenDeathTime
		local _suddenDeathTime = GetSuddenDeathRemainingTime()
		local suddenDeathTime
		if _suddenDeathTime ~= nil then
			suddenDeathTime = string.format("%.1f", _suddenDeathTime)
		end

        ]]
		--$fury
		local furyPrecision = TRB.Data.settings.demonhunter.havoc.furyPrecision or 0
		local currentFury = string.format("|c%s%s|r", currentFuryColor, TRB.Functions.RoundTo(normalizedFury, furyPrecision, "floor"))
		--$casting
		local castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, furyPrecision, "floor"))
		--$passive
		local _passiveFury = 0-- _ravagerFury + _ancientAftershockFury + _conquerorsBannerFury

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

        --[[
		
		--$rendCount and $rendTime
		local _rendCount = TRB.Data.snapshotData.targetData.rend or 0
		local rendCount = _rendCount
		local _rendTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_rendTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining or 0
		end

		local rendTime

		local _deepWoundsCount = TRB.Data.snapshotData.targetData.deepWounds or 0
		local deepWoundsCount = _deepWoundsCount
		local _deepWoundsTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_deepWoundsTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining or 0
		end

		local deepWoundsTime

		if TRB.Data.settings.demonhunter.havoc.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rend then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining > TRB.Data.spells.rend.pandemicTime then
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.up, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining)
				else
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.pandemic, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining)
				end
			else
				rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.down, _rendCount)
				rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWounds then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining > TRB.Data.spells.deepWounds.pandemicTime then
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.up, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining)
				else
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.pandemic, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining)
				end
			else
				deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.down, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.demonhunter.havoc.colors.text.dots.down, 0)
			end
		else
			rendTime = string.format("%.1f", _rendTime)
			deepWoundsTime = string.format("%.1f", _deepWoundsTime)
		end

		--#covenantAbility
		local covenantAbilityIcon = ""
		local covenantAbilityTicks = 0
		local covenantAbilityFury = 0

		if TRB.Data.character.covenantId == 1 then
			covenantAbilityIcon = TRB.Data.spells.spearOfBastion.icon
		elseif TRB.Data.character.covenantId == 2 then
			covenantAbilityIcon = TRB.Data.spells.condemn.icon
		elseif TRB.Data.character.covenantId == 3 then
			covenantAbilityIcon = TRB.Data.spells.ancientAftershock.icon
			covenantAbilityFury = ancientAftershockFury
			covenantAbilityTicks = ancientAftershockTicks
		elseif TRB.Data.character.covenantId == 4 then
			covenantAbilityIcon = TRB.Data.spells.conquerorsBanner.icon
			covenantAbilityFury = conquerorsBannerFury
			covenantAbilityTicks = conquerorsBannerTicks
		end
        ]]
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedFury
		Global_TwintopResourceBar.resource.passive = _passiveFury
		--[[Global_TwintopResourceBar.resource.ravager = _ravagerFury
		Global_TwintopResourceBar.resource.ancientAftershock = _ancientAftershockFury
		Global_TwintopResourceBar.resource.conquerorsBanner = _conquerorsBannerFury
		Global_TwintopResourceBar.dots = {
			rendCount = _rendCount,
			deepWoundsCount = _deepWoundsCount
		}
		Global_TwintopResourceBar.ravager = {
			fury = _ravagerFury,
			ticks = TRB.Data.snapshotData.ravager.ticksRemaining or 0
		}
		Global_TwintopResourceBar.conquerorsBanner = {
			fury = _conquerorsBannerFury,
			ticks = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining or 0
		}
		Global_TwintopResourceBar.ancientAftershock = {
			fury = _ancientAftershockFury,
			ticks = TRB.Data.snapshotData.ancientAftershock.ticksRemaining or 0,
			targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit or 0
		}
        ]]

		local lookup = TRB.Data.lookup or {}
		--[[
        lookup["#ancientAftershock"] = TRB.Data.spells.ancientAftershock.icon
		lookup["#charge"] = TRB.Data.spells.charge.icon
		lookup["#cleave"] = TRB.Data.spells.cleave.icon
		lookup["#condemn"] = TRB.Data.spells.condemn.icon
		lookup["#conquerorsBanner"] = TRB.Data.spells.conquerorsBanner.icon
		lookup["#covenantAbility"] = covenantAbilityIcon
		lookup["#deadlyCalm"] = TRB.Data.spells.deadlyCalm.icon
		lookup["#deepWounds"] = TRB.Data.spells.deadlyCalm.icon
		lookup["#execute"] = TRB.Data.spells.execute.icon
		lookup["#ignorePain"] = TRB.Data.spells.ignorePain.icon
		lookup["#impendingVictory"] = TRB.Data.spells.impendingVictory.icon
		lookup["#massacre"] = TRB.Data.spells.massacre.icon
		lookup["#mortalStrike"] = TRB.Data.spells.mortalStrike.icon
		lookup["#ravager"] = TRB.Data.spells.ravager.icon
		lookup["#rend"] = TRB.Data.spells.rend.icon
		lookup["#shieldBlock"] = TRB.Data.spells.shieldBlock.icon
		lookup["#skullsplitter"] = TRB.Data.spells.skullsplitter.icon
		lookup["#slam"] = TRB.Data.spells.slam.icon
		lookup["#spearOfBastion"] = TRB.Data.spells.spearOfBastion.icon
		lookup["#victoryRush"] = TRB.Data.spells.victoryRush.icon
		lookup["#whirlwind"] = TRB.Data.spells.whirlwind.icon
        ]]
        --[[
		lookup["$rend"] = TRB.Data.character.talents.rend.isSelected
		lookup["$rendCount"] = rendCount
		lookup["$rendTime"] = rendTime
		lookup["$deepWoundsCount"] = deepWoundsCount
		lookup["$deepWoundsTime"] = deepWoundsTime
		lookup["$suddenDeathTime"] = suddenDeathTime
		lookup["$ravagerFury"] = ravagerFury
		lookup["$ravagerTicks"] = ravagerTicks
		lookup["$ancientAftershockFury"] = ancientAftershockFury
		lookup["$ancientAftershockTicks"] = ancientAftershockTicks
		lookup["$conquerorsBannerFury"] = conquerorsBannerFury
		lookup["$conquerorsBannerTicks"] = conquerorsBannerTicks
		lookup["$covenantAbilityFury"] = covenantAbilityFury
		lookup["$covenantFury"] = covenantAbilityFury
		lookup["$covenantAbilityTicks"] = covenantAbilityTicks
		lookup["$covenantTicks"] = covenantAbilityTicks
        ]]
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

    --[[
	local function UpdateRavager()
		if TRB.Data.snapshotData.ravager.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.ravager.endTime == nil or currentTime > TRB.Data.snapshotData.ravager.endTime then
				TRB.Data.snapshotData.ravager.ticksRemaining = 0
				TRB.Data.snapshotData.ravager.endTime = nil
				TRB.Data.snapshotData.ravager.fury = 0
				TRB.Data.snapshotData.ravager.isActive = false
				TRB.Data.snapshotData.ravager.totalDuration = 0
			else
				local ticksRemaining = math.ceil((TRB.Data.snapshotData.ravager.endTime - currentTime) / (TRB.Data.snapshotData.ravager.totalDuration / TRB.Data.spells.ravager.ticks))
				
				if ticksRemaining < TRB.Data.snapshotData.ravager.ticksRemaining then
					TRB.Data.snapshotData.ravager.ticksRemaining = ticksRemaining
				end

				TRB.Data.snapshotData.ravager.fury = TRB.Data.snapshotData.ravager.ticksRemaining * TRB.Data.spells.ravager.fury				
				if TRB.Data.snapshotData.ravager.fury < 0 then
					TRB.Data.snapshotData.ravager.fury = 0
				end
			end
		end
	end

	local function UpdateAncientAftershock()
		if TRB.Data.snapshotData.ancientAftershock.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.ancientAftershock.endTime == nil or currentTime > TRB.Data.snapshotData.ancientAftershock.endTime then
				TRB.Data.snapshotData.ancientAftershock.ticksRemaining = 0
				TRB.Data.snapshotData.ancientAftershock.endTime = nil
				TRB.Data.snapshotData.ancientAftershock.fury = 0
				TRB.Data.snapshotData.ancientAftershock.isActive = false
				TRB.Data.snapshotData.ancientAftershock.hitTime = nil
				TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
				TRB.Data.snapshotData.ancientAftershock.lastTick = nil
			else
				local ticksRemaining = math.ceil((TRB.Data.snapshotData.ancientAftershock.endTime - currentTime) / (TRB.Data.spells.ancientAftershock.duration / TRB.Data.spells.ancientAftershock.ticks))
				TRB.Data.snapshotData.ancientAftershock.ticksRemaining = ticksRemaining
				TRB.Data.snapshotData.ancientAftershock.fury = TRB.Data.snapshotData.ancientAftershock.ticksRemaining * TRB.Data.spells.ancientAftershock.fury * TRB.Data.snapshotData.ancientAftershock.targetsHit
			end
		end
	end

	local function UpdateConquerorsBanner()
		if TRB.Data.snapshotData.conquerorsBanner.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.conquerorsBanner.endTime == nil or currentTime > TRB.Data.snapshotData.conquerorsBanner.endTime then
				TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = 0
				TRB.Data.snapshotData.conquerorsBanner.endTime = nil
				TRB.Data.snapshotData.conquerorsBanner.fury = 0
				TRB.Data.snapshotData.conquerorsBanner.isActive = false
			else
				TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = math.ceil((TRB.Data.snapshotData.conquerorsBanner.endTime - currentTime) / (TRB.Data.spells.conquerorsBanner.duration / TRB.Data.spells.conquerorsBanner.ticks))
				TRB.Data.snapshotData.conquerorsBanner.fury = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.fury
			end
		end
	end
    ]]

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateSnapshot_Havoc()
		UpdateSnapshot()
		--UpdateRavager()
		--UpdateAncientAftershock()
		--UpdateConquerorsBanner()

		local currentTime = GetTime()
		local _

        if TRB.Data.snapshotData.bladeDance.startTime ~= nil and currentTime > (TRB.Data.snapshotData.bladeDance.startTime + TRB.Data.snapshotData.bladeDance.duration) then
			TRB.Data.snapshotData.bladeDance.startTime = nil
            TRB.Data.snapshotData.bladeDance.duration = 0
		elseif TRB.Data.snapshotData.bladeDance.startTime ~= nil then
			TRB.Data.snapshotData.bladeDance.startTime, TRB.Data.snapshotData.bladeDance.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeDance.id)
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

		--[[
		_, _, TRB.Data.snapshotData.suddenDeath.stacks, _, TRB.Data.snapshotData.suddenDeath.duration, TRB.Data.snapshotData.suddenDeath.endTime, _, _, _, TRB.Data.snapshotData.suddenDeath.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.suddenDeath.id, "player")
		_, _, TRB.Data.snapshotData.deadlyCalm.stacks, _, TRB.Data.snapshotData.deadlyCalm.duration, TRB.Data.snapshotData.deadlyCalm.endTime, _, _, _, TRB.Data.snapshotData.deadlyCalm.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.deadlyCalm.id, "player")

		
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rend then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.rend.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWounds then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.deepWounds.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining = expiration - currentTime
				end
			end
		end
		]]
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if force or ((not affectingCombat) and
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
					local gcd = TRB.Functions.GetCurrentGCDTime(true)
					local currentFury = TRB.Data.snapshotData.resource / TRB.Data.resourceFactor

					local passiveValue = 0
					if TRB.Data.settings.demonhunter.havoc.bar.showPassive then
						--[[if TRB.Data.snapshotData.ravager.fury > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.ravager.fury 
						end

						if TRB.Data.snapshotData.ancientAftershock.fury > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.ancientAftershock.fury 
						end
                        ]]
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
							
							TRB.Functions.RepositionThreshold(TRB.Data.settings.demonhunter.havoc, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.demonhunter.havoc.thresholdWidth, -furyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local isUsable = true -- Could use it if we had enough fury, e.g. not on CD
							local thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.over
							local frameLevel = 129

							if spell.isTalent and not TRB.Data.character.talents[spell.settingKey].isSelected then -- Talent not selected
								showThreshold = false
								isUsable = false
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								--[[if spell.id == TRB.Data.spells.execute.id or spell.id == TRB.Data.spells.condemn.id then
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
										TRB.Functions.RepositionThreshold(TRB.Data.settings.demonhunter.havoc, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.demonhunter.havoc.thresholdWidth, -TRB.Data.spells.execute.furyMax, TRB.Data.character.maxResource)
									else
										TRB.Functions.RepositionThreshold(TRB.Data.settings.demonhunter.havoc, resourceFrame.thresholds[spell.thresholdId], resourceFrame, TRB.Data.settings.demonhunter.havoc.thresholdWidth, math.min(math.max(-furyAmount, normalizedFury), -TRB.Data.spells.execute.furyMax), TRB.Data.character.maxResource)
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
									elseif currentFury >= -furyAmount then
										thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.under
										frameLevel = 128
									end
								elseif spell.id == TRB.Data.spells.impendingVictory.id then
									if TRB.Data.snapshotData[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshotData[spell.settingKey].startTime + TRB.Data.snapshotData[spell.settingKey].duration) then
										thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.unusable
										frameLevel = 127
									elseif currentFury >= -furyAmount or TRB.Data.spells.victoryRush.isActive then
										thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.demonhunter.havoc.colors.threshold.under
										frameLevel = 128
									end
								end]]
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
					--[[
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
							
							if TRB.Data.settings.demonhunter.havoc.audio.suddenDeath.enabled then
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
							TRB.Data.snapshotData.ravager.fury = TRB.Data.snapshotData.ravager.ticksRemaining * TRB.Data.spells.ravager.fury
							TRB.Data.snapshotData.ravager.endTime = currentTime + TRB.Data.snapshotData.ravager.totalDuration
							TRB.Data.snapshotData.ravager.lastTick = currentTime
							if TRB.Data.snapshotData.ravager.fury < 0 then
								TRB.Data.snapshotData.ravager.fury = 0
							end
						end
					elseif spellId == TRB.Data.spells.ravager.energizeId then
						if type == "SPELL_ENERGIZE" then						
							TRB.Data.snapshotData.ravager.ticksRemaining = TRB.Data.snapshotData.ravager.ticksRemaining - 1
							if TRB.Data.snapshotData.ravager.ticksRemaining == 0 then
								TRB.Data.snapshotData.ravager.ticksRemaining = 0
								TRB.Data.snapshotData.ravager.endTime = nil
								TRB.Data.snapshotData.ravager.fury = 0
								TRB.Data.snapshotData.ravager.isActive = false
								TRB.Data.snapshotData.ravager.totalDuration = 0
							else
								TRB.Data.snapshotData.ravager.fury = TRB.Data.snapshotData.ravager.ticksRemaining * TRB.Data.spells.ravager.fury
								TRB.Data.snapshotData.ravager.lastTick = currentTime
								if TRB.Data.snapshotData.ravager.fury < 0 then
									TRB.Data.snapshotData.ravager.fury = 0
								end
							end
						end
					elseif spellId == TRB.Data.spells.rend.id then
						InitializeTarget(destGUID)
						TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rend Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].rend = true
							TRB.Data.snapshotData.targetData.rend = TRB.Data.snapshotData.targetData.rend + 1
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].rend = false
							TRB.Data.snapshotData.targetData.targets[destGUID].rendRemaining = 0
							TRB.Data.snapshotData.targetData.rend = TRB.Data.snapshotData.targetData.rend - 1
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					elseif spellId == TRB.Data.spells.deepWounds.id then
						InitializeTarget(destGUID)
						TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Deep Wounds Applied to Target
							TRB.Data.snapshotData.targetData.targets[destGUID].deepWounds = true
							TRB.Data.snapshotData.targetData.deepWounds = TRB.Data.snapshotData.targetData.deepWounds + 1
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.targetData.targets[destGUID].deepWounds = false
							TRB.Data.snapshotData.targetData.targets[destGUID].deepWoundsRemaining = 0
							TRB.Data.snapshotData.targetData.deepWounds = TRB.Data.snapshotData.targetData.deepWounds - 1
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					elseif spellId == TRB.Data.spells.ancientAftershock.id then
						if type == "SPELL_CAST_SUCCESS" then -- This is incase it doesn't hit any targets
							if TRB.Data.snapshotData.ancientAftershock.hitTime == nil then --This is a new cast without target data. Use the initial number hit to seed predictions
								TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
							end
							TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
							TRB.Data.snapshotData.ancientAftershock.endTime = currentTime + TRB.Data.spells.ancientAftershock.duration
							TRB.Data.snapshotData.ancientAftershock.ticksRemaining = TRB.Data.spells.ancientAftershock.ticks
							TRB.Data.snapshotData.ancientAftershock.isActive = true
						elseif type == "SPELL_AURA_APPLIED" then
							if TRB.Data.snapshotData.ancientAftershock.hitTime == nil then --This is a new cast without target data. Use the initial number hit to seed predictions
								TRB.Data.snapshotData.ancientAftershock.targetsHit = 1
							else
								TRB.Data.snapshotData.ancientAftershock.targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit + 1
							end
							TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
							TRB.Data.snapshotData.ancientAftershock.endTime = currentTime + TRB.Data.spells.ancientAftershock.duration
							TRB.Data.snapshotData.ancientAftershock.isActive = true
						end
					elseif spellId == TRB.Data.spells.ancientAftershock.idTick then
						if type == "SPELL_DAMAGE" and TRB.Data.snapshotData.ancientAftershock.hitTime ~= nil then
							if currentTime > (TRB.Data.snapshotData.ancientAftershock.hitTime + 0.1) then --This is a new tick
								TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
							end
							TRB.Data.snapshotData.ancientAftershock.targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit + 1
							TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
						end
					elseif spellId == TRB.Data.spells.conquerorsBanner.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Conqueror's Banner
							TRB.Data.snapshotData.conquerorsBanner.isActive = true
							TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.spells.conquerorsBanner.ticks
							TRB.Data.snapshotData.conquerorsBanner.fury = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.fury
							TRB.Data.snapshotData.conquerorsBanner.endTime = currentTime + TRB.Data.spells.conquerorsBanner.duration
							TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.spells.conquerorsBanner.ticks + 1
							TRB.Data.snapshotData.conquerorsBanner.fury = TRB.Data.snapshotData.conquerorsBanner.fury * TRB.Data.spells.conquerorsBanner.fury
							TRB.Data.snapshotData.conquerorsBanner.endTime = currentTime + TRB.Data.spells.conquerorsBanner.duration + ((TRB.Data.spells.conquerorsBanner.duration / TRB.Data.spells.conquerorsBanner.ticks) - (currentTime - TRB.Data.snapshotData.conquerorsBanner.lastTick))
							TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.conquerorsBanner.isActive = false
							TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = 0
							TRB.Data.snapshotData.conquerorsBanner.fury = 0
							TRB.Data.snapshotData.conquerorsBanner.endTime = nil
							TRB.Data.snapshotData.conquerorsBanner.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining - 1
							TRB.Data.snapshotData.conquerorsBanner.fury = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.fury
							TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
						end
                    ]]
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
					TRB.Options.DemonHunter.ConstructOptionsPanel(specCache)
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
					TRB.Functions.HideResourceBar()
				end
			end
		end
	end)
end
