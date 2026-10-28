local _, TRB = ...

-- World of Warcraft Classic saved-variable migrations; every step runs on every login, so each must be idempotent.

---Applies every settings migration to a saved-variables shaped table.
---@param settings table? # Defaults to the live saved variables
function TRB.Flavor.PortForwardSettings(settings)
	local savedSettings = settings or TRB.Flavor.GetSavedVariables()
	if savedSettings == nil then
		return
	end

	-- Pet bars: seed their default text into the global list; barText is an array the defaults merge cannot backfill.
	TRB.Functions.Settings:SeedPetBarsText(savedSettings.core)

	-- Visibility presets: seed every table and link stored profiles; the live settings are linked after the defaults merge.
	TRB.Functions.Settings:SeedVisibilityPresets(savedSettings)
	if settings ~= nil then
		TRB.Functions.Settings:AutoLinkVisibilityPresets(savedSettings)
	end

	-- Textures: the one Texture Lock became four, the Utility bar began following Global, and the mana bar's unread texture keys are dropped.
	TRB.Functions.Settings:MigrateTextures(savedSettings)

	-- Threshold icons: the cooldown time option starts off where the cooldown swipe was off.
	TRB.Functions.Settings:MigrateThresholdIconCooldownText(savedSettings)
end
