local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Functions = TRB.Functions or {}

---@class TRB.Classes.BarVisibilityContext
---@field force boolean # Whether to force-hide all bars (e.g., spec switch or render transition)
---@field specSupported boolean # Whether the current spec is enabled in addon settings
---@field inCombat boolean # Whether the player is currently in combat
---@field inVehicle boolean # Whether the player is currently in a vehicle
---@field inPetBattle boolean # Whether the player is currently in a pet battle
---@field onTaxi boolean # Whether the player is currently on a flight path
---@field isDead boolean # Whether the player is currently dead or a ghost
---@field hasTarget boolean # Whether the player has a target selected
---@field targetIsFriendly boolean # Whether the current target is friendly
---@field targetIsEnemy boolean # Whether the current target is unfriendly
---@field isMountedAny boolean # Whether the player is currently mounted (any mount)
---@field isMountedGround boolean # Whether the player is mounted and on the ground (not flying, any mount type)
---@field isMountedFlying boolean # Whether the player is mounted and in real (non-gliding) flight (Hide-list alias of isSteadyFlight)
---@field isSkyriding boolean # Whether the player is mounted on a skyriding-capable mount in a skyriding-enabled area
---@field isSkyridingFlying boolean # Whether the player is actively skyriding (mounted, canGlide, and flying)
---@field isSteadyFlight boolean # Whether the player is mounted and in real (non-gliding) flight; IsFlying() is false while skyriding-gliding
---@field isSteadyFlightFlying boolean # Whether the player is mounted and in real (non-gliding) flight (same as isSteadyFlight; steady flight only exists while airborne)
---@field inGroup boolean # Whether the player is in a group (party or raid)
---@field inRaid boolean # Whether the player is in a raid group
---@field inInstance boolean # Whether the player is in any instance (dungeon, raid, scenario, arena, battleground)
---@field inDungeon boolean # Whether the player is in a 5-man dungeon instance
---@field inRaidInstance boolean # Whether the player is in a raid instance
---@field inBattleground boolean # Whether the player is in a battleground
---@field inArena boolean # Whether the player is in an arena
---@field inDelve boolean # Whether the player is in a delve (scenario with isDelve flag)
---@field isPvpFlagged boolean # Whether the player is PVP flagged
---@field isWarMode boolean # Whether War Mode is enabled
---@field isDruidHumanoidForm boolean # Whether the Druid player is in humanoid form
---@field isDruidTravelFormAny boolean # Whether the Druid player is in any travel form variant
---@field isDruidStagForm boolean # Whether the Druid player is in stag/ground travel form
---@field isDruidFlightForm boolean # Whether the Druid player is in steady flight form
---@field isDruidSwiftFlightForm boolean # Whether the Druid player is in skyriding flight form
---@field isDruidAquaticForm boolean # Whether the Druid player is in aquatic form
---@field isDruidCatForm boolean # Whether the Druid player is in cat form
---@field isDruidBearForm boolean # Whether the Druid player is in bear form
---@field isDruidMoonkinForm boolean # Whether the Druid player is in moonkin form
TRB.Classes.BarVisibilityContext = {}
TRB.Classes.BarVisibilityContext.__index = TRB.Classes.BarVisibilityContext

---Creates a new BarVisibilityContext with explicit values.
---@param params table # Table of context fields
---@return TRB.Classes.BarVisibilityContext
function TRB.Classes.BarVisibilityContext:New(params)
	local self = setmetatable({}, TRB.Classes.BarVisibilityContext)
	params = params or {}
	self.force = params.force or false
	self.specSupported = params.specSupported or false
	self.inCombat = params.inCombat or false
	self.inVehicle = params.inVehicle or false
	self.inPetBattle = params.inPetBattle or false
	self.onTaxi = params.onTaxi or false
	self.isDead = params.isDead or false
	self.hasTarget = params.hasTarget or false
	self.targetIsFriendly = params.targetIsFriendly or false
	self.targetIsEnemy = params.targetIsEnemy or false
	self.isMountedAny = params.isMountedAny or false
	self.isMountedGround = params.isMountedGround or false
	self.isMountedFlying = params.isMountedFlying or false
	self.isSkyriding = params.isSkyriding or false
	self.isSkyridingFlying = params.isSkyridingFlying or false
	self.isSteadyFlight = params.isSteadyFlight or false
	self.isSteadyFlightFlying = params.isSteadyFlightFlying or false
	self.inGroup = params.inGroup or false
	self.inRaid = params.inRaid or false
	self.inInstance = params.inInstance or false
	self.inDungeon = params.inDungeon or false
	self.inRaidInstance = params.inRaidInstance or false
	self.inBattleground = params.inBattleground or false
	self.inArena = params.inArena or false
	self.inDelve = params.inDelve or false
	self.isPvpFlagged = params.isPvpFlagged or false
	self.isWarMode = params.isWarMode or false
	self.isDruidHumanoidForm = params.isDruidHumanoidForm or false
	self.isDruidTravelFormAny = params.isDruidTravelFormAny or false
	self.isDruidStagForm = params.isDruidStagForm or false
	self.isDruidFlightForm = params.isDruidFlightForm or false
	self.isDruidSwiftFlightForm = params.isDruidSwiftFlightForm or false
	self.isDruidAquaticForm = params.isDruidAquaticForm or false
	self.isDruidCatForm = params.isDruidCatForm or false
	self.isDruidBearForm = params.isDruidBearForm or false
	self.isDruidMoonkinForm = params.isDruidMoonkinForm or false
	return self
