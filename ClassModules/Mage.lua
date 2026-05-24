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
local fireBlastChargesFrame = CreateFrame("Frame")

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
	specCache.mage_arcane.snapshotData.audio = {
		arcaneChargeThreshold1Played = false,
		arcaneChargeThreshold2Played = false,
	}

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
	specCache.mage_fire.snapshotData.audio = {
	}

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
	specCache.mage_frost.snapshotData.audio = {
		iciclesThreshold1Played = false,
	}

	specCache.mage_frost.snapshotData.snapshots[frostSpells.icicles.id] = TRB.Classes.Snapshot:New(frostSpells.icicles, nil, "always")

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
		return
	end

	local targetNodeCount = math.min(maxCharges, secondaryGroup.maxNodes or maxCharges)
	local nodeCountChanged = secondaryGroup.nodeCount ~= targetNodeCount
	secondaryGroup:SetNodeCount(maxCharges)

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

	secondaryGroup:ShowNodes(maxCharges)
end

local function GetFireBlastChargeInfo(spells)
	local maxCharges = TRB.Data.character.maxResource2 or 1
	local currentCharges = maxCharges
	local isRecharging = false
	local durationObject = nil

	if spells ~= nil and spells.fireBlast ~= nil then
		local chargeInfo = C_Spell.GetSpellCharges(spells.fireBlast.id)
		if chargeInfo ~= nil then
			if chargeInfo.maxCharges ~= nil and not issecretvalue(chargeInfo.maxCharges) then
				maxCharges = chargeInfo.maxCharges
			end
			currentCharges = chargeInfo.currentCharges or currentCharges
			isRecharging = chargeInfo["isActive"] == true
		end

		if isRecharging then
			durationObject = C_Spell.GetSpellChargeDuration(spells.fireBlast.id)
		end
	end

	return currentCharges, maxCharges, isRecharging, durationObject
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
			barGroups.secondary:SetNodeCount(maxCharges)
			barGroups.secondary:SetLayout(Bar:GetEffectiveSpacing(settings.comboPoints), Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
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
			
			-- Explicitly set textures and colors for each Arcane Charge node
			local frameLevels = TRB.Data.constants.frameLevels
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
					node:SetFrameLevel(frameLevels.comboPoint)
				end
			end
		elseif TRB.Data.character.specId == 2 then
			local maxFBCharges = TRB.Data.character.maxResource2 or 2
			local frameLevels = TRB.Data.constants.frameLevels

			if maxFBCharges == 0 then
				barGroups.secondary:Hide()
			else
				SyncFireBlastChargeNodes(maxFBCharges, settings)
				barGroups.secondary:SetNodeCount(maxFBCharges)
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
				barGroups.secondary:ShowNodes(maxFBCharges)

				local fireBlastColors = settings.colors.bars and settings.colors.bars.fireBlastCharges
				for i = 1, maxFBCharges do
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
						node:SetFrameLevel(frameLevels.comboPoint)
					end
				end
			end
		elseif TRB.Data.character.specId == 3 then
			local maxIcicles = TRB.Data.character.maxResource2 or 0

			if maxIcicles == 0 then
				barGroups.secondary:Hide()
			else
				-- Ensure secondary group knows the correct node count
				barGroups.secondary:SetNodeCount(maxIcicles)
				barGroups.secondary:SetLayout(Bar:GetEffectiveSpacing(settings.comboPoints), Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
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

				-- Use the standard rebuild path so caches, textures, and colors are handled correctly
				if barGroups.secondary.RebuildNodes then
					barGroups.secondary:RebuildNodes(maxIcicles, settings)
				else
					-- Fallback: preserve visibility if RebuildNodes is unavailable
					barGroups.secondary:SetNodeCount(maxIcicles)
					barGroups.secondary:Show()
				end
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

	-- Block B: Fire Blast Charges ($fireBlastCharges, $fbCharges, $fireBlastTime, $fbTime)
	if not activeVars or activeVars["$fireBlastCharges"] or activeVars["$fbCharges"]
		or activeVars["$fireBlastTime"] or activeVars["$fbTime"] then
		local _fbCharges, _, isRecharging, durationObject = GetFireBlastChargeInfo(spells)
		local _fbTime = 0
		if isRecharging and durationObject ~= nil then
			_fbTime = durationObject:GetRemainingDuration() or 0
		end
		lookupLogic["$fireBlastCharges"] = _fbCharges
		lookupLogic["$fbCharges"] = _fbCharges
		lookupLogic["$fireBlastTime"] = _fbTime
		lookupLogic["$fbTime"] = _fbTime
		lookup["$fireBlastCharges"] = TRB.Functions.Number:RoundTo(_fbCharges, 0)
		lookup["$fbCharges"] = TRB.Functions.Number:RoundTo(_fbCharges, 0)
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

local function UpdateSnapshot_Frost()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
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

		-- Arcane Charge threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			do
				local coreSettings = TRB.Data.settings.core
				local currentResource2 = snapshotData.attributes.resource2
				local threshold1 = specSettings.audio.arcaneChargeThreshold1
				local threshold2 = specSettings.audio.arcaneChargeThreshold2
				local threshold1Value = threshold1.configuration.thresholdValue
				local threshold2Value = threshold2.configuration.thresholdValue

				local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.arcaneChargeThreshold1Played and currentResource2 >= threshold1Value
				local threshold2ShouldFire = threshold2.enabled and not snapshotData.audio.arcaneChargeThreshold2Played and currentResource2 >= threshold2Value

				if threshold1ShouldFire and threshold2ShouldFire then
					snapshotData.audio.arcaneChargeThreshold1Played = true
					snapshotData.audio.arcaneChargeThreshold2Played = true
					if threshold2Value > threshold1Value then
						PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
					else
						PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
					end
				elseif threshold2ShouldFire then
					snapshotData.audio.arcaneChargeThreshold2Played = true
					PlaySoundFile(threshold2.sound, coreSettings.audio.channel.channel)
				elseif threshold1ShouldFire then
					snapshotData.audio.arcaneChargeThreshold1Played = true
					PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
				end

				if currentResource2 < threshold1Value then
					snapshotData.audio.arcaneChargeThreshold1Played = false
				end
				if currentResource2 < threshold2Value then
					snapshotData.audio.arcaneChargeThreshold2Played = false
				end
			end
		end
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

			-- Fire Blast Charges secondary bar
			if not specSettings.displayBar.secondary.neverShow then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
				if spells and spells.fireBlast and barGroups and barGroups.secondary then
					local charges, maxCharges, isRecharging, rechargeDurationObject = GetFireBlastChargeInfo(spells)
					local fireBlastColors = specCacheSettings.colors.bars and specCacheSettings.colors.bars.fireBlastCharges
					SyncFireBlastChargeNodes(maxCharges, specCacheSettings)

					refreshText = true
					for x = 1, maxCharges do
						local chargeNode = barGroups.secondary:GetNode(x)
						if chargeNode then
							local cpKey = "comboPoint" .. x
							if isRecharging and x == maxCharges and rechargeDurationObject ~= nil then
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
								if fireBlastColors.nodeColors and fireBlastColors.nodeColors[chargeKey] then
									TRB.Functions.Color:ApplyFillColor(chargeNode, fireBlastColors.nodeColors[chargeKey])
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

			-- Icicles bar (only when Icicles is talented, i.e. maxResource2 > 0)
			if not specSettings.displayBar.secondary.neverShow and (TRB.Data.character.maxResource2 or 0) > 0 then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
				local snapshots = snapshotData.snapshots
				local currentIcicles = snapshots[spells.icicles.id].buff.applications or 0
				local maxIcicles = spells.icicles.maxStacks
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				for x = 1, maxIcicles do
					local cpBorderColor = specSettings.colors.comboPoints.border.color
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue
					local filled = currentIcicles >= x

					if filled then
						if (specSettings.colors.comboPoints.sameColor and currentIcicles == (maxIcicles - 1)) or (not specSettings.colors.comboPoints.sameColor and x == (maxIcicles - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.colors.comboPoints.sameColor and currentIcicles == maxIcicles) or x == maxIcicles then
							cpColor = specSettings.colors.comboPoints.final
						end
					end

					if barGroups and barGroups.secondary then
						local icicleNode = barGroups.secondary:GetNode(x)
						if icicleNode then
							Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, icicleNode, filled and 1 or 0, 1)
							icicleNode:SetBorderColor(cpBorderColor)
							TRB.Functions.Color:ApplyFillColor(icicleNode, cpColor)
							icicleNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
						end
					end
				end
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

		-- Icicles threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			do
				local coreSettings = TRB.Data.settings.core
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
				local snapshots = snapshotData.snapshots
				local currentIcicles = snapshots[spells.icicles.id].buff.applications or 0
				local threshold1 = specSettings.audio.iciclesThreshold1
				local threshold1Value = threshold1.configuration.thresholdValue

				local threshold1ShouldFire = threshold1.enabled and not snapshotData.audio.iciclesThreshold1Played and currentIcicles >= threshold1Value

				if threshold1ShouldFire then
					snapshotData.audio.iciclesThreshold1Played = true
					PlaySoundFile(threshold1.sound, coreSettings.audio.channel.channel)
				end

				if currentIcicles < threshold1Value then
					snapshotData.audio.iciclesThreshold1Played = false
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

		-- Sync Fire Blast node count from the charge API after EventRegistration populates spell data.
		do
			local fireSpells = specCache.mage_fire.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
			local _, maxCharges = GetFireBlastChargeInfo(fireSpells)
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
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
-- comes directly from C_Spell.GetSpellCharges in the update path.
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

fireBlastChargesFrame:RegisterEvent("SPELL_UPDATE_CHARGES")
fireBlastChargesFrame:SetScript("OnEvent", function(self, event, spellId, ...)
	if event == "SPELL_UPDATE_CHARGES" then
		HandleFireBlastChargesEvent(spellId)
	end
end)

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
		local _, maxFBCharges = GetFireBlastChargeInfo(fireSpells2)
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

function TRB.Functions.Class:EventRegistration()
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
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.mage.frost then
		local spells = TRB.Data.specCache["mage_frost"].spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "SPELL"
		TRB.Data.resource2Id = spells.icicles.id
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

		-- Arcane (1) always has Arcane Charges; Frost (3) has Icicles only if talented (maxResource2 > 0)
		local hasSecondary = TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or (TRB.Data.character.specId == 3 and (TRB.Data.character.maxResource2 or 0) > 0)

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
		["$casting"] = castingFn,
		["$resource"] = false, ["$mana"] = false,
		["$resourcePercent"] = false, ["$manaPercent"] = false,
		["$resourceMax"] = true, ["$manaMax"] = true,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true,
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
	-- Fire
	local fire = {}
	for k, v in pairs(common) do fire[k] = v end
	fire["$fireBlastCharges"] = true
	fire["$fbCharges"] = true
	fire["$fireBlastTime"] = true
	fire["$fbTime"] = true

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