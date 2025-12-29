local _, TRB = ...
if TRB.Data.character.classId ~= 12 then --Only do this if we're on a DemonHunter!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.DemonHunter = TRB.Classes.DemonHunter or {}


---@class TRB.Classes.DemonHunter.HavocSpells : TRB.Classes.SpecializationSpellsBase
---@field public demonic TRB.Classes.SpellBase
---@field public immolationAura TRB.Classes.SpellBase
---@field public immolationAura1 TRB.Classes.SpellBase
---@field public immolationAura2 TRB.Classes.SpellBase
---@field public immolationAura3 TRB.Classes.SpellBase
---@field public immolationAura4 TRB.Classes.SpellBase
---@field public immolationAura5 TRB.Classes.SpellBase
---@field public immolationAura6 TRB.Classes.SpellBase
---@field public metamorphosis TRB.Classes.SpellBase
---@field public burningHatred TRB.Classes.SpellBase
---@field public felfireHeart TRB.Classes.SpellBase
---@field public blindFury TRB.Classes.SpellBase
---@field public unboundChaos TRB.Classes.SpellBase
---@field public tacticalRetreat TRB.Classes.SpellBase
---@field public chaosTheory TRB.Classes.SpellBase
---@field public artOfTheGlaive TRB.Classes.SpellBase
---@field public glaiveFlurry TRB.Classes.SpellBase
---@field public rendingStrike TRB.Classes.SpellBase
---@field public studentOfSuffering TRB.Classes.SpellBase
---@field public warbladesHunger TRB.Classes.SpellBase
---@field public illidansGrasp TRB.Classes.SpellBase
---@field public throwGlaive TRB.Classes.SpellThreshold
---@field public bladeDance TRB.Classes.SpellThreshold
---@field public chaosStrike TRB.Classes.SpellThreshold
---@field public annihilation TRB.Classes.SpellThreshold
---@field public deathSweep TRB.Classes.SpellThreshold
---@field public chaosNova TRB.Classes.SpellThreshold
---@field public eyeBeam TRB.Classes.SpellThreshold
---@field public glaiveTempest TRB.Classes.SpellThreshold
---@field public felBarrage TRB.Classes.SpellThreshold
TRB.Classes.DemonHunter.HavocSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DemonHunter.HavocSpells.__index = TRB.Classes.DemonHunter.HavocSpells

