---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
if TRB.Data.character.classId ~= 10 then --Only do this if we're on a Monk!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Monk = TRB.Classes.Monk or {}


---@class TRB.Classes.Monk.BrewmasterSpells : TRB.Classes.SpecializationSpellsBase
--Baseline
---@field public cracklingJadeLightning TRB.Classes.SpellThreshold
---@field public expelHarm TRB.Classes.SpellThreshold
---@field public spinningCraneKick TRB.Classes.SpellThreshold
---@field public tigerPalm TRB.Classes.SpellThreshold
---@field public vivify TRB.Classes.SpellThreshold
--Class Talents
---@field public ancientArts TRB.Classes.SpellBase
---@field public detox TRB.Classes.SpellThreshold
---@field public disable TRB.Classes.SpellThreshold
---@field public paralysis TRB.Classes.SpellThreshold
---@field public soothingMist TRB.Classes.SpellThreshold
--Spec Talents
---@field public jadeFlash TRB.Classes.SpellBase
---@field public kegSmash TRB.Classes.SpellThreshold
TRB.Classes.Monk.BrewmasterSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Monk.BrewmasterSpells.__index = TRB.Classes.Monk.BrewmasterSpells

function TRB.Classes.Monk.BrewmasterSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Monk.BrewmasterSpells) --[[@as TRB.Classes.Monk.BrewmasterSpells]]

	-- Baseline Abilities
	self.cracklingJadeLightning = TRB.Classes.SpellThreshold:New({
		id = 117952,
		castId = 117952,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "cracklingJadeLightning",
		isTalent = false,
		baseline = true,
		hasCooldown = true
	})
	self.expelHarm = TRB.Classes.SpellComboPointThreshold:New({
		id = 322101,
		castId = 322101,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "expelHarm",
		hasCooldown = true,
		cooldown = 5,
		isTalent = false,
		baseline = true,
		rangeCheck = false
	})
	self.spinningCraneKick = TRB.Classes.SpellThreshold:New({
		id = 322729,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "spinningCraneKick",
		isTalent = false,
		baseline = true
	})
	self.tigerPalm = TRB.Classes.SpellComboPointThreshold:New({
		id = 100780,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "tigerPalm",
		isTalent = false,
		baseline = true,
		rangeCheck = false
	})
	self.vivify = TRB.Classes.SpellThreshold:New({
		id = 116670,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "vivify",
		isTalent = false,
		baseline = true,
		rangeCheck = false
	})

	-- Monk Class Talents
	self.detox = TRB.Classes.SpellThreshold:New({
		id = 218164,
		castId = 218164,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "detox",
		hasCooldown = true,
		cooldown = 8,
		isTalent = true,
		rangeCheck = false
	})
	self.disable = TRB.Classes.SpellThreshold:New({
		id = 116095,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "disable",
		hasCooldown = false,
		isTalent = true
	})
	self.paralysis = TRB.Classes.SpellThreshold:New({
		id = 115078,
		castId = 115078,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "paralysis",
		hasCooldown = true,
		cooldown = 45,
		isTalent = true,
	})
	self.ancientArts = TRB.Classes.SpellBase:New({
		id = 344359,
		cooldownMod = -15,
		isTalent = true,
	})
	self.soothingMist = TRB.Classes.SpellThreshold:New({
		id = 115175,
		primaryResourceType = Enum.PowerType.Energy,
		primaryResourceTypeProperty = "costPerSec",
		settingKey = "soothingMist",
		isTalent = true,
		rangeCheck = false
	})

	-- Brewmaster Spec Talents
	self.kegSmash = TRB.Classes.SpellThreshold:New({
		id = 121253,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "kegSmash",
		isTalent = true,
	})
	self.jadeFlash = TRB.Classes.SpellBase:New({
		id = 1262334,
		isTalent = true,
		cooldown = 60
	})

	return self
end