end

---Convenience constructor that reads current game state into a context.
---@param force boolean # Force-hide flag from the caller
---@param settings table|nil # The spec's settings table (unused in new system, kept for API compat)
---@return TRB.Classes.BarVisibilityContext
function TRB.Classes.BarVisibilityContext:NewFromGameState(force, settings)
	local hasTarget = UnitExists("target") == true
	local targetIsFriendly = false
	local targetIsEnemy = false
	if hasTarget then
		targetIsFriendly = UnitIsFriend("player", "target") == true
		targetIsEnemy = UnitCanAttack("player", "target") == true
	end

	local isFlying = IsFlying()
	local isGliding = C_PlayerInfo.GetGlidingInfo() or false
	local isMountedAny = TRB.Data.character.isMounted or false
	local canSkyriding = TRB.Data.character.isSkyriding or false
	local isMountedGround = isMountedAny and not isFlying and not isGliding
	local isSkyriding = isMountedAny and canSkyriding
	local isSkyridingFlying = isMountedAny and canSkyriding and isFlying
	local isSteadyFlight = isMountedAny and isFlying
	local isSteadyFlightFlying = isMountedAny and isFlying
	local isMountedFlying = isSteadyFlight
	local onTaxi = TRB.Data.character.onTaxi
	if onTaxi == nil then
		onTaxi = UnitOnTaxi("player") or false
	end

	local isDead = UnitIsDeadOrGhost("player") or false

	local isDruid = TRB.Data.character.classId == 11
	local druidForm = nil
	if isDruid then
		druidForm = TRB.Data.character.currentShapeshiftForm or "humanoid"
	end
	local isDruidTravelFormAny = druidForm == "travel" or druidForm == "aquatic" or druidForm == "flight" or druidForm == "swiftFlight"

	-- Instance type: cached on ZONE_CHANGED_NEW_AREA
	local instanceType = TRB.Data.character.instanceType or "none"
	local inDungeon = (instanceType == "party")
	local inRaidInstance = (instanceType == "raid")
	local inBattleground = (instanceType == "pvp")
	local inArena = (instanceType == "arena")
	local inInstance = (inDungeon or inRaidInstance or inBattleground or inArena or instanceType == "scenario")

	-- Delves are scenarios with the isDelve flag set in ScenarioInfo
	local inDelve = false
	if instanceType == "scenario" then
		local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()
		if scenarioInfo and scenarioInfo.type == 8 then
			inDelve = true
		end
	end

	return TRB.Classes.BarVisibilityContext:New({
		force = force or false,
		specSupported = TRB.Data.specSupported or false,
		inCombat = TRB.Data.character.inCombat or false,
		inVehicle = TRB.Data.character.inVehicle or false,
		inPetBattle = TRB.Data.character.inPetBattle or false,
		onTaxi = onTaxi or false,
		isDead = isDead or false,
		hasTarget = hasTarget,
		targetIsFriendly = targetIsFriendly,
		targetIsEnemy = targetIsEnemy,
		isMountedAny = isMountedAny,
		isMountedGround = isMountedGround,
		isMountedFlying = isMountedFlying,
		isSkyriding = isSkyriding,
		isSkyridingFlying = isSkyridingFlying,
		isSteadyFlight = isSteadyFlight,
		isSteadyFlightFlying = isSteadyFlightFlying,
		inGroup = IsInGroup() or false,
		inRaid = IsInRaid() or false,
		inInstance = inInstance,
		inDungeon = inDungeon,
		inRaidInstance = inRaidInstance,
		inBattleground = inBattleground,
		inArena = inArena,
		inDelve = inDelve,
		isPvpFlagged = UnitIsPVP("player") or false,
		isWarMode = C_PvP.IsWarModeDesired() or false,
		isDruidHumanoidForm = druidForm == "humanoid",
		isDruidTravelFormAny = isDruidTravelFormAny,
		isDruidStagForm = druidForm == "travel",
		isDruidFlightForm = druidForm == "flight",
		isDruidSwiftFlightForm = druidForm == "swiftFlight",
		isDruidAquaticForm = druidForm == "aquatic",
		isDruidCatForm = druidForm == "cat",
		isDruidBearForm = druidForm == "bear",
		isDruidMoonkinForm = druidForm == "moonkin",
	})
end

---@class TRB.Classes.BarVisibilityEntry
---@field barGroup TRB.Classes.BarGroup|nil # The BarGroup to show/hide (nil = skip)
---@field visibilitySettings trbBarVisibilitySetting|nil # The displayBar sub-table for this bar (must have .neverShow and .conditions), or nil to force-hide
---@field enabled boolean # Class-level precondition (false = always hide regardless of settings)
---@field showNodesCount number|nil # If set, calls :ShowNodes(n) when showing the bar
---@field setMaxNodes number|nil # If set, calls :SetMaxNodes(n) before showing the bar
---@field boolShowCached boolean|nil # Cached result of ShouldShowBar from last dirty evaluation; used by Phase 3 to skip curve when boolean conditions already satisfied
---@field forceHideCached boolean|nil # Cached result of hard-hide/force/unsupported evaluation from last dirty evaluation
---@field thresholdEligibleCached boolean|nil # Cached threshold eligibility from last dirty evaluation; false when force/neverShow/unsupported prevent curve evaluation
TRB.Classes.BarVisibilityEntry = {}
TRB.Classes.BarVisibilityEntry.__index = TRB.Classes.BarVisibilityEntry

