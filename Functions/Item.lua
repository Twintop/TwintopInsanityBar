---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Item = {}

function TRB.Functions.Item:DoesItemLinkMatchMatchIdAndHaveBonus(itemLink, id, bonusId)
	local parts = { strsplit(":", itemLink) }
	-- Note for Future Twintop:
	--  1  = Item Name
	--  2  = Item Id
	-- 14  = # of Bonuses
	-- 15+ = Bonuses
	if tonumber(parts[2]) == id and tonumber(parts[14]) > 0 then
		for x = 1, tonumber(parts[14]) do
			if tonumber(parts[14+x]) == bonusId then
				return true
			end
		end
	end
	return false
end

function TRB.Functions.Item:DoesItemLinkMatchId(itemLink, id)
	local parts = { strsplit(":", itemLink) }
	-- Note for Future Twintop:
	--  1  = Item Name
	--  2  = Item Id
	if tonumber(parts[2]) == id then
		return true
	end
	return false
end

function TRB.Functions.Item:GetItemLevelOfItem(itemLink)
	if itemLink == nil then
		return nil
	end
	return select(1, C_Item.GetDetailedItemLevelInfo(itemLink))
end