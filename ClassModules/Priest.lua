local _, TRB = ...
if TRB.Data.character.classId ~= 5 then --Only do this if we're on a Priest!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}
local lookupChanged = TRB.Functions.BarText.LookupChanged
local Threshold = TRB.Functions.Threshold
local Bar = TRB.Functions.Bar
local Color = TRB.Functions.Color
local Character = TRB.Functions.Character
local frameLevels = TRB.Data.constants.frameLevels

local targetsTimerFrame = TRB.Frames.targetsTimerFrame

local eventFrame = CreateFrame("Frame")

-- Voidbinding detection state: tooltip-based healing comparison
local previousDescriptionHealing = nil  ---@type number|nil # Prayer of Mending healing from last frame's tooltip
local lastKnownVersOffensive = nil      ---@type number|nil # Last non-secret GetCombatRatingBonus(29) reading

-- Pre-allocated Holy Word definitions table, populated once by FillSpellData_Holy().
-- Only the mutable fields (color, enabled) are refreshed per-tick in UpdateResourceBar.
-- This avoids creating 4 tables (1 array + 3 elements) every 50ms tick.
local holyWordDefsCache = {
	{ spell = nil --[[@as TRB.Classes.SpellBase]], key = "holyWordSerenity", color = "" --[[@as string]], enabled = false },
	{ spell = nil --[[@as TRB.Classes.SpellBase]], key = "holyWordSanctify", color = "" --[[@as string]], enabled = false },
	{ spell = nil --[[@as TRB.Classes.SpellBase]], key = "holyWordChastise", color = "" --[[@as string]], enabled = false },
}


-- Reverse lookup: nodeColor key → holyWordDefsCache entry (populated once, stable)
local holyWordKeyToDef = {
	holyWordSerenity = holyWordDefsCache[1],
	holyWordSanctify = holyWordDefsCache[2],
	holyWordChastise = holyWordDefsCache[3],
}

--- Builds (or refreshes) the Holy Word node mapping that maps e.g. "holyWordSerenity1" → physical node index.
--- This is used by GetBarTextFrame to anchor bar text to the correct Holy Word node.
--- Safe to call any time after SwitchSpec has populated talents/spells; the mapping is also
--- refreshed every tick by UpdateResourceBar.
local function BuildHolyWordNodeMapping()
	local specCache = TRB.Data.specCache
	local holyTalents = specCache and specCache.priest_holy and specCache.priest_holy.talents
	if not holyTalents then return end

	local holySpells = specCache.priest_holy.spellsData and specCache.priest_holy.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	if not holySpells then return end

	local settings = TRB.Data.settings and TRB.Data.settings.priest and TRB.Data.settings.priest.holy
	if not settings then return end

	local hwColors = settings.colors and settings.colors.bars and settings.colors.bars.holyWords
	if not hwColors then return end

	local holyWordsBarTypeDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords")
	if not holyWordsBarTypeDef then return end

	local orderedKeys = holyWordsBarTypeDef:GetOrderedNodeKeys(hwColors)

	TRB.Data.holyWordNodeMapping = TRB.Data.holyWordNodeMapping or {}
	local nodeMapping = TRB.Data.holyWordNodeMapping
	-- Snapshot old mapping to detect changes (for re-anchoring bar text)
	local oldSnapshot = {}
	for k, v in pairs(nodeMapping) do
		oldSnapshot[k] = v
	end
	-- Clear existing entries
	for k in pairs(nodeMapping) do
		nodeMapping[k] = nil
	end

	local currentNode = 1
	for _, nodeKey in ipairs(orderedKeys) do
		local nodeColorEntry = hwColors.nodeColors[nodeKey]
		if nodeColorEntry and nodeColorEntry.enabled then
			local hwDef = holyWordKeyToDef[nodeKey]
			if hwDef and hwDef.spell and holyTalents:IsTalentActive(hwDef.spell) then
				if nodeKey ~= "holyWordSanctify" or not holyTalents:IsTalentActive(holySpells.ultimateSerenity) then
					local maxCharges = 1
					if (nodeKey == "holyWordSerenity" or nodeKey == "holyWordSanctify") and holyTalents:IsTalentActive(holySpells.miracleWorker) then
						maxCharges = 2
					end
					for chargeIndex = 1, maxCharges do
						nodeMapping[nodeKey .. chargeIndex] = currentNode
						currentNode = currentNode + 1
					end
				end
			end
		end
	end

	-- If the mapping changed (node order swap, enable/disable toggle, talent change),
	-- re-anchor bar text frames so they point to the correct physical nodes.
	local mappingChanged = false
	for k, v in pairs(nodeMapping) do
		if oldSnapshot[k] ~= v then
			mappingChanged = true
			break
		end
	end
	if not mappingChanged then
		for k in pairs(oldSnapshot) do
			if nodeMapping[k] == nil then
				mappingChanged = true
				break
			end
		end
	end
	if mappingChanged then
		TRB.Functions.BarText:CreateBarTextFrames()
	end
end

-- Frame for handling Sustained Potency pause events (PLAYER_CONTROL_LOST/GAINED, PLAYER_REGEN_ENABLED/DISABLED)
local sustainedPotencyFrame = CreateFrame("Frame")

---Handles Sustained Potency pause events for Voidform
---@param self any
---@param event string
local function SustainedPotencyEventHandler(self, event)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	if snapshotData == nil then
		return
	end

	local spellsData = TRB.Data.spellsData
	if spellsData == nil or spellsData.spells == nil then
		return
	end

	local buff = nil

	if TRB.Data.character.specId == 2 then
		---@type TRB.Classes.Priest.HolySpells
		local spells = spellsData.spells
		
		local apotheosisSnapshot = snapshotData.snapshots[spells.apotheosis.id]
		if apotheosisSnapshot == nil then
			return
		end

		buff = apotheosisSnapshot.buff
	elseif TRB.Data.character.specId == 3 then
		---@type TRB.Classes.Priest.ShadowSpells
		local spells = spellsData.spells

		local voidformSnapshot = snapshotData.snapshots[spells.voidform.id]
		if voidformSnapshot == nil then
			return
		end

		buff = voidformSnapshot.buff
	end

	if buff == nil or not buff.isActive then
		return
	end

	if event == "PLAYER_CONTROL_LOST" or event == "PLAYER_REGEN_ENABLED" then
		-- Enter pause mode when losing control or exiting combat
		buff:EnterPauseMode()
	elseif event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_REGEN_DISABLED" then
		-- Exit pause mode when regaining control or entering combat
		buff:ExitPauseMode()
	end
end

sustainedPotencyFrame:SetScript("OnEvent", SustainedPotencyEventHandler)

---Registers Sustained Potency events for Voidform pause tracking
local function RegisterSustainedPotencyEvents()
	sustainedPotencyFrame:RegisterEvent("PLAYER_CONTROL_LOST")
	sustainedPotencyFrame:RegisterEvent("PLAYER_CONTROL_GAINED")
	sustainedPotencyFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	sustainedPotencyFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
end

---Unregisters Sustained Potency events
local function UnregisterSustainedPotencyEvents()
	sustainedPotencyFrame:UnregisterEvent("PLAYER_CONTROL_LOST")
	sustainedPotencyFrame:UnregisterEvent("PLAYER_CONTROL_GAINED")
	sustainedPotencyFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	sustainedPotencyFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

---Starts the buff paused when it was cast out of combat. The pause events only fire on a combat
---transition, so a cast that never crosses one would otherwise tick from the moment it lands.
---@param buff TRB.Classes.SnapshotBuff
local function StartPausedIfOutOfCombat(buff)
	if not InCombatLockdown() then
		buff:EnterPauseMode()
	end
end

---@type TRB.Classes.Talents
local talents

Global_TwintopResourceBar = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	priest_discipline = TRB.Classes.SpecCache:New(),
	priest_holy = TRB.Classes.SpecCache:New(),
	priest_shadow = TRB.Classes.SpecCache:New()
}
TRB.Data.specCache = specCache

local function FillSpecializationCache()
	-- Discipline
	specCache.priest_discipline.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
		isPvp = false
	}

	specCache.priest_discipline.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 1,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}
	
	specCache.priest_discipline.spellsData.spells = TRB.Classes.Priest.DisciplineSpells:New()
	---@type TRB.Classes.Priest.DisciplineSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.priest_discipline.spellsData.spells

	specCache.priest_discipline.snapshotData.attributes.manaRegen = 0
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.powerWordRadiance.id] = TRB.Classes.Snapshot:New(spells.powerWordRadiance)
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.angelicFeather.id] = TRB.Classes.Snapshot:New(spells.angelicFeather)
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.masterTheDarkness.id] = TRB.Classes.Snapshot:New(spells.masterTheDarkness)
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.voidbinding.id] = TRB.Classes.Snapshot:New(spells.voidbinding)
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.surgeOfLight.id] = TRB.Classes.Snapshot:New(spells.surgeOfLight)
	-- The stack count is a secret in combat, so it is counted in Lua from SPELL_UPDATE_USES instead.
	specCache.priest_discipline.snapshotData.snapshots[spells.surgeOfLight.id].buff:InitializeProcCharges()
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.harshDiscipline.id] = TRB.Classes.Snapshot:New(spells.harshDiscipline)
	--[[---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.shadowCovenant.id] = TRB.Classes.Snapshot:New(spells.shadowCovenant)
	---@type TRB.Classes.Snapshot
	specCache.priest_discipline.snapshotData.snapshots[spells.entropicRift.id] = TRB.Classes.Snapshot:New(spells.entropicRift, {
		guid = nil,
		totemId = nil
	}, false, true)]]

	specCache.priest_discipline.barTextVariables = {
		icons = {},
		values = {}
	}

	-- Holy
	specCache.priest_holy.Global_TwintopResourceBar = {
		resource = {
			resource = 0,
			casting = 0,
		},
		isPvp = false
	}

	specCache.priest_holy.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 2,
		maxResource = 100,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.Priest.HolySpells
	specCache.priest_holy.spellsData.spells = TRB.Classes.Priest.HolySpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.priest_holy.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]

	specCache.priest_holy.snapshotData.attributes.manaRegen = 0
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.apotheosis.id] = TRB.Classes.Snapshot:New(spells.apotheosis, nil, "sometimes")
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.sustainedPotency.id] = TRB.Classes.Snapshot:New(spells.sustainedPotency)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.lightweaver.id] = TRB.Classes.Snapshot:New(spells.lightweaver)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.holyWordSerenity.id] = TRB.Classes.Snapshot:New(spells.holyWordSerenity)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.holyWordSanctify.id] = TRB.Classes.Snapshot:New(spells.holyWordSanctify)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.holyWordChastise.id] = TRB.Classes.Snapshot:New(spells.holyWordChastise)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.angelicFeather.id] = TRB.Classes.Snapshot:New(spells.angelicFeather)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.voidbinding.id] = TRB.Classes.Snapshot:New(spells.voidbinding)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.benediction.id] = TRB.Classes.Snapshot:New(spells.benediction)
	---@type TRB.Classes.Snapshot
	specCache.priest_holy.snapshotData.snapshots[spells.surgeOfLight.id] = TRB.Classes.Snapshot:New(spells.surgeOfLight)
	-- The stack count is a secret in combat, so it is counted in Lua from SPELL_UPDATE_USES instead.
	specCache.priest_holy.snapshotData.snapshots[spells.surgeOfLight.id].buff:InitializeProcCharges()

	-- Shadow
	specCache.priest_shadow.Global_TwintopResourceBar = {
		voidform = {
		},
		resource = {
			resource = 0,
			casting = 0,
		},
	}

	specCache.priest_shadow.character = {
		guid = UnitGUID("player"),
		raceId = TRB.Data.character.raceId,
		classId = TRB.Data.character.classId,
		specId = 3,
		maxResource = 100,
		shadowWordMadnessThreshold = 50,
		effects = {
		},
		items = {
		}
	}

	---@type TRB.Classes.Priest.ShadowSpells
	specCache.priest_shadow.spellsData.spells = TRB.Classes.Priest.ShadowSpells:New()
	---@diagnostic disable-next-line: cast-local-type
	spells = specCache.priest_shadow.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.voidform.id] = TRB.Classes.Snapshot:New(spells.voidform, nil, "sometimes")
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.mindDevourer.id] = TRB.Classes.Snapshot:New(spells.mindDevourer)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.mindFlayInsanity.id] = TRB.Classes.Snapshot:New(spells.mindFlayInsanity)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.screamsOfTheVoid.id] = TRB.Classes.Snapshot:New(spells.screamsOfTheVoid)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.entropicRift.id] = TRB.Classes.Snapshot:New(spells.entropicRift)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.sustainedPotency.id] = TRB.Classes.Snapshot:New(spells.sustainedPotency)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.angelicFeather.id] = TRB.Classes.Snapshot:New(spells.angelicFeather)
	--[[
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.shatteredPsyche.id] = TRB.Classes.Snapshot:New(spells.shatteredPsyche)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.mindBlast.id] = TRB.Classes.Snapshot:New(spells.mindBlast)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.idolOfYoggSaron.id] = TRB.Classes.Snapshot:New(spells.idolOfYoggSaron)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.thingFromBeyond.id] = TRB.Classes.Snapshot:New(spells.thingFromBeyond)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.horrificVisions.id] = TRB.Classes.Snapshot:New(spells.horrificVisions)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.voidVolley.id] = TRB.Classes.Snapshot:New(spells.voidVolley)
	---@type TRB.Classes.Snapshot
	specCache.priest_shadow.snapshotData.snapshots[spells.powerSurge.id] = TRB.Classes.Snapshot:New(spells.powerSurge)]]
end

local function Setup_Discipline()
	Character:FillSpecializationCacheSettings("priest", "discipline", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "priest_discipline" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Priest.BarGroupsFactory:CreateForSpec(1, UIParent)
	end
end

local function FillSpellData_Discipline()
	Setup_Discipline()
	---@type TRB.Classes.SpellsData
	specCache.priest_discipline.spellsData:FillSpellData()
	local spells = specCache.priest_discipline.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]

	TRB.Classes.Priest.DisciplineSpells.FillBarTextVariables(specCache.priest_discipline)
end

local function Setup_Holy()
	Character:FillSpecializationCacheSettings("priest", "holy", true)
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "priest_holy" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Priest.BarGroupsFactory:CreateForSpec(2, UIParent)
	end
end

local function FillSpellData_Holy()
	Setup_Holy()
	specCache.priest_holy.spellsData:FillSpellData()
	local spells = specCache.priest_holy.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]

	-- Populate static spell references in the pre-allocated holyWordDefs table
	holyWordDefsCache[1].spell = spells.holyWordSerenity
	holyWordDefsCache[2].spell = spells.holyWordSanctify
	holyWordDefsCache[3].spell = spells.holyWordChastise

	TRB.Classes.Priest.HolySpells.FillBarTextVariables(specCache.priest_holy)
end

local function Setup_Shadow()
	Character:FillSpecializationCacheSettings("priest", "shadow")
	
	-- Only destroy and recreate bar groups when switching to this spec
	if TRB.Frames.barGroups == nil or TRB.Data.barConstructedForSpec ~= "priest_shadow" then
		Bar:DestroyBarGroups()
		TRB.Frames.barGroups = TRB.Classes.Priest.BarGroupsFactory:CreateForSpec(3, UIParent)
	end
end

local function FillSpellData_Shadow()
	Setup_Shadow()
	specCache.priest_shadow.spellsData:FillSpellData()
	local spells = specCache.priest_shadow.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]

	TRB.Classes.Priest.ShadowSpells.FillBarTextVariables(specCache.priest_shadow)
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:UpdateTrackedSpells(currentTime)
end

local function TargetsCleanup(clearAll)
	local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
	targetData:Cleanup(clearAll)
end

