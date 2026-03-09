local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Functions = TRB.Functions or {}

---@class TRB.Classes.BarVisibilityContext
---@field force boolean # Whether to force-hide all bars (e.g., spec switch, pet battle)
---@field specSupported boolean # Whether the current spec is enabled in addon settings
---@field inCombat boolean # Whether the player is currently in combat
---@field inVehicle boolean # Whether the player is currently in a vehicle
---@field hasTarget boolean # Whether the player has a target selected
---@field targetIsFriendly boolean # Whether the current target is friendly
---@field targetIsEnemy boolean # Whether the current target is unfriendly
---@field isMounted boolean # Whether the player is currently mounted
TRB.Classes.BarVisibilityContext = {}
TRB.Classes.BarVisibilityContext.__index = TRB.Classes.BarVisibilityContext

---Creates a new BarVisibilityContext with explicit values.
---@param force boolean
---@param specSupported boolean
---@param inCombat boolean
---@param inVehicle boolean
---@param hasTarget boolean
---@param targetIsFriendly boolean
---@param targetIsEnemy boolean
---@param isMounted boolean
---@return TRB.Classes.BarVisibilityContext
function TRB.Classes.BarVisibilityContext:New(force, specSupported, inCombat, inVehicle, hasTarget, targetIsFriendly, targetIsEnemy, isMounted)
	local self = setmetatable({}, TRB.Classes.BarVisibilityContext)
	self.force = force or false
	self.specSupported = specSupported
	self.inCombat = inCombat or false
	self.inVehicle = inVehicle or false
	self.hasTarget = hasTarget or false
	self.targetIsFriendly = targetIsFriendly or false
	self.targetIsEnemy = targetIsEnemy or false
	self.isMounted = isMounted or false
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

	return TRB.Classes.BarVisibilityContext:New(
		force or false,
		TRB.Data.specSupported or false,
		TRB.Data.character.inCombat or false,
		TRB.Data.character.inVehicle or false,
		hasTarget,
		targetIsFriendly,
		targetIsEnemy,
		TRB.Data.character.isMounted or false
	)
end

---@class TRB.Classes.BarVisibilityEntry
---@field barGroup TRB.Classes.BarGroup|nil # The BarGroup to show/hide (nil = skip)
---@field visibilitySettings trbBarVisibilitySetting|nil # The displayBar sub-table for this bar (must have .neverShow and .conditions), or nil to force-hide
---@field enabled boolean # Class-level precondition (false = always hide regardless of settings)
---@field showNodesCount number|nil # If set, calls :ShowNodes(n) when showing the bar
---@field setMaxNodes number|nil # If set, calls :SetMaxNodes(n) before showing the bar
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

---Marks visibility state as dirty, forcing the next ProcessBars call to re-evaluate.
---Call this whenever any input to visibility evaluation changes:
---  inCombat, inVehicle, inPetBattle, onTaxi, specSupported,
---  isMounted, hasTarget, per-bar visibility settings, talent gates, maxResource2.
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
	return self.dirtyToken ~= self.lastAppliedToken
end

---Marks the cache as up-to-date after a successful ProcessBars evaluation.
function TRB.Functions.BarVisibility:MarkClean()
	self.lastAppliedToken = self.dirtyToken
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

	-- If no conditions are enabled (all false/nil), treat as "always show"
	local hasAnyCondition = false
	for _, v in pairs(conditions) do
		if v == true then
			hasAnyCondition = true
			break
		end
	end

	if not hasAnyCondition then
		return true -- No conditions selected = always show
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
	if conditions.isMounted and context.isMounted then
		return true
	end

	-- Conditions exist but none matched
	return false
end

