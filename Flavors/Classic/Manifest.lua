local addonName, TRB = ...

-- World of Warcraft Classic (Vanilla Era) flavor manifest; talent tabs are not specs, so each class has one "general" spec.
-- Field reference: see Flavors\Mainline\Manifest.lua and Core\FlavorRegistry.lua.

-- Talent ID -> its rank 1 spell, from the 1.15.9 Talent table. The client reports spellID 0 for every Classic talent, so
-- ReadTalentRanks keys each talent by this spell instead, the way retail keys a talent by its definition's spell.
local talentSpellIds = {
	-- Warrior
	[121] = 12834, [123] = 12281, [124] = 12282, [125] = 12284, [126] = 12285, [127] = 12286, [128] = 12287, [129] = 12289,
	[130] = 16462, [131] = 12290, [132] = 12700, [133] = 12292, [134] = 12165, [135] = 12294, [136] = 12163, [137] = 12296,
	[138] = 12297, [140] = 12299, [141] = 12300, [142] = 12301, [143] = 12302, [144] = 12303, [145] = 12945, [146] = 12308,
	[147] = 12797, [148] = 23922, [149] = 12311, [150] = 12312, [151] = 12313, [152] = 12809, [153] = 12975, [154] = 12318,
	[155] = 12317, [156] = 12319, [157] = 12320, [158] = 12321, [159] = 12322, [160] = 12323, [161] = 12324, [165] = 12328,
	[166] = 12329, [167] = 23881, [168] = 12862, [641] = 12295, [661] = 16487, [662] = 16493, [702] = 16538, [1541] = 20500,
	[1542] = 20502, [1543] = 20504, [1581] = 23584, [1601] = 12298,
	-- Paladin
	[1401] = 20042, [1402] = 20049, [1403] = 20060, [1405] = 20091, [1407] = 20101, [1409] = 20218, [1410] = 20111, [1411] = 20117,
	[1421] = 20127, [1422] = 20138, [1423] = 20143, [1424] = 20148, [1425] = 20174, [1426] = 20177, [1429] = 20196, [1430] = 20925,
	[1431] = 20911, [1432] = 20205, [1433] = 20216, [1435] = 26573, [1441] = 20066, [1442] = 20217, [1443] = 20234, [1444] = 20237,
	[1446] = 20244, [1449] = 20257, [1450] = 20262, [1461] = 20210, [1463] = 20224, [1464] = 20335, [1465] = 20359, [1481] = 20375,
	[1501] = 20468, [1502] = 20473, [1521] = 20487, [1626] = 20254, [1627] = 5923, [1628] = 9453, [1629] = 20096, [1630] = 20189,
	[1631] = 25956, [1632] = 9799, [1633] = 9452, [1634] = 26022,
	-- Hunter
	[1301] = 19151, [1303] = 19168, [1304] = 19184, [1305] = 19228, [1306] = 19239, [1308] = 19263, [1309] = 19286, [1310] = 19290,
	[1311] = 19295, [1312] = 19306, [1321] = 19370, [1322] = 19376, [1325] = 19386, [1341] = 19407, [1342] = 19416, [1343] = 19421,
	[1344] = 19426, [1345] = 19434, [1346] = 19454, [1347] = 19461, [1348] = 19464, [1349] = 19485, [1351] = 19491, [1352] = 19498,
	[1353] = 19503, [1361] = 19506, [1362] = 19507, [1381] = 19549, [1382] = 19552, [1384] = 19559, [1385] = 19572, [1386] = 19574,
	[1387] = 19577, [1388] = 19578, [1389] = 19583, [1390] = 19590, [1391] = 19596, [1393] = 19598, [1395] = 19609, [1396] = 19616,
	[1397] = 19621, [1621] = 19159, [1622] = 19255, [1623] = 24293, [1624] = 19557, [1625] = 24443,
	-- Rogue
	[181] = 13705, [182] = 13706, [183] = 13707, [184] = 13709, [186] = 13712, [187] = 13713, [201] = 13732, [202] = 13733,
	[203] = 13741, [204] = 13742, [205] = 13750, [206] = 13754, [221] = 13715, [222] = 13743, [223] = 13877, [241] = 13958,
	[242] = 13960, [244] = 13975, [245] = 13976, [246] = 13983, [247] = 13981, [261] = 14057, [262] = 14076, [263] = 14079,
	[265] = 14082, [268] = 14113, [269] = 14128, [270] = 14138, [272] = 14144, [273] = 14156, [274] = 14158, [276] = 14162,
	[277] = 14165, [278] = 14168, [279] = 14174, [280] = 14177, [281] = 14179, [283] = 14186, [284] = 14185, [301] = 14251,
	[303] = 14278, [381] = 14183, [382] = 14983, [681] = 16511, [682] = 16513, [1122] = 18427, [1123] = 14171, [1700] = 30892,
	[1701] = 30894, [1702] = 30902, [1703] = 30919,
	-- Priest
	[321] = 14531, [322] = 10060, [341] = 14520, [342] = 14522, [343] = 14748, [344] = 14749, [345] = 14524, [346] = 14747,
	[347] = 14521, [348] = 14751, [350] = 14750, [351] = 14752, [352] = 14523, [361] = 14892, [401] = 14889, [402] = 14901,
	[403] = 14909, [404] = 14898, [406] = 14908, [408] = 14912, [410] = 14913, [411] = 27900, [413] = 14911, [442] = 15237,
	[461] = 15257, [462] = 15259, [463] = 15260, [464] = 15268, [465] = 15270, [466] = 15318, [481] = 15273, [482] = 15275,
	[483] = 15274, [484] = 15286, [501] = 15407, [521] = 15473, [541] = 15487, [542] = 15392, [881] = 17322, [1181] = 18530,
	[1201] = 18551, [1202] = 18544, [1561] = 20711, [1635] = 27789, [1636] = 27811, [1637] = 724, [1638] = 27839,
	-- Shaman
	[561] = 16038, [562] = 16041, [563] = 16035, [564] = 16039, [565] = 16089, [567] = 16086, [572] = 16043, [573] = 16166,
	[574] = 16164, [575] = 16040, [581] = 16176, [582] = 16189, [583] = 16180, [586] = 16182, [587] = 16181, [588] = 16187,
	[589] = 16184, [590] = 16190, [591] = 16188, [592] = 16178, [593] = 16179, [594] = 16194, [595] = 16173, [601] = 16254,
	[602] = 16256, [605] = 16262, [607] = 16261, [609] = 16258, [610] = 16259, [611] = 16266, [612] = 16253, [613] = 16255,
	[614] = 17485, [615] = 16252, [616] = 16268, [617] = 16269, [721] = 16578, [901] = 17364, [1640] = 28996, [1641] = 28999,
	[1642] = 29062, [1643] = 29082, [1645] = 30160, [1646] = 29187, [1647] = 29192, [1648] = 29206,
	-- Mage
	[23] = 11083, [24] = 11094, [25] = 11095, [26] = 11069, [27] = 11078, [28] = 11100, [29] = 11366, [30] = 11103,
	[31] = 11108, [32] = 11113, [33] = 11115, [34] = 11119, [35] = 11124, [36] = 11129, [37] = 11070, [38] = 11071,
	[61] = 11151, [62] = 11165, [63] = 11185, [64] = 11190, [65] = 11175, [66] = 11160, [67] = 11170, [68] = 11180,
	[69] = 12472, [70] = 11189, [71] = 11426, [72] = 11958, [73] = 11207, [74] = 11210, [75] = 11213, [76] = 11222,
	[77] = 11232, [78] = 6057, [80] = 11237, [81] = 11242, [82] = 11247, [83] = 11252, [85] = 28574, [86] = 12043,
	[87] = 12042, [88] = 11255, [421] = 15058, [741] = 16757, [1141] = 18459, [1142] = 18462, [1639] = 29074, [1649] = 29438,
	[1650] = 29441,
	-- Warlock
	[941] = 17778, [943] = 17788, [944] = 17793, [961] = 17815, [963] = 17877, [964] = 17917, [965] = 17927, [966] = 17954,
	[967] = 17959, [968] = 17962, [981] = 18130, [982] = 18119, [983] = 18126, [984] = 18128, [985] = 18135, [986] = 18096,
	[1001] = 17783, [1002] = 18094, [1003] = 17810, [1004] = 17804, [1005] = 18174, [1006] = 18179, [1007] = 18182, [1021] = 18218,
	[1022] = 18220, [1041] = 18265, [1042] = 18271, [1061] = 18288, [1081] = 18223, [1082] = 18310, [1101] = 18213, [1121] = 17864,
	[1221] = 18692, [1222] = 18694, [1223] = 18697, [1224] = 18703, [1225] = 18705, [1226] = 18708, [1227] = 18709, [1241] = 18748,
	[1242] = 18731, [1243] = 18754, [1244] = 23785, [1261] = 18767, [1262] = 18769, [1263] = 18774, [1281] = 18788, [1282] = 19028,
	[1283] = 18821, [1284] = 18827,
	-- Druid
	[761] = 16689, [762] = 16814, [763] = 16821, [764] = 16819, [781] = 16833, [782] = 16836, [783] = 16845, [784] = 16850,
	[787] = 16918, [788] = 16864, [789] = 16880, [790] = 16896, [791] = 16902, [792] = 16909, [793] = 24858, [794] = 16929,
	[795] = 16858, [796] = 16934, [797] = 16940, [798] = 16942, [799] = 16947, [800] = 16952, [801] = 16958, [802] = 16966,
	[803] = 16972, [804] = 16979, [805] = 16998, [807] = 17002, [808] = 17003, [809] = 17007, [821] = 17050, [822] = 17056,
	[823] = 17063, [824] = 17069, [825] = 17074, [826] = 17079, [827] = 5570, [828] = 17104, [829] = 17106, [830] = 17111,
	[831] = 17116, [841] = 17118, [842] = 17123, [843] = 24968, [844] = 18562, [921] = 17245, [1162] = 16857,
}

