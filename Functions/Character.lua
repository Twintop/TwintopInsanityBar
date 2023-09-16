---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Character = {}


function TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.guid = UnitGUID("player")
---@diagnostic disable-next-line: missing-parameter
	TRB.Data.character.specGroup = GetActiveSpecGroup()
	TRB.Data.character.isPvp = TRB.Functions.Talent:ArePvpTalentsActive()
	TRB.Data.character.inPetBattle = C_PetBattles.IsInBattle()
	TRB.Data.character.onTaxi = UnitOnTaxi("player")

	TRB.Data.barTextCache = {}
	TRB.Functions.Spell:FillSpellData()
end

function TRB.Functions.Character:UpdateSnapshot()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]

	if target ~= nil then
		target:UpdateAllSpellTracking(currentTime)
	end

	snapshotData.attributes.resource = UnitPower("player", TRB.Data.resource, true)

	if TRB.Data.resource2 ~= nil then
		if TRB.Data.resource2 == "CUSTOM" and TRB.Data.resource2Id ~= nil then
			local _, _, stacks, _, duration, endTime, _, _, _, spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.resource2Id)
			snapshotData.attributes.resource2 = stacks or 0
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

function TRB.Functions.Character:LoadFromSpecializationCache(cache)
	Global_TwintopResourceBar = cache.Global_TwintopResourceBar

	TRB.Data.character = cache.character
	TRB.Data.character.specGroup = GetActiveSpecGroup()
	TRB.Data.spells = cache.spells
	TRB.Data.talents = cache.talents
	TRB.Data.barTextVariables.icons = cache.barTextVariables.icons
	TRB.Data.barTextVariables.values = cache.barTextVariables.values
	TRB.Data.snapshotData = cache.snapshotData

end

function TRB.Functions.Character:FillSpecializationCacheSettings(settings, cache, className, specName)
	local specCache = cache[specName]
	local core = settings.core
	local s = core.globalSettings[className][specName]
	local enabled = (core.globalSettings.globalEnable or s.specEnable) and specCache.settings ~= nil
	local spec = settings[className][specName]

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

	if 	(classIndexId == 4) or -- Rogue
		(classIndexId == 7 and specId == 2) or -- Enhancement Shaman
		(classIndexId == 10 and specId == 3) or -- Windwalker Monk
		(classIndexId == 11 and specId == 2) or -- Feral Druid
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