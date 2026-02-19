local _, TRB = ...
if TRB.Data.character.classId ~= 11 then --Only do this if we're on a Druid!
	return
end

local ASTRAL_POWER_RESOURCE_FACTOR = 10
local ENERGY_RESOURCE_FACTOR = 1
local RAGE_RESOURCE_FACTOR = 10
local MANA_RESOURCE_FACTOR = 1

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	druid_balance = TRB.Classes.SpecCache:New(),
	druid_feral = TRB.Classes.SpecCache:New(),
	druid_guardian = TRB.Classes.SpecCache:New(),
	druid_restoration = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Balance
	specCache.druid_balance.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		},
		furyOfElune = {
			astralPower = 0,
			ticks = 0,
			remaining = 0
		}
	}
	
	specCache.druid_balance.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		pandemicModifier = 1.0,
		effects = {
		},
		items = {
			twwSeason1SetBonusCount = 0
		}
	}
	
	---@type TRB.Classes.Druid.BalanceSpells
	specCache.druid_balance.spellsData.spells = TRB.Classes.Druid.BalanceSpells:New()
	local spells = specCache.druid_balance.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	
	specCache.druid_balance.snapshotData.audio = {
		playedSsCue = false,
		playedSfCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.druid_balance.snapshotData.snapshots[spells.eclipseSolar.id] = TRB.Classes.Snapshot:New(spells.eclipseSolar)
	---@type TRB.Classes.Snapshot
	specCache.druid_balance.snapshotData.snapshots[spells.eclipseLunar.id] = TRB.Classes.Snapshot:New(spells.eclipseLunar)
	---@type TRB.Classes.Snapshot
	specCache.druid_balance.snapshotData.snapshots[spells.celestialAlignment.id] = TRB.Classes.Snapshot:New(spells.celestialAlignment)
	---@type TRB.Classes.Snapshot
	specCache.druid_balance.snapshotData.snapshots[spells.incarnationChosenOfElune.id] = TRB.Classes.Snapshot:New(spells.incarnationChosenOfElune)
	---@type TRB.Classes.Snapshot
	specCache.druid_balance.snapshotData.snapshots[spells.newMoon.id] = TRB.Classes.Snapshot:New(spells.newMoon, {
		currentSpellId = nil,
		currentIcon = "",
		currentKey = "",
		checkAfter = nil
	})
	---@type TRB.Classes.Snapshot
	specCache.druid_balance.snapshotData.snapshots[spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(spells.frenziedRegeneration)
	---@type TRB.Classes.Snapshot
	specCache.druid_balance.snapshotData.snapshots[spells.maim.id] = TRB.Classes.Snapshot:New(spells.maim)

	-- Feral
	specCache.druid_feral.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.druid_feral.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		maxResource2 = 5,
		pandemicModifier = 1.0,
		effects = {
		}
	}
	
	---@type TRB.Classes.Druid.FeralSpells
	specCache.druid_feral.spellsData.spells = TRB.Classes.Druid.FeralSpells:New()
	local spells = specCache.druid_feral.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]

	specCache.druid_feral.snapshotData.attributes.resourceRegen = 0
	specCache.druid_feral.snapshotData.attributes.comboPoints = 0
	specCache.druid_feral.snapshotData.audio = {
		apexPredatorsCravingCue = false,
		comboPointThreshold1Played = false,
		comboPointThreshold2Played = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.maim.id] = TRB.Classes.Snapshot:New(spells.maim)
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.brutalSlash.id] = TRB.Classes.Snapshot:New(spells.brutalSlash)
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.feralFrenzy.id] = TRB.Classes.Snapshot:New(spells.feralFrenzy)
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.franticFrenzy.id] = TRB.Classes.Snapshot:New(spells.franticFrenzy)
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.clearcasting.id] = TRB.Classes.Snapshot:New(spells.clearcasting)
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.berserk.id] = TRB.Classes.Snapshot:New(spells.berserk, {
		lastTick = nil,
		nextTick = nil,
		untilNextTick = 0,
		ticks = 0,
	})
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id] = TRB.Classes.Snapshot:New(spells.incarnationAvatarOfAshamane)
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.apexPredatorsCraving.id] = TRB.Classes.Snapshot:New(spells.apexPredatorsCraving)
	-- Druid of the Claw
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.ravageMinimum.id] = TRB.Classes.Snapshot:New(spells.ravageMinimum)
	---@type TRB.Classes.Snapshot
	specCache.druid_feral.snapshotData.snapshots[spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(spells.frenziedRegeneration)

	-- Guardian
	specCache.druid_guardian.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		}
	}
	
	specCache.druid_guardian.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		pandemicModifier = 1.0,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Druid.GuardianSpells
	specCache.druid_guardian.spellsData.spells = TRB.Classes.Druid.GuardianSpells:New()
	local spells = specCache.druid_guardian.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
	---@type TRB.Classes.Snapshot
	specCache.druid_guardian.snapshotData.snapshots[spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(spells.frenziedRegeneration)
	---@type TRB.Classes.Snapshot
	specCache.druid_guardian.snapshotData.snapshots[spells.berserk.id] = TRB.Classes.Snapshot:New(spells.berserk)
	---@type TRB.Classes.Snapshot
	specCache.druid_guardian.snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id] = TRB.Classes.Snapshot:New(spells.incarnationGuardianOfUrsoc)
	---@type TRB.Classes.Snapshot
	specCache.druid_guardian.snapshotData.snapshots[spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(spells.frenziedRegeneration)
	---@type TRB.Classes.Snapshot
	specCache.druid_guardian.snapshotData.snapshots[spells.maim.id] = TRB.Classes.Snapshot:New(spells.maim)

	specCache.druid_guardian.snapshotData.audio = {
	}

	-- Restoration
	specCache.druid_restoration.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.druid_restoration.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 4,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}
	
	---@type TRB.Classes.Druid.RestorationSpells
	specCache.druid_restoration.spellsData.spells = TRB.Classes.Druid.RestorationSpells:New()
	local spells = specCache.druid_restoration.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]

	specCache.druid_restoration.snapshotData.attributes.manaRegen = 0
	specCache.druid_restoration.snapshotData.audio = {
		innervateCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.druid_restoration.snapshotData.snapshots[spells.efflorescence.id] = TRB.Classes.Snapshot:New(spells.efflorescence)
	---@type TRB.Classes.Snapshot
	specCache.druid_restoration.snapshotData.snapshots[spells.incarnationTreeOfLife.id] = TRB.Classes.Snapshot:New(spells.incarnationTreeOfLife)
	---@type TRB.Classes.Snapshot
	specCache.druid_restoration.snapshotData.snapshots[spells.frenziedRegeneration.id] = TRB.Classes.Snapshot:New(spells.frenziedRegeneration)
	---@type TRB.Classes.Snapshot
	specCache.druid_restoration.snapshotData.snapshots[spells.maim.id] = TRB.Classes.Snapshot:New(spells.maim)

	specCache.druid_restoration.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Balance()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "balance")
	
	-- Destroy existing bar groups before creating new ones
	--TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Balance using new OOP system
	--TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(1)
end

local function FillSpellData_Balance()
	Setup_Balance()
	specCache.druid_balance.spellsData:FillSpellData()
	local spells = specCache.druid_balance.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]

	TRB.Classes.Druid.BalanceSpells.FillBarTextVariables(specCache.druid_balance)
end

local function Setup_Feral()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "feral")
	
	-- Destroy existing bar groups before creating new ones
	--TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Feral using new OOP system
	--TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(2)
end

local function FillSpellData_Feral()
	Setup_Feral()
	specCache.druid_feral.spellsData:FillSpellData()
	local spells = specCache.druid_feral.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]

	TRB.Classes.Druid.FeralSpells.FillBarTextVariables(specCache.druid_feral)
end

local function Setup_Guardian()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "guardian")
	
	-- Destroy existing bar groups before creating new ones
	--TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Guardian using new OOP system
	--TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(3)
end

local function FillSpellData_Guardian()
	Setup_Guardian()
	specCache.druid_guardian.spellsData:FillSpellData()
	local spells = specCache.druid_guardian.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]

	TRB.Classes.Druid.GuardianSpells.FillBarTextVariables(specCache.druid_guardian)
end

local function Setup_Restoration()
	TRB.Functions.Character:FillSpecializationCacheSettings("druid", "restoration", true)
	
	-- Destroy existing bar groups before creating new ones
	--TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Restoration using new OOP system
	--TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(4)
end

local function FillSpellData_Restoration()
	Setup_Restoration()
	specCache.druid_restoration.spellsData:FillSpellData()
	local spells = specCache.druid_restoration.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]

	TRB.Classes.Druid.RestorationSpells.FillBarTextVariables(specCache.druid_restoration)
end

---Updates all resource values for Druids (Energy, Rage, Mana, Astral Power, Combo Points)
---This allows cross-form bar text variables to work
local function UpdateResourceValues()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	-- Track all resources simultaneously for form-based switching and cross-form bar text
	snapshotData.attributes.energy = UnitPower("player", Enum.PowerType.Energy, true)
	snapshotData.attributes.energyModified = UnitPower("player", Enum.PowerType.Energy, false)
	
	snapshotData.attributes.rage = UnitPower("player", Enum.PowerType.Rage, true)
	snapshotData.attributes.rageModified = UnitPower("player", Enum.PowerType.Rage, false)
	
	snapshotData.attributes.mana = UnitPower("player", Enum.PowerType.Mana, true)
	snapshotData.attributes.manaModified = UnitPower("player", Enum.PowerType.Mana, false)
	
	snapshotData.attributes.astralPower = UnitPower("player", Enum.PowerType.LunarPower, true)
	snapshotData.attributes.astralPowerModified = UnitPower("player", Enum.PowerType.LunarPower, false)
	
	snapshotData.attributes.comboPoints = UnitPower("player", Enum.PowerType.ComboPoints, false)
	
	-- Set primary resource and resource2 based on current spec for backwards compatibility
	-- All specs track combo points as resource2 for Cat form support
	snapshotData.attributes.resource2 = snapshotData.attributes.comboPoints
	snapshotData.attributes.resource2Modified = snapshotData.attributes.comboPoints
	
	if TRB.Data.character.specId == 1 then -- Balance
		snapshotData.attributes.resource = snapshotData.attributes.astralPower
		snapshotData.attributes.resourceModified = snapshotData.attributes.astralPowerModified
		snapshotData.attributes.resourcePercent = UnitPowerPercent("player", Enum.PowerType.LunarPower, true, CurveConstants.ScaleTo100)
	elseif TRB.Data.character.specId == 2 then -- Feral
		snapshotData.attributes.resource = snapshotData.attributes.energy
		snapshotData.attributes.resourceModified = snapshotData.attributes.energyModified
		snapshotData.attributes.resourcePercent = UnitPowerPercent("player", Enum.PowerType.Energy, true, CurveConstants.ScaleTo100)
	elseif TRB.Data.character.specId == 3 then -- Guardian
		snapshotData.attributes.resource = snapshotData.attributes.rage
		snapshotData.attributes.resourceModified = snapshotData.attributes.rageModified
		snapshotData.attributes.resourcePercent = UnitPowerPercent("player", Enum.PowerType.Rage, true, CurveConstants.ScaleTo100)
	elseif TRB.Data.character.specId == 4 then -- Restoration
		snapshotData.attributes.resource = snapshotData.attributes.mana
		snapshotData.attributes.resourceModified = snapshotData.attributes.manaModified
		snapshotData.attributes.resourcePercent = UnitPowerPercent("player", Enum.PowerType.Mana, true, CurveConstants.ScaleTo100)
	end
end

local function DruidPowerEvent(self, event, ...)
	if event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then
		UpdateResourceValues()
		TRB.Functions.Character:UpdateOvercapColor()
	elseif event == "UNIT_MAXPOWER" then
		local unitTarget, powerType = ...
		if unitTarget == "player" then
			-- Update max values when they change
			if powerType == "COMBO_POINTS" then
				TRB.Data.character.maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
			elseif powerType == "ENERGY" then
				TRB.Data.character.maxEnergy = UnitPowerMax("player", Enum.PowerType.Energy, true)
			elseif powerType == "RAGE" then
				TRB.Data.character.maxRage = UnitPowerMax("player", Enum.PowerType.Rage, true)
			elseif powerType == "MANA" then
				TRB.Data.character.maxMana = UnitPowerMax("player", Enum.PowerType.Mana, true)
			elseif powerType == "LUNAR_POWER" then
				TRB.Data.character.maxAstralPower = UnitPowerMax("player", Enum.PowerType.LunarPower, true)
			end
		end
	end
end
local druidPowerFrame = CreateFrame("Frame")

