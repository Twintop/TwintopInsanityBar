---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}


---@class TRB.Classes.SnapshotData
---@field public targetData TRB.Classes.TargetData
---@field public auraInstanceIds table<integer, TRB.Classes.SnapshotBuff>
---@field public snapshots table<integer, TRB.Classes.Snapshot>
---@field public casting TRB.Classes.SnapshotCasting
---@field public audio table
---@field public attributes table
---@field public formatted table<string, string|number|boolean> Pre-formatted display strings, populated at event time
TRB.Classes.SnapshotData = {}
TRB.Classes.SnapshotData.__index = TRB.Classes.SnapshotData

---Creates a new SnapshotData object
---@param attributes table? # Custom attributes to be tracked
---@return TRB.Classes.SnapshotData
function TRB.Classes.SnapshotData:New(attributes)
	local self = {}
	setmetatable(self, TRB.Classes.SnapshotData)
	---@type TRB.Classes.TargetData
	self.targetData = TRB.Classes.TargetData:New()
	---@type table<integer, TRB.Classes.Snapshot>
	self.snapshots = {}
	self.auraInstanceIds = {}
	self.casting = TRB.Classes.SnapshotCasting:New()
	self.audio = {}
	self.attributes = attributes or {}
	self.attributes.resource = self.attributes.resource or 0
	---Pre-formatted display strings, populated at event time so the render tick
	---can copy them into lookup[] without redoing expensive string.format / number
	---abbreviation work.  Keys mirror the lookup variable names minus the "$" prefix.
	---@type table<string, string|number|boolean>
	self.formatted = {}

	return self
end

---Refreshes all buffs. Usually required upon login or from a specialization/talent change.
function TRB.Classes.SnapshotData:RefreshAllBuffs()
	for _, v in pairs(self.snapshots) do
		v.buff:Refresh()
	end
end

---Recalculates all hasted cooldowns when haste changes
---@param newHaste number # The new haste percentage
function TRB.Classes.SnapshotData:RecalculateHastedCooldowns(newHaste)
	for _, v in pairs(self.snapshots) do
		v.cooldown:RecalculateForHaste(newHaste)
	end
end

---@class TRB.Classes.Snapshot
---@field public spell TRB.Classes.SpellBase?
---@field public buff TRB.Classes.SnapshotBuff
---@field public cooldown TRB.Classes.SnapshotCooldown
---@field public stacks integer
---@field public attributes table
TRB.Classes.Snapshot = {}
TRB.Classes.Snapshot.__index = TRB.Classes.Snapshot

---Creates a new Snapshot object
---@param spell TRB.Classes.SpellBase # Spell we are snapshotting
---@param attributes table? # Custom attributes to be tracked
---@param simpleBuff trbBuffSimpleMode? # Should the buff tracking always run in simple mode?
---@param onlyRefreshOnRequest boolean? # Should the buff refresh only occur when explictly requested?
---@return TRB.Classes.Snapshot
function TRB.Classes.Snapshot:New(spell, attributes, simpleBuff, onlyRefreshOnRequest)
	local self = {}
	setmetatable(self, TRB.Classes.Snapshot)
	self.spell = spell
	self.buff = TRB.Classes.SnapshotBuff:New(self, simpleBuff, onlyRefreshOnRequest)
	self.cooldown = TRB.Classes.SnapshotCooldown:New(self)
	self:Reset()
	self.attributes = attributes or {}
	return self
end

---Resets snapshot values to default
function TRB.Classes.Snapshot:Reset()
	---@type TRB.Classes.SnapshotBuff
	self.buff:Reset()
	---@type TRB.Classes.SnapshotCooldown
	self.cooldown:Reset()
end


---@class TRB.Classes.SnapshotBuff
---@field public auraInstanceId integer?
---@field public isActive boolean
---@field public endTime number?
---@field public duration number
---@field public remaining number
---@field public endTimeLeeway number
---@field public applications integer
---@field public customPropertyDefinitions TRB.Classes.BuffCustomProperty[]
---@field public customProperties table
---@field public alwaysSimple boolean?
---@field public currentlySimple boolean? # Is the buff currently running in simple mode?
---@field public sometimesSimple boolean? # Should the buff tracking run in simple mode sometimes? Example: Sustained Potency + Voidform + stun
---@field public hasTicks boolean
---@field public resourcePerTick number
---@field private tickRate number
---@field public ticks number
---@field public resource number
---@field public isCustom boolean
---@field public updateFromSecret boolean
---@field public parent TRB.Classes.Snapshot
---@field private refreshRequested boolean
---@field private refreshEmbargo number?
---@field private onlyRefreshOnRequest boolean
---@field private lastRefreshGetTime number
---@field public previousRemaining number
---@field public attributes table
---@field public pauseMaxDuration number? # Maximum allowed pause duration, nil if not pausable
---@field public pauseElapsedTime number # Cumulative time spent paused
---@field public pauseStartTime number? # When the current pause began, nil if not paused
---@field public isPaused boolean # Whether the buff is currently paused
TRB.Classes.SnapshotBuff = {}
TRB.Classes.SnapshotBuff.__index = TRB.Classes.SnapshotBuff

---Creates a new Snapshot object
---@param parent TRB.Classes.Snapshot
---@param simpleBuff trbBuffSimpleMode? # Should the buff tracking always run in simple mode?
---@param onlyRefreshOnRequest boolean? # Should the buff refresh only occur when explictly requested?
---@return TRB.Classes.SnapshotBuff
function TRB.Classes.SnapshotBuff:New(parent, simpleBuff, onlyRefreshOnRequest)
	local self = {}
	setmetatable(self, TRB.Classes.SnapshotBuff)

	if simpleBuff == "always" then
		self.sometimesSimple = false
        self.alwaysSimple = true
		self.currentlySimple = true
	elseif simpleBuff == "sometimes" then
		self.sometimesSimple = true
		self.alwaysSimple = false
		self.currentlySimple = false
	else
        self.sometimesSimple = false
		self.alwaysSimple = false
		self.currentlySimple = false
	end

	if onlyRefreshOnRequest ~= nil then
		self.onlyRefreshOnRequest = onlyRefreshOnRequest
	else
		self.onlyRefreshOnRequest = false
	end

	self.parent = parent

	if self.parent.spell.hasTicks then
		self.hasTicks = true
		self.resourcePerTick = self.parent.spell.resourcePerTick
		self.tickRate = self.parent.spell.tickRate
	end

	if self.parent.spell.customPropertyDefinitions ~= nil then
		self.customPropertyDefinitions = self.parent.spell.customPropertyDefinitions
	else
		self.customPropertyDefinitions = {}
	end
	
	self.customProperties = {}
	self.attributes = {}
	self:Reset()


	return self