function TRB.Classes.DemonHunter.HavocSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.DemonHunter.HavocSpells) --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	--Demon Hunter Class Baseline Abilities
	self.immolationAura = TRB.Classes.SpellBase:New({
		id = 258920,
		resource = 20,
		cooldown = 30,
		isTalent = false,
		baseline = true
	})
	self.immolationAura1 = TRB.Classes.SpellBase:New({
		id = 427912,
	})
	self.immolationAura2 = TRB.Classes.SpellBase:New({
		id = 427913,
	})
	self.immolationAura3 = TRB.Classes.SpellBase:New({
		id = 427914,
	})
	self.immolationAura4 = TRB.Classes.SpellBase:New({
		id = 427915,
	})
	self.immolationAura5 = TRB.Classes.SpellBase:New({
		id = 427916,
	})
	self.immolationAura6 = TRB.Classes.SpellBase:New({
		id = 427917,
	})
	self.metamorphosis = TRB.Classes.SpellBase:New({
		id = 162264,
		castId = 200166,
		isTalent = false,
		baseline = true,
		duration = 20
	})
	self.demonic = TRB.Classes.SpellBase:New({
		id = 213410,
		isTalent = true,
		duration = 5
	})
	self.throwGlaive = TRB.Classes.SpellThreshold:New({
		id = 185123,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "throwGlaive",
		hasCooldown = true,
		hasCharges = true,
		isTalent = false,
		baseline = true
	})

	--Havoc Baseline Abilities
	self.bladeDance = TRB.Classes.SpellThreshold:New({
		id = 188499,
		primaryResourceType = Enum.PowerType.Fury,
		cooldown = 9,
		settingKey = "bladeDance",
		hasCooldown = true,
		demonForm = false,
		isTalent = false,
		baseline = true,
		isSnowflake = true,
		rangeCheck = false
	})
	self.chaosStrike = TRB.Classes.SpellThreshold:New({
		id = 162794,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "chaosStrike",
		hasCooldown = false,
		isSnowflake = true,
		demonForm = false,
		isTalent = false,
		baseline = true
	})
	self.annihilation = TRB.Classes.SpellThreshold:New({
		id = 201427,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "annihilation",
		hasCooldown = false,
		demonForm = true,
		isTalent = false,
		baseline = true
	})
	self.deathSweep = TRB.Classes.SpellThreshold:New({
		id = 210152,
		primaryResourceType = Enum.PowerType.Fury,
		cooldown = 9,
		settingKey = "deathSweep",
		hasCooldown = true,
		demonForm = true,
		isTalent = false,
		baseline = true,
		isSnowflake = true,
		rangeCheck = false
	})

	-- Demon Hunter Talent Abilities
	self.chaosNova = TRB.Classes.SpellThreshold:New({
		id = 179057,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "chaosNova",
		hasCooldown = true,
		isTalent = true,
		rangeCheck = false
	})

	-- Havoc Talent Abilities
	self.eyeBeam = TRB.Classes.SpellThreshold:New({
		id = 198013,
		primaryResourceType = Enum.PowerType.Fury,
		duration = 2,
		settingKey = "eyeBeam",
		hasCooldown = true,
		isTalent = true,
		rangeCheck = false
	})
	self.burningHatred = TRB.Classes.SpellBase:New({
		id = 258922,
		talentId = 320374,
		resourcePerTick = 4,
		tickRate = 1,
		hasTicks = true,
		duration = 12,
		isTalent = true
	})
	self.felfireHeart = TRB.Classes.SpellBase:New({ --TODO: figure out how this plays with Burning Hatred
		id = 388109,
		duration = 4, -- These don't match what's seen on the PTR, should be 2,
		ticks = 4, --2,
		isTalent = true
	})
	self.blindFury = TRB.Classes.SpellBase:New({
		id = 203550,
		tickRate = 0.1,
		resource = 3,
		isHasted = true,
		isTalent = true
	})
	self.glaiveTempest = TRB.Classes.SpellThreshold:New({
		id = 342817,
		primaryResourceType = Enum.PowerType.Fury,
		cooldown = 20,
		settingKey = "glaiveTempest",
		hasCooldown = true,
		isTalent = true,
		rangeCheck = false
	})
	self.unboundChaos = TRB.Classes.SpellBase:New({
		id = 347462,
		duration = 20
	})
	self.tacticalRetreat = TRB.Classes.SpellBase:New({
		id = 389890,
		resourcePerTick = 8,
		tickRate = 1,
		hasTicks = true,
		isTalent = true
	})
	self.chaosTheory = TRB.Classes.SpellBase:New({
		id = 390195
	})
	self.felBarrage = TRB.Classes.SpellThreshold:New({
		id = 258925,
		primaryResourceType = Enum.PowerType.Fury,
		cooldown = 90,
		settingKey = "felBarrage",
		hasCooldown = true,
		isTalent = true,
		rangeCheck = false
	})

	-- Aldrachi Reaver
	self.artOfTheGlaive = TRB.Classes.SpellBase:New({
		id = 444661,
		buffId = 444661,
		talentId = 442290,
		isTalent = true
	})
	self.glaiveFlurry = TRB.Classes.SpellBase:New({
		id = 442435
	})
	self.rendingStrike = TRB.Classes.SpellBase:New({
		id = 442442
	})
	self.warbladesHunger = TRB.Classes.SpellBase:New({
		id = 442503,
		talentId = 442502,
		isTalent = true,
		isBuff = true
	})

	-- Fel-Scarred
	self.studentOfSuffering = TRB.Classes.SpellBase:New({
		id = 453239,
		buffId = 453239,
		talentId = 452412,
		isTalent = true,
		resourcePerTick = 5,
		tickRate = 2,
		hasTicks = true
	})

	--PVP
	self.illidansGrasp = TRB.Classes.SpellBase:New({
		id = 205630,
		isPvp = true
	})

	return self
