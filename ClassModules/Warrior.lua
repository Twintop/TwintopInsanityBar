local _, TRB = ...
if TRB.Data.character.classId ~= 1 then --Only do this if we're on a Warrior!
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
	warrior_arms = TRB.Classes.SpecCache:New(),
	warrior_fury = TRB.Classes.SpecCache:New(),
	warrior_protection = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Arms
	specCache.warrior_arms.Global_TwintopResourceBar = {
		resource = {
			resource = 0
		}
	}

	specCache.warrior_arms.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		effects = {
		},
		pandemicModifier = 0
	}

	---@type TRB.Classes.Warrior.ArmsSpells
	specCache.warrior_arms.spellsData.spells = TRB.Classes.Warrior.ArmsSpells:New()
	local spells = specCache.warrior_arms.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]

	specCache.warrior_arms.snapshotData.audio = {
	}
	--[[---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.execute.id] = TRB.Classes.Snapshot:New(spells.execute)]]
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.shieldBlock.id] = TRB.Classes.Snapshot:New(spells.shieldBlock)
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.impendingVictory.id] = TRB.Classes.Snapshot:New(spells.impendingVictory)
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.thunderClap.id] = TRB.Classes.Snapshot:New(spells.thunderClap)
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.mortalStrike.id] = TRB.Classes.Snapshot:New(spells.mortalStrike)
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.cleave.id] = TRB.Classes.Snapshot:New(spells.cleave)
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.ignorePain.id] = TRB.Classes.Snapshot:New(spells.ignorePain)
	--[[---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.suddenDeath.id] = TRB.Classes.Snapshot:New(spells.suddenDeath)
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.stormOfSwords.id] = TRB.Classes.Snapshot:New(spells.stormOfSwords)
	---@type TRB.Classes.Snapshot
	specCache.warrior_arms.snapshotData.snapshots[spells.ravager.id] = TRB.Classes.Snapshot:New(spells.ravager)]]

	-- Fury

	specCache.warrior_fury.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			ravager = 0
		},
		ravager = {
			rage = 0,
			ticks = 0
		}
	}

	specCache.warrior_fury.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		}
	}

	---@type TRB.Classes.Warrior.FurySpells
	specCache.warrior_fury.spellsData.spells = TRB.Classes.Warrior.FurySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.warrior_fury.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]

	specCache.warrior_fury.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.warrior_fury.snapshotData.snapshots[spells.shieldBlock.id] = TRB.Classes.Snapshot:New(spells.shieldBlock)
	---@type TRB.Classes.Snapshot
	specCache.warrior_fury.snapshotData.snapshots[spells.thunderClap.id] = TRB.Classes.Snapshot:New(spells.thunderClap)
	---@type TRB.Classes.Snapshot
	specCache.warrior_fury.snapshotData.snapshots[spells.impendingVictory.id] = TRB.Classes.Snapshot:New(spells.impendingVictory)
	---@type TRB.Classes.Snapshot
	specCache.warrior_fury.snapshotData.snapshots[spells.improvedWhirlwind.id] = TRB.Classes.Snapshot:New(spells.improvedWhirlwind)
	---@type TRB.Classes.Snapshot
	specCache.warrior_fury.snapshotData.snapshots[spells.bladestorm.id] = TRB.Classes.Snapshot:New(spells.bladestorm)
	---@type TRB.Classes.Snapshot
	specCache.warrior_fury.snapshotData.snapshots[spells.execute.id] = TRB.Classes.Snapshot:New(spells.execute)
	---@type TRB.Classes.Snapshot
	specCache.warrior_fury.snapshotData.snapshots[spells.suddenDeath.id] = TRB.Classes.Snapshot:New(spells.suddenDeath)

	-- Protection
	specCache.warrior_protection.Global_TwintopResourceBar = {
		resource = {
			resource = 0
		}
	}

	specCache.warrior_protection.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		effects = {
		},
		pandemicModifier = 0
	}

	---@type TRB.Classes.Warrior.ProtectionSpells
	specCache.warrior_protection.spellsData.spells = TRB.Classes.Warrior.ProtectionSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.warrior_protection.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]

	specCache.warrior_protection.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.warrior_protection.snapshotData.snapshots[spells.impendingVictory.id] = TRB.Classes.Snapshot:New(spells.impendingVictory)
	---@type TRB.Classes.Snapshot
	specCache.warrior_protection.snapshotData.snapshots[spells.ignorePain.id] = TRB.Classes.Snapshot:New(spells.ignorePain)
	--[[---@type TRB.Classes.Snapshot
	specCache.warrior_protection.snapshotData.snapshots[spells.ravager.id] = TRB.Classes.Snapshot:New(spells.ravager)]]
	---@type TRB.Classes.Snapshot
	specCache.warrior_protection.snapshotData.snapshots[spells.shieldBlock.id] = TRB.Classes.Snapshot:New(spells.shieldBlock)
	--[[---@type TRB.Classes.Snapshot
	specCache.warrior_protection.snapshotData.snapshots[spells.shieldBlock.buffId] = TRB.Classes.Snapshot:New(spells.shieldBlock)]]
	---@type TRB.Classes.Snapshot
	specCache.warrior_protection.snapshotData.snapshots[spells.suddenDeath.id] = TRB.Classes.Snapshot:New(spells.suddenDeath)
