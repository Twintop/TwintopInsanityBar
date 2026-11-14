local _, TRB = ...
local L = TRB.Localization

-- Forever's resource type names and Global Bar Text resource anchors, which Core reads once localization loads.

---@type table<string, TRB.Flavor.ResourceType>
TRB.Flavor.resourceTypes = {
	-- Primary power types
	Rage = { name = L["ResourceRage"] },
	Mana = { name = L["ResourceMana"], percentScale = true, powerType = Enum.PowerType.Mana },
	Energy = { name = L["ResourceEnergy"] },
	-- Secondary resources
	ComboPoints = { name = L["ResourceComboPoints"], containerLabel = L["ComboPointsContainer"] },
	ArcaneBlast = { name = L["ResourceMageArcaneBlast"], containerLabel = L["ArcaneBlastContainer"] },
	Eclipse = { name = L["ResourceDruidEclipse"], containerLabel = L["EclipseContainer"] },
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
