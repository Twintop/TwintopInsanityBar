local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Warlock = TRB.Classes.Warlock or {}

---@class TRB.Classes.Warlock.AfflictionSpells : TRB.Classes.SpecializationSpellsBase
---@field public seedOfCorruption TRB.Classes.SpellBase
---@field public unstableAffliction TRB.Classes.SpellBase
---@field public darkHarvest TRB.Classes.SpellBase
---@field public shadowOfDeath TRB.Classes.SpellBase
---@field public shardInstability TRB.Classes.SpellBase
TRB.Classes.Warlock.AfflictionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.AfflictionSpells.__index = TRB.Classes.Warlock.AfflictionSpells

function TRB.Classes.Warlock.AfflictionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.AfflictionSpells) --[[@as TRB.Classes.Warlock.AfflictionSpells]]

    self.seedOfCorruption = TRB.Classes.SpellBase:New({
        id = 27243,
        baseline = true,
        resource = -1
    })
    self.unstableAffliction = TRB.Classes.SpellBase:New({
        id = 1259790,
        isTalent = true,
        resource = -1
    })
    self.darkHarvest = TRB.Classes.SpellBase:New({
        id = 1257052,
        isTalent = true
    })
    self.shadowOfDeath = TRB.Classes.SpellBase:New({
        id = 449638,
        isTalent = true,
        resource = 1
    })
    self.shardInstability = TRB.Classes.SpellBase:New({
        id = 1260264,
        isTalent = true,
        buffId = 1260269,
        maxStacks = 3
    })

    return self
end

