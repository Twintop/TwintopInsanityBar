---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 5 then --Only do this if we're on a Priest!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Priest = TRB.Classes.Priest or {}

---@alias shadowfiendType
---| '"Shadowfiend"' # Shadowfiend
---| '"Mindbender"' # Mindbender
---| '"Voidwraith"' # Voidwraith

---@class TRB.Classes.Priest.ShadowfiendEntry : TRB.Classes.SpellBase
---@field public guid string # ID of the spawned Shadowfiend, Mindbender, or Voidwraith
---@field public totemId number # Totem that represents this spawn
---@field public spellId integer? # Spell Id of the spawn
---@field public type shadowfiendType? # Type of spawn
---@field public startTime number? # Timestamp the spawn started
---@field public duration number # Duration of the spawn
---@field public remaining number # Time remaining on the spawn
---@field public swingTime number? # Timestamp of last swing
---@field public remainingSwings number # Number of swings remaining before despawn
---@field public remainingGcds number # Number of GCDs remaining before despawn
---@field public remainingTime number # Time remaining before despawn
---@field public resourceRaw number # Amount of Mana or Insanity to be generated before despawn, before modifiers
---@field public resourceFinal number # Amount of Mana or Insanity to be generated before despawn, after modifiers
---@field private shadowfiend TRB.Classes.SpellBase # Shadowfiend spell
---@field private mindbender TRB.Classes.SpellBase? # Mindbender spell
---@field private voidwraith TRB.Classes.SpellBase? # Voidwraith spell
---@field private activeSpell TRB.Classes.SpellBase? # Spell of the active spawn
---@field private resourceCalculationFunction function # Function to call for resource gain calculations to get the "final" values
---@field private settings table # Shadowfiend settings
TRB.Classes.Priest.ShadowfiendEntry = {}
TRB.Classes.Priest.ShadowfiendEntry.__index = TRB.Classes.Priest.ShadowfiendEntry

---Creates a new ShadowfiendEntry object
---@param totemId number # Totem that represents this spawn
---@param resourceCalculationFunction function # Function to call for resource gain calculations to get the "final" values
---@param settings table # Shadowfiend settings
---@param shadowfiend TRB.Classes.SpellBase # Shadowfiend spell
---@param mindbender TRB.Classes.SpellBase? # Mindbender spell
---@param voidwraith TRB.Classes.SpellBase? # Voidwraith spell
---@return TRB.Classes.Priest.ShadowfiendEntry
function TRB.Classes.Priest.ShadowfiendEntry:New(totemId, resourceCalculationFunction, settings, shadowfiend, mindbender, voidwraith)
---@diagnostic disable-next-line: missing-fields
    local self = {} --[[@as TRB.Classes.Priest.ShadowfiendEntry]]
    self = setmetatable(self, TRB.Classes.Priest.ShadowfiendEntry)

    self.totemId = totemId
    self.resourceCalculationFunction = resourceCalculationFunction
    self.settings = settings
    self.shadowfiend = shadowfiend
    self.mindbender = mindbender
    self.voidwraith = voidwraith

    self:Reset()

    return self
end

---Resets the Shadowfiend snapshot to default/empty values
function TRB.Classes.Priest.ShadowfiendEntry:Reset()
    self.guid = nil
    self.startTime = nil
    self.duration = 0
    self.remaining = 0
    self.swingTime = nil
    self.remainingGcds = 0
    self.remainingSwings = 0
    self.remainingTime = 0
    self.resourceRaw = 0
    self.resourceFinal = 0
    self.spellId = nil
    self.activeSpell = nil
end

---Activates the entry with the guid provided and updates with initial values
---@param spellId integer # SpellId of the spawn
---@param guid string # Guid of the spawn
---@param currentTime number # Current timestamp
function TRB.Classes.Priest.ShadowfiendEntry:Activate(spellId, guid, currentTime)
    self.spellId = spellId
    self.guid = guid
    self.swingTime = currentTime
    self:Update()
end

---Gets Shadowfiend values based on current state of the spawn
---@return number # Time remaining on this spawn
---@return integer # Swings remaining
---@return integer # GCDs remaining
---@return number # Time until next melee swing
---@return number # Swing speed
function TRB.Classes.Priest.ShadowfiendEntry:GetShadowfiendValues()
	local currentTime = GetTime()
    local swingSpeed = 1.5 / (1 + (TRB.Data.snapshotData.attributes.haste / 100))
	local gcd = swingSpeed
	local swingsRemaining = 0
	local gcdsRemaining = 0

	if swingSpeed > 1.5 then
		swingSpeed = 1.5
	end

	local timeToNextSwing = swingSpeed - (currentTime - self.swingTime)
    local timeRemaining = self.startTime + self.duration - currentTime

	if timeToNextSwing < 0 then
		timeToNextSwing = 0
	elseif timeToNextSwing > 1.5 then
		timeToNextSwing = 1.5
	end

	swingsRemaining = math.ceil((self.remaining - timeToNextSwing) / swingSpeed)

	gcd = swingSpeed
	if gcd < 0.75 then
		gcd = 0.75
	end

	if self.remaining > (gcd * swingsRemaining) then
		gcdsRemaining = math.ceil(((gcd * swingsRemaining) - timeToNextSwing) / swingSpeed)
	else
		gcdsRemaining = math.ceil((timeRemaining - timeToNextSwing) / swingSpeed)
	end

	return timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed
end

function TRB.Classes.Priest.ShadowfiendEntry:Update()
    local haveTotem, name, startTime, duration, _ = GetTotemInfo(self.totemId)

    if haveTotem then
        if name == self.shadowfiend.name then
            self.type = "Shadowfiend"
            self.activeSpell = self.shadowfiend
        elseif name == self.mindbender.name then
            self.type = "Mindbender"
            self.activeSpell = self.mindbender
        elseif name == self.voidwraith.name then
            self.type = "Voidwraith"
            self.activeSpell = self.voidwraith
        else -- Sha Beast?
            if self.spellId == self.shadowfiend.id then
                self.type = "Shadowfiend"
                self.activeSpell = self.shadowfiend
            elseif self.mindbender ~= nil and self.spellId == self.mindbender.id then
                self.type = "Mindbender"
                self.activeSpell = self.mindbender
            elseif self.voidwraith ~= nil and self.spellId == self.voidwraith.id then
                self.type = "Voidwraith"
                self.activeSpell = self.voidwraith
            else
                self:Reset()
                return
            end
        end
    else
        if self.guid ~= nil then
            self:Reset()
        end
        return
    end

	local specId = GetSpecialization()
	local currentTime = GetTime()

    self.startTime = startTime
    self.duration = duration
    self.remaining = currentTime - startTime + duration

    local timeRemaining, swingsRemaining, gcdsRemaining, timeToNextSwing, swingSpeed = self:GetShadowfiendValues()
    self.remainingTime = timeRemaining
    self.remainingSwings = swingsRemaining
    self.remainingGcds = gcdsRemaining

    local countValue = 0

    if self.settings.mode == "swing" then
        if self.remainingSwings > self.settings.swingsMax then
            countValue = self.settings.swingsMax
        else
            countValue = self.remainingSwings
        end
    elseif self.settings.mode == "time" then
        if self.remainingTime > self.settings.timeMax then
            countValue = math.ceil((self.settings.timeMax - timeToNextSwing) / swingSpeed)
        else
            countValue = math.ceil((self.remainingTime - timeToNextSwing) / swingSpeed)
        end
    else --assume GCD
        if self.remainingGcds > self.settings.gcdsMax then
            countValue = self.settings.gcdsMax
        else
            countValue = self.remainingGcds
        end
    end

    if specId == 1 then
        self.resourceRaw = countValue * self.activeSpell.attributes.resourcePercent * TRB.Data.character.maxResource
        self.resourceFinal = self.resourceCalculationFunction(self.resourceRaw, false)
    elseif specId == 2 then
        self.resourceRaw = countValue * self.activeSpell.attributes.resourcePercent * TRB.Data.character.maxResource
        self.resourceFinal = self.resourceCalculationFunction(self.resourceRaw, false)
    elseif specId == 3 then
        self.resourceRaw = countValue * self.activeSpell.resource
        self.resourceFinal = self.resourceCalculationFunction(self.resourceRaw)
    end
end


---@class TRB.Classes.Priest.Shadowfiend : TRB.Classes.Snapshot
---@field public spawns { [integer]: TRB.Classes.Priest.ShadowfiendEntry } # Shadowfiend spawns by TotemId key
---@field public resourceRaw number # Total amount of Mana or Insanity to be generated before all despawn, before modifiers
---@field public resourceFinal number # Total amount of Mana or Insanity to be generated before all despawn, after modifiers
---@field public remainingSwings number # Maximum number of swings remaining before all despawn
---@field public remainingGcds number # Maximum number of GCDs remaining before all despawn
---@field public remainingTime number # Maximum time remaining before all despawn
---@field public shadowfiend TRB.Classes.SpellBase # Shadowfiend spell
---@field public mindbender TRB.Classes.SpellBase? # Mindbender spell
---@field public voidwraith TRB.Classes.SpellBase? # Voidwraith spell
---@field private settings table # Specialization specific settings
---@field private resourceCalculationFunction function # Function to call for resource gain calculations to get the "final" values
---@field private talents TRB.Classes.Talents # Talents list
TRB.Classes.Priest.Shadowfiend = setmetatable({}, {__index = TRB.Classes.Snapshot})
TRB.Classes.Priest.Shadowfiend.__index = TRB.Classes.Priest.Shadowfiend