---Creates a new BarVisibilityEntry.
---@param barGroup TRB.Classes.BarGroup|nil # The bar group to control
---@param visibilitySettings trbBarVisibilitySetting|nil # The displayBar.<key> settings sub-table (must have .neverShow and .conditions), or nil
---@param enabled boolean # Whether this bar is active for the current spec/state
---@param showNodesCount number|nil # Node count to pass to :ShowNodes() when visible
---@param setMaxNodes number|nil # If set, calls :SetMaxNodes() before Show
---@return TRB.Classes.BarVisibilityEntry
function TRB.Classes.BarVisibilityEntry:New(barGroup, visibilitySettings, enabled, showNodesCount, setMaxNodes)
	local self = setmetatable({}, TRB.Classes.BarVisibilityEntry)
	self.barGroup = barGroup
	self.visibilitySettings = visibilitySettings
	self.enabled = enabled
	self.showNodesCount = showNodesCount
	self.setMaxNodes = setMaxNodes
	return self
end

---@class TRB.Functions.BarVisibility
TRB.Functions.BarVisibility = {}

-- Dirty-flag cache: visibility results are deterministic for a given set of inputs.
-- We skip re-evaluation unless an input has changed (MarkDirty was called).
TRB.Functions.BarVisibility.dirtyToken = 0
TRB.Functions.BarVisibility.lastAppliedToken = -1
-- When true, at least one bar is mid-fade and needs per-tick interpolation.
TRB.Functions.BarVisibility.fading = false
-- When true, at least one bar has a resource/health threshold curve active.
-- Character.lua checks this to MarkDirty on resource/health changes.
TRB.Functions.BarVisibility.hasResourceCurve = false

local DRUID_FORM_VISIBILITY_KEYS = {
	"isDruidHumanoidForm",
	"isDruidTravelFormAny",
	"isDruidStagForm",
	"isDruidFlightForm",
	"isDruidSwiftFlightForm",
	"isDruidAquaticForm",
	"isDruidCatForm",
	"isDruidBearForm",
	"isDruidMoonkinForm",
}

local function HasMatchingDruidFormCondition(conditions, context)
	for _, key in ipairs(DRUID_FORM_VISIBILITY_KEYS) do
		if conditions[key] == true and context[key] == true then
			return true
		end
	end
	return false
end

---Marks visibility state as dirty, forcing the next ProcessBars call to re-evaluate.
---Call this whenever any input to visibility evaluation changes:
---  inCombat, inVehicle, inPetBattle, onTaxi, specSupported,
---  isMountedAny, isMountedGround, isMountedFlying, isSkyriding, isSkyridingFlying, isSteadyFlight, isSteadyFlightFlying, hasTarget, inGroup, inRaid,
---  inInstance, inDungeon, inRaidInstance, inBattleground, inArena, isPvpFlagged, isWarMode,
---  Druid shapeshift form,
---  per-bar visibility settings, talent gates, maxResource2.
function TRB.Functions.BarVisibility:MarkDirty()
	self.dirtyToken = self.dirtyToken + 1
end

---Returns true if a re-evaluation is needed (inputs have changed since last ProcessBars).
---@param force boolean|nil # If true, always returns true (bypasses cache)
---@return boolean
function TRB.Functions.BarVisibility:IsDirty(force)
	if force then
		return true
	end
	if self.fading then
		return true
	end
	return self.dirtyToken ~= self.lastAppliedToken
end

---Marks the cache as up-to-date after a successful ProcessBars evaluation.
function TRB.Functions.BarVisibility:MarkClean()
	self.lastAppliedToken = self.dirtyToken
end

---Discards the applied show/alpha state of every bar group so the next ProcessBars pass
---rebuilds it from scratch, then marks visibility dirty.
---
---ProcessBars memoizes what it has already applied: it only calls Show()/ShowNodes() on a
---hidden→visible transition, SetTargetAlpha() no-ops when the target is unchanged, and frame
---alpha is only written while a bar is showing. Layout passes mutate that same state
---independently (ApplyBarGroupsLayout shows the primary group and its node directly, and
---ConstructAnchoredBarGroup shows or hides anchored/custom groups plus their nodes). After a
---bar flips off and back on, those two views disagree: the group reads as already visible, so
---Phase 3 skips ShowNodes() even though the hide pass called HideAllNodes(), leaving a bar that
---occupies its layout space but draws nothing until an unrelated event marks visibility dirty.
---
---Hide() is used rather than clearing isVisible directly so the flag and the frame stay in
---agreement -- if ProcessBars then resolves the bar as hidden, it simply stays hidden.
function TRB.Functions.BarVisibility:InvalidateAppliedState()
	local barGroups = TRB.Frames.barGroups
	if barGroups ~= nil then
		for key, group in pairs(barGroups) do
			-- The cast bars, the GCD bar and the mirror timers render themselves from live state and are
			-- not ProcessBars entries, so nothing would ever show them again if they were torn down here.
			local isSelfDriven = TRB.Classes.BarTypeRegistry:IsSelfDriven(key)
			if not isSelfDriven and type(group) == "table" and group.Hide ~= nil and group.containerFrame ~= nil then
				group:Hide()
				-- Defeats SetTargetAlpha's no-op guard so Phase 3 re-applies frame alpha.
				group.targetAlpha = -1
			end
		end
	end

	self:MarkDirty()
