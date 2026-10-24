local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.LibSharedMedia = {}

local lsm = TRB.Details.addonData.libs.SharedMedia

-- Names looked up while unregistered, by media type, so their registration can re-apply them.
---@type table<string, table<any, boolean>>
local missing = {}
local reapplyQueued = false
local listsQueued = false

---The file a saved media name is registered to. Settings are never written: a name that isn't loaded
---draws the fallback until it registers, and a pick without a name keeps its saved path.
---@param mediaType string # A LibSharedMedia media type
---@param name any # The saved name
---@param savedPath any # The saved path
---@param fallbackPath any # What draws or plays while the name isn't registered
---@return any path
function TRB.Functions.LibSharedMedia:Resolve(mediaType, name, savedPath, fallbackPath)
	if name == nil or name == "" then
		return savedPath
	end

	local path = lsm:HashTable(mediaType)[name]
	if path ~= nil then
		return path
	end

	local missingOfType = missing[mediaType]
	if missingOfType == nil then
		missingOfType = {}
		missing[mediaType] = missingOfType
	end
	missingOfType[name] = true
	return fallbackPath
end

---The file a saved sound name plays, or the default sound while it isn't loaded.
---@param name any # The saved sound name
---@param savedPath any # The saved sound path
---@return any path
function TRB.Functions.LibSharedMedia:ResolveSound(name, savedPath)
	return self:Resolve("sound", name, savedPath, TRB.Data.constants.defaultSettings.sounds.sound)
end

---A saved media name for the options to show, marked while it isn't loaded; nil when there is no name.
---@param mediaType string # A LibSharedMedia media type
---@param name any # The saved name
---@return string?
function TRB.Functions.LibSharedMedia:GetDisplayName(mediaType, name)
	if name == nil or name == "" then
		return nil
	end

	if lsm:HashTable(mediaType)[name] ~= nil then
		return tostring(name)
	end
	return string.format(L["LSMNotLoaded"], tostring(name))
end

---Re-resolves every built specialization's textures, then re-applies the active bars and bar text.
local function ReapplyMedia()
	reapplyQueued = false
	-- The deferred setup's own fill resolves anything registered before it.
	if not TRB.Details.addonData.optionsPanelFinished then
		return
	end

	local Character = TRB.Functions.Character
	for _, entry in ipairs(Character:GetSpecRegistryEntriesOrdered()) do
		if TRB.Data.specCache[entry.compositeKey] then
			Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		end
	end

	local specCache = TRB.Data.specCache[TRB.Data.character.compositeKey]
	if TRB.Frames.barGroups ~= nil and specCache ~= nil then
		TRB.Functions.Bar:ApplyBarGroupsLayout(specCache.settings, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(specCache.settings, TRB.Frames.barGroups)
		TRB.Functions.BarText:CreateBarTextFrames()
		TRB.Functions.BarVisibility:MarkDirty()
		TRB.Data.lookupDirty = true
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

---Refills the options' media lists, so media registered after they were built can be picked, and redraws the
---Textures tabs that mark a pick as not loaded.
local function RefreshLists()
	listsQueued = false
	TRB.Functions.OptionsUi.Media:RefreshCaches()
	TRB.Functions.OptionsUi.TextureDropdowns:RefreshCaches()
	if TRB.Details.addonData.optionsPanelFinished then
		TRB.Functions.OptionsUi.Textures:RefreshAllEditors()
	end
end

-- Fires for every addon's registrations, so it only marks work and coalesces it to one pass per frame.
local function OnMediaRegistered(_, mediaType, name)
	local missingOfType = missing[mediaType]
	if missingOfType ~= nil and missingOfType[name] then
		missingOfType[name] = nil
		-- A sound resolves each time it plays, so only drawn media need re-applying.
		if mediaType ~= lsm.MediaType.SOUND and not reapplyQueued then
			reapplyQueued = true
			C_Timer.After(0, ReapplyMedia)
		end
	end

	if not listsQueued then
		listsQueued = true
		C_Timer.After(0, RefreshLists)
	end
end

lsm.RegisterCallback(TRB.Functions.LibSharedMedia, "LibSharedMedia_Registered", OnMediaRegistered)