---Creates a new Shadowfiend object
---@param settings table # Specialization specific settings
---@param resourceCalculationFunction function # Function to call for resource gain calculations to get the "final" values
---@param talents TRB.Classes.Talents # Talents list
---@param shadowfiend TRB.Classes.SpellBase # Shadowfiend spell
---@param mindbender TRB.Classes.SpellBase? # Mindbender spell
---@param voidwraith TRB.Classes.SpellBase? # Voidwraith spell
---@return TRB.Classes.Priest.Shadowfiend
function TRB.Classes.Priest.Shadowfiend:New(settings, talents, resourceCalculationFunction, shadowfiend, mindbender, voidwraith)
---@diagnostic disable-next-line: missing-fields
    ---@type TRB.Classes.Snapshot
    local snapshot = TRB.Classes.Snapshot
    self = setmetatable(snapshot:New(shadowfiend), {__index = TRB.Classes.Priest.Shadowfiend})

    self.settings = settings
    self.resourceCalculationFunction = resourceCalculationFunction
    self.talents = talents
    self.shadowfiend = shadowfiend
    self.mindbender = mindbender
    self.voidwraith = voidwraith
    self.spawns = {}
    self.remainingGcds = 0
    self.remainingSwings = 0
    self.remainingTime = 0
    
    for x = 1, 5 do
        self.spawns[x] = TRB.Classes.Priest.ShadowfiendEntry:New(x, resourceCalculationFunction, settings, shadowfiend, mindbender, voidwraith)
    end

    self.resourceRaw = 0
    self.resourceFinal = 0

    return self
end

function TRB.Classes.Priest.Shadowfiend:LogSwingTime(guid, currentTime)
    for x = 1, #self.spawns do
        if self.spawns[x].guid == guid then
            self.spawns[x].swingTime = currentTime
            return
        end
    end
end

---Updates all values of all Shadowfiend spawns
function TRB.Classes.Priest.Shadowfiend:Update()
    if self.settings.enabled then
        local resourceRaw = 0
        local resourceFinal = 0
        local remainingSwings = 0
        local remainingGcds = 0
        local remainingTime = 0
        
        for x = 1, #self.spawns do
            if self.spawns[x].guid ~= nil then -- Only update if we had a spawn tracked
                self.spawns[x]:Update()
                if self.spawns[x].guid ~= nil then -- Only update max values if we still have a spawn after update
                    resourceRaw = resourceRaw + self.spawns[x].resourceRaw
                    resourceFinal = resourceFinal + self.spawns[x].resourceFinal
                    remainingSwings = math.max(remainingSwings, self.spawns[x].remainingSwings)
                    remainingGcds = math.max(remainingGcds, self.spawns[x].remainingGcds)
                    remainingTime = math.max(remainingTime, self.spawns[x].remainingTime)
                end
            end
        end

        self.resourceRaw = resourceRaw
        self.resourceFinal = resourceFinal
        self.remainingSwings = remainingSwings
        self.remainingGcds = remainingGcds
        self.remainingTime = remainingTime

        self.cooldown:Refresh(true)
    end
end

---Is there currently a Shadowfiend, Mindbender, or Voidwraith spawned?
---@return boolean
function TRB.Classes.Priest.Shadowfiend:IsAnyActive()
    for x = 1, #self.spawns do
        if self.spawns[x].guid ~= nil then
            return true
        end
    end
    return false
end

---Gets a count of the currently active spawns
---@return integer # Count of currently active spawns
function TRB.Classes.Priest.Shadowfiend:TotalActive()
    local count = 0
    for x = 1, #self.spawns do
        if self.spawns[x].guid ~= nil then
            count = count + 1
        end
    end
    return count
end

---Gets the theoretical maximum values for the talented spawn type
---@return number # Time remaining on this spawn
---@return integer # Swings remaining
---@return integer # GCDs remaining
---@return number # Time until next melee swing
---@return number # Swing speed
function TRB.Classes.Priest.Shadowfiend:GetMaximumValues()
    local specId = GetSpecialization()
    local spell = nil

    if specId == 1 or specId == 3 then
        if self.talents:IsTalentActive(self.voidwraith) then
            spell = self.voidwraith
        elseif self.talents:IsTalentActive(self.mindbender) then
            spell = self.mindbender
        else
            spell = self.shadowfiend
        end
    elseif specId == 2 then
        if self.talents:IsTalentActive(self.shadowfiend) then
            spell = self.shadowfiend
        end
    end
    
    if spell == nil then
        return 0, 0, 0, 0, 0
    end

---@diagnostic disable-next-line: missing-fields
    return TRB.Classes.Priest.ShadowfiendEntry.GetShadowfiendValues({
        swingTime = GetTime(),
        remaining = spell.duration,
        duration = spell.duration,
        startTime = GetTime()
    })
end


