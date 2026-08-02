local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.DeathKnight = TRB.Classes.DeathKnight or {}

---@class TRB.Classes.DeathKnight.DeathKnightBaseSpells : TRB.Classes.SpecializationSpellsBase
---@field deathCoil TRB.Classes.SpellThreshold
---@field deathStrike TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.DeathKnightBaseSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.DeathKnight.DeathKnightBaseSpells.__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells

function TRB.Classes.DeathKnight.DeathKnightBaseSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    self = setmetatable(TRB.Classes.SpecializationSpellsBase:New(), TRB.Classes.DeathKnight.DeathKnightBaseSpells) --[[@as TRB.Classes.DeathKnight.DeathKnightBaseSpells]]

    -- Baseline
    self.deathCoil = TRB.Classes.SpellThreshold:New({
        id = 47541,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "deathCoil",
        category = "offensive",
        isTalent = false,
        baseline = true
    })

    -- Class Talents
    self.deathStrike = TRB.Classes.SpellThreshold:New({
        id = 49998,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "deathStrike",
        category = "defensive",
        isTalent = true
    })

    return self
end

---@class TRB.Classes.DeathKnight.BloodSpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
---@field boneShield TRB.Classes.SpellBase
---@field improvedBoneShield TRB.Classes.SpellBase
---@field marrowrend TRB.Classes.SpellBase
---@field ossuary TRB.Classes.SpellBase
---@field raiseAlly TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.BloodSpells = setmetatable({}, {__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells})
TRB.Classes.DeathKnight.BloodSpells.__index = TRB.Classes.DeathKnight.BloodSpells

function TRB.Classes.DeathKnight.BloodSpells:New()
    ---@type TRB.Classes.DeathKnight.DeathKnightBaseSpells
    local base = TRB.Classes.DeathKnight.DeathKnightBaseSpells
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.BloodSpells) --[[@as TRB.Classes.DeathKnight.BloodSpells]]
    -- Death Knight Class Baseline Abilities
    self.raiseAlly = TRB.Classes.SpellThreshold:New({
        id = 61999,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "raiseAlly",
        category = "utility",
        isTalent = false,
        baseline = true
    })

    self.boneShield = TRB.Classes.SpellBase:New({
        id = 195181,
        duration = 30,
        maxStacks = 10
    })
    self.improvedBoneShield = TRB.Classes.SpellBase:New({
        id = 374715,
        maxStacksMod = 2
    })

    self.marrowrend = TRB.Classes.SpellBase:New({
        id = 195182,
        isTalent = true
    })

    self.ossuary = TRB.Classes.SpellBase:New({
        id = 219786,
        isTalent = true,
        stackThreshold = 5
    })

    self.deathStrike.baseline = true
    return self
end

---Fills barTextVariables for Blood Death Knight options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DeathKnight.BloodSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DeathKnight.BloodSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DeathKnight.BloodSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#boneShield", icon = spells.boneShield.icon, description = spells.boneShield.name, printInSettings = true },
	})
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$boneShieldStacks", description = L["DeathKnightBarTextVariable_boneShieldStacks"], printInSettings = true, color = false, secret = true },
		{ variable = "$boneShieldStacksMax", description = L["DeathKnightBarTextVariable_boneShieldStacksMax"], printInSettings = true, color = false },
	})
end

---Gets built-in castbar channel tick profiles for Blood, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.DeathKnight.BloodSpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.DeathKnight.FrostSpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
---@field breathOfSindragosa TRB.Classes.SpellThreshold
---@field frostStrike TRB.Classes.SpellThreshold
---@field glacialAdvance TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.FrostSpells = setmetatable({}, {__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells})
TRB.Classes.DeathKnight.FrostSpells.__index = TRB.Classes.DeathKnight.FrostSpells

function TRB.Classes.DeathKnight.FrostSpells:New()
    ---@type TRB.Classes.DeathKnight.DeathKnightBaseSpells
    local base = TRB.Classes.DeathKnight.DeathKnightBaseSpells
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.FrostSpells) --[[@as TRB.Classes.DeathKnight.FrostSpells]]

    self.breathOfSindragosa = TRB.Classes.SpellThreshold:New({
        id = 1249658,
        castId = 1249658,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "breathOfSindragosa",
        category = "offensive",
        isTalent = true,
        rangeCheck = false,
        hasCooldown = true,
        cooldown = 90
    })
    self.frostStrike = TRB.Classes.SpellThreshold:New({
        id = 49143,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "frostStrike",
        category = "offensive",
        isTalent = true
    })
    self.glacialAdvance = TRB.Classes.SpellThreshold:New({
        id = 194913,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "glacialAdvance",
        category = "offensive",
        baseline = true
    })

    return self
end

---Fills barTextVariables for Frost Death Knight options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DeathKnight.FrostSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DeathKnight.FrostSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DeathKnight.FrostSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
	})
end

---Gets built-in castbar channel tick profiles for Frost, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.DeathKnight.FrostSpells.GetCastbarTickProfiles()
	return {}
end


---@class TRB.Classes.DeathKnight.UnholySpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
---@field epidemic TRB.Classes.SpellThreshold
---@field raiseAlly TRB.Classes.SpellThreshold
---@field zombify TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.UnholySpells = setmetatable({}, {__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells})
TRB.Classes.DeathKnight.UnholySpells.__index = TRB.Classes.DeathKnight.UnholySpells

