local _, TRB = ...
if TRB.Data.character.classId ~= 7 then --Only do this if we're on a Shaman!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}
local lookupChanged = TRB.Functions.BarText.LookupChanged

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

local specCache = {
	shaman_elemental = TRB.Classes.SpecCache:New(),
	shaman_enhancement = TRB.Classes.SpecCache:New(),
	shaman_restoration = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Elemental
	Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		},
		chainLightning = {
			targetsHit = 0
		}
	}
	
	specCache.shaman_elemental.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		earthShockThreshold = 60,
		earthquakeThreshold = 60,
		effects = {
		},
		items = {
		}
	}
	
	---@type TRB.Classes.Shaman.ElementalSpells
	specCache.shaman_elemental.spellsData.spells = TRB.Classes.Shaman.ElementalSpells:New()
	local spells = specCache.shaman_elemental.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
	
	specCache.shaman_elemental.snapshotData.audio = {
		playedEsCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.shaman_elemental.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)
	---@type TRB.Classes.Snapshot
	specCache.shaman_elemental.snapshotData.snapshots[spells.chainLightning.id] = TRB.Classes.Snapshot:New(spells.chainLightning, {
		targetsHit = 0,
		hitTime = nil,
		hasStruckTargets = false
	})
	---@type TRB.Classes.Snapshot
	specCache.shaman_elemental.snapshotData.snapshots[spells.powerOfTheMaelstrom.id] = TRB.Classes.Snapshot:New(spells.powerOfTheMaelstrom, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.shaman_elemental.snapshotData.snapshots[spells.icefury.id] = TRB.Classes.Snapshot:New(spells.icefury, {
		resource = 0
	})
	---@type TRB.Classes.Snapshot
	specCache.shaman_elemental.snapshotData.snapshots[spells.stormkeeper.id] = TRB.Classes.Snapshot:New(spells.stormkeeper)
	---@type TRB.Classes.Snapshot
	specCache.shaman_elemental.snapshotData.snapshots[spells.echoesOfGreatSundering.id] = TRB.Classes.Snapshot:New(spells.echoesOfGreatSundering)


	-- Enhancement
	specCache.shaman_enhancement.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.shaman_enhancement.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 10000,
		maxResource2 = 10,
		effects = {
		},
		items = {}
	}

	---@type TRB.Classes.Shaman.EnhancementSpells
	specCache.shaman_enhancement.spellsData.spells = TRB.Classes.Shaman.EnhancementSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.shaman_enhancement.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]

	specCache.shaman_enhancement.snapshotData.attributes.manaRegen = 0
	specCache.shaman_enhancement.snapshotData.audio = {
		maelstromWeaponThreshold1Played = false,
		maelstromWeaponThreshold2Played = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.shaman_enhancement.snapshotData.snapshots[spells.maelstromWeapon.id] = TRB.Classes.Snapshot:New(spells.maelstromWeapon)
	---@type TRB.Classes.Snapshot
	specCache.shaman_enhancement.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)

	specCache.shaman_enhancement.barTextVariables = {
		icons = {},
		values = {}
	}

	
	-- Restoration
	specCache.shaman_restoration.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		}
	}

	specCache.shaman_restoration.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.Shaman.RestorationSpells
	specCache.shaman_restoration.spellsData.spells = TRB.Classes.Shaman.RestorationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.shaman_restoration.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]

	specCache.shaman_restoration.snapshotData.attributes.manaRegen = 0
	specCache.shaman_restoration.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.shaman_restoration.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)

	specCache.shaman_restoration.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Elemental()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "elemental")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "shaman_elemental" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Shaman.BarGroupsFactory:CreateForSpec(1)
	end
end

local function Setup_Enhancement()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "enhancement", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "shaman_enhancement" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Shaman.BarGroupsFactory:CreateForSpec(2)
	end
end

local function Setup_Restoration()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "restoration", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "shaman_restoration" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Shaman.BarGroupsFactory:CreateForSpec(3)
	end
end

local function FillSpellData_Elemental()
	Setup_Elemental()
	---@type TRB.Classes.SpellsData
	specCache.shaman_elemental.spellsData:FillSpellData()
	TRB.Classes.Shaman.ElementalSpells.FillBarTextVariables(specCache.shaman_elemental)
end

local function FillSpellData_Enhancement()
	Setup_Enhancement()
	---@type TRB.Classes.SpellsData
	specCache.shaman_enhancement.spellsData:FillSpellData()
	TRB.Classes.Shaman.EnhancementSpells.FillBarTextVariables(specCache.shaman_enhancement)
end

local function FillSpellData_Restoration()
	Setup_Restoration()
	---@type TRB.Classes.SpellsData
	specCache.shaman_restoration.spellsData:FillSpellData()
	TRB.Classes.Shaman.RestorationSpells.FillBarTextVariables(specCache.shaman_restoration)
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:UpdateTrackedSpells(currentTime)
end

