local _, TRB = ...
if TRB.Data.character.classId ~= 2 then --Only do this if we're on an Paladin!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local barContainerFrame = TRB.Frames.barContainerFrame
local resourceFrame = TRB.Frames.resourceFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame
local barBorderFrame = TRB.Frames.barBorderFrame

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	holy = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function CalculateManaGain(mana, isPotion)
	if isPotion == nil then
		isPotion = false
	end

	local modifier = 1.0

	if isPotion then
		if TRB.Data.character.items.alchemyStone then
			local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
			local spells = spellsData.spells --[[@as TRB.Classes.Healer.HealerSpells]]
			modifier = modifier * spells.alchemistStone.attributes.resourcePercent
		end
	end

	return mana * modifier
end

local function FillSpecializationCache()
	-- Holy
	specCache.holy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			symbolOfHope = 0,
		},
		dots = {
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
			potions = {
				algariManaPotionRank3 = {
					id = 212241,
					mana = 270000
				},
				algariManaPotionRank2 = {
					id = 212240,
					mana = 234783
				},
				algariManaPotionRank1 = {
					id = 212239,
					mana = 204159
				},
				cavedwellersDelightRank3 = {
					id = 212244,
					mana = 202500
				},
				cavedwellersDelightRank2 = {
					id = 212243,
					mana = 176087
				},
				cavedwellersDelightRank1 = {
					id = 212243,
					mana = 153119
				},
				slumberingSoulSerumRank3 = {
					id = 212247,
					mana = 375000
				},
				slumberingSoulSerumRank2 = {
					id = 212246,
					mana = 326090
				},
				slumberingSoulSerumRank1 = {
					id = 212245,
					mana = 283550
				},
			},
			alchemyStone = false
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

	---@type TRB.Classes.Healer.Innervate
	specCache.holy.snapshotData.snapshots[spells.innervate.id] = TRB.Classes.Healer.Innervate:New(spells.innervate)
	---@type TRB.Classes.Healer.PotionOfChilledClarity
	specCache.holy.snapshotData.snapshots[spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(spells.potionOfChilledClarity)
	---@type TRB.Classes.Healer.ManaTideTotem
	specCache.holy.snapshotData.snapshots[spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(spells.manaTideTotem)
	---@type TRB.Classes.Healer.SymbolOfHope
	specCache.holy.snapshotData.snapshots[spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(spells.symbolOfHope, CalculateManaGain)
	---@type TRB.Classes.Healer.ChanneledManaPotion
	specCache.holy.snapshotData.snapshots[spells.slumberingSoulSerumRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.slumberingSoulSerumRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.algariManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.algariManaPotionRank1)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.holy.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.holy.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)

	---@type TRB.Classes.Snapshot
	specCache.holy.snapshotData.snapshots[spells.infusionOfLight.id] = TRB.Classes.Snapshot:New(spells.infusionOfLight)

	specCache.holy.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Holy()
	TRB.Functions.Character:FillSpecializationCacheSettings("paladin", "holy", true)
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
		
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },
		{ variable = "#iol", icon = spells.infusionOfLight.icon, description = spells.infusionOfLight.name, printInSettings = true },
		{ variable = "#infusionOfLight", icon = spells.infusionOfLight.icon, description = spells.infusionOfLight.name, printInSettings = false },

		{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
		{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

		{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
		{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },

		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

		{ variable = "#amp", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = true },
		{ variable = "#algariManaPotion", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = true },
		{ variable = "#slumberingSoulSerum", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = true },
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
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["PaladinHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PaladinHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PaladinHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PaladinHolyBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["PaladinHolyBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["PaladinHolyBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["PaladinHolyBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["PaladinHolyBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
					
		{ variable = "$holyPower", description = L["PaladinHolyBarTextVariable_holyPower"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$holyPowerMax", description = L["PaladinHolyBarTextVariable_holyPowerMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$iolTime", description =   L["PaladinHolyBarTextVariable_iolTime"], printInSettings = true, color = false },
		{ variable = "$iolStacks", description = L["PaladinHolyBarTextVariable_iolStacks"], printInSettings = true, color = false },

		{ variable = "$bowMana", description = L["PaladinHolyBarTextVariable_bowMana"], printInSettings = true, color = false },
		{ variable = "$bowTime", description = L["PaladinHolyBarTextVariable_bowTime"], printInSettings = true, color = false },
		{ variable = "$bowTicks", description = L["PaladinHolyBarTextVariable_bowTicks"], printInSettings = true, color = false },

		{ variable = "$sohMana", description = L["PaladinHolyBarTextVariable_sohMana"], printInSettings = true, color = false },
		{ variable = "$sohTime", description = L["PaladinHolyBarTextVariable_sohTime"], printInSettings = true, color = false },
		{ variable = "$sohTicks", description = L["PaladinHolyBarTextVariable_sohTicks"], printInSettings = true, color = false },

		{ variable = "$innervateMana", description = L["PaladinHolyBarTextVariable_innervateMana"], printInSettings = true, color = false },
		{ variable = "$innervateTime", description = L["PaladinHolyBarTextVariable_innervateTime"], printInSettings = true, color = false },
		
		{ variable = "$mttMana", description = L["PaladinHolyBarTextVariable_mttMana"], printInSettings = true, color = false },
		{ variable = "$mttTime", description = L["PaladinHolyBarTextVariable_mttTime"], printInSettings = true, color = false },
					
		{ variable = "$mrMana", description = L["PaladinHolyBarTextVariable_mrMana"], printInSettings = true, color = false },
		{ variable = "$mrTime", description = L["PaladinHolyBarTextVariable_mrTime"], printInSettings = true, color = false },

		{ variable = "$channeledMana", description = L["PaladinHolyBarTextVariable_channeledMana"], printInSettings = true, color = false },
		{ variable = "$slumberingSoulSerumTicks", description = L["PaladinHolyBarTextVariable_slumberingSoulSerumTicks"], printInSettings = true, color = false },
		{ variable = "$slumberingSoulSerumTime", description = L["PaladinHolyBarTextVariable_slumberingSoulSerumTime"], printInSettings = true, color = false },
		
		{ variable = "$potionOfChilledClarityMana", description = L["PaladinHolyBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
		{ variable = "$potionOfChilledClarityTime", description = L["PaladinHolyBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

		{ variable = "$potionCooldown", description = L["PaladinHolyBarTextVariable_potionCooldown"], printInSettings = true, color = false },
		{ variable = "$potionCooldownSeconds", description = L["PaladinHolyBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
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
		for x = 1, 7 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end
			TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.passiveFrame.thresholds[x], settings, true)
		end
	end
	TRB.Frames.resource2ContainerFrame:Show()

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
end

local function RefreshLookupData_Holy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.paladin.holy
	local sharedSettings = TRB.Data.specCache["holy"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$iolTime
	local _iolTime = snapshots[spells.infusionOfLight.id].buff:GetRemainingTime(currentTime)
	local iolTime = TRB.Functions.BarText:TimerPrecision(_iolTime)
	--$iolTicks
	local _iolStacks = snapshots[spells.infusionOfLight.id].buff.applications
	local iolStacks = string.format("%.0f", _iolStacks)

	local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
	--$sohMana
	local _sohMana = symbolOfHope.buff.mana
	local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
	--$sohTicks
	local _sohTicks = symbolOfHope.buff.ticks or 0
	local sohTicks = string.format("%.0f", _sohTicks)
	--$sohTime
	local _sohTime = symbolOfHope.buff:GetRemainingTime(currentTime)
	local sohTime = TRB.Functions.BarText:TimerPrecision(_sohTime)

	local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	--$innervateMana
	local _innervateMana = innervate.mana
	local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
	--$innervateTime
	local _innervateTime = innervate.buff:GetRemainingTime(currentTime)
	local innervateTime = TRB.Functions.BarText:TimerPrecision(_innervateTime)

	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	--$potionOfChilledClarityMana
	local _potionOfChilledClarityMana = potionOfChilledClarity.mana
	local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
	--$potionOfChilledClarityTime
	local _potionOfChilledClarityTime = potionOfChilledClarity.buff:GetRemainingTime(currentTime)
	local potionOfChilledClarityTime = TRB.Functions.BarText:TimerPrecision(_potionOfChilledClarityTime)
	
	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
	--$mttMana
	local _mttMana = manaTideTotem.mana
	local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
	--$mttTime
	local _mttTime = manaTideTotem.buff:GetRemainingTime(currentTime)
	local mttTime = TRB.Functions.BarText:TimerPrecision(_mttTime)
	
	local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
	--$mrMana
	local _mrMana = moltenRadiance.mana
	local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
	--$mrTime
	local _mrTime = moltenRadiance.buff.remaining
	local mrTime = TRB.Functions.BarText:TimerPrecision(_mrTime)
	
	local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
	--$bowMana
	local _bowMana = blessingOfWinter.mana
	local bowMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_bowMana, manaPrecision, "floor", true))
	--$bowTime
	local _bowTime = blessingOfWinter.buff.remaining
	local bowTime = TRB.Functions.BarText:TimerPrecision(_bowTime)
	--$bowTicks
	local _bowTicks = blessingOfWinter.buff.ticks or 0
	local bowTicks = string.format("%.0f", _bowTicks)

	--$potionCooldownSeconds
	local _potionCooldown = snapshots[spells.algariManaPotionRank1.id].cooldown.remaining
	local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
	local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
	local _potionCooldownSeconds = _potionCooldown % 60
	--$potionCooldown
	local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
	
	local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	--$channeledMana
	local _channeledMana = channeledManaPotion.mana
	local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
	--$slumberingSoulSerumTicks
	local _slumberingSoulSerumTicks = channeledManaPotion.ticks or 0
	local slumberingSoulSerumTicks = string.format("%.0f", _slumberingSoulSerumTicks)
	--$slumberingSoulSerumTime
	local _slumberingSoulSerumTime = channeledManaPotion.buff:GetRemainingTime(currentTime)
	local slumberingSoulSerumTime = TRB.Functions.BarText:TimerPrecision(_slumberingSoulSerumTime)

	--$passive
	local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana + _bowMana
	local passiveMana = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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

	----------

	Global_TwintopResourceBar.resource.passive = _passiveMana
	Global_TwintopResourceBar.resource.channeledPotion = _channeledMana or 0
	Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
	Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
	Global_TwintopResourceBar.resource.potionOfChilledClarity = _potionOfChilledClarityMana or 0
	Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
	Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
	
	Global_TwintopResourceBar.potionOfSpiritualClarity = Global_TwintopResourceBar.potionOfSpiritualClarity or {}
	Global_TwintopResourceBar.potionOfSpiritualClarity.mana = _channeledMana
	Global_TwintopResourceBar.potionOfSpiritualClarity.ticks = _slumberingSoulSerumTicks or 0
	
	Global_TwintopResourceBar.symbolOfHope = Global_TwintopResourceBar.symbolOfHope or {}
	Global_TwintopResourceBar.symbolOfHope.mana = _sohMana
	Global_TwintopResourceBar.symbolOfHope.ticks = _sohTicks or 0

	local lookup = TRB.Data.lookup or {}
	lookup["$manaTotal"] = manaTotal
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourcePlusCasting"] = manaPlusCasting
	lookup["$manaPlusCasting"] = manaPlusCasting
	lookup["$resourcePlusPassive"] = manaPlusPassive
	lookup["$manaPlusPassive"] = manaPlusPassive
	lookup["$resourceTotal"] = manaTotal
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$resource"] = currentMana
	lookup["$casting"] = castingMana
	lookup["$passive"] = passiveMana
	lookup["$sohMana"] = sohMana
	lookup["$sohTime"] = sohTime
	lookup["$sohTicks"] = sohTicks
	lookup["$innervateMana"] = innervateMana
	lookup["$innervateTime"] = innervateTime
	lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
	lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
	lookup["$mttMana"] = mttMana
	lookup["$mttTime"] = mttTime
	lookup["$mrMana"] = mrMana
	lookup["$mrTime"] = mrTime
	lookup["$bowMana"] = bowMana
	lookup["$bowTime"] = bowTime
	lookup["$bowTicks"] = bowTicks
	lookup["$channeledMana"] = channeledMana
	lookup["$slumberingSoulSerumTicks"] = slumberingSoulSerumTicks
	lookup["$slumberingSoulSerumTime"] = slumberingSoulSerumTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
	lookup["$holyPower"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$holyPowerMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$iolTime"] = iolTime
	lookup["$iolStacks"] = iolStacks
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaTotal"] = _manaTotal
	lookupLogic["$manaMax"] = maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
	lookupLogic["$manaPlusCasting"] = _manaPlusCasting
	lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
	lookupLogic["$manaPlusPassive"] = _manaPlusPassive
	lookupLogic["$resourceTotal"] = _manaTotal
	lookupLogic["$resourceMax"] = maxResource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$passive"] = _passiveMana
	lookupLogic["$sohMana"] = _sohMana
	lookupLogic["$sohTime"] = _sohTime
	lookupLogic["$sohTicks"] = _sohTicks
	lookupLogic["$innervateMana"] = _innervateMana
	lookupLogic["$innervateTime"] = _innervateTime
	lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
	lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
	lookupLogic["$mttMana"] = _mttMana
	lookupLogic["$mttTime"] = _mttTime
	lookupLogic["$mrMana"] = _mrMana
	lookupLogic["$mrTime"] = _mrTime
	lookupLogic["$bowMana"] = _bowMana
	lookupLogic["$bowTime"] = _bowTime
	lookupLogic["$bowTicks"] = _bowTicks
	lookupLogic["$channeledMana"] = _channeledMana
	lookupLogic["$slumberingSoulSerumTicks"] = _slumberingSoulSerumTicks
	lookupLogic["$slumberingSoulSerumTime"] = _slumberingSoulSerumTime
	lookupLogic["$potionCooldown"] = potionCooldown
	lookupLogic["$potionCooldownSeconds"] = potionCooldown
	lookupLogic["$holyPower"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$holyPowerMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$iolTime"] = _iolTime
	lookupLogic["$iolStacks"] = _iolStacks
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
	local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
end

local function CastingSpell()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
	local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")

	if currentSpellName == nil and currentChannelName == nil then
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	else
		if TRB.Data.character.specId == 1 then
			if currentSpellName == nil then
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			else
				local spellInfo = C_Spell.GetSpellInfo(currentSpellName) --[[@as SpellInfo]]

				if spellInfo ~= nil and spellInfo.spellID then
					local manaCost = -TRB.Classes.SpellBase.GetPrimaryResourceCost({ id = spellInfo.spellID, primaryResourceType = Enum.PowerType.Mana, primaryResourceTypeProperty = "cost", primaryResourceTypeMod = 1.0 }, true, true)

					snapshotData.casting.startTime = currentSpellStartTime / 1000
					snapshotData.casting.endTime = currentSpellEndTime / 1000
					snapshotData.casting.resourceRaw = manaCost
					snapshotData.casting.spellId = spellInfo.spellID
					snapshotData.casting.icon = string.format("|T%s:0|t", spellInfo.iconID)

					UpdateCastingResourceFinal_Holy()
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			return true
		end
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local currentTime = GetTime()
end

local function UpdateSnapshot_Holy()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local _
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	innervate:Update()

	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
	manaTideTotem:Update()

	local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
	symbolOfHope:Update()

	local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
	moltenRadiance:Update()

	local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
	blessingOfWinter:Update()
	
	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	potionOfChilledClarity:Update()

	local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	channeledManaPotion:Update()

	-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
	snapshots[spells.algariManaPotionRank1.id].cooldown.startTime, snapshots[spells.algariManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.algariManaPotionRank1.id)
	snapshots[spells.algariManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.paladin
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.holy
		local specCacheSettings = TRB.Data.specCache.holy.settings
		UpdateSnapshot_Holy()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

				if snapshots[spells.infusionOfLight.id].buff.isActive then
					if snapshots[spells.infusionOfLight.id].buff.applications == 1 then
						if specSettings.colors.bar.infusionOfLight.enabled then
							barBorderColor = specSettings.colors.bar.infusionOfLight.color
						end

						if specSettings.audio.infusionOfLight.enabled and not snapshotData.audio.infusionOfLightCue then
							snapshotData.audio.infusionOfLightCue = true
							PlaySoundFile(specSettings.audio.infusionOfLight.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshots[spells.infusionOfLight.id].buff.applications == 2 then
						if specSettings.colors.bar.infusionOfLight2.enabled then
							barBorderColor = specSettings.colors.bar.infusionOfLight2.color
						end

						if specSettings.audio.infusionOfLight2.enabled and not snapshotData.audio.infusionOfLight2Cue then
							snapshotData.audio.infusionOfLightCue = true
							snapshotData.audio.infusionOfLight2Cue = true
							PlaySoundFile(specSettings.audio.infusionOfLight2.sound, coreSettings.audio.channel.channel)
						end
					end
				end

				if potionOfChilledClarity.buff.isActive then
					if specSettings.colors.bar.potionOfChilledClarityBorderChange then
						barBorderColor = specSettings.colors.bar.potionOfChilledClarity
					end
				elseif innervate.buff.isActive then
					if specSettings.colors.bar.innervateBorderChange then
						barBorderColor = specSettings.colors.bar.innervate
					end

					if specSettings.audio.innervate.enabled and snapshotData.audio.innervateCue == false then
						snapshotData.audio.innervateCue = true
						PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
					end
				end

				if CastingSpell() and specSettings.colors.bar.showCasting  then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				local passiveValue, _ = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specCacheSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				passiveBarValue = castingBarValue + passiveValue

				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", passiveFrame, currentResource)
						castingBarColor = specSettings.colors.bar.passive
						passiveBarColor = specSettings.colors.bar.spending
					else
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, currentResource)
						castingBarColor = specSettings.colors.bar.spending
						passiveBarColor = specSettings.colors.bar.passive
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				end


				local potion = snapshots[spells.algariManaPotionRank1.id].cooldown
				local potionCooldownThreshold = 0
				local potionThresholdColor = specCacheSettings.colors.threshold.over.color
				local potionFrameLevel = TRB.Data.constants.frameLevels.thresholdOver

				if potion.onCooldown then
					potionThresholdColor = specCacheSettings.colors.threshold.unusable.color
					potionFrameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					if specCacheSettings.thresholds.potionCooldown.enabled then
						if specCacheSettings.thresholds.potionCooldown.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							potionCooldownThreshold = gcd * specCacheSettings.thresholds.potionCooldown.gcdsMax
						elseif specCacheSettings.thresholds.potionCooldown.mode == "time" then
							potionCooldownThreshold = specCacheSettings.thresholds.potionCooldown.timeMax
						end
					end
				end

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					pairOffset = (thresholdId - 1) * 3
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					local resourceAmount = 0

					if spell.attributes.isPotion then
						snapshot = snapshots[spells.algariManaPotionRank1.id]
						thresholdColor = potionThresholdColor
						frameLevel = potionFrameLevel
						if not potion.onCooldown or (potionCooldownThreshold > math.abs(potion.startTime + potion.duration - currentTime)) then
							local potionMana = CalculateManaGain(TRB.Data.character.items.potions[spell.settingKey].mana, true)
							resourceAmount = castingBarValue + potionMana
							if specCacheSettings.thresholds.thresholdDictionary[spell.settingKey].enabled and resourceAmount < TRB.Data.character.maxResource then
							else
								showThreshold = false
							end
						else
							showThreshold = false
						end
					else
						resourceAmount = spell:GetPrimaryResourceCost()
					end

					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, resourceFrame, resourceAmount, TRB.Data.character.maxResource)
					TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
				end

				local barColor = specSettings.colors.bar.base

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)				
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					else
						TRB.Functions.Bar:SetValue(specCacheSettings, "comboPoint" .. x, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end
					
					TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(TRB.Frames.resource2Frames[x].borderFrame, "comboPoint" .. x, cpBorderColor)
					TRB.Functions.Color:SetStatusBarColorFromRGBAString(TRB.Frames.resource2Frames[x].resourceFrame, "comboPoint" .. x, cpColor)
					TRB.Functions.Color:SetBackdropColor(TRB.Frames.resource2Frames[x].containerFrame, "comboPoint" .. x, cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()
		
		local settings
		if TRB.Data.character.specId == 1 then
			settings = TRB.Data.settings.paladin.holy
		end

		if entry.destinationGuid == TRB.Data.character.guid then
			if TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "holy" then -- Let's check raid effect mana stuff
				if settings.passiveGeneration.symbolOfHope and (entry.spellId == spells.symbolOfHope.tickId or entry.spellId == spells.symbolOfHope.id) then
					local symbolOfHope = snapshotData.snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
					local castByToken = UnitTokenFromGUID(entry.sourceGuid)
					symbolOfHope.buff:Initialize(entry.type, nil, castByToken)
				elseif settings.passiveGeneration.innervate and entry.spellId == spells.innervate.id then
					local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					innervate.buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						snapshotData.audio.innervateCue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.innervateCue = false
					end
				elseif settings.passiveGeneration.manaTideTotem and entry.spellId == spells.manaTideTotem.id then
					local manaTideTotem = snapshotData.snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
					manaTideTotem:Initialize(entry.type)
				elseif entry.spellId == spells.moltenRadiance.id then
					local moltenRadiance = snapshotData.snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
					moltenRadiance.buff:Initialize(entry.type)
				elseif settings.passiveGeneration.blessingOfWinter and entry.spellId == spells.blessingOfWinter.id then
					local blessingOfWinter = snapshotData.snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
					blessingOfWinter.buff:Initialize(entry.type)
				end
			end
		end

		if entry.sourceGuid == TRB.Data.character.guid then
			if TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "holy" then
				if entry.spellId == spells.slumberingSoulSerumRank1.spellId or entry.spellId == spells.slumberingSoulSerumRank2.spellId or entry.spellId == spells.slumberingSoulSerumRank3.spellId then
					local channeledManaPotion = snapshotData.snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
					channeledManaPotion.buff:Initialize(entry.type)
				elseif entry.spellId == spells.potionOfChilledClarity.id then
					local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					potionOfChilledClarity.buff:Initialize(entry.type)
				elseif entry.spellId == spells.infusionOfLight.id then
					if entry.type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
						snapshotData.audio.infusionOfLight2Cue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.infusionOfLightCue = false
						snapshotData.audio.infusionOfLight2Cue = false
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
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.paladin.holy)

		local lookup = TRB.Data.lookup or {}
		lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
		lookup["#bow"] = spells.blessingOfWinter.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#mr"] = spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = spells.moltenRadiance.icon
		lookup["#soh"] = spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = spells.symbolOfHope.icon
		lookup["#amp"] = spells.algariManaPotionRank1.icon
		lookup["#algariManaPotion"] = spells.algariManaPotionRank1.icon
		lookup["#poff"] = spells.slumberingSoulSerumRank1.icon
		lookup["#slumberingSoulSerum"] = spells.slumberingSoulSerumRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "holy" then
			talents = specCache.holy.talents
			TRB.Data.barConstructedForSpec = "holy"
			ConstructResourceBar(specCache.holy.settings)
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
						settings.paladin.holy.displayText.barText = TRB.Options.Paladin.HolyLoadDefaultBarTextSimpleSettings()
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
						
						FillSpellData_Holy()
						
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
				SwitchSpec()
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	TRB.Data.character.specId = GetSpecialization()
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "paladin"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	TRB.Data.character.maxResource2 = 1
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local sharedSettings = nil
	if TRB.Data.character.specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
		TRB.Data.character.specName = "holy"
		TRB.Data.character.items.alchemyStone = spells.alchemistStone.attributes.isAlchemistStoneEquipped()
		sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	end

	if sharedSettings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(sharedSettings, TRB.Frames.barContainerFrame)
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.paladin.holy then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.paladin.holy)
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

	if TRB.Data.character.specId == 1 then
		local notZeroShowValue = TRB.Data.character.maxResource
		local notZeroShowValueComboPoints = 0
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		TRB.Functions.Bar:HideResourceBarGeneric(sharedSettings, force, notZeroShowValue, true, notZeroShowValueComboPoints)
	else
		TRB.Frames.barContainerFrame:Hide()
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed, isFriend)
	if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
		return false
	end
	
	if guid ~= nil and guid ~= "" then
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		local targets = targetData.targets

		if not targetData:CheckTargetExists(guid) then
			targetData:InitializeTarget(guid)
		end
		if isFriend then
			targets[guid].isFriend = true
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Paladin.HolySpells]]
	local settings = nil

	if TRB.Data.character.specId == 1 then
		settings = TRB.Data.settings.paladin.holy
	else
		return false
	end

	if TRB.Data.character.specId == 1 then --Holy
		if var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
				valid = true
			end
		elseif var == "$sohMana" then
			local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
			if symbolOfHope.buff.isActive then
				valid = true
			end
		elseif var == "$sohTime" then
			local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
			if symbolOfHope.buff.isActive then
				valid = true
			end
		elseif var == "$sohTicks" then
			local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
			if symbolOfHope.buff.isActive then
				valid = true
			end
		elseif var == "$innervateMana" then
			local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
			if innervate.buff.isActive then
				valid = true
			end
		elseif var == "$innervateTime" then
			local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
			if innervate.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfChilledClarityMana" then
			local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
			if potionOfChilledClarity.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfChilledClarityTime" then
			local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
			if potionOfChilledClarity.buff.isActive then
				valid = true
			end
		elseif var == "$mttMana" then
			local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
			if manaTideTotem.buff.isActive then
				valid = true
			end
		elseif var == "$mttTime" then
			local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
			if manaTideTotem.buff.isActive then
				valid = true
			end
		elseif var == "$mrMana" then
			local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$mrTime" then
			local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$bowMana" then
			local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$bowTime" then
			local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$bowTicks" then
			local moltenRadiance = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
			if moltenRadiance.buff.isActive then
				valid = true
			end
		elseif var == "$channeledMana" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$slumberingSoulSerumTicks" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$slumberingSoulSerumTime" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionCooldown" then
			if snapshots[spells.algariManaPotionRank1.id].cooldown:IsUnusable() then
				valid = true
			end
		elseif var == "$potionCooldownSeconds" then
			if snapshots[spells.algariManaPotionRank1.id].cooldown:IsUnusable() then
				valid = true
			end
		elseif var == "$iolTime" then
			if snapshots[spells.infusionOfLight.id].buff.isActive then
				valid = true
			end
		elseif var == "$iolStacks" then
			if snapshots[spells.infusionOfLight.id].buff.isActive then
				valid = true
			end
		end
	end

	--Spec agnostic
	if var == "$casting" then
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
	elseif var == "$comboPoints" or var == "$holyPower" then
		valid = true
	elseif var == "$comboPointsMax"or var == "$holyPowerMax" then
		valid = true
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end