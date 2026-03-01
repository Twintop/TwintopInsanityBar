local _, TRB = ...
if TRB.Data.character.classId ~= 13 then --Only do this if we're on an Evoker!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	evoker_devastation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
	evoker_preservation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
	evoker_augmentation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Devastation
	specCache.evoker_devastation.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.evoker_devastation.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 10000,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Evoker.DevastationSpells
	specCache.evoker_devastation.spellsData.spells = TRB.Classes.Evoker.DevastationSpells:New()
	local spells = specCache.evoker_devastation.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]

	specCache.evoker_devastation.snapshotData.attributes.manaRegen = 0
	specCache.evoker_devastation.snapshotData.audio = {
		essenceBurstPlayed = false,
		secondaryThresholdPlayed = false
	}
	---@type TRB.Classes.Snapshot
	specCache.evoker_devastation.snapshotData.snapshots[spells.dragonrage.id] = TRB.Classes.Snapshot:New(spells.dragonrage)

	specCache.evoker_devastation.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Preservation
	specCache.evoker_preservation.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.evoker_preservation.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		},
		items = {
		}
	}
	
	---@type TRB.Classes.Evoker.PreservationSpells
	specCache.evoker_preservation.spellsData.spells = TRB.Classes.Evoker.PreservationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.evoker_preservation.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

	specCache.evoker_preservation.snapshotData.attributes.manaRegen = 0
	specCache.evoker_preservation.snapshotData.audio = {
		essenceBurstPlayed = false,
		secondaryThresholdPlayed = false
	}

	specCache.evoker_preservation.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Augmentation
	specCache.evoker_augmentation.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.evoker_augmentation.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 10000,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Evoker.AugmentationSpells
	specCache.evoker_augmentation.spellsData.spells = TRB.Classes.Evoker.AugmentationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.evoker_augmentation.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]

	specCache.evoker_augmentation.snapshotData.attributes.manaRegen = 0
	specCache.evoker_augmentation.snapshotData.attributes.extendsEbonMight = false
	specCache.evoker_augmentation.snapshotData.audio = {
		essenceBurstPlayed = false,
		playedEbonMightCue = false,
		secondaryThresholdPlayed = false
	}
	---@type TRB.Classes.Snapshot
	specCache.evoker_augmentation.snapshotData.snapshots[spells.ebonMight.id] = TRB.Classes.Snapshot:New(spells.ebonMight)

	specCache.evoker_augmentation.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Devastation()
	TRB.Functions.Character:FillSpecializationCacheSettings("evoker", "devastation")

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "evoker_devastation" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(1)
	end
end

local function FillSpellData_Devastation()
	Setup_Devastation()
	specCache.evoker_devastation.spellsData:FillSpellData()
	TRB.Classes.Evoker.DevastationSpells.FillBarTextVariables(specCache.evoker_devastation)
end

local function Setup_Preservation()
	TRB.Functions.Character:FillSpecializationCacheSettings("evoker", "preservation", true)

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "evoker_preservation" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(2)
	end
end

local function FillSpellData_Preservation()
	Setup_Preservation()
	specCache.evoker_preservation.spellsData:FillSpellData()
	TRB.Classes.Evoker.PreservationSpells.FillBarTextVariables(specCache.evoker_preservation)
end

local function Setup_Augmentation()
	TRB.Functions.Character:FillSpecializationCacheSettings("evoker", "augmentation")

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "evoker_augmentation" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(3)
	end
end

local function FillSpellData_Augmentation()
	Setup_Augmentation()
	specCache.evoker_augmentation.spellsData:FillSpellData()
	TRB.Classes.Evoker.AugmentationSpells.FillBarTextVariables(specCache.evoker_augmentation)
end