local function ConstructResourceBar(settings)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Don't construct bars for disabled specs
	if not TRB.Data.specSupported then
		return
	end

	-- Create thresholds on the BarNode (new system)
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

	-- Power Words secondary bar (Discipline only)
	if TRB.Data.character.specId == 1 and barGroups and barGroups.secondary then
		local maxPowerWordNodes = TRB.Data.character.maxResource2 or 0

		if maxPowerWordNodes == 0 then
			barGroups.secondary:Hide()
		else
			barGroups.secondary:SetMaxNodes(maxPowerWordNodes)
			Bar:ApplySecondaryBarGroupLayout(settings, barGroups, maxPowerWordNodes)
			barGroups.secondary:Show()

			for i = 1, maxPowerWordNodes do
				local node = barGroups.secondary:GetNode(i)
				if node then
					node:SetTextures(
						settings.textures.comboPointsBar,
						settings.textures.comboPointsBorder,
						settings.textures.comboPointsBackground
					)
					node:SetMinMax(0, 1)
					node:SetBorderColor(settings.colors.comboPoints.border.color)
					node:SetBackgroundColorFromString(settings.colors.comboPoints.background.color)
					TRB.Functions.Color:ApplyFillColor(node, settings.colors.comboPoints.powerWordRadiance)
					node:SetFrameLevel(TRB.Functions.Bar:GetBarFrameLevel("secondary"))
				end
			end
		end
	end

	-- Holy Words bar (Holy only)
	if TRB.Data.character.specId == 2 and barGroups and barGroups.holyWords then
		local maxHolyWordNodes = TRB.Data.character.maxResource2 or 0

		if maxHolyWordNodes == 0 then
			-- All Holy Word enables are unchecked — treat as visibility="never"
			barGroups.holyWords:Hide()
		else
			barGroups.holyWords:SetMaxNodes(maxHolyWordNodes)
			Bar:ApplyMultiNodeBarGroupLayout(settings, barGroups, "holyWords", barGroups.holyWords, settings.bars.holyWords, maxHolyWordNodes)
			barGroups.holyWords:Show()

			-- Build an ordered list of enabled node colors so each physical node gets its correct fill color
			local hwColors = settings.colors.bars.holyWords
			local holyWordsBarTypeDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords")
			local orderedNodeColors = {}
			if holyWordsBarTypeDef and hwColors then
				local orderedKeys = holyWordsBarTypeDef:GetOrderedNodeKeys(hwColors)
				for _, nodeKey in ipairs(orderedKeys) do
					local nodeColorEntry = hwColors.nodeColors[nodeKey]
					if nodeColorEntry and nodeColorEntry.enabled then
						local hwDef = holyWordKeyToDef[nodeKey]
						if hwDef and hwDef.spell and talents and talents:IsTalentActive(hwDef.spell) then
							if nodeKey ~= "holyWordSanctify" or not talents:IsTalentActive(specCache.priest_holy.spellsData.spells--[[@as TRB.Classes.Priest.HolySpells]].ultimateSerenity) then
								local maxCharges = 1
								if (nodeKey == "holyWordSerenity" or nodeKey == "holyWordSanctify") and talents:IsTalentActive(specCache.priest_holy.spellsData.spells--[[@as TRB.Classes.Priest.HolySpells]].miracleWorker) then
									maxCharges = 2
								end
								for _ = 1, maxCharges do
									orderedNodeColors[#orderedNodeColors + 1] = nodeColorEntry.color
								end
							end
						end
					end
				end
			end

			for i = 1, maxHolyWordNodes do
				local node = barGroups.holyWords:GetNode(i)
				if node then
					node:SetTextures(
						settings.textures.holyWordsBar,
						settings.textures.holyWordsBorder,
						settings.textures.holyWordsBackground
					)
					node:SetMinMax(0, 1)
					node:SetBorderColor(hwColors.border.color)
					node:SetBackgroundColorFromString(hwColors.background.color)
					node:SetColor(orderedNodeColors[i] or hwColors.border.color)
					node:SetFrameLevel(TRB.Functions.Bar:GetBarFrameLevel("holyWords"))
				end
			end

			-- Eagerly build the node mapping so bar text anchors resolve before the first UpdateResourceBar tick
			BuildHolyWordNodeMapping()
		end
	end

	-- Lightweaver bar (Holy only)
	if TRB.Data.character.specId == 2 and barGroups and barGroups.lightweaver then
		local lightweaverColors = settings.colors and settings.colors.bars and settings.colors.bars.lightweaver
		local maxLightweaverNodes = 4

		for i = 1, maxLightweaverNodes do
			local node = barGroups.lightweaver:GetNode(i)
			if node then
				node:SetMinMax(0, 1)
				-- Per-node charge color (sameColor uses highest filled charge's color)
				local chargeKey = "charge" .. i
				local nodeColor = lightweaverColors and lightweaverColors.nodeColors and lightweaverColors.nodeColors[chargeKey]
				TRB.Functions.Color:ApplyFillColor(node, nodeColor)
				node:SetFrameLevel(TRB.Functions.Bar:GetBarFrameLevel("lightweaver"))
			end
		end
	end

	TRB.Functions.Class:CheckCharacter()
	-- Make sure bar visibility and bar text are updated immediately.
	-- Bar:HideResourceBar()
	TRB.Functions.Class:TriggerResourceBarUpdates()
end

---Calculates the effective cooldown duration for a Holy Word spell, factoring in talent mods.
---@param holyWordSpell TRB.Classes.SpellBase # The Holy Word spell (holyWordSerenity, holyWordSanctify, or holyWordChastise)
---@return number # The effective cooldown duration in seconds
local function CalculateHolyWordDuration(holyWordSpell)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local duration = holyWordSpell.duration
	if talents:IsTalentActive(spells.holyCelerity) then
		duration = duration + spells.holyCelerity.attributes.durationMod
	end
	if talents:IsTalentActive(spells.prophetsInsight) then
		duration = duration + spells.prophetsInsight.attributes.durationMod
	end

	-- Voidbinding CDR: cooldowns recover cdrPercent faster (rate model, not flat reduction)
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	if snapshots[spells.voidbinding.id].buff.isActive then
		duration = duration / (1 + spells.voidbinding.attributes.cdrPercent)
	end

	return duration
end

---Calculates the amount of CDR based on modifiers
---@param base number
---@return number
local function CalculateHolyWordCooldown(base)
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local mod = 1

	if snapshots[spells.apotheosis.id].buff.isActive then
		mod = mod * spells.apotheosis--[[@as TRB.Classes.Priest.HolyWordSpell]].holyWordModifier
	end

	if talents:IsTalentActive(spells.lightOfTheNaaru) then
		mod = mod * (1 + (spells.lightOfTheNaaru--[[@as TRB.Classes.Priest.HolyWordSpell]].holyWordModifier * talents.talents[spells.lightOfTheNaaru.id].currentRank))
	end

	return mod * (base)
end

local function CalculateResourceGain(resource)
	local modifier = 1.0

	return resource * modifier
end


---Is Surge of Light usable for a Holy Word cooldown reduction right now? The grace covers the frame
---batch where the spend event lands ahead of the cast that consumed it.
---@param snapshotData TRB.Classes.SnapshotData
---@param spells TRB.Classes.Priest.HolySpells
---@return boolean
local function SurgeOfLightUsable(snapshotData, spells)
	return snapshotData.snapshots[spells.surgeOfLight.id].buff.isActive == true
		or snapshotData.attributes.surgeOfLightActiveGrace == true
end

---Did the cast that just landed actually have Surge of Light behind it? A hard cast needs it at both
---ends; an instant fires no START, leaving the reading nil, and there the live value is the whole story.
---@param snapshotData TRB.Classes.SnapshotData
---@param spells TRB.Classes.Priest.HolySpells
---@return boolean
local function SurgeOfLightEmpoweredCast(snapshotData, spells)
	if snapshotData.attributes.surgeOfLightAtCastStart == false then
		return false
	end
	return SurgeOfLightUsable(snapshotData, spells)
end

---Returns true if the player is currently inside an active M+ dungeon in the Voidbinding key range (2-11).
---@return boolean
local function IsInVoidbindingKeyRange()
	if C_ChallengeMode.GetActiveChallengeMapID() == nil then
		return false
	end
	local activeKeystoneLevel = C_ChallengeMode.GetActiveKeystoneInfo()
	return activeKeystoneLevel ~= nil and activeKeystoneLevel >= 2 and activeKeystoneLevel <= 11
end

---Applies or reverses Voidbinding CDR on a single manual-tracked cooldown.
---@param cooldown TRB.Classes.SnapshotCooldown
---@param cdrPercent number # e.g. 0.3 for 30% CDR
---@param apply boolean # true = apply CDR (gain), false = reverse CDR (loss)
local function AdjustCooldownForVoidbinding(cooldown, cdrPercent, apply)
	if not cooldown.onCooldown or cooldown.manualCooldownExpires == nil then
		return
	end
	local now = GetTime()
	local remaining = cooldown.manualCooldownExpires - now
	if remaining <= 0 then
		return
	end
	-- CDR recovery rate: cooldowns tick (1+cdr) times faster while it holds, normal speed once it drops.
	local factor = apply and (1 / (1 + cdrPercent)) or (1 + cdrPercent)
	cooldown.manualCooldownExpires = now + remaining * factor
	-- The duration fields feed bar progress and every later charge, so they scale with the expiry.
	if cooldown.manualCooldownDuration ~= nil then
		cooldown.manualCooldownDuration = cooldown.manualCooldownDuration * factor
	end
	if cooldown.manualRechargeDuration ~= nil then
		cooldown.manualRechargeDuration = cooldown.manualRechargeDuration * factor
	end
end

---Applies or reverses Voidbinding CDR on all affected cooldowns for the current spec.
---@param apply boolean # true = gained Voidbinding, false = lost Voidbinding
local function ApplyVoidbindingCDR(apply)
	local spells = TRB.Data.spellsData.spells
	local snapshots = TRB.Data.snapshotData.snapshots
	local cdrPercent = spells.voidbinding.attributes.cdrPercent
	local specId = TRB.Data.character.specId

	if specId == 1 then
		---@cast spells TRB.Classes.Priest.DisciplineSpells
		AdjustCooldownForVoidbinding(snapshots[spells.powerWordRadiance.id].cooldown, cdrPercent, apply)
	elseif specId == 2 then
		---@cast spells TRB.Classes.Priest.HolySpells
		AdjustCooldownForVoidbinding(snapshots[spells.holyWordSerenity.id].cooldown, cdrPercent, apply)
		AdjustCooldownForVoidbinding(snapshots[spells.holyWordSanctify.id].cooldown, cdrPercent, apply)
		AdjustCooldownForVoidbinding(snapshots[spells.holyWordChastise.id].cooldown, cdrPercent, apply)
	end
end

---Calculates the predicted actual remaining time for a cooldown, accounting for
---Voidbinding CDR expiring mid-cooldown.
---@param cooldownRemaining number # Current remaining time (already CDR'd if VB active)
---@param voidbindingRemaining number # Remaining Voidbinding buff time (0 if inactive)
---@param cdrPercent number # e.g. 0.3 for 30% CDR
---@return number # Predicted wall-clock remaining time
local function CalculatePredictedCooldownRemaining(cooldownRemaining, voidbindingRemaining, cdrPercent)
	if voidbindingRemaining <= 0 or cooldownRemaining <= 0 then
		return cooldownRemaining
	end

	if voidbindingRemaining >= cooldownRemaining then
		-- Entire cooldown benefits from CDR, already reflected in remaining
		return cooldownRemaining
	end

	-- CDR expires mid-cooldown: portion after VB drops runs at normal speed
	-- cooldownRemaining is the CDR'd total, VB covers the first voidbindingRemaining seconds (real time)
	-- After VB drops, the leftover CDR'd time must be stretched back to normal rate
	local afterVoidbinding = cooldownRemaining - voidbindingRemaining
	return voidbindingRemaining + afterVoidbinding * (1 + cdrPercent)
end

---Dumps the manual charge tracker's live state for each Holy Word. Nothing can verify these values
---against the game in combat, so the comparison has to be made by eye against the action bars.
function TRB.Functions.Class:PrintHolyWordDiagnostics()
	if TRB.Data.character.specId ~= 2 then
		print("|cFFFF8800TRB Holy Words:|r Holy specialization only.")
		return
	end

	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local currentTime = GetTime()

	local function Seconds(value)
		return value and string.format("%.2fs", value) or "none"
	end

	print("|cFF00FF00TRB Holy Words:|r manual charge tracker state")
	for _, key in ipairs({ "holyWordSerenity", "holyWordSanctify", "holyWordChastise" }) do
		local spell = spells[key]
		local cooldown = snapshots[spell.id].cooldown
		local remaining = cooldown.manualCooldownExpires and (cooldown.manualCooldownExpires - currentTime)
		print(string.format("  %s: %d/%d charges | remaining %s | timer %s | recharge %s | expected %s",
			spell.name or key,
			cooldown.manualCharges or 0,
			cooldown.manualMaxCharges or 0,
			Seconds(remaining),
			Seconds(cooldown.manualCooldownDuration),
			Seconds(cooldown.manualRechargeDuration),
			Seconds(CalculateHolyWordDuration(spell))))
	end

	print(string.format("  Apotheosis %s | Voidbinding %s | Surge of Light %d",
		snapshots[spells.apotheosis.id].buff.isActive and "up" or "down",
		snapshots[spells.voidbinding.id].buff.isActive and "up" or "down",
		snapshots[spells.surgeOfLight.id].buff.applications or 0))
end

local function RefreshLookupData_Discipline()
	local sharedSettings = TRB.Data.specCache["priest_discipline"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $manaMax, $resourceMax, $manaPercent, $resourcePercent, $casting)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then
		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = f
			lookup["$resource"] = f
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = f
			lookup["$resourceMax"] = f
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = f
			lookup["$resourcePercent"] = f
		end
	end

	-- Block B: PW Radiance ($pwRadianceTime, $radianceTime, $powerWordRadianceTime, $pwRadianceCharges, $radianceCharges, $powerWordRadianceCharges)
	if not activeVars or activeVars["$pwRadianceTime"] or activeVars["$radianceTime"] or activeVars["$powerWordRadianceTime"]
		or activeVars["$pwRadianceCharges"] or activeVars["$radianceCharges"] or activeVars["$powerWordRadianceCharges"] then
		local vbBuff = snapshots[spells.voidbinding.id].buff
		local vbRemaining = vbBuff.isActive and vbBuff.remaining or 0
		local cdrPercent = spells.voidbinding.attributes.cdrPercent
		local _pwRadianceTime = CalculatePredictedCooldownRemaining(
			snapshots[spells.powerWordRadiance.id].cooldown.remaining, vbRemaining, cdrPercent)
		local _pwRadianceCharges = snapshots[spells.powerWordRadiance.id].cooldown.charges

		lookupLogic["$pwRadianceTime"] = _pwRadianceTime
		lookupLogic["$radianceTime"] = _pwRadianceTime
		lookupLogic["$powerWordRadianceTime"] = _pwRadianceTime
		lookupLogic["$pwRadianceCharges"] = _pwRadianceCharges
		lookupLogic["$radianceCharges"] = _pwRadianceCharges
		lookupLogic["$powerWordRadianceCharges"] = _pwRadianceCharges

		if lookupChanged(prevState, "$pwRadianceTime", _pwRadianceTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_pwRadianceTime)
			lookup["$pwRadianceTime"] = f
			lookup["$radianceTime"] = f
			lookup["$powerWordRadianceTime"] = f
		end
		if lookupChanged(prevState, "$pwRadianceCharges", _pwRadianceCharges) then
			local f = string.format("%.0f", _pwRadianceCharges)
			lookup["$pwRadianceCharges"] = f
			lookup["$radianceCharges"] = f
			lookup["$powerWordRadianceCharges"] = f
		end
	end

	-- Block C: Angelic Feather ($afTime, $angelicFeatherTime, $afCharges, $angelicFeatherCharges, $afMaxCharges, $angelicFeatherMaxCharges)
	if not activeVars or activeVars["$afTime"] or activeVars["$angelicFeatherTime"]
		or activeVars["$afCharges"] or activeVars["$angelicFeatherCharges"]
		or activeVars["$afMaxCharges"] or activeVars["$angelicFeatherMaxCharges"] then
		local _afTime = snapshots[spells.angelicFeather.id].cooldown.remaining
		local _afCharges = snapshots[spells.angelicFeather.id].cooldown.charges
		local _afMaxCharges = spells.angelicFeather.attributes.maxCharges

		lookupLogic["$afTime"] = _afTime
		lookupLogic["$angelicFeatherTime"] = _afTime
		lookupLogic["$afCharges"] = _afCharges
		lookupLogic["$angelicFeatherCharges"] = _afCharges
		lookupLogic["$afMaxCharges"] = _afMaxCharges
		lookupLogic["$angelicFeatherMaxCharges"] = _afMaxCharges

		if lookupChanged(prevState, "$afTime", _afTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_afTime)
			lookup["$afTime"] = f
			lookup["$angelicFeatherTime"] = f
		end
		if lookupChanged(prevState, "$afCharges", _afCharges) then
			local f = string.format("%.0f", _afCharges)
			lookup["$afCharges"] = f
			lookup["$angelicFeatherCharges"] = f
		end
		if lookupChanged(prevState, "$afMaxCharges", _afMaxCharges) then
			local f = string.format("%.0f", _afMaxCharges)
			lookup["$afMaxCharges"] = f
			lookup["$angelicFeatherMaxCharges"] = f
		end
	end

	-- Block D: Buff state ($surgeOfLight, $surgeOfLightStacks, $surgeOfLightStacksMax, $surgeOfLightTime)
	if not activeVars or activeVars["$surgeOfLight"] or activeVars["$surgeOfLightStacks"]
		or activeVars["$surgeOfLightStacksMax"] or activeVars["$surgeOfLightTime"] then
		local surgeOfLightBuff = snapshotData.snapshots[spells.surgeOfLight.id]
		local _surgeOfLightActive = (surgeOfLightBuff ~= nil and surgeOfLightBuff.buff.isActive) or false
		local _surgeOfLightStacks = (_surgeOfLightActive and (surgeOfLightBuff.buff.applications or 0)) or 0
		local _surgeOfLightStacksMax = spells.surgeOfLight.maxStacks
		local _surgeOfLightTime = (_surgeOfLightActive and surgeOfLightBuff.buff.remaining) or 0
		lookupLogic["$surgeOfLight"] = _surgeOfLightActive
		lookupLogic["$surgeOfLightStacks"] = _surgeOfLightStacks
		lookupLogic["$surgeOfLightStacksMax"] = _surgeOfLightStacksMax
		lookupLogic["$surgeOfLightTime"] = _surgeOfLightTime
		lookup["$surgeOfLight"] = ""
		if lookupChanged(prevState, "$surgeOfLightStacks", _surgeOfLightStacks) then
			lookup["$surgeOfLightStacks"] = string.format("%.0f", _surgeOfLightStacks)
		end
		if lookupChanged(prevState, "$surgeOfLightStacksMax", _surgeOfLightStacksMax) then
			lookup["$surgeOfLightStacksMax"] = string.format("%.0f", _surgeOfLightStacksMax)
		end
		if lookupChanged(prevState, "$surgeOfLightTime", _surgeOfLightTime) then
			lookup["$surgeOfLightTime"] = TRB.Functions.BarText:TimerPrecision(_surgeOfLightTime)
		end
	end

	-- Block E: Void Shield duration ($voidShieldTime)
	if not activeVars or activeVars["$voidShieldTime"] or activeVars["$masterTheDarknessTime"] then
		local _voidShieldTime = snapshots[spells.masterTheDarkness.id].buff.remaining

		lookupLogic["$voidShieldTime"] = _voidShieldTime
		lookupLogic["$masterTheDarknessTime"] = _voidShieldTime

		if lookupChanged(prevState, "$voidShieldTime", _voidShieldTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_voidShieldTime)
			lookup["$voidShieldTime"] = f
			lookup["$masterTheDarknessTime"] = f
		end
	end

	-- Block F: Harsh Discipline ($harshDisciplineTime, $harshDisciplineStacks, $harshDisciplineMaxStacks)
	if not activeVars or activeVars["$harshDisciplineTime"] or activeVars["$harshDisciplineStacks"] or activeVars["$harshDisciplineMaxStacks"] then
		local currentTime = GetTime()
		local harshDisciplineBuff = snapshots[spells.harshDiscipline.id]
		local _harshDisciplineActive = (harshDisciplineBuff ~= nil and harshDisciplineBuff.buff.isActive) or false
		local _harshDisciplineStacks = (_harshDisciplineActive and (harshDisciplineBuff.buff.applications or 0)) or 0
		local _harshDisciplineTime = (harshDisciplineBuff ~= nil and harshDisciplineBuff.buff:GetRemainingTime(currentTime)) or 0
		local _harshDisciplineMaxStacks = spells.harshDiscipline.maxStacks or 0
		lookupLogic["$harshDisciplineTime"] = _harshDisciplineTime
		lookupLogic["$harshDisciplineStacks"] = _harshDisciplineStacks
		lookupLogic["$harshDisciplineMaxStacks"] = _harshDisciplineMaxStacks
		if lookupChanged(prevState, "$harshDisciplineTime", _harshDisciplineTime) then
			lookup["$harshDisciplineTime"] = TRB.Functions.BarText:TimerPrecision(_harshDisciplineTime)
		end
		if lookupChanged(prevState, "$harshDisciplineStacks", _harshDisciplineStacks) then
			lookup["$harshDisciplineStacks"] = string.format("%.0f", _harshDisciplineStacks)
		end
		if lookupChanged(prevState, "$harshDisciplineMaxStacks", _harshDisciplineMaxStacks) then
			lookup["$harshDisciplineMaxStacks"] = string.format("%.0f", _harshDisciplineMaxStacks)
		end
	end

	--[[lookup["$scTime"] = scTime
	lookup["$shadowCovenantTime"] = scTime
	lookup["$entropicRiftTime"] = entropicRiftTime]]
	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Holy()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local sharedSettings = TRB.Data.specCache["priest_holy"].settings

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core mana ($mana, $resource, $manaMax, $resourceMax, $manaPercent, $resourcePercent, $casting)
	if not activeVars or activeVars["$mana"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$manaMax"] or activeVars["$resourceMax"]
		or activeVars["$manaPercent"] or activeVars["$resourcePercent"] then
		local normalizedMana = snapshotData.attributes.resourceModified
		local currentManaColor = sharedSettings.colors.text.current.color
		local castingManaColor = sharedSettings.colors.text.casting.color
		local _castingMana = snapshotData.casting.resourceFinal
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)

		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$casting"] = _castingMana

		local manaFormatted = snapshotData.formatted.resourceAbbrev or ""
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, manaFormatted)
			lookup["$mana"] = f
			lookup["$resource"] = f
		end
		if lookupChanged(prevState, "$casting", _castingMana, castingManaColor) then
			lookup["$casting"] = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(_castingMana))
		end
		if lookupChanged(prevState, "$manaMax", TRB.Data.character.maxResource, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToAbbreviatedNumber(TRB.Data.character.maxResource))
			lookup["$manaMax"] = f
			lookup["$resourceMax"] = f
		end
		local manaPercentFormatted = snapshotData.formatted.resourcePercent or ""
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			local f = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
			lookup["$manaPercent"] = f
			lookup["$resourcePercent"] = f
		end
	end

	-- Block B: Holy Words ($hwChastiseTime, $hwSanctifyTime, $hwSerenityTime + charges)
	if not activeVars or activeVars["$hwChastiseTime"] or activeVars["$chastiseTime"] or activeVars["$holyWordChastiseTime"]
		or activeVars["$hwSanctifyTime"] or activeVars["$sanctifyTime"] or activeVars["$holyWordSanctifyTime"]
		or activeVars["$hwSerenityTime"] or activeVars["$serenityTime"] or activeVars["$holyWordSerenityTime"]
		or activeVars["$hwSanctifyCharges"] or activeVars["$sanctifyCharges"] or activeVars["$holyWordSanctifyCharges"]
		or activeVars["$hwSerenityCharges"] or activeVars["$serenityCharges"] or activeVars["$holyWordSerenityCharges"] then
		local vbBuff = snapshots[spells.voidbinding.id].buff
		local vbRemaining = vbBuff.isActive and vbBuff.remaining or 0
		local cdrPercent = spells.voidbinding.attributes.cdrPercent
		local _hwChastiseTime = CalculatePredictedCooldownRemaining(
			snapshots[spells.holyWordChastise.id].cooldown.remaining, vbRemaining, cdrPercent)
		local _hwSanctifyTime = CalculatePredictedCooldownRemaining(
			snapshots[spells.holyWordSanctify.id].cooldown.remaining, vbRemaining, cdrPercent)
		local _hwSerenityTime = CalculatePredictedCooldownRemaining(
			snapshots[spells.holyWordSerenity.id].cooldown.remaining, vbRemaining, cdrPercent)
		local _hwSanctifyCharges = snapshots[spells.holyWordSanctify.id].cooldown.charges
		local _hwSerenityCharges = snapshots[spells.holyWordSerenity.id].cooldown.charges

		lookupLogic["$hwChastiseTime"] = _hwChastiseTime
		lookupLogic["$chastiseTime"] = _hwChastiseTime
		lookupLogic["$holyWordChastiseTime"] = _hwChastiseTime
		lookupLogic["$hwSanctifyTime"] = _hwSanctifyTime
		lookupLogic["$sanctifyTime"] = _hwSanctifyTime
		lookupLogic["$holyWordSanctifyTime"] = _hwSanctifyTime
		lookupLogic["$hwSerenityTime"] = _hwSerenityTime
		lookupLogic["$serenityTime"] = _hwSerenityTime
		lookupLogic["$holyWordSerenityTime"] = _hwSerenityTime
		lookupLogic["$hwSanctifyCharges"] = _hwSanctifyCharges
		lookupLogic["$sanctifyCharges"] = _hwSanctifyCharges
		lookupLogic["$holyWordSanctifyCharges"] = _hwSanctifyCharges
		lookupLogic["$hwSerenityCharges"] = _hwSerenityCharges
		lookupLogic["$serenityCharges"] = _hwSerenityCharges
		lookupLogic["$holyWordSerenityCharges"] = _hwSerenityCharges

		if lookupChanged(prevState, "$hwChastiseTime", _hwChastiseTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_hwChastiseTime)
			lookup["$hwChastiseTime"] = f
			lookup["$chastiseTime"] = f
			lookup["$holyWordChastiseTime"] = f
		end
		if lookupChanged(prevState, "$hwSanctifyTime", _hwSanctifyTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_hwSanctifyTime)
			lookup["$hwSanctifyTime"] = f
			lookup["$sanctifyTime"] = f
			lookup["$holyWordSanctifyTime"] = f
		end
		if lookupChanged(prevState, "$hwSerenityTime", _hwSerenityTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_hwSerenityTime)
			lookup["$hwSerenityTime"] = f
			lookup["$serenityTime"] = f
			lookup["$holyWordSerenityTime"] = f
		end
		if lookupChanged(prevState, "$hwSanctifyCharges", _hwSanctifyCharges) then
			local f = string.format("%.0f", _hwSanctifyCharges)
			lookup["$hwSanctifyCharges"] = f
			lookup["$sanctifyCharges"] = f
			lookup["$holyWordSanctifyCharges"] = f
		end
		if lookupChanged(prevState, "$hwSerenityCharges", _hwSerenityCharges) then
			local f = string.format("%.0f", _hwSerenityCharges)
			lookup["$hwSerenityCharges"] = f
			lookup["$serenityCharges"] = f
			lookup["$holyWordSerenityCharges"] = f
		end
	end

	-- Block C: Apotheosis ($apotheosisTime)
	if not activeVars or activeVars["$apotheosisTime"] then
		local currentTime = GetTime()
		local _apotheosisTime = snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)

		lookupLogic["$apotheosisTime"] = _apotheosisTime

		if lookupChanged(prevState, "$apotheosisTime", _apotheosisTime) then
			lookup["$apotheosisTime"] = TRB.Functions.BarText:TimerPrecision(_apotheosisTime)
		end
	end

	-- Block D: Lightweaver ($lightweaverStacks, $lightweaverTime)
	if not activeVars or activeVars["$lightweaverStacks"] or activeVars["$lightweaverTime"] then
		local currentTime = GetTime()
		local _lightweaverStacks = snapshots[spells.lightweaver.id].buff.applications or 0
		local _lightweaverTime = snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime) or 0

		lookupLogic["$lightweaverStacks"] = _lightweaverStacks
		lookupLogic["$lightweaverTime"] = _lightweaverTime

		if lookupChanged(prevState, "$lightweaverStacks", _lightweaverStacks) then
			lookup["$lightweaverStacks"] = string.format("%.0f", _lightweaverStacks)
		end
		if lookupChanged(prevState, "$lightweaverTime", _lightweaverTime) then
			lookup["$lightweaverTime"] = TRB.Functions.BarText:TimerPrecision(_lightweaverTime)
		end
	end

	-- Block E: Angelic Feather ($afTime, $angelicFeatherTime, $afCharges, $angelicFeatherCharges, $afMaxCharges, $angelicFeatherMaxCharges)
	if not activeVars or activeVars["$afTime"] or activeVars["$angelicFeatherTime"]
		or activeVars["$afCharges"] or activeVars["$angelicFeatherCharges"]
		or activeVars["$afMaxCharges"] or activeVars["$angelicFeatherMaxCharges"] then
		local _afTime = snapshots[spells.angelicFeather.id].cooldown.remaining
		local _afCharges = snapshots[spells.angelicFeather.id].cooldown.charges
		local _afMaxCharges = spells.angelicFeather.attributes.maxCharges

		lookupLogic["$afTime"] = _afTime
		lookupLogic["$angelicFeatherTime"] = _afTime
		lookupLogic["$afCharges"] = _afCharges
		lookupLogic["$angelicFeatherCharges"] = _afCharges
		lookupLogic["$afMaxCharges"] = _afMaxCharges
		lookupLogic["$angelicFeatherMaxCharges"] = _afMaxCharges

		if lookupChanged(prevState, "$afTime", _afTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_afTime)
			lookup["$afTime"] = f
			lookup["$angelicFeatherTime"] = f
		end
		if lookupChanged(prevState, "$afCharges", _afCharges) then
			local f = string.format("%.0f", _afCharges)
			lookup["$afCharges"] = f
			lookup["$angelicFeatherCharges"] = f
		end
		if lookupChanged(prevState, "$afMaxCharges", _afMaxCharges) then
			local f = string.format("%.0f", _afMaxCharges)
			lookup["$afMaxCharges"] = f
			lookup["$angelicFeatherMaxCharges"] = f
		end
	end

	-- Block F: Buff state ($surgeOfLight, $surgeOfLightStacks, $surgeOfLightStacksMax, $surgeOfLightTime, $benediction)
	if not activeVars or activeVars["$surgeOfLight"] or activeVars["$surgeOfLightStacks"]
		or activeVars["$surgeOfLightStacksMax"] or activeVars["$surgeOfLightTime"] or activeVars["$benediction"] then
		local surgeOfLightBuff = snapshotData.snapshots[spells.surgeOfLight.id]
		local _surgeOfLightActive = (surgeOfLightBuff ~= nil and surgeOfLightBuff.buff.isActive) or false
		local _surgeOfLightStacks = (_surgeOfLightActive and (surgeOfLightBuff.buff.applications or 0)) or 0
		local _surgeOfLightStacksMax = spells.surgeOfLight.maxStacks
		local _surgeOfLightTime = (_surgeOfLightActive and surgeOfLightBuff.buff.remaining) or 0
		lookupLogic["$surgeOfLight"] = _surgeOfLightActive
		lookupLogic["$surgeOfLightStacks"] = _surgeOfLightStacks
		lookupLogic["$surgeOfLightStacksMax"] = _surgeOfLightStacksMax
		lookupLogic["$surgeOfLightTime"] = _surgeOfLightTime
		lookup["$surgeOfLight"] = ""
		if lookupChanged(prevState, "$surgeOfLightStacks", _surgeOfLightStacks) then
			lookup["$surgeOfLightStacks"] = string.format("%.0f", _surgeOfLightStacks)
		end
		if lookupChanged(prevState, "$surgeOfLightStacksMax", _surgeOfLightStacksMax) then
			lookup["$surgeOfLightStacksMax"] = string.format("%.0f", _surgeOfLightStacksMax)
		end
		if lookupChanged(prevState, "$surgeOfLightTime", _surgeOfLightTime) then
			lookup["$surgeOfLightTime"] = TRB.Functions.BarText:TimerPrecision(_surgeOfLightTime)
		end
		lookupLogic["$benediction"] = snapshots[spells.benediction.id].buff.isActive or false
		lookup["$benediction"] = ""
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

