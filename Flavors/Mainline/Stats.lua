local _, TRB = ...

-- Mainline bar text stats: the four secondary ratings and the four primary stats. Core reads, formats,
-- and exposes every entry (Core\FlavorRegistry.lua documents the fields); nothing in Core names a stat.

---@type TRB.Flavor.StatEvents
TRB.Flavor.statEvents = {
	primary = { "UNIT_STATS" },
	secondary = { "COMBAT_RATING_UPDATE" },
}

---@type TRB.Flavor.StatDefinition[]
TRB.Flavor.stats = {
	{ key = "haste", variables = { "$haste", "$hastePercent" }, descriptionKey = "BarTextVariableHaste", refresh = "secondary", format = "percent", read = function() return (UnitSpellHaste("player")) end },
	{ key = "hasteRating", variables = { "$hasteRating" }, descriptionKey = "BarTextVariableHasteRating", refresh = "secondary", format = "number", read = function() return (GetCombatRating(20)) end },
	{ key = "crit", variables = { "$crit", "$critPercent" }, descriptionKey = "BarTextVariableCrit", refresh = "secondary", format = "percent", read = function() return (GetCritChance()) end },
	{ key = "critRating", variables = { "$critRating" }, descriptionKey = "BarTextVariableCritRating", refresh = "secondary", format = "number", read = function() return (GetCombatRating(11)) end },
	{ key = "mastery", variables = { "$mastery", "$masteryPercent" }, descriptionKey = "BarTextVariableMastery", refresh = "secondary", format = "percent", read = function() return (GetMasteryEffect()) end },
	{ key = "masteryRating", variables = { "$masteryRating" }, descriptionKey = "BarTextVariableMasteryRating", refresh = "secondary", format = "number", read = function() return (GetCombatRating(26)) end },
	{ key = "versatilityOffensive", variables = { "$vers", "$versPercent", "$versatility", "$versatilityPercent", "$oVers", "$oVersPercent" }, descriptionKey = "BarTextVariableVers", refresh = "secondary", format = "percent", read = function() return (GetCombatRatingBonus(29)) end },
	{ key = "versatilityDefensive", variables = { "$dVers", "$dVersPercent" }, descriptionKey = "BarTextVariableVersDefense", refresh = "secondary", format = "percent", read = function() return (GetCombatRatingBonus(31)) end },
	{ key = "versatilityRating", variables = { "$versRating", "$versatilityRating" }, descriptionKey = "BarTextVariableVersRating", refresh = "secondary", format = "number", read = function() return (GetCombatRating(29)) end },

	{ key = "intellect", variables = { "$int", "$intellect" }, descriptionKey = "BarTextVariableIntellect", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 4)) end },
	{ key = "agility", variables = { "$agi", "$agility" }, descriptionKey = "BarTextVariableAgility", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 2)) end },
	{ key = "strength", variables = { "$str", "$strength" }, descriptionKey = "BarTextVariableStrength", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 1)) end },
	{ key = "stamina", variables = { "$stam", "$stamina" }, descriptionKey = "BarTextVariableStamina", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 3)) end },
}
