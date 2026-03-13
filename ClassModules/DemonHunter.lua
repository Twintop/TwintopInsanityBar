local _, TRB = ...
if TRB.Data.character.classId ~= 12 then --Only do this if we're on a DemonHunter!
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
	demonhunter_havoc = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	demonhunter_vengeance = TRB.Classes.SpecCache:New(), --[[@as TRB.Classes.SpecCache]]
	demonhunter_devourer = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Havoc
	specCache.demonhunter_havoc.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
		burningHatred = {
			fury = 0,
			ticks = 0,
			time = 0
		},
		tacticalRetreat = {
			fury = 0,
			ticks = 0,
			time = 0
		}
	}

	specCache.demonhunter_havoc.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 120,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.DemonHunter.HavocSpells
	specCache.demonhunter_havoc.spellsData.spells = TRB.Classes.DemonHunter.HavocSpells:New()
	local spells = specCache.demonhunter_havoc.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]

	specCache.demonhunter_havoc.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_havoc.snapshotData.snapshots[spells.bladeDance.id] = TRB.Classes.Snapshot:New(spells.bladeDance)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_havoc.snapshotData.snapshots[spells.chaosNova.id] = TRB.Classes.Snapshot:New(spells.chaosNova)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_havoc.snapshotData.snapshots[spells.deathSweep.id] = TRB.Classes.Snapshot:New(spells.deathSweep)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_havoc.snapshotData.snapshots[spells.eyeBeam.id] = TRB.Classes.Snapshot:New(spells.eyeBeam)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_havoc.snapshotData.snapshots[spells.abyssalGaze.id] = TRB.Classes.Snapshot:New(spells.abyssalGaze)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_havoc.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_havoc.snapshotData.snapshots[spells.throwGlaive.id] = TRB.Classes.Snapshot:New(spells.throwGlaive)

	-- vengeance
	specCache.demonhunter_vengeance.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
		burningHatred = {
			fury = 0,
			ticks = 0
		},
		tacticalRetreat = {
			fury = 0,
			ticks = 0
		}
	}

	specCache.demonhunter_vengeance.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 120,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.DemonHunter.VengeanceSpells
	specCache.demonhunter_vengeance.spellsData.spells = TRB.Classes.DemonHunter.VengeanceSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.demonhunter_vengeance.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]

	specCache.demonhunter_vengeance.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_vengeance.snapshotData.snapshots[spells.chaosNova.id] = TRB.Classes.Snapshot:New(spells.chaosNova)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_vengeance.snapshotData.snapshots[spells.felDevastation.id] = TRB.Classes.Snapshot:New(spells.felDevastation)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_vengeance.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_vengeance.snapshotData.snapshots[spells.artOfTheGlaive.id] = TRB.Classes.Snapshot:New(spells.artOfTheGlaive)
	
	-- Devourer
	specCache.demonhunter_devourer.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			burningHatred = 0,
			tacticalRetreat = 0
		},
	}

	specCache.demonhunter_devourer.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 120,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.DemonHunter.DevourerSpells
	specCache.demonhunter_devourer.spellsData.spells = TRB.Classes.DemonHunter.DevourerSpells:New()
	local spells = specCache.demonhunter_devourer.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]

	specCache.demonhunter_devourer.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_devourer.snapshotData.snapshots[spells.metamorphosis.id] = TRB.Classes.Snapshot:New(spells.metamorphosis, nil, "always")
	-----@type TRB.Classes.Snapshot
	--specCache.demonhunter_devourer.snapshotData.snapshots[spells.voidMetamorphosis.id] = TRB.Classes.Snapshot:New(spells.voidMetamorphosis, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_devourer.snapshotData.snapshots[spells.voidRay.id] = TRB.Classes.Snapshot:New(spells.voidRay)
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_devourer.snapshotData.snapshots[spells.soulFragments.id] = TRB.Classes.Snapshot:New(spells.soulFragments, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_devourer.snapshotData.snapshots[spells.collapsingStar.id] = TRB.Classes.Snapshot:New(spells.collapsingStar, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.demonhunter_devourer.snapshotData.snapshots[spells.rollingTorment.id] = TRB.Classes.Snapshot:New(spells.rollingTorment)
end

local function Setup_Havoc()
	Character:FillSpecializationCacheSettings("demonhunter", "havoc")

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "demonhunter_havoc" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.DemonHunter.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Havoc()
	Setup_Havoc()
	specCache.demonhunter_havoc.spellsData:FillSpellData()
	local spells = specCache.demonhunter_havoc.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]

	TRB.Classes.DemonHunter.HavocSpells.FillBarTextVariables(specCache.demonhunter_havoc)
end

local function Setup_Vengeance()
	Character:FillSpecializationCacheSettings("demonhunter", "vengeance")

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "demonhunter_vengeance" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.DemonHunter.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Vengeance()
	Setup_Vengeance()
	specCache.demonhunter_vengeance.spellsData:FillSpellData()
	local spells = specCache.demonhunter_vengeance.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]

	TRB.Classes.DemonHunter.VengeanceSpells.FillBarTextVariables(specCache.demonhunter_vengeance)
end

local function Setup_Devourer()
	Character:FillSpecializationCacheSettings("demonhunter", "devourer")

	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "demonhunter_devourer" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.DemonHunter.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Devourer()
	Setup_Devourer()
	specCache.demonhunter_devourer.spellsData:FillSpellData()
	local spells = specCache.demonhunter_devourer.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]

	TRB.Classes.DemonHunter.DevourerSpells.FillBarTextVariables(specCache.demonhunter_devourer)
end

