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
local frameLevels = TRB.Data.constants.frameLevels

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local function CoupDeGraceEvent(self, event, ...)
	if event == "COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED" then
		local baseSpellID, overrideSpellID = ...
		-- Dispatch (Outlaw, ID 2098) or Eviscerate (Subtlety, ID 196819) can be replaced by Coup de Grace (ID 441776)
		if baseSpellID == 2098 or baseSpellID == 196819 then
			local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
			if snapshotData and snapshotData.attributes then
				snapshotData.attributes.coupDeGraceActive = (overrideSpellID == 441776)
			end
		end
	end
end
local coupDeGraceFrame = CreateFrame("Frame")
coupDeGraceFrame:SetScript("OnEvent", CoupDeGraceEvent)

local talents --[[@as TRB.Classes.Talents]]

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
	
	---@type TRB.Classes.Rogue.AssassinationSpells
	specCache.rogue_assassination.spellsData.spells = TRB.Classes.Rogue.AssassinationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	local spells = specCache.rogue_assassination.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]

	specCache.rogue_assassination.snapshotData.attributes.resourceRegen = 0
	specCache.rogue_assassination.snapshotData.attributes.comboPoints = 0
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
	
	---@type TRB.Classes.Rogue.OutlawSpells
	specCache.rogue_outlaw.spellsData.spells = TRB.Classes.Rogue.OutlawSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]

	specCache.rogue_outlaw.snapshotData.attributes.resourceRegen = 0
	specCache.rogue_outlaw.snapshotData.attributes.comboPoints = 0
	specCache.rogue_outlaw.snapshotData.attributes.coupDeGraceActive = false
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
	specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id] = TRB.Classes.Snapshot:New(spells.rollTheBones, {
		---@type table<integer, TRB.Classes.Snapshot>
		buffs = {
			[spells.broadside.id] = TRB.Classes.Snapshot:New(spells.broadside),
			[spells.buriedTreasure.id] = TRB.Classes.Snapshot:New(spells.buriedTreasure),
			[spells.grandMelee.id] = TRB.Classes.Snapshot:New(spells.grandMelee),
			[spells.ruthlessPrecision.id] = TRB.Classes.Snapshot:New(spells.ruthlessPrecision),
			[spells.skullAndCrossbones.id] = TRB.Classes.Snapshot:New(spells.skullAndCrossbones),
			[spells.trueBearing.id] =TRB.Classes.Snapshot:New(spells.trueBearing)
		},
		count = 0,
		goodBuffs = false
	})
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.broadside.id] = specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.broadside.id]
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.buriedTreasure.id] = specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.buriedTreasure.id]
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.grandMelee.id] = specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.grandMelee.id]
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.ruthlessPrecision.id] = specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.ruthlessPrecision.id]
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.skullAndCrossbones.id] = specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.skullAndCrossbones.id]
	---@type TRB.Classes.Snapshot
	specCache.rogue_outlaw.snapshotData.snapshots[spells.trueBearing.id] = specCache.rogue_outlaw.snapshotData.snapshots[spells.rollTheBones.id].attributes.buffs[spells.trueBearing.id]
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
	
	---@type TRB.Classes.Rogue.SubtletySpells
	specCache.rogue_subtlety.spellsData.spells = TRB.Classes.Rogue.SubtletySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.rogue_subtlety.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]

	specCache.rogue_subtlety.snapshotData.attributes.resourceRegen = 0
	specCache.rogue_subtlety.snapshotData.attributes.comboPoints = 0
	specCache.rogue_subtlety.snapshotData.attributes.coupDeGraceActive = false
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
	specCache.rogue_subtlety.snapshotData.snapshots[spells.shadowTechniques.id] = TRB.Classes.Snapshot:New(spells.shadowTechniques, nil, "always")
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
		TRB.Frames.barGroups = TRB.Classes.Rogue.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Assassination()
	Setup_Assassination()
	specCache.rogue_assassination.spellsData:FillSpellData()
	local spells = specCache.rogue_assassination.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
	
	TRB.Classes.Rogue.AssassinationSpells.FillBarTextVariables(specCache.rogue_assassination)
end

local function Setup_Outlaw()
	Character:FillSpecializationCacheSettings("rogue", "outlaw")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "rogue_outlaw" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Rogue.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Outlaw()
	Setup_Outlaw()
	specCache.rogue_outlaw.spellsData:FillSpellData()
	local spells = specCache.rogue_outlaw.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]

	TRB.Classes.Rogue.OutlawSpells.FillBarTextVariables(specCache.rogue_outlaw)
end