local function CalculateAbilityResourceValue(resource, threshold)
	local modifier = 1.0

	return resource * modifier
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	
	if TRB.Data.character.specId == 1 then -- Devastation
	elseif TRB.Data.character.specId == 2 then -- Preservation
	elseif TRB.Data.character.specId == 3 then -- Augmentation
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
	if clearAll == true then
		if TRB.Data.character.specId == 1 then
		elseif TRB.Data.character.specId == 2 then
		elseif TRB.Data.character.specId == 3 then
		end
	end
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Don't construct bars for disabled specs
	if not TRB.Data.specSupported then
		return
	end

	-- Construct thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
			for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetFrame())
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Configure secondary bar for Essence (all specs)
	-- Set up structure, but let HideResourceBar() determine visibility
	if barGroups and barGroups.secondary then
		barGroups.secondary:SetNodeCount(TRB.Data.character.maxResource2 or 5)
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Devastation()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local specSettings = TRB.Data.settings.evoker.devastation
	local sharedSettings = TRB.Data.specCache["evoker_devastation"].settings
	--Spec specific implementation
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local regen, _ = GetPowerRegenForPowerType(Enum.PowerType.Essence)

	if regen == nil or regen == 0 then
		regen = 1
	end

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / regen
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

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
	
	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	--$dragonrageTime
	local _dragonrageTime = snapshots[spells.dragonrage.id].buff:GetRemainingTime(currentTime)
	local dragonrageTime = TRB.Functions.BarText:TimerPrecision(_dragonrageTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$resource"] = currentMana
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$dragonrageTime"] = dragonrageTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$dragonrageTime"] = _dragonrageTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Preservation()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.evoker.preservation
	local sharedSettings = TRB.Data.specCache["evoker_preservation"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local regen, _ = GetPowerRegenForPowerType(Enum.PowerType.Essence)

	if regen == nil or regen == 0 then
		regen = 1
	end

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / regen
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

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

	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$resourcePercent"] = manaPercent
	lookup["$manaPercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourceMax"] = manaMax
	lookupLogic["$manaMax"] = manaMax
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Augmentation()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local specSettings = TRB.Data.settings.evoker.augmentation
	local sharedSettings = TRB.Data.specCache["evoker_augmentation"].settings
	--Spec specific implementation
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local regen, _ = GetPowerRegenForPowerType(Enum.PowerType.Essence)

	if regen == nil or regen == 0 then
		regen = 1
	end

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / regen
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

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

	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	--$ebonMightTime
	local _ebonMightTime = snapshots[spells.ebonMight.id].buff:GetRemainingTime(currentTime)
	local ebonMightTime = TRB.Functions.BarText:TimerPrecision(_ebonMightTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$resource"] = currentMana
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$ebonMightTime"] = ebonMightTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$ebonMightTime"] = _ebonMightTime
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateCastingResourceFinal_Devastation()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Preservation()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function UpdateCastingResourceFinal_Augmentation()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId, ...)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		local snapshots = snapshotData.snapshots
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START"  then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Devastation()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.dragonrage.id then
				snapshots[spells.dragonrage.id].buff:InitializeCustom(spells.dragonrage.duration, currentTime)
				snapshots[spells.dragonrage.id].buff.attributes["empoweredCasts"] = 0
			end
		elseif event == "UNIT_SPELLCAST_EMPOWER_STOP" then
			if snapshots[spells.dragonrage.id].buff.isActive and talents:IsTalentActive(spells.animosity) then				
				local success = ...
				if success and (spellId == spells.fireBreath.id or spellId == spells.fireBreath.attributes.id2 or spellId == spells.eternitySurge.id or spellId == spells.eternitySurge.talentId) then
					local mod = spells.animosity.attributes.durationPerCastMod ^ (snapshots[spells.dragonrage.id].buff.attributes["empoweredCasts"] or 0)
					local increasedDuration = mod * spells.animosity.attributes.durationMod
					snapshots[spells.dragonrage.id].buff:AddTimeOrInitializeCustom(increasedDuration, currentTime)
					snapshots[spells.dragonrage.id].buff.attributes["empoweredCasts"] = snapshots[spells.dragonrage.id].buff.attributes["empoweredCasts"] + 1
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_EMPOWER_START" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Preservation()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		if event == "UNIT_SPELLCAST_EMPOWER_START" then
			snapshotData.attributes.extendsEbonMight = true
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Augmentation()
		elseif event == "UNIT_SPELLCAST_START" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Augmentation()
			-- Track if we're casting an ability that extends Ebon Might
			if spellId == spells.eruption.id then
				snapshotData.attributes.extendsEbonMight = true
			elseif spellId == spells.emeraldBlossom.id and talents:IsTalentActive(spells.dreamOfSpring.talentId) then
				snapshotData.attributes.extendsEbonMight = true
			else
				snapshotData.attributes.extendsEbonMight = false
			end
		elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_EMPOWER_STOP" then
			snapshotData.attributes.extendsEbonMight = false
			casting:Reset()
		else
			casting:Reset()
		end
	end
