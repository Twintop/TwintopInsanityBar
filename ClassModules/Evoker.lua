local _, TRB = ...
if TRB.Data.character.classId ~= 13 then --Only do this if we're on an Evoker!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}
local lookupChanged = TRB.Functions.BarText.LookupChanged
local Threshold = TRB.Functions.Threshold
local Bar = TRB.Functions.Bar
local Color = TRB.Functions.Color
local Character = TRB.Functions.Character
local frameLevels = TRB.Data.constants.frameLevels

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
	---@type TRB.Classes.Snapshot
	specCache.evoker_devastation.snapshotData.snapshots[spells.essenceBurst.id] = TRB.Classes.Snapshot:New(spells.essenceBurst)

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
	---@type TRB.Classes.Snapshot
	specCache.evoker_preservation.snapshotData.snapshots[spells.essenceBurst.id] = TRB.Classes.Snapshot:New(spells.essenceBurst)

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
	---@type TRB.Classes.Snapshot
	specCache.evoker_augmentation.snapshotData.snapshots[spells.essenceBurst.id] = TRB.Classes.Snapshot:New(spells.essenceBurst)

	specCache.evoker_augmentation.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Devastation()
	Character:FillSpecializationCacheSettings("evoker", "devastation")

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "evoker_devastation" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(1)
	end
end

local function FillSpellData_Devastation()
	Setup_Devastation()
	specCache.evoker_devastation.spellsData:FillSpellData()
	TRB.Classes.Evoker.DevastationSpells.FillBarTextVariables(specCache.evoker_devastation)
end

local function Setup_Preservation()
	Character:FillSpecializationCacheSettings("evoker", "preservation", true)

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "evoker_preservation" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Evoker.BarGroupsFactory:CreateForSpec(2)
	end
end

local function FillSpellData_Preservation()
	Setup_Preservation()
	specCache.evoker_preservation.spellsData:FillSpellData()
	TRB.Classes.Evoker.PreservationSpells.FillBarTextVariables(specCache.evoker_preservation)
end

local function Setup_Augmentation()
	Character:FillSpecializationCacheSettings("evoker", "augmentation")

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "evoker_augmentation" then
		Bar:DestroyBarGroups()
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

-- Essence regen tracking.
-- As of 12.0.5, GetPowerRegenForPowerType(Enum.PowerType.Essence) returns a
-- secret value. We approximate the rate ourselves by snapshotting the times at
-- which the integer Essence count last ticked up.
--
-- Snapshots:
--   oneEssenceAgo  : GetTime() when we reached (current - 1) Essence.
--   mostRecent     : GetTime() when we reached the current Essence count.
--   duration       : mostRecent - oneEssenceAgo (seconds per Essence).
--                    Defaults to the unhasted 5s baseline until we have
--                    observed at least one non-capped tick.
--   previousEssence: the Essence count from the previous call. We only
--                    recompute `duration` on a gain when previousEssence was
--                    NOT capped, because sitting at cap inflates the measured
--                    gap on the next tick after a spend.
--   previousPartial: UnitPartialPower reading from the previous call. Used
--                    to recover the pre-tick partial, because Blizzard now
--                    resets partial power to 0 on an Essence level change.
--   partialCarry   : the previousPartial value captured at the moment the
--                    Essence level changed. Added to subsequent raw readings
--                    (capped at 1000) to reconstruct a continuous 0-1000
--                    progress value into the next Essence tick.
local essenceTiming = {
	oneEssenceAgo = nil,
	mostRecent = nil,
	duration = 5.0,
	previousEssence = nil,
	previousPartial = 0,
	partialCarry = 0,
}

