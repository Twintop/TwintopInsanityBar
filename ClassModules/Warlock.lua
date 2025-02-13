local _, TRB = ...
if TRB.Data.character.classId ~= 9 then --Only do this if we're on an Warlock!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local barContainerFrame = TRB.Frames.barContainerFrame
local resource2Frame = TRB.Frames.resource2Frame
local resourceFrame = TRB.Frames.resourceFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame
local barBorderFrame = TRB.Frames.barBorderFrame

local targetsTimerFrame = TRB.Frames.targetsTimerFrame
local timerFrame = TRB.Frames.timerFrame
local combatFrame = TRB.Frames.combatFrame

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	affliction = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]	
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Affliction
	specCache.affliction.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
		},
		isPvp = false
	}

	specCache.affliction.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 10000,
		maxResource2 = 5,
		maxResource2Resource = 0,
		maxResource2ResourceMax = 1000,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Warlock.AfflictionSpells
	specCache.affliction.spellsData.spells = TRB.Classes.Warlock.AfflictionSpells:New()
	local spells = specCache.affliction.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	specCache.affliction.snapshotData.audio = {
		nightfallCue = false,
		tormentedCrescendoCue = false,
		tormentedCrescendo2Cue = false
	}

	specCache.affliction.barTextVariables = {
		icons = {},
		values = {}
	}
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.nightfall.id] = TRB.Classes.Snapshot:New(spells.nightfall)
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.tormentedCrescendo.id] = TRB.Classes.Snapshot:New(spells.tormentedCrescendo)
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.malignOmen.id] = TRB.Classes.Snapshot:New(spells.malignOmen)
	---@type TRB.Classes.Snapshot
	specCache.affliction.snapshotData.snapshots[spells.succulentSoul.id] = TRB.Classes.Snapshot:New(spells.succulentSoul)
end

local function Setup_Affliction()
	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "warlock", "affliction")
end

