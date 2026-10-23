local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.Visibility = TRB.Functions.OptionsUi.Visibility or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

-- A table row's delete action: a red X that dims until it is hovered.
local actionCellDimAlpha = 0.65
local actionCellBrightAlpha = 1.0
local deleteActionTextColor = { r = 1, g = 0.12, b = 0.12, a = 1 }

-- ============================================================================
-- Shared condition metadata
--
-- Ordered key lists and a merged label map, shared by the bar visibility panel
-- below and by the per-bar tab visibility headers. Order is fixed so summaries
-- always list their conditions in the same sequence.
-- ============================================================================

local STANDARD_CONDITION_KEYS = { "inCombat", "inVehicle", "hasFriendlyTarget", "hasUnfriendlyTarget", "isMountedAny", "isMountedGround", "isSkyriding", "isSkyridingFlying", "isSteadyFlight", "isSteadyFlightFlying", "inGroup", "inRaid", "inInstance", "inDungeon", "inRaidInstance", "inBattleground", "inArena", "inDelve", "isPvpFlagged", "isWarMode" }
local DRUID_FORM_CONDITION_KEYS = { "isDruidHumanoidForm", "isDruidTravelFormAny", "isDruidStagForm", "isDruidFlightForm", "isDruidSwiftFlightForm", "isDruidAquaticForm", "isDruidCatForm", "isDruidBearForm", "isDruidMoonkinForm" }
local CASTBAR_CONDITION_KEYS = { "casting", "channeling", "empowered" }
-- Other Bars' own show state: their timer is running.
local TIMER_CONDITION_KEYS = { "whenActive" }
-- Ranged Swing's extra timer state: movement is delaying the shot.
local RANGED_TIMER_CONDITION_KEYS = { "heldByMovement" }
-- Pet bars' pet states, offered in both the show and hide lists.
local PET_CONDITION_KEYS = { "isPetAlive", "isPetDead", "isPetMissing" }
-- Skyriding bars' own condition beside the standard Skyriding pair, offered in both lists.
local SKYRIDING_CONDITION_KEYS = { "isNotSkyriding" }
local STANDARD_HIDE_CONDITION_KEYS ={ "isMountedAny", "isMountedGround", "isMountedFlying", "isSteadyFlightFlying", "isSkyriding", "isSkyridingFlying", "inVehicle", "inPetBattle", "onTaxi", "isDead" }

-- Every condition key the addon can store, show-side and hide-side alike.
local CONDITION_LABELS = {
	inCombat = L["ShowBarVisibilityConditionInCombat"],
	inVehicle = L["ShowBarVisibilityConditionInVehicle"],
	hasFriendlyTarget = L["ShowBarVisibilityConditionFriendlyTarget"],
	hasUnfriendlyTarget = L["ShowBarVisibilityConditionUnfriendlyTarget"],
	isMountedAny = L["ShowBarVisibilityConditionIsMountedAny"],
	isMountedGround = L["ShowBarVisibilityConditionIsMountedGround"],
	isMountedFlying = L["ShowBarVisibilityConditionIsSteadyFlight"],
	isSkyriding = L["ShowBarVisibilityConditionIsSkyriding"],
	isSkyridingFlying = L["ShowBarVisibilityConditionIsSkyridingFlying"],
	isNotSkyriding = L["ShowBarVisibilityConditionIsNotSkyriding"],
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
	inPetBattle = L["ShowBarVisibilityConditionInPetBattle"],
	onTaxi = L["ShowBarVisibilityConditionOnTaxi"],
	isDead = L["ShowBarVisibilityConditionIsDead"],
	isDruidHumanoidForm = L["ShowBarVisibilityConditionDruidHumanoidForm"],
	isDruidTravelFormAny = L["ShowBarVisibilityConditionDruidTravelFormAny"],
	isDruidStagForm = L["ShowBarVisibilityConditionDruidStagForm"],
	isDruidFlightForm = L["ShowBarVisibilityConditionDruidFlightForm"],
	isDruidSwiftFlightForm = L["ShowBarVisibilityConditionDruidSwiftFlightForm"],
	isDruidAquaticForm = L["ShowBarVisibilityConditionDruidAquaticForm"],
	isDruidCatForm = L["ShowBarVisibilityConditionDruidCatForm"],
	isDruidBearForm = L["ShowBarVisibilityConditionDruidBearForm"],
	isDruidMoonkinForm = L["ShowBarVisibilityConditionDruidMoonkinForm"],
	casting = L["ShowBarVisibilityConditionCasting"],
	channeling = L["ShowBarVisibilityConditionChanneling"],
	empowered = L["ShowBarVisibilityConditionEmpowered"],
	whenActive = L["ShowBarVisibilityWhenActive"],
	heldByMovement = L["ShowBarVisibilityConditionHeldByMovement"],
	isPetAlive = L["ShowBarVisibilityConditionPetAlive"],
	isPetDead = L["ShowBarVisibilityConditionPetDead"],
	isPetMissing = L["ShowBarVisibilityConditionPetMissing"],
	isItemMissing = L["ShowBarVisibilityConditionItemMissing"],
}

