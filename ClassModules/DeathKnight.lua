local _, TRB = ...
if TRB.Data.character.classId ~= 6 then --Only do this if we're on an Death Knight!
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
	deathknight_blood = TRB.Classes.SpecCache:New(),
	deathknight_frost = TRB.Classes.SpecCache:New(),
	deathknight_unholy = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function CalculateRunicPowerGain(runicPower)
	local modifier = 1.0
	return runicPower * modifier
end

local function CreateRune()
	local rune = {
		startTime = 0,
		duration = 0,
		ready = false,
		remaining = 0,
		percentage = 1
	}
	return rune
end

local function UpdateRune(runeIndex, refresh)
	local rune = TRB.Data.character.runes[runeIndex]

	if refresh == true then
		local startTime, duration, ready = GetRuneCooldown(runeIndex)
		
		-- Sometimes these values come back as secrets when they shouldn't be -- bail out and try again next frame to prevent Lua errors
		if issecretvalue(startTime) or issecretvalue(duration) or issecretvalue(ready) then
			return
		end

		rune.startTime = startTime or 0
		rune.duration = duration or 0
		rune.ready = ready or rune.startTime == 0

		if rune.ready then
			rune.remaining = 0
			rune.percentage = 1
		else
			local currentTime = GetTime()
			rune.remaining = (rune.startTime + rune.duration) - currentTime
			rune.percentage = 1 - (rune.remaining / rune.duration)
		end
	else
		if not rune.ready then
			local currentTime = GetTime()
			rune.remaining = (rune.startTime + rune.duration) - currentTime
			if rune.remaining <= 0 then
				rune.remaining = 0
				rune.ready = true
				rune.percentage = 1
			else
				rune.percentage = 1 - (rune.remaining / rune.duration)
			end
		end
	end
end

local function FillSpecializationCache()
	-- Blood
	specCache.deathknight_blood.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.deathknight_blood.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		runes = {
			[1] = CreateRune(),
			[2] = CreateRune(),
			[3] = CreateRune(),
			[4] = CreateRune(),
			[5] = CreateRune(),
			[6] = CreateRune(),
		}
	}
	
	---@type TRB.Classes.DeathKnight.BloodSpells
	specCache.deathknight_blood.spellsData.spells = TRB.Classes.DeathKnight.BloodSpells:New()
	local spells = specCache.deathknight_blood.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	
	specCache.deathknight_blood.snapshotData.audio = {
	}

	specCache.deathknight_blood.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Frost
	specCache.deathknight_frost.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		}
	}

	specCache.deathknight_frost.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		runes = {
			[1] = CreateRune(),
			[2] = CreateRune(),
			[3] = CreateRune(),
			[4] = CreateRune(),
			[5] = CreateRune(),
			[6] = CreateRune(),
		}
	}
	
	---@type TRB.Classes.DeathKnight.FrostSpells
	specCache.deathknight_frost.spellsData.spells = TRB.Classes.DeathKnight.FrostSpells:New()
	local spells = specCache.deathknight_frost.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
	---@type TRB.Classes.Snapshot
	specCache.deathknight_frost.snapshotData.snapshots[spells.breathOfSindragosa.id] = TRB.Classes.Snapshot:New(spells.breathOfSindragosa)

	specCache.deathknight_frost.snapshotData.audio = {
	}

	specCache.deathknight_frost.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Unholy
	specCache.deathknight_unholy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.deathknight_unholy.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		runes = {
			[1] = CreateRune(),
			[2] = CreateRune(),
			[3] = CreateRune(),
			[4] = CreateRune(),
			[5] = CreateRune(),
			[6] = CreateRune(),
		}
	}
	
	---@type TRB.Classes.DeathKnight.UnholySpells
	specCache.deathknight_unholy.spellsData.spells = TRB.Classes.DeathKnight.UnholySpells:New()

	specCache.deathknight_unholy.snapshotData.audio = {
	}

	specCache.deathknight_unholy.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Blood()
	TRB.Functions.Character:FillSpecializationCacheSettings("deathknight", "blood", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	-- (guards against redundant delayed SwitchSpec calls that would orphan initialized bars)
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "deathknight_blood" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Blood()
	Setup_Blood()
	specCache.deathknight_blood.spellsData:FillSpellData()
	local spells = specCache.deathknight_blood.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]

	TRB.Classes.DeathKnight.BloodSpells.FillBarTextVariables(specCache.deathknight_blood)
