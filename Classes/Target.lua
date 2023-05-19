---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.TimeToDieSnapshot
---@field public health number
---@field public time number
---@field public dps number
TRB.Classes.TimeToDieSnapshot = {}
TRB.Classes.TimeToDieSnapshot.__index = TRB.Classes.TimeToDieSnapshot

---Create a new TimeToDieSnapshot
---@param health number # Current health percentage
---@param time number # Timestamp of this sample
---@param dps number # DPS since the previous sample was taken
---@return TRB.Classes.TimeToDieSnapshot
function TRB.Classes.TimeToDieSnapshot:New(health, time, dps)
    local self = {}
    setmetatable(self, TRB.Classes.TimeToDieSnapshot)
    self.health = health
    self.time = time
    self.dps = dps
    return self
end


---@class TRB.Classes.TimeToDie
---@field public guid string
---@field public time number
---@field public lastUpdate number?
---@field public deathPercent number
---@field public snapshots TRB.Classes.TimeToDieSnapshot[]
---@field private settings table
TRB.Classes.TimeToDie = {}
TRB.Classes.TimeToDie.__index = TRB.Classes.TimeToDie

---Create a new TimeToDie tracking object
---@param guid string # GUID of the unit we are tracking the TTD of
---@return TRB.Classes.TimeToDie
function TRB.Classes.TimeToDie:New(guid)
    local self = {}
    setmetatable(self, TRB.Classes.TimeToDie)
    self.guid = guid
    self.time = 0
    self.deathPercent = TRB.Functions.TimeToDie:GetDeathHealthPercentage(guid)
    ---@type TRB.Classes.TimeToDieSnapshot[]
    self.snapshots = {}
    ---@type table
    self.settings = TRB.Data.settings.core.ttd
    return self
end

---Attempts to update the Time To Die for this creature. May fail if this creature does not have a current UnitToken.
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.TimeToDie:Update(currentTime)
    currentTime = currentTime or GetTime()
    -- TODO: Look in to hooking in to nameplates to get the info we need for this
    local unitToken = UnitTokenFromGUID(self.guid)

    if unitToken ~= nil then
        local currentHealth = UnitHealth(unitToken)
        local maxHealth = UnitHealthMax(unitToken)
        local healthDelta = 0
        local timeDelta = 0
        local dps = 0
        local ttd = 0
        local count = TRB.Functions.Table:Length(self.snapshots)

        if count > 0 and self.snapshots[1] ~= nil then
            healthDelta = math.max(self.snapshots[1].health - currentHealth, 0)
            timeDelta = math.max(currentTime - self.snapshots[1].time, 0)
        end

        if currentHealth <= 0 or maxHealth <= 0 then
            dps = 0
            ttd = 0
        else
            if count == 0 or self.snapshots[count] == nil or
                (self.snapshots[1].health == currentHealth and count == self.settings.numEntries) then
                dps = 0
            elseif healthDelta == 0 or timeDelta == 0 then
                dps = self.snapshots[count].dps
            else
                dps = healthDelta / timeDelta
            end

            if dps == nil or dps == 0 then
                ttd = 0
            else
                local deathHealth = maxHealth * self.deathPercent
                ttd = math.max(math.max(currentHealth - deathHealth, 0) / dps, 0)
            end
        end

        self.lastUpdate = currentTime

        if count >= self.settings.numEntries then
            self:RemoveOldestSnapshot()
        end

        self:AddSnapshot(currentHealth, currentTime, dps)

        self.time = ttd
    end
end

---Removes the oldest entry from the TTD snapshot table
function TRB.Classes.TimeToDie:RemoveOldestSnapshot()
    table.remove(self.snapshots, 1)
end

---Adds a new entry to the end of the TTD snapshot table
---@param health number # Current health percentage
---@param time number # Timestamp of this sample
---@param dps number # DPS since the previous sample was taken
function TRB.Classes.TimeToDie:AddSnapshot(health, time, dps)
    local snapshot = TRB.Classes.TimeToDieSnapshot:New(health, time, dps)
    table.insert(self.snapshots, snapshot)
end


---@class TRB.Classes.TargetSpell
---@field public id integer
---@field public active boolean
---@field public remainingTime number
---@field public isDot boolean
---@field public hasCounter boolean
---@field public count integer
---@field public hasSnapshot boolean
---@field public snapshot number
TRB.Classes.TargetSpell = {}
TRB.Classes.TargetSpell.__index = TRB.Classes.TargetSpell

---Adds a new spell to be tracked against a target
---@param spellId integer # Spell ID we are tracking
---@param isDot boolean? # Is this a DoT?
---@param hasCounter boolean? # Does this have a counter component to it?
---@param hasSnapshot boolean? # Is there any snapshotting required?
---@return TRB.Classes.TargetSpell
function TRB.Classes.TargetSpell:New(spellId, isDot, hasCounter, hasSnapshot)
    local self = {}
    setmetatable(self, TRB.Classes.TargetSpell)
    self.id = spellId
    self.active = false
    self.isDot = isDot
    self.remainingTime = 0.0
    self.hasCounter = hasCounter
    self.count = 0
    self.hasSnapshot = hasSnapshot
    self.snapshot = 0.0
    return self
end

---Updates this spell's snapshotting
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.TargetSpell:Update(currentTime)
	currentTime = currentTime or GetTime()
    if self.isDot then
        local expiration = select(6, TRB.Functions.Aura:FindDebuffById(self.id, "target", "player"))

        if expiration ~= nil then
            self.active = true
            self.remainingTime = expiration - currentTime
            return
        end
    end
end


---@class TRB.Classes.Target
---@field public guid string
---@field public timeToDie TRB.Classes.TimeToDie
---@field public lastUpdate number?
---@field public spells TRB.Classes.TargetSpell[]
TRB.Classes.Target = {}
TRB.Classes.Target.__index = TRB.Classes.Target

function TRB.Classes.Target:New(guid)
    local self = {}
    setmetatable(self, TRB.Classes.Target)
    self.guid = guid
    self.timeToDie = TRB.Classes.TimeToDie:New(guid)
    self.lastUpdate = nil
    self.spells = {}
    return self
end

---Adds a new spell to be tracked against a target
---@param spell table # Spell we are tracking
---@param isDot boolean? # Is this a DoT?
---@param hasCounter boolean? # Does this have a counter component to it?
---@param hasSnapshot boolean? # Is there any snapshotting required?
function TRB.Classes.Target:AddSpellTracking(spell, isDot, hasCounter, hasSnapshot)
    isDot = isDot or true
    hasCounter = hasCounter or false
    hasSnapshot = hasSnapshot or false
    if self.spells[spell.id] == nil then
		self.spells[spell.id] = TRB.Classes.TargetSpell:New(spell.id, isDot, hasCounter, hasSnapshot)
	end
end

---Updates all spells tracked on this target
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.Target:UpdateAllSpellTracking(currentTime)
	currentTime = currentTime or GetTime()
    if TRB.Functions.Table:Length(self.spells) > 0 then
        for spellId, _ in pairs(self.spells) do
            if self.spells[spellId] ~= nil then
                self.spells[spellId]:Update(currentTime)
            end
        end
    end
end