end

---Sets the list of custom properties to be parsed out of a UnitAura() call when SnapshotBuff:Refresh() is called
---@param customProperties TRB.Classes.BuffCustomProperty[]
function TRB.Classes.SnapshotBuff:SetCustomProperties(customProperties)
	self.customPropertyDefinitions = customProperties
	self:Reset()
end

---Resets the object to default values
---@param includeAttributes boolean? # If true or nil, also resets custom attributes
---@param force boolean? # If true, reset even if currently paused
function TRB.Classes.SnapshotBuff:Reset(includeAttributes, force)
	-- Don't reset if we're actively paused with budget remaining (unless forced)
	-- This prevents the game's UNIT_AURA removal events from clearing a paused buff
	if not force and self.isPaused and self.pauseMaxDuration ~= nil then
		local currentPauseElapsed = GetTime() - (self.pauseStartTime or GetTime())
		if self.pauseElapsedTime + currentPauseElapsed < self.pauseMaxDuration then
			return
		end
	end

	if includeAttributes == nil then
		includeAttributes = true
	end
	if self.auraInstanceId ~= nil then
		TRB.Functions.Aura:RemoveBuffAuraInstanceId(self.auraInstanceId)
	end
	self.auraInstanceId = nil
	self.isActive = false
	self.endTime = nil
	self.duration = 0
	self.remaining = 0
	self.endTimeLeeway = 0
	self.applications = 0
	self.ticks = 0
	self.resource = 0
	self.isCustom = false
	self.updateFromSecret = false
	self.refreshRequested = false
	self.lastRefreshGetTime = 0
	self.previousRemaining = 0
	self.pauseMaxDuration = nil
	self.pauseElapsedTime = 0
	self.pauseStartTime = nil
	self.isPaused = false

	if includeAttributes then
		wipe(self.attributes)
	end

	if self.customPropertyDefinitions ~= nil then
		for _, prop in ipairs(self.customPropertyDefinitions) do
			if prop.dataType == "number" then
				self.customProperties[prop.name] = 0
			elseif prop.dataType == "integer" then
				self.customProperties[prop.name] = 0
			end
		end
	end
end

---Configures tick-based resource generation data for a periodic buff
---@param hasTicks boolean # Does this spell have ticks?
---@param resourcePerTick number # Amount of a given resource generated per tick
---@param tickRate number # How frequently, in seconds, a tick occurs.
function TRB.Classes.SnapshotBuff:SetTickData(hasTicks, resourcePerTick, tickRate)
	self.hasTicks = hasTicks
	self.resourcePerTick = resourcePerTick
	self.tickRate = tickRate
end

---Sets the maximum pause duration for this buff. Resets pauseElapsedTime when called.
---@param maxDuration number? # Maximum pause duration in seconds. Set to nil to disable pause functionality.
function TRB.Classes.SnapshotBuff:SetPauseMaxDuration(maxDuration)
	self.pauseMaxDuration = maxDuration
	self.pauseElapsedTime = 0
	self.pauseStartTime = nil
	self.isPaused = false
end

---Enters pause mode, freezing the remaining time at the current value.
---Does nothing if already paused, pauseMaxDuration is nil, or the buff is not active.
function TRB.Classes.SnapshotBuff:EnterPauseMode()
	-- Don't enter pause mode if already paused, not pausable, or buff is inactive
	if self.isPaused or self.pauseMaxDuration == nil or not self.isActive then
		return
	end

	-- Check if we've already exhausted the pause budget
	if self.pauseElapsedTime >= self.pauseMaxDuration then
		return
	end

	-- Snapshot the current remaining time before entering pause mode
	self:GetRemainingTime()
	self.previousRemaining = self.remaining

	-- Enter pause mode
	self.pauseStartTime = GetTime()
	self.isPaused = true
	self.currentlySimple = true
end

---Exits pause mode, resuming normal time tracking.
---Does nothing if not currently paused.
function TRB.Classes.SnapshotBuff:ExitPauseMode()
	if not self.isPaused then
		return
	end

	-- Calculate elapsed pause time
	local currentTime = GetTime()
	local pauseElapsed = currentTime - (self.pauseStartTime or currentTime)

	-- Add to cumulative pause time, capped at max duration
	self.pauseElapsedTime = math.min(self.pauseElapsedTime + pauseElapsed, self.pauseMaxDuration or 0)

	-- Extend the endTime by the pause duration to account for the frozen time
	if self.endTime ~= nil then
		self.endTime = self.endTime + pauseElapsed
	end

	-- Exit pause mode
	self.pauseStartTime = nil
	self.isPaused = false
	self.currentlySimple = false

	-- Resume normal time tracking
	self:GetRemainingTime()
end

---Gets the remaining pause budget (time that can still be paused).
---@return number # Remaining pause time in seconds, or 0 if not pausable
function TRB.Classes.SnapshotBuff:GetPauseTimeRemaining()
	if self.pauseMaxDuration == nil then
		return 0
	end

	local currentPauseElapsed = 0
	if self.isPaused and self.pauseStartTime then
		currentPauseElapsed = GetTime() - self.pauseStartTime
	end

	return math.max(0, self.pauseMaxDuration - self.pauseElapsedTime - currentPauseElapsed)
end