local function TargetsCleanup(clearAll)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Don't construct bars for disabled specs
	if not TRB.Data.specSupported then
		return
	end

	-- Enhancement uses secondary bar (Maelstrom Weapon). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	if barGroups and barGroups.secondary and TRB.Data.character.specId == 2 then
		local maxStacks = TRB.Data.character.maxResource2
		if maxStacks == nil or maxStacks == 0 then
			maxStacks = barGroups.secondary.maxNodes or 10
		end
		TRB.Data.character.maxResource2 = maxStacks
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

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Enhancement uses secondary bar (Maelstrom Weapon); Elemental/Restoration do not.
	if barGroups and barGroups.secondary then
		if TRB.Data.character.specId == 2 then
			local maxStacks = TRB.Data.character.maxResource2 or 10
			
			-- Determine display node count based on compressed view setting
			local displayNodes = maxStacks
			if settings.colors and settings.colors.comboPoints and settings.colors.comboPoints.compressedView then
				displayNodes = math.ceil(maxStacks / 2) -- 10 stacks -> 5 nodes
			end
			
			barGroups.secondary:RebuildNodes(displayNodes, settings)
		else
			barGroups.secondary:Hide()
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Elemental()
	local specSettings = TRB.Data.settings.shaman.elemental
	local sharedSettings = TRB.Data.specCache["shaman_elemental"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()

	local currentMaelstromColor = sharedSettings.colors.text.current.color
	local castingMaelstromColor = sharedSettings.colors.text.casting.color

	local maelstromThreshold = TRB.Data.character.maxResource

	if talents:IsTalentActive(spells.earthquake) then
		maelstromThreshold = math.min(maelstromThreshold, spells.earthquake:GetPrimaryResourceCost())
	end
	
	if talents:IsTalentActive(spells.earthShock) and not talents:IsTalentActive(spells.elementalBlast) then
		maelstromThreshold = math.min(maelstromThreshold, spells.earthShock:GetPrimaryResourceCost())
	elseif talents:IsTalentActive(spells.elementalBlast) then
		maelstromThreshold = math.min(maelstromThreshold, spells.elementalBlast:GetPrimaryResourceCost())
	end

	-- $earthShockUsable, $elementalBlastUsable (synonyms), $earthquakeUsable
	local _earthShockUsable = (talents:IsTalentActive(spells.earthShock) and not talents:IsTalentActive(spells.elementalBlast) and (spells.earthShock:IsUsable() or spells.earthShock:IsFree())) or (talents:IsTalentActive(spells.elementalBlast) and (spells.elementalBlast:IsUsable() or spells.elementalBlast:IsFree()))
	local _earthquakeUsable = (talents:IsTalentActive(spells.earthquake) and (spells.earthquake:IsUsable() or spells.earthquake:IsFree())) or (talents:IsTalentActive(spells.earthquakeTargeted) and (spells.earthquakeTargeted:IsUsable() or spells.earthquakeTargeted:IsFree()))

	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled and _earthShockUsable then
			currentMaelstromColor = sharedSettings.colors.text.overThreshold.color
			castingMaelstromColor = sharedSettings.colors.text.overThreshold.color
		end
	end

	--[[
	----------
	--Icefury
	--$ifMaelstrom
	local icefuryMaelstrom = snapshots[spells.icefury.id].attributes.resource or 0
	--$ifStacks
	local icefuryStacks = snapshots[spells.icefury.id].buff.applications or 0
	--$ifStacks
	local _icefuryTime = snapshots[spells.icefury.id].buff:GetRemainingTime(currentTime)
	local icefuryTime = TRB.Functions.BarText:TimerPrecision(_icefuryTime)

	--$skStacks
	local stormkeeperStacks = snapshots[spells.stormkeeper.id].buff.applications or 0
	--$skStacks
	local _stormkeeperTime = snapshots[spells.stormkeeper.id].buff:GetRemainingTime(currentTime)
	local stormkeeperTime = TRB.Functions.BarText:TimerPrecision(_stormkeeperTime)

	--$eogsTime
	local _eogsTime = snapshots[spells.echoesOfGreatSundering.id].buff:GetRemainingTime(currentTime)
	local eogsTime = TRB.Functions.BarText:TimerPrecision(_eogsTime)]]

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)

	-- Mana lookups
	local currentManaColor = (sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color) or sharedSettings.colors.text.current.color
	local normalizedMana = UnitPower("player", Enum.PowerType.Mana)
	local normalizedManaMax = UnitPowerMax("player", Enum.PowerType.Mana)

	--$manaPercent
	local manaPrecision = sharedSettings.precision.mana or 1
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

	----------------------------

	local prevState = TRB.Data.prevLookupState or {}
	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}

	-- lookupLogic (unconditional)
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$maelstrom"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$maelstromMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	lookupLogic["$earthShockUsable"] = _earthShockUsable
	lookupLogic["$elementalBlastUsable"] = _earthShockUsable
	lookupLogic["$earthquakeUsable"] = _earthquakeUsable
	--[[
	lookupLogic["$ifStacks"] = icefuryStacks
	lookupLogic["$ifTime"] = icefuryTime
	lookupLogic["$skStacks"] = stormkeeperStacks
	lookupLogic["$skTime"] = _stormkeeperTime
	lookupLogic["$eogsTime"] = _eogsTime
	lookupLogic["$pfTime"] = _pfTime]]
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$manaMax"] = normalizedManaMax
	lookupLogic["$manaPercent"] = _manaPercent

	-- RAW assignments (unmemoized)
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$maelstromMax"] = TRB.Data.character.maxResource
	lookup["$earthShockUsable"] = ""
	lookup["$elementalBlastUsable"] = ""
	lookup["$earthquakeUsable"] = ""

	-- OVERCAP pattern: maelstrom + casting
	local resourceChanged = lookupChanged(prevState, "$maelstrom", snapshotData.attributes.resource, currentMaelstromColor, true)
	local castingChanged = lookupChanged(prevState, "$casting", snapshotData.casting.resourceFinal, castingMaelstromColor)
	if resourceChanged or castingChanged then
		local currentMaelstrom
		local castingMaelstrom
		if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
			local overcapTextCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, currentMaelstromColor, sharedSettings.colors.text.overcap.color)
			local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
			currentMaelstrom = textColorResult:WrapTextInColorCode(string.format("%.0f", snapshotData.attributes.resource))
			castingMaelstrom = textColorResult:WrapTextInColorCode(string.format("%.0f", snapshotData.casting.resourceFinal))
		else
			currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, snapshotData.attributes.resource)
			castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, snapshotData.casting.resourceFinal)
		end
		lookup["$maelstrom"] = currentMaelstrom
		lookup["$resource"] = currentMaelstrom
		lookup["$casting"] = castingMaelstrom
	end
	if lookupChanged(prevState, "$ascendanceTime", _ascendanceTime) then
		lookup["$ascendanceTime"] = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)
	end
	--[[
	lookup["$ifStacks"] = icefuryStacks
	lookup["$ifTime"] = icefuryTime
	lookup["$skStacks"] = stormkeeperStacks
	lookup["$skTime"] = stormkeeperTime
	lookup["$eogsTime"] = eogsTime
	lookup["$pfTime"] = pfTime]]
	if lookupChanged(prevState, "$mana", normalizedMana, currentManaColor, true) then
		lookup["$mana"] = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))
	end
	if lookupChanged(prevState, "$manaMax", normalizedManaMax, currentManaColor, true) then
		lookup["$manaMax"] = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedManaMax))
	end
	if lookupChanged(prevState, "$manaPercent", manaPercentRaw, currentManaColor, true) then
		lookup["$manaPercent"] = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Enhancement()
	local specSettings = TRB.Data.settings.shaman.enhancement
	local sharedSettings = TRB.Data.specCache["shaman_enhancement"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	--Spec specific implementation
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh

	local currentManaColor = specSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	local manaPrecision = sharedSettings.precision.mana or 1

	--$casting
	local _castingMana = snapshotData.casting.resourceFinal

	--$maelstromWeapon
	local _maelstromWeapon = snapshots[spells.maelstromWeapon.id].buff.applications or 0

	--$maelstromWeaponMax
	local _maelstromWeaponMax = spells.maelstromWeapon.maxStacks

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)

	----------------------------

	local prevState = TRB.Data.prevLookupState or {}
	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}

	-- lookupLogic (unconditional)
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	lookupLogic["$comboPoints"] = _maelstromWeapon
	lookupLogic["$maelstromWeapon"] = _maelstromWeapon
	lookupLogic["$maelstromWeaponMax"] = _maelstromWeaponMax
	lookupLogic["$comboPointsMax"] = _maelstromWeaponMax

	-- RAW assignments (unmemoized)
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$manaMax"] = TRB.Data.character.maxResource
	lookup["$comboPoints"] = _maelstromWeapon
	lookup["$maelstromWeapon"] = _maelstromWeapon
	lookup["$comboPointsMax"] = _maelstromWeaponMax
	lookup["$maelstromWeaponMax"] = _maelstromWeaponMax

	-- Memoized formatted writes
	if lookupChanged(prevState, "$mana", normalizedMana, currentManaColor, true) then
		local f = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))
		lookup["$mana"] = f
		lookup["$resource"] = f
	end
	if lookupChanged(prevState, "$manaPercent", manaPercentRaw, currentManaColor, true) then
		local f = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)
		lookup["$manaPercent"] = f
		lookup["$resourcePercent"] = f
	end
	if lookupChanged(prevState, "$ascendanceTime", _ascendanceTime) then
		lookup["$ascendanceTime"] = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Restoration()
	local specSettings = TRB.Data.settings.shaman.restoration
	local sharedSettings = TRB.Data.specCache["shaman_restoration"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	local manaPrecision = sharedSettings.precision.mana or 1

	--$casting
	local _castingMana = snapshotData.casting.resourceFinal

	--$manaMax (formatted — intentionally used for both lookup and lookupLogic)
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)

	----------------------

	local prevState = TRB.Data.prevLookupState or {}
	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}

	-- lookupLogic (unconditional)
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourceMax"] = manaMax
	lookupLogic["$manaMax"] = manaMax
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$ascendanceTime"] = _ascendanceTime

	-- Memoized formatted writes
	if lookupChanged(prevState, "$mana", normalizedMana, currentManaColor, true) then
		local f = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))
		lookup["$mana"] = f
		lookup["$resource"] = f
	end
	if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor, true) then
		lookup["$manaMax"] = manaMax
		lookup["$resourceMax"] = manaMax
	end
	if lookupChanged(prevState, "$manaPercent", manaPercentRaw, currentManaColor, true) then
		local f = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)
		lookup["$manaPercent"] = f
		lookup["$resourcePercent"] = f
	end
	if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
		lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
	end
	if lookupChanged(prevState, "$ascendanceTime", _ascendanceTime) then
		lookup["$ascendanceTime"] = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting(spell, resourceMod)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]

	resourceMod = resourceMod or 0
	local resourceMultMod = 1

	local currentTime = GetTime()
	if spell.resource ~= nil and spell.resource > 0 then
		snapshotData.casting.resourceRaw = (spell.resource + resourceMod) * resourceMultMod
		snapshotData.casting.resourceFinal = (spell.resource + resourceMod) * resourceMultMod
	end
	snapshotData.casting.startTime = currentTime
	snapshotData.casting.spellId = spell.id
	snapshotData.casting.icon = spell.icon
