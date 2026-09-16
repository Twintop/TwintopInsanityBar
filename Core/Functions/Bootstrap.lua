local addonName, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.Bootstrap = {}

-- The addon's load sequence, shared by every class module. A class runtime module registers itself
-- once (see RegisterClassModule) and Core does the rest: settings load/merge/migrate at ADDON_LOADED,
-- saving at PLAYER_LOGOUT, the deferred first-time setup (media validation, spell data, options panel,
-- bar construction) once the character is known, and the spec re-switch on spec/talent changes.
--
-- Only the module for the player's class ever registers (each module returns early otherwise), so
-- there is exactly one registration per session.

---@class TRB.Functions.Bootstrap.ClassModule
---@field classId integer
---@field specCache table<string, TRB.Classes.SpecCache> # The module's spec cache table, keyed by composite key
---@field FillSpecializationCache fun() # Builds specCache from TRB.Data.settings after they are loaded
---@field SwitchSpec fun() # Rebuilds everything for the active spec (spell data, lookups, bars)
---@field ConstructResourceBar fun(settings: table) # Reconstructs the bars for the given spec settings
---@field fillSpellData fun()[]? # Spell data fillers to run once during the deferred setup, before the first SwitchSpec (a module may fill inside SwitchSpec instead and leave this empty)
---@field OnSettingsLoaded fun(settings: table, savedVariables: table?, checks: table)? # After the settings are merged and migrated: seed class-specific bar text, run one-shot migrations. `checks` carries freshInstall = true when there were no saved variables, plus whatever the flavor's manual update checks reported (e.g. barTextReset = true)
---@field OnBeforeReady fun()? # Runs synchronously the moment the deferred setup is scheduled (e.g. initialize class state the setup relies on)
---@field extraEvents string[]? # Additional events to register on the bootstrap frame; delivered to OnEvent
---@field OnEvent fun(event: string, ...): boolean? # Sees every event first; return true to consume it (the shared handling is skipped)

local registeredModule = nil
local eventFrame = CreateFrame("Frame")

local SLASH_COMMANDS = { "/twintop", "/tt", "/tib", "/tit", "/ttib", "/ttit", "/trb", "/trt", "/ttrt", "/ttrb" }

