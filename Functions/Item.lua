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

---The five class set (tier) pieces of a season's set, as item ids. Any piece may be omitted.
---@class TRB.Classes.ItemSetDefinition
---@field public headId integer?
---@field public shoulderId integer?
---@field public chestId integer?
---@field public handId integer?
---@field public legId integer?

-- Inventory slot each set definition field is worn in.
local setPieceSlots = {
	headId = 1,
	shoulderId = 3,
	chestId = 5,
	legId = 7,
	handId = 10,
}

-- Equipment changes anywhere else on the character can't alter a set count, so they're ignored outright.
local setPieceSlotIds = {
	[1] = true,
	[3] = true,
	[5] = true,
	[7] = true,
	[10] = true,
}

-- Equipped piece count for every set in TRB.Data.itemSetRegistry, keyed by set key. Computed only when gear
-- changes; reads are a table lookup and never touch the inventory. Module-local rather than on
-- TRB.Data.character because that table is swapped out wholesale whenever a spec cache is loaded.
local setPieceCounts = {}

---Recomputes equipped piece counts for every registered class set. Only called on a gear change.
local function RefreshSetPieceCounts()
	wipe(setPieceCounts)
	local registry = TRB.Data.itemSetRegistry
	if registry == nil then
		return
	end
	for setKey, setDefinition in pairs(registry) do
		local count = 0
		for field, slot in pairs(setPieceSlots) do
			local itemId = setDefinition[field]
			if itemId ~= nil and TRB.Functions.Item:DoesItemLinkMatchId(GetInventoryItemLink("player", slot), itemId) then
				count = count + 1
			end
		end
		setPieceCounts[setKey] = count
	end
end

local setPieceFrame = CreateFrame("Frame")
setPieceFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
setPieceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
setPieceFrame:SetScript("OnEvent", function(_, event, slot)
	if event == "PLAYER_EQUIPMENT_CHANGED" and not setPieceSlotIds[slot] then
		return
	end
	RefreshSetPieceCounts()
end)

---How many pieces of a registered class set the player has equipped. Read from the cached count maintained
---by gear-change events -- this never scans the inventory, so it is safe to call from hot paths.
---@param setKey string? # Key the set is registered under in TRB.Data.itemSetRegistry
---@return integer # Equipped piece count, 0 for an unknown or unregistered set
function TRB.Functions.Item:GetEquippedSetPieceCount(setKey)
	return (setKey ~= nil and setPieceCounts[setKey]) or 0
end

---Whether the player has enough pieces of a registered class set equipped for one of its set bonuses.
---@param setKey string? # Key the set is registered under in TRB.Data.itemSetRegistry
---@param pieces integer? # Pieces the bonus requires, defaults to 2
---@return boolean
function TRB.Functions.Item:HasSetBonus(setKey, pieces)
	return self:GetEquippedSetPieceCount(setKey) >= (pieces or 2)
end