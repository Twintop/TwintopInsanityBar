local _, TRB = ...
if TRB.Data.character.classId ~= 6 then --Only do this if we're on an Death Knight!
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
local spellEventFrame = CreateFrame("Frame")

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

spellEventFrame:SetScript("OnEvent", function(self, event, spellId)
	if event == "SPELL_UPDATE_USES" and TRB.Data.character.specId == 1 then
		local spellsData = TRB.Data.spellsData
		if spellsData and spellsData.spells then
			local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
			if spells.marrowrend and spellId == spells.marrowrend.id then
				local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
				snapshotData.attributes.boneShieldStacks = C_Spell.GetSpellCastCount(spells.marrowrend.id) or 0
			end
		end
	end
end)

local function Setup_Blood()
	Character:FillSpecializationCacheSettings("deathknight", "blood", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	-- (guards against redundant delayed SwitchSpec calls that would orphan initialized bars)
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "deathknight_blood" then
		Bar:DestroyBarGroups()
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
	Character:FillSpecializationCacheSettings("deathknight", "frost")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "deathknight_frost" then
		Bar:DestroyBarGroups()
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
	Character:FillSpecializationCacheSettings("deathknight", "unholy")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "deathknight_unholy" then
		Bar:DestroyBarGroups()
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
				Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		Bar:ConstructBarGroups(settings, barGroups)
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

	-- Bone Shield bar (Blood only) - uses stepped min/max via BarTypeRegistry
	if barGroups and barGroups.boneShield and TRB.Data.character.specId == 1 then
		local maxBoneShield = TRB.Data.character.maxBoneShield or 10
		barGroups.boneShield:SetNodeCount(maxBoneShield)
	end

	-- Coagulating Blood bar (Blood only). Fixed stack scale, so set once here rather than per frame;
	-- the "percentage" min/max mode leaves it to us and never overwrites it.
	if barGroups and barGroups.coagulatingBlood and TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
		local coagulatingBloodNode = barGroups.coagulatingBlood:GetNode(1)
		if coagulatingBloodNode then
			coagulatingBloodNode:SetMinMax(0, spells.coagulatingBlood.maxStacks)
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Blood()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.deathknight.blood
	local sharedSettings = TRB.Data.specCache["deathknight_blood"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core runic power ($runicPower, $resource, $runicPowerMax, $resourceMax)
	if not activeVars or activeVars["$runicPower"] or activeVars["$resource"]
		or activeVars["$runicPowerMax"] or activeVars["$resourceMax"] then
		local normalizedRunicPower = snapshotData.attributes.resourceModified
		local currentRunicPowerColor = TRB.Data.settings.deathknight.blood.colors.text.current.color

		lookupLogic["$runicPower"] = normalizedRunicPower
		lookupLogic["$resource"] = normalizedRunicPower
		lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource

		local resourceAbbrevFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$runicPower", resourceAbbrevFormatted, currentRunicPowerColor) then
			local rp
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentRunicPowerColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				rp = textColorResult:WrapTextInColorCode(resourceAbbrevFormatted)
			else
				rp = string.format("|c%s%s|r", currentRunicPowerColor, resourceAbbrevFormatted)
			end
			lookup["$runicPower"] = rp
			lookup["$resource"] = rp
		end
		if lookupChanged(prevState, "$runicPowerMax", TRB.Data.character.maxResource, currentRunicPowerColor) then
			local rpMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$runicPowerMax"] = rpMax
			lookup["$resourceMax"] = rpMax
		end
	end

	-- Block B: Runes ($rune1Time-$rune6Time, $rune1Ready-$rune6Ready, $runesReadyCount)
	if not activeVars or activeVars["$rune1Time"] or activeVars["$rune2Time"] or activeVars["$rune3Time"]
		or activeVars["$rune4Time"] or activeVars["$rune5Time"] or activeVars["$rune6Time"]
		or activeVars["$rune1Ready"] or activeVars["$rune2Ready"] or activeVars["$rune3Ready"]
		or activeVars["$rune4Ready"] or activeVars["$rune5Ready"] or activeVars["$rune6Ready"]
		or activeVars["$runesReadyCount"] then
		local runes = TRB.Data.character.runes
		for i = 1, 6 do
			local rawTime = runes[i].remaining
			local timeKey = "$rune" .. i .. "Time"
			lookupLogic[timeKey] = rawTime
			if lookupChanged(prevState, timeKey, rawTime) then
				lookup[timeKey] = TRB.Functions.BarText:TimerPrecision(rawTime)
			end
			local readyKey = "$rune" .. i .. "Ready"
			lookupLogic[readyKey] = runes[i].ready
			lookup[readyKey] = ""
		end
		local _runesReadyCount = (runes[1].ready and 1 or 0) + (runes[2].ready and 1 or 0) + (runes[3].ready and 1 or 0) + (runes[4].ready and 1 or 0) + (runes[5].ready and 1 or 0) + (runes[6].ready and 1 or 0)
		lookupLogic["$runesReadyCount"] = _runesReadyCount
		if lookupChanged(prevState, "$runesReadyCount", _runesReadyCount) then
			lookup["$runesReadyCount"] = tostring(_runesReadyCount)
		end
	end

	-- Block C: Bone Shield ($boneShieldStacks, $boneShieldStacksMax)
	if not activeVars or activeVars["$boneShieldStacks"] or activeVars["$boneShieldStacksMax"] then
		local boneShieldStacks = snapshotData.attributes.boneShieldStacks or 0
		local maxBoneShield = TRB.Data.character.maxBoneShield or 10
		lookupLogic["$boneShieldStacks"] = boneShieldStacks
		lookupLogic["$boneShieldStacksMax"] = maxBoneShield
		if lookupChanged(prevState, "$boneShieldStacks", boneShieldStacks, nil, true) then
			lookup["$boneShieldStacks"] = string.format("%s", boneShieldStacks)
		end
		if lookupChanged(prevState, "$boneShieldStacksMax", maxBoneShield) then
			lookup["$boneShieldStacksMax"] = tostring(maxBoneShield)
		end
	end

	-- Block D: Coagulating Blood ($coagulatingBloodStacks, $coagulatingBloodStacksMax)
	if not activeVars or activeVars["$coagulatingBloodStacks"] or activeVars["$coagulatingBloodStacksMax"] then
		local attributes = snapshotData.attributes
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
		local _coagulatingBloodStacksMax = spells.coagulatingBlood.maxStacks

		lookupLogic["$coagulatingBloodStacksMax"] = _coagulatingBloodStacksMax

		-- A buff that is down is a known zero; one nothing in the Cooldown Manager holds is unknown.
		-- Memoized on the rendered string, since both are nil underneath.
		local stacksDisplay
		if not attributes.coagulatingBloodTracked then
			stacksDisplay = "??"
		elseif attributes.coagulatingBloodStacks ~= nil then
			stacksDisplay = string.format("%s", attributes.coagulatingBloodStacks)
		else
			stacksDisplay = string.format("%.0f", 0)
		end

		if lookupChanged(prevState, "$coagulatingBloodStacks", stacksDisplay) then
			lookup["$coagulatingBloodStacks"] = stacksDisplay
		end
		if lookupChanged(prevState, "$coagulatingBloodStacksMax", _coagulatingBloodStacksMax) then
			lookup["$coagulatingBloodStacksMax"] = tostring(_coagulatingBloodStacksMax)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Frost()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.deathknight.frost
	local sharedSettings = TRB.Data.specCache["deathknight_frost"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core runic power ($runicPower, $resource, $runicPowerMax, $resourceMax)
	if not activeVars or activeVars["$runicPower"] or activeVars["$resource"]
		or activeVars["$runicPowerMax"] or activeVars["$resourceMax"] then
		local normalizedRunicPower = snapshotData.attributes.resourceModified
		local currentRunicPowerColor = TRB.Data.settings.deathknight.frost.colors.text.current.color

		lookupLogic["$runicPower"] = normalizedRunicPower
		lookupLogic["$resource"] = normalizedRunicPower
		lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource

		local resourceAbbrevFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$runicPower", resourceAbbrevFormatted, currentRunicPowerColor) then
			local rp
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentRunicPowerColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				rp = textColorResult:WrapTextInColorCode(resourceAbbrevFormatted)
			else
				rp = string.format("|c%s%s|r", currentRunicPowerColor, resourceAbbrevFormatted)
			end
			lookup["$runicPower"] = rp
			lookup["$resource"] = rp
		end
		if lookupChanged(prevState, "$runicPowerMax", TRB.Data.character.maxResource, currentRunicPowerColor) then
			local rpMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$runicPowerMax"] = rpMax
			lookup["$resourceMax"] = rpMax
		end
	end

	-- Block B: Runes ($rune1Time-$rune6Time, $rune1Ready-$rune6Ready, $runesReadyCount)
	if not activeVars or activeVars["$rune1Time"] or activeVars["$rune2Time"] or activeVars["$rune3Time"]
		or activeVars["$rune4Time"] or activeVars["$rune5Time"] or activeVars["$rune6Time"]
		or activeVars["$rune1Ready"] or activeVars["$rune2Ready"] or activeVars["$rune3Ready"]
		or activeVars["$rune4Ready"] or activeVars["$rune5Ready"] or activeVars["$rune6Ready"]
		or activeVars["$runesReadyCount"] then
		local runes = TRB.Data.character.runes
		for i = 1, 6 do
			local rawTime = runes[i].remaining
			local timeKey = "$rune" .. i .. "Time"
			lookupLogic[timeKey] = rawTime
			if lookupChanged(prevState, timeKey, rawTime) then
				lookup[timeKey] = TRB.Functions.BarText:TimerPrecision(rawTime)
			end
			local readyKey = "$rune" .. i .. "Ready"
			lookupLogic[readyKey] = runes[i].ready
			lookup[readyKey] = ""
		end
		local _runesReadyCount = (runes[1].ready and 1 or 0) + (runes[2].ready and 1 or 0) + (runes[3].ready and 1 or 0) + (runes[4].ready and 1 or 0) + (runes[5].ready and 1 or 0) + (runes[6].ready and 1 or 0)
		lookupLogic["$runesReadyCount"] = _runesReadyCount
		if lookupChanged(prevState, "$runesReadyCount", _runesReadyCount) then
			lookup["$runesReadyCount"] = tostring(_runesReadyCount)
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Unholy()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.deathknight.unholy
	local sharedSettings = TRB.Data.specCache["deathknight_unholy"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core runic power ($runicPower, $resource, $runicPowerMax, $resourceMax)
	if not activeVars or activeVars["$runicPower"] or activeVars["$resource"]
		or activeVars["$runicPowerMax"] or activeVars["$resourceMax"] then
		local normalizedRunicPower = snapshotData.attributes.resourceModified
		local currentRunicPowerColor = TRB.Data.settings.deathknight.unholy.colors.text.current.color

		lookupLogic["$runicPower"] = normalizedRunicPower
		lookupLogic["$resource"] = normalizedRunicPower
		lookupLogic["$runicPowerMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource

		local resourceAbbrevFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$runicPower", resourceAbbrevFormatted, currentRunicPowerColor) then
			local rp
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentRunicPowerColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				rp = textColorResult:WrapTextInColorCode(resourceAbbrevFormatted)
			else
				rp = string.format("|c%s%s|r", currentRunicPowerColor, resourceAbbrevFormatted)
			end
			lookup["$runicPower"] = rp
			lookup["$resource"] = rp
		end
		if lookupChanged(prevState, "$runicPowerMax", TRB.Data.character.maxResource, currentRunicPowerColor) then
			local rpMax = string.format("|c%s%s|r", currentRunicPowerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$runicPowerMax"] = rpMax
			lookup["$resourceMax"] = rpMax
		end
	end

	-- Block B: Runes ($rune1Time-$rune6Time, $rune1Ready-$rune6Ready, $runesReadyCount)
	if not activeVars or activeVars["$rune1Time"] or activeVars["$rune2Time"] or activeVars["$rune3Time"]
		or activeVars["$rune4Time"] or activeVars["$rune5Time"] or activeVars["$rune6Time"]
		or activeVars["$rune1Ready"] or activeVars["$rune2Ready"] or activeVars["$rune3Ready"]
		or activeVars["$rune4Ready"] or activeVars["$rune5Ready"] or activeVars["$rune6Ready"]
		or activeVars["$runesReadyCount"] then
		local runes = TRB.Data.character.runes
		for i = 1, 6 do
			local rawTime = runes[i].remaining
			local timeKey = "$rune" .. i .. "Time"
			lookupLogic[timeKey] = rawTime
			if lookupChanged(prevState, timeKey, rawTime) then
				lookup[timeKey] = TRB.Functions.BarText:TimerPrecision(rawTime)
			end
			local readyKey = "$rune" .. i .. "Ready"
			lookupLogic[readyKey] = runes[i].ready
			lookup[readyKey] = ""
		end
		local _runesReadyCount = (runes[1].ready and 1 or 0) + (runes[2].ready and 1 or 0) + (runes[3].ready and 1 or 0) + (runes[4].ready and 1 or 0) + (runes[5].ready and 1 or 0) + (runes[6].ready and 1 or 0)
		lookupLogic["$runesReadyCount"] = _runesReadyCount
		if lookupChanged(prevState, "$runesReadyCount", _runesReadyCount) then
			lookup["$runesReadyCount"] = tostring(_runesReadyCount)
		end
	end

	TRB.Data.lookup = lookup
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
		end
	elseif TRB.Data.character.specId == 3 then
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
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

	-- Plain count of complete (ready) runes ($runesReadyCount) for Runes custom thresholds.
	local readyCount = 0
	for x = 1, TRB.Data.character.maxResource2 or 0 do
		if runes[x] and runes[x].ready then
			readyCount = readyCount + 1
		end
	end
	TRB.Data.snapshotData.attributes.runesReadyCount = readyCount
end

---Refreshes the Coagulating Blood stack count from the Cooldown Manager. `coagulatingBloodTracked`
---separates a buff that is down (known zero) from one the Cooldown Manager lacks (renders "??").
local function RefreshCoagulatingBlood()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local attributes = snapshotData.attributes
	local wasTracked = attributes.coagulatingBloodTracked == true
	local wasActive = attributes.coagulatingBloodActive == true

	attributes.coagulatingBloodStacks = nil
	attributes.coagulatingBloodTracked = false
	attributes.coagulatingBloodActive = false

	if spells ~= nil and spells.coagulatingBlood ~= nil then
		-- Pinned to the buff viewers: it is a self-buff, and a cooldown viewer would describe the
		-- cast instead. applications is nil while the buff is down and secret while it is up.
		local cdm = TRB.Functions.CooldownManager
		local trackedId = cdm:ResolveTrackedSpellId(cdm.SourceGroup.BUFF, spells.coagulatingBlood.id)
		if trackedId ~= nil then
			attributes.coagulatingBloodTracked = true
			local stacksOk, stacks = cdm:Read(trackedId, cdm.Signal.APPLICATIONS, cdm.SourceGroup.BUFF)
			if stacksOk then
				attributes.coagulatingBloodStacks = stacks
				attributes.coagulatingBloodActive = true
			end
		end
	end

	if wasTracked ~= attributes.coagulatingBloodTracked or wasActive ~= attributes.coagulatingBloodActive then
		TRB.Data.lookupDirty = true
	end
end

local function UpdateSnapshot_Blood()
	UpdateSnapshot()
	RefreshCoagulatingBlood()
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

local function CountRunesOnCooldown()
	local runes = TRB.Data.character.runes
	local runesOnCooldown = 0
	for i = 1, TRB.Data.character.maxResource2 or 0 do
		if runes[i] and not runes[i].ready then
			runesOnCooldown = runesOnCooldown + 1
		end
	end
	return runesOnCooldown
end

local function GetDeathKnightIndicatorState(specSettings)
	local sharedColors = specSettings.colors.shared
	local indicatorColors = sharedColors and sharedColors.indicatorColors
	local nodeOrder = sharedColors and sharedColors.nodeOrder
	local gradientOrder = sharedColors and sharedColors.gradientOrder
	local runesOnCooldown = CountRunesOnCooldown()
	local conditionMap = {
		borderOvercap = TRB.Data.character.inCombat,
		runeRegenOvercap = TRB.Data.character.inCombat and runesOnCooldown < 3,
	}

	return indicatorColors, nodeOrder, gradientOrder, conditionMap, sharedColors
end

local function GetActiveGradientIndicator(indicatorColors, gradientOrder, conditionMap)
	if not (indicatorColors and gradientOrder and conditionMap) then
		return nil
	end

	for i = #gradientOrder, 1, -1 do
		local key = gradientOrder[i]
		local indicator = indicatorColors[key]
		if indicator and indicator.enabled and conditionMap[key] and indicator.isGradient then
			return indicator
		end
	end

	return nil
end

local function BuildGradientCurves(specSettings, barKey, currentColors, gradientIndicator)
	local curves = {}
	if gradientIndicator and gradientIndicator.targets then
		local targets = gradientIndicator.targets[barKey]
		if targets then
			if targets.border then
				curves.border = Color:BuildResourceThresholdCurve(specSettings, currentColors.border, gradientIndicator.color)
			end
			if targets.bar then
				curves.bar = Color:BuildResourceThresholdCurve(specSettings, currentColors.bar, gradientIndicator.color)
			end
			if targets.background then
				curves.background = Color:BuildResourceThresholdCurve(specSettings, currentColors.background, gradientIndicator.color)
			end
		end
	end
	return curves
end

local function ApplyPrimaryRunicPowerColors(specSettings, primaryNode)
	local indicatorColors, _, gradientOrder, conditionMap, sharedColors = GetDeathKnightIndicatorState(specSettings)
	local runicPowerBarColors = {
		bar = specSettings.colors.bar.base,
		border = specSettings.colors.bar.border.color,
		background = specSettings.colors.bar.background.color,
	}

	TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, { runicPowerBar = runicPowerBarColors })

	local gradientIndicator = GetActiveGradientIndicator(indicatorColors, gradientOrder, conditionMap)
	local overcapCurves = BuildGradientCurves(specSettings, "runicPowerBar", runicPowerBarColors, gradientIndicator)

	if overcapCurves.border then
		local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.border)
		primaryNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(primaryNode, overcapCurves.border))
	else
		primaryNode:SetBorderColor(runicPowerBarColors.border)
	end

	if overcapCurves.bar then
		local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.bar)
		primaryNode:SetColorCurve(barColorResult)
	else
		TRB.Functions.Color:ApplyFillColor(primaryNode, runicPowerBarColors.bar)
	end

	if overcapCurves.background then
		local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.background)
		primaryNode:SetBackgroundColorCurve(backgroundColorResult)
	else
		primaryNode:SetBackgroundColorFromString(runicPowerBarColors.background)
	end
end

---Updates the rune display
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateRunes(specSettings, specCacheSettings)
	local cpBackgroundColor = specSettings.colors.comboPoints.background.color
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(cpBackgroundColor, true)
	local cpBorderColor = specSettings.colors.comboPoints.border.color
	local cpBaseColor = specSettings.colors.comboPoints.base
	local cpCooldownColor = specSettings.colors.comboPoints.cooldown
	local cpCooldownEnabled = specSettings.colors.comboPoints.cooldownEnabled

	local runes = TRB.Data.character.runes
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local indicatorColors, _, gradientOrder, conditionMap, sharedColors = GetDeathKnightIndicatorState(specSettings)
	local runeRegenIndicator = indicatorColors and indicatorColors.runeRegenOvercap
	local runeTargets = runeRegenIndicator and runeRegenIndicator.enabled and conditionMap.runeRegenOvercap
		and runeRegenIndicator.targets and runeRegenIndicator.targets.runesBar or nil
	local runeBarColors = {
		bar = cpBaseColor,
		border = cpBorderColor,
		background = cpBackgroundColor,
	}

	TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, { runesBar = runeBarColors })
	local gradientIndicator = GetActiveGradientIndicator(indicatorColors, gradientOrder, conditionMap)
	local runeGradientCurves = BuildGradientCurves(specSettings, "runesBar", runeBarColors, gradientIndicator)
	local runeGradientResults = {}
	if runeGradientCurves.border then
		runeGradientResults.border = UnitPowerPercent("player", TRB.Data.resource, true, runeGradientCurves.border)
	end
	if runeGradientCurves.bar then
		runeGradientResults.bar = UnitPowerPercent("player", TRB.Data.resource, true, runeGradientCurves.bar)
	end
	if runeGradientCurves.background then
		runeGradientResults.background = UnitPowerPercent("player", TRB.Data.resource, true, runeGradientCurves.background)
	end
	
	for x = 1, TRB.Data.character.maxResource2 do
		local rune = runes[x]
		local runeBorderColor = runeBarColors.border
		local runeColor = runeBarColors.bar
		local runeBackgroundColor = runeBarColors.background

		if cpCooldownEnabled and not rune.ready and not (runeTargets and runeTargets.bar) then
			runeColor = cpCooldownColor
		end

		-- When cooldown display is off, runes are binary: full when ready, empty otherwise
		local runeValue = cpCooldownEnabled and rune.percentage or (rune.ready and 1 or 0)

		if barGroups and barGroups.secondary then
			local runeNode = barGroups.secondary:GetNode(x)
			if runeNode then
				Bar:SetBarNodeValue(specCacheSettings, "rune" .. x, runeNode, runeValue, 1)
				if runeGradientResults.border then
					runeNode:SetBorderColorCurve(runeGradientResults.border, Color:EvaluateEndCapCurve(runeNode, runeGradientCurves.border))
				else
					runeNode:SetBorderColor(runeBorderColor)
				end
				if runeGradientResults.bar then
					runeNode:SetColorCurve(runeGradientResults.bar)
				else
					TRB.Functions.Color:ApplyFillColor(runeNode, runeColor)
				end
				if runeGradientResults.background then
					runeNode:SetBackgroundColorCurve(runeGradientResults.background)
				elseif runeBackgroundColor == cpBackgroundColor then
					runeNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
				else
					runeNode:SetBackgroundColorFromString(runeBackgroundColor)
				end
				Bar:ApplyEndCapIndicator(runeNode, "runesBar")
			end
		end
	end
