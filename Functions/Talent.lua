---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Talent = {}


function TRB.Functions.Talent:GetTalents(baselineTalents)
	local talents = {}
	baselineTalents = baselineTalents or {}
	local _, name, icon, iconString
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
						local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)

						if definitionInfo ~= nil then
							local spellId = nil
							if definitionInfo.spellID ~= nil then
								spellId = definitionInfo.spellID
							elseif definitionInfo.overriddenSpellID ~= nil then
								spellId = definitionInfo.overriddenSpellID
							end
							
							if spellId ~= nil then
---@diagnostic disable-next-line: cast-local-type
								name, _, icon = GetSpellInfo(spellId)
								iconString = string.format("|T%s:0|t", icon)

								talents[spellId] = {
									id = spellId,
									name = name,
									icon = iconString,
									currentRank = node.ranksPurchased,
									maxRank = node.maxRanks,
								}

								if baselineTalents[spellId] ~= nil then
									talents[spellId].currentRank = talents[spellId].maxRank
								end
							end
						end
					end
				end
			end
		end
	end

	return talents
end

function TRB.Functions.Talent:IsTalentActive(spell)
	return spell.baseline == true or
		(TRB.Data.talents[spell.id] ~= nil and TRB.Data.talents[spell.id].currentRank > 0) or
		(TRB.Data.talents[spell.talentId] ~= nil and TRB.Data.talents[spell.talentId].currentRank > 0)
end


-- Source: https://www.wowinterface.com/forums/showpost.php?p=338665&postcount=5
function TRB.Functions.Talent:ArePvpTalentsActive()
    local inInstance, instanceType = IsInInstance()
    if inInstance and (instanceType == "pvp" or instanceType == "arena") then
        return true
    elseif inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
        return false
    else
        local talents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
        for _, pvptalent in pairs(talents) do
---@diagnostic disable-next-line: missing-parameter
            local spellID = select(6, GetPvpTalentInfoByID(pvptalent))
            if IsPlayerSpell(spellID) then
                return true
            end
        end
    end
	return false
end