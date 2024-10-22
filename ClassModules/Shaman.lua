local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 7 then --Only do this if we're on a Shaman!
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
local timerFrame = TRB.Frames.timerFrame
local combatFrame = TRB.Frames.combatFrame

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}
TRB.Data.character = {}

local specCache = {
	elemental = TRB.Classes.SpecCache:New(),
	enhancement = TRB.Classes.SpecCache:New(),
	restoration = TRB.Classes.SpecCache:New()
}

local function CalculateManaGain(mana, isPotion)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
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
	-- Elemental
	Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0
		},
		dots = {
			fsCount = 0
		},
		chainLightning = {
			targetsHit = 0
		}
	}
	
	specCache.elemental.character = {
		guid = UnitGUID("player"),
		maxResource = 100,
		earthShockThreshold = 60,
		earthquakeThreshold = 60,
		effects = {
		},
		items = {
		}
	}
	
	---@type TRB.Classes.Shaman.ElementalSpells
	specCache.elemental.spellsData.spells = TRB.Classes.Shaman.ElementalSpells:New()
	local spells = specCache.elemental.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
	
	specCache.elemental.snapshotData.audio = {
		playedEsCue = false
	}
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.chainLightning.id] = TRB.Classes.Snapshot:New(spells.chainLightning, {
		targetsHit = 0,
		hitTime = nil,
		hasStruckTargets = false
	})
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.surgeOfPower.id] = TRB.Classes.Snapshot:New(spells.surgeOfPower, nil, true)
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.powerOfTheMaelstrom.id] = TRB.Classes.Snapshot:New(spells.powerOfTheMaelstrom, nil, true)
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.icefury.id] = TRB.Classes.Snapshot:New(spells.icefury, {
		resource = 0
	})
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.stormkeeper.id] = TRB.Classes.Snapshot:New(spells.stormkeeper)
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.echoesOfGreatSundering.id] = TRB.Classes.Snapshot:New(spells.echoesOfGreatSundering)
	---@type TRB.Classes.Snapshot
	specCache.elemental.snapshotData.snapshots[spells.primalFracture.id] = TRB.Classes.Snapshot:New(spells.primalFracture)


	-- Enhancement
	specCache.enhancement.Global_TwintopResourceBar = {
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

	specCache.enhancement.character = {
		guid = UnitGUID("player"),
	---@diagnostic disable-next-line: missing-parameter
		specId = 1,
		maxResource = 10000,
		maxResource2 = 10,
		effects = {
		},
		items = {}
	}

	---@type TRB.Classes.Shaman.EnhancementSpells
	specCache.enhancement.spellsData.spells = TRB.Classes.Shaman.EnhancementSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.enhancement.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]

	specCache.enhancement.snapshotData.attributes.manaRegen = 0
	specCache.enhancement.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.enhancement.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)

	specCache.enhancement.barTextVariables = {
		icons = {},
		values = {}
	}

	
	-- Restoration
	specCache.restoration.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0
		},
		dots = {
			--swpCount = 0
		},
	}

	specCache.restoration.character = {
		guid = UnitGUID("player"),
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

	---@type TRB.Classes.Shaman.RestorationSpells
	specCache.restoration.spellsData.spells = TRB.Classes.Shaman.RestorationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.restoration.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]

	specCache.restoration.snapshotData.attributes.manaRegen = 0
	specCache.restoration.snapshotData.audio = {
		innervateCue = false
	}
	---@type TRB.Classes.Healer.Innervate
	specCache.restoration.snapshotData.snapshots[spells.innervate.id] = TRB.Classes.Healer.Innervate:New(spells.innervate)
	---@type TRB.Classes.Healer.PotionOfChilledClarity
	specCache.restoration.snapshotData.snapshots[spells.potionOfChilledClarity.id] = TRB.Classes.Healer.PotionOfChilledClarity:New(spells.potionOfChilledClarity)
	---@type TRB.Classes.Healer.ManaTideTotem
	specCache.restoration.snapshotData.snapshots[spells.manaTideTotem.id] = TRB.Classes.Healer.ManaTideTotem:New(spells.manaTideTotem)
	---@type TRB.Classes.Healer.SymbolOfHope
	specCache.restoration.snapshotData.snapshots[spells.symbolOfHope.id] = TRB.Classes.Healer.SymbolOfHope:New(spells.symbolOfHope, CalculateManaGain)
	---@type TRB.Classes.Healer.ChanneledManaPotion
	specCache.restoration.snapshotData.snapshots[spells.slumberingSoulSerumRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.slumberingSoulSerumRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.algariManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.algariManaPotionRank1)
	---@type TRB.Classes.Healer.MoltenRadiance
	specCache.restoration.snapshotData.snapshots[spells.moltenRadiance.id] = TRB.Classes.Healer.MoltenRadiance:New(spells.moltenRadiance)
	---@type TRB.Classes.Healer.BlessingOfWinter
	specCache.restoration.snapshotData.snapshots[spells.blessingOfWinter.id] = TRB.Classes.Healer.BlessingOfWinter:New(spells.blessingOfWinter)
	---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)

	specCache.restoration.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Elemental()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "elemental")
end

local function Setup_Enhancement()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "enhancement")
end

local function Setup_Restoration()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "restoration")
end