---@class TRB.Classes.Priest.HolyWordSpell : TRB.Classes.SpellBase
---@field public holyWordKey string? # Holy Word spell key that has its cooldown reduced on cast.
---@field public holyWordReduction number? # How much the associated Holy Word will have its cooldown reduced.
---@field public holyWordModifier number? # Modification of the reduction when included with related casts.
TRB.Classes.Priest.HolyWordSpell = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.Priest.HolyWordSpell.__index = TRB.Classes.Priest.HolyWordSpell

---Creates a new HolyWordSpell object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.Priest.HolyWordSpell
function TRB.Classes.Priest.HolyWordSpell:New(spellAttributes)
    ---@type TRB.Classes.SpellBase
    local spellBase = TRB.Classes.SpellBase
    self = setmetatable(spellBase:New(spellAttributes), {__index = TRB.Classes.Priest.HolyWordSpell})

    table.insert(self.classTypes, "TRB.Classes.Priest.HolyWordSpell")
    
    self.holyWordModifier = 1
    self.holyWordReduction = 0

    for key, value in pairs(spellAttributes) do
        if  (key == "holyWordReduction" and type(value) == "number") or
            (key == "holyWordModifier"  and type(value) == "number") or
            (key == "holyWordKey") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end


---@class TRB.Classes.Priest.HealerSpells : TRB.Classes.Healer.HealerSpells
---@field public shadowWordPain TRB.Classes.SpellBase
---@field public surgeOfLight TRB.Classes.SpellBase
---@field public shadowfiend TRB.Classes.SpellThreshold
---@field public cannibalize TRB.Classes.SpellThreshold
TRB.Classes.Priest.HealerSpells = setmetatable({}, {__index = TRB.Classes.Healer.HealerSpells})
TRB.Classes.Priest.HealerSpells.__index = TRB.Classes.Priest.HealerSpells

function TRB.Classes.Priest.HealerSpells:New()
    ---@type TRB.Classes.Healer.HealerSpells
    local base = TRB.Classes.Healer.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Priest.HealerSpells) --[[@as TRB.Classes.Priest.HealerSpells]]

    -- Priest Class Baseline Abilities
    self.shadowWordPain = TRB.Classes.SpellBase:New({
        id = 589,
        baseDuration = 16,
        pandemic = true,
        isTalent = false,
        baseline = true
    })

    -- Priest Talent Abilities
    self.shadowfiend = TRB.Classes.SpellThreshold:New({
        id = 34433,
        iconName = "spell_shadow_shadowfiend",
        energizeId = 343727,
        settingKey = "shadowfiend",
        primaryResourceType = Enum.PowerType.Mana,
        isTalent = true,
        baseline = false,
        resourcePercent = 0.005,
        duration = 15,
        hasCooldown = true
    })
    self.surgeOfLight = TRB.Classes.SpellBase:New({
        id = 114255,
        duration = 20,
        isTalent = true
    })

    -- Racials
    self.cannibalize = TRB.Classes.SpellThreshold:New({
        id = 20577,
        buffId = 20578,
        baseline = true,
        resourcePerTick = 0.07,
        duration = 10,
        hasTicks = true,
        tickRate = 2,
        settingKey = "cannibalize",
        primaryResourceType = Enum.PowerType.Mana,
        isSnowflake = true,
        hasCooldown = true
    })

    return self
end


---@class TRB.Classes.Priest.DisciplineSpells : TRB.Classes.Priest.HealerSpells
---@field public atonement TRB.Classes.SpellBase
---@field public evangelism TRB.Classes.SpellBase
---@field public powerWordRadiance TRB.Classes.SpellBase
---@field public lightsPromise TRB.Classes.SpellBase
---@field public rapture TRB.Classes.SpellBase
---@field public shadowCovenant TRB.Classes.SpellBase
---@field public purgeTheWicked TRB.Classes.SpellBase
---@field public entropicRift TRB.Classes.SpellBase
---@field public depthOfShadows TRB.Classes.SpellBase
---@field public mindbender TRB.Classes.SpellThreshold
---@field public voidwraith TRB.Classes.SpellThreshold
TRB.Classes.Priest.DisciplineSpells = setmetatable({}, {__index = TRB.Classes.Priest.HealerSpells})
TRB.Classes.Priest.DisciplineSpells.__index = TRB.Classes.Priest.DisciplineSpells

