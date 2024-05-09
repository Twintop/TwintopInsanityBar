local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId ~= 9 then --Only do this if we're on an Evoker!
	return
end

local L = TRB.Localization
TRB.Functions.Class = TRB.Functions.Class or {}

local barContainerFrame = TRB.Frames.barContainerFrame
local resource2Frame = TRB.Frames.resource2Frame
local resourceFrame = TRB.Frames.resourceFrame
local castingFrame = TRB.Frames.castingFrame
local passiveFrame = TRB.Frames.passiveFrame
local barBorderFrame = TRB.Frames.barBorderFrame

local targetsTimerFrame = TRB.Frames.targetsTimerFrame
local timerFrame = TRB.Frames.timerFrame
local combatFrame = TRB.Frames.combatFrame

local talents --[[@as TRB.Classes.Talents]]

Global_TwintopResourceBar = {}
TRB.Data.character = {}

---@type table<string, TRB.Classes.SpecCache>
local specCache = {
	affliction = TRB.Classes.SpecCache:New() --[[@as TRB.Classes.SpecCache]]
	
}

local function FillSpecializationCache()
	-- Affliction
	specCache.affliction.Global_TwintopResourceBar = {
		ttd = 0,
		resource = {
			resource = 0,
			casting = 0,
			passive = 0,
			regen = 0
		},
		dots = {
		},
		isPvp = false
	}

	specCache.affliction.character = {
		guid = UnitGUID("player"),
		specId = 1,
		maxResource = 10000,
		maxResource2 = 5,
		maxResource2Resource = 0,
		maxResource2ResourceMax = 1000,
		effects = {
		},
		items = {}
	}
	
	---@type TRB.Classes.Warlock.AfflictionSpells
	specCache.affliction.spellsData.spells = TRB.Classes.Warlock.AfflictionSpells:New()
	---@type TRB.Classes.Warlock.AfflictionSpells
	---@diagnostic disable-next-line: assign-type-mismatch
	local spells = specCache.affliction.spellsData.spells

	specCache.affliction.snapshotData.audio = {
		
	}

	specCache.affliction.barTextVariables = {
		icons = {},
		values = {}
	}

end

local function Setup_Affliction()
	if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "warlock", "affliction")
end

local function FillSpellData_Affliction()
	Setup_Affliction()
	specCache.affliction.spellsData:FillSpellData()
	local spells = specCache.affliction.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]

	-- This is done here so that we can get icons for the options menu!
	specCache.devastation.barTextVariables.icons = {
		{ variable = "#casting", icon = "", description = L["BarTextIconCasting"], printInSettings = true },
		{ variable = "#item_ITEMID_", icon = "", description = L["BarTextIconCustomItem"], printInSettings = true },
		{ variable = "#spell_SPELLID_", icon = "", description = L["BarTextIconCustomSpell"], printInSettings = true },
	}
	specCache.devastation.barTextVariables.values = {
		{ variable = "$gcd", description = L["BarTextVariableGcd"], printInSettings = true, color = false },
		{ variable = "$haste", description = L["BarTextVariableHaste"], printInSettings = true, color = false },
		{ variable = "$hastePercent", description = L["BarTextVariableHaste"], printInSettings = false, color = false },
		{ variable = "$hasteRating", description = L["BarTextVariableHasteRating"], printInSettings = true, color = false },
		{ variable = "$crit", description = L["BarTextVariableCrit"], printInSettings = true, color = false },
		{ variable = "$critPercent", description = L["BarTextVariableCrit"], printInSettings = false, color = false },
		{ variable = "$critRating", description = L["BarTextVariableCritRating"], printInSettings = true, color = false },
		{ variable = "$mastery", description = L["BarTextVariableMastery"], printInSettings = true, color = false },
		{ variable = "$masteryPercent", description = L["BarTextVariableMastery"], printInSettings = false, color = false },
		{ variable = "$masteryRating", description = L["BarTextVariableMasteryRating"], printInSettings = true, color = false },
		{ variable = "$vers", description = L["BarTextVariableVers"], printInSettings = true, color = false },
		{ variable = "$versPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$versatility", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVers", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$oVersPercent", description = L["BarTextVariableVers"], printInSettings = false, color = false },
		{ variable = "$dVers", description = L["BarTextVariableVersDefense"], printInSettings = true, color = false },
		{ variable = "$dVersPercent", description = L["BarTextVariableVersDefense"], printInSettings = false, color = false },
		{ variable = "$versRating", description = L["BarTextVariableVersRating"], printInSettings = true, color = false },
		{ variable = "$versatilityRating", description = L["BarTextVariableVersRating"], printInSettings = false, color = false },

		{ variable = "$int", description = L["BarTextVariableIntellect"], printInSettings = true, color = false },
		{ variable = "$intellect", description = L["BarTextVariableIntellect"], printInSettings = false, color = false },
		{ variable = "$agi", description = L["BarTextVariableAgility"], printInSettings = true, color = false },
		{ variable = "$agility", description = L["BarTextVariableAgility"], printInSettings = false, color = false },
		{ variable = "$str", description = L["BarTextVariableStrength"], printInSettings = true, color = false },
		{ variable = "$strength", description = L["BarTextVariableStrength"], printInSettings = false, color = false },
		{ variable = "$stam", description = L["BarTextVariableStamina"], printInSettings = true, color = false },
		{ variable = "$stamina", description = L["BarTextVariableStamina"], printInSettings = false, color = false },
		
		{ variable = "$inCombat", description = L["BarTextVariableInCombat"], printInSettings = true, color = false },

		{ variable = "$resourceMax", description = "", printInSettings = false, color = false },
		
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },
		{ variable = "$comboPoints", description = "", printInSettings = false, color = false },

		{ variable = "$ttd", description = L["BarTextVariableTtd"], printInSettings = true, color = true },
		{ variable = "$ttdSeconds", description = L["BarTextVariableTtdSeconds"], printInSettings = true, color = true }
	}
