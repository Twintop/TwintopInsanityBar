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

L["WarriorArmsFull"] = string.format("%s %s", L["WarriorArms"], L["Warrior"])
L["WarriorFuryFull"] = string.format("%s %s", L["WarriorFury"], L["Warrior"])
L["WarriorProtectionFull"] = string.format("%s %s", L["WarriorProtection"], L["Warrior"])
L["PaladinHolyFull"] = string.format("%s %s", L["PaladinHoly"], L["Paladin"])
L["PaladinProtectionFull"] = string.format("%s %s", L["PaladinProtection"], L["Paladin"])
L["PaladinRetributionFull"] = string.format("%s %s", L["PaladinRetribution"], L["Paladin"])
L["HunterBeastMasteryFull"] = string.format("%s %s", L["HunterBeastMastery"], L["Hunter"])
L["HunterMarksmanshipFull"] = string.format("%s %s", L["HunterMarksmanship"], L["Hunter"])
L["HunterSurvivalFull"] = string.format("%s %s", L["HunterSurvival"], L["Hunter"])
L["RogueAssassinationFull"] = string.format("%s %s", L["RogueAssassination"], L["Rogue"])
L["RogueOutlawFull"] = string.format("%s %s", L["RogueOutlaw"], L["Rogue"])
L["RogueSubtletyFull"] = string.format("%s %s", L["RogueSubtlety"], L["Rogue"])
L["PriestDisciplineFull"] = string.format("%s %s", L["PriestDiscipline"], L["Priest"])
L["PriestHolyFull"] = string.format("%s %s", L["PriestHoly"], L["Priest"])
L["PriestShadowFull"] = string.format("%s %s", L["PriestShadow"], L["Priest"])
L["DeathKnightBloodFull"] = string.format("%s %s", L["DeathKnightBlood"], L["DeathKnight"])
L["DeathKnightFrostFull"] = string.format("%s %s", L["DeathKnightFrost"], L["DeathKnight"])
L["DeathKnightUnholyFull"] = string.format("%s %s", L["DeathKnightUnholy"], L["DeathKnight"])
L["ShamanElementalFull"] = string.format("%s %s", L["ShamanElemental"], L["Shaman"])
L["ShamanEnhancementFull"] = string.format("%s %s", L["ShamanEnhancement"], L["Shaman"])
L["ShamanRestorationFull"] = string.format("%s %s", L["ShamanRestoration"], L["Shaman"])
L["MageArcaneFull"] = string.format("%s %s", L["MageArcane"], L["Mage"])
L["MageFireFull"] = string.format("%s %s", L["MageFire"], L["Mage"])
L["MageFrostFull"] = string.format("%s %s", L["MageFrost"], L["Mage"])
L["WarlockAfflictionFull"] = string.format("%s %s", L["WarlockAffliction"], L["Warlock"])
L["WarlockDemonologyFull"] = string.format("%s %s", L["WarlockDemonology"], L["Warlock"])
L["WarlockDescructionFull"] = string.format("%s %s", L["WarlockDescruction"], L["Warlock"])
L["MonkBrewmasterFull"] = string.format("%s %s", L["MonkBrewmaster"], L["Monk"])
L["MonkMistweaverFull"] = string.format("%s %s", L["MonkMistweaver"], L["Monk"])
L["MonkWindwalkerFull"] = string.format("%s %s", L["MonkWindwalker"], L["Monk"])
L["DruidBalanceFull"] = string.format("%s %s", L["DruidBalance"], L["Druid"])
L["DruidFeralFull"] = string.format("%s %s", L["DruidFeral"], L["Druid"])
L["DruidGuardianFull"] = string.format("%s %s", L["DruidGuardian"], L["Druid"])
L["DruidRestorationFull"] = string.format("%s %s", L["DruidRestoration"], L["Druid"])
L["DemonHunterHavocFull"] = string.format("%s %s", L["DemonHunterHavoc"], L["DemonHunter"])
L["DemonHunterVengeanceFull"] = string.format("%s %s", L["DemonHunterVengeance"], L["DemonHunter"])
L["EvokerDevastationFull"] = string.format("%s %s", L["EvokerDevastation"], L["Evoker"])
L["EvokerPreservationFull"] = string.format("%s %s", L["EvokerPreservation"], L["Evoker"])
L["EvokerAugmentationFull"] = string.format("%s %s", L["EvokerAugmentation"], L["Evoker"])

-- Use existing localization strings provided by Blizzard for some things.
-- Source: https://www.townlong-yak.com/framexml/live/GlobalStrings.lua

L["ResourceFury"] = POWER_TYPE_FURY
L["ResourceEnergy"] = POWER_TYPE_ENERGY
L["ResourceComboPoints"] = COMBO_POINTS_POWER
L["ResourceRage"] = POWER_TYPE_RED_POWER
L["ResourceMana"] = POWER_TYPE_MANA
L["ResourceInsanity"] = POWER_TYPE_INSANITY
L["ResourceMaelstrom"] = POWER_TYPE_MAELSTROM
L["ResourceAstralPower"] = POWER_TYPE_LUNAR_POWER
L["ResourceChi"] = CHI_POWER
L["ResourceFocus"] = POWER_TYPE_FOCUS
L["ResourceEssence"] = POWER_TYPE_ESSENCE
L["ResourceHolyPower"] = HOLY_POWER

TRB.Localization = L