end

local function Setup_Frost()
	TRB.Functions.Character:FillSpecializationCacheSettings("deathknight", "frost")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "deathknight_frost" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Frost()
	Setup_Frost()
	specCache.deathknight_frost.spellsData:FillSpellData()
	local spells = specCache.deathknight_frost.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]

	TRB.Classes.DeathKnight.FrostSpells.FillBarTextVariables(specCache.deathknight_frost)
end

local function Setup_Unholy()
	TRB.Functions.Character:FillSpecializationCacheSettings("deathknight", "unholy")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "deathknight_unholy" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Unholy()
	Setup_Unholy()
	specCache.deathknight_unholy.spellsData:FillSpellData()
	local spells = specCache.deathknight_unholy.spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]

	TRB.Classes.DeathKnight.UnholySpells.FillBarTextVariables(specCache.deathknight_unholy)
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
	
	if TRB.Data.character.specId == 1 then -- Blood
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Frost
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Unholy
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

	-- Construct thresholds on the BarNode (new system)
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

	-- Death Knight always uses the secondary bar for runes (always 6)
	-- Set up structure, but let HideResourceBar() determine visibility
	if barGroups and barGroups.secondary then
		local maxRunes = TRB.Data.character.maxResource2 or 6
		barGroups.secondary:SetNodeCount(maxRunes)
		for x = 1, maxRunes do
			local runeNode = barGroups.secondary:GetNode(x)
			if runeNode then
				runeNode:SetMinMax(0, 1)
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Blood()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.deathknight.blood
	local sharedSettings = TRB.Data.specCache["deathknight_blood"].settings
	local currentTime = GetTime()
	local normalizedRunicPower = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentRunicPowerColor = TRB.Data.settings.deathknight.blood.colors.text.current.color
	local castingRunicPowerColor = TRB.Data.settings.deathknight.blood.colors.text.casting.color

	-- Apply overcap color if enabled
	local currentRunicPower
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, currentRunicPowerColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentRunicPower = textColorResult:WrapTextInColorCode(TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))
	else
		currentRunicPower = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))
	end

	--$runicPowerMax
	local runicPowerPrecision = TRB.Data.settings.deathknight.frost.runicPowerPrecision or 1
	
	--$runicPowerMax
	local runicPowerMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, runicPowerPrecision, "floor", true))
	
	local runes = TRB.Data.character.runes
	--$runeXTime
	local _rune1Time = runes[1].remaining
	local rune1Time = TRB.Functions.BarText:TimerPrecision(_rune1Time)
	local _rune2Time = runes[2].remaining
	local rune2Time = TRB.Functions.BarText:TimerPrecision(_rune2Time)
	local _rune3Time = runes[3].remaining
	local rune3Time = TRB.Functions.BarText:TimerPrecision(_rune3Time)
	local _rune4Time = runes[4].remaining
	local rune4Time = TRB.Functions.BarText:TimerPrecision(_rune4Time)
	local _rune5Time = runes[5].remaining
	local rune5Time = TRB.Functions.BarText:TimerPrecision(_rune5Time)
	local _rune6Time = runes[6].remaining
	local rune6Time = TRB.Functions.BarText:TimerPrecision(_rune6Time)

	--$runeXReady
	local _rune1Ready = runes[1].ready
	local _rune2Ready = runes[2].ready
	local _rune3Ready = runes[3].ready
	local _rune4Ready = runes[4].ready
	local _rune5Ready = runes[5].ready
	local _rune6Ready = runes[6].ready
	local _runesReadyCount = (_rune1Ready and 1 or 0) + (_rune2Ready and 1 or 0) + (_rune3Ready and 1 or 0) + (_rune4Ready and 1 or 0) + (_rune5Ready and 1 or 0) + (_rune6Ready and 1 or 0)
	local runesReadyCount = tostring(_runesReadyCount)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$runicPower"] = currentRunicPower
	lookup["$resource"] = currentRunicPower
	lookup["$runicPowerMax"] = runicPowerMax
	lookup["$resourceMax"] = runicPowerMax
	lookup["$rune1Time"] = rune1Time
	lookup["$rune2Time"] = rune2Time
	lookup["$rune3Time"] = rune3Time
	lookup["$rune4Time"] = rune4Time
	lookup["$rune5Time"] = rune5Time
	lookup["$rune6Time"] = rune6Time
	lookup["$rune1Ready"] = ""
	lookup["$rune2Ready"] = ""
	lookup["$rune3Ready"] = ""
	lookup["$rune4Ready"] = ""
	lookup["$rune5Ready"] = ""
	lookup["$rune6Ready"] = ""
	lookup["$runesReadyCount"] = runesReadyCount
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$runicPower"] = normalizedRunicPower
	lookupLogic["$resource"] = normalizedRunicPower
	lookupLogic["$rune1Time"] = _rune1Time
	lookupLogic["$rune2Time"] = _rune2Time
	lookupLogic["$rune3Time"] = _rune3Time
	lookupLogic["$rune4Time"] = _rune4Time
	lookupLogic["$rune5Time"] = _rune5Time
	lookupLogic["$rune6Time"] = _rune6Time
	lookupLogic["$rune1Ready"] = _rune1Ready
	lookupLogic["$rune2Ready"] = _rune2Ready
	lookupLogic["$rune3Ready"] = _rune3Ready
	lookupLogic["$rune4Ready"] = _rune4Ready
	lookupLogic["$rune5Ready"] = _rune5Ready
	lookupLogic["$rune6Ready"] = _rune6Ready
	lookupLogic["$runesReadyCount"] = _runesReadyCount
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Frost()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.deathknight.frost
	local sharedSettings = TRB.Data.specCache["deathknight_frost"].settings
	local currentTime = GetTime()
	local normalizedRunicPower = snapshotData.attributes.resourceModified

	local currentRunicPowerColor = TRB.Data.settings.deathknight.frost.colors.text.current.color
	local castingRunicPowerColor = TRB.Data.settings.deathknight.frost.colors.text.casting.color

	-- Apply overcap color if enabled
	local currentRunicPower
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, currentRunicPowerColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentRunicPower = textColorResult:WrapTextInColorCode(TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))
	else
		currentRunicPower = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))
	end

	--$runicPowerMax
	local runicPowerPrecision = TRB.Data.settings.deathknight.frost.runicPowerPrecision or 1
	
	--$runicPowerMax
	local runicPowerMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, runicPowerPrecision, "floor", true))
	
	local runes = TRB.Data.character.runes
	--$runeXTime
	local _rune1Time = runes[1].remaining
	local rune1Time = TRB.Functions.BarText:TimerPrecision(_rune1Time)
	local _rune2Time = runes[2].remaining
	local rune2Time = TRB.Functions.BarText:TimerPrecision(_rune2Time)
	local _rune3Time = runes[3].remaining
	local rune3Time = TRB.Functions.BarText:TimerPrecision(_rune3Time)
	local _rune4Time = runes[4].remaining
	local rune4Time = TRB.Functions.BarText:TimerPrecision(_rune4Time)
	local _rune5Time = runes[5].remaining
	local rune5Time = TRB.Functions.BarText:TimerPrecision(_rune5Time)
	local _rune6Time = runes[6].remaining
	local rune6Time = TRB.Functions.BarText:TimerPrecision(_rune6Time)

	--$runeXReady
	local _rune1Ready = runes[1].ready
	local _rune2Ready = runes[2].ready
	local _rune3Ready = runes[3].ready
	local _rune4Ready = runes[4].ready
	local _rune5Ready = runes[5].ready
	local _rune6Ready = runes[6].ready
	local _runesReadyCount = (_rune1Ready and 1 or 0) + (_rune2Ready and 1 or 0) + (_rune3Ready and 1 or 0) + (_rune4Ready and 1 or 0) + (_rune5Ready and 1 or 0) + (_rune6Ready and 1 or 0)
	local runesReadyCount = tostring(_runesReadyCount)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$runicPower"] = currentRunicPower
	lookup["$resource"] = currentRunicPower
	lookup["$runicPowerMax"] = runicPowerMax
	lookup["$resourceMax"] = runicPowerMax
	lookup["$rune1Time"] = rune1Time
	lookup["$rune2Time"] = rune2Time
	lookup["$rune3Time"] = rune3Time
	lookup["$rune4Time"] = rune4Time
	lookup["$rune5Time"] = rune5Time
	lookup["$rune6Time"] = rune6Time
	lookup["$rune1Ready"] = ""
	lookup["$rune2Ready"] = ""
	lookup["$rune3Ready"] = ""
	lookup["$rune4Ready"] = ""
	lookup["$rune5Ready"] = ""
	lookup["$rune6Ready"] = ""
	lookup["$runesReadyCount"] = runesReadyCount
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$runicPower"] = normalizedRunicPower
	lookupLogic["$resource"] = normalizedRunicPower
	lookupLogic["$rune1Time"] = _rune1Time
	lookupLogic["$rune2Time"] = _rune2Time
	lookupLogic["$rune3Time"] = _rune3Time
	lookupLogic["$rune4Time"] = _rune4Time
	lookupLogic["$rune5Time"] = _rune5Time
	lookupLogic["$rune6Time"] = _rune6Time
	lookupLogic["$rune1Ready"] = _rune1Ready
	lookupLogic["$rune2Ready"] = _rune2Ready
	lookupLogic["$rune3Ready"] = _rune3Ready
	lookupLogic["$rune4Ready"] = _rune4Ready
	lookupLogic["$rune5Ready"] = _rune5Ready
	lookupLogic["$rune6Ready"] = _rune6Ready
	lookupLogic["$runesReadyCount"] = _runesReadyCount
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Unholy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.deathknight.unholy
	local sharedSettings = TRB.Data.specCache["deathknight_unholy"].settings
	local currentTime = GetTime()
	local normalizedRunicPower = snapshotData.attributes.resourceModified

	local currentRunicPowerColor = TRB.Data.settings.deathknight.unholy.colors.text.current.color
	local castingRunicPowerColor = TRB.Data.settings.deathknight.unholy.colors.text.casting.color

	-- Apply overcap color if enabled
	local currentRunicPower
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, currentRunicPowerColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentRunicPower = textColorResult:WrapTextInColorCode(TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))
	else
		currentRunicPower = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedRunicPower))
	end

	--$runicPowerMax
	local runicPowerPrecision = TRB.Data.settings.deathknight.frost.runicPowerPrecision or 1
	
	--$runicPowerMax
	local runicPowerMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, runicPowerPrecision, "floor", true))
	
	local runes = TRB.Data.character.runes
	--$runeXTime
	local _rune1Time = runes[1].remaining
	local rune1Time = TRB.Functions.BarText:TimerPrecision(_rune1Time)
	local _rune2Time = runes[2].remaining
	local rune2Time = TRB.Functions.BarText:TimerPrecision(_rune2Time)
	local _rune3Time = runes[3].remaining
	local rune3Time = TRB.Functions.BarText:TimerPrecision(_rune3Time)
	local _rune4Time = runes[4].remaining
	local rune4Time = TRB.Functions.BarText:TimerPrecision(_rune4Time)
	local _rune5Time = runes[5].remaining
	local rune5Time = TRB.Functions.BarText:TimerPrecision(_rune5Time)
	local _rune6Time = runes[6].remaining
	local rune6Time = TRB.Functions.BarText:TimerPrecision(_rune6Time)

	--$runeXReady
	local _rune1Ready = runes[1].ready
	local _rune2Ready = runes[2].ready
	local _rune3Ready = runes[3].ready
	local _rune4Ready = runes[4].ready
	local _rune5Ready = runes[5].ready
	local _rune6Ready = runes[6].ready
	local _runesReadyCount = (_rune1Ready and 1 or 0) + (_rune2Ready and 1 or 0) + (_rune3Ready and 1 or 0) + (_rune4Ready and 1 or 0) + (_rune5Ready and 1 or 0) + (_rune6Ready and 1 or 0)
	local runesReadyCount = tostring(_runesReadyCount)

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$runicPower"] = currentRunicPower
	lookup["$resource"] = currentRunicPower
	lookup["$runicPowerMax"] = runicPowerMax
	lookup["$resourceMax"] = runicPowerMax
	lookup["$rune1Time"] = rune1Time
	lookup["$rune2Time"] = rune2Time
	lookup["$rune3Time"] = rune3Time
	lookup["$rune4Time"] = rune4Time
	lookup["$rune5Time"] = rune5Time
	lookup["$rune6Time"] = rune6Time
	lookup["$rune1Ready"] = ""
	lookup["$rune2Ready"] = ""
	lookup["$rune3Ready"] = ""
	lookup["$rune4Ready"] = ""
	lookup["$rune5Ready"] = ""
	lookup["$rune6Ready"] = ""
	lookup["$runesReadyCount"] = runesReadyCount
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$runicPower"] = normalizedRunicPower
	lookupLogic["$resource"] = normalizedRunicPower
	lookupLogic["$rune1Time"] = _rune1Time
	lookupLogic["$rune2Time"] = _rune2Time
	lookupLogic["$rune3Time"] = _rune3Time
	lookupLogic["$rune4Time"] = _rune4Time
	lookupLogic["$rune5Time"] = _rune5Time
	lookupLogic["$rune6Time"] = _rune6Time
	lookupLogic["$rune1Ready"] = _rune1Ready
	lookupLogic["$rune2Ready"] = _rune2Ready
	lookupLogic["$rune3Ready"] = _rune3Ready
	lookupLogic["$rune4Ready"] = _rune4Ready
	lookupLogic["$rune5Ready"] = _rune5Ready
	lookupLogic["$rune6Ready"] = _rune6Ready
	lookupLogic["$runesReadyCount"] = _runesReadyCount
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting(spell)
	local currentTime = GetTime()
	TRB.Data.snapshotData.casting.startTime = currentTime
	TRB.Data.snapshotData.casting.resourceRaw = spell.runicPower
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(spell.runicPower)
	TRB.Data.snapshotData.casting.spellId = spell.id
	TRB.Data.snapshotData.casting.icon = spell.icon
