local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 7 then --Only do this if we're on a Shaman!
	TRB.Frames.resourceFrame.thresholds[1] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)

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
            fsCount = 0
		},
		chainLightning = {
			targetsHit = 0
		}
    }
    
	TRB.Data.character = {
		guid = UnitGUID("player"),
		specGroup = GetActiveSpecGroup(),
		maxResource = 100,
		earthShockThreshold = 60,
		talents = {
			echoingShock = {
				isSelected = false,
				modifier = 2,
				duration = 1.0
			},
			elementalBlast = {
				isSelected = false
			},
			surgeOfPower = {
				isSelected = false
			},
			icefury = {
				isSelected = false
			},
			stormkeeper = {
				isSelected = false
			},
			ascendance = {
				isSelected = false
			}
		},
		items = {
		}
	}

	TRB.Data.spells = {
		lightningBolt = {
			id = 188196,
			name = "",
			icon = "",
			maelstrom = 8,
			overload = 3,
			echoingShock = true
		},
		lavaBurst = {
			id = 51505,
			name = "",
			icon = "",
			maelstrom = 10,
			echoingShock = true
		},

		chainLightning = {
			id = 188443,
			name = "",
			icon = "",
			maelstrom = 4,
			overload = 3,
			echoingShock = true
		},
		lavaBeam = {
			id = 114074,
			name = "",
			icon = "",
			maelstrom = 4, --Tooltip says 3, but spell ID 217891 and in game says 4
			overload = 3,
			echoingShock = false
		},

        flameShock = {
            id = 188389,
            name = "",
            icon = "",
			baseDuration = 18,
			pandemic = true,
			pandemicTime = 18 * 0.3
        },
        frostShock = {
            id = 196840,
            name = "",
			icon = "",
			maelstrom = 8,
			echoingShock = false
        },
        lightningShield = {
            id = 192106,
            name = "",
            icon = "",
            maelstrom = 5,
			echoingShock = false
		},

		elementalBlast = {
			id = 117014,
			name = "",
			icon = "",
			maelstrom = 30,
			overload = 15,
			echoingShock = false --Is this possible to do?
		},
		echoingShock = {
			id = 320125,
			name = "", 
			icon = ""
		},


		surgeOfPower = {
			id = 285514,
			name = "", 
			icon = "",
			isActive = false
		},
		icefury = {
			id = 210714,
			name = "",
			icon = "",
			maelstrom = 25,
			overload = 12,
			echoingShock = true,
			stacks = 4,
			duration = 15
		},

		stormkeeper = {
			id = 191634,
			name = "",
			icon = "",
			stacks = 2,
			duration = 15
		},
		ascendance = {
			id = 114050,
			name = "", 
			icon = ""
		}   
    }
    
	TRB.Data.snapshotData.audio = {
		playedEsCue = false
    }    
	TRB.Data.snapshotData.chainLightning = {
		targetsHit = 0,
		hitTime = nil,
		hasStruckTargets = false
	}
	TRB.Data.snapshotData.surgeOfPower = {
		isActive = false
	}
	TRB.Data.snapshotData.icefury = {
		isActive = false,
		stacksRemaining = 0,
		startTime = nil,
		maelstrom = 0
	}
	TRB.Data.snapshotData.stormkeeper = {
		isActive = false,
		spell = nil
	}
	TRB.Data.snapshotData.echoingShock = {
		isActive = false,
		spell = nil
	}
	TRB.Data.snapshotData.echoingShock = {
		isActive = false,
		spell = nil
	}
	TRB.Data.snapshotData.targetData = {
		ttdIsActive = false,
		currentTargetGuid = nil,
		flameShock = 0,
		targets = {}
	}

	local function FillSpellData()
		TRB.Functions.FillSpellData()

		-- This is done here so that we can get icons for the options menu!
		TRB.Data.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Maelstrom generating spell you are currently hardcasting", printInSettings = true },
			--{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#ascendance", icon = TRB.Data.spells.ascendance.icon, description = TRB.Data.spells.ascendance.name, printInSettings = true },
			{ variable = "#chainLightning", icon = TRB.Data.spells.chainLightning.icon, description = TRB.Data.spells.chainLightning.name, printInSettings = true },
			{ variable = "#echoingShock", icon = TRB.Data.spells.echoingShock.icon, description = TRB.Data.spells.echoingShock.name, printInSettings = true },
			{ variable = "#elementalBlast", icon = TRB.Data.spells.elementalBlast.icon, description = TRB.Data.spells.elementalBlast.name, printInSettings = true },
			{ variable = "#flameShock", icon = TRB.Data.spells.flameShock.icon, description = TRB.Data.spells.flameShock.name, printInSettings = true },
			{ variable = "#frostShock", icon = TRB.Data.spells.frostShock.icon, description = TRB.Data.spells.frostShock.name, printInSettings = true },
			{ variable = "#icefury", icon = TRB.Data.spells.icefury.icon, description = TRB.Data.spells.icefury.name, printInSettings = true },
			{ variable = "#lavaBeam", icon = TRB.Data.spells.lavaBeam.icon, description = TRB.Data.spells.lavaBeam.name, printInSettings = true },
			{ variable = "#lavaBurst", icon = TRB.Data.spells.lavaBurst.icon, description = TRB.Data.spells.lavaBurst.name, printInSettings = true },
			{ variable = "#lightningBolt", icon = TRB.Data.spells.lightningBolt.icon, description = TRB.Data.spells.lightningBolt.name, printInSettings = true },
			{ variable = "#lightningShield", icon = TRB.Data.spells.lightningShield.icon, description = TRB.Data.spells.lightningShield.name, printInSettings = true },
			{ variable = "#stormkeeper", icon = TRB.Data.spells.stormkeeper.icon, description = TRB.Data.spells.stormkeeper.name, printInSettings = true },
		}
		TRB.Data.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },

			{ variable = "$isKyrian", description = "Is the character a member of the Kyrian Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNecrolord", description = "Is the character a member of the Necrolord Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isNightFae", description = "Is the character a member of the Night Fae Covenant? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$isVenthyr", description = "Is the character a member of the Venthyr Covenant? Logic variable only!", printInSettings = true, color = false },

			{ variable = "$maelstrom", description = "Current Maelstrom", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Maelstrom", printInSettings = false, color = false },
			{ variable = "$maelstromMax", description = "Maximum Maelstrom", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Maelstrom", printInSettings = false, color = false },
			{ variable = "$casting", description = "Maelstrom from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Maelstrom from Passive Sources", printInSettings = true, color = false },
			{ variable = "$maelstromPlusCasting", description = "Current + Casting Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Maelstrom Total", printInSettings = false, color = false },
			{ variable = "$maelstromPlusPassive", description = "Current + Passive Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Maelstrom Total", printInSettings = false, color = false },
			{ variable = "$maelstromTotal", description = "Current + Passive + Casting Maelstrom Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Maelstrom Total", printInSettings = false, color = false },   

			{ variable = "$fsCount", description = "Number of Flame Shocks active on targets", printInSettings = true, color = false },
			{ variable = "$fsTime", description = "Time remaining on Flame Shock on your current target", printInSettings = true, color = false },

			{ variable = "$ifStacks", description = "Number of Icefury Frost Shock stacks remaining", printInSettings = true, color = false },
			{ variable = "$ifMaelstrom", description = "Total Maelstrom from available Icefury Frost Shock stacks", printInSettings = true, color = false },
			{ variable = "$ifTime", description = "Time remaining on Icefury buff", printInSettings = true, color = false },

			{ variable = "$skStacks", description = "Number of Stormkeeper stacks remaining", printInSettings = true, color = false },
			{ variable = "$skTime", description = "Time remaining on Stormkeeper buff", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		
		TRB.Data.character.className = "shaman"
		TRB.Data.character.specName = "elemental"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom)
		TRB.Data.character.talents.echoingShock.isSelected = select(4, GetTalentInfo(2, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.elementalBlast.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.surgeOfPower.isSelected = select(4, GetTalentInfo(6, 1, TRB.Data.character.specGroup))
		TRB.Data.character.talents.icefury.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.stormkeeper.isSelected = select(4, GetTalentInfo(7, 2, TRB.Data.character.specGroup))
		TRB.Data.character.talents.ascendance.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))

		TRB.Data.character.earthShockThreshold = 60

		if TRB.Data.settings.shaman ~= nil and TRB.Data.settings.shaman.elemental ~= nil and TRB.Data.settings.shaman.elemental.earthShockThreshold and TRB.Data.character.earthShockThreshold < TRB.Data.character.maxResource then
			resourceFrame.thresholds[1]:Show()
			TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.elemental, resourceFrame.thresholds[1], resourceFrame, TRB.Data.settings.shaman.elemental.thresholdWidth, TRB.Data.character.earthShockThreshold, TRB.Data.character.maxResource)
		else
			resourceFrame.thresholds[1]:Hide()
		end
	end
	TRB.Functions.CheckCharacter_Class = CheckCharacter

	local function EventRegistration()
		if GetSpecialization() == 1 then
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
			TRB.Data.resource = Enum.PowerType.Maelstrom
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
			TRB.Data.snapshotData.targetData.targets[guid].flameShock = false
			TRB.Data.snapshotData.targetData.targets[guid].flameShockRemaining = 0
			TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell = nil
		end
	end
	TRB.Functions.InitializeTarget_Class = InitializeTarget

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local fsTotal = 0
		local echoingShockSpell = nil
		for guid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[guid].lastUpdate) > 10 then
				TRB.Data.snapshotData.targetData.targets[guid].flameShock = false
				TRB.Data.snapshotData.targetData.targets[guid].flameShockRemaining = 0
				TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell = nil
			else
				if TRB.Data.snapshotData.targetData.targets[guid].flameShock == true then
					fsTotal = fsTotal + 1
				end

				if TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell ~= nil then
					if currentTime > TRB.Data.snapshotData.targetData.targets[guid].echoingShockExpiration then
						TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell = nil
						TRB.Data.snapshotData.targetData.targets[guid].echoingShockExpiration = nil
					else
						echoingShockSpell = TRB.Data.snapshotData.targetData.targets[guid].echoingShockSpell
					end
				end
			end
		end
		TRB.Data.snapshotData.targetData.flameShock = fsTotal
		TRB.Data.snapshotData.echoingShock.spell = echoingShockSpell
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.flameShock = 0
			TRB.Data.snapshotData.echoingShock.spell = nil
		end
	end

	local function ConstructResourceBar()
		TRB.Functions.ConstructResourceBar(TRB.Data.settings.shaman.elemental)
	end

    local function IsValidVariableForSpec(var)
		local valid = TRB.Functions.IsValidVariableBase(var)
		if valid then
			return valid
		end

		if var == "$resource" or var == "$maelstrom" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$maelstromMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$maelstromTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.lavaBeam.id)) or
				(TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0)then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$maelstromPlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.lavaBeam.id)) then
				valid = true
			end
		elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
			if (TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal) > TRB.Data.settings.shaman.elemental.overcapThreshold then
				valid = true
			end
		elseif var == "$resourcePlusPassive" or var == "$maelstromPlusPassive" then
			if TRB.Data.snapshotData.resource > 0 or (TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0) then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id) then
				valid = true
			end
		elseif var == "$passive" then
			if TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0 then
				valid = true
			end
		elseif var == "$fsCount" then
			if TRB.Data.snapshotData.targetData.flameShock > 0 then
				valid = true
			end
		elseif var == "$fsTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshotData.targetData.targets ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining > 0 then
				valid = true
			end
		elseif var == "$ifMaelstrom" then
			if TRB.Data.snapshotData.icefury.maelstrom > 0 then
				valid = true
			end
		elseif var == "$ifStacks" then
			if TRB.Data.snapshotData.icefury.stacksRemaining > 0 then
				valid = true
			end
		elseif var == "$ifTime" then
			if TRB.Data.snapshotData.icefury.startTime ~= nil and TRB.Data.snapshotData.icefury.startTime > 0 then
				valid = true
			end
		elseif var == "$skStacks" then
			if TRB.Data.snapshotData.stormkeeper.stacksRemaining > 0 then
				valid = true
			end
		elseif var == "$skTime" then
			if TRB.Data.snapshotData.stormkeeper.startTime ~= nil and TRB.Data.snapshotData.stormkeeper.startTime > 0 then
				valid = true
			end
		else
			valid = false
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

	local function RefreshLookupData()
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = IsValidVariableForSpec("$overcap")

		local currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom
		local castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.castingMaelstrom

		local maelstromThreshold = TRB.Data.character.earthShockThreshold

		if TRB.Data.settings.shaman.elemental.colors.text.overcapEnabled and overcap then 
			currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom
			castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom
		elseif TRB.Data.settings.shaman.elemental.colors.text.overThresholdEnabled and TRB.Data.snapshotData.resource >= maelstromThreshold then
			currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overThreshold
			castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overThreshold
		end

		--$maelstrom
		local currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, TRB.Data.snapshotData.resource)
		--$casting
		local castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _passiveMaelstrom = 0

		if TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0 then
			_passiveMaelstrom = _passiveMaelstrom + TRB.Data.snapshotData.echoingShock.spell.maelstrom
		end

		local passiveMaelstrom = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.passiveMaelstrom, _passiveMaelstrom)
		--$maelstromTotal
		local _maelstromTotal = math.min(_passiveMaelstrom + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromTotal = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromTotal)
		--$maelstromPlusCasting
		local _maelstromPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromPlusCasting = string.format("|c%s%.0f|r", castingMaelstromColor, _maelstromPlusCasting)
		--$maelstromPlusPassive
		local _maelstromPlusPassive = math.min(_passiveMaelstrom + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromPlusPassive = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromPlusPassive)

		----------
		--$fsCount and $fsTime
		local _flameShockCount = TRB.Data.snapshotData.targetData.flameShock or 0
		local flameShockCount = _flameShockCount
		local _flameShockTime = 0
		
		if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil then
			_flameShockTime = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining or 0
		end

		local flameShockTime

		if TRB.Data.settings.shaman.elemental.colors.text.dots.enabled and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShock then
				if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining > TRB.Data.spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining)
				else
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining)
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, 0)
			end
		else
			flameShockTime = string.format("%.1f", _flameShockTime)
		end

		----------
		--Icefury
		--$ifMaelstrom
		local icefuryMaelstrom = TRB.Data.snapshotData.icefury.maelstrom or 0
		--$ifStacks
		local icefuryStacks = TRB.Data.snapshotData.icefury.stacksRemaining or 0
		--$ifStacks
		local icefuryTime = 0
		if TRB.Data.snapshotData.icefury.startTime ~= nil then
			icefuryTime = string.format("%.1f", math.abs(currentTime - (TRB.Data.snapshotData.icefury.startTime + TRB.Data.spells.icefury.duration)))
		end

		--$skStacks
		local stormkeeperStacks = TRB.Data.snapshotData.stormkeeper.stacksRemaining or 0
		--$skStacks
		local stormkeeperTime = 0
		if TRB.Data.snapshotData.stormkeeper.startTime ~= nil then
			stormkeeperTime = string.format("%.1f", math.abs(currentTime - (TRB.Data.snapshotData.stormkeeper.startTime + TRB.Data.spells.stormkeeper.duration)))
		end
		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveMaelstrom
		Global_TwintopResourceBar.resource.icefury = icefuryMaelstrom
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}
		Global_TwintopResourceBar.chainLightning = {
			targetsHit = TRB.Data.snapshotData.chainLightning.targetsHit or 0
		}
		Global_TwintopResourceBar.icefury = {
			maelstrom = icefuryMaelstrom,
			stacks = icefuryStacks,
			remaining = icefuryTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = TRB.Data.spells.ascendance.icon
		lookup["#chainLightning"] = TRB.Data.spells.chainLightning.icon
		lookup["#echoingShock"] = TRB.Data.spells.echoingShock.icon
		lookup["#elementalBlast"] = TRB.Data.spells.elementalBlast.icon
		lookup["#flameShock"] = TRB.Data.spells.flameShock.icon
		lookup["#frostShock"] = TRB.Data.spells.frostShock.icon
		lookup["#icefury"] = TRB.Data.spells.icefury.icon
		lookup["#lavaBeam"] = TRB.Data.spells.lavaBeam.icon
		lookup["#lavaBurst"] = TRB.Data.spells.lavaBurst.icon
		lookup["#lightningBolt"] = TRB.Data.spells.lightningBolt.icon
		lookup["#lightningShield"] = TRB.Data.spells.lightningShield.icon
		lookup["#stormkeeper"] = TRB.Data.spells.stormkeeper.icon
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
		lookup["$maelstromPlusCasting"] = maelstromPlusCasting
		lookup["$maelstromPlusPassive"] = maelstromPlusPassive
		lookup["$maelstromTotal"] = maelstromTotal
		lookup["$maelstromMax"] = TRB.Data.character.maxResource
		lookup["$maelstrom"] = currentMaelstrom
		lookup["$resourcePlusCasting"] = maelstromPlusCasting
		lookup["$resourcePlusPassive"] = maelstromPlusPassive
		lookup["$resourceTotal"] = maelstromTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentMaelstrom
		lookup["$casting"] = castingMaelstrom
		lookup["$passive"] = passiveMaelstrom
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$maelstromOvercap"] = overcap
		lookup["$ifMaelstrom"] = icefuryMaelstrom
		lookup["$ifStacks"] = icefuryStacks
		lookup["$ifTime"] = icefuryTime
		lookup["$skStacks"] = stormkeeperStacks
		lookup["$skTime"] = stormkeeperTime
		TRB.Data.lookup = lookup
	end
	TRB.Functions.RefreshLookupData = RefreshLookupData

    local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
        TRB.Data.snapshotData.casting.startTime = currentTime
        TRB.Data.snapshotData.casting.resourceRaw = spell.maelstrom
        TRB.Data.snapshotData.casting.resourceFinal = spell.maelstrom
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
				TRB.Functions.ResetCastingSnapshotData()
				return false
                --See Priest implementation for handling channeled spells
			else
				local spellName = select(1, currentSpell)
				if spellName == TRB.Data.spells.lightningBolt.name then
					FillSnapshotDataCasting(TRB.Data.spells.lightningBolt)

					if TRB.Data.spells.surgeOfPower.isActive then
						TRB.Data.snapshotData.casting.resourceRaw = TRB.Data.snapshotData.casting.resourceRaw + TRB.Data.spells.lightningBolt.overload
						TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.spells.lightningBolt.overload
					end
				elseif spellName == TRB.Data.spells.lavaBurst.name then
                    FillSnapshotDataCasting(TRB.Data.spells.lavaBurst)
				elseif spellName == TRB.Data.spells.elementalBlast.name then
                    FillSnapshotDataCasting(TRB.Data.spells.elementalBlast)
				elseif spellName == TRB.Data.spells.icefury.name then
                    FillSnapshotDataCasting(TRB.Data.spells.icefury)
                elseif spellName == TRB.Data.spells.chainLightning.name or spellName == TRB.Data.spells.lavaBeam.name then 
                    local spell = nil
                    if spellName == TRB.Data.spells.lavaBeam.name then
                        spell = TRB.Data.spells.lavaBeam
                    else
                        spell = TRB.Data.spells.chainLightning
                    end
                    FillSnapshotDataCasting(spell)
                    
                    local currentTime = GetTime()
					local down, up, lagHome, lagWorld = GetNetStats()
					local latency = lagWorld / 1000

					if TRB.Data.snapshotData.chainLightning.hitTime == nil then
						TRB.Data.snapshotData.chainLightning.targetsHit = 1
						TRB.Data.snapshotData.chainLightning.hitTime = currentTime
						TRB.Data.snapshotData.chainLightning.hasStruckTargets = false
					elseif currentTime > (TRB.Data.snapshotData.chainLightning.hitTime + (TRB.Functions.GetCurrentGCDTime(true) * 3) + latency) then
						TRB.Data.snapshotData.chainLightning.targetsHit = 0
					end

                    TRB.Data.snapshotData.casting.resourceRaw = spell.maelstrom * TRB.Data.snapshotData.chainLightning.targetsHit
                    TRB.Data.snapshotData.casting.resourceFinal = spell.maelstrom * TRB.Data.snapshotData.chainLightning.targetsHit
				else
					TRB.Functions.ResetCastingSnapshotData()
					return false
				end
			end
			return true
		end
	end

	local function UpdateIcefury()
		if TRB.Data.snapshotData.icefury.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshotData.icefury.startTime == nil or currentTime > (TRB.Data.snapshotData.icefury.startTime + TRB.Data.spells.icefury.duration) then
				TRB.Data.snapshotData.icefury.stacksRemaining = 0
				TRB.Data.snapshotData.icefury.startTime = nil
				TRB.Data.snapshotData.icefury.astralPower = 0
				TRB.Data.snapshotData.icefury.isActive = false
			end
		end
	end

	local function UpdateSnapshot()
		local currentTime = GetTime()
		TRB.Functions.UpdateSnapshot()
		UpdateIcefury()
		
		if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] then
			if TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShock then
				local expiration = select(6, TRB.Functions.FindDebuffById(TRB.Data.spells.flameShock.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].flameShockRemaining = expiration - currentTime
				end
			end
		end    
	end

	local function HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")

		if force or GetSpecialization() ~= 1 or ((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.shaman.elemental.displayBar.alwaysShow) and (
					(not TRB.Data.settings.shaman.elemental.displayBar.notZeroShow) or
					(TRB.Data.settings.shaman.elemental.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
				)
			 )) then
			TRB.Frames.barContainerFrame:Hide()
			TRB.Data.snapshotData.isTracking = false
		else
			TRB.Data.snapshotData.isTracking = true
			if TRB.Data.settings.shaman.elemental.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	end
	TRB.Functions.HideResourceBar = HideResourceBar

	local function UpdateResourceBar()
		local refreshText = false
		UpdateSnapshot()
		TRB.Functions.RepositionBarForPRD(TRB.Data.settings.shaman.elemental)

		if TRB.Data.snapshotData.isTracking then
			TRB.Functions.HideResourceBar()

			if TRB.Data.settings.shaman.elemental.displayBar.neverShow == false then
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0

				if TRB.Data.settings.shaman.elemental.colors.bar.overcapEnabled and IsValidVariableForSpec("$overcap") then
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.borderOvercap, true))

					if TRB.Data.settings.shaman.elemental.audio.overcap.enabled and TRB.Data.snapshotData.audio.overcapCue == false then
						TRB.Data.snapshotData.audio.overcapCue = true
						PlaySoundFile(TRB.Data.settings.shaman.elemental.audio.overcap.sound, TRB.Data.settings.core.audio.channel.channel)
					end
				else
					barBorderFrame:SetBackdropBorderColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.border, true))
					TRB.Data.snapshotData.audio.overcapCue = false
				end

				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.elemental, resourceFrame, TRB.Data.snapshotData.resource)

				if CastingSpell() and TRB.Data.settings.shaman.elemental.bar.showCasting then
					castingBarValue = TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal
				else
					castingBarValue = TRB.Data.snapshotData.resource
				end

				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.elemental, castingFrame, castingBarValue)

				if TRB.Data.settings.shaman.elemental.bar.showPassive then
					if TRB.Data.snapshotData.echoingShock.spell ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom ~= nil and TRB.Data.snapshotData.echoingShock.spell.maelstrom > 0 then
						passiveBarValue = TRB.Data.snapshotData.echoingShock.spell.maelstrom + castingBarValue
					else
						passiveBarValue = castingBarValue
					end
				else
					passiveBarValue = castingBarValue
				end

				TRB.Functions.SetBarCurrentValue(TRB.Data.settings.shaman.elemental, passiveFrame, passiveBarValue)

				if TRB.Data.settings.shaman.elemental.earthShockThreshold then
					resourceFrame.thresholds[1]:Show()
				else
					resourceFrame.thresholds[1]:Hide()
				end

				if TRB.Data.snapshotData.resource >= TRB.Data.character.earthShockThreshold then
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.earthShock, true))
---@diagnostic disable-next-line: undefined-field
					resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.threshold.over, true))
					if TRB.Data.settings.shaman.elemental.colors.bar.flashEnabled then
						TRB.Functions.PulseFrame(barContainerFrame, TRB.Data.settings.shaman.elemental.colors.bar.flashAlpha, TRB.Data.settings.shaman.elemental.colors.bar.flashPeriod)
					else
						barContainerFrame:SetAlpha(1.0)
					end

					if TRB.Data.settings.shaman.elemental.audio.esReady.enabled and TRB.Data.snapshotData.audio.playedEsCue == false then
						TRB.Data.snapshotData.audio.playedEsCue = true
						PlaySoundFile(TRB.Data.settings.shaman.elemental.audio.esReady.sound, TRB.Data.settings.core.audio.channel.channel)
					end
				else
