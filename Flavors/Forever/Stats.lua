local _, TRB = ...

-- Forever bar text stats, mirroring the client's own character sheet (Blizzard_UIPanels_Game, Camelot\PaperDollFrame*.lua).
-- Composites return nil while a component is secret: arithmetic on a secret errors, and the variable renders empty instead.

---@return boolean
local function AnySecret(...)
	for i = 1, select("#", ...) do
		if issecretvalue((select(i, ...))) then
			return true
		end
	end
	return false
end

---Sum of its arguments, or nil when any of them is secret.
---@return number?
local function Sum(...)
	if AnySecret(...) then
		return nil
	end
	local total = 0
	for i = 1, select("#", ...) do
		total = total + ((select(i, ...)) or 0)
	end
	return total
end

---Mana regeneration per five seconds from one of GetManaRegen's per-second values, or nil when secret.
---@param perSecond number?
---@return number?
local function PerFiveSeconds(perSecond)
	if perSecond == nil or issecretvalue(perSecond) then
		return nil
	end
	return math.floor(perSecond * 5)
end

-- GetSpellBonusDamage takes the 1-based spell school index: 2 Holy, 3 Fire, 4 Nature, 5 Frost, 6 Shadow, 7 Arcane.
local spellSchools = { holy = 2, fire = 3, nature = 4, frost = 5, shadow = 6, arcane = 7 }

