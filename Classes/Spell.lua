---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@alias trbSpellType
---| '"TRB.Classes.SpellBase"' # TRB.Classes.SpellBase
---| '"TRB.Classes.SpellComboPoint"' # TRB.Classes.SpellComboPointThreshold
---| '"TRB.Classes.SpellThreshold"' # TRB.Classes.SpellThreshold
---| '"TRB.Classes.SpellComboPointThreshold"' # TRB.Classes.SpellComboPointThreshold
---| '"TRB.Classes.Priest.HolyWordSpell"' # TRB.Classes.Priest.HolyWordSpell
---| '"TRB.Classes.Shaman.OverloadSpell"' # TRB.Classes.Shaman.OverloadSpell

---@class TRB.Classes.SpellsData
---@field public spells TRB.Classes.SpecializationSpellsBase # Dictionary of spells
--@field public fillManaCost boolean # Should the mana cost of spells also be filled when `FillSpellData()` is called?
TRB.Classes.SpellsData = {}
TRB.Classes.SpellsData.__index = TRB.Classes.SpellsData

---Create a new SpellsData
---@return TRB.Classes.SpellsData
function TRB.Classes.SpellsData:New()
    local self = {}
    setmetatable(self, TRB.Classes.SpellsData)
    
    ---@type TRB.Classes.SpecializationSpellsBase
    self.spells = {}

    return self
end

---Fills extra spell data for all spells in the dictionary.
function TRB.Classes.SpellsData:FillSpellData()
	for _, v in pairs(self.spells) do
        ---@type TRB.Classes.SpellBase
        local spell = v
        spell:FillSpellData()
	end
end


---@class TRB.Classes.SpecializationSpellsBase
TRB.Classes.SpecializationSpellsBase = {}
TRB.Classes.SpecializationSpellsBase.__index = TRB.Classes.SpecializationSpellsBase

---Create a new SpecializationSpellsBase
---@return TRB.Classes.SpecializationSpellsBase
function TRB.Classes.SpecializationSpellsBase:New()
    local self = {}
    setmetatable(self, TRB.Classes.SpecializationSpellsBase)
    return self
end


---@class TRB.Classes.SpellBase
---@field public id integer # Primary spell ID of the spell. This can be the spellbook ID, spell associated with the talent ID, the buff/debuff ID, an energize ID, or something else. This is the spell ID that is used, by default, to populate the `name` and `icon` properties.
---@field public spellId integer? # Spell ID differs from the main `id`.
---@field public buffId integer? # Spell ID of a buff that differs from the main `id`.
---@field public debuffId integer? # Spell ID of a debuff that differs from the main `id`.
---@field public energizeId integer? # Spell ID of a `SPELL_ENERGIZE` combat log event.
---@field public talentId integer? # Spell ID of the underlying talent.
---@field public tickId integer? # Spell ID of a tick of a HoT/DoT related to the main spell.
---@field public itemId integer? # Item ID related to the spell.
---@field public name string # Name of the spell. Populated automagically from the ID via lookups
---@field public iconName string? # Manual override of the icon file name to use to populate `icon`.
---@field public icon string # Icon string of the spell. Usually populated automagically from the ID via lookups.
---@field public useSpellIcon boolean? # Use the icon from `spellId` instead of `id`.
---@field public texture string # Icon texture of the spell for uses in place like bar text. Usually populated automagically from the ID via lookups.
---@field public baseline boolean? # Is this spell a baseline ability?
---@field public isTalent boolean? # Is this spell available via a talent? Only used if we need to check if the talent is talented.
---@field public primaryResourceType Enum.PowerType? # Primary resource used in API calls, e.g. Enum.PowerType.Mana
---@field public primaryResourceTypeMod number? # Modifier applied to whatever the returned primary resource amount is, e.g. a second Devouring Plague cast cost
---@field public primaryResourceTypeProperty string? # Which parameter to take from the return of the API call. Defaults to `cost` but can also be `minCost` or `costPerSec`.
---@field public primaryResourceTypePropertyValue number? # Custom override value that an ability will cost. Primarily used for spells that have a max range but the value isn't returned by the API, such as Execute.
---@field public resource number? # How much of the primary resource a spell will generate.
---@field public duration number? # The duration of a buff/debuff. Used by `TRB.Classes.TargetSpell` and others when the duration cannot otherwise be deduced.
---@field public baseDuration number? # The base duration a DoT/HoT lasts.
---@field public pandemic boolean? # Is this spell a DoT/HoT that can be extended to a duration 30% longer than its baseDuration (Pandemic).
---@field public pandemicTime number? # How much time remaining on the DoT/HoT until a refresh will be within Pandemic range. Usually populated automagically based on the `baseDuration` and `pandemic = true`
---@field public hasCooldown boolean? # Does this spell have a cooldown associated with its use?
---@field public hasCharges boolean? # Does this spell have charges?
---@field public hasTicks boolean? # Does this spell have a buff/debuff/channel that has ticks?
---@field public ticks integer? # How many ticks this spell have at the beginning.
---@field public tickRate number? # How many seconds between ticks.
---@field public resourcePerTick number? # How many resources are generated per tick.
---@field public isBuff boolean? # Is this spell a buff?
---@field public isPvp boolean? # Is this a PvP only spell?
---@field public tocMinVersion number? # Minimum TOC version of WoW before attempting to use/load this spell.
---@field public attributes { [string]: any } # Spell specific values that will need to be looked up during gameplay.
---@field protected classTypes trbSpellType[] # List of types that this class implements. Used for checking if a specific class implements some derived class, e.g. SpellThreshold 
---@field private _lastNonZeroPrimaryResourceValue number? # What was the last non-zero primary resource value seen
---@field private _lastPrimaryResourceValueCheck number? # Timestamp of the last time a check was done
TRB.Classes.SpellBase = {}
TRB.Classes.SpellBase.__index = TRB.Classes.SpellBase

