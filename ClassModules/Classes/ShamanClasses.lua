---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 7 then --Only do this if we're on a Shaman!
	return
end
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
---@field public flameShock TRB.Classes.SpellBase
---@field public lavaBurst TRB.Classes.SpellBase
---@field public frostShock TRB.Classes.SpellBase
---@field public hex TRB.Classes.SpellBase
---@field public inundate TRB.Classes.SpellBase
---@field public flowOfPower TRB.Classes.SpellBase
---@field public stormkeeper TRB.Classes.SpellBase
---@field public surgeOfPower TRB.Classes.SpellBase
---@field public echoesOfGreatSundering TRB.Classes.SpellBase
---@field public ascendance TRB.Classes.SpellBase
---@field public primalFracture TRB.Classes.SpellBase
---@field public lightningBolt TRB.Classes.Shaman.OverloadSpell
---@field public chainLightning TRB.Classes.Shaman.OverloadSpell
---@field public icefury TRB.Classes.Shaman.OverloadSpell
---@field public lavaBeam TRB.Classes.Shaman.OverloadSpell
---@field public earthShock TRB.Classes.SpellThreshold
---@field public earthquake TRB.Classes.SpellThreshold
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
        resource = 8,
        overload = 3,
        baseline = true,
        primalFracture = true
    })
    self.flameShock = TRB.Classes.SpellBase:New({
        id = 188389,
        baseDuration = 18,
        pandemic = true
    })

    -- Elemental Baseline Abilities


    -- Shaman Class Talent Abilities
    self.lavaBurst = TRB.Classes.SpellBase:New({
        id = 51505,
        resource = 10,
        isTalent = true,
        baseline = true,
        primalFracture = true
    })
    self.chainLightning = TRB.Classes.Shaman.OverloadSpell:New({
        id = 188443,
        resource = 4,
        overload = 3,
        isTalent = true,
        baseline = true
    })
    self.frostShock = TRB.Classes.SpellBase:New({
        id = 196840,
        resource = 14,
        isTalent = true,
        primalFracture = true
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
        thresholdId = 1,
        settingKey = "earthShock",
        isTalent = true,
        baseline = true,
        isSnowflake = true
    })
    self.earthquake = TRB.Classes.SpellThreshold:New({
        id = 61882,
        primaryResourceType = Enum.PowerType.Maelstrom,
        thresholdId = 2,
        settingKey = "earthquake",
        isTalent = true,
        isSnowflake = true
    })
    self.inundate = TRB.Classes.SpellBase:New({
        id = 378776,
        resource = 8,
        isTalent = true
    })
    self.flowOfPower = TRB.Classes.SpellBase:New({
        id = 385923,
        resourceMods = {
            base = {
                [0] = {
                    lightningBolt = 0,
                    lavaBurst = 0
                },
                [1] = {
                    lightningBolt = 2,
                    lavaBurst = 2
                }
            },
            overload = {
                [0] = {
                    lightningBolt = 0,
                    lavaBurst = 0
                },
                [1] = {
                    lightningBolt = 1,
                    lavaBurst = 1
                }
            }
        },
        isTalent = true
    })
    self.icefury = TRB.Classes.Shaman.OverloadSpell:New({
        id = 210714,
        resource = 25,
        overload = 12,
        stacks = 4,
        duration = 15,
        isTalent = true,
        primalFracture = true
    })
    self.stormkeeper = TRB.Classes.SpellBase:New({
        id = 191634,
        stacks = 2,
        duration = 15
    })
    self.surgeOfPower = TRB.Classes.SpellBase:New({
        id = 285514,
        isTalent = true
    })
    self.powerOfTheMaelstrom = TRB.Classes.SpellBase:New({
        id = 191877,
        isTalent = true
    })
    self.elementalBlast = TRB.Classes.SpellThreshold:New({
        id = 117014,
        primaryResourceType = Enum.PowerType.Maelstrom,
        thresholdId = 3,
        settingKey = "elementalBlast",
        isTalent = true,
        isSnowflake = true
    })
    self.echoesOfGreatSundering = TRB.Classes.SpellBase:New({
        id = 384088,
        isTalent = true
    })
    self.ascendance = TRB.Classes.SpellBase:New({
        id = 114050,
        isTalent = true
    })
    self.lavaBeam = TRB.Classes.Shaman.OverloadSpell:New({
        id = 114074,
        resource = 4, --Tooltip says 3, but spell ID 217891 and in game says 4
        overload = 3
    })

    --TODO: Add Searing Flames passive resource

    self.primalFracture = TRB.Classes.SpellBase:New({ -- T30 4P
        id = 410018,
        resourcePercent = 1.5
    })

    return self
end


---@class TRB.Classes.Shaman.EnhancementSpells : TRB.Classes.SpecializationSpellsBase
---@field public flameShock TRB.Classes.SpellBase
---@field public ascendance TRB.Classes.SpellBase
TRB.Classes.Shaman.EnhancementSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Shaman.EnhancementSpells.__index = TRB.Classes.Shaman.EnhancementSpells

function TRB.Classes.Shaman.EnhancementSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Shaman.EnhancementSpells) --[[@as TRB.Classes.Shaman.EnhancementSpells]]

    self.flameShock = TRB.Classes.SpellBase:New({
        id = 188389,
        baseDuration = 18,
        pandemic = true
    })
    self.ascendance = TRB.Classes.SpellBase:New({
        id = 114051,
        isTalent = true
    })

    return self
end


---@class TRB.Classes.Shaman.RestorationSpells : TRB.Classes.Healer.HealerSpells
---@field public resonantWaters TRB.Classes.SpellBase
---@field public flameShock TRB.Classes.SpellBase
---@field public ascendance TRB.Classes.SpellBase
TRB.Classes.Shaman.RestorationSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Shaman.RestorationSpells.__index = TRB.Classes.Shaman.RestorationSpells

function TRB.Classes.Shaman.RestorationSpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Shaman.RestorationSpells) --[[@as TRB.Classes.Shaman.RestorationSpells]]

    self.resonantWaters = TRB.Classes.SpellBase:New({
        id = 404539,
        isTalent = true,
        duration = 4,
    })
    self.flameShock = TRB.Classes.SpellBase:New({
        id = 188389,
        baseDuration = 18,
        pandemic = true
    })
    self.ascendance = TRB.Classes.SpellBase:New({
        id = 114052,
        isTalent = true
    })

    return self
end