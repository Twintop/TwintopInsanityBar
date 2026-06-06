---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.IO = {}
TRB.Data = TRB.Data or {}

local EXPORT_STRING_PREFIX = "!TRB!"
local EXPORT_STRING_PREFIX2 = "!TRBv2!"

local SECONDARY_BAR_EXPORT_SPECS = {
	[1] = { [2] = true },
	[2] = { [1] = true, [2] = true, [3] = true },
	[3] = { [3] = true },
	[4] = { [1] = true, [2] = true, [3] = true },
	[5] = { [1] = true },
	[6] = { [1] = true, [2] = true, [3] = true },
	[7] = { [2] = true },
	[8] = { [1] = true, [3] = true },
	[9] = { [1] = true, [2] = true, [3] = true },
	[10] = { [3] = true },
	[11] = { [2] = true },
	[12] = { [2] = true, [3] = true },
	[13] = { [1] = true, [2] = true, [3] = true },
}

local CUSTOM_BAR_EXPORT_SPECS = {
	[1] = {
		[2] = { "whirlwind" },
		[3] = { "defensives" },
	},
	[5] = {
		[1] = { "utility" },
		[2] = { "holyWords", "lightweaver", "utility" },
		[3] = { "mana", "utility" },
	},
	[6] = {
		[1] = { "boneShield" },
	},
	[7] = {
		[1] = { "mana" },
	},
	[10] = {
		[1] = { "stagger" },
	},
	[11] = {
		[1] = { "mana" },
	},
	[13] = {
		[3] = { "ebonMight" },
	},
}

local CORE_TEXTURE_KEYS = {
	"background",
	"backgroundName",
	"border",
	"borderName",
	"resourceBar",
	"resourceBarName",
	"textureLock",
	"healthBackground",
	"healthBackgroundName",
	"healthBorder",
	"healthBorderName",
	"healthBar",
	"healthBarName",
	"absorbBar",
	"absorbBarName",
	"incomingHealBar",
	"incomingHealBarName",
	"castingBar",
	"castingBarName",
}

local DRUID_DISPLAY_BAR_FLAG_KEYS = {
	"enableFormSwitching",
	"showComboPoints",
}

local function CopyKey(destination, source, key)
	if destination ~= nil and source ~= nil and source[key] ~= nil then
		destination[key] = source[key]
	end
end

local function CopyKeys(destination, source, keys)
	if destination == nil or source == nil then
		return
	end

	for _, key in ipairs(keys) do
		CopyKey(destination, source, key)
	end
end

local function CopyTexturePrefix(destination, source, prefix)
	CopyKeys(destination, source, {
		prefix .. "Bar",
		prefix .. "BarName",
		prefix .. "Border",
		prefix .. "BorderName",
		prefix .. "Background",
		prefix .. "BackgroundName",
	})
end

local function CopyDruidDisplayBarFlags(configuration, settings, classId)
	if classId ~= 11 then
		return
	end

	CopyKeys(configuration.displayBar, settings.displayBar, DRUID_DISPLAY_BAR_FLAG_KEYS)
end

local function ShouldExportSecondaryBar(classId, specId, settings)
	local hasSecondarySettings = settings.comboPoints ~= nil or (settings.colors ~= nil and settings.colors.comboPoints ~= nil)
	if not hasSecondarySettings then
		return false
	end

	if SECONDARY_BAR_EXPORT_SPECS[classId] ~= nil and SECONDARY_BAR_EXPORT_SPECS[classId][specId] == true then
		return true
	end

	local specConfiguration = TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
	return specConfiguration ~= nil and specConfiguration.secondary ~= nil
end

local function AddCustomBarKey(allowedBars, barKey)
	if barKey ~= nil then
		allowedBars[barKey] = true
	end
end

local function GetAllowedCustomBarKeys(classId, specId)
	local allowedBars = {}
	local registry = TRB.Classes and TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()

	if registry ~= nil then
		local registryBars = registry:GetBarTypesForSpec(classId, specId)
		for barKey in pairs(registryBars) do
			AddCustomBarKey(allowedBars, barKey)
		end
	end

	local classBars = CUSTOM_BAR_EXPORT_SPECS[classId]
	local specBars = classBars and classBars[specId]
	if specBars ~= nil then
		for _, barKey in ipairs(specBars) do
			AddCustomBarKey(allowedBars, barKey)
		end
	end

	return allowedBars
end

