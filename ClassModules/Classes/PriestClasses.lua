---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Priest = TRB.Classes.Priest or {}

---@class TRB.Classes.Priest.HolyWordSpell : TRB.Classes.SpellBase
---@field public holyWordKey string? # Holy Word spell key that has its cooldown reduced on cast.
---@field public holyWordReduction number? # How much the associated Holy Word will have its cooldown reduced.
---@field public holyWordModifier number? # Modification of the reduction when included with related casts.
TRB.Classes.Priest.HolyWordSpell = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.Priest.HolyWordSpell.__index = TRB.Classes.Priest.HolyWordSpell

---Creates a new HolyWordSpell object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.Priest.HolyWordSpell
function TRB.Classes.Priest.HolyWordSpell:New(spellAttributes)
	---@type TRB.Classes.SpellBase
	local spellBase = TRB.Classes.SpellBase
	self = setmetatable(spellBase:New(spellAttributes), {__index = TRB.Classes.Priest.HolyWordSpell})

	table.insert(self.classTypes, "TRB.Classes.Priest.HolyWordSpell")
	
	self.holyWordModifier = 1
	self.holyWordReduction = 0

	for key, value in pairs(spellAttributes) do
		if  (key == "holyWordReduction" and type(value) == "number") or
			(key == "holyWordModifier"  and type(value) == "number") or
			(key == "holyWordKey") then
			self[key] = value
			self.attributes[key] = nil
		end
	end

	return self
end


---@class TRB.Classes.Priest.HealerSpells : TRB.Classes.Healer.HealerSpells
---@field public flashHeal TRB.Classes.SpellBase
---@field public surgeOfLight TRB.Classes.SpellBase
---@field public angelicFeather TRB.Classes.SpellBase
---@field public powerWordShield TRB.Classes.SpellBase
---@field public voidbinding TRB.Classes.SpellBase
TRB.Classes.Priest.HealerSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Priest.HealerSpells.__index = TRB.Classes.Priest.HealerSpells

function TRB.Classes.Priest.HealerSpells:New()
	---@type TRB.Classes.Healer.HealerSpells
	local base = TRB.Classes.Healer.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Priest.HealerSpells) --[[@as TRB.Classes.Priest.HealerSpells]]

	-- Priest Class Baseline Abilities
	self.flashHeal = TRB.Classes.SpellBase:New({
		id = 2061,
		isTalent = false,
		baseline = true,
		primaryResourceType = Enum.PowerType.Mana,
		attributes = {
			baseManaCost = nil -- Populated at runtime, used to detect Surge of Light via cost reduction
		}
	})
	self.surgeOfLight = TRB.Classes.SpellBase:New({
		id = 114255,
		isBuff = true
	})

	-- Priest Class Talent Abilities
	self.angelicFeather = TRB.Classes.SpellBase:New({
		id = 121536,
		isTalent = true,
		hasCharges = true,
		maxCharges = 3,
		duration = 20
	})

	self.powerWordShield = TRB.Classes.SpellBase:New({
		id = 17,
		isTalent = false,
		baseline = true
	})

	self.voidbinding = TRB.Classes.SpellBase:New({
		id = 462661,
		versPercent = 0.2,
		cdrPercent = 0.3,
		duration = 30
	})

	return self
end


---@class TRB.Classes.Priest.DisciplineSpells : TRB.Classes.Priest.HealerSpells
---@field public powerWordRadiance TRB.Classes.SpellBase
---@field public lightsPromise TRB.Classes.SpellBase
---@field public brightPupil TRB.Classes.SpellBase
---@field public evangelism TRB.Classes.SpellBase
---@field public harshDiscipline TRB.Classes.SpellBase
---@field public masterTheDarkness TRB.Classes.SpellBase
--[[---@field public atonement TRB.Classes.SpellBase
---@field public shadowCovenant TRB.Classes.SpellBase
---@field public entropicRift TRB.Classes.SpellBase
---@field public depthOfShadows TRB.Classes.SpellBase]]
TRB.Classes.Priest.DisciplineSpells = setmetatable({}, {__index = TRB.Classes.Priest.HealerSpells})
TRB.Classes.Priest.DisciplineSpells.__index = TRB.Classes.Priest.DisciplineSpells

function TRB.Classes.Priest.DisciplineSpells:New()
	---@type TRB.Classes.Priest.HealerSpells
	local base = TRB.Classes.Priest.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Priest.DisciplineSpells) --[[@as TRB.Classes.Priest.DisciplineSpells]]

	-- Priest Class Baseline Abilities
	
	-- Discipline Baseline Abilities

	-- Priest Talent Abilities

	-- Discipline Talent Abilities
	self.powerWordRadiance = TRB.Classes.SpellBase:New({
		id = 194509,
		isTalent = true,
		hasCharges = true,
		duration = 18
	})
	self.lightsPromise = TRB.Classes.SpellBase:New({
		id = 322115,
		isTalent = true
	})
	self.brightPupil = TRB.Classes.SpellBase:New({
		id = 390684,
		isTalent = true,
		durationMod = -3
	})
	self.evangelism = TRB.Classes.SpellBase:New({
		id = 472433,
		isTalent = true
	})
	self.harshDiscipline = TRB.Classes.SpellBase:New({
		id = 373183,
		talentId = 373180,
		isTalent = true,
		isBuff = true,
		duration = 30,
		maxStacks = 2
	})
	--[[self.atonement = TRB.Classes.SpellBase:New({
		id = 194384,
		isTalent = true,
		isBuff = true,
		isFriend = true,
		isSelfInitializeAllowed = true,
		duration = 15
	})
	self.shadowCovenant = TRB.Classes.SpellBase:New({
		id = 322105,
		talentId = 314867,
		isTalent = true
	})

	-- Voidweaver
	self.entropicRift = TRB.Classes.SpellBase:New({
		id = 450193,
		talentId = 447444,
		isTalent = true,
		duration = 8
	})
	self.depthOfShadows = TRB.Classes.SpellBase:New({
		id = 451308,
		isTalent = true
	})]]
	
	self.masterTheDarkness = TRB.Classes.SpellBase:New({
		id = 1253593,
		buffId = 1253591,
		isBuff = true,
		duration = 60
	})

	return self
