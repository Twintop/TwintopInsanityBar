---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Character = {}

--TODO: Find a better home for this.
local function OnAdvFlyEnabled()
	TRB.Data.character.advancedFlight = true
	TRB.Functions.Bar:HideResourceBar()
end

local function OnAdvFlyDisabled()
	TRB.Data.character.advancedFlight = false
	if TRB.Data.specSupported == true then
		TRB.Functions.Bar:ShowResourceBar()
	end
end

--[[
TRB.Details.addonData.libs.LibAdvFlight.RegisterCallback(TRB.Details.addonData.libs.LibAdvFlight.Events.ADV_FLYING_ENABLED, OnAdvFlyEnabled);
TRB.Details.addonData.libs.LibAdvFlight.RegisterCallback(TRB.Details.addonData.libs.LibAdvFlight.Events.ADV_FLYING_DISABLED, OnAdvFlyDisabled);
]]

--TODO: Move this somewhere else.
--This is a fallback method for the Advanced Flight checking on a class that doesn't have support. Hide everything bar related.
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
--This is a fallback method for the Advanced Flight checking on a class that doesn't have support. Hide everything bar related.
function TRB.Functions.Class:EventRegistration()
	TRB.Data.specSupported = false
	TRB.Details.addonData.registered = false

	TRB.Functions.Bar:HideResourceBar()
end

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

local function UpdateResourceValues()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.attributes.resource = UnitPower("player", TRB.Data.resource, true)
	snapshotData.attributes.resourceModified = UnitPower("player", TRB.Data.resource, false)
	snapshotData.attributes.resourcePercent = UnitPowerPercent("player", TRB.Data.resource, true, CurveConstants.ScaleTo100)
	if TRB.Data.resource2 ~= nil then
		if TRB.Data.resource2 == "SPELL" then
			--Do nothing, this is handled by UNIT_AURA
		elseif TRB.Data.resource2 == "CUSTOM" then
			-- Do nothing
		else
			snapshotData.attributes.resource2 = UnitPower("player", TRB.Data.resource2, false)
			snapshotData.attributes.resource2Modified = UnitPower("player", TRB.Data.resource2, true)
		end
	end
end

function TRB.Functions.Character:UpdateHealthValues()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.attributes.health = UnitHealth("player", true)
	snapshotData.attributes.healthMax = UnitHealthMax("player")
	snapshotData.attributes.healthPercent = UnitHealthPercent("player", true, CurveConstants.ScaleTo100)

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

	-- Use configurable settings or defaults
	local curveType = Enum.LuaCurveType.Step

	if healthBarSettings then
		local highR, highG, highB, highA = 0, 1, 0, 1
		local highThreshold = 0.7
		-- High health color and threshold
		if healthBarSettings.high then
			if healthBarSettings.high.color then
				highR, highG, highB, highA = TRB.Functions.Color:GetRGBAFromString(healthBarSettings.high.color, true)
			end
			if healthBarSettings.high.threshold then
				highThreshold = healthBarSettings.high.threshold
			end
		end

		-- Curve type
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
			local lowThreshold = 0.0
			local lowR, lowG, lowB, lowA = 1, 0, 0, 1
			local mediumThreshold = 0.3
			local mediumR, mediumG, mediumB, mediumA = 1, 1, 0, 1

			-- Low health color and threshold
			if healthBarSettings.low then
				if healthBarSettings.low.color then
					lowR, lowG, lowB, lowA = TRB.Functions.Color:GetRGBAFromString(healthBarSettings.low.color, true)
				end
				if healthBarSettings.low.threshold then
					lowThreshold = healthBarSettings.low.threshold
				end
			end

			-- Medium health color and threshold
			if healthBarSettings.medium then
				if healthBarSettings.medium.color then
					mediumR, mediumG, mediumB, mediumA = TRB.Functions.Color:GetRGBAFromString(healthBarSettings.medium.color, true)
				end
				if healthBarSettings.medium.threshold then
					mediumThreshold = healthBarSettings.medium.threshold
				end
			end

			if mediumThreshold >= highThreshold then
				mediumThreshold = highThreshold - 0.000001
			end

			if lowThreshold >= mediumThreshold then
				lowThreshold = mediumThreshold - 0.000001
			end

			curve:SetType(curveType)
			curve:AddPoint(lowThreshold, CreateColor(lowR, lowG, lowB, lowA))
			curve:AddPoint(mediumThreshold, CreateColor(mediumR, mediumG, mediumB, mediumA))
			curve:AddPoint(highThreshold, CreateColor(highR, highG, highB, highA))
		end
		local hpColor = UnitHealthPercent("player", true, curve)

		snapshotData.attributes.healthColor = hpColor
	end
