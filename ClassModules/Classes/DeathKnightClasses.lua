local _, TRB = ...
if TRB.Data.character.classId ~= 6 then --Only do this if we're on an Death Knight!
	return
end

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
        isTalent = false,
        baseline = true
    })

    -- Class Talents
    self.deathStrike = TRB.Classes.SpellThreshold:New({
        id = 49998,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "deathStrike",
        isTalent = true
    })

    return self
end

---@class TRB.Classes.DeathKnight.BloodSpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
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
        isTalent = false,
        baseline = true
    })

    -- Blood Baseline Abilities

    -- Death Knight Class Talents
    
    -- Blood Spec Talents

    self.deathStrike.baseline = true
    return self
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
        isTalent = true,
        rangeCheck = false,
        hasCooldown = true,
        cooldown = 90
    })
    self.frostStrike = TRB.Classes.SpellThreshold:New({
        id = 49143,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "frostStrike",
        isTalent = true
    })
    self.glacialAdvance = TRB.Classes.SpellThreshold:New({
        id = 194913,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "glacialAdvance",
        isTalent = true
    })

    return self
end


---@class TRB.Classes.DeathKnight.UnholySpells : TRB.Classes.DeathKnight.DeathKnightBaseSpells
---@field raiseAlly TRB.Classes.SpellThreshold
TRB.Classes.DeathKnight.UnholySpells = setmetatable({}, {__index = TRB.Classes.DeathKnight.DeathKnightBaseSpells})
TRB.Classes.DeathKnight.UnholySpells.__index = TRB.Classes.DeathKnight.UnholySpells

function TRB.Classes.DeathKnight.UnholySpells:New()
    ---@type TRB.Classes.DeathKnight.DeathKnightBaseSpells
    local base = TRB.Classes.DeathKnight.DeathKnightBaseSpells
    self = setmetatable(base:New(), TRB.Classes.DeathKnight.UnholySpells) --[[@as TRB.Classes.DeathKnight.UnholySpells]]
    
    self.raiseAlly = TRB.Classes.SpellThreshold:New({
        id = 61999,
        primaryResourceType = Enum.PowerType.RunicPower,
        settingKey = "raiseAlly",
        isTalent = false,
        baseline = true
    })

    return self
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
    barGroups.primary = TRB.Classes.BarGroup:New(
        parentFrame,
        "TwintopResourceBarFrame",
        1,
        true -- isPrimary
    )

    -- Runes (6 nodes for all specs)
    barGroups.runes = TRB.Classes.BarGroup:New(
        parentFrame,
        "TwintopResourceBarFrame_ComboPoint",
        6,
        false -- not primary
    )

    return barGroups
end

---Gets the bar group configuration for a spec
---@param specId integer
---@return table # Configuration describing the bar groups for this spec
function TRB.Classes.DeathKnight.BarGroupsFactory:GetSpecConfiguration(specId)
    -- All Death Knight specs have the same configuration
    return {
        primary = {
            maxNodes = 1,
            isPrimary = true
        },
        runes = {
            maxNodes = 6,
            isPrimary = false,
            resourceType = "Runes"
        }
    }
end