local function FillSpellData_Affliction()
	Setup_Affliction()
	specCache.affliction.spellsData:FillSpellData()
	local spells = specCache.affliction.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.affliction.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
				
		{ variable = "#agony", icon = spells.agony.icon, description = spells.agony.name, printInSettings = true },
		{ variable = "#corruption", icon = spells.corruption.icon, description = spells.corruption.name, printInSettings = true },
		{ variable = "#haunt", icon = spells.haunt.icon, description = spells.haunt.name, printInSettings = true },
		{ variable = "#malignOmen", icon = spells.malignOmen.icon, description = spells.malignOmen.name, printInSettings = true },
		{ variable = "#nightfall", icon = spells.nightfall.icon, description = spells.nightfall.name, printInSettings = true },
		{ variable = "#phantomSingularity", icon = spells.phantomSingularity.icon, description = spells.phantomSingularity.name, printInSettings = true },
		{ variable = "#shadowEmbrace", icon = spells.shadowEmbrace.icon, description = spells.shadowEmbrace.name, printInSettings = true },
		{ variable = "#soulRot", icon = spells.soulRot.icon, description = spells.soulRot.name, printInSettings = true },
		{ variable = "#succulentSoul", icon = spells.succulentSoul.icon, description = spells.succulentSoul.name, printInSettings = true },
		{ variable = "#tormentedCrescendo", icon = spells.tormentedCrescendo.icon, description = spells.tormentedCrescendo.name, printInSettings = true },
		{ variable = "#ua", icon = spells.unstableAffliction.icon, description = spells.unstableAffliction.name, printInSettings = true },
		{ variable = "#vileTaint", icon = spells.vileTaint.icon, description = spells.vileTaint.name, printInSettings = true },
		{ variable = "#wither", icon = spells.wither.icon, description = spells.wither.name, printInSettings = true },
	}
	specCache.affliction.barTextVariables.values = {
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

		{ variable = "$mana", description = L["WarlockAfflictionBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["WarlockAfflictionBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["WarlockAfflictionBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["WarlockAfflictionBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["WarlockAfflictionBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["WarlockAfflictionBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["WarlockAfflictionBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["WarlockAfflictionBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
					
		{ variable = "$soulShards", description = L["WarlockAfflictionBarTextVariable_soulShards"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockAfflictionBarTextVariable_soulShardsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$agonyCount", description = L["WarlockAfflictionBarTextVariable_agonyCount"], printInSettings = true, color = false },
		{ variable = "$agonyStacks", description = L["WarlockAfflictionBarTextVariable_agonyStacks"], printInSettings = true, color = false },
		{ variable = "$agonyTime", description = L["WarlockAfflictionBarTextVariable_agonyTime"], printInSettings = true, color = false },
		{ variable = "$corruptionTime", description = L["WarlockAfflictionBarTextVariable_corruptionTime"], printInSettings = true, color = false },
		{ variable = "$corruptionCount", description = L["WarlockAfflictionBarTextVariable_corruptionCount"], printInSettings = true, color = false },
		{ variable = "$hauntCount", description = L["WarlockAfflictionBarTextVariable_hauntCount"], printInSettings = true, color = false },
		{ variable = "$hauntTime", description = L["WarlockAfflictionBarTextVariable_hauntTime"], printInSettings = true, color = false },
		{ variable = "$shadowEmbraceMaxStacks", description = L["WarlockAfflictionBarTextVariable_shadowEmbraceMaxStacks"], printInSettings = true, color = false },
		{ variable = "$shadowEmbraceStacks", description = L["WarlockAfflictionBarTextVariable_shadowEmbraceStacks"], printInSettings = true, color = false },
		{ variable = "$shadowEmbraceTime", description = L["WarlockAfflictionBarTextVariable_shadowEmbraceTime"], printInSettings = true, color = false },
		{ variable = "$soulRotCount", description = L["WarlockAfflictionBarTextVariable_soulRotCount"], printInSettings = true, color = false },
		{ variable = "$soulRotTime", description = L["WarlockAfflictionBarTextVariable_soulRotTime"], printInSettings = true, color = false },
		{ variable = "$unstableAfflictionTime", description = L["WarlockAfflictionBarTextVariable_unstableAfflictionTime"], printInSettings = true, color = false },
		{ variable = "$vileTaintCount", description = L["WarlockAfflictionBarTextVariable_vileTaintCount"], printInSettings = true, color = false },
		{ variable = "$vileTaintTime", description = L["WarlockAfflictionBarTextVariable_vileTaintTime"], printInSettings = true, color = false },

		{ variable = "$phantomSingularityTime", description = L["WarlockAfflictionBarTextVariable_phantomSingularityTime"], printInSettings = true, color = false },

		{ variable = "$nightfallTime", description = L["WarlockAfflictionBarTextVariable_nightfallTime"], printInSettings = true, color = false },
		{ variable = "$nightfallStacks", description = L["WarlockAfflictionBarTextVariable_nightfallStacks"], printInSettings = true, color = false },
		{ variable = "$tormentedCrescendoTime", description = L["WarlockAfflictionBarTextVariable_tormentedCrescendoTime"], printInSettings = true, color = false },
		{ variable = "$tormentedCrescendoStacks", description = L["WarlockAfflictionBarTextVariable_tormentedCrescendoStacks"], printInSettings = true, color = false },
		{ variable = "$succulentSoulTime", description = L["WarlockAfflictionBarTextVariable_succulentSoulTime"], printInSettings = true, color = false },
		{ variable = "$succulentSoulStacks", description = L["WarlockAfflictionBarTextVariable_succulentSoulStacks"], printInSettings = true, color = false },
		{ variable = "$malignOmenTime", description = L["WarlockAfflictionBarTextVariable_malignOmenTime"], printInSettings = true, color = false },
		{ variable = "$malignOmenStacks", description = L["WarlockAfflictionBarTextVariable_malignOmenStacks"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	---@type TRB.Classes.TargetData
	local targetData = snapshotData.targetData

	if TRB.Data.character.specId == 1 then -- Affliction	
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
	if clearAll == true then
		if TRB.Data.character.specId == 1 then
		
		end
	end
end

local function ConstructResourceBar(settings)
	for _, v in pairs(resourceFrame.thresholds) do
		v:Hide();
	end

	for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
		if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
			TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
		end
		TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
	end

	if TRB.Data.character.specId == 1 then
    end
	TRB.Frames.resource2ContainerFrame:Show()
	
	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
end


local function RefreshLookupData_Affliction()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warlock.affliction
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local targetData = snapshotData.targetData
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor
	local normalizedSoulShards = snapshotData.attributes.resource2 / TRB.Data.resource2Factor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = specSettings.colors.text.current
	local castingManaColor = specSettings.colors.text.casting

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$passive
	local _passiveMana = 0
	local passiveMana = string.format("|c%s%s|r", specSettings.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
	--$manaTotal
	local _manaTotal = math.min(_passiveMana + snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
	--$manaPlusCasting
	local _manaPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor", true))
	--$manaPlusPassive
	local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end
	local _manaPercent = (normalizedMana/maxResource)
	local manaPercent = string.format("|c%s%s|r", currentManaColor, TRB.Functions.Number:RoundTo(_manaPercent*100, manaPrecision, "floor"))

	--$unstableAfflictionTime
	local _unstableAfflictionTime = 0
	local unstableAfflictionTime
	if target ~= nil then
		_unstableAfflictionTime = target.spells[spells.unstableAffliction.id].remainingTime or 0
	end

	--$agonyCount and $agonyStacks $agonyTime
	local _agonyCount = snapshotData.targetData.count[spells.agony.id] or 0
	local agonyCount = string.format("%s", _agonyCount)
	local _agonyStacks = snapshotData.targetData.trackedSpells[spells.agony.id].stacks or 0
	local agonyStacks
	local _agonyTime = 0
	local agonyTime
	if target ~= nil then
		_agonyStacks = target.spells[spells.agony.id].stacks or 0
		_agonyTime = target.spells[spells.agony.id].remainingTime or 0
	end

	--$corruptionCount and $corruptionTime
	local _corruptionCount
	if talents:IsTalentActive(spells.wither) then
		_corruptionCount = snapshotData.targetData.count[spells.wither.id] or 0
	else
		_corruptionCount = snapshotData.targetData.count[spells.corruption.id] or 0
	end
	local corruptionCount = string.format("%s", _corruptionCount)
	--[[@type integer|boolean]]
	local _corruptionTime = 0
	local corruptionTime = "0"
	if target ~= nil then
		_corruptionTime = target.spells[spells.corruption.id].remainingTime or 0
		
		if talents:IsTalentActive(spells.wither) then
			if target.spells[spells.wither.id].active then
				if target.spells[spells.wither.id].remainingTime <= 0 and talents:IsTalentActive(spells.absoluteCorruption) then
					_corruptionTime = true
					corruptionTime = "∞"
				else
					corruptionTime = TRB.Functions.BarText:TimerPrecision(_corruptionTime)
				end
			end
		else
			if target.spells[spells.corruption.id].active then
				if target.spells[spells.corruption.id].remainingTime <= 0 and talents:IsTalentActive(spells.absoluteCorruption) then
					_corruptionTime = true
					corruptionTime = "∞"
				else
					corruptionTime = TRB.Functions.BarText:TimerPrecision(_corruptionTime)
				end
			end
		end
	end

	--$hauntCount and $hauntTime
	local _hauntCount = snapshotData.targetData.count[spells.haunt.id] or 0
	local hauntCount = string.format("%s", _hauntCount)
	local _hauntTime = 0
	local hauntTime
	if target ~= nil then
		_hauntTime = target.spells[spells.haunt.id].remainingTime or 0
	end

	--$vileTaintCount and $vileTaintTime
	local _vileTaintCount = snapshotData.targetData.count[spells.vileTaint.id] or 0
	local vileTaintCount = string.format("%s", _vileTaintCount)
	local _vileTaintTime = 0
	if target ~= nil then
		_vileTaintTime = target.spells[spells.vileTaint.id].remainingTime or 0
	end
	local vileTaintTime = TRB.Functions.BarText:TimerPrecision(_vileTaintTime)

	--$soulRotCount and $soulRotTime
	local _soulRotCount = snapshotData.targetData.count[spells.soulRot.id] or 0
	local soulRotCount = string.format("%s", _soulRotCount)
	local _soulRotTime = 0
	if target ~= nil then
		_soulRotTime = target.spells[spells.soulRot.id].remainingTime or 0
	end
	local soulRotTime = TRB.Functions.BarText:TimerPrecision(_soulRotTime)

	--$phantomSingularityTime
	local _phantomSingularityTime = 0
	if target ~= nil then
		_phantomSingularityTime = target.spells[spells.phantomSingularity.id].remainingTime or 0
	end	
	local phantomSingularityTime = TRB.Functions.BarText:TimerPrecision(_phantomSingularityTime)
	
	--$shadowEmbraceStacks $shadowEmbraceTime
	local _shadowEmbraceStacks = snapshotData.targetData.trackedSpells[spells.shadowEmbrace.id].stacks or 0
	local shadowEmbraceStacks
	local _shadowEmbraceMaxStacks = spells.shadowEmbrace.attributes.maxStacks
	local shadowEmbraceMaxStacks = string.format("%s", _shadowEmbraceMaxStacks)
	local _shadowEmbraceTime = 0
	local shadowEmbraceTime
	if target ~= nil then
		_shadowEmbraceStacks = target.spells[spells.shadowEmbrace.id].stacks or 0
		_shadowEmbraceTime = target.spells[spells.shadowEmbrace.id].remainingTime or 0
	end	
	shadowEmbraceStacks = string.format("%s", _shadowEmbraceStacks)

	--$nightfallTime
	local _nightfallTime = snapshotData.snapshots[spells.nightfall.id].buff:GetRemainingTime(currentTime)
	local nightfallTime =  TRB.Functions.BarText:TimerPrecision(_nightfallTime)
	
	--$nightfallStacks
	local _nightfallStacks = snapshotData.snapshots[spells.nightfall.id].buff.applications or 0
	local nightfallStacks = string.format("%s", _nightfallStacks)

	--$tormentedCrescendoTime
	local _tormentedCrescendoTime = snapshotData.snapshots[spells.tormentedCrescendo.id].buff:GetRemainingTime(currentTime)
	local tormentedCrescendoTime =  TRB.Functions.BarText:TimerPrecision(_tormentedCrescendoTime)
	
	--$tormentedCrescendoStacks
	local _tormentedCrescendoStacks = snapshotData.snapshots[spells.tormentedCrescendo.id].buff.applications or 0
	local tormentedCrescendoStacks = string.format("%.0f", _tormentedCrescendoStacks)
	
	--$succulentSoulTime
	local _succulentSoulTime = snapshotData.snapshots[spells.succulentSoul.id].buff:GetRemainingTime()
	local succulentSoulTime =  TRB.Functions.BarText:TimerPrecision(_succulentSoulTime)
	
	--$succulentSoulStacks
	local _succulentSoulStacks = snapshotData.snapshots[spells.succulentSoul.id].buff.applications or 0
	local succulentSoulStacks = string.format("%.0f", _succulentSoulStacks)
	
	--$malignOmenTime
	local _malignOmenTime = snapshotData.snapshots[spells.malignOmen.id].buff:GetRemainingTime()
	local malignOmenTime =  TRB.Functions.BarText:TimerPrecision(_malignOmenTime)
	
	--$malignOmenStacks
	local _malignOmenStacks = snapshotData.snapshots[spells.malignOmen.id].buff.applications or 0
	local malignOmenStacks = string.format("%.0f", _malignOmenStacks)
	
	----------------------------

	if specSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.unstableAffliction.id].active then
			if target.spells[spells.unstableAffliction.id].remainingTime > spells.unstableAffliction.pandemicTime then
				unstableAfflictionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_unstableAfflictionTime))
			else
				unstableAfflictionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_unstableAfflictionTime))
			end
		else
			unstableAfflictionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
		if target ~= nil and target.spells[spells.agony.id].active then
			if target.spells[spells.agony.id].remainingTime > spells.agony.pandemicTime then
				agonyTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_agonyTime))
				agonyCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up.color, _agonyCount)
				agonyStacks = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up.color, _agonyStacks)
			else
				agonyTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_agonyTime))
				agonyCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic.color, _agonyCount)
				agonyStacks = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic.color, _agonyStacks)
			end
		else
			agonyTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
			agonyCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down.color, _agonyCount)
			agonyStacks = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down.color, _agonyStacks)
		end
		if target ~= nil and (target.spells[spells.corruption.id].active or target.spells[spells.wither.id].active) then
			if talents:IsTalentActive(spells.absoluteCorruption) then
				if target.spells[spells.corruption.id].remainingTime > 0 or target.spells[spells.wither.id].remainingTime > 0 then -- PvP
					if target.spells[spells.corruption.id].remainingTime > spells.absoluteCorruption.attributes.pvpPandemicTime or target.spells[spells.wither.id].remainingTime > spells.absoluteCorruption.attributes.pvpPandemicTime then
						corruptionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up.color, corruptionTime)
						corruptionCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up.color, _corruptionCount)
					else
						corruptionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic.color, corruptionTime)
						corruptionCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic.color, _corruptionCount)
					end
				else -- PvE
					corruptionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up.color, corruptionTime)
					corruptionCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up.color, _corruptionCount)
				end
			elseif target.spells[spells.corruption.id].remainingTime > spells.corruption.pandemicTime then
				corruptionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up.color, corruptionTime)
				corruptionCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up.color, _corruptionCount)
			else
				corruptionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic.color, corruptionTime)
				corruptionCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic.color, _corruptionCount)
			end
		else
			corruptionTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down.color, corruptionTime)
			corruptionCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down.color, _corruptionCount)
		end
		if target ~= nil and target.spells[spells.haunt.id].active then
			if target.spells[spells.haunt.id].remainingTime > spells.haunt.pandemicTime then
				hauntTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_hauntTime))
				hauntCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up.color, _hauntCount)
			else
				hauntTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_hauntTime))
				hauntCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic.color, _hauntCount)
			end
		else
			hauntTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
			hauntCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down.color, _hauntCount)
		end
	else
		unstableAfflictionTime = TRB.Functions.BarText:TimerPrecision(_unstableAfflictionTime)
		agonyStacks = string.format("%s", _agonyStacks)
		agonyTime = TRB.Functions.BarText:TimerPrecision(_agonyTime)
		--Handled above because of Absolute Corruption
		--corruptionTime = TRB.Functions.BarText:TimerPrecision(_corruptionTime)
		hauntTime = TRB.Functions.BarText:TimerPrecision(_hauntTime)
	end

	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.agonyCount = _agonyCount or 0
	Global_TwintopResourceBar.dots.corruptionCount = _corruptionCount or 0
	Global_TwintopResourceBar.dots.hauntCount = _hauntCount or 0
	Global_TwintopResourceBar.dots.soulRotCount = _soulRotCount or 0
	Global_TwintopResourceBar.dots.vileTaintCount = _vileTaintCount or 0

	local lookup = TRB.Data.lookup or {}
	
	lookup["#ua"] = spells.unstableAffliction.icon
	lookup["#agony"] = spells.agony.icon
	lookup["#corruption"] = spells.corruption.icon
	lookup["#haunt"] = spells.haunt.icon
	lookup["#vileTaint"] = spells.vileTaint.icon
	lookup["#soulRot"] = spells.soulRot.icon
	lookup["#phantomSingularity"] = spells.phantomSingularity.icon
	lookup["#nightfall"] = spells.nightfall.icon
	lookup["#tormentedCrescendo"] = spells.tormentedCrescendo.icon
	lookup["#succulentSoul"] = spells.succulentSoul.icon
	lookup["#malignOmen"] = spells.malignOmen.icon
	lookup["#shadowEmbrace"] = spells.shadowEmbrace.icon
	lookup["$resourceTotal"] = manaTotal
	lookup["$manaTotal"] = manaTotal
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$resourcePlusCasting"] = manaPlusCasting
	lookup["$manaPlusCasting"] = manaPlusCasting
	lookup["$resourcePlusPassive"] = manaPlusPassive
	lookup["$manaPlusPassive"] = manaPlusPassive
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$passive"] = passiveMana
	lookup["$soulShards"] = normalizedSoulShards
	lookup["$comboPoints"] = normalizedSoulShards
	lookup["$soulShardsMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$unstableAfflictionTime"] = unstableAfflictionTime
	lookup["$agonyCount"] = agonyCount
	lookup["$agonyStacks"] = agonyStacks
	lookup["$agonyTime"] = agonyTime
	lookup["$corruptionCount"] = corruptionCount
	lookup["$corruptionTime"] = corruptionTime
	lookup["$hauntCount"] = hauntCount
	lookup["$hauntTime"] = hauntTime
	lookup["$vileTaintCount"] = vileTaintCount
	lookup["$vileTaintTime"] = vileTaintTime
	lookup["$soulRotCount"] = soulRotCount
	lookup["$soulRotTime"] = soulRotTime
	lookup["$phantomSingularityTime"] = phantomSingularityTime
	lookup["$tormentedCrescendoTime"] = tormentedCrescendoTime
	lookup["$tormentedCrescendoStacks"] = tormentedCrescendoStacks
	lookup["$nightfallTime"] = nightfallTime
	lookup["$nightfallStacks"] = nightfallStacks
	lookup["$succulentSoulTime"] = succulentSoulTime
	lookup["$succulentSoulStacks"] = succulentSoulStacks
	lookup["$malignOmenTime"] = malignOmenTime
	lookup["$malignOmenStacks"] = malignOmenStacks
	lookup["$shadowEmbraceStacks"] = shadowEmbraceStacks
	lookup["$shadowEmbraceMaxStacks"] = shadowEmbraceMaxStacks
	lookup["$shadowEmbraceTime"] = shadowEmbraceTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	
	lookupLogic["$resourceTotal"] = _manaTotal
	lookupLogic["$manaTotal"] = _manaTotal
	lookupLogic["$resourceMax"] = manaMax
	lookupLogic["$manaMax"] = manaMax
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
	lookupLogic["$manaPlusCasting"] = _manaPlusCasting
	lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
	lookupLogic["$manaPlusPassive"] = _manaPlusPassive
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$passive"] = _passiveMana
	lookupLogic["$soulShards"] = normalizedSoulShards
	lookupLogic["$comboPoints"] = normalizedSoulShards
	lookupLogic["$soulShardsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$unstableAfflictionTime"] = _unstableAfflictionTime
	lookupLogic["$agonyCount"] = _agonyCount
	lookupLogic["$agonyStacks"] = _agonyStacks
	lookupLogic["$agonyTime"] = _agonyTime
	lookupLogic["$corruptionCount"] = _corruptionCount
	lookupLogic["$corruptionTime"] = _corruptionTime
	lookupLogic["$hauntCount"] = _hauntCount
	lookupLogic["$hauntTime"] = _hauntTime
	lookupLogic["$vileTaintCount"] = _vileTaintCount
	lookupLogic["$vileTaintTime"] = _vileTaintTime
	lookupLogic["$soulRotCount"] = _soulRotCount
	lookupLogic["$soulRotTime"] = _soulRotTime
	lookupLogic["$nightfallTime"] = _nightfallTime
	lookupLogic["$nightfallStacks"] = _nightfallStacks
	lookupLogic["$phantomSingularityTime"] = _phantomSingularityTime
	lookupLogic["$tormentedCrescendoTime"] = _tormentedCrescendoTime
	lookupLogic["$tormentedCrescendoStacks"] = _tormentedCrescendoStacks
	lookupLogic["$succulentSoulTime"] = _succulentSoulTime
	lookupLogic["$succulentSoulStacks"] = _succulentSoulStacks
	lookupLogic["$malignOmenTime"] = _malignOmenTime
	lookupLogic["$malignOmenStacks"] = _malignOmenStacks
	lookupLogic["$shadowEmbraceStacks"] = _shadowEmbraceStacks
	lookupLogic["$shadowEmbraceMaxStacks"] = _shadowEmbraceMaxStacks
	lookupLogic["$shadowEmbraceTime"] = _shadowEmbraceTime
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
end