end


---@class TRB.Classes.DemonHunter.VengeanceSpells : TRB.Classes.SpecializationSpellsBase
--[[---@field public soulFragments TRB.Classes.SpellBase]]
---@field public immolationAura TRB.Classes.SpellBase
---@field public metamorphosis TRB.Classes.SpellBase
---@field public vengefulBeast TRB.Classes.SpellBase
---@field public soulFurnace TRB.Classes.SpellBase
---@field public artOfTheGlaive TRB.Classes.SpellBase
---@field public glaiveFlurry TRB.Classes.SpellBase
---@field public rendingStrike TRB.Classes.SpellBase
---@field public studentOfSuffering TRB.Classes.SpellBase
---@field public warbladesHunger TRB.Classes.SpellBase
---@field public soulCleave TRB.Classes.SpellThreshold
---@field public chaosNova TRB.Classes.SpellThreshold
---@field public felDevastation TRB.Classes.SpellThreshold
---@field public spiritBomb TRB.Classes.SpellThreshold
TRB.Classes.DemonHunter.VengeanceSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DemonHunter.VengeanceSpells.__index = TRB.Classes.DemonHunter.VengeanceSpells

function TRB.Classes.DemonHunter.VengeanceSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.DemonHunter.VengeanceSpells) --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]

	--Resource
	--[[self.soulFragments = TRB.Classes.SpellBase:New({
		id = 203981,
		attributes = {},
		maxResource = 5
	})]]

	--Demon Hunter Class Baseline Abilities
	self.immolationAura = TRB.Classes.SpellBase:New({
		id = 258920,
		resourcePerTick = 2,
		tickRate = 1,
		hasTicks = true,
		isTalent = false,
		baseline = true
	})
	self.metamorphosis = TRB.Classes.SpellBase:New({
		id = 187827,
		castId = 187827,
		isTalent = false,
		baseline = true,
		duration = 15
	})
	self.vengefulBeast = TRB.Classes.SpellBase:New({
		id = 1265818,
		isTalent = true,
		duration = 5
	})

	--Vengeance Baseline Abilities
	self.soulCleave = TRB.Classes.SpellThreshold:New({
		id = 228477,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "soulCleave",
		isTalent = false,
		baseline = true,
		isSnowflake = true,
		rangeCheck = false
	})

	-- Demon Hunter Talent Abilities
	self.chaosNova = TRB.Classes.SpellThreshold:New({
		id = 179057,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "chaosNova",
		hasCooldown = true,
		isTalent = true,
		rangeCheck = false
	})

	-- Vengeance Talent Abilities
	self.felDevastation = TRB.Classes.SpellThreshold:New({
		id = 212084,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "felDevastation",
		hasCooldown = true,
		isTalent = true,
		rangeCheck = false
	})
	self.spiritBomb = TRB.Classes.SpellComboPointThreshold:New({
		id = 247454,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "spiritBomb",
		comboPoints = true,
		isTalent = true,
		isSnowflake = true,
		rangeCheck = false
	})
	self.soulFurnace = TRB.Classes.SpellBase:New({
		id = 391172,
		isTalent = true
	})

	-- Aldrachi Reaver
	self.artOfTheGlaive = TRB.Classes.SpellBase:New({
		id = 444661,
		buffId = 444661,
		talentId = 442290,
		isTalent = true
	})
	self.glaiveFlurry = TRB.Classes.SpellBase:New({
		id = 442435
	})
	self.rendingStrike = TRB.Classes.SpellBase:New({
		id = 442442
	})
	self.warbladesHunger = TRB.Classes.SpellBase:New({
		id = 442503,
		talentId = 442502,
		isTalent = true,
		isBuff = true
	})

	-- Fel-Scarred
	self.studentOfSuffering = TRB.Classes.SpellBase:New({
		id = 453239,
		buffId = 453239,
		talentId = 452412,
		isTalent = true,
		resourcePerTick = 5,
		tickRate = 2,
		hasTicks = true
	})

	return self