end

local function RefreshTargetTracking()
	local currentTime = GetTime()
	local specId = GetSpecialization()
	
	if specId == 1 then -- Affliction
	
	end
end

local function TargetsCleanup(clearAll)
	---@type TRB.Classes.TargetData
	local targetData = TRB.Data.snapshotData.targetData
	targetData:Cleanup(clearAll)
	if clearAll == true then
		local specId = GetSpecialization()
		if specId == 1 then
		
		end
	end
end

local function ConstructResourceBar(settings)
	local specId = GetSpecialization()
	local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
	if entries > 0 then
		for x = 1, entries do
			resourceFrame.thresholds[x]:Hide()
		end
	end

	if specId == 1 then
		local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
		local thresholdId = 1
		for _, v in pairs(spells) do
			local spell = v --[[@as TRB.Classes.SpellBase]]
			if (spell:Is("TRB.Classes.SpellThreshold") or spell:Is("TRB.Classes.SpellComboPointThreshold")) and spell:IsValid() then
				spell = spell --[[@as TRB.Classes.SpellThreshold]]
				if TRB.Frames.resourceFrame.thresholds[thresholdId] == nil then
					TRB.Frames.resourceFrame.thresholds[thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end
				TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[thresholdId], settings, true)
				TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[thresholdId], spell, settings)

				TRB.Frames.resourceFrame.thresholds[thresholdId]:Show()
				TRB.Frames.resourceFrame.thresholds[thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[thresholdId]:Hide()
				thresholdId = thresholdId + 1
			end
		end
    end
	TRB.Functions.Class:CheckCharacter()
	TRB.Frames.resource2ContainerFrame:Show()
	TRB.Functions.Bar:Construct(settings)
	TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
end


local function RefreshLookupData_Affliction()
	local currentTime = GetTime()
	local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local specSettings = TRB.Data.settings.warlock.affliction

	----------------------------

	local lookup = TRB.Data.lookup or {}
	
	lookup["$manaMax"] = TRB.Data.character.maxResource
	lookup["$resourceMax"] = TRB.Data.character.maxResource
	lookup["$essence"] = snapshotData.attributes.resource2
	lookup["$comboPoints"] = snapshotData.attributes.resource2
	lookup["$essenceMax"] = TRB.Data.character.maxResource
	lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookup = lookup

	local lookupLogic = TRB.Data.lookupLogic or {}
	lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
	lookupLogic["$resource"] = snapshotData.attributes.resource
	lookupLogic["$casting"] = snapshotData.casting.resourceFinal
	lookupLogic["$essence"] = snapshotData.attributes.resource2
	lookupLogic["$comboPoints"] = snapshotData.attributes.resource2
	lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
	TRB.Data.lookupLogic = lookupLogic
end

local function UpdateSnapshot()
	TRB.Functions.Character:UpdateSnapshot()
	local currentTime = GetTime()
end

local function UpdateSnapshot_Affliction()
	UpdateSnapshot()
	
	local currentTime = GetTime()
	local _
end

local function UpdateResourceBar()
	local currentTime = GetTime()
	local refreshText = false
	local specId = GetSpecialization()
	local coreSettings = TRB.Data.settings.core
	local classSettings = TRB.Data.settings.warlock
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots

	if specId == 1 then
		local specSettings = classSettings.affliction
		UpdateSnapshot_Affliction()
		TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

		if snapshotData.attributes.isTracking then
			TRB.Functions.Bar:HideResourceBar()

			if specSettings.displayBar.neverShow == false then
				local spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
				refreshText = true
				local passiveBarValue = 0
				local castingBarValue = 0
				local currentResource = snapshotData.attributes.resource / TRB.Data.resourceFactor
				local barColor = specSettings.colors.bar.base
				local barBorderColor = specSettings.colors.bar.border

				TRB.Functions.Bar:SetPrimaryValue(specSettings, resourceFrame, currentResource)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, castingFrame, castingBarValue)
				TRB.Functions.Bar:SetPrimaryValue(specSettings, passiveFrame, passiveBarValue)

				barContainerFrame:SetAlpha(1.0)


				barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

				resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
				
				local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
				for x = 1, TRB.Data.character.maxResource2 do
					local cpBorderColor = specSettings.colors.comboPoints.border
					local cpColor = specSettings.colors.comboPoints.base
					local cpBR = cpBackgroundRed
					local cpBG = cpBackgroundGreen
					local cpBB = cpBackgroundBlue

					if snapshotData.attributes.resource2 >= x then
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
						if (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
							cpColor = specSettings.colors.comboPoints.penultimate
						elseif (specSettings.comboPoints.sameColor and snapshotData.attributes.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
							cpColor = specSettings.colors.comboPoints.final
						end
					elseif snapshotData.attributes.resource2+1 == x then
						local partial = UnitPartialPower("player", Enum.PowerType.SouldShards)
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, partial, 1000)
					else
						TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
					end

					TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
					TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
					TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
				end
			end
		end
		TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
	end
end

barContainerFrame:SetScript("OnEvent", function(self, event, ...)
	local currentTime = GetTime()
	local triggerUpdate = false
	local _
	local specId = GetSpecialization()
	local spells
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local targetData = snapshotData.targetData
	local snapshots = snapshotData.snapshots

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local entry = TRB.Classes.CombatLogEntry:GetCurrentEventInfo()
		
		local settings
		if specId == 1 then
			spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
			settings = TRB.Data.settings.warlock.affliction
        end
		if entry.sourceGuid == TRB.Data.character.guid then
			if specId == 1 and TRB.Data.barConstructedForSpec == "affliction" then --Affliction					

			-- Spec Agnostic
			-- if entry.spellId == spells.essenceBurst.id then
			-- 	snapshots[entry.spellId].buff:Initialize(entry.type)
			-- 	if entry.type == "SPELL_AURA_REMOVED_DOSE" then -- Lost stack
			-- 		snapshotData.audio.essenceBurst2Cue = false
			-- 	elseif entry.type == "SPELL_AURA_REMOVED" then -- Lost buff
			-- 		snapshotData.audio.essenceBurstCue = false
			-- 		snapshotData.audio.essenceBurst2Cue = false
			-- 	end
			 end
		end

		if entry.destinationGuid ~= TRB.Data.character.guid and (entry.type == "UNIT_DIED" or entry.type == "UNIT_DESTROYED" or entry.type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
			targetData:Remove(entry.destinationGuid)
			RefreshTargetTracking()
			triggerUpdate = true
		end
	end

	if triggerUpdate then
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end)

function targetsTimerFrame:onUpdate(sinceLastUpdate)
	local currentTime = GetTime()
	self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
	if self.sinceLastUpdate >= 1 then -- in seconds
		TargetsCleanup()
		RefreshTargetTracking()
		TRB.Functions.Class:TriggerResourceBarUpdates()
		self.sinceLastUpdate = 0
	end
end

combatFrame:SetScript("OnEvent", function(self, event, ...)
	if event =="PLAYER_REGEN_DISABLED" then
		TRB.Functions.Bar:ShowResourceBar()
	else
		TRB.Functions.Bar:HideResourceBar()
	end
end)


local function SwitchSpec()
	barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local specId = GetSpecialization()
	if specId == 1 then
		specCache.affliction.talents:GetTalents()
		FillSpellData_Affliction()
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.affliction)
		
		---@type TRB.Classes.TargetData
		TRB.Data.snapshotData.targetData = TRB.Classes.TargetData:New()

		TRB.Functions.RefreshLookupData = RefreshLookupData_Affliction
		TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.warlock.affliction)
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warlock.affliction)

		if TRB.Data.barConstructedForSpec ~= "affliction" then
			talents = specCache.affliction.talents
			TRB.Data.barConstructedForSpec = "affliction"
			ConstructResourceBar(specCache.affliction.settings)
		end
	else
		TRB.Data.barConstructedForSpec = nil
	end

	TRB.Functions.Class:EventRegistration()
