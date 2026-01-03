---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.IO = {}
TRB.Data = TRB.Data or {}

local EXPORT_STRING_PREFIX = "!TRB!"

local function ExportConfigurationSections(classId, specId, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
	local configuration = {
		colors = {},
		displayText = {}
	}

	if includeBarDisplay then
		configuration.bar = settings.bar
		configuration.healthBar = settings.healthBar
		configuration.displayBar = settings.displayBar
		configuration.textures = settings.textures
		configuration.colors.bar = settings.colors.bar

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
			elseif specId == 2 then -- Fury
				configuration.endOfEnrage = settings.endOfEnrage
			elseif specId == 3 then -- Protection
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 2 then -- Paladin
			if specId == 1 then -- Holy
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Protection
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Retribution
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 3 then -- Hunters
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
				configuration.endOfTrueshot = settings.endOfTrueshot
				configuration.steadyFocus = settings.steadyFocus
			elseif specId == 3 then -- Survival
			end
		elseif classId == 4 then -- Rogue
			if specId == 1 then -- Assassination
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Outlaw
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Subtlety
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end 
		elseif classId == 5 then -- Priests
			if specId == 1 then -- Discipline
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Holy
				configuration.endOfApotheosis = settings.endOfApotheosis
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Shadow
				configuration.endOfVoidform = settings.endOfVoidform
			end
		elseif classId == 6 then -- Death Knight
			if specId == 1 then -- Blood
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Frost
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Unholy
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 7 then -- Shaman
			if specId == 1 then -- Elemental
				configuration.endOfAscendance = settings.endOfAscendance
			elseif specId == 2 then -- Enhancement
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
				configuration.endOfAscendance = settings.endOfAscendance
			elseif specId == 3 then -- Restoration
				configuration.endOfAscendance = settings.endOfAscendance
			end
		elseif classId == 8 then -- Mage
			if specId == 1 then -- Arcane
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Fire
			elseif specId == 3 then -- Frost
			end
		elseif classId == 9 then -- Warlock
			if specId == 1 then -- Affliction
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Demonology
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Destruction
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 10 then -- Monk
			if specId == 1 then -- Brewmaster
			elseif specId == 2 then -- Mistweaver
			elseif specId == 3 then -- Windwalker
			end
		elseif classId == 11 then -- Druids
			if specId == 1 then -- Balance
				configuration.endOfEclipse = settings.endOfEclipse
				elseif specId == 2 then -- Feral
					configuration.colors.comboPoints = settings.colors.comboPoints
					configuration.comboPoints = settings.comboPoints
				elseif specId == 3 then -- Guardian
					-- No special bar display configuration for Guardian
					configuration.endOfBerserk = settings.endOfBerserk
				elseif specId == 4 then -- Restoration
					configuration.endOfIncarnation = settings.endOfIncarnation
				end
		elseif classId == 12 then -- Demon Hunter
			if specId == 1 then -- Havoc
				configuration.endOfMetamorphosis = settings.endOfMetamorphosis
			elseif specId == 2 then -- Vengeance
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
				configuration.endOfMetamorphosis = settings.endOfMetamorphosis
			elseif specId == 3 then -- Devourer
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
				configuration.endOfMetamorphosis = settings.endOfMetamorphosis
			end
		elseif classId == 13 then -- Evoker
			if specId == 1 then -- Devastation
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Preservation
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Augmentation
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		end
	end

	if includeThresholds then
		configuration.thresholds = settings.thresholds
		configuration.colors.threshold = settings.colors.threshold
	end

	if includeFontAndText then
		configuration.colors.text = settings.colors.text
		configuration.precision = settings.precision
		configuration.displayText.default = settings.displayText.default

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
			elseif specId == 2 then -- Fury
			elseif specId == 3 then -- Protection
			end
		elseif classId == 2 then -- Paladins
			if specId == 1 then -- Holy
			elseif specId == 2 then -- Protection
			elseif specId == 3 then -- Retribution
			end
		elseif classId == 3 then -- Hunters
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
			elseif specId == 3 then -- Survival
			end
		elseif classId == 4 then -- Rogue
			if specId == 1 then -- Assassination
			elseif specId == 2 then -- Outlaw
			elseif specId == 3 then -- Subtlety
			end 
		elseif classId == 5 then -- Priests
			if specId == 1 then -- Discipline
			elseif specId == 2 then -- Holy
			elseif specId == 3 then -- Shadow
				configuration.hasteApproachingThreshold = settings.hasteApproachingThreshold
				configuration.hasteThreshold = settings.hasteThreshold
			end
		elseif classId == 6 then -- Death Knight
			if specId == 1 then -- Blood
			elseif specId == 2 then -- Frost
			elseif specId == 3 then -- Unholy
			end
		elseif classId == 7 then -- Shaman
			if specId == 1 then -- Elemental
			elseif specId == 2 then -- Enhancement
			elseif specId == 3 then -- Restoration
			end
		elseif classId == 8 then -- Mage
			if specId == 1 then -- Arcane
			elseif specId == 2 then -- Fire
			elseif specId == 3 then -- Frost
			end
		elseif classId == 9 then -- Warlock
			if specId == 1 then -- Affliction
			end
		elseif classId == 10 then -- Monk
			if specId == 1 then -- Brewmaster
			elseif specId == 2 then -- Mistweaver
			elseif specId == 3 then -- Windwalker
			end
		elseif classId == 11 then -- Druids
			if specId == 1 then -- Balance
			elseif specId == 2 then -- Feral
			elseif specId == 3 then -- Guardian
			elseif specId == 4 then -- Restoration
			end
		elseif classId == 12 then -- Demon Hunter
			if specId == 1 then -- Havoc
			elseif specId == 2 then -- Vengeance
			elseif specId == 3 then -- Devourer
			end
		elseif classId == 13 then -- Evoker
			if specId == 1 then -- Devastation
			elseif specId == 2 then -- Preservation
			elseif specId == 3 then -- Augmentation
			end
		end
	end

	if includeAudioAndTracking then
		configuration.audio = settings.audio

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
			elseif specId == 2 then -- Fury
			elseif specId == 3 then -- Protection
			end
		elseif classId == 2 then -- Paladin
			if specId == 1 then -- Holy
			elseif specId == 2 then -- Protection
			elseif specId == 3 then -- Retribution
			end
		elseif classId == 3 then -- Hunters
			configuration.generation = settings.generation
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
			elseif specId == 3 then -- Survival
			end
		elseif classId == 4 then -- Rogues
			if specId == 1 then -- Assassination
				configuration.generation = settings.generation
			elseif specId == 2 then -- Outlaw
				configuration.generation = settings.generation
			elseif specId == 3 then -- Subtlety
				configuration.generation = settings.generation
			end
		elseif classId == 5 then -- Priests
			if specId == 1 then -- Discipline
			elseif specId == 2 then -- Holy
			elseif specId == 3 then -- Shadow
			end
		elseif classId == 6 then -- Death Knight
			if specId == 1 then -- Blood
			elseif specId == 2 then -- Frost
			elseif specId == 3 then -- Unholy
			end
		elseif classId == 7 then -- Shaman
			if specId == 1 then -- Elemental
			elseif specId == 2 then -- Enhancement
			elseif specId == 3 then -- Restoration
			end
		elseif classId == 8 then -- Mage
			if specId == 1 then -- Arcane
			elseif specId == 2 then -- Fire
			elseif specId == 3 then -- Frost
			end
		elseif classId == 9 then -- Warlock
			if specId == 1 then -- Affliction
			end
		elseif classId == 10 then -- Monk
			if specId == 1 then -- Brewmaster
			elseif specId == 2 then -- Mistweaver
			elseif specId == 3 then -- Windwalker
			end
		elseif classId == 11 then -- Druid
			if specId == 1 then -- Balance
			elseif specId == 2 then -- Feral
			elseif specId == 3 then -- Guardian
			elseif specId == 4 then -- Restoration
			end
		elseif classId == 12 then -- Demon Hunter
			if specId == 1 then -- Havoc
			elseif specId == 2 then -- Vengeance
			elseif specId == 3 then -- Devourer
			end
		elseif classId == 13 then -- Evoker
			if specId == 1 then -- Devastation
			elseif specId == 2 then -- Preservation
			elseif specId == 3 then -- Augmentation
			end
		end
	end

	if includeBarText then
		configuration.displayText.barText = settings.displayText.barText or {}
	end

	return configuration
end

local function ExportGetConfiguration(classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local settings = TRB.Data.settings or {}
	if includeBarDisplay == nil then
		includeBarDisplay = true
	end

	if includeThresholds == nil then
		includeThresholds = true
	end

	if includeFontAndText == nil then
		includeFontAndText = true
	end

	if includeAudioAndTracking == nil then
		includeAudioAndTracking = true
	end

	if includeBarText == nil then
		includeBarText = true
	end

	if includeCore == nil then
		includeCore = false -- Don't include unless explicity stated
	end

	local configuration = {}

	if classId ~= nil then -- One class
		if classId == 1 and settings.warrior ~= nil then -- Warrior
			configuration.warrior = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.warrior.arms) > 0 then -- Arms
				configuration.warrior.arms = ExportConfigurationSections(1, 1, settings.warrior.arms, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.warrior.fury) > 0 then -- Fury
				configuration.warrior.fury = ExportConfigurationSections(1, 2, settings.warrior.fury, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.warrior.protection) > 0 then -- Protection
				configuration.warrior.protection = ExportConfigurationSections(1, 3, settings.warrior.protection, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 2 and settings.paladin ~= nil then -- Paladin
			configuration.paladin = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.paladin.holy) > 0 then -- Holy
				configuration.paladin.holy = ExportConfigurationSections(2, 1, settings.paladin.holy, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.paladin.protection) > 0 then -- Protection
				configuration.paladin.protection = ExportConfigurationSections(2, 2, settings.paladin.protection, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.paladin.retribution) > 0 then -- Retribution
				configuration.paladin.retribution = ExportConfigurationSections(2, 3, settings.paladin.retribution, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 3 and settings.hunter ~= nil then -- Hunter
			configuration.hunter = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.hunter.beastMastery) > 0 then -- Beast Mastery
				configuration.hunter.beastMastery = ExportConfigurationSections(3, 1, settings.hunter.beastMastery, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.hunter.marksmanship) > 0 then -- Marksmanship
				configuration.hunter.marksmanship = ExportConfigurationSections(3, 2, settings.hunter.marksmanship, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.hunter.survival) > 0 then -- Survival
				configuration.hunter.survival = ExportConfigurationSections(3, 3, settings.hunter.survival, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 4 and settings.rogue ~= nil then -- Rogue
			configuration.rogue = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.rogue.assassination) > 0 then -- Assassination
				configuration.rogue.assassination = ExportConfigurationSections(4, 1, settings.rogue.assassination, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.rogue.outlaw) > 0 then -- Outlaw
				configuration.rogue.outlaw = ExportConfigurationSections(4, 2, settings.rogue.outlaw, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.rogue.subtlety) > 0 then -- Subtlety
				configuration.rogue.subtlety = ExportConfigurationSections(4, 3, settings.rogue.subtlety, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 5 and settings.priest ~= nil then -- Priest
			configuration.priest = {}
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.priest.discipline) > 0 then -- Discipline
				configuration.priest.discipline = ExportConfigurationSections(5, 1, settings.priest.discipline, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.priest.holy) > 0 then -- Holy
				configuration.priest.holy = ExportConfigurationSections(5, 2, settings.priest.holy, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.priest.shadow) > 0 then -- Shadow
				configuration.priest.shadow = ExportConfigurationSections(5, 3, settings.priest.shadow, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 6 and settings.deathknight ~= nil then -- Death Knight
			configuration.deathknight = {}
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.deathknight.blood) > 0 then -- Blood
				configuration.deathknight.blood = ExportConfigurationSections(6, 1, settings.deathknight.blood, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.deathknight.frost) > 0 then -- Frost
				configuration.deathknight.frost = ExportConfigurationSections(6, 2, settings.deathknight.frost, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.deathknight.unholy) > 0 then -- Unholy
				configuration.deathknight.unholy = ExportConfigurationSections(6, 3, settings.deathknight.unholy, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 7 and settings.shaman ~= nil then -- Shaman
			configuration.shaman = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.shaman.elemental) > 0 then -- Elemental
				configuration.shaman.elemental = ExportConfigurationSections(7, 1, settings.shaman.elemental, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
			
			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.shaman.enhancement) > 0 then -- Enhancement
				configuration.shaman.enhancement = ExportConfigurationSections(7, 2, settings.shaman.enhancement, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.shaman.restoration) > 0 then -- Restoration
				configuration.shaman.restoration = ExportConfigurationSections(7, 3, settings.shaman.restoration, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 8 and settings.mage ~= nil then -- Mage
			configuration.mage = {}
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.mage.arcane) > 0 then -- Arcane
				configuration.mage.arcane = ExportConfigurationSections(8, 1, settings.mage.arcane, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.mage.fire) > 0 then -- Fire
				configuration.mage.fire = ExportConfigurationSections(8, 2, settings.mage.fire, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.mage.frost) > 0 then -- Frost
				configuration.mage.frost = ExportConfigurationSections(8, 3, settings.mage.frost, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 9 and settings.warlock ~= nil then
			configuration.warlock = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.warlock.affliction) > 0 then -- Affliction
				configuration.warlock.affliction = ExportConfigurationSections(9, 1, settings.warlock.affliction, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.warlock.demonology) > 0 then -- Demonology
				configuration.warlock.demonology = ExportConfigurationSections(9, 2, settings.warlock.demonology, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.warlock.destruction) > 0 then -- Destruction
				configuration.warlock.destruction = ExportConfigurationSections(9, 3, settings.warlock.destruction, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 10 and settings.monk ~= nil then -- Monk
			configuration.monk = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.monk.brewmaster) > 0 then -- Brewmaster
				configuration.monk.brewmaster = ExportConfigurationSections(10, 1, settings.monk.brewmaster, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.monk.mistweaver) > 0 then -- Mistweaver
				configuration.monk.mistweaver = ExportConfigurationSections(10, 2, settings.monk.mistweaver, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.monk.windwalker) > 0 then -- Windwalker
				configuration.monk.windwalker = ExportConfigurationSections(10, 3, settings.monk.windwalker, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 11 and settings.druid ~= nil then -- Druid
			configuration.druid = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.druid.balance) > 0 then -- Balance
				configuration.druid.balance = ExportConfigurationSections(11, 1, settings.druid.balance, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
			
			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.druid.feral) > 0 then -- Feral
				configuration.druid.feral = ExportConfigurationSections(11, 2, settings.druid.feral, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.druid.guardian) > 0 then -- Guardian
				configuration.druid.guardian = ExportConfigurationSections(11, 3, settings.druid.guardian, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 4 or specId == nil) and TRB.Functions.Table:Length(settings.druid.restoration) > 0 then -- Restoration
				configuration.druid.restoration = ExportConfigurationSections(11, 4, settings.druid.restoration, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 12 and settings.demonhunter ~= nil then -- Demon Hunter
			configuration.demonhunter = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.demonhunter.havoc) > 0 then -- Havoc
				configuration.demonhunter.havoc = ExportConfigurationSections(12, 1, settings.demonhunter.havoc, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.demonhunter.vengeance) > 0 then -- Vengeance
				configuration.demonhunter.vengeance = ExportConfigurationSections(12, 2, settings.demonhunter.vengeance, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.demonhunter.devourer) > 0 then -- Devourer
				configuration.demonhunter.devourer = ExportConfigurationSections(12, 3, settings.demonhunter.devourer, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 13 and settings.evoker ~= nil then -- Evoker
			configuration.evoker = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.evoker.devastation) > 0 then -- Devastation
				configuration.evoker.devastation = ExportConfigurationSections(13, 1, settings.evoker.devastation, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.evoker.preservation) > 0 then -- Preservation
				configuration.evoker.preservation = ExportConfigurationSections(13, 2, settings.evoker.preservation, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
			
			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.evoker.augmentation) > 0 then -- Augmentation
				configuration.evoker.augmentation = ExportConfigurationSections(13, 1, settings.evoker.augmentation, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		end
	elseif classId == nil and specId == nil then -- Everything
		-- Instead of just dumping the whole table, let's clean it up

		-- Warrior
		-- Arms
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Fury
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Protection
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Paladin
		-- Holy
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(2, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Protection
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(2, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Retribution
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(2, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Hunter
		-- Beast Mastery
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Marksmanship
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Survival
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Rogue
		-- Assassination
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Outlaw
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Subtlety
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Priest
		-- Discipline
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Holy
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Shadow
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Death Knight
		-- Blood
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(6, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Frost
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(6, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Unholy
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(6, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Shaman
		-- Elemental
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Enhancement
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Restoration
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Warlock
		-- Affliction
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(9, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Demonology
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(9, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Destruction
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(9, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Monk
		-- Brewmaster
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Mistweaver
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Windwalker
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		
		-- Druid
		-- Balance
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Feral
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Guardian
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Restoration
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 4, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Demon Hunter
		-- Havoc
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(12, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Vengeance
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(12, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Devourer
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(12, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		
		-- Evoker
		-- Devastation
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 1, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Preservation
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 2, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Augmentation
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 3, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
	end

	if includeCore then
		configuration.core = settings.core
	end

	return configuration
end

local function Export(configuration)
	local json = TRB.Functions.Libs:GetJsonLibrary()
	local base64 = TRB.Functions.Libs:GetBase64Library()

	local encoded = json.encode(configuration)
	local output = base64.encode(encoded)

	return EXPORT_STRING_PREFIX .. output
end

function TRB.Functions.IO:Import(input)
	local json = TRB.Functions.Libs:GetJsonLibrary()
	local base64 = TRB.Functions.Libs:GetBase64Library()

	local prefix = string.sub(input, 1, 5)

	if prefix == EXPORT_STRING_PREFIX then
		input = string.sub(input, 6)
	end

	local decoded, configuration, mergedSettings, result

	result, decoded = pcall(base64.decode, input)

	if not result then
		return -1
	end

	result, configuration = pcall(json.decode, decoded)

	if not result then
		return -2
	end

	if not (configuration.core ~= nil or
		(configuration.warrior ~= nil and
			(configuration.warrior.arms ~= nil or
			configuration.warrior.fury ~= nil or
			configuration.warrior.protection ~= nil)) or
		(configuration.paladin ~= nil and
			(configuration.paladin.holy ~= nil or
			configuration.paladin.protection ~= nil or
			configuration.paladin.retribution ~= nil)) or
		(configuration.rogue ~= nil and
			(configuration.rogue.assassination ~= nil or
			configuration.rogue.outlaw ~= nil or
			configuration.rogue.subtlety ~= nil)) or
		(configuration.hunter ~= nil and
			(configuration.hunter.beastMastery ~= nil or
			configuration.hunter.marksmanship ~= nil or
			configuration.hunter.survival ~= nil)) or
		(configuration.monk ~= nil and
			(configuration.monk.mistweaver ~= nil or
			configuration.monk.windwalker ~= nil)) or
		(configuration.deathknight ~= nil and
			(configuration.deathknight.blood ~= nil or
			configuration.deathknight.frost ~= nil or
			configuration.deathknight.unholy ~= nil)) or
		(configuration.priest ~= nil and
			(configuration.priest.discipline ~= nil or
			configuration.priest.holy ~= nil or
			configuration.priest.shadow ~= nil)) or
		(configuration.mage ~= nil and
			(configuration.mage.arcane ~= nil or
			configuration.mage.fire ~= nil or
			configuration.mage.frost ~= nil)) or
		(configuration.shaman ~= nil and
			(configuration.shaman.elemental ~= nil or
			configuration.shaman.restoration ~= nil or
			configuration.shaman.enhancement ~= nil)) or
		(configuration.warlock ~= nil and
			(configuration.warlock.affliction ~= nil or
			configuration.warlock.demonology ~= nil or
			configuration.warlock.destiny ~= nil)) or
		(configuration.druid ~= nil and
			(configuration.druid.balance ~= nil or
			configuration.druid.feral ~= nil or
			configuration.druid.guardian ~= nil or
			configuration.druid.restoration)) or
		(configuration.demonhunter ~= nil and
			(configuration.demonhunter.havoc ~= nil or
			configuration.demonhunter.vengeance ~= nil or
			configuration.demonhunter.devourer ~= nil)) or
		(configuration.evoker ~= nil and
			(configuration.evoker.devastation ~= nil or
			configuration.evoker.preservation ~= nil or
			configuration.evoker.augmentation ~= nil)
		)) then
		return -3
	end

	local existingSettings = TRB.Data.settings

	local function TableMergeWrapper(existing, config)
		local newBarText = {}
		
		for className, class in pairs(config) do
			if className ~= "core" then
				for specName, spec in pairs(class) do
					local entryCount = TRB.Functions.Table:Length(spec.displayText.barText)
					if entryCount > 0 then
						newBarText[className.."_"..specName] = spec.displayText.barText
						spec.displayText.barText = {}
					end
				end
			end
		end

		local merged = TRB.Functions.Table:Merge(existing, config)

		if TRB.Functions.Table:Length(newBarText) > 0 then
			for className, class in pairs(merged) do
				if className ~= "core" then
					for specName, spec in pairs(class) do
						local entryCount = TRB.Functions.Table:Length(newBarText[className.."_"..specName])
						if entryCount > 0 then
							spec.displayText.barText = newBarText[className.."_"..specName]
						end
					end
				end
			end
		end

		return merged
	end

	result, mergedSettings = pcall(TableMergeWrapper, existingSettings, configuration)

	if not result then
		return -4
	end

	TRB.Data.settings = mergedSettings
	return 1
end

function TRB.Functions.IO:ExportPopup(exportMessage, classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local configuration = ExportGetConfiguration(classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local output = Export(configuration)
	StaticPopup_Show("TwintopResourceBar_Export", nil, nil, { message = exportMessage, exportString = output})
end