end

---Updates the overcap color based on current resource percentage and overcap settings
---Stores the result in snapshotData.attributes.overcapColor (raw ColorMixin object)
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
			UpdateResourceValues()
			TRB.Functions.Character:UpdateOvercapColor()
		end
	elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
		local unitTarget = ...
		if unitTarget == "player" then
			TRB.Functions.Character:UpdateHealthValues()
		end
	elseif event == "UNIT_STATS" then
		if unitTarget == "player" then
			local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
			snapshotData.attributes.primaryRefresh = true
		end
	elseif event == "COMBAT_RATING_UPDATE" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		snapshotData.attributes.secondaryRefresh = true
	elseif event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_CONTROL_LOST" then
		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				TRB.Data.character.onTaxi = UnitOnTaxi("player")
			end)
		end)
	elseif event == "PET_BATTLE_OPENING_START" or event == "PET_BATTLE_CLOSE" then
		C_Timer.After(0, function()
			C_Timer.After(0.05, function()
				TRB.Data.character.inPetBattle = C_PetBattles.IsInBattle()
			end)
		end)
	elseif event == "PLAYER_ENTERING_WORLD" then
		TRB.Functions.Character:CheckCharacter()
	else
		TRB.Functions.Class:CheckCharacter()
		TRB.Functions.Character:UpdatePrimaryStatsSnapshot()
		TRB.Functions.Character:UpdateSecondaryStatsSnapshot()
	end
end

local characterChangeFrame = CreateFrame("Frame")
characterChangeFrame:SetScript("OnEvent", CharacterChange)

function TRB.Functions.Character:EnableCharacterChange()
	characterChangeFrame:RegisterEvent("UNIT_POWER_UPDATE")
	characterChangeFrame:RegisterEvent("UNIT_POWER_FREQUENT")
	characterChangeFrame:RegisterEvent("UNIT_HEALTH")
	characterChangeFrame:RegisterEvent("UNIT_MAXHEALTH")
	characterChangeFrame:RegisterEvent("UNIT_STATS")
	characterChangeFrame:RegisterEvent("COMBAT_RATING_UPDATE")
	characterChangeFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	characterChangeFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
	characterChangeFrame:RegisterEvent("PLAYER_CONTROL_LOST")
	characterChangeFrame:RegisterEvent("PET_BATTLE_OPENING_START")
	characterChangeFrame:RegisterEvent("PET_BATTLE_CLOSE")
	characterChangeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	characterChangeFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	characterChangeFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
end

function TRB.Functions.Character:DisableCharacterChange()
	characterChangeFrame:UnregisterEvent("UNIT_POWER_UPDATE")
	characterChangeFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	characterChangeFrame:UnregisterEvent("UNIT_HEALTH")
	characterChangeFrame:UnregisterEvent("UNIT_MAXHEALTH")
	characterChangeFrame:UnregisterEvent("UNIT_STATS")
	characterChangeFrame:UnregisterEvent("COMBAT_RATING_UPDATE")
	characterChangeFrame:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	characterChangeFrame:UnregisterEvent("PLAYER_CONTROL_GAINED")
	characterChangeFrame:UnregisterEvent("PLAYER_CONTROL_LOST")
	characterChangeFrame:UnregisterEvent("PET_BATTLE_OPENING_START")
	characterChangeFrame:UnregisterEvent("PET_BATTLE_CLOSE")
	characterChangeFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	characterChangeFrame:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	characterChangeFrame:UnregisterEvent("TRAIT_CONFIG_UPDATED")
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


function TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, lowerCaseClass)
	local className
	if classId ~= nil then
		className = select(2, GetClassInfo(classId))
	else
		className = "Global"
	end

	local specName = TRB.Functions.Character:GetSpecializationName(className, specId)
	if specName == nil then
		specName = ""
	end

	if lowerCaseClass then
		return string.lower(className), specName
	else
		return className, specName
	end
end

function TRB.Functions.Character:GetSpecializationName(className, specId)
    className = string.upper(className) -- Should be uppercase anyway from UnitClass() but let's be certain
	if className == "DEATHKNIGHT" then
        if specId == 1 then
            return "blood"
        elseif specId == 2 then
            return "frost"
        elseif specId == 3 then
            return "unholy"
        end
    elseif className == "DEMONHUNTER" then
        if specId == 1 then
            return "havoc"
        elseif specId == 2 then
            return "vengeance"
		elseif specId == 3 then
			return "devourer"
        end
    elseif className == "DRUID" then
        if specId == 1 then
            return "balance"
        elseif specId == 2 then
            return "feral"
        elseif specId == 3 then
            return "guardian"
        elseif specId == 4 then
            return "restoration"
        end
    elseif className == "HUNTER" then
        if specId == 1 then
            return "beastMastery"
        elseif specId == 2 then
            return "marksmanship"
        elseif specId == 3 then
            return "survival"
        end
    elseif className == "EVOKER" then
        if specId == 1 then
            return "devastation"
        elseif specId == 2 then
            return "preservation"
        elseif specId == 3 then
            return "augmentation"
        end
    elseif className == "MAGE" then
        if specId == 1 then
            return "arcane"
        elseif specId == 2 then
            return "fire"
        elseif specId == 3 then
            return "frost"
        end
    elseif className == "MONK" then
        if specId == 1 then
            return "brewmaster"
        elseif specId == 2 then
            return "mistweaver"
        elseif specId == 3 then
            return "windwalker"
        end
    elseif className == "PALADIN" then
        if specId == 1 then
            return "holy"
        elseif specId == 2 then
            return "protection"
        elseif specId == 3 then
            return "retribution"
        end
    elseif className == "PRIEST" then
        if specId == 1 then
            return "discipline"
        elseif specId == 2 then
            return "holy"
        elseif specId == 3 then
            return "shadow"
        end
    elseif className == "ROGUE" then
        if specId == 1 then
            return "assassination"
        elseif specId == 2 then
            return "outlaw"
        elseif specId == 3 then
            return "subtlety"
        end
    elseif className == "SHAMAN" then
        if specId == 1 then
            return "elemental"
        elseif specId == 2 then
            return "enhancement"
        elseif specId == 3 then
            return "restoration"
        end
    elseif className == "WARLOCK" then
        if specId == 1 then
            return "affliction"
        elseif specId == 2 then
            return "demonology"
        elseif specId == 3 then
            return "destruction"
        end
    elseif className == "WARRIOR" then
        if specId == 1 then
            return "arms"
        elseif specId == 2 then
            return "fury"
        elseif specId == 3 then
            return "protection"
        end
    end
    return nil
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

function TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.isPvp = TRB.Functions.Talent:ArePvpTalentsActive()
end

function TRB.Functions.Character:UpdatePrimaryStatsSnapshot()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.attributes.strength, _, _, _ = UnitStat("player", 1)
	snapshotData.attributes.agility, _, _, _ = UnitStat("player", 2)
	snapshotData.attributes.stamina, _, _, _ = UnitStat("player", 3)
	snapshotData.attributes.intellect, _, _, _ = UnitStat("player", 4)

	snapshotData.attributes.cacheRefresh = true
	snapshotData.attributes.primaryRefresh = false
end

function TRB.Functions.Character:UpdateSecondaryStatsSnapshot()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	snapshotData.attributes.haste = UnitSpellHaste("player")
	snapshotData.attributes.crit = GetCritChance()
	snapshotData.attributes.mastery = GetMasteryEffect()
	snapshotData.attributes.versatilityOffensive = GetCombatRatingBonus(29)
	snapshotData.attributes.versatilityDefensive = GetCombatRatingBonus(31)

	snapshotData.attributes.hasteRating = GetCombatRating(20)
	snapshotData.attributes.critRating = GetCombatRating(11)
	snapshotData.attributes.masteryRating = GetCombatRating(26)
	snapshotData.attributes.versatilityRating = GetCombatRating(29)

	snapshotData.attributes.cacheRefresh = true
	snapshotData.attributes.secondaryRefresh = false
