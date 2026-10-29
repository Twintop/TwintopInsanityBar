local _, TRB = ...
if TRB.Data.character.classId ~= 4 then --Only do this if we're on a Rogue!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}
local lookupChanged = TRB.Functions.BarText.LookupChanged
local Threshold = TRB.Functions.Threshold
local Bar = TRB.Functions.Bar
local Color = TRB.Functions.Color
local Character = TRB.Functions.Character
-- Inside the 20Hz tick these reuse player/pet curve results until the next power or health event (CurveMemo.lua).
local UnitPowerPercent = TRB.Functions.CurveMemo.UnitPowerPercent

local targetsTimerFrame = TRB.Frames.targetsTimerFrame


local function CoupDeGraceEvent(self, event, ...)
	if event == "COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED" then
		local baseSpellID, overrideSpellID = ...
		-- Coup de Grace replaces Outlaw's Dispatch or Subtlety's Eviscerate; only those specs register this event.
		local finisher
		local coupDeGrace
		if TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
			finisher, coupDeGrace = spells.dispatch, spells.coupDeGrace
		elseif TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.SubtletySpells]]
			finisher, coupDeGrace = spells.eviscerate, spells.coupDeGrace
		end
		if finisher ~= nil and coupDeGrace ~= nil and baseSpellID == finisher.id then
			local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
			if snapshotData and snapshotData.attributes then
				snapshotData.attributes.coupDeGraceActive = (overrideSpellID == coupDeGrace.id)
			end
		end
	end
end
local coupDeGraceFrame = CreateFrame("Frame")
coupDeGraceFrame:SetScript("OnEvent", CoupDeGraceEvent)

local talents --[[@as TRB.Classes.Talents]]

local thresholdBar = TRB.Classes.ThresholdBar:New()
local thresholdState = TRB.Classes.ThresholdState:New() --[[@as TRB.Classes.Mainline.Rogue.ThresholdState]]
local thresholdData = TRB.Classes.ThresholdData:New()

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	rogue_assassination = TRB.Classes.SpecCache:New(),
	rogue_outlaw = TRB.Classes.SpecCache:New(),
	rogue_subtlety = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Assassination
	specCache.rogue_assassination.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.rogue_assassination.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		}
	}
	
	---@type TRB.Classes.Mainline.Rogue.AssassinationSpells
	specCache.rogue_assassination.spellsData.spells = TRB.Classes.Mainline.Rogue.AssassinationSpells:New()
	local spells = specCache.rogue_assassination.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.AssassinationSpells]]

	specCache.rogue_assassination.snapshotData.attributes.resourceRegen = 0
	specCache.rogue_assassination.snapshotData.attributes.comboPoints = 0
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.cheapShot.id] = TRB.Classes.Snapshot:New(spells.cheapShot)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.crimsonVial.id] = TRB.Classes.Snapshot:New(spells.crimsonVial)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.distract.id] = TRB.Classes.Snapshot:New(spells.distract)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.kidneyShot.id] = TRB.Classes.Snapshot:New(spells.kidneyShot)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(spells.sliceAndDice)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.shiv.id] = TRB.Classes.Snapshot:New(spells.shiv)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.feint.id] = TRB.Classes.Snapshot:New(spells.feint)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.gouge.id] = TRB.Classes.Snapshot:New(spells.gouge)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.garrote.id] = TRB.Classes.Snapshot:New(spells.garrote)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.improvedGarrote.id] = TRB.Classes.Snapshot:New(spells.improvedGarrote, {
		isActiveStealth = false
	})
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.kingsbane.id] = TRB.Classes.Snapshot:New(spells.kingsbane)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(spells.deathFromAbove)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.blindside.id] = TRB.Classes.Snapshot:New(spells.blindside)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.dismantle.id] = TRB.Classes.Snapshot:New(spells.dismantle)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.rogue_assassination.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand)

	specCache.rogue_assassination.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Outlaw
	specCache.rogue_outlaw.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.rogue_outlaw.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		}
	}
	
	---@type TRB.Classes.Mainline.Rogue.OutlawSpells
	specCache.rogue_outlaw.spellsData.spells = TRB.Classes.Mainline.Rogue.OutlawSpells:New()
	local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]

	specCache.rogue_outlaw.snapshotData.attributes.resourceRegen = 0
	specCache.rogue_outlaw.snapshotData.attributes.comboPoints = 0
	specCache.rogue_outlaw.snapshotData.attributes.coupDeGraceActive = false
	specCache.rogue_outlaw.snapshotData.attributes.rollTheBonesLevel = 0
	specCache.rogue_outlaw.snapshotData.attributes.restlessBladesSecondsPerComboPoint = spells.restlessBlades.attributes.cooldownReductionPerComboPoint
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.cheapShot.id] = TRB.Classes.Snapshot:New(spells.cheapShot)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.crimsonVial.id] = TRB.Classes.Snapshot:New(spells.crimsonVial)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.distract.id] = TRB.Classes.Snapshot:New(spells.distract)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.feint.id] = TRB.Classes.Snapshot:New(spells.feint)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.kidneyShot.id] = TRB.Classes.Snapshot:New(spells.kidneyShot)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.shiv.id] = TRB.Classes.Snapshot:New(spells.shiv)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.gouge.id] = TRB.Classes.Snapshot:New(spells.gouge)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.betweenTheEyes.id] = TRB.Classes.Snapshot:New(spells.betweenTheEyes)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.bladeFlurry.id] = TRB.Classes.Snapshot:New(spells.bladeFlurry)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.bladeRush.id] = TRB.Classes.Snapshot:New(spells.bladeRush)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(spells.sliceAndDice)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.opportunity.id] = TRB.Classes.Snapshot:New(spells.opportunity)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(spells.deathFromAbove)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.dismantle.id] = TRB.Classes.Snapshot:New(spells.dismantle)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.killingSpree.id] = TRB.Classes.Snapshot:New(spells.killingSpree)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id] = TRB.Classes.Snapshot:New(spells.rollTheBones)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.oneOfAKind.id] = TRB.Classes.Snapshot:New(spells.oneOfAKind)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.doubleTrouble.id] = TRB.Classes.Snapshot:New(spells.doubleTrouble)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.tripleThreat.id] = TRB.Classes.Snapshot:New(spells.tripleThreat)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.jackpot.id] = TRB.Classes.Snapshot:New(spells.jackpot)
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand)

	specCache.rogue_outlaw.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Subtlety
	specCache.rogue_subtlety.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.rogue_subtlety.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		}
	}
	
	---@type TRB.Classes.Mainline.Rogue.SubtletySpells
	specCache.rogue_subtlety.spellsData.spells = TRB.Classes.Mainline.Rogue.SubtletySpells:New()
	local spells = specCache.rogue_subtlety.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.SubtletySpells]]

	specCache.rogue_subtlety.snapshotData.attributes.resourceRegen = 0
	specCache.rogue_subtlety.snapshotData.attributes.comboPoints = 0
	specCache.rogue_subtlety.snapshotData.attributes.coupDeGraceActive = false
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.cheapShot.id] = TRB.Classes.Snapshot:New(spells.cheapShot)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.crimsonVial.id] = TRB.Classes.Snapshot:New(spells.crimsonVial)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.distract.id] = TRB.Classes.Snapshot:New(spells.distract)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.feint.id] = TRB.Classes.Snapshot:New(spells.feint)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.gouge.id] = TRB.Classes.Snapshot:New(spells.gouge)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.kidneyShot.id] = TRB.Classes.Snapshot:New(spells.kidneyShot)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.shiv.id] = TRB.Classes.Snapshot:New(spells.shiv)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.sliceAndDice.id] = TRB.Classes.Snapshot:New(spells.sliceAndDice)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.symbolsOfDeath.id] = TRB.Classes.Snapshot:New(spells.symbolsOfDeath)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.goremawsBite.id] = TRB.Classes.Snapshot:New(spells.goremawsBite)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.secretTechnique.id] = TRB.Classes.Snapshot:New(spells.secretTechnique)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.shadowBlades.id] = TRB.Classes.Snapshot:New(spells.shadowBlades)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.deathFromAbove.id] = TRB.Classes.Snapshot:New(spells.deathFromAbove)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.dismantle.id] = TRB.Classes.Snapshot:New(spells.dismantle)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.subterfuge.id] = TRB.Classes.Snapshot:New(spells.subterfuge)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.shadowDance.id] = TRB.Classes.Snapshot:New(spells.shadowDance)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.shotInTheDark.id] = TRB.Classes.Snapshot:New(spells.shotInTheDark, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.flagellation.id] = TRB.Classes.Snapshot:New(spells.flagellation)
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.silentStorm.id] = TRB.Classes.Snapshot:New(spells.silentStorm, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.finalityBlackPowder.id] = TRB.Classes.Snapshot:New(spells.finalityBlackPowder, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.finalityEviscerate.id] = TRB.Classes.Snapshot:New(spells.finalityEviscerate, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.finalityRupture.id] = TRB.Classes.Snapshot:New(spells.finalityRupture, nil, "always")
	---@type TRB.Classes.Snapshot
	specCache.rogue_subtlety.snapshotData.snapshots[spells.echoingReprimand.id] = TRB.Classes.Snapshot:New(spells.echoingReprimand)

	specCache.rogue_subtlety.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Assassination()
	Character:FillSpecializationCacheSettings("rogue", "assassination")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "rogue_assassination" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Mainline.Rogue.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Assassination()
	Setup_Assassination()
	specCache.rogue_assassination.spellsData:FillSpellData()
	local spells = specCache.rogue_assassination.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.AssassinationSpells]]
	
	TRB.Classes.Mainline.Rogue.AssassinationSpells.FillBarTextVariables(specCache.rogue_assassination)
