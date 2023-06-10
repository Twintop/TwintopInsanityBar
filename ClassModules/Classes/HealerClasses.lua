---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Classes.Healer = TRB.Classes.Healer or {}

---@class TRB.Classes.Healer.Innervate : TRB.Classes.Snapshot
---@field public mana number
---@field public modifier number
TRB.Classes.Healer.Innervate = setmetatable({}, {__index = TRB.Classes.Snapshot})
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
            index = 16
        }
    }
    ---@type TRB.Classes.Snapshot
    local snapshot = TRB.Classes.Snapshot
    local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.Innervate)
    self.buff:SetCustomProperties(definitions)
    self:Reset()
    self.attributes = {}
    return self
end

---Resets Innervate's values to default
function TRB.Classes.Healer.Innervate:Reset()
    ---@type TRB.Classes.Snapshot
    local snapshot = TRB.Classes.Snapshot
    snapshot.Reset(self)
    self.mana = 0
    self.modifier = 1
end

---Updates Innervate's values
function TRB.Classes.Healer.Innervate:Update()
    if self.buff.isActive then
        local manaRegen = 0

        if TRB.Data.snapshotData ~= nil then
            manaRegen = TRB.Data.snapshotData.attributes.manaRegen
        else
            manaRegen = TRB.Data.snapshot.manaRegen
        end
        self.modifier = (100 + (self.buff.customProperties["modifier"] or 100)) / 100
        self.mana = self.buff:GetRemainingTime() * manaRegen * (1 - self.modifier)
    else
        self.mana = 0
    end
end




---@class TRB.Classes.Healer.SymbolOfHope : TRB.Classes.Snapshot
---@field public buff TRB.Classes.Healer.SymbolOfHopeBuff
TRB.Classes.Healer.SymbolOfHope = setmetatable({}, {__index = TRB.Classes.Snapshot})
TRB.Classes.Healer.SymbolOfHope.__index = TRB.Classes.Healer.SymbolOfHope

---Creates a new SymbolOfHope object
---@param spell table # Spell we are snapshotting, in this case SymbolOfHope
---@return TRB.Classes.Healer.SymbolOfHope
function TRB.Classes.Healer.SymbolOfHope:New(spell, calculateManaGainFunction)
    ---@type TRB.Classes.BuffCustomProperty[]
    local definitions = {}
    ---@type TRB.Classes.Snapshot
    local snapshot = TRB.Classes.Snapshot
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
end

---Updates SymbolOfHope's values
function TRB.Classes.Healer.SymbolOfHope:Update()
    self.buff:Refresh(nil, nil, nil)
    if self.buff.isActive then
        if self.buff.ticks <= 0 or self.buff.tickRate == 0 then
            self.buff:Reset()
            return
        end

        if self.buff.ticks > self.spell.ticks then
            self.buff:Reset()
            return
        end

        local nextTickRemaining = self.buff.remaining - ((self.buff.ticks - 1) * self.buff.tickRate)
        self.buff.manaRaw = 0

        local casting
        local manaRegen
        local resource

        if TRB.Data.snapshotData ~= nil then
            ---@type TRB.Classes.SnapshotCasting
            casting = TRB.Data.snapshotData.casting
            manaRegen = TRB.Data.snapshotData.attributes.manaRegen
            resource = TRB.Data.snapshotData.attributes.resource
        else
            casting = TRB.Data.snapshot.casting
            manaRegen = TRB.Data.snapshot.manaRegen
            resource = TRB.Data.snapshotData.attributes.resource
        end

        for x = 1, self.buff.ticks do
            local casterRegen = 0
            if casting.spellId == self.spell.id then
                if x == 1 then
                    casterRegen = nextTickRemaining * manaRegen
                else
                    casterRegen = manaRegen * self.buff.tickRate
                end
            end

            local estimatedManaMissing = TRB.Data.character.maxResource - (casterRegen + self.buff.manaRaw + (resource / TRB.Data.resourceFactor))
            local nextTick = self.spell.manaPercent * math.max(0, math.min(TRB.Data.character.maxResource, estimatedManaMissing))
            self.buff.manaRaw = self.buff.manaRaw + nextTick + casterRegen
        end
        
        self.buff.mana = self.buff.CalculateManaGainFunction(self.buff.manaRaw, false)
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
---@param parent TRB.Classes.Snapshot
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



---@class TRB.Classes.Healer.MoltenRadiance : TRB.Classes.Snapshot
---@field public mana number
---@field public ticks integer
TRB.Classes.Healer.MoltenRadiance = setmetatable({}, {__index = TRB.Classes.Snapshot})
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
            index = 18
        }
    }
    ---@type TRB.Classes.Snapshot
    local snapshot = TRB.Classes.Snapshot
    local self = setmetatable(snapshot:New(spell), TRB.Classes.Healer.MoltenRadiance)
    self.buff:SetCustomProperties(definitions)
    self:Reset()
    self.attributes = {}
    return self
end

---Resets MoltenRadiance's values to default
function TRB.Classes.Healer.MoltenRadiance:Reset()
    ---@type TRB.Classes.Snapshot
    local snapshot = TRB.Classes.Snapshot
    snapshot.Reset(self)
    self.mana = 0
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