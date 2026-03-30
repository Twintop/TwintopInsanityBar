---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.IO = {}
TRB.Data = TRB.Data or {}

local EXPORT_STRING_PREFIX = "!TRB!"
local EXPORT_STRING_PREFIX2 = "!TRBv2!"

---Extracts selected configuration sections (bar display, thresholds, font/text, audio/tracking, bar text) from a single spec's settings table into an export-ready table, including class/spec-specific fields like combo points, mana bar, or stagger bar.
---@param classId integer # WoW class ID (1=Warrior, 2=Paladin, ..., 13=Evoker)
---@param specId integer # Specialization index within the class (1-based)
---@param settings table # The spec's full settings table to extract sections from
---@param includeBarDisplay boolean # Whether to include bar display, colors, textures, and overcap settings
---@param includeThresholds boolean # Whether to include threshold configuration and threshold colors
---@param includeFontAndText boolean # Whether to include font, text color, precision, and display text defaults
---@param includeAudioAndTracking boolean # Whether to include audio cue settings
---@param includeBarText boolean # Whether to include bar text templates and migrations
---@return table # Partial configuration table containing only the requested sections
local function ExportConfigurationSections(classId, specId, settings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
	local configuration = {
		colors = {},
		displayText = {}
	}

	if includeBarDisplay then
		configuration.bar = settings.bar
		configuration.healthBar = settings.healthBar
		configuration.displayBar = settings.displayBar
		configuration.textures = settings.textures or {}
		configuration.colors.bar = settings.colors and settings.colors.bar
		configuration.colors.shared = settings.colors and settings.colors.shared
		configuration.colors.healthBar = settings.colors and settings.colors.healthBar
		configuration.overcap = settings.overcap
		configuration.endOf = settings.endOf

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
			elseif specId == 2 then -- Fury
				configuration.comboPoints = settings.comboPoints
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.whirlwind = settings.colors and settings.colors.bars and settings.colors.bars.whirlwind
			elseif specId == 3 then -- Protection
				-- Export defensives bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.defensives = settings.bars and settings.bars.defensives
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.defensives = settings.colors and settings.colors.bars and settings.colors.bars.defensives
				-- Export flat texture keys
				configuration.textures.defensivesBar = settings.textures and settings.textures.defensivesBar
				configuration.textures.defensivesBarName = settings.textures and settings.textures.defensivesBarName
				configuration.textures.defensivesBorder = settings.textures and settings.textures.defensivesBorder
				configuration.textures.defensivesBorderName = settings.textures and settings.textures.defensivesBorderName
				configuration.textures.defensivesBackground = settings.textures and settings.textures.defensivesBackground
				configuration.textures.defensivesBackgroundName = settings.textures and settings.textures.defensivesBackgroundName
			end
		elseif classId == 2 then -- Paladin
			if specId == 1 then -- Holy
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Protection
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Retribution
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 3 then -- Hunters
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
			elseif specId == 3 then -- Survival
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 4 then -- Rogue
			if specId == 1 then -- Assassination
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Outlaw
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Subtlety
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end 
		elseif classId == 5 then -- Priests
			if specId == 1 then -- Discipline
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
				-- Export utility bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.utility = settings.bars and settings.bars.utility
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.utility = settings.colors and settings.colors.bars and settings.colors.bars.utility
				configuration.textures.utilityBar = settings.textures and settings.textures.utilityBar
				configuration.textures.utilityBarName = settings.textures and settings.textures.utilityBarName
				configuration.textures.utilityBorder = settings.textures and settings.textures.utilityBorder
				configuration.textures.utilityBorderName = settings.textures and settings.textures.utilityBorderName
				configuration.textures.utilityBackground = settings.textures and settings.textures.utilityBackground
				configuration.textures.utilityBackgroundName = settings.textures and settings.textures.utilityBackgroundName
			elseif specId == 2 then -- Holy
				-- Export Holy Words bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.holyWords = settings.bars and settings.bars.holyWords
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.holyWords = settings.colors and settings.colors.bars and settings.colors.bars.holyWords
				configuration.textures.holyWordsBar = settings.textures and settings.textures.holyWordsBar
				configuration.textures.holyWordsBarName = settings.textures and settings.textures.holyWordsBarName
				configuration.textures.holyWordsBorder = settings.textures and settings.textures.holyWordsBorder
				configuration.textures.holyWordsBorderName = settings.textures and settings.textures.holyWordsBorderName
				configuration.textures.holyWordsBackground = settings.textures and settings.textures.holyWordsBackground
				configuration.textures.holyWordsBackgroundName = settings.textures and settings.textures.holyWordsBackgroundName
				-- Export Lightweaver bar settings
				configuration.bars.lightweaver = settings.bars and settings.bars.lightweaver
				configuration.colors.bars.lightweaver = settings.colors and settings.colors.bars and settings.colors.bars.lightweaver
				configuration.textures.lightweaverBar = settings.textures and settings.textures.lightweaverBar
				configuration.textures.lightweaverBarName = settings.textures and settings.textures.lightweaverBarName
				configuration.textures.lightweaverBorder = settings.textures and settings.textures.lightweaverBorder
				configuration.textures.lightweaverBorderName = settings.textures and settings.textures.lightweaverBorderName
				configuration.textures.lightweaverBackground = settings.textures and settings.textures.lightweaverBackground
				configuration.textures.lightweaverBackgroundName = settings.textures and settings.textures.lightweaverBackgroundName
				-- Export utility bar settings
				configuration.bars.utility = settings.bars and settings.bars.utility
				configuration.colors.bars.utility = settings.colors and settings.colors.bars and settings.colors.bars.utility
				configuration.textures.utilityBar = settings.textures and settings.textures.utilityBar
				configuration.textures.utilityBarName = settings.textures and settings.textures.utilityBarName
				configuration.textures.utilityBorder = settings.textures and settings.textures.utilityBorder
				configuration.textures.utilityBorderName = settings.textures and settings.textures.utilityBorderName
				configuration.textures.utilityBackground = settings.textures and settings.textures.utilityBackground
				configuration.textures.utilityBackgroundName = settings.textures and settings.textures.utilityBackgroundName
			elseif specId == 3 then -- Shadow
				-- Export mana bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.mana = settings.bars and settings.bars.mana
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.mana = settings.colors and settings.colors.bars and settings.colors.bars.mana
				-- Export flat texture keys
				configuration.textures.manaBar = settings.textures and settings.textures.manaBar
				configuration.textures.manaBarName = settings.textures and settings.textures.manaBarName
				configuration.textures.manaBorder = settings.textures and settings.textures.manaBorder
				configuration.textures.manaBorderName = settings.textures and settings.textures.manaBorderName
				configuration.textures.manaBackground = settings.textures and settings.textures.manaBackground
				configuration.textures.manaBackgroundName = settings.textures and settings.textures.manaBackgroundName
				-- Export utility bar settings
				configuration.bars.utility = settings.bars and settings.bars.utility
				configuration.colors.bars.utility = settings.colors and settings.colors.bars and settings.colors.bars.utility
				configuration.textures.utilityBar = settings.textures and settings.textures.utilityBar
				configuration.textures.utilityBarName = settings.textures and settings.textures.utilityBarName
				configuration.textures.utilityBorder = settings.textures and settings.textures.utilityBorder
				configuration.textures.utilityBorderName = settings.textures and settings.textures.utilityBorderName
				configuration.textures.utilityBackground = settings.textures and settings.textures.utilityBackground
				configuration.textures.utilityBackgroundName = settings.textures and settings.textures.utilityBackgroundName
			end
		elseif classId == 6 then -- Death Knight
			if specId == 1 then -- Blood
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
				-- Bone Shield bar
				configuration.bars = configuration.bars or {}
				configuration.bars.boneShield = settings.bars and settings.bars.boneShield
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.boneShield = settings.colors and settings.colors.bars and settings.colors.bars.boneShield
				configuration.textures.boneShieldBar = settings.textures and settings.textures.boneShieldBar
				configuration.textures.boneShieldBarName = settings.textures and settings.textures.boneShieldBarName
				configuration.textures.boneShieldBorder = settings.textures and settings.textures.boneShieldBorder
				configuration.textures.boneShieldBorderName = settings.textures and settings.textures.boneShieldBorderName
				configuration.textures.boneShieldBackground = settings.textures and settings.textures.boneShieldBackground
				configuration.textures.boneShieldBackgroundName = settings.textures and settings.textures.boneShieldBackgroundName
			elseif specId == 2 then -- Frost
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Unholy
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 7 then -- Shaman
			if specId == 1 then -- Elemental
				-- Export mana bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.mana = settings.bars and settings.bars.mana
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.mana = settings.colors and settings.colors.bars and settings.colors.bars.mana
				-- Export flat texture keys
				configuration.textures.manaBar = settings.textures and settings.textures.manaBar
				configuration.textures.manaBarName = settings.textures and settings.textures.manaBarName
				configuration.textures.manaBorder = settings.textures and settings.textures.manaBorder
				configuration.textures.manaBorderName = settings.textures and settings.textures.manaBorderName
				configuration.textures.manaBackground = settings.textures and settings.textures.manaBackground
				configuration.textures.manaBackgroundName = settings.textures and settings.textures.manaBackgroundName
			elseif specId == 2 then -- Enhancement
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Restoration
			end
		elseif classId == 8 then -- Mage
			if specId == 1 then -- Arcane
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Fire
			elseif specId == 3 then -- Frost
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 9 then -- Warlock
			if specId == 1 then -- Affliction
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Demonology
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Destruction
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 10 then -- Monk
			if specId == 1 then -- Brewmaster
				-- Export stagger bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.stagger = settings.bars and settings.bars.stagger
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.stagger = settings.colors and settings.colors.bars and settings.colors.bars.stagger
				-- Export flat texture keys (same pattern as manaBar)
				configuration.textures.staggerBar = settings.textures and settings.textures.staggerBar
				configuration.textures.staggerBarName = settings.textures and settings.textures.staggerBarName
				configuration.textures.staggerBorder = settings.textures and settings.textures.staggerBorder
				configuration.textures.staggerBorderName = settings.textures and settings.textures.staggerBorderName
				configuration.textures.staggerBackground = settings.textures and settings.textures.staggerBackground
				configuration.textures.staggerBackgroundName = settings.textures and settings.textures.staggerBackgroundName
			elseif specId == 2 then -- Mistweaver
			elseif specId == 3 then -- Windwalker
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 11 then -- Druids
			if specId == 1 then -- Balance
				-- Export mana bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.mana = settings.bars and settings.bars.mana
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.mana = settings.colors and settings.colors.bars and settings.colors.bars.mana
				-- Export flat texture keys
				configuration.textures.manaBar = settings.textures and settings.textures.manaBar
				configuration.textures.manaBarName = settings.textures and settings.textures.manaBarName
				configuration.textures.manaBorder = settings.textures and settings.textures.manaBorder
				configuration.textures.manaBorderName = settings.textures and settings.textures.manaBorderName
				configuration.textures.manaBackground = settings.textures and settings.textures.manaBackground
				configuration.textures.manaBackgroundName = settings.textures and settings.textures.manaBackgroundName
			elseif specId == 2 then -- Feral
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Guardian
			elseif specId == 4 then -- Restoration
			end
		elseif classId == 12 then -- Demon Hunter
			if specId == 1 then -- Havoc
			elseif specId == 2 then -- Vengeance
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Devourer
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		elseif classId == 13 then -- Evoker
			if specId == 1 then -- Devastation
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Preservation
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 3 then -- Augmentation
				configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
				-- Export Ebon Might bar settings
				configuration.bars = configuration.bars or {}
				configuration.bars.ebonMight = settings.bars and settings.bars.ebonMight
				configuration.colors.bars = configuration.colors.bars or {}
				configuration.colors.bars.ebonMight = settings.colors and settings.colors.bars and settings.colors.bars.ebonMight
				configuration.textures.ebonMightBar = settings.textures and settings.textures.ebonMightBar
				configuration.textures.ebonMightBarName = settings.textures and settings.textures.ebonMightBarName
				configuration.textures.ebonMightBorder = settings.textures and settings.textures.ebonMightBorder
				configuration.textures.ebonMightBorderName = settings.textures and settings.textures.ebonMightBorderName
				configuration.textures.ebonMightBackground = settings.textures and settings.textures.ebonMightBackground
				configuration.textures.ebonMightBackgroundName = settings.textures and settings.textures.ebonMightBackgroundName
			end
		end
	end

	if includeThresholds then
		configuration.thresholds = settings.thresholds
		configuration.colors.threshold = settings.colors and settings.colors.threshold
	end

	if includeFontAndText then
		configuration.colors.text = settings.colors and settings.colors.text
		configuration.precision = settings.precision
		configuration.displayText.default = settings.displayText and settings.displayText.default

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
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
			elseif specId == 3 then -- Survival
			end
		elseif classId == 4 then -- Rogues
			if specId == 1 then -- Assassination
			elseif specId == 2 then -- Outlaw
			elseif specId == 3 then -- Subtlety
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
		configuration.displayText.barText = settings.displayText and settings.displayText.barText or {}
		configuration.displayText.migrations = settings.displayText and settings.displayText.migrations
	end

	return configuration
end

---Gets an export configuration table for the specified class and spec.
---@param classId integer? # Class to export. If nil, exports all classes. Both classId and specId must be nil to export all classes/specs.
---@param specId integer? # Specialization to export. If nil, exports all specs for the class.
---@param includeBarDisplay boolean? # Include all values found on the Bar Display tab. Defaults to true.
---@param includeThresholds boolean? # Include all values found on the Thresholds tab. Defaults to true.
---@param includeFontAndText boolean? # Include all values found on the Font & Text tab. Defaults to true.
---@param includeAudioAndTracking boolean? # Include all values found on the Audio & Tracking tab. Defaults to true.
---@param includeBarText boolean? # Include all values found on the Bar Text tab. Defaults to true.
---@param includeCore boolean? # Should the export also include core settings not tied to a class/spec? Defaults to false.
---@return table
local function ExportGetConfiguration(classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local settings = TRB.Data.settings

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
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Fury
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Protection
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Paladin
		-- Holy
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(2, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Protection
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(2, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Retribution
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(2, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Hunter
		-- Beast Mastery
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Marksmanship
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Survival
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Rogue
		-- Assassination
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Outlaw
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Subtlety
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Priest
		-- Discipline
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Holy
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Shadow
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Death Knight
		-- Blood
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(6, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Frost
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(6, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Unholy
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(6, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Shaman
		-- Elemental
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Enhancement
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Restoration
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Mage
		-- Arcane
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(8, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Fire
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(8, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Frost
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(8, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Warlock
		-- Affliction
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(9, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Demonology
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(9, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Destruction
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(9, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Monk
		-- Brewmaster
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Mistweaver
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Windwalker
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		
		-- Druid
		-- Balance
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Feral
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Guardian
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Restoration
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 4, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Demon Hunter
		-- Havoc
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(12, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Vengeance
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(12, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Devourer
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(12, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		
		-- Evoker
		-- Devastation
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 1, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Preservation
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 2, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Augmentation
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 3, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText))
	end

	if includeCore then
		configuration.core = settings.core
	end

	return configuration
end

---Serializes a configuration table to JSON, compresses it with Deflate, Base64-encodes it, and prepends the v2 export string prefix.
---@param configuration table # The configuration table to serialize and encode for export
---@return string # The prefixed Base64-encoded compressed export string
local function Export(configuration)
	local encoded = C_EncodingUtil.SerializeJSON(configuration)
	local compressed = C_EncodingUtil.CompressString(encoded, Enum.CompressionMethod.Deflate)
	local base64 = C_EncodingUtil.EncodeBase64(compressed)

	return EXPORT_STRING_PREFIX2 .. base64
end

---Handles importing a configuration string.
---@param input string
---@return integer # Status code of the result of the import. 1 = Success (`/reload` required), -1 = Base64 decode error, -2 = Decompression error, -3 = JSON decode error, -4 = Invalid configuration structure, -5 = Merge error.
local function HandleImport(input)
	local prefix = string.sub(input, 1, 5)
	local prefixV2 = string.sub(input, 1, 7)
	local exportVersion = nil

	if prefixV2 == EXPORT_STRING_PREFIX2 then
		exportVersion = 2
		input = string.sub(input, 8)
	elseif prefix == EXPORT_STRING_PREFIX then
		input = string.sub(input, 6)
		exportVersion = 1
	end

	local decoded, decompressed, configuration, mergedSettings, result

	result, decoded = pcall(C_EncodingUtil.DecodeBase64, input)

	if not result then
		return -1
	end

	if exportVersion == 2 then
		result, decompressed = pcall(C_EncodingUtil.DecompressString, decoded, Enum.CompressionMethod.Deflate)
		
		if not result then
			return -2
		end
		decoded = decompressed
	end

	result, configuration = pcall(C_EncodingUtil.DeserializeJSON, decoded)

	if not result or type(configuration) ~= "table" then
		return -3
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
			(configuration.monk.brewmaster ~= nil or
			configuration.monk.mistweaver ~= nil or
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
			configuration.warlock.destruction ~= nil)) or
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
		return -4
	end

	local existingSettings = TRB.Data.settings

	---Merges an imported configuration into the existing settings, treating barText arrays as full replacements rather than deep merges, and migrates bar anchors after merge.
	---@param existing table # The current addon settings table to merge into
	---@param config table # The imported configuration table to merge from
	---@return table # The merged settings table with barText arrays replaced wholesale
	local function TableMergeWrapper(existing, config)
		local newBarText = {}
		local newCoreBarText = nil
		
		-- Extract core displayText.barText before merge (array replacement, not merge)
		if config.core and config.core.displayText and config.core.displayText.barText then
			local entryCount = TRB.Functions.Table:Length(config.core.displayText.barText)
			if entryCount > 0 then
				newCoreBarText = config.core.displayText.barText
				config.core.displayText.barText = {}
			end
		end

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

		-- Re-apply core barText as full replacement
		if newCoreBarText then
			merged.core.displayText.barText = newCoreBarText
		end

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
		return -5
	end

	TRB.Data.settings = mergedSettings

	-- Post-import migration: ensure anchor blocks are populated from legacy fields.
	-- forceResync=true because the import may have changed relativeTo/xPos/yPos/fullWidth
	-- without updating the corresponding anchor blocks.
	TRB.Functions.Settings:MigrateBarAnchors(TRB.Data.settings, true)

	return 1
end

---Public wrapper for HandleImport. Decodes, decompresses, deserializes, validates, and merges an import string into the addon's settings.
---@param input string # The full import string (with or without the TRB prefix)
---@return integer # Status code: 1 = success, -1 = Base64 error, -2 = decompression error, -3 = JSON error, -4 = invalid structure, -5 = merge error
function TRB.Functions.IO:Import(input)
	return HandleImport(input)
end

---Gets an export configuration table for the specified class and spec.
---@param classId integer? # Class to export. If nil, exports all classes. Both classId and specId must be nil to export all classes/specs.
---@param specId integer? # Specialization to export. If nil, exports all specs for the class.
---@param includeBarDisplay boolean? # Include all values found on the Bar Display tab. Defaults to true.
---@param includeThresholds boolean? # Include all values found on the Thresholds tab. Defaults to true.
---@param includeFontAndText boolean? # Include all values found on the Font & Text tab. Defaults to true.
---@param includeAudioAndTracking boolean? # Include all values found on the Audio & Tracking tab. Defaults to true.
---@param includeBarText boolean? # Include all values found on the Bar Text tab. Defaults to true.
---@param includeCore boolean? # Should the export also include core settings not tied to a class/spec? Defaults to false.
---@return string
local function HandleExport(classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local configuration = ExportGetConfiguration(classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local output = Export(configuration)
	return output
end

---Generates an export string for the specified class/spec configuration and displays it in a copy-paste popup dialog.
---@param exportMessage string # Message to display at the top of the export popup
---@param classId integer? # WoW class ID to export, or nil for all classes
---@param specId integer? # Specialization index to export, or nil for all specs within the class
---@param includeBarDisplay boolean? # Include bar display settings. Defaults to true.
---@param includeThresholds boolean? # Include threshold settings. Defaults to true.
---@param includeFontAndText boolean? # Include font and text settings. Defaults to true.
---@param includeAudioAndTracking boolean? # Include audio and tracking settings. Defaults to true.
---@param includeBarText boolean? # Include bar text settings. Defaults to true.
---@param includeCore boolean? # Include core (non-spec) settings. Defaults to false.
function TRB.Functions.IO:ExportPopup(exportMessage, classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local output = HandleExport(classId, specId, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	StaticPopup_Show("TwintopResourceBar_Export", nil, nil, { message = exportMessage, exportString = output})
end

---Exports only the global bar text settings (core.displayText.barText).
---@param exportMessage string
function TRB.Functions.IO:ExportGlobalBarTextPopup(exportMessage)
	local configuration = {
		core = {
			displayText = {
				barText = TRB.Data.settings.core.displayText.barText,
				migrations = TRB.Data.settings.core.displayText.migrations
			}
		}
	}
	local output = Export(configuration)
	StaticPopup_Show("TwintopResourceBar_Export", nil, nil, { message = exportMessage, exportString = output})
end

Twintop_API = TwintopAPI or {}
Twintop_API.ExportConfiguration = HandleExport
Twintop_API.ImportConfiguration = HandleImport
