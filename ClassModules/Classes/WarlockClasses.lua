local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 9 then --Only do this if we're on an Warlock!
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
---@field public absoluteCorruption TRB.Classes.SpellBase
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

    -- Hellcaller    
    self.wither = TRB.Classes.SpellBase:New({
        id = 445474,
        talentId = 445468,
        baseDuration = 18,
        pandemic = true,
        isTalent = true,
    })

    return self
end
