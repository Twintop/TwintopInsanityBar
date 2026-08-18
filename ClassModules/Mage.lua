local _, TRB = ...
if TRB.Data.character.classId ~= 8 then --Only do this if we're on an Mage!
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
	mage_arcane = TRB.Classes.SpecCache:New(),
	mage_fire = TRB.Classes.SpecCache:New(),
	mage_frost = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Arcane
	specCache.mage_arcane.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.mage_arcane.character = {
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
	
	---@type TRB.Classes.Mage.ArcaneSpells
	specCache.mage_arcane.spellsData.spells = TRB.Classes.Mage.ArcaneSpells:New()
	local spells = specCache.mage_arcane.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]

	specCache.mage_arcane.snapshotData.attributes.manaRegen = 0

	specCache.mage_arcane.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Fire
	specCache.mage_fire.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.mage_fire.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
	}
	
	---@type TRB.Classes.Mage.FireSpells
	specCache.mage_fire.spellsData.spells = TRB.Classes.Mage.FireSpells:New()

	specCache.mage_fire.snapshotData.attributes.manaRegen = 0

	specCache.mage_fire.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Frost
	specCache.mage_frost.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.mage_frost.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		},
	}
	
	---@type TRB.Classes.Mage.FrostSpells
	specCache.mage_frost.spellsData.spells = TRB.Classes.Mage.FrostSpells:New()
	local frostSpells = specCache.mage_frost.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]

	specCache.mage_frost.snapshotData.attributes.manaRegen = 0

	specCache.mage_frost.snapshotData.snapshots[frostSpells.icicles.id] = TRB.Classes.Snapshot:New(frostSpells.icicles, nil, "always")
	specCache.mage_frost.snapshotData.snapshots[frostSpells.fingersOfFrost.id] = TRB.Classes.Snapshot:New(frostSpells.fingersOfFrost)
	-- The charge count is a secret in combat, so it is counted in Lua from SPELL_UPDATE_USES instead.
	specCache.mage_frost.snapshotData.snapshots[frostSpells.fingersOfFrost.id].buff:InitializeProcCharges()
	-- Simple mode, or the UNIT_AURA-driven RefreshAllBuffs would run GetRemainingTime against the nil
	-- endTime an overlay-tracked proc has and clear isActive between procs.
	specCache.mage_frost.snapshotData.snapshots[frostSpells.brainFreeze.id] = TRB.Classes.Snapshot:New(frostSpells.brainFreeze, nil, "always")

	specCache.mage_frost.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Arcane()
	Character:FillSpecializationCacheSettings("mage", "arcane", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "mage_arcane" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Mage.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Arcane()
	Setup_Arcane()
	specCache.mage_arcane.spellsData:FillSpellData()
	local spells = specCache.mage_arcane.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]

	TRB.Classes.Mage.ArcaneSpells.FillBarTextVariables(specCache.mage_arcane)
end

local function Setup_Fire()
	Character:FillSpecializationCacheSettings("mage", "fire")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "mage_fire" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Mage.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Fire()
	Setup_Fire()
	specCache.mage_fire.spellsData:FillSpellData()
	local spells = specCache.mage_fire.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]

	-- Create snapshot for Fire Blast charge tracking
	specCache.mage_fire.snapshotData.snapshots[spells.fireBlast.id] = TRB.Classes.Snapshot:New(spells.fireBlast)

	TRB.Classes.Mage.FireSpells.FillBarTextVariables(specCache.mage_fire)
end

local function Setup_Frost()
	Character:FillSpecializationCacheSettings("mage", "frost")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "mage_frost" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Mage.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Frost()
	Setup_Frost()
	specCache.mage_frost.spellsData:FillSpellData()
	local spells = specCache.mage_frost.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]

	TRB.Classes.Mage.FrostSpells.FillBarTextVariables(specCache.mage_frost)
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
	
	if TRB.Data.character.specId == 1 then -- Arcane
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Fire
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Frost
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

