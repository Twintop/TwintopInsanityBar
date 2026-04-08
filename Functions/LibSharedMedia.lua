---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.LibSharedMedia = {}


---Validates all LibSharedMedia references (fonts, textures, sounds) in a spec's settings, resetting any invalid entries to defaults
---@param specName string The name of the specialization whose settings are being validated
---@param settings table The spec settings table containing displayText, textures, and audio sub-tables
---@return table settings The validated settings table with any invalid LSM references replaced by defaults
function TRB.Functions.LibSharedMedia:ValidateLsmValues(specName, settings)
	--[[
		Other addons can add/remove/alter entries in the LibSharedMedia. As a result, sometimes a previously usable asset
		goes missing or gets renamed. Do some logic checks here to fix common errors instead of causing the bar to blow
		up with Lua errors or show default neon-green textures.
	]]
	
	-- Text
	if settings.displayText ~= nil and settings.displayText.barText ~= nil then
		---@type TRB.Classes.Settings.DisplayTextEntry[]
		local barText = settings.displayText.barText
		for _, bt in pairs(barText) do
			if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.FONT, bt.fontFaceName) then
				bt.fontFace = TRB.Details.addonData.libs.SharedMedia.MediaTable.font[bt.fontFaceName]
			else
				print(string.format(L["LSMInvalidFont"], specName, bt.name, bt.fontFaceName))
				bt.fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace
				bt.fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName
			end
		end
	end

	-- Textures
	-- Bar
	if settings.textures ~= nil then
		if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.BACKGROUND, settings.textures.backgroundName) then
			settings.textures.background = TRB.Details.addonData.libs.SharedMedia.MediaTable.background[settings.textures.backgroundName]
		else
			print(string.format(L["LSMInvalidBarBackgroundTexture"], specName, settings.textures.backgroundName))
			settings.textures.background = TRB.Data.constants.defaultSettings.textures.background
			settings.textures.backgroundName = TRB.Data.constants.defaultSettings.textures.backgroundName
		end

		if not TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.BORDER, settings.textures.borderName) and settings.textures.borderName ~= "1 Pixel" then
			print(string.format(L["LSMInvalidBarBorderTexture"], specName, settings.textures.borderName))
			settings.textures.border = TRB.Data.constants.defaultSettings.textures.border
			settings.textures.borderName = TRB.Data.constants.defaultSettings.textures.borderName
		else
			settings.textures.border = TRB.Details.addonData.libs.SharedMedia.MediaTable.border[settings.textures.borderName]
		end

		if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.STATUSBAR, settings.textures.resourceBarName) then
			settings.textures.resourceBar = TRB.Details.addonData.libs.SharedMedia.MediaTable.statusbar[settings.textures.resourceBarName]
		else
			print(string.format(L["LSMInvalidBarResourceTexture"], specName, settings.textures.resourceBarName))
			settings.textures.resourceBar = TRB.Data.constants.defaultSettings.textures.resourceBar
			settings.textures.resourceBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
		end

		-- Combo Points
		if settings.textures.comboPointsBorder ~= nil then
			if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.BACKGROUND, settings.textures.comboPointsBackgroundName) then
				settings.textures.comboPointsBackground = TRB.Details.addonData.libs.SharedMedia.MediaTable.background[settings.textures.comboPointsBackgroundName]
			else
				print(string.format(L["LSMInvalidComboPointBackgroundTexture"], specName, settings.textures.comboPointsBackgroundName))
				settings.textures.comboPointsBackground = TRB.Data.constants.defaultSettings.textures.background
				settings.textures.comboPointsBackgroundName = TRB.Data.constants.defaultSettings.textures.backgroundName
			end

			if not TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.BORDER, settings.textures.comboPointsBorderName) and settings.textures.comboPointsBorderName ~= "1 Pixel" then
				print(string.format(L["LSMInvalidComboPointBorderTexture"], specName, settings.textures.comboPointsBorderName))
				settings.textures.comboPointsBorder = TRB.Data.constants.defaultSettings.textures.border
				settings.textures.comboPointsBorderName = TRB.Data.constants.defaultSettings.textures.borderName
			else
				settings.textures.comboPointsBorder = TRB.Details.addonData.libs.SharedMedia.MediaTable.border[settings.textures.comboPointsBorderName]
			end

			if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.STATUSBAR, settings.textures.comboPointsBarName) then
				settings.textures.comboPointsBar = TRB.Details.addonData.libs.SharedMedia.MediaTable.statusbar[settings.textures.comboPointsBarName]
			else
				print(string.format(L["LSMInvalidComboPointResourceTexture"], specName, settings.textures.comboPointsBarName))
				settings.textures.comboPointsBar = TRB.Data.constants.defaultSettings.textures.resourceBar
				settings.textures.comboPointsBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
			end
		end
	end

	if settings.audio ~= nil then
		for k, v in pairs(settings.audio) do
			if k ~= "channel" and v.soundName == nil or not TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.SOUND, v.soundName) then
				if type(v.name) == "table" or type(v.soundName) == "table" then
					print(string.format(L["LSMInvalidSound"], specName))
				elseif v.name ~= nil and v.soundName ~= nil then
					print(string.format(L["LSMInvalidSoundNameBoth"], specName, v.name, v.soundName))
				elseif v.soundName ~= nil then
					print(string.format(L["LSMInvalidSoundNameOnlySoundName"], specName, v.soundName))
				elseif v.name ~= nil then
					print(string.format(L["LSMInvalidSoundNameOnlyName"], specName, v.name))
				else
					print(string.format(L["LSMInvalidSound"], specName))
				end
				settings.audio[k].sound = TRB.Data.constants.defaultSettings.sounds.sound
				settings.audio[k].soundName = TRB.Data.constants.defaultSettings.sounds.soundName
			else
				settings.audio[k].sound = TRB.Details.addonData.libs.SharedMedia.MediaTable.sound[v.soundName]
			end
		end
	end

	-- Threshold Dictionary Audio
	if settings.thresholds ~= nil and settings.thresholds.thresholdDictionary ~= nil then
		for k, dictEntry in pairs(settings.thresholds.thresholdDictionary) do
			if dictEntry.audio ~= nil and dictEntry.audio.soundName ~= nil and dictEntry.audio.soundName ~= "" then
				if not TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.SOUND, dictEntry.audio.soundName) then
					print(string.format(L["LSMInvalidSoundNameOnlySoundName"], specName, dictEntry.audio.soundName))
					dictEntry.audio.sound = TRB.Data.constants.defaultSettings.sounds.sound
					dictEntry.audio.soundName = TRB.Data.constants.defaultSettings.sounds.soundName
				else
					dictEntry.audio.sound = TRB.Details.addonData.libs.SharedMedia.MediaTable.sound[dictEntry.audio.soundName]
				end
			end
		end
	end

	return settings
end