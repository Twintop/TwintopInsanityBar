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

function TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinketItemLink)
	local conjuredChillglobe = TRB.Functions.Item:DoesItemLinkMatchMatchIdAndHaveBonus(trinketItemLink, TRB.Data.character.items.conjuredChillglobe.id, TRB.Data.character.items.conjuredChillglobe.lfr.bonusId)
	if conjuredChillglobe == true then
		return true, "lfr"
	end
	
	conjuredChillglobe = TRB.Functions.Item:DoesItemLinkMatchMatchIdAndHaveBonus(trinketItemLink, TRB.Data.character.items.conjuredChillglobe.id, TRB.Data.character.items.conjuredChillglobe.normal.bonusId)
	if conjuredChillglobe == true then
		return true, "normal"
	end
	
	conjuredChillglobe = TRB.Functions.Item:DoesItemLinkMatchMatchIdAndHaveBonus(trinketItemLink, TRB.Data.character.items.conjuredChillglobe.id, TRB.Data.character.items.conjuredChillglobe.heroic.bonusId)
	if conjuredChillglobe == true then
		return true, "heroic"
	end

	conjuredChillglobe = TRB.Functions.Item:DoesItemLinkMatchMatchIdAndHaveBonus(trinketItemLink, TRB.Data.character.items.conjuredChillglobe.id, TRB.Data.character.items.conjuredChillglobe.mythic.bonusId)
	if conjuredChillglobe == true then
		return true, "mythic"
	end
	
	return false, ""
end