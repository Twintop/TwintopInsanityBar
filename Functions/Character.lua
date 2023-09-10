---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Character = {}


function TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.guid = UnitGUID("player")
---@diagnostic disable-next-line: missing-parameter
	TRB.Data.character.specGroup = GetActiveSpecGroup()
	TRB.Data.character.isPvp = TRB.Functions.Talent:ArePvpTalentsActive()

	TRB.Data.barTextCache = {}
	TRB.Functions.Spell:FillSpellData()
end

function TRB.Functions.Character:UpdateSnapshot()
	local snapshot
	local target

	local _, _, classIndexId = UnitClass("player")
	if classIndexId == 1 or classIndexId == 5 or classIndexId == 7 or classIndexId == 10 or classIndexId == 11 or classIndexId == 12 or classIndexId == 13 then --Only do this if we're on a Warrior, Priest, Shaman, Monk, Druid, Demon Hunter, or Evoker!
		snapshot = TRB.Data.snapshotData.attributes
		---@type TRB.Classes.Target
		target = TRB.Data.snapshotData.targetData.targets[TRB.Data.snapshotData.targetData.currentTargetGuid]
	else
		snapshot = TRB.Data.snapshot
		---@type TRB.Classes.Target
		target = snapshot.targetData.targets[snapshot.targetData.currentTargetGuid]
	end

	if target ~= nil then
		target:UpdateAllSpellTracking(currentTime)
	end

	snapshot.resource = UnitPower("player", TRB.Data.resource, true)

	if TRB.Data.resource2 ~= nil then
		if TRB.Data.resource2 == "CUSTOM" and TRB.Data.resource2Id ~= nil then
			local _, _, stacks, _, duration, endTime, _, _, _, spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.resource2Id)
			snapshot.resource2 = stacks or 0
		else
			snapshot.resource2 = UnitPower("player", TRB.Data.resource2, true)
		end
	end

	snapshot.haste = UnitSpellHaste("player")
	snapshot.crit = GetCritChance()
	snapshot.mastery = GetMasteryEffect()
	snapshot.versatilityOffensive = GetCombatRatingBonus(29)
	snapshot.versatilityDefensive = GetCombatRatingBonus(31)

	snapshot.hasteRating = GetCombatRating(20)
	snapshot.critRating = GetCombatRating(11)
	snapshot.masteryRating = GetCombatRating(26)
	snapshot.versatilityRating = GetCombatRating(29)
	
	---@diagnostic disable-next-line: assign-type-mismatch, cast-local-type
	snapshot.strength, _, _, _ = UnitStat("player", 1)
	---@diagnostic disable-next-line: assign-type-mismatch, cast-local-type
	snapshot.agility, _, _, _ = UnitStat("player", 2)
	---@diagnostic disable-next-line: assign-type-mismatch, cast-local-type
	snapshot.stamina, _, _, _ = UnitStat("player", 3)
	---@diagnostic disable-next-line: assign-type-mismatch, cast-local-type
	snapshot.intellect, _, _, _ = UnitStat("player", 4)
end

function TRB.Functions.Character:ResetSnapshotData()
	local _, _, classIndexId = UnitClass("player")
	if classIndexId == 1 or classIndexId == 5 or classIndexId == 7 or classIndexId == 10 or classIndexId == 11 or classIndexId == 12 or classIndexId == 13 then --Only do this if we're on a Warrior, Priest, Shaman, Monk, Druid, Demon Hunter, or Evoker!
		--TRB.Data.snapshotData = TRB.Classes.SnapshotData:New()
	else
		TRB.Data.snapshot = {
			resource = 0,
			haste = 0,
			crit = 0,
			mastery = 0,
			versatilityOffensive = 0,
			versatilityDefensive = 0,
			hasteRating = 0,
			critRating = 0,
			masteryRating = 0,
			versatilityRating = 0,
			intellect = 0,
			strength = 0,
			agility = 0,
			stamina = 0,
			isTracking = false,
			casting = {
				spellId = nil,
				startTime = nil,
				endTime = nil,
				resourceRaw = 0,
				resourceFinal = 0,
				icon = ""
			},
			targetData = {},
			audio = {}
		}
	end
end

function TRB.Functions.Character:LoadFromSpecializationCache(cache)
	Global_TwintopResourceBar = cache.Global_TwintopResourceBar

	TRB.Data.character = cache.character
	TRB.Data.spells = cache.spells
	TRB.Data.talents = cache.talents
	TRB.Data.barTextVariables.icons = cache.barTextVariables.icons
	TRB.Data.barTextVariables.values = cache.barTextVariables.values

	TRB.Functions.Character:ResetSnapshotData()

	local _, _, classIndexId = UnitClass("player")
	if classIndexId == 1 or classIndexId == 5 or classIndexId == 7 or classIndexId == 10 or classIndexId == 11 or classIndexId == 12 or classIndexId == 13 then --Only do this if we're on a Warrior, Priest, Shaman, Monk, Druid, Demon Hunter, or Evoker!
		TRB.Data.snapshotData = cache.snapshotData
	else
		TRB.Data.snapshot = TRB.Functions.Table:Merge(TRB.Data.snapshot, cache.snapshot)
	end

---@diagnostic disable-next-line: missing-parameter
	TRB.Data.character.specGroup = GetActiveSpecGroup()
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
	local _, _, classIndexId = UnitClass("player")
	if classIndexId == 1 or classIndexId == 5 or classIndexId == 7 or classIndexId == 10 or classIndexId == 11 or classIndexId == 12 or classIndexId == 13 then --Only do this if we're on a Warrior, Priest, Shaman, Monk, Druid, Demon Hunter, or Evoker!
		---@type TRB.Classes.SnapshotCasting
		local casting = TRB.Data.snapshotData.casting
		casting:Reset()
	else
		TRB.Data.snapshot.casting.spellId = nil
		TRB.Data.snapshot.casting.startTime = nil
		TRB.Data.snapshot.casting.endTime = nil
		TRB.Data.snapshot.casting.resourceRaw = 0
		TRB.Data.snapshot.casting.resourceFinal = 0
		TRB.Data.snapshot.casting.icon = ""
		TRB.Data.snapshot.casting.spellKey = nil
	end
end

function TRB.Functions.Character:GetLatency()
	--local down, up, lagHome, lagWorld = GetNetStats()
	local _, _, _, lagWorld = GetNetStats()
	local latency = lagWorld / 1000
	return latency
end