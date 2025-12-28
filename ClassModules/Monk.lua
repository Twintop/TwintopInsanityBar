local _, TRB = ...
if TRB.Data.character.classId ~= 10 then --Only do this if we're on a Monk!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	brewmaster = TRB.Classes.SpecCache:New(),
	mistweaver = TRB.Classes.SpecCache:New(),
	windwalker = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Brewmaster
	specCache.brewmaster.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.brewmaster.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		maxResource2 = 0,
		effects = {
		},
		items = {}
	}
	
	specCache.brewmaster.spellsData.spells = TRB.Classes.Monk.BrewmasterSpells:New()
	---@type TRB.Classes.Monk.BrewmasterSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.brewmaster.spellsData.spells

	---@type TRB.Classes.Snapshot
	specCache.brewmaster.snapshotData.snapshots[spells.detox.id] = TRB.Classes.Snapshot:New(spells.detox)
	---@type TRB.Classes.Snapshot
	specCache.brewmaster.snapshotData.snapshots[spells.expelHarm.id] = TRB.Classes.Snapshot:New(spells.expelHarm)
	---@type TRB.Classes.Snapshot
	specCache.brewmaster.snapshotData.snapshots[spells.paralysis.id] = TRB.Classes.Snapshot:New(spells.paralysis)
	---@type TRB.Classes.Snapshot
	specCache.brewmaster.snapshotData.snapshots[spells.cracklingJadeLightning.id] = TRB.Classes.Snapshot:New(spells.cracklingJadeLightning)
	---@type TRB.Classes.Snapshot
	specCache.brewmaster.snapshotData.snapshots[spells.kegSmash.id] = TRB.Classes.Snapshot:New(spells.kegSmash)

	specCache.brewmaster.snapshotData.attributes.resourceRegen = 0
	specCache.brewmaster.snapshotData.audio = {
	}

	specCache.brewmaster.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Mistweaver
	specCache.mistweaver.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
		},
	}

	specCache.mistweaver.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
		items = {
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
	---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.vivaciousVivification.id] = TRB.Classes.Snapshot:New(spells.vivaciousVivification, nil, "always")
	--[[---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.sheilunsGift.id] = TRB.Classes.Snapshot:New(spells.sheilunsGift)
	---@type TRB.Classes.Snapshot
	specCache.mistweaver.snapshotData.snapshots[spells.heartOfTheJadeSerpent.id] = TRB.Classes.Snapshot:New(spells.heartOfTheJadeSerpent)]]

	specCache.mistweaver.barTextVariables = {
		icons = {},
		values = {}
	}


	-- Windwalker
	specCache.windwalker.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		isPvp = false
	}

	specCache.windwalker.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
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
	specCache.windwalker.snapshotData.snapshots[spells.danceOfChiJi.id] = TRB.Classes.Snapshot:New(spells.danceOfChiJi)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.heartOfTheJadeSerpent.id] = TRB.Classes.Snapshot:New(spells.heartOfTheJadeSerpent)
	---@type TRB.Classes.Snapshot
	specCache.windwalker.snapshotData.snapshots[spells.flurryCharge.id] = TRB.Classes.Snapshot:New(spells.flurryCharge)

	specCache.windwalker.barTextVariables = {
		icons = {},
		values = {}
	}
end

local function Setup_Brewmaster()
	TRB.Functions.Character:FillSpecializationCacheSettings("monk", "brewmaster")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Brewmaster using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Monk.BarGroupsFactory:CreateForSpec(1)
end

