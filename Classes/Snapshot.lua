---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}


---@class TRB.Classes.SnapshotData
---@field public targetData TRB.Classes.TargetData
---@field public snapshots table<integer, TRB.Classes.Snapshot>
---@field public casting TRB.Classes.SnapshotCasting
---@field public audio table
---@field public attributes table
TRB.Classes.SnapshotData = {}
TRB.Classes.SnapshotData.__index = TRB.Classes.SnapshotData

---Creates a new SnapshotData object
---@param attributes table? # Custom attributes to be tracked
---@return TRB.Classes.SnapshotData
function TRB.Classes.SnapshotData:New(attributes)
    local self = {}
    setmetatable(self, TRB.Classes.SnapshotData)
    ---@type TRB.Classes.TargetData
    self.targetData = TRB.Classes.TargetData:New()
    ---@type table<integer, TRB.Classes.Snapshot>
    self.snapshots = {}
    self.casting = TRB.Classes.SnapshotCasting:New()
    self.audio = {}
    self.attributes = attributes or {}
    self.attributes.resource = self.attributes.resource or 0

    return self
end


---@class TRB.Classes.Snapshot
---@field public spell TRB.Classes.SpellBase?
---@field public buff TRB.Classes.SnapshotBuff
---@field public cooldown TRB.Classes.SnapshotCooldown
---@field public stacks integer
---@field public attributes table
TRB.Classes.Snapshot = {}
TRB.Classes.Snapshot.__index = TRB.Classes.Snapshot

---Creates a new Snapshot object
---@param spell TRB.Classes.SpellBase # Spell we are snapshotting
---@param attributes table? # Custom attributes to be tracked
---@param alwaysSimpleBuff boolean? # Should the buff tracking always run in simple mode?
---@param onlyRefreshOnRequest boolean? # Should the buff refresh only occur when explictly requested?
---@return TRB.Classes.Snapshot
function TRB.Classes.Snapshot:New(spell, attributes, alwaysSimpleBuff, onlyRefreshOnRequest)
    local self = {}
    setmetatable(self, TRB.Classes.Snapshot)
    self.spell = spell
    self.buff = TRB.Classes.SnapshotBuff:New(self, alwaysSimpleBuff, onlyRefreshOnRequest)
    self.cooldown = TRB.Classes.SnapshotCooldown:New(self)
    self:Reset()
    self.attributes = attributes or {}
    return self
end

---Resets snapshot values to default
function TRB.Classes.Snapshot:Reset()
    ---@type TRB.Classes.SnapshotBuff
    self.buff:Reset()
    ---@type TRB.Classes.SnapshotCooldown
    self.cooldown:Reset()
end


---@class TRB.Classes.SnapshotBuff
---@field public auraInstanceId integer?
---@field public isActive boolean
---@field public endTime number?
---@field public duration number
---@field public remaining number
---@field public endTimeLeeway number
---@field public applications integer
---@field public customPropertiesDefinitions TRB.Classes.BuffCustomProperty[]
---@field public customProperties table
---@field public alwaysSimple boolean?
---@field public hasTicks boolean
---@field private resourcePerTick number
---@field private tickRate number
---@field public ticks number
---@field public resource number
---@field public isCustom boolean
---@field private refreshRequested boolean
---@field private refreshEmbargo number?
---@field private onlyRefreshOnRequest boolean
---@field protected parent TRB.Classes.Snapshot
TRB.Classes.SnapshotBuff = {}
TRB.Classes.SnapshotBuff.__index = TRB.Classes.SnapshotBuff

