---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Character = {}

-- Static mapping from Enum.PowerType values to their UNIT_POWER_UPDATE token strings.
-- Used instead of UnitPowerType("player") to avoid stale results during spec transitions.
local PowerTypeToToken = {
	[Enum.PowerType.Mana] = "MANA",
	[Enum.PowerType.Rage] = "RAGE",
	[Enum.PowerType.Focus] = "FOCUS",
	[Enum.PowerType.Energy] = "ENERGY",
	[Enum.PowerType.ComboPoints] = "COMBO_POINTS",
	[Enum.PowerType.Runes] = "RUNES",
	[Enum.PowerType.RunicPower] = "RUNIC_POWER",
	[Enum.PowerType.SoulShards] = "SOUL_SHARDS",
	[Enum.PowerType.LunarPower] = "LUNAR_POWER",
	[Enum.PowerType.HolyPower] = "HOLY_POWER",
	[Enum.PowerType.Maelstrom] = "MAELSTROM",
	[Enum.PowerType.Chi] = "CHI",
	[Enum.PowerType.Insanity] = "INSANITY",
	[Enum.PowerType.ArcaneCharges] = "ARCANE_CHARGES",
	[Enum.PowerType.Fury] = "FURY",
	[Enum.PowerType.Essence] = "ESSENCE",
}

-- Cached format strings for resource/health percent formatting.
-- Rebuilt only when the precision setting changes (spec switch / options edit).
local cachedResourcePercentFmt = nil
local cachedResourcePercentPrecision = nil
local cachedHealthPercentFmt = nil
local cachedHealthPercentPrecision = nil

local function UpdateSkyridingState()
	local _, canGlide = C_PlayerInfo.GetGlidingInfo()
	TRB.Data.character.isSkyriding = canGlide or false
end

--TODO: Move this somewhere else.
---Fallback implementation that hides all bar groups. Class modules override this with spec-specific visibility logic.
---@param force boolean|nil If true, force-hide even if normally shown
function TRB.Functions.Class:HideResourceBar(force)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if barGroups then
		if barGroups.primary then
			barGroups.primary:Hide()
		end
		if barGroups.secondary then
			barGroups.secondary:Hide()
		end
	end
end

--TODO: Move this somewhere else.
---Fallback event registration that marks the spec as unsupported and hides the resource bar. Class modules override this.
function TRB.Functions.Class:EventRegistration()
	TRB.Data.specSupported = false
	TRB.Details.addonData.registered = false

	TRB.Functions.Bar:HideResourceBar()
end

---Resets class/spec-specific proc attributes on player death. Class modules override this to clear their own flags.
function TRB.Functions.Class:ResetProcsOnDeath()
	-- Base implementation does nothing; class modules override with spec-specific resets.
end

---Returns the composite key whose settings should currently drive the bar's layout/appearance.
---For most classes this is just the active spec (`TRB.Data.character.compositeKey`).
---Druid overrides this when form-switching is enabled to return the form-resolved spec
---(e.g., Cat Form on a Guardian Druid returns "druid_feral").
---@return string|nil compositeKey
function TRB.Functions.Class:GetActiveDisplayCompositeKey()
	return TRB.Data.character.compositeKey
end

---Returns the settings table whose values should currently drive the bar's layout/appearance.
---Built on top of `GetActiveDisplayCompositeKey`. Returns nil when the spec cache is not
---populated yet (e.g., during early initialization).
---@return TRB.Classes.Settings.SpecializationSettingsBase|nil settings
function TRB.Functions.Class:GetActiveDisplaySettings()
	local key = self:GetActiveDisplayCompositeKey()
	if not key or not TRB.Data.specCache or not TRB.Data.specCache[key] then
		return nil
	end
	return TRB.Data.specCache[key].settings
end

---Initializes or refreshes a target entry in the snapshot target data by GUID.
---@param guid string The target's GUID
---@param selfInitializeAllowed boolean|nil If false or nil, skips initialization when guid matches the player's GUID
---@param isFriend boolean|nil If true, marks the target as friendly
---@return boolean initialized True if the target was successfully initialized or refreshed
function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed, isFriend)
	if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
		return false
	end

	if guid ~= nil and guid ~= "" then
		local currentTime = GetTime()
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		local targets = targetData.targets
		
		if not targetData:CheckTargetExists(guid) then
			targetData:InitializeTarget(guid, isFriend)
		end
		if isFriend then
			targets[guid].isFriend = true
		end
		targets[guid].lastUpdate = currentTime
		return true
	end
	return false
end

---Reads the player's current primary and secondary resource values from the WoW API, updates snapshotData.attributes, and pre-formats display strings into snapshotData.formatted.
function TRB.Functions.Character:UpdateResourceValues()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.attributes.resource = UnitPower("player", TRB.Data.resource, true)
	snapshotData.attributes.resourceModified = UnitPower("player", TRB.Data.resource, false)
	snapshotData.attributes.resourcePercent = UnitPowerPercent("player", TRB.Data.resource, true, CurveConstants.ScaleTo100)

	-- Pre-format resource display strings at event time, consuming secret values once.
	-- Per-spec RefreshLookupData picks the appropriate format (resource vs resourceAbbrev).
	local formatted = snapshotData.formatted
	formatted.resource = string.format("%s", snapshotData.attributes.resourceModified)
	formatted.resourceAbbrev = TRB.Functions.String:ConvertToAbbreviatedNumber(snapshotData.attributes.resourceModified)
	-- resourcePercent: all consumers are mana-based specs whose RefreshLookupData expects
	-- precision.mana formatting (e.g., "%.1f").  Mirror the healthPercent pattern.
	local resourcePercentPrecision = 1
	if TRB.Data.specCache and TRB.Data.character and TRB.Data.character.compositeKey then
		local entry = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if entry and entry.settings and entry.settings.precision then
			resourcePercentPrecision = entry.settings.precision.mana or 1
		end
	end
	if resourcePercentPrecision ~= cachedResourcePercentPrecision then
		cachedResourcePercentPrecision = resourcePercentPrecision
		cachedResourcePercentFmt = "%." .. resourcePercentPrecision .. "f"
	end
	formatted.resourcePercent = string.format(cachedResourcePercentFmt, snapshotData.attributes.resourcePercent)

	if TRB.Data.resource2 ~= nil then
		if TRB.Data.resource2 == "SPELL" then
			--Do nothing, this is handled by UNIT_AURA
		elseif TRB.Data.resource2 == "CUSTOM" then
			-- Do nothing
		else
			snapshotData.attributes.resource2 = UnitPower("player", TRB.Data.resource2, false)
			snapshotData.attributes.resource2Modified = UnitPower("player", TRB.Data.resource2, true)
			formatted.resource2 = string.format("%s", snapshotData.attributes.resource2Modified)
		end
	end

	-- If any bar has a resource/health threshold curve, mark visibility dirty so
	-- ProcessBars re-evaluates on the next tick.
	if TRB.Functions.BarVisibility.hasResourceCurve then
		TRB.Functions.BarVisibility:MarkDirty()
	end
end