end

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
	TRB.Data.character.latency = TRB.Functions.Character:GetLatency()
	TRB.Data.character.inCombat = InCombatLockdown()
	TRB.Data.spellsData = cache.spellsData
	TRB.Data.talents = cache.talents
	TRB.Data.barTextVariables.icons = cache.barTextVariables.icons
	TRB.Data.barTextVariables.values = cache.barTextVariables.values
	TRB.Data.snapshotData = cache.snapshotData
	TRB.Data.snapshotData.attributes.isTracking = false
	TRB.Functions.Character:ResetCaches()
end

function TRB.Functions.Character:ResetColorCaches()
	TRB.Data.cache.colors.border = {}
	TRB.Data.cache.colors.bar = {}
	TRB.Data.cache.colors.backdrop = {}
end 

function TRB.Functions.Character:ResetCaches()
	TRB.Data.cache.barText = {}
	TRB.Data.cache.symbols = {}
	TRB.Data.cache.barTextTree = {}
	TRB.Data.cache.values.bar = {}
	TRB.Data.cache.values.resource = {}
	TRB.Data.cache.values.threshold = {}
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

---@diagnostic disable-next-line: missing-fields
	specCache.settings.displayText = {
		barText = spec.displayText.barText
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
		healthBar = spec.colors.healthBar,
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

	if s.healthBarColors then
		specCache.settings.colors.healthBar.border = core.colors.healthBar.border
		specCache.settings.colors.healthBar.background = core.colors.healthBar.background
		specCache.settings.colors.healthBar.high = core.colors.healthBar.high
		specCache.settings.colors.healthBar.medium = core.colors.healthBar.medium
		specCache.settings.colors.healthBar.low = core.colors.healthBar.low
		specCache.settings.colors.healthBar.type = core.colors.healthBar.type
	else
		specCache.settings.colors.healthBar.border = spec.colors.healthBar.border
		specCache.settings.colors.healthBar.background = spec.colors.healthBar.background
		specCache.settings.colors.healthBar.high = spec.colors.healthBar.high
		specCache.settings.colors.healthBar.medium = spec.colors.healthBar.medium
		specCache.settings.colors.healthBar.low = spec.colors.healthBar.low
		specCache.settings.colors.healthBar.type = spec.colors.healthBar.type
	end

	if spec.thresholds ~= nil then
	---@diagnostic disable-next-line: missing-fields
		specCache.settings.thresholds = {
			specProperties = spec.thresholds.specProperties,
			thresholdDictionary = {}
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
	else
		specCache.settings.thresholds = {
			specProperties = {},
			properties = core.thresholds.properties,
			icons = core.thresholds.icons,
			thresholdDictionary = {}
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
				-- Deep copy the table (visibility + smooth)
				specCache.settings.displayBar[k] = {}
				for k2, v2 in pairs(v) do
					specCache.settings.displayBar[k][k2] = v2
				end
				-- When using global displayBar, both visibility AND smooth come from global
			else
				specCache.settings.displayBar[k] = v
			end
		end
		
		-- Override with spec-specific custom bar visibility settings
		-- These are always spec-specific (mana, stagger, defensives, etc.)
		if spec.displayBar and spec.displayBar.mana ~= nil then
			specCache.settings.displayBar.mana = spec.displayBar.mana
		end
		if spec.displayBar and spec.displayBar.stagger ~= nil then
			specCache.settings.displayBar.stagger = spec.displayBar.stagger
		end
		if spec.displayBar and spec.displayBar.defensives ~= nil then
			specCache.settings.displayBar.defensives = spec.displayBar.defensives
		end
		-- Also carry over non-global keys that don't exist in core
		if spec.displayBar then
			if spec.displayBar.enableFormSwitching ~= nil then
				specCache.settings.displayBar.enableFormSwitching = spec.displayBar.enableFormSwitching
			end
		end
	else
		specCache.settings.displayBar = spec.displayBar
	end

	--NYI
	specCache.settings.audio = spec.audio
	specCache.settings.maxResource = spec.maxResource

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

---Ensure that default spec settings exist in TRB.Data.settings for the given class.
---If any spec in the class has empty settings (no .bar field), loads defaults from the
---class's options module and merges them with any existing saved values.
---@param className string Lowercase class name (e.g., "warrior")
---@return boolean success Whether settings were successfully ensured
function TRB.Functions.Character:EnsureSpecSettings(className)
	local settings = TRB.Data.settings
	if not settings or not settings[className] then
		return false
	end

	-- Check if defaults have already been loaded by testing a sentinel field (.bar)
	-- on any spec in this class. If all have .bar, defaults are loaded.
	local needsDefaults = false
	for _, specSettings in pairs(settings[className]) do
		if type(specSettings) == "table" and specSettings.bar == nil then
			needsDefaults = true
			break
		end
	end

	if not needsDefaults then
		return true
	end

	local optionsKey = CLASS_OPTIONS_KEY[className]
	if not optionsKey or not TRB.Options[optionsKey] or not TRB.Options[optionsKey].LoadDefaultSettings then
		return false
	end

	-- Load full defaults for this class (returns a complete settings table; we only use the class portion)
	local classDefaults = TRB.Options[optionsKey].LoadDefaultSettings(true)
	if not classDefaults or not classDefaults[className] then
		return false
	end

	-- Merge class-specific defaults into current settings.
	-- Table:Merge(original, incoming) gives incoming priority, so defaults are
	-- the base and any existing saved settings overlay on top.
	for specName, specDefaults in pairs(classDefaults[className]) do
		if type(specDefaults) == "table" then
			settings[className][specName] = TRB.Functions.Table:Merge(specDefaults, settings[className][specName] or {})
		end
	end

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

function TRB.Functions.Character:GetCurrentGCDTime(floor)
	if floor == nil then
		floor = false
	end

	local haste = UnitSpellHaste("player") / 100

	local gcd = 1.5 / (1 + haste)

	if not floor and gcd < 0.75 then
		gcd = 0.75
	end

	return gcd
end

function TRB.Functions.Character:ResetCastingSnapshotData()
	---@type TRB.Classes.SnapshotCasting
	local casting = TRB.Data.snapshotData.casting
	casting:Reset()
end

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
					local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetResourceFrame())
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

function TRB.Functions.Character:EventRegistration()
	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.specSupported then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

		if TRB.Data.resource ~= nil then
			_, TRB.Data.resourceToken = UnitPowerType("player")
		end
		if TRB.Data.resource2 ~= nil then
			snapshotData.attributes.resource2 = 0
			if TRB.Data.resource2 ~= "SPELL" and TRB.Data.resource2 ~= "CUSTOM" then
				if TRB.Data.resource2 == 4 then
					TRB.Data.resource2Token = "COMBO_POINTS"
				elseif TRB.Data.resource2 == 5 then
					TRB.Data.resource2Token = "RUNES"
				elseif TRB.Data.resource2 == 7 then
					TRB.Data.resource2Token = "SOUL_SHARDS"
				elseif TRB.Data.resource2 == 9 then
					TRB.Data.resource2Token = "HOLY_POWER"
				elseif TRB.Data.resource2 == 12 then
					TRB.Data.resource2Token = "CHI"
				elseif TRB.Data.resource2 == 16 then
					TRB.Data.resource2Token = "ARCANE_CHARGES"
				elseif TRB.Data.resource2 == 19 then
					TRB.Data.resource2Token = "ESSENCE"
				end
			end
		end
		UpdateResourceValues()
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

				-- Register the primary bar with Edit Mode (required for CDM anchoring)
				if barGroups.primary and TRB.Functions.EditMode then
					TRB.Functions.EditMode:RegisterPrimaryBar(barGroups.primary:GetContainerFrame())
				end

				TRB.Functions.BarText:CreateBarTextFrames()
				TRB.Functions.BarText:Hide(specSettings.settings)
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
		end
	end

	TRB.Functions.Bar:HideResourceBar()
end