end

local function UpdateCastingResourceFinal()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshotData.casting.resourceRaw)
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Blood()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
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
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.breathOfSindragosa.castId then
				snapshotData.snapshots[spells.breathOfSindragosa.id].cooldown:InitializeCustom(spells.breathOfSindragosa.cooldown, currentTime)
			end
		elseif event == "SPELL_UPDATE_ICON" then

		end
	elseif TRB.Data.character.specId == 3 then
	end	
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	--local currentTime = GetTime()

	for x = 1, TRB.Data.character.maxResource2 do
		UpdateRune(x, true)
	end
	
	local specSettings = TRB.Data.settings.deathknight[TRB.Data.character.specName]
	local runes = TRB.Data.character.runes
	if specSettings.colors.comboPoints.sortRunes == true then
		-- Sort: ready runes first, then by percentage (high to low)
		table.sort(runes, function(a, b)
			if a.ready ~= b.ready then
				return a.ready -- true comes before false
			end
			return a.percentage > b.percentage
		end)
	end
end

local function UpdateSnapshot_Blood()
	UpdateSnapshot()
end

local function UpdateSnapshot_Frost()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()

	snapshotData.snapshots[spells.breathOfSindragosa.id].cooldown:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Unholy()
	UpdateSnapshot()
end

---Updates the rune display
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateRunes(specSettings, specCacheSettings)
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)

	local runes = TRB.Data.character.runes
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Count runes on cooldown for overcap detection
	local runesOnCooldown = 0
	for i = 1, TRB.Data.character.maxResource2 do
		if not runes[i].ready then
			runesOnCooldown = runesOnCooldown + 1
		end
	end

	-- Check if we should show overcap warning (fewer than 3 runes on cooldown while in combat)
	local overcapSettings = specSettings.colors.comboPoints.overcap
	local showOvercap = overcapSettings and overcapSettings.enabled and TRB.Data.character.inCombat and runesOnCooldown < 3
	
	for x = 1, TRB.Data.character.maxResource2 do
		local rune = runes[x]
		local cpBorderColor = specSettings.colors.comboPoints.border.color
		local cpColor = specSettings.colors.comboPoints.base.color
		local cpBR = cpBackgroundRed
		local cpBG = cpBackgroundGreen
		local cpBB = cpBackgroundBlue

		if not rune.ready then
			cpColor = specSettings.colors.comboPoints.cooldown.color
		elseif showOvercap then
			-- Rune is ready and we're overcapping - use overcap color
			cpColor = overcapSettings.color
		end
		

		if barGroups and barGroups.secondary then
			local runeNode = barGroups.secondary:GetNode(x)
			if runeNode then
				TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "rune" .. x, runeNode, rune.percentage, 1)
				runeNode:SetBorderColor(cpBorderColor)
				runeNode:SetColor(cpColor)
				runeNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
			end
		end
	end
