local _, TRB = ...
local L = TRB.Localization

-- Mainline resource vocabulary: every resourceType this flavor's GetSpecConfiguration declares, and the Global Bar
-- Text's resource anchors. Loads after Core's localization and before Core reads it.

---@type table<string, TRB.Flavor.ResourceType>
TRB.Flavor.resourceTypes = {
	-- Primary power types
	Rage = { name = L["ResourceRage"] },
	Mana = { name = L["ResourceMana"], percentScale = true },
	Energy = { name = L["ResourceEnergy"] },
	Focus = { name = L["ResourceFocus"] },
	Insanity = { name = L["ResourceInsanity"] },
	RunicPower = { name = L["ResourceRunicPower"] },
	Maelstrom = { name = L["ResourceMaelstrom"] },
	AstralPower = { name = L["ResourceAstralPower"] },
	Fury = { name = L["ResourceFury"] },
	-- Secondary, custom, and utility resources
	ComboPoints = { name = L["ResourceComboPoints"], containerLabel = L["ComboPointsContainer"] },
	SoulShards = { name = L["ResourceSoulShards"], containerLabel = L["SoulShardsContainer"] },
	SoulFragments = { name = L["ResourceSoulFragments"], containerLabel = L["SoulFragmentsContainer"] },
	CollapsingStar = { name = L["ResourceCollapsingStar"] },
	ArcaneCharges = { name = L["ResourceArcaneCharges"], containerLabel = L["ArcaneChargesContainer"] },
	Runes = { name = L["ResourceRunes"], containerLabel = L["RunesContainer"] },
	HolyPower = { name = L["ResourceHolyPower"], containerLabel = L["HolyPowerContainer"] },
	Chi = { name = L["ResourceChi"], containerLabel = L["ChiContainer"] },
	Essence = { name = L["ResourceEssence"], containerLabel = L["EssenceContainer"] },
	TipOfTheSpear = { name = L["ResourceTipOfTheSpear"], containerLabel = L["TipOfTheSpearContainer"] },
	MaelstromWeapon = { name = L["ResourceMaelstromWeapon"], containerLabel = L["MaelstromWeaponContainer"] },
	Icicles = { name = L["ResourceIcicles"], containerLabel = L["IciclesContainer"] },
	Shatter = { name = L["ResourceMageShatter"], containerLabel = L["ShatterContainer"] },
	ArcaneSalvo = { name = L["ResourceMageArcaneSalvo"] },
	BoneShield = { name = L["ResourceBoneShield"], containerLabel = L["BoneShieldContainer"] },
	CoagulatingBlood = { name = L["ResourceCoagulatingBlood"] },
	Stagger = { name = L["ResourceStagger"] },
	Utility = { name = L["ResourceUtility"] },
	AngelicFeather = { name = L["ResourceAngelicFeather"], containerLabel = L["AngelicFeatherContainer"] },
	Lightweaver = { name = L["ResourcePriestLightweaver"], containerLabel = L["LightweaverContainer"] },
	HolyWords = { name = L["ResourcePriestHolyWords"] },
	PowerWords = { name = L["BarNamePowerWordsBar"] },
	DefensiveBuffs = { name = L["ResourceWarriorDefensives"] },
	WhirlwindCharges = { name = L["ResourceWarriorWhirlwind"], containerLabel = L["WhirlwindChargesContainer"] },
	EbonMight = { name = L["ResourceEvokerEbonMight"] },
	Dragonrage = { name = L["ResourceEvokerDragonrage"] },
	ElementalBlastBuffs = { name = L["ResourceShamanElementalBlastBuffs"] },
	FireBlastCharges = { name = L["MageFireBlastCharges"] },
	Brews = { name = L["ResourceMonkBrews"] },
	Ironfur = { name = L["ResourceDruidIronfur"] },
}

-- Global Bar Text anchors beyond the bars every spec has, keyed by the bar group they sort with.
---@type table<string, TRB.Classes.SpecDescriptor.AnchorFrame[]>
TRB.Flavor.globalBarTextAnchorFrames = {
	secondary = {
		{ label = L["ComboPoint1"], frame = "ComboPoint_1" },
		{ label = L["ComboPoint2"], frame = "ComboPoint_2" },
		{ label = L["ComboPoint3"], frame = "ComboPoint_3" },
		{ label = L["ComboPoint4"], frame = "ComboPoint_4" },
		{ label = L["ComboPoint5"], frame = "ComboPoint_5" },
	},
}
