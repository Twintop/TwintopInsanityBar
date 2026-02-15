local _, TRB = ...
if TRB.Data.character.classId ~= 5 then --Only do this if we're on a Priest!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

-- Frame for handling Sustained Potency pause events (PLAYER_CONTROL_LOST/GAINED, PLAYER_REGEN_ENABLED/DISABLED)
local sustainedPotencyFrame = CreateFrame("Frame")

---Handles Sustained Potency pause events for Voidform
---@param self any
---@param event string
local function SustainedPotencyEventHandler(self, event)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	if snapshotData == nil then
		return
	end

	local spellsData = TRB.Data.spellsData
	if spellsData == nil or spellsData.spells == nil then
		return
	end

	local buff = nil

	if TRB.Data.character.specId == 2 then
		---@type TRB.Classes.Priest.HolySpells
		local spells = spellsData.spells
		
		local apotheosisSnapshot = snapshotData.snapshots[spells.apotheosis.id]
		if apotheosisSnapshot == nil then
			return
		end

		buff = apotheosisSnapshot.buff
	elseif TRB.Data.character.specId == 3 then
		---@type TRB.Classes.Priest.ShadowSpells
		local spells = spellsData.spells

		local voidformSnapshot = snapshotData.snapshots[spells.voidform.id]
		if voidformSnapshot == nil then
			return
		end

		buff = voidformSnapshot.buff
	end

	if buff == nil or not buff.isActive then
		return
	end

	if event == "PLAYER_CONTROL_LOST" or event == "PLAYER_REGEN_ENABLED" then
		-- Enter pause mode when losing control or exiting combat
		buff:EnterPauseMode()
	elseif event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_REGEN_DISABLED" then
		-- Exit pause mode when regaining control or entering combat
		buff:ExitPauseMode()
	end
end

sustainedPotencyFrame:SetScript("OnEvent", SustainedPotencyEventHandler)

---Registers Sustained Potency events for Voidform pause tracking
local function RegisterSustainedPotencyEvents()
	sustainedPotencyFrame:RegisterEvent("PLAYER_CONTROL_LOST")
	sustainedPotencyFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
	sustainedPotencyFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	sustainedPotencyFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
end

---Unregisters Sustained Potency events
local function UnregisterSustainedPotencyEvents()
	sustainedPotencyFrame:UnregisterEvent("PLAYER_CONTROL_LOST")
	sustainedPotencyFrame:UnregisterEvent("PLAYER_CONTROL_GAINED")
	sustainedPotencyFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	sustainedPotencyFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

---@type TRB.Classes.Talents
local talents

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	priest_discipline = TRB.Classes.SpecCache:New(),
	priest_holy = TRB.Classes.SpecCache:New(),
	priest_shadow = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Discipline
	specCache.priest_discipline.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
		isPvp = false
	}

	specCache.priest_discipline.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}
	
	specCache.priest_discipline.spellsData.spells = TRB.Classes.Priest.DisciplineSpells:New()
	---@type TRB.Classes.Priest.DisciplineSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.priest_discipline.spellsData.spells

	specCache.priest_discipline.snapshotData.attributes.manaRegen = 0
	specCache.priest_discipline.snapshotData.audio = {
		innervateCue = false,
		surgeOfLightPlayed = false
	}
	--[[---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.powerWordRadiance.id] = TRB.Classes.Snapshot:New(spells.powerWordRadiance)
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.shadowCovenant.id] = TRB.Classes.Snapshot:New(spells.shadowCovenant)
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.entropicRift.id] = TRB.Classes.Snapshot:New(spells.entropicRift, {
		guid = nil,
		totemId = nil
	}, false, true)]]

	specCache.priest_discipline.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Holy
	specCache.priest_holy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
		isPvp = false
	}

	specCache.priest_holy.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.Priest.HolySpells
	specCache.priest_holy.spellsData.spells = TRB.Classes.Priest.HolySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.priest_holy.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]

	specCache.priest_holy.snapshotData.attributes.manaRegen = 0
	specCache.priest_holy.snapshotData.audio = {
		innervateCue = false,
		resonantWordsCue = false,
		lightweaverCue = false,
		surgeOfLightPlayed = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.apotheosis.id] = TRB.Classes.Snapshot:New(spells.apotheosis, nil, "sometimes")
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.sustainedPotency.id] = TRB.Classes.Snapshot:New(spells.sustainedPotency)
	--[[---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.resonantWords.id] = TRB.Classes.Snapshot:New(spells.resonantWords)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.lightweaver.id] = TRB.Classes.Snapshot:New(spells.lightweaver)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.holyWordSerenity.id] = TRB.Classes.Snapshot:New(spells.holyWordSerenity)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.holyWordSanctify.id] = TRB.Classes.Snapshot:New(spells.holyWordSanctify)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.holyWordChastise.id] = TRB.Classes.Snapshot:New(spells.holyWordChastise)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.sacredReverence.id] = TRB.Classes.Snapshot:New(spells.sacredReverence, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.answeredPrayers.id] = TRB.Classes.Snapshot:New(spells.answeredPrayers, nil, "always")]]

	-- Shadow
	specCache.priest_shadow.Global_TwintopResourceBar = {
		voidform = {
		},
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.priest_shadow.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		shadowWordMadnessThreshold = 50,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.Priest.ShadowSpells
	specCache.priest_shadow.spellsData.spells = TRB.Classes.Priest.ShadowSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.priest_shadow.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	specCache.priest_shadow.snapshotData.audio = {
		playedDpCue = false,
		playedMdCue = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.voidform.id] = TRB.Classes.Snapshot:New(spells.voidform, nil, "sometimes")
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.mindDevourer.id] = TRB.Classes.Snapshot:New(spells.mindDevourer)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.mindFlayInsanity.id] = TRB.Classes.Snapshot:New(spells.mindFlayInsanity)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.screamsOfTheVoid.id] = TRB.Classes.Snapshot:New(spells.screamsOfTheVoid)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.entropicRift.id] = TRB.Classes.Snapshot:New(spells.entropicRift)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.sustainedPotency.id] = TRB.Classes.Snapshot:New(spells.sustainedPotency)
	--[[
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.shatteredPsyche.id] = TRB.Classes.Snapshot:New(spells.shatteredPsyche)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.shadowyInsight.id] = TRB.Classes.Snapshot:New(spells.shadowyInsight)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.mindBlast.id] = TRB.Classes.Snapshot:New(spells.mindBlast)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.idolOfYoggSaron.id] = TRB.Classes.Snapshot:New(spells.idolOfYoggSaron)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.thingFromBeyond.id] = TRB.Classes.Snapshot:New(spells.thingFromBeyond)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.horrificVisions.id] = TRB.Classes.Snapshot:New(spells.horrificVisions)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.voidVolley.id] = TRB.Classes.Snapshot:New(spells.voidVolley)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.powerSurge.id] = TRB.Classes.Snapshot:New(spells.powerSurge)]]
end

local function Setup_Discipline()
	TRB.Functions.Character:FillSpecializationCacheSettings("priest", "discipline", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Discipline using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Priest.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_Discipline()
	Setup_Discipline()
	---@type TRB.Classes.SpellsData
	specCache.priest_discipline.spellsData:FillSpellData()
	local spells = specCache.priest_discipline.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]

	TRB.Classes.Priest.DisciplineSpells.FillBarTextVariables(specCache.priest_discipline)
end

local function Setup_Holy()
	TRB.Functions.Character:FillSpecializationCacheSettings("priest", "holy", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Holy using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Priest.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Holy()
	Setup_Holy()
	specCache.priest_holy.spellsData:FillSpellData()
	local spells = specCache.priest_holy.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]

	TRB.Classes.Priest.HolySpells.FillBarTextVariables(specCache.priest_holy)
end

local function Setup_Shadow()
	TRB.Functions.Character:FillSpecializationCacheSettings("priest", "shadow")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Shadow using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Priest.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Shadow()
	Setup_Shadow()
	specCache.priest_shadow.spellsData:FillSpellData()
	local spells = specCache.priest_shadow.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	TRB.Classes.Priest.ShadowSpells.FillBarTextVariables(specCache.priest_shadow)
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

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function CalculateHolyWordCooldown(base, spellId)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local mod = 1

	if snapshots[spells.apotheosis.id].buff.isActive then
		mod = mod * spells.apotheosis--[[@as TRB.Classes.Priest.HolyWordSpell]].holyWordModifier
	end

	return mod * (base)
end

local function CalculateResourceGain(resource)
	local modifier = 1.0

	return resource * modifier
end

