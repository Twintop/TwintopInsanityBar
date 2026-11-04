local _, TRB = ...
local L = TRB.Localization

TRB.Classes = TRB.Classes or {}
TRB.Classes.TBC.Druid = TRB.Classes.TBC.Druid or {}

-- Druid (The Burning Crusade Classic): Mana, Rage, Energy, and Combo Points are four separate bars that follow
-- the shapeshift form. Loads in the Classes stage, before Core's Stage 2 Functions, so of TRB.Functions only the
-- Stage 1 AudioCues registry is called here.

---@class TRB.Classes.TBC.Druid.GeneralSpells : TRB.Classes.SpecializationSpellsBase
---@field public maul TRB.Classes.SpellThreshold
---@field public lacerate TRB.Classes.SpellThreshold
---@field public mangleBear TRB.Classes.SpellThreshold
---@field public demoralizingRoar TRB.Classes.SpellThreshold
---@field public bash TRB.Classes.SpellThreshold
---@field public challengingRoar TRB.Classes.SpellThreshold
---@field public swipe TRB.Classes.SpellThreshold
---@field public feralCharge TRB.Classes.SpellThreshold
---@field public claw TRB.Classes.SpellComboPointThreshold
---@field public mangleCat TRB.Classes.SpellComboPointThreshold
---@field public shred TRB.Classes.SpellComboPointThreshold
---@field public rake TRB.Classes.SpellComboPointThreshold
---@field public ravage TRB.Classes.SpellComboPointThreshold
---@field public pounce TRB.Classes.SpellComboPointThreshold
---@field public rip TRB.Classes.SpellComboPointThreshold
---@field public ferociousBite TRB.Classes.SpellComboPointThreshold
---@field public maim TRB.Classes.SpellComboPointThreshold
---@field public cower TRB.Classes.SpellComboPointThreshold
---@field public tigersFury TRB.Classes.SpellThreshold
---@field public bearForm TRB.Classes.SpellBase
---@field public direBearForm TRB.Classes.SpellBase
---@field public catForm TRB.Classes.SpellBase
---@field public travelForm TRB.Classes.SpellBase
---@field public aquaticForm TRB.Classes.SpellBase
---@field public flightForm TRB.Classes.SpellBase
---@field public swiftFlightForm TRB.Classes.SpellBase
---@field public moonkinForm TRB.Classes.SpellBase
---@field public treeOfLife TRB.Classes.SpellBase
---@field public prowl TRB.Classes.SpellBase
---@field public tranquility TRB.Classes.SpellBase
---@field public hurricane TRB.Classes.SpellBase
TRB.Classes.TBC.Druid.GeneralSpells = setmetatable({}, { __index = TRB.Classes.SpecializationSpellsBase })
TRB.Classes.TBC.Druid.GeneralSpells.__index = TRB.Classes.TBC.Druid.GeneralSpells