local function UpdateSnapshot_Affliction()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.warlock
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.affliction
		local specCacheSettings = TRB.Data.specCache.affliction.settings
		UpdateSnapshot_Affliction()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
				local targetData = snapshotData.targetData
				local target = targetData.targets[targetData.currentTargetGuid]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border
				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				TRB.Functions.Bar:SetPrimaryValue(specSettings, "resource", resourceFrame, currentResource)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, "passive", passiveFrame, passiveBarValue)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, "casting", castingFrame, castingBarValue)

				barContainerFrame:SetAlpha(1.0)

				if snapshots[spells.nightfall.id].buff.isActive then
					if specSettings.colors.bar.nightfall.enabled then
						barBorderColor = specSettings.colors.bar.nightfall.color
					end

					if specSettings.audio.nightfall.enabled and snapshotData.audio.nightfallCue == false then
						snapshotData.audio.nightfallCue = true
						PlaySoundFile(specSettings.audio.nightfall.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.nightfallCue = false
				end

				if snapshots[spells.tormentedCrescendo.id].buff.isActive then
					if specSettings.colors.bar.tormentedCrescendo.enabled then
						barBorderColor = specSettings.colors.bar.tormentedCrescendo.color
					end

					if snapshots[spells.tormentedCrescendo.id].buff.applications == 1 and specSettings.audio.tormentedCrescendo.enabled and not snapshotData.audio.tormentedCrescendoCue then
						snapshotData.audio.tormentedCrescendoCue = true
						PlaySoundFile(specSettings.audio.tormentedCrescendo.sound, coreSettings.audio.channel.channel)
					elseif	snapshots[spells.tormentedCrescendo.id].buff.applications == 2 and specSettings.audio.tormentedCrescendo2.enabled and not snapshotData.audio.tormentedCrescendo2Cue then
						snapshotData.audio.tormentedCrescendo2Cue = true
						PlaySoundFile(specSettings.audio.tormentedCrescendo2.sound, coreSettings.audio.channel.channel)
					end
				end

				if specSettings.colors.bar.shadowEmbraceNotMax.enabled and talents:IsTalentActive(spells.shadowEmbrace) and target ~= nil and
					not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") and
					target.spells[spells.shadowEmbrace.id].stacks < spells.shadowEmbrace.attributes.maxStacks then
					barColor = specSettings.colors.bar.shadowEmbraceNotMax.color
				end

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				local normalizedResource2 = snapshotData.attributes.resource2 / TRB.Data.resource2Factor
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if normalizedResource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and normalizedResource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					if specSettings.colors.comboPoints.malignOmen.enabled and snapshotData.snapshots[spells.malignOmen.id].buff.isActive then
						if x <= normalizedResource2 and snapshotData.snapshots[spells.malignOmen.id].buff.applications > (normalizedResource2 - x) then
							cpColor = specSettings.colors.comboPoints.malignOmen.color
						elseif not specSettings.comboPoints.consistentUnfilledColor and x > normalizedResource2 and x <= snapshotData.snapshots[spells.malignOmen.id].buff.applications then
							cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.malignOmen.color, true)
						end
					end

					if specSettings.colors.comboPoints.succulentSoul.enabled and snapshotData.snapshots[spells.succulentSoul.id].buff.isActive then
						if x <= normalizedResource2 and snapshotData.snapshots[spells.succulentSoul.id].buff.applications > (normalizedResource2 - x) then
							cpBorderColor = specSettings.colors.comboPoints.succulentSoul.color
						elseif x > normalizedResource2 and x <= snapshotData.snapshots[spells.succulentSoul.id].buff.applications then
							cpBorderColor = specSettings.colors.comboPoints.succulentSoul.color
						end
					end

					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[x].borderFrame, "comboPoint" .. x, cpBorderColor)
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[x].resourceFrame, "comboPoint" .. x, cpColor)
					TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[x].containerFrame, "comboPoint" .. x, cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, specCacheSettings, refreshText)
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local spells
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()
		
		local settings
		if TRB.Data.character.specId == 1 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
			settings = TRB.Data.settings.warlock.affliction
        end

		if entry.sourceGuid == TRB.Data.character.guid then
			if TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "affliction" then --Affliction					
				if entry.spellId == spells.unstableAffliction.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.agony.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.corruption.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.wither.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.haunt.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.vileTaint.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.soulRot.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.phantomSingularity.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.shadowEmbrace.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
					end
				elseif entry.spellId == spells.tormentedCrescendo.id then
					if entry.type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
						snapshotData.audio.tormentedCrescendo2Cue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.tormentedCrescendoCue = false
						snapshotData.audio.tormentedCrescendo2Cue = false
					end
				end
			end
		end

		if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
			targetData:Remove(entry.destinationGuid)
			RefreshTargetTracking()
		end
	end