local function Setup_Subtlety()
	Character:FillSpecializationCacheSettings("rogue", "subtlety")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "rogue_subtlety" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Rogue.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Subtlety()
	Setup_Subtlety()
	specCache.rogue_subtlety.spellsData:FillSpellData()
	local spells = specCache.rogue_subtlety.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]

	TRB.Classes.Rogue.SubtletySpells.FillBarTextVariables(specCache.rogue_subtlety)
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

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
end

local function UpdateRollTheBones()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
	---@type TRB.Classes.Snapshot
	local rollTheBones = TRB.Data.snapshotData.snapshots[spells.rollTheBones.id]
	---@type table<integer, TRB.Classes.Snapshot>
	local buffs = rollTheBones.attributes.buffs
	local currentTime = GetTime()
			
	local rollTheBonesCount = 0
	local highestRemaining = 0
	for _, v in pairs(buffs) do
		local remaining = v.buff:GetRemainingTime(currentTime)
		if v.buff.isActive then
			rollTheBonesCount = rollTheBonesCount + 1
			if remaining > highestRemaining then
				highestRemaining = remaining
			end
		end
	end
	rollTheBones.attributes.count = rollTheBonesCount
	rollTheBones.attributes.remaining = highestRemaining

	if rollTheBones.attributes.count >= 2 or buffs[spells.broadside.id].buff.isActive or buffs[spells.trueBearing.id].buff.isActive then
		rollTheBones.attributes.goodBuffs = true
	else
		rollTheBones.attributes.goodBuffs = false
	end
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.RogueBaseSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

local function UpdateSnapshot_Assassination()
	UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.AssassinationSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()]]
end

local function UpdateSnapshot_Outlaw()
	UpdateSnapshot()
	UpdateRollTheBones()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.OutlawSpells]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots]]
end

local function UpdateSnapshot_Subtlety()
	UpdateSnapshot()
	--[[local spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Rogue.SubtletySpells]
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

local function ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap)
	local flatIndicatorTargets = {}
	for barKey, _ in pairs(barColorMap) do
		flatIndicatorTargets[barKey] = { bar = false, border = false, background = false }
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

