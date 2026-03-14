---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Item = {}

---Checks if an item link matches the given item ID and has a specific bonus ID
---@param itemLink string The item link string to parse
---@param id integer The item ID to match against
---@param bonusId integer The bonus ID to search for in the item's bonus list
---@return boolean found True if the item matches the ID and contains the bonus ID
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

---Determines if the currently equipped item matches the specified item id
---@param itemLink string? # ItemLink we are using the verify
---@param id integer # Item Id we are checking for
---@return boolean # Is this a match?
function TRB.Functions.Item:DoesItemLinkMatchId(itemLink, id)
	if itemLink == nil or id == nil then
		return false
	end
	local parts = { strsplit(":", itemLink) }
	-- Note for Future Twintop:
	--  1  = Item Name
	--  2  = Item Id
	--[[
		2025-03-10:
			There is a bug (?) on 11.1.5 PTR where there is an extra entry at the start of the parts table.
	 		We're going to check both part[2] and part[3] to account for this.
	]]

	if tonumber(parts[2]) == id or (type(parts[2] == "string") and tonumber(parts[3]) == id) then
		return true
	end
	return false
end

---Retrieves the item level of an item from its item link
---@param itemLink string? The item link to get the item level for
---@return integer|nil itemLevel The item level, or nil if itemLink is nil
function TRB.Functions.Item:GetItemLevelOfItem(itemLink)
	if itemLink == nil then
		return nil
	end
	return select(1, C_Item.GetDetailedItemLevelInfo(itemLink))
end