local function RefreshLookupData_Discipline()
	local specSettings = TRB.Data.settings.priest.discipline
	local sharedSettings = TRB.Data.specCache["priest_discipline"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = sharedSettings.precision.mana or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- BreakUpLargeNumbers(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	--[[
	--$scTime
	local _scTime = snapshots[spells.shadowCovenant.id].buff:GetRemainingTime(currentTime)
	local scTime = TRB.Functions.BarText:TimerPrecision(_scTime)

	--$pwRadianceTime
	local _pwRadianceTime = snapshots[spells.powerWordRadiance.id].cooldown.remaining
	local pwRadianceTime = TRB.Functions.BarText:TimerPrecision(_pwRadianceTime)
	
	--$pwRadianceCharges
	local _pwRadianceCharges = snapshots[spells.powerWordRadiance.id].cooldown.charges
	local pwRadianceCharges = string.format("%.0f", _pwRadianceCharges)
	
	--$atonementMinTime
	local _atonementMinTime = snapshots[spells.atonement.id].attributes.minRemainingTime
	local atonementMinTime = TRB.Functions.BarText:TimerPrecision(_atonementMinTime)
	
	--$atonementMaxTime
	local _atonementMaxTime = snapshots[spells.atonement.id].attributes.maxRemainingTime
	local atonementMaxTime = TRB.Functions.BarText:TimerPrecision(_atonementMaxTime)

	
	--$atonementTime
	local _atonementTime = 0

	if target ~= nil then
		_atonementTime = target.spells[spells.atonement.id].remainingTime or 0
	end
	local atonementTime = TRB.Functions.BarText:TimerPrecision(_atonementTime)

	--$atonementCount
	local _atonementCount = snapshotData.targetData.count[spells.atonement.id] or 0
	local atonementCount = string.format("%s", _atonementCount)]]

	--[[--$entropicRiftTime
	local _entropicRiftTime = snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
	local entropicRiftTime = TRB.Functions.BarText:TimerPrecision(_entropicRiftTime)]]


	local lookup = TRB.Data.lookup
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	--[[
	lookup["$pwRadianceTime"] = pwRadianceTime
	lookup["$radianceTime"] = pwRadianceTime
	lookup["$powerWordRadianceTime"] = pwRadianceTime
	lookup["$pwRadianceCharges"] = pwRadianceCharges
	lookup["$radianceCharges"] = pwRadianceCharges
	lookup["$powerWordRadianceCharges"] = pwRadianceCharges
	lookup["$scTime"] = scTime
	lookup["$shadowCovenantTime"] = scTime
	lookup["$entropicRiftTime"] = entropicRiftTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	--[[
	lookupLogic["$pwRadianceTime"] = _pwRadianceTime
	lookupLogic["$radianceTime"] = _pwRadianceTime
	lookupLogic["$powerWordRadianceTime"] = _pwRadianceTime
	lookupLogic["$pwRadianceCharges"] = _pwRadianceCharges
	lookupLogic["$radianceCharges"] = _pwRadianceCharges
	lookupLogic["$powerWordRadianceCharges"] = _pwRadianceCharges
	lookupLogic["$scTime"] = _scTime
	lookupLogic["$shadowCovenantTime"] = _scTime
	lookupLogic["$entropicRiftTime"] = _entropicRiftTime]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Holy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.priest.holy
	local sharedSettings = TRB.Data.specCache["priest_holy"].settings
	---@type TRB.Classes.Target
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

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

	--[[
	--$hwChastiseTime
	local _hwChastiseTime = snapshots[spells.holyWordChastise.id].cooldown.remaining
	local hwChastiseTime = TRB.Functions.BarText:TimerPrecision(_hwChastiseTime)

	--$hwSanctifyTime
	local _hwSanctifyTime = snapshots[spells.holyWordSanctify.id].cooldown.remaining
	local hwSanctifyTime = TRB.Functions.BarText:TimerPrecision(_hwSanctifyTime)

	--$hwSerenityTime
	local _hwSerenityTime = snapshots[spells.holyWordSerenity.id].cooldown.remaining
	local hwSerenityTime = TRB.Functions.BarText:TimerPrecision(_hwSerenityTime)
	
	--$hwSanctifyCharges
	local _hwSanctifyCharges = snapshots[spells.holyWordSanctify.id].cooldown.charges
	local hwSanctifyCharges = string.format("%.0f", _hwSanctifyCharges)
	
	--$hwSerenityCharges
	local _hwSerenityCharges = snapshots[spells.holyWordSerenity.id].cooldown.charges
	local hwSerenityCharges = string.format("%.0f", _hwSerenityCharges)]]

	--$apotheosisTime
	local _apotheosisTime = snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)
	local apotheosisTime = TRB.Functions.BarText:TimerPrecision(_apotheosisTime)
	
	--[[--$answeredPrayersStacks
	local _answeredPrayersStacks = snapshots[spells.answeredPrayers.id].buff.applications or 0
	local answeredPrayersStacks = string.format("%.0f", _answeredPrayersStacks)
	--$answeredPrayersMaxStacks
	local _answeredPrayersMaxStacks = 0	
	if spells.answeredPrayers ~= nil and talents.talents[spells.answeredPrayers.talentId] ~= nil then
		_answeredPrayersMaxStacks = spells.answeredPrayers.attributes.maxStackRank[talents.talents[spells.answeredPrayers.talentId].currentRank] or 0
	end
	local answeredPrayersMaxStacks = string.format("%.0f", _answeredPrayersMaxStacks)
	--$answeredPrayersRemainingStacks
	local _answeredPrayersRemainingStacks = _answeredPrayersMaxStacks - _answeredPrayersStacks
	local answeredPrayersRemainingStacks = string.format("%.0f", _answeredPrayersRemainingStacks)

	--
	--$lightweaverStacks
	local _lightweaverStacks = snapshots[spells.lightweaver.id].buff.applications or 0
	local lightweaverStacks = string.format("%.0f", _lightweaverStacks)
	--$lightweaverTime
	local _lightweaverTime = snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime) or 0
	local lightweaverTime = TRB.Functions.BarText:TimerPrecision(_lightweaverTime)
	
	--$rwTime
	local _rwTime = snapshots[spells.resonantWords.id].buff:GetRemainingTime(currentTime) or 0
	local rwTime = TRB.Functions.BarText:TimerPrecision(_rwTime)
	
	--$lightweaverStacks
	local _sacredReverenceStacks = snapshots[spells.sacredReverence.id].buff.applications or 0
	local sacredReverenceStacks = string.format("%.0f", _sacredReverenceStacks)
	]]

	----------------

	local lookup = TRB.Data.lookup
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$apotheosisTime"] = apotheosisTime
	--[[
	lookup["$hwChastiseTime"] = hwChastiseTime
	lookup["$chastiseTime"] = hwChastiseTime
	lookup["$holyWordChastiseTime"] = hwChastiseTime
	lookup["$hwSanctifyTime"] = hwSanctifyTime
	lookup["$sanctifyTime"] = hwSanctifyTime
	lookup["$holyWordSanctifyTime"] = hwSanctifyTime
	lookup["$hwSerenityTime"] = hwSerenityTime
	lookup["$serenityTime"] = hwSerenityTime
	lookup["$holyWordSerenityTime"] = hwSerenityTime
	lookup["$hwSanctifyCharges"] = hwSanctifyCharges
	lookup["$sanctifyCharges"] = hwSanctifyCharges
	lookup["$holyWordSanctifyCharges"] = hwSanctifyCharges
	lookup["$hwSerenityCharges"] = hwSerenityCharges
	lookup["$serenityCharges"] = hwSerenityCharges
	lookup["$holyWordSerenityCharges"] = hwSerenityCharges
	lookup["$lightweaverStacks"] = lightweaverStacks
	lookup["$lightweaverTime"] = lightweaverTime
	lookup["$answeredPrayersStacks"] = answeredPrayersStacks
	lookup["$answeredPrayersMaxStacks"] = answeredPrayersMaxStacks
	lookup["$answeredPrayersRemainingStacks"] = answeredPrayersRemainingStacks
	lookup["$sacredReverenceStacks"] = sacredReverenceStacks
	lookup["$rwTime"] = rwTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$apotheosisTime"] = _apotheosisTime
	--[[
	lookupLogic["$hwChastiseTime"] = _hwChastiseTime
	lookupLogic["$chastiseTime"] = _hwChastiseTime
	lookupLogic["$holyWordChastiseTime"] = _hwChastiseTime
	lookupLogic["$hwSanctifyTime"] = _hwSanctifyTime
	lookupLogic["$sanctifyTime"] = _hwSanctifyTime
	lookupLogic["$holyWordSanctifyTime"] = _hwSanctifyTime
	lookupLogic["$hwSerenityTime"] = _hwSerenityTime
	lookupLogic["$serenityTime"] = _hwSerenityTime
	lookupLogic["$holyWordSerenityTime"] = _hwSerenityTime
	lookupLogic["$hwSanctifyCharges"] = _hwSanctifyCharges
	lookupLogic["$sanctifyCharges"] = _hwSanctifyCharges
	lookupLogic["$holyWordSanctifyCharges"] = _hwSanctifyCharges
	lookupLogic["$hwSerenityCharges"] = _hwSerenityCharges
	lookupLogic["$serenityCharges"] = _hwSerenityCharges
	lookupLogic["$holyWordSerenityCharges"] = _hwSerenityCharges
	lookupLogic["$lightweaverStacks"] = _lightweaverStacks
	lookupLogic["$lightweaverTime"] = _lightweaverTime
	lookupLogic["$answeredPrayersStacks"] = _answeredPrayersStacks
	lookupLogic["$answeredPrayersMaxStacks"] = _answeredPrayersMaxStacks
	lookupLogic["$answeredPrayersRemainingStacks"] = _answeredPrayersRemainingStacks
	lookupLogic["$sacredReverenceStacks"] = _sacredReverenceStacks
	lookupLogic["$rwTime"] = rwTime]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Shadow()
	local specSettings = TRB.Data.settings.priest.shadow
	local sharedSettings = TRB.Data.specCache["priest_shadow"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedInsanity = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	--$vfTime
	local _voidformTime = snapshots[spells.voidform.id].buff:GetRemainingTime(currentTime)
	local voidformTime = TRB.Functions.BarText:TimerPrecision(_voidformTime)

	local currentInsanityColor = sharedSettings.colors.text.current.color
	local castingInsanityColor = sharedSettings.colors.text.casting.color

	-- $shadowWordMadnessUsable
	local _shadowWordMadnessUsable = spells.shadowWordMadness:IsUsable() or spells.shadowWordMadness:IsFree()

	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled and _shadowWordMadnessUsable then
			currentInsanityColor = sharedSettings.colors.text.overThreshold.color
			--castingInsanityColor = sharedSettings.colors.text.overThreshold.color
		end
	end	

	--$insanity
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentInsanity = normalizedInsanity
	local currentInsanity
	--$casting
	local _castingInsanity = snapshotData.casting.resourceFinal
	local castingInsanity

	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentInsanityColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentInsanity = textColorResult:WrapTextInColorCode(_currentInsanity)
		castingInsanity = textColorResult:WrapTextInColorCode(TRB.Functions.Number:RoundTo(_castingInsanity, resourcePrecision, "floor"))
	else
		currentInsanity = string.format("|c%s%s|r", currentInsanityColor, _currentInsanity)-- TRB.Functions.Number:RoundTo(_currentInsanity, resourcePrecision, "floor"))
		castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_castingInsanity, resourcePrecision, "floor"))
	end
	
	--[[
	--$loiInsanity
	local _loiInsanity = snapshots[spells.idolOfCthun.id].attributes.resourceFinal
	local loiInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_loiInsanity, resourcePrecision, "floor"))
	--$loiTicks
	local _loiTicks = snapshots[spells.idolOfCthun.id].attributes.maxTicksRemaining
	local loiTicks = string.format("%.0f", _loiTicks)
	--$ecttvCount
	local _ecttvCount = snapshots[spells.idolOfCthun.id].attributes.numberActive
	local ecttvCount = string.format("%.0f", _ecttvCount)
	--$hvInsanity
	local _hvInsanity = snapshots[spells.horrificVisions.id].attributes.resourceFinal or 0
	local hvInsanity = string.format("%s", TRB.Functions.Number:RoundTo(_hvInsanity, resourcePrecision, "ceil"))
	--$hvTicks
	local _hvTicks = snapshots[spells.horrificVisions.id].buff.ticks or 0
	local hvTicks = string.format("%.0f", _hvTicks)	
	--$hvStacks
	local _hvStacks = 0
	if target ~= nil then
		_hvStacks = target.spells[spells.horrificVisions.id].stacks or 0
	end
	local hvStacks = string.format("%.0f", _hvStacks)]]
	
	--$mfiTime
	local _mfiTime = 0
	--$mfiStacks
	local _mfiStacks = 0
	
	if snapshots[spells.mindFlayInsanity.id].buff.isActive then
		_mfiTime = snapshots[spells.mindFlayInsanity.id].buff:GetRemainingTime(currentTime)
		_mfiStacks = snapshots[spells.mindFlayInsanity.id].buff.applications or 0
	end
	
	local mfiTime = TRB.Functions.BarText:TimerPrecision(_mfiTime)
	local mfiStacks = string.format("%.0f", _mfiStacks)
	
	--$sotvTime
	local _sotvTime = 0
	if snapshots[spells.screamsOfTheVoid.id].buff.isActive then
		_sotvTime = snapshots[spells.screamsOfTheVoid.id].buff:GetRemainingTime(currentTime)
	end
	local sotvTime = TRB.Functions.BarText:TimerPrecision(_sotvTime)

	--[[
	--$mindBlastCharges
	local mindBlastCharges = snapshots[spells.mindBlast.id].cooldown.charges or 0
	
	--$mindBlastMaxCharges
	local mindBlastMaxCharges = snapshots[spells.mindBlast.id].cooldown.maxCharges or 0

	--$siTime
	local _siTime = snapshots[spells.shadowyInsight.id].buff:GetRemainingTime(currentTime)
	local siTime = TRB.Functions.BarText:TimerPrecision(_siTime)
	
	--$spTime
	local _spTime = snapshots[spells.shatteredPsyche.id].buff:GetRemainingTime(currentTime)
	local spTime = TRB.Functions.BarText:TimerPrecision(_spTime)
	--$spStacks
	local spStacks = snapshots[spells.shatteredPsyche.id].buff.applications or 0
	--$spCrit
	local spCrit = snapshots[spells.shatteredPsyche.id].buff.customProperties["crit"] or 0

	--$ysTime
	local _ysTime = snapshots[spells.idolOfYoggSaron.id].buff:GetRemainingTime(currentTime)
	local ysTime = TRB.Functions.BarText:TimerPrecision(_ysTime)
	--$ysStacks
	local ysStacks = snapshots[spells.idolOfYoggSaron.id].buff.applications or 0
	--$ysRemainingStacks
	local ysRemainingStacks = (spells.idolOfYoggSaron.attributes.requiredStacks - ysStacks) or spells.idolOfYoggSaron.attributes.requiredStacks
	--$tfbTime
	local _tfbTime = snapshots[spells.thingFromBeyond.id].buff:GetRemainingTime(currentTime)
	local tfbTime = TRB.Functions.BarText:TimerPrecision(_tfbTime)
	
	--$reStacks
	local reStacks = 0
	--$reTime
	local _reTime = 0
	if target ~= nil then
		reStacks = target.spells[spells.resonantEnergy.debuffId].stacks or 0
		_reTime = target.spells[spells.resonantEnergy.debuffId].remainingTime
	end
	local reTime = TRB.Functions.BarText:TimerPrecision(_reTime)]]

	--$entropicRiftTime
	local _entropicRiftTime = snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
	local entropicRiftTime = TRB.Functions.BarText:TimerPrecision(_entropicRiftTime)

	--$entropicRiftExtensionsRemaining
	local entropicRiftExtensionsRemaining = snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] or 0

	--[[--$voidVolleyTime
	local _voidVolleyTime = snapshots[spells.voidVolley.id].buff:GetRemainingTime(currentTime)
	local voidVolleyTime = TRB.Functions.BarText:TimerPrecision(_voidVolleyTime)
	]]

	-- Mana lookups (Shadow uses mana as secondary resource display)
	local currentManaColor = (sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color) or sharedSettings.colors.text.current.color
	local normalizedMana = UnitPower("player", Enum.PowerType.Mana)
	local normalizedManaMax = UnitPowerMax("player", Enum.PowerType.Mana)

	--$mana
	local manaPrecision = sharedSettings.precision.mana or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedManaMax))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))


	----------------------------

	local lookup = TRB.Data.lookup
	lookup["$insanityMax"] = TRB.Data.character.maxResource
	lookup["$insanity"] = currentInsanity
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentInsanity
	lookup["$casting"] = castingInsanity
	lookup["$mfiTime"] = mfiTime
	lookup["$mfiStacks"] = mfiStacks
	lookup["$sotvTime"] = sotvTime
	lookup["$entropicRiftTime"] = entropicRiftTime
	lookup["$entropicRiftExtensionsRemaining"] = entropicRiftExtensionsRemaining
	lookup["$vfTime"] = voidformTime
	lookup["$shadowWordMadnessUsable"] = ""
	lookup["$mana"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	--[[
	lookup["$spTime"] = spTime
	lookup["$mmTime"] = spTime
	lookup["$spStacks"] = spStacks
	lookup["$mmStacks"] = spStacks
	lookup["$spCrit"] = spCrit
	lookup["$ysTime"] = ysTime
	lookup["$ysStacks"] = ysStacks
	lookup["$ysRemainingStacks"] = ysRemainingStacks
	lookup["$reStacks"] = reStacks
	lookup["$reTime"] = reTime
	lookup["$tfbTime"] = tfbTime
	lookup["$siTime"] = siTime
	lookup["$mindBlastCharges"] = mindBlastCharges
	lookup["$mindBlastMaxCharges"] = mindBlastMaxCharges
	lookup["$hvTicks"] = hvTicks
	lookup["$hvStacks"] = hvStacks
	lookup["$voidVolleyTime"] = voidVolleyTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$insanityMax"] = TRB.Data.character.maxResource
	lookupLogic["$insanity"] = _currentInsanity
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = _currentInsanity
	lookupLogic["$casting"] = _castingInsanity
	lookupLogic["$mfiTime"] = _mfiTime
	lookupLogic["$mfiStacks"] = _mfiStacks
	lookupLogic["$sotvTime"] = _sotvTime
	lookupLogic["$entropicRiftTime"] = _entropicRiftTime
	lookupLogic["$entropicRiftExtensionsRemaining"] = entropicRiftExtensionsRemaining
	lookupLogic["$vfTime"] = _voidformTime
	lookupLogic["$shadowWordMadnessUsable"] = _shadowWordMadnessUsable
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$manaMax"] = normalizedManaMax
	lookupLogic["$manaPercent"] = _manaPercent
	--[[
	lookupLogic["$spTime"] = _spTime
	lookupLogic["$mmTime"] = _spTime
	lookupLogic["$spStacks"] = spStacks
	lookupLogic["$mmStacks"] = spStacks
	lookupLogic["$spCrit"] = spCrit
	lookupLogic["$ysTime"] = _ysTime
	lookupLogic["$ysStacks"] = ysStacks
	lookupLogic["$ysRemainingStacks"] = ysRemainingStacks
	lookupLogic["$reStacks"] = reStacks
	lookupLogic["$reTime"] = _reTime
	lookupLogic["$tfbTime"] = _tfbTime
	lookupLogic["$siTime"] = _siTime
	lookupLogic["$mindBlastCharges"] = mindBlastCharges
	lookupLogic["$mindBlastMaxCharges"] = mindBlastMaxCharges
	lookupLogic["$hvTicks"] = _hvTicks
	lookupLogic["$hvStacks"] = _hvStacks
	lookupLogic["$voidVolleyTime"] = _voidVolleyTime]]
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Discipline()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Holy()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function UpdateCastingResourceFinal_Shadow()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateResourceGain(TRB.Data.snapshotData.casting.resourceRaw)
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
		casting:SnapshotManaSpell()
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Discipline()
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		local snapshots = snapshotData.snapshots
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()

			--[[if spellId == spells.heal.id then
				casting.spellKey = "heal"
			elseif spellId == spells.flashHeal.id then
				casting.spellKey = "flashHeal"
			elseif spellId == spells.prayerOfHealing.id then
				casting.spellKey = "prayerOfHealing"
			elseif spellId == spells.smite.id then
				casting.spellKey = "smite"
			elseif talents:IsTalentActive(spells.voiceOfHarmony) then
				if spellId == spells.holyFire.id then --Voice of Harmony
					casting.spellKey = "holyFire"
				end
			end]]
			UpdateCastingResourceFinal_Holy()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.halo.id then
				if talents:IsTalentActive(spells.manifestedPower) then
					--TODO: Clean this up into something more automated
					if talents:IsTalentActive(spells.powerSurge) then
						local function SustainedPotencyStack()
							if talents:IsTalentActive(spells.sustainedPotency) then
								if snapshots[spells.apotheosis.id].buff.isActive then
									snapshots[spells.apotheosis.id].buff:AddTimeOrInitializeCustom(spells.sustainedPotency.attributes.durationMod)
								else
									snapshots[spells.sustainedPotency.id].buff:AddStackOrInitializeCustom(spells.sustainedPotency.attributes.durationMod, currentTime, true)
								end
							end
						end

						SustainedPotencyStack()

						C_Timer.After(0, function()
							C_Timer.After(spells.powerSurge.tickRate, function()
								SustainedPotencyStack()
							end)
							C_Timer.After((spells.powerSurge.tickRate * 2), function()
								SustainedPotencyStack()
							end)
							if talents:IsTalentActive(spells.energyConservation) then
								C_Timer.After((spells.powerSurge.tickRate * 3), function()
									SustainedPotencyStack()
								end)
							end
						end)
					end
				end
			elseif spellId == spells.apotheosis.id then
				local duration = spells.apotheosis.duration + snapshots[spells.sustainedPotency.id].buff.applications * spells.sustainedPotency.attributes.durationMod
 				snapshots[spells.sustainedPotency.id].buff:Reset()

				snapshots[spells.apotheosis.id].buff:InitializeCustom(duration, currentTime)
				snapshots[spells.apotheosis.id].buff.attributes["swmCasts"] = 0
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local snapshots = snapshotData.snapshots
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.mindBlast.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindBlast.resource
				casting.spellId = spells.mindBlast.id
				casting.icon = spells.mindBlast.icon
			elseif spellId == spells.vampiricTouch.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.vampiricTouch.resource
				casting.spellId = spells.vampiricTouch.id
				casting.icon = spells.vampiricTouch.icon
			elseif spellId == spells.voidform.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.voidform.resource
				casting.spellId = spells.voidform.id
				casting.icon = spells.voidform.icon

				if talents:IsTalentActive(spells.improvedVoidform) then
					casting.resourceRaw = casting.resourceRaw + spells.improvedVoidform.resource
				end				
			elseif spellId == spells.mindgames.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindgames.resource
				casting.spellId = spells.mindgames.id
				casting.icon = spells.mindgames.icon
			elseif spellId == spells.halo.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.halo.resource
				casting.spellId = spells.halo.id
				casting.icon = spells.halo.icon
			elseif spellId == spells.voidBlast.id then
				casting.startTime = currentTime
				if talents:IsTalentActive(spells.voidInfusion) then
					casting.resourceRaw = spells.voidBlast.resource * spells.voidInfusion.attributes.resourceMod
				else
					casting.resourceRaw = spells.voidBlast.resource
				end
				casting.spellId = spells.voidBlast.id
				casting.icon = spells.voidBlast.icon
			end
			UpdateCastingResourceFinal_Shadow()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.mindFlay.id then
				casting.spellId = spells.mindFlay.id
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindFlay.resource
				casting.icon = spells.mindFlay.icon

				if talents:IsTalentActive(spells.surgeOfInsanity) then
					casting.resourceRaw = casting.resourceRaw * spells.surgeOfInsanity.attributes.resourceMod
				end

				-- If Mind Flay: Insanity is supposedly active but we're channeling Mind Flay, something got messed up in the buff tracking and we need to clear the buff
				if snapshots[spells.mindFlayInsanity.id].buff.isActive then
					snapshots[spells.mindFlayInsanity.id].buff:Reset()
				end
			elseif spellId == spells.mindFlayInsanity.castId then
				casting.spellId = spells.mindFlayInsanity.castId
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindFlayInsanity.resource
				casting.icon = spells.mindFlayInsanity.icon

				snapshots[spells.mindFlayInsanity.id].buff:RemoveStack()
			elseif spellId == spells.voidTorrent.id then
				casting.spellId = spells.voidTorrent.id
				casting.startTime = currentTime
				casting.resourceRaw = spells.voidTorrent.resource
				casting.icon = spells.voidTorrent.icon

				snapshots[spells.entropicRift.id].buff:InitializeCustom(spells.entropicRift.duration, currentTime)
				if talents:IsTalentActive(spells.darkeningHorizon) then
					snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] = spells.darkeningHorizon.attributes["maxExtensions"]
				else
					snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] = 0
				end
			end
			UpdateCastingResourceFinal_Shadow()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.halo.id then
				local function SustainedPotencyStack()
					if talents:IsTalentActive(spells.sustainedPotency) then
						if snapshots[spells.voidform.id].buff.isActive then
							snapshots[spells.voidform.id].buff:AddTimeOrInitializeCustom(spells.sustainedPotency.attributes.durationMod)
						else
							snapshots[spells.sustainedPotency.id].buff:AddStackOrInitializeCustom(spells.sustainedPotency.attributes.durationMod, currentTime, true)
						end
					end
				end

				SustainedPotencyStack()
				if talents:IsTalentActive(spells.manifestedPower) or talents:IsTalentActive(spells.sustainedPotency) then
					if talents:IsTalentActive(spells.manifestedPower) then
						snapshots[spells.mindFlayInsanity.id].buff:InitializeCustom(spells.mindFlayInsanity.duration, currentTime, true)
					end

					--TODO: Clean this up into something more automated
					if talents:IsTalentActive(spells.powerSurge) then

						C_Timer.After(0, function()
							C_Timer.After(spells.powerSurge.tickRate, function()
								if talents:IsTalentActive(spells.manifestedPower) then
									snapshots[spells.mindFlayInsanity.id].buff:AddStackOrInitializeCustom(spells.mindFlayInsanity.duration, currentTime + spells.powerSurge.tickRate, true)
								end
								SustainedPotencyStack()
							end)
							C_Timer.After((spells.powerSurge.tickRate * 2), function()
								if talents:IsTalentActive(spells.manifestedPower) then
									snapshots[spells.mindFlayInsanity.id].buff:AddStackOrInitializeCustom(spells.mindFlayInsanity.duration, currentTime + (spells.powerSurge.tickRate * 2), true)
								end
								SustainedPotencyStack()
							end)
							if talents:IsTalentActive(spells.energyConservation) then
								C_Timer.After((spells.powerSurge.tickRate * 3), function()
								if talents:IsTalentActive(spells.manifestedPower) then
									snapshots[spells.mindFlayInsanity.id].buff:AddStackOrInitializeCustom(spells.mindFlayInsanity.duration, currentTime + (spells.powerSurge.tickRate * 3), true)
								end
								SustainedPotencyStack()
								end)
							end
						end)
					end
				end
			elseif spellId == spells.voidform.id then
				local duration = spells.voidform.duration + snapshots[spells.sustainedPotency.id].buff.applications * spells.sustainedPotency.attributes.durationMod
 				snapshots[spells.sustainedPotency.id].buff:Reset()

				snapshots[spells.voidform.id].buff:InitializeCustom(duration, currentTime)
				snapshots[spells.voidform.id].buff.attributes["swmCasts"] = 0
			elseif spellId == spells.shadowWordMadness.castId then
				if talents:IsTalentActive(spells.screamsOfTheVoid) then
					snapshots[spells.screamsOfTheVoid.id].buff:AddTimeOrInitializeCustom(spells.screamsOfTheVoid.duration, currentTime)
				end

				if snapshots[spells.voidform.id].buff.isActive and talents:IsTalentActive(spells.ancientMadness) then
					local mod = spells.ancientMadness.attributes.durationPerCastMod ^ (snapshots[spells.voidform.id].buff.attributes["swmCasts"] or 0)
					local increasedDuration = mod * spells.ancientMadness.attributes.durationMod
					snapshots[spells.voidform.id].buff:AddTimeOrInitializeCustom(increasedDuration)
					snapshots[spells.voidform.id].buff.attributes["swmCasts"] = snapshots[spells.voidform.id].buff.attributes["swmCasts"] + 1
				end
			elseif spellId == spells.tentacleSlam.castId then
				if talents:IsTalentActive(spells.screamsOfTheVoid) and talents:IsTalentActive(spells.maddeningTentacles) then
					C_Timer.After((spells.tentacleSlam.attributes.delay), function()
						snapshots[spells.screamsOfTheVoid.id].buff:AddTimeOrInitializeCustom(spells.screamsOfTheVoid.duration, currentTime+spells.tentacleSlam.attributes.delay)
					end)
				end
			elseif spellId == spells.voidBlast.id then
				snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime) -- Force update of remaining time before checking
				if talents:IsTalentActive(spells.darkeningHorizon) and snapshots[spells.entropicRift.id].buff.isActive and snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] > 0 then
					snapshots[spells.entropicRift.id].buff:AddTimeOrInitializeCustom(spells.darkeningHorizon.duration, currentTime)
					snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] = snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] - 1
				end
			end
		end
	end