-- Deterministic iteration order for show-side summaries: standard, then Druid forms, then cast states,
-- then the timer-bar state.
local SHOW_CONDITION_ORDER = {}
for _, key in ipairs(STANDARD_CONDITION_KEYS) do
	SHOW_CONDITION_ORDER[#SHOW_CONDITION_ORDER + 1] = key
end
for _, key in ipairs(DRUID_FORM_CONDITION_KEYS) do
	SHOW_CONDITION_ORDER[#SHOW_CONDITION_ORDER + 1] = key
end
for _, key in ipairs(CASTBAR_CONDITION_KEYS) do
	SHOW_CONDITION_ORDER[#SHOW_CONDITION_ORDER + 1] = key
end
for _, key in ipairs(TIMER_CONDITION_KEYS) do
	SHOW_CONDITION_ORDER[#SHOW_CONDITION_ORDER + 1] = key
end
for _, key in ipairs(RANGED_TIMER_CONDITION_KEYS) do
	SHOW_CONDITION_ORDER[#SHOW_CONDITION_ORDER + 1] = key
end
for _, key in ipairs(PET_CONDITION_KEYS) do
	SHOW_CONDITION_ORDER[#SHOW_CONDITION_ORDER + 1] = key
end
for _, key in ipairs(SKYRIDING_CONDITION_KEYS) do
	SHOW_CONDITION_ORDER[#SHOW_CONDITION_ORDER + 1] = key
end

-- Resource/health threshold condition types (used in the show dropdown and in summaries).
-- Ordered array so dropdown items render in a deterministic, logical order.
local BASE_THRESHOLD_TYPES = {
	{ key = "resourcePercent", label = L["BarVisibilityThresholdResourcePercent"], comparisonLabel = L["BarVisibilityThresholdResourcePercentComparison"], valueLabel = L["BarVisibilityThresholdResourcePercentValue"], isPercent = true },
	{ key = "resourceValue",   label = L["BarVisibilityThresholdResourceValue"],   comparisonLabel = L["BarVisibilityThresholdResourceValueComparison"],   valueLabel = L["BarVisibilityThresholdResourceValueValue"],   isPercent = false },
	{ key = "healthPercent",   label = L["BarVisibilityThresholdHealthPercent"],   comparisonLabel = L["BarVisibilityThresholdHealthPercentComparison"],   valueLabel = L["BarVisibilityThresholdHealthPercentValue"],   isPercent = true },
	{ key = "healthValue",     label = L["BarVisibilityThresholdHealthValue"],     comparisonLabel = L["BarVisibilityThresholdHealthValueComparison"],     valueLabel = L["BarVisibilityThresholdHealthValueValue"],     isPercent = false },
}

local BASE_THRESHOLD_LABELS = {}
for _, thresholdType in ipairs(BASE_THRESHOLD_TYPES) do
	BASE_THRESHOLD_LABELS[thresholdType.key] = thresholdType.label
end

-- Pet bars name the player's thresholds as the player's, beside the pet's own.
local PET_BAR_THRESHOLD_TYPES = {
	{ key = "resourcePercent",    label = L["BarVisibilityThresholdPlayerResourcePercent"], comparisonLabel = L["BarVisibilityThresholdPlayerResourcePercentComparison"], valueLabel = L["BarVisibilityThresholdPlayerResourcePercentValue"], isPercent = true },
	{ key = "resourceValue",      label = L["BarVisibilityThresholdPlayerResourceValue"],   comparisonLabel = L["BarVisibilityThresholdPlayerResourceValueComparison"],   valueLabel = L["BarVisibilityThresholdPlayerResourceValueValue"],   isPercent = false },
	{ key = "healthPercent",      label = L["BarVisibilityThresholdPlayerHealthPercent"],   comparisonLabel = L["BarVisibilityThresholdPlayerHealthPercentComparison"],   valueLabel = L["BarVisibilityThresholdPlayerHealthPercentValue"],   isPercent = true },
	{ key = "healthValue",        label = L["BarVisibilityThresholdPlayerHealthValue"],     comparisonLabel = L["BarVisibilityThresholdPlayerHealthValueComparison"],     valueLabel = L["BarVisibilityThresholdPlayerHealthValueValue"],     isPercent = false },
	{ key = "petHealthPercent",   label = L["BarVisibilityThresholdPetHealthPercent"],      comparisonLabel = L["BarVisibilityThresholdPetHealthPercentComparison"],      valueLabel = L["BarVisibilityThresholdPetHealthPercentValue"],      isPercent = true },
	{ key = "petResourcePercent", label = L["BarVisibilityThresholdPetResourcePercent"],    comparisonLabel = L["BarVisibilityThresholdPetResourcePercentComparison"],    valueLabel = L["BarVisibilityThresholdPetResourcePercentValue"],    isPercent = true },
}

local PET_BAR_THRESHOLD_LABELS = {}
for _, thresholdType in ipairs(PET_BAR_THRESHOLD_TYPES) do
	PET_BAR_THRESHOLD_LABELS[thresholdType.key] = thresholdType.label
end

---Copies the given keys into a new array, in order.
---@param keys string[]
---@return string[]
---Copies a key list, leaving out the conditions this flavor's client can never satisfy.
local function CopyKeys(keys)
	local result = {}
	for _, key in ipairs(keys) do
		if not TRB.Flavor.unavailableVisibilityConditions[key] then
			result[#result + 1] = key
		end
	end
	return result
end

---Filters each group's keys the same way and drops any group left empty.
local function AvailableGroups(groups)
	local result = {}
	for _, group in ipairs(groups) do
		local keys = CopyKeys(group.keys)
		if #keys > 0 then
			result[#result + 1] = { title = group.title, keys = keys }
		end
	end
	return result
end

---Copies a key list and its groups with one more group on the end, leaving the originals untouched.
---@param keys string[]
---@param groups table[]
---@param title string
---@param extraKeys string[]
---@return string[] keys, table[] groups
local function AppendGroup(keys, groups, title, extraKeys)
	local joinedKeys = CopyKeys(keys)
	for _, key in ipairs(extraKeys) do
		joinedKeys[#joinedKeys + 1] = key
	end
	local joinedGroups = {}
	for _, group in ipairs(groups) do
		joinedGroups[#joinedGroups + 1] = group
	end
	joinedGroups[#joinedGroups + 1] = { title = title, keys = extraKeys }
	return joinedKeys, joinedGroups
end

---Builds a label map containing only the requested keys.
---@param keys string[]
---@return table<string, string>
local function LabelsFor(keys)
	local labels = {}
	for _, key in ipairs(keys) do
		labels[key] = CONDITION_LABELS[key]
	end
	return labels
end

---Builds the status summary shown in a per-bar tab visibility header: every selected show
---condition, comma separated. The header ellipsizes it to fit and keeps the full text in a tooltip,
---so this never abbreviates to a count the way the Visibility tab's dropdown button does.
---@param visSettings trbBarVisibilitySetting|nil # The bar's displayBar entry
---@param visibilityKey string? # The bar's displayBar key, which picks the pet bars' threshold names
---@return string summary # Localized summary text
function TRB.Functions.OptionsUi.Visibility:GetBarStatusSummary(visSettings, visibilityKey)
	if visSettings == nil or visSettings.neverShow then
		return L["BarVisibilityTableShowNeverShown"]
	end
	if visSettings.alwaysShow then
		return L["ShowBarVisibilityAlways"]
	end

	local selectedLabels = {}
	local conditions = visSettings.conditions
	if conditions ~= nil then
		for _, key in ipairs(SHOW_CONDITION_ORDER) do
			if conditions[key] then
				selectedLabels[#selectedLabels + 1] = CONDITION_LABELS[key]
			end
		end
	end

	local conditionType = visSettings.resourceConditionType
	if conditionType ~= nil and conditionType ~= "none" then
		local thresholdLabels = TRB.Classes.BarTypeRegistry:IsPetBar(visibilityKey) and PET_BAR_THRESHOLD_LABELS or BASE_THRESHOLD_LABELS
		local thresholdLabel = thresholdLabels[conditionType]
		if thresholdLabel == nil then
			-- Spec-defined threshold types aren't in the base set, so name the group instead.
			thresholdLabel = L["BarVisibilityThresholdHeader"]
		end
		selectedLabels[#selectedLabels + 1] = thresholdLabel
	end

	if #selectedLabels == 0 then
		return string.format(L["ShowBarVisibilitySelectedCount"], 0)
	end
	return table.concat(selectedLabels, ", ")
end

---Returns true when a bar is enabled but no condition could ever make it appear.
---@param visSettings trbBarVisibilitySetting|nil # The bar's displayBar entry
---@return boolean
function TRB.Functions.OptionsUi.Visibility:IsBarUnreachable(visSettings)
	if visSettings == nil or visSettings.neverShow or visSettings.alwaysShow then
		return false
	end

	local conditionType = visSettings.resourceConditionType
	if conditionType ~= nil and conditionType ~= "none" then
		return false
	end

	local conditions = visSettings.conditions
	if conditions == nil then
		-- Legacy entries fall back to the visibility string, which always resolves to something showable.
		return visSettings.visibility == nil
	end

	for _, key in ipairs(SHOW_CONDITION_ORDER) do
		if conditions[key] then
			return false
		end
	end
	return true
end

---Reapplies spec/global settings and re-evaluates bar visibility after a visibility setting changes.
---Shared by the bar visibility panel and the per-bar tab visibility headers.
---@param classId integer? # Class ID, or nil when editing the global panel
---@param specId integer? # Spec ID, or nil when editing the global panel
---@param includeAppearance boolean? # Whether to reapply bar appearance (needed for custom bars)
---@param forceReshow boolean? # Whether the change alters which bars should render, requiring their applied show/alpha state to be rebuilt rather than reused
function TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChange(classId, specId, includeAppearance, forceReshow)
	-- Ahead of the scope resolution below: bar tab labels turn red when their bar is disabled, and
	-- a global displayBar edit recolours tabs on spec panels this call never otherwise touches.
	TRB.Functions.OptionsUi.Tabs:RefreshBarTabStates()

	local className, specName
	if classId ~= nil and specId ~= nil then
		className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
		className = string.lower(className)
	elseif TRB.Data.character and TRB.Data.character.className and TRB.Data.character.specName then
		className = string.lower(TRB.Data.character.className)
		specName = TRB.Data.character.specName
	end

	if className == nil or specName == nil then
		return
	end

	TRB.Functions.Character:FillSpecializationCacheSettings(className, specName)

	-- Custom bars rebuild colors/textures from the caches, so those are dropped even when editing
	-- a spec that isn't currently being played (matching the pre-existing custom-bar refresh path).
	if includeAppearance then
		TRB.Functions.Character:ResetCaches()
	end

	-- The global panel always edits the playing character's resolved settings, so it refreshes
	-- unconditionally; a spec panel only refreshes when it is the spec currently being played.
	local isActive = (classId == nil or specId == nil) or TRB.Functions.OptionsUi.GlobalSettings:IsEditingActiveSpec(classId, specId)
	if isActive then
		if not includeAppearance then
			TRB.Functions.Character:ResetCaches()
		end
		if TRB.Frames.barGroups ~= nil then
			local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
			TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
			if includeAppearance then
				TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
			end
			TRB.Functions.EditMode:UpdateWrapperSize(settings)
		end
		-- Changing which bars should render invalidates the show/alpha state ProcessBars has
		-- already applied, because the layout pass above independently re-shows bar groups.
		-- Without this a re-enabled bar reclaims its layout space but never draws.
		if forceReshow then
			TRB.Functions.BarVisibility:InvalidateAppliedState()
		else
			TRB.Functions.BarVisibility:MarkDirty()
		end
		TRB.Functions.Bar:HideResourceBar()
		if includeAppearance and TRB.Frames.barGroups ~= nil and TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end

	-- Never Show toggles change castbar enablement + whether the Blizzard cast bar is detached.
	TRB.Functions.Castbar:SyncEnabledState()
	TRB.Functions.PetCastbar:SyncEnabledState()
	-- Re-resolve the target/focus idle (Always Show) / hidden display for the new visibility settings.
	TRB.Functions.TargetCastbar:RefreshVisibility()
	-- Same for the Other Bars, which also re-arms the GCD events and Blizzard Duration Bar suppression.
	TRB.Functions.OtherBars:SyncGcdEvents()
	TRB.Functions.OtherBars:RefreshVisibility()
end

-- ============================================================================
-- Per-bar tab visibility header
--
-- A compact enable/disable row pinned to the top of each bar's options tab. It is
-- purely a shortcut for the bar's "Never Show" setting, mirrors whatever the
-- Visibility tab holds, and goes read-only when Global Options owns the bar.
-- ============================================================================

local BAR_TAB_HEADER_HEIGHT = 30
-- Widest the show-condition summary may grow, and the padding it keeps from the band's right edge.
local BAR_TAB_STATUS_MAX_WIDTH = 400
local BAR_TAB_STATUS_RIGHT_PADDING = 10
-- Left edge the summary may never cross: clears the widest checkbox label plus its link.
local BAR_TAB_STATUS_LEFT_BOUNDARY = 310

-- Vertical space a bar tab's content must leave for the header. The tabsheet already offsets its
-- scroll frame by a few pixels, and that becomes the gap below the band.
-- Read by OptionsUiTabs when it offsets a tabsheet's scroll frame.
TRB.Functions.OptionsUi.Visibility.barTabHeaderReservedHeight = BAR_TAB_HEADER_HEIGHT

---Resolves which displayBar entry drives a bar, and whether Global Options owns it.
---@param classId integer? # Class ID, or nil for the global panel
---@param specId integer? # Spec ID, or nil for the global panel
---@param visibilityKey string # The displayBar key for the bar
---@return trbBarVisibilitySetting|nil visSettings # What the bar shows now, its preset included. A copy: write to the third value
---@return boolean isControlledByGlobal # True when Global Options owns this bar for this spec
---@return trbBarVisibilitySetting|nil saved # The saved entry behind it, for a write
function TRB.Functions.OptionsUi.Visibility:ResolveBarVisibilityEntry(classId, specId, visibilityKey)
	local core = TRB.Data.settings.core
	if core == nil then
		return nil, false, nil
	end
	local barVisibility = TRB.Functions.BarVisibility

	local globalEntry = core.displayBar and core.displayBar[visibilityKey]
	if classId == nil or specId == nil then
		return globalEntry and barVisibility:ComposeEntry(globalEntry), false, globalEntry
	end

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local classSettings = TRB.Data.settings[className]
	local spec = classSettings and classSettings[specName]
	local specEntry = spec and spec.displayBar and spec.displayBar[visibilityKey]

	-- Only keys present in core.displayBar are shared globally; custom bars stay spec-owned. IsEntryGlobal
	-- also asks IsGlobalScopeBar, so a stale core entry for a class-scoped bar can't take its spec row
	-- hostage (it would go read-only against a global entry with no UI behind it).
	if barVisibility:IsEntryGlobal(visibilityKey, core.displayBar, spec and spec.displayBar) then
		return barVisibility:ComposeEntry(globalEntry), true, globalEntry
	end
	return specEntry and barVisibility:ComposeEntry(specEntry), false, specEntry
end

---One key per options scope: the Global panels share one, each spec has its own.
---@param classId integer?
---@param specId integer?
---@return string
local function GetScopeKey(classId, specId)
	if classId == nil or specId == nil then
		return "global"
	end
	return classId .. "_" .. specId
end

-- Session-only, never saved: whether a scope's spec tab also lists the bars that have their own groupings' tabs.
local includeAllGroups = {}

-- Each Visibility tab's table API, by scope then grouping, so a bar's tab header can reach the tab that lists its bar.
local visibilityApis = {}

---Registers a Visibility tab's table API under its scope and grouping.
---@param classId integer?
---@param specId integer?
---@param groupKey string? # nil is the spec's own tab
---@param api table # { Refresh, SelectByDisplayBarKey }
function TRB.Functions.OptionsUi.Visibility:RegisterApi(classId, specId, groupKey, api)
	local scopeKey = GetScopeKey(classId, specId)
	visibilityApis[scopeKey] = visibilityApis[scopeKey] or {}
	visibilityApis[scopeKey][groupKey or "spec"] = api
end

---The table API of the Visibility tab for a scope and grouping, or nil when that tab has not been built.
---@param classId integer?
---@param specId integer?
---@param groupKey string? # nil is the spec's own tab
---@return table?
function TRB.Functions.OptionsUi.Visibility:GetApi(classId, specId, groupKey)
	local scopeApis = visibilityApis[GetScopeKey(classId, specId)]
	return scopeApis and scopeApis[groupKey or "spec"] or nil
end

---Refreshes every built Visibility table of a scope.
---@param classId integer?
---@param specId integer?
function TRB.Functions.OptionsUi.Visibility:RefreshApis(classId, specId)
	local scopeApis = visibilityApis[GetScopeKey(classId, specId)]
	if scopeApis ~= nil then
		for _, api in pairs(scopeApis) do
			api.Refresh()
		end
	end
end

---Refreshes every built Visibility table of every scope, for a change that reaches many specializations.
function TRB.Functions.OptionsUi.Visibility:RefreshAllApis()
	for _, scopeApis in pairs(visibilityApis) do
		for _, api in pairs(scopeApis) do
			api.Refresh()
		end
	end
end

---Opens a bar's row on its Global Options Visibility tab, switching to the Global screen that holds it.
---@param visibilityKey string # The displayBar key
function TRB.Functions.OptionsUi.Visibility:OpenGlobalVisibility(visibilityKey)
	local barGroup = TRB.Classes.BarTypeRegistry:GetBarGroup(visibilityKey)
	local tabs = TRB.Functions.OptionsUi.Tabs
	local function OpenTab()
		if barGroup == "spec" then
			tabs:SwitchToGlobalVisibilityTab()
		else
			tabs:SwitchToTabByNamePrefix(tabs:GetGroupInnerPrefix(barGroup, nil, nil), tabs.TabKeys.BarVisibility)
		end
		local api = TRB.Functions.OptionsUi.Visibility:GetApi(nil, nil, barGroup)
		if api ~= nil and api.SelectByDisplayBarKey ~= nil then
			api.SelectByDisplayBarKey(visibilityKey)
		end
	end
	if TRB.Options.OptionsFrame then
		TRB.Options.OptionsFrame:SelectCategory(barGroup == "spec" and "global" or barGroup)
		C_Timer.After(0, OpenTab)
	end
end

---Applies a change that reaches every specialization, such as an edit to a preset.
function TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChangeAllSpecs()
	for _, entry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
		if TRB.Data.specCache[entry.compositeKey] then
			TRB.Functions.Character:FillSpecializationCacheSettings(entry.className, entry.specName)
		end
	end
	self:ApplyVisibilityChange(nil, nil, true, true)
	self:RefreshAllApis()
end

---Opens a preset on Global Options' Manage Presets tab.
---@param presetId string
function TRB.Functions.OptionsUi.Visibility:OpenGlobalPreset(presetId)
	if TRB.Options.OptionsFrame then
		TRB.Options.OptionsFrame:SelectCategory("global")
		C_Timer.After(0, function()
			local tabs = TRB.Functions.OptionsUi.Tabs
			tabs:SwitchToGlobalVisibilityTab(tabs.TabKeys.VisibilityPresets)
			local api = TRB.Functions.OptionsUi.Visibility:GetApi(nil, nil, "presets")
			if api ~= nil and api.SelectPreset ~= nil then
				api.SelectPreset(presetId)
			end
		end)
	end
end

-- Each kind of bar a preset can be for, in menu order; the swing kinds need a flavor with swing timers.
local presetKindLabels = {
	standard = L["BarVisibilityProfile_standard"],
	castbar = L["BarVisibilityProfile_castbar"],
	targetCastbar = L["BarVisibilityProfile_targetCastbar"],
	petCastbar = L["BarVisibilityProfile_petCastbar"],
	timerBar = L["BarVisibilityProfile_timerBar"],
	timerEnvironment = L["BarVisibilityProfile_timerEnvironment"],
	rangedSwing = L["BarVisibilityProfile_rangedSwing"],
	mainHandSwing = L["BarVisibilityProfile_mainHandSwing"],
	petBar = L["BarVisibilityProfile_petBar"],
	skyriding = L["BarVisibilityProfile_skyriding"],
}
local presetKindOrder = { "standard", "castbar", "targetCastbar", "petCastbar", "timerBar", "timerEnvironment", "petBar", "skyriding" }
if TRB.Flavor.swingTimers then
	presetKindOrder[#presetKindOrder + 1] = "mainHandSwing"
	presetKindOrder[#presetKindOrder + 1] = "rangedSwing"
end

---Draws an action cell dimmed; the table's hover handlers brighten it.
local function UpdateActionCell(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
	scrollingTable.DoCellUpdate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, scrollingTable, ...)
	if fShow and cellFrame ~= nil and cellFrame.text ~= nil then
		cellFrame.text:SetAlpha(actionCellDimAlpha)
	end
end

---Wraps menu text in the color of every "use global settings" label.
---@param menuText string
---@return string
local function UseGlobalMenuText(menuText)
	local r, g, b = TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor()
	return string.format("|cff%02x%02x%02x%s|r", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5), menuText)
end

-- Asks for a preset's name. Defined once, outside the generator: everything it needs arrives in the data payload.
StaticPopupDialogs["TwintopResourceBar_VisibilityPresetName"] = {
	text = "",
	button1 = L["OK"],
	button2 = L["Cancel"],
	hasEditBox = true,
	editBoxWidth = 260,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	OnShow = function(self, data)
		self:SetFormattedText("%s", data.message)
		local editBox = self:GetEditBox()
		if editBox ~= nil then
			editBox:SetText(data.initialName or "")
			editBox:HighlightText()
			editBox:SetAutoFocus(true)
		end
	end,
	OnAccept = function(self, data)
		local name = self:GetEditBox():GetText() or ""
		name = name:gsub("^%s+", ""):gsub("%s+$", "")
		if name ~= "" then
			data.onAccept(name)
		end
	end,
}

StaticPopupDialogs["TwintopResourceBar_VisibilityPresetDelete"] = {
	text = "",
	button1 = L["Yes"],
	button2 = L["No"],
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	OnShow = function(self, data)
		self:SetFormattedText("%s", data.message)
	end,
	OnAccept = function(self, data)
		data.onAccept()
	end,
}

-- Confirms changing the kind of a preset bars use; No puts the dropdown back.
StaticPopupDialogs["TwintopResourceBar_VisibilityPresetKind"] = {
	text = "",
	button1 = L["Yes"],
	button2 = L["No"],
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	OnShow = function(self, data)
		self:SetFormattedText("%s", data.message)
	end,
	OnAccept = function(_, data)
		data.onAccept()
	end,
	OnCancel = function(_, data)
		data.onCancel()
	end,
}

-- Tells the user why an action did nothing; the message is the popup's first argument.
StaticPopupDialogs["TwintopResourceBar_VisibilityMessage"] = {
	text = "%s",
	button1 = L["OK"],
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

---Builds the enable/disable header pinned to the top of a bar's options tab.
---The returned frame exposes :Refresh() so callers can resync it when the tab is shown.
---@param container Frame # The tabsheet frame the header is anchored into
---@param namePrefix string # The tab group's name prefix (e.g. "Monk_brewmaster")
---@param classId integer? # Class ID, or nil for the global panel
---@param specId integer? # Spec ID, or nil for the global panel
---@param visibilityKey string # The displayBar key for this tab's bar
---@return Frame header # The header frame
function TRB.Functions.OptionsUi.Visibility:BuildBarTabVisibilityHeader(container, namePrefix, classId, specId, visibilityKey)
	-- Filled band, darker than the tabsheet behind it, so the row reads as a title bar rather than
	-- as the first row of the tab's own content. Pinned flush to the tabsheet's top/left/right with
	-- an identical backdrop, so its three outer edges land exactly on the tabsheet's own border art
	-- and the only new line drawn is the band's bottom edge.
	local header = CreateFrame("Frame", nil, container, "BackdropTemplate")
	header:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	header:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
	header:SetHeight(BAR_TAB_HEADER_HEIGHT)
	header:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
	header:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, 0)

	local checkbox = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_barTabEnabled_" .. visibilityKey, header, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint("LEFT", header, "LEFT", 7, 0)
	local checkboxText = getglobal(checkbox:GetName() .. "Text")

	-- Jumps to this bar's row on the Visibility tab, building that tab first if it is still deferred.
	local configureLink = CreateFrame("Button", nil, header)
	configureLink:SetNormalFontObject("GameFontNormalSmall")
	configureLink:SetHighlightFontObject("GameFontHighlightSmall")
	configureLink:SetText(L["BarTabConfigureVisibility"])
	configureLink:SetWidth(configureLink:GetFontString():GetStringWidth() + 4)
	configureLink:SetHeight(16)
	configureLink:GetFontString():SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	-- Above the checkbox so the label can never swallow clicks meant for the link.
	configureLink:SetFrameLevel(checkbox:GetFrameLevel() + 1)
	configureLink.tooltip = L["BarTabConfigureVisibilityTooltip"]
	configureLink:SetScript("OnEnter", function(self)
		self:GetFontString():SetTextColor(1, 1, 1)
		SetCursor("Interface\\CURSOR\\vehichleCursor.PNG")
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	configureLink:SetScript("OnLeave", function(self)
		self:GetFontString():SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		SetCursor(nil)
		GameTooltip:Hide()
	end)
	local barGroup = TRB.Classes.BarTypeRegistry:GetBarGroup(visibilityKey)

	---Switches to the Visibility tab that lists this bar and selects its row. SwitchTab builds a deferred
	---tab first, so its table API exists by the time the row is selected.
	local function OpenVisibilityTab()
		-- Resolved from the scope, not from namePrefix: the shared groupings' sub-tabs use synthesized prefixes.
		local tabs = TRB.Functions.OptionsUi.Tabs
		if barGroup == "spec" then
			if classId == nil or specId == nil then
				tabs:SwitchToGlobalVisibilityTab()
			else
				tabs:SwitchToTabByClassSpec(classId, specId, tabs.TabKeys.BarVisibility)
			end
		else
			if classId ~= nil and specId ~= nil then
				tabs:SwitchToTabByClassSpec(classId, specId, barGroup)
			end
			tabs:SwitchToTabByNamePrefix(tabs:GetGroupInnerPrefix(barGroup, classId, specId), tabs.TabKeys.BarVisibility)
		end
		local api = TRB.Functions.OptionsUi.Visibility:GetApi(classId, specId, barGroup)
		if api ~= nil and api.SelectByDisplayBarKey ~= nil then
			api.SelectByDisplayBarKey(visibilityKey)
		end
	end

	configureLink:SetScript("OnClick", function()
		-- The spec's own bars live on the Global Options category, which must be selected before its tab exists to switch to.
		if (classId == nil or specId == nil) and barGroup == "spec" then
			if TRB.Options.OptionsFrame then
				TRB.Options.OptionsFrame:SelectCategory("global")
				C_Timer.After(0, OpenVisibilityTab)
				return
			end
		end
		OpenVisibilityTab()
	end)

	-- Shown instead of the Configure link when Global Options owns this bar.
	local globalLink = TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(checkbox, TRB.Functions.OptionsUi.Tabs.TabKeys.BarVisibility, barGroup ~= "spec" and barGroup or nil)

	-- Right-aligned summary. Word wrap is off, so the FontString ellipsizes anything wider than the
	-- width applied below; the untruncated text stays reachable through the hitbox tooltip.
	local status = header:CreateFontString(nil, "OVERLAY")
	status:SetFontObject(GameFontNormalSmall)
	status:SetPoint("RIGHT", header, "RIGHT", -BAR_TAB_STATUS_RIGHT_PADDING, 0)
	status:SetJustifyH("RIGHT")
	status:SetWordWrap(false)

	-- FontStrings take no scripts, so a frame hugging the rendered text carries the tooltip.
	local statusHitbox = CreateFrame("Frame", nil, header)
	statusHitbox:SetPoint("RIGHT", status, "RIGHT", 0, 0)
	statusHitbox:SetHeight(BAR_TAB_HEADER_HEIGHT)
	statusHitbox:EnableMouse(true)
	statusHitbox:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
		GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	statusHitbox:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	---Sizes the summary to the smaller of its cap and the space left beside the checkbox and link,
	---so a long condition list neither stretches across the whole band nor collides with the link,
	---then pulls the hitbox in to match whatever ends up rendered.
	local function ApplyStatusWidth()
		local available = header:GetWidth() - BAR_TAB_STATUS_LEFT_BOUNDARY - BAR_TAB_STATUS_RIGHT_PADDING
		if available > 0 then
			status:SetWidth(math.min(BAR_TAB_STATUS_MAX_WIDTH, available))
		end
		-- GetStringWidth reports the untruncated text, so clamping to the FontString's own width
		-- keeps the hitbox on the visible glyphs rather than out over the empty part of the band.
		statusHitbox:SetWidth(math.max(math.min(status:GetStringWidth(), status:GetWidth()), 1))
	end
	-- The header has no resolved width yet during construction, so re-apply once it is laid out.
	header:HookScript("OnSizeChanged", ApplyStatusWidth)
	ApplyStatusWidth()

	---Resyncs every part of the header from the settings currently in effect.
	local function Refresh()
		local visSettings, isControlledByGlobal = TRB.Functions.OptionsUi.Visibility:ResolveBarVisibilityEntry(classId, specId, visibilityKey)

		-- A tab whose bar has no visibility entry for this spec simply shows no header.
		if visSettings == nil then
			header:Hide()
			return
		end
		header:Show()

		local isEnabled = not visSettings.neverShow
		checkbox:SetChecked(isEnabled)
		checkbox:SetEnabled(not isControlledByGlobal)

		-- Green "Enabled" / red "Disabled", matching the spec enable checkbox. The Global variants
		-- take the same colors but name their source, since the checkbox is read-only in that state.
		if isControlledByGlobal then
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(checkbox, isEnabled, false)
			if isEnabled then
				checkboxText:SetText(L["BarTabEnabledGlobal"])
			else
				checkboxText:SetText(L["BarTabDisabledGlobal"])
			end
			checkbox.tooltip = L["BarTabVisibilityGlobalTooltip"]
		else
			TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(checkbox, isEnabled, true)
			checkbox.tooltip = L["BarTabEnabledCheckboxTooltip"]
		end

		configureLink:SetShown(not isControlledByGlobal)
		if globalLink ~= nil then
			globalLink:SetShown(isControlledByGlobal)
		end

		-- Anchor the active link past the label's rendered width. The checkbox's FontString keeps
		-- the template's own width regardless of its text, so anchoring to its right edge leaves
		-- the label overlapping the link and eating clicks meant for it.
		local labelEnd = checkboxText:GetStringWidth() + 14
		configureLink:ClearAllPoints()
		configureLink:SetPoint("LEFT", checkbox, "RIGHT", labelEnd, 0)
		if globalLink ~= nil then
			globalLink:ClearAllPoints()
			globalLink:SetPoint("LEFT", checkbox, "RIGHT", labelEnd, 0)
		end

		local statusText
		if TRB.Functions.OptionsUi.Visibility:IsBarUnreachable(visSettings) then
			statusText = L["BarTabVisibilityNeverWarning"]
			status:SetTextColor(1, 0.82, 0)
		else
			statusText = string.format(L["BarTabVisibilityShowsPrefix"], TRB.Functions.OptionsUi.Visibility:GetBarStatusSummary(visSettings, visibilityKey))
			status:SetTextColor(0.75, 0.75, 0.75)
		end
		status:SetText(statusText)

		-- Tooltip carries the full list, since a long one is ellipsized on the band.
		statusHitbox.tooltip = statusText
		ApplyStatusWidth()
	end

	checkbox:SetScript("OnClick", function(self)
		local visSettings, isControlledByGlobal, saved = TRB.Functions.OptionsUi.Visibility:ResolveBarVisibilityEntry(classId, specId, visibilityKey)
		if visSettings == nil or saved == nil or isControlledByGlobal then
			Refresh()
			return
		end

		-- Disabling only writes the Never Show bit. ShouldShowBar bails on neverShow before it ever
		-- reads alwaysShow, so the bar is fully disabled either way, and leaving Always Show intact
		-- keeps this a lossless round trip instead of quietly discarding the setting on the way out.
		saved.neverShow = not self:GetChecked()
		visSettings.neverShow = saved.neverShow

		-- Enabling a bar has to leave it able to actually appear. If nothing else would ever show
		-- it, fall back to Always Show, otherwise the checkbox would report the bar as enabled while
		-- it stayed invisible. A bar that already has a condition or threshold keeps it untouched.
		-- A bar on a preset leaves it first: Always Show belongs to the preset, and one bar must not change the rest.
		if not saved.neverShow and TRB.Functions.OptionsUi.Visibility:IsBarUnreachable(visSettings) then
			TRB.Functions.BarVisibility:UnlinkEntry(saved)
			saved.alwaysShow = true
		end

		-- forceReshow: toggling Never Show changes whether this bar renders at all.
		TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChange(classId, specId, true, true)
		Refresh()

		-- Push straight into the Visibility tables that have already been constructed.
		TRB.Functions.OptionsUi.Visibility:RefreshApis(classId, specId)
	end)

	header.Refresh = Refresh
	Refresh()

	return header
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
---@param options { groupKey: string? }? Which grouping's bars to list; nil is the spec's own tab, and "presets" lists Global Options' presets instead of bars
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi.Visibility:GenerateBarVisibilityOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, showWhenCategory, includeSecondaryVisibility, secondaryResourceString, includeHealthVisibility, includeManaBarVisibility, customBars, extraThresholdTypes, options)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local groupKey = options and options.groupKey or "spec"
	-- The spec tab keeps the unsuffixed name; every grouping's tab needs its own, as they share a scope.
	local namePrefix = className .. "_" .. specName .. "_barVisibility" .. (groupKey ~= "spec" and ("_" .. groupKey) or "")
	local scopeKey = GetScopeKey(classId, specId)
	local f = nil
	if customBars == nil then
		customBars = {}
	end
	if extraThresholdTypes == nil then
		extraThresholdTypes = {}
	end

	-- Declared up front: the Use Global boxes below, built before the table, and the table's own handlers share them.
	local RefreshTableForGlobalToggle = nil
	local allBarEntries = {}
	local barEntries = {}
	local coreDisplayBar = TRB.Data.settings.core.displayBar
	local barVisibility = TRB.Functions.BarVisibility
	-- Global Options' Manage Presets tab lists presets where every other tab lists bars.
	local isPresetHost = classId == nil and groupKey == "presets"
	-- The preset the detail panel is showing, when it shows one; the refresh helpers below act on it.
	local selectedPresetGuid = nil
	-- Assigned below, once the panel they act on exists.
	---@type fun(barKey: string)
	local FillDetailPanel = nil
	---@type fun()
	local SetPresetTableValues = nil

	---Whether a row follows Global Options for this specialization. The Global panel edits its own entries.
	---@param entry table # A bar entry
	---@return boolean
	local function IsRowControlledByGlobal(entry)
		return classId ~= nil and entry.isGlobal and TRB.Functions.BarVisibility:IsEntryGlobal(entry.displayBarKey, coreDisplayBar, spec.displayBar)
	end

	---Whether all, none, or some of the listed bars that could follow Global Options do.
	---@return boolean|nil state # nil is mixed
	---@return integer total # How many listed bars could
	local function GetUseGlobalState()
		local total, controlled = 0, 0
		for _, entry in ipairs(barEntries) do
			if entry.isGlobal then
				total = total + 1
				if IsRowControlledByGlobal(entry) then
					controlled = controlled + 1
				end
			end
		end
		if controlled == 0 then
			return false, total
		elseif controlled == total then
			return true, total
		end
		return nil, total
	end

	---Runs a function on every specialization's entry for each listed bar that could follow Global Options.
	---@param fn fun(specEntry: table)
	local function ForEachSpecEntryOfListedBars(fn)
		for _, specRegistryEntry in ipairs(TRB.Functions.Character:GetSpecRegistryEntriesOrdered()) do
			local classPiece = TRB.Data.settings[specRegistryEntry.className]
			local piece = classPiece and classPiece[specRegistryEntry.specName]
			if piece ~= nil and piece.displayBar ~= nil then
				for _, entry in ipairs(barEntries) do
					local specEntry = piece.displayBar[entry.displayBarKey]
					if type(specEntry) == "table" and coreDisplayBar[entry.displayBarKey] ~= nil
						and TRB.Classes.BarTypeRegistry:IsGlobalScopeBar(entry.displayBarKey) then
						fn(specEntry)
					end
				end
			end
		end
	end

	---The same state across every specialization, for the Global panel's box.
	---@return boolean|nil state # nil is mixed
	---@return integer controlled
	---@return integer total
	local function GetBulkUseGlobalState()
		local total, controlled = 0, 0
		ForEachSpecEntryOfListedBars(function(specEntry)
			total = total + 1
			if specEntry.useGlobal ~= false then
				controlled = controlled + 1
			end
		end)
		if controlled == 0 then
			return false, controlled, total
		elseif controlled == total then
			return true, controlled, total
		end
		return nil, controlled, total
	end

	---Syncs the Use Global box to the rows it covers.
	local function SyncUseGlobalControls()
		local checkbox = controls.checkBoxes ~= nil and (controls.checkBoxes.useGlobalDisplayBar or controls.checkBoxes.enableAllDisplayBar) or nil
		if checkbox == nil then
			return
		end
		if classId ~= nil then
			local state, total = GetUseGlobalState()
			checkbox:SetShown(total > 0)
			TRB.Functions.OptionsUi.GlobalSettings:SetCheckboxTriState(checkbox, state)
		else
			local state, controlled, total = GetBulkUseGlobalState()
			TRB.Functions.OptionsUi.GlobalSettings:SetCheckboxTriState(checkbox, state)
			checkbox.specCount:SetText(string.format(L["UseGlobalBarCountFormat"], controlled, total))
		end
	end

	controls.barDisplaySection = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(parent, isPresetHost and L["BarVisibilityPresetsHeader"] or L["BarDisplayHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		controls.checkBoxes = controls.checkBoxes or {}
		controls.checkBoxes.useGlobalDisplayBar = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_displayBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalDisplayBar
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobalAllListedBars"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, TRB.Functions.OptionsUi.Tabs.TabKeys.BarVisibility, groupKey ~= "spec" and groupKey or nil)
		f.tooltip = L["CheckboxUseGlobalAllListedBarsTooltip"]
		f:SetScript("OnClick", function()
			-- Checked gives every listed bar its own settings; unchecked or mixed puts them all back on Global Options.
			local useGlobal = GetUseGlobalState() ~= true
			for _, entry in ipairs(barEntries) do
				local specEntry = entry.isGlobal and spec.displayBar[entry.displayBarKey] or nil
				if specEntry ~= nil then
					if useGlobal then
						specEntry.useGlobal = nil
					else
						specEntry.useGlobal = false
					end
				end
			end
			-- Swapping the source can flip Never Show for several bars at once,
			-- so the applied show/alpha state is rebuilt rather than reused.
			TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChange(classId, specId, true, true)
			-- Every tab of this spec lists some of the bars, so each one's table and box follow.
			TRB.Functions.OptionsUi.Visibility:RefreshApis(classId, specId)
		end)
	elseif groupKey == "spec" then
		-- Global options panel: one box for the listed bars in every specialization.
		yCoord = yCoord - 30
		controls.checkBoxes = controls.checkBoxes or {}
		controls.checkBoxes.enableAllDisplayBar = CreateFrame("CheckButton", "TwintopResourceBar_Global_enableAll_displayBar", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.enableAllDisplayBar
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobalAllSpecsListedBars"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
		f.tooltip = L["CheckboxUseGlobalAllSpecsListedBarsTooltip"]
		f.specCount = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		f.specCount:SetTextColor(0.75, 0.75, 0.75)
		-- The template's label keeps its own width, so sit past the rendered text rather than its right edge.
		f.specCount:SetPoint("LEFT", f, "RIGHT", getglobal(f:GetName() .. 'Text'):GetStringWidth() + 14, 0)
		f:SetScript("OnClick", function()
			local useGlobal = GetBulkUseGlobalState() ~= true
			ForEachSpecEntryOfListedBars(function(specEntry)
				if useGlobal then
					specEntry.useGlobal = nil
				else
					specEntry.useGlobal = false
				end
			end)
			TRB.Functions.OptionsUi.GlobalSettings:RefreshAfterBulkChange()
			TRB.Functions.OptionsUi.Visibility:RefreshAllApis()
		end)
	end

	-- Re-lists the table; assigned once the table exists.
	local RebuildRows = nil
	if groupKey == "spec" then
		yCoord = yCoord - 20
		controls.checkBoxes.includeAllGroups = TRB.Functions.OptionsUi.Primitives:BuildCheckboxRow(parent, "TwintopResourceBar_" .. namePrefix .. "_includeAllGroups",
			L["CheckboxIncludeAllBarGroups"], L["CheckboxIncludeAllBarGroupsTooltip"], yCoord,
			function() return includeAllGroups[scopeKey] == true end,
			function(checked)
				includeAllGroups[scopeKey] = checked
				if RebuildRows ~= nil then
					RebuildRows()
				end
			end)
		-- Lined up with the start of the Use Global row above it.
		controls.checkBoxes.includeAllGroups:ClearAllPoints()
		controls.checkBoxes.includeAllGroups:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	end

	yCoord = yCoord - 30
	-- Shapeshift form conditions only make sense for a class whose display follows forms (descriptor
	-- `forms`). Global Options and its presets serve every class, so they always list them.
	local isDruidVisibilityPanel = classId == nil or TRB.Functions.Character:ClassHasForms(classId)
	local druidFormConditionKeys = CopyKeys(DRUID_FORM_CONDITION_KEYS)

	-- Condition definitions for multi-select bar visibility
	local conditionKeys = CopyKeys(STANDARD_CONDITION_KEYS)
	local conditionLabels = LabelsFor(STANDARD_CONDITION_KEYS)

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
			conditionLabels[key] = CONDITION_LABELS[key]
		end
		table.insert(conditionGroups, {
			title = L["ShowBarVisibilityGroupDruidForms"],
			keys = druidFormConditionKeys,
		})
	end
	conditionGroups = AvailableGroups(conditionGroups)

	local hideConditionKeys = CopyKeys(STANDARD_HIDE_CONDITION_KEYS)
	local hideConditionLabels = LabelsFor(STANDARD_HIDE_CONDITION_KEYS)
	local hideConditionGroups = {
		{
			title = L["ShowBarVisibilityGroupGeneral"],
			keys = { "inVehicle", "inPetBattle", "onTaxi", "isDead" },
		},
		{
			title = L["ShowBarVisibilityGroupMounting"],
			keys = { "isMountedAny", "isMountedGround", "isSkyriding", "isSkyridingFlying", "isMountedFlying", "isSteadyFlightFlying" },
		},
	}
	if isDruidVisibilityPanel then
		for _, key in ipairs(druidFormConditionKeys) do
			table.insert(hideConditionKeys, key)
			hideConditionLabels[key] = CONDITION_LABELS[key]
		end
		table.insert(hideConditionGroups, {
			title = L["ShowBarVisibilityGroupDruidForms"],
			keys = druidFormConditionKeys,
		})
	end
	hideConditionGroups = AvailableGroups(hideConditionGroups)

	-- Castbar-specific condition profile: show conditions are cast states (not environment), the only
	-- hard-hide condition is In Vehicle, and resource/health thresholds don't apply. Empowered is only
	-- offered on the global panel and on specs with empowered abilities.
	local castbarConditionKeys = { "casting", "channeling" }
	if classId == nil or TRB.Functions.OptionsUi.Castbar:SpecUsesEmpower(classId, specId) then
		table.insert(castbarConditionKeys, "empowered")
	end
	local castbarConditionLabels = LabelsFor(CASTBAR_CONDITION_KEYS)
	local castbarHideKeys = { "inVehicle", "isDead" }
	local castbarHideLabels = LabelsFor(castbarHideKeys)
	local castbarProfile = {
		showKeys = castbarConditionKeys,
		showLabels = castbarConditionLabels,
		showGroups = { { title = L["ShowBarVisibilityGroupCasting"], keys = castbarConditionKeys } },
		hideKeys = castbarHideKeys,
		hideLabels = castbarHideLabels,
		hideGroups = { { title = L["ShowBarVisibilityGroupGeneral"], keys = castbarHideKeys } },
		supportsThresholds = false,
	}
	-- Target/Focus cast bars: a target can be any class, so Empowered is always offered (unlike the player
	-- castbar, which gates it on the player's own spec). Otherwise identical to the player castbar profile.
	local targetCastbarConditionKeys = CopyKeys(CASTBAR_CONDITION_KEYS)
	local targetCastbarProfile = {
		showKeys = targetCastbarConditionKeys,
		showLabels = castbarConditionLabels,
		showGroups = { { title = L["ShowBarVisibilityGroupCasting"], keys = targetCastbarConditionKeys } },
		hideKeys = castbarHideKeys,
		hideLabels = castbarHideLabels,
		hideGroups = { { title = L["ShowBarVisibilityGroupGeneral"], keys = castbarHideKeys } },
		supportsThresholds = false,
	}
	-- The Pet Cast Bar: the cast bar profile without Empowered, which no pet casts.
	local petCastbarConditionKeys = { "casting", "channeling" }
	local petCastbarProfile = {
		showKeys = petCastbarConditionKeys,
		showLabels = castbarConditionLabels,
		showGroups = { { title = L["ShowBarVisibilityGroupCasting"], keys = petCastbarConditionKeys } },
		hideKeys = castbarHideKeys,
		hideLabels = castbarHideLabels,
		hideGroups = { { title = L["ShowBarVisibilityGroupGeneral"], keys = castbarHideKeys } },
		supportsThresholds = false,
	}
	-- Mirror timers: one show state, "When Active", meaning the bar's timer is
	-- running. It sits alongside Always Show / Never Show exactly like the cast bars' cast states do, so
	-- a bar can be enabled without being pinned on screen. Resource/health thresholds don't apply, but
	-- the hard-hide list is the full standard one (Druid forms included) rather than the cast bars'
	-- pared-back pair: these run in exactly the situations people want to suppress -- mounted, flying,
	-- on a taxi -- so the whole set has to be reachable.
	local timerBarConditionKeys = CopyKeys(TIMER_CONDITION_KEYS)
	local timerBarProfile = {
		showKeys = timerBarConditionKeys,
		showLabels = LabelsFor(timerBarConditionKeys),
		showGroups = { { title = L["ShowBarVisibilityGroupTimer"], keys = timerBarConditionKeys } },
		hideKeys = hideConditionKeys,
		hideLabels = hideConditionLabels,
		hideGroups = hideConditionGroups,
		supportsThresholds = false,
	}
	-- GCD and swing bars (definition `environmentShowConditions`): When Active first, then the standard groups.
	local timerEnvironmentKeys = CopyKeys(TIMER_CONDITION_KEYS)
	for _, key in ipairs(conditionKeys) do
		timerEnvironmentKeys[#timerEnvironmentKeys + 1] = key
	end
	local timerEnvironmentGroups = { { title = L["ShowBarVisibilityGroupTimer"], keys = CopyKeys(TIMER_CONDITION_KEYS) } }
	for _, group in ipairs(conditionGroups) do
		timerEnvironmentGroups[#timerEnvironmentGroups + 1] = group
	end
	local timerEnvironmentProfile = {
		showKeys = timerEnvironmentKeys,
		showLabels = LabelsFor(timerEnvironmentKeys),
		showGroups = timerEnvironmentGroups,
		hideKeys = hideConditionKeys,
		hideLabels = hideConditionLabels,
		hideGroups = hideConditionGroups,
		supportsThresholds = false,
	}
	-- Ranged Swing adds Held by Movement to its Timer group, for classes that auto-shoot and the global scope.
	local rangedSwingProfile = nil
	local descriptor = TRB.Classes.SpecDescriptor:Get(classId, specId)
	if classId == nil or (descriptor ~= nil and descriptor.rangedAttack == true) then
		local rangedTimerKeys = CopyKeys(TIMER_CONDITION_KEYS)
		for _, key in ipairs(CopyKeys(RANGED_TIMER_CONDITION_KEYS)) do
			rangedTimerKeys[#rangedTimerKeys + 1] = key
		end
		local rangedShowKeys = CopyKeys(rangedTimerKeys)
		for _, key in ipairs(conditionKeys) do
			rangedShowKeys[#rangedShowKeys + 1] = key
		end
		local rangedShowGroups = { { title = L["ShowBarVisibilityGroupTimer"], keys = rangedTimerKeys } }
		for _, group in ipairs(conditionGroups) do
			rangedShowGroups[#rangedShowGroups + 1] = group
		end
		rangedSwingProfile = {
			showKeys = rangedShowKeys,
			showLabels = LabelsFor(rangedShowKeys),
			showGroups = rangedShowGroups,
			hideKeys = hideConditionKeys,
			hideLabels = hideConditionLabels,
			hideGroups = hideConditionGroups,
			supportsThresholds = false,
		}
	end
	-- Main Hand Swing also offers Item not equipped, closing its General hide group.
	local mainHandHideKeys = CopyKeys(hideConditionKeys)
	mainHandHideKeys[#mainHandHideKeys + 1] = "isItemMissing"
	local mainHandHideGroups = {}
	for _, group in ipairs(hideConditionGroups) do
		if group.title == L["ShowBarVisibilityGroupGeneral"] then
			local keys = CopyKeys(group.keys)
			keys[#keys + 1] = "isItemMissing"
			group = { title = group.title, keys = keys }
		end
		mainHandHideGroups[#mainHandHideGroups + 1] = group
	end
	local mainHandSwingProfile = {
		showKeys = timerEnvironmentKeys,
		showLabels = timerEnvironmentProfile.showLabels,
		showGroups = timerEnvironmentGroups,
		hideKeys = mainHandHideKeys,
		hideLabels = LabelsFor(mainHandHideKeys),
		hideGroups = mainHandHideGroups,
		supportsThresholds = false,
	}
	local thresholdTypeDefinitions = {}
	for _, tt in ipairs(BASE_THRESHOLD_TYPES) do
		thresholdTypeDefinitions[tt.key] = tt
	end
	for _, tt in ipairs(extraThresholdTypes) do
		thresholdTypeDefinitions[tt.key] = tt
	end
	local petThresholdTypeDefinitions = {}
	for _, tt in ipairs(PET_BAR_THRESHOLD_TYPES) do
		petThresholdTypeDefinitions[tt.key] = tt
	end
	-- The selected bar's definitions, so the detail panel's labels follow its profile.
	local activeThresholdDefinitions = thresholdTypeDefinitions

	-- Pet bars: the standard lists and thresholds, each list closed by a Pet group of pet states.
	local petShowKeys, petShowGroups = AppendGroup(conditionKeys, conditionGroups, L["ShowBarVisibilityGroupPet"], CopyKeys(PET_CONDITION_KEYS))
	local petHideKeys, petHideGroups = AppendGroup(hideConditionKeys, hideConditionGroups, L["ShowBarVisibilityGroupPet"], CopyKeys(PET_CONDITION_KEYS))
	local petBarProfile = {
		showKeys = petShowKeys,
		showLabels = LabelsFor(petShowKeys),
		showGroups = petShowGroups,
		hideKeys = petHideKeys,
		hideLabels = LabelsFor(petHideKeys),
		hideGroups = petHideGroups,
		supportsThresholds = true,
		thresholdDefinitions = petThresholdTypeDefinitions,
	}
	local standardProfile = {
		showKeys = conditionKeys,
		showLabels = conditionLabels,
		showGroups = conditionGroups,
		hideKeys = hideConditionKeys,
		hideLabels = hideConditionLabels,
		hideGroups = hideConditionGroups,
		supportsThresholds = true,
		thresholdDefinitions = thresholdTypeDefinitions,
	}
	-- Skyriding bars: whether you're skyriding decides them, so both lists stay short.
	local skyridingShowKeys = { "isSkyriding", "isSkyridingFlying", "isNotSkyriding" }
	local skyridingHideKeys = { "inVehicle", "isDead", "isNotSkyriding" }
	local skyridingProfile = {
		showKeys = skyridingShowKeys,
		showLabels = LabelsFor(skyridingShowKeys),
		showGroups = { { title = L["ShowBarVisibilityGroupMounting"], keys = skyridingShowKeys } },
		hideKeys = skyridingHideKeys,
		hideLabels = LabelsFor(skyridingHideKeys),
		hideGroups = {
			{ title = L["ShowBarVisibilityGroupGeneral"], keys = { "inVehicle", "isDead" } },
			{ title = L["ShowBarVisibilityGroupMounting"], keys = { "isNotSkyriding" } },
		},
		supportsThresholds = false,
	}

	local profilesByKey = {
		standard = standardProfile,
		castbar = castbarProfile,
		targetCastbar = targetCastbarProfile,
		petCastbar = petCastbarProfile,
		timerBar = timerBarProfile,
		timerEnvironment = timerEnvironmentProfile,
		-- A class that doesn't auto-shoot has no ranged profile, and offers the same list as the off hand timer.
		rangedSwing = rangedSwingProfile or timerEnvironmentProfile,
		mainHandSwing = mainHandSwingProfile,
		petBar = petBarProfile,
		skyriding = skyridingProfile,
	}

	---Returns the condition profile (show/hide keys, labels, groups) for a bar entry.
	---@param barEntry table?
	---@return table profile
	local function GetProfileForEntry(barEntry)
		if barEntry == nil then
			return standardProfile
		end
		local profileKey = barEntry.isPreset and barEntry.profileKey or barVisibility:GetProfileKeyForBar(barEntry.displayBarKey)
		return profilesByKey[profileKey] or standardProfile
	end

	local function GetThresholdTypesForBarEntry(barEntry)
		-- A preset is not one bar's resource, so it has no threshold to compare.
		if barEntry ~= nil and barEntry.isPreset then
			return {}
		end
		-- Self-driven bars (cast bars, GCD, mirror timers) fill from a timeline, not a resource, so a
		-- resource/health threshold condition has nothing to compare against.
		if barEntry ~= nil and (barEntry.isCastbar or barEntry.isTimerBar or barEntry.isSkyridingBar) then
			return {}
		end
		local types = {}
		for _, tt in ipairs((barEntry ~= nil and barEntry.isPetBar) and PET_BAR_THRESHOLD_TYPES or BASE_THRESHOLD_TYPES) do
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
		if profile.supportsThresholds and ct ~= nil and ct ~= "none" and profile.thresholdDefinitions[ct] ~= nil then
			table.insert(selectedLabels, profile.thresholdDefinitions[ct].label)
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

	---Applies an edit to the selected preset to every bar using it, in every specialization.
	local function RefreshPresetEdit()
		barVisibility:PushPresetToEntries(selectedPresetGuid)
		TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChangeAllSpecs()
	end

	---Refreshes the spec/global cache and re-evaluates bar visibility after visibility settings change.
	local function RefreshVisibilitySettings()
		if selectedPresetGuid ~= nil then
			RefreshPresetEdit()
			return
		end
		TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChange(classId, specId, false)
	end

	---Refreshes the spec/global cache, reapplies bar appearance, and re-evaluates visibility for changes affecting custom bars.
	local function RefreshVisibilityAndAppearance()
		if selectedPresetGuid ~= nil then
			RefreshPresetEdit()
			return
		end
		TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChange(classId, specId, true)
	end

	---Refresh for changes that alter which bars should render (Never Show / Always Show, show and
	---hard-hide conditions). These need the applied show/alpha state rebuilt rather than reused,
	---so a bar switched back on draws immediately instead of waiting for the next visibility event.
	local function RefreshVisibilityConditions()
		if selectedPresetGuid ~= nil then
			RefreshPresetEdit()
			return
		end
		TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChange(classId, specId, true, true)
	end

	---Populates the show-condition dropdown menu.
	---@param rootDescription table The root menu description to add items to
	---@param entry table The visibility settings entry to read/write conditions on
	---@param thresholdTypesForBar table[] The threshold condition types available for the selected bar
	---@param onChange function Callback invoked after any condition is toggled
	---@param profile table The condition profile for the bar
	---@param isPreset boolean? # Presets leave Never Show to each bar
	local function BuildShowVisibilityDropdownItems(rootDescription, entry, thresholdTypesForBar, onChange, profile, isPreset)
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
					if not isPreset then
						entry.neverShow = false
					end
				end
				onChange()
			end
		)

		if not isPreset then
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
		end

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

	-- Build list of every bar entry; the tab lists the ones in its grouping

	-- Primary bar (always present)
	table.insert(allBarEntries, {
		key = "primary",
		displayBarKey = "primary",
		label = string.format(L["BarVisibilityBarNamePrimary"], primaryResourceString or L["ResourceMana"]),
		globalLabel = string.format(L["BarVisibilityBarNamePrimary"], L["Resource"]),
		isCustomBar = false,
		isGlobal = (classId ~= nil and coreDisplayBar["primary"] ~= nil),
	})

	-- Health bar
	if includeHealthVisibility and spec.displayBar.health ~= nil then
		table.insert(allBarEntries, {
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
		table.insert(allBarEntries, {
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
		table.insert(allBarEntries, {
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
			-- A class module may rename a shared bar after its own use of it, which Global Options must not show.
			local globalDisplayName = barTypeDef.globalDisplayName
			local registryDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(barTypeDef.visibilityKey)
			if registryDef then
				globalDisplayName = registryDef.globalDisplayName
			end
			table.insert(allBarEntries, {
				key = barTypeDef.key,
				displayBarKey = barTypeDef.visibilityKey,
				label = string.format(L["ShowBarVisibilityCustom"], classId == nil and globalDisplayName or barTypeDef.displayName),
				globalLabel = string.format(L["ShowBarVisibilityCustom"], globalDisplayName),
				isCustomBar = true,
				hidesSmooth = barTypeDef.timerDrivenFill == true,
				isGlobal = (classId ~= nil and coreDisplayBar[barTypeDef.visibilityKey] ~= nil),
			})
		end
	end

	-- Cast bar: self-driven render (Functions/Castbar.lua) configured through the same visibility entries
	if spec.displayBar and spec.displayBar.castbar ~= nil then
		table.insert(allBarEntries, {
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
		table.insert(allBarEntries, {
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
		table.insert(allBarEntries, {
			key = "focusCastbar",
			displayBarKey = "focusCastbar",
			label = L["BarVisibilityBarNameFocusCastbar"],
			globalLabel = L["BarVisibilityBarNameFocusCastbar"],
			isCustomBar = false,
			isCastbar = true,
			isGlobal = (classId ~= nil and coreDisplayBar["focusCastbar"] ~= nil),
		})
	end

	-- Other Bars: self-driven timer bars; only those flagged environmentShowConditions offer the standard show list.
	for _, otherBarKey in ipairs(TRB.Classes.BarTypeRegistry:GetOtherBarKeys(classId)) do
		if spec.displayBar and spec.displayBar[otherBarKey] ~= nil then
			local otherBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(otherBarKey)
			local otherBarLabel = otherBarDef and otherBarDef.displayName or otherBarKey
			table.insert(allBarEntries, {
				key = otherBarKey,
				displayBarKey = otherBarKey,
				label = otherBarLabel,
				globalLabel = otherBarLabel,
				isCustomBar = false,
				isTimerBar = true,
				environmentShowConditions = otherBarDef ~= nil and otherBarDef.environmentShowConditions or false,
				-- Scope decides this, not whether core happens to hold the key: a class-scoped bar such as
				-- Feign Death has no global screen to configure, so its row must stay spec-editable.
				isGlobal = (classId ~= nil and coreDisplayBar[otherBarKey] ~= nil
					and TRB.Classes.BarTypeRegistry:IsGlobalScopeBar(otherBarKey)),
			})
		end
	end

	-- Pet bars, only on the specs that have their settings; the Pet Cast Bar takes the cast bars' states.
	local petBarKeysForPanel = (classId == nil) and TRB.Classes.BarTypeRegistry.petScopeKeys
		or TRB.Classes.BarTypeRegistry:GetPetScopeKeys(classId, specId)
	for _, petBarKey in ipairs(petBarKeysForPanel) do
		if spec.displayBar and spec.displayBar[petBarKey] ~= nil then
			local petBarDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(petBarKey)
			local petBarLabel = petBarDef and petBarDef.displayName or petBarKey
			local isCastbar = petBarKey == "petCastbar"
			table.insert(allBarEntries, {
				key = petBarKey,
				displayBarKey = petBarKey,
				label = petBarLabel,
				globalLabel = petBarLabel,
				isCustomBar = false,
				isCastbar = isCastbar,
				isPetBar = not isCastbar,
				isGlobal = (classId ~= nil and coreDisplayBar[petBarKey] ~= nil),
			})
		end
	end

	-- Skyriding bars, every spec. Only Speed fills from a value, so it alone keeps Smooth.
	for _, skyridingKey in ipairs(TRB.Classes.BarTypeRegistry.skyridingBarKeys) do
		if spec.displayBar and spec.displayBar[skyridingKey] ~= nil then
			local skyridingDef = TRB.Classes.BarTypeRegistry:GetInstance():Get(skyridingKey)
			local skyridingLabel = skyridingDef and skyridingDef.displayName or skyridingKey
			table.insert(allBarEntries, {
				key = skyridingKey,
				displayBarKey = skyridingKey,
				label = skyridingLabel,
				globalLabel = skyridingLabel,
				isCustomBar = false,
				isSkyridingBar = true,
				hidesSmooth = skyridingDef ~= nil and skyridingDef.timerDrivenFill == true,
				isGlobal = (classId ~= nil and coreDisplayBar[skyridingKey] ~= nil),
			})
		end
	end

	-- barEntries is mutated in place: the Use Global box, table, detail panel, and handlers all close over it.
	local function RebuildBarEntries()
		for index = #barEntries, 1, -1 do
			barEntries[index] = nil
		end
		for _, entry in ipairs(allBarEntries) do
			if TRB.Classes.BarTypeRegistry:IsBarInGroupScope(entry.displayBarKey, groupKey, includeAllGroups[scopeKey]) then
				barEntries[#barEntries + 1] = entry
			end
		end
	end
	RebuildBarEntries()

	-- Show at most 5 rows; LibScrollingTable adds a scrollbar when there are more bars than that.
	local function GetTableRowCount(entryCount)
		return math.min(math.max(entryCount, 2), 5)
	end

	-- The bars table, with its table-level action above it on the right. Manage Presets lists presets instead.
	controls.buttons = controls.buttons or {}
	local bvc = nil
	---@type any
	local barVisibilityTable = nil
	local tableRowCount = 0
	if not isPresetHost then
		controls.buttons.applyToBars = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["BarVisibilityApplyToBars"], 0, 0, 170, 22)
		controls.buttons.applyToBars:ClearAllPoints()
		controls.buttons.applyToBars:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -oUi.xCoord, yCoord)
		yCoord = yCoord - 30

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
		bvc = controls.barVisibilityContainer
		bvc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
		bvc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
		tableRowCount = GetTableRowCount(#barEntries)
		bvc:SetHeight(35 + (tableRowCount * 15))

		barVisibilityTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, tableRowCount, 15, nil, bvc, false, false)

		-- Dynamically resize the Settings Source column to fill available width
		bvc:HookScript("OnSizeChanged", function(self, w, h)
			local fixedWidth = columns[1].width + columns[2].width + columns[3].width + columns[4].width
			local newSettingsSourceWidth = math.max(180, w - fixedWidth - 30)
			columns[5].width = newSettingsSourceWidth
			barVisibilityTable:SetDisplayCols(columns)
		end)
	end

	---Fits the table to the bars listed; the detail panel is anchored below it and follows.
	local function ResizeTable()
		-- Manage Presets lists presets, not bars, so it has no bars table.
		if bvc == nil then
			return
		end
		local rowCount = GetTableRowCount(#barEntries)
		barVisibilityTable:SetDisplayRows(rowCount, 15)
		bvc:SetHeight(35 + (rowCount * 15))
	end

	local globalDimColor = { r = 0.5, g = 0.5, b = 0.5, a = 0.7 }

	---A preset shaped like a bar entry, so the detail panel can show either.
	---@param preset table
	---@return table
	local function BuildPresetEntry(preset)
		local profileKey = preset.profileKey or "standard"
		return {
			key = "preset:" .. preset.guid,
			label = preset.name or "",
			isPreset = true,
			profileKey = profileKey,
			isCastbar = profileKey == "castbar" or profileKey == "targetCastbar" or profileKey == "petCastbar",
			isTimerBar = profileKey == "timerBar" or profileKey == "timerEnvironment" or profileKey == "rangedSwing" or profileKey == "mainHandSwing",
		}
	end

	---Where a bar row's visibility comes from, what it shows, and the saved entry behind it.
	---@param entry table # A bar entry
	---@return "global"|"preset"|"own" source
	---@return table|nil shown # What the bar shows now, its preset included. Read-only unless the source is own
	---@return table|nil saved # The saved entry the values come from
	---@return table|nil preset # The preset in use, when the source is a preset
	local function ResolveRow(entry)
		local key = entry.displayBarKey
		if IsRowControlledByGlobal(entry) then
			local coreEntry = coreDisplayBar[key]
			return "global", barVisibility:ComposeEntry(coreEntry), coreEntry, nil
		end
		local saved = spec.displayBar[key]
		local preset = saved ~= nil and barVisibility:GetPreset(saved.presetId) or nil
		if preset ~= nil then
			return "preset", barVisibility:ComposeEntry(saved), saved, preset
		end
		return "own", saved, saved, nil
	end

	---Refreshes the scrolling table data from the current bar visibility settings.
	local function SetTableValues()
		if barVisibilityTable == nil then
			return
		end
		local dataTable = {}
		for _, entry in ipairs(barEntries) do
			local source, visSettings, _, preset = ResolveRow(entry)
			local showText = ""
			local hideText = ""
			if visSettings then
				local profile = GetProfileForEntry(entry)
				showText = GetShowVisibilityTableDisplayName(visSettings, profile)
				hideText = GetHideVisibilityTableDisplayName(visSettings, profile)
			end
			local sourceText
			if source == "global" then
				sourceText = entry.globalLabel and string.format(L["BarVisibilitySettingsSourceGlobalNamed"], entry.globalLabel) or L["BarVisibilitySettingsSourceGlobal"]
			elseif source == "preset" then
				sourceText = string.format(L["BarVisibilitySettingsSourcePreset"], preset and preset.name or "")
			elseif classId == nil then
				sourceText = L["BarVisibilitySettingsSourceGlobal"]
			else
				sourceText = L["BarVisibilitySettingsSourceSpec"]
			end
			local rowData = {
				cols = {
					{ value = entry.key },
					{ value = entry.label },
					{ value = showText },
					{ value = hideText },
					{ value = sourceText },
				}
			}
			if source ~= "own" then
				rowData.color = globalDimColor
			end
			table.insert(dataTable, rowData)
		end
		barVisibilityTable:SetData(dataTable)
		barVisibilityTable:EnableSelection(true)
	end

	-- ===== Presets: the table and editor of Global Options' Manage Presets tab =====
	local PRESET_TABLE_ROWS = 5
	local PRESET_EDITOR_HEIGHT = 55
	local presetsTableHeight = 35 + (PRESET_TABLE_ROWS * 15)
	---@type any
	local presetTable = nil
	local presetList = {}
	local presetEditorRow = nil
	local presetNameLabel = nil
	local presetNameBox = nil
	local presetKindDropdown = nil
	local detailAnchor = bvc
	-- Reselects the open bar or preset after a redraw; assigned once the detail panel exists.
	---@type fun()
	local ReselectSelection = nil
	-- Shows the selected preset's name and kind, or hides them; a no-op wherever there are no presets.
	---@type fun(preset: table?)
	local SyncPresetEditor = function() end
	local SelectPreset = nil
	-- Asks before deleting a preset; assigned with the table's handlers.
	local PromptDeletePreset = nil

	if isPresetHost then
		local presetsTableFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
		controls.barVisibilityPresets = presetsTableFrame
		presetsTableFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
		presetsTableFrame:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
		presetsTableFrame:SetHeight(presetsTableHeight)
		local presetColumns = {
			{ ["name"] = "Key", ["width"] = 1, ["align"] = "CENTER" },
			{ ["name"] = L["BarVisibilityPresetTableHeaderName"], ["width"] = 260, ["align"] = "LEFT" },
			{ ["name"] = L["BarVisibilityPresetTableHeaderKind"], ["width"] = 230, ["align"] = "LEFT" },
			{ ["name"] = L["BarVisibilityPresetTableHeaderUsedBy"], ["width"] = 70, ["align"] = "LEFT" },
			{ ["name"] = "", ["width"] = 15, ["align"] = "CENTER", ["color"] = deleteActionTextColor },
		}
		presetTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(presetColumns, PRESET_TABLE_ROWS, 15, nil, presetsTableFrame, false, false)

		-- Dynamically resize the Name column to fill available width
		presetsTableFrame:HookScript("OnSizeChanged", function(self, w, h)
			local fixedWidth = presetColumns[1].width + presetColumns[3].width + presetColumns[4].width + presetColumns[5].width
			presetColumns[2].width = math.max(150, w - fixedWidth - 30)
			presetTable:SetDisplayCols(presetColumns)
		end)

		SetPresetTableValues = function()
			presetList = barVisibility:GetPresetsOrdered()
			local uses = barVisibility:CountAllPresetUses()
			local dataTable = {}
			for _, preset in ipairs(presetList) do
				dataTable[#dataTable + 1] = {
					cols = {
						{ value = preset.guid },
						{ value = preset.name or "" },
						{ value = presetKindLabels[preset.profileKey or "standard"] or "" },
						{ value = tostring(uses[preset.guid] or 0) },
						{ value = "X", color = deleteActionTextColor, DoCellUpdate = UpdateActionCell },
					}
				}
			end
			presetTable:SetData(dataTable)
			presetTable:EnableSelection(true)
		end

		-- Name and kind of the open preset under the table, with Add Preset on the right.
		presetEditorRow = CreateFrame("Frame", nil, parent)
		presetEditorRow:SetPoint("TOPLEFT", presetsTableFrame, "BOTTOMLEFT", 0, -10)
		presetEditorRow:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
		presetEditorRow:SetHeight(PRESET_EDITOR_HEIGHT)
		detailAnchor = presetEditorRow

		local presetAddButton = TRB.Functions.OptionsUi.Primitives:BuildButton(presetEditorRow, L["BarVisibilityPresetAdd"], 0, 0, 140, 24)
		presetAddButton:ClearAllPoints()
		presetAddButton:SetPoint("TOPRIGHT", presetEditorRow, "TOPRIGHT", -5, -8)
		controls.buttons.addPreset = presetAddButton

		presetNameLabel = TRB.Functions.OptionsUi.Primitives:BuildLabel(presetEditorRow, L["BarVisibilityPresetName"], 0, 0, 250, 20, GameFontNormal)
		presetNameBox = TRB.Functions.OptionsUi.Primitives:BuildTextBox(presetEditorRow, "", 60, 250, 24, 0, -22)
		local kindOptions = {}
		for _, kindKey in ipairs(presetKindOrder) do
			kindOptions[#kindOptions + 1] = { value = kindKey, label = presetKindLabels[kindKey] }
		end
		presetKindDropdown = TRB.Functions.OptionsUi.Primitives:BuildDropdown(presetEditorRow, "TwintopResourceBar_" .. namePrefix .. "_PresetKind", nil, kindOptions,
			function()
				local preset = barVisibility:GetPreset(selectedPresetGuid)
				return preset ~= nil and preset.profileKey or "standard"
			end,
			function(value)
				local preset = barVisibility:GetPreset(selectedPresetGuid)
				if preset == nil or preset.profileKey == value then
					return
				end
				local guid = preset.guid
				local function ChangeKind()
					if barVisibility:GetPreset(guid) == nil then
						return
					end
					-- An entry only takes a preset of its own kind, so the ones naming it let go and keep what they show.
					barVisibility:UnlinkPreset(guid)
					preset.profileKey = value
					TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChangeAllSpecs()
					-- The kind decides which conditions the preset offers, so the panel is rebuilt around it.
					SetPresetTableValues()
					FillDetailPanel("preset:" .. guid)
					ReselectSelection()
				end
				local uses = barVisibility:CountPresetUses(guid)
				if uses == 0 then
					ChangeKind()
					return
				end
				StaticPopup_Show("TwintopResourceBar_VisibilityPresetKind", nil, nil, {
					message = string.format(L["BarVisibilityPresetKindConfirm"], preset.name or "",
						presetKindLabels[preset.profileKey or "standard"] or "", presetKindLabels[value] or "", uses),
					onAccept = ChangeKind,
					onCancel = function()
						SyncPresetEditor(preset)
					end,
				})
			end, 0, 0)
		-- Level with the name box, and narrow enough to leave room for Add Preset.
		presetKindDropdown:ClearAllPoints()
		presetKindDropdown:SetPoint("LEFT", presetNameBox, "RIGHT", 20, 0)
		presetKindDropdown:SetWidth(235)
		-- Its label sits on the Name label's row.
		presetKindDropdown.label = TRB.Functions.OptionsUi.Primitives:BuildLabel(presetEditorRow, L["BarVisibilityPresetKind"], 270, 0, 235, 20, GameFontNormal)
		presetNameLabel:Hide()
		presetNameBox:Hide()
		presetKindDropdown.label:Hide()
		presetKindDropdown:Hide()

		SyncPresetEditor = function(preset)
			local isShown = preset ~= nil
			presetNameLabel:SetShown(isShown)
			presetNameBox:SetShown(isShown)
			presetKindDropdown.label:SetShown(isShown)
			presetKindDropdown:SetShown(isShown)
			if not isShown then
				return
			end
			presetNameBox:SetText(preset.name or "")
			presetNameBox:SetCursorPosition(0)
			presetKindDropdown:SetDefaultText(presetKindLabels[preset.profileKey or "standard"] or "")
		end

		presetNameBox:SetScript("OnTextChanged", function(self, userInput)
			if not userInput or selectedPresetGuid == nil then
				return
			end
			local preset = barVisibility:GetPreset(selectedPresetGuid)
			local name = self:GetText()
			if preset ~= nil and name ~= "" then
				preset.name = name
				ReselectSelection()
			end
		end)
	end

	-- Detail panel below the table
	local detailHeight = 360
	controls.barVisibilityDetail = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarVisibilityDetail", parent, "BackdropTemplate")
	local detailFrame = controls.barVisibilityDetail
	detailFrame:SetPoint("TOPLEFT", detailAnchor, "BOTTOMLEFT", 0, 0)
	detailFrame:SetPoint("TOPRIGHT", detailAnchor, "BOTTOMRIGHT", 0, 0)
	detailFrame:SetHeight(detailHeight)
	detailFrame:Hide()

	local detailYCoord = 0
	local selectedBarKey = nil
	-- Assigned below, once the detail panel can refill itself.
	---@type fun()
	local CustomizeSelectedRow = nil

	-- Detail panel contents: header, show/hide dropdowns, smooth checkbox, sliders
	local detailHeader = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(detailFrame, "", oUi.xCoord, detailYCoord)

	-- Copy, link, and save-as-preset actions for the selected bar; assigned below, with the menus.
	---@type fun(owner: Frame)
	local OpenActionsMenu = nil
	local actionsButton = TRB.Functions.OptionsUi.Primitives:BuildButton(detailFrame, L["BarVisibilityActionsButton"], 0, 0, 120, 22)
	actionsButton:ClearAllPoints()
	actionsButton:SetPoint("TOPRIGHT", detailFrame, "TOPRIGHT", -5, 0)
	actionsButton:SetScript("OnClick", function(self)
		OpenActionsMenu(self)
	end)
	controls.buttons.barActions = actionsButton

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

		local thresholdDefinition = activeThresholdDefinitions[conditionType]
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
		local thresholdDefinition = activeThresholdDefinitions[conditionType]
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
			local thresholdDefinition = activeThresholdDefinitions[conditionType]
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

	-- Blocks the detail controls of a row that follows Global Options or a preset, with the way out.
	local detailCover = TRB.Functions.OptionsUi.Primitives:BuildSectionCover(detailFrame, -30, -detailHeight)
	controls.barVisibilityDetailCover = detailCover
	local coverMessage = detailCover:CreateFontString(nil, "OVERLAY")
	coverMessage:SetFontObject(GameFontHighlightLarge)
	coverMessage:SetTextColor(TRB.Functions.OptionsUi.ColorPickers:GetUseGlobalSettingsColor())
	coverMessage:SetJustifyH("CENTER")
	coverMessage:SetText(L["BarVisibilityUsingGlobal"])
	-- Raised by half the button row so the message and buttons sit centered as one block.
	coverMessage:SetPoint("LEFT", detailCover, "LEFT", 20, 15)
	coverMessage:SetPoint("RIGHT", detailCover, "RIGHT", -20, 15)

	local coverOpen = CreateFrame("Button", nil, detailCover, "UIPanelButtonTemplate")
	coverOpen:SetText(L["UseGlobalCoverOpenGlobal"])
	coverOpen:SetSize(coverOpen:GetTextWidth() + 30, 22)
	coverOpen:SetPoint("TOPRIGHT", coverMessage, "BOTTOM", -5, -8)
	coverOpen:SetScript("OnClick", function()
		for _, e in ipairs(barEntries) do
			if e.key == selectedBarKey then
				local _, _, _, preset = ResolveRow(e)
				if preset ~= nil then
					TRB.Functions.OptionsUi.Visibility:OpenGlobalPreset(preset.guid)
				else
					TRB.Functions.OptionsUi.Visibility:OpenGlobalVisibility(e.displayBarKey)
				end
				return
			end
		end
	end)

	local coverCustomize = CreateFrame("Button", nil, detailCover, "UIPanelButtonTemplate")
	coverCustomize:SetText(L["UseGlobalCoverCustomize"])
	coverCustomize:SetSize(coverCustomize:GetTextWidth() + 30, 22)
	coverCustomize:SetPoint("TOPLEFT", coverMessage, "BOTTOM", 5, -8)
	coverCustomize:SetScript("OnClick", function()
		CustomizeSelectedRow()
	end)
	detailCover.customizeButton = coverCustomize
	detailCover.openButton = coverOpen

	---Redraws both tables and keeps the open bar or preset highlighted.
	ReselectSelection = function()
		SetTableValues()
		for i, e in ipairs(barEntries) do
			if e.key == selectedBarKey then
				barVisibilityTable:SetSelection(i)
				break
			end
		end
		if SetPresetTableValues ~= nil then
			SetPresetTableValues()
			for i, preset in ipairs(presetList) do
				if preset.guid == selectedPresetGuid then
					presetTable:SetSelection(i)
					break
				end
			end
		end
	end

	---Populates the bar visibility detail panel with controls for the selected bar's, or preset's, visibility settings.
	---@param barKey string The key identifying which bar to display details for, or "preset:" and a preset's id
	FillDetailPanel = function(barKey)
		local presetGuid = barKey:match("^preset:(.+)$")
		local barEntry = nil
		local visSettings = nil
		local source = "own"
		local sourcePreset = nil
		if presetGuid ~= nil then
			local preset = barVisibility:GetPreset(presetGuid)
			if preset == nil then
				detailFrame:Hide()
				return
			end
			selectedPresetGuid = presetGuid
			selectedBarKey = nil
			barEntry = BuildPresetEntry(preset)
			visSettings = preset
		else
			selectedPresetGuid = nil
			selectedBarKey = barKey
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
			-- A row on Global Options or a preset shows those values, read-only.
			local rowSource, rowShown, _, rowPreset = ResolveRow(barEntry)
			source, visSettings, sourcePreset = rowSource, rowShown, rowPreset
		end
		if visSettings == nil then
			detailFrame:Hide()
			return
		end
		SyncPresetEditor(barEntry.isPreset and visSettings or nil)

		-- Update header
		if barEntry.isPreset then
			detailHeader.font:SetText(string.format(L["BarVisibilityPresetDetailHeader"], barEntry.label))
		else
			detailHeader.font:SetText(string.format(L["BarVisibilityDetailHeader"], barEntry.label))
		end

		-- Determine if this bar needs the appearance refresh (custom bars)
		local refreshFunc = barEntry.isCustomBar and RefreshVisibilityAndAppearance or RefreshVisibilitySettings
		local profile = GetProfileForEntry(barEntry)
		activeThresholdDefinitions = profile.thresholdDefinitions or thresholdTypeDefinitions

		-- Visibility dropdowns
		local function OnVisibilityChange()
			local displayText = GetShowVisibilityDisplayName(visSettings, profile)
			controls.dropDown.selectedBarVisibility:SetDefaultText(displayText)
			controls.dropDown.selectedBarVisibility:SetText(displayText)
			ShowThresholdControls(visSettings.resourceConditionType or "none", visSettings)
			RefreshVisibilityConditions()
			ReselectSelection()
		end

		local function OnHideVisibilityChange()
			local displayText = GetHideVisibilityDisplayName(visSettings, profile)
			controls.dropDown.selectedHideVisibility:SetDefaultText(displayText)
			controls.dropDown.selectedHideVisibility:SetText(displayText)
			RefreshVisibilityConditions()
			ReselectSelection()
		end

		local function VisibilityGenerator(dropdown, rootDescription)
			BuildShowVisibilityDropdownItems(rootDescription, visSettings, GetThresholdTypesForBarEntry(barEntry), OnVisibilityChange, profile, barEntry.isPreset)
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

		-- Smooth checkbox (hidden wherever the fill is timeline-driven rather than resource-driven)
		if barEntry.isCastbar or barEntry.isTimerBar or barEntry.hidesSmooth then
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
			local thresholdDefinition = activeThresholdDefinitions[ct]
			local precision = (thresholdDefinition ~= nil and thresholdDefinition.isPercent == true) and 1 or 0
			value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, precision, nil, true)
			self.EditBox:SetText(value)
			visSettings.resourceConditionValue = value
			refreshFunc()
		end)
		controls.sliders.selectedThresholdValue:SetValue(visSettings.resourceConditionValue or 0)
		UpdateThresholdControlLabels(visSettings.resourceConditionType or "none")

		-- A row following Global Options or a preset is shown read-only behind a cover.
		detailCover:SetShown(source ~= "own")
		if source == "global" then
			coverMessage:SetText(L["BarVisibilityUsingGlobal"])
			coverOpen:SetText(L["UseGlobalCoverOpenGlobal"])
			coverCustomize:SetText(L["UseGlobalCoverCustomize"])
		elseif source == "preset" then
			coverMessage:SetText(string.format(L["BarVisibilityUsingPreset"], sourcePreset and sourcePreset.name or ""))
			coverOpen:SetText(L["BarVisibilityEditPreset"])
			coverCustomize:SetText(L["BarVisibilityCustomizeBar"])
		end
		coverOpen:SetWidth(coverOpen:GetTextWidth() + 30)
		coverCustomize:SetWidth(coverCustomize:GetTextWidth() + 30)
		actionsButton:SetShown(not barEntry.isPreset)
		detailFrame:Show()
	end

	---The open bar's entry, or nil when a preset or nothing is open.
	---@return table?
	local function GetSelectedBarEntry()
		for _, e in ipairs(barEntries) do
			if e.key == selectedBarKey then
				return e
			end
		end
		return nil
	end

	---Applies a change made to the open bar's saved entry, on every tab of this specialization.
	local function AfterRowEdit()
		TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChange(classId, specId, true, true)
		TRB.Functions.OptionsUi.Visibility:RefreshApis(classId, specId)
	end

	-- Detaches the selected row from what it follows, keeping the values it shows now so nothing changes until it is edited.
	CustomizeSelectedRow = function()
		local barEntry = GetSelectedBarEntry()
		if barEntry == nil then
			return
		end
		local source, shown, saved = ResolveRow(barEntry)
		if source == "preset" then
			barVisibility:UnlinkEntry(saved)
		elseif source == "global" then
			local specEntry = spec.displayBar[barEntry.displayBarKey]
			for k in pairs(specEntry) do
				specEntry[k] = nil
			end
			-- shown is already a copy of Global Options' entry with its preset's values laid over it.
			for k, v in pairs(shown) do
				specEntry[k] = v
			end
			specEntry.presetId = nil
			specEntry.useGlobal = false
		else
			return
		end
		AfterRowEdit()
	end

	---Copies the covered fields of a bar or preset onto the open bar, which keeps its own settings afterwards.
	---@param source table
	local function CopyOntoSelected(source)
		local barEntry = GetSelectedBarEntry()
		if barEntry == nil then
			return
		end
		local saved = spec.displayBar[barEntry.displayBarKey]
		barVisibility:CopyPresetFields(source, saved)
		saved.presetId = nil
		AfterRowEdit()
	end

	---Points the open bar at a preset.
	---@param presetId string
	local function LinkSelected(presetId)
		local barEntry = GetSelectedBarEntry()
		if barEntry == nil then
			return
		end
		barVisibility:LinkEntry(spec.displayBar[barEntry.displayBarKey], presetId)
		AfterRowEdit()
	end

	---Puts the open bar back on Global Options. Its own settings stay saved but unused, as with the Use Global box.
	local function UseGlobalSelected()
		local barEntry = GetSelectedBarEntry()
		if barEntry == nil then
			return
		end
		local saved = spec.displayBar[barEntry.displayBarKey]
		if saved ~= nil then
			saved.useGlobal = nil
			AfterRowEdit()
		end
	end

	-- Names a new preset after the open bar's current settings.
	local function PromptSavePreset()
		local barEntry = GetSelectedBarEntry()
		if barEntry == nil then
			return
		end
		local _, shown = ResolveRow(barEntry)
		local profileKey = barVisibility:GetProfileKeyForBar(barEntry.displayBarKey)
		StaticPopup_Show("TwintopResourceBar_VisibilityPresetName", nil, nil, {
			message = L["BarVisibilitySaveAsPresetPrompt"],
			initialName = barEntry.label,
			onAccept = function(name)
				barVisibility:NewPreset(shown, profileKey, name)
				TRB.Functions.OptionsUi.Visibility:RefreshAllApis()
			end,
		})
	end

	OpenActionsMenu = function(owner)
		local barEntry = GetSelectedBarEntry()
		if barEntry == nil then
			return
		end
		local source = ResolveRow(barEntry)
		local profileKey = barVisibility:GetProfileKeyForBar(barEntry.displayBarKey)
		local presets = barVisibility:GetPresetsOrdered(profileKey)
		MenuUtil.CreateContextMenu(owner, function(_, rootDescription)
			-- A bar of its own, or one on a preset, can go back to following Global Options.
			if classId ~= nil and barEntry.isGlobal and source ~= "global" then
				rootDescription:CreateButton(UseGlobalMenuText(L["BarVisibilityUseGlobal"]), UseGlobalSelected)
				rootDescription:CreateDivider()
			end
			-- A bar that follows Global Options or a preset is changed from its cover instead.
			if source == "own" then
				local copyMenu = rootDescription:CreateButton(L["BarVisibilityCopyFrom"])
				local sources = 0
				if classId ~= nil and barEntry.isGlobal then
					sources = sources + 1
					copyMenu:CreateButton(L["BarVisibilityCopyFromGlobal"], function()
						CopyOntoSelected(barVisibility:ComposeEntry(coreDisplayBar[barEntry.displayBarKey]))
					end)
				end
				for _, other in ipairs(allBarEntries) do
					if other ~= barEntry and spec.displayBar[other.displayBarKey] ~= nil
						and barVisibility:GetProfileKeyForBar(other.displayBarKey) == profileKey then
						sources = sources + 1
						copyMenu:CreateButton(other.label, function()
							local _, otherShown = ResolveRow(other)
							CopyOntoSelected(otherShown)
						end)
					end
				end
				if #presets > 0 then
					copyMenu:CreateDivider()
					copyMenu:CreateTitle(L["BarVisibilityCopyFromPresets"])
					for _, preset in ipairs(presets) do
						sources = sources + 1
						copyMenu:CreateButton(preset.name or "", function()
							CopyOntoSelected(preset)
						end)
					end
				end
				if sources == 0 then
					copyMenu:CreateTitle(L["BarVisibilityNoSources"])
				end

				local linkMenu = rootDescription:CreateButton(L["BarVisibilityLinkToPreset"])
				for _, preset in ipairs(presets) do
					local presetId = preset.guid
					linkMenu:CreateButton(preset.name or "", function()
						LinkSelected(presetId)
					end)
				end
				if #presets == 0 then
					linkMenu:CreateTitle(L["BarVisibilityNoPresets"])
				end
			end
			rootDescription:CreateButton(L["BarVisibilitySaveAsPreset"], PromptSavePreset)
		end)
	end

	-- The bars the Apply to Bars menu will change, by displayBar key. Kept between openings of the menu.
	local applyTargets = {}

	---Gives every checked bar of a source's kind that source's settings, or links it to the preset.
	---@param source table # A bar's shown values, or a preset
	---@param profileKey string # Only bars of this kind are changed
	---@param linkPresetId string? # Link the bars to this preset instead of copying
	local function ApplyToTargets(source, profileKey, linkPresetId)
		local applied = 0
		for _, target in ipairs(barEntries) do
			local saved = spec.displayBar[target.displayBarKey]
			if applyTargets[target.displayBarKey] and saved ~= nil
				and barVisibility:GetProfileKeyForBar(target.displayBarKey) == profileKey then
				-- A bar that follows Global Options takes its own settings, or the change would never show.
				if IsRowControlledByGlobal(target) then
					saved.useGlobal = false
				end
				if linkPresetId ~= nil then
					barVisibility:LinkEntry(saved, linkPresetId)
				else
					barVisibility:CopyPresetFields(source, saved)
					saved.presetId = nil
				end
				applied = applied + 1
			end
		end
		if applied == 0 then
			StaticPopup_Show("TwintopResourceBar_VisibilityMessage", L["BarVisibilityApplyNoneChecked"])
			return
		end
		AfterRowEdit()
	end

	---Puts every checked bar that can follow Global Options back on it.
	local function ApplyUseGlobalToTargets()
		local checked, applied = 0, 0
		for _, target in ipairs(barEntries) do
			if applyTargets[target.displayBarKey] then
				checked = checked + 1
				local saved = spec.displayBar[target.displayBarKey]
				if target.isGlobal and saved ~= nil then
					saved.useGlobal = nil
					applied = applied + 1
				end
			end
		end
		if checked == 0 then
			StaticPopup_Show("TwintopResourceBar_VisibilityMessage", L["BarVisibilityApplyChooseFirst"])
			return
		end
		if applied == 0 then
			StaticPopup_Show("TwintopResourceBar_VisibilityMessage", L["BarVisibilityApplyNoneGlobal"])
			return
		end
		AfterRowEdit()
	end

	if controls.buttons.applyToBars ~= nil then
		controls.buttons.applyToBars:SetScript("OnClick", function(self)
			MenuUtil.CreateContextMenu(self, function(_, rootDescription)
				rootDescription:CreateTitle(L["BarVisibilityApplyToBars"])

				-- The listed bars, kind by kind, as checkboxes. A source below applies to the checked bars of its own kind.
				local chooseMenu = rootDescription:CreateButton(L["BarVisibilityApplyChooseBars"])
				TRB.Functions.OptionsUi.Primitives:LimitMenuRows(chooseMenu, #barEntries + #presetKindOrder)
				local kindsPresent = {}
				for _, kindKey in ipairs(presetKindOrder) do
					local first = true
					for _, e in ipairs(barEntries) do
						if barVisibility:GetProfileKeyForBar(e.displayBarKey) == kindKey then
							if first then
								if next(kindsPresent) ~= nil then
									chooseMenu:CreateDivider()
								end
								chooseMenu:CreateTitle(presetKindLabels[kindKey])
								kindsPresent[kindKey] = true
								first = false
							end
							local displayBarKey = e.displayBarKey
							chooseMenu:CreateCheckbox(e.label,
								function() return applyTargets[displayBarKey] == true end,
								function()
									if applyTargets[displayBarKey] then
										applyTargets[displayBarKey] = nil
									else
										applyTargets[displayBarKey] = true
									end
								end)
						end
					end
				end

				local copyMenu = rootDescription:CreateButton(L["BarVisibilityApplyCopyFrom"])
				local linkMenu = rootDescription:CreateButton(L["BarVisibilityApplyLinkTo"])
				TRB.Functions.OptionsUi.Primitives:LimitMenuRows(copyMenu, #allBarEntries + #presetKindOrder)
				for _, kindKey in ipairs(presetKindOrder) do
					if kindsPresent[kindKey] then
						local capturedKind = kindKey
						local presets = barVisibility:GetPresetsOrdered(kindKey)
						copyMenu:CreateTitle(presetKindLabels[kindKey])
						linkMenu:CreateTitle(presetKindLabels[kindKey])
						for _, e in ipairs(allBarEntries) do
							if spec.displayBar[e.displayBarKey] ~= nil and barVisibility:GetProfileKeyForBar(e.displayBarKey) == kindKey then
								copyMenu:CreateButton(e.label, function()
									local _, shown = ResolveRow(e)
									ApplyToTargets(shown, capturedKind, nil)
								end)
							end
						end
						for _, preset in ipairs(presets) do
							local presetId = preset.guid
							copyMenu:CreateButton(preset.name or "", function()
								ApplyToTargets(preset, capturedKind, nil)
							end)
							linkMenu:CreateButton(preset.name or "", function()
								ApplyToTargets(preset, capturedKind, presetId)
							end)
						end
						if #presets == 0 then
							linkMenu:CreateTitle(L["BarVisibilityNoPresets"])
						end
					end
				end

				-- Bars that can follow Global Options can go back to it.
				if classId ~= nil then
					rootDescription:CreateDivider()
					rootDescription:CreateButton(UseGlobalMenuText(L["BarVisibilityUseGlobal"]), ApplyUseGlobalToTargets)
				end
			end)
		end)
	end

	-- Table click handler
	if barVisibilityTable ~= nil then
		barVisibilityTable:RegisterEvents({
			OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
				if button == "LeftButton" then
					if realrow ~= nil and realrow > 0 then
						local barKey = data[realrow].cols[1].value

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
	end

	if isPresetHost then
		-- Opens a preset in the detail panel and highlights its row.
		SelectPreset = function(guid)
			SetPresetTableValues()
			for i, preset in ipairs(presetList) do
				if preset.guid == guid then
					presetTable:SetSelection(i)
					break
				end
			end
			FillDetailPanel("preset:" .. guid)
		end

		PromptDeletePreset = function(guid)
			local preset = barVisibility:GetPreset(guid)
			if preset == nil then
				return
			end
			StaticPopup_Show("TwintopResourceBar_VisibilityPresetDelete", nil, nil, {
				message = string.format(L["BarVisibilityPresetDeleteConfirm"], preset.name or "", barVisibility:CountPresetUses(guid)),
				onAccept = function()
					-- Bars using it keep the settings they show now.
					barVisibility:UnlinkPreset(guid)
					barVisibility:GetPresets()[guid] = nil
					if selectedPresetGuid == guid then
						selectedPresetGuid = nil
						presetTable:ClearSelection()
						detailFrame:Hide()
						SyncPresetEditor(nil)
					end
					TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChangeAllSpecs()
				end,
			})
		end

		presetTable:RegisterEvents({
			OnEnter = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				scrollingTable.DefaultEvents.OnEnter(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if realrow ~= nil and realrow > 0 and column == 5 and cellFrame ~= nil and cellFrame.text ~= nil then
					cellFrame.text:SetAlpha(actionCellBrightAlpha)
					GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
					GameTooltip:SetText(L["BarVisibilityPresetDeleteActionTooltip"], 1, 1, 1, 1, true)
					GameTooltip:Show()
				end
			end,
			OnLeave = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				scrollingTable.DefaultEvents.OnLeave(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
				if column == 5 then
					if cellFrame ~= nil and cellFrame.text ~= nil then
						cellFrame.text:SetAlpha(actionCellDimAlpha)
					end
					GameTooltip:Hide()
				end
			end,
			OnClick = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
				if button ~= "LeftButton" or realrow == nil or realrow <= 0 then
					return
				end
				local guid = data[realrow].cols[1].value
				if column == 5 then
					PromptDeletePreset(guid)
					-- The row is on its way out, so the click must not also select it.
					return true
				end
				local currentSelection = scrollingTable:GetSelection()
				FillDetailPanel("preset:" .. guid)
				C_Timer.After(0, function()
					C_Timer.After(0.05, function()
						if scrollingTable:GetSelection() == nil then
							presetTable:SetSelection(currentSelection)
						end
					end)
				end)
			end,
		})

		controls.buttons.addPreset:SetScript("OnClick", function()
			-- A new preset starts as a copy of the main resource bar's look.
			local template = barVisibility:ComposeEntry(coreDisplayBar.primary or {})
			local preset = barVisibility:NewPreset(template, "standard", L["BarVisibilityPresetNewName"])
			SelectPreset(preset.guid)
		end)

		SetPresetTableValues()
	end

	-- Initial table population
	SetTableValues()
	SyncUseGlobalControls()

	-- Re-reads every row after a Use Global change, here or on another tab of this specialization.
	RefreshTableForGlobalToggle = function()
		SyncUseGlobalControls()
		SetTableValues()
		if SetPresetTableValues ~= nil then
			SetPresetTableValues()
			if selectedPresetGuid ~= nil then
				-- The open preset keeps its panel: an edit made in it is what asked for this refresh.
				for i, preset in ipairs(presetList) do
					if preset.guid == selectedPresetGuid then
						presetTable:SetSelection(i)
						return
					end
				end
				detailFrame:Hide()
				selectedPresetGuid = nil
				SyncPresetEditor(nil)
				return
			end
		end
		-- The selected row may have switched between Global Options and its own settings.
		if selectedBarKey ~= nil then
			for i, e in ipairs(barEntries) do
				if e.key == selectedBarKey then
					barVisibilityTable:SetSelection(i)
					FillDetailPanel(selectedBarKey)
					return
				end
			end
			detailFrame:Hide()
			selectedBarKey = nil
		end
	end

	RebuildRows = function()
		RebuildBarEntries()
		ResizeTable()
		SetTableValues()
		SyncUseGlobalControls()
		-- The selected bar keeps its panel while it is still listed.
		barVisibilityTable:ClearSelection()
		if selectedBarKey ~= nil then
			for i, e in ipairs(barEntries) do
				if e.key == selectedBarKey then
					barVisibilityTable:SetSelection(i)
					return
				end
			end
			detailFrame:Hide()
			selectedBarKey = nil
		end
	end

	-- Handle used by the per-bar tab visibility headers: refreshes the table after a header
	-- toggle, and jumps to a bar's row when the header's "Configure Visibility" link is used.
	-- Selection matches on displayBarKey because it diverges from key for custom bars.
	TRB.Functions.OptionsUi.Visibility:RegisterApi(classId, specId, groupKey, {
		Refresh = RefreshTableForGlobalToggle,
		SelectByDisplayBarKey = function(displayBarKey)
			for i, e in ipairs(barEntries) do
				if e.displayBarKey == displayBarKey then
					barVisibilityTable:SetSelection(i)
					FillDetailPanel(e.key)
					return
				end
			end
		end,
		SelectPreset = function(presetId)
			if SelectPreset ~= nil then
				SelectPreset(presetId)
			end
		end,
	})

	-- Keep the table in sync with visibility changes made from the per-bar tab headers.
	parent:HookScript("OnShow", function()
		RefreshTableForGlobalToggle()
	end)

	if isPresetHost then
		yCoord = yCoord - presetsTableHeight - 10 - PRESET_EDITOR_HEIGHT - detailHeight
	else
		-- The spec tab's table can grow to every bar with the include-all box ticked, so the panel leaves room for that.
		yCoord = yCoord - (35 + (GetTableRowCount(groupKey == "spec" and #allBarEntries or #barEntries) * 15)) - 10 - detailHeight
	end

	return yCoord
end

---Builds a shared grouping's Visibility tab: the spec tab's table and detail panel, listing only that grouping's bars.
---@param parent Frame # The tab's scroll child
---@param classId integer? # nil edits core (global) scope
---@param specId integer?
---@param groupKey string # castbar, otherBars, petBars, or skyriding; "presets" builds Global Options' Manage Presets tab
function TRB.Functions.OptionsUi.Visibility:ConstructGroupPanel(parent, classId, specId, groupKey)
	if parent == nil then
		return
	end
	local classNameLower, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId, true)
	local spec
	if classId == nil then
		spec = TRB.Data.settings.core
	else
		spec = TRB.Data.settings[classNameLower] and TRB.Data.settings[classNameLower][specName]
	end
	if spec == nil then
		return
	end

	-- Each grouping's tab gets its own controls: they would otherwise overwrite each other's under one scope.
	local groupControls = { checkBoxes = {}, dropDown = {}, sliders = {}, colors = {}, buttons = {} }

	self:GenerateBarVisibilityOptions(parent, groupControls, spec, classId, specId, 5, nil, nil, false, nil, false, false, {}, {}, { groupKey = groupKey })
end