---Computes the time remaining on the Snapshot and also refreshes data related to ticks if the spell supports it
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
---@param useLeeway boolean? # If true, use the included leeway value for offsetting the remainingTime slightly.
---@param force boolean? # If true, forces a recalculation even if called multiple times in the same timestamp.
---@return number # Duration remaining on the Snapshot
function TRB.Classes.SnapshotBuff:GetRemainingTime(currentTime, useLeeway, force)
	currentTime = currentTime or GetTime()

	-- Handle pause mode with max duration tracking
	if self.isPaused and self.pauseMaxDuration ~= nil then
		local currentPauseElapsed = currentTime - (self.pauseStartTime or currentTime)
		local totalPauseTime = self.pauseElapsedTime + currentPauseElapsed

		-- Check if pause budget is exhausted
		if totalPauseTime >= self.pauseMaxDuration then
			-- Finalize the pause elapsed time at max and exit pause mode
			-- Extend endTime by the max pause duration before resuming normal tracking
			if self.endTime ~= nil then
				self.endTime = self.endTime + self.pauseMaxDuration
			end
			self.pauseElapsedTime = self.pauseMaxDuration
			self.pauseStartTime = nil
			self.isPaused = false
			self.currentlySimple = false
			-- Continue to normal time calculation below
		else
			-- Still within pause budget, return frozen time
			-- Maintain isActive and remaining so other code sees consistent state
			self.isActive = true
			self.remaining = self.previousRemaining
			self.lastRefreshGetTime = currentTime
			return self.previousRemaining
		end
	elseif self.currentlySimple then
		self.lastRefreshGetTime = currentTime
		return self.previousRemaining
	end

    if not force and self.lastRefreshGetTime == currentTime then
        return self.remaining
	end

	if useLeeway == nil then
		useLeeway = false
	end

	local remainingTime = 0
	local endTime = self.endTime
	
	if useLeeway and self.endTimeLeeway ~= nil then
		endTime = self.endTimeLeeway
	end

	if endTime ~= nil and endTime > currentTime then
		remainingTime = endTime - currentTime
	end

	if remainingTime <= 0 then
		self.isActive = false
		remainingTime = 0
	else
		self.isActive = true
	end

	if not self.isActive then
		self:Reset()
	end

	self.remaining = remainingTime
	self.lastRefreshGetTime = currentTime
	return remainingTime
end

---Updates the number of ticks remaining on a buff
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
function TRB.Classes.SnapshotBuff:UpdateTicks(currentTime)
	if self.hasTicks then
		currentTime = currentTime or GetTime()
		self:GetRemainingTime(currentTime)
		self.ticks = math.ceil(self.remaining / self.tickRate)
		self.resource = self.ticks * self.resourcePerTick
	end
end

---Initializes the buff information for the snapshot
---@param eventType trbAuraEventType? # Event type sourced from the combat log event. If not provided, will do a generic buff update
---@param simple? boolean # Just updates isActive. If not provided, defaults to `false`
---@param unit? UnitId # Unit we want to check to update. If not provided, defaults to `player`
function TRB.Classes.SnapshotBuff:Initialize(eventType, simple, unit)
	unit = unit or "player"
	if simple == nil then
		simple = false
	end
	if self.onlyRefreshOnRequest then
		self.refreshRequested = true
	end
	self:Refresh(eventType, simple, unit)
end

---Initializes the buff with custom endTime and duration values
---@param duration number # How long the buff will last
---@param startTime number? # When did this buff begin. Defaults to GetTime()
---@param hasStacks boolean? # Should the buff be marked as having stacks
---@param stacks integer? # Number of stacks to set when initializing
---@param updateFromSecret boolean? # Should the buff be flagged to update from secret AuraData on refresh
function TRB.Classes.SnapshotBuff:InitializeCustom(duration, startTime, hasStacks, stacks, updateFromSecret)
	local startTime = startTime or GetTime()
	self.duration = duration
	self.endTime = startTime + duration
	self.isCustom = true
	self.updateFromSecret = updateFromSecret or false
	if hasStacks then
		self.applications = stacks or 1
	else
		self.applications = 0
	end
	self:GetRemainingTime(nil, nil, true)
end

---Initializes the buff with custom endTime and duration values
---@param hasStacks boolean? # Should the buff be marked as having stacks
function TRB.Classes.SnapshotBuff:InitializeCustomSimple(hasStacks)
	self.isCustom = true
	self.isActive = true
	if hasStacks then
		self.applications = 1
	else
		self.applications = 0
	end
end

---Adds time to a currently active buff or initializes it if not active
---@param duration number # How much time to add
---@param startTime number? # When did this buff begin. Defaults to GetTime()
function TRB.Classes.SnapshotBuff:AddTimeOrInitializeCustom(duration, startTime)
	local startTime = startTime or GetTime()
	self:GetRemainingTime()
	if not self.isActive then
		self:InitializeCustom(duration, startTime)
	else
		self.duration = self.remaining + duration
		self.endTime = startTime + self.duration
		self:GetRemainingTime(nil, nil, true)
	end
end

---Adds stacks to a currently active buff or initializes it if not active
---@param duration number # How long the buff will last
---@param startTime number? # When did this buff begin. Defaults to GetTime()
---@param refreshTime boolean? # Should the endTime be refreshed to now + duration
---@param stacks integer? # Number of stacks to add when initializing
function TRB.Classes.SnapshotBuff:AddStackOrInitializeCustom(duration, startTime, refreshTime, stacks)
	if refreshTime == nil then
		refreshTime = false
	end
	if not self.isActive then
		self:InitializeCustom(duration, startTime, true, stacks)
	else
		self:AddStack(refreshTime, stacks)
	end
end

---Adds a new stack (application) to the buff
---@param refreshTime boolean? # Should the endTime be refreshed to now + duration
---@param stacks integer? # Number of stacks to add
function TRB.Classes.SnapshotBuff:AddStack(refreshTime, stacks)
	if refreshTime == nil then
		refreshTime = false
	end
	if self.isActive and (self.parent.spell.maxStacks == nil or self.applications < self.parent.spell.maxStacks) then
		self.applications = self.applications + (stacks or 1)
		if refreshTime then
			self.endTime = GetTime() + self.duration
			self:GetRemainingTime()
		end
	end