end

local function UpdateResourceBar()
	local refreshText = false
	local classSettings = TRB.Data.settings.deathknight
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

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	local primaryResourceFrame = primaryNode:GetFrame()

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.blood
		local specCacheSettings = TRB.Data.specCache.deathknight_blood.settings
		UpdateSnapshot_Blood()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resource
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				-- Apply overcap border color if enabled
				if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					local thresholds = primaryNode:GetThresholds()
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, primaryResourceFrame)
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

					if spell.isSnowflake then
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then
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
					else
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

					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if specSettings.displayBar.secondary.visibility ~= "never" then
				refreshText = true
				UpdateRunes(specSettings, specCacheSettings)
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
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.frost
		local specCacheSettings = TRB.Data.specCache.deathknight_frost.settings
		UpdateSnapshot_Frost()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resource
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				-- Apply overcap border color if enabled
				if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					local thresholds = primaryNode:GetThresholds()
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, primaryResourceFrame)
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

					if spell.isSnowflake then
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then
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
					else
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

					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if specSettings.displayBar.secondary.visibility ~= "never" then
				refreshText = true
				UpdateRunes(specSettings, specCacheSettings)
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
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.unholy
		local specCacheSettings = TRB.Data.specCache.deathknight_unholy.settings
		UpdateSnapshot_Unholy()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resource
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				-- Apply overcap border color if enabled
				if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = TRB.Functions.Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult)
				else
					primaryNode:SetBorderColor(barBorderColor)
				end

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					local thresholds = primaryNode:GetThresholds()
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, primaryResourceFrame)
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

					if spell.isSnowflake then
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then
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
					else
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

					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if specSettings.displayBar.secondary.visibility ~= "never" then
				refreshText = true
				UpdateRunes(specSettings, specCacheSettings)
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
	if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
		TRB.Functions.Bar:QueueRenderTransition("switchSpec", 0.8)
	elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
		TRB.Functions.Bar:HideResourceBar(true)
	end
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	
	if TRB.Data.character.specId == 1 then
		specCache.deathknight_blood.talents:GetTalents()
		FillSpellData_Blood()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.deathknight_blood)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Blood
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.deathknight_blood.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "deathknight_blood" then
			talents = specCache.deathknight_blood.talents
			TRB.Data.barConstructedForSpec = "deathknight_blood"
			ConstructResourceBar(specCache.deathknight_blood.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.deathknight_frost.talents:GetTalents()
		FillSpellData_Frost()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.deathknight_frost)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Frost
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.deathknight_frost.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "deathknight_frost" then
			talents = specCache.deathknight_frost.talents
			TRB.Data.barConstructedForSpec = "deathknight_frost"
			ConstructResourceBar(specCache.deathknight_frost.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.deathknight_unholy.talents:GetTalents()
		FillSpellData_Unholy()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.deathknight_unholy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Unholy
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.deathknight_unholy.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "deathknight_unholy" then
			talents = specCache.deathknight_unholy.talents
			TRB.Data.barConstructedForSpec = "deathknight_unholy"
			ConstructResourceBar(specCache.deathknight_unholy.settings)
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
	
	if TRB.Data.character.classId == 6 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.DeathKnight.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.deathknight == nil or
						TwintopInsanityBarSettings.deathknight.blood == nil or
						TwintopInsanityBarSettings.deathknight.blood.displayText == nil then
						settings.deathknight.blood.displayText.barText = TRB.Options.DeathKnight.BloodLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.deathknight == nil or
						TwintopInsanityBarSettings.deathknight.frost == nil or
						TwintopInsanityBarSettings.deathknight.frost.displayText == nil then
						settings.deathknight.frost.displayText.barText = TRB.Options.DeathKnight.FrostLoadDefaultBarTextSettings()
					end 

					if TwintopInsanityBarSettings.deathknight == nil or
						TwintopInsanityBarSettings.deathknight.unholy == nil or
						TwintopInsanityBarSettings.deathknight.unholy.displayText == nil then
						settings.deathknight.unholy.displayText.barText = TRB.Options.DeathKnight.UnholyLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.deathknight ~= true then
						TRB.Data.settings.deathknight.blood.displayText.barText = TRB.Options.DeathKnight.BloodLoadDefaultBarTextSettings()
						TRB.Data.settings.deathknight.frost.displayText.barText = TRB.Options.DeathKnight.FrostLoadDefaultBarTextSettings()
						TRB.Data.settings.deathknight.unholy.displayText.barText = TRB.Options.DeathKnight.UnholyLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.deathknight = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["DeathKnight"])
					end
				else
					local settings = TRB.Options.DeathKnight.LoadDefaultSettings(true)
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
						TRB.Data.settings.deathknight.blood = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DeathKnightBloodFull"], TRB.Data.settings.deathknight.blood)
						TRB.Data.settings.deathknight.frost = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DeathKnightFrostFull"], TRB.Data.settings.deathknight.frost)
						TRB.Data.settings.deathknight.unholy = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DeathKnightUnholyFull"], TRB.Data.settings.deathknight.unholy)
						
						FillSpellData_Blood()
						FillSpellData_Frost()
						FillSpellData_Unholy()
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.DeathKnight.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "deathknight"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.RunicPower, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.RunicPower, false)
	TRB.Data.character.maxResource2 = 6 -- Death Knights always have 6 runes
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "blood"
		TRB.Data.character.compositeKey = "deathknight_blood"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "frost"
		TRB.Data.character.compositeKey = "deathknight_frost"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "unholy"
		TRB.Data.character.compositeKey = "deathknight_unholy"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	end

	if sharedSettings ~= nil then
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		if barGroups and barGroups.secondary then
			barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.deathknight.blood then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.RunicPower
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = Enum.PowerType.Runes
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.deathknight.frost then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.RunicPower
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = Enum.PowerType.Runes
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.deathknight.unholy then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.RunicPower
		TRB.Data.resourceFactor = 10
		TRB.Data.resource2 = Enum.PowerType.Runes
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
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
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.secondary then
				barGroups.secondary:Hide()
			end
			if barGroups and barGroups.health then
				barGroups.health:Hide()
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.deathknight.blood
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.deathknight.frost
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.deathknight.unholy
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Blood
		-- No spec-specific variables for Blood currently
	elseif TRB.Data.character.specId == 2 then --Frost
		-- No spec-specific variables for Frost currently
	elseif TRB.Data.character.specId == 3 then --Unholy
		-- No spec-specific variables for Unholy currently
	end

	--Spec agnostic
	if var == "$resource" or var == "$runicPower" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$runicPowerMax" then
		valid = true
	elseif var == "$rune1Time" then
		if TRB.Data.character.runes[1].remaining > 0 then
			valid = true
		end
	elseif var == "$rune2Time" then
		if TRB.Data.character.runes[2].remaining > 0 then
			valid = true
		end
	elseif var == "$rune3Time" then
		if TRB.Data.character.runes[3].remaining > 0 then
			valid = true
		end
	elseif var == "$rune4Time" then
		if TRB.Data.character.runes[4].remaining > 0 then
			valid = true
		end
	elseif var == "$rune5Time" then
		if TRB.Data.character.runes[5].remaining > 0 then
			valid = true
		end
	elseif var == "$rune6Time" then
		if TRB.Data.character.runes[6].remaining > 0 then
			valid = true
		end
	elseif var == "$rune1Ready" then
		if TRB.Data.character.runes[1].ready then
			valid = true
		end
	elseif var == "$rune2Ready" then
		if TRB.Data.character.runes[2].ready then
			valid = true
		end
	elseif var == "$rune3Ready" then
		if TRB.Data.character.runes[3].ready then
			valid = true
		end
	elseif var == "$rune4Ready" then
		if TRB.Data.character.runes[4].ready then
			valid = true
		end
	elseif var == "$rune5Ready" then
		if TRB.Data.character.runes[5].ready then
			valid = true
		end
	elseif var == "$rune6Ready" then
		if TRB.Data.character.runes[6].ready then
			valid = true
		end
	elseif var == "$runesReadyCount" then
		for x = 1, TRB.Data.character.maxResource2 do
			if TRB.Data.character.runes[x].ready then
				valid = true
				break
			end
		end
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
				local runeNode = barGroups.secondary:GetNode(index)
				if runeNode then
					local isVisible = barGroups.secondary.isVisible and runeNode.isVisible
					return runeNode:GetFrame(), true, isVisible
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