end

local function Setup_Outlaw()
	Character:FillSpecializationCacheSettings("rogue", "outlaw")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "rogue_outlaw" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Mainline.Rogue.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Outlaw()
	Setup_Outlaw()
	specCache.rogue_outlaw.spellsData:FillSpellData()
	local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]

	TRB.Classes.Mainline.Rogue.OutlawSpells.FillBarTextVariables(specCache.rogue_outlaw)
end

local function Setup_Subtlety()
	Character:FillSpecializationCacheSettings("rogue", "subtlety")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "rogue_subtlety" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Mainline.Rogue.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Subtlety()
	Setup_Subtlety()
	specCache.rogue_subtlety.spellsData:FillSpellData()
	local spells = specCache.rogue_subtlety.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.SubtletySpells]]

	TRB.Classes.Mainline.Rogue.SubtletySpells.FillBarTextVariables(specCache.rogue_subtlety)
end

local function UpdateCastingResourceFinal()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	
	if TRB.Data.character.specId == 1 then -- Assassination
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 2 then -- Outlaw
		targetData:UpdateTrackedSpells(currentTime)
	elseif TRB.Data.character.specId == 3 then -- Outlaw
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

	-- All Rogue specs use secondary bar (Combo Points). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	-- If it's still nil/0, use a fallback.
	if barGroups and barGroups.secondary then
		local maxComboPoints = TRB.Data.character.maxResource2
		if maxComboPoints == nil or maxComboPoints == 0 then
			maxComboPoints = barGroups.secondary.maxNodes or 5
		end
		TRB.Data.character.maxResource2 = maxComboPoints
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

	-- All Rogue specs use secondary bar (Combo Points)
	if barGroups and barGroups.secondary then
		local maxComboPoints = TRB.Data.character.maxResource2 or 5
		
		-- Ensure we have enough nodes for the max combo points
		barGroups.secondary:SetMaxNodes(maxComboPoints)
		
		-- Ensure secondary group knows the correct node count
		Bar:ApplySecondaryBarGroupLayout(settings, barGroups, maxComboPoints)
		barGroups.secondary:Show()
		
		-- Explicitly set textures and colors for each Combo Point node
		for i = 1, maxComboPoints do
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

