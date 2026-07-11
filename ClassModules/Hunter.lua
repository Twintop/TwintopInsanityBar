local _, TRB = ...
if TRB.Data.character.classId ~= 3 then --Only do this if we're on a Hunter!
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

---@type TRB.Classes.Talents
local talents

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	hunter_beastMastery = TRB.Classes.SpecCache:New(),
	hunter_marksmanship = TRB.Classes.SpecCache:New(),
	hunter_survival = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Beast Mastery
	specCache.hunter_beastMastery.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		}
	}

	specCache.hunter_beastMastery.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		petGuid = UnitGUID("pet"),
		maxResource = 100
	}
	
	---@type TRB.Classes.Hunter.BeastMasterySpells
	specCache.hunter_beastMastery.spellsData.spells = TRB.Classes.Hunter.BeastMasterySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	local spells = specCache.hunter_beastMastery.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]

	specCache.hunter_beastMastery.snapshotData.attributes.resourceRegen = 0
	specCache.hunter_beastMastery.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.hunter_beastMastery.snapshotData.snapshots[spells.killCommand.id] = TRB.Classes.Snapshot:New(spells.killCommand)
	---@type TRB.Classes.Snapshot
	specCache.hunter_beastMastery.snapshotData.snapshots[spells.bestialWrath.id] = TRB.Classes.Snapshot:New(spells.bestialWrath)
	---@type TRB.Classes.Snapshot
	specCache.hunter_beastMastery.snapshotData.snapshots[spells.wailingArrow.id] = TRB.Classes.Snapshot:New(spells.wailingArrow)
	---@type TRB.Classes.Snapshot
	specCache.hunter_beastMastery.snapshotData.snapshots[spells.beastCleave.id] = TRB.Classes.Snapshot:New(spells.beastCleave)
	---@type TRB.Classes.Snapshot
	specCache.hunter_beastMastery.snapshotData.snapshots[spells.blackArrow.id] = TRB.Classes.Snapshot:New(spells.blackArrow)
	---@type TRB.Classes.Snapshot
	specCache.hunter_beastMastery.snapshotData.snapshots[spells.direBeastHawk.id] = TRB.Classes.Snapshot:New(spells.direBeastHawk)
	---@type TRB.Classes.Snapshot
	specCache.hunter_beastMastery.snapshotData.snapshots[spells.wildThrash.id] = TRB.Classes.Snapshot:New(spells.wildThrash)

	specCache.hunter_beastMastery.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Marksmanship

	specCache.hunter_marksmanship.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		}
	}

	specCache.hunter_marksmanship.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100
	}
	
	---@type TRB.Classes.Hunter.MarksmanshipSpells
	specCache.hunter_marksmanship.spellsData.spells = TRB.Classes.Hunter.MarksmanshipSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.hunter_marksmanship.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]

	specCache.hunter_marksmanship.snapshotData.attributes.resourceRegen = 0
	specCache.hunter_marksmanship.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.hunter_marksmanship.snapshotData.snapshots[spells.trueshot.id] = TRB.Classes.Snapshot:New(spells.trueshot)
	---@type TRB.Classes.Snapshot
	specCache.hunter_marksmanship.snapshotData.snapshots[spells.aimedShot.id] = TRB.Classes.Snapshot:New(spells.aimedShot)
	---@type TRB.Classes.Snapshot
	specCache.hunter_marksmanship.snapshotData.snapshots[spells.killShot.id] = TRB.Classes.Snapshot:New(spells.killShot)
	---@type TRB.Classes.Snapshot
	specCache.hunter_marksmanship.snapshotData.snapshots[spells.blackArrow.id] = TRB.Classes.Snapshot:New(spells.blackArrow)
	---@type TRB.Classes.Snapshot
	specCache.hunter_marksmanship.snapshotData.snapshots[spells.wailingArrow.id] = TRB.Classes.Snapshot:New(spells.wailingArrow)
	---@type TRB.Classes.Snapshot
	specCache.hunter_marksmanship.snapshotData.snapshots[spells.explosiveShot.id] = TRB.Classes.Snapshot:New(spells.explosiveShot)

	specCache.hunter_marksmanship.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Survival
	specCache.hunter_survival.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
		}
	}

	specCache.hunter_survival.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		maxResource2 = 3
	}
	
	---@type TRB.Classes.Hunter.SurvivalSpells
	specCache.hunter_survival.spellsData.spells = TRB.Classes.Hunter.SurvivalSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.hunter_survival.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]

	specCache.hunter_survival.snapshotData.attributes.resourceRegen = 0
	specCache.hunter_survival.snapshotData.audio = {
		totsThreshold1Played = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.hunter_survival.snapshotData.snapshots[spells.killCommand.id] = TRB.Classes.Snapshot:New(spells.killCommand)
	---@type TRB.Classes.Snapshot
	specCache.hunter_survival.snapshotData.snapshots[spells.wildfireBomb.id] = TRB.Classes.Snapshot:New(spells.wildfireBomb)
	---@type TRB.Classes.Snapshot
	specCache.hunter_survival.snapshotData.snapshots[spells.boomstick.id] = TRB.Classes.Snapshot:New(spells.boomstick)
	---@type TRB.Classes.Snapshot
	specCache.hunter_survival.snapshotData.snapshots[spells.takedown.id] = TRB.Classes.Snapshot:New(spells.takedown)
	---@type TRB.Classes.Snapshot
	specCache.hunter_survival.snapshotData.snapshots[spells.tipOfTheSpear.id] = TRB.Classes.Snapshot:New(spells.tipOfTheSpear)
	

	specCache.hunter_survival.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_BeastMastery()
	Character:FillSpecializationCacheSettings("hunter", "beastMastery")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "hunter_beastMastery" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Hunter.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_BeastMastery()
	Setup_BeastMastery()
	specCache.hunter_beastMastery.spellsData:FillSpellData()
	local spells = specCache.hunter_beastMastery.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]

	TRB.Classes.Hunter.BeastMasterySpells.FillBarTextVariables(specCache.hunter_beastMastery)
end

local function Setup_Marksmanship()
	Character:FillSpecializationCacheSettings("hunter", "marksmanship")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "hunter_marksmanship" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Hunter.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Marksmanship()
	Setup_Marksmanship()
	specCache.hunter_marksmanship.spellsData:FillSpellData()
	local spells = specCache.hunter_marksmanship.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]

	TRB.Classes.Hunter.MarksmanshipSpells.FillBarTextVariables(specCache.hunter_marksmanship)