---Reads the player's current health, max health, absorbs, and incoming heals from the WoW API, updates snapshotData.attributes, pre-formats display strings, and recalculates the health color curve.
function TRB.Functions.Character:UpdateHealthValues()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.attributes.health = UnitHealth("player", true)
	snapshotData.attributes.healthMax = UnitHealthMax("player")
	snapshotData.attributes.healthPercent = UnitHealthPercent("player", true, CurveConstants.ScaleTo100)
	snapshotData.attributes.absorb = UnitGetTotalAbsorbs("player")
	snapshotData.attributes.incomingHeal = UnitGetIncomingHeals("player") or 0
	snapshotData.attributes.healAbsorb = UnitGetTotalHealAbsorbs("player")

	-- Pre-format health display strings at event time, consuming secret values once.
	-- The render tick copies these normal strings into lookup[] without reformatting.
	local formatted = snapshotData.formatted
	formatted.health = TRB.Functions.String:ConvertToAbbreviatedNumber(snapshotData.attributes.health)
	formatted.healthMax = TRB.Functions.String:ConvertToAbbreviatedNumber(snapshotData.attributes.healthMax)
	formatted.absorb = TRB.Functions.String:ConvertToAbbreviatedNumber(snapshotData.attributes.absorb)
	formatted.incomingHeal = TRB.Functions.String:ConvertToAbbreviatedNumber(snapshotData.attributes.incomingHeal)
	formatted.healAbsorb = TRB.Functions.String:ConvertToAbbreviatedNumber(snapshotData.attributes.healAbsorb)
	-- healthPercent requires precision from settings
	local healthPrecision = 1
	if TRB.Data.specCache and TRB.Data.character and TRB.Data.character.compositeKey then
		local entry = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if entry and entry.settings and entry.settings.precision then
			healthPrecision = entry.settings.precision.health or 1
		end
	end
	if healthPrecision ~= cachedHealthPercentPrecision then
		cachedHealthPercentPrecision = healthPrecision
		cachedHealthPercentFmt = "%." .. healthPrecision .. "f"
	end
	formatted.healthPercent = string.format(cachedHealthPercentFmt, snapshotData.attributes.healthPercent)

	-- Get configurable color curve settings from spec settings
	local healthBarSettings = nil
	if TRB.Data.specCache and TRB.Data.character and TRB.Data.character.specName then
		local specCache = TRB.Data.specCache[TRB.Data.character.compositeKey]
		if specCache and specCache.settings and specCache.settings.colors then
			healthBarSettings = specCache.settings.colors.healthBar
		end
	end

	if healthBarSettings == nil then
		return
	end

	-- Build a composite cache key from the settings that feed into the curve.
	-- The curve object itself is normal (non-secret); only the evaluation result is secret.
	-- Caching the curve avoids ~4 C-side object allocations per health event.
	local highColor = (healthBarSettings.high and healthBarSettings.high.color) or ""
	local highThreshold = (healthBarSettings.high and healthBarSettings.high.threshold) or 0.7
	local lowColor = (healthBarSettings.low and healthBarSettings.low.color) or ""
	local lowThreshold = (healthBarSettings.low and healthBarSettings.low.threshold) or 0.0
	local medColor = (healthBarSettings.medium and healthBarSettings.medium.color) or ""
	local medThreshold = (healthBarSettings.medium and healthBarSettings.medium.threshold) or 0.3
	local curveTypeStr = healthBarSettings.type or ""
	local cacheKey = highColor .. highThreshold .. lowColor .. lowThreshold .. medColor .. medThreshold .. curveTypeStr

	local cache = TRB.Data.cache
	if cache.healthCurve == nil or cache.healthCurveKey ~= cacheKey then
		-- Rebuild the curve — settings have changed
		---@type integer?
		local curveType = Enum.LuaCurveType.Step

		local highR, highG, highB, highA = 0, 1, 0, 1
		if healthBarSettings.high and healthBarSettings.high.color then
			highR, highG, highB, highA = TRB.Functions.Color:GetRGBAFromString(healthBarSettings.high.color, true)
		end

		if healthBarSettings.type == "linear" then
			curveType = Enum.LuaCurveType.Linear
		elseif healthBarSettings.type == "step" then
			curveType = Enum.LuaCurveType.Step
		else
			curveType = nil
		end

		local curve = C_CurveUtil.CreateColorCurve()

		if curveType == nil then
			curve:SetType(Enum.LuaCurveType.Step)
			curve:AddPoint(0, CreateColor(highR, highG, highB, highA))
		else
			local lowR, lowG, lowB, lowA = 1, 0, 0, 1
			local mediumR, mediumG, mediumB, mediumA = 1, 1, 0, 1

			if healthBarSettings.low and healthBarSettings.low.color then
				lowR, lowG, lowB, lowA = TRB.Functions.Color:GetRGBAFromString(healthBarSettings.low.color, true)
			end
			if healthBarSettings.medium and healthBarSettings.medium.color then
				mediumR, mediumG, mediumB, mediumA = TRB.Functions.Color:GetRGBAFromString(healthBarSettings.medium.color, true)
			end

			local adjMedThreshold = medThreshold
			if adjMedThreshold >= highThreshold then
				adjMedThreshold = highThreshold - 0.000001
			end

			local adjLowThreshold = lowThreshold
			if adjLowThreshold >= adjMedThreshold then
				adjLowThreshold = adjMedThreshold - 0.000001
			end

			curve:SetType(curveType)
			curve:AddPoint(adjLowThreshold, CreateColor(lowR, lowG, lowB, lowA))
			curve:AddPoint(adjMedThreshold, CreateColor(mediumR, mediumG, mediumB, mediumA))
			curve:AddPoint(highThreshold, CreateColor(highR, highG, highB, highA))
		end

		cache.healthCurve = curve
		cache.healthCurveKey = cacheKey
	end

	-- Evaluate the cached curve — the result is a secret ColorMixin
	snapshotData.attributes.healthColor = UnitHealthPercent("player", true, cache.healthCurve)

	-- If any bar has a resource/health threshold curve, mark visibility dirty so
	-- ProcessBars re-evaluates on the next tick.
	if TRB.Functions.BarVisibility.hasResourceCurve then
		TRB.Functions.BarVisibility:MarkDirty()
	end
end

---Updates the overcap color based on current resource percentage and overcap settings
---Stores the result in snapshotData.attributes.overcapColor (raw ColorMixin object)
---NOTE: Currently unused — snapshotData.attributes.overcapColor has zero consumers.
---Kept for potential future use. All call sites have been removed for performance.
function TRB.Functions.Character:UpdateOvercapColor()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	-- Get spec settings
	local specSettings = nil
	local sharedSettings = nil
	if TRB.Data.settings and TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
		local classSettings = TRB.Data.settings[TRB.Data.character.className]
		if classSettings then
			specSettings = classSettings[TRB.Data.character.specName]
		end
		if TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.compositeKey] then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		end
	end
	
	-- Need both settings objects
	if specSettings == nil or specSettings.overcap == nil then
		snapshotData.attributes.overcapColor = nil
		return
	end
	
	if sharedSettings == nil or sharedSettings.colors == nil or sharedSettings.colors.text == nil or sharedSettings.colors.text.overcap == nil then
		snapshotData.attributes.overcapColor = nil
		return
	end
	
	-- Get the normal and overcap colors
	local normalColor = sharedSettings.colors.text.current.color
	local overcapColor = sharedSettings.colors.text.overcap.color
	local maxResource = TRB.Data.character.maxResource or 100
	
	-- Calculate the overcap threshold as a percentage
	local overcapThreshold
	if specSettings.overcap.mode == "relative" then
		overcapThreshold = maxResource + (specSettings.overcap.relative or 0)
	else
		overcapThreshold = specSettings.overcap.fixed or maxResource
	end
	local overcapPercent = overcapThreshold / maxResource
	
	-- Get RGBA from colors
	local normalR, normalG, normalB, normalA = TRB.Functions.Color:GetRGBAFromString(normalColor, true)
	local overcapR, overcapG, overcapB, overcapA = TRB.Functions.Color:GetRGBAFromString(overcapColor, true)
	
	local normalColorObj = CreateColor(normalR, normalG, normalB, normalA)
	local overcapColorObj = CreateColor(overcapR, overcapG, overcapB, overcapA)
	
	-- Create the curve
	local curve = C_CurveUtil.CreateColorCurve()
	curve:SetType(Enum.LuaCurveType.Step)
	curve:AddPoint(0, normalColorObj)
	curve:AddPoint(overcapPercent, overcapColorObj)
	curve:AddPoint(2.0, overcapColorObj) -- Extend beyond 100% for overflow
	
	-- Evaluate using UnitPowerPercent with the curve - returns the appropriate color
	-- Store the raw color object (like healthColor) for use with SetVertexColor
	snapshotData.attributes.overcapColor = UnitPowerPercent("player", TRB.Data.resource, true, curve)
end

---Handles some change with the character's status
---@param self any
---@param event string
---@param ... unknown
local function CharacterChange(self, event, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" then
		local unitTarget = ...
		if unitTarget ~= "player" then
			return
		end
	end

	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
		if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
			TRB.Functions.Bar:QueueRenderTransition("characterChange:" .. event, 0.35)
		end
	end

	if event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then
		local unitTarget, powerType = ...
		if unitTarget == "player" and (powerType == TRB.Data.resourceToken or powerType == TRB.Data.resource2Token) then
			TRB.Functions.Character:UpdateResourceValues()
			TRB.Data.lookupDirty = true
		elseif unitTarget == "player" and TRB.Data.additionalPowerTokens and TRB.Data.additionalPowerTokens[powerType] then
			if TRB.Functions.BarVisibility.hasResourceCurve then
				TRB.Functions.BarVisibility:MarkDirty()
			end
			TRB.Data.lookupDirty = true
		end
	elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" or event == "UNIT_ABSORB_AMOUNT_CHANGED" or event == "UNIT_HEAL_PREDICTION" or event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" then
		local unitTarget = ...
		if unitTarget == "player" then
			TRB.Functions.Character:UpdateHealthValues()
			TRB.Data.lookupDirty = true
		end
	elseif event == "UNIT_STATS" then
		local unitTarget = ...
		if unitTarget == "player" then
			local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
			snapshotData.attributes.primaryRefresh = true
			TRB.Data.lookupDirty = true
		end
	elseif event == "COMBAT_RATING_UPDATE" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		snapshotData.attributes.secondaryRefresh = true
		TRB.Data.lookupDirty = true
	elseif event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_CONTROL_LOST" then
		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				TRB.Data.character.onTaxi = UnitOnTaxi("player")
				TRB.Functions.BarVisibility:MarkDirty()
			end)
		end)
	elseif event == "PET_BATTLE_OPENING_START" or event == "PET_BATTLE_CLOSE" then
		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				TRB.Data.character.inPetBattle = C_PetBattles.IsInBattle()
				TRB.Functions.BarVisibility:MarkDirty()
			end)
		end)
	elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
		local unitTarget = ...
		if unitTarget == "player" then
			TRB.Data.character.inVehicle = UnitInVehicle("player") or false
			TRB.Functions.BarVisibility:MarkDirty()
		end
	elseif event == "PLAYER_TARGET_CHANGED" then
		TRB.Functions.BarVisibility:MarkDirty()
	elseif event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
		local frame = self
		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				TRB.Data.character.isMounted = IsMounted()
				UpdateSkyridingState()
				local isMounted = TRB.Data.character.isMounted

				if isMounted then
					-- Poll IsFlying() to detect ground↔air transitions while mounted
					TRB.Functions.Character:StartFlightPolling()
				else
					-- Dismounted: stop polling
					TRB.Functions.Character:StopFlightPolling()
				end

				TRB.Functions.BarVisibility:MarkDirty()
			end)
		end)
	elseif event == "PLAYER_CAN_GLIDE_CHANGED" then
		UpdateSkyridingState()

		if TRB.Data.character.isMounted then
			-- Keep flight polling running while mounted
			TRB.Functions.Character:StartFlightPolling()
		else
			TRB.Functions.Character:StopFlightPolling()
		end

		TRB.Functions.BarVisibility:MarkDirty()
	elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		local _, instanceType = GetInstanceInfo()
		TRB.Data.character.instanceType = instanceType or "none"
		TRB.Functions.Character:CheckCharacter()
		TRB.Functions.BarVisibility:MarkDirty()
		TRB.Data.lookupDirty = true
	elseif event == "GROUP_ROSTER_UPDATE" then
		TRB.Functions.BarVisibility:MarkDirty()
	elseif event == "UNIT_FLAGS" then
		local unitTarget = ...
		if unitTarget == "player" then
			TRB.Functions.BarVisibility:MarkDirty()
		end
	elseif event == "PLAYER_DEAD" then
		-- All buffs are lost on death. Reset any manually-tracked (isCustom) buff
		-- snapshots so they don't show stale timers after the player dies.
		local snapshotData = TRB.Data.snapshotData
		if snapshotData and snapshotData.snapshots then
			for _, snapshot in pairs(snapshotData.snapshots) do
				if snapshot.buff and snapshot.buff.isCustom then
					snapshot.buff:Reset(nil, true)
				end
			end
		end
		-- Reset audio "played" flags so cues can fire again after respawn.
		if snapshotData and snapshotData.audio then
			wipe(snapshotData.audio)
		end
		-- Let class modules clear their spec-specific proc attributes.
		TRB.Functions.Class:ResetProcsOnDeath()
		TRB.Data.lookupDirty = true
	else
		TRB.Functions.Class:CheckCharacter()
		TRB.Functions.Character:UpdatePrimaryStatsSnapshot()
		TRB.Functions.Character:UpdateSecondaryStatsSnapshot()
		TRB.Data.lookupDirty = true
	end
