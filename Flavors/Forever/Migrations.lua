local _, TRB = ...

-- World of Warcraft: Forever saved-variable migrations; every step runs on every login, so each must be idempotent.

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
end
