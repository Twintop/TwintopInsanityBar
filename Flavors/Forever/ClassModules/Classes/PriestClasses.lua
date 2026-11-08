local _, TRB = ...
local L = TRB.Localization

-- Priest (World of Warcraft: Forever): Mana; there is no Insanity in this game.

---@class TRB.Classes.Forever.Priest.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public improvedInnerFire TRB.Classes.SpellBase
---@field public innerFire TRB.Classes.SpellBase
---@field public mindFlay TRB.Classes.SpellBase
---@field public penance TRB.Classes.SpellBase
---@field public penanceDamage TRB.Classes.SpellBase
---@field public penanceHeal TRB.Classes.SpellBase
---@field public starshards TRB.Classes.SpellBase

---Adds the Priest's channeled abilities and tracked buffs to a new spell set.
---@param spells TRB.Classes.Forever.Priest.GeneralSpells
local function FillSpells(spells)
	spells.improvedInnerFire = TRB.Classes.SpellBase:New({
		id = 14747,
		isTalent = true,
		maxStacksPerRank = { 4, 8, 12 },
	})
	-- maxStacks is every rank's charge count before Improved Inner Fire.
	spells.innerFire = TRB.Classes.SpellBase:New({
		id = 588,
		rankIds = { 588, 7128, 602, 1006, 10951, 10952 },
		baseline = true,
		isBuff = true,
		duration = 600,
		maxStacks = 20,
	})
	spells.mindFlay = TRB.Classes.SpellBase:New({
		id = 15407,
		rankIds = { 15407, 17311, 17312, 17313, 17314, 18807 },
		isTalent = true,
		tickProfile = { mode = "fixedCount", baseDuration = 3, tickCount = 3, firstTickAtStart = false },
	})
	-- Which ID the channel events report is unconfirmed, so the cast and both channel auras carry the profile.
	local penanceTicks = { mode = "fixedCount", baseDuration = 2, tickCount = 3, firstTickAtStart = true }
	spells.penance = TRB.Classes.SpellBase:New({
		id = 402174,
		rankIds = { 402174, 1240720, 1240721, 1316995 },
		isTalent = true,
		tickProfile = penanceTicks,
	})
	spells.penanceDamage = TRB.Classes.SpellBase:New({
		id = 402261,
		rankIds = { 402261, 1240734, 1240736, 1316994 },
		tickProfile = penanceTicks,
	})
	spells.penanceHeal = TRB.Classes.SpellBase:New({
		id = 402277,
		rankIds = { 402277, 1240732, 1240733, 1316992 },
		tickProfile = penanceTicks,
	})
	spells.starshards = TRB.Classes.SpellBase:New({
		id = 10797,
		rankIds = { 10797, 19296, 19299, 19302, 19303, 19304, 19305 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 6, tickCount = 6, firstTickAtStart = false },
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

TRB.Forever.Templates.Classes:DefineClass("priest", {
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
