local _, TRB = ...
if TRB.Data.character.classId ~= 2 then --Only do this if we're on an Paladin!
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
	holy = TRB.Classes.SpecCache:New(),
	protection = TRB.Classes.SpecCache:New(),
	retribution = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Holy
	specCache.holy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.holy.character = {
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
	
	---@type TRB.Classes.Paladin.HolySpells
	specCache.holy.spellsData.spells = TRB.Classes.Paladin.HolySpells:New()
	local spells = specCache.holy.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]

	specCache.holy.snapshotData.attributes.manaRegen = 0
	specCache.holy.snapshotData.audio = {
		innervateCue = false,
		infusionOfLightCue = false,
		infusionOfLight2Cue = false
	}

	--[[---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.infusionOfLight.id] = TRB.Classes.Snapshot:New(spells.infusionOfLight)]]

	specCache.holy.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Protection
	specCache.protection.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.protection.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
	}
	
	---@type TRB.Classes.Paladin.ProtectionSpells
	specCache.protection.spellsData.spells = TRB.Classes.Paladin.ProtectionSpells:New()

	specCache.protection.snapshotData.attributes.manaRegen = 0
	specCache.protection.snapshotData.audio = {
	}

	specCache.protection.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Retribution
	specCache.retribution.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.retribution.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		effects = {
		},
	}
	
	---@type TRB.Classes.Paladin.RetributionSpells
	specCache.retribution.spellsData.spells = TRB.Classes.Paladin.RetributionSpells:New()

	specCache.retribution.snapshotData.attributes.manaRegen = 0
	specCache.retribution.snapshotData.audio = {
	}

	specCache.retribution.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Holy()
	TRB.Functions.Character:FillSpecializationCacheSettings("paladin", "holy", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Holy using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Paladin.BarGroupsFactory:CreateForSpec(1, UIParent)
end

local function FillSpellData_Holy()
	Setup_Holy()
	specCache.holy.spellsData:FillSpellData()
	local spells = specCache.holy.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.holy.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		
		--[[{ variable = "#iol", icon = spells.infusionOfLight.icon, description = spells.infusionOfLight.name, printInSettings = true },
		{ variable = "#infusionOfLight", icon = spells.infusionOfLight.icon, description = spells.infusionOfLight.name, printInSettings = false },]]
	}
	specCache.holy.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Protection()
	TRB.Functions.Character:FillSpecializationCacheSettings("paladin", "protection", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Protection using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Paladin.BarGroupsFactory:CreateForSpec(2, UIParent)
end

local function FillSpellData_Protection()
	Setup_Protection()
	specCache.protection.spellsData:FillSpellData()
	local spells = specCache.protection.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.protection.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.protection.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$health", description = L["BarTextVariable_health"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariable_healthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariable_healthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end

local function Setup_Retribution()
	TRB.Functions.Character:FillSpecializationCacheSettings("paladin", "retribution", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Retribution using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Paladin.BarGroupsFactory:CreateForSpec(3, UIParent)
end

local function FillSpellData_Retribution()
	Setup_Retribution()
	specCache.retribution.spellsData:FillSpellData()
	local spells = specCache.retribution.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.retribution.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.retribution.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
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
	
	if TRB.Data.character.specId == 1 then -- Holy
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Protection
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Retribution
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
	local barGroups = TRB.Frames.barGroups

	-- All Paladin specs use Holy Power (secondary bar). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	-- If it's still nil/0, use the factory's maxNodes as a fallback.
	if barGroups and barGroups.secondary then
		local maxHolyPower = TRB.Data.character.maxResource2
		if maxHolyPower == nil or maxHolyPower == 0 then
			maxHolyPower = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxHolyPower
	end

	-- Create thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
			for _ = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
				TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		TRB.Functions.Bar:ConstructBarGroups(settings, barGroups)
	end

	-- All Paladin specs use Holy Power secondary bar
	if barGroups and barGroups.secondary then
		local maxHolyPower = TRB.Data.character.maxResource2 or 5
		
		-- Ensure secondary group knows the correct node count
		barGroups.secondary:SetNodeCount(maxHolyPower)
		barGroups.secondary:SetLayout(settings.comboPoints.spacing, settings.comboPoints.fullWidth, "HORIZONTAL")
		barGroups.secondary:Show()
		
		-- Apply layout to position all nodes correctly
		barGroups.secondary:ApplyLayout(
			settings.bar.width,
			settings.comboPoints.width,
			settings.comboPoints.height,
			settings.comboPoints.border
		)
		
		-- Explicitly set textures and colors for each Holy Power node
		local frameLevels = TRB.Data.constants.frameLevels
		for i = 1, maxHolyPower do
			local node = barGroups.secondary:GetNode(i)
			if node then
				node:SetTextures(
					settings.textures.comboPointsBar,
					settings.textures.comboPointsBorder,
					settings.textures.comboPointsBackground
				)
				node:SetMinMax(0, 1)
				node:SetBorderColor(settings.colors.comboPoints.border)
				node:SetBackgroundColorFromString(settings.colors.comboPoints.background)
				node:SetColor(settings.colors.comboPoints.base)
				node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Holy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.paladin.holy
	local sharedSettings = TRB.Data.specCache["holy"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.paladin.holy.colors.text.current.color
	local castingManaColor = TRB.Data.settings.paladin.holy.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.paladin.holy.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--[[--$iolTime
	local _iolTime = snapshots[spells.infusionOfLight.id].buff:GetRemainingTime(currentTime)
	local iolTime = TRB.Functions.BarText:TimerPrecision(_iolTime)
	--$iolTicks
	local _iolStacks = snapshots[spells.infusionOfLight.id].buff.applications
	local iolStacks = string.format("%.0f", _iolStacks)
	]]

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
	lookup["$holyPower"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	--[[
	lookup["$iolTime"] = iolTime
	lookup["$iolStacks"] = iolStacks]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$holyPower"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	--[[
	lookupLogic["$iolTime"] = _iolTime
	lookupLogic["$iolStacks"] = _iolStacks]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Protection()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.paladin.protection
	local sharedSettings = TRB.Data.specCache["protection"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.paladin.protection.colors.text.current.color
	local castingManaColor = TRB.Data.settings.paladin.protection.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.paladin.protection.manaPrecision or 1
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
	lookup["$holyPower"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
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
	lookupLogic["$holyPower"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Retribution()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.paladin.retribution
	local sharedSettings = TRB.Data.specCache["retribution"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = TRB.Data.settings.paladin.retribution.colors.text.current.color
	local castingManaColor = TRB.Data.settings.paladin.retribution.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.paladin.retribution.manaPrecision or 1
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
	lookup["$holyPower"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
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
	lookupLogic["$holyPower"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
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

--TODO: Remove?
local function UpdateCastingResourceFinal_Holy()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting

	if TRB.Data.character.specId == 1 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Holy()
		end
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	--local currentTime = GetTime()
end

local function UpdateSnapshot_Holy()
	local currentTime = GetTime()
	UpdateSnapshot()	
end

local function UpdateSnapshot_Protection()
	local currentTime = GetTime()
	UpdateSnapshot()
end

local function UpdateSnapshot_Retribution()
	local currentTime = GetTime()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local refreshText = false
	local classSettings = TRB.Data.settings.paladin
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local barGroups = TRB.Frames.barGroups

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

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	local function UpdateHolyPower(specSettings, specCacheSettings)
		local currentHolyPower = snapshotData.attributes.resource2 or 0
		local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
		for x = 1, TRB.Data.character.maxResource2 do
			local cpBorderColor = specSettings.colors.comboPoints.border
			local cpColor = specSettings.colors.comboPoints.base
			local cpBR = cpBackgroundRed
			local cpBG = cpBackgroundGreen
			local cpBB = cpBackgroundBlue
			local filled = currentHolyPower >= x

			if filled then
				if (specSettings.comboPoints.sameColor and currentHolyPower == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
					cpColor = specSettings.colors.comboPoints.penultimate
				elseif (specSettings.comboPoints.sameColor and currentHolyPower == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
					cpColor = specSettings.colors.comboPoints.final
				end
			end

			if barGroups and barGroups.secondary then
				local holyPowerNode = barGroups.secondary:GetNode(x)
				if holyPowerNode then
					TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, holyPowerNode, filled and 1 or 0, 1)
					holyPowerNode:SetBorderColor(cpBorderColor)
					holyPowerNode:SetColor(cpColor)
					holyPowerNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.holy
		local specCacheSettings = TRB.Data.specCache.holy.settings
		UpdateSnapshot_Holy()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barBorderColor = specSettings.colors.bar.border
				local barColor = specSettings.colors.bar.base
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				UpdateHolyPower(specSettings, specCacheSettings)
			end

			if specSettings.displayBar.health ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.protection
		local specCacheSettings = TRB.Data.specCache.protection.settings
		UpdateSnapshot_Protection()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				UpdateHolyPower(specSettings, specCacheSettings)
			end

			if specSettings.displayBar.health ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.retribution
		local specCacheSettings = TRB.Data.specCache.retribution.settings
		UpdateSnapshot_Retribution()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()
		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				UpdateHolyPower(specSettings, specCacheSettings)
			end

			if specSettings.displayBar.health ~= "never" then
				refreshText = true
				local healthNode = barGroups and barGroups.health and barGroups.health:GetNode(1)
				if healthNode then
					healthNode:SetMinMax(0, snapshotData.attributes.healthMax or 1)
					healthNode:SetValue(snapshotData.attributes.health or 0)
					healthNode:SetColorCurve(snapshotData.attributes.healthColor)
					healthNode:SetBorderColor(specSettings.colors.healthBar.border.color)
					healthNode:SetBackgroundColorFromString(specSettings.colors.healthBar.background.color)
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
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()
	
	if TRB.Data.character.specId == 1 then
		specCache.holy.talents:GetTalents()
		FillSpellData_Holy()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.holy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Holy
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.holy.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "holy" then
			talents = specCache.holy.talents
			TRB.Data.barConstructedForSpec = "holy"
			ConstructResourceBar(specCache.holy.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.protection.talents:GetTalents()
		FillSpellData_Protection()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.protection)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Paladin.ProtectionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Protection
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.protection.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "protection" then
			talents = specCache.protection.talents
			TRB.Data.barConstructedForSpec = "protection"
			ConstructResourceBar(specCache.protection.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.retribution.talents:GetTalents()
		FillSpellData_Retribution()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.retribution)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Paladin.RetributionSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Retribution
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.retribution.settings)

		local lookup = TRB.Data.lookup or {}
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "retribution" then
			talents = specCache.retribution.talents
			TRB.Data.barConstructedForSpec = "retribution"
			ConstructResourceBar(specCache.retribution.settings)
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
				ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
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
	
	if TRB.Data.character.classId == 2 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Paladin.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.paladin == nil or
						TwintopInsanityBarSettings.paladin.holy == nil or
						TwintopInsanityBarSettings.paladin.holy.displayText == nil then
						settings.paladin.holy.displayText.barText = TRB.Options.Paladin.HolyLoadDefaultBarTextSettings()
					elseif TwintopInsanityBarSettings.paladin == nil or
						TwintopInsanityBarSettings.paladin.protection == nil or
						TwintopInsanityBarSettings.paladin.protection.displayText == nil then
						settings.paladin.protection.displayText.barText = TRB.Options.Paladin.ProtectionLoadDefaultBarTextSettings()
					elseif TwintopInsanityBarSettings.paladin == nil or
						TwintopInsanityBarSettings.paladin.retribution == nil or
						TwintopInsanityBarSettings.paladin.retribution.displayText == nil then
						settings.paladin.retribution.displayText.barText = TRB.Options.Paladin.RetributionLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Paladin.LoadDefaultSettings(true)
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
						TRB.Data.settings.paladin.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PaladinHolyFull"], TRB.Data.settings.paladin.holy)
						TRB.Data.settings.paladin.protection = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PaladinProtectionFull"], TRB.Data.settings.paladin.protection)
						TRB.Data.settings.paladin.retribution = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PaladinRetributionFull"], TRB.Data.settings.paladin.retribution)
						
						FillSpellData_Holy()
						FillSpellData_Protection()
						FillSpellData_Retribution()
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Paladin.ConstructOptionsPanel(specCache)
						
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
	TRB.Data.character.className = "paladin"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	TRB.Data.character.maxResource2 = 1
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
		TRB.Data.character.specName = "holy"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "protection"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "retribution"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end

	if sharedSettings ~= nil then
		local barGroups = TRB.Frames.barGroups
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			if barGroups and barGroups.primary then
				TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.paladin.holy then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.HolyPower
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.paladin.protection then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.HolyPower
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.paladin.retribution then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.HolyPower
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		if sharedSettings ~= nil then
			local affectingCombat = TRB.Data.character.inCombat
			local inVehicle = UnitInVehicle("player")
			local forceHideAll = not TRB.Data.specSupported or force or (TRB.Data.character.advancedFlight and not sharedSettings.displayBar.dragonriding)

			-- Determine primary bar visibility independently
			local showPrimary = false
			if not forceHideAll then
				if sharedSettings.displayBar.primary == "always" then
					showPrimary = true
				elseif sharedSettings.displayBar.primary == "combat" then
					showPrimary = affectingCombat or inVehicle
				end
				-- "never" means showPrimary stays false
			end

			-- Determine secondary bar visibility independently
			-- All Paladin specs use the secondary (Holy Power) bar
			local showSecondary = false
			if not forceHideAll then
				if sharedSettings.displayBar.secondary == "always" then
					showSecondary = true
				elseif sharedSettings.displayBar.secondary == "combat" then
					showSecondary = affectingCombat or inVehicle
				end
				-- "never" means showSecondary stays false
			end

			-- Determine health bar visibility independently
			local showHealth = false
			if not forceHideAll then
				if sharedSettings.displayBar.health == "always" then
					showHealth = true
				elseif sharedSettings.displayBar.health == "combat" then
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

			-- Track if any bar is showing
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.paladin.holy
	elseif TRB.Data.character.specId == 2 then
		settings = TRB.Data.settings.paladin.protection
	elseif TRB.Data.character.specId == 3 then
		settings = TRB.Data.settings.paladin.retribution
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Holy
	elseif TRB.Data.character.specId == 2 then --Protection
		-- No spec-specific variables for Protection currently
	elseif TRB.Data.character.specId == 3 then --Retribution
		-- No spec-specific variables for Retribution currently
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
	elseif var == "$comboPoints" or var == "$holyPower" then
		valid = true
	elseif var == "$comboPointsMax"or var == "$holyPowerMax" then
		valid = true
	elseif var == "$health" or var == "$healthMax" or var == "$healthPercent" then
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
	local barGroups = TRB.Frames.barGroups
	if not (barGroups and barGroups.primary) then
		return nil, true, false
	end

	local normalizedRelativeFrame = string.gsub(relativeToFrame or "", "_", "")
	if normalizedRelativeFrame == "Resource" or normalizedRelativeFrame == "ResourceBar" then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
			return primaryNode:GetResourceFrame(), true, isVisible
		end
		return nil, true, false
	end

	if normalizedRelativeFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local holyPowerNode = barGroups.secondary:GetNode(comboPoint)
			if holyPowerNode then
				local isVisible = barGroups.secondary.isVisible and holyPowerNode.isVisible
				return holyPowerNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end