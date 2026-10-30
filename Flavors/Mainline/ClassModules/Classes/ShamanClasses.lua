local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Mainline.Shaman = TRB.Classes.Mainline.Shaman or {}


---@class TRB.Classes.Mainline.Shaman.OverloadSpell : TRB.Classes.SpellBase
---@field public overload number
TRB.Classes.Mainline.Shaman.OverloadSpell = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.Mainline.Shaman.OverloadSpell.__index = TRB.Classes.Mainline.Shaman.OverloadSpell

---Creates a new OverloadSpell object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.Mainline.Shaman.OverloadSpell
function TRB.Classes.Mainline.Shaman.OverloadSpell:New(spellAttributes)
    ---@type TRB.Classes.SpellBase
    local base = TRB.Classes.SpellBase
    self = setmetatable(base:New(spellAttributes), {__index = TRB.Classes.Mainline.Shaman.OverloadSpell})

    table.insert(self.classTypes, "TRB.Classes.Mainline.Shaman.OverloadSpell")

    self.overload = 0

    for key, value in pairs(spellAttributes) do
        if  (key == "overload" and type(value) == "number") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end


---@class TRB.Classes.Mainline.Shaman.ElementalSpells : TRB.Classes.SpecializationSpellsBase
---@field public frostShock TRB.Classes.SpellBase
---@field public hex TRB.Classes.SpellBase
---@field public inundate TRB.Classes.SpellBase
---@field public stormkeeper TRB.Classes.SpellBase
---@field public stormwell TRB.Classes.SpellBase
---@field public echoesOfGreatSundering TRB.Classes.SpellBase
---@field public ascendance TRB.Classes.SpellBase
---@field public preeminence TRB.Classes.SpellBase
---@field public tempest TRB.Classes.SpellBase
---@field public arcDischarge TRB.Classes.SpellBase
---@field public midnightSeason1SetBonus TRB.Classes.SpellBase
---@field public midnightSeason1SetKey string # Key the set's pieces are registered under in TRB.Data.itemSetRegistry
---@field public lightningBolt TRB.Classes.Mainline.Shaman.OverloadSpell
---@field public lavaBurst TRB.Classes.Mainline.Shaman.OverloadSpell
---@field public chainLightning TRB.Classes.Mainline.Shaman.OverloadSpell
---@field public icefury TRB.Classes.Mainline.Shaman.OverloadSpell
---@field public earthShock TRB.Classes.SpellThreshold
---@field public earthquake TRB.Classes.SpellThreshold
---@field public earthquakeTargeted TRB.Classes.SpellThreshold
---@field public elementalBlast TRB.Classes.SpellThreshold
---@field public elementalBlastCriticalStrike TRB.Classes.SpellBase
---@field public elementalBlastHaste TRB.Classes.SpellBase
---@field public elementalBlastMastery TRB.Classes.SpellBase
TRB.Classes.Mainline.Shaman.ElementalSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mainline.Shaman.ElementalSpells.__index = TRB.Classes.Mainline.Shaman.ElementalSpells

