---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
local L = TRB.Localization
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.TargetData
---@field public targets table<string, TRB.Classes.Target>
---@field public auraInstanceIds table<integer, TRB.Classes.Target>
---@field public currentTargetGuid string?
---@field public count table
---@field public custom table
---@field public trackedSpells table<integer, TRB.Classes.TargetSpell>
TRB.Classes.TargetData = {}
TRB.Classes.TargetData.__index = TRB.Classes.TargetData

---Creates a new TargetData object
---@return TRB.Classes.TargetData
function TRB.Classes.TargetData:New()
    local self = {}
    setmetatable(self, TRB.Classes.TargetData)
    ---@type table<string, TRB.Classes.Target>
    self.targets = {}
    self.currentTargetGuid = nil
    self.count = {}
    self.custom = {}
    ---@type table<integer, TRB.Classes.TargetSpell>
    self.trackedSpells = {}
    self.auraInstanceIds = {}

    return self
end

---Adds a new spell to the `trackedSpells` cache that can be tracked against a target
---@param spell table # Spell we are tracking
---@param isDot boolean? # Is this a DoT?
---@param hasCounter boolean? # Does this have a counter component to it?
---@param hasSnapshot boolean? # Is there any snapshotting required?
---@param autoUpdate boolean? # Should this spell's tracked values be automatically updated?
function TRB.Classes.TargetData:AddSpellTracking(spell, isDot, hasCounter, hasSnapshot, autoUpdate)
    if isDot == nil then
        isDot = true
    end

    hasCounter = hasCounter or false
    hasSnapshot = hasSnapshot or false

    if autoUpdate == nil then
        autoUpdate = true
    end

    local id = spell.debuffId or spell.buffId or spell.spellId or spell.id or nil

    if id ~= nil and self.trackedSpells[id] == nil then
---@diagnostic disable-next-line: param-type-mismatch
        self.trackedSpells[id] = TRB.Classes.TargetSpell:New(spell, nil, isDot, hasCounter, hasSnapshot, autoUpdate)
        self.count[id] = 0
    end
end

---Creates a new entry in the target table for this target if one does not exist already
---@param guid string # GUID of the target we're adding
function TRB.Classes.TargetData:InitializeTarget(guid, isFriend)
    if guid ~= nil and guid ~= "" then
        if not self:CheckTargetExists(guid) then
            self.targets[guid] = TRB.Classes.Target:New(guid, isFriend)
            for _, spell in pairs(self.trackedSpells) do
                self.targets[guid]:AddSpellTracking(spell.spell, spell.isDot, spell.hasCounter, spell.hasSnapshot, spell.autoUpdate)
            end
        end
    end
end

---Updates the status of debuffs on the target
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.TargetData:UpdateTrackedSpells(currentTime)
    currentTime = currentTime or GetTime()
    local counts = {}
    for guid, _ in pairs(self.targets) do
        local target = self.targets[guid]
        if not target.isFriend and (target.lastUpdate == nil or (currentTime - target.lastUpdate) > 30) and target.guid ~= self.currentTargetGuid then
            for spellId, _ in pairs(target.spells) do
                target.spells[spellId]:Reset()
            end
        elseif target.isFriend and (target.lastUpdate == nil or (currentTime - target.lastUpdate) > 30) and target.guid ~= self.currentTargetGuid then
            for spellId, _ in pairs(target.spells) do
                target.spells[spellId]:Reset()
            end
        else
            for spellId, _ in pairs(target.spells) do
                counts[spellId] = counts[spellId] or 0

                if target.spells[spellId].active then
                    if target.spells[spellId].isDot then
                        counts[spellId] = counts[spellId] + 1
                    elseif target.spells[spellId].hasCounter then
                        counts[spellId] = counts[spellId] + target.spells[spellId].count
                    end
                end
            end
        end
    end

    for spellId, _ in pairs(counts) do
        self.count[spellId] = counts[spellId]
    end
end