---Loads, migrates and merges the saved variables into TRB.Data.settings for the registered class.
---@param module TRB.Functions.Bootstrap.ClassModule
---@param classEntry TRB.Data.ClassRegistryEntry
local function LoadSettings(module, classEntry)
	local options = TRB.Options[classEntry.classModuleName]
	local saved = TRB.Flavor.GetSavedVariables()
	local checks = {}

	if saved and TRB.Functions.Table:Length(saved) > 0 then
		TRB.Functions.Settings:PortForwardSettings()

		local settings = options.LoadDefaultSettings(false)
		local savedClass = saved[classEntry.className]

		-- A spec the user never initialized (no displayText in the saved data) starts from the full
		-- default bar text; every other spec keeps whatever the saved list holds, even an empty one.
		for _, specEntry in ipairs(classEntry.specs) do
			local savedSpec = savedClass and savedClass[specEntry.specName]
			if savedSpec == nil or savedSpec.displayText == nil then
				local loader = options[specEntry.specLocaleKey:sub(#classEntry.classModuleName + 1) .. "LoadDefaultBarTextSettings"]
				if loader ~= nil then
					settings[classEntry.className][specEntry.specName].displayText.barText = loader()
				end
			end
		end

		-- Clear core barText defaults before merge so the user's saved list (even if empty)
		-- takes precedence. Only skip when no saved core displayText exists (first-run seeding).
		if saved.core and saved.core.displayText and saved.core.displayText.barText then
			settings.core.displayText.barText = {}
		end
		TRB.Data.settings = TRB.Functions.Table:Merge(settings, saved)
		TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

		-- One-shot manual migrations the flavor keeps behind settings.manualUpdateChecks.
		if TRB.Flavor.RunManualUpdateChecks ~= nil then
			checks = TRB.Flavor.RunManualUpdateChecks(TRB.Data.settings, classEntry) or {}
		end
	else
		TRB.Data.settings = options.LoadDefaultSettings(true)
		checks.freshInstall = true
	end

	if module.OnSettingsLoaded ~= nil then
		module.OnSettingsLoaded(TRB.Data.settings, saved, checks)
	end

	module.FillSpecializationCache()

	for i, command in ipairs(SLASH_COMMANDS) do
		_G["SLASH_TWINTOP" .. i] = command
	end
end

---The deferred first-time setup: validate media, fill spell data, switch to the active spec, build the
---options panel and construct the bars. Delayed a little to let other addons register their media.
---@param module TRB.Functions.Bootstrap.ClassModule
---@param classEntry TRB.Data.ClassRegistryEntry
local function StartDeferredSetup(module, classEntry)
	TRB.Details.addonData.optionsPanelStarted = true
	if module.OnBeforeReady ~= nil then
		module.OnBeforeReady()
	end

	-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
	C_Timer.After(0, function()
		C_Timer.After(1, function()
			local options = TRB.Options[classEntry.classModuleName]
			local classSettings = TRB.Data.settings[classEntry.className]

			TRB.Data.settings.core = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["GlobalOptions"], TRB.Data.settings.core)
			for _, specEntry in ipairs(classEntry.specs) do
				classSettings[specEntry.specName] = TRB.Functions.LibSharedMedia:ValidateLsmValues(L[specEntry.specLocaleKey .. "Full"], classSettings[specEntry.specName])
			end

			for _, fill in ipairs(module.fillSpellData or {}) do
				fill()
			end

			TRB.Data.barConstructedForSpec = nil
			module.SwitchSpec()

			options.ConstructOptionsPanel(module.specCache)

			-- Reconstruct just in case
			local constructedFor = TRB.Data.barConstructedForSpec
			if constructedFor and module.specCache[constructedFor] and module.specCache[constructedFor].settings then
				module.ConstructResourceBar(module.specCache[constructedFor].settings)
			end

			TRB.Functions.Class:EventRegistration()
			TRB.Functions.News:Init()
			TRB.Details.addonData.optionsPanelFinished = true
		end)
	end)
end

local function OnEvent(_, event, arg1, ...)
	-- Wrong game version for this build: halt before anything reads or writes settings.
	if TRB.Functions.VersionGate:IsBlocked() then
		return
	end

	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end

	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end

	local module = registeredModule
	if module == nil or TRB.Data.character.classId ~= module.classId then
		return
	end

	if module.OnEvent ~= nil and module.OnEvent(event, arg1, ...) == true then
		return
	end

	local classEntry = TRB.Data.classRegistryByIds[module.classId]

	if event == "ADDON_LOADED" and arg1 == addonName then
		if not TRB.Details.addonData.loaded then
			TRB.Details.addonData.loaded = true
			LoadSettings(module, classEntry)
		end
	end

	if event == "PLAYER_LOGOUT" then
		TRB.Flavor.SetSavedVariables(TRB.Data.settings)
	end

	if TRB.Details.addonData.loaded and TRB.Data.character.specId > 0 then
		if not TRB.Details.addonData.optionsPanelStarted then
			StartDeferredSetup(module, classEntry)
		end

		if TRB.Details.addonData.optionsPanelFinished and (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED") then
			if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
				TRB.Functions.Bar:QueueRenderTransition("eventPreSwitch", 0.8)
			elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
				TRB.Functions.Bar:HideResourceBar(true)
			end
			C_Timer.After(0, function()
				C_Timer.After(0.1, function()
					module.SwitchSpec()
				end)
			end)
		end
	end
end

---Registers the player's class runtime module and starts the load sequence for it.
---@param module TRB.Functions.Bootstrap.ClassModule
function TRB.Functions.Bootstrap:RegisterClassModule(module)
	assert(registeredModule == nil, "TwintopInsanityBar: a class module is already registered with the bootstrap")
	assert(type(module.classId) == "number" and TRB.Data.classRegistryByIds[module.classId] ~= nil, "TwintopInsanityBar: bootstrap registration for an unknown class")
	assert(type(module.FillSpecializationCache) == "function" and type(module.SwitchSpec) == "function" and type(module.ConstructResourceBar) == "function" and type(module.specCache) == "table",
		"TwintopInsanityBar: bootstrap registration is missing a required field")
	registeredModule = module

	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	for _, extraEvent in ipairs(module.extraEvents or {}) do
		eventFrame:RegisterEvent(extraEvent)
	end
	eventFrame:SetScript("OnEvent", OnEvent)
end