end

---Updates the Bone Shield bar display (Blood only).
---Follows the same pattern as VDH Soul Fragments: secret value from GetSpellCastCount
---is passed to SetBarNodeValue (stepped min/max handles fill), and Ossuary uses
---positional coloring (node index >= threshold) since the stack count is a secret value
---that cannot be compared directly.
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateBoneShield(specSettings, specCacheSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local boneShieldStacks = snapshotData.attributes.boneShieldStacks or 0
	local maxBoneShield = TRB.Data.character.maxBoneShield or 10
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if not (barGroups and barGroups.boneShield) then
		return
	end

	local defaultBoneShieldColors = TRB.Functions.Settings:DefaultBoneShieldBarColors()
	local storedBoneShieldColors = specSettings.colors and specSettings.colors.bars and specSettings.colors.bars.boneShield or {}
	local boneShieldColors = {
		bar = storedBoneShieldColors.bar or defaultBoneShieldColors.bar,
		border = storedBoneShieldColors.border or defaultBoneShieldColors.border,
		background = storedBoneShieldColors.background or defaultBoneShieldColors.background,
		ossuary = storedBoneShieldColors.ossuary or defaultBoneShieldColors.ossuary,
		ossuaryThreshold = storedBoneShieldColors.ossuaryThreshold or defaultBoneShieldColors.ossuaryThreshold,
	}

	local cpBackgroundColor = boneShieldColors.background.color
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(cpBackgroundColor, true)
	local cpBorderColor = boneShieldColors.border.color

	-- Ossuary positional coloring: stack count is a secret value and cannot be compared
	-- directly — positional coloring is the only approach (same as VDH penultimate/final).
	-- ossuaryBuildingEnabled: nodes 1 through (threshold-1) get the ossuary building range color
	-- ossuaryThresholdEnabled: the node at exactly the threshold gets the ossuary threshold color
	local ossuaryStackThreshold = nil
	local ossuaryBuildingEnabled = false
	local ossuaryThresholdEnabled = false
	if talents and talents:IsTalentActive(spells.ossuary) then
		ossuaryStackThreshold = spells.ossuary.attributes and spells.ossuary.attributes.stackThreshold or 5
		ossuaryBuildingEnabled = boneShieldColors.ossuary and boneShieldColors.ossuary.enabled or false
		ossuaryThresholdEnabled = boneShieldColors.ossuaryThreshold and boneShieldColors.ossuaryThreshold.enabled or false
	end

	-- Compute indicator overrides for bone shield elements (nil = use default)
	local bsBarOverride, bsBorderOverride, bsBackgroundOverride = nil, nil, nil
	local sharedColors = specSettings.colors.shared
	local indicatorColors = sharedColors and sharedColors.indicatorColors
	local nodeOrder = sharedColors and sharedColors.nodeOrder

	if nodeOrder and indicatorColors then
		local _, _, _, conditionMap = GetDeathKnightIndicatorState(specSettings)

		-- Apply flat indicators to bone shield targets (reverse iteration, last writer wins)
		for i = #nodeOrder, 1, -1 do
			local key = nodeOrder[i]
			local indicator = indicatorColors[key]
			if indicator and indicator.enabled and conditionMap[key] then
				local bsTargets = indicator.targets and indicator.targets.boneShield
				if bsTargets then
					if bsTargets.bar then bsBarOverride = indicator end
					if bsTargets.border then bsBorderOverride = indicator.color end
					if bsTargets.background then bsBackgroundOverride = indicator.color end
				end
			end
		end
	end

	-- Build gradient curves for bone shield targets (border/background, uses runic power scale)
	local bsOvercapCurves = {}
	local gradientOrder = sharedColors and sharedColors.gradientOrder
	if gradientOrder and indicatorColors then
		local _, _, _, conditionMap = GetDeathKnightIndicatorState(specSettings)
		for i = #gradientOrder, 1, -1 do
			local key = gradientOrder[i]
			local indicator = indicatorColors[key]
			if indicator and indicator.enabled and conditionMap[key] and indicator.isGradient then
				local bsTargets = indicator.targets and indicator.targets.boneShield
				if bsTargets then
					if bsTargets.border then
						bsOvercapCurves.border = Color:BuildResourceThresholdCurve(specSettings, bsBorderOverride or cpBorderColor, indicator.color)
					end
					if bsTargets.background then
						bsOvercapCurves.background = Color:BuildResourceThresholdCurve(specSettings, bsBackgroundOverride or cpBackgroundColor, indicator.color)
					end
				end
				break
			end
		end
	end

	-- Update all Bone Shield nodes with positional coloring + indicator overrides
	for x = 1, maxBoneShield do
		local boneShieldNode = barGroups.boneShield:GetNode(x)
		if boneShieldNode then
			-- All nodes get the same raw secret value; each node's stepped
			-- SetMinMax(x-1, x) handles fill via StatusBar clamping
			Bar:SetBarNodeValue(specCacheSettings, "boneShield" .. x, boneShieldNode, boneShieldStacks)

			-- Positional coloring:
			-- Nodes 1 through threshold: ossuary color (if enabled)
			-- Node at exact threshold: ossuaryThreshold color overrides ossuary (if enabled)
			-- Nodes above threshold: base color
			local boneShieldColor = boneShieldColors.bar
			if ossuaryStackThreshold then
				if ossuaryBuildingEnabled and x <= ossuaryStackThreshold then
					boneShieldColor = boneShieldColors.ossuary
				end
				if ossuaryThresholdEnabled and x == ossuaryStackThreshold then
					boneShieldColor = boneShieldColors.ossuaryThreshold
				end
			end

			-- Flat indicator override (overrides positional coloring)
			if bsBarOverride then
				boneShieldColor = bsBarOverride
			end
			TRB.Functions.Color:ApplyFillColor(boneShieldNode, boneShieldColor)

			-- Border: gradient > flat indicator > default
			if bsOvercapCurves.border then
				local borderResult = UnitPowerPercent("player", TRB.Data.resource, true, bsOvercapCurves.border)
				boneShieldNode:SetBorderColorCurve(borderResult)
			else
				boneShieldNode:SetBorderColor(bsBorderOverride or cpBorderColor)
			end

			-- Background: gradient > flat indicator > default
			if bsOvercapCurves.background then
				local bgResult = UnitPowerPercent("player", TRB.Data.resource, true, bsOvercapCurves.background)
				boneShieldNode:SetBackgroundColorCurve(bgResult)
			else
				if bsBackgroundOverride then
					boneShieldNode:SetBackgroundColorFromString(bsBackgroundOverride)
				else
					boneShieldNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
				end
			end
		end
	end
end

---Updates the Coagulating Blood bar (Blood only). One application is one percent, so the node runs
---0-100 and takes the raw secret count straight from the Cooldown Manager; the StatusBar scales it.
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateCoagulatingBlood(specSettings, specCacheSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if not (barGroups and barGroups.coagulatingBlood) then
		return
	end

	local node = barGroups.coagulatingBlood:GetNode(1)
	if node == nil then
		return
	end

	local colors = specSettings.colors and specSettings.colors.bars and specSettings.colors.bars.coagulatingBlood
	if colors == nil then
		return
	end

	local stacks = snapshotData.attributes.coagulatingBloodStacks or 0
	Bar:SetBarNodeValue(specCacheSettings, "coagulatingBlood", node, stacks, spells.coagulatingBlood.maxStacks)

	-- Same color resolution as the primary bar. Unlike Bone Shield the fill has no positional scheme
	-- of its own, so the gradient can target it too.
	local indicatorColors, _, gradientOrder, conditionMap, sharedColors = GetDeathKnightIndicatorState(specSettings)
	local coagulatingBloodColors = {
		bar = colors.bar,
		border = colors.border.color,
		background = colors.background.color,
	}

	Color:ApplyIndicatorColors(sharedColors, conditionMap, { coagulatingBlood = coagulatingBloodColors })

	local gradientIndicator = GetActiveGradientIndicator(indicatorColors, gradientOrder, conditionMap)
	local overcapCurves = BuildGradientCurves(specSettings, "coagulatingBlood", coagulatingBloodColors, gradientIndicator)

	if overcapCurves.border then
		local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.border)
		node:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(node, overcapCurves.border))
	else
		node:SetBorderColor(coagulatingBloodColors.border)
	end

	if overcapCurves.bar then
		local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.bar)
		node:SetColorCurve(barColorResult)
	else
		Color:ApplyFillColor(node, coagulatingBloodColors.bar)
	end

	if overcapCurves.background then
		local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurves.background)
		node:SetBackgroundColorCurve(backgroundColorResult)
	else
		node:SetBackgroundColorFromString(coagulatingBloodColors.background)
	end

	Bar:ApplyEndCapIndicator(node, "coagulatingBlood")
