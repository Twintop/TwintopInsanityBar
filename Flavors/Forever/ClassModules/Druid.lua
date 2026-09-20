local _, TRB = ...
if TRB.Data.character.classId ~= 11 then -- Only do this if we are on a Druid!
	return
end

-- Druid runtime (World of Warcraft: Forever). Mana is the primary bar; Rage, Energy, and Combo Points are their own
-- bars, and the shapeshift form decides which of them show.

local lookupChanged = TRB.Functions.BarText.LookupChanged
local Bar = TRB.Functions.Bar
local Color = TRB.Functions.Color
local Character = TRB.Functions.Character
local Threshold = TRB.Functions.Threshold

local className, specName, compositeKey, specId, classId = "druid", "general", "druid_general", 1, 11
local frameLevels = TRB.Data.constants.frameLevels

TRB.Functions.Class = TRB.Functions.Class or {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = { [compositeKey] = TRB.Classes.SpecCache:New() }
TRB.Data.specCache = specCache
---@type TRB.Classes.Talents?
local talents = nil

Global_TwintopResourceBar = {}

-- The two form resource bars and the keys their values, indicators, and thresholds use.
local formBars = {
	{ key = "rage", powerType = Enum.PowerType.Rage, token = "RAGE", indicator = "rageBar", variable = "$rage" },
	{ key = "energy", powerType = Enum.PowerType.Energy, token = "ENERGY", indicator = "energyBar", variable = "$energy" },
}

-- Form ids confirmed on the beta: Bear 5, humanoid nil. Cat, Travel, Aquatic, and Moonkin follow retail's numbering.
---@param formId integer?
---@return string
local function GetShapeshiftFormName(formId)
	if formId == 1 then
		return "cat"
	elseif formId == 5 or formId == 8 then
		return "bear"
	elseif formId == 3 then
		return "travel"
	elseif formId == 4 then
		return "aquatic"
	elseif formId ~= nil and formId >= 31 and formId <= 35 then
		return "moonkin"
	end
	return "humanoid"
end

local function FillSpecializationCache()
	Global_TwintopResourceBar = { resource = { resource = 0, casting = 0 } }
	local cache = specCache[compositeKey]
	cache.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = classId,
		specId = specId,
		maxResource = 100,
		maxResource2 = 5,
		effects = {},
		items = {},
	}
	cache.spellsData.spells = TRB.Classes.Druid.GeneralSpells:New()
	local spells = cache.spellsData.spells --[[@as TRB.Classes.Druid.GeneralSpells]]
	local snapshots = cache.snapshotData.snapshots
	cache.snapshotData.attributes.resource2 = 0
	for _, spell in ipairs({ spells.bash, spells.challengingRoar, spells.frenziedRegeneration, spells.feralCharge, spells.cower }) do
		snapshots[spell.id] = TRB.Classes.Snapshot:New(spell)
	end
	cache.barTextVariables = { icons = {}, values = {} }
end

local function Setup()
	Character:FillSpecializationCacheSettings(className, specName, false)
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= compositeKey then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Druid.BarGroupsFactory:CreateForSpec(specId)
	end
end

local function FillSpellData()
	Setup()
	local cache = specCache[compositeKey]
	cache.spellsData:FillSpellData()
	TRB.Classes.Druid.GeneralSpells.FillBarTextVariables(cache)
end

---The dimension block a bar's threshold lines size against.
---@param settings table
---@param barKey string
---@return table?
local function GetBarSettings(settings, barKey)
	if barKey == "primary" then
		return settings.bar
	end
	return settings.bars and settings.bars[barKey]
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if not TRB.Data.specSupported or barGroups == nil then
		return
	end

	if barGroups.primary then
		local primaryNode = barGroups.primary:GetNode(1)
		if primaryNode then
			primaryNode:ClearThresholds()
		end
		Bar:ConstructBarGroups(settings, barGroups)
	end

	-- Threshold lines are created on demand by the update loop, one per threshold spell of the bar.
	for _, formBar in ipairs(formBars) do
		local group = barGroups[formBar.key]
		local node = group and group:GetNode(1)
		if node then
			node:ClearThresholds()
		end
	end

	if barGroups.secondary then
		local maxNodes = TRB.Data.character.maxResource2 or 5
		barGroups.secondary:RebuildNodes(maxNodes, settings)
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

