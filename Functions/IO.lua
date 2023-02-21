---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.IO = {}
TRB.Data = TRB.Data or {}

local EXPORT_STRING_PREFIX = "!TRB!"

local function ExportConfigurationSections(classId, specId, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
	local configuration = {
		colors = {},
		displayText = {}
	}

	if includeBarDisplay then
		configuration.bar = settings.bar
		configuration.displayBar = settings.displayBar
		configuration.textures = settings.textures
		configuration.thresholds = settings.thresholds
		configuration.colors.bar = settings.colors.bar
		configuration.colors.threshold = settings.colors.threshold
		configuration.overcapThreshold = settings.overcapThreshold

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
			elseif specId == 2 then -- Fury
				configuration.endOfEnrage = settings.endOfEnrage
			end
		elseif classId == 3 then -- Hunters
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
				configuration.endOfTrueshot = settings.endOfTrueshot
				configuration.steadyFocus = settings.steadyFocus
			elseif specId == 3 then -- Survival
				configuration.endOfCoordinatedAssault = settings.endOfCoordinatedAssault
			end
		elseif classId == 4 then -- Rogue
			if specId == 1 then -- Assassination
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Outlaw
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end 
		elseif classId == 5 then -- Priests
			if specId == 2 then -- Holy
				configuration.endOfApotheosis = settings.endOfApotheosis
			elseif specId == 3 then -- Shadow
				configuration.endOfVoidform = settings.endOfVoidform
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
		elseif classId == 10 then -- Monk
			if specId == 2 then -- Mistweaver
			elseif specId == 3 then -- Windwalker
				configuration.endOfSerenity = settings.endOfSerenity
			end
		elseif classId == 11 then -- Druids
			if specId == 1 then -- Balance
				configuration.endOfEclipse = settings.endOfEclipse
			elseif specId == 2 then -- Feral
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 4 then -- Restoration
			end
		elseif classId == 12 and specId == 1 then -- Havoc Demon Hunter
			configuration.endOfMetamorphosis = settings.endOfMetamorphosis
		elseif classId == 13 then -- Evoker
			if specId == 1 then -- Devastation
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			elseif specId == 2 then -- Preservation
				configuration.colors.comboPoints = settings.colors.comboPoints
				configuration.comboPoints = settings.comboPoints
			end
		end
	end

	if includeFontAndText then
		configuration.colors.text = settings.colors.text
		configuration.hastePrecision = settings.hastePrecision
		configuration.displayText.fontSizeLock = settings.displayText.fontSizeLock
		configuration.displayText.fontFaceLock = settings.displayText.fontFaceLock
		configuration.displayText.left = {
			fontFace = settings.displayText.left.fontFace,
			fontFaceName = settings.displayText.left.fontFaceName,
			fontSize = settings.displayText.left.fontSize
		}
		configuration.displayText.middle = {
			fontFace = settings.displayText.middle.fontFace,
			fontFaceName = settings.displayText.middle.fontFaceName,
			fontSize = settings.displayText.middle.fontSize
		}
		configuration.displayText.right = {
			fontFace = settings.displayText.right.fontFace,
			fontFaceName = settings.displayText.right.fontFaceName,
			fontSize = settings.displayText.right.fontSize
		}

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
				configuration.ragePrecision = settings.ragePrecision
			elseif specId == 2 then -- Fury
				configuration.ragePrecision = settings.ragePrecision
			end
		elseif classId == 3 then -- Hunters
			if specId == 1 then -- Beast Mastery
			elseif specId == 2 then -- Marksmanship
			elseif specId == 3 then -- Survival
			end
		elseif classId == 4 then -- Rogue
			if specId == 1 then -- Assassination
			elseif specId == 2 then -- Outlaw
			end 
		elseif classId == 5 then -- Priests
			if specId == 2 then -- Holy
			elseif specId == 3 then -- Shadow
				configuration.hasteApproachingThreshold = settings.hasteApproachingThreshold
				configuration.hasteThreshold = settings.hasteThreshold
				configuration.insanityPrecision = settings.insanityPrecision
			end
		elseif classId == 7 then -- Shaman
			if specId == 1 then -- Elemental
			elseif specId == 2 then -- Enhancement
			elseif specId == 3 then -- Restoration
			end
		elseif classId == 10 then -- Monk
			if specId == 2 then -- Mistweaver
			elseif specId == 3 then -- Windwalker
			end
		elseif classId == 11 then -- Druids
			if specId == 1 then -- Balance
				configuration.astralPowerPrecision = settings.astralPowerPrecision
			elseif specId == 2 then -- Feral
			elseif specId == 4 then -- Restoration
			end
		elseif classId == 12 and specId == 1 then -- Havoc Demon Hunter
		elseif classId == 13 then -- Evoker
			if specId == 1 then -- Devastation
			elseif specId == 2 then -- Preservation
			end
		end
	end

	if includeAudioAndTracking then
		configuration.audio = settings.audio

		if classId == 1 then -- Warrior
			if specId == 1 then -- Arms
				configuration.ragePrecision = settings.ragePrecision
			elseif specId == 2 then -- Fury
				configuration.ragePrecision = settings.ragePrecision
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
			end
		elseif classId == 5 then -- Priests
			if specId == 2 then -- Holy
				configuration.passiveGeneration = settings.passiveGeneration
				configuration.shadowfiend = settings.shadowfiend
			elseif specId == 3 then -- Shadow
				configuration.mindbender = settings.mindbender
				configuration.auspiciousSpiritsTracker = settings.auspiciousSpiritsTracker
				configuration.voidTendrilTracker = settings.voidTendrilTracker
			end
		elseif classId == 7 then -- Shaman
			if specId == 1 then -- Elemental
			elseif specId == 2 then -- Enhancement
			elseif specId == 3 then -- Restoration
			end
		elseif classId == 10 then -- Monk
			if specId == 2 then -- Mistweaver
			elseif specId == 3 then -- Windwalker
			end
		elseif classId == 11 then -- Druid
			if specId == 1 then -- Balance
			elseif specId == 2 then -- Feral
			elseif specId == 4 then -- Restoration
			end
		elseif classId == 12 and specId == 1 then -- Havoc Demon Hunter
		elseif classId == 13 then -- Evoker
			if specId == 1 then -- Devastation
			elseif specId == 2 then -- Preservation
			end
		end
	end

	if includeBarText then
		configuration.displayText.left = configuration.displayText.left or {}
		configuration.displayText.left.text = settings.displayText.left.text
		configuration.displayText.middle = configuration.displayText.middle or {}
		configuration.displayText.middle.text = settings.displayText.middle.text
		configuration.displayText.right = configuration.displayText.right or {}
		configuration.displayText.right.text = settings.displayText.right.text
	end

	return configuration
end

local function ExportGetConfiguration(classId, specId, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	local settings = TRB.Data.settings or {}
	if includeBarDisplay == nil then
		includeBarDisplay = true
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
				configuration.warrior.arms = ExportConfigurationSections(1, 1, settings.warrior.arms, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.warrior.fury) > 0 then -- Fury
				configuration.warrior.fury = ExportConfigurationSections(1, 2, settings.warrior.fury, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 3 and settings.hunter ~= nil then -- Hunter
			configuration.hunter = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.hunter.beastMastery) > 0 then -- Beast Mastery
				configuration.hunter.beastMastery = ExportConfigurationSections(3, 1, settings.hunter.beastMastery, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.hunter.marksmanship) > 0 then -- Marksmanship
				configuration.hunter.marksmanship = ExportConfigurationSections(3, 2, settings.hunter.marksmanship, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.hunter.survival) > 0 then -- Survival
				configuration.hunter.survival = ExportConfigurationSections(3, 3, settings.hunter.survival, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 4 and settings.rogue ~= nil then -- Rogue
			configuration.rogue = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.rogue.assassination) > 0 then -- Assassination
				configuration.rogue.assassination = ExportConfigurationSections(4, 1, settings.rogue.assassination, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.rogue.outlaw) > 0 then -- Outlaw
				configuration.rogue.outlaw = ExportConfigurationSections(4, 2, settings.rogue.outlaw, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 5 and settings.priest ~= nil then -- Priest
			configuration.priest = {}

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.priest.holy) > 0 then -- Holy
				configuration.priest.holy = ExportConfigurationSections(5, 2, settings.priest.holy, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.priest.shadow) > 0 then -- Shadow
				configuration.priest.shadow = ExportConfigurationSections(5, 3, settings.priest.shadow, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 7 and settings.shaman ~= nil then -- Shaman
			configuration.shaman = {}

			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.shaman.elemental) > 0 then -- Elemental
				configuration.shaman.elemental = ExportConfigurationSections(7, 1, settings.shaman.elemental, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
			
			if TRB.Data.settings.core.experimental.specs.shaman.enhancement then
				if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.shaman.enhancement) > 0 then -- Enhancement
					configuration.shaman.enhancement = ExportConfigurationSections(7, 2, settings.shaman.enhancement, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
				end
			end		

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.shaman.restoration) > 0 then -- Restoration
				configuration.shaman.restoration = ExportConfigurationSections(7, 3, settings.shaman.restoration, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 10 and settings.monk ~= nil then -- Monk
			configuration.monk = {}

			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.monk.mistweaver) > 0 then -- Mistweaver
				configuration.monk.mistweaver = ExportConfigurationSections(10, 2, settings.monk.mistweaver, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 3 or specId == nil) and TRB.Functions.Table:Length(settings.monk.windwalker) > 0 then -- Windwalker
				configuration.monk.windwalker = ExportConfigurationSections(10, 3, settings.monk.windwalker, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 11 and settings.druid ~= nil then -- Druid
			configuration.druid = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.druid.balance) > 0 then -- Balance
				configuration.druid.balance = ExportConfigurationSections(11, 1, settings.druid.balance, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
			
			if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.druid.feral) > 0 then -- Feral
				configuration.druid.feral = ExportConfigurationSections(11, 2, settings.druid.feral, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end

			if (specId == 4 or specId == nil) and TRB.Functions.Table:Length(settings.druid.restoration) > 0 then -- Restoration
				configuration.druid.restoration = ExportConfigurationSections(11, 4, settings.druid.restoration, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 12 and settings.demonhunter ~= nil then -- Demon Hunter
			configuration.demonhunter = {}
			
			if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.demonhunter.havoc) > 0 then -- Havoc
				configuration.demonhunter.havoc = ExportConfigurationSections(12, 1, settings.demonhunter.havoc, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
			end
		elseif classId == 13 and settings.evoker ~= nil then -- Evoker
			configuration.evoker = {}
			
			if TRB.Data.settings.core.experimental.specs.evoker.devastation then
				if (specId == 1 or specId == nil) and TRB.Functions.Table:Length(settings.evoker.devastation) > 0 then -- Devastation
					configuration.evoker.devastation = ExportConfigurationSections(13, 1, settings.evoker.devastation, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
				end
			end			
			
			if TRB.Data.settings.core.experimental.specs.evoker.preservation then
				if (specId == 2 or specId == nil) and TRB.Functions.Table:Length(settings.evoker.preservation) > 0 then -- Preservation
					configuration.evoker.preservation = ExportConfigurationSections(13, 2, settings.evoker.preservation, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText)
				end
			end
		end
	elseif classId == nil and specId == nil then -- Everything
		-- Instead of just dumping the whole table, let's clean it up

		-- Warriors
		-- Arms
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Fury
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(1, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Hunters
		-- Beast Mastery
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Marksmanship
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Survival
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(3, 3, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Monks
		-- Mistweaver
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Windwalker
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(10, 3, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Priests
		-- Holy
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Shadow
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(5, 3, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Rogues
		-- Assassination
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Outlaw
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(4, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Shamans
		-- Elemental
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		if TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			-- Enhancement
			configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		end
		-- Restoration
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(7, 3, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Druids
		-- Balance
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Feral
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		-- Restoration
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(11, 4, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))

		-- Demon Hunter
		-- Havoc
		configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(12, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		
		-- Evoker
		if TRB.Data.settings.core.experimental.specs.evoker.devastation then
			-- Devastation
			configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 1, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		end

		if TRB.Data.settings.core.experimental.specs.evoker.preservation then
			-- Preservation
			configuration = TRB.Functions.Table:Merge(configuration, ExportGetConfiguration(13, 2, settings, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText))
		end
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
		(configuration.warrior ~= nil and (configuration.warrior.arms ~= nil or configuration.warrior.fury ~= nil)) or
		(configuration.rogue ~= nil and (configuration.rogue.assassination ~= nil or configuration.rogue.outlaw ~= nil)) or
		(configuration.hunter ~= nil and (configuration.hunter.beastMastery ~= nil or configuration.hunter.marksmanship ~= nil or configuration.hunter.survival ~= nil)) or
		(configuration.monk ~= nil and (configuration.monk.mistweaver ~= nil or configuration.monk.windwalker ~= nil)) or
		(configuration.priest ~= nil and (configuration.priest.holy ~= nil or configuration.priest.shadow ~= nil)) or
		(configuration.shaman ~= nil and
			(configuration.shaman.elemental ~= nil or
			configuration.shaman.restoration ~= nil or
			(TRB.Data.settings.core.experimental.specs.shaman.enhancement and configuration.shaman.enhancement ~= nil))) or
		(configuration.druid ~= nil and (configuration.druid.balance ~= nil or configuration.druid.feral ~= nil)) or
		(configuration.evoker ~= nil and (TRB.Data.settings.core.experimental.specs.evoker.devastation and configuration.evoker.devastation ~= nil) or (TRB.Data.settings.core.experimental.specs.evoker.preservation and configuration.evoker.preservation ~= nil))) then
		return -3
	end

	local existingSettings = TRB.Data.settings

	local function TableMergeWrapper(existing, config)
		return TRB.Functions.Table:Merge(existing, config)
	end

	result, mergedSettings = pcall(TableMergeWrapper, existingSettings, configuration)

	if not result then
		return -4
	end

	TRB.Data.settings = mergedSettings
	return 1
end

function TRB.Functions.IO:ExportPopup(exportMessage, classId, specId, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
	StaticPopupDialogs["TwintopResourceBar_Export"].text = exportMessage
	StaticPopupDialogs["TwintopResourceBar_Export"].OnShow = function(self)
		local configuration = ExportGetConfiguration(classId, specId, includeBarDisplay, includeFontAndText, includeAudioAndTracking, includeBarText, includeCore)
		local output = Export(configuration)
---@diagnostic disable-next-line: undefined-field
		self.editBox:SetText(output)
	end
	StaticPopup_Show("TwintopResourceBar_Export")
end