end

---Updates data based on spell events
local function HandleSpellEvents(self, event, ...)
	if event == "SPELL_ACTIVATION_OVERLAY_SHOW" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
			if spellId == spells.surgeOfLight.id then -- Surge of Light
				if snapshotData.attributes.surgeOfLightActive ~= true then
					local specSettings = TRB.Data.settings.priest[TRB.Data.character.specName]
					if specSettings.audio.surgeOfLight.enabled and not snapshotData.audio.surgeOfLightPlayed then
						PlaySoundFile(specSettings.audio.surgeOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
						snapshotData.audio.surgeOfLightPlayed = true
					end
				end
				snapshotData.attributes.surgeOfLightActive = true
			end
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_HIDE" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
			if spellId == spells.surgeOfLight.id then -- Surge of Light
				snapshotData.attributes.surgeOfLightActive = false
				snapshotData.audio.surgeOfLightPlayed = false
			end
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
end

local function UpdateSnapshot_Healers()
	local _
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	-- Track Flash Heal mana cost to detect Surge of Light via cost reduction
	local currentFlashHealCost = spells.flashHeal:GetPrimaryResourceCost(true) or 0
	if currentFlashHealCost > 0 then
		local baseManaCost = spells.flashHeal.attributes.baseManaCost
		if baseManaCost == nil then
			-- First time seeing a non-zero cost, store it
			spells.flashHeal.attributes.baseManaCost = currentFlashHealCost
		elseif currentFlashHealCost >= baseManaCost * 2 then
			-- We captured a reduced cost initially, overwrite with the higher (true base) cost
			spells.flashHeal.attributes.baseManaCost = currentFlashHealCost
		end
	end
end

local function UpdateSnapshot_Voidweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.ShadowSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local entropicRift = snapshots[spells.entropicRift.id]
	
	if entropicRift.buff.isActive then
		entropicRift.buff:GetRemainingTime()
		if not entropicRift.buff.isActive then
			entropicRift.buff.attributes["extensionsRemaining"] = 0
		end
	end
end

local function UpdateSnapshot_Discipline()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Healers()
	--UpdateSnapshot_Voidweaver()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--[[snapshots[spells.powerWordRadiance.id].cooldown:Refresh(true)
	snapshots[spells.shadowCovenant.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)]]
end

local function UpdateSnapshot_Holy()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Healers()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.sustainedPotency.id].buff:GetRemainingTime(currentTime)
	--[[snapshots[spells.holyWordSerenity.id].cooldown:Refresh(true)
	snapshots[spells.holyWordSanctify.id].cooldown:Refresh(true)
	snapshots[spells.holyWordChastise.id].cooldown:Refresh()
	snapshots[spells.resonantWords.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime)]]
