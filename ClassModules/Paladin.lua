local _, TRB = ...
if TRB.Data.character.classId ~= 2 then --Only do this if we're on an Paladin!
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
	paladin_holy = TRB.Classes.SpecCache:New(),
	paladin_protection = TRB.Classes.SpecCache:New(),
	paladin_retribution = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Holy
	specCache.paladin_holy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.paladin_holy.character = {
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
	
	---@type TRB.Classes.Paladin.HolySpells
	specCache.paladin_holy.spellsData.spells = TRB.Classes.Paladin.HolySpells:New()
	local spells = specCache.paladin_holy.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]

	specCache.paladin_holy.snapshotData.attributes.manaRegen = 0
	specCache.paladin_holy.snapshotData.audio = {
		innervateCue = false,
		holyPowerThreshold1Played = false,
		holyPowerThreshold2Played = false,
		holyPowerThreshold3Played = false,
		infusionOfLightPlayed = false,
		divinePurposePlayed = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.paladin_holy.snapshotData.snapshots[spells.divinePurpose.id] = TRB.Classes.Snapshot:New(spells.divinePurpose)

	specCache.paladin_holy.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Protection
	specCache.paladin_protection.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.paladin_protection.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
	}
	
	---@type TRB.Classes.Paladin.ProtectionSpells
	specCache.paladin_protection.spellsData.spells = TRB.Classes.Paladin.ProtectionSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.paladin_protection.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]

	specCache.paladin_protection.snapshotData.attributes.manaRegen = 0
	specCache.paladin_protection.snapshotData.audio = {
		holyPowerThreshold1Played = false,
		holyPowerThreshold2Played = false,
		holyPowerThreshold3Played = false,
		divinePurposePlayed = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.paladin_protection.snapshotData.snapshots[spells.divinePurpose.id] = TRB.Classes.Snapshot:New(spells.divinePurpose)

	specCache.paladin_protection.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Retribution
	specCache.paladin_retribution.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.paladin_retribution.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		effects = {
		},
	}
	
	---@type TRB.Classes.Paladin.RetributionSpells
	specCache.paladin_retribution.spellsData.spells = TRB.Classes.Paladin.RetributionSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.paladin_retribution.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]

	specCache.paladin_retribution.snapshotData.attributes.manaRegen = 0
	specCache.paladin_retribution.snapshotData.audio = {
		holyPowerThreshold1Played = false,
		holyPowerThreshold2Played = false,
		holyPowerThreshold3Played = false,
		divinePurposePlayed = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.paladin_retribution.snapshotData.snapshots[spells.divinePurpose.id] = TRB.Classes.Snapshot:New(spells.divinePurpose)

	specCache.paladin_retribution.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Holy()
	Character:FillSpecializationCacheSettings("paladin", "holy", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "paladin_holy" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Paladin.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Holy()
	Setup_Holy()
	specCache.paladin_holy.spellsData:FillSpellData()
	local spells = specCache.paladin_holy.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]

	TRB.Classes.Paladin.HolySpells.FillBarTextVariables(specCache.paladin_holy)
end

local function Setup_Protection()
	Character:FillSpecializationCacheSettings("paladin", "protection", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "paladin_protection" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Paladin.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Protection()
	Setup_Protection()
	specCache.paladin_protection.spellsData:FillSpellData()
	local spells = specCache.paladin_protection.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]

	TRB.Classes.Paladin.ProtectionSpells.FillBarTextVariables(specCache.paladin_protection)
end

local function Setup_Retribution()
	Character:FillSpecializationCacheSettings("paladin", "retribution", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "paladin_retribution" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Paladin.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Retribution()
	Setup_Retribution()
	specCache.paladin_retribution.spellsData:FillSpellData()
	local spells = specCache.paladin_retribution.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]

	TRB.Classes.Paladin.RetributionSpells.FillBarTextVariables(specCache.paladin_retribution)
end

local function CalculateAbilityResourceValue(resource, threshold)
	local modifier = 1.0

	return resource * modifier
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	
	if TRB.Data.character.specId == 1 then -- Holy
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Protection
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Retribution
		targetData:UpdateTrackedSpells(currentTime)
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

	-- All Paladin specs use Holy Power (secondary bar). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	-- If it's still nil/0, use the factory's maxNodes as a fallback.
	if barGroups and barGroups.secondary then
		local maxHolyPower = TRB.Data.character.maxResource2
		if maxHolyPower == nil or maxHolyPower == 0 then
			maxHolyPower = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxHolyPower
	end

	-- Create thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
			for _ = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetFrame())
				Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		Bar:ConstructBarGroups(settings, barGroups)
	end

	-- All Paladin specs use Holy Power secondary bar
	if barGroups and barGroups.secondary then
		local maxHolyPower = TRB.Data.character.maxResource2 or 5
		
		-- Ensure secondary group knows the correct node count
		Bar:ApplySecondaryBarGroupLayout(settings, barGroups, maxHolyPower)
		barGroups.secondary:Show()
		
		-- Explicitly set textures and colors for each Holy Power node
		local frameLevels = TRB.Data.constants.frameLevels
		for i = 1, maxHolyPower do
			local node = barGroups.secondary:GetNode(i)
			if node then
				node:SetTextures(
					settings.textures.comboPointsBar,
					settings.textures.comboPointsBorder,
					settings.textures.comboPointsBackground
				)
				node:SetMinMax(0, 1)
				node:SetBorderColor(settings.colors.comboPoints.border.color)
				node:SetBackgroundColorFromString(settings.colors.comboPoints.background.color)
				TRB.Functions.Color:ApplyFillColor(node, settings.colors.comboPoints.base)
				node:SetFrameLevel(frameLevels.comboPoint)
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