function TRB.Classes.Priest.DisciplineSpells:New()
    ---@type TRB.Classes.Priest.HealerSpells
    local base = TRB.Classes.Priest.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Priest.DisciplineSpells) --[[@as TRB.Classes.Priest.DisciplineSpells]]

    -- Priest Class Baseline Abilities
    self.shadowWordPain = TRB.Classes.SpellBase:New({
        id = 589,
        baseDuration = 16,
        pandemic = true,
        isTalent = false,
        baseline = true
    })

    self.shadowfiend.baseline = true
    self.shadowfiend.primaryResourceType = Enum.PowerType.Mana
    
    -- Discipline Baseline Abilities

    -- Priest Talent Abilities

    -- Discipline Talent Abilities
    self.atonement = TRB.Classes.SpellBase:New({
        id = 194384,
        isTalent = true,
        isBuff = true,
        duration = 15
    })
    self.evangelism = TRB.Classes.SpellBase:New({
        id = 246287,
        atonementMod = 6
    })
    self.powerWordRadiance = TRB.Classes.SpellBase:New({
        id = 194509,
        isTalent = true,
        hasCharges = true
    })
    self.lightsPromise = TRB.Classes.SpellBase:New({
        id = 322115,
        isTalent = true
    })
    self.rapture = TRB.Classes.SpellBase:New({
        id = 47536,
        isTalent = true
    })
    self.shadowCovenant = TRB.Classes.SpellBase:New({
        id = 322105,
        talentId = 314867,
        isTalent = true
    })
    self.purgeTheWicked = TRB.Classes.SpellBase:New({
        id = 204213,
        talentId = 204197,
        baseDuration = 20,
        pandemic = true,
        isTalent = true,
    })
    self.mindbender = TRB.Classes.SpellThreshold:New({
        id = 123040,
        iconName = "spell_shadow_soulleech_3",
        energizeId = 123051,
        settingKey = "mindbender",
        primaryResourceType = Enum.PowerType.Mana,
        isTalent = true,
        duration = 12,
        resourcePercent = 0.002
    })

    -- Voidweaver
    self.entropicRift = TRB.Classes.SpellBase:New({
        id = 450193,
        talentId = 447444,
        isTalent = true,
        duration = 8
    })
    self.depthOfShadows = TRB.Classes.SpellBase:New({
        id = 451308,
        isTalent = true
    })
    self.voidwraith = TRB.Classes.SpellThreshold:New({
        id = 451235,
        talentId = 451234,
        settingKey = "voidwraith",
        energizeId = 262485,
        primaryResourceType = Enum.PowerType.Mana,
        isTalent = true,
        duration = 15,
        resourcePercent = 0.005
    })
    
    return self
end


---@class TRB.Classes.Priest.HolySpells : TRB.Classes.Priest.HealerSpells
---@field public flashHeal TRB.Classes.SpellBase
---@field public holyWordSerenity TRB.Classes.SpellBase
---@field public holyWordChastise TRB.Classes.SpellBase
---@field public holyWordSanctify TRB.Classes.SpellBase
---@field public resonantWords TRB.Classes.SpellBase
---@field public lightweaver TRB.Classes.SpellBase
---@field public miracleWorker TRB.Classes.SpellBase
---@field public sacredReverence TRB.Classes.SpellBase
---@field public voiceOfHarmony TRB.Classes.SpellBase
---@field public lightwell TRB.Classes.SpellBase
---@field public symbolOfHope TRB.Classes.SpellThreshold
---@field public smite TRB.Classes.Priest.HolyWordSpell
---@field public heal TRB.Classes.Priest.HolyWordSpell
---@field public prayerOfMending TRB.Classes.Priest.HolyWordSpell
---@field public renew TRB.Classes.Priest.HolyWordSpell
---@field public prayerOfHealing TRB.Classes.Priest.HolyWordSpell
---@field public holyFire TRB.Classes.Priest.HolyWordSpell
---@field public circleOfHealing TRB.Classes.Priest.HolyWordSpell
---@field public lightOfTheNaaru TRB.Classes.Priest.HolyWordSpell
---@field public apotheosis TRB.Classes.Priest.HolyWordSpell
TRB.Classes.Priest.HolySpells = setmetatable({}, {__index = TRB.Classes.Priest.HealerSpells})
TRB.Classes.Priest.HolySpells.__index = TRB.Classes.Priest.HolySpells