local function CopySecondaryBarConfiguration(configuration, settings)
	configuration.comboPoints = settings.comboPoints
	configuration.colors.comboPoints = settings.colors and settings.colors.comboPoints

	CopyKey(configuration.displayBar, settings.displayBar, "secondary")
	CopyTexturePrefix(configuration.textures, settings.textures, "comboPoints")
	CopyKeys(configuration.textures, settings.textures, {
		"comboPointsCastingBar",
		"comboPointsCastingBarName",
	})
end

local function CopyCustomBarConfiguration(configuration, settings, barKey)
	local registry = TRB.Classes and TRB.Classes.BarTypeRegistry and TRB.Classes.BarTypeRegistry:GetInstance()
	local barTypeDef = registry and registry:Get(barKey)
	local barSettings = settings.bars and settings.bars[barKey]

	if barSettings ~= nil then
		configuration.bars = configuration.bars or {}
		configuration.bars[barKey] = barSettings

		local visibilityKey = barTypeDef and barTypeDef.visibilityKey or barKey
		CopyKey(configuration.displayBar, settings.displayBar, visibilityKey)
		CopyTexturePrefix(configuration.textures, settings.textures, barKey)

		if barKey == "mana" then
			CopyTexturePrefix(configuration.textures, settings.textures, "manaBar")
		end
	end

	local barColors = settings.colors and settings.colors.bars and settings.colors.bars[barKey]
	if barColors ~= nil then
		configuration.colors.bars = configuration.colors.bars or {}
		configuration.colors.bars[barKey] = barColors
	end
end

local function CopyCustomBarConfigurations(configuration, settings, classId, specId)
	local allowedBars = GetAllowedCustomBarKeys(classId, specId)
	for barKey in pairs(allowedBars) do
		CopyCustomBarConfiguration(configuration, settings, barKey)
	end
end

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
		configuration.displayBar = {}
		configuration.textures = {}
		configuration.colors.bar = settings.colors and settings.colors.bar
		configuration.colors.shared = settings.colors and settings.colors.shared
		configuration.colors.healthBar = settings.colors and settings.colors.healthBar
		configuration.overcap = settings.overcap
		configuration.endOf = settings.endOf

		CopyKeys(configuration.displayBar, settings.displayBar, { "primary", "health" })
		CopyDruidDisplayBarFlags(configuration, settings, classId)
		CopyKeys(configuration.textures, settings.textures, CORE_TEXTURE_KEYS)

		if ShouldExportSecondaryBar(classId, specId, settings) then
			CopySecondaryBarConfiguration(configuration, settings)
		end

		CopyCustomBarConfigurations(configuration, settings, classId, specId)
	end

	if includeThresholds then
		configuration.thresholds = settings.thresholds
		configuration.colors.threshold = settings.colors and settings.colors.threshold
	end

	if includeFontAndText then
		configuration.colors.text = settings.colors and settings.colors.text
		configuration.precision = settings.precision
		configuration.displayText.default = settings.displayText and settings.displayText.default

		if classId == 5 and specId == 3 then -- Shadow Priest
			configuration.hasteApproachingThreshold = settings.hasteApproachingThreshold
			configuration.hasteThreshold = settings.hasteThreshold
		end
	end

	if includeAudioAndTracking then
		configuration.audio = settings.audio
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

	local function ExportClassEntry(entry)
		if entry == nil then
			return
		end

		local classSettings = settings[entry.className]
		if type(classSettings) ~= "table" then
			return
		end

		local classConfiguration = {}
		for _, specEntry in ipairs(entry.specs) do
			if specId == nil or specId == specEntry.specId then
				local specSettings = classSettings[specEntry.specName]
				if type(specSettings) == "table" and TRB.Functions.Table:Length(specSettings) > 0 then
					classConfiguration[specEntry.specName] = ExportConfigurationSections(specEntry.classId, specEntry.specId, specSettings, includeBarDisplay, includeThresholds, includeFontAndText, includeAudioAndTracking, includeBarText)
				end
			end
		end

		if next(classConfiguration) ~= nil then
			configuration[entry.className] = classConfiguration
		end
	end

	if classId ~= nil then
		ExportClassEntry(TRB.Functions.Character:GetClassRegistryEntry(classId))
	elseif classId == nil and specId == nil then -- Everything
		for _, entry in ipairs(TRB.Functions.Character:GetClassRegistryEntriesOrdered()) do
			ExportClassEntry(entry)
		end
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