end

---Fills barTextVariables for Discipline Priest options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Priest.DisciplineSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Priest.DisciplineSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#pwRadiance", icon = spells.powerWordRadiance.icon, description = spells.powerWordRadiance.name, printInSettings = true },
		{ variable = "#powerWordRadiance", icon = spells.powerWordRadiance.icon, description = spells.powerWordRadiance.name, printInSettings = false },
		--[[{ variable = "#atonement", icon = spells.atonement.icon, description = spells.atonement.name, printInSettings = true },
		{ variable = "#entropicRift", icon = spells.entropicRift.icon, description = spells.entropicRift.name, printInSettings = true },
		{ variable = "#sc", icon = spells.shadowCovenant.icon, description = spells.shadowCovenant.name, printInSettings = true },
		{ variable = "#shadowCovenant", icon = spells.shadowCovenant.icon, description = spells.shadowCovenant.name, printInSettings = false },]]
		{ variable = "#af", icon = spells.angelicFeather.icon, description = spells.angelicFeather.name, printInSettings = true },
		{ variable = "#angelicFeather", icon = spells.angelicFeather.icon, description = spells.angelicFeather.name, printInSettings = false },
		{ variable = "#voidShield", icon = spells.masterTheDarkness.icon, description = spells.masterTheDarkness.name, printInSettings = true },
		{ variable = "#masterTheDarkness", icon = spells.masterTheDarkness.icon, description = spells.masterTheDarkness.name, printInSettings = false },
		{ variable = "#harshDiscipline", icon = spells.harshDiscipline.icon, description = spells.harshDiscipline.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PriestDisciplineBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PriestDisciplineBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PriestDisciplineBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PriestDisciplineBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$pwRadianceTime", description = L["PriestDisciplineBarTextVariable_pwRadianceTime"], printInSettings = true, color = false },
		{ variable = "$radianceTime", description = "", printInSettings = false, color = false },
		{ variable = "$powerWordRadianceTime", description = "", printInSettings = false, color = false },

		{ variable = "$pwRadianceCharges", description = L["PriestDisciplineBarTextVariable_pwRadianceCharges"], printInSettings = true, color = false },
		{ variable = "$radianceCharges", description = "", printInSettings = false, color = false },
		{ variable = "$powerWordRadianceCharges", description = "", printInSettings = false, color = false },

		--[[{ variable = "$scTime", description = L["PriestDisciplineBarTextVariable_scTime"], printInSettings = true, color = false },
		{ variable = "$shadowCovenantTime", description = "", printInSettings = false, color = false },]]

		{ variable = "$afTime", description = L["PriestBarTextVariable_afTime"], printInSettings = true, color = false },
		{ variable = "$afCharges", description = L["PriestBarTextVariable_afCharges"], printInSettings = true, color = false },
		{ variable = "$afMaxCharges", description = L["PriestBarTextVariable_afMaxCharges"], printInSettings = true, color = false },

		{ variable = "$surgeOfLight", description = L["PriestBarTextVariable_surgeOfLight"], printInSettings = false, color = false },
		{ variable = "$surgeOfLightStacks", description = L["PriestBarTextVariable_surgeOfLightStacks"], printInSettings = true, color = false },
		{ variable = "$surgeOfLightTime", description = L["PriestBarTextVariable_surgeOfLightTime"], printInSettings = true, color = false },

		{ variable = "$voidShieldTime", description = L["PriestDisciplineBarTextVariable_voidShieldTime"], printInSettings = true, color = false },
		{ variable = "$masterTheDarknessTime", description = "", printInSettings = false, color = false },

		{ variable = "$harshDisciplineTime", description = L["PriestDisciplineBarTextVariable_harshDisciplineTime"], printInSettings = true, color = false },
		{ variable = "$harshDisciplineStacks", description = L["PriestDisciplineBarTextVariable_harshDisciplineStacks"], printInSettings = true, color = false },
		{ variable = "$harshDisciplineMaxStacks", description = L["PriestDisciplineBarTextVariable_harshDisciplineMaxStacks"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Discipline, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Priest.DisciplineSpells.GetCastbarTickProfiles()
	return {
		-- Penance: 3 bolts baseline over 2s; Castigation/Harsh Discipline bolts come from tick modifiers.
		[47757] = { mode = "fixedCount", baseDuration = 2, tickCount = 3, firstTickAtStart = true },
		[47758] = { mode = "fixedCount", baseDuration = 2, tickCount = 3, firstTickAtStart = true },
	}
end

---Gets built-in castbar tick modifiers for Discipline (talent/buff-conditional bonus ticks), keyed by
---channel spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.CastbarTickModifier[]>
function TRB.Classes.Priest.DisciplineSpells.GetCastbarTickModifiers()
	return {
		-- Penance
		[47757] = {
			-- Castigation: +1 bolt while talented
			{ talentId = 193134, bonusTicks = 1 },
			-- Harsh Discipline: Penance after Power Word: Radiance fires +1 bolt per talent rank
			{ talentId = 373180, buffId = 373183, bonusTicks = { 1, 2 } },
		},
		[47758] = {
			-- Castigation: +1 bolt while talented
			{ talentId = 193134, bonusTicks = 1 },
			-- Harsh Discipline: Penance after Power Word: Radiance fires +1 bolt per talent rank
			{ talentId = 373180, buffId = 373183, bonusTicks = { 1, 2 } },
		},
	}
end


---@class TRB.Classes.Priest.HolySpells : TRB.Classes.Priest.HealerSpells
---@field public flashHeal TRB.Classes.Priest.HolyWordSpell
---@field public prayerOfHealing TRB.Classes.Priest.HolyWordSpell
---@field public halo TRB.Classes.Priest.HolyWordSpell
---@field public apotheosis TRB.Classes.Priest.HolyWordSpell
---@field public prayerOfMending TRB.Classes.Priest.HolyWordSpell
---@field public smite TRB.Classes.Priest.HolyWordSpell
---@field public holyFire TRB.Classes.Priest.HolyWordSpell
---@field public lightOfTheNaaru TRB.Classes.Priest.HolyWordSpell
---@field public energyCycle TRB.Classes.Priest.HolyWordSpell
---@field public benediction TRB.Classes.Priest.HolyWordSpell
---@field public holyWordSerenity TRB.Classes.SpellBase
---@field public holyWordChastise TRB.Classes.SpellBase
---@field public holyWordSanctify TRB.Classes.SpellBase
---@field public ultimateSerenity TRB.Classes.SpellBase
---@field public miracleWorker TRB.Classes.SpellBase
---@field public holyCelerity TRB.Classes.SpellBase
---@field public prophetsInsight TRB.Classes.SpellBase
---@field public voiceOfHarmony TRB.Classes.SpellBase
---@field public lightweaver TRB.Classes.SpellBase
---@field public eternalSanctity TRB.Classes.SpellBase
---@field public manifestedPower TRB.Classes.SpellBase
---@field public powerSurge TRB.Classes.SpellBase
---@field public energyConservation TRB.Classes.SpellBase
---@field public sustainedPotency TRB.Classes.SpellBase
---@field public spiritwell TRB.Classes.SpellBase
TRB.Classes.Priest.HolySpells = setmetatable({}, {__index = TRB.Classes.Priest.HealerSpells})
TRB.Classes.Priest.HolySpells.__index = TRB.Classes.Priest.HolySpells

function TRB.Classes.Priest.HolySpells:New()
	---@type TRB.Classes.Priest.HealerSpells
	local base = TRB.Classes.Priest.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Priest.HolySpells) --[[@as TRB.Classes.Priest.HolySpells]]

	-- Holy Word: Chastise
	self.holyWordChastise = TRB.Classes.SpellBase:New({
		id = 88625,
		duration = 60,
		isTalent = true
	})
	self.smite = TRB.Classes.Priest.HolyWordSpell:New({
		id = 585,
		holyWordKey = "holyWordChastise",
		holyWordReduction = 4,
		isTalent = false,
		baseline = true
	})
	self.holyFire = TRB.Classes.Priest.HolyWordSpell:New({
		id = 14914,
		holyWordKey = "holyWordChastise",
		holyWordReduction = 4, -- Per rank of Voice of Harmony
		isTalent = true
	})
	self.holyNova = TRB.Classes.Priest.HolyWordSpell:New({
		id = 132157,
		holyWordKey = "holyWordChastise",
		holyWordReduction = 4,
		isTalent = true
	})

	-- Holy Word: Sanctify
	self.holyWordSanctify = TRB.Classes.SpellBase:New({
		id = 34861,
		duration = 60,
		isTalent = true,
		hasCharges = true
	})
	self.prayerOfHealing = TRB.Classes.Priest.HolyWordSpell:New({
		id = 596,
		holyWordKey = "holyWordSanctify",
		holyWordReduction = 6,
		isTalent = true
	})
	self.halo = TRB.Classes.Priest.HolyWordSpell:New({
		id = 120517,
		isTalent = true,
		resource = 5,
		holyWordKey = "holyWordSanctify",
		holyWordReduction = 4,
	})
	self.energyCycle = TRB.Classes.Priest.HolyWordSpell:New({
		id = 453828,
		holyWordKey = "holyWordSanctify",
		holyWordReduction = 4,
		isTalent = true
	})
	self.spiritwell = TRB.Classes.SpellBase:New({
		id = 1247178,
		isTalent = true
	})

	-- Holy Word: Serenity
	self.holyWordSerenity = TRB.Classes.SpellBase:New({
		id = 2050,
		duration = 60,
		hasCharges = true
	})
	self.flashHeal = TRB.Classes.Priest.HolyWordSpell:New({
		id = 2061,
		holyWordKey = "holyWordSerenity",
		holyWordReduction = 6,
		isTalent = false,
		baseline = true,
		primaryResourceType = Enum.PowerType.Mana,
		attributes = {
			baseManaCost = nil -- Populated at runtime, used to detect Surge of Light via cost reduction
		}
	})
	self.prayerOfMending = TRB.Classes.Priest.HolyWordSpell:New({
		id = 33076,
		holyWordKey = "holyWordSerenity",
		holyWordReduction = 4, -- Per rank of Voice of Harmony
	})
	self.benediction = TRB.Classes.Priest.HolyWordSpell:New({
		id = 1262763,
		talentId = 1262755,
		isTalent = true,
		holyWordKey = "holyWordSerenity",
		holyWordReduction = 6,
		duration = 30,
	})

	-- Holy Baseline Abilities

	-- Holy Talent Abilities
	self.ultimateSerenity = TRB.Classes.SpellBase:New({
		id = 1246517,
		isTalent = true
	})
	self.miracleWorker = TRB.Classes.SpellBase:New({
		id = 235587,
		isTalent = true
	})
	self.holyCelerity = TRB.Classes.SpellBase:New({
		id = 1215275,
		isTalent = true,
		durationMod = -15
	})
	self.prophetsInsight = TRB.Classes.SpellBase:New({
		id = 1272359,
		isTalent = true,
		durationMod = -5
	})
	self.lightOfTheNaaru = TRB.Classes.Priest.HolyWordSpell:New({
		id = 196985,
		holyWordModifier = 0.1, -- Per rank
		isTalent = true
	})
	self.voiceOfHarmony = TRB.Classes.SpellBase:New({
		id = 390994,
		isTalent = true
	})
	self.apotheosis = TRB.Classes.Priest.HolyWordSpell:New({
		id = 200183,
		holyWordModifier = 3, -- 200% more
		duration = 20,
		isTalent = true
	})
	self.lightweaver = TRB.Classes.SpellBase:New({
		id = 390993,
		talentId = 390992,
		isTalent = true,
		duration = 20,
		maxStacks = 4
	})
	self.eternalSanctity = TRB.Classes.SpellBase:New({
		id = 1215245,
		isTalent = true,
		durationMod = 12
	})
	-- Set Bonuses


	-- Archon
	self.manifestedPower = TRB.Classes.SpellBase:New({
		id = 453783,
		isTalent = true
	})
	self.powerSurge = TRB.Classes.SpellBase:New({
		id = 453109,
		isTalent = true,
		resourcePerTick = 15,
		tickRate = 5,
		ticks = 3,
		duration = 10,
		hasTicks = true
	})
	self.energyConservation = TRB.Classes.SpellBase:New({
		id = 1272308,
		ticks = 1,
		isTalent = true
	})
	self.sustainedPotency = TRB.Classes.SpellBase:New({
		id = 454001,
		buffId = 454002,
		isTalent = true,
		duration = 120,
		maxStacks = 6,
		pauseDuration = 20,
		durationMod = 1
	})

	return self
end

---Fills barTextVariables for Holy Priest options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Priest.HolySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Priest.HolySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#flashHeal", icon = spells.flashHeal.icon, description = spells.flashHeal.name, printInSettings = true },

		{ variable = "#apotheosis", icon = spells.apotheosis.icon, description = spells.apotheosis.name, printInSettings = true },
		{ variable = "#hf", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = true },
		{ variable = "#holyFire", icon = spells.holyFire.icon, description = spells.holyFire.name, printInSettings = false },
		{ variable = "#hwChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = true },
		{ variable = "#chastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
		{ variable = "#holyWordChastise", icon = spells.holyWordChastise.icon, description = spells.holyWordChastise.name, printInSettings = false },
		{ variable = "#hwSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = true },
		{ variable = "#sanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
		{ variable = "#holyWordSanctify", icon = spells.holyWordSanctify.icon, description = spells.holyWordSanctify.name, printInSettings = false },
		{ variable = "#hwSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = true },
		{ variable = "#serenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
		{ variable = "#holyWordSerenity", icon = spells.holyWordSerenity.icon, description = spells.holyWordSerenity.name, printInSettings = false },
		{ variable = "#lightweaver", icon = spells.lightweaver.icon, description = spells.lightweaver.name, printInSettings = true },
		{ variable = "#smite", icon = spells.smite.icon, description = spells.smite.name, printInSettings = true },
		{ variable = "#af", icon = spells.angelicFeather.icon, description = spells.angelicFeather.name, printInSettings = true },
		{ variable = "#angelicFeather", icon = spells.angelicFeather.icon, description = spells.angelicFeather.name, printInSettings = false },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["PriestHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["PriestHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["PriestHolyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PriestHolyBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$hwChastiseTime", description = L["PriestHolyBarTextVariable_hwChastiseTime"], printInSettings = true, color = false },
		{ variable = "$chastiseTime", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordChastiseTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSanctifyTime", description = L["PriestHolyBarTextVariable_hwSanctifyTime"], printInSettings = true, color = false },
		{ variable = "$sanctifyTime", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSanctifyTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSanctifyCharges", description = L["PriestHolyBarTextVariable_hwSanctifyCharges"], printInSettings = true, color = false },
		{ variable = "$sanctifyCharges", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSanctifyCharges", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSerenityTime", description = L["PriestHolyBarTextVariable_hwSerenityTime"], printInSettings = true, color = false },
		{ variable = "$serenityTime", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSerenityTime", description = "", printInSettings = false, color = false },
		
		{ variable = "$hwSerenityCharges", description = L["PriestHolyBarTextVariable_hwSerenityCharges"], printInSettings = true, color = false },
		{ variable = "$serenityCharges", description = "", printInSettings = false, color = false },
		{ variable = "$holyWordSerenityCharges", description = "", printInSettings = false, color = false },

		{ variable = "$apotheosisTime", description = L["PriestHolyBarTextVariable_apotheosisTime"], printInSettings = true, color = false },
		
		{ variable = "$lightweaverStacks", description = L["PriestHolyBarTextVariable_lightweaverStacks"], printInSettings = true, color = false },
		{ variable = "$lightweaverTime", description = L["PriestHolyBarTextVariable_lightweaverTime"], printInSettings = true, color = false },

		{ variable = "$afTime", description = L["PriestBarTextVariable_afTime"], printInSettings = true, color = false },
		{ variable = "$afCharges", description = L["PriestBarTextVariable_afCharges"], printInSettings = true, color = false },
		{ variable = "$afMaxCharges", description = L["PriestBarTextVariable_afMaxCharges"], printInSettings = true, color = false },

		{ variable = "$surgeOfLight", description = L["PriestBarTextVariable_surgeOfLight"], printInSettings = false, color = false },
		{ variable = "$surgeOfLightStacks", description = L["PriestBarTextVariable_surgeOfLightStacks"], printInSettings = true, color = false },
		{ variable = "$surgeOfLightTime", description = L["PriestBarTextVariable_surgeOfLightTime"], printInSettings = true, color = false },
		{ variable = "$benediction", description = L["PriestHolyBarTextVariable_benediction"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Holy, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Priest.HolySpells.GetCastbarTickProfiles()
	return {
		-- Divine Hymn
		[64843] = { mode = "fixedCount", baseDuration = 5, tickCount = 5, firstTickAtStart = true },
	}
end


---@class TRB.Classes.Priest.ShadowSpells : TRB.Classes.SpecializationSpellsBase
---@field public angelicFeather TRB.Classes.SpellBase
---@field public mindBlast TRB.Classes.SpellBase
---@field public mindFlay TRB.Classes.SpellBase
---@field public surgeOfInsanity TRB.Classes.SpellBase
---@field public vampiricTouch TRB.Classes.SpellBase
---@field public voidform TRB.Classes.SpellBase
---@field public improvedVoidform TRB.Classes.SpellBase
---@field public ancientMadness TRB.Classes.SpellBase
---@field public voidVolley TRB.Classes.SpellBase
---@field public halo TRB.Classes.SpellBase
---@field public manifestedPower TRB.Classes.SpellBase
---@field public mindFlayInsanity TRB.Classes.SpellBase
---@field public powerSurge TRB.Classes.SpellBase
---@field public energyConservation TRB.Classes.SpellBase
---@field public voidTorrent TRB.Classes.SpellBase
---@field public voidBlast TRB.Classes.SpellBase
---@field public voidInfusion TRB.Classes.SpellBase
---@field public entropicRift TRB.Classes.SpellBase
---@field public darkeningHorizon TRB.Classes.SpellBase
---@field public mindgames TRB.Classes.SpellBase
---@field public screamsOfTheVoid TRB.Classes.SpellBase
---@field public shadowWordPain TRB.Classes.SpellBase
---@field public tentacleSlam TRB.Classes.SpellBase
---@field public maddeningTentacles TRB.Classes.SpellBase
---@field public sustainedPotency TRB.Classes.SpellBase
---@field public shadowyInsight TRB.Classes.SpellBase
--[[
---@field public powerSurge TRB.Classes.SpellBase
---@field public misery TRB.Classes.SpellBase
---@field public shatteredPsyche TRB.Classes.SpellBase
---@field public idolOfYoggSaron TRB.Classes.SpellBase
---@field public thingFromBeyond TRB.Classes.SpellBase
---@field public horrificVisions TRB.Classes.SpellBase
---@field public subservientShadows TRB.Classes.SpellBase
---@field public depthOfShadows TRB.Classes.SpellBase]]
---@field public mindDevourer TRB.Classes.SpellBase
---@field public shadowWordMadness TRB.Classes.SpellThreshold
---@field public shadowWordMadness2 TRB.Classes.SpellThreshold
---@field public shadowWordMadness3 TRB.Classes.SpellThreshold
TRB.Classes.Priest.ShadowSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Priest.ShadowSpells.__index = TRB.Classes.Priest.ShadowSpells

function TRB.Classes.Priest.ShadowSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Priest.ShadowSpells) --[[@as TRB.Classes.Priest.ShadowSpells]]
	
	-- Priest Class Talent Abilities
	self.angelicFeather = TRB.Classes.SpellBase:New({
		id = 121536,
		isTalent = true,
		hasCharges = true,
		maxCharges = 3,
		duration = 20
	})

	-- Priest Class Baseline Abilities
	self.mindBlast = TRB.Classes.SpellBase:New({
		id = 8092,
		resource = 6,
		isTalent = false,
		baseline = true,
		hasCharges = true
	})
	self.shadowWordPain = TRB.Classes.SpellBase:New({
		id = 589,
		resource = 3,
		baseDuration = 16,
		pandemic = true,
		isTalent = false,
		baseline = true,
		miseryPandemic = 21,
		miseryPandemicTime = 21 * 0.3,
	})

	-- Shadow Baseline Abilities
	self.mindFlay = TRB.Classes.SpellBase:New({
		id = 15407,
		resource = 3,
		isTalent = false,
		baseline = true
	})
	self.surgeOfInsanity = TRB.Classes.SpellBase:New({
		id = 391399,
		isTalent = true,
		resourceMod = 1.3
	})
	self.vampiricTouch = TRB.Classes.SpellBase:New({
		id = 34914,
		resource = 4,
		baseDuration = 21,
		pandemic = true,
		isTalent = false,
		baseline = true
	})

	-- Priest Talent Abilities			
	--[[
	self.massDispel = TRB.Classes.SpellBase:New({
		id = 32375,
		isTalent = true
	})
	self.twistOfFate = TRB.Classes.SpellBase:New({
		id = 390978,
		isTalent = true
	})
	self.powerSurge = TRB.Classes.SpellBase:New({
		id = 453113,
		talentId = 453109,
		isTalent = true,
		resourcePerTick = 10,
		tickRate = 5,
		hasTicks = true
	})
	self.powerInfusion = TRB.Classes.SpellBase:New({
		id = 10060,
		isTalent = true
	})]]
	-- Shadow Talent Abilities			
	self.shadowWordMadness = TRB.Classes.SpellThreshold:New({
		id = 335467,
		castId = 335467,
		primaryResourceType = Enum.PowerType.Insanity,
		settingKey = "shadowWordMadness",
		isTalent = true,
		isSnowflake = true,
		category = "offensive"
	})
	self.shadowWordMadness2 = TRB.Classes.SpellThreshold:New({
		id = 335467,
		primaryResourceType = Enum.PowerType.Insanity,
		primaryResourceTypeMod = 2,
		settingKey = "shadowWordMadness2",
		isTalent = true,
		isSnowflake = true,
		category = "offensive",
		canHaveAudioCue = false
	})
	self.shadowWordMadness3 = TRB.Classes.SpellThreshold:New({
		id = 335467,
		primaryResourceType = Enum.PowerType.Insanity,
		primaryResourceTypeMod = 3,
		settingKey = "shadowWordMadness3",
		isTalent = true,
		isSnowflake = true,
		category = "offensive",
		canHaveAudioCue = false
	})
	self.mindDevourer = TRB.Classes.SpellBase:New({
		id = 373204,
		talentId = 373202,
		isTalent = true
	})
	self.voidform = TRB.Classes.SpellBase:New({
		id = 228260,
		buffId = 194249,
		isTalent = true,
		resource = 10,
		duration = 20
	})
	self.improvedVoidform = TRB.Classes.SpellBase:New({
		id = 341240,
		isTalent = true,
		resource = 60
	})
	self.ancientMadness = TRB.Classes.SpellBase:New({
		id = 1231346,
		isTalent = true,
		durationMod = 3,
		durationPerCastMod = 0.75
	})
	self.voidVolley = TRB.Classes.SpellBase:New({
		id = 1242173,
		resource = 10,
		isTalent = true
	})
	self.screamsOfTheVoid = TRB.Classes.SpellBase:New({
		id = 375767,
		isTalent = true,
		duration = 3
	})
	self.tentacleSlam = TRB.Classes.SpellBase:New({
		id = 1227280,
		castId = 1227280,
		isTalent = true,
		delay = 0.75
	})
	self.maddeningTentacles = TRB.Classes.SpellBase:New({
		id = 1279353,
		isTalent = true
	})
	self.shadowyInsight = TRB.Classes.SpellBase:New({
		id = 375981,
		isTalent = true
	})
	--[[self.shadowyApparition = TRB.Classes.SpellBase:New({
		id = 341491,
		isTalent = true
	})
	self.auspiciousSpirits = TRB.Classes.SpellBase:New({
		id = 155271,
		idSpawn = 341263,
		idImpact = 413231,
		resource = 1,
		targetChance = function(num)
			if num == 0 then
				return 0
			else
				return 0.8*(num^(-0.8))
			end
		end,
		isTalent = true
	})
	self.misery = TRB.Classes.SpellBase:New({
		id = 238558,
		isTalent = true
	})
	self.hallucinations = TRB.Classes.SpellBase:New({
		id = 280752,
		resource = 4,
		isTalent = true
	})
	self.shatteredPsyche = TRB.Classes.SpellBase:New({
		id = 391092,
		isTalent = true,
		---@type TRB.Classes.BuffCustomProperty[]
		customPropertyDefinitions = {
			TRB.Classes.BuffCustomProperty:New(1, "integer", "crit", 1)
		}
	})
	self.subservientShadows = TRB.Classes.SpellBase:New({
		id = 1228516,
		isTalent = true,
		modPercent = 1.2
	})
	self.idolOfYoggSaron = TRB.Classes.SpellBase:New({
		id = 373276,
		talentId = 373273,
		isTalent = true,
		requiredStacks = 25
	})
	self.thingFromBeyond = TRB.Classes.SpellBase:New({
		id = 373277,
		isTalent = true,
		duration = 20
	})
	self.horrificVisions = TRB.Classes.SpellBase:New({
		id = 1243069,
		debuffId = 1243069,
		duration = 30,
		maxStacks = 99,
		stackResourceTriggers = {
			[50] = {
				resource = 1,
				duration = 3,
				ticks = 4
			},
			[100] = {
				resource = 1,
				duration = 3,
				ticks = 12
			}
		}
	})]]

	-- Archon
	self.halo = TRB.Classes.SpellBase:New({
		id = 120644,
		isTalent = true,
		resource = 5
	})
	self.manifestedPower = TRB.Classes.SpellBase:New({
		id = 453783,
		isTalent = true
	})
	self.mindFlayInsanity = TRB.Classes.SpellBase:New({
		id = 391401,
		buffId = 391401,
		castId = 391403,
		resource = 4,
		duration = 30
	})
	self.powerSurge = TRB.Classes.SpellBase:New({
		id = 453109,
		isTalent = true,
		resourcePerTick = 10,
		tickRate = 5,
		ticks = 2,
		duration = 10,
		hasTicks = true
	})
	self.energyConservation = TRB.Classes.SpellBase:New({
		id = 1272308,
		ticks = 1,
		isTalent = true
	})
	self.sustainedPotency = TRB.Classes.SpellBase:New({
		id = 454001,
		isTalent = true,
		duration = 120,
		maxStacks = 6,
		pauseDuration = 20,
		durationMod = 1
	})
	--[[self.resonantEnergy = TRB.Classes.SpellBase:New({
		id = 453845,
		debuffId = 453850,
		isTalent = true,
		duration = 8,
		maxStacks = 5
	})]]

	-- Voidweaver
	self.voidTorrent = TRB.Classes.SpellBase:New({
		id = 263165,
		resource = 6,
		isTalent = true
	})
	self.voidBlast = TRB.Classes.SpellBase:New({
		id = 450983,
		talentId = 450405,
		resource = 6,
		isTalent = true,
		hasCharges = true
	})
	self.voidInfusion = TRB.Classes.SpellBase:New({
		id = 450612,
		resourceMod = 2,
		isTalent = true
	})
	self.entropicRift = TRB.Classes.SpellBase:New({
		id = 450193,
		isTalent = true,
		duration = 8
	})
	self.darkeningHorizon = TRB.Classes.SpellBase:New({
		id = 449912,
		isTalent = true,
		duration = 1,
		maxExtensions = 3
	})
	--[[self.depthOfShadows = TRB.Classes.SpellBase:New({
		id = 451308,
		isTalent = true
	})]]

	-- PvP Talents
	self.mindgames = TRB.Classes.SpellBase:New({
		id = 375901,
		isTalent = true,
		resource = 10,
		isPvp = true
	})

    --Set Bonuses

	return self
end

---Fills barTextVariables for Shadow Priest options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Priest.ShadowSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Priest.ShadowSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#swm", icon = spells.shadowWordMadness.icon, description = spells.shadowWordMadness.name, printInSettings = true },
		{ variable = "#shadowWordMadness", icon = spells.shadowWordMadness.icon, description = spells.shadowWordMadness.name, printInSettings = false },

		{ variable = "#entropicRift", icon = spells.entropicRift.icon, description = spells.entropicRift.name, printInSettings = true },

		{ variable = "#halo", icon = spells.halo.icon, description = spells.halo.name, printInSettings = true },
				
		--[[{ variable = "#hv", icon = spells.horrificVisions.icon, description = spells.horrificVisions.name, printInSettings = true },
		{ variable = "#horrificVisions", icon = spells.horrificVisions.icon, description = spells.horrificVisions.name, printInSettings = false },]]

		{ variable = "#mDev", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = true },
		{ variable = "#mindDevourer", icon = spells.mindDevourer.icon, description = spells.mindDevourer.name, printInSettings = false },

		{ variable = "#mindgames", icon = spells.mindgames.icon, description = spells.mindgames.name, printInSettings = true },

		{ variable = "#mb", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = true },
		{ variable = "#mindBlast", icon = spells.mindBlast.icon, description = spells.mindBlast.name, printInSettings = false },
		
		{ variable = "#mfi", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = true },
		{ variable = "#mindFlayInsanity", icon = spells.mindFlayInsanity.icon, description = spells.mindFlayInsanity.name, printInSettings = false },

		{ variable = "#mf", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = true },
		{ variable = "#mindFlay", icon = spells.mindFlay.icon, description = spells.mindFlay.name, printInSettings = false },

		{ variable = "#sotv", icon = spells.screamsOfTheVoid.icon, description = spells.screamsOfTheVoid.name, printInSettings = true },
		{ variable = "#screamsOfTheVoid", icon = spells.screamsOfTheVoid.icon, description = spells.screamsOfTheVoid.name, printInSettings = false },

		{ variable = "#si", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = true },
		{ variable = "#shadowyInsight", icon = spells.shadowyInsight.icon, description = spells.shadowyInsight.name, printInSettings = false },
		--[[																												
		
		{ variable = "#sp", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = true },
		{ variable = "#shatteredPsyche", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = false },
		{ variable = "#mm", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = false },
		{ variable = "#mindMelt", icon = spells.shatteredPsyche.icon, description = spells.shatteredPsyche.name, printInSettings = false },
		
		{ variable = "#tfb", icon = spells.thingFromBeyond.icon, description = spells.thingFromBeyond.name, printInSettings = true },
		{ variable = "#thingFromBeyond", icon = spells.thingFromBeyond.icon, description = spells.thingFromBeyond.name, printInSettings = false },]]
		
		{ variable = "#vf", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = true },
		{ variable = "#voidform", icon = spells.voidform.icon, description = spells.voidform.name, printInSettings = false },
																																								
		{ variable = "#voit", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = true },
		{ variable = "#voidTorrent", icon = spells.voidTorrent.icon, description = spells.voidTorrent.name, printInSettings = false },
																																								
		{ variable = "#vv", icon = spells.voidVolley.icon, description = spells.voidVolley.name, printInSettings = true },
		{ variable = "#voidVolley", icon = spells.voidVolley.icon, description = spells.voidVolley.name, printInSettings = false },

		{ variable = "#vt", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = true },
		{ variable = "#vampiricTouch", icon = spells.vampiricTouch.icon, description = spells.vampiricTouch.name, printInSettings = false },
		
		--[[{ variable = "#ys", icon = spells.idolOfYoggSaron.icon, description = spells.idolOfYoggSaron.name, printInSettings = true },
		{ variable = "#idolOfYoggSaron", icon = spells.idolOfYoggSaron.icon, description = spells.idolOfYoggSaron.name, printInSettings = false },]]

		{ variable = "#af", icon = spells.angelicFeather.icon, description = spells.angelicFeather.name, printInSettings = true },
		{ variable = "#angelicFeather", icon = spells.angelicFeather.icon, description = spells.angelicFeather.name, printInSettings = false },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$insanity", description = L["PriestShadowBarTextVariable_insanity"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$insanityMax", description = L["PriestShadowBarTextVariable_insanityMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["PriestShadowBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["PriestHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$manaPercent", description = L["PriestHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["PriestHolyBarTextVariable_manaMax"], printInSettings = true, color = false },

		{ variable = "$mfiTime", description = L["PriestShadowBarTextVariable_mfiTime"], printInSettings = true, color = false },
		{ variable = "$mfiStacks", description = L["PriestShadowBarTextVariable_mfiStacks"], printInSettings = true, color = false },

		{ variable = "$sotvTime", description = L["PriestShadowBarTextVariable_sotvTime"], printInSettings = true, color = false },

		{ variable = "$entropicRiftTime", description = L["PriestShadowBarTextVariable_entropicRiftTime"], printInSettings = true, color = false },
		{ variable = "$entropicRiftExtensionsRemaining", description = L["PriestShadowBarTextVariable_entropicRiftExtensionsRemaining"], printInSettings = true, color = false },

		{ variable = "$vfTime", description = L["PriestShadowBarTextVariable_vfTime"], printInSettings = true, color = false },

		{ variable = "$shadowWordMadnessUsable", description = L["PriestShadowBarTextVariable_shadowWordMadnessUsable"], printInSettings = true, color = false },

		--[[{ variable = "$siTime", description = L["PriestShadowBarTextVariable_siTime"], printInSettings = true, color = false },
		
		{ variable = "$mindBlastCharges", description = L["PriestShadowBarTextVariable_mindBlastCharges"], printInSettings = true, color = false },
		{ variable = "$mindBlastMaxCharges", description = L["PriestShadowBarTextVariable_mindBlastMaxCharges"], printInSettings = true, color = false },

		{ variable = "$spTime", description = L["PriestShadowBarTextVariable_spTime"], printInSettings = true, color = false },
		{ variable = "$mmTime", description = L["PriestShadowBarTextVariable_spTime"], printInSettings = false, color = false },
		{ variable = "$spStacks", description = L["PriestShadowBarTextVariable_spStacks"], printInSettings = true, color = false },
		{ variable = "$mmStacks", description = L["PriestShadowBarTextVariable_spStacks"], printInSettings = false, color = false },
		{ variable = "$spCrit", description = L["PriestShadowBarTextVariable_spCrit"], printInSettings = true, color = false },


		{ variable = "$ysTime", description = L["PriestShadowBarTextVariable_ysTime"], printInSettings = true, color = false },
		{ variable = "$ysStacks", description = L["PriestShadowBarTextVariable_ysStacks"], printInSettings = true, color = false },
		{ variable = "$ysRemainingStacks", description = L["PriestShadowBarTextVariable_ysRemainingStacks"], printInSettings = true, color = false },
		{ variable = "$tfbTime", description = L["PriestShadowBarTextVariable_tfbTime"], printInSettings = true, color = false },

		{ variable = "$reTime", description = L["PriestShadowBarTextVariable_reTime"], printInSettings = true, color = false },
		{ variable = "$reStacks", description = L["PriestShadowBarTextVariable_reStacks"], printInSettings = true, color = false },

		{ variable = "$voidVolleyTime", description = L["PriestShadowBarTextVariable_voidVolleyTime"], printInSettings = true }]]

		{ variable = "$afTime", description = L["PriestBarTextVariable_afTime"], printInSettings = true, color = false },
		{ variable = "$afCharges", description = L["PriestBarTextVariable_afCharges"], printInSettings = true, color = false },
		{ variable = "$afMaxCharges", description = L["PriestBarTextVariable_afMaxCharges"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Shadow, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Priest.ShadowSpells.GetCastbarTickProfiles()
	return {
		-- Mind Flay: constant tick count, duration shrinks with haste.
		[15407] = { mode = "fixedCount", baseDuration = 4.5, tickCount = 6, firstTickAtStart = false, chains = true },
		-- Void Torrent: fixed 3s channel, tick rate accelerates with haste, partial final tick.
		[263165] = { mode = "fixedRate", baseDuration = 3.0, baseTickRate = 1, firstTickAtStart = true },
		-- Mind Flay: Insanity
		[391403] = { mode = "fixedCount", baseDuration = 1.5, tickCount = 4, firstTickAtStart = false, chains = true },
	}
end


--[[
    BarGroups Factory for Priest
    Creates the appropriate BarGroup instances for each Priest specialization.
    
    Discipline: Primary bar (N=1) + Secondary Power Words (N=2) + Utility Angelic Feather (N=3)
    Holy: Primary bar (N=1) + Holy Words (N=5) + Utility Angelic Feather (N=3)
    Shadow: Primary bar (N=1) + Mana bar (N=1) + Utility Angelic Feather (N=3)
]]

---@class TRB.Classes.Priest.BarGroupsFactory
TRB.Classes.Priest.BarGroupsFactory = {}
TRB.Classes.Priest.BarGroupsFactory.__index = TRB.Classes.Priest.BarGroupsFactory

---Creates BarGroup instances for the specified Priest specialization
---@param specId integer # 1=Discipline, 2=Holy, 3=Shadow
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Priest.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    if specId == 1 then -- Discipline
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Secondary Power Words bar (up to 2 nodes: PWR 1 base + 1 from Light's Promise)
        barGroups.secondary = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Secondary",
            2,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

        -- Utility bar for Angelic Feather (3 charge nodes)
        barGroups.utility = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Utility",
            3,
            false -- not primary
        )

    elseif specId == 2 then -- Holy
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Holy Words bar (up to 5 nodes: Serenity 2 + Sanctify 2 + Chastise 1)
        barGroups.holyWords = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_HolyWords",
            5,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

        -- Utility bar for Angelic Feather (3 charge nodes)
        barGroups.utility = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Utility",
            3,
            false -- not primary
        )

        -- Lightweaver buff stacks bar (4 nodes)
        barGroups.lightweaver = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Lightweaver",
            4,
            false -- not primary
        )

    elseif specId == 3 then -- Shadow
        -- Primary insanity bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Secondary mana bar (1 node) - optional, controlled by settings
        barGroups.mana = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Mana",
            1,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

        -- Utility bar for Angelic Feather (3 charge nodes)
        barGroups.utility = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Utility",
            3,
            false -- not primary
        )
    end

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Priest.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Discipline
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            secondary = {
                maxNodes = 2,
                isPrimary = false,
				resourceType = "PowerWords",
				allowContainerAnchor = false
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            },
            utility = {
                maxNodes = 3,
                isPrimary = false,
                resourceType = "AngelicFeather"
            }
        }
    elseif specId == 2 then -- Holy
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Mana"
            },
            holyWords = {
                maxNodes = 5,
                isPrimary = false,
				resourceType = "HolyWords",
				allowContainerAnchor = false
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            },
            utility = {
                maxNodes = 3,
                isPrimary = false,
                resourceType = "AngelicFeather"
            },
            lightweaver = {
                maxNodes = 4,
                isPrimary = false,
                resourceType = "Lightweaver"
            }
        }
    elseif specId == 3 then -- Shadow
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Insanity"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            },
            utility = {
                maxNodes = 3,
                isPrimary = false,
                resourceType = "AngelicFeather"
            }
        }
    end

    return {}
end

-- Override the generic utility bar type with Angelic Feather-specific display name, node colors, and defaults
---@return table
function TRB.Classes.Priest.DefaultAngelicFeatherUtilityBarColors()
	return {
		border = { color = "FFD6AA00" },
		background = { color = "66000000" },
		sameColor = false,
		nodeColors = {
			angelicFeather1 = { color = "FFFFE77A", enabled = true },
			angelicFeather2 = { color = "FFFFE34B", enabled = true },
			angelicFeather3 = { color = "FFEEC800", enabled = true }
		}
	}
end

do
	local L = TRB.Localization
	local registry = TRB.Classes.BarTypeRegistry:GetInstance()
	local utilityDef = registry:Get("utility")
	if utilityDef then
		utilityDef.nodeColors = {
			{ key = "angelicFeather1", displayName = L["AngelicFeatherCharge1"], hasEnabled = false },
			{ key = "angelicFeather2", displayName = L["AngelicFeatherCharge2"], hasEnabled = false },
			{ key = "angelicFeather3", displayName = L["AngelicFeatherCharge3"], hasEnabled = false }
		}
		utilityDef.defaultColorsFunc = function()
			return TRB.Classes.Priest.DefaultAngelicFeatherUtilityBarColors()
		end
	end
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["priest_discipline"] = TRB.Classes.Priest.DisciplineSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["priest_holy"] = TRB.Classes.Priest.HolySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["priest_shadow"] = TRB.Classes.Priest.ShadowSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["priest_shadow"] = TRB.Classes.Priest.ShadowSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["priest_discipline"] = TRB.Classes.Priest.DisciplineSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["priest_holy"] = TRB.Classes.Priest.HolySpells.GetCastbarTickProfiles

-- Register built-in castbar tick modifiers (talent/buff-conditional bonus ticks)
TRB.Data.castbarTickModifiersRegistry = TRB.Data.castbarTickModifiersRegistry or {}
TRB.Data.castbarTickModifiersRegistry["priest_discipline"] = TRB.Classes.Priest.DisciplineSpells.GetCastbarTickModifiers