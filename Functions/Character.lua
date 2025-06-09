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

TRB.Details.addonData.libs.LibAdvFlight.RegisterCallback(TRB.Details.addonData.libs.LibAdvFlight.Events.ADV_FLYING_ENABLED, OnAdvFlyEnabled);
TRB.Details.addonData.libs.LibAdvFlight.RegisterCallback(TRB.Details.addonData.libs.LibAdvFlight.Events.ADV_FLYING_DISABLED, OnAdvFlyDisabled);

--TODO: Move this somewhere else.
--This is a fallback method for the Advanced Flight checking on a class that doesn't have support. Hide everything bar related.
function TRB.Functions.Class:HideResourceBar(force)
	TRB.Frames.barContainerFrame:Hide()
end

--TODO: Move this somewhere else.
--This is a fallback method for the Advanced Flight checking on a class that doesn't have support. Hide everything bar related.
function TRB.Functions.Class:EventRegistration()
	TRB.Data.specSupported = false
	TRB.Details.addonData.registered = false

	TRB.Functions.Bar:HideResourceBar()
end

local function UpdateResourceValues()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	snapshotData.attributes.resource = UnitPower("player", TRB.Data.resource, true)
	if TRB.Data.resource2 ~= nil then
		if TRB.Data.resource2 == "SPELL" and TRB.Data.resource2Id ~= nil then
			local resourceBuff = C_UnitAuras.GetPlayerAuraBySpellID(TRB.Data.resource2Id)
			if resourceBuff ~= nil then
				snapshotData.attributes.resource2 = resourceBuff.applications or 0
			else
				snapshotData.attributes.resource2 = 0
			end			
		elseif TRB.Data.resource2 == "CUSTOM" then
			-- Do nothing
		else
			snapshotData.attributes.resource2 = UnitPower("player", TRB.Data.resource2, true)
		end
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
		TRB.Functions.Character:UpdateStatsSnapshot()
	end
end

local characterChangeFrame = CreateFrame("Frame")
characterChangeFrame:SetScript("OnEvent", CharacterChange)

function TRB.Functions.Character:EnableCharacterChange()
	characterChangeFrame:RegisterEvent("UNIT_POWER_UPDATE")
	characterChangeFrame:RegisterEvent("UNIT_POWER_FREQUENT")
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

function TRB.Functions.Character:UpdateSnapshot()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	
	if target == nil and targetData.currentTargetGuid ~= nil then
		targetData:InitializeTarget(targetData.currentTargetGuid, UnitIsFriend("target", "player"))
		target = targetData.targets[targetData.currentTargetGuid]
	end
	
	if target ~= nil then
		target:UpdateAllSpellTracking(currentTime)
	end

	if 1 == 0 then
		local startTime = debugprofilestop()
		snapshotData.attributes.resource = UnitPower("player", TRB.Data.resource, true)

		if TRB.Data.resource2 ~= nil then
			if TRB.Data.resource2 == "SPELL" and TRB.Data.resource2Id ~= nil then
				local resourceBuff = C_UnitAuras.GetPlayerAuraBySpellID(TRB.Data.resource2Id)
				if resourceBuff ~= nil then
					snapshotData.attributes.resource2 = resourceBuff.applications or 0
				else
					snapshotData.attributes.resource2 = 0
				end			
			elseif TRB.Data.resource2 == "CUSTOM" then
				-- Do nothing
			else
				snapshotData.attributes.resource2 = UnitPower("player", TRB.Data.resource2, true)
			end
		end
		local endTime = debugprofilestop()
		print(endTime-startTime)
	end
end

function TRB.Functions.Character:UpdateStatsSnapshot()
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
	
	snapshotData.attributes.strength, _, _, _ = UnitStat("player", 1)
	snapshotData.attributes.agility, _, _, _ = UnitStat("player", 2)
	snapshotData.attributes.stamina, _, _, _ = UnitStat("player", 3)
	snapshotData.attributes.intellect, _, _, _ = UnitStat("player", 4)

	snapshotData.attributes.cacheRefresh = true
	snapshotData.attributes.attributeRefresh = false
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
---| '"demonhunter"' # Demon Hunter
---| '"druid"' # Druid 
---| '"evoker"' # Evoker
---| '"hunter"' # Hunter
---| '"monk"' # Monk
---| '"paladin' # Paladin
---| '"priest"' # Priest
---| '"rogue"' # Rogue
---| '"shaman"' # Shaman
---| '"warlock' # Warlock
---| '"warrior"' # Warrior
---@param specName string
---| '"havoc"' # Havoc (Demon Hunter)
---| '"vengeance"' # Vengeance (Demon Hunter)
---| '"balance"' # Balance (Druid)
---| '"feral"' # Feral (Druid)
---| '"restoration"' # Restoration (Druid, Shaman)
---| '"devastation"' # Devastation (Evoker)
---| '"preservation"' # Preservation (Evoker)
---| '"augmentation"' # Augmentation (Evoker)
---| '"beastMastery"' # Beast Mastery (Hunter)
---| '"marksmanship"' # Marksmanship (Hunter)
---| '"survival"' # Survival (Hunter)
---| '"discipline"' # Discipline (Priest)
---| '"holy"' # Holy (Paladin, Priest)
---| '"shadow"' # Shadow (Priest)
---| '"assassination"' # Assassination (Rogue)
---| '"outlaw"' # Outlaw (Rogue)
---| '"subtlety"' # Subtlety (Rogue)
---| '"elemental"' # Elemental (Shaman)
---| '"enhancement"' # Enhancement (Shaman)
---| '"affliction"' # Affliction (Warlock)
---| '"arms"' # Arms (Warrior)
---| '"fury"' # Fury (Warrior)
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
		endCap = {}
	}

	if s.textColors then
		specCache.settings.colors.text.current = core.colors.text.current
		specCache.settings.colors.text.casting = core.colors.text.casting
		specCache.settings.colors.text.spending = core.colors.text.spending
		specCache.settings.colors.text.passive = core.colors.text.passive
		specCache.settings.colors.text.overcap = core.colors.text.overcap
		specCache.settings.colors.text.overThreshold = core.colors.text.overThreshold
	else
		specCache.settings.colors.text.current = spec.colors.text.current
		specCache.settings.colors.text.casting = spec.colors.text.casting
		specCache.settings.colors.text.spending = spec.colors.text.spending
		specCache.settings.colors.text.passive = spec.colors.text.passive
		specCache.settings.colors.text.overcap = spec.colors.text.overcap
		specCache.settings.colors.text.overThreshold = spec.colors.text.overThreshold
	end

	if s.dotColors then
		specCache.settings.colors.text.dots.up = spec.colors.text.dots.up
		specCache.settings.colors.text.dots.down = spec.colors.text.dots.down
		specCache.settings.colors.text.dots.pandemic = spec.colors.text.dots.pandemic
		specCache.settings.colors.text.dots.options = spec.colors.text.dots.options
		if className == "druid" and specName == "feral" then -- Kitty is a special snowflake
			-- Use spec values			
			specCache.settings.colors.text.dots.same = spec.colors.text.dots.same
			specCache.settings.colors.text.dots.worse = spec.colors.text.dots.worse
			specCache.settings.colors.text.dots.better = spec.colors.text.dots.better
		end
	else
		specCache.settings.colors.text.dots = spec.colors.text.dots
	end

