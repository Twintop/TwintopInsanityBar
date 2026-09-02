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

	---@type TRB.Classes.Snapshot
	-- Always simple: this buff never has a knowable endTime. Its remaining time is a secret we can
	-- render but not subtract, so normal time tracking would see a nil endTime and clear isActive on
	-- the very next tick. Simple mode leaves isActive alone for our own signals to drive.
	specCache.warlock_affliction.snapshotData.snapshots[spells.shardInstability.id] = TRB.Classes.Snapshot:New(spells.shardInstability, nil, "always")

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

	---@type TRB.Classes.Snapshot
	specCache.warlock_demonology.snapshotData.snapshots[spells.dominionOfArgus.id] = TRB.Classes.Snapshot:New(spells.dominionOfArgus)
	---@type TRB.Classes.Snapshot
	-- Always simple: the Demonbolt glow says a proc exists but not when it started, and it does not
	-- fire again as stacks are added, so there is no application time to count from. Without an
	-- endTime the normal path reads the buff as expired and clears it a tick later.
	specCache.warlock_demonology.snapshotData.snapshots[spells.demonicCore.id] = TRB.Classes.Snapshot:New(spells.demonicCore, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.warlock_demonology.snapshotData.snapshots[spells.infernalBolt.id] = TRB.Classes.Snapshot:New(spells.infernalBolt)
	---@type TRB.Classes.Snapshot
	specCache.warlock_demonology.snapshotData.snapshots[spells.ruination.id] = TRB.Classes.Snapshot:New(spells.ruination)

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

	---@type TRB.Classes.Snapshot
	specCache.warlock_destruction.snapshotData.snapshots[spells.infernalBolt.id] = TRB.Classes.Snapshot:New(spells.infernalBolt)
	---@type TRB.Classes.Snapshot
	specCache.warlock_destruction.snapshotData.snapshots[spells.ruination.id] = TRB.Classes.Snapshot:New(spells.ruination)

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
		Bar:ApplySecondaryBarGroupLayout(settings, barGroups, maxShards)
		barGroups.secondary:Show()
		
		-- Set textures and colors for each Soul Shard node
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
				TRB.Functions.Color:ApplyFillColor(node, settings.colors.comboPoints.base)
				node:SetFrameLevel(TRB.Functions.Bar:GetBarFrameLevel("secondary"))
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

	-- Block C: Casting Soul Shard Fragments ($castingFragments, $castingShards, $castingSoulShards)
	if not activeVars or activeVars["$castingFragments"] or activeVars["$castingShards"] or activeVars["$castingSoulShards"] then
		local castingFragmentsColor = sharedSettings.colors.text.casting.color
		local castingFragments = (snapshotData.casting.resource2Casting or 0) + (snapshotData.casting.resource2Spending or 0)

		lookupLogic["$castingFragments"] = castingFragments
		lookupLogic["$castingShards"] = castingFragments
		lookupLogic["$castingSoulShards"] = castingFragments

		if lookupChanged(prevState, "$castingFragments", castingFragments, castingFragmentsColor) then
			local f = string.format("|c%s%.1f|r", castingFragmentsColor, castingFragments)
			lookup["$castingFragments"] = f
			lookup["$castingShards"] = f
			lookup["$castingSoulShards"] = f
		end
	end

	-- Block D: Shard Instability ($shardInstabilityTime, $shardInstabilityStacks, $shardInstabilityMaxStacks)
	if not activeVars or activeVars["$shardInstabilityTime"] or activeVars["$shardInstabilityStacks"] or activeVars["$shardInstabilityMaxStacks"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
		local shardInstabilityBuff = snapshotData.snapshots[spells.shardInstability.id].buff
		local _shardInstabilityActive = shardInstabilityBuff.isActive == true
		local properties = shardInstabilityBuff.customProperties
		local _shardInstabilityStacks = properties.stacks
		local _shardInstabilityTime = properties.remaining
		local _shardInstabilityTimeText = properties.remainingText

		-- Both values are secret when the Cooldown Manager has them and missing entirely when it does
		-- not, so logic never learns more than whether there is a value at all. Max stacks is a plain
		-- constant from the spell data and stays a real number.
		lookupLogic["$shardInstabilityStacks"] = _shardInstabilityActive and _shardInstabilityStacks ~= nil
		lookupLogic["$shardInstabilityTime"] = _shardInstabilityActive and (_shardInstabilityTime ~= nil or _shardInstabilityTimeText ~= nil)
		lookupLogic["$shardInstabilityMaxStacks"] = spells.shardInstability.maxStacks

		-- Absent for two different reasons: a proc that is down is a known zero, a proc that is up
		-- with nothing tracking it in the Cooldown Manager is unknown. Memoized on the rendered
		-- string rather than the value, so those two -- both nil underneath -- still repaint when
		-- one becomes the other.
		local stacksDisplay
		if not _shardInstabilityActive then
			stacksDisplay = string.format("%.0f", 0)
		elseif _shardInstabilityStacks ~= nil then
			stacksDisplay = string.format("%.0f", _shardInstabilityStacks)
		else
			stacksDisplay = TRB.Functions.BarText:UnknownValue(string.format("%.0f", 0))
		end

		local timeDisplay
		if not _shardInstabilityActive then
			timeDisplay = TRB.Functions.BarText:TimerPrecision(0)
		elseif _shardInstabilityTime ~= nil then
			timeDisplay = TRB.Functions.BarText:TimerPrecision(_shardInstabilityTime)
		elseif _shardInstabilityTimeText ~= nil then
			-- Already formatted for us, and to the viewer's precision rather than ours.
			timeDisplay = _shardInstabilityTimeText
		else
			timeDisplay = TRB.Functions.BarText:UnknownValue(TRB.Functions.BarText:TimerPrecision(0))
		end

		if lookupChanged(prevState, "$shardInstabilityStacks", stacksDisplay) then
			lookup["$shardInstabilityStacks"] = stacksDisplay
		end
		if lookupChanged(prevState, "$shardInstabilityTime", timeDisplay) then
			lookup["$shardInstabilityTime"] = timeDisplay
		end
		if lookupChanged(prevState, "$shardInstabilityMaxStacks", spells.shardInstability.maxStacks) then
			lookup["$shardInstabilityMaxStacks"] = string.format("%.0f", spells.shardInstability.maxStacks)
		end
	end

	-- Block E: Soul Shards Plus Casting ($soulShardsPlusCasting, $comboPointsPlusCasting)
	if not activeVars or activeVars["$soulShardsPlusCasting"] or activeVars["$comboPointsPlusCasting"] then
		local soulShardsPlusCastingColor = sharedSettings.colors.text.casting.color
		local soulShardsPlusCasting = snapshotData.attributes.resource2 + (snapshotData.casting.resource2Casting or 0) + (snapshotData.casting.resource2Spending or 0)

		lookupLogic["$soulShardsPlusCasting"] = soulShardsPlusCasting
		lookupLogic["$comboPointsPlusCasting"] = soulShardsPlusCasting

		if lookupChanged(prevState, "$soulShardsPlusCasting", soulShardsPlusCasting, soulShardsPlusCastingColor) then
			local f = string.format("|c%s%.0f|r", soulShardsPlusCastingColor, soulShardsPlusCasting)
			lookup["$soulShardsPlusCasting"] = f
			lookup["$comboPointsPlusCasting"] = f
		end
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

		if lookupChanged(prevState, "$soulShards", normalizedSoulShards) then
			local f = string.format("%.0f", normalizedSoulShards)
			lookup["$soulShards"] = f
			lookup["$comboPoints"] = f
		end

		-- RAW (unmemoized)
		lookup["$soulShardsMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Casting Soul Shard Fragments ($castingFragments, $castingShards, $castingSoulShards)
	if not activeVars or activeVars["$castingFragments"] or activeVars["$castingShards"] or activeVars["$castingSoulShards"] then
		local castingFragmentsColor = sharedSettings.colors.text.casting.color
		local castingFragments = (snapshotData.casting.resource2Casting or 0) + (snapshotData.casting.resource2Spending or 0)

		lookupLogic["$castingFragments"] = castingFragments
		lookupLogic["$castingShards"] = castingFragments
		lookupLogic["$castingSoulShards"] = castingFragments

		if lookupChanged(prevState, "$castingFragments", castingFragments, castingFragmentsColor) then
			local f = string.format("|c%s%.1f|r", castingFragmentsColor, castingFragments)
			lookup["$castingFragments"] = f
			lookup["$castingShards"] = f
			lookup["$castingSoulShards"] = f
		end
	end

	-- Block D: Demonic Core ($demonicCoreTime, $demonicCoreStacks, $demonicCoreMaxStacks)
	if not activeVars or activeVars["$demonicCoreTime"] or activeVars["$demonicCoreStacks"] or activeVars["$demonicCoreMaxStacks"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
		local demonicCoreBuff = snapshotData.snapshots[spells.demonicCore.id].buff
		local _demonicCoreActive = demonicCoreBuff.isActive == true
		local properties = demonicCoreBuff.customProperties
		local _demonicCoreStacks = properties.stacks
		local _demonicCoreTime = properties.remaining
		local _demonicCoreTimeText = properties.remainingText

		-- Both values are secret when the Cooldown Manager has them and missing entirely when it does
		-- not, so logic never learns more than whether there is a value at all. Max stacks is a plain
		-- constant from the spell data and stays a real number.
		lookupLogic["$demonicCoreStacks"] = _demonicCoreActive and _demonicCoreStacks ~= nil
		lookupLogic["$demonicCoreTime"] = _demonicCoreActive and (_demonicCoreTime ~= nil or _demonicCoreTimeText ~= nil)
		lookupLogic["$demonicCoreMaxStacks"] = spells.demonicCore.maxStacks

		-- Absent for two different reasons: a proc that is down is a known zero, a proc that is up
		-- with nothing tracking it in the Cooldown Manager is unknown. Memoized on the rendered
		-- string rather than the value, so those two -- both nil underneath -- still repaint when
		-- one becomes the other.
		local stacksDisplay
		if not _demonicCoreActive then
			stacksDisplay = string.format("%.0f", 0)
		elseif _demonicCoreStacks ~= nil then
			stacksDisplay = string.format("%.0f", _demonicCoreStacks)
		else
			stacksDisplay = TRB.Functions.BarText:UnknownValue(string.format("%.0f", 0))
		end

		local timeDisplay
		if not _demonicCoreActive then
			timeDisplay = TRB.Functions.BarText:TimerPrecision(0)
		elseif _demonicCoreTime ~= nil then
			timeDisplay = TRB.Functions.BarText:TimerPrecision(_demonicCoreTime)
		elseif _demonicCoreTimeText ~= nil then
			-- Already formatted for us, and to the viewer's precision rather than ours.
			timeDisplay = _demonicCoreTimeText
		else
			timeDisplay = TRB.Functions.BarText:UnknownValue(TRB.Functions.BarText:TimerPrecision(0))
		end

		if lookupChanged(prevState, "$demonicCoreStacks", stacksDisplay) then
			lookup["$demonicCoreStacks"] = stacksDisplay
		end
		if lookupChanged(prevState, "$demonicCoreTime", timeDisplay) then
			lookup["$demonicCoreTime"] = timeDisplay
		end
		if lookupChanged(prevState, "$demonicCoreMaxStacks", spells.demonicCore.maxStacks) then
			lookup["$demonicCoreMaxStacks"] = string.format("%.0f", spells.demonicCore.maxStacks)
		end
	end

	-- Block E: Dominion of Argus ($doaTime)
	if not activeVars or activeVars["$doaTime"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
		local currentTime = GetTime()
		local doaBuff = snapshotData.snapshots[spells.dominionOfArgus.id]
		local _doaActive = (doaBuff ~= nil and doaBuff.buff.isActive) or false

		lookupLogic["$doaTime"] = _doaActive

		if _doaActive then
			local _doaTime = doaBuff.buff:GetRemainingTime(currentTime)
			if lookupChanged(prevState, "$doaTime", _doaTime, nil) then
				lookup["$doaTime"] = TRB.Functions.BarText:TimerPrecision(_doaTime)
			end
		else
			-- When Dominion of Argus is not active, display a zeroed default that
			-- respects the user's timer precision setting ("0.0" by default).
			if lookupChanged(prevState, "$doaTime", 0) then
				lookup["$doaTime"] = TRB.Functions.BarText:TimerPrecision(0)
			end
		end
	end

	-- Block F: Infernal Bolt ($infernalBoltTime) - 20s proc countdown set on glow detection
	if not activeVars or activeVars["$infernalBoltTime"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
		local currentTime = GetTime()
		local infernalBoltBuff = snapshotData.snapshots[spells.infernalBolt.id]
		local _infernalBoltActive = (infernalBoltBuff ~= nil and infernalBoltBuff.buff.isActive) or false

		lookupLogic["$infernalBoltTime"] = _infernalBoltActive

		if _infernalBoltActive then
			local _infernalBoltTime = infernalBoltBuff.buff:GetRemainingTime(currentTime)
			if lookupChanged(prevState, "$infernalBoltTime", _infernalBoltTime, nil) then
				lookup["$infernalBoltTime"] = TRB.Functions.BarText:TimerPrecision(_infernalBoltTime)
			end
		else
			if lookupChanged(prevState, "$infernalBoltTime", 0) then
				lookup["$infernalBoltTime"] = TRB.Functions.BarText:TimerPrecision(0)
			end
		end
	end

	-- Block G: Ruination ($ruinationTime) - 20s proc countdown set on glow detection
	if not activeVars or activeVars["$ruinationTime"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
		local currentTime = GetTime()
		local ruinationBuff = snapshotData.snapshots[spells.ruination.id]
		local _ruinationActive = (ruinationBuff ~= nil and ruinationBuff.buff.isActive) or false

		lookupLogic["$ruinationTime"] = _ruinationActive

		if _ruinationActive then
			local _ruinationTime = ruinationBuff.buff:GetRemainingTime(currentTime)
			if lookupChanged(prevState, "$ruinationTime", _ruinationTime, nil) then
				lookup["$ruinationTime"] = TRB.Functions.BarText:TimerPrecision(_ruinationTime)
			end
		else
			if lookupChanged(prevState, "$ruinationTime", 0) then
				lookup["$ruinationTime"] = TRB.Functions.BarText:TimerPrecision(0)
			end
		end
	end

	-- Block H: Soul Shards Plus Casting ($soulShardsPlusCasting, $comboPointsPlusCasting)
	if not activeVars or activeVars["$soulShardsPlusCasting"] or activeVars["$comboPointsPlusCasting"] then
		local soulShardsPlusCastingColor = sharedSettings.colors.text.casting.color
		local soulShardsPlusCasting = snapshotData.attributes.resource2 + (snapshotData.casting.resource2Casting or 0) + (snapshotData.casting.resource2Spending or 0)

		lookupLogic["$soulShardsPlusCasting"] = soulShardsPlusCasting
		lookupLogic["$comboPointsPlusCasting"] = soulShardsPlusCasting

		if lookupChanged(prevState, "$soulShardsPlusCasting", soulShardsPlusCasting, soulShardsPlusCastingColor) then
			local f = string.format("|c%s%.0f|r", soulShardsPlusCastingColor, soulShardsPlusCasting)
			lookup["$soulShardsPlusCasting"] = f
			lookup["$comboPointsPlusCasting"] = f
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Destruction()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local sharedSettings = TRB.Data.specCache["warlock_destruction"].settings
	local castingFragments = (snapshotData.casting.resource2Casting or 0) + (snapshotData.casting.resource2Spending or 0)

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

		if lookupChanged(prevState, "$soulShards", normalizedSoulShards) then
			local f = string.format("%.1f", normalizedSoulShards)
			lookup["$soulShards"] = f
			lookup["$comboPoints"] = f
		end
		if lookupChanged(prevState, "$soulShardsMax", TRB.Data.character.maxResource2) then
			local f = string.format("%.0f", TRB.Data.character.maxResource2)
			lookup["$soulShardsMax"] = f
			lookup["$comboPointsMax"] = f
		end
	end

	-- Block C: Casting Soul Shard Fragments ($castingFragments, $castingShards, $castingSoulShards)
	if not activeVars or activeVars["$castingFragments"] or activeVars["$castingShards"] or activeVars["$castingSoulShards"] then
		local castingFragmentsColor = sharedSettings.colors.text.casting.color
		local normalizedCastingFragments = castingFragments / TRB.Data.resource2Factor

		lookupLogic["$castingFragments"] = normalizedCastingFragments
		lookupLogic["$castingShards"] = normalizedCastingFragments
		lookupLogic["$castingSoulShards"] = normalizedCastingFragments

		if lookupChanged(prevState, "$castingFragments", normalizedCastingFragments, castingFragmentsColor) then
			local f = string.format("|c%s%.1f|r", castingFragmentsColor, normalizedCastingFragments)
			lookup["$castingFragments"] = f
			lookup["$castingShards"] = f
			lookup["$castingSoulShards"] = f
		end
	end

	-- Block D: Infernal Bolt ($infernalBoltTime) - 20s proc countdown set on glow detection
	if not activeVars or activeVars["$infernalBoltTime"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
		local currentTime = GetTime()
		local infernalBoltBuff = snapshotData.snapshots[spells.infernalBolt.id]
		local _infernalBoltActive = (infernalBoltBuff ~= nil and infernalBoltBuff.buff.isActive) or false

		lookupLogic["$infernalBoltTime"] = _infernalBoltActive

		if _infernalBoltActive then
			local _infernalBoltTime = infernalBoltBuff.buff:GetRemainingTime(currentTime)
			if lookupChanged(prevState, "$infernalBoltTime", _infernalBoltTime, nil) then
				lookup["$infernalBoltTime"] = TRB.Functions.BarText:TimerPrecision(_infernalBoltTime)
			end
		else
			if lookupChanged(prevState, "$infernalBoltTime", 0) then
				lookup["$infernalBoltTime"] = TRB.Functions.BarText:TimerPrecision(0)
			end
		end
	end

	-- Block E: Ruination ($ruinationTime) - 20s proc countdown set on glow detection
	if not activeVars or activeVars["$ruinationTime"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
		local currentTime = GetTime()
		local ruinationBuff = snapshotData.snapshots[spells.ruination.id]
		local _ruinationActive = (ruinationBuff ~= nil and ruinationBuff.buff.isActive) or false

		lookupLogic["$ruinationTime"] = _ruinationActive

		if _ruinationActive then
			local _ruinationTime = ruinationBuff.buff:GetRemainingTime(currentTime)
			if lookupChanged(prevState, "$ruinationTime", _ruinationTime, nil) then
				lookup["$ruinationTime"] = TRB.Functions.BarText:TimerPrecision(_ruinationTime)
			end
		else
			if lookupChanged(prevState, "$ruinationTime", 0) then
				lookup["$ruinationTime"] = TRB.Functions.BarText:TimerPrecision(0)
			end
		end
	end

	-- Block F: Soul Shards Plus Casting ($soulShardsPlusCasting, $comboPointsPlusCasting)
	if not activeVars or activeVars["$soulShardsPlusCasting"] or activeVars["$comboPointsPlusCasting"] then
		local soulShardsPlusCastingColor = sharedSettings.colors.text.casting.color
		local soulShardsPlusCasting = (snapshotData.attributes.resource2Modified + castingFragments) / TRB.Data.resource2Factor

		lookupLogic["$soulShardsPlusCasting"] = soulShardsPlusCasting
		lookupLogic["$comboPointsPlusCasting"] = soulShardsPlusCasting

		if lookupChanged(prevState, "$soulShardsPlusCasting", soulShardsPlusCasting, soulShardsPlusCastingColor) then
			local f = string.format("|c%s%.1f|r", soulShardsPlusCastingColor, soulShardsPlusCasting)
			lookup["$soulShardsPlusCasting"] = f
			lookup["$comboPointsPlusCasting"] = f
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateCastingResourceFinal_Affliction()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	casting.resourceFinal = casting.resourceRaw
	casting.resource2Casting = 0
	casting.resource2Spending = 0
	casting.resource2Refunding = 0

	if casting.spellId == spells.seedOfCorruption.id then
		casting.resource2Spending = spells.seedOfCorruption.resource
	elseif casting.spellId == spells.unstableAffliction.id then
		casting.resource2Spending = spells.unstableAffliction.resource
	elseif casting.spellId == spells.darkHarvest.id and talents:IsTalentActive(spells.shadowOfDeath) then
		casting.resource2Casting = spells.shadowOfDeath.resource
	end
end

local function UpdateCastingResourceFinal_Demonology()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	casting.resourceFinal = casting.resourceRaw
	casting.resource2Casting = 0
	casting.resource2Spending = 0
	casting.resource2Refunding = 0

	if casting.spellId == spells.shadowBolt.id then
		casting.resource2Casting = spells.shadowBolt.resource
	elseif casting.spellId == spells.demonbolt.id then
		casting.resource2Casting = spells.demonbolt.resource
	elseif casting.spellId == spells.infernalBolt.id then
		casting.resource2Casting = spells.infernalBolt.resource
	elseif casting.spellId == spells.ruination.id then
		casting.resource2Casting = spells.ruination.resource
	elseif casting.spellId == spells.summonDemonicTyrant.id and talents:IsTalentActive(spells.shadowOfDeath) then
		casting.resource2Casting = spells.shadowOfDeath.resource
	elseif casting.spellId == spells.handOfGuldan.id then
		local mod = 0
		local dominionOfArgusTalent = talents.talents[spells.dominionOfArgus.talentId] or talents.talents[spells.dominionOfArgus2.talentId] or talents.talents[spells.dominionOfArgus3.talentId]
		if snapshotData.snapshots[spells.dominionOfArgus.id].buff.isActive and dominionOfArgusTalent and dominionOfArgusTalent.currentRank == dominionOfArgusTalent.maxRank then
			mod = spells.demonicCalling.attributes.resourceMod
			casting.resource2Refunding = mod -- Dominion of Argus refunds 1 Soul Shard on Hand of Gul'dan
		end
		casting.resource2Spending = spells.handOfGuldan.resource + mod
	elseif casting.spellId == spells.summonFelguard.id then
		casting.resource2Spending = spells.summonFelguard.resource
	elseif casting.spellId == spells.callDreadstalkers.id then
		local demonicCallingTalent = talents.talents[spells.demonicCalling.talentId]
		local mod = 0
		if demonicCallingTalent ~= nil and demonicCallingTalent.currentRank ~= nil then
			mod = spells.demonicCalling.attributes.resourceMod * demonicCallingTalent.currentRank
		end
		casting.resource2Spending = spells.callDreadstalkers.resource + mod
	end
end

local function UpdateCastingResourceFinal_Destruction()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	casting.resourceFinal = casting.resourceRaw
	casting.resource2Casting = 0
	casting.resource2Spending = 0
	casting.resource2Refunding = 0

	if casting.spellId == spells.incinerate.id then
		if talents:IsTalentActive(spells.diabolicEmbers) then
			casting.resource2Casting = spells.incinerate.resource + spells.diabolicEmbers.attributes.resourceMod
		else
			casting.resource2Casting = spells.incinerate.resource
		end
	elseif casting.spellId == spells.soulFire.id then
		casting.resource2Casting = spells.soulFire.resource
	elseif casting.spellId == spells.infernalBolt.id then
		casting.resource2Casting = spells.infernalBolt.resource
	elseif casting.spellId == spells.chaosBolt.id then
		casting.resource2Spending = spells.chaosBolt.resource
	end
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting

	if TRB.Data.character.specId == 1 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_START" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Affliction()
		end
	elseif TRB.Data.character.specId == 2 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Demonology()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			 -- Handle instant-cast spells that generate resources on cast success rather than cast start
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
			if spellId == spells.summonDemonicTyrant.id then
				if talents:IsTalentActive(spells.dominionOfArgus) or talents:IsTalentActive(spells.dominionOfArgus2) or talents:IsTalentActive(spells.dominionOfArgus3) then
					local duration = spells.dominionOfArgus.duration
					local dominionOfArgusTalent = talents.talents[spells.dominionOfArgus.talentId] or talents.talents[spells.dominionOfArgus2.talentId] or talents.talents[spells.dominionOfArgus3.talentId]
					if dominionOfArgusTalent and dominionOfArgusTalent.currentRank > 1 then
						duration = duration + math.min(dominionOfArgusTalent.currentRank - 1, 2) * spells.dominionOfArgus.attributes.durationMod
					end
					snapshotData.snapshots[spells.dominionOfArgus.id].buff:InitializeCustom(duration, GetTime(), true)
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Destruction()
		end
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
end

local function UpdateSnapshot_Affliction()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local shardInstabilityBuff = snapshotData.snapshots[spells.shardInstability.id].buff

	local properties = shardInstabilityBuff.customProperties
	properties.stacks = nil
	properties.remaining = nil
	properties.remainingText = nil

	-- Pinned to the buff viewers, which describe the aura -- a cooldown viewer would describe the
	-- cast instead. Which ID the entry answers to depends on how it was configured, so offer both.
	local cdm = TRB.Functions.CooldownManager
	local trackedId = cdm:ResolveTrackedSpellId(cdm.SourceGroup.BUFF, spells.shardInstability.buffId, spells.shardInstability.id)
	if trackedId == nil then
		-- Nothing tracking it, so the Unstable Affliction button glow is the only signal left. It
		-- carries no stacks or duration, which is what the bar text renders as "??".
		return
	end

	-- Once the Cooldown Manager holds the buff it is authoritative, because its item follows the
	-- real aura while the glow only reports that a proc appeared. The applications read doubles as
	-- the up-signal: Blizzard drops the cached aura record the moment the aura ends, so the count
	-- and the buff's existence always arrive together.
	local wasActive = shardInstabilityBuff.isActive
	local stacksOk, stacks = cdm:Read(trackedId, cdm.Signal.APPLICATIONS, cdm.SourceGroup.BUFF)
	if stacksOk then
		properties.stacks = stacks
		shardInstabilityBuff:InitializeCustomSimple(true)

		-- The bar viewer is the only one where Blizzard subtracts expiry from now, leaving a number
		-- we can render at the user's own precision. Elsewhere the best on offer is the countdown
		-- Blizzard already formatted, which is empty while that viewer's timers are switched off --
		-- a settings answer, not a value, so it is discarded when plain-empty.
		local remainingOk, remaining = cdm:Read(trackedId, cdm.Signal.REMAINING, cdm.SourceKind.BUFF_BAR)
		if remainingOk then
			properties.remaining = remaining
		else
			local textOk, remainingText = cdm:Read(trackedId, cdm.Signal.REMAINING_TEXT, cdm.SourceGroup.BUFF)
			if textOk and remainingText ~= nil and (issecretvalue(remainingText) or remainingText ~= "") then
				properties.remainingText = remainingText
			end
		end
	elseif wasActive then
		shardInstabilityBuff:Reset()
	end

	if wasActive ~= shardInstabilityBuff.isActive then
		TRB.Data.lookupDirty = true
	end
end

local function UpdateSnapshot_Demonology()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.snapshots[spells.dominionOfArgus.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.infernalBolt.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.ruination.id].buff:GetRemainingTime(currentTime)

	local demonicCoreBuff = snapshotData.snapshots[spells.demonicCore.id].buff
	local properties = demonicCoreBuff.customProperties
	properties.stacks = nil
	properties.remaining = nil
	properties.remainingText = nil

	-- Pinned to the buff viewers, which describe the aura -- a cooldown viewer would describe the
	-- cast instead. Which ID the entry answers to depends on how it was configured, so offer both.
	local cdm = TRB.Functions.CooldownManager
	local trackedId = cdm:ResolveTrackedSpellId(cdm.SourceGroup.BUFF, spells.demonicCore.buffId, spells.demonicCore.id)
	if trackedId == nil then
		-- Nothing tracking it, so the Demonbolt button glow is the only signal left. It carries no
		-- stacks or duration, which is what the bar text renders as "??".
		return
	end

	-- Once the Cooldown Manager holds the buff it is authoritative, because its item follows the
	-- real aura while the glow only reports that a proc appeared: it stays lit unchanged as stacks
	-- come and go. The applications read doubles as the up-signal, since Blizzard drops the cached
	-- aura record the moment the aura ends.
	local wasActive = demonicCoreBuff.isActive
	local stacksOk, stacks = cdm:Read(trackedId, cdm.Signal.APPLICATIONS, cdm.SourceGroup.BUFF)
	if stacksOk then
		properties.stacks = stacks
		demonicCoreBuff:InitializeCustomSimple(true)

		-- The bar viewer is the only one where Blizzard subtracts expiry from now, leaving a number
		-- we can render at the user's own precision. Elsewhere the best on offer is the countdown
		-- Blizzard already formatted, which is empty while that viewer's timers are switched off --
		-- a settings answer, not a value, so it is discarded when plain-empty.
		local remainingOk, remaining = cdm:Read(trackedId, cdm.Signal.REMAINING, cdm.SourceKind.BUFF_BAR)
		if remainingOk then
			properties.remaining = remaining
		else
			local textOk, remainingText = cdm:Read(trackedId, cdm.Signal.REMAINING_TEXT, cdm.SourceGroup.BUFF)
			if textOk and remainingText ~= nil and (issecretvalue(remainingText) or remainingText ~= "") then
				properties.remainingText = remainingText
			end
		end
	elseif wasActive then
		demonicCoreBuff:Reset()
		-- The glow arms the sound and its hide event disarms it. When the Cooldown Manager is the one
		-- that sees the buff end, rearm here so the next proc is still audible.
		TRB.Functions.AudioCues:ResetLatch(snapshotData, "demonicCore")
	end

	if wasActive ~= demonicCoreBuff.isActive then
		TRB.Data.lookupDirty = true
	end
end

local function UpdateSnapshot_Destruction()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.snapshots[spells.infernalBolt.id].buff:GetRemainingTime(currentTime)
	snapshotData.snapshots[spells.ruination.id].buff:GetRemainingTime(currentTime)
end

---Processes Soul Shard threshold audio cues for any Warlock spec
---@param specSettings table The spec-specific settings table containing audio cues
local function ProcessSoulShardAudioCues(specSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, "soulShards", snapshotData.attributes.resource2)
end


---Updates data based on spell events
local function HandleSpellEvents(self, event, ...)
	if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 1 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
			if spellId == spells.unstableAffliction.id then -- Shard Instability proc glows the Unstable Affliction button
				local shardInstabilitySnapshot = snapshotData.snapshots[spells.shardInstability.id]
				if shardInstabilitySnapshot ~= nil then
					-- No duration or stacks knowable; active until GLOW_HIDE
					shardInstabilitySnapshot.buff:InitializeCustomSimple(true)
				end
			end
		elseif TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
			if spellId == spells.demonbolt.id then -- Demonic Core
				local demonicCoreSnapshot = snapshotData.snapshots[spells.demonicCore.id]
				if demonicCoreSnapshot ~= nil then
					-- Gated on the sound flag alone rather than on isActive, which the Cooldown Manager
					-- may already have set from the same proc a tick earlier.
					TRB.Functions.AudioCues:Fire(TRB.Data.settings.warlock.demonology, snapshotData, "demonicCore", true)

					-- No stacks or duration knowable from a glow; active until GLOW_HIDE
					demonicCoreSnapshot.buff:InitializeCustomSimple(true)
				end
			elseif spellId == spells.shadowBolt.id then -- Infernal Bolt proc glows the Shadow Bolt button
				local infernalBoltSnapshot = snapshotData.snapshots[spells.infernalBolt.id]
				if infernalBoltSnapshot ~= nil then
					local wasActive = infernalBoltSnapshot.buff.isActive

					if not wasActive then
						TRB.Functions.AudioCues:Fire(TRB.Data.settings.warlock.demonology, snapshotData, "infernalBolt", true)
					end

					-- Infernal Bolt proc has no real aura; start a 20s custom timer (early consume handled by GLOW_HIDE).
					infernalBoltSnapshot.buff:InitializeCustom(spells.infernalBolt.duration, GetTime(), false)
				end
			elseif spellId == spells.ruination.id then -- Ruination proc glows the Ruination button
				local ruinationSnapshot = snapshotData.snapshots[spells.ruination.id]
				if ruinationSnapshot ~= nil then
					local wasActive = ruinationSnapshot.buff.isActive

					if not wasActive then
						TRB.Functions.AudioCues:Fire(TRB.Data.settings.warlock.demonology, snapshotData, "ruination", true)
					end

					-- Ruination proc has no real aura; start a 20s custom timer (early consume handled by GLOW_HIDE).
					ruinationSnapshot.buff:InitializeCustom(spells.ruination.duration, GetTime(), false)
				end
			end
		elseif TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
			if spellId == spells.incinerate.id then -- Infernal Bolt proc glows the Incinerate button
				local infernalBoltSnapshot = snapshotData.snapshots[spells.infernalBolt.id]
				if infernalBoltSnapshot ~= nil then
					local wasActive = infernalBoltSnapshot.buff.isActive

					if not wasActive then
						TRB.Functions.AudioCues:Fire(TRB.Data.settings.warlock.destruction, snapshotData, "infernalBolt", true)
					end

					-- Infernal Bolt proc has no real aura; start a 20s custom timer (early consume handled by GLOW_HIDE).
					infernalBoltSnapshot.buff:InitializeCustom(spells.infernalBolt.duration, GetTime(), false)
				end
			elseif spellId == spells.ruination.id then -- Ruination proc glows the Ruination button
				local ruinationSnapshot = snapshotData.snapshots[spells.ruination.id]
				if ruinationSnapshot ~= nil then
					local wasActive = ruinationSnapshot.buff.isActive

					if not wasActive then
						TRB.Functions.AudioCues:Fire(TRB.Data.settings.warlock.destruction, snapshotData, "ruination", true)
					end

					-- Ruination proc has no real aura; start a 20s custom timer (early consume handled by GLOW_HIDE).
					ruinationSnapshot.buff:InitializeCustom(spells.ruination.duration, GetTime(), false)
				end
			end
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 1 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
			if spellId == spells.unstableAffliction.id then -- Shard Instability proc ended
				local shardInstabilitySnapshot = snapshotData.snapshots[spells.shardInstability.id]
				if shardInstabilitySnapshot ~= nil then
					shardInstabilitySnapshot.buff:Reset()
				end
			end
		elseif TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]
			if spellId == spells.demonbolt.id then -- Demonic Core
				local demonicCoreSnapshot = snapshotData.snapshots[spells.demonicCore.id]
				if demonicCoreSnapshot ~= nil then
					demonicCoreSnapshot.buff:Reset()
				end
				TRB.Functions.AudioCues:ResetLatch(snapshotData, "demonicCore")

				snapshotData.attributes.demonicCoreActiveGrace = true

				C_Timer.After(0, function()
					C_Timer.After(0.05, function()
						snapshotData.attributes.demonicCoreActiveGrace = false
					end)
				end)
			elseif spellId == spells.shadowBolt.id then -- Infernal Bolt proc ended
				local infernalBoltSnapshot = snapshotData.snapshots[spells.infernalBolt.id]
				if infernalBoltSnapshot ~= nil then
					infernalBoltSnapshot.buff:Reset()
				end
				TRB.Functions.AudioCues:ResetLatch(snapshotData, "infernalBolt")
			elseif spellId == spells.ruination.id then -- Ruination proc ended
				local ruinationSnapshot = snapshotData.snapshots[spells.ruination.id]
				if ruinationSnapshot ~= nil then
					ruinationSnapshot.buff:Reset()
				end
				TRB.Functions.AudioCues:ResetLatch(snapshotData, "ruination")
			end
		elseif TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]
			if spellId == spells.incinerate.id then -- Infernal Bolt proc ended
				local infernalBoltSnapshot = snapshotData.snapshots[spells.infernalBolt.id]
				if infernalBoltSnapshot ~= nil then
					infernalBoltSnapshot.buff:Reset()
				end
				TRB.Functions.AudioCues:ResetLatch(snapshotData, "infernalBolt")
			elseif spellId == spells.ruination.id then -- Ruination proc ended
				local ruinationSnapshot = snapshotData.snapshots[spells.ruination.id]
				if ruinationSnapshot ~= nil then
					ruinationSnapshot.buff:Reset()
				end
				TRB.Functions.AudioCues:ResetLatch(snapshotData, "ruination")
			end
		end
	end
end


local spellEventFrame = CreateFrame("Frame")
spellEventFrame:SetScript("OnEvent", HandleSpellEvents)

function TRB.Functions.Class:EnableEvents()
	spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
	spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
end

function TRB.Functions.Class:DisableEvents()
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
end


-- Reused per-tick scratch tables for UpdateResourceBar (see conditionMap/barColorMap sites).
-- Held in one table so UpdateResourceBar gains a single upvalue rather than one per site.
local scratch = {
	conditionMap1 = {},
	manaBarColors1 = {},
	soulShardsOverride1 = {},
	barColorMap1 = {},
	conditionMap2 = {},
	manaBarColors2 = {},
	soulShardsOverride2 = {},
	barColorMap2 = {},
	conditionMap3 = {},
	manaBarColors3 = {},
	soulShardsOverride3 = {},
	barColorMap3 = {},
}

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

	local function GetSoulShardOverlayAmount(normalizedResource2, incomingShards, spendingShards, nodeIndex)
		local nodeStart = nodeIndex - 1
		local nodeEnd = nodeIndex

		if incomingShards > 0 then
			local predictionEnd = math.min(normalizedResource2 + incomingShards, TRB.Data.character.maxResource2)
			return math.max(0, math.min(predictionEnd, nodeEnd) - math.max(normalizedResource2, nodeStart))
		elseif spendingShards > 0 then
			local spendingEnd = math.max(normalizedResource2 - spendingShards, 0)
			local overlayValue = math.max(0, math.min(normalizedResource2, nodeEnd) - math.max(spendingEnd, nodeStart))
			return -overlayValue
		end

		return 0
	end

	local function UpdateSoulShardsDemonology(specSettings, specCacheSettings, normalizedResource2, fillOverride, borderOverride, backgroundOverride)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(backgroundOverride or specSettings.colors.comboPoints.background.color, true)
		local castingSettings = specCacheSettings.colors.comboPoints.casting
		local spendingSettings = specCacheSettings.colors.comboPoints.spending
		local castingTexture = specCacheSettings.textures.comboPointsCastingBar
		local incomingShards = snapshotData.casting.resource2Casting or 0
		local spendingShards = math.abs(snapshotData.casting.resource2Spending or 0)
		-- Demonology renders whole-shard (binary) nodes, so anchor the predictive/spending
		-- overlay to the whole-shard boundary. Without flooring, a fractional Soul Shard
		-- value (which can occur transiently after a talent change, before it settles on a
		-- whole shard via a passive power update) splits a single-shard prediction across
		-- two adjacent nodes.
		local overlayBaseline = math.floor(normalizedResource2)
		-- Dominion of Argus refund: the leftmost shard of Hand of Gul'dan's full cost (just
		-- below the spending overlay) survives the cast, so mark it with the refunding overlay.
		local refundingShards = math.abs(snapshotData.casting.resource2Refunding or 0)
		local refundingSettings = specCacheSettings.colors.comboPoints.refunding
		local refundingNodeIndex = nil
		if refundingShards > 0 then
			local idx = overlayBaseline - spendingShards
			if idx >= 1 then
				refundingNodeIndex = idx
			end
		end

		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = borderOverride or specSettings.colors.comboPoints.border.color
			local cpColor = fillOverride or specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = normalizedResource2 >= x
			local overlayAmount = GetSoulShardOverlayAmount(overlayBaseline, incomingShards, spendingShards, x)

			if filled and fillOverride == nil then
				if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 3)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 3)) then
					cpColor = specSettings.colors.comboPoints.second
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 2)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 2)) then
					cpColor = specSettings.colors.comboPoints.third
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end

			-- The refund node sits below the spend overlay and always draws an overlay; when the
			-- refunding color is enabled it uses that color, otherwise it falls back to spending.
			local nodeSpendingSettings = spendingSettings
			if refundingNodeIndex ~= nil and x == refundingNodeIndex then
				overlayAmount = -refundingShards
				if refundingSettings and refundingSettings.enabled then
					nodeSpendingSettings = refundingSettings
				end
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, filled and 1 or 0, 1)
					shardNode:SetBorderColor(cpBorderColor)
					TRB.Functions.Color:ApplyFillColor(shardNode, cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					Bar:ApplyNodeIndicators(shardNode, "soulShardsBar")

					if overlayAmount ~= 0 or shardNode:GetOverlaySlot("casting") ~= nil then
						Bar:UpdateCastingResourceOverlay(shardNode, snapshotData, specCacheSettings, overlayAmount, 1, castingSettings, nodeSpendingSettings, castingTexture)
					end
				end
			end
		end
	end

	local function UpdateSoulShardsAffliction(specSettings, specCacheSettings, normalizedResource2, fillOverride, borderOverride, backgroundOverride)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(backgroundOverride or specSettings.colors.comboPoints.background.color, true)
		local castingSettings = specCacheSettings.colors.comboPoints.casting
		local spendingSettings = specCacheSettings.colors.comboPoints.spending
		local castingTexture = specCacheSettings.textures.comboPointsCastingBar or specCacheSettings.textures.castingBar or specCacheSettings.textures.resourceBar
		local incomingShards = snapshotData.casting.resource2Casting or 0
		local spendingShards = math.abs(snapshotData.casting.resource2Spending or 0)
		-- Affliction renders whole-shard (binary) nodes, so anchor the predictive/spending
		-- overlay to the whole-shard boundary. Without flooring, a fractional Soul Shard
		-- value (which can occur transiently after a talent change, before it settles on a
		-- whole shard via a passive power update) splits a single-shard prediction across
		-- two adjacent nodes.
		local overlayBaseline = math.floor(normalizedResource2)

		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = borderOverride or specSettings.colors.comboPoints.border.color
			local cpColor = fillOverride or specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = normalizedResource2 >= x
			local overlayAmount = GetSoulShardOverlayAmount(overlayBaseline, incomingShards, spendingShards, x)

			if filled and fillOverride == nil then
				if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 3)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 3)) then
					cpColor = specSettings.colors.comboPoints.second
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 2)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 2)) then
					cpColor = specSettings.colors.comboPoints.third
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, filled and 1 or 0, 1)
					shardNode:SetBorderColor(cpBorderColor)
					TRB.Functions.Color:ApplyFillColor(shardNode, cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					Bar:ApplyNodeIndicators(shardNode, "soulShardsBar")

					if overlayAmount ~= 0 or shardNode:GetOverlaySlot("casting") ~= nil then
						Bar:UpdateCastingResourceOverlay(shardNode, snapshotData, specCacheSettings, overlayAmount, 1, castingSettings, spendingSettings, castingTexture)
					end
				end
			end
		end
	end

	local function UpdateSoulShardsDestruction(specSettings, specCacheSettings, normalizedResource2, fillOverride, borderOverride, backgroundOverride)
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(backgroundOverride or specSettings.colors.comboPoints.background.color, true)
		local regeneratingColor = specSettings.colors.comboPoints.regenerating
		local castingSettings = specCacheSettings.colors.comboPoints.casting
		local spendingSettings = specCacheSettings.colors.comboPoints.spending
		local castingTexture = specCacheSettings.textures.comboPointsCastingBar
		local castingFragments = snapshotData.casting.resource2Casting or 0
		local incomingShards = castingFragments / TRB.Data.resource2Factor
		local spendingFragments = snapshotData.casting.resource2Spending or 0
		local spendingShards = math.abs(spendingFragments / TRB.Data.resource2Factor)
		local function GetSoulShardFillColor(resourceCount, nodeIndex)
			local shardColor = specSettings.colors.comboPoints.base
			if (specSettings.comboPoints.sameColor and resourceCount == (TRB.Data.character.maxResource2 - 3)) or (not specSettings.comboPoints.sameColor and nodeIndex == (TRB.Data.character.maxResource2 - 3)) then
				shardColor = specSettings.colors.comboPoints.second
			elseif (specSettings.comboPoints.sameColor and resourceCount == (TRB.Data.character.maxResource2 - 2)) or (not specSettings.comboPoints.sameColor and nodeIndex == (TRB.Data.character.maxResource2 - 2)) then
				shardColor = specSettings.colors.comboPoints.third
			elseif (specSettings.comboPoints.sameColor and resourceCount == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and nodeIndex == (TRB.Data.character.maxResource2 - 1)) then
				shardColor = specSettings.colors.comboPoints.penultimate
			elseif (specSettings.comboPoints.sameColor and resourceCount == TRB.Data.character.maxResource2) or nodeIndex == TRB.Data.character.maxResource2 then
				shardColor = specSettings.colors.comboPoints.final
			end

			return shardColor
		end

		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = borderOverride or specSettings.colors.comboPoints.border.color
			local cpColor = fillOverride or specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local fillValue = 0
			local overlayAmount = GetSoulShardOverlayAmount(normalizedResource2, incomingShards, spendingShards, x)

			if normalizedResource2 >= x then
				fillValue = 1
				if fillOverride == nil then
					cpColor = GetSoulShardFillColor(math.floor(normalizedResource2), x)
				end
			elseif normalizedResource2 >= (x - 1) then
				-- Partial fill for Destruction
				fillValue = normalizedResource2 - (x - 1)
				if fillOverride == nil and fillValue > 0 and fillValue < 1 then
					if regeneratingColor and regeneratingColor.enabled then
						cpColor = regeneratingColor
					else
						cpColor = GetSoulShardFillColor(x, x)
					end
				end
			end

			if barGroups and barGroups.secondary then
				local shardNode = barGroups.secondary:GetNode(x)
				if shardNode then
					Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, shardNode, fillValue, 1)
					shardNode:SetBorderColor(cpBorderColor)
					TRB.Functions.Color:ApplyFillColor(shardNode, cpColor)
					shardNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					Bar:ApplyNodeIndicators(shardNode, "soulShardsBar")

					if overlayAmount ~= 0 or shardNode:GetOverlaySlot("casting") ~= nil then
						Bar:UpdateCastingResourceOverlay(shardNode, snapshotData, specCacheSettings, overlayAmount, 1, castingSettings, spendingSettings, castingTexture)
					end
				end
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.affliction
		local specCacheSettings = TRB.Data.specCache.warlock_affliction.settings
		UpdateSnapshot_Affliction()
		if snapshotData.attributes.isTracking then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

			-- Resolve indicator colors (shared system). manaBar uses default colors;
			-- soulShardsBar overrides start as nil so the per-node Soul Shard coloring is
			-- preserved unless an indicator explicitly targets a given element.
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			-- No talent gate: a buff that is up is proof enough the talent is taken, and the talent
			-- lookup keys off the spell ID, which is not guaranteed to be the tree's node ID.
			local shardInstabilitySnapshot = snapshots[spells.shardInstability.id]
			local conditionMap = scratch.conditionMap1
			wipe(conditionMap)
			conditionMap.shardInstability = shardInstabilitySnapshot ~= nil and shardInstabilitySnapshot.buff.isActive == true

			local manaBarColors = scratch.manaBarColors1
			wipe(manaBarColors)
			manaBarColors.bar = specSettings.colors.bar.base
			manaBarColors.border = specSettings.colors.bar.border.color
			manaBarColors.background = specSettings.colors.bar.background.color
			local soulShardsOverride = scratch.soulShardsOverride1
			wipe(soulShardsOverride)
			local barColorMap = scratch.barColorMap1
			wipe(barColorMap)
			barColorMap.manaBar = manaBarColors
			barColorMap.soulShardsBar = soulShardsOverride

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyNodeIndicators(primaryNode, "manaBar")
				primaryNode:SetBorderColor(manaBarColors.border)
				TRB.Functions.Color:ApplyFillColor(primaryNode, manaBarColors.bar)
				primaryNode:SetBackgroundColorFromString(manaBarColors.background)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShardsAffliction(specSettings, specCacheSettings, normalizedResource2, soulShardsOverride.bar, soulShardsOverride.border, soulShardsOverride.background)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
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
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]

			-- Resolve indicator colors (shared system). manaBar uses default colors;
			-- soulShardsBar overrides start as nil so the per-node Soul Shard coloring is
			-- preserved unless an indicator explicitly targets a given element.
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			-- Precompute Dominion of Argus end-of-buff timing threshold
			local doaSnapshot = snapshotData.snapshots[spells.dominionOfArgus.id]
			local doaActive = doaSnapshot ~= nil and doaSnapshot.buff.isActive
			local doaEndMet = false
			if doaActive then
				local timeThreshold = 0
				if specSettings.endOf.dominionOfArgus.mode == "gcd" then
					local gcd = Character:GetCurrentGCDTime()
					timeThreshold = gcd * specSettings.endOf.dominionOfArgus.gcdsMax
				elseif specSettings.endOf.dominionOfArgus.mode == "time" then
					timeThreshold = specSettings.endOf.dominionOfArgus.timeMax
				end
				doaEndMet = doaSnapshot.buff.remaining <= timeThreshold
			end

			local conditionMap = scratch.conditionMap2
			wipe(conditionMap)
			conditionMap.dominionOfArgusEnd = doaActive and doaEndMet
			conditionMap.dominionOfArgus = doaActive
			conditionMap.demonicCore = snapshotData.snapshots[spells.demonicCore.id] ~= nil and snapshotData.snapshots[spells.demonicCore.id].buff.isActive
			conditionMap.infernalBolt = snapshotData.snapshots[spells.infernalBolt.id] ~= nil and snapshotData.snapshots[spells.infernalBolt.id].buff.isActive
			conditionMap.ruination = snapshotData.snapshots[spells.ruination.id] ~= nil and snapshotData.snapshots[spells.ruination.id].buff.isActive

			local manaBarColors = scratch.manaBarColors2
			wipe(manaBarColors)
			manaBarColors.bar = specSettings.colors.bar.base
			manaBarColors.border = specSettings.colors.bar.border.color
			manaBarColors.background = specSettings.colors.bar.background.color
			local soulShardsOverride = scratch.soulShardsOverride2
			wipe(soulShardsOverride)
			local barColorMap = scratch.barColorMap2
			wipe(barColorMap)
			barColorMap.manaBar = manaBarColors
			barColorMap.soulShardsBar = soulShardsOverride

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyNodeIndicators(primaryNode, "manaBar")
				primaryNode:SetBorderColor(manaBarColors.border)
				TRB.Functions.Color:ApplyFillColor(primaryNode, manaBarColors.bar)
				primaryNode:SetBackgroundColorFromString(manaBarColors.background)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShardsDemonology(specSettings, specCacheSettings, normalizedResource2, soulShardsOverride.bar, soulShardsOverride.border, soulShardsOverride.background)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
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
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]

			-- Resolve indicator colors (shared system). manaBar uses default colors;
			-- soulShardsBar overrides start as nil so the per-node Soul Shard coloring is
			-- preserved unless an indicator explicitly targets a given element.
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			local conditionMap = scratch.conditionMap3
			wipe(conditionMap)
			conditionMap.infernalBolt = snapshots[spells.infernalBolt.id] ~= nil and snapshots[spells.infernalBolt.id].buff.isActive
			conditionMap.ruination = snapshots[spells.ruination.id] ~= nil and snapshots[spells.ruination.id].buff.isActive

			local manaBarColors = scratch.manaBarColors3
			wipe(manaBarColors)
			manaBarColors.bar = specSettings.colors.bar.base
			manaBarColors.border = specSettings.colors.bar.border.color
			manaBarColors.background = specSettings.colors.bar.background.color
			local soulShardsOverride = scratch.soulShardsOverride3
			wipe(soulShardsOverride)
			local barColorMap = scratch.barColorMap3
			wipe(barColorMap)
			barColorMap.manaBar = manaBarColors
			barColorMap.soulShardsBar = soulShardsOverride

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyNodeIndicators(primaryNode, "manaBar")
				primaryNode:SetBorderColor(manaBarColors.border)
				TRB.Functions.Color:ApplyFillColor(primaryNode, manaBarColors.bar)
				primaryNode:SetBackgroundColorFromString(manaBarColors.background)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local normalizedResource2 = snapshotData.attributes.resource2Modified / TRB.Data.resource2Factor
				UpdateSoulShardsDestruction(specSettings, specCacheSettings, normalizedResource2, soulShardsOverride.bar, soulShardsOverride.border, soulShardsOverride.background)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
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
		lookup["#seedOfCorruption"] = spells.seedOfCorruption.icon
		lookup["#unstableAffliction"] = spells.unstableAffliction.icon
		lookup["#shadowOfDeath"] = spells.shadowOfDeath.icon
		lookup["#shardInstability"] = spells.shardInstability.icon
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
		lookup["#shadowBolt"] = spells.shadowBolt.icon
		lookup["#demonbolt"] = spells.demonbolt.icon
		lookup["#infernalBolt"] = spells.infernalBolt.icon
		lookup["#ruination"] = spells.ruination.icon
		lookup["#handOfGuldan"] = spells.handOfGuldan.icon
		lookup["#shadowOfDeath"] = spells.shadowOfDeath.icon
		lookup["#summonFelguard"] = spells.summonFelguard.icon
		lookup["#callDreadstalkers"] = spells.callDreadstalkers.icon
		lookup["#demonicCore"] = spells.demonicCore.icon
		lookup["#doa"] = spells.dominionOfArgus.icon
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
		lookup["#incinerate"] = spells.incinerate.icon
		lookup["#soulFire"] = spells.soulFire.icon
		lookup["#infernalBolt"] = spells.infernalBolt.icon
		lookup["#chaosBolt"] = spells.chaosBolt.icon
		lookup["#ruination"] = spells.ruination.icon
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
	TRB.Functions.Class:DisableEvents()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.warlock.affliction == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
		TRB.Functions.Class:EnableEvents()
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.warlock.demonology == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
		TRB.Functions.Class:EnableEvents()
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.warlock.destruction == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.SoulShards
		TRB.Data.resource2Factor = 10
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
			local castingSnapshot = TRB.Data.snapshotData.casting
			return castingSnapshot.resourceRaw ~= nil and castingSnapshot.resourceRaw ~= 0
		end,
		["$resource"] = false, ["$mana"] = false,
		["$resourcePercent"] = false, ["$manaPercent"] = false,
		["$resourceMax"] = true, ["$manaMax"] = true,
		["$castingFragments"] = function()
			local value = TRB.Data.lookupLogic and TRB.Data.lookupLogic["$castingFragments"]
			return value ~= nil and not issecretvalue(value) and value ~= 0
		end,
		["$castingShards"] = function()
			local value = TRB.Data.lookupLogic and TRB.Data.lookupLogic["$castingShards"]
			return value ~= nil and not issecretvalue(value) and value ~= 0
		end,
		["$castingSoulShards"] = function()
			local value = TRB.Data.lookupLogic and TRB.Data.lookupLogic["$castingSoulShards"]
			return value ~= nil and not issecretvalue(value) and value ~= 0
		end,
		["$comboPoints"] = true, ["$soulShards"] = true,
		["$comboPointsMax"] = true, ["$soulShardsMax"] = true,
		["$comboPointsPlusCasting"] = true, ["$soulShardsPlusCasting"] = true,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
	}
	local affliction = {}
	for key, entry in pairs(shared) do
		affliction[key] = entry
	end
	-- Both go false the moment the value is unknown, matching the "??" the text renders: a
	-- conditional must not read as satisfied on the strength of a number we could not obtain.
	affliction["$shardInstabilityTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.shardInstability == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.shardInstability.id]
		if snap == nil or snap.buff.isActive ~= true then
			return false
		end
		return snap.buff.customProperties.remaining ~= nil or snap.buff.customProperties.remainingText ~= nil
	end
	affliction["$shardInstabilityStacks"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.shardInstability == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.shardInstability.id]
		return snap ~= nil and snap.buff.isActive == true and snap.buff.customProperties.stacks ~= nil
	end
	affliction["$shardInstabilityMaxStacks"] = true
	local demonology = {}
	for key, entry in pairs(shared) do
		demonology[key] = entry
	end
	-- Both go false the moment the value is unknown, matching the "??" the text renders: a
	-- conditional must not read as satisfied on the strength of a number we could not obtain.
	demonology["$demonicCoreTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.demonicCore == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.demonicCore.id]
		if snap == nil or snap.buff.isActive ~= true then
			return false
		end
		return snap.buff.customProperties.remaining ~= nil or snap.buff.customProperties.remainingText ~= nil
	end
	demonology["$demonicCoreStacks"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.demonicCore == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.demonicCore.id]
		return snap ~= nil and snap.buff.isActive == true and snap.buff.customProperties.stacks ~= nil
	end
	demonology["$demonicCoreMaxStacks"] = true
	demonology["$infernalBoltTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.infernalBolt == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.infernalBolt.id]
		return snap ~= nil and snap.buff.isActive == true
	end
	demonology["$ruinationTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.ruination == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.ruination.id]
		return snap ~= nil and snap.buff.isActive == true
	end
	demonology["$doaTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.dominionOfArgus == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.dominionOfArgus.id]
		return snap ~= nil and snap.buff.isActive == true
	end
	local destruction = {}
	for key, entry in pairs(shared) do
		destruction[key] = entry
	end
	destruction["$infernalBoltTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.infernalBolt == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.infernalBolt.id]
		return snap ~= nil and snap.buff.isActive == true
	end
	destruction["$ruinationTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells == nil or spells.ruination == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.ruination.id]
		return snap ~= nil and snap.buff.isActive == true
	end
	specValidVars = { [1] = affliction, [2] = demonology, [3] = destruction }
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