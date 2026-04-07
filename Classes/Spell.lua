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
---@field public spellsById table<integer, TRB.Classes.SpellBase[]> # Dictionary of list of spells by id.
--@field public fillManaCost boolean # Should the mana cost of spells also be filled when `FillSpellData()` is called?
TRB.Classes.SpellsData = {}
TRB.Classes.SpellsData.__index = TRB.Classes.SpellsData

---Create a new SpellsData
---@return TRB.Classes.SpellsData
function TRB.Classes.SpellsData:New()
	local self = {}
	setmetatable(self, TRB.Classes.SpellsData)
	
	---@type TRB.Classes.SpecializationSpellsBase
	self.spells = TRB.Classes.SpecializationSpellsBase:New()
	self.spellsById = {}

	return self
end

---Fills extra spell data for all spells in the dictionary.
function TRB.Classes.SpellsData:FillSpellData()
	for _, v in pairs(self.spells) do
		---@type TRB.Classes.SpellBase
		local spell = v
		spell:FillSpellData()

		TRB.Functions.Table:AddToDictionaryOfListsById(self.spellsById, spell.id, spell)
		TRB.Functions.Table:AddToDictionaryOfListsById(self.spellsById, spell.buffId, spell)
		TRB.Functions.Table:AddToDictionaryOfListsById(self.spellsById, spell.debuffId, spell)
		TRB.Functions.Table:AddToDictionaryOfListsById(self.spellsById, spell.energizeId, spell)
		TRB.Functions.Table:AddToDictionaryOfListsById(self.spellsById, spell.talentId, spell)
		TRB.Functions.Table:AddToDictionaryOfListsById(self.spellsById, spell.castId, spell)
		TRB.Functions.Table:AddToDictionaryOfListsById(self.spellsById, spell.tickId, spell)
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
---@field public castId integer? # Spell ID of the cast to use the spell.
---@field public tickId integer? # Spell ID of a tick of a HoT/DoT related to the main spell.
---@field public itemId integer? # Item ID related to the spell.
---@field public name string # Name of the spell. Populated automagically from the ID via lookups.
---@field public iconName string? # Manual override of the icon file name to use to populate `icon`.
---@field public icon string # Icon string of the spell. Usually populated automagically from the ID via lookups.
---@field public useSpellIcon boolean? # Use the icon from `spellId` instead of `id`.
---@field public texture string # Icon texture of the spell for uses in place like bar text. Usually populated automagically from the ID via lookups.
---@field public baseline boolean? # Is this spell a baseline ability?
---@field public isTalent boolean? # Is this spell available via a talent? Only used if we need to check if the talent is talented.
---@field public primaryResourceType Enum.PowerType? # Primary resource used in API calls, e.g. Enum.PowerType.Mana
---@field public primaryResourceTypeMod number? # Modifier applied to whatever the returned primary resource amount is, e.g. a second Shadow Word: Madness cast cost
---@field public primaryResourceTypeProperty string? # Which parameter to take from the return of the API call. Defaults to `cost` but can also be `minCost` or `costPerSec`.
---@field public primaryResourceTypePropertyValue number? # Custom override value that an ability will cost. Primarily used for spells that have a max range but the value isn't returned by the API, such as Execute.
---@field public resource number? # How much of the primary resource a spell will generate.
---@field public duration number? # The duration of a buff/debuff. Used by `TRB.Classes.TargetSpell` and others when the duration cannot otherwise be deduced.
---@field public baseDuration number? # The base duration a DoT/HoT lasts.
---@field public pandemic boolean? # Is this spell a DoT/HoT that can be extended to a duration 30% longer than its baseDuration (Pandemic).
---@field public pandemicTime number? # How much time remaining on the DoT/HoT until a refresh will be within Pandemic range. Usually populated automagically based on the `baseDuration` and `pandemic = true`
---@field public hasCooldown boolean? # Does this spell have a cooldown associated with its use?
---@field public hasCharges boolean? # Does this spell have charges?
---@field public hasCastCount boolean? # Does this spell have a cast count that needs to be tracked?
---@field public hasTicks boolean? # Does this spell have a buff/debuff/channel that has ticks?
---@field public ticks integer? # How many ticks this spell have at the beginning.
---@field public tickRate number? # How many seconds between ticks.
---@field public resourcePerTick number? # How many resources are generated per tick.
---@field public maxStacks integer? # Maximum number of stacks for this spell's buff/debuff.
---@field public cooldown number? # How many seconds the cooldown lasts as an unhasted value.
---@field public isHasted boolean? # Does this spell's cooldown, tick rate, etc. benefit from haste?
---@field public isBuff boolean? # Is this spell a buff?
---@field public isFriend boolean? # Is this an effect that happens to friendly targets?
---@field public isSelfInitializeAllowed boolean? # Can this effect be initialized on the player? Almost always false unless we're tracking a friendly buff (like Atonement)
---@field public isPvp boolean? # Is this a PvP only spell?
---@field public rangeCheck boolean? # Should this spell perform range checks?
---@field public customPropertyDefinitions TRB.Classes.BuffCustomProperty[]? # Custom properties that will be tracked by the buff/debuff.
---@field public targetUnit string? # The target that will be used when doing castable and range calculations
---@field public tocMinVersion number? # Minimum TOC version of WoW before attempting to use/load this spell.
---@field public attributes { [string]: any } # Spell specific values that will need to be looked up during gameplay.
---@field protected classTypes trbSpellType[] # List of types that this class implements. Used for checking if a specific class implements some derived class, e.g. SpellThreshold 
---@field private _lastNonZeroPrimaryResourceValue number? # What was the last non-zero primary resource value seen
---@field private _lastPrimaryResourceValueCheck number? # Timestamp of the last time a check was done
---@field private _isFreeCurrently boolean # Is this ability free now when it usually has a resource cost?
---@field private _lastSpellUsableCheck number? # Timestamp of the last time a spell usability check was done
---@field private _isUsable boolean # Is the spell usable currently
---@field private _insufficientPower boolean # Is there insufficient power to cast the spell currently
---@field private _cacheKey string # Key used to cache the primary resource cost of the spell
---@field private _lastCastTimeCheck number? # Timestamp of the last time a cast time check was done
---@field private _lastCastTimeValue number # Current cast time of the spell in seconds
---@field private _baseCastTime number? # Base (first non-zero) cast time seen, used to detect procs
---@field private _isInstantCurrently boolean # Is this ability instant cast currently when it usually has a cast time?
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
		if  (key == "id"								and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "spellId"						  	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "buffId"						   	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "debuffId"						 	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "energizeId"					   	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "talentId"						 	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "castId"						   	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "tickId"						   	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "itemId"						   	and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "iconName") or
			(key == "useSpellIcon"					 	and type(value) == "boolean") or
			(key == "texture") or
			(key == "baseline"						 	and type(value) == "boolean") or
			(key == "isTalent"						 	and type(value) == "boolean") or
			(key == "primaryResourceType") or
			(key == "primaryResourceTypeMod"		   	and type(value) == "number") or
			(key == "primaryResourceTypeProperty") or
			(key == "primaryResourceTypePropertyValue" 	and type(value) == "number") or
			(key == "resource"						 	and type(value) == "number") or
			(key == "duration"						 	and type(value) == "number") or
			(key == "baseDuration"					 	and type(value) == "number") or
			(key == "pandemic"						 	and type(value) == "boolean") or
			(key == "pandemicTime"					 	and type(value) == "number") or
			(key == "hasCooldown"					 	and type(value) == "boolean") or
			(key == "hasCharges"					 	and type(value) == "boolean") or
			(key == "hasCastCount"					 	and type(value) == "boolean") or
			(key == "hasTicks"						 	and type(value) == "boolean") or
			(key == "ticks"								and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "tickRate"							and type(value) == "number") or
			(key == "resourcePerTick"					and type(value) == "number") or
			(key == "cooldown"							and type(value) == "number") or
			(key == "maxStacks" 						and type(value) == "number" and tonumber(value, 10) ~= nil) or
			(key == "isHasted"							and type(value) == "boolean") or
			(key == "isBuff"							and type(value) == "boolean") or
			(key == "isFriend"							and type(value) == "boolean") or
			(key == "isSelfInitializeAllowed"			and type(value) == "boolean") or
			(key == "isPvp"								and type(value) == "boolean") or
			(key == "targetUnit") or
			(key == "rangeCheck"						and type(value) == "boolean") or
			(key == "customPropertyDefinitions"			and type(value) == "table") or
			(key == "tocMinVersion"						and type(value) == "number") then
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

	if self.primaryResourceTypeMod == nil then
		self.primaryResourceTypeMod = 1
	end

	self._lastPrimaryResourceValueCheck = 0
	if self.primaryResourceType ~= nil then
		self._lastNonZeroPrimaryResourceValue = 0
		if self.primaryResourceTypeProperty == nil then
			self.primaryResourceTypeProperty = "cost"
		end
		
		self:GetCacheKey()
	end


	self.name = ""
	self.icon = ""
	self.texture = ""

	self._isFreeCurrently = false
	self._lastCastTimeCheck = 0
	self._lastCastTimeValue = 0
	self._baseCastTime = nil
	self._isInstantCurrently = false

	return self