function TRB.Classes.DeathKnight.UnholySpells:New()
    ---@type TRB.Classes.DeathKnight.DeathKnightBaseSpells
    local base = TRB.Classes.DeathKnight.DeathKnightBaseSpells
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.UnholySpells) --[[@as TRB.Classes.DeathKnight.UnholySpells]]
    
    self.epidemic = TRB.Classes.SpellThreshold:New({
        id = 207317,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "epidemic",
        category = "offensive",
        baseline = true
    })

    self.raiseAlly = TRB.Classes.SpellThreshold:New({
        id = 61999,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "raiseAlly",
        category = "utility",
        isTalent = false,
        baseline = true
    })

    self.zombify = TRB.Classes.SpellThreshold:New({
        id = 210128,
        talentId = 207289,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "zombify",
        isPvp = true,
        category = "pvp",
        isTalent = true
    })

    return self
end

---Fills barTextVariables for Unholy Death Knight options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.DeathKnight.UnholySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.DeathKnight.UnholySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.DeathKnight.UnholySpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons()
	local varCategory = TRB.Functions.BarText.VariableCategory
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$runicPower", description = L["DeathKnightBarTextVariable_runicPower"], printInSettings = true, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$resource", description = "", printInSettings = false, color = false, secret = true, category = varCategory.RESOURCES },
		{ variable = "$runicPowerMax", description = L["DeathKnightBarTextVariable_runicPowerMax"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false, category = varCategory.RESOURCES },

		{ variable = "$runesReadyCount", description = L["DeathKnightBarTextVariable_runesReadyCount"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$rune1Time", description = L["DeathKnightBarTextVariable_rune1Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune2Time", description = L["DeathKnightBarTextVariable_rune2Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune3Time", description = L["DeathKnightBarTextVariable_rune3Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune4Time", description = L["DeathKnightBarTextVariable_rune4Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune5Time", description = L["DeathKnightBarTextVariable_rune5Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune6Time", description = L["DeathKnightBarTextVariable_rune6Time"], printInSettings = true, color = false, category = varCategory.RESOURCES },

		{ variable = "$rune1Ready", description = L["DeathKnightBarTextVariable_rune1Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune2Ready", description = L["DeathKnightBarTextVariable_rune2Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune3Ready", description = L["DeathKnightBarTextVariable_rune3Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune4Ready", description = L["DeathKnightBarTextVariable_rune4Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune5Ready", description = L["DeathKnightBarTextVariable_rune5Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
		{ variable = "$rune6Ready", description = L["DeathKnightBarTextVariable_rune6Ready"], printInSettings = true, color = false, category = varCategory.RESOURCES },
	})
end

---Gets built-in castbar channel tick profiles for Unholy, keyed by spell id. Fresh tables each call.
---@return table<integer, TRB.Classes.Settings.CastbarTickProfile>
function TRB.Classes.DeathKnight.UnholySpells.GetCastbarTickProfiles()
	return {}
end


--[[
    BarGroups Factory for Death Knight
    Creates the appropriate BarGroup instances for each Death Knight specialization.
    
    All specs: Primary bar (N=1) for Runic Power + Runes (N=6)
]]

---@class TRB.Classes.DeathKnight.BarGroupsFactory
TRB.Classes.DeathKnight.BarGroupsFactory = {}
TRB.Classes.DeathKnight.BarGroupsFactory.__index = TRB.Classes.DeathKnight.BarGroupsFactory

---Creates BarGroup instances for the specified Death Knight specialization
---@param specId integer # 1=Blood, 2=Frost, 3=Unholy
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.DeathKnight.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- All Death Knight specs have the same bar structure:
    -- Primary Runic Power bar (1 node) + Runes (6 nodes)

    -- Primary Runic Power bar (1 node)
    -- Primary bar groups are parented directly to UIParent for proper positioning
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Runes (6 nodes for all specs)
    -- Secondary bars are parented to UIParent for independent visibility
    barGroups.secondary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_ComboPoint",
        6,
        false -- not primary
    )
    -- Runes recharge independently, so an enabled end cap appears on every rune
    barGroups.secondary.endCapMode = "all"

    -- Health bar (1 node)
    barGroups.health = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_Health",
        1,
        false -- not primary
    )

    -- Bone Shield bar (Blood only, 12 max nodes)
    if specId == 1 then
        barGroups.boneShield = TRB.Classes.BarGroup:New(
            UIParent,
            "TwintopResourceBarFrame_BoneShield",
            12,
            false -- not primary
        )
    end

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.DeathKnight.BarGroupsFactory:GetSpecConfiguration(specId)
    local config = {
        primary = {
            maxNodes = 1,
            isPrimary = true,
            resourceType = "RunicPower"
        },
        secondary = {
            maxNodes = 6,
            isPrimary = false,
            resourceType = "Runes"
        },
        health = {
            maxNodes = 1,
            isPrimary = false,
            resourceType = "Health"
        }
    }

    -- Blood gets a Bone Shield bar
    if specId == 1 then
        config.boneShield = {
            maxNodes = 12,
            isPrimary = false,
            resourceType = "BoneShield"
        }
    end

    return config
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["deathknight_blood"] = TRB.Classes.DeathKnight.BloodSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["deathknight_frost"] = TRB.Classes.DeathKnight.FrostSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["deathknight_unholy"] = TRB.Classes.DeathKnight.UnholySpells.FillBarTextVariables

-- Register built-in castbar channel tick profiles for spec default settings
TRB.Data.castbarTickProfilesRegistry = TRB.Data.castbarTickProfilesRegistry or {}
TRB.Data.castbarTickProfilesRegistry["deathknight_blood"] = TRB.Classes.DeathKnight.BloodSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["deathknight_frost"] = TRB.Classes.DeathKnight.FrostSpells.GetCastbarTickProfiles
TRB.Data.castbarTickProfilesRegistry["deathknight_unholy"] = TRB.Classes.DeathKnight.UnholySpells.GetCastbarTickProfiles