end

local characterChangeFrame = CreateFrame("Frame")
characterChangeFrame:SetScript("OnEvent", CharacterChange)

---Registers all character-change events (power updates, health, stats, mounting, zone changes, etc.) on the characterChangeFrame.
function TRB.Functions.Character:EnableCharacterChange()
	characterChangeFrame:RegisterEvent("UNIT_POWER_UPDATE")
	characterChangeFrame:RegisterEvent("UNIT_POWER_FREQUENT")
	characterChangeFrame:RegisterEvent("UNIT_HEALTH")
	characterChangeFrame:RegisterEvent("UNIT_MAXHEALTH")
	characterChangeFrame:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	characterChangeFrame:RegisterEvent("UNIT_HEAL_PREDICTION")
	characterChangeFrame:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
	characterChangeFrame:RegisterEvent("UNIT_STATS")
	characterChangeFrame:RegisterEvent("COMBAT_RATING_UPDATE")
	characterChangeFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	characterChangeFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
	characterChangeFrame:RegisterEvent("PLAYER_CONTROL_LOST")
	characterChangeFrame:RegisterEvent("PET_BATTLE_OPENING_START")
	characterChangeFrame:RegisterEvent("PET_BATTLE_CLOSE")
	characterChangeFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	characterChangeFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
	characterChangeFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	characterChangeFrame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
	characterChangeFrame:RegisterEvent("PLAYER_CAN_GLIDE_CHANGED")
	characterChangeFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	characterChangeFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	characterChangeFrame:RegisterEvent("UNIT_FLAGS")
	characterChangeFrame:RegisterEvent("PLAYER_DEAD")
	characterChangeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	characterChangeFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	characterChangeFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
end

---Unregisters all character-change events from the characterChangeFrame and stops flight polling.
function TRB.Functions.Character:DisableCharacterChange()
	characterChangeFrame:UnregisterEvent("UNIT_POWER_UPDATE")
	characterChangeFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	characterChangeFrame:UnregisterEvent("UNIT_HEALTH")
	characterChangeFrame:UnregisterEvent("UNIT_MAXHEALTH")
	characterChangeFrame:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	characterChangeFrame:UnregisterEvent("UNIT_HEAL_PREDICTION")
	characterChangeFrame:UnregisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
	characterChangeFrame:UnregisterEvent("UNIT_STATS")
	characterChangeFrame:UnregisterEvent("COMBAT_RATING_UPDATE")
	characterChangeFrame:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	characterChangeFrame:UnregisterEvent("PLAYER_CONTROL_GAINED")
	characterChangeFrame:UnregisterEvent("PLAYER_CONTROL_LOST")
	characterChangeFrame:UnregisterEvent("PET_BATTLE_OPENING_START")
	characterChangeFrame:UnregisterEvent("PET_BATTLE_CLOSE")
	characterChangeFrame:UnregisterEvent("UNIT_ENTERED_VEHICLE")
	characterChangeFrame:UnregisterEvent("UNIT_EXITED_VEHICLE")
	characterChangeFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
	characterChangeFrame:UnregisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
	characterChangeFrame:UnregisterEvent("PLAYER_CAN_GLIDE_CHANGED")
	characterChangeFrame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	characterChangeFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
	characterChangeFrame:UnregisterEvent("UNIT_FLAGS")
	characterChangeFrame:UnregisterEvent("PLAYER_DEAD")
	characterChangeFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	characterChangeFrame:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	characterChangeFrame:UnregisterEvent("TRAIT_CONFIG_UPDATED")
	TRB.Functions.Character:StopFlightPolling()
end

-- Flight state polling for mounted flight transitions.
-- IsFlying() changes without any event when transitioning between ground and air,
-- so we poll at a short interval while mounted.
local flightPollTicker = nil
local lastKnownIsFlying = nil

---Starts polling IsFlying() every 0.25s. Only marks dirty when the value changes.
---Safe to call multiple times (idempotent).
function TRB.Functions.Character:StartFlightPolling()
	if flightPollTicker then
		return -- already running
	end
	lastKnownIsFlying = IsFlying()
	flightPollTicker = C_Timer.NewTicker(0.25, function()
		local flying = IsFlying()
		if flying ~= lastKnownIsFlying then
			lastKnownIsFlying = flying
			TRB.Functions.BarVisibility:MarkDirty()
		end
	end)
end

---Stops the IsFlying() polling ticker.
---Safe to call when not running (idempotent).
function TRB.Functions.Character:StopFlightPolling()
	if flightPollTicker then
		flightPollTicker:Cancel()
		flightPollTicker = nil
	end
	lastKnownIsFlying = nil
end

---Handles SPELL_RANGE_CHECK_UPDATE events
---@param self any
---@param event string
---@param spellIdentifier integer|string
---@param isInRange boolean
---@param checksRange boolean
local function SpellRangeCheckUpdateEvent(self, event, spellIdentifier, isInRange, checksRange)
	if type(spellIdentifier) == "number" then
		if checksRange == true then
			TRB.Data.cache.values.range[spellIdentifier] = isInRange
			return
		end
	end

	if TRB.Data.specCache[TRB.Data.barConstructedForSpec] ~= nil then
		local specCache = TRB.Data.specCache[TRB.Data.barConstructedForSpec] ---@type TRB.Classes.SpecCache
		for _, v in pairs(specCache.spellsData.spells) do
			if v.id == spellIdentifier then
				v:UpdateIsSpellInRange()
				return
			end
		end
	end
end

local spellRangeCheckUpdateFrame = CreateFrame("Frame")
spellRangeCheckUpdateFrame:SetScript("OnEvent", SpellRangeCheckUpdateEvent)

---Enables all spells that need to have range checks performed
function TRB.Functions.Character:EnableSpellRangeCheckUpdate()
	local specCache = TRB.Data.specCache[TRB.Data.barConstructedForSpec] ---@type TRB.Classes.SpecCache
	
	if specCache ~= nil and TRB.Functions.Threshold:ShouldShowOutOfRangeThresholds(specCache.settings) then
		for _, v in pairs(specCache.spellsData.spells) do
			if (v:Is("TRB.Classes.SpellThreshold") or v:Is("TRB.Classes.SpellComboPointThreshold")) and v:IsValid() and v.rangeCheck == true then
				C_Spell.EnableSpellRangeCheck(v.id, true)
				v:UpdateIsSpellInRange()
			end
		end
	end

	spellRangeCheckUpdateFrame:RegisterEvent("SPELL_RANGE_CHECK_UPDATE")
end

---Disables all spells that need to have range checks performed
function TRB.Functions.Character:DisableSpellRangeCheckUpdate()
	local specCache = TRB.Data.specCache[TRB.Data.barConstructedForSpec] ---@type TRB.Classes.SpecCache

	spellRangeCheckUpdateFrame:UnregisterEvent("SPELL_RANGE_CHECK_UPDATE")
	
	-- Do two passes over this:
	-- 1) spells that should be disabled based on the specCache
	-- 2) any spells we might already have cached
	if specCache ~= nil then
		for _, v in pairs(specCache.spellsData.spells) do
			if (v:Is("TRB.Classes.SpellThreshold") or v:Is("TRB.Classes.SpellComboPointThreshold")) and v:IsValid() and v.rangeCheck == true then
				C_Spell.EnableSpellRangeCheck(v.id, false)
			end
		end
	end

	for k, _ in pairs(TRB.Data.cache.values.range) do
		C_Spell.EnableSpellRangeCheck(k, false)
	end

	TRB.Data.cache.values.range = {}
end

---@param className string?
---@return string?
local function NormalizeClassRegistryKey(className)
	if type(className) ~= "string" then
		return nil
	end
	return string.lower(string.gsub(className, "%s+", ""))
end

---Look up a classRegistry entry from numeric classId or an internal class name/token.
---@param classIdOrName number|string
---@return TRB.Data.ClassRegistryEntry|nil
function TRB.Functions.Character:GetClassRegistryEntry(classIdOrName)
	if type(classIdOrName) == "number" then
		return TRB.Data.classRegistryByIds[classIdOrName]
	elseif type(classIdOrName) == "string" then
		local key = NormalizeClassRegistryKey(classIdOrName)
		if key ~= nil and TRB.Data.classRegistry[key] ~= nil then
			return TRB.Data.classRegistry[key]
		end
		local token = string.upper(string.gsub(classIdOrName, "%s+", ""))
		return TRB.Data.classRegistryByTokens[token]
	end
	return nil
end

