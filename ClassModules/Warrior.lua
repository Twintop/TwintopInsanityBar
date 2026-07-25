local _, TRB = ...
if TRB.Data.character.classId ~= 1 then --Only do this if we're on a Warrior!
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

--- Lowest Rage value Shield Slam's tooltip has reported since the last gear/talent change.
--- Acts as the floor/baseline; a Violent Outburst proc reads ~50% higher than this.
---@type number?
local protectionShieldSlamBaselineRage = nil

--- Spell lookup for defensive node keys → spell objects. Populated in FillSpellData_Protection.
---@type table<string, table>
local defensiveSpellsByKey = {}

--- Computes the number of enabled defensive bar nodes from settings.
---@param specSettings table? # Protection spec settings
---@return integer
local function GetEnabledDefensiveCount(specSettings)
	if not specSettings then return 0 end
	local defensivesBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives")
	if not defensivesBarDef then return 2 end
	local colorSettings = defensivesBarDef:GetColors(specSettings)
	if not colorSettings then return 2 end
	local count = defensivesBarDef:GetEnabledNodeCount(colorSettings)
	return count
end

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
	---@type TRB.Classes.Snapshot
	specCache.warrior_protection.snapshotData.snapshots[spells.violentOutburst.id] = TRB.Classes.Snapshot:New(spells.violentOutburst)
end

