local _, TRB = ...
if TRB.Data.character.classId ~= 2 and TRB.Data.character.classId ~= 5 and TRB.Data.character.classId ~= 7 and TRB.Data.character.classId ~= 10 and TRB.Data.character.classId ~= 11 and TRB.Data.character.classId ~= 13 then --Only do this if we're on a Healer Class!
	return
end

TRB.Classes = TRB.Classes or {}
TRB.Classes.Healer = TRB.Classes.Healer or {}


--[[
	***************************
	***** HealerRegenBase *****
	***************************
	]]

---@class TRB.Classes.Healer.HealerRegenBase : TRB.Classes.Snapshot
---@field public mana number
TRB.Classes.Healer.HealerRegenBase = setmetatable({}, {__index = TRB.Classes.Snapshot})
TRB.Classes.Healer.HealerRegenBase.__index = TRB.Classes.Healer.HealerRegenBase

---Creates a new HealerRegenBase object
---@param spell table # Spell we are snapshotting.
---@param attributes table? # Custom attributes to be tracked.
---@return TRB.Classes.Healer.HealerRegenBase
function TRB.Classes.Healer.HealerRegenBase:New(spell, attributes)
	---@type TRB.Classes.Snapshot
	local snapshot = TRB.Classes.Snapshot
	local self = setmetatable(snapshot:New(spell, attributes), TRB.Classes.Healer.HealerRegenBase)
	self:Reset()
	return self
end

---Resets HealerRegenBase's values to default
function TRB.Classes.Healer.HealerRegenBase:Reset()
	---@type TRB.Classes.Snapshot
	local snapshot = TRB.Classes.Snapshot
	snapshot.Reset(self)
	self.mana = 0
end


--[[
	*********************
	***** Innervate *****
	*********************
	]]

---@class TRB.Classes.Healer.Innervate : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
---@field public modifier number
TRB.Classes.Healer.Innervate = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.Innervate.__index = TRB.Classes.Healer.Innervate

---Creates a new Innervate object
---@param spell table # Spell we are snapshotting, in this case Innervate
---@return TRB.Classes.Healer.Innervate
function TRB.Classes.Healer.Innervate:New(spell)
	---@type TRB.Classes.BuffCustomProperty[]
	local definitions = {
		TRB.Classes.BuffCustomProperty:New(1, "number", "modifier", 1)
	}
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.Innervate)
	self.buff:SetCustomProperties(definitions)
	self:Reset()
	return self
end

---Resets Innervate's values to default
function TRB.Classes.Healer.Innervate:Reset()
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	snapshot.Reset(self)
	self.modifier = 1
end

---Updates Innervate's values
function TRB.Classes.Healer.Innervate:Update()
	if self.buff.isActive then
		local manaRegen = TRB.Data.snapshotData.attributes.manaRegen
		self.modifier = (100 + (self.buff.customProperties["modifier"] or 100)) / 100
		self.mana = self.buff:GetRemainingTime() * manaRegen * (1 - self.modifier)
	else
		self.modifier = 1
		self.mana = 0
	end
end


--[[
	***************************
	***** Mana Tide Totem *****
	***************************
	]]

---@class TRB.Classes.Healer.ManaTideTotem : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
TRB.Classes.Healer.ManaTideTotem = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.ManaTideTotem.__index = TRB.Classes.Healer.ManaTideTotem

---Creates a new ManaTideTotem object
---@param spell table # Spell we are snapshotting, in this case ManaTideTotem
---@return TRB.Classes.Healer.ManaTideTotem
function TRB.Classes.Healer.ManaTideTotem:New(spell)
	---@type TRB.Classes.BuffCustomProperty[]
	local definitions = {
		TRB.Classes.BuffCustomProperty:New(1, "number", "manaPerTick", 1)
	}
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.ManaTideTotem)
	self.buff:SetCustomProperties(definitions)
	self:Reset()
	self.attributes = {}
	return self
end

---Initializes the spell, then the buff, information for the snapshot
---@param eventType trbAuraEventType? # Event type sourced from the combat log event. If not provided, will do a generic buff update
---@param duration? number # Expected duration of the totem
function TRB.Classes.Healer.ManaTideTotem:Initialize(eventType, duration)
	if (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") then
		if duration == nil then
			duration = self.spell.duration
		end

		local currentTime = GetTime()
		self.buff:InitializeCustom(duration, currentTime)
	elseif eventType == "SPELL_AURA_REMOVED" then
		self:Reset()
	end
end

---Resets ManaTideTotem's values to default
function TRB.Classes.Healer.ManaTideTotem:Reset()
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	snapshot.Reset(self)
	self.mana = 0
end

---Updates ManaTideTotem's values
function TRB.Classes.Healer.ManaTideTotem:Update()
	if self.buff.isActive then
		local manaRegen = TRB.Data.snapshotData.attributes.manaRegen
		self.mana = self.buff:GetRemainingTime() * manaRegen * self.spell.attributes.resourceMod
	else
		self.mana = 0
	end
end


--[[
	***********************
	***** Cannibalize *****
	***********************
	]]

---@class TRB.Classes.Healer.Cannibalize : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
TRB.Classes.Healer.Cannibalize = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.Cannibalize.__index = TRB.Classes.Healer.Cannibalize

---Creates a new Cannibalize object
---@param spell table # Spell we are snapshotting, in this case Cannibalize
---@return TRB.Classes.Healer.Cannibalize
function TRB.Classes.Healer.Cannibalize:New(spell)
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.Cannibalize)
	self:Reset()
	self.attributes = {}
	return self