---Creates a new Snapshot object
---@param parent TRB.Classes.Snapshot
---@param alwaysSimpleBuff boolean? # Should the buff tracking always run in simple mode?
---@param onlyRefreshOnRequest boolean? # Should the buff refresh only occur when explictly requested?
---@return TRB.Classes.SnapshotBuff
function TRB.Classes.SnapshotBuff:New(parent, alwaysSimpleBuff, onlyRefreshOnRequest)
    local self = {}
    setmetatable(self, TRB.Classes.SnapshotBuff)

    if alwaysSimpleBuff ~= nil then
        self.alwaysSimple = alwaysSimpleBuff
    else
        self.alwaysSimple = false
    end

    if onlyRefreshOnRequest ~= nil then
        self.onlyRefreshOnRequest = onlyRefreshOnRequest
    else
        self.onlyRefreshOnRequest = false
    end

    self.parent = parent

    if self.parent.spell.hasTicks then
        self.hasTicks = true
        self.resourcePerTick = self.parent.spell.resourcePerTick
        self.tickRate = self.parent.spell.tickRate
    end

    self:Reset()
    self.customPropertiesDefinitions = {}
    self.customProperties = {}

    return self
end

---Sets the list of custom properties to be parsed out of a UnitAura() call when SnapshotBuff:Refresh() is called
---@param customProperties TRB.Classes.BuffCustomProperty[]
function TRB.Classes.SnapshotBuff:SetCustomProperties(customProperties)
    self.customPropertiesDefinitions = customProperties
    self:Reset()
end

---Resets the object to default values
function TRB.Classes.SnapshotBuff:Reset()
    self.auraInstanceId = nil
    self.isActive = false
    self.endTime = nil
    self.duration = 0
    self.remaining = 0
    self.endTimeLeeway = 0
    self.applications = 0
    self.ticks = 0
    self.resource = 0
    self.isCustom = false
    self.refreshRequested = false

    if self.customPropertiesDefinitions ~= nil then
        for _, prop in ipairs(self.customPropertiesDefinitions) do
            if prop.dataType == "number" then
                self.customProperties[prop.name] = 0
            elseif prop.dataType == "integer" then
                self.customProperties[prop.name] = 0
            end
        end
    end
end

---@param hasTicks boolean # Does this spell have ticks?
---@param resourcePerTick number # Amount of a given resource generated per tick
---@param tickRate number # How frequently, in seconds, a tick occurs.
function TRB.Classes.SnapshotBuff:SetTickData(hasTicks, resourcePerTick, tickRate)
    self.hasTicks = hasTicks
    self.resourcePerTick = resourcePerTick
    self.tickRate = tickRate
end

---Computes the time remaining on the Snapshot and also refreshes data related to ticks if the spell supports it
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

---Updates the number of ticks remaining on a buff
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.SnapshotBuff:UpdateTicks(currentTime)
    if self.hasTicks then
        currentTime = currentTime or GetTime()
        self:GetRemainingTime(currentTime)
        self.ticks = math.ceil(self.remaining / self.tickRate)
        self.resource = self.ticks * self.resourcePerTick
    end
end

---Initializes the buff information for the snapshot
---@param eventType trbAuraEventType? # Event type sourced from the combat log event. If not provided, will do a generic buff update
---@param simple? boolean # Just updates isActive. If not provided, defaults to `false`
---@param unit? UnitId # Unit we want to check to update. If not provided, defaults to `player`
function TRB.Classes.SnapshotBuff:Initialize(eventType, simple, unit)
    unit = unit or "player"
    if simple == nil then
        simple = false
    end
    if self.onlyRefreshOnRequest then
        self.refreshRequested = true
    end
    self:Refresh(eventType, simple, unit)
end

---Initializes the buff with custom endTime and duration values
---@param duration number # How long the buff will last
function TRB.Classes.SnapshotBuff:InitializeCustom(duration)
    local currentTime = GetTime()
    self.duration = duration
    self.endTime = currentTime + duration
    self.isCustom = true
    self:GetRemainingTime()
end


---Parse the buff
---@param buff TRB.Classes.SnapshotBuff # The snapshot buff we are updating
---@param aura AuraData # Data about the buff
---@return integer? # The SpellID of the buff, if found
local function ParseBuffData(buff, aura)
    if aura ~= nil then
        buff.auraInstanceId = aura.auraInstanceID
        buff.applications = aura.applications
        buff.duration = aura.duration
        buff.endTime = aura.expirationTime

        if buff.customPropertiesDefinitions ~= nil then
            for _, prop in ipairs(buff.customPropertiesDefinitions) do
                buff.customProperties[prop.name] = aura.points[prop.index]
                if buff.customProperties[prop.name] ~= nil then
                    if prop.dataType == "number" then
                        buff.customProperties[prop.name] = tonumber(buff.customProperties[prop.name] * prop.modifier)
                    elseif prop.dataType == "integer" then
                        buff.customProperties[prop.name] = math.floor(tonumber(buff.customProperties[prop.name] * prop.modifier))
                    end
                else
                    if prop.dataType == "number" then
                        buff.customProperties[prop.name] = 0
                    elseif prop.dataType == "integer" then
                        buff.customProperties[prop.name] = 0
                    end
                end
            end
        end

        return aura.spellId
    else
        buff:Reset()
    end