---@diagnostic disable-next-line: undefined-field
					resourceFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.threshold.under, true))
					barContainerFrame:SetAlpha(1.0)
					resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.base, true))
					TRB.Data.snapshotData.audio.playedEsCue = false
				end
			end
		end
		TRB.Functions.UpdateResourceBar(TRB.Data.settings.shaman.elemental, refreshText)
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

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if sourceGUID == TRB.Data.character.guid then 
				if spellId == TRB.Data.spells.flameShock.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- FS Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].flameShock = true
						TRB.Data.snapshotData.targetData.flameShock = TRB.Data.snapshotData.targetData.flameShock + 1
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.targetData.targets[destGUID].flameShock = false
						TRB.Data.snapshotData.targetData.targets[destGUID].flameShockRemaining = 0
						TRB.Data.snapshotData.targetData.flameShock = TRB.Data.snapshotData.targetData.flameShock - 1
					--elseif type == "SPELL_PERIODIC_DAMAGE" then
					end
				elseif spellId == TRB.Data.spells.chainLightning.id or spellId == TRB.Data.spells.lavaBeam.id then
					if type == "SPELL_DAMAGE" then
						if TRB.Data.snapshotData.chainLightning.hitTime == nil or currentTime > (TRB.Data.snapshotData.chainLightning.hitTime + 0.1) then --This is a new hit
							TRB.Data.snapshotData.chainLightning.targetsHit = 0
						end
						TRB.Data.snapshotData.chainLightning.targetsHit = TRB.Data.snapshotData.chainLightning.targetsHit + 1
						TRB.Data.snapshotData.chainLightning.hitTime = currentTime
						TRB.Data.snapshotData.chainLightning.hasStruckTargets = true
                    end
				elseif spellId == TRB.Data.spells.icefury.id then
					if type == "SPELL_AURA_APPLIED" then -- Icefury
						TRB.Data.snapshotData.icefury.isActive = true
						TRB.Data.snapshotData.icefury.stacksRemaining = TRB.Data.spells.icefury.stacks
						TRB.Data.snapshotData.icefury.maelstrom = TRB.Data.snapshotData.icefury.stacksRemaining * TRB.Data.spells.frostShock.maelstrom
						TRB.Data.snapshotData.icefury.startTime = currentTime
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.icefury.isActive = false
						TRB.Data.snapshotData.icefury.stacksRemaining = 0
						TRB.Data.snapshotData.icefury.maelstrom = 0
						TRB.Data.snapshotData.icefury.startTime = nil
					elseif type == "SPELL_AURA_REMOVED_DOSE" then
						TRB.Data.snapshotData.icefury.stacksRemaining = TRB.Data.snapshotData.icefury.stacksRemaining - 1
						TRB.Data.snapshotData.icefury.maelstrom = TRB.Data.snapshotData.icefury.stacksRemaining * TRB.Data.spells.frostShock.maelstrom
					end
				elseif spellId == TRB.Data.spells.stormkeeper.id then
					if type == "SPELL_AURA_APPLIED" then -- Stormkeeper
						TRB.Data.snapshotData.stormkeeper.isActive = true
						TRB.Data.snapshotData.stormkeeper.stacksRemaining = TRB.Data.spells.stormkeeper.stacks
						TRB.Data.snapshotData.stormkeeper.maelstrom = TRB.Data.snapshotData.stormkeeper.stacksRemaining * TRB.Data.spells.frostShock.maelstrom
						TRB.Data.snapshotData.stormkeeper.startTime = currentTime
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.stormkeeper.isActive = false
						TRB.Data.snapshotData.stormkeeper.stacksRemaining = 0
						TRB.Data.snapshotData.stormkeeper.maelstrom = 0
						TRB.Data.snapshotData.stormkeeper.startTime = nil
					elseif type == "SPELL_AURA_REMOVED_DOSE" then
						TRB.Data.snapshotData.stormkeeper.stacksRemaining = TRB.Data.snapshotData.stormkeeper.stacksRemaining - 1
						TRB.Data.snapshotData.stormkeeper.maelstrom = TRB.Data.snapshotData.stormkeeper.stacksRemaining * TRB.Data.spells.frostShock.maelstrom
					end
				elseif spellId == TRB.Data.spells.surgeOfPower.id then
					if type == "SPELL_AURA_APPLIED" then -- Surge of Power
						TRB.Data.spells.surgeOfPower.isActive = true
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.spells.surgeOfPower.isActive = false
					end
				elseif spellId == TRB.Data.spells.echoingShock.id then
					if type == "SPELL_AURA_APPLIED" then -- Echoing Shock
						TRB.Data.snapshotData.echoingShock.isActive = true
					end
				end

				if type == "SPELL_CAST_SUCCESS" and TRB.Data.snapshotData.echoingShock.isActive and spellId ~= TRB.Data.spells.echoingShock.id then
					local spell = nil

					if spellId == TRB.Data.spells.lightningBolt.id then
						spell = TRB.Data.spells.lightningBolt
					elseif spellId == TRB.Data.spells.lavaBurst.id then
						spell = TRB.Data.spells.lavaBurst
					elseif spellId == TRB.Data.spells.elementalBlast.id then
						spell = TRB.Data.spells.elementalBlast
					elseif spellId == TRB.Data.spells.icefury.id then
						spell = TRB.Data.spells.icefury
					elseif spellId == TRB.Data.spells.chainLightning.id then
						spell = TRB.Data.spells.chainLightning
					elseif spellId == TRB.Data.spells.lavaBeam.id then 
						spell = TRB.Data.spells.lavaBeam
					end

					InitializeTarget(destGUID)

					TRB.Data.snapshotData.targetData.targets[destGUID].echoingShockSpell = spell
					TRB.Data.snapshotData.targetData.targets[destGUID].echoingShockExpiration = currentTime + TRB.Data.character.talents.echoingShock.duration - TRB.Functions.GetLatency()
					TRB.Data.snapshotData.echoingShock.isActive = false
					TRB.Data.snapshotData.echoingShock.spell = spell
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
		if classIndex == 7 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true
					local settings = TRB.Options.Shaman.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end

					TRB.Functions.UpdateSanityCheckValues(TRB.Data.settings.shaman.elemental)
					TRB.Functions.IsTtdActive(TRB.Data.settings.shaman.elemental)
					FillSpellData()
					ConstructResourceBar()
					TRB.Options.Shaman.ConstructOptionsPanel()

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
