local _, TRB = ...
local L = TRB.Localization

-- Forever resource vocabulary: every resourceType this flavor's GetSpecConfiguration declares, and the Global Bar
-- Text's resource anchors. Loads after Core's localization and before Core reads it.

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

-- Global Bar Text anchors beyond the bars every spec has, keyed by the bar group they sort with.
---@type table<string, TRB.Classes.SpecDescriptor.AnchorFrame[]>
TRB.Flavor.globalBarTextAnchorFrames = {
	secondary = {
		{ label = L["ComboPoint1"], frame = "ComboPoint_1" },
		{ label = L["ComboPoint2"], frame = "ComboPoint_2" },
		{ label = L["ComboPoint3"], frame = "ComboPoint_3" },
		{ label = L["ComboPoint4"], frame = "ComboPoint_4" },
		{ label = L["ComboPoint5"], frame = "ComboPoint_5" },
	},
}
