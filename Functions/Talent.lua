---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Talent = {}

-- Source: https://www.wowinterface.com/forums/showpost.php?p=338665&postcount=5
function TRB.Functions.Talent:ArePvpTalentsActive()
	local inInstance, instanceType = IsInInstance()
	if inInstance and (instanceType == "pvp" or instanceType == "arena") then
		return true
	elseif inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
		return false
	else
		local talents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
		for _, pvpTalent in pairs(talents) do
---@diagnostic disable-next-line: missing-parameter
			local spellId = select(6, GetPvpTalentInfoByID(pvpTalent))
			if IsPlayerSpell(spellId) then
				return true
			end
		end
	end
	return false
end