end

---Evaluates whether a bar has any configured hard-hide condition active.
---@param context TRB.Classes.BarVisibilityContext # The shared environment snapshot
---@param entry TRB.Classes.BarVisibilityEntry # The bar entry to evaluate
---@return boolean # true if a hard-hide condition is currently active
function TRB.Functions.BarVisibility:ShouldForceHideBar(context, entry)
	if entry.visibilitySettings == nil then
		return false
	end

	local conditions = entry.visibilitySettings.hideConditions
	if conditions == nil then
		return false
	end

	if conditions.isMountedAny == true and context.isMountedAny then
		return true
	end
	if conditions.isMountedGround == true and context.isMountedGround then
		return true
	end
	if conditions.isMountedFlying == true and context.isMountedFlying then
		return true
	end
	if conditions.isSkyriding == true and context.isSkyriding then
		return true
	end
	if conditions.isSkyridingFlying == true and context.isSkyridingFlying then
		return true
	end
	if conditions.isSteadyFlightFlying == true and context.isSteadyFlightFlying then
		return true
	end
	if conditions.inVehicle == true and context.inVehicle then
		return true
	end
	if conditions.inPetBattle == true and context.inPetBattle then
		return true
	end
	if conditions.onTaxi == true and context.onTaxi then
		return true
	end
	if conditions.isDead == true and context.isDead then
		return true
	end
	if HasMatchingDruidFormCondition(conditions, context) then
		return true
	end

	return false
end

---Evaluates whether a single bar should be shown. Pure function, no side effects.
---@param context TRB.Classes.BarVisibilityContext # The shared environment snapshot
---@param entry TRB.Classes.BarVisibilityEntry # The bar entry to evaluate
---@return boolean # true if the bar should be shown, false if it should be hidden
function TRB.Functions.BarVisibility:ShouldShowBar(context, entry)
	-- No bar group or disabled by class-level precondition
	if entry.barGroup == nil or not entry.enabled then
		return false
	end

	-- No visibility settings available (no settings loaded yet)
	if entry.visibilitySettings == nil then
		return false
	end

	-- Global force-hide conditions
	if context.force or not context.specSupported then
		return false
	end

	-- "Never Show" override
	if entry.visibilitySettings.neverShow then
		return false
	end

	-- Per-bar hard-hide conditions override Always Show and threshold visibility.
	if self:ShouldForceHideBar(context, entry) then
		return false
	end

	-- "Always Show" override
	if entry.visibilitySettings.alwaysShow then
		return true
	end

	-- Evaluate conditions (OR logic)
	local conditions = entry.visibilitySettings.conditions

	-- Legacy support: if no conditions table exists but visibility string does, use old logic
	if conditions == nil then
		local visibility = entry.visibilitySettings.visibility
		if visibility == "always" then
			return true
		elseif visibility == "combat" then
			return context.inCombat or context.inVehicle
		end
		return false
	end

	-- OR-evaluate: if ANY enabled condition matches the current context, show the bar
	if conditions.inCombat and context.inCombat then
		return true
	end
	if conditions.inVehicle and context.inVehicle then
		return true
	end
	if conditions.hasFriendlyTarget and context.hasTarget and context.targetIsFriendly then
		return true
	end
	if conditions.hasUnfriendlyTarget and context.hasTarget and context.targetIsEnemy then
		return true
	end
	if conditions.isMountedAny and context.isMountedAny then
		return true
	end
	if conditions.isMountedGround and context.isMountedGround then
		return true
	end
	if conditions.isSkyriding and context.isSkyriding then
		return true
	end
	if conditions.isSkyridingFlying and context.isSkyridingFlying then
		return true
	end
	if conditions.isSteadyFlight and context.isSteadyFlight then
		return true
	end
	if conditions.isSteadyFlightFlying and context.isSteadyFlightFlying then
		return true
	end
	if conditions.inGroup and context.inGroup then
		return true
	end
	if conditions.inRaid and context.inRaid then
		return true
	end
	if conditions.inInstance and context.inInstance then
		return true
	end
	if conditions.inDungeon and context.inDungeon then
		return true
	end
	if conditions.inRaidInstance and context.inRaidInstance then
		return true
	end
	if conditions.inBattleground and context.inBattleground then
		return true
	end
	if conditions.inArena and context.inArena then
		return true
	end
	if conditions.inDelve and context.inDelve then
		return true
	end
	if conditions.isPvpFlagged and context.isPvpFlagged then
		return true
	end
	if conditions.isWarMode and context.isWarMode then
		return true
	end
	if HasMatchingDruidFormCondition(conditions, context) then
		return true
	end

	-- No boolean conditions matched — return false.
	-- ProcessBars handles the OR with resource/health threshold independently.
	return false
end

-- Visibility alpha curve cache: keyed by all inputs so curves are reused when settings
-- haven't changed.  Uses the shared stepColorCurves cache in TRB.Data.cache.
TRB.Data.cache = TRB.Data.cache or {}
TRB.Data.cache.stepColorCurves = TRB.Data.cache.stepColorCurves or {}

local VISIBILITY_HEALTH_MAX = 1000000
local VISIBILITY_MANA_MAX = 275625 -- 250k base, enchant or Gnome * 1.05, both is another * 1.05

---@param conditionType string
---@param settings table|nil
---@return table|nil
function TRB.Functions.BarVisibility:GetVisibilityThresholdDefinition(conditionType, settings)
	if settings ~= nil and settings.barVisibilityThresholds ~= nil then
		return settings.barVisibilityThresholds[conditionType]
	end
	return nil
