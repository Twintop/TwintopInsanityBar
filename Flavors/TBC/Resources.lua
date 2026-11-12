local _, TRB = ...
local L = TRB.Localization

-- TBC resource vocabulary: every resourceType this flavor's GetSpecConfiguration declares. Loads after Core's
-- localization and before Core reads it.

---@type table<string, TRB.Flavor.ResourceType>
TRB.Flavor.resourceTypes = {
	-- Primary power types
	Rage = { name = L["ResourceRage"] },
	Mana = { name = L["ResourceMana"], percentScale = true },
	Energy = { name = L["ResourceEnergy"] },
	-- Secondary resources
	ComboPoints = { name = L["ResourceComboPoints"], containerLabel = L["ComboPointsContainer"] },
	ArcaneBlast = { name = L["ResourceMageArcaneBlast"], containerLabel = L["ArcaneBlastContainer"] },
}