function TRB.Classes.Priest.HolySpells:New()
    ---@type TRB.Classes.Priest.HealerSpells
    local base = TRB.Classes.Priest.HealerSpells
    self = setmetatable(base:New(), TRB.Classes.Priest.HolySpells) --[[@as TRB.Classes.Priest.HolySpells]]

    -- Priest Class Baseline Abilities
    self.flashHeal = TRB.Classes.Priest.HolyWordSpell:New({
        id = 2061,
        holyWordKey = "holyWordSerenity",
        holyWordReduction = 6,
        isTalent = false,
        baseline = true
    })
    self.smite = TRB.Classes.Priest.HolyWordSpell:New({
        id = 585,
        holyWordKey = "holyWordChastise",
        holyWordReduction = 4,
        isTalent = false,
        baseline = true
    })

    -- Holy Baseline Abilities
    self.heal = TRB.Classes.Priest.HolyWordSpell:New({
        id = 2060,
        holyWordKey = "holyWordSerenity",
        holyWordReduction = 6,
        isTalent = false,
        baseline = true
    })

    self.prayerOfMending = TRB.Classes.Priest.HolyWordSpell:New({
        id = 33076,
        holyWordKey = "holyWordSerenity",
        holyWordReduction = 2, -- Per rank of Voice of Harmony
        isTalent = true,
        baseline = true
    })
    self.renew = TRB.Classes.Priest.HolyWordSpell:New({
        id = 139,
        holyWordKey = "holyWordSanctify",
        holyWordReduction = 2,
        isTalent = true,
        baseline = true
    })

    -- Holy Talent Abilities
    self.holyWordSerenity = TRB.Classes.SpellBase:New({
        id = 2050,
        duration = 60,
        hasCharges = true
    })
    self.prayerOfHealing = TRB.Classes.Priest.HolyWordSpell:New({
        id = 596,
        holyWordKey = "holyWordSanctify",
        holyWordReduction = 6,
        isTalent = true
    })
    self.holyWordChastise = TRB.Classes.SpellBase:New({
        id = 88625,
        duration = 60,
        isTalent = true
    })
    self.holyWordSanctify = TRB.Classes.SpellBase:New({
        id = 34861,
        duration = 60,
        isTalent = true,
        hasCharges = true
    })
    self.holyFire = TRB.Classes.Priest.HolyWordSpell:New({
        id = 14914,
        holyWordKey = "holyWordChastise",
        holyWordReduction = 2, -- Per rank of Voice of Harmony
        isTalent = true
    })
    self.circleOfHealing = TRB.Classes.Priest.HolyWordSpell:New({
        id = 204883,
        holyWordKey = "holyWordSanctify",
        holyWordReduction = 2, -- Per rank of Voice of Harmony
        isTalent = true
    })
    self.symbolOfHope = TRB.Classes.SpellThreshold:New({
        id = 64901,
        duration = 4.0, --Hasted
        resourcePercent = 0.02,
        settingKey = "symbolOfHope",
        primaryResourceType = Enum.PowerType.Mana,
        ticks = 4,
        tickId = 265144,
        isTalent = true,
        hasCooldown = true
    })
    self.lightOfTheNaaru = TRB.Classes.Priest.HolyWordSpell:New({
        id = 196985,
        holyWordModifier = 0.1, -- Per rank
        isTalent = true
    })
    self.voiceOfHarmony = TRB.Classes.SpellBase:New({
        id = 390994,
        isTalent = true
    })
    self.apotheosis = TRB.Classes.Priest.HolyWordSpell:New({
        id = 200183,
        holyWordModifier = 4, -- 300% more
        duration = 20,
        isTalent = true
    })
    self.resonantWords = TRB.Classes.SpellBase:New({
        id = 372313,
        talentId = 372309,
        isTalent = true
    })
    self.lightweaver = TRB.Classes.SpellBase:New({
        id = 390993,
        talentId = 390992,
        isTalent = true
    })
    self.miracleWorker = TRB.Classes.SpellBase:New({
        id = 235587,
        isTalent = true
    })
    self.lightwell = TRB.Classes.SpellBase:New({
        id = 372835,
        isTalent = true
    })

    -- Set Bonuses
    self.sacredReverence = TRB.Classes.SpellBase:New({ -- T31 4P
        id = 423510,
    })

    self.shadowfiend.primaryResourceType = Enum.PowerType.Mana

    -- Archon
    self.resonantEnergy = TRB.Classes.SpellBase:New({
        id = 453845,
        debuffId = 453850,
        isTalent = true,
        duration = 8,
        hasStacks = true,
        maxStacks = 5
    })

    return self
end


