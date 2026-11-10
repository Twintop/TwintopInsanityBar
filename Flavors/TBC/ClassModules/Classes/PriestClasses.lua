local _, TRB = ...
local L = TRB.Localization

-- Priest (The Burning Crusade Classic): Mana; there is no Insanity in this game.

---@class TRB.Classes.TBC.Priest.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public innerFire TRB.Classes.SpellBase
---@field public mindFlay TRB.Classes.SpellBase

---Adds the Priest's tracked buffs and channeled abilities to a new spell set; Starshards is a damage over time spell here, not a channel.
---@param spells TRB.Classes.TBC.Priest.GeneralSpells
local function FillSpells(spells)
	-- Improved Inner Fire only raises the armor here, so every rank has 20 charges.
	spells.innerFire = TRB.Classes.SpellBase:New({
		id = 588,
		rankIds = { 588, 7128, 602, 1006, 10951, 10952, 25431 },
		baseline = true,
		isBuff = true,
		maxStacks = 20,
	})
	spells.mindFlay = TRB.Classes.SpellBase:New({
		id = 15407,
		rankIds = { 15407, 17311, 17312, 17313, 17314, 18807, 25387 },
		isTalent = true,
		tickProfile = { mode = "fixedCount", baseDuration = 3, tickCount = 3, firstTickAtStart = false },
	})
end

---The Inner Fire bar text values, appended to the mana archetype's.
---@return table[]
local function BarTextValues()
	return {
		{ variable = "$innerFireStacks", description = L["ForeverPriestBarTextVariable_innerFireStacks"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
		{ variable = "$innerFireStacksMax", description = L["ForeverPriestBarTextVariable_innerFireStacksMax"], printInSettings = true, color = false, logicType = "number" },
		{ variable = "$innerFireTime", description = L["ForeverPriestBarTextVariable_innerFireTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
	}
end

TRB.TBC.Templates.Classes:DefineClass("priest", {
	general = {
		archetype = "mana",
		spells = FillSpells,
		icons = { "innerFire" },
		buffs = { "innerFire" },
		barTextValues = BarTextValues,
		-- No default targets: Inner Fire is up almost all the time, so the row starts Disabled.
		indicators = {
			{
				key = "innerFire",
				buff = "innerFire",
				color = "FFFF8000",
				labelKey = "ForeverPriestCheckboxInnerFire",
				tooltipKey = "ForeverPriestIndicatorInnerFireTooltip",
				colorLabelKey = "ForeverPriestIndicatorInnerFireColor",
			},
		},
	},
})

TRB.Classes.SpecDescriptor:DeclareForClass("priest", { rangedAttack = true })