end)

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		self.sinceLastUpdate = 0
	end
end

local function SwitchSpec()
	barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	TRB.Data.character.specId = GetSpecialization()
	if TRB.Data.character.specId == 1 then
		specCache.affliction.talents:GetTalents()
		FillSpellData_Affliction()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.affliction)
		
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local targetData = TRB.Data.snapshotData.targetData
		local spells = spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

		TRB.Functions.RefreshLookupData = RefreshLookupData_Affliction
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.warlock.affliction)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warlock.affliction)
		targetData:AddSpellTracking(spells.unstableAffliction)
		targetData:AddSpellTracking(spells.agony)
		targetData:AddSpellTracking(spells.corruption)
		targetData:AddSpellTracking(spells.wither)
		targetData:AddSpellTracking(spells.haunt)
		targetData:AddSpellTracking(spells.vileTaint)
		targetData:AddSpellTracking(spells.soulRot)
		targetData:AddSpellTracking(spells.phantomSingularity)
		targetData:AddSpellTracking(spells.shadowEmbrace)

		if TRB.Data.barConstructedForSpec ~= "affliction" then
			talents = specCache.affliction.talents
			TRB.Data.barConstructedForSpec = "affliction"
			ConstructResourceBar(specCache.affliction.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

	TRB.Functions.Class:EventRegistration()
end


resourceFrame:RegisterEvent("ADDON_LOADED")
resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
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
						settings.warlock.affliction.displayText.barText = TRB.Options.Warlock.AfflictionLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
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
			if not TRB.Details.addonData.optionsPanel then
				TRB.Details.addonData.optionsPanel = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.barConstructedForSpec = nil
						TRB.Data.settings.warlock.affliction = TRB.Functions.LibSharedMedia:ValidateLsmValues("Affliction Warlock", TRB.Data.settings.warlock.affliction)

						FillSpellData_Affliction()

						SwitchSpec()

						TRB.Options.Warlock.ConstructOptionsPanel(specCache)
						
						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end
						TRB.Functions.Class:EventRegistration()
					end)
				end)
			end

			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
				SwitchSpec()
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	TRB.Data.character.specId = GetSpecialization()
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "warlock"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	TRB.Data.character.maxResource2 = 1
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local settings = nil
	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.warlock.affliction
		TRB.Data.character.specName = "affliction"

    end
	if settings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
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
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if TRB.Data.character.specId == 1 then
		local settings
		local notZeroShowValue = TRB.Data.character.maxResource
		local notZeroShowValueComboPoints = 3
		if TRB.Data.character.specId == 1 then
			settings = TRB.Data.settings.warlock.affliction
		end

		TRB.Functions.Bar:HideResourceBarGeneric(settings, force, notZeroShowValue, true, notZeroShowValueComboPoints)
	else
		TRB.Frames.barContainerFrame:Hide()
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed)
	if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
		return false
	end
	
	if guid ~= nil and guid ~= "" then
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		local targets = targetData.targets

		if not targetData:CheckTargetExists(guid) then
			targetData:InitializeTarget(guid)
		end
		targets[guid].lastUpdate = GetTime()
		return true
	end
	return false