---@class TRB.Classes.Priest.ShadowSpells : TRB.Classes.SpecializationSpellsBase
---@field public mindBlast TRB.Classes.SpellBase
---@field public shadowWordPain TRB.Classes.SpellBase
---@field public mindFlay TRB.Classes.SpellBase
---@field public vampiricTouch TRB.Classes.SpellBase
---@field public voidBolt TRB.Classes.SpellBase
---@field public shadowfiend TRB.Classes.SpellBase
---@field public massDispel TRB.Classes.SpellBase
---@field public twistOfFate TRB.Classes.SpellBase
---@field public halo TRB.Classes.SpellBase
---@field public mindgames TRB.Classes.SpellBase
---@field public shadowyApparition TRB.Classes.SpellBase
---@field public auspiciousSpirits TRB.Classes.SpellBase
---@field public misery TRB.Classes.SpellBase
---@field public hallucinations TRB.Classes.SpellBase
---@field public voidEruption TRB.Classes.SpellBase
---@field public voidform TRB.Classes.SpellBase
---@field public darkAscension TRB.Classes.SpellBase
---@field public mindSpike TRB.Classes.SpellBase
---@field public surgeOfInsanity TRB.Classes.SpellBase
---@field public mindFlayInsanity TRB.Classes.SpellBase
---@field public mindSpikeInsanity TRB.Classes.SpellBase
---@field public deathspeaker TRB.Classes.SpellBase
---@field public voidTorrent TRB.Classes.SpellBase
---@field public shadowCrash TRB.Classes.SpellBase
---@field public voidCrash TRB.Classes.SpellBase
---@field public shadowyInsight TRB.Classes.SpellBase
---@field public mindMelt TRB.Classes.SpellBase
---@field public mindbender TRB.Classes.SpellBase
---@field public devouredDespair TRB.Classes.SpellBase
---@field public mindDevourer TRB.Classes.SpellBase
---@field public idolOfCthun TRB.Classes.SpellBase
---@field public idolOfCthun_Tendril TRB.Classes.SpellBase
---@field public idolOfCthun_Lasher TRB.Classes.SpellBase
---@field public lashOfInsanity_Tendril TRB.Classes.SpellBase
---@field public lashOfInsanity_Lasher TRB.Classes.SpellBase
---@field public idolOfYoggSaron TRB.Classes.SpellBase
---@field public thingFromBeyond TRB.Classes.SpellBase
---@field public resonantEnergy TRB.Classes.SpellBase
---@field public entropicRift TRB.Classes.SpellBase
---@field public voidBlast TRB.Classes.SpellBase
---@field public voidInfusion TRB.Classes.SpellBase
---@field public depthOfShadows TRB.Classes.SpellBase
---@field public voidwraith TRB.Classes.SpellBase
---@field public devouringPlague TRB.Classes.SpellThreshold
---@field public devouringPlague2 TRB.Classes.SpellThreshold
---@field public devouringPlague3 TRB.Classes.SpellThreshold
TRB.Classes.Priest.ShadowSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Priest.ShadowSpells.__index = TRB.Classes.Priest.ShadowSpells