local function RefreshLookupData_Assassination()
	local specSettings = TRB.Data.settings.rogue.assassination
	local sharedSettings = TRB.Data.specCache["rogue_assassination"].settings
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core energy ($energy, $resource, $casting, $energyMax, $resourceMax, $inStealth)
	if not activeVars or activeVars["$energy"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$energyMax"] or activeVars["$resourceMax"] or activeVars["$inStealth"] then

		local currentEnergyColor = sharedSettings.colors.text.current.color
		local castingEnergyColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.primaryResourceType ~= nil and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
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

		local _castingEnergy = snapshotData.casting.resourceFinal
		if _castingEnergy < 0 then
			castingEnergyColor = sharedSettings.colors.text.spending.color
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
		local isStealthed = IsStealthed()

		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = _castingEnergy
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = snapshotData.attributes.resource
		lookupLogic["$inStealth"] = isStealthed

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$energy", resourceFormatted, currentEnergyColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingEnergy, castingEnergyColor)
		local stealthChanged = lookupChanged(prevState, "$_stealth", isStealthed)
		if resourceChanged or castingChanged or stealthChanged then
			local currentEnergy
			local castingEnergy
			if not isStealthed and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentEnergy = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingEnergy, resourcePrecision, "floor")))
			else
				currentEnergy = string.format("|c%s%s|r", currentEnergyColor, resourceFormatted)
				castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(_castingEnergy, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentEnergy
			lookup["$energy"] = currentEnergy
			lookup["$casting"] = castingEnergy
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$inStealth"] = ""
	end

	-- Block B: Combo Points ($comboPoints, $comboPointsMax)
	if not activeVars or activeVars["$comboPoints"] or activeVars["$comboPointsMax"] then
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Outlaw()
	local specSettings = TRB.Data.settings.rogue.outlaw
	local sharedSettings = TRB.Data.specCache["rogue_outlaw"].settings
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core energy ($energy, $resource, $casting, $energyMax, $resourceMax, $inStealth)
	if not activeVars or activeVars["$energy"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$energyMax"] or activeVars["$resourceMax"] or activeVars["$inStealth"] then

		local currentEnergyColor = sharedSettings.colors.text.current.color
		local castingEnergyColor = sharedSettings.colors.text.casting.color

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
					currentEnergyColor = sharedSettings.colors.text.overThreshold.color
					castingEnergyColor = sharedSettings.colors.text.overThreshold.color
				end
			end
		end

		local _castingEnergy = snapshotData.casting.resourceFinal
		if _castingEnergy < 0 then
			castingEnergyColor = sharedSettings.colors.text.spending.color
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
		local isStealthed = IsStealthed()

		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = _castingEnergy
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = snapshotData.attributes.resource
		lookupLogic["$inStealth"] = isStealthed

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$energy", resourceFormatted, currentEnergyColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingEnergy, castingEnergyColor)
		local stealthChanged = lookupChanged(prevState, "$_stealth", isStealthed)
		if resourceChanged or castingChanged or stealthChanged then
			local currentEnergy
			local castingEnergy
			if not isStealthed and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentEnergy = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingEnergy, resourcePrecision, "floor")))
			else
				currentEnergy = string.format("|c%s%s|r", currentEnergyColor, resourceFormatted)
				castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(_castingEnergy, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentEnergy
			lookup["$energy"] = currentEnergy
			lookup["$casting"] = castingEnergy
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$inStealth"] = ""
	end

	-- Block B: Combo Points ($comboPoints, $comboPointsMax)
	if not activeVars or activeVars["$comboPoints"] or activeVars["$comboPointsMax"] then
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	-- Block C: Roll the Bones ($rtbBuffTime, $rtbBuffName, $rtbBuffLevel, #rtbBuff, and each outcome's time)
	if not activeVars or activeVars["$rtbBuffTime"] or activeVars["$rtbBuffName"] or activeVars["$rtbBuffLevel"] or activeVars["#rtbBuff"]
		or activeVars["$oneOfAKindTime"] or activeVars["$doubleTroubleTime"] or activeVars["$tripleThreatTime"] or activeVars["$jackpotTime"] then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
		local snapshots = snapshotData.snapshots
		local outcome = snapshotData.attributes.rollTheBonesOutcome --[[@as TRB.Classes.SpellBase?]]
		local oneOfAKind = snapshots[spells.oneOfAKind.id].buff
		local doubleTrouble = snapshots[spells.doubleTrouble.id].buff
		local tripleThreat = snapshots[spells.tripleThreat.id].buff
		local jackpot = snapshots[spells.jackpot.id].buff
		local _oneOfAKindTime = oneOfAKind.isActive and oneOfAKind.remaining or 0
		local _doubleTroubleTime = doubleTrouble.isActive and doubleTrouble.remaining or 0
		local _tripleThreatTime = tripleThreat.isActive and tripleThreat.remaining or 0
		local _jackpotTime = jackpot.isActive and jackpot.remaining or 0
		local _rtbBuffTime = 0
		if outcome ~= nil then
			local buff = snapshots[outcome.id].buff
			_rtbBuffTime = buff.isActive and buff.remaining or 0
		end

		lookupLogic["$rtbBuffTime"] = _rtbBuffTime
		lookupLogic["$rtbBuffLevel"] = snapshotData.attributes.rollTheBonesLevel
		lookupLogic["$oneOfAKindTime"] = _oneOfAKindTime
		lookupLogic["$doubleTroubleTime"] = _doubleTroubleTime
		lookupLogic["$tripleThreatTime"] = _tripleThreatTime
		lookupLogic["$jackpotTime"] = _jackpotTime

		lookup["$rtbBuffTime"] = TRB.Functions.BarText:TimerPrecision(_rtbBuffTime)
		lookup["$rtbBuffName"] = outcome ~= nil and outcome.name or ""
		lookup["$rtbBuffLevel"] = snapshotData.attributes.rollTheBonesLevel
		lookup["#rtbBuff"] = outcome ~= nil and outcome.icon or ""
		lookup["$oneOfAKindTime"] = TRB.Functions.BarText:TimerPrecision(_oneOfAKindTime)
		lookup["$doubleTroubleTime"] = TRB.Functions.BarText:TimerPrecision(_doubleTroubleTime)
		lookup["$tripleThreatTime"] = TRB.Functions.BarText:TimerPrecision(_tripleThreatTime)
		lookup["$jackpotTime"] = TRB.Functions.BarText:TimerPrecision(_jackpotTime)
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Subtlety()
	local specSettings = TRB.Data.settings.rogue.subtlety
	local sharedSettings = TRB.Data.specCache["rogue_subtlety"].settings
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core energy ($energy, $resource, $casting, $energyMax, $resourceMax, $inStealth)
	if not activeVars or activeVars["$energy"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$energyMax"] or activeVars["$resourceMax"] or activeVars["$inStealth"] then

		local currentEnergyColor = sharedSettings.colors.text.current.color
		local castingEnergyColor = sharedSettings.colors.text.casting.color

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled then
				local _overThreshold = false
				for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
					if spell ~= nil and spell.primaryResourceType ~= nil and (spell.baseline or (talents.talents[spell.id] ~= nil and talents.talents[spell.id]:IsActive())) and spell:IsUsable() then
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

		local _castingEnergy = snapshotData.casting.resourceFinal
		if _castingEnergy < 0 then
			castingEnergyColor = sharedSettings.colors.text.spending.color
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
		local isStealthed = IsStealthed()

		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resource
		lookupLogic["$casting"] = _castingEnergy
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = snapshotData.attributes.resource
		lookupLogic["$inStealth"] = isStealthed

		local resourceFormatted = snapshotData.formatted.resource or ""
		local resourceChanged = lookupChanged(prevState, "$energy", resourceFormatted, currentEnergyColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingEnergy, castingEnergyColor)
		local stealthChanged = lookupChanged(prevState, "$_stealth", isStealthed)
		if resourceChanged or castingChanged or stealthChanged then
			local currentEnergy
			local castingEnergy
			if not isStealthed and sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentEnergyColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentEnergy = textColorResult:WrapTextInColorCode(resourceFormatted)
				castingEnergy = textColorResult:WrapTextInColorCode(string.format("%.0f", TRB.Functions.Number:RoundTo(_castingEnergy, resourcePrecision, "floor")))
			else
				currentEnergy = string.format("|c%s%s|r", currentEnergyColor, resourceFormatted)
				castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(_castingEnergy, resourcePrecision, "floor"))
			end
			lookup["$resource"] = currentEnergy
			lookup["$energy"] = currentEnergy
			lookup["$casting"] = castingEnergy
		end
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$inStealth"] = ""
	end

	-- Block B: Combo Points ($comboPoints, $comboPointsMax)
	if not activeVars or activeVars["$comboPoints"] or activeVars["$comboPointsMax"] then
		lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

		lookup["$comboPoints"] = snapshotData.formatted.resource2 or ""
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

-- The outcome's SPELL_UPDATE_COOLDOWN and Roll the Bones' cast land in the same frame in either order.
local rollTheBonesCastTime = nil
---@type TRB.Classes.SpellBase?
local pendingOutcome = nil
local pendingOutcomeTime = nil

---The Roll the Bones outcome a spell id names, or nil.
---@param spellId integer
---@return TRB.Classes.SpellBase?
local function GetRollTheBonesOutcome(spellId)
	local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
	for _, outcome in ipairs({ spells.oneOfAKind, spells.doubleTrouble, spells.tripleThreat, spells.jackpot }) do
		if outcome.id == spellId then
			return outcome
		end
	end
	return nil
end

---Sets the outcome values the Outlaw threshold lines read each tick.
---@param outcome TRB.Classes.SpellBase?
local function SetRollTheBonesAttributes(outcome)
	local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
	local attributes = specCache.rogue_outlaw.snapshotData.attributes
	local bonus = 0
	if outcome ~= nil and outcome.attributes.restlessBladesBonus ~= nil then
		bonus = outcome.attributes.restlessBladesBonus
		if specCache.rogue_outlaw.talents:IsTalentActive(spells.dragonBoneDice) then
			bonus = bonus + spells.dragonBoneDice.attributes.restlessBladesBonus
		end
	end
	attributes.rollTheBonesOutcome = outcome
	attributes.rollTheBonesLevel = outcome ~= nil and outcome.attributes.outcomeLevel or 0
	attributes.restlessBladesSecondsPerComboPoint = spells.restlessBlades.attributes.cooldownReductionPerComboPoint * (1 + bonus)
	TRB.Data.lookupDirty = true
end

---Starts the rolled outcome's timer and clears the others; nil clears every outcome.
---@param outcome TRB.Classes.SpellBase?
local function ApplyRollTheBonesOutcome(outcome)
	local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
	local snapshots = specCache.rogue_outlaw.snapshotData.snapshots
	for _, spell in ipairs({ spells.oneOfAKind, spells.doubleTrouble, spells.tripleThreat, spells.jackpot }) do
		if spell == outcome then
			snapshots[spell.id].buff:InitializeCustom(spell.duration)
		else
			snapshots[spell.id].buff:Reset()
		end
	end
	SetRollTheBonesAttributes(outcome)
end

local function ExtendRollTheBonesOutcome()
	local outcome = specCache.rogue_outlaw.snapshotData.attributes.rollTheBonesOutcome --[[@as TRB.Classes.SpellBase?]]
	if outcome == nil then
		return
	end
	local buff = specCache.rogue_outlaw.snapshotData.snapshots[outcome.id].buff
	buff:GetRemainingTime()
	if buff.isActive then
		local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
		buff:AddTimeOrInitializeCustom(spells.keepItRolling.duration)
		TRB.Data.lookupDirty = true
	end
end

local function RollTheBonesEvent(self, event, ...)
	if TRB.Data.character.specId ~= 2 then
		return
	end

	if event == "SPELL_UPDATE_COOLDOWN" then
		local spellId = ...
		local outcome = spellId ~= nil and GetRollTheBonesOutcome(spellId) or nil
		if outcome == nil then
			return
		end
		local currentTime = GetTime()
		if rollTheBonesCastTime == currentTime then
			ApplyRollTheBonesOutcome(outcome)
		else
			pendingOutcome = outcome
			pendingOutcomeTime = currentTime
			return
		end
	elseif event == "ENCOUNTER_END" then
		-- The outcome drops at the end of a raid encounter only.
		if select(2, IsInInstance()) ~= "raid" then
			return
		end
		ApplyRollTheBonesOutcome(nil)
	else
		ApplyRollTheBonesOutcome(nil)
	end
	TRB.Functions.Class:TriggerResourceBarUpdates()
end
local rollTheBonesFrame = CreateFrame("Frame")
rollTheBonesFrame:SetScript("OnEvent", RollTheBonesEvent)
-- Rare events that remove the outcome stay registered; SPELL_UPDATE_COOLDOWN is registered only while Outlaw.
rollTheBonesFrame:RegisterEvent("ENCOUNTER_END")
rollTheBonesFrame:RegisterEvent("CHALLENGE_MODE_START")
rollTheBonesFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	if TRB.Data.character.specId ~= 2 or event ~= "UNIT_SPELLCAST_SUCCEEDED" then
		return
	end

	local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
	if spellId == spells.rollTheBones.id then
		local currentTime = GetTime()
		rollTheBonesCastTime = currentTime
		if pendingOutcome ~= nil and pendingOutcomeTime == currentTime then
			ApplyRollTheBonesOutcome(pendingOutcome)
		end
		pendingOutcome = nil
		pendingOutcomeTime = nil
	elseif spellId == spells.keepItRolling.id then
		ExtendRollTheBonesOutcome()
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Mainline.Rogue.RogueBaseSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

local function UpdateSnapshot_Assassination()
	UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Mainline.Rogue.AssassinationSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

local function UpdateSnapshot_Outlaw()
	UpdateSnapshot()
	local outcome = TRB.Data.snapshotData.attributes.rollTheBonesOutcome --[[@as TRB.Classes.SpellBase?]]
	if outcome ~= nil then
		local buff = TRB.Data.snapshotData.snapshots[outcome.id].buff
		buff:GetRemainingTime()
		-- Nothing fires at the outcome's natural end.
		if not buff.isActive then
			SetRollTheBonesAttributes(nil)
		end
	end
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Mainline.Rogue.OutlawSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots]]
end

