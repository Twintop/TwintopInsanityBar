local addonName, TRB = ...

-- Mainline (modern World of Warcraft) flavor manifest.
--
-- A flavor is one game lineage that shares the modern addon API: Mainline today, WoW Forever next,
-- possibly Classic variants later. This file is pure data plus one client-detection function; it
-- loads before anything in Core, and Core\FlavorRegistry.lua turns it into the class/spec registries
-- that every shared system reads. Nothing in Core may name a class, spec, resource or bar type
-- directly; if a shared system needs such a fact, it comes from here or from a spec descriptor that
-- the flavor's class modules declare.
--
-- Field reference (see TRB.Flavor / TRB.Flavor.ClassEntry annotations in Core\FlavorRegistry.lua):
--   classId          WoW class ID as returned by UnitClass
--   className        all-lowercase settings-tree key, e.g. "deathknight"
--   classToken       uppercase class file token, e.g. "DEATHKNIGHT"
--   classModuleName  PascalCase key for TRB.Classes / TRB.Options modules, e.g. "DeathKnight"
--   specs[].specId        specialization index (GetSpecialization order)
--   specs[].specName      camelCase settings-tree key, e.g. "beastMastery"
--   specs[].specGlobalId  global specialization ID (GetSpecializationInfoByID); informational, names come from GetSpecializationInfoForClassID
--   specs[].resources     per-resource maximums shared by options panels and custom thresholds