---Fills barTextVariables for Affliction Warlock options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warlock.AfflictionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warlock.AfflictionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#seedOfCorruption", icon = spells.seedOfCorruption.icon, description = spells.seedOfCorruption.name, printInSettings = true },
		{ variable = "#unstableAffliction", icon = spells.unstableAffliction.icon, description = spells.unstableAffliction.name, printInSettings = true },
		{ variable = "#shadowOfDeath", icon = spells.shadowOfDeath.icon, description = spells.shadowOfDeath.name, printInSettings = true },
		{ variable = "#shardInstability", icon = spells.shardInstability.icon, description = spells.shardInstability.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["WarlockAfflictionBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["WarlockAfflictionBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["WarlockAfflictionBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
        { variable = "$casting", description = L["WarlockAfflictionBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$castingShards", description = L["WarlockDestructionBarTextVariable_castingFragments"], printInSettings = true, color = false },
		{ variable = "$castingFragments", description = "", printInSettings = false, color = false },
		{ variable = "$castingSoulShards", description = "", printInSettings = false, color = false },
					
		{ variable = "$soulShards", description = L["WarlockAfflictionBarTextVariable_soulShards"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockAfflictionBarTextVariable_soulShardsMax"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsPlusCasting", description = L["WarlockAfflictionBarTextVariable_soulShardsPlusCasting"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPointsPlusCasting", description = "", printInSettings = false, color = false },

		{ variable = "$shardInstabilityTime", description = L["WarlockAfflictionBarTextVariable_shardInstabilityTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true },
		{ variable = "$shardInstabilityStacks", description = L["WarlockAfflictionBarTextVariable_shardInstabilityStacks"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true },
		{ variable = "$shardInstabilityMaxStacks", description = L["WarlockAfflictionBarTextVariable_shardInstabilityMaxStacks"], printInSettings = true, color = false },
	})
end

---@class TRB.Classes.Warlock.DemonologySpells : TRB.Classes.SpecializationSpellsBase
---@field public shadowBolt TRB.Classes.SpellBase
---@field public demonbolt TRB.Classes.SpellBase
---@field public infernalBolt TRB.Classes.SpellBase
---@field public ruination TRB.Classes.SpellBase
---@field public handOfGuldan TRB.Classes.SpellBase
---@field public shadowOfDeath TRB.Classes.SpellBase
---@field public summonFelguard TRB.Classes.SpellBase
---@field public summonDemonicTyrant TRB.Classes.SpellBase
---@field public callDreadstalkers TRB.Classes.SpellBase
---@field public demonicCalling TRB.Classes.SpellBase
---@field public dominionOfArgus TRB.Classes.SpellBase
---@field public dominionOfArgus2 TRB.Classes.SpellBase
---@field public dominionOfArgus3 TRB.Classes.SpellBase
---@field public demonicCore TRB.Classes.SpellBase
TRB.Classes.Warlock.DemonologySpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.DemonologySpells.__index = TRB.Classes.Warlock.DemonologySpells

function TRB.Classes.Warlock.DemonologySpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.DemonologySpells) --[[@as TRB.Classes.Warlock.DemonologySpells]]

    self.shadowBolt = TRB.Classes.SpellBase:New({
        id = 686,
        baseline = true,
        resource = 1
    })
    self.demonbolt = TRB.Classes.SpellBase:New({
        id = 264178,
        baseline = true,
        resource = 2
    })
    self.infernalBolt = TRB.Classes.SpellBase:New({
        id = 434506,
        isTalent = true,
        resource = 3,
        duration = 20
    })
    self.ruination = TRB.Classes.SpellBase:New({
        id = 434635,
        isTalent = true,
        resource = 1,
        duration = 20
    })
    self.handOfGuldan = TRB.Classes.SpellBase:New({
        id = 105174,
        baseline = true,
        resource = -3
    })
    self.shadowOfDeath = TRB.Classes.SpellBase:New({
        id = 449638,
        isTalent = true,
        resource = 3
    })
    self.summonFelguard = TRB.Classes.SpellBase:New({
        id = 30146,
        baseline = true,
        resource = -1
    })
    self.summonDemonicTyrant = TRB.Classes.SpellBase:New({
        id = 265187
    })
    self.callDreadstalkers = TRB.Classes.SpellBase:New({
        id = 104316,
        isTalent = true,
        resource = -2
    })
    self.demonicCalling = TRB.Classes.SpellBase:New({
        id = 1276947,
        isTalent = true,
        resourceMod = 1
    })
    --1/4 ranks
    self.dominionOfArgus = TRB.Classes.SpellBase:New({
        id = 1276166,
        talentId = 1276163,
        isTalent = true,
        duration = 15,
        durationMod = 5,
        resourceMod = 1
    })
    --2/4 and 3/4 ranks
    self.dominionOfArgus2 = TRB.Classes.SpellBase:New({
        id = 1276166,
        talentId = 1276190,
        isTalent = true,
        duration = 15,
        durationMod = 5,
        resourceMod = 1
    })
    --4/4 ranks
    self.dominionOfArgus3 = TRB.Classes.SpellBase:New({
        id = 1276166,
        talentId = 1276222,
        isTalent = true,
        duration = 15,
        durationMod = 5,
        resourceMod = 1
    })
    self.demonicCore = TRB.Classes.SpellBase:New({
        id = 264173,
        duration = 20,
        maxStacks = 4
    })

    return self
end

---Fills barTextVariables for Demonology Warlock options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warlock.DemonologySpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warlock.DemonologySpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warlock.DemonologySpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#shadowBolt", icon = spells.shadowBolt.icon, description = spells.shadowBolt.name, printInSettings = true },
		{ variable = "#demonbolt", icon = spells.demonbolt.icon, description = spells.demonbolt.name, printInSettings = true },
		{ variable = "#infernalBolt", icon = spells.infernalBolt.icon, description = spells.infernalBolt.name, printInSettings = true },
		{ variable = "#ruination", icon = spells.ruination.icon, description = spells.ruination.name, printInSettings = true },
		{ variable = "#handOfGuldan", icon = spells.handOfGuldan.icon, description = spells.handOfGuldan.name, printInSettings = true },
		{ variable = "#shadowOfDeath", icon = spells.shadowOfDeath.icon, description = spells.shadowOfDeath.name, printInSettings = true },
		{ variable = "#summonFelguard", icon = spells.summonFelguard.icon, description = spells.summonFelguard.name, printInSettings = true },
		{ variable = "#callDreadstalkers", icon = spells.callDreadstalkers.icon, description = spells.callDreadstalkers.name, printInSettings = true },
		{ variable = "#demonicCore", icon = spells.demonicCore.icon, description = spells.demonicCore.name, printInSettings = true },
		{ variable = "#doa", icon = spells.dominionOfArgus.icon, description = spells.dominionOfArgus.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["WarlockDemonologyBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$manaPercent", description = L["WarlockDemonologyBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
		{ variable = "$manaMax", description = L["WarlockDemonologyBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$casting", description = L["WarlockDemonologyBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$castingShards", description = L["WarlockDestructionBarTextVariable_castingFragments"], printInSettings = true, color = false },
		{ variable = "$castingFragments", description = "", printInSettings = false, color = false },
		{ variable = "$castingSoulShards", description = "", printInSettings = false, color = false },
					
		{ variable = "$soulShards", description = L["WarlockDemonologyBarTextVariable_soulShards"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockDemonologyBarTextVariable_soulShardsMax"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsPlusCasting", description = L["WarlockDemonologyBarTextVariable_soulShardsPlusCasting"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPointsPlusCasting", description = "", printInSettings = false, color = false },

		{ variable = "$demonicCoreTime", description = L["WarlockDemonologyBarTextVariable_demonicCoreTime"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true },
		{ variable = "$demonicCoreStacks", description = L["WarlockDemonologyBarTextVariable_demonicCoreStacks"], printInSettings = true, color = false, secret = true, logicType = "number", booleanCheck = true },

		{ variable = "$doaTime", description = L["WarlockDemonologyBarTextVariable_doaTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },

		{ variable = "$infernalBoltTime", description = L["WarlockDemonologyBarTextVariable_infernalBoltTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
		{ variable = "$ruinationTime", description = L["WarlockDemonologyBarTextVariable_ruinationTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
	})
end


---@class TRB.Classes.Warlock.DestructionSpells : TRB.Classes.SpecializationSpellsBase
---@field public incinerate TRB.Classes.SpellBase
---@field public diabolicEmbers TRB.Classes.SpellBase
---@field public soulFire TRB.Classes.SpellBase
---@field public infernalBolt TRB.Classes.SpellBase
---@field public chaosBolt TRB.Classes.SpellBase
---@field public ruination TRB.Classes.SpellBase
TRB.Classes.Warlock.DestructionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.DestructionSpells.__index = TRB.Classes.Warlock.DestructionSpells

function TRB.Classes.Warlock.DestructionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.DestructionSpells) --[[@as TRB.Classes.Warlock.DestructionSpells]]

    self.incinerate = TRB.Classes.SpellBase:New({
        id = 29722,
        baseline = true,
        resource = 2
    })
    self.diabolicEmbers = TRB.Classes.SpellBase:New({
        id = 387173,
        isTalent = true,
        resourceMod = 2
    })
    self.soulFire = TRB.Classes.SpellBase:New({
        id = 6353,
        isTalent = true,
        resource = 10
    })
    self.infernalBolt = TRB.Classes.SpellBase:New({
        id = 434506,
        isTalent = true,
        resource = 20,
        duration = 20
    })
    self.chaosBolt = TRB.Classes.SpellBase:New({
        id = 116858,
        baseline = true,
        resource = -20
    })
    self.ruination = TRB.Classes.SpellBase:New({
        id = 434635,
        isTalent = true,
        duration = 20
    })

    return self
end

---Fills barTextVariables for Destruction Warlock options panel display
---@param specCacheEntry TRB.Classes.SpecCache
function TRB.Classes.Warlock.DestructionSpells.FillBarTextVariables(specCacheEntry)
	local L = TRB.Localization
	if getmetatable(specCacheEntry.spellsData.spells) == TRB.Classes.SpecializationSpellsBase then
		specCacheEntry.spellsData.spells = TRB.Classes.Warlock.DestructionSpells:New()
	end
	specCacheEntry.spellsData:FillSpellData()
	local spells = specCacheEntry.spellsData.spells --[[@as TRB.Classes.Warlock.DestructionSpells]]

	specCacheEntry.barTextVariables.icons = TRB.Functions.BarText:GetCommonIcons({
		{ variable = "#incinerate", icon = spells.incinerate.icon, description = spells.incinerate.name, printInSettings = true },
		{ variable = "#soulFire", icon = spells.soulFire.icon, description = spells.soulFire.name, printInSettings = true },
		{ variable = "#infernalBolt", icon = spells.infernalBolt.icon, description = spells.infernalBolt.name, printInSettings = true },
		{ variable = "#chaosBolt", icon = spells.chaosBolt.icon, description = spells.chaosBolt.name, printInSettings = true },
		{ variable = "#ruination", icon = spells.ruination.icon, description = spells.ruination.name, printInSettings = true },
	})
	specCacheEntry.barTextVariables.values = TRB.Functions.BarText:GetCommonValues({
		{ variable = "$mana", description = L["WarlockDestructionBarTextVariable_mana"], printInSettings = true, color = false },
		{ variable = "$manaPercent", description = L["WarlockDestructionBarTextVariable_manaPercent"], printInSettings = true, color = false },
		{ variable = "$manaMax", description = L["WarlockDestructionBarTextVariable_manaMax"], printInSettings = true, color = false },
		{ variable = "$casting", description = L["WarlockDestructionBarTextVariable_casting"], printInSettings = true, color = false },
		{ variable = "$castingFragments", description = L["WarlockDestructionBarTextVariable_castingFragments"], printInSettings = true, color = false },
		{ variable = "$castingShards", description = "", printInSettings = false, color = false },
		{ variable = "$castingSoulShards", description = "", printInSettings = false, color = false },
		{ variable = "$resource", description = "", printInSettings = false, color = false },
		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		{ variable = "$resourceTotal", description = "", printInSettings = false, color = false },
		{ variable = "$resourcePercent", description = "", printInSettings = false, color = false },
        
		{ variable = "$soulShards", description = L["WarlockDestructionBarTextVariable_soulShards"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsMax", description = L["WarlockDestructionBarTextVariable_soulShardsMax"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPointsMax", description = "", printInSettings = false, color = false },
		{ variable = "$soulShardsPlusCasting", description = L["WarlockDestructionBarTextVariable_soulShardsPlusCasting"], printInSettings = true, color = false, secret = true },
		{ variable = "$comboPointsPlusCasting", description = "", printInSettings = false, color = false },

		{ variable = "$infernalBoltTime", description = L["WarlockDestructionBarTextVariable_infernalBoltTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
		{ variable = "$ruinationTime", description = L["WarlockDestructionBarTextVariable_ruinationTime"], printInSettings = true, color = false, logicType = "number", booleanCheck = true },
	})
end


--[[
    BarGroups Factory for Warlock
    Creates the appropriate BarGroup instances for each Warlock specialization.
    
    All specs use Soul Shards as secondary resource:
    Affliction: Primary bar (N=1) + Soul Shards (N=5) - binary fill
    Demonology: Primary bar (N=1) + Soul Shards (N=5) - binary fill
    Destruction: Primary bar (N=1) + Soul Shards (N=5) - percentage fill (partial shards)
]]

---@class TRB.Classes.Warlock.BarGroupsFactory
TRB.Classes.Warlock.BarGroupsFactory = {}
TRB.Classes.Warlock.BarGroupsFactory.__index = TRB.Classes.Warlock.BarGroupsFactory

---Creates BarGroup instances for the specified Warlock specialization
---@param specId integer # 1=Affliction, 2=Demonology, 3=Destruction
---@param parentFrame Frame # The parent frame to attach bar groups to
---@return table<string, TRB.Classes.BarGroup> # Table of bar groups keyed by name
function TRB.Classes.Warlock.BarGroupsFactory:CreateForSpec(specId, parentFrame)
    local barGroups = {}

    -- Primary mana bar (1 node)
    barGroups.primary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Soul Shards (5 nodes) - all specs use secondary resource
    -- Secondary bars are parented to UIParent for independent visibility
    barGroups.secondary = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_ComboPoint",
        5,
        false -- not primary
    )

    -- Health bar
    barGroups.health = TRB.Classes.BarGroup:New(
        UIParent,
        "TwintopResourceBarFrame_Health",
        1,
        false -- not primary
    )

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.Warlock.BarGroupsFactory:GetSpecConfiguration(specId)
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true,
            resourceType = "Mana"
        },
        secondary = {
            maxNodes = 5,
            isPrimary = false,
            resourceType = "SoulShards"
        },
        health = {
            maxNodes = 1,
            isPrimary = false,
            resourceType = "Health"
        }
    }
end

-- Register barTextVariables fillers for cross-class options panel support
TRB.Data.barTextVariablesRegistry = TRB.Data.barTextVariablesRegistry or {}
TRB.Data.barTextVariablesRegistry["warlock_affliction"] = TRB.Classes.Warlock.AfflictionSpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["warlock_demonology"] = TRB.Classes.Warlock.DemonologySpells.FillBarTextVariables
TRB.Data.barTextVariablesRegistry["warlock_destruction"] = TRB.Classes.Warlock.DestructionSpells.FillBarTextVariables