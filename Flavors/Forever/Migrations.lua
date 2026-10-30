local _, TRB = ...

-- World of Warcraft: Forever saved-variable migrations; every step runs on every login, so each must be idempotent.

---Seeds settings.manualUpdateChecks for a fresh settings table.
---@return table
function TRB.Flavor.DefaultManualUpdateChecks()
	return {
		-- Fresh installs show the Totems bar; PortForwardSettings marks existing saves to be asked.
		totemBarsPrompt = {
			answered = true,
			hidden = false
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

	-- Swing timer bars: same, for their remaining-time text.
	TRB.Functions.Settings:SeedSwingTimersText(savedSettings.core)

	-- Visibility presets: seed every table and link stored profiles; the live settings are linked after the defaults merge.
	TRB.Functions.Settings:SeedVisibilityPresets(savedSettings)
	if settings ~= nil then
		TRB.Functions.Settings:AutoLinkVisibilityPresets(savedSettings)
	end

	-- Textures: the one Texture Lock became four, the Utility bar began following Global, and the mana bar's unread texture keys are dropped.
	TRB.Functions.Settings:MigrateTextures(savedSettings)

	-- Threshold icons: the cooldown time option starts off where the cooldown swipe was off.
	TRB.Functions.Settings:MigrateThresholdIconCooldownText(savedSettings)

	-- Totems bar: existing saves get asked on their first Shaman login. The bar's defaults keep it hidden until then.
	-- Live saves only, so profiles and imports never carry the flag.
	if savedSettings == TRB.Flavor.GetSavedVariables() then
		savedSettings.manualUpdateChecks = savedSettings.manualUpdateChecks or {}
		if savedSettings.manualUpdateChecks.totemBarsPrompt == nil then
			savedSettings.manualUpdateChecks.totemBarsPrompt = { answered = false }
		end
	end
end
