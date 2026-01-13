local _, TRB = ...
if TRB.Data.character.classId ~= 7 then --Only do this if we're on a Shaman!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

local specCache = {
	elemental = TRB.Classes.SpecCache:New(),
	enhancement = TRB.Classes.SpecCache:New(),
	restoration = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Elemental
	Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0
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
			regen = 0
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
			casting = 0
		}
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
		}
	}

	---@type TRB.Classes.Shaman.RestorationSpells
	specCache.restoration.spellsData.spells = TRB.Classes.Shaman.RestorationSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.restoration.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]

	specCache.restoration.snapshotData.attributes.manaRegen = 0
	specCache.restoration.snapshotData.audio = {
	}
	---@type TRB.Classes.Snapshot
	specCache.restoration.snapshotData.snapshots[spells.ascendance.id] = TRB.Classes.Snapshot:New(spells.ascendance)

	specCache.restoration.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Elemental()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "elemental")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Elemental using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Shaman.BarGroupsFactory:CreateForSpec(1)
end

local function Setup_Enhancement()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "enhancement", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Enhancement using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Shaman.BarGroupsFactory:CreateForSpec(2)
end

local function Setup_Restoration()
	TRB.Functions.Character:FillSpecializationCacheSettings("shaman", "restoration", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Restoration using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Shaman.BarGroupsFactory:CreateForSpec(3)
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
		{ variable = "#frostShock", icon = spells.frostShock.icon, description = spells.frostShock.name, printInSettings = true },
		{ variable = "#icefury", icon = spells.icefury.icon, description = spells.icefury.name, printInSettings = true },
		{ variable = "#lavaBurst", icon = spells.lavaBurst.icon, description = spells.lavaBurst.name, printInSettings = true },
		{ variable = "#lightningBolt", icon = spells.lightningBolt.icon, description = spells.lightningBolt.name, printInSettings = true },
		{ variable = "#primalFracture", icon = spells.primalFracture.icon, description = spells.primalFracture.name, printInSettings = true },
		{ variable = "#stormkeeper", icon = spells.stormkeeper.icon, description = spells.stormkeeper.name, printInSettings = true },
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
		
		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$maelstrom", description = L["ShamanElementalBarTextVariable_maelstrom"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromMax", description = L["ShamanElementalBarTextVariable_maelstromMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["ShamanElementalBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["PriestHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$manaPercent", description = L["PriestHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["PriestHolyBarTextVariable_manaMax"], printInSettings = true, color = false },

		--[[{ variable = "$ifStacks", description = L["ShamanElementalBarTextVariable_ifStacks"], printInSettings = true, color = false },
		{ variable = "$ifMaelstrom", description = L["ShamanElementalBarTextVariable_ifMaelstrom"], printInSettings = true, color = false },
		{ variable = "$ifTime", description = L["ShamanElementalBarTextVariable_ifTime"], printInSettings = true, color = false },

		{ variable = "$skStacks", description = L["ShamanElementalBarTextVariable_skStacks"], printInSettings = true, color = false },
		{ variable = "$skTime", description = L["ShamanElementalBarTextVariable_skTime"], printInSettings = true, color = false },]]

		{ variable = "$ascendanceTime", description = L["ShamanElementalBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		--[[{ variable = "$eogsTime", description = L["ShamanElementalBarTextVariable_eogsTime"], printInSettings = true, color = false },

		{ variable = "$pfTime", description = L["ShamanElementalBarTextVariable_pfTime"], printInSettings = true, color = false }]]
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
		
		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["ShamanEnhancementBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["ShamanEnhancementBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["ShamanEnhancementBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$maelstromWeapon", description = L["ShamanEnhancementBarTextVariable_maelstromWeapon"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromWeaponMax", description = L["ShamanEnhancementBarTextVariable_maelstromWeaponMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$ascendanceTime", description = L["ShamanEnhancementBarTextVariable_ascendanceTime"], printInSettings = true, color = false },
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
		
		{ variable = "$health", description = L["BarTextVariableHealth"], printInSettings = true, color = false },
		{ variable = "$healthMax", description = L["BarTextVariableHealthMax"], printInSettings = true, color = false },
		{ variable = "$healthPercent", description = L["BarTextVariableHealthPercent"], printInSettings = true, color = false },

		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["ShamanRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["ShamanRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["ShamanRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["ShamanRestorationBarTextVariable_casting"], printInSettings = true, color = false },
		
		{ variable = "$ascendanceTime", description = L["ShamanRestorationBarTextVariable_ascendanceTime"], printInSettings = true, color = false },
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
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Enhancement uses secondary bar (Maelstrom Weapon). maxResource2 must already be populated
	-- by the snapshot pipeline (EventRegistration -> UpdateResourceValues) before this runs.
	if barGroups and barGroups.secondary and TRB.Data.character.specId == 2 then
		local maxStacks = TRB.Data.character.maxResource2
		if maxStacks == nil or maxStacks == 0 then
			maxStacks = barGroups.secondary.maxNodes or 10
		end
		TRB.Data.character.maxResource2 = maxStacks
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

	-- Enhancement uses secondary bar (Maelstrom Weapon); Elemental/Restoration do not.
	if barGroups and barGroups.secondary then
		if TRB.Data.character.specId == 2 and TRB.Details.addonData.build ~= "64914" then
			local maxStacks = TRB.Data.character.maxResource2 or 10
			
			-- Determine display node count based on compressed view setting
			local displayNodes = maxStacks
			if settings.colors and settings.colors.comboPoints and settings.colors.comboPoints.compressedView then
				displayNodes = math.ceil(maxStacks / 2) -- 10 stacks -> 5 nodes
			end
			
			barGroups.secondary:RebuildNodes(displayNodes, settings)
		else
			barGroups.secondary:Hide()
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
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
		if sharedSettings.colors.text.overThreshold.enabled and snapshotData.attributes.resource >= maelstromThreshold then
			currentMaelstromColor = sharedSettings.colors.text.overThreshold.color
			castingMaelstromColor = sharedSettings.colors.text.overThreshold.color
		end
	end

	--$maelstrom
	local currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, snapshotData.attributes.resource)
	--$casting
	local castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, snapshotData.casting.resourceFinal)
	
	--[[
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

	-- Mana lookups
	local currentManaColor = (sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color) or sharedSettings.colors.text.current.color or "FF0000FF"
	local normalizedMana = UnitPower("player", Enum.PowerType.Mana)
	local normalizedManaMax = UnitPowerMax("player", Enum.PowerType.Mana)

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedManaMax))

	--$manaPercent
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMaelstrom
	lookup["$maelstrom"] = currentMaelstrom
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$maelstromMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingMaelstrom
	lookup["$ascendanceTime"] = ascendanceTime
	--[[
	lookup["$ifStacks"] = icefuryStacks
	lookup["$ifTime"] = icefuryTime
	lookup["$skStacks"] = stormkeeperStacks
	lookup["$skTime"] = stormkeeperTime
	lookup["$eogsTime"] = eogsTime
	lookup["$pfTime"] = pfTime]]
	lookup["$mana"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$manaPercent"] = manaPercent

	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$maelstrom"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$maelstromMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	--[[
	lookupLogic["$ifStacks"] = icefuryStacks
	lookupLogic["$ifTime"] = icefuryTime
	lookupLogic["$skStacks"] = stormkeeperStacks
	lookupLogic["$skTime"] = _stormkeeperTime
	lookupLogic["$eogsTime"] = _eogsTime
	lookupLogic["$pfTime"] = _pfTime]]
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$manaMax"] = normalizedManaMax
	lookupLogic["$manaPercent"] = _manaPercent

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

	local currentManaColor = specSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
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

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	----------------------------	

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$manaMax"] = TRB.Data.character.maxResource
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$ascendanceTime"] = ascendanceTime
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$maelstromWeapon"] = snapshotData.attributes.resource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	lookup["$maelstromWeaponMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$mana"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$ascendanceTime"] = _ascendanceTime
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$maelstromWeapon"] = snapshotData.attributes.resource2
	lookupLogic["$maelstromWeaponMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
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

	local currentManaColor = sharedSettings.colors.text.current.color
	local castingManaColor = sharedSettings.colors.text.casting.color

	--$mana
	local manaPrecision = specSettings.manaPrecision or 1
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

	--$ascendanceTime
	local _ascendanceTime = snapshots[spells.ascendance.id].buff:GetRemainingTime(currentTime)
	local ascendanceTime = TRB.Functions.BarText:TimerPrecision(_ascendanceTime)

	----------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentMana
	lookup["$mana"] = currentMana
	lookup["$resourceMax"] = manaMax
	lookup["$manaMax"] = manaMax
	lookup["$resourcePercent"] = manaPercent
	lookup["$manaPercent"] = manaPercent
	lookup["$casting"] = castingMana
	lookup["$ascendanceTime"] = ascendanceTime
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
	-- Do nothing for now
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
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
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.shaman
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.elemental
		local specCacheSettings = TRB.Data.specCache.elemental.settings
		UpdateSnapshot_Elemental()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barBorderColor = specSettings.colors.bar.border
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				local barColor = specSettings.colors.bar.base

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetResourceFrame()
				local thresholds = primaryNode:GetThresholds()

				local anyUsable = false
				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
						TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
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
								if isUsable then
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
						elseif isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						if isUsable then
							thresholdColor = specCacheSettings.colors.threshold.over.color
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
						end
					end
					
					if resourceAmount >= maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end
					
					if thresholds[thresholdId] then
						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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

				if anyUsable then
					barColor = specSettings.colors.bar.earthShock
					if specSettings.colors.bar.flashEnabled then
						TRB.Functions.Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					else
						barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					end

					if specSettings.audio.esReady.enabled and snapshotData.audio.playedEsCue == false then
						snapshotData.audio.playedEsCue = true
						PlaySoundFile(specSettings.audio.esReady.sound, coreSettings.audio.channel.channel)
					end
				else
					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
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

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
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

			-- Mana bar update (Balance only)
			if specSettings.displayBar.mana ~= nil and specSettings.displayBar.mana ~= "never" then
				refreshText = true
				local manaNode = barGroups and barGroups.mana and barGroups.mana:GetNode(1)
				if manaNode then
					local currentMana = snapshotData.attributes.mana or UnitPower("player", Enum.PowerType.Mana) or 0
					local maxMana = snapshotData.attributes.manaMax or UnitPowerMax("player", Enum.PowerType.Mana) or 1
					manaNode:SetMinMax(0, maxMana)
					manaNode:SetValue(currentMana)
					manaNode:SetColor(specSettings.colors.manaBar.bar.color)
					manaNode:SetBorderColor(specSettings.colors.manaBar.border.color)
					manaNode:SetBackgroundColorFromString(specSettings.colors.manaBar.background.color)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		if TRB.Data.character.maxResource2 == nil then
			return
		end
		local specSettings = classSettings.enhancement
		local specCacheSettings = TRB.Data.specCache.enhancement.settings
		UpdateSnapshot_Enhancement()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

				barGroups.primary:GetContainerFrame():SetAlpha(1.0)
				
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

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
			end
			
			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				-- Update Maelstrom Weapon stacks using BarNodes
				if TRB.Details.addonData.build ~= "64914" and barGroups.secondary then
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
					local maxStacks = TRB.Data.character.maxResource2 or 10
					local currentStacks = snapshotData.attributes.resource2 or 0
					local compressedView = specSettings.colors.comboPoints.compressedView
					local displayNodes = compressedView and math.ceil(maxStacks / 2) or maxStacks
					
					local cpBorderColor = specSettings.colors.comboPoints.border
					
					if compressedView then
						-- Compressed view: 5 nodes representing 10 stacks
						-- Stacks 1-5 fill nodes left-to-right with base color
						-- Stacks 6-10 overwrite nodes left-to-right with overflow color
						local firstHalf = math.min(currentStacks, 5)  -- How many of stacks 1-5 we have
						local secondHalf = math.max(0, currentStacks - 5)  -- How many of stacks 6-10 we have
						
						for nodeIndex = 1, displayNodes do
							local stackNode = barGroups.secondary:GetNode(nodeIndex)
							if stackNode then
								local cpColor = specSettings.colors.comboPoints.base
								local isFilled = false
								local isOverflow = false
								
								-- Determine if this node is filled and whether it's overflow
								if nodeIndex <= secondHalf then
									-- This node is in the overflow range (stacks 6-10)
									isFilled = true
									isOverflow = true
									cpColor = specSettings.colors.comboPoints.overflowBase.color
								elseif nodeIndex <= firstHalf then
									-- This node is in the base range (stacks 1-5)
									isFilled = true
									isOverflow = false
									cpColor = specSettings.colors.comboPoints.base
								end
								
								-- Apply penultimate/final colors
								if isFilled and isOverflow then
									-- Check for penultimate (9 stacks) or final (10 stacks)
									if currentStacks == maxStacks then
										-- At max stacks (10): sameColor makes all overflow nodes final, otherwise only node 5
										if specSettings.comboPoints.sameColor or nodeIndex == displayNodes then
											cpColor = specSettings.colors.comboPoints.final
										elseif nodeIndex == displayNodes - 1 then
											cpColor = specSettings.colors.comboPoints.penultimate
										end
									elseif currentStacks == maxStacks - 1 then
										-- At penultimate stacks (9): sameColor makes all overflow nodes penultimate
										if specSettings.comboPoints.sameColor or nodeIndex == secondHalf then
											cpColor = specSettings.colors.comboPoints.penultimate
										end
									end
								end
								
								if isFilled then
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. nodeIndex, stackNode, 1, 1)
								else
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. nodeIndex, stackNode, 0, 1)
								end
								
								stackNode:SetBorderColor(cpBorderColor)
								stackNode:SetColor(cpColor)
								stackNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
							end
						end
					else
						-- Standard view: 10 nodes, one per stack
						-- Nodes 1-5 use base color, nodes 6-10 use overflow/penultimate/final
						local halfPoint = math.ceil(maxStacks / 2) -- 5 for 10 stacks
						
						for x = 1, maxStacks do
							local cpColor = specSettings.colors.comboPoints.base
							local isFilled = currentStacks >= x

							local stackNode = barGroups.secondary:GetNode(x)
							if stackNode then
								if isFilled then
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, stackNode, 1, 1)
									
									-- Determine color based on position and sameColor setting
									if specSettings.comboPoints.sameColor then
										-- sameColor: all filled nodes share the highest applicable color
										if currentStacks == maxStacks then
											cpColor = specSettings.colors.comboPoints.final
										elseif currentStacks == maxStacks - 1 then
											cpColor = specSettings.colors.comboPoints.penultimate
										elseif currentStacks > halfPoint then
											cpColor = specSettings.colors.comboPoints.overflowBase.color
										else
											cpColor = specSettings.colors.comboPoints.base
										end
									else
										-- Per-node coloring
										if x == maxStacks then
											cpColor = specSettings.colors.comboPoints.final
										elseif x == maxStacks - 1 then
											cpColor = specSettings.colors.comboPoints.penultimate
										elseif x > halfPoint then
											cpColor = specSettings.colors.comboPoints.overflowBase.color
										else
											cpColor = specSettings.colors.comboPoints.base
										end
									end
								else
									TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, stackNode, 0, 1)
								end
								
								stackNode:SetBorderColor(cpBorderColor)
								stackNode:SetColor(cpColor)
								stackNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)
							end
						end
					end
				end
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
		local specSettings = classSettings.restoration
		local specCacheSettings = TRB.Data.specCache.restoration.settings
		UpdateSnapshot_Restoration()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
				local currentResource = snapshotData.attributes.resourceModified
				local barBorderColor = specSettings.colors.bar.border
				
				TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

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

				primaryNode:SetBorderColor(barBorderColor)
				primaryNode:SetColor(barColor)
				primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
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
		specCache.elemental.talents:GetTalents()
		FillSpellData_Elemental()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.elemental)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Elemental
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.elemental.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		lookup["#chainLightning"] = spells.chainLightning.icon
		lookup["#elementalBlast"] = spells.elementalBlast.icon
		lookup["#eogs"] = spells.echoesOfGreatSundering.icon
		lookup["#frostShock"] = spells.frostShock.icon
		lookup["#icefury"] = spells.icefury.icon
		lookup["#lavaBurst"] = spells.lavaBurst.icon
		lookup["#lightningBolt"] = spells.lightningBolt.icon
		lookup["#primalFracture"] = spells.primalFracture.icon
		lookup["#stormkeeper"] = spells.stormkeeper.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()
		
		if TRB.Data.barConstructedForSpec ~= "elemental" then
			talents = specCache.elemental.talents
			TRB.Data.barConstructedForSpec = "elemental"
			ConstructResourceBar(specCache.elemental.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.enhancement.talents:GetTalents()
		FillSpellData_Enhancement()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.enhancement)
			
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]		
		local spells = spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Enhancement
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.enhancement.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

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

		TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.restoration.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = spells.ascendance.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

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
						settings.shaman.elemental.displayText.barText = TRB.Options.Shaman.ElementalLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.enhancement == nil or
						TwintopInsanityBarSettings.shaman.enhancement.displayText == nil then
						settings.shaman.enhancement.displayText.barText = TRB.Options.Shaman.EnhancementLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.shaman == nil or
						TwintopInsanityBarSettings.shaman.restoration == nil or
						TwintopInsanityBarSettings.shaman.restoration.displayText == nil then
						settings.shaman.restoration.displayText.barText = TRB.Options.Shaman.RestorationLoadDefaultBarTextSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.shaman ~= true then
						TRB.Data.settings.shaman.elemental.displayText.barText = TRB.Options.Shaman.ElementalLoadDefaultBarTextSettings()
						TRB.Data.settings.shaman.enhancement.displayText.barText = TRB.Options.Shaman.EnhancementLoadDefaultBarTextSettings()
						TRB.Data.settings.shaman.restoration.displayText.barText = TRB.Options.Shaman.RestorationLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.shaman = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Shaman"])
					end
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
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "elemental"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Maelstrom, false)
	elseif TRB.Data.character.specId == 2 then
		TRB.Data.character.specName = "enhancement"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		
		if TRB.Details.addonData.build ~= "64914" then
			local maxComboPoints = 10
			local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName] and TRB.Data.specCache[TRB.Data.character.specName].settings
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.secondary and sharedSettings then
					barGroups.secondary:Show()
					TRB.Functions.Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]
		TRB.Data.character.specName = "restoration"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.shaman.elemental then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Maelstrom
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = nil
		TRB.Data.resource2Id = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.shaman.enhancement then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		if TRB.Details.addonData.build ~= "64914" then
			TRB.Data.resource2 = "SPELL"
			TRB.Data.resource2Id = 344179
			TRB.Data.resource2Factor = 1
		else
			TRB.Data.resource2 = nil
			TRB.Data.resource2Id = nil
		end
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.shaman.restoration then
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
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

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
			-- Only Enhancement (specId == 2) uses the secondary (Maelstrom Weapon) bar
			local showSecondary = false
			if not forceHideAll and TRB.Data.character.specId == 2 and TRB.Details.addonData.build ~= "64914" then
				if sharedSettings.displayBar.secondary == "always" then
					showSecondary = true
				elseif sharedSettings.displayBar.secondary == "combat" then
					showSecondary = affectingCombat or inVehicle
				end
				-- "never" means showSecondary stays false
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
					-- Respect compressed view setting for node count
					local maxStacks = TRB.Data.character.maxResource2 or 10
					local displayNodes = maxStacks
					if sharedSettings.colors and sharedSettings.colors.comboPoints and sharedSettings.colors.comboPoints.compressedView then
						displayNodes = math.ceil(maxStacks / 2)
					end
					barGroups.secondary:ShowNodes(displayNodes)
				else
					barGroups.secondary:Hide()
				end
			end

			-- Determine health bar visibility independently
			local showHealth = false
			if not forceHideAll and sharedSettings.displayBar.health ~= nil then
				if sharedSettings.displayBar.health == "always" then
					showHealth = true
				elseif sharedSettings.displayBar.health == "combat" then
					showHealth = affectingCombat or inVehicle
				end
				-- "never" means showHealth stays false
			end

			-- Apply health bar visibility
			if barGroups and barGroups.health then
				if showHealth then
					barGroups.health:Show()
				else
					barGroups.health:Hide()
				end
			end

			-- Determine mana bar visibility independently (Elemental only)
			local showMana = false
			if not forceHideAll and TRB.Data.character.specId == 1 and sharedSettings.displayBar.mana ~= nil then
				if sharedSettings.displayBar.mana == "always" then
					showMana = true
				elseif sharedSettings.displayBar.mana == "combat" then
					showMana = affectingCombat or inVehicle
				end
				-- "never" means showMana stays false
			end

			-- Apply mana bar visibility
			if barGroups and barGroups.mana then
				if showMana then
					barGroups.mana:Show()
				else
					barGroups.mana:Hide()
				end
			end

			-- Track if any bar is showing
			snapshotData.attributes.isTracking = showPrimary or showSecondary or showHealth or showMana
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
			if barGroups and barGroups.mana then
				barGroups.mana:Hide()
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
		if barGroups and barGroups.mana then
			barGroups.mana:Hide()
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
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$maelstromMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw > 0 or snapshotData.casting.spellId == spells.chainLightning.id) then
				valid = true
			end
		--[[
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
		elseif var == "$mana" then
			-- Do not compare snapshotData.attributes.mana as it may be a secret value
			valid = false
		elseif var == "$manaMax" then
			valid = true
		elseif var == "$manaPercent" then
			-- Do not compare mana percent as it may be a secret value
			valid = false
		end
	elseif TRB.Data.character.specId == 2 then --Enhancement
		if var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$resource" or var == "$mana" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$comboPoints" or var == "$maelstromWeapon" then
			if TRB.Details.addonData.build ~= "64914" then
				valid = true
			end
		elseif var == "$comboPointsMax"or var == "$maelstromWeaponMax" then
			if TRB.Details.addonData.build ~= "64914" then
				valid = true
			end
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then
		if var == "$resource" or var == "$mana" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$ascendanceTime" then
			if snapshots[spells.ascendance.id].buff.isActive then
				valid = true
			end
		end
	else
		valid = false
	end

	-- Health variables are valid for all specs
	if var == "$health" or var == "$healthMax" or var == "$healthPercent" then
		valid = true
	end
	

	-- Mana variables (Balance only)
	if TRB.Data.character.specId == 1 then
		if var == "$mana" or var == "$manaMax" or var == "$manaPercent" then
			valid = true
		end
	end

	return valid
end

---Gets the Frame for the requested bar text variable, if the frame is currently enabled, and if it is visible.
---@param relativeToFrame string
---@return Frame? # Relative to Frame
---@return boolean # Is Enabled?
---@return boolean # Is Visible?
function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
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

	-- Handle secondary resources (Maelstrom Weapon stacks for Enhancement)
	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local stackNode = barGroups.secondary:GetNode(comboPoint)
			if stackNode then
				local isVisible = barGroups.secondary.isVisible and stackNode.isVisible
				return stackNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	-- Handle health bar
	if normalizedRelativeFrame == "HealthBar" or normalizedRelativeFrame == "Health" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	-- Handle mana bar (Elemental only)
	if normalizedRelativeFrame == "ManaBar" or normalizedRelativeFrame == "Mana" then
		if barGroups and barGroups.mana then
			local manaNode = barGroups.mana:GetNode(1)
			if manaNode then
				local isVisible = barGroups.mana.isVisible and manaNode.isVisible
				return manaNode:GetResourceFrame(), true, isVisible
			end
		end
		return nil, true, false
	end

	return nil, true, false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3 then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	UpdateResourceBar()
end