end

---Removes a stack (application) from the buff
---@param resetAttributes boolean? # If true or nil, resets custom attributes when the buff is fully removed
function TRB.Classes.SnapshotBuff:RemoveStack(resetAttributes)
	if self.isActive then
		if self.applications == 1 then
			self:Reset(resetAttributes)
			return
		end
		self.applications = self.applications - 1
	end
end

---Sets the auraInstanceId value for this buff.
---@param auraInstanceId integer
function TRB.Classes.SnapshotBuff:SetAuraInstanceId(auraInstanceId)
	self.auraInstanceId = auraInstanceId
	TRB.Functions.Aura:StoreBuffAuraInstanceId(self)
end

---Parse the aura.points[] into customProperty[] values.
---@param buff TRB.Classes.SnapshotBuff # The snapshot buff we are updating
---@param aura AuraData # Data about the buff
local function GetCustomProperties(buff, aura)
	if buff.customPropertyDefinitions ~= nil and not issecrettable(aura.points) then
		for _, prop in ipairs(buff.customPropertyDefinitions) do
			buff.customProperties[prop.name] = aura.points[prop.index]
			if buff.customProperties[prop.name] ~= nil then
				if issecretvalue(buff.customProperties[prop.name]) then
					-- Do nothing, store it as-is
				elseif prop.dataType == "number" then
					buff.customProperties[prop.name] = tonumber(buff.customProperties[prop.name] * prop.modifier)
				elseif prop.dataType == "integer" then
					buff.customProperties[prop.name] = math.floor(tonumber(buff.customProperties[prop.name] * prop.modifier))
				end
			else
				if prop.dataType == "number" then
					buff.customProperties[prop.name] = 0
				elseif prop.dataType == "integer" then
					buff.customProperties[prop.name] = 0
				end
			end
		end
	end
end


---Parse the buff
---@param buff TRB.Classes.SnapshotBuff # The snapshot buff we are updating
---@param aura AuraData # Data about the buff
---@return integer? # The SpellID of the buff, if found
local function ParseBuffData(buff, aura)
	if aura ~= nil then
        if (buff.sometimesSimple or buff.alwaysSimple) and (aura.expirationTime <= 0 or aura.duration <= 0) then
            -- Make sure we have the most up-to-date remaining time before we set the buff to simple mode
            buff:GetRemainingTime()
            buff.currentlySimple = true
        else
            buff.currentlySimple = false
        end
        buff.previousRemaining = buff.remaining

        buff.auraInstanceId = aura.auraInstanceID
		buff.applications = aura.applications
		buff.duration = aura.duration
		buff.endTime = aura.expirationTime

		GetCustomProperties(buff, aura)

		TRB.Functions.Aura:StoreBuffAuraInstanceId(buff)
		return aura.spellId
	else
		buff:Reset()
	end
end

---Requests a refresh of the buff after the embargo has passed, if specified
---@param embargo number? # Timestamp to embargo the refresh until
function TRB.Classes.SnapshotBuff:RequestRefresh(embargo)
	self.refreshRequested = true
	self.refreshEmbargo = embargo
end

---Refreshes the buff snapshot with already captured AuraData
---@param auraData AuraData
function TRB.Classes.SnapshotBuff:RefreshWithAuraData(auraData)
	if self.isCustom then
		return
	end

	ParseBuffData(self, auraData)

	if self.currentlySimple then
		self.isActive = true
	else
		local currentTime = GetTime()
		if self.endTime ~= nil and self.endTime > currentTime then
			self.isActive = true
			self:GetRemainingTime()
		else
			self:Reset()
		end
	end
end

---Refreshes the buff snapshot with already captured *secret* AuraData
---@param auraData AuraData
function TRB.Classes.SnapshotBuff:RefreshWithSecretAuraData(auraData)
	GetCustomProperties(self, auraData)
end

---Refreshes the buff information for the snapshot
---@param eventType trbAuraEventType? # Event type sourced from the combat log event. If not provided, will do a generic buff update
---@param simple boolean? # Just updates isActive. If not provided, defaults to `false`
---@param unit UnitId? # Unit we want to check to update. If not provided, defaults to `player`
function TRB.Classes.SnapshotBuff:Refresh(eventType, simple, unit)
	-- If this is a custom buff, don't do any of the following checks and instead just update the remaining time.
	if self.isCustom then
		self:GetRemainingTime()
		return
	end
	
	if self.onlyRefreshOnRequest then
		if self.refreshRequested == false or self.refreshEmbargo ~= nil and self.refreshEmbargo > GetTime() then
			if self.isActive then
				self:GetRemainingTime()
				return
			end
		else
			self.refreshRequested = false
			self.refreshEmbargo = nil
		end
	end

	unit = unit or "player"
	if simple == nil then
		simple = false
	end

	local id = self.parent.spell.buffId or self.parent.spell.spellId or self.parent.spell.id or nil
	if id ~= nil then
		if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_APPLIED_DOSE" then -- Gained buff
			self.isActive = true
			if unit == "player" then
				ParseBuffData(self, C_UnitAuras.GetPlayerAuraBySpellID(id))
			else
				ParseBuffData(self, TRB.Functions.Aura:FindBuffById(id, unit))
			end
			if not simple and not self.currentlySimple then
				self:GetRemainingTime()

				if self.hasTicks then
					self:UpdateTicks()
				end
			end
		elseif eventType == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
			if self.applications ~= nil then
				self.applications = self.applications - 1
			end
		elseif eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_DISPEL" then -- Lost buff
			self:Reset()
		elseif eventType == "SPELL_PERIODIC_ENERGIZE" then -- Tick with gain of energy
			self:GetRemainingTime()

			if self.hasTicks then
				self:UpdateTicks()
			end
		elseif eventType == nil or eventType == "" then
			local currentTime = currentTime or GetTime()
			local foundId = nil
			
			if unit == "player" then
				foundId = ParseBuffData(self, C_UnitAuras.GetPlayerAuraBySpellID(id))
			else
				foundId = ParseBuffData(self, TRB.Functions.Aura:FindBuffById(id, unit))
			end

			if self.currentlySimple then
				self.isActive = foundId == id
			else
				if self.endTime ~= nil and self.endTime > currentTime then
					self.isActive = true
					self:GetRemainingTime()

					if self.hasTicks then
						self:UpdateTicks()
					end
				else
					self:Reset()
				end
			end
		end
	end