local function BuildBarElementOvercapCurves(specSettings, overcapIndicator, barKey, targetColors)
	local curves = {}
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
	thresholds1 = {},
	conditionMap3 = {},
	energyBarColors3 = {},
	comboPointsColors6 = {},
	barColorMap3 = {},
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
		local comboPointSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
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
		local comboPointIndicatorTargets, comboPointOvercapIndicator = ApplyIndicatorColorsToBarMap(comboPointBarColorMap, specSettings.colors.shared, comboPointConditionMap)
		local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, comboPointOvercapIndicator, "comboPointsBar", comboPointsColors)
		local comboPointFlatTargets = comboPointIndicatorTargets.comboPointsBar or { bar = false, border = false, background = false }

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					Bar:ApplyEndCapIndicator(primaryNode, "energyBar")
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive

				local thresholds = primaryNode and primaryNode:GetThresholds() or {}
				local nodeResourceFrame = primaryNode and primaryNode:GetFrame()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if primaryNode and thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
						Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
						if spell.id == spells.ambush.id then
							if stealthViaBuff then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif snapshots[spells.blindside.id].buff.isActive then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								showThreshold = false
							end
						elseif stealthViaBuff then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					else
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.sliceAndDice.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.garrote.id then
								if not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.improvedGarrote.id].attributes.isActiveStealth or snapshots[spells.improvedGarrote.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									elseif snapshots[spell.id].cooldown:IsUnusable() then
										thresholdColor = specCacheSettings.colors.threshold.unusable.color
										frameLevel = frameLevels.thresholdUnusable
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.mutilate.id then
								if specCacheSettings.colors.threshold["echoingReprimand"].enabled and snapshots[spells.echoingReprimand.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold["echoingReprimand"].color
									frameLevel = frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							end
						elseif resourceAmount == 0 then
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.hasCooldown then
							if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
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
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					if	spell:Is("TRB.Classes.SpellComboPointThreshold") and
						spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and
						not isUsable then-- snapshotData.attributes.resource2 == 0 then
						thresholdColor = specCacheSettings.colors.threshold.unusable.color
						frameLevel = frameLevels.thresholdUnusable
					end

					local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
					if thresholds[thresholdId] then
						local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
						Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
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
				local flatIndicatorTargets, overcapIndicator = ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap)
				local energyBarOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "energyBar", energyBarColors)
				local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "comboPointsBar", comboPointsColors)
				local comboPointFlatTargets = flatIndicatorTargets.comboPointsBar or { bar = false, border = false, background = false }

				barColor = energyBarColors.bar
				barBorderColor = energyBarColors.border
				barBackgroundColor = energyBarColors.background

				if barGroups and barGroups.primary then
					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
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
							Bar:ApplyEndCapIndicator(cpNode, "comboPointsBar")
						end
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		-- Combo Point threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessComboPointAudioCues(specSettings)
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.outlaw
		local specCacheSettings = TRB.Data.specCache.rogue_outlaw.settings
		UpdateSnapshot_Outlaw()
		local comboPointSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
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
		local comboPointIndicatorTargets, comboPointOvercapIndicator = ApplyIndicatorColorsToBarMap(comboPointBarColorMap, specSettings.colors.shared, comboPointConditionMap)
		local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, comboPointOvercapIndicator, "comboPointsBar", comboPointsColors)
		local comboPointFlatTargets = comboPointIndicatorTargets.comboPointsBar or { bar = false, border = false, background = false }

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					Bar:ApplyEndCapIndicator(primaryNode, "energyBar")
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive

				local thresholds = primaryNode and primaryNode:GetThresholds() or {}
				local nodeResourceFrame = primaryNode and primaryNode:GetFrame()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if primaryNode and thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
						Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
						if spell.id == spells.ambush.id then
							if stealthViaBuff then
								if isUsable then
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over.color
								else
									thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							else
								showThreshold = false
							end
						elseif stealthViaBuff then
							if isUsable then
								thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over.color
							else
								thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					else
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.sinisterStrike.id then
								if specCacheSettings.colors.threshold["echoingReprimand"].enabled and snapshots[spells.echoingReprimand.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold["echoingReprimand"].color
									frameLevel = frameLevels.thresholdHighPriority
								elseif isUsable then
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.skullAndCrossbones.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.skullAndCrossbones.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.pistolShot.id then
								if isUsable then
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.opportunity.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.opportunity.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.betweenTheEyes.id then
								if snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specCacheSettings.colors.threshold.unusable.color
									frameLevel = frameLevels.thresholdUnusable
								elseif isUsable then
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.ruthlessPrecision.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								else
									if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.ruthlessPrecision.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.sliceAndDice.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.dispatch.id then
								if snapshotData.attributes.coupDeGraceActive then
									showThreshold = false
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.coupDeGrace.id then
								if not snapshotData.attributes.coupDeGraceActive then
									showThreshold = false
								else
									if specCacheSettings.colors.threshold.special.enabled then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								end
							end
						elseif resourceAmount == 0 then
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.hasCooldown then
							if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
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
					end

					if spell:Is("TRB.Classes.SpellComboPointThreshold") and
						spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and
						not isUsable --snapshotData.attributes.resource2 == 0
						then
						thresholdColor = specCacheSettings.colors.threshold.unusable.color
						frameLevel = frameLevels.thresholdUnusable
					end

					if specCacheSettings.colors.threshold["restlessBlades"].enabled and spell.attributes.restlessBlades and
						(spell.attributes.floatLikeAButterfly == nil or (spell.attributes.floatLikeAButterfly and talents:IsTalentActive(spells.floatLikeAButterfly))) and
						snapshot ~= nil and snapshot.cooldown.remainingTotal > 0 and snapshot.cooldown.remaining <= snapshotData.attributes.resource2
						then
						thresholdColor = specCacheSettings.colors.threshold["restlessBlades"].color
						frameLevel = frameLevels.thresholdUnder
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
					if thresholds[thresholdId] then
						local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
						Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
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
				local flatIndicatorTargets, overcapIndicator = ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap)
				local energyBarOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "energyBar", energyBarColors)
				local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "comboPointsBar", comboPointsColors)
				local comboPointFlatTargets = flatIndicatorTargets.comboPointsBar or { bar = false, border = false, background = false }

				barColor = energyBarColors.bar
				barBorderColor = energyBarColors.border
				barBackgroundColor = energyBarColors.background

				if barGroups and barGroups.primary then
					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
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
							Bar:ApplyEndCapIndicator(cpNode, "comboPointsBar")
						end
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		-- Combo Point threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessComboPointAudioCues(specSettings)
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.subtlety
		local specCacheSettings = TRB.Data.specCache.rogue_subtlety.settings
		UpdateSnapshot_Subtlety()
		local comboPointSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
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
		local comboPointIndicatorTargets, comboPointOvercapIndicator = ApplyIndicatorColorsToBarMap(comboPointBarColorMap, specSettings.colors.shared, comboPointConditionMap)
		local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, comboPointOvercapIndicator, "comboPointsBar", comboPointsColors)
		local comboPointFlatTargets = comboPointIndicatorTargets.comboPointsBar or { bar = false, border = false, background = false }

		if snapshotData.attributes.isTracking then
			if not specSettings.displayBar.primary.neverShow then
				local affectingCombat = TRB.Data.character.inCombat
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				local nodeResourceFrame = nil
				if primaryNode then
					nodeResourceFrame = primaryNode:GetFrame()
					Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					Bar:ApplyEndCapIndicator(primaryNode, "energyBar")
				end

				local thresholds = scratch.thresholds1
				wipe(thresholds)
				if primaryNode then
					thresholds = primaryNode:GetThresholds()
				end
				
				local stealthViaBuff = snapshots[spells.subterfuge.id].buff.isActive or snapshots[spells.shadowDance.id].buff.isActive

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if thresholds[thresholdId] == nil and primaryNode then
						thresholds[thresholdId] = primaryNode:RegisterThreshold(thresholdId)
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					
					if spell.attributes.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
						if stealthViaBuff then
							if isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						else
							showThreshold = false
						end
					else
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.sliceAndDice.id then
								if isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.backstab.id then
								if talents:IsTalentActive(spells.gloomblade) then
									showThreshold = false
								else
									if isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.gloomblade.id then
								if not talents:IsTalentActive(spells.gloomblade) then
									showThreshold = false
								else
									if specCacheSettings.colors.threshold["echoingReprimand"].enabled and snapshots[spells.echoingReprimand.id].buff.isActive then
										thresholdColor = specCacheSettings.colors.threshold["echoingReprimand"].color
										frameLevel = frameLevels.thresholdHighPriority
									elseif isUsable then
										thresholdColor = specCacheSettings.colors.threshold.over.color
									else
										thresholdColor = specCacheSettings.colors.threshold.under.color
										frameLevel = frameLevels.thresholdUnder
									end
								end
							elseif spell.id == spells.cheapShot.id then
								if snapshots[spells.shotInTheDark.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.over.color
									frameLevel = frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.shurikenStorm.id then
								if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.silentStorm.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.blackPowder.id then
								if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.finalityBlackPowder.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.eviscerate.id then
								if snapshotData.attributes.coupDeGraceActive then
									showThreshold = false
								elseif specCacheSettings.colors.threshold.special.enabled and snapshots[spells.finalityEviscerate.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = frameLevels.thresholdHighPriority
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = frameLevels.thresholdUnder
								end
							elseif spell.id == spells.coupDeGrace.id then
								if not snapshotData.attributes.coupDeGraceActive then
									showThreshold = false
								else
									if specCacheSettings.colors.threshold.special.enabled then
										thresholdColor = specCacheSettings.colors.threshold.special.color
										frameLevel = frameLevels.thresholdHighPriority
									else
										thresholdColor = specCacheSettings.colors.threshold.over.color
									end
								end
							end
						elseif resourceAmount == 0 then
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.hasCooldown then
							if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
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
					end

					if 	spell:Is("TRB.Classes.SpellComboPointThreshold") and
						spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true then
						if not isUsable then-- snapshotData.attributes.resource2 == 0 then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = frameLevels.thresholdUnusable
						elseif thresholdColor ~= specCacheSettings.colors.threshold.special.color and snapshots[spells.goremawsBite.id].buff.isActive and (snapshotData.snapshots[spell.id] == nil or snapshotData.snapshots[spell.id].cooldown:IsUsable()) then
							thresholdColor = specCacheSettings.colors.threshold.over.color
							frameLevel = frameLevels.thresholdOver
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
					if thresholds[thresholdId] then
						local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
						Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end
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
				local flatIndicatorTargets, overcapIndicator = ApplyIndicatorColorsToBarMap(barColorMap, sharedColors, conditionMap)
				local energyBarOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "energyBar", energyBarColors)
				local comboPointsOvercapCurves = BuildBarElementOvercapCurves(specSettings, overcapIndicator, "comboPointsBar", comboPointsColors)
				local comboPointFlatTargets = flatIndicatorTargets.comboPointsBar or { bar = false, border = false, background = false }

				barColor = energyBarColors.bar
				barBorderColor = energyBarColors.border
				barBackgroundColor = energyBarColors.background
				
				if barGroups and barGroups.primary then
					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
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
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
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
						
							local isCharged = false
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
										isCharged = true
									end
								end
							end

							if not isCharged and x > snapshotData.attributes.resource2 and (snapshots[spells.shadowTechniques.id].buff.applications + snapshotData.attributes.resource2) >= x then
								if not comboPointBorderOverrideActive then
									cpBorderColor = specSettings.colors.comboPoints.shadowTechniques.color
								end
								if not comboPointBackgroundOverrideActive then
									cpBR, cpBG, cpBB, _ = Color:GetRGBAFromString(specSettings.colors.comboPoints.shadowTechniques.color, true)
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
							Bar:ApplyEndCapIndicator(cpNode, "comboPointsBar")
						end
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		-- Combo Point threshold audio cues (independent of bar visibility)
		if TRB.Data.character.inCombat then
			ProcessComboPointAudioCues(specSettings)
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
	coupDeGraceFrame:UnregisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")

	if TRB.Data.character.specId == 1 then
		specCache.rogue_assassination.talents:GetTalents()
		FillSpellData_Assassination()
		Character:LoadFromSpecializationCache(specCache.rogue_assassination)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Rogue.AssassinationSpells]]
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
		local spells = spellsData.spells --[[@as TRB.Classes.Rogue.OutlawSpells]]
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
		lookup["#broadside"] = spells.broadside.icon
		lookup["#buriedTreasure"] = spells.buriedTreasure.icon
		lookup["#deathFromAbove"] = spells.deathFromAbove.icon
		lookup["#dispatch"] = spells.dispatch.icon
		lookup["#dismantle"] = spells.dismantle.icon
		lookup["#grandMelee"] = spells.grandMelee.icon
		lookup["#opportunity"] = spells.opportunity.icon
		lookup["#pistolShot"] = spells.pistolShot.icon
		lookup["#rollTheBones"] = spells.rollTheBones.icon
		lookup["#ruthlessPrecision"] = spells.ruthlessPrecision.icon
		lookup["#sad"] = spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = spells.sliceAndDice.icon
		lookup["#sinisterStrike"] = spells.sinisterStrike.icon
		lookup["#skullAndCrossbones"] = spells.skullAndCrossbones.icon
		lookup["#trueBearing"] = spells.trueBearing.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar
		TRB.Functions.Class:EventRegistration()

		if specCache.rogue_outlaw.talents:IsTalentActive(spells.coupDeGrace) then
			coupDeGraceFrame:RegisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
		end

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
		local spells = spellsData.spells --[[@as TRB.Classes.Rogue.SubtletySpells]]
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
	
	if TRB.Data.character.classId == 4 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Rogue.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.assassination == nil or
						TwintopInsanityBarSettings.rogue.assassination.displayText == nil then
						settings.rogue.assassination.displayText.barText = TRB.Options.Rogue.AssassinationLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.outlaw == nil or
						TwintopInsanityBarSettings.rogue.outlaw.displayText == nil then
						settings.rogue.outlaw.displayText.barText = TRB.Options.Rogue.OutlawLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.rogue == nil or
						TwintopInsanityBarSettings.rogue.subtlety == nil or
						TwintopInsanityBarSettings.rogue.subtlety.displayText == nil then
						settings.rogue.subtlety.displayText.barText = TRB.Options.Rogue.SubtletyLoadDefaultBarTextSettings()
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
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.rogue ~= true then
						TRB.Data.settings.rogue.assassination.displayText.barText = TRB.Options.Rogue.AssassinationLoadDefaultBarTextSettings()
						TRB.Data.settings.rogue.outlaw.displayText.barText = TRB.Options.Rogue.OutlawLoadDefaultBarTextSettings()
						TRB.Data.settings.rogue.subtlety.displayText.barText = TRB.Options.Rogue.SubtletyLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.rogue = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Rogue"])
					end
				else
					local settings = TRB.Options.Rogue.LoadDefaultSettings(true)
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
						TRB.Data.settings.rogue.assassination = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["RogueAssassinationFull"], TRB.Data.settings.rogue.assassination)
						TRB.Data.settings.rogue.outlaw = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["RogueOutlawFull"], TRB.Data.settings.rogue.outlaw)
						TRB.Data.settings.rogue.subtlety = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["RogueSubtletyFull"], TRB.Data.settings.rogue.subtlety)
						
						FillSpellData_Assassination()
						FillSpellData_Outlaw()
						FillSpellData_Subtlety()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Rogue.ConstructOptionsPanel(specCache)

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
				SwitchSpec()
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

		local healthVisSettings = sharedSettings and sharedSettings.displayBar.health or nil

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, true, TRB.Data.character.maxResource2, TRB.Data.character.maxResource2),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, healthVisSettings, true, 1, nil),
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

function TRB.Functions.Class:ResetProcsOnDeath()
	local snapshotData = TRB.Data.snapshotData
	if snapshotData and snapshotData.attributes then
		snapshotData.attributes.coupDeGraceActive = false
	end
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