end

---Updates data based on spell events
local function HandleSpellEvents(self, event, ...)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]	
	local essenceBurstSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells|TRB.Classes.Evoker.PreservationSpells|TRB.Classes.Evoker.AugmentationSpells]]
	local essenceBurstDetectionId = essenceBurstSpells.essenceBurst.id

	if event == "SPELL_ACTIVATION_OVERLAY_SHOW" then
		local spellId = ...
		if spellId == essenceBurstDetectionId then -- Essence Burst
			if snapshotData.attributes.essenceBurstActive ~= true then
				local specSettings = TRB.Data.settings.evoker[TRB.Data.character.specName]
				if specSettings.audio.essenceBurst.enabled and not snapshotData.audio.essenceBurstPlayed then
					PlaySoundFile(specSettings.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
					snapshotData.audio.essenceBurstPlayed = true
				end
			end
			snapshotData.attributes.essenceBurstActive = true
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_HIDE" then
		local spellId = ...
		if spellId == essenceBurstDetectionId then -- Essence Burst
			snapshotData.attributes.essenceBurstActive = false
			snapshotData.audio.essenceBurstPlayed = false
		end
	end
end


local spellEventFrame = CreateFrame("Frame")
spellEventFrame:SetScript("OnEvent", HandleSpellEvents)

function TRB.Functions.Class:EnableEvents()
	spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW")
	spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE")
end

function TRB.Functions.Class:DisableEvents()
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW")
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE")
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local currentTime = GetTime()
end

local function UpdateSnapshot_Devastation()
	UpdateSnapshot()
	
	local currentTime = GetTime()
end

local function UpdateSnapshot_Preservation()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
end

local function UpdateSnapshot_Augmentation()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	local currentTime = GetTime()
end

---Updates Essence bar nodes with current values and colors
---@param specSettings table # The spec-specific settings
---@param specCacheSettings table # The spec cache settings
local function UpdateEssence(specSettings, specCacheSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	for x = 1, TRB.Data.character.maxResource2 do
		local cpBorderColor = specSettings.colors.comboPoints.border.color
		local cpColor = specSettings.colors.comboPoints.base.color

		local essenceValue = 0
		if snapshotData.attributes.resource2 >= x then
			essenceValue = 1000
			-- Color logic for penultimate/final
			if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
				cpColor = specSettings.colors.comboPoints.penultimate.color
			elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2) or x == TRB.Data.character.maxResource2 then
				cpColor = specSettings.colors.comboPoints.final.color
			end
		elseif snapshotData.attributes.resource2 + 1 == x then
			essenceValue = snapshotData.attributes.essencePartial or UnitPartialPower("player", Enum.PowerType.Essence)
		end

		if barGroups and barGroups.secondary then
			local essenceNode = barGroups.secondary:GetNode(x)
			if essenceNode then
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "essence" .. x, essenceNode, essenceValue, 1000)
				essenceNode:SetBorderColor(cpBorderColor)
				essenceNode:SetColor(cpColor)
				essenceNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
			end
		end
	end
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.evoker
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	TRB.Functions.Bar:HideResourceBar()

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	local function UpdateEssenceOuter(specSettings, specCacheSettings)
		local refreshTextEssence = false
		
		if specSettings.displayBar.secondary.visibility ~= "never" then
			refreshTextEssence = true
			UpdateEssence(specSettings, specCacheSettings)
		end

		if specSettings.audio.secondaryThreshold.enabled and not snapshotData.audio.secondaryThresholdPlayed and snapshotData.attributes.resource2 <= specSettings.audio.secondaryThreshold.configuration.thresholdValue then
			snapshotData.audio.secondaryThresholdPlayed = true
			PlaySoundFile(specSettings.audio.secondaryThreshold.sound, coreSettings.audio.channel.channel)
		elseif snapshotData.attributes.resource2 > specSettings.audio.secondaryThreshold.configuration.thresholdValue then
			snapshotData.audio.secondaryThresholdPlayed = false
		end

		return refreshTextEssence
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.devastation
		local specCacheSettings = TRB.Data.specCache.evoker_devastation.settings
		UpdateSnapshot_Devastation()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" and primaryNode then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
				local snapshots = snapshotData.snapshots
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				-- Dragonrage bar color changes
				if specSettings.colors.bar.dragonrage.enabled and snapshots[spells.dragonrage.id].buff.isActive then
					local dragonrageTimeLeft = snapshots[spells.dragonrage.id].buff:GetRemainingTime(currentTime)
					local dragonrageTimeThreshold = 0
					local useEndOfDragonrageColor = false

					if specSettings.endOf.dragonrage.enabled then
						useEndOfDragonrageColor = true
						if specSettings.endOf.dragonrage.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							dragonrageTimeThreshold = gcd * specSettings.endOf.dragonrage.gcdsMax
						elseif specSettings.endOf.dragonrage.mode == "time" then
							dragonrageTimeThreshold = specSettings.endOf.dragonrage.timeMax
						end
					end

					if useEndOfDragonrageColor and dragonrageTimeLeft <= dragonrageTimeThreshold then
						-- Dragonrage is ending soon
						barColor = specSettings.colors.bar.dragonrageEnd.color
					else
						-- Dragonrage is active
						barColor = specSettings.colors.bar.dragonrage.color
					end
				end

				if snapshotData.attributes.essenceBurstActive then
					if specSettings.colors.bar.essenceBurst.enabled then
						barBorderColor = specSettings.colors.bar.essenceBurst.color
					end
				end

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings) or refreshText

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
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.preservation
		local specCacheSettings = TRB.Data.specCache.evoker_preservation.settings
		UpdateSnapshot_Preservation()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" and primaryNode then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
				local currentResource = snapshotData.attributes.resourceModified
				local barBorderColor = specSettings.colors.bar.border.color
				local barColor = specSettings.colors.bar.base.color

				if snapshotData.attributes.essenceBurstActive then
					if specSettings.colors.bar.essenceBurst.enabled then
						barBorderColor = specSettings.colors.bar.essenceBurst.color
					end
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings) or refreshText

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
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.augmentation
		local specCacheSettings = TRB.Data.specCache.evoker_augmentation.settings
		UpdateSnapshot_Augmentation()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" and primaryNode then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				-- Ebon Might bar color changes
				if snapshots[spells.ebonMight.id].buff.isActive then
					local ebonMightTimeLeft = snapshots[spells.ebonMight.id].buff.remaining
					local ebonMightTimeThreshold = 0
					local useEndOfEbonMightColor = false

					if specSettings.endOf.ebonMight.enabled then
						useEndOfEbonMightColor = true
						if specSettings.endOf.ebonMight.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							ebonMightTimeThreshold = gcd * specSettings.endOf.ebonMight.gcdsMax
						elseif specSettings.endOf.ebonMight.mode == "time" then
							ebonMightTimeThreshold = specSettings.endOf.ebonMight.timeMax
						end
					end

					-- Check if casting an ability that extends Ebon Might but won't finish before it expires
					local castTimeRemaining = 0
					if snapshotData.attributes.extendsEbonMight and snapshotData.casting.endTime ~= nil then
						castTimeRemaining = snapshotData.casting.endTime - currentTime
						if castTimeRemaining < 0 then
							castTimeRemaining = 0
						end
					end

					if specSettings.colors.bar.ebonMightDropDuringCast.enabled and snapshotData.attributes.extendsEbonMight and castTimeRemaining > ebonMightTimeLeft then
						-- Cast will finish after Ebon Might expires
						barColor = specSettings.colors.bar.ebonMightDropDuringCast.color

						-- Play audio cue for ending soon
						if specSettings.audio.ebonMightEnding.enabled and not snapshotData.audio.playedEbonMightCue then
							snapshotData.audio.playedEbonMightCue = true
							PlaySoundFile(specSettings.audio.ebonMightEnding.sound, coreSettings.audio.channel.channel)
						end
					elseif useEndOfEbonMightColor and specSettings.colors.bar.ebonMightEnd.enabled and ebonMightTimeLeft <= ebonMightTimeThreshold then
						-- Ebon Might is ending soon
						barColor = specSettings.colors.bar.ebonMightEnd.color
					elseif specSettings.colors.bar.ebonMight.enabled then
						-- Ebon Might is active
						barColor = specSettings.colors.bar.ebonMight.color
						snapshotData.audio.playedEbonMightCue = false
					end
				else
					snapshotData.audio.playedEbonMightCue = false
				end

				if snapshotData.attributes.essenceBurstActive then
					if specSettings.colors.bar.essenceBurst.enabled then
						barBorderColor = specSettings.colors.bar.essenceBurst.color
					end
				end

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings) or refreshText

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
	if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
		TRB.Functions.Bar:QueueRenderTransition("switchSpec", 0.8)
	elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
		TRB.Functions.Bar:HideResourceBar(true)
	end
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	if TRB.Data.character.specId == 1 then
		specCache.evoker_devastation.talents:GetTalents()
		FillSpellData_Devastation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.evoker_devastation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData		

		TRB.Functions.RefreshLookupData = RefreshLookupData_Devastation
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.evoker_devastation.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#dragonrage"] = spells.dragonrage.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "evoker_devastation" then
			talents = specCache.evoker_devastation.talents
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "evoker_devastation"
			ConstructResourceBar(specCache.evoker_devastation.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.evoker_preservation.talents:GetTalents()
		FillSpellData_Preservation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.evoker_preservation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Preservation
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.evoker_preservation.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "evoker_preservation" then
			talents = specCache.evoker_devastation.talents
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "evoker_preservation"
			ConstructResourceBar(specCache.evoker_preservation.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.evoker_augmentation.talents:GetTalents()
		FillSpellData_Augmentation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.evoker_augmentation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Augmentation
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.evoker_augmentation.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ebonMight"] = spells.ebonMight.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "evoker_augmentation" then
			talents = specCache.evoker_augmentation.talents
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "evoker_augmentation"
			ConstructResourceBar(specCache.evoker_augmentation.settings)
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
	
	if TRB.Data.character.classId == 13 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Evoker.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.devastation == nil or
						TwintopInsanityBarSettings.evoker.devastation.displayText == nil then
						settings.evoker.devastation.displayText.barText = TRB.Options.Evoker.DevastationLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.preservation == nil or
						TwintopInsanityBarSettings.evoker.preservation.displayText == nil then
						settings.evoker.preservation.displayText.barText = TRB.Options.Evoker.PreservationLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.augmentation == nil or
						TwintopInsanityBarSettings.evoker.augmentation.displayText == nil then
						settings.evoker.augmentation.displayText.barText = TRB.Options.Evoker.AugmentationLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.evoker ~= true then
						TRB.Data.settings.evoker.devastation.displayText.barText = TRB.Options.Evoker.DevastationLoadDefaultBarTextSettings()
						TRB.Data.settings.evoker.preservation.displayText.barText = TRB.Options.Evoker.PreservationLoadDefaultBarTextSettings()
						TRB.Data.settings.evoker.augmentation.displayText.barText = TRB.Options.Evoker.AugmentationLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.evoker = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Evoker"])
					end
				else
					local settings = TRB.Options.Evoker.LoadDefaultSettings(true)
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
						TRB.Data.settings.core = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["GlobalOptions"], TRB.Data.settings.core)
						TRB.Data.settings.evoker.devastation = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["EvokerDevastationFull"], TRB.Data.settings.evoker.devastation)
						TRB.Data.settings.evoker.preservation = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["EvokerPreservationFull"], TRB.Data.settings.evoker.preservation)
						TRB.Data.settings.evoker.augmentation = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["EvokerAugmentationFull"], TRB.Data.settings.evoker.augmentation)
						
						FillSpellData_Devastation()
						FillSpellData_Preservation()
						FillSpellData_Augmentation()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Evoker.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "evoker"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", TRB.Data.resource, false)
	TRB.Data.character.maxResource2 = 1
	TRB.Data.resource2 = Enum.PowerType.Essence
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "devastation"
		TRB.Data.character.compositeKey = "evoker_devastation"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		TRB.Data.character.specName = "preservation"
		TRB.Data.character.compositeKey = "evoker_preservation"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "augmentation"
		TRB.Data.character.compositeKey = "evoker_augmentation"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	end

	if sharedSettings ~= nil then
		--if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
				TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
			end
		--end
	end
