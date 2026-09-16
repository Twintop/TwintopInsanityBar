local _, TRB = ...

--If you would like to have your AddOn integrated into WagoUI Packs we need a couple of accessible functions that our AddOns can call to manage profiles.
--In general the immplementation of the functions is up to you but make sure the behavior of your functions matches the expected behavior as described in the comments.
--IMPORTANT NOTE: If your AddOn needs to ReloadUI() after importing / setting profiles make sure NOT to call reloads within these functions (or their tail calls) directly. WagoUI will instead mark your AddOn has "needing reload" and handle reloads for all AddOns at the end of the setup together.

--For WagoUI to have access to your functions it is recommended to create a separate global API table and place all the needed functions in it.

-- TRB integration notes: All entry points delegate to the existing Profiles +
-- IO infrastructure so the live-vs-stored mechanics used by the in-addon
-- profile dropdown also apply to Wago exports. Per the WagoUI contract, none
-- of these functions call C_UI.Reload(); WagoUI batches reloads across all
-- participating AddOns at the end of setup.

TwintopsResourceBarAPI = TwintopsResourceBarAPI or {}

---@param profileKey string --the name of the profile to be exported
---@return string? --the encoded profile string that can be imported by other users
function TwintopsResourceBarAPI:ExportProfile(profileKey)
	-- NOTE: If your AddOn has no profile system we will call this function with "Global" as the profileKey
	-- NOTE: This function should NOT just export the CURRENT profile (if your AddOn has a profile system) but should be able to export any profile by name.

	-- It is recommended to use Blizzard functions from C_EncodingUtil for encoding / decoding.
	-- Add nil checks and error handling as needed, this is just a basic example of how to use the functions.

	-- TRB: Delegates to TRB.Functions.IO:ExportFullProfile, which:
	--   * captures the live working copy of any piece whose profile is active
	--     on the current character (so unsaved Global Options edits are included),
	--   * falls back to the stored profile data otherwise, and
	--   * always includes a `core` piece -- falling back to the currently-active
	--     Global Options when the named profile has none of its own.
	if TRB.Functions.IO == nil or TRB.Functions.IO.ExportFullProfile == nil then
		return nil
	end
	local output = TRB.Functions.IO:ExportFullProfile(profileKey)
	return output
end

---@param profileString string --the encoded profile string to be imported
---@param profileKey string --the name of the profile to be imported
function TwintopsResourceBarAPI:ImportProfile(profileString, profileKey)
	-- NOTE: If your AddOn has no profile system we will call this function with "Global" as the profileKey and you should just import the data to your global settings.
	-- NOTE: This function should import the profile data to your AddOn and make it the current active profile if your AddOn has a profile system.
	-- NOTE: Make sure that the new profile is named after the profileKey passed to the function if you have a profile system. For AddOns with only Global settings you can ignore the profileKey.

	-- NOTE: You do not NEED to implement your encoding like this, this code is just meant as an easy example. If you have your own / already existing encoding that is perfectly fine.
	--       It is however expected that Profiles exported by the API are 100% compatible with your own internal import/export system for profile strings.

	-- TRB: Mirrors the headless equivalent of the profile import popup apply flow:
	-- same writes, no popups, no reload. After
	-- writing, the imported profile is activated for every scope present in
	-- the payload on the current character so the upcoming WagoUI-batched
	-- reload picks up the new content.
	if type(profileString) ~= "string" or profileString == "" then
		return
	end
	if type(profileKey) ~= "string" or profileKey == "" then
		return
	end
	if TRB.Functions.IO == nil or TRB.Functions.IO.ParseProfileImport == nil then
		return
	end
	if TRB.Functions.Profiles == nil then
		return
	end

	local parsed = TRB.Functions.IO:ParseProfileImport(profileString)
	if parsed == nil then
		return
	end

	local writtenSpecs = {}
	for _, slot in ipairs(parsed.validSpecs or {}) do
		local piece = parsed.profileBody
			and parsed.profileBody[slot.className]
			and parsed.profileBody[slot.className][slot.specName]
		if type(piece) == "table" then
			TRB.Functions.Profiles:CreateSpecProfile(profileKey, slot.className, slot.specName, piece)
			table.insert(writtenSpecs, { className = slot.className, specName = slot.specName })
		end
	end

	local wroteCore = false
	if parsed.hasCore and type(parsed.profileBody.core) == "table" then
		TRB.Functions.Profiles:CreateCoreProfile(profileKey, parsed.profileBody.core)
		wroteCore = true
	end

	-- Normalize the imported entry against the current settings schema so
	-- cross-version imports land in a shape the rest of the addon expects.
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p ~= nil and p.list ~= nil and p.list[profileKey] ~= nil then
		if TRB.Functions.Settings and TRB.Functions.Settings.PortForwardProfile then
			TRB.Functions.Settings:PortForwardProfile(p.list[profileKey])
		end
	end

	TRB.Functions.Profiles:InvalidateCache()

	-- Activate the imported profile for every scope present in the payload.
	-- The live runtime has not picked up the imported contents yet, so do
	-- NOT FlushActive (would overwrite the freshly-written profile with stale
	-- runtime state). Suppress the PLAYER_LOGOUT flush instead and let
	-- WagoUI's batched reload bring the new content live.
	TRB.Functions.Profiles:SuppressLogoutFlush()
	if wroteCore then
		TRB.Functions.Profiles:SetActiveCoreProfile(profileKey)
	end
	for _, slot in ipairs(writtenSpecs) do
		TRB.Functions.Profiles:SetActiveSpecProfile(slot.specName, profileKey)
	end