---Create a new SpellBase
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.SpellBase
function TRB.Classes.SpellBase:New(spellAttributes)
    ---@diagnostic disable-next-line: missing-fields
    local self = {} --[[@as TRB.Classes.SpellBase]]
    setmetatable(self, TRB.Classes.SpellBase)
    
    self.classTypes = {
        "TRB.Classes.SpellBase"
    }

    ---@type { [string]: any }
    local attributes = {}
    for key, value in pairs(spellAttributes) do
        if  (key == "id"                               and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "spellId"                          and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "buffId"                           and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "debuffId"                         and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "energizeId"                       and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "talentId"                         and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "tickId"                           and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "itemId"                           and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "iconName") or
            (key == "useSpellIcon"                     and type(value) == "boolean") or
            (key == "texture") or
            (key == "baseline"                         and type(value) == "boolean") or
            (key == "isTalent"                         and type(value) == "boolean") or
            (key == "primaryResourceType") or
            (key == "primaryResourceTypeMod"           and type(value) == "number") or
            (key == "primaryResourceTypeProperty") or
            (key == "primaryResourceTypePropertyValue" and type(value) == "number") or
            (key == "resource"                         and type(value) == "number") or
            (key == "duration"                         and type(value) == "number") or
            (key == "baseDuration"                     and type(value) == "number") or
            (key == "pandemic"                         and type(value) == "boolean") or
            (key == "pandemicTime"                     and type(value) == "number") or
            (key == "hasCooldown"                      and type(value) == "boolean") or
            (key == "hasCharges"                       and type(value) == "boolean") or
            (key == "hasTicks"                         and type(value) == "boolean") or
            (key == "ticks"                            and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "tickRate"                         and type(value) == "number") or
            (key == "resourcePerTick"                  and type(value) == "number") or
            (key == "isBuff"                           and type(value) == "boolean") or
            (key == "isPvP"                            and type(value) == "boolean") or
            (key == "tocMinVersion"                    and type(value) == "number") then
            self[key] = value
        elseif key == "name" or key == "icon" then
            print(string.format("TRB: Unexpected property `%s` provided with value `%s`.", key, value))
        elseif key == "attributes" then
            --Do nothing, we'll merge after
        else
            attributes[key] = value
        end
    end

    if spellAttributes["attributes"] ~= nil then
        TRB.Functions.Table:Merge(attributes, spellAttributes["attributes"])
    end

    self.attributes = attributes

    if self.pandemic and self.baseDuration ~= nil and type(self.baseDuration) == "number" and self.baseDuration > 0 and self.pandemicTime == nil then
        self.pandemicTime = self.baseDuration * 0.3
    end

    if self.primaryResourceType ~= nil then
        self._lastNonZeroPrimaryResourceValue = 0
        self._lastPrimaryResourceValueCheck = 0
        if self.primaryResourceTypeProperty == nil then
            self.primaryResourceTypeProperty = "cost"
        end
        if self.primaryResourceTypeMod == nil then
            self.primaryResourceTypeMod = 1
        end
    end


    self.name = ""
    self.icon = ""
    self.texture = ""

    return self
