---@diagnostic disable: undefined-field, undefined-global
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
	local configId = C_ClassTalents.GetActiveConfigID()
	if configId ~= nil then
		local configInfo = C_Traits.GetConfigInfo(configId)
		if configInfo ~= nil then
			for _, treeId in pairs(configInfo.treeIDs) do
				local nodes = C_Traits.GetTreeNodes(treeId)
				for _, nodeId in pairs(nodes) do
					local node = C_Traits.GetNodeInfo(configId, nodeId)
					local entryId = nil
					
					if node.activeEntry ~= nil then
						entryId = node.activeEntry.entryID
					elseif node.nextEntry ~= nil then
						entryId = node.nextEntry.entryID
					elseif node.entryIDs ~= nil then
						entryId = node.entryIDs[1]
					end

					if entryId ~= nil then
						local entryInfo = C_Traits.GetEntryInfo(configId, entryId)
						
						if entryInfo.definitionID ~= nil then
							local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)

							if definitionInfo ~= nil then
								local spellId = nil
								if definitionInfo.spellID ~= nil then
									spellId = definitionInfo.spellID
								elseif definitionInfo.overriddenSpellID ~= nil then
									spellId = definitionInfo.overriddenSpellID
								end
								if spellId ~= nil then
									talents[spellId] = TRB.Classes.Talent:New(spellId, node.currentRank, node.maxRanks, node.subTreeActive)
								end
							end
						end
					end
				end
			end
		end
	end

	self.talents = talents
end

---Checks to see if a talent is active
---@param spell table # The spell that we're checking to see if is a a talent and is active.
---@return boolean
function TRB.Classes.Talents:IsTalentActive(spell)
	return spell.baseline == true or
		(self.talents[spell.id] ~= nil and self.talents[spell.id]:IsActive()) or
		(self.talents[spell.talentId] ~= nil and self.talents[spell.talentId]:IsActive()) or
		(spell.isPvp and IsPlayerSpell(spell.id))
end