end

function TRB.Functions.Class:EventRegistration()
	TRB.Functions.Class:EnableEvents()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.evoker.devastation then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.evoker.preservation then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.evoker.augmentation then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
		TRB.Functions.Class:DisableEvents()
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
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
			-- All Evoker specs use the secondary (Essence) bar
			local showSecondary = false
			if not forceHideAll then
				if sharedSettings.displayBar.secondary.visibility == "always" then
					showSecondary = true
				elseif sharedSettings.displayBar.secondary.visibility == "combat" then
					showSecondary = affectingCombat or inVehicle
				end
				-- "never" means showSecondary stays false
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

			-- Track if either bar is showing
			snapshotData.attributes.isTracking = showPrimary or showSecondary or showHealth
			if snapshotData.attributes.isTracking then
				TRB.Functions.BarText:Show(sharedSettings)
			else
				TRB.Functions.BarText:Hide(sharedSettings)
			end
		else
			-- No settings - hide everything
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.secondary then
				barGroups.secondary:Hide()
			end
			if barGroups and barGroups.health then
				barGroups.health:Hide()
			end
			snapshotData.attributes.isTracking = false
		end
	else
		-- Unsupported spec - hide everything
		if barGroups and barGroups.primary then
			barGroups.primary:Hide()
		end
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
		if barGroups and barGroups.health then
			barGroups.health:Hide()
		end
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end

	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		settings = TRB.Data.settings.evoker.devastation
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		settings = TRB.Data.settings.evoker.preservation
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		settings = TRB.Data.settings.evoker.augmentation
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Devastation
		if var == "$dragonrageTime" then
			if snapshots[spells.dragonrage.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 2 then --Preservation
	elseif TRB.Data.character.specId == 3 then -- Augmentation
		if var == "$ebonMightTime" then
			if snapshots[spells.ebonMight.id].buff.isActive then
				valid = true
			end
		end
	end

	-- Chronowarden
	if TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
	end

	-- Scalecommander
	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 3 then
	end

	--Spec agnostic
	if var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$resource" or var == "$mana" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourcePercent" or var == "$manaPercent" then
		-- Do not compare resource percent as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$manaMax" then
		valid = true
	elseif var == "$comboPoints" or var == "$essence" then
		valid = true
	elseif var == "$essenceRegenTime" then
		if snapshotData.attributes.resource2 < TRB.Data.character.maxResource2 then
			valid = true
		end
	elseif var == "$comboPointsMax"or var == "$essenceMax" then
		valid = true
	elseif var == "$health" or var == "$healthMax" or var == "$healthPercent" or var == "$absorb" or var == "$incomingHeal" then
		valid = true
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
	if relativeToFrame ~= nil then
		relativeToFrame = string.gsub(relativeToFrame, "_", "")
	end
	if relativeToFrame == "ResourceBar" or relativeToFrame == "Resource" then
		if barGroups and barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
				return primaryNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame ~= nil then
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local essenceNode = barGroups.secondary:GetNode(index)
				if essenceNode then
					local isVisible = barGroups.secondary.isVisible and essenceNode.isVisible
					return essenceNode:GetFrame(), true, isVisible
				end
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
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end