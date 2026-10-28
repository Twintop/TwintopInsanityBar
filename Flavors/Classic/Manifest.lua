local addonName, TRB = ...

-- World of Warcraft Classic (Vanilla Era) flavor manifest; talent tabs are not specs, so each class has one "general" spec.
-- Field reference: see Flavors\Mainline\Manifest.lua and Core\FlavorRegistry.lua.

-- Stats.lua adds stats and statEvents.
---@class TRB.Flavor
TRB.Flavor = {
	id = "classic",
	nameKey = "FlavorClassic",
	classNamespace = "Classic",
	-- Distinct from the other flavors' globals so no two flavors ever share a settings table.
	savedVariablesName = "TwintopInsanityBarClassicSettings",
	-- Retail's 61304 does not exist on this client.
	gcdSpellId = 29515,
	-- No flying of any kind.
	unavailableVisibilityConditions = {
		isMountedFlying = true, isSteadyFlight = true, isSteadyFlightFlying = true, isSkyriding = true, isSkyridingFlying = true,
		isDruidFlightForm = true, isDruidSwiftFlightForm = true,
	},
	-- Ranked spells are learned one at a time, so a threshold's spell may not be known yet.
	thresholdsRequireKnown = true,
	pvpTalents = false,

	---True when the running client is WoW Classic: the classic project with a 1.13 to 1.15 interface number.
	---An unreadable project ID or interface number is not evidence of a mismatch.
	---@return boolean
	IsClientMatch = function()
		if WOW_PROJECT_ID ~= nil and WOW_PROJECT_CLASSIC ~= nil and WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
			return false
		end
		local interfaceVersion = tonumber((select(4, GetBuildInfo())))
		return interfaceVersion == nil or (interfaceVersion >= 11300 and interfaceVersion < 16000)
	end,

	---Active specialization index; always 1, since talent tabs are not specializations.
	---@return integer?
	GetSpecializationIndex = function()
		return 1
	end,

	---Every learned or unlearned talent in the three talent tabs, keyed by the spell ID the client reports for it.
	---@return table<integer, TRB.Flavor.TalentRank>
	ReadTalentRanks = function()
		local ranks = {}
		for tab = 1, GetNumTalentTabs() do
			for index = 1, GetNumTalents(tab) do
				local info = C_SpecializationInfo.GetTalentInfo({ specializationIndex = tab, talentIndex = index })
				if info ~= nil and info.spellID ~= nil and info.spellID ~= 0 then
					ranks[info.spellID] = { currentRank = info.rank, maxRank = info.maxRank }
				end
			end
		end
		return ranks
	end,

	---Channel tick profiles any class can cast. Each bandage tier has its own spell and length; all tick once a second.
	---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
	DefaultCastbarTickProfiles = function()
		local function Bandage(seconds)
			return { mode = "fixedCount", baseDuration = seconds, tickCount = seconds, firstTickAtStart = false }
		end
		return {
			-- Cannibalize
			[20578] = { mode = "fixedCount", baseDuration = 10, tickCount = 5, firstTickAtStart = false },
			-- Linen and Heavy Linen Bandage
			[746] = Bandage(6),
			[1159] = Bandage(6),
			-- Wool and Heavy Wool Bandage
			[3267] = Bandage(7),
			[3268] = Bandage(7),
			-- Silk, Mageweave, Runecloth, and Dense Runecloth Bandage tiers
			[7926] = Bandage(8),
			[7927] = Bandage(8),
			[10838] = Bandage(8),
			[10839] = Bandage(8),
			[18608] = Bandage(8),
			[18610] = Bandage(8),
			[470345] = Bandage(8),
			-- Battleground bandages: Warsong Gulch, Alterac Valley, and Arathi Basin
			[23567] = Bandage(8),
			[23568] = Bandage(8),
			[23569] = Bandage(8),
			[23696] = Bandage(8),
			[24412] = Bandage(8),
			[24413] = Bandage(8),
			[24414] = Bandage(8),
			-- Crystal Infused Bandage
			[30020] = Bandage(10),
		}
	end,

	-- Class ids follow the client's class file ids (Death Knight = 6, Monk = 10, Demon Hunter = 12, and
	-- Evoker = 13 do not exist here, so the ids are sparse). No spec has a specGlobalId, since the client
	-- has no specializations to name it after.
	-- Druid shows Mana, Rage, Energy, and Combo Points as separate bars that follow the shapeshift form.
	classes = {
		{ classId = 1, className = "warrior", classToken = "WARRIOR", classModuleName = "Warrior", specs = {
			{ specId = 1, specName = "general", resources = { rage = 100 } },
		} },
		{ classId = 2, className = "paladin", classToken = "PALADIN", classModuleName = "Paladin", specs = {
			{ specId = 1, specName = "general" },
		} },
		{ classId = 3, className = "hunter", classToken = "HUNTER", classModuleName = "Hunter", specs = {
			{ specId = 1, specName = "general" },
		} },
		{ classId = 4, className = "rogue", classToken = "ROGUE", classModuleName = "Rogue", specs = {
			{ specId = 1, specName = "general", resources = { energy = 110 } }, -- Vigor adds 10
		} },
		{ classId = 5, className = "priest", classToken = "PRIEST", classModuleName = "Priest", specs = {
			{ specId = 1, specName = "general" },
		} },
		{ classId = 7, className = "shaman", classToken = "SHAMAN", classModuleName = "Shaman", specs = {
			{ specId = 1, specName = "general" },
		} },
		{ classId = 8, className = "mage", classToken = "MAGE", classModuleName = "Mage", specs = {
			{ specId = 1, specName = "general" },
		} },
		{ classId = 9, className = "warlock", classToken = "WARLOCK", classModuleName = "Warlock", specs = {
			{ specId = 1, specName = "general" },
		} },
		{ classId = 11, className = "druid", classToken = "DRUID", classModuleName = "Druid", specs = {
			{ specId = 1, specName = "general", resources = { rage = 100, energy = 100, comboPoints = 5 } },
		} },
	},
}

-- Spells have one ID per rank here. Resolution walks rankIds from the top and takes the first known rank,
-- remembered per spell until the spellbook changes (SPELLS_CHANGED fires on every learn and unlearn).
do
	local generation = 0
	local spellbookFrame = CreateFrame("Frame")
	spellbookFrame:RegisterEvent("SPELLS_CHANGED")
	spellbookFrame:SetScript("OnEvent", function()
		generation = generation + 1
	end)

	---@param spell TRB.Classes.SpellBase
	---@return integer
	function TRB.Flavor.ResolveSpellRankId(spell)
		if spell.rankGeneration == generation and spell.rankedId ~= nil then
			return spell.rankedId
		end
		local rankedId = spell.id
		for i = #spell.rankIds, 1, -1 do
			local rankId = spell.rankIds[i]
			if C_SpellBook.IsSpellKnown(rankId) then
				rankedId = rankId
				break
			end
		end
		spell.rankedId = rankedId
		spell.rankGeneration = generation
		return rankedId
	end
end
