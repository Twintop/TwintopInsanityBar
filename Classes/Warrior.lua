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
			barTextVariables = {
				icons = {},
				values = {}
			}
		}
	}

	local function FillSpecCache()
		-- Arms

		specCache.arms.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				passive = 0,
				ravager = 0,
				ancientAftershock = 0,
				conquerorsBanner = 0
			},
			dots = {
				rendCount = 0,
				deepWoundsCount = 0
			},
			ravager = {
				rage = 0,
				ticks = 0
			},
			ancientAftershock = {
				rage = 0,
				ticks = 0
			},
			conquerorsBanner = {
				rage = 0,
				ticks = 0
			}
		}

		specCache.arms.character = {
			guid = UnitGUID("player"),
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			covenantId = 0,
			effects = {
				overgrowthSeedling = 1.0
			},
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
				glory = false,
				naturesFury = false
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
			deepWounds = {
				id = 262115,
				name = "",
				icon = "",
				baseDuration = 10,
				pandemic = true,
				pandemicTime = 3 --Refreshes add 12sec, capping at 15? --10 * 0.3				
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
				thresholdUsable = false,
				baseDuration = 15,
				pandemic = true,
				pandemicTime = 15 * 0.3				
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
				rage = 4,
				idLegendaryBonus = 7469
			},
			ancientAftershock = {
				id = 325886,
				name = "",
				icon = "",
				duration = 12,
				ticks = 4,
				rage = 4,
				idTick = 326062,
				idLegendaryBonus = 7471,
				legendaryDuration = 3,
				legendaryTicks = 1
			},

			-- Torghast
			voraciousCullingBlade = {
				id = 329214, --Maybe 329213
				name = "",
				icon = ""
			},
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
		specCache.arms.snapshotData.conquerorsBanner = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.arms.snapshotData.ancientAftershock = {
			isActive = false,
			ticksRemaining = 0,
			rage = 0,
			endTime = nil,
			lastTick = nil,
			targetsHit = 0,
			hitTime = nil
		}
		specCache.arms.snapshotData.voraciousCullingBlade = {
			isActive = false
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
			{ variable = "#casting", icon = "", description = "The icon of the Rage generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

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
			{ variable = "#voraciousCullingBlade", icon = spells.voraciousCullingBlade.icon, description = spells.voraciousCullingBlade.name, printInSettings = true },
			{ variable = "#whirlwind", icon = spells.whirlwind.icon, description = "Whirlwind", printInSettings = true },			
        }
		specCache.arms.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$rage", description = "Current Rage", printInSettings = true, color = false },
            { variable = "$resource", description = "Current Rage", printInSettings = false, color = false },
			{ variable = "$rageMax", description = "Maximum Rage", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Rage", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Rage from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Rage from Passive Sources including Ravager and Covenant abilities", printInSettings = true, color = false },
			{ variable = "$ragePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Rage Total", printInSettings = false, color = false },
			{ variable = "$ragePlusPassive", description = "Current + Passive Rage Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Rage Total", printInSettings = false, color = false },
			{ variable = "$rageTotal", description = "Current + Passive + Casting Rage Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Rage Total", printInSettings = false, color = false },   

			{ variable = "$rend", description = "Is Rend currently talented. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$deepWoundsCount", description = "Number of Deep Wounds active on targets", printInSettings = true, color = false },
			{ variable = "$deepWoundsTime", description = "Time remaining on Deep Wounds on your current target", printInSettings = true, color = false },
			{ variable = "$rendCount", description = "Number of Rends active on targets", printInSettings = true, color = false },
			{ variable = "$rendTime", description = "Time remaining on Rend on your current target", printInSettings = true, color = false },

			{ variable = "$ravagerTicks", description = "Number of expected ticks remaining on Ravager", printInSettings = true, color = false }, 
			{ variable = "$ravagerRage", description = "Rage from Ravager", printInSettings = true, color = false },   

			{ variable = "$ancientAftershockTicks", description = "Number of ticks remaining on Ancient Aftershock", printInSettings = true, color = false }, 
			{ variable = "$ancientAftershockRage", description = "Rage from Ancient Aftershock", printInSettings = true, color = false },   

			{ variable = "$conquerorsBannerRage", description = "Rage from Conqueror's Banner", printInSettings = true, color = false },
			{ variable = "$conquerorsBannerTicks", description = "Number of ticks remaining on Conqueror's Banner", printInSettings = true, color = false },

			{ variable = "$covenantRage", description = "Rage from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityRage", description = "Rage from Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },
			{ variable = "$covenantTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = true, color = false },
			{ variable = "$covenantAbilityTicks", description = "Number of ticks remaining on Ancient Aftershock or Conqueror's Banner, as appropriate", printInSettings = false, color = false },

			{ variable = "$suddenDeathTime", description = "Time remaining on Sudden Death proc", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
            { variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.arms.spells = spells
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.className = "warrior"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage)

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

			-- Legendaries
			local chestItemLink = GetInventoryItemLink("player", 5)
			local waistItemLink = GetInventoryItemLink("player", 6)
			local wristItemLink = GetInventoryItemLink("player", 9)
			local handItemLink = GetInventoryItemLink("player", 10)
			local backItemLink = GetInventoryItemLink("player", 15)

			local naturesFury = false
			if wristItemLink ~= nil  then
				naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(wristItemLink, 171419, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
			end
			
			if naturesFury == false and handItemLink ~= nil  then
				naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(handItemLink, 171414, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
			end
			
			if naturesFury == false and backItemLink ~= nil  then
				naturesFury = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(backItemLink, 173242, TRB.Data.spells.ancientAftershock.idLegendaryBonus)
			end

			local glory = false
			if chestItemLink ~= nil  then
				glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(chestItemLink, 171412, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
			end
			
			if glory == false and waistItemLink ~= nil  then
				glory = TRB.Functions.DoesItemLinkMatchMatchIdAndHaveBonus(waistItemLink, 171418, TRB.Data.spells.conquerorsBanner.idLegendaryBonus)
			end

			TRB.Data.character.items.naturesFury = naturesFury
			TRB.Data.character.items.glory = glory
        elseif GetSpecialization() == 2 then
		elseif GetSpecialization() == 3 then
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.warrior.arms == true then
			TRB.Functions.IsTtdActive(TRB.Data.settings.warrior.arms)
			TRB.Data.resource = Enum.PowerType.Rage
			TRB.Data.resourceFactor = 10
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

	local function GetSuddenDeathRemainingTime()
		return TRB.Functions.GetSpellRemainingTime(TRB.Data.snapshotData.suddenDeath)
	end

    local function CalculateAbilityResourceValue(resource, includeDeadlyCalm)
        if includeDeadlyCalm == nil then
			includeDeadlyCalm = false
		end

		local modifier = 1.0

		if resource > 0 then

		else
			modifier = modifier * TRB.Data.character.effects.overgrowthSeedlingModifier
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

	local function InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		if guid ~= nil and not TRB.Functions.CheckTargetExists(guid) then
			TRB.Functions.InitializeTarget(guid)
			TRB.Data.snapshotData.targetData.targets[guid].rend = false
			TRB.Data.snapshotData.targetData.targets[guid].rendRemaining = 0
			TRB.Data.snapshotData.targetData.targets[guid].deepWounds = false
			TRB.Data.snapshotData.targetData.targets[guid].deepWoundsRemaining = 0
		end
		TRB.Data.snapshotData.targetData.targets[guid].lastUpdate = GetTime()

		return true
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
		local currentTime = GetTime()
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
		TRB.Data.snapshotData.targetData.deepWounds = deepWoundsTotal
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
			if var == "$ravagerTicks" then
				if TRB.Data.snapshotData.ravager.isActive then
					valid = true
				end
			elseif var == "$ravagerRage" then
				if TRB.Data.snapshotData.ravager.isActive then
					valid = true
				end
			elseif var == "$ancientAftershockTicks" then
				if TRB.Data.snapshotData.ancientAftershock.isActive then
					valid = true
				end
			elseif var == "$ancientAftershockRage" then
				if TRB.Data.snapshotData.ancientAftershock.isActive then
					valid = true
				end
			elseif var == "$conquerorsBannerTicks" then
				if TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$conquerorsBannerRage" then
				if TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$covenantTicks" then
				if TRB.Data.snapshotData.ancientAftershock.isActive or TRB.Data.snapshotData.conquerorsBanner.isActive then
					valid = true
				end
			elseif var == "$covenantRage" then
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
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining > 0 then
					valid = true
				end
			elseif var == "$deepWoundsCount" then
				if TRB.Data.snapshotData.targetData.deepWounds > 0 then
					valid = true
				end
			elseif var == "$deepWoundsTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshotData.targetData.targets ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining > 0 then
					valid = true
				end
            end
		end

		if var == "$resource" or var == "$rage" then
			if normalizedRage > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$rageMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$rageTotal" then
			if normalizedRage > 0 or TRB.Data.snapshotData.ravager.rage > 0 or TRB.Data.snapshotData.ancientAftershock.rage > 0 or
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
			if normalizedRage > 0 or TRB.Data.snapshotData.ravager.rage > 0 or TRB.Data.snapshotData.ancientAftershock.rage > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and TRB.Data.snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if TRB.Data.snapshotData.ravager.rage > 0 or TRB.Data.snapshotData.ancientAftershock.rage > 0 then
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
				if spell ~= nil and spell.thresholdUsable == true then
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

		--$ravagerRage
		local _ravagerRage = TRB.Data.snapshotData.ravager.rage
		local ravagerRage = string.format("%.0f", TRB.Data.snapshotData.ravager.rage)
		--$ravagerTicks
		local ravagerTicks = string.format("%.0f", TRB.Data.snapshotData.ravager.ticksRemaining)
		
		--$ancientAftershockRage
		local _ancientAftershockRage = TRB.Data.snapshotData.ancientAftershock.rage
		local ancientAftershockRage = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.rage)
		--$ancientAftershockTicks
		local ancientAftershockTicks = string.format("%.0f", TRB.Data.snapshotData.ancientAftershock.ticksRemaining)
        
		--$conquerorsBannerRage
		local _conquerorsBannerRage = TRB.Data.snapshotData.conquerorsBanner.rage
		local conquerorsBannerRage = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.rage)
		--$conquerorsBannerTicks
		local conquerorsBannerTicks = string.format("%.0f", TRB.Data.snapshotData.conquerorsBanner.ticksRemaining)
        
		--$suddenDeathTime
		local _suddenDeathTime = GetSuddenDeathRemainingTime()
		local suddenDeathTime
		if _suddenDeathTime ~= nil then
			suddenDeathTime = string.format("%.1f", _suddenDeathTime)
		end

		--$rage
		local ragePrecision = TRB.Data.settings.warrior.arms.ragePrecision or 0
		local currentRage = string.format("|c%s%s|r", currentRageColor, TRB.Functions.RoundTo(normalizedRage, ragePrecision, "floor"))
		--$casting
		local castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.RoundTo(TRB.Data.snapshotData.casting.resourceFinal, ragePrecision, "floor"))
		--$passive
		local _passiveRage = _ravagerRage + _ancientAftershockRage + _conquerorsBannerRage

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

		if TRB.Data.settings.warrior.arms.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rend then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining > TRB.Data.spells.rend.pandemicTime then
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining)
				else
					rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, _rendCount)
					rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].rendRemaining)
				end
			else
				rendCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, _rendCount)
				rendTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWounds then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining > TRB.Data.spells.deepWounds.pandemicTime then
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining)
				else
					deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, _deepWoundsCount)
					deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].deepWoundsRemaining)
				end
			else
				deepWoundsCount = string.format("|c%s%.0f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, _deepWoundsCount)
				deepWoundsTime = string.format("|c%s%.1f|r", TRB.Data.settings.warrior.arms.colors.text.dots.down, 0)
			end
		else
			rendTime = string.format("%.1f", _rendTime)
			deepWoundsTime = string.format("%.1f", _deepWoundsTime)
		end

		--#covenantAbility
		local covenantAbilityIcon = ""
		local covenantAbilityTicks = 0
		local covenantAbilityRage = 0

		if TRB.Data.character.covenantId == 1 then
			covenantAbilityIcon = TRB.Data.spells.spearOfBastion.icon
		elseif TRB.Data.character.covenantId == 2 then
			covenantAbilityIcon = TRB.Data.spells.condemn.icon
		elseif TRB.Data.character.covenantId == 3 then
			covenantAbilityIcon = TRB.Data.spells.ancientAftershock.icon
			covenantAbilityRage = ancientAftershockRage
			covenantAbilityTicks = ancientAftershockTicks
		elseif TRB.Data.character.covenantId == 4 then
			covenantAbilityIcon = TRB.Data.spells.conquerorsBanner.icon
			covenantAbilityRage = conquerorsBannerRage
			covenantAbilityTicks = conquerorsBannerTicks
		end
		----------------------------

		Global_TwintopResourceBar.resource.resource = normalizedRage
		Global_TwintopResourceBar.resource.passive = _passiveRage
		Global_TwintopResourceBar.resource.ravager = _ravagerRage
		Global_TwintopResourceBar.resource.ancientAftershock = _ancientAftershockRage
		Global_TwintopResourceBar.resource.conquerorsBanner = _conquerorsBannerRage
		Global_TwintopResourceBar.dots = {
			rendCount = _rendCount,
			deepWoundsCount = _deepWoundsCount
		}
		Global_TwintopResourceBar.ravager = {
			rage = _ravagerRage,
			ticks = TRB.Data.snapshotData.ravager.ticksRemaining or 0
		}
		Global_TwintopResourceBar.conquerorsBanner = {
			rage = _conquerorsBannerRage,
			ticks = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining or 0
		}
		Global_TwintopResourceBar.ancientAftershock = {
			rage = _ancientAftershockRage,
			ticks = TRB.Data.snapshotData.ancientAftershock.ticksRemaining or 0,
			targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#ancientAftershock"] = TRB.Data.spells.ancientAftershock.icon
		lookup["#charge"] = TRB.Data.spells.charge.icon
		lookup["#cleave"] = TRB.Data.spells.cleave.icon
		lookup["#condemn"] = TRB.Data.spells.condemn.icon
		lookup["#conquerorsBanner"] = TRB.Data.spells.conquerorsBanner.icon
		lookup["#covenantAbility"] = covenantAbilityIcon
		lookup["#deadlyCalm"] = TRB.Data.spells.deadlyCalm.icon
		lookup["#deepWounds"] = TRB.Data.spells.deepWounds.icon
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
		lookup["$rend"] = TRB.Data.character.talents.rend.isSelected
		lookup["$rendCount"] = rendCount
		lookup["$rendTime"] = rendTime
		lookup["$deepWoundsCount"] = deepWoundsCount
		lookup["$deepWoundsTime"] = deepWoundsTime
		lookup["$suddenDeathTime"] = suddenDeathTime
		lookup["$ravagerRage"] = ravagerRage
		lookup["$ravagerTicks"] = ravagerTicks
		lookup["$ancientAftershockRage"] = ancientAftershockRage
		lookup["$ancientAftershockTicks"] = ancientAftershockTicks
		lookup["$conquerorsBannerRage"] = conquerorsBannerRage
		lookup["$conquerorsBannerTicks"] = conquerorsBannerTicks
		lookup["$covenantAbilityRage"] = covenantAbilityRage
		lookup["$covenantRage"] = covenantAbilityRage
		lookup["$covenantAbilityTicks"] = covenantAbilityTicks
		lookup["$covenantTicks"] = covenantAbilityTicks
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
				if TRB.Data.snapshotData.ravager.rage < 0 then
					TRB.Data.snapshotData.ravager.rage = 0
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
				TRB.Data.snapshotData.ancientAftershock.rage = 0
				TRB.Data.snapshotData.ancientAftershock.isActive = false
				TRB.Data.snapshotData.ancientAftershock.hitTime = nil
				TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
				TRB.Data.snapshotData.ancientAftershock.lastTick = nil
			else
				local ticksRemaining = math.ceil((TRB.Data.snapshotData.ancientAftershock.endTime - currentTime) / (TRB.Data.spells.ancientAftershock.duration / TRB.Data.spells.ancientAftershock.ticks))
				TRB.Data.snapshotData.ancientAftershock.ticksRemaining = ticksRemaining
				TRB.Data.snapshotData.ancientAftershock.rage = TRB.Data.snapshotData.ancientAftershock.ticksRemaining * TRB.Data.spells.ancientAftershock.rage * TRB.Data.snapshotData.ancientAftershock.targetsHit
			end
		end
	end

	local function UpdateConquerorsBanner()
		if TRB.Data.snapshotData.conquerorsBanner.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.conquerorsBanner.endTime ~= nil and currentTime > TRB.Data.snapshotData.conquerorsBanner.endTime then
				TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = 0
				TRB.Data.snapshotData.conquerorsBanner.endTime = nil
				TRB.Data.snapshotData.conquerorsBanner.duration = 0
				TRB.Data.snapshotData.conquerorsBanner.rage = 0
				TRB.Data.snapshotData.conquerorsBanner.isActive = false
			elseif TRB.Data.snapshotData.conquerorsBanner.endTime ~= nil then
				_, _, _, _, TRB.Data.snapshotData.conquerorsBanner.duration, TRB.Data.snapshotData.conquerorsBanner.endTime, _, _, _, TRB.Data.snapshotData.conquerorsBanner.spellId = TRB.Functions.FindBuffById(TRB.Data.spells.conquerorsBanner.id)
				TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = math.ceil((TRB.Data.snapshotData.conquerorsBanner.endTime - currentTime) / (TRB.Data.spells.conquerorsBanner.duration / TRB.Data.spells.conquerorsBanner.ticks))
				TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.rage
			end
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
		local currentTime = GetTime()
		TRB.Data.spells.voraciousCullingBlade.isActive = select(10, TRB.Functions.FindBuffById(TRB.Data.spells.voraciousCullingBlade.id))
	end

	local function UpdateSnapshot_Arms()
		UpdateSnapshot()
		UpdateRavager()
		UpdateAncientAftershock()
		UpdateConquerorsBanner()

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
	end  

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
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
			TRB.Functions.RepositionBarForPRD(TRB.Data.settings.warrior.arms)

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

						if TRB.Data.snapshotData.ancientAftershock.rage > 0 then
							passiveValue = passiveValue + TRB.Data.snapshotData.ancientAftershock.rage 
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

									if not showThis or UnitIsDeadOrGhost("target") or targetUnitHealth == nil then
										showThreshold = false
										isUsable = false
									elseif spell.id == TRB.Data.spells.condemn.id and not TRB.Data.spells.voraciousCullingBlade.isActive and ((targetUnitHealth <= TRB.Data.spells.condemn.healthAbove and targetUnitHealth >= TRB.Data.spells.execute.healthMinimum)) then
										showThreshold = false
										isUsable = false
									elseif spell.id == TRB.Data.spells.execute.id and not TRB.Data.spells.voraciousCullingBlade.isActive and (targetUnitHealth >= TRB.Data.spells.execute.healthMinimum) then
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
							if TRB.Data.snapshotData.ravager.rage < 0 then
								TRB.Data.snapshotData.ravager.rage = 0
							end
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
								if TRB.Data.snapshotData.ravager.rage < 0 then
									TRB.Data.snapshotData.ravager.rage = 0
								end
							end
						end
					elseif spellId == TRB.Data.spells.rend.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rend Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].rend = true
								TRB.Data.snapshotData.targetData.rend = TRB.Data.snapshotData.targetData.rend + 1
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].rend = false
								TRB.Data.snapshotData.targetData.targets[destGUID].rendRemaining = 0
								TRB.Data.snapshotData.targetData.rend = TRB.Data.snapshotData.targetData.rend - 1
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.deepWounds.id then
						if InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Deep Wounds Applied to Target
								TRB.Data.snapshotData.targetData.targets[destGUID].deepWounds = true
								TRB.Data.snapshotData.targetData.deepWounds = TRB.Data.snapshotData.targetData.deepWounds + 1
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshotData.targetData.targets[destGUID].deepWounds = false
								TRB.Data.snapshotData.targetData.targets[destGUID].deepWoundsRemaining = 0
								TRB.Data.snapshotData.targetData.deepWounds = TRB.Data.snapshotData.targetData.deepWounds - 1
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.ancientAftershock.id then
						local legendaryDuration = 0
						local legendaryTicks = 0
						if TRB.Data.character.items.naturesFury == true then
							legendaryDuration = TRB.Data.snapshotData.ancientAftershock.legendaryDuration
							legendaryTicks = TRB.Data.snapshotData.ancientAftershock.legendaryTicks
						end

						if type == "SPELL_CAST_SUCCESS" then -- This is incase it doesn't hit any targets
							if TRB.Data.snapshotData.ancientAftershock.hitTime == nil then --This is a new cast without target data. Use the initial number hit to seed predictions
								TRB.Data.snapshotData.ancientAftershock.targetsHit = 0
							end
							TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
							TRB.Data.snapshotData.ancientAftershock.endTime = currentTime + TRB.Data.spells.ancientAftershock.duration + legendaryDuration
							TRB.Data.snapshotData.ancientAftershock.ticksRemaining = TRB.Data.spells.ancientAftershock.ticks + legendaryTicks
							TRB.Data.snapshotData.ancientAftershock.isActive = true
						elseif type == "SPELL_AURA_APPLIED" then
							if TRB.Data.snapshotData.ancientAftershock.hitTime == nil then --This is a new cast without target data. Use the initial number hit to seed predictions
								TRB.Data.snapshotData.ancientAftershock.targetsHit = 1
							else
								TRB.Data.snapshotData.ancientAftershock.targetsHit = TRB.Data.snapshotData.ancientAftershock.targetsHit + 1
							end
							TRB.Data.snapshotData.ancientAftershock.hitTime = currentTime
							TRB.Data.snapshotData.ancientAftershock.endTime = currentTime + TRB.Data.spells.ancientAftershock.duration + legendaryDuration
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
							TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.rage
							TRB.Data.snapshotData.conquerorsBanner.endTime = currentTime + TRB.Data.spells.conquerorsBanner.duration
							TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
						elseif type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.spells.conquerorsBanner.ticks + 1
							TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.rage * TRB.Data.spells.conquerorsBanner.rage
							TRB.Data.snapshotData.conquerorsBanner.endTime = currentTime + TRB.Data.spells.conquerorsBanner.duration + ((TRB.Data.spells.conquerorsBanner.duration / TRB.Data.spells.conquerorsBanner.ticks) - (currentTime - TRB.Data.snapshotData.conquerorsBanner.lastTick))
							TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshotData.conquerorsBanner.isActive = false
							TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = 0
							TRB.Data.snapshotData.conquerorsBanner.rage = 0
							TRB.Data.snapshotData.conquerorsBanner.endTime = nil
							TRB.Data.snapshotData.conquerorsBanner.lastTick = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshotData.conquerorsBanner.ticksRemaining = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining - 1
							TRB.Data.snapshotData.conquerorsBanner.rage = TRB.Data.snapshotData.conquerorsBanner.ticksRemaining * TRB.Data.spells.conquerorsBanner.rage
							TRB.Data.snapshotData.conquerorsBanner.lastTick = currentTime
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
				end
			end
		end
	end)
end