-- =============================================================================
-- Phase 3: Profile Import/Export helpers
-- =============================================================================
-- These are additive helpers used by the profile dropdown's Import/Export
-- actions. They do not modify the behaviour of the legacy `HandleExport` /
-- `HandleImport` pipeline used by the Import/Export options screen.

---Resolves `(classId, specId)` to `(className, specName)`.
---@param classId integer
---@param specId integer
---@return string? className
---@return string? specName
function TRB.Functions.IO:GetClassSpecNamesById(classId, specId)
	local entry = TRB.Functions.Character:GetSpecRegistryEntryFromIds(classId, specId)
	if entry == nil then
		return nil, nil
	end
	return entry.className, entry.specName
end

---Resolves `(className, specName)` to `(classId, specId)`.
---@param className string
---@param specName string
---@return integer? classId
---@return integer? specId
function TRB.Functions.IO:GetClassSpecIdsByName(className, specName)
	local classEntry = TRB.Functions.Character:GetClassRegistryEntry(className)
	if classEntry == nil then
		return nil, nil
	end
	for _, specEntry in ipairs(classEntry.specs) do
		if specEntry.specName == specName then
			return classEntry.classId, specEntry.specId
		end
	end
	return classEntry.classId, nil
end

---Decodes an export string into a Lua table. Strips the `!TRBv2!` or legacy
---`!TRB!` prefix, base64-decodes, deflate-decompresses (v2 only), and
---JSON-deserializes. Factored out of `HandleImport` so the profile Import UI
---can inspect the decoded payload shape without merging it.
---@param input string # The full export string
---@return boolean ok
---@return table|nil configuration # Decoded Lua table on success
---@return integer? errorCode # -1 base64 error, -2 decompression error, -3 JSON error
function TRB.Functions.IO:DecodeExportString(input)
	if type(input) ~= "string" or input == "" then
		return false, nil, -1
	end

	local prefix = string.sub(input, 1, 5)
	local prefixV2 = string.sub(input, 1, 7)
	local exportVersion
	local body

	if prefixV2 == EXPORT_STRING_PREFIX2 then
		exportVersion = 2
		body = string.sub(input, 8)
	elseif prefix == EXPORT_STRING_PREFIX then
		exportVersion = 1
		body = string.sub(input, 6)
	else
		-- No recognised prefix; treat as unprefixed v1 payload for symmetry with legacy behaviour.
		exportVersion = 1
		body = input
	end

	local ok, decoded = pcall(C_EncodingUtil.DecodeBase64, body)
	if not ok then
		return false, nil, -1
	end

	if exportVersion == 2 then
		local decompOk, decompressed = pcall(C_EncodingUtil.DecompressString, decoded, Enum.CompressionMethod.Deflate)
		if not decompOk then
			return false, nil, -2
		end
		decoded = decompressed
	end

	local parseOk, configuration = pcall(C_EncodingUtil.DeserializeJSON, decoded)
	if not parseOk or type(configuration) ~= "table" then
		return false, nil, -3
	end

	return true, configuration, nil
end

---Builds the export configuration table for a single-spec profile export.
---Wraps the `ExportConfigurationSections` output under
---`profiles.list[profileName][className][specName]`, with optional `core`.
---@param profileName string
---@param classId integer
---@param specId integer
---@param specPiece table # Source settings table for the spec (live or stored)
---@param corePiece table? # Optional source settings table for core
---@return table? configuration # The wrapped export configuration, or nil on invalid inputs
function TRB.Functions.IO:BuildSpecProfileExportConfiguration(profileName, classId, specId, specPiece, corePiece)
	if type(profileName) ~= "string" or profileName == "" then
		return nil
	end
	local className, specName = self:GetClassSpecNamesById(classId, specId)
	if className == nil or specName == nil then
		return nil
	end
	if type(specPiece) ~= "table" then
		return nil
	end

	local specConfig = ExportConfigurationSections(classId, specId, specPiece, true, true, true, true, true)

	local configuration = {
		profiles = {
			list = {
				[profileName] = {
					[className] = {
						[specName] = specConfig,
					},
				},
			},
		},
	}

	if type(corePiece) == "table" then
		configuration.profiles.list[profileName].core = TRB.Functions.Table:DeepCopy(corePiece)
	end

	return configuration
end