function TRB.Classes.Priest.ShadowSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), TRB.Classes.Priest.ShadowSpells) --[[@as TRB.Classes.Priest.ShadowSpells]]

    -- Priest Class Baseline Abilities
    self.mindBlast = TRB.Classes.SpellBase:New({
        id = 8092,
        resource = 6,
        isTalent = false,
        baseline = true,
        hasCharges = true
    })
    self.shadowWordPain = TRB.Classes.SpellBase:New({
        id = 589,
        resource = 3,
        baseDuration = 16,
        pandemic = true,
        isTalent = false,
        baseline = true,
        miseryPandemic = 21,
        miseryPandemicTime = 21 * 0.3,
    })

    -- Shadow Baseline Abilities
    self.mindFlay = TRB.Classes.SpellBase:New({
        id = 15407,
        resource = 2,
        isTalent = false,
        baseline = true
    })
    self.vampiricTouch = TRB.Classes.SpellBase:New({
        id = 34914,
        resource = 4,
        baseDuration = 21,
        pandemic = true,
        isTalent = false,
        baseline = true
    })
    self.voidBolt = TRB.Classes.SpellBase:New({
        id = 205448,
        resource = 10,
        isTalent = false,
        baseline = true
    })


    -- Priest Talent Abilities			
    self.shadowfiend = TRB.Classes.SpellBase:New({
        id = 34433,
        iconName = "spell_shadow_shadowfiend",
        energizeId = 279420,
        resource = 2,
        isTalent = true,
        baseline = true
    })
    self.massDispel = TRB.Classes.SpellBase:New({
        id = 32375,
        isTalent = true
    })
    self.twistOfFate = TRB.Classes.SpellBase:New({
        id = 390978,
        isTalent = true
    })
    self.halo = TRB.Classes.SpellBase:New({
        id = 120644,
        isTalent = true,
        resource = 10
    })

    -- Shadow Talent Abilities			
    self.devouringPlague = TRB.Classes.SpellThreshold:New({
        id = 335467,
        primaryResourceType = Enum.PowerType.Insanity,
        settingKey = "devouringPlague",
        isTalent = true,
        isSnowflake = true
    })
    self.devouringPlague2 = TRB.Classes.SpellThreshold:New({
        id = 335467,
        primaryResourceType = Enum.PowerType.Insanity,
        primaryResourceTypeMod = 2,
        settingKey = "devouringPlague2",
        isTalent = true,
        isSnowflake = true
    })
    self.devouringPlague3 = TRB.Classes.SpellThreshold:New({
        id = 335467,
        primaryResourceType = Enum.PowerType.Insanity,
        primaryResourceTypeMod = 3,
        settingKey = "devouringPlague3",
        isTalent = true,
        isSnowflake = true
    })
    self.shadowyApparition = TRB.Classes.SpellBase:New({
        id = 341491,
        isTalent = true
    })
    self.auspiciousSpirits = TRB.Classes.SpellBase:New({
        id = 155271,
        idSpawn = 341263,
        idImpact = 413231,
        resource = 1,
        targetChance = function(num)
            if num == 0 then
                return 0
            else
                return 0.8*(num^(-0.8))
            end
        end,
        isTalent = true
    })
    self.misery = TRB.Classes.SpellBase:New({
        id = 238558,
        isTalent = true
    })
    self.hallucinations = TRB.Classes.SpellBase:New({
        id = 280752,
        resource = 4,
        isTalent = true
    })
    self.voidEruption = TRB.Classes.SpellBase:New({
        id = 228260,
        isTalent = true
    })
    self.voidform = TRB.Classes.SpellBase:New({
        id = 194249,
        isTalent = true
    })
    self.darkAscension = TRB.Classes.SpellBase:New({
        id = 391109,
        resource = 30,
        isTalent = true
    })
    self.mindSpike = TRB.Classes.SpellBase:New({
        id = 73510,
        resource = 4,
        isTalent = true
    })
    self.surgeOfInsanity = TRB.Classes.SpellBase:New({
        id = 391399,
        isTalent = true
    })
    self.mindFlayInsanity = TRB.Classes.SpellBase:New({
        id = 391403,
        buffId = 391401,
        resource = 3,
        isTalent = true
    })
    self.mindSpikeInsanity = TRB.Classes.SpellBase:New({
        id = 407466,
        buffId = 407468,
        talentId = 391403,
        resource = 12,
        isTalent = true
    })
    self.deathspeaker = TRB.Classes.SpellBase:New({
        id = 392507,
        buffId = 392511,
        isTalent = true
    })
    self.voidTorrent = TRB.Classes.SpellBase:New({
        id = 263165,
        resource = 6,
        isTalent = true
    })
    self.shadowCrash = TRB.Classes.SpellBase:New({
        id = 205385,
        resource = 6,
        isTalent = true
    })
    self.voidCrash = TRB.Classes.SpellBase:New({
        id = 457042,
        resource = 6,
        isTalent = true
    })
    self.shadowyInsight = TRB.Classes.SpellBase:New({
        id = 375981,
        isTalent = true
    })
    self.mindMelt = TRB.Classes.SpellBase:New({
        id = 391092,
        isTalent = true
    })
    self.mindbender = TRB.Classes.SpellBase:New({
        id = 200174,
        iconName = "spell_shadow_soulleech_3",
        energizeId = 200010,
        resource = 2,
        isTalent = true
    })
    self.devouredDespair = TRB.Classes.SpellBase:New({ -- Idol of Y'Shaarj proc
        id = 373317,
        resource = 5,
        resourcePerTick = 5,
        tickRate = 1,
        hasTicks = true
    })
    self.mindDevourer = TRB.Classes.SpellBase:New({
        id = 373202,
        buffId = 373204,
        isTalent = true
    })
    self.idolOfCthun = TRB.Classes.SpellBase:New({
        id = 377349,
    })
    self.idolOfCthun_Tendril = TRB.Classes.SpellBase:New({
        id = 377355,
        tickId = 193473,
    })
    self.idolOfCthun_Lasher = TRB.Classes.SpellBase:New({
        id = 377357,
        tickId = 394979,
    })
    self.lashOfInsanity_Tendril = TRB.Classes.SpellBase:New({
        id = 344838,
        resource = 1,
        duration = 15,
        ticks = 10,
        tickDuration = 1.5
    })
    self.lashOfInsanity_Lasher = TRB.Classes.SpellBase:New({
        id = 344838, --Doesn't actually exist / unused?
        resource = 1,
        duration = 15,
        ticks = 10,
        tickDuration = 1.5
    })
    self.idolOfYoggSaron = TRB.Classes.SpellBase:New({
        id = 373276,
        talentId = 373273,
        isTalent = true,
        requiredStacks = 25
    })
    self.thingFromBeyond = TRB.Classes.SpellBase:New({
        id = 373277,
        isTalent = true,
        duration = 20
    })

    -- Archon
    self.resonantEnergy = TRB.Classes.SpellBase:New({
        id = 453845,
        debuffId = 453850,
        isTalent = true,
        duration = 8,
        hasStacks = true,
        maxStacks = 5
    })

    -- Voidweaver
    self.entropicRift = TRB.Classes.SpellBase:New({
        id = 450193,
        talentId = 447444,
        isTalent = true,
        duration = 8
    })
    self.voidBlast = TRB.Classes.SpellBase:New({
        id = 450983,
        talentId = 450405,
        resource = 6,
        isTalent = true,
        hasCharges = true
    })
    self.voidInfusion = TRB.Classes.SpellBase:New({
        id = 450612,
        resourceMod = 2,
        isTalent = true
    })
    self.depthOfShadows = TRB.Classes.SpellBase:New({
        id = 451308,
        isTalent = true
    })
    self.voidwraith = TRB.Classes.SpellBase:New({
        id = 451235,
        talentId = 451234,
        energizeId = 262485,
        resource = 2,
        isTalent = true
    })

    -- PvP Talents
    self.mindgames = TRB.Classes.SpellBase:New({
        id = 375901,
        isTalent = true,
        resource = 10,
        isPvp = true
    })

    return self
end