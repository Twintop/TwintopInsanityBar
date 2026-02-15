---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Shaman = TRB.Classes.Shaman or {}


---@class TRB.Classes.Shaman.OverloadSpell : TRB.Classes.SpellBase
---@field public overload number
TRB.Classes.Shaman.OverloadSpell = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.Shaman.OverloadSpell.__index = TRB.Classes.Shaman.OverloadSpell

---Creates a new OverloadSpell object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.Shaman.OverloadSpell
function TRB.Classes.Shaman.OverloadSpell:New(spellAttributes)
    ---@type TRB.Classes.SpellBase
    local base = TRB.Classes.SpellBase
    self = setmetatable(base:New(spellAttributes), {__index = TRB.Classes.Shaman.OverloadSpell})

    table.insert(self.classTypes, "TRB.Classes.Shaman.OverloadSpell")

    self.overload = 0

    for key, value in pairs(spellAttributes) do
        if  (key == "overload" and type(value) == "number") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end


---@class TRB.Classes.Shaman.ElementalSpells : TRB.Classes.SpecializationSpellsBase
---@field public frostShock TRB.Classes.SpellBase
---@field public hex TRB.Classes.SpellBase
---@field public inundate TRB.Classes.SpellBase
---@field public stormkeeper TRB.Classes.SpellBase
---@field public echoesOfGreatSundering TRB.Classes.SpellBase
---@field public ascendance TRB.Classes.SpellBase
---@field public preeminence TRB.Classes.SpellBase
---@field public lightningBolt TRB.Classes.Shaman.OverloadSpell
---@field public lavaBurst TRB.Classes.Shaman.OverloadSpell
---@field public chainLightning TRB.Classes.Shaman.OverloadSpell
---@field public icefury TRB.Classes.Shaman.OverloadSpell
---@field public earthShock TRB.Classes.SpellThreshold
---@field public earthquake TRB.Classes.SpellThreshold
---@field public earthquakeTargeted TRB.Classes.SpellThreshold
---@field public elementalBlast TRB.Classes.SpellThreshold
TRB.Classes.Shaman.ElementalSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Shaman.ElementalSpells.__index = TRB.Classes.Shaman.ElementalSpells

function TRB.Classes.Shaman.ElementalSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Shaman.ElementalSpells) --[[@as TRB.Classes.Shaman.ElementalSpells]]

    -- Shaman Class Baseline Abilities
    self.lightningBolt = TRB.Classes.Shaman.OverloadSpell:New({
        id = 188196,
        resource = 6,
        overload = 2,
        baseline = true
    })

    -- Elemental Baseline Abilities
    self.inundate = TRB.Classes.SpellBase:New({
        id = 378776,
        resource = 8,
        baseline = true
    })


    -- Shaman Class Talent Abilities
    self.lavaBurst = TRB.Classes.Shaman.OverloadSpell:New({
        id = 51505,
        resource = 8,
        overload = 3,
        isTalent = true,
        baseline = true
    })
    self.chainLightning = TRB.Classes.Shaman.OverloadSpell:New({
        id = 188443,
        resource = 2,
        overload = 1,
        isTalent = true,
        baseline = true
    })
    self.frostShock = TRB.Classes.SpellBase:New({
        id = 196840,
        resource = 10,
        isTalent = true
    })
    self.hex = TRB.Classes.SpellBase:New({
        id = 51514,
        resource = 8,
        isTalent = true
    })


    -- Elemental Talent Abilities
    self.earthShock = TRB.Classes.SpellThreshold:New({
        id = 8042,
        primaryResourceType = Enum.PowerType.Maelstrom,
        settingKey = "earthShock",
        isTalent = true
    })
    self.earthquake = TRB.Classes.SpellThreshold:New({
        id = 61882,
        primaryResourceType = Enum.PowerType.Maelstrom,
        settingKey = "earthquake",
        isTalent = true,
        isSnowflake = true,
		rangeCheck = false
    })
    self.earthquakeTargeted = TRB.Classes.SpellThreshold:New({
        id = 462620,
        primaryResourceType = Enum.PowerType.Maelstrom,
        settingKey = "earthquakeTargeted",
        isTalent = true,
        isSnowflake = true
    })
    self.icefury = TRB.Classes.Shaman.OverloadSpell:New({
        id = 462818,
        resource = 10,
        isTalent = true
    })
    self.stormkeeper = TRB.Classes.SpellBase:New({
        id = 191634,
        stacks = 2,
        duration = 15
    })
    self.powerOfTheMaelstrom = TRB.Classes.SpellBase:New({
        id = 191877,
        isTalent = true
    })
    self.elementalBlast = TRB.Classes.SpellThreshold:New({
        id = 117014,
        primaryResourceType = Enum.PowerType.Maelstrom,
        settingKey = "elementalBlast",
        isTalent = true
    })
    self.echoesOfGreatSundering = TRB.Classes.SpellBase:New({
        id = 384088,
        isTalent = true
    })
    self.ascendance = TRB.Classes.SpellBase:New({
        id = 114050,
        castId = 114050,
        isTalent = true,
        duration = 15
    })
    self.preeminence = TRB.Classes.SpellBase:New({
        id = 462443,
        isTalent = true,
        duration = 3
    })

    return self
