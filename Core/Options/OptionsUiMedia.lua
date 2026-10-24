local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Media = TRB.Functions.OptionsUi.Media or {}

local lsm = TRB.Details.addonData.libs.SharedMedia

-- Each media type's entries as { name, path }. Refilled in place, so built dropdowns see new media.
local mediaPairs = { sound = {}, font = {} }

-- Relabels a font or sound dropdown, so a pick marked as not loaded loses the mark once its media registers.
local labelRefreshers = {}

---Fills one media type's entries from LibSharedMedia.
---@param mediaType string
local function FillPairs(mediaType)
	local list = mediaPairs[mediaType]
	wipe(list)
	local paths = lsm:HashTable(mediaType)
	for _, name in ipairs(lsm:List(mediaType)) do
		list[#list + 1] = { name, paths[name] }
	end
end

---One media type's entries, filled the first time they are needed.
---@param mediaType string
---@return table
local function GetPairs(mediaType)
	if #mediaPairs[mediaType] == 0 then
		FillPairs(mediaType)
	end
	return mediaPairs[mediaType]
end

---Refills the sound and font entries already built, after more media registers, and relabels their dropdowns.
function TRB.Functions.OptionsUi.Media:RefreshCaches()
	for mediaType, list in pairs(mediaPairs) do
		if #list > 0 then
			FillPairs(mediaType)
		end
	end
	-- One failing refresher reports without skipping the rest, or the Textures refresh after it.
	for _, refresh in pairs(labelRefreshers) do
		local ok, err = pcall(refresh)
		if not ok then
			geterrorhandler()(err)
		end
	end
end

---Relabels a dropdown whenever media registers; a later call for the same dropdown replaces its refresher.
---@param dropdown table
---@param refresh fun()
function TRB.Functions.OptionsUi.Media:SetLabelRefresher(dropdown, refresh)
	labelRefreshers[dropdown] = refresh
end

---@return table soundPairs
function TRB.Functions.OptionsUi.Media:GetSoundPairs()
	return GetPairs("sound")
end

---@return table fontPairs
function TRB.Functions.OptionsUi.Media:GetFontPairs()
	return GetPairs("font")
end