---@alias trbDruidForm
---| '"humanoid"'		# nil
---| '"cat"'			# 1
---| '"treeOfLife"'		# 2
---| '"travel"'			# 3
---| '"aquatic"'		# 4
---| '"bear"'			# 5
---| '"swiftFlight"'	# 27
---| '"flight"'			# 29
---| '"moonkin"'		# 31-35
---| '"treant"'			# 36

local function UpdateShapeshiftForm()
	local formId = GetShapeshiftFormID()
	local oldId = TRB.Data.character.currentShapeshiftFormId
	local oldForm = TRB.Data.character.currentShapeshiftForm

	if formId == oldId then
		return
	end

	TRB.Data.character.currentShapeshiftFormId = formId

	if formId == nil or formId == 0 then
		TRB.Data.character.currentShapeshiftForm = "humanoid"
	elseif formId == 1 then
		TRB.Data.character.currentShapeshiftForm = "cat"
	elseif formId == 2 then
		TRB.Data.character.currentShapeshiftForm = "treeOfLife"
	elseif formId == 3 then
		TRB.Data.character.currentShapeshiftForm = "travel"
	elseif formId == 4 then
		TRB.Data.character.currentShapeshiftForm = "aquatic"
	elseif formId == 5 then
		TRB.Data.character.currentShapeshiftForm = "bear"
	elseif formId == 27 then
		TRB.Data.character.currentShapeshiftForm = "swiftFlight"
	elseif formId == 29 then
		TRB.Data.character.currentShapeshiftForm = "flight"
	elseif formId >= 31 and formId <= 35 then
		TRB.Data.character.currentShapeshiftForm = "moonkin"
	elseif formId == 36 then
		TRB.Data.character.currentShapeshiftForm = "treant"
	else
		TRB.Data.character.currentShapeshiftForm = "humanoid"
	end

	-- Trigger resource bar update when form changes
	if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
		TRB.Functions.Class:CheckCharacter()
	end
	
	if TRB.Data.snapshotData ~= nil and TRB.Data.snapshotData.snapshots ~= nil then
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
		TRB.Functions.Character:ResetColorCaches()
		
		TRB.Data.cache.values.frame = {}
		TRB.Functions.BarText:CreateBarTextFrames(TRB.Data.character.classId, TRB.Data.character.specId)
	end

	-- Recalculate wrapper/CDM positioning for the new form.
	-- The bounding box (CalculateWrapperLayout) is form-aware: it strips bars that aren't
	-- shown in the current form (e.g., combo points in Moonkin, mana bar in Cat).
	-- Without this, the wrapper stays sized for the old form, causing:
	-- - Wrong extendAbove (gap between CDM and top bar)
	-- - Wrong baseOffsetX (primary shifted away from CDM center)
	if TRB.Functions.Bar and TRB.Functions.Bar.RefreshWrapperPositioning then
		TRB.Functions.Bar:RefreshWrapperPositioning()
	end
end

local shapeshiftFrame = CreateFrame("Frame")
shapeshiftFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
shapeshiftFrame:SetScript("OnEvent", UpdateShapeshiftForm)

---Returns which spec's settings should be used for the given form
---@param specId integer The current active spec ID
---@param formName string The current shapeshift form name
---@return integer specIdForSettings The spec ID whose settings should be used
local function GetFormSpecForSettings(specId, formName)
	-- Check if form switching is enabled for the active spec
	local activeSpecName = ({ [1] = "balance", [2] = "feral", [3] = "guardian", [4] = "restoration" })[specId]
	local settings = TRB.Data.settings.druid[activeSpecName]
	if settings and settings.displayBar and settings.displayBar.enableFormSwitching == false then
		return specId -- Return active spec, don't switch based on form
	end

	-- Cat Form → Feral settings
	if formName == "cat" then
		return 2 -- Feral
	-- Bear Form → Guardian settings
	elseif formName == "bear" then
		return 3 -- Guardian
	-- Moonkin Form → Balance settings (only if Balance spec)
	elseif formName == "moonkin" then
		if specId == 1 then -- Balance spec
			return 1 -- Balance
		else
			-- Non-Balance in Moonkin form uses Humanoid/Mana bar
			return 4 -- Restoration (mana bar)
		end
	-- Humanoid, Travel, Aquatic, Flight, Tree of Life, Treant → Mana bar (Restoration settings)
	else
		return 4 -- Restoration
	end
end

local function GetCurrentMoonSpell()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local moon = snapshotData.snapshots[spells.newMoon.id]
	local currentTime = GetTime()
	if talents:IsTalentActive(spells.newMoon) and (moon.attributes.checkAfter == nil or currentTime >= moon.attributes.checkAfter) then
		---@diagnostic disable-next-line: redundant-parameter
		local spellInfo = C_Spell.GetSpellInfo(spells.newMoon.name) --[[@as SpellInfo]]
		moon.attributes.currentSpellId = spellInfo.spellID

		if moon.attributes.currentSpellId == spells.newMoon.id then
			moon.attributes.currentKey = "newMoon"
		elseif moon.attributes.currentSpellId == spells.halfMoon.id then
			moon.attributes.currentKey = "halfMoon"
		elseif moon.attributes.currentSpellId == spells.fullMoon.id then
			moon.attributes.currentKey = "fullMoon"
		else
			moon.attributes.currentKey = "newMoon"
		end
		moon.attributes.checkAfter = nil
		moon.attributes.currentIcon = spells[moon.attributes.currentKey].icon
	else
		moon.attributes.currentSpellId = spells.newMoon.id
		moon.attributes.currentKey = "newMoon"
		moon.attributes.checkAfter = nil
	end
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	targetData:UpdateTrackedSpells(currentTime)
end

local function TargetsCleanup(clearAll)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 then
		targetData:Cleanup(clearAll)
	elseif TRB.Data.character.specId == 2 then
		targetData:Cleanup(clearAll)
	elseif TRB.Data.character.specId == 3 then
		targetData:Cleanup(clearAll)
	elseif TRB.Data.character.specId == 4 then
		targetData:Cleanup(clearAll)
	end
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Don't construct bars for disabled specs
	if not TRB.Data.specSupported then
		return
	end

	-- Feral uses secondary bar (Combo Points). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	-- If it's still nil/0 for Feral, use the factory's maxNodes as a fallback.
	if barGroups and barGroups.secondary then
		local maxComboPoints = TRB.Data.character.maxResource2
		if maxComboPoints == nil or maxComboPoints == 0 then
			maxComboPoints = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxComboPoints
	end

	-- Create thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
			for _ = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		-- ConstructBarGroups now handles the Druid special case internally:
		-- For non-Feral Druids, it looks up Feral's combo point settings from specCache
		-- and creates a new merged settings object without modifying the original.
		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function GetBerserkRemainingTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()
	local berserkSnapshotBuff = snapshotData.snapshots[spells.berserk.id].buff

	if not berserkSnapshotBuff.isActive and talents:IsTalentActive(spells.incarnationAvatarOfAshamane) then
		berserkSnapshotBuff = snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff
	end

	return berserkSnapshotBuff:GetRemainingTime(currentTime)
end

local function GetEclipseRemainingTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local remainingTime = 0
	local icon = nil
	local spellId = nil

	if snapshotData.snapshots[spells.celestialAlignment.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.celestialAlignment.id].buff.remaining
		icon = spells.celestialAlignment.icon
		spellId = spells.celestialAlignment.id
	elseif snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff.remaining
		icon = spells.incarnationChosenOfElune.icon
		spellId = spells.incarnationChosenOfElune.id
	elseif snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.eclipseSolar.id].buff.remaining
		icon = spells.eclipseSolar.icon
		spellId = spells.eclipseSolar.id
	elseif snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive then
		remainingTime = snapshotData.snapshots[spells.eclipseLunar.id].buff.remaining
		icon = spells.eclipseLunar.icon
		spellId = spells.eclipseLunar.id
	end

	return remainingTime, icon, spellId
end