-- Stats.lua adds stats and statEvents.
---@class TRB.Flavor
TRB.Flavor = {
	id = "classic",
	nameKey = "FlavorClassic",
	coreNewsLabel = "Classic",
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
	-- Talent tabs announce a learned or reset talent with this, as Blizzard's own talent frame reads it.
	talentEvents = { "PLAYER_TALENT_UPDATE" },
	-- The Cooldown Manager API exists, but its viewers do not and every category is empty.
	cooldownManager = false,
	-- Buffs are read straight from the player's auras, and no value this client hands out is a secret.
	playerAuras = true,
	secretValues = false,
	-- No Blizzard swing timer or PLAYER_SWING here, so swings come from the combat log and these casts.
	swingTimers = true,
	swingSpells = {
		meleeResets = {
			1464, 8820, 11604, 11605, -- Slam
			78, 284, 285, 1608, 11564, 11565, 11566, 11567, 25286, -- Heroic Strike
			845, 7369, 11608, 11609, 20569, -- Cleave
			2973, 14260, 14261, 14262, 14263, 14264, 14265, 14266, -- Raptor Strike
			6807, 6808, 6809, 8972, 9745, 9880, 9881, -- Maul
			20549, -- War Stomp
			2480, 7919, 7918, 2764, 5019, -- Shoot Bow, Shoot Crossbow, Shoot Gun, Throw, Shoot
			5384, -- Feign Death
		},
		rangedShots = {
			75, -- Auto Shot
			2480, 7919, 7918, 2764, 5019, -- Shoot Bow, Shoot Crossbow, Shoot Gun, Throw, Shoot
			5384, -- Feign Death
		},
		castsKeepSwing = {
			1464, 8820, 11604, 11605, -- Slam
			19434, 20900, 20901, 20902, 20903, 20904, -- Aimed Shot
			4054, 4061, 4062, 8331, 23000, 23063, -- Rough, Coarse, Heavy, Ez-Thro, Ez-Thro II, and Dense Dynamite
			4064, 4065, 4066, 4067, 4068, 4069, 12421, 12543, 12562, 19769, 19784, 19821, -- Bombs and grenades
		},
	},

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

	---Every learned or unlearned talent in the three talent tabs, keyed by its rank 1 spell.
	---@return table<integer, TRB.Flavor.TalentRank>
	ReadTalentRanks = function()
		local ranks = {}
		for tab = 1, GetNumTalentTabs() do
			for index = 1, GetNumTalents(tab) do
				local info = C_SpecializationInfo.GetTalentInfo({ specializationIndex = tab, talentIndex = index })
				if info ~= nil and talentSpellIds[info.talentID] ~= nil then
					ranks[talentSpellIds[info.talentID]] = { currentRank = info.rank, maxRank = info.maxRank }
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
