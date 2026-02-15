local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.DemonHunter = TRB.Classes.DemonHunter or {}


---@class TRB.Classes.DemonHunter.HavocSpells : TRB.Classes.SpecializationSpellsBase
---@field public demonic TRB.Classes.SpellBase
---@field public metamorphosis TRB.Classes.SpellBase
---@field public blindFury TRB.Classes.SpellBase
---@field public throwGlaive TRB.Classes.SpellThreshold
---@field public bladeDance TRB.Classes.SpellThreshold
---@field public chaosStrike TRB.Classes.SpellThreshold
---@field public annihilation TRB.Classes.SpellThreshold
---@field public deathSweep TRB.Classes.SpellThreshold
---@field public chaosNova TRB.Classes.SpellThreshold
---@field public eyeBeam TRB.Classes.SpellThreshold
TRB.Classes.DemonHunter.HavocSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DemonHunter.HavocSpells.__index = TRB.Classes.DemonHunter.HavocSpells

function TRB.Classes.DemonHunter.HavocSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.DemonHunter.HavocSpells) --[[@as TRB.Classes.DemonHunter.HavocSpells]]
	--Demon Hunter Class Baseline Abilities	
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
	self.blindFury = TRB.Classes.SpellBase:New({
		id = 203550,
		tickRate = 0.1,
		resource = 3,
		isHasted = true,
		isTalent = true
	})

	return self
end

---Fills barTextVariables for Havoc Demon Hunter options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DemonHunter.HavocSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DemonHunter.HavocSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DemonHunter.HavocSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#annihilation", icon = spells.annihilation.icon, description = spells.annihilation.name, printInSettings = true },
		{ variable = "#bladeDance", icon = spells.bladeDance.icon, description = spells.bladeDance.name, printInSettings = true },
		{ variable = "#blindFury", icon = spells.blindFury.icon, description = spells.blindFury.name, printInSettings = true },
		{ variable = "#chaosNova", icon = spells.chaosNova.icon, description = spells.chaosNova.name, printInSettings = true },
		{ variable = "#chaosStrike", icon = spells.chaosStrike.icon, description = spells.chaosStrike.name, printInSettings = true },
		{ variable = "#deathSweep", icon = spells.deathSweep.icon, description = spells.deathSweep.name, printInSettings = true },
		{ variable = "#eyeBeam", icon = spells.eyeBeam.icon, description = spells.eyeBeam.name, printInSettings = true },
		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$fury", description = L["DemonHunterHavocBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterHavocBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterHavocBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$metaTime", description = L["DemonHunterHavocBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
	})
end


---@class TRB.Classes.DemonHunter.VengeanceSpells : TRB.Classes.SpecializationSpellsBase
---@field public soulFragments TRB.Classes.SpellBase
---@field public metamorphosis TRB.Classes.SpellBase
---@field public vengefulBeast TRB.Classes.SpellBase
---@field public artOfTheGlaive TRB.Classes.SpellBase
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
	self.soulFragments = TRB.Classes.SpellBase:New({
		id = 203981,
		attributes = {},
		maxResource = 6
	})

	--Demon Hunter Class Baseline Abilities
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

	-- Aldrachi Reaver
	self.artOfTheGlaive = TRB.Classes.SpellBase:New({
		id = 442290,
		buffId = 444661,
		isTalent = true,
		duration = 30,
		maxStacks = 20
	})

	return self
end

---Fills barTextVariables for Vengeance Demon Hunter options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DemonHunter.VengeanceSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DemonHunter.VengeanceSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DemonHunter.VengeanceSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#soulFragments", icon = spells.soulFragments.icon, description = spells.soulFragments.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$fury", description = L["DemonHunterVengeanceBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterVengeanceBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterVengeanceBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$soulFragments", description = L["DemonHunterVengeanceBarTextVariable_soulFragments"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulFragmentsMax", description = L["DemonHunterVengeanceBarTextVariable_soulFragmentsMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$metaTime", description = L["DemonHunterVengeanceBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
	})
end