---@param spells TRB.Classes.Paladin.HolySpells?
---@return number
local function GetHolyCastingHolyPower(spells)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData?]]
	if snapshotData == nil or snapshotData.casting == nil or spells == nil then
		return 0
	end

	if spells.flashOfLight ~= nil and snapshotData.casting.spellId == spells.flashOfLight.id then
		return spells.flashOfLight.resource or 0
	elseif spells.holyLight ~= nil and snapshotData.casting.spellId == spells.holyLight.id then
		return spells.holyLight.resource or 0
	end

	return 0
end

local function RefreshLookupData_Holy()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local sharedSettings = TRB.Data.specCache["paladin_holy"].settings
	local castingHolyPower = GetHolyCastingHolyPower(spells)

	-- Side-effect: other systems depend on manaRegen being current
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $casting, $manaMax, $resourceMax, $manaPercent, $resourcePercent)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then

		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = TRB.Data.settings.paladin.holy.colors.text.current.color
		local castingManaColor = TRB.Data.settings.paladin.holy.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$casting"] = _castingMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent

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

	-- Block B: Holy Power ($holyPower, $comboPoints, $holyPowerMax, $comboPointsMax)
	if not activeVars or activeVars["$holyPower"] or activeVars["$comboPoints"]
		or activeVars["$holyPowerMax"] or activeVars["$comboPointsMax"] then
		lookupLogic["$holyPower"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$holyPower"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Casting Holy Power ($castingHolyPower)
	if not activeVars or activeVars["$castingHolyPower"] then
		local castingHolyPowerColor = sharedSettings.colors.text.casting.color

		lookupLogic["$castingHolyPower"] = castingHolyPower

		if lookupChanged(prevState, "$castingHolyPower", castingHolyPower, castingHolyPowerColor) then
			lookup["$castingHolyPower"] = string.format("|c%s%.0f|r", castingHolyPowerColor, castingHolyPower)
		end
	end

	-- Block D: Buff state ($divinePurposeTime)
	if not activeVars or activeVars["$divinePurposeTime"] then
		local currentTime = GetTime()
		local divinePurposeBuff = snapshotData.snapshots[spells.divinePurpose.id]
		local _divinePurposeTime = (divinePurposeBuff ~= nil and divinePurposeBuff.buff:GetRemainingTime(currentTime)) or 0
		lookupLogic["$divinePurposeTime"] = _divinePurposeTime
		if lookupChanged(prevState, "$divinePurposeTime", _divinePurposeTime) then
			lookup["$divinePurposeTime"] = TRB.Functions.BarText:TimerPrecision(_divinePurposeTime)
		end
	end

	-- Block E: Holy Power Plus Casting ($holyPowerPlusCasting, $comboPointsPlusCasting)
	if not activeVars or activeVars["$holyPowerPlusCasting"] or activeVars["$comboPointsPlusCasting"] then
		local holyPowerPlusCastingColor = sharedSettings.colors.text.casting.color
		local holyPowerPlusCasting = snapshotData.attributes.resource2 + castingHolyPower

		lookupLogic["$holyPowerPlusCasting"] = holyPowerPlusCasting
		lookupLogic["$comboPointsPlusCasting"] = holyPowerPlusCasting

		if lookupChanged(prevState, "$holyPowerPlusCasting", holyPowerPlusCasting, holyPowerPlusCastingColor) then
			local f = string.format("|c%s%.0f|r", holyPowerPlusCastingColor, holyPowerPlusCasting)
			lookup["$holyPowerPlusCasting"] = f
			lookup["$comboPointsPlusCasting"] = f
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Protection()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]
	local sharedSettings = TRB.Data.specCache["paladin_protection"].settings

	-- Side-effect: other systems depend on manaRegen being current
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $casting, $manaMax, $resourceMax, $manaPercent, $resourcePercent)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then

		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = TRB.Data.settings.paladin.protection.colors.text.current.color
		local castingManaColor = TRB.Data.settings.paladin.protection.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$casting"] = _castingMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent

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

	-- Block B: Holy Power ($holyPower, $comboPoints, $holyPowerMax, $comboPointsMax)
	if not activeVars or activeVars["$holyPower"] or activeVars["$comboPoints"]
		or activeVars["$holyPowerMax"] or activeVars["$comboPointsMax"] then
		lookupLogic["$holyPower"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$holyPower"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Buff state ($divinePurposeTime)
	if not activeVars or activeVars["$divinePurposeTime"] then
		local currentTime = GetTime()
		local divinePurposeBuff = snapshotData.snapshots[spells.divinePurpose.id]
		local _divinePurposeTime = (divinePurposeBuff ~= nil and divinePurposeBuff.buff:GetRemainingTime(currentTime)) or 0
		lookupLogic["$divinePurposeTime"] = _divinePurposeTime
		if lookupChanged(prevState, "$divinePurposeTime", _divinePurposeTime) then
			lookup["$divinePurposeTime"] = TRB.Functions.BarText:TimerPrecision(_divinePurposeTime)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Retribution()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]
	local sharedSettings = TRB.Data.specCache["paladin_retribution"].settings

	-- Side-effect: other systems depend on manaRegen being current
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $casting, $manaMax, $resourceMax, $manaPercent, $resourcePercent)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then

		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = TRB.Data.settings.paladin.retribution.colors.text.current.color
		local castingManaColor = TRB.Data.settings.paladin.retribution.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$casting"] = _castingMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent

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

	-- Block B: Holy Power ($holyPower, $comboPoints, $holyPowerMax, $comboPointsMax)
	if not activeVars or activeVars["$holyPower"] or activeVars["$comboPoints"]
		or activeVars["$holyPowerMax"] or activeVars["$comboPointsMax"] then
		lookupLogic["$holyPower"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$holyPower"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Buff state ($divinePurposeTime)
	if not activeVars or activeVars["$divinePurposeTime"] then
		local currentTime = GetTime()
		local divinePurposeBuff = snapshotData.snapshots[spells.divinePurpose.id]
		local _divinePurposeTime = (divinePurposeBuff ~= nil and divinePurposeBuff.buff:GetRemainingTime(currentTime)) or 0
		lookupLogic["$divinePurposeTime"] = _divinePurposeTime
		if lookupChanged(prevState, "$divinePurposeTime", _divinePurposeTime) then
			lookup["$divinePurposeTime"] = TRB.Functions.BarText:TimerPrecision(_divinePurposeTime)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting(spell)
	local currentTime = GetTime()
	TRB.Data.snapshotData.casting.startTime = currentTime
	TRB.Data.snapshotData.casting.resourceRaw = spell.mana
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.mana)
	TRB.Data.snapshotData.casting.spellId = spell.id
	TRB.Data.snapshotData.casting.icon = spell.icon
