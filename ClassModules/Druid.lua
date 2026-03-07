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
local lookupChanged = TRB.Functions.BarText.LookupChanged

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

	-- Form change affects which bars are visible (e.g., combo points only in cat form),
	-- so mark visibility dirty so HideResourceBar will re-evaluate.
	TRB.Functions.BarVisibility:MarkDirty()

	-- Trigger resource bar update when form changes
	if TRB.Functions.Class and TRB.Functions.Class.CheckCharacter then
		TRB.Functions.Class:CheckCharacter()
	end
	
	if TRB.Data.snapshotData ~= nil and TRB.Data.snapshotData.snapshots ~= nil then
		TRB.Functions.Character:ResetColorCaches()

		-- Recreate bar text frames BEFORE triggering updates. Form changes alter which
		-- bar aliases (AstralPowerBar, EnergyBar, etc.) resolve to an actual frame, so
		-- CreateBarTextFrames must re-parent text frames for the new form first. It also
		-- clears font strings to "", so the lookup memoization must be invalidated
		-- afterwards to ensure UpdateResourceBarText repopulates them instead of hitting
		-- the OOC idle-skip (lookupDirty=false, not inCombat, no active timers).
		TRB.Data.cache.values.frame = {}
		TRB.Functions.BarText:CreateBarTextFrames(TRB.Data.character.classId, TRB.Data.character.specId)
		TRB.Functions.BarText:InvalidateLookupMemoization()

		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
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
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetFrame())
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

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core resource ($resource, $astralPower, $casting, $resourceMax, $astralPowerMax, $starsurgeUsable, $starfallUsable)
	if not activeVars or activeVars["$resource"] or activeVars["$astralPower"] or activeVars["$casting"]
		or activeVars["$resourceMax"] or activeVars["$astralPowerMax"]
		or activeVars["$starsurgeUsable"] or activeVars["$starfallUsable"] then

		local normalizedAstralPower = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
		local currentAstralPowerColor = sharedSettings.colors.text.current.color
		local castingAstralPowerColor = sharedSettings.colors.text.casting.color

		local _starsurgeUsable = spells.starsurge:IsUsable() or spells.starsurge:IsFree()
		local _starfallUsable = spells.starfall:IsUsable() or spells.starfall:IsFree()

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled and (_starsurgeUsable or _starfallUsable) then
				currentAstralPowerColor = sharedSettings.colors.text.overThreshold.color
				castingAstralPowerColor = sharedSettings.colors.text.overThreshold.color
			end
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
		local _currentAstralPower = normalizedAstralPower

		lookupLogic["$resource"] = normalizedAstralPower
		lookupLogic["$astralPower"] = normalizedAstralPower
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookupLogic["$astralPowerMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		lookupLogic["$starsurgeUsable"] = _starsurgeUsable
		lookupLogic["$starfallUsable"] = _starfallUsable

		-- OVERCAP: $astralPower/$resource + $casting
		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$astralPower", resourceFormatted, currentAstralPowerColor)
		local castingChanged = lookupChanged(prevState, "$casting", snapshotData.casting.resourceFinal, castingAstralPowerColor)
		if resourceChanged or castingChanged then
			local currentAstralPower
			local castingAstralPower
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, currentAstralPowerColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentAstralPower = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingAstralPower = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
			else
				currentAstralPower = string.format("|c%s%s|r", currentAstralPowerColor, resourceFormatted)
				castingAstralPower = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentAstralPower
			lookup["$astralPower"] = currentAstralPower
			lookup["$casting"] = castingAstralPower
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookup["$astralPowerMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookup["$starsurgeUsable"] = ""
		lookup["$starfallUsable"] = ""
	end

	-- Block B: Eclipse ($eclipseTime, $eclipse, $lunar, $solar, $celestialAlignment, #eclipse, #moon)
	if not activeVars or activeVars["$eclipseTime"] or activeVars["$eclipse"]
		or activeVars["$lunar"] or activeVars["$lunarEclipse"] or activeVars["$eclipseLunar"]
		or activeVars["$solar"] or activeVars["$solarEclipse"] or activeVars["$eclipseSolar"]
		or activeVars["$celestialAlignment"] or activeVars["#eclipse"] or activeVars["#moon"] then

		local currentMoonIcon = spells.newMoon.icon
		local _eclispeTime, eclipseIcon, eclipseSpellId = GetEclipseRemainingTime()

		lookupLogic["$eclipseTime"] = _eclispeTime
		lookupLogic["$eclipse"] = _eclispeTime > 0
		lookupLogic["$lunar"] = false
		lookupLogic["$lunarEclipse"] = false
		lookupLogic["$eclipseLunar"] = false
		lookupLogic["$solar"] = false
		lookupLogic["$solarEclipse"] = false
		lookupLogic["$eclipseSolar"] = false
		lookupLogic["$celestialAlignment"] = false

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

		lookup["#moon"] = currentMoonIcon
		lookup["#eclipse"] = eclipseIcon or spells.celestialAlignment.icon
		lookup["$eclipse"] = ""
		lookup["$lunar"] = ""
		lookup["$lunarEclipse"] = ""
		lookup["$eclipseLunar"] = ""
		lookup["$solar"] = ""
		lookup["$solarEclipse"] = ""
		lookup["$eclipseSolar"] = ""
		lookup["$celestialAlignment"] = ""

		if lookupChanged(prevState, "$eclipseTime", _eclispeTime) then
			lookup["$eclipseTime"] = TRB.Functions.BarText:TimerPrecision(_eclispeTime)
		end
	end

	-- Block C: Mana ($mana, $manaMax, $manaPercent)
	if not activeVars or activeVars["$mana"] or activeVars["$manaMax"] or activeVars["$manaPercent"] then
		local currentManaColor = (sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color) or sharedSettings.colors.text.current.color
		local normalizedMana = UnitPower("player", Enum.PowerType.Mana)
		local normalizedManaMax = UnitPowerMax("player", Enum.PowerType.Mana)
		local manaPrecision = sharedSettings.precision.mana or 1
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
		local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$manaMax"] = normalizedManaMax
		lookupLogic["$manaPercent"] = _manaPercent

		local manaFormatted = TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana)
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			lookup["$mana"] = string.format("|c%s%s|r", currentManaColor, manaFormatted)
		end
		local manaMaxFormatted = TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedManaMax)
		if lookupChanged(prevState, "$manaMax", manaMaxFormatted, currentManaColor) then
			lookup["$manaMax"] = string.format("|c%s%s|r", currentManaColor, manaMaxFormatted)
		end
		local manaPercentFormatted = string.format("%." .. manaPrecision .. "f", manaPercentRaw)
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			lookup["$manaPercent"] = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Feral()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.FeralSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.feral
	local sharedSettings = TRB.Data.specCache["druid_feral"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core energy ($energy, $resource, $casting, $energyMax, $resourceMax, $inStealth)
	if not activeVars or activeVars["$energy"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$energyMax"] or activeVars["$resourceMax"] or activeVars["$inStealth"] then

		local currentEnergyColor = sharedSettings.colors.text.current.color
		local castingEnergyColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.resource and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
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

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
		local isStealthed = IsStealthed()

		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookupLogic["$energy"] = snapshotData.attributes.resource
		lookupLogic["$inStealth"] = isStealthed

		local resourceFormatted = snapshotData.formatted.resource or ""
		local energyChanged = lookupChanged(prevState, "$energy", resourceFormatted, currentEnergyColor)
		local castingChanged = lookupChanged(prevState, "$casting", snapshotData.casting.resourceFinal, castingEnergyColor)
		if energyChanged or castingChanged then
			local currentEnergy
			local castingEnergy
			if not isStealthed and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentEnergy = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
			else
				currentEnergy = string.format("|c%s%s|r", currentEnergyColor, resourceFormatted)
				castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentEnergy
			lookup["$energy"] = currentEnergy
			lookup["$casting"] = castingEnergy
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookup["$energyMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookup["$inStealth"] = ""
	end

	-- Block B: Combo Points ($comboPoints, $comboPointsMax)
	if not activeVars or activeVars["$comboPoints"] or activeVars["$comboPointsMax"] then
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Berserk/Incarnation ($berserkTime, $incarnationTime, $incarnationTicks, $incarnationTickTime, $incarnationNextCp)
	if not activeVars or activeVars["$berserkTime"] or activeVars["$incarnationTime"]
		or activeVars["$incarnationTicks"] or activeVars["$incarnationTickTime"]
		or activeVars["$incarnationNextCp"] then
		local _berserkTime = GetBerserkRemainingTime()
		local _incarnationTicks = snapshotData.snapshots[spells.berserk.id].attributes.ticks
		local _incarnationTickTime = snapshotData.snapshots[spells.berserk.id].attributes.untilNextTick

		local incarnationNextCp = 0
		for x = 1, TRB.Data.character.maxResource2 do
			if snapshotData.attributes.resource2 < x then
				if incarnationNextCp == 0 and _incarnationTicks > 0 then
					incarnationNextCp = x
				end
			end
		end

		lookupLogic["$berserkTime"] = _berserkTime
		lookupLogic["$incarnationTime"] = _berserkTime
		lookupLogic["$incarnationTicks"] = _incarnationTicks
		lookupLogic["$incarnationTickTime"] = _incarnationTickTime
		lookupLogic["$incarnationNextCp"] = incarnationNextCp

		lookup["$incarnationTicks"] = _incarnationTicks
		lookup["$incarnationNextCp"] = incarnationNextCp

		if lookupChanged(prevState, "$berserkTime", _berserkTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_berserkTime)
			lookup["$berserkTime"] = f
			lookup["$incarnationTime"] = f
		end
		if lookupChanged(prevState, "$incarnationTickTime", _incarnationTickTime) then
			lookup["$incarnationTickTime"] = TRB.Functions.BarText:TimerPrecision(_incarnationTickTime)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Guardian()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.GuardianSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.druid.guardian
	local sharedSettings = TRB.Data.specCache["druid_guardian"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core rage ($rage, $resource, $rageMax, $resourceMax)
	if not activeVars or activeVars["$rage"] or activeVars["$resource"]
		or activeVars["$rageMax"] or activeVars["$resourceMax"] then

		local currentRageColor = TRB.Data.settings.druid.guardian.colors.text.current.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.resource and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentRageColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$rage"] = snapshotData.attributes.resource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookupLogic["$rageMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor

		local resourceFormatted = snapshotData.formatted.resource or ""
		if lookupChanged(prevState, "$rage", resourceFormatted, currentRageColor) then
			local currentRage
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentRage = textColorResult:WrapTextInColorCode(resourceFormatted)
			else
				currentRage = string.format("|c%s%s|r", currentRageColor, resourceFormatted)
			end
			lookup["$resource"] = currentRage
			lookup["$rage"] = currentRage
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
		lookup["$rageMax"] = TRB.Data.character.maxResource / TRB.Data.resourceFactor
	end

	-- Block B: Berserk ($berserkTime, $incarnationTime)
	if not activeVars or activeVars["$berserkTime"] or activeVars["$incarnationTime"] then
		local currentTime = GetTime()
		local berserkSnapshotBuff = snapshotData.snapshots[spells.berserk.id].buff

		if not berserkSnapshotBuff.isActive then
			berserkSnapshotBuff = snapshotData.snapshots[spells.incarnationGuardianOfUrsoc.id].buff
		end

		local _berserkTime = berserkSnapshotBuff:GetRemainingTime(currentTime)

		lookupLogic["$berserkTime"] = _berserkTime
		lookupLogic["$incarnationTime"] = _berserkTime

		if lookupChanged(prevState, "$berserkTime", _berserkTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_berserkTime)
			lookup["$berserkTime"] = f
			lookup["$incarnationTime"] = f
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Restoration()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Druid.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local sharedSettings = TRB.Data.specCache["druid_restoration"].settings

	-- Side-effect: must remain ungated
---@diagnostic disable-next-line: cast-local-type
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $manaMax, $resourceMax, $manaPercent, $resourcePercent, $casting)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then
		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = TRB.Data.settings.druid.restoration.colors.text.current.color
		local castingManaColor = TRB.Data.settings.druid.restoration.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = f
			lookup["$resource"] = f
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = f
			lookup["$resourceMax"] = f
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = f
			lookup["$resourcePercent"] = f
		end
	end

	-- Block B: Efflorescence ($efflorescenceTime)
	if not activeVars or activeVars["$efflorescenceTime"] then
		local currentTime = GetTime()
		local _efflorescenceTime = snapshots[spells.efflorescence.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$efflorescenceTime"] = _efflorescenceTime

		if lookupChanged(prevState, "$efflorescenceTime", _efflorescenceTime) then
			lookup["$efflorescenceTime"] = TRB.Functions.BarText:TimerPrecision(_efflorescenceTime)
		end
	end

	-- Block C: Incarnation ($incarnationTime)
	if not activeVars or activeVars["$incarnationTime"] then
		local currentTime = GetTime()
		local _incarnationTime = snapshots[spells.incarnationTreeOfLife.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$incarnationTime"] = _incarnationTime

		if lookupChanged(prevState, "$incarnationTime", _incarnationTime) then
			lookup["$incarnationTime"] = TRB.Functions.BarText:TimerPrecision(_incarnationTime)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

---Unified RefreshLookupData that populates ALL Druid resource variables regardless of active spec
---This enables cross-form bar text variables to work
local function RefreshLookupData_Unified()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
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
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: All primary resources + $resource/$resourceMax mapping
	if not activeVars or activeVars["$energy"] or activeVars["$energyMax"]
		or activeVars["$rage"] or activeVars["$rageMax"]
		or activeVars["$mana"] or activeVars["$manaMax"] or activeVars["$manaPercent"]
		or activeVars["$astralPower"] or activeVars["$astralPowerMax"]
		or activeVars["$resource"] or activeVars["$resourceMax"] then

		local energy = snapshotData.attributes.energy or 0
		local rage = snapshotData.attributes.rageModified or 0
		local mana = snapshotData.attributes.mana or 0
		local astralPower = snapshotData.attributes.astralPower or 0

		-- Resource color configuration
		local astralPowerColor = TRB.Data.settings.druid.balance.colors.text.current.color
		local energyColor = TRB.Data.settings.druid.feral.colors.text.current.color
		local rageColor = TRB.Data.settings.druid.guardian.colors.text.current.color
		local manaColor = TRB.Data.settings.druid.restoration.colors.text.current.color

		-- Mana color override
		local manaColorOverride = sharedSettings.colors.text and sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color
		manaColor = manaColorOverride or manaColor
		local manaPrecision = sharedSettings.precision.mana or 1
		local manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

		-- lookupLogic entries
		lookupLogic["$energy"] = energy
		lookupLogic["$energyMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR
		lookupLogic["$rage"] = rage
		lookupLogic["$rageMax"] = TRB.Data.character.maxRage / RAGE_RESOURCE_FACTOR
		lookupLogic["$mana"] = mana
		lookupLogic["$manaMax"] = TRB.Data.character.maxMana / MANA_RESOURCE_FACTOR
		lookupLogic["$manaPercent"] = manaPercent

		if specId == 1 then
			lookupLogic["$astralPower"] = astralPower
			lookupLogic["$astralPowerMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
		end

		-- FCS: Energy ($energy)
		if lookupChanged(prevState, "u$energy", energy, energyColor, true) then
			lookup["$energy"] = string.format("|c%s%s|r", energyColor, energy)
		end
		lookup["$energyMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR

		-- FCS: Rage ($rage)
		if lookupChanged(prevState, "u$rage", rage, rageColor, true) then
			lookup["$rage"] = string.format("|c%s%s|r", rageColor, rage)
		end
		lookup["$rageMax"] = TRB.Data.character.maxRage / RAGE_RESOURCE_FACTOR

		-- FCS: Mana ($mana, $manaMax, $manaPercent)
		if lookupChanged(prevState, "u$mana", mana, manaColor, true) then
			lookup["$mana"] = string.format("|c%s%s|r", manaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(mana))
		end
		if lookupChanged(prevState, "u$manaMax", TRB.Data.character.maxMana, manaColor, true) then
			lookup["$manaMax"] = string.format("|c%s%s|r", manaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxMana))
		end
		if lookupChanged(prevState, "u$manaPercent", manaPercent, manaColor, true) then
			lookup["$manaPercent"] = string.format("|c%s%." .. manaPrecision .. "f|r", manaColor, manaPercent)
		end

		-- FCS: Astral Power ($astralPower, $astralPowerMax) - Balance only
		if specId == 1 then
			if lookupChanged(prevState, "u$astralPower", astralPower, astralPowerColor, true) then
				lookup["$astralPower"] = string.format("|c%s%s|r", astralPowerColor, astralPower)
			end
			lookup["$astralPowerMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
		end

		-- Primary $resource and $resourceMax - mapped to current form's resource
		if currentForm == "cat" then
			lookup["$resource"] = lookup["$energy"]
			lookup["$resourceMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR
			lookupLogic["$resource"] = energy
			lookupLogic["$resourceMax"] = TRB.Data.character.maxEnergy / ENERGY_RESOURCE_FACTOR
		elseif currentForm == "bear" then
			lookup["$resource"] = lookup["$rage"]
			lookup["$resourceMax"] = TRB.Data.character.maxRage / RAGE_RESOURCE_FACTOR
			lookupLogic["$resource"] = rage
			lookupLogic["$resourceMax"] = TRB.Data.character.maxRage / RAGE_RESOURCE_FACTOR
		elseif currentForm == "moonkin" and specId == 1 then
			lookup["$resource"] = lookup["$astralPower"]
			lookup["$resourceMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
			lookupLogic["$resource"] = astralPower
			lookupLogic["$resourceMax"] = TRB.Data.character.maxAstralPower / ASTRAL_POWER_RESOURCE_FACTOR
		else
			-- Humanoid/other forms use mana
			lookup["$resource"] = lookup["$mana"]
			lookup["$resourceMax"] = TRB.Data.character.maxMana / MANA_RESOURCE_FACTOR
			lookupLogic["$resource"] = mana
			lookupLogic["$resourceMax"] = TRB.Data.character.maxMana / MANA_RESOURCE_FACTOR
		end
	end

	-- Block B: Combo Points ($comboPoints, $comboPointsMax)
	if not activeVars or activeVars["$comboPoints"] or activeVars["$comboPointsMax"] then
		local comboPoints = snapshotData.attributes.comboPoints or 0

		lookupLogic["$comboPoints"] = comboPoints
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxComboPoints

		lookup["$comboPoints"] = comboPoints
		lookup["$comboPointsMax"] = TRB.Data.character.maxComboPoints
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
	local isInEditMode = TRB.Functions.EditMode:IsInEditMode()

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
		local resourceFrame = primaryNode:GetFrame()
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
		-- Generic combo points rendering for non-native forms. Feral always shows CPs as its
		-- native secondary resource. Non-Feral specs show CPs when showComboPoints is enabled
		-- or when in cat form via form switching.
		local showCp = false
		local cpSettings = nil
		local activeSpecName = ({ [1] = "balance", [2] = "feral", [3] = "guardian", [4] = "restoration" })[activeSpecId]
		local activeSpecSettings = activeSpecName and classSettings[activeSpecName]
		if activeSpecSettings ~= nil and activeSpecSettings.displayBar ~= nil then
			if displaySpecId == 2 then
				-- Cat form (or Feral with form-switching off): CPs are native, always eligible
				showCp = activeSpecSettings.displayBar.secondary.visibility ~= "never"
				cpSettings = (activeSpecId == 2) and activeSpecSettings or (classSettings.feral or activeSpecSettings)
			elseif activeSpecId == 2 then
				-- Feral in non-cat form: checkbox defaults ON (nil → show)
				if activeSpecSettings.displayBar.showComboPoints ~= false then
					showCp = activeSpecSettings.displayBar.secondary.visibility ~= "never"
					cpSettings = activeSpecSettings
				end
			else
				-- Non-Feral in non-cat form: checkbox defaults OFF (nil → hide)
				if activeSpecSettings.displayBar.showComboPoints == true then
					showCp = activeSpecSettings.displayBar.secondary.visibility ~= "never"
					cpSettings = classSettings.feral or activeSpecSettings
				end
			end
		end

		if showCp and cpSettings then
			local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(cpSettings.colors.comboPoints.background.color, true)
			
			for x = 1, TRB.Data.character.maxComboPoints do
				local cpBorderColor = cpSettings.colors.comboPoints.border.color
				local cpColor = cpSettings.colors.comboPoints.base.color
				local cpBR = cpBackgroundRed
				local cpBG = cpBackgroundGreen
				local cpBB = cpBackgroundBlue

				if barGroups and barGroups.secondary then
					local cpNode = barGroups.secondary:GetNode(x)
					if cpNode then
						if (snapshotData.attributes.comboPoints or 0) >= x then
							TRB.Functions.Bar:SetBarNodeValue(formSpecCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
							if (cpSettings.comboPoints.sameColor and snapshotData.attributes.comboPoints == (TRB.Data.character.maxComboPoints - 1)) or (not cpSettings.comboPoints.sameColor and x == (TRB.Data.character.maxComboPoints - 1)) then
								cpColor = cpSettings.colors.comboPoints.penultimate.color
							elseif (cpSettings.comboPoints.sameColor and snapshotData.attributes.comboPoints == (TRB.Data.character.maxComboPoints)) or x == TRB.Data.character.maxComboPoints then
								cpColor = cpSettings.colors.comboPoints.final.color
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

		-- Combo points should not render: ensure secondary bar is hidden.
		-- This is a defensive safeguard: ConstructAnchoredBarGroup (called during
		-- ApplyBarGroupsLayout) unconditionally Show()s bar groups, and the dirty-
		-- flag visibility cache may not re-evaluate in time if the render transition
		-- consumes the hide. Explicitly hiding here on every frame guarantees the
		-- secondary bar stays invisible when visibility is "never" or showComboPoints
		-- is disabled.
		if barGroups and barGroups.secondary and not isInEditMode then
			barGroups.secondary:Hide()
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
					local nodeResourceFrame = primaryNode:GetFrame()

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
										local thresholdCurve = TRB.Functions.Color:BuildThresholdCurve(
											spell.primaryResourceTypeMod,
											baseCost,
											specCacheSettings.colors.threshold.under.color,
											specCacheSettings.colors.threshold.over.color
										)
										local iconCurve = TRB.Functions.Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
										frameLevel = isUsable and TRB.Data.constants.frameLevels.thresholdOver or TRB.Data.constants.frameLevels.thresholdUnder
										local curveApplied = TRB.Functions.Threshold:ApplyThresholdCurveColor(
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
										local thresholdCurve = TRB.Functions.Color:BuildThresholdCurve(
											spell.primaryResourceTypeMod,
											baseCost,
											specCacheSettings.colors.threshold.under.color,
											specCacheSettings.colors.threshold.over.color
										)
										local iconCurve = TRB.Functions.Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
										frameLevel = isUsable and TRB.Data.constants.frameLevels.thresholdOver or TRB.Data.constants.frameLevels.thresholdUnder
										local curveApplied = TRB.Functions.Threshold:ApplyThresholdCurveColor(
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
					local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(formSpecSettings, barBorderColor, formSpecSettings.colors.bar.borderOvercap.color)
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
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
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
					healthNode:SetBorderColor(specCacheSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specCacheSettings.colors.healthBar.background.color)
				end
				TRB.Functions.Bar:UpdateHealthBarOverlays(healthNode, snapshotData, specCacheSettings)
			elseif barGroups and barGroups.health and not isInEditMode then
				barGroups.health:Hide()
			end

			-- Mana bar update (Balance only, when primary bar is Astral Power — not when primary is already mana)
			if displaySpecId == 1 and specSettings.displayBar.mana ~= nil and specSettings.displayBar.mana.visibility ~= "never" then
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
			elseif barGroups and barGroups.mana and not isInEditMode then
				barGroups.mana:Hide()
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
				local barColorCurveResult = nil

				-- Use simple colors when in non-native form
				if displaySpecId ~= TRB.Data.character.specId then
					barColor = formSpecSettings.colors.bar.base.color
					barBorderColor = formSpecSettings.colors.bar.border.color
					ConstructPrimaryGeneric(maxPrimaryBarResource)
					primaryNode:SetBorderColor(barBorderColor)
				else
					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetFrame()

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
							---@type string?
							local thresholdColor = specCacheSettings.colors.threshold.over.color
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							local snapshot = snapshots[spell.id]

							if spell.attributes.isClearcasting and snapshots[spells.clearcasting.id].buff.applications ~= nil and snapshots[spells.clearcasting.id].buff.applications > 0 then
								if spell.id == spells.swipe.id then
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
										if apcActive then
											thresholdColor = specCacheSettings.colors.threshold.over.color
										elseif isUsable then
											-- Use ColorCurve to correctly evaluate max cost against secret Energy
											local baseCost = resourceAmount / spell.primaryResourceTypeMod
											local thresholdCurve = TRB.Functions.Color:BuildThresholdCurve(
												spell.primaryResourceTypeMod,
												baseCost,
												specCacheSettings.colors.threshold.under.color,
												specCacheSettings.colors.threshold.over.color
											)
											local iconCurve = TRB.Functions.Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
											frameLevel = TRB.Data.constants.frameLevels.thresholdOver
											local curveApplied = TRB.Functions.Threshold:ApplyThresholdCurveColor(
												spell, thresholds[thresholdId], thresholdCurve, displayResourceType, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
											)
											if curveApplied then
												thresholdColor = nil -- Skip normal color application
											else
												thresholdColor = specCacheSettings.colors.threshold.under.color
											end
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
										if apcActive then
											thresholdColor = specCacheSettings.colors.threshold.over.color
										elseif isUsable then
											-- Use ColorCurve to correctly evaluate max cost against secret Energy
											local baseCost = resourceAmount / spell.primaryResourceTypeMod
											local thresholdCurve = TRB.Functions.Color:BuildThresholdCurve(
												spell.primaryResourceTypeMod,
												baseCost,
												specCacheSettings.colors.threshold.under.color,
												specCacheSettings.colors.threshold.over.color
											)
											local iconCurve = TRB.Functions.Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
											frameLevel = TRB.Data.constants.frameLevels.thresholdOver
											local curveApplied = TRB.Functions.Threshold:ApplyThresholdCurveColor(
												spell, thresholds[thresholdId], thresholdCurve, displayResourceType, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
											)
											if curveApplied then
												thresholdColor = nil -- Skip normal color application
											else
												thresholdColor = specCacheSettings.colors.threshold.under.color
											end
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
									if isUsable then
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

						-- Use a ColorCurve to check the 50 Energy threshold for max bite color,
						-- since Energy is a secret value and IsUsable() triggers at 25 (base cost) not 50 (max cost)
						if specSettings.colors.bar.maxBite.enabled and snapshotData.attributes.resource2 == 5 then
							local maxBiteCost = spells.ferociousBiteMaximum:GetPrimaryResourceCost()
							local maxEnergy = TRB.Data.character.maxEnergy or 100
							local maxBitePercent = maxBiteCost / maxEnergy
							local maxBiteCurve = TRB.Functions.Color:GetStepColorCurve("feralMaxBite", barColor, specSettings.colors.bar.maxBite.color, maxBitePercent)
							barColorCurveResult = UnitPowerPercent("player", displayResourceType, true, maxBiteCurve)
						end

						if apcActive then
							if specSettings.colors.bar.apexPredator.enabled then
								barColor = specSettings.colors.bar.apexPredator.color
								barColorCurveResult = nil -- APC overrides the maxBite curve
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
						local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", displayResourceType, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
				end

				if barColorCurveResult ~= nil then
					primaryNode:SetColorCurve(barColorCurveResult)
					-- Invalidate the color cache so the next SetColor() call won't be skipped
					-- (SetColorCurve bypasses the cache by setting vertex color directly)
					TRB.Data.cache.colors.bar[primaryNode.name .. "_resource"] = nil
				else
					primaryNode:SetColor(barColor)
				end
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			-- Show native combo points (with Berserk tick tracking) when in Cat form or
			-- when displaySpecId is Feral (enableFormSwitching disabled). Other forms with
			-- form switching ON fall through to ConstructComboPointsGeneric for simplified rendering.
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
			else
				-- Non-Cat form: use generic combo points handler for showComboPoints
				local refreshTextFromComboPoints = ConstructComboPointsGeneric()
				refreshText = refreshText or refreshTextFromComboPoints
			end

			-- Health bar update
			if specSettings.displayBar.health.visibility ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specCacheSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specCacheSettings.colors.healthBar.background.color)
				end
				TRB.Functions.Bar:UpdateHealthBarOverlays(healthNode, snapshotData, specCacheSettings)
			elseif barGroups and barGroups.health and not isInEditMode then
				barGroups.health:Hide()
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
					local nodeResourceFrame = primaryNode:GetFrame()

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
						local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", displayResourceType, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
				end

				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				primaryNode:SetColor(barColor)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
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
					healthNode:SetBorderColor(specCacheSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specCacheSettings.colors.healthBar.background.color)
				end
				TRB.Functions.Bar:UpdateHealthBarOverlays(healthNode, snapshotData, specCacheSettings)
			elseif barGroups and barGroups.health and not isInEditMode then
				barGroups.health:Hide()
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
					local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(formSpecSettings, barBorderColor, formSpecSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", displayResourceType, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
	
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
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
					healthNode:SetBorderColor(specCacheSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specCacheSettings.colors.healthBar.background.color)
				end
				TRB.Functions.Bar:UpdateHealthBarOverlays(healthNode, snapshotData, specCacheSettings)
			elseif barGroups and barGroups.health and not isInEditMode then
				barGroups.health:Hide()
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
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
	TRB.Data.prevLookupState = {}
	TRB.Data.lookupDirty = true
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
			-- CreateBarTextFrames wipes all font text to "". If EndRenderTransition
			-- already ran (consuming lookupDirty), the OOC idle-skip in
			-- UpdateResourceBarText would prevent text from being repopulated.
			-- Invalidate memoization so the next periodic tick re-renders text.
			TRB.Functions.BarText:InvalidateLookupMemoization()
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

					-- Clear core barText defaults before merge to prevent per-index array duplication.
					-- Only clear if saved vars have entries; otherwise let defaults seed the list.
					if TwintopInsanityBarSettings.core
						and TwintopInsanityBarSettings.core.displayText
						and TwintopInsanityBarSettings.core.displayText.barText
						and #TwintopInsanityBarSettings.core.displayText.barText > 0 then
						settings.core.displayText.barText = {}
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
			
			-- Only configure combo points for Feral, or for other specs when form switching or showComboPoints is enabled
			local showComboPoints = specSettings ~= nil and specSettings.displayBar ~= nil and specSettings.displayBar.showComboPoints
			if barGroups.secondary and (TRB.Data.character.specId == 2 or enableFormSwitching or showComboPoints) then
				-- Clear cached node count if combo point max changed, so the new value is used
				if TRB.Data.character.maxResource2 ~= TRB.Data.character.maxComboPoints then
					barGroups.secondary.lastRebuildNodeCount = nil
				end
				TRB.Data.character.maxResource2 = TRB.Data.character.maxComboPoints
				-- Use Feral settings for combo point configuration
				local feralSettings = TRB.Data.specCache.druid_feral.settings

				if feralSettings ~= nil and feralSettings.comboPoints ~= nil
					and feralSettings.colors and feralSettings.colors.comboPoints then
					-- Get effective width for secondary bar, accounting for CDM width matching
					local effectiveWidth, cdmForced = TRB.Functions.Bar:GetEffectiveWidthForBarGroup(barGroups, feralSettings, "secondary")
					
					barGroups.secondary:SetMaxNodes(TRB.Data.character.maxComboPoints)
					barGroups.secondary:SetNodeCount(TRB.Data.character.maxComboPoints)
					barGroups.secondary:SetLayout(feralSettings.comboPoints.spacing, TRB.Functions.Bar:GetMatchWidth(feralSettings.comboPoints), "HORIZONTAL")
					if cdmForced then
						barGroups.secondary.fullWidth = true
					end
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
							node:SetFrameLevel(frameLevels.comboPoint)
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
	if not TRB.Functions.BarVisibility:IsDirty(force) then
		return
	end

	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 or TRB.Data.character.specId == 4 then
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.compositeKey] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		end

		-- Determine form-based display spec for secondary and mana bar routing
		local currentForm = TRB.Data.character.currentShapeshiftForm or "humanoid"
		local displaySpecId = GetFormSpecForSettings(TRB.Data.character.specId, currentForm)

		-- Secondary (Combo Points): In cat form (displaySpecId == 2), CPs are the native resource
		-- and always show. In non-cat forms, the showComboPoints checkbox controls visibility
		-- (defaults ON for Feral, OFF for non-Feral).
		local hasSecondary = false
		local secondaryVisSettings = nil
		if sharedSettings ~= nil and sharedSettings.displayBar ~= nil then
			if displaySpecId == 2 then
				-- Cat form (or Feral with form-switching off): CPs are native, always eligible
				hasSecondary = true
				secondaryVisSettings = sharedSettings.displayBar.secondary
			elseif TRB.Data.character.specId == 2 then
				-- Feral in non-cat form: checkbox defaults ON (nil → show)
				if sharedSettings.displayBar.showComboPoints ~= false then
					hasSecondary = true
					secondaryVisSettings = sharedSettings.displayBar.secondary
				end
			else
				-- Non-Feral in non-cat form: checkbox defaults OFF (nil → hide)
				if sharedSettings.displayBar.showComboPoints == true then
					hasSecondary = true
					secondaryVisSettings = sharedSettings.displayBar.secondary
				end
			end
		end

		-- Mana bar: Balance (specId == 1) only when primary bar is NOT already showing mana.
		-- When form switching routes to displaySpecId == 4 (Restoration), the primary bar IS mana,
		-- so the dedicated mana bar would duplicate it. Only show it when displaySpecId == 1 (Astral Power on primary).
		local hasMana = TRB.Data.character.specId == 1 and displaySpecId == 1
		local manaVisSettings = (sharedSettings and sharedSettings.displayBar.mana) or nil

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, nil, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, secondaryVisSettings, hasSecondary, TRB.Data.character.maxResource2, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, sharedSettings and sharedSettings.displayBar.health, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.mana, manaVisSettings, hasMana, 1, nil),
		}

		if sharedSettings ~= nil then
			local context = TRB.Classes.BarVisibilityContext:NewFromGameState(force, sharedSettings)
			TRB.Functions.BarVisibility:ProcessBars(context, entries, snapshotData, sharedSettings)
		else
			TRB.Functions.BarVisibility:HideAllEntries(entries, snapshotData, nil)
		end
	else
		TRB.Functions.BarVisibility:HideAllBarGroups(snapshotData)
	end
end

local specValidVars
do
	local healthVars = {
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true,
	}
	local sharedResourceVars = {
		["$mana"] = true, ["$manaMax"] = true, ["$manaPercent"] = true,
		["$resource"] = false, ["$resourceMax"] = true,
		["$astralPower"] = false, ["$astralPowerMax"] = true,
		["$energy"] = false, ["$energyMax"] = true,
		["$comboPoints"] = true, ["$comboPointsMax"] = true,
		["$rage"] = false, ["$rageMax"] = true,
	}
	local castingFn = function()
		local c = TRB.Data.snapshotData.casting
		return c.resourceRaw ~= nil and c.resourceRaw ~= 0
	end
	-- Balance
	local eclipseFn = function()
		local spells = TRB.Data.spellsData.spells
		local snaps = TRB.Data.snapshotData.snapshots
		return snaps[spells.eclipseSolar.id].buff.isActive or snaps[spells.eclipseLunar.id].buff.isActive or snaps[spells.celestialAlignment.id].buff.isActive or snaps[spells.incarnationChosenOfElune.id].buff.isActive
	end
	local solarFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.eclipseSolar.id].buff.isActive
	end
	local lunarFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.eclipseLunar.id].buff.isActive
	end
	local caFn = function()
		local spells = TRB.Data.spellsData.spells
		local snaps = TRB.Data.snapshotData.snapshots
		return snaps[spells.celestialAlignment.id].buff.isActive or snaps[spells.incarnationChosenOfElune.id].buff.isActive
	end
	---@type table<string, boolean|function>
	local balance = {
		["$eclipse"] = eclipseFn,
		["$solar"] = solarFn, ["$eclipseSolar"] = solarFn, ["$solarEclipse"] = solarFn,
		["$lunar"] = lunarFn, ["$eclipseLunar"] = lunarFn, ["$lunarEclipse"] = lunarFn,
		["$celestialAlignment"] = caFn,
		["$eclipseTime"] = eclipseFn,
		["$starsurgeUsable"] = function()
			local spells = TRB.Data.spellsData.spells
			return spells.starsurge:IsUsable() or spells.starsurge:IsFree()
		end,
		["$starfallUsable"] = function()
			local spells = TRB.Data.spellsData.spells
			return spells.starfall:IsUsable() or spells.starfall:IsFree()
		end,
		["$casting"] = castingFn,
	}
	for k, v in pairs(healthVars) do balance[k] = v end
	for k, v in pairs(sharedResourceVars) do balance[k] = v end
	-- Feral
	local berserkFeralFn = function() return GetBerserkRemainingTime() > 0 end
	local incarnFeralBuffFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive
	end
	---@type table<string, boolean|function>
	local feral = {
		["$berserkTime"] = berserkFeralFn, ["$incarnationTime"] = berserkFeralFn,
		["$incarnationTicks"] = incarnFeralBuffFn,
		["$incarnationTickTime"] = incarnFeralBuffFn,
		["$incarnationNextCp"] = incarnFeralBuffFn,
		["$inStealth"] = function() return IsStealthed() end,
		["$casting"] = castingFn,
	}
	for k, v in pairs(healthVars) do feral[k] = v end
	for k, v in pairs(sharedResourceVars) do feral[k] = v end
	-- Guardian (no $casting check - intentional)
	local berserkGuardianFn = function()
		local spells = TRB.Data.spellsData.spells
		local snaps = TRB.Data.snapshotData.snapshots
		return snaps[spells.berserk.id].buff.isActive or snaps[spells.incarnationGuardianOfUrsoc.id].buff.isActive
	end
	---@type table<string, boolean|function>
	local guardian = {
		["$berserkTime"] = berserkGuardianFn, ["$incarnationTime"] = berserkGuardianFn,
	}
	for k, v in pairs(healthVars) do guardian[k] = v end
	for k, v in pairs(sharedResourceVars) do guardian[k] = v end
	-- Restoration
	local restoration = {
		["$resourcePercent"] = false,
		["$efflorescenceTime"] = function()
			local spells = TRB.Data.spellsData.spells
			return TRB.Data.snapshotData.snapshots[spells.efflorescence.id].buff.isActive
		end,
		["$incarnationTime"] = function()
			local spells = TRB.Data.spellsData.spells
			return TRB.Data.snapshotData.snapshots[spells.incarnationTreeOfLife.id].buff.isActive
		end,
		["$casting"] = castingFn,
	}
	for k, v in pairs(healthVars) do restoration[k] = v end
	for k, v in pairs(sharedResourceVars) do restoration[k] = v end

	specValidVars = { [1] = balance, [2] = feral, [3] = guardian, [4] = restoration }
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then return valid end

	local specVars = specValidVars[TRB.Data.character.specId]
	if not specVars then return false end

	local entry = specVars[var]
	if entry == true then return true end
	if not entry then return false end
	return entry() or false
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
				return primaryNode:GetFrame(), true, isVisible
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
				return primaryNode:GetFrame(), true, isVisible
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
				return primaryNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end
	
	-- Standard "Resource" or "ResourceBar" always returns primary bar
	if normalizedRelativeFrame == "Resource" or normalizedRelativeFrame == "ResourceBar" then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
			return primaryNode:GetFrame(), true, isVisible
		end
		return nil, true, false
	end

	if normalizedRelativeFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetFrame(), true, isVisible
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
				return primaryNode:GetFrame(), true, isVisible
			end
		elseif displaySpecId == 1 and barGroups.mana then
			-- Balance uses separate mana bar (when in moonkin form)
			local manaNode = barGroups.mana:GetNode(1)
			if manaNode then
				local isVisible = barGroups.mana.isVisible and manaNode.isVisible
				return manaNode:GetFrame(), true, isVisible
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
				return cpNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

---Returns true when any spec-specific buff timer is actively counting down.
---Balance: eclipse/celestial alignment/incarnation; Feral: berserk/incarnation;
---Guardian: berserk/incarnation; Restoration: efflorescence/incarnation.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local snapshotData = TRB.Data.snapshotData
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
	if not snapshotData or not spells then return false end
	local snapshots = snapshotData.snapshots
	local specId = TRB.Data.character.specId
	if specId == 1 then -- Balance
		if (spells.celestialAlignment and snapshots[spells.celestialAlignment.id] and snapshots[spells.celestialAlignment.id].buff and snapshots[spells.celestialAlignment.id].buff.isActive)
			or (spells.incarnationChosenOfElune and snapshots[spells.incarnationChosenOfElune.id] and snapshots[spells.incarnationChosenOfElune.id].buff and snapshots[spells.incarnationChosenOfElune.id].buff.isActive)
			or (spells.eclipseSolar and snapshots[spells.eclipseSolar.id] and snapshots[spells.eclipseSolar.id].buff and snapshots[spells.eclipseSolar.id].buff.isActive)
			or (spells.eclipseLunar and snapshots[spells.eclipseLunar.id] and snapshots[spells.eclipseLunar.id].buff and snapshots[spells.eclipseLunar.id].buff.isActive) then
			return true
		end
	elseif specId == 2 then -- Feral
		if (spells.berserk and snapshots[spells.berserk.id] and snapshots[spells.berserk.id].buff and snapshots[spells.berserk.id].buff.isActive)
			or (spells.incarnationAvatarOfAshamane and snapshots[spells.incarnationAvatarOfAshamane.id] and snapshots[spells.incarnationAvatarOfAshamane.id].buff and snapshots[spells.incarnationAvatarOfAshamane.id].buff.isActive) then
			return true
		end
	elseif specId == 3 then -- Guardian
		if (spells.berserk and snapshots[spells.berserk.id] and snapshots[spells.berserk.id].buff and snapshots[spells.berserk.id].buff.isActive)
			or (spells.incarnationGuardianOfUrsoc and snapshots[spells.incarnationGuardianOfUrsoc.id] and snapshots[spells.incarnationGuardianOfUrsoc.id].buff and snapshots[spells.incarnationGuardianOfUrsoc.id].buff.isActive) then
			return true
		end
	elseif specId == 4 then -- Restoration
		if (spells.efflorescence and snapshots[spells.efflorescence.id] and snapshots[spells.efflorescence.id].buff and snapshots[spells.efflorescence.id].buff.isActive)
			or (spells.incarnationTreeOfLife and snapshots[spells.incarnationTreeOfLife.id] and snapshots[spells.incarnationTreeOfLife.id].buff and snapshots[spells.incarnationTreeOfLife.id].buff.isActive) then
			return true
		end
	end
	return false
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