end

---Fills extra spell data from various API calls. Properties to be filled include: `name`, `icon`, and `texture`.
function TRB.Classes.SpellBase:FillSpellData()
    if self.tocMinVersion == nil or TRB.Details.addonData.toc >= self.tocMinVersion then
        if self.itemId ~= nil and self.useSpellIcon ~= true then
            local _, name, icon
            name, _, _, _, _, _, _, _, _, icon = GetItemInfo(self.itemId)
            if name ~= nil then
                self.name = name
            end

            if self.iconName ~= nil then
                icon = "Interface\\Icons\\" .. self.iconName
            end
            
            if icon ~= nil then
                self.icon = string.format("|T%s:0|t", icon)
                self.texture = icon
            end
        elseif self.id ~= nil or (self.spellId ~= nil and self.useSpellIcon == true) then
            local _, name, icon
            if self.spellId ~= nil and self.useSpellIcon == true then
                name, _, icon = GetSpellInfo(self.spellId)
            else
                name, _, icon = GetSpellInfo(self.id)
            end
            
            if self.iconName ~= nil then
                icon = "Interface\\Icons\\" .. self.iconName
            end

            self.icon = string.format("|T%s:0|t", icon)
            self.name = name

            if self.thresholdId ~= nil then
                self.texture = icon
            end
        end
    end
end

local primaryResourceCostEmbargoTimespan = 0.05

---Gets the current primary resource cost of the spell.
---@param dontReturnLastNonZero boolean? # If true, return 0 if not found instead of the last known value instead.
---@return number # Primary resource cost of the spell.
function TRB.Classes.SpellBase:GetPrimaryResourceCost(dontReturnLastNonZero)
    local currentTime = GetTime()
    if self.primaryResourceType ~= nil and self.primaryResourceTypeProperty ~= "custom" then
        if self._lastPrimaryResourceValueCheck + primaryResourceCostEmbargoTimespan > currentTime then
            self._lastPrimaryResourceValueCheck = currentTime
            return self._lastNonZeroPrimaryResourceValue
        end
        local spc = GetSpellPowerCost(self.id)
        if spc ~= nil then
            for x = 1, #spc do
                if spc[x].type == self.primaryResourceType and spc[x][self.primaryResourceTypeProperty] > 0 then
                    local value = spc[x][self.primaryResourceTypeProperty] * self.primaryResourceTypeMod
                    self._lastNonZeroPrimaryResourceValue = value
                    return value
                end
            end
        end
    elseif self.primaryResourceTypeProperty == "custom" then
        return self.primaryResourceTypePropertyValue
    end

    if dontReturnLastNonZero == true then
        return 0
    end

	return self._lastNonZeroPrimaryResourceValue
end

---Resets the last non-zero resource value to 0.
function TRB.Classes.SpellBase:ResetPrimaryResourceCost()
    self._lastNonZeroPrimaryResourceValue = 0
end

---Determines if the current SpellBase is also another type, such as SpellThreshold.
---@param spellType trbSpellType # Spell Class type we're checking
---@return boolean # Is it of this type
function TRB.Classes.SpellBase:Is(spellType)
    for _, value in ipairs(self.classTypes) do
        if spellType == value then
            return true
        end
    end
    return false
end

---Determines if the spell is in a valid state. Mostly used by inherited classes to add extra checking.
---@return boolean
function TRB.Classes.SpellBase:IsValid()
    return true
end



---Determines if the threshold spell is in a valid state.
---@param spell TRB.Classes.SpellThreshold|TRB.Classes.SpellComboPointThreshold # Spell to check
---@return boolean # Is this a valid Threshold spell
local function spellThreshold_IsValid(spell)
    if spell ~= nil and spell.id ~= nil and spell.primaryResourceType ~= nil and spell.thresholdId ~= nil and spell.settingKey ~= nil then
        return true
    end
    return false
end


---@class TRB.Classes.SpellThreshold : TRB.Classes.SpellBase
---@field public thresholdId integer # Index of the threshold to be controlled
---@field public settingKey string # Key used for lookups. Typically the same as the name in the `spells` dictionary.
---@field public isSnowflake boolean? # Is this threshold a special snowflake that needs to be handled manually?
TRB.Classes.SpellThreshold = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.SpellThreshold.__index = TRB.Classes.SpellThreshold