end

local function Setup_Arms()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "arms")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warrior_arms" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Arms()
	Setup_Arms()
	specCache.warrior_arms.spellsData:FillSpellData()
	local spells = specCache.warrior_arms.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]

	TRB.Classes.Warrior.ArmsSpells.FillBarTextVariables(specCache.warrior_arms)
end

local function Setup_Fury()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "fury")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warrior_fury" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Fury()
	Setup_Fury()
	specCache.warrior_fury.spellsData:FillSpellData()
	local spells = specCache.warrior_fury.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]

	TRB.Classes.Warrior.FurySpells.FillBarTextVariables(specCache.warrior_fury)
end

local function Setup_Protection()
	TRB.Functions.Character:FillSpecializationCacheSettings("warrior", "protection", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warrior_protection" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Protection()
	Setup_Protection()
	specCache.warrior_protection.spellsData:FillSpellData()
	local spells = specCache.warrior_protection.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]

	TRB.Classes.Warrior.ProtectionSpells.FillBarTextVariables(specCache.warrior_protection)
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 then
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
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

	if TRB.Data.character.specId == 1 then
		-- Arms: No secondary bar
		if barGroups and barGroups.defensives then
			barGroups.defensives:Hide()
		end
		TRB.Functions.Aura:DisableUnitAuraCache()
	elseif TRB.Data.character.specId == 2 then
		-- Fury: Whirlwind stacks bar (nodes based on talent)
		if barGroups and barGroups.defensives then
			barGroups.defensives:Hide()
		end
		if barGroups and barGroups.secondary then
			local maxWhirlwindNodes = TRB.Data.character.maxResource2 or 0

			if maxWhirlwindNodes == 0 then
				barGroups.secondary:Hide()
			else
				barGroups.secondary:SetMaxNodes(maxWhirlwindNodes)
				barGroups.secondary:SetNodeCount(maxWhirlwindNodes)
				barGroups.secondary:SetLayout(settings.comboPoints.spacing, TRB.Functions.Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
				barGroups.secondary:Show()

				local effectiveWidth, cdmForced = TRB.Functions.Bar:GetEffectiveWidthForBarGroup(barGroups, settings, "secondary")
				if cdmForced then
					barGroups.secondary.fullWidth = true
				end

				barGroups.secondary:ApplyLayout(
					effectiveWidth,
					settings.comboPoints.width,
					settings.comboPoints.height,
					settings.comboPoints.border
				)

				local frameLevels = TRB.Data.constants.frameLevels
				for x = 1, maxWhirlwindNodes do
					local wwNode = barGroups.secondary:GetNode(x)
					if wwNode then
						wwNode:SetTextures(
							settings.textures.comboPointsBar,
							settings.textures.comboPointsBorder,
							settings.textures.comboPointsBackground
						)
						wwNode:SetMinMax(0, 1)
						wwNode:SetBorderColor(settings.colors.comboPoints.border.color)
						wwNode:SetBackgroundColorFromString(settings.colors.comboPoints.background.color)
						wwNode:SetColor(settings.colors.comboPoints.base.color)
						wwNode:SetFrameLevel(frameLevels.comboPoint)
					end
				end
			end
		end
		TRB.Functions.Aura:DisableUnitAuraCache()
	elseif TRB.Data.character.specId == 3 then
		-- Protection: Show secondary bar for defensive buffs (Shield Block + Ignore Pain)
		if barGroups and barGroups.defensives then
			local maxDefensiveBuffs = TRB.Data.character.maxResource2 or 2
			barGroups.defensives:Show()
			barGroups.defensives:ShowNodes(maxDefensiveBuffs)
			for x = 1, maxDefensiveBuffs do
				local defensiveNode = barGroups.defensives:GetNode(x)
				if defensiveNode then
					defensiveNode:SetMinMax(0, 1)
				end
			end
		end
		TRB.Functions.Aura:EnableUnitAuraCache()
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Arms()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.arms
	local sharedSettings = TRB.Data.specCache["warrior_arms"].settings
	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local _
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local currentTime = GetTime()

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
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
				currentRageColor = sharedSettings.colors.text.overThreshold.color
				castingRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingRageColor = sharedSettings.colors.text.spending.color
	end

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage
	local castingRage
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentRage = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentRage))
		castingRage = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)
		castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end
	
	--------------
	---
	local lookup = TRB.Data.lookup or {}
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$casting"] = castingRage
	TRB.Data.lookup = lookup
	
	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Fury()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.fury
	local sharedSettings = TRB.Data.specCache["warrior_fury"].settings
	local _
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local currentTime = GetTime()

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
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
				currentRageColor = sharedSettings.colors.text.overThreshold.color
				castingRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingRageColor = sharedSettings.colors.text.spending.color
	end

	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage
	local castingRage
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentRage = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentRage))
		castingRage = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)
		castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end
	
	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$casting"] = castingRage
	
	-- Whirlwind stacks & time
	local wwSnapshot = snapshots[spells.improvedWhirlwind.id]
	local wwCharges = 0
	local wwTime = 0
	if wwSnapshot and wwSnapshot.buff then
		wwCharges = wwSnapshot.buff.applications or 0
		wwTime = wwSnapshot.buff.remaining or 0
	end

	lookup["$wwCharges"] = string.format("%s", wwCharges)
	lookup["$whirlwindCharges"] = lookup["$wwCharges"]
	lookup["$wwTime"] = string.format("%.1f", wwTime)
	lookup["$whirlwindTime"] = lookup["$wwTime"]

	TRB.Data.lookup = lookup


	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$wwCharges"] = wwCharges
	lookupLogic["$whirlwindCharges"] = wwCharges
	lookupLogic["$wwTime"] = wwTime
	lookupLogic["$whirlwindTime"] = wwTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Protection()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.protection
	local sharedSettings = TRB.Data.specCache["warrior_protection"].settings
	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local _
	local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
	local currentTime = GetTime()

	local currentRageColor = sharedSettings.colors.text.current.color
	local castingRageColor = sharedSettings.colors.text.casting.color
	
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
				currentRageColor = sharedSettings.colors.text.overThreshold.color
				castingRageColor = sharedSettings.colors.text.overThreshold.color
			end
		end
	end
	
	--$rage
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _currentRage = normalizedRage
	local currentRage
	local castingRage
	-- Apply overcap color if enabled (takes precedence over overThreshold)
	if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
		local overcapTextCurve = TRB.Functions.Color:BuildOvercapCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
		local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
		currentRage = textColorResult:WrapTextInColorCode(string.format("%.0f", _currentRage))
		castingRage = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
	else
		currentRage = string.format("|c%s%s|r", currentRageColor, _currentRage)
		castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
	end
		
	--$ignorePainAbsorb
	local _ignorePainAbsorb = snapshots[spells.ignorePain.id].buff.customProperties["absorb"] or 0
	local ignorePainAbsorb = TRB.Functions.String:ConvertToAbbreviatedNumber(_ignorePainAbsorb)

	--$ignorePainTime
	local _ignorePainTime = snapshots[spells.ignorePain.id].buff:GetRemainingTime(currentTime)
	local ignorePainTime = TRB.Functions.BarText:TimerPrecision(_ignorePainTime)

	--$shieldBlockTime
	local _shieldBlockTime = snapshots[spells.shieldBlock.id].buff:GetRemainingTime(currentTime)
	local shieldBlockTime = TRB.Functions.BarText:TimerPrecision(_shieldBlockTime)
	
	--$shieldBlockCharges
	local shieldBlockCharges = snapshots[spells.shieldBlock.id].cooldown.charges or 0
	
	--$shieldBlockMaxCharges
	local shieldBlockMaxCharges = snapshots[spells.shieldBlock.id].cooldown.maxCharges or 0

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentRage
	lookup["$rage"] = currentRage
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$rageMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingRage
	lookup["$ignorePainTime"] = ignorePainTime
	lookup["$ignorePainAbsorb"] = ignorePainAbsorb
	lookup["$shieldBlockTime"] = shieldBlockTime
	lookup["$shieldBlockCharges"] = shieldBlockCharges
	lookup["$shieldBlockMaxCharges"] = shieldBlockMaxCharges
	TRB.Data.lookup = lookup
	
	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedRage
	lookupLogic["$rage"] = normalizedRage
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$rageMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$ignorePainTime"] = _ignorePainTime
	lookupLogic["$ignorePainAbsorb"] = true
	lookupLogic["$shieldBlockTime"] = _shieldBlockTime
	lookupLogic["$shieldBlockCharges"] = shieldBlockCharges
	lookupLogic["$shieldBlockMaxCharges"] = shieldBlockMaxCharges
	TRB.Data.lookupLogic = lookupLogic