end

---Gets the effective tick rate of the spell, adjusted for haste if applicable.
---@return number # Tick rate in seconds, haste-adjusted if the spell is hasted
function TRB.Classes.SpellBase:GetTickRate()
	if self.isHasted then
		return self.tickRate * (TRB.Functions.Character:GetCurrentGCDTime(true) / 1.5)
	end
	return self.tickRate
end

---Gets the cache key for the spell. If the _cacheKey is not set, it will be set to the id, primaryResourceTypeProperty, and primaryResourceTypeMod.
---@return string # Cache key
function TRB.Classes.SpellBase:GetCacheKey()
	if self._cacheKey == nil then
		self._cacheKey = self.id .. "_" .. self.primaryResourceTypeProperty .. "_" .. self.primaryResourceTypeMod
	end
	return self._cacheKey
end

---Fills extra spell data from various API calls. Properties to be filled include: `name`, `icon`, and `texture`.
function TRB.Classes.SpellBase:FillSpellData()
	if self.tocMinVersion == nil or TRB.Details.addonData.toc >= self.tocMinVersion then
		if self.itemId ~= nil and self.useSpellIcon ~= true then
			local _, name, icon

			name, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(self.itemId)
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
			local spellInfo
			local icon
			if self.spellId ~= nil and self.useSpellIcon == true then
				spellInfo = C_Spell.GetSpellInfo(self.spellId) --[[@as SpellInfo]]

				if spellInfo == nil then
					spellInfo = C_Spell.GetSpellInfo(self.id)
				end
			else
				spellInfo = C_Spell.GetSpellInfo(self.id) --[[@as SpellInfo]]
			end

			if spellInfo == nil then
				print("MISSING", self.id, self.spellId)
				spellInfo = {
					name = "MISSING"
				}
			end

			if self.iconName ~= nil then
				icon = "Interface\\Icons\\" .. self.iconName
			else
				icon = spellInfo.originalIconID
			end

			if icon == nil then
				icon = "Interface\\Icons\\INV_Misc_QuestionMark"
			end
			self.icon = string.format("|T%s:0|t", icon)
			self.name = spellInfo.name

			if self.settingKey ~= nil then
				self.texture = icon
			end
		end
	end
