local _, TRB = ...
if TRB.Data.character.classId ~= 9 then --Only do this if we're on an Warlock!
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
	warlock_affliction = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	warlock_demonology = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	warlock_destruction = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Affliction
	specCache.warlock_affliction.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.warlock_affliction.character = {
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
	
	---@type TRB.Classes.Warlock.AfflictionSpells
	specCache.warlock_affliction.spellsData.spells = TRB.Classes.Warlock.AfflictionSpells:New()
	local spells = specCache.warlock_affliction.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	specCache.warlock_affliction.snapshotData.audio = {
		soulShardThreshold1Played = false,
		soulShardThreshold2Played = false,
	}

	specCache.warlock_affliction.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Demonology
	specCache.warlock_demonology.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.warlock_demonology.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 10000,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Warlock.DemonologySpells
	specCache.warlock_demonology.spellsData.spells = TRB.Classes.Warlock.DemonologySpells:New()
	local spells = specCache.warlock_demonology.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]

	specCache.warlock_demonology.snapshotData.audio = {
		soulShardThreshold1Played = false,
		soulShardThreshold2Played = false,
	}

	specCache.warlock_demonology.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Destruction
	specCache.warlock_destruction.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.warlock_destruction.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 10000,
		maxResource2 = 50,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Warlock.DestructionSpells
	specCache.warlock_destruction.spellsData.spells = TRB.Classes.Warlock.DestructionSpells:New()
	local spells = specCache.warlock_destruction.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]

	specCache.warlock_destruction.snapshotData.audio = {
		soulShardThreshold1Played = false,
		soulShardThreshold2Played = false,
	}

	specCache.warlock_destruction.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Affliction()
	Character:FillSpecializationCacheSettings("warlock", "affliction", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warlock_affliction" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Affliction()
	Setup_Affliction()
	specCache.warlock_affliction.spellsData:FillSpellData()
	local spells = specCache.warlock_affliction.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	TRB.Classes.Warlock.AfflictionSpells.FillBarTextVariables(specCache.warlock_affliction)
end

local function Setup_Demonology()
	Character:FillSpecializationCacheSettings("warlock", "demonology", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warlock_demonology" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Demonology()
	Setup_Demonology()
	specCache.warlock_demonology.spellsData:FillSpellData()
	local spells = specCache.warlock_demonology.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]

	TRB.Classes.Warlock.DemonologySpells.FillBarTextVariables(specCache.warlock_demonology)
end



local function Setup_Destruction()
	Character:FillSpecializationCacheSettings("warlock", "destruction", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "warlock_destruction" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Destruction()
	Setup_Destruction()
	specCache.warlock_destruction.spellsData:FillSpellData()
	local spells = specCache.warlock_destruction.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]

	TRB.Classes.Warlock.DestructionSpells.FillBarTextVariables(specCache.warlock_destruction)
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then -- Affliction or Demonology
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

	-- All Warlock specs use Soul Shards as secondary resource
	if barGroups and barGroups.secondary then
		local maxShards = TRB.Data.character.maxResource2
		if maxShards == nil or maxShards == 0 then
			maxShards = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxShards
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

	-- All Warlock specs use Soul Shards secondary bar
	if barGroups and barGroups.secondary then
		local maxShards = TRB.Data.character.maxResource2 or 5
		
		-- Ensure secondary group knows the correct node count
		barGroups.secondary:SetNodeCount(maxShards)
		barGroups.secondary:SetLayout(settings.comboPoints.spacing, Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
		barGroups.secondary:Show()
		
		-- Get effective width for secondary bar, accounting for CDM width matching
		local effectiveWidth, cdmForced = Bar:GetEffectiveWidthForBarGroup(barGroups, settings, "secondary")
		if cdmForced then
			barGroups.secondary.fullWidth = true
		end
		
		-- Apply layout to position all nodes correctly
		barGroups.secondary:ApplyLayout(
			effectiveWidth,
			settings.comboPoints.width,
			settings.comboPoints.height,
			settings.comboPoints.border
		)
		
		-- Set textures and colors for each Soul Shard node
		local frameLevels = TRB.Data.constants.frameLevels
		for i = 1, maxShards do
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

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end


local function RefreshLookupData_Affliction()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local sharedSettings = TRB.Data.specCache["warlock_affliction"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $casting, $manaMax, $resourceMax, $manaPercent, $resourcePercent)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then

		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

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

	-- Block B: Soul Shards ($soulShards, $comboPoints, $soulShardsMax, $comboPointsMax)
	if not activeVars or activeVars["$soulShards"] or activeVars["$comboPoints"]
		or activeVars["$soulShardsMax"] or activeVars["$comboPointsMax"] then
		local normalizedSoulShards = snapshotData.attributes.resource2

		lookupLogic["$soulShards"] = normalizedSoulShards
		lookupLogic["$comboPoints"] = normalizedSoulShards
		lookupLogic["$soulShardsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		-- RAW (unmemoized)
		lookup["$soulShards"] = normalizedSoulShards
		lookup["$comboPoints"] = normalizedSoulShards
		lookup["$soulShardsMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Demonology()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local sharedSettings = TRB.Data.specCache["warlock_demonology"].settings

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
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = manaPercentRaw
		lookupLogic["$resourcePercent"] = manaPercentRaw
		lookupLogic["$casting"] = _castingMana

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

	-- Block B: Soul Shards ($soulShards, $comboPoints, $soulShardsMax, $comboPointsMax)
	if not activeVars or activeVars["$soulShards"] or activeVars["$comboPoints"]
		or activeVars["$soulShardsMax"] or activeVars["$comboPointsMax"] then
		local normalizedSoulShards = snapshotData.attributes.resource2

		lookupLogic["$soulShards"] = normalizedSoulShards
		lookupLogic["$comboPoints"] = normalizedSoulShards
		lookupLogic["$soulShardsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		if lookupChanged(prevState, "$soulShards", normalizedSoulShards, nil, true) then
			local f = string.format("%.0f", normalizedSoulShards)
			lookup["$soulShards"] = f
			lookup["$comboPoints"] = f
		end

		-- RAW (unmemoized)
		lookup["$soulShardsMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Destruction()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local sharedSettings = TRB.Data.specCache["warlock_destruction"].settings

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
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = manaPercentRaw
		lookupLogic["$resourcePercent"] = manaPercentRaw
		lookupLogic["$casting"] = _castingMana

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

	-- Block B: Soul Shards ($soulShards, $comboPoints, $soulShardsMax, $comboPointsMax)
	if not activeVars or activeVars["$soulShards"] or activeVars["$comboPoints"]
		or activeVars["$soulShardsMax"] or activeVars["$comboPointsMax"] then
		local normalizedSoulShards = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor

		lookupLogic["$soulShards"] = normalizedSoulShards
		lookupLogic["$comboPoints"] = normalizedSoulShards
		lookupLogic["$soulShardsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		if lookupChanged(prevState, "$soulShards", normalizedSoulShards, nil, true) then
			local f = string.format("%.1f", normalizedSoulShards)
			lookup["$soulShards"] = f
			lookup["$comboPoints"] = f
		end
		if lookupChanged(prevState, "$soulShardsMax", TRB.Data.character.maxResource2, nil, true) then
			local f = string.format("%.0f", TRB.Data.character.maxResource2)
			lookup["$soulShardsMax"] = f
			lookup["$comboPointsMax"] = f
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateCastingResourceFinal()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal()
		end
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
end

local function UpdateSnapshot_Affliction()
	UpdateSnapshot()
end

local function UpdateSnapshot_Demonology()
	UpdateSnapshot()
end

local function UpdateSnapshot_Destruction()
	UpdateSnapshot()
end

---Processes soul shard threshold audio cues for any Warlock spec
---@param specSettings table The spec-specific settings table containing audio thresholds
local function ProcessSoulShardAudioCues(specSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local coreSettings = TRB.Data.settings.core
	local currentResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
	local threshold1 = specSettings.audio.soulShardThreshold1
	local threshold2 = specSettings.audio.soulShardThreshold2
	local threshold1Value = threshold1.configuration.thresholdValue
	local threshold2Value = threshold2.configuration.thresholdValue

	local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.soulShardThreshold1Played and currentResource2 >= threshold1Value
	local threshold2ShouldFire = threshold2.enabled and not snapshotData.audio.soulShardThreshold2Played and currentResource2 >= threshold2Value

	if threshold1ShouldFire and threshold2ShouldFire then
		snapshotData.audio.soulShardThreshold1Played = true
		snapshotData.audio.soulShardThreshold2Played = true
		if threshold2Value > threshold1Value then
			PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
		else
			PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
		end
	elseif threshold2ShouldFire then
		snapshotData.audio.soulShardThreshold2Played = true
		PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
	elseif threshold1ShouldFire then
		snapshotData.audio.soulShardThreshold1Played = true
		PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
	end

	if currentResource2 < threshold1Value then
		snapshotData.audio.soulShardThreshold1Played = false
	end
	if currentResource2 < threshold2Value then
		snapshotData.audio.soulShardThreshold2Played = false
	end
end

local function UpdateResourceBar()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.warlock
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

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil or snapshotData.attributes.resource2Modified == nil then
		return
	end

	local function UpdateSoulShards(specSettings, specCacheSettings, normalizedResource2)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = specSettings.colors.comboPoints.border.color
			local cpColor = specSettings.colors.comboPoints.base.color
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = normalizedResource2 >= x

			if filled then
				if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate.color
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final.color
				end
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, filled and 1 or 0, 1)
					shardNode:SetBorderColor(cpBorderColor)
					shardNode:SetColor(cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
	end

	local function UpdateSoulShardsAffliction(specSettings, specCacheSettings, normalizedResource2, spells)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = specSettings.colors.comboPoints.border.color
			local cpColor = specSettings.colors.comboPoints.base.color
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = normalizedResource2 >= x

			if filled then
				if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate.color
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final.color
				end
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, filled and 1 or 0, 1)
					shardNode:SetBorderColor(cpBorderColor)
					shardNode:SetColor(cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
	end

	local function UpdateSoulShardsDestruction(specSettings, specCacheSettings, normalizedResource2)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = specSettings.colors.comboPoints.border.color
			local cpColor = specSettings.colors.comboPoints.base.color
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local fillValue = 0

			if normalizedResource2 >= x then
				fillValue = 1
				if (specSettings.comboPoints.sameColor and math.floor(normalizedResource2) == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate.color
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final.color
				end
			elseif normalizedResource2 >= (x - 1) then
				-- Partial fill for Destruction
				fillValue = normalizedResource2 - (x - 1)
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, fillValue, 1)
					shardNode:SetBorderColor(cpBorderColor)
					shardNode:SetColor(cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.affliction
		local specCacheSettings = TRB.Data.specCache.warlock_affliction.settings
		UpdateSnapshot_Affliction()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShardsAffliction(specSettings, specCacheSettings, normalizedResource2, spells)
			end

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
		end

		-- Soul Shard threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessSoulShardAudioCues(specSettings)
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.demonology
		local specCacheSettings = TRB.Data.specCache.warlock_demonology.settings
		UpdateSnapshot_Demonology()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShards(specSettings, specCacheSettings, normalizedResource2)
			end

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
		end

		-- Soul Shard threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessSoulShardAudioCues(specSettings)
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.destruction
		local specCacheSettings = TRB.Data.specCache.warlock_destruction.settings
		UpdateSnapshot_Destruction()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShardsDestruction(specSettings, specCacheSettings, normalizedResource2)
			end

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
		end

		-- Soul Shard threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessSoulShardAudioCues(specSettings)
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
		specCache.warlock_affliction.talents:GetTalents()
		FillSpellData_Affliction()
		Character:LoadFromSpecializationCache(specCache.warlock_affliction)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Affliction
		Bar:UpdateSanityCheckValues(specCache.warlock_affliction.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "warlock_affliction" then
			talents = specCache.warlock_affliction.talents
			TRB.Data.barConstructedForSpec = "warlock_affliction"
			ConstructResourceBar(specCache.warlock_affliction.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.warlock_demonology.talents:GetTalents()
		FillSpellData_Demonology()
		Character:LoadFromSpecializationCache(specCache.warlock_demonology)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Demonology
		Bar:UpdateSanityCheckValues(specCache.warlock_demonology.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "warlock_demonology" then
			talents = specCache.warlock_demonology.talents
			TRB.Data.barConstructedForSpec = "warlock_demonology"
			ConstructResourceBar(specCache.warlock_demonology.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.warlock_destruction.talents:GetTalents()
		FillSpellData_Destruction()
		Character:LoadFromSpecializationCache(specCache.warlock_destruction)
		
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Destruction
		Bar:UpdateSanityCheckValues(specCache.warlock_destruction.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "warlock_destruction" then
			talents = specCache.warlock_destruction.talents
			TRB.Data.barConstructedForSpec = "warlock_destruction"
			ConstructResourceBar(specCache.warlock_destruction.settings)
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
	
	if TRB.Data.character.classId == 9 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Warlock.LoadDefaultSettings(false)

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.affliction == nil or
						TwintopInsanityBarSettings.warlock.affliction.displayText == nil) then
						settings.warlock.affliction.displayText.barText = TRB.Options.Warlock.AfflictionLoadDefaultBarTextSettings()
					end

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.demonology == nil or
						TwintopInsanityBarSettings.warlock.demonology.displayText == nil) then
						settings.warlock.demonology.displayText.barText = TRB.Options.Warlock.DemonologyLoadDefaultBarTextSettings()
					end

					if (TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.destruction == nil or
						TwintopInsanityBarSettings.warlock.destruction.displayText == nil) then
						settings.warlock.destruction.displayText.barText = TRB.Options.Warlock.DestructionLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.warlock ~= true then
						TRB.Data.settings.warlock.affliction.displayText.barText = TRB.Options.Warlock.AfflictionLoadDefaultBarTextSettings()
						TRB.Data.settings.warlock.demonology.displayText.barText = TRB.Options.Warlock.DemonologyLoadDefaultBarTextSettings()
						TRB.Data.settings.warlock.destruction.displayText.barText = TRB.Options.Warlock.DestructionLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.warlock = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Warlock"])
					end
				else
					local settings = TRB.Options.Warlock.LoadDefaultSettings(true)
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
						TRB.Data.settings.warlock.affliction = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarlockAfflictionFull"], TRB.Data.settings.warlock.affliction)
						TRB.Data.settings.warlock.demonology = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarlockDemonologyFull"], TRB.Data.settings.warlock.demonology)
						TRB.Data.settings.warlock.destruction = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["WarlockDestructionFull"], TRB.Data.settings.warlock.destruction)

						FillSpellData_Affliction()
						FillSpellData_Demonology()
						FillSpellData_Destruction()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Warlock.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "warlock"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", TRB.Data.resource, false)
	TRB.Data.character.maxResource2 = UnitPowerMax("player", TRB.Data.resource2, false)
	TRB.Data.character.maxResource2Modified = UnitPowerMax("player", TRB.Data.resource2, true)
	TRB.Data.resource2 = Enum.PowerType.SoulShards
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2, false)
	local oldMaxResource2 = TRB.Data.character.maxResource2
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "affliction"
		TRB.Data.character.compositeKey = "warlock_affliction"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "demonology"
		TRB.Data.character.compositeKey = "warlock_demonology"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "destruction"
		TRB.Data.character.compositeKey = "warlock_destruction"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	end

	if sharedSettings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
			if barGroups and barGroups.secondary then
				barGroups.secondary:Show()
				Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
				Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.warlock.affliction == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.warlock.demonology == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.warlock.destruction == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
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
		["$comboPoints"] = true, ["$soulShards"] = true,
		["$comboPointsMax"] = true, ["$soulShardsMax"] = true,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true,
	}
	specValidVars = { [1] = shared, [2] = shared, [3] = shared }
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

	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local shardNode = barGroups.secondary:GetNode(comboPoint)
			if shardNode then
				local isVisible = barGroups.secondary.isVisible and shardNode.isVisible
				return shardNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	if normalizedRelativeFrame == "HealthBar" then
		if barGroups.health then
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