end


---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId, ...)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()

	if TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
		local snapshots = snapshotData.snapshots
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if talents:IsTalentActive(spells.improvedWhirlwind) then
				if spellId == spells.bladestorm.id and talents:IsTalentActive(spells.unhinged) then
					local duration = spells.bladestorm.duration / (1 + (snapshotData.attributes.haste / 100))
					snapshots[spells.bladestorm.id].buff:InitializeCustom(duration, currentTime)
				elseif spells.improvedWhirlwind.attributes.builderIds[spellId] or (spells.crashingThunder.attributes.builderIds[spellId] and talents:IsTalentActive(spells.crashingThunder)) then
					snapshots[spells.improvedWhirlwind.id].buff:InitializeCustom(spells.improvedWhirlwind.duration, currentTime, true, spells.improvedWhirlwind.maxStacks)
				elseif spells.improvedWhirlwind.attributes.spenderIds[spellId] and snapshots[spells.improvedWhirlwind.id].buff.applications > 0 then
					if not talents:IsTalentActive(spells.unhinged) then
						snapshots[spells.improvedWhirlwind.id].buff:RemoveStack()
					else
						snapshots[spells.bladestorm.id].buff:GetRemainingTime(currentTime) -- Force a refresh since this event is likely happening on a frame where we aren't in the main update loop
						if not snapshots[spells.bladestorm.id].buff.isActive then
							snapshots[spells.improvedWhirlwind.id].buff:RemoveStack()
						end
					end
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.shieldBlock.castId then
				local duration = spells.shieldBlock.duration + (spells.enduringDefenses.attributes.durationModPerRank * talents.talents[spells.enduringDefenses.id].currentRank)
				snapshotData.snapshots[spells.shieldBlock.id].buff:AddTimeOrInitializeCustom(duration, currentTime)
			elseif spellId == spells.shieldCharge.id then -- Button press
				snapshotData.snapshots[spells.shieldBlock.id].buff.attributes.shieldChargeUsed = true
				C_Timer.After(0, function()
					C_Timer.After((1 + (TRB.Data.character.latency * 2)), function()
						if snapshotData.snapshots[spells.shieldBlock.id].buff.attributes.shieldChargeUsed then
							local duration = spells.shieldBlock.duration + (spells.enduringDefenses.attributes.durationModPerRank * talents.talents[spells.enduringDefenses.id].currentRank)
							snapshotData.snapshots[spells.shieldBlock.id].buff:AddTimeOrInitializeCustom(duration, currentTime)
							snapshotData.snapshots[spells.shieldBlock.id].buff.attributes.shieldChargeUsed = false
						end
					end)
				end)
			elseif spellId == spells.shieldCharge.castId then -- Stun
				local duration = spells.shieldBlock.duration + (spells.enduringDefenses.attributes.durationModPerRank * talents.talents[spells.enduringDefenses.id].currentRank)
				snapshotData.snapshots[spells.shieldBlock.id].buff:AddTimeOrInitializeCustom(duration, currentTime)
				snapshotData.snapshots[spells.shieldBlock.id].buff.attributes.shieldChargeUsed = false
			elseif spellId == spells.ignorePain.castId then
				snapshotData.snapshots[spells.ignorePain.id].buff:InitializeCustom(spells.ignorePain.duration, currentTime, nil, nil, true)
				local bufferEntry = TRB.Functions.Aura:GetFromAuraCacheBuffer(currentTime)
				if bufferEntry ~= nil then
					snapshotData.snapshots[spells.ignorePain.id].buff:SetAuraInstanceId(bufferEntry)
				else
					TRB.Functions.Aura:InsertAuraRequest(currentTime, snapshotData.snapshots[spells.ignorePain.id].buff)
				end
			elseif spellId == spells.shieldSlam.id then
				if talents:IsTalentActive(spells.heavyRepercussions) and snapshotData.snapshots[spells.shieldBlock.id].buff.isActive then
					local duration = spells.heavyRepercussions.attributes.durationMod
					snapshotData.snapshots[spells.shieldBlock.id].buff:AddTimeOrInitializeCustom(duration, currentTime)
				end
			end
		end
	end