local function FillSpellData_Brewmaster()
	Setup_Brewmaster()
	---@type TRB.Classes.SpellsData
	specCache.brewmaster.spellsData:FillSpellData()
	local spells = specCache.brewmaster.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.brewmaster.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true }
	}
	specCache.brewmaster.barTextVariables.values = {
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

		{ variable = "$energy", description = L["MonkBrewmasterBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["MonkBrewmasterBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MonkBrewmasterBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$stagger", description = L["MonkBrewmasterBarTextVariable_stagger"], printInSettings = true, color = false },
		{ variable = "$staggerPercent", description = L["MonkBrewmasterBarTextVariable_staggerPercent"], printInSettings = true, color = false },
	}
end

local function Setup_Mistweaver()
	TRB.Functions.Character:FillSpecializationCacheSettings("monk", "mistweaver", true)
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Mistweaver using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Monk.BarGroupsFactory:CreateForSpec(2)
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
		
		{ variable = "#hotjs", icon = spells.heartOfTheJadeSerpent.icon, description = spells.heartOfTheJadeSerpent.name, printInSettings = true },
		{ variable = "#manaTea", icon = spells.manaTea.icon, description = spells.manaTea.name, printInSettings = true },
		{ variable = "#sheilunsGift", icon = spells.sheilunsGift.icon, description = spells.sheilunsGift.name, printInSettings = true },
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
	}
end

local function Setup_Windwalker()
	TRB.Functions.Character:FillSpecializationCacheSettings("monk", "windwalker")
	
	-- Destroy existing bar groups before creating new ones
	TRB.Functions.Bar:DestroyBarGroups()
	
	-- Create bar groups for Windwalker using new OOP system
	TRB.Frames.barGroups = TRB.Classes.Monk.BarGroupsFactory:CreateForSpec(3)
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
		{ variable = "#flurryCharge", icon = spells.flurryCharge.icon, description = spells.flurryCharge.name, printInSettings = false },
		{ variable = "#hotjs", icon = spells.heartOfTheJadeSerpent.icon, description = spells.heartOfTheJadeSerpent.name, printInSettings = true },
		{ variable = "#paralysis", icon = spells.paralysis.icon, description = spells.paralysis.name, printInSettings = true },
		{ variable = "#risingSunKick", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = true },
		{ variable = "#rsk", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = false },
		{ variable = "#spinningCraneKick", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = true },
		{ variable = "#sck", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = false },
		{ variable = "#strikeOfTheWindlord", icon = spells.strikeOfTheWindlord.icon, description = spells.strikeOfTheWindlord.name, printInSettings = true },
		{ variable = "#tigerPalm", icon = spells.tigerPalm.icon, description = spells.tigerPalm.name, printInSettings = true },
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
		
		{ variable = "$chi", description = L["MonkWindwalkerBarTextVariable_chi"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$chiMax", description = L["MonkWindwalkerBarTextVariable_chiMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	}
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	
	if TRB.Data.character.specId == 1 then -- Brewmaster
	elseif TRB.Data.character.specId == 2 then -- Mistweaver
	elseif TRB.Data.character.specId == 3 then -- Windwalker
		targetData:UpdateTrackedSpells(currentTime)
	end
end

local function TargetsCleanup(clearAll)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups

	-- Create thresholds on the primary BarNode
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

	-- Handle secondary bar based on spec
	if barGroups and barGroups.secondary then
		if TRB.Data.character.specId == 1 then -- Brewmaster uses Stagger bar with thresholds
			local maxStaggerNodes = 1
			TRB.Data.character.maxResource2 = maxStaggerNodes
			
			-- Set the node count and layout for Stagger bar
			barGroups.secondary:SetNodeCount(maxStaggerNodes)
			barGroups.secondary:SetLayout(settings.comboPoints.spacing, settings.comboPoints.fullWidth, "HORIZONTAL")
			barGroups.secondary:Show()
			
			-- Apply layout to position the Stagger bar correctly
			barGroups.secondary:ApplyLayout(
				settings.bar.width,
				settings.comboPoints.width,
				settings.comboPoints.height,
				settings.comboPoints.border
			)
			
			-- Set up the Stagger bar node with textures and colors
			local frameLevels = TRB.Data.constants.frameLevels
			local staggerNode = barGroups.secondary:GetNode(1)
			if staggerNode then
				staggerNode:SetTextures(
					settings.textures.comboPointsBar,
					settings.textures.comboPointsBorder,
					settings.textures.comboPointsBackground
				)
				staggerNode:SetBorderColor(settings.colors.comboPoints.border)
				staggerNode:SetBackgroundColorFromString(settings.colors.comboPoints.background)
				staggerNode:SetColor(settings.colors.comboPoints.base)
				staggerNode:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
				
				-- Create thresholds on the Stagger bar (for Medium and Heavy Stagger thresholds)
				staggerNode:ClearThresholds()
				for _ = 1, 2 do
					local thresholdFrame = CreateFrame("Frame", nil, staggerNode:GetResourceFrame())
					TRB.Functions.Threshold:ResetThresholdLineComboPoint(thresholdFrame, settings)
					staggerNode:RegisterThreshold(thresholdFrame)
				end
			end

		elseif TRB.Data.character.specId == 3 then -- Windwalker uses Chi
			local maxChi = TRB.Data.character.maxResource2
			if maxChi == nil or maxChi == 0 then
				maxChi = barGroups.secondary.maxNodes or 5
			end
			TRB.Data.character.maxResource2 = maxChi
			
			-- Ensure we have enough nodes for the max chi
			barGroups.secondary:SetMaxNodes(maxChi)
			
			-- Set the node count and layout for Chi
			barGroups.secondary:SetNodeCount(maxChi)
			barGroups.secondary:SetLayout(settings.comboPoints.spacing, settings.comboPoints.fullWidth, "HORIZONTAL")
			barGroups.secondary:Show()
			
			-- Apply layout to position all Chi nodes correctly
			barGroups.secondary:ApplyLayout(
				settings.bar.width,
				settings.comboPoints.width,
				settings.comboPoints.height,
				settings.comboPoints.border
			)
			
			-- Set up Chi nodes with textures and colors
			local frameLevels = TRB.Data.constants.frameLevels
			for i = 1, maxChi do
				local node = barGroups.secondary:GetNode(i)
				if node then
					node:SetTextures(
						settings.textures.comboPointsBar,
						settings.textures.comboPointsBorder,
						settings.textures.comboPointsBackground
					)
					node:SetMinMax(0, 1)
					node:SetBorderColor(settings.colors.comboPoints.border)
					node:SetBackgroundColorFromString(settings.colors.comboPoints.background)
					node:SetColor(settings.colors.comboPoints.base)
					node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
				end
			end
		else
			barGroups.secondary:Hide()
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

local function RefreshLookupData_Brewmaster()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.brewmaster
	local sharedSettings = TRB.Data.specCache["brewmaster"].settings
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]

	local currentEnergyColor = sharedSettings.colors.text.current.color
	local castingEnergyColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
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

	--$energy
	local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, snapshotData.attributes.resource)
	--$casting
	local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, snapshotData.casting.resourceFinal)

	--$stagger and $staggerPercent
	local _stagger = snapshotData.attributes.stagger or 0
	local _staggerPercent = snapshotData.attributes.staggerPercent or 0
	local staggerColor = specSettings.colors.comboPoints.base
	if _staggerPercent >= STAGGER_STATES.RED.threshold then
		staggerColor = specSettings.colors.comboPoints.staggerHeavy
	elseif _staggerPercent >= STAGGER_STATES.YELLOW.threshold then
		staggerColor = specSettings.colors.comboPoints.staggerMedium
	end

	local stagger = string.format("|c%s%s|r", staggerColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_stagger))
	local staggerPercent = string.format("|c%s%.1f|r", staggerColor, _staggerPercent * 100)

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentEnergy
	lookup["$energy"] = currentEnergy
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingEnergy
	lookup["$stagger"] = stagger
	lookup["$staggerPercent"] = staggerPercent
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$stagger"] = _stagger
	lookupLogic["$staggerPercent"] = _staggerPercent
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Mistweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.mistweaver
	local sharedSettings = TRB.Data.specCache["mistweaver"].settings
	local currentTime = GetTime()
	local normalizedMana = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentManaColor = TRB.Data.settings.monk.mistweaver.colors.text.current.color
	local castingManaColor = TRB.Data.settings.monk.mistweaver.colors.text.casting.color

	--$mana
	local manaPrecision = TRB.Data.settings.monk.mistweaver.manaPrecision or 1
	local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana))-- TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
	--$casting
	local _castingMana = snapshotData.casting.resourceFinal
	local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))-- TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

	--$manaMax
	local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))-- TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

	--$manaPercent
	--[[local maxResource = TRB.Data.character.maxResource

	if maxResource == 0 then
		maxResource = 1
	end]]
	local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
	local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)
	local manaPercent = string.format("|c%s%." .. manaPrecision .. "f|r", currentManaColor, manaPercentRaw)--TRB.Functions.Number:RoundTo(manaPercentRaw, manaPrecision, "floor"))

	----------

	local lookup = TRB.Data.lookup or {}
	lookup["$mana"] = currentMana
	lookup["$resource"] = currentMana
	lookup["$manaMax"] = manaMax
	lookup["$resourceMax"] = manaMax
	lookup["$manaPercent"] = manaPercent
	lookup["$resourcePercent"] = manaPercent
	lookup["$casting"] = castingMana
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$manaMax"] = TRB.Data.character.maxResource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$mana"] = normalizedMana
	lookupLogic["$resource"] = normalizedMana
	lookupLogic["$manaPercent"] = _manaPercent
	lookupLogic["$resourcePercent"] = _manaPercent
	lookupLogic["$casting"] = _castingMana
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Windwalker()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.monk.windwalker
	local sharedSettings = TRB.Data.specCache["windwalker"].settings
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local normalizedEnergy = snapshotData.attributes.resourceModified-- / TRB.Data.resourceFactor

	local currentEnergyColor = sharedSettings.colors.text.current.color
	local castingEnergyColor = sharedSettings.colors.text.casting.color
	
	if TRB.Data.character.inCombat then
		if sharedSettings.colors.text.overThreshold.enabled then
			local _overThreshold = false
			for _, spell --[[@as TRB.Classes.SpellThreshold]] in ipairs(TRB.Data.cache.thresholdSpells) do
				if spell ~= nil and spell.resource and (spell.baseline or talents.talents[spell.id]:IsActive()) and spell:GetPrimaryResourceCost() >= snapshotData.attributes.resource then
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

	--$energy
	local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
	local _normalizedEnergy = normalizedEnergy
	local currentEnergy = string.format("|c%s%s|r", currentEnergyColor, _normalizedEnergy)-- TRB.Functions.Number:RoundTo(normalizedAstralPower, resourcePrecision, "floor"))
	--$casting
	local castingEnergy = string.format("|c%s%s|r", castingEnergyColor, TRB.Functions.Number:RoundTo(snapshotData.casting.resourceFinal, resourcePrecision, "floor"))

	----------------------------

	local lookup = TRB.Data.lookup or {}
	lookup["$resource"] = currentEnergy
	lookup["$energy"] = currentEnergy
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$energyMax"] = TRB.Data.character.maxResource
	lookup["$casting"] = castingEnergy
	lookup["$chi"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$chiMax"] = TRB.Data.character.maxResource2
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$energy"] = snapshotData.attributes.resource
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$energyMax"] = TRB.Data.character.maxResource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$chi"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$chiMax"] = TRB.Data.character.maxResource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
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

	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
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
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.expelHarm.castId then
				local cooldown = spells.expelHarm.cooldown

				snapshotData.snapshots[spells.expelHarm.id].cooldown:InitializeCustom(cooldown, currentTime)
			elseif spellId == spells.paralysis.castId then
				local cooldown = spells.paralysis.cooldown

				if talents:IsTalentActive(spells.ancientArts) then
					cooldown = cooldown + spells.ancientArts.attributes.cooldownMod
				end

				snapshotData.snapshots[spells.paralysis.id].cooldown:InitializeCustom(cooldown, currentTime)
			elseif spellId == spells.detox.castId then -- This doesn't actually trigger a CD if it doesn't dispel anything, but we have no way of knowing that here
				local cooldown = spells.detox.cooldown

				snapshotData.snapshots[spells.detox.id].cooldown:InitializeCustom(cooldown, currentTime)
			end
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.cracklingJadeLightning.castId then
				if talents:IsTalentActive(spells.jadeFlash) then
					local cooldown = spells.jadeFlash.cooldown

					snapshotData.snapshots[spells.cracklingJadeLightning.id].cooldown:InitializeCustom(cooldown, currentTime)
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Mistweaver()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			local spells = spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
			if spellId == spells.soothingMist.id then
				local manaCost = -spells.soothingMist:GetPrimaryResourceCost(true)

				snapshotData.casting.spellId = spells.soothingMist.id
				snapshotData.casting.startTime = currentTime
				snapshotData.casting.resourceRaw = manaCost
				snapshotData.casting.icon = spells.soothingMist.icon
			end
			
			UpdateCastingResourceFinal_Mistweaver()
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		if spellId == spells.cracklingJadeLightning.id then
			snapshotData.casting.spellId = spells.cracklingJadeLightning.id
			snapshotData.casting.startTime = currentTime
			snapshotData.casting.resourceRaw = -spells.cracklingJadeLightning:GetPrimaryResourceCost()
			snapshotData.casting.icon = spells.cracklingJadeLightning.icon
			UpdateCastingResourceFinal()
		end
	end
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	--local currentTime = GetTime()
end

local function UpdateSnapshot_Brewmaster()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	UpdateSnapshot()

	snapshotData.attributes.maxHealth = UnitHealthMax("player")
	snapshotData.attributes.stagger = UnitStagger("player")
	snapshotData.attributes.staggerPercent = snapshotData.attributes.stagger / snapshotData.attributes.maxHealth

	snapshots[spells.expelHarm.id].cooldown:GetRemainingTime()
	snapshots[spells.detox.id].cooldown:GetRemainingTime()
	snapshots[spells.paralysis.id].cooldown:GetRemainingTime()
	snapshots[spells.cracklingJadeLightning.id].cooldown:GetRemainingTime()
end

local function UpdateSnapshot_Mistweaver()
	UpdateSnapshot()
end

local function UpdateSnapshot_Windwalker()
	UpdateSnapshot()
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.monk
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups
	local primaryNode = barGroups and barGroups.primary and barGroups.primary:GetNode(1)

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end
	
	if TRB.Data.character.specId == 1 then
		local specSettings = classSettings.brewmaster
		local specCacheSettings = TRB.Data.specCache.brewmaster.settings
		UpdateSnapshot_Brewmaster()

		if barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		end
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end
				
				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
					
					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetResourceFrame()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						-- Create threshold on-demand if missing
						if thresholds[thresholdId] == nil then
							local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
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

						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
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

						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end

					local barBorderColor = specSettings.colors.bar.border
					local barColor = specSettings.colors.bar.base

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					primaryNode:SetBorderColor(barBorderColor)
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end

			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				-- Update Stagger bar using BarNodes
				if barGroups and barGroups.secondary then
					local staggerNode = barGroups.secondary:GetNode(1)
					if staggerNode then
						-- Set Stagger bar value as percentage of max health
						staggerNode:SetMinMax(0, snapshotData.attributes.maxHealth)
						staggerNode:SetValue(snapshotData.attributes.stagger)

						local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
						local cpBorderColor = specSettings.colors.comboPoints.border
						local cpColor = specSettings.colors.comboPoints.base

						if snapshotData.attributes.staggerPercent >= STAGGER_STATES.RED.threshold then
							cpColor = specSettings.colors.comboPoints.staggerHeavy
						elseif snapshotData.attributes.staggerPercent >= STAGGER_STATES.YELLOW.threshold then
							cpColor = specSettings.colors.comboPoints.staggerMedium
						end

						staggerNode:SetColor(cpColor)
						staggerNode:SetBorderColor(cpBorderColor)
						staggerNode:SetBackgroundColor(cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha)

						-- Update Stagger thresholds on the BarNode
						local staggerThresholds = staggerNode:GetThresholds()
						local staggerResourceFrame = staggerNode:GetResourceFrame()

						-- Medium Stagger threshold
						if staggerThresholds[1] then
							TRB.Functions.Color:SetThresholdColor(staggerThresholds[1], specSettings.colors.comboPoints.staggerMedium, true)
							TRB.Functions.Threshold:RepositionThresholdComboPoint(specCacheSettings, "comboPointThreshold1", staggerThresholds[1], true, staggerNode:GetContainerFrame(), STAGGER_STATES.YELLOW.threshold * snapshotData.attributes.maxHealth, snapshotData.attributes.maxHealth)
						end

						-- Heavy Stagger threshold
						if staggerThresholds[2] then
							TRB.Functions.Color:SetThresholdColor(staggerThresholds[2], specSettings.colors.comboPoints.staggerHeavy, true)
							TRB.Functions.Threshold:RepositionThresholdComboPoint(specCacheSettings, "comboPointThreshold2", staggerThresholds[2], true, staggerNode:GetContainerFrame(), STAGGER_STATES.RED.threshold * snapshotData.attributes.maxHealth, snapshotData.attributes.maxHealth)
						end
					end
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local specSettings = classSettings.mistweaver
		local specCacheSettings = TRB.Data.specCache.mistweaver.settings
		UpdateSnapshot_Mistweaver()

		if barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		end
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
				local currentResource = snapshotData.attributes.resourceModified

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

					local affectingCombat = TRB.Data.character.inCombat
					local barColor = specSettings.colors.bar.base
					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.vivaciousVivification.enabled and affectingCombat and snapshots[spells.vivaciousVivification.id].buff.isActive then
						barColor = specSettings.colors.bar.vivaciousVivification.color
					end

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					primaryNode:SetBorderColor(barBorderColor)
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		if TRB.Data.character.maxResource2 == nil then
			return
		end
		local specSettings = classSettings.windwalker
		local specCacheSettings = TRB.Data.specCache.windwalker.settings
		UpdateSnapshot_Windwalker()

		if barGroups and barGroups.primary then
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specCacheSettings, barGroups.primary:GetContainerFrame())
		end
		TRB.Functions.Bar:HideResourceBar()

		if snapshotData.attributes.isTracking then
			if specSettings.displayBar.primary ~= "never" then
				refreshText = true
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				if primaryNode then
					TRB.Functions.Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)

					local thresholds = primaryNode:GetThresholds()
					local nodeResourceFrame = primaryNode:GetResourceFrame()

					local pairOffset = 0
					for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
						-- Create threshold on-demand if missing
						if thresholds[thresholdId] == nil then
							local thresholdFrame = CreateFrame("Frame", nil, nodeResourceFrame)
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

						if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
							if spell.id == spells.expelHarm.id then
								if talents:IsTalentActive(spells.combatWisdom) then
									showThreshold = false
								elseif snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
									thresholdColor = specCacheSettings.colors.threshold.unusable.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif isUsable then
									thresholdColor = specCacheSettings.colors.threshold.over.color
								else
									thresholdColor = specCacheSettings.colors.threshold.under.color
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
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

						if spell:Is("TRB.Classes.SpellComboPointThreshold") and
							spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true
							and snapshotData.attributes.resource2 == 0 then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
						end
						
						if resourceAmount >= maxPrimaryBarResourceUnnormalized then
							showThreshold = false
						end

						local isDrawn = TRB.Functions.Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings)
						TRB.Functions.Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeResourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
					end

					local barColor = specSettings.colors.bar.base
					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.heartOfTheJadeSerpentReady.enabled and talents:IsTalentActive(spells.heartOfTheJadeSerpent) and talents:IsTalentActive(spells.strikeOfTheWindlord) and snapshots[spells.strikeOfTheWindlord.id].cooldown:IsUsable() and TRB.Data.character.inCombat then
						barBorderColor = specSettings.colors.bar.heartOfTheJadeSerpentReady.color
					elseif specSettings.colors.bar.heartOfTheJadeSerpent.enabled and snapshots[spells.heartOfTheJadeSerpent.id].buff.isActive then
						barBorderColor = specSettings.colors.bar.heartOfTheJadeSerpent.color
					elseif snapshots[spells.danceOfChiJi.id].buff.isActive then
						barBorderColor = specSettings.colors.bar.borderChiJi
					end

					barGroups.primary:GetContainerFrame():SetAlpha(1.0)
					primaryNode:SetBorderColor(barBorderColor)
					primaryNode:SetColor(barColor)
					primaryNode:SetBackgroundColorFromString(specSettings.colors.bar.background)
				end
			end
			
			if specSettings.displayBar.secondary ~= "never" then
				refreshText = true
				-- Update Chi using BarNodes
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if barGroups and barGroups.secondary then
						local chiNode = barGroups.secondary:GetNode(x)
						if chiNode then
							if snapshotData.attributes.resource2 >= x then
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, chiNode, 1, 1)
								if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							else
								TRB.Functions.Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, chiNode, 0, 1)
							end
							
							chiNode:SetBorderColor(cpBorderColor)
							chiNode:SetColor(cpColor)
							chiNode:SetBackgroundColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
						end
					end
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
		specCache.brewmaster.talents:GetTalents()
		FillSpellData_Brewmaster()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.brewmaster)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Brewmaster
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.brewmaster.settings)

		TRB.Data.lookup = {}
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "brewmaster" then
			talents = specCache.brewmaster.talents
			-- CRITICAL: EventRegistration must be called BEFORE ConstructResourceBar
			-- because ConstructResourceBar calls TriggerResourceBarUpdates() which needs
			-- snapshot data to be initialized.
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "brewmaster"
			ConstructResourceBar(specCache.brewmaster.settings)
		end
	elseif TRB.Data.character.specId == 2 then
		specCache.mistweaver.talents:GetTalents()
		FillSpellData_Mistweaver()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.mistweaver)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Mistweaver
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.mistweaver.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#hotjs"] = spells.heartOfTheJadeSerpent.icon
		lookup["#manaTea"] = spells.manaTea.icon
		lookup["#sheilunsGift"] = spells.sheilunsGift.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "mistweaver" then
			talents = specCache.mistweaver.talents
			-- CRITICAL: EventRegistration must be called BEFORE ConstructResourceBar
			-- because ConstructResourceBar calls TriggerResourceBarUpdates() which needs
			-- snapshot data to be initialized.
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "mistweaver"
			ConstructResourceBar(specCache.mistweaver.settings)
		end
	elseif TRB.Data.character.specId == 3 then
		specCache.windwalker.talents:GetTalents()
		FillSpellData_Windwalker()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.windwalker)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()
		local targetData = TRB.Data.snapshotData.targetData

		TRB.Functions.RefreshLookupData = RefreshLookupData_Windwalker
		TRB.Functions.Bar:UpdateSanityCheckValues(specCache.windwalker.settings)

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
		lookup["#flurryCharge"] = spells.flurryCharge.icon
		lookup["#hotjs"] = spells.heartOfTheJadeSerpent.icon
		lookup["#paralysis"] = spells.paralysis.icon
		lookup["#risingSunKick"] = spells.risingSunKick.icon
		lookup["#rsk"] = spells.risingSunKick.icon
		lookup["#spinningCraneKick"] = spells.spinningCraneKick.icon
		lookup["#sck"] = spells.spinningCraneKick.icon
		lookup["#strikeOfTheWindlord"] = spells.strikeOfTheWindlord.icon
		lookup["#tigerPalm"] = spells.tigerPalm.icon
		lookup["#vivify"] = spells.vivify.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		if TRB.Data.barConstructedForSpec ~= "windwalker" then
			talents = specCache.windwalker.talents
			-- CRITICAL: EventRegistration must be called BEFORE ConstructResourceBar
			-- because ConstructResourceBar calls TriggerResourceBarUpdates() which needs
			-- snapshot data to be initialized.
			TRB.Functions.Class:EventRegistration()
			TRB.Data.barConstructedForSpec = "windwalker"
			ConstructResourceBar(specCache.windwalker.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

	-- EventRegistration is now called inside each spec block before ConstructResourceBar
	-- This ensures snapshot data is populated before the bar is rendered
	if TRB.Data.barConstructedForSpec == nil then
		TRB.Functions.Class:EventRegistration()
	end

	C_Timer.After(0, function()
		C_Timer.After(0.05, function()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Data.barConstructedForSpec ~= nil then
				ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
				TRB.Functions.Character:ResetCaches()
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
	
	if TRB.Data.character.classId == 10 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Monk.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.monk == nil or
						TwintopInsanityBarSettings.monk.brewmaster == nil or
						TwintopInsanityBarSettings.monk.brewmaster.displayText == nil then
						settings.monk.brewmaster.displayText.barText = TRB.Options.Monk.BrewmasterLoadDefaultBarTextSimpleSettings()
					end

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
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)
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

		if TRB.Details.addonData.loaded and TRB.Data.character.specId > 0 then
			if not TRB.Details.addonData.optionsPanelStarted then
				TRB.Details.addonData.optionsPanelStarted = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.settings.core = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["GlobalOptions"], TRB.Data.settings.core)
						TRB.Data.settings.monk.windwalker = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MonkWindwalkerFull"], TRB.Data.settings.monk.windwalker)
						TRB.Data.settings.monk.mistweaver = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["MonkMistweaverFull"], TRB.Data.settings.monk.mistweaver)
						FillSpellData_Windwalker()
						FillSpellData_Mistweaver()

						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Monk.ConstructOptionsPanel(specCache)

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
	TRB.Data.character.className = "monk"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	local maxComboPoints = 0
	local barGroups = TRB.Frames.barGroups
	
	if TRB.Data.character.specId == 1 then
		TRB.Data.character.specName = "brewmaster"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)

		local maxComboPoints = 1
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings

		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		TRB.Data.character.specName = "mistweaver"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
	elseif TRB.Data.character.specId == 3 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Energy, false)
		TRB.Data.character.specName = "windwalker"
		maxComboPoints = UnitPowerMax("player", Enum.PowerType.Chi)
		local sharedSettings = TRB.Data.specCache[TRB.Data.character.specName].settings
	
		if sharedSettings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				if barGroups and barGroups.primary then
					TRB.Functions.Bar:SetPosition(sharedSettings, barGroups.primary:GetContainerFrame())
				end
				-- Rebuild secondary bar layout when chi count changes
				if barGroups and barGroups.secondary then
					barGroups.secondary:SetMaxNodes(maxComboPoints)
					barGroups.secondary:SetNodeCount(maxComboPoints)
					barGroups.secondary:SetLayout(sharedSettings.comboPoints.spacing, sharedSettings.comboPoints.fullWidth, "HORIZONTAL")
					barGroups.secondary:ApplyLayout(
						sharedSettings.bar.width,
						sharedSettings.comboPoints.width,
						sharedSettings.comboPoints.height,
						sharedSettings.comboPoints.border
					)
					-- Apply textures and colors to any newly created nodes
					local frameLevels = TRB.Data.constants.frameLevels
					for i = 1, maxComboPoints do
						local node = barGroups.secondary:GetNode(i)
						if node then
							node:SetTextures(
								sharedSettings.textures.comboPointsBar,
								sharedSettings.textures.comboPointsBorder,
								sharedSettings.textures.comboPointsBackground
							)
							node:SetMinMax(0, 1)
							node:SetBorderColor(sharedSettings.colors.comboPoints.border)
							node:SetBackgroundColorFromString(sharedSettings.colors.comboPoints.background)
							node:SetColor(sharedSettings.colors.comboPoints.base)
							node:SetFrameLevels(frameLevels.cpContainer, frameLevels.cpBorder, frameLevels.cpResource)
						end
					end
				end
			end
		end
	end	
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.monk.brewmaster then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = 1
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.monk.mistweaver then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.monk.windwalker then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Energy
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Chi
		TRB.Data.resource2Factor = 1
	else
		TRB.Data.specSupported = false
	end

	TRB.Functions.Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups

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
			-- Brewmaster (specId == 1) uses Stagger, Windwalker (specId == 3) uses Chi
			local showSecondary = false
			if not forceHideAll and (TRB.Data.character.specId == 1 or TRB.Data.character.specId == 3) then
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
					barGroups.secondary:ShowNodes(TRB.Data.character.maxResource2)
				else
					barGroups.secondary:Hide()
				end
			end

			-- Track if either bar is showing
			snapshotData.attributes.isTracking = showPrimary or showSecondary
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

	if TRB.Data.character.specId == 2 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]
		settings = TRB.Data.settings.monk.mistweaver
	elseif TRB.Data.character.specId == 3 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]
		settings = TRB.Data.settings.monk.windwalker
	else
		return false
	end

	if TRB.Data.character.specId == 1 then -- Brewmaster
		if var == "$resource" or var == "$energy" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$stagger" then
			if snapshotData.attributes.stagger ~= nil and snapshotData.attributes.stagger > 0 then
				valid = true
			end
		elseif var == "$staggerPercent" then
			if snapshotData.attributes.staggerPercent ~= nil and snapshotData.attributes.staggerPercent > 0 then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 2 then --Mistweaver
		if var == "$resource" or var == "$mana" then
			valid = false
		elseif var == "$resourceMax" or var == "$manaMax" then
			valid = true
		elseif var == "$resourcePercent" or var == "$manaPercent" then
			-- Do not compare resource percent as it may be a secret value
			valid = false
		elseif var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and (snapshotData.casting.resourceRaw ~= 0) then
				valid = true
			end
		end
	elseif TRB.Data.character.specId == 3 then --Windwalker
		if var == "$casting" then
			if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
				valid = true
			end
		elseif var == "$resource" or var == "$energy" then
			-- Do not compare snapshotData.attributes.resource as it may be a secret value
			valid = false
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$comboPoints" or var == "$chi" then
			valid = true
		elseif var == "$comboPointsMax"or var == "$chiMax" then
			valid = true
		end
	end

	-- Mistweaver or Windwalker / Conduit of the Celestials shared abilities
	if TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
	end

	return valid
end

---Gets the Frame for the requested bar text variable, if the frame is currently enabled, and if it is visible.
---@param relativeToFrame string
---@return Frame? # Relative to Frame
---@return boolean # Is Enabled?
---@return boolean # Is Visible?
function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups
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

	-- Handle secondary resources (Stagger for Brewmaster, Chi for Windwalker)
	local comboPointPrefix = "ComboPoint"
	if string.sub(normalizedRelativeFrame, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local comboPoint = tonumber(string.sub(normalizedRelativeFrame, string.len(comboPointPrefix) + 1))
		if comboPoint and barGroups.secondary then
			local cpNode = barGroups.secondary:GetNode(comboPoint)
			if cpNode then
				local isVisible = barGroups.secondary.isVisible and cpNode.isVisible
				return cpNode:GetResourceFrame(), true, isVisible
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