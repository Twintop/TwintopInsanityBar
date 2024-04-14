---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
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
        {
            name = "modifier",
            dataType = "number",
            index = 1
        }
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
        {
            name = "manaPerTick",
            dataType = "number",
            index = 1
        }
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
        if duration ~= nil then
            self.buff.duration = duration
        else
            self.buff.duration = self.spell.duration
        end

        local currentTime = GetTime()
        self.buff.endTime = currentTime + self.buff.duration
        self.buff.isActive = true
    else
        self.buff:Initialize(eventType)
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
        self.mana = self.buff:GetRemainingTime() * manaRegen / 2
    else
        self.mana = 0
    end
end


--[[
    **************************
    ***** Symbol of Hope *****
    **************************
    ]]

---@class TRB.Classes.Healer.SymbolOfHope : TRB.Classes.Healer.HealerRegenBase
---@field public buff TRB.Classes.Healer.SymbolOfHopeBuff
TRB.Classes.Healer.SymbolOfHope = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.SymbolOfHope.__index = TRB.Classes.Healer.SymbolOfHope

---Creates a new SymbolOfHope object
---@param spell table # Spell we are snapshotting, in this case SymbolOfHope
---@return TRB.Classes.Healer.SymbolOfHope
function TRB.Classes.Healer.SymbolOfHope:New(spell, calculateManaGainFunction)
    ---@type TRB.Classes.BuffCustomProperty[]
    local definitions = {}
    ---@type TRB.Classes.Healer.HealerRegenBase
    local snapshot = TRB.Classes.Healer.HealerRegenBase
    ---@type TRB.Classes.Healer.SymbolOfHope
    local self = setmetatable(snapshot:New(spell, nil), TRB.Classes.Healer.SymbolOfHope)
    ---@type TRB.Classes.Healer.SymbolOfHopeBuff
    self.buff = TRB.Classes.Healer.SymbolOfHopeBuff:New(self)
    self.buff:SetCustomProperties(definitions)
    self:Reset()
    self.buff.CalculateManaGainFunction = calculateManaGainFunction
    self.attributes = {}
    return self
end

---Resets SymbolOfHope's values to default
function TRB.Classes.Healer.SymbolOfHope:Reset()
    self.buff:Reset()
    self.mana = 0
end

---comment
---@param totalTicks integer
---@param tickRate number
---@param nextTickRemaining number
---@param forceManaInclusion boolean?
---@return number
function TRB.Classes.Healer.SymbolOfHope:CalculateTime(totalTicks, tickRate, nextTickRemaining, forceManaInclusion)
    local manaRaw = 0
    local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
    local casting = snapshotData.casting
    local manaRegen = snapshotData.attributes.manaRegen
    local resource = snapshotData.attributes.resource

    for x = 1, totalTicks do
        local casterRegen = 0
        if casting.spellId == self.spell.id or forceManaInclusion then
            if x == 1 then
                casterRegen = nextTickRemaining * manaRegen
            else
                casterRegen = manaRegen * tickRate
            end
        end

        local estimatedManaMissing = TRB.Data.character.maxResource - (casterRegen + manaRaw + (resource / TRB.Data.resourceFactor))
        local nextTick = self.spell.manaPercent * math.max(0, math.min(TRB.Data.character.maxResource, estimatedManaMissing))
        manaRaw = manaRaw + nextTick + casterRegen
    end

    return manaRaw
end

---Updates SymbolOfHope's values
function TRB.Classes.Healer.SymbolOfHope:Update()
    local activePreviously = self.buff.isActive
    self.buff:Refresh(nil, nil, nil)
    if self.buff.isActive then
        if self.buff.ticks <= 0 or self.buff.tickRate == 0 then
            self:Reset()
            return
        end

        if self.buff.ticks > self.spell.ticks then
            self:Reset()
            return
        end

        local nextTickRemaining = self.buff.remaining - ((self.buff.ticks - 1) * self.buff.tickRate)
        local manaRaw = self:CalculateTime(self.buff.ticks, self.buff.tickRate, nextTickRemaining)
        
        self.buff.manaRaw = manaRaw
        self.buff.mana = self.buff.CalculateManaGainFunction(self.buff.manaRaw, false)
        self.mana = self.buff.mana
    elseif activePreviously then
        self:Reset()
    end
end


---@class TRB.Classes.Healer.SymbolOfHopeBuff : TRB.Classes.SnapshotBuff
---@field public ticks integer
---@field public tickRate number
---@field public manaRaw number
---@field public mana number
---@field public CalculateManaGainFunction function
TRB.Classes.Healer.SymbolOfHopeBuff = setmetatable({}, {__index = TRB.Classes.SnapshotBuff})
TRB.Classes.Healer.SymbolOfHopeBuff.__index = TRB.Classes.Healer.SymbolOfHopeBuff

---Creates a new SymbolOfHopeBuff object
---@param parent TRB.Classes.Healer.HealerRegenBase
---@return TRB.Classes.Healer.SymbolOfHopeBuff
function TRB.Classes.Healer.SymbolOfHopeBuff:New(parent)
    ---@type TRB.Classes.SnapshotBuff
    local snapshotBuff = TRB.Classes.SnapshotBuff
    ---@type TRB.Classes.Healer.SymbolOfHopeBuff
    local self = setmetatable(snapshotBuff:New(parent), TRB.Classes.Healer.SymbolOfHopeBuff)
    self:Reset()

    ---@diagnostic disable-next-line: return-type-mismatch
    return self
end