---Refreshes lookup/lookupLogic: Mana on the primary variables, the form powers, and Combo Points.
local function RefreshLookupData()
	local sharedSettings = specCache[compositeKey].settings
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]

	local prevState = TRB.Data.prevLookupState or {}
	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local activeVars = TRB.Data.activeVariables

	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then
		local normalizedResource = snapshotData.attributes.resourceModified
		local currentColor = sharedSettings.colors.text.current.color
		local castingColor = sharedSettings.colors.text.casting.color
		local castingResource = snapshotData.casting.resourceFinal
		local resourcePercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$resource"] = normalizedResource
		lookupLogic["$mana"] = normalizedResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourcePercent"] = resourcePercent
		lookupLogic["$manaPercent"] = resourcePercent
		lookupLogic["$casting"] = castingResource

		local resourceFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", resourceFormatted, currentColor) then
			local formatted = string.format("|c%s%s|r", currentColor, resourceFormatted)
			lookup["$mana"] = formatted
			lookup["$resource"] = formatted
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentColor) then
			local formatted = string.format("|c%s%s|r", currentColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = formatted
			lookup["$resourceMax"] = formatted
		end
		local percentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", percentFormatted, currentColor) then
			local formatted = string.format("|c%s%s|r", currentColor, percentFormatted)
			lookup["$manaPercent"] = formatted
			lookup["$resourcePercent"] = formatted
		end
		if lookupChanged(prevState, "$casting", castingResource, castingColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingColor, TRB.Functions.String:ConvertToAbbreviatedNumber(castingResource))
		end
	end

	for _, formBar in ipairs(formBars) do
		local variable = formBar.variable
		if not activeVars or activeVars[variable] or activeVars[variable .. "Max"] then
			local token = formBar.token
			local currentColor = sharedSettings.colors.text[formBar.key].color
			-- Power events only mark the entry dirty; the value is re-read here at most once per tick.
			local additionalPower = snapshotData.formatted.additionalPower --[[@as table<string, table>?]]
			local power = additionalPower and additionalPower[token]
			if power == nil or power.dirty then
				Character:UpdateAdditionalPowerValues(token, 0)
				power = snapshotData.formatted.additionalPower[token] --[[@as table]]
			end
			lookupLogic[variable] = power.current
			lookupLogic[variable .. "Max"] = power.max
			if lookupChanged(prevState, variable, power.currentFormatted, currentColor) then
				lookup[variable] = string.format("|c%s%s|r", currentColor, power.currentFormatted)
			end
			if lookupChanged(prevState, variable .. "Max", power.maxFormatted, currentColor) then
				lookup[variable .. "Max"] = string.format("|c%s%s|r", currentColor, power.maxFormatted)
			end
		end
	end

	-- TEMPORARY: same secret Combo Points guard as UpdateResourceBar.
	if (not activeVars or activeVars["$comboPoints"] or activeVars["$comboPointsMax"]) and not issecretvalue(snapshotData.attributes.resource2) then
		local current = snapshotData.attributes.resource2 or 0
		local max = TRB.Data.character.maxResource2 or 5
		lookupLogic["$comboPoints"] = current
		lookupLogic["$comboPointsMax"] = max
		if lookupChanged(prevState, "$comboPoints", current) then
			lookup["$comboPoints"] = tostring(current)
		end
		if lookupChanged(prevState, "$comboPointsMax", max) then
			lookup["$comboPointsMax"] = tostring(max)
		end
	end

	if not activeVars or activeVars["$inStealth"] then
		lookupLogic["$inStealth"] = IsStealthed()
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
end

-- Reused per-tick scratch tables so UpdateResourceBar allocates nothing.
local scratch = { conditionMap = {}, barColors = {}, barColorMap = {}, formBarColors = { rage = {}, energy = {} }, comboPointColors = {}, formBarMax = {} }

---Draws one bar's spell threshold lines, creating them on demand.
---@param barKey string
---@param node TRB.Classes.BarNode
---@param specCacheSettings table
---@param maxResource number
local function UpdateBarThresholds(barKey, node, specCacheSettings, maxResource)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barSettings = GetBarSettings(specCacheSettings, barKey)
	local thresholds = node:GetThresholds()
	local nodeFrame = node:GetFrame()
	local isStealthed = IsStealthed()
	local thresholdId = 0

	for _, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
		if spell.barTarget == barKey then
			thresholdId = thresholdId + 1
			if thresholds[thresholdId] == nil then
				local thresholdFrame = CreateFrame("Frame", nil, nodeFrame)
				Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true, barSettings)
				node:RegisterThreshold(thresholdFrame)
				thresholds = node:GetThresholds()
			end
			local pairOffset = (thresholdId - 1) * 3
			local thresholdSettings = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
			local thresholdActive = thresholdSettings == nil or thresholdSettings.enabled == true
				or (thresholdSettings.audio ~= nil and thresholdSettings.audio.enabled == true and thresholdSettings.audio.sound ~= nil)
			local resourceAmount, isUsable = 0, false
			if thresholdActive then
				resourceAmount = spell:GetPrimaryResourceCost()
				isUsable = spell:IsUsable()
			end
			local showThreshold = true
			local thresholdColor = specCacheSettings.colors.threshold.over.color
			local frameLevel = frameLevels.thresholdOver
			local snapshot = snapshots[spell.id]

			if spell.attributes.stealth and not isStealthed then
				showThreshold = false
			elseif resourceAmount == 0 then
				showThreshold = false
			elseif not spell:IsKnown() then
				showThreshold = false
			elseif spell.isTalent and not talents:IsTalentActive(spell) then
				showThreshold = false
			elseif spell.hasCooldown and snapshot ~= nil and snapshot.cooldown:IsUnusable() then
				thresholdColor = specCacheSettings.colors.threshold.unusable.color
				frameLevel = frameLevels.thresholdUnusable
			elseif not isUsable then
				thresholdColor = specCacheSettings.colors.threshold.under.color
				frameLevel = frameLevels.thresholdUnder
			end

			if resourceAmount >= maxResource then
				showThreshold = false
			end

			if spell:Is("TRB.Classes.SpellComboPointThreshold") and spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and not isUsable then
				thresholdColor = specCacheSettings.colors.threshold.unusable.color
				frameLevel = frameLevels.thresholdUnusable
			end

			local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
			if thresholds[thresholdId] then
				local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry, barSettings)
				Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeFrame, resourceAmount, maxResource, nil, barSettings)
			end
			-- Per-threshold audio cue (independent of line visibility)
			if spell.canHaveAudioCue == true and dictEntry and dictEntry.audio and dictEntry.audio.enabled and dictEntry.audio.sound then
				snapshotData.audio.thresholdCues = snapshotData.audio.thresholdCues or {}
				if isUsable then
					if not snapshotData.audio.thresholdCues[spell.settingKey] then
						snapshotData.audio.thresholdCues[spell.settingKey] = true
						PlaySoundFile(dictEntry.audio.sound, TRB.Data.settings.core.audio.channel.channel)
					end
				else
					snapshotData.audio.thresholdCues[spell.settingKey] = false
				end
			end
		end
	end
