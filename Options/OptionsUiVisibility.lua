---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Visibility = TRB.Functions.OptionsUi.Visibility or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

---Returns the RGB color values used for "Use Global Settings" checkbox label text.
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/255
end

-- ============================================================================
-- Bar visibility options
-- ============================================================================

---Creates extra Show Bar When threshold options for a specific bar.
---@param displayBarKey string The displayBar key that should expose these options
---@param thresholdTypes table[] Threshold definitions to attach to the bar
---@return table[] thresholdTypes Extra threshold definitions for GenerateBarVisibilityOptions
function TRB.Functions.OptionsUi.Visibility:CreateBarVisibilityThresholdTypes(displayBarKey, thresholdTypes)
	local results = {}
	for _, thresholdType in ipairs(thresholdTypes or {}) do
		table.insert(results, {
			displayBarKey = displayBarKey,
			barKey = thresholdType.barKey,
			key = thresholdType.key,
			label = thresholdType.label,
			comparisonLabel = thresholdType.comparisonLabel,
			valueLabel = thresholdType.valueLabel,
			isPercent = thresholdType.isPercent,
			header = thresholdType.header,
			maxValue = thresholdType.maxValue,
		})
	end
	return results
end

---Generates the bar visibility options panel with per-bar condition dropdowns, alpha/fade sliders, and smooth checkbox.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer? Class ID (nil for global panel)
---@param specId integer? Spec ID (nil for global panel)
---@param yCoord number Starting Y coordinate
---@param primaryResourceString string? Localized primary resource name
---@param showWhenCategory string? Legacy parameter, no longer used
---@param includeSecondaryVisibility boolean? Whether to include secondary resource bar visibility
---@param secondaryResourceString string? Localized secondary resource name
---@param includeHealthVisibility boolean? Whether to include health bar visibility
---@param includeManaBarVisibility boolean? Whether to include mana bar visibility
---@param customBars TRB.Classes.BarTypeDefinition[]? Custom bar definitions to include
---@param extraThresholdTypes table[]? Extra threshold condition definitions to include for matching bars
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, showWhenCategory, includeSecondaryVisibility, secondaryResourceString, includeHealthVisibility, includeManaBarVisibility, customBars, extraThresholdTypes)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_barVisibility"
	local f = nil
	if customBars == nil then
		customBars = {}
	end
	if extraThresholdTypes == nil then
		extraThresholdTypes = {}
	end

	-- Forward-declare so the checkbox OnClick (defined before the table) can call it
	local RefreshTableForGlobalToggle = nil

	---Returns true when this is a spec options panel and the "Use global settings" checkbox is checked for displayBar.
	local function IsUsingGlobalDisplayBar()
		if classId == nil or specId == nil then
			return false
		end
		local lc = string.lower(className)
		return TRB.Data.settings.core.global[lc][specName].displayBar == true
	end

	controls.barDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, L["BarDisplayHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes = controls.checkBoxes or {}
		controls.checkBoxes.useGlobalDisplayBar = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_displayBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalDisplayBar
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "barVisibility")
		f.tooltip = L["CheckboxUseGlobalTooltip_BarDisplay"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayBar)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayBar = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.BarVisibility:MarkDirty()
					TRB.Functions.Bar:HideResourceBar()
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Data.lookupDirty = true
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				end
			end
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("displayBar")
			if RefreshTableForGlobalToggle then
				RefreshTableForGlobalToggle()
			end
		end)
		TRB.Functions.OptionsUi.GlobalCopy:BuildUseGlobalCopyButton(f, classId, specId, "displayBar")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllDisplayBar", "displayBar", yCoord)
	end

	yCoord = yCoord - 30
	local isDruidVisibilityPanel = classId == 11 or (classId == nil and TRB.Data.character ~= nil and TRB.Data.character.classId == 11)
	local druidFormConditionKeys = { "isDruidHumanoidForm", "isDruidTravelFormAny", "isDruidStagForm", "isDruidFlightForm", "isDruidSwiftFlightForm", "isDruidAquaticForm", "isDruidCatForm", "isDruidBearForm", "isDruidMoonkinForm" }
	local druidFormConditionLabels = {
		isDruidHumanoidForm = L["ShowBarVisibilityConditionDruidHumanoidForm"],
		isDruidTravelFormAny = L["ShowBarVisibilityConditionDruidTravelFormAny"],
		isDruidStagForm = L["ShowBarVisibilityConditionDruidStagForm"],
		isDruidFlightForm = L["ShowBarVisibilityConditionDruidFlightForm"],
		isDruidSwiftFlightForm = L["ShowBarVisibilityConditionDruidSwiftFlightForm"],
		isDruidAquaticForm = L["ShowBarVisibilityConditionDruidAquaticForm"],
		isDruidCatForm = L["ShowBarVisibilityConditionDruidCatForm"],
		isDruidBearForm = L["ShowBarVisibilityConditionDruidBearForm"],
		isDruidMoonkinForm = L["ShowBarVisibilityConditionDruidMoonkinForm"],
	}

	-- Condition definitions for multi-select bar visibility
	local conditionKeys = { "inCombat", "inVehicle", "hasFriendlyTarget", "hasUnfriendlyTarget", "isMountedAny", "isMountedGround", "isSkyriding", "isSkyridingFlying", "isSteadyFlight", "isSteadyFlightFlying", "inGroup", "inRaid", "inInstance", "inDungeon", "inRaidInstance", "inBattleground", "inArena", "inDelve", "isPvpFlagged", "isWarMode" }
	local conditionLabels = {
		inCombat = L["ShowBarVisibilityConditionInCombat"],
		inVehicle = L["ShowBarVisibilityConditionInVehicle"],
		hasFriendlyTarget = L["ShowBarVisibilityConditionFriendlyTarget"],
		hasUnfriendlyTarget = L["ShowBarVisibilityConditionUnfriendlyTarget"],
		isMountedAny = L["ShowBarVisibilityConditionIsMountedAny"],
		isMountedGround = L["ShowBarVisibilityConditionIsMountedGround"],
		isSkyriding = L["ShowBarVisibilityConditionIsSkyriding"],
		isSkyridingFlying = L["ShowBarVisibilityConditionIsSkyridingFlying"],
		isSteadyFlight = L["ShowBarVisibilityConditionIsSteadyFlight"],
		isSteadyFlightFlying = L["ShowBarVisibilityConditionIsSteadyFlightFlying"],
		inGroup = L["ShowBarVisibilityConditionInGroup"],
		inRaid = L["ShowBarVisibilityConditionInRaidGroup"],
		inInstance = L["ShowBarVisibilityConditionInInstance"],
		inDungeon = L["ShowBarVisibilityConditionInDungeon"],
		inRaidInstance = L["ShowBarVisibilityConditionInRaidInstance"],
		inBattleground = L["ShowBarVisibilityConditionInBattleground"],
		inArena = L["ShowBarVisibilityConditionInArena"],
		inDelve = L["ShowBarVisibilityConditionInDelve"],
		isPvpFlagged = L["ShowBarVisibilityConditionIsPvpFlagged"],
		isWarMode = L["ShowBarVisibilityConditionIsWarMode"],
	}

	-- Grouped condition sections for the dropdown
	local conditionGroups = {
		{
			title = L["ShowBarVisibilityGroupGeneral"],
			keys = { "inCombat", "inVehicle", "hasFriendlyTarget", "hasUnfriendlyTarget" },
		},
		{
			title = L["ShowBarVisibilityGroupMounting"],
			keys = { "isMountedAny", "isMountedGround", "isSkyriding", "isSkyridingFlying", "isSteadyFlight", "isSteadyFlightFlying" },
		},
		{
			title = L["ShowBarVisibilityGroupSocial"],
			keys = { "inGroup", "inRaid" },
		},
		{
			title = L["ShowBarVisibilityGroupLocation"],
			keys = { "inInstance", "inDungeon", "inRaidInstance", "inDelve", "inArena", "inBattleground" },
		},
		{
			title = L["ShowBarVisibilityGroupPvP"],
			keys = { "isPvpFlagged", "isWarMode" },
		},
	}
	if isDruidVisibilityPanel then
		for _, key in ipairs(druidFormConditionKeys) do
			table.insert(conditionKeys, key)
			conditionLabels[key] = druidFormConditionLabels[key]
		end
		table.insert(conditionGroups, {
			title = L["ShowBarVisibilityGroupDruidForms"],
			keys = druidFormConditionKeys,
		})
	end

	local hideConditionKeys = { "isMountedAny", "isMountedGround", "isMountedFlying", "isSteadyFlightFlying", "isSkyriding", "isSkyridingFlying", "inVehicle", "inPetBattle", "onTaxi" }
	local hideConditionLabels = {
		isMountedAny = L["ShowBarVisibilityConditionIsMountedAny"],
		isMountedGround = L["ShowBarVisibilityConditionIsMountedGround"],
		isMountedFlying = L["ShowBarVisibilityConditionIsSteadyFlight"],
		isSteadyFlightFlying = L["ShowBarVisibilityConditionIsSteadyFlightFlying"],
		isSkyriding = L["ShowBarVisibilityConditionIsSkyriding"],
		isSkyridingFlying = L["ShowBarVisibilityConditionIsSkyridingFlying"],
		inVehicle = L["ShowBarVisibilityConditionInVehicle"],
		inPetBattle = L["ShowBarVisibilityConditionInPetBattle"],
		onTaxi = L["ShowBarVisibilityConditionOnTaxi"],
	}
	local hideConditionGroups = {
		{
			title = L["ShowBarVisibilityGroupGeneral"],
			keys = { "inVehicle", "inPetBattle", "onTaxi" },
		},
		{
			title = L["ShowBarVisibilityGroupMounting"],
			keys = { "isMountedAny", "isMountedGround", "isSkyriding", "isSkyridingFlying", "isMountedFlying", "isSteadyFlightFlying" },
		},
	}
	if isDruidVisibilityPanel then
		for _, key in ipairs(druidFormConditionKeys) do
			table.insert(hideConditionKeys, key)
			hideConditionLabels[key] = druidFormConditionLabels[key]
		end
		table.insert(hideConditionGroups, {
			title = L["ShowBarVisibilityGroupDruidForms"],
			keys = druidFormConditionKeys,
		})
	end

	-- Castbar-specific condition profile: show conditions are cast states (not environment), the only
	-- hard-hide condition is In Vehicle, and resource/health thresholds don't apply. Empowered is only
	-- offered on the global panel and on specs with empowered abilities.
	local castbarConditionKeys = { "casting", "channeling" }
	if classId == nil or TRB.Functions.OptionsUi.Castbar:SpecUsesEmpower(classId, specId) then
		table.insert(castbarConditionKeys, "empowered")
	end
	local castbarConditionLabels = {
		casting = L["ShowBarVisibilityConditionCasting"],
		channeling = L["ShowBarVisibilityConditionChanneling"],
		empowered = L["ShowBarVisibilityConditionEmpowered"],
	}
	local castbarProfile = {
		showKeys = castbarConditionKeys,
		showLabels = castbarConditionLabels,
		showGroups = { { title = L["ShowBarVisibilityGroupCasting"], keys = castbarConditionKeys } },
		hideKeys = { "inVehicle" },
		hideLabels = { inVehicle = L["ShowBarVisibilityConditionInVehicle"] },
		hideGroups = { { title = L["ShowBarVisibilityGroupGeneral"], keys = { "inVehicle" } } },
		supportsThresholds = false,
	}
	-- Target/Focus cast bars: a target can be any class, so Empowered is always offered (unlike the player
	-- castbar, which gates it on the player's own spec). Otherwise identical to the player castbar profile.
	local targetCastbarConditionKeys = { "casting", "channeling", "empowered" }
	local targetCastbarProfile = {
		showKeys = targetCastbarConditionKeys,
		showLabels = castbarConditionLabels,
		showGroups = { { title = L["ShowBarVisibilityGroupCasting"], keys = targetCastbarConditionKeys } },
		hideKeys = { "inVehicle" },
		hideLabels = { inVehicle = L["ShowBarVisibilityConditionInVehicle"] },
		hideGroups = { { title = L["ShowBarVisibilityGroupGeneral"], keys = { "inVehicle" } } },
		supportsThresholds = false,
	}
	local standardProfile = {
		showKeys = conditionKeys,
		showLabels = conditionLabels,
		showGroups = conditionGroups,
		hideKeys = hideConditionKeys,
		hideLabels = hideConditionLabels,
		hideGroups = hideConditionGroups,
		supportsThresholds = true,
	}

	---Returns the condition profile (show/hide keys, labels, groups) for a bar entry.
	---@param barEntry table?
	---@return table profile
	local function GetProfileForEntry(barEntry)
		if barEntry ~= nil and barEntry.isCastbar then
			if barEntry.displayBarKey == "targetCastbar" or barEntry.displayBarKey == "focusCastbar" then
				return targetCastbarProfile
			end
			return castbarProfile
		end
		return standardProfile
	end

	-- Labels for resource/health threshold condition types (used in dropdown and summary)
	-- Ordered array so dropdown items render in a deterministic, logical order.
	local baseThresholdTypes = {
		{ key = "resourcePercent", label = L["BarVisibilityThresholdResourcePercent"], comparisonLabel = L["BarVisibilityThresholdResourcePercentComparison"], valueLabel = L["BarVisibilityThresholdResourcePercentValue"], isPercent = true },
		{ key = "resourceValue",   label = L["BarVisibilityThresholdResourceValue"],   comparisonLabel = L["BarVisibilityThresholdResourceValueComparison"],   valueLabel = L["BarVisibilityThresholdResourceValueValue"],   isPercent = false },
		{ key = "healthPercent",   label = L["BarVisibilityThresholdHealthPercent"],   comparisonLabel = L["BarVisibilityThresholdHealthPercentComparison"],   valueLabel = L["BarVisibilityThresholdHealthPercentValue"],   isPercent = true },
		{ key = "healthValue",     label = L["BarVisibilityThresholdHealthValue"],     comparisonLabel = L["BarVisibilityThresholdHealthValueComparison"],     valueLabel = L["BarVisibilityThresholdHealthValueValue"],     isPercent = false },
	}
	local thresholdTypeDefinitions = {}
	for _, tt in ipairs(baseThresholdTypes) do
		thresholdTypeDefinitions[tt.key] = tt
	end
	for _, tt in ipairs(extraThresholdTypes) do
		thresholdTypeDefinitions[tt.key] = tt
	end

	local function GetThresholdTypesForBarEntry(barEntry)
		if barEntry ~= nil and barEntry.isCastbar then
			return {}
		end
		local types = {}
		for _, tt in ipairs(baseThresholdTypes) do
			table.insert(types, tt)
		end

		if barEntry ~= nil then
			for _, tt in ipairs(extraThresholdTypes) do
				local matchesDisplayBarKey = tt.displayBarKey == nil or tt.displayBarKey == barEntry.displayBarKey
				local matchesBarKey = tt.barKey == nil or tt.barKey == barEntry.key
				local hasRuntimeDefinition = spec.barVisibilityThresholds ~= nil and spec.barVisibilityThresholds[tt.key] ~= nil
				if matchesDisplayBarKey and matchesBarKey and hasRuntimeDefinition then
					table.insert(types, tt)
				end
			end
		end

		return types
	end

	---Builds a compact summary from a set of boolean conditions.
	---@param selectedLabels string[] The selected condition labels
	---@return string displayName The summary display text
	local function GetConditionDisplayName(selectedLabels)
		if #selectedLabels == 0 then
			return string.format(L["ShowBarVisibilitySelectedCount"], 0)
		end
		if #selectedLabels == 1 then
			return selectedLabels[1]
		end
		return string.format(L["ShowBarVisibilitySelectedCount"], #selectedLabels)
	end

	---Builds a localized summary string describing the show side of a visibility entry.
	---@param entry table The visibility settings entry
	---@param profile table The condition profile for the bar (see GetProfileForEntry)
	---@return string displayName The show summary display text
	local function GetShowVisibilityDisplayName(entry, profile)
		if entry.neverShow then
			return L["ShowBarVisibilityNever"]
		end
		if entry.alwaysShow then
			return L["ShowBarVisibilityAlways"]
		end
		local conditions = entry.conditions
		if conditions == nil then
			-- Legacy fallback for unmigrated data
			if entry.visibility == "never" then return L["ShowBarVisibilityNever"] end
			if entry.visibility == "combat" then return L["ShowBarVisibilityCombat"] end
			return L["ShowBarVisibilityAlways"]
		end
		local selectedLabels = {}
		for _, key in ipairs(profile.showKeys) do
			if conditions[key] then
				table.insert(selectedLabels, profile.showLabels[key])
			end
		end
		-- Include resource/health threshold as an additional condition in the summary
		local ct = entry.resourceConditionType
		if profile.supportsThresholds and ct ~= nil and ct ~= "none" and thresholdTypeDefinitions[ct] ~= nil then
			table.insert(selectedLabels, thresholdTypeDefinitions[ct].label)
		end
		return GetConditionDisplayName(selectedLabels)
	end

	---Counts selected options in the show-condition dropdown.
	---@param entry table The visibility settings entry
	---@param profile table The condition profile for the bar
	---@return number selectedCount The number of selected show options
	local function GetShowVisibilitySelectedCount(entry, profile)
		if entry.neverShow or entry.alwaysShow then
			return 1
		end

		local conditions = entry.conditions
		if conditions == nil then
			return 1
		end

		local selectedCount = 0
		for _, key in ipairs(profile.showKeys) do
			if conditions[key] then
				selectedCount = selectedCount + 1
			end
		end

		local ct = entry.resourceConditionType
		if profile.supportsThresholds and ct ~= nil and ct ~= "none" then
			selectedCount = selectedCount + 1
		end

		return selectedCount
	end

	---Counts selected options in the hard-hide dropdown.
	---@param entry table The visibility settings entry
	---@param profile table The condition profile for the bar
	---@return number selectedCount The number of selected hide options
	local function GetHideVisibilitySelectedCount(entry, profile)
		local selectedCount = 0
		local hideConditions = entry.hideConditions
		if hideConditions ~= nil then
			for _, key in ipairs(profile.hideKeys) do
				if hideConditions[key] == true then
					selectedCount = selectedCount + 1
				end
			end
		end
		return selectedCount
	end

	---Builds a count display string using the standard "X Selected" format.
	---@param selectedCount number The number of selected options
	---@return string displayName The count display text
	local function GetSelectedCountDisplayName(selectedCount)
		return string.format(L["ShowBarVisibilitySelectedCount"], selectedCount)
	end

	---Builds the compact show summary used in the visibility table.
	---@param entry table The visibility settings entry
	---@param profile table The condition profile for the bar
	---@return string displayName The table display text
	local function GetShowVisibilityTableDisplayName(entry, profile)
		if entry.neverShow then
			return L["BarVisibilityTableShowNeverShown"]
		end
		if entry.alwaysShow then
			return L["ShowBarVisibilityAlways"]
		end
		return GetSelectedCountDisplayName(GetShowVisibilitySelectedCount(entry, profile))
	end

	---Builds the compact hard-hide summary used in the visibility table.
	---@param entry table The visibility settings entry
	---@param profile table The condition profile for the bar
	---@return string displayName The table display text
	local function GetHideVisibilityTableDisplayName(entry, profile)
		return GetSelectedCountDisplayName(GetHideVisibilitySelectedCount(entry, profile))
	end

	---Builds a localized summary string describing the hard-hide side of a visibility entry.
	---@param entry table The visibility settings entry
	---@param profile table The condition profile for the bar
	---@return string displayName The hide summary display text
	---@return number selectedCount The number of selected hide conditions
	local function GetHideVisibilityDisplayName(entry, profile)
		local selectedLabels = {}
		local hideConditions = entry.hideConditions
		if hideConditions ~= nil then
			for _, key in ipairs(profile.hideKeys) do
				if hideConditions[key] == true then
					table.insert(selectedLabels, profile.hideLabels[key])
				end
			end
		end
		return GetConditionDisplayName(selectedLabels), GetHideVisibilitySelectedCount(entry, profile)
	end

	local dropdownOriginalSetText = setmetatable({}, { __mode = "k" })
	local dropdownGetTextFunc = setmetatable({}, { __mode = "k" })

	---Installs a SetText hook on a dropdown so its display text is always replaced with a custom summary.
	---@param dropdown DropdownButton The dropdown button to hook
	local function InstallDropdownDisplayTextHook(dropdown)
		if dropdownOriginalSetText[dropdown] == nil then
			dropdownOriginalSetText[dropdown] = dropdown.SetText
			dropdown.SetText = function(self, text)
				local originalSetText = dropdownOriginalSetText[self]
				local getTextFunc = dropdownGetTextFunc[self]
				if originalSetText == nil then
					return
				end
				if getTextFunc then
					originalSetText(self, getTextFunc())
				else
					originalSetText(self, text)
				end
			end
		end
	end

	---Updates the display text function for a hooked dropdown and forces an immediate visual refresh.
	---@param dropdown DropdownButton The dropdown button to update
	---@param getTextFunc fun(): string A function that returns the current display text
	local function UpdateDropdownDisplayText(dropdown, getTextFunc)
		dropdownGetTextFunc[dropdown] = getTextFunc
		-- Force an immediate visual refresh via the original SetText
		if dropdownOriginalSetText[dropdown] then
			dropdownOriginalSetText[dropdown](dropdown, getTextFunc())
		end
	end

	---Adds a hover tooltip to a dropdown button.
	---@param dropdown DropdownButton The dropdown button to attach a tooltip to
	---@param tooltipText string The localized tooltip text
	local function SetDropdownTooltip(dropdown, tooltipText)
		dropdown:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(tooltipText, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		dropdown:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end

	---Refreshes the spec/global cache and re-evaluates bar visibility after visibility settings change.
	local function RefreshVisibilitySettings()
		if classId ~= nil and specId ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
			if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
				end
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		else
			if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
				local lowerClassName = string.lower(TRB.Data.character.className)
				local currentSpecName = TRB.Data.character.specName
				TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
				end
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
		-- Never Show toggles change castbar enablement + whether the Blizzard cast bar is detached.
		TRB.Functions.Castbar:SyncEnabledState()
		-- Re-resolve the target/focus idle (Always Show) / hidden display for the new visibility settings.
		TRB.Functions.TargetCastbar:RefreshVisibility()
	end

	---Refreshes the spec/global cache, reapplies bar appearance, and re-evaluates visibility for changes affecting custom bars.
	local function RefreshVisibilityAndAppearance()
		if classId ~= nil and specId ~= nil then
			TRB.Functions.Character:FillSpecializationCacheSettings(string.lower(className), specName)
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId) then
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
					TRB.Functions.BarVisibility:MarkDirty()
					TRB.Functions.Bar:HideResourceBar()
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Data.lookupDirty = true
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				else
					TRB.Functions.BarVisibility:MarkDirty()
					TRB.Functions.Bar:HideResourceBar()
				end
			end
		else
			if TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
				local lowerClassName = string.lower(TRB.Data.character.className)
				local currentSpecName = TRB.Data.character.specName
				TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, currentSpecName)
				TRB.Functions.Character:ResetCaches()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Functions.EditMode:UpdateWrapperSize(settings)
				end
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	---Populates the show-condition dropdown menu.
	---@param rootDescription table The root menu description to add items to
	---@param entry table The visibility settings entry to read/write conditions on
	---@param thresholdTypesForBar table[] The threshold condition types available for the selected bar
	---@param onChange function Callback invoked after any condition is toggled
	---@param profile table The condition profile for the bar
	local function BuildShowVisibilityDropdownItems(rootDescription, entry, thresholdTypesForBar, onChange, profile)
		if rootDescription.SetScrollMode then
			rootDescription:SetScrollMode(400)
		end

		entry.conditions = entry.conditions or {}

		rootDescription:CreateCheckbox(
			L["ShowBarVisibilityAlwaysShow"],
			function() return entry.alwaysShow == true end,
			function()
				if entry.alwaysShow then
					entry.alwaysShow = false
				else
					entry.alwaysShow = true
					entry.neverShow = false
				end
				onChange()
			end
		)

		rootDescription:CreateCheckbox(
			L["ShowBarVisibilityNeverShow"],
			function() return entry.neverShow or false end,
			function()
				entry.neverShow = not entry.neverShow
				if entry.neverShow then
					entry.alwaysShow = false
				end
				onChange()
			end
		)

		for _, group in ipairs(profile.showGroups) do
			local groupTitle = group.title
			local groupKeys = group.keys
			rootDescription:CreateDivider()
			rootDescription:CreateTitle(groupTitle)
			for _, key in ipairs(groupKeys) do
				local capturedKey = key
				local checkbox = rootDescription:CreateCheckbox(
					profile.showLabels[capturedKey],
					function()
						return entry.conditions and entry.conditions[capturedKey] or false
					end,
					function()
						entry.conditions = entry.conditions or {}
						if entry.conditions[capturedKey] then
							entry.conditions[capturedKey] = nil
						else
							entry.conditions[capturedKey] = true
						end
						onChange()
					end
				)
				checkbox:SetEnabled(function() return not entry.neverShow and not entry.alwaysShow end)
			end
		end

		-- Bars without threshold support (castbar) get no threshold section at all.
		if #thresholdTypesForBar == 0 then
			return
		end

		local thresholdHeader = L["BarVisibilityThresholdHeader"]
		for _, tt in ipairs(thresholdTypesForBar) do
			if tt.header ~= nil then
				thresholdHeader = tt.header
				break
			end
		end

		rootDescription:CreateDivider()
		rootDescription:CreateTitle(thresholdHeader)
		for _, tt in ipairs(thresholdTypesForBar) do
			local capturedKey = tt.key
			local capturedLabel = tt.label
			local checkbox = rootDescription:CreateCheckbox(
				capturedLabel,
				function() return entry.resourceConditionType == capturedKey end,
				function()
					if entry.resourceConditionType == capturedKey then
						entry.resourceConditionType = "none"
					else
						entry.resourceConditionType = capturedKey
					end
					onChange()
				end
			)
			checkbox:SetEnabled(function() return not entry.neverShow and not entry.alwaysShow end)
		end
	end

	---Populates the hard-hide dropdown menu.
	---@param rootDescription table The root menu description to add items to
	---@param entry table The visibility settings entry to read/write hide conditions on
	---@param onChange function Callback invoked after any condition is toggled
	---@param profile table The condition profile for the bar
	local function BuildHideVisibilityDropdownItems(rootDescription, entry, onChange, profile)
		if rootDescription.SetScrollMode then
			rootDescription:SetScrollMode(400)
		end

		entry.hideConditions = entry.hideConditions or TRB.Functions.Settings:LoadDefaultBarVisibilityHideConditions()

		for groupIndex, group in ipairs(profile.hideGroups) do
			local groupTitle = group.title
			local groupKeys = group.keys
			rootDescription:CreateTitle(groupTitle)
			for _, key in ipairs(groupKeys) do
				local capturedKey = key
				rootDescription:CreateCheckbox(
					profile.hideLabels[capturedKey],
					function()
						return entry.hideConditions and entry.hideConditions[capturedKey] == true
					end,
					function()
						entry.hideConditions = entry.hideConditions or {}
						entry.hideConditions[capturedKey] = not (entry.hideConditions[capturedKey] == true)
						onChange()
					end
				)
			end
			if groupIndex < #profile.hideGroups then
				rootDescription:CreateDivider()
			end
		end
	end

	-- Build list of bar entries for the table
	local barEntries = {}

	local coreDisplayBar = TRB.Data.settings.core.displayBar

	-- Primary bar (always present)
	table.insert(barEntries, {
		key = "primary",
		displayBarKey = "primary",
		label = string.format(L["BarVisibilityBarNamePrimary"], primaryResourceString or L["ResourceMana"]),
		globalLabel = string.format(L["BarVisibilityBarNamePrimary"], L["Resource"]),
		isCustomBar = false,
		isGlobal = (classId ~= nil and coreDisplayBar["primary"] ~= nil),
	})

	-- Health bar
	if includeHealthVisibility and spec.displayBar.health ~= nil then
		table.insert(barEntries, {
			key = "health",
			displayBarKey = "health",
			label = L["BarVisibilityBarNameHealth"],
			globalLabel = L["BarVisibilityBarNameHealth"],
			isCustomBar = false,
			isGlobal = (classId ~= nil and coreDisplayBar["health"] ~= nil),
		})
	end

	-- Secondary resource
	if includeSecondaryVisibility then
		table.insert(barEntries, {
			key = "secondary",
			displayBarKey = "secondary",
			label = string.format(L["ShowBarVisibilitySecondary"], secondaryResourceString or L["ResourceComboPoints"]),
			globalLabel = string.format(L["ShowBarVisibilitySecondary"], L["ResourceComboPoints"]),
			isCustomBar = false,
			isGlobal = (classId ~= nil and coreDisplayBar["secondary"] ~= nil),
		})
	end

	-- Mana bar (secondary)
	if includeManaBarVisibility and spec.displayBar.mana ~= nil then
		table.insert(barEntries, {
			key = "mana",
			displayBarKey = "mana",
			label = L["BarVisibilityBarNameMana"],
			isCustomBar = false,
			isGlobal = (classId ~= nil and coreDisplayBar["mana"] ~= nil),
		})
	end

	-- Custom bars (stagger, defensives, utility, etc.)
	for _, barTypeDef in ipairs(customBars) do
		if spec.displayBar and spec.displayBar[barTypeDef.visibilityKey] ~= nil then
			local globalDisplayName = barTypeDef.displayName
			local registryDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(barTypeDef.visibilityKey)
			if registryDef then
				globalDisplayName = registryDef.displayName
			end
			table.insert(barEntries, {
				key = barTypeDef.key,
				displayBarKey = barTypeDef.visibilityKey,
				label = string.format(L["ShowBarVisibilityCustom"], barTypeDef.displayName),
				globalLabel = string.format(L["ShowBarVisibilityCustom"], globalDisplayName),
				isCustomBar = true,
				isGlobal = (classId ~= nil and coreDisplayBar[barTypeDef.visibilityKey] ~= nil),
			})
		end
	end

	-- Cast bar: self-driven render (Functions/Castbar.lua) configured through the same visibility entries
	if spec.displayBar and spec.displayBar.castbar ~= nil then
		table.insert(barEntries, {
			key = "castbar",
			displayBarKey = "castbar",
			label = L["ResourcePlayerCastbar"],
			globalLabel = L["ResourcePlayerCastbar"],
			isCustomBar = false,
			isCastbar = true,
			isGlobal = (classId ~= nil and coreDisplayBar["castbar"] ~= nil),
		})
	end

	-- Target / Focus cast bars: self-driven render (Functions/TargetCastbar.lua), same castbar visibility
	-- controls (cast-state show conditions, In Vehicle hide, alpha/fade). isCastbar reuses the entire
	-- castbar row path (smooth hidden, thresholds excluded).
	if spec.displayBar and spec.displayBar.targetCastbar ~= nil then
		table.insert(barEntries, {
			key = "targetCastbar",
			displayBarKey = "targetCastbar",
			label = L["BarVisibilityBarNameTargetCastbar"],
			globalLabel = L["BarVisibilityBarNameTargetCastbar"],
			isCustomBar = false,
			isCastbar = true,
			isGlobal = (classId ~= nil and coreDisplayBar["targetCastbar"] ~= nil),
		})
	end
	if spec.displayBar and spec.displayBar.focusCastbar ~= nil then
		table.insert(barEntries, {
			key = "focusCastbar",
			displayBarKey = "focusCastbar",
			label = L["BarVisibilityBarNameFocusCastbar"],
			globalLabel = L["BarVisibilityBarNameFocusCastbar"],
			isCustomBar = false,
			isCastbar = true,
			isGlobal = (classId ~= nil and coreDisplayBar["focusCastbar"] ~= nil),
		})
	end

	-- Create the LibScrollingTable for bar selection
	local columns = {
		{
			["name"] = "Key",
			["width"] = 1,
			["align"] = "CENTER",
		},
		{
			["name"] = L["BarVisibilityTableHeaderBar"],
			["width"] = 200,
			["align"] = "LEFT",
		},
		{
			["name"] = L["BarVisibilityTableHeaderShow"],
			["width"] = 95,
			["align"] = "LEFT",
		},
		{
			["name"] = L["BarVisibilityTableHeaderAlwaysHide"],
			["width"] = 105,
			["align"] = "LEFT",
		},
		{
			["name"] = L["BarVisibilityTableHeaderSettingsSource"],
			["width"] = 255,
			["align"] = "LEFT",
		},
	}

	controls.barVisibilityContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local bvc = controls.barVisibilityContainer
	bvc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	bvc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	-- Show at most 5 rows; LibScrollingTable adds a scrollbar when there are more bars than that.
	local tableRowCount = math.min(math.max(#barEntries, 2), 5)
	bvc:SetHeight(35 + (tableRowCount * 15))

	local barVisibilityTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, tableRowCount, 15, nil, bvc, false, false)

	-- Dynamically resize the Settings Source column to fill available width
	bvc:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[3].width + columns[4].width
		local newSettingsSourceWidth = math.max(180, w - fixedWidth - 30)
		columns[5].width = newSettingsSourceWidth
		barVisibilityTable:SetDisplayCols(columns)
	end)

	local globalDimColor = { r = 0.5, g = 0.5, b = 0.5, a = 0.7 }

	---Refreshes the scrolling table data from the current bar visibility settings.
	local function SetTableValues()
		local useGlobal = IsUsingGlobalDisplayBar()
		local dataTable = {}
		for _, entry in ipairs(barEntries) do
			local isControlledByGlobal = useGlobal and entry.isGlobal
			local visSettings
			if isControlledByGlobal then
				visSettings = coreDisplayBar[entry.displayBarKey]
			else
				visSettings = spec.displayBar[entry.displayBarKey]
			end
			local showText = ""
			local hideText = ""
			if visSettings then
				local profile = GetProfileForEntry(entry)
				showText = GetShowVisibilityTableDisplayName(visSettings, profile)
				hideText = GetHideVisibilityTableDisplayName(visSettings, profile)
			end
			local rowData = {
				cols = {
					{ value = entry.key },
					{ value = entry.label },
					{ value = showText },
					{ value = hideText },
					{ value = (classId == nil or isControlledByGlobal) and (classId ~= nil and entry.globalLabel and string.format(L["BarVisibilitySettingsSourceGlobalNamed"], entry.globalLabel) or L["BarVisibilitySettingsSourceGlobal"]) or L["BarVisibilitySettingsSourceSpec"] },
				}
			}
			if isControlledByGlobal then
				rowData.color = globalDimColor
			end
			table.insert(dataTable, rowData)
		end
		barVisibilityTable:SetData(dataTable)
		barVisibilityTable:EnableSelection(true)
	end

	-- Detail panel below the table
	local detailHeight = 360
	controls.barVisibilityDetail = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarVisibilityDetail", parent, "BackdropTemplate")
	local detailFrame = controls.barVisibilityDetail
	detailFrame:SetPoint("TOPLEFT", bvc, "BOTTOMLEFT", 0, 0)
	detailFrame:SetPoint("TOPRIGHT", bvc, "BOTTOMRIGHT", 0, 0)
	detailFrame:SetHeight(detailHeight)
	detailFrame:Hide()

	local detailYCoord = 0
	local selectedBarKey = nil

	-- Detail panel contents: header, show/hide dropdowns, smooth checkbox, sliders
	local detailHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailFrame, "", oUi.xCoord, detailYCoord)

	detailYCoord = detailYCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.selectedBarVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_SelectedBarVisibility", detailFrame, "WowStyle1DropdownTemplate")
	controls.dropDown.selectedBarVisibility:SetWidth(oUi.sliderWidth)
	controls.dropDown.selectedBarVisibility.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailFrame, L["ShowBarVisibilityShowColumnHeader"], oUi.xCoord, detailYCoord)
	controls.dropDown.selectedBarVisibility.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.selectedBarVisibility:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 30)
	InstallDropdownDisplayTextHook(controls.dropDown.selectedBarVisibility)
	SetDropdownTooltip(controls.dropDown.selectedBarVisibility, L["ShowBarVisibilityShowDropdownTooltip"])

	controls.dropDown.selectedHideVisibility = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_SelectedHideVisibility", detailFrame, "WowStyle1DropdownTemplate")
	controls.dropDown.selectedHideVisibility:SetWidth(oUi.sliderWidth)
	controls.dropDown.selectedHideVisibility.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailFrame, L["ShowBarVisibilityForceHideColumnHeader"], oUi.xCoord2, detailYCoord)
	controls.dropDown.selectedHideVisibility.label.font:SetFontObject(GameFontNormal)
	controls.dropDown.selectedHideVisibility:SetPoint("TOPLEFT", oUi.xCoord2, detailYCoord - 30)
	InstallDropdownDisplayTextHook(controls.dropDown.selectedHideVisibility)
	SetDropdownTooltip(controls.dropDown.selectedHideVisibility, L["ShowBarVisibilityForceHideDropdownTooltip"])

	-- Smooth checkbox (separate row below dropdowns)
	controls.checkBoxes = controls.checkBoxes or {}
	controls.checkBoxes.selectedSmooth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_SelectedSmooth", detailFrame, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.selectedSmooth
	f:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 70)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxSmoothBar"])
	f.tooltip = L["CheckboxSmoothBarTooltip"]

	-- Alpha/fade sliders
	controls.sliders = controls.sliders or {}

	detailYCoord = detailYCoord - 105
	controls.sliders.selectedActiveAlpha = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailFrame, L["ShowBarVisibilityActiveAlpha"],
		0, 100, 100, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)
	controls.sliders.selectedActiveAlpha.MinLabel:SetText("0%")
	controls.sliders.selectedActiveAlpha.MaxLabel:SetText("100%")

	controls.sliders.selectedInactiveAlpha = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailFrame, L["ShowBarVisibilityInactiveAlpha"],
		0, 100, 0, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.selectedInactiveAlpha.MinLabel:SetText("0%")
	controls.sliders.selectedInactiveAlpha.MaxLabel:SetText("100%")

	detailYCoord = detailYCoord - 60
	controls.sliders.selectedFadeDuration = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailFrame, L["ShowBarVisibilityFadeDuration"],
		0, 10, 0, 0.25, 2,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, detailYCoord)

	controls.sliders.selectedFadeDelay = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailFrame, L["ShowBarVisibilityFadeDelay"],
		0, 10, 0, 0.25, 2,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)

	-- Operator labels for the comparison dropdown
	local comparisonOperators = {
		{ operator = ">=", label = L["ComparisonGTE"] },
		{ operator = "<=", label = L["ComparisonLTE"] },
	}

	-- Helper to get display label for an operator
	local function GetComparisonLabel(op)
		for _, entry in ipairs(comparisonOperators) do
			if entry.operator == op then
				return entry.label
			end
		end
		return op
	end

	-- Dynamic controls: comparison dropdown + value slider (hidden when no threshold type selected)
	detailYCoord = detailYCoord - 50
	controls.dropDown.selectedThresholdComparison = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ThresholdComparison", detailFrame, "WowStyle1DropdownTemplate")
	controls.dropDown.selectedThresholdComparison:SetWidth(oUi.sliderWidth)
	controls.dropDown.selectedThresholdComparison.label = detailFrame:CreateFontString(nil, "OVERLAY")
	controls.dropDown.selectedThresholdComparison.label:SetFontObject(GameFontNormal)
	controls.dropDown.selectedThresholdComparison.label:SetSize(oUi.sliderWidth, 14)
	controls.dropDown.selectedThresholdComparison.label:SetJustifyH("LEFT")
	controls.dropDown.selectedThresholdComparison.label:SetPoint("BOTTOMLEFT", controls.dropDown.selectedThresholdComparison, "TOPLEFT", 0, 6)
	controls.dropDown.selectedThresholdComparison.label:SetText(L["BarVisibilityThresholdComparison"])
	controls.dropDown.selectedThresholdComparison:SetPoint("TOPLEFT", oUi.xCoord, detailYCoord - 20)
	controls.dropDown.selectedThresholdComparison:Hide()
	controls.dropDown.selectedThresholdComparison.label:Hide()

	detailYCoord = detailYCoord - 10
	controls.sliders.selectedThresholdValue = TRB.Functions.OptionsUi.Primitives:BuildSlider(detailFrame, L["BarVisibilityThresholdValue"],
		0, 100, 0, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, detailYCoord)
	controls.sliders.selectedThresholdValue:Hide()

	local function GetThresholdValueMax(conditionType)
		if conditionType == "healthValue" then
			return 1000000
		end

		local thresholdDefinition = thresholdTypeDefinitions[conditionType]
		if thresholdDefinition ~= nil and type(thresholdDefinition.maxValue) == "number" then
			return thresholdDefinition.maxValue
		end

		local visibilityMaxValue = TRB.Functions.BarVisibility:GetVisibilityThresholdMaxValue(conditionType, spec)
		if visibilityMaxValue ~= nil and visibilityMaxValue > 0 and (conditionType ~= "resourceValue" or primaryResourceString ~= L["ResourceMana"]) then
			return visibilityMaxValue
		end

		if conditionType == "resourceValue" then
			if primaryResourceString == L["ResourceMana"] then
				return 275625
			end
			if spec.maxResource ~= nil and type(spec.maxResource.value) == "number" and spec.maxResource.value > 0 then
				return spec.maxResource.value
			end
			return 100
		end

		return 100
	end

	local function UpdateThresholdControlLabels(conditionType)
		local thresholdDefinition = thresholdTypeDefinitions[conditionType]
		if thresholdDefinition ~= nil then
			controls.dropDown.selectedThresholdComparison.label:SetText(thresholdDefinition.comparisonLabel)
			controls.sliders.selectedThresholdValue.Title:SetText(thresholdDefinition.valueLabel)
		else
			controls.dropDown.selectedThresholdComparison.label:SetText(L["BarVisibilityThresholdComparison"])
			controls.sliders.selectedThresholdValue.Title:SetText(L["BarVisibilityThresholdValue"])
		end
	end

	--- Shows or hides the threshold dynamic controls based on whether a threshold type is selected.
	---@param conditionType string # The current resourceConditionType ("none" or a valid type)
	---@param visSettings table|nil # The selected visibility settings entry
	local function ShowThresholdControls(conditionType, visSettings)
		local hideForOverrides = visSettings ~= nil and (visSettings.neverShow or visSettings.alwaysShow)

		if conditionType ~= "none" and conditionType ~= nil and not hideForOverrides then
			UpdateThresholdControlLabels(conditionType)
			controls.dropDown.selectedThresholdComparison:Show()
			controls.dropDown.selectedThresholdComparison.label:Show()
			controls.sliders.selectedThresholdValue:Show()

			-- Reconfigure slider range based on type
			local thresholdDefinition = thresholdTypeDefinitions[conditionType]
			local isPercent = thresholdDefinition ~= nil and thresholdDefinition.isPercent == true
			if isPercent then
				controls.sliders.selectedThresholdValue:SetMinMaxValues(0, 100)
				controls.sliders.selectedThresholdValue.MinLabel:SetText("0%")
				controls.sliders.selectedThresholdValue.MaxLabel:SetText("100%")
			else
				local maxVal = GetThresholdValueMax(conditionType)
				controls.sliders.selectedThresholdValue:SetMinMaxValues(0, maxVal)
				controls.sliders.selectedThresholdValue.MinLabel:SetText("0")
				controls.sliders.selectedThresholdValue.MaxLabel:SetText(tostring(maxVal))
			end
		else
			controls.dropDown.selectedThresholdComparison:Hide()
			controls.dropDown.selectedThresholdComparison.label:Hide()
			controls.sliders.selectedThresholdValue:Hide()
		end
	end

	---Populates the bar visibility detail panel with controls for the selected bar's visibility settings.
	---@param barKey string The key identifying which bar to display details for
	local function FillDetailPanel(barKey)
		selectedBarKey = barKey
		local barEntry = nil
		for _, e in ipairs(barEntries) do
			if e.key == barKey then
				barEntry = e
				break
			end
		end
		if barEntry == nil then
			detailFrame:Hide()
			return
		end

		local visSettings = spec.displayBar[barEntry.displayBarKey]
		if visSettings == nil then
			detailFrame:Hide()
			return
		end

		-- Update header
		detailHeader.font:SetText(string.format(L["BarVisibilityDetailHeader"], barEntry.label))

		-- Determine if this bar needs the appearance refresh (custom bars)
		local refreshFunc = barEntry.isCustomBar and RefreshVisibilityAndAppearance or RefreshVisibilitySettings
		local profile = GetProfileForEntry(barEntry)

		-- Visibility dropdowns
		local function OnVisibilityChange()
			local displayText = GetShowVisibilityDisplayName(visSettings, profile)
			controls.dropDown.selectedBarVisibility:SetDefaultText(displayText)
			controls.dropDown.selectedBarVisibility:SetText(displayText)
			ShowThresholdControls(visSettings.resourceConditionType or "none", visSettings)
			refreshFunc()
			SetTableValues()
			-- Re-select the current row
			for i, e in ipairs(barEntries) do
				if e.key == barKey then
					barVisibilityTable:SetSelection(i)
					break
				end
			end
		end

		local function OnHideVisibilityChange()
			local displayText = GetHideVisibilityDisplayName(visSettings, profile)
			controls.dropDown.selectedHideVisibility:SetDefaultText(displayText)
			controls.dropDown.selectedHideVisibility:SetText(displayText)
			refreshFunc()
			SetTableValues()
			-- Re-select the current row
			for i, e in ipairs(barEntries) do
				if e.key == barKey then
					barVisibilityTable:SetSelection(i)
					break
				end
			end
		end

		local function VisibilityGenerator(dropdown, rootDescription)
			BuildShowVisibilityDropdownItems(rootDescription, visSettings, GetThresholdTypesForBarEntry(barEntry), OnVisibilityChange, profile)
		end

		local function HideVisibilityGenerator(dropdown, rootDescription)
			BuildHideVisibilityDropdownItems(rootDescription, visSettings, OnHideVisibilityChange, profile)
		end

		controls.dropDown.selectedBarVisibility:SetupMenu(VisibilityGenerator)
		UpdateDropdownDisplayText(controls.dropDown.selectedBarVisibility, function() return GetShowVisibilityDisplayName(visSettings, profile) end)
		controls.dropDown.selectedHideVisibility:SetupMenu(HideVisibilityGenerator)
		UpdateDropdownDisplayText(controls.dropDown.selectedHideVisibility, function()
			local displayText = GetHideVisibilityDisplayName(visSettings, profile)
			return displayText
		end)

		-- Smooth checkbox (hidden for the castbar: its fill is timeline-driven, not resource-driven)
		if barEntry.isCastbar then
			controls.checkBoxes.selectedSmooth:Hide()
		else
			controls.checkBoxes.selectedSmooth:Show()
			controls.checkBoxes.selectedSmooth:SetChecked(visSettings.smooth)
			controls.checkBoxes.selectedSmooth:SetScript("OnClick", function(self, ...)
				visSettings.smooth = self:GetChecked()
				refreshFunc()
			end)
		end

		-- Alpha sliders -- set scripts BEFORE values so SetValue doesn't write to the old entry
		controls.sliders.selectedActiveAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			visSettings.activeAlpha = value
			refreshFunc()
		end)
		controls.sliders.selectedActiveAlpha:SetValue(visSettings.activeAlpha or 100)

		controls.sliders.selectedInactiveAlpha:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			visSettings.inactiveAlpha = value
			refreshFunc()
		end)
		controls.sliders.selectedInactiveAlpha:SetValue(visSettings.inactiveAlpha or 0)

		controls.sliders.selectedFadeDuration:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			visSettings.fadeDuration = value
			refreshFunc()
		end)
		controls.sliders.selectedFadeDuration:SetValue(visSettings.fadeDuration or 0)

		controls.sliders.selectedFadeDelay:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
			self.EditBox:SetText(value)
			visSettings.fadeDelay = value
			refreshFunc()
		end)
		controls.sliders.selectedFadeDelay:SetValue(visSettings.fadeDelay or 0)

		-- Show/hide threshold controls based on current condition type
		ShowThresholdControls(visSettings.resourceConditionType or "none", visSettings)

		-- Comparison dropdown -- set up menu and current selection using CreateRadio for proper text+indicator
		local function ThresholdComparisonIsSelected(operator)
			return (visSettings.resourceConditionOperator or ">=") == operator
		end

		local function ThresholdComparisonSetSelected(operator)
			visSettings.resourceConditionOperator = operator
			refreshFunc()
		end

		local function ThresholdComparisonGenerator(dropdown, rootDescription)
			for _, entry in ipairs(comparisonOperators) do
				rootDescription:CreateRadio(entry.label, ThresholdComparisonIsSelected, ThresholdComparisonSetSelected, entry.operator)
			end
		end

		controls.dropDown.selectedThresholdComparison:SetupMenu(ThresholdComparisonGenerator)
		local currentOp = visSettings.resourceConditionOperator or ">="
		controls.dropDown.selectedThresholdComparison:SetDefaultText(GetComparisonLabel(currentOp))
		controls.dropDown.selectedThresholdComparison:SetText(GetComparisonLabel(currentOp))

		-- Threshold value slider -- set script BEFORE value
		controls.sliders.selectedThresholdValue:SetScript("OnValueChanged", function(self, value)
			-- Compute precision dynamically based on current condition type (may change after FillDetailPanel)
			local ct = visSettings.resourceConditionType or "none"
			local thresholdDefinition = thresholdTypeDefinitions[ct]
			local precision = (thresholdDefinition ~= nil and thresholdDefinition.isPercent == true) and 1 or 0
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, precision, nil, true)
			self.EditBox:SetText(value)
			visSettings.resourceConditionValue = value
			refreshFunc()
		end)
		controls.sliders.selectedThresholdValue:SetValue(visSettings.resourceConditionValue or 0)
		UpdateThresholdControlLabels(visSettings.resourceConditionType or "none")

		detailFrame:Show()
	end

	-- Table click handler
	barVisibilityTable:RegisterEvents({
		OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				if realrow ~= nil and realrow > 0 then
					local barKey = data[realrow].cols[1].value

					-- Reject selection if this bar is currently controlled by global settings
					if IsUsingGlobalDisplayBar() then
						for _, e in ipairs(barEntries) do
							if e.key == barKey and e.isGlobal then
								scrollingTable:ClearSelection()
								detailFrame:Hide()
								return
							end
						end
					end

					local currentSelection = scrollingTable:GetSelection()
					FillDetailPanel(barKey)
					C_Timer.After(0, function()
						C_Timer.After(0.05, function()
							local newSelection = scrollingTable:GetSelection()
							if newSelection == nil then
								barVisibilityTable:SetSelection(currentSelection)
							end
						end)
					end)
				end
			end
		end
	})

	-- Initial table population
	SetTableValues()

	-- Define the refresh function that the "Use global settings" checkbox calls
	-- to update the table state when the toggle changes.
	RefreshTableForGlobalToggle = function()
		SetTableValues()
		-- If the currently selected bar is now controlled by global, deselect it
		if IsUsingGlobalDisplayBar() and selectedBarKey ~= nil then
			for _, e in ipairs(barEntries) do
				if e.key == selectedBarKey and e.isGlobal then
					barVisibilityTable:ClearSelection()
					detailFrame:Hide()
					selectedBarKey = nil
					break
				end
			end
		end
	end

	yCoord = yCoord - (35 + (tableRowCount * 15)) - 10 - detailHeight

	return yCoord
end