end


---@class TRB.Classes.SnapshotCooldown
---@field public startTime number?
---@field public duration number
---@field public remaining number
---@field public remainingTotal number
---@field public onCooldown boolean
---@field public charges integer
---@field public maxCharges integer
---@field public castCount integer
---@field private isCustom boolean
---@field private retryForceTime number?
---@field private parent TRB.Classes.Snapshot
---@field public useManualCharges boolean # When true, charges are tracked manually via events instead of API
---@field public manualCharges integer # Manually tracked current charge count
---@field public manualMaxCharges integer # Manually tracked max charge count
---@field private durationObject any? # Cached DurationObject from C_Spell.GetSpellChargeDuration()
---@field public hastedCooldown boolean # When true, cooldown remaining is dynamically adjusted when haste changes
---@field public lastKnownHaste number? # The haste percentage used when the cooldown was last initialized or recalculated
TRB.Classes.SnapshotCooldown = {}
TRB.Classes.SnapshotCooldown.__index = TRB.Classes.SnapshotCooldown

---Creates a new Snapshot object
---@param parent TRB.Classes.Snapshot # Snapshot that this is a part of
---@return TRB.Classes.SnapshotCooldown
function TRB.Classes.SnapshotCooldown:New(parent)
	local self = {}
	setmetatable(self, TRB.Classes.SnapshotCooldown)
	self:Reset()
	self.parent = parent

	return self
end

---Resets the object to default values
function TRB.Classes.SnapshotCooldown:Reset()
	self.startTime = nil
	self.duration = 0
	self.remaining = 0
	self.remainingTotal = 0
	self.onCooldown = false
	self.charges = 0
	self.castCount = 0
	self.maxCharges = 0
	self.retryForceTime = nil
	self.isCustom = false
	self.useManualCharges = false
	self.manualCharges = 0
	self.manualMaxCharges = 0
	self.durationObject = nil
	self.hastedCooldown = false
	self.lastKnownHaste = nil
end

---Computes the time remaining on the Snapshot
---@param currentTime number? # Timestamp to use for calculations. If not specified, the current time from `GetTime()` will be used instead.
---@param totalTime boolean? # Return the total remaining time of all charges on the Snapshot
---@return number # Cooldown duration remaining on the Snapshot; nil if the startTime or duration is a secret value
function TRB.Classes.SnapshotCooldown:GetRemainingTime(currentTime, totalTime)
	if totalTime == nil then
		totalTime = false
	end
	
	currentTime = currentTime or GetTime()

	-- Manual charges mode: compute remaining time from our manual timer fields
	if self.useManualCharges then
		local remainingTime = 0

		if self.manualCooldownExpires ~= nil and self.manualCooldownDuration ~= nil and self.manualCooldownDuration > 0 then
			remainingTime = math.max(0, self.manualCooldownExpires - currentTime)
		end

		self.onCooldown = self.manualCharges < self.manualMaxCharges
		self.charges = self.manualCharges
		self.maxCharges = self.manualMaxCharges
		self.remaining = remainingTime

		if self.manualMaxCharges > 1 and self.manualCharges < self.manualMaxCharges and self.manualCooldownDuration ~= nil then
			self.remainingTotal = remainingTime + ((self.manualMaxCharges - self.manualCharges - 1) * self.manualCooldownDuration)
		else
			self.remainingTotal = remainingTime
		end

		if totalTime then
			return self.remainingTotal
		else
			return self.remaining
		end
	end

	if self.retryForceTime ~= nil and currentTime > self.retryForceTime then
		self.retryForceTime = nil
		self:Refresh(true)
	end

	if issecretvalue(self.startTime) or issecretvalue(self.duration) then
		local dObj = C_Spell.GetSpellChargeDuration(self.parent.spell.id)
		if dObj ~= nil then
			local remaining = dObj:GetRemainingDuration()
			if not issecretvalue(remaining) then
				return remaining
			end
		end
		return 0
	end

	local remainingTime = 0

	if self.startTime ~= nil and self.duration ~= nil and self.duration > 0 then
		remainingTime = self.duration - (currentTime - self.startTime)
	end

	if remainingTime <= 0 then
		remainingTime = 0
		self.onCooldown = false
---@diagnostic disable-next-line: param-type-mismatch
	elseif not issecretvalue(self.charges) and self.charges > 0 then
		self.onCooldown = false
	else
		self.onCooldown = true
	end

	self.remaining = remainingTime
	
---@diagnostic disable-next-line: param-type-mismatch
	if not issecretvalue(self.maxCharges) and not issecretvalue(self.charges) and self.maxCharges > 1 and self.charges < self.maxCharges then
		self.remainingTotal = self.remaining +  ((self.maxCharges - self.charges - 1) * self.duration)
---@diagnostic disable-next-line: param-type-mismatch
	elseif not issecretvalue(self.maxCharges) and not issecretvalue(self.charges) and self.maxCharges > 1 and self.maxCharges == self.charges then
		self.startTime = nil
		self.duration = 0
		self.remainingTotal = 0
	else
		self.remainingTotal = self.remaining
	end

	if totalTime then
		return self.remainingTotal
	else
		return self.remaining
	end
end

---Initializes the cooldown information for the snapshot with custom startTime and duration values
---@param duration number
---@param startTime? number
---@param hastedCooldown? boolean # When true, the cooldown remaining will be dynamically adjusted when haste changes
---@param currentHaste? number # The current haste percentage (from snapshotData.attributes.haste). Required when hastedCooldown is true.
function TRB.Classes.SnapshotCooldown:InitializeCustom(duration, startTime, hastedCooldown, currentHaste)
	self.startTime = startTime or GetTime()
	self.duration = duration
	self.isCustom = true
	self.hastedCooldown = hastedCooldown or false
	self.lastKnownHaste = self.hastedCooldown and currentHaste or nil
	self:GetRemainingTime()