end

local function UpdateResourceBar()
	local refreshText = false
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	Bar:HideResourceBar()

	if not (barGroups and barGroups.primary) then
		return
	end
	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil or TRB.Data.character.maxResource == nil then
		return
	end
	if snapshotData.attributes == nil or snapshotData.attributes.resource == nil then
		return
	end

	local specSettings = TRB.Data.settings[className][specName]
	local specCacheSettings = specCache[compositeKey].settings
	UpdateSnapshot()

	if snapshotData.attributes.isTracking then
		-- Indicators resolve ahead of the primary bar's visibility guard: the health bar and cast bar
		-- have their own visibility, so they still need coloring when the resource bar is set to Never Show.
		local sharedColors = specSettings.colors.shared
		local conditionMap = scratch.conditionMap
		wipe(conditionMap)
		local barColors = scratch.barColors
		wipe(barColors)
		barColors.bar = specSettings.colors.bar.base
		barColors.border = specSettings.colors.bar.border.color
		barColors.background = specSettings.colors.bar.background.color
		local barColorMap = scratch.barColorMap
		wipe(barColorMap)
		barColorMap.resourceBar = barColors
		for _, formBar in ipairs(formBars) do
			local colors = scratch.formBarColors[formBar.key]
			wipe(colors)
			local formColors = specSettings.colors.bars[formBar.key]
			colors.bar = formColors.bar
			colors.border = formColors.border.color
			colors.background = formColors.background.color
			barColorMap[formBar.indicator] = colors
		end
		local comboPointColors = scratch.comboPointColors
		wipe(comboPointColors)
		comboPointColors.bar = specSettings.colors.comboPoints.base
		comboPointColors.border = specSettings.colors.comboPoints.border.color
		comboPointColors.background = specSettings.colors.comboPoints.background.color
		barColorMap.comboPointsBar = comboPointColors

		Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

		if not specSettings.displayBar.primary.neverShow then
			refreshText = true
			Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, snapshotData.attributes.resourceModified)
			Bar:ApplyNodeIndicators(primaryNode, "resourceBar")
			primaryNode:SetBorderColor(barColors.border)
			Color:ApplyFillColor(primaryNode, barColors.bar)
			primaryNode:SetBackgroundColorFromString(barColors.background)
			Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
		end

		for _, formBar in ipairs(formBars) do
			local group = barGroups[formBar.key]
			local node = group and group:GetNode(1)
			if node and not specSettings.displayBar[formBar.key].neverShow then
				refreshText = true
				local maxPower = UnitPowerMax("player", formBar.powerType)
				if maxPower == nil or maxPower == 0 then
					maxPower = 100
				end
				-- A secret UnitPower goes straight to the StatusBar unscaled, so its range must be the real maximum.
				if scratch.formBarMax[formBar.key] ~= maxPower then
					scratch.formBarMax[formBar.key] = maxPower
					node:SetMinMax(0, maxPower)
				end
				Bar:SetBarNodeValue(specCacheSettings, formBar.key, node, UnitPower("player", formBar.powerType), maxPower)
				Bar:ApplyNodeIndicators(node, formBar.indicator)
				local colors = barColorMap[formBar.indicator]
				node:SetBorderColor(colors.border)
				Color:ApplyFillColor(node, colors.bar)
				node:SetBackgroundColorFromString(colors.background)
				if not issecretvalue(maxPower) then
					UpdateBarThresholds(formBar.key, node, specCacheSettings, maxPower)
				end
			end
		end

		-- TEMPORARY: the current beta build wrongly marks Combo Points secret; skip the fill until Blizzard fixes it.
		if barGroups.secondary and not specSettings.displayBar.secondary.neverShow and not issecretvalue(snapshotData.attributes.resource2) then
			refreshText = true
			local comboPointsColors = specSettings.colors.comboPoints
			local current = snapshotData.attributes.resource2 or 0
			local max = TRB.Data.character.maxResource2 or 5
			for x = 1, max do
				local node = barGroups.secondary:GetNode(x)
				if node then
					local fillColor = comboPointColors.bar
					if current >= x then
						Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, node, 1, 1)
						local penultimateActive = (specSettings.comboPoints.sameColor and current == max - 1) or (not specSettings.comboPoints.sameColor and x == max - 1)
						local finalActive = (specSettings.comboPoints.sameColor and current == max) or x == max
						if penultimateActive then
							fillColor = comboPointsColors.penultimate
						elseif finalActive then
							fillColor = comboPointsColors.final
						end
					else
						Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, node, 0, 1)
					end
					Bar:ApplyNodeIndicators(node, "comboPointsBar")
					Color:ApplyFillColor(node, fillColor)
					node:SetBorderColor(comboPointColors.border)
					node:SetBackgroundColorFromString(comboPointColors.background)
				end
			end
		end

		if not specSettings.displayBar.health.neverShow then
			refreshText = true
			Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
		end
	end

	TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