local function UpdateEssenceTiming()
	local currentTime = GetTime()
	local resource2 = TRB.Data.snapshotData.attributes.resource2 or 0
	local maxResource2 = TRB.Data.character.maxResource2 or 5
	local rawPartial = UnitPartialPower("player", Enum.PowerType.Essence) or 0

	if essenceTiming.previousEssence == nil then
		-- First observation. We can't seed a learned duration: haste is secret
		-- and GetPowerRegenForPowerType for Essence is secret. Keep the 5s
		-- baseline and wait for a real tick to learn from.
		essenceTiming.previousEssence = resource2
		essenceTiming.mostRecent = currentTime
		essenceTiming.previousPartial = rawPartial
		essenceTiming.partialCarry = 0
		TRB.Data.snapshotData.attributes.essencePartial = rawPartial
		return
	end

	if resource2 ~= essenceTiming.previousEssence then
		-- Blizzard resets partial power to 0 on an Essence level change, so
		-- the "real" partial progress into the next tick right now is actually
		-- the partial we observed on the previous frame (just before the
		-- reset). Capture it as a carry that we add to subsequent readings
		-- until the next level change.
		essenceTiming.partialCarry = essenceTiming.previousPartial

		if resource2 < essenceTiming.previousEssence then
			if essenceTiming.previousEssence == maxResource2 then
				-- Spent some Essence after being capped. This means the most recent
				-- tick was a real gain, so we can learn from it.
				essenceTiming.oneEssenceAgo = nil
				essenceTiming.mostRecent = currentTime
			end
		elseif resource2 == maxResource2 then
			-- Gained to cap. Start tracking from here, but don't update the
			-- duration until we see a real gain after this.
			essenceTiming.oneEssenceAgo = essenceTiming.mostRecent
			essenceTiming.mostRecent = currentTime
			essenceTiming.duration = essenceTiming.mostRecent - essenceTiming.oneEssenceAgo
			essenceTiming.partialCarry = 0
		else
			-- Gained some Essence but not to cap. This is a real gain, so update
			-- the timestamps and duration.
			essenceTiming.oneEssenceAgo = essenceTiming.mostRecent
			essenceTiming.mostRecent = currentTime
			essenceTiming.duration = essenceTiming.mostRecent - essenceTiming.oneEssenceAgo
			essenceTiming.partialCarry = 0
		end
		essenceTiming.previousEssence = resource2
	end

	-- Reconstruct the effective partial by adding the carry, capping at 1000.
	local effectivePartial = rawPartial + essenceTiming.partialCarry
	if effectivePartial > 1000 then
		effectivePartial = 1000
	end
	TRB.Data.snapshotData.attributes.essencePartial = effectivePartial
	essenceTiming.previousPartial = rawPartial
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
				Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Configure secondary bar for Essence (all specs)
	-- Set up structure, but let HideResourceBar() determine visibility
	if barGroups and barGroups.secondary then
		barGroups.secondary:SetNodeCount(TRB.Data.character.maxResource2 or 5)
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Devastation()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local sharedSettings = TRB.Data.specCache["evoker_devastation"].settings
	UpdateEssenceTiming()

	-- Side-effects: must remain ungated
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen = essenceTiming.duration
	-- essencePartial is set by UpdateEssenceTiming above (with carry-over applied).

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $manaMax, $resourceMax, $manaPercent, $resourcePercent, $casting)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = snapshotData.attributes.resource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = formatted
			lookup["$resource"] = formatted
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = formatted
			lookup["$resourceMax"] = formatted
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = formatted
			lookup["$resourcePercent"] = formatted
		end
	end

	-- Block B: Essence ($essence, $comboPoints, $essenceRegenTime, $essenceMax, $comboPointsMax)
	if not activeVars or activeVars["$essence"] or activeVars["$comboPoints"]
		or activeVars["$essenceRegenTime"]
		or activeVars["$essenceMax"] or activeVars["$comboPointsMax"] then
		local _latency = (select(4, GetNetStats()) or 0) / 1000
		local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen - _latency
		if _essenceRegenTime < 0 then _essenceRegenTime = 0 end
		if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
			_essenceRegenTime = 0
		end

		lookupLogic["$essence"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$essenceRegenTime"] = _essenceRegenTime
		lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$essence"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		if lookupChanged(prevState, "$essenceRegenTime", _essenceRegenTime) then
			lookup["$essenceRegenTime"] = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)
		end
		lookup["$essenceMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Dragonrage ($dragonrageTime)
	if not activeVars or activeVars["$dragonrageTime"] then
		local currentTime = GetTime()
		local _dragonrageTime = snapshotData.snapshots[spells.dragonrage.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$dragonrageTime"] = _dragonrageTime

		if lookupChanged(prevState, "$dragonrageTime", _dragonrageTime) then
			lookup["$dragonrageTime"] = TRB.Functions.BarText:TimerPrecision(_dragonrageTime)
		end
	end

	-- Block D: Essence Burst ($essenceBurstTime, $essenceBurstStacks)
	if not activeVars or activeVars["$essenceBurstTime"] or activeVars["$essenceBurstStacks"] then
		local currentTime = GetTime()
		local essenceBurstBuff = snapshotData.snapshots[spells.essenceBurst.id].buff
		local _essenceBurstTime = essenceBurstBuff:GetRemainingTime(currentTime)
		local _essenceBurstStacks = (essenceBurstBuff.isActive and (essenceBurstBuff.applications or 0)) or 0

		lookupLogic["$essenceBurstTime"] = _essenceBurstTime
		lookupLogic["$essenceBurstStacks"] = _essenceBurstStacks

		if lookupChanged(prevState, "$essenceBurstTime", _essenceBurstTime) then
			lookup["$essenceBurstTime"] = TRB.Functions.BarText:TimerPrecision(_essenceBurstTime)
		end
		if lookupChanged(prevState, "$essenceBurstStacks", _essenceBurstStacks) then
			lookup["$essenceBurstStacks"] = string.format("%.0f", _essenceBurstStacks)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Preservation()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local sharedSettings = TRB.Data.specCache["evoker_preservation"].settings
	UpdateEssenceTiming()

	-- Side-effects: must remain ungated
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen = essenceTiming.duration
	-- essencePartial is set by UpdateEssenceTiming above (with carry-over applied).

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $manaMax, $resourceMax, $manaPercent, $resourcePercent, $casting)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then
		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = formatted
			lookup["$resource"] = formatted
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = formatted
			lookup["$resourceMax"] = formatted
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = formatted
			lookup["$resourcePercent"] = formatted
		end
	end

	-- Block B: Essence ($essence, $comboPoints, $essenceRegenTime, $essenceMax, $comboPointsMax)
	if not activeVars or activeVars["$essence"] or activeVars["$comboPoints"]
		or activeVars["$essenceRegenTime"]
		or activeVars["$essenceMax"] or activeVars["$comboPointsMax"] then
		local _latency = (select(4, GetNetStats()) or 0) / 1000
		local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen - _latency
		if _essenceRegenTime < 0 then _essenceRegenTime = 0 end
		if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
			_essenceRegenTime = 0
		end

		lookupLogic["$essence"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$essenceRegenTime"] = _essenceRegenTime
		lookupLogic["$essenceMax"] = TRB.Data.character.maxResource
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$essence"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		if lookupChanged(prevState, "$essenceRegenTime", _essenceRegenTime) then
			lookup["$essenceRegenTime"] = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)
		end
		lookup["$essenceMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Essence Burst ($essenceBurstTime, $essenceBurstStacks)
	if not activeVars or activeVars["$essenceBurstTime"] or activeVars["$essenceBurstStacks"] then
		local currentTime = GetTime()
		local essenceBurstBuff = snapshotData.snapshots[spells.essenceBurst.id].buff
		local _essenceBurstTime = essenceBurstBuff:GetRemainingTime(currentTime)
		local _essenceBurstStacks = (essenceBurstBuff.isActive and (essenceBurstBuff.applications or 0)) or 0

		lookupLogic["$essenceBurstTime"] = _essenceBurstTime
		lookupLogic["$essenceBurstStacks"] = _essenceBurstStacks

		if lookupChanged(prevState, "$essenceBurstTime", _essenceBurstTime) then
			lookup["$essenceBurstTime"] = TRB.Functions.BarText:TimerPrecision(_essenceBurstTime)
		end
		if lookupChanged(prevState, "$essenceBurstStacks", _essenceBurstStacks) then
			lookup["$essenceBurstStacks"] = string.format("%.0f", _essenceBurstStacks)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Augmentation()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local sharedSettings = TRB.Data.specCache["evoker_augmentation"].settings
	UpdateEssenceTiming()

	-- Side-effects: must remain ungated
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen = essenceTiming.duration
	-- essencePartial is set by UpdateEssenceTiming above (with carry-over applied).

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $manaMax, $resourceMax, $manaPercent, $resourcePercent, $casting)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = snapshotData.attributes.resource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = formatted
			lookup["$resource"] = formatted
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = formatted
			lookup["$resourceMax"] = formatted
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = formatted
			lookup["$resourcePercent"] = formatted
		end
	end

	-- Block B: Essence ($essence, $comboPoints, $essenceRegenTime, $essenceMax, $comboPointsMax)
	if not activeVars or activeVars["$essence"] or activeVars["$comboPoints"]
		or activeVars["$essenceRegenTime"]
		or activeVars["$essenceMax"] or activeVars["$comboPointsMax"] then
		local _latency = (select(4, GetNetStats()) or 0) / 1000
		local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen - _latency
		if _essenceRegenTime < 0 then _essenceRegenTime = 0 end
		if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
			_essenceRegenTime = 0
		end

		lookupLogic["$essence"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$essenceRegenTime"] = _essenceRegenTime
		lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$essence"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		if lookupChanged(prevState, "$essenceRegenTime", _essenceRegenTime) then
			lookup["$essenceRegenTime"] = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)
		end
		lookup["$essenceMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Ebon Might ($ebonMightTime)
	if not activeVars or activeVars["$ebonMightTime"] then
		local currentTime = GetTime()
		local _ebonMightTime = snapshotData.snapshots[spells.ebonMight.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$ebonMightTime"] = _ebonMightTime

		if lookupChanged(prevState, "$ebonMightTime", _ebonMightTime) then
			lookup["$ebonMightTime"] = TRB.Functions.BarText:TimerPrecision(_ebonMightTime)
		end
	end

	-- Block D: Essence Burst ($essenceBurstTime, $essenceBurstStacks)
	if not activeVars or activeVars["$essenceBurstTime"] or activeVars["$essenceBurstStacks"] then
		local currentTime = GetTime()
		local essenceBurstBuff = snapshotData.snapshots[spells.essenceBurst.id].buff
		local _essenceBurstTime = essenceBurstBuff:GetRemainingTime(currentTime)
		local _essenceBurstStacks = (essenceBurstBuff.isActive and (essenceBurstBuff.applications or 0)) or 0

		lookupLogic["$essenceBurstTime"] = _essenceBurstTime
		lookupLogic["$essenceBurstStacks"] = _essenceBurstStacks

		if lookupChanged(prevState, "$essenceBurstTime", _essenceBurstTime) then
			lookup["$essenceBurstTime"] = TRB.Functions.BarText:TimerPrecision(_essenceBurstTime)
		end
		if lookupChanged(prevState, "$essenceBurstStacks", _essenceBurstStacks) then
			lookup["$essenceBurstStacks"] = string.format("%.0f", _essenceBurstStacks)
		end
	end

	TRB.Data.lookup = lookup
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
					snapshots[spells.dragonrage.id].buff.attributes["empoweredCasts"] = (snapshots[spells.dragonrage.id].buff.attributes["empoweredCasts"] or 0) + 1
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
		elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_EMPOWER_STOP" then
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
	local essenceBurstSpell = essenceBurstSpells.essenceBurst
	local essenceBurstDetectionId = essenceBurstSpell.id
	local essenceBurstSnapshot = snapshotData.snapshots[essenceBurstDetectionId]

	if event == "SPELL_ACTIVATION_OVERLAY_SHOW" then
		local spellId = ...
		if spellId == essenceBurstDetectionId then -- Essence Burst
			local currentTime = GetTime()
			local wasActive = essenceBurstSnapshot ~= nil and essenceBurstSnapshot.buff.isActive

			if not wasActive then
				local specSettings = TRB.Data.settings.evoker[TRB.Data.character.specName]
				if specSettings.audio.essenceBurst.enabled and not snapshotData.audio.essenceBurstPlayed then
					PlaySoundFile(specSettings.audio.essenceBurst.sound, TRB.Data.settings.core.audio.channel.channel)
					snapshotData.audio.essenceBurstPlayed = true
				end
			end

			-- Stacks pinned to 1: redraw re-SHOWs would inflate an AddStack approach.
			-- Stack counting needs EB's per-stack overlay ids (etrace, like SoL 114255/128654).
			if essenceBurstSnapshot ~= nil then
				essenceBurstSnapshot.buff:InitializeCustom(essenceBurstSpell.duration, currentTime, true, 1)
			end
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_HIDE" then
		local spellId = ...
		if spellId == essenceBurstDetectionId then -- Essence Burst
			if essenceBurstSnapshot ~= nil then
				essenceBurstSnapshot.buff:Reset()
			end
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
	Character:UpdateSnapshot()
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	local currentTime = GetTime()

	-- Plain (non-secret) active flag for the Ebon Might bar's custom thresholds: the lines hide
	-- while the buff is down (see ebonMight thresholdActiveAttribute).
	if spells.ebonMight ~= nil and snapshots[spells.ebonMight.id] ~= nil then
		TRB.Data.snapshotData.attributes.ebonMightActive = snapshots[spells.ebonMight.id].buff.isActive == true
	end
end

---Updates Essence bar nodes with current values and colors
---@param specSettings table # The spec-specific settings
---@param specCacheSettings table # The spec cache settings
---@param essenceOverrides table? # Optional { bar = color?, border = color?, background = color? } from indicator system
local function UpdateEssence(specSettings, specCacheSettings, essenceOverrides)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if essenceOverrides and essenceOverrides.background then
		cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(essenceOverrides.background, true)
	end

	local barOverrideActive = essenceOverrides and essenceOverrides.bar
	local regeneratingColor = specSettings.colors.comboPoints.regenerating

	for x = 1, TRB.Data.character.maxResource2 do
		local cpBorderColor = (essenceOverrides and essenceOverrides.border) or specSettings.colors.comboPoints.border.color
		local cpColor = (barOverrideActive) or specSettings.colors.comboPoints.base

		local essenceValue = 0
		if snapshotData.attributes.resource2 >= x then
			essenceValue = 1000
			-- Color logic for penultimate/final (only when no indicator bar override)
			if not barOverrideActive then
				if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end
		elseif snapshotData.attributes.resource2 + 1 == x then
			essenceValue = snapshotData.attributes.essencePartial or UnitPartialPower("player", Enum.PowerType.Essence)
			if not barOverrideActive and essenceValue > 0 and essenceValue < 1000 then
				if regeneratingColor and regeneratingColor.enabled then
					cpColor = regeneratingColor
				elseif x == (TRB.Data.character.maxResource2 - 1) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end
		end

		if barGroups and barGroups.secondary then
			local essenceNode = barGroups.secondary:GetNode(x)
			if essenceNode then
				Bar:SetBarNodeValue(specCacheSettings, "essence" .. x, essenceNode, essenceValue, 1000)
				essenceNode:SetBorderColor(cpBorderColor)
				TRB.Functions.Color:ApplyFillColor(essenceNode, cpColor)
				essenceNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
				Bar:ApplyEndCapIndicator(essenceNode, "essences")
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
	Bar:HideResourceBar()

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	local function UpdateEssenceOuter(specSettings, specCacheSettings, essenceOverrides)
		local refreshTextEssence = false
		
		if not specSettings.displayBar.secondary.neverShow then
			refreshTextEssence = true
			UpdateEssence(specSettings, specCacheSettings, essenceOverrides)
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
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
			local barColor = specSettings.colors.bar.base
			local barBorderColor = specSettings.colors.bar.border.color
			local barBackgroundColor = specSettings.colors.bar.background.color

			-- Indicator color system
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			-- Precompute dragonrage end timing threshold
			local dragonrageActive = snapshots[spells.dragonrage.id].buff.isActive
			local dragonrageEndMet = false
			if dragonrageActive then
				local dragonrageTimeLeft = snapshots[spells.dragonrage.id].buff:GetRemainingTime(currentTime)
				local timeThreshold = 0
				if specSettings.endOf.dragonrage.mode == "gcd" then
					local gcd = Character:GetCurrentGCDTime()
					timeThreshold = gcd * specSettings.endOf.dragonrage.gcdsMax
				elseif specSettings.endOf.dragonrage.mode == "time" then
					timeThreshold = specSettings.endOf.dragonrage.timeMax
				end
				dragonrageEndMet = dragonrageTimeLeft <= timeThreshold
			end

			local conditionMap = {
				dragonrageEnd = dragonrageActive and dragonrageEndMet,
				dragonrage = dragonrageActive,
				essenceBurst = snapshots[spells.essenceBurst.id].buff.isActive,
			}

			-- Color targets: barKey -> elementKey -> current color
			local manaBarColors = { bar = barColor, border = barBorderColor, background = barBackgroundColor }
			local essenceColors = { bar = nil, border = nil, background = nil }
			local barColorMap = { manaBar = manaBarColors, essences = essenceColors }

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			-- Read final mana bar colors from the color map
			barColor = manaBarColors.bar
			barBorderColor = manaBarColors.border
			barBackgroundColor = manaBarColors.background

			if not specSettings.displayBar.primary.neverShow and primaryNode then
				refreshText = true
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)

				primaryNode:SetBorderColor(barBorderColor)
				TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings, essenceColors) or refreshText

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.preservation
		local specCacheSettings = TRB.Data.specCache.evoker_preservation.settings
		UpdateSnapshot_Preservation()

		if snapshotData.attributes.isTracking then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
			local barColor = specSettings.colors.bar.base
			local barBorderColor = specSettings.colors.bar.border.color
			local barBackgroundColor = specSettings.colors.bar.background.color

			-- Indicator color system
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			local conditionMap = {
				innervate = false,
				essenceBurst = snapshots[spells.essenceBurst.id].buff.isActive,
			}

			-- Color targets: barKey -> elementKey -> current color
			local manaBarColors = { bar = barColor, border = barBorderColor, background = barBackgroundColor }
			local essenceColors = { bar = nil, border = nil, background = nil }
			local barColorMap = { manaBar = manaBarColors, essences = essenceColors }

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			-- Read final mana bar colors from the color map
			barColor = manaBarColors.bar
			barBorderColor = manaBarColors.border
			barBackgroundColor = manaBarColors.background

			if not specSettings.displayBar.primary.neverShow and primaryNode then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")
				primaryNode:SetBorderColor(barBorderColor)
				TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings, essenceColors) or refreshText

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.augmentation
		local specCacheSettings = TRB.Data.specCache.evoker_augmentation.settings
		UpdateSnapshot_Augmentation()

		if snapshotData.attributes.isTracking then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
			local barColor = specSettings.colors.bar.base
			local barBorderColor = specSettings.colors.bar.border.color
			local barBackgroundColor = specSettings.colors.bar.background.color

			local ebonMightBarColors = specSettings.colors.bars and specSettings.colors.bars.ebonMight
			local ebonMightBarColor = ebonMightBarColors and ebonMightBarColors.bar.color
			local ebonMightBorderColor = ebonMightBarColors and ebonMightBarColors.border.color
			local ebonMightBackgroundColor = ebonMightBarColors and ebonMightBarColors.background.color

			-- Indicator color system
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			-- Precompute Ebon Might conditions
			local ebonMightActive = snapshots[spells.ebonMight.id].buff.isActive
			local ebonMightDropDuringCastMet = false
			local ebonMightEndMet = false
			if ebonMightActive then
				local ebonMightTimeLeft = snapshots[spells.ebonMight.id].buff:GetRemainingTime(currentTime)
				local timeThreshold = 0
				if specSettings.endOf.ebonMight.mode == "gcd" then
					local gcd = Character:GetCurrentGCDTime()
					timeThreshold = gcd * specSettings.endOf.ebonMight.gcdsMax
				elseif specSettings.endOf.ebonMight.mode == "time" then
					timeThreshold = specSettings.endOf.ebonMight.timeMax
				end
				ebonMightEndMet = ebonMightTimeLeft <= timeThreshold

				-- Check if casting an ability that extends Ebon Might but won't finish before it expires
				local castTimeRemaining = 0
				if snapshotData.attributes.extendsEbonMight and snapshotData.casting.endTime ~= nil then
					castTimeRemaining = snapshotData.casting.endTime - currentTime
					if castTimeRemaining < 0 then
						castTimeRemaining = 0
					end
				end
				ebonMightDropDuringCastMet = snapshotData.attributes.extendsEbonMight and castTimeRemaining > ebonMightTimeLeft
			end

			-- Audio cue for Ebon Might dropping during cast
			if ebonMightActive and ebonMightDropDuringCastMet then
				if specSettings.audio.ebonMightEnding.enabled and not snapshotData.audio.playedEbonMightCue then
					snapshotData.audio.playedEbonMightCue = true
					PlaySoundFile(specSettings.audio.ebonMightEnding.sound, coreSettings.audio.channel.channel)
				end
			else
				snapshotData.audio.playedEbonMightCue = false
			end

			local conditionMap = {
				ebonMightDropDuringCast = ebonMightActive and ebonMightDropDuringCastMet,
				ebonMightEnd = ebonMightActive and ebonMightEndMet,
				ebonMight = ebonMightActive,
				essenceBurst = snapshots[spells.essenceBurst.id].buff.isActive,
			}

			-- Color targets: barKey -> elementKey -> current color
			local manaBarColors = { bar = barColor, border = barBorderColor, background = barBackgroundColor }
			local essenceColors = { bar = nil, border = nil, background = nil }
			local ebonMightColors = { bar = ebonMightBarColor, border = ebonMightBorderColor, background = ebonMightBackgroundColor }
			local barColorMap = { manaBar = manaBarColors, essences = essenceColors, ebonMight = ebonMightColors }

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			-- Read final mana bar colors from the color map
			barColor = manaBarColors.bar
			barBorderColor = manaBarColors.border
			barBackgroundColor = manaBarColors.background

			if not specSettings.displayBar.primary.neverShow and primaryNode then
				refreshText = true
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				local currentResource = snapshotData.attributes.resourceModified

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)

				primaryNode:SetBorderColor(barBorderColor)
				TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			-- Update Ebon Might bar
			if specSettings.displayBar.ebonMight ~= nil and not specSettings.displayBar.ebonMight.neverShow then
				refreshText = true
				local ebonMightNode = barGroups and barGroups.ebonMight and barGroups.ebonMight:GetNode(1)
				if ebonMightNode then
					local ebonMightSnapshot = snapshots[spells.ebonMight.id]
					local ebonMightDuration = ebonMightSnapshot.buff.duration or 1
					local ebonMightRemaining = 0

					if ebonMightSnapshot.buff.isActive then
						ebonMightRemaining = ebonMightSnapshot.buff:GetRemainingTime(currentTime)
					end

					ebonMightNode:SetMinMax(0, ebonMightDuration)
					ebonMightNode:SetValue(ebonMightRemaining)

					if ebonMightBarColors then
						TRB.Functions.Color:ApplyFillColor(ebonMightNode, ebonMightColors.bar)
						ebonMightNode:SetBorderColor(ebonMightColors.border)
						ebonMightNode:SetBackgroundColorFromString(ebonMightColors.background)
						Bar:ApplyEndCapIndicator(ebonMightNode, "ebonMight")
					end
				end
			end

			refreshText = UpdateEssenceOuter(specSettings, specCacheSettings, essenceColors) or refreshText

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
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
		Bar:QueueRenderTransition("switchSpec", 0.8)
	elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
		Bar:HideResourceBar(true)
	end
	Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	if TRB.Data.character.specId == 1 then
		specCache.evoker_devastation.talents:GetTalents()
		FillSpellData_Devastation()
		Character:LoadFromSpecializationCache(specCache.evoker_devastation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData		

		TRB.Functions.RefreshLookupData = RefreshLookupData_Devastation
		Bar:UpdateSanityCheckValues(specCache.evoker_devastation.settings)

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
		Character:LoadFromSpecializationCache(specCache.evoker_preservation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Preservation
		Bar:UpdateSanityCheckValues(specCache.evoker_preservation.settings)

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
		Character:LoadFromSpecializationCache(specCache.evoker_augmentation)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Augmentation
		Bar:UpdateSanityCheckValues(specCache.evoker_augmentation.settings)

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
				Character:ResetCaches()
				-- Ensure health values are populated so the health bar displays immediately
				Character:UpdateHealthValues()
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

					-- Clear core barText defaults before merge so the user's saved list (even if empty)
					-- takes precedence. Only skip when no saved core displayText exists (first-run seeding).
					if TwintopInsanityBarSettings.core
						and TwintopInsanityBarSettings.core.displayText
						and TwintopInsanityBarSettings.core.displayText.barText then
						settings.core.displayText.barText = {}
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
					Bar:QueueRenderTransition("eventPreSwitch", 0.8)
				elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
					Bar:HideResourceBar(true)
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
	Character:CheckCharacter()
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
				Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
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

	Character:EventRegistration()
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

		local hasEbonMight = TRB.Data.character.specId == 3

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, true, TRB.Data.character.maxResource2, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.ebonMight, sharedSettings and sharedSettings.displayBar.ebonMight, hasEbonMight, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, sharedSettings and sharedSettings.displayBar.health, true, 1, nil),
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

function TRB.Functions.Class:ResetProcsOnDeath()
	local snapshotData = TRB.Data.snapshotData
	if snapshotData and snapshotData.attributes then
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells and spells.essenceBurst and snapshotData.snapshots then
			local essenceBurstSnapshot = snapshotData.snapshots[spells.essenceBurst.id]
			if essenceBurstSnapshot ~= nil then
				essenceBurstSnapshot.buff:Reset()
			end
		end
		snapshotData.attributes.extendsEbonMight = false
	end
end

local specValidVars
do
	local castingFn = function()
		local c = TRB.Data.snapshotData.casting
		return c.resourceRaw ~= nil and c.resourceRaw ~= 0
	end
	local essenceRegenFn = function()
		return TRB.Data.snapshotData.attributes.resource2 < TRB.Data.character.maxResource2
	end
	local essenceBurstFn = function()
		local spells = TRB.Data.spellsData.spells
		return spells and spells.essenceBurst and TRB.Data.snapshotData.snapshots[spells.essenceBurst.id].buff.isActive
	end
	local common = {
		["$casting"] = castingFn,
		["$resource"] = false, ["$mana"] = false,
		["$resourcePercent"] = false, ["$manaPercent"] = false,
		["$resourceMax"] = true, ["$manaMax"] = true,
		["$comboPoints"] = true, ["$essence"] = true,
		["$essenceRegenTime"] = essenceRegenFn,
		["$comboPointsMax"] = true, ["$essenceMax"] = true,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
		["$essenceBurstTime"] = essenceBurstFn,
		["$essenceBurstStacks"] = essenceBurstFn,
	}
	-- Devastation
	local devastation = {}
	for k, v in pairs(common) do devastation[k] = v end
	devastation["$dragonrageTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.dragonrage.id].buff.isActive
	end
	-- Augmentation
	local augmentation = {}
	for k, v in pairs(common) do augmentation[k] = v end
	augmentation["$ebonMightTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.ebonMight.id].buff.isActive
	end

	specValidVars = { [1] = devastation, [2] = common, [3] = augmentation }
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
	elseif relativeToFrame == "EbonMightBar" then
		if barGroups and barGroups.ebonMight then
			local ebonMightNode = barGroups.ebonMight:GetNode(1)
			if ebonMightNode then
				local isVisible = barGroups.ebonMight.isVisible and ebonMightNode.isVisible
				return ebonMightNode:GetFrame(), true, isVisible
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

---Returns true when Essence is regenerating (not at max) or a spec buff is active.
---Devastation: $essenceRegenTime, $dragonrageTime; Preservation: $essenceRegenTime;
---Augmentation: $essenceRegenTime, $ebonMightTime.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local snapshotData = TRB.Data.snapshotData
	if not snapshotData then return false end
	-- All 3 specs: essence regeneration is time-dependent when not at max
	local resource2 = snapshotData.attributes.resource2
	local maxResource2 = TRB.Data.character.maxResource2
	if resource2 ~= nil and maxResource2 ~= nil and resource2 < maxResource2 then
		return true
	end
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
	if not spells then return false end
	local snapshots = snapshotData.snapshots
	local specId = TRB.Data.character.specId
	if specId == 1 then -- Devastation
		if spells.dragonrage and snapshots[spells.dragonrage.id] and snapshots[spells.dragonrage.id].buff and snapshots[spells.dragonrage.id].buff.isActive then
			return true
		end
	elseif specId == 3 then -- Augmentation
		if spells.ebonMight and snapshots[spells.ebonMight.id] and snapshots[spells.ebonMight.id].buff and snapshots[spells.ebonMight.id].buff.isActive then
			return true
		end
	end
	-- All 3 specs: Essence Burst is active
	if spells.essenceBurst and snapshots[spells.essenceBurst.id] and snapshots[spells.essenceBurst.id].buff and snapshots[spells.essenceBurst.id].buff.isActive then
		return true
	end
	return false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Functions.Bar and TRB.Functions.Bar.IsRenderTransitionActive and Bar:IsRenderTransitionActive() then
		Bar:HideResourceBar(true)
		return
	end

	if not TRB.Data.specSupported or talents == nil then
		return
	end
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end