end

local function UpdateSnapshot()
	local currentTime = GetTime()
	TRB.Functions.Character:UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells|TRB.Classes.Warrior.FurySpells|TRB.Classes.Warrior.ProtectionSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	--[[snapshots[spells.impendingVictory.id].cooldown:Refresh()]]
	snapshots[spells.shieldBlock.id].cooldown:Refresh()
	--[[snapshots[spells.thunderClap.id].cooldown:Refresh()
	snapshots[spells.suddenDeath.id].buff:GetRemainingTime(currentTime)]]
end

local function UpdateSnapshot_DPS()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells|TRB.Classes.Warrior.FurySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--snapshots[spells.thunderClap.id].cooldown:Refresh()
end

local function UpdateSnapshot_Arms()
	local currentTime = GetTime()
	UpdateSnapshot_DPS()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--[[snapshots[spells.mortalStrike.id].cooldown:Refresh()
	snapshots[spells.cleave.id].cooldown:Refresh()
	snapshots[spells.ignorePain.id].cooldown:Refresh()]]
end

local function UpdateSnapshot_Fury()
	local currentTime = GetTime()
	UpdateSnapshot_DPS()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.improvedWhirlwind.id].buff:GetRemainingTime(currentTime)
	--[[snapshots[spells.bladestorm.id].buff:UpdateTicks(currentTime)
	snapshots[spells.execute.id].cooldown:Refresh()]]