local function RefreshTargetTracking()
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

	-- Create thresholds on the BarNode (new system)
	if barGroups and barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			-- Clear old thresholds
			primaryNode:ClearThresholds()

			-- Create new threshold frames parented to the BarNode's resourceFrame
			for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
				local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetFrame())
				Threshold:ResetThresholdLine(thresholdFrame, settings, true)
				primaryNode:RegisterThreshold(thresholdFrame)
			end
		end

		-- Construct the bar groups (sets dimensions, colors, textures, positioning)
		Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Show/hide secondary bar based on spec (using BarGroups, not legacy frames)
	if TRB.Data.character.specId == 1 then -- Havoc - no secondary bar
		if barGroups and barGroups.secondary then
			barGroups.secondary:Hide()
		end
	elseif TRB.Data.character.specId == 2 then -- Vengeance - Soul Fragments (6 independent nodes)
		if barGroups and barGroups.secondary then
			local maxSoulFragments = 6

			barGroups.secondary:SetMaxNodes(maxSoulFragments)
			barGroups.secondary:SetNodeCount(maxSoulFragments)
			barGroups.secondary:SetLayout(settings.comboPoints.spacing, Bar:GetMatchWidth(settings.comboPoints), "HORIZONTAL")
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

			local frameLevels = TRB.Data.constants.frameLevels
			for i = 1, maxSoulFragments do
				local node = barGroups.secondary:GetNode(i)
				if node then
					node:SetTextures(
						settings.textures.comboPointsBar,
						settings.textures.comboPointsBorder,
						settings.textures.comboPointsBackground
					)
					-- Stepped min/max: node 1 = 0,1; node 2 = 1,2; ... node 6 = 5,6
					-- All nodes receive the same raw secret value; StatusBar clamping handles fill
					node:SetMinMax(i - 1, i)
					node:SetBorderColor(settings.colors.comboPoints.border.color)
					node:SetBackgroundColorFromString(settings.colors.comboPoints.background.color)
					node:SetColor(settings.colors.comboPoints.base.color)
					node:SetFrameLevel(frameLevels.comboPoint)
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then -- Devourer - has secondary bar (Soul Fragments/Collapsing Star)
		if barGroups and barGroups.secondary then
			-- Set up the secondary bar structure, but don't show it yet
			-- HideResourceBar() will determine visibility based on settings
			barGroups.secondary:SetNodeCount(1)
			local sfNode = barGroups.secondary:GetNode(1)
			if sfNode then
				sfNode:SetMinMax(0, 50)
				
				-- Create 1 threshold for Collapsing Star
				sfNode:ClearThresholds()
				local thresholdFrame = CreateFrame("Frame", nil, sfNode:GetFrame())
				Threshold:ResetThresholdLineComboPoint(thresholdFrame, settings)
				sfNode:RegisterThreshold(thresholdFrame)
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Havoc()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.demonhunter.havoc
	local sharedSettings = TRB.Data.specCache["demonhunter_havoc"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core fury ($fury, $resource, $casting, $furyMax, $resourceMax)
	if not activeVars or activeVars["$fury"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$furyMax"] or activeVars["$resourceMax"] then

		local normalizedResource = snapshotData.attributes.resourceModified
		local _castingFury = snapshotData.casting.resourceFinal
		local currentFuryColor = sharedSettings.colors.text.current.color
		local castingFuryColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.resource and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFuryColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))

		lookupLogic["$resource"] = normalizedResource
		lookupLogic["$fury"] = normalizedResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$furyMax"] = TRB.Data.character.maxResource
		lookupLogic["$casting"] = _castingFury

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$fury", resourceFormatted, currentFuryColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingFury, castingFuryColor)
		if resourceChanged or castingChanged then
			local currentFury
			local castingFury
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentFuryColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentFury = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingFury = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor")))
			else
				currentFury = string.format("|c%s%s|r", currentFuryColor, resourceFormatted)
				castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentFury
			lookup["$fury"] = currentFury
			lookup["$casting"] = castingFury
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$furyMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Metamorphosis ($metaTime, $metamorphosisTime, $voidMetaTime, $voidMetamorphosisTime)
	if not activeVars or activeVars["$metaTime"] or activeVars["$metamorphosisTime"]
		or activeVars["$voidMetaTime"] or activeVars["$voidMetamorphosisTime"] then
		local currentTime = GetTime()
		local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$metaTime"] = _metamorphosisTime
		lookupLogic["$metamorphosisTime"] = _metamorphosisTime
		lookupLogic["$voidMetaTime"] = _metamorphosisTime
		lookupLogic["$voidMetamorphosisTime"] = _metamorphosisTime

		if lookupChanged(prevState, "$metaTime", _metamorphosisTime) then
			local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)
			lookup["$metaTime"] = metamorphosisTime
			lookup["$metamorphosisTime"] = metamorphosisTime
			lookup["$voidMetaTime"] = metamorphosisTime
			lookup["$voidMetamorphosisTime"] = metamorphosisTime
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Vengeance()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.demonhunter.vengeance
	local sharedSettings = TRB.Data.specCache["demonhunter_vengeance"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core fury ($fury, $resource, $casting, $furyMax, $resourceMax)
	if not activeVars or activeVars["$fury"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$furyMax"] or activeVars["$resourceMax"] then

		local normalizedResource = snapshotData.attributes.resourceModified
		local _castingFury = snapshotData.casting.resourceFinal
		local currentFuryColor = sharedSettings.colors.text.current.color
		local castingFuryColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.resource and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFuryColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))

		lookupLogic["$resource"] = normalizedResource
		lookupLogic["$fury"] = normalizedResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$furyMax"] = TRB.Data.character.maxResource
		lookupLogic["$casting"] = _castingFury

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$fury", resourceFormatted, currentFuryColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingFury, castingFuryColor)
		if resourceChanged or castingChanged then
			local currentFury
			local castingFury
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentFuryColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentFury = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingFury = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor")))
			else
				currentFury = string.format("|c%s%s|r", currentFuryColor, resourceFormatted)
				castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentFury
			lookup["$fury"] = currentFury
			lookup["$casting"] = castingFury
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$furyMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Metamorphosis ($metaTime, $metamorphosisTime, $voidMetaTime, $voidMetamorphosisTime)
	if not activeVars or activeVars["$metaTime"] or activeVars["$metamorphosisTime"]
		or activeVars["$voidMetaTime"] or activeVars["$voidMetamorphosisTime"] then
		local currentTime = GetTime()
		local _metamorphosisTime = snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$metaTime"] = _metamorphosisTime
		lookupLogic["$metamorphosisTime"] = _metamorphosisTime
		lookupLogic["$voidMetaTime"] = _metamorphosisTime
		lookupLogic["$voidMetamorphosisTime"] = _metamorphosisTime

		if lookupChanged(prevState, "$metaTime", _metamorphosisTime) then
			local metamorphosisTime = TRB.Functions.BarText:TimerPrecision(_metamorphosisTime)
			lookup["$metaTime"] = metamorphosisTime
			lookup["$metamorphosisTime"] = metamorphosisTime
			lookup["$voidMetaTime"] = metamorphosisTime
			lookup["$voidMetamorphosisTime"] = metamorphosisTime
		end
	end

	-- Block C: Soul Fragments ($soulFragments, $comboPoints, $soulFragmentsMax, $comboPointsMax)
	if not activeVars or activeVars["$soulFragments"] or activeVars["$comboPoints"]
		or activeVars["$soulFragmentsMax"] or activeVars["$comboPointsMax"] then
		local _soulFragments = snapshotData.attributes.resource2

		lookupLogic["$soulFragments"] = _soulFragments
		lookupLogic["$comboPoints"] = _soulFragments
		lookupLogic["$soulFragmentsMax"] = spells.soulFragments.attributes.maxResource
		lookupLogic["$comboPointsMax"] = spells.soulFragments.attributes.maxResource

		if lookupChanged(prevState, "$soulFragments", _soulFragments, nil, true) then
			local soulFragments = string.format("%s", _soulFragments)
			lookup["$soulFragments"] = soulFragments
			lookup["$comboPoints"] = soulFragments
		end

		lookup["$soulFragmentsMax"] = spells.soulFragments.attributes.maxResource
		lookup["$comboPointsMax"] = spells.soulFragments.attributes.maxResource
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Devourer()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local specSettings = TRB.Data.settings.demonhunter.devourer
	local sharedSettings = TRB.Data.specCache["demonhunter_devourer"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core fury ($fury, $resource, $casting, $furyMax, $resourceMax)
	if not activeVars or activeVars["$fury"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$furyMax"] or activeVars["$resourceMax"] then

		local normalizedResource = snapshotData.attributes.resourceModified
		local _castingFury = snapshotData.casting.resourceFinal
		local currentFuryColor = sharedSettings.colors.text.current.color
		local castingFuryColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.resource and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentFuryColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))

		lookupLogic["$resource"] = normalizedResource
		lookupLogic["$fury"] = normalizedResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$furyMax"] = TRB.Data.character.maxResource
		lookupLogic["$casting"] = _castingFury

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$fury", resourceFormatted, currentFuryColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingFury, castingFuryColor)
		if resourceChanged or castingChanged then
			local currentFury
			local castingFury
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentFuryColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentFury = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingFury = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor")))
			else
				currentFury = string.format("|c%s%s|r", currentFuryColor, resourceFormatted)
				castingFury = string.format("|c%s%s|r", castingFuryColor, TRB.Functions.Number:RoundTo(_castingFury, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentFury
			lookup["$fury"] = currentFury
			lookup["$casting"] = castingFury
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$furyMax"] = TRB.Data.character.maxResource
	end

	-- Block B: Soul Fragments / Collapsing Stars + Meta stubs
	if not activeVars or activeVars["$soulFragments"] or activeVars["$comboPoints"]
		or activeVars["$collapsingStar"] or activeVars["$collapsingStars"]
		or activeVars["$soulFragmentsMax"] or activeVars["$comboPointsMax"]
		or activeVars["$collapsingStarMax"] or activeVars["$collapsingStarsMax"]
		or activeVars["$metaTime"] or activeVars["$metamorphosisTime"]
		or activeVars["$voidMetaTime"] or activeVars["$voidMetamorphosisTime"]
		or activeVars["$voidRayUsable"] or activeVars["$collapsingStarUsable"]
		or activeVars["$collapsingStarsUsable"] or activeVars["$rollingTormentFury"] then

		local _soulFragments = snapshotData.attributes.resource2
		local _soulFragmentsMax = snapshotData.attributes.maxResource2
		if type(_soulFragments) ~= "number" then
			_soulFragments = 0
		end
		if type(_soulFragmentsMax) ~= "number" or _soulFragmentsMax <= 0 then
			_soulFragmentsMax = TRB.Data.character.maxResource2Value or 50
		end

		-- If Metamorphosis is active and Collapsing Star talent is not selected, Soul Fragments (Collapsing Star values, really) are disabled
		local metaActive = snapshotData.snapshots[spells.metamorphosis.id].buff.isActive
		if metaActive and not talents:IsTalentActive(spells.collapsingStar) then
			_soulFragments = 0
			_soulFragmentsMax = 0
		end

		local _rollingTormentFury = 0
		if talents:IsTalentActive(spells.rollingTorment) and metaActive then
			_rollingTormentFury = _soulFragments * spells.rollingTorment.attributes.resourceMod
		end

		local _voidRayUsable = (not snapshotData.snapshots[spells.metamorphosis.id].buff.isActive) and (spells.voidRay:IsUsable())
		local _collapsingStarUsable = snapshotData.snapshots[spells.collapsingStar.id].buff.applications >= spells.collapsingStarThreshold.resource

		lookupLogic["$soulFragments"] = _soulFragments
		lookupLogic["$comboPoints"] = _soulFragments
		lookupLogic["$collapsingStar"] = _soulFragments
		lookupLogic["$collapsingStars"] = _soulFragments
		lookupLogic["$soulFragmentsMax"] = _soulFragmentsMax
		lookupLogic["$comboPointsMax"] = _soulFragmentsMax
		lookupLogic["$collapsingStarMax"] = _soulFragmentsMax
		lookupLogic["$collapsingStarsMax"] = _soulFragmentsMax
		lookupLogic["$metaTime"] = 0
		lookupLogic["$metamorphosisTime"] = 0
		lookupLogic["$voidMetaTime"] = 0
		lookupLogic["$voidMetamorphosisTime"] = 0
		lookupLogic["$voidRayUsable"] = _voidRayUsable
		lookupLogic["$collapsingStarUsable"] = _collapsingStarUsable
		lookupLogic["$collapsingStarsUsable"] = _collapsingStarUsable
		lookupLogic["$rollingTormentFury"] = _rollingTormentFury

		if lookupChanged(prevState, "$soulFragments", _soulFragments) then
			local soulFragments = string.format("%s", _soulFragments)
			lookup["$soulFragments"] = soulFragments
			lookup["$comboPoints"] = soulFragments
			lookup["$collapsingStar"] = soulFragments
			lookup["$collapsingStars"] = soulFragments
		end		
		if lookupChanged(prevState, "$soulFragmentsMax", _soulFragmentsMax) then
			local soulFragmentsMax = string.format("%s", _soulFragmentsMax)
			lookup["$soulFragmentsMax"] = soulFragmentsMax
			lookup["$comboPointsMax"] = soulFragmentsMax
			lookup["$collapsingStarMax"] = soulFragmentsMax
			lookup["$collapsingStarsMax"] = soulFragmentsMax
		end

		if lookupChanged(prevState, "$rollingTormentFury", lookupLogic["$rollingTormentFury"]) then
			local rollingTormentFury = string.format("%s", _rollingTormentFury)
			lookup["$rollingTormentFury"] = rollingTormentFury
		end

		lookup["$metaTime"] = ""
		lookup["$metamorphosisTime"] = ""
		lookup["$voidMetaTime"] = ""
		lookup["$voidMetamorphosisTime"] = ""
		lookup["$voidRayUsable"] = ""
		lookup["$collapsingStarUsable"] = ""
		lookup["$collapsingStarsUsable"] = ""
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function CalculateResourceGain_Devourer(resource)
	local modifier = 1.0

	return resource * modifier
end

local function UpdateCastingResourceFinal_Devourer()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateResourceGain_Devourer(TRB.Data.snapshotData.casting.resourceRaw)
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
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			if casting.spellId ~= spells.eyeBeam.id and spellId == spells.eyeBeam.id then
				if talents:IsTalentActive(spells.blindFury) then
					local _, _, _, currentChannelStartTime, currentChannelEndTime, _, _, _ = UnitChannelInfo("player")

					casting.spellId = spells.eyeBeam.id
					casting.startTime = currentChannelStartTime / 1000
					casting.endTime = currentChannelEndTime / 1000
					casting.icon = spells.eyeBeam.icon
					local remainingTime = casting.endTime - currentTime
					--TODO: use SnapshotBuff:UpdateTicks() instead?
					local ticks = TRB.Functions.Number:RoundTo(remainingTime / (spells.blindFury:GetTickRate()), 0, "ceil", true)
					local resource = ticks * spells.blindFury.resource * talents.talents[spells.blindFury.id].currentRank
					casting.resourceRaw = math.max(resource, 0)
					casting.resourceFinal = casting.resourceRaw
				end

				if talents:IsTalentActive(spells.demonic) then
					snapshotData.snapshots[spells.metamorphosis.id].buff:AddTimeOrInitializeCustom(spells.demonic.duration + ((casting.endTime or 0) - (casting.startTime or 0)), currentTime)
				end
			elseif casting.spellId ~= spells.abyssalGaze.id and spellId == spells.abyssalGaze.id then
				if talents:IsTalentActive(spells.blindFury) then
					local _, _, _, currentChannelStartTime, currentChannelEndTime, _, _, _ = UnitChannelInfo("player")

					casting.spellId = spells.abyssalGaze.id
					casting.startTime = currentChannelStartTime / 1000
					casting.endTime = currentChannelEndTime / 1000
					casting.icon = spells.abyssalGaze.icon
					local remainingTime = casting.endTime - currentTime
					--TODO: use SnapshotBuff:UpdateTicks() instead?
					local ticks = TRB.Functions.Number:RoundTo(remainingTime / (spells.blindFury:GetTickRate()), 0, "ceil", true)
					local resource = ticks * spells.blindFury.resource * talents.talents[spells.blindFury.id].currentRank
					casting.resourceRaw = math.max(resource, 0)
					casting.resourceFinal = casting.resourceRaw
				end

				if talents:IsTalentActive(spells.demonic) then
					if not snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
						snapshotData.attributes.shatteredDestinyFury = 0
					end

					snapshotData.snapshots[spells.metamorphosis.id].buff:AddTimeOrInitializeCustom(spells.demonic.duration + ((casting.endTime or 0) - (casting.startTime or 0)), currentTime)
				end
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.metamorphosis.castId then
				if not snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
					snapshotData.attributes.shatteredDestinyFury = 0
				end
				snapshotData.snapshots[spells.metamorphosis.id].buff:AddTimeOrInitializeCustom(spells.metamorphosis.duration, currentTime)
			end

			if talents:IsTalentActive(spells.shatteredDestiny) and snapshotData.snapshots[spells.metamorphosis.id].buff.isActive then
				local furyAmount = 0
				snapshotData.attributes.shatteredDestinyFury = snapshotData.attributes.shatteredDestinyFury or 0

				if spellId == spells.throwGlaive.id then
					furyAmount = spells.throwGlaive:GetPrimaryResourceCost(true)
				elseif spellId == spells.bladeDance.id then
					furyAmount = spells.bladeDance:GetPrimaryResourceCost(true)
				elseif spellId == spells.deathSweep.id then
					furyAmount = spells.deathSweep:GetPrimaryResourceCost(true)
				elseif spellId == spells.chaosStrike.id then
					furyAmount = spells.chaosStrike:GetPrimaryResourceCost(true)
				elseif spellId == spells.annihilation.id then
					furyAmount = spells.annihilation:GetPrimaryResourceCost(true)
				elseif spellId == spells.chaosNova.id then
					furyAmount = spells.chaosNova:GetPrimaryResourceCost(true)
				elseif spellId == spells.eyeBeam.id then
					furyAmount = spells.eyeBeam:GetPrimaryResourceCost(true)
				elseif spellId == spells.abyssalGaze.id then
					furyAmount = spells.abyssalGaze:GetPrimaryResourceCost(true)
				end
				
				local newFuryAmount = snapshotData.attributes.shatteredDestinyFury + furyAmount
				local extensions = math.floor(newFuryAmount / spells.shatteredDestiny.attributes.resourceRequired)
				if extensions > 0 then
					snapshotData.snapshots[spells.metamorphosis.id].buff:AddTimeOrInitializeCustom(extensions * spells.shatteredDestiny.attributes.durationMod, currentTime)
					snapshotData.attributes.shatteredDestinyFury = newFuryAmount % spells.shatteredDestiny.attributes.resourceRequired
				else
					snapshotData.attributes.shatteredDestinyFury = newFuryAmount
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.metamorphosis.castId then
				if snapshotData.attributes.untetheredRageActive then
					snapshotData.snapshots[spells.metamorphosis.id].buff:AddTimeOrInitializeCustom(spells.untetheredRage.duration, currentTime)
				else
					local duration = spells.metamorphosis.duration
					if talents:IsTalentActive(spells.vengefulBeast) then
						duration = duration + spells.vengefulBeast.duration
					end

					snapshotData.snapshots[spells.metamorphosis.id].buff:InitializeCustom(duration, currentTime)
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			if casting.spellId ~= spells.voidRay.id then
				local _, _, _, currentChannelStartTime, currentChannelEndTime, _, _, _ = UnitChannelInfo("player")

				casting.spellId = spells.voidRay.id
				casting.startTime = currentChannelStartTime / 1000
				casting.endTime = currentChannelEndTime / 1000
				casting.icon = spells.voidRay.icon
				local remainingTime = casting.endTime - currentTime
				--TODO: use SnapshotBuff:UpdateTicks() instead?
				--[[local ticks = TRB.Functions.Number:RoundTo(remainingTime / (spells.blindFury:GetTickRate()), 0, "ceil", true)
				local resource = ticks * spells.blindFury.resource * talents.talents[spells.blindFury.id].currentRank
				casting.resourceRaw = math.max(resource, 0)
				casting.resourceFinal = casting.resourceRaw]]
			end
		elseif event == "UNIT_SPELLCAST_START" then
			if spellId == spells.consume.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.consume.resource
				casting.spellId = spells.consume.id
				casting.icon = spells.consume.icon
			end
			UpdateCastingResourceFinal_Devourer()
		end
	end
end


local function DemonHunterEvent(self, event, ...)
	if event == "SPELL_UPDATE_USES" then
		if TRB.Data.character.specId == 2 then
			local spellId, _ = ...
			
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
			if spellId == spells.spiritBomb.id then
				local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
				-- Get Soul Fragment count via Spirit Bomb's GetSpellCastCount (returns 0-6)
				local soulFragments = C_Spell.GetSpellCastCount(spells.spiritBomb.id) or 0
				snapshotData.attributes.resource2 = soulFragments
			end
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
			if spellId == spells.metamorphosis.id and talents:IsTalentActive(spells.untetheredRage) then -- Metamorphosis
				snapshotData.attributes.untetheredRageActive = true
			end
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		if TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
			if spellId == spells.metamorphosis.id then -- Metamorphosis
				snapshotData.attributes.untetheredRageActive = false
			end
		end
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		local spellId = ...
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		if TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
			if spellId == spells.uncontainedFel.id then -- Last Resort fires off Uncontained Fel
				local duration = spells.metamorphosis.duration
				if talents:IsTalentActive(spells.vengefulBeast) then
					duration = duration + spells.vengefulBeast.duration
				end

				snapshotData.snapshots[spells.metamorphosis.id].buff:InitializeCustom(duration, GetTime())
			end
		end
	elseif event == "COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED" then
		local spellId, rSpellId = ...
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		if TRB.Data.character.specId == 1 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
			if spellId == spells.eyeBeam.id then
				if rSpellId == nil or rSpellId ~= spells.abyssalGaze.id then
					snapshotData.attributes.eyeBeamOverride = false
				else
					snapshotData.attributes.eyeBeamOverride = true
				end
			end
		end
	end
end
local spellEventFrame = CreateFrame("Frame")
spellEventFrame:SetScript("OnEvent", DemonHunterEvent)

local function UpdateSnapshot()
	Character:UpdateSnapshot()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells|TRB.Classes.DemonHunter.VengeanceSpells|TRB.Classes.DemonHunter.DevourerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Havoc()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	if (snapshotData.casting.spellId == spells.eyeBeam.id or snapshotData.casting.spellId == spells.abyssalGaze.id) and talents:IsTalentActive(spells.blindFury) then
		local casting = snapshotData.casting
		local remainingTime = casting.endTime - currentTime
		local ticks = TRB.Functions.Number:RoundTo(remainingTime / (spells.blindFury:GetTickRate()), 0, "ceil", true)
		local resource = ticks * spells.blindFury.resource * talents.talents[spells.blindFury.id].currentRank
		casting.resourceRaw = math.max(resource, 0)
		casting.resourceFinal = casting.resourceRaw
	end
end

local function UpdateSnapshot_Vengeance()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
end

local function UpdateSnapshot_Devourer()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()
	local collapsingStarBuff = snapshotData.snapshots[spells.collapsingStar.id].buff
	local soulFragmentsBuff = snapshotData.snapshots[spells.soulFragments.id].buff

	if collapsingStarBuff.isActive then
		snapshotData.attributes.resource2 = collapsingStarBuff.applications
		snapshotData.attributes.maxResource2 = spells.collapsingStar.attributes.maxResource
		snapshotData.attributes.devourerSoulFragmentsLastKnown = snapshotData.attributes.resource2
		snapshotData.attributes.devourerSoulFragmentsLastKnownAt = currentTime
	else
		local maxResource2 = spells.soulFragments.attributes.maxResource
		if talents:IsTalentActive(spells.soulGlutton) then
			maxResource2 = maxResource2 + spells.soulGlutton.attributes.maxResourceMod
		end

		if talents:IsTalentActive(spells.surrenderToTheVoid) then
			maxResource2 = maxResource2 + spells.surrenderToTheVoid.attributes.maxResourceMod
		end

		local resource2 = soulFragmentsBuff.applications
		if type(resource2) ~= "number" then
			resource2 = 0
		end
		if not soulFragmentsBuff.isActive then
			local lastKnown = snapshotData.attributes.devourerSoulFragmentsLastKnown
			local lastKnownAt = snapshotData.attributes.devourerSoulFragmentsLastKnownAt or 0
			if type(lastKnown) == "number" and lastKnown > 0 and (currentTime - lastKnownAt) <= 0.20 then
				resource2 = lastKnown
			end
		else
			snapshotData.attributes.devourerSoulFragmentsLastKnown = resource2
			snapshotData.attributes.devourerSoulFragmentsLastKnownAt = currentTime
		end

		local transitionAt = snapshotData.attributes.devourerTransitionAt or 0
		if resource2 == 0 then
			local lastKnown = snapshotData.attributes.devourerSoulFragmentsLastKnown
			if type(lastKnown) == "number" and lastKnown > 0 and (currentTime - transitionAt) <= 0.60 then
				resource2 = lastKnown
			end
		end

		snapshotData.attributes.resource2 = resource2
		snapshotData.attributes.maxResource2 = maxResource2
	end

end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.demonhunter
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	Bar:HideResourceBar()

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.havoc
		local specCacheSettings = TRB.Data.specCache.demonhunter_havoc.settings
		UpdateSnapshot_Havoc()

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
				local metaTime = snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
				local currentResource = snapshotData.attributes.resource
				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					local resourceFrame = primaryNode:GetFrame()
					local thresholds = primaryNode:GetThresholds()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						pairOffset = (thresholdId - 1) * 3
						local resourceAmount = spell:GetPrimaryResourceCost()
						local isUsable = spell:IsUsable()
						local showThreshold = true
						local thresholdColor = specCacheSettings.colors.threshold.over.color
						local frameLevel = frameLevels.thresholdOver
						local snapshot = snapshots[spell.id]

						if metaTime > 0 and (spell.attributes.demonForm ~= nil and spell.attributes.demonForm == false) then
							showThreshold = false
						elseif metaTime == 0 and (spell.attributes.demonForm ~= nil and spell.attributes.demonForm == true) then
							showThreshold = false
						elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.chaosStrike.id or spell.id == spells.annihilation.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.bladeDance.id or spell.id == spells.deathSweep.id then
								if snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specCacheSettings.colors.threshold.unusable.color
									frameLevel = frameLevels.thresholdUnusable
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.eyeBeam.id or spell.id == spells.abyssalGaze.id then
								if spell.id == spells.eyeBeam.id and snapshotData.attributes.eyeBeamOverride then
									showThreshold = false
								elseif spell.id == spells.abyssalGaze.id and not snapshotData.attributes.eyeBeamOverride then
									showThreshold = false
								else
									if snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
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

						if thresholds[thresholdId] then
							local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
							Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
						end
					end
					
					local barColor = specSettings.colors.bar.base.color
					if snapshots[spells.metamorphosis.id].buff.isActive then
						local timeThreshold = 0
						local useEndOfMetamorphosisColor = false

						if specSettings.endOf.metamorphosis.enabled then
							useEndOfMetamorphosisColor = true
							if specSettings.endOf.metamorphosis.mode == "gcd" then
								local gcd = Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOf.metamorphosis.gcdsMax
							elseif specSettings.endOf.metamorphosis.mode == "time" then
								timeThreshold = specSettings.endOf.metamorphosis.timeMax
							end
						end

						if useEndOfMetamorphosisColor and metaTime <= timeThreshold then
							barColor = specSettings.colors.bar.metamorphosisEnd.color
						elseif specSettings.colors.bar.metamorphosis.enabled then
							barColor = specSettings.colors.bar.metamorphosis.color
						end
					end

					local barBorderColor = specSettings.colors.bar.border.color

					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
						local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
					Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
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
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.vengeance
		local specCacheSettings = TRB.Data.specCache.demonhunter_vengeance.settings
		UpdateSnapshot_Vengeance()

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				local metaTime = snapshots[spells.metamorphosis.id].buff:GetRemainingTime(currentTime)
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					local resourceFrame = primaryNode:GetFrame()
					local thresholds = primaryNode:GetThresholds()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						pairOffset = (thresholdId - 1) * 3
						local resourceAmount = spell:GetPrimaryResourceCost()
						local isUsable = spell:IsUsable()
						local showThreshold = true
						local thresholdColor = specCacheSettings.colors.threshold.over.color
						local frameLevel = frameLevels.thresholdOver
						local snapshot = snapshots[spell.id]
						if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.soulCleave.id or spell.id == spells.spiritBomb.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							end
						elseif resourceAmount == 0 then
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

						-- Note: Cannot check resource2 == 0 for Spirit Bomb as Soul Fragments are now a secret value
						
						if resourceAmount >= maxPrimaryBarResourceUnnormalized then
							showThreshold = false
						end

						if thresholds[thresholdId] then
							local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
							Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
						end
					end
					
					local barColor = specSettings.colors.bar.base.color
					if snapshots[spells.metamorphosis.id].buff.isActive then
						local timeThreshold = 0
						local useEndOfMetamorphosisColor = false

						if specSettings.endOf.metamorphosis.enabled then
							useEndOfMetamorphosisColor = true
							if specSettings.endOf.metamorphosis.mode == "gcd" then
								local gcd = Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOf.metamorphosis.gcdsMax
							elseif specSettings.endOf.metamorphosis.mode == "time" then
								timeThreshold = specSettings.endOf.metamorphosis.timeMax
							end
						end

						if useEndOfMetamorphosisColor and metaTime <= timeThreshold then
							barColor = specSettings.colors.bar.metamorphosisEnd.color
						elseif specSettings.colors.bar.metamorphosis.enabled then
							barColor = specSettings.colors.bar.metamorphosis.color
						end
					end

					local barBorderColor = specSettings.colors.bar.border.color

					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
						local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
					Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
				end
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
				-- Soul Fragments bar (Vengeance, 0-6 fragments, 6 independent nodes)
				local soulFragments = snapshotData.attributes.resource2 or 0
				local maxSoulFragments = TRB.Data.character.maxResource2 or 6
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				local cpBorderColor = specSettings.colors.comboPoints.border.color

				-- Update all 6 Soul Fragment nodes with positional coloring
				if barGroups.secondary then
					for x = 1, maxSoulFragments do
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							-- All nodes get the same raw secret value; each node's stepped
							-- SetMinMax(x-1, x) handles fill via StatusBar clamping
							Bar:SetBarNodeValue(specCacheSettings, "soulFragment" .. x, cpNode, soulFragments)
							cpNode:SetBorderColor(cpBorderColor)
							cpNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)

							-- Positional coloring: base for 1-4, penultimate for 5, final for 6
							local cpColor = specSettings.colors.comboPoints.base.color
							if x == maxSoulFragments then
								cpColor = specSettings.colors.comboPoints.final.color
							elseif x == (maxSoulFragments - 1) then
								cpColor = specSettings.colors.comboPoints.penultimate.color
							end
							cpNode:SetColor(cpColor)
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
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.devourer
		local specCacheSettings = TRB.Data.specCache.demonhunter_devourer.settings
		UpdateSnapshot_Devourer()
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		local metaActive = snapshots[spells.metamorphosis.id].buff.isActive
		local metaUsable = snapshotData.snapshots[spells.soulFragments.id].buff.applications >= snapshotData.attributes.maxResource2
		local collapsingStarUsable = snapshots[spells.collapsingStar.id].buff.applications >= spells.collapsingStarThreshold.resource

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true

				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					local resourceFrame = primaryNode:GetFrame()
					local thresholds = primaryNode:GetThresholds()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						pairOffset = (thresholdId - 1) * 3
						local resourceAmount = spell:GetPrimaryResourceCost()
						local isUsable = spell:IsUsable()
						local showThreshold = true
						local thresholdColor = specCacheSettings.colors.threshold.over.color
						local frameLevel = frameLevels.thresholdOver
						local snapshot = snapshots[spell.id]

						if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually						
							if spell.id == spells.voidRay.id then
								if metaActive then
									showThreshold = false
								else
									resourceAmount = spells.voidRay.resource
									
									if snapshotData.casting.spellId == spells.voidRay.id or snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
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

						if thresholds[thresholdId] then
							local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
							Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
						end
					end
					
					local barColor = specSettings.colors.bar.base.color
					if snapshots[spells.metamorphosis.id].buff.isActive and specSettings.colors.bar.voidMetamorphosis.enabled then
						barColor = specSettings.colors.bar.voidMetamorphosis.color
					end

					local barBorderColor = specSettings.colors.bar.border.color

					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
					-- Apply overcap border color if enabled
					if specSettings.colors.bar.borderOvercap.enabled and affectingCombat then
						local overcapBorderCurve = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, specSettings.colors.bar.borderOvercap.color)
						local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapBorderCurve)
						primaryNode:SetBorderColorCurve(borderColorResult)
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background.color)
					Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
				end
			end

			if not specSettings.displayBar.secondary.neverShow then
				-- Soul Fragments bar (Devourer fixed max)
				local current = snapshotData.attributes.resource2
				local max = snapshotData.attributes.maxResource2
				if type(current) ~= "number" then
					current = 0
				end
				if type(max) ~= "number" or max <= 0 then
					max = TRB.Data.character.maxResource2Value or 50
				end
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(specSettings.colors.comboPoints.background.color, true)
				local cpBorderColor = specSettings.colors.comboPoints.border.color
				local cpColor = specSettings.colors.comboPoints.base.color

				if specSettings.colors.comboPoints.voidMetamorphosisReady.enabled and metaUsable then
					cpColor = specSettings.colors.comboPoints.voidMetamorphosisReady.color
				elseif specSettings.colors.comboPoints.collapsingStarReady.enabled and collapsingStarUsable then
					cpColor = specSettings.colors.comboPoints.collapsingStarReady.color
				elseif metaActive then
					cpColor = specSettings.colors.comboPoints.collapsingStar.color
				end

				local cpBR = cpBackgroundRed
				local cpBG = cpBackgroundGreen
				local cpBB = cpBackgroundBlue

				-- Update secondary bar (Soul Fragments)
				if barGroups.secondary then
					local sfNode = barGroups.secondary:GetNode(1)
					if sfNode then
						local secondaryMin, secondaryMax = sfNode:GetMinMax()
						if secondaryMin ~= 0 or secondaryMax ~= max then
							sfNode:SetMinMax(0, max)
						end
						local expectedValue = math.min(current, max)
						sfNode:SetValue(expectedValue, false)
						sfNode:SetBorderColor(cpBorderColor)
						sfNode:SetColor(cpColor)
						sfNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
						
						-- Collapsing Star threshold (only visible when buff is active)
						local thresholds = sfNode:GetThresholds()
						local sfResourceFrame = sfNode:GetFrame()
						local spell = spells.collapsingStarThreshold
						if thresholds[1] and specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].enabled then
							local showThreshold = false
							local thresholdColor = specCacheSettings.colors.threshold.over.color
							local frameLevel = frameLevels.thresholdOver
							
							if metaActive and talents:IsTalentActive(spells.collapsingStar) then
								showThreshold = true
								local collapsingStarSnapshot = snapshots[spells.collapsingStar.id]
								local resourceAmount = spells.collapsingStarThreshold.resource

								-- Determine usability based on buff applications
								if collapsingStarSnapshot.buff.applications >= resourceAmount then
									thresholdColor = specCacheSettings.colors.threshold.over.color
									frameLevel = frameLevels.thresholdOver
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
								
								thresholds[1]:SetFrameLevel(frameLevel)
								thresholds[1]:Show()
								
								-- Set the threshold color using the proper method
								Color:SetThresholdColor(thresholds[1], thresholdColor, true)
								
								Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[1], showThreshold, sfResourceFrame, resourceAmount, max)
							else
								thresholds[1]:Hide()
							end
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
	spellEventFrame:UnregisterEvent("SPELL_UPDATE_USES")
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
	spellEventFrame:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	spellEventFrame:UnregisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
	if TRB.Data.character.specId == 1 then
		specCache.demonhunter_havoc.talents:GetTalents()
		FillSpellData_Havoc()
		Character:LoadFromSpecializationCache(specCache.demonhunter_havoc)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Havoc
		Bar:UpdateSanityCheckValues(specCache.demonhunter_havoc.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#annihilation"] = spells.annihilation.icon
		lookup["#bladeDance"] = spells.bladeDance.icon
		lookup["#blindFury"] = spells.blindFury.icon
		lookup["#chaosNova"] = spells.chaosNova.icon
		lookup["#chaosStrike"] = spells.chaosStrike.icon
		lookup["#deathSweep"] = spells.deathSweep.icon
		lookup["#eyeBeam"] = spells.eyeBeam.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		spellEventFrame:RegisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")

		if TRB.Data.barConstructedForSpec ~= "demonhunter_havoc" then
			talents = specCache.demonhunter_havoc.talents
			TRB.Data.barConstructedForSpec = "demonhunter_havoc"
			TRB.Functions.Class:EventRegistration()
			ConstructResourceBar(specCache.demonhunter_havoc.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.demonhunter_vengeance.talents:GetTalents()
		FillSpellData_Vengeance()
		Character:LoadFromSpecializationCache(specCache.demonhunter_vengeance)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Vengeance
		Bar:UpdateSanityCheckValues(specCache.demonhunter_vengeance.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		lookup["#soulFragments"] = spells.soulFragments.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		spellEventFrame:RegisterEvent("SPELL_UPDATE_USES")
		spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
		spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
		spellEventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")

		if TRB.Data.barConstructedForSpec ~= "demonhunter_vengeance" then
			talents = specCache.demonhunter_vengeance.talents
			TRB.Data.barConstructedForSpec = "demonhunter_vengeance"
			TRB.Functions.Class:EventRegistration()
			ConstructResourceBar(specCache.demonhunter_vengeance.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.demonhunter_devourer.talents:GetTalents()
		FillSpellData_Devourer()
		Character:LoadFromSpecializationCache(specCache.demonhunter_devourer)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		---@type TRB.Classes.TargetData
		snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Devourer
		Bar:UpdateSanityCheckValues(specCache.demonhunter_devourer.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#collapsingStar"] = spells.collapsingStar.icon
		lookup["#metamorphosis"] = spells.metamorphosis.icon
		lookup["#meta"] = spells.metamorphosis.icon
		lookup["#voidMetamorphosis"] = spells.metamorphosis.icon
		lookup["#voidMeta"] = spells.metamorphosis.icon
		lookup["#voidRay"] = spells.voidRay.icon
		lookup["#rollingTorment"] = spells.rollingTorment.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		snapshotData.snapshots[spells.soulFragments.id].buff:Refresh()

		if TRB.Data.barConstructedForSpec ~= "demonhunter_devourer" then
			talents = specCache.demonhunter_devourer.talents
			TRB.Data.barConstructedForSpec = "demonhunter_devourer"
			TRB.Functions.Class:EventRegistration()
			ConstructResourceBar(specCache.demonhunter_devourer.settings)
		end

		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				snapshotData.snapshots[spells.soulFragments.id].buff:Refresh()
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
	
	if TRB.Data.character.classId == 12 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.DemonHunter.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.havoc == nil or
						TwintopInsanityBarSettings.demonhunter.havoc.displayText == nil then
						settings.demonhunter.havoc.displayText.barText = TRB.Options.DemonHunter.HavocLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.vengeance == nil or
						TwintopInsanityBarSettings.demonhunter.vengeance.displayText == nil then
						settings.demonhunter.vengeance.displayText.barText = TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.demonhunter == nil or
						TwintopInsanityBarSettings.demonhunter.devourer == nil or
						TwintopInsanityBarSettings.demonhunter.devourer.displayText == nil then
						settings.demonhunter.devourer.displayText.barText = TRB.Options.DemonHunter.DevourerLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.demonhunter ~= true then
						TRB.Data.settings.demonhunter.havoc.displayText.barText = TRB.Options.DemonHunter.HavocLoadDefaultBarTextSettings()
						TRB.Data.settings.demonhunter.vengeance.displayText.barText = TRB.Options.DemonHunter.VengeanceLoadDefaultBarTextSettings()
						TRB.Data.settings.demonhunter.devourer.displayText.barText = TRB.Options.DemonHunter.DevourerLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.demonhunter = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["DemonHunter"])
					end
				else
					local settings = TRB.Options.DemonHunter.LoadDefaultSettings(true)
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
						TRB.Data.settings.demonhunter.havoc = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DemonHunterHavocFull"], TRB.Data.settings.demonhunter.havoc)
						TRB.Data.settings.demonhunter.vengeance = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DemonHunterVengeanceFull"], TRB.Data.settings.demonhunter.vengeance)
						TRB.Data.settings.demonhunter.devourer = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["DemonHunterDevourerFull"], TRB.Data.settings.demonhunter.devourer)

						FillSpellData_Havoc()
						FillSpellData_Vengeance()
						FillSpellData_Devourer()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.DemonHunter.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "demonhunter"
	
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Fury, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Fury, false)
	
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]
		TRB.Data.character.specName = "havoc"
		TRB.Data.character.compositeKey = "demonhunter_havoc"
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		TRB.Data.character.specName = "vengeance"
		TRB.Data.character.compositeKey = "demonhunter_vengeance"
		
		-- Soul Fragments: 6 nodes (one per fragment), max 6 fragments
		local maxComboPoints = 6
		TRB.Data.character.maxResource2Value = 6
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if TRB.Frames.barGroups ~= nil then
					local barGroups = TRB.Frames.barGroups
					Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
					-- Rebuild secondary nodes with stepped min/max
					if barGroups.secondary then
						barGroups.secondary:SetMaxNodes(maxComboPoints)
						barGroups.secondary:SetNodeCount(maxComboPoints)
						local frameLevels = TRB.Data.constants.frameLevels
						for i = 1, maxComboPoints do
							local node = barGroups.secondary:GetNode(i)
							if node then
								node:SetMinMax(i - 1, i)
								node:SetTextures(
									sharedSettings.textures.comboPointsBar,
									sharedSettings.textures.comboPointsBorder,
									sharedSettings.textures.comboPointsBackground
								)
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
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
		TRB.Data.character.specName = "devourer"
		TRB.Data.character.compositeKey = "demonhunter_devourer"

		local maxComboPoints = 1
		TRB.Data.character.maxResource2Value = 50
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if TRB.Frames.barGroups ~= nil then
					Bar:ApplyBarGroupsLayout(sharedSettings, TRB.Frames.barGroups)
				end
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.demonhunter.havoc == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.demonhunter.vengeance == true then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		-- Soul Fragments retrieved via C_Spell.GetSpellCastCount(spiritBomb.id)
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Id = spells.spiritBomb.id
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.demonhunter.devourer == true then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Fury
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = 1
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

		-- Secondary (Soul Fragments) only for Vengeance (2) and Devourer (3)
		local hasSecondary = TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3
		local secondaryNodes = nil
		if hasSecondary then
			secondaryNodes = TRB.Data.character.specId == 2 and 6 or 1
		end

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, hasSecondary, secondaryNodes, nil),
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
	local metaFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.metamorphosis.id].buff.isActive
	end
	-- Havoc
	local havoc = {
		["$metamorphosisTime"] = metaFn, ["$metaTime"] = metaFn,
		["$voidMetaTime"] = metaFn, ["$voidMetamorphosisTime"] = metaFn,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true,
		["$resource"] = false, ["$fury"] = false,
		["$resourceMax"] = true, ["$furyMax"] = true,
		["$casting"] = castingFn,
	}
	-- Vengeance
	local vengeance = {
		["$comboPoints"] = false, ["$soulFragments"] = false,
		["$comboPointsMax"] = true, ["$soulFragmentsMax"] = true,
		["$metamorphosisTime"] = metaFn, ["$metaTime"] = metaFn,
		["$voidMetaTime"] = metaFn, ["$voidMetamorphosisTime"] = metaFn,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true,
		["$resource"] = false, ["$fury"] = false,
		["$resourceMax"] = true, ["$furyMax"] = true,
		["$casting"] = castingFn,
	}
	-- Devourer
	local collapsingStarFn = function()
		local spells = TRB.Data.spellsData.spells
		return talents:IsTalentActive(spells.collapsingStar) and TRB.Data.snapshotData.snapshots[spells.collapsingStar.id].buff.isActive
	end
	local collapsingStarMaxFn = function()
		local spells = TRB.Data.spellsData.spells
		return talents:IsTalentActive(spells.collapsingStar) and TRB.Data.snapshotData.snapshots[spells.collapsingStar.id].buff.isActive
	end
	local collapsingStarUsableFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.collapsingStar.id].buff.applications >= spells.collapsingStarThreshold.resource
	end
	local devourer = {
		["$comboPoints"] = true, ["$comboPointsMax"] = true,
		["$soulFragments"] = true, ["$soulFragmentsMax"] = true,
		["$collapsingStar"] = collapsingStarFn, ["$collapsingStars"] = collapsingStarFn,
		["$collapsingStarMax"] =collapsingStarMaxFn, ["$collapsingStarsMax"] = collapsingStarMaxFn,
		["$voidRayUsable"] = function()
			local spells = TRB.Data.spellsData.spells
			local sd = TRB.Data.snapshotData
			return (not sd.snapshots[spells.metamorphosis.id].buff.isActive) and (spells.voidRay:IsUsable())
		end,
		["$collapsingStarUsable"] = collapsingStarUsableFn, ["$collapsingStarsUsable"] = collapsingStarUsableFn,
		["$metamorphosisTime"] = metaFn, ["$metaTime"] = metaFn,
		["$voidMetaTime"] = metaFn, ["$voidMetamorphosisTime"] = metaFn,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true,
		["$resource"] = false, ["$fury"] = false,
		["$resourceMax"] = true, ["$furyMax"] = true,
		["$casting"] = castingFn,
		["$rollingTormentFury"] = function()
			local spells = TRB.Data.spellsData.spells
			return talents:IsTalentActive(spells.rollingTorment) and metaFn()
		end,
	}

	specValidVars = { [1] = havoc, [2] = vengeance, [3] = devourer }
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
		-- Handle secondary resources (ComboPoint1, ComboPoint2, etc.)
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local secondaryNode = barGroups.secondary:GetNode(index)
				if secondaryNode then
					local isVisible = barGroups.secondary.isVisible and secondaryNode.isVisible
					return secondaryNode:GetFrame(), true, isVisible
				end
			end
		elseif relativeToFrame == "HealthBar" or relativeToFrame == "Health" then
			if barGroups and barGroups.health then
				local healthNode = barGroups.health:GetNode(1)
				if healthNode then
					local isVisible = barGroups.health.isVisible and healthNode.isVisible
					return healthNode:GetFrame(), true, isVisible
				end
			end
		end
		return nil, true, false
	end
	return nil, true, false