end

local function UpdateCastingResourceFinal()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Holy()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting

	if TRB.Data.character.specId == 1 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Holy()
		end
	elseif TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Holy()
		end
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
	--local currentTime = GetTime()
end

---Ages the event-driven Divine Purpose timer. The color indicator reads isActive directly, so the
---timer has to be aged here rather than in the bar text, which is skipped when no bar text uses it.
---@param spells TRB.Classes.Paladin.HolySpells|TRB.Classes.Paladin.ProtectionSpells|TRB.Classes.Paladin.RetributionSpells
---@param currentTime number
local function UpdateDivinePurpose(spells, currentTime)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local divinePurposeSnapshot = snapshotData.snapshots[spells.divinePurpose.id]
	if divinePurposeSnapshot == nil then
		return
	end

	local wasActive = divinePurposeSnapshot.buff.isActive
	divinePurposeSnapshot.buff:GetRemainingTime(currentTime)
	if wasActive and not divinePurposeSnapshot.buff.isActive then
		-- Expiry can beat the overlay's hide, so rearm the cue here to keep the next proc audible.
		snapshotData.audio.divinePurposePlayed = false
		TRB.Functions.BarText:MarkLookupDirty()
	end
end

local function UpdateSnapshot_Holy()
	local currentTime = GetTime()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	spells.flashOfLight:GetCastTime()
	UpdateDivinePurpose(spells, currentTime)
