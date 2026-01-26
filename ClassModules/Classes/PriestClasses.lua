---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
if TRB.Data.character.classId ~= 5 then --Only do this if we're on a Priest!
	return
end

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
		id = 114255
	})

	return self
end


---@class TRB.Classes.Priest.DisciplineSpells : TRB.Classes.Priest.HealerSpells
--[[---@field public atonement TRB.Classes.SpellBase
---@field public evangelism TRB.Classes.SpellBase
---@field public powerWordRadiance TRB.Classes.SpellBase
---@field public lightsPromise TRB.Classes.SpellBase
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
	--[[self.atonement = TRB.Classes.SpellBase:New({
		id = 194384,
		isTalent = true,
		isBuff = true,
		isFriend = true,
		isSelfInitializeAllowed = true,
		duration = 15
	})
	self.evangelism = TRB.Classes.SpellBase:New({
		id = 472433,
		atonementMod = 6
	})
	self.powerWordRadiance = TRB.Classes.SpellBase:New({
		id = 194509,
		isTalent = true,
		hasCharges = true
	})
	self.lightsPromise = TRB.Classes.SpellBase:New({
		id = 322115,
		isTalent = true
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
	
	return self
end


---@class TRB.Classes.Priest.HolySpells : TRB.Classes.Priest.HealerSpells
---@field public flashHeal TRB.Classes.SpellBase
---@field public prayerOfHealing TRB.Classes.Priest.HolyWordSpell
---@field public halo TRB.Classes.SpellBase
--[[---@field public holyWordSerenity TRB.Classes.SpellBase
---@field public holyWordChastise TRB.Classes.SpellBase
---@field public holyWordSanctify TRB.Classes.SpellBase
---@field public resonantWords TRB.Classes.SpellBase
---@field public lightweaver TRB.Classes.SpellBase
---@field public miracleWorker TRB.Classes.SpellBase
---@field public sacredReverence TRB.Classes.SpellBase
---@field public voiceOfHarmony TRB.Classes.SpellBase
---@field public lightwell TRB.Classes.SpellBase
---@field public answeredPrayers TRB.Classes.SpellBase
---@field public smite TRB.Classes.Priest.HolyWordSpell
---@field public heal TRB.Classes.Priest.HolyWordSpell
---@field public holyFire TRB.Classes.Priest.HolyWordSpell
---@field public lightOfTheNaaru TRB.Classes.Priest.HolyWordSpell]]
---@field public benediction TRB.Classes.SpellBase
---@field public apotheosis TRB.Classes.Priest.HolyWordSpell
---@field public manifestedPower TRB.Classes.SpellBase
---@field public powerSurge TRB.Classes.SpellBase
---@field public energyConservation TRB.Classes.SpellBase
---@field public sustainedPotency TRB.Classes.SpellBase
TRB.Classes.Priest.HolySpells = setmetatable({}, {__index = TRB.Classes.Priest.HealerSpells})
TRB.Classes.Priest.HolySpells.__index = TRB.Classes.Priest.HolySpells

function TRB.Classes.Priest.HolySpells:New()
	---@type TRB.Classes.Priest.HealerSpells
	local base = TRB.Classes.Priest.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Priest.HolySpells) --[[@as TRB.Classes.Priest.HolySpells]]

	-- Priest Class Baseline Abilities
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
	--[[self.smite = TRB.Classes.Priest.HolyWordSpell:New({
		id = 585,
		holyWordKey = "holyWordChastise",
		holyWordReduction = 4,
		isTalent = false,
		baseline = true
	})]]

	-- Holy Baseline Abilities

	-- Holy Talent Abilities
	self.prayerOfHealing = TRB.Classes.Priest.HolyWordSpell:New({
		id = 596,
		holyWordKey = "holyWordSanctify",
		holyWordReduction = 6,
		isTalent = true
	})
	--[[self.holyWordSerenity = TRB.Classes.SpellBase:New({
		id = 2050,
		duration = 60,
		hasCharges = true
	})
	self.holyWordChastise = TRB.Classes.SpellBase:New({
		id = 88625,
		duration = 60,
		isTalent = true
	})
	self.holyWordSanctify = TRB.Classes.SpellBase:New({
		id = 34861,
		duration = 60,
		isTalent = true,
		hasCharges = true
	})
	self.holyFire = TRB.Classes.Priest.HolyWordSpell:New({
		id = 14914,
		holyWordKey = "holyWordChastise",
		holyWordReduction = 2, -- Per rank of Voice of Harmony
		isTalent = true
	})
	self.lightOfTheNaaru = TRB.Classes.Priest.HolyWordSpell:New({
		id = 196985,
		holyWordModifier = 0.1, -- Per rank
		isTalent = true
	})
	self.voiceOfHarmony = TRB.Classes.SpellBase:New({
		id = 390994,
		isTalent = true
	})]]
	self.apotheosis = TRB.Classes.Priest.HolyWordSpell:New({
		id = 200183,
		holyWordModifier = 4, -- 300% more
		duration = 20,
		isTalent = true
	})
	--[[self.resonantWords = TRB.Classes.SpellBase:New({
		id = 372313,
		talentId = 372309,
		isTalent = true
	})
	self.lightweaver = TRB.Classes.SpellBase:New({
		id = 390993,
		talentId = 390992,
		isTalent = true
	})
	self.miracleWorker = TRB.Classes.SpellBase:New({
		id = 235587,
		isTalent = true
	})
	self.lightwell = TRB.Classes.SpellBase:New({
		id = 372835,
		isTalent = true
	})
	self.answeredPrayers = TRB.Classes.SpellBase:New({
		id = 394289,
		talentId = 391387,
		isTalent = true,
		maxStackRank = {
			[0] = 0,
			[1] = 100,
			[2] = 50
		}
	})]]

	self.benediction = TRB.Classes.SpellBase:New({
		id = 1262755,
		isTalent = true
	})
	-- Set Bonuses


	-- Archon
	self.halo = TRB.Classes.SpellBase:New({
		id = 120517,
		isTalent = true,
		resource = 5
	})
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
	--[[self.resonantEnergy = TRB.Classes.SpellBase:New({
		id = 453845,
		debuffId = 453850,
		isTalent = true,
		duration = 8,
		maxStacks = 5
	})]]

	return self
end


---@class TRB.Classes.Priest.ShadowSpells : TRB.Classes.SpecializationSpellsBase
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
--[[
---@field public powerSurge TRB.Classes.SpellBase
---@field public misery TRB.Classes.SpellBase
---@field public shadowyInsight TRB.Classes.SpellBase
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
		resource = 2,
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
		isSnowflake = true
	})
	self.shadowWordMadness2 = TRB.Classes.SpellThreshold:New({
		id = 335467,
		primaryResourceType = Enum.PowerType.Insanity,
		primaryResourceTypeMod = 2,
		settingKey = "shadowWordMadness2",
		isTalent = true,
		isSnowflake = true
	})
	self.shadowWordMadness3 = TRB.Classes.SpellThreshold:New({
		id = 335467,
		primaryResourceType = Enum.PowerType.Insanity,
		primaryResourceTypeMod = 3,
		settingKey = "shadowWordMadness3",
		isTalent = true,
		isSnowflake = true
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
		id = 341540,
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
	self.shadowyInsight = TRB.Classes.SpellBase:New({
		id = 375981,
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


--[[
    BarGroups Factory for Priest
    Creates the appropriate BarGroup instances for each Priest specialization.
    
    Discipline: Primary bar (N=1) only
    Holy: Primary bar (N=1) only
    Shadow: Primary bar (N=1) only
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

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Health",
            1,
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

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            parentFrame or UIParent,
            "TwintopResourceBarFrame_Health",
            1,
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
                isPrimary = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 2 then -- Holy
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 3 then -- Shadow
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    end

    return {}
end