local function UpdateSnapshot_Subtlety()
	UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Mainline.Rogue.SubtletySpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

---Processes Combo Point threshold audio cues for any Rogue spec
---@param specSettings table The spec-specific settings table containing audio cues
local function ProcessComboPointAudioCues(specSettings)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, "comboPoints", snapshotData.attributes.resource2)
end

-- Read-only stand-in for a barKey the resolver never targeted; never written to.
local emptyIndicatorFlags = {}

---Resolves indicator colors into barColorMap and records which elements an indicator claimed.
---targets and flagPool are caller-owned: a returned flag table stays live past the caller's next
---call, so every call site needs its own pair rather than sharing one pool.
local function ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap, flatIndicatorTargets, flagPool)
	wipe(flatIndicatorTargets)
	for barKey, _ in pairs(barColorMap) do
		local flags = flagPool[barKey]
		if flags == nil then
			flags = {}
			flagPool[barKey] = flags
		else
			wipe(flags)
		end
		flatIndicatorTargets[barKey] = flags
	end

	local indicatorColors = sharedColors and sharedColors.indicatorColors
	local gradientOrder = sharedColors and sharedColors.gradientOrder

	TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap, flatIndicatorTargets)

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

	return flatIndicatorTargets, overcapIndicator
end

---Fills a caller's scratch table with the overcap indicator's per-element curves for one bar.
---@param curves table # Scratch table, wiped first
local function BuildBarElementOvercapCurves(specSettings, overcapIndicator, barKey, targetColors, curves)
	wipe(curves)
	local targets = overcapIndicator and overcapIndicator.targets and overcapIndicator.targets[barKey]
	if targets == nil or overcapIndicator == nil or overcapIndicator.color == nil then
		return curves
	end

	for elemKey, isTargeted in pairs(targets) do
		local baseColor = targetColors[elemKey]
		if isTargeted and baseColor ~= nil then
			curves[elemKey] = Color:BuildResourceThresholdCurve(specSettings, baseColor, overcapIndicator.color)
		end
	end

	return curves
end

local function EvaluateOvercapCurve(thresholdCurve)
	if thresholdCurve == nil then
		return nil
	end

	return UnitPowerPercent("player", TRB.Data.resource, true, thresholdCurve)
end


