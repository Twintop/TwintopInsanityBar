---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
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
---@field public invokeNiuzao TRB.Classes.SpellBase
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
		hasCooldown = true,
		category = "offensive"
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
		rangeCheck = false,
		category = "defensive"
	})
	self.spinningCraneKick = TRB.Classes.SpellThreshold:New({
		id = 322729,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "spinningCraneKick",
		isTalent = false,
		baseline = true,
		category = "offensive"
	})
	self.tigerPalm = TRB.Classes.SpellComboPointThreshold:New({
		id = 100780,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "tigerPalm",
		isTalent = false,
		baseline = true,
		rangeCheck = false,
		category = "offensive"
	})
	self.vivify = TRB.Classes.SpellThreshold:New({
		id = 116670,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "vivify",
		isTalent = false,
		baseline = true,
		rangeCheck = false,
		category = "utility"
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
		rangeCheck = false,
		category = "utility"
	})
	self.disable = TRB.Classes.SpellThreshold:New({
		id = 116095,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "disable",
		hasCooldown = false,
		isTalent = true,
		category = "utility"
	})
	self.paralysis = TRB.Classes.SpellThreshold:New({
		id = 115078,
		castId = 115078,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "paralysis",
		hasCooldown = true,
		cooldown = 45,
		isTalent = true,
		category = "utility"
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
		rangeCheck = false,
		category = "utility"
	})

	-- Brewmaster Spec Talents
	self.invokeNiuzao = TRB.Classes.SpellBase:New({
		id = 132578,
		isTalent = true,
		hasCooldown = true,
		cooldown = 180,
		duration = 25
	})
	self.kegSmash = TRB.Classes.SpellThreshold:New({
		id = 121253,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "kegSmash",
		isTalent = true,
		category = "offensive"
	})
	self.jadeFlash = TRB.Classes.SpellBase:New({
		id = 1262334,
		isTalent = true,
		cooldown = 60
	})

	return self
end

---Fills barTextVariables for Brewmaster Monk options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Monk.BrewmasterSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Monk.BrewmasterSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Monk.BrewmasterSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#niuzao", icon = spells.invokeNiuzao.icon, description = L["MonkBrewmasterBarTextIcon_niuzao"], printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$energy", description = L["MonkBrewmasterBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["MonkBrewmasterBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MonkBrewmasterBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$stagger", description = L["MonkBrewmasterBarTextVariable_stagger"], printInSettings = true, color = false, secret = true },
		{ variable = "$staggerPercent", description = L["MonkBrewmasterBarTextVariable_staggerPercent"], printInSettings = true, color = false, secret = true },

		{ variable = "$niuzaoTime", description = L["MonkBrewmasterBarTextVariable_niuzaoTime"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Brewmaster, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Monk.BrewmasterSpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Monk.MistweaverSpells : TRB.Classes.Healer.HealerSpells
---@field public risingSunKick TRB.Classes.SpellBase
---@field public soothingMist TRB.Classes.SpellBase
---@field public vivaciousVivification TRB.Classes.SpellBase
---@field public sereneSurge TRB.Classes.SpellBase
---@field public envelopingMist TRB.Classes.SpellBase
---@field public vivify TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpent TRB.Classes.SpellBase
---@field public rushingWindKick TRB.Classes.SpellBase
---@field public sheilunsGift TRB.Classes.SpellBase
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
	self.sereneSurge = TRB.Classes.SpellBase:New({
		id = 1266735,
		talentId = 1266734,
		isTalent = true,
		duration = 20
	})

	-- Mistweaver Spec Talents
	self.envelopingMist = TRB.Classes.SpellBase:New({
		id = 124682,
		isTalent = true,
	})
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

	self.sheilunsGift = TRB.Classes.SpellBase:New({
		id = 399491,
		isTalent = true,
	})

	return self
end

---Fills barTextVariables for Mistweaver Monk options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Monk.MistweaverSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Monk.MistweaverSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Monk.MistweaverSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#hotjs", icon = spells.heartOfTheJadeSerpent.icon, description = spells.heartOfTheJadeSerpent.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["MonkMistweaverBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["MonkMistweaverBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["MonkMistweaverBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MonkMistweaverBarTextVariable_casting"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Mistweaver, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Monk.MistweaverSpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.Monk.WindwalkerSpells : TRB.Classes.SpecializationSpellsBase
---@field public ancientArts TRB.Classes.SpellBase
---@field public strikeOfTheWindlord TRB.Classes.SpellBase
---@field public danceOfChiJi TRB.Classes.SpellBase
---@field public combatWisdom TRB.Classes.SpellBase
---@field public heartOfTheJadeSerpent TRB.Classes.SpellBase
---@field public communionWithWind TRB.Classes.SpellBase
---@field public whirlingDragonPunch TRB.Classes.SpellBase
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
		baseline = true,
		category = "offensive"
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
		rangeCheck = false,
		category = "defensive"
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
		baseline = true,
		category = "offensive"
	})
	self.vivify = TRB.Classes.SpellThreshold:New({
		id = 116670,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "vivify",
		isTalent = false,
		baseline = true,
		rangeCheck = false,
		category = "utility"
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
		category = "utility"
	})
	self.disable = TRB.Classes.SpellThreshold:New({
		id = 116095,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "disable",
		hasCooldown = false,
		isTalent = true,
		category = "utility"
	})
	self.paralysis = TRB.Classes.SpellThreshold:New({
		id = 115078,
		primaryResourceType = Enum.PowerType.Energy,
		settingKey = "paralysis",
		hasCooldown = true,
		cooldown = 45,
		isTalent = true,
		category = "utility"
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
		rangeCheck = false,
		category = "utility"
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
		cooldown = 30 -- Tooltip lies and says it is 35 as of 2026-03-02
	})
	self.whirlingDragonPunch = TRB.Classes.SpellBase:New({
		id = 152175,
		hasCooldown = true,
		isTalent = true,
		cooldown = 30 -- Tooltip lies and says it is 35 as of 2026-03-02
	})
	self.communionWithWind = TRB.Classes.SpellBase:New({
		id = 451576,
		isTalent = true,
		cooldownMod = -5
	})
	self.danceOfChiJi = TRB.Classes.SpellBase:New({
		id = 322729,
		talentId = 325201,
		isTalent = true
	})

	-- Conduit of the Celestials
	self.heartOfTheJadeSerpent = TRB.Classes.SpellBase:New({
		id = 443421,
		talentId = 443294,
		isTalent = true,
		duration = 6
	})

	return self
