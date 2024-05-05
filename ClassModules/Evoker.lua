local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 13 then --Only do this if we're on an Evoker!
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
TRB.Data.character = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	devastation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
	preservation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]],
	augmentation = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
}

local function CalculateManaGain(mana, isPotion)
	if isPotion == nil then
		isPotion = false
	end

	local modifier = 1.0

	if isPotion then
		if TRB.Data.character.items.alchemyStone then
			modifier = modifier * TRB.Data.spells.alchemistStone.resourcePercent
		end
	end

	return mana * modifier
end

local function FillSpecializationCache()
	-- Devastation
	specCache.devastation.Global_TwintopResourceBar = {
		ttd = 0,
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

	specCache.devastation.character = {
		guid = UnitGUID("player"),
		specId = 1,
		maxResource = 10000,
		maxResource2 = 5,
		maxResource2Resource = 0,
		maxResource2ResourceMax = 1000,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Evoker.DevastationSpells
	specCache.devastation.spellsData.spells = TRB.Classes.Evoker.DevastationSpells:New()
	---@type TRB.Classes.Evoker.DevastationSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.devastation.spellsData.spells

	specCache.devastation.snapshotData.attributes.manaRegen = 0
	specCache.devastation.snapshotData.audio = {
		essenceBurstCue = false,
		essenceBurst2Cue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.devastation.snapshotData.snapshots[spells.essenceBurst.id] = TRB.Classes.Snapshot:New(spells.essenceBurst)

	specCache.devastation.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Preservation
	specCache.preservation.Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			symbolOfHope = 0,
		},
		dots = {
		},
	}

	specCache.preservation.character = {
		guid = UnitGUID("player"),
		maxResource = 100,
		effects = {
		},
		items = {
			potions = {
				aeratedManaPotionRank3 = {
					id = 191386,
					mana = 27600
				},
				aeratedManaPotionRank2 = {
					id = 191385,
					mana = 24000
				},
				aeratedManaPotionRank1 = {
					id = 191384,
					mana = 20869
				},
				potionOfFrozenFocusRank3 = {
					id = 191365,
					mana = 48300
				},
				potionOfFrozenFocusRank2 = {
					id = 191364,
					mana = 42000
				},
				potionOfFrozenFocusRank1 = {
					id = 191363,
					mana = 36521
				},
			},
			conjuredChillglobe = {
				id = 194300,
				isEquipped = false,
				manaThresholdPercent = 0.65,
				mana = 0
			},
			alchemyStone = false
		}
	}
	
	---@type TRB.Classes.Evoker.PreservationSpells
	specCache.preservation.spellsData.spells = TRB.Classes.Evoker.PreservationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.preservation.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

	specCache.preservation.snapshotData.attributes.manaRegen = 0
	specCache.preservation.snapshotData.audio = {
		innervateCue = false,
		essenceBurstCue = false,
		essenceBurst2Cue = false
	}
	
	---@type TRB.Classes.Healer.Innervate
	specCache.preservation.snapshotData.snapshots[spells.innervate.id] = TRB.Classes.Healer.Innervate:New(spells.innervate)
	---@type TRB.Classes.Healer.PotionOfChilledClarity
	specCache.preservation.snapshotData.snapshots[spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(spells.potionOfChilledClarity)
	---@type TRB.Classes.Healer.ManaTideTotem
	specCache.preservation.snapshotData.snapshots[spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(spells.manaTideTotem)
	---@type TRB.Classes.Healer.SymbolOfHope
	specCache.preservation.snapshotData.snapshots[spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(spells.symbolOfHope, CalculateManaGain)
	---@type TRB.Classes.Healer.ChanneledManaPotion
	specCache.preservation.snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.potionOfFrozenFocusRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.preservation.snapshotData.snapshots[spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.aeratedManaPotionRank1)
	---@type TRB.Classes.Snapshot
	specCache.preservation.snapshotData.snapshots[spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(spells.conjuredChillglobe)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.preservation.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.preservation.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)
	---@type TRB.Classes.Snapshot
	specCache.preservation.snapshotData.snapshots[spells.emeraldCommunion.id] = TRB.Classes.Healer.HealerRegenBase:New(spells.emeraldCommunion)
	---@type TRB.Classes.Snapshot
	specCache.preservation.snapshotData.snapshots[spells.essenceBurst.id] = TRB.Classes.Snapshot:New(spells.essenceBurst)

	specCache.preservation.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Augmentation
	specCache.augmentation.Global_TwintopResourceBar = {
		ttd = 0,
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

	specCache.augmentation.character = {
		guid = UnitGUID("player"),
		specId = 1,
		maxResource = 10000,
		maxResource2 = 5,
		maxResource2Resource = 0,
		maxResource2ResourceMax = 1000,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Evoker.AugmentationSpells
	specCache.augmentation.spellsData.spells = TRB.Classes.Evoker.AugmentationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.augmentation.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]

	specCache.augmentation.snapshotData.attributes.manaRegen = 0
	specCache.augmentation.snapshotData.audio = {
		essenceBurstCue = false,
		essenceBurst2Cue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.augmentation.snapshotData.snapshots[spells.essenceBurst.id] = TRB.Classes.Snapshot:New(spells.essenceBurst)

	specCache.augmentation.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Devastation()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "evoker", "devastation")
end

local function Setup_Preservation()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "evoker", "preservation")
end

local function Setup_Augmentation()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "evoker", "augmentation")
end

local function FillSpellData_Devastation()
	Setup_Devastation()
	specCache.devastation.spellsData:FillSpellData()
	local spells = specCache.devastation.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.devastation.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		{ variable = "#eb", icon = spells.essenceBurst.icon, description = spells.essenceBurst.name, printInSettings = true },
		{ variable = "#essenceBurst", icon = spells.essenceBurst.icon, description = spells.essenceBurst.name, printInSettings = false },
	}
	specCache.devastation.barTextVariables.values = {
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

		{ variable = "$mana", description = L["EvokerDevastationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerDevastationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$essence", description = L["EvokerDevastationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerDevastationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerDevastationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },

		{ variable = "$ebTime", description = L["EvokerDevastationBarTextVariable_ebTime"], printInSettings = true, color = false },
		{ variable = "$ebStacks", description = L["EvokerDevastationBarTextVariable_ebStacks"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function FillSpellData_Preservation()
	Setup_Preservation()
	specCache.preservation.spellsData:FillSpellData()
	local spells = specCache.preservation.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.preservation.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#eb", icon = spells.essenceBurst.icon, description = spells.essenceBurst.name, printInSettings = true },
		{ variable = "#essenceBurst", icon = spells.essenceBurst.icon, description = spells.essenceBurst.name, printInSettings = false },

		{ variable = "#ec", icon = spells.emeraldCommunion.icon, description = spells.emeraldCommunion.name, printInSettings = true },
		{ variable = "#emeraldCommunion", icon = spells.emeraldCommunion.icon, description = spells.emeraldCommunion.name, printInSettings = false },

		{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
		{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },
		
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

		{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
		{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },

		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

		{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
		{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
		{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
	}
	specCache.preservation.barTextVariables.values = {
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

		{ variable = "$mana", description = L["EvokerPreservationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["EvokerPreservationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerPreservationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["EvokerPreservationBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["EvokerPreservationBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["EvokerPreservationBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["EvokerPreservationBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["EvokerPreservationBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
					
		{ variable = "$essence", description = L["EvokerPreservationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerPreservationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerPreservationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$ebTime", description = L["EvokerPreservationBarTextVariable_ebTime"], printInSettings = true, color = false },
		{ variable = "$ebStacks", description = L["EvokerPreservationBarTextVariable_ebStacks"], printInSettings = true, color = false },

		{ variable = "$ecMana", description = L["EvokerPreservationBarTextVariable_ecMana"], printInSettings = true, color = false },
		{ variable = "$ecTime", description = L["EvokerPreservationBarTextVariable_ecTime"], printInSettings = true, color = false },
		{ variable = "$ecTicks", description = L["EvokerPreservationBarTextVariable_ecTicks"], printInSettings = true, color = false },
		
		{ variable = "$bowMana", description = L["EvokerPreservationBarTextVariable_bowMana"], printInSettings = true, color = false },
		{ variable = "$bowTime", description = L["EvokerPreservationBarTextVariable_bowTime"], printInSettings = true, color = false },
		{ variable = "$bowTicks", description = L["EvokerPreservationBarTextVariable_bowTicks"], printInSettings = true, color = false },

		{ variable = "$sohMana", description = L["EvokerPreservationBarTextVariable_sohMana"], printInSettings = true, color = false },
		{ variable = "$sohTime", description = L["EvokerPreservationBarTextVariable_sohTime"], printInSettings = true, color = false },
		{ variable = "$sohTicks", description = L["EvokerPreservationBarTextVariable_sohTicks"], printInSettings = true, color = false },

		{ variable = "$innervateMana", description = L["EvokerPreservationBarTextVariable_innervateMana"], printInSettings = true, color = false },
		{ variable = "$innervateTime", description = L["EvokerPreservationBarTextVariable_innervateTime"], printInSettings = true, color = false },
		
		{ variable = "$mttMana", description = L["EvokerPreservationBarTextVariable_mttMana"], printInSettings = true, color = false },
		{ variable = "$mttTime", description = L["EvokerPreservationBarTextVariable_mttTime"], printInSettings = true, color = false },
					
		{ variable = "$mrMana", description = L["EvokerPreservationBarTextVariable_mrMana"], printInSettings = true, color = false },
		{ variable = "$mrTime", description = L["EvokerPreservationBarTextVariable_mrTime"], printInSettings = true, color = false },

		{ variable = "$channeledMana", description = L["EvokerPreservationBarTextVariable_channeledMana"], printInSettings = true, color = false },
		{ variable = "$potionOfFrozenFocusTicks", description = L["EvokerPreservationBarTextVariable_potionOfFrozenFocusTicks"], printInSettings = true, color = false },
		{ variable = "$potionOfFrozenFocusTime", description = L["EvokerPreservationBarTextVariable_potionOfFrozenFocusTime"], printInSettings = true, color = false },
		
		{ variable = "$potionOfChilledClarityMana", description = L["EvokerPreservationBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
		{ variable = "$potionOfChilledClarityTime", description = L["EvokerPreservationBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

		{ variable = "$potionCooldown", description = L["EvokerPreservationBarTextVariable_potionCooldown"], printInSettings = true, color = false },
		{ variable = "$potionCooldownSeconds", description = L["EvokerPreservationBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function FillSpellData_Augmentation()
	Setup_Augmentation()
	specCache.augmentation.spellsData:FillSpellData()
	local spells = specCache.augmentation.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.augmentation.barTextVariables.icons = {
		{ variable = "#eb", icon = spells.essenceBurst.icon, description = spells.essenceBurst.name, printInSettings = true },
		{ variable = "#essenceBurst", icon = spells.essenceBurst.icon, description = spells.essenceBurst.name, printInSettings = false },
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.augmentation.barTextVariables.values = {
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

		{ variable = "$mana", description = L["EvokerAugmentationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["EvokerAugmentationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$essence", description = L["EvokerAugmentationBarTextVariable_essence"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$essenceRegenTime", description = L["EvokerAugmentationBarTextVariable_essenceRegenTime"], printInSettings = true, color = false },
		{ variable = "$essenceMax", description = L["EvokerAugmentationBarTextVariable_essenceMax"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },

		{ variable = "$ebTime", description = L["EvokerAugmentationBarTextVariable_ebTime"], printInSettings = true, color = false },
		{ variable = "$ebStacks", description = L["EvokerAugmentationBarTextVariable_ebStacks"], printInSettings = true, color = false },

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
	local specId = GetSpecialization()
	
	if specId == 1 then -- Devastation
	elseif specId == 2 then -- Preservation
	elseif specId == 3 then -- Augmentation
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
	if clearAll == true then
		local specId = GetSpecialization()
		if specId == 1 then
		elseif specId == 2 then
		elseif specId == 3 then
		end
	end
end

local function ConstructResourceBar(settings)
	local specId = GetSpecialization()
	local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			resourceFrame.thresholds[x]:Hide()
		end
	end

	if specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		for _, v in pairs(spells) do
			local spell = v --[[@as TRB.Classes.SpellBase]]
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
				spell = spell --[[@as TRB.Classes.SpellThreshold]]
				if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
				TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell, settings)

				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
			end
		end
	elseif specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		for x = 1, 7 do
			if TRB.Frames.resourceFrame.thresholds[x] == nil then
				TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
			end

			TRB.Frames.resourceFrame.thresholds[x]:Show()
			TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.resourceFrame.thresholds[x]:Hide()
		end

		for x = 1, 8 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end

			TRB.Frames.passiveFrame.thresholds[x]:Show()
			TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.passiveFrame.thresholds[x]:Hide()
		end
		
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1, TRB.Data.settings.evoker.preservation)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2, TRB.Data.settings.evoker.preservation)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3, TRB.Data.settings.evoker.preservation)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1, TRB.Data.settings.evoker.preservation)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2, TRB.Data.settings.evoker.preservation)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3, TRB.Data.settings.evoker.preservation)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe, TRB.Data.settings.evoker.preservation)
	elseif specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		for _, v in pairs(spells) do
			local spell = v --[[@as TRB.Classes.SpellBase]]
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
				spell = spell --[[@as TRB.Classes.SpellThreshold]]
				if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
				TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell, settings)

				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Frames.resource2ContainerFrame:Show()
	TRB.Functions.Bar:Construct(settings)
	TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
end

local function RefreshLookupData_Devastation()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.evoker.devastation
	--Spec specific implementation
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / GetPowerRegenForPowerType(Enum.PowerType.Essence)
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = specSettings.colors.text.current
	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	
	--$ebTime
	local _ebTime = snapshots[spells.essenceBurst.id].buff:GetRemainingTime(currentTime)
	local ebTime = TRB.Functions.BarText:TimerPrecision(_ebTime)
	--$ebTicks
	local _ebStacks = snapshots[spells.essenceBurst.id].buff.applications
	local ebStacks = string.format("%.0f", _ebStacks)

	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["#eb"] = spells.essenceBurst.icon
	lookup["#essenceBurst"] = spells.essenceBurst.icon
	lookup["$manaMax"] = TRB.Data.character.maxResource
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentMana
	lookup["$ebTime"] = ebTime
	lookup["$ebStacks"] = ebStacks
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$ebTime"] = _ebTime
	lookupLogic["$ebStacks"] = _ebStacks
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Preservation()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.evoker.preservation
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / GetPowerRegenForPowerType(Enum.PowerType.Essence)
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = specSettings.colors.text.current
	local castingManaColor = specSettings.colors.text.casting

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$ecMana
	local _ecMana = snapshots[spells.emeraldCommunion.id].buff.resource
	local ecMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_ecMana, manaPrecision, "floor", true))
	--$ecTicks
	local _ecTicks = snapshots[spells.emeraldCommunion.id].buff.ticks
	local ecTicks = string.format("%.0f", _ecTicks)
	--$ecTime
	local _ecTime = snapshots[spells.emeraldCommunion.id].buff:GetRemainingTime(currentTime)
	local ecTime = TRB.Functions.BarText:TimerPrecision(_ecTime)
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
	local _potionCooldown = snapshots[spells.aeratedManaPotionRank1.id].cooldown.remaining
	local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
	local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
	local _potionCooldownSeconds = _potionCooldown % 60
	--$potionCooldown
	local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
	
	local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	--$channeledMana
	local _channeledMana = channeledManaPotion.mana
	local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
	--$potionOfFrozenFocusTicks
	local _potionOfFrozenFocusTicks = channeledManaPotion.ticks or 0
	local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
	--$potionOfFrozenFocusTime
	local _potionOfFrozenFocusTime = channeledManaPotion.buff:GetRemainingTime(currentTime)
	local potionOfFrozenFocusTime = TRB.Functions.BarText:TimerPrecision(_potionOfFrozenFocusTime)

	--$passive
	local _passiveMana = _ecMana + _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana + _bowMana
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


	--$ebTime
	local _ebTime = snapshots[spells.essenceBurst.id].buff:GetRemainingTime(currentTime)
	local ebTime = TRB.Functions.BarText:TimerPrecision(_ebTime)
	--$ecTicks
	local _ebStacks = snapshots[spells.essenceBurst.id].buff.applications
	local ebStacks = string.format("%.0f", _ebStacks)

	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	----------

	Global_TwintopResourceBar.resource.passive = _passiveMana
	Global_TwintopResourceBar.resource.channeledPotion = _channeledMana or 0
	Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
	Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
	Global_TwintopResourceBar.resource.potionOfChilledClarity = _potionOfChilledClarityMana or 0
	Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
	Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
	Global_TwintopResourceBar.channeledPotion = {
		mana = _channeledMana,
		ticks = _potionOfFrozenFocusTicks
	}
	Global_TwintopResourceBar.symbolOfHope = {
		mana = _sohMana,
		ticks = _sohTicks
	}
	Global_TwintopResourceBar.emeraldCommunion = {
		mana = _ecMana,
		ticks = _ecTicks
	}


	local lookup = TRB.Data.lookup or {}
	lookup["#eb"] = spells.essenceBurst.icon
	lookup["#essenceBurst"] = spells.essenceBurst.icon
	lookup["#ec"] = spells.emeraldCommunion.icon
	lookup["#emeraldCommunion"] = spells.emeraldCommunion.icon
	lookup["#innervate"] = spells.innervate.icon
	lookup["#mtt"] = spells.manaTideTotem.icon
	lookup["#manaTideTotem"] = spells.manaTideTotem.icon
	lookup["#mr"] = spells.moltenRadiance.icon
	lookup["#moltenRadiance"] = spells.moltenRadiance.icon
	lookup["#soh"] = spells.symbolOfHope.icon
	lookup["#symbolOfHope"] = spells.symbolOfHope.icon
	lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
	lookup["#bow"] = spells.blessingOfWinter.icon
	lookup["#amp"] = spells.aeratedManaPotionRank1.icon
	lookup["#aeratedManaPotion"] = spells.aeratedManaPotionRank1.icon
	lookup["#poff"] = spells.potionOfFrozenFocusRank1.icon
	lookup["#potionOfFrozenFocus"] = spells.potionOfFrozenFocusRank1.icon
	lookup["#pocc"] = spells.potionOfChilledClarity.icon
	lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
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
	lookup["$ecMana"] = ecMana
	lookup["$ecTime"] = ecTime
	lookup["$ecTicks"] = ecTicks
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
	lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
	lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
	lookup["$ebTime"] = ebTime
	lookup["$ebStacks"] = ebStacks
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
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
	lookupLogic["$ecMana"] = _ecMana
	lookupLogic["$ecTime"] = _ecTime
	lookupLogic["$ecTicks"] = _ecTicks
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
	lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
	lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
	lookupLogic["$potionCooldown"] = potionCooldown
	lookupLogic["$potionCooldownSeconds"] = potionCooldown
	lookupLogic["$ebTime"] = _ebTime
	lookupLogic["$ebStacks"] = _ebStacks
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Augmentation()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.evoker.augmentation
	--Spec specific implementation
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	snapshotData.attributes.essenceRegen, _ = 1 / GetPowerRegenForPowerType(Enum.PowerType.Essence)
	snapshotData.attributes.essencePartial = UnitPartialPower("player", Enum.PowerType.Essence)

	local currentManaColor = specSettings.colors.text.current
	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))

	--$ebTime
	local _ebTime = snapshots[spells.essenceBurst.id].buff:GetRemainingTime(currentTime)
	local ebTime = TRB.Functions.BarText:TimerPrecision(_ebTime)
	--$ecTicks
	local _ebStacks = snapshots[spells.essenceBurst.id].buff.applications
	local ebStacks = string.format("%.0f", _ebStacks)

	--$essenceRegenTime
	local _essenceRegenTime = (1 - (snapshotData.attributes.essencePartial / 1000)) * snapshotData.attributes.essenceRegen
	if snapshotData.attributes.resource2 == TRB.Data.character.maxResource2 then
		_essenceRegenTime = 0
	end
	local essenceRegenTime = TRB.Functions.BarText:TimerPrecision(_essenceRegenTime)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["#eb"] = spells.essenceBurst.icon
	lookup["#essenceBurst"] = spells.essenceBurst.icon
	lookup["$manaMax"] = TRB.Data.character.maxResource
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentMana
	lookup["$ebTime"] = ebTime
	lookup["$ebStacks"] = ebStacks
	lookup["$essence"] = snapshotData.attributes.resource
	lookup["$essenceRegenTime"] = essenceRegenTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$ebTime"] = _ebTime
	lookupLogic["$ebStacks"] = _ebStacks
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$essenceRegenTime"] = _essenceRegenTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2
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
local function UpdateCastingResourceFinal_Preservation()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
end

local function CastingSpell()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()
	local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
	local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
	local specId = GetSpecialization()

	if currentSpellName == nil and currentChannelName == nil then
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	else
		if specId == 1 then
			--[[if currentSpellName == nil then
				return true
			else]]
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			--end
		elseif specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
			if currentSpellName == nil then
				if currentChannelId == spells.emeraldCommunion.id then
					casting.spellId = spells.emeraldCommunion.id
					casting.startTime = currentChannelStartTime / 1000
					casting.endTime = currentChannelEndTime / 1000
					casting.resourceRaw = 0
					casting.icon = spells.emeraldCommunion.icon
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			else
				local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

				if spellId then
					local manaCost = -TRB.Classes.SpellBase.GetPrimaryResourceCost({ id = spellId, primaryResourceType = Enum.PowerType.Mana, primaryResourceTypeProperty = "cost", primaryResourceTypeMod = 1.0 }, true)

					casting.startTime = currentSpellStartTime / 1000
					casting.endTime = currentSpellEndTime / 1000
					casting.resourceRaw = manaCost
					casting.spellId = spellId
					casting.icon = string.format("|T%s:0|t", spellIcon)

					UpdateCastingResourceFinal_Preservation()
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			return true
		elseif specId == 3 then
			--[[if currentSpellName == nil then
				return true
			else]]
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			--end
		end
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local currentTime = GetTime()
end

local function UpdateSnapshot_Devastation()
	UpdateSnapshot()
	
	local currentTime = GetTime()
	local _
end

local function UpdateSnapshot_Preservation()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	
	local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	innervate:Update()

	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
	manaTideTotem:Update()

	local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
	symbolOfHope:Update()

	local blessingOfWinter = snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
	blessingOfWinter:Update()

	local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
	moltenRadiance:Update()
	
	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	potionOfChilledClarity:Update()

	local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	channeledManaPotion:Update()

	-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
	snapshots[spells.aeratedManaPotionRank1.id].cooldown.startTime, snapshots[spells.aeratedManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
	snapshots[spells.aeratedManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)

	snapshots[spells.conjuredChillglobe.id].cooldown.startTime, snapshots[spells.conjuredChillglobe.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
	snapshots[spells.conjuredChillglobe.id].cooldown:GetRemainingTime(currentTime)

	local emeraldCommunion = snapshots[spells.emeraldCommunion.id] --[[@as TRB.Classes.Healer.HealerRegenBase]]
	emeraldCommunion.buff:UpdateTicks(currentTime)
	emeraldCommunion.mana = emeraldCommunion.buff.resource
end

local function UpdateSnapshot_Augmentation()
	UpdateSnapshot()
	
	local currentTime = GetTime()
	local _
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local specId = GetSpecialization()
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.evoker
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if specId == 1 then
		local specSettings = classSettings.devastation
		UpdateSnapshot_Devastation()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)

				barContainerFrame:SetAlpha(1.0)

				if snapshots[spells.essenceBurst.id].buff.isActive then
					if snapshots[spells.essenceBurst.id].buff.applications == 1 then
						if specSettings.colors.bar.essenceBurst.enabled then
							barBorderColor = specSettings.colors.bar.essenceBurst.color
						end

						if specSettings.audio.essenceBurst.enabled and not snapshotData.audio.essenceBurstCue then
							snapshotData.audio.essenceBurstCue = true
							PlaySoundFile(specSettings.audio.essenceBurst.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshots[spells.essenceBurst.id].buff.applications == 2 then
						if specSettings.colors.bar.essenceBurst2.enabled then
							barBorderColor = specSettings.colors.bar.essenceBurst2.color
						end

						if specSettings.audio.essenceBurst2.enabled and not snapshotData.audio.essenceBurst2Cue then
							snapshotData.audio.essenceBurst2Cue = true
							PlaySoundFile(specSettings.audio.essenceBurst2.sound, coreSettings.audio.channel.channel)
						end
					end
				end

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					elseif snapshotData.attributes.resource2+1 == x then
						local partial = UnitPartialPower("player", Enum.PowerType.Essence)
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, partial, 1000)
					else
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	elseif specId == 2 then
		local specSettings = classSettings.preservation
		UpdateSnapshot_Preservation()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

				if snapshots[spells.essenceBurst.id].buff.isActive then
					if snapshots[spells.essenceBurst.id].buff.applications == 1 then
						if specSettings.colors.bar.essenceBurst.enabled then
							barBorderColor = specSettings.colors.bar.essenceBurst.color
						end

						if specSettings.audio.essenceBurst.enabled and not snapshotData.audio.essenceBurstCue then
							snapshotData.audio.essenceBurstCue = true
							PlaySoundFile(specSettings.audio.essenceBurst.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshots[spells.essenceBurst.id].buff.applications == 2 then
						if specSettings.colors.bar.essenceBurst2.enabled then
							barBorderColor = specSettings.colors.bar.essenceBurst2.color
						end

						if specSettings.audio.essenceBurst2.enabled and not snapshotData.audio.essenceBurst2Cue then
							snapshotData.audio.essenceBurst2Cue = true
							PlaySoundFile(specSettings.audio.essenceBurst2.sound, coreSettings.audio.channel.channel)
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

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				if CastingSpell() and specSettings.bar.showCasting  then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				TRB.Functions.Threshold:ManageCommonHealerThresholds(currentResource, castingBarValue, specSettings, snapshotData.snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshotData.snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

				local passiveValue, thresholdCount = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				thresholdCount = thresholdCount + 1
				if specSettings.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specSettings, snapshots[spells.emeraldCommunion.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], passiveFrame, thresholdCount, castingBarValue, passiveValue)
				else
					TRB.Frames.passiveFrame.thresholds[thresholdCount]:Hide()
				end
	
				passiveBarValue = castingBarValue + passiveValue
				if castingBarValue < snapshotData.attributes.resource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end

				local resourceBarColor = nil

				resourceBarColor = specSettings.colors.bar.base

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
--[[
				for x = 2, TRB.Data.character.maxResource2 do
					TRB.Frames.resource2Frames[x]:Hide()
				end]]

				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					elseif snapshotData.attributes.resource2+1 == x then
						local partial = UnitPartialPower("player", Enum.PowerType.Essence)
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, partial, 1000)
					else
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end

			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		end
	elseif specId == 3 then
		local specSettings = classSettings.augmentation
		UpdateSnapshot_Devastation()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)

				barContainerFrame:SetAlpha(1.0)

				if snapshots[spells.essenceBurst.id].buff.isActive then
					if snapshots[spells.essenceBurst.id].buff.applications == 1 then
						if specSettings.colors.bar.essenceBurst.enabled then
							barBorderColor = specSettings.colors.bar.essenceBurst.color
						end

						if specSettings.audio.essenceBurst.enabled and not snapshotData.audio.essenceBurstCue then
							snapshotData.audio.essenceBurstCue = true
							PlaySoundFile(specSettings.audio.essenceBurst.sound, coreSettings.audio.channel.channel)
						end
					end

					if snapshots[spells.essenceBurst.id].buff.applications == 2 then
						if specSettings.colors.bar.essenceBurst2.enabled then
							barBorderColor = specSettings.colors.bar.essenceBurst2.color
						end

						if specSettings.audio.essenceBurst2.enabled and not snapshotData.audio.essenceBurst2Cue then
							snapshotData.audio.essenceBurst2Cue = true
							PlaySoundFile(specSettings.audio.essenceBurst2.sound, coreSettings.audio.channel.channel)
						end
					end
				end

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					elseif snapshotData.attributes.resource2+1 == x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, snapshotData.attributes.essencePartial, 1000)
					else
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local currentTime = GetTime()
	local triggerUpdate = false
	local _
	local specId = GetSpecialization()
	local spells
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	local snapshots = snapshotData.snapshots

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()
		
		local settings
		if specId == 1 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
			settings = TRB.Data.settings.evoker.devastation
		elseif specId == 2 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
			settings = TRB.Data.settings.evoker.preservation
		elseif specId == 3 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
			settings = TRB.Data.settings.evoker.augmentation
		end

		if entry.destinationGuid == TRB.Data.character.guid then
			if specId == 2 and TRB.Data.barConstructedForSpec == "preservation" then -- Let's check raid effect mana stuff
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
			if specId == 1 and TRB.Data.barConstructedForSpec == "devastation" then --Devastation					
			elseif specId == 2 and TRB.Data.barConstructedForSpec == "preservation" then
				if entry.spellId == spells.potionOfFrozenFocusRank1.spellId or entry.spellId == spells.potionOfFrozenFocusRank2.spellId or entry.spellId == spells.potionOfFrozenFocusRank3.spellId then
					local channeledManaPotion = snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
					channeledManaPotion.buff:Initialize(entry.type)
				elseif entry.spellId == spells.potionOfChilledClarity.id then
					local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					potionOfChilledClarity.buff:Initialize(entry.type)
				elseif entry.spellId == spells.emeraldCommunion.id then
					if entry.type == "SPELL_PERIODIC_ENERGIZE" then
						if not snapshots[entry.spellId].buff.isActive then
							local duration = spells.emeraldCommunion.duration * (TRB.Functions.Character:GetCurrentGCDTime(true) / 1.5)								
							snapshots[entry.spellId].buff:InitializeCustom(duration)
							snapshots[entry.spellId].buff:SetTickData(true, CalculateManaGain(spells.emeraldCommunion.resourcePerTick * TRB.Data.character.maxResource, false), spells.emeraldCommunion.tickRate * (TRB.Functions.Character:GetCurrentGCDTime(true) / 1.5))
						end
						snapshots[entry.spellId].buff:UpdateTicks(currentTime)
					end
				end
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "augmentation" then --Augmentation
			end

			-- Spec Agnostic
			if entry.spellId == spells.essenceBurst.id then
				snapshots[entry.spellId].buff:Initialize(entry.type)
				if entry.type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
					snapshotData.audio.essenceBurst2Cue = false
				elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
					snapshotData.audio.essenceBurstCue = false
					snapshotData.audio.essenceBurst2Cue = false
				end
			end
		end

		if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
			targetData:Remove(entry.destinationGuid)
			RefreshTargetTracking()
			triggerUpdate = true
		end
	end

	if triggerUpdate then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end)

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		TRB.Functions.Class:TriggerResourceBarUpdates()
		self.sinceLastUpdate = 0
	end
end

combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event =="PLAYER_REGEN_DISABLED" then
		TRB.Functions.Bar:ShowResourceBar()
	else
		TRB.Functions.Bar:HideResourceBar()
	end
end)

local function SwitchSpec()
	barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local specId = GetSpecialization()
	if specId == 1 then
		specCache.devastation.talents:GetTalents()
		FillSpellData_Devastation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.devastation)
		
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Devastation
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.evoker.devastation)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.devastation)

		if TRB.Data.barConstructedForSpec ~= "devastation" then
			talents = specCache.devastation.talents
			TRB.Data.barConstructedForSpec = "devastation"
			ConstructResourceBar(specCache.devastation.settings)
		end
	elseif specId == 2 then
		specCache.preservation.talents:GetTalents()
		FillSpellData_Preservation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.preservation)

		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Preservation
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.evoker.preservation)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.preservation)

		if TRB.Data.barConstructedForSpec ~= "preservation" then
			talents = specCache.devastation.talents
			TRB.Data.barConstructedForSpec = "preservation"
			ConstructResourceBar(specCache.preservation.settings)
		end
	elseif specId == 3 then
		specCache.augmentation.talents:GetTalents()
		FillSpellData_Augmentation()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.augmentation)
		
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		
		TRB.Functions.RefreshLookupData = RefreshLookupData_Augmentation
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.evoker.augmentation)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.augmentation)

		if TRB.Data.barConstructedForSpec ~= "augmentation" then
			talents = specCache.augmentation.talents
			TRB.Data.barConstructedForSpec = "augmentation"
			ConstructResourceBar(specCache.augmentation.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	TRB.Functions.Class:EventRegistration()
end

resourceFrame:RegisterEvent("ADDON_LOADED")
resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	local specId = GetSpecialization() or 0
	if classIndexId == 13 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Options:PortForwardSettings()

					local settings = TRB.Options.Evoker.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.devastation == nil or
						TwintopInsanityBarSettings.evoker.devastation.displayText == nil then
						settings.evoker.devastation.displayText.barText = TRB.Options.Evoker.DevastationLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.preservation == nil or
						TwintopInsanityBarSettings.evoker.preservation.displayText == nil then
						settings.evoker.preservation.displayText.barText = TRB.Options.Evoker.PreservationLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.evoker == nil or
						TwintopInsanityBarSettings.evoker.augmentation == nil or
						TwintopInsanityBarSettings.evoker.augmentation.displayText == nil then
						settings.evoker.augmentation.displayText.barText = TRB.Options.Evoker.AugmentationLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Evoker.LoadDefaultSettings(true)
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

		if TRB.Details.addonData.loaded and specId > 0 then
			if not TRB.Details.addonData.optionsPanel then
				TRB.Details.addonData.optionsPanel = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.barConstructedForSpec = nil
						TRB.Data.settings.evoker.devastation = TRB.Functions.LibSharedMedia:ValidateLsmValues("Devastation Evoker", TRB.Data.settings.evoker.devastation)
						TRB.Data.settings.evoker.preservation = TRB.Functions.LibSharedMedia:ValidateLsmValues("Preservation Evoker", TRB.Data.settings.evoker.preservation)
						TRB.Data.settings.evoker.augmentation = TRB.Functions.LibSharedMedia:ValidateLsmValues("Augmentation Evoker", TRB.Data.settings.evoker.augmentation)
						FillSpellData_Devastation()
						FillSpellData_Preservation()
						FillSpellData_Augmentation()

						SwitchSpec()

						TRB.Options.Evoker.ConstructOptionsPanel(specCache)
						
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
	local specId = GetSpecialization()
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "evoker"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	TRB.Data.character.maxResource2 = 1
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local settings = nil
	if specId == 1 then
		settings = TRB.Data.settings.evoker.devastation
		TRB.Data.character.specName = "devastation"
	elseif specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		settings = TRB.Data.settings.evoker.preservation
		TRB.Data.character.specName = "preservation"

		local trinket1ItemLink = GetInventoryItemLink("player", 13)
		local trinket2ItemLink = GetInventoryItemLink("player", 14)

		local alchemyStone = false
		local conjuredChillglobe = false
		local conjuredChillglobeMana = ""
		
		if trinket1ItemLink ~= nil then
			for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.attributes.itemIds) do
				if alchemyStone == false then
					alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, spells.alchemistStone.attributes.itemIds[x])
				else
					break
				end
			end

			if alchemyStone == false then
				conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
			end
		end

		if alchemyStone == false and trinket2ItemLink ~= nil then
			for x = 1, TRB.Functions.Table:Length(spells.alchemistStone.attributes.itemIds) do
				if alchemyStone == false then
					alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, spells.alchemistStone.attributes.itemIds[x])
				else
					break
				end
			end
		end

		if conjuredChillglobe == false and trinket2ItemLink ~= nil then
			conjuredChillglobe, conjuredChillglobeMana = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket2ItemLink)
		end

		TRB.Data.character.items.alchemyStone = alchemyStone
		TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
		TRB.Data.character.items.conjuredChillglobe.mana = conjuredChillglobeMana
	elseif specId == 3 then
		settings = TRB.Data.settings.evoker.augmentation
		TRB.Data.character.specName = "augmentation"
	end
	
	if settings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	local specId = GetSpecialization()
	if specId == 1 and TRB.Data.settings.core.enabled.evoker.devastation then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.devastation)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	elseif specId == 2 and TRB.Data.settings.core.enabled.evoker.preservation then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.preservation)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resourceFactor = 1
	elseif specId == 3 and TRB.Data.settings.core.enabled.evoker.augmentation then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.evoker.augmentation)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
	end

	if TRB.Data.specSupported then
		TRB.Functions.Class:CheckCharacter()

		targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
		barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

		TRB.Details.addonData.registered = true
	else -- This should never happen
		targetsTimerFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Details.addonData.registered = false
		barContainerFrame:Hide()
	end

	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Class:HideResourceBar(force)
	local affectingCombat = UnitAffectingCombat("player")
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local specId = GetSpecialization()

	if specId == 1 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.evoker.devastation.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.evoker.devastation.displayBar.alwaysShow) and (
					(not TRB.Data.settings.evoker.devastation.displayBar.notZeroShow) or
					(TRB.Data.settings.evoker.devastation.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.evoker.devastation.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	elseif specId == 2 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.evoker.preservation.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.evoker.preservation.displayBar.alwaysShow) and (
					(not TRB.Data.settings.evoker.preservation.displayBar.notZeroShow) or
					(TRB.Data.settings.evoker.preservation.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.evoker.preservation.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	elseif specId == 3 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.evoker.augmentation.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.evoker.augmentation.displayBar.alwaysShow) and (
					(not TRB.Data.settings.evoker.augmentation.displayBar.notZeroShow) or
					(TRB.Data.settings.evoker.augmentation.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.evoker.augmentation.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
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
	local specId = GetSpecialization()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil
	if specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.DevastationSpells]]
		settings = TRB.Data.settings.evoker.devastation
	elseif specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.PreservationSpells]]
		settings = TRB.Data.settings.evoker.preservation
	elseif specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Evoker.AugmentationSpells]]
		settings = TRB.Data.settings.evoker.augmentation
	else
		return false
	end

	if specId == 1 then --Devastation			
	elseif specId == 2 then --Preservation
		if var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$ecMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
				valid = true
			end
		elseif var == "$ecMana" then
			if snapshots[spells.emeraldCommunion.id].buff.isActive then
				valid = true
			end
		elseif var == "$ecTime" then
			if snapshots[spells.emeraldCommunion.id].buff.isActive then
				valid = true
			end
		elseif var == "$ecTicks" then
			if snapshots[spells.emeraldCommunion.id].buff.isActive then
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
			local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfFrozenFocusTicks" then
			local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfFrozenFocusTime" then
			local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$potionCooldown" then
			if snapshots[spells.aeratedManaPotionRank1.id].cooldown:IsUnusable() then
				valid = true
			end
		elseif var == "$potionCooldownSeconds" then
			if snapshots[spells.aeratedManaPotionRank1.id].cooldown:IsUnusable() then
				valid = true
			end
		end
	elseif specId == 3 then -- Augmentation
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
	elseif var == "$comboPoints" or var == "$essence" then
		valid = true
	elseif var == "$essenceRegenTime" then
		if snapshotData.attributes.resource2 < TRB.Data.character.maxResource2 then
			valid = true
		end
	elseif var == "$comboPointsMax"or var == "$essenceMax" then
		valid = true
	elseif var == "$ebTime" then
		if snapshots[spells.essenceBurst.id].buff.isActive then
			valid = true
		end
	elseif var == "$ebStacks" then
		if snapshots[spells.essenceBurst.id].buff.isActive then
			valid = true
		end
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	--local specId = GetSpecialization()
	--local settings = TRB.Data.settings.evoker
	--local spells = TRB.Data.spells
	--local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	--[[
	if specId == 1 then
	elseif specId == 2 then
	elseif specId == 3 then
	end]]
	return nil
end

--HACK to fix FPS
local updateRateLimit = 0

function TRB.Functions.Class:TriggerResourceBarUpdates()
	local specId = GetSpecialization()
	if (specId ~= 1 and specId ~= 2 and specId ~= 3) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	local currentTime = GetTime()

	if updateRateLimit + 0.05 < currentTime then
		updateRateLimit = currentTime
		UpdateResourceBar()
	end
end