local function RefreshLookupData_Shadow()
	local specSettings = TRB.Data.settings.priest.shadow
	local sharedSettings = TRB.Data.specCache["priest_shadow"].settings
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local targetData = snapshotData.targetData
	local target = targetData.targets[targetData.currentTargetGuid]
	local currentTime = GetTime()

	local lookup = TRB.Data.lookup or {}
	local lookupLogic = TRB.Data.lookupLogic or {}
	local prevState = TRB.Data.prevLookupState or {}
	local activeVars = TRB.Data.activeVariables

	-- Block A: Core resource ($insanity, $resource, $casting, $insanityMax, $resourceMax, $shadowWordMadnessUsable)
	if not activeVars or activeVars["$insanity"] or activeVars["$resource"] or activeVars["$casting"]
		or activeVars["$insanityMax"] or activeVars["$resourceMax"]
		or activeVars["$shadowWordMadnessUsable"] then

		-- Use the pre-formatted resource string (consumes secret at event time, normal here)
		local insanityFormatted = snapshotData.formatted.resource or ""
		local currentInsanityColor = sharedSettings.colors.text.current.color
		local castingInsanityColor = sharedSettings.colors.text.casting.color

		local _shadowWordMadnessUsable = spells.shadowWordMadness:IsUsable() or spells.shadowWordMadness:IsFree()

		if TRB.Data.character.inCombat then
			if sharedSettings.colors.text.overThreshold.enabled and _shadowWordMadnessUsable then
				currentInsanityColor = sharedSettings.colors.text.overThreshold.color
				--castingInsanityColor = sharedSettings.colors.text.overThreshold.color
			end
		end

		local resourcePrecision = math.min(sharedSettings.precision.resource, math.log10(TRB.Data.resourceFactor or 1))
		local _castingInsanity = snapshotData.casting.resourceFinal

		lookupLogic["$insanityMax"] = TRB.Data.character.maxResource
		lookupLogic["$insanity"] = snapshotData.attributes.resourceModified
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = snapshotData.attributes.resourceModified
		lookupLogic["$casting"] = _castingInsanity
		lookupLogic["$shadowWordMadnessUsable"] = _shadowWordMadnessUsable

		lookup["$insanityMax"] = TRB.Data.character.maxResource
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$shadowWordMadnessUsable"] = ""

		-- insanityFormatted is a normal string so lookupChanged can memoize (no isSecret)
		local insanityChanged = lookupChanged(prevState, "$insanity", insanityFormatted, currentInsanityColor)
		local castingChanged = lookupChanged(prevState, "$casting", _castingInsanity, castingInsanityColor)
		if insanityChanged or castingChanged then
			local currentInsanity
			local castingInsanity
			if sharedSettings.colors.text.overcap and sharedSettings.colors.text.overcap.enabled and TRB.Data.character.inCombat then
				local overcapTextCurve = Color:BuildResourceThresholdCurve(specSettings, currentInsanityColor, sharedSettings.colors.text.overcap.color)
				local textColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapTextCurve)
				currentInsanity = textColorResult:WrapTextInColorCode(insanityFormatted)
				castingInsanity = textColorResult:WrapTextInColorCode(TRB.Functions.Number:RoundTo(_castingInsanity, resourcePrecision, "floor"))
			else
				currentInsanity = string.format("|c%s%s|r", currentInsanityColor, insanityFormatted)
				castingInsanity = string.format("|c%s%s|r", castingInsanityColor, TRB.Functions.Number:RoundTo(_castingInsanity, resourcePrecision, "floor"))
			end
			lookup["$insanity"] = currentInsanity
			lookup["$resource"] = currentInsanity
			lookup["$casting"] = castingInsanity
		end
	end

	-- Block B: Voidform ($vfTime)
	if not activeVars or activeVars["$vfTime"] then
		local _voidformTime = snapshots[spells.voidform.id].buff:GetRemainingTime(currentTime)
		lookupLogic["$vfTime"] = _voidformTime
		if lookupChanged(prevState, "$vfTime", _voidformTime) then
			lookup["$vfTime"] = TRB.Functions.BarText:TimerPrecision(_voidformTime)
		end
	end

	-- Block C: Mind Flay Insanity ($mfiTime, $mfiStacks)
	if not activeVars or activeVars["$mfiTime"] or activeVars["$mfiStacks"] then
		local _mfiTime = 0
		local _mfiStacks = 0
		if snapshots[spells.mindFlayInsanity.id].buff.isActive then
			_mfiTime = snapshots[spells.mindFlayInsanity.id].buff:GetRemainingTime(currentTime)
			_mfiStacks = snapshots[spells.mindFlayInsanity.id].buff.applications or 0
		end
		lookupLogic["$mfiTime"] = _mfiTime
		lookupLogic["$mfiStacks"] = _mfiStacks
		if lookupChanged(prevState, "$mfiTime", _mfiTime) then
			lookup["$mfiTime"] = TRB.Functions.BarText:TimerPrecision(_mfiTime)
		end
		if lookupChanged(prevState, "$mfiStacks", _mfiStacks) then
			lookup["$mfiStacks"] = string.format("%.0f", _mfiStacks)
		end
	end

	-- Block D: Screams of the Void ($sotvTime)
	if not activeVars or activeVars["$sotvTime"] then
		local _sotvTime = 0
		if snapshots[spells.screamsOfTheVoid.id].buff.isActive then
			_sotvTime = snapshots[spells.screamsOfTheVoid.id].buff:GetRemainingTime(currentTime)
		end
		lookupLogic["$sotvTime"] = _sotvTime
		if lookupChanged(prevState, "$sotvTime", _sotvTime) then
			lookup["$sotvTime"] = TRB.Functions.BarText:TimerPrecision(_sotvTime)
		end
	end

	-- Block E: Entropic Rift ($entropicRiftTime, $entropicRiftExtensionsRemaining)
	if not activeVars or activeVars["$entropicRiftTime"] or activeVars["$entropicRiftExtensionsRemaining"] then
		local _entropicRiftTime = snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
		local entropicRiftExtensionsRemaining = snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] or 0
		lookupLogic["$entropicRiftTime"] = _entropicRiftTime
		lookupLogic["$entropicRiftExtensionsRemaining"] = entropicRiftExtensionsRemaining
		lookup["$entropicRiftExtensionsRemaining"] = entropicRiftExtensionsRemaining
		if lookupChanged(prevState, "$entropicRiftTime", _entropicRiftTime) then
			lookup["$entropicRiftTime"] = TRB.Functions.BarText:TimerPrecision(_entropicRiftTime)
		end
	end

	-- Block F: Mana ($mana, $manaMax, $manaPercent)
	if not activeVars or activeVars["$mana"] or activeVars["$manaMax"] or activeVars["$manaPercent"] then
		local currentManaColor = (sharedSettings.colors.text.manaBar and sharedSettings.colors.text.manaBar.color) or sharedSettings.colors.text.current.color
		local normalizedMana = UnitPower("player", Enum.PowerType.Mana)
		local normalizedManaMax = UnitPowerMax("player", Enum.PowerType.Mana)
		local manaPrecision = sharedSettings.precision.mana or 1
		local _manaPercent = UnitPowerPercent("player", Enum.PowerType.Mana)
		local manaPercentRaw = UnitPowerPercent("player", Enum.PowerType.Mana, false, CurveConstants.ScaleTo100)

		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$manaMax"] = normalizedManaMax
		lookupLogic["$manaPercent"] = _manaPercent
		local manaFormatted = TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedMana)
		if lookupChanged(prevState, "$mana", manaFormatted, currentManaColor) then
			lookup["$mana"] = string.format("|c%s%s|r", currentManaColor, manaFormatted)
		end
		local manaMaxFormatted = TRB.Functions.String:ConvertToAbbreviatedNumber(normalizedManaMax)
		if lookupChanged(prevState, "$manaMax", manaMaxFormatted, currentManaColor) then
			lookup["$manaMax"] = string.format("|c%s%s|r", currentManaColor, manaMaxFormatted)
		end
		local manaPercentFormatted = string.format("%." .. manaPrecision .. "f", manaPercentRaw)
		if lookupChanged(prevState, "$manaPercent", manaPercentFormatted, currentManaColor) then
			lookup["$manaPercent"] = string.format("|c%s%s|r", currentManaColor, manaPercentFormatted)
		end
	end

	-- Block G: Angelic Feather ($afTime, $angelicFeatherTime, $afCharges, $angelicFeatherCharges, $afMaxCharges, $angelicFeatherMaxCharges)
	if not activeVars or activeVars["$afTime"] or activeVars["$angelicFeatherTime"]
		or activeVars["$afCharges"] or activeVars["$angelicFeatherCharges"]
		or activeVars["$afMaxCharges"] or activeVars["$angelicFeatherMaxCharges"] then

		local _afTime = snapshots[spells.angelicFeather.id].cooldown.remaining
		local _afCharges = snapshots[spells.angelicFeather.id].cooldown.charges
		local _afMaxCharges = spells.angelicFeather.attributes.maxCharges

		lookupLogic["$afTime"] = _afTime
		lookupLogic["$angelicFeatherTime"] = _afTime
		lookupLogic["$afCharges"] = _afCharges
		lookupLogic["$angelicFeatherCharges"] = _afCharges
		lookupLogic["$afMaxCharges"] = _afMaxCharges
		lookupLogic["$angelicFeatherMaxCharges"] = _afMaxCharges

		if lookupChanged(prevState, "$afTime", _afTime) then
			local f = TRB.Functions.BarText:TimerPrecision(_afTime)
			lookup["$afTime"] = f
			lookup["$angelicFeatherTime"] = f
		end
		if lookupChanged(prevState, "$afCharges", _afCharges) then
			local f = string.format("%.0f", _afCharges)
			lookup["$afCharges"] = f
			lookup["$angelicFeatherCharges"] = f
		end
		if lookupChanged(prevState, "$afMaxCharges", _afMaxCharges) then
			local f = string.format("%.0f", _afMaxCharges)
			lookup["$afMaxCharges"] = f
			lookup["$angelicFeatherMaxCharges"] = f
		end
	end

	TRB.Data.lookup = lookup
	TRB.Data.lookupLogic = lookupLogic
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Discipline()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

--TODO: Remove?
local function UpdateCastingResourceFinal_Holy()
	-- Do nothing for now
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	
	snapshotData.casting.resourceFinal = snapshotData.casting.resourceRaw
end

local function UpdateCastingResourceFinal_Shadow()
	TRB.Data.snapshotData.casting.resourceFinal = CalculateResourceGain(TRB.Data.snapshotData.casting.resourceRaw)
end