end

local primaryResourceCostEmbargoTimespan = 0.05

---Gets the current primary resource cost of the spell.
---@param dontReturnLastNonZero boolean? # If true, return 0 if not found instead of the last known value.
---@param indirectCall boolean? # Is this call indirect?
---@return number # Primary resource cost of the spell.
function TRB.Classes.SpellBase:GetPrimaryResourceCost(dontReturnLastNonZero, indirectCall)
	local currentTime = GetTime()
	if self.primaryResourceType ~= nil and self.primaryResourceTypeProperty ~= "custom" then
		if (self._lastPrimaryResourceValueCheck or 0) + primaryResourceCostEmbargoTimespan > currentTime then
			self._lastPrimaryResourceValueCheck = currentTime
			return self._lastNonZeroPrimaryResourceValue
		end

		if indirectCall == true then
            TRB.Classes.SpellBase.GetCacheKey(self)
        else
		    self:GetCacheKey()
        end

		if TRB.Data.cache.values.resource[self._cacheKey] == nil then
			local spc = C_Spell.GetSpellPowerCost(self.id)
			if spc ~= nil then
				for x = 1, #spc do
					if spc[x].type == self.primaryResourceType then
						if spc[x][self.primaryResourceTypeProperty] > 0 then
							local value = spc[x][self.primaryResourceTypeProperty] * self.primaryResourceTypeMod
							self._lastNonZeroPrimaryResourceValue = value
							self._isFreeCurrently = false
							TRB.Data.cache.values.resource[self._cacheKey] = value
							return value
						elseif spc[x][self.primaryResourceTypeProperty] == 0 then
							self._isFreeCurrently = true
							TRB.Data.cache.values.resource[self._cacheKey] = 0
						end
					end
				end
			end
		else
			if TRB.Data.cache.values.resource[self._cacheKey] == 0 then
				self._isFreeCurrently = true
			else
				return TRB.Data.cache.values.resource[self._cacheKey]
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
	self._isFreeCurrently = false
