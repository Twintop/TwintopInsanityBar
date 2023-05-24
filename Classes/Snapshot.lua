---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.SnapshotData
---@field public targetData TRB.Classes.TargetData
---@field public snapshots TRB.Classes.Snapshot[]
---@field public casting TRB.Classes.SnapshotCasting
---@field public audio table
---@field public attributes table
TRB.Classes.SnapshotData = {}
TRB.Classes.SnapshotData.__index = TRB.Classes.SnapshotData

---Creates a new SnapshotData object
---@param attributes table # Custom attributes to be tracked
---@return TRB.Classes.SnapshotData
function TRB.Classes.SnapshotData:New(attributes)
    local self = {}
    setmetatable(self, TRB.Classes.SnapshotData)
    ---@type TRB.Classes.TargetData
    self.targetData = TRB.Classes.TargetData:New()
    ---@type TRB.Classes.Snapshot[]
    self.snapshots = {}
    self.casting = TRB.Classes.SnapshotCasting:New()
    self.audio = {}
    self.attributes = attributes or {}

    return self
end


---@class TRB.Classes.Snapshot
---@field public spellId integer
---@field public isActive boolean
---@field public buff TRB.Classes.SnapshotBuff
---@field public cooldown TRB.Classes.SnapshotCooldown
---@field public stacks integer
---@field public attributes table
TRB.Classes.Snapshot = {}
TRB.Classes.Snapshot.__index = TRB.Classes.Snapshot

---Creates a new Snapshot object
---@param attributes table # Custom attributes to be tracked
---@return TRB.Classes.Snapshot
function TRB.Classes.Snapshot:New(attributes)
    local self = {}
    setmetatable(self, TRB.Classes.Snapshot)
    self.buff = TRB.Classes.SnapshotBuff:New(self)
    self.cooldown = TRB.Classes.SnapshotCooldown:New(self)
    self:Reset()
    self.attributes = attributes or {}

    return self
end

---Resets snapshot values to default
function TRB.Classes.Snapshot:Reset()
    self.spellId = nil
    self.isActive = false
    ---@type TRB.Classes.SnapshotBuff
    TRB.Classes.SnapshotBuff:Reset()
    TRB.Classes.SnapshotCooldown:Reset()
end


---@class TRB.Classes.SnapshotBuff
---@field public isActive boolean
---@field public endTime number?
---@field public duration number
---@field public remaining number
---@field public endTimeLeeway number
---@field public stacks integer
---@field private parent TRB.Classes.Snapshot
TRB.Classes.SnapshotBuff = {}
TRB.Classes.SnapshotBuff.__index = TRB.Classes.SnapshotBuff

---Creates a new Snapshot object
---@return TRB.Classes.SnapshotBuff
function TRB.Classes.SnapshotBuff:New(parent)
    local self = {}
    setmetatable(self, TRB.Classes.SnapshotBuff)
    self:Reset()
    self.parent = parent

    return self
end

---Resets the object to default values
function TRB.Classes.SnapshotBuff:Reset()
    self.isActive = false
    self.endTime = nil
    self.duration = 0
    self.remaining = 0
    self.endTimeLeeway = 0
    self.stacks = 0
end

---Computes the time remaining on the Snapshot
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
---@param useLeeway boolean? # If true, use the included leeway value for offsetting the remainingTime slightly.
---@return number # Duration remaining on the Snapshot
function TRB.Classes.SnapshotBuff:GetRemainingTime(currentTime, useLeeway)
	currentTime = currentTime or GetTime()

    if useLeeway == nil then
        useLeeway = false
    end

	local remainingTime = 0
	local endTime = self.endTime
	
	if useLeeway and self.endTimeLeeway ~= nil then
		endTime = self.endTimeLeeway
	end

	if endTime ~= nil and endTime > currentTime then
		remainingTime = endTime - currentTime
	elseif self.startTime ~= nil and self.duration ~= nil and self.duration > 0 then
		remainingTime = self.duration - (currentTime - self.startTime)
	end

	if remainingTime <= 0 then
        self.isActive = false
		remainingTime = 0
    else
        self.isActive = true
	end

    self.remaining = remainingTime
	return remainingTime
end

---Refreshes the buff information for the snapshot
function TRB.Classes.SnapshotBuff:Refresh()
    TRB.Functions.Aura:SnapshotGenericAura(self.parent.spellId, nil, self.parent)
end


---@class TRB.Classes.SnapshotCooldown
---@field public startTime number?
---@field public duration number
---@field public remaining number
---@field public onCooldown boolean
---@field private parent TRB.Classes.Snapshot
TRB.Classes.SnapshotCooldown = {}
TRB.Classes.SnapshotCooldown.__index = TRB.Classes.SnapshotCooldown

---Creates a new Snapshot object
---@param parent TRB.Classes.Snapshot # Snapshot that this is a part of
---@return TRB.Classes.SnapshotCooldown
function TRB.Classes.SnapshotCooldown:New(parent)
    local self = {}
    setmetatable(self, TRB.Classes.SnapshotCooldown)
    self:Reset()
    self.parent = parent

    return self
end

---Resets the object to default values
function TRB.Classes.SnapshotCooldown:Reset()
    self.startTime = nil
    self.duration = 0
    self.remaining = 0
    self.onCooldown = false
end

---Computes the time remaining on the Snapshot
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
---@return number # Cooldown duration remaining on the Snapshot
function TRB.Classes.SnapshotCooldown:GetRemainingTime(currentTime)
	currentTime = currentTime or GetTime()

    local remainingTime = 0

    if self.startTime ~= nil and self.duration ~= nil and self.duration > 0 then
		remainingTime = self.duration - (currentTime - self.startTime)
	end

	if remainingTime <= 0 then
		remainingTime = 0
        self.onCooldown = false
    else
        self.onCooldown = true
	end

    self.remaining = remainingTime
	return remainingTime
end

---Refreshes the cooldown information for the snapshot
function TRB.Classes.SnapshotCooldown:Refresh()
    if self.parent.spellId ~= nil then
        self.startTime, self.duration, _, _ = GetSpellCooldown(self.parent.spellId)
    end
    self:GetRemainingTime()
end


---@class TRB.Classes.SnapshotCasting
---@field public spellId integer?
---@field public startTime number?
---@field public endTime number?
---@field public resourceRaw number
---@field public resourceFinal number
---@field public icon string
---@field public spellKey string?
TRB.Classes.SnapshotCasting = {}
TRB.Classes.SnapshotCasting.__index = TRB.Classes.SnapshotCasting

---Creates a new Snapshot object
---@return TRB.Classes.SnapshotCasting
function TRB.Classes.SnapshotCasting:New()
    local self = {}
    setmetatable(self, TRB.Classes.SnapshotCasting)

    self:Reset()
    return self
end

---Resets casting values to default
function TRB.Classes.SnapshotCasting:Reset()
    self.spellId = nil
    self.startTime = nil
    self.endTime = nil
    self.resourceRaw = 0
    self.resourceFinal = 0
    self.icon = ""
    self.spellKey = nil
end