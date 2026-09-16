local addonName, TRB = ...

-- World of Warcraft: Forever flavor manifest.
--
-- Forever runs on the modern client and addon API (secret values, Cooldown Manager, Edit Mode) but with
-- the original class design: nine classes, three specializations each, and the original resources.
-- Everything below that is marked TO CONFIRM is a best guess made before beta access; the beta probe
-- (build\forever-probe\) reports the real values and this file is where they land.
--
-- Field reference: see Flavors\Mainline\Manifest.lua and Core\FlavorRegistry.lua.

---@type TRB.Flavor
TRB.Flavor = {
	id = "forever",
	nameKey = "FlavorForever",
	-- Distinct from mainline's global so the two flavors never share a settings table, even if the
	-- client ends up sharing an AddOns/WTF folder between them.
	savedVariablesName = "TwintopInsanityBarForeverSettings",

	---TO CONFIRM: how the client identifies itself. Until the beta reveals a project id (WOW_PROJECT_ID
	---value or a new WOW_PROJECT_* constant), this never blocks -- the TOC also keeps X-FlavorCheck
	---disabled so a mismatch can only ever be a mainline build loading here, which its own gate handles.
	---@return boolean
	IsClientMatch = function()
		if WOW_PROJECT_ID == nil then
			return true
		end
		-- Placeholder: replace with the Forever project constant once known, e.g.
		--   return WOW_PROJECT_ID == WOW_PROJECT_FOREVER
		return true
	end,

	-- Class ids follow the client's class file ids (Death Knight = 6, Monk = 10, Demon Hunter = 12 and
	-- Evoker = 13 do not exist here, so the ids are sparse). Spec ids are GetSpecialization() order;
	-- specGlobalIds are the mainline ids for the same-named specs and are TO CONFIRM (Rogue's second
	-- spec is Combat here, listed under mainline Outlaw's id until the real one is known).
	classes = {
		{ classId = 1, className = "warrior", classToken = "WARRIOR", classModuleName = "Warrior", specs = {
			{ specId = 1, specName = "arms", specGlobalId = 71, resources = { rage = 100 } },
			{ specId = 2, specName = "fury", specGlobalId = 72, resources = { rage = 100 } },
			{ specId = 3, specName = "protection", specGlobalId = 73, resources = { rage = 100 } },
		} },
		{ classId = 2, className = "paladin", classToken = "PALADIN", classModuleName = "Paladin", specs = {
			{ specId = 1, specName = "holy", specGlobalId = 65 },
			{ specId = 2, specName = "protection", specGlobalId = 66 },
			{ specId = 3, specName = "retribution", specGlobalId = 70 },
		} },
		{ classId = 3, className = "hunter", classToken = "HUNTER", classModuleName = "Hunter", specs = {
			{ specId = 1, specName = "beastMastery", specGlobalId = 253 },
			{ specId = 2, specName = "marksmanship", specGlobalId = 254 },
			{ specId = 3, specName = "survival", specGlobalId = 255 },
		} },
		{ classId = 4, className = "rogue", classToken = "ROGUE", classModuleName = "Rogue", specs = {
			{ specId = 1, specName = "assassination", specGlobalId = 259, resources = { energy = 100 } },
			{ specId = 2, specName = "combat", specGlobalId = 260, resources = { energy = 100 } },
			{ specId = 3, specName = "subtlety", specGlobalId = 261, resources = { energy = 100 } },
		} },
		{ classId = 5, className = "priest", classToken = "PRIEST", classModuleName = "Priest", specs = {
			{ specId = 1, specName = "discipline", specGlobalId = 256 },
			{ specId = 2, specName = "holy", specGlobalId = 257 },
			{ specId = 3, specName = "shadow", specGlobalId = 258 },
		} },
		{ classId = 7, className = "shaman", classToken = "SHAMAN", classModuleName = "Shaman", specs = {
			{ specId = 1, specName = "elemental", specGlobalId = 262 },
			{ specId = 2, specName = "enhancement", specGlobalId = 263 },
			{ specId = 3, specName = "restoration", specGlobalId = 264 },
		} },
		{ classId = 8, className = "mage", classToken = "MAGE", classModuleName = "Mage", specs = {
			{ specId = 1, specName = "arcane", specGlobalId = 62 },
			{ specId = 2, specName = "fire", specGlobalId = 63 },
			{ specId = 3, specName = "frost", specGlobalId = 64 },
		} },
		{ classId = 9, className = "warlock", classToken = "WARLOCK", classModuleName = "Warlock", specs = {
			{ specId = 1, specName = "affliction", specGlobalId = 265 },
			{ specId = 2, specName = "demonology", specGlobalId = 266 },
			{ specId = 3, specName = "destruction", specGlobalId = 267 },
		} },
		{ classId = 11, className = "druid", classToken = "DRUID", classModuleName = "Druid", specs = {
			{ specId = 1, specName = "balance", specGlobalId = 102 },
			{ specId = 2, specName = "feral", specGlobalId = 103, resources = { energy = 100 } },
			{ specId = 3, specName = "restoration", specGlobalId = 105 },
		} },
	},
}
