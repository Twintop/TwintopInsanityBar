local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.Talent
---@field public id integer
---@field public name string
---@field public icon string
---@field public currentRank integer
---@field public maxRank integer
---@field public subTreeActive boolean?
TRB.Classes.Talent = {}
TRB.Classes.Talent.__index = TRB.Classes.Talent

---Create a new fully hydrated Talent
---@param id integer # SpellId of the Talent
---@param currentRank integer # Current rank
---@param maxRank integer # Maximum ranks
---@param subTreeActive boolean? # Is this sub tree active? Only for Hero talents.
---@return TRB.Classes.Talent
function TRB.Classes.Talent:New(id, currentRank, maxRank, subTreeActive)
    local self = {}
    setmetatable(self, TRB.Classes.Talent)

    local spellInfo = C_Spell.GetSpellInfo(id) --[[@as SpellInfo]]
    local iconString = string.format("|T%s:0|t", spellInfo.originalIconID)

    self.id = id
    self.currentRank = currentRank
    self.maxRank = maxRank
	self.subTreeActive = subTreeActive
    self.name = spellInfo.name
    self.icon = iconString
    return self
end

---Checks to see if the talent is currently active or not.
---@return boolean # True if the talent is active
function TRB.Classes.Talent:IsActive()
	return self.currentRank > 0 and (self.subTreeActive == nil or self.subTreeActive == true)
end

---@class TRB.Classes.Talents
---@field public talents table<integer, TRB.Classes.Talent>
TRB.Classes.Talents = {}
TRB.Classes.Talents.__index = TRB.Classes.Talents

---Creates a new Talents object.
---@param fill boolean? # Should GetTalents() be called immediately
---@return TRB.Classes.Talents
function TRB.Classes.Talents:New(fill)
    local self = {}
    setmetatable(self, TRB.Classes.Talents)

    if fill then
        self:GetTalents()
    else
        self.talents = {}
    end

    return self
end

---Loads all of the talents for the current specialization.
function TRB.Classes.Talents:GetTalents()
	local talents = {}
	for spellId, rank in pairs(TRB.Flavor.ReadTalentRanks()) do
		talents[spellId] = TRB.Classes.Talent:New(spellId, rank.currentRank, rank.maxRank, rank.subTreeActive)
	end
	self.talents = talents
end

---Checks if the current talent configuration has changed since the last GetTalents() call.
---Compares spellId+currentRank of every talent without overwriting self.talents.
---@return boolean # True if talents have changed, false if they are the same.
function TRB.Classes.Talents:HaveTalentsChanged()
	local oldTalents = self.talents or {}
	local newTalents = TRB.Flavor.ReadTalentRanks()

	-- Compare: check if any spellId has a different rank or is new/missing
	for spellId, rank in pairs(newTalents) do
		local oldTalent = oldTalents[spellId]
		if oldTalent == nil or oldTalent.currentRank ~= rank.currentRank then
			return true
		end
	end
	for spellId, _ in pairs(oldTalents) do
		if newTalents[spellId] == nil then
			return true
		end
	end

	return false
end

---Checks to see if a talent is active
---@param spell table # The spell that we're checking to see if is a a talent and is active.
---@return boolean
function TRB.Classes.Talents:IsTalentActive(spell)
	return spell.baseline == true or
		(self.talents[spell.talentId] ~= nil and self.talents[spell.talentId]:IsActive()) or
		(self.talents[spell.id] ~= nil and self.talents[spell.id]:IsActive()) or
		(spell.isPvp and C_SpellBook.IsSpellKnown(spell.id)) or false
end