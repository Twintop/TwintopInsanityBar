---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Aura = {}

---Attempts to get a buff on a target by its spellId
---@param spellId integer
---@param onWhom string?
---@param byWhom string?
---@return AuraData?
function TRB.Functions.Aura:FindBuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	local buffData

	for i = 1, 1000 do
		buffData = C_UnitAuras.GetBuffDataByIndex(onWhom, i)
		if not buffData then
			return
		elseif spellId == buffData.spellId and (byWhom == nil or byWhom == buffData.sourceUnit) then
			return buffData
		end
	end
end

---Attempts to get a debuff by its spellId
---@param spellId integer
---@param onWhom string?
---@param byWhom string?
---@return AuraData?
function TRB.Functions.Aura:FindDebuffById(spellId, onWhom, byWhom)
	if onWhom == nil then
		onWhom = "player"
	end

	local debuffData

	for i = 1, 1000 do
		debuffData = C_UnitAuras.GetDebuffDataByIndex(onWhom, i)
		if not debuffData then
			return
		elseif spellId == debuffData.spellId and (byWhom == nil or byWhom == debuffData.sourceUnit) then
			return debuffData
		end
	end
end

---@alias trbAuraEventType
---| '"SPELL_AURA_APPLIED"' # SPELL_AURA_APPLIED
---| '"SPELL_AURA_REFRESH"' # SPELL_AURA_REFRESH
---| '"SPELL_AURA_REMOVED"' # SPELL_AURA_REMOVED
---| '"SPELL_AURA_APPLIED_DOSE"' # SPELL_AURA_APPLIED_DOSE
---| '"SPELL_AURA_REMOVED_DOSE"' # SPELL_AURA_REMOVED_DOSE
---| '"SPELL_DISPEL"' # SPELL_DISPEL
---| '""' # No event type; refresh data and nothing else