---@class TRB.Classes.Monk.MistweaverSpells : TRB.Classes.Healer.HealerSpells
---@field public risingSunKick TRB.Classes.SpellBase
---@field public soothingMist TRB.Classes.SpellBase
---@field public vivaciousVivification TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpent TRB.Classes.SpellBase
---@field public rushingWindKick TRB.Classes.SpellBase
TRB.Classes.Monk.MistweaverSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Monk.MistweaverSpells.__index = TRB.Classes.Monk.MistweaverSpells

function TRB.Classes.Monk.MistweaverSpells:New()
	---@type TRB.Classes.Healer.HealerSpells
	local base = TRB.Classes.Healer.HealerSpells
	self = setmetatable(base:New(), TRB.Classes.Monk.MistweaverSpells) --[[@as TRB.Classes.Monk.MistweaverSpells]]

	self.risingSunKick = TRB.Classes.SpellBase:New({
		id = 107428,
		baseline = true,
	})
	self.vivify = TRB.Classes.SpellBase:New({
		id = 116670,
		baseline = true,
	})

	-- Monk Class Talents		
	self.soothingMist = TRB.Classes.SpellBase:New({
		id = 115175,
		isTalent = true,
		primaryResourceType = Enum.PowerType.Mana,
		primaryResourceTypeProperty = "costPerSec"
	})
	self.vivaciousVivification = TRB.Classes.SpellBase:New({
		id = 392883,
		talentId = 388812,
		isTalent = true,
		duration = 20
	})

	-- Mistweaver Spec Talents
	self.rushingWindKick = TRB.Classes.SpellBase:New({
		id = 467307,
		isTalent = true,
	})

	-- Conduit of the Celestials
	self.heartOfTheJadeSerpent = TRB.Classes.SpellBase:New({
		id = 443421,
		talentId = 443294,
		isTalent = true,
	})

	return self
end


---@class TRB.Classes.Monk.WindwalkerSpells : TRB.Classes.SpecializationSpellsBase
---@field public ancientArts TRB.Classes.SpellBase
---@field public strikeOfTheWindlord TRB.Classes.SpellBase
---@field public danceOfChiJi TRB.Classes.SpellBase
---@field public combatWisdom TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpent TRB.Classes.SpellBase
---@field public blackoutKick TRB.Classes.SpellComboPoint
---@field public spinningCraneKick TRB.Classes.SpellComboPoint
---@field public risingSunKick TRB.Classes.SpellComboPoint
---@field public fistsOfFury TRB.Classes.SpellComboPoint
---@field public cracklingJadeLightning TRB.Classes.SpellThreshold
---@field public vivify TRB.Classes.SpellThreshold
---@field public detox TRB.Classes.SpellThreshold
---@field public disable TRB.Classes.SpellThreshold
---@field public paralysis TRB.Classes.SpellThreshold
---@field public soothingMist TRB.Classes.SpellThreshold
---@field public expelHarm TRB.Classes.SpellComboPointThreshold
---@field public tigerPalm TRB.Classes.SpellComboPointThreshold
TRB.Classes.Monk.WindwalkerSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Monk.WindwalkerSpells.__index = TRB.Classes.Monk.WindwalkerSpells