---Returns the addon module/options key for a class, e.g. "DeathKnight".
---@param classIdOrName number|string
---@return string|nil
function TRB.Functions.Character:GetClassModuleName(classIdOrName)
	local entry = self:GetClassRegistryEntry(classIdOrName)
	return entry and entry.classModuleName or nil
end

-- Resolved display name per resource-type token. Literal localization keys only (built at
-- load like BarText's anchor maps). Single source for turning a GetSpecConfiguration
-- resourceType / primary token into a user-facing name.
local resourceTypeNames = {
	-- Primary power types
	Rage = TRB.Localization["ResourceRage"],
	Mana = TRB.Localization["ResourceMana"],
	Energy = TRB.Localization["ResourceEnergy"],
	Focus = TRB.Localization["ResourceFocus"],
	Insanity = TRB.Localization["ResourceInsanity"],
	RunicPower = TRB.Localization["ResourceRunicPower"],
	Maelstrom = TRB.Localization["ResourceMaelstrom"],
	AstralPower = TRB.Localization["ResourceAstralPower"],
	Fury = TRB.Localization["ResourceFury"],
	-- Secondary / custom / utility resources
	ComboPoints = TRB.Localization["ResourceComboPoints"],
	SoulShards = TRB.Localization["ResourceSoulShards"],
	SoulFragments = TRB.Localization["ResourceSoulFragments"],
	CollapsingStar = TRB.Localization["ResourceCollapsingStar"],
	ArcaneCharges = TRB.Localization["ResourceArcaneCharges"],
	Runes = TRB.Localization["ResourceRunes"],
	HolyPower = TRB.Localization["ResourceHolyPower"],
	Chi = TRB.Localization["ResourceChi"],
	Essence = TRB.Localization["ResourceEssence"],
	TipOfTheSpear = TRB.Localization["ResourceTipOfTheSpear"],
	MaelstromWeapon = TRB.Localization["ResourceMaelstromWeapon"],
	Icicles = TRB.Localization["ResourceIcicles"],
	BoneShield = TRB.Localization["ResourceBoneShield"],
	Stagger = TRB.Localization["ResourceStagger"],
	Health = TRB.Localization["ResourceHealth"],
	Utility = TRB.Localization["ResourceUtility"],
	AngelicFeather = TRB.Localization["ResourceAngelicFeather"],
	Lightweaver = TRB.Localization["ResourcePriestLightweaver"],
	HolyWords = TRB.Localization["ResourcePriestHolyWords"],
	PowerWords = TRB.Localization["BarNamePowerWordsBar"],
	DefensiveBuffs = TRB.Localization["ResourceWarriorDefensives"],
	WhirlwindCharges = TRB.Localization["ResourceWarriorWhirlwind"],
	EbonMight = TRB.Localization["ResourceEvokerEbonMight"],
	FireBlastCharges = TRB.Localization["MageFireBlastCharges"],
}

---Reads a spec's bar-group configuration (GetSpecConfiguration) without requiring it to be
---the active spec. Shared by the BarText, IO, and Threshold modules.
---@param classId integer?
---@param specId integer?
---@return table?
function TRB.Functions.Character:GetSpecBarGroupConfig(classId, specId)
	if classId == nil or specId == nil then
		return nil
	end
	local className = self:GetClassModuleName(classId)
	if className == nil then
		return nil
	end
	local classModule = TRB.Classes and TRB.Classes[className]
	if classModule == nil or classModule.BarGroupsFactory == nil or classModule.BarGroupsFactory.GetSpecConfiguration == nil then
		return nil
	end
	return classModule.BarGroupsFactory:GetSpecConfiguration(specId)
end

---Returns the localized display name for a resource-type token (as used in
---GetSpecConfiguration resourceType fields and primary power types), or nil if unknown.
---@param resourceType string?
---@return string?
function TRB.Functions.Character:GetResourceTypeName(resourceType)
	if resourceType == nil then
		return nil
	end
	return resourceTypeNames[resourceType]
end

---Returns the localized PRIMARY resource name for a spec, or nil if unknown. Reads the
---primary bar's resourceType from the spec's GetSpecConfiguration (declared alongside the
---secondary/health/custom bar resource types).
---@param classId integer?
---@param specId integer?
---@return string?
function TRB.Functions.Character:GetPrimaryResourceName(classId, specId)
	local config = self:GetSpecBarGroupConfig(classId, specId)
	local token = config and config.primary and config.primary.resourceType or nil
	return self:GetResourceTypeName(token)
end

---Returns the uppercase WoW class file token for a class, e.g. "DEATHKNIGHT".
---@param classIdOrName number|string
---@return string|nil
function TRB.Functions.Character:GetClassToken(classIdOrName)
	local entry = self:GetClassRegistryEntry(classIdOrName)
	return entry and entry.classToken or nil
end

---Returns the numeric classId for an internal class name/token.
---@param className string
---@return integer|nil
function TRB.Functions.Character:GetClassIdFromName(className)
	local entry = self:GetClassRegistryEntry(className)
	return entry and entry.classId or nil
end

---Returns class registry entries in WoW classId order.
---@return TRB.Data.ClassRegistryEntry[]
function TRB.Functions.Character:GetClassRegistryEntriesOrdered()
	return TRB.Data.classRegistryOrder
end

---Returns spec registry entries in WoW classId/specId order.
---@return TRB.Data.SpecRegistryEntry[]
function TRB.Functions.Character:GetSpecRegistryEntriesOrdered()
	return TRB.Data.specRegistryOrder
end

---Returns ordered spec registry entries for a class.
---@param classIdOrName number|string
---@return TRB.Data.SpecRegistryEntry[]
function TRB.Functions.Character:GetSpecRegistryEntriesForClass(classIdOrName)
	local classEntry = self:GetClassRegistryEntry(classIdOrName)
	return classEntry and classEntry.specs or {}
end

---Returns the class file name and specialization name for the given classId and specId.
---@param classId number|nil The numeric class ID (1-13). If nil, returns "Global".
---@param specId number The numeric spec index (1-4) within the class
---@param lowerCaseClass boolean|nil If true, returns the class name in lowercase
---@return string className The class file name (e.g., "WARRIOR" or "warrior" if lowerCaseClass is true)
---@return string specName The specialization name in camelCase (e.g., "beastMastery"), or "" if not found
function TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, lowerCaseClass)
	local classEntry = classId ~= nil and self:GetClassRegistryEntry(classId) or nil
	local className
	if classId ~= nil then
		className = classEntry and classEntry.classToken or select(2, GetClassInfo(classId))
	else
		className = "Global"
	end

	local specEntry = classId ~= nil and self:GetSpecRegistryEntryFromIds(classId, specId) or nil
	local specName = specEntry and specEntry.specName or nil
	if specName == nil then
		specName = ""
	end

	if lowerCaseClass then
		return classEntry and classEntry.className or string.lower(className), specName
	else
		return className, specName
	end
end

---Converts a class name and numeric spec index into the addon's internal camelCase spec name.
---@param className string The class file name (e.g., "WARRIOR", "DEATHKNIGHT")
---@param specId number The numeric spec index (1-4) within the class
---@return string|nil specName The camelCase specialization name (e.g., "beastMastery"), or nil if not recognized
function TRB.Functions.Character:GetSpecializationName(className, specId)
	local classEntry = self:GetClassRegistryEntry(className)
	if classEntry == nil then
		return nil
	end

	local specEntry = self:GetSpecRegistryEntryFromIds(classEntry.classId, specId)
	return specEntry and specEntry.specName or nil
end

---Build a composite key from a className and specName.
---@param className string All-lowercase class name (e.g., "deathknight")
---@param specName string Spec name in camelCase (e.g., "beastMastery")
---@return string compositeKey e.g., "deathknight_frost"
function TRB.Functions.Character:GetCompositeKey(className, specName)
	return className .. "_" .. specName
end

---Look up a composite key from numeric classId and specId via the specRegistry.
---@param classId number
---@param specId number
---@return string|nil compositeKey e.g., "warrior_arms", or nil if not found
function TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	local byClass = TRB.Data.specRegistryByIds[classId]
	if byClass then
		local entry = byClass[specId]
		if entry then
			return entry.compositeKey
		end
	end
	return nil
end

---Parse a composite key back into its className and specName components.
---@param compositeKey string e.g., "deathknight_frost"
---@return string className e.g., "deathknight"
---@return string specName e.g., "frost"
function TRB.Functions.Character:ParseCompositeKey(compositeKey)
	local className, specName = string.match(compositeKey, "^([^_]+)_(.+)$")
	return className, specName
end

---Look up a specRegistry entry from a composite key.
---@param compositeKey string e.g., "warrior_arms"
---@return TRB.Data.SpecRegistryEntry|nil
function TRB.Functions.Character:GetSpecRegistryEntry(compositeKey)
	return TRB.Data.specRegistry[compositeKey]
end

---Look up a specRegistry entry from numeric classId and specId.
---@param classId number
---@param specId number
---@return TRB.Data.SpecRegistryEntry|nil
function TRB.Functions.Character:GetSpecRegistryEntryFromIds(classId, specId)
	local byClass = TRB.Data.specRegistryByIds[classId]
	if byClass then
		return byClass[specId]
	end
	return nil
end

---Get the composite key for the currently active character.
---@return string|nil compositeKey e.g. "deathknight_frost" or nil if not yet set
function TRB.Functions.Character:GetActiveCompositeKey()
	return TRB.Data.character.compositeKey
end

---Get the specCache entry for the currently active character (using compositeKey).
---@return table|nil specCacheEntry The specCache entry (contains .settings, .talents, etc.)
function TRB.Functions.Character:GetActiveSpecCache()
	local key = TRB.Data.character.compositeKey
	if key then
		return TRB.Data.specCache[key]
	end
	return nil
