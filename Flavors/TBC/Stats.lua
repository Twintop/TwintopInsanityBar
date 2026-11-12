local _, TRB = ...

-- TBC bar text stats, read the way the 2.5 character sheet reads them: hit and haste come from combat ratings.

---Sum of its arguments.
---@return number
local function Sum(...)
	local total = 0
	for i = 1, select("#", ...) do
		total = total + ((select(i, ...)) or 0)
	end
	return total
end

---Mana regeneration per five seconds from one of GetManaRegen's per-second values.
---@param perSecond number?
---@return number?
local function PerFiveSeconds(perSecond)
	if perSecond == nil then
		return nil
	end
	return math.floor(perSecond * 5)
end

-- GetSpellBonusDamage and GetSpellCritChance take the 1-based spell school index: 2 Holy, 3 Fire, 4 Nature, 5 Frost, 6 Shadow, 7 Arcane.
local spellSchools = { holy = 2, fire = 3, nature = 4, frost = 5, shadow = 6, arcane = 7 }

-- The character sheet's combat rating indexes; its CR_ globals only exist once the character frame has loaded.
local combatRatings = { hitMelee = 6, hitRanged = 7, hitSpell = 8, hasteMelee = 18, hasteRanged = 19 }

---The value every school shares: the character sheet's Spell Power and Spell Crit.
---@param read fun(school: integer): number
---@return number?
local function Shared(read)
	local shared
	for _, school in pairs(spellSchools) do
		local value = read(school)
		if shared == nil or value < shared then
			shared = value
		end
	end
	return shared
end

---@param school integer
---@return fun(): number?
local function SchoolSpellPower(school)
	return function() return (GetSpellBonusDamage(school)) end
end

---The percent a combat rating adds, as the character sheet shows it.
---@param rating integer
---@return fun(): number?
local function RatingBonus(rating)
	return function() return (GetCombatRatingBonus(rating)) end
end

---UnitResistance's second value is the resistance the character sheet shows; the third is only the positive bonus.
---@param damageClassKey string # Enum.Damageclass key
---@return fun(): number?
local function Resistance(damageClassKey)
	return function() return (select(2, UnitResistance("player", Enum.Damageclass[damageClassKey]))) end
end

---@type TRB.Flavor.StatEvents
TRB.Flavor.statEvents = {
	primary = { "UNIT_STATS" },
	-- The events the client's character sheet refreshes on; attack power and crit follow UNIT_STATS too.
	-- PLAYER_EQUIPMENT_CHANGED stays out: Core's fallback refreshes every stat and the saved max resource on it.
	secondary = { "UNIT_STATS", "COMBAT_RATING_UPDATE", "UNIT_RESISTANCES", "UNIT_ATTACK", "UNIT_RANGED_ATTACK_POWER", "UNIT_SPELL_HASTE", "SPELL_POWER_CHANGED", "PLAYER_DAMAGE_DONE_MODS", "SKILL_LINES_CHANGED", "UNIT_DEFENSE" },
}

---@class TRB.TBC.StatDefinition : TRB.Flavor.StatDefinition
---@field public requires string? # Client function the character sheet doesn't prove exists; the stat drops when the client lacks it