end

---Fills barTextVariables for Windwalker Monk options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Monk.WindwalkerSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Monk.WindwalkerSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Monk.WindwalkerSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#blackoutKick", icon = spells.blackoutKick.icon, description = spells.blackoutKick.name, printInSettings = true },
		{ variable = "#cracklingJadeLightning", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = true },
		{ variable = "#cjl", icon = spells.cracklingJadeLightning.icon, description = spells.cracklingJadeLightning.name, printInSettings = false },
		{ variable = "#danceOfChiJi", icon = spells.danceOfChiJi.icon, description = spells.danceOfChiJi.name, printInSettings = true },
		{ variable = "#detox", icon = spells.detox.icon, description = spells.detox.name, printInSettings = true },
		{ variable = "#disable", icon = spells.disable.icon, description = spells.disable.name, printInSettings = true },
		{ variable = "#expelHarm", icon = spells.expelHarm.icon, description = spells.expelHarm.name, printInSettings = true },
		{ variable = "#fistsOfFury", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = true },
		{ variable = "#fof", icon = spells.fistsOfFury.icon, description = spells.fistsOfFury.name, printInSettings = false },
		{ variable = "#hotjs", icon = spells.heartOfTheJadeSerpent.icon, description = spells.heartOfTheJadeSerpent.name, printInSettings = true },
		{ variable = "#paralysis", icon = spells.paralysis.icon, description = spells.paralysis.name, printInSettings = true },
		{ variable = "#risingSunKick", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = true },
		{ variable = "#rsk", icon = spells.risingSunKick.icon, description = spells.risingSunKick.name, printInSettings = false },
		{ variable = "#spinningCraneKick", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = true },
		{ variable = "#sck", icon = spells.spinningCraneKick.icon, description = spells.spinningCraneKick.name, printInSettings = false },
		{ variable = "#strikeOfTheWindlord", icon = spells.strikeOfTheWindlord.icon, description = spells.strikeOfTheWindlord.name, printInSettings = true },
		{ variable = "#tigerPalm", icon = spells.tigerPalm.icon, description = spells.tigerPalm.name, printInSettings = true },
		{ variable = "#vivify", icon = spells.vivify.icon, description = spells.vivify.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$energy", description = L["MonkWindwalkerBarTextVariable_energy"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$energyMax", description = L["MonkWindwalkerBarTextVariable_energyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["MonkWindwalkerBarTextVariable_casting"], printInSettings = false, color = false },
		
		{ variable = "$chi", description = L["MonkWindwalkerBarTextVariable_chi"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$chiMax", description = L["MonkWindwalkerBarTextVariable_chiMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Windwalker, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Monk.WindwalkerSpells.GetCastbarTickProfiles()
	return {
		-- Spinning Crane Kick
		[101546] = { mode = "fixedCount", baseDuration = 1.5, tickCount = 4, firstTickAtStart = false },
		-- Crackling Jade Lightning
		[117952] = { mode = "fixedCount", baseDuration = 4, tickCount = 5, firstTickAtStart = true, chains = true },
	}
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
                isPrimary = true,
                resourceType = "Energy"
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
                isPrimary = true,
                resourceType = "Mana"
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
                isPrimary = true,
                resourceType = "Energy"
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

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["monk_brewmaster"] = TRB.Classes.Monk.BrewmasterSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["monk_mistweaver"] = TRB.Classes.Monk.MistweaverSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["monk_windwalker"] = TRB.Classes.Monk.WindwalkerSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["monk_brewmaster"] = TRB.Classes.Monk.BrewmasterSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["monk_mistweaver"] = TRB.Classes.Monk.MistweaverSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["monk_windwalker"] = TRB.Classes.Monk.WindwalkerSpells.GetCastbarTickProfiles