end

---Gets the normalization max value for visibility threshold comparisons.
---For primary resource value thresholds, use the spec's configured max value from the
---associated options/default settings rather than the live character max.
---@param conditionType string
---@param settings table|nil
---@return number
function TRB.Functions.BarVisibility:GetVisibilityThresholdMaxValue(conditionType, settings)
	local thresholdDefinition = self:GetVisibilityThresholdDefinition(conditionType, settings)
	if thresholdDefinition ~= nil and type(thresholdDefinition.maxValue) == "number" then
		return thresholdDefinition.maxValue
	end

	if conditionType == "healthValue" then
		return VISIBILITY_HEALTH_MAX
	end

	if conditionType == "resourceValue" then
		if TRB.Data.resource == Enum.PowerType.Mana then
			return VISIBILITY_MANA_MAX
		end

		local specCache = nil
		if TRB.Data.specCache ~= nil and TRB.Data.character ~= nil then
			if TRB.Data.character.compositeKey ~= nil then
				specCache = TRB.Data.specCache[TRB.Data.character.compositeKey]
			end
			if specCache == nil and TRB.Data.character.specName ~= nil then
				specCache = TRB.Data.specCache[TRB.Data.character.specName]
			end
		end

		local maxResourceSettings = settings and settings.maxResource
		if maxResourceSettings == nil and specCache ~= nil and specCache.settings ~= nil then
			maxResourceSettings = specCache.settings.maxResource
		end

		if maxResourceSettings ~= nil then
			local value = maxResourceSettings.value
			if type(value) == "number" and value > 0 then
				return value
			end
		end

		local maxRes = TRB.Data.character and TRB.Data.character.maxResourceUnmodified or 100
		if maxRes <= 0 then
			maxRes = 100
		end
		return maxRes
	end

	return 100
end

---Builds (or retrieves from cache) a Step ColorCurve whose alpha channel encodes
---visibility: activeAlpha on one side of the threshold, inactiveAlpha on the other.
---RGB is always (1,1,1) — only the alpha channel matters.
---
---For ">=" the curve is: [0, inactive) → [threshold, active) → [2.0, active)
---For "<=" the curve is: [0, active) → [threshold+ε, inactive) → [2.0, inactive)
---
---@param conditionType string # "resourcePercent"|"resourceValue"|"healthPercent"|"healthValue" or a spec-defined threshold type
---@param operator string # ">=" or "<="
---@param thresholdValue number # The user-configured threshold (0–100 for percent, raw for value)
---@param activeAlpha number # 0–100 alpha when condition is met
---@param inactiveAlpha number # 0–100 alpha when condition is not met
---@param settings table|nil # Spec settings used to resolve spec-defined threshold types
---@return any # A C_CurveUtil color curve
function TRB.Functions.BarVisibility:BuildVisibilityAlphaCurve(conditionType, operator, thresholdValue, activeAlpha, inactiveAlpha, settings)
	local cache = TRB.Data.cache.stepColorCurves
	local thresholdDefinition = self:GetVisibilityThresholdDefinition(conditionType, settings)

	-- Compute threshold as a fraction of 0.0–1.0 (the scale UnitPowerPercent/UnitHealthPercent use)
	local thresholdFraction
	if thresholdDefinition ~= nil and thresholdDefinition.valueType == "percent" then
		thresholdFraction = (thresholdValue or 0) / 100
	elseif thresholdDefinition ~= nil and thresholdDefinition.valueType == "value" then
		local maxValue = self:GetVisibilityThresholdMaxValue(conditionType, settings)
		if maxValue <= 0 then maxValue = 100 end
		thresholdFraction = (thresholdValue or 0) / maxValue
	elseif conditionType == "resourcePercent" then
		thresholdFraction = (thresholdValue or 0) / 100
	elseif conditionType == "resourceValue" then
		local maxRes = self:GetVisibilityThresholdMaxValue(conditionType, settings)
		if maxRes <= 0 then maxRes = 100 end
		thresholdFraction = (thresholdValue or 0) / maxRes
	elseif conditionType == "healthPercent" then
		thresholdFraction = (thresholdValue or 0) / 100
	elseif conditionType == "healthValue" then
		local maxHP = self:GetVisibilityThresholdMaxValue(conditionType, settings)
		if maxHP <= 0 then maxHP = 1 end
		thresholdFraction = (thresholdValue or 0) / maxHP
	else
		thresholdFraction = 0
	end

	-- Clamp
	if thresholdFraction < 0 then thresholdFraction = 0 end

	-- Normalize alphas to 0.0–1.0
	local activeA = (activeAlpha or 100) / 100
	local inactiveA = (inactiveAlpha or 0) / 100

	-- Build a cache key from all inputs
	local fullKey = "vis_" .. conditionType .. "_" .. operator .. "_" .. tostring(thresholdFraction) .. "_" .. tostring(activeA) .. "_" .. tostring(inactiveA)

	if cache[fullKey] == nil then
		local curve = C_CurveUtil.CreateColorCurve()
		curve:SetType(Enum.LuaCurveType.Step)

		if operator == "<=" then
			-- Active when BELOW threshold: [0, active) → [threshold+ε, inactive) → [2.0, inactive)
			local activeColor = CreateColor(1, 1, 1, activeA)
			local inactiveColor = CreateColor(1, 1, 1, inactiveA)
			curve:AddPoint(0, activeColor)
			curve:AddPoint(thresholdFraction + 0.001, inactiveColor)
			curve:AddPoint(2.0, inactiveColor)
		else
			-- ">=" (default): Active when AT or ABOVE threshold: [0, inactive) → [threshold, active) → [2.0, active)
			local activeColor = CreateColor(1, 1, 1, activeA)
			local inactiveColor = CreateColor(1, 1, 1, inactiveA)
			curve:AddPoint(0, inactiveColor)
			curve:AddPoint(thresholdFraction, activeColor)
			curve:AddPoint(2.0, activeColor)
		end

		cache[fullKey] = curve
	end

	return cache[fullKey]