---The bonus every school shares (the character sheet's Spell Power), or nil when any school is secret.
---@return number?
local function SharedSpellPower()
	local shared
	for _, school in pairs(spellSchools) do
		local value = GetSpellBonusDamage(school)
		if issecretvalue(value) then
			return nil
		end
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

---UnitResistance's third value is the effective resistance the character sheet shows.
---@param damageClassKey string # Enum.Damageclass key
---@return fun(): number?
local function Resistance(damageClassKey)
	---@diagnostic disable-next-line: undefined-global
	return function() return (select(3, UnitResistance("player", Enum.Damageclass[damageClassKey]))) end
end

---@type TRB.Flavor.StatEvents
TRB.Flavor.statEvents = {
	primary = { "UNIT_STATS" },
	-- The events the client's character sheet refreshes on; attack power and crit follow UNIT_STATS too.
	secondary = { "UNIT_STATS", "COMBAT_RATING_UPDATE", "UNIT_RESISTANCES", "UNIT_ATTACK", "UNIT_RANGED_ATTACK_POWER", "UNIT_SPELL_HASTE", "SPELL_POWER_CHANGED", "PLAYER_DAMAGE_DONE_MODS", "SKILL_LINES_CHANGED", "PLAYER_EQUIPMENT_CHANGED" },
}

---@type TRB.Flavor.StatDefinition[]
TRB.Flavor.stats = {
	-- Primary
	{ key = "strength", variables = { "$str", "$strength" }, descriptionKey = "BarTextVariableStrength", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 1)) end },
	{ key = "agility", variables = { "$agi", "$agility" }, descriptionKey = "BarTextVariableAgility", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 2)) end },
	{ key = "stamina", variables = { "$stam", "$stamina" }, descriptionKey = "BarTextVariableStamina", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 3)) end },
	{ key = "intellect", variables = { "$int", "$intellect" }, descriptionKey = "BarTextVariableIntellect", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 4)) end },
	{ key = "spirit", variables = { "$spi", "$spirit" }, descriptionKey = "BarTextVariableSpirit", refresh = "primary", format = "number", integer = true, read = function() return (UnitStat("player", 5)) end },

	-- Melee and ranged
	{ key = "attackPower", variables = { "$ap", "$attackPower" }, descriptionKey = "BarTextVariableAttackPower", refresh = "secondary", format = "number", integer = true, read = function() return Sum(UnitAttackPower("player")) end },
	{ key = "rangedAttackPower", variables = { "$rap", "$rangedAttackPower" }, descriptionKey = "BarTextVariableRangedAttackPower", refresh = "secondary", format = "number", integer = true, read = function() return Sum(UnitRangedAttackPower("player")) end },
	{ key = "crit", variables = { "$crit", "$meleeCrit", "$critPercent" }, descriptionKey = "BarTextVariableMeleeCrit", refresh = "secondary", format = "percent", read = function() return (GetCritChance()) end },
	{ key = "rangedCrit", variables = { "$rangedCrit" }, descriptionKey = "BarTextVariableRangedCrit", refresh = "secondary", format = "percent", read = function() return (GetRangedCritChance()) end },
	{ key = "spellCrit", variables = { "$spellCrit" }, descriptionKey = "BarTextVariableSpellCrit", refresh = "secondary", format = "percent", read = function() return (GetSpellCritChance()) end },
	{ key = "hit", variables = { "$hit", "$meleeHit" }, descriptionKey = "BarTextVariableMeleeHit", refresh = "secondary", format = "percent", read = function() return (GetHitModifier()) end },
	---@diagnostic disable-next-line: undefined-global
	{ key = "rangedHit", variables = { "$rangedHit" }, descriptionKey = "BarTextVariableRangedHit", refresh = "secondary", format = "percent", read = function() return (GetRangedHitModifier()) end },
	{ key = "spellHit", variables = { "$spellHit" }, descriptionKey = "BarTextVariableSpellHit", refresh = "secondary", format = "percent", read = function() return (GetSpellHitModifier()) end },
	{ key = "haste", variables = { "$haste", "$spellHaste", "$hastePercent" }, descriptionKey = "BarTextVariableSpellHaste", refresh = "secondary", format = "percent", read = function() return (UnitSpellHaste("player")) end },
	{ key = "meleeHaste", variables = { "$meleeHaste" }, descriptionKey = "BarTextVariableMeleeHaste", refresh = "secondary", format = "percent", read = function() return (GetMeleeHaste()) end },
	{ key = "rangedHaste", variables = { "$rangedHaste" }, descriptionKey = "BarTextVariableRangedHaste", refresh = "secondary", format = "percent", read = function() return Sum(GetRangedHaste()) end },
	{ key = "expertise", variables = { "$expertise" }, descriptionKey = "BarTextVariableExpertise", refresh = "secondary", format = "number", integer = true, read = function() return (GetExpertise()) end },
	---@diagnostic disable-next-line: undefined-global
	{ key = "armorPenetration", variables = { "$armorPen", "$armorPenetration" }, descriptionKey = "BarTextVariableArmorPenetration", refresh = "secondary", format = "number", integer = true, read = function() return (GetArmorPenetration()) end },

	-- Spell
	{ key = "spellPower", variables = { "$spellPower", "$sp" }, descriptionKey = "BarTextVariableSpellPower", refresh = "secondary", format = "number", integer = true, read = SharedSpellPower },
	{ key = "spellPowerHoly", variables = { "$spellPowerHoly" }, descriptionKey = "BarTextVariableSpellPowerHoly", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.holy) },
	{ key = "spellPowerFire", variables = { "$spellPowerFire" }, descriptionKey = "BarTextVariableSpellPowerFire", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.fire) },
	{ key = "spellPowerNature", variables = { "$spellPowerNature" }, descriptionKey = "BarTextVariableSpellPowerNature", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.nature) },
	{ key = "spellPowerFrost", variables = { "$spellPowerFrost" }, descriptionKey = "BarTextVariableSpellPowerFrost", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.frost) },
	{ key = "spellPowerShadow", variables = { "$spellPowerShadow" }, descriptionKey = "BarTextVariableSpellPowerShadow", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.shadow) },
	{ key = "spellPowerArcane", variables = { "$spellPowerArcane" }, descriptionKey = "BarTextVariableSpellPowerArcane", refresh = "secondary", format = "number", integer = true, read = SchoolSpellPower(spellSchools.arcane) },
	{ key = "healingPower", variables = { "$healingPower", "$healing" }, descriptionKey = "BarTextVariableHealingPower", refresh = "secondary", format = "number", integer = true, read = function() return (GetSpellBonusHealing()) end },
	{ key = "spellPenetration", variables = { "$spellPenetration", "$spellPen" }, descriptionKey = "BarTextVariableSpellPenetration", refresh = "secondary", format = "number", integer = true, read = function() return (GetSpellPenetration()) end },
	{ key = "mp5", variables = { "$mp5", "$manaRegen" }, descriptionKey = "BarTextVariableMp5", refresh = "secondary", format = "number", integer = true, read = function() return PerFiveSeconds((select(2, GetManaRegen()))) end },
	{ key = "mp5NotCasting", variables = { "$mp5NotCasting", "$manaRegenNotCasting" }, descriptionKey = "BarTextVariableMp5NotCasting", refresh = "secondary", format = "number", integer = true, read = function() return PerFiveSeconds((GetManaRegen())) end },

	-- Defense
	---@diagnostic disable-next-line: undefined-global
	{ key = "defense", variables = { "$defense" }, descriptionKey = "BarTextVariableDefense", refresh = "secondary", format = "number", integer = true, read = function() return Sum(UnitDefenseSkill("player")) end },
	{ key = "dodge", variables = { "$dodge" }, descriptionKey = "BarTextVariableDodge", refresh = "secondary", format = "percent", read = function() return (GetDodgeChance()) end },
	{ key = "parry", variables = { "$parry" }, descriptionKey = "BarTextVariableParry", refresh = "secondary", format = "percent", read = function() return (GetParryChance()) end },
	{ key = "block", variables = { "$block" }, descriptionKey = "BarTextVariableBlock", refresh = "secondary", format = "percent", read = function() return (GetBlockChance()) end },
	{ key = "blockValue", variables = { "$blockValue" }, descriptionKey = "BarTextVariableBlockValue", refresh = "secondary", format = "number", integer = true, read = function() return (GetShieldBlock()) end },
	{ key = "armor", variables = { "$armor" }, descriptionKey = "BarTextVariableArmor", refresh = "secondary", format = "number", integer = true, read = function() return (select(2, UnitArmor("player"))) end },

	-- Resistances
	{ key = "resistArcane", variables = { "$resistArcane" }, descriptionKey = "BarTextVariableResistArcane", refresh = "secondary", format = "number", integer = true, read = Resistance("Arcane") },
	{ key = "resistFire", variables = { "$resistFire" }, descriptionKey = "BarTextVariableResistFire", refresh = "secondary", format = "number", integer = true, read = Resistance("Fire") },
	{ key = "resistFrost", variables = { "$resistFrost" }, descriptionKey = "BarTextVariableResistFrost", refresh = "secondary", format = "number", integer = true, read = Resistance("Frost") },
	{ key = "resistNature", variables = { "$resistNature" }, descriptionKey = "BarTextVariableResistNature", refresh = "secondary", format = "number", integer = true, read = Resistance("Nature") },
	{ key = "resistShadow", variables = { "$resistShadow" }, descriptionKey = "BarTextVariableResistShadow", refresh = "secondary", format = "number", integer = true, read = Resistance("Shadow") },
}
