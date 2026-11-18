local _, TRB = ...

-- The Burning Crusade Classic saved-variable migrations; every step runs on every login, so each must be idempotent.

---Seeds settings.manualUpdateChecks for a fresh settings table: one-shot steps a fresh install has nothing for.
---@return table
function TRB.Flavor.DefaultManualUpdateChecks()
	return {
		steadyFlightSplit = {
			done = true
		}
	}
end

---Applies every settings migration to a saved-variables shaped table.
---@param settings table? # Defaults to the live saved variables
function TRB.Flavor.PortForwardSettings(settings)
	local savedSettings = settings or TRB.Flavor.GetSavedVariables()
	if savedSettings == nil then
		return
	end

	-- Pet bars: seed their default text into the global list; barText is an array the defaults merge cannot backfill.
	TRB.Functions.Settings:SeedPetBarsText(savedSettings.core)

	-- Totems bar: seed its default text into each Shaman spec's list, since the bar has no global scope here.
	TRB.Functions.Settings:SeedTotemBarsText(savedSettings)

	-- Visibility presets: seed every table and link stored profiles; the live settings are linked after the defaults merge.
	TRB.Functions.Settings:SeedVisibilityPresets(savedSettings)
	if settings ~= nil then
		TRB.Functions.Settings:AutoLinkVisibilityPresets(savedSettings)
	end

	-- Textures: the one Texture Lock became four, the Utility bar began following Global, and the mana bar's unread texture keys are dropped.
	TRB.Functions.Settings:MigrateTextures(savedSettings)

	-- Threshold icons: the cooldown time option starts off where the cooldown swipe was off.
	TRB.Functions.Settings:MigrateThresholdIconCooldownText(savedSettings)

	-- Steady Flight: split every old tick in the save and its stored profiles, once, so ticks made since keep their meaning.
	if savedSettings == TRB.Flavor.GetSavedVariables() then
		savedSettings.manualUpdateChecks = savedSettings.manualUpdateChecks or {}
		if savedSettings.manualUpdateChecks.steadyFlightSplit == nil then
			TRB.Functions.Settings:SplitSteadyFlightTicksWithProfiles(savedSettings)
			savedSettings.manualUpdateChecks.steadyFlightSplit = { done = true }
		end
	end
end