end

---Updates character state flags (PvP talents, mounted, skyriding, instance type) and starts or stops flight polling based on mount state.
function TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.isPvp = TRB.Functions.Talent:ArePvpTalentsActive()
	TRB.Data.character.isMounted = IsMounted()
	TRB.Data.character.onTaxi = UnitOnTaxi("player") or false
	TRB.Data.character.inPetBattle = C_PetBattles.IsInBattle() or false

	-- Phase 2 visibility state
	UpdateSkyridingState()

	local _, instanceType = GetInstanceInfo()
	TRB.Data.character.instanceType = instanceType or "none"

	-- Start/stop flight polling based on current mount state
	if TRB.Data.character.isMounted then
		TRB.Functions.Character:StartFlightPolling()
	else
		TRB.Functions.Character:StopFlightPolling()
	end
end

---Reads Strength, Agility, Stamina, and Intellect from the WoW API into snapshotData.attributes and pre-formats display strings.
function TRB.Functions.Character:UpdatePrimaryStatsSnapshot()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.attributes.strength, _, _, _ = UnitStat("player", 1)
	snapshotData.attributes.agility, _, _, _ = UnitStat("player", 2)
	snapshotData.attributes.stamina, _, _, _ = UnitStat("player", 3)
	snapshotData.attributes.intellect, _, _, _ = UnitStat("player", 4)

	-- Pre-format primary stat display strings at event time
	local precision = 2
	local entry = TRB.Functions.Character:GetActiveSpecCache()
	if entry and entry.settings and entry.settings.precision then
		precision = entry.settings.precision.secondary or 2
	end
	local formatted = snapshotData.formatted
	local shortNum = TRB.Functions.String.ConvertToShortNumberNotation
	formatted.int = shortNum(TRB.Functions.String, snapshotData.attributes.intellect, precision, "floor", true)
	formatted.str = shortNum(TRB.Functions.String, snapshotData.attributes.strength, precision, "floor", true)
	formatted.agi = shortNum(TRB.Functions.String, snapshotData.attributes.agility, precision, "floor", true)
	formatted.stam = shortNum(TRB.Functions.String, snapshotData.attributes.stamina, precision, "floor", true)

	snapshotData.attributes.cacheRefresh = true
	snapshotData.attributes.primaryRefresh = false
end

---Reads haste, crit, mastery, and versatility (percentages and ratings) from the WoW API, recalculates hasted cooldowns if haste changed, pre-formats display strings, and computes the GCD value.
function TRB.Functions.Character:UpdateSecondaryStatsSnapshot()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	snapshotData.attributes.haste = UnitSpellHaste("player")

	-- Try to immediately read the new GCD duration. If we're mid-GCD, GetTotalDuration()
	-- returns the real value and we can update right away. Otherwise we fall back to the
	-- deferred path (actioned on next cast in SpellCastEvent).
	local oldGcd = snapshotData.attributes.gcdDuration or 1.5
	local immediateGcd
	local durationObj = C_Spell.GetSpellCooldownDuration(61304)
	if durationObj then
		local totalDuration = durationObj:GetTotalDuration()
		if not issecretvalue(totalDuration) and totalDuration > 0 then
			immediateGcd = totalDuration
		end
	end

	if immediateGcd and immediateGcd ~= oldGcd then
		snapshotData.attributes.gcdDuration = immediateGcd
		snapshotData:RecalculateHastedCooldowns(oldGcd, immediateGcd, GetTime())
		snapshotData.attributes.pendingGcdRecalc = nil

		local displayGcd = immediateGcd
		if displayGcd > 1.5 then displayGcd = 1.5 elseif displayGcd < 0.75 then displayGcd = 0.75 end
		snapshotData.formatted.gcd = string.format("%.2f", displayGcd)
		snapshotData.formatted.gcdRaw = displayGcd
	else
		-- Flag deferred haste recalc — actioned on next GCD observation in SpellCastEvent.
		snapshotData.attributes.pendingGcdRecalc = {
			time = GetTime(),
			oldGcd = oldGcd,
		}
	end

	snapshotData.attributes.crit = GetCritChance()
	snapshotData.attributes.mastery = GetMasteryEffect()
	snapshotData.attributes.versatilityOffensive = GetCombatRatingBonus(29)
	snapshotData.attributes.versatilityDefensive = GetCombatRatingBonus(31)

	snapshotData.attributes.hasteRating = GetCombatRating(20)
	snapshotData.attributes.critRating = GetCombatRating(11)
	snapshotData.attributes.masteryRating = GetCombatRating(26)
	snapshotData.attributes.versatilityRating = GetCombatRating(29)

	-- Pre-format secondary stat display strings at event time
	local precision = 2
	local entry = TRB.Functions.Character:GetActiveSpecCache()
	if entry and entry.settings and entry.settings.precision then
		precision = entry.settings.precision.secondary or 2
	end
	local formatted = snapshotData.formatted
	local shortNum = TRB.Functions.String.ConvertToShortNumberNotation
	local roundTo = TRB.Functions.Number.RoundTo
	local numLib = TRB.Functions.Number
	local strLib = TRB.Functions.String

	formatted.hasteRating = shortNum(strLib, snapshotData.attributes.hasteRating, precision, "floor", true)
	formatted.critRating = shortNum(strLib, snapshotData.attributes.critRating, precision, "floor", true)
	formatted.masteryRating = shortNum(strLib, snapshotData.attributes.masteryRating, precision, "floor", true)
	formatted.versRating = shortNum(strLib, snapshotData.attributes.versatilityRating, precision, "floor", true)

	formatted.haste = roundTo(numLib, snapshotData.attributes.haste, precision)
	formatted.crit = roundTo(numLib, snapshotData.attributes.crit, precision)
	formatted.mastery = roundTo(numLib, snapshotData.attributes.mastery, precision)
	formatted.versOff = roundTo(numLib, snapshotData.attributes.versatilityOffensive, precision)
	formatted.versDef = roundTo(numLib, snapshotData.attributes.versatilityDefensive, precision)

	-- GCD (always 2 decimal places, clamped 0.75 – 1.5)
	-- Uses cached GCD duration from SpellCastEvent instead of haste math (haste is secret)
	local _gcd = snapshotData.attributes.gcdDuration or 1.5
	if _gcd > 1.5 then _gcd = 1.5 elseif _gcd < 0.75 then _gcd = 0.75 end
	formatted.gcd = string.format("%.2f", _gcd)
---@diagnostic disable-next-line: assign-type-mismatch
	formatted.gcdRaw = _gcd

	snapshotData.attributes.cacheRefresh = true
	snapshotData.attributes.secondaryRefresh = false
end

---Re-reads live API values and re-formats all pre-formatted display strings.
---Call this whenever precision settings change so the cached format strings update.
function TRB.Functions.Character:RecomputeFormattedValues()
	local snapshotData = TRB.Data.snapshotData
	if snapshotData == nil then return end
	TRB.Functions.Character:UpdateResourceValues()
	TRB.Functions.Character:UpdateHealthValues()
	TRB.Functions.Character:UpdatePrimaryStatsSnapshot()
	TRB.Functions.Character:UpdateSecondaryStatsSnapshot()
	TRB.Functions.BarText:InvalidateLookupMemoization()
end

---Updates target tracking in the snapshot by refreshing spell tracking data for the current target. Initializes the target if it does not exist and is not dead.
function TRB.Functions.Character:UpdateSnapshot()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	
	if target == nil and targetData.currentTargetGuid ~= nil then
		local isDead = UnitIsDeadOrGhost("target")

		if not isDead then
			targetData:InitializeTarget(targetData.currentTargetGuid, UnitIsFriend("target", "player"))
			target = targetData.targets[targetData.currentTargetGuid]
		end
	end
	
	if target ~= nil then
		target:UpdateAllSpellTracking(currentTime)
	end
end

---Loads data from the specialization cache in to the main TRB.Data table
---@param cache TRB.Classes.SpecCache
function TRB.Functions.Character:LoadFromSpecializationCache(cache)
	Global_TwintopResourceBar = cache.Global_TwintopResourceBar

	TRB.Data.character = cache.character
	-- The cached character table may carry a stale specId from the previous time this spec
	-- was active. Always stamp the current specId so downstream code (EventRegistration,
	-- UpdateResourceBar, etc.) branches into the correct spec.
	TRB.Data.character.specId = GetSpecialization() or TRB.Data.character.specId
	TRB.Data.character.latency = TRB.Functions.Character:GetLatency()
	TRB.Data.character.inCombat = InCombatLockdown()
	TRB.Data.character.inVehicle = UnitInVehicle("player") or false
	TRB.Data.character.inPetBattle = C_PetBattles.IsInBattle() or false
	TRB.Data.character.onTaxi = UnitOnTaxi("player") or false
	TRB.Data.spellsData = cache.spellsData
	TRB.Data.talents = cache.talents
	TRB.Data.barTextVariables.icons = cache.barTextVariables.icons
	TRB.Data.barTextVariables.values = cache.barTextVariables.values
	TRB.Data.snapshotData = cache.snapshotData
	TRB.Data.snapshotData.attributes.isTracking = false
	TRB.Functions.Character:ResetCaches()
	TRB.Functions.BarVisibility:MarkDirty()
end

---Clears all cached color data (border, bar, backdrop, health curve, absorb border curve) and resets the RGBA parse memoization.
function TRB.Functions.Character:ResetColorCaches()
	wipe(TRB.Data.cache.colors.border)
	wipe(TRB.Data.cache.colors.bar)
	wipe(TRB.Data.cache.colors.backdrop)
	wipe(TRB.Data.cache.colors.gradient)
	-- Invalidate cached health color curve so it rebuilds from fresh settings
	TRB.Data.cache.healthCurve = nil
	TRB.Data.cache.healthCurveKey = nil
	-- Clear RGBA parse memoization to bound memory
	TRB.Functions.Color:ClearRGBACache()