function TRB.Classes.Mainline.Shaman.ElementalSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mainline.Shaman.ElementalSpells) --[[@as TRB.Classes.Mainline.Shaman.ElementalSpells]]

    -- Shaman Class Baseline Abilities
    self.lightningBolt = TRB.Classes.Mainline.Shaman.OverloadSpell:New({
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
    self.lavaBurst = TRB.Classes.Mainline.Shaman.OverloadSpell:New({
        id = 51505,
        resource = 8,
        overload = 3,
        isTalent = true,
        baseline = true
    })
    self.chainLightning = TRB.Classes.Mainline.Shaman.OverloadSpell:New({
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
        isTalent = true,
        category = "offensive"
    })
    self.earthquake = TRB.Classes.SpellThreshold:New({
        id = 61882,
        primaryResourceType = Enum.PowerType.Maelstrom,
        settingKey = "earthquake",
        isTalent = true,
        isSnowflake = true,
		rangeCheck = false,
        category = "offensive"
    })
    self.earthquakeTargeted = TRB.Classes.SpellThreshold:New({
        id = 462620,
        primaryResourceType = Enum.PowerType.Maelstrom,
        settingKey = "earthquakeTargeted",
        isTalent = true,
        isSnowflake = true,
        category = "offensive"
    })
    self.icefury = TRB.Classes.Mainline.Shaman.OverloadSpell:New({
        id = 462818,
        resource = 10,
        isTalent = true
    })
    self.stormkeeper = TRB.Classes.SpellBase:New({
        id = 191634,
        stacks = 2,
        maxStacks = 4,
        duration = 15
    })
    self.stormwell = TRB.Classes.SpellBase:New({
        id = 1264762,
        isTalent = true,
        resource = 10
    })
    self.tempest = TRB.Classes.SpellBase:New({
        id = 452201,
        spellId = 452201,
        castId = 452201,
        talentId = 454009,
        isTalent = true,
        maxStacks = 2,
        duration = 30,
        cdmSpellId = 454015
    })
    self.arcDischarge = TRB.Classes.SpellBase:New({
        id = 455096,
        isTalent = true,
        stormkeeperStacks = 1
    })
    self.powerOfTheMaelstrom = TRB.Classes.SpellBase:New({
        id = 191877,
        isTalent = true
    })
    self.elementalBlast = TRB.Classes.SpellThreshold:New({
        id = 117014,
        primaryResourceType = Enum.PowerType.Maelstrom,
        settingKey = "elementalBlast",
        isTalent = true,
        category = "offensive"
    })
    self.elementalBlastCriticalStrike = TRB.Classes.SpellBase:New({
        id = 118522
    })
    self.elementalBlastHaste = TRB.Classes.SpellBase:New({
        id = 173183
    })
    self.elementalBlastMastery = TRB.Classes.SpellBase:New({
        id = 173184
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
    -- Midnight Season 1 4pc: Stormkeeper grants one more charge and holds one more.
    self.midnightSeason1SetBonus = TRB.Classes.SpellBase:New({
        fourPieceStacks = 1,
        fourPieceMaxStacks = 1
    })

    return self
end

---Fills barTextVariables for Elemental Shaman options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mainline.Shaman.ElementalSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mainline.Shaman.ElementalSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mainline.Shaman.ElementalSpells]]

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
		{ variable = "#tempest", icon = spells.tempest.icon, description = spells.tempest.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$maelstrom", description = L["ShamanElementalBarTextVariable_maelstrom"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$maelstromMax", description = L["ShamanElementalBarTextVariable_maelstromMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["ShamanElementalBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$mana", description = L["ShamanElementalBarTextVariable_mana"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["ShamanElementalBarTextVariable_manaPercent"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["ShamanElementalBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$ascendanceTime", description = L["ShamanElementalBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		{ variable = "$stormkeeperStacks", description = L["ShamanElementalBarTextVariable_stormkeeperStacks"], printInSettings = true, color = false },
		{ variable = "$stormkeeperStacksMax", description = L["ShamanElementalBarTextVariable_stormkeeperStacksMax"], printInSettings = true, color = false },
		{ variable = "$stormkeeperTime", description = L["ShamanElementalBarTextVariable_stormkeeperTime"], printInSettings = true, color = false },

		-- Stacks are plain: the override says it is up and CDM's stack text only says whether it is at two.
		{ variable = "$tempestStacks", description = L["ShamanBarTextVariable_tempestStacks"], printInSettings = true, color = false, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
		{ variable = "$tempestStacksMax", description = L["ShamanBarTextVariable_tempestStacksMax"], printInSettings = true, color = false },
		{ variable = "$tempestTime", description = L["ShamanBarTextVariable_tempestTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },

		{ variable = "$ebCritTime", description = L["ShamanElementalBarTextVariable_ebCritTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
		{ variable = "$ebHasteTime", description = L["ShamanElementalBarTextVariable_ebHasteTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
		{ variable = "$ebMasteryTime", description = L["ShamanElementalBarTextVariable_ebMasteryTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },

		{ variable = "$earthShockUsable", description = L["ShamanElementalBarTextVariable_earthShockUsable"], printInSettings = true, color = false },
		{ variable = "$elementalBlastUsable", description = L["ShamanElementalBarTextVariable_elementalBlastUsable"], printInSettings = true, color = false },
		{ variable = "$earthquakeUsable", description = L["ShamanElementalBarTextVariable_earthquakeUsable"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Elemental, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mainline.Shaman.ElementalSpells.GetCastbarTickProfiles()
	return {
		-- Lightning Lasso
		[305485] = { mode = "fixedCount", baseDuration = 5, tickCount = 5, },
    }
end

---@type TRB.Classes.ThresholdSnowflakes
TRB.Classes.Mainline.Shaman.ElementalSpells.thresholdSnowflakes = {
	spells = {
		earthquake = TRB.Classes.ThresholdLine.ColorByUsable,
		earthquakeTargeted = TRB.Classes.ThresholdLine.ColorByUsable,
	},
}


---@class TRB.Classes.Mainline.Shaman.EnhancementSpells : TRB.Classes.SpecializationSpellsBase
---@field public maelstromWeapon TRB.Classes.SpellBase
---@field public doomWinds TRB.Classes.SpellBase
---@field public ascendance TRB.Classes.SpellBase
---@field public tempest TRB.Classes.SpellBase
---@field public lightningBolt TRB.Classes.SpellBase
TRB.Classes.Mainline.Shaman.EnhancementSpells =setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mainline.Shaman.EnhancementSpells.__index = TRB.Classes.Mainline.Shaman.EnhancementSpells

function TRB.Classes.Mainline.Shaman.EnhancementSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Mainline.Shaman.EnhancementSpells) --[[@as TRB.Classes.Mainline.Shaman.EnhancementSpells]]

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
    self.tempest = TRB.Classes.SpellBase:New({
        id = 452201,
        spellId = 452201,
        castId = 452201,
        talentId = 454009,
        isTalent = true,
        maxStacks = 2,
        duration = 30,
        cdmSpellId = 454015
    })
    -- Tempest's override is announced against Lightning Bolt.
    self.lightningBolt = TRB.Classes.SpellBase:New({
        id = 188196,
        baseline = true
    })

    return self
end

---Fills barTextVariables for Enhancement Shaman options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Mainline.Shaman.EnhancementSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mainline.Shaman.EnhancementSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mainline.Shaman.EnhancementSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
		{ variable = "#tempest", icon = spells.tempest.icon, description = spells.tempest.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["ShamanEnhancementBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["ShamanEnhancementBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["ShamanEnhancementBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		
		{ variable = "$maelstromWeapon", description = L["ShamanEnhancementBarTextVariable_maelstromWeapon"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$maelstromWeaponMax", description = L["ShamanEnhancementBarTextVariable_maelstromWeaponMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },

		{ variable = "$ascendanceTime", description = L["ShamanEnhancementBarTextVariable_ascendanceTime"], printInSettings = true, color = false },

		{ variable = "$tempestStacks", description = L["ShamanBarTextVariable_tempestStacks"], printInSettings = true, color = false, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
		{ variable = "$tempestStacksMax", description = L["ShamanBarTextVariable_tempestStacksMax"], printInSettings = true, color = false },
		{ variable = "$tempestTime", description = L["ShamanBarTextVariable_tempestTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true, cdm = TRB.Data.constants.cdmDependency.REQUIRED },
	})
end

---Gets built-in castbar channel tick profiles for Enhancement, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mainline.Shaman.EnhancementSpells.GetCastbarTickProfiles()
	return {
		-- Lightning Lasso
		[305485] = { mode = "fixedCount", baseDuration = 5, tickCount = 5, },
    }
end


---@class TRB.Classes.Mainline.Shaman.RestorationSpells : TRB.Classes.Mainline.Healer.HealerSpells
---@field public ascendance TRB.Classes.SpellBase
---@field public preeminence TRB.Classes.SpellBase
TRB.Classes.Mainline.Shaman.RestorationSpells = setmetatable({}, {__index = TRB.Classes.Mainline.Healer.HealerSpells})
TRB.Classes.Mainline.Shaman.RestorationSpells.__index = TRB.Classes.Mainline.Shaman.RestorationSpells

function TRB.Classes.Mainline.Shaman.RestorationSpells:New()
    ---@type TRB.Classes.Mainline.Healer.HealerSpells
    local base = TRB.Classes.Mainline.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Mainline.Shaman.RestorationSpells) --[[@as TRB.Classes.Mainline.Shaman.RestorationSpells]]

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
function TRB.Classes.Mainline.Shaman.RestorationSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Mainline.Shaman.RestorationSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Mainline.Shaman.RestorationSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["ShamanRestorationBarTextVariable_mana"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaPercent", description = L["ShamanRestorationBarTextVariable_manaPercent"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$manaMax", description = L["ShamanRestorationBarTextVariable_manaMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },
		{ variable = "$casting", description = L["ShamanRestorationBarTextVariable_casting"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		
		{ variable = "$ascendanceTime", description = L["ShamanRestorationBarTextVariable_ascendanceTime"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Restoration, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.Mainline.Shaman.RestorationSpells.GetCastbarTickProfiles()
	return {
		-- Lightning Lasso
		[305485] = { mode = "fixedCount", baseDuration = 5, tickCount = 5, },
    }
end


--[[
    BarGroups Factory for Shaman
    Creates the appropriate BarGroup instances for each Shaman specialization.
    
    Elemental: Primary bar (N=1) only
    Enhancement: Primary bar (N=1) + Maelstrom Weapon (N=10)
    Restoration: Primary bar (N=1) only
]]

---@class TRB.Classes.Mainline.Shaman.BarGroupsFactory
TRB.Classes.Mainline.Shaman.BarGroupsFactory = {}
TRB.Classes.Mainline.Shaman.BarGroupsFactory.__index = TRB.Classes.Mainline.Shaman.BarGroupsFactory

---Creates BarGroup instances for the specified Shaman specialization
---@param specId integer # 1=Elemental, 2=Enhancement, 3=Restoration
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Mainline.Shaman.BarGroupsFactory:CreateForSpec(specId)
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

        barGroups.elementalBlastBuffs = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_ElementalBlastBuffs",
            3, -- Critical Strike, Haste, Mastery
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
function TRB.Classes.Mainline.Shaman.BarGroupsFactory:GetSpecConfiguration(specId)
    if specId == 1 then -- Elemental
        return {
            primary = {
                maxNodes = 1,
                isPrimary = true,
                resourceType = "Maelstrom"
            },
            elementalBlastBuffs = {
                maxNodes = 3,
                isPrimary = false,
                resourceType = "ElementalBlastBuffs",
                allowContainerAnchor = false
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
                isPrimary = true,
                resourceType = "Mana"
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
                isPrimary = true,
                resourceType = "Mana"
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
TRB.Data.barTextVariablesRegistry["shaman_elemental"] = TRB.Classes.Mainline.Shaman.ElementalSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["shaman_enhancement"] = TRB.Classes.Mainline.Shaman.EnhancementSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["shaman_restoration"] = TRB.Classes.Mainline.Shaman.RestorationSpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["shaman_elemental"] = TRB.Classes.Mainline.Shaman.ElementalSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["shaman_enhancement"] = TRB.Classes.Mainline.Shaman.EnhancementSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["shaman_restoration"] = TRB.Classes.Mainline.Shaman.RestorationSpells.GetCastbarTickProfiles

-- Register class sets whose bonuses the addon reacts to. Functions\Item.lua counts the equipped pieces of
-- every registered set once per gear change and caches it.
TRB.Classes.Mainline.Shaman.ElementalSpells.midnightSeason1SetKey = "shaman_elemental_midnightSeason1"
TRB.Data.itemSetRegistry = TRB.Data.itemSetRegistry or {}
---@type TRB.Classes.ItemSetDefinition
TRB.Data.itemSetRegistry[TRB.Classes.Mainline.Shaman.ElementalSpells.midnightSeason1SetKey] = {
	headId = 249979,
	shoulderId = 249977,
	chestId = 249982,
	handId = 249980,
	legId = 249978,
}

-- Register audio cue vocabularies
do
	local L = TRB.Localization

	TRB.Functions.AudioCues:Register("shaman_elemental", {
		builtIns = {
			{
				id = "esReady",
				label = L["ShamanElementalAudioEarthShockReady"],
				trigger = L["ShamanElementalAudioTriggerEarthShockReady"],
				tooltip = L["ShamanElementalAudioCheckboxEarthShockTooltip"],
			},
			{
				id = "tempest",
				label = L["ShamanAudioTempest"],
				trigger = L["ShamanAudioTriggerTempest"],
				tooltip = L["ShamanAudioCheckboxTempestTooltip"],
				config = {
					{
						key = "playOnDrop",
						control = "checkbox",
						label = L["AudioCuePlayOnDropCheckbox"],
						tooltip = L["ShamanAudioCheckboxTempestPlayOnDropTooltip"],
						default = false,
					},
				},
			},
			{
				id = "tempest2",
				label = L["ShamanAudioTempest2"],
				trigger = L["ShamanAudioTriggerTempest2"],
				tooltip = L["ShamanAudioCheckboxTempest2Tooltip"],
				cdm = TRB.Data.constants.cdmDependency.REQUIRED,
			},
		},
	})

	TRB.Functions.AudioCues:Register("shaman_enhancement", {
		builtIns = {
			{
				id = "tempest",
				label = L["ShamanAudioTempest"],
				trigger = L["ShamanAudioTriggerTempest"],
				tooltip = L["ShamanAudioCheckboxTempestTooltip"],
				config = {
					{
						key = "playOnDrop",
						control = "checkbox",
						label = L["AudioCuePlayOnDropCheckbox"],
						tooltip = L["ShamanAudioCheckboxTempestPlayOnDropTooltip"],
						default = false,
					},
				},
			},
			{
				id = "tempest2",
				label = L["ShamanAudioTempest2"],
				trigger = L["ShamanAudioTriggerTempest2"],
				tooltip = L["ShamanAudioCheckboxTempest2Tooltip"],
				cdm = TRB.Data.constants.cdmDependency.REQUIRED,
			},
		},
		counters = {
			{
				id = "maelstromWeapon",
				label = L["ShamanAudioCueSourceMaelstromWeapon"],
				description = L["ShamanAudioCueSourceMaelstromWeaponDescription"],
				sliderLabel = L["ShamanMaelstromWeaponThresholdSliderTitle"],
				defaultName = L["ShamanAudioCueMaelstromWeaponDefaultName"],
				min = 0,
				max = 10,
				step = 1,
				decimals = 0,
				compare = "atLeast",
				requiresCombat = true,
				legacyIds = { "maelstromWeaponThreshold1", "maelstromWeaponThreshold2" },
				defaultCues = {
					{
						id = "maelstromWeaponThreshold1",
						name = L["ShamanAudioMaelstromWeaponThreshold1"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 5,
					},
					{
						id = "maelstromWeaponThreshold2",
						name = L["ShamanAudioMaelstromWeaponThreshold2"],
						enabled = false,
						sound = "Interface\\Addons\\TwintopInsanityBar\\Sounds\\BoxingArenaSound.ogg",
						soundName = L["LSMSoundBoxingArenaGong"],
						thresholdValue = 10,
					},
				},
			},
		},
	})
end

-- Spec descriptors: the traits Core needs to know about these specs (see Core\Classes\SpecDescriptor.lua).
-- Everything class-specific that shared code used to hard-code by class/spec id is declared here instead.
do
	local L = TRB.Localization
	local SpecDescriptor = TRB.Classes.SpecDescriptor
	SpecDescriptor:Declare("shaman_elemental", {
		manaBar = true,
		totems = { placement = "spec" },
		talentGatedBars = { elementalBlastBuffs = "elementalBlast" },
		customBars = { "mana", "elementalBlastBuffs" },
		barTextAnchorFrames = {
			mana = { { label = L["ManaBar"], frame = "ManaBar" } },
			elementalBlastBuffs = {
				{ label = L["ElementalBlastCriticalStrike"], frame = "ElementalBlastCriticalStrike" }, { label = L["ElementalBlastHaste"], frame = "ElementalBlastHaste" }, { label = L["ElementalBlastMastery"], frame = "ElementalBlastMastery" },
			},
		},
	})
	SpecDescriptor:Declare("shaman_enhancement", {
		manaBar = true,
		totems = { placement = "spec" },
		secondary = { exportable = true },
		barTextAnchorFrames = {
			secondary = {
				{ label = L["Maelstrom1"], frame = "ComboPoint_1" }, { label = L["Maelstrom2"], frame = "ComboPoint_2" }, { label = L["Maelstrom3"], frame = "ComboPoint_3" }, { label = L["Maelstrom4"], frame = "ComboPoint_4" },
				{ label = L["Maelstrom5"], frame = "ComboPoint_5" }, { label = L["Maelstrom6"], frame = "ComboPoint_6" }, { label = L["Maelstrom7"], frame = "ComboPoint_7" }, { label = L["Maelstrom8"], frame = "ComboPoint_8" },
				{ label = L["Maelstrom9"], frame = "ComboPoint_9" }, { label = L["Maelstrom10"], frame = "ComboPoint_10" },
			},
		},
	})
	SpecDescriptor:Declare("shaman_restoration", {
		manaBar = true,
		totems = { placement = "spec" },
	})
end
