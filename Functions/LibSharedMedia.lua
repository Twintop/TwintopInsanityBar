---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.LibSharedMedia = {}


function TRB.Functions.LibSharedMedia:ValidateLsmValues(specName, settings)
	--[[
		Other addons can add/remove/alter entries in the LibSharedMedia. As a result, sometimes a previously usable asset
		goes missing or gets renamed. Do some logic checks here to fix common errors instead of causing the bar to blow
		up with LUA errors or show default neon-green textures.
	]]
	
	-- Text
	if settings.displayText ~= nil and settings.displayText.barText ~= nil then
		---@type TRB.Classes.DisplayTextEntry[]
		local barText = settings.displayText.barText
		for idx, bt in pairs(barText) do
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
			print(L["LSMInvalidBarBackgroundTexture"], specName, settings.textures.backgroundName)
			settings.textures.background = TRB.Data.constants.defaultSettings.textures.background
			settings.textures.backgroundName = TRB.Data.constants.defaultSettings.textures.backgroundName
		end

		if not TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.BORDER, settings.textures.borderName) and settings.textures.borderName ~= "1 Pixel" then
			print(L["LSMInvalidBarBorderTexture"], specName, settings.textures.borderName)
			settings.textures.border = TRB.Data.constants.defaultSettings.textures.border
			settings.textures.borderName = TRB.Data.constants.defaultSettings.textures.borderName
		else
			settings.textures.border = TRB.Details.addonData.libs.SharedMedia.MediaTable.border[settings.textures.borderName]
		end

		if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.STATUSBAR, settings.textures.resourceBarName) then
			settings.textures.resourceBar = TRB.Details.addonData.libs.SharedMedia.MediaTable.statusbar[settings.textures.resourceBarName]
		else
			print(L["LSMInvalidBarResourceTexture"], specName, settings.textures.resourceBarName)
			settings.textures.resourceBar = TRB.Data.constants.defaultSettings.textures.resourceBar
			settings.textures.resourceBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
		end

		if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.STATUSBAR, settings.textures.passiveBarName) then
			settings.textures.passiveBar = TRB.Details.addonData.libs.SharedMedia.MediaTable.statusbar[settings.textures.passiveBarName]
		else
			print(L["LSMInvalidBarPassiveTexture"], specName, settings.textures.passiveBarName)
			settings.textures.passiveBar = TRB.Data.constants.defaultSettings.textures.resourceBar
			settings.textures.passiveBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
		end

		if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.STATUSBAR, settings.textures.castingBarName) then
			settings.textures.castingBar = TRB.Details.addonData.libs.SharedMedia.MediaTable.statusbar[settings.textures.castingBarName]
		else
			print(L["LSMInvalidBarCastingTexture"], specName, settings.textures.castingBarName)
			settings.textures.castingBar = TRB.Data.constants.defaultSettings.textures.resourceBar
			settings.textures.castingBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
		end

		-- Combo Points
		if settings.textures.comboPointsBorder ~= nil then
			if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.BACKGROUND, settings.textures.comboPointsBackgroundName) then
				settings.textures.comboPointsBackground = TRB.Details.addonData.libs.SharedMedia.MediaTable.background[settings.textures.comboPointsBackgroundName]
			else
				print(L["LSMInvalidComboPointBackgroundTexture"], specName, settings.textures.comboPointsBackgroundName)
				settings.textures.comboPointsBackground = TRB.Data.constants.defaultSettings.textures.background
				settings.textures.comboPointsBackgroundName = TRB.Data.constants.defaultSettings.textures.backgroundName
			end

			if not TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.BORDER, settings.textures.comboPointsBorderName) and settings.textures.comboPointsBorderName ~= "1 Pixel" then
				print(L["LSMInvalidComboPointBorderTexture"], specName, settings.textures.comboPointsBorderName)
				settings.textures.comboPointsBorder = TRB.Data.constants.defaultSettings.textures.border
				settings.textures.comboPointsBorderName = TRB.Data.constants.defaultSettings.textures.borderName
			else
				settings.textures.comboPointsBorder = TRB.Details.addonData.libs.SharedMedia.MediaTable.border[settings.textures.comboPointsBorderName]
			end

			if TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.STATUSBAR, settings.textures.comboPointsBarName) then
				settings.textures.comboPointsBar = TRB.Details.addonData.libs.SharedMedia.MediaTable.statusbar[settings.textures.comboPointsBarName]
			else
				print(L["LSMInvalidComboPointResourceTexture"], specName, settings.textures.comboPointsBarName)
				settings.textures.comboPointsBar = TRB.Data.constants.defaultSettings.textures.resourceBar
				settings.textures.comboPointsBarName = TRB.Data.constants.defaultSettings.textures.resourceBarName
			end
		end		
	end

	if settings.audio ~= nil then
		for k, v in pairs(settings.audio) do
			if v.soundName == nil or not TRB.Details.addonData.libs.SharedMedia:IsValid(TRB.Details.addonData.libs.SharedMedia.MediaType.SOUND, v.soundName) then
				if v.name ~= nil and v.soundName ~= nil then
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
	return settings
end