local function RefreshLookupData_Balance()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.balance
	local sharedSettings = TRB.Data.specCache["druid_balance"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedAstralPower = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentAstralPowerColor = sharedSettings.colors.text.current.color
	local castingAstralPowerColor = sharedSettings.colors.text.casting.color

	-- $starsurgeUsable and $starfallUsable
	local _starsurgeUsable = spells.starsurge:IsUsable() or spells.starsurge:IsFree()
	local _starfallUsable = spells.starfall:IsUsable() or spells.starfall:IsFree()

	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled and (_starsurgeUsable or _starfallUsable) then
			currentAstralPowerColor = sharedSettings.colors.text.overThreshold.color
			castingAstralPowerColor = sharedSettings.colors.text.overThreshold.color
		end
	end

	-- Apply overcap color if enabled (takes precedence over overThreshold)
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentAstralPower = normalizedAstralPower
	local currentAstralPower
	local castingAstralPower
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentAstralPowerColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		--$astralPower
		currentAstralPower = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentAstralPower))
		--$casting
		castingAstralPower = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		--$astralPower
		currentAstralPower = string.format("|c%s%s|r", currentAstralPowerColor, _currentAstralPower)
		--$casting
		castingAstralPower = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end
	
	local currentMoonIcon = spells.newMoon.icon
	--New Moon
	
	--$eclipseTime
	local _eclispeTime, eclipseIcon, eclipseSpellId = GetEclipseRemainingTime()
	local eclipseTime = TRB.Functions.BarText:TimerPrecision(_eclispeTime)
	
	local _nonEclipseTime = 0
	local nonEclipseTime = TRB.Functions.BarText:TimerPrecision(0)

	-- Mana lookups (Balance uses mana as secondary resource display)
	local currentManaColor = (sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color) or sharedSettings.colors.text.current.color
	local normalizedMana = UnitPower("player", Enum.PowerType.Mana)
	local normalizedManaMax = UnitPowerMax("player", Enum.PowerType.Mana)

	--$mana
	local manaPrecision = sharedSettings.precision.mana or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedManaMax))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)

	----------------------------
	
	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentAstralPower
	lookup["$astralPower"] = currentAstralPower
	lookup["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookup["$astralPowerMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookup["$casting"] = castingAstralPower
	lookup["#moon"] = currentMoonIcon
	lookup["#eclipse"] = eclipseIcon or spells.celestialAlignment.icon
	lookup["$eclipseTime"] = eclipseTime
	lookup["$eclipse"] = ""
	lookup["$lunar"] = ""
	lookup["$lunarEclipse"] = ""
	lookup["$eclipseLunar"] = ""
	lookup["$solar"] = ""
	lookup["$solarEclipse"] = ""
	lookup["$eclipseSolar"] = ""
	lookup["$celestialAlignment"] = ""
	lookup["$starsurgeUsable"] = ""
	lookup["$starfallUsable"] = ""
	lookup["$mana"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedAstralPower
	lookupLogic["$astralPower"] = normalizedAstralPower
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookupLogic["$astralPowerMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookupLogic["$casting"] = currentAstralPower
	lookupLogic["$eclipseTime"] = _eclispeTime
	lookupLogic["$eclipse"] = _eclispeTime > 0
	lookupLogic["$lunar"] = false
	lookupLogic["$lunarEclipse"] = false
	lookupLogic["$eclipseLunar"] = false
	lookupLogic["$solar"] = false
	lookupLogic["$solarEclipse"] = false
	lookupLogic["$eclipseSolar"] = false
	lookupLogic["$celestialAlignment"] = false
	lookupLogic["$starsurgeUsable"] = _starsurgeUsable
	lookupLogic["$starfallUsable"] = _starfallUsable
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$manaMax"] = normalizedManaMax
	lookupLogic["$manaPercent"] = _manaPercent

	if eclipseSpellId == spells.eclipseLunar.id then
		lookupLogic["$lunar"] = true
		lookupLogic["$lunarEclipse"] = true
		lookupLogic["$eclipseLunar"] = true
	elseif eclipseSpellId == spells.eclipseSolar.id then
		lookupLogic["$solar"] = true
		lookupLogic["$solarEclipse"] = true
		lookupLogic["$eclipseSolar"] = true
	elseif eclipseSpellId == spells.celestialAlignment.id or eclipseSpellId == spells.incarnationChosenOfElune.id then
		lookupLogic["$celestialAlignment"] = true
	end
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Feral()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.feral
	local sharedSettings = TRB.Data.specCache["druid_feral"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedEnergy = snapshotData.attributes.resourceModified or 0

	--Spec specific implementation

	local currentEnergyColor = sharedSettings.colors.text.current.color
	local castingEnergyColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:IsUsable() then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = sharedSettings.colors.text.overThreshold.color
				castingEnergyColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = sharedSettings.colors.text.spending.color
	end

	--$energy
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _normalizedEnergy = normalizedEnergy
	local currentEnergy
	local castingEnergy
	-- Apply overcap color if enabled (takes precedence over overThreshold, but not stealth)
	-- Stealth takes precedence over overcap for Feral
	if not IsStealthed() and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", _normalizedEnergy))
		castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentEnergy = string.format("|c%s%s|r", currentEnergyColor, _normalizedEnergy)
		castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end

	--$berserkTime (and $incarnationTime)
	local _berserkTime = GetBerserkRemainingTime()
	local berserkTime = TRB.Functions.BarText:TimerPrecision(_berserkTime)

	--$incarnationTicks 
	local _incarnationTicks = snapshotData.snapshots[spells.berserk.id].attributes.ticks
	
	--$incarnationTickTime
	local _incarnationTickTime = snapshotData.snapshots[spells.berserk.id].attributes.untilNextTick
	local incarnationTickTime = TRB.Functions.BarText:TimerPrecision(_incarnationTickTime)

	--$incarnationNextCp
	local incarnationNextCp = 0

		for x = 1, TRB.Data.character.maxResource2 do
		if snapshotData.attributes.resource2 < x then
			if incarnationNextCp == 0 and _incarnationTicks > 0 then
				incarnationNextCp = x
			end
		end
	end

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$energyMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookup["$energy"] = currentEnergy
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$inStealth"] = ""
	lookup["$berserkTime"] = berserkTime
	lookup["$incarnationTime"] = berserkTime
	lookup["$incarnationTicks"] = _incarnationTicks
	lookup["$incarnationTickTime"] = incarnationTickTime
	lookup["$incarnationNextCp"] = incarnationNextCp
	TRB.Data.lookup = lookup
	

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$inStealth"] = IsStealthed()
	lookupLogic["$berserkTime"] = _berserkTime
	lookupLogic["$incarnationTime"] = _berserkTime
	lookupLogic["$incarnationTicks"] = _incarnationTicks
	lookupLogic["$incarnationTickTime"] = _incarnationTickTime
	lookupLogic["$incarnationNextCp"] = incarnationNextCp
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Guardian()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.guardian
	local sharedSettings = TRB.Data.specCache["druid_guardian"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	--Spec specific implementation

	local currentRageColor = TRB.Data.settings.druid.guardian.colors.text.current.color

	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:IsUsable() then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage
	local castingRage
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentRage = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentRage))
	else
		currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)
	end

	
	--$berserkTime (and $incarnationTime)
	local berserkSnapshotBuff = snapshotData.snapshots[spells.berserk.id].buff

	if not berserkSnapshotBuff.isActive then
		berserkSnapshotBuff = snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff
	end

	local _berserkTime = berserkSnapshotBuff:GetRemainingTime(currentTime)
	local berserkTime = TRB.Functions.BarText:TimerPrecision(_berserkTime)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookup["$rageMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookup["$berserkTime"] = berserkTime
	lookup["$incarnationTime"] = berserkTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$rage"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	lookupLogic["$berserkTime"] = _berserkTime
	lookupLogic["$incarnationTime"] = _berserkTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Restoration()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.druid.restoration
	local sharedSettings = TRB.Data.specCache["druid_restoration"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.druid.restoration.colors.text.current.color
	local castingManaColor = TRB.Data.settings.druid.restoration.colors.text.casting.color

	--$mana
	local manaPrecision = sharedSettings.precision.mana or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	--$efflorescenceTime
	local _efflorescenceTime = snapshots[spells.efflorescence.id].buff:GetRemainingTime(currentTime) --TODO: This isn't actually how this works, double check/fix it
	local efflorescenceTime = TRB.Functions.BarText:TimerPrecision(_efflorescenceTime)

	--$incarnationTime
	local _incarnationTime = snapshots[spells.incarnationTreeOfLife.id].buff:GetRemainingTime(currentTime)
	local incarnationTime = TRB.Functions.BarText:TimerPrecision(_incarnationTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$incarnationTime"] = incarnationTime
	lookup["$efflorescenceTime"] = efflorescenceTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$efflorescenceTime"] = _efflorescenceTime
	lookupLogic["$incarnationTime"] = _incarnationTime
	TRB.Data.lookupLogic = lookupLogic
end

---Unified RefreshLookupData that populates ALL Druid resource variables regardless of active spec
---This enables cross-form bar text variables to work
local function RefreshLookupData_Unified()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()
	local currentForm = TRB.Data.character.currentShapeshiftForm
	local specId = TRB.Data.character.specId
	
	-- Determine which form's settings to use for coloring
	local formSpecId = GetFormSpecForSettings(specId, currentForm)
	local formSpecName = ({ [1] = "druid_balance", [2] = "druid_feral", [3] = "druid_guardian", [4] = "druid_restoration" })[formSpecId]
	local sharedSettings = TRB.Data.specCache[formSpecName] and TRB.Data.specCache[formSpecName].settings
	
	if not sharedSettings then
		-- Fallback to active spec settings
		formSpecName = TRB.Data.character.compositeKey
		sharedSettings = TRB.Data.specCache[formSpecName] and TRB.Data.specCache[formSpecName].settings
	end
	
	if not sharedSettings then
		return -- Cannot proceed without settings
	end
	
	-- Guard: Ensure colors table exists
	if not sharedSettings.colors then
		return -- Cannot proceed without color settings
	end
	
	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	
	-- Get all resource values from snapshot attributes
	local energy = snapshotData.attributes.energy or 0
	local rage = snapshotData.attributes.rageModified or 0
	local mana = snapshotData.attributes.mana or 0
	local astralPower = snapshotData.attributes.astralPower or 0
	local comboPoints = snapshotData.attributes.comboPoints or 0
	
	-- Resource color configuration
	local astralPowerColor =  TRB.Data.settings.druid.balance.colors.text.current.color
	local energyColor =  TRB.Data.settings.druid.feral.colors.text.current.color
	local rageColor =  TRB.Data.settings.druid.guardian.colors.text.current.color
	local manaColor =  TRB.Data.settings.druid.restoration.colors.text.current.color
	
	-- Energy variables ($energy, $energyMax)
		local energyFormatted = string.format("|c%s%s|r", energyColor, energy)
	lookup["$energy"] = energyFormatted
	lookup["$energyMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR
	lookupLogic["$energy"] = energy
	lookupLogic["$energyMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR
	
	-- Rage variables ($rage, $rageMax)
	local rageFormatted = string.format("|c%s%s|r", rageColor, rage)
	lookup["$rage"] = rageFormatted
	lookup["$rageMax"] = TRB.Data.character.maxRage  / RAGE_RESOURCE_FACTOR
	lookupLogic["$rage"] = rage
	lookupLogic["$rageMax"] = TRB.Data.character.maxRage / RAGE_RESOURCE_FACTOR
	
	-- Mana variables ($mana, $manaMax, $manaPercent)
	local manaColorOverride = sharedSettings.colors.text and sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color
	local manaColor = manaColorOverride or manaColor
	local manaFormatted = string.format("|c%s%s|r", manaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(mana))
	local manaMaxFormatted = string.format("|c%s%s|r", manaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxMana))
	local manaPrecision = sharedSettings.precision.mana or 1
	local manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercentFormatted = string.format("|c%s%." .. manaPrecision .. "f|r", manaColor, manaPercent)
	lookup["$mana"] = manaFormatted
	lookup["$manaMax"] = manaMaxFormatted
	lookup["$manaPercent"] = manaPercentFormatted
	lookupLogic["$mana"] = mana
	lookupLogic["$manaMax"] = TRB.Data.character.maxMana / MANA_RESOURCE_FACTOR
	lookupLogic["$manaPercent"] = manaPercent
	
	-- Astral Power variables ($astralPower, $astralPowerMax) - Balance only
	if specId == 1 then
		local astralPowerFormatted = string.format("|c%s%s|r", astralPowerColor, astralPower)
		lookup["$astralPower"] = astralPowerFormatted
		lookup["$astralPowerMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
		lookupLogic["$astralPower"] = astralPower
		lookupLogic["$astralPowerMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
	end
	
	-- Combo Points variables ($comboPoints, $comboPointsMax)
	lookup["$comboPoints"] = comboPoints
	lookup["$comboPointsMax"] = TRB.Data.character.maxComboPoints
	lookupLogic["$comboPoints"] = comboPoints
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxComboPoints
	
	-- Primary $resource and $resourceMax - mapped to current form's resource
	if currentForm == "cat" then
		lookup["$resource"] = energyFormatted
		lookup["$resourceMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR
		lookupLogic["$resource"] = energy
		lookupLogic["$resourceMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR
	elseif currentForm == "bear" then
		lookup["$resource"] = rageFormatted
		lookup["$resourceMax"] = TRB.Data.character.maxRage / RAGE_RESOURCE_FACTOR
		lookupLogic["$resource"] = rage
		lookupLogic["$resourceMax"] = TRB.Data.character.maxRage / RAGE_RESOURCE_FACTOR
	elseif currentForm == "moonkin" and specId == 1 then
		local astralPowerFormatted = string.format("|c%s%s|r", astralPowerColor, astralPower)
		lookup["$resource"] = astralPowerFormatted
		lookup["$resourceMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
		lookupLogic["$resource"] = astralPower
		lookupLogic["$resourceMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
	else
		-- Humanoid/other forms use mana
		lookup["$resource"] = manaFormatted
		lookup["$resourceMax"] = TRB.Data.character.maxMana / MANA_RESOURCE_FACTOR
		lookupLogic["$resource"] = mana
		lookupLogic["$resourceMax"] = TRB.Data.character.maxMana / MANA_RESOURCE_FACTOR
	end

	-- Call the spec-specific lookup function to fill in spec-specific variables
	-- (like $eclipseTime, $berserkTime, $incarnationTime, etc.)
	if specId == 1 then
		RefreshLookupData_Balance()
	elseif specId == 2 then
		RefreshLookupData_Feral()
	elseif specId == 3 then
		RefreshLookupData_Guardian()
	elseif specId == 4 then
		RefreshLookupData_Restoration()
	end
	
	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting_Balance(spell)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()

	local resource = spell.resource

	if talents:IsTalentActive(spells.boundlessMoonlight) and spell.attributes.boundlessMoonlight ~= nil and spell.attributes.boundlessMoonlight > 0 then
		resource = resource + (spells.boundlessMoonlight.attributes.resourceMod * spell.attributes.boundlessMoonlight)
	end

	if talents:IsTalentActive(spells.theEternalMoon) and spell.attributes.theEternalMoon ~= nil and spell.attributes.theEternalMoon > 0 then
		resource = resource + (spells.theEternalMoon.attributes.moonResourceMod * spell.attributes.theEternalMoon)
	end

	casting.startTime = currentTime
	casting.resourceRaw = spell.resource
	casting.resourceFinal = spell.resource
	casting.spellId = spell.id
	casting.icon = spell.icon
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Restoration()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
		
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			if spellId == spells.wrath.id then
				FillSnapshotDataCasting_Balance(spells.wrath)

				if talents:IsTalentActive(spells.wildSurges) then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.wildSurges.attributes.resourceMod
				end
				if talents:IsTalentActive(spells.soulOfTheForest) and snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * (1 + spells.soulOfTheForest.attributes.modifier.wrath)
				end
			elseif spellId == spells.starfire.id then
				FillSnapshotDataCasting_Balance(spells.starfire)
				if talents:IsTalentActive(spells.wildSurges) then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.wildSurges.attributes.resourceMod
				end
				if talents:IsTalentActive(spells.moonGuardian) then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.moonGuardian.attributes.resourceMod
				end
				if talents:IsTalentActive(spells.soulOfTheForest) and snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive then
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * (1 + spells.soulOfTheForest.attributes.modifier.starfire)
				end
			elseif spellId == spells.stellarFlare.id then
				FillSnapshotDataCasting_Balance(spells.stellarFlare)
			elseif spellId == spells.newMoon.id then
				FillSnapshotDataCasting_Balance(spells.newMoon)
			elseif spellId == spells.halfMoon.id then
				FillSnapshotDataCasting_Balance(spells.halfMoon)
			elseif spellId == spells.fullMoon.id then
				FillSnapshotDataCasting_Balance(spells.fullMoon)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.eclipseSolar.castId then
				snapshotData.snapshots[spells.eclipseSolar.id].buff:InitializeCustom(spells.eclipseSolar.duration, currentTime)
			elseif spellId == spells.eclipseLunar.castId then
				snapshotData.snapshots[spells.eclipseLunar.id].buff:InitializeCustom(spells.eclipseLunar.duration, currentTime)
			elseif spellId == spells.celestialAlignment.castId or spellId == spells.celestialAlignment.talentId then
				local duration = spells.celestialAlignment.duration

				snapshotData.snapshots[spells.celestialAlignment.id].buff:InitializeCustom(duration, currentTime)
			elseif spellId == spells.incarnationChosenOfElune.castId or spellId == spells.incarnationChosenOfElune.id then
				local duration = spells.incarnationChosenOfElune.duration

				snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 2 then
				local spells = spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.berserk.castId then
				snapshotData.snapshots[spells.berserk.id].buff:InitializeCustom(spells.berserk.duration, currentTime)
			elseif spellId == spells.incarnationAvatarOfAshamane.castId or spellId == spells.incarnationAvatarOfAshamane.attributes.castId2 then
				snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff:InitializeCustom(spells.incarnationAvatarOfAshamane.duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.berserk.castId then
				snapshotData.snapshots[spells.berserk.id].buff:InitializeCustom(spells.berserk.duration, currentTime)
			elseif spellId == spells.incarnationGuardianOfUrsoc.castId then
				snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff:InitializeCustom(spells.incarnationGuardianOfUrsoc.duration, currentTime)
			end
		elseif event == "SPELL_UPDATE_ICON" then

		end
	elseif TRB.Data.character.specId == 4 then
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Restoration()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.efflorescence.castId then
				snapshotData.snapshots[spells.efflorescence.id].buff:InitializeCustom(spells.efflorescence.duration, currentTime)
			elseif spellId == spells.incarnationTreeOfLife.castId then
				snapshotData.snapshots[spells.incarnationTreeOfLife.id].buff:InitializeCustom(spells.incarnationTreeOfLife.duration, currentTime)
			elseif spellId == spells.lifebloom.castId then
				if talents:IsTalentActive(spells.lifetreading) then
					snapshotData.snapshots[spells.efflorescence.id].buff:InitializeCustom(spells.efflorescence.duration, currentTime)
				end
			end
		end
	end
end

---Calculates the incoming combo points for a given effect
---@param spell TRB.Classes.SpellBase
---@param buffSnapshot TRB.Classes.Snapshot
---@param cpSnapshot TRB.Classes.Snapshot
local function CalculateIncomingComboPointsForEffect(spell, buffSnapshot, cpSnapshot)
	local currentTime = GetTime()
	buffSnapshot.buff:GetRemainingTime(currentTime)
	local remainingTime = buffSnapshot.buff.remaining

	if remainingTime > 0 then
		local offset = spell.attributes.offset or 0
		local totalCps = TRB.Functions.Number:RoundTo((remainingTime - offset) / spell:GetTickRate(), 0, "ceil", true) or 0
		local untilNextTick = remainingTime - offset - (spell:GetTickRate() * math.max(0, totalCps - 1))-- - (currentTime - (cpSnapshot.attributes.lastTick or currentTime))

		if buffSnapshot.buff.endTime < currentTime then
			totalCps = 1
			untilNextTick = 0
		elseif untilNextTick < 0 then
			totalCps = totalCps + 1
			untilNextTick = 0
		end

		cpSnapshot.attributes.ticks = totalCps
		cpSnapshot.attributes.nextTick = currentTime + untilNextTick
		cpSnapshot.attributes.untilNextTick = untilNextTick
		cpSnapshot.attributes.tickRate = spell:GetTickRate()
	else
		buffSnapshot.buff:Reset()
		cpSnapshot.attributes.lastTick = nil
		cpSnapshot.attributes.ticks = 0
		cpSnapshot.attributes.nextTick = nil
		cpSnapshot.attributes.untilNextTick = 0
		cpSnapshot.attributes.tickRate = spell:GetTickRate()
	end
end

local function UpdateBerserkIncomingComboPoints()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	local berserk = TRB.Data.snapshotData.snapshots[spells.berserk.id] --[[@as TRB.Classes.Snapshot]]
	local incarnationAvatarOfAshamane = TRB.Data.snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id] --[[@as TRB.Classes.Snapshot]]
	if incarnationAvatarOfAshamane.buff.isActive then
		CalculateIncomingComboPointsForEffect(spells.incarnationAvatarOfAshamane, incarnationAvatarOfAshamane, berserk)
	else
		CalculateIncomingComboPointsForEffect(spells.berserk, berserk, berserk)
	end
end

---Checks if Apex Predator's Craving is active by comparing its current energy cost to its base cost
---@return boolean # True if Apex Predator's Craving is active (energy cost is free)
local function IsApexPredatorsCravingActive()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	if spells == nil or spells.apexPredatorsCraving == nil then
		return false
	end

	local baseEnergyCost = spells.apexPredatorsCraving.attributes.baseEnergyCost
	if baseEnergyCost == nil or baseEnergyCost < 0 then
		return false
	end

	local currentCost = spells.ferociousBiteMinimum:GetPrimaryResourceCost(true) or 0
	return currentCost == 0 and currentCost < baseEnergyCost
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
end

local function UpdateSnapshot_Balance()
	UpdateSnapshot()
	GetCurrentMoonSpell()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()

	snapshotData.snapshots[spells.celestialAlignment.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.incarnationChosenOfElune.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.eclipseSolar.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.eclipseLunar.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Feral()
	UpdateSnapshot()
	UpdateBerserkIncomingComboPoints()
	
	local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Druid.FeralSpells]
	--[[local snapshotData = TRB.Data.snapshotData --[@as TRB.Classes.SnapshotData]
	local currentTime = GetTime()]]

	local currentApcCost = spells.ferociousBiteMinimum:GetPrimaryResourceCost(true) or 0
	if currentApcCost > 0 then
		local baseEnergyCost = spells.apexPredatorsCraving.attributes.baseEnergyCost
		if baseEnergyCost == nil then
			-- First time seeing a non-zero cost, store it
			spells.apexPredatorsCraving.attributes.baseEnergyCost = currentApcCost
		elseif currentApcCost >= baseEnergyCost then
			-- We captured a reduced cost initially, overwrite with the higher (true base) cost
			spells.apexPredatorsCraving.attributes.baseEnergyCost = currentApcCost
		end
	end
end

local function UpdateSnapshot_Guardian()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()

	snapshotData.snapshots[spells.berserk.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff:GetRemainingTime(currentTime)
	-- Add any Guardian-specific snapshot updates here when spells are defined
end

local function UpdateSnapshot_Restoration()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.druid
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	TRB.Functions.Bar:HideResourceBar()

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end
	
	-- Form-based resource switching: Determine which form we're in and which spec's settings to use
	local currentForm = TRB.Data.character.currentShapeshiftForm or "humanoid"
	local activeSpecId = TRB.Data.character.specId
	local displaySpecId = GetFormSpecForSettings(activeSpecId, currentForm)
	local displaySpecName = ({ [1] = "balance", [2] = "feral", [3] = "guardian", [4] = "restoration" })[displaySpecId]
	local displayCompositeKey = ({ [1] = "druid_balance", [2] = "druid_feral", [3] = "druid_guardian", [4] = "druid_restoration" })[displaySpecId]
	
	-- Determine which resource to display based on displaySpecId (respects enableFormSwitching setting)
	local displayResource = snapshotData.attributes.resource -- default
	local displayResourceType = TRB.Data.resource -- default
	local displayResourceFactor = TRB.Data.resourceFactor or 1 -- default
	local displayMaxResource = TRB.Data.character.maxResource -- default
	
	if displaySpecId == 2 then -- Feral uses Energy
		displayResource = snapshotData.attributes.energy or 0
		displayResourceType = Enum.PowerType.Energy
		displayResourceFactor = 1
		displayMaxResource = TRB.Data.character.maxEnergy
	elseif displaySpecId == 3 then -- Guardian uses Rage
		displayResource = snapshotData.attributes.rage or 0
		displayResourceType = Enum.PowerType.Rage
		displayResourceFactor = 10
		displayMaxResource = TRB.Data.character.maxRage
	elseif displaySpecId == 1 then -- Balance uses Astral Power
		displayResource = snapshotData.attributes.astralPower or 0
		displayResourceType = Enum.PowerType.LunarPower
		displayResourceFactor = 10
		displayMaxResource = TRB.Data.character.maxAstralPower
	else -- Restoration uses Mana
		displayResource = snapshotData.attributes.mana or 0
		displayResourceType = Enum.PowerType.Mana
		displayResourceFactor = 1
		displayMaxResource = TRB.Data.character.maxMana
	end
	
	local formSpecSettings = classSettings[displaySpecName]
	local formSpecCache = TRB.Data.specCache[displayCompositeKey]
	local formSpecCacheSettings = formSpecCache and formSpecCache.settings
	
	-- If the form's spec cache settings aren't available, fall back to current spec's settings
	if formSpecCacheSettings == nil then
		formSpecCacheSettings = TRB.Data.specCache[TRB.Data.character.compositeKey] and TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		if formSpecCacheSettings == nil then
			return -- Cannot proceed without settings
		end
	end

	local function ConstructPrimaryGeneric(maxPrimaryBarResource)
		-- Guard: Skip threshold processing if the form's spec doesn't define thresholds
		if formSpecCacheSettings.thresholds == nil or formSpecCacheSettings.thresholds.properties == nil then
			return
		end
		
		-- Guard: Ensure colors.threshold exists for threshold coloring
		if formSpecCacheSettings.colors == nil or formSpecCacheSettings.colors.threshold == nil then
			return
		end
		
		-- Get resourceFrame and thresholds from the BarNode
		local resourceFrame = primaryNode:GetResourceFrame()
		local thresholds = primaryNode:GetThresholds()

		local pairOffset = 0
		for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
			-- Create threshold on-demand if missing
			if thresholds[thresholdId] == nil then
				local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, formSpecCacheSettings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
				thresholds = primaryNode:GetThresholds()
			end

			if spell.primaryResourceType ~= nil and spell.primaryResourceType ~= displayResourceType then
				-- This threshold is for a different resource type, hide and skip it
				if thresholds[thresholdId] ~= nil then
					thresholds[thresholdId]:Hide()
				end
			else
				pairOffset = (thresholdId - 1) * 3
				local resourceAmount = spell:GetPrimaryResourceCost()
				local isUsable = spell:IsUsable()
				local showThreshold = true
				local thresholdColor = formSpecCacheSettings.colors.threshold.over.color
				local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
				local snapshot = snapshots[spell.id]
				
				if resourceAmount == 0 then
					showThreshold = false
				elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
					showThreshold = false
				elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
					showThreshold = false
				elseif spell.hasCooldown then
					if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
						thresholdColor = formSpecCacheSettings.colors.threshold.unusable.color
						frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					elseif isUsable then
						thresholdColor = formSpecCacheSettings.colors.threshold.over.color
					else
						thresholdColor = formSpecCacheSettings.colors.threshold.under.color
						frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
					end
				else -- This is an active/available/normal spell threshold
					if isUsable then
						thresholdColor = formSpecCacheSettings.colors.threshold.over.color
					else
						thresholdColor = formSpecCacheSettings.colors.threshold.under.color
						frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
					end
				end
				
				if resourceAmount > maxPrimaryBarResource then
					showThreshold = false
				end

				if thresholds[thresholdId] then
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, formSpecCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(formSpecCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResource)
				end
			end
		end
	end

	local function ConstructComboPointsGeneric()
		-- Combo points update (when displaying Feral bar configuration)
		-- Only show combo points when displaySpecId == 2 (Feral), which means form switching is enabled and we're in Cat form
		-- This ensures formSpecSettings points to Feral settings (which has comboPoints defined)
		if displaySpecId == 2 and formSpecSettings.displayBar.secondary.visibility ~= "never" then
			-- Use Feral's combo point settings (formSpecSettings points to Feral when displaySpecId == 2)
			local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(formSpecSettings.colors.comboPoints.background.color, true)
			
			for x = 1, TRB.Data.character.maxComboPoints do
				local cpBorderColor = formSpecSettings.colors.comboPoints.border.color
				local cpColor = formSpecSettings.colors.comboPoints.base.color
				local cpBR = cpBackgroundRed
				local cpBG = cpBackgroundGreen
				local cpBB = cpBackgroundBlue

				if barGroups and barGroups.secondary then
					local cpNode = barGroups.secondary:GetNode(x)
					if cpNode then
						if (snapshotData.attributes.comboPoints or 0) >= x then
							TRB.Functions.Bar:SetBarNodeValue(formSpecCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
							if (formSpecSettings.comboPoints.sameColor and snapshotData.attributes.comboPoints == (TRB.Data.character.maxComboPoints - 1)) or (not formSpecSettings.comboPoints.sameColor and x == (TRB.Data.character.maxComboPoints - 1)) then
								cpColor = formSpecSettings.colors.comboPoints.penultimate.color
							elseif (formSpecSettings.comboPoints.sameColor and snapshotData.attributes.comboPoints == (TRB.Data.character.maxComboPoints)) or x == TRB.Data.character.maxComboPoints then
								cpColor = formSpecSettings.colors.comboPoints.final.color
							end
						else
							TRB.Functions.Bar:SetBarNodeValue(formSpecCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
						end
						
						cpNode:SetBorderColor(cpBorderColor)
						cpNode:SetColor(cpColor)
						cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			return true
		end
	end
	
	-- Use form-appropriate resource for display
	local currentResource = displayResource
	local maxPrimaryBarResourceUnnormalized = displayMaxResource
	if formSpecCacheSettings.maxResource ~= nil and formSpecCacheSettings.maxResource.enabled == true and formSpecCacheSettings.maxResource.value > 0 then
		maxPrimaryBarResourceUnnormalized = math.min(formSpecCacheSettings.maxResource.value * displayResourceFactor, maxPrimaryBarResourceUnnormalized)
	end
	local maxPrimaryBarResource = maxPrimaryBarResourceUnnormalized / displayResourceFactor

	if TRB.Data.character.specId == 1 then
		-- Override with form-appropriate spec settings for colors and bar configuration
		local specSettings = classSettings.balance
		local specCacheSettings = TRB.Data.specCache["druid_balance"].settings
		UpdateSnapshot_Balance()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
				local flashBar = false
				local barBorderColor = specSettings.colors.bar.border.color


				-- Set min/max before setting value to ensure correct scaling
				primaryNode:SetMinMax(0, maxPrimaryBarResourceUnnormalized)
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "resource", primaryNode, currentResource, maxPrimaryBarResourceUnnormalized)

				local barColor = specSettings.colors.bar.base.color
				-- Use simple colors when in non-native form
				if displaySpecId ~= TRB.Data.character.specId then
					barColor = formSpecSettings.colors.bar.base.color
					barBorderColor = formSpecSettings.colors.bar.border.color
					ConstructPrimaryGeneric(maxPrimaryBarResource)
				else
					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetResourceFrame()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						-- Form-based threshold filtering: Only show thresholds for current form's resource type
						local shouldProcessThreshold = true
						if spell.primaryResourceType ~= nil and spell.primaryResourceType ~= displayResourceType then
							-- This threshold is for a different resource type, hide and skip it
							if thresholds[thresholdId] ~= nil then
								thresholds[thresholdId]:Hide()
							end
							shouldProcessThreshold = false
						end
						
						if shouldProcessThreshold then
							-- Create threshold on-demand if missing
							if thresholds[thresholdId] == nil then
								local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
								TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
								primaryNode:RegisterThreshold(thresholdFrame)
								thresholds = primaryNode:GetThresholds()
							end
							pairOffset = (thresholdId - 1) * 3
							local resourceAmount = spell:GetPrimaryResourceCost()
							local showThreshold = true
							local thresholdColor = specCacheSettings.colors.threshold.over.color --[[@as string?]]
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							local snapshot = snapshots[spell.id]
							local isUsable = spell:IsUsable()

							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.settingKey == spells.starsurge.settingKey then
									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
									
									if showThreshold then
										if isUsable then
											if specSettings.audio.ssReady.enabled and snapshotData.audio.playedSsCue == false then
												snapshotData.audio.playedSsCue = true
												PlaySoundFile(specSettings.audio.ssReady.sound, coreSettings.audio.channel.channel)
											end
										else
											snapshotData.audio.playedSsCue = false
										end
									end
								elseif spell.settingKey == spells.starsurge2.settingKey then
									if specCacheSettings.thresholds.specProperties.starsurgeThresholdOnlyOverShow then
										showThreshold = false
									else
										-- Use ColorCurve to dynamically change threshold color based on resource
										local baseCost = resourceAmount / spell.primaryResourceTypeMod
										local thresholdCurve = TRB.Functions.Color:BuildMulticastThresholdCurve(
											spell.primaryResourceTypeMod,
											baseCost,
											specCacheSettings.colors.threshold.under.color,
											specCacheSettings.colors.threshold.over.color
										)
										local iconCurve = TRB.Functions.Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
										frameLevel = isUsable and TRB.Data.constants.frameLevels.thresholdOver or TRB.Data.constants.frameLevels.thresholdUnder
										local curveApplied = TRB.Functions.Threshold:ApplyMulticastThresholdCurveColor(
											spell, thresholds[thresholdId], thresholdCurve, TRB.Data.resource, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
										)
										if curveApplied then
											thresholdColor = nil -- Skip normal color application
										else
											-- No valid target or out of range - use under color (AdjustThresholdDisplay handles out-of-range override)
											thresholdColor = specCacheSettings.colors.threshold.under.color
										end
									end
								elseif spell.settingKey == spells.starsurge3.settingKey then
									if specCacheSettings.thresholds.specProperties.starsurgeThresholdOnlyOverShow then
										showThreshold = false
									else
										-- Use ColorCurve to dynamically change threshold color based on resource
										local baseCost = resourceAmount / spell.primaryResourceTypeMod
										local thresholdCurve = TRB.Functions.Color:BuildMulticastThresholdCurve(
											spell.primaryResourceTypeMod,
											baseCost,
											specCacheSettings.colors.threshold.under.color,
											specCacheSettings.colors.threshold.over.color
										)
										local iconCurve = TRB.Functions.Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
										frameLevel = isUsable and TRB.Data.constants.frameLevels.thresholdOver or TRB.Data.constants.frameLevels.thresholdUnder
										local curveApplied = TRB.Functions.Threshold:ApplyMulticastThresholdCurveColor(
											spell, thresholds[thresholdId], thresholdCurve, TRB.Data.resource, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
										)
										if curveApplied then
											thresholdColor = nil -- Skip normal color application
										else
											-- No valid target or out of range - use under color (AdjustThresholdDisplay handles out-of-range override)
											thresholdColor = specCacheSettings.colors.threshold.under.color
										end
									end
								elseif spell.id == spells.starfall.id then
									if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
									
									if showThreshold then
										if isUsable then
											if specSettings.audio.sfReady.enabled and snapshotData.audio.playedSfCue == false then
												snapshotData.audio.playedSfCue = true
												PlaySoundFile(specSettings.audio.sfReady.sound, coreSettings.audio.channel.channel)
											end
										else
											snapshotData.audio.playedSfCue = false
										end
									end
								end
							--The rest isn't used. Keeping it here for consistency until I can finish abstracting this whole mess out
							elseif resourceAmount == 0 then
								showThreshold = false
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.hasCooldown then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end

							--[[
							TODO: Find out if this is still required for Starfall?
							local snapshotCooldown = nil
							if snapshots[spell.id] ~= nil then
								snapshotCooldown = snapshots[spell.id].cooldown
							end
							]]
						
							if resourceAmount == nil then
								showThreshold = false
							elseif resourceAmount >= maxPrimaryBarResource then
								showThreshold = false
							end

							local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
							TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResource)
						end -- shouldProcessThreshold
					end
					
					if specSettings.colors.bar.flashEnabled and spells.starsurge:IsUsable() then-- currentResource >= spells.starsurge:GetPrimaryResourceCost() then
						flashBar = true
					end

					if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
						local timeThreshold = 0
						local useEndOfEclipseColor = false

						if specSettings.endOf.eclipse.enabled and (not specSettings.endOf.eclipse.celestialAlignmentOnly or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive) then
							useEndOfEclipseColor = true
							if specSettings.endOf.eclipse.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOf.eclipse.gcdsMax
							elseif specSettings.endOf.eclipse.mode == "time" then
								timeThreshold = specSettings.endOf.eclipse.timeMax
							end
						end

						if useEndOfEclipseColor and GetEclipseRemainingTime() <= timeThreshold then
							barColor = specSettings.colors.bar.eclipseEnd.color
						elseif snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive or (snapshots[spells.eclipseSolar.id].buff.isActive and snapshots[spells.eclipseLunar.id].buff.isActive) then
							if specSettings.colors.bar.celestial.enabled then
								barColor = specSettings.colors.bar.celestial.color
							end
						elseif snapshots[spells.eclipseSolar.id].buff.isActive then
							if specSettings.colors.bar.solar.enabled then
								barColor = specSettings.colors.bar.solar.color
							end
						else
							if specSettings.colors.bar.lunar.enabled then
								barColor = specSettings.colors.bar.lunar.color
							end
						end
					end
				end

				-- Apply overcap border color if enabled (Cat/Feral uses Energy, Bear/Guardian uses Rage)
				if formSpecSettings.colors.bar.borderOvercap ~= nil and formSpecSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(formSpecSettings, barBorderColor, formSpecSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", displayResourceType, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end

				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				if flashBar then
					TRB.Functions.Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
				end
			end
			
			local refreshTextFromComboPoints = ConstructComboPointsGeneric()
			refreshText = refreshText or refreshTextFromComboPoints

			-- Health bar update
			if specSettings.displayBar.health.visibility ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end

			-- Mana bar update (Balance only)
			if specSettings.displayBar.mana ~= nil and specSettings.displayBar.mana.visibility ~= "never" then
				refreshText = true
				local manaNode = barGroups and barGroups.mana and barGroups.mana:GetNode(1)
				if manaNode then
					local currentMana = snapshotData.attributes.mana or UnitPower("player", Enum.PowerType.Mana) or 0
					local maxMana = snapshotData.attributes.manaMax or UnitPowerMax("player", Enum.PowerType.Mana) or 1
					manaNode:SetMinMax(0, maxMana)
					manaNode:SetValue(currentMana)
					manaNode:SetColor(specSettings.colors.bars.mana.bar.color)
					manaNode:SetBorderColor(specSettings.colors.bars.mana.border.color)
					manaNode:SetBackgroundColorFromString(specSettings.colors.bars.mana.background.color)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		-- Override with form-appropriate spec settings for colors and bar configuration
		local specSettings = classSettings.feral
		local specCacheSettings = TRB.Data.specCache["druid_feral"].settings
		UpdateSnapshot_Feral()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]

				-- Set min/max before setting value to ensure correct scaling
				primaryNode:SetMinMax(0, maxPrimaryBarResourceUnnormalized)
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "resource", primaryNode, currentResource, maxPrimaryBarResourceUnnormalized)

				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				local apcActive = IsApexPredatorsCravingActive()

				-- Use simple colors when in non-native form
				if displaySpecId ~= TRB.Data.character.specId then
					barColor = formSpecSettings.colors.bar.base.color
					barBorderColor = formSpecSettings.colors.bar.border.color
					ConstructPrimaryGeneric(maxPrimaryBarResource)
					primaryNode:SetBorderColor(barBorderColor)
				else
					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetResourceFrame()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						-- Form-based threshold filtering: Only show thresholds for current form's resource type
						local shouldProcessThreshold = true
						if spell.primaryResourceType ~= nil and spell.primaryResourceType ~= displayResourceType then
							-- This threshold is for a different resource type, hide and skip it
							if thresholds[thresholdId] ~= nil then
								thresholds[thresholdId]:Hide()
							end
							shouldProcessThreshold = false
						end
						
						if shouldProcessThreshold then
							-- Create threshold on-demand if missing
							if thresholds[thresholdId] == nil then
								local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
								TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
								primaryNode:RegisterThreshold(thresholdFrame)
								thresholds = primaryNode:GetThresholds()
							end
							pairOffset = (thresholdId - 1) * 3
							local resourceAmount = spell:GetPrimaryResourceCost()
							local isUsable = spell:IsUsable()
							local showThreshold = true
							local thresholdColor = specCacheSettings.colors.threshold.over.color
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							local snapshot = snapshots[spell.id]

							if spell.attributes.isClearcasting and snapshots[spells.clearcasting.id].buff.applications ~= nil and snapshots[spells.clearcasting.id].buff.applications > 0 then
								if spell.id == spells.brutalSlash.id then
									if not talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif snapshots[spells.brutalSlash.id].cooldown.charges > 0 then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									end
								elseif spell.id == spells.swipe.id then
									if talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									thresholdColor = specCacheSettings.colors.threshold.over.color
								end
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == spells.ferociousBiteMinimum.id then
									if snapshots[spells.ravageMinimum.id].buff.isActive then
										showThreshold = false
									elseif spell.id == spells.ferociousBiteMinimum.id and spell.settingKey == "ferociousBiteMinimum" then
										if isUsable or apcActive then
											thresholdColor = specCacheSettings.colors.threshold.over.color
										else
											thresholdColor = specCacheSettings.colors.threshold.under.color
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == spells.ferociousBiteMaximum.id and spell.settingKey == "ferociousBiteMaximum" then
										if isUsable or apcActive then
											thresholdColor = specCacheSettings.colors.threshold.over.color
										else
											thresholdColor = specCacheSettings.colors.threshold.under.color
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.ravageMinimum.id then
									if not snapshots[spells.ravageMinimum.id].buff.isActive then
										showThreshold = false
									elseif spell.id == spells.ravageMinimum.id and spell.settingKey == "ravageMinimum" then
										if isUsable or apcActive then
											thresholdColor = specCacheSettings.colors.threshold.over.color
										else
											thresholdColor = specCacheSettings.colors.threshold.under.color
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == spells.ravageMaximum.id and spell.settingKey == "ravageMaximum" then
										if isUsable or apcActive then
											thresholdColor = specCacheSettings.colors.threshold.over.color
										else
											thresholdColor = specCacheSettings.colors.threshold.under.color
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == spells.moonfire.id then
									if not talents:IsTalentActive(spells.lunarInspiration) then
										showThreshold = false
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.swipe.id then
									if talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.brutalSlash.id then
									if not talents:IsTalentActive(spells.brutalSlash) then
										showThreshold = false
									elseif snapshots[spells.brutalSlash.id].cooldown.charges == 0 then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.frenziedRegeneration.id then
									if not talents:IsTalentActive(spells.empoweredShapeshifting) then
										showThreshold = false
									elseif snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.feralFrenzy.id then
									if talents:IsTalentActive(spells.franticFrenzy) then
										showThreshold = false
									elseif snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == spells.franticFrenzy.id then
									if not talents:IsTalentActive(spells.franticFrenzy) then
										showThreshold = false
									elseif snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else
									showThreshold = false
								end
							elseif resourceAmount == 0 then
								showThreshold = false
							elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.hasCooldown then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else -- This is an active/available/normal spell threshold
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end
						
						if resourceAmount >= maxPrimaryBarResourceUnnormalized then
							showThreshold = false
						end

						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
						end
					end

					
					-- Use simple colors when in non-native form
					if displaySpecId ~= TRB.Data.character.specId then
						barColor = specSettings.colors.bar.base.color
					else
						if specSettings.colors.bar.clearcasting.enabled and snapshots[spells.clearcasting.id].buff.remaining > 0 then
							barColor = specSettings.colors.bar.clearcasting.color
						end

						if specSettings.colors.bar.maxBite.enabled and snapshotData.attributes.resource2 == 5 and spells.ferociousBiteMaximum:IsUsable() then
							barColor = specSettings.colors.bar.maxBite.color
						end						

						if apcActive then
							if specSettings.colors.bar.apexPredator.enabled then
								barColor = specSettings.colors.bar.apexPredator.color
							end

							if specSettings.audio.apexPredatorsCraving.enabled and not snapshotData.audio.apexPredatorsCravingCue then
								snapshotData.audio.apexPredatorsCravingCue = true
								PlaySoundFile(specSettings.audio.apexPredatorsCraving.sound, coreSettings.audio.channel.channel)
							end
						else
							-- Reset audio cues when Apex Predator's Craving is no longer active
							snapshotData.audio.apexPredatorsCravingCue = false
						end
					end

					local barBorderColor = specSettings.colors.bar.border.color
					if specSettings.colors.bar.borderStealth.enabled and IsStealthed() then
						primaryNode:SetBorderColor(specSettings.colors.bar.borderStealth.color)
					elseif specSettings.colors.bar.borderOvercap ~= nil and specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
						-- Apply overcap border color if enabled (skipped when stealthed)
						local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", displayResourceType, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
				end

				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			-- Show combo points when in Cat form, OR when displaySpecId is Feral (enableFormSwitching disabled)
			if (currentForm == "cat" or displaySpecId == 2) and specSettings.displayBar.secondary.visibility ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				local berserkTotalCps = snapshots[spells.berserk.id].attributes.ticks
				local berserkNextTick = snapshots[spells.berserk.id].attributes.tickRate - snapshots[spells.berserk.id].attributes.untilNextTick

				local berserkTickShown = 0

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border.color
					local cpColor = specSettings.colors.comboPoints.base.color
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate.color
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final.color
								end
							else
								if specSettings.colors.comboPoints.generation and berserkTickShown == 0 and berserkTotalCps > 0 then
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, berserkNextTick * 1000, spells.berserk:GetTickRate() * 1000)
									berserkTickShown = 1

									if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
										cpColor = specSettings.colors.comboPoints.penultimate.color
									elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
										cpColor = specSettings.colors.comboPoints.final.color
									end
								else
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
								end
							end
							
							cpNode:SetBorderColor(cpBorderColor)
							cpNode:SetColor(cpColor)
							cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
						end
					end
				end
			end

			-- Health bar update
			if specSettings.displayBar.health.visibility ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end
		end

		-- Combo Point threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			do
				local coreSettings = TRB.Data.settings.core
				local currentResource2 = snapshotData.attributes.resource2
				local threshold1 = specSettings.audio.comboPointThreshold1
				local threshold2 = specSettings.audio.comboPointThreshold2
				local threshold1Value = threshold1.configuration.thresholdValue
				local threshold2Value = threshold2.configuration.thresholdValue

				local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.comboPointThreshold1Played and currentResource2 >= threshold1Value
				local threshold2ShouldFire = threshold2.enabled and not snapshotData.audio.comboPointThreshold2Played and currentResource2 >= threshold2Value

				if threshold1ShouldFire and threshold2ShouldFire then
					snapshotData.audio.comboPointThreshold1Played = true
					snapshotData.audio.comboPointThreshold2Played = true
					if threshold2Value > threshold1Value then
						PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
					else
						PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
					end
				elseif threshold2ShouldFire then
					snapshotData.audio.comboPointThreshold2Played = true
					PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
				elseif threshold1ShouldFire then
					snapshotData.audio.comboPointThreshold1Played = true
					PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
				end

				if currentResource2 < threshold1Value then
					snapshotData.audio.comboPointThreshold1Played = false
				end
				if currentResource2 < threshold2Value then
					snapshotData.audio.comboPointThreshold2Played = false
				end
			end
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		-- Override with form-appropriate spec settings for colors and bar configuration
		local specSettings = classSettings.guardian
		local specCacheSettings = TRB.Data.specCache["druid_guardian"].settings
		UpdateSnapshot_Guardian()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]

				-- Set min/max before setting value to ensure correct scaling
				primaryNode:SetMinMax(0, maxPrimaryBarResourceUnnormalized)
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "resource", primaryNode, currentResource, maxPrimaryBarResourceUnnormalized)

				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				-- Use simple colors when in non-native form
				if displaySpecId ~= TRB.Data.character.specId then
					barColor = formSpecSettings.colors.bar.base.color
					barBorderColor = formSpecSettings.colors.bar.border.color
					ConstructPrimaryGeneric(maxPrimaryBarResource)
					primaryNode:SetBorderColor(barBorderColor)
				else
					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetResourceFrame()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						-- Form-based threshold filtering: Only show thresholds for current form's resource type
						local shouldProcessThreshold = true
						if spell.primaryResourceType ~= nil and spell.primaryResourceType ~= displayResourceType then
							-- This threshold is for a different resource type, hide and skip it
							if thresholds[thresholdId] ~= nil then
								thresholds[thresholdId]:Hide()
							end
							shouldProcessThreshold = false
						end
						
						if shouldProcessThreshold then
							-- Create threshold on-demand if missing
							if thresholds[thresholdId] == nil then
								local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
								TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
								primaryNode:RegisterThreshold(thresholdFrame)
								thresholds = primaryNode:GetThresholds()
							end
							pairOffset = (thresholdId - 1) * 3
							local resourceAmount = spell:GetPrimaryResourceCost()
						local isUsable = spell:IsUsable()
						local showThreshold = true
						local thresholdColor = specCacheSettings.colors.threshold.over.color
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
						local snapshot = snapshots[spell.id]

						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.maul.id then
								if talents:IsTalentActive(spells.raze) then
									showThreshold = false
								elseif talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						elseif resourceAmount == 0 then
							showThreshold = false
						elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.hasCooldown then
							if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else -- This is an active/available/normal spell threshold
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end

						if resourceAmount >= maxPrimaryBarResource then
							showThreshold = false
						end

						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResource)
						end
					end
				
					if snapshots[spells.berserk.id].buff.isActive or snapshots[spells.incarnationGuardianOfUrsoc.id].buff.isActive then
						local snapshotBuff = snapshots[spells.berserk.id].buff

						if not snapshotBuff.isActive then
							snapshotBuff = snapshots[spells.incarnationGuardianOfUrsoc.id].buff
						end

						local timeThreshold = 0
						local useEndOfBerserkColor = false

						if specSettings.endOf.berserk.enabled then
							useEndOfBerserkColor = true
							if specSettings.endOf.berserk.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOf.berserk.gcdsMax
							elseif specSettings.endOf.berserk.mode == "time" then
								timeThreshold = specSettings.endOf.berserk.timeMax
							end
						end

						if useEndOfBerserkColor and snapshotBuff.remaining <= timeThreshold then
							barColor = specSettings.colors.bar.berserkEnd.color
						elseif specSettings.colors.bar.berserk.enabled then
							barColor = specSettings.colors.bar.berserk.color
						end
					end

					-- Apply overcap border color if enabled
					if specSettings.colors.bar.borderOvercap ~= nil and specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
						local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", displayResourceType, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
				end

				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				primaryNode:SetColor(barColor)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			local refreshTextFromComboPoints = ConstructComboPointsGeneric()
			refreshText = refreshText or refreshTextFromComboPoints

			-- Health bar update
			if specSettings.displayBar.health.visibility ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 4 then
		-- Override with form-appropriate spec settings for colors and bar configuration
		local specSettings = classSettings.restoration
		local specCacheSettings = TRB.Data.specCache.druid_restoration.settings
		UpdateSnapshot_Restoration()

		if snapshotData.attributes.isTracking then
			if formSpecSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]

				-- Set min/max before setting value to ensure correct scaling
				primaryNode:SetMinMax(0, maxPrimaryBarResourceUnnormalized)
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "resource", primaryNode, currentResource, maxPrimaryBarResourceUnnormalized)

				local barBorderColor = formSpecSettings.colors.bar.border.color
				local barColor = specSettings.colors.bar.base.color

				-- Use simple colors when in non-native form
				if displaySpecId ~= TRB.Data.character.specId then
					barColor = formSpecSettings.colors.bar.base.color
					ConstructPrimaryGeneric(maxPrimaryBarResource)
				else
					if (currentForm == "humanoid" or currentForm == "treeOfLife" or currentForm == "treant") then
						if specSettings.colors.bar.noEfflorescence.enabled and affectingCombat and talents:IsTalentActive(spells.efflorescence) and not snapshots[spells.efflorescence.id].buff.isActive then
							barColor = specSettings.colors.bar.noEfflorescence.color
						elseif snapshots[spells.incarnationTreeOfLife.id].buff.isActive and (talents:IsTalentActive(spells.cenariusGuidance) or snapshots[spells.clearcasting.id].buff.isActive) then
							local timeThreshold = 0
							local useEndOfIncarnationColor = false

							if specSettings.endOf.incarnation.enabled then
								useEndOfIncarnationColor = true
								if specSettings.endOf.incarnation.mode == "gcd" then
									local gcd = TRB.Functions.Character:GetCurrentGCDTime()
									timeThreshold = gcd * specSettings.endOf.incarnation.gcdsMax
								elseif specSettings.endOf.incarnation.mode == "time" then
									timeThreshold = specSettings.endOf.incarnation.timeMax
								end
							end

							if useEndOfIncarnationColor and snapshots[spells.incarnationTreeOfLife.id].buff.remaining <= timeThreshold then
								barColor = specSettings.colors.bar.incarnationEnd.color
							elseif specSettings.colors.bar.incarnation.enabled then
								barColor = specSettings.colors.bar.incarnation.color
							end
						end
					end
				end

				-- Apply overcap border color if enabled (Cat/Feral uses Energy, Bear/Guardian uses Rage)
				if formSpecSettings.colors.bar.borderOvercap ~= nil and formSpecSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(formSpecSettings, barBorderColor, formSpecSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", displayResourceType, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
	
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			local refreshTextFromComboPoints = ConstructComboPointsGeneric()
			refreshText = refreshText or refreshTextFromComboPoints

			-- Health bar update
			if specSettings.displayBar.health.visibility ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	end
end

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		self.sinceLastUpdate = 0
	end
end

local function SwitchSpec()
	if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
		TRB.Functions.Bar:QueueRenderTransition("switchSpec", 0.8)
	elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
		TRB.Functions.Bar:HideResourceBar(true)
	end
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	
	TRB.Data.character.currentShapeshiftFormId = 0
	TRB.Data.character.currentShapeshiftForm = "humanoid"
	if TRB.Data.character.specId == 1 then
		specCache.druid_balance.talents:GetTalents()
		FillSpellData_Balance()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.druid_balance)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Unified
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.druid_balance.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#wrath"] = spells.wrath.icon
		lookup["#starsurge"] = spells.starsurge.icon
		lookup["#starfall"] = spells.starfall.icon
		lookup["#celestialAlignment"] = spells.celestialAlignment.icon
		lookup["#icoe"] = spells.incarnationChosenOfElune.icon
		lookup["#coe"] = spells.incarnationChosenOfElune.icon
		lookup["#incarnation"] = spells.incarnationChosenOfElune.icon
		lookup["#incarnationChosenOfElune"] = spells.incarnationChosenOfElune.icon
		lookup["#solar"] = spells.eclipseSolar.icon
		lookup["#eclipseSolar"] = spells.eclipseSolar.icon
		lookup["#solarEclipse"] = spells.eclipseSolar.icon
		lookup["#lunar"] = spells.eclipseLunar.icon
		lookup["#eclipseLunar"] = spells.eclipseLunar.icon
		lookup["#lunarEclipse"] = spells.eclipseLunar.icon
		lookup["#soulOfTheForest"] = spells.soulOfTheForest.icon
		lookup["#stellarFlare"] = spells.stellarFlare.icon
		lookup["#newMoon"] = spells.newMoon.icon
		lookup["#halfMoon"] = spells.halfMoon.icon
		lookup["#fullMoon"] = spells.fullMoon.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.druid_balance.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "druid_balance" then
			TRB.Data.barConstructedForSpec = "druid_balance"
			ConstructResourceBar(specCache.druid_balance.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.druid_feral.talents:GetTalents()
		FillSpellData_Feral()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.druid_feral)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Unified
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.druid_feral.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#apexPredatorsCraving"] = spells.apexPredatorsCraving.icon
		lookup["#berserk"] = spells.berserk.icon
		lookup["#brutalSlash"] = spells.brutalSlash.icon
		lookup["#clearcasting"] = spells.clearcasting.icon
		lookup["#feralFrenzy"] = spells.feralFrenzy.icon
		lookup["#ferociousBite"] = spells.ferociousBiteMinimum.icon
		lookup["#incarnation"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#incarnationAvatarOfAshamane"] = spells.incarnationAvatarOfAshamane.icon
		lookup["#lunarInspiration"] = spells.lunarInspiration.icon
		lookup["#maim"] = spells.maim.icon
		lookup["#moonfire"] = spells.moonfire.icon
		lookup["#primalWrath"] = spells.primalWrath.icon
		lookup["#rake"] = spells.rake.icon
		lookup["#ravage"] = spells.ravageMinimum.icon
		lookup["#rip"] = spells.rip.icon
		lookup["#shred"] = spells.shred.icon
		lookup["#swipe"] = spells.swipe.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.druid_feral.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "druid_feral" then
			TRB.Data.barConstructedForSpec = "druid_feral"
			ConstructResourceBar(specCache.druid_feral.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.druid_guardian.talents:GetTalents()
		FillSpellData_Guardian()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.druid_guardian)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Unified
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.druid_guardian)

		local lookup = TRB.Data.lookup or {}
		lookup["#berserk"] = spells.berserk.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.druid_guardian.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "druid_guardian" then
			TRB.Data.barConstructedForSpec = "druid_guardian"
			ConstructResourceBar(specCache.druid_guardian.settings)
		end
	elseif TRB.Data.character.specId == 4 then
		specCache.druid_restoration.talents:GetTalents()
		FillSpellData_Restoration()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.druid_restoration)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Unified
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.druid_restoration)

		local lookup = TRB.Data.lookup or {}
		lookup["#efflorescence"] = spells.efflorescence.icon
		lookup["#incarnation"] = spells.incarnationTreeOfLife.icon
		lookup["#clearcasting"] = spells.clearcasting.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Set talents before EventRegistration since CheckCharacter uses it
		talents = specCache.druid_restoration.talents

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "druid_restoration" then
			TRB.Data.barConstructedForSpec = "druid_restoration"
			ConstructResourceBar(specCache.druid_restoration.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
			
		-- Destroy existing bar groups before creating new ones
		TRB.Functions.Bar:DestroyBarGroups()
		
		-- Create bar groups for Restoration using new OOP system
		TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(TRB.Data.character.specId)
	end
	
	TRB.Functions.Class:EventRegistration()

	C_Timer.After(0, function()
		C_Timer.After(0.05, function()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Data.barConstructedForSpec ~= nil then
				TRB.Functions.Character:ResetCaches()
				-- Ensure health values are populated so the health bar displays immediately
				TRB.Functions.Character:UpdateHealthValues()
				TRB.Functions.Class:TriggerResourceBarUpdates()
				UpdateShapeshiftForm()
			end
		end)
		
		C_Timer.After(0.25, function()
			DruidPowerEvent(nil, "UNIT_POWER_UPDATE")
			DruidPowerEvent(nil, "UNIT_MAXPOWER", "COMBO_POINTS")
			DruidPowerEvent(nil, "UNIT_MAXPOWER", "ENERGY")
			DruidPowerEvent(nil, "UNIT_MAXPOWER", "RAGE")
			DruidPowerEvent(nil, "UNIT_MAXPOWER", "MANA")
			DruidPowerEvent(nil, "UNIT_MAXPOWER", "LUNAR_POWER")
			TRB.Functions.BarText:CreateBarTextFrames(TRB.Data.character.classId, TRB.Data.character.specId)
		end)
	end)
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
eventFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end
	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end
	
	if TRB.Data.character.classId == 11 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Druid.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.balance == nil or
						TwintopInsanityBarSettings.druid.balance.displayText == nil then
						settings.druid.balance.displayText.barText = TRB.Options.Druid.BalanceLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.feral == nil or
						TwintopInsanityBarSettings.druid.feral.displayText == nil then
						settings.druid.feral.displayText.barText = TRB.Options.Druid.FeralLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.guardian == nil or
						TwintopInsanityBarSettings.druid.guardian.displayText == nil then
						settings.druid.guardian.displayText.barText = TRB.Options.Druid.GuardianLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.druid == nil or
						TwintopInsanityBarSettings.druid.restoration == nil or
						TwintopInsanityBarSettings.druid.restoration.displayText == nil then
						settings.druid.restoration.displayText.barText = TRB.Options.Druid.RestorationLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.druid ~= true then
						TRB.Data.settings.druid.balance.displayText.barText = TRB.Options.Druid.BalanceLoadDefaultBarTextSettings()
						TRB.Data.settings.druid.feral.displayText.barText = TRB.Options.Druid.FeralLoadDefaultBarTextSettings()
						TRB.Data.settings.druid.guardian.displayText.barText = TRB.Options.Druid.GuardianLoadDefaultBarTextSettings()
						TRB.Data.settings.druid.restoration.displayText.barText = TRB.Options.Druid.RestorationLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.druid = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Druid"])
					end
				else
					local settings = TRB.Options.Druid.LoadDefaultSettings(true)
					TRB.Data.settings = settings
				end
				FillSpecializationCache()

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

		if TRB.Details.addonData.loaded and TRB.Data.character.specId > 0 then
			if not TRB.Details.addonData.optionsPanelStarted then
				TRB.Details.addonData.optionsPanelStarted = true				
				TRB.Data.character.currentShapeshiftFormId = 0
				TRB.Data.character.currentShapeshiftForm = "humanoid"
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.settings.core = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["GlobalOptions"], TRB.Data.settings.core)
						TRB.Data.settings.druid.balance = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidBalanceFull"], TRB.Data.settings.druid.balance)
						TRB.Data.settings.druid.feral = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidFeralFull"], TRB.Data.settings.druid.feral)
						TRB.Data.settings.druid.guardian = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidGuardianFull"], TRB.Data.settings.druid.guardian)
						TRB.Data.settings.druid.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DruidRestorationFull"], TRB.Data.settings.druid.restoration)
						
						FillSpellData_Balance()
						FillSpellData_Feral()
						FillSpellData_Guardian()
						FillSpellData_Restoration()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Druid.ConstructOptionsPanel(specCache)

						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end

						TRB.Functions.Class:EventRegistration()
						TRB.Functions.News:Init()
						TRB.Details.addonData.optionsPanelFinished = true
					end)
				end)
			end

			if TRB.Details.addonData.optionsPanelFinished and (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED") then
				if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
					TRB.Functions.Bar:QueueRenderTransition("eventPreSwitch", 0.8)
				elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
					TRB.Functions.Bar:HideResourceBar(true)
				end
				C_Timer.After(0, function()
					C_Timer.After(0.1, function()
						SwitchSpec()
					end)
				end)
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	local specId = GetSpecialization()
	if specId ~= TRB.Data.character.specId then
		SwitchSpec()
	end
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "druid"

	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Track all resource types simultaneously for cross-form bar text variables
	TRB.Data.character.maxEnergy = UnitPowerMax("player", Enum.PowerType.Energy, true)
	TRB.Data.character.maxRage = UnitPowerMax("player", Enum.PowerType.Rage, true)
	TRB.Data.character.maxMana = UnitPowerMax("player", Enum.PowerType.Mana, true)
	TRB.Data.character.maxAstralPower = UnitPowerMax("player", Enum.PowerType.LunarPower, true)
	TRB.Data.character.maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)

	local function SetupSharedSettingsForSpec()
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		if sharedSettings ~= nil and barGroups then
			if barGroups.primary then
				TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
			end
			
			-- Configure secondary bar for combo points (used when in Cat form)
			-- Check if form switching is enabled for this spec
			local specSettings = TRB.Data.settings.druid[TRB.Data.character.specName]
			local enableFormSwitching = specSettings == nil or specSettings.displayBar == nil or specSettings.displayBar.enableFormSwitching ~= false
			
			-- Only configure combo points for Feral, or for other specs when form switching is enabled
			if barGroups.secondary and (TRB.Data.character.specId == 2 or enableFormSwitching) then
				-- Clear cached node count if combo point max changed, so the new value is used
				if TRB.Data.character.maxResource2 ~= TRB.Data.character.maxComboPoints then
					barGroups.secondary.lastRebuildNodeCount = nil
				end
				TRB.Data.character.maxResource2 = TRB.Data.character.maxComboPoints
				-- Use Feral settings for combo point configuration
				local feralSettings = TRB.Data.specCache.druid_feral.settings

				if feralSettings ~= nil and feralSettings.comboPoints ~= nil then
					-- Get effective width (may be CDM-matched) from barGroups or fall back to feral settings
					local effectiveWidth = (barGroups and barGroups.effectiveWidth) or feralSettings.bar.width
					
					barGroups.secondary:SetMaxNodes(TRB.Data.character.maxComboPoints)
					barGroups.secondary:SetNodeCount(TRB.Data.character.maxComboPoints)
					barGroups.secondary:SetLayout(feralSettings.comboPoints.spacing, TRB.Functions.Bar:GetMatchWidth(feralSettings.comboPoints), "HORIZONTAL")
					barGroups.secondary:ApplyLayout(
						effectiveWidth,
						feralSettings.comboPoints.width,
						feralSettings.comboPoints.height,
						feralSettings.comboPoints.border
					)
					-- Apply textures and colors to all nodes
					local frameLevels = TRB.Data.constants.frameLevels
					for i = 1, TRB.Data.character.maxComboPoints do
						local node = barGroups.secondary:GetNode(i)
						if node then
							node:SetTextures(
								feralSettings.textures.comboPointsBar,
								feralSettings.textures.comboPointsBorder,
								feralSettings.textures.comboPointsBackground
							)
							node:SetMinMax(0, 1)
							node:SetBorderColor(feralSettings.colors.comboPoints.border.color)
							node:SetBackgroundColorFromString(feralSettings.colors.comboPoints.background.color)
							node:SetColor(feralSettings.colors.comboPoints.base.color)
							node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
						end
					end
				end
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "balance"
		TRB.Data.character.compositeKey = "druid_balance"
		TRB.Data.character.maxResource = TRB.Data.character.maxAstralPower
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.LunarPower, false)
		TRB.Data.character.maxResource2 = TRB.Data.character.maxComboPoints
		pcall(GetCurrentMoonSpell)

		SetupSharedSettingsForSpec()
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		TRB.Data.character.specName = "feral"
		TRB.Data.character.compositeKey = "druid_feral"
		TRB.Data.character.maxResource = TRB.Data.character.maxEnergy
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)
		TRB.Data.character.maxResource2 = TRB.Data.character.maxComboPoints
		
		SetupSharedSettingsForSpec()
		
		if talents:IsTalentActive(spells.circleOfLifeAndDeath) then
			TRB.Data.character.pandemicModifier = spells.circleOfLifeAndDeath.attributes.modifier
		end
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "guardian"
		TRB.Data.character.compositeKey = "druid_guardian"
		TRB.Data.character.maxResource = TRB.Data.character.maxRage
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Rage, false)
		TRB.Data.character.maxResource2 = TRB.Data.character.maxComboPoints
		
		SetupSharedSettingsForSpec()
	elseif TRB.Data.character.specId == 4 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		TRB.Data.character.specName = "restoration"
		TRB.Data.character.compositeKey = "druid_restoration"
		TRB.Data.character.maxResource = TRB.Data.character.maxMana
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		TRB.Data.character.maxResource2 = TRB.Data.character.maxComboPoints

		SetupSharedSettingsForSpec()
	end