---Builds the export configuration table for a class-level profile export.
---Wraps every available spec piece for the class under
---`profiles.list[profileName][className][specName]`, with optional `core`.
---@param profileName string
---@param classId integer
---@param specPieces table<string, table> # Map of specName -> source settings table
---@param corePiece table? # Optional source settings table for core
---@return table? configuration # The wrapped export configuration, or nil on invalid inputs
function TRB.Functions.IO:BuildClassProfileExportConfiguration(profileName, classId, specPieces, corePiece)
	if type(profileName) ~= "string" or profileName == "" then
		return nil
	end

	local entry = TRB.Functions.Character:GetClassRegistryEntry(classId)
	if entry == nil or type(specPieces) ~= "table" then
		return nil
	end

	local classConfig = {}
	local hasAnySpec = false
	for _, specEntry in ipairs(entry.specs) do
		local specId = specEntry.specId
		local specName = specEntry.specName
		local specPiece = specPieces[specName]
		if type(specPiece) == "table" then
			classConfig[specName] = ExportConfigurationSections(classId, specId, specPiece, true, true, true, true, true)
			hasAnySpec = true
		end
	end

	if not hasAnySpec then
		return nil
	end

	local configuration = {
		profiles = {
			list = {
				[profileName] = {
					[entry.className] = classConfig,
				},
			},
		},
	}

	if type(corePiece) == "table" then
		configuration.profiles.list[profileName].core = TRB.Functions.Table:DeepCopy(corePiece)
	end

	return configuration
end

---Resolves the "live vs stored" spec piece for an export. Returns the deep-
---copied live spec settings if the character is currently on that spec AND
---the requested profile matches the resolved active profile for that spec;
---otherwise returns a deep copy of the stored profile piece. Returns nil if
---neither source has data.
---@param profileName string
---@param className string
---@param specName string
---@return table?
local function ResolveLiveOrStoredSpecPiece(profileName, className, specName)
	local character = TRB.Data.character
	local classId, specId = TRB.Functions.IO:GetClassSpecIdsByName(className, specName)
	local useLive = character ~= nil
		and character.classId == classId
		and character.specId == specId
		and TRB.Functions.Profiles ~= nil
		and (TRB.Functions.Profiles:ResolveSpecProfileName(className, specName) == profileName)

	if useLive then
		local live = TRB.Data.settings and TRB.Data.settings[className] and TRB.Data.settings[className][specName]
		if type(live) == "table" then
			return TRB.Functions.Table:DeepCopy(live)
		end
	end

	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p ~= nil and p.list ~= nil and p.list[profileName] ~= nil
		and type(p.list[profileName][className]) == "table"
		and type(p.list[profileName][className][specName]) == "table" then
		return TRB.Functions.Table:DeepCopy(p.list[profileName][className][specName])
	end

	return nil
end

---Resolves the "live vs stored" core piece for an export. Returns deep-copied
---live core settings if the requested profile matches the resolved active core
---profile; otherwise returns a deep copy of the stored core piece. Returns nil
---if neither source has data.
---@param profileName string
---@return table?
local function ResolveLiveOrStoredCorePiece(profileName)
	local useLive = TRB.Functions.Profiles ~= nil
		and (TRB.Functions.Profiles:ResolveCoreProfileName() == profileName)

	if useLive then
		local live = TRB.Data.settings and TRB.Data.settings.core
		if type(live) == "table" then
			return TRB.Functions.Table:DeepCopy(live)
		end
	end

	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p ~= nil and p.list ~= nil and p.list[profileName] ~= nil
		and type(p.list[profileName].core) == "table" then
		return TRB.Functions.Table:DeepCopy(p.list[profileName].core)
	end

	return nil
end

---Exports a single spec profile (optionally with its core piece) as an
---encoded export string. The spec piece is read live when the requested
---profile matches the currently-active profile for that spec on the current
---character; otherwise the stored copy is used. The core piece follows the
---same live-vs-stored rule against the core profile resolution.
---@param profileName string
---@param classId integer
---@param specId integer
---@param includeCore boolean
---@return string? exportString # Encoded export string, or nil on error
---@return integer? errorCode # -1 invalid args, -2 no spec data available
function TRB.Functions.IO:ExportSpecProfile(profileName, classId, specId, includeCore)
	local className, specName = self:GetClassSpecNamesById(classId, specId)
	if type(profileName) ~= "string" or profileName == "" or className == nil or specName == nil then
		return nil, -1
	end

	local specPiece = ResolveLiveOrStoredSpecPiece(profileName, className, specName)
	if specPiece == nil then
		return nil, -2
	end

	local corePiece
	if includeCore then
		corePiece = ResolveLiveOrStoredCorePiece(profileName)
	end

	local configuration = self:BuildSpecProfileExportConfiguration(profileName, classId, specId, specPiece, corePiece)
	if configuration == nil then
		return nil, -1
	end

	return Export(configuration), nil