end


resourceFrame:RegisterEvent("ADDON_LOADED")
resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	local specId = GetSpecialization() or 0
	if classIndexId == 9 then
		if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
			if not TRB.Details.addonData.loaded then
				TRB.Details.addonData.loaded = true

				if TwintopInsanityBarSettings and TRB.Functions.Table:Length(TwintopInsanityBarSettings) > 0 then
					TRB.Options:PortForwardSettings()

					local settings = TRB.Options.Warlock.LoadDefaultSettings(false)

					if TwintopInsanityBarSettings.warlock == nil or
						TwintopInsanityBarSettings.warlock.affliction == nil or
						TwintopInsanityBarSettings.warlock.affliction.displayText == nil then
						settings.warlock.affliction.displayText.barText = TRB.Options.Warlock.AfflictionLoadDefaultBarTextSimpleSettings()
					end

					TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
					TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
				else
					local settings = TRB.Options.Warlock.LoadDefaultSettings(true)
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

		if TRB.Details.addonData.loaded and specId > 0 then
			if not TRB.Details.addonData.optionsPanel then
				TRB.Details.addonData.optionsPanel = true
				-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
				C_Timer.After(0, function()
					C_Timer.After(1, function()
						TRB.Data.barConstructedForSpec = nil
						TRB.Data.settings.warlock.affliction = TRB.Functions.LibSharedMedia:ValidateLsmValues("Affliction Warlock", TRB.Data.settings.warlock.affliction)

						FillSpellData_Affliction()

						SwitchSpec()

						TRB.Options.Warlock.ConstructOptionsPanel(specCache)
						
						-- Reconstruct just in case
						if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
							ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
						end
						TRB.Functions.Class:EventRegistration()
					end)
				end)
			end

			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
				SwitchSpec()
			end
		end
	end
