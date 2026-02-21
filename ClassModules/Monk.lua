local _, TRB = ...
if TRB.Data.character.classId ~= 10 then --Only do this if we're on a Monk!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

---@type TRB.Classes.Talents
local talents

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	monk_brewmaster = TRB.Classes.SpecCache:New(),
	monk_mistweaver = TRB.Classes.SpecCache:New(),
	monk_windwalker = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Brewmaster
	specCache.monk_brewmaster.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.monk_brewmaster.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		maxResource2 = 0,
		effects = {
		},
		items = {}
	}
	
	specCache.monk_brewmaster.spellsData.spells = TRB.Classes.Monk.BrewmasterSpells:New()
	---@type TRB.Classes.Monk.BrewmasterSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.monk_brewmaster.spellsData.spells

	---@type TRB.Classes.Snapshot
	specCache.monk_brewmaster.snapshotData.snapshots[spells.detox.id] = TRB.Classes.Snapshot:New(spells.detox)
	---@type TRB.Classes.Snapshot
	specCache.monk_brewmaster.snapshotData.snapshots[spells.expelHarm.id] = TRB.Classes.Snapshot:New(spells.expelHarm)
	---@type TRB.Classes.Snapshot
	specCache.monk_brewmaster.snapshotData.snapshots[spells.paralysis.id] = TRB.Classes.Snapshot:New(spells.paralysis)
	---@type TRB.Classes.Snapshot
	specCache.monk_brewmaster.snapshotData.snapshots[spells.cracklingJadeLightning.id] = TRB.Classes.Snapshot:New(spells.cracklingJadeLightning)
	---@type TRB.Classes.Snapshot
	specCache.monk_brewmaster.snapshotData.snapshots[spells.kegSmash.id] = TRB.Classes.Snapshot:New(spells.kegSmash)
	---@type TRB.Classes.Snapshot
	specCache.monk_brewmaster.snapshotData.snapshots[spells.invokeNiuzao.id] = TRB.Classes.Snapshot:New(spells.invokeNiuzao)

	specCache.monk_brewmaster.snapshotData.attributes.resourceRegen = 0
	specCache.monk_brewmaster.snapshotData.audio = {
	}

	specCache.monk_brewmaster.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Mistweaver
	specCache.monk_mistweaver.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.monk_mistweaver.character = {
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
	
	specCache.monk_mistweaver.spellsData.spells = TRB.Classes.Monk.MistweaverSpells:New()
	---@type TRB.Classes.Monk.MistweaverSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.monk_mistweaver.spellsData.spells

	specCache.monk_mistweaver.snapshotData.attributes.manaRegen = 0
	specCache.monk_mistweaver.snapshotData.audio = {
		innervateCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.monk_mistweaver.snapshotData.snapshots[spells.vivaciousVivification.id] = TRB.Classes.Snapshot:New(spells.vivaciousVivification)

	specCache.monk_mistweaver.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Windwalker
	specCache.monk_windwalker.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.monk_windwalker.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	specCache.monk_windwalker.spellsData.spells = TRB.Classes.Monk.WindwalkerSpells:New()
	---@type TRB.Classes.Monk.WindwalkerSpells
	---@diagnostic disable-next-line: assign-type-mismatch, cast-local-type
	spells = specCache.monk_windwalker.spellsData.spells

	specCache.monk_windwalker.snapshotData.attributes.resourceRegen = 0
	specCache.monk_windwalker.snapshotData.audio = {
		chiThreshold1Played = false,
		chiThreshold2Played = false,
		chiThreshold3Played = false,
	}
	---@type TRB.Classes.Snapshot
	specCache.monk_windwalker.snapshotData.snapshots[spells.detox.id] = TRB.Classes.Snapshot:New(spells.detox)
	---@type TRB.Classes.Snapshot
	specCache.monk_windwalker.snapshotData.snapshots[spells.expelHarm.id] = TRB.Classes.Snapshot:New(spells.expelHarm)
	---@type TRB.Classes.Snapshot
	specCache.monk_windwalker.snapshotData.snapshots[spells.paralysis.id] = TRB.Classes.Snapshot:New(spells.paralysis)
	---@type TRB.Classes.Snapshot
	specCache.monk_windwalker.snapshotData.snapshots[spells.strikeOfTheWindlord.id] = TRB.Classes.Snapshot:New(spells.strikeOfTheWindlord)
	---@type TRB.Classes.Snapshot
	specCache.monk_windwalker.snapshotData.snapshots[spells.danceOfChiJi.id] = TRB.Classes.Snapshot:New(spells.danceOfChiJi)
	---@type TRB.Classes.Snapshot
	specCache.monk_windwalker.snapshotData.snapshots[spells.heartOfTheJadeSerpent.id] = TRB.Classes.Snapshot:New(spells.heartOfTheJadeSerpent)

	specCache.monk_windwalker.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Brewmaster()
	TRB.Functions.Character:FillSpecializationCacheSettings("monk", "brewmaster")
	
	-- Only destroy and recreate bar groups when switching to this spec
	-- (guards against redundant delayed SwitchSpec calls that would orphan initialized bars)
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "monk_brewmaster" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Monk.BarGroupsFactory:CreateForSpec(1)
	end
end

local function FillSpellData_Brewmaster()
	Setup_Brewmaster()
	---@type TRB.Classes.SpellsData
	specCache.monk_brewmaster.spellsData:FillSpellData()
	local spells = specCache.monk_brewmaster.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]

	TRB.Classes.Monk.BrewmasterSpells.FillBarTextVariables(specCache.monk_brewmaster)
end

local function Setup_Mistweaver()
	TRB.Functions.Character:FillSpecializationCacheSettings("monk", "mistweaver", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	-- (guards against redundant delayed SwitchSpec calls that would orphan initialized bars)
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "monk_mistweaver" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Monk.BarGroupsFactory:CreateForSpec(2)
	end
end

local function FillSpellData_Mistweaver()
	Setup_Mistweaver()
	---@type TRB.Classes.SpellsData
	specCache.monk_mistweaver.spellsData:FillSpellData()
	local spells = specCache.monk_mistweaver.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]

	TRB.Classes.Monk.MistweaverSpells.FillBarTextVariables(specCache.monk_mistweaver)
end

local function Setup_Windwalker()
	TRB.Functions.Character:FillSpecializationCacheSettings("monk", "windwalker")
	
	-- Only destroy and recreate bar groups when switching to this spec
	-- (guards against redundant delayed SwitchSpec calls that would orphan initialized bars)
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "monk_windwalker" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Monk.BarGroupsFactory:CreateForSpec(3)
	end
end

local function FillSpellData_Windwalker()
	Setup_Windwalker()
	---@type TRB.Classes.SpellsData
	specCache.monk_windwalker.spellsData:FillSpellData()
	local spells = specCache.monk_windwalker.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]

	TRB.Classes.Monk.WindwalkerSpells.FillBarTextVariables(specCache.monk_windwalker)
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	
	if TRB.Data.character.specId == 1 then -- Brewmaster
	elseif TRB.Data.character.specId == 2 then -- Mistweaver
	elseif TRB.Data.character.specId == 3 then -- Windwalker
		targetData:UpdateTrackedSpells(currentTime)
	end
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

	-- Create thresholds on the primary BarNode
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

	-- Handle secondary bar based on spec
	if barGroups then
		if TRB.Data.character.specId == 1 then -- Brewmaster uses Stagger bar with thresholds
			if barGroups.stagger then
				TRB.Data.character.maxResource2 = 1
				
				-- Create thresholds on the Stagger bar (for Medium, Heavy, and Extreme Stagger thresholds)
				-- Layout and appearance are handled by the generic ApplyCustomBarGroupsLayout/Appearance
				local staggerNode = barGroups.stagger:GetNode(1)
				if staggerNode then
					staggerNode:ClearThresholds()
					-- Get stagger bar settings
					local staggerSettings = settings.bars and settings.bars["stagger"]
					local staggerColors = settings.colors and settings.colors.bars and settings.colors.bars.stagger
					local thresholdWidth = settings.thresholds and settings.thresholds.properties and settings.thresholds.properties.width or 2
					local thresholdHeight = staggerSettings and staggerSettings.height or 24
					local borderColor = staggerColors and staggerColors.border and staggerColors.border.color
					
					for _ = 1, 3 do
						local thresholdFrame = CreateFrame("Frame", nil, staggerNode:GetFrame())
						TRB.Functions.Threshold:ResetThresholdLineCustomBar(thresholdFrame, thresholdWidth, thresholdHeight, borderColor)
						staggerNode:RegisterThreshold(thresholdFrame)
					end
				end
			end

		elseif TRB.Data.character.specId == 3 and barGroups.secondary then -- Windwalker uses Chi
			local maxChi = TRB.Data.character.maxResource2
			if maxChi == nil or maxChi == 0 then
				maxChi = barGroups.secondary.maxNodes or 5
			end
			TRB.Data.character.maxResource2 = maxChi
			
			-- Ensure we have enough nodes for the max chi
			barGroups.secondary:SetMaxNodes(maxChi)
			
			-- Set the node count and layout for Chi
			barGroups.secondary:SetNodeCount(maxChi)
			barGroups.secondary:SetLayout(settings.comboPoints.spacing, TRB.Functions.Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
			barGroups.secondary:Show()
			
			-- Get effective width for secondary bar, accounting for CDM width matching
			local effectiveWidth, cdmForced = TRB.Functions.Bar:GetEffectiveWidthForBarGroup(barGroups, settings, "secondary")
			if cdmForced then
				barGroups.secondary.fullWidth = true
			end
			
			-- Apply layout to position all Chi nodes correctly
			barGroups.secondary:ApplyLayout(
				effectiveWidth,
				settings.comboPoints.width,
				settings.comboPoints.height,
				settings.comboPoints.border
			)
			
			-- Set up Chi nodes with textures and colors
			local frameLevels = TRB.Data.constants.frameLevels
			for i = 1, maxChi do
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
					node:SetColor(settings.colors.comboPoints.base.color)
					node:SetFrameLevel(frameLevels.comboPoint)
				end
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Brewmaster()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.brewmaster
	local sharedSettings = TRB.Data.specCache["monk_brewmaster"].settings
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()

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

	--$energy
	local _currentEnergy = snapshotData.attributes.resource
	local currentEnergy
	local castingEnergy
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentEnergy))
		castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", snapshotData.casting.resourceFinal))
	else
		currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, _currentEnergy)
		castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, snapshotData.casting.resourceFinal)
	end

	--$stagger and $staggerPercent
	local _stagger = snapshotData.attributes.stagger or 0
	local _staggerPercent = snapshotData.attributes.staggerPercent or 0

	-- Get stagger color from ColorCurve result, fallback to low color from custom bar settings
	local staggerColors = specSettings.colors and specSettings.colors.bars and specSettings.colors.bars.stagger or {}
	local staggerColor = staggerColors.low and staggerColors.low.color
	if snapshotData.attributes.staggerColor then
		local r, g, b, a = snapshotData.attributes.staggerColor:GetRGBA()
		staggerColor = TRB.Functions.Color:ConvertColorDecimalToHex(r, g, b, a)
	end

	local stagger = string.format("|c%s%s|r", staggerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_stagger))
	local staggerPercent = string.format("|c%s%.1f|r", staggerColor, _staggerPercent * 100)

	--$niuzaoTime
	local _niuzaoTime = snapshots[spells.invokeNiuzao.id].buff:GetRemainingTime(currentTime)
	local niuzaoTime = TRB.Functions.BarText:TimerPrecision(_niuzaoTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentEnergy
	lookup["$energy"] = currentEnergy
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingEnergy
	lookup["$stagger"] = stagger
	lookup["$staggerPercent"] = staggerPercent
	lookup["$niuzaoTime"] = niuzaoTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$stagger"] = _stagger
	lookupLogic["$staggerPercent"] = _staggerPercent
	lookupLogic["$niuzaoTime"] = _niuzaoTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Mistweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.mistweaver
	local sharedSettings = TRB.Data.specCache["monk_mistweaver"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentManaColor = TRB.Data.settings.monk.mistweaver.colors.text.current.color
	local castingManaColor = TRB.Data.settings.monk.mistweaver.colors.text.casting.color

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

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Windwalker()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.windwalker
	local sharedSettings = TRB.Data.specCache["monk_windwalker"].settings
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local normalizedEnergy = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

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

	--$energy
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _normalizedEnergy = normalizedEnergy
	local currentEnergy
	local castingEnergy
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", _normalizedEnergy))
		castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentEnergy = string.format("|c%s%s|r", currentEnergyColor, _normalizedEnergy)
		castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentEnergy
	lookup["$energy"] = currentEnergy
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingEnergy
	lookup["$chi"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$chiMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$chi"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$chiMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateCastingResourceFinal()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function UpdateCastingResourceFinal_Mistweaver()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
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
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.expelHarm.castId then
				local cooldown = spells.expelHarm.cooldown

				snapshotData.snapshots[spells.expelHarm.id].cooldown:InitializeCustom(cooldown, currentTime)
			elseif spellId == spells.paralysis.castId then
				local cooldown = spells.paralysis.cooldown

				if talents:IsTalentActive(spells.ancientArts) then
					cooldown = cooldown + spells.ancientArts.attributes.cooldownMod
				end

				snapshotData.snapshots[spells.paralysis.id].cooldown:InitializeCustom(cooldown, currentTime)
			elseif spellId == spells.detox.castId then -- This doesn't actually trigger a CD if it doesn't dispel anything, but we have no way of knowing that here
				local cooldown = spells.detox.cooldown

				snapshotData.snapshots[spells.detox.id].cooldown:InitializeCustom(cooldown, currentTime)
			elseif spellId == spells.invokeNiuzao.id then
				snapshotData.snapshots[spells.invokeNiuzao.id].buff:InitializeCustom(spells.invokeNiuzao.duration, currentTime)
			end
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.cracklingJadeLightning.castId then
				if talents:IsTalentActive(spells.jadeFlash) then
					local cooldown = spells.jadeFlash.cooldown

					snapshotData.snapshots[spells.cracklingJadeLightning.id].cooldown:InitializeCustom(cooldown, currentTime)
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Mistweaver()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.soothingMist.id then
				local manaCost = -spells.soothingMist:GetPrimaryResourceCost(true)

				snapshotData.casting.spellId = spells.soothingMist.id
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.resourceRaw = manaCost
				snapshotData.casting.icon = spells.soothingMist.icon
			end
			
			UpdateCastingResourceFinal_Mistweaver()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if talents:IsTalentActive(spells.vivaciousVivification) and (spellId == spells.risingSunKick.id or spellId == spells.rushingWindKick.id) then
				snapshotData.snapshots[spells.vivaciousVivification.id].buff:InitializeCustom(spells.vivaciousVivification.duration, currentTime)
			elseif spellId == spells.vivify.id then
				snapshotData.snapshots[spells.vivaciousVivification.id].buff:Reset()
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		if spellId == spells.cracklingJadeLightning.id then
			snapshotData.casting.spellId = spells.cracklingJadeLightning.id
			snapshotData.casting.startTime = currentTime
			snapshotData.casting.resourceRaw = -spells.cracklingJadeLightning:GetPrimaryResourceCost()
			snapshotData.casting.icon = spells.cracklingJadeLightning.icon
			UpdateCastingResourceFinal()
		end
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	--local currentTime = GetTime()
end

---Updates the stagger color curve based on current stagger percentage and configured thresholds
local function UpdateStaggerColor()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	-- Get configurable color curve settings from spec settings (new custom bar structure)
	local staggerBarSettings = nil
	if TRB.Data.specCache and TRB.Data.specCache.monk_brewmaster then
		local specCache = TRB.Data.specCache.monk_brewmaster
		if specCache and specCache.settings and specCache.settings.colors and specCache.settings.colors.bars then
			staggerBarSettings = specCache.settings.colors.bars.stagger
		end
	end

	if staggerBarSettings == nil then
		return
	end

	-- Use configurable settings or defaults
	local curveType = Enum.LuaCurveType.Step

	local lightThreshold = 0.0
	local lightR, lightG, lightB, lightA = 0.52, 1, 0.52, 1 -- default green for light stagger

	-- Light/Low stagger color and threshold (renamed from "light" to "low" in new structure)
	if staggerBarSettings.low then
		if staggerBarSettings.low.color then
			lightR, lightG, lightB, lightA = TRB.Functions.Color:GetRGBAFromString(staggerBarSettings.low.color, true)
		end
		if staggerBarSettings.low.threshold then
			lightThreshold = staggerBarSettings.low.threshold
		end
	elseif staggerBarSettings.light then
		-- Backwards compatibility with old structure
		if staggerBarSettings.light.color then
			lightR, lightG, lightB, lightA = TRB.Functions.Color:GetRGBAFromString(staggerBarSettings.light.color, true)
		end
		if staggerBarSettings.light.threshold then
			lightThreshold = staggerBarSettings.light.threshold
		end
	end

	local heavyR, heavyG, heavyB, heavyA = 1, 0.42, 0.42, 1 -- default red-ish for heavy stagger
	local heavyThreshold = 0.6
	-- Heavy stagger color and threshold
	if staggerBarSettings.heavy then
		if staggerBarSettings.heavy.color then
			heavyR, heavyG, heavyB, heavyA = TRB.Functions.Color:GetRGBAFromString(staggerBarSettings.heavy.color, true)
		end
		if staggerBarSettings.heavy.threshold then
			heavyThreshold = staggerBarSettings.heavy.threshold
		end
	end

	-- Extreme stagger color and threshold
	local extremeR, extremeG, extremeB, extremeA = 0.73, 0.07, 0.07, 1 -- default deep red for extreme stagger
	local extremeThreshold = 1.0
	if staggerBarSettings.extreme then
		if staggerBarSettings.extreme.color then
			extremeR, extremeG, extremeB, extremeA = TRB.Functions.Color:GetRGBAFromString(staggerBarSettings.extreme.color, true)
		end
		if staggerBarSettings.extreme.threshold then
			extremeThreshold = staggerBarSettings.extreme.threshold
		end
	end

	-- Curve type
	if staggerBarSettings.type == "linear" then
		curveType = Enum.LuaCurveType.Linear
	elseif staggerBarSettings.type == "step" then
		curveType = Enum.LuaCurveType.Step
	else
		curveType = nil
	end

	local curve = C_CurveUtil.CreateColorCurve()

	if curveType == nil then
		curve:SetType(Enum.LuaCurveType.Step)
		curve:AddPoint(0, CreateColor(lightR, lightG, lightB, lightA))
	else
		local mediumThreshold = 0.3
		local mediumR, mediumG, mediumB, mediumA = 1, 0.98, 0.72, 1 -- default yellow for medium stagger

		-- Medium stagger color and threshold
		if staggerBarSettings.medium then
			if staggerBarSettings.medium.color then
				mediumR, mediumG, mediumB, mediumA = TRB.Functions.Color:GetRGBAFromString(staggerBarSettings.medium.color, true)
			end
			if staggerBarSettings.medium.threshold then
				mediumThreshold = staggerBarSettings.medium.threshold
			end
		end

		-- Ensure thresholds are in ascending order
		if mediumThreshold >= heavyThreshold then
			mediumThreshold = heavyThreshold - 0.000001
		end

		if lightThreshold >= mediumThreshold then
			lightThreshold = mediumThreshold - 0.000001
		end

		if heavyThreshold >= extremeThreshold then
			heavyThreshold = extremeThreshold - 0.000001
		end

		curve:SetType(curveType)
		curve:AddPoint(lightThreshold, CreateColor(lightR, lightG, lightB, lightA))
		curve:AddPoint(mediumThreshold, CreateColor(mediumR, mediumG, mediumB, mediumA))
		curve:AddPoint(heavyThreshold, CreateColor(heavyR, heavyG, heavyB, heavyA))
		curve:AddPoint(extremeThreshold, CreateColor(extremeR, extremeG, extremeB, extremeA))
	end

	-- Evaluate the curve at current stagger percent
	local staggerPercent = snapshotData.attributes.staggerPercent or 0
	local staggerColor = curve:Evaluate(staggerPercent)
	snapshotData.attributes.staggerColor = staggerColor
end

local function UpdateSnapshot_Brewmaster()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local currentTime = GetTime()
	UpdateSnapshot()

	snapshotData.attributes.stagger = UnitStagger("player")

	if issecretvalue(snapshotData.attributes.stagger) then
		snapshotData.attributes.stagger = 0
	else
		snapshotData.attributes.staggerPercent = snapshotData.attributes.stagger / snapshotData.attributes.healthMax
	end
	UpdateStaggerColor()

	snapshots[spells.expelHarm.id].cooldown:GetRemainingTime(currentTime)
	snapshots[spells.detox.id].cooldown:GetRemainingTime(currentTime)
	snapshots[spells.paralysis.id].cooldown:GetRemainingTime(currentTime)
	snapshots[spells.cracklingJadeLightning.id].cooldown:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Mistweaver()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local currentTime = GetTime()
	
	snapshots[spells.vivaciousVivification.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Windwalker()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.monk
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	TRB.Functions.Bar:HideResourceBar()

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end
	
	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.brewmaster
		local specCacheSettings = TRB.Data.specCache.monk_brewmaster.settings
		UpdateSnapshot_Brewmaster()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					
					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetFrame()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
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

						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end

					local barBorderColor = specSettings.colors.bar.border.color
					local barColor = specSettings.colors.bar.base.color

					-- Invoke Niuzao bar color change
					if specSettings.colors.bar.invokeNiuzao.enabled and snapshots[spells.invokeNiuzao.id].buff.isActive then
						local niuzaoTimeLeft = snapshots[spells.invokeNiuzao.id].buff:GetRemainingTime(currentTime)
						local timeThreshold = 0
						local useEndOfNiuzaoColor = false

						if specSettings.endOf.invokeNiuzao.enabled then
							useEndOfNiuzaoColor = true
							if specSettings.endOf.invokeNiuzao.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOf.invokeNiuzao.gcdsMax
							elseif specSettings.endOf.invokeNiuzao.mode == "time" then
								timeThreshold = specSettings.endOf.invokeNiuzao.timeMax
							end
						end

						if useEndOfNiuzaoColor and niuzaoTimeLeft <= timeThreshold then
							barColor = specSettings.colors.bar.invokeNiuzaoEnd.color
						else
							barColor = specSettings.colors.bar.invokeNiuzao.color
						end
					end

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
						local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				end
			end

			if specSettings.displayBar.stagger.visibility ~= "never" then
				refreshText = true
				-- Update Stagger bar using BarNodes
				if barGroups and barGroups.stagger then
					local staggerNode = barGroups.stagger:GetNode(1)
					if staggerNode then
						-- Get stagger colors and dimensions from the new custom bar structure
						local staggerSettings = specSettings.bars and specSettings.bars.stagger or {}
						local staggerColors = specSettings.colors and specSettings.colors.bars and specSettings.colors.bars.stagger or {}
						local staggerBorder = staggerSettings.border or 2
						
						-- Get max scale (default 1.0 = 100% of max health)
						local maxScale = staggerSettings.maxScale or 1.0
						local scaledMaxHealth = snapshotData.attributes.healthMax * maxScale
						
						-- Set Stagger bar value with scaled max
						staggerNode:SetMinMax(0, scaledMaxHealth)
						staggerNode:SetValue(snapshotData.attributes.stagger)
						
						-- Calculate effective width (respects fullWidth setting and Edit Mode CDM width matching)
						local staggerWidth
						if TRB.Functions.Bar:GetMatchWidth(staggerSettings) then
							-- When matchWidth is enabled, use effectiveWidth (which accounts for CDM width matching)
							staggerWidth = (barGroups and barGroups.effectiveWidth) or specSettings.bar.width
						else
							staggerWidth = staggerSettings.width
						end
						
						local cpBackgroundColor = staggerColors.background
						if type(cpBackgroundColor) == "table" then cpBackgroundColor = cpBackgroundColor.color end
						local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(cpBackgroundColor, true)
						local cpBorderColor = staggerColors.border
						if type(cpBorderColor) == "table" then cpBorderColor = cpBorderColor.color end
						cpBorderColor = cpBorderColor

						-- Use ColorCurve for stagger bar fill color
						staggerNode:SetColorCurve(snapshotData.attributes.staggerColor)
						staggerNode:SetBorderColor(cpBorderColor)
						staggerNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)

						-- Update Stagger thresholds on the BarNode (use discrete colors, configurable positions)
						local staggerThresholds = staggerNode:GetThresholds()

						-- Medium Stagger threshold (configurable position, discrete color)
						if staggerThresholds[1] then
							local mediumThreshold = staggerColors.medium and staggerColors.medium.threshold or 0.30
							local mediumColor = staggerColors.medium and staggerColors.medium.color
							-- Hide threshold if it exceeds the bar's max scale
							local showMediumThreshold = specSettings.thresholds.stagger and specSettings.thresholds.stagger.medium and specSettings.thresholds.stagger.medium.enabled and mediumThreshold <= maxScale or false
							TRB.Functions.Color:SetThresholdColor(staggerThresholds[1], mediumColor, true)
							TRB.Functions.Threshold:RepositionThresholdCustomBar("staggerThreshold1", staggerThresholds[1], showMediumThreshold, staggerNode:GetFrame(), mediumThreshold * snapshotData.attributes.healthMax, scaledMaxHealth, staggerWidth, staggerBorder)
						end

						-- Heavy Stagger threshold (configurable position, discrete color)
						if staggerThresholds[2] then
							local heavyThreshold = staggerColors.heavy and staggerColors.heavy.threshold or 0.60
							local heavyColor = staggerColors.heavy and staggerColors.heavy.color
							-- Hide threshold if it exceeds the bar's max scale
							local showHeavyThreshold = specSettings.thresholds.stagger and specSettings.thresholds.stagger.heavy and specSettings.thresholds.stagger.heavy.enabled and heavyThreshold <= maxScale or false
							TRB.Functions.Color:SetThresholdColor(staggerThresholds[2], heavyColor, true)
							TRB.Functions.Threshold:RepositionThresholdCustomBar("staggerThreshold2", staggerThresholds[2], showHeavyThreshold, staggerNode:GetFrame(), heavyThreshold * snapshotData.attributes.healthMax, scaledMaxHealth, staggerWidth, staggerBorder)
						end

						-- Extremely Heavy Stagger threshold (configurable position, discrete color)
						if staggerThresholds[3] then
							local extremeThreshold = staggerColors.extreme and staggerColors.extreme.threshold or 1.0
							local extremeColor = staggerColors.extreme and staggerColors.extreme.color
							-- Hide threshold if it exceeds the bar's max scale
							local showExtremeThreshold = specSettings.thresholds.stagger and specSettings.thresholds.stagger.extreme and specSettings.thresholds.stagger.extreme.enabled and extremeThreshold <= maxScale or false
							TRB.Functions.Color:SetThresholdColor(staggerThresholds[3], extremeColor, true)
							TRB.Functions.Threshold:RepositionThresholdCustomBar("staggerThreshold3", staggerThresholds[3], showExtremeThreshold, staggerNode:GetFrame(), extremeThreshold * snapshotData.attributes.healthMax, scaledMaxHealth, staggerWidth, staggerBorder)
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
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.mistweaver
		local specCacheSettings = TRB.Data.specCache.monk_mistweaver.settings
		UpdateSnapshot_Mistweaver()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
				local currentResource = snapshotData.attributes.resourceModified

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

					local barColor = specSettings.colors.bar.base.color
					local barBorderColor = specSettings.colors.bar.border.color

					if specSettings.colors.bar.vivaciousVivification.enabled and affectingCombat and snapshots[spells.vivaciousVivification.id].buff.isActive then
						barColor = specSettings.colors.bar.vivaciousVivification.color
					end

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					primaryNode:SetBorderColor(barBorderColor)
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
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
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		if TRB.Data.character.maxResource2 == nil then
			return
		end
		local specSettings = classSettings.windwalker
		local specCacheSettings = TRB.Data.specCache.monk_windwalker.settings
		UpdateSnapshot_Windwalker()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetFrame()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
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
							if spell.id == spells.expelHarm.id then
								if talents:IsTalentActive(spells.combatWisdom) then
									showThreshold = false
								elseif snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specCacheSettings.colors.threshold.unusable.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
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

						if spell:Is("TRB.Classes.SpellComboPointThreshold") and
							spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true
							and snapshotData.attributes.resource2 == 0 then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						end
						
						if resourceAmount >= maxPrimaryBarResourceUnnormalized then
							showThreshold = false
						end

						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end

					local barColor = specSettings.colors.bar.base.color
					local barBorderColor = specSettings.colors.bar.border.color

					if specSettings.colors.bar.heartOfTheJadeSerpentReady.enabled and talents:IsTalentActive(spells.heartOfTheJadeSerpent) and talents:IsTalentActive(spells.strikeOfTheWindlord) and snapshots[spells.strikeOfTheWindlord.id].cooldown:IsUsable() and TRB.Data.character.inCombat then
						barBorderColor = specSettings.colors.bar.heartOfTheJadeSerpentReady.color
					elseif specSettings.colors.bar.heartOfTheJadeSerpent.enabled and snapshots[spells.heartOfTheJadeSerpent.id].buff.isActive then
						barBorderColor = specSettings.colors.bar.heartOfTheJadeSerpent.color
					elseif specSettings.colors.bar.borderChiJi.enabled and snapshots[spells.danceOfChiJi.id].buff.isActive then
						barBorderColor = specSettings.colors.bar.borderChiJi.color
					end

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
						local overcapBorderCurve = TRB.Functions.Color:BuildOvercapCurve(specCacheSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				end
			end
			
			if specSettings.displayBar.secondary.visibility ~= "never" then
				refreshText = true
				-- Update Chi using BarNodes
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border.color
					local cpColor = specSettings.colors.comboPoints.base.color
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local chiNode = barGroups.secondary:GetNode(x)
						if chiNode then
							if snapshotData.attributes.resource2 >= x then
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, chiNode, 1, 1)
								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate.color
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final.color
								end
							else
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, chiNode, 0, 1)
							end
							
							chiNode:SetBorderColor(cpBorderColor)
							chiNode:SetColor(cpColor)
							chiNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
			end
		end

		-- Chi threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			do
				local coreSettings = TRB.Data.settings.core
				local currentResource2 = snapshotData.attributes.resource2
				local threshold1 = specSettings.audio.chiThreshold1
				local threshold2 = specSettings.audio.chiThreshold2
				local threshold3 = specSettings.audio.chiThreshold3
				local threshold1Value = threshold1.configuration.thresholdValue
				local threshold2Value = threshold2.configuration.thresholdValue
				local threshold3Value = threshold3.configuration.thresholdValue

				local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.chiThreshold1Played and currentResource2 >= threshold1Value
				local threshold2ShouldFire = threshold2.enabled and not snapshotData.audio.chiThreshold2Played and currentResource2 >= threshold2Value
				local threshold3ShouldFire = threshold3.enabled and not snapshotData.audio.chiThreshold3Played and currentResource2 >= threshold3Value

				if threshold1ShouldFire or threshold2ShouldFire or threshold3ShouldFire then
					local highestValue = 0
					local highestSound = nil

					if threshold1ShouldFire then
						snapshotData.audio.chiThreshold1Played = true
						if threshold1Value > highestValue then
							highestValue = threshold1Value
							highestSound = threshold1.sound
						end
					end
					if threshold2ShouldFire then
						snapshotData.audio.chiThreshold2Played = true
						if threshold2Value > highestValue then
							highestValue = threshold2Value
							highestSound = threshold2.sound
						end
					end
					if threshold3ShouldFire then
						snapshotData.audio.chiThreshold3Played = true
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
					snapshotData.audio.chiThreshold1Played = false
				end
				if currentResource2 < threshold2Value then
					snapshotData.audio.chiThreshold2Played = false
				end
				if currentResource2 < threshold3Value then
					snapshotData.audio.chiThreshold3Played = false
				end
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
		specCache.monk_brewmaster.talents:GetTalents()
		FillSpellData_Brewmaster()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.monk_brewmaster)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Brewmaster
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.monk_brewmaster.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#niuzao"] = spells.invokeNiuzao.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "monk_brewmaster" then
			talents = specCache.monk_brewmaster.talents
			-- CRITICAL: EventRegistration must be called BEFORE ConstructResourceBar
			-- because ConstructResourceBar calls TriggerResourceBarUpdates() which needs
			-- snapshot data to be initialized.
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "monk_brewmaster"
			ConstructResourceBar(specCache.monk_brewmaster.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.monk_mistweaver.talents:GetTalents()
		FillSpellData_Mistweaver()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.monk_mistweaver)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Mistweaver
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.monk_mistweaver.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#hotjs"] = spells.heartOfTheJadeSerpent.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "monk_mistweaver" then
			talents = specCache.monk_mistweaver.talents
			-- CRITICAL: EventRegistration must be called BEFORE ConstructResourceBar
			-- because ConstructResourceBar calls TriggerResourceBarUpdates() which needs
			-- snapshot data to be initialized.
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "monk_mistweaver"
			ConstructResourceBar(specCache.monk_mistweaver.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.monk_windwalker.talents:GetTalents()
		FillSpellData_Windwalker()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.monk_windwalker)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Windwalker
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.monk_windwalker.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#blackoutKick"] = spells.blackoutKick.icon
		lookup["#cracklingJadeLightning"] = spells.cracklingJadeLightning.icon
		lookup["#cjl"] = spells.cracklingJadeLightning.icon
		lookup["#danceOfChiJi"] = spells.danceOfChiJi.icon
		lookup["#detox"] = spells.detox.icon
		lookup["#disable"] = spells.disable.icon
		lookup["#expelHarm"] = spells.expelHarm.icon
		lookup["#fistsOfFury"] = spells.fistsOfFury.icon
		lookup["#fof"] = spells.fistsOfFury.icon
		lookup["#hotjs"] = spells.heartOfTheJadeSerpent.icon
		lookup["#paralysis"] = spells.paralysis.icon
		lookup["#risingSunKick"] = spells.risingSunKick.icon
		lookup["#rsk"] = spells.risingSunKick.icon
		lookup["#spinningCraneKick"] = spells.spinningCraneKick.icon
		lookup["#sck"] = spells.spinningCraneKick.icon
		lookup["#strikeOfTheWindlord"] = spells.strikeOfTheWindlord.icon
		lookup["#tigerPalm"] = spells.tigerPalm.icon
		lookup["#vivify"] = spells.vivify.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "monk_windwalker" then
			talents = specCache.monk_windwalker.talents
			-- CRITICAL: EventRegistration must be called BEFORE ConstructResourceBar
			-- because ConstructResourceBar calls TriggerResourceBarUpdates() which needs
			-- snapshot data to be initialized.
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "monk_windwalker"
			ConstructResourceBar(specCache.monk_windwalker.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

	-- EventRegistration is now called inside each spec block before ConstructResourceBar
	-- This ensures snapshot data is populated before the bar is rendered
	if TRB.Data.barConstructedForSpec == nil then
		TRB.Functions.Class:EventRegistration()
	end

	C_Timer.After(0, function()
		C_Timer.After(0.05, function()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Data.barConstructedForSpec ~= nil then
				TRB.Functions.Character:ResetCaches()
				-- Reapply bar textures after spec switch to ensure health bar and other bar textures render correctly
				if TRB.Frames.barGroups then
					TRB.Functions.Bar:ApplyBarGroupsAppearance(specCache[TRB.Data.barConstructedForSpec].settings, TRB.Frames.barGroups)
				end
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
	
	if TRB.Data.character.classId == 10 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Monk.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.monk == nil or
						TwintopInsanityBarSettings.monk.brewmaster == nil or
						TwintopInsanityBarSettings.monk.brewmaster.displayText == nil then
						settings.monk.brewmaster.displayText.barText = TRB.Options.Monk.BrewmasterLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.monk == nil or
						TwintopInsanityBarSettings.monk.mistweaver == nil or
						TwintopInsanityBarSettings.monk.mistweaver.displayText == nil then
						settings.monk.mistweaver.displayText.barText = TRB.Options.Monk.MistweaverLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.monk == nil or
						TwintopInsanityBarSettings.monk.windwalker == nil or
						TwintopInsanityBarSettings.monk.windwalker.displayText == nil then
						settings.monk.windwalker.displayText.barText = TRB.Options.Monk.WindwalkerLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.monk ~= true then
						TRB.Data.settings.monk.brewmaster.displayText.barText = TRB.Options.Monk.BrewmasterLoadDefaultBarTextSettings()
						TRB.Data.settings.monk.mistweaver.displayText.barText = TRB.Options.Monk.MistweaverLoadDefaultBarTextSettings()
						TRB.Data.settings.monk.windwalker.displayText.barText = TRB.Options.Monk.WindwalkerLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.monk = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Monk"])
					end
				else
					local settings = TRB.Options.Monk.LoadDefaultSettings(true)
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
						TRB.Data.settings.monk.windwalker = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MonkWindwalkerFull"], TRB.Data.settings.monk.windwalker)
						TRB.Data.settings.monk.mistweaver = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MonkMistweaverFull"], TRB.Data.settings.monk.mistweaver)
						FillSpellData_Windwalker()
						FillSpellData_Mistweaver()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Monk.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "monk"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	local maxComboPoints = 0
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "brewmaster"
		TRB.Data.character.compositeKey = "monk_brewmaster"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)

		local maxComboPoints = 1
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		TRB.Data.character.specName = "mistweaver"
		TRB.Data.character.compositeKey = "monk_mistweaver"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)
		TRB.Data.character.specName = "windwalker"
		TRB.Data.character.compositeKey = "monk_windwalker"
		maxComboPoints = UnitPowerMax("player", Enum.PowerType.Chi)
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	
		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
				-- Rebuild secondary bar layout when chi count changes
				if barGroups and barGroups.secondary then
					-- Clear cached node count so ApplyBarGroupsLayout uses the new maxResource2
					barGroups.secondary.lastRebuildNodeCount = nil
					
					barGroups.secondary:SetMaxNodes(maxComboPoints)
					barGroups.secondary:SetNodeCount(maxComboPoints)
					barGroups.secondary:SetLayout(sharedSettings.comboPoints.spacing, TRB.Functions.Bar:GetMatchWidth(sharedSettings.comboPoints), "HORIZONTAL")
					
					-- Get effective width for secondary bar, accounting for CDM width matching
					local effectiveWidth, cdmForced = TRB.Functions.Bar:GetEffectiveWidthForBarGroup(barGroups, sharedSettings, "secondary")
					if cdmForced then
						barGroups.secondary.fullWidth = true
					end
					
					barGroups.secondary:ApplyLayout(
						effectiveWidth,
						sharedSettings.comboPoints.width,
						sharedSettings.comboPoints.height,
						sharedSettings.comboPoints.border
					)
					-- Apply textures and colors to any newly created nodes
					local frameLevels = TRB.Data.constants.frameLevels
					for i = 1, maxComboPoints do
						local node = barGroups.secondary:GetNode(i)
						if node then
							node:SetTextures(
								sharedSettings.textures.comboPointsBar,
								sharedSettings.textures.comboPointsBorder,
								sharedSettings.textures.comboPointsBackground
							)
							node:SetMinMax(0, 1)
							node:SetBorderColor(sharedSettings.colors.comboPoints.border.color)
							node:SetBackgroundColorFromString(sharedSettings.colors.comboPoints.background.color)
							node:SetColor(sharedSettings.colors.comboPoints.base.color)
							node:SetFrameLevel(frameLevels.comboPoint)
						end
					end
				end
			end
		end
	end	
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.monk.brewmaster then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.monk.mistweaver then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.monk.windwalker then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Chi
		TRB.Data.resource2Factor = 1
	else
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

			-- Determine stagger bar visibility (Brewmaster only)
			local showStagger = false
			if not forceHideAll and TRB.Data.character.specId == 1 then
				local staggerVisibility = sharedSettings.displayBar.stagger.visibility
				if staggerVisibility == "always" then
					showStagger = true
				elseif staggerVisibility == "combat" then
					showStagger = affectingCombat or inVehicle
				end
				-- "never" means showStagger stays false
			end

			-- Determine secondary bar visibility (Windwalker Chi only)
			local showSecondary = false
			if not forceHideAll and TRB.Data.character.specId == 3 then
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

			-- Apply stagger bar visibility (Brewmaster only)
			if barGroups and barGroups.stagger then
				if showStagger then
					barGroups.stagger:Show()
					barGroups.stagger:ShowNodes(1)
				else
					barGroups.stagger:Hide()
				end
			end

			-- Apply secondary bar visibility (Windwalker Chi)
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

			-- Track if any bar is showing
			snapshotData.attributes.isTracking = showPrimary or showStagger or showSecondary or showHealth
			if snapshotData.attributes.isTracking then
				TRB.Functions.BarText:Show(sharedSettings)
			else
				TRB.Functions.BarText:Hide(sharedSettings)
			end
		else
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.stagger then
				barGroups.stagger:Hide()
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
		if barGroups and barGroups.stagger then
			barGroups.stagger:Hide()
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
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spells
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
		settings = TRB.Data.settings.monk.brewmaster
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		settings = TRB.Data.settings.monk.mistweaver
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		settings = TRB.Data.settings.monk.windwalker
	else
		return false
	end

	if TRB.Data.character.specId == 1 then -- Brewmaster
		if var == "$resource" or var == "$energy" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$stagger" then
			if snapshotData.attributes.stagger ~= nil and snapshotData.attributes.stagger > 0 then
				valid = true
			end
		elseif var == "$staggerPercent" then
			if snapshotData.attributes.staggerPercent ~= nil and snapshotData.attributes.staggerPercent > 0 then
				valid = true
			end
		elseif var == "$niuzaoTime" then
			if snapshots[spells.invokeNiuzao.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 2 then --Mistweaver
		if var == "$resource" or var == "$mana" then
			valid = false
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then --Windwalker
		if var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$resource" or var == "$energy" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$comboPoints" or var == "$chi" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$chiMax" then
			valid = true
		end
	end

	-- Health variables - valid for all specs
	if var == "$health" or var == "$healthMax" or var == "$healthPercent" then
		valid = true
	end

	-- Mistweaver or Windwalker / Conduit of the Celestials shared abilities
	if TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
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
	elseif normalizedRelativeFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif normalizedRelativeFrame == "StaggerBar" then
		-- Brewmaster Stagger bar
		if barGroups and barGroups.stagger then
			local staggerNode = barGroups.stagger:GetNode(1)
			if staggerNode then
				local isVisible = barGroups.stagger.isVisible and staggerNode.isVisible
				return staggerNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	-- Handle secondary resources (Chi for Windwalker, also supports Stagger for Brewmaster via ComboPoint1)
	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint then
			-- For Brewmaster, ComboPoint1 refers to the Stagger bar
			if TRB.Data.character.specId == 1 and barGroups.stagger then
				local staggerNode = barGroups.stagger:GetNode(comboPoint)
				if staggerNode then
					local isVisible = barGroups.stagger.isVisible and staggerNode.isVisible
					return staggerNode:GetFrame(), true, isVisible
				end
			-- For Windwalker, ComboPointN refers to Chi
			elseif barGroups.secondary then
				local cpNode = barGroups.secondary:GetNode(comboPoint)
				if cpNode then
					local isVisible = barGroups.secondary.isVisible and cpNode.isVisible
					return cpNode:GetFrame(), true, isVisible
				end
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

---Recreates thresholds when re-enabling a previously disabled spec
---Monk override: handles primary bar + Brewmaster stagger bar thresholds
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Class:RecreateThresholds(settings, barGroups)
	-- Primary bar thresholds
	if barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local existingThresholds = primaryNode:GetThresholds()
			local thresholdSpells = TRB.Data.cache.thresholdSpells
			if thresholdSpells and #thresholdSpells > 0 and (not existingThresholds or #existingThresholds ~= #thresholdSpells) then
				primaryNode:ClearThresholds()
				for _ = 1, #thresholdSpells do
					local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetFrame())
					TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
					primaryNode:RegisterThreshold(thresholdFrame)
				end
			end
		end
	end

	-- Brewmaster: Stagger bar thresholds (Medium, Heavy, Extreme)
	if TRB.Data.character.specId == 1 and barGroups.stagger then
		local staggerNode = barGroups.stagger:GetNode(1)
		if staggerNode then
			local existingThresholds = staggerNode:GetThresholds()
			if not existingThresholds or #existingThresholds ~= 3 then
				staggerNode:ClearThresholds()
				local staggerSettings = settings.bars and settings.bars["stagger"]
				local staggerColors = settings.colors and settings.colors.bars and settings.colors.bars.stagger
				local thresholdWidth = settings.thresholds and settings.thresholds.properties and settings.thresholds.properties.width or 2
				local thresholdHeight = staggerSettings and staggerSettings.height or 24
				local borderColor = staggerColors and staggerColors.border and staggerColors.border.color
				
				for _ = 1, 3 do
					local thresholdFrame = CreateFrame("Frame", nil, staggerNode:GetFrame())
					TRB.Functions.Threshold:ResetThresholdLineCustomBar(thresholdFrame, thresholdWidth, thresholdHeight, borderColor)
					staggerNode:RegisterThreshold(thresholdFrame)
				end
			end
		end
	end
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