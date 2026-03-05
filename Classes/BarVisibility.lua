local _, TRB = ...
TRB.Classes = TRB.Classes or {}
TRB.Functions = TRB.Functions or {}

---@class TRB.Classes.BarVisibilityContext
---@field force boolean # Whether to force-hide all bars (e.g., spec switch, pet battle)
---@field specSupported boolean # Whether the current spec is enabled in addon settings
---@field advancedFlight boolean # Whether the player is in advanced (dragon) flight
---@field dragonridingEnabled boolean # Whether the user wants bars shown during dragonriding
---@field inCombat boolean # Whether the player is currently in combat
---@field inVehicle boolean # Whether the player is currently in a vehicle
TRB.Classes.BarVisibilityContext = {}
TRB.Classes.BarVisibilityContext.__index = TRB.Classes.BarVisibilityContext

---Creates a new BarVisibilityContext with explicit values.
---@param force boolean
---@param specSupported boolean
---@param advancedFlight boolean
---@param dragonridingEnabled boolean
---@param inCombat boolean
---@param inVehicle boolean
---@return TRB.Classes.BarVisibilityContext
function TRB.Classes.BarVisibilityContext:New(force, specSupported, advancedFlight, dragonridingEnabled, inCombat, inVehicle)
	local self = setmetatable({}, TRB.Classes.BarVisibilityContext)
	self.force = force or false
	self.specSupported = specSupported
	self.advancedFlight = advancedFlight or false
	self.dragonridingEnabled = dragonridingEnabled or false
	self.inCombat = inCombat or false
	self.inVehicle = inVehicle or false
	return self
end

---Convenience constructor that reads current game state into a context.
---@param force boolean # Force-hide flag from the caller
---@param settings table|nil # The spec's settings table (must have displayBar.dragonriding)
---@return TRB.Classes.BarVisibilityContext
function TRB.Classes.BarVisibilityContext:NewFromGameState(force, settings)
	local dragonridingEnabled = false
	if settings and settings.displayBar then
		dragonridingEnabled = settings.displayBar.dragonriding or false
	end

	return TRB.Classes.BarVisibilityContext:New(
		force or false,
		TRB.Data.specSupported or false,
		TRB.Data.character.advancedFlight or false,
		dragonridingEnabled,
		TRB.Data.character.inCombat or false,
		UnitInVehicle("player") or false
	)
end

---@class TRB.Classes.BarVisibilityEntry
---@field barGroup TRB.Classes.BarGroup|nil # The BarGroup to show/hide (nil = skip)
---@field visibilitySettings table|nil # The displayBar sub-table for this bar (must have .visibility string), or nil to force-hide
---@field enabled boolean # Class-level precondition (false = always hide regardless of settings)
---@field showNodesCount number|nil # If set, calls :ShowNodes(n) when showing the bar
---@field setMaxNodes number|nil # If set, calls :SetMaxNodes(n) before showing the bar
TRB.Classes.BarVisibilityEntry = {}
TRB.Classes.BarVisibilityEntry.__index = TRB.Classes.BarVisibilityEntry

---Creates a new BarVisibilityEntry.
---@param barGroup TRB.Classes.BarGroup|nil # The bar group to control
---@param visibilitySettings table|nil # The displayBar.<key> settings sub-table (must have .visibility), or nil
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

	-- Dragonriding hide
	if context.advancedFlight and not context.dragonridingEnabled then
		return false
	end

	-- Evaluate the visibility setting
	local visibility = entry.visibilitySettings.visibility
	if visibility == "always" then
		return true
	elseif visibility == "combat" then
		return context.inCombat or context.inVehicle
	end

	-- "never" or any unrecognized value
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

	snapshotData.attributes.isTracking = anyShowing
	if anyShowing then
		TRB.Functions.BarText:Show(settings)
	else
		if settings ~= nil then
			TRB.Functions.BarText:Hide(settings)
		end
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
				entry.barGroup:Hide()
			end
		end
	end

	snapshotData.attributes.isTracking = false
	if settings ~= nil then
		TRB.Functions.BarText:Hide(settings)
	end
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
end

---Convenience: Builds entries from barGroups for Edit Mode display.
---Shows ALL bars unconditionally so they can be previewed and repositioned.
---@param barGroups table # TRB.Frames.barGroups
---@param displayBar table|nil # The displayBar settings table (unused; kept for API compat)
---@param maxResource2 number|nil # Max secondary resource count (for ShowNodes)
---@return TRB.Classes.BarVisibilityEntry[]
function TRB.Functions.BarVisibility:BuildEditModeEntries(barGroups, displayBar, maxResource2)
	local entries = {}
	local alwaysVis = { visibility = "always" }

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

	-- Iterate remaining bar groups (custom bar types: mana, stagger, defensives, utility, etc.)
	-- All shown unconditionally in Edit Mode
	for key, group in pairs(barGroups) do
		if type(group) == "table" and group.Hide and key ~= "primary" and key ~= "secondary" and key ~= "health" then
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