---Handles UNIT_SPELLCAST_ events for the class
---@param event trbSpellCastType
---@param spellId integer
function TRB.Functions.Class:SpellCast(event, spellId)
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local casting = snapshotData.casting
	local currentTime = GetTime()

	-- Angelic Feather charge tracking (shared across all specs)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HealerSpells|TRB.Classes.Priest.ShadowSpells]]
		if spells.angelicFeather and spellId == spells.angelicFeather.id then
			local snapshots = snapshotData.snapshots
			if snapshots[spells.angelicFeather.id] then
				snapshots[spells.angelicFeather.id].cooldown:SpendCharge(spells.angelicFeather.duration)
			end
		end
	end

	if (TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2) and event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HealerSpells]]
		if spells.flashHeal ~= nil and spellId == spells.flashHeal.id then
			local snapshot = spells.surgeOfLight and snapshotData.snapshots
				and snapshotData.snapshots[spells.surgeOfLight.id]
			if snapshot ~= nil then
				snapshot.buff:ArmProcSpend(currentTime)
			end
		end
	end

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		local snapshots = snapshotData.snapshots
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()
			UpdateCastingResourceFinal_Discipline()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.evangelism.id then
				-- Evangelism triggers a free, automatic Power Word: Radiance cast that
				-- does NOT consume a charge. Record the timestamp so we can suppress the
				-- deferred PWR SpendCharge. Uses a time window instead of a flag+frame
				-- approach to avoid C_Timer.After(0) callback ordering issues.
				snapshotData.attributes.evangelismCastTime = GetTime()
			elseif spellId == spells.powerWordRadiance.id then
				-- Harsh Discipline: each Radiance grants a stack (timer refreshed on gain) empowering the next Penance.
				if talents:IsTalentActive(spells.harshDiscipline) then
					local hdBuff = snapshots[spells.harshDiscipline.id].buff
					hdBuff:AddStackOrInitializeCustom(spells.harshDiscipline.duration, currentTime, true)
				end
				-- Defer by one frame so the Evangelism timestamp is recorded regardless
				-- of which SUCCEEDED event fires first within the same frame.
				local castTime = currentTime
				C_Timer.After(0, function()
					local evangelismTime = snapshotData.attributes.evangelismCastTime
					-- Suppress if Evangelism was cast within a very short window (same frame batch).
					-- Any real manual PWR cast would be at least a GCD (~1.5s) later.
					if evangelismTime == nil or (castTime - evangelismTime) > 0.5 then
						local duration = spells.powerWordRadiance.duration
						if talents:IsTalentActive(spells.brightPupil) then
							duration = duration + spells.brightPupil.attributes.durationMod
						end
						-- Voidbinding CDR: cooldowns recover cdrPercent faster (rate model)
						if snapshots[spells.voidbinding.id].buff.isActive then
							duration = duration / (1 + spells.voidbinding.attributes.cdrPercent)
						end
						snapshots[spells.powerWordRadiance.id].cooldown:SpendCharge(duration)
					end
				end)
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		local snapshots = snapshotData.snapshots
		if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_DELAYED" then
			casting:SnapshotManaSpell()

			-- A proc gained partway through cannot empower a cast already in flight. Recorded on START
			-- only, so pushback (DELAYED) can't requalify one. Instants fire no START and stay nil.
			if event == "UNIT_SPELLCAST_START" then
				snapshotData.attributes.surgeOfLightAtCastStart = SurgeOfLightUsable(snapshotData, spells)
			end

			if spellId == spells.flashHeal.id then
				casting.spellKey = "flashHeal"
			elseif spellId == spells.benediction.id then
				casting.spellKey = "benediction"
			elseif spellId == spells.prayerOfHealing.id then
				casting.spellKey = "prayerOfHealing"
			elseif spellId == spells.smite.id then
				casting.spellKey = "smite"
			elseif talents:IsTalentActive(spells.voiceOfHarmony) then
				if spellId == spells.holyFire.id then --Voice of Harmony
					casting.spellKey = "holyFire"
				end
			end
			UpdateCastingResourceFinal_Holy()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.halo.id then
				if talents:IsTalentActive(spells.manifestedPower) then
					--TODO: Clean this up into something more automated
					if talents:IsTalentActive(spells.powerSurge) then
						local function SustainedPotencyStack()
							if talents:IsTalentActive(spells.sustainedPotency) then
								if snapshots[spells.apotheosis.id].buff.isActive then
									snapshots[spells.apotheosis.id].buff:AddTimeOrInitializeCustom(spells.sustainedPotency.attributes.durationMod)
								else
									snapshots[spells.sustainedPotency.id].buff:AddStackOrInitializeCustom(spells.sustainedPotency.duration, currentTime, true)
								end
							end

							if talents:IsTalentActive(spells.voiceOfHarmony) then
								local targetSpell = spells.holyWordSanctify
								local cooldown = snapshots[targetSpell.id].cooldown

								if talents:IsTalentActive(spells.ultimateSerenity) then
									targetSpell = spells.holyWordSerenity
									cooldown = snapshots[targetSpell.id].cooldown
								end

								if cooldown.onCooldown then
									local cdrAmount = CalculateHolyWordCooldown(spells.halo.holyWordReduction)
									cooldown:ReduceCooldown(cdrAmount)
								end
							end
						end

						SustainedPotencyStack()

						-- Death wipes the tracked buffs; pending pulses must not re-arm them.
						local deathCountAtCast = Character:GetDeathCount()
						C_Timer.After(0, function()
							C_Timer.After(spells.powerSurge.tickRate, function()
								if Character:GetDeathCount() ~= deathCountAtCast then
									return
								end
								SustainedPotencyStack()
							end)
							C_Timer.After((spells.powerSurge.tickRate * 2), function()
								if Character:GetDeathCount() ~= deathCountAtCast then
									return
								end
								SustainedPotencyStack()
							end)
							if talents:IsTalentActive(spells.energyConservation) then
								C_Timer.After((spells.powerSurge.tickRate * 3), function()
									if Character:GetDeathCount() ~= deathCountAtCast then
										return
									end
									SustainedPotencyStack()
								end)
							end
						end)
					end
				end
			elseif spellId == spells.apotheosis.id then
				local duration = spells.apotheosis.duration + snapshots[spells.sustainedPotency.id].buff.applications * spells.sustainedPotency.attributes.durationMod

				if talents:IsTalentActive(spells.eternalSanctity) then
					duration = duration + spells.eternalSanctity.attributes.durationMod
				end

 				snapshots[spells.sustainedPotency.id].buff:Reset()

				snapshots[spells.apotheosis.id].buff:InitializeCustom(duration, currentTime)
				snapshots[spells.apotheosis.id].buff.attributes["swmCasts"] = 0
				StartPausedIfOutOfCombat(snapshots[spells.apotheosis.id].buff)

				-- The free charge keeps the in-flight timer's progress, but the charge after it recharges in full.
				-- Settling first stops a charge that was already due from being dropped by this grant.
				for _, hwSpell in ipairs({ spells.holyWordSerenity, spells.holyWordSanctify, spells.holyWordChastise }) do
					local hwCooldown = snapshots[hwSpell.id].cooldown
					hwCooldown:SettleExpiredCharges()
					hwCooldown:GetRemainingTime(currentTime)
					hwCooldown:GainCharge(hwCooldown.remaining, CalculateHolyWordDuration(hwSpell))
				end
			elseif spellId == spells.holyWordSerenity.id then
				snapshots[spells.holyWordSerenity.id].cooldown:SpendCharge(CalculateHolyWordDuration(spells.holyWordSerenity))
			elseif spellId == spells.holyWordSanctify.id then
				snapshots[spells.holyWordSanctify.id].cooldown:SpendCharge(CalculateHolyWordDuration(spells.holyWordSanctify))
			elseif spellId == spells.holyWordChastise.id then
				snapshots[spells.holyWordChastise.id].cooldown:SpendCharge(CalculateHolyWordDuration(spells.holyWordChastise))
			end

			-- Holy Word cooldown reduction from supporting spells
			local cdrSpell = nil
			if spellId == spells.smite.id then
				cdrSpell = spells.smite
			elseif spellId == spells.holyNova.id then
				cdrSpell = spells.holyNova
			elseif spellId == spells.holyFire.id and talents:IsTalentActive(spells.voiceOfHarmony) then
				cdrSpell = spells.holyFire
			elseif spellId == spells.flashHeal.id then -- or spellId == spells.benediction.id then
				if spellId == spells.flashHeal.id then
					cdrSpell = spells.flashHeal
				else
					cdrSpell = spells.benediction
				end

				if SurgeOfLightEmpoweredCast(snapshotData, spells) and talents:IsTalentActive(spells.energyCycle) then
					local cooldownSpell = spells.holyWordSanctify

					if talents:IsTalentActive(spells.ultimateSerenity) then
						cooldownSpell = spells.holyWordSerenity
					end

					local cooldown = snapshots[cooldownSpell.id].cooldown
				
					if cooldown.onCooldown then
						local cdrAmount = CalculateHolyWordCooldown(spells.energyCycle.holyWordReduction)
						cooldown:ReduceCooldown(cdrAmount)
					end
				end

				if talents:IsTalentActive(spells.lightweaver) then
					snapshots[spells.lightweaver.id].buff:AddStackOrInitializeCustom(spells.lightweaver.duration, currentTime, true, 1)
				end
			elseif spellId == spells.benediction.id then
				cdrSpell = spells.benediction
				--NOTE: This is a bug. Remove the check and merge benediction in with 
				if talents:IsTalentActive(spells.energyCycle) and talents:IsTalentActive(spells.ultimateSerenity) then
					local cooldown = snapshots[spells.holyWordSerenity.id].cooldown
					local cdrAmount = CalculateHolyWordCooldown(spells.energyCycle.holyWordReduction)
					cooldown:ReduceCooldown(cdrAmount)
				end

				if talents:IsTalentActive(spells.lightweaver) then
					snapshots[spells.lightweaver.id].buff:AddStackOrInitializeCustom(spells.lightweaver.duration, currentTime, true, 1)
				end
			elseif spellId == spells.prayerOfHealing.id then
				cdrSpell = spells.prayerOfHealing

				if talents:IsTalentActive(spells.spiritwell) and SurgeOfLightEmpoweredCast(snapshotData, spells) and talents:IsTalentActive(spells.energyCycle) then
					local cooldownSpell = spells.holyWordSanctify
					local cdrAmount = 0

					if talents:IsTalentActive(spells.ultimateSerenity) then
						cooldownSpell = spells.holyWordSerenity
						-- NOTE: This is a bug. We gain 6sec CDR from Spiritwell + Ultimate Serenity, but it should only be 4sec.
						cdrAmount = CalculateHolyWordCooldown(spells.energyCycle.holyWordReduction * 1.5)
					else
						cdrAmount = CalculateHolyWordCooldown(spells.energyCycle.holyWordReduction)
					end

					local cooldown = snapshots[cooldownSpell.id].cooldown
					if cooldown.onCooldown then
						cooldown:ReduceCooldown(cdrAmount)
					end
				end

				if talents:IsTalentActive(spells.lightweaver) then
					snapshots[spells.lightweaver.id].buff:RemoveStack()
				end
			elseif spellId == spells.halo.id and talents:IsTalentActive(spells.voiceOfHarmony) and not talents:IsTalentActive(spells.powerSurge) then
				-- If Power Surge is talented, Halo CDR gets handled above.
				cdrSpell = spells.halo
			elseif spellId == spells.prayerOfMending.id and talents:IsTalentActive(spells.voiceOfHarmony) then
				cdrSpell = spells.prayerOfMending
			end

			if cdrSpell ~= nil then
				local hwSpell = cdrSpell --[[@as TRB.Classes.Priest.HolyWordSpell]]
				if hwSpell.holyWordKey ~= nil and hwSpell.holyWordReduction ~= nil then
					local targetSpell = spells[hwSpell.holyWordKey]

					if hwSpell.holyWordKey == "holyWordSanctify" and talents:IsTalentActive(spells.ultimateSerenity) then
						targetSpell = spells.holyWordSerenity
					end

					if targetSpell and talents:IsTalentActive(targetSpell) then
						local cooldown = snapshots[targetSpell.id].cooldown
						if cooldown.onCooldown then
							local cdrAmount = CalculateHolyWordCooldown(hwSpell.holyWordReduction)
							cooldown:ReduceCooldown(cdrAmount)
						end
					end
				end
			end

			snapshotData.attributes.surgeOfLightAtCastStart = nil
		elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" then
			-- A stale false would veto the next instant, which fires no START to overwrite it.
			snapshotData.attributes.surgeOfLightAtCastStart = nil
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local snapshots = snapshotData.snapshots
		if event == "UNIT_SPELLCAST_START" then
			if spellId == spells.mindBlast.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindBlast.resource
				casting.spellId = spells.mindBlast.id
				casting.icon = spells.mindBlast.icon
			elseif spellId == spells.vampiricTouch.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.vampiricTouch.resource
				casting.spellId = spells.vampiricTouch.id
				casting.icon = spells.vampiricTouch.icon
			elseif spellId == spells.voidform.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.voidform.resource
				casting.spellId = spells.voidform.id
				casting.icon = spells.voidform.icon
			elseif spellId == spells.mindgames.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindgames.resource
				casting.spellId = spells.mindgames.id
				casting.icon = spells.mindgames.icon
			elseif spellId == spells.halo.id then
				casting.startTime = currentTime
				casting.resourceRaw = spells.halo.resource
				casting.spellId = spells.halo.id
				casting.icon = spells.halo.icon
			elseif spellId == spells.voidBlast.id then
				casting.startTime = currentTime
				if talents:IsTalentActive(spells.voidInfusion) then
					casting.resourceRaw = spells.voidBlast.resource + spells.voidInfusion.attributes.resourceMod
				else
					casting.resourceRaw = spells.voidBlast.resource
				end
				casting.spellId = spells.voidBlast.id
				casting.icon = spells.voidBlast.icon
			end
			UpdateCastingResourceFinal_Shadow()
		elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
			if spellId == spells.mindFlay.id then
				casting.spellId = spells.mindFlay.id
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindFlay.resource
				casting.icon = spells.mindFlay.icon

				if talents:IsTalentActive(spells.surgeOfInsanity) then
					casting.resourceRaw = casting.resourceRaw * spells.surgeOfInsanity.attributes.resourceMod
				end

				-- If Mind Flay: Insanity is supposedly active but we're channeling Mind Flay, something got messed up in the buff tracking and we need to clear the buff
				if snapshots[spells.mindFlayInsanity.id].buff.isActive then
					snapshots[spells.mindFlayInsanity.id].buff:Reset()
				end
			elseif spellId == spells.mindFlayInsanity.castId then
				casting.spellId = spells.mindFlayInsanity.castId
				casting.startTime = currentTime
				casting.resourceRaw = spells.mindFlayInsanity.resource
				casting.icon = spells.mindFlayInsanity.icon

				snapshots[spells.mindFlayInsanity.id].buff:RemoveStack()
			elseif spellId == spells.voidTorrent.id then
				casting.spellId = spells.voidTorrent.id
				casting.startTime = currentTime
				casting.resourceRaw = spells.voidTorrent.resource
				casting.icon = spells.voidTorrent.icon

				snapshots[spells.entropicRift.id].buff:InitializeCustom(spells.entropicRift.duration, currentTime)
				if talents:IsTalentActive(spells.darkeningHorizon) then
					snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] = spells.darkeningHorizon.attributes["maxExtensions"]
				else
					snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] = 0
				end
			end
			UpdateCastingResourceFinal_Shadow()
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			if spellId == spells.halo.id then
				local function SustainedPotencyStack()
					if talents:IsTalentActive(spells.sustainedPotency) then
						if snapshots[spells.voidform.id].buff.isActive then
							snapshots[spells.voidform.id].buff:AddTimeOrInitializeCustom(spells.sustainedPotency.attributes.durationMod)
						else
							snapshots[spells.sustainedPotency.id].buff:AddStackOrInitializeCustom(spells.sustainedPotency.duration, currentTime, true)
						end
					end
				end

				SustainedPotencyStack()
				if talents:IsTalentActive(spells.manifestedPower) or talents:IsTalentActive(spells.sustainedPotency) then
					if talents:IsTalentActive(spells.manifestedPower) then
						snapshots[spells.mindFlayInsanity.id].buff:InitializeCustom(spells.mindFlayInsanity.duration, currentTime, true)
					end

					--TODO: Clean this up into something more automated
					if talents:IsTalentActive(spells.powerSurge) then
						-- Death wipes the tracked buffs; pending pulses must not re-arm them.
						local deathCountAtCast = Character:GetDeathCount()
						C_Timer.After(0, function()
							C_Timer.After(spells.powerSurge.tickRate, function()
								if Character:GetDeathCount() ~= deathCountAtCast then
									return
								end
								if talents:IsTalentActive(spells.manifestedPower) then
									snapshots[spells.mindFlayInsanity.id].buff:AddStackOrInitializeCustom(spells.mindFlayInsanity.duration, currentTime + spells.powerSurge.tickRate, true)
								end
								SustainedPotencyStack()
							end)
							C_Timer.After((spells.powerSurge.tickRate * 2), function()
								if Character:GetDeathCount() ~= deathCountAtCast then
									return
								end
								if talents:IsTalentActive(spells.manifestedPower) then
									snapshots[spells.mindFlayInsanity.id].buff:AddStackOrInitializeCustom(spells.mindFlayInsanity.duration, currentTime + (spells.powerSurge.tickRate * 2), true)
								end
								SustainedPotencyStack()
							end)
							if talents:IsTalentActive(spells.energyConservation) then
								C_Timer.After((spells.powerSurge.tickRate * 3), function()
								if Character:GetDeathCount() ~= deathCountAtCast then
									return
								end
								if talents:IsTalentActive(spells.manifestedPower) then
									snapshots[spells.mindFlayInsanity.id].buff:AddStackOrInitializeCustom(spells.mindFlayInsanity.duration, currentTime + (spells.powerSurge.tickRate * 3), true)
								end
								SustainedPotencyStack()
								end)
							end
						end)
					end
				end
			elseif spellId == spells.voidform.id then
				local duration = spells.voidform.duration + snapshots[spells.sustainedPotency.id].buff.applications * spells.sustainedPotency.attributes.durationMod
 				snapshots[spells.sustainedPotency.id].buff:Reset()

				snapshots[spells.voidform.id].buff:InitializeCustom(duration, currentTime)
				snapshots[spells.voidform.id].buff.attributes["swmCasts"] = 0
				StartPausedIfOutOfCombat(snapshots[spells.voidform.id].buff)
			elseif spellId == spells.shadowWordMadness.castId then
				if talents:IsTalentActive(spells.screamsOfTheVoid) then
					snapshots[spells.screamsOfTheVoid.id].buff:AddTimeOrInitializeCustom(spells.screamsOfTheVoid.duration, currentTime)
				end

				if snapshots[spells.voidform.id].buff.isActive and talents:IsTalentActive(spells.ancientMadness) and snapshots[spells.voidform.id].buff.attributes["swmCasts"] < spells.ancientMadness.attributes.maxCasts then
					local increasedDuration = spells.ancientMadness.attributes.durationMod
					snapshots[spells.voidform.id].buff:AddTimeOrInitializeCustom(increasedDuration)
					snapshots[spells.voidform.id].buff.attributes["swmCasts"] = snapshots[spells.voidform.id].buff.attributes["swmCasts"] + 1
				end
			elseif spellId == spells.tentacleSlam.castId then
				if talents:IsTalentActive(spells.screamsOfTheVoid) and talents:IsTalentActive(spells.maddeningTentacles) then
					local deathCountAtCast = Character:GetDeathCount()
					C_Timer.After((spells.tentacleSlam.attributes.delay), function()
						if Character:GetDeathCount() ~= deathCountAtCast then
							return
						end
						snapshots[spells.screamsOfTheVoid.id].buff:AddTimeOrInitializeCustom(spells.screamsOfTheVoid.duration, currentTime+spells.tentacleSlam.attributes.delay)
					end)
				end
			elseif spellId == spells.voidBlast.id then
				snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime) -- Force update of remaining time before checking
				if talents:IsTalentActive(spells.darkeningHorizon) and snapshots[spells.entropicRift.id].buff.isActive and snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] > 0 then
					snapshots[spells.entropicRift.id].buff:AddTimeOrInitializeCustom(spells.darkeningHorizon.duration, currentTime)
					snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] = snapshots[spells.entropicRift.id].buff.attributes["extensionsRemaining"] - 1
				end
			end
		end
	end
end

-- One overlay artwork per Surge of Light stack (see overlayIds on the spell definition). The set
-- only answers "is any stack still up", which is what separates a full loss from a spend.
---@type table<integer, boolean>
local surgeOfLightVisibleOverlays = {}

---@param snapshotData TRB.Classes.SnapshotData
---@param spells TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells
---@return integer
local function GetSurgeOfLightStacks(snapshotData, spells)
	local snapshot = spells.surgeOfLight and snapshotData.snapshots
		and snapshotData.snapshots[spells.surgeOfLight.id]
	if snapshot == nil or not snapshot.buff.isActive then
		return 0
	end
	return snapshot.buff.applications or 0
end

---Fires the Surge of Light stack cues. Stacks are Lua-tracked, so the two-stack cue wins when a proc
---takes you straight to two, and the one-stack cue can offer a play-on-drop for spending back to one.
---@param specSettings table
---@param snapshotData TRB.Classes.SnapshotData
---@param spells TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells
local function FireSurgeOfLightCues(specSettings, snapshotData, spells)
	local spiritwellActive = (talents ~= nil and spells.spiritwell ~= nil
		and talents:IsTalentActive(spells.spiritwell)) or false

	---Holy's Spiritwell gate is per cue, so each one silences only itself.
	---@param cueId string
	---@return boolean
	local function CanPlay(cueId)
		local cue = specSettings.audio and specSettings.audio[cueId]
		local configuration = cue and cue.configuration
		if configuration ~= nil and configuration.requireSpiritwellTalent then
			return spiritwellActive
		end
		return true
	end

	TRB.Functions.AudioCues:FireValueGroup(specSettings, snapshotData, "surgeOfLightStacks",
		GetSurgeOfLightStacks(snapshotData, spells), {
			{ id = "surgeOfLight", threshold = 1, canPlay = CanPlay("surgeOfLight") },
			{ id = "surgeOfLight2", threshold = 2, canPlay = CanPlay("surgeOfLight2") },
		})
end

---Keeps Surge of Light readable as active for the rest of the frame batch that dropped it.
---@param snapshotData TRB.Classes.SnapshotData
local function StartSurgeOfLightGrace(snapshotData)
	snapshotData.attributes.surgeOfLightActiveGrace = true
	C_Timer.After(0.05, function()
		snapshotData.attributes.surgeOfLightActiveGrace = false
	end)
end

---Drops everything the manual tracker banked. Manual tracking only runs while a healer spec is
---played, so anything held over a spec change is stale.
local function ResetSurgeOfLightTracking()
	wipe(surgeOfLightVisibleOverlays)
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
	local snapshot = spells and spells.surgeOfLight and snapshotData.snapshots
		and snapshotData.snapshots[spells.surgeOfLight.id]
	if snapshot ~= nil then
		snapshot.buff:Reset()
		snapshot.buff:ResetProcCharges()
	end
	snapshotData.attributes.surgeOfLightActiveGrace = false
	snapshotData.attributes.surgeOfLightAtCastStart = nil
	TRB.Functions.AudioCues:ResetLatch(snapshotData, "surgeOfLight")
	TRB.Functions.AudioCues:ResetLatch(snapshotData, "surgeOfLight2")
end

---Every Surge of Light stack change fires SPELL_UPDATE_USES on Flash Heal, not on the buff itself.
---@param spellId integer?
local function HandleSurgeOfLightEvent(spellId)
	if TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 then return end

	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
	if not (spells and spells.flashHeal and spells.surgeOfLight) then return end
	if spellId ~= spells.flashHeal.id then return end

	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshot = snapshotData and snapshotData.snapshots and snapshotData.snapshots[spells.surgeOfLight.id]
	if snapshot == nil then return end

	local outcome = snapshot.buff:HandleProcChargeEvent()
	if outcome == "spend" or outcome == "expire" then
		-- The Holy Word CDR path reads the buff on UNIT_SPELLCAST_SUCCEEDED, which can land after
		-- this; the grace keeps the cast that burned the charge from missing it.
		StartSurgeOfLightGrace(snapshotData)
		if not snapshot.buff.isActive then
			TRB.Functions.AudioCues:ResetLatch(snapshotData, "surgeOfLight")
			TRB.Functions.AudioCues:ResetLatch(snapshotData, "surgeOfLight2")
		end
	end

	TRB.Data.lookupDirty = true
	if TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

---Updates data based on spell events
local function HandleSpellEvents(self, event, ...)
	if event == "SPELL_UPDATE_USES" then
		local spellId = ...
		HandleSurgeOfLightEvent(spellId)
	elseif event == "SPELL_ACTIVATION_OVERLAY_SHOW" or event == "SPELL_ACTIVATION_OVERLAY_HIDE" then
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		local spellId = ...
		local isShow = event == "SPELL_ACTIVATION_OVERLAY_SHOW"
		if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
			-- Flag only: a hide-all carries no spell id and is always followed by a re-show of whatever is
			-- still up, and leaving the stack count to SPELL_UPDATE_USES keeps a misread from wiping it.
			if spellId ~= nil and spells.surgeOfLight.attributes.overlayIds[spellId] then
				surgeOfLightVisibleOverlays[spellId] = isShow or nil
				local surgeOfLightSnapshot = snapshotData.snapshots[spells.surgeOfLight.id]
				if surgeOfLightSnapshot ~= nil then
					surgeOfLightSnapshot.buff:SetProcOverlay(next(surgeOfLightVisibleOverlays) ~= nil)
				end
			end
		elseif TRB.Data.character.specId == 3 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
			if spellId == spells.shadowyInsight.id then
				snapshotData.attributes.shadowyInsightActive = isShow
			end
		end
	elseif event == "COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED" then
		local spellId, rSpellId = ...
		local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
		if TRB.Data.character.specId == 1 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
			if spellId == spells.powerWordShield.id then
				if rSpellId == nil or rSpellId ~= spells.masterTheDarkness.id then
					snapshotData.snapshots[spells.masterTheDarkness.id].buff:Reset()
					-- Keep isCustom so RefreshAllBuffs() won't re-detect the game aura
					snapshotData.snapshots[spells.masterTheDarkness.id].buff.isCustom = true
					TRB.Data.lookupDirty = true
				elseif rSpellId == spells.masterTheDarkness.id then
					snapshotData.snapshots[spells.masterTheDarkness.id].buff:AddTimeOrInitializeCustom(spells.masterTheDarkness.duration, GetTime())
				end
			end
		elseif TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
			if spellId == spells.flashHeal.id then
				local benedictionBuff = snapshotData.snapshots[spells.benediction.id].buff
				if rSpellId == nil or rSpellId ~= spells.benediction.id then
					benedictionBuff:Reset()
					benedictionBuff.isCustom = true
					TRB.Functions.AudioCues:ResetLatch(snapshotData, "benediction")
				else
					benedictionBuff:AddTimeOrInitializeCustom(spells.benediction.duration, GetTime())
					TRB.Functions.AudioCues:Fire(TRB.Data.settings.priest.holy, snapshotData, "benediction", true)
				end
			end
		end
	end
end


local spellEventFrame = CreateFrame("Frame")
spellEventFrame:SetScript("OnEvent", HandleSpellEvents)

function TRB.Functions.Class:EnableEvents()
	spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW")
	spellEventFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE")
	spellEventFrame:RegisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
	-- Surge of Light is a healer proc; toggled both ways because EventRegistration reaches here
	-- without a DisableEvents() first when moving between supported specs.
	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 then
		spellEventFrame:RegisterEvent("SPELL_UPDATE_USES")
	else
		spellEventFrame:UnregisterEvent("SPELL_UPDATE_USES")
	end
end

function TRB.Functions.Class:DisableEvents()
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW")
	spellEventFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE")
	spellEventFrame:UnregisterEvent("COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED")
	spellEventFrame:UnregisterEvent("SPELL_UPDATE_USES")
end

local function UpdateSnapshot()
	Character:UpdateSnapshot()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells|TRB.Classes.Priest.ShadowSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	snapshots[spells.angelicFeather.id].cooldown:Refresh(true)
end

local function UpdateSnapshot_Healers()
	local _
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	local surgeOfLight = snapshots[spells.surgeOfLight.id]
	if surgeOfLight ~= nil then
		surgeOfLight.buff:RefreshProcCharges()
	end

	-- Track Flash Heal mana cost to detect Surge of Light via cost reduction
	local currentFlashHealCost = spells.flashHeal:GetPrimaryResourceCost(true) or 0
	if currentFlashHealCost > 0 then
		local baseManaCost = spells.flashHeal.attributes.baseManaCost
		if baseManaCost == nil then
			-- First time seeing a non-zero cost, store it
			spells.flashHeal.attributes.baseManaCost = currentFlashHealCost
		elseif currentFlashHealCost >= baseManaCost * 2 then
			-- We captured a reduced cost initially, overwrite with the higher (true base) cost
			spells.flashHeal.attributes.baseManaCost = currentFlashHealCost
		end
	end

	if IsInVoidbindingKeyRange() then
		-- 1. Capture last known good offensive vers (before it becomes secret).
		local liveVers = GetCombatRatingBonus(29)
		if not issecretvalue(liveVers) and type(liveVers) == "number" and liveVers > 0 then
			lastKnownVersOffensive = liveVers
		end

		-- 2. Parse the healing value from Prayer of Mending's spell description.
		local desc = C_Spell.GetSpellDescription(33076)
		local currentHealing = TRB.Functions.String:ParseFirstNumber(desc)

		if currentHealing and previousDescriptionHealing
			and currentHealing ~= previousDescriptionHealing
			and lastKnownVersOffensive and lastKnownVersOffensive > 0
			and not snapshots[spells.voidbinding.id].buff.isActive then
			-- 3. Normalize both values by dividing out the known vers, then compute
			--    the percentage increase. If it matches the Voidbinding vers within
			--    +/- 1%, flag the buff as gained.
			local versDivisor = 1 + lastKnownVersOffensive / 100
			local prevNorm = previousDescriptionHealing / versDivisor
			local currNorm = currentHealing / versDivisor
			local diffPercent = (currNorm - prevNorm) / prevNorm * 100
			local expectedPercent = spells.voidbinding.attributes.versPercent * 100

			--[[print("VB Detection: prev=" .. previousDescriptionHealing .. " curr=" .. currentHealing
				.. " vers=" .. string.format("%.2f", lastKnownVersOffensive)
				.. " diffPct=" .. string.format("%.2f", diffPercent)
				.. " expected=" .. expectedPercent)]]

			if math.abs(diffPercent - expectedPercent) <= 1 then
				snapshots[spells.voidbinding.id].buff:InitializeCustom(spells.voidbinding.duration, GetTime())
				ApplyVoidbindingCDR(true)
				--print("Voidbinding DETECTED via tooltip: +" .. string.format("%.2f", diffPercent) .. "% vers")
			end
			-- Don't detect loss -- let the buff timer expire naturally.
		end

		if currentHealing then
			previousDescriptionHealing = currentHealing
		end
	end
end

local function UpdateSnapshot_Voidweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells|TRB.Classes.Priest.ShadowSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots
	local entropicRift = snapshots[spells.entropicRift.id]
	
	if entropicRift.buff.isActive then
		entropicRift.buff:GetRemainingTime()
		if not entropicRift.buff.isActive then
			entropicRift.buff.attributes["extensionsRemaining"] = 0
		end
	end
end

local function UpdateSnapshot_Discipline()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Healers()
	--UpdateSnapshot_Voidweaver()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	--[[snapshots[spells.shadowCovenant.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)]]

	snapshots[spells.masterTheDarkness.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.powerWordRadiance.id].cooldown:Refresh(true)

	-- Voidbinding buff natural expiry
	local wasVoidbindingActive = snapshots[spells.voidbinding.id].buff.isActive
	snapshots[spells.voidbinding.id].buff:GetRemainingTime(currentTime)
	if wasVoidbindingActive and not snapshots[spells.voidbinding.id].buff.isActive then
		ApplyVoidbindingCDR(false)
	end
end