end

local function UpdateSnapshot_Protection()
	local currentTime = GetTime()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]
	spells.flashOfLight:GetCastTime()
	UpdateDivinePurpose(spells, currentTime)
end

local function UpdateSnapshot_Retribution()
	local currentTime = GetTime()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]
	UpdateDivinePurpose(spells, currentTime)
end

---Processes holy power threshold audio cues for any Paladin spec
---@param specSettings table The spec-specific settings table containing audio thresholds
local function ProcessHolyPowerAudioCues(specSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local coreSettings = TRB.Data.settings.core
	local currentResource2 = snapshotData.attributes.resource2 or 0
	local threshold1 = specSettings.audio.holyPowerThreshold1
	local threshold2 = specSettings.audio.holyPowerThreshold2
	local threshold3 = specSettings.audio.holyPowerThreshold3
	local threshold1Value = threshold1.configuration.thresholdValue
	local threshold2Value = threshold2.configuration.thresholdValue
	local threshold3Value = threshold3.configuration.thresholdValue

	local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.holyPowerThreshold1Played and currentResource2 >= threshold1Value
	local threshold2ShouldFire = threshold2.enabled and not snapshotData.audio.holyPowerThreshold2Played and currentResource2 >= threshold2Value
	local threshold3ShouldFire = threshold3.enabled and not snapshotData.audio.holyPowerThreshold3Played and currentResource2 >= threshold3Value

	if threshold1ShouldFire or threshold2ShouldFire or threshold3ShouldFire then
		local highestValue = 0
		local highestSound = nil

		if threshold1ShouldFire then
			snapshotData.audio.holyPowerThreshold1Played = true
			if threshold1Value > highestValue then
				highestValue = threshold1Value
				highestSound = threshold1.sound
			end
		end
		if threshold2ShouldFire then
			snapshotData.audio.holyPowerThreshold2Played = true
			if threshold2Value > highestValue then
				highestValue = threshold2Value
				highestSound = threshold2.sound
			end
		end
		if threshold3ShouldFire then
			snapshotData.audio.holyPowerThreshold3Played = true
			if threshold3Value > highestValue then
				highestValue = threshold3Value
				highestSound = threshold3.sound
			end
		end

		if highestSound then
			PlaySoundFile(highestSound, coreSettings.audio.channel.channel)
		end
	end

	if currentResource2 < threshold1Value then
		snapshotData.audio.holyPowerThreshold1Played = false
	end
	if currentResource2 < threshold2Value then
		snapshotData.audio.holyPowerThreshold2Played = false
	end
	if currentResource2 < threshold3Value then
		snapshotData.audio.holyPowerThreshold3Played = false
	end
end

local function HandleSpellEvents(self, event, ...)
	if event == "SPELL_ACTIVATION_OVERLAY_SHOW" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells|TRB.Classes.Paladin.ProtectionSpells|TRB.Classes.Paladin.RetributionSpells]]
			if spellId == spells.divinePurpose.spellId then
				local currentTime = GetTime()
				local divinePurposeSnapshot = snapshotData.snapshots[spells.divinePurpose.id]
				local wasActive = divinePurposeSnapshot ~= nil and divinePurposeSnapshot.buff.isActive

				if not wasActive then
					local specSettings = TRB.Data.settings.paladin[TRB.Data.character.specName]
					if specSettings.audio.divinePurpose.enabled and not snapshotData.audio.divinePurposePlayed then
						PlaySoundFile(specSettings.audio.divinePurpose.sound, TRB.Data.settings.core.audio.channel.channel)
						snapshotData.audio.divinePurposePlayed = true
					end
				end

				-- Timed from the spell definition: the aura is secret, and a proc is always a full
				-- duration because spending it is what would have to roll the next one.
				if divinePurposeSnapshot ~= nil then
					divinePurposeSnapshot.buff:InitializeCustom(spells.divinePurpose.duration, currentTime)
				end
				TRB.Functions.BarText:MarkLookupDirty()
			end
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_HIDE" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells|TRB.Classes.Paladin.ProtectionSpells|TRB.Classes.Paladin.RetributionSpells]]
			if spellId == spells.divinePurpose.spellId then
				local divinePurposeSnapshot = snapshotData.snapshots[spells.divinePurpose.id]
				if divinePurposeSnapshot ~= nil then
					divinePurposeSnapshot.buff:Reset()
				end
				snapshotData.audio.divinePurposePlayed = false
				TRB.Functions.BarText:MarkLookupDirty()
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

