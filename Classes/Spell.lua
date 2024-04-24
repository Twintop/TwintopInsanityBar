---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

---@class TRB.Classes.SpellsData
---@field public spells TRB.Classes.SpecializationSpellsBase # Dictionary of spells
---@field public fillManaCost boolean # Should the mana cost of spells also be filled when `FillSpellData()` is called?

TRB.Classes.SpellsData = {}
TRB.Classes.SpellsData.__index = TRB.Classes.SpellsData

---Create a new SpellsData
---@param fillManaCost boolean? # Should the mana cost of spells also be filled with `FillSpellData()` is called?
---@return TRB.Classes.SpellsData
function TRB.Classes.SpellsData:New(fillManaCost)
    local self = {}
    setmetatable(self, TRB.Classes.SpellsData)
    
    ---@type TRB.Classes.SpecializationSpellsBase
    self.spells = {}
    self.fillManaCost = fillManaCost or false

    return self
end

---Fills extra spell data for all spells in the dictionary.
function TRB.Classes.SpellsData:FillSpellData()
	for _, v in pairs(self.spells) do
        
        v--[[@as TRB.Classes.SpellBase]]:FillSpellData()
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
---@field public resource number? # How much of the primary resource a spell will generate (positive) or cost (negative).
---@field public resourceMod number? # How much of an offset to the base resource will be applied. Can be a percentage or absolute value. TODO: Split these two values out.
---@field public resourcePercent number? # How much of a percentage of the resource will be used. Implementation dependent on usage.
---@field public duration number? # The duration of a buff/debuff. Used by `TRB.Classes.TargetSpell` and others when the duration cannot otherwise be deduced.
---@field public baseDuration number? # The base duration a DoT/HoT lasts.
---@field public pandemic boolean? # Is this spell a DoT/HoT that can be extended to a duration 30% longer than its baseDuration (Pandemic).
---@field public pandemicTime number? # How much time remaining on the DoT/HoT until a refresh will be within Pandemic range. Usually populated automagically based on the `baseDuration` and `pandemic = true`
---@field public hasCooldown boolean? # Does this spell have a cooldown associated with its use?
---@field public hasCharges boolean? # Does this spell have charges?
---@field public hasTicks boolean? # Does this spell have a buff/debuff/channel that has ticks?
---@field public ticks integer? # How many ticks this spell have at the beginning.
---@field public tickRate number? # How many seconds between ticks.
---@field public resourcePerTicks number? # How many resources are generated per tick.
---@field public isBuff boolean? # Is this spell a buff?
---@field public isPvp boolean? # Is this a PvP only spell?
---@field public tocMinVersion number? # Minimum TOC version of WoW before attempting to use/load this spell.
---@field public attributes { [string]: any } # Spell specific values that will need to be looked up during gameplay.

TRB.Classes.SpellBase = {}
TRB.Classes.SpellBase.__index = TRB.Classes.SpellBase

---Create a new SpellBase
---@param spellAttributes { [string]: any } # Attributes associated with the spell
---@return TRB.Classes.SpellBase
function TRB.Classes.SpellBase:New(spellAttributes)
    local self = {}
    setmetatable(self, TRB.Classes.SpellBase)
    
    ---@type { [string]: any }
    local attributes = {}
    for key, value in pairs(spellAttributes) do
        if  (key == "id"              and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "spellId"         and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "buffId"          and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "debuffId"        and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "energizeId"      and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "talentId"        and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "tickId"          and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "itemId"          and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "iconName") or
            (key == "useSpellIcon"    and type(value) == "boolean") or
            (key == "texture") or
            (key == "baseline"        and type(value) == "boolean") or
            (key == "isTalent"        and type(value) == "boolean") or
            (key == "resource"        and type(value) == "number") or
            (key == "resourceMod"     and type(value) == "number") or
            (key == "resourcePercent" and type(value) == "number") or
            (key == "duration"        and type(value) == "number") or
            (key == "baseDuration"    and type(value) == "number") or
            (key == "pandemic"        and type(value) == "boolean") or
            (key == "pandemicTime"    and type(value) == "number") or
            (key == "hasCooldown"     and type(value) == "boolean") or
            (key == "hasCharges"      and type(value) == "boolean") or
            (key == "hasTicks"        and type(value) == "boolean") or
            (key == "ticks"           and type(value) == "number" and tonumber(value, 10) ~= nil) or
            (key == "tickRate"        and type(value) == "number") or
            (key == "resourcePerTick" and type(value) == "number") or
            (key == "isBuff"          and type(value) == "boolean") or
            (key == "isPvP"           and type(value) == "boolean") or
            (key == "tocMinVersion"   and type(value) == "number") then
            self[key] = value
        elseif key == "name" or key == "icon" then
            print(string.format("TRB: Unexpected property `%s` provided with value `%s`.", key, value))
        elseif key == "attributes" then
            --Do nothing, we'll merge after
        else
            --[[if key ~= "settingKey" and key ~= "thresholdId" and key ~= "mana" and key ~= "resourcePercent" and key ~= "itemIds" and key ~= "isSnowflake" and
               key ~= "holyWordKey" and key ~= "holyWordReduction" and key ~= "holyWordModifier" and key ~= "tickDuration" then
                print(string.format("TRB: Attribute `%s`", key))
            end]]
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

---Gets the current mana cost of the spell.
---@return number # Mana cost of the spell.
function TRB.Classes.SpellBase:GetManaCost()
	local spc = GetSpellPowerCost(self.spellId)
	local length = TRB.Functions.Table:Length(spc)

	for x = 1, length do
		if spc[x]["name"] == "MANA" and spc[x]["cost"] > 0 then
			return spc[x]["cost"]
		end
	end
	return 0
end

---Gets the current mana cost per second of the spell.
---@return number # Mana cost per second of the spell.
function TRB.Classes.SpellBase:GetSpellManaCostPerSecond()
	local spc = GetSpellPowerCost(self.spellId)
	local length = TRB.Functions.Table:Length(spc)

	for x = 1, length do
		if spc[x]["name"] == "MANA" and spc[x]["costPerSec"] > 0 then
			return spc[x]["costPerSec"]
		end
	end
	return 0
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
    local self = setmetatable(spellBase:New(spellAttributes), TRB.Classes.SpellBase)

    
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