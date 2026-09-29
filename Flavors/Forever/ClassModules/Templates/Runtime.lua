local _, TRB = ...
local L = TRB.Localization

TRB.Forever = TRB.Forever or {}
TRB.Forever.Templates = TRB.Forever.Templates or {}
TRB.Forever.Templates.Runtime = {}

-- World of Warcraft: Forever class template, part 2 of 3 (the Runtime stage).
--
-- Installs the runtime for the player's class from its DefineClass definition: the spec caches, the
-- TRB.Functions.Class overrides Core drives (CheckCharacter, EventRegistration, HideResourceBar,
-- TriggerResourceBarUpdates, SpellCast, IsValidVariableForSpec, GetBarTextFrame, HasActiveTimers), the
-- lookup refresh for the archetype's bar text variables, the per-tick bar update, spec switching and
-- bar construction, and the Bootstrap registration. Class files call Install once; a class that grows
-- real ability tracking replaces individual hooks through the returned runtime table.

local lookupChanged = TRB.Functions.BarText.LookupChanged
local Bar = TRB.Functions.Bar
local Color = TRB.Functions.Color
local Character = TRB.Functions.Character
local Threshold = TRB.Functions.Threshold
local frameLevels = TRB.Data.constants.frameLevels

---@class TRB.Forever.Runtime
---@field public classDef TRB.Forever.ClassDefinition
---@field public specCache table<string, TRB.Classes.SpecCache>
---@field public talents TRB.Classes.Talents?
---@field public stance string? # stance the class module last read, matched against a threshold's `stances` set
---@field public SwitchSpec fun()
---@field public ConstructResourceBar fun(settings: table)
---@field public FillSpellData table<string, fun()> # keyed by specName