local function FillSpellData_Elemental()
	Setup_Elemental()
	---@type TRB.Classes.SpellsData
	specCache.elemental.spellsData:FillSpellData()
	local spells = specCache.elemental.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.elemental.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },

		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
		{ variable = "#chainLightning", icon = spells.chainLightning.icon, description = spells.chainLightning.name, printInSettings = true },
		{ variable = "#elementalBlast", icon = spells.elementalBlast.icon, description = spells.elementalBlast.name, printInSettings = true },
		{ variable = "#eogs", icon = spells.echoesOfGreatSundering.icon, description = spells.echoesOfGreatSundering.name, printInSettings = true },
		{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
		{ variable = "#frostShock", icon = spells.frostShock.icon, description = spells.frostShock.name, printInSettings = true },
		{ variable = "#icefury", icon = spells.icefury.icon, description = spells.icefury.name, printInSettings = true },
		{ variable = "#lavaBurst", icon = spells.lavaBurst.icon, description = spells.lavaBurst.name, printInSettings = true },
		{ variable = "#lightningBolt", icon = spells.lightningBolt.icon, description = spells.lightningBolt.name, printInSettings = true },
		{ variable = "#primalFracture", icon = spells.primalFracture.icon, description = spells.primalFracture.name, printInSettings = true },
		{ variable = "#stormkeeper", icon = spells.stormkeeper.icon, description = spells.stormkeeper.name, printInSettings = true },
		{ variable = "#tempest", icon = spells.tempest.icon, description = spells.tempest.name, printInSettings = true },
	}
	specCache.elemental.barTextVariables.values = {
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

		{ variable = "$maelstrom", description = L["ShamanElementalBarTextVariable_maelstrom"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromMax", description = L["ShamanElementalBarTextVariable_maelstromMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["ShamanElementalBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["ShamanElementalBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$maelstromPlusCasting", description = L["ShamanElementalBarTextVariable_maelstromPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromPlusPassive", description = L["ShamanElementalBarTextVariable_maelstromPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromTotal", description = L["ShamanElementalBarTextVariable_maelstromTotal"], printInSettings = true, color = false },   
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },   

		{ variable = "$fsCount", description = L["ShamanElementalBarTextVariable_fsCount"], printInSettings = true, color = false },
		{ variable = "$fsTime", description = L["ShamanElementalBarTextVariable_fsTime"], printInSettings = true, color = false },

		{ variable = "$ifStacks", description = L["ShamanElementalBarTextVariable_ifStacks"], printInSettings = true, color = false },
		{ variable = "$ifMaelstrom", description = L["ShamanElementalBarTextVariable_ifMaelstrom"], printInSettings = true, color = false },
		{ variable = "$ifTime", description = L["ShamanElementalBarTextVariable_ifTime"], printInSettings = true, color = false },

		{ variable = "$skStacks", description = L["ShamanElementalBarTextVariable_skStacks"], printInSettings = true, color = false },
		{ variable = "$skTime", description = L["ShamanElementalBarTextVariable_skTime"], printInSettings = true, color = false },

		{ variable = "$ascendanceTime", description = L["ShamanElementalBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		{ variable = "$eogsTime", description = L["ShamanElementalBarTextVariable_eogsTime"], printInSettings = true, color = false },

		{ variable = "$pfTime", description = L["ShamanElementalBarTextVariable_pfTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function FillSpellData_Enhancement()
	Setup_Enhancement()
	---@type TRB.Classes.SpellsData
	specCache.enhancement.spellsData:FillSpellData()
	local spells = specCache.enhancement.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.enhancement.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		
		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
		{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
	}
	specCache.enhancement.barTextVariables.values = {
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

		{ variable = "$mana", description = L["ShamanEnhancementBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["ShamanEnhancementBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$maelstromWeapon", description = L["ShamanEnhancementBarTextVariable_maelstromWeapon"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromWeaponMax", description = L["ShamanEnhancementBarTextVariable_maelstromWeaponMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$ascendanceTime", description = L["ShamanEnhancementBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		{ variable = "$fsCount", description = L["ShamanEnhancementBarTextVariable_fsCount"], printInSettings = true, color = false },
		{ variable = "$fsTime", description = L["ShamanEnhancementBarTextVariable_fsTime"], printInSettings = true, color = false },
		
		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function FillSpellData_Restoration()
	Setup_Restoration()
	---@type TRB.Classes.SpellsData
	specCache.restoration.spellsData:FillSpellData()
	local spells = specCache.restoration.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.restoration.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
		
		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
		{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
		{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

		{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
		{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },
		
		{ variable = "#bow", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = true },
		{ variable = "#blessingOfWinter", icon = spells.blessingOfWinter.icon, description = spells.blessingOfWinter.name, printInSettings = false },

		{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
		{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

		{ variable = "#amp", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = true },
		{ variable = "#algariManaPotion", icon = spells.algariManaPotionRank1.icon, description = spells.algariManaPotionRank1.name, printInSettings = false },
		{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
		{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
		{ variable = "#poff", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = true },
		{ variable = "#slumberingSoulSerum", icon = spells.slumberingSoulSerumRank1.icon, description = spells.slumberingSoulSerumRank1.name, printInSettings = false },
		{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
	}
	specCache.restoration.barTextVariables.values = {
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

		{ variable = "$mana", description = L["ShamanRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["ShamanRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["ShamanRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["ShamanRestorationBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$passive", description = L["ShamanRestorationBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["ShamanRestorationBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["ShamanRestorationBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["ShamanRestorationBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		
		{ variable = "$bowMana", description = L["ShamanRestorationBarTextVariable_bowMana"], printInSettings = true, color = false },
		{ variable = "$bowTime", description = L["ShamanRestorationBarTextVariable_bowTime"], printInSettings = true, color = false },
		{ variable = "$bowTicks", description = L["ShamanRestorationBarTextVariable_bowTicks"], printInSettings = true, color = false },

		{ variable = "$sohMana", description = L["ShamanRestorationBarTextVariable_sohMana"], printInSettings = true, color = false },
		{ variable = "$sohTime", description = L["ShamanRestorationBarTextVariable_sohTime"], printInSettings = true, color = false },
		{ variable = "$sohTicks", description = L["ShamanRestorationBarTextVariable_sohTicks"], printInSettings = true, color = false },

		{ variable = "$innervateMana", description = L["ShamanRestorationBarTextVariable_innervateMana"], printInSettings = true, color = false },
		{ variable = "$innervateTime", description = L["ShamanRestorationBarTextVariable_innervateTime"], printInSettings = true, color = false },
								
		{ variable = "$mrMana", description = L["ShamanRestorationBarTextVariable_mrMana"], printInSettings = true, color = false },
		{ variable = "$mrTime", description = L["ShamanRestorationBarTextVariable_mrTime"], printInSettings = true, color = false },

		{ variable = "$mttMana", description = L["ShamanRestorationBarTextVariable_mttMana"], printInSettings = true, color = false },
		{ variable = "$mttTime", description = L["ShamanRestorationBarTextVariable_mttTime"], printInSettings = true, color = false },
		
		{ variable = "$channeledMana", description = L["ShamanRestorationBarTextVariable_channeledMana"], printInSettings = true, color = false },

		{ variable = "$potionOfChilledClarityMana", description = L["ShamanRestorationBarTextVariable_potionOfChilledClarityMana"], printInSettings = true, color = false },
		{ variable = "$potionOfChilledClarityTime", description = L["ShamanRestorationBarTextVariable_potionOfChilledClarityTime"], printInSettings = true, color = false },

		{ variable = "$slumberingSoulSerumTicks", description = L["ShamanRestorationBarTextVariable_slumberingSoulSerumTicks"], printInSettings = true, color = false },
		{ variable = "$slumberingSoulSerumTime", description = L["ShamanRestorationBarTextVariable_slumberingSoulSerumTime"], printInSettings = true, color = false },
		
		{ variable = "$potionCooldown", description = L["ShamanRestorationBarTextVariable_potionCooldown"], printInSettings = true, color = false },
		{ variable = "$potionCooldownSeconds", description = L["ShamanRestorationBarTextVariable_potionCooldownSeconds"], printInSettings = true, color = false },

		{ variable = "$fsCount", description = L["ShamanRestorationBarTextVariable_fsCount"], printInSettings = true, color = false },
		{ variable = "$fsTime", description = L["ShamanRestorationBarTextVariable_fsTime"], printInSettings = true, color = false },
		
		{ variable = "$ascendanceTime", description = L["ShamanRestorationBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:UpdateTrackedSpells(currentTime)
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
	
	local entriesPassive = TRB.Functions.Table:Length(passiveFrame.thresholds)
	if entriesPassive > 0 then
		for x = 1, entriesPassive do
			passiveFrame.thresholds[x]:Hide()
		end
	end

	if specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		local thresholdId = 1
		for _, v in pairs(spells) do
			local spell = v --[[@as TRB.Classes.SpellBase]]
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
				spell = spell --[[@as TRB.Classes.SpellThreshold]]
				if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
				TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[thresholdId], spell, settings)

				TRB.Frames.resourceFrame.thresholds[thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[thresholdId]:Hide()

				thresholdId = thresholdId + 1
			end
		end
		TRB.Frames.resource2ContainerFrame:Hide()
	elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		local thresholdId = 1
		for _, v in pairs(spells) do
			local spell = v --[[@as TRB.Classes.SpellBase]]
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
				spell = spell --[[@as TRB.Classes.SpellThreshold]]
				if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
				TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[thresholdId], spell, settings)

				TRB.Frames.resourceFrame.thresholds[thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[thresholdId]:Hide()

				thresholdId = thresholdId + 1
			end
		end
		TRB.Frames.resource2ContainerFrame:Show()
	elseif specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		local thresholdId = 1
		for _, v in pairs(spells) do
			local spell = v --[[@as TRB.Classes.SpellBase]]
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
				spell = spell --[[@as TRB.Classes.SpellThreshold]]
				if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
				TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[thresholdId], spell, settings)

				TRB.Frames.resourceFrame.thresholds[thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[thresholdId]:Hide()

				thresholdId = thresholdId + 1
			end
		end

		for x = 1, 7 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end

			TRB.Frames.passiveFrame.thresholds[x]:Show()
			TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
			TRB.Frames.passiveFrame.thresholds[x]:Hide()
		end
		TRB.Frames.resource2ContainerFrame:Hide()
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)

	if specId == 1 or
	(specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement) or
	specId == 3 then
		TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
	end
end

local function RefreshLookupData_Elemental()
	local specSettings = TRB.Data.settings.shaman.elemental
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()

	--$overcap
	local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentMaelstromColor = specSettings.colors.text.current
	local castingMaelstromColor = specSettings.colors.text.casting

	local maelstromThreshold = TRB.Data.character.maxResource

	if talents:IsTalentActive(spells.earthquake) then
		maelstromThreshold = math.min(maelstromThreshold, spells.earthquake:GetPrimaryResourceCost())
	end
	
	if talents:IsTalentActive(spells.earthShock) and not talents:IsTalentActive(spells.elementalBlast) then
		maelstromThreshold = math.min(maelstromThreshold, spells.earthShock:GetPrimaryResourceCost())
	elseif talents:IsTalentActive(spells.elementalBlast) then
		maelstromThreshold = math.min(maelstromThreshold, spells.elementalBlast:GetPrimaryResourceCost())
	end

	if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
		if specSettings.colors.text.overcapEnabled and overcap then
			currentMaelstromColor = specSettings.colors.text.overcap
			castingMaelstromColor = specSettings.colors.text.overcap
		elseif specSettings.colors.text.overThresholdEnabled and snapshotData.attributes.resource >= maelstromThreshold then
			currentMaelstromColor = specSettings.colors.text.overThreshold
			castingMaelstromColor = specSettings.colors.text.overThreshold
		end
	end

	--$maelstrom
	local currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, snapshotData.attributes.resource)
	--$casting
	local castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, snapshotData.casting.resourceFinal)
	--$passive
	local _passiveMaelstrom = 0

	local passiveMaelstrom = string.format("|c%s%.0f|r", specSettings.colors.text.passive, _passiveMaelstrom)
	--$maelstromTotal
	local _maelstromTotal = math.min(_passiveMaelstrom + snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local maelstromTotal = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromTotal)
	--$maelstromPlusCasting
	local _maelstromPlusCasting = math.min(snapshotData.casting.resourceFinal + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local maelstromPlusCasting = string.format("|c%s%.0f|r", castingMaelstromColor, _maelstromPlusCasting)
	--$maelstromPlusPassive
	local _maelstromPlusPassive = math.min(_passiveMaelstrom + snapshotData.attributes.resource, TRB.Data.character.maxResource)
	local maelstromPlusPassive = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromPlusPassive)

	----------
	--$fsCount and $fsTime
	local _flameShockCount = targetData.count[spells.flameShock.id] or 0
	local flameShockCount = string.format("%s", _flameShockCount)
	local _flameShockTime = 0
	
	if target ~= nil then
		_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
	end

	local flameShockTime

	if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.flameShock.id].active then
			if _flameShockTime > spells.flameShock.pandemicTime then
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			else
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			end
		else
			flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _flameShockCount)
			flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
	end

	----------
	--Icefury
	--$ifMaelstrom
	local icefuryMaelstrom = snapshots[spells.icefury.id].attributes.resource or 0
	--$ifStacks
	local icefuryStacks = snapshots[spells.icefury.id].buff.applications or 0
	--$ifStacks
	local _icefuryTime = snapshots[spells.icefury.id].buff:GetRemainingTime(currentTime)
	local icefuryTime = TRB.Functions.BarText:TimerPrecision(_icefuryTime)

	--$skStacks
	local stormkeeperStacks = snapshots[spells.stormkeeper.id].buff.applications or 0
	--$skStacks
	local _stormkeeperTime = snapshots[spells.stormkeeper.id].buff:GetRemainingTime(currentTime)
	local stormkeeperTime = TRB.Functions.BarText:TimerPrecision(_stormkeeperTime)

	--$eogsTime
	local _eogsTime = snapshots[spells.echoesOfGreatSundering.id].buff:GetRemainingTime(currentTime)
	local eogsTime = TRB.Functions.BarText:TimerPrecision(_eogsTime)

	--$pfTime
	local _pfTime = snapshots[spells.primalFracture.id].buff:GetRemainingTime(currentTime)
	local pfTime = TRB.Functions.BarText:TimerPrecision(_pfTime)

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	----------------------------

	Global_TwintopResourceBar.resource.passive = _passiveMaelstrom
	Global_TwintopResourceBar.resource.icefury = icefuryMaelstrom

	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.fsCount = flameShockCount or 0

	Global_TwintopResourceBar.chainLightning = Global_TwintopResourceBar.chainLightning or {}
	Global_TwintopResourceBar.chainLightning.targetsHit = snapshots[spells.chainLightning.id].attributes.targetsHit or 0

	Global_TwintopResourceBar.icefury = Global_TwintopResourceBar.icefury or {}
	Global_TwintopResourceBar.icefury.maelstrom = icefuryMaelstrom
	Global_TwintopResourceBar.icefury.stacks = icefuryStacks
	Global_TwintopResourceBar.icefury.remaining = icefuryTime

	local lookup = TRB.Data.lookup or {}
	lookup["#ascendance"] = spells.ascendance.icon
	lookup["#chainLightning"] = spells.chainLightning.icon
	lookup["#elementalBlast"] = spells.elementalBlast.icon
	lookup["#eogs"] = spells.echoesOfGreatSundering.icon
	lookup["#flameShock"] = spells.flameShock.icon
	lookup["#frostShock"] = spells.frostShock.icon
	lookup["#icefury"] = spells.icefury.icon
	lookup["#lavaBurst"] = spells.lavaBurst.icon
	lookup["#lightningBolt"] = spells.lightningBolt.icon
	lookup["#primalFracture"] = spells.primalFracture.icon
	lookup["#stormkeeper"] = spells.stormkeeper.icon
	lookup["#tempest"] = spells.stormkeeper.icon
	lookup["$maelstromPlusCasting"] = maelstromPlusCasting
	lookup["$maelstromPlusPassive"] = maelstromPlusPassive
	lookup["$maelstromTotal"] = maelstromTotal
	lookup["$maelstromMax"] = TRB.Data.character.maxResource
	lookup["$maelstrom"] = currentMaelstrom
	lookup["$resourcePlusCasting"] = maelstromPlusCasting
	lookup["$resourcePlusPassive"] = maelstromPlusPassive
	lookup["$resourceTotal"] = maelstromTotal
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentMaelstrom
	lookup["$casting"] = castingMaelstrom
	lookup["$passive"] = passiveMaelstrom
	lookup["$overcap"] = overcap
	lookup["$resourceOvercap"] = overcap
	lookup["$maelstromOvercap"] = overcap
	lookup["$ifMaelstrom"] = icefuryMaelstrom
	lookup["$ifStacks"] = icefuryStacks
	lookup["$ifTime"] = icefuryTime
	lookup["$skStacks"] = stormkeeperStacks
	lookup["$skTime"] = stormkeeperTime
	lookup["$eogsTime"] = eogsTime
	lookup["$fsCount"] = flameShockCount
	lookup["$fsTime"] = flameShockTime
	lookup["$ascendanceTime"] = ascendanceTime
	lookup["$pfTime"] = pfTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$maelstromPlusCasting"] = _maelstromPlusCasting
	lookupLogic["$maelstromPlusPassive"] = _maelstromPlusPassive
	lookupLogic["$maelstromTotal"] = _maelstromTotal
	lookupLogic["$maelstromMax"] = TRB.Data.character.maxResource
	lookupLogic["$maelstrom"] = snapshotData.attributes.resource
	lookupLogic["$resourcePlusCasting"] = _maelstromPlusCasting
	lookupLogic["$resourcePlusPassive"] = _maelstromPlusPassive
	lookupLogic["$resourceTotal"] = _maelstromTotal
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$passive"] = _passiveMaelstrom
	lookupLogic["$overcap"] = overcap
	lookupLogic["$resourceOvercap"] = overcap
	lookupLogic["$maelstromOvercap"] = overcap
	lookupLogic["$ifMaelstrom"] = icefuryMaelstrom
	lookupLogic["$ifStacks"] = icefuryStacks
	lookupLogic["$ifTime"] = icefuryTime
	lookupLogic["$skStacks"] = stormkeeperStacks
	lookupLogic["$skTime"] = _stormkeeperTime
	lookupLogic["$eogsTime"] = _eogsTime
	lookupLogic["$fsCount"] = _flameShockCount
	lookupLogic["$fsTime"] = _flameShockTime
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	lookupLogic["$pfTime"] = _pfTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Enhancement()
	local specSettings = TRB.Data.settings.shaman.enhancement
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	--Spec specific implementation
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	local currentManaColor = specSettings.colors.text.current
	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))

	----------
	--$fsCount and $fsTime
	local _flameShockCount = targetData.count[spells.flameShock.id] or 0
	local flameShockCount = string.format("%s", _flameShockCount)
	local _flameShockTime = 0
	
	if target ~= nil then
		_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
	end

	local flameShockTime

	if specSettings.colors.text.dots.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.flameShock.id].active then
			if _flameShockTime > spells.flameShock.pandemicTime then
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			else
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			end
		else
			flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _flameShockCount)
			flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
	end

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	----------------------------	
	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.fsCount = flameShockCount or 0

	local lookup = TRB.Data.lookup or {}
	lookup["#ascendance"] = spells.ascendance.icon
	lookup["#flameShock"] = spells.flameShock.icon
	lookup["$manaMax"] = TRB.Data.character.maxResource
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$resource"] = currentMana
	lookup["$maelstromWeapon"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$maelstromWeaponMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$ascendanceTime"] = ascendanceTime
	lookup["$fsCount"] = flameShockCount
	lookup["$fsTime"] = flameShockTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$maelstromWeapon"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$maelstromWeaponMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	lookupLogic["$fsCount"] = _flameShockCount
	lookupLogic["$fsTime"] = _flameShockTime
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Restoration()
	local specSettings = TRB.Data.settings.shaman.restoration
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resource / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
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
	--$fsCount and $fsTime
	local _flameShockCount = snapshotData.targetData.count[spells.flameShock.id] or 0
	local flameShockCount = string.format("%s", _flameShockCount)
	local _flameShockTime = 0
	
	if target ~= nil then
		_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
	end

	local flameShockTime

	if specSettings.colors.text.dots.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.flameShock.id].active then
			if _flameShockTime > spells.flameShock.pandemicTime then
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.up, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.up, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			else
				flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.pandemic, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.pandemic, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			end
		else
			flameShockCount = string.format("|c%s%.0f|r", specSettings.colors.text.dots.down, _flameShockCount)
			flameShockTime = string.format("|c%s%s|r", specSettings.colors.text.dots.down, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
	end

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	Global_TwintopResourceBar.resource.passive = _passiveMana
	Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
	Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
	Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
	Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
	Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
	
	Global_TwintopResourceBar.potionOfSpiritualClarity = Global_TwintopResourceBar.potionOfSpiritualClarity or {}
	Global_TwintopResourceBar.potionOfSpiritualClarity.mana = _channeledMana
	Global_TwintopResourceBar.potionOfSpiritualClarity.ticks = _slumberingSoulSerumTicks or 0
	
	Global_TwintopResourceBar.symbolOfHope = Global_TwintopResourceBar.symbolOfHope or {}
	Global_TwintopResourceBar.symbolOfHope.mana = _sohMana
	Global_TwintopResourceBar.symbolOfHope.ticks = _sohTicks or 0
	
	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.fsCount = flameShockCount or 0

	local lookup = TRB.Data.lookup or {}
	lookup["#ascendance"] = spells.ascendance.icon
	lookup["#flameShock"] = spells.flameShock.icon
	lookup["#innervate"] = spells.innervate.icon
	lookup["#mtt"] = spells.manaTideTotem.icon
	lookup["#manaTideTotem"] = spells.manaTideTotem.icon
	lookup["#blessingOfWinter"] = spells.blessingOfWinter.icon
	lookup["#bow"] = spells.blessingOfWinter.icon
	lookup["#mr"] = spells.moltenRadiance.icon
	lookup["#moltenRadiance"] = spells.moltenRadiance.icon
	lookup["#soh"] = spells.symbolOfHope.icon
	lookup["#symbolOfHope"] = spells.symbolOfHope.icon
	lookup["#slumberingSoulSerum"] = spells.slumberingSoulSerumRank1.icon
	lookup["#amp"] = spells.algariManaPotionRank1.icon
	lookup["#algariManaPotion"] = spells.algariManaPotionRank1.icon
	lookup["#pocc"] = spells.potionOfChilledClarity.icon
	lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
	lookup["#poff"] = spells.slumberingSoulSerumRank1.icon
	lookup["#slumberingSoulSerum"] = spells.slumberingSoulSerumRank1.icon
	lookup["$fsCount"] = flameShockCount
	lookup["$fsTime"] = flameShockTime
	lookup["$manaPlusCasting"] = manaPlusCasting
	lookup["$manaPlusPassive"] = manaPlusPassive
	lookup["$manaTotal"] = manaTotal
	lookup["$manaMax"] = manaMax
	lookup["$mana"] = currentMana
	lookup["$resourcePlusCasting"] = manaPlusCasting
	lookup["$resourcePlusPassive"] = manaPlusPassive
	lookup["$resourceTotal"] = manaTotal
	lookup["$resourceMax"] = maxResource
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
	lookup["$mrMana"] = mrMana
	lookup["$mrTime"] = mrTime
	lookup["$mttMana"] = mttMana
	lookup["$mttTime"] = mttTime
	lookup["$bowMana"] = bowMana
	lookup["$bowTime"] = bowTime
	lookup["$bowTicks"] = bowTicks
	lookup["$channeledMana"] = channeledMana
	lookup["$slumberingSoulSerumTicks"] = slumberingSoulSerumTicks
	lookup["$slumberingSoulSerumTime"] = slumberingSoulSerumTime
	lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
	lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds
	lookup["$ascendanceTime"] = ascendanceTime
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaPlusCasting"] = _manaPlusCasting
	lookupLogic["$manaPlusPassive"] = _manaPlusPassive
	lookupLogic["$manaTotal"] = _manaTotal
	lookupLogic["$manaMax"] = maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
	lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
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
	lookupLogic["$mrMana"] = _mrMana
	lookupLogic["$mrTime"] = _mrTime
	lookupLogic["$bowMana"] = _bowMana
	lookupLogic["$bowTime"] = _bowTime
	lookupLogic["$bowTicks"] = _bowTicks
	lookupLogic["$mttMana"] = _mttMana
	lookupLogic["$mttTime"] = _mttTime
	lookupLogic["$channeledMana"] = _channeledMana
	lookupLogic["$slumberingSoulSerumTicks"] = _slumberingSoulSerumTicks
	lookupLogic["$slumberingSoulSerumTime"] = _slumberingSoulSerumTime
	lookupLogic["$potionCooldown"] = potionCooldown
	lookupLogic["$potionCooldownSeconds"] = potionCooldown
	lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
	lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
	lookupLogic["$fsCount"] = _flameShockCount
	lookupLogic["$fsTime"] = _flameShockTime
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	TRB.Data.lookupLogic = lookupLogic
end

local function FillSnapshotDataCasting(spell, resourceMod)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]

	resourceMod = resourceMod or 0
	local resourceMultMod = 1

	if snapshotData.snapshots[spells.primalFracture.id].buff.isActive then
		if spell.id == spells.lavaBurst.id or
			spell.id == spells.lightningBolt.id or
			spell.id == spells.icefury.id or
			spell.id == spells.frostShock.id
			then
			resourceMultMod = spells.primalFracture.attributes.resourcePercent
		end
	end

	local currentTime = GetTime()
	if spell.resource ~= nil and spell.resource > 0 then
		snapshotData.casting.resourceRaw = (spell.resource + resourceMod) * resourceMultMod
		snapshotData.casting.resourceFinal = (spell.resource + resourceMod) * resourceMultMod
	end
	snapshotData.casting.startTime = currentTime
	snapshotData.casting.spellId = spell.id
	snapshotData.casting.icon = spell.icon
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Restoration()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local innervate = snapshotData.snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
	local potionOfChilledClarity = snapshotData.snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw * innervate.modifier * potionOfChilledClarity.modifier
end

local function CastingSpell()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specId = GetSpecialization()
	local affectingCombat = UnitAffectingCombat("player")
	local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
	local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")

	if currentSpellName == nil and currentChannelName == nil then
		TRB.Functions.Character:ResetCastingSnapshotData()
		return false
	else
		if specId == 1 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
			if currentSpellName == nil then
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
				--See Priest implementation for handling channeled spells
			else
				if currentSpellId == spells.lightningBolt.id then
					FillSnapshotDataCasting(spells.lightningBolt)

					if snapshots[spells.surgeOfPower.id].buff.isActive then
						snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + ((spells.lightningBolt.overload) * 2)
						snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + ((spells.lightningBolt.overload) * 2)
					end
					
					if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive then
						snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + spells.lightningBolt.overload
						snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.lightningBolt.overload
					end
				elseif currentSpellId == spells.lavaBurst.id then
					FillSnapshotDataCasting(spells.lavaBurst)
				elseif currentSpellId == spells.elementalBlast.id then
					FillSnapshotDataCasting(spells.elementalBlast)
				elseif currentSpellId == spells.icefury.id then
					FillSnapshotDataCasting(spells.icefury)
				elseif currentSpellId == spells.chainLightning.id then
					local spell = nil
					
					spell = spells.chainLightning
					FillSnapshotDataCasting(spell)
					
					local currentTime = GetTime()
					local down, up, lagHome, lagWorld = GetNetStats()
					local latency = lagWorld / 1000

					if snapshots[spells.chainLightning.id].attributes.hitTime == nil then
						snapshots[spells.chainLightning.id].attributes.targetsHit = 1
						snapshots[spells.chainLightning.id].attributes.hitTime = currentTime
						snapshots[spells.chainLightning.id].attributes.hasStruckTargets = false
					elseif currentTime > (snapshots[spells.chainLightning.id].attributes.hitTime + (TRB.Functions.Character:GetCurrentGCDTime(true) * 4) + latency) then
						snapshots[spells.chainLightning.id].attributes.targetsHit = 1
					end

					if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive and currentSpellId == spells.chainLightning.id then
						snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + spells.chainLightning.overload
						snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.chainLightning.overload
					end

					snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw * snapshots[spells.chainLightning.id].attributes.targetsHit
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * snapshots[spells.chainLightning.id].attributes.targetsHit
				elseif currentSpellId == spells.hex.id and talents:IsTalentActive(spells.inundate) and affectingCombat then
					FillSnapshotDataCasting(spells.hex)
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			end
			return true
		elseif specId == 2 then
			--[[if currentSpellName == nil then
				return true
			else]]
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			--end
		elseif specId == 3 then
			if currentSpellName == nil then
				TRB.Functions.Character:ResetCastingSnapshotData()
				return false
			else
				local spellInfo = C_Spell.GetSpellInfo(currentSpellName) --[[@as SpellInfo]]

				if spellInfo ~= nil and spellInfo.spellID then
					local manaCost = -TRB.Classes.SpellBase.GetPrimaryResourceCost({ id = spellInfo.spellID, primaryResourceType = Enum.PowerType.Mana, primaryResourceTypeProperty = "cost", primaryResourceTypeMod = 1.0 }, true)

					snapshotData.casting.startTime = currentSpellStartTime / 1000
					snapshotData.casting.endTime = currentSpellEndTime / 1000
					snapshotData.casting.resourceRaw = manaCost
					snapshotData.casting.spellId = spellInfo.spellID
					snapshotData.casting.icon = string.format("|T%s:0|t", spellInfo.iconID)

					UpdateCastingResourceFinal_Restoration()
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
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells|TRB.Classes.Shaman.EnhancementSpells|TRB.Classes.Shaman.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local currentTime = GetTime()
	TRB.Functions.Character:UpdateSnapshot()

	snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Elemental()
	local currentTime = GetTime()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.icefury.id].buff:GetRemainingTime(currentTime)
end

local function UpdateSnapshot_Enhancement()
	UpdateSnapshot()
end

local function UpdateSnapshot_Restoration()
	UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	local currentTime = GetTime()
	
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
	local specId = GetSpecialization()
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.shaman
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if specId == 1 then
		local specSettings = classSettings.elemental
		UpdateSnapshot_Elemental()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				local passiveValue = 0

				if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end					

				if specSettings.colors.bar.primalFracture.enabled and TRB.Functions.Class:IsValidVariableForSpec("$pfTime") then
					barBorderColor = specSettings.colors.bar.primalFracture.color
				end

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				if CastingSpell() and specSettings.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
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

				local barColor = specSettings.colors.bar.base

				local pairOffset = 0
				local thresholdId = 1
				for _, v in pairs(TRB.Data.spellsData.spells) do
					local spell = v --[[@as TRB.Classes.SpellBase]]
					if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
						spell = spell --[[@as TRB.Classes.SpellThreshold]]
						pairOffset = (thresholdId - 1) * 3
						local resourceAmount = spell:GetPrimaryResourceCost()
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[thresholdId], resourceFrame, resourceAmount, TRB.Data.character.maxResource)

						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
						local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
						
						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.earthquake.id or spell.id == spells.earthquakeTargeted.id then
								if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								else
									if snapshots[spells.echoesOfGreatSundering.id].buff.isActive then
										thresholdColor = specSettings.colors.threshold.echoesOfGreatSundering
										frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
									elseif currentResource >= resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
										frameLevel = TRB.Data.constants.frameLevels.thresholdOver
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end
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
							elseif currentResource >= resourceAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						else -- This is an active/available/normal spell threshold
							if currentResource >= resourceAmount then
								thresholdColor = specSettings.colors.threshold.over
							else
								thresholdColor = specSettings.colors.threshold.under
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
							end
						end
						
						TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[thresholdId], resourceFrame, resourceAmount, TRB.Data.character.maxResource)

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshots[spell.id], specSettings)

						thresholdId = thresholdId + 1
					end
				end

				local maelstromThreshold = TRB.Data.character.maxResource

				if talents:IsTalentActive(spells.earthquake) then
					maelstromThreshold = math.min(maelstromThreshold, spells.earthquake:GetPrimaryResourceCost())
				end
				
				if talents:IsTalentActive(spells.earthShock) and not talents:IsTalentActive(spells.elementalBlast) then
					maelstromThreshold = math.min(maelstromThreshold, spells.earthShock:GetPrimaryResourceCost())
				elseif talents:IsTalentActive(spells.elementalBlast) then
					maelstromThreshold = math.min(maelstromThreshold, spells.elementalBlast:GetPrimaryResourceCost())
				end

				if currentResource >= maelstromThreshold then
					barColor = specSettings.colors.bar.earthShock
					if specSettings.colors.bar.flashEnabled then
						TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					else
						barContainerFrame:SetAlpha(1.0)
					end

					if specSettings.audio.esReady.enabled and snapshotData.audio.playedEsCue == false then
						snapshotData.audio.playedEsCue = true
						PlaySoundFile(specSettings.audio.esReady.sound, coreSettings.audio.channel.channel)
					end
				else
					barContainerFrame:SetAlpha(1.0)
					snapshotData.audio.playedEsCue = false
				end

				if snapshots[spells.ascendance.id].buff.isActive then
					local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
					local timeThreshold = 0
					local useEndOfAscendanceColor = false

					if specSettings.endOfAscendance.enabled then
						useEndOfAscendanceColor = true
						if specSettings.endOfAscendance.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
						elseif specSettings.endOfAscendance.mode == "time" then
							timeThreshold = specSettings.endOfAscendance.timeMax
						end
					end

					if useEndOfAscendanceColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.inAscendance1GCD
					else
						barColor = specSettings.colors.bar.inAscendance
					end
				end
				
				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	elseif specId == 2 then
		local specSettings = classSettings.enhancement
		UpdateSnapshot_Enhancement()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
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

				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))
				
				if snapshots[spells.ascendance.id].buff.isActive then
					local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
					local timeThreshold = 0
					local useEndOfAscendanceColor = false

					if specSettings.endOfAscendance.enabled then
						useEndOfAscendanceColor = true
						if specSettings.endOfAscendance.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
						elseif specSettings.endOfAscendance.mode == "time" then
							timeThreshold = specSettings.endOfAscendance.timeMax
						end
					end

					if useEndOfAscendanceColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.inAscendance1GCD
					else
						barColor = specSettings.colors.bar.inAscendance
					end
				end

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
	elseif specId == 3 then
		local specSettings = classSettings.restoration
		UpdateSnapshot_Restoration()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barBorderColor = specSettings.colors.bar.border

				local innervate = snapshots[spells.innervate.id] --[[@as TRB.Classes.Healer.Innervate]]
				local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]

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

				local passiveValue, _ = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)

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

				local potion = snapshots[spells.algariManaPotionRank1.id].cooldown
				local potionCooldownThreshold = 0
				local potionThresholdColor = specSettings.colors.threshold.over
				local potionFrameLevel = TRB.Data.constants.frameLevels.thresholdOver

				if potion.onCooldown then
					potionThresholdColor = specSettings.colors.threshold.unusable
					potionFrameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
					if specSettings.thresholds.potionCooldown.enabled then
						if specSettings.thresholds.potionCooldown.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							potionCooldownThreshold = gcd * specSettings.thresholds.potionCooldown.gcdsMax
						elseif specSettings.thresholds.potionCooldown.mode == "time" then
							potionCooldownThreshold = specSettings.thresholds.potionCooldown.timeMax
						end
					end
				end

				local pairOffset = 0
				local thresholdId = 1
				for _, v in pairs(spells) do
					local spell = v --[[@as TRB.Classes.SpellBase]]
					if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
						spell = spell --[[@as TRB.Classes.SpellThreshold]]
						
						local showThreshold = true
						local thresholdColor = specSettings.colors.threshold.over
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
								if specSettings.thresholds[spell.settingKey].enabled and resourceAmount < TRB.Data.character.maxResource then
									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[thresholdId], resourceFrame, resourceAmount, TRB.Data.character.maxResource)
								else
									showThreshold = false
								end
							else
								showThreshold = false
							end
						else
							resourceAmount = spell:GetPrimaryResourceCost()
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[thresholdId], resourceFrame, resourceAmount, TRB.Data.character.maxResource)
						end

						TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specSettings)

						thresholdId = thresholdId + 1
						pairOffset = pairOffset + 3
					end
				end

				local barColor = specSettings.colors.bar.base

				if snapshots[spells.ascendance.id].buff.isActive then
					local timeLeft = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
					local timeThreshold = 0
					local useEndOfAscendanceColor = false

					if specSettings.endOfAscendance.enabled then
						useEndOfAscendanceColor = true
						if specSettings.endOfAscendance.mode == "gcd" then
							local gcd = TRB.Functions.Character:GetCurrentGCDTime()
							timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
						elseif specSettings.endOfAscendance.mode == "time" then
							timeThreshold = specSettings.endOfAscendance.timeMax
						end
					end

					if useEndOfAscendanceColor and timeLeft <= timeThreshold then
						barColor = specSettings.colors.bar.inAscendance1GCD
					else
						barColor = specSettings.colors.bar.inAscendance
					end
				end

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
			end

			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		end
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
		if specId == 1 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
			settings = TRB.Data.settings.shaman.elemental
		elseif specId == 2 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
			settings = TRB.Data.settings.shaman.enhancement
		elseif specId == 3 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
			settings = TRB.Data.settings.shaman.restoration
		end

		if entry.destinationGuid == TRB.Data.character.guid then
			if specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
				if settings.passiveGeneration.symbolOfHope and
				 (entry.spellId == spells.symbolOfHope.tickId or
				 entry.spellId == spells.symbolOfHope.id) then
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
					local duration = spells.manaTideTotem.duration
					manaTideTotem:Initialize(entry.type, duration)
				elseif entry.spellId == spells.potionOfChilledClarity.id then
					local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
					potionOfChilledClarity.buff:Initialize(entry.type)
				elseif entry.spellId == spells.moltenRadiance.id then
					local moltenRadiance = snapshots[spells.moltenRadiance.id] --[[@as TRB.Classes.Healer.MoltenRadiance]]
					moltenRadiance.buff:Initialize(entry.type)
				elseif settings.passiveGeneration.blessingOfWinter and entry.spellId == spells.blessingOfWinter.id then
					local blessingOfWinter = snapshotData.snapshots[spells.blessingOfWinter.id] --[[@as TRB.Classes.Healer.BlessingOfWinter]]
					blessingOfWinter.buff:Initialize(entry.type)
				end
			end
		end

		if entry.sourceGuid == TRB.Data.character.guid then
			if specId == 1 and TRB.Data.barConstructedForSpec == "elemental" then
				if entry.spellId == spells.chainLightning.id then
					if entry.type == "SPELL_DAMAGE" then
						local chainLightning = snapshots[spells.chainLightning.id]
						if chainLightning.attributes.hitTime == nil or currentTime > (chainLightning.attributes.hitTime + 0.1) then --This is a new hit
							chainLightning.attributes.targetsHit = 0
						end
						chainLightning.attributes.targetsHit = chainLightning.attributes.targetsHit + 1
						chainLightning.attributes.hitTime = currentTime
						chainLightning.attributes.hasStruckTargets = true
					end
				elseif entry.spellId == spells.icefury.id then
					snapshots[spells.icefury.id].buff:Initialize(entry.type)
					snapshots[spells.icefury.id].attributes.resource = snapshots[spells.icefury.id].buff.applications * spells.frostShock.resource
				elseif entry.spellId == spells.stormkeeper.id then
					snapshots[spells.stormkeeper.id].buff:Initialize(entry.type)
				elseif entry.spellId == spells.surgeOfPower.id then
					snapshots[spells.surgeOfPower.id].buff:Initialize(entry.type)
				elseif entry.spellId == spells.powerOfTheMaelstrom.id then
					snapshots[spells.powerOfTheMaelstrom.id].buff:Initialize(entry.type)
				elseif entry.spellId == spells.echoesOfGreatSundering.id then
					snapshots[spells.echoesOfGreatSundering.id].buff:Initialize(entry.type)
				elseif entry.spellId == spells.primalFracture.id then
					snapshots[spells.primalFracture.id].buff:Initialize(entry.type)
				end
			elseif specId == 2 and TRB.Data.barConstructedForSpec == "enhancement" then
			elseif specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then
				if entry.spellId == spells.slumberingSoulSerumRank1.spellId or entry.spellId == spells.slumberingSoulSerumRank2.spellId or entry.spellId == spells.slumberingSoulSerumRank3.spellId then
					local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
					channeledManaPotion.buff:Initialize(entry.type)
				end
			end

			-- Spec agnostic abilities
			if entry.spellId == spells.ascendance.id then
				snapshots[entry.spellId].buff:Initialize(entry.type)
			elseif entry.spellId == spells.flameShock.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					triggerUpdate = targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
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
		specCache.elemental.talents:GetTalents()
		FillSpellData_Elemental()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.elemental)

		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.flameShock)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Elemental
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.elemental)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)
		
		if TRB.Data.barConstructedForSpec ~= "elemental" then
			talents = specCache.elemental.talents
			TRB.Data.barConstructedForSpec = "elemental"
			ConstructResourceBar(specCache.elemental.settings)
		end
	elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		specCache.enhancement.talents:GetTalents()
		FillSpellData_Enhancement()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.enhancement)
					
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.flameShock)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Enhancement
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.enhancement)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)

		if TRB.Data.barConstructedForSpec ~= "enhancement" then
			talents = specCache.enhancement.talents
			TRB.Data.barConstructedForSpec = "enhancement"
			ConstructResourceBar(specCache.enhancement.settings)
		end
	elseif specId == 3 then
		specCache.restoration.talents:GetTalents()
		FillSpellData_Restoration()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)

		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		targetData:AddSpellTracking(spells.flameShock)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.restoration)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)

		if TRB.Data.barConstructedForSpec ~= "restoration" then
			talents = specCache.restoration.talents
			TRB.Data.barConstructedForSpec = "restoration"
			ConstructResourceBar(specCache.restoration.settings)
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
	local specId = GetSpecialization() or 0
	if classIndexId == 7 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Options:PortForwardSettings()

					local settings = TRB.Options.Shaman.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.elemental == nil or
						TwintopInsanityBarSettings.shaman.elemental.displayText == nil then
						settings.shaman.elemental.displayText.barText = TRB.Options.Shaman.ElementalLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.core.experimental.specs.shaman.enhancement and
						(TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.enhancement == nil or
						TwintopInsanityBarSettings.shaman.enhancement.displayText == nil) then
						settings.shaman.enhancement.displayText.barText = TRB.Options.Shaman.EnhancementLoadDefaultBarTextSimpleSettings()
					end

					if TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.restoration == nil or
						TwintopInsanityBarSettings.shaman.restoration.displayText == nil then
						settings.shaman.restoration.displayText.barText = TRB.Options.Shaman.RestorationLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Shaman.LoadDefaultSettings(true)
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
						TRB.Data.settings.shaman.elemental = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.elemental)
						TRB.Data.settings.shaman.enhancement = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.enhancement)
						TRB.Data.settings.shaman.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues("Restoration Shaman", TRB.Data.settings.shaman.restoration)
						FillSpellData_Elemental()
						FillSpellData_Enhancement()
						FillSpellData_Restoration()

						SwitchSpec()
						TRB.Options.Shaman.ConstructOptionsPanel(specCache)
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
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "shaman"
	local specId = GetSpecialization()
	
	if specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		TRB.Data.character.specName = "elemental"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom)
	elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		TRB.Data.character.specName = "enhancement"
		local maxComboPoints = 10
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(TRB.Data.settings.shaman.enhancement, TRB.Frames.barContainerFrame)
		end
	elseif specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		TRB.Data.character.specName = "restoration"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
		TRB.Data.character.items.alchemyStone = spells.alchemistStone.attributes.isAlchemistStoneEquipped()
	end