end


---@class TRB.Classes.DemonHunter.DevourerSpells : TRB.Classes.SpecializationSpellsBase
---@field public metamorphosis TRB.Classes.SpellBase -- Void Metamorphosis but keeping it simple naming to re-use existing code
---@field public voidRay TRB.Classes.SpellThreshold
TRB.Classes.DemonHunter.DevourerSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DemonHunter.DevourerSpells.__index = TRB.Classes.DemonHunter.DevourerSpells

function TRB.Classes.DemonHunter.DevourerSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.DemonHunter.DevourerSpells) --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
	--Demon Hunter Class Baseline Abilities
	self.metamorphosis = TRB.Classes.SpellBase:New({
		id = 1217605,
		castId = 1217605,
		isTalent = false,
		baseline = true
	})
	self.voidRay = TRB.Classes.SpellThreshold:New({
		id = 473728,
		primaryResourceType = Enum.PowerType.Fury,
		settingKey = "voidRay",
		hasCooldown = true,
		isTalent = true,
		rangeCheck = false,
		isSnowflake = true,
		resource = 100
	})
	-- Really Void Metamorphosis but splittng out for tracking
	self.soulFragments = TRB.Classes.SpellBase:New({
		id = 1225789,
		maxResource = 50
	})
	self.collapsingStar = TRB.Classes.SpellBase:New({
		id = 1227702,--1221150
		maxResource = 40
	})

	return self
end


--[[
    BarGroups Factory for Demon Hunter
    Creates the appropriate BarGroup instances for each Demon Hunter specialization.
    
    Havoc (specId=1): Primary bar (N=1) only - no secondary resource
    Vengeance (specId=2): Primary bar (N=1) + Soul Fragments (N=1 with 5 threshold dividers, 0-6 discrete fragments via GetSpellCastCount)
    Devourer (specId=3): Primary bar (N=1) + Soul Fragments (N=1, percentage-based from Blizzard UI)
]]

---@class TRB.Classes.DemonHunter.BarGroupsFactory
TRB.Classes.DemonHunter.BarGroupsFactory = {}
TRB.Classes.DemonHunter.BarGroupsFactory.__index = TRB.Classes.DemonHunter.BarGroupsFactory

---Creates BarGroup instances for the specified Demon Hunter specialization
---@param specId integer # 1=Havoc, 2=Vengeance, 3=Devourer
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.DemonHunter.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- Primary bar groups are parented directly to UIParent for proper positioning
    -- Secondary bar groups are parented to the primary's container frame
    if specId == 1 then -- Havoc
        -- Primary fury bar only (no secondary resource)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 2 then -- Vengeance
        -- Primary fury bar
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Soul Fragments (single bar with 5 threshold dividers creating 6 segments)
        -- Uses C_Spell.GetSpellCastCount(spiritBomb.id) to get fragment count (0-5)
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            1,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 3 then -- Devourer
        -- Primary fury bar
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Soul Fragments (single percentage bar from Blizzard UI)
        -- Secondary bars are parented to UIParent for independent visibility
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            1,
            false -- not primary
        )

        -- Health bar (1 node)
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
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
function TRB.Classes.DemonHunter.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Havoc
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
    elseif specId == 2 then -- Vengeance
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            secondary = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "SoulFragments",
                thresholdCount = 5, -- 5 dividers create 6 segments (0-5 Soul Fragments)
                fillType = "discrete" -- Fills left-to-right based on fragment count
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 3 then -- Devourer
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            secondary = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "SoulFragments",
                fillType = "percentage" -- 0.0 to 1.0 based on Blizzard bar value
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