end

local targetsTimerFrame = TRB.Frames.targetsTimerFrame
function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		targetData:Cleanup(false)
		targetData:UpdateTrackedSpells(GetTime())
		self.sinceLastUpdate = 0
	end
end

---Re-reads the shapeshift form; a change re-evaluates the form hide conditions and re-parents the bar text.
local function UpdateShapeshiftForm()
	local formId = GetShapeshiftFormID()
	if formId == TRB.Data.character.currentShapeshiftFormId and TRB.Data.character.currentShapeshiftForm ~= nil then
		return
	end
	TRB.Data.character.currentShapeshiftFormId = formId
	TRB.Data.character.currentShapeshiftForm = GetShapeshiftFormName(formId)

	TRB.Functions.BarVisibility:MarkDirty()
	if TRB.Data.barConstructedForSpec == nil or TRB.Data.snapshotData == nil or TRB.Data.snapshotData.snapshots == nil then
		return
	end
	TRB.Functions.Class:TriggerResourceBarUpdates()
	TRB.Functions.Castbar:SyncEnabledState()
end

local shapeshiftFrame = CreateFrame("Frame")
shapeshiftFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
shapeshiftFrame:SetScript("OnEvent", UpdateShapeshiftForm)

local function SwitchSpec()
	TRB.Data.prevLookupState = {}
	TRB.Data.lookupDirty = true
	Bar:QueueRenderTransition("switchSpec", 0.8)
	Character:DisableSpellRangeCheckUpdate()
	TRB.Data.character.specId = TRB.Flavor.GetSpecializationIndex()

	if TRB.Data.character.specId == specId then
		local cache = specCache[compositeKey]
		cache.talents:GetTalents()
		FillSpellData()
		Character:LoadFromSpecializationCache(cache)
		UpdateShapeshiftForm()

		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData
		Bar:UpdateSanityCheckValues(cache.settings)
		local spells = cache.spellsData.spells --[[@as TRB.Classes.Druid.GeneralSpells]]
		local lookup = TRB.Data.lookup or {}
		lookup["#bearForm"] = spells.bearForm.icon
		lookup["#catForm"] = spells.catForm.icon
		lookup["#claw"] = spells.claw.icon
		lookup["#ferociousBite"] = spells.ferociousBite.icon
		lookup["#maul"] = spells.maul.icon
		lookup["#prowl"] = spells.prowl.icon
		lookup["#rake"] = spells.rake.icon
		lookup["#rip"] = spells.rip.icon
		lookup["#shred"] = spells.shred.icon
		lookup["#swipe"] = spells.swipe.icon
		lookup["#tigersFury"] = spells.tigersFury.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
		TRB.Functions.Class:EventRegistration()

		if TRB.Data.barConstructedForSpec ~= compositeKey then
			talents = cache.talents
			TRB.Data.barConstructedForSpec = compositeKey
			ConstructResourceBar(cache.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

	TRB.Functions.Class:EventRegistration()

	C_Timer.After(0, function()
		C_Timer.After(0.05, function()
			TRB.Functions.Class:CheckCharacter()
			if TRB.Data.barConstructedForSpec ~= nil then
				Character:ResetCaches()
				-- Ensure health values are populated so the health bar displays immediately
				Character:UpdateHealthValues()
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end)
end

function TRB.Functions.Class:CheckCharacter()
	local currentSpecId = TRB.Flavor.GetSpecializationIndex()
	if currentSpecId ~= TRB.Data.character.specId then
		SwitchSpec()
	end
	Character:CheckCharacter()
	TRB.Data.character.className = className
	TRB.Data.character.specName = specName
	TRB.Data.character.compositeKey = compositeKey
	TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
	TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)

	local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
	if maxComboPoints == nil or maxComboPoints == 0 then
		maxComboPoints = 5
	end
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	local sharedSettings = specCache[compositeKey].settings
	if maxComboPoints ~= TRB.Data.character.maxResource2 then
		TRB.Data.character.maxResource2 = maxComboPoints
		if barGroups and barGroups.secondary and sharedSettings then
			barGroups.secondary:SetMaxNodes(maxComboPoints)
			barGroups.secondary:Show()
			Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
			Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	local enabled = TRB.Data.settings.core.enabled[className][specName] == true
	if enabled then
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.ComboPoints
		TRB.Data.resource2Factor = 1
		TRB.Data.additionalPowerTokens = { ["RAGE"] = true, ["ENERGY"] = true }
	else
		TRB.Data.specSupported = false
		TRB.Data.additionalPowerTokens = nil
	end

	Character:EventRegistration()
end

function TRB.Functions.Class:HideResourceBar(force)
	if not TRB.Functions.BarVisibility:IsDirty(force) then
		return
	end

	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	if TRB.Data.character.specId == specId then
		local sharedSettings = specCache[compositeKey] and specCache[compositeKey].settings
		local displayBar = sharedSettings and sharedSettings.displayBar
		local comboPointNodes = TRB.Data.character.maxResource2 or 5
		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, displayBar and displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.rage, displayBar and displayBar.rage, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.energy, displayBar and displayBar.energy, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, displayBar and displayBar.secondary, true, comboPointNodes, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, displayBar and displayBar.health, true, 1, nil),
		}
		if sharedSettings ~= nil then
			local context = TRB.Classes.BarVisibilityContext:NewFromGameState(force, sharedSettings)
			TRB.Functions.BarVisibility:ProcessBars(context, entries, snapshotData, sharedSettings)
		else
			TRB.Functions.BarVisibility:HideAllEntries(entries, snapshotData, nil)
		end
	else
		TRB.Functions.BarVisibility:HideAllBarGroups(snapshotData)
	end