end)

function TRB.Functions.Class:CheckCharacter()
	local specId = GetSpecialization()
	TRB.Functions.Character:CheckCharacter()
	TRB.Data.character.className = "warlock"
	TRB.Data.character.maxResource = UnitPowerMax("player", TRB.Data.resource)
	TRB.Data.character.maxResource2 = 1
	local maxComboPoints = UnitPowerMax("player", TRB.Data.resource2)
	local settings = nil
	if specId == 1 then
		settings = TRB.Data.settings.warlock.affliction
		TRB.Data.character.specName = "affliction"

    end
	if settings ~= nil then
		if maxComboPoints ~= TRB.Data.character.maxResource2 then
			TRB.Data.character.maxResource2 = maxComboPoints
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end
end

function TRB.Functions.Class:EventRegistration()
	local specId = GetSpecialization()
	if specId == 1 and TRB.Data.settings.core.enabled.warlock.affliction then
		TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.warlock.affliction)
		TRB.Data.specSupported = true
		TRB.Data.resource = Enum.PowerType.Mana
		TRB.Data.resourceFactor = 1
		TRB.Data.resource2 = Enum.PowerType.Essence
		TRB.Data.resource2Factor = 1
	else -- This should never happen
		TRB.Data.specSupported = false
	end

	if TRB.Data.specSupported then
		TRB.Functions.Class:CheckCharacter()

		targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
		timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
		barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

		TRB.Details.addonData.registered = true
	else -- This should never happen
		targetsTimerFrame:SetScript("OnUpdate", nil)
		timerFrame:SetScript("OnUpdate", nil)
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		TRB.Details.addonData.registered = false
		barContainerFrame:Hide()
	end

	TRB.Functions.Bar:HideResourceBar()
