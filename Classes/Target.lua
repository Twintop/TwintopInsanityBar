---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

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