---Handles updating the targetData and associated target's debuff tracking of a spell
---@param spellId integer # Spell ID of the debuff we are updating
---@param type trbAuraEventType # Event Type sourced from the combat log event
---@param guid string # GUID of the target we are updating
---@return boolean # Should this trigger a full bar update?
function TRB.Classes.TargetData:HandleCombatLogDebuff(spellId, type, guid)
    if self.trackedSpells[spellId] == nil or self.targets[guid] == nil then
        return false
    end

    local currentTime = GetTime()
    self.targets[guid].lastUpdate = currentTime
    if (type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH") then
        if self.targets[guid].spells[spellId].lastCheckTimestampApplied == currentTime then
            return false
        end
        self.targets[guid].spells[spellId].lastCheckTimestampApplied = currentTime
    end

    if type == "SPELL_AURA_REMOVED" then
        if self.targets[guid].spells[spellId].lastCheckTimestampApplied == currentTime or self.targets[guid].spells[spellId].lastCheckTimestampRemoved == currentTime then
            return false
        end
        self.targets[guid].spells[spellId].lastCheckTimestampRemoved = currentTime
    end

    local preExisting = self.targets[guid].spells[spellId].active
    local triggerUpdate = self.targets[guid]:HandleCombatLogDebuff(spellId, type)
    if triggerUpdate and type == "SPELL_AURA_APPLIED" then
        if not preExisting then
            self.count[spellId] = self.count[spellId] + 1
        end
        triggerUpdate = true
    elseif triggerUpdate and type == "SPELL_AURA_REMOVED" then
        if preExisting then
            self.count[spellId] = self.count[spellId] - 1
        end
        triggerUpdate = true
    elseif type == "SPELL_AURA_APPLIED_DOSE" then
        triggerUpdate = true
    elseif type == "SPELL_AURA_REMOVED_DOSE" then
        triggerUpdate = true
    elseif type == "SPELL_AURA_REFRESH" then
        triggerUpdate = true
    else
        --triggerUpdate = true
    end
    return triggerUpdate
end

---Handles updating the targetData and associated target's buff tracking of a spell
---@param spellId integer # Spell ID of the buff we are updating
---@param type trbAuraEventType # Event Type sourced from the combat log event
---@param guid any # GUID of the target we are updating
---@return boolean # Should this trigger a full bar update?
function TRB.Classes.TargetData:HandleCombatLogBuff(spellId, type, guid)
    if self.trackedSpells[spellId] == nil or self.targets[guid] == nil then
        return false
    end

    local currentTime = GetTime()
    self.targets[guid].lastUpdate = currentTime
    if (type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH") then
        if self.targets[guid].spells[spellId].lastCheckTimestampApplied == currentTime then
            return false
        end
        self.targets[guid].spells[spellId].lastCheckTimestampApplied = currentTime
    end

    if type == "SPELL_AURA_REMOVED" then
        if self.targets[guid].spells[spellId].lastCheckTimestampApplied == currentTime or self.targets[guid].spells[spellId].lastCheckTimestampRemoved == currentTime then
            return false
        end
        self.targets[guid].spells[spellId].lastCheckTimestampRemoved = currentTime
    end

    local preExisting = self.targets[guid].spells[spellId].active
    local triggerUpdate = self.targets[guid]:HandleCombatLogBuff(spellId, type)
    if triggerUpdate and type == "SPELL_AURA_APPLIED" then
        if not preExisting then
            self.count[spellId] = self.count[spellId] + 1
        end
        triggerUpdate = true
    elseif triggerUpdate and type == "SPELL_AURA_REMOVED" then
        if preExisting then
            self.count[spellId] = self.count[spellId] - 1
        end
        triggerUpdate = true
    end
    return triggerUpdate
end

---Checks to see if a target currently exists within the targets table
---@param guid string # GUID of the target we're checking the existence of
---@return boolean # Was the target found
function TRB.Classes.TargetData:CheckTargetExists(guid)
    if guid == nil or (not self.targets[guid] or self.targets[guid] == nil) then
        return false
    end
    return true
end

---Cleans up target tracking data
---@param clearAll boolean # Should we forcibly clean up all target data including targets we may still have active snapshotted data for?
function TRB.Classes.TargetData:Cleanup(clearAll)
    if clearAll == true then
        ---@type table<string, TRB.Classes.Target>
        self.targets = {}
    else
        local currentTime = GetTime()
        for guid, target in pairs(self.targets) do
            if not target.isFriend and (currentTime - target.lastUpdate) > 30 and target.guid ~= self.currentTargetGuid then
                self:Remove(guid)
            elseif target.isFriend and (currentTime - target.lastUpdate) > 30 and target.guid ~= self.currentTargetGuid then
                self:Remove(guid)
            end
        end
    end

    for spellId, _ in pairs(self.count) do
        self.count[spellId] = 0
    end

    for id, _ in pairs(self.custom) do
        self.count[id] = nil
    end
end

---Removes a target from the targets table
---@param guid string # GUID of the target we're removing
---@return boolean
function TRB.Classes.TargetData:Remove(guid)
    if guid ~= nil and self:CheckTargetExists(guid) then
        self.targets[guid] = nil
        return true
    end
    return false
end

---@class TRB.Classes.Target
---@field public guid string
---@field public lastUpdate number?
---@field public spells table<integer, TRB.Classes.TargetSpell>
---@field public auraInstanceIds table<integer, TRB.Classes.TargetSpell>
---@field public isFriend boolean
---@field public unitToken UnitToken?
---@field public persistedData table # Data that should be persisted across buff/debuff applications and removals
---@field private lastRefreshGetTime number
TRB.Classes.Target = {}
TRB.Classes.Target.__index = TRB.Classes.Target

---Creates a new Target for tracking
---@param guid string # GUID of the target
---@param isFriend boolean? # Is this a friendly unit?
---@return TRB.Classes.Target
function TRB.Classes.Target:New(guid, isFriend)
    local self = {}
    setmetatable(self, TRB.Classes.Target)
    self.guid = guid
    self.lastUpdate = GetTime()
    self.spells = {}
    self.auraInstanceIds = {}
    self.isFriend = isFriend or false
    self.unitToken = nil
    self.lastRefreshGetTime = 0
    self.persistedData = {}
    return self
end

---Adds a new spell to be tracked against a target
---@param spell table # Spell we are tracking
---@param isDot boolean? # Is this a DoT?
---@param hasCounter boolean? # Does this have a counter component to it?
---@param hasSnapshot boolean? # Is there any snapshotting required?
---@param autoUpdate boolean? # Should this spell's tracked values be automatically updated?
function TRB.Classes.Target:AddSpellTracking(spell, isDot, hasCounter, hasSnapshot, autoUpdate)
    if isDot == nil then
        isDot = true
    end

    hasCounter = hasCounter or false
    hasSnapshot = hasSnapshot or false

    if autoUpdate == nil then
        autoUpdate = true
    end

    local id = spell.debuffId or spell.spellId or spell.id or nil

    if id ~= nil and self.spells[id] == nil then
        self.spells[id] = TRB.Classes.TargetSpell:New(spell, self, isDot, hasCounter, hasSnapshot, autoUpdate)
    end
end

---Handles updating the target's debuff tracking of a spell
---@param spellId integer # Spell ID of the debuff we are updating
---@param type trbAuraEventType # Event Type sourced from the combat log event
---@return boolean # Should this trigger a full bar update?
function TRB.Classes.Target:HandleCombatLogDebuff(spellId, type)
    if self.spells[spellId] == nil then
        return false
    end

    return self.spells[spellId]:HandleCombatLogBuffOrDebuff(type)
end

---Handles updating the target's buff tracking of a spell
---@param spellId integer # Spell ID of the buff we are updating
---@param type trbAuraEventType # Event Type sourced from the combat log event
---@return boolean # Should this trigger a full bar update?
function TRB.Classes.Target:HandleCombatLogBuff(spellId, type)
    if self.spells[spellId] == nil then
        return false
    end
    return self.spells[spellId]:HandleCombatLogBuffOrDebuff(type)
end

---Updates all spells tracked on this target
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.Target:UpdateAllSpellTracking(currentTime)
    currentTime = currentTime or GetTime()
    if TRB.Functions.Table:Length(self.spells) > 0 then
        for spellId, _ in pairs(self.spells) do
            if self.spells[spellId] ~= nil and self.spells[spellId].endTime ~= nil then
                self.spells[spellId].remainingTime = self.spells[spellId].endTime - currentTime
            end
        end
    end
end

---Attempts to get the current health percent for this creature. May fail if this creature does not have a current UnitToken.
---@return number? # Returns the health percentage if the creature has a valid UnitToken; nil otherwise
function TRB.Classes.Target:GetHealthPercent()
    self:UpdateUnitToken()
	if self.unitToken ~= nil then
		local health = UnitHealth(self.unitToken)
		local healthMax = UnitHealthMax(self.unitToken)
		return health / healthMax
	else
		return nil
	end
end

---Updates the UnitToken for the target. This check runs no more than once per frame.
function TRB.Classes.Target:UpdateUnitToken()
    local currentTime = GetTime()
    if self.lastRefreshGetTime == currentTime then
        return
    end

    local guidCheck = nil
    
    if self.unitToken ~= nil then
        guidCheck = UnitGUID(self.unitToken)
    end

    if guidCheck ~= self.guid then
        self.unitToken = UnitTokenFromGUID(self.guid)
    end    
    self.lastRefreshGetTime = currentTime
end


---@class TRB.Classes.TargetSpell
---@field public id integer
---@field public spell TRB.Classes.SpellBase
---@field public active boolean
---@field public remainingTime number
---@field public endTime number?
---@field public isDot boolean
---@field public hasCounter boolean
---@field public count integer
---@field public hasSnapshot boolean
---@field public snapshot number
---@field public stacks integer
---@field public autoUpdate boolean
---@field public auraInstanceId? integer
---@field public lastCheckTimestampApplied number?
---@field public lastCheckTimestampRemoved number?
---@field private target TRB.Classes.Target
TRB.Classes.TargetSpell = {}
TRB.Classes.TargetSpell.__index = TRB.Classes.TargetSpell

---Adds a new spell to be tracked against a target
---@param spell TRB.Classes.SpellBase # Spell we are tracking
---@param target TRB.Classes.Target # Target this spell is tracked against
---@param isDot boolean? # Is this a DoT?
---@param hasCounter boolean? # Does this have a counter component to it?
---@param hasSnapshot boolean? # Is there any snapshotting required?
---@param autoUpdate boolean? # Should this spell's tracked values be automatically updated?
---@return TRB.Classes.TargetSpell
function TRB.Classes.TargetSpell:New(spell, target, isDot, hasCounter, hasSnapshot, autoUpdate)
    local self = {}
    setmetatable(self, TRB.Classes.TargetSpell)

    if isDot == nil then
        isDot = true
    end

    if hasCounter == nil then
        hasCounter = false
    end

    if hasSnapshot == nil then
        hasSnapshot = false
    end

    if autoUpdate == nil then
        autoUpdate = true
    end

    self.id = spell.debuffId or spell.spellId or spell.id
    self.target = target
    self.spell = spell
    self.active = false
    self.isDot = isDot
    self.remainingTime = 0.0
    self.endTime = nil
    self.hasCounter = hasCounter
    self.count = 0
    self.hasSnapshot = hasSnapshot
    self.snapshot = 0.0
    self.stacks = 0
    self.autoUpdate = autoUpdate
    self.guid = ""
    self.auraInstanceId = nil
    return self
end

---Sets the aura related data for the target spell
---@param self TRB.Classes.TargetSpell
---@param unitToken string
---@param isBuff boolean # True = Buff, False = Debuff
local function SetAuraData(self, unitToken, isBuff)
    local currentTime = GetTime()
    ---@type AuraData?
    local aura
    
    if self.auraInstanceId ~= nil then
        aura = C_UnitAuras.GetAuraDataByAuraInstanceID(unitToken, self.auraInstanceId)
    else
        if isBuff then
            aura = TRB.Functions.Aura:FindBuffById(self.id, unitToken, "player")
        else
            aura = TRB.Functions.Aura:FindDebuffById(self.id, unitToken, "player")
        end
    end
    
    if aura ~= nil then
        self.active = true
        self.remainingTime = aura.expirationTime - currentTime
        self.endTime = aura.expirationTime
        self.stacks = aura.applications
        self.auraInstanceId = aura.auraInstanceID
    else
        --self:Reset()
    end
end

---Updates this spell's snapshotting
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.TargetSpell:Update(currentTime)
    currentTime = currentTime or GetTime()
    self.target:UpdateUnitToken()
    
    if self.target.unitToken ~= nil then
        if self.autoUpdate then
            if self.isDot then
                if self.spell.isBuff and self.spell.isDebuff then -- Buff on friendly, debuff on unfriendly
                    if self.target ~= nil and self.target.isFriend then
                        SetAuraData(self, self.target.unitToken, true)
                    else
                        SetAuraData(self, self.target.unitToken, false)
                    end
                elseif self.spell.isBuff then
                    SetAuraData(self, self.target.unitToken, true)
                else
                    SetAuraData(self, self.target.unitToken, false)
                end

                if self.auraInstanceId ~= nil then
                    TRB.Functions.Aura:StoreTargetAuraInstanceId(self.auraInstanceId, self.target)
                    self.target.auraInstanceIds[self.auraInstanceId] = self
                end
            end

            if self.hasCounter then
                if self.count <= 0 then
                    self.count = 0
                    self.active = false
                end
            end
        end
    end
end

---Handles updating the buff or debuff tracking of a spell
---@param type trbAuraEventType # Event Type sourced from the combat log event
---@return boolean # Should this trigger a full bar update?
function TRB.Classes.TargetSpell:HandleCombatLogBuffOrDebuff(type)
    local triggerUpdate = false
    if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
        self.active = true
        self:Update()
        if self.spell.duration ~= nil and self.spell.duration > 0 then
            local currentTime = GetTime()
            self.endTime = currentTime + self.spell.duration
            self.remainingTime = self.spell.duration
        end
        triggerUpdate = true
    elseif type == "SPELL_AURA_REMOVED" then
        self.active = false
        if self.isDot and self.autoUpdate then
            self:Reset()
        end
        triggerUpdate = true
    else
        triggerUpdate = true
    --elseif type == "SPELL_PERIODIC_DAMAGE" then
    end
    return triggerUpdate
end

---Resets the spell's snapshots
function TRB.Classes.TargetSpell:Reset()
    if self.auraInstanceId ~= nil then
        TRB.Functions.Aura:RemoveTargetAuraInstanceId(self.auraInstanceId)
    end
    self.active = false
    self.remainingTime = 0.0
    self.endTime = nil
    self.count = 0
    self.snapshot = 0.0
    self.stacks = 0
    self.auraInstanceId = nil
end