end


function TRB.Functions.Class:HideResourceBar(force)
	local affectingCombat = UnitAffectingCombat("player")
	---@type TRB.Classes.SnapshotData
	local snapshotData = TRB.Data.snapshotData or TRB.Classes.SnapshotData:New()
	local specId = GetSpecialization()

	if specId == 1 then
		if not TRB.Data.specSupported or force or
		(TRB.Data.character.advancedFlight and not TRB.Data.settings.warlock.affliction.displayBar.dragonriding) or 
		((not affectingCombat) and
			(not UnitInVehicle("player")) and (
				(not TRB.Data.settings.warlock.affliction.displayBar.alwaysShow) and (
					(not TRB.Data.settings.warlock.affliction.displayBar.notZeroShow) or
					(TRB.Data.settings.warlock.affliction.displayBar.notZeroShow and snapshotData.attributes.resource == TRB.Data.character.maxResource and snapshotData.attributes.resource2 == TRB.Data.character.maxResource2)
				)
			)) then
			TRB.Frames.barContainerFrame:Hide()
			snapshotData.attributes.isTracking = false
		else
			snapshotData.attributes.isTracking = true
			if TRB.Data.settings.warlock.affliction.displayBar.neverShow == true then
				TRB.Frames.barContainerFrame:Hide()
			else
				TRB.Frames.barContainerFrame:Show()
			end
		end
	else
		TRB.Frames.barContainerFrame:Hide()
		snapshotData.attributes.isTracking = false
	end
end

function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed)
	if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
		return false
	end
	
	if guid ~= nil and guid ~= "" then
		local targetData = TRB.Data.snapshotData.targetData --[[@as TRB.Classes.TargetData]]
		local targets = targetData.targets

		if not targetData:CheckTargetExists(guid) then
			targetData:InitializeTarget(guid)
		end
		targets[guid].lastUpdate = GetTime()
		return true
	end
	return false
end


function TRB.Functions.Class:IsValidVariableForSpec(var)
	local valid = TRB.Functions.BarText:IsValidVariableBase(var)
	if valid then
		return valid
	end
	local specId = GetSpecialization()
	local snapshotData = TRB.Data.snapshotData --[[@as TRB.Classes.SnapshotData]]
	local snapshots = snapshotData.snapshots
	local spells
	local target = snapshotData.targetData.targets[snapshotData.targetData.currentTargetGuid]
	local settings = nil
	if specId == 1 then
		spells = TRB.Data.spellsData.spells --[[@as TRB.Classes.Warlock.AfflictionSpells]]
		settings = TRB.Data.settings.warlock.affliction
	else
		return false
	end

	if specId == 1 then --Devastation			
	elseif specId == 3 then -- Augmentation
	end

	--Spec agnostic
	if var == "$casting" then
		if snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0 then
			valid = true
		end
	elseif var == "$resource" or var == "$mana" then
		if snapshotData.attributes.resource > 0 then
			valid = true
		end
	elseif var == "$resourceMax" or var == "$manaMax" then
		valid = true
	elseif var == "$resourceTotal" or var == "$manaTotal" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0)
			then
			valid = true
		end
	elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
		if snapshotData.attributes.resource > 0 or
			(snapshotData.casting.resourceRaw ~= nil and snapshotData.casting.resourceRaw ~= 0) then
			valid = true
		end
	elseif var == "$regen" then
		if snapshotData.attributes.resource < TRB.Data.character.maxResource and
			((settings.generation.mode == "time" and settings.generation.time > 0) or
			(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
			valid = true
		end
	elseif var == "$comboPoints" or var == "$essence" then
		valid = true
	elseif var == "$comboPointsMax"or var == "$essenceMax" then
		valid = true
	end

	return valid
end

function TRB.Functions.Class:GetBarTextFrame(relativeToFrame)
	return nil
end


--HACK to fix FPS
local updateRateLimit = 0

function TRB.Functions.Class:TriggerResourceBarUpdates()
	local specId = GetSpecialization()
	if (specId ~= 1) then
		TRB.Functions.Bar:HideResourceBar(true)
		return
	end

	local currentTime = GetTime()

	if updateRateLimit + 0.05 < currentTime then
		updateRateLimit = currentTime
		UpdateResourceBar()
	end
end