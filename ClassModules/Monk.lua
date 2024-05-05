local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 10 then --Only do this if we're on a Monk!
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
	mistweaver = TRB.Classes.SpecCache:New(),
	windwalker = TRB.Classes.SpecCache:New()
}

local function CalculateManaGain(mana, isPotion)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
	if isPotion == nil then
		isPotion = false
	end

	local modifier = 1.0

	if isPotion then
		if TRB.Data.character.items.alchemyStone then
			modifier = modifier * spells.alchemistStone.attributes.resourcePercent
		end
	end

	return mana * modifier
end

local function FillSpecializationCache()
	-- Mistweaver
	specCache.mistweaver.Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
		dots = {
		},
	}

	specCache.mistweaver.character = {
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
	
	specCache.mistweaver.spellsData.spells = TRB.Classes.Monk.MistweaverSpells:New()
	---@type TRB.Classes.Monk.MistweaverSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.mistweaver.spellsData.spells

	specCache.mistweaver.snapshotData.attributes.manaRegen = 0
	specCache.mistweaver.snapshotData.audio = {
		innervateCue = false
	}
	---@type TRB.Classes.Healer.Innervate
	specCache.mistweaver.snapshotData.snapshots[spells.innervate.id] = TRB.Classes.Healer.Innervate:New(spells.innervate)
	---@type TRB.Classes.Healer.PotionOfChilledClarity
	specCache.mistweaver.snapshotData.snapshots[spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(spells.potionOfChilledClarity)
	---@type TRB.Classes.Healer.ManaTideTotem
	specCache.mistweaver.snapshotData.snapshots[spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(spells.manaTideTotem)
	---@type TRB.Classes.Healer.SymbolOfHope
	specCache.mistweaver.snapshotData.snapshots[spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(spells.symbolOfHope, CalculateManaGain)
	---@type TRB.Classes.Healer.ChanneledManaPotion
	specCache.mistweaver.snapshotData.snapshots[spells.potionOfFrozenFocusRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.potionOfFrozenFocusRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.aeratedManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.aeratedManaPotionRank1)
	---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.conjuredChillglobe.id] = TRB.Classes.Snapshot:New(spells.conjuredChillglobe)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.mistweaver.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.mistweaver.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)
	---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.manaTea.id] = TRB.Classes.Snapshot:New(spells.manaTea)
	---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.vivaciousVivification.id] = TRB.Classes.Snapshot:New(spells.vivaciousVivification, nil, true)
	---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.soulfangInfusion.id] = TRB.Classes.Healer.HealerRegenBase:New(spells.soulfangInfusion)

	specCache.mistweaver.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Windwalker
	specCache.windwalker.Global_TwintopResourceBar = {
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

	specCache.windwalker.character = {
		guid = UnitGUID("player"),
		specId = 1,
		maxResource = 100,
		maxResource2 = 5,
		effects = {
		},
		items = {}
	}
	
	specCache.windwalker.spellsData.spells = TRB.Classes.Monk.WindwalkerSpells:New()
	---@type TRB.Classes.Monk.WindwalkerSpells
	---@diagnostic disable-next-line: assign-type-mismatch, cast-local-type
	spells = specCache.windwalker.spellsData.spells

	specCache.windwalker.snapshotData.attributes.resourceRegen = 0
	specCache.windwalker.snapshotData.audio = {
		overcapCue = false,
		playedDanceOfChiJiCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.detox.id] = TRB.Classes.Snapshot:New(spells.detox)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.expelHarm.id] = TRB.Classes.Snapshot:New(spells.expelHarm)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.paralysis.id] = TRB.Classes.Snapshot:New(spells.paralysis)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.strikeOfTheWindlord.id] = TRB.Classes.Snapshot:New(spells.strikeOfTheWindlord)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.serenity.id] = TRB.Classes.Snapshot:New(spells.serenity)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.danceOfChiJi.id] = TRB.Classes.Snapshot:New(spells.danceOfChiJi)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.markOfTheCrane.id] = TRB.Classes.Snapshot:New(spells.markOfTheCrane, {
		count = 0,
		activeCount = 0,
		minEndTime = nil,
		maxEndTime = nil,
		list = {}
	})

	specCache.windwalker.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Mistweaver()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "monk", "mistweaver")
end

local function Setup_Windwalker()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "monk", "windwalker")
end