local function UpdateSnapshot_Holy()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Healers()
	
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	snapshots[spells.apotheosis.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.sustainedPotency.id].buff:GetRemainingTime(currentTime)

	-- Track Lightweaver active→inactive transition so that bar text gets one final
	-- refresh when the buff expires out of combat.  Without this, the early-out in
	-- UpdateResourceBarText (HasActiveTimers() == false) prevents RefreshLookupData
	-- from clearing the stale $lightweaverStacks / $lightweaverTime values.
	local wasLightweaverActive = snapshots[spells.lightweaver.id].buff.isActive
	snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime)
	if wasLightweaverActive and not snapshots[spells.lightweaver.id].buff.isActive then
		TRB.Data.lookupDirty = true
	end

	snapshots[spells.holyWordSerenity.id].cooldown:Refresh(true)
	snapshots[spells.holyWordSanctify.id].cooldown:Refresh(true)
	snapshots[spells.holyWordChastise.id].cooldown:Refresh()

	-- Voidbinding buff natural expiry
	local wasVoidbindingActive = snapshots[spells.voidbinding.id].buff.isActive
	snapshots[spells.voidbinding.id].buff:GetRemainingTime(currentTime)
	if wasVoidbindingActive and not snapshots[spells.voidbinding.id].buff.isActive then
		ApplyVoidbindingCDR(false)
	end

	-- Benediction buff natural expiry (handled by the Snapshot's buff timer).
	local wasBenedictionActive = snapshots[spells.benediction.id].buff.isActive
	snapshots[spells.benediction.id].buff:GetRemainingTime(currentTime)
	if wasBenedictionActive and not snapshots[spells.benediction.id].buff.isActive then
		TRB.Functions.AudioCues:ResetLatch(TRB.Data.snapshotData, "benediction")
		TRB.Data.lookupDirty = true
	end
end

local function UpdateSnapshot_Shadow()
	local currentTime = GetTime()
	UpdateSnapshot()
	UpdateSnapshot_Voidweaver()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	snapshots[spells.mindFlayInsanity.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.sustainedPotency.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.voidform.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.mindDevourer.id].buff:GetRemainingTime(currentTime)
	snapshots[spells.entropicRift.id].buff:GetRemainingTime(currentTime)
	--snapshots[spells.mindBlast.id].cooldown:Refresh()
end


-- Reused per-tick scratch tables for UpdateResourceBar (see conditionMap/barColorMap sites).
-- Held in one table so UpdateResourceBar gains a single upvalue rather than one per site.
local scratch = {
	conditionMap1 = {},
	manaBarColors1 = {},
	powerWordsBarColors1 = {},
	barColorMap1 = {},
	conditionMap2 = {},
	manaBarColors2 = {},
	holyWordsBarColors1 = {},
	lightweaverBarColors1 = {},
	barColorMap2 = {},
	conditionMap3 = {},
	insanityBarColors1 = {},
	manaBarColors3 = {},
	barColorMap3 = {},
	overcapCurvesInsanity1 = {},
	overcapCurvesMana1 = {},
}

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.priest
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]

	-- Always call HideResourceBar first to ensure visibility is correctly determined
	-- even if we return early due to missing data
	Bar:HideResourceBar()

	if not (barGroups and barGroups.primary) then
		return
	end

	local primaryNode = barGroups.primary:GetNode(1)
	if primaryNode == nil then
		return
	end

	if TRB.Data.character.maxResource == nil then
		return
	end

	if snapshotData.attributes == nil or snapshotData.attributes.resourceModified == nil then
		return
	end

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		local specSettings = classSettings.discipline
		local specCacheSettings = TRB.Data.specCache.priest_discipline.settings
		local displaySettings = specCacheSettings.displayBar or specSettings.displayBar
		UpdateSnapshot_Discipline()
		if snapshotData.attributes.isTracking then
			-- Build indicator condition map (shared across primary and secondary bar blocks)
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			local surgeOfLightStacks = GetSurgeOfLightStacks(snapshotData, spells)
			local conditionMap = scratch.conditionMap1
			wipe(conditionMap)
			conditionMap.surgeOfLight = surgeOfLightStacks >= 1
			conditionMap.surgeOfLight2 = surgeOfLightStacks >= 2
			conditionMap.voidShield = snapshotData.snapshots[spells.masterTheDarkness.id].buff.isActive

			-- Color targets: barKey -> elementKey -> current color
			local manaBarColors = scratch.manaBarColors1
			wipe(manaBarColors)
			manaBarColors.bar = specSettings.colors.bar.base
			manaBarColors.border = specSettings.colors.bar.border.color
			manaBarColors.background = specSettings.colors.bar.background.color
			local powerWordsBarColors = scratch.powerWordsBarColors1
			wipe(powerWordsBarColors)
			powerWordsBarColors.bar = specSettings.colors.comboPoints.powerWordRadiance
			powerWordsBarColors.border = specSettings.colors.comboPoints.border.color
			powerWordsBarColors.background = specSettings.colors.comboPoints.background.color
			local barColorMap = scratch.barColorMap1
			wipe(barColorMap)
			barColorMap.manaBar = manaBarColors
			barColorMap.powerWordsBar = powerWordsBarColors

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor
				
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")

				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				primaryNode:SetBorderColor(manaBarColors.border)
				TRB.Functions.Color:ApplyFillColor(primaryNode, manaBarColors.bar)
				primaryNode:SetBackgroundColorFromString(manaBarColors.background)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			-- Update Power Words secondary bar
			if not specSettings.displayBar.secondary.neverShow then
				local cpBorderColor = specSettings.colors.comboPoints.border.color
				local currentCp = 1

				if talents:IsTalentActive(spells.powerWordRadiance) and specSettings.colors.comboPoints.powerWordRadiance.enabled then
					local cooldown = snapshots[spells.powerWordRadiance.id].cooldown
					local charges = cooldown.manualCharges or 0
					local maxCharges = cooldown.manualMaxCharges or 1

					for chargeIndex = 1, maxCharges do
						if barGroups and barGroups.secondary then
							local cpNode = barGroups.secondary:GetNode(currentCp)
							if cpNode then
								local cpColor = specSettings.colors.comboPoints.powerWordRadiance
								local cpKey = "comboPoint" .. currentCp
								if chargeIndex <= charges then
									-- Available charge: full bar
									cpNode:ClearTimerDuration()
									Bar:SetBarNodeValue(specCacheSettings, cpKey, cpNode, 1, 1)
								elseif chargeIndex == charges + 1 and cooldown:IsRechargingManual() and cooldown.manualCooldownExpires ~= nil then
									-- Currently recharging: manual timer-based progress
									cpNode:ClearTimerDuration()
									local progress = cooldown:GetManualCooldownProgress(currentTime)
									TRB.Data.cache.values.bar[cpKey] = nil
									Bar:SetBarNodeValue(specCacheSettings, cpKey, cpNode, progress, 1)
								else
									-- Empty charge (not yet recharging)
									cpNode:ClearTimerDuration()
									TRB.Data.cache.values.bar[cpKey] = nil
									Bar:SetBarNodeValue(specCacheSettings, cpKey, cpNode, 0, 1)
								end
								TRB.Functions.Color:ApplyFillColor(cpNode, powerWordsBarColors.bar)
								cpNode:SetBorderColor(powerWordsBarColors.border)
								cpNode:SetBackgroundColorFromString(powerWordsBarColors.background)
								Bar:ApplyEndCapIndicator(cpNode, "powerWordsBar")
								currentCp = currentCp + 1
							end
						end
					end
				end
			end

			-- Update health bar
			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end

			-- Update utility bar (Angelic Feather charges)
			if displaySettings.utility ~= nil and not displaySettings.utility.neverShow and barGroups and barGroups.utility then
				if talents:IsTalentActive(spells.angelicFeather) then
					refreshText = true
					local cooldown = snapshots[spells.angelicFeather.id].cooldown
					local charges = cooldown.manualCharges or 0
					local maxCharges = spells.angelicFeather.attributes.maxCharges
					local utilityColors = specSettings.colors.bars.utility

					for chargeIndex = 1, maxCharges do
						local utilNode = barGroups.utility:GetNode(chargeIndex)
						if utilNode then
							local nodeKey = "utility" .. chargeIndex
							local nodeColorKey = "angelicFeather" .. chargeIndex
							local nodeColor = utilityColors.nodeColors and utilityColors.nodeColors[nodeColorKey] or "FFFFD700"
							-- sameColor: use highest filled charge's color for all filled nodes
							if utilityColors.sameColor and chargeIndex <= charges and charges > 0 then
								local highestKey = "angelicFeather" .. charges
								nodeColor = utilityColors.nodeColors and utilityColors.nodeColors[highestKey] or nodeColor
							end
							if chargeIndex <= charges then
								utilNode:ClearTimerDuration()
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, 1, 1)
							elseif chargeIndex == charges + 1 and cooldown:IsRechargingManual() and cooldown.manualCooldownExpires ~= nil then
								utilNode:ClearTimerDuration()
								local progress = cooldown:GetManualCooldownProgress(currentTime)
								TRB.Data.cache.values.bar[nodeKey] = nil
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, progress, 1)
							else
								utilNode:ClearTimerDuration()
								TRB.Data.cache.values.bar[nodeKey] = nil
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, 0, 1)
							end
							TRB.Functions.Color:ApplyFillColor(utilNode, nodeColor)
							utilNode:SetBorderColor(utilityColors.border.color)
							utilNode:SetBackgroundColorFromString(utilityColors.background.color)
						end
					end
				end
			end
		end

		-- Surge of Light audio cues (independent of bar visibility)
		FireSurgeOfLightCues(specSettings, snapshotData, spells)

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		local specSettings = classSettings.holy
		local specCacheSettings = TRB.Data.specCache.priest_holy.settings
		local displaySettings = specCacheSettings.displayBar or specSettings.displayBar
		UpdateSnapshot_Holy()
		if snapshotData.attributes.isTracking then
			local holyWordCooldownCompletesKey = nil

			if snapshotData.casting.spellKey ~= nil then
				local maybeHolyWordSpell = spells[snapshotData.casting.spellKey]--[[@as TRB.Classes.Priest.HolyWordSpell]]
				if maybeHolyWordSpell ~= nil and
					maybeHolyWordSpell.holyWordKey ~= nil and
					maybeHolyWordSpell.holyWordReduction ~= nil and
					maybeHolyWordSpell.holyWordReduction >= 0 then

					-- Ultimate Serenity redirects Sanctify CDR to Serenity
					local effectiveHolyWordKey = maybeHolyWordSpell.holyWordKey
					if effectiveHolyWordKey == "holyWordSanctify" and talents:IsTalentActive(spells.ultimateSerenity) then
						effectiveHolyWordKey = "holyWordSerenity"
					end

					local reduction = maybeHolyWordSpell.holyWordReduction

					--NOTE: This is to handle the bug of always getting Energy Cycle CDR.
					if maybeHolyWordSpell.id == spells.benediction.id and talents:IsTalentActive(spells.energyCycle) and talents:IsTalentActive(spells.ultimateSerenity) then
						reduction = reduction + spells.energyCycle.holyWordReduction
					end

					if talents:IsTalentActive(spells[effectiveHolyWordKey]) then
						local castTimeRemains = snapshotData.casting.endTime - currentTime
						local holyWordCooldownRemaining = snapshots[spells[effectiveHolyWordKey].id].cooldown:GetRemainingTime(currentTime)
						local calcHolyWordCooldown = CalculateHolyWordCooldown(reduction)

						if (holyWordCooldownRemaining - calcHolyWordCooldown - castTimeRemains) <= 0 then
							holyWordCooldownCompletesKey = effectiveHolyWordKey
						end
					end
				end
			end

			-- Build indicator condition map (hoisted above primary/HW/LW blocks so all share these)
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors
			local nodeOrder = sharedColors and sharedColors.nodeOrder

			-- Precompute apotheosis end timing threshold
			local apotheosisActive = snapshots[spells.apotheosis.id].buff.isActive
			local apotheosisEndMet = false
			if apotheosisActive then
				local timeLeft = snapshots[spells.apotheosis.id].buff.remaining
				local timeThreshold = 0
				if specSettings.endOf.apotheosis.mode == "gcd" then
					local gcd = Character:GetCurrentGCDTime()
					timeThreshold = gcd * specSettings.endOf.apotheosis.gcdsMax
				elseif specSettings.endOf.apotheosis.mode == "time" then
					timeThreshold = specSettings.endOf.apotheosis.timeMax
				end
				apotheosisEndMet = timeLeft <= timeThreshold
			end

			local surgeOfLightStacks = GetSurgeOfLightStacks(snapshotData, spells)
			local conditionMap = scratch.conditionMap2
			wipe(conditionMap)
			conditionMap.benediction = snapshots[spells.benediction.id].buff.isActive
			conditionMap.holyWordSerenity = holyWordCooldownCompletesKey == "holyWordSerenity"
			conditionMap.holyWordSanctify = holyWordCooldownCompletesKey == "holyWordSanctify"
			conditionMap.holyWordChastise = holyWordCooldownCompletesKey == "holyWordChastise"
			conditionMap.apotheosisEnd = apotheosisActive and apotheosisEndMet
			conditionMap.apotheosis = apotheosisActive
			conditionMap.surgeOfLight = surgeOfLightStacks >= 1
			conditionMap.surgeOfLight2 = surgeOfLightStacks >= 2
			conditionMap.lightweaver = snapshots[spells.lightweaver.id].buff.isActive

			-- Color targets: barKey -> elementKey -> current color
			local manaBarColors = scratch.manaBarColors2
			wipe(manaBarColors)
			manaBarColors.bar = specSettings.colors.bar.base
			manaBarColors.border = specSettings.colors.bar.border.color
			manaBarColors.background = specSettings.colors.bar.background.color
			local holyWordsBarColors = scratch.holyWordsBarColors1
			wipe(holyWordsBarColors)
			holyWordsBarColors.bar = nil
			holyWordsBarColors.border = nil
			holyWordsBarColors.background = nil
			local lightweaverBarColors = scratch.lightweaverBarColors1
			wipe(lightweaverBarColors)
			lightweaverBarColors.bar = nil
			lightweaverBarColors.border = nil
			lightweaverBarColors.background = nil
			local barColorMap = scratch.barColorMap2
			wipe(barColorMap)
			barColorMap.manaBar = manaBarColors
			barColorMap.holyWordsBar = holyWordsBarColors
			barColorMap.lightweaverBar = lightweaverBarColors

			-- Holy's own bars are resolved by the node-aware walk below, not the shared resolver: several of
			-- its indicators apply to one node of a bar rather than the whole bar. The shared health/cast bar
			-- have no such nuance, so they still resolve the standard way.
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, nil)

			-- Apply flat indicator colors (priority order, last writer wins)
			if nodeOrder and indicatorColors then
				for i = #nodeOrder, 1, -1 do
					local key = nodeOrder[i]
					local indicator = indicatorColors[key]
					if indicator and indicator.enabled and conditionMap[key] then
						if indicator.targets then
							for barKey, elements in pairs(indicator.targets) do
								local targetColors = barColorMap[barKey]
								if targetColors and elements then
									for elemKey, isTargeted in pairs(elements) do
										-- Benediction on lightweaverBar.background is node-specific (next empty node only)
										-- Per-HW indicators on holyWordsBar are node-specific (recharging node only)
										if isTargeted
											and not (key == "benediction" and barKey == "lightweaverBar" and elemKey == "background")
											and not ((key == "holyWordSerenity" or key == "holyWordSanctify" or key == "holyWordChastise") and barKey == "holyWordsBar") then
											targetColors[elemKey] = (elemKey == "bar") and indicator or indicator.color
										end
									end
								end
							end
						end
					end
				end
			end

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resourceModified --/ TRB.Data.resourceFactor

				-- Resolve final mana bar colors from the map
				local barColor = manaBarColors.bar
				local barBorderColor = manaBarColors.border
				local barBackgroundColor = manaBarColors.background

				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "manaBar")

				barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
				primaryNode:SetBorderColor(barBorderColor)
				TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end

			if not specSettings.displayBar.holyWords.neverShow then
				local hwColors = specSettings.colors.bars.holyWords
				local cpBorderColor = holyWordsBarColors.border or hwColors.border.color
				local cpBackgroundColor = holyWordsBarColors.background or hwColors.background.color
				local cpBR, cpBG, cpBB, cpBA = Color:GetRGBAFromString(cpBackgroundColor, true)
				local currentCp = 1

				-- Use BarTypeDefinition ordering to iterate Holy Words in user-configured order
				local holyWordsBarTypeDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords")
				local orderedKeys = holyWordsBarTypeDef:GetOrderedNodeKeys(hwColors)

				-- Rebuild runtime node mapping for GetBarTextFrame
				BuildHolyWordNodeMapping()

				for _, nodeKey in ipairs(orderedKeys) do
					local hwDef = holyWordKeyToDef[nodeKey]
					local nodeColorEntry = hwColors.nodeColors[nodeKey]
					local nodeEnabled = nodeColorEntry and nodeColorEntry.enabled
					if hwDef and hwDef.spell and nodeEnabled and talents:IsTalentActive(hwDef.spell) then
						-- Sanctify is removed by Ultimate Serenity
						if nodeKey ~= "holyWordSanctify" or not talents:IsTalentActive(spells.ultimateSerenity) then