---Evaluates and applies visibility for all bar entries. Sets isTracking and controls BarText.
---@param context TRB.Classes.BarVisibilityContext # The shared environment snapshot
---@param entries TRB.Classes.BarVisibilityEntry[] # Array of bar entries to process
---@param snapshotData TRB.Classes.SnapshotData # The snapshot data to update isTracking on
---@param settings table|nil # The spec settings, passed to BarText:Show/Hide
---@return boolean # Whether any bar is showing (isTracking value)
function TRB.Functions.BarVisibility:ProcessBars(context, entries, snapshotData, settings)
	local anyShowing = false

	for _, entry in ipairs(entries) do
		if entry.barGroup ~= nil then
			local show = self:ShouldShowBar(context, entry)
			if show then
				anyShowing = true
				if entry.setMaxNodes then
					entry.barGroup:SetMaxNodes(entry.setMaxNodes)
				end
				entry.barGroup:Show()
				if entry.showNodesCount then
					entry.barGroup:ShowNodes(entry.showNodesCount)
				end
			else
				entry.barGroup:Hide()
			end
		end
	end

	-- Collapse/expand container frames based on resolved visibility.
	-- Hidden bars' containers are shrunk to 0.001 so that bars anchored to them
	-- slide together (no blank gap). Visible bars are expanded back to their
	-- layout height (stored during ConstructAnchoredBarGroup / ApplyLayout).
	-- This runs AFTER Show/Hide so it reflects the correct runtime state,
	-- including Druid form-based visibility which isn't known at construction time.
	for _, entry in ipairs(entries) do
		if entry.barGroup ~= nil and entry.barGroup.containerFrame then
			if entry.barGroup.isVisible then
				if entry.barGroup.layoutHeight and entry.barGroup.layoutHeight > 0 then
					entry.barGroup.containerFrame:SetHeight(entry.barGroup.layoutHeight)
				end
			else
				entry.barGroup.containerFrame:SetHeight(0.001)
			end
		end
	end

	-- Detect hidden→visible transition: when the bar was not tracking but is now
	-- showing, mark lookup data dirty so that UpdateResourceBarText doesn't
	-- early-out on the next tick. Without this, text goes stale when the bar is
	-- hidden (lookupDirty gets consumed while hidden) and never refreshes when
	-- the bar reappears.
	local wasTracking = snapshotData.attributes.isTracking
	snapshotData.attributes.isTracking = anyShowing
	if anyShowing and not wasTracking then
		TRB.Data.lookupDirty = true
	end

	if anyShowing and settings ~= nil then
		TRB.Functions.BarText:Show(settings)
	else
		TRB.Functions.BarText:Hide(settings)
	end

	self:MarkClean()
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
				entry.barGroup:Hide()
				-- Collapse container so anchored children slide together
				if entry.barGroup.containerFrame then
					entry.barGroup.containerFrame:SetHeight(0.001)
				end
			end
		end
	end

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
				group:Hide()
			end
		end
	end
	snapshotData.attributes.isTracking = false

	self:MarkClean()
end

---Convenience: Builds entries from barGroups for Edit Mode display.
---Shows ALL bars unconditionally so they can be previewed and repositioned.
---@param barGroups table # TRB.Frames.barGroups
---@param displayBar table|nil # The displayBar settings table (unused; kept for API compat)
---@param maxResource2 number|nil # Max secondary resource count (for ShowNodes)
---@return TRB.Classes.BarVisibilityEntry[]
function TRB.Functions.BarVisibility:BuildEditModeEntries(barGroups, displayBar, maxResource2)
	local entries = {}
	local alwaysVis = { neverShow = false, conditions = {} }

	-- Primary always shows in Edit Mode
	if barGroups.primary then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.primary,
			alwaysVis,
			true,
			nil,
			nil
		)
	end

	-- Secondary: always show in Edit Mode if nodes exist
	if barGroups.secondary and (maxResource2 or 0) > 0 then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.secondary,
			alwaysVis,
			true,
			maxResource2,
			nil
		)
	end

	-- Health: always show in Edit Mode
	if barGroups.health then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.health,
			alwaysVis,
			true,
			1,
			nil
		)
	end

	-- Utility: always show in Edit Mode
	if barGroups.utility then
		entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
			barGroups.utility,
			alwaysVis,
			true,
			1,
			nil
		)
	end

	-- Iterate remaining bar groups (custom bar types: mana, stagger, defensives, utility, etc.)
	-- All shown unconditionally in Edit Mode
	for key, group in pairs(barGroups) do
		if type(group) == "table" and group.Hide and key ~= "primary" and key ~= "secondary" and key ~= "health" and key ~= "utility" then
			local nodeCount = group.maxNodes or 1
			entries[#entries + 1] = TRB.Classes.BarVisibilityEntry:New(
				group,
				alwaysVis,
				true,
				nodeCount,
				nil
			)
		end
	end

	return entries
end