---Installs the runtime for one class and registers it with the bootstrap. Call only from the module of
---the player's class (the class file returns early otherwise).
---@param className string
---@return TRB.Forever.Runtime
function TRB.Forever.Templates.Runtime:Install(className)
	local classDef = TRB.Forever.Classes[className]
	assert(classDef ~= nil, "TwintopInsanityBar: Forever runtime install for undefined class '" .. tostring(className) .. "'")
	TRB.Functions.Class = TRB.Functions.Class or {}

	---@type TRB.Forever.Runtime
	---@diagnostic disable-next-line: missing-fields
	local runtime = { classDef = classDef, specCache = {}, talents = nil, FillSpellData = {} }
	local specCache = runtime.specCache
	for _, spec in ipairs(classDef.specOrder) do
		specCache[spec.entry.compositeKey] = TRB.Classes.SpecCache:New()
	end
	TRB.Data.specCache = specCache

	Global_TwintopResourceBar = {}

	---The active spec's template definition, or nil while the character has no spec yet.
	---@return TRB.Forever.SpecDefinition?
	local function ActiveSpec()
		return classDef.specsById[TRB.Data.character.specId]
	end

	local function FillSpecializationCache()
		Global_TwintopResourceBar = { resource = { resource = 0, casting = 0 } }
		for _, spec in ipairs(classDef.specOrder) do
			local cache = specCache[spec.entry.compositeKey]
			cache.character = {
				guid = UnitGUID("player"),
				raceId = TRB.Data.character.raceId,
				classId = TRB.Data.character.classId,
				specId = spec.entry.specId,
				maxResource = spec.archetype.defaultMax,
				effects = {},
				items = {},
			}
			cache.spellsData.spells = spec.spellsClass:New()
			-- A cooldown ability's threshold line and icon swipe read its snapshot.
			local snapshots = cache.snapshotData.snapshots
			for _, spell in pairs(cache.spellsData.spells) do
				if spell.hasCooldown then
					snapshots[spell.id] = TRB.Classes.Snapshot:New(spell)
				end
			end
			cache.barTextVariables = { icons = {}, values = {} }
		end
	end

	---@param spec TRB.Forever.SpecDefinition
	local function Setup(spec)
		Character:FillSpecializationCacheSettings(className, spec.entry.specName)
		-- Only destroy and recreate bar groups when switching to this spec
		if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= spec.entry.compositeKey then
			Bar:DestroyBarGroups()
			TRB.Frames.barGroups = TRB.Classes[classDef.classModuleName].BarGroupsFactory:CreateForSpec(spec.entry.specId)
		end
	end

	for _, spec in ipairs(classDef.specOrder) do
		runtime.FillSpellData[spec.entry.specName] = function()
			Setup(spec)
			local cache = specCache[spec.entry.compositeKey]
			cache.spellsData:FillSpellData()
			spec.spellsClass.FillBarTextVariables(cache)
		end
	end

	local function ConstructResourceBar(settings)
		local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
		if not TRB.Data.specSupported then
			return
		end
		local spec = ActiveSpec()
		if spec == nil then
			return
		end

		if barGroups and barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				primaryNode:ClearThresholds()
				for _ = 1, #TRB.Data.cache.thresholdSpells do
					local thresholdFrame = CreateFrame("Frame", nil, primaryNode:GetFrame())
					Threshold:ResetThresholdLine(thresholdFrame, settings, true)
					primaryNode:RegisterThreshold(thresholdFrame)
				end
			end
			Bar:ConstructBarGroups(settings, barGroups)
		end

		if barGroups and barGroups.secondary then
			if spec.archetype.secondary ~= nil then
				local maxNodes = TRB.Data.character.maxResource2 or spec.archetype.secondary.maxNodes
				barGroups.secondary:RebuildNodes(maxNodes, settings)
			else
				barGroups.secondary:Hide()
			end
		end

		TRB.Functions.Class:CheckCharacter()
		-- Make sure bar visibility and bar text are updated immediately.
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
	runtime.ConstructResourceBar = ConstructResourceBar

	---Whether any enabled threshold ability can be cast right now, for the over-threshold text color.
	---@param specCacheSettings table
	---@return boolean
	local function AnyThresholdUsable(specCacheSettings)
		local dictionary = specCacheSettings.thresholds.thresholdDictionary
		for _, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
			local dictEntry = dictionary[spell.settingKey]
			if (dictEntry == nil or dictEntry.enabled == true) and spell:IsKnown()
				and (not spell.isTalent or runtime.talents:IsTalentActive(spell)) and spell:IsUsable() then
				return true
			end
		end
		return false
	end

	---Refreshes lookup/lookupLogic for the archetype's variables: $resource and its named alias, the
	---max and percent forms, $casting, and the secondary resource when the spec has one.
	local function RefreshLookupData()
		local spec = ActiveSpec()
		if spec == nil then
			return
		end
		local sharedSettings = specCache[spec.entry.compositeKey].settings
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local archetype = spec.archetype
		local variable = "$" .. archetype.variable

		local prevState = TRB.Data.prevLookupState or {}
		local lookup = TRB.Data.lookup or {}
		local lookupLogic = TRB.Data.lookupLogic or {}
		local activeVars = TRB.Data.activeVariables

		if not activeVars or activeVars[variable] or activeVars["$resource"] or activeVars["$casting"]
			or activeVars[variable .. "Max"] or activeVars["$resourceMax"]
			or activeVars[variable .. "Percent"] or activeVars["$resourcePercent"] then
			local normalizedResource = snapshotData.attributes.resourceModified
			local textColors = sharedSettings.colors.text
			local currentColor = textColors.current.color
			local castingColor = textColors.casting.color
			local castingResource = snapshotData.casting.resourceFinal
			local resourcePercent = UnitPowerPercent("player", archetype.powerType)

			-- The live value's text takes the overcap curve's color, when one applies, in place of currentColor.
			local overcapColor = nil
			if archetype.overcap ~= nil and TRB.Data.character.inCombat then
				if textColors.overThreshold.enabled and AnyThresholdUsable(sharedSettings) then
					currentColor = textColors.overThreshold.color
					castingColor = textColors.overThreshold.color
				end
				if textColors.overcap.enabled and not (spec.stealth and IsStealthed()) then
					-- The raw settings: the spec cache's composed copy carries no overcap threshold.
					local overcapCurve = Color:BuildResourceThresholdCurve(TRB.Data.settings[className][spec.entry.specName], currentColor, textColors.overcap.color)
					if overcapCurve ~= nil then
						overcapColor = UnitPowerPercent("player", archetype.powerType, true, overcapCurve)
					end
				end
			end

			lookupLogic["$resource"] = normalizedResource
			lookupLogic[variable] = normalizedResource
			lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
			lookupLogic[variable .. "Max"] = TRB.Data.character.maxResource
			lookupLogic["$resourcePercent"] = resourcePercent
			lookupLogic[variable .. "Percent"] = resourcePercent
			lookupLogic["$casting"] = castingResource

			local resourceFormatted = snapshotData.formatted.resourceAbbrev or ""
			if lookupChanged(prevState, variable, resourceFormatted, currentColor, overcapColor ~= nil) then
				local formatted = overcapColor ~= nil and overcapColor:WrapTextInColorCode(resourceFormatted) or string.format("|c%s%s|r", currentColor, resourceFormatted)
				lookup[variable] = formatted
				lookup["$resource"] = formatted
			end
			if lookupChanged(prevState, variable .. "Max", TRB.Data.character.maxResource, currentColor) then
				local formatted = string.format("|c%s%s|r", currentColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
				lookup[variable .. "Max"] = formatted
				lookup["$resourceMax"] = formatted
			end
			local percentFormatted = snapshotData.formatted.resourcePercent or ""
			if lookupChanged(prevState, variable .. "Percent", percentFormatted, currentColor, overcapColor ~= nil) then
				local formatted = overcapColor ~= nil and overcapColor:WrapTextInColorCode(percentFormatted) or string.format("|c%s%s|r", currentColor, percentFormatted)
				lookup[variable .. "Percent"] = formatted
				lookup["$resourcePercent"] = formatted
			end
			if lookupChanged(prevState, "$casting", castingResource, castingColor) then
				lookup["$casting"] = string.format("|c%s%s|r", castingColor, TRB.Functions.String:ConvertToAbbreviatedNumber(castingResource))
			end
		end

		if archetype.secondary ~= nil then
			local secondaryVariable = "$" .. archetype.secondary.variable
			if not activeVars or activeVars[secondaryVariable] or activeVars[secondaryVariable .. "Max"] then
				local current = snapshotData.attributes.resource2 or 0
				local max = TRB.Data.character.maxResource2 or archetype.secondary.maxNodes
				lookupLogic[secondaryVariable] = current
				lookupLogic[secondaryVariable .. "Max"] = max
				if lookupChanged(prevState, secondaryVariable, current) then
					lookup[secondaryVariable] = tostring(current)
				end
				if lookupChanged(prevState, secondaryVariable .. "Max", max) then
					lookup[secondaryVariable .. "Max"] = tostring(max)
				end
			end
		end

		if spec.stealth and (not activeVars or activeVars["$inStealth"]) then
			lookupLogic["$inStealth"] = IsStealthed()
		end

		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = lookupLogic
	end

	local function UpdateSnapshot()
		Character:UpdateSnapshot()
	end

	-- Reused per-tick scratch tables so UpdateResourceBar allocates nothing.
	local scratch = {
		conditionMap = {}, barColors = {}, barColorMap = {}, comboPointColors = {}, comboPointNodeColors = {},
		claimed = { comboPointsBar = {} },
	}

	---Draws the primary bar's spell threshold lines, creating them on demand.
	---@param node TRB.Classes.BarNode
	---@param specCacheSettings table
	---@param maxResource number
	local function UpdateThresholds(node, specCacheSettings, maxResource)
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local snapshots = snapshotData.snapshots
		local thresholds = node:GetThresholds()
		local nodeFrame = node:GetFrame()
		local isStealthed = IsStealthed()

		for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
			if thresholds[thresholdId] == nil then
				local thresholdFrame = CreateFrame("Frame", nil, nodeFrame)
				Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
				node:RegisterThreshold(thresholdFrame)
				thresholds = node:GetThresholds()
			end
			local pairOffset = (thresholdId - 1) * 3
			local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
			local thresholdActive = dictEntry == nil or dictEntry.enabled == true
				or (dictEntry.audio ~= nil and dictEntry.audio.enabled == true and dictEntry.audio.sound ~= nil)
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
			elseif spell.attributes.stances ~= nil and not spell.attributes.stances[runtime.stance] then
				showThreshold = false
			elseif resourceAmount == 0 then
				showThreshold = false
			elseif not spell:IsKnown() then
				showThreshold = false
			elseif spell.isTalent and not runtime.talents:IsTalentActive(spell) then
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

			-- A finisher short only on the resource keeps the below color; with no combo points it can't be cast at all.
			if spell:Is("TRB.Classes.SpellComboPointThreshold") and spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true and (snapshotData.attributes.resource2 or 0) == 0 then
				thresholdColor = specCacheSettings.colors.threshold.unusable.color
				frameLevel = frameLevels.thresholdUnusable
			end

			if thresholds[thresholdId] then
				local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
				Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, nodeFrame, resourceAmount, maxResource)
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
		local spec = ActiveSpec()
		if spec == nil then
			return
		end

		local specSettings = TRB.Data.settings[className][spec.entry.specName]
		local specCacheSettings = specCache[spec.entry.compositeKey].settings
		UpdateSnapshot()

		if snapshotData.attributes.isTracking then
			-- Indicators resolve ahead of the primary bar's visibility guard: the health bar and cast bar
			-- have their own visibility, so they still need coloring when the resource bar is set to Never Show.
			local sharedColors = specSettings.colors.shared
			local powerType = spec.archetype.powerType
			local isStealthed = spec.stealth == true and IsStealthed()
			local conditionMap = scratch.conditionMap
			wipe(conditionMap)
			conditionMap.borderStealth = isStealthed
			conditionMap.borderOvercap = TRB.Data.character.inCombat and not isStealthed
			local barColors = scratch.barColors
			wipe(barColors)
			barColors.bar = specSettings.colors.bar.base
			barColors.border = specSettings.colors.bar.border.color
			barColors.background = specSettings.colors.bar.background.color
			local barColorMap = scratch.barColorMap
			wipe(barColorMap)
			barColorMap.resourceBar = barColors
			local comboPointColors = scratch.comboPointColors
			wipe(comboPointColors)
			if spec.archetype.secondary ~= nil then
				comboPointColors.bar = specSettings.colors.comboPoints.base
				comboPointColors.border = specSettings.colors.comboPoints.border.color
				comboPointColors.background = specSettings.colors.comboPoints.background.color
				barColorMap.comboPointsBar = comboPointColors
			end
			local claimed = scratch.claimed
			wipe(claimed.comboPointsBar)

			Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap, claimed)
			local gradient = Color:GetResolvedGradient()

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, snapshotData.attributes.resourceModified)
				Bar:ApplyNodeIndicators(primaryNode, "resourceBar")
				Color:ApplyNodeGradientColors(primaryNode, "resourceBar", barColors, gradient, powerType, specSettings.overcap)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
				-- A secret maximum leaves nothing to place the lines against.
				if not issecretvalue(TRB.Data.character.maxResource) then
					UpdateThresholds(primaryNode, specCacheSettings, TRB.Data.character.maxResource)
				end
			end

			if spec.archetype.secondary ~= nil and barGroups.secondary and not specSettings.displayBar.secondary.neverShow then
				refreshText = true
				local comboPointsColors = specSettings.colors.comboPoints
				local current = snapshotData.attributes.resource2 or 0
				local max = TRB.Data.character.maxResource2 or spec.archetype.secondary.maxNodes
				-- An element an indicator owns keeps the indicator's color over the per-point colors.
				local gradientTargets = gradient ~= nil and gradient.targets and gradient.targets.comboPointsBar or nil
				local fillClaimed = claimed.comboPointsBar.bar or (gradientTargets ~= nil and gradientTargets.bar)
				local borderClaimed = claimed.comboPointsBar.border or (gradientTargets ~= nil and gradientTargets.border)
				local backgroundClaimed = claimed.comboPointsBar.background or (gradientTargets ~= nil and gradientTargets.background)
				local charged = GetUnitChargedPowerPoints("player")
				local nodeColors = scratch.comboPointNodeColors
				for x = 1, max do
					local node = barGroups.secondary:GetNode(x)
					if node then
						nodeColors.bar = comboPointColors.bar
						nodeColors.border = comboPointColors.border
						nodeColors.background = comboPointColors.background
						if current >= x then
							Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, node, 1, 1)
							if not fillClaimed then
								local penultimateActive = (specSettings.comboPoints.sameColor and current == max - 1) or (not specSettings.comboPoints.sameColor and x == max - 1)
								local finalActive = (specSettings.comboPoints.sameColor and current == max) or x == max
								if penultimateActive then
									nodeColors.bar = comboPointsColors.penultimate
								elseif finalActive then
									nodeColors.bar = comboPointsColors.final
								end
							end
						else
							Bar:SetBarNodeValue(specCacheSettings, "comboPoint" .. x, node, 0, 1)
						end
						if charged ~= nil then
							for _, chargedIndex in ipairs(charged) do
								if chargedIndex == x then
									local chargedColors = comboPointsColors.echoingReprimand
									if not fillClaimed then
										nodeColors.bar = chargedColors
									end
									if not borderClaimed then
										nodeColors.border = chargedColors.color
									end
									if not backgroundClaimed then
										-- The charged color's hue at the background's own opacity.
										nodeColors.background = string.sub(comboPointColors.background, 1, 2) .. string.sub(chargedColors.color, 3)
									end
									break
								end
							end
						end
						Bar:ApplyNodeIndicators(node, "comboPointsBar")
						Color:ApplyNodeGradientColors(node, "comboPointsBar", nodeColors, gradient, powerType, specSettings.overcap)
					end
				end
			end

			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end
		end

		if spec.archetype.secondary ~= nil then
			TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, "comboPoints", snapshotData.attributes.resource2)
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

	local function SwitchSpec()
		TRB.Data.prevLookupState = {}
		TRB.Data.lookupDirty = true
		if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
			Bar:QueueRenderTransition("switchSpec", 0.8)
		elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
			Bar:HideResourceBar(true)
		end
		Character:DisableSpellRangeCheckUpdate()
		TRB.Data.character.specId = TRB.Flavor.GetSpecializationIndex()

		local spec = ActiveSpec()
		if spec ~= nil then
			local cache = specCache[spec.entry.compositeKey]
			cache.talents:GetTalents()
			runtime.FillSpellData[spec.entry.specName]()
			Character:LoadFromSpecializationCache(cache)

			---@type TRB.Classes.TargetData
			TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

			TRB.Functions.RefreshLookupData = RefreshLookupData
			Bar:UpdateSanityCheckValues(cache.settings)
			local lookup = TRB.Data.lookup or {}
			for _, key in ipairs(spec.icons or {}) do
				lookup["#" .. key] = cache.spellsData.spells[key].icon
			end
			TRB.Data.lookup = lookup
			TRB.Data.lookupLogic = {}

			-- CRITICAL: EventRegistration MUST be called BEFORE ConstructResourceBar.
			TRB.Functions.Class:EventRegistration()

			if TRB.Data.barConstructedForSpec ~= spec.entry.compositeKey then
				runtime.talents = cache.talents
				TRB.Data.barConstructedForSpec = spec.entry.compositeKey
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
	runtime.SwitchSpec = SwitchSpec

	function TRB.Functions.Class:CheckCharacter()
		local specId = TRB.Flavor.GetSpecializationIndex()
		if specId ~= TRB.Data.character.specId then
			SwitchSpec()
		end
		Character:CheckCharacter()
		TRB.Data.character.className = className

		local spec = ActiveSpec()
		if spec == nil then
			return
		end
		TRB.Data.character.specName = spec.entry.specName
		TRB.Data.character.compositeKey = spec.entry.compositeKey
		TRB.Data.character.maxResource = UnitPowerMax("player", spec.archetype.powerType, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", spec.archetype.powerType, false)

		if spec.archetype.secondary ~= nil then
			local maxSecondary = UnitPowerMax("player", spec.archetype.secondary.powerType)
			if maxSecondary == nil or maxSecondary == 0 then
				maxSecondary = spec.archetype.secondary.maxNodes
			end
			local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
			local sharedSettings = specCache[spec.entry.compositeKey].settings
			if maxSecondary ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxSecondary
				if barGroups and barGroups.secondary and sharedSettings then
					barGroups.secondary:SetMaxNodes(maxSecondary)
					barGroups.secondary:Show()
					Bar:ApplyBarGroupsLayout(sharedSettings, barGroups)
					Bar:ApplyBarGroupsAppearance(sharedSettings, barGroups)
				end
			end
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local spec = ActiveSpec()
		local enabled = spec ~= nil and TRB.Data.settings.core.enabled[className][spec.entry.specName] == true
		if enabled then
			TRB.Data.specSupported = true
			TRB.Data.resource = spec.archetype.powerType
			TRB.Data.resourceFactor = 1
			if spec.archetype.secondary ~= nil then
				TRB.Data.resource2 = spec.archetype.secondary.powerType
				TRB.Data.resource2Factor = 1
			else
				TRB.Data.resource2 = nil
				TRB.Data.resource2Id = nil
			end
			TRB.Data.additionalPowerTokens = nil
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
		local spec = ActiveSpec()

		if spec ~= nil then
			local sharedSettings
			if specCache[spec.entry.compositeKey] ~= nil then
				sharedSettings = specCache[spec.entry.compositeKey].settings
			end
			local hasSecondary = spec.archetype.secondary ~= nil
			local secondaryNodes = hasSecondary and (TRB.Data.character.maxResource2 or spec.archetype.secondary.maxNodes) or nil
			local entries = {
				TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
				TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, sharedSettings and sharedSettings.displayBar.secondary, hasSecondary, secondaryNodes, nil),
				TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, sharedSettings and sharedSettings.displayBar.health, true, 1, nil),
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

	---Mana specs snapshot the cast's mana cost so the casting overlay and $casting can show it; the
	---other archetypes have no cast-time resource spending to predict. A finished cast refreshes its cooldown.
	---@param event string
	---@param spellId integer?
	function TRB.Functions.Class:SpellCast(event, spellId)
		local spec = ActiveSpec()
		if spec == nil then
			return
		end
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			if spec.archetype.key == "mana" then
				snapshotData.casting:SnapshotManaSpell()
				snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
			end
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

	-- Logic validity: the live resource is secret, so only its max (and the discrete secondary count)
	-- can gate a conditional; $casting gates on an actual cast being tracked.
	local castingFn = function()
		local casting = TRB.Data.snapshotData.casting
		return casting.resourceRaw ~= nil and casting.resourceRaw ~= 0
	end
	function TRB.Functions.Class:IsValidVariableForSpec(var)
		local valid = TRB.Functions.BarText:IsValidVariableBase(var)
		if valid then return valid end
		local spec = ActiveSpec()
		if spec == nil then return false end
		local variable = "$" .. spec.archetype.variable
		if var == "$resourceMax" or var == variable .. "Max" then
			return true
		end
		if var == "$casting" then
			return castingFn() or false
		end
		if spec.stealth and var == "$inStealth" then
			return true
		end
		if spec.archetype.secondary ~= nil then
			local secondaryVariable = "$" .. spec.archetype.secondary.variable
			if var == secondaryVariable or var == secondaryVariable .. "Max" then
				return true
			end
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
		if normalized == "Resource" or normalized == "ResourceBar" then
			local node = barGroups.primary:GetNode(1)
			if node then
				return node:GetFrame(), true, barGroups.primary.isVisible and node.isVisible
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
			return nil, true, false
		end
		if normalized == "HealthBar" or normalized == "Health" then
			if barGroups.health then
				local node = barGroups.health:GetNode(1)
				if node then
					return node:GetFrame(), true, barGroups.health.isVisible and node.isVisible
				end
			end
			return nil, true, false
		end
		return nil, true, false
	end

	function TRB.Functions.Class:HasActiveTimers()
		return false
	end

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		if TRB.Functions.Bar and TRB.Functions.Bar.IsRenderTransitionActive and Bar:IsRenderTransitionActive() then
			Bar:HideResourceBar(true)
			return
		end
		if not TRB.Data.specSupported or runtime.talents == nil then
			return
		end
		if ActiveSpec() == nil then
			Bar:HideResourceBar(true)
			return
		end
		UpdateResourceBar()
	end

	local fillSpellData = {}
	for _, spec in ipairs(classDef.specOrder) do
		fillSpellData[#fillSpellData + 1] = runtime.FillSpellData[spec.entry.specName]
	end

	TRB.Functions.Bootstrap:RegisterClassModule({
		classId = classDef.classId,
		specCache = specCache,
		FillSpecializationCache = FillSpecializationCache,
		SwitchSpec = SwitchSpec,
		ConstructResourceBar = ConstructResourceBar,
		fillSpellData = fillSpellData,
	})

	TRB.Forever.Runtime = runtime
	return runtime
end