end

---Recalculates the remaining cooldown time when haste changes, using the formula:
---  newRemaining = oldRemaining * (1 + oldHaste/100) / (1 + newHaste/100)
---@param newHaste number # The new haste percentage
function TRB.Classes.SnapshotCooldown:RecalculateForHaste(newHaste)
	if not self.hastedCooldown or not self.isCustom or not self.onCooldown or self.lastKnownHaste == nil then
		return
	end

	local oldHaste = self.lastKnownHaste
	if oldHaste == newHaste then
		return
	end

	local currentTime = GetTime()
	local oldRemaining = self:GetRemainingTime(currentTime)

	if oldRemaining <= 0 then
		return
	end

	local newRemaining = oldRemaining * (1 + oldHaste / 100) / (1 + newHaste / 100)
	newRemaining = math.max(0, newRemaining)

	-- Reset duration and startTime from "now" so that GetRemainingTime computes newRemaining directly,
	-- avoiding cumulative floating-point drift from back-calculating startTime through the old duration.
	self.duration = newRemaining
	self.startTime = currentTime
	self.lastKnownHaste = newHaste
	self:GetRemainingTime(currentTime)
end

---Initializes the cooldown information for the snapshot by forcing a refresh and a retry on the next frame, if needed
function TRB.Classes.SnapshotCooldown:Initialize()
	self:Refresh(true, true)
end

---Refreshes the cooldown information for the snapshot
---@param force boolean? # Force refresh of the value even if other interal logic would prevent it from doing so
---@param retryForce boolean? # Allow the cooldown to retry a force on the next call to Refresh()
function TRB.Classes.SnapshotCooldown:Refresh(force, retryForce)
	-- Manual charges mode: skip normal API reads, just sync state
	if self.useManualCharges then
		self.charges = self.manualCharges
		self.maxCharges = self.manualMaxCharges
		self.onCooldown = self.manualCharges < self.manualMaxCharges
		-- Manual timer-based cooldown tracking for all manual charge spells.
		-- Check if the current recharge timer has expired.
		if self.onCooldown and self.manualCooldownExpires ~= nil then
			local currentTime = GetTime()
			if currentTime >= self.manualCooldownExpires then
				-- Carry any sub-frame overflow into the next charge's timer
				local overflow = currentTime - self.manualCooldownExpires
				self:GainCharge(self.manualCooldownDuration)
				if overflow > 0 and self.onCooldown and self.manualCooldownExpires ~= nil then
					self.manualCooldownExpires = self.manualCooldownExpires - overflow
				end
			end
		end
		self:GetRemainingTime()
		return
	end

	if not self.isCustom and self.parent.spell ~= nil and self.parent.spell.id ~= nil and (force or self.parent.spell.hasCharges or self.parent.spell.hasCastCount or self.onCooldown) then
		local startTime = nil
		local duration = 0
		if self.parent.spell.hasCharges == true then
			local spellCharges = C_Spell.GetSpellCharges(self.parent.spell.id)
			self.charges = spellCharges.currentCharges
			self.maxCharges = spellCharges.maxCharges
			startTime = spellCharges.cooldownStartTime
			duration = spellCharges.cooldownDuration
---@diagnostic disable-next-line: param-type-mismatch
			if not issecretvalue(self.charges) and not issecretvalue(self.maxCharges) and self.charges == self.maxCharges then
				startTime = 0
				duration = 0
			end
		else
			local spellCooldown = C_Spell.GetSpellCooldown(self.parent.spell.id) --[[@as SpellCooldownInfo]]
			startTime = spellCooldown.startTime
			duration = spellCooldown.duration
		end

		if self.parent.spell.hasCastCount == true then
			self.castCount = C_Spell.GetSpellCastCount(self.parent.spell.id)
		end

---@diagnostic disable-next-line: param-type-mismatch
		if not issecretvalue(startTime) then
			---@type TRB.Classes.SnapshotCasting
			local casting = TRB.Data.snapshotData.casting
			local gcd = casting:GetCurrentGCDLockRemaining()
			
			local currentTime = GetTime()
			local remainingTime = startTime + duration - currentTime

			if ((startTime ~= nil and startTime > 0 and not self.onCooldown and remainingTime > gcd + TRB.Data.character.latency) or
				(self.onCooldown and remainingTime > gcd + TRB.Data.character.latency)) and (self.parent.spell.hasChanges ~= true or (self.parent.spell.hasChanges and self.charges < self.maxCharges))
				then
				self.startTime = startTime
				self.duration = duration
				self.retryForceTime = nil
			elseif self.onCooldown and remainingTime > gcd + TRB.Data.character.latency then
				self.startTime = startTime
				self.duration = duration
				self.retryForceTime = nil
			else
				self.startTime = nil
				self.duration = 0
				if retryForce then
					self.retryForceTime = currentTime
				end
			end
		else
			self.startTime = startTime
			self.duration = duration
		end
	end
	self:GetRemainingTime()
end

---Determines if the cooldown is unusable, either by virtue of being completely on cooldown or having no charges to spend
---@return boolean
function TRB.Classes.SnapshotCooldown:IsUnusable()
	-- Lie and say it is not unusable if we have secret values for charges or cooldown state
---@diagnostic disable-next-line: param-type-mismatch
	if issecretvalue(self.charges) or issecretvalue(self.onCooldown) then
		return false
	end
	return (self.charges == nil or self.charges == 0) and self.onCooldown
end

---Determines if the cooldown is usable, either by virtue of being completely off of cooldown or having any charges to spend
---@return boolean
function TRB.Classes.SnapshotCooldown:IsUsable()
	return not self.onCooldown
end