end

local function UpdateCastingResourceFinal_Enhancement()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Restoration()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
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
	local snapshots = snapshotData.snapshots
	local casting = snapshotData.casting
	local currentTime = GetTime()
	local affectingCombat = TRB.Data.character.inCombat

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.lightningBolt.id then
				FillSnapshotDataCasting(spells.lightningBolt)

				--[[if snapshots[spells.surgeOfPower.id].buff.isActive then
					casting.resourceRaw = casting.resourceRaw + ((spells.lightningBolt.overload) * 2)
					casting.resourceFinal = casting.resourceFinal + ((spells.lightningBolt.overload) * 2)
				end]]
				
				if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive then
					casting.resourceRaw = casting.resourceRaw + spells.lightningBolt.overload
					casting.resourceFinal = casting.resourceFinal + spells.lightningBolt.overload
				end
			elseif spellId == spells.lavaBurst.id then
				FillSnapshotDataCasting(spells.lavaBurst)
			elseif spellId == spells.elementalBlast.id then
				FillSnapshotDataCasting(spells.elementalBlast)
			elseif spellId == spells.icefury.id then
				FillSnapshotDataCasting(spells.icefury)
			elseif spellId == spells.chainLightning.id then
				FillSnapshotDataCasting(spells.chainLightning)

				if snapshots[spells.chainLightning.id].attributes.hitTime == nil then
					snapshots[spells.chainLightning.id].attributes.targetsHit = 1
					snapshots[spells.chainLightning.id].attributes.hitTime = currentTime
					snapshots[spells.chainLightning.id].attributes.hasStruckTargets = false
				elseif currentTime > (snapshots[spells.chainLightning.id].attributes.hitTime + (TRB.Functions.Character:GetCurrentGCDTime(true) * 4) + TRB.Data.character.latency) then
					snapshots[spells.chainLightning.id].attributes.targetsHit = 1
				end

				if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive and spellId == spells.chainLightning.id then
					snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + spells.chainLightning.overload
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.chainLightning.overload
				end

				snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw * snapshots[spells.chainLightning.id].attributes.targetsHit
				snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * snapshots[spells.chainLightning.id].attributes.targetsHit
			elseif spellId == spells.hex.id and talents:IsTalentActive(spells.inundate) and affectingCombat then
				FillSnapshotDataCasting(spells.hex)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.ascendance.castId then
				local duration = spells.ascendance.duration
				if talents:IsTalentActive(spells.preeminence) then
					duration = duration + spells.preeminence.duration
				end
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Enhancement()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			local spells = spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
			if spellId == spells.ascendance.castId then
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(spells.ascendance.duration, currentTime)
			elseif spellId == spells.doomWinds.castId then
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(spells.doomWinds.duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Restoration()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			local spells = spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
			if spellId == spells.ascendance.castId then
				local duration = spells.ascendance.duration
				if talents:IsTalentActive(spells.preeminence) then
					duration = duration + spells.preeminence.duration
				end
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	end
end

local function UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells|TRB.Classes.Shaman.EnhancementSpells|TRB.Classes.Shaman.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local currentTime = GetTime()
	TRB.Functions.Character:UpdateSnapshot()

	snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Elemental()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
end

local function UpdateSnapshot_Enhancement()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	snapshots[spells.maelstromWeapon.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Restoration()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.shaman
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

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.elemental
		local specCacheSettings = TRB.Data.specCache.shaman_elemental.settings
		UpdateSnapshot_Elemental()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = specSettings.colors.bar.border.color
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local barColor = specSettings.colors.bar.base.color

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetFrame()
				local thresholds = primaryNode:GetThresholds()

				local anyUsable = false
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
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

					anyUsable = anyUsable or isUsable
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.earthquake.id or spell.id == spells.earthquakeTargeted.id then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							else
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdOver
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
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
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end
					
					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				local maelstromThreshold = TRB.Data.character.maxResource

				if talents:IsTalentActive(spells.earthquake) then
					maelstromThreshold = math.min(maelstromThreshold, spells.earthquake:GetPrimaryResourceCost())
				end
				
				if talents:IsTalentActive(spells.earthShock) and not talents:IsTalentActive(spells.elementalBlast) then
					maelstromThreshold = math.min(maelstromThreshold, spells.earthShock:GetPrimaryResourceCost())
				elseif talents:IsTalentActive(spells.elementalBlast) then
					maelstromThreshold = math.min(maelstromThreshold, spells.elementalBlast:GetPrimaryResourceCost())
				end

				if anyUsable and specSettings.colors.bar.earthShock.enabled then
					barColor = specSettings.colors.bar.earthShock.color
					if specSettings.colors.bar.flashEnabled then
						TRB.Functions.Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					else
						barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					end

					if specSettings.audio.esReady.enabled and snapshotData.audio.playedEsCue == false then
						snapshotData.audio.playedEsCue = true
						PlaySoundFile(specSettings.audio.esReady.sound, coreSettings.audio.channel.channel)
					end
				else
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					snapshotData.audio.playedEsCue = false
				end

				if snapshots[spells.ascendance.id].buff.isActive then
					local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
					local timeThreshold = 0
					local useEndOfAscendanceColor = false

					if specSettings.endOf.ascendance.enabled then
						useEndOfAscendanceColor = true
						if specSettings.endOf.ascendance.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOf.ascendance.gcdsMax
						elseif specSettings.endOf.ascendance.mode == "time" then
							timeThreshold = specSettings.endOf.ascendance.timeMax
						end
					end

					if useEndOfAscendanceColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.ascendanceEnd.color
					elseif anyUsable and specSettings.colors.bar.earthShock.enabled then
						barColor = specSettings.colors.bar.earthShock.color
					elseif specSettings.colors.bar.ascendance.enabled then
						barColor = specSettings.colors.bar.ascendance.color
					end
				end

				-- Apply overcap border color if enabled
				if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end

				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

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
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		local specSettings = classSettings.enhancement
		local specCacheSettings = TRB.Data.specCache.shaman_enhancement.settings
		UpdateSnapshot_Enhancement()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				
				if snapshots[spells.ascendance.id].buff.isActive then
					local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
					local timeThreshold = 0
					local useEndOfAscendanceColor = false

					if specSettings.endOf.ascendance.enabled then
						useEndOfAscendanceColor = true
						if specSettings.endOf.ascendance.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOf.ascendance.gcdsMax
						elseif specSettings.endOf.ascendance.mode == "time" then
							timeThreshold = specSettings.endOf.ascendance.timeMax
						end
					end

					if useEndOfAscendanceColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.ascendanceEnd.color
					elseif specSettings.colors.bar.ascendance.enabled then
						barColor = specSettings.colors.bar.ascendance.color
					end
				end

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end
			
			if specSettings.displayBar.secondary.visibility ~= "never" then
				refreshText = true
				-- Update Maelstrom Weapon stacks using BarNodes
				if barGroups.secondary then
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
					local maxStacks = spells.maelstromWeapon.maxStacks
					local currentStacks = snapshots[spells.maelstromWeapon.id].buff.applications
					local compressedView = specSettings.colors.comboPoints.compressedView
					local displayNodes = compressedView and math.ceil(maxStacks / 2) or maxStacks
					
					local cpBorderColor = specSettings.colors.comboPoints.border.color
					
					if compressedView then
						-- Compressed view: 5 nodes representing 10 stacks
						-- Stacks 1-5 fill nodes left-to-right with base color
						-- Stacks 6-10 overwrite nodes left-to-right with overflow color
						local firstHalf = math.min(currentStacks, 5)  -- How many of stacks 1-5 we have
						local secondHalf = math.max(0, currentStacks - 5)  -- How many of stacks 6-10 we have
						
						for nodeIndex = 1, displayNodes do
							local stackNode = barGroups.secondary:GetNode(nodeIndex)
							if stackNode then
								local cpColor = specSettings.colors.comboPoints.base.color
								local isFilled = false
								local isOverflow = false
								
								-- Determine if this node is filled and whether it's overflow
								if nodeIndex <= secondHalf then
									-- This node is in the overflow range (stacks 6-10)
									isFilled = true
									isOverflow = true
									cpColor = specSettings.colors.comboPoints.overflowBase.color
								elseif nodeIndex <= firstHalf then
									-- This node is in the base range (stacks 1-5)
									isFilled = true
									isOverflow = false
									cpColor = specSettings.colors.comboPoints.base.color
								end
								
								-- Apply penultimate/final colors
								if isFilled and isOverflow then
									-- Check for penultimate (9 stacks) or final (10 stacks)
									if currentStacks == maxStacks then
										-- At max stacks (10): sameColor makes all overflow nodes final, otherwise only node 5
										if specSettings.comboPoints.sameColor or nodeIndex == displayNodes then
											cpColor = specSettings.colors.comboPoints.final.color
										elseif nodeIndex == displayNodes - 1 then
											cpColor = specSettings.colors.comboPoints.penultimate.color
										end
									elseif currentStacks == maxStacks - 1 then
										-- At penultimate stacks (9): sameColor makes all overflow nodes penultimate
										if specSettings.comboPoints.sameColor or nodeIndex == secondHalf then
											cpColor = specSettings.colors.comboPoints.penultimate.color
										end
									end
								end
								
								if isFilled then
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. nodeIndex, stackNode, 1, 1)
								else
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. nodeIndex, stackNode, 0, 1)
								end
								
								stackNode:SetBorderColor(cpBorderColor)
								stackNode:SetColor(cpColor)
								stackNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
							end
						end
					else
						-- Standard view: 10 nodes, one per stack
						-- Nodes 1-5 use base color, nodes 6-10 use overflow/penultimate/final
						local halfPoint = math.ceil(maxStacks / 2) -- 5 for 10 stacks
						
						for x = 1, maxStacks do
							local cpColor = specSettings.colors.comboPoints.base.color
							local isFilled = currentStacks >= x

							local stackNode = barGroups.secondary:GetNode(x)
							if stackNode then
								if isFilled then
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, stackNode, 1, 1)
									
									-- Determine color based on position and sameColor setting
									if specSettings.comboPoints.sameColor then
										-- sameColor: all filled nodes share the highest applicable color
										if currentStacks == maxStacks then
											cpColor = specSettings.colors.comboPoints.final.color
										elseif currentStacks == maxStacks - 1 then
											cpColor = specSettings.colors.comboPoints.penultimate.color
										elseif currentStacks > halfPoint then
											cpColor = specSettings.colors.comboPoints.overflowBase.color
										else
											cpColor = specSettings.colors.comboPoints.base.color
										end
									else
										-- Per-node coloring
										if x == maxStacks then
											cpColor = specSettings.colors.comboPoints.final.color
										elseif x == maxStacks - 1 then
											cpColor = specSettings.colors.comboPoints.penultimate.color
										elseif x > halfPoint then
											cpColor = specSettings.colors.comboPoints.overflowBase.color
										else
											cpColor = specSettings.colors.comboPoints.base.color
										end
									end
								else
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, stackNode, 0, 1)
								end
								
								stackNode:SetBorderColor(cpBorderColor)
								stackNode:SetColor(cpColor)
								stackNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
							end
						end
					end
				end
			end

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
			end
		end

		-- Maelstrom Weapon threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			do
				local coreSettings = TRB.Data.settings.core
				local currentResource2 = snapshots[spells.maelstromWeapon.id].buff.applications or 0
				local threshold1 = specSettings.audio.maelstromWeaponThreshold1
				local threshold2 = specSettings.audio.maelstromWeaponThreshold2
				local threshold1Value = threshold1.configuration.thresholdValue
				local threshold2Value = threshold2.configuration.thresholdValue

				local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.maelstromWeaponThreshold1Played and currentResource2 >= threshold1Value
				local threshold2ShouldFire = threshold2.enabled and not snapshotData.audio.maelstromWeaponThreshold2Played and currentResource2 >= threshold2Value

				if threshold1ShouldFire and threshold2ShouldFire then
					snapshotData.audio.maelstromWeaponThreshold1Played = true
					snapshotData.audio.maelstromWeaponThreshold2Played = true
					if threshold2Value > threshold1Value then
						PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
					else
						PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
					end
				elseif threshold2ShouldFire then
					snapshotData.audio.maelstromWeaponThreshold2Played = true
					PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
				elseif threshold1ShouldFire then
					snapshotData.audio.maelstromWeaponThreshold1Played = true
					PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
				end

				if currentResource2 < threshold1Value then
					snapshotData.audio.maelstromWeaponThreshold1Played = false
				end
				if currentResource2 < threshold2Value then
					snapshotData.audio.maelstromWeaponThreshold2Played = false
				end
			end
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.restoration
		local specCacheSettings = TRB.Data.specCache.shaman_restoration.settings
		UpdateSnapshot_Restoration()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
				local currentResource = snapshotData.attributes.resourceModified
				local barBorderColor = specSettings.colors.bar.border.color
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local barColor = specSettings.colors.bar.base.color

				if snapshots[spells.ascendance.id].buff.isActive then
					local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
					local timeThreshold = 0
					local useEndOfAscendanceColor = false

					if specSettings.endOf.ascendance.enabled then
						useEndOfAscendanceColor = true
						if specSettings.endOf.ascendance.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOf.ascendance.gcdsMax
						elseif specSettings.endOf.ascendance.mode == "time" then
							timeThreshold = specSettings.endOf.ascendance.timeMax
						end
					end

					if useEndOfAscendanceColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.ascendanceEnd.color
					elseif specSettings.colors.bar.ascendance.enabled then
						barColor = specSettings.colors.bar.ascendance.color
					end
				end

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

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

	if TRB.Data.character.specId == 1 then
		specCache.shaman_elemental.talents:GetTalents()
		FillSpellData_Elemental()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.shaman_elemental)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Elemental
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.shaman_elemental.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		lookup["#chainLightning"] = spells.chainLightning.icon
		lookup["#earthShock"] = spells.earthShock.icon
		lookup["#earthquake"] = spells.earthquake.icon
		lookup["#elementalBlast"] = spells.elementalBlast.icon
		lookup["#eogs"] = spells.echoesOfGreatSundering.icon
		lookup["#frostShock"] = spells.frostShock.icon
		lookup["#icefury"] = spells.icefury.icon
		lookup["#lavaBurst"] = spells.lavaBurst.icon
		lookup["#lightningBolt"] = spells.lightningBolt.icon
		lookup["#stormkeeper"] = spells.stormkeeper.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "shaman_elemental" then
			talents = specCache.shaman_elemental.talents
			TRB.Data.barConstructedForSpec = "shaman_elemental"
			ConstructResourceBar(specCache.shaman_elemental.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.shaman_enhancement.talents:GetTalents()
		FillSpellData_Enhancement()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.shaman_enhancement)
			
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]		
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Enhancement
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.shaman_enhancement.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "shaman_enhancement" then
			talents = specCache.shaman_enhancement.talents
			TRB.Data.barConstructedForSpec = "shaman_enhancement"
			ConstructResourceBar(specCache.shaman_enhancement.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.shaman_restoration.talents:GetTalents()
		FillSpellData_Restoration()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.shaman_restoration)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.shaman_restoration.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "shaman_restoration" then
			talents = specCache.shaman_restoration.talents
			TRB.Data.barConstructedForSpec = "shaman_restoration"
			ConstructResourceBar(specCache.shaman_restoration.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
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
			end
		end)
	end)
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
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
	
	if TRB.Data.character.classId == 7 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Shaman.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.elemental == nil or
						TwintopInsanityBarSettings.shaman.elemental.displayText == nil then
						settings.shaman.elemental.displayText.barText = TRB.Options.Shaman.ElementalLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.enhancement == nil or
						TwintopInsanityBarSettings.shaman.enhancement.displayText == nil then
						settings.shaman.enhancement.displayText.barText = TRB.Options.Shaman.EnhancementLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.restoration == nil or
						TwintopInsanityBarSettings.shaman.restoration.displayText == nil then
						settings.shaman.restoration.displayText.barText = TRB.Options.Shaman.RestorationLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.shaman ~= true then
						TRB.Data.settings.shaman.elemental.displayText.barText = TRB.Options.Shaman.ElementalLoadDefaultBarTextSettings()
						TRB.Data.settings.shaman.enhancement.displayText.barText = TRB.Options.Shaman.EnhancementLoadDefaultBarTextSettings()
						TRB.Data.settings.shaman.restoration.displayText.barText = TRB.Options.Shaman.RestorationLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.shaman = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Shaman"])
					end
				else
					local settings = TRB.Options.Shaman.LoadDefaultSettings(true)
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
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.barConstructedForSpec = nil
						TRB.Data.settings.shaman.elemental = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.elemental)
						TRB.Data.settings.shaman.enhancement = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.enhancement)
						TRB.Data.settings.shaman.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues("Restoration Shaman", TRB.Data.settings.shaman.restoration)
						FillSpellData_Elemental()
						FillSpellData_Enhancement()
						FillSpellData_Restoration()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Shaman.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "shaman"
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "elemental"
		TRB.Data.character.compositeKey = "shaman_elemental"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Maelstrom, false)
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "enhancement"
		TRB.Data.character.compositeKey = "shaman_enhancement"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		
		local maxComboPoints = 10
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey] and TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			if barGroups and barGroups.secondary and sharedSettings then
				barGroups.secondary:Show()
				TRB.Functions.Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		TRB.Data.character.specName = "restoration"
		TRB.Data.character.compositeKey = "shaman_restoration"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.shaman.elemental then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Maelstrom
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Id = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.shaman.enhancement then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1		
		TRB.Data.resource2 = "SPELL"
		TRB.Data.resource2Id = TRB.Data.specCache["shaman_enhancement"].spellsData.spells.maelstromWeapon.id
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.shaman.restoration then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Id = nil
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	if not TRB.Functions.BarVisibility:IsDirty(force) then
		return
	end

	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.compositeKey] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		end

		-- Enhancement (2) uses the secondary (Maelstrom Weapon) bar
		local hasSecondary = TRB.Data.character.specId == 2
		local secondaryNodes = nil
		if hasSecondary then
			local maxStacks = TRB.Data.character.maxResource2 or 10
			secondaryNodes = maxStacks
			if sharedSettings and sharedSettings.colors and sharedSettings.colors.comboPoints and sharedSettings.colors.comboPoints.compressedView then
				secondaryNodes = math.ceil(maxStacks / 2)
			end
		end

		-- Elemental (1) uses the mana bar
		local hasMana = TRB.Data.character.specId == 1
		local manaVisSettings = (sharedSettings and sharedSettings.displayBar.mana) or nil
		local healthVisSettings = (sharedSettings and sharedSettings.displayBar.health) or nil

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, nil, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, hasSecondary, secondaryNodes, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, healthVisSettings, true, 1, nil),
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

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spells
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		settings = TRB.Data.settings.shaman.elemental
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		settings = TRB.Data.settings.shaman.enhancement
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		settings = TRB.Data.settings.shaman.restoration
	else
		return false
	end

	if TRB.Data.character.specId == 1 then
		if var == "$resource" or var == "$maelstrom" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$maelstromMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id) then
				valid = true
			end
		--[[
		elseif var == "$ifStacks" then
			if snapshots[spells.icefury.id].buff.isActive then
				valid = true
			end
		elseif var == "$ifTime" then
			if snapshots[spells.icefury.id].buff.isActive then
				valid = true
			end
		elseif var == "$skStacks" then
			if snapshots[spells.stormkeeper.id].buff.isActive then
				valid = true
			end
		elseif var == "$skTime" then
			if snapshots[spells.stormkeeper.id].buff.isActive then
				valid = true
			end
		elseif var == "$eogsTime" then
			if snapshots[spells.echoesOfGreatSundering.id].buff.isActive then
				valid = true
			end]]
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		elseif var == "$earthShockUsable" or var == "$elementalBlastUsable" then
			if (talents:IsTalentActive(spells.earthShock) and not talents:IsTalentActive(spells.elementalBlast) and (spells.earthShock:IsUsable() or spells.earthShock:IsFree())) or (talents:IsTalentActive(spells.elementalBlast) and (spells.elementalBlast:IsUsable() or spells.elementalBlast:IsFree())) then
				valid = true
			end
		elseif var == "$earthquakeUsable" then
			if (talents:IsTalentActive(spells.earthquake) and (spells.earthquake:IsUsable() or spells.earthquake:IsFree())) or (talents:IsTalentActive(spells.earthquakeTargeted) and (spells.earthquakeTargeted:IsUsable() or spells.earthquakeTargeted:IsFree())) then
				valid = true
			end
		elseif var == "$mana" then
			-- Do not compare snapshotData.attributes.mana as it may be a secret value
			valid = false
		elseif var == "$manaMax" then
			valid = true
		elseif var == "$manaPercent" then
			-- Do not compare mana percent as it may be a secret value
			valid = false
		end
	elseif TRB.Data.character.specId == 2 then --Enhancement
		if var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$resource" or var == "$mana" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$comboPoints" or var == "$maelstromWeapon" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$maelstromWeaponMax" then
			valid = true
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then
		if var == "$resource" or var == "$mana" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		end
	else
		valid = false
	end

	-- Health variables are valid for all specs
	if var == "$health" or var == "$healthMax" or var == "$healthPercent" or var == "$absorb" or var == "$incomingHeal" then
		valid = true
	end
	

	-- Mana variables (Balance only)
	if TRB.Data.character.specId == 1 then
		if var == "$mana" or var == "$manaMax" or var == "$manaPercent" then
			valid = true
		end
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
	if normalizedRelativeFrame == "Resource" or normalizedRelativeFrame == "ResourceBar" then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
			return primaryNode:GetFrame(), true, isVisible
		end
		return nil, true, false
	end

	-- Handle secondary resources (Maelstrom Weapon stacks for Enhancement)
	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local stackNode = barGroups.secondary:GetNode(comboPoint)
			if stackNode then
				local isVisible = barGroups.secondary.isVisible and stackNode.isVisible
				return stackNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	-- Handle health bar
	if normalizedRelativeFrame == "HealthBar" or normalizedRelativeFrame == "Health" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	-- Handle mana bar (Elemental only)
	if normalizedRelativeFrame == "ManaBar" or normalizedRelativeFrame == "Mana" then
		if barGroups and barGroups.mana then
			local manaNode = barGroups.mana:GetNode(1)
			if manaNode then
				local isVisible = barGroups.mana.isVisible and manaNode.isVisible
				return manaNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

---Returns true when Ascendance buff is active (all 3 specs).
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local snapshotData = TRB.Data.snapshotData
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
	if snapshotData and spells and spells.ascendance then
		local snapshot = snapshotData.snapshots[spells.ascendance.id]
		if snapshot and snapshot.buff and snapshot.buff.isActive then
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
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end