end 

---Clears all runtime caches (bar text, symbols, parse trees, resource/threshold values, colors) and rebuilds the threshold spell list.
function TRB.Functions.Character:ResetCaches()
	wipe(TRB.Data.cache.barText)
	TRB.Functions.BarText:ClearBarTextCacheHash()
	wipe(TRB.Data.cache.symbols)
	wipe(TRB.Data.cache.barTextTree)
	TRB.Data.activeVariables = nil
	wipe(TRB.Data.cache.values.bar)
	wipe(TRB.Data.cache.values.resource)
	wipe(TRB.Data.cache.values.threshold)
	TRB.Functions.Character:ResetColorCaches()
	-- We don't do range check cache reset here since we need to track what we've enabled and clean it up when we change specs
	--TRB.Data.cache.values.range = {}
	TRB.Functions.Character:GetThresholdSpells(TRB.Data.spellsData.spells, TRB.Data.talents)
end

---Fills the specialization cache with a combination of global and spec specific settings
---@param className string # Class name
---| '"deathknight"' # Death Knight
---| '"demonhunter"' # Demon Hunter
---| '"druid"' # Druid 
---| '"evoker"' # Evoker
---| '"hunter"' # Hunter
---| '"mage"' # Mage
---| '"monk"' # Monk
---| '"paladin' # Paladin
---| '"priest"' # Priest
---| '"rogue"' # Rogue
---| '"shaman"' # Shaman
---| '"warlock' # Warlock
---| '"warrior"' # Warrior
---@param specName string
---| '"blood"' # Blood (Death Knight)
---| '"frost"' # Frost (Death Knight, Mage)
---| '"unholy"' # Unholy (Death Knight)
---| '"havoc"' # Havoc (Demon Hunter)
---| '"vengeance"' # Vengeance (Demon Hunter)
---| '"devourer"' # Devourer (Demon Hunter)
---| '"balance"' # Balance (Druid)
---| '"feral"' # Feral (Druid)
---| '"guardian"' # Guardian (Druid)
---| '"restoration"' # Restoration (Druid, Shaman)
---| '"devastation"' # Devastation (Evoker)
---| '"preservation"' # Preservation (Evoker)
---| '"augmentation"' # Augmentation (Evoker)
---| '"beastMastery"' # Beast Mastery (Hunter)
---| '"marksmanship"' # Marksmanship (Hunter)
---| '"survival"' # Survival (Hunter)
---| '"arcane"' # Arcane (Mage)
---| '"fire"' # Fire (Mage)
---| '"brewmaster"' # Brewmaster (Monk)
---| '"mistweaver"' # Mistweaver (Monk)
---| '"windwalker"' # Windwalker (Monk)
---| '"retribution"' # Retribution (Paladin)
---| '"discipline"' # Discipline (Priest)
---| '"holy"' # Holy (Paladin, Priest)
---| '"shadow"' # Shadow (Priest)
---| '"assassination"' # Assassination (Rogue)
---| '"outlaw"' # Outlaw (Rogue)
---| '"subtlety"' # Subtlety (Rogue)
---| '"elemental"' # Elemental (Shaman)
---| '"enhancement"' # Enhancement (Shaman)
---| '"affliction"' # Affliction (Warlock)
---| '"demonology"' # Demonology (Warlock)
---| '"destruction"' # Destruction (Warlock)
---| '"arms"' # Arms (Warrior)
---| '"fury"' # Fury (Warrior)
---| '"protection"' # Protection (Paladin, Warrior)
---@param isHealer boolean
function TRB.Functions.Character:FillSpecializationCacheSettings(className, specName, isHealer)
	local compositeKey = TRB.Functions.Character:GetCompositeKey(className, specName)
	local specCache = TRB.Data.specCache[compositeKey] --[[@as TRB.Classes.SpecCache]]
	local core = TRB.Data.settings.core --[[@as TRB.Classes.Settings.Core]]
	local s = core.global[className][specName] --[[@as TRB.Classes.Settings.SpecializationGlobalEnabled]]
	local enabled = (core.global.globalEnable or s.specEnable) and specCache.settings ~= nil
	local spec = TRB.Data.settings[className][specName] --[[@as TRB.Classes.Settings.SpecializationSettingsBase]]

	if s.bar then
		specCache.settings.bar = core.bar
	else
		specCache.settings.bar = spec.bar
	end

	if s.comboPoints then
		specCache.settings.comboPoints = core.comboPoints
	else
		specCache.settings.comboPoints = spec.comboPoints
	end

	if s.healthBar then
		specCache.settings.healthBar = core.healthBar
	else
		specCache.settings.healthBar = spec.healthBar
	end

	-- Extra bar settings (no global toggle, always use spec settings if present)
	if spec.bars then
		specCache.settings.bars = spec.bars
	end

	-- Build merged bar text list: global entries first, then spec entries
	local mergedBarText
	local globalBarTextCount = 0
	if s.globalBarText and core.displayText and core.displayText.barText and #core.displayText.barText > 0 then
		mergedBarText = {}
		for _, entry in ipairs(core.displayText.barText) do
			mergedBarText[#mergedBarText + 1] = entry
		end
		globalBarTextCount = #mergedBarText
		for _, entry in ipairs(spec.displayText.barText) do
			mergedBarText[#mergedBarText + 1] = entry
		end
	else
		mergedBarText = spec.displayText.barText
	end

---@diagnostic disable-next-line: missing-fields
	specCache.settings.displayText = {
		barText = mergedBarText,
		globalBarTextCount = globalBarTextCount
	}

	if s.displayText then
		specCache.settings.displayText.default = core.displayText.default
	else
		specCache.settings.displayText.default = spec.displayText.default
	end

	specCache.settings.colors = {
---@diagnostic disable-next-line: missing-fields
		text = {},
		bar = spec.colors.bar,
---@diagnostic disable-next-line: missing-fields
		threshold = {},
		comboPoints = spec.colors.comboPoints,
		bars = spec.colors.bars,
---@diagnostic disable-next-line: missing-fields
		healthBar = {},
		manaBar = spec.colors.manaBar
	}

	if s.textColors then
		specCache.settings.colors.text.current = core.colors.text.current
		specCache.settings.colors.text.casting = core.colors.text.casting
		specCache.settings.colors.text.spending = core.colors.text.spending
		specCache.settings.colors.text.passive = core.colors.text.passive
		specCache.settings.colors.text.overThreshold = core.colors.text.overThreshold
		specCache.settings.colors.text.overcap = core.colors.text.overcap
		-- manaBar is spec-specific (only for Shadow Priest, Balance Druid, Elemental Shaman), so always use spec colors
		specCache.settings.colors.text.manaBar = spec.colors.text.manaBar
	else
		specCache.settings.colors.text.current = spec.colors.text.current
		specCache.settings.colors.text.casting = spec.colors.text.casting
		specCache.settings.colors.text.spending = spec.colors.text.spending
		specCache.settings.colors.text.passive = spec.colors.text.passive
		specCache.settings.colors.text.overThreshold = spec.colors.text.overThreshold
		specCache.settings.colors.text.overcap = spec.colors.text.overcap
		specCache.settings.colors.text.manaBar = spec.colors.text.manaBar
	end

---@diagnostic disable-next-line: missing-fields
	specCache.settings.colors.threshold = {}
	if spec.colors.threshold ~= nil then
		for key, _ in pairs(spec.colors.threshold) do
			specCache.settings.colors.threshold[key] = spec.colors.threshold[key]
		end
	end

	if s.thresholdColors then
		if isHealer then
		else
			specCache.settings.colors.threshold.over = core.colors.threshold.over
			specCache.settings.colors.threshold.under = core.colors.threshold.under
			specCache.settings.colors.threshold.unusable = core.colors.threshold.unusable
			specCache.settings.colors.threshold.special = core.colors.threshold.special
			specCache.settings.colors.threshold.outOfRange = core.colors.threshold.outOfRange
		end
	end

	-- Share the whole table by reference (like bar/comboPoints/manaBar) so primitive
	-- fields such as `type` stay in sync with live edits, not just the sub-tables.
	if s.healthBarColors then
		specCache.settings.colors.healthBar = core.colors.healthBar
	else
		specCache.settings.colors.healthBar = spec.colors.healthBar
	end

	if spec.thresholds ~= nil then
	---@diagnostic disable-next-line: missing-fields
		specCache.settings.thresholds = {
			specProperties = spec.thresholds.specProperties,
			thresholdDictionary = {},
			customThresholds = {}
		}
		if s.thresholdIcons then
			specCache.settings.thresholds.properties = core.thresholds.properties
			specCache.settings.thresholds.icons = core.thresholds.icons
		else
			specCache.settings.thresholds.properties = spec.thresholds.properties
			specCache.settings.thresholds.icons = spec.thresholds.icons
		end

		if spec.thresholds ~= nil and spec.thresholds.thresholdDictionary ~= nil then
			for key, _ in pairs(spec.thresholds.thresholdDictionary) do
				specCache.settings.thresholds.thresholdDictionary[key] = spec.thresholds.thresholdDictionary[key]
			end
		end

		if spec.thresholds ~= nil and spec.thresholds.customThresholds ~= nil then
			for key, _ in pairs(spec.thresholds.customThresholds) do
				specCache.settings.thresholds.customThresholds[key] = spec.thresholds.customThresholds[key]
			end
		end
	else
		specCache.settings.thresholds = {
			specProperties = {},
			properties = core.thresholds.properties,
			icons = core.thresholds.icons,
			thresholdDictionary = {},
			customThresholds = {}
		}
	end

	if s.precision then
		specCache.settings.precision = core.precision
	else
		specCache.settings.precision = spec.precision
	end
	
	if s.textures then
		specCache.settings.textures = core.textures
	else
		specCache.settings.textures = spec.textures
	end

	-- Mana bar and custom bar textures are spec-specific (not available in core settings)
	-- When using global textures with texture lock enabled, sync from primary bar texture
	-- When using global textures with texture lock disabled, use spec-specific textures
	-- When using spec textures, always use spec-specific textures
	if spec.textures then
		local useGlobalWithTextureLock = s.textures and specCache.settings.textures.textureLock
		
		-- Mana bar textures
		if useGlobalWithTextureLock then
			-- Sync mana bar textures to primary bar texture from global settings
			specCache.settings.textures.manaBarBar = specCache.settings.textures.resourceBar
			specCache.settings.textures.manaBarBarName = specCache.settings.textures.resourceBarName
			specCache.settings.textures.manaBarBorder = specCache.settings.textures.border
			specCache.settings.textures.manaBarBorderName = specCache.settings.textures.borderName
			specCache.settings.textures.manaBarBackground = specCache.settings.textures.background
			specCache.settings.textures.manaBarBackgroundName = specCache.settings.textures.backgroundName
		else
			-- Use spec-specific mana bar textures
			if spec.textures.manaBarBar then
				specCache.settings.textures.manaBarBar = spec.textures.manaBarBar
				specCache.settings.textures.manaBarBarName = spec.textures.manaBarBarName
			end
			if spec.textures.manaBarBorder then
				specCache.settings.textures.manaBarBorder = spec.textures.manaBarBorder
				specCache.settings.textures.manaBarBorderName = spec.textures.manaBarBorderName
			end
			if spec.textures.manaBarBackground then
				specCache.settings.textures.manaBarBackground = spec.textures.manaBarBackground
				specCache.settings.textures.manaBarBackgroundName = spec.textures.manaBarBackgroundName
			end
		end
		
		-- Custom bar textures using flat keys (e.g., staggerBar, staggerBorder, staggerBackground)
		local registry = TRB.Classes.BarTypeRegistry:GetInstance()
		for key, _ in pairs(registry:GetAll()) do
			local barKey = key .. "Bar"
			local borderKey = key .. "Border"
			local bgKey = key .. "Background"
			if useGlobalWithTextureLock then
				-- Sync custom bar textures to primary bar texture from global settings
				specCache.settings.textures[barKey] = specCache.settings.textures.resourceBar
				specCache.settings.textures[barKey .. "Name"] = specCache.settings.textures.resourceBarName
				specCache.settings.textures[borderKey] = specCache.settings.textures.border
				specCache.settings.textures[borderKey .. "Name"] = specCache.settings.textures.borderName
				specCache.settings.textures[bgKey] = specCache.settings.textures.background
				specCache.settings.textures[bgKey .. "Name"] = specCache.settings.textures.backgroundName
			else
				-- Use spec-specific custom bar textures
				if spec.textures[barKey] then
					specCache.settings.textures[barKey] = spec.textures[barKey]
					specCache.settings.textures[barKey .. "Name"] = spec.textures[barKey .. "Name"]
				end
				if spec.textures[borderKey] then
					specCache.settings.textures[borderKey] = spec.textures[borderKey]
					specCache.settings.textures[borderKey .. "Name"] = spec.textures[borderKey .. "Name"]
				end
				if spec.textures[bgKey] then
					specCache.settings.textures[bgKey] = spec.textures[bgKey]
					specCache.settings.textures[bgKey .. "Name"] = spec.textures[bgKey .. "Name"]
				end
			end
		end
	end

	-- Custom bar dimensions (stagger, defensives, mana, etc.) - always spec-specific
	if spec.bars then
		specCache.settings.bars = spec.bars
	end

	-- Custom bar colors (stagger, defensives, mana, etc.) - always spec-specific
	if spec.colors and spec.colors.bars then
		specCache.settings.colors.bars = spec.colors.bars
	end

	if s.displayBar then
		-- Create a deep copy to avoid modifying the global displayBar object
		specCache.settings.displayBar = {}
		for k, v in pairs(core.displayBar) do
			if type(v) == "table" then
				-- Deep copy the table (neverShow, conditions, smooth, etc.)
				specCache.settings.displayBar[k] = {}
				for k2, v2 in pairs(v) do
					if type(v2) == "table" then
						-- Deep copy nested tables (e.g., conditions)
						specCache.settings.displayBar[k][k2] = {}
						for k3, v3 in pairs(v2) do
							specCache.settings.displayBar[k][k2][k3] = v3
						end
					else
						specCache.settings.displayBar[k][k2] = v2
					end
				end
				-- When using global displayBar, both visibility AND smooth come from global
			else
				specCache.settings.displayBar[k] = v
			end
		end
		
		-- Override with spec-specific displayBar keys that don't exist in core.displayBar.
		-- Custom bars (mana, stagger, defensives, holyWords, lightweaver, boneShield, etc.)
		-- and non-visibility flags (enableFormSwitching, showComboPoints) are always
		-- spec-specific because they aren't exposed in the global panel.
		-- This loop automatically picks up any new custom bar types without needing
		-- manual additions here — preventing the recurring bug where a new bar type
		-- was invisible under "Use global settings" because it wasn't listed.
		if spec.displayBar then
			for k, v in pairs(spec.displayBar) do
				if core.displayBar[k] == nil then
					specCache.settings.displayBar[k] = v
				end
			end
		end
	else
		specCache.settings.displayBar = spec.displayBar
	end

	--NYI
	specCache.settings.audio = spec.audio
	specCache.settings.maxResource = spec.maxResource
	specCache.settings.barVisibilityThresholds = spec.barVisibilityThresholds

end

--- Mapping from lowercase className to PascalCase options module key
---@type table<string, string>
local CLASS_OPTIONS_KEY = {
	deathknight = "DeathKnight",
	demonhunter = "DemonHunter",
	druid = "Druid",
	evoker = "Evoker",
	hunter = "Hunter",
	mage = "Mage",
	monk = "Monk",
	paladin = "Paladin",
	priest = "Priest",
	rogue = "Rogue",
	shaman = "Shaman",
	warlock = "Warlock",
	warrior = "Warrior",
}

-- Tracks which classes have had their defaults merged into TRB.Data.settings.
-- The old .bar sentinel was unreliable: the ADDON_LOADED merge copies saved data
-- for ALL classes, so a non-active class can have .bar from old saved vars while
-- still missing newer default fields (e.g., colors.bar.casting).
local classDefaultsMerged = {}

---Ensure that default spec settings exist in TRB.Data.settings for the given class.
---Loads defaults from the class's options module and merges them (as base) with
---any existing saved values so that new default fields are always present.
---Only performs the merge once per class per session.
---@param className string Lowercase class name (e.g., "warrior")
---@return boolean success Whether settings were successfully ensured
function TRB.Functions.Character:EnsureSpecSettings(className)
	if classDefaultsMerged[className] then
		return true
	end

	local settings = TRB.Data.settings
	if not settings or not settings[className] then
		return false
	end

	local optionsKey = CLASS_OPTIONS_KEY[className]
	if not optionsKey or not TRB.Options[optionsKey] or not TRB.Options[optionsKey].LoadDefaultSettings then
		return false
	end

	-- Load defaults WITHOUT bar text (includeBarText=false). Using true would populate default
	-- barText arrays that Table:Merge cannot shrink — if the user cleared their bar text to {},
	-- the merge iterates zero incoming keys and the defaults survive, repopulating phantom entries.
	local classDefaults = TRB.Options[optionsKey].LoadDefaultSettings(false)
	if not classDefaults or not classDefaults[className] then
		return false
	end

	-- Also load defaults WITH bar text, but only to seed specs the user has never initialized.
	local classDefaultsWithBarText = TRB.Options[optionsKey].LoadDefaultSettings(true)

	-- Track whether ANY spec in this class needed fresh bar text seeding
	local seededBarTextForClass = false

	-- Merge class-specific defaults into current settings.
	-- Table:Merge(original, incoming) gives incoming priority, so defaults are
	-- the base and any existing saved settings overlay on top.
	for specName, specDefaults in pairs(classDefaults[className]) do
		if type(specDefaults) == "table" then
			-- Check if this spec has never been initialized (no displayText key in saved settings).
			-- A user who deleted all bar text still has displayText = { barText = {} } in saved vars.
			-- A brand new spec stub is just {} with no displayText at all.
			local savedSpec = settings[className][specName]
			local isNewSpec = not savedSpec or type(savedSpec) ~= "table" or savedSpec.displayText == nil

			settings[className][specName] = TRB.Functions.Table:Merge(specDefaults, savedSpec or {})

			-- For never-initialized specs, seed bar text from the full defaults
			if isNewSpec and classDefaultsWithBarText and classDefaultsWithBarText[className]
				and classDefaultsWithBarText[className][specName]
				and classDefaultsWithBarText[className][specName].displayText
				and classDefaultsWithBarText[className][specName].displayText.barText then
				settings[className][specName].displayText.barText = classDefaultsWithBarText[className][specName].displayText.barText
				seededBarTextForClass = true
			end
		end
	end

	-- If we just seeded fresh default bar text for this class, mark the midnightBarTextReset
	-- migration as done. The migration is meant for users upgrading from TWW with old-format
	-- bar text — not for specs that just received brand-new defaults. Without this, logging
	-- into the class later would trigger the migration and clobber any changes the user made
	-- to bar text via the cross-class options panel.
	if seededBarTextForClass
		and settings.manualUpdateChecks
		and settings.manualUpdateChecks.midnightBarTextReset
		and settings.manualUpdateChecks.midnightBarTextReset[className] ~= nil then
		settings.manualUpdateChecks.midnightBarTextReset[className] = true
	end

	classDefaultsMerged[className] = true
	return true
end

---Lazily create a minimal specCache entry for the given composite key if one doesn't exist.
---Ensures the spec's settings are loaded (from defaults if needed) and populates the
---specCache settings via FillSpecializationCacheSettings.
---barTextVariables will be empty ({icons={}, values={}}) until FillSpellData is called.
---@param compositeKey string e.g., "warrior_arms"
---@return TRB.Classes.SpecCache|nil
function TRB.Functions.Character:EnsureSpecCache(compositeKey)
	-- If it already exists and has populated settings, return it
	if TRB.Data.specCache[compositeKey] and TRB.Data.specCache[compositeKey].settings
		and TRB.Data.specCache[compositeKey].settings.bar then
		return TRB.Data.specCache[compositeKey]
	end

	local className, specName = TRB.Functions.Character:ParseCompositeKey(compositeKey)
	if not className or not specName then
		return nil
	end

	-- Ensure default settings exist for this class
	if not TRB.Functions.Character:EnsureSpecSettings(className) then
		return nil
	end

	-- Create the specCache entry if it doesn't exist
	if not TRB.Data.specCache[compositeKey] then
		TRB.Data.specCache[compositeKey] = TRB.Classes.SpecCache:New()
	end

	-- Populate merged settings into the specCache entry
	-- isHealer=false is safe for lazy loading; the active class's FillSpecializationCacheSettings
	-- call with the correct isHealer value will override this when the spec becomes active.
	TRB.Functions.Character:FillSpecializationCacheSettings(className, specName, false)

	-- Populate barTextVariables for cross-class options panel display.
	-- For the active class, barTextVariables are populated by FillSpellData_[Spec] at load time.
	-- For non-active classes, we use the registry to fill icons/values from the Classes files.
	local entry = TRB.Data.specCache[compositeKey]
	if entry and TRB.Functions.Table:Length(entry.barTextVariables.icons) == 0 then
		local registry = TRB.Data.barTextVariablesRegistry
		if registry and registry[compositeKey] then
			registry[compositeKey](entry)
		end
	end

	return entry
end

---Calculates the player's current GCD duration, clamped between 0.75s and 1.5s.
---Uses the cached GCD duration observed from C_Spell.GetSpellCooldownDuration(61304)
---during the last spell cast, since haste is now a secret value.
---@param floor boolean|nil If true, skips the 0.75s minimum clamp (allows sub-0.75 values)
---@return number gcd The GCD duration in seconds
function TRB.Functions.Character:GetCurrentGCDTime(floor)
	if floor == nil then
		floor = false
	end

	local snapshotData = TRB.Data.snapshotData
	local gcd = (snapshotData and snapshotData.attributes and snapshotData.attributes.gcdDuration) or 1.5

	if not floor and gcd < 0.75 then
		gcd = 0.75
	end

	return gcd
end

---Resets the casting snapshot data to its default state by calling Reset() on snapshotData.casting.
function TRB.Functions.Character:ResetCastingSnapshotData()
	---@type TRB.Classes.SnapshotCasting
	local casting = TRB.Data.snapshotData.casting
	casting:Reset()
end

---Retrieves the player's current world latency in seconds (world lag from GetNetStats divided by 1000).
---@return number latency World latency in seconds
function TRB.Functions.Character:GetLatency()
	--local down, up, lagHome, lagWorld = GetNetStats()
	local _, _, _, lagWorld = GetNetStats()
	local latency = lagWorld / 1000
	return latency
end

---Caches threshold spells for the current specialization that are currently available.
---@param spells TRB.Classes.SpecializationSpellsBase
---@param talents TRB.Classes.Talents
function TRB.Functions.Character:GetThresholdSpells(spells, talents)
	-- Note to future Twintop: using table.insert() and not keeping track of the thresholdIds manually results
	-- in missing thresholds from the list. Sometimes. I don't know why, but it does, so we're doing it manually.
	---@type TRB.Classes.SpellThreshold[]
	local thresholdSpells = {}
	local thresholdId = 0
	for _, v in pairs(spells) do
		local spell = v --[[@as TRB.Classes.SpellBase]]
		if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) then
			spell = spell --[[@as TRB.Classes.SpellThreshold]]
			if spell:IsValid() then
				if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected	
				else
					thresholdId = thresholdId + 1
					thresholdSpells[thresholdId] = spell
				end
			end
		end
	end
	TRB.Data.cache.thresholdSpells = thresholdSpells
end

---Default implementation of RecreateThresholds. Class modules can override this
---to handle spec-specific thresholds on secondary bars, stagger bars, etc.
---This is called when re-enabling a previously disabled spec.
---@param settings TRB.Classes.Settings.SpecializationSettingsBase
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Class:RecreateThresholds(settings, barGroups)
	-- Primary bar thresholds (generic implementation)
	if barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			local existingThresholds = primaryNode:GetThresholds()
			local thresholdSpells = TRB.Data.cache.thresholdSpells
			-- Check if thresholds need to be created (either empty or wrong count)
			if thresholdSpells and #thresholdSpells > 0 and (not existingThresholds or #existingThresholds ~= #thresholdSpells) then
				primaryNode:ClearThresholds()
				for _ = 1, #thresholdSpells do
					local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetFrame())
					TRB.Functions.Threshold:ResetThresholdLine(thresholdFrame, settings, true)
					primaryNode:RegisterThreshold(thresholdFrame)
				end
			end
		end
	end
	-- Class modules should override this function to also handle:
	-- - Secondary bar thresholds (combo point dividers, soul fragment dividers, etc.)
	-- - Stagger bar thresholds (Brewmaster Monk)
	-- - Other custom bar thresholds