end

---Recreates thresholds and secondary bar setup when re-enabling a previously disabled spec
---Demon Hunter override: handles primary bar + secondary bar setup for Vengeance/Devourer
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
					Threshold:ResetThresholdLine(thresholdFrame, settings, true)
					primaryNode:RegisterThreshold(thresholdFrame)
				end
			end
		end
	end

	-- Vengeance: Soul Fragments bar with 6 independent nodes (stepped min/max)
	if TRB.Data.character.specId == 2 and barGroups.secondary then
		local maxSoulFragments = 6
		barGroups.secondary:SetMaxNodes(maxSoulFragments)
		barGroups.secondary:SetNodeCount(maxSoulFragments)
		local frameLevels = TRB.Data.constants.frameLevels
		for i = 1, maxSoulFragments do
			local node = barGroups.secondary:GetNode(i)
			if node then
				node:SetMinMax(i - 1, i)
				node:SetTextures(
					settings.textures.comboPointsBar,
					settings.textures.comboPointsBorder,
					settings.textures.comboPointsBackground
				)
				node:SetBorderColor(settings.colors.comboPoints.border.color)
				node:SetBackgroundColorFromString(settings.colors.comboPoints.background.color)
				node:SetColor(settings.colors.comboPoints.base.color)
				node:SetFrameLevel(frameLevels.comboPoint)
			end
		end
	end

	-- Devourer: Soul Fragments bar with 1 threshold for Collapsing Star (0-50 scale)
	if TRB.Data.character.specId == 3 and barGroups.secondary then
		barGroups.secondary:SetNodeCount(1)
		local sfNode = barGroups.secondary:GetNode(1)
		if sfNode then
			sfNode:SetMinMax(0, 50) -- 0-50 for Collapsing Star
			local existingThresholds = sfNode:GetThresholds()
			if not existingThresholds or #existingThresholds ~= 1 then
				sfNode:ClearThresholds()
				local thresholdFrame = CreateFrame("Frame", nil, sfNode:GetFrame())
				Threshold:ResetThresholdLineComboPoint(thresholdFrame, settings)
				sfNode:RegisterThreshold(thresholdFrame)
			end
		end
	end
end

---Returns true when Metamorphosis buff is active (Havoc/Vengeance), producing $metaTime.
---Devourer (specId 3) has no timers.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local specId = TRB.Data.character.specId
	if specId == 1 or specId == 2 then -- Havoc / Vengeance
		local snapshotData = TRB.Data.snapshotData
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if snapshotData and spells and spells.metamorphosis then
			local snapshot = snapshotData.snapshots[spells.metamorphosis.id]
			if snapshot and snapshot.buff and snapshot.buff.isActive then
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
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end