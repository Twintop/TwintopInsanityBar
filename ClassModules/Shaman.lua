local _, TRB = ...
if TRB.Data.character.classId ~= 7 then --Only do this if we're on a Shaman!
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

local specCache = {
	elemental = TRB.Classes.SpecCache:New(),
	enhancement = TRB.Classes.SpecCache:New(),
	restoration = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

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
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
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
	specCache.elemental.snapshotData.snapshots[spells.powerOfTheMaelstrom.id] = TRB.Classes.Snapshot:New(spells.powerOfTheMaelstrom, nil, "always")
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
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
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
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
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
	---@type TRB.Classes.Healer.ChanneledManaPotion
	specCache.restoration.snapshotData.snapshots[spells.slumberingSoulSerumRank1.id] = TRB.Classes.Healer.ChanneledManaPotion:New(spells.slumberingSoulSerumRank1, CalculateManaGain)
	---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.algariManaPotionRank1.id] = TRB.Classes.Snapshot:New(spells.algariManaPotionRank1)
	---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)

	specCache.restoration.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Elemental()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "elemental")
end

local function Setup_Enhancement()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "enhancement")
end

local function Setup_Restoration()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "restoration", true)
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
		--[[{ variable = "$passive", description = L["ShamanElementalBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$maelstromPlusCasting", description = L["ShamanElementalBarTextVariable_maelstromPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromPlusPassive", description = L["ShamanElementalBarTextVariable_maelstromPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromTotal", description = L["ShamanElementalBarTextVariable_maelstromTotal"], printInSettings = true, color = false },   
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },]]

		--[[{ variable = "$fsCount", description = L["ShamanElementalBarTextVariable_fsCount"], printInSettings = true, color = false },
		{ variable = "$fsTime", description = L["ShamanElementalBarTextVariable_fsTime"], printInSettings = true, color = false },

		{ variable = "$ifStacks", description = L["ShamanElementalBarTextVariable_ifStacks"], printInSettings = true, color = false },
		{ variable = "$ifMaelstrom", description = L["ShamanElementalBarTextVariable_ifMaelstrom"], printInSettings = true, color = false },
		{ variable = "$ifTime", description = L["ShamanElementalBarTextVariable_ifTime"], printInSettings = true, color = false },

		{ variable = "$skStacks", description = L["ShamanElementalBarTextVariable_skStacks"], printInSettings = true, color = false },
		{ variable = "$skTime", description = L["ShamanElementalBarTextVariable_skTime"], printInSettings = true, color = false },]]

		{ variable = "$ascendanceTime", description = L["ShamanElementalBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		--[[{ variable = "$eogsTime", description = L["ShamanElementalBarTextVariable_eogsTime"], printInSettings = true, color = false },

		{ variable = "$pfTime", description = L["ShamanElementalBarTextVariable_pfTime"], printInSettings = true, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
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
		
		--[[{ variable = "$maelstromWeapon", description = L["ShamanEnhancementBarTextVariable_maelstromWeapon"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromWeaponMax", description = L["ShamanEnhancementBarTextVariable_maelstromWeaponMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },]]

		{ variable = "$ascendanceTime", description = L["ShamanEnhancementBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		--[[{ variable = "$fsCount", description = L["ShamanEnhancementBarTextVariable_fsCount"], printInSettings = true, color = false },
		{ variable = "$fsTime", description = L["ShamanEnhancementBarTextVariable_fsTime"], printInSettings = true, color = false },
		
		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
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
		--[[{ variable = "$passive", description = L["ShamanRestorationBarTextVariable_passive"], printInSettings = true, color = false },
		{ variable = "$manaPlusCasting", description = L["ShamanRestorationBarTextVariable_manaPlusCasting"], printInSettings = true, color = false },
		{ variable = "$resourcePlusCasting", description = "", printInSettings = false, color = false },
		{ variable = "$manaPlusPassive", description = L["ShamanRestorationBarTextVariable_manaPlusPassive"], printInSettings = true, color = false },
		{ variable = "$resourcePlusPassive", description = "", printInSettings = false, color = false },
		{ variable = "$manaTotal", description = L["ShamanRestorationBarTextVariable_manaTotal"], printInSettings = true, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },

		{ variable = "$innervateMana", description = L["ShamanRestorationBarTextVariable_innervateMana"], printInSettings = true, color = false },
		{ variable = "$innervateTime", description = L["ShamanRestorationBarTextVariable_innervateTime"], printInSettings = true, color = false },

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
		{ variable = "$fsTime", description = L["ShamanRestorationBarTextVariable_fsTime"], printInSettings = true, color = false },]]
		
		{ variable = "$ascendanceTime", description = L["ShamanRestorationBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		--[[{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }]]
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
	for _, v in pairs(resourceFrame.thresholds) do
		v:Hide();
	end

	for thresholdId = 1, #TRB.Data.cache.thresholdSpells do
		if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
			TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
		end
		TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
	end
	
	for _, v in pairs(passiveFrame.thresholds) do
		v:Hide();
	end

	if TRB.Data.character.specId == 1 then
		TRB.Frames.resource2ContainerFrame:Hide()
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		--TRB.Frames.resource2ContainerFrame:Show()
		TRB.Frames.resource2ContainerFrame:Hide()
	elseif TRB.Data.character.specId == 3 then
		for x = 1, 7 do
			if TRB.Frames.passiveFrame.thresholds[x] == nil then
				TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
			end
			TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.passiveFrame.thresholds[x], settings, false)
		end
		TRB.Frames.resource2ContainerFrame:Hide()
	end

	TRB.Functions.Class:CheckCharacter()
	TRB.Functions.Bar:Construct(settings)
end

local function RefreshLookupData_Elemental()
	local specSettings = TRB.Data.settings.shaman.elemental
	local sharedSettings = TRB.Data.specCache["elemental"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()

	--$overcap
	--local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

	local currentMaelstromColor = sharedSettings.colors.text.current.color
	local castingMaelstromColor = sharedSettings.colors.text.casting.color

	local maelstromThreshold = TRB.Data.character.maxResource

	if talents:IsTalentActive(spells.earthquake) then
		maelstromThreshold = math.min(maelstromThreshold, spells.earthquake:GetPrimaryResourceCost())
	end
	
	if talents:IsTalentActive(spells.earthShock) and not talents:IsTalentActive(spells.elementalBlast) then
		maelstromThreshold = math.min(maelstromThreshold, spells.earthShock:GetPrimaryResourceCost())
	elseif talents:IsTalentActive(spells.elementalBlast) then
		maelstromThreshold = math.min(maelstromThreshold, spells.elementalBlast:GetPrimaryResourceCost())
	end

	if TRB.Data.character.inCombat then
		--[[if sharedSettings.colors.text.overcap.enabled and overcap then
			currentMaelstromColor = sharedSettings.colors.text.overcap.color
			castingMaelstromColor = sharedSettings.colors.text.overcap.color
		else]]if sharedSettings.colors.text.overThreshold.enabled and snapshotData.attributes.resource >= maelstromThreshold then
			currentMaelstromColor = sharedSettings.colors.text.overThreshold.color
			castingMaelstromColor = sharedSettings.colors.text.overThreshold.color
		end
	end

	--$maelstrom
	local currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, snapshotData.attributes.resource)
	--$casting
	local castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, snapshotData.casting.resourceFinal)
	--$passive
	--[[local _passiveMaelstrom = 0

	local passiveMaelstrom = string.format("|c%s%.0f|r", sharedSettings.colors.text.passive.color, _passiveMaelstrom)
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

	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.flameShock.id].active then
			if _flameShockTime > spells.flameShock.pandemicTime then
				flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			else
				flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			end
		else
			flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _flameShockCount)
			flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
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
	local pfTime = TRB.Functions.BarText:TimerPrecision(_pfTime)]]

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	----------------------------

	--[[Global_TwintopResourceBar.resource.passive = _passiveMaelstrom
	Global_TwintopResourceBar.resource.icefury = icefuryMaelstrom

	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.fsCount = flameShockCount or 0

	Global_TwintopResourceBar.chainLightning = Global_TwintopResourceBar.chainLightning or {}
	Global_TwintopResourceBar.chainLightning.targetsHit = snapshots[spells.chainLightning.id].attributes.targetsHit or 0

	Global_TwintopResourceBar.icefury = Global_TwintopResourceBar.icefury or {}
	Global_TwintopResourceBar.icefury.maelstrom = icefuryMaelstrom
	Global_TwintopResourceBar.icefury.stacks = icefuryStacks
	Global_TwintopResourceBar.icefury.remaining = icefuryTime]]

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMaelstrom
	lookup["$maelstrom"] = currentMaelstrom
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$maelstromMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingMaelstrom
	lookup["$ascendanceTime"] = ascendanceTime
	--[[lookup["$maelstromPlusCasting"] = maelstromPlusCasting
	lookup["$maelstromPlusPassive"] = maelstromPlusPassive
	lookup["$maelstromTotal"] = maelstromTotal
	lookup["$resourcePlusCasting"] = maelstromPlusCasting
	lookup["$resourcePlusPassive"] = maelstromPlusPassive
	lookup["$resourceTotal"] = maelstromTotal
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
	lookup["$pfTime"] = pfTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$maelstrom"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$maelstromMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	--[[lookupLogic["$maelstromPlusCasting"] = _maelstromPlusCasting
	lookupLogic["$maelstromPlusPassive"] = _maelstromPlusPassive
	lookupLogic["$maelstromTotal"] = _maelstromTotal
	lookupLogic["$resourcePlusCasting"] = _maelstromPlusCasting
	lookupLogic["$resourcePlusPassive"] = _maelstromPlusPassive
	lookupLogic["$resourceTotal"] = _maelstromTotal
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
	lookupLogic["$pfTime"] = _pfTime]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Enhancement()
	local specSettings = TRB.Data.settings.shaman.enhancement
	local sharedSettings = TRB.Data.specCache["enhancement"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	--Spec specific implementation
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()
	local currentManaColor = sharedSettings.colors.text.current.color
	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))

	----------
	--$fsCount and $fsTime
	--[[local _flameShockCount = targetData.count[spells.flameShock.id] or 0
	local flameShockCount = string.format("%s", _flameShockCount)
	local _flameShockTime = 0
	
	if target ~= nil then
		_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
	end

	local flameShockTime

	if sharedSettings.colors.text.dots.options.enabled and targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.flameShock.id].active then
			if _flameShockTime > spells.flameShock.pandemicTime then
				flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			else
				flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			end
		else
			flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _flameShockCount)
			flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
	end]]

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	----------------------------	
	--[[Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.fsCount = flameShockCount or 0]]

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$manaMax"] = TRB.Data.character.maxResource
	lookup["$ascendanceTime"] = ascendanceTime
	--[[lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$maelstromWeapon"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$maelstromWeaponMax"] = TRB.Data.character.maxResource2]]
	--[[lookup["$fsCount"] = flameShockCount
	lookup["$fsTime"] = flameShockTime]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	--[[lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$maelstromWeapon"] = snapshotData.attributes.resource2
	lookupLogic["$maelstromWeaponMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2]]
	--[[lookupLogic["$fsCount"] = _flameShockCount
	lookupLogic["$fsTime"] = _flameShockTime]]
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Restoration()
	local specSettings = TRB.Data.settings.shaman.restoration
	local sharedSettings = TRB.Data.specCache["restoration"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
	snapshotData.attributes.manaRegen, _ = GetPowerRegen()

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--[[
	local innervate = snapshots[spells.innervate.id] --[@as TRB.Classes.Healer.Innervate]
	--$innervateMana
	local _innervateMana = innervate.mana
	local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
	--$innervateTime
	local _innervateTime = innervate.buff:GetRemainingTime(currentTime)
	local innervateTime = TRB.Functions.BarText:TimerPrecision(_innervateTime)

	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[@as TRB.Classes.Healer.PotionOfChilledClarity]
	--$potionOfChilledClarityMana
	local _potionOfChilledClarityMana = potionOfChilledClarity.mana
	local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
	--$potionOfChilledClarityTime
	local _potionOfChilledClarityTime = potionOfChilledClarity.buff:GetRemainingTime(currentTime)
	local potionOfChilledClarityTime = TRB.Functions.BarText:TimerPrecision(_potionOfChilledClarityTime)
	
	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[@as TRB.Classes.Healer.ManaTideTotem]
	--$mttMana
	local _mttMana = manaTideTotem.mana
	local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
	--$mttTime
	local _mttTime = manaTideTotem.buff:GetRemainingTime(currentTime)
	local mttTime = TRB.Functions.BarText:TimerPrecision(_mttTime)

	--$potionCooldownSeconds
	local _potionCooldown = snapshots[spells.algariManaPotionRank1.id].cooldown.remaining
	local potionCooldownSeconds = TRB.Functions.BarText:TimerPrecision(_potionCooldown)
	local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
	local _potionCooldownSeconds = _potionCooldown % 60
	--$potionCooldown
	local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)
	
	local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[@as TRB.Classes.Healer.ChanneledManaPotion]
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
	local _passiveMana = _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana
	local passiveMana = string.format("|c%s%s|r", sharedSettings.colors.text.passive.color, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
	--$manaTotal
	local _manaTotal = math.min(_passiveMana + snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
	--$manaPlusCasting
	local _manaPlusCasting = math.min(snapshotData.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor", true))
	--$manaPlusPassive
	local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
	local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor", true))]]
	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	--[[local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end]]
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, true)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	----------
	--$fsCount and $fsTime
	--[[local _flameShockCount = snapshotData.targetData.count[spells.flameShock.id] or 0
	local flameShockCount = string.format("%s", _flameShockCount)
	local _flameShockTime = 0
	
	if target ~= nil then
		_flameShockTime = target.spells[spells.flameShock.id].remainingTime or 0
	end

	local flameShockTime

	if sharedSettings.colors.text.dots.options.enabled and snapshotData.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
		if target ~= nil and target.spells[spells.flameShock.id].active then
			if _flameShockTime > spells.flameShock.pandemicTime then
				flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.up.color, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.up.color, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			else
				flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.pandemic.color, _flameShockCount)
				flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.pandemic.color, TRB.Functions.BarText:TimerPrecision(_flameShockTime))
			end
		else
			flameShockCount = string.format("|c%s%.0f|r", sharedSettings.colors.text.dots.down.color, _flameShockCount)
			flameShockTime = string.format("|c%s%s|r", sharedSettings.colors.text.dots.down.color, TRB.Functions.BarText:TimerPrecision(0))
		end
	else
		flameShockTime = TRB.Functions.BarText:TimerPrecision(_flameShockTime)
	end]]

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	----------------------

	--[[Global_TwintopResourceBar.resource.passive = _passiveMana
	Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
	Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
	Global_TwintopResourceBar.resource.innervate = _innervateMana or 0

	Global_TwintopResourceBar.potionOfSpiritualClarity = Global_TwintopResourceBar.potionOfSpiritualClarity or {}
	Global_TwintopResourceBar.potionOfSpiritualClarity.mana = _channeledMana
	Global_TwintopResourceBar.potionOfSpiritualClarity.ticks = _slumberingSoulSerumTicks or 0

	Global_TwintopResourceBar.dots = Global_TwintopResourceBar.dots or {}
	Global_TwintopResourceBar.dots.fsCount = flameShockCount or 0]]

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$resourcePercent"] = manaPercent
	lookup["$manaPercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$ascendanceTime"] = ascendanceTime
	--[[lookup["$fsCount"] = flameShockCount
	lookup["$fsTime"] = flameShockTime
	lookup["$manaPlusCasting"] = manaPlusCasting
	lookup["$manaPlusPassive"] = manaPlusPassive
	lookup["$manaTotal"] = manaTotal
	lookup["$resourcePlusCasting"] = manaPlusCasting
	lookup["$resourcePlusPassive"] = manaPlusPassive
	lookup["$resourceTotal"] = manaTotal
	lookup["$passive"] = passiveMana
	lookup["$innervateMana"] = innervateMana
	lookup["$innervateTime"] = innervateTime
	lookup["$mttMana"] = mttMana
	lookup["$mttTime"] = mttTime
	lookup["$channeledMana"] = channeledMana
	lookup["$slumberingSoulSerumTicks"] = slumberingSoulSerumTicks
	lookup["$slumberingSoulSerumTime"] = slumberingSoulSerumTime
	lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
	lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
	lookup["$potionCooldown"] = potionCooldown
	lookup["$potionCooldownSeconds"] = potionCooldownSeconds]]
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resourceMax"] = manaMax
	lookupLogic["$manaMax"] = manaMax
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	--[[lookupLogic["$manaPlusCasting"] = _manaPlusCasting
	lookupLogic["$manaPlusPassive"] = _manaPlusPassive
	lookupLogic["$manaTotal"] = _manaTotal
	lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
	lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
	lookupLogic["$resourceTotal"] = _manaTotal
	lookupLogic["$passive"] = _passiveMana
	lookupLogic["$innervateMana"] = _innervateMana
	lookupLogic["$innervateTime"] = _innervateTime
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
	TRB.Data.lookupLogic = lookupLogic]]
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

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local casting = snapshotData.casting
	local currentTime = GetTime()
	local affectingCombat = TRB.Data.character.inCombat

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.lightningBolt.id then
				FillSnapshotDataCasting(spells.lightningBolt)

				--[[if snapshots[spells.surgeOfPower.id].buff.isActive then
					casting.resourceRaw = casting.resourceRaw + ((spells.lightningBolt.overload) * 2)
					casting.resourceFinal = casting.resourceFinal + ((spells.lightningBolt.overload) * 2)
				end]]
				
				if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive then
					casting.resourceRaw = casting.resourceRaw + spells.lightningBolt.overload
					casting.resourceFinal = casting.resourceFinal + spells.lightningBolt.overload
				end
			elseif spellId == spells.lavaBurst.id then
				FillSnapshotDataCasting(spells.lavaBurst)
			elseif spellId == spells.elementalBlast.id then
				FillSnapshotDataCasting(spells.elementalBlast)
			elseif spellId == spells.icefury.id then
				FillSnapshotDataCasting(spells.icefury)
			elseif spellId == spells.chainLightning.id then
				FillSnapshotDataCasting(spells.chainLightning)

				if snapshots[spells.chainLightning.id].attributes.hitTime == nil then
					snapshots[spells.chainLightning.id].attributes.targetsHit = 1
					snapshots[spells.chainLightning.id].attributes.hitTime = currentTime
					snapshots[spells.chainLightning.id].attributes.hasStruckTargets = false
				elseif currentTime > (snapshots[spells.chainLightning.id].attributes.hitTime + (TRB.Functions.Character:GetCurrentGCDTime(true) * 4) + TRB.Data.character.latency) then
					snapshots[spells.chainLightning.id].attributes.targetsHit = 1
				end

				if snapshots[spells.powerOfTheMaelstrom.id].buff.isActive and spellId == spells.chainLightning.id then
					snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw + spells.chainLightning.overload
					snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal + spells.chainLightning.overload
				end

				snapshotData.casting.resourceRaw = snapshotData.casting.resourceRaw * snapshots[spells.chainLightning.id].attributes.targetsHit
				snapshotData.casting.resourceFinal = snapshotData.casting.resourceFinal * snapshots[spells.chainLightning.id].attributes.targetsHit
			elseif spellId == spells.hex.id and talents:IsTalentActive(spells.inundate) and affectingCombat then
				FillSnapshotDataCasting(spells.hex)
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.ascendance.castId then
				local duration = spells.ascendance.duration
				if talents:IsTalentActive(spells.preeminence) then
					duration = duration + spells.preeminence.duration
				end
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local spells = spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
			if spellId == spells.ascendance.castId then
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(spells.ascendance.duration, currentTime)
			elseif spellId == spells.doomWinds.castId then
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(spells.doomWinds.duration, currentTime)
			end
		end
	elseif TRB.Data.character.specId == 3 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Restoration()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			local spells = spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
			if spellId == spells.ascendance.castId then
				local duration = spells.ascendance.duration
				if talents:IsTalentActive(spells.preeminence) then
					duration = duration + spells.preeminence.duration
				end
				snapshotData.snapshots[spells.ascendance.id].buff:InitializeCustom(duration, currentTime)
			end
		end
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

	--snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	--snapshots[spells.icefury.id].buff:GetRemainingTime(currentTime)
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
	--innervate:Update()

	local manaTideTotem = snapshots[spells.manaTideTotem.id] --[[@as TRB.Classes.Healer.ManaTideTotem]]
	--manaTideTotem:Update()

	local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[[@as TRB.Classes.Healer.PotionOfChilledClarity]]
	--potionOfChilledClarity:Update()

	local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[[@as TRB.Classes.Healer.ChanneledManaPotion]]
	--channeledManaPotion:Update()

	-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
	--snapshots[spells.algariManaPotionRank1.id].cooldown.startTime, snapshots[spells.algariManaPotionRank1.id].cooldown.duration, _ = C_Container.GetItemCooldown(TRB.Data.character.items.potions.algariManaPotionRank1.id)
	--snapshots[spells.algariManaPotionRank1.id].cooldown:GetRemainingTime(currentTime)
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.shaman
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.elemental
		local specCacheSettings = TRB.Data.specCache.elemental.settings
		UpdateSnapshot_Elemental()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = specSettings.colors.bar.border
				local passiveValue = 0

				--[[if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Data.character.inCombat then
					barBorderColor = specSettings.colors.bar.borderOvercap

					if specSettings.audio.overcap.enabled and snapshotData.audio.overcapCue == false then
						snapshotData.audio.overcapCue = true
						PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
					end
				else
					snapshotData.audio.overcapCue = false
				end]]

				--[[if specSettings.colors.bar.primalFracture.enabled and TRB.Functions.Class:IsValidVariableForSpec("$pfTime") then
					barBorderColor = specSettings.colors.bar.primalFracture.color
				end

				if TRB.Data.snapshotData.casting.resourceFinal ~= 0 and specSettings.colors.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end
				passiveBarValue = castingBarValue + passiveValue]]

				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				--[[if castingBarValue < currentResource then --Using a spender
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
				else]]
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				--end

				local barColor = specSettings.colors.bar.base

				local anyUsable = false
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					if resourceFrame.thresholds[thresholdId] == nil then
						resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color
					local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]

					anyUsable = anyUsable or isUsable
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.id == spells.earthquake.id or spell.id == spells.earthquakeTargeted.id then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							else
								--[[if specCacheSettings.colors.threshold.special.enabled and snapshots[spells.echoesOfGreatSundering.id].buff.isActive then
									thresholdColor = specCacheSettings.colors.threshold.special.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
								else]]if isUsable then-- currentResource >= resourceAmount then
									thresholdColor = specCacheSettings.colors.threshold.over.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdOver
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
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
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						elseif isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then-- currentResource >= resourceAmount then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end
					
					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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

				if anyUsable then-- currentResource >= maelstromThreshold then
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

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.enhancement
		local specCacheSettings = TRB.Data.specCache.enhancement.settings
		UpdateSnapshot_Enhancement()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource -- snapshotData.attributes.resource / TRB.Data.resourceFactor

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border
				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
				TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)

				barContainerFrame:SetAlpha(1.0)
				
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

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
				
				--[[local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
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
				end]]
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local specSettings = classSettings.restoration
		local specCacheSettings = TRB.Data.specCache.restoration.settings
		UpdateSnapshot_Restoration()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, TRB.Frames.barContainerFrame)
		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
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

				--[[if TRB.Data.snapshotData.casting.resourceFinal ~= 0 and specSettings.colors.bar.showCasting then
					castingBarValue = currentResource + snapshotData.casting.resourceFinal
				else
					castingBarValue = currentResource
				end

				local passiveValue, _ = TRB.Functions.Threshold:ManageCommonHealerPassiveThresholds(specCacheSettings, spells, snapshotData.snapshots, passiveFrame, castingBarValue)
				passiveBarValue = castingBarValue + passiveValue]]

				local castingBarColor = specSettings.colors.bar.casting
				local passiveBarColor = specSettings.colors.bar.passive

				--[[if castingBarValue < currentResource then --Using a spender
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
				else]]
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "resource", resourceFrame, currentResource)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "passive", passiveFrame, passiveBarValue)
					TRB.Functions.Bar:SetPrimaryValue(specCacheSettings, "casting", castingFrame, castingBarValue)
					castingBarColor = specSettings.colors.bar.casting
					passiveBarColor = specSettings.colors.bar.passive
				--end


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

				--[[local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]=]) do
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

					local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
					TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, resourceFrame.thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, TRB.Data.character.maxResource)
				end]]

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

				TRB.Functions.Color:SetBackdropBorderColorFromRGBAString(barBorderFrame, "bar", barBorderColor)
				if specSettings.colors.endCap["base"].enabled and specSettings.colors.endCap["base"].useBorderColor then
					if specSettings.colors.endCap["base"].useBorderColorExceptDefault and barBorderColor == specSettings.colors.bar.border then
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, specSettings.colors.endCap["base"].color, true)
					else
						TRB.Functions.Color:SetThresholdColor(resourceFrame.endCap, barBorderColor, true)
					end
				end
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(castingFrame, "casting", castingBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(passiveFrame, "passive", passiveBarColor)
				TRB.Functions.Color:SetStatusBarColorFromRGBAString(resourceFrame, "resource", barColor)
			end

			TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
		end
	end
end

--[[
barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local currentTime = GetTime()
	local spells
	local snapshotData = TRB.Data.snapshotData --[@as TRB.Classes.SnapshotData]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()

		local settings
		if TRB.Data.character.specId == 1 then
			spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Shaman.ElementalSpells]
			settings = TRB.Data.settings.shaman.elemental
		elseif TRB.Data.character.specId == 2 then
			spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Shaman.EnhancementSpells]
			settings = TRB.Data.settings.shaman.enhancement
		elseif TRB.Data.character.specId == 3 then
			spells = TRB.Data.spellsData.spells --[@as TRB.Classes.Shaman.RestorationSpells]
			settings = TRB.Data.settings.shaman.restoration
		end

		if entry.destinationGuid == TRB.Data.character.guid then
			if TRB.Data.character.specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
				if settings.passiveGeneration.innervate and entry.spellId == spells.innervate.id then
					local innervate = snapshots[spells.innervate.id] --[@as TRB.Classes.Healer.Innervate]
					innervate.buff:Initialize(entry.type)
					if entry.type == "SPELL_AURA_APPLIED" or entry.type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
						snapshotData.audio.innervateCue = false
					elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
						snapshotData.audio.innervateCue = false
					end
				elseif settings.passiveGeneration.manaTideTotem and entry.spellId == spells.manaTideTotem.id then
					local manaTideTotem = snapshots[spells.manaTideTotem.id] --[@as TRB.Classes.Healer.ManaTideTotem]
					local duration = spells.manaTideTotem.duration
					manaTideTotem:Initialize(entry.type, duration)
				elseif entry.spellId == spells.potionOfChilledClarity.id then
					local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[@as TRB.Classes.Healer.PotionOfChilledClarity]
					potionOfChilledClarity.buff:Initialize(entry.type)
				end
			end
		end

		if entry.sourceGuid == TRB.Data.character.guid then
			if TRB.Data.character.specId == 1 and TRB.Data.barConstructedForSpec == "elemental" then
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
				end
			elseif TRB.Data.character.specId == 2 and TRB.Data.barConstructedForSpec == "enhancement" then
			elseif TRB.Data.character.specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then
				if entry.spellId == spells.slumberingSoulSerumRank1.spellId or entry.spellId == spells.slumberingSoulSerumRank2.spellId or entry.spellId == spells.slumberingSoulSerumRank3.spellId then
					local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[@as TRB.Classes.Healer.ChanneledManaPotion]
					channeledManaPotion.buff:Initialize(entry.type)
				end
			end

			-- Spec agnostic abilities
			if entry.spellId == spells.flameShock.id then
				if TRB.Functions.Class:InitializeTarget(entry.destinationGuid) then
					targetData:HandleCombatLogDebuff(entry.spellId, entry.type, entry.destinationGuid)
				end
			end
		end

		if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
			targetData:Remove(entry.destinationGuid)
			RefreshTargetTracking()
		end
	end
end)
]]

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		self.sinceLastUpdate = 0
	end