end

---Registers or unregisters all addon event handlers based on whether the current spec is supported. When supported, initializes resources, enables combat/aura/spellcast tracking, sets up update timers, and reapplies bar layout. When unsupported, tears down all event handlers and hides all bar groups.
function TRB.Functions.Character:EventRegistration()
	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.specSupported then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		-- Derive resourceToken from the PowerType enum set by the class module, not from
		-- UnitPowerType("player"). During spec transitions, UnitPowerType can return the
		-- OLD spec's power type, permanently breaking the UNIT_POWER_UPDATE event filter
		-- and causing the resource bar to freeze.
		if TRB.Data.resource ~= nil then
			TRB.Data.resourceToken = PowerTypeToToken[TRB.Data.resource]
		end
		if TRB.Data.resource2 ~= nil then
			snapshotData.attributes.resource2 = 0
			if TRB.Data.resource2 ~= "SPELL" and TRB.Data.resource2 ~= "CUSTOM" then
				TRB.Data.resource2Token = PowerTypeToToken[TRB.Data.resource2]
			else
				-- Clear stale token from a previous spec so UNIT_POWER_UPDATE events
				-- for an unrelated power type don't trigger unnecessary updates.
				TRB.Data.resource2Token = nil
			end
		end
		TRB.Functions.Character:UpdateResourceValues()
		TRB.Functions.Character:UpdateHealthValues()
		TRB.Functions.Class:CheckCharacter()
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Details.addonData.registered = true
		TRB.Functions.Aura:EnableUnitAura()
		TRB.Functions.SpellCast:EnableSpellCast()
		TRB.Functions.Character:EnableCharacterChange()
		TRB.Functions.Character:EnableSpellRangeCheckUpdate()
		targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)

		-- Reapply bar appearance when re-enabling a previously disabled spec
		-- Note: TriggerResourceBarUpdates is NOT called here because talents/spells may not be set yet.
		-- The class module's SwitchSpec or ConstructResourceBar handles the full update after setup is complete.
		if barGroups and TRB.Data.specCache and TRB.Data.character.specName then
			local specSettings = TRB.Data.specCache[TRB.Data.character.compositeKey]
			if specSettings and specSettings.settings then
				-- Initialize Edit Mode if not yet done (required for CDM anchoring/width matching)
				if TRB.Functions.EditMode and TRB.Functions.EditMode.Initialize then
					TRB.Functions.EditMode:Initialize()
				end

				-- Recreate thresholds if they don't exist (happens when spec was disabled on initial load)
				-- This calls into a class-module-overridable function to handle spec-specific thresholds
				if TRB.Functions.Class.RecreateThresholds then
					TRB.Functions.Class:RecreateThresholds(specSettings.settings, barGroups)
				end

				TRB.Functions.Bar:ApplyBarGroupsLayout(specSettings.settings, barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(specSettings.settings, barGroups)

				-- Register all tree roots with Edit Mode (each root gets its own wrapper)
				if TRB.Functions.EditMode then
					TRB.Functions.EditMode:RegisterAllTreeRoots()
				end

				TRB.Functions.BarText:CreateBarTextFrames()
				TRB.Functions.BarText:Hide(specSettings.settings)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Class:HideResourceBar()
			end
		end
	else
		targetsTimerFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Functions.Aura:DisableUnitAura()
		TRB.Functions.SpellCast:DisableSpellCast()
		TRB.Functions.Character:DisableCharacterChange()
		TRB.Functions.Character:DisableSpellRangeCheckUpdate()
		TRB.Details.addonData.registered = false
		if barGroups then
			if barGroups.primary then
				barGroups.primary:Hide()
			end
			if barGroups.secondary then
				barGroups.secondary:Hide()
			end
			if barGroups.health then
				barGroups.health:Hide()
			end
			if barGroups.mana then
				barGroups.mana:Hide()
			end
			if barGroups.stagger then
				barGroups.stagger:Hide()
			end
			if barGroups.defensives then
				barGroups.defensives:Hide()
			end
			if barGroups.holyWords then
				barGroups.holyWords:Hide()
			end
		end
	end

	TRB.Functions.BarVisibility:MarkDirty()
	TRB.Functions.Bar:HideResourceBar()
end