end

---Fills barTextVariables for Elemental Shaman options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Shaman.ElementalSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Shaman.ElementalSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Shaman.ElementalSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
		{ variable = "#chainLightning", icon = spells.chainLightning.icon, description = spells.chainLightning.name, printInSettings = true },
		{ variable = "#elementalBlast", icon = spells.elementalBlast.icon, description = spells.elementalBlast.name, printInSettings = true },
		{ variable = "#earthShock", icon = spells.earthShock.icon, description = spells.earthShock.name, printInSettings = true },
		{ variable = "#earthquake", icon = spells.earthquake.icon, description = spells.earthquake.name, printInSettings = true },
		{ variable = "#eogs", icon = spells.echoesOfGreatSundering.icon, description = spells.echoesOfGreatSundering.name, printInSettings = true },
		{ variable = "#frostShock", icon = spells.frostShock.icon, description = spells.frostShock.name, printInSettings = true },
		{ variable = "#icefury", icon = spells.icefury.icon, description = spells.icefury.name, printInSettings = true },
		{ variable = "#lavaBurst", icon = spells.lavaBurst.icon, description = spells.lavaBurst.name, printInSettings = true },
		{ variable = "#lightningBolt", icon = spells.lightningBolt.icon, description = spells.lightningBolt.name, printInSettings = true },
		{ variable = "#stormkeeper", icon = spells.stormkeeper.icon, description = spells.stormkeeper.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$maelstrom", description = L["ShamanElementalBarTextVariable_maelstrom"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromMax", description = L["ShamanElementalBarTextVariable_maelstromMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["ShamanElementalBarTextVariable_casting"], printInSettings = true, color = false },

		{ variable = "$mana", description = L["PriestHolyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$manaPercent", description = L["PriestHolyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["PriestHolyBarTextVariable_manaMax"], printInSettings = true, color = false },

		--[[{ variable = "$ifStacks", description = L["ShamanElementalBarTextVariable_ifStacks"], printInSettings = true, color = false },
		{ variable = "$ifMaelstrom", description = L["ShamanElementalBarTextVariable_ifMaelstrom"], printInSettings = true, color = false },
		{ variable = "$ifTime", description = L["ShamanElementalBarTextVariable_ifTime"], printInSettings = true, color = false },

		{ variable = "$skStacks", description = L["ShamanElementalBarTextVariable_skStacks"], printInSettings = true, color = false },
		{ variable = "$skTime", description = L["ShamanElementalBarTextVariable_skTime"], printInSettings = true, color = false },]]

		{ variable = "$ascendanceTime", description = L["ShamanElementalBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		{ variable = "$earthShockUsable", description = L["ShamanElementalBarTextVariable_earthShockUsable"], printInSettings = true, color = false },
		{ variable = "$elementalBlastUsable", description = L["ShamanElementalBarTextVariable_elementalBlastUsable"], printInSettings = true, color = false },
		{ variable = "$earthquakeUsable", description = L["ShamanElementalBarTextVariable_earthquakeUsable"], printInSettings = true, color = false },

		--[[{ variable = "$eogsTime", description = L["ShamanElementalBarTextVariable_eogsTime"], printInSettings = true, color = false },

		{ variable = "$pfTime", description = L["ShamanElementalBarTextVariable_pfTime"], printInSettings = true, color = false }]]
	})
end


---@class TRB.Classes.Shaman.EnhancementSpells : TRB.Classes.SpecializationSpellsBase
---@field public maelstromWeapon TRB.Classes.SpellBase
---@field public doomWinds TRB.Classes.SpellBase
---@field public ascendance TRB.Classes.SpellBase
TRB.Classes.Shaman.EnhancementSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Shaman.EnhancementSpells.__index = TRB.Classes.Shaman.EnhancementSpells

function TRB.Classes.Shaman.EnhancementSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Shaman.EnhancementSpells) --[[@as TRB.Classes.Shaman.EnhancementSpells]]

    self.maelstromWeapon = TRB.Classes.SpellBase:New({
        id = 344179,
        maxStacks = 10,
        duration = 30
    })
    self.doomWinds = TRB.Classes.SpellBase:New({
        id = 384352,
        castId = 384352,
        isTalent = true,
        duration = 10
    })
    self.ascendance = TRB.Classes.SpellBase:New({
        id = 114051,
        castId = 114051,
        isTalent = true,
        duration = 15
    })

    return self
end

---Fills barTextVariables for Enhancement Shaman options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Shaman.EnhancementSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Shaman.EnhancementSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Shaman.EnhancementSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["ShamanEnhancementBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["ShamanEnhancementBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["ShamanEnhancementBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$maelstromWeapon", description = L["ShamanEnhancementBarTextVariable_maelstromWeapon"], printInSettings = true, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$maelstromWeaponMax", description = L["ShamanEnhancementBarTextVariable_maelstromWeaponMax"], printInSettings = true, color = false },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },

		{ variable = "$ascendanceTime", description = L["ShamanEnhancementBarTextVariable_ascendanceTime"], printInSettings = true, color = false },
	})
end


---@class TRB.Classes.Shaman.RestorationSpells : TRB.Classes.Healer.HealerSpells
---@field public ascendance TRB.Classes.SpellBase
---@field public preeminence TRB.Classes.SpellBase
TRB.Classes.Shaman.RestorationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Shaman.RestorationSpells.__index = TRB.Classes.Shaman.RestorationSpells

function TRB.Classes.Shaman.RestorationSpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Shaman.RestorationSpells) --[[@as TRB.Classes.Shaman.RestorationSpells]]

    self.ascendance = TRB.Classes.SpellBase:New({
        id = 114052,
        castId = 114052,
        isTalent = true,
        duration = 15
    })
    self.preeminence = TRB.Classes.SpellBase:New({
        id = 462443,
        isTalent = true,
        duration = 3
    })

    return self
end

---Fills barTextVariables for Restoration Shaman options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Shaman.RestorationSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Shaman.RestorationSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Shaman.RestorationSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["ShamanRestorationBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["ShamanRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["ShamanRestorationBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["ShamanRestorationBarTextVariable_casting"], printInSettings = true, color = false },
		
		{ variable = "$ascendanceTime", description = L["ShamanRestorationBarTextVariable_ascendanceTime"], printInSettings = true, color = false },
	})
end


--[[
    BarGroups Factory for Shaman
    Creates the appropriate BarGroup instances for each Shaman specialization.
    
    Elemental: Primary bar (N=1) only
    Enhancement: Primary bar (N=1) + Maelstrom Weapon (N=10)
    Restoration: Primary bar (N=1) only
]]

---@class TRB.Classes.Shaman.BarGroupsFactory
TRB.Classes.Shaman.BarGroupsFactory = {}
TRB.Classes.Shaman.BarGroupsFactory.__index = TRB.Classes.Shaman.BarGroupsFactory

---Creates BarGroup instances for the specified Shaman specialization
---@param specId integer # 1=Elemental, 2=Enhancement, 3=Restoration
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Shaman.BarGroupsFactory:CreateForSpec(specId)
    local barGroups = {}

    if specId == 1 then -- Elemental
        -- Primary Maelstrom bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Health bar
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

        -- Mana bar (1 node) - optional secondary mana display for Elemental
        barGroups.mana = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Mana",
            1,
            false -- not primary
        )

    elseif specId == 2 then -- Enhancement
        -- Primary mana bar (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Maelstrom Weapon stacks (10 nodes)
        -- Secondary bars are parented to UIParent for independent visibility
        barGroups.secondary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ComboPoint",
            10,
            false -- not primary
        )

        -- Health bar
        barGroups.health = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_Health",
            1,
            false -- not primary
        )

    elseif specId == 3 then -- Restoration
        -- Primary mana bar only (1 node)
        barGroups.primary = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame",
            1,
            true -- isPrimary
        )

        -- Health bar
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
function TRB.Classes.Shaman.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Elemental
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
    elseif specId == 2 then -- Enhancement
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true
            },
            secondary = {
                maxNodes = 10,
                isPrimary = false,
                resourceType = "MaelstromWeapon"
            },
            health = {
                maxNodes = 1,
                isPrimary = false,
                resourceType = "Health"
            }
        }
    elseif specId == 3 then -- Restoration
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

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["shaman_elemental"] = TRB.Classes.Shaman.ElementalSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["shaman_enhancement"] = TRB.Classes.Shaman.EnhancementSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["shaman_restoration"] = TRB.Classes.Shaman.RestorationSpells.FillBarTextVariables