end


function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end

	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
		settings = TRB.Data.settings.warlock.affliction
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Affliction
		if var == "$nightfallTime" then
			if snapshots[spells.nightfall.id].buff.isActive then
				valid = true
			end
		elseif var == "$nightfallStacks" then
			if snapshots[spells.nightfall.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$tormentedCrescendoTime" then
			if snapshots[spells.tormentedCrescendo.id].buff.isActive then
				valid = true
			end
		elseif var == "$tormentedCrescendoStacks" then
			if snapshots[spells.tormentedCrescendo.id].buff.isActive then
				valid = true
			end
		elseif var == "$malignOmenTime" then
			if snapshots[spells.malignOmen.id].buff.isActive then
				valid = true
			end
		elseif var == "$malignOmenStacks" then
			if snapshots[spells.malignOmen.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$succulentSoulTime" then
			if snapshots[spells.succulentSoul.id].buff.isActive then
				valid = true
			end
		elseif var == "$succulentSoulStacks" then
			if snapshots[spells.succulentSoul.id].buff.applications > 0 then
				valid = true
			end
		elseif var == "$unstableAfflictionTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.unstableAffliction.id] ~= nil and
			target.spells[spells.unstableAffliction.id].remainingTime > 0 then
			valid = true
			end
		elseif var == "$agonyCount" then
			if snapshotData.targetData.count[spells.agony.id] > 0 then
				valid = true
			end
		elseif var == "$agonyStacks" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.agony.id] ~= nil and
			target.spells[spells.agony.id].stacks > 0 then
				valid = true
			end
		elseif var == "$agonyTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.agony.id] ~= nil and
			target.spells[spells.agony.id].remainingTime > 0 then
			valid = true
			end
		elseif var == "$corruptionCount" then
			if snapshotData.targetData.count[spells.corruption.id] > 0 or snapshotData.targetData.count[spells.wither.id] > 0 then
				valid = true
			end
		elseif var == "$corruptionTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			((target.spells[spells.corruption.id] ~= nil and
			target.spells[spells.corruption.id].remainingTime > 0) or
			(target.spells[spells.wither.id] ~= nil and
			target.spells[spells.wither.id].remainingTime > 0)) then
			valid = true
			end
		elseif var == "$hauntCount" then
			if snapshotData.targetData.count[spells.haunt.id] > 0 then
				valid = true
			end
		elseif var == "$hauntTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.haunt.id] ~= nil and
			target.spells[spells.haunt.id].remainingTime > 0 then
			valid = true
			end
		elseif var == "$vileTaintCount" then
			if snapshotData.targetData.count[spells.vileTaint.id] > 0 then
				valid = true
			end
		elseif var == "$vileTaintTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.vileTaint.id] ~= nil and
			target.spells[spells.vileTaint.id].remainingTime > 0 then
			valid = true
			end
		elseif var == "$soulRotCount" then
			if snapshotData.targetData.count[spells.soulRot.id] > 0 then
				valid = true
			end
		elseif var == "$soulRotTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.soulRot.id] ~= nil and
			target.spells[spells.soulRot.id].remainingTime > 0 then
			valid = true
			end
		elseif var == "$phantomSingularityTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.phantomSingularity.id] ~= nil and
			target.spells[spells.phantomSingularity.id].remainingTime > 0 then
			valid = true
			end
		elseif var == "$shadowEmbraceStacks" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.shadowEmbrace.id] ~= nil and
			target.spells[spells.shadowEmbrace.id].stacks > 0 then
				valid = true
			end
		elseif var == "$shadowEmbraceMaxStacks" then
			valid = true
		elseif var == "$shadowEmbraceTime" then
			if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.shadowEmbrace.id] ~= nil and
			target.spells[spells.shadowEmbrace.id].remainingTime > 0 then
			valid = true
			end
		end
	end

	--Spec agnostic
	if var == "$passive" then
		-- we'll set this to valid once there's something passive being tracked
	elseif var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$resource" or var == "$mana" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$manaMax" then
		valid = true
	elseif var == "$resourceTotal" or var == "$manaTotal" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
			then
			valid = true
		end
	elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
			valid = true
		end
	elseif var == "$regen" then
		if snapshotData.attributes.resource < TRB.Data.character.maxResource and
			((settings.generation.mode == "time" and settings.generation.time > 0) or
			(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
			valid = true
		end
	elseif var == "$comboPoints" or var == "$soulShards" then
		valid = true
	elseif var == "$comboPointsMax"or var == "$soulShardsMax" then
		valid = true
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end