local function FillSpellData_Mistweaver()
	Setup_Mistweaver()
	---@type TRB.Classes.SpellsData
	specCache.mistweaver.spellsData:FillSpellData()
	local spells = specCache.mistweaver.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.mistweaver.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		
		{ variable = "#manaTea", icon = spells.manaTea.icon, description = spells.manaTea.name, printInSettings = true },

		{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
		{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },
		
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

		{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
		{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },

		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

		{ variable = "#si", icon = spells.soulfangInfusion.icon, description = spells.soulfangInfusion.name, printInSettings = true },
		{ variable = "#soulfangInfusion", icon = spells.soulfangInfusion.icon, description = spells.soulfangInfusion.name, printInSettings = false },

		{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
		{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
		{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
	}
	specCache.mistweaver.barTextVariables.values = {
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

		{ variable = "$mana", description = L["MonkMistweaverBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MonkMistweaverBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MonkMistweaverBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MonkMistweaverBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["MonkMistweaverBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["MonkMistweaverBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["MonkMistweaverBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["MonkMistweaverBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$bowMana", description = L["MonkMistweaverBarTextVariable_bowMana"], printInSettings = true, color = false },
		{ variable = "$bowTime", description = L["MonkMistweaverBarTextVariable_bowTime"], printInSettings = true, color = false },
		{ variable = "$bowTicks", description = L["MonkMistweaverBarTextVariable_bowTicks"], printInSettings = true, color = false },

		{ variable = "$sohMana", description = L["MonkMistweaverBarTextVariable_sohMana"], printInSettings = true, color = false },
		{ variable = "$sohTime", description = L["MonkMistweaverBarTextVariable_sohTime"], printInSettings = true, color = false },
		{ variable = "$sohTicks", description = L["MonkMistweaverBarTextVariable_sohTicks"], printInSettings = true, color = false },

		{ variable = "$innervateMana", description = L["MonkMistweaverBarTextVariable_innervateMana"], printInSettings = true, color = false },
		{ variable = "$innervateTime", description = L["MonkMistweaverBarTextVariable_innervateTime"], printInSettings = true, color = false },
								
		{ variable = "$mrMana", description = L["MonkMistweaverBarTextVariable_mrMana"], printInSettings = true, color = false },
		{ variable = "$mrTime", description = L["MonkMistweaverBarTextVariable_mrTime"], printInSettings = true, color = false },

		{ variable = "$mttMana", description = L["MonkMistweaverBarTextVariable_mttMana"], printInSettings = true, color = false },
		{ variable = "$mttTime", description = L["MonkMistweaverBarTextVariable_mttTime"], printInSettings = true, color = false },

		{ variable = "$mtTime", description = L["MonkMistweaverBarTextVariable_mtTime"], printInSettings = true, color = false },
		{ variable = "$manaTeaTime", description = "", printInSettings = false, color = false },

		{ variable = "$siMana", description = L["MonkMistweaverBarTextVariable_siMana"], printInSettings = true, color = false },
		{ variable = "$siTime", description = L["MonkMistweaverBarTextVariable_siTime"], printInSettings = true, color = false },
		{ variable = "$siTicks", description = L["MonkMistweaverBarTextVariable_siTicks"], printInSettings = true, color = false },

		{ variable = "$channeledMana", description = L["MonkMistweaverBarTextVariable_channeledMana"], printInSettings = true, color = false },
		{ variable = "$potionOfFrozenFocusTicks", description = L["MonkMistweaverBarTextVariable_potionOfFrozenFocusTicks"], printInSettings = true, color = false },
		{ variable = "$potionOfFrozenFocusTime", description = L["MonkMistweaverBarTextVariable_potionOfFrozenFocusTime"], printInSettings = true, color = false },
		
		{ variable = "$potionOfChilledClarityMana", description = L["MonkMistweaverBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
		{ variable = "$potionOfChilledClarityTime", description = L["MonkMistweaverBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

		{ variable = "$potionCooldown", description = L["MonkMistweaverBarTextVariable_potionCooldown"], printInSettings = true, color = false },
		{ variable = "$potionCooldownSeconds", description = L["MonkMistweaverBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function FillSpellData_Windwalker()
	Setup_Windwalker()
	---@type TRB.Classes.SpellsData
	specCache.windwalker.spellsData:FillSpellData()
	local spells = specCache.windwalker.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.windwalker.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#blackoutKick", icon = spells.blackoutKick.icon, description = spells.blackoutKick.name, printInSettings = true },
		{ variable = "#cracklingJadeLightning", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = true },
		{ variable = "#cjl", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = false },
		{ variable = "#danceOfChiJi", icon = spells.danceOfChiJi.icon, description = spells.danceOfChiJi.name, printInSettings = true },
		{ variable = "#detox", icon = spells.detox.icon, description = spells.detox.name, printInSettings = true },
		{ variable = "#disable", icon = spells.disable.icon, description = spells.disable.name, printInSettings = true },
		{ variable = "#expelHarm", icon = spells.expelHarm.icon, description = spells.expelHarm.name, printInSettings = true },
		{ variable = "#fistsOfFury", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = true },
		{ variable = "#fof", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = false },
		{ variable = "#strikeOfTheWindlord", icon = spells.strikeOfTheWindlord.icon, description = spells.strikeOfTheWindlord.name, printInSettings = true },
		{ variable = "#paralysis", icon = spells.paralysis.icon, description = spells.paralysis.name, printInSettings = true },
		{ variable = "#risingSunKick", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = true },
		{ variable = "#rsk", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = false },
		{ variable = "#serenity", icon = spells.serenity.icon, description = spells.serenity.name, printInSettings = true },
		{ variable = "#spinningCraneKick", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = true },
		{ variable = "#sck", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = false },
		{ variable = "#tigerPalm", icon = spells.tigerPalm.icon, description = spells.tigerPalm.name, printInSettings = true },
		{ variable = "#touchOfDeath", icon = spells.touchOfDeath.icon, description = spells.touchOfDeath.name, printInSettings = true },
		{ variable = "#vivify", icon = spells.vivify.icon, description = spells.vivify.name, printInSettings = true },
	}
	specCache.windwalker.barTextVariables.values = {
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

		{ variable = "$energy", description = L["MonkWindwalkerBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["MonkWindwalkerBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MonkWindwalkerBarTextVariable_casting"], printInSettings = false, color = false },
		{ variable = "$passive", description = L["MonkWindwalkerBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$regen", description = L["MonkWindwalkerBarTextVariable_regen"], printInSettings = true, color = false },
		{ variable = "$regenEnergy", description = "", printInSettings = false, color = false },
		{ variable = "$energyRegen", description = "", printInSettings = false, color = false },
		{ variable = "$resourceRegen", description = "", printInSettings = false, color = false },
		{ variable = "$energyPlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$energyPlusPassive", description = L["MonkWindwalkerBarTextVariable_energyPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$energyTotal", description = L["MonkWindwalkerBarTextVariable_energyTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$chi", description = L["MonkWindwalkerBarTextVariable_chi"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$chiMax", description = L["MonkWindwalkerBarTextVariable_chiMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$serenityTime", description = L["MonkWindwalkerBarTextVariable_serenityTime"], printInSettings = true, color = false },

		{ variable = "$danceOfChiJiTime", description = L["MonkWindwalkerBarTextVariable_danceOfChiJiTime"], printInSettings = true, color = false },

		{ variable = "$motcCount", description = L["MonkWindwalkerBarTextVariable_motcCount"], printInSettings = true, color = false },
		{ variable = "$motcActiveCount", description = L["MonkWindwalkerBarTextVariable_motcActiveCount"], printInSettings = true, color = false },
		{ variable = "$motcTime", description = L["MonkWindwalkerBarTextVariable_motcTime"], printInSettings = true, color = false },
		{ variable = "$motcMinTime", description = L["MonkWindwalkerBarTextVariable_motcMinTime"], printInSettings = true, color = false },
		{ variable = "$motcMaxTime", description = L["MonkWindwalkerBarTextVariable_motcMaxTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local specId = GetSpecialization()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	
	if specId == 2 then -- Mistweaver
	elseif specId == 3 then -- Windwalker
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local specId = GetSpecialization()

	local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			resourceFrame.thresholds[x]:Hide()
		end
	end

	if specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
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
		
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], spells.aeratedManaPotionRank1, TRB.Data.settings.monk.mistweaver)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], spells.aeratedManaPotionRank2, TRB.Data.settings.monk.mistweaver)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], spells.aeratedManaPotionRank3, TRB.Data.settings.monk.mistweaver)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], spells.potionOfFrozenFocusRank1, TRB.Data.settings.monk.mistweaver)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], spells.potionOfFrozenFocusRank2, TRB.Data.settings.monk.mistweaver)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], spells.potionOfFrozenFocusRank3, TRB.Data.settings.monk.mistweaver)
		TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], spells.conjuredChillglobe, TRB.Data.settings.monk.mistweaver)
		TRB.Frames.resource2ContainerFrame:Hide()
	elseif specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
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
		TRB.Frames.resource2ContainerFrame:Show()
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)

	if specId == 2  or specId == 3 then
		TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
	end
end

local function GetGuidPositionInMarkOfTheCraneList(guid)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local markOfTheCrane = TRB.Data.snapshotData.snapshots[spells.markOfTheCrane.id] --[[@as TRB.Classes.Snapshot]]
	local entries = TRB.Functions.Table:Length(markOfTheCrane.attributes.list)
	for x = 1, entries do
		if markOfTheCrane.attributes.list[x].guid == guid then
			return x
		end
	end
	return 0
end

local function ApplyMarkOfTheCrane(guid)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local markOfTheCrane = snapshotData.snapshots[spells.markOfTheCrane.id]
	local targetData = snapshotData.targetData
	local currentTime = GetTime()
	targetData.targets[guid].spells[spells.markOfTheCrane.id].active = true
	targetData.targets[guid].spells[spells.markOfTheCrane.id].remainingTime = spells.markOfTheCrane.duration
	local listPosition = GetGuidPositionInMarkOfTheCraneList(guid)
	if listPosition > 0 then
		markOfTheCrane.attributes.list[listPosition].startTime = currentTime
		markOfTheCrane.attributes.list[listPosition].endTime = currentTime + spells.markOfTheCrane.duration
	else
		targetData.count[spells.markOfTheCrane.id] = targetData.count[spells.markOfTheCrane.id] + 1
		table.insert(markOfTheCrane.attributes.list, {
			guid = guid,
			endTime = currentTime + spells.markOfTheCrane.duration
		})
	end
end

local function GetOldestOrExpiredMarkOfTheCraneListEntry(any, aliveOnly)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local markOfTheCrane = snapshotData.snapshots[spells.markOfTheCrane.id]
	local targetData = snapshotData.targetData
	local currentTime = GetTime()
	local entries = TRB.Functions.Table:Length(markOfTheCrane.attributes.list)
	local oldestTime = currentTime
	local oldestId = 0

	if any then
		oldestTime = oldestTime + spells.markOfTheCrane.duration
	end

	for x = 1, entries do
		local listItem = markOfTheCrane.attributes.list[x]
		local target = targetData.targets[listItem.guid]

		if target ~= nil and target.spells[spells.markOfTheCrane.id].active and listItem.endTime > currentTime then
			targetData.targets[listItem.guid].spells[spells.markOfTheCrane.id].remainingTime = listItem.endTime - currentTime
		end

		if listItem.endTime < oldestTime and (not aliveOnly or target ~= nil) then
			oldestId = x
			oldestTime = listItem.endTime
		end
	end
	return oldestId
end

local function RemoveExcessMarkOfTheCraneEntries()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local markOfTheCrane = snapshotData.snapshots[spells.markOfTheCrane.id]
	local targetData = snapshotData.targetData
	while true do
		local id = GetOldestOrExpiredMarkOfTheCraneListEntry(false)

		if id == 0 then
			return
		else
			if targetData.targets[markOfTheCrane.attributes.list[id].guid] ~= nil then
				targetData.targets[markOfTheCrane.attributes.list[id].guid].spells[spells.markOfTheCrane.id].active = false
				targetData.targets[markOfTheCrane.attributes.list[id].guid].spells[spells.markOfTheCrane.id].remainingTime = 0
			end
			table.remove(markOfTheCrane.attributes.list, id)
		end
	end
end

local function IsTargetLowestInMarkOfTheCraneList()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	if targetData.currentTargetGuid == nil then
		return false
	end

	local markOfTheCrane = snapshotData.snapshots[spells.markOfTheCrane.id]

	local oldest = GetOldestOrExpiredMarkOfTheCraneListEntry(true, true)
	if oldest > 0 and markOfTheCrane.attributes.list[oldest].guid == targetData.currentTargetGuid then
		return true
	end

	return false
end

local function RefreshLookupData_Mistweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.mistweaver
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

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
	
	local soulfangInfusion = snapshots[spells.soulfangInfusion.id] --[[@as TRB.Classes.Healer.HealerRegenBase]]
	--$siMana
	local _siMana = soulfangInfusion.buff.resource
	local siMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_siMana, manaPrecision, "floor", true))
	--$siTicks
	local _siTicks = soulfangInfusion.buff.ticks
	local siTicks = string.format("%.0f", _siTicks)
	--$siTime
	local _siTime = soulfangInfusion.buff:GetRemainingTime(currentTime)
	local siTime = TRB.Functions.BarText:TimerPrecision(_siTime)
	
	local manaTea = snapshots[spells.manaTea.id] --[[@as TRB.Classes.Snapshot]]
	--$mrTime
	local _mtTime = manaTea.buff.remaining
	local mtTime = TRB.Functions.BarText:TimerPrecision(_mtTime)

	--$passive
	local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana + _siMana + _bowMana
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

	----------

	Global_TwintopResourceBar.resource.passive = _passiveMana
	Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
	Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
	Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
	Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
	Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
	Global_TwintopResourceBar.resource.soulfangInfusion = _siMana or 0
	Global_TwintopResourceBar.potionOfSpiritualClarity = {
		mana = _channeledMana,
		ticks = _potionOfFrozenFocusTicks
	}
	Global_TwintopResourceBar.symbolOfHope = {
		mana = _sohMana,
		ticks = _sohTicks
	}
	Global_TwintopResourceBar.soulfangInfusion = {
		mana = _siMana,
		ticks = _siTicks
	}


	local lookup = TRB.Data.lookup or {}
	lookup["#innervate"] = spells.innervate.icon
	lookup["#mr"] = spells.moltenRadiance.icon
	lookup["#moltenRadiance"] = spells.moltenRadiance.icon
	lookup["#manaTea"] = spells.manaTea.icon
	lookup["#mtt"] = spells.manaTideTotem.icon
	lookup["#manaTideTotem"] = spells.manaTideTotem.icon
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
	lookup["#si"] = spells.soulfangInfusion.icon
	lookup["#soulfangInfusion"] = spells.soulfangInfusion.icon
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
	lookup["$mrMana"] = mrMana
	lookup["$mrTime"] = mrTime
	lookup["$bowMana"] = bowMana
	lookup["$bowTime"] = bowTime
	lookup["$bowTicks"] = bowTicks
	lookup["$mttMana"] = mttMana
	lookup["$mttTime"] = mttTime
	lookup["$mtTime"] = mtTime
	lookup["$manaTeaTime"] = mtTime
	lookup["$siMana"] = siMana
	lookup["$siTicks"] = siTicks
	lookup["$siTime"] = siTime
	lookup["$channeledMana"] = channeledMana
	lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
	lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
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
	lookupLogic["$mrMana"] = _mrMana
	lookupLogic["$mrTime"] = _mrTime
	lookupLogic["$bowMana"] = _bowMana
	lookupLogic["$bowTime"] = _bowTime
	lookupLogic["$bowTicks"] = _bowTicks
	lookupLogic["$mttMana"] = _mttMana
	lookupLogic["$mttTime"] = _mttTime
	lookupLogic["$mtTime"] = _mtTime
	lookupLogic["$manaTeaTime"] = _mtTime
	lookupLogic["$siMana"] = _siMana
	lookupLogic["$siTicks"] = _siTicks
	lookupLogic["$siTime"] = _siTime
	lookupLogic["$channeledMana"] = _channeledMana
	lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
	lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
	lookupLogic["$potionCooldown"] = potionCooldown
	lookupLogic["$potionCooldownSeconds"] = potionCooldown
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Windwalker()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.windwalker
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local _
	--Spec specific implementation
	local currentTime = GetTime()

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.resourceRegen, _ = GetPowerRegen()

	--$overcap
	local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentEnergyColor = specSettings.colors.text.current
	local castingEnergyColor = specSettings.colors.text.casting
	
	if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
		if specSettings.colors.text.overcapEnabled and overcap then
			currentEnergyColor = specSettings.colors.text.overcap
			castingEnergyColor = specSettings.colors.text.overcap
		elseif specSettings.colors.text.overThresholdEnabled then
			local _overThreshold = false
			for _, v in pairs(spells) do
				local spell = v --[[@as TRB.Classes.SpellBase]]
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
					_overThreshold = true
					break
				end
			end

			if _overThreshold then
				currentEnergyColor = specSettings.colors.text.overThreshold
				castingEnergyColor = specSettings.colors.text.overThreshold
			end
		end
	end

	if snapshotData.casting.resourceFinal < 0 then
		castingEnergyColor = specSettings.colors.text.spending
	end

	--$energy
	local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, snapshotData.attributes.resource)
	--$casting
	local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, snapshotData.casting.resourceFinal)
	--$passive
	local _regenEnergy = 0
	local _passiveEnergy
	local _passiveEnergyMinusRegen

	local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

	if specSettings.generation.enabled then
		if specSettings.generation.mode == "time" then
			_regenEnergy = snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0)
		else
			_regenEnergy = snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * _gcd)
		end
	end

	--$regenEnergy
	local regenEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _regenEnergy)

	_passiveEnergy = _regenEnergy
	_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

	local passiveEnergy = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergy)
	local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveEnergyMinusRegen)
	--$energyTotal
	local _energyTotal = math.min(_passiveEnergy + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
	--$energyPlusCasting
	local _energyPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
	--$energyPlusPassive
	local _energyPlusPassive = math.min(_passiveEnergy + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)
	
	--$serenityTime
	local _serenityTime = snapshots[spells.serenity.id].buff:GetRemainingTime(currentTime)
	local serenityTime = TRB.Functions.BarText:TimerPrecision(_serenityTime)
	
	--$danceOfChiJiTime
	local _danceOfChiJiTime = snapshots[spells.danceOfChiJi.id].buff:GetRemainingTime(currentTime)
	local danceOfChiJiTime = TRB.Functions.BarText:TimerPrecision(_danceOfChiJiTime)
	
	--$motcMinTime
	local _motcMinTime = (snapshots[spells.markOfTheCrane.id].attributes.minEndTime or 0) - currentTime
	local motcMinTime = TRB.Functions.BarText:TimerPrecision(_motcMinTime)
	
	--$motcMaxTime
	local _motcMaxTime = (snapshots[spells.markOfTheCrane.id].attributes.maxEndTime or 0) - currentTime
	local motcMaxTime = TRB.Functions.BarText:TimerPrecision(_motcMaxTime)

	
	local targetMotcId = GetGuidPositionInMarkOfTheCraneList(targetData.currentTargetGuid)
	--$motcTime
	local _motcTime = 0

	if targetMotcId > 0 and target ~= nil then
		_motcTime = snapshots[spells.markOfTheCrane.id].attributes.list[targetMotcId].endTime - currentTime
	end

	local _motcCount = snapshots[spells.markOfTheCrane.id].attributes.count or 0
	local motcCount = tostring(_motcCount)
	local _motcActiveCount = snapshots[spells.markOfTheCrane.id].attributes.activeCount or 0
	local motcActiveCount = tostring(_motcActiveCount)

	local motcTime

	if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if targetMotcId > 0 and target ~= nil and target.spells[spells.markOfTheCrane.id].active then
			if not IsTargetLowestInMarkOfTheCraneList() then
				motcCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, snapshots[spells.markOfTheCrane.id].attributes.count)
				motcActiveCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, snapshots[spells.markOfTheCrane.id].attributes.activeCount)
				motcTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_motcTime))
			else
				motcCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, snapshots[spells.markOfTheCrane.id].attributes.count)
				motcActiveCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, snapshots[spells.markOfTheCrane.id].attributes.activeCount)
				motcTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_motcTime))
			end
		else
			motcCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, snapshots[spells.markOfTheCrane.id].attributes.count)
			motcActiveCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, snapshots[spells.markOfTheCrane.id].attributes.activeCount)
			motcTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		motcTime = TRB.Functions.BarText:TimerPrecision(_motcTime)
	end

	----------------------------

	Global_TwintopResourceBar.resource.passive = _passiveEnergy
	Global_TwintopResourceBar.resource.regen = _regenEnergy
	Global_TwintopResourceBar.dots = {
		motcCount = _motcCount,
		motcActiveCount = _motcActiveCount
	}
	Global_TwintopResourceBar.markOfTheCrane = {
		count = _motcCount,
		activeCount = _motcActiveCount,
		targetTime = _motcTime,
		minTime = _motcMinTime,
		maxTime = _motcMaxTime
	}

	local lookup = TRB.Data.lookup or {}
	lookup["#blackoutKick"] = spells.blackoutKick.icon
	lookup["#cracklingJadeLightning"] = spells.cracklingJadeLightning.icon
	lookup["#cjl"] = spells.cracklingJadeLightning.icon
	lookup["#danceOfChiJi"] = spells.danceOfChiJi.icon
	lookup["#detox"] = spells.detox.icon
	lookup["#disable"] = spells.disable.icon
	lookup["#expelHarm"] = spells.expelHarm.icon
	lookup["#fistsOfFury"] = spells.fistsOfFury.icon
	lookup["#fof"] = spells.fistsOfFury.icon
	lookup["#strikeOfTheWindlord"] = spells.strikeOfTheWindlord.icon
	lookup["#paralysis"] = spells.paralysis.icon
	lookup["#risingSunKick"] = spells.risingSunKick.icon
	lookup["#rsk"] = spells.risingSunKick.icon
	lookup["#serenity"] = spells.serenity.icon
	lookup["#spinningCraneKick"] = spells.spinningCraneKick.icon
	lookup["#sck"] = spells.spinningCraneKick.icon
	lookup["#tigerPalm"] = spells.tigerPalm.icon
	lookup["#touchOfDeath"] = spells.touchOfDeath.icon
	lookup["#vivify"] = spells.vivify.icon

	lookup["$energyTotal"] = energyTotal
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$energy"] = currentEnergy
	lookup["$energyPlusCasting"] = energyPlusCasting
	lookup["$resourcePlusCasting"] = energyPlusCasting
	lookup["$energyPlusPassive"] = energyPlusPassive
	lookup["$resourcePlusPassive"] = energyPlusPassive
	lookup["$resourceTotal"] = energyTotal
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentEnergy
	lookup["$casting"] = castingEnergy
	lookup["$chi"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$chiMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookup["$passive"] = passiveEnergyMinusRegen
	else
		lookup["$passive"] = passiveEnergy
	end

	lookup["$regen"] = regenEnergy
	lookup["$regenEnergy"] = regenEnergy
	lookup["$energyRegen"] = regenEnergy
	lookup["$resourceRegen"] = regenEnergy
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$energyOvercap"] = overcap
	lookup["$serenityTime"] = serenityTime
	lookup["$danceOfChiJiTime"] = danceOfChiJiTime
	lookup["$motcMinTime"] = motcMinTime
	lookup["$motcMaxTime"] = motcMaxTime
	lookup["$motcTime"] = motcTime
	lookup["$motcCount"] = motcCount
	lookup["$motcActiveCount"] = motcActiveCount
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$energyTotal"] = _energyTotal
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$energyPlusCasting"] = _energyPlusCasting
	lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
	lookupLogic["$energyPlusPassive"] = _energyPlusPassive
	lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
	lookupLogic["$resourceTotal"] = _energyTotal
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$chi"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$chiMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2

	if TRB.Data.character.maxResource == snapshotData.attributes.resource then
		lookupLogic["$passive"] = _passiveEnergyMinusRegen
	else
		lookupLogic["$passive"] = _passiveEnergy
	end

	lookupLogic["$regen"] = _regenEnergy
	lookupLogic["$regenEnergy"] = _regenEnergy
	lookupLogic["$energyRegen"] = _regenEnergy
	lookupLogic["$resourceRegen"] = _regenEnergy
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$energyOvercap"] = overcap
	lookupLogic["$serenityTime"] = _serenityTime
	lookupLogic["$danceOfChiJiTime"] = _danceOfChiJiTime
	lookupLogic["$motcMinTime"] = _motcMinTime
	lookupLogic["$motcMaxTime"] = _motcMaxTime
	lookupLogic["$motcTime"] = _motcTime
	lookupLogic["$motcCount"] = _motcCount
	lookupLogic["$motcActiveCount"] = _motcActiveCount
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateCastingResourceFinal()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function UpdateCastingResourceFinal_Mistweaver()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
end

local function CastingSpell()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local currentTime = GetTime()
	local affectingCombat = UnitAffectingCombat("player")
	local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
	local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")
	local specId = GetSpecialization()

	if currentSpellName == nil and currentChannelName == nil then
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	else
		if specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
			if currentSpellName == nil then
				if currentChannelId == spells.soothingMist.id then
					local manaCost = -spells.soothingMist:GetPrimaryResourceCost(true)

					snapshotData.casting.spellId = spells.soothingMist.id
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = manaCost
					snapshotData.casting.icon = spells.soothingMist.icon

					UpdateCastingResourceFinal_Mistweaver()
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
				end
				return false
			else
				local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

				if spellId then
					local manaCost = -TRB.Classes.SpellBase.GetPrimaryResourceCost({ id = spellId, primaryResourceType = Enum.PowerType.Mana, primaryResourceTypeProperty = "cost", primaryResourceTypeMod = 1.0 }, true)

					snapshotData.casting.startTime = currentSpellStartTime / 1000
					snapshotData.casting.endTime = currentSpellEndTime / 1000
					snapshotData.casting.resourceRaw = manaCost
					snapshotData.casting.spellId = spellId
					snapshotData.casting.icon = string.format("|T%s:0|t", spellIcon)

					UpdateCastingResourceFinal_Mistweaver()
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			return true
		elseif specId == 3 then
			if currentSpellName == nil then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
				if currentChannelId == spells.cracklingJadeLightning.id then
					snapshotData.casting.spellId = spells.cracklingJadeLightning.id
					snapshotData.casting.startTime = currentTime
					snapshotData.casting.resourceRaw = spells.cracklingJadeLightning:GetPrimaryResourceCost()
					snapshotData.casting.icon = spells.cracklingJadeLightning.icon
					UpdateCastingResourceFinal()
				end
				return true
			else
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			end
		end
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	end
end

local function UpdateMarkOfTheCrane()
	RemoveExcessMarkOfTheCraneEntries()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local markOfTheCrane = TRB.Data.snapshotData.snapshots[spells.markOfTheCrane.id] --[[@as TRB.Classes.Snapshot]]
	local entries = TRB.Functions.Table:Length(markOfTheCrane.attributes.list)
	local minEndTime = nil
	local maxEndTime = nil
	local activeCount = 0
	local currentTime = GetTime()
	if entries > 0 then
		for x = 1, entries do
			activeCount = activeCount + 1
			markOfTheCrane.buff.isActive = true

			if markOfTheCrane.attributes.list[x].endTime > (maxEndTime or 0) then
				maxEndTime = markOfTheCrane.attributes.list[x].endTime
			end
			
			if markOfTheCrane.attributes.list[x].endTime < (minEndTime or currentTime+999) then
				minEndTime = markOfTheCrane.attributes.list[x].endTime
			end
		end
	end

	if activeCount > 0 then
		markOfTheCrane.buff.isActive = true
	else
		markOfTheCrane.buff.isActive = false
	end

	markOfTheCrane.attributes.count = GetSpellCount(spells.spinningCraneKick.id)

	-- Avoid race conditions from combat log events saying we have 6 marks when 5 is the max
	if markOfTheCrane.attributes.count < activeCount then
		markOfTheCrane.attributes.activeCount = markOfTheCrane.attributes.count
	else
		markOfTheCrane.attributes.activeCount = activeCount
	end

	markOfTheCrane.attributes.minEndTime = minEndTime
	markOfTheCrane.attributes.maxEndTime = maxEndTime
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local currentTime = GetTime()
end

local function UpdateSnapshot_Mistweaver()
	local currentTime = GetTime()
	UpdateSnapshot()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
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

	local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	channeledManaPotion:Update()

	-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
	snapshots[spells.aeratedManaPotionRank1.id].cooldown.startTime, snapshots[spells.aeratedManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
	snapshots[spells.aeratedManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)

	snapshots[spells.conjuredChillglobe.id].cooldown.startTime, snapshots[spells.conjuredChillglobe.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
	snapshots[spells.conjuredChillglobe.id].cooldown:GetRemainingTime(currentTime)

	local soulfangInfusion = snapshots[spells.soulfangInfusion.id] --[[@as TRB.Classes.Healer.HealerRegenBase]]
	soulfangInfusion.buff:UpdateTicks(currentTime)
	soulfangInfusion.mana = soulfangInfusion.buff.resource
end

local function UpdateSnapshot_Windwalker()
	UpdateSnapshot()
	UpdateMarkOfTheCrane()

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	local currentTime = GetTime()

	snapshots[spells.detox.id].cooldown:Refresh()
	snapshots[spells.expelHarm.id].cooldown:Refresh()
	snapshots[spells.paralysis.id].cooldown:Refresh()

	snapshots[spells.strikeOfTheWindlord.id].buff:GetRemainingTime(currentTime)
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local specId = GetSpecialization()
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.monk
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	
	if specId == 2 then
		local specSettings = classSettings.mistweaver
		UpdateSnapshot_Mistweaver()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

				if potionOfChilledClarity.buff.isActive and specSettings.colors.bar.potionOfChilledClarityBorderChange then
					barBorderColor = specSettings.colors.bar.potionOfChilledClarity
				elseif innervate.buff.isActive and (specSettings.colors.bar.innervateBorderChange or specSettings.audio.innervate.enabled)  then
					if specSettings.colors.bar.innervateBorderChange then
						barBorderColor = specSettings.colors.bar.innervate
					end

					if specSettings.audio.innervate.enabled and snapshotData.audio.innervateCue == false then
						snapshotData.audio.innervateCue = true
						PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
					end
				elseif snapshots[spells.manaTea.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.manaTea.color
				end

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				if CastingSpell() and specSettings.bar.showCasting  then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				TRB.Functions.Threshold:ManageCommonHealerThresholds(currentResource, castingBarValue, specSettings, snapshots[spells.aeratedManaPotionRank1.id].cooldown, snapshots[spells.conjuredChillglobe.id].cooldown, TRB.Data.character, resourceFrame, CalculateManaGain)

				local passiveValue, thresholdCount = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				thresholdCount = thresholdCount + 1
				if specSettings.bar.showPassive then
					passiveValue = TRB.Functions.Threshold:ManageHealerManaPassiveThreshold(specSettings, snapshots[spells.soulfangInfusion.id] --[[@as TRB.Classes.Healer.HealerRegenBase]], passiveFrame, thresholdCount, castingBarValue, passiveValue)
				else
					TRB.Frames.passiveFrame.thresholds[thresholdCount]:Hide()
				end

				passiveBarValue = castingBarValue + passiveValue
				if castingBarValue < currentResource then --Using a spender
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

				local affectingCombat = UnitAffectingCombat("player")
				local resourceBarColor = nil

				resourceBarColor = specSettings.colors.bar.base

				if specSettings.colors.bar.vivaciousVivification.enabled and affectingCombat and snapshots[spells.vivaciousVivification.id].buff.isActive then
					resourceBarColor = specSettings.colors.bar.vivaciousVivification.color
				end

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
			end

			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		end
	elseif specId == 3 then
		local specSettings = classSettings.windwalker
		UpdateSnapshot_Windwalker()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

				local passiveValue = 0
				if specSettings.bar.showPassive then
					if specSettings.generation.enabled then
						if specSettings.generation.mode == "time" then
							passiveValue = (snapshotData.attributes.resourceRegen * (specSettings.generation.time or 3.0))
						else
							passiveValue = (snapshotData.attributes.resourceRegen * ((specSettings.generation.gcds or 2) * gcd))
						end
					end
				end

				if CastingSpell() and specSettings.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				if castingBarValue < currentResource then --Using a spender
					if -snapshotData.casting.resourceFinal > passiveValue then
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, castingBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, currentResource)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end
				else
					passiveBarValue = castingBarValue + passiveValue
					TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
					castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
					passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
				end

				local pairOffset = 0
				for _, v in pairs(TRB.Data.spellsData.spells) do
					local spell = v --[[@as TRB.Classes.SpellBase]]
					if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
						spell = spell --[[@as TRB.Classes.SpellThreshold]]
						local resourceAmount = -spell:GetPrimaryResourceCost()
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, -resourceAmount, TRB.Data.character.maxResource)

						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						elseif resourceAmount == 0 then
							showThreshold = false
						elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
							showThreshold = false
						elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
							showThreshold = false
						elseif spell.hasCooldown then
							if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							elseif currentResource >= -resourceAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else -- This is an active/available/normal spell threshold
							if currentResource >= -resourceAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end

						if  spell:Is("TRB.Classes.SpellComboPointThreshold") and
							spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true
							and snapshotData.attributes.resource2 == 0 then
							thresholdColor = specSettings.colors.threshold.unusable
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						end

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)
					end
					pairOffset = pairOffset + 3
				end

				local barColor = specSettings.colors.bar.base
				if snapshots[spells.serenity.id].buff.isActive then
					local timeThreshold = 0
					if specSettings.endOfSerenity.mode == "gcd" then
						local gcd = TRB.Functions.Character:GetCurrentGCDTime()
						timeThreshold = gcd * specSettings.endOfSerenity.gcdsMax
					elseif specSettings.endOfSerenity.mode == "time" then
						timeThreshold = specSettings.endOfSerenity.timeMax
					end
					
					if snapshots[spells.serenity.id].buff:GetRemainingTime(currentTime) <= timeThreshold then
						barColor = specSettings.colors.bar.serenityEnd
					else
						barColor = specSettings.colors.bar.serenity
					end
				end

				local barBorderColor = specSettings.colors.bar.border
				if snapshots[spells.danceOfChiJi.id].buff.isActive then
					barBorderColor = specSettings.colors.bar.borderChiJi
				elseif specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end

				barContainerFrame:SetAlpha(1.0)

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
	local specId = GetSpecialization()
	local spells
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

		local settings
		if specId == 2 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
			settings = TRB.Data.settings.monk.mistweaver
		elseif specId == 3 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
			settings = TRB.Data.settings.monk.windwalker
		end

		if entry.destinationGuid == TRB.Data.character.guid then
			if specId == 2 and TRB.Data.barConstructedForSpec == "mistweaver" then -- Let's check raid effect mana stuff
				if settings.passiveGeneration.symbolOfHope and (entry.spellId == spells.symbolOfHope.tickId or entry.spellId == spells.symbolOfHope.id) then
					local castByToken = UnitTokenFromGUID(entry.sourceGuid)
					local symbolOfHope = snapshots[spells.symbolOfHope.id] --[[@as TRB.Classes.Healer.SymbolOfHope]]
					symbolOfHope.buff:Initialize(entry.type, nil, castByToken)
				elseif settings.passiveGeneration.innervate and entry.spellId == spells.innervate.id then
					local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
					innervate.buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						snapshotData.audio.innervateCue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.innervateCue = false
					end
				elseif settings.passiveGeneration.manaTideTotem and entry.spellId == spells.manaTideTotem.id then
					local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
					manaTideTotem.buff:Initialize(entry.type)
				elseif entry.spellId == spells.potionOfChilledClarity.id then
					local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					potionOfChilledClarity.buff:Initialize(entry.type)
				elseif entry.spellId == spells.moltenRadiance.id then
					local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
					moltenRadiance.buff:Initialize(entry.type)
				elseif settings.passiveGeneration.blessingOfWinter and entry.spellId == spells.blessingOfWinter.id then
					local blessingOfWinter = snapshotData.snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
					blessingOfWinter.buff:Initialize(entry.type)
				elseif entry.spellId == spells.vivaciousVivification.id then
					snapshots[entry.spellId].buff:Initialize(entry.type, true)
				end
			end
		end

		if entry.sourceGuid == TRB.Data.character.guid then
			if specId == 2 and TRB.Data.barConstructedForSpec == "mistweaver" then
				if entry.spellId == spells.potionOfFrozenFocusRank1.spellId or entry.spellId == spells.potionOfFrozenFocusRank2.spellId or entry.spellId == spells.potionOfFrozenFocusRank3.spellId then
					local channeledManaPotion = snapshots[spells.potionOfFrozenFocusRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
					channeledManaPotion.buff:Initialize(entry.type)
				elseif entry.spellId == spells.soulfangInfusion.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" then -- Gain Soulfang Infusion
						snapshots[entry.spellId].buff:SetTickData(true, CalculateManaGain(TRB.Data.character.maxResource * spells.soulfangInfusion.resourcePerTick, false), spells.soulfangInfusion.tickRate)
						snapshots[entry.spellId].buff:UpdateTicks(currentTime)
					end
				elseif entry.spellId == spells.manaTea.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				end
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "windwalker" then --Windwalker
				if entry.spellId == spells.strikeOfTheWindlord.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].buff:Initialize(entry.type)
					end
				elseif entry.spellId == spells.serenity.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
				elseif entry.spellId == spells.danceOfChiJi.id then
					snapshots[entry.spellId].buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
						if TRB.Data.settings.monk.windwalker.audio.danceOfChiJi.enabled and not snapshotData.audio.playedDanceOfChiJiCue then
							snapshotData.audio.playedDanceOfChiJiCue = true
							PlaySoundFile(TRB.Data.settings.monk.windwalker.audio.danceOfChiJi.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					elseif entry.type == "SPELL_AURA_REMOVED" then
						snapshotData.audio.playedDanceOfChiJiCue = false
					end
				elseif entry.spellId == spells.markOfTheCrane.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then
							ApplyMarkOfTheCrane(entry.destinationGuid)
							triggerUpdate = true
						elseif entry.type == "SPELL_AURA_REMOVED" then
							triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
						end
					end
				elseif entry.spellId == spells.tigerPalm.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						if entry.type == "SPELL_DAMAGE" then
							ApplyMarkOfTheCrane(entry.destinationGuid)
							triggerUpdate = true
						end
					end
				elseif entry.spellId == spells.blackoutKick.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						if entry.type == "SPELL_DAMAGE" then
							ApplyMarkOfTheCrane(entry.destinationGuid)
							triggerUpdate = true
						end
					end
				elseif entry.spellId == spells.risingSunKick.id then
					if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
						if entry.type == "SPELL_DAMAGE" then
							ApplyMarkOfTheCrane(entry.destinationGuid)
							triggerUpdate = true
						end
					end
				elseif entry.spellId == spells.detox.id then
					if entry.type == "SPELL_DISPEL" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.expelHarm.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()
					end
				elseif entry.spellId == spells.paralysis.id then
					if entry.type == "SPELL_CAST_SUCCESS" then
						snapshots[entry.spellId].cooldown:Initialize()

						if talents:IsTalentActive(spells.paralysisRank2) then
							snapshots[entry.spellId].cooldown.duration = snapshots[entry.spellId].cooldown.duration + spells.paralysisRank2.attributes.cooldownMod
						end
					end
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
	elseif specId == 2 then
		specCache.mistweaver.talents:GetTalents()
		FillSpellData_Mistweaver()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.mistweaver)
		
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Mistweaver
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.monk.mistweaver)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.mistweaver)

		if TRB.Data.barConstructedForSpec ~= "mistweaver" then
			talents = specCache.mistweaver.talents
			TRB.Data.barConstructedForSpec = "mistweaver"
			ConstructResourceBar(specCache.mistweaver.settings)
		end
	elseif specId == 3 then
		specCache.windwalker.talents:GetTalents()
		FillSpellData_Windwalker()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.windwalker)
		
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.markOfTheCrane, nil, nil, nil, true)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Windwalker
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.monk.windwalker)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.windwalker)

		if TRB.Data.barConstructedForSpec ~= "windwalker" then
			talents = specCache.windwalker.talents
			TRB.Data.barConstructedForSpec = "windwalker"
			ConstructResourceBar(specCache.windwalker.settings)
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
	if classIndexId == 10 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Options:PortForwardSettings()

					local settings = TRB.Options.Monk.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.monk == nil or
						TwintopInsanityBarSettings.monk.mistweaver == nil or
						TwintopInsanityBarSettings.monk.mistweaver.displayText == nil then
						settings.monk.mistweaver.displayText.barText = TRB.Options.Monk.MistweaverLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.monk == nil or
						TwintopInsanityBarSettings.monk.windwalker == nil or
						TwintopInsanityBarSettings.monk.windwalker.displayText == nil then
						settings.monk.windwalker.displayText.barText = TRB.Options.Monk.WindwalkerLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Monk.LoadDefaultSettings(true)
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
						TRB.Data.settings.monk.windwalker = TRB.Functions.LibSharedMedia:ValidateLsmValues("Windwalker Monk", TRB.Data.settings.monk.windwalker)
						TRB.Data.settings.monk.mistweaver = TRB.Functions.LibSharedMedia:ValidateLsmValues("Mistweaver Monk", TRB.Data.settings.monk.mistweaver)
						FillSpellData_Windwalker()
						FillSpellData_Mistweaver()

						SwitchSpec()
						TRB.Options.Monk.ConstructOptionsPanel(specCache)
						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end
						TRB.Functions.Class:EventRegistration()
						TRB.Functions.News:Init()
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
	TRB.Data.character.className = "monk"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	local maxComboPoints = 0
	local settings = nil
	
	if specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		TRB.Data.character.specName = "mistweaver"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)

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
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
---@diagnostic disable-next-line: missing-parameter, missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
---@diagnostic disable-next-line: missing-parameter, missing-parameter
		maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
		settings = TRB.Data.settings.monk.windwalker
		TRB.Data.character.specName = "windwalker"
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
	if specId == 2 and TRB.Data.settings.core.enabled.monk.mistweaver then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.mistweaver)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
	elseif specId == 3 and TRB.Data.settings.core.enabled.monk.windwalker then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.monk.windwalker)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Chi
		TRB.Data.resource2Factor = 1
	else
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
	else
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
	local specId = GetSpecialization()
	local affectingCombat = UnitAffectingCombat("player")
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if specId == 2 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.monk.mistweaver.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.monk.mistweaver.displayBar.alwaysShow) and (
					(not TRB.Data.settings.monk.mistweaver.displayBar.notZeroShow) or
					(TRB.Data.settings.monk.mistweaver.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.monk.mistweaver.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	elseif specId == 3 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.monk.windwalker.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.monk.windwalker.displayBar.alwaysShow) and (
					(not TRB.Data.settings.monk.windwalker.displayBar.notZeroShow) or
					(TRB.Data.settings.monk.windwalker.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.monk.windwalker.displayBar.neverShow == true then
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

	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	local targets = targetData.targets

	if guid ~= nil and guid ~= "" then
		if not targetData:CheckTargetExists(guid) then
			targetData:InitializeTarget(guid)
		end
		targets[guid].lastUpdate = currentTime
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
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spells
	local settings = nil
	if specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		settings = TRB.Data.settings.monk.mistweaver
	elseif specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		settings = TRB.Data.settings.monk.windwalker
	else
		return false
	end

	if specId == 2 then --Mistweaver
		if var == "$resource" or var == "$mana" then
			valid = true
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			valid = true
		elseif var == "$resourceTotal" or var == "$manaTotal" then
			valid = true
		elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
			valid = true
		elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
			valid = true
		elseif var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
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
		elseif var == "$siMana" then
			if snapshots[spells.soulfangInfusion.id].buff.isActive then
				valid = true
			end
		elseif var == "$siTicks" then
			if snapshots[spells.soulfangInfusion.id].buff.isActive then
				valid = true
			end
		elseif var == "$siTime" then
			if snapshots[spells.soulfangInfusion.id].buff.isActive then
				valid = true
			end
		end
	elseif specId == 3 then --Windwalker
		if var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$passive" then
			if snapshotData.attributes.resource < TRB.Data.character.maxResource and
				settings.generation.enabled and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$serenityTime" then
			if snapshots[spells.serenity.id].buff.isActive then
				valid = true
			end
		elseif var == "$danceOfChiJiTime" then
			if snapshots[spells.serenity.id].buff.isActive then
				valid = true
			end
		elseif var == "$motcCount" then
			if snapshots[spells.markOfTheCrane.id].attributes.count > 0 then
				valid = true
			end
		elseif var == "$motcActiveCount" then
			if snapshots[spells.markOfTheCrane.id].attributes.activeCount > 0 then
				valid = true
			end
		elseif var == "$motcMinTime" then
			if snapshots[spells.markOfTheCrane.id].attributes.minEndTime ~= nil then
				valid = true
			end
		elseif var == "$motcMaxTime" then
			if snapshots[spells.markOfTheCrane.id].attributes.maxEndTime ~= nil then
				valid = true
			end
		elseif var == "$motcTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				target ~= nil and
				target.spells[spells.markOfTheCrane.id] ~= nil and
				target.spells[spells.markOfTheCrane.id].remainingTime > 0 then
				valid = true
			end
		elseif var == "$resource" or var == "$energy" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$energyTotal" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$energyOvercap" or var == "$resourceOvercap" then
			local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$regen" or var == "$regenEnergy" or var == "$resourceRegen" or var == "$energyRegen" then
			if settings.generation.enabled and
				snapshotData.attributes.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$comboPoints" or var == "$chi" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$chiMax" then
			valid = true
		end
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local specId = GetSpecialization()	
	return nil
end

--HACK to fix FPS
local updateRateLimit = 0

function TRB.Functions.Class:TriggerResourceBarUpdates()
	local specId = GetSpecialization()
	if specId ~= 2 and specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	local currentTime = GetTime()

	if updateRateLimit + 0.05 < currentTime then
		updateRateLimit = currentTime
		UpdateResourceBar()
	end
end