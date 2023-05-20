---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.TargetData
---@field public targets TRB.Classes.Target[]
---@field public currentTargetGuid string?
---@field public ttdIsActive boolean
---@field public count table
---@field public custom table
---@field public trackedSpells TRB.Classes.TargetSpell[]
TRB.Classes.TargetData = {}
TRB.Classes.TargetData.__index = TRB.Classes.TargetData

---Creates a new TargetData object
---@return TRB.Classes.TargetData
function TRB.Classes.TargetData:New()
    local self = {}
    setmetatable(self, TRB.Classes.TargetData)
    ---@type TRB.Classes.Target[]
    self.targets = {}
    self.currentTargetGuid = nil
    self.ttdIsActive = false
    self.count = {}
    self.custom = {}
    ---@type TRB.Classes.TargetSpell[]
    self.trackedSpells = {}

    return self
end

---Adds a new spell to the `trackedSpells` cache that can be tracked against a target
---@param spell table # Spell we are tracking
---@param isDot boolean? # Is this a DoT?
---@param hasCounter boolean? # Does this have a counter component to it?
---@param hasSnapshot boolean? # Is there any snapshotting required?
function TRB.Classes.TargetData:AddSpellTracking(spell, isDot, hasCounter, hasSnapshot)
    isDot = isDot or true
    hasCounter = hasCounter or false
    hasSnapshot = hasSnapshot or false
    if self.trackedSpells[spell.id] == nil then
		self.trackedSpells[spell.id] = TRB.Classes.TargetSpell:New(spell, isDot, hasCounter, hasSnapshot)
        self.count[spell.id] = 0
	end
end

---Creates a new entry in the target table for this target if onee does not exist already
---@param guid string # GUID of the target we're adding
function TRB.Classes.TargetData:InitializeTarget(guid)
	if guid ~= nil and guid ~= "" then
		if not self:CheckTargetExists(guid) then
			self.targets[guid] = TRB.Classes.Target:New(guid)
            for _, spell in pairs(self.trackedSpells) do
                self.targets[guid]:AddSpellTracking(spell.spell, spell.isDot, spell.hasCounter, spell.hasSnapshot)
            end
		end
	end
end

---Updates the status of debuffs on the target
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.TargetData:UpdateDebuffs(currentTime)
    currentTime = currentTime or GetTime()
    local counts = {}
    for guid,_ in pairs(self.targets) do
        local target = self.targets[guid]
        if target.lastUpdate == nil or (currentTime - target.lastUpdate) > 10 then
            for spellId,_ in pairs(target.spells) do
                target.spells[spellId]:Reset()
            end
        else
            for spellId,_ in pairs(target.spells) do
                counts[spellId] = counts[spellId] or 0

                if target.spells[spellId].active then
                    if target.spells[spellId].isDot then
                        counts[spellId] = counts[spellId] + 1
                    elseif target.spells[spellId].hasCounter then
                        counts[spellId] = counts[spellId] + target[spellId].count
                    end
                end
            end
        end
    end

    for spellId, _ in pairs(counts) do
        self.count[spellId] = counts[spellId]
    end
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
		---@type TRB.Classes.Target[]
		self.targets = {}
	else
		local currentTime = GetTime()
		for guid,_ in pairs(self.targets) do
			if (currentTime - self.targets[guid].lastUpdate) > 10 then
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
function TRB.Classes.TargetData:Remove(guid)
	if guid ~= nil and self:CheckTargetExists(guid) then
		self.targets[guid] = nil
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
		self.spells[spell.id] = TRB.Classes.TargetSpell:New(spell, isDot, hasCounter, hasSnapshot)
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

---@class TRB.Classes.TargetSpell
---@field public id integer
---@field public spell table 
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
---@param spell table # Spell we are tracking
---@param isDot boolean? # Is this a DoT?
---@param hasCounter boolean? # Does this have a counter component to it?
---@param hasSnapshot boolean? # Is there any snapshotting required?
---@return TRB.Classes.TargetSpell
function TRB.Classes.TargetSpell:New(spell, isDot, hasCounter, hasSnapshot)
    local self = {}
    setmetatable(self, TRB.Classes.TargetSpell)
    self.id = spell.id
    self.spell = spell
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

---Reset's the spell's snapshots
function TRB.Classes.TargetSpell:Reset()
    self.active = false
    self.remainingTime = 0.0
    self.count = 0
    self.snapshot = 0.0
end