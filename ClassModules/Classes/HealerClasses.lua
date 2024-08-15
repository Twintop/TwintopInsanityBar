local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 2 and classIndexId ~= 5 and classIndexId ~= 7 and classIndexId ~= 10 and classIndexId ~= 11 and classIndexId ~= 13 then --Only do this if we're on a Healer Class!
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
        {
            name = "modifier",
            dataType = "number",
            index = 1,
            modifier = 1
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
            index = 1,
            modifier = 1
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
---@field public calculateManaGainFunction function # Function that will calculate mana gain
TRB.Classes.Healer.SymbolOfHope = setmetatable({}, {__index = TRB.Classes.Healer.HealerRegenBase})
TRB.Classes.Healer.SymbolOfHope.__index = TRB.Classes.Healer.SymbolOfHope

---Creates a new SymbolOfHope object
---@param spell table # Spell we are snapshotting, in this case SymbolOfHope
---@param calculateManaGainFunction function # Function that will calculate mana gain
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
        local nextTick = self.spell.attributes.resourcePercent * math.max(0, math.min(TRB.Data.character.maxResource, estimatedManaMissing))
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
                    self:UpdateTicks()
                end
            end
        end
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
    return (TRB.Data.snapshotData.attributes.manaRegen * self.spell.duration) + (self.spell.duration / self.spell.tickRate) * self.spell.resourcePerTick * TRB.Data.character.maxResource
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
            index = 2,
            modifier = 1
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
---@param calculateManaGainFunction function # Function that will calculate mana gain
---@return TRB.Classes.Healer.ChanneledManaPotion
function TRB.Classes.Healer.ChanneledManaPotion:New(spell, calculateManaGainFunction)
    ---@type TRB.Classes.BuffCustomProperty[]
    local definitions = {
        {
            name = "manaPerTick",
            dataType = "number",
            index = 1,
            modifier = 1
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
            index = 3,
            modifier = 1
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
        self.mana = self.spell.attributes.resourcePercent * TRB.Data.character.maxResource * self.buff.ticks
    else
        self.ticks = 0
        self.mana = 0
    end
end


---@class TRB.Classes.Healer.HealerSpells : TRB.Classes.SpecializationSpellsBase
---@field public symbolOfHope TRB.Classes.SpellBase
---@field public innervate TRB.Classes.SpellBase
---@field public manaTideTotem TRB.Classes.SpellBase
---@field public blessingOfWinter TRB.Classes.SpellBase
---@field public alchemistStone TRB.Classes.SpellBase
---@field public moltenRadiance TRB.Classes.SpellBase
---@field public potionOfChilledClarity TRB.Classes.SpellBase
---@field public algariManaPotionRank1 TRB.Classes.SpellThreshold
---@field public algariManaPotionRank2 TRB.Classes.SpellThreshold
---@field public algariManaPotionRank3 TRB.Classes.SpellThreshold
---@field public cavedwellersDelightRank1 TRB.Classes.SpellThreshold
---@field public cavedwellersDelightRank2 TRB.Classes.SpellThreshold
---@field public cavedwellersDelightRank3 TRB.Classes.SpellThreshold
---@field public slumberingSoulSerumRank1 TRB.Classes.SpellThreshold
---@field public slumberingSoulSerumRank2 TRB.Classes.SpellThreshold
---@field public slumberingSoulSerumRank3 TRB.Classes.SpellThreshold
TRB.Classes.Healer.HealerSpells = setmetatable({}, {__index = TRB.Classes.SpecializationSpellsBase})
TRB.Classes.Healer.HealerSpells.__index = TRB.Classes.Healer.HealerSpells

function TRB.Classes.Healer.HealerSpells:New()
    ---@type TRB.Classes.SpecializationSpellsBase
    local base = TRB.Classes.SpecializationSpellsBase
    self = setmetatable(base:New(), {__index = TRB.Classes.Healer.HealerSpells})
    
    -- External mana
    self.symbolOfHope = TRB.Classes.SpellBase:New({
        id = 64901,
        duration = 4.0, --Hasted
        resourcePercent = 0.02,
        ticks = 4,
        tickId = 265144,
        hasCooldown = true
    })
    self.innervate = TRB.Classes.SpellBase:New({
        id = 29166,
        duration = 10
    })
    self.manaTideTotem = TRB.Classes.SpellBase:New({
        id = 320763,
        duration = 8
    })
    self.blessingOfWinter = TRB.Classes.SpellBase:New({
        id = 388011,
        tickRate = 2,
        hasTicks = true,
        resourcePerTick = 0,
        resourcePercent = 0.01
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
        hasCooldown = true
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
        hasCooldown = true
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
        hasCooldown = true
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
        hasCooldown = true
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
        hasCooldown = true
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
        hasCooldown = true
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
        hasCooldown = true
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
        hasCooldown = true
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
        hasCooldown = true
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
    })

    -- Rashok's Molten Heart
    self.moltenRadiance = TRB.Classes.SpellBase:New({
        id = 409898,
    })
    
    return self
end