local function UpdateResourceBar()
	local refreshText = false
	local classSettings = TRB.Data.settings.paladin
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	Bar:HideResourceBar()

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	local function UpdateHolyPower(specSettings, specCacheSettings, holyPowerColors, castingHolyPower)
		local currentHolyPower = snapshotData.attributes.resource2 or 0
		local backgroundColor = holyPowerColors and holyPowerColors.background or specSettings.colors.comboPoints.background.color
		local barOverrideActive = holyPowerColors and holyPowerColors.barOverridden == true
		local castingSettings = specCacheSettings.colors.comboPoints.casting
		local castingTexture = specCacheSettings.textures.comboPointsCastingBar
		local incomingHolyPower = castingHolyPower or 0
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(backgroundColor, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = holyPowerColors and holyPowerColors.border or specSettings.colors.comboPoints.border.color
			local cpColor = holyPowerColors and holyPowerColors.bar or specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = currentHolyPower >= x
			local overlayAmount = 0

			if incomingHolyPower > 0 then
				local nodeStart = x - 1
				local nodeEnd = x
				local predictionEnd = math.min(currentHolyPower + incomingHolyPower, TRB.Data.character.maxResource2)
				overlayAmount = math.max(0, math.min(predictionEnd, nodeEnd) - math.max(currentHolyPower, nodeStart))
			end

			if filled and not barOverrideActive then
				if (specSettings.comboPoints.sameColor and currentHolyPower == (TRB.Data.character.maxResource2 - 3)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 3)) then
					cpColor = specSettings.colors.comboPoints.second
				elseif (specSettings.comboPoints.sameColor and currentHolyPower == (TRB.Data.character.maxResource2 - 2)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 2)) then
					cpColor = specSettings.colors.comboPoints.third
				elseif (specSettings.comboPoints.sameColor and currentHolyPower == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and currentHolyPower == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end

			if barGroups and barGroups.secondary then
				local holyPowerNode = barGroups.secondary:GetNode(x)
				if holyPowerNode then
					Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, holyPowerNode, filled and 1 or 0, 1)
					holyPowerNode:SetBorderColor(cpBorderColor)
					TRB.Functions.Color:ApplyFillColor(holyPowerNode, cpColor)
					holyPowerNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					Bar:ApplyEndCapIndicator(holyPowerNode, "holyPowerBar")

					if castingSettings ~= nil and (overlayAmount ~= 0 or holyPowerNode:GetOverlaySlot("casting") ~= nil) then
						Bar:UpdateCastingResourceOverlay(holyPowerNode, snapshotData, specCacheSettings, overlayAmount, 1, castingSettings, nil, castingTexture)
					end
				end
			end
		end
	end

	local function ApplyFlatIndicatorColors(sharedColors, conditionMap, barColorMap)
		-- barOverridden tells the render below to skip the resource-threshold fill curve: once an indicator
		-- owns the fill, its flat color has to survive rather than being recomputed from the resource.
		local overrides = {}
		for barKey in pairs(barColorMap) do
			overrides[barKey] = {}
		end

		TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap, overrides)

		for barKey, colorEntry in pairs(barColorMap) do
			if overrides[barKey].bar then
				colorEntry.barOverridden = true
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.holy
		local specCacheSettings = TRB.Data.specCache.paladin_holy.settings
		UpdateSnapshot_Holy()
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
		local castingHolyPower = GetHolyCastingHolyPower(spells)
		local infusionOfLightActive = spells.flashOfLight:IsInstant()
		local divinePurposeBuff = snapshotData.snapshots[spells.divinePurpose.id]
		local divinePurposeActive = divinePurposeBuff ~= nil and divinePurposeBuff.buff.isActive
		local manaBarColors = {
			bar = specSettings.colors.bar.base,
			border = specSettings.colors.bar.border.color,
			background = specSettings.colors.bar.background.color,
		}
		local holyPowerColors = {
			bar = specSettings.colors.comboPoints.base,
			border = specSettings.colors.comboPoints.border.color,
			background = specSettings.colors.comboPoints.background.color,
		}
		ApplyFlatIndicatorColors(specSettings.colors.shared, { infusionOfLight = infusionOfLightActive, divinePurpose = divinePurposeActive }, {
			manaBar = manaBarColors,
			holyPowerBar = holyPowerColors,
		})
		if snapshotData.attributes.isTracking then
			if infusionOfLightActive then
				if specSettings.audio.infusionOfLight.enabled and not snapshotData.audio.infusionOfLightPlayed then
					PlaySoundFile(specSettings.audio.infusionOfLight.sound, TRB.Data.settings.core.audio.channel.channel)
					snapshotData.audio.infusionOfLightPlayed = true
				end
			else
				snapshotData.audio.infusionOfLightPlayed = false
			end

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")
				primaryNode:SetBorderColor(manaBarColors.border)
				TRB.Functions.Color:ApplyFillColor(primaryNode, manaBarColors.bar)
				primaryNode:SetBackgroundColorFromString(manaBarColors.background)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				UpdateHolyPower(specSettings, specCacheSettings, holyPowerColors, castingHolyPower)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end

		end

		-- Holy Power threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessHolyPowerAudioCues(specSettings)
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.protection
		local specCacheSettings = TRB.Data.specCache.paladin_protection.settings
		UpdateSnapshot_Protection()
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]
		local infusionOfLightActive = spells.flashOfLight:IsInstant()
		local divinePurposeBuff = snapshotData.snapshots[spells.divinePurpose.id]
		local divinePurposeActive = divinePurposeBuff ~= nil and divinePurposeBuff.buff.isActive
		local manaBarColors = {
			bar = specSettings.colors.bar.base,
			border = specSettings.colors.bar.border.color,
			background = specSettings.colors.bar.background.color,
		}
		local holyPowerColors = {
			bar = specSettings.colors.comboPoints.base,
			border = specSettings.colors.comboPoints.border.color,
			background = specSettings.colors.comboPoints.background.color,
		}
		ApplyFlatIndicatorColors(specSettings.colors.shared, { infusionOfLight = infusionOfLightActive, divinePurpose = divinePurposeActive }, {
			manaBar = manaBarColors,
			holyPowerBar = holyPowerColors,
		})
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")
				primaryNode:SetBorderColor(manaBarColors.border)
				TRB.Functions.Color:ApplyFillColor(primaryNode, manaBarColors.bar)
				primaryNode:SetBackgroundColorFromString(manaBarColors.background)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				UpdateHolyPower(specSettings, specCacheSettings, holyPowerColors)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end

		end

		-- Holy Power threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessHolyPowerAudioCues(specSettings)
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.retribution
		local specCacheSettings = TRB.Data.specCache.paladin_retribution.settings
		UpdateSnapshot_Retribution()
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]
		local divinePurposeBuff = snapshotData.snapshots[spells.divinePurpose.id]
		local divinePurposeActive = divinePurposeBuff ~= nil and divinePurposeBuff.buff.isActive
		local manaBarColors = {
			bar = specSettings.colors.bar.base,
			border = specSettings.colors.bar.border.color,
			background = specSettings.colors.bar.background.color,
		}
		local holyPowerColors = {
			bar = specSettings.colors.comboPoints.base,
			border = specSettings.colors.comboPoints.border.color,
			background = specSettings.colors.comboPoints.background.color,
		}
		ApplyFlatIndicatorColors(specSettings.colors.shared, { divinePurpose = divinePurposeActive }, {
			manaBar = manaBarColors,
			holyPowerBar = holyPowerColors,
		})
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")
				primaryNode:SetBorderColor(manaBarColors.border)
				TRB.Functions.Color:ApplyFillColor(primaryNode, manaBarColors.bar)
				primaryNode:SetBackgroundColorFromString(manaBarColors.background)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				UpdateHolyPower(specSettings, specCacheSettings, holyPowerColors)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end

		end

		-- Holy Power threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessHolyPowerAudioCues(specSettings)
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
		specCache.paladin_holy.talents:GetTalents()
		FillSpellData_Holy()
		Character:LoadFromSpecializationCache(specCache.paladin_holy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Holy
		Bar:UpdateSanityCheckValues(specCache.paladin_holy.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "paladin_holy" then
			talents = specCache.paladin_holy.talents
			TRB.Data.barConstructedForSpec = "paladin_holy"
			ConstructResourceBar(specCache.paladin_holy.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.paladin_protection.talents:GetTalents()
		FillSpellData_Protection()
		Character:LoadFromSpecializationCache(specCache.paladin_protection)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Protection
		Bar:UpdateSanityCheckValues(specCache.paladin_protection.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "paladin_protection" then
			talents = specCache.paladin_protection.talents
			TRB.Data.barConstructedForSpec = "paladin_protection"
			ConstructResourceBar(specCache.paladin_protection.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.paladin_retribution.talents:GetTalents()
		FillSpellData_Retribution()
		Character:LoadFromSpecializationCache(specCache.paladin_retribution)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Retribution
		Bar:UpdateSanityCheckValues(specCache.paladin_retribution.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "paladin_retribution" then
			talents = specCache.paladin_retribution.talents
			TRB.Data.barConstructedForSpec = "paladin_retribution"
			ConstructResourceBar(specCache.paladin_retribution.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

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
	
	if TRB.Data.character.classId == 2 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Paladin.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.paladin == nil or
						TwintopInsanityBarSettings.paladin.holy == nil or
						TwintopInsanityBarSettings.paladin.holy.displayText == nil then
						settings.paladin.holy.displayText.barText = TRB.Options.Paladin.HolyLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.paladin == nil or
						TwintopInsanityBarSettings.paladin.protection == nil or
						TwintopInsanityBarSettings.paladin.protection.displayText == nil then
						settings.paladin.protection.displayText.barText = TRB.Options.Paladin.ProtectionLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.paladin == nil or
						TwintopInsanityBarSettings.paladin.retribution == nil or
						TwintopInsanityBarSettings.paladin.retribution.displayText == nil then
						settings.paladin.retribution.displayText.barText = TRB.Options.Paladin.RetributionLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.paladin ~= true then
						TRB.Data.settings.paladin.holy.displayText.barText = TRB.Options.Paladin.HolyLoadDefaultBarTextSettings()
						TRB.Data.settings.paladin.protection.displayText.barText = TRB.Options.Paladin.ProtectionLoadDefaultBarTextSettings()
						TRB.Data.settings.paladin.retribution.displayText.barText = TRB.Options.Paladin.RetributionLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.paladin = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Paladin"])
					end
				else
					local settings = TRB.Options.Paladin.LoadDefaultSettings(true)
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
						TRB.Data.settings.paladin.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PaladinHolyFull"], TRB.Data.settings.paladin.holy)
						TRB.Data.settings.paladin.protection = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PaladinProtectionFull"], TRB.Data.settings.paladin.protection)
						TRB.Data.settings.paladin.retribution = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PaladinRetributionFull"], TRB.Data.settings.paladin.retribution)
						
						FillSpellData_Holy()
						FillSpellData_Protection()
						FillSpellData_Retribution()
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Paladin.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "paladin"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	TRB.Data.character.maxResource2 = 1
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
		TRB.Data.character.specName = "holy"
		TRB.Data.character.compositeKey = "paladin_holy"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "protection"
		TRB.Data.character.compositeKey = "paladin_protection"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "retribution"
		TRB.Data.character.compositeKey = "paladin_retribution"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	end

	if sharedSettings ~= nil then
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			if barGroups and barGroups.primary then
				Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.paladin.holy then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.HolyPower
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.paladin.protection then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.HolyPower
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.paladin.retribution then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.HolyPower
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

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, true, TRB.Data.character.maxResource2, nil),
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
	if snapshotData and snapshotData.snapshots then
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells and spells.divinePurpose then
			local divinePurposeSnapshot = snapshotData.snapshots[spells.divinePurpose.id]
			if divinePurposeSnapshot ~= nil then
				divinePurposeSnapshot.buff:Reset()
			end
		end
	end
end

local specValidVars
do
	local shared = {
		["$casting"] = function()
			local c = TRB.Data.snapshotData.casting
			return c.resourceRaw ~= nil and c.resourceRaw ~= 0
		end,
		["$resource"] = false, ["$mana"] = false,
		["$resourcePercent"] = false, ["$manaPercent"] = false,
		["$resourceMax"] = true, ["$manaMax"] = true,
		["$comboPoints"] = true, ["$holyPower"] = true,
		["$comboPointsMax"] = true, ["$holyPowerMax"] = true,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
		["$divinePurposeTime"] = function()
			local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
			if spells == nil or spells.divinePurpose == nil then
				return false
			end
			local snap = TRB.Data.snapshotData.snapshots[spells.divinePurpose.id]
			return snap ~= nil and snap.buff.isActive == true
		end,
	}
	local holy = {}
	for key, entry in pairs(shared) do
		holy[key] = entry
	end
	holy["$castingHolyPower"] = function()
		local value = TRB.Data.lookupLogic and TRB.Data.lookupLogic["$castingHolyPower"]
		return value ~= nil and not issecretvalue(value) and value ~= 0
	end
	holy["$holyPowerPlusCasting"] = true
	holy["$comboPointsPlusCasting"] = true
	specValidVars = { [1] = holy, [2] = shared, [3] = shared }
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

	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local holyPowerNode = barGroups.secondary:GetNode(comboPoint)
			if holyPowerNode then
				local isVisible = barGroups.secondary.isVisible and holyPowerNode.isVisible
				return holyPowerNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

---Returns true while $divinePurposeTime is counting down, which is driven by elapsed time rather
---than by any event. All 3 specs share it.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local snapshotData = TRB.Data.snapshotData
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
	if not snapshotData or not spells then return false end
	local snapshots = snapshotData.snapshots
	local specId = TRB.Data.character.specId
	if specId == 1 or specId == 2 or specId == 3 then
		if spells.divinePurpose and snapshots[spells.divinePurpose.id] and snapshots[spells.divinePurpose.id].buff and snapshots[spells.divinePurpose.id].buff.isActive then
			return true
		end
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