---@type TRB.Flavor
TRB.Flavor = {
	id = "mainline",
	-- Localization key for the flavor's display name; resolved once localization has loaded.
	nameKey = "FlavorMainline",
	-- The global the TOC's SavedVariables line declares. Per-flavor so two flavors can never share a
	-- settings table, even if a future client ends up sharing an AddOns/WTF folder between lineages.
	savedVariablesName = "TwintopInsanityBarSettings",

	---True when the running client is this flavor's game. Checked by the version gate when the TOC
	---sets X-FlavorCheck to enabled. An unreadable project ID or interface number is not evidence of a
	---mismatch. WoW Forever also reports the mainline project; only its 1.x interface number tells it apart.
	---@return boolean
	IsClientMatch = function()
		if WOW_PROJECT_ID == nil or WOW_PROJECT_MAINLINE == nil then
			return true
		end
		if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
			return false
		end
		local interfaceVersion = tonumber((select(4, GetBuildInfo())))
		return interfaceVersion == nil or interfaceVersion >= 100000
	end,

	---Active specialization index (specs[] order), or nil before the client reports one.
	---@return integer?
	GetSpecializationIndex = function()
		return C_SpecializationInfo.GetSpecialization()
	end,

	classes = {
		{ classId = 1, className = "warrior", classToken = "WARRIOR", classModuleName = "Warrior", specs = {
			{ specId = 1, specName = "arms", specGlobalId = 71, resources = { rage = 130 } },
			{ specId = 2, specName = "fury", specGlobalId = 72, resources = { rage = 130 } },
			{ specId = 3, specName = "protection", specGlobalId = 73, resources = { rage = 130 } },
		} },
		{ classId = 2, className = "paladin", classToken = "PALADIN", classModuleName = "Paladin", specs = {
			{ specId = 1, specName = "holy", specGlobalId = 65 },
			{ specId = 2, specName = "protection", specGlobalId = 66 },
			{ specId = 3, specName = "retribution", specGlobalId = 70 },
		} },
		{ classId = 3, className = "hunter", classToken = "HUNTER", classModuleName = "Hunter", specs = {
			{ specId = 1, specName = "beastMastery", specGlobalId = 253, resources = { focus = 100 } },
			{ specId = 2, specName = "marksmanship", specGlobalId = 254, resources = { focus = 100 } },
			{ specId = 3, specName = "survival", specGlobalId = 255, resources = { focus = 100 } },
		} },
		{ classId = 4, className = "rogue", classToken = "ROGUE", classModuleName = "Rogue", specs = {
			{ specId = 1, specName = "assassination", specGlobalId = 259, resources = { energy = 300 } },
			{ specId = 2, specName = "outlaw", specGlobalId = 260, resources = { energy = 250 } },
			{ specId = 3, specName = "subtlety", specGlobalId = 261, resources = { energy = 200 } },
		} },
		{ classId = 5, className = "priest", classToken = "PRIEST", classModuleName = "Priest", specs = {
			{ specId = 1, specName = "discipline", specGlobalId = 256 },
			{ specId = 2, specName = "holy", specGlobalId = 257 },
			{ specId = 3, specName = "shadow", specGlobalId = 258, resources = { insanity = 150 } },
		} },
		{ classId = 6, className = "deathknight", classToken = "DEATHKNIGHT", classModuleName = "DeathKnight", specs = {
			{ specId = 1, specName = "blood", specGlobalId = 250, resources = { runicPower = 125, coagulatingBlood = 100 } },
			{ specId = 2, specName = "frost", specGlobalId = 251, resources = { runicPower = 110 } },
			{ specId = 3, specName = "unholy", specGlobalId = 252, resources = { runicPower = 100 } },
		} },
		{ classId = 7, className = "shaman", classToken = "SHAMAN", classModuleName = "Shaman", specs = {
			{ specId = 1, specName = "elemental", specGlobalId = 262, resources = { maelstrom = 175 } },
			{ specId = 2, specName = "enhancement", specGlobalId = 263 },
			{ specId = 3, specName = "restoration", specGlobalId = 264 },
		} },
		{ classId = 8, className = "mage", classToken = "MAGE", classModuleName = "Mage", specs = {
			{ specId = 1, specName = "arcane", specGlobalId = 62, resources = { arcaneSalvo = 25 } },
			{ specId = 2, specName = "fire", specGlobalId = 63 },
			{ specId = 3, specName = "frost", specGlobalId = 64, resources = { shatter = 20 } },
		} },
		{ classId = 9, className = "warlock", classToken = "WARLOCK", classModuleName = "Warlock", specs = {
			{ specId = 1, specName = "affliction", specGlobalId = 265 },
			{ specId = 2, specName = "demonology", specGlobalId = 266 },
			{ specId = 3, specName = "destruction", specGlobalId = 267 },
		} },
		{ classId = 10, className = "monk", classToken = "MONK", classModuleName = "Monk", specs = {
			{ specId = 1, specName = "brewmaster", specGlobalId = 268, resources = { energy = 100 } },
			{ specId = 2, specName = "mistweaver", specGlobalId = 270 },
			{ specId = 3, specName = "windwalker", specGlobalId = 269, resources = { energy = 150 } },
		} },
		{ classId = 11, className = "druid", classToken = "DRUID", classModuleName = "Druid", specs = {
			{ specId = 1, specName = "balance", specGlobalId = 102, resources = { astralPower = 140 } },
			{ specId = 2, specName = "feral", specGlobalId = 103, resources = { energy = 160 } },
			{ specId = 3, specName = "guardian", specGlobalId = 104, resources = { rage = 100 } },
			{ specId = 4, specName = "restoration", specGlobalId = 105 },
		} },
		{ classId = 12, className = "demonhunter", classToken = "DEMONHUNTER", classModuleName = "DemonHunter", specs = {
			{ specId = 1, specName = "havoc", specGlobalId = 577, resources = { fury = 170 } },
			{ specId = 2, specName = "vengeance", specGlobalId = 581, resources = { fury = 120 } },
			{ specId = 3, specName = "devourer", specGlobalId = 1480, resources = { fury = 140 } },
		} },
		{ classId = 13, className = "evoker", classToken = "EVOKER", classModuleName = "Evoker", specs = {
			{ specId = 1, specName = "devastation", specGlobalId = 1467 },
			{ specId = 2, specName = "preservation", specGlobalId = 1468 },
			{ specId = 3, specName = "augmentation", specGlobalId = 1473 },
		} },
	},
}