end

---Is this ability free (resource cost = 0) to cast currently? 
---@return boolean
function TRB.Classes.SpellBase:IsFree()
	return self._isFreeCurrently
end

local castTimeEmbargoTimespan = 0.05

---Gets the current cast time of the spell in seconds.
---@return number # Cast time of the spell in seconds (0 = instant).
function TRB.Classes.SpellBase:GetCastTime()
	local currentTime = GetTime()
	if (self._lastCastTimeCheck or 0) + castTimeEmbargoTimespan > currentTime then
		self._lastCastTimeCheck = currentTime
		return self._lastCastTimeValue
	end

	local cacheKey = self.id
	if TRB.Data.cache.values.castTime[cacheKey] == nil then
		local spellInfo = C_Spell.GetSpellInfo(self.id)
		if spellInfo ~= nil and spellInfo.castTime ~= nil then
			local value = spellInfo.castTime / 1000 -- Convert ms to seconds
			self._lastCastTimeValue = value
			TRB.Data.cache.values.castTime[cacheKey] = value

			-- Track the base (first non-zero) cast time to detect procs
			if value > 0 and self._baseCastTime == nil then
				self._baseCastTime = value
			end

			-- Determine if the spell is currently instant when it normally has a cast time
			if self._baseCastTime ~= nil and self._baseCastTime > 0 then
				self._isInstantCurrently = (value == 0)
			else
				self._isInstantCurrently = false
			end

			return value
		end
	else
		local cachedValue = TRB.Data.cache.values.castTime[cacheKey]
		self._lastCastTimeValue = cachedValue

		-- Update instant status based on cached value
		if self._baseCastTime ~= nil and self._baseCastTime > 0 then
			self._isInstantCurrently = (cachedValue == 0)
		else
			self._isInstantCurrently = false
		end

		return cachedValue
	end

	return self._lastCastTimeValue
end

---Gets the base (unmodified) cast time of the spell in seconds.
---This is the first non-zero cast time observed, used as a reference to detect procs.
---@return number? # Base cast time in seconds, or nil if never observed.
function TRB.Classes.SpellBase:GetBaseCastTime()
	return self._baseCastTime
end

---Determines if the spell's cast time has been modified from its base value (e.g., by a proc).
---@return boolean # True if the current cast time differs from the base cast time.
function TRB.Classes.SpellBase:IsCastTimeModified()
	if self._baseCastTime == nil then
		return false
	end
	return self._lastCastTimeValue ~= self._baseCastTime
end

---Is this ability instant cast currently when it normally has a cast time?
---@return boolean
function TRB.Classes.SpellBase:IsInstant()
	return self._isInstantCurrently
end

---Resets the cast time tracking state.
function TRB.Classes.SpellBase:ResetCastTime()
	self._baseCastTime = nil
	self._lastCastTimeValue = 0
	self._isInstantCurrently = false
end

local spellUsableEmbargoTimespan = 0.05

---Gets whether the spell is currently usable.
---@return boolean # Is the spell usable
function TRB.Classes.SpellBase:IsUsable()
	self:UpdateIsSpellUsable()
	return self._isUsable and not self._insufficientPower
end

---Checks whether the spell cannot be cast due to insufficient power (resource).
---@return boolean # True if the player lacks the required resource to cast this spell
function TRB.Classes.SpellBase:InsufficientPower()
	self:UpdateIsSpellUsable()
	return self._insufficientPower