end

---Evaluates the visibility alpha curve for an entry's resource/health condition.
---Passes the curve to UnitPowerPercent or UnitHealthPercent, which returns a secret
---ColorMixin.  The alpha channel of that color encodes the visibility decision.
---@param visSettings trbBarVisibilitySetting # The bar's visibility settings
---@param settings table|nil # Spec settings used to resolve spec-defined threshold types
---@return any|nil # A secret ColorMixin with alpha encoding visibility, or nil if not applicable
function TRB.Functions.BarVisibility:EvaluateVisibilityCurve(visSettings, settings)
	local conditionType = visSettings.resourceConditionType
	local operator = visSettings.resourceConditionOperator or ">="
	local threshold = visSettings.resourceConditionValue or 0
	local activeAlpha = visSettings.activeAlpha or 100
	local inactiveAlpha = visSettings.inactiveAlpha or 0
	local thresholdDefinition = self:GetVisibilityThresholdDefinition(conditionType, settings)

	local curve = self:BuildVisibilityAlphaCurve(conditionType, operator, threshold, activeAlpha, inactiveAlpha, settings)

	if thresholdDefinition ~= nil and thresholdDefinition.powerType ~= nil then
		return UnitPowerPercent("player", thresholdDefinition.powerType, true, curve)
	elseif conditionType == "resourcePercent" or conditionType == "resourceValue" then
		return UnitPowerPercent("player", TRB.Data.resource, true, curve)
	elseif conditionType == "healthPercent" or conditionType == "healthValue" then
		return UnitHealthPercent("player", true, curve)
	end
	return nil
end

