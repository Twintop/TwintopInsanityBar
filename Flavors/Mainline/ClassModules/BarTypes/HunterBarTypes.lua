local _, TRB = ...
local L = TRB.Localization

-- Hunter bar types: the custom bar definitions this class registers with Core's BarTypeRegistry and
-- the default-settings factories they and the Hunter options panel use. Loads after Core (so
-- TRB.Functions.Settings exists) and before the class runtime modules.

---Gets the default Feign Death bar text entry. Hunter-only, so it is seeded into the Hunter specs' own
---bar text rather than the global list every spec shares.
---@return TRB.Classes.Settings.DisplayTextEntry
function TRB.Functions.Settings:LoadDefaultFeignDeathBarTextSettings()
	return self:LoadDefaultOtherBarTextSettings("FeignDeathBar", L["ResourceFeignDeath"], "$feignDeathDurationRemaining", "CENTER", 12)
end