end

function TRB.Functions.Class:EventRegistration()
	local primaryResourceToken
	-- For Druids, we need to track ALL power types simultaneously for form-based switching
	-- The actual displayed resource will be determined by current form in UpdateResourceBar
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.druid.balance == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.LunarPower -- Primary spec resource
		TRB.Data.resourceFactor = ASTRAL_POWER_RESOURCE_FACTOR
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
		primaryResourceToken = "LUNAR_POWER"
		-- Track all resources for form-based switching
		TRB.Data.resourceEnergy = Enum.PowerType.Energy
		TRB.Data.resourceRage = Enum.PowerType.Rage
		TRB.Data.resourceMana = Enum.PowerType.Mana
		TRB.Data.resourceComboPoints = Enum.PowerType.ComboPoints
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.druid.feral == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Energy -- Primary spec resource
		TRB.Data.resourceFactor = ENERGY_RESOURCE_FACTOR
		TRB.Data.resource2 = Enum.PowerType.ComboPoints
		TRB.Data.resource2Factor = 1
		primaryResourceToken = "ENERGY"
		-- Track all resources for form-based switching
		TRB.Data.resourceRage = Enum.PowerType.Rage
		TRB.Data.resourceMana = Enum.PowerType.Mana
		TRB.Data.resourceAstralPower = Enum.PowerType.LunarPower
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.druid.guardian == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Rage -- Primary spec resource
		TRB.Data.resourceFactor = RAGE_RESOURCE_FACTOR
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
		primaryResourceToken = "RAGE"
		-- Track all resources for form-based switching
		TRB.Data.resourceEnergy = Enum.PowerType.Energy
		TRB.Data.resourceMana = Enum.PowerType.Mana
		TRB.Data.resourceAstralPower = Enum.PowerType.LunarPower
		TRB.Data.resourceComboPoints = Enum.PowerType.ComboPoints
	elseif TRB.Data.character.specId == 4 and TRB.Data.settings.core.enabled.druid.restoration then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana -- Primary spec resource
		TRB.Data.resourceFactor = MANA_RESOURCE_FACTOR
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
		primaryResourceToken = "MANA"
		-- Track all resources for form-based switching
		TRB.Data.resourceEnergy = Enum.PowerType.Energy
		TRB.Data.resourceRage = Enum.PowerType.Rage
		TRB.Data.resourceAstralPower = Enum.PowerType.LunarPower
		TRB.Data.resourceComboPoints = Enum.PowerType.ComboPoints
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
	TRB.Data.resourceToken = primaryResourceToken
	
	-- Override resource tracking for Druids to track ALL power types
	-- This allows form-based resource switching and cross-form bar text variables
	if TRB.Data.specSupported then
		druidPowerFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
		druidPowerFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
		druidPowerFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
		druidPowerFrame:SetScript("OnEvent", DruidPowerEvent)
	end
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 or TRB.Data.character.specId == 4 then
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.compositeKey] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		end

		if sharedSettings ~= nil then
			local affectingCombat = TRB.Data.character.inCombat
			local inVehicle = UnitInVehicle("player")
			local forceHideAll = not TRB.Data.specSupported or force or (TRB.Data.character.advancedFlight and not sharedSettings.displayBar.dragonriding)

			-- Determine primary bar visibility independently
			local showPrimary = false
			if not forceHideAll then
				if sharedSettings.displayBar.primary.visibility == "always" then
					showPrimary = true
				elseif sharedSettings.displayBar.primary.visibility == "combat" then
					showPrimary = affectingCombat or inVehicle
				end
				-- "never" means showPrimary stays false
			end

			-- Determine secondary bar visibility independently
			-- Combo points should show whenever the energy bar is being shown (Feral spec or Cat form)
			-- and should respect their visibility setting
			local showSecondary = false
			local currentForm = TRB.Data.character.currentShapeshiftForm or "humanoid"
			local displaySpecId = GetFormSpecForSettings(TRB.Data.character.specId, currentForm)
			
			-- Show combo points when displaySpecId is Feral (energy bar is shown)
			if not forceHideAll and displaySpecId == 2 then
				-- Use Feral's secondary bar settings for visibility
				local secondarySettings = TRB.Data.specCache.druid_feral and TRB.Data.specCache.druid_feral.settings or sharedSettings
				
				if secondarySettings ~= nil and secondarySettings.displayBar ~= nil then
					if secondarySettings.displayBar.secondary.visibility == "always" then
						showSecondary = true
					elseif secondarySettings.displayBar.secondary.visibility == "combat" then
						showSecondary = affectingCombat or inVehicle
					end
					-- "never" means showSecondary stays false
				end
			end

			-- Determine health bar visibility independently
			local showHealth = false
			if not forceHideAll then
				if sharedSettings.displayBar.health.visibility == "always" then
					showHealth = true
				elseif sharedSettings.displayBar.health.visibility == "combat" then
					showHealth = affectingCombat or inVehicle
				end
				-- "never" means showHealth stays false
			end

			-- Determine mana bar visibility independently (Balance only)
			-- Show mana bar when displaySpecId is Balance (1), not just when in Moonkin form
			-- This ensures mana bar persists when form switching is disabled
			local showMana = false
			if TRB.Data.character.specId == 1 and displaySpecId == 1 and not forceHideAll and sharedSettings.displayBar.mana ~= nil then
				if sharedSettings.displayBar.mana.visibility == "always" then
					showMana = true
				elseif sharedSettings.displayBar.mana.visibility == "combat" then
					showMana = affectingCombat or inVehicle
				end
				-- "never" means showMana stays false
			end

			-- Apply primary bar visibility
			if barGroups and barGroups.primary then
				if showPrimary then
					barGroups.primary:Show()
				else
					barGroups.primary:Hide()
				end
			end

			-- Apply secondary bar visibility
			if barGroups and barGroups.secondary then
				if showSecondary then
					barGroups.secondary:Show()
					barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
				else
					barGroups.secondary:Hide()
				end
			end

			-- Apply health bar visibility
			if barGroups and barGroups.health then
				if showHealth then
					barGroups.health:Show()
					barGroups.health:ShowNodes(1)
				else
					barGroups.health:Hide()
				end
			end

			-- Apply mana bar visibility (Balance only)
			if barGroups and barGroups.mana then
				if showMana then
					barGroups.mana:Show()
					barGroups.mana:ShowNodes(1)
				else
					barGroups.mana:Hide()
				end
			end

			-- Track if any bar is showing
			snapshotData.attributes.isTracking = showPrimary or showSecondary or showHealth or showMana
			if snapshotData.attributes.isTracking then
				TRB.Functions.BarText:Show(sharedSettings)
			else
				TRB.Functions.BarText:Hide(sharedSettings)
			end
		else
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.secondary then
				barGroups.secondary:Hide()
			end
			if barGroups and barGroups.health then
				barGroups.health:Hide()
			end
			if barGroups and barGroups.mana then
				barGroups.mana:Hide()
			end
			TRB.Functions.BarText:Hide(sharedSettings)
			snapshotData.attributes.isTracking = false
		end
	else
		if barGroups and barGroups.primary then
			barGroups.primary:Hide()
		end
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
		if barGroups and barGroups.health then
			barGroups.health:Hide()
		end
		if barGroups and barGroups.mana then
			barGroups.mana:Hide()
		end
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end

	-- Health variables are valid for all specs
	if var == "$health" or var == "$healthMax" or var == "$healthPercent" then
		valid = true
		return valid
	end

	local spells
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.BalanceSpells]]
		settings = TRB.Data.settings.druid.balance
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
		settings = TRB.Data.settings.druid.feral
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
		settings = TRB.Data.settings.druid.guardian
	elseif TRB.Data.character.specId == 4 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
		settings = TRB.Data.settings.druid.restoration
	else
		return false
	end
	
	if var == "$mana" or var == "$manaMax" or var == "$manaPercent" then
		valid = true
	elseif var == "$resource" or var == "$astralPower" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$astralPowerMax" then
		valid = true
	elseif var == "$resource" or var == "$energy" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$energyMax" then
		valid = true
	elseif var == "$comboPoints" then
		valid = true
	elseif var == "$comboPointsMax" then
		valid = true
	elseif var == "$resource" or var == "$rage" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$rageMax" then
		valid = true
	end

	if TRB.Data.character.specId == 1 then -- Balance
		if var == "$eclipse" then
			if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
				valid = true
			end
		elseif var == "$solar" or var == "$eclipseSolar" or var == "$solarEclipse" then
			if snapshots[spells.eclipseSolar.id].buff.isActive then
				valid = true
			end
		elseif var == "$lunar" or var == "$eclipseLunar" or var == "$lunarEclipse" then
			if snapshots[spells.eclipseLunar.id].buff.isActive then
				valid = true
			end
		elseif var == "$celestialAlignment" then
			if snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
				valid = true
			end
		elseif var == "$eclipseTime" then
			if snapshots[spells.eclipseSolar.id].buff.isActive or snapshots[spells.eclipseLunar.id].buff.isActive or snapshots[spells.celestialAlignment.id].buff.isActive or snapshots[spells.incarnationChosenOfElune.id].buff.isActive then
				valid = true
			end
		elseif var == "$starsurgeUsable" then
			if spells.starsurge:IsUsable() or spells.starsurge:IsFree() then
				valid = true
			end
		elseif var == "$starfallUsable" then
			if spells.starfall:IsUsable() or spells.starfall:IsFree() then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 2 then -- Feral
		if var == "$berserkTime" or var == "$incarnationTime" then
			if GetBerserkRemainingTime() > 0 then
				valid = true
			end
		elseif var == "$incarnationTicks" then
			if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				valid = true
			end
		elseif var == "$incarnationTickTime" then
			if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				valid = true
			end
		elseif var == "$incarnationNextCp" then
			if snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive then
				valid = true
			end
		elseif var == "$inStealth" then
			if IsStealthed() then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then -- Guardian
		if var == "$berserkTime" or var == "$incarnationTime" then
			if snapshotData.snapshots[spells.berserk.id].buff.isActive or snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 4 then --Restoration
		if var == "$resourcePercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$efflorescenceTime" then
			if snapshots[spells.efflorescence.id].buff.isActive then
				valid = true
			end
		elseif var == "$incarnationTime" then
			if snapshots[spells.incarnationTreeOfLife.id].buff.isActive  then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		end
	else
		valid = false
	end

	return valid