---Evaluates and applies visibility for all bar entries. Sets isTracking and controls BarText.
---Uses alpha-based visibility with fade interpolation instead of binary Show/Hide.
---For entries with a resource/health threshold curve, the secret alpha from the curve
---is applied directly to the container frame (secret-safe via SetAlpha), identical in
---spirit to overcap color handling. Lua never compares the secret value.
---@param context TRB.Classes.BarVisibilityContext # The shared environment snapshot
---@param entries TRB.Classes.BarVisibilityEntry[] # Array of bar entries to process
---@param snapshotData TRB.Classes.SnapshotData # The snapshot data to update isTracking on
---@param settings table|nil # The spec settings, passed to BarText:Show/Hide
---@return boolean # Whether any bar is showing (isTracking value)
function TRB.Functions.BarVisibility:ProcessBars(context, entries, snapshotData, settings)
	local anyShowing = false
	local anyFading = false
	local anyEntryHasCurve = false
	local conditionsChanged = (self.dirtyToken ~= self.lastAppliedToken) or context.force
	local isRenderTransition = TRB.Functions.Bar:IsRenderTransitionActive()

	for _, entry in ipairs(entries) do
		if entry.barGroup ~= nil then
			local visSettings = entry.visibilitySettings
			local hasCurve = visSettings ~= nil
				and visSettings.resourceConditionType ~= nil
				and visSettings.resourceConditionType ~= "none"
			if hasCurve then
				anyEntryHasCurve = true
			end

			-- Phase 1: Evaluate conditions and compute target alpha (only when dirty)
			if conditionsChanged then
				local boolShow = self:ShouldShowBar(context, entry)
				local forceHide = context.force
					or not context.specSupported
					or not entry.enabled
					or visSettings == nil
					or (visSettings and visSettings.neverShow == true)
					or self:ShouldForceHideBar(context, entry)
				-- Cache boolShow and thresholdEligible so Phase 3 can:
				--  (a) skip the curve when boolean conditions already satisfy the OR,
				--  (b) skip the curve when force/neverShow/unsupported make it ineligible.
				entry.boolShowCached = boolShow
				entry.forceHideCached = forceHide
				local thresholdEligible = entry.enabled
					and visSettings ~= nil
					and not forceHide
				entry.thresholdEligibleCached = thresholdEligible
				local targetAlpha, fadeDuration
				local fadeDelay = 0

				if forceHide then
					targetAlpha = 0
					fadeDuration = 0
					fadeDelay = 0
				elseif hasCurve and boolShow then
					-- Boolean conditions already satisfied (OR short-circuit).
					-- Show at active alpha; the curve is not needed this tick.
					targetAlpha = (visSettings and visSettings.activeAlpha or 100) / 100
					fadeDuration = 0
				elseif hasCurve then
					-- Boolean conditions did not match. The curve decides visibility.
					-- Keep the bar renderable at active alpha so the curve can supply
					-- the final opacity in Phase 3 (identical pattern to overcap colors).
					if thresholdEligible then
						targetAlpha = (visSettings and visSettings.activeAlpha or 100) / 100
						fadeDuration = 0
					else
						targetAlpha = (visSettings and visSettings.inactiveAlpha or 0) / 100
						fadeDuration = visSettings and visSettings.fadeDuration or 0
						fadeDelay = visSettings and visSettings.fadeDelay or 0
					end
				elseif boolShow then
					targetAlpha = (visSettings and visSettings.activeAlpha or 100) / 100
					fadeDuration = 0
				else
					targetAlpha = (visSettings and visSettings.inactiveAlpha or 0) / 100
					fadeDuration = visSettings and visSettings.fadeDuration or 0
					fadeDelay = visSettings and visSettings.fadeDelay or 0
				end

				-- During render transitions, snap to 0 instantly (no fade)
				if isRenderTransition then
					targetAlpha = 0
					fadeDuration = 0
					fadeDelay = 0
				end

				entry.barGroup:SetTargetAlpha(targetAlpha, fadeDuration, fadeDelay)
			end

			-- Phase 2: Interpolate fade (runs every tick while fading)
			local currentAlpha, stillFading = entry.barGroup:UpdateFade()
			if stillFading then
				anyFading = true
			end

			-- Phase 3: Apply alpha, show/hide, and apply secret curve alpha if applicable
			if currentAlpha > 0 then
				anyShowing = true
				if not entry.barGroup.isVisible then
					if entry.setMaxNodes then
						entry.barGroup:SetMaxNodes(entry.setMaxNodes)
					end
					entry.barGroup:Show()
					if entry.showNodesCount then
						entry.barGroup:ShowNodes(entry.showNodesCount)
					end
				end

				-- If a curve is active, boolean conditions didn't already satisfy
				-- the OR, AND the entry is eligible (not force-hidden/neverShow/
				-- unsupported), evaluate the curve and apply the secret alpha.
				-- Otherwise fall through to the normal fade alpha.
				if hasCurve and not entry.boolShowCached and entry.thresholdEligibleCached then
					local curveResult = self:EvaluateVisibilityCurve(visSettings, settings)
					if curveResult ~= nil and type(curveResult.GetRGBA) == "function" then
						local _, _, _, secretAlpha = curveResult:GetRGBA()
						entry.barGroup.containerFrame:SetAlpha(secretAlpha)
					else
						entry.barGroup.containerFrame:SetAlpha(currentAlpha)
					end
				else
					entry.barGroup.containerFrame:SetAlpha(currentAlpha)
				end
			else
				if entry.barGroup.isVisible then
					entry.barGroup:Hide()
				end
			end
		end
	end

	self.fading = anyFading
	self.hasResourceCurve = anyEntryHasCurve

	-- Collapse/expand container frames based on resolved visibility.
	-- Visible bars are expanded back to their layout height.
	-- Hidden bars fall into two categories:
	--   1. Permanently hidden (neverShow, disabled by class precondition, or no settings):
	--      collapsed to 0.001 so children anchored through them slide together (no gap).
	--   2. Dynamically hidden (conditions like "in combat" not met, but bar is eligible):
	--      maintain layoutHeight as an invisible positioning scaffold so that bars
	--      anchored through them stay in place and don't shift when visibility toggles.
	for _, entry in ipairs(entries) do
		if entry.barGroup ~= nil and entry.barGroup.containerFrame then
			if entry.barGroup.currentAlpha > 0 then
				if entry.barGroup.layoutHeight and entry.barGroup.layoutHeight > 0 then
					entry.barGroup.containerFrame:SetHeight(entry.barGroup.layoutHeight)
				end
				if entry.barGroup.layoutWidth and entry.barGroup.layoutWidth > 0 then
					entry.barGroup.containerFrame:SetWidth(entry.barGroup.layoutWidth)
				end
			else
				-- Determine if this bar is permanently hidden (collapse) or
				-- dynamically hidden (maintain height as invisible scaffold).
				local isPermanentlyHidden = not entry.enabled
					or entry.visibilitySettings == nil
					or entry.visibilitySettings.neverShow == true
					or entry.forceHideCached == true
				if isPermanentlyHidden then
					entry.barGroup.containerFrame:SetHeight(0.001)
					entry.barGroup.containerFrame:SetWidth(0.001)
				else
					-- Dynamically hidden: keep layout dimensions so anchored bars don't shift
					if entry.barGroup.layoutHeight and entry.barGroup.layoutHeight > 0 then
						entry.barGroup.containerFrame:SetHeight(entry.barGroup.layoutHeight)
					end
					if entry.barGroup.layoutWidth and entry.barGroup.layoutWidth > 0 then
						entry.barGroup.containerFrame:SetWidth(entry.barGroup.layoutWidth)
					end
				end
			end
		end
	end

	-- The castbar isn't a ProcessBars entry (it manages its own visibility), but its anchored bar text
	-- must keep updating through the shared render path while a cast is active — even when every other
	-- bar is hidden or we're out of combat. Count it as "showing" so isTracking stays true (which is
	-- what keeps each class's UpdateResourceBar calling UpdateResourceBarText) and BarText:Show runs.
	if not anyShowing and TRB.Data.castbar ~= nil and TRB.Data.castbar:IsActive() then
		anyShowing = true
	end
	-- Same for the target/focus cast bars: keep isTracking true while either is active so their
	-- anchored bar text keeps ticking through the shared render path.
	if not anyShowing and ((TRB.Data.targetCastbar ~= nil and TRB.Data.targetCastbar:IsActive())
		or (TRB.Data.focusCastbar ~= nil and TRB.Data.focusCastbar:IsActive())) then
		anyShowing = true
	end
	-- And for the Other Bars timers. This one matters most: Fatigue and Breath run out of combat, which
	-- is exactly when every other bar is hidden and isTracking would otherwise be false -- taking their
	-- anchored bar text down with it.
	if not anyShowing and TRB.Functions.OtherBars:HasActiveTimer() then
		anyShowing = true
	end

	-- Kick the castbar's idle display (Always Show / non-zero inactive alpha) when no cast is active:
	-- its self-driven updater stops while idle-hidden, so this is what restarts it after settings
	-- changes, spec swaps, or reconstructions.
	TRB.Functions.Castbar:EnsureIdleState()

	-- Detect hidden→visible transition: when the bar was not tracking but is now
	-- showing, fully invalidate the lookup memoization cache so that every
	-- variable is recomputed on the next RefreshLookupData pass.
	local wasTracking = snapshotData.attributes.isTracking
	snapshotData.attributes.isTracking = anyShowing
	if anyShowing and not wasTracking then
		TRB.Functions.BarText:InvalidateLookupMemoization()
		TRB.Data.barTextVisibilityRefreshNeeded = true
	end

	if anyShowing and settings ~= nil then
		TRB.Functions.BarText:Show(settings)
	else
		TRB.Functions.BarText:Hide(settings)
	end

	if conditionsChanged then
		self:MarkClean()
	end
	return anyShowing