end

local function SwitchSpec()
	--barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = GetSpecialization()

	if TRB.Data.character.specId == 1 then
		specCache.elemental.talents:GetTalents()
		FillSpellData_Elemental()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.elemental)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		--targetData:AddSpellTracking(spells.flameShock)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Elemental
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.elemental.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)

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
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}
		
		if TRB.Data.barConstructedForSpec ~= "elemental" then
			talents = specCache.elemental.talents
			TRB.Data.barConstructedForSpec = "elemental"
			ConstructResourceBar(specCache.elemental.settings)
		end
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		specCache.enhancement.talents:GetTalents()
		FillSpellData_Enhancement()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.enhancement)
			
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]		
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		--targetData:AddSpellTracking(spells.flameShock)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Enhancement
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.enhancement.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		lookup["#flameShock"] = spells.flameShock.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "enhancement" then
			talents = specCache.enhancement.talents
			TRB.Data.barConstructedForSpec = "enhancement"
			ConstructResourceBar(specCache.enhancement.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.restoration.talents:GetTalents()
		FillSpellData_Restoration()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData
		--targetData:AddSpellTracking(spells.flameShock)

		TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.restoration.settings)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		lookup["#flameShock"] = spells.flameShock.icon
		lookup["#innervate"] = spells.innervate.icon
		lookup["#mtt"] = spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = spells.manaTideTotem.icon
		lookup["#slumberingSoulSerum"] = spells.slumberingSoulSerumRank1.icon
		lookup["#amp"] = spells.algariManaPotionRank1.icon
		lookup["#algariManaPotion"] = spells.algariManaPotionRank1.icon
		lookup["#pocc"] = spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = spells.potionOfChilledClarity.icon
		lookup["#poff"] = spells.slumberingSoulSerumRank1.icon
		lookup["#slumberingSoulSerum"] = spells.slumberingSoulSerumRank1.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

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
	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end
	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end
	
	if TRB.Data.character.classId == 7 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

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
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
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

		if TRB.Details.addonData.loaded and TRB.Data.character.specId > 0 then
			if not TRB.Details.addonData.optionsPanelStarted then
				TRB.Details.addonData.optionsPanelStarted = true
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

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Shaman.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "shaman"
	
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "elemental"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Maelstrom, false)
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		TRB.Data.character.specName = "enhancement"
		local maxComboPoints = 10
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(TRB.Data.settings.shaman.enhancement, TRB.Frames.barContainerFrame)
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		TRB.Data.character.specName = "restoration"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		TRB.Data.character.items.alchemyStone = spells.alchemistStone.attributes.isAlchemistStoneEquipped()
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.shaman.elemental then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Maelstrom
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Id = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.shaman.enhancement and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		--[[TRB.Data.resource2 = "SPELL"
		TRB.Data.resource2Id = 344179
		TRB.Data.resource2Factor = 1]]
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.shaman.restoration then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Id = nil
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()

	if TRB.Data.character.specId == 1 or (TRB.Data.character.specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement) or TRB.Data.character.specId == 3 then
		local notZeroShowValue = TRB.Data.character.maxResource
		local notZeroShowValueComboPoints = 0
		local includeComboPoints = false
		if TRB.Data.character.specId == 1 then
			notZeroShowValue = 0
		elseif TRB.Data.character.specId == 2 then
			includeComboPoints = true
		end
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.specName] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
		end

		TRB.Functions.Bar:HideResourceBarGeneric(sharedSettings, force, notZeroShowValue, includeComboPoints, notZeroShowValueComboPoints)
	else
		TRB.Frames.barContainerFrame:Hide()
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
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local spells
	local settings = nil

	if TRB.Data.character.specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		settings = TRB.Data.settings.shaman.elemental
	elseif TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		settings = TRB.Data.settings.shaman.enhancement
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		settings = TRB.Data.settings.shaman.restoration
	else
		return false
	end

	if TRB.Data.character.specId == 1 then
		if var == "$resource" or var == "$maelstrom" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$maelstromMax" then
			valid = true
		--[[elseif var == "$resourceTotal" or var == "$maelstromTotal" then
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
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) <= threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed <= threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$maelstromPlusPassive" then
			if snapshotData.attributes.resource > 0 then
				valid = true
			end]]
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id) then
				valid = true
			end
		--[[elseif var == "$passive" then
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
			end]]
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 2 then --Enhancement
		--[[if var == "$casting" then
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
		else]]if var == "$resource" or var == "$mana" then
			valid = true
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		--[[elseif var == "$resourcePercent" or var == "$manaPercent" then
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
			valid = true]]
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then
		if var == "$resource" or var == "$mana" then
			valid = true
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		--[[elseif var == "$resourceTotal" or var == "$manaTotal" then
			valid = true
		elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
			valid = true
		elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
			valid = true]]
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		--[[elseif var == "$passive" then
			if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
				TRB.Functions.Class:IsValidVariableForSpec("$mttMana") then
				valid = true
			end
		elseif var == "$innervateMana" then
			local innervate = snapshots[spells.innervate.id] --[@as TRB.Classes.Healer.Innervate]
			if innervate.buff.isActive then
				valid = true
			end
		elseif var == "$innervateTime" then
			local innervate = snapshots[spells.innervate.id] --[@as TRB.Classes.Healer.Innervate]
			if innervate.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfChilledClarityMana" then
			local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[@as TRB.Classes.Healer.PotionOfChilledClarity]
			if potionOfChilledClarity.buff.isActive then
				valid = true
			end
		elseif var == "$potionOfChilledClarityTime" then
			local potionOfChilledClarity = snapshots[spells.potionOfChilledClarity.id] --[@as TRB.Classes.Healer.PotionOfChilledClarity]
			if potionOfChilledClarity.buff.isActive then
				valid = true
			end
		elseif var == "$mttMana" then
			local manaTideTotem = snapshots[spells.manaTideTotem.id] --[@as TRB.Classes.Healer.ManaTideTotem]
			if manaTideTotem.buff.isActive then
				valid = true
			end
		elseif var == "$mttTime" then
			local manaTideTotem = snapshots[spells.manaTideTotem.id] --[@as TRB.Classes.Healer.ManaTideTotem]
			if manaTideTotem.buff.isActive then
				valid = true
			end
		elseif var == "$channeledMana" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[@as TRB.Classes.Healer.ChanneledManaPotion]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$slumberingSoulSerumTicks" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[@as TRB.Classes.Healer.ChanneledManaPotion]
			if channeledManaPotion.buff.isActive then
				valid = true
			end
		elseif var == "$slumberingSoulSerumTime" then
			local channeledManaPotion = snapshots[spells.slumberingSoulSerumRank1.id] --[@as TRB.Classes.Healer.ChanneledManaPotion]
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
			end]]
		end
	else
		valid = false
	end
	
	-- Spec Agnostic
	--[[if var == "$fsCount" then
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
	end]]

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil, true
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) or
		(TRB.Data.character.specId == 2 and not TRB.Data.settings.core.experimental.specs.shaman.enhancement) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end