end

function TRB.Functions.Class:EventRegistration()
	local specId = GetSpecialization()
	if specId == 1 and TRB.Data.settings.core.enabled.shaman.elemental then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Maelstrom
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Id = nil
	elseif specId == 2 and TRB.Data.settings.core.enabled.shaman.enhancement and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "SPELL"
		TRB.Data.resource2Id = 344179
		TRB.Data.resource2Factor = 1
	elseif specId == 3 and TRB.Data.settings.core.enabled.shaman.restoration then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Id = nil
	else
		TRB.Data.specSupported = false
	end

	if TRB.Data.specSupported then
		TRB.Functions.Class:CheckCharacter()

		targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
		TRB.Frames.barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		TRB.Frames.barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Functions.Aura:EnableUnitAura()

		TRB.Details.addonData.registered = true
	else
		targetsTimerFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)
		TRB.Frames.barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		TRB.Frames.barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Functions.Aura:DisableUnitAura()
		TRB.Details.addonData.registered = false
		TRB.Frames.barContainerFrame:Hide()
	end
	TRB.Functions.Bar:HideResourceBar()
end

function TRB.Functions.Class:HideResourceBar(force)
	local specId = GetSpecialization()
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if specId == 1 or (specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement) or specId == 3 then
		local settings
		local notZeroShowValue = TRB.Data.character.maxResource
		local notZeroShowValueComboPoints = 0
		local includeComboPoints = false
		if specId == 1 then
			settings = TRB.Data.settings.shaman.elemental
			notZeroShowValue = 0
		elseif specId == 2 then
			settings = TRB.Data.settings.shaman.enhancement
			includeComboPoints = true
		elseif specId == 3 then
			settings = TRB.Data.settings.shaman.restoration
		end

		TRB.Functions.Bar:HideResourceBarGeneric(settings, force, notZeroShowValue, includeComboPoints, notZeroShowValueComboPoints)
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
	if specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		settings = TRB.Data.settings.shaman.elemental
	elseif specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		settings = TRB.Data.settings.shaman.enhancement
	elseif specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		settings = TRB.Data.settings.shaman.restoration
	else
		return false
	end

	if specId == 1 then
		if var == "$resource" or var == "$maelstrom" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$maelstromMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$maelstromTotal" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id)) then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$maelstromPlusCasting" then
			if snapshotData.attributes.resource > 0 or
				(snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id)) then
				valid = true
			end
		elseif var == "$overcap" or var == "$maelstromOvercap" or var == "$resourceOvercap" then
			local threshold = ((snapshotData.attributes.resource / TRB.Data.resourceFactor) + snapshotData.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$maelstromPlusPassive" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id) then
				valid = true
			end
		elseif var == "$passive" then
		elseif var == "$ifMaelstrom" then
			if snapshots[spells.icefury.id].attributes.resource > 0 then
				valid = true
			end
		elseif var == "$ifStacks" then
			if snapshots[spells.icefury.id].buff.isActive then
				valid = true
			end
		elseif var == "$ifTime" then
			if snapshots[spells.icefury.id].buff.isActive then
				valid = true
			end
		elseif var == "$skStacks" then
			if snapshots[spells.stormkeeper.id].buff.isActive then
				valid = true
			end
		elseif var == "$skTime" then
			if snapshots[spells.stormkeeper.id].buff.isActive then
				valid = true
			end
		elseif var == "$eogsTime" then
			if snapshots[spells.echoesOfGreatSundering.id].buff.isActive then
				valid = true
			end
		elseif var == "$pfTime" then
			if snapshots[spells.primalFracture.id].buff.isActive then
				valid = true
			end
		end
	elseif specId == 2 then --Enhancement
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
		elseif var == "$resource" or var == "$mana" then
			valid = true
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourcePercent" or var == "$manaPercent" then
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
		elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$regen" then
			if snapshotData.attributes.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$comboPoints" or var == "$maelstromWeapon" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$maelstromWeaponMax" then
			valid = true
		end
	elseif specId == 3 then
		if var == "$resource" or var == "$mana" then
			valid = true
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$manaTotal" then
			valid = true
		elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
			valid = true
		elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$passive" then
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
		elseif var == "$channeledMana" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
			if channeledManaPotion.buff.isActive then
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
		end
	else
		valid = false
	end
	
	-- Spec Agnostic
	if var == "$fsCount" then
		if snapshotData.targetData.count[spells.flameShock.id] > 0 then
			valid = true
		end
	elseif var == "$fsTime" then
		if not UnitIsDeadOrGhost("target") and
			UnitCanAttack("player", "target") and
			target ~= nil and
			target.spells[spells.flameShock.id] ~= nil and
			target.spells[spells.flameShock.id].remainingTime > 0 then
			valid = true
		end
	elseif var == "$ascendanceTime" then
		if snapshots[spells.ascendance.id].buff.isActive then
			valid = true
		end
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil
end

--HACK to fix FPS
local updateRateLimit = 0

function TRB.Functions.Class:TriggerResourceBarUpdates()
	local specId = GetSpecialization()
	if (specId ~= 1 and specId ~= 2 and specId ~= 3) or
		(specId == 2 and not TRB.Data.settings.core.experimental.specs.shaman.enhancement) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	local currentTime = GetTime()

	if updateRateLimit + 0.05 < currentTime then
		updateRateLimit = currentTime
		UpdateResourceBar()
	end
end