local function SyncFireBlastChargeNodes(maxCharges, settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if not (barGroups and barGroups.secondary) then
		return
	end

	maxCharges = tonumber(maxCharges) or 0
	if maxCharges < 0 then
		maxCharges = 0
	end

	local previousMaxResource2 = TRB.Data.character.maxResource2
	TRB.Data.character.maxResource2 = maxCharges
	if previousMaxResource2 ~= maxCharges and TRB.Functions.BarVisibility and TRB.Functions.BarVisibility.MarkDirty then
		TRB.Functions.BarVisibility:MarkDirty()
	end

	local secondaryGroup = barGroups.secondary
	if maxCharges == 0 then
		secondaryGroup:HideAllNodes()
		return 0
	end

	local targetNodeCount = math.min(maxCharges, secondaryGroup.maxNodes or maxCharges)
	local nodeCountChanged = secondaryGroup.nodeCount ~= targetNodeCount
	secondaryGroup:SetNodeCount(targetNodeCount)

	if settings ~= nil and settings.comboPoints ~= nil and settings.bar ~= nil and nodeCountChanged then
		secondaryGroup:SetLayout(Bar:GetEffectiveSpacing(settings.comboPoints), Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")

		local effectiveWidth, cdmForced = Bar:GetEffectiveWidthForBarGroup(barGroups, settings, "secondary")
		if cdmForced then
			secondaryGroup.fullWidth = true
		end

		secondaryGroup:ApplyLayout(
			effectiveWidth,
			settings.comboPoints.width,
			settings.comboPoints.height,
			settings.comboPoints.border
		)
	end

	secondaryGroup:ShowNodes(targetNodeCount)
	return targetNodeCount
end

---@param spells TRB.Classes.Mage.FireSpells?
---@param refresh boolean?
---@return TRB.Classes.SnapshotCooldown?
local function GetFireBlastCooldownSnapshot(spells, refresh)
	if not (spells and spells.fireBlast and TRB.Data.snapshotData and TRB.Data.snapshotData.snapshots) then
		return nil
	end

	local snapshot = TRB.Data.snapshotData.snapshots[spells.fireBlast.id]
	if not (snapshot and snapshot.cooldown) then
		return nil
	end

	if refresh then
		snapshot.cooldown:Refresh(true)
	end

	return snapshot.cooldown
end

---@param cooldown TRB.Classes.SnapshotCooldown?
---@return integer
local function GetFireBlastMaxCharges(cooldown)
	local maxCharges = cooldown and cooldown.maxCharges
	if maxCharges ~= nil and not issecretvalue(maxCharges) then
		local numericMaxCharges = tonumber(maxCharges)
		if numericMaxCharges ~= nil then
			return numericMaxCharges
		end
	end

	return TRB.Data.character.maxResource2 or 1
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Don't construct bars for disabled specs
	if not TRB.Data.specSupported then
		return
	end

	-- Arcane uses secondary bar (Arcane Charges). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	-- If it's still nil/0 for Arcane, use the factory's maxNodes as a fallback.
	if barGroups and barGroups.secondary and TRB.Data.character.specId == 1 then
		local maxCharges = TRB.Data.character.maxResource2
		if maxCharges == nil or maxCharges == 0 then
			maxCharges = barGroups.secondary.maxNodes or 4
		end
		TRB.Data.character.maxResource2 = maxCharges
	end

	-- Frost uses secondary bar (Icicles). maxResource2 must already be populated.
	-- If maxResource2 == 0, Icicles is not talented; leave it at 0 to hide the bar.
	if barGroups and barGroups.secondary and TRB.Data.character.specId == 3 then
		local maxIcicles = TRB.Data.character.maxResource2
		if maxIcicles == nil then
			maxIcicles = 0
		end
		TRB.Data.character.maxResource2 = maxIcicles
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

	-- Arcane uses secondary bar (Arcane Charges); Fire uses secondary bar (Fire Blast Charges); Frost uses secondary bar (Icicles).
	if barGroups and barGroups.secondary then
		if TRB.Data.character.specId == 1 then
			local maxCharges = TRB.Data.character.maxResource2 or 4
			
			-- Ensure secondary group knows the correct node count
			Bar:ApplySecondaryBarGroupLayout(settings, barGroups, maxCharges)
			barGroups.secondary:Show()
			
			-- Explicitly set textures and colors for each Arcane Charge node
			for i = 1, maxCharges do
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
		elseif TRB.Data.character.specId == 2 then
			local maxFBCharges = TRB.Data.character.maxResource2 or 2

			if maxFBCharges == 0 then
				barGroups.secondary:Hide()
			else
				local fireBlastNodeCount = SyncFireBlastChargeNodes(maxFBCharges, settings) or 0
				barGroups.secondary:SetNodeCount(fireBlastNodeCount)
				barGroups.secondary:SetLayout(Bar:GetEffectiveSpacing(settings.comboPoints), Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
				barGroups.secondary:Show()

				local effectiveWidth, cdmForced = Bar:GetEffectiveWidthForBarGroup(barGroups, settings, "secondary")
				if cdmForced then
					barGroups.secondary.fullWidth = true
				end

				barGroups.secondary:ApplyLayout(
					effectiveWidth,
					settings.comboPoints.width,
					settings.comboPoints.height,
					settings.comboPoints.border
				)
				barGroups.secondary:ShowNodes(fireBlastNodeCount)

				local fireBlastColors = settings.colors.bars and settings.colors.bars.fireBlastCharges
				-- Style every slot, not just the visible count: charge count lags on spec switch, so higher nodes would render texture-less when shown later.
				local fireBlastMaxNodes = barGroups.secondary.maxNodes or fireBlastNodeCount
				for i = 1, fireBlastMaxNodes do
					local node = barGroups.secondary:GetNode(i)
					if node then
						node:SetTextures(
							settings.textures.comboPointsBar,
							settings.textures.comboPointsBorder,
							settings.textures.comboPointsBackground
						)
						node:SetMinMax(i - 1, i)
						if fireBlastColors then
							node:SetBorderColor(fireBlastColors.border.color)
							node:SetBackgroundColorFromString(fireBlastColors.background.color)
							local chargeKey = "charge" .. i
							if fireBlastColors.nodeColors and fireBlastColors.nodeColors[chargeKey] then
								TRB.Functions.Color:ApplyFillColor(node, fireBlastColors.nodeColors[chargeKey])
							end
						end
						node:SetFrameLevel(TRB.Functions.Bar:GetBarFrameLevel("secondary"))
					end
				end
			end
		elseif TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
			local maxIcicles = TRB.Data.character.maxResource2 or 0

			if maxIcicles == 0 then
				barGroups.secondary:Hide()
			else
				-- Use the standard rebuild path so caches, textures, and colors are handled correctly
				if barGroups.secondary.RebuildNodes then
					barGroups.secondary:RebuildNodes(maxIcicles, settings)
				else
					-- Fallback: preserve visibility if RebuildNodes is unavailable
					Bar:ApplySecondaryBarGroupLayout(settings, barGroups, maxIcicles)
					barGroups.secondary:Show()
				end
			end

			if barGroups.shatter then
				barGroups.shatter:SetNodeCount(spells.shatter.maxStacks)
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Arcane()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.arcane
	local sharedSettings = TRB.Data.specCache["mage_arcane"].settings

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
		local currentManaColor = TRB.Data.settings.mage.arcane.colors.text.current.color
		local castingManaColor = TRB.Data.settings.mage.arcane.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = formatted
			lookup["$resource"] = formatted
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = formatted
			lookup["$resourceMax"] = formatted
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = formatted
			lookup["$resourcePercent"] = formatted
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
	end

	-- Block B: Arcane Charges ($arcaneCharges, $comboPoints, $arcaneChargesMax, $comboPointsMax)
	if not activeVars or activeVars["$arcaneCharges"] or activeVars["$comboPoints"]
		or activeVars["$arcaneChargesMax"] or activeVars["$comboPointsMax"] then
		lookupLogic["$arcaneCharges"] = snapshotData.attributes.resource2
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$arcaneChargesMax"] = TRB.Data.character.maxResource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$arcaneCharges"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$arcaneChargesMax"] = TRB.Data.character.maxResource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Fire()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.mage.fire
	local sharedSettings = TRB.Data.specCache["mage_fire"].settings

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
		local currentManaColor = TRB.Data.settings.mage.fire.colors.text.current.color
		local castingManaColor = TRB.Data.settings.mage.fire.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = formatted
			lookup["$resource"] = formatted
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = formatted
			lookup["$resourceMax"] = formatted
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = formatted
			lookup["$resourcePercent"] = formatted
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
	end

	-- Block B: Fire Blast Charges ($fireBlastCharges, $fbCharges, $fireBlastChargesMax, $fbChargesMax, $fireBlastTime, $fbTime)
	if not activeVars or activeVars["$fireBlastCharges"] or activeVars["$fbCharges"]
		or activeVars["$fireBlastChargesMax"] or activeVars["$fbChargesMax"]
		or activeVars["$fireBlastTime"] or activeVars["$fbTime"] then
		local fireBlastCooldown = GetFireBlastCooldownSnapshot(spells, true)
		local _fbChargesMax = GetFireBlastMaxCharges(fireBlastCooldown)
		local _fbCharges = fireBlastCooldown and fireBlastCooldown.charges or _fbChargesMax
		local isRecharging = fireBlastCooldown and fireBlastCooldown.isActive == true
		local durationObject = nil
		if fireBlastCooldown ~= nil and isRecharging then
			durationObject = fireBlastCooldown:GetDurationObject()
		end
		local _fbTime = 0
		if isRecharging and durationObject ~= nil then
			_fbTime = durationObject:GetRemainingDuration() or 0
		end
		lookupLogic["$fireBlastCharges"] = false
		lookupLogic["$fbCharges"] = false
		lookupLogic["$fireBlastChargesMax"] = _fbChargesMax
		lookupLogic["$fbChargesMax"] = _fbChargesMax
		lookupLogic["$fireBlastTime"] = isRecharging and 1 or 0
		lookupLogic["$fbTime"] = isRecharging and 1 or 0
		lookup["$fireBlastCharges"] = TRB.Functions.Number:RoundTo(_fbCharges, 0)
		lookup["$fbCharges"] = TRB.Functions.Number:RoundTo(_fbCharges, 0)
		lookup["$fireBlastChargesMax"] = TRB.Functions.Number:RoundTo(_fbChargesMax, 0)
		lookup["$fbChargesMax"] = TRB.Functions.Number:RoundTo(_fbChargesMax, 0)
		lookup["$fireBlastTime"] = TRB.Functions.BarText:TimerPrecision(_fbTime)
		lookup["$fbTime"] = TRB.Functions.BarText:TimerPrecision(_fbTime)
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Frost()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.frost
	local sharedSettings = TRB.Data.specCache["mage_frost"].settings

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
		local currentManaColor = TRB.Data.settings.mage.frost.colors.text.current.color
		local castingManaColor = TRB.Data.settings.mage.frost.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = formatted
			lookup["$resource"] = formatted
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = formatted
			lookup["$resourceMax"] = formatted
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local formatted = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = formatted
			lookup["$resourcePercent"] = formatted
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
	end

	-- Block B: Icicles ($icicles, $comboPoints, $iciclesMax, $comboPointsMax)
	if not activeVars or activeVars["$icicles"] or activeVars["$comboPoints"]
		or activeVars["$iciclesMax"] or activeVars["$comboPointsMax"] then
		local _icicles = snapshots[spells.icicles.id].buff.applications or 0
		local _iciclesMax = spells.icicles.maxStacks

		lookupLogic["$icicles"] = _icicles
		lookupLogic["$comboPoints"] = _icicles
		lookupLogic["$iciclesMax"] = _iciclesMax
		lookupLogic["$comboPointsMax"] = _iciclesMax

		lookup["$icicles"] = _icicles
		lookup["$comboPoints"] = _icicles
		lookup["$iciclesMax"] = _iciclesMax
		lookup["$comboPointsMax"] = _iciclesMax
	end

	-- Block C: Shatter ($shatterStacks, $shatterStacksMax)
	if not activeVars or activeVars["$shatterStacks"] or activeVars["$shatterStacksMax"] then
		local attributes = snapshotData.attributes
		local _shatterStacksMax = spells.shatter.maxStacks

		lookupLogic["$shatterStacksMax"] = _shatterStacksMax

		-- A debuff that is down is a known zero; one nothing in the Cooldown Manager holds is unknown.
		-- Memoized on the rendered string, since both are nil underneath.
		local stacksDisplay
		if not attributes.shatterTracked then
			stacksDisplay = TRB.Functions.BarText:UnknownValue(string.format("%.0f", 0))
		elseif attributes.shatterStacks ~= nil then
			stacksDisplay = string.format("%s", attributes.shatterStacks)
		else
			stacksDisplay = string.format("%.0f", 0)
		end

		if lookupChanged(prevState, "$shatterStacks", stacksDisplay) then
			lookup["$shatterStacks"] = stacksDisplay
		end
		if lookupChanged(prevState, "$shatterStacksMax", _shatterStacksMax) then
			lookup["$shatterStacksMax"] = tostring(_shatterStacksMax)
		end
	end

	-- Block D: Fingers of Frost ($fingersOfFrostStacks, $fingersOfFrostStacksMax, $fingersOfFrostTime)
	if not activeVars or activeVars["$fingersOfFrostStacks"] or activeVars["$fingersOfFrostStacksMax"]
		or activeVars["$fingersOfFrostTime"] then
		local buff = snapshots[spells.fingersOfFrost.id].buff
		local _fingersOfFrostStacks = buff.isActive and (buff.applications or 0) or 0
		local _fingersOfFrostStacksMax = spells.fingersOfFrost.maxStacks
		local _fingersOfFrostTime = buff.isActive and buff.remaining or 0

		lookupLogic["$fingersOfFrostStacks"] = _fingersOfFrostStacks
		lookupLogic["$fingersOfFrostStacksMax"] = _fingersOfFrostStacksMax
		lookupLogic["$fingersOfFrostTime"] = _fingersOfFrostTime

		lookup["$fingersOfFrostStacks"] = _fingersOfFrostStacks
		lookup["$fingersOfFrostStacksMax"] = _fingersOfFrostStacksMax
		lookup["$fingersOfFrostTime"] = TRB.Functions.BarText:TimerPrecision(_fingersOfFrostTime)
	end

	-- Block E: Brain Freeze ($brainFreezeTime)
	if not activeVars or activeVars["$brainFreezeTime"] then
		local buff = snapshots[spells.brainFreeze.id].buff
		local _brainFreezeActive = buff.isActive == true
		local properties = buff.customProperties
		local _brainFreezeTime = properties.remaining
		local _brainFreezeTimeText = properties.remainingText

		-- Secret when the Cooldown Manager has it, missing when it does not, so logic only learns whether
		-- there is a value at all.
		lookupLogic["$brainFreezeTime"] = _brainFreezeActive and (_brainFreezeTime ~= nil or _brainFreezeTimeText ~= nil)

		-- Proc down is a known zero; proc up with nothing tracking it is unknown. Memoized on the rendered
		-- string, since both are nil underneath.
		local timeDisplay
		if not _brainFreezeActive then
			timeDisplay = TRB.Functions.BarText:TimerPrecision(0)
		elseif _brainFreezeTime ~= nil then
			timeDisplay = TRB.Functions.BarText:TimerPrecision(_brainFreezeTime)
		elseif _brainFreezeTimeText ~= nil then
			-- Already formatted, to the viewer's precision rather than ours.
			timeDisplay = _brainFreezeTimeText
		else
			timeDisplay = TRB.Functions.BarText:UnknownValue(TRB.Functions.BarText:TimerPrecision(0))
		end

		if lookupChanged(prevState, "$brainFreezeTime", timeDisplay) then
			lookup["$brainFreezeTime"] = timeDisplay
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

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal()
		end
	end

	if TRB.Data.character.specId == 3 and event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		if spells ~= nil and spells.iceLance ~= nil and spellId == spells.iceLance.id then
			local snapshot = spells.fingersOfFrost and snapshotData.snapshots
				and snapshotData.snapshots[spells.fingersOfFrost.id]
			if snapshot ~= nil then
				snapshot.buff:ArmProcSpend()
			end
		end
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
	--local currentTime = GetTime()
end

local function UpdateSnapshot_Arcane()
	UpdateSnapshot()
end

local function UpdateSnapshot_Fire()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	if spells and spells.fireBlast and snapshots[spells.fireBlast.id] then
		snapshots[spells.fireBlast.id].cooldown:Refresh(true)
	end
end

---Refreshes the Shatter stack count on the current target from the Cooldown Manager.
---`shatterTracked` separates a down debuff (known zero) from an untracked spell (renders "??").
local function RefreshShatterStacks()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	local attributes = snapshotData.attributes
	local wasTracked = attributes.shatterTracked == true
	local wasActive = attributes.shatterActive == true

	attributes.shatterStacks = nil
	attributes.shatterTracked = false
	attributes.shatterActive = false

	if spells ~= nil and spells.shatter ~= nil then
		-- Unpinned: the debuff is on our target, so a cooldown viewer holds it, not a buff viewer.
		local cdm = TRB.Functions.CooldownManager
		local trackedId = cdm:ResolveTrackedSpellId(cdm.SourceGroup.ANY, spells.shatter.id)
		if trackedId ~= nil then
			attributes.shatterTracked = true
			local stacksOk, stacks = cdm:Read(trackedId, cdm.Signal.APPLICATIONS, cdm.SourceGroup.ANY)
			if stacksOk then
				attributes.shatterStacks = stacks
				attributes.shatterActive = true
			end
		end
	end

	if wasTracked ~= attributes.shatterTracked or wasActive ~= attributes.shatterActive then
		TRB.Data.lookupDirty = true
	end
end

---Refreshes the time left on Brain Freeze from the Cooldown Manager. The activation overlay owns
---whether the proc is up, so this only ever supplies the number the overlay cannot carry.
local function RefreshBrainFreeze()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	if spells == nil or spells.brainFreeze == nil then
		return
	end

	local snapshot = snapshotData.snapshots[spells.brainFreeze.id]
	if snapshot == nil then
		return
	end

	local properties = snapshot.buff.customProperties
	properties.remaining = nil
	properties.remainingText = nil

	if not snapshot.buff.isActive then
		return
	end

	-- Pinned to the buff viewers, which describe the aura -- a cooldown viewer would describe the cast.
	local cdm = TRB.Functions.CooldownManager
	local trackedId = cdm:ResolveTrackedSpellId(cdm.SourceGroup.BUFF, spells.brainFreeze.id)
	if trackedId == nil then
		return
	end

	-- Only the bar viewer leaves a subtracted remaining value; elsewhere take Blizzard's own countdown
	-- text, which is empty when that viewer's timers are off -- a settings answer, not a value.
	local remainingOk, remaining = cdm:Read(trackedId, cdm.Signal.REMAINING, cdm.SourceKind.BUFF_BAR)
	if remainingOk then
		properties.remaining = remaining
	else
		local textOk, remainingText = cdm:Read(trackedId, cdm.Signal.REMAINING_TEXT, cdm.SourceGroup.BUFF)
		if textOk and remainingText ~= nil and (issecretvalue(remainingText) or remainingText ~= "") then
			properties.remainingText = remainingText
		end
	end
end

local function UpdateSnapshot_Frost()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	RefreshShatterStacks()
	RefreshBrainFreeze()

	local fingersOfFrost = snapshots[spells.fingersOfFrost.id]
	if fingersOfFrost ~= nil then
		fingersOfFrost.buff:RefreshProcCharges(currentTime)
	end
end

---Updates the Shatter bar nodes (Frost only).
---The count is secret, so every node takes the raw value and stepped min/max does the filling.
---@param specSettings table
---@param specCacheSettings TRB.Classes.Settings.SpecializationSettingsBase
---@param barColors table # Indicator-resolved bar/border/background colors for the Shatter bar
---@param fillIndicated boolean? # An indicator owns the fill, overriding the every-Nth threshold color
local function UpdateShatter(specSettings, specCacheSettings, barColors, fillIndicated)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if not (barGroups and barGroups.shatter) then
		return
	end

	local shatterStacks = snapshotData.attributes.shatterStacks or 0
	local maxShatter = spells.shatter.maxStacks

	local shatterColors = specSettings.colors and specSettings.colors.bars and specSettings.colors.bars.shatter
	if shatterColors == nil then
		return
	end

	local backgroundRed, backgroundGreen, backgroundBlue, backgroundAlpha = Color:GetRGBAFromString(barColors.background, true)

	local stackThreshold = spells.shatter.attributes and spells.shatter.attributes.stackThreshold
	local thresholdEnabled = shatterColors.threshold ~= nil and shatterColors.threshold.enabled == true

	for x = 1, maxShatter do
		local shatterNode = barGroups.shatter:GetNode(x)
		if shatterNode then
			Bar:SetBarNodeValue(specCacheSettings, "shatter" .. x, shatterNode, shatterStacks)

			local fillColor = barColors.bar
			-- Every multiple of the threshold, not just the first: 5, 10, 15, 20.
			if not fillIndicated and thresholdEnabled and stackThreshold and stackThreshold > 0 and x % stackThreshold == 0 then
				fillColor = shatterColors.threshold
			end

			Color:ApplyFillColor(shatterNode, fillColor)
			Bar:ApplyEndCapIndicator(shatterNode, "shatterBar")
			shatterNode:SetBorderColor(barColors.border)
			shatterNode:SetBackgroundColor(backgroundRed, backgroundGreen, backgroundBlue, backgroundAlpha)
		end
	end
end

local function UpdateResourceBar()
	local refreshText = false
	local classSettings = TRB.Data.settings.mage
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

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		if TRB.Data.character.maxResource2 == nil then
			return
		end
		local specSettings = classSettings.arcane
		local specCacheSettings = TRB.Data.specCache.mage_arcane.settings
		UpdateSnapshot_Arcane()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barBorderColor = specSettings.colors.bar.border.color
				local barColor = specSettings.colors.bar.base
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local currentCharges = snapshotData.attributes.resource2 or 0
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border.color
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue
					local filled = currentCharges >= x

					if filled then
						if (specSettings.comboPoints.sameColor and currentCharges == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and currentCharges == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					end

					if barGroups and barGroups.secondary then
						local chargeNode = barGroups.secondary:GetNode(x)
						if chargeNode then
							Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, chargeNode, filled and 1 or 0, 1)
							chargeNode:SetBorderColor(cpBorderColor)
							TRB.Functions.Color:ApplyFillColor(chargeNode, cpColor)
							chargeNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
						end
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, "arcaneCharges", snapshotData.attributes.resource2)
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.fire
		local specCacheSettings = TRB.Data.specCache.mage_fire.settings
		UpdateSnapshot_Fire()
		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border.color
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end

			-- Fire Blast Charges secondary bar
			if not specSettings.displayBar.secondary.neverShow then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
				if spells and spells.fireBlast and barGroups and barGroups.secondary then
					local fireBlastCooldown = GetFireBlastCooldownSnapshot(spells)
					local maxCharges = GetFireBlastMaxCharges(fireBlastCooldown)
					local charges = fireBlastCooldown and fireBlastCooldown.charges or maxCharges
					local isRecharging = fireBlastCooldown and fireBlastCooldown.isActive == true
					local rechargeDurationObject = nil
					if fireBlastCooldown ~= nil and isRecharging then
						rechargeDurationObject = fireBlastCooldown:GetDurationObject()
					end
					local fireBlastColors = specCacheSettings.colors.bars and specCacheSettings.colors.bars.fireBlastCharges
					local fireBlastNodeCount = SyncFireBlastChargeNodes(maxCharges, specCacheSettings) or 0

					refreshText = true
					for x = 1, fireBlastNodeCount do
						local chargeNode = barGroups.secondary:GetNode(x)
						if chargeNode then
							local cpKey = "comboPoint" .. x
							local isPartialRechargeNode = isRecharging and x == fireBlastNodeCount and rechargeDurationObject ~= nil
							if isPartialRechargeNode then
								chargeNode:SetMinMax(0, 1)
								TRB.Data.cache.values.bar[cpKey] = nil
								Bar:SetBarNodeTimerDuration(specCacheSettings, cpKey, chargeNode, rechargeDurationObject)
							else
								chargeNode:ClearTimerDuration()
								chargeNode:SetMinMax(x - 1, x)
								TRB.Data.cache.values.bar[cpKey] = nil
								chargeNode:SetValue(charges)
							end
							if fireBlastColors then
								local chargeKey = "charge" .. x
								local fillColor = fireBlastColors.nodeColors and fireBlastColors.nodeColors[chargeKey]
								if isPartialRechargeNode and fireBlastColors.regenerating and fireBlastColors.regenerating.enabled then
									fillColor = fireBlastColors.regenerating
								end
								if fillColor then
									TRB.Functions.Color:ApplyFillColor(chargeNode, fillColor)
								end
								chargeNode:SetBorderColor(fireBlastColors.border.color)
								chargeNode:SetBackgroundColorFromString(fireBlastColors.background.color)
							end
						end
					end
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.frost
		local specCacheSettings = TRB.Data.specCache.mage_frost.settings
		UpdateSnapshot_Frost()
		if snapshotData.attributes.isTracking then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
			local snapshots = snapshotData.snapshots

			-- Indicators resolve ahead of the bars' visibility guards: the health bar and cast bar have
			-- their own visibility, so they still need coloring when a resource bar is set to Never Show.
			local sharedColors = specSettings.colors.shared
			local conditionMap = {
				fingersOfFrost = snapshots[spells.fingersOfFrost.id].buff.isActive,
				brainFreeze = snapshots[spells.brainFreeze.id].buff.isActive,
			}

			local manaBarColors = {
				bar = specSettings.colors.bar.base,
				border = specSettings.colors.bar.border.color,
				background = specSettings.colors.bar.background.color,
			}
			local iciclesBarColors = {
				bar = specSettings.colors.comboPoints.base,
				border = specSettings.colors.comboPoints.border.color,
				background = specSettings.colors.comboPoints.background.color,
			}
			local shatterColors = specSettings.colors.bars and specSettings.colors.bars.shatter
			local shatterBarColors = shatterColors and {
				bar = shatterColors.bar,
				border = shatterColors.border.color,
				background = shatterColors.background.color,
			} or nil
			local indicatorTargets = {
				manaBar = { bar = false, border = false, background = false },
				iciclesBar = { bar = false, border = false, background = false },
				shatterBar = { bar = false, border = false, background = false },
			}

			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, {
				manaBar = manaBarColors,
				iciclesBar = iciclesBarColors,
				shatterBar = shatterBarColors,
			}, indicatorTargets)

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

			-- Icicles bar (only when Icicles is talented, i.e. maxResource2 > 0)
			if not specSettings.displayBar.secondary.neverShow and (TRB.Data.character.maxResource2 or 0) > 0 then
				refreshText = true
				local currentIcicles = snapshots[spells.icicles.id].buff.applications or 0
				local maxIcicles = spells.icicles.maxStacks
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(iciclesBarColors.background, true)
				for x = 1, maxIcicles do
					local cpColor = specSettings.colors.comboPoints.base
					local filled = currentIcicles >= x

					if filled then
						if (specSettings.colors.comboPoints.sameColor and currentIcicles == (maxIcicles - 1)) or (not specSettings.colors.comboPoints.sameColor and x == (maxIcicles - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.colors.comboPoints.sameColor and currentIcicles == maxIcicles) or x == maxIcicles then
							cpColor = specSettings.colors.comboPoints.final
						end
					end

					-- An indicator on the fill wins over the per-node base/penultimate/final choice.
					if indicatorTargets.iciclesBar.bar then
						cpColor = iciclesBarColors.bar
					end

					if barGroups and barGroups.secondary then
						local icicleNode = barGroups.secondary:GetNode(x)
						if icicleNode then
							Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, icicleNode, filled and 1 or 0, 1)
							Bar:ApplyEndCapIndicator(icicleNode, "iciclesBar")
							icicleNode:SetBorderColor(iciclesBarColors.border)
							TRB.Functions.Color:ApplyFillColor(icicleNode, cpColor)
							icicleNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
						end
					end
				end
			end

			if specSettings.displayBar.shatter and not specSettings.displayBar.shatter.neverShow then
				refreshText = true
				UpdateShatter(specSettings, specCacheSettings, shatterBarColors, indicatorTargets.shatterBar.bar)
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		-- Audio cues (independent of bar visibility)
		do
			local frostSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
			local frostSnapshots = snapshotData.snapshots
			TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, "icicles",
				frostSnapshots[frostSpells.icicles.id].buff.applications or 0)

			-- Charges are Lua-tracked, so the second-charge cue wins when a proc takes you straight to
			-- two, and the first-charge cue can offer a play-on-drop for spending back down to one.
			local fingersOfFrost = frostSnapshots[frostSpells.fingersOfFrost.id].buff
			local fingersOfFrostStacks = fingersOfFrost.isActive and (fingersOfFrost.applications or 0) or 0
			TRB.Functions.AudioCues:FireValueGroup(specSettings, snapshotData, "fingersOfFrostCharges",
				fingersOfFrostStacks, {
					{ id = "fingersOfFrostCharge1", threshold = 1 },
					{ id = "fingersOfFrostCharge2", threshold = 2 },
				})

			TRB.Functions.AudioCues:Fire(specSettings, snapshotData, "brainFreeze",
				frostSnapshots[frostSpells.brainFreeze.id].buff.isActive == true)
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
		specCache.mage_arcane.talents:GetTalents()
		FillSpellData_Arcane()
		Character:LoadFromSpecializationCache(specCache.mage_arcane)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Arcane
		Bar:UpdateSanityCheckValues(specCache.mage_arcane.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "mage_arcane" then
			talents = specCache.mage_arcane.talents
			TRB.Data.barConstructedForSpec = "mage_arcane"
			ConstructResourceBar(specCache.mage_arcane.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.mage_fire.talents:GetTalents()
		FillSpellData_Fire()
		Character:LoadFromSpecializationCache(specCache.mage_fire)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Fire
		Bar:UpdateSanityCheckValues(specCache.mage_fire.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		-- Sync Fire Blast node count from the snapshot cooldown after EventRegistration populates spell data.
		do
			local fireSpells = specCache.mage_fire.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
			local fireBlastCooldown = GetFireBlastCooldownSnapshot(fireSpells, true)
			local maxCharges = GetFireBlastMaxCharges(fireBlastCooldown)
			SyncFireBlastChargeNodes(maxCharges, specCache.mage_fire.settings)
		end

		if TRB.Data.barConstructedForSpec ~= "mage_fire" then
			talents = specCache.mage_fire.talents
			TRB.Data.barConstructedForSpec = "mage_fire"
			ConstructResourceBar(specCache.mage_fire.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.mage_frost.talents:GetTalents()
		FillSpellData_Frost()
		Character:LoadFromSpecializationCache(specCache.mage_frost)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Frost
		Bar:UpdateSanityCheckValues(specCache.mage_frost.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#shatter"] = spells.shatter.icon
		lookup["#fingersOfFrost"] = spells.fingersOfFrost.icon
		lookup["#brainFreeze"] = spells.brainFreeze.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Manual tracking only runs while Frost is played, so anything banked is stale by now.
		snapshotData.snapshots[spells.fingersOfFrost.id].buff:Reset()
		snapshotData.snapshots[spells.fingersOfFrost.id].buff:ResetProcCharges()
		snapshotData.snapshots[spells.brainFreeze.id].buff:Reset()

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "mage_frost" then
			talents = specCache.mage_frost.talents
			TRB.Data.barConstructedForSpec = "mage_frost"
			ConstructResourceBar(specCache.mage_frost.settings)
		end

		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				snapshotData.snapshots[spells.icicles.id].buff:Refresh()
			end)
		end)
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
	
	if TRB.Data.character.classId == 8 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Mage.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.mage == nil or
						TwintopInsanityBarSettings.mage.arcane == nil or
						TwintopInsanityBarSettings.mage.arcane.displayText == nil then
						settings.mage.arcane.displayText.barText = TRB.Options.Mage.ArcaneLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.mage == nil or
						TwintopInsanityBarSettings.mage.fire == nil or
						TwintopInsanityBarSettings.mage.fire.displayText == nil then
						settings.mage.fire.displayText.barText = TRB.Options.Mage.FireLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.mage == nil or
						TwintopInsanityBarSettings.mage.frost == nil or
						TwintopInsanityBarSettings.mage.frost.displayText == nil then
						settings.mage.frost.displayText.barText = TRB.Options.Mage.FrostLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.mage ~= true then
						TRB.Data.settings.mage.arcane.displayText.barText = TRB.Options.Mage.ArcaneLoadDefaultBarTextSettings()
						TRB.Data.settings.mage.fire.displayText.barText = TRB.Options.Mage.FireLoadDefaultBarTextSettings()
						TRB.Data.settings.mage.frost.displayText.barText = TRB.Options.Mage.FrostLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.mage = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Mage"])
					end
				else
					local settings = TRB.Options.Mage.LoadDefaultSettings(true)
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
						TRB.Data.settings.mage.arcane = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MageArcaneFull"], TRB.Data.settings.mage.arcane)
						TRB.Data.settings.mage.fire = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MageFireFull"], TRB.Data.settings.mage.fire)
						TRB.Data.settings.mage.frost = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MageFrostFull"], TRB.Data.settings.mage.frost)
						
						FillSpellData_Arcane()
						FillSpellData_Fire()
						FillSpellData_Frost()
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Mage.ConstructOptionsPanel(specCache)
						
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

-- Fire Blast charge update handler. This event is only a repaint hint; charge state
-- comes from the Fire Blast cooldown snapshot in the update path.
local function HandleFireBlastChargesEvent(spellId)
	if TRB.Data.character.specId ~= 2 then return end

	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
	if not (spells and spells.fireBlast) then return end

	-- SPELL_UPDATE_CHARGES passes the spellId of the affected spell. Filter to Fire Blast.
	if spellId ~= nil and spellId ~= spells.fireBlast.id then return end

	TRB.Data.lookupDirty = true
	if TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

-- Every Fingers of Frost charge change fires SPELL_UPDATE_USES on Ice Lance, not on the buff itself.
local function HandleFingersOfFrostEvent(spellId)
	if TRB.Data.character.specId ~= 3 then return end

	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	if not (spells and spells.iceLance and spells.fingersOfFrost) then return end
	if spellId ~= spells.iceLance.id then return end

	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshot = snapshotData and snapshotData.snapshots and snapshotData.snapshots[spells.fingersOfFrost.id]
	if snapshot == nil then return end

	snapshot.buff:HandleProcChargeEvent()

	TRB.Data.lookupDirty = true
	if TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

---Updates data based on spell events
local function HandleSpellEvents(self, event, ...)
	if event == "SPELL_UPDATE_CHARGES" then
		local spellId = ...
		HandleFireBlastChargesEvent(spellId)
	elseif event == "SPELL_UPDATE_USES" then
		local spellId = ...
		HandleFingersOfFrostEvent(spellId)
	elseif event == "SPELL_ACTIVATION_OVERLAY_SHOW" or event == "SPELL_ACTIVATION_OVERLAY_HIDE" then
		local spellId = ...
		if TRB.Data.character.specId ~= 3 then return end
		-- A hide-all carries no spell id and is always followed by a re-show of whatever is still up,
		-- so only an explicit id match counts.
		if spellId == nil then return end

		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		if not (spells and spells.brainFreeze and spells.fingersOfFrost) then return end

		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData and snapshotData.snapshots
		if snapshots == nil then return end

		local isShow = event == "SPELL_ACTIVATION_OVERLAY_SHOW"

		if spellId == spells.brainFreeze.id then -- Brain Freeze
			local snapshot = snapshots[spells.brainFreeze.id]
			if snapshot == nil then return end
			if isShow then
				-- Never GetRemainingTime this buff: there is no endTime behind it to expire against.
				snapshot.buff:InitializeCustomSimple(false)
			else
				snapshot.buff:Reset()
			end
		elseif spellId == spells.fingersOfFrost.id then -- Fingers of Frost
			-- Flag only: a hide never means a partial spend, but leaving the charge count and the spend
			-- arm to SPELL_UPDATE_USES keeps a misread here from being able to wipe either.
			local snapshot = snapshots[spells.fingersOfFrost.id]
			if snapshot ~= nil then
				snapshot.buff:SetProcOverlay(isShow)
			end
			return
		else
			return
		end

		TRB.Data.lookupDirty = true
		if TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end
end

spellEventFrame:SetScript("OnEvent", HandleSpellEvents)

function TRB.Functions.Class:CheckCharacter()
	local specId = GetSpecialization()
	if specId ~= TRB.Data.character.specId then
		SwitchSpec()
	end
	Character:CheckCharacter()
	TRB.Data.character.className = "mage"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)

	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
		TRB.Data.character.specName = "arcane"
		TRB.Data.character.compositeKey = "mage_arcane"
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		-- Arcane Charges max is always 4 (fixed game value).
		local maxComboPoints = 4

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
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "fire"
		TRB.Data.character.compositeKey = "mage_fire"
		local fireSpells2 = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
		local fireBlastCooldown = GetFireBlastCooldownSnapshot(fireSpells2, true)
		local maxFBCharges = GetFireBlastMaxCharges(fireBlastCooldown)
		TRB.Data.character.maxResource2 = maxFBCharges
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		TRB.Data.character.specName = "frost"
		TRB.Data.character.compositeKey = "mage_frost"
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		local frostTalents = TRB.Data.specCache.mage_frost and TRB.Data.specCache.mage_frost.talents
		local maxIcicles = 0
		if frostTalents and frostTalents:IsTalentActive(spells.icicles) then
			maxIcicles = 5
		end

		if sharedSettings ~= nil then
			if maxIcicles ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxIcicles
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
					Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
				end
			end
		end
	end
end

function TRB.Functions.Class:EnableEvents()
	if TRB.Data.character.specId == 2 then
		spellEventFrame:RegisterEvent("SPELL_UPDATE_CHARGES")
	elseif TRB.Data.character.specId == 3 then
		spellEventFrame:RegisterEvent("SPELL_UPDATE_USES")
		spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW")
		spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE")
	end
end

-- Ungated on purpose: EventRegistration calls this once specId has already flipped, so a spec check
-- here would strand the outgoing spec's events.
function TRB.Functions.Class:DisableEvents()
	spellEventFrame:UnregisterEvent("SPELL_UPDATE_CHARGES")
	spellEventFrame:UnregisterEvent("SPELL_UPDATE_USES")
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW")
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE")
end

function TRB.Functions.Class:EventRegistration()
	TRB.Functions.Class:DisableEvents()

	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.mage.arcane then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.ArcaneCharges
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.mage.fire then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = 1
		TRB.Functions.Class:EnableEvents()
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.mage.frost then
		local spells = TRB.Data.specCache["mage_frost"].spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "SPELL"
		TRB.Data.resource2Id = spells.icicles.id
		TRB.Data.resource2Factor = 1
		TRB.Functions.Class:EnableEvents()
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

		-- Arcane (1) always has Arcane Charges; Frost (3) has Icicles only if talented (maxResource2 > 0)
		local hasSecondary = TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or (TRB.Data.character.specId == 3 and (TRB.Data.character.maxResource2 or 0) > 0)

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, hasSecondary, TRB.Data.character.maxResource2, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, sharedSettings and sharedSettings.displayBar.health, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.shatter, sharedSettings and sharedSettings.displayBar.shatter, TRB.Data.character.specId == 3, barGroups and barGroups.shatter and barGroups.shatter.maxNodes, nil),
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
		["$casting"] = castingFn,
		["$resource"] = false, ["$mana"] = false,
		["$resourcePercent"] = false, ["$manaPercent"] = false,
		["$resourceMax"] = true, ["$manaMax"] = true,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
	}
	-- Arcane
	local arcane = {}
	for k, v in pairs(common) do arcane[k] = v end
	arcane["$comboPoints"] = true
	arcane["$arcaneCharges"] = true
	arcane["$comboPointsMax"] = true
	arcane["$arcaneChargesMax"] = true
	-- Frost
	local frost = {}
	for k, v in pairs(common) do frost[k] = v end
	frost["$comboPoints"] = true
	frost["$icicles"] = true
	frost["$comboPointsMax"] = true
	frost["$iciclesMax"] = true
	-- Goes false when the count is unknown, matching the "??" the text renders.
	frost["$shatterStacks"] = function()
		return TRB.Data.snapshotData.attributes.shatterTracked == true
	end
	frost["$shatterStacksMax"] = true
	local fingersOfFrostActiveFn = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		local snapshot = spells and spells.fingersOfFrost and TRB.Data.snapshotData.snapshots[spells.fingersOfFrost.id]
		return snapshot ~= nil and snapshot.buff.isActive == true
	end
	frost["$fingersOfFrostStacks"] = fingersOfFrostActiveFn
	frost["$fingersOfFrostStacksMax"] = true
	frost["$fingersOfFrostTime"] = fingersOfFrostActiveFn
	-- Goes false the moment the time is unknown, matching the "??" the text renders.
	frost["$brainFreezeTime"] = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		if spells == nil or spells.brainFreeze == nil then
			return false
		end
		local snap = TRB.Data.snapshotData.snapshots[spells.brainFreeze.id]
		if snap == nil or snap.buff.isActive ~= true then
			return false
		end
		return snap.buff.customProperties.remaining ~= nil or snap.buff.customProperties.remainingText ~= nil
	end
	-- Fire
	local fireBlastChargesMaxFn = function()
		local maxCharges = TRB.Data.character.maxResource2 or 0
		return maxCharges > 0
	end
	local fireBlastTimeFn = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
		local fireBlastCooldown = GetFireBlastCooldownSnapshot(spells, true)
		return fireBlastCooldown ~= nil and fireBlastCooldown.isActive == true
	end
	local fire = {}
	for k, v in pairs(common) do fire[k] = v end
	fire["$fireBlastCharges"] = false
	fire["$fbCharges"] = false
	fire["$fireBlastChargesMax"] = fireBlastChargesMaxFn
	fire["$fbChargesMax"] = fireBlastChargesMaxFn
	fire["$fireBlastTime"] = fireBlastTimeFn
	fire["$fbTime"] = fireBlastTimeFn

	specValidVars = { [1] = arcane, [2] = fire, [3] = frost }
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

	if normalizedRelativeFrame == "FireBlastChargesBar" or normalizedRelativeFrame == "FireBlastCharges" then
		if barGroups.secondary then
			return barGroups.secondary:GetContainerFrame(), true, barGroups.secondary.isVisible
		end
		return nil, true, false
	end

	local shatterIndex = string.match(normalizedRelativeFrame, "^Shatter(%d+)$")
	if shatterIndex ~= nil then
		local index = tonumber(shatterIndex)
		if index and barGroups.shatter then
			local shatterNode = barGroups.shatter:GetNode(index)
			if shatterNode then
				local isVisible = barGroups.shatter.isVisible and shatterNode.isVisible
				return shatterNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	local fireBlastChargeIndex = string.match(normalizedRelativeFrame, "^FireBlastCharge(%d+)$")
	if fireBlastChargeIndex ~= nil then
		local chargeIndex = tonumber(fireBlastChargeIndex)
		if chargeIndex and barGroups.secondary then
			local chargeNode = barGroups.secondary:GetNode(chargeIndex)
			if chargeNode then
				local isVisible = barGroups.secondary.isVisible and chargeNode.isVisible
				return chargeNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local chargeNode = barGroups.secondary:GetNode(comboPoint)
			if chargeNode then
				local isVisible = barGroups.secondary.isVisible and chargeNode.isVisible
				return chargeNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

function TRB.Functions.Class:HasActiveTimers()
	if TRB.Data.character.specId == 2 then
		local activeVars = TRB.Data.activeVariables
		if activeVars ~= nil and not activeVars["$fireBlastTime"] and not activeVars["$fbTime"] then
			return false
		end

		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
		local fireBlastCooldown = GetFireBlastCooldownSnapshot(spells, true)
		return fireBlastCooldown ~= nil and fireBlastCooldown.isActive == true
	elseif TRB.Data.character.specId == 3 then
		local activeVars = TRB.Data.activeVariables
		if activeVars ~= nil and not activeVars["$fingersOfFrostTime"] then
			return false
		end

		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		local snapshot = spells and spells.fingersOfFrost and TRB.Data.snapshotData.snapshots[spells.fingersOfFrost.id]
		return snapshot ~= nil and snapshot.buff.isActive == true
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