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


function TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.guid = UnitGUID("player")
	TRB.Data.character.isPvp = TRB.Functions.Talent:ArePvpTalentsActive()
	TRB.Data.character.inPetBattle = C_PetBattles.IsInBattle()
	TRB.Data.character.onTaxi = UnitOnTaxi("player")
	TRB.Data.character.advancedFlight = TRB.Details.addonData.libs.LibAdvFlight.IsAdvFlyEnabled()

	--TRB.Data.barTextCache = {}
	--TRB.Functions.Spell:FillSpellData()
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
end

---Loads data from the specialization cache in to the main TRB.Data table
---@param cache TRB.Classes.SpecCache
function TRB.Functions.Character:LoadFromSpecializationCache(cache)
	Global_TwintopResourceBar = cache.Global_TwintopResourceBar

	TRB.Data.character = cache.character
	TRB.Data.spellsData = cache.spellsData
	TRB.Data.talents = cache.talents
	TRB.Data.barTextVariables.icons = cache.barTextVariables.icons
	TRB.Data.barTextVariables.values = cache.barTextVariables.values
	TRB.Data.snapshotData = cache.snapshotData
	TRB.Data.barTextCache = {}
end

---Fills the specialization cache with a combination of global and spec specific settings
---@param settings table
---@param cache table<string, TRB.Classes.SharedSpecSetting> # The full cache of all specs for the current class
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
---| '"arms"' # Arms (Warrior)
---| '"fury"' # Fury (Warrior)
function TRB.Functions.Character:FillSpecializationCacheSettings(settings, cache, className, specName)
	local specCache = cache[specName]
	local core = settings.core
	local s = core.globalSettings[className][specName] --[[@as TRB.Classes.GlobalSpecSetting]]
	local enabled = (core.globalSettings.globalEnable or s.specEnable) and specCache.settings ~= nil
	local spec = settings[className][specName] --[[@as TRB.Classes.GlobalSpecSetting]]

	if enabled and s.bar then
		specCache.settings.bar = core.bar
		--print("bar!")
	else
		--print("no bar :(")
		specCache.settings.bar = spec.bar
	end

	if enabled and s.comboPoints then
		specCache.settings.comboPoints = core.comboPoints
	else
		specCache.settings.comboPoints = spec.comboPoints
	end

	if enabled and s.displayBar then
		specCache.settings.displayBar = core.displayBar
	else
		specCache.settings.displayBar = spec.displayBar
	end

	if enabled and s.font then
		specCache.settings.displayText = core.font
	else
		specCache.settings.displayText = spec.displayText
	end

	if enabled and s.textures then
		specCache.settings.textures = core.textures
	else
		specCache.settings.textures = spec.textures
	end

	if enabled and s.thresholds then
		specCache.settings.thresholds = core.thresholds
	else
		specCache.settings.thresholds = spec.thresholds
	end

	specCache.settings.colors = spec.colors
end

function TRB.Functions.Character:IsComboPointUser()
	local _, _, classIndexId = UnitClass("player")
	local specId = GetSpecialization()

	if 	(classIndexId == 2) or -- Paladin
		(classIndexId == 4) or -- Rogue
		(classIndexId == 5 and (specId == 1 or specId == 2)) or -- Discipline or Holy Priest
		(classIndexId == 7 and specId == 2) or -- Enhancement Shaman
		(classIndexId == 10 and specId == 3) or -- Windwalker Monk
		(classIndexId == 11 and specId == 2) or -- Feral Druid
		(classIndexId == 12 and specId == 2) or -- Vengeance Demon Hunter
		(classIndexId == 13) -- Evoker
		then
		return true
	end
	return false
end


function TRB.Functions.Character:GetCurrentGCDLockRemaining()
---@diagnostic disable-next-line: redundant-parameter
	local startTime, duration, _ = GetSpellCooldown(61304)
	return (startTime + duration - GetTime())
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