end

---Updates Cannibalize's values
function TRB.Classes.Healer.Cannibalize:Update()
	self.cooldown:Refresh()
	self.buff:UpdateTicks()
	if self.buff.isActive then
		self.mana = (TRB.Data.snapshotData.attributes.manaRegen * self.buff.remaining) + self.buff.resource * TRB.Data.character.maxResource
	else
		self.mana = 0
	end
end

function TRB.Classes.Healer.Cannibalize:GetMaxManaReturn()
	return (TRB.Data.snapshotData.attributes.manaRegen * self.spell.duration) + (self.spell.duration / self.spell:GetTickRate()) * self.spell.resourcePerTick * TRB.Data.character.maxResource
end


--[[
	*************************************
	***** Potion of Chilled Clarity *****
	*************************************
	]]

---@class TRB.Classes.Healer.PotionOfChilledClarity : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
---@field public modifier number
TRB.Classes.Healer.PotionOfChilledClarity = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.PotionOfChilledClarity.__index = TRB.Classes.Healer.PotionOfChilledClarity

---Creates a new PotionOfChilledClarity object
---@param spell table # Spell we are snapshotting, in this case PotionOfChilledClarity
---@return TRB.Classes.Healer.PotionOfChilledClarity
function TRB.Classes.Healer.PotionOfChilledClarity:New(spell)
	---@type TRB.Classes.BuffCustomProperty[]
	local definitions = {
		TRB.Classes.BuffCustomProperty:New(2, "number", "modifier", 1)
	}
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.PotionOfChilledClarity)
	self.buff:SetCustomProperties(definitions)
	self:Reset()
	self.attributes = {}
	return self
end

---Resets PotionOfChilledClarity's values to default
function TRB.Classes.Healer.PotionOfChilledClarity:Reset()
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	snapshot.Reset(self)
	self.mana = 0
	self.modifier = 1
end

---Updates PotionOfChilledClarity's values
function TRB.Classes.Healer.PotionOfChilledClarity:Update()
	if self.buff.isActive then
		local manaRegen = TRB.Data.snapshotData.attributes.manaRegen
		self.modifier = (100 + (self.buff.customProperties["modifier"] or 100)) / 100
		self.mana = self.buff:GetRemainingTime() * manaRegen * (1 - self.modifier)
	else
		self.modifier = 1
		self.mana = 0
	end
end


--[[
	*********************************
	***** Channeled Mana Potion *****
	*********************************
	]]

---@class TRB.Classes.Healer.ChanneledManaPotion : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
---@field public ticks integer
---@field public CalculateManaGainFunction function
TRB.Classes.Healer.ChanneledManaPotion = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.ChanneledManaPotion.__index = TRB.Classes.Healer.ChanneledManaPotion

---Creates a new ChanneledManaPotion object
---@param spell table # Spell we are snapshotting, in this case ChanneledManaPotion
---@param calculateManaGainFunction function # Function that will calculate mana gain
---@return TRB.Classes.Healer.ChanneledManaPotion
function TRB.Classes.Healer.ChanneledManaPotion:New(spell, calculateManaGainFunction)
	---@type TRB.Classes.BuffCustomProperty[]
	local definitions = {
		TRB.Classes.BuffCustomProperty:New(1, "number", "manaPerTick", 1)
	}
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.ChanneledManaPotion)
	self.CalculateManaGainFunction = calculateManaGainFunction
	self.buff:SetCustomProperties(definitions)
	self:Reset()
	self.attributes = {}
	return self
end

---Resets ChanneledManaPotion's values to default
function TRB.Classes.Healer.ChanneledManaPotion:Reset()
	---@type TRB.Classes.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Healer.HealerRegenBase
	snapshot.Reset(self)
	self.ticks = 0
end

---Updates ChanneledManaPotion's values
function TRB.Classes.Healer.ChanneledManaPotion:Update()
	if self.buff.isActive then
		local manaRegen = TRB.Data.snapshotData.attributes.manaRegen
		self.ticks = TRB.Functions.Number:RoundTo(self.buff:GetRemainingTime(), 0, "ceil", true)
		self.mana = self.ticks * self.CalculateManaGainFunction(self.buff.customProperties["manaPerTick"] or 0, true) + (self.buff:GetRemainingTime() * manaRegen)
	else
		self.ticks = 0
		self.mana = 0
	end