---@class TRB.Classes.DemonHunter.DevourerSpells : TRB.Classes.SpecializationSpellsBase
---@field public metamorphosis TRB.Classes.SpellBase -- Void Metamorphosis but keeping it simple naming to re-use existing code
---@field public voidRay TRB.Classes.SpellThreshold
---@field public soulFragments TRB.Classes.SpellBase
---@field public soulGlutton TRB.Classes.SpellBase
---@field public collapsingStar TRB.Classes.SpellBase
---@field public collapsingStarThreshold TRB.Classes.SpellThreshold
---@field public surrenderToTheVoid TRB.Classes.SpellBase
TRB.Classes.DemonHunter.DevourerSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DemonHunter.DevourerSpells.__index = TRB.Classes.DemonHunter.DevourerSpells

function TRB.Classes.DemonHunter.DevourerSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), TRB.Classes.DemonHunter.DevourerSpells) --[[@as TRB.Classes.DemonHunter.DevourerSpells]]
	--Demon Hunter Class Baseline Abilities
	self.metamorphosis = TRB.Classes.SpellBase:New({
		id = 1217607,
		castId = 1217605,
		isTalent = true,
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
	-- Really Void Metamorphosis but splitting out for tracking
	--self.voidMetamorphosis = TRB.Classes.SpellBase:New({
	--	id = 1217607,
	--	isTalent = true
	--})
	self.soulFragments = TRB.Classes.SpellBase:New({
		id = 1225789,
		maxResource = 50
	})
	self.soulGlutton = TRB.Classes.SpellBase:New({
		id = 1247534,
		isTalent = true,
		maxResourceMod = -15
	})
	self.collapsingStar = TRB.Classes.SpellBase:New({
		id = 1227702,
		talentId = 1221167,
		isTalent = true,
		maxResource = 40,
	})
	self.collapsingStarThreshold = TRB.Classes.SpellThreshold:New({
		id = 1227750,
		buffId = 1227702,
		talentId = 1221167,
		settingKey = "collapsingStarThreshold",
		hasCooldown = false,
		isTalent = true,
		rangeCheck = false,
		resource = 30
	})

	--PvP
	self.surrenderToTheVoid = TRB.Classes.SpellBase:New({
		id = 1261423,
		isTalent = true,
		isPvp = true,
		maxResourceMod = 50
	})

	return self
end

---Fills barTextVariables for Devourer Demon Hunter options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DemonHunter.DevourerSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DemonHunter.DevourerSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DemonHunter.DevourerSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#collapsingStar", icon = spells.collapsingStar.icon, description = spells.collapsingStar.name, printInSettings = true },
		{ variable = "#metamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = true },
		{ variable = "#meta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMetamorphosis", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidMeta", icon = spells.metamorphosis.icon, description = spells.metamorphosis.name, printInSettings = false },
		{ variable = "#voidRay", icon = spells.voidRay.icon, description = spells.voidRay.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$fury", description = L["DemonHunterHavocBarTextVariable_fury"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$furyMax", description = L["DemonHunterHavocBarTextVariable_furyMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["DemonHunterHavocBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$soulFragments", description = L["DemonHunterDevourerBarTextVariable_soulFragments"], printInSettings = true, color = false },
		{ variable = "$collapsingStar", description = "", printInSettings = false, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulFragmentsMax", description = L["DemonHunterDevourerBarTextVariable_soulFragmentsMax"], printInSettings = true, color = false },
		{ variable = "$collapsingStarMax", description = "", printInSettings = false, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$metaTime", description = L["DemonHunterDevourerBarTextVariable_metaTime"], printInSettings = true, color = false },
		{ variable = "$metamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetaTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidMetamorphosisTime", description = "", printInSettings = false, color = false },
		{ variable = "$voidRayUsable", description = L["DemonHunterDevourerBarTextVariable_voidRayUsable"], printInSettings = true, color = false },
		{ variable = "$collapsingStarUsable", description = L["DemonHunterDevourerBarTextVariable_collapsingStarUsable"], printInSettings = true, color = false },
	})
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

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["demonhunter_havoc"] = TRB.Classes.DemonHunter.HavocSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["demonhunter_vengeance"] = TRB.Classes.DemonHunter.VengeanceSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["demonhunter_devourer"] = TRB.Classes.DemonHunter.DevourerSpells.FillBarTextVariables