---Resets the object to default values
function TRB.Classes.Healer.SymbolOfHopeBuff:Reset()
    TRB.Classes.SnapshotBuff:Reset(self)
    self.ticks = 0
    self.tickRate = 0
    self.manaRaw = 0
    self.mana = 0
end

---Initializes the buff information for the snapshot
---@param eventType trbAuraEventType? # Event type sourced from the combat log event. If not provided, will do a generic buff update
---@param simple? boolean # Just updates isActive. If not provided, defaults to `false`
---@param unit? UnitId # Unit we want to check to update. If not provided, defaults to `player`
function TRB.Classes.Healer.SymbolOfHopeBuff:Initialize(eventType, simple, unit)
    unit = unit or "player"
    if simple == nil then
        simple = false
    end

    self:Refresh(eventType, simple, unit)
end

---Refreshes the buff information for the snapshot
---@param eventType trbAuraEventType? # Event type sourced from the combat log event. If not provided, will do a generic buff update
---@param simple boolean? # Just updates isActive. If not provided, defaults to `false`
---@param unit UnitId? # Unit we want to check to update. If not provided, defaults to `player`
function TRB.Classes.Healer.SymbolOfHopeBuff:Refresh(eventType, simple, unit)
    TRB.Classes.SnapshotBuff.Refresh(self, eventType, simple, unit)

    if eventType ~= nil and eventType ~= "" then
        if eventType == "SPELL_AURA_APPLIED" then
            self.ticks = self.parent.spell.ticks
            self.tickRate = self.duration / self.ticks
        elseif eventType == "SPELL_AURA_REMOVED" then
            self:Reset()
        elseif eventType == "SPELL_ENERGIZE" then
            if self.isActive then
                self.ticks = math.max(self.ticks - 1, 0)

                if self.ticks <= 0 then
                    self.parent:Reset()
                else
                    self.parent:Update()
                end
            end
        end
    end
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
        {
            name = "modifier",
            dataType = "number",
            index = 2
        }
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
---@return TRB.Classes.Healer.ChanneledManaPotion
function TRB.Classes.Healer.ChanneledManaPotion:New(spell, calculateManaGainFunction)
    ---@type TRB.Classes.BuffCustomProperty[]
    local definitions = {
        {
            name = "manaPerTick",
            dataType = "number",
            index = 1
        }
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


--[[
    ***************************
    ***** Molten Radiance *****
    ***************************
    ]]

---@class TRB.Classes.Healer.MoltenRadiance : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
---@field public ticks integer
TRB.Classes.Healer.MoltenRadiance = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.MoltenRadiance.__index = TRB.Classes.Healer.MoltenRadiance

---Creates a new MoltenRadiance object
---@param spell table # Spell we are snapshotting, in this case MoltenRadiance
---@return TRB.Classes.Healer.MoltenRadiance
function TRB.Classes.Healer.MoltenRadiance:New(spell)
    ---@type TRB.Classes.BuffCustomProperty[]
    local definitions = {
        {
            name = "manaPerTick",
            dataType = "number",
            index = 3
        }
    }
    ---@type TRB.Classes.Healer.HealerRegenBase
    local snapshot = TRB.Classes.Healer.HealerRegenBase
    local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.MoltenRadiance)
    self.buff:SetCustomProperties(definitions)
    self:Reset()
    self.attributes = {}
    return self
end

---Resets MoltenRadiance's values to default
function TRB.Classes.Healer.MoltenRadiance:Reset()
    ---@type TRB.Classes.Healer.HealerRegenBase
    local snapshot = TRB.Classes.Healer.HealerRegenBase
    snapshot.Reset(self)
    self.ticks = 0
end

---Updates MoltenRadiance's values
function TRB.Classes.Healer.MoltenRadiance:Update()
    if self.buff.isActive then
        self.ticks = TRB.Functions.Number:RoundTo(self.buff:GetRemainingTime(), 0, "ceil", true)
        self.mana = (self.buff.customProperties["manaPerTick"] or 0) * self.ticks
    else
        self.ticks = 0
        self.mana = 0
    end
end


--[[
    ******************************
    ***** Blessing of Winter *****
    ******************************
    ]]

---@class TRB.Classes.Healer.BlessingOfWinter : TRB.Classes.Healer.HealerRegenBase
---@field public mana number
---@field public ticks integer
TRB.Classes.Healer.BlessingOfWinter = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.BlessingOfWinter.__index = TRB.Classes.Healer.BlessingOfWinter

---Creates a new BlessingOfWinter object
---@param spell table # Spell we are snapshotting, in this case BlessingOfWinter
---@return TRB.Classes.Healer.BlessingOfWinter
function TRB.Classes.Healer.BlessingOfWinter:New(spell)
    ---@type TRB.Classes.Healer.HealerRegenBase
    local snapshot = TRB.Classes.Healer.HealerRegenBase
    local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.BlessingOfWinter)
    self:Reset()
    self.attributes = {}
    return self
end

---Resets BlessingOfWinter's values to default
function TRB.Classes.Healer.BlessingOfWinter:Reset()
    ---@type TRB.Classes.Healer.HealerRegenBase
    local snapshot = TRB.Classes.Healer.HealerRegenBase
    snapshot.Reset(self)
    self.ticks = 0
end

---Updates BlessingOfWinter's values
function TRB.Classes.Healer.BlessingOfWinter:Update()
    if self.buff.isActive then
        self.buff:UpdateTicks()
        self.mana = self.spell.manaPercent * TRB.Data.character.maxResource * self.buff.ticks
    else
        self.ticks = 0
        self.mana = 0
    end
end