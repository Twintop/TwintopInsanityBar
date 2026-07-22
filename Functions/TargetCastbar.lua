---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.TargetCastbar = {}

--[[
	Functions.TargetCastbar: render + event bridge for the target/focus cast bars.
	Drives the per-unit TRB.Classes.TargetCastbar models (TRB.Data.targetCastbar / focusCastbar) from
	UNIT_SPELLCAST_* events on the target/focus tokens, plus PLAYER_TARGET_CHANGED / PLAYER_FOCUS_CHANGED
	to pick up a cast already in progress when the unit changes.

	Everything is secret-safe: the fill is native self-animation via StatusBar:SetTimerDuration(durationObject),
	the remaining countdown formats the DurationObject's (possibly secret) seconds via string.format, the
	interruptible color comes from C_CurveUtil.EvaluateColorFromBoolean, and the spell name/icon are pushed
	straight into SetText / the icon texture. No Lua arithmetic or comparison ever touches a secret.

	Like the player castbar, these bars are NOT in BarVisibility:ProcessBars, so ApplyVisibleState
	re-asserts alpha/visibility every frame to self-heal after render transitions.
]]

-- Unit key -> model + bar-group key. Focus is a second, independently-positioned bar.
local UNITS = {
	{ unit = "target", modelKey = "targetCastbar", groupKey = "targetCastbar" },
	{ unit = "focus", modelKey = "focusCastbar", groupKey = "focusCastbar" },
}

-- Dedicated per-frame frame: refreshes the remaining-countdown text and self-heals visibility while any
-- tracked bar is active. Enabled when a cast starts, disabled once all bars are idle.
local updaterFrame = CreateFrame("Frame")
updaterFrame:Hide()

-- Interruptible/uninterruptible colors are resolved from settings each render; cached CreateColor objects
-- are rebuilt only when the hex changes (CreateColor allocates).
local colorCache = {}
local function GetColorObject(hex)
	if hex == nil then
		return nil
	end
	local cached = colorCache[hex]
	if cached == nil then
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(hex, true)
		cached = CreateColor(r, g, b, a)
		colorCache[hex] = cached
	end
	return cached
end

---Returns the model for a unit key, lazily creating both models on first use.
---@param modelKey string
---@return TRB.Classes.TargetCastbar
local function GetModel(modelKey)
	if TRB.Data[modelKey] == nil then
		local unit = modelKey == "focusCastbar" and "focus" or "target"
		TRB.Data[modelKey] = TRB.Classes.TargetCastbar:New(unit)
	end
	return TRB.Data[modelKey]
end

---Returns the composed active display settings, or nil.
local function GetActiveSettings()
	return TRB.Functions.Class:GetActiveDisplaySettings()
end

---Returns the bar settings / colors / visibility for a unit's bar from composed settings.
---@param groupKey string
---@return table? settings, table? barSettings, table? colors, table? visibility
local function GetBarConfig(groupKey)
	local settings = GetActiveSettings()
	if settings == nil then
		return nil, nil, nil, nil
	end
	local barSettings = settings.bars and settings.bars[groupKey]
	local colors = settings.colors and settings.colors.bars and settings.colors.bars[groupKey]
	local visibility = settings.displayBar and settings.displayBar[groupKey]
	return settings, barSettings, colors, visibility
end