end


---@class TRB.Classes.Healer.HealerSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Healer.HealerSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Healer.HealerSpells.__index = TRB.Classes.Healer.HealerSpells

function TRB.Classes.Healer.HealerSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), {__index = TRB.Classes.Healer.HealerSpells})
	
	--[[
	-- External mana
	self.innervate = TRB.Classes.SpellBase:New({
		id = 29166,
		duration = 10
	})
	self.manaTideTotem = TRB.Classes.SpellBase:New({
		id = 320763,
		duration = 8,
		resourceMod = 0.8
	})

	-- Potions
	self.algariManaPotionRank1 = TRB.Classes.SpellThreshold:New({
		id = 431418,
		itemId = 212239,
		spellId = 431418,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_flask_blue",
		useSpellIcon = true,
		settingKey = "algariManaPotionRank1",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.algariManaPotionRank2 = TRB.Classes.SpellThreshold:New({
		id = 431418,
		itemId = 212240,
		spellId = 431418,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_flask_blue",
		useSpellIcon = true,
		settingKey = "algariManaPotionRank2",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.algariManaPotionRank3 = TRB.Classes.SpellThreshold:New({
		id = 431418,
		itemId = 212241,
		spellId = 431418,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_flask_blue",
		useSpellIcon = true,
		settingKey = "algariManaPotionRank3",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.cavedwellersDelightRank1 = TRB.Classes.SpellThreshold:New({
		id = 431419,
		itemId = 212242,
		spellId = 431419,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_alchemy_elixir_06",
		useSpellIcon = true,
		settingKey = "cavedwellersDelightRank1",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.cavedwellersDelightRank2 = TRB.Classes.SpellThreshold:New({
		id = 431419,
		itemId = 212243,
		spellId = 431419,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_alchemy_elixir_06",
		useSpellIcon = true,
		settingKey = "cavedwellersDelightRank2",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.cavedwellersDelightRank3 = TRB.Classes.SpellThreshold:New({
		id = 431419,
		itemId = 212244,
		spellId = 431419,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_alchemy_elixir_06",
		useSpellIcon = true,
		settingKey = "cavedwellersDelightRank3",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.slumberingSoulSerumRank1 = TRB.Classes.SpellThreshold:New({
		id = 431422,
		itemId = 212245,
		spellId = 431422,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_flask_green",
		useSpellIcon = true,
		settingKey = "slumberingSoulSerumRank1",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.slumberingSoulSerumRank2 = TRB.Classes.SpellThreshold:New({
		id = 431422,
		itemId = 212246,
		spellId = 431422,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_flask_green",
		useSpellIcon = true,
		settingKey = "slumberingSoulSerumRank2",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.slumberingSoulSerumRank3 = TRB.Classes.SpellThreshold:New({
		id = 431422,
		itemId = 212247,
		spellId = 431422,
		primaryResourceType = Enum.PowerType.Mana,
		iconName = "inv_flask_green",
		useSpellIcon = true,
		settingKey = "slumberingSoulSerumRank3",
		isPotion = true,
		hasCooldown = true,
		rangeCheck = false
	})
	self.potionOfChilledClarity = TRB.Classes.SpellBase:New({
		id = 371052
	})

	-- Alchemist Stone
	local alchemistStoneItemIds = {
		-- The War Within
		210816,
		-- Shadowlands
		175943,
		175942,
		175941,
		171323,
		-- Battle for Azeroth
		171088,
		171087,
		171085,
		168676,
		168675,
		168674,
		166976,
		166975,
		166974,
		165928,
		165927,
		165926,
		152637,
		152632,
		-- Legion
		151607,
		127842,
		-- Warlords of Draenor
		128024,
		128023,
		122604,
		122603,
		122602,
		122601,
		109262,
		-- Mists of Pandaria
		75274,
		-- Cataclysm
		68777,
		68776,
		68775,
		58483,
		-- Wrath of the Lich King
		44324,
		44323,
		44322,
		-- Burning Crusade
		35751,
		35750,
		35749,
		35748,
		13503
	}

	self.alchemistStone = TRB.Classes.SpellBase:New({
		id = 17619,
		resourcePercent = 1.4,
		isAlchemistStoneEquipped = function ()
			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)
			if trinket1ItemLink ~= nil then
				for x = 1, #alchemistStoneItemIds do
					if TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, alchemistStoneItemIds[x]) then
						return true
					end
					
					if TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, alchemistStoneItemIds[x]) then
						return true
					end
				end
			end
			return false
		end
	})]]
	
	return self
end