end

local function UpdateSnapshot_Shadow()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Voidweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	snapshots[spells.mindFlayInsanity.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.sustainedPotency.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.voidform.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.mindDevourer.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
	--snapshots[spells.mindBlast.id].cooldown:Refresh()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.priest
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
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

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		local specSettings = classSettings.discipline
		local specCacheSettings = TRB.Data.specCache.priest_discipline.settings
		UpdateSnapshot_Discipline()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border.color

				-- Detect Surge of Light via Flash Heal mana cost reduction
				if snapshotData.attributes.surgeOfLightActive then
					if specSettings.colors.bar.surgeOfLight.enabled then
						barBorderColor = specSettings.colors.bar.surgeOfLight.color
					end
				end

				--[[if snapshots[spells.shadowCovenant.id].buff.isActive then
					if specSettings.colors.bar.shadowCovenant.enabled then
						barBorderColor = specSettings.colors.bar.shadowCovenant.color
					end
				end]]
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				
				local barColor = specSettings.colors.bar.base.color

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
			end

			-- Update health bar
			if specSettings.displayBar.health ~= "never" then
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
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		local specSettings = classSettings.holy
		local specCacheSettings = TRB.Data.specCache.priest_holy.settings
		UpdateSnapshot_Holy()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border.color

				-- Detect Surge of Light via Flash Heal mana cost reduction
				if snapshotData.attributes.surgeOfLightActive then
					if specSettings.colors.bar.surgeOfLight.enabled then
						barBorderColor = specSettings.colors.bar.surgeOfLight.color
					end
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local barColor = nil
				local holyWordCooldownCompletes = false
				local holyWordCooldownCompletesKey = nil

				if snapshotData.casting.spellKey ~= nil then
					local maybeHolyWordSpell = spells[snapshotData.casting.spellKey]--[[@as TRB.Classes.Priest.HolyWordSpell]]
					if maybeHolyWordSpell ~= nil and
						maybeHolyWordSpell.holyWordKey ~= nil and
						maybeHolyWordSpell.holyWordReduction ~= nil and
						maybeHolyWordSpell.holyWordReduction >= 0 and
						talents:IsTalentActive(spells[maybeHolyWordSpell.holyWordKey]) then

						local castTimeRemains = snapshotData.casting.endTime - currentTime
						local holyWordCooldownRemaining = snapshots[spells[maybeHolyWordSpell.holyWordKey].id].cooldown:GetRemainingTime(currentTime)
						local calcHolyWordCooldown = CalculateHolyWordCooldown(maybeHolyWordSpell.holyWordReduction, spells[snapshotData.casting.spellKey].id)

						if (holyWordCooldownRemaining - calcHolyWordCooldown - castTimeRemains) <= 0 then
							holyWordCooldownCompletes = true
							holyWordCooldownCompletesKey = maybeHolyWordSpell.holyWordKey
							if specSettings.colors.bar[maybeHolyWordSpell.holyWordKey] and specSettings.colors.bar[maybeHolyWordSpell.holyWordKey].enabled then
								barColor = specSettings.colors.bar[maybeHolyWordSpell.holyWordKey].color
							end
						end
					end
				end

				if snapshots[spells.apotheosis.id].buff.isActive and barColor == nil then
					local timeThreshold = 0
					local useEndOfApotheosisColor = false

					if specSettings.endOf.apotheosis.enabled then
						useEndOfApotheosisColor = true
						if specSettings.endOf.apotheosis.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOf.apotheosis.gcdsMax
						elseif specSettings.endOf.apotheosis.mode == "time" then
							timeThreshold = specSettings.endOf.apotheosis.timeMax
						end
					end

					if useEndOfApotheosisColor and snapshots[spells.apotheosis.id].buff.remaining <= timeThreshold then
						barColor = specSettings.colors.bar.apotheosisEnd.color
					elseif specSettings.colors.bar.apotheosis.enabled then
						barColor = specSettings.colors.bar.apotheosis.color
					end
				end
				
				if barColor == nil then
					barColor = specSettings.colors.bar.base.color
				end

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
			end

			-- Update health bar
			if specSettings.displayBar.health ~= "never" then
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
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local specSettings = classSettings.shadow
		local specCacheSettings = TRB.Data.specCache.priest_shadow.settings
		UpdateSnapshot_Shadow()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = specSettings.colors.bar.border.color
				local barColor = specSettings.colors.bar.base.color

				if specSettings.colors.bar.mindDevourer.enabled and spells.shadowWordMadness:IsFree() then --snapshots[spells.mindDevourer.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.mindDevourer.color
				elseif specSettings.colors.bar.entropicRift.enabled and snapshots[spells.entropicRift.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.entropicRift.color
				elseif specSettings.colors.bar.borderMindFlayInsanity.enabled and snapshots[spells.mindFlayInsanity.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.borderMindFlayInsanity.color
				end

				-- Build overcap border curve if enabled
				local overcapBorderCurve = nil
				if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
				end

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetResourceFrame()
				local thresholds = primaryNode:GetThresholds()

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
					local thresholdColor = specCacheSettings.colors.threshold.over.color --[[@as string?]]
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.settingKey == spells.shadowWordMadness--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount > TRB.Data.character.maxResource then
								showThreshold = false
							elseif snapshots[spells.mindDevourer.id].buff.endTime ~= nil and currentTime < snapshots[spells.mindDevourer.id].buff.endTime then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif spell:IsFree() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.settingKey == spells.shadowWordMadness2--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount > TRB.Data.character.maxResource then
								showThreshold = false
							elseif specCacheSettings.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow then
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
						elseif spell.settingKey == spells.shadowWordMadness3--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount > maxPrimaryBarResourceUnnormalized then
								showThreshold = false
							elseif specCacheSettings.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow then
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
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						thresholdColor = specCacheSettings.colors.threshold.under.color
						frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
					end
					
					if resourceAmount > maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
				end

				if spells.shadowWordMadness:IsFree() or spells.shadowWordMadness:IsUsable() then
					if specSettings.colors.bar.flashEnabled then
						TRB.Functions.Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					else
						barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					end

					if spells.shadowWordMadness:IsFree() and specSettings.audio.mdProc.enabled and snapshotData.audio.playedMdCue == false then
						snapshotData.audio.playedDpCue = true
						snapshotData.audio.playedMdCue = true
						PlaySoundFile(specSettings.audio.mdProc.sound, coreSettings.audio.channel.channel)
					elseif specSettings.audio.dpReady.enabled and snapshotData.audio.playedDpCue == false then
						snapshotData.audio.playedDpCue = true
						PlaySoundFile(specSettings.audio.dpReady.sound, coreSettings.audio.channel.channel)
					end
				else
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					snapshotData.audio.playedDpCue = false
					snapshotData.audio.playedMdCue = false
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				if snapshots[spells.voidform.id].buff.isActive then
					local timeLeft = snapshots[spells.voidform.id].buff.remaining
					local timeThreshold = 0
					local useEndOfVoidformColor = false

					if specSettings.endOf.voidform.enabled then
						useEndOfVoidformColor = true
						if specSettings.endOf.voidform.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOf.voidform.gcdsMax
						elseif specSettings.endOf.voidform.mode == "time" then
							timeThreshold = specSettings.endOf.voidform.timeMax
						end
					end

					if useEndOfVoidformColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.voidformEnd.color
					elseif specSettings.colors.bar.shadowWordMadnessUsable.enabled and (spells.shadowWordMadness:IsFree() or spells.shadowWordMadness:IsUsable()) then
						barColor = specSettings.colors.bar.shadowWordMadnessUsable.color
					elseif specSettings.colors.bar.voidform.enabled then
						barColor = specSettings.colors.bar.voidform.color
					end
				elseif specSettings.colors.bar.shadowWordMadnessUsable.enabled and (spells.shadowWordMadness:IsFree() or spells.shadowWordMadness:IsUsable()) then
					barColor = specSettings.colors.bar.shadowWordMadnessUsable.color
				end
				
				if overcapBorderCurve then
					-- Evaluate the curve with current power level to get the right color
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
			end
		end

		-- Update health bar
		if specSettings.displayBar.health ~= "never" then
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

		-- Update mana bar (Shadow only)
		if specSettings.displayBar.mana ~= nil and specSettings.displayBar.mana ~= "never" then
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
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization() or 0

	if TRB.Data.character.specId == 1 then
		specCache.priest_discipline.talents:GetTalents()
		FillSpellData_Discipline()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.priest_discipline)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Discipline
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.priest_discipline.settings)

		local lookup = TRB.Data.lookup or {}
		--[[lookup["#atonement"] = spells.atonement.icon
		lookup["#pwRadiance"] = spells.powerWordRadiance.icon
		lookup["#radiance"] = spells.powerWordRadiance.icon
		lookup["#powerWordRadiance"] = spells.powerWordRadiance.icon
		lookup["#sc"] = spells.shadowCovenant.icon
		lookup["#shadowCovenant"] = spells.shadowCovenant.icon
		lookup["#entropicRift"] = spells.entropicRift.icon]]

		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		talents = specCache.priest_discipline.talents
		TRB.Data.barConstructedForSpec = "priest_discipline"
		ConstructResourceBar(specCache.priest_discipline.settings)
	elseif TRB.Data.character.specId == 2 then
		specCache.priest_holy.talents:GetTalents()
		FillSpellData_Holy()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.priest_holy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Holy
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.priest_holy.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#flashHeal"] = spells.flashHeal.icon
		lookup["#apotheosis"] = spells.apotheosis.icon
		--[[lookup["#answeredPrayers"] = spells.answeredPrayers.icon
		lookup["#heal"] = spells.heal.icon
		lookup["#hwChastise"] = spells.holyWordChastise.icon
		lookup["#chastise"] = spells.holyWordChastise.icon
		lookup["#holyWordChastise"] = spells.holyWordChastise.icon
		lookup["#hwSanctify"] = spells.holyWordSanctify.icon
		lookup["#sanctify"] = spells.holyWordSanctify.icon
		lookup["#holyWordSanctify"] = spells.holyWordSanctify.icon
		lookup["#hwSerenity"] = spells.holyWordSerenity.icon
		lookup["#serenity"] = spells.holyWordSerenity.icon
		lookup["#holyWordSerenity"] = spells.holyWordSerenity.icon
		lookup["#lightweaver"] = spells.lightweaver.icon
		lookup["#rw"] = spells.resonantWords.icon
		lookup["#resonantWords"] = spells.resonantWords.icon
		lookup["#lotn"] = spells.lightOfTheNaaru.icon
		lookup["#lightOfTheNaaru"] = spells.lightOfTheNaaru.icon
		lookup["#poh"] = spells.prayerOfHealing.icon
		lookup["#prayerOfHealing"] = spells.prayerOfHealing.icon
		lookup["#smite"] = spells.smite.icon]]
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		-- Configure Sustained Potency pause tracking for Apotheosis
		local apotheosisSnapshot = specCache.priest_holy.snapshotData.snapshots[spells.apotheosis.id]
		if apotheosisSnapshot ~= nil then
			if specCache.priest_holy.talents:IsTalentActive(spells.sustainedPotency) then
				-- Set the pause max duration from the Sustained Potency talent
				apotheosisSnapshot.buff:SetPauseMaxDuration(spells.sustainedPotency.attributes.pauseDuration)
				RegisterSustainedPotencyEvents()
			else
				-- Clear pause configuration if talent is not active
				apotheosisSnapshot.buff:SetPauseMaxDuration(nil)
				UnregisterSustainedPotencyEvents()
			end
		end

		talents = specCache.priest_holy.talents
		TRB.Data.barConstructedForSpec = "priest_holy"
		ConstructResourceBar(specCache.priest_holy.settings)
	elseif TRB.Data.character.specId == 3 then
		specCache.priest_shadow.talents:GetTalents()
		FillSpellData_Shadow()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.priest_shadow)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.priest_shadow.settings)

		local lookup = {}
		lookup["#mb"] = spells.mindBlast.icon
		lookup["#mindBlast"] = spells.mindBlast.icon
		lookup["#mf"] = spells.mindFlay.icon
		lookup["#mindFlay"] = spells.mindFlay.icon
		lookup["#mfi"] = spells.mindFlayInsanity.icon
		lookup["#mindFlayInsanity"] = spells.mindFlayInsanity.icon
		lookup["#mindgames"] = spells.mindgames.icon
		lookup["#vf"] = spells.voidform.icon
		lookup["#voidform"] = spells.voidform.icon
		lookup["#voit"] = spells.voidTorrent.icon
		lookup["#voidTorrent"] = spells.voidTorrent.icon
		lookup["#vv"] = spells.voidVolley.icon
		lookup["#voidVolley"] = spells.voidVolley.icon
		lookup["#mDev"] = spells.mindDevourer.icon
		lookup["#mindDevourer"] = spells.mindDevourer.icon
		lookup["#sotv"] = spells.screamsOfTheVoid.icon
		lookup["#screamsOfTheVoid"] = spells.screamsOfTheVoid.icon
		lookup["#entropicRift"] = spells.entropicRift.icon
		lookup["#swm"] = spells.shadowWordMadness.icon
		lookup["#shadowWordMadness"] = spells.shadowWordMadness.icon
		lookup["#halo"] = spells.halo.icon
		--[[
		lookup["#si"] = spells.shadowyInsight.icon
		lookup["#shadowyInsight"] = spells.shadowyInsight.icon
		lookup["#mm"] = spells.shatteredPsyche.icon
		lookup["#mindMelt"] = spells.shatteredPsyche.icon
		lookup["#sp"] = spells.shatteredPsyche.icon
		lookup["#shatteredPsyche"] = spells.shatteredPsyche.icon
		lookup["#ys"] = spells.idolOfYoggSaron.icon
		lookup["#idolOfYoggSaron"] = spells.idolOfYoggSaron.icon
		lookup["#tfb"] = spells.thingFromBeyond.icon
		lookup["#thingFromBeyond"] = spells.thingFromBeyond.icon
		lookup["#md"] = spells.massDispel.icon
		lookup["#massDispel"] = spells.massDispel.icon
		lookup["#cthun"] = spells.idolOfCthun.icon
		lookup["#idolOfCthun"] = spells.idolOfCthun.icon
		lookup["#loi"] = spells.idolOfCthun.icon
		lookup["#hv"] = spells.horrificVisions.icon
		lookup["#horrificVisions"] = spells.horrificVisions.icon]]

		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		-- Configure Sustained Potency pause tracking for Voidform
		local voidformSnapshot = specCache.priest_shadow.snapshotData.snapshots[spells.voidform.id]
		if voidformSnapshot ~= nil then
			if specCache.priest_shadow.talents:IsTalentActive(spells.sustainedPotency) then
				-- Set the pause max duration from the Sustained Potency talent
				voidformSnapshot.buff:SetPauseMaxDuration(spells.sustainedPotency.attributes.pauseDuration)
				RegisterSustainedPotencyEvents()
			else
				-- Clear pause configuration if talent is not active
				voidformSnapshot.buff:SetPauseMaxDuration(nil)
				UnregisterSustainedPotencyEvents()
			end
		end

		talents = specCache.priest_shadow.talents
		TRB.Data.barConstructedForSpec = "priest_shadow"
		ConstructResourceBar(specCache.priest_shadow.settings)
	else
		-- Unregister Sustained Potency events when not Shadow spec
		UnregisterSustainedPotencyEvents()
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

	C_Timer.After(0, function()
		C_Timer.After(0.05, function()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Data.barConstructedForSpec ~= nil then
				ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
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

	if TRB.Data.character.classId == 5 then
		if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Priest.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.discipline == nil or
						TwintopInsanityBarSettings.priest.discipline.displayText == nil then
						settings.priest.discipline.displayText.barText = TRB.Options.Priest.DisciplineLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.holy == nil or
						TwintopInsanityBarSettings.priest.holy.displayText == nil then
						settings.priest.holy.displayText.barText = TRB.Options.Priest.HolyLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.shadow == nil or
						TwintopInsanityBarSettings.priest.shadow.displayText == nil then
						settings.priest.shadow.displayText.barText = TRB.Options.Priest.ShadowLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.priest ~= true then
						TRB.Data.settings.priest.discipline.displayText.barText = TRB.Options.Priest.DisciplineLoadDefaultBarTextSettings()
						TRB.Data.settings.priest.holy.displayText.barText = TRB.Options.Priest.HolyLoadDefaultBarTextSettings()
						TRB.Data.settings.priest.shadow.displayText.barText = TRB.Options.Priest.ShadowLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.priest = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Priest"])
					end
				else
					local settings = TRB.Options.Priest.LoadDefaultSettings(true)
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
						TRB.Data.settings.priest.discipline = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestDisciplineFull"], TRB.Data.settings.priest.discipline)
						TRB.Data.settings.priest.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestHolyFull"], TRB.Data.settings.priest.holy)
						TRB.Data.settings.priest.shadow = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestShadowFull"], TRB.Data.settings.priest.shadow)
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Priest.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "priest"
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		TRB.Data.character.specName = "discipline"
		TRB.Data.character.compositeKey = "priest_discipline"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		local settings = TRB.Data.settings.priest.discipline
		
		local totalPowerWordCharges = 0
		
		--[[if talents:IsTalentActive(spells.powerWordRadiance) and settings.colors.comboPoints.powerWordRadiance.enabled then
			totalPowerWordCharges = totalPowerWordCharges + 1
			if talents:IsTalentActive(spells.lightsPromise) then
				totalPowerWordCharges = totalPowerWordCharges + 1
			end
		end]]
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	
		if sharedSettings ~= nil then
			if totalPowerWordCharges ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = totalPowerWordCharges
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		TRB.Data.character.specName = "holy"
		TRB.Data.character.compositeKey = "priest_holy"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		local settings = TRB.Data.settings.priest.holy
		

		local totalHolyWordCharges = 0
		
		--[[if talents:IsTalentActive(spells.holyWordSerenity) and settings.colors.comboPoints.holyWordSerenity.enabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
			if talents:IsTalentActive(spells.miracleWorker) then
				totalHolyWordCharges = totalHolyWordCharges + 1
			end
		end
		
		if talents:IsTalentActive(spells.holyWordSanctify) and settings.colors.comboPoints.holyWordSanctify.enabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
			if talents:IsTalentActive(spells.miracleWorker) then
				totalHolyWordCharges = totalHolyWordCharges + 1
			end
		end
		
		if talents:IsTalentActive(spells.holyWordChastise) and settings.colors.comboPoints.holyWordChastise.enabled then
			totalHolyWordCharges = totalHolyWordCharges + 1
		end]]
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	
		if sharedSettings ~= nil then
			if totalHolyWordCharges ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = totalHolyWordCharges
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		TRB.Data.character.specName = "shadow"
		TRB.Data.character.compositeKey = "priest_shadow"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Insanity, false)
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.priest.discipline == true then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.priest.holy == true then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.priest.shadow == true then
		TRB.Functions.Class:DisableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Insanity
		TRB.Data.resourceFactor = 100
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
	else
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
			-- Priest has no secondary bar
			local showPrimary = false
			if not forceHideAll then
				if sharedSettings.displayBar.primary == "always" then
					showPrimary = true
				elseif sharedSettings.displayBar.primary == "combat" then
					showPrimary = affectingCombat or inVehicle
				end
				-- "never" means showPrimary stays false
			end

			-- Determine health bar visibility independently
			local showHealth = false
			if not forceHideAll then
				if sharedSettings.displayBar.health == "always" then
					showHealth = true
				elseif sharedSettings.displayBar.health == "combat" then
					showHealth = affectingCombat or inVehicle
				end
				-- "never" means showHealth stays false
			end

			-- Determine mana bar visibility independently (Shadow only)
			local showMana = false
			if TRB.Data.character.specId == 3 and not forceHideAll and sharedSettings.displayBar.mana ~= nil then
				if sharedSettings.displayBar.mana == "always" then
					showMana = true
				elseif sharedSettings.displayBar.mana == "combat" then
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

			-- Apply health bar visibility
			if barGroups and barGroups.health then
				if showHealth then
					barGroups.health:Show()
					barGroups.health:ShowNodes(1)
				else
					barGroups.health:Hide()
				end
			end

			-- Apply mana bar visibility (Shadow only)
			if barGroups and barGroups.mana then
				if showMana then
					barGroups.mana:Show()
					barGroups.mana:ShowNodes(1)
				else
					barGroups.mana:Hide()
				end
			end

			-- Track if the bar is showing
			snapshotData.attributes.isTracking = showPrimary or showHealth or showMana
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
			if barGroups and barGroups.health then
				barGroups.health:Hide()
			end
			if barGroups and barGroups.mana then
				barGroups.mana:Hide()
			end
			snapshotData.attributes.isTracking = false
		end
	else
		-- Unsupported spec - hide everything
		if barGroups and barGroups.primary then
			barGroups.primary:Hide()
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
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local spells = spellsData.spells
	local settings = nil
	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.priest.discipline
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.priest.holy
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.priest.shadow
	else
		return false
	end

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HealerSpells]]
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
		end
	end

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		--[[if var == "$pwRadianceTime" or var == "$radianceTime" or var == "$powerWordRadianceTime" then
			if snapshots[spells.powerWordRadiance.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$pwRadianceCharges" or var == "$radianceCharges" or var == "$powerWordRadianceCharges" then
			if snapshots[spells.powerWordRadiance.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$scTime" or var == "$shadowCovenantTime" then
			if snapshots[spells.shadowCovenant.id].buff.isActive then
				valid = true
			end
		end]]
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		--[[if var == "$lightweaverTime" then
			if snapshots[spells.lightweaver.id].buff.isActive then
				valid = true
			end
		elseif var == "$lightweaverStacks" then
			if snapshots[spells.lightweaver.id].buff.isActive then
				valid = true
			end
		elseif var == "$rwTime" then
			if snapshots[spells.resonantWords.id].buff.isActive then
				valid = true
			end
		else]]if var == "$apotheosisTime" then
			if snapshots[spells.apotheosis.id].buff.isActive then
				valid = true
			end
		--[[elseif var == "$answeredPrayersStacks" then
			if snapshots[spells.answeredPrayers.id].buff.isActive then
				valid = true
			end
		elseif var == "$answeredPrayersMaxStacks" then
			if spells.answeredPrayers.attributes.maxStackRank[talents.talents[spells.answeredPrayers.talentId].currentRank] > 0 then
				valid = true
			end
		elseif var == "$answeredPrayersRemainingStacks" then
			if spells.answeredPrayers.attributes.maxStackRank[talents.talents[spells.answeredPrayers.talentId].currentRank] > 0 then
				valid = true
			end
		elseif var == "$hwChastiseTime" or var == "$chastiseTime" or var == "$holyWordChastiseTime" then
			if snapshots[spells.holyWordChastise.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$hwSerenityTime" or var == "$serenityTime" or var == "$holyWordSerenityTime" then
			if snapshots[spells.holyWordSerenity.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$hwSanctifyTime" or var == "$sanctifyTime" or var == "$holyWordSanctifyTime" then
			if snapshots[spells.holyWordSanctify.id].cooldown.remaining > 0 then
				valid = true
			end
		elseif var == "$hwChastiseCharges" or var == "$chastiseCharges" or var == "$holyWordChastiseCharges" then
			if snapshots[spells.holyWordChastise.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$hwSerenityCharges" or var == "$serenityCharges" or var == "$holyWordSerenityCharges" then
			if snapshots[spells.holyWordSerenity.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$sacredReverenceStacks" then
			if snapshots[spells.sacredReverence.id].buff.isActive then
				valid = true
			end]]
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		if var == "$resource" or var == "$insanity" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$insanityMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw > 0 then
				valid = true
			end
		elseif var == "$vfTime" then
			if (snapshots[spells.voidform.id].buff.remaining ~= nil and snapshots[spells.voidform.id].buff.remaining > 0) then
				valid = true
			end
		--[[elseif var == "$hvTicks" then
			if snapshots[spells.horrificVisions.id].buff.ticks > 0 then
				valid = true
			end
		elseif var == "$hvStacks" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.vampiricTouch.id] ~= nil and
				target.spells[spells.vampiricTouch.id].stacks > 0 then
				valid = true
			end]]
		elseif var == "$mfiTime" then
			if snapshots[spells.mindFlayInsanity.id].buff.isActive then
				valid = true
			end
		elseif var == "$mfiStacks" then
			if snapshots[spells.mindFlayInsanity.id].buff.isActive then
				valid = true
			end
		elseif var == "$sotvTime" then
			if snapshots[spells.screamsOfTheVoid.id].buff.isActive then
				valid = true
			end
		elseif var == "$shadowWordMadnessUsable" then
			if spells.shadowWordMadness:IsUsable() or spells.shadowWordMadness:IsFree() then
				valid = true
			end
		--[[elseif var == "$siTime" then
			if snapshots[spells.shadowyInsight.id].buff.isActive then
				valid = true
			end
		elseif var == "$mmTime" or var == "$spTime" then
			if snapshots[spells.shatteredPsyche.id].buff.isActive then
				valid = true
			end
		elseif var == "$mmStacks" or var == "$spStacks" then
			if snapshots[spells.shatteredPsyche.id].buff.isActive then
				valid = true
			end
		elseif var == "$ysTime" then
			if snapshots[spells.idolOfYoggSaron.id].buff.isActive then
				valid = true
			end
		elseif var == "$ysStacks" then
			if snapshots[spells.idolOfYoggSaron.id].buff.isActive then
				valid = true
			end
		elseif var == "$ysRemainingStacks" then
			if talents:IsTalentActive(spells.idolOfYoggSaron) then
				valid = true
			end
		elseif var == "$tfbTime" then
			if snapshots[spells.thingFromBeyond.id].buff.isActive then
				valid = true
			end
		elseif var == "$reTime" then
			if target and target.spells[spells.resonantEnergy.debuffId].active then
				valid = true
			end
		elseif var == "$reStacks" then
			if target and target.spells[spells.resonantEnergy.debuffId].active then
				valid = true
			end
		elseif var == "$mindBlastCharges" then
			if snapshots[spells.mindBlast.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$mindBlastMaxCharges" then
			if snapshots[spells.mindBlast.id].cooldown.charges > 0  then
				valid = true
			end
		elseif var == "$voidVolleyTime" then
			if snapshots[spells.voidVolley.id].buff.isActive  then
				valid = true
			end]]
		elseif var == "$mana" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$manaPercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$manaMax" then
			valid = true
		else
			valid = false
		end
	end

	-- Voidweaver
	--if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 3 then
	if TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.ShadowSpells]]
		if var == "$entropicRiftTime" then
			if snapshots[spells.entropicRift.id].buff.isActive then
				valid = true
			end
		elseif var == "$entropicRiftExtensionsRemaining" then
			if snapshots[spells.entropicRift.id].buff.isActive and snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] > 0 then
				valid = true
			end
		end
	end

	-- Health variables (all specs)
	if var == "$health" or var == "$healthMax" or var == "$healthPercent" then
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
				return primaryNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame == "ManaBar" then
		if barGroups and barGroups.mana then
			local manaNode = barGroups.mana:GetNode(1)
			if manaNode then
				local isVisible = barGroups.mana.isVisible and manaNode.isVisible
				return manaNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end
	return nil, true, false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if not TRB.Data.specSupported or talents == nil then
		return
	end
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end
	
	UpdateResourceBar()
end