end

---Requests a refresh of the buff after the embargo has passed, if specified
---@param embargo number? # Timestamp to embargo the refresh until
function TRB.Classes.SnapshotBuff:RequestRefresh(embargo)
    self.refreshRequested = true
    self.refreshEmbargo = embargo
end

---Refreshes the buff information for the snapshot
---@param eventType trbAuraEventType? # Event type sourced from the combat log event. If not provided, will do a generic buff update
---@param simple boolean? # Just updates isActive. If not provided, defaults to `false`
---@param unit UnitId? # Unit we want to check to update. If not provided, defaults to `player`
function TRB.Classes.SnapshotBuff:Refresh(eventType, simple, unit)
    -- If this is a custom buff, don't do any of the following checks and instead just update the remaining time.
    if self.isCustom then
        self:GetRemainingTime()
        return
    end
    
    if self.onlyRefreshOnRequest then
        if self.refreshRequested == false or self.refreshEmbargo ~= nil and self.refreshEmbargo > GetTime() then
            if self.isActive then
                self:GetRemainingTime()
            end
            return
        else
            self.refreshRequested = false
            self.refreshEmbargo = nil
        end
    end

    unit = unit or "player"
    if simple == nil then
        simple = false
    end

    local id = self.parent.spell.buffId or self.parent.spell.spellId or self.parent.spell.id or nil
    if id ~= nil then
        if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_APPLIED_DOSE" then -- Gained buff
            self.isActive = true
            if unit == "player" then
                ParseBuffData(self, C_UnitAuras.GetPlayerAuraBySpellID(id))
            else
                ParseBuffData(self, TRB.Functions.Aura:FindBuffById(id, unit))
            end
            if not simple and not self.alwaysSimple then
                self:GetRemainingTime()
            end
        elseif eventType == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
            if self.applications ~= nil then
                self.applications = self.applications - 1
            end
        elseif eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_DISPEL" then -- Lost buff
            self:Reset()
        elseif eventType == nil or eventType == "" then
            local currentTime = currentTime or GetTime()
            local foundId = nil
            
            if unit == "player" then
                foundId = ParseBuffData(self, C_UnitAuras.GetPlayerAuraBySpellID(id))
            else
                foundId = ParseBuffData(self, TRB.Functions.Aura:FindBuffById(id, unit))
            end

            if simple or self.alwaysSimple then
                self.isActive = foundId == id
            else
                if self.endTime ~= nil and self.endTime > currentTime then
                    self.isActive = true
                    self:GetRemainingTime()
                else
                    self:Reset()
                end
            end
        end
    end
end


---@class TRB.Classes.SnapshotCooldown
---@field public startTime number?
---@field public duration number
---@field public remaining number
---@field public remainingTotal number
---@field public onCooldown boolean
---@field public charges integer
---@field public maxCharges integer
---@field private retryForceTime number?
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
    self.remainingTotal = 0
    self.onCooldown = false
    self.charges = 0
    self.maxCharges = 0
    self.retryForceTime = nil
end