---Whether the bar is enabled at all (mirrors the castbar's IsEnabled rules).
---@param visibility table?
---@return boolean
local function IsEnabled(visibility)
	if visibility == nil or visibility.neverShow == true then
		return false
	end
	if visibility.alwaysShow == true then
		return true
	end
	local conditions = visibility.conditions
	if conditions == nil then
		return true
	end
	return conditions.casting == true or conditions.channeling == true or conditions.empowered == true
end

---Whether the given cast state may show per the visibility conditions.
---@param visibility table?
---@param state string
---@return boolean
local function IsStateAllowed(visibility, state)
	if visibility == nil or visibility.neverShow == true then
		return false
	end
	if visibility.alwaysShow then
		return true
	end
	local conditions = visibility.conditions
	if conditions == nil then
		return true
	end
	if state == "channel" then
		return conditions.channeling == true
	elseif state == "empower" then
		return conditions.empowered == true
	end
	return conditions.casting == true
end

---Returns the bar group + single node for a unit key, or nils.
---@param groupKey string
---@return TRB.Classes.BarGroup?, TRB.Classes.BarNode?
local function GetGroupNode(groupKey)
	local barGroups = TRB.Frames.barGroups
	local group = barGroups and barGroups[groupKey] or nil
	local node = group and group:GetNode(1) or nil
	return group, node
end

---Sets the side icon texture without the memoized comparison SetIconTexture does, so a SECRET icon id
---(which cannot be compared) still applies. Passing nil hides the icon.
---@param node TRB.Classes.BarNode
---@param iconId any
local function SetIconRaw(node, iconId)
	if iconId == nil then
		node:SetIconVisible(false)
		return
	end
	local icon = node:EnsureIcon()
	icon.texture:SetTexture(iconId)
	node:SetIconVisible(true)
end

---Applies the fill color for the current state, honoring interruptibility via the native secret-boolean
---evaluator. Interruptible coloring is scoped to hostile units (a friendly cast reads interruptible but
---cannot actually be interrupted). Border/background are static and owned by the custom-bar appearance
---path (ApplyCustomBarGroupsAppearance), so this only touches the fill.
---@param node TRB.Classes.BarNode
---@param model TRB.Classes.TargetCastbar
---@param colors table
---@param barSettings table?
local function ApplyFillColor(node, model, colors, barSettings)
	local baseHex = (model.state == "channel" and colors.channel and colors.channel.color)
		or (colors.bar and colors.bar.color)
	-- Interruptible recolor: opt-in, hostile targets only, and only when we have both colors + a flag.
	local wantInterrupt = barSettings == nil or barSettings.interruptColor ~= false
	local hostile = UnitExists(model.unit) and UnitCanAttack("player", model.unit)
	if wantInterrupt and hostile and colors.uninterruptible and colors.uninterruptible.color
		and model.notInterruptible ~= nil and C_CurveUtil ~= nil and C_CurveUtil.EvaluateColorFromBoolean ~= nil then
		local locked = GetColorObject(colors.uninterruptible.color)
		local normal = GetColorObject(baseHex)
		if locked ~= nil and normal ~= nil then
			-- EvaluateColorFromBoolean reads the (secret) notInterruptible C-side; result may be secret.
			local colorResult = C_CurveUtil.EvaluateColorFromBoolean(model.notInterruptible, locked, normal)
			if colorResult ~= nil then
				node:ClearGradient()
				node.frame:SetStatusBarColor(colorResult:GetRGBA())
				return
			end
		end
	end
	if baseHex ~= nil then
		node:SetColor(baseHex)
	end
end

---Applies the full visible render for an active cast: fill (native timer), color, name/icon, alpha, Show.
---Re-asserted every frame to self-heal after render transitions (these bars aren't in ProcessBars).
---@param groupKey string
---@param model TRB.Classes.TargetCastbar
local function ApplyVisibleState(groupKey, model)
	local group, node = GetGroupNode(groupKey)
	if group == nil or node == nil then
		return
	end
	local _, barSettings, colors, visibility = GetBarConfig(groupKey)

	node:SetMinMax(0, 1)
	-- Native self-animating fill from the DurationObject (secret-safe); falls back to a static full/empty
	-- bar when no object is available.
	if model.durationObject ~= nil and node.SetTimerDuration ~= nil then
		node:SetTimerDuration(model.durationObject, Enum.StatusBarInterpolation.Immediate, model:GetTimerDirection())
	else
		node:SetValue(model.state == "channel" and 1 or 0)
	end

	if colors ~= nil then
		ApplyFillColor(node, model, colors, barSettings)
	end

	-- Side icon (secret-safe). Border color tracks the bar's border so the icon reads as one bar.
	if barSettings and barSettings.icon and barSettings.icon.enabled ~= false then
		SetIconRaw(node, model.spellIconId)
		if node.icon ~= nil and colors ~= nil and colors.border ~= nil and colors.border.color ~= nil then
			node.icon:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(colors.border.color, true))
		end
	else
		node:SetIconVisible(false)
	end

	local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
	group.targetAlpha = activeAlpha
	group.currentAlpha = activeAlpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	node:Show()
	group.containerFrame:SetAlpha(activeAlpha)
end

---Per-frame self-heal: re-asserts alpha/visibility (and the static per-cast fill color) WITHOUT
---re-binding the native timer -- re-calling SetTimerDuration every frame would reset the fill animation.
---@param groupKey string
---@param model TRB.Classes.TargetCastbar
local function ReassertVisibility(groupKey, model)
	local group, node = GetGroupNode(groupKey)
	if group == nil or node == nil then
		return
	end
	local _, barSettings, colors, visibility = GetBarConfig(groupKey)
	if colors ~= nil then
		ApplyFillColor(node, model, colors, barSettings)
	end
	local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
	group.targetAlpha = activeAlpha
	group.currentAlpha = activeAlpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	node:Show()
	group.containerFrame:SetAlpha(activeAlpha)
end

---Applies the fully-hidden state for a unit's bar.
---@param groupKey string
local function ApplyHiddenState(groupKey)
	local group, node = GetGroupNode(groupKey)
	if group == nil then
		return
	end
	if node ~= nil and node.ClearTimerDuration ~= nil then
		node:ClearTimerDuration()
	end
	group.targetAlpha = 0
	group.currentAlpha = 0
	if group.isVisible then
		group:Hide()
	end
	if group.containerFrame then
		group.containerFrame:SetAlpha(0)
	end
end

---Whether any tracked bar is currently active.
---@return boolean
local function AnyActive()
	for _, u in ipairs(UNITS) do
		local model = TRB.Data[u.modelKey]
		if model ~= nil and model:IsActive() then
			return true
		end
	end
	return false
end

---Starts/stops the per-frame updater based on whether anything is active.
local function SyncUpdater()
	if AnyActive() then
		updaterFrame:Show()
	else
		updaterFrame:Hide()
	end
end

---Begins showing a unit's bar for a freshly-started cast.
---@param groupKey string
---@param model TRB.Classes.TargetCastbar
local function BeginRender(groupKey, model)
	local _, _, _, visibility = GetBarConfig(groupKey)
	if not IsEnabled(visibility) or not IsStateAllowed(visibility, model.state) then
		ApplyHiddenState(groupKey)
		return
	end
	ApplyVisibleState(groupKey, model)
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

---Ends a unit's bar render.
---@param groupKey string
local function EndRender(groupKey)
	ApplyHiddenState(groupKey)
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

-- ============================================================================
-- Per-frame updater: self-heal visibility while active. The fill self-animates via SetTimerDuration;
-- the countdown text is refreshed by the shared bar-text pipeline (RefreshTargetCastbarLookupData).
-- ============================================================================
updaterFrame:SetScript("OnUpdate", function()
	local anyActive = false
	for _, u in ipairs(UNITS) do
		local model = TRB.Data[u.modelKey]
		if model ~= nil and model:IsActive() then
			anyActive = true
			ReassertVisibility(u.groupKey, model)
		end
	end
	if anyActive then
		-- Keep the shared bar-text pipeline refreshing so $target/$focus remaining ticks down.
		TRB.Data.lookupDirty = true
	else
		updaterFrame:Hide()
	end
end)

-- ============================================================================
-- Event routing
-- ============================================================================

---Handles a UNIT_SPELLCAST_* event for a tracked unit.
---@param unit string
---@param event string
---@param spellId any
local function OnUnitEvent(unit, event, spellId)
	local entry
	for _, u in ipairs(UNITS) do
		if u.unit == unit then
			entry = u
			break
		end
	end
	if entry == nil then
		return
	end
	local model = GetModel(entry.modelKey)

	if event == "UNIT_SPELLCAST_START" then
		model:StartCast(spellId)
		BeginRender(entry.groupKey, model)
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		model:StartChannel(spellId)
		BeginRender(entry.groupKey, model)
	elseif event == "UNIT_SPELLCAST_EMPOWER_START" then
		model:StartEmpower(spellId)
		BeginRender(entry.groupKey, model)
	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP"
		or event == "UNIT_SPELLCAST_EMPOWER_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" then
		model:Stop()
		EndRender(entry.groupKey)
	elseif event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		-- The DurationObject reflects the new timing automatically; just re-assert the render.
		if model:IsActive() then
			ApplyVisibleState(entry.groupKey, model)
		end
	end
	TRB.Functions.BarText:MarkLookupDirty()
end

---Re-syncs a unit's bar when the unit changes: pick up an in-progress cast or clear a stale one.
---@param entry table
local function OnUnitChanged(entry)
	local model = GetModel(entry.modelKey)
	model:Stop()
	if UnitExists(entry.unit) and model:SyncFromUnit() then
		BeginRender(entry.groupKey, model)
	else
		EndRender(entry.groupKey)
	end
	TRB.Functions.BarText:MarkLookupDirty()
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(_, event, unit, _, spellId)
	if event == "PLAYER_TARGET_CHANGED" then
		OnUnitChanged(UNITS[1])
	elseif event == "PLAYER_FOCUS_CHANGED" then
		OnUnitChanged(UNITS[2])
	else
		OnUnitEvent(unit, event, spellId)
	end
end)

---Registers all events to begin tracking target + focus casts.
function TRB.Functions.TargetCastbar:Enable()
	for _, e in ipairs({ "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_DELAYED",
		"UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_UPDATE", "UNIT_SPELLCAST_CHANNEL_STOP",
		"UNIT_SPELLCAST_EMPOWER_START", "UNIT_SPELLCAST_EMPOWER_STOP", "UNIT_SPELLCAST_INTERRUPTED" }) do
		eventFrame:RegisterUnitEvent(e, "target", "focus")
	end
	eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	eventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
end

---Unregisters all target/focus cast tracking events.
function TRB.Functions.TargetCastbar:Disable()
	eventFrame:UnregisterAllEvents()
	for _, u in ipairs(UNITS) do
		local model = TRB.Data[u.modelKey]
		if model ~= nil then
			model:Stop()
		end
		EndRender(u.groupKey)
	end
end

---Returns the model for a unit key ("targetCastbar" / "focusCastbar"), creating it if needed.
---@param modelKey string
---@return TRB.Classes.TargetCastbar
function TRB.Functions.TargetCastbar:GetModel(modelKey)
	return GetModel(modelKey)
end
