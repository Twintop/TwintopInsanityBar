local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 7 then --Only do this if we're on a Shaman!
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local resourceFrame = TRB.Frames.resourceFrame
	local passiveFrame = TRB.Frames.passiveFrame

	resourceFrame.thresholdEs = CreateFrame("Frame", nil, resourceFrame)
	passiveFrame.threshold = CreateFrame("Frame", nil, passiveFrame)

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
    local combatFrame = TRB.Frames.combatFrame
    
    local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
    
	Global_TwintopMaelstromBar = {
		ttd = 0,
		maelstrom = {
			maelstrom = 0,
			casting = 0,
			passive = 0
		},
		dots = {
            fsCount = 0
		}
    }
    
	TRB.Data.character = {
		guid = UnitGUID("player"),
		specGroup = GetActiveSpecGroup(),
		maxResource = 100,
		earthShockThreshold = 60,
		talents = {
			elementalBlast = {
				isSelected = false
			},
			icefury = {
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
			maelstrom = 8
		},
		lavaBurst = {
			id = 51505,
			name = "",
			icon = "",
			maelstrom = 10
		},
		elementalBlast = {
			id = 117014,
			name = "",
			icon = "",
			maelstrom = 30
		},
		chainLightning = {
			id = 188443,
			name = "",
			icon = "",
			maelstrom = 4
		},
		icefury = {
			id = 210714,
			name = "",
			icon = "",
			maelstrom = 25
		},
		lavaBeam = {
			id = 114050,
			name = "",
			icon = "",
			maelstrom = 3
        },
        flameShock = {
            id = 188389,
            name = "",
            icon = ""
        },
        lightningShield = {
            id = 192106,
            name = "",
            icon = "",
            maelstrom = 5
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
	
			{ variable = "#lightningBolt", icon = TRB.Data.spells.lightningBolt.icon, description = "Lightning Bolt", printInSettings = true },
			{ variable = "#lavaBurst", icon = TRB.Data.spells.lavaBurst.icon, description = "Lava Burst", printInSettings = true },
			{ variable = "#elementalBlast", icon = TRB.Data.spells.elementalBlast.icon, description = "Elemental Blast", printInSettings = true },
			{ variable = "#chainLightning", icon = TRB.Data.spells.chainLightning.icon, description = "Chain Lightning", printInSettings = true },
			{ variable = "#lavaBeam", icon = TRB.Data.spells.lavaBeam.icon, description = "Lava Beam", printInSettings = true },
			{ variable = "#icefury", icon = TRB.Data.spells.icefury.icon, description = "Icefury", printInSettings = true },
			{ variable = "#flameShock", icon = TRB.Data.spells.flameShock.icon, description = "Flame Shock", printInSettings = true },
			{ variable = "#lightningShield", icon = TRB.Data.spells.lightningShield.icon, description = "Lightning Shield", printInSettings = true },
		}
		TRB.Data.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste%", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Crit%", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery%", printInSettings = true, color = false },
	
			{ variable = "$maelstrom", description = "Current Maelstrom", printInSettings = true, color = false },
			{ variable = "$casting", description = "Maelstrom from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Maelstrom from Passive Sources", printInSettings = true, color = false },
			{ variable = "$maelstromPlusCasting", description = "Current + Casting Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$maelstromPlusPassive", description = "Current + Passive Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$maelstromTotal", description = "Current + Passive + Casting Maelstrom Total", printInSettings = true, color = false },   
	
			{ variable = "$fsCount", description = "Number of Flame Shocks active on targets", printInSettings = true, color = false },
	
			{ variable = "$ttd", description = "Time To Die of current target", printInSettings = true, color = true }
		}
	end

	local function CheckCharacter()
		TRB.Functions.CheckCharacter()
		TRB.Data.character.maxResource = UnitPowerMax("player", SPELL_POWER_MAELSTROM)
		TRB.Data.character.talents.elementalBlast.isSelected = select(4, GetTalentInfo(2, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.icefury.isSelected = select(4, GetTalentInfo(6, 3, TRB.Data.character.specGroup))
		TRB.Data.character.talents.ascendance.isSelected = select(4, GetTalentInfo(7, 3, TRB.Data.character.specGroup))
		
		TRB.Data.character.earthShockThreshold = 60
		
		if TRB.Data.settings.shaman ~= nil and TRB.Data.settings.shaman.elemental ~= nil and TRB.Data.settings.shaman.elemental.earthShockThreshold and TRB.Data.character.earthShockThreshold < TRB.Data.character.maxResource then
			resourceFrame.thresholdEs:Show()
			TRB.Functions.RepositionThreshold(TRB.Data.settings.shaman.elemental, resourceFrame.thresholdEs, resourceFrame, TRB.Data.settings.shaman.elemental.thresholdWidth, TRB.Data.character.earthShockThreshold, TRB.Data.character.maxResource)
		else
			resourceFrame.thresholdEs:Hide()
		end
	end
	
	local function IsTtdActive()
		if TRB.Data.settings.shaman ~= nil and TRB.Data.settings.shaman.elemental ~= nil and TRB.Data.settings.shaman.elemental.displayText ~= nil then
			if string.find(TRB.Data.settings.shaman.elemental.displayText.left.text, "$ttd") or
				string.find(TRB.Data.settings.shaman.elemental.displayText.middle.text, "$ttd") or
				string.find(TRB.Data.settings.shaman.elemental.displayText.right.text, "$ttd") then
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
			TRB.Data.resource = SPELL_POWER_MAELSTROM
			TRB.Data.specSupported = true
            CheckCharacter()
            
			if TRB.Functions.IsTtdActive() then
				targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			else
				targetsTimerFrame:SetScript("OnUpdate", nil)
            end
            
			targetsTimerFrame:SetScript("OnUpdate", nil)
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
			TRB.Data.snapshotData.targetData.targets[guid].flameShock = false
		end	
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local fsTotal = 0
		for tguid,count in pairs(TRB.Data.snapshotData.targetData.targets) do
			if (currentTime - TRB.Data.snapshotData.targetData.targets[tguid].lastUpdate) > 10 then
				TRB.Data.snapshotData.targetData.targets[tguid].flameShock = false
			else
				if TRB.Data.snapshotData.targetData.targets[tguid].flameShock == true then
					fsTotal = fsTotal + 1
				end
			end
		end		
		TRB.Data.snapshotData.targetData.flameShock = fsTotal
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.TargetsCleanup(clearAll)
		if clearAll == true then
			TRB.Data.snapshotData.targetData.flameShock = 0
		end
	end

	local function ConstructResourceBar()
		TRB.Functions.ConstructResourceBar(TRB.Data.settings.shaman.elemental)
		
		resourceFrame.thresholdEs:SetWidth(TRB.Data.settings.shaman.elemental.thresholdWidth)
		resourceFrame.thresholdEs:SetHeight(TRB.Data.settings.shaman.elemental.bar.height)
		resourceFrame.thresholdEs.texture = resourceFrame.thresholdEs:CreateTexture(nil, TRB.Data.settings.core.strata.level)
		resourceFrame.thresholdEs.texture:SetAllPoints(resourceFrame.thresholdEs)
		resourceFrame.thresholdEs.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.threshold.under, true))
		resourceFrame.thresholdEs:SetFrameStrata(TRB.Data.settings.core.strata.level)
		resourceFrame.thresholdEs:SetFrameLevel(128)
		resourceFrame.thresholdEs:Show()
	end

    local function IsValidVariableForSpec(var)
		local valid = false

		if var == "$crit" then
			valid = true
		elseif var == "$mastery" then
			valid = true
		elseif var == "$haste" then
			valid = true
		elseif var == "$gcd" then
			valid = true
		elseif var == "$maelstrom" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$maelstromTotal" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.lavaBeam.id)) then
				valid = true
			end
		elseif var == "$maelstromPlusCasting" then
			if TRB.Data.snapshotData.resource > 0 or
				(TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.lavaBeam.id)) then
				valid = true
			end
		elseif var == "$maelstromPlusPassive" then
			if TRB.Data.snapshotData.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if TRB.Data.snapshotData.casting.resourceRaw ~= nil and (TRB.Data.snapshotData.casting.resourceRaw > 0 or TRB.Data.snapshotData.casting.spellId == TRB.Data.spells.chainLightning.id) then
				valid = true
			end
        elseif var == "$passive" then
            valid = false --No passive sources?

		elseif var == "$fsCount" then
			if TRB.Data.snapshotData.targetData.flameShock > 0 then
				valid = true
			end
		elseif var == "$ttd" then
			if TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and UnitGUID("target") ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ttd > 0 then
				valid = true
			end
		else
			valid = false					
		end

		return valid
	end
	TRB.Data.IsValidVariableForSpec = IsValidVariableForSpec

    local function BarText()
		local currentTime = GetTime()
		--$crit
		local critPercent = string.format("%." .. TRB.Data.settings.shaman.elemental.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.crit, TRB.Data.settings.shaman.elemental.hastePrecision))

		--$mastery
		local masteryPercent = string.format("%." .. TRB.Data.settings.shaman.elemental.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.mastery, TRB.Data.settings.shaman.elemental.hastePrecision))
		
		--$haste

		--$gcd
		local _gcd = 1.5 / (1 + (TRB.Data.snapshotData.haste/100))
		if _gcd > 1.5 then
			_gcd = 1.5
		elseif _gcd < 0.75 then
			_gcd = 0.75
		end
		local gcd = string.format("%.2f", _gcd)

		local hastePercent = string.format("%." .. TRB.Data.settings.shaman.elemental.hastePrecision .. "f", TRB.Functions.RoundTo(TRB.Data.snapshotData.haste, TRB.Data.settings.shaman.elemental.hastePrecision))
		
		----------
		
		--$maelstrom
		local currentMaelstrom = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom, TRB.Data.snapshotData.resource)
		--$casting
		local castingMaelstrom = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.castingMaelstrom, TRB.Data.snapshotData.casting.resourceFinal)
		--$passive
		local _passiveMaelstrom = 0
		local passiveMaelstrom = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.passiveMaelstrom, _passiveMaelstrom)
		--$maelstromTotal
		local _maelstromTotal = math.min(_passiveMaelstrom + TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromTotal = string.format("|c%s%.0f%%|r", TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom, _maelstromTotal)
		--$maelstromPlusCasting
		local _maelstromPlusCasting = math.min(TRB.Data.snapshotData.casting.resourceFinal + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromPlusCasting = string.format("|c%s%.0f%%|r", TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom, _maelstromPlusCasting)
		--$maelstromPlusPassive
		local _maelstromPlusPassive = math.min(_passiveMaelstrom + TRB.Data.snapshotData.resource, TRB.Data.character.maxResource)
		local maelstromPlusPassive = string.format("|c%s%.0f%%|r", TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom, _maelstromPlusPassive)

		----------
		--$fsCount
		local flameShockCount = TRB.Data.snapshotData.targetData.flameShock or 0

		----------

		--$ttd
		local _ttd = ""
		local ttd = ""

		if TRB.Data.snapshotData.targetData.ttdIsActive and TRB.Data.snapshotData.targetData.currentTargetGuid ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid].ttd ~= 0 then
			local target = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid]
			local ttdMinutes = math.floor(target.ttd / 60)
			local ttdSeconds = target.ttd % 60
			ttd = string.format("%d:%0.2d", ttdMinutes, ttdSeconds)
		else
			ttd = "--"
		end

		--#castingIcon
		local castingIcon = TRB.Data.snapshotData.casting.icon or ""
		----------------------------

		Global_TwintopMaelstromBar = {
			ttd = ttd or "--",
			maelstrom = {
				maelstrom = TRB.Data.snapshotData.resource or 0,
				casting = TRB.Data.snapshotData.casting.resourceFinal or 0,
				passive = _passiveMaelstrom
			},
			dots = {
				fsCount = flameShockCount or 0,
			}
		}
		
		local lookup = {}
		lookup["#lightningBolt"] = TRB.Data.spells.lightningBolt.icon
		lookup["#lavaBurst"] = TRB.Data.spells.lavaBurst.icon
		lookup["#elementalBlast"] = TRB.Data.spells.elementalBlast.icon
		lookup["#chainLightning"] = TRB.Data.spells.chainLightning.icon
		lookup["#lavaBeam"] = TRB.Data.spells.lavaBeam.icon
		lookup["#icefury"] = TRB.Data.spells.icefury.icon
		lookup["#flameShock"] = TRB.Data.spells.flameShock.icon
		lookup["#lightningShield"] = TRB.Data.spells.lightningShield.icon
		lookup["#casting"] = castingIcon
		lookup["$haste"] = hastePercent
		lookup["$crit"] = critPercent
		lookup["$mastery"] = masteryPercent
		lookup["$gcd"] = gcd
		lookup["$fsCount"] = flameShockCount
		lookup["$maelstromPlusCasting"] = maelstromPlusCasting
		lookup["$maelstromPlusPassive"] = maelstromPlusPassive
		lookup["$maelstromTotal"] = maelstromTotal
		lookup["$maelstrom"] = currentMaelstrom
		lookup["$casting"] = castingMaelstrom
		lookup["$passive"] = passiveMaelstrom
		lookup["$ttd"] = ttd
		lookup["||n"] = string.format("\n")
		lookup["||c"] = string.format("%s", "|c")
		lookup["||r"] = string.format("%s", "|r")
		lookup["%%"] = "%"
		TRB.Data.lookup = lookup

		local returnText = {}
		returnText[0] = {}
		returnText[1] = {}
		returnText[2] = {}
        returnText[0].text = TRB.Data.settings.shaman.elemental.displayText.left.text
        returnText[1].text = TRB.Data.settings.shaman.elemental.displayText.middle.text
        returnText[2].text = TRB.Data.settings.shaman.elemental.displayText.right.text

		returnText[0].color = string.format("|c%s", TRB.Data.settings.shaman.elemental.colors.text.left)
		returnText[1].color = string.format("|c%s", TRB.Data.settings.shaman.elemental.colors.text.middle)
		returnText[2].color = string.format("|c%s", TRB.Data.settings.shaman.elemental.colors.text.right)

		return TRB.Functions.GetReturnText(returnText[0]), TRB.Functions.GetReturnText(returnText[1]), TRB.Functions.GetReturnText(returnText[2])
	end
	TRB.Data.BarText = BarText

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
                --See Priest implementation for handling channeled spells
			else	
				local spellName = select(1, currentSpell)
				if spellName == TRB.Data.spells.lightningBolt.name then
                    FillSnapshotDataCasting(TRB.Data.spells.lightningBolt)
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

	local function UpdateSnapshot()
		TRB.Functions.UpdateSnapshot()
	end    

	local function HideResourceBar()
		local affectingCombat = UnitAffectingCombat("player")
	
		if (not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.shaman.elemental.displayBar.alwaysShow) and (
					(not TRB.Data.settings.shaman.elemental.displayBar.notZeroShow) or
					(TRB.Data.settings.shaman.elemental.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0)
				)
			 ) then
			TRB.Frames.barContainerFrame:Hide()	
		else
			TRB.Frames.barContainerFrame:Show()	
		end
	end
	TRB.Functions.HideResourceBar = HideResourceBar

	local function UpdateResourceBar()
		UpdateSnapshot()

		if barContainerFrame:IsShown() then
			if TRB.Data.snapshotData.resource == 0 then
				TRB.Functions.HideResourceBar()
			end
			
			resourceFrame:SetValue(TRB.Data.snapshotData.resource)
			
			if CastingSpell() then
				castingFrame:SetValue(TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal)
			else
				castingFrame:SetValue(TRB.Data.snapshotData.resource)
			end
			
			-- Elemental doesn't use the passive frame right now. Hide it and the threshold line
			passiveFrame:Hide()
			passiveFrame.threshold.texture:Hide()
			passiveFrame:SetValue(TRB.Data.snapshotData.resource + TRB.Data.snapshotData.casting.resourceFinal)

			if TRB.Data.settings.shaman.elemental.earthShockThreshold then
				resourceFrame.thresholdEs:Show()
			else
				resourceFrame.thresholdEs:Hide()
			end
			
			if TRB.Data.snapshotData.resource >= TRB.Data.character.earthShockThreshold then
				resourceFrame.thresholdEs.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.threshold.over, true))
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
				resourceFrame.thresholdEs.texture:SetColorTexture(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.threshold.under, true))
				barContainerFrame:SetAlpha(1.0)
				TRB.Data.snapshotData.audio.playedEsCue = false
			end
			
            if TRB.Data.snapshotData.resource >= TRB.Data.character.earthShockThreshold then
                resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.earthShock, true))
            else
                resourceFrame:SetStatusBarColor(TRB.Functions.GetRGBAFromString(TRB.Data.settings.shaman.elemental.colors.bar.base, true))
            end
		end

		TRB.Functions.UpdateResourceBar(TRB.Data.settings.shaman.elemental)
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	local function TriggerResourceBarUpdates()
		if GetSpecialization() ~= 1 then
			TRB.Functions.HideResourceBar()
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
			if TRB.Data.snapshotData.chainLightning.hitTime ~= nil and currentTime > (TRB.Data.snapshotData.chainLightning.hitTime + 6) then
				TRB.Data.snapshotData.chainLightning.hitTime = nil
				TRB.Data.snapshotData.chainLightning.targetsHit = 0
			end
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
				if spellId == TRB.Data.spells.flameShock.id then
					InitializeTarget(destGUID)
					TRB.Data.snapshotData.targetData.targets[destGUID].lastUpdate = currentTime
					if type == "SPELL_AURA_APPLIED" then -- FS Applied to Target
						TRB.Data.snapshotData.targetData.targets[destGUID].flameShock = true
						TRB.Data.snapshotData.targetData.flameShock = TRB.Data.snapshotData.targetData.flameShock + 1
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshotData.targetData.targets[destGUID].flameShock = false
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
		if classIndex == 7 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true
					local settings = TRB.Options.Shaman.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options.PortForwardPriestSettings()
						TRB.Data.settings = TRB.Functions.MergeSettings(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options.CleanupSettings()
					else
						TRB.Data.settings = settings
					end	

					TRB.Functions.UpdateSanityCheckValues()
					TRB.Functions.IsTtdActive()		
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
					
				local affectingCombat = UnitAffectingCombat("player")

				if (not affectingCombat) and TRB.Data.settings.shaman.elemental ~= nil and TRB.Data.settings.shaman.elemental.displayBar ~= nil and (
					(not TRB.Data.settings.shaman.elemental.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.elemental.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.elemental.displayBar.notZeroShow and TRB.Data.snapshotData.resource == 0))) then	
					barContainerFrame:Hide()
				end
			end
		end
	end)
end
