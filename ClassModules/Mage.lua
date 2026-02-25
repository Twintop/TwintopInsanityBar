local _, TRB = ...
if TRB.Data.character.classId ~= 8 then --Only do this if we're on an Mage!
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
	TRB.Functions.Character:FillSpecializationCacheSettings("mage", "arcane", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "mage_arcane" then
		TRB.Functions.Bar:DestroyBarGroups()
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
	TRB.Functions.Character:FillSpecializationCacheSettings("mage", "fire")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "mage_fire" then
		TRB.Functions.Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Mage.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Fire()
	Setup_Fire()
	specCache.mage_fire.spellsData:FillSpellData()
	local spells = specCache.mage_fire.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]

	TRB.Classes.Mage.FireSpells.FillBarTextVariables(specCache.mage_fire)
end

local function Setup_Frost()
	TRB.Functions.Character:FillSpecializationCacheSettings("mage", "frost")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "mage_frost" then
		TRB.Functions.Bar:DestroyBarGroups()
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
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Arcane uses secondary bar (Arcane Charges); Frost uses secondary bar (Icicles); Fire does not.
	if barGroups and barGroups.secondary then
		if TRB.Data.character.specId == 1 then
			local maxCharges = TRB.Data.character.maxResource2 or 4
			
			-- Ensure secondary group knows the correct node count
			barGroups.secondary:SetNodeCount(maxCharges)
			barGroups.secondary:SetLayout(settings.comboPoints.spacing, TRB.Functions.Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
			barGroups.secondary:Show()
			
			-- Get effective width for secondary bar, accounting for CDM width matching
			local effectiveWidth, cdmForced = TRB.Functions.Bar:GetEffectiveWidthForBarGroup(barGroups, settings, "secondary")
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
					node:SetColor(settings.colors.comboPoints.base.color)
					node:SetFrameLevel(frameLevels.comboPoint)
				end
			end
		elseif TRB.Data.character.specId == 3 then
			local maxIcicles = TRB.Data.character.maxResource2 or 0

			if maxIcicles == 0 then
				barGroups.secondary:Hide()
			else
				-- Ensure secondary group knows the correct node count
				barGroups.secondary:SetNodeCount(maxIcicles)
				barGroups.secondary:SetLayout(settings.comboPoints.spacing, TRB.Functions.Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
				barGroups.secondary:Show()

				-- Get effective width for secondary bar, accounting for CDM width matching
				local effectiveWidth, cdmForced = TRB.Functions.Bar:GetEffectiveWidthForBarGroup(barGroups, settings, "secondary")
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

				-- Explicitly set textures and colors for each Icicle node
				local frameLevels = TRB.Data.constants.frameLevels
				for i = 1, maxIcicles do
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
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Arcane()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.arcane
	local sharedSettings = TRB.Data.specCache["mage_arcane"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.mage.arcane.colors.text.current.color
	local castingManaColor = TRB.Data.settings.mage.arcane.colors.text.casting.color

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
	lookup["$arcaneCharges"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$arcaneChargesMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$arcaneCharges"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$arcaneChargesMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Fire()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.fire
	local sharedSettings = TRB.Data.specCache["mage_fire"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.mage.fire.colors.text.current.color
	local castingManaColor = TRB.Data.settings.mage.fire.colors.text.casting.color

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

local function RefreshLookupData_Frost()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.mage.frost
	local sharedSettings = TRB.Data.specCache["mage_frost"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.mage.frost.colors.text.current.color
	local castingManaColor = TRB.Data.settings.mage.frost.colors.text.casting.color

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

	--$icicles
	local _icicles = snapshots[spells.icicles.id].buff.applications or 0
	local _iciclesMax = spells.icicles.maxStacks

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$icicles"] = _icicles
	lookup["$comboPoints"] = _icicles
	lookup["$iciclesMax"] = _iciclesMax
	lookup["$comboPointsMax"] = _iciclesMax
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$icicles"] = _icicles
	lookupLogic["$comboPoints"] = _icicles
	lookupLogic["$iciclesMax"] = _iciclesMax
	lookupLogic["$comboPointsMax"] = _iciclesMax
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
	TRB.Functions.Character:UpdateSnapshot()
	--local currentTime = GetTime()
end

local function UpdateSnapshot_Arcane()
	UpdateSnapshot()
end

local function UpdateSnapshot_Fire()
	UpdateSnapshot()
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
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barBorderColor = specSettings.colors.bar.border.color
				local barColor = specSettings.colors.bar.base.color
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if specSettings.displayBar.secondary.visibility ~= "never" then
				refreshText = true
				local currentCharges = snapshotData.attributes.resource2 or 0
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border.color
					local cpColor = specSettings.colors.comboPoints.base.color
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue
					local filled = currentCharges >= x

					if filled then
						if (specSettings.comboPoints.sameColor and currentCharges == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate.color
						elseif (specSettings.comboPoints.sameColor and currentCharges == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final.color
						end
					end

					if barGroups and barGroups.secondary then
						local chargeNode = barGroups.secondary:GetNode(x)
						if chargeNode then
							TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, chargeNode, filled and 1 or 0, 1)
							chargeNode:SetBorderColor(cpBorderColor)
							chargeNode:SetColor(cpColor)
							chargeNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
				TRB.Functions.Bar:UpdateHealthBarAbsorbOverlay(healthNode, snapshotData, specCacheSettings)
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
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
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
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.frost
		local specCacheSettings = TRB.Data.specCache.mage_frost.settings
		UpdateSnapshot_Frost()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary.visibility ~= "never" then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base.color
				local barBorderColor = specSettings.colors.bar.border.color
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				TRB.Functions.Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			-- Icicles bar (only when Icicles is talented, i.e. maxResource2 > 0)
			if specSettings.displayBar.secondary.visibility ~= "never" and (TRB.Data.character.maxResource2 or 0) > 0 then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
				local snapshots = snapshotData.snapshots
				local currentIcicles = snapshots[spells.icicles.id].buff.applications or 0
				local maxIcicles = spells.icicles.maxStacks
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				for x = 1, maxIcicles do
					local cpBorderColor = specSettings.colors.comboPoints.border.color
					local cpColor = specSettings.colors.comboPoints.base.color
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue
					local filled = currentIcicles >= x

					if filled then
						if (specSettings.colors.comboPoints.sameColor and currentIcicles == (maxIcicles - 1)) or (not specSettings.colors.comboPoints.sameColor and x == (maxIcicles - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate.color
						elseif (specSettings.colors.comboPoints.sameColor and currentIcicles == maxIcicles) or x == maxIcicles then
							cpColor = specSettings.colors.comboPoints.final.color
						end
					end

					if barGroups and barGroups.secondary then
						local icicleNode = barGroups.secondary:GetNode(x)
						if icicleNode then
							TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, icicleNode, filled and 1 or 0, 1)
							icicleNode:SetBorderColor(cpBorderColor)
							icicleNode:SetColor(cpColor)
							icicleNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
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
				TRB.Functions.Bar:UpdateHealthBarAbsorbOverlay(healthNode, snapshotData, specCacheSettings)
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
	if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
		TRB.Functions.Bar:QueueRenderTransition("switchSpec", 0.8)
	elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
		TRB.Functions.Bar:HideResourceBar(true)
	end
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	
	if TRB.Data.character.specId == 1 then
		specCache.mage_arcane.talents:GetTalents()
		FillSpellData_Arcane()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.mage_arcane)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Arcane
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.mage_arcane.settings)

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
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.mage_fire)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.FireSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Fire
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.mage_fire.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "mage_fire" then
			talents = specCache.mage_fire.talents
			TRB.Data.barConstructedForSpec = "mage_fire"
			ConstructResourceBar(specCache.mage_fire.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.mage_frost.talents:GetTalents()
		FillSpellData_Frost()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.mage_frost)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mage.FrostSpells]]
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Frost
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.mage_frost.settings)

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
					TRB.Functions.Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "fire"
		TRB.Data.character.compositeKey = "mage_fire"
		TRB.Data.character.maxResource2 = 1
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
					TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
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
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "SPELL"
		TRB.Data.resource2Id = TRB.Data.specCache["mage_frost"].spellsData.spells.icicles.id
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
			-- Arcane (specId == 1) uses Arcane Charges bar; Frost (specId == 3) uses Icicles bar
			-- If maxResource2 == 0 (Icicles not talented), treat as "never"
			local showSecondary = false
			if not forceHideAll and (TRB.Data.character.specId == 1 or (TRB.Data.character.specId == 3 and (TRB.Data.character.maxResource2 or 0) > 0)) then
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
			-- No settings - hide everything
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
		-- Unsupported spec - hide everything
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mage.ArcaneSpells]]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.mage.arcane
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.mage.fire
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.mage.frost
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Arcane
		if var == "$comboPoints" or var == "$arcaneCharges" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$arcaneChargesMax" then
			valid = true
		end
	elseif TRB.Data.character.specId == 2 then --Fire
		-- No spec-specific variables for Fire currently
	elseif TRB.Data.character.specId == 3 then --Frost
		if var == "$comboPoints" or var == "$icicles" then
			valid = true
		elseif var == "$comboPointsMax" or var == "$iciclesMax" then
			valid = true
		end
	end

	--Spec agnostic
	if var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$resource" or var == "$mana" then
		-- Do not compare snapshotData.attributes.resource as it may be a secret value
		valid = false
	elseif var == "$resourcePercent" or var == "$manaPercent" then
		-- Do not compare resource percent as it may be a secret value
		valid = false
	elseif var == "$resourceMax" or var == "$manaMax" then
		valid = true
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