end

local function UpdateSnapshot_Protection()
	local currentTime = GetTime()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.ignorePain.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.shieldBlock.id].buff:GetRemainingTime(currentTime)
	--[[
	snapshots[spells.whirlwind.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.bladestorm.id].buff:UpdateTicks(currentTime)

	snapshots[spells.execute.id].cooldown:Refresh()
	]]
end

---Updates the defensive buff secondary bar nodes for Protection
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateDefensiveBuffs(specSettings, specCacheSettings)
	local currentTime = GetTime()
	-- Handle both raw string and { color = "..." } object formats
	local bgColor = specSettings.colors.bars.defensives.background
	if type(bgColor) == "table" then bgColor = bgColor.color end
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(bgColor, true)
	local cpBorderColor = specSettings.colors.bars.defensives.border
	if type(cpBorderColor) == "table" then cpBorderColor = cpBorderColor.color end

	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	
	local currentDefensiveBar = 1
	
	-- Defensive buff config: { spell, colorKey }
	local defensiveBuffs = {
		{ spell = spells.ignorePain, colorKey = "ignorePain" },
		{ spell = spells.shieldBlock, colorKey = "shieldBlock" }
	}
	
	for _, buffConfig in ipairs(defensiveBuffs) do
		local spell = buffConfig.spell
		local colorKey = buffConfig.colorKey
		local defensiveBarEnabled = specSettings.colors.bars.defensives.nodeColors[colorKey] and specSettings.colors.bars.defensives.nodeColors[colorKey].enabled
		
		if talents:IsTalentActive(spell) and defensiveBarEnabled then
			local cpColor = specSettings.colors.bars.defensives.nodeColors[colorKey].color
			local buff = snapshots[spell.id].buff
			
			local cpTime = 0
			local cpDuration = 1
			
			if buff.isActive then
				cpTime = buff:GetRemainingTime(currentTime)
				cpDuration = buff.duration
			end
			
			if cpTime < 0 then
				cpTime = 0
			end
			
			if cpTime == math.huge or cpDuration == math.huge then
				cpTime = 0
				cpDuration = 1
			end
			
			if barGroups and barGroups.defensives then
				local defensiveNode = barGroups.defensives:GetNode(currentDefensiveBar)
				if defensiveNode then
					TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. currentDefensiveBar, defensiveNode, cpTime, cpDuration)
					defensiveNode:SetBorderColor(cpBorderColor)
					defensiveNode:SetColor(cpColor)
					defensiveNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
				end
			end
			
			currentDefensiveBar = currentDefensiveBar + 1
		end
	end
end