end

---Hides all bars in the entries list unconditionally. Used for fallback paths (no settings, unsupported spec).
---@param entries TRB.Classes.BarVisibilityEntry[]|nil # Array of bar entries, or nil
---@param snapshotData TRB.Classes.SnapshotData # The snapshot data to update
---@param settings table|nil # Settings to pass to BarText:Hide, may be nil
function TRB.Functions.BarVisibility:HideAllEntries(entries, snapshotData, settings)
	if entries then
		for _, entry in ipairs(entries) do
			if entry.barGroup ~= nil then
				entry.barGroup.targetAlpha = 0
				entry.barGroup.currentAlpha = 0
				entry.barGroup:Hide()
				-- Collapse container so anchored children slide together
				if entry.barGroup.containerFrame then
					entry.barGroup.containerFrame:SetHeight(0.001)
					entry.barGroup.containerFrame:SetWidth(0.001)
				end
			end
		end
	end

	self.fading = false
	snapshotData.attributes.isTracking = false
	if settings ~= nil then
		TRB.Functions.BarText:Hide(settings)
	end

	self:MarkClean()
end

---Hides all bar groups in TRB.Frames.barGroups unconditionally. Used when no entries are available.
---@param snapshotData TRB.Classes.SnapshotData # The snapshot data to update
function TRB.Functions.BarVisibility:HideAllBarGroups(snapshotData)
	local barGroups = TRB.Frames.barGroups
	if barGroups then
		for _, group in pairs(barGroups) do
			if type(group) == "table" and group.Hide then
				group.targetAlpha = 0
				group.currentAlpha = 0
				group:Hide()
			end
		end
	end
	self.fading = false
	snapshotData.attributes.isTracking = false

	self:MarkClean()
end

---Convenience: Builds entries from barGroups for Edit Mode display.
---Every bar previews at full size so it can be repositioned, except bars set to "Never Show",
---which get a collapsing entry so they don't render in Edit Mode.
---@param barGroups table # TRB.Frames.barGroups
---@param displayBar table|nil # The displayBar settings table (used to resolve per-bar Never Show)
---@param maxResource2 number|nil # Max secondary resource count (for ShowNodes)
---@return TRB.Classes.BarVisibilityEntry[]
function TRB.Functions.BarVisibility:BuildEditModeEntries(barGroups, displayBar, maxResource2)
	local entries = {}
	local alwaysVis = { neverShow = false, alwaysShow = true, conditions = {}, hideConditions = {} }
	local neverVis = { neverShow = true, alwaysShow = false, conditions = {}, hideConditions = {} }

	-- In Edit Mode a bar previews at full size unless it is set to "Never Show", in which case
	-- it gets a collapsing entry (ProcessBars shrinks its container to 0.001) so it doesn't render.
	local visSource = displayBar and { displayBar = displayBar } or nil
	local function visFor(barKey)
		if TRB.Functions.Bar:IsBarNeverShow(visSource, barKey) then
			return neverVis
		end
		return alwaysVis
	end

	-- Primary
	if barGroups.primary then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.primary,
			visFor("primary"),
			true,
			nil,
			nil
		)
	end

	-- Secondary: only when nodes exist
	if barGroups.secondary and (maxResource2 or 0) > 0 then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.secondary,
			visFor("secondary"),
			true,
			maxResource2,
			nil
		)
	end

	-- Health
	if barGroups.health then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.health,
			visFor("health"),
			true,
			1,
			nil
		)
	end

	-- Utility
	if barGroups.utility then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.utility,
			visFor("utility"),
			true,
			1,
			nil
		)
	end

	-- Iterate remaining bar groups (custom bar types: mana, stagger, defensives, cast bars, etc.)
	for key, group in pairs(barGroups) do
		if type(group) == "table" and group.Hide and key ~= "primary" and key ~= "secondary" and key ~= "health" and key ~= "utility" then
			local nodeCount = group.maxNodes or 1
			entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
				group,
				visFor(key),
				true,
				nodeCount,
				nil
			)
		end
	end

	return entries
end