---Computes the time remaining on the Snapshot
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
---@param totalTime boolean? # Return the total remaining time of all charges on the Snapshot
---@return number # Cooldown duration remaining on the Snapshot
function TRB.Classes.SnapshotCooldown:GetRemainingTime(currentTime, totalTime)
	if totalTime == nil then
        totalTime = false
    end
    
    currentTime = currentTime or GetTime()

    if self.retryForceTime ~= nil and currentTime > self.retryForceTime then
        self.retryForceTime = nil
        self:Refresh(true)
    end

    local remainingTime = 0

    if self.startTime ~= nil and self.duration ~= nil and self.duration > 0 then
		remainingTime = self.duration - (currentTime - self.startTime)
	end

	if remainingTime <= 0 then
		remainingTime = 0
        self.onCooldown = false
    elseif self.charges > 0 then
        self.onCooldown = false
    else
        self.onCooldown = true
	end

    self.remaining = remainingTime
    
    if self.maxCharges > 1 and self.charges < self.maxCharges then
        self.remainingTotal = self.remaining +  ((self.maxCharges - self.charges - 1) * self.duration)
    elseif self.maxCharges > 1 and self.maxCharges == self.charges then
        self.startTime = nil
        self.duration = 0
        self.remainingTotal = 0
    end

    if totalTime then
        return self.remainingTotal
    else
        return self.remaining
    end
end

---Initializes the cooldown information for the snapshot by forcing a refresh and a retry on the next frame, if needed
function TRB.Classes.SnapshotCooldown:Initialize()
    self:Refresh(true, true)
end

---Refreshes the cooldown information for the snapshot
---@param force boolean? # Force refresh of the value even if other interal logic would prevent it from doing so
---@param retryForce boolean? # Allow the cooldown to retry a force on the next call to Refresh()
function TRB.Classes.SnapshotCooldown:Refresh(force, retryForce)
    if self.parent.spell ~= nil and self.parent.spell.id ~= nil and (force or self.parent.spell.hasCharges or self.onCooldown) then
        local startTime = nil
        local duration = 0
        if self.parent.spell.hasCharges == true then
            self.charges, self.maxCharges, startTime, duration, _ = GetSpellCharges(self.parent.spell.id)
            if self.charges == self.maxCharges then
                startTime = 0
                duration = 0
            end
        else
            startTime, duration, _, _ = GetSpellCooldown(self.parent.spell.id)
        end

        local gcd = TRB.Functions.Character:GetCurrentGCDLockRemaining()
        local down, up, lagHome, lagWorld = GetNetStats()
        local latency = lagWorld / 1000
        
        local currentTime = GetTime()
        local remainingTime = startTime + duration - currentTime

        if ((startTime ~= nil and startTime > 0 and not self.onCooldown and remainingTime > gcd + latency) or
            (self.onCooldown and remainingTime > gcd + latency)) and (self.parent.spell.hasChanges ~= true or (self.parent.spell.hasChanges and self.charges < self.maxCharges))
            then
            self.startTime = startTime
            self.duration = duration
            self.retryForceTime = nil
        elseif self.onCooldown and remainingTime > gcd + latency then
            self.startTime = startTime
            self.duration = duration
            self.retryForceTime = nil
        else
            self.startTime = nil
            self.duration = 0
            if retryForce then
                self.retryForceTime = currentTime
            end
        end
    end
    self:GetRemainingTime()
end

---Determines if the cooldown is unusable, either by virtue of being completely on cooldown or having no charges to spend
---@return boolean
function TRB.Classes.SnapshotCooldown:IsUnusable()
    return (self.charges == nil or self.charges == 0) and self.onCooldown
end

---Determines if the cooldown is usable, either by virtue of being completely off of cooldown or having any charges to spend
---@return boolean
function TRB.Classes.SnapshotCooldown:IsUsable()
    return not self.onCooldown
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


---@class TRB.Classes.BuffCustomProperty
---@field public index integer
---@field public dataType string
---@field public name string
---@field public modifier number
TRB.Classes.BuffCustomProperty = {}
TRB.Classes.BuffCustomProperty.__index = TRB.Classes.BuffCustomProperty


---Creates a new BuffCustomProperty object
---@param index integer
---@param dataType string
---@param name string
---@param modifier number?
---@return TRB.Classes.BuffCustomProperty
function TRB.Classes.BuffCustomProperty:New(index, dataType, name, modifier)
    local self = {}
    setmetatable(self, TRB.Classes.BuffCustomProperty)

    self.index = index
    self.dataType = dataType
    self.name = name
    self.modifier = modifier or 1
    return self
end