---@diagnostic disable-next-line: undefined-field
							local cooldown = snapshots[hwDef.spell.id].cooldown
							local charges = cooldown.manualCharges or 0
							local maxCharges = cooldown.manualMaxCharges or 1
							local baseColor = nodeColorEntry.color or "FFFFFFFF"

							-- Read per-HW indicator for node-specific coloring on the recharging node
							local hwIndicator = indicatorColors and indicatorColors[hwDef.key]
							local hwIndTargets = hwIndicator and hwIndicator.enabled
								and conditionMap[hwDef.key]
								and hwIndicator.targets and hwIndicator.targets.holyWordsBar

							for chargeIndex = 1, maxCharges do
								if barGroups and barGroups.holyWords then
									local cpNode = barGroups.holyWords:GetNode(currentCp)
									if cpNode then
										local cpColor = holyWordsBarColors.bar or baseColor
										local nodeBorderColor = cpBorderColor
										local nodeBgR, nodeBgG, nodeBgB, nodeBgA = cpBR, cpBG, cpBB, cpBA
										local cpKey = "comboPoint" .. currentCp
										if chargeIndex <= charges then
											-- Available charge: full bar
											cpNode:ClearTimerDuration()
											Bar:SetBarNodeValue(specCacheSettings, cpKey, cpNode, 1, 1)
										elseif chargeIndex == charges + 1 and cooldown:IsRechargingManual() and cooldown.manualCooldownExpires ~= nil then
											-- Currently recharging: manual timer-based progress
											cpNode:ClearTimerDuration()
											local progress = cooldown:GetManualCooldownProgress(currentTime)
											-- Invalidate cache so continuously changing progress always renders
											TRB.Data.cache.values.bar[cpKey] = nil
											Bar:SetBarNodeValue(specCacheSettings, cpKey, cpNode, progress, 1)
										else
											-- Empty charge (not yet recharging)
											cpNode:ClearTimerDuration()
											Bar:SetBarNodeValue(specCacheSettings, cpKey, cpNode, 0, 1)
										end
										-- Per-HW indicator: node-specific coloring on the recharging node only
										if hwIndTargets and chargeIndex == charges + 1 then
											if hwIndTargets.bar then cpColor = hwIndicator end
											if hwIndTargets.border then nodeBorderColor = hwIndicator.color end
											if hwIndTargets.background then nodeBgR, nodeBgG, nodeBgB, nodeBgA = Color:GetRGBAFromString(hwIndicator.color, true) end
										end
										TRB.Functions.Color:ApplyFillColor(cpNode, cpColor)
										cpNode:SetBorderColor(nodeBorderColor)
										cpNode:SetBackgroundColor(nodeBgR, nodeBgG, nodeBgB, nodeBgA)
										Bar:ApplyEndCapIndicator(cpNode, "holyWordsBar")
									end
								end
								currentCp = currentCp + 1
							end
						end
					end
				end
			end

			-- Update health bar
			if not specSettings.displayBar.health.neverShow then
				refreshText = true
				Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
			end

			-- Update utility bar (Angelic Feather charges)
			if displaySettings.utility ~= nil and not displaySettings.utility.neverShow and barGroups and barGroups.utility then
				if talents:IsTalentActive(spells.angelicFeather) then
					refreshText = true
					local cooldown = snapshots[spells.angelicFeather.id].cooldown
					local charges = cooldown.manualCharges or 0
					local maxCharges = spells.angelicFeather.attributes.maxCharges
					local utilityColors = specSettings.colors.bars.utility

					for chargeIndex = 1, maxCharges do
						local utilNode = barGroups.utility:GetNode(chargeIndex)
						if utilNode then
							local nodeKey = "utility" .. chargeIndex
							local nodeColorKey = "angelicFeather" .. chargeIndex
							local nodeColor = utilityColors.nodeColors and utilityColors.nodeColors[nodeColorKey] or "FFFFD700"
							-- sameColor: use highest filled charge's color for all filled nodes
							if utilityColors.sameColor and chargeIndex <= charges and charges > 0 then
								local highestKey = "angelicFeather" .. charges
								nodeColor = utilityColors.nodeColors and utilityColors.nodeColors[highestKey] or nodeColor
							end
							if chargeIndex <= charges then
								utilNode:ClearTimerDuration()
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, 1, 1)
							elseif chargeIndex == charges + 1 and cooldown:IsRechargingManual() and cooldown.manualCooldownExpires ~= nil then
								utilNode:ClearTimerDuration()
								local progress = cooldown:GetManualCooldownProgress(currentTime)
								TRB.Data.cache.values.bar[nodeKey] = nil
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, progress, 1)
							else
								utilNode:ClearTimerDuration()
								TRB.Data.cache.values.bar[nodeKey] = nil
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, 0, 1)
							end
							TRB.Functions.Color:ApplyFillColor(utilNode, nodeColor)
							utilNode:SetBorderColor(utilityColors.border.color)
							utilNode:SetBackgroundColorFromString(utilityColors.background.color)
						end
					end
				end
			end

			-- Update Lightweaver bar (buff stacks)
			if specSettings.displayBar.lightweaver ~= nil and not specSettings.displayBar.lightweaver.neverShow and barGroups and barGroups.lightweaver then
				if talents:IsTalentActive(spells.lightweaver) then
					refreshText = true
					local lightweaverBuff = snapshots[spells.lightweaver.id].buff
					local lwStacks = lightweaverBuff.applications or 0
					local lightweaverColors = specSettings.colors.bars.lightweaver

					for chargeIndex = 1, barGroups.lightweaver.maxNodes or 4 do
						local lwNode = barGroups.lightweaver:GetNode(chargeIndex)
						if lwNode then
							local nodeKey = "lightweaver" .. chargeIndex
							local chargeKey = "charge" .. chargeIndex
							-- When sameColor is enabled, all filled nodes use the highest filled charge's color
							local colorKey = chargeKey
							if lightweaverColors.sameColor and lwStacks > 0 and chargeIndex <= lwStacks then
								colorKey = "charge" .. lwStacks
							end
							local nodeColor = lightweaverColors.nodeColors and lightweaverColors.nodeColors[colorKey]
							if chargeIndex <= lwStacks then
								lwNode:ClearTimerDuration()
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, lwNode, 1, 1)
							else
								lwNode:ClearTimerDuration()
								TRB.Data.cache.values.bar[nodeKey] = nil
								Bar:SetBarNodeValue(specCacheSettings, nodeKey, lwNode, 0, 1)
							end
							TRB.Functions.Color:ApplyFillColor(lwNode, lightweaverBarColors.bar or nodeColor)
							lwNode:SetBorderColor(lightweaverBarColors.border or lightweaverColors.border.color)
							local lwBgColor = lightweaverBarColors.background or lightweaverColors.background.color
							-- Benediction on lightweaver background is node-specific: only the next empty node
							local benIndicator = indicatorColors and indicatorColors.benediction
							if benIndicator and benIndicator.enabled and conditionMap.benediction
								and benIndicator.targets and benIndicator.targets.lightweaverBar
								and benIndicator.targets.lightweaverBar.background
								and chargeIndex == lwStacks + 1 then
								lwBgColor = benIndicator.color
							end
							lwNode:SetBackgroundColorFromString(lwBgColor)
							Bar:ApplyEndCapIndicator(lwNode, "lightweaverBar")
						end
					end
				end
			end
		end

		-- Surge of Light audio cues (independent of bar visibility)
		FireSurgeOfLightCues(specSettings, snapshotData, spells)

		-- Lightweaver audio cues (independent of bar visibility)
		do
			local lightweaverStacks = snapshots[spells.lightweaver.id].buff.applications or 0
			TRB.Functions.AudioCues:UpdateCounter(specSettings, snapshotData, "lightweaverStacks", lightweaverStacks)

			-- Expiring cue: fires when buff is active and remaining time drops below configured threshold
			local lightweaverTime = snapshots[spells.lightweaver.id].buff:GetRemainingTime(currentTime) or 0
			local expiringThreshold = specSettings.audio.lightweaverExpiring.configuration.thresholdValue
			TRB.Functions.AudioCues:Fire(specSettings, snapshotData, "lightweaverExpiring",
				lightweaverStacks > 0 and lightweaverTime > 0 and lightweaverTime < expiringThreshold)
		end

		-- Holy Word charge-ready audio cues (independent of bar visibility, combat-only). Latches
		-- track charge state out of combat too, so re-entering combat with a Holy Word already up
		-- does not replay its cue.
		do
			local inCombat = TRB.Data.character.inCombat
			local chastiseCharges = snapshots[spells.holyWordChastise.id].cooldown.charges or 0
			local serenityCharges = snapshots[spells.holyWordSerenity.id].cooldown.charges or 0
			local sanctifyCharges = snapshots[spells.holyWordSanctify.id].cooldown.charges or 0

			TRB.Functions.AudioCues:Fire(specSettings, snapshotData, "holyWordChastiseReady", chastiseCharges >= 1, inCombat)

			-- Serenity and Sanctify go up to 2 charges with Miracle Worker; the second-charge cue
			-- wins when both thresholds are crossed on the same update.
			TRB.Functions.AudioCues:FireGroup(specSettings, snapshotData, {
				{ id = "holyWordSerenityCharge1", condition = serenityCharges >= 1 },
				{ id = "holyWordSerenityCharge2", condition = serenityCharges >= 2 },
			}, inCombat)

			TRB.Functions.AudioCues:FireGroup(specSettings, snapshotData, {
				{ id = "holyWordSanctifyCharge1", condition = sanctifyCharges >= 1 },
				{ id = "holyWordSanctifyCharge2", condition = sanctifyCharges >= 2 },
			}, inCombat)
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		local specSettings = classSettings.shadow
		local specCacheSettings = TRB.Data.specCache.priest_shadow.settings
		local displaySettings = specCacheSettings.displayBar or specSettings.displayBar
		UpdateSnapshot_Shadow()

		-- Mana bar colors and overcap curves hoisted above isTracking for mana bar block access
		local manaBarColor = specSettings.colors.bars.mana.bar.color
		local manaBorderColor = specSettings.colors.bars.mana.border.color
		local manaBackgroundColor = specSettings.colors.bars.mana.background.color
		local overcapCurvesMana = scratch.overcapCurvesMana1
		wipe(overcapCurvesMana)

		if snapshotData.attributes.isTracking then
			local affectingCombat = TRB.Data.character.inCombat

			-- Indicators resolve ahead of the primary bar's visibility guard: the health bar and cast bar have
			-- their own visibility, so they still need coloring when the resource bar is set to Never Show.
			local barBorderColor = specSettings.colors.bar.border.color
			local barColor = specSettings.colors.bar.base
			local barBackgroundColor = specSettings.colors.bar.background.color

			-- Build indicator condition map
			local sharedColors = specSettings.colors.shared
			local indicatorColors = sharedColors and sharedColors.indicatorColors

			-- Precompute voidformEnd timing threshold
			local voidformActive = snapshots[spells.voidform.id].buff.isActive
			local voidformEndMet = false
			if voidformActive then
				local timeLeft = snapshots[spells.voidform.id].buff.remaining
				local timeThreshold = 0
				if specSettings.endOf.voidform.mode == "gcd" then
					local gcd = Character:GetCurrentGCDTime()
					timeThreshold = gcd * specSettings.endOf.voidform.gcdsMax
				elseif specSettings.endOf.voidform.mode == "time" then
					timeThreshold = specSettings.endOf.voidform.timeMax
				end
				voidformEndMet = timeLeft <= timeThreshold
			end

			local swmUsable = spells.shadowWordMadness:IsFree() or spells.shadowWordMadness:IsUsable()

			local conditionMap = scratch.conditionMap3
			wipe(conditionMap)
			conditionMap.instantMindBlast = snapshotData.attributes.shadowyInsightActive
			conditionMap.voidformEnd = voidformActive and voidformEndMet
			conditionMap.mindDevourer = spells.shadowWordMadness:IsFree()
			conditionMap.entropicRift = snapshots[spells.entropicRift.id].buff.isActive
			conditionMap.borderMindFlayInsanity = snapshots[spells.mindFlayInsanity.id].buff.isActive
			conditionMap.shadowWordMadnessUsable = swmUsable
			conditionMap.voidform = voidformActive
			conditionMap.borderOvercap = affectingCombat

			-- Color targets: barKey -> elementKey -> current color
			local insanityBarColors = scratch.insanityBarColors1
			wipe(insanityBarColors)
			insanityBarColors.bar = barColor
			insanityBarColors.border = barBorderColor
			insanityBarColors.background = barBackgroundColor
			local manaBarColors = scratch.manaBarColors3
			wipe(manaBarColors)
			manaBarColors.bar = manaBarColor
			manaBarColors.border = manaBorderColor
			manaBarColors.background = manaBackgroundColor
			local barColorMap = scratch.barColorMap3
			wipe(barColorMap)
			barColorMap.insanityBar = insanityBarColors
			barColorMap.manaBar = manaBarColors

			-- Apply flat indicator colors (priority order, last writer wins)
			TRB.Functions.Color:ApplyIndicatorColors(sharedColors, conditionMap, barColorMap)

			if not specSettings.displayBar.primary.neverShow then
				refreshText = true
				local currentResource = snapshotData.attributes.resource

				local maxPrimaryBarResourceUnnormalized = TRB.Data.character.maxResourceUnmodified
				if specCacheSettings.maxResource ~= nil and specCacheSettings.maxResource.enabled == true and specCacheSettings.maxResource.value > 0 then
					maxPrimaryBarResourceUnnormalized = math.min(specCacheSettings.maxResource.value, maxPrimaryBarResourceUnnormalized)
				end

				local isCasting = snapshotData.casting.resourceFinal ~= 0

				-- Find active gradient indicators (separate priority group, always override flat colors when active)
				local gradientOrder = sharedColors and sharedColors.gradientOrder
				local overcapIndicator = nil
				if gradientOrder and indicatorColors then
					for i = #gradientOrder, 1, -1 do
						local key = gradientOrder[i]
						local indicator = indicatorColors[key]
						if indicator and indicator.enabled and conditionMap[key] and indicator.isGradient then
							overcapIndicator = indicator
							break
						end
					end
				end

				-- Resolve final insanity bar colors from the map
				barColor = insanityBarColors.bar
				barBorderColor = insanityBarColors.border
				barBackgroundColor = insanityBarColors.background

				-- Resolve final mana bar colors from the map
				manaBarColor = manaBarColors.bar
				manaBorderColor = manaBarColors.border
				manaBackgroundColor = manaBarColors.background

				-- Build gradient curves for targeted elements (gradient always wins over flat indicators)
				local overcapCurvesInsanity = scratch.overcapCurvesInsanity1
				wipe(overcapCurvesInsanity)
				if overcapIndicator and overcapIndicator.targets then
					local insanityTargets = overcapIndicator.targets.insanityBar
					if insanityTargets then
						if insanityTargets.border then
							overcapCurvesInsanity.border = Color:BuildResourceThresholdCurve(specSettings, barBorderColor, overcapIndicator.color)
						end
						if insanityTargets.bar then
							overcapCurvesInsanity.bar = Color:BuildResourceThresholdCurve(specSettings, barColor, overcapIndicator.color)
						end
						if insanityTargets.background then
							overcapCurvesInsanity.background = Color:BuildResourceThresholdCurve(specSettings, barBackgroundColor, overcapIndicator.color)
						end
					end
					local manaTargets = overcapIndicator.targets.manaBar
					if manaTargets then
						if manaTargets.border then
							overcapCurvesMana.border = Color:BuildResourceThresholdCurve(specSettings, manaBorderColor, overcapIndicator.color)
						end
						if manaTargets.bar then
							overcapCurvesMana.bar = Color:BuildResourceThresholdCurve(specSettings, manaBarColor, overcapIndicator.color)
						end
						if manaTargets.background then
							overcapCurvesMana.background = Color:BuildResourceThresholdCurve(specSettings, manaBackgroundColor, overcapIndicator.color)
						end
					end
				end

				-- Get resourceFrame and thresholds from the BarNode
				local resourceFrame = primaryNode:GetFrame()
				local thresholds = primaryNode:GetThresholds()

				local pairOffset = 0
				for thresholdId, spell in ipairs(TRB.Data.cache.thresholdSpells--[=[@as TRB.Classes.SpellThreshold[]]=]) do
					-- Create threshold on-demand if missing
					if thresholds[thresholdId] == nil then
						local thresholdFrame = CreateFrame("Frame", nil, resourceFrame)
						Threshold:ResetThresholdLine(thresholdFrame, specCacheSettings, true)
						primaryNode:RegisterThreshold(thresholdFrame)
						thresholds = primaryNode:GetThresholds()
					end
					pairOffset = (thresholdId - 1) * 3
					local resourceAmount = spell:GetPrimaryResourceCost()
					local isUsable = spell:IsUsable()
					local showThreshold = true
					local thresholdColor = specCacheSettings.colors.threshold.over.color --[[@as string?]]
					local frameLevel = frameLevels.thresholdOver
					local snapshot = snapshots[spell.id]
					
					if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
						if spell.settingKey == spells.shadowWordMadness--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount > TRB.Data.character.maxResource then
								showThreshold = false
							elseif snapshots[spells.mindDevourer.id].buff.endTime ~= nil and currentTime < snapshots[spells.mindDevourer.id].buff.endTime then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif spell:IsFree() then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							elseif isUsable then
								thresholdColor = specCacheSettings.colors.threshold.over.color
							else
								thresholdColor = specCacheSettings.colors.threshold.under.color
								frameLevel = frameLevels.thresholdUnder
							end
						elseif spell.settingKey == spells.shadowWordMadness2--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount > TRB.Data.character.maxResource then
								showThreshold = false
							elseif specCacheSettings.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow then
								showThreshold = false
							else
								-- Use ColorCurve to dynamically change threshold color based on resource
								local baseCost = resourceAmount / spell.primaryResourceTypeMod
								local curveUnderColor, curveOverColor = Threshold:ResolveThresholdCurveColors(spell, specCacheSettings)
								local thresholdCurve = Color:BuildThresholdCurve(
									spell.primaryResourceTypeMod,
									baseCost,
									curveUnderColor,
									curveOverColor
								)
								local iconCurve = Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
								frameLevel = isUsable and frameLevels.thresholdOver or frameLevels.thresholdUnder
								local curveApplied = Threshold:ApplyThresholdCurveColor(
									spell, thresholds[thresholdId], thresholdCurve, TRB.Data.resource, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
								)
								if curveApplied then
									thresholdColor = nil -- Skip normal color application
								else
									thresholdColor = curveUnderColor
								end
							end
						elseif spell.settingKey == spells.shadowWordMadness3--[[@as TRB.Classes.SpellThreshold]].settingKey then
							if spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif resourceAmount > maxPrimaryBarResourceUnnormalized then
								showThreshold = false
							elseif specCacheSettings.thresholds.specProperties.shadowWordMadnessThresholdOnlyOverShow then
								showThreshold = false
							else
								-- Use ColorCurve to dynamically change threshold color based on resource
								local baseCost = resourceAmount / spell.primaryResourceTypeMod
								local curveUnderColor, curveOverColor = Threshold:ResolveThresholdCurveColors(spell, specCacheSettings)
								local thresholdCurve = Color:BuildThresholdCurve(
									spell.primaryResourceTypeMod,
									baseCost,
									curveUnderColor,
									curveOverColor
								)
								local iconCurve = Color:BuildIconVertexColorCurve(spell.primaryResourceTypeMod, baseCost)
								frameLevel = isUsable and frameLevels.thresholdOver or frameLevels.thresholdUnder
								local curveApplied = Threshold:ApplyThresholdCurveColor(
									spell, thresholds[thresholdId], thresholdCurve, TRB.Data.resource, specCacheSettings, iconCurve, frameLevel, pairOffset, isUsable
								)
								if curveApplied then
									thresholdColor = nil -- Skip normal color application
								else
									thresholdColor = curveUnderColor
								end
							end
						end
					elseif resourceAmount == 0 then
						showThreshold = false
					elseif spell.isTalent and not talents:IsTalentActive(spell) then -- Talent not selected
						showThreshold = false
					elseif spell.isPvp and (not TRB.Data.character.isPvp or not talents:IsTalentActive(spell)) then
						showThreshold = false
					elseif spell.hasCooldown then
						if snapshotData.snapshots[spell.id].cooldown:IsUnusable() then
							thresholdColor = specCacheSettings.colors.threshold.unusable.color
							frameLevel = frameLevels.thresholdUnusable
						else
							thresholdColor = specCacheSettings.colors.threshold.under.color
							frameLevel = frameLevels.thresholdUnder
						end
					else -- This is an active/available/normal spell threshold
						thresholdColor = specCacheSettings.colors.threshold.under.color
						frameLevel = frameLevels.thresholdUnder
					end
					
					if resourceAmount > maxPrimaryBarResourceUnnormalized then
						showThreshold = false
					end

					local dictEntry = specCacheSettings.thresholds.thresholdDictionary[spell.settingKey]
					if thresholds[thresholdId] then
						local isDrawn = Threshold:AdjustThresholdDisplay(spell, spell.settingKey, thresholds[thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, snapshot, specCacheSettings, dictEntry)
						Threshold:RepositionThreshold(specCacheSettings, spell.settingKey, thresholds[thresholdId], showThreshold and isDrawn, resourceFrame, resourceAmount, maxPrimaryBarResourceUnnormalized)
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

				if spells.shadowWordMadness:IsFree() or spells.shadowWordMadness:IsUsable() then
					if specSettings.colors.bar.flashEnabled then
						Bar:PulseFrame(barGroups.primary:GetContainerFrame(), specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod, barGroups.primary.currentAlpha)
					else
						barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
					end

					-- A free cast outranks a merely usable one, so the Mind Devourer cue wins when both
					-- become true together.
					TRB.Functions.AudioCues:FireGroup(specSettings, snapshotData, {
						{ id = "dpReady", condition = true },
						{ id = "mdProc", condition = spells.shadowWordMadness:IsFree() },
					})
				else
					barGroups.primary:GetContainerFrame():SetAlpha(barGroups.primary.currentAlpha or 1.0)
					TRB.Functions.AudioCues:ResetLatch(snapshotData, "dpReady")
					TRB.Functions.AudioCues:ResetLatch(snapshotData, "mdProc")
				end
				
				Bar:SetBarNodePrimaryValue(specCacheSettings, "resource", primaryNode, currentResource)
				Bar:ApplyEndCapIndicator(primaryNode, "insanityBar")

				if overcapCurvesInsanity.border then
					local borderColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurvesInsanity.border)
					primaryNode:SetBorderColorCurve(borderColorResult, TRB.Functions.Color:EvaluateEndCapCurve(primaryNode, overcapCurvesInsanity.border))
				else
					primaryNode:SetBorderColor(barBorderColor)
				end
				if overcapCurvesInsanity.bar then
					local barColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurvesInsanity.bar)
					primaryNode:SetColorCurve(barColorResult)
				else
					TRB.Functions.Color:ApplyFillColor(primaryNode, barColor)
				end
				if overcapCurvesInsanity.background then
					local bgColorResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurvesInsanity.background)
					primaryNode:SetBackgroundColorCurve(bgColorResult)
				else
					primaryNode:SetBackgroundColorFromString(barBackgroundColor)
				end
				Bar:UpdateCastingResourceOverlay(primaryNode, snapshotData, specCacheSettings)
			end
		end

		-- Update health bar
		if not specSettings.displayBar.health.neverShow then
			refreshText = true
			Bar:UpdateHealthBar(barGroups, snapshotData, specCacheSettings)
		end

		-- Update mana bar (Shadow only)
		if specSettings.displayBar.mana ~= nil and not specSettings.displayBar.mana.neverShow then
			refreshText = true
			local manaNode = barGroups and barGroups.mana and barGroups.mana:GetNode(1)
			if manaNode then
				local currentMana = snapshotData.attributes.mana or UnitPower("player", Enum.PowerType.Mana) or 0
				local maxMana = snapshotData.attributes.manaMax or UnitPowerMax("player", Enum.PowerType.Mana) or 1
				manaNode:SetMinMax(0, maxMana)
				manaNode:SetValue(currentMana)
				Bar:ApplyEndCapIndicator(manaNode, "manaBar")
				if overcapCurvesMana.bar then
					local manaBarResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurvesMana.bar)
					manaNode:SetColorCurve(manaBarResult)
				else
					TRB.Functions.Color:ApplyFillColor(manaNode, manaBarColor)
				end
				if overcapCurvesMana.border then
					local manaBorderResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurvesMana.border)
					manaNode:SetBorderColorCurve(manaBorderResult, TRB.Functions.Color:EvaluateEndCapCurve(manaNode, overcapCurvesMana.border))
				else
					manaNode:SetBorderColor(manaBorderColor)
				end
				if overcapCurvesMana.background then
					local manaBgResult = UnitPowerPercent("player", TRB.Data.resource, true, overcapCurvesMana.background)
					manaNode:SetBackgroundColorCurve(manaBgResult)
				else
					manaNode:SetBackgroundColorFromString(manaBackgroundColor)
				end
			end
		end

		-- Update utility bar (Angelic Feather charges)
		if displaySettings.utility ~= nil and not displaySettings.utility.neverShow and barGroups and barGroups.utility then
			if talents:IsTalentActive(spells.angelicFeather) then
				refreshText = true
				local cooldown = snapshots[spells.angelicFeather.id].cooldown
				local charges = cooldown.manualCharges or 0
				local maxCharges = spells.angelicFeather.attributes.maxCharges
				local utilityColors = specSettings.colors.bars.utility

				for chargeIndex = 1, maxCharges do
					local utilNode = barGroups.utility:GetNode(chargeIndex)
					if utilNode then
						local nodeKey = "utility" .. chargeIndex
						local nodeColorKey = "angelicFeather" .. chargeIndex
						local nodeColor = utilityColors.nodeColors and utilityColors.nodeColors[nodeColorKey] or "FFFFD700"
						-- sameColor: use highest filled charge's color for all filled nodes
						if utilityColors.sameColor and chargeIndex <= charges and charges > 0 then
							local highestKey = "angelicFeather" .. charges
							nodeColor = utilityColors.nodeColors and utilityColors.nodeColors[highestKey] or nodeColor
						end
						if chargeIndex <= charges then
							utilNode:ClearTimerDuration()
							Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, 1, 1)
						elseif chargeIndex == charges + 1 and cooldown:IsRechargingManual() and cooldown.manualCooldownExpires ~= nil then
							utilNode:ClearTimerDuration()
							local progress = cooldown:GetManualCooldownProgress(currentTime)
							TRB.Data.cache.values.bar[nodeKey] = nil
							Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, progress, 1)
						else
							utilNode:ClearTimerDuration()
							TRB.Data.cache.values.bar[nodeKey] = nil
							Bar:SetBarNodeValue(specCacheSettings, nodeKey, utilNode, 0, 1)
						end
						TRB.Functions.Color:ApplyFillColor(utilNode, nodeColor)
						utilNode:SetBorderColor(utilityColors.border.color)
						utilNode:SetBackgroundColorFromString(utilityColors.background.color)
					end
				end
			end
		end

		TRB.Functions.BarText:UpdateResourceBarText(specCacheSettings, refreshText)
	end
