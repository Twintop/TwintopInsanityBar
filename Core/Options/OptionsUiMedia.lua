local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Media = TRB.Functions.OptionsUi.Media or {}

local lsm = TRB.Details.addonData.libs.SharedMedia

-- Each media type's entries as { name, path }, and each path's name. Refilled in place, so built dropdowns see new media.
local mediaPairs = { sound = {}, font = {} }
local mediaPairsByName = { sound = {}, font = {} }

---Fills one media type's entries from LibSharedMedia.
---@param mediaType string
local function FillPairs(mediaType)
	local list = mediaPairs[mediaType]
	local byName = mediaPairsByName[mediaType]
	wipe(list)
	wipe(byName)
	local paths = lsm:HashTable(mediaType)
	for _, name in ipairs(lsm:List(mediaType)) do
		list[#list + 1] = { name, paths[name] }
		byName[paths[name]] = name
	end
end

---One media type's entries, filled the first time they are needed.
---@param mediaType string
local function EnsurePairs(mediaType)
	if #mediaPairs[mediaType] == 0 then
		FillPairs(mediaType)
	end
end

---Refills the sound and font entries already built, after more media registers.
function TRB.Functions.OptionsUi.Media:RefreshCaches()
	for mediaType, list in pairs(mediaPairs) do
		if #list > 0 then
			FillPairs(mediaType)
		end
	end
end

---Populates the sound cache from LibSharedMedia if not already filled.
function TRB.Functions.OptionsUi.Media:FillSoundCache()
	EnsurePairs("sound")
end

---@return table soundPairs
function TRB.Functions.OptionsUi.Media:GetSoundPairs()
	EnsurePairs("sound")
	return mediaPairs.sound
end

---@return table soundPairsByName
function TRB.Functions.OptionsUi.Media:GetSoundPairsByName()
	EnsurePairs("sound")
	return mediaPairsByName.sound
end

---Populates the font cache from LibSharedMedia if not already filled.
function TRB.Functions.OptionsUi.Media:FillFontCache()
	EnsurePairs("font")
end

---@return table fontPairs
function TRB.Functions.OptionsUi.Media:GetFontPairs()
	EnsurePairs("font")
	return mediaPairs.font
end

---@return table fontPairsByName
function TRB.Functions.OptionsUi.Media:GetFontPairsByName()
	EnsurePairs("font")
	return mediaPairsByName.font
end
