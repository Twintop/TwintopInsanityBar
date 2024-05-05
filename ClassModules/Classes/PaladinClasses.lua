local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 2 then --Only do this if we're on an Paladin!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Paladin = TRB.Classes.Paladin or {}


---@class TRB.Classes.Paladin.HolySpells : TRB.Classes.Healer.HealerSpells
---@field public infusionOfLight TRB.Classes.SpellBase
---@field public glimmerOfLight TRB.Classes.SpellBase
---@field public daybreak TRB.Classes.SpellThreshold
TRB.Classes.Paladin.HolySpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Paladin.HolySpells.__index = TRB.Classes.Paladin.HolySpells

function TRB.Classes.Paladin.HolySpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Paladin.HolySpells) --[[@as TRB.Classes.Paladin.HolySpells]]
    -- Paladin Class Baseline Abilities

    -- Holy Baseline Abilities
    self.infusionOfLight = TRB.Classes.SpellBase:New({
        id = 54149,
        isTalent = false,
        baseline = true
    })

    -- Paladin Class Talents		
    
    -- Holy Spec Talents
    self.glimmerOfLight = TRB.Classes.SpellBase:New({
        id = 287269,
        spellId = 287280,
        isTalent = true,
        isDot = true,
        isBuff = true,
        isDebuff = true,
        duration = 30,
        debuffId = 287280,
        buffId = 287280
    })
    self.daybreak = TRB.Classes.SpellThreshold:New({
        id = 414170,
        thresholdId = 8,
        settingKey = "daybreak",
        isTalent = true,
        resourcePercent = 0.008
    })

    return self
end