function TRB.Classes.Monk.WindwalkerSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.Monk.WindwalkerSpells) --[[@as TRB.Classes.Monk.WindwalkerSpells]]

	-- Monk Class Baseline Abilities
	self.blackoutKick = TRB.Classes.SpellComboPoint:New({
		id = 100784,
		comboPoints = 1,
		isTalent = false,
		baseline = true
	})
	self.cracklingJadeLightning = TRB.Classes.SpellThreshold:New({
		id = 117952,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "cracklingJadeLightning",
		isTalent = false,
		baseline = true
	})
	self.expelHarm = TRB.Classes.SpellComboPointThreshold:New({
		id = 322101,
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 1,
		settingKey = "expelHarm",
		hasCooldown = true,
		cooldown = 15,
		isTalent = false,
		baseline = true,
		isSnowflake = true,
		rangeCheck = false
	})
	self.spinningCraneKick = TRB.Classes.SpellComboPoint:New({
		id = 101546,
		comboPoints = 2,
		isTalent = false,
		baseline = true
	})
	self.tigerPalm = TRB.Classes.SpellComboPointThreshold:New({
		id = 100780,
		primaryResourceType = Enum.PowerType.Energy,
		comboPointsGenerated = 2,
		settingKey = "tigerPalm",
		isTalent = false,
		baseline = true
	})
	self.vivify = TRB.Classes.SpellThreshold:New({
		id = 116670,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "vivify",
		isTalent = false,
		baseline = true,
		rangeCheck = false
	})

	-- Windwalker Spec Baseline Abilities

	-- Monk Class Talents
	self.combatWisdom = TRB.Classes.SpellBase:New({
		id = 121817,
		isTalent = true
	})
	self.risingSunKick = TRB.Classes.SpellComboPoint:New({
		id = 107428,
		comboPoints = 2,
		isTalent = true,
		baseline = true
	})
	self.detox = TRB.Classes.SpellThreshold:New({
		id = 218164,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "detox",
		hasCooldown = true,
		cooldown = 8,
		isTalent = true,
	})
	self.disable = TRB.Classes.SpellThreshold:New({
		id = 116095,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "disable",
		hasCooldown = false,
		isTalent = true
	})
	self.paralysis = TRB.Classes.SpellThreshold:New({
		id = 115078,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "paralysis",
		hasCooldown = true,
		cooldown = 45,
		isTalent = true,
	})
	self.ancientArts = TRB.Classes.SpellBase:New({
		id = 344359,
		cooldownMod = -15,
		isTalent = true,
	})
	self.soothingMist = TRB.Classes.SpellThreshold:New({
		id = 115175,
		primaryResourceType = Enum.PowerType.Energy,
		primaryResourceTypeProperty = "costPerSec",
		settingKey = "soothingMist",
		isTalent = true,
		rangeCheck = false
	})

	-- Windwalker Spec Talent Abilities

	self.fistsOfFury = TRB.Classes.SpellComboPoint:New({
		id = 113656,
		comboPoints = 3,
		isTalent = true
	})

	-- Talents
	self.strikeOfTheWindlord = TRB.Classes.SpellBase:New({
		id = 392983,
		hasCooldown = true,
		isTalent = true,
		cooldown = 40
	})
	self.danceOfChiJi = TRB.Classes.SpellBase:New({
		id = 325202,
		isTalent = true
	})

	-- Conduit of the Celestials
	self.heartOfTheJadeSerpent = TRB.Classes.SpellBase:New({
		id = 443421,
		talentId = 443294,
		isTalent = true
	})

	return self
end


--[[
    BarGroups Factory for Monk
    Creates the appropriate BarGroup instances for each Monk specialization.
    
    Brewmaster: Primary bar (N=1) + Stagger bar (N=1 with thresholds)
    Mistweaver: Primary bar (N=1) only
    Windwalker: Primary bar (N=1) + Chi (N=5-6)
]]

---@class TRB.Classes.Monk.BarGroupsFactory
TRB.Classes.Monk.BarGroupsFactory = {}
TRB.Classes.Monk.BarGroupsFactory.__index = TRB.Classes.Monk.BarGroupsFactory

---Creates BarGroup instances for the specified Monk specialization
---@param specId integer # 1=Brewmaster, 2=Mistweaver, 3=Windwalker
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Monk.BarGroupsFactory:CreateForSpec(specId)
    local barGroups = {}

    if specId == 1 then -- Brewmaster
        -- Primary Energy bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Stagger bar (1 node with thresholds) - custom bar type
        barGroups.stagger = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Stagger",
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

    elseif specId == 2 then -- Mistweaver
        -- Primary Mana bar only (1 node)
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

    elseif specId == 3 then -- Windwalker
        -- Primary Energy bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Chi (5 nodes by default, can be 6 with talents)
        -- Secondary bars are parented to UIParent for independent visibility
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            5,
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
function TRB.Classes.Monk.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Brewmaster
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            stagger = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Stagger",
                isCustomBar = true
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 2 then -- Mistweaver
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
    elseif specId == 3 then -- Windwalker
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            secondary = {
                maxNodes = 5,
                isPrimary = false,
                resourceType = "Chi"
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