end

---Threshold lines live on the Rage and Energy bars and are created on demand, so the primary bar keeps none.
---@param _ table
---@param barGroups table<string, TRB.Classes.BarGroup>
function TRB.Functions.Class:RecreateThresholds(_, barGroups)
	local primaryNode = barGroups.primary and barGroups.primary:GetNode(1)
	if primaryNode then
		primaryNode:ClearThresholds()
	end
end

---Mana casts snapshot their cost for the casting overlay and $casting; a finished cast refreshes its cooldown.
---@param event string
---@param spellId integer?
function TRB.Functions.Class:SpellCast(event, spellId)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
		snapshotData.casting:SnapshotManaSpell()
		snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and spellId ~= nil then
		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spellsById[spellId]
		local spell = spells and spells[1]
		local snapshot = spell and snapshotData.snapshots[spell.id]
		if snapshot ~= nil and spell.hasCooldown then
			snapshot.cooldown:Refresh(true)
		end
	end
end

-- Logic validity: the live resources are secret, so only their maxes and the discrete combo point
-- count can gate a conditional; $casting gates on an actual cast being tracked.
local castingFn = function()
	local casting = TRB.Data.snapshotData.casting
	return casting.resourceRaw ~= nil and casting.resourceRaw ~= 0
end
function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then return valid end
	if var == "$resourceMax" or var == "$manaMax" or var == "$rageMax" or var == "$energyMax"
		or var == "$comboPoints" or var == "$comboPointsMax" or var == "$inStealth" then
		return true
	end
	if var == "$casting" then
		return castingFn() or false
	end
	return false