---Initializes manual charge tracking mode. When enabled, charges are tracked via events
---instead of reading from C_Spell.GetSpellCharges() (which may return secret values).
---@param maxCharges integer # Maximum charges for this spell
---@param currentCharges integer? # Starting charge count. If nil, attempts to read from API; defaults to maxCharges if secret.
function TRB.Classes.SnapshotCooldown:InitializeManualCharges(maxCharges, currentCharges)
	self.useManualCharges = true
	self.manualMaxCharges = maxCharges

	if currentCharges ~= nil then
		self.manualCharges = currentCharges
	else
		-- Try to read current charges from the API
		if self.parent.spell ~= nil and self.parent.spell.id ~= nil then
			local spellCharges = C_Spell.GetSpellCharges(self.parent.spell.id)
			if spellCharges ~= nil and not issecretvalue(spellCharges.currentCharges) then
				self.manualCharges = spellCharges.currentCharges
			else
				-- Default to max charges when API returns secrets (assume fully charged)
				self.manualCharges = maxCharges
			end
		else
			self.manualCharges = maxCharges
		end
	end

	-- Sync public fields
	self.charges = self.manualCharges
	self.maxCharges = self.manualMaxCharges
	self.onCooldown = self.manualCharges < self.manualMaxCharges

	-- If on cooldown, try to bootstrap a recharge timer from the API so charges
	-- aren't permanently stuck after /reload.
	if self.onCooldown and self.manualCooldownExpires == nil and self.parent.spell ~= nil and self.parent.spell.id ~= nil then
		local spellCharges = C_Spell.GetSpellCharges(self.parent.spell.id)
		if spellCharges ~= nil then
			local startTime = spellCharges.cooldownStartTime
			local duration = spellCharges.cooldownDuration
---@diagnostic disable-next-line: param-type-mismatch
			if startTime ~= nil and duration ~= nil and not issecretvalue(startTime) and not issecretvalue(duration) and duration > 0 then
				local now = GetTime()
				local expires = startTime + duration
				if expires > now then
					self.manualCooldownStart = startTime
					self.manualCooldownDuration = duration
					self.manualCooldownExpires = expires
				end
			end
		end
	end

	self:RefreshDurationObject()
end

---Spends a charge (decrements manualCharges, floor at 0)
---@param cooldownDuration number? # The total cooldown duration (with talent mods applied). When provided, starts a manual GetTime()-based timer.
function TRB.Classes.SnapshotCooldown:SpendCharge(cooldownDuration)
	if not self.useManualCharges then return end
	-- If our manual tracking shows 0 charges but a cast succeeded (this is only called
	-- from UNIT_SPELLCAST_SUCCEEDED), then the game must have had at least 1 real charge.
	-- Resync by assuming exactly 1, so spending it brings us to 0 and starts the timer.
	-- The old code reset to manualMaxCharges here, which caused a net INCREASE in charges.
	local resynced = false
	if self.manualCharges <= 0 then
		self.manualCharges = 1
		resynced = true
	end

	-- Capture AFTER resync so that a 0->1 correction doesn't leave wasAlreadyRecharging
	-- as true (which would prevent the recharge timer from starting).
	local wasAlreadyRecharging = self.onCooldown and not resynced

	self.manualCharges = self.manualCharges - 1
	self.charges = self.manualCharges
	self.onCooldown = self.manualCharges < self.manualMaxCharges

	-- Start a recharge timer if one isn't already running.
	-- In WoW's charge system, spending a second charge while the first is recharging
	-- does NOT reset the existing timer — so only start if there's no active timer.
	local now = GetTime()
	local hasRunningTimer = self.manualCooldownExpires ~= nil and self.manualCooldownExpires > now
	if self.onCooldown and not hasRunningTimer and cooldownDuration ~= nil and cooldownDuration > 0 then
		self.manualCooldownStart = now
		self.manualCooldownDuration = cooldownDuration
		self.manualCooldownExpires = now + cooldownDuration
		self.durationObject = nil
	end
end

---Gains a charge (increments manualCharges, cap at manualMaxCharges)
---@param cooldownDuration number? # If still on cooldown after gaining, start a new timer with this duration for the next recharge.
function TRB.Classes.SnapshotCooldown:GainCharge(cooldownDuration)
	if not self.useManualCharges then return end
	self.manualCharges = math.min(self.manualMaxCharges, self.manualCharges + 1)
	self.charges = self.manualCharges
	self.onCooldown = self.manualCharges < self.manualMaxCharges

	if self.onCooldown and cooldownDuration ~= nil and cooldownDuration > 0 then
		-- Still recharging (multi-charge spell): start a new timer for the next charge
		local now = GetTime()
		self.manualCooldownStart = now
		self.manualCooldownDuration = cooldownDuration
		self.manualCooldownExpires = now + cooldownDuration
	else
		-- Fully charged or no duration provided: clear timer fields
		self.manualCooldownStart = nil
		self.manualCooldownDuration = nil
		self.manualCooldownExpires = nil
	end
	self.durationObject = nil
end

---Reduces the remaining manual cooldown by the specified amount.
---If the cooldown expires as a result, GainCharge() is called.
---@param amount number # Seconds to subtract from remaining cooldown
---@param rechargeDuration number? # If a charge is gained and still on cooldown, start a new timer with this duration
function TRB.Classes.SnapshotCooldown:ReduceCooldown(amount, rechargeDuration)
	if self.manualCooldownExpires == nil then return end
	self.manualCooldownExpires = self.manualCooldownExpires - amount
	local now = GetTime()
	if self.manualCooldownExpires <= now then
		-- Calculate how much CDR carried past the expiration point
		local overflow = now - self.manualCooldownExpires
		self:GainCharge(rechargeDuration)
		-- If still recharging (multi-charge), apply the overflow to the new timer
		if overflow > 0 and self.onCooldown and self.manualCooldownExpires ~= nil then
			self.manualCooldownExpires = self.manualCooldownExpires - overflow
		end
	end
end

---Returns the progress (0 to 1) of the manual cooldown timer.
---0 = just started (empty bar), 1 = complete (full bar).
---@param currentTime number? # Current time from GetTime(). If nil, calls GetTime().
---@return number # Progress fraction clamped to [0, 1]
function TRB.Classes.SnapshotCooldown:GetManualCooldownProgress(currentTime)
	if self.manualCooldownExpires == nil or self.manualCooldownDuration == nil or self.manualCooldownDuration <= 0 then
		return self.onCooldown and 0 or 1
	end
	currentTime = currentTime or GetTime()
	local remaining = self.manualCooldownExpires - currentTime
	return math.max(0, math.min(1, 1 - (remaining / self.manualCooldownDuration)))