end

---Updates IsSpellUsable cache.
---@param force boolean? # Force the update even if within embargo timespan
function TRB.Classes.SpellBase:UpdateIsSpellUsable(force)
	local currentTime = GetTime()
	if (self._lastSpellUsableCheck or 0) + spellUsableEmbargoTimespan > currentTime then
		self._lastSpellUsableCheck = currentTime
		return self._isUsable
	end

	local isUsable, insufficientPower = C_Spell.IsSpellUsable(self.id)
	--We previously only cared about insufficient power, but since we are not doing a check based on just primary and secondary resources we might as well use the full usability.
	self._isUsable = isUsable
	self._insufficientPower = insufficientPower
	self._lastSpellUsableCheck = currentTime
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

---Updates the cache value for the spell check of if it is in range.
function TRB.Classes.SpellBase:UpdateIsSpellInRange()
	if self.rangeCheck == true then
		TRB.Data.cache.values.range[self.id] = C_Spell.IsSpellInRange(self.id, self.targetUnit or "target")
	end
end

---Determines if the spell is within range to be used
---@return boolean
function TRB.Classes.SpellBase:GetIsSpellInRange()
	if self.rangeCheck ~= true then
		return true
	end
	if TRB.Data.cache.values.range[self.id] == nil then
		self:UpdateIsSpellInRange()
	end

	return TRB.Data.cache.values.range[self.id]
end



---Determines if the threshold spell is in a valid state.
---@param spell TRB.Classes.SpellThreshold|TRB.Classes.SpellComboPointThreshold # Spell to check
---@return boolean # Is this a valid Threshold spell
local function spellThreshold_IsValid(spell)
	if spell ~= nil and spell.id ~= nil and spell.primaryResourceType ~= nil and spell.settingKey ~= nil then
		return true
	end
	return false
end


---@class TRB.Classes.SpellThreshold : TRB.Classes.SpellBase
---@field public settingKey string # Key used for lookups. Typically the same as the name in the `spells` dictionary.
---@field public isSnowflake boolean? # Is this threshold a special snowflake that needs to be handled manually?
---@field public targetUnit string # The target that will be used when doing castable and range calculations
---@field public rangeCheck boolean # Should this threshold perform range checks?
---@field public category string? # Category for grouping in the threshold list UI (e.g., "offensive", "defensive", "utility", "execute")
---@field public barTarget string # Which bar this threshold targets (e.g., "primary", "secondary", "custom:<key>")
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
		if  (key == "settingKey") or
			(key == "isSnowflake"   and type(value) == "boolean") or
			(key == "category") or
			(key == "barTarget") then
			self[key] = value
			self.attributes[key] = nil
		end
	end

	if self.targetUnit == nil then
		self.targetUnit = "target"
	end

	if self.rangeCheck == nil then
		self.rangeCheck = true
	end

	if self.barTarget == nil then
		self.barTarget = "primary"
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
			(key == "comboPoints"			and type(value) == "boolean") then
			self[key] = value
			self.attributes[key] = nil
		end
	end

	return self
end


---@class TRB.Classes.SpellComboPointThreshold : TRB.Classes.SpellComboPoint
---@field public settingKey string # Key used for lookups. Typically the same as the name in the `spells` dictionary.
---@field public isSnowflake boolean? # Is this threshold a special snowflake that needs to be handled manually?
---@field public targetUnit string # The target that will be used when doing castable and range calculations
---@field public rangeCheck boolean # Should this threshold perform range checks?
---@field public category string? # Category for grouping in the threshold list UI (e.g., "offensive", "defensive", "utility", "execute")
---@field public barTarget string # Which bar this threshold targets (e.g., "primary", "secondary", "custom:<key>")
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
		if  (key == "settingKey") or
			(key == "isSnowflake"   and type(value) == "boolean") or
			(key == "category") or
			(key == "barTarget") then
			self[key] = value
			self.attributes[key] = nil
		end
	end

	if self.targetUnit == nil then
		self.targetUnit = "target"
	end

	if self.rangeCheck == nil then
		self.rangeCheck = true
	end

	if self.barTarget == nil then
		self.barTarget = "primary"
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