end

---Gets the Frame for the requested bar text anchor, if the frame is currently enabled and visible.
---@param relativeToFrame string
---@return Frame?, boolean, boolean
function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if not (barGroups and barGroups.primary) then
		return nil, true, false
	end
	local normalized = string.gsub(relativeToFrame or "", "_", "")
	local singleNodeGroups = {
		Resource = barGroups.primary, ResourceBar = barGroups.primary, ManaBar = barGroups.primary,
		RageBar = barGroups.rage, EnergyBar = barGroups.energy,
		Health = barGroups.health, HealthBar = barGroups.health,
	}
	local group = singleNodeGroups[normalized]
	if group ~= nil then
		local node = group:GetNode(1)
		if node then
			return node:GetFrame(), true, group.isVisible and node.isVisible
		end
		return nil, true, false
	end
	local comboPointPrefix = "ComboPoint"
	if string.sub(normalized, 1, string.len(comboPointPrefix)) == comboPointPrefix then
		local index = tonumber(string.sub(normalized, string.len(comboPointPrefix) + 1))
		if index and barGroups.secondary then
			local node = barGroups.secondary:GetNode(index)
			if node then
				return node:GetFrame(), true, barGroups.secondary.isVisible and node.isVisible
			end
		end
	end
	return nil, true, false
end

function TRB.Functions.Class:HasActiveTimers()
	return false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if Bar:IsRenderTransitionActive() then
		Bar:HideResourceBar(true)
		return
	end
	if not TRB.Data.specSupported or talents == nil then
		return
	end
	if TRB.Data.character.specId ~= specId then
		Bar:HideResourceBar(true)
		return
	end
	UpdateResourceBar()
end

TRB.Functions.Bootstrap:RegisterClassModule({
	classId = classId,
	specCache = specCache,
	FillSpecializationCache = FillSpecializationCache,
	SwitchSpec = SwitchSpec,
	ConstructResourceBar = ConstructResourceBar,
	fillSpellData = { FillSpellData },
})
