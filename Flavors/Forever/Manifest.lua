local addonName, TRB = ...

-- World of Warcraft: Forever flavor manifest.
--
-- Forever runs on the modern client and addon API (secret values, Cooldown Manager, Edit Mode) but with
-- the original class design: nine classes, one specialization each, and the original resources.
-- The values below come from the beta probe (build\forever-probe\); anything still marked TO CONFIRM
-- is waiting on a probe run that can answer it.
--
-- Client facts (1.60.1 beta): the TOC interface number is 16001, WOW_PROJECT_ID is WOW_PROJECT_MAINLINE
-- (intentional, per Blizzard), and the TOC game type is "camelot" ("standard" is retail). The client
-- registers a different API surface from retail: the global GetSpecialization is absent while
-- GetSpecializationInfoForClassID and GetSpecializationInfoByID are present, and C_SpecializationInfo
-- carries only GetSpecialization, GetSpecializationInfo, GetActiveSpecGroup, and the PvP talent calls.
--
-- Field reference: see Flavors\Mainline\Manifest.lua and Core\FlavorRegistry.lua.

---@type TRB.Flavor
TRB.Flavor = {
	id = "forever",
	nameKey = "FlavorForever",
	-- Distinct from mainline's global so the two flavors never share a settings table, even if the
	-- client ends up sharing an AddOns/WTF folder between them.
	savedVariablesName = "TwintopInsanityBarForeverSettings",

	---True when the running client is WoW Forever: the mainline project with a 1.x interface number
	---(the same rule AceDB uses). An unreadable project ID or interface number is not evidence of a mismatch.
	---@return boolean
	IsClientMatch = function()
		if WOW_PROJECT_ID ~= nil and WOW_PROJECT_MAINLINE ~= nil and WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
			return false
		end
		local interfaceVersion = tonumber((select(4, GetBuildInfo())))
		return interfaceVersion == nil or (interfaceVersion > 16000 and interfaceVersion < 20000)
	end,

	---Active specialization index; always 1 here, since every class has exactly one specialization.
	---@return integer?
	GetSpecializationIndex = function()
		return C_SpecializationInfo.GetSpecialization()
	end,

	-- Class ids follow the client's class file ids (Death Knight = 6, Monk = 10, Demon Hunter = 12, and
	-- Evoker = 13 do not exist here, so the ids are sparse). The client gives every class exactly one
	-- specialization, named after the class, with the specGlobalIds below; the Vanilla talent trees are one
	-- CamelotCombat trait tree per class, so talent-based behaviour is a setting under the one spec, not a spec.
	-- Druid's form-dependent power (Mana, Energy, Rage) is TO DESIGN; it starts on Mana.
	classes = {
		{ classId = 1, className = "warrior", classToken = "WARRIOR", classModuleName = "Warrior", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1491, resources = { rage = 100 } },
		} },
		{ classId = 2, className = "paladin", classToken = "PALADIN", classModuleName = "Paladin", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1486 },
		} },
		{ classId = 3, className = "hunter", classToken = "HUNTER", classModuleName = "Hunter", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1485 },
		} },
		{ classId = 4, className = "rogue", classToken = "ROGUE", classModuleName = "Rogue", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1488, resources = { energy = 100 } },
		} },
		{ classId = 5, className = "priest", classToken = "PRIEST", classModuleName = "Priest", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1487 },
		} },
		{ classId = 7, className = "shaman", classToken = "SHAMAN", classModuleName = "Shaman", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1489 },
		} },
		{ classId = 8, className = "mage", classToken = "MAGE", classModuleName = "Mage", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1482 },
		} },
		{ classId = 9, className = "warlock", classToken = "WARLOCK", classModuleName = "Warlock", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1490 },
		} },
		{ classId = 11, className = "druid", classToken = "DRUID", classModuleName = "Druid", specs = {
			{ specId = 1, specName = "general", specGlobalId = 1484 },
		} },
	},
}