end

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
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
	TRB.Data.character.specId = GetSpecialization() or 0
	if TRB.Data.character.specId == 1 then
		specCache.priest_discipline.talents:GetTalents()
		FillSpellData_Discipline()
		Character:LoadFromSpecializationCache(specCache.priest_discipline)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Discipline
		Bar:UpdateSanityCheckValues(specCache.priest_discipline.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#pwRadiance"] = spells.powerWordRadiance.icon
		lookup["#radiance"] = spells.powerWordRadiance.icon
		lookup["#powerWordRadiance"] = spells.powerWordRadiance.icon
		lookup["#af"] = spells.angelicFeather.icon
		lookup["#angelicFeather"] = spells.angelicFeather.icon
		lookup["#voidShield"] = spells.masterTheDarkness.icon
		lookup["#masterTheDarkness"] = spells.masterTheDarkness.icon
		lookup["#surgeOfLight"] = spells.surgeOfLight.icon
		--[[lookup["#atonement"] = spells.atonement.icon
		lookup["#sc"] = spells.shadowCovenant.icon
		lookup["#shadowCovenant"] = spells.shadowCovenant.icon
		lookup["#entropicRift"] = spells.entropicRift.icon]]

		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		ResetSurgeOfLightTracking()

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		-- Initialize manual charge tracking for Power Word: Radiance (API returns secret values)
		local pwrSnapshot = specCache.priest_discipline.snapshotData.snapshots[spells.powerWordRadiance.id]
		if pwrSnapshot then
			local maxCharges = specCache.priest_discipline.talents:IsTalentActive(spells.lightsPromise) and 2 or 1
			pwrSnapshot.cooldown:InitializeManualCharges(maxCharges)
		end

		-- Initialize manual charge tracking for Angelic Feather
		local afSnapshot = specCache.priest_discipline.snapshotData.snapshots[spells.angelicFeather.id]
		if afSnapshot then
			afSnapshot.cooldown:InitializeManualCharges(spells.angelicFeather.attributes.maxCharges)
		end

		talents = specCache.priest_discipline.talents
		TRB.Data.barConstructedForSpec = "priest_discipline"
		ConstructResourceBar(specCache.priest_discipline.settings)
	elseif TRB.Data.character.specId == 2 then
		specCache.priest_holy.talents:GetTalents()
		FillSpellData_Holy()
		Character:LoadFromSpecializationCache(specCache.priest_holy)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Holy
		Bar:UpdateSanityCheckValues(specCache.priest_holy.settings)

		local lookup = TRB.Data.lookup or {}
		lookup["#flashHeal"] = spells.flashHeal.icon
		lookup["#apotheosis"] = spells.apotheosis.icon
		lookup["#hf"] = spells.holyFire.icon
		lookup["#holyFire"] = spells.holyFire.icon
		lookup["#hwChastise"] = spells.holyWordChastise.icon
		lookup["#chastise"] = spells.holyWordChastise.icon
		lookup["#holyWordChastise"] = spells.holyWordChastise.icon
		lookup["#hwSanctify"] = spells.holyWordSanctify.icon
		lookup["#sanctify"] = spells.holyWordSanctify.icon
		lookup["#holyWordSanctify"] = spells.holyWordSanctify.icon
		lookup["#hwSerenity"] = spells.holyWordSerenity.icon
		lookup["#serenity"] = spells.holyWordSerenity.icon
		lookup["#holyWordSerenity"] = spells.holyWordSerenity.icon
		lookup["#smite"] = spells.smite.icon
		lookup["#lightweaver"] = spells.lightweaver.icon
		lookup["#af"] = spells.angelicFeather.icon
		lookup["#angelicFeather"] = spells.angelicFeather.icon
		lookup["#surgeOfLight"] = spells.surgeOfLight.icon
		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		ResetSurgeOfLightTracking()

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		-- Configure Sustained Potency pause tracking for Apotheosis
		local apotheosisSnapshot = specCache.priest_holy.snapshotData.snapshots[spells.apotheosis.id]
		if apotheosisSnapshot ~= nil then
			if specCache.priest_holy.talents:IsTalentActive(spells.sustainedPotency) then
				-- Set the pause max duration from the Sustained Potency talent
				apotheosisSnapshot.buff:SetPauseMaxDuration(spells.sustainedPotency.attributes.pauseDuration)
				RegisterSustainedPotencyEvents()
			else
				-- Clear pause configuration if talent is not active
				apotheosisSnapshot.buff:SetPauseMaxDuration(nil)
				UnregisterSustainedPotencyEvents()
			end
		end

		-- Initialize manual charge tracking for Holy Words (secret-value-safe)
		local holySnapshots = specCache.priest_holy.snapshotData.snapshots
		local hasMiracleWorker = specCache.priest_holy.talents:IsTalentActive(spells.miracleWorker)
		holySnapshots[spells.holyWordSerenity.id].cooldown:InitializeManualCharges(hasMiracleWorker and 2 or 1)
		holySnapshots[spells.holyWordSanctify.id].cooldown:InitializeManualCharges(hasMiracleWorker and 2 or 1)
		holySnapshots[spells.holyWordChastise.id].cooldown:InitializeManualCharges(1)

		-- Initialize manual charge tracking for Angelic Feather
		local afSnapshot = holySnapshots[spells.angelicFeather.id]
		if afSnapshot then
			afSnapshot.cooldown:InitializeManualCharges(spells.angelicFeather.attributes.maxCharges)
		end

		-- Set up the getNodeCountForKey callback on the Holy Words BarTypeDefinition
		-- This closure captures talents and spells so GetEnabledNodeCount returns correct total
		local holyWordsBarTypeDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords")
		if holyWordsBarTypeDef then
			holyWordsBarTypeDef.getNodeCountForKey = function(key, _colorSettings)
				local holyTalents = specCache.priest_holy and specCache.priest_holy.talents
				if not holyTalents then return 0 end

				local hwDef = holyWordKeyToDef[key]
				if not hwDef or not hwDef.spell then return 0 end

				-- Sanctify is removed by Ultimate Serenity talent
				if key == "holyWordSanctify" and holyTalents:IsTalentActive(spells.ultimateSerenity) then
					return 0
				end

				if not holyTalents:IsTalentActive(hwDef.spell) then return 0 end

				-- Miracle Worker grants +1 charge to Serenity and Sanctify
				if (key == "holyWordSerenity" or key == "holyWordSanctify") and holyTalents:IsTalentActive(spells.miracleWorker) then
					return 2
				end
				return 1
			end
		end

		talents = specCache.priest_holy.talents
		TRB.Data.barConstructedForSpec = "priest_holy"
		ConstructResourceBar(specCache.priest_holy.settings)
	elseif TRB.Data.character.specId == 3 then
		specCache.priest_shadow.talents:GetTalents()
		FillSpellData_Shadow()
		Character:LoadFromSpecializationCache(specCache.priest_shadow)

		local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Shadow
		Bar:UpdateSanityCheckValues(specCache.priest_shadow.settings)

		local lookup = {}
		lookup["#mb"] = spells.mindBlast.icon
		lookup["#mindBlast"] = spells.mindBlast.icon
		lookup["#mf"] = spells.mindFlay.icon
		lookup["#mindFlay"] = spells.mindFlay.icon
		lookup["#mfi"] = spells.mindFlayInsanity.icon
		lookup["#mindFlayInsanity"] = spells.mindFlayInsanity.icon
		lookup["#mindgames"] = spells.mindgames.icon
		lookup["#vf"] = spells.voidform.icon
		lookup["#voidform"] = spells.voidform.icon
		lookup["#voit"] = spells.voidTorrent.icon
		lookup["#voidTorrent"] = spells.voidTorrent.icon
		lookup["#vv"] = spells.voidVolley.icon
		lookup["#voidVolley"] = spells.voidVolley.icon
		lookup["#mDev"] = spells.mindDevourer.icon
		lookup["#mindDevourer"] = spells.mindDevourer.icon
		lookup["#sotv"] = spells.screamsOfTheVoid.icon
		lookup["#screamsOfTheVoid"] = spells.screamsOfTheVoid.icon
		lookup["#entropicRift"] = spells.entropicRift.icon
		lookup["#swm"] = spells.shadowWordMadness.icon
		lookup["#shadowWordMadness"] = spells.shadowWordMadness.icon
		lookup["#halo"] = spells.halo.icon
		lookup["#af"] = spells.angelicFeather.icon
		lookup["#angelicFeather"] = spells.angelicFeather.icon
		lookup["#si"] = spells.shadowyInsight.icon
		lookup["#shadowyInsight"] = spells.shadowyInsight.icon
		--[[
		lookup["#mm"] = spells.shatteredPsyche.icon
		lookup["#mindMelt"] = spells.shatteredPsyche.icon
		lookup["#sp"] = spells.shatteredPsyche.icon
		lookup["#shatteredPsyche"] = spells.shatteredPsyche.icon
		lookup["#ys"] = spells.idolOfYoggSaron.icon
		lookup["#idolOfYoggSaron"] = spells.idolOfYoggSaron.icon
		lookup["#tfb"] = spells.thingFromBeyond.icon
		lookup["#thingFromBeyond"] = spells.thingFromBeyond.icon
		lookup["#md"] = spells.massDispel.icon
		lookup["#massDispel"] = spells.massDispel.icon
		lookup["#cthun"] = spells.idolOfCthun.icon
		lookup["#idolOfCthun"] = spells.idolOfCthun.icon
		lookup["#loi"] = spells.idolOfCthun.icon
		lookup["#hv"] = spells.horrificVisions.icon
		lookup["#horrificVisions"] = spells.horrificVisions.icon]]

		TRB.Data.lookup = lookup
		TRB.Data.lookupLogic = {}

		-- Ensure resource snapshots are initialized before bar construction.
		TRB.Functions.Class:EventRegistration()

		-- Configure Sustained Potency pause tracking for Voidform
		local voidformSnapshot = specCache.priest_shadow.snapshotData.snapshots[spells.voidform.id]
		if voidformSnapshot ~= nil then
			if specCache.priest_shadow.talents:IsTalentActive(spells.sustainedPotency) then
				-- Set the pause max duration from the Sustained Potency talent
				voidformSnapshot.buff:SetPauseMaxDuration(spells.sustainedPotency.attributes.pauseDuration)
				RegisterSustainedPotencyEvents()
			else
				-- Clear pause configuration if talent is not active
				voidformSnapshot.buff:SetPauseMaxDuration(nil)
				UnregisterSustainedPotencyEvents()
			end
		end

		-- Initialize manual charge tracking for Angelic Feather
		local afSnapshot = specCache.priest_shadow.snapshotData.snapshots[spells.angelicFeather.id]
		if spells and afSnapshot then
			afSnapshot.cooldown:InitializeManualCharges(spells.angelicFeather.attributes.maxCharges)
		end

		talents = specCache.priest_shadow.talents
		TRB.Data.barConstructedForSpec = "priest_shadow"
		ConstructResourceBar(specCache.priest_shadow.settings)
	else
		-- Unregister Sustained Potency events when not Shadow spec
		UnregisterSustainedPotencyEvents()
		TRB.Data.barConstructedForSpec = nil
	end

	if TRB.Data.barConstructedForSpec ~= nil then
		TRB.Functions.Aura:ClearAuraInstanceIds()
	end

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

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	-- Wrong game version for this build: halt before anything reads or writes settings.
	if TRB.Functions.VersionGate:IsBlocked() then
		return
	end

	if event == "PLAYER_SPECIALIZATION_CHANGED" and arg1 ~= "player" then
		return
	end

	if TRB.Data.character.classId == nil or TRB.Data.character.classId == 0 then
		_, _, TRB.Data.character.classId = UnitClass("player")
	end

	if TRB.Data.character.specId == nil or TRB.Data.character.specId == 0 then
		TRB.Data.character.specId = GetSpecialization() or 0
	end

	if TRB.Data.character.classId == 5 then
		if event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar" then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Functions.Settings:PortForwardSettings()

					local settings = TRB.Options.Priest.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.discipline == nil or
						TwintopInsanityBarSettings.priest.discipline.displayText == nil then
						settings.priest.discipline.displayText.barText = TRB.Options.Priest.DisciplineLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.holy == nil or
						TwintopInsanityBarSettings.priest.holy.displayText == nil then
						settings.priest.holy.displayText.barText = TRB.Options.Priest.HolyLoadDefaultBarTextSettings()
					end

					if TwintopInsanityBarSettings.priest == nil or
						TwintopInsanityBarSettings.priest.shadow == nil or
						TwintopInsanityBarSettings.priest.shadow.displayText == nil then
						settings.priest.shadow.displayText.barText = TRB.Options.Priest.ShadowLoadDefaultBarTextSettings()
					end

					-- Clear core barText defaults before merge so the user's saved list (even if empty)
					-- takes precedence. Only skip when no saved core displayText exists (first-run seeding).
					if TwintopInsanityBarSettings.core
						and TwintopInsanityBarSettings.core.displayText
						and TwintopInsanityBarSettings.core.displayText.barText then
						settings.core.displayText.barText = {}
					end
					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Functions.Settings:CleanupSettings(TRB.Data.settings)

					if TRB.Data.settings.manualUpdateChecks.midnightBarTextReset ~= nil and
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.priest ~= true then
						TRB.Data.settings.priest.discipline.displayText.barText = TRB.Options.Priest.DisciplineLoadDefaultBarTextSettings()
						TRB.Data.settings.priest.holy.displayText.barText = TRB.Options.Priest.HolyLoadDefaultBarTextSettings()
						TRB.Data.settings.priest.shadow.displayText.barText = TRB.Options.Priest.ShadowLoadDefaultBarTextSettings()
						TRB.Data.settings.manualUpdateChecks.midnightBarTextReset.priest = true
						TRB.Functions.Settings:ShowMidnightBarTextResetMessage(L["Priest"])
						-- Mark Holy Word bar text as seeded since HolyLoadDefaultBarTextSettings includes them
						TRB.Data.settings.priest.holy.displayText.migrations = TRB.Data.settings.priest.holy.displayText.migrations or {}
						TRB.Data.settings.priest.holy.displayText.migrations.holyWordBarTextSeeded = true
						-- Mark Lightweaver bar text as seeded since HolyLoadDefaultBarTextSettings includes them
						TRB.Data.settings.priest.holy.displayText.migrations.lightweaverBarTextSeeded = true
						-- Mark Power Word bar text as seeded since DisciplineLoadDefaultBarTextSettings includes them
						TRB.Data.settings.priest.discipline.displayText.migrations = TRB.Data.settings.priest.discipline.displayText.migrations or {}
						TRB.Data.settings.priest.discipline.displayText.migrations.powerWordBarTextSeeded = true
						-- Mark Angelic Feather bar text as seeded since all specs' LoadDefaultBarTextSettings include them
						TRB.Data.settings.priest.discipline.displayText.migrations.angelicFeatherBarTextSeeded = true
						TRB.Data.settings.priest.holy.displayText.migrations.angelicFeatherBarTextSeeded = true
						TRB.Data.settings.priest.shadow.displayText.migrations = TRB.Data.settings.priest.shadow.displayText.migrations or {}
						TRB.Data.settings.priest.shadow.displayText.migrations.angelicFeatherBarTextSeeded = true
					end

					-- Seed Holy Word bar text entries for existing users who don't have them yet
					TRB.Data.settings.priest.holy.displayText.migrations = TRB.Data.settings.priest.holy.displayText.migrations or {}
					if TRB.Data.settings.priest.holy.displayText.migrations.holyWordBarTextSeeded ~= true then
						local extraEntries = TRB.Options.Priest.HolyLoadHolyWordBarTextSettings()
						for _, v in ipairs(extraEntries) do
							table.insert(TRB.Data.settings.priest.holy.displayText.barText, v)
						end
						TRB.Data.settings.priest.holy.displayText.migrations.holyWordBarTextSeeded = true
					end

					-- Seed Lightweaver bar text entries for existing users who don't have them yet
					if TRB.Data.settings.priest.holy.displayText.migrations.lightweaverBarTextSeeded ~= true then
						local lwEntries = TRB.Options.Priest.HolyLoadLightweaverBarTextSettings()
						for _, v in ipairs(lwEntries) do
							table.insert(TRB.Data.settings.priest.holy.displayText.barText, v)
						end
						TRB.Data.settings.priest.holy.displayText.migrations.lightweaverBarTextSeeded = true
					end

					-- Seed Power Word bar text entries for existing users who don't have them yet
					TRB.Data.settings.priest.discipline.displayText.migrations = TRB.Data.settings.priest.discipline.displayText.migrations or {}
					if TRB.Data.settings.priest.discipline.displayText.migrations.powerWordBarTextSeeded ~= true then
						local extraEntries = TRB.Options.Priest.DisciplineLoadPowerWordBarTextSettings()
						for _, v in ipairs(extraEntries) do
							table.insert(TRB.Data.settings.priest.discipline.displayText.barText, v)
						end
						TRB.Data.settings.priest.discipline.displayText.migrations.powerWordBarTextSeeded = true
					end

					-- Seed Angelic Feather bar text entries for existing users who don't have them yet (all 3 specs)
					local priestSpecs = { "discipline", "holy", "shadow" }
					for _, specName in ipairs(priestSpecs) do
						TRB.Data.settings.priest[specName].displayText.migrations = TRB.Data.settings.priest[specName].displayText.migrations or {}
						if TRB.Data.settings.priest[specName].displayText.migrations.angelicFeatherBarTextSeeded ~= true then
							local afEntries = TRB.Options.Priest.LoadAngelicFeatherBarTextSettings()
							for _, v in ipairs(afEntries) do
								table.insert(TRB.Data.settings.priest[specName].displayText.barText, v)
							end
							TRB.Data.settings.priest[specName].displayText.migrations.angelicFeatherBarTextSeeded = true
						end
					end
				else
					local settings = TRB.Options.Priest.LoadDefaultSettings(true)
					TRB.Data.settings = settings
				end
				FillSpecializationCache()

				SLASH_TWINTOP1 	= "/twintop"
				SLASH_TWINTOP2 	= "/tt"
				SLASH_TWINTOP3 	= "/tib"
				SLASH_TWINTOP4 	= "/tit"
				SLASH_TWINTOP5 	= "/ttib"
				SLASH_TWINTOP6 	= "/ttit"
				SLASH_TWINTOP7 	= "/trb"
				SLASH_TWINTOP8 	= "/trt"
				SLASH_TWINTOP9 	= "/ttrt"
				SLASH_TWINTOP10 = "/ttrb"
			end
		end

		if event == "PLAYER_LOGOUT" then
			TwintopInsanityBarSettings = TRB.Data.settings
		end

		if TRB.Details.addonData.loaded and TRB.Data.character.specId > 0 then
			if not TRB.Details.addonData.optionsPanelStarted then
				TRB.Details.addonData.optionsPanelStarted = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.settings.core = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["GlobalOptions"], TRB.Data.settings.core)
						TRB.Data.settings.priest.discipline = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestDisciplineFull"], TRB.Data.settings.priest.discipline)
						TRB.Data.settings.priest.holy = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestHolyFull"], TRB.Data.settings.priest.holy)
						TRB.Data.settings.priest.shadow = TRB.Functions.LibSharedMedia:ValidateLsmValues(L["PriestShadowFull"], TRB.Data.settings.priest.shadow)
						
						TRB.Data.barConstructedForSpec = nil
						SwitchSpec()

						TRB.Options.Priest.ConstructOptionsPanel(specCache)

						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end

						TRB.Functions.Class:EventRegistration()
						TRB.Functions.News:Init()
						TRB.Details.addonData.optionsPanelFinished = true
					end)
				end)
			end

			if TRB.Details.addonData.optionsPanelFinished and (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED") then
				if TRB.Functions.Bar and TRB.Functions.Bar.QueueRenderTransition then
					Bar:QueueRenderTransition("eventPreSwitch", 0.8)
				elseif TRB.Functions.Bar and TRB.Functions.Bar.HideResourceBar then
					Bar:HideResourceBar(true)
				end
				C_Timer.After(0, function()
					C_Timer.After(0.1, function()
						SwitchSpec()
					end)
				end)
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	local specId = GetSpecialization()
	if specId ~= TRB.Data.character.specId then
		SwitchSpec()
	end

	Character:CheckCharacter()
	TRB.Data.character.className = "priest"
	local spellsData = TRB.Data.spellsData --[[@as TRB.Classes.SpellsData]]
	---@type table<integer, TRB.Classes.Snapshot>
	local snapshots = TRB.Data.snapshotData.snapshots

	if TRB.Data.character.specId == 1 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
		TRB.Data.character.specName = "discipline"
		TRB.Data.character.compositeKey = "priest_discipline"
---@diagnostic disable-next-line: missing-parameter
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		local settings = TRB.Data.settings.priest.discipline
		
		local totalPowerWordCharges = 0

		local discTalents = TRB.Data.specCache.priest_discipline and TRB.Data.specCache.priest_discipline.talents
		if discTalents then
			if discTalents:IsTalentActive(spells.powerWordRadiance) and settings.colors.comboPoints.powerWordRadiance.enabled then
				totalPowerWordCharges = totalPowerWordCharges + 1
				if discTalents:IsTalentActive(spells.lightsPromise) then
					totalPowerWordCharges = totalPowerWordCharges + 1
				end
			end
		end

		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	
		if sharedSettings ~= nil then
			if totalPowerWordCharges ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = totalPowerWordCharges
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
					Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
				end
			end
		end
	elseif TRB.Data.character.specId == 2 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.HolySpells]]
		TRB.Data.character.specName = "holy"
		TRB.Data.character.compositeKey = "priest_holy"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Mana, false)
		local settings = TRB.Data.settings.priest.holy

		-- Use the BarTypeDefinition's GetEnabledNodeCount which delegates to getNodeCountForKey
		-- to compute the total number of Holy Word nodes (talent-aware, respecting enabled flags)
		local holyWordsBarTypeDef = TRB.Classes.BarTypeRegistry:GetInstance():Get("holyWords")
		local totalHolyWordCharges = 0
		if holyWordsBarTypeDef and settings.colors and settings.colors.bars and settings.colors.bars.holyWords then
			totalHolyWordCharges = holyWordsBarTypeDef:GetEnabledNodeCount(settings.colors.bars.holyWords)
		end

		local sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings

		if sharedSettings ~= nil then
			if totalHolyWordCharges ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = totalHolyWordCharges
				if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
					Bar:SetPosition(sharedSettings, TRB.Frames.barGroups.primary:GetContainerFrame())
				end
			end
		end
	elseif TRB.Data.character.specId == 3 then
		local spells = spellsData.spells --[[@as TRB.Classes.Priest.ShadowSpells]]
		TRB.Data.character.specName = "shadow"
		TRB.Data.character.compositeKey = "priest_shadow"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Insanity, true)
		TRB.Data.character.maxResourceUnmodified = UnitPowerMax("player", Enum.PowerType.Insanity, false)
	end
end