---@type TRB.TBC.StatDefinition[]
local stats = {
	-- Primary
	{ key = "strength", variables = { "$str", "$strength" }, descriptionKey = "BarTextVariableStrength", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 1)) end },
	{ key = "agility", variables = { "$agi", "$agility" }, descriptionKey = "BarTextVariableAgility", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 2)) end },
	{ key = "stamina", variables = { "$stam", "$stamina" }, descriptionKey = "BarTextVariableStamina", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 3)) end },
	{ key = "intellect", variables = { "$int", "$intellect" }, descriptionKey = "BarTextVariableIntellect", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 4)) end },
	{ key = "spirit", variables = { "$spi", "$spirit" }, descriptionKey = "BarTextVariableSpirit", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 5)) end },

	-- Melee and ranged
	{ key = "attackPower", variables = { "$ap", "$attackPower" }, descriptionKey = "BarTextVariableAttackPower", refresh = "secondary", format = "number", integer = true, read = function() return Sum(UnitAttackPower("player")) end },
	{ key = "rangedAttackPower", variables = { "$rap", "$rangedAttackPower" }, descriptionKey = "BarTextVariableRangedAttackPower", refresh = "secondary", format = "number", integer = true, read = function() return Sum(UnitRangedAttackPower("player")) end },
	{ key = "crit", requires = "GetCritChance", variables = { "$crit", "$meleeCrit", "$critPercent" }, descriptionKey = "BarTextVariableMeleeCrit", refresh = "secondary", format = "percent", booleanCheck = true, read = function() return (GetCritChance()) end },
	{ key = "rangedCrit", requires = "GetRangedCritChance", variables = { "$rangedCrit" }, descriptionKey = "BarTextVariableRangedCrit", refresh = "secondary", format = "percent", read = function() return (GetRangedCritChance()) end },
	{ key = "spellCrit", requires = "GetSpellCritChance", variables = { "$spellCrit" }, descriptionKey = "BarTextVariableSpellCrit", refresh = "secondary", format = "percent", read = function() return Shared(GetSpellCritChance) end },
	{ key = "hit", requires = "GetCombatRatingBonus", variables = { "$hit", "$meleeHit" }, descriptionKey = "BarTextVariableMeleeHit", refresh = "secondary", format = "percent", read = RatingBonus(combatRatings.hitMelee) },
	{ key = "rangedHit", requires = "GetCombatRatingBonus", variables = { "$rangedHit" }, descriptionKey = "BarTextVariableRangedHit", refresh = "secondary", format = "percent", read = RatingBonus(combatRatings.hitRanged) },
	{ key = "spellHit", requires = "GetCombatRatingBonus", variables = { "$spellHit" }, descriptionKey = "BarTextVariableSpellHit", refresh = "secondary", format = "percent", read = RatingBonus(combatRatings.hitSpell) },
	{ key = "haste", requires = "UnitSpellHaste", variables = { "$haste", "$spellHaste", "$hastePercent" }, descriptionKey = "BarTextVariableSpellHaste", refresh = "secondary", format = "percent", booleanCheck = true, read = function() return (UnitSpellHaste("player")) end },
	{ key = "meleeHaste", requires = "GetCombatRatingBonus", variables = { "$meleeHaste" }, descriptionKey = "BarTextVariableMeleeHaste", refresh = "secondary", format = "percent", read = RatingBonus(combatRatings.hasteMelee) },
	{ key = "rangedHaste", requires = "GetCombatRatingBonus", variables = { "$rangedHaste" }, descriptionKey = "BarTextVariableRangedHaste", refresh = "secondary", format = "percent", read = RatingBonus(combatRatings.hasteRanged) },
	{ key = "expertise", requires = "GetExpertise", variables = { "$expertise" }, descriptionKey = "BarTextVariableExpertise", refresh = "secondary", format = "number", integer = true, read = function() return (GetExpertise()) end },
	{ key = "armorPenetration", requires = "GetArmorPenetration", variables = { "$armorPen", "$armorPenetration" }, descriptionKey = "BarTextVariableArmorPenetration", refresh = "secondary", format = "number", integer = true, read = function() return (GetArmorPenetration()) end },

	-- Spell
	{ key = "spellPower", requires = "GetSpellBonusDamage", variables = { "$spellPower", "$sp" }, descriptionKey = "BarTextVariableSpellPower", refresh = "secondary", format = "number", integer = true, read = function() return Shared(GetSpellBonusDamage) end },
	{ key = "spellPowerHoly", requires = "GetSpellBonusDamage", variables = { "$spellPowerHoly" }, descriptionKey = "BarTextVariableSpellPowerHoly", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.holy) },
	{ key = "spellPowerFire", requires = "GetSpellBonusDamage", variables = { "$spellPowerFire" }, descriptionKey = "BarTextVariableSpellPowerFire", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.fire) },
	{ key = "spellPowerNature", requires = "GetSpellBonusDamage", variables = { "$spellPowerNature" }, descriptionKey = "BarTextVariableSpellPowerNature", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.nature) },
	{ key = "spellPowerFrost", requires = "GetSpellBonusDamage", variables = { "$spellPowerFrost" }, descriptionKey = "BarTextVariableSpellPowerFrost", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.frost) },
	{ key = "spellPowerShadow", requires = "GetSpellBonusDamage", variables = { "$spellPowerShadow" }, descriptionKey = "BarTextVariableSpellPowerShadow", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.shadow) },
	{ key = "spellPowerArcane", requires = "GetSpellBonusDamage", variables = { "$spellPowerArcane" }, descriptionKey = "BarTextVariableSpellPowerArcane", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.arcane) },
	{ key = "healingPower", requires = "GetSpellBonusHealing", variables = { "$healingPower", "$healing" }, descriptionKey = "BarTextVariableHealingPower", refresh = "secondary", format = "number", integer = true, read = function() return (GetSpellBonusHealing()) end },
	{ key = "spellPenetration", requires = "GetSpellPenetration", variables = { "$spellPenetration", "$spellPen" }, descriptionKey = "BarTextVariableSpellPenetration", refresh = "secondary", format = "number", integer = true, read = function() return (GetSpellPenetration()) end },
	{ key = "mp5", requires = "GetManaRegen", variables = { "$mp5", "$manaRegen" }, descriptionKey = "BarTextVariableMp5", refresh = "secondary", format = "number", integer = true, read = function() return PerFiveSeconds((select(2, GetManaRegen()))) end },
	{ key = "mp5NotCasting", requires = "GetManaRegen", variables = { "$mp5NotCasting", "$manaRegenNotCasting" }, descriptionKey = "BarTextVariableMp5NotCasting", refresh = "secondary", format = "number", integer = true, read = function() return PerFiveSeconds((GetManaRegen())) end },

	-- Defense
	{ key = "defense", requires = "UnitDefense", variables = { "$defense" }, descriptionKey = "BarTextVariableDefense", refresh = "secondary", format = "number", integer = true, read = function() return Sum(UnitDefense("player")) end },
	{ key = "dodge", requires = "GetDodgeChance", variables = { "$dodge" }, descriptionKey = "BarTextVariableDodge", refresh = "secondary", format = "percent", read = function() return (GetDodgeChance()) end },
	{ key = "parry", requires = "GetParryChance", variables = { "$parry" }, descriptionKey = "BarTextVariableParry", refresh = "secondary", format = "percent", read = function() return (GetParryChance()) end },
	{ key = "block", requires = "GetBlockChance", variables = { "$block" }, descriptionKey = "BarTextVariableBlock", refresh = "secondary", format = "percent", read = function() return (GetBlockChance()) end },
	{ key = "blockValue", requires = "GetShieldBlock", variables = { "$blockValue" }, descriptionKey = "BarTextVariableBlockValue", refresh = "secondary", format = "number", integer = true, read = function() return (GetShieldBlock()) end },
	{ key = "armor", variables = { "$armor" }, descriptionKey = "BarTextVariableArmor", refresh = "secondary", format = "number", integer = true, read = function() return (select(2, UnitArmor("player"))) end },

	-- Resistances
	{ key = "resistArcane", variables = { "$resistArcane" }, descriptionKey = "BarTextVariableResistArcane", refresh = "secondary", format = "number", integer = true, read = Resistance("Arcane") },
	{ key = "resistFire", variables = { "$resistFire" }, descriptionKey = "BarTextVariableResistFire", refresh = "secondary", format = "number", integer = true, read = Resistance("Fire") },
	{ key = "resistFrost", variables = { "$resistFrost" }, descriptionKey = "BarTextVariableResistFrost", refresh = "secondary", format = "number", integer = true, read = Resistance("Frost") },
	{ key = "resistNature", variables = { "$resistNature" }, descriptionKey = "BarTextVariableResistNature", refresh = "secondary", format = "number", integer = true, read = Resistance("Nature") },
	{ key = "resistShadow", variables = { "$resistShadow" }, descriptionKey = "BarTextVariableResistShadow", refresh = "secondary", format = "number", integer = true, read = Resistance("Shadow") },
}

TRB.Flavor.stats = {}
for _, stat in ipairs(stats) do
	if stat.requires == nil or type(_G[stat.requires]) == "function" then
		TRB.Flavor.stats[#TRB.Flavor.stats + 1] = stat
	end
end
