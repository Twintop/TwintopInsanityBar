---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Media = TRB.Functions.OptionsUi.Media or {}

local sounds = {}
local soundsList = {}
local soundPairs = {}
local soundPairsByName = {}

---Populates the sound cache from LibSharedMedia if not already filled.
function TRB.Functions.OptionsUi.Media:FillSoundCache()
	if TRB.Functions.Table:Length(sounds) == 0 then
		sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")

		for _, value in pairs(soundsList) do
			table.insert(soundPairs, { value, sounds[value] })
			soundPairsByName[sounds[value]] = value
		end
	end
end

---@return table soundPairs
function TRB.Functions.OptionsUi.Media:GetSoundPairs()
	self:FillSoundCache()
	return soundPairs
end

---@return table soundPairsByName
function TRB.Functions.OptionsUi.Media:GetSoundPairsByName()
	self:FillSoundCache()
	return soundPairsByName
end

local fonts = {}
local fontsList = {}
local fontPairs = {}
local fontPairsByName = {}

---Populates the font cache from LibSharedMedia if not already filled.
function TRB.Functions.OptionsUi.Media:FillFontCache()
	if TRB.Functions.Table:Length(fonts) == 0 then
		fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
		fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")

		for _, value in pairs(fontsList) do
			table.insert(fontPairs, { value, fonts[value] })
			fontPairsByName[fonts[value]] = value
		end
	end
end

---@return table fontPairs
function TRB.Functions.OptionsUi.Media:GetFontPairs()
	self:FillFontCache()
	return fontPairs
end

---@return table fontPairsByName
function TRB.Functions.OptionsUi.Media:GetFontPairsByName()
	self:FillFontCache()
	return fontPairsByName
end