end

local function Setup_Survival()
	Character:FillSpecializationCacheSettings("hunter", "survival", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "hunter_survival" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Hunter.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Survival()
	Setup_Survival()
	specCache.hunter_survival.spellsData:FillSpellData()
	local spells = specCache.hunter_survival.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]

	TRB.Classes.Hunter.SurvivalSpells.FillBarTextVariables(specCache.hunter_survival)
end

local function GetSurvivalTipOfTheSpearMaxStacks()
	local spellsData = TRB.Data.spellsData
	if spellsData == nil or spellsData.spells == nil or talents == nil then
		return 0
	end

	local spells = spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
	if talents:IsTalentActive(spells.tipOfTheSpear) then
		return spells.tipOfTheSpear.maxStacks or 0
	end

	return 0
end

local function CalculateAbilityResourceValue(resource, threshold)
	local modifier = 1.0
	if TRB.Data.character.specId == 2 then
		if resource > 0 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
			local trueshot = TRB.Data.snapshotData.snapshots[spells.trueshot.id] --[[@as TRB.Classes.Snapshot]]
			if trueshot.buff.isActive and not threshold then
				modifier = modifier * trueshot.spell.attributes.resourcePercent
			end
		end
	end

	return resource * modifier
end

local function UpdateCastingResourceFinal()
	TRB.Data.snapshotData.casting.resourceFinal = TRB.Data.snapshotData.casting.resourceRaw
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

	-- Survival uses secondary bar (Tip of the Spear). Seed the talent-gated node count
	-- before layout so match-width calculations use the real rendered node count.
	if barGroups and barGroups.secondary and TRB.Data.character.specId == 3 then
		local maxStacks = GetSurvivalTipOfTheSpearMaxStacks()
		TRB.Data.character.maxResource2 = maxStacks
		barGroups.secondary.lastRebuildNodeCount = maxStacks
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

	-- Survival uses secondary bar (Tip of the Spear); BM/MM do not.
	if barGroups and barGroups.secondary then
		if TRB.Data.character.specId == 3 then
			local maxStacks = TRB.Data.character.maxResource2 or 0
			if maxStacks > 0 then
				barGroups.secondary:RebuildNodes(maxStacks, settings)
			else
				barGroups.secondary:Hide()
			end
		else
			barGroups.secondary:Hide()
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_BeastMastery()
	local specSettings = TRB.Data.settings.hunter.beastMastery
	local sharedSettings = TRB.Data.specCache["hunter_beastMastery"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core focus ($focus, $resource, $casting, $focusMax, $resourceMax)
	if not activeVars or activeVars["$focus"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$focusMax"] or activeVars["$resourceMax"] then

		local _currentFocus = snapshotData.attributes.resource
		local _castingFocus = snapshotData.casting.resourceFinal
		local currentFocusColor = sharedSettings.colors.text.current.color
		local castingFocusColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.primaryResourceType and spell.settingKey and sharedSettings.thresholds.thresholdDictionary[spell.settingKey] and sharedSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFocusColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		if _castingFocus < 0 then
			castingFocusColor = sharedSettings.colors.text.spending.color
		end

		lookupLogic["$resource"] = _currentFocus
		lookupLogic["$focus"] = _currentFocus
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$casting"] = _castingFocus

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$focus", resourceFormatted, currentFocusColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingFocus, castingFocusColor)
		if resourceChanged or castingChanged then
			local currentFocus
			local castingFocus
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentFocusColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentFocus = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", _castingFocus))
			else
				currentFocus = string.format("|c%s%s|r", currentFocusColor, resourceFormatted)
				castingFocus = string.format("|c%s%.0f|r", castingFocusColor, _castingFocus)
			end
			lookup["$resource"] = currentFocus
			lookup["$focus"] = currentFocus
			lookup["$casting"] = castingFocus
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$focusMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Beast Cleave ($beastCleaveTime)
	if not activeVars or activeVars["$beastCleaveTime"] then
		local currentTime = GetTime()
		local _beastCleaveTime = snapshots[spells.beastCleave.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$beastCleaveTime"] = _beastCleaveTime

		if lookupChanged(prevState, "$beastCleaveTime", _beastCleaveTime) then
			lookup["$beastCleaveTime"] = TRB.Functions.BarText:TimerPrecision(_beastCleaveTime)
		end
	end

	-- Block C: Bestial Wrath ($bestialWrathTime)
	if not activeVars or activeVars["$bestialWrathTime"] then
		local currentTime = GetTime()
		local _bestialWrathTime = snapshots[spells.bestialWrath.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$bestialWrathTime"] = _bestialWrathTime

		if lookupChanged(prevState, "$bestialWrathTime", _bestialWrathTime) then
			lookup["$bestialWrathTime"] = TRB.Functions.BarText:TimerPrecision(_bestialWrathTime)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Marksmanship()
	local specSettings = TRB.Data.settings.hunter.marksmanship
	local sharedSettings = TRB.Data.specCache["hunter_marksmanship"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core focus ($focus, $resource, $casting, $focusMax, $resourceMax)
	if not activeVars or activeVars["$focus"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$focusMax"] or activeVars["$resourceMax"] then

		local _currentFocus = snapshotData.attributes.resource
		local _castingFocus = snapshotData.casting.resourceFinal
		local currentFocusColor = sharedSettings.colors.text.current.color
		local castingFocusColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.primaryResourceType and spell.settingKey and sharedSettings.thresholds.thresholdDictionary[spell.settingKey] and sharedSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFocusColor = sharedSettings.colors.text.overThreshold.color
					castingFocusColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		if _castingFocus < 0 then
			castingFocusColor = sharedSettings.colors.text.spending.color
		end

		lookupLogic["$resource"] = _currentFocus
		lookupLogic["$focus"] = _currentFocus
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$casting"] = _castingFocus

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$focus", resourceFormatted, currentFocusColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingFocus, castingFocusColor)
		if resourceChanged or castingChanged then
			local currentFocus
			local castingFocus
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentFocusColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentFocus = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", _castingFocus))
			else
				currentFocus = string.format("|c%s%s|r", currentFocusColor, resourceFormatted)
				castingFocus = string.format("|c%s%.0f|r", castingFocusColor, _castingFocus)
			end
			lookup["$resource"] = currentFocus
			lookup["$focus"] = currentFocus
			lookup["$casting"] = castingFocus
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$focusMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Trueshot ($trueshotTime)
	if not activeVars or activeVars["$trueshotTime"] then
		local currentTime = GetTime()
		local _trueshotTime = snapshots[spells.trueshot.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$trueshotTime"] = _trueshotTime

		if lookupChanged(prevState, "$trueshotTime", _trueshotTime) then
			lookup["$trueshotTime"] = TRB.Functions.BarText:TimerPrecision(_trueshotTime)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Survival()
	local specSettings = TRB.Data.settings.hunter.survival
	local sharedSettings = TRB.Data.specCache["hunter_survival"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core focus ($focus, $resource, $casting, $focusMax, $resourceMax)
	if not activeVars or activeVars["$focus"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$focusMax"] or activeVars["$resourceMax"] then

		local _currentFocus = snapshotData.attributes.resource
		local _castingFocus = snapshotData.casting.resourceFinal
		local currentFocusColor = sharedSettings.colors.text.current.color
		local castingFocusColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.primaryResourceType and spell.settingKey and sharedSettings.thresholds.thresholdDictionary[spell.settingKey] and sharedSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFocusColor = sharedSettings.colors.text.overThreshold.color
					castingFocusColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		if _castingFocus < 0 then
			castingFocusColor = sharedSettings.colors.text.spending.color
		end

		lookupLogic["$resource"] = _currentFocus
		lookupLogic["$focus"] = _currentFocus
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$focusMax"] = TRB.Data.character.maxResource
		lookupLogic["$casting"] = _castingFocus

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$focus", resourceFormatted, currentFocusColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingFocus, castingFocusColor)
		if resourceChanged or castingChanged then
			local currentFocus
			local castingFocus
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentFocusColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentFocus = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingFocus = textColorResult:WrapTextInColorCode(string.format("%.0f", _castingFocus))
			else
				currentFocus = string.format("|c%s%s|r", currentFocusColor, resourceFormatted)
				castingFocus = string.format("|c%s%.0f|r", castingFocusColor, _castingFocus)
			end
			lookup["$resource"] = currentFocus
			lookup["$focus"] = currentFocus
			lookup["$casting"] = castingFocus
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$focusMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Tip of the Spear ($tipOfTheSpear, $comboPoints, $tipOfTheSpearMax, $comboPointsMax, $totsTime)
	if not activeVars or activeVars["$tipOfTheSpear"] or activeVars["$comboPoints"]
		or activeVars["$tipOfTheSpearMax"] or activeVars["$comboPointsMax"]
		or activeVars["$totsTime"] then
		local currentTime = GetTime()
		local _tipOfTheSpear = snapshots[spells.tipOfTheSpear.id].buff.applications or 0
		local _tipOfTheSpearMax = spells.tipOfTheSpear.maxStacks
		local _totsTime = snapshots[spells.tipOfTheSpear.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$totsTime"] = _totsTime
		lookupLogic["$tipOfTheSpear"] = _tipOfTheSpear
		lookupLogic["$comboPoints"] = _tipOfTheSpear
		lookupLogic["$tipOfTheSpearMax"] = _tipOfTheSpearMax
		lookupLogic["$comboPointsMax"] = _tipOfTheSpearMax

		if lookupChanged(prevState, "$totsTime", _totsTime) then
			lookup["$totsTime"] = TRB.Functions.BarText:TimerPrecision(_totsTime)
		end

		lookup["$tipOfTheSpear"] = _tipOfTheSpear
		lookup["$comboPoints"] = _tipOfTheSpear
		lookup["$tipOfTheSpearMax"] = _tipOfTheSpearMax
		lookup["$comboPointsMax"] = _tipOfTheSpearMax
	end

	-- Block C: Takedown ($takedownTime)
	if not activeVars or activeVars["$takedownTime"] then
		local currentTime = GetTime()
		local _takedownTime = snapshots[spells.takedown.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$takedownTime"] = _takedownTime

		if lookupChanged(prevState, "$takedownTime", _takedownTime) then
			lookup["$takedownTime"] = TRB.Functions.BarText:TimerPrecision(_takedownTime)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

---comment
---@param spell TRB.Classes.SpellBase
local function FillSnapshotDataCasting(spell, mod)
	mod = mod or 0
	local currentTime = GetTime()
	local casting = TRB.Data.snapshotData.casting --[[@as TRB.Classes.SnapshotCasting]]
	casting.startTime = currentTime
	if spell.resource ~= nil and spell.resource + mod > 0 then
		casting.resourceRaw = spell.resource + mod
		casting.resourceFinal = CalculateAbilityResourceValue(spell.resource + mod)
	else
		casting.resourceRaw = -spell:GetPrimaryResourceCost()
		casting.resourceFinal = casting.resourceRaw
	end
	casting.spellId = spell.id
	casting.icon = spell.icon
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
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.scareBeast.id then
				FillSnapshotDataCasting(spells.scareBeast)
			elseif spellId == spells.revivePet.id then
				FillSnapshotDataCasting(spells.revivePet)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.bestialWrath.castId then
				snapshotData.snapshots[spells.bestialWrath.id].buff:InitializeCustom(spells.bestialWrath.duration, currentTime)
			elseif spellId == spells.wildThrash.castId then
				snapshotData.snapshots[spells.beastCleave.id].buff:InitializeCustom(spells.beastCleave.duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.aimedShot.id then
				FillSnapshotDataCasting(spells.aimedShot)
			elseif spellId == spells.steadyShot.id then
				if talents:IsTalentActive(spells.invigoratingPulse) then
					FillSnapshotDataCasting(spells.steadyShot, spells.invigoratingPulse.attributes.resourceMod)
				else
					FillSnapshotDataCasting(spells.steadyShot)
				end
			elseif spellId == spells.scareBeast.id then
				FillSnapshotDataCasting(spells.scareBeast)
			elseif spellId == spells.revivePet.id then
				FillSnapshotDataCasting(spells.revivePet)
			end
			UpdateCastingResourceFinal()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.rapidFire.id then
				local _, _, _, currentChannelStartTime, currentChannelEndTime, _, _, _ = UnitChannelInfo("player")
				casting.spellId = spells.rapidFire.id
				casting.icon = spells.rapidFire.icon
				casting.startTime = currentChannelStartTime / 1000
				casting.endTime = currentChannelEndTime / 1000
				local duration = casting.endTime - casting.startTime
				local remainingTime = casting.endTime - currentTime
				local ticksRemaining = math.ceil(remainingTime / (duration / (spells.rapidFire.attributes.shots - 1)))
				casting.resourceRaw = math.max(ticksRemaining * spells.rapidFire.resource, 0)
				casting.resourceFinal = CalculateAbilityResourceValue(casting.resourceRaw)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.trueshot.castId then
				local duration = spells.trueshot.duration
				if talents:IsTalentActive(spells.cantMissWontMiss) then
					duration = duration + spells.cantMissWontMiss.duration
				end
				snapshotData.snapshots[spells.trueshot.id].buff:InitializeCustom(duration, currentTime)
			elseif spellId == spells.explosiveShot.id then
				snapshotData.snapshots[spells.explosiveShot.id].cooldown:InitializeCustom(spells.explosiveShot.cooldown, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.scareBeast.id then
				FillSnapshotDataCasting(spells.scareBeast)
			elseif spellId == spells.revivePet.id then
				FillSnapshotDataCasting(spells.revivePet)
			end
			UpdateCastingResourceFinal()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.takedown.id then
				local duration = spells.takedown.duration
				if talents:IsTalentActive(spells.cantMissWontMiss) then
					duration = duration + spells.cantMissWontMiss.duration
				end
				snapshotData.snapshots[spells.takedown.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.HunterBaseSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
end

local function UpdateDarkRanger()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells|TRB.Classes.Hunter.MarksmanshipSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
end

local function UpdateSnapshot_BeastMastery()
	UpdateSnapshot()
	UpdateDarkRanger()
	
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	snapshots[spells.beastCleave.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Marksmanship()
	UpdateSnapshot()
	UpdateDarkRanger()

	local currentTime = GetTime()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData
	local snapshots = snapshotData.snapshots

	snapshots[spells.explosiveShot.id].cooldown:GetRemainingTime(currentTime)

	if snapshotData.casting.spellId == spells.rapidFire.id then
		local casting = snapshotData.casting
		local duration = casting.endTime - casting.startTime
		local remainingTime = casting.endTime - currentTime
		local ticksRemaining = math.ceil(remainingTime / (duration / (spells.rapidFire.attributes.shots - 1)))
		casting.resourceRaw = math.max(ticksRemaining * spells.rapidFire.resource, 0)
		casting.resourceFinal = CalculateAbilityResourceValue(casting.resourceRaw)
	end
end

local function UpdateSnapshot_Survival()
	UpdateSnapshot()

	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.tipOfTheSpear.id].buff:GetRemainingTime(currentTime)
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.hunter
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
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

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.beastMastery
		local specCacheSettings = TRB.Data.specCache.hunter_beastMastery.settings
		UpdateSnapshot_BeastMastery()

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]				
				local gcd = Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetFrame()
				local thresholds = primaryNode:GetThresholds()
				
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
						Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.blackArrow.id and talents:IsTalentActive(spells.blackArrow) then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.id == spells.killCommand.id then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = frameLevels.thresholdUnusable
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.id == spells.wailingArrow.id then
							if not snapshots[spells.bestialWrath.id].buff.isActive then
								showThreshold = false
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
					if thresholds[thresholdId] then
						local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
						Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
					-- Per-threshold audio cue (independent of line visibility)
					if spell.canHaveAudioCue == true and dictEntry and dictEntry.audio and dictEntry.audio.enabled and dictEntry.audio.sound then
						snapshotData.audio.thresholdCues = snapshotData.audio.thresholdCues or {}
						if isUsable then
							if not snapshotData.audio.thresholdCues[spell.settingKey] then
								snapshotData.audio.thresholdCues[spell.settingKey] = true
								PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						else
							snapshotData.audio.thresholdCues[spell.settingKey] = false
						end
					end
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border.color
				local barBackgroundColor = specSettings.colors.bar.background.color

				local sharedColors = specSettings.colors.shared
				local indicatorColors = sharedColors and sharedColors.indicatorColors
				local nodeOrder = sharedColors and sharedColors.nodeOrder
				local gradientOrder = sharedColors and sharedColors.gradientOrder
				local conditionMap = {
					bestialWrath = snapshots[spells.bestialWrath.id].buff.isActive and affectingCombat,
					bestialWrathEnd = snapshots[spells.bestialWrath.id].buff.isActive and affectingCombat
						and specSettings.endOf.bestialWrath.enabled
						and (snapshots[spells.bestialWrath.id].buff:GetRemainingTime(currentTime) <=
							(specSettings.endOf.bestialWrath.mode == "gcd"
								and Character:GetCurrentGCDTime() * specSettings.endOf.bestialWrath.gcdsMax
								or specSettings.endOf.bestialWrath.timeMax)),
					beastCleave = snapshots[spells.beastCleave.id].buff.isActive,
					borderOvercap = affectingCombat,
				}
				local focusBarColors = { bar = barColor, border = barBorderColor, background = barBackgroundColor }
				local barColorMap = { focusBar = focusBarColors }

				if nodeOrder and indicatorColors then
					for i = #nodeOrder, 1, -1 do
						local key = nodeOrder[i]
						local indicator = indicatorColors[key]
						if indicator and indicator.enabled and conditionMap[key] and indicator.targets then
							for barKey, elements in pairs(indicator.targets) do
								local targetColors = barColorMap[barKey]
								if targetColors and elements then
									for elemKey, isTargeted in pairs(elements) do
										if isTargeted then
											targetColors[elemKey] = (elemKey == "bar") and indicator or indicator.color
										end
									end
								end
							end
						end
					end
				end

				local overcapCurves = {}
				if gradientOrder and indicatorColors then
					for i = #gradientOrder, 1, -1 do
						local key = gradientOrder[i]
						local indicator = indicatorColors[key]
						if indicator and indicator.enabled and conditionMap[key] and indicator.isGradient and indicator.targets then
							local fbTargets = indicator.targets.focusBar
							if fbTargets then
								if fbTargets.border then
									overcapCurves.border = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.border, indicator.color)
								end
								if fbTargets.bar then
									overcapCurves.bar = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.bar, indicator.color)
								end
								if fbTargets.background then
									overcapCurves.background = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.background, indicator.color)
								end
							end
							break
						end
					end
				end

				if spells.bestialWrath:IsUsable() then
					if specSettings.colors.bar.flashEnabled and TRB.Data.character.inCombat then
						Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod, barGroups.primary.currentAlpha)
					else
						barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
					end
				else
					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				end

				if overcapCurves.border then
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.border)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(focusBarColors.border)
				end
				if overcapCurves.bar then
					local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.bar)
					primaryNode:SetColorCurve(barColorResult)
				else
					TRB.Functions.Color:ApplyFillColor(primaryNode, focusBarColors.bar)
				end
				if overcapCurves.background then
					local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.background)
					primaryNode:SetBackgroundColorCurve(backgroundColorResult)
				else
					primaryNode:SetBackgroundColorFromString(focusBarColors.background)
				end
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end
		end

		-- Update health bar
		if not specSettings.displayBar.health.neverShow then
			refreshText = true
			local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
			if healthNode then
				healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
				healthNode:SetValue(snapshotData.attributes.health or 0)
				healthNode:SetColorCurve(snapshotData.attributes.healthColor)
				healthNode:SetBorderColor(specCacheSettings.colors.healthBar.border.color)
				healthNode:SetBackgroundColorFromString(specCacheSettings.colors.healthBar.background.color)
			end
			Bar:UpdateHealthBarOverlays(healthNode, snapshotData, specCacheSettings)
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.marksmanship
		local specCacheSettings = TRB.Data.specCache.hunter_marksmanship.settings
		UpdateSnapshot_Marksmanship()

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
				local gcd = Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = specSettings.colors.bar.border.color
				
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetFrame()
				local thresholds = primaryNode:GetThresholds()
				
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
						Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.aimedShot.id then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = frameLevels.thresholdUnusable
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.id == spells.killShot.id and not talents:IsTalentActive(spells.blackArrow) then
							if snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = frameLevels.thresholdUnusable
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								-- Hide the threshold if we can't use it
								showThreshold = false
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.id == spells.blackArrow.id and talents:IsTalentActive(spells.blackArrow) then
							if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specCacheSettings.colors.threshold.unusable.color
								frameLevel = frameLevels.thresholdUnusable
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								-- Hide the threshold if we can't use it
								showThreshold = false
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.id == spells.wailingArrow.id then
							if not snapshots[spells.trueshot.id].buff.isActive then
								showThreshold = false
							elseif snapshots[spell.id].cooldown:IsUnusable() then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
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
						if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
					if thresholds[thresholdId] then
						local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
						Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
					-- Per-threshold audio cue (independent of line visibility)
					if spell.canHaveAudioCue == true and dictEntry and dictEntry.audio and dictEntry.audio.enabled and dictEntry.audio.sound then
						snapshotData.audio.thresholdCues = snapshotData.audio.thresholdCues or {}
						if isUsable then
							if not snapshotData.audio.thresholdCues[spell.settingKey] then
								snapshotData.audio.thresholdCues[spell.settingKey] = true
								PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						else
							snapshotData.audio.thresholdCues[spell.settingKey] = false
						end
					end
				end

				local barColor = specSettings.colors.bar.base
				local barBackgroundColor = specSettings.colors.bar.background.color

				local sharedColors = specSettings.colors.shared
				local indicatorColors = sharedColors and sharedColors.indicatorColors
				local nodeOrder = sharedColors and sharedColors.nodeOrder
				local gradientOrder = sharedColors and sharedColors.gradientOrder
				local conditionMap = {
					trueshot = snapshots[spells.trueshot.id].buff.isActive,
					trueshotEnd = snapshots[spells.trueshot.id].buff.isActive
						and specSettings.endOf.trueshot.enabled
						and (snapshots[spells.trueshot.id].buff:GetRemainingTime(currentTime) <=
							(specSettings.endOf.trueshot.mode == "gcd"
								and Character:GetCurrentGCDTime() * specSettings.endOf.trueshot.gcdsMax
								or specSettings.endOf.trueshot.timeMax)),
					borderOvercap = affectingCombat,
				}
				local focusBarColors = { bar = barColor, border = barBorderColor, background = barBackgroundColor }
				local barColorMap = { focusBar = focusBarColors }

				if nodeOrder and indicatorColors then
					for i = #nodeOrder, 1, -1 do
						local key = nodeOrder[i]
						local indicator = indicatorColors[key]
						if indicator and indicator.enabled and conditionMap[key] and indicator.targets then
							for barKey, elements in pairs(indicator.targets) do
								local targetColors = barColorMap[barKey]
								if targetColors and elements then
									for elemKey, isTargeted in pairs(elements) do
										if isTargeted then
											targetColors[elemKey] = (elemKey == "bar") and indicator or indicator.color
										end
									end
								end
							end
						end
					end
				end

				local overcapCurves = {}
				if gradientOrder and indicatorColors then
					for i = #gradientOrder, 1, -1 do
						local key = gradientOrder[i]
						local indicator = indicatorColors[key]
						if indicator and indicator.enabled and conditionMap[key] and indicator.isGradient and indicator.targets then
							local fbTargets = indicator.targets.focusBar
							if fbTargets then
								if fbTargets.border then
									overcapCurves.border = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.border, indicator.color)
								end
								if fbTargets.bar then
									overcapCurves.bar = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.bar, indicator.color)
								end
								if fbTargets.background then
									overcapCurves.background = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.background, indicator.color)
								end
							end
							break
						end
					end
				end

				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				if overcapCurves.border then
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.border)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(focusBarColors.border)
				end
				if overcapCurves.bar then
					local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.bar)
					primaryNode:SetColorCurve(barColorResult)
				else
					TRB.Functions.Color:ApplyFillColor(primaryNode, focusBarColors.bar)
				end
				if overcapCurves.background then
					local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.background)
					primaryNode:SetBackgroundColorCurve(backgroundColorResult)
				else
					primaryNode:SetBackgroundColorFromString(focusBarColors.background)
				end
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end
		end

		-- Update health bar
		if not specSettings.displayBar.health.neverShow then
			refreshText = true
			local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
			if healthNode then
				healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
				healthNode:SetValue(snapshotData.attributes.health or 0)
				healthNode:SetColorCurve(snapshotData.attributes.healthColor)
				healthNode:SetBorderColor(specCacheSettings.colors.healthBar.border.color)
				healthNode:SetBackgroundColorFromString(specCacheSettings.colors.healthBar.background.color)
			end
			Bar:UpdateHealthBarOverlays(healthNode, snapshotData, specCacheSettings)
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.survival
		local specCacheSettings = TRB.Data.specCache.hunter_survival.settings
		UpdateSnapshot_Survival()

		if snapshotData.attributes.isTracking then
			local affectingCombat = TRB.Data.character.inCombat
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors
			local nodeOrder = sharedColors and sharedColors.nodeOrder
			local gradientOrder = sharedColors and sharedColors.gradientOrder
			local conditionMap = {
				takedown = snapshots[spells.takedown.id].buff.isActive,
				takedownEnd = snapshots[spells.takedown.id].buff.isActive
					and specSettings.endOf.takedown.enabled
					and (snapshots[spells.takedown.id].buff:GetRemainingTime(currentTime) <=
						(specSettings.endOf.takedown.mode == "gcd"
							and Character:GetCurrentGCDTime() * specSettings.endOf.takedown.gcdsMax
							or specSettings.endOf.takedown.timeMax)),
				borderOvercap = affectingCombat,
			}
			local focusBarColors = {
				bar = specSettings.colors.bar.base,
				border = specSettings.colors.bar.border.color,
				background = specSettings.colors.bar.background.color,
			}
			local tipOfTheSpearBarColors = {
				bar = specSettings.colors.comboPoints.base,
				border = specSettings.colors.comboPoints.border.color,
				background = specSettings.colors.comboPoints.background.color,
			}
			local tipOfTheSpearOverrides = { bar = false, border = false, background = false }
			local barColorMap = {
				focusBar = focusBarColors,
				tipOfTheSpearBar = tipOfTheSpearBarColors,
			}

			if nodeOrder and indicatorColors then
				for i = #nodeOrder, 1, -1 do
					local key = nodeOrder[i]
					local indicator = indicatorColors[key]
					if indicator and indicator.enabled and conditionMap[key] and indicator.targets then
						for barKey, elements in pairs(indicator.targets) do
							local targetColors = barColorMap[barKey]
							if targetColors and elements then
								for elemKey, isTargeted in pairs(elements) do
									if isTargeted then
										targetColors[elemKey] = (elemKey == "bar") and indicator or indicator.color
										if barKey == "tipOfTheSpearBar" then
											tipOfTheSpearOverrides[elemKey] = true
										end
									end
								end
							end
						end
					end
				end
			end

			local overcapIndicator = nil
			if gradientOrder and indicatorColors then
				for i = #gradientOrder, 1, -1 do
					local key = gradientOrder[i]
					local indicator = indicatorColors[key]
					if indicator and indicator.enabled and conditionMap[key] and indicator.isGradient then
						overcapIndicator = indicator
						break
					end
				end
			end

			local focusOvercapCurves = {}
			local tipOfTheSpearOvercapCurves = {}
			if overcapIndicator and overcapIndicator.targets then
				local focusTargets = overcapIndicator.targets.focusBar
				if focusTargets then
					if focusTargets.border then
						focusOvercapCurves.border = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.border, overcapIndicator.color)
					end
					if focusTargets.bar then
						focusOvercapCurves.bar = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.bar, overcapIndicator.color)
					end
					if focusTargets.background then
						focusOvercapCurves.background = Color:BuildResourceThresholdCurve(specSettings, focusBarColors.background, overcapIndicator.color)
					end
				end

				local tipTargets = overcapIndicator.targets.tipOfTheSpearBar
				if tipTargets then
					if tipTargets.border then
						tipOfTheSpearOvercapCurves.border = Color:BuildResourceThresholdCurve(specSettings, tipOfTheSpearBarColors.border, overcapIndicator.color)
					end
					if tipTargets.bar then
						tipOfTheSpearOvercapCurves.bar = Color:BuildResourceThresholdCurve(specSettings, tipOfTheSpearBarColors.bar, overcapIndicator.color)
					end
					if tipTargets.background then
						tipOfTheSpearOvercapCurves.background = Color:BuildResourceThresholdCurve(specSettings, tipOfTheSpearBarColors.background, overcapIndicator.color)
					end
				end
			end

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local gcd = Character:GetCurrentGCDTime(true)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = focusBarColors.border
				
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetFrame()
				local thresholds = primaryNode:GetThresholds()
				
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
						Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.raptorStrike.id then
							if spells.raptorSwipe:IsUsable() then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.id == spells.raptorSwipe.id then
							if spells.raptorStrike:IsUsable() then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
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
							frameLevel = frameLevels.thresholdUnusable
						elseif isUsable or spell:IsFree() then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
					if thresholds[thresholdId] then
						local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
						Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
					-- Per-threshold audio cue (independent of line visibility)
					if spell.canHaveAudioCue == true and dictEntry and dictEntry.audio and dictEntry.audio.enabled and dictEntry.audio.sound then
						snapshotData.audio.thresholdCues = snapshotData.audio.thresholdCues or {}
						if isUsable then
							if not snapshotData.audio.thresholdCues[spell.settingKey] then
								snapshotData.audio.thresholdCues[spell.settingKey] = true
								PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						else
							snapshotData.audio.thresholdCues[spell.settingKey] = false
						end
					end
				end

				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				if focusOvercapCurves.border then
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, focusOvercapCurves.border)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(focusBarColors.border)
				end
				if focusOvercapCurves.bar then
					local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, focusOvercapCurves.bar)
					primaryNode:SetColorCurve(barColorResult)
				else
					TRB.Functions.Color:ApplyFillColor(primaryNode, focusBarColors.bar)
				end
				if focusOvercapCurves.background then
					local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, focusOvercapCurves.background)
					primaryNode:SetBackgroundColorCurve(backgroundColorResult)
				else
					primaryNode:SetBackgroundColorFromString(focusBarColors.background)
				end
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			-- Secondary resource bar: Tip of the Spear stacks
			local maxResource2 = TRB.Data.character.maxResource2 or 0
			if not specSettings.displayBar.secondary.neverShow and maxResource2 > 0 then
				refreshText = true
				if barGroups.secondary then
					local maxStacks = spells.tipOfTheSpear.maxStacks
					local currentStacks = snapshots[spells.tipOfTheSpear.id].buff.applications or 0

					-- Standard view: 3 nodes, one per stack
					for x = 1, maxStacks do
						local cpColor = tipOfTheSpearBarColors.bar
						local cpBorderColor = tipOfTheSpearBarColors.border
						local cpBackgroundColor = tipOfTheSpearBarColors.background
						local isFilled = currentStacks >= x

						local stackNode = barGroups.secondary:GetNode(x)
						if stackNode then
							if isFilled then
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, stackNode, 1, 1)

								-- Determine color based on position and sameColor setting
								if not tipOfTheSpearOverrides.bar and not tipOfTheSpearOvercapCurves.bar and specSettings.colors.comboPoints.sameColor then
									-- sameColor: all filled nodes share the highest applicable color
									if currentStacks == maxStacks then
										cpColor = specSettings.colors.comboPoints.final
									elseif currentStacks == maxStacks - 1 then
										cpColor = specSettings.colors.comboPoints.penultimate
									else
										cpColor = specSettings.colors.comboPoints.base
									end
								elseif not tipOfTheSpearOverrides.bar and not tipOfTheSpearOvercapCurves.bar then
									-- Per-node coloring
									if x == maxStacks then
										cpColor = specSettings.colors.comboPoints.final
									elseif x == maxStacks - 1 then
										cpColor = specSettings.colors.comboPoints.penultimate
									else
										cpColor = specSettings.colors.comboPoints.base
									end
								end
							else
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, stackNode, 0, 1)
							end

							if tipOfTheSpearOvercapCurves.border then
								local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, tipOfTheSpearOvercapCurves.border)
								stackNode:SetBorderColorCurve(borderColorResult)
							else
								stackNode:SetBorderColor(cpBorderColor)
							end

							if tipOfTheSpearOvercapCurves.bar then
								local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, tipOfTheSpearOvercapCurves.bar)
								stackNode:SetColorCurve(barColorResult)
							else
								TRB.Functions.Color:ApplyFillColor(stackNode, cpColor)
							end

							if tipOfTheSpearOvercapCurves.background then
								local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, tipOfTheSpearOvercapCurves.background)
								stackNode:SetBackgroundColorCurve(backgroundColorResult)
							else
								stackNode:SetBackgroundColorFromString(cpBackgroundColor)
							end
						end
					end
				end
			end
		end

		-- Tip of the Spear threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			do
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
				local coreSettings = TRB.Data.settings.core
				local currentResource2 = snapshots[spells.tipOfTheSpear.id].buff.applications or 0
				local threshold1 = specSettings.audio.totsThreshold1
				if threshold1 ~= nil then
					local threshold1Value = threshold1.configuration.thresholdValue

					local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.totsThreshold1Played and currentResource2 >= threshold1Value

					if threshold1ShouldFire then
						snapshotData.audio.totsThreshold1Played = true
						PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
					end

					if currentResource2 < threshold1Value then
						snapshotData.audio.totsThreshold1Played = false
					end
				end
			end
		end

		-- Update health bar
		if not specSettings.displayBar.health.neverShow then
			refreshText = true
			local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
			if healthNode then
				healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
				healthNode:SetValue(snapshotData.attributes.health or 0)
				healthNode:SetColorCurve(snapshotData.attributes.healthColor)
				healthNode:SetBorderColor(specCacheSettings.colors.healthBar.border.color)
				healthNode:SetBackgroundColorFromString(specCacheSettings.colors.healthBar.background.color)
			end
			Bar:UpdateHealthBarOverlays(healthNode, snapshotData, specCacheSettings)
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
		specCache.hunter_beastMastery.talents:GetTalents()
		FillSpellData_BeastMastery()
		Character:LoadFromSpecializationCache(specCache.hunter_beastMastery)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.BeastMasterySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_BeastMastery
		Bar:UpdateSanityCheckValues(specCache.hunter_beastMastery.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#beastCleave"] = spells.beastCleave.icon
		lookup["#bestialWrath"] = spells.bestialWrath.icon
		lookup["#cobraShot"] = spells.cobraShot.icon
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "hunter_beastMastery" then
			talents = specCache.hunter_beastMastery.talents
			TRB.Data.barConstructedForSpec = "hunter_beastMastery"
			ConstructResourceBar(specCache.hunter_beastMastery.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.hunter_marksmanship.talents:GetTalents()
		FillSpellData_Marksmanship()
		Character:LoadFromSpecializationCache(specCache.hunter_marksmanship)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.MarksmanshipSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Marksmanship
		Bar:UpdateSanityCheckValues(specCache.hunter_marksmanship.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#aimedShot"] = spells.aimedShot.icon
		lookup["#arcaneShot"] = spells.arcaneShot.icon
		lookup["#explosiveShot"] = spells.explosiveShot.icon
		lookup["#killShot"] = spells.killShot.icon
		lookup["#multiShot"] = spells.multiShot.icon
		lookup["#rapidFire"] = spells.rapidFire.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#steadyShot"] = spells.steadyShot.icon
		lookup["#trueshot"] = spells.trueshot.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "hunter_marksmanship" then
			talents = specCache.hunter_marksmanship.talents
			TRB.Data.barConstructedForSpec = "hunter_marksmanship"
			ConstructResourceBar(specCache.hunter_marksmanship.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.hunter_survival.talents:GetTalents()
		FillSpellData_Survival()
		Character:LoadFromSpecializationCache(specCache.hunter_survival)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Survival
		Bar:UpdateSanityCheckValues(specCache.hunter_survival.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#killCommand"] = spells.killCommand.icon
		lookup["#raptorStrike"] = spells.raptorStrike.icon
		lookup["#revivePet"] = spells.revivePet.icon
		lookup["#scareBeast"] = spells.scareBeast.icon
		lookup["#takedown"] = spells.takedown.icon
		lookup["#tipOfTheSpear"] = spells.tipOfTheSpear.icon
		lookup["#wingClip"] = spells.wingClip.icon
		lookup["#wildfireBomb"] = spells.wildfireBomb.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "hunter_survival" then
			talents = specCache.hunter_survival.talents
			TRB.Data.barConstructedForSpec = "hunter_survival"
			ConstructResourceBar(specCache.hunter_survival.settings)
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
	
	if TRB.Data.character.classId == 3 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Hunter.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.beastMastery == nil or
						TwintopInsanityBarSettings.hunter.beastMastery.displayText == nil then
						settings.hunter.beastMastery.displayText.barText = TRB.Options.Hunter.BeastMasteryLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.marksmanship == nil or
						TwintopInsanityBarSettings.hunter.marksmanship.displayText == nil then
						settings.hunter.marksmanship.displayText.barText = TRB.Options.Hunter.MarksmanshipLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.hunter == nil or
						TwintopInsanityBarSettings.hunter.survival == nil or
						TwintopInsanityBarSettings.hunter.survival.displayText == nil then
						settings.hunter.survival.displayText.barText = TRB.Options.Hunter.SurvivalLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.hunter ~= true then
						TRB.Data.settings.hunter.beastMastery.displayText.barText = TRB.Options.Hunter.BeastMasteryLoadDefaultBarTextSettings()
						TRB.Data.settings.hunter.marksmanship.displayText.barText = TRB.Options.Hunter.MarksmanshipLoadDefaultBarTextSettings()
						TRB.Data.settings.hunter.survival.displayText.barText = TRB.Options.Hunter.SurvivalLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.hunter = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Hunter"])
					end
				else
					local settings = TRB.Options.Hunter.LoadDefaultSettings(true)
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
						TRB.Data.settings.hunter.beastMastery = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["HunterBeastMasteryFull"], TRB.Data.settings.hunter.beastMastery)
						TRB.Data.settings.hunter.marksmanship = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["HunterMarksmanshipFull"], TRB.Data.settings.hunter.marksmanship)
						TRB.Data.settings.hunter.survival = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["HunterSurvivalFull"], TRB.Data.settings.hunter.survival)
						
						FillSpellData_BeastMastery()
						FillSpellData_Marksmanship()
						FillSpellData_Survival()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Hunter.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "hunter"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Focus, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Focus, false)

	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "beastMastery"
		TRB.Data.character.compositeKey = "hunter_beastMastery"
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "marksmanship"
		TRB.Data.character.compositeKey = "hunter_marksmanship"
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "survival"
		TRB.Data.character.compositeKey = "hunter_survival"

		-- Tip of the Spear: talent-gated secondary resource
		local maxComboPoints = GetSurvivalTipOfTheSpearMaxStacks()
		local barGroups = TRB.Frames.barGroups
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey] and TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		local maxComboPointsChanged = maxComboPoints ~= TRB.Data.character.maxResource2

		if maxComboPointsChanged then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.BarVisibility:MarkDirty()
		end

		if barGroups and barGroups.secondary and sharedSettings then
			barGroups.secondary.lastRebuildNodeCount = maxComboPoints
			if maxComboPoints > 0 then
				barGroups.secondary:SetMaxNodes(maxComboPoints)
				Bar:ApplySecondaryBarGroupLayout(sharedSettings, barGroups, maxComboPoints)
				barGroups.secondary:Show()
				barGroups.secondary:ShowNodes(maxComboPoints)
				if maxComboPointsChanged then
					Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
				end
			else
				barGroups.secondary:Hide()
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.hunter.beastMastery == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.hunter.marksmanship == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.hunter.survival == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Focus
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "SPELL"
		local spellsData = TRB.Data.spellsData
		if spellsData and spellsData.spells then
			local spells = spellsData.spells --[[@as TRB.Classes.Hunter.SurvivalSpells]]
			TRB.Data.resource2Id = spells.tipOfTheSpear.id
		end
		TRB.Data.resource2Factor = 1
	else
		TRB.Data.specSupported = false
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

		-- Only Survival (3) uses the secondary (Tip of the Spear) bar, and only if talented
		local hasSecondary = TRB.Data.character.specId == 3 and (TRB.Data.character.maxResource2 or 0) > 0

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, hasSecondary, TRB.Data.character.maxResource2, nil),
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