---Creates a new SpellThreshold object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.SpellThreshold
function TRB.Classes.SpellThreshold:New(spellAttributes)
    ---@type TRB.Classes.SpellBase
    local spellBase = TRB.Classes.SpellBase
    ---@type TRB.Classes.SpellThreshold
    ---@diagnostic disable-next-line: assign-type-mismatch
    local self = setmetatable(spellBase:New(spellAttributes), {__index = TRB.Classes.SpellThreshold})
    self.isSnowflake = false

    table.insert(self.classTypes, "TRB.Classes.SpellThreshold")
    
    for key, value in pairs(spellAttributes) do
        if  (key == "thresholdId"   and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "settingKey") or
            (key == "isSnowflake"   and type(value) == "boolean") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end

---Determines if the spell is in a valid state. Mostly used by inherited classes to add extra checking.
---@return boolean # Is this valid
function TRB.Classes.SpellThreshold:IsValid()
    local base = TRB.Classes.SpellBase
    if spellThreshold_IsValid(self) then
        return base.IsValid(self)
    end
    return false
end


---@class TRB.Classes.SpellComboPoint : TRB.Classes.SpellBase
---@field public comboPoints boolean # Does this ability require Combo Points to be used
---@field public comboPointsGenerated integer # Number of Combo Points generated when the ability is used
---@field public settingKey string # Key used for lookups. Typically the same as the name in the `spells` dictionary.
---@field public isSnowflake boolean? # Is this threshold a special snowflake that needs to be handled manually?
TRB.Classes.SpellComboPoint = setmetatable({}, {__index = TRB.Classes.SpellBase})
TRB.Classes.SpellComboPoint.__index = TRB.Classes.SpellComboPoint

---Creates a new SpellComboPoint object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.SpellComboPoint
function TRB.Classes.SpellComboPoint:New(spellAttributes)
    ---@type TRB.Classes.SpellBase
    local spellBase = TRB.Classes.SpellBase
    ---@type TRB.Classes.SpellComboPoint
    ---@diagnostic disable-next-line: assign-type-mismatch
    local self = setmetatable(spellBase:New(spellAttributes), {__index = TRB.Classes.SpellComboPoint})
    
    self.comboPoints = false
    self.comboPointsGenerated = 0

    table.insert(self.classTypes, "TRB.Classes.SpellComboPoint")
    
    for key, value in pairs(spellAttributes) do
        if  (key == "comboPointsGenerated"   and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "comboPoints"            and type(value) == "boolean") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end


---@class TRB.Classes.SpellComboPointThreshold : TRB.Classes.SpellComboPoint
---@field public thresholdId integer # Index of the threshold to be controlled
---@field public settingKey string # Key used for lookups. Typically the same as the name in the `spells` dictionary.
---@field public isSnowflake boolean? # Is this threshold a special snowflake that needs to be handled manually?
TRB.Classes.SpellComboPointThreshold = setmetatable({}, {__index = TRB.Classes.SpellComboPoint})
TRB.Classes.SpellComboPointThreshold.__index = TRB.Classes.SpellComboPointThreshold


---Creates a new SpellComboPointThreshold object
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.SpellComboPointThreshold
function TRB.Classes.SpellComboPointThreshold:New(spellAttributes)
    ---@type TRB.Classes.SpellComboPoint
    local base = TRB.Classes.SpellComboPoint
    ---@type TRB.Classes.SpellComboPointThreshold
    ---@diagnostic disable-next-line: assign-type-mismatch
    local self = setmetatable(base:New(spellAttributes), {__index = TRB.Classes.SpellComboPointThreshold})
    self.isSnowflake = false

    table.insert(self.classTypes, "TRB.Classes.SpellComboPointThreshold")
    
    for key, value in pairs(spellAttributes) do
        if  (key == "thresholdId"   and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "settingKey") or
            (key == "isSnowflake"   and type(value) == "boolean") then
            self[key] = value
            self.attributes[key] = nil
        end
    end

    return self
end

---Determines if the spell is in a valid state. Mostly used by inherited classes to add extra checking.
---@return boolean # Is this valid
function TRB.Classes.SpellComboPointThreshold:IsValid()
    local base = TRB.Classes.SpellComboPoint
    if spellThreshold_IsValid(self) then
        return base.IsValid(self)
    end
    return false
end