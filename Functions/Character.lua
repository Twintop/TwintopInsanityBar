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
	if TRB.Data.resource2 ~= nil then
		if TRB.Data.resource2 == "SPELL" and TRB.Data.resource2Id ~= nil then
			if TRB.Details.addonData.build ~= "64914" then
				local resourceBuff = C_UnitAuras.GetPlayerAuraBySpellID(TRB.Data.resource2Id)
				if resourceBuff ~= nil then
					snapshotData.attributes.resource2 = resourceBuff.applications or 0
				else
					snapshotData.attributes.resource2 = 0
				end
			end
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
		local specCache = TRB.Data.specCache[TRB.Data.character.specName]
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

---Handles some change with the character's status
---@param self any
---@param event string
---@param ... unknown
local function CharacterChange(self, event, ...)
	if event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT" then
		local unitTarget, powerType = ...
		if unitTarget == "player" and (powerType == TRB.Data.resourceToken or powerType == TRB.Data.resource2Token) then
			UpdateResourceValues()
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

function TRB.Functions.Character:ResetCaches()
	TRB.Data.cache.barText = {}
	TRB.Data.cache.symbols = {}
	TRB.Data.cache.barTextTree = {}
	TRB.Data.cache.colors.border = {}
	TRB.Data.cache.colors.bar = {}
	TRB.Data.cache.colors.backdrop = {}
	TRB.Data.cache.values.bar = {}
	TRB.Data.cache.values.resource = {}
	TRB.Data.cache.values.threshold = {}
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
	local specCache = TRB.Data.specCache[specName] --[[@as TRB.Classes.SpecCache]]
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
		-- manaBar is spec-specific (only for Shadow Priest, Balance Druid, Elemental Shaman), so always use spec colors
		specCache.settings.colors.text.manaBar = spec.colors.text.manaBar
	else
		specCache.settings.colors.text.current = spec.colors.text.current
		specCache.settings.colors.text.casting = spec.colors.text.casting
		specCache.settings.colors.text.spending = spec.colors.text.spending
		specCache.settings.colors.text.passive = spec.colors.text.passive
		specCache.settings.colors.text.overThreshold = spec.colors.text.overThreshold
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
		specCache.settings.displayBar = core.displayBar
	else
		specCache.settings.displayBar = spec.displayBar
	end

	-- Mana bar visibility is always spec-specific (not available in core settings)
	-- Ensure it's propagated from spec even when using global displayBar settings
	if spec.displayBar and spec.displayBar.mana ~= nil then
		specCache.settings.displayBar.mana = spec.displayBar.mana
	end

	-- Custom bar visibility (stagger, defensives, etc.) is always spec-specific
	-- Ensure it's propagated from spec even when using global displayBar settings
	if spec.displayBar and spec.displayBar.stagger ~= nil then
		specCache.settings.displayBar.stagger = spec.displayBar.stagger
	end
	if spec.displayBar and spec.displayBar.defensives ~= nil then
		specCache.settings.displayBar.defensives = spec.displayBar.defensives
	end

	--NYI
	specCache.settings.audio = spec.audio
	specCache.settings.maxResource = spec.maxResource

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
		end
	end

	TRB.Functions.Bar:HideResourceBar()
end