-- Reused per-tick scratch tables for UpdateResourceBar (see conditionMap/barColorMap sites).
-- Held in one table so UpdateResourceBar gains a single upvalue rather than one per site.
local scratch = {
	comboPointsColors1 = {},
	comboPointConditionMap1 = {},
	comboPointBarColorMap1 = {},
	conditionMap1 = {},
	energyBarColors1 = {},
	comboPointsColors2 = {},
	barColorMap1 = {},
	comboPointsColors3 = {},
	comboPointConditionMap2 = {},
	comboPointBarColorMap2 = {},
	conditionMap2 = {},
	energyBarColors2 = {},
	comboPointsColors4 = {},
	barColorMap2 = {},
	comboPointsColors5 = {},
	comboPointConditionMap3 = {},
	comboPointBarColorMap3 = {},
	conditionMap3 = {},
	energyBarColors3 = {},
	comboPointsColors6 = {},
	barColorMap3 = {},
	comboPointIndicatorTargets1 = {}, comboPointTargetFlags1 = {},
	comboPointIndicatorTargets2 = {}, comboPointTargetFlags2 = {},
	comboPointIndicatorTargets3 = {}, comboPointTargetFlags3 = {},
	flatIndicatorTargets1 = {}, flatTargetFlags1 = {},
	flatIndicatorTargets2 = {}, flatTargetFlags2 = {},
	flatIndicatorTargets3 = {}, flatTargetFlags3 = {},
	-- One per BuildBarElementOvercapCurves call site; the specs never run in the same tick.
	comboPointOvercapCurves1 = {}, energyBarOvercapCurves1 = {}, comboPointOvercapCurves2 = {},
}

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.rogue
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	Bar:HideResourceBar()

	if TRB.Data.character.maxResource == nil or TRB.Data.character.maxResource2 == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil or snapshotData.attributes.resource2 == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.assassination
		local specCacheSettings = TRB.Data.specCache.rogue_assassination.settings
		UpdateSnapshot_Assassination()
		local comboPointSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.AssassinationSpells]]
		local comboPointAffectingCombat = TRB.Data.character.inCombat
		local comboPointStealthViaBuff = snapshots[comboPointSpells.subterfuge.id].buff.isActive
		local comboPointsColors = scratch.comboPointsColors1
		wipe(comboPointsColors)
		comboPointsColors.bar = specSettings.colors.comboPoints.base
		comboPointsColors.border = specSettings.colors.comboPoints.border.color
		comboPointsColors.background = specSettings.colors.comboPoints.background.color
		local comboPointConditionMap = scratch.comboPointConditionMap1
		wipe(comboPointConditionMap)
		comboPointConditionMap.borderStealth = IsStealthed() or comboPointStealthViaBuff
		comboPointConditionMap.borderOvercap = comboPointAffectingCombat and not (IsStealthed() or comboPointStealthViaBuff)
		local comboPointBarColorMap = scratch.comboPointBarColorMap1
		wipe(comboPointBarColorMap)
		comboPointBarColorMap.comboPointsBar = comboPointsColors
		local comboPointIndicatorTargets, comboPointOvercapIndicator = ApplyIndicatorColorsToBarMap(comboPointBarColorMap, specSettings.colors.shared, comboPointConditionMap, scratch.comboPointIndicatorTargets1, scratch.comboPointTargetFlags1)
		local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, comboPointOvercapIndicator, "comboPointsBar", comboPointsColors, scratch.comboPointOvercapCurves1)
		local comboPointFlatTargets = comboPointIndicatorTargets.comboPointsBar or emptyIndicatorFlags

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.AssassinationSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					Bar:ApplyNodeIndicators(primaryNode, "energyBar")
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive

				if primaryNode then
					thresholdBar:Set(primaryNode, maxPrimaryBarResourceUnnormalized)
					thresholdState:Refresh(specCacheSettings)
					thresholdState.stealthViaBuff = stealthViaBuff
					thresholdData:Refresh(talents)
					Threshold:UpdateSpellThresholds(thresholdBar, thresholdState, thresholdData, TRB.Classes.Mainline.Rogue.AssassinationSpells.thresholdSnowflakes)
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border.color
				local barBackgroundColor = specSettings.colors.bar.background.color
				local stealthActive = IsStealthed() or stealthViaBuff
				local sharedColors = specSettings.colors.shared
				local conditionMap = scratch.conditionMap1
				wipe(conditionMap)
				conditionMap.borderStealth = stealthActive
				conditionMap.borderOvercap = affectingCombat and not stealthActive
				local energyBarColors = scratch.energyBarColors1
				wipe(energyBarColors)
				energyBarColors.bar = barColor
				energyBarColors.border = barBorderColor
				energyBarColors.background = barBackgroundColor
				local comboPointsColors = scratch.comboPointsColors2
				wipe(comboPointsColors)
				comboPointsColors.bar = specSettings.colors.comboPoints.base
				comboPointsColors.border = specSettings.colors.comboPoints.border.color
				comboPointsColors.background = specSettings.colors.comboPoints.background.color
				local barColorMap = scratch.barColorMap1
				wipe(barColorMap)
				barColorMap.energyBar = energyBarColors
				barColorMap.comboPointsBar = comboPointsColors
				local flatIndicatorTargets, overcapIndicator = ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap, scratch.flatIndicatorTargets1, scratch.flatTargetFlags1)
				local energyBarOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "energyBar", energyBarColors, scratch.energyBarOvercapCurves1)
				local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "comboPointsBar", comboPointsColors, scratch.comboPointOvercapCurves2)
				local comboPointFlatTargets = flatIndicatorTargets.comboPointsBar or emptyIndicatorFlags

				barColor = energyBarColors.bar
				barBorderColor = energyBarColors.border
				barBackgroundColor = energyBarColors.background

				if barGroups and barGroups.primary then
					Bar:ClearPrimaryPulse(barGroups)
				end

				if primaryNode then
					if energyBarOvercapCurves.border ~= nil then
						primaryNode:SetBorderColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.border), Color:EvaluateEndCapCurve(primaryNode, energyBarOvercapCurves.border))
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					if energyBarOvercapCurves.bar ~= nil then
						primaryNode:SetColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.bar))
					else
						TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
					end
					if energyBarOvercapCurves.background ~= nil then
						primaryNode:SetBackgroundColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.background))
					else
						primaryNode:SetBackgroundColorFromString(barBackgroundColor)
					end
					Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
				end
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(comboPointsColors.background, true)
				local comboPointBarOverrideActive = comboPointFlatTargets.bar or comboPointsOvercapCurves.bar ~= nil
				local comboPointBorderOverrideActive = comboPointFlatTargets.border or comboPointsOvercapCurves.border ~= nil
				local comboPointBackgroundOverrideActive = comboPointFlatTargets.background or comboPointsOvercapCurves.background ~= nil

				local charged = GetUnitChargedPowerPoints("player")
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = comboPointsColors.border
					local cpColor = comboPointBarOverrideActive and comboPointsColors.bar or specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue
					local sbs = false

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if not comboPointBarOverrideActive then
									local cpFive = specSettings.colors.comboPoints.fiveComboPoints
									local penultimateActive = (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1))
									local finalActive = (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2
									local fiveActive = TRB.Data.character.maxResource2 >= 5 and ((specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == 5) or (not specSettings.comboPoints.sameColor and x == 5))
									if fiveActive and (cpFive.override or (not penultimateActive and not finalActive)) then
										cpColor = cpFive
									elseif penultimateActive then
										cpColor = specSettings.colors.comboPoints.penultimate
									elseif finalActive then
										cpColor = specSettings.colors.comboPoints.final
									end
								end
							else
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
							end

							if charged ~= nil then
								for y = 1, #charged do
									if charged[y] == x then
										if not comboPointBarOverrideActive then
											cpColor = specSettings.colors.comboPoints.echoingReprimand
										end
										
										if not comboPointBorderOverrideActive and not sbs then
											cpBorderColor = specSettings.colors.comboPoints.echoingReprimand.color
										end

										if not comboPointBackgroundOverrideActive then
											cpBR, cpBG, cpBB, _ = Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand.color, true)
										end
									end
								end
							end
							
							if comboPointsOvercapCurves.border ~= nil then
								cpNode:SetBorderColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.border), Color:EvaluateEndCapCurve(cpNode, comboPointsOvercapCurves.border))
							else
								cpNode:SetBorderColor(cpBorderColor)
							end
							if comboPointsOvercapCurves.bar ~= nil then
								cpNode:SetColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.bar))
							else
								TRB.Functions.Color:ApplyFillColor(cpNode, cpColor)
							end
							if comboPointsOvercapCurves.background ~= nil then
								cpNode:SetBackgroundColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.background))
							else
								cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
							end
							Bar:ApplyNodeIndicators(cpNode, "comboPointsBar")
						end
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		-- Threshold line sounds (independent of bar visibility)
		Threshold:UpdateSpellThresholdAudio(specCacheSettings, snapshotData)

		-- Combo Point threshold audio cues (independent of bar visibility)
		ProcessComboPointAudioCues(specSettings)

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.outlaw
		local specCacheSettings = TRB.Data.specCache.rogue_outlaw.settings
		UpdateSnapshot_Outlaw()
		local comboPointSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
		local comboPointAffectingCombat = TRB.Data.character.inCombat
		local comboPointStealthViaBuff = snapshots[comboPointSpells.subterfuge.id].buff.isActive
		local comboPointsColors = scratch.comboPointsColors3
		wipe(comboPointsColors)
		comboPointsColors.bar = specSettings.colors.comboPoints.base
		comboPointsColors.border = specSettings.colors.comboPoints.border.color
		comboPointsColors.background = specSettings.colors.comboPoints.background.color
		local comboPointConditionMap = scratch.comboPointConditionMap2
		wipe(comboPointConditionMap)
		comboPointConditionMap.borderStealth = IsStealthed() or comboPointStealthViaBuff
		comboPointConditionMap.borderOvercap = comboPointAffectingCombat and not (IsStealthed() or comboPointStealthViaBuff)
		local comboPointBarColorMap = scratch.comboPointBarColorMap2
		wipe(comboPointBarColorMap)
		comboPointBarColorMap.comboPointsBar = comboPointsColors
		local comboPointIndicatorTargets, comboPointOvercapIndicator = ApplyIndicatorColorsToBarMap(comboPointBarColorMap, specSettings.colors.shared, comboPointConditionMap, scratch.comboPointIndicatorTargets2, scratch.comboPointTargetFlags2)
		local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, comboPointOvercapIndicator, "comboPointsBar", comboPointsColors, scratch.comboPointOvercapCurves1)
		local comboPointFlatTargets = comboPointIndicatorTargets.comboPointsBar or emptyIndicatorFlags

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					Bar:ApplyNodeIndicators(primaryNode, "energyBar")
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive

				if primaryNode then
					thresholdBar:Set(primaryNode, maxPrimaryBarResourceUnnormalized)
					thresholdState:Refresh(specCacheSettings)
					thresholdState.stealthViaBuff = stealthViaBuff
					thresholdData:Refresh(talents)
					Threshold:UpdateSpellThresholds(thresholdBar, thresholdState, thresholdData, TRB.Classes.Mainline.Rogue.OutlawSpells.thresholdSnowflakes)
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border.color
				local barBackgroundColor = specSettings.colors.bar.background.color
				local stealthActive = IsStealthed() or stealthViaBuff
				local sharedColors = specSettings.colors.shared
				local conditionMap = scratch.conditionMap2
				wipe(conditionMap)
				conditionMap.borderStealth = stealthActive
				conditionMap.borderOvercap = affectingCombat and not stealthActive
				local energyBarColors = scratch.energyBarColors2
				wipe(energyBarColors)
				energyBarColors.bar = barColor
				energyBarColors.border = barBorderColor
				energyBarColors.background = barBackgroundColor
				local comboPointsColors = scratch.comboPointsColors4
				wipe(comboPointsColors)
				comboPointsColors.bar = specSettings.colors.comboPoints.base
				comboPointsColors.border = specSettings.colors.comboPoints.border.color
				comboPointsColors.background = specSettings.colors.comboPoints.background.color
				local barColorMap = scratch.barColorMap2
				wipe(barColorMap)
				barColorMap.energyBar = energyBarColors
				barColorMap.comboPointsBar = comboPointsColors
				local flatIndicatorTargets, overcapIndicator = ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap, scratch.flatIndicatorTargets2, scratch.flatTargetFlags2)
				local energyBarOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "energyBar", energyBarColors, scratch.energyBarOvercapCurves1)
				local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "comboPointsBar", comboPointsColors, scratch.comboPointOvercapCurves2)
				local comboPointFlatTargets = flatIndicatorTargets.comboPointsBar or emptyIndicatorFlags

				barColor = energyBarColors.bar
				barBorderColor = energyBarColors.border
				barBackgroundColor = energyBarColors.background

				if barGroups and barGroups.primary then
					Bar:ClearPrimaryPulse(barGroups)
				end

				if primaryNode then
					if energyBarOvercapCurves.border ~= nil then
						primaryNode:SetBorderColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.border), Color:EvaluateEndCapCurve(primaryNode, energyBarOvercapCurves.border))
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					if energyBarOvercapCurves.bar ~= nil then
						primaryNode:SetColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.bar))
					else
						TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
					end
					if energyBarOvercapCurves.background ~= nil then
						primaryNode:SetBackgroundColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.background))
					else
						primaryNode:SetBackgroundColorFromString(barBackgroundColor)
					end
					Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
				end
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(comboPointsColors.background, true)
				local comboPointBarOverrideActive = comboPointFlatTargets.bar or comboPointsOvercapCurves.bar ~= nil
				local comboPointBorderOverrideActive = comboPointFlatTargets.border or comboPointsOvercapCurves.border ~= nil
				local comboPointBackgroundOverrideActive = comboPointFlatTargets.background or comboPointsOvercapCurves.background ~= nil

				local charged = GetUnitChargedPowerPoints("player")

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = comboPointsColors.border
					local cpColor = comboPointBarOverrideActive and comboPointsColors.bar or specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if not comboPointBarOverrideActive then
									local cpFive = specSettings.colors.comboPoints.fiveComboPoints
									local penultimateActive = (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1))
									local finalActive = (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2
									local fiveActive = TRB.Data.character.maxResource2 >= 5 and ((specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == 5) or (not specSettings.comboPoints.sameColor and x == 5))
									if fiveActive and (cpFive.override or (not penultimateActive and not finalActive)) then
										cpColor = cpFive
									elseif penultimateActive then
										cpColor = specSettings.colors.comboPoints.penultimate
									elseif finalActive then
										cpColor = specSettings.colors.comboPoints.final
									end
								end
							else
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
							end

							if charged ~= nil then
								for y = 1, #charged do
									if charged[y] == x then
										if not comboPointBarOverrideActive then
											cpColor = specSettings.colors.comboPoints.echoingReprimand
										end
										if not comboPointBorderOverrideActive then
											cpBorderColor = specSettings.colors.comboPoints.echoingReprimand.color
										end

										if not comboPointBackgroundOverrideActive then
											cpBR, cpBG, cpBB, _ = Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand.color, true)
										end
									end
								end
							end
							
							if comboPointsOvercapCurves.border ~= nil then
								cpNode:SetBorderColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.border), Color:EvaluateEndCapCurve(cpNode, comboPointsOvercapCurves.border))
							else
								cpNode:SetBorderColor(cpBorderColor)
							end
							if comboPointsOvercapCurves.bar ~= nil then
								cpNode:SetColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.bar))
							else
								TRB.Functions.Color:ApplyFillColor(cpNode, cpColor)
							end
							if comboPointsOvercapCurves.background ~= nil then
								cpNode:SetBackgroundColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.background))
							else
								cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
							end
							Bar:ApplyNodeIndicators(cpNode, "comboPointsBar")
						end
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		-- Threshold line sounds (independent of bar visibility)
		Threshold:UpdateSpellThresholdAudio(specCacheSettings, snapshotData)

		-- Combo Point threshold audio cues (independent of bar visibility)
		ProcessComboPointAudioCues(specSettings)

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.subtlety
		local specCacheSettings = TRB.Data.specCache.rogue_subtlety.settings
		UpdateSnapshot_Subtlety()
		local comboPointSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.SubtletySpells]]
		local comboPointAffectingCombat = TRB.Data.character.inCombat
		local comboPointStealthViaBuff = snapshots[comboPointSpells.subterfuge.id].buff.isActive or snapshots[comboPointSpells.shadowDance.id].buff.isActive
		local comboPointsColors = scratch.comboPointsColors5
		wipe(comboPointsColors)
		comboPointsColors.bar = specSettings.colors.comboPoints.base
		comboPointsColors.border = specSettings.colors.comboPoints.border.color
		comboPointsColors.background = specSettings.colors.comboPoints.background.color
		local comboPointConditionMap = scratch.comboPointConditionMap3
		wipe(comboPointConditionMap)
		comboPointConditionMap.borderStealth = comboPointStealthViaBuff or IsStealthed()
		comboPointConditionMap.borderOvercap = comboPointAffectingCombat and not (comboPointStealthViaBuff or IsStealthed())
		local comboPointBarColorMap = scratch.comboPointBarColorMap3
		wipe(comboPointBarColorMap)
		comboPointBarColorMap.comboPointsBar = comboPointsColors
		local comboPointIndicatorTargets, comboPointOvercapIndicator = ApplyIndicatorColorsToBarMap(comboPointBarColorMap, specSettings.colors.shared, comboPointConditionMap, scratch.comboPointIndicatorTargets3, scratch.comboPointTargetFlags3)
		local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, comboPointOvercapIndicator, "comboPointsBar", comboPointsColors, scratch.comboPointOvercapCurves1)
		local comboPointFlatTargets = comboPointIndicatorTargets.comboPointsBar or emptyIndicatorFlags

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.SubtletySpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					Bar:ApplyNodeIndicators(primaryNode, "energyBar")
				end

				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.shadowDance.id].buff.isActive

				if primaryNode then
					thresholdBar:Set(primaryNode, maxPrimaryBarResourceUnnormalized)
					thresholdState:Refresh(specCacheSettings)
					thresholdState.stealthViaBuff = stealthViaBuff
					thresholdData:Refresh(talents)
					Threshold:UpdateSpellThresholds(thresholdBar, thresholdState, thresholdData, TRB.Classes.Mainline.Rogue.SubtletySpells.thresholdSnowflakes)
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border.color
				local barBackgroundColor = specSettings.colors.bar.background.color
				local stealthActive = stealthViaBuff or IsStealthed()
				local sharedColors = specSettings.colors.shared
				local conditionMap = scratch.conditionMap3
				wipe(conditionMap)
				conditionMap.borderStealth = stealthActive
				conditionMap.borderOvercap = affectingCombat and not stealthActive
				local energyBarColors = scratch.energyBarColors3
				wipe(energyBarColors)
				energyBarColors.bar = barColor
				energyBarColors.border = barBorderColor
				energyBarColors.background = barBackgroundColor
				local comboPointsColors = scratch.comboPointsColors6
				wipe(comboPointsColors)
				comboPointsColors.bar = specSettings.colors.comboPoints.base
				comboPointsColors.border = specSettings.colors.comboPoints.border.color
				comboPointsColors.background = specSettings.colors.comboPoints.background.color
				local barColorMap = scratch.barColorMap3
				wipe(barColorMap)
				barColorMap.energyBar = energyBarColors
				barColorMap.comboPointsBar = comboPointsColors
				local flatIndicatorTargets, overcapIndicator = ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap, scratch.flatIndicatorTargets3, scratch.flatTargetFlags3)
				local energyBarOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "energyBar", energyBarColors, scratch.energyBarOvercapCurves1)
				local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "comboPointsBar", comboPointsColors, scratch.comboPointOvercapCurves2)
				local comboPointFlatTargets = flatIndicatorTargets.comboPointsBar or emptyIndicatorFlags

				barColor = energyBarColors.bar
				barBorderColor = energyBarColors.border
				barBackgroundColor = energyBarColors.background
				
				if barGroups and barGroups.primary then
					Bar:ClearPrimaryPulse(barGroups)
				end

				if primaryNode then
					if energyBarOvercapCurves.border ~= nil then
						primaryNode:SetBorderColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.border), Color:EvaluateEndCapCurve(primaryNode, energyBarOvercapCurves.border))
					else
						primaryNode:SetBorderColor(barBorderColor)
					end
					if energyBarOvercapCurves.bar ~= nil then
						primaryNode:SetColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.bar))
					else
						TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
					end
					if energyBarOvercapCurves.background ~= nil then
						primaryNode:SetBackgroundColorCurve(EvaluateOvercapCurve(energyBarOvercapCurves.background))
					else
						primaryNode:SetBackgroundColorFromString(barBackgroundColor)
					end
					Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
				end
			end

			if not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = Color:GetRGBAFromString(comboPointsColors.background, true)
				local comboPointBarOverrideActive = comboPointFlatTargets.bar or comboPointsOvercapCurves.bar ~= nil
				local comboPointBorderOverrideActive = comboPointFlatTargets.border or comboPointsOvercapCurves.border ~= nil
				local comboPointBackgroundOverrideActive = comboPointFlatTargets.background or comboPointsOvercapCurves.background ~= nil

				local charged = GetUnitChargedPowerPoints("player")

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = comboPointsColors.border
					local cpColor = comboPointBarOverrideActive and comboPointsColors.bar or specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local cpNode = barGroups.secondary:GetNode(x)
						if cpNode then
							if snapshotData.attributes.resource2 >= x then
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 1, 1)
								if not comboPointBarOverrideActive then
									local cpFive = specSettings.colors.comboPoints.fiveComboPoints
									local penultimateActive = (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1))
									local finalActive = (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2
									local fiveActive = TRB.Data.character.maxResource2 >= 5 and ((specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == 5) or (not specSettings.comboPoints.sameColor and x == 5))
									if fiveActive and (cpFive.override or (not penultimateActive and not finalActive)) then
										cpColor = cpFive
									elseif penultimateActive then
										cpColor = specSettings.colors.comboPoints.penultimate
									elseif finalActive then
										cpColor = specSettings.colors.comboPoints.final
									end
								end
							else
								Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, cpNode, 0, 1)
							end
						
							if charged ~= nil then
								for y = 1, #charged do
									if charged[y] == x then
										if not comboPointBarOverrideActive then
											cpColor = specSettings.colors.comboPoints.echoingReprimand
										end
										if not comboPointBorderOverrideActive then
											cpBorderColor = specSettings.colors.comboPoints.echoingReprimand.color
										end

										if not comboPointBackgroundOverrideActive then
											cpBR, cpBG, cpBB, _ = Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand.color, true)
										end
									end
								end
							end

							if comboPointsOvercapCurves.border ~= nil then
								cpNode:SetBorderColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.border), Color:EvaluateEndCapCurve(cpNode, comboPointsOvercapCurves.border))
							else
								cpNode:SetBorderColor(cpBorderColor)
							end
							if comboPointsOvercapCurves.bar ~= nil then
								cpNode:SetColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.bar))
							else
								TRB.Functions.Color:ApplyFillColor(cpNode, cpColor)
							end
							if comboPointsOvercapCurves.background ~= nil then
								cpNode:SetBackgroundColorCurve(EvaluateOvercapCurve(comboPointsOvercapCurves.background))
							else
								cpNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
							end
							Bar:ApplyNodeIndicators(cpNode, "comboPointsBar")
						end
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		-- Threshold line sounds (independent of bar visibility)
		Threshold:UpdateSpellThresholdAudio(specCacheSettings, snapshotData)

		-- Combo Point threshold audio cues (independent of bar visibility)
		ProcessComboPointAudioCues(specSettings)

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
	TRB.Data.character.specId = TRB.Flavor.GetSpecializationIndex()
	coupDeGraceFrame:UnregisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
	rollTheBonesFrame:UnregisterEvent("SPELL_UPDATE_COOLDOWN")

	if TRB.Data.character.specId == 1 then
		specCache.rogue_assassination.talents:GetTalents()
		FillSpellData_Assassination()
		Character:LoadFromSpecializationCache(specCache.rogue_assassination)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.AssassinationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		spells.shiv:ResetPrimaryResourceCost()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Assassination
		Bar:UpdateSanityCheckValues(specCache.rogue_assassination.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#blindside"] = spells.blindside.icon
		lookup["#crimsonTempest"] = spells.crimsonTempest.icon
		lookup["#ct"] = spells.crimsonTempest.icon
		lookup["#deathFromAbove"] = spells.deathFromAbove.icon
		lookup["#dismantle"] = spells.dismantle.icon
		lookup["#garrote"] = spells.garrote.icon
		lookup["#rupture"] = spells.rupture.icon
		lookup["#sad"] = spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = spells.sliceAndDice.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= "rogue_assassination" then
			talents = specCache.rogue_assassination.talents
			TRB.Data.barConstructedForSpec = "rogue_assassination"
			ConstructResourceBar(specCache.rogue_assassination.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.rogue_outlaw.talents:GetTalents()
		FillSpellData_Outlaw()
		Character:LoadFromSpecializationCache(specCache.rogue_outlaw)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.OutlawSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Outlaw
		Bar:UpdateSanityCheckValues(specCache.rogue_outlaw.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#adrenalineRush"] = spells.adrenalineRush.icon
		lookup["#betweenTheEyes"] = spells.betweenTheEyes.icon
		lookup["#bladeFlurry"] = spells.bladeFlurry.icon
		lookup["#bladeRush"] = spells.bladeRush.icon
		lookup["#deathFromAbove"] = spells.deathFromAbove.icon
		lookup["#dispatch"] = spells.dispatch.icon
		lookup["#dismantle"] = spells.dismantle.icon
		lookup["#doubleTrouble"] = spells.doubleTrouble.icon
		lookup["#jackpot"] = spells.jackpot.icon
		lookup["#oneOfAKind"] = spells.oneOfAKind.icon
		lookup["#opportunity"] = spells.opportunity.icon
		lookup["#pistolShot"] = spells.pistolShot.icon
		lookup["#rollTheBones"] = spells.rollTheBones.icon
		lookup["#sad"] = spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = spells.sliceAndDice.icon
		lookup["#sinisterStrike"] = spells.sinisterStrike.icon
		lookup["#tripleThreat"] = spells.tripleThreat.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar
		TRB.Functions.Class:EventRegistration()

		if specCache.rogue_outlaw.talents:IsTalentActive(spells.coupDeGrace) then
			coupDeGraceFrame:RegisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
		end
		rollTheBonesFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")

		if TRB.Data.barConstructedForSpec ~= "rogue_outlaw" then
			talents = specCache.rogue_outlaw.talents
			TRB.Data.barConstructedForSpec = "rogue_outlaw"
			ConstructResourceBar(specCache.rogue_outlaw.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.rogue_subtlety.talents:GetTalents()
		FillSpellData_Subtlety()
		Character:LoadFromSpecializationCache(specCache.rogue_subtlety)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Mainline.Rogue.SubtletySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Subtlety
		Bar:UpdateSanityCheckValues(specCache.rogue_subtlety.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#deathFromAbove"] = spells.deathFromAbove.icon
		lookup["#dismantle"] = spells.dismantle.icon
		lookup["#flagellation"] = spells.flagellation.icon
		lookup["#sad"] = spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = spells.sliceAndDice.icon
		lookup["#sod"] = spells.symbolsOfDeath.icon
		lookup["#symbolsOfDeath"] = spells.symbolsOfDeath.icon
		lookup["#shadowTechniques"] = spells.shadowTechniques.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar
		TRB.Functions.Class:EventRegistration()

		if specCache.rogue_subtlety.talents:IsTalentActive(spells.coupDeGrace) then
			coupDeGraceFrame:RegisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
		end

		if TRB.Data.barConstructedForSpec ~= "rogue_subtlety" then
			talents = specCache.rogue_subtlety.talents
			TRB.Data.barConstructedForSpec = "rogue_subtlety"
			ConstructResourceBar(specCache.rogue_subtlety.settings)
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

-- Core runs the shared load sequence (settings load/merge/migrate at ADDON_LOADED, saving at logout,
-- media validation, the deferred first-time setup and spec re-switches); this module only supplies
-- the class-specific pieces.
TRB.Functions.Bootstrap:RegisterClassModule({
	classId = 4,
	specCache = specCache,
	FillSpecializationCache = FillSpecializationCache,
	SwitchSpec = SwitchSpec,
	ConstructResourceBar = ConstructResourceBar,
	fillSpellData = { FillSpellData_Assassination, FillSpellData_Outlaw, FillSpellData_Subtlety },
})

function TRB.Functions.Class:CheckCharacter()
	local specId = TRB.Flavor.GetSpecializationIndex()
	if specId ~= TRB.Data.character.specId then
		SwitchSpec()
	end
	Character:CheckCharacter()
	TRB.Data.character.className = "rogue"
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)
	local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
	local sharedSettings = nil
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "assassination"
		TRB.Data.character.compositeKey = "rogue_assassination"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "outlaw"
		TRB.Data.character.compositeKey = "rogue_outlaw"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	elseif TRB.Data.character.specId == 3 then
		TRB.Data.character.specName = "subtlety"
		TRB.Data.character.compositeKey = "rogue_subtlety"
		sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	end
	
	if sharedSettings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			if barGroups and barGroups.primary then
				Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
			end
			-- Rebuild secondary bar layout when combo point count changes
			if barGroups and barGroups.secondary then
				-- Clear cached node count so ApplyBarGroupsLayout uses the new maxResource2
				barGroups.secondary.lastRebuildNodeCount = nil
				
				barGroups.secondary:SetMaxNodes(maxComboPoints)
				Bar:ApplySecondaryBarGroupLayout(sharedSettings, barGroups, maxComboPoints)
				-- Apply textures and colors to any newly created nodes
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
						TRB.Functions.Color:ApplyFillColor(node, sharedSettings.colors.comboPoints.base)
						node:SetFrameLevel(TRB.Functions.Bar:GetBarFrameLevel("secondary"))
					end
				end
			end
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.rogue.assassination == true then
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.rogue.outlaw == true then
		TRB.Data.specSupported = true
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.rogue.subtlety == true then
		TRB.Data.specSupported = true
	else
		TRB.Data.specSupported = false
	end

	if TRB.Data.specSupported then		
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.ComboPoints
		TRB.Data.resource2Factor = 1
	end

	Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	if not TRB.Functions.BarVisibility:NeedsFullPass(force) then
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

		local healthVisSettings = sharedSettings and sharedSettings.displayBar.health or nil

		local entries = TRB.Functions.BarVisibility:BeginEntries()
		TRB.Functions.BarVisibility:AddEntry(entries, barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil)
		TRB.Functions.BarVisibility:AddEntry(entries, barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, true, TRB.Data.character.maxResource2, TRB.Data.character.maxResource2)
		TRB.Functions.BarVisibility:AddEntry(entries, barGroups and barGroups.health, healthVisSettings, true, 1, nil)

		if sharedSettings ~= nil then
			local context = TRB.Functions.BarVisibility:GetGameStateContext(force)
			TRB.Functions.BarVisibility:ProcessBars(context, entries, snapshotData, sharedSettings)
		else
			TRB.Functions.BarVisibility:HideAllEntries(entries, snapshotData, nil)
		end
	else
		TRB.Functions.BarVisibility:HideAllBarGroups(snapshotData)
	end
end

function TRB.Functions.Class:ResetProcsOnDeath()
	local snapshotData = TRB.Data.snapshotData
	if snapshotData and snapshotData.attributes then
		snapshotData.attributes.coupDeGraceActive = false
	end
	if TRB.Data.character.specId == 2 then
		ApplyRollTheBonesOutcome(nil)
	end
end

-- Outlaw timer variables, keyed to the outcome whose buff drives each one.
local outlawTimerSpells = {
	["$oneOfAKindTime"] = "oneOfAKind",
	["$doubleTroubleTime"] = "doubleTrouble",
	["$tripleThreatTime"] = "tripleThreat",
	["$jackpotTime"] = "jackpot",
}

function TRB.Functions.Class:HasActiveTimers()
	if TRB.Data.character.specId ~= 2 or TRB.Data.snapshotData.attributes.rollTheBonesOutcome == nil then
		return false
	end

	local activeVars = TRB.Data.activeVariables
	if activeVars == nil or activeVars["$rtbBuffTime"] then
		return true
	end

	local spells = TRB.Data.spellsData.spells
	local snapshots = TRB.Data.snapshotData.snapshots
	for variable, spellKey in pairs(outlawTimerSpells) do
		if activeVars[variable] and snapshots[spells[spellKey].id].buff.isActive then
			return true
		end
	end
	return false
end

local specValidVars
do
	local shared = {
		["$resource"] = false, ["$energy"] = false,
		["$resourceMax"] = true, ["$energyMax"] = true,
		["$casting"] = function()
			local c = TRB.Data.snapshotData.casting
			return c.resourceRaw ~= nil and c.resourceRaw ~= 0
		end,
		["$comboPoints"] = true,
		["$comboPointsMax"] = true,
		["$inStealth"] = function() return IsStealthed() end,
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
	}
	local function IsRollTheBonesActive()
		return TRB.Data.snapshotData.attributes.rollTheBonesOutcome ~= nil
	end
	---@param spellKey string
	---@return fun(): boolean
	local function IsOutcomeActive(spellKey)
		return function()
			local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
			local snapshot = spells and spells[spellKey] and TRB.Data.snapshotData.snapshots[spells[spellKey].id]
			return snapshot ~= nil and snapshot.buff.isActive == true
		end
	end
	local outlaw = {}
	for k, v in pairs(shared) do outlaw[k] = v end
	outlaw["$rtbBuffTime"] = IsRollTheBonesActive
	outlaw["$rtbBuffName"] = IsRollTheBonesActive
	outlaw["$rtbBuffLevel"] = IsRollTheBonesActive
	for variable, spellKey in pairs(outlawTimerSpells) do
		outlaw[variable] = IsOutcomeActive(spellKey)
	end
	specValidVars = { [1] = shared, [2] = outlaw, [3] = shared }
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
		relativeToFrame = TRB.Functions.BarText:NormalizeAnchorKey(relativeToFrame)
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
		local comboPointIndex = TRB.Functions.BarText:MatchAnchorKey(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local secondaryNode = barGroups.secondary:GetNode(index)
				if secondaryNode then
					local isVisible = barGroups.secondary.isVisible and secondaryNode.isVisible
					return secondaryNode:GetFrame(), true, isVisible
				end
			end
		-- Handle health bar
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
