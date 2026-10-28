local _, TRB = ...

TRB.Classes = TRB.Classes or {}
TRB.Classes.Mainline.Healer = TRB.Classes.Mainline.Healer or {}


--[[
	***************************
	***** HealerRegenBase *****
	***************************
	]]

---@class TRB.Classes.Mainline.Healer.HealerRegenBase : TRB.Classes.Snapshot
---@field public mana number
TRB.Classes.Mainline.Healer.HealerRegenBase = setmetatable({}, {__index = TRB.Classes.Snapshot})
TRB.Classes.Mainline.Healer.HealerRegenBase.__index = TRB.Classes.Mainline.Healer.HealerRegenBase

---Creates a new HealerRegenBase object
---@param spell table # Spell we are snapshotting.
---@param attributes table? # Custom attributes to be tracked.
---@return TRB.Classes.Mainline.Healer.HealerRegenBase
function TRB.Classes.Mainline.Healer.HealerRegenBase:New(spell, attributes)
	---@type TRB.Classes.Snapshot
	local snapshot = TRB.Classes.Snapshot
	local self = setmetatable(snapshot:New(spell, attributes), TRB.Classes.Mainline.Healer.HealerRegenBase)
	self:Reset()
	return self
end

---Resets HealerRegenBase's values to default
function TRB.Classes.Mainline.Healer.HealerRegenBase:Reset()
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

---@class TRB.Classes.Mainline.Healer.Innervate : TRB.Classes.Mainline.Healer.HealerRegenBase
---@field public mana number
---@field public modifier number
TRB.Classes.Mainline.Healer.Innervate = setmetatable({}, {__index = TRB.Classes.Mainline.Healer.HealerRegenBase})
TRB.Classes.Mainline.Healer.Innervate.__index = TRB.Classes.Mainline.Healer.Innervate

---Creates a new Innervate object
---@param spell table # Spell we are snapshotting, in this case Innervate
---@return TRB.Classes.Mainline.Healer.Innervate
function TRB.Classes.Mainline.Healer.Innervate:New(spell)
	---@type TRB.Classes.BuffCustomProperty[]
	local definitions = {
		TRB.Classes.BuffCustomProperty:New(1, "number", "modifier", 1)
	}
	---@type TRB.Classes.Mainline.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Mainline.Healer.HealerRegenBase
	local self = setmetatable(snapshot:New(spell), TRB.Classes.Mainline.Healer.Innervate)
	self.buff:SetCustomProperties(definitions)
	self:Reset()
	return self
end

---Resets Innervate's values to default
function TRB.Classes.Mainline.Healer.Innervate:Reset()
	---@type TRB.Classes.Mainline.Healer.HealerRegenBase
	local snapshot = TRB.Classes.Mainline.Healer.HealerRegenBase
	snapshot.Reset(self)
	self.modifier = 1
end

---Updates Innervate's values
function TRB.Classes.Mainline.Healer.Innervate:Update()
	if self.buff.isActive then
		local manaRegen = TRB.Data.snapshotData.attributes.manaRegen
		self.modifier = (100 + (self.buff.customProperties["modifier"] or 100)) / 100
		self.mana = self.buff:GetRemainingTime() * manaRegen * (1 - self.modifier)
	else
		self.modifier = 1
		self.mana = 0
	end
end

---@class TRB.Classes.Mainline.Healer.HealerSpells : TRB.Classes.SpecializationSpellsBase
TRB.Classes.Mainline.Healer.HealerSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Mainline.Healer.HealerSpells.__index = TRB.Classes.Mainline.Healer.HealerSpells

function TRB.Classes.Mainline.Healer.HealerSpells:New()
	---@type TRB.Classes.SpecializationSpellsBase
	local base = TRB.Classes.SpecializationSpellsBase
	self = setmetatable(base:New(), {__index = TRB.Classes.Mainline.Healer.HealerSpells})
	
	--[[
	-- External mana
	self.innervate = TRB.Classes.SpellBase:New({
		id = 29166,
		duration = 10
	})]]
	
	return self
end