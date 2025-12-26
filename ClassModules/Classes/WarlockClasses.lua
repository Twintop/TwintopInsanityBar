local _, TRB = ...
if TRB.Data.character.classId ~= 9 then --Only do this if we're on an Warlock!
	return
end
TRB.Classes = TRB.Classes or {}
TRB.Classes.Warlock = TRB.Classes.Warlock or {}

---@class TRB.Classes.Warlock.AfflictionSpells : TRB.Classes.SpecializationSpellsBase
---@field public unstableAffliction TRB.Classes.SpellBase
---@field public agony TRB.Classes.SpellBase
---@field public corruption TRB.Classes.SpellBase
---@field public haunt TRB.Classes.SpellBase
---@field public vileTaint TRB.Classes.SpellBase
---@field public soulRot TRB.Classes.SpellBase
---@field public phantomSingularity TRB.Classes.SpellBase
---@field public tormentedCrescendo TRB.Classes.SpellBase
---@field public nightfall TRB.Classes.SpellBase
---@field public shadowEmbraceShadowBolt TRB.Classes.SpellBase
---@field public shadowEmbraceDrainSoul TRB.Classes.SpellBase
---@field public drainSoul TRB.Classes.SpellBase
---@field public wither TRB.Classes.SpellBase
---@field public succulentSoul TRB.Classes.SpellBase
TRB.Classes.Warlock.AfflictionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.AfflictionSpells.__index = TRB.Classes.Warlock.AfflictionSpells

function TRB.Classes.Warlock.AfflictionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.AfflictionSpells) --[[@as TRB.Classes.Warlock.AfflictionSpells]]

    -- Warlock Class Baseline Abilities
    self.corruption = TRB.Classes.SpellBase:New({
        id = 146739,
        baseDuration = 14,
        pandemic = true,
        baseline = true,
    })

    -- Affliction Baseline Abilities 
    

    -- Warlock Talent Abilities


    -- Affliction Talent Abilities
    self.nightfall = TRB.Classes.SpellBase:New({
        id = 264571,
        talentId = 108558,
        isTalent = true
    })
    self.tormentedCrescendo = TRB.Classes.SpellBase:New({
        id = 387079,
        talentId = 387075,
        isTalent= true
    })
    self.unstableAffliction = TRB.Classes.SpellBase:New({
        id = 316099,
        baseDuration = 21,
        pandemic = true,
        isTalent = true,
    })
    self.agony = TRB.Classes.SpellBase:New({
        id = 980,
        baseDuration = 18,
        pandemic = true,
        isTalent = true
    })
    self.haunt = TRB.Classes.SpellBase:New({
        id = 48181,
        pandemic = true,
        baseDuration = 18,
        isTalent = true,
    })
    self.vileTaint = TRB.Classes.SpellBase:New({
        id = 386931,
        baseDuration = 10,
        isTalent = true,
    })
    self.soulRot = TRB.Classes.SpellBase:New({
        id = 386997,
        baseDuration = 8,
        isTalent = true,
    })
    self.phantomSingularity = TRB.Classes.SpellBase:New({
        id = 205179,
        baseDuration = 14.3,
        isTalent = true,
    })
    self.absoluteCorruption = TRB.Classes.SpellBase:New({
        id = 196103,
        isTalent = true,
        pvpDuration = 24,
        pvpPandemicTime = 24*0.3
    })
    self.malignOmen = TRB.Classes.SpellBase:New({
        id = 458043
    })
    self.shadowEmbraceShadowBolt = TRB.Classes.SpellBase:New({
        id = 453206,
        talentId = 32388,
        isTalent = true,
        maxStacks = 2
    })
    self.shadowEmbraceDrainSoul = TRB.Classes.SpellBase:New({
        id = 32390,
        talentId = 32388,
        isTalent = true,
        maxStacks = 4
    })
    self.drainSoul = TRB.Classes.SpellBase:New({
        id = 198590,
        talentId = 388667,
        isTalent = true
    })

    -- Hellcaller    
    self.wither = TRB.Classes.SpellBase:New({
        id = 445474,
        talentId = 445468,
        baseDuration = 18,
        pandemic = true,
        isTalent = true,
    })

    -- Soul Harvester
    self.succulentSoul = TRB.Classes.SpellBase:New({
        id = 449793
    })

    return self
end

---@class TRB.Classes.Warlock.DemonologySpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Warlock.DemonologySpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.DemonologySpells.__index = TRB.Classes.Warlock.DemonologySpells

function TRB.Classes.Warlock.DemonologySpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.DemonologySpells) --[[@as TRB.Classes.Warlock.DemonologySpells]]


    return self
end


---@class TRB.Classes.Warlock.DestructionSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Warlock.DestructionSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Warlock.DestructionSpells.__index = TRB.Classes.Warlock.DestructionSpells

function TRB.Classes.Warlock.DestructionSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Warlock.DestructionSpells) --[[@as TRB.Classes.Warlock.DestructionSpells]]


    return self
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
    barGroups.secondary = TRB.Classes.BarGroup:New(
        barGroups.primary:GetContainerFrame(),
        "TwintopResourceBarFrame_ComboPoint",
        5,
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
            isPrimary = true
        },
        secondary = {
            maxNodes = 5,
            isPrimary = false,
            resourceType = "SoulShards"
        }
    }
end