local _, TRB = ...

local L = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

-- Class and spec names to be used throughout
local classList = LocalizedClassList()
L["Warrior"] = classList["WARRIOR"]
L["Paladin"] = classList["PALADIN"]
L["Hunter"] = classList["HUNTER"]
L["Rogue"] = classList["ROGUE"]
L["Priest"] = classList["PRIEST"]
L["DeathKnight"] = classList["DEATHKNIGHT"]
L["Shaman"] = classList["SHAMAN"]
L["Mage"] = classList["MAGE"]
L["Warlock"] = classList["WARLOCK"]
L["Monk"] = classList["MONK"]
L["Druid"] = classList["DRUID"]
L["DemonHunter"] = classList["DEMONHUNTER"]
L["Evoker"] = classList["EVOKER"]

L["WarriorArms"] = select(2, GetSpecializationInfoByID(71))
L["WarriorFury"] = select(2, GetSpecializationInfoByID(72))
L["WarriorProtection"] = select(2, GetSpecializationInfoByID(73))

L["PaladinHoly"] = select(2, GetSpecializationInfoByID(65))
L["PaladinProtection"] = select(2, GetSpecializationInfoByID(66))
L["PaladinRetribution"] = select(2, GetSpecializationInfoByID(70))

L["HunterBeastMastery"] = select(2, GetSpecializationInfoByID(253))
L["HunterMarksmanship"] = select(2, GetSpecializationInfoByID(254))
L["HunterSurvival"] = select(2, GetSpecializationInfoByID(255))

L["RogueAssassination"] = select(2, GetSpecializationInfoByID(259))
L["RogueOutlaw"] = select(2, GetSpecializationInfoByID(260))
L["RogueSubtlety"] = select(2, GetSpecializationInfoByID(261))

L["PriestDiscipline"] = select(2, GetSpecializationInfoByID(256))
L["PriestHoly"] = select(2, GetSpecializationInfoByID(257))
L["PriestShadow"] = select(2, GetSpecializationInfoByID(258))

L["DeathKnightBlood"] = select(2, GetSpecializationInfoByID(250))
L["DeathKnightFrost"] = select(2, GetSpecializationInfoByID(251))
L["DeathKnightUnholy"] = select(2, GetSpecializationInfoByID(252))

L["ShamanElemental"] = select(2, GetSpecializationInfoByID(262))
L["ShamanEnhancement"] = select(2, GetSpecializationInfoByID(263))
L["ShamanRestoration"] = select(2, GetSpecializationInfoByID(264))

L["MageArcane"] = select(2, GetSpecializationInfoByID(62))
L["MageFire"] = select(2, GetSpecializationInfoByID(63))
L["MageFrost"] = select(2, GetSpecializationInfoByID(64))

L["WarlockAffliction"] = select(2, GetSpecializationInfoByID(265))
L["WarlockDemonology"] = select(2, GetSpecializationInfoByID(266))
L["WarlockDescruction"] = select(2, GetSpecializationInfoByID(267))

L["MonkBrewmaster"] = select(2, GetSpecializationInfoByID(268))
L["MonkMistweaver"] = select(2, GetSpecializationInfoByID(270))
L["MonkWindwalker"] = select(2, GetSpecializationInfoByID(269))

L["DruidBalance"] = select(2, GetSpecializationInfoByID(102))
L["DruidFeral"] = select(2, GetSpecializationInfoByID(103))
L["DruidGuardian"] = select(2, GetSpecializationInfoByID(104))
L["DruidRestoration"] = select(2, GetSpecializationInfoByID(105))

L["DemonHunterHavoc"] = select(2, GetSpecializationInfoByID(577))
L["DemonHunterVengeance"] = select(2, GetSpecializationInfoByID(581))

L["EvokerDevastation"] = select(2, GetSpecializationInfoByID(1467))
L["EvokerPreservation"] = select(2, GetSpecializationInfoByID(1468))
L["EvokerAugmentation"] = select(2, GetSpecializationInfoByID(1473))

TRB.Localization = L