---Updates the Whirlwind stacks bar for Fury
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
local function UpdateWhirlwindCharges(specSettings, specCacheSettings)
	local currentTime = GetTime()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if not (barGroups and barGroups.secondary) then
		return
	end

	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
	local wwBuff = snapshots[spells.improvedWhirlwind.id] and snapshots[spells.improvedWhirlwind.id].buff
	wwBuff:GetRemainingTime(currentTime) -- Force a refresh since this event is likely happening on a frame where we aren't in the main update loop
	local stacks = (wwBuff and wwBuff.isActive and wwBuff.applications) or 0
	if stacks < 0 then stacks = 0 end
	if stacks > 4 then stacks = 4 end

	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
	for x = 1, 4 do
		local cpBorderColor = specSettings.colors.comboPoints.border.color
		local cpColor = specSettings.colors.comboPoints.base.color
		local filled = stacks >= x

		if filled then
			if (specSettings.comboPoints.sameColor and stacks == 3) or (not specSettings.comboPoints.sameColor and x == 3) then
				cpColor = specSettings.colors.comboPoints.penultimate.color
			elseif (specSettings.comboPoints.sameColor and stacks == 4) or x == 4 then
				cpColor = specSettings.colors.comboPoints.final.color
			end
		end

		local node = barGroups.secondary:GetNode(x)
		if node then
			TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, node, filled and 1 or 0, 1)
			node:SetBorderColor(cpBorderColor)
			node:SetColor(cpColor)
			node:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
		end
	end
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.warrior
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
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

	local primaryResourceFrame = primaryNode:GetFrame()

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.arms
		local specCacheSettings = TRB.Data.specCache.warrior_arms.settings
		UpdateSnapshot_Arms()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				
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

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.executeMinimum.id then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								showThreshold = false
							end
						elseif spell.id == spells.whirlwind.id then
							if talents:IsTalentActive(spells.cleave) then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						elseif spell.id == spells.cleave.id then
							if not talents:IsTalentActive(spells.cleave) then
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

					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

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
				TRB.Functions.Bar:UpdateHealthBarAbsorbOverlay(healthNode, snapshotData, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.fury
		local specCacheSettings = TRB.Data.specCache.warrior_fury.settings
		UpdateSnapshot_Fury()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

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
					
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.execute.id then
							if talents:IsTalentActive(spells.improvedExecute) then
								showThreshold = false
							else
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
						elseif spell.id == spells.thunderClap.id then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif talents:IsTalentActive(spells.crashingThunder) then
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
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base.color

				local barBorderColor = specSettings.colors.bar.border.color

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
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			-- Whirlwind stacks bar (only when Improved Whirlwind is talented, i.e. maxResource2 > 0)
			if specSettings.displayBar.secondary.visibility ~= "never" and (TRB.Data.character.maxResource2 or 0) > 0 then
				refreshText = true
				UpdateWhirlwindCharges(specSettings, specCacheSettings)
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
				TRB.Functions.Bar:UpdateHealthBarAbsorbOverlay(healthNode, snapshotData, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.protection
		local specCacheSettings = TRB.Data.specCache.warrior_protection.settings
		UpdateSnapshot_Protection()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

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
					if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.executeMinimum.id then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								showThreshold = false
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end
					elseif resourceAmount == 0 then
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

					local thresholdFrame = thresholds[thresholdId]
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholdFrame, showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholdFrame, showThreshold and isDrawn, primaryResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
				end
				
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

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
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if specSettings.displayBar.defensives.visibility ~= "never" then
			refreshText = true
				UpdateDefensiveBuffs(specSettings, specCacheSettings)
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
				TRB.Functions.Bar:UpdateHealthBarAbsorbOverlay(healthNode, snapshotData, specCacheSettings)
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
		specCache.warrior_arms.talents:GetTalents()
		FillSpellData_Arms()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.warrior_arms)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Arms
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.warrior_arms.settings)
		
		local lookup = TRB.Data.lookup or {}
		lookup["#cleave"] = spells.cleave.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#mortalStrike"] = spells.mortalStrike.icon
		lookup["#rend"] = spells.rend.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#whirlwind"] = spells.whirlwind.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "warrior_arms" then
			talents = specCache.warrior_arms.talents
			TRB.Data.barConstructedForSpec = "warrior_arms"
			ConstructResourceBar(specCache.warrior_arms.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.warrior_fury.talents:GetTalents()
		FillSpellData_Fury()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.warrior_fury)
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Fury
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.warrior_fury.settings)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
		local lookup = TRB.Data.lookup or {}
		lookup["#bladestorm"] = spells.bladestorm.icon
		lookup["#execute"] = spells.execute.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon
		lookup["#whirlwind"] = spells.improvedWhirlwind.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "warrior_fury" then
			talents = specCache.warrior_fury.talents
			TRB.Data.barConstructedForSpec = "warrior_fury"
			ConstructResourceBar(specCache.warrior_fury.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.warrior_protection.talents:GetTalents()
		FillSpellData_Protection()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.warrior_protection)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Protection
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.warrior_protection.settings)
		
		local lookup = TRB.Data.lookup or {}
		lookup["#ignorePain"] = spells.ignorePain.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "warrior_protection" then
			talents = specCache.warrior_protection.talents
			TRB.Data.barConstructedForSpec = "warrior_protection"
			ConstructResourceBar(specCache.warrior_protection.settings)
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
	
	if TRB.Data.character.classId == 1 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Warrior.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.arms == nil or
						TwintopInsanityBarSettings.warrior.arms.displayText == nil then
						settings.warrior.arms.displayText.barText = TRB.Options.Warrior.ArmsLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.fury == nil or
						TwintopInsanityBarSettings.warrior.fury.displayText == nil then
						settings.warrior.fury.displayText.barText = TRB.Options.Warrior.FuryLoadDefaultBarTextSettings()
					end

					if  TwintopInsanityBarSettings.warrior == nil or
						TwintopInsanityBarSettings.warrior.protection == nil or
						TwintopInsanityBarSettings.warrior.protection.displayText == nil then
						settings.warrior.protection.displayText.barText = TRB.Options.Warrior.ProtectionLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.warrior ~= true then
						TRB.Data.settings.warrior.arms.displayText.barText = TRB.Options.Warrior.ArmsLoadDefaultBarTextSettings()
						TRB.Data.settings.warrior.fury.displayText.barText = TRB.Options.Warrior.FuryLoadDefaultBarTextSettings()
						TRB.Data.settings.warrior.protection.displayText.barText = TRB.Options.Warrior.ProtectionLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.warrior = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Warrior"])
					end

					-- Seed Whirlwind charge bar text entries for existing users
					if TRB.Data.settings.warrior.fury.displayText.migrations == nil then
						TRB.Data.settings.warrior.fury.displayText.migrations = {}
					end

					if not TRB.Data.settings.warrior.fury.displayText.migrations.whirlwindBarTextSeeded then
						local whirlwindBarTextEntries = TRB.Options.Warrior.FuryLoadWhirlwindBarTextSettings()
						for _, entry in ipairs(whirlwindBarTextEntries) do
							table.insert(TRB.Data.settings.warrior.fury.displayText.barText, entry)
						end
						TRB.Data.settings.warrior.fury.displayText.migrations.whirlwindBarTextSeeded = true
					end
				else
					local settings = TRB.Options.Warrior.LoadDefaultSettings(true)
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
						TRB.Data.settings.warrior.arms = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarriorArmsFull"], TRB.Data.settings.warrior.arms)
						TRB.Data.settings.warrior.fury = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarriorFuryFull"], TRB.Data.settings.warrior.fury)
						TRB.Data.settings.warrior.protection = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarriorProtectionFull"], TRB.Data.settings.warrior.protection)
						
						FillSpellData_Arms()
						FillSpellData_Fury()
						FillSpellData_Protection()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Warrior.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "warrior"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Rage, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Rage, false)

	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
		TRB.Data.character.specName = "arms"
		TRB.Data.character.compositeKey = "warrior_arms"

		--[[if talents:IsTalentActive(spells.bloodletting) then
			TRB.Data.character.pandemicModifier = spells.bloodletting.attributes.pandemicModifier
		end]]
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "fury"
		TRB.Data.character.compositeKey = "warrior_fury"

		local furySpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
		local furyTalents = TRB.Data.specCache.warrior_fury and TRB.Data.specCache.warrior_fury.talents
		local whirlwindCharges = 0
		if furyTalents and furyTalents:IsTalentActive(furySpells.improvedWhirlwind) then
			whirlwindCharges = 4
		end

		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		if sharedSettings ~= nil then
			if whirlwindCharges ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = whirlwindCharges
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "protection"
		TRB.Data.character.compositeKey = "warrior_protection"
		local maxComboPoints = 2 -- Shield Block and Ignore Pain
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.warrior.arms == true then
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.warrior.fury == true then
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.warrior.protection == true then
		TRB.Data.resource = Enum.PowerType.Rage
		TRB.Data.resourceFactor = 10
		TRB.Data.specSupported = true
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

			-- Determine secondary bar visibility independently
			-- Protection (specId == 3) uses defensives; Fury (specId == 2) uses whirlwind
			local showSecondary = false
			if not forceHideAll and TRB.Data.character.specId == 3 then
				if sharedSettings.displayBar.defensives.visibility == "always" then
					showSecondary = true
				elseif sharedSettings.displayBar.defensives.visibility == "combat" then
					showSecondary = affectingCombat or inVehicle
				end
			end
			-- Whirlwind bar uses secondary bar visibility (always / combat / never)
			-- If maxResource2 == 0 (Improved Whirlwind not talented), treat as "never"
			local showWhirlwind = false
			if not forceHideAll and TRB.Data.character.specId == 2
				and sharedSettings.displayBar.secondary ~= nil
				and (TRB.Data.character.maxResource2 or 0) > 0 then
				if sharedSettings.displayBar.secondary.visibility == "always" then
					showWhirlwind = true
				elseif sharedSettings.displayBar.secondary.visibility == "combat" then
					showWhirlwind = affectingCombat or inVehicle
				end
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
			if barGroups and barGroups.defensives then
				if showSecondary then
					barGroups.defensives:Show()
					barGroups.defensives:ShowNodes(TRB.Data.character.maxResource2)
				else
					barGroups.defensives:Hide()
				end
			end
			if barGroups and barGroups.secondary then
				if showWhirlwind then
					barGroups.secondary:Show()
					barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2 or 0)
				else
					barGroups.secondary:Hide()
				end
			end

			-- Apply health bar visibility
			if barGroups and barGroups.health then
				if showHealth then
					barGroups.health:Show()
				else
					barGroups.health:Hide()
				end
			end

			-- Track if any bar is showing
			snapshotData.attributes.isTracking = showPrimary or showSecondary or showWhirlwind or showHealth
			if snapshotData.attributes.isTracking then
				TRB.Functions.BarText:Show(sharedSettings)
			else
				TRB.Functions.BarText:Hide(sharedSettings)
			end
		else
			if barGroups and barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups and barGroups.defensives then
				barGroups.defensives:Hide()
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
		if barGroups and barGroups.defensives then
			barGroups.defensives:Hide()
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
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local spells
	local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
		settings = TRB.Data.settings.warrior.arms
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
		settings = TRB.Data.settings.warrior.fury
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		settings = TRB.Data.settings.warrior.protection
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Arms
	elseif TRB.Data.character.specId == 2 then --Fury
	elseif TRB.Data.character.specId == 3 then --Protection
		if var == "$ignorePainTime" then
			if snapshots[spells.ignorePain.id].buff.isActive then
				valid = true
			end
		elseif var == "$ignorePainAbsorb" then
			-- Always secret, return false
			valid = false
		elseif var == "$shieldBlockTime" then
			if snapshots[spells.shieldBlock.id].buff.isActive then
				valid = true
			end
		elseif var == "$shieldBlockCharges" then
			if issecretvalue(snapshots[spells.shieldBlock.id].cooldown.charges) or snapshots[spells.shieldBlock.id].cooldown.charges > 0 then
				valid = true
			end
		elseif var == "$shieldBlockMaxCharges" then
			if issecretvalue(snapshots[spells.shieldBlock.id].cooldown.charges) or snapshots[spells.shieldBlock.id].cooldown.charges > 0  then
				valid = true
			end
		end
	end

	if valid == true then
		return valid
	end

	if var == "$resource" or var == "$rage" then
		-- Do not compare resource as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$rageMax" then
		valid = true
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$health" or var == "$healthMax" or var == "$healthPercent" or var == "$absorb" then
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
	elseif relativeToFrame ~= nil then
		-- Handle Fury's Whirlwind charge nodes
		if TRB.Data.character.specId == 2 then
			local whirlwindChargeIndex = string.match(relativeToFrame, "^WhirlwindCharge(%d+)$")
			if whirlwindChargeIndex ~= nil then
				local index = tonumber(whirlwindChargeIndex)
				if index ~= nil and barGroups and barGroups.secondary then
					local node = barGroups.secondary:GetNode(index)
					if node then
						local isVisible = barGroups.secondary.isVisible and node.isVisible
						return node:GetFrame(), true, isVisible
					end
				end
				return nil, true, false
			end
		end
		-- Handle Protection's defensive buff nodes
		if TRB.Data.character.specId == 3 then
			if TRB.Functions.String:StartsWith(relativeToFrame, "IgnorePain") then
				if barGroups and barGroups.defensives then
					local node = barGroups.defensives:GetNode(1)
					if node then
						local isVisible = barGroups.defensives.isVisible and node.isVisible
						return node:GetFrame(), true, isVisible
					end
				end
				return nil, true, false
			elseif TRB.Functions.String:StartsWith(relativeToFrame, "ShieldBlock") then
				if barGroups and barGroups.defensives then
					local node = barGroups.defensives:GetNode(2)
					if node then
						local isVisible = barGroups.defensives.isVisible and node.isVisible
						return node:GetFrame(), true, isVisible
					end
				end
				return nil, true, false
			end
		end
		-- Handle generic combo point index pattern
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.defensives then
				local node = barGroups.defensives:GetNode(index)
				if node then
					local isVisible = barGroups.defensives.isVisible and node.isVisible
					return node:GetFrame(), true, isVisible
				end
			end
		end
		-- Handle health bar
		if relativeToFrame == "HealthBar" then
			if barGroups and barGroups.health then
				local healthNode = barGroups.health:GetNode(1)
				if healthNode then
					local isVisible = barGroups.health.isVisible and healthNode.isVisible
					return healthNode:GetFrame(), true, isVisible
				end
			end
			return nil, true, false
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
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end