end

---@param profileString string --the profile string to decode
---@return table? --the decoded profile data as a table
function TwintopsResourceBarAPI:DecodeProfileString(profileString)
	-- NOTE: This function should decode the profile string and return the profile data as a table. This is used for comparing profiles and generating changelogs for creators.

	-- NOTE: You do not NEED to implement your encoding like this, this code is just meant as an easy example. If you have your own / already existing encoding that is perfectly fine.
	--       It is however expected that Profiles exported by the API are 100% compatible with your own internal import/export system for profile strings.

	-- TRB: Wraps TRB.Functions.IO:DecodeExportString so the decoded shape is
	-- 100% compatible with TRB's own export/import path.
	if type(profileString) ~= "string" or profileString == "" then
		return nil
	end
	if TRB.Functions.IO == nil or TRB.Functions.IO.DecodeExportString == nil then
		return nil
	end
	local ok, configuration = TRB.Functions.IO:DecodeExportString(profileString)
	if not ok or type(configuration) ~= "table" then
		return nil
	end
	return configuration
end

---@param profileKey string -- profileKey of an existing profile
function TwintopsResourceBarAPI:SetProfile(profileKey)
	-- NOTE: This function should set the current active profile to the profile with the given profileKey. This is used when users select a profile from the list of available profiles.

	-- TRB: Activates the named profile across every scope present in the
	-- profile body. FlushAndSuppressLogout writes the current runtime state
	-- back to the previously-active profile and prevents the PLAYER_LOGOUT
	-- flush from clobbering the newly-selected profile during the upcoming
	-- WagoUI-batched reload.
	if type(profileKey) ~= "string" or profileKey == "" then
		return
	end
	if TRB.Functions.Profiles == nil then
		return
	end
	local p = TRB.Data.settings and TRB.Data.settings.profiles
	if p == nil or p.list == nil or p.list[profileKey] == nil then
		return
	end

	TRB.Functions.Profiles:FlushAndSuppressLogout()

	local entry = p.list[profileKey]
	if type(entry.core) == "table" then
		TRB.Functions.Profiles:SetActiveCoreProfile(profileKey)
	end
	for className, specs in pairs(entry) do
		if className ~= "core" and type(specs) == "table" then
			for specName, piece in pairs(specs) do
				if type(piece) == "table" then
					TRB.Functions.Profiles:SetActiveSpecProfile(specName, profileKey)
				end
			end
		end
	end
end