end

---Gets the Frame for the requested bar text variable, if the frame is currently enabled, and if it is visible.
---@param relativeToFrame string
---@return Frame? # Relative to Frame
---@return boolean # Is Enabled?
---@return boolean # Is Visible?
function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if not (barGroups and barGroups.primary) then
		return nil, true, false
	end

	local normalizedRelativeFrame = string.gsub(relativeToFrame or "", "_", "")
	local currentForm = TRB.Data.character.currentShapeshiftForm or "humanoid"
	local displaySpecId = GetFormSpecForSettings(TRB.Data.character.specId, currentForm)
	
	-- Form-based bar aliases - map to primary bar when displaying matching spec
	if normalizedRelativeFrame == "EnergyBar" then
		-- Energy bar is shown when displaySpecId is Feral (2)
		if displaySpecId == 2 then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
				return primaryNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end
	
	if normalizedRelativeFrame == "RageBar" then
		-- Rage bar is shown when displaySpecId is Guardian (3)
		if displaySpecId == 3 then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
				return primaryNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end
	
	if normalizedRelativeFrame == "AstralPowerBar" then
		-- Astral Power bar is shown when displaySpecId is Balance (1)
		if displaySpecId == 1 then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
				return primaryNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end
	
	-- Standard "Resource" or "ResourceBar" always returns primary bar
	if normalizedRelativeFrame == "Resource" or normalizedRelativeFrame == "ResourceBar" then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
			return primaryNode:GetResourceFrame(), true, isVisible
		end
		return nil, true, false
	end

	if normalizedRelativeFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	if normalizedRelativeFrame == "ManaBar" then
		-- Mana bar is shown when displaySpecId is Restoration (4) or Balance (1) with mana bar enabled
		if displaySpecId == 4 then
			-- Restoration uses primary bar for mana
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
				return primaryNode:GetResourceFrame(), true, isVisible
			end
		elseif displaySpecId == 1 and barGroups.mana then
			-- Balance uses separate mana bar (when in moonkin form)
			local manaNode = barGroups.mana:GetNode(1)
			if manaNode then
				local isVisible = barGroups.mana.isVisible and manaNode.isVisible
				return manaNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		-- Combo points are shown when displaySpecId is Feral (2)
		if comboPoint and barGroups.secondary and displaySpecId == 2 then
			local cpNode = barGroups.secondary:GetNode(comboPoint)
			if cpNode then
				local isVisible = barGroups.secondary.isVisible and cpNode.isVisible
				return cpNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Functions.Bar and TRB.Functions.Bar.IsRenderTransitionActive and TRB.Functions.Bar:IsRenderTransitionActive() then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	if not TRB.Data.specSupported or talents == nil then
		return
	end
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 and TRB.Data.character.specId ~= 4 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end