local specValidVars
do
	local castingFn = function()
		local c = TRB.Data.snapshotData.casting
		return c.resourceRaw ~= nil and c.resourceRaw ~= 0
	end
	local common = {
		["$resource"] = false, ["$focus"] = false,
		["$resourceMax"] = true, ["$focusMax"] = true,
		["$casting"] = castingFn,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
	}
	-- Beast Mastery
	local bm = {}
	for k, v in pairs(common) do bm[k] = v end
	bm["$beastCleaveTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.beastCleave.id].buff.isActive
	end
	bm["$bestialWrathTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.bestialWrath.id].buff.isActive
	end
	-- Marksmanship
	local mm = {}
	for k, v in pairs(common) do mm[k] = v end
	mm["$trueshotTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.trueshot.id].buff.isActive
	end
	-- Survival
	local sv = {}
	for k, v in pairs(common) do sv[k] = v end
	sv["$takedownTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.takedown.id].buff.isActive
	end
	sv["$totsTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.tipOfTheSpear.id].buff.isActive
	end
	sv["$tipOfTheSpear"] = true
	sv["$comboPoints"] = true
	sv["$tipOfTheSpearMax"] = true
	sv["$comboPointsMax"] = true

	specValidVars = { [1] = bm, [2] = mm, [3] = sv }
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
	elseif normalizedRelativeFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	local comboPointIndex = string.match(normalizedRelativeFrame, "^ComboPoint(%d+)$")
	if comboPointIndex ~= nil then
		local index = tonumber(comboPointIndex)
		if index ~= nil and barGroups and barGroups.secondary then
			local secondaryNode = barGroups.secondary:GetNode(index)
			if secondaryNode then
				local isVisible = barGroups.secondary.isVisible and secondaryNode.isVisible
				return secondaryNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

---Returns true when any spec-specific buff timer is actively counting down.
---BM: Beast Cleave, Bestial Wrath; MM: Trueshot; SV: Takedown, Tip of the Spear.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local snapshotData = TRB.Data.snapshotData
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
	if not snapshotData or not spells then return false end
	local snapshots = snapshotData.snapshots
	local specId = TRB.Data.character.specId
	if specId == 1 then -- Beast Mastery
		if (spells.beastCleave and snapshots[spells.beastCleave.id] and snapshots[spells.beastCleave.id].buff and snapshots[spells.beastCleave.id].buff.isActive)
			or (spells.bestialWrath and snapshots[spells.bestialWrath.id] and snapshots[spells.bestialWrath.id].buff and snapshots[spells.bestialWrath.id].buff.isActive) then
			return true
		end
	elseif specId == 2 then -- Marksmanship
		if spells.trueshot and snapshots[spells.trueshot.id] and snapshots[spells.trueshot.id].buff and snapshots[spells.trueshot.id].buff.isActive then
			return true
		end
	elseif specId == 3 then -- Survival
		if (spells.takedown and snapshots[spells.takedown.id] and snapshots[spells.takedown.id].buff and snapshots[spells.takedown.id].buff.isActive)
			or (spells.tipOfTheSpear and snapshots[spells.tipOfTheSpear.id] and snapshots[spells.tipOfTheSpear.id].buff and snapshots[spells.tipOfTheSpear.id].buff.isActive) then
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
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end