end

---Refreshes the cached DurationObject. Uses GetSpellChargeDuration for charge-based spells,
---or GetSpellCooldownDuration for single-cooldown spells, mirroring the pattern in Refresh().
function TRB.Classes.SnapshotCooldown:RefreshDurationObject()
	if self.parent.spell ~= nil and self.parent.spell.id ~= nil then
		if self.parent.spell.hasCharges == true then
			self.durationObject = C_Spell.GetSpellChargeDuration(self.parent.spell.id)
		else
			self.durationObject = C_Spell.GetSpellCooldownDuration(self.parent.spell.id)
		end
	else
		self.durationObject = nil
	end
end

---Returns the cached DurationObject, refreshing if nil
---@return any? # DurationObject or nil
function TRB.Classes.SnapshotCooldown:GetDurationObject()
	if self.durationObject == nil then
		self:RefreshDurationObject()
	end
	return self.durationObject
end

---Returns whether the cooldown is actively recharging (has fewer than max charges)
---@return boolean
function TRB.Classes.SnapshotCooldown:IsRechargingManual()
	return self.useManualCharges and self.manualCharges < self.manualMaxCharges
end


---@class TRB.Classes.SnapshotCasting
---@field public spellId integer?
---@field public startTime number?
---@field public endTime number?
---@field public resourceRaw number
---@field public resourceFinal number
---@field public icon string
---@field public spellKey string?
---@field public gcdLockRemaining number
---@field private gcdLockLastUpdate number?
TRB.Classes.SnapshotCasting = {}
TRB.Classes.SnapshotCasting.__index = TRB.Classes.SnapshotCasting

---Creates a new Snapshot object
---@return TRB.Classes.SnapshotCasting
function TRB.Classes.SnapshotCasting:New()
	local self = {}
	setmetatable(self, TRB.Classes.SnapshotCasting)

	self:Reset()
	return self
end

---Resets casting values to default
function TRB.Classes.SnapshotCasting:Reset()
	self.spellId = nil
	self.startTime = nil
	self.endTime = nil
	self.resourceRaw = 0
	self.resourceFinal = 0
	self.icon = ""
	self.spellKey = nil
	self.gcdLockRemaining = 0
	self.gcdLockLastUpdate = nil
end

---Captures the currently casting or channeled spell's timing and icon into the casting snapshot
function TRB.Classes.SnapshotCasting:SnapshotSpell()
	local startTime, endTime, spellId
	_, _, _, startTime, endTime, _, _, _, spellId = UnitCastingInfo("player")

	if spellId == nil then
		_, _, _, startTime, endTime, _, _, spellId, _ = UnitChannelInfo("player")
	end
	
	if spellId ~= nil then
		local spellInfo = C_Spell.GetSpellInfo(spellId)

		self.startTime = startTime / 1000
		self.endTime = endTime / 1000
		self.resourceRaw = manaCost
		self.spellId = spellInfo.spellID
		self.icon = string.format("|T%s:0|t", spellInfo.iconID)
	end
end

---Captures the currently casting or channeled spell's mana cost, timing, and icon into the casting snapshot
function TRB.Classes.SnapshotCasting:SnapshotManaSpell()
	local startTime, endTime, spellId
	_, _, _, startTime, endTime, _, _, _, spellId = UnitCastingInfo("player")

	if spellId == nil then
		_, _, _, startTime, endTime, _, _, spellId, _ = UnitChannelInfo("player")
	end
	
	if spellId ~= nil then
		local spellInfo = C_Spell.GetSpellInfo(spellId)
		local manaCost = -TRB.Classes.SpellBase.GetPrimaryResourceCost({ id = spellInfo.spellID, primaryResourceType = Enum.PowerType.Mana, primaryResourceTypeProperty = "cost", primaryResourceTypeMod = 1.0 }, true, true)

		self.startTime = startTime / 1000
		self.endTime = endTime / 1000
		self.resourceRaw = manaCost
		self.spellId = spellInfo.spellID
		self.icon = string.format("|T%s:0|t", spellInfo.iconID or 134400) -- Default to question mark icon if spell icon is unavailable
	end
end

---Computes and caches the remaining global cooldown lock time using the GCD spell (61304)
---@return number # Remaining GCD lock time in seconds
function TRB.Classes.SnapshotCasting:GetCurrentGCDLockRemaining()
	local currentTime = GetTime()
	if currentTime == self.gcdLockLastUpdate then
		return self.gcdLockRemaining
	end
	local startTime, duration
	local spellCooldown = C_Spell.GetSpellCooldown(61304) --[[@as SpellCooldownInfo]]
	startTime = spellCooldown.startTime
	duration = spellCooldown.duration
	self.gcdLockRemaining = (startTime + duration - currentTime)
	self.gcdLockLastUpdate = currentTime
	return self.gcdLockRemaining
end

---@class TRB.Classes.BuffCustomProperty
---@field public index integer
---@field public dataType string
---@field public name string
---@field public modifier number
TRB.Classes.BuffCustomProperty = {}
TRB.Classes.BuffCustomProperty.__index = TRB.Classes.BuffCustomProperty


---Creates a new BuffCustomProperty object
---@param index integer
---@param dataType string
---@param name string
---@param modifier number?
---@return TRB.Classes.BuffCustomProperty
function TRB.Classes.BuffCustomProperty:New(index, dataType, name, modifier)
	local self = {}
	setmetatable(self, TRB.Classes.BuffCustomProperty)

	self.index = index
	self.dataType = dataType
	self.name = name
	self.modifier = modifier or 1
	return self
end


---@alias trbBuffSimpleMode
---| '"always"' # Always run in simple mode
---| '"sometimes"' # Run in simple mode sometimes
---| '"never"' # Never run in simple mode