end

local function UpdateResourceBar()
	local refreshText = false
	local classSettings = TRB.Data.settings.deathknight
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
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

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	local primaryResourceFrame = primaryNode:GetFrame()

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.blood
		local specCacheSettings = TRB.Data.specCache.deathknight_blood.settings
		UpdateSnapshot_Blood()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resource
				ApplyPrimaryRunicPowerColors(specSettings, primaryNode)

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "runicPowerBar")
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					local thresholds = primaryNode:GetThresholds()
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, primaryResourceFrame)
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
							frameLevel = frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					else
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
					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
					Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				UpdateRunes(specSettings, specCacheSettings)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end

			if specSettings.displayBar.boneShield and not specSettings.displayBar.boneShield.neverShow then
				refreshText = true
				UpdateBoneShield(specSettings, specCacheSettings)
			end

			if specSettings.displayBar.coagulatingBlood and not specSettings.displayBar.coagulatingBlood.neverShow then
				refreshText = true
				UpdateCoagulatingBlood(specSettings, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.frost
		local specCacheSettings = TRB.Data.specCache.deathknight_frost.settings
		UpdateSnapshot_Frost()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resource
				ApplyPrimaryRunicPowerColors(specSettings, primaryNode)

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "runicPowerBar")
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					local thresholds = primaryNode:GetThresholds()
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, primaryResourceFrame)
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
							frameLevel = frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					else
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
					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
					Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				UpdateRunes(specSettings, specCacheSettings)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.unholy
		local specCacheSettings = TRB.Data.specCache.deathknight_unholy.settings
		UpdateSnapshot_Unholy()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resource
				ApplyPrimaryRunicPowerColors(specSettings, primaryNode)

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "runicPowerBar")
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					local thresholds = primaryNode:GetThresholds()
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, primaryResourceFrame)
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
							frameLevel = frameLevels.thresholdUnusable
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					else
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
					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
					Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				UpdateRunes(specSettings, specCacheSettings)
			end

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

	-- Unregister spec-specific events before switching
	spellEventFrame:UnregisterEvent("SPELL_UPDATE_USES")
	
	if TRB.Data.character.specId == 1 then
		specCache.deathknight_blood.talents:GetTalents()
		FillSpellData_Blood()
		Character:LoadFromSpecializationCache(specCache.deathknight_blood)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Blood
		Bar:UpdateSanityCheckValues(specCache.deathknight_blood.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#boneShield"] = spells.boneShield.icon
		lookup["#coagulatingBlood"] = spells.coagulatingBlood.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "deathknight_blood" then
			talents = specCache.deathknight_blood.talents
			TRB.Data.barConstructedForSpec = "deathknight_blood"
			ConstructResourceBar(specCache.deathknight_blood.settings)
		end

		-- Register Bone Shield tracking via SPELL_UPDATE_USES
		spellEventFrame:RegisterEvent("SPELL_UPDATE_USES")
		-- Initialize current bone shield stacks
		TRB.Data.snapshotData.attributes.boneShieldStacks = C_Spell.GetSpellCastCount(spells.marrowrend.id) or 0
	elseif TRB.Data.character.specId == 2 then
		specCache.deathknight_frost.talents:GetTalents()
		FillSpellData_Frost()
		Character:LoadFromSpecializationCache(specCache.deathknight_frost)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Frost
		Bar:UpdateSanityCheckValues(specCache.deathknight_frost.settings)

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
		Character:LoadFromSpecializationCache(specCache.deathknight_unholy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Unholy
		Bar:UpdateSanityCheckValues(specCache.deathknight_unholy.settings)

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
	-- Wrong game version for this build: halt before anything reads or writes settings.
	if TRB.Functions.VersionGate:IsBlocked() then
		return
	end

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
	TRB.Data.character.className = "deathknight"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.RunicPower, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.RunicPower, false)
	TRB.Data.character.maxResource2 = 6 -- Death Knights always have 6 runes
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "blood"
		TRB.Data.character.compositeKey = "deathknight_blood"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		-- Determine max Bone Shield stacks based on Improved Bone Shield talent
		local spellsData = TRB.Data.spellsData
		if spellsData and spellsData.spells then
			local spells = spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]
			if spells.boneShield and spells.improvedBoneShield then
				local maxBoneShield = spells.boneShield.maxStacks or 10
				if talents and talents:IsTalentActive(spells.improvedBoneShield) then
					maxBoneShield = maxBoneShield + (spells.improvedBoneShield.attributes.maxStacksMod or 2)
				end
				TRB.Data.character.maxBoneShield = maxBoneShield
			end
		end
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
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.boneShield, sharedSettings and sharedSettings.displayBar.boneShield, TRB.Data.character.specId == 1, TRB.Data.character.maxBoneShield, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.coagulatingBlood, sharedSettings and sharedSettings.displayBar.coagulatingBlood, TRB.Data.character.specId == 1, 1, nil),
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
	local shared = {
		["$resource"] = false, ["$runicPower"] = false,
		["$resourceMax"] = true, ["$runicPowerMax"] = true,
		["$rune1Time"] = function() return TRB.Data.character.runes[1].remaining > 0 end,
		["$rune2Time"] = function() return TRB.Data.character.runes[2].remaining > 0 end,
		["$rune3Time"] = function() return TRB.Data.character.runes[3].remaining > 0 end,
		["$rune4Time"] = function() return TRB.Data.character.runes[4].remaining > 0 end,
		["$rune5Time"] = function() return TRB.Data.character.runes[5].remaining > 0 end,
		["$rune6Time"] = function() return TRB.Data.character.runes[6].remaining > 0 end,
		["$rune1Ready"] = function() return TRB.Data.character.runes[1].ready end,
		["$rune2Ready"] = function() return TRB.Data.character.runes[2].ready end,
		["$rune3Ready"] = function() return TRB.Data.character.runes[3].ready end,
		["$rune4Ready"] = function() return TRB.Data.character.runes[4].ready end,
		["$rune5Ready"] = function() return TRB.Data.character.runes[5].ready end,
		["$rune6Ready"] = function() return TRB.Data.character.runes[6].ready end,
		["$runesReadyCount"] = function()
			for x = 1, TRB.Data.character.maxResource2 do
				if TRB.Data.character.runes[x].ready then return true end
			end
			return false
		end,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
	}
	local blood = {}
	for k, v in pairs(shared) do blood[k] = v end
	blood["$boneShieldStacks"] = false
	blood["$boneShieldStacksMax"] = true
	-- Goes false when the count is unknown, matching the "??" the text renders.
	blood["$coagulatingBloodStacks"] = function()
		return TRB.Data.snapshotData.attributes.coagulatingBloodTracked == true
	end
	blood["$coagulatingBloodStacksMax"] = true
	specValidVars = { [1] = blood, [2] = shared, [3] = shared }
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
	elseif relativeToFrame == "CoagulatingBloodBar" then
		if barGroups and barGroups.coagulatingBlood then
			local coagulatingBloodNode = barGroups.coagulatingBlood:GetNode(1)
			if coagulatingBloodNode then
				local isVisible = barGroups.coagulatingBlood.isVisible and coagulatingBloodNode.isVisible
				return coagulatingBloodNode:GetFrame(), true, isVisible
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
		local boneShieldIndex = string.match(relativeToFrame, "^BoneShield(%d+)$")
		if boneShieldIndex ~= nil then
			local index = tonumber(boneShieldIndex)
			if index ~= nil and barGroups and barGroups.boneShield then
				local boneShieldNode = barGroups.boneShield:GetNode(index)
				if boneShieldNode then
					local isVisible = barGroups.boneShield.isVisible and boneShieldNode.isVisible
					return boneShieldNode:GetFrame(), true, isVisible
				end
			end
		end
		return nil, true, false
	end
	return nil, true, false
end

---Returns true when any rune is on cooldown, producing time-dependent $runeXTime variables.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local runes = TRB.Data.character.runes
	if runes then
		for i = 1, 6 do
			if runes[i] and runes[i].ready == false then
				return true
			end
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