function TRB.Classes.TBC.Druid.GeneralSpells:New()
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.TBC.Druid.GeneralSpells) --[[@as TRB.Classes.TBC.Druid.GeneralSpells]]

	-- Bear Form and Dire Bear Form (Rage)
	self.maul = TRB.Classes.SpellThreshold:New({
		id = 6807,
		rankIds = { 6807, 6808, 6809, 8972, 9745, 9880, 9881, 26996 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "maul",
		baseline = true,
		category = "offensive",
		barTarget = "rage",
	})
	self.lacerate = TRB.Classes.SpellThreshold:New({
		id = 33745,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "lacerate",
		baseline = true,
		category = "offensive",
		barTarget = "rage",
	})
	-- The Mangle talent teaches both forms' Mangle.
	self.mangleBear = TRB.Classes.SpellThreshold:New({
		id = 33878,
		rankIds = { 33878, 33986, 33987 },
		talentId = 33917,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "mangleBear",
		isTalent = true,
		hasCooldown = true,
		category = "offensive",
		barTarget = "rage",
	})
	self.demoralizingRoar = TRB.Classes.SpellThreshold:New({
		id = 99,
		rankIds = { 99, 1735, 9490, 9747, 9898, 26998 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "demoralizingRoar",
		baseline = true,
		category = "defensive",
		barTarget = "rage",
	})
	self.bash = TRB.Classes.SpellThreshold:New({
		id = 5211,
		rankIds = { 5211, 6798, 8983 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "bash",
		baseline = true,
		hasCooldown = true,
		category = "utility",
		barTarget = "rage",
	})
	self.challengingRoar = TRB.Classes.SpellThreshold:New({
		id = 5209,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "challengingRoar",
		baseline = true,
		hasCooldown = true,
		category = "defensive",
		barTarget = "rage",
	})
	self.swipe = TRB.Classes.SpellThreshold:New({
		id = 779,
		rankIds = { 779, 780, 769, 9754, 9908, 26997 },
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "swipe",
		baseline = true,
		category = "offensive",
		barTarget = "rage",
	})
	self.feralCharge = TRB.Classes.SpellThreshold:New({
		id = 16979,
		primaryResourceType = Enum.PowerType.Rage,
		settingKey = "feralCharge",
		isTalent = true,
		hasCooldown = true,
		category = "utility",
		barTarget = "rage",
	})

	-- Cat Form (Energy and Combo Points)
	self.claw = TRB.Classes.SpellComboPointThreshold:New({
		id = 1082,
		rankIds = { 1082, 3029, 5201, 9849, 9850, 27000 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "claw",
		baseline = true,
		category = "offensive",
		barTarget = "energy",
	})
	self.mangleCat = TRB.Classes.SpellComboPointThreshold:New({
		id = 33876,
		rankIds = { 33876, 33982, 33983 },
		talentId = 33917,
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "mangleCat",
		isTalent = true,
		category = "offensive",
		barTarget = "energy",
	})
	self.shred = TRB.Classes.SpellComboPointThreshold:New({
		id = 5221,
		rankIds = { 5221, 6800, 8992, 9829, 9830, 27001, 27002 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "shred",
		baseline = true,
		category = "offensive",
		barTarget = "energy",
	})
	self.rake = TRB.Classes.SpellComboPointThreshold:New({
		id = 1822,
		rankIds = { 1822, 1823, 1824, 9904, 27003 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "rake",
		baseline = true,
		category = "offensive",
		barTarget = "energy",
	})
	self.ravage = TRB.Classes.SpellComboPointThreshold:New({
		id = 6785,
		rankIds = { 6785, 6787, 9866, 9867, 27005 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "ravage",
		baseline = true,
		stealth = true,
		category = "offensive",
		barTarget = "energy",
	})
	self.pounce = TRB.Classes.SpellComboPointThreshold:New({
		id = 9005,
		rankIds = { 9005, 9823, 9827, 27006 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "pounce",
		baseline = true,
		stealth = true,
		category = "utility",
		barTarget = "energy",
	})
	self.rip = TRB.Classes.SpellComboPointThreshold:New({
		id = 1079,
		rankIds = { 1079, 9492, 9493, 9752, 9894, 9896, 27008 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "rip",
		baseline = true,
		category = "offensive",
		barTarget = "energy",
	})
	self.ferociousBite = TRB.Classes.SpellComboPointThreshold:New({
		id = 22568,
		rankIds = { 22568, 22827, 22828, 22829, 31018, 24248 },
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "ferociousBite",
		baseline = true,
		category = "offensive",
		barTarget = "energy",
	})
	self.maim = TRB.Classes.SpellComboPointThreshold:New({
		id = 22570,
		primaryResourceType = Enum.PowerType.Energy,
		comboPoints = true,
		settingKey = "maim",
		baseline = true,
		hasCooldown = true,
		category = "utility",
		barTarget = "energy",
	})
	self.cower = TRB.Classes.SpellComboPointThreshold:New({
		id = 8998,
		rankIds = { 8998, 9000, 9892, 31709, 27004 },
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "cower",
		baseline = true,
		hasCooldown = true,
		category = "defensive",
		barTarget = "energy",
	})
	self.tigersFury = TRB.Classes.SpellThreshold:New({
		id = 5217,
		rankIds = { 5217, 6793, 9845, 9846 },
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "tigersFury",
		baseline = true,
		rangeCheck = false,
		category = "offensive",
		barTarget = "energy",
	})

	-- Shapeshift forms
	self.bearForm = TRB.Classes.SpellBase:New({
		id = 5487,
	})
	self.direBearForm = TRB.Classes.SpellBase:New({
		id = 9634,
	})
	self.catForm = TRB.Classes.SpellBase:New({
		id = 768,
	})
	self.travelForm = TRB.Classes.SpellBase:New({
		id = 783,
	})
	self.aquaticForm = TRB.Classes.SpellBase:New({
		id = 1066,
	})
	self.flightForm = TRB.Classes.SpellBase:New({
		id = 33943,
	})
	self.swiftFlightForm = TRB.Classes.SpellBase:New({
		id = 40120,
	})
	self.moonkinForm = TRB.Classes.SpellBase:New({
		id = 24858,
		isTalent = true,
	})
	self.treeOfLife = TRB.Classes.SpellBase:New({
		id = 33891,
		isTalent = true,
	})
	self.prowl = TRB.Classes.SpellBase:New({
		id = 5215,
		rankIds = { 5215, 6783, 9913 },
	})

	-- Channels
	self.tranquility = TRB.Classes.SpellBase:New({
		id = 740,
		rankIds = { 740, 8918, 9862, 9863, 26983 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 8, tickCount = 4, firstTickAtStart = false },
	})
	self.hurricane = TRB.Classes.SpellBase:New({
		id = 16914,
		rankIds = { 16914, 17401, 17402, 27012 },
		baseline = true,
		tickProfile = { mode = "fixedCount", baseDuration = 10, tickCount = 10, firstTickAtStart = false },
	})

	return self
end

---Fills barTextVariables for the options panel display.
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.TBC.Druid.GeneralSpells.FillBarTextVariables(specCacheEntry)
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.TBC.Druid.GeneralSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.TBC.Druid.GeneralSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#bearForm", icon = spells.bearForm.icon, description = spells.bearForm.name, printInSettings = true },
		{ variable = "#catForm", icon = spells.catForm.icon, description = spells.catForm.name, printInSettings = true },
		{ variable = "#claw", icon = spells.claw.icon, description = spells.claw.name, printInSettings = true },
		{ variable = "#ferociousBite", icon = spells.ferociousBite.icon, description = spells.ferociousBite.name, printInSettings = true },
		{ variable = "#lacerate", icon = spells.lacerate.icon, description = spells.lacerate.name, printInSettings = true },
		{ variable = "#maim", icon = spells.maim.icon, description = spells.maim.name, printInSettings = true },
		{ variable = "#mangleBear", icon = spells.mangleBear.icon, description = spells.mangleBear.name, printInSettings = true },
		{ variable = "#mangleCat", icon = spells.mangleCat.icon, description = spells.mangleCat.name, printInSettings = true },
		{ variable = "#maul", icon = spells.maul.icon, description = spells.maul.name, printInSettings = true },
		{ variable = "#prowl", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = true },
		{ variable = "#rake", icon = spells.rake.icon, description = spells.rake.name, printInSettings = true },
		{ variable = "#rip", icon = spells.rip.icon, description = spells.rip.name, printInSettings = true },
		{ variable = "#shred", icon = spells.shred.icon, description = spells.shred.name, printInSettings = true },
		{ variable = "#swipe", icon = spells.swipe.icon, description = spells.swipe.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["DruidRestorationBarTextVariable_mana"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["DruidRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["DruidRestorationBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["DruidRestorationBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$rage", description = L["DruidGuardianBarTextVariable_rage"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rageMax", description = L["DruidGuardianBarTextVariable_rageMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$energy", description = L["DruidFeralBarTextVariable_energy"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$energyMax", description = L["DruidFeralBarTextVariable_energyMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = L["DruidFeralBarTextVariable_comboPoints"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = L["DruidFeralBarTextVariable_comboPointsMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$inStealth", description = L["BarTextVariableInStealth"], printInSettings = true, color = false },
	})
end

---@type TRB.Classes.ThresholdSnowflakes
TRB.Classes.TBC.Druid.GeneralSpells.thresholdSnowflakes = {
	after = TRB.Classes.ThresholdLine.UnusableWithoutComboPoints,
}

TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["druid_general"] = TRB.Classes.TBC.Druid.GeneralSpells.FillBarTextVariables

TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["druid_general"] = function()
	return TRB.TBC.Templates.Classes:CastbarTickProfilesFromSpells(TRB.Classes.TBC.Druid.GeneralSpells:New())
end

TRB.Classes.TBC.Druid.BarGroupsFactory = {}
TRB.Classes.TBC.Druid.BarGroupsFactory.__index = TRB.Classes.TBC.Druid.BarGroupsFactory

---Creates BarGroup instances: Mana is the primary bar, Rage and Energy are custom bars, Combo Points the secondary bar.
---@param specId integer
---@return table<string, TRB.Classes.BarGroup>
function TRB.Classes.TBC.Druid.BarGroupsFactory:CreateForSpec(specId)
	local barGroups = {}
	if specId ~= 1 then
		return barGroups
	end
	barGroups.primary = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame", 1, true)
	barGroups.rage = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame_Rage", 1, false)
	barGroups.energy = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame_Energy", 1, false)
	barGroups.secondary = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame_ComboPoint", 5, false)
	barGroups.health = TRB.Classes.BarGroup:New(UIParent, "TwintopResourceBarFrame_Health", 1, false)
	return barGroups
end

---Gets the bar group configuration for a spec.
---@param specId integer
---@return table
function TRB.Classes.TBC.Druid.BarGroupsFactory:GetSpecConfiguration(specId)
	if specId ~= 1 then
		return {}
	end
	return {
		primary = { maxNodes = 1, isPrimary = true, resourceType = "Mana" },
		rage = { maxNodes = 1, isPrimary = false, resourceType = "Rage" },
		energy = { maxNodes = 1, isPrimary = false, resourceType = "Energy" },
		secondary = { maxNodes = 5, isPrimary = false, resourceType = "ComboPoints" },
		health = { maxNodes = 1, isPrimary = false, resourceType = "Health" },
	}
end

-- Spec descriptor: which bars each shapeshift form shows (see Core\Classes\SpecDescriptor.lua).
do
	local SpecDescriptor = TRB.Classes.SpecDescriptor

	-- Forms drive the per-bar hide conditions only; every bar's visibility is its own settings.
	SpecDescriptor:Declare("druid_general", {
		manaBar = true,
		forms = {},
		secondary = { exportable = true },
		customBars = { "rage", "energy" },
		-- The global panel has no notion of a form-following bar set, so visibility and combo point layout stay spec-owned.
		useGlobalDefaults = { displayBar = false, comboPoints = false },
		barTextAnchorFrames = {
			secondary = {
				{ label = L["ComboPoint1"], frame = "ComboPoint_1" }, { label = L["ComboPoint2"], frame = "ComboPoint_2" }, { label = L["ComboPoint3"], frame = "ComboPoint_3" }, { label = L["ComboPoint4"], frame = "ComboPoint_4" },
				{ label = L["ComboPoint5"], frame = "ComboPoint_5" },
			},
			energy = { { label = L["EnergyBar"], frame = "EnergyBar" } },
			rage = { { label = L["RageBar"], frame = "RageBar" } },
		},
	})
end

TRB.Functions.AudioCues:Register("druid_general", {
	counters = { TRB.TBC.Templates.Classes:ComboPointAudioCueSource() },
})