local function Setup_Arms()
	Character:FillSpecializationCacheSettings("warrior", "arms")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warrior_arms" then
		Bar:DestroyBarGroups()
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
	Character:FillSpecializationCacheSettings("warrior", "fury")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warrior_fury" then
		Bar:DestroyBarGroups()
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
	Character:FillSpecializationCacheSettings("warrior", "protection", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warrior_protection" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Warrior.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Protection()
	Setup_Protection()
	specCache.warrior_protection.spellsData:FillSpellData()
	local spells = specCache.warrior_protection.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]

	-- Populate the defensive spell lookup so UpdateDefensiveBuffs can resolve nodeOrder keys
	defensiveSpellsByKey["ignorePain"] = spells.ignorePain
	defensiveSpellsByKey["ignorePainAbsorb"] = spells.ignorePain
	defensiveSpellsByKey["shieldBlock"] = spells.shieldBlock

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

	-- Pre-populate defensiveNodeMapping so that CreateBarTextFrames (called inside
	-- ConstructBarGroups) can resolve IgnorePain/ShieldBlock frame references.
	-- UpdateDefensiveBuffs will overwrite this with live buff data later.
	if TRB.Data.character.specId == 3 then
		local defensivesBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives")
		local colorSettings = settings.colors.bars.defensives
		local orderedKeys = defensivesBarDef and defensivesBarDef:GetOrderedNodeKeys(colorSettings) or { "ignorePain", "shieldBlock" }
		TRB.Data.defensiveNodeMapping = TRB.Data.defensiveNodeMapping or {}
		local mapping = TRB.Data.defensiveNodeMapping
		for k in pairs(mapping) do mapping[k] = nil end
		local nodeIdx = 1
		for _, colorKey in ipairs(orderedKeys) do
			local nc = colorSettings.nodeColors[colorKey]
			if nc and nc.enabled then
				mapping[colorKey] = nodeIdx
				nodeIdx = nodeIdx + 1
			end
		end
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

	if TRB.Data.character.specId == 1 then
		-- Arms: No secondary bar
		if barGroups and barGroups.defensives then
			barGroups.defensives:Hide()
		end
	elseif TRB.Data.character.specId == 2 then
		-- Fury: Whirlwind stacks bar (nodes based on talent)
		if barGroups and barGroups.defensives then
			barGroups.defensives:Hide()
		end
		if barGroups and barGroups.secondary then
			-- Always apply textures and colors to ALL secondary nodes so they are
			-- renderable even when maxResource2 is not yet known (it is set in
			-- CheckCharacter which may run after ConstructResourceBar).
			local frameLevels = TRB.Data.constants.frameLevels
			local whirlwindColors = settings.colors.bars and settings.colors.bars.whirlwind
			for x = 1, barGroups.secondary.maxNodes do
				local wwNode = barGroups.secondary:GetNode(x)
				if wwNode then
					wwNode:SetTextures(
						settings.textures.comboPointsBar,
						settings.textures.comboPointsBorder,
						settings.textures.comboPointsBackground
					)
					wwNode:SetMinMax(0, 1)
					if whirlwindColors then
						wwNode:SetBorderColor(whirlwindColors.border.color)
						wwNode:SetBackgroundColorFromString(whirlwindColors.background.color)
						TRB.Functions.Color:ApplyFillColor(wwNode, whirlwindColors.nodeColors.charge1)
					end
					wwNode:SetFrameLevel(frameLevels.comboPoint)
				end
			end

			-- Now handle visibility based on current maxResource2
			local maxWhirlwindNodes = TRB.Data.character.maxResource2 or 0

			if maxWhirlwindNodes == 0 then
				barGroups.secondary:Hide()
			else
				barGroups.secondary:SetMaxNodes(maxWhirlwindNodes)
				Bar:ApplySecondaryBarGroupLayout(settings, barGroups, maxWhirlwindNodes)
				barGroups.secondary:Show()
			end
		end
	elseif TRB.Data.character.specId == 3 then
		-- Protection: Show secondary bar for defensive buffs (Shield Block + Ignore Pain)
		if barGroups and barGroups.defensives then
			local enabledCount = GetEnabledDefensiveCount(settings)
			if enabledCount > 0 then
				barGroups.defensives:Show()
				barGroups.defensives:ShowNodes(enabledCount)
				for x = 1, enabledCount do
					local defensiveNode = barGroups.defensives:GetNode(x)
					if defensiveNode then
						defensiveNode:SetMinMax(0, 1)
					end
				end
			else
				barGroups.defensives:Hide()
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Arms()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.warrior.arms
	local sharedSettings = TRB.Data.specCache["warrior_arms"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core resource ($rage, $resource, $casting, $rageMax, $resourceMax)
	if not activeVars or activeVars["$rage"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$rageMax"] or activeVars["$resourceMax"] then

		local normalizedRage = snapshotData.attributes.resourceModified
		local currentRageColor = sharedSettings.colors.text.current.color
		local castingRageColor = sharedSettings.colors.text.casting.color

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
					currentRageColor = sharedSettings.colors.text.overThreshold.color
					castingRageColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingRageColor = sharedSettings.colors.text.spending.color
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))

		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedRage
		lookupLogic["$rage"] = normalizedRage
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal

		local resourceFormatted = snapshotData.formatted.resource or ""
		local rageChanged = lookupChanged(prevState, "$rage", resourceFormatted, currentRageColor)
		local castingChanged = lookupChanged(prevState, "$casting", snapshotData.casting.resourceFinal, castingRageColor)

		if rageChanged or castingChanged then
			local currentRage
			local castingRage
			-- Apply overcap color if enabled (takes precedence over overThreshold)
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentRage = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingRage = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
			else
				currentRage = string.format("|c%s%s|r", currentRageColor, resourceFormatted)
				castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentRage
			lookup["$rage"] = currentRage
			lookup["$casting"] = castingRage
		end
		lookup["$rageMax"] = TRB.Data.character.maxResource
		lookup["$resourceMax"] = TRB.Data.character.maxResource
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Fury()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.fury
	local sharedSettings = TRB.Data.specCache["warrior_fury"].settings
	local _
	local currentTime = GetTime()

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core resource ($rage, $resource, $casting, $rageMax, $resourceMax)
	if not activeVars or activeVars["$rage"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$rageMax"] or activeVars["$resourceMax"] then

		local normalizedRage = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor
		local currentRageColor = sharedSettings.colors.text.current.color
		local castingRageColor = sharedSettings.colors.text.casting.color

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
					currentRageColor = sharedSettings.colors.text.overThreshold.color
					castingRageColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		if snapshotData.casting.resourceFinal < 0 then
			castingRageColor = sharedSettings.colors.text.spending.color
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
		local _currentRage = normalizedRage

		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedRage
		lookupLogic["$rage"] = normalizedRage
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal

		local resourceFormatted = snapshotData.formatted.resource or ""
		local rageChanged = lookupChanged(prevState, "$rage", resourceFormatted, currentRageColor)
		local castingChanged = lookupChanged(prevState, "$casting", snapshotData.casting.resourceFinal, castingRageColor)
		if rageChanged or castingChanged then
			local currentRage
			local castingRage
			-- Apply overcap color if enabled (takes precedence over overThreshold)
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentRage = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingRage = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
			else
				currentRage = string.format("|c%s%s|r", currentRageColor, resourceFormatted)
				castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentRage
			lookup["$rage"] = currentRage
			lookup["$casting"] = castingRage
		end
		lookup["$rageMax"] = TRB.Data.character.maxResource
		lookup["$resourceMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Whirlwind ($wwCharges, $whirlwindCharges, $wwTime, $whirlwindTime)
	if not activeVars or activeVars["$wwCharges"] or activeVars["$whirlwindCharges"]
		or activeVars["$wwTime"] or activeVars["$whirlwindTime"] then

		local wwSnapshot = snapshots[spells.improvedWhirlwind.id]
		local wwCharges = 0
		local wwTime = 0
		if wwSnapshot and wwSnapshot.buff then
			wwCharges = wwSnapshot.buff.applications or 0
			wwTime = wwSnapshot.buff.remaining or 0
		end

		lookupLogic["$wwCharges"] = wwCharges
		lookupLogic["$whirlwindCharges"] = wwCharges
		lookupLogic["$wwTime"] = wwTime
		lookupLogic["$whirlwindTime"] = wwTime

		if lookupChanged(prevState, "$wwCharges", wwCharges) then
			local formatted = string.format("%s", wwCharges)
			lookup["$wwCharges"] = formatted
			lookup["$whirlwindCharges"] = formatted
		end
		if lookupChanged(prevState, "$wwTime", wwTime) then
			local formatted = string.format("%.1f", wwTime)
			lookup["$wwTime"] = formatted
			lookup["$whirlwindTime"] = formatted
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Protection()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warrior.protection
	local sharedSettings = TRB.Data.specCache["warrior_protection"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core resource ($rage, $resource, $casting, $rageMax, $resourceMax)
	if not activeVars or activeVars["$rage"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$rageMax"] or activeVars["$resourceMax"] then

		local normalizedRage = snapshotData.attributes.resourceModified
		local currentRageColor = sharedSettings.colors.text.current.color
		local castingRageColor = sharedSettings.colors.text.casting.color

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
					currentRageColor = sharedSettings.colors.text.overThreshold.color
					castingRageColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))

		lookupLogic["$resource"] = normalizedRage
		lookupLogic["$rage"] = normalizedRage
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$rageMax"] = TRB.Data.character.maxResource
		lookupLogic["$casting"] = snapshotData.casting.resourceFinal

		local resourceFormatted = snapshotData.formatted.resource or ""
		local rageChanged = lookupChanged(prevState, "$rage", resourceFormatted, currentRageColor)
		local castingChanged = lookupChanged(prevState, "$casting", snapshotData.casting.resourceFinal, castingRageColor)

		if rageChanged or castingChanged then
			local currentRage
			local castingRage
			-- Apply overcap color if enabled (takes precedence over overThreshold)
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentRageColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentRage = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingRage = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor")))
			else
				currentRage = string.format("|c%s%s|r", currentRageColor, resourceFormatted)
				castingRage = string.format("|c%s%s|r", castingRageColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentRage
			lookup["$rage"] = currentRage
			lookup["$casting"] = castingRage
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$rageMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Ignore Pain ($ignorePainAbsorb, $ignorePainTime)
	if not activeVars or activeVars["$ignorePainAbsorb"] or activeVars["$ignorePainTime"] then
		local currentTime = GetTime()
		local ipBuff = snapshots[spells.ignorePain.id].buff
		-- GetRemainingTime updates isActive, so call it first
		local _ignorePainTime = ipBuff:GetRemainingTime(currentTime)
		-- Refilled from the Cooldown Manager each tick and usually a secret.
		local _ignorePainAbsorb = nil
		if ipBuff.isActive then
			_ignorePainAbsorb = ipBuff.customProperties.absorb
		end

		lookupLogic["$ignorePainTime"] = _ignorePainTime
		-- A secret cannot be compared, so logic only ever learns whether there is a pool at all.
		lookupLogic["$ignorePainAbsorb"] = _ignorePainAbsorb ~= nil

		-- Absent for two different reasons: a buff that is down is a known zero, a buff that is up
		-- with no Cooldown Manager data is unknown. Memoized on the rendered string rather than the
		-- value, so those two -- both nil underneath -- still repaint when one becomes the other.
		local absorbDisplay
		if _ignorePainAbsorb ~= nil then
			absorbDisplay = TRB.Functions.String:ConvertToAbbreviatedNumber(_ignorePainAbsorb)
		elseif ipBuff.isActive then
			absorbDisplay = "??"
		else
			absorbDisplay = "0"
		end

		if lookupChanged(prevState, "$ignorePainAbsorb", absorbDisplay) then
			lookup["$ignorePainAbsorb"] = absorbDisplay
		end
		if lookupChanged(prevState, "$ignorePainTime", _ignorePainTime) then
			lookup["$ignorePainTime"] = TRB.Functions.BarText:TimerPrecision(_ignorePainTime)
		end
	end

	-- Block C: Shield Block ($shieldBlockTime, $shieldBlockCharges, $shieldBlockMaxCharges)
	if not activeVars or activeVars["$shieldBlockTime"] or activeVars["$shieldBlockCharges"]
		or activeVars["$shieldBlockMaxCharges"] then
		local currentTime = GetTime()
		local _shieldBlockTime = snapshots[spells.shieldBlock.id].buff:GetRemainingTime(currentTime)
		local shieldBlockCharges = snapshots[spells.shieldBlock.id].cooldown.charges or 0
		local shieldBlockMaxCharges = snapshots[spells.shieldBlock.id].cooldown.maxCharges or 0

		lookupLogic["$shieldBlockTime"] = _shieldBlockTime
		lookupLogic["$shieldBlockCharges"] = shieldBlockCharges
		lookupLogic["$shieldBlockMaxCharges"] = shieldBlockMaxCharges

		if lookupChanged(prevState, "$shieldBlockTime", _shieldBlockTime) then
			lookup["$shieldBlockTime"] = TRB.Functions.BarText:TimerPrecision(_shieldBlockTime)
		end
		lookup["$shieldBlockCharges"] = shieldBlockCharges
		lookup["$shieldBlockMaxCharges"] = shieldBlockMaxCharges
	end

	-- Block D: Violent Outburst ($voTime, $violentOutburstTime)
	if not activeVars or activeVars["$voTime"] or activeVars["$violentOutburstTime"] then
		local currentTime = GetTime()
		local _voTime = snapshots[spells.violentOutburst.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$voTime"] = _voTime
		lookupLogic["$violentOutburstTime"] = _voTime

		if lookupChanged(prevState, "$voTime", _voTime) then
			local formatted = TRB.Functions.BarText:TimerPrecision(_voTime)
			lookup["$voTime"] = formatted
			lookup["$violentOutburstTime"] = formatted
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end


--- Starts the event-driven Ignore Pain timer. The absorb pool needs nothing from here: it is a
--- percentage supplied by the Cooldown Manager each tick. An earlier version scraped an absolute
--- absorb out of the spell description into the same field, which is what made the number useless
--- -- millions of damage where the consumer wanted 0-100.
---@param currentTime number
local function StartIgnorePainTimer(currentTime)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	local ipBuff = TRB.Data.snapshotData.snapshots[spells.ignorePain.id].buff
	ipBuff:InitializeCustom(spells.ignorePain.duration, currentTime)
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
					local cachedGcd = snapshotData.attributes.gcdDuration or 1.5
					local duration = spells.bladestorm.duration * (cachedGcd / 1.5)
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
			--[[elseif spellId == spells.shieldCharge.id then -- Button press
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
				snapshotData.snapshots[spells.shieldBlock.id].buff.attributes.shieldChargeUsed = false]]
			elseif spellId == spells.ignorePain.castId then
				StartIgnorePainTimer(currentTime)
			elseif spellId == spells.shieldSlam.id then
				if talents:IsTalentActive(spells.heavyRepercussions) and snapshotData.snapshots[spells.shieldBlock.id].buff.isActive then
					local duration = spells.heavyRepercussions.attributes.durationMod
					snapshotData.snapshots[spells.shieldBlock.id].buff:AddTimeOrInitializeCustom(duration, currentTime)
				end

				-- Shield Slam consumes an active Violent Outburst proc, which also grants Ignore
				-- Pain. Start the event-driven Ignore Pain timer from the consume.
				local violentOutburst = snapshotData.snapshots[spells.violentOutburst.id]
				if violentOutburst ~= nil and violentOutburst.buff.isActive then
					violentOutburst.buff:Reset()
					snapshotData.audio.violentOutburstCue = false

					StartIgnorePainTimer(currentTime)
				end
			end
		end
	end
end

---Updates data based on spell events
local function HandleSpellEvents(self, event, ...)
	if event == "SPELL_UPDATE_COOLDOWN" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
			if spellId == spells.shieldCharge.castId then
				local currentTime = GetTime()
				local duration = spells.shieldBlock.duration + (spells.enduringDefenses.attributes.durationModPerRank * talents.talents[spells.enduringDefenses.id].currentRank)
				snapshotData.snapshots[spells.shieldBlock.id].buff:AddTimeOrInitializeCustom(duration, currentTime)
				snapshotData.snapshots[spells.shieldBlock.id].buff.attributes.shieldChargeUsed = false
			end
		end
	end
end


local spellEventFrame = CreateFrame("Frame")
spellEventFrame:SetScript("OnEvent", HandleSpellEvents)

--- Polls Shield Slam's tooltip to detect a Violent Outburst proc (Protection only).
--- Establishes the baseline (lowest) Rage, then snapshots a 30s buff when the tooltip
--- reads ~50% higher. Driven by UNIT_AURA so it only runs on buff gained/lost.
local function DetectViolentOutburst()
	if TRB.Data.character.specId ~= 3 then
		return
	end
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	if talents == nil or spells == nil or spells.violentOutburst == nil or spells.shieldSlam == nil then
		return
	end
	if not talents:IsTalentActive(spells.violentOutburst) then
		return
	end

	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snap = snapshotData.snapshots[spells.violentOutburst.id]
	if snap == nil then
		return
	end

	local currentRage = TRB.Functions.String:ParseLastNumber(C_Spell.GetSpellDescription(spells.shieldSlam.id))
	if currentRage == nil or currentRage <= 0 then
		return
	end

	-- Only (re)establish the floor while the proc isn't active, so the inflated proc
	-- value can never become the baseline.
	if not snap.buff.isActive then
		if protectionShieldSlamBaselineRage == nil or currentRage < protectionShieldSlamBaselineRage then
			protectionShieldSlamBaselineRage = currentRage
		end

		-- Tolerant 50% check: integer Rage means a 15 base reads as 22 (1.467x), not 1.5x.
		if protectionShieldSlamBaselineRage ~= nil and currentRage >= protectionShieldSlamBaselineRage * 1.4 then
			snap.buff:InitializeCustom(spells.violentOutburst.duration, GetTime())
			TRB.Data.lookupDirty = true

			local specSettings = TRB.Data.settings.warrior.protection
			if specSettings.audio.violentOutburst ~= nil and specSettings.audio.violentOutburst.enabled and not snapshotData.audio.violentOutburstCue then
				PlaySoundFile(specSettings.audio.violentOutburst.sound, TRB.Data.settings.core.audio.channel.channel)
				snapshotData.audio.violentOutburstCue = true
			end
		end
	end
end

--- Generic player-aura hook invoked by Functions/Aura.lua on every player UNIT_AURA. Used to
--- poll Shield Slam's tooltip for a Violent Outburst proc only when auras change.
---@param info UnitAuraUpdateInfo?
function TRB.Functions.Class:OnPlayerUnitAura(info)
	DetectViolentOutburst()
end

-- Gear changes can alter Shield Slam's Rage generation, so rebuild the baseline when equipment
-- changes. (UNIT_AURA-driven proc detection is handled centrally via OnPlayerUnitAura above.)
local equipmentFrame = CreateFrame("Frame")
equipmentFrame:SetScript("OnEvent", function(self, event)
	protectionShieldSlamBaselineRage = nil
	DetectViolentOutburst()
end)

function TRB.Functions.Class:EnableEvents()
	spellEventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	equipmentFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
end

function TRB.Functions.Class:DisableEvents()
	spellEventFrame:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	equipmentFrame:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
end

local function UpdateSnapshot()
	local currentTime = GetTime()
	Character:UpdateSnapshot()
	
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

	-- Track active→inactive transition so bar text gets one final refresh when the
	-- buff expires out of combat (same pattern as Priest Lightweaver fix).
	local wasWhirlwindActive = snapshots[spells.improvedWhirlwind.id].buff.isActive
	snapshots[spells.improvedWhirlwind.id].buff:GetRemainingTime(currentTime)
	if wasWhirlwindActive and not snapshots[spells.improvedWhirlwind.id].buff.isActive then
		TRB.Data.lookupDirty = true
	end
	--[[snapshots[spells.bladestorm.id].buff:UpdateTicks(currentTime)
	snapshots[spells.execute.id].cooldown:Refresh()]]
end

local function UpdateSnapshot_Protection()
	local currentTime = GetTime()
	UpdateSnapshot()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	-- Track active→inactive transitions so bar text gets one final refresh when
	-- buffs expire out of combat.
	local ignorePainBuff = snapshots[spells.ignorePain.id].buff
	local wasIgnorePainActive = ignorePainBuff.isActive
	ignorePainBuff:GetRemainingTime(currentTime)
	if wasIgnorePainActive and not ignorePainBuff.isActive then
		TRB.Data.lookupDirty = true
	end

	-- Refill the absorb pool from the Cooldown Manager, and clear it the moment the buff drops -- a
	-- stale pool reads as protection that is no longer there. The pool arrives as the aura's
	-- application count rather than an effect value: Ignore Pain does not stack, and the buff
	-- viewers still print a number on the icon, so that count is the absorb. Pinned to the buff
	-- viewers because the cooldown viewers hold the same spell but describe the cast instead.
	local cdm = TRB.Functions.CooldownManager
	local absorbOk, absorb = cdm:Read(spells.ignorePain.id, cdm.Signal.APPLICATIONS, cdm.SourceGroup.BUFF)
	if ignorePainBuff.isActive and absorbOk then
		ignorePainBuff.customProperties.absorb = absorb
	else
		ignorePainBuff.customProperties.absorb = nil
	end

	local wasShieldBlockActive = snapshots[spells.shieldBlock.id].buff.isActive
	snapshots[spells.shieldBlock.id].buff:GetRemainingTime(currentTime)
	if wasShieldBlockActive and not snapshots[spells.shieldBlock.id].buff.isActive then
		TRB.Data.lookupDirty = true
	end

	local wasViolentOutburstActive = snapshots[spells.violentOutburst.id].buff.isActive
	snapshots[spells.violentOutburst.id].buff:GetRemainingTime(currentTime)
	if wasViolentOutburstActive and not snapshots[spells.violentOutburst.id].buff.isActive then
		-- Proc expired (or was consumed); allow the audio cue to fire on the next proc.
		TRB.Data.snapshotData.audio.violentOutburstCue = false
		TRB.Data.lookupDirty = true
	end
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
	local affectingCombat = TRB.Data.character.inCombat
	-- Handle both raw string and { color = "..." } object formats
	local bgColor = specSettings.colors.bars.defensives.background
	if type(bgColor) == "table" then bgColor = bgColor.color end
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(bgColor, true)
	local cpBorderColor = specSettings.colors.bars.defensives.border
	if type(cpBorderColor) == "table" then cpBorderColor = cpBorderColor.color end

	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
	local sharedColors = specSettings.colors.shared
	local indicatorColors = sharedColors and sharedColors.indicatorColors
	local gradientOrder = sharedColors and sharedColors.gradientOrder
	local overcapIndicator = nil
	if gradientOrder and indicatorColors then
		for i = #gradientOrder, 1, -1 do
			local key = gradientOrder[i]
			local indicator = indicatorColors[key]
			if indicator and indicator.enabled and indicator.isGradient and key == "borderOvercap" and affectingCombat then
				overcapIndicator = indicator
				break
			end
		end
	end
	
	local currentDefensiveBar = 1

	-- Build ordered defensive buffs list from nodeOrder setting
	local defensivesBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("defensives")
	local colorSettings = specSettings.colors.bars.defensives
	local orderedKeys = defensivesBarDef and defensivesBarDef:GetOrderedNodeKeys(colorSettings) or { "ignorePain", "shieldBlock" }

	-- Runtime node mapping: tracks which logical buff key ended up at which bar node index
	TRB.Data.defensiveNodeMapping = TRB.Data.defensiveNodeMapping or {}
	local mapping = TRB.Data.defensiveNodeMapping
	-- Snapshot old mapping to detect changes (for re-anchoring bar text)
	local oldIgnorePain = mapping["ignorePain"]
	local oldIgnorePainAbsorb = mapping["ignorePainAbsorb"]
	local oldShieldBlock = mapping["shieldBlock"]
	-- Reset mapping
	for k in pairs(mapping) do mapping[k] = nil end

	for _, colorKey in ipairs(orderedKeys) do
		local spell = defensiveSpellsByKey[colorKey]
		if not spell then
			-- Unknown key, skip
		else
			local defensiveBarEnabled = specSettings.colors.bars.defensives.nodeColors[colorKey] and specSettings.colors.bars.defensives.nodeColors[colorKey].enabled
			
			if talents:IsTalentActive(spell) and defensiveBarEnabled then
				local cpColor = specSettings.colors.bars.defensives.nodeColors[colorKey]
				local defensiveBarTargetKey = nil
				if colorKey == "ignorePain" then
					defensiveBarTargetKey = "defensivesIgnorePainTimeBar"
				elseif colorKey == "ignorePainAbsorb" then
					defensiveBarTargetKey = "defensivesIgnorePainAbsorbBar"
				elseif colorKey == "shieldBlock" then
					defensiveBarTargetKey = "defensivesShieldBlockBar"
				end
				local buff = snapshots[spell.id].buff
				
				-- Refresh isActive before reading it (GetRemainingTime updates isActive as a side-effect)
				buff:GetRemainingTime(currentTime)
				
				local cpTime = 0
				local cpDuration = 1
				
				if colorKey == "ignorePainAbsorb" then
					-- The pool already arrives as a 0-100 percentage, so it goes straight onto a
					-- fixed scale. It is a secret, which the status bar accepts but no arithmetic
					-- here could touch -- there is nothing to normalise either way.
					cpDuration = 100
					if buff.isActive and buff.customProperties.absorb ~= nil then
						cpTime = buff.customProperties.absorb
					end
				else
					if buff.isActive then
						cpTime = buff.remaining or 0
						cpDuration = buff.duration
					end
				
					if cpTime < 0 then
						cpTime = 0
					end
				
					if cpTime == math.huge or cpDuration == math.huge then
						cpTime = 0
						cpDuration = 1
					end
				end
				
				if barGroups and barGroups.defensives then
					local defensiveNode = barGroups.defensives:GetNode(currentDefensiveBar)
					if defensiveNode then
						defensiveNode:SetMinMax(0, cpDuration)
						defensiveNode:SetValue(cpTime)
						if overcapIndicator and defensiveBarTargetKey and overcapIndicator.targets and overcapIndicator.targets[defensiveBarTargetKey] and overcapIndicator.targets[defensiveBarTargetKey].border then
							local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, cpBorderColor, overcapIndicator.color)
							local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
							defensiveNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(defensiveNode, overcapBorderCurve))
						else
							defensiveNode:SetBorderColor(cpBorderColor)
						end

						if overcapIndicator and defensiveBarTargetKey and overcapIndicator.targets and overcapIndicator.targets[defensiveBarTargetKey] and overcapIndicator.targets[defensiveBarTargetKey].bar then
							local overcapBarCurve = Color:BuildResourceThresholdCurve(specSettings, cpColor, overcapIndicator.color)
							local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBarCurve)
							defensiveNode:SetColorCurve(barColorResult)
						else
							TRB.Functions.Color:ApplyFillColor(defensiveNode, cpColor)
						end

						if overcapIndicator and defensiveBarTargetKey and overcapIndicator.targets and overcapIndicator.targets[defensiveBarTargetKey] and overcapIndicator.targets[defensiveBarTargetKey].background then
							local overcapBackgroundCurve = Color:BuildResourceThresholdCurve(specSettings, bgColor, overcapIndicator.color)
							local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBackgroundCurve)
							defensiveNode:SetBackgroundColorCurve(backgroundColorResult)
						else
							defensiveNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
						end
						Bar:ApplyEndCapIndicator(defensiveNode, defensiveBarTargetKey)
					end
				end
				
				mapping[colorKey] = currentDefensiveBar
				currentDefensiveBar = currentDefensiveBar + 1
			end
		end
	end

	-- If the mapping changed (node order swap, enable/disable toggle, talent change),
	-- re-anchor bar text frames so they point to the correct physical nodes.
	if mapping["ignorePain"] ~= oldIgnorePain or mapping["ignorePainAbsorb"] ~= oldIgnorePainAbsorb or mapping["shieldBlock"] ~= oldShieldBlock then
		TRB.Functions.BarText:CreateBarTextFrames()
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

	local whirlwindColors = specSettings.colors.bars.whirlwind
	local cpBackgroundColor = whirlwindColors.background.color
	local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(whirlwindColors.background.color, true)

	-- Read Fury indicator colors system
	local sharedColors = specSettings.colors.shared
	local indicatorColors = sharedColors and sharedColors.indicatorColors
	local gradientOrder = sharedColors and sharedColors.gradientOrder
	local zeroStackInd = indicatorColors and indicatorColors.zeroStackBackground
	local zeroStackTargets = zeroStackInd and zeroStackInd.enabled and stacks == 0 and TRB.Data.character.inCombat
		and zeroStackInd.targets and zeroStackInd.targets.whirlwindBar or nil
	local useZeroStackBg = zeroStackTargets and zeroStackTargets.background
	local overcapIndicator = nil
	if gradientOrder and indicatorColors and TRB.Data.character.inCombat then
		for i = #gradientOrder, 1, -1 do
			local key = gradientOrder[i]
			local indicator = indicatorColors[key]
			if indicator and indicator.enabled and indicator.isGradient then
				overcapIndicator = indicator
				break
			end
		end
	end
	local zsBgR, zsBgG, zsBgB, zsBgA
	if useZeroStackBg then
		zsBgR, zsBgG, zsBgB, zsBgA = Color:GetRGBAFromString(zeroStackInd.color, true)
	end
	local whirlwindTargets = overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.whirlwindBar or nil
	local overcapColor = overcapIndicator and overcapIndicator.color or nil
	local overcapBorderColorResult = nil
	local overcapBorderCurve = nil
	local overcapBackgroundColorResult = nil
	local overcapBarColorResults = {}
	local borderBaseColor = zeroStackTargets and zeroStackTargets.border and zeroStackInd.color or whirlwindColors.border.color
	local backgroundBaseColor = zeroStackTargets and zeroStackTargets.background and zeroStackInd.color or cpBackgroundColor
	if whirlwindTargets and whirlwindTargets.border and overcapColor then
		overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, borderBaseColor, overcapColor)
		overcapBorderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
	end
	if whirlwindTargets and whirlwindTargets.background and overcapColor then
		local overcapBackgroundCurve = Color:BuildResourceThresholdCurve(specSettings, backgroundBaseColor, overcapColor)
		overcapBackgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBackgroundCurve)
	end

	for x = 1, 4 do
		local cpBorderColor = whirlwindColors.border.color
		local cpColor = whirlwindColors.nodeColors.charge1
		local currentBackgroundColor = cpBackgroundColor
		local filled = stacks >= x

		if filled then
			if (whirlwindColors.sameColor and stacks == 2) or (not whirlwindColors.sameColor and x == 2) then
				cpColor = whirlwindColors.nodeColors.charge2
			elseif (whirlwindColors.sameColor and stacks == 3) or (not whirlwindColors.sameColor and x == 3) then
				cpColor = whirlwindColors.nodeColors.charge3
			elseif (whirlwindColors.sameColor and stacks == 4) or x == 4 then
				cpColor = whirlwindColors.nodeColors.charge4
			end
		end

		if zeroStackTargets then
			if zeroStackTargets.border then
				cpBorderColor = zeroStackInd.color
			end
			if zeroStackTargets.bar then
				cpColor = zeroStackInd.color
			end
			if zeroStackTargets.background then
				currentBackgroundColor = zeroStackInd.color
			end
		end

		local node = barGroups.secondary:GetNode(x)
		if node then
			Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, node, filled and 1 or 0, 1)
			if overcapBorderColorResult then
				node:SetBorderColorCurve(overcapBorderColorResult, Color:EvaluateEndCapCurve(node, overcapBorderCurve))
			else
				node:SetBorderColor(cpBorderColor)
			end

			if whirlwindTargets and whirlwindTargets.bar and overcapColor then
				local overcapBarCacheKey = type(cpColor) == "table" and cpColor.color or cpColor
				local barColorResult = overcapBarColorResults[overcapBarCacheKey]
				if barColorResult == nil then
					local overcapBarCurve = Color:BuildResourceThresholdCurve(specSettings, cpColor, overcapColor)
					barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBarCurve)
					overcapBarColorResults[overcapBarCacheKey] = barColorResult
				end
				node:SetColorCurve(barColorResult)
			else
				TRB.Functions.Color:ApplyFillColor(node, cpColor)
			end

			if overcapBackgroundColorResult then
				node:SetBackgroundColorCurve(overcapBackgroundColorResult)
			elseif useZeroStackBg then
				node:SetBackgroundColor(zsBgR, zsBgG, zsBgB, zsBgA)
			else
				node:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
			end
			Bar:ApplyEndCapIndicator(node, "whirlwindBar")
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

	local primaryResourceFrame = primaryNode:GetFrame()

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.arms
		local specCacheSettings = TRB.Data.specCache.warrior_arms.settings
		UpdateSnapshot_Arms()

		if snapshotData.attributes.isTracking then
			local affectingCombat = TRB.Data.character.inCombat

			-- Indicators resolve ahead of the primary bar's visibility guard: the health bar and cast bar have
			-- their own visibility, so they still need coloring when the resource bar is set to Never Show.
			local barColor = specSettings.colors.bar.base
			local barBorderColor = specSettings.colors.bar.border.color
			local barBackgroundColor = specSettings.colors.bar.background.color
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors
			local gradientOrder = sharedColors and sharedColors.gradientOrder
			local conditionMap = {
				borderOvercap = affectingCombat,
			}
			-- The rage bar is colored bespoke below; the resolver is here for the shared health/cast bar.
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, nil)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "rageBar")
				
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
							---@type string?
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.executeMinimum.id then
							if spell.settingKey == "executeMinimum" then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									showThreshold = false
								end
							elseif spell.settingKey == "executeMaximum" then
								if isUsable then
									-- Use ColorCurve to correctly evaluate max cost against secret Rage
									local curveUnderColor, curveOverColor = Threshold:ResolveThresholdCurveColors(spell, specCacheSettings)
									local thresholdCurve = Color:BuildThresholdCurve(
										1,
										resourceAmount,
										curveUnderColor,
										curveOverColor
									)
									local iconCurve = Color:BuildIconVertexColorCurve(1, resourceAmount)
									frameLevel = frameLevels.thresholdOver
									local curveApplied = Threshold:ApplyThresholdCurveColor(
										spell, thresholds[thresholdId], thresholdCurve, TRB.Data.resource, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
									)
									if curveApplied then
										thresholdColor = nil -- Skip normal color application
									else
										thresholdColor = curveUnderColor
									end
								else
									showThreshold = false
								end
							end
						elseif spell.id == spells.whirlwind.id then
							if talents:IsTalentActive(spells.cleave) then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.id == spells.cleave.id then
							if not talents:IsTalentActive(spells.cleave) then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshots[spell.id].cooldown:IsUnusable() then
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

				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.border then
					local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, overcapIndicator.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(primaryNode, overcapBorderCurve))
				elseif specSettings.colors.bar.borderOvercap and specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(primaryNode, overcapBorderCurve))
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.bar then
					local overcapBarCurve = Color:BuildResourceThresholdCurve(specSettings, barColor, overcapIndicator.color)
					local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBarCurve)
					primaryNode:SetColorCurve(barColorResult)
				else
					TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				end

				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.background then
					local overcapBackgroundCurve = Color:BuildResourceThresholdCurve(specSettings, barBackgroundColor, overcapIndicator.color)
					local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBackgroundCurve)
					primaryNode:SetBackgroundColorCurve(backgroundColorResult)
				else
					primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				end
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.fury
		local specCacheSettings = TRB.Data.specCache.warrior_fury.settings
		UpdateSnapshot_Fury()

		if snapshotData.attributes.isTracking then
			local affectingCombat = TRB.Data.character.inCombat
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.FurySpells]]

			-- Indicators resolve ahead of the primary bar's visibility guard: the health bar and cast bar have
			-- their own visibility, so they still need coloring when the resource bar is set to Never Show.
			local barColor = specSettings.colors.bar.base
			local barBorderColor = specSettings.colors.bar.border.color
			local barBackgroundColor = specSettings.colors.bar.background.color
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors
			local gradientOrder = sharedColors and sharedColors.gradientOrder
			local zeroStackTargets
			local zeroStackActive = false
			do
				local zeroStackInd = indicatorColors and indicatorColors.zeroStackBackground
				local wwBuff = snapshots[spells.improvedWhirlwind.id] and snapshots[spells.improvedWhirlwind.id].buff
				wwBuff:GetRemainingTime(currentTime)
				local whirlwindStacks = (wwBuff and wwBuff.isActive and wwBuff.applications) or 0
				if whirlwindStacks < 0 then whirlwindStacks = 0 end
				if whirlwindStacks > 4 then whirlwindStacks = 4 end
				zeroStackActive = whirlwindStacks == 0 and affectingCombat == true
				zeroStackTargets = zeroStackInd and zeroStackInd.enabled and zeroStackActive
					and zeroStackInd.targets and zeroStackInd.targets.rageBar or nil
				if zeroStackTargets then
					if zeroStackTargets.bar then
						barColor = zeroStackInd.color
					end
					if zeroStackTargets.border then
						barBorderColor = zeroStackInd.color
					end
					if zeroStackTargets.background then
						barBackgroundColor = zeroStackInd.color
					end
				end
			end
			local conditionMap = {
				borderOvercap = affectingCombat,
				zeroStackBackground = zeroStackActive,
			}
			-- The rage bar is colored bespoke above; the resolver is here for the shared health/cast bar.
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, nil)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "rageBar")

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
					---@type string?
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.execute.id then
							if talents:IsTalentActive(spells.improvedExecute) then
								showThreshold = false
							elseif spell.settingKey == "executeMaximum" then
								if isUsable then
									-- Use ColorCurve to correctly evaluate max cost against secret Rage
									local curveUnderColor, curveOverColor = Threshold:ResolveThresholdCurveColors(spell, specCacheSettings)
									local thresholdCurve = Color:BuildThresholdCurve(
										1,
										resourceAmount,
										curveUnderColor,
										curveOverColor
									)
									local iconCurve = Color:BuildIconVertexColorCurve(1, resourceAmount)
									frameLevel = frameLevels.thresholdOver
									local curveApplied = Threshold:ApplyThresholdCurveColor(
										spell, thresholds[thresholdId], thresholdCurve, TRB.Data.resource, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
									)
									if curveApplied then
										thresholdColor = nil -- Skip normal color application
									else
										thresholdColor = curveUnderColor
									end
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
						elseif spell.id == spells.thunderClap.id then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif talents:IsTalentActive(spells.crashingThunder) then
								showThreshold = false
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
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

				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.border then
					local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, overcapIndicator.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(primaryNode, overcapBorderCurve))
				elseif specSettings.colors.bar.borderOvercap and specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(primaryNode, overcapBorderCurve))
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.bar then
					local overcapBarCurve = Color:BuildResourceThresholdCurve(specSettings, barColor, overcapIndicator.color)
					local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBarCurve)
					primaryNode:SetColorCurve(barColorResult)
				else
					TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				end

				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.background then
					local overcapBackgroundCurve = Color:BuildResourceThresholdCurve(specSettings, barBackgroundColor, overcapIndicator.color)
					local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBackgroundCurve)
					primaryNode:SetBackgroundColorCurve(backgroundColorResult)
				else
					primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				end
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			-- Whirlwind stacks bar (only when Improved Whirlwind is talented, i.e. maxResource2 > 0)
			if not specSettings.displayBar.secondary.neverShow and (TRB.Data.character.maxResource2 or 0) > 0 then
				refreshText = true
				UpdateWhirlwindCharges(specSettings, specCacheSettings)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.protection
		local specCacheSettings = TRB.Data.specCache.warrior_protection.settings
		UpdateSnapshot_Protection()

		if snapshotData.attributes.isTracking then
			local affectingCombat = TRB.Data.character.inCombat
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]

			-- Indicators resolve ahead of the primary bar's visibility guard: the health bar and cast bar have
			-- their own visibility, so they still need coloring when the resource bar is set to Never Show.
			local barColor = specSettings.colors.bar.base
			local barBorderColor = specSettings.colors.bar.border.color
			local barBackgroundColor = specSettings.colors.bar.background.color
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors
			local gradientOrder = sharedColors and sharedColors.gradientOrder
			local conditionMap = {
				borderOvercap = affectingCombat,
				violentOutburst = snapshotData.snapshots[spells.violentOutburst.id] ~= nil and snapshotData.snapshots[spells.violentOutburst.id].buff.isActive,
			}
			-- The rage bar is colored bespoke below; the resolver is here for the shared health/cast bar.
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, nil)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified

				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "rageBar")

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
					---@type string?
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.executeMinimum.id then
							if spell.settingKey == "executeMinimum" then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									showThreshold = false
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.settingKey == "executeMaximum" then
								if isUsable then
									-- Use ColorCurve to correctly evaluate max cost against secret Rage
									local curveUnderColor, curveOverColor = Threshold:ResolveThresholdCurveColors(spell, specCacheSettings)
									local thresholdCurve = Color:BuildThresholdCurve(
										1,
										resourceAmount,
										curveUnderColor,
										curveOverColor
									)
									local iconCurve = Color:BuildIconVertexColorCurve(1, resourceAmount)
									frameLevel = frameLevels.thresholdOver
									local curveApplied = Threshold:ApplyThresholdCurveColor(
										spell, thresholds[thresholdId], thresholdCurve, TRB.Data.resource, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
									)
									if curveApplied then
										thresholdColor = nil -- Skip normal color application
									else
										thresholdColor = curveUnderColor
									end
								else
									showThreshold = false
								end
							end
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshots[spell.id].cooldown:IsUnusable() then
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

				-- Boolean (non-gradient) indicators recolor the rage bar; last-writer-wins over
				-- nodeOrder (index 1 = highest priority). An active override becomes the base color
				-- any gradient overcap curve is then built from below.
				if sharedColors and sharedColors.nodeOrder and indicatorColors then
					for i = #sharedColors.nodeOrder, 1, -1 do
						local key = sharedColors.nodeOrder[i]
						local indicator = indicatorColors[key]
						if indicator and indicator.enabled and not indicator.isGradient and conditionMap[key]
							and indicator.targets and indicator.targets.rageBar then
							if indicator.targets.rageBar.border then barBorderColor = indicator.color end
							if indicator.targets.rageBar.bar then barColor = indicator.color end
							if indicator.targets.rageBar.background then barBackgroundColor = indicator.color end
						end
					end
				end

				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.border then
					local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, overcapIndicator.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(primaryNode, overcapBorderCurve))
				elseif specSettings.colors.bar.borderOvercap and specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
					local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
					primaryNode:SetBorderColorCurve(borderColorResult, Color:EvaluateEndCapCurve(primaryNode, overcapBorderCurve))
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.bar then
					local overcapBarCurve = Color:BuildResourceThresholdCurve(specSettings, barColor, overcapIndicator.color)
					local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBarCurve)
					primaryNode:SetColorCurve(barColorResult)
				else
					TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				end

				if overcapIndicator and overcapIndicator.targets and overcapIndicator.targets.rageBar and overcapIndicator.targets.rageBar.background then
					local overcapBackgroundCurve = Color:BuildResourceThresholdCurve(specSettings, barBackgroundColor, overcapIndicator.color)
					local backgroundColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBackgroundCurve)
					primaryNode:SetBackgroundColorCurve(backgroundColorResult)
				else
					primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				end
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.defensives.neverShow then
			refreshText = true
				UpdateDefensiveBuffs(specSettings, specCacheSettings)
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
	
	if TRB.Data.character.specId == 1 then
		specCache.warrior_arms.talents:GetTalents()
		FillSpellData_Arms()
		Character:LoadFromSpecializationCache(specCache.warrior_arms)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ArmsSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Arms
		Bar:UpdateSanityCheckValues(specCache.warrior_arms.settings)
		
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
		Character:LoadFromSpecializationCache(specCache.warrior_fury)
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Fury
		Bar:UpdateSanityCheckValues(specCache.warrior_fury.settings)
		
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
		Character:LoadFromSpecializationCache(specCache.warrior_protection)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warrior.ProtectionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Protection
		Bar:UpdateSanityCheckValues(specCache.warrior_protection.settings)
		
		-- Talent change reroutes through here; rebuild the Shield Slam Rage baseline.
		protectionShieldSlamBaselineRage = nil

		local lookup = TRB.Data.lookup or {}
		lookup["#ignorePain"] = spells.ignorePain.icon
		lookup["#impendingVictory"] = spells.impendingVictory.icon
		lookup["#shieldBlock"] = spells.shieldBlock.icon
		lookup["#slam"] = spells.slam.icon
		lookup["#suddenDeath"] = spells.suddenDeath.icon
		lookup["#violentOutburst"] = spells.violentOutburst.icon
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
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

		if sharedSettings ~= nil then
			if whirlwindCharges ~= TRB.Data.character.maxResource2 then
				local oldMaxResource2 = TRB.Data.character.maxResource2 or 0
				TRB.Data.character.maxResource2 = whirlwindCharges

				if barGroups and barGroups.secondary then
					if whirlwindCharges > 0 then
						-- Talent became active: set up secondary bar layout and show it
						barGroups.secondary:SetMaxNodes(whirlwindCharges)
						Bar:ApplySecondaryBarGroupLayout(sharedSettings, barGroups, whirlwindCharges)
						barGroups.secondary:Show()
						barGroups.secondary:ShowNodes(whirlwindCharges)
					else
						-- Talent removed: hide secondary bar
						barGroups.secondary:Hide()
					end
				end

				if barGroups and barGroups.primary then
					Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
				TRB.Functions.BarVisibility:MarkDirty()
			end
		end
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "protection"
		TRB.Data.character.compositeKey = "warrior_protection"
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		local maxComboPoints = GetEnabledDefensiveCount(sharedSettings)
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	TRB.Functions.Class:DisableEvents()
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
		TRB.Functions.Class:EnableEvents()
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

		-- Protection (3) uses the defensives bar; Fury (2) uses the secondary/whirlwind bar (talent-gated)
		local hasDefensives = TRB.Data.character.specId == 3
		local enabledDefensiveCount = hasDefensives and GetEnabledDefensiveCount(sharedSettings) or 0
		local hasWhirlwind = TRB.Data.character.specId == 2 and (TRB.Data.character.maxResource2 or 0) > 0
		local secondaryVisSettings = (sharedSettings and sharedSettings.displayBar.secondary) or nil

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.defensives, sharedSettings and sharedSettings.displayBar.defensives, hasDefensives and enabledDefensiveCount > 0, enabledDefensiveCount, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, secondaryVisSettings, hasWhirlwind, TRB.Data.character.maxResource2 or 0, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, sharedSettings and sharedSettings.displayBar.health, true, nil, nil),
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
		["$resource"] = false, ["$rage"] = false,
		["$resourceMax"] = true, ["$rageMax"] = true,
		["$casting"] = castingFn,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
	}
	-- Protection
	local protection = {}
	for k, v in pairs(common) do protection[k] = v end
	protection["$ignorePainTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.ignorePain.id].buff.isActive
	end
	-- Always renders: a buff that is down shows 0, and one that is up with nothing from the Cooldown
	-- Manager shows "??" rather than dropping out, so the gap is visible instead of silent.
	protection["$ignorePainAbsorb"] = true
	protection["$shieldBlockTime"] = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.shieldBlock.id].buff.isActive
	end
	protection["$shieldBlockCharges"] = function()
		local spells = TRB.Data.spellsData.spells
		local charges = TRB.Data.snapshotData.snapshots[spells.shieldBlock.id].cooldown.charges
		return issecretvalue(charges) or charges > 0
	end
	protection["$shieldBlockMaxCharges"] = function()
		local spells = TRB.Data.spellsData.spells
		local charges = TRB.Data.snapshotData.snapshots[spells.shieldBlock.id].cooldown.charges
		return issecretvalue(charges) or charges > 0
	end

	specValidVars = { [1] = common, [2] = common, [3] = protection }
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
		-- Handle Protection's defensive buff nodes (dynamic mapping from UpdateDefensiveBuffs)
		if TRB.Data.character.specId == 3 then
			local mapping = TRB.Data.defensiveNodeMapping or {}
			if relativeToFrame == "IgnorePainAbsorb" then
				local nodeIndex = mapping["ignorePainAbsorb"]
				if nodeIndex and barGroups and barGroups.defensives then
					local node = barGroups.defensives:GetNode(nodeIndex)
					if node then
						local isVisible = barGroups.defensives.isVisible and node.isVisible
						return node:GetFrame(), true, isVisible
					end
				end
				return nil, true, false
			elseif TRB.Functions.String:StartsWith(relativeToFrame, "IgnorePain") then
				local nodeIndex = mapping["ignorePain"]
				if nodeIndex and barGroups and barGroups.defensives then
					local node = barGroups.defensives:GetNode(nodeIndex)
					if node then
						local isVisible = barGroups.defensives.isVisible and node.isVisible
						return node:GetFrame(), true, isVisible
					end
				end
				return nil, true, false
			elseif TRB.Functions.String:StartsWith(relativeToFrame, "ShieldBlock") then
				local nodeIndex = mapping["shieldBlock"]
				if nodeIndex and barGroups and barGroups.defensives then
					local node = barGroups.defensives:GetNode(nodeIndex)
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

---Returns true when spec-specific buff timers are counting down.
---Arms: no timers; Fury: Whirlwind buff; Protection: Ignore Pain, Shield Block.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local snapshotData = TRB.Data.snapshotData
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
	if not snapshotData or not spells then return false end
	local snapshots = snapshotData.snapshots
	local specId = TRB.Data.character.specId
	if specId == 2 then -- Fury
		if spells.improvedWhirlwind and snapshots[spells.improvedWhirlwind.id] then
			local buff = snapshots[spells.improvedWhirlwind.id].buff
			if buff and buff.isActive then
				return true
			end
		end
	elseif specId == 3 then -- Protection
		if (spells.ignorePain and snapshots[spells.ignorePain.id] and snapshots[spells.ignorePain.id].buff and snapshots[spells.ignorePain.id].buff.isActive)
			or (spells.shieldBlock and snapshots[spells.shieldBlock.id] and snapshots[spells.shieldBlock.id].buff and snapshots[spells.shieldBlock.id].buff.isActive) then
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