function TRB.Functions.Class:EventRegistration()
	if TRB.Data.character.specId == 1 and TRB.Data.settings.core.enabled.priest.discipline == true then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
		TRB.Data.additionalPowerTokens = nil
	elseif TRB.Data.character.specId == 2 and TRB.Data.settings.core.enabled.priest.holy == true then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = "CUSTOM"
		TRB.Data.resource2Factor = nil
		TRB.Data.additionalPowerTokens = nil
	elseif TRB.Data.character.specId == 3 and TRB.Data.settings.core.enabled.priest.shadow == true then
		TRB.Functions.Class:EnableEvents()
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Insanity
		TRB.Data.resourceFactor = 100
		TRB.Data.resource2 = nil
		TRB.Data.resource2Factor = nil
		TRB.Data.additionalPowerTokens = { ["MANA"] = true }
	else
		TRB.Data.specSupported = false
		TRB.Data.additionalPowerTokens = nil
		TRB.Functions.Class:DisableEvents()
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

	if TRB.Data.character.specId == 1 or TRB.Data.character.specId == 2 or TRB.Data.character.specId == 3 then
		local sharedSettings
		if TRB.Data.specCache[TRB.Data.character.compositeKey] ~= nil then
			sharedSettings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
		end

		-- Secondary (Power Words): Discipline (1) only, gated on maxResource2 > 0
		local hasSecondary = TRB.Data.character.specId == 1
			and (TRB.Data.character.maxResource2 or 0) > 0
		local secondaryVisSettings = (sharedSettings and sharedSettings.displayBar.secondary) or nil

		-- Holy Words: Holy (2) only, gated on maxResource2 > 0
		local hasHolyWords = TRB.Data.character.specId == 2
			and (TRB.Data.character.maxResource2 or 0) > 0
		local holyWordsVisSettings = (sharedSettings and sharedSettings.displayBar.holyWords) or nil

		-- Mana bar: Shadow (3) only
		local hasMana = TRB.Data.character.specId == 3
		local manaVisSettings = (sharedSettings and sharedSettings.displayBar.mana) or nil

		-- Utility bar (Angelic Feather): all specs, talent-gated
		local spells = nil --[[@as TRB.Classes.Priest.HealerSpells|TRB.Classes.Priest.ShadowSpells|nil]]
		if TRB.Data.spellsData and TRB.Data.spellsData.spells then
			spells = TRB.Data.spellsData.spells
		end

		local hasUtility = false
		local utilityNodes = nil
		if sharedSettings and sharedSettings.displayBar.utility ~= nil and spells then
			local specTalents = TRB.Data.specCache[TRB.Data.character.compositeKey] and TRB.Data.specCache[TRB.Data.character.compositeKey].talents
			if specTalents and specTalents:IsTalentActive(spells.angelicFeather) then
				hasUtility = true
				utilityNodes = spells.angelicFeather.attributes.maxCharges
			end
		end
		local utilityVisSettings = (sharedSettings and sharedSettings.displayBar.utility) or nil

		-- Lightweaver bar: Holy (2) only, talent-gated
		local hasLightweaver = false
		if TRB.Data.character.specId == 2 and sharedSettings and sharedSettings.displayBar.lightweaver ~= nil and spells then
			local specTalents = TRB.Data.specCache[TRB.Data.character.compositeKey] and TRB.Data.specCache[TRB.Data.character.compositeKey].talents
			if specTalents and specTalents:IsTalentActive(spells.lightweaver) then
				hasLightweaver = true
			end
		end
		local lightweaverVisSettings = (sharedSettings and sharedSettings.displayBar.lightweaver) or nil

		local entries = {
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.primary, sharedSettings and sharedSettings.displayBar.primary, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.secondary, secondaryVisSettings, hasSecondary, TRB.Data.character.maxResource2 or 0, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.holyWords, holyWordsVisSettings, hasHolyWords, TRB.Data.character.maxResource2 or 0, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.lightweaver, lightweaverVisSettings, hasLightweaver, 4, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.health, sharedSettings and sharedSettings.displayBar.health, true, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.mana, manaVisSettings, hasMana, 1, nil),
			TRB.Classes.BarVisibilityEntry:New(barGroups and barGroups.utility, utilityVisSettings, hasUtility, utilityNodes, nil),
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

function TRB.Functions.Class:ResetProcsOnDeath()
	wipe(surgeOfLightVisibleOverlays)
	local snapshotData = TRB.Data.snapshotData
	if snapshotData and snapshotData.attributes then
		snapshotData.attributes.surgeOfLightActiveGrace = false
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		if spells and spells.surgeOfLight then
			local surgeOfLightSnapshot = snapshotData.snapshots and snapshotData.snapshots[spells.surgeOfLight.id]
			if surgeOfLightSnapshot then
				surgeOfLightSnapshot.buff:Reset()
				surgeOfLightSnapshot.buff:ResetProcCharges()
			end
			TRB.Functions.AudioCues:ResetLatch(snapshotData, "surgeOfLight")
			TRB.Functions.AudioCues:ResetLatch(snapshotData, "surgeOfLight2")
		end
		snapshotData.attributes.shadowyInsightActive = false
		if TRB.Data.character.specId == 2 then
			local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
			local benedictionSnapshot = spells and spells.benediction and snapshotData.snapshots and snapshotData.snapshots[spells.benediction.id]
			if benedictionSnapshot then
				benedictionSnapshot.buff:Reset()
			end
			TRB.Functions.AudioCues:ResetLatch(snapshotData, "benediction")
		end
	end
end

local specValidVars
do
	local healthVars = {
		["$health"] = true, ["$healthMax"] = true, ["$healthPercent"] = true,
		["$absorb"] = true, ["$incomingHeal"] = true, ["$healAbsorb"] = true,
	}
	local castingFn = function()
		local c = TRB.Data.snapshotData.casting
		return c.resourceRaw ~= nil and c.resourceRaw ~= 0
	end
	local castingShadowFn = function()
		local c = TRB.Data.snapshotData.casting
		return c.resourceRaw ~= nil and c.resourceRaw > 0
	end
	local afTimeFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.angelicFeather.id].cooldown.remaining > 0
	end
	local afChargesFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.angelicFeather.id].cooldown.charges > 0
	end
	local surgeOfLightActiveFn = function()
		local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
		local snap = spells and spells.surgeOfLight and TRB.Data.snapshotData.snapshots[spells.surgeOfLight.id]
		return snap ~= nil and snap.buff.isActive == true
	end
	-- Discipline
	local pwRadTimeFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.powerWordRadiance.id].cooldown.remaining > 0
	end
	local pwRadChargesFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.powerWordRadiance.id].cooldown.charges > 0
	end
	local harshDisciplineFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.harshDiscipline.id].buff.isActive
	end
	local discipline = {
		["$resource"] = false, ["$mana"] = false,
		["$resourcePercent"] = false, ["$manaPercent"] = false,
		["$resourceMax"] = true, ["$manaMax"] = true,
		["$casting"] = castingFn,
		["$pwRadianceTime"] = pwRadTimeFn,
		["$radianceTime"] = pwRadTimeFn,
		["$powerWordRadianceTime"] = pwRadTimeFn,
		["$pwRadianceCharges"] = pwRadChargesFn,
		["$radianceCharges"] = pwRadChargesFn,
		["$powerWordRadianceCharges"] = pwRadChargesFn,
		["$afTime"] = afTimeFn, ["$angelicFeatherTime"] = afTimeFn,
		["$afCharges"] = afChargesFn, ["$angelicFeatherCharges"] = afChargesFn,
		["$afMaxCharges"] = true, ["$angelicFeatherMaxCharges"] = true,
		["$surgeOfLight"] = surgeOfLightActiveFn,
		["$surgeOfLightStacks"] = surgeOfLightActiveFn,
		["$surgeOfLightStacksMax"] = true,
		["$surgeOfLightTime"] = surgeOfLightActiveFn,
		["$voidShieldTime"] = function()
			local spells = TRB.Data.spellsData.spells
			return TRB.Data.snapshotData.snapshots[spells.masterTheDarkness.id].buff.isActive
		end,
		["$masterTheDarknessTime"] = function()
			local spells = TRB.Data.spellsData.spells
			return TRB.Data.snapshotData.snapshots[spells.masterTheDarkness.id].buff.isActive
		end,
		["$harshDisciplineTime"] = harshDisciplineFn,
		["$harshDisciplineStacks"] = harshDisciplineFn,
		["$harshDisciplineMaxStacks"] = true,
	}
	for k, v in pairs(healthVars) do discipline[k] = v end
	-- Holy
	local lwTimeFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.lightweaver.id].buff.isActive
	end
	local hwChastiseTimeFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.holyWordChastise.id].cooldown.remaining > 0
	end
	local hwSerenityTimeFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.holyWordSerenity.id].cooldown.remaining > 0
	end
	local hwSanctifyTimeFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.holyWordSanctify.id].cooldown.remaining > 0
	end
	local hwChastiseChargesFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.holyWordChastise.id].cooldown.charges > 0
	end
	local hwSerenityChargesFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.holyWordSerenity.id].cooldown.charges > 0
	end
	local hwSanctifyChargesFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.holyWordSanctify.id].cooldown.charges > 0
	end
	local holy = {
		["$resource"] = false, ["$mana"] = false,
		["$resourcePercent"] = false, ["$manaPercent"] = false,
		["$resourceMax"] = true, ["$manaMax"] = true,
		["$casting"] = castingFn,
		["$lightweaverTime"] = lwTimeFn,
		["$lightweaverStacks"] = lwTimeFn,
		["$apotheosisTime"] = function()
			local spells = TRB.Data.spellsData.spells
			return TRB.Data.snapshotData.snapshots[spells.apotheosis.id].buff.isActive
		end,
		["$hwChastiseTime"] = hwChastiseTimeFn,
		["$chastiseTime"] = hwChastiseTimeFn,
		["$holyWordChastiseTime"] = hwChastiseTimeFn,
		["$hwSerenityTime"] = hwSerenityTimeFn,
		["$serenityTime"] = hwSerenityTimeFn,
		["$holyWordSerenityTime"] = hwSerenityTimeFn,
		["$hwSanctifyTime"] = hwSanctifyTimeFn,
		["$sanctifyTime"] = hwSanctifyTimeFn,
		["$holyWordSanctifyTime"] = hwSanctifyTimeFn,
		["$hwChastiseCharges"] = hwChastiseChargesFn,
		["$chastiseCharges"] = hwChastiseChargesFn,
		["$holyWordChastiseCharges"] = hwChastiseChargesFn,
		["$hwSerenityCharges"] = hwSerenityChargesFn,
		["$serenityCharges"] = hwSerenityChargesFn,
		["$holyWordSerenityCharges"] = hwSerenityChargesFn,
		["$hwSanctifyCharges"] = hwSanctifyChargesFn,
		["$sanctifyCharges"] = hwSanctifyChargesFn,
		["$holyWordSanctifyCharges"] = hwSanctifyChargesFn,
		["$afTime"] = afTimeFn, ["$angelicFeatherTime"] = afTimeFn,
		["$afCharges"] = afChargesFn, ["$angelicFeatherCharges"] = afChargesFn,
		["$afMaxCharges"] = true, ["$angelicFeatherMaxCharges"] = true,
		["$surgeOfLight"] = surgeOfLightActiveFn,
		["$surgeOfLightStacks"] = surgeOfLightActiveFn,
		["$surgeOfLightStacksMax"] = true,
		["$surgeOfLightTime"] = surgeOfLightActiveFn,
		["$benediction"] = function()
			local spells = TRB.Data.spellsData.spells
			return TRB.Data.snapshotData.snapshots[spells.benediction.id].buff.isActive or false
		end,
	}
	for k, v in pairs(healthVars) do holy[k] = v end
	-- Shadow
	local mfiBuffFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.mindFlayInsanity.id].buff.isActive
	end
	local entropicRiftTimeFn = function()
		local spells = TRB.Data.spellsData.spells
		return TRB.Data.snapshotData.snapshots[spells.entropicRift.id].buff.isActive
	end
	local shadow = {
		["$resource"] = false, ["$insanity"] = false,
		["$resourceMax"] = true, ["$insanityMax"] = true,
		["$casting"] = castingShadowFn,
		["$vfTime"] = function()
			local spells = TRB.Data.spellsData.spells
			local b = TRB.Data.snapshotData.snapshots[spells.voidform.id].buff
			return b.remaining ~= nil and b.remaining > 0
		end,
		["$mfiTime"] = mfiBuffFn,
		["$mfiStacks"] = mfiBuffFn,
		["$sotvTime"] = function()
			local spells = TRB.Data.spellsData.spells
			return TRB.Data.snapshotData.snapshots[spells.screamsOfTheVoid.id].buff.isActive
		end,
		["$shadowWordMadnessUsable"] = function()
			local spells = TRB.Data.spellsData.spells
			return spells.shadowWordMadness:IsUsable() or spells.shadowWordMadness:IsFree()
		end,
		["$mana"] = false, ["$manaPercent"] = false, ["$manaMax"] = true,
		["$entropicRiftTime"] = entropicRiftTimeFn,
		["$entropicRiftExtensionsRemaining"] = function()
			local spells = TRB.Data.spellsData.spells
			local s = TRB.Data.snapshotData.snapshots[spells.entropicRift.id]
			return s.buff.isActive and s.buff.attributes["extensionsRemaining"] > 0
		end,
		["$afTime"] = afTimeFn, ["$angelicFeatherTime"] = afTimeFn,
		["$afCharges"] = afChargesFn, ["$angelicFeatherCharges"] = afChargesFn,
		["$afMaxCharges"] = true, ["$angelicFeatherMaxCharges"] = true,
	}
	for k, v in pairs(healthVars) do shadow[k] = v end

	specValidVars = { [1] = discipline, [2] = holy, [3] = shadow }
end

function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then return valid end

	local specVars = specValidVars[TRB.Data.character.specId]
	if not specVars then return false end

	local entry = specVars[var]
	if entry == true then return true end
	if not entry then return false end
	return entry() or false
end

---Gets the Frame for the requested bar text variable, if the frame is currently enabled, and if it is visible.
---@param relativeToFrame string
---@return Frame? # Relative to Frame
---@return boolean # Is Enabled?
---@return boolean # Is Visible?
function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	local barGroups = TRB.Frames.barGroups --[[@as { [string]: TRB.Classes.BarGroup }]]
	if relativeToFrame ~= nil then
		relativeToFrame = string.gsub(relativeToFrame, "_", "")
	end
	if relativeToFrame == "ResourceBar" or relativeToFrame == "Resource" then
		if barGroups and barGroups.primary then
			local primaryNode = barGroups.primary:GetNode(1)
			if primaryNode then
				local isVisible = barGroups.primary.isVisible and primaryNode.isVisible
				return primaryNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame == "HealthBar" then
		if barGroups and barGroups.health then
			local healthNode = barGroups.health:GetNode(1)
			if healthNode then
				local isVisible = barGroups.health.isVisible and healthNode.isVisible
				return healthNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame == "ManaBar" then
		if barGroups and barGroups.mana then
			local manaNode = barGroups.mana:GetNode(1)
			if manaNode then
				local isVisible = barGroups.mana.isVisible and manaNode.isVisible
				return manaNode:GetFrame(), true, isVisible
			end
		end
		return nil, true, false
	elseif relativeToFrame ~= nil then
		-- Handle secondary resources (ComboPoint1, ComboPoint2, etc.)
		local comboPointIndex = string.match(relativeToFrame, "^ComboPoint(%d+)$")
		if comboPointIndex ~= nil then
			local index = tonumber(comboPointIndex)
			if index ~= nil and barGroups and barGroups.secondary then
				local secondaryNode = barGroups.secondary:GetNode(index)
				if secondaryNode then
					local isVisible = barGroups.secondary.isVisible and secondaryNode.isVisible
					return secondaryNode:GetFrame(), true, isVisible
				end
			end
			return nil, true, false
		end

		-- Handle Power Word: Radiance frames (PowerWordRadiance1, PowerWordRadiance2)
		if TRB.Data.character.specId == 1 then
			local pwrMatch = string.match(relativeToFrame, "^PowerWordRadiance(%d+)$")
			if pwrMatch ~= nil then
				local chargeIndex = tonumber(pwrMatch)
				if chargeIndex ~= nil then
					local discTalents = TRB.Data.specCache.priest_discipline and TRB.Data.specCache.priest_discipline.talents
					local discSpells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Priest.DisciplineSpells]]
					local discSettings = TRB.Data.settings.priest.discipline

					if discTalents and discTalents:IsTalentActive(discSpells.powerWordRadiance) and discSettings.colors.comboPoints.powerWordRadiance.enabled then
						local maxCharges = discTalents:IsTalentActive(discSpells.lightsPromise) and 2 or 1
						if chargeIndex >= 1 and chargeIndex <= maxCharges then
							if barGroups and barGroups.secondary then
								local secondaryNode = barGroups.secondary:GetNode(chargeIndex)
								if secondaryNode then
									local isVisible = barGroups.secondary.isVisible and secondaryNode.isVisible
									return secondaryNode:GetFrame(), true, isVisible
								end
							end
						end
					end
				end
				return nil, false, false
			end
		end

		-- Handle Holy Word frames (HolyWordSerenity1, HolyWordSanctify1, HolyWordChastise1, etc.)
		if TRB.Data.character.specId == 2 then
			if string.match(relativeToFrame, "^HolyWord") then
				-- Use the runtime node mapping built by UpdateResourceBar / ConstructResourceBar.
				-- Lazily rebuild if not yet populated (bar text frames are created before first tick).
				if not TRB.Data.holyWordNodeMapping or not next(TRB.Data.holyWordNodeMapping) then
					BuildHolyWordNodeMapping()
				end
				local nodeMapping = TRB.Data.holyWordNodeMapping
				if nodeMapping then
					-- Extract the key and charge index from the frame name
					-- "HolyWordSerenity1" → key="holyWordSerenity", chargeIndex=1
					local hwName, chargeStr = string.match(relativeToFrame, "^(HolyWord%a+)(%d+)$")
					if hwName and chargeStr then
						-- Convert PascalCase frame name to camelCase key: "HolyWordSerenity" → "holyWordSerenity"
						local mappingKey = hwName:sub(1, 1):lower() .. hwName:sub(2) .. chargeStr
						local nodeIndex = nodeMapping[mappingKey]
						if nodeIndex and barGroups and barGroups.holyWords then
							local holyWordsNode = barGroups.holyWords:GetNode(nodeIndex)
							if holyWordsNode then
								local isVisible = barGroups.holyWords.isVisible and holyWordsNode.isVisible
								return holyWordsNode:GetFrame(), true, isVisible
							end
						end
					end
				end
				return nil, false, false
			end
		end

		-- Handle Lightweaver Charge frames (LightweaverCharge1, LightweaverCharge2, LightweaverCharge3, LightweaverCharge4)
		if TRB.Data.character.specId == 2 then
			local lwMatch = string.match(relativeToFrame, "^LightweaverCharge(%d+)$")
			if lwMatch ~= nil then
				local chargeIndex = tonumber(lwMatch)
				if chargeIndex ~= nil and chargeIndex >= 1 and chargeIndex <= 4 then
					if barGroups and barGroups.lightweaver then
						local lightweaverNode = barGroups.lightweaver:GetNode(chargeIndex)
						if lightweaverNode then
							local isVisible = barGroups.lightweaver.isVisible and lightweaverNode.isVisible
							return lightweaverNode:GetFrame(), true, isVisible
						end
					end
				end
				return nil, false, false
			end
		end

		-- Handle Angelic Feather Charge frames (AngelicFeatherCharge1, AngelicFeatherCharge2, AngelicFeatherCharge3)
		local afMatch = string.match(relativeToFrame, "^AngelicFeatherCharge(%d+)$")
		if afMatch ~= nil then
			local chargeIndex = tonumber(afMatch)
			if chargeIndex ~= nil and chargeIndex >= 1 and chargeIndex <= 3 then
				if barGroups and barGroups.utility then
					local utilityNode = barGroups.utility:GetNode(chargeIndex)
					if utilityNode then
						local isVisible = barGroups.utility.isVisible and utilityNode.isVisible
						return utilityNode:GetFrame(), true, isVisible
					end
				end
				return nil, true, false
			end
		end

		return nil, true, false
	end
	return nil, true, false
end

---Returns true when any spec-specific cooldown or buff timer is counting down.
---Disc: PW:Radiance CD, Angelic Feather CD; Holy: Holy Words CDs, Apotheosis, Lightweaver, AF CD;
---Shadow: Voidform, MFI, SotV, Entropic Rift, AF CD.
---@return boolean
function TRB.Functions.Class:HasActiveTimers()
	local snapshotData = TRB.Data.snapshotData
	local spells = TRB.Data.spellsData and TRB.Data.spellsData.spells
	if not snapshotData or not spells then return false end
	local snapshots = snapshotData.snapshots
	local specId = TRB.Data.character.specId
	local surgeOfLightActive = spells.surgeOfLight and snapshots[spells.surgeOfLight.id]
		and snapshots[spells.surgeOfLight.id].buff.isActive
	if specId == 1 then -- Discipline
		if (spells.powerWordRadiance and snapshots[spells.powerWordRadiance.id] and snapshots[spells.powerWordRadiance.id].cooldown and snapshots[spells.powerWordRadiance.id].cooldown.remaining > 0)
			or (spells.angelicFeather and snapshots[spells.angelicFeather.id] and snapshots[spells.angelicFeather.id].cooldown and snapshots[spells.angelicFeather.id].cooldown.remaining > 0)
			or surgeOfLightActive then
			return true
		end
	elseif specId == 2 then -- Holy
		if (spells.holyWordChastise and snapshots[spells.holyWordChastise.id] and snapshots[spells.holyWordChastise.id].cooldown and snapshots[spells.holyWordChastise.id].cooldown.remaining > 0)
			or (spells.holyWordSanctify and snapshots[spells.holyWordSanctify.id] and snapshots[spells.holyWordSanctify.id].cooldown and snapshots[spells.holyWordSanctify.id].cooldown.remaining > 0)
			or (spells.holyWordSerenity and snapshots[spells.holyWordSerenity.id] and snapshots[spells.holyWordSerenity.id].cooldown and snapshots[spells.holyWordSerenity.id].cooldown.remaining > 0)
			or (spells.apotheosis and snapshots[spells.apotheosis.id] and snapshots[spells.apotheosis.id].buff and snapshots[spells.apotheosis.id].buff.isActive)
			or (spells.lightweaver and snapshots[spells.lightweaver.id] and snapshots[spells.lightweaver.id].buff and snapshots[spells.lightweaver.id].buff.isActive)
			or (spells.angelicFeather and snapshots[spells.angelicFeather.id] and snapshots[spells.angelicFeather.id].cooldown and snapshots[spells.angelicFeather.id].cooldown.remaining > 0)
			or surgeOfLightActive then
			return true
		end
	elseif specId == 3 then -- Shadow
		if (spells.voidform and snapshots[spells.voidform.id] and snapshots[spells.voidform.id].buff and snapshots[spells.voidform.id].buff.isActive)
			or (spells.mindFlayInsanity and snapshots[spells.mindFlayInsanity.id] and snapshots[spells.mindFlayInsanity.id].buff and snapshots[spells.mindFlayInsanity.id].buff.isActive)
			or (spells.screamsOfTheVoid and snapshots[spells.screamsOfTheVoid.id] and snapshots[spells.screamsOfTheVoid.id].buff and snapshots[spells.screamsOfTheVoid.id].buff.isActive)
			or (spells.entropicRift and snapshots[spells.entropicRift.id] and snapshots[spells.entropicRift.id].buff and snapshots[spells.entropicRift.id].buff.isActive)
			or (spells.angelicFeather and snapshots[spells.angelicFeather.id] and snapshots[spells.angelicFeather.id].cooldown and snapshots[spells.angelicFeather.id].cooldown.remaining > 0) then
			return true
		end
	end
	return false
end

function TRB.Functions.Class:TriggerResourceBarUpdates()
	if TRB.Functions.Bar and TRB.Functions.Bar.IsRenderTransitionActive and Bar:IsRenderTransitionActive() then
		Bar:HideResourceBar(true)
		return
	end

	if not TRB.Data.specSupported or talents == nil then
		return
	end
	if (TRB.Data.character.specId ~= 1 and TRB.Data.character.specId ~= 2 and TRB.Data.character.specId ~= 3) then
		Bar:HideResourceBar(true)
		return
	end
	
	UpdateResourceBar()
end