---@diagnostic disable-next-line: missing-fields
	specCache.settings.colors.threshold = {}
	for key, _ in pairs(spec.colors.threshold) do
		specCache.settings.colors.threshold[key] = spec.colors.threshold[key]
	end

	if s.thresholdColors then
		if isHealer then
			specCache.settings.colors.threshold.over = core.colors.thresholdHealers.over
			specCache.settings.colors.threshold.unusable = core.colors.thresholdHealers.unusable
			specCache.settings.colors.threshold.passive = core.colors.thresholdHealers.passive
		else
			specCache.settings.colors.threshold.over = core.colors.threshold.over
			specCache.settings.colors.threshold.under = core.colors.threshold.under
			specCache.settings.colors.threshold.unusable = core.colors.threshold.unusable
			specCache.settings.colors.threshold.special = core.colors.threshold.special
			specCache.settings.colors.threshold.outOfRange = core.colors.threshold.outOfRange
		end
	end
	
	if s.endCap then
		specCache.settings.colors.endCap.base = core.colors.endCap.base
	else
		specCache.settings.colors.endCap.base = spec.colors.endCap.base
	end

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

	for key, _ in pairs(spec.thresholds.thresholdDictionary) do
		specCache.settings.thresholds.thresholdDictionary[key] = spec.thresholds.thresholdDictionary[key]
	end
	if isHealer then
		if s.thresholdPotions then
			specCache.settings.thresholds.potionCooldown = core.thresholds.potionCooldown
		else
			specCache.settings.thresholds.potionCooldown = spec.thresholds.potionCooldown
		end

		if s.thresholdHealers then
			for key, _ in pairs(core.thresholds.thresholdDictionaryHealers) do
				specCache.settings.thresholds.thresholdDictionary[key] = core.thresholds.thresholdDictionaryHealers[key]
			end
		end
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

	--NYI	
	specCache.settings.displayBar = spec.displayBar
	specCache.settings.audio = spec.audio
end

function TRB.Functions.Character:IsComboPointUser()
	if 	(TRB.Data.character.classId == 2) or -- Paladin
		(TRB.Data.character.classId == 4) or -- Rogue
		(TRB.Data.character.classId == 5 and (TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2)) or -- Discipline or Holy Priest
		(TRB.Data.character.classId == 7 and TRB.Data.character.specId == 2) or -- Enhancement Shaman
		(TRB.Data.character.classId == 9 and TRB.Data.character.specId == 1) or -- Affliction Warlock
		(TRB.Data.character.classId == 10 and TRB.Data.character.specId == 3) or -- Windwalker Monk
		(TRB.Data.character.classId == 11 and TRB.Data.character.specId == 2) or -- Feral Druid
		(TRB.Data.character.classId == 12 and TRB.Data.character.specId == 2) or -- Vengeance Demon Hunter
		(TRB.Data.character.classId == 13) -- Evoker
		then
		return true
	end
	return false
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
	local barContainerFrame = TRB.Frames.barContainerFrame
	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame

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
				elseif TRB.Data.resource2 == 19 then
					TRB.Data.resource2Token = "ESSENCE"
				end
			end
		end
		UpdateResourceValues()
		TRB.Functions.Class:CheckCharacter()
		barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Details.addonData.registered = true
		TRB.Functions.Aura:EnableUnitAura()
		TRB.Functions.Character:EnableCharacterChange()
		TRB.Functions.Character:EnableSpellRangeCheckUpdate()
		targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
	else
		targetsTimerFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Functions.Aura:DisableUnitAura()
		TRB.Functions.Character:DisableCharacterChange()
		TRB.Functions.Character:DisableSpellRangeCheckUpdate()
		TRB.Details.addonData.registered = false
		barContainerFrame:Hide()
	end

	TRB.Functions.Bar:HideResourceBar()
end