---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Item = {}

local conjuredChillglobeMana = {
	[75] = 44,		-- TBC/Wrath Timewalking
	[90] = 60,		-- Cata/MoP Timewalking
	[105] = 81,		-- WoD Timewalking
	[120] = 108,	-- Legion Timewalking
	[376] = 3263,	-- DF S1 LFR
	[389] = 3521,	-- DF S1 Normal
	[402] = 4329,	-- DF S1 Heroic
	[415] = 5287,	-- DF S1 Mythic
	[480] = 13362,	-- DF S4 LFR 1/8 Veteran
	[483] = 13915,
	[486] = 14488,
	[489] = 15084,
	[493] = 15911,	-- DF S4 Normal 1/8 Champion
	[496] = 16559,
	[499] = 17231,
	[502] = 17927,
	[506] = 18896,	-- DF S4 Heroic 1/6 Heroic
	[509] = 19654,
	[512] = 20439,
	[515] = 21254,
	[519] = 22386,	-- DF S4 Mythic 1/4 Myth
	[522] = 23271,
	[525] = 24189,
	[528] = 25139
}

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
	return select(1, C_Item.GetDetailedItemLevelInfo(select(2,C_Item.GetItemInfo(itemLink))))
end

function TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinketItemLink)
	local conjuredChillglobe = TRB.Functions.Item:DoesItemLinkMatchId(trinketItemLink, TRB.Data.character.items.conjuredChillglobe.id)
	if conjuredChillglobe == true then
		local ilvl = TRB.Functions.Item:GetItemLevelOfItem(trinketItemLink)
		return true, conjuredChillglobeMana[ilvl] or 0
	end
	return false, 0
end