---@return table<string, boolean>  -- a table of all available profile keys in the format [profileKey] = true
function TwintopsResourceBarAPI:GetProfileKeys()
	-- NOTE: This function should return a table of all available profile keys in the format [profileKey] = true, this is used to check for duplicates and validate profile keys.
	-- NOTE: If your AddOn has no profile system just return a table with "Global" as the only key.

	-- TRB: Always includes the hard-coded "Default" profile (seeded on first
	-- load) plus every name in TRB.Data.settings.profiles.list.
	local keys = {}
	if TRB.Functions.Profiles == nil or TRB.Functions.Profiles.GetProfileNames == nil then
		keys[(TRB.Functions.Profiles and TRB.Functions.Profiles.DEFAULT_NAME) or "Default"] = true
		return keys
	end
	local names = TRB.Functions.Profiles:GetProfileNames()
	for _, name in ipairs(names) do
		keys[name] = true
	end
	return keys
end

---@return table<string, string> | nil --optional table in the format [characterKey] = profileKey
function TwintopsResourceBarAPI:GetProfileAssignments()
	-- NOTE: WagoUI uses this to restore profile selections from another character without relying only on
	--       its own import history.
	-- NOTE: If your AddOn does not expose these assignments, or only the current character can be resolved,
	--       just return nil.

	-- TRB: Returns nil. TRB stores between 3 and 8 profile assignments per
	-- character (one for `core` plus one per spec), which cannot be
	-- represented by WagoUI's flat `[characterKey] = profileKey` shape
	-- without losing information. WagoUI will fall back to its own resolution
	-- via GetCurrentProfileKey for the active character.
	return nil
end

---@return string --the profileKey of the currently active profile
function TwintopsResourceBarAPI:GetCurrentProfileKey()
	-- NOTE: This function should return the profile key of the currently active profile. This helps Creators exporting profiles correctly.
	-- NOTE: If your AddOn has no profile system just return "Global".

	-- TRB: Resolves the active spec profile for the current character's
	-- current specialization (the profile that drives the bar the user is
	-- actually looking at), with a final fallback to the hard-coded
	-- "Default" profile. Uses TRB.Data.character.{className,specName} which
	-- the active class module keeps in sync with the player's current spec.
	if TRB.Functions.Profiles == nil then
		return "Default"
	end
	local character = TRB.Data and TRB.Data.character
	local className = character and character.className
	local specName = character and character.specName
	if type(className) == "string" and className ~= ""
		and type(specName) == "string" and specName ~= "" then
		local resolved = TRB.Functions.Profiles:ResolveSpecProfileName(className, specName)
		if resolved ~= nil then
			return resolved
		end
	end
	return TRB.Functions.Profiles.DEFAULT_NAME or "Default"
end

function TwintopsResourceBarAPI:OpenConfig()
	-- NOTE: This function should open the configuration interface of your AddOn.
	-- NOTE: If your AddOn has no configuration interface you can leave this function empty or just print a message to the user.
	-- NOTE: If your AddOn uses Editmode for configuration leave this function empty, we will open the Editmode config when the user tries to open the config for your AddOn.

	-- TRB: Mirrors the `/trb` slash command and minimap-button click: open
	-- the options frame and select the category for the player's currently
	-- active spec (falling back to "main" before the bar has been
	-- constructed for a spec).
	if TRB.Options == nil or TRB.Options.OptionsFrame == nil then
		return
	end
	if TRB.Options.OptionsFrame.Show then
		TRB.Options.OptionsFrame:Show()
	end
	if TRB.Options.OptionsFrame.SelectCategory then
		if TRB.Data and TRB.Data.barConstructedForSpec ~= nil then
			TRB.Options.OptionsFrame:SelectCategory(TRB.Data.barConstructedForSpec)
		else
			TRB.Options.OptionsFrame:SelectCategory("main")
		end
	end
end

function TwintopsResourceBarAPI:CloseConfig()
	-- NOTE: This function should close the configuration interface of your AddOn if it has one.
	if TRB.Options and TRB.Options.OptionsFrame and TRB.Options.OptionsFrame.Hide then
		TRB.Options.OptionsFrame:Hide()
	end
end