end

---Exports every available spec piece in a class profile (optionally with its
---core piece) as an encoded export string.
---@param profileName string
---@param classId integer
---@param includeCore boolean
---@return string? exportString # Encoded export string, or nil on error
---@return integer? errorCode # -1 invalid args, -2 no class data available
function TRB.Functions.IO:ExportClassProfile(profileName, classId, includeCore)
	local entry = TRB.Functions.Character:GetClassRegistryEntry(classId)
	if type(profileName) ~= "string" or profileName == "" or entry == nil then
		return nil, -1
	end

	local specPieces = {}
	local hasAnySpec = false
	for _, specEntry in ipairs(entry.specs) do
		local specName = specEntry.specName
		local specPiece = ResolveLiveOrStoredSpecPiece(profileName, entry.className, specName)
		if specPiece ~= nil then
			specPieces[specName] = specPiece
			hasAnySpec = true
		end
	end

	if not hasAnySpec then
		return nil, -2
	end

	local corePiece
	if includeCore then
		corePiece = ResolveLiveOrStoredCorePiece(profileName)
	end

	local configuration = self:BuildClassProfileExportConfiguration(profileName, classId, specPieces, corePiece)
	if configuration == nil then
		return nil, -1
	end

	return Export(configuration), nil
end

---Exports a core-only profile as an encoded export string. Used by the core
---profile dropdown's Export action. The core piece is read live when the
---requested profile matches the currently-active core profile; otherwise the
---stored copy is used.
---@param profileName string
---@return string? exportString
---@return integer? errorCode # -1 invalid args, -2 no core data available
function TRB.Functions.IO:ExportCoreProfile(profileName)
	if type(profileName) ~= "string" or profileName == "" then
		return nil, -1
	end

	local corePiece = ResolveLiveOrStoredCorePiece(profileName)
	if corePiece == nil then
		return nil, -2
	end

	local configuration = {
		profiles = {
			list = {
				[profileName] = {
					core = corePiece,
				},
			},
		},
	}

	return Export(configuration), nil
end

---Exports an entire stored profile (all class/spec pieces and optionally the
---core piece) as an encoded export string. Each spec piece is resolved
---live-vs-stored using the same rules as ExportSpecProfile. Returns nil on
---error.
---@param profileName string
---@return string? exportString # Encoded export string, or nil on error
---@return integer? errorCode  # -1 invalid args, -2 no data found for that profile
function TRB.Functions.IO:ExportFullProfile(profileName)
	if type(profileName) ~= "string" or profileName == "" then
		return nil, -1
	end

	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil or p.list[profileName] == nil then
		return nil, -2
	end

	local profileBody = {}

	-- Core piece. A full profile export must always carry a core piece, even
	-- if the named profile has no core stored. When missing, fall back to the
	-- currently-active core profile so the recipient gets a complete bundle.
	local corePiece = ResolveLiveOrStoredCorePiece(profileName)
	if corePiece == nil and TRB.Functions.Profiles ~= nil then
		local activeCoreName = TRB.Functions.Profiles:ResolveCoreProfileName()
		if activeCoreName ~= nil then
			local liveCore = TRB.Data.settings and TRB.Data.settings.core
			if type(liveCore) == "table" then
				corePiece = TRB.Functions.Table:DeepCopy(liveCore)
			elseif p.list[activeCoreName] ~= nil and type(p.list[activeCoreName].core) == "table" then
				corePiece = TRB.Functions.Table:DeepCopy(p.list[activeCoreName].core)
			end
		end
	end
	if corePiece ~= nil then
		profileBody.core = corePiece
	end

	-- All spec pieces
	local hasAnySpec = false
	for _, entry in ipairs(TRB.Functions.Character:GetClassRegistryEntriesOrdered()) do
		for _, specEntry in ipairs(entry.specs) do
			local specId = specEntry.specId
			local specName = specEntry.specName
			local specPiece = ResolveLiveOrStoredSpecPiece(profileName, entry.className, specName)
			if specPiece ~= nil then
				profileBody[entry.className] = profileBody[entry.className] or {}
				profileBody[entry.className][specName] = ExportConfigurationSections(
					entry.classId, specId, specPiece, true, true, true, true, true)
				hasAnySpec = true
			end
		end
	end

	if not hasAnySpec and profileBody.core == nil then
		return nil, -2
	end

	local configuration = {
		profiles = {
			list = {
				[profileName] = profileBody,
			},
		},
	}
	return Export(configuration), nil
end

---Exports only the pieces of a profile that are checked in `selection`
---(mirrors `CopyProfileSelection`). `selection.core` includes the core piece;
---`selection[className][specName] = true` includes that spec piece.
---@param profileName string
---@param selection table # { core = bool, [className] = { [specName] = bool } }
---@return string? exportString
---@return integer? errorCode # -1 invalid args, -2 no data selected
function TRB.Functions.IO:ExportProfileSelection(profileName, selection)
	if type(profileName) ~= "string" or profileName == "" or type(selection) ~= "table" then
		return nil, -1
	end

	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil or p.list[profileName] == nil then
		return nil, -2
	end

	local profileBody = {}
	local hasAny = false

	if selection.core then
		local corePiece = ResolveLiveOrStoredCorePiece(profileName)
		if corePiece ~= nil then
			profileBody.core = corePiece
			hasAny = true
		end
	end

	for _, entry in ipairs(TRB.Functions.Character:GetClassRegistryEntriesOrdered()) do
		local specSel = selection[entry.className]
		if type(specSel) == "table" then
			for _, specEntry in ipairs(entry.specs) do
				local specId = specEntry.specId
				local specName = specEntry.specName
				if specSel[specName] then
					local specPiece = ResolveLiveOrStoredSpecPiece(profileName, entry.className, specName)
					if specPiece ~= nil then
						profileBody[entry.className] = profileBody[entry.className] or {}
						profileBody[entry.className][specName] = ExportConfigurationSections(
							entry.classId, specId, specPiece, true, true, true, true, true)
						hasAny = true
					end
				end
			end
		end
	end

	if not hasAny then
		return nil, -2
	end

	local configuration = {
		profiles = {
			list = {
				[profileName] = profileBody,
			},
		},
	}
	return Export(configuration), nil
end

---Parses an import string into a normalised descriptor suitable for the
---profile Import UI. Detects profile-wrapped vs bare payloads, validates that
---spec/core pieces map to known (className, specName) pairs, and returns the
---list of valid slots.
---@param input string
---@return table? parsed # Normalised descriptor on success; shape below
---@return integer? errorCode # -1/-2/-3 decode, -4 no valid slots, -6 multiple profiles, -7 empty profile
--- parsed = {
---   kind = "wrapped"|"bare",
---   suggestedName = string?,          -- only for wrapped
---   profileBody = table,              -- { core?, [className][specName] = {...} }
---   validSpecs = { { className = string, specName = string } ... },
---   hasCore = boolean,
--- }
function TRB.Functions.IO:ParseProfileImport(input)
	local ok, configuration, errorCode = self:DecodeExportString(input)
	if not ok or type(configuration) ~= "table" then
		return nil, errorCode or -3
	end

	local kind
	local suggestedName
	local profileBody

	if type(configuration.profiles) == "table" and type(configuration.profiles.list) == "table" then
		kind = "wrapped"
		local count = 0
		local firstName
		for name, body in pairs(configuration.profiles.list) do
			count = count + 1
			if firstName == nil then
				firstName = name
				profileBody = body
			end
		end
		if count == 0 then
			return nil, -7
		elseif count > 1 then
			return nil, -6
		end
		suggestedName = firstName
	else
		kind = "bare"
		profileBody = configuration
	end

	if type(profileBody) ~= "table" then
		return nil, -4
	end

	local validSpecs = {}
	local hasCore = type(profileBody.core) == "table" and next(profileBody.core) ~= nil
	for _, entry in ipairs(TRB.Functions.Character:GetClassRegistryEntriesOrdered()) do
		local classTable = profileBody[entry.className]
		if type(classTable) == "table" then
			for _, specEntry in ipairs(entry.specs) do
				local specName = specEntry.specName
				local piece = classTable[specName]
				if type(piece) == "table" and next(piece) ~= nil then
					validSpecs[#validSpecs + 1] = { className = entry.className, specName = specName }
				end
			end
		end
	end

	if (not hasCore) and #validSpecs == 0 then
		return nil, -4
	end

	return {
		kind = kind,
		suggestedName = suggestedName,
		profileBody = profileBody,
		validSpecs = validSpecs,
		hasCore = hasCore,
	}, nil
end
