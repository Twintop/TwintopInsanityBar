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
local ENTRY_BY_GROUP = {}
for _, u in ipairs(UNITS) do
	ENTRY_BY_GROUP[u.groupKey] = u
end

-- Post-cast fade timers keyed by groupKey: GetTime() when the fade-out began, or nil when not fading.
local fadeStart = {}
-- Tracks bars force-hidden (In Vehicle) mid-cast, so exiting the condition rebinds the native fill timer
-- (ApplyHiddenState clears it) instead of leaving a blank bar.
local forceHidden = {}

-- Dedicated per-frame frame: refreshes the remaining-countdown text and self-heals visibility while any
-- tracked bar is active. Enabled when a cast starts, disabled once all bars are idle.
local updaterFrame = CreateFrame("Frame")
updaterFrame:Hide()

-- 20Hz throttle for the expensive per-unit visibility work (GetBarConfig -> GetActiveSettings, plus the
-- IsForceHidden/IsStateAllowed condition checks and the color re-assert). Matches the shared timerFrame
-- cadence; the native SetTimerDuration fill animates on its own between ticks and a cheap alpha/visibility
-- self-heal still runs each frame, so nothing visibly lags. Cast start/stop, unit change, and delayed/
-- channel-update events re-assert immediately through their own handlers regardless of this accumulator.
local UPDATER_THROTTLE = 0.05
local updaterSinceLastUpdate = UPDATER_THROTTLE -- force a full pass on the first frame

-- Forces the updater's next frame to be a full throttle tick. Called from every state-transition entry
-- point (cast start/stop/fade, unit change, visibility refresh) so the tick re-resolves settings and
-- conditions immediately rather than acting on a cache left over from the previous state.
local function ForceThrottleTick()
	updaterSinceLastUpdate = UPDATER_THROTTLE
end

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

-- Uninterruptible shield curve endpoints. The visible endpoint carries the resolved tint RGB (white when
-- untinted, so the atlas keeps its own gray) and the final alpha; the transparent endpoint is shared so an
-- interruptible cast always evaluates fully-transparent. Cached by rounded r/g/b/a since CreateColor
-- allocates and this runs every frame.
local shieldTransparent = CreateColor(1, 1, 1, 0)
local shieldOpaqueCache = {}
local function GetShieldVisibleColor(r, g, b, a)
	r, g, b = r or 1, g or 1, b or 1
	a = math.min(math.max(a or 1, 0), 1)
	-- Key on 3-decimal-rounded channels: keeps the cache bounded while distinguishing every practical color.
	local key = string.format("%.3f:%.3f:%.3f:%.3f", r, g, b, a)
	local cached = shieldOpaqueCache[key]
	if cached == nil then
		cached = CreateColor(r, g, b, a)
		shieldOpaqueCache[key] = cached
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

---Public wrapper over the local IsEnabled: whether the bar is enabled at all (not Never Show / has a
---show condition). Layout consults this to collapse a disabled bar's reserved container space.
---@param visibility table?
---@return boolean
function TRB.Functions.TargetCastbar:IsEnabled(visibility)
	return IsEnabled(visibility)
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

---Whether a hard-hide condition (In Vehicle, Dead) currently suppresses the bar. The model keeps tracking while
---force-hidden so the bar reappears mid-cast when the condition clears (mirrors the player castbar).
---@param visibility table?
---@return boolean
local function IsForceHidden(visibility)
	local hideConditions = visibility and visibility.hideConditions
	if hideConditions == nil then
		return false
	end
	if hideConditions.inVehicle == true and UnitInVehicle("player") == true then
		return true
	end
	if hideConditions.isDead == true and UnitIsDeadOrGhost("player") == true then
		return true
	end
	return false
end

---Container alpha to rest at while no cast is active: activeAlpha when Always Show, else inactiveAlpha.
---0 whenever the bar is disabled (Never Show / nothing checked) or a hard-hide condition is active.
---@param visibility table?
---@return number # 0..1
local function GetIdleAlpha(visibility)
	if visibility == nil or not IsEnabled(visibility) or IsForceHidden(visibility) then
		return 0
	end
	if visibility.alwaysShow then
		return ((visibility.activeAlpha) or 100) / 100
	end
	return ((visibility.inactiveAlpha) or 0) / 100
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

-- ---------- empower stage boundary lines ----------
-- Pooled lines drawn at each stage-boundary fraction, bound to the node frame (rebuilt if the frame
-- changes, e.g. bar groups reconstructed). UnitEmpoweredStagePercentages comes back PLAIN even for a
-- fully secret cast (validated in-game), so its fractions drive SetPoint directly; any secret entry is
-- skipped defensively since a secret offset can't position a texture.
local function GetStageLinePool(node)
	local frame = node.frame
	---@diagnostic disable-next-line: inject-field
	local pool = frame._trbTargetStageLines
	if pool ~= nil and pool.frame == frame then
		return pool
	end
	pool = { frame = frame, lines = {} }
	---@diagnostic disable-next-line: inject-field
	frame._trbTargetStageLines = pool
	return pool
end

---Returns a pooled stage-line texture at index i, creating it on demand.
local function GetStageLine(pool, node, i)
	if pool.lines[i] == nil then
		local t = node.frame:CreateTexture(nil, "OVERLAY")
		t:SetDrawLayer("OVERLAY", 3)
		pool.lines[i] = t
	end
	return pool.lines[i]
end

---Hides all pooled stage-line textures for a node.
local function HideEmpowerStageLines(node)
	if node == nil then
		return
	end
	local pool = GetStageLinePool(node)
	for _, t in ipairs(pool.lines) do
		t:Hide()
	end
end

---Places a stage line at a timeline fraction. A local mirror of the player castbar's PlaceLine so that
---path stays untouched; the geometry (border-inset, fill-direction aware) is identical.
---@param tex table
---@param node TRB.Classes.BarNode
---@param frac number # Timeline fraction 0..1 (0 = fill start)
---@param isVertical boolean
---@param thickness number
local function PlaceStageLine(tex, node, frac, isVertical, thickness)
	local border = node.border or 0
	local innerW = math.max(1, node.width - 2 * border)
	local innerH = math.max(1, node.height - 2 * border)
	local fillDirection = node.fillDirection or "leftRight"
	tex:ClearAllPoints()
	if isVertical then
		local yFromBottom = (fillDirection == "topBottom") and (border + (1 - frac) * innerH) or (border + frac * innerH)
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", border, yFromBottom - thickness / 2)
		tex:SetSize(innerW, thickness)
	else
		local xFromLeft = (fillDirection == "rightLeft") and (border + (1 - frac) * innerW) or (border + frac * innerW)
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", xFromLeft - thickness / 2, border)
		tex:SetSize(thickness, innerH)
	end
end

---Draws the empower stage boundary lines for an active empowered cast. Clears (and no-ops) for other
---states, when the toggle is off, or when no stage fractions are available. Cheap to re-run every frame.
---@param node TRB.Classes.BarNode
---@param model TRB.Classes.TargetCastbar
---@param colors table?
---@param barSettings table?
local function DrawEmpowerStageLines(node, model, colors, barSettings)
	if node == nil then
		return
	end
	local pool = GetStageLinePool(node)
	local fractions = model and model.stagePercentages
	if model == nil or model.state ~= "empower" or fractions == nil
		or (barSettings ~= nil and barSettings.showEmpowerStages == false) then
		for _, t in ipairs(pool.lines) do
			t:Hide()
		end
		return
	end
	local lineColor = (colors and colors.empowerStageLine and colors.empowerStageLine.color) or "FFFFFFFF"
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(lineColor, true)
	local thickness = (barSettings and barSettings.empowerStageLineWidth) or 1
	local isVertical = TRB.Functions.Bar:IsVerticalFill(node.fillDirection)
	-- UnitEmpoweredStagePercentages returns per-stage segment WIDTHS across the charge+hold timeline
	-- (the last entry is the hold-at-max segment), summing to 1.0 -- the same frame as the fill and the
	-- player cast bar. Accumulate them into boundary positions and draw a line at each except the final
	-- one (~1.0, the bar end). A secret width would break the running sum, so bail and clear.
	local cum, drawn, n = 0, 0, #fractions
	for i = 1, n do
		local seg = fractions[i]
		if issecretvalue(seg) then
			drawn = 0
			break
		end
		cum = cum + seg
		if i < n and cum > 0.0001 and cum < 0.9999 then
			drawn = drawn + 1
			local t = GetStageLine(pool, node, drawn)
			t:SetColorTexture(r, g, b, a)
			PlaceStageLine(t, node, cum, isVertical, thickness)
			t:Show()
		end
	end
	for i = drawn + 1, #pool.lines do
		pool.lines[i]:Hide()
	end
end

---Whether PvP is currently "enabled" for the class-color PvP-only sub-option: player flagged, War Mode
---desired, or inside a battleground/arena. Mirrors the player cast bar's rule.
---@return boolean
local function IsPvpEnabled()
	if UnitIsPVP("player") or C_PvP.IsWarModeDesired() then
		return true
	end
	local instanceType = TRB.Data.character.instanceType
	return instanceType == "pvp" or instanceType == "arena"
end

---Resolves the monitored unit's class color as an AARRGGBB hex when the "color by class" option applies:
---the unit is a player, hostile (or friendly when opted in), and PvP is enabled when the PvP-only
---sub-option is set. Returns nil to fall through to the configured / uninterruptible colors. The class
---name can be secret for an enemy, so bail rather than compare it.
---@param unit string
---@param barSettings table?
---@return string?
local function GetUnitClassColor(unit, barSettings)
	if barSettings == nil or barSettings.classColor ~= true then
		return nil
	end
	if not UnitExists(unit) or not UnitIsPlayer(unit) then
		return nil
	end
	if UnitIsFriend("player", unit) and barSettings.classColorFriendly ~= true then
		return nil
	end
	if barSettings.classColorPvpOnly == true and not IsPvpEnabled() then
		return nil
	end
	local _, classFilename = UnitClass(unit)
	if classFilename == nil or issecretvalue(classFilename) then
		return nil
	end
	local color = C_ClassColor.GetClassColor(classFilename)
	if color == nil then
		return nil
	end
	return TRB.Functions.Color:ConvertColorDecimalToHex(color.r, color.g, color.b, 1)
end

---Applies the fill color for the current state. The monitored unit's class color (when enabled) wins for
---every cast type, including uninterruptible -- the uninterruptible border still marks it. Otherwise the
---fill honors interruptibility via the native secret-boolean evaluator, scoped to hostile units (a
---friendly cast reads interruptible but cannot actually be interrupted). Background is static and owned by
---the custom-bar appearance path; the border is handled by ApplyBorderColor.
---@param node TRB.Classes.BarNode
---@param model TRB.Classes.TargetCastbar
---@param colors table
---@param barSettings table?
local function ApplyFillColor(node, model, colors, barSettings)
	-- Class color overrides everything on the fill (mirrors the player cast bar's target-class option).
	local classHex = GetUnitClassColor(model.unit, barSettings)
	if classHex ~= nil then
		node:ClearGradient()
		node:SetColor(classHex)
		return
	end
	local baseHex = (model.state == "empower" and colors.empower and colors.empower.color)
		or (model.state == "channel" and colors.channel and colors.channel.color)
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

---Applies the border color, in priority order: an active Color Indicator targeting the border wins
---(mirrors the player cast bar), else the secret-safe uninterruptible recolor -- while a hostile cast
---can't be interrupted the border takes the uninterruptibleBorder color via the native secret-boolean
---evaluator -- else the configured border, with a gradient indicator turning that base into a resource
---curve. SetBorderColor/SetBorderColorCurve also color the side icon's border (and the end cap, via its
---border-follow) so the whole bar reads as one.
---@param node TRB.Classes.BarNode
---@param model TRB.Classes.TargetCastbar? # nil for the idle bar, which is never uninterruptible
---@param colors table?
---@param barSettings table?
---@param barKey string # "targetCastbar" / "focusCastbar" -- the Color Indicator target key
local function ApplyBorderColor(node, model, colors, barSettings, barKey)
	if colors == nil or colors.border == nil or colors.border.color == nil then
		return
	end
	local Color = TRB.Functions.Color
	local indicators = Color:GetResolvedIndicators(barKey)
	-- A flat indicator targeting the border overrides everything (including uninterruptible); the resolved
	-- path also layers a gradient indicator on top when one targets the border.
	if indicators ~= nil and indicators.border ~= nil then
		Color:ApplyResolvedBorderOrBackground(node, barKey, "border", indicators.border)
		return
	end
	local normalHex = colors.border.color
	local wantInterrupt = barSettings == nil or barSettings.interruptColor ~= false
	local hostile = model ~= nil and UnitExists(model.unit) and UnitCanAttack("player", model.unit)
	if wantInterrupt and hostile and colors.uninterruptibleBorder and colors.uninterruptibleBorder.color
		and model ~= nil and model.notInterruptible ~= nil and C_CurveUtil ~= nil and C_CurveUtil.EvaluateColorFromBoolean ~= nil then
		local locked = GetColorObject(colors.uninterruptibleBorder.color)
		local normal = GetColorObject(normalHex)
		if locked ~= nil and normal ~= nil then
			-- Reads the (secret) notInterruptible C-side; the result may be secret and passes straight
			-- through SetBorderColorCurve into SetBackdropBorderColor (bar + icon border).
			local colorResult = C_CurveUtil.EvaluateColorFromBoolean(model.notInterruptible, locked, normal)
			if colorResult ~= nil then
				node:SetBorderColorCurve(colorResult)
				return
			end
		end
	end
	-- No indicator, no uninterruptible override: configured color, plus a gradient indicator if present.
	Color:ApplyResolvedBorderOrBackground(node, barKey, "border", normalHex)
end

---Applies the background color: an active Color Indicator targeting the background wins, else the
---configured background, with a gradient indicator turning that base into a resource curve. Re-applied
---each frame (background is otherwise static) so an indicator can recolor it while the bar is on screen.
---@param node TRB.Classes.BarNode
---@param colors table?
---@param barKey string
local function ApplyBackgroundColor(node, colors, barKey)
	local Color = TRB.Functions.Color
	local indicators = Color:GetResolvedIndicators(barKey)
	local background = indicators and indicators.background
	if background == nil and colors ~= nil and colors.background ~= nil then
		background = colors.background.color
	end
	Color:ApplyResolvedBorderOrBackground(node, barKey, "background", background)
	-- End cap: a flat/gradient indicator targeting it, else the cap reverts to its own configured color.
	Color:ApplyResolvedEndCap(node, barKey)
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

	-- Side icon (secret-safe). Its border tracks the bar's border via ApplyBorderColor below.
	if barSettings and barSettings.icon and barSettings.icon.enabled ~= false then
		SetIconRaw(node, model.spellIconId)
	else
		node:SetIconVisible(false)
	end

	-- Uninterruptible shield. Independent of the icon being enabled (a bar-targeted shield shows with the
	-- icon off). notInterruptible is SECRET here, so we can't branch on it: instead evaluate a curve (visible
	-- tint -> transparent) and feed the result's color straight to the shield, exactly like the border
	-- recolor. The tint (resolved from a plain color source) and alpha ride the visible endpoint. Same
	-- opt-in/hostile guards as the border.
	local shield = barSettings and barSettings.uninterruptibleShield
	local wantInterrupt = barSettings == nil or barSettings.interruptColor ~= false
	if shield ~= nil and shield.mode ~= "hide" and model.state ~= "empower" and wantInterrupt
		and UnitExists(model.unit) and UnitCanAttack("player", model.unit)
		and model.notInterruptible ~= nil and C_CurveUtil ~= nil and C_CurveUtil.EvaluateColorFromBoolean ~= nil then
		-- Resolve the tint (nil = untinted white). Final alpha = opacity slider, times the custom color's own
		-- alpha (bar-color sources contribute RGB only).
		local tintHex = TRB.Functions.Color:ResolveShieldColor(shield, colors)
		local alpha = (shield.opacity or 100) / 100
		local r, g, b
		if tintHex ~= nil then
			local ta
			r, g, b, ta = TRB.Functions.Color:GetRGBAFromString(tintHex, true)
			if shield.colorSource == "custom" then
				alpha = alpha * ta
			end
		end
		local colorResult = C_CurveUtil.EvaluateColorFromBoolean(model.notInterruptible,
			GetShieldVisibleColor(r, g, b, alpha), shieldTransparent)
		node:SetShieldCurve(colorResult)
	else
		node:SetShieldCurve(nil)
	end

	-- Border / background / end cap: Color Indicator (border/background/endCap targets) over the secret-safe
	-- uninterruptible recolor over the configured colors. Border also colors the icon border + end-cap follow.
	if colors ~= nil then
		ApplyBorderColor(node, model, colors, barSettings, groupKey)
		ApplyBackgroundColor(node, colors, groupKey)
	end

	-- Empower stage boundary lines (secret-safe; no-op for non-empower states).
	DrawEmpowerStageLines(node, model, colors, barSettings)

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

-- Per-groupKey cache of the last throttle tick's resolved activeAlpha, so between-tick frames can do the
-- cheap alpha/visibility self-heal without re-resolving settings (GetBarConfig). nil means the bar was not
-- visible at the last tick (disabled/force-hidden/idle), so the cheap self-heal is skipped.
local cachedActiveAlpha = {}
-- Per-groupKey cache of the last throttle tick's resolved visibility table, reused between ticks by the
-- per-frame fade interpolation so it needn't re-resolve settings every frame.
local cachedVisibility = {}
-- Per-groupKey cache of the last throttle tick's resolved idle alpha (Always Show / inactive-alpha resting
-- bar). nil means no idle bar was resting visible at the last tick, so the cheap self-heal is skipped.
local cachedIdleAlpha = {}

---Full per-cast visibility re-assert (color + stage lines + alpha) WITHOUT re-binding the native timer
---(re-calling SetTimerDuration every frame would reset the fill animation). Run on the 20Hz throttle tick.
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
		ApplyBorderColor(node, model, colors, barSettings, groupKey)
		ApplyBackgroundColor(node, colors, groupKey)
	end
	-- Re-draw the stage lines each frame so they self-heal after render transitions and pick up live
	-- settings changes (positions are static per cast, so this is cheap).
	DrawEmpowerStageLines(node, model, colors, barSettings)
	local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
	cachedActiveAlpha[groupKey] = activeAlpha
	group.targetAlpha = activeAlpha
	group.currentAlpha = activeAlpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	node:Show()
	group.containerFrame:SetAlpha(activeAlpha)
end

---Cheap between-tick self-heal: re-asserts only alpha/visibility from the cached activeAlpha, no settings
---resolution or color work. Keeps a visible active bar healed against render transitions each frame while
---the full re-assert waits for the next 20Hz tick.
---@param groupKey string
local function ReassertVisibilityCheap(groupKey)
	local group, node = GetGroupNode(groupKey)
	if group == nil or node == nil then
		return
	end
	local activeAlpha = cachedActiveAlpha[groupKey] or 1
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
	HideEmpowerStageLines(node)
	group.targetAlpha = 0
	group.currentAlpha = 0
	if group.isVisible then
		group:Hide()
	end
	if group.containerFrame then
		group.containerFrame:SetAlpha(0)
	end
end

---Freezes the fill where the native timer last animated it, so an abnormal stop (interrupt, cancel, early
---empower release) holds the bar in place instead of the C-side timer draining it to empty/full through the
---fade-out. GetValue() stays 0 while the timer animates C-side (no readable animated position), so instead
---reconstruct the stopped fraction directly from the duration's own seconds: range [0, total], value elapsed.
---Both are secret, but SetMinMaxValues/SetValue accept secrets and there's no Lua compare or arithmetic, so
---elapsed/total renders as the exact stopped fraction with NO timer left to advance it. Idempotent: a single
---cancel fires duplicate STOP/INTERRUPTED events, and model:Stop() has already nil'd the durationObject by the
---second call -- with no duration to read, leave the already-frozen bar untouched (calling ClearTimerDuration
---here would hide/reshow the frame and flash it).
---@param groupKey string
---@param model TRB.Classes.TargetCastbar
local function FreezeFill(groupKey, model)
	local _, node = GetGroupNode(groupKey)
	if node == nil then
		return
	end
	local dur = model and model.durationObject
	local total = dur and dur.GetTotalDuration and dur:GetTotalDuration()
	-- Casts/empowers fill up (freeze at elapsed); channels deplete from full (freeze at remaining). Mirror the
	-- direction GetTimerDirection drove the live fill with, so the frozen bar sits exactly where it was drawn.
	local value
	if model.state == "channel" then
		value = dur and dur.GetRemainingDuration and dur:GetRemainingDuration()
	else
		value = dur and dur.GetElapsedDuration and dur:GetElapsedDuration()
	end
	if value == nil or total == nil then
		return
	end
	-- Paint the static frozen fraction directly; a manual SetMinMaxValues + SetValue supersedes the timer
	-- animation without ClearTimerDuration's hide/reshow flash. Keep hasTimerDuration in sync so a later
	-- rebind (next cast) still clears cleanly.
	node.frame:SetMinMaxValues(0, total)
	node.frame:SetValue(value)
	node.hasTimerDuration = false
end

---Applies the idle (no active cast) empty-bar state at idleAlpha: empty fill, no icon/stage lines, normal
---border. Re-asserted per frame so it self-heals after render transitions the same way the active render
---does (these bars aren't in ProcessBars). Used for Always Show and non-zero inactive alpha.
---@param groupKey string
---@param idleAlpha number # 0..1
local function ApplyIdleState(groupKey, idleAlpha)
	local group, node = GetGroupNode(groupKey)
	if group == nil or node == nil then
		return
	end
	local _, _, colors = GetBarConfig(groupKey)
	if node.ClearTimerDuration ~= nil then
		node:ClearTimerDuration()
	end
	node:SetMinMax(0, 1)
	node:SetValue(0)
	HideEmpowerStageLines(node)
	node:SetIconVisible(false)
	node:SetShieldCurve(nil)
	-- No cast means no interruptibility, but the empty bar is on screen, so a Color Indicator targeting
	-- its border/background/end cap should still show (else the configured colors).
	if colors ~= nil then
		ApplyBorderColor(node, nil, colors, nil, groupKey)
		ApplyBackgroundColor(node, colors, groupKey)
	end
	group.targetAlpha = idleAlpha
	group.currentAlpha = idleAlpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	node:Show()
	group.containerFrame:SetAlpha(idleAlpha)
end

---Resolves a unit's no-active-cast display: an idle empty bar at the resting alpha when one should show
---(Always Show, or a non-zero inactive alpha) and the unit exists, else fully hidden.
---@param groupKey string
local function ApplyInactiveState(groupKey)
	local entry = ENTRY_BY_GROUP[groupKey]
	local _, _, _, visibility = GetBarConfig(groupKey)
	local idleAlpha = GetIdleAlpha(visibility)
	if idleAlpha > 0 and entry ~= nil and UnitExists(entry.unit) then
		ApplyIdleState(groupKey, idleAlpha)
	else
		ApplyHiddenState(groupKey)
	end
end

---Whether the per-frame updater needs to run: any bar actively casting, mid fade-out, or resting at a
---visible idle alpha (which must self-heal against render transitions).
---@return boolean
local function NeedsUpdater()
	for _, u in ipairs(UNITS) do
		local model = TRB.Data[u.modelKey]
		if model ~= nil and model:IsActive() then
			return true
		end
		if fadeStart[u.groupKey] ~= nil then
			return true
		end
		local _, _, _, visibility = GetBarConfig(u.groupKey)
		if GetIdleAlpha(visibility) > 0 and UnitExists(u.unit) then
			return true
		end
	end
	return false
end

---Starts/stops the per-frame updater based on whether any bar needs rendering. Every state-transition
---entry point (BeginRender/BeginFadeOut/EndRender/RefreshVisibility) ends here, so forcing a throttle tick
---when the updater runs guarantees the next frame re-resolves settings/conditions from the new state
---rather than acting on a cache left over from the previous state.
local function SyncUpdater()
	if NeedsUpdater() then
		ForceThrottleTick()
		updaterFrame:Show()
	else
		updaterFrame:Hide()
	end
end

---Begins showing a unit's bar for a freshly-started cast. A hard-hide condition (In Vehicle) keeps the
---model tracking but stays hidden; a disabled bar or a disallowed cast type falls back to the idle state.
---@param groupKey string
---@param model TRB.Classes.TargetCastbar
local function BeginRender(groupKey, model)
	fadeStart[groupKey] = nil
	local _, _, _, visibility = GetBarConfig(groupKey)
	if not IsEnabled(visibility) or not IsStateAllowed(visibility, model.state) then
		forceHidden[groupKey] = nil
		ApplyInactiveState(groupKey)
		TRB.Functions.BarVisibility:MarkDirty()
		SyncUpdater()
		return
	end
	if IsForceHidden(visibility) then
		-- Hidden now, but the model keeps tracking; flag so the updater rebinds the fill when it clears.
		forceHidden[groupKey] = true
		ApplyHiddenState(groupKey)
	else
		forceHidden[groupKey] = nil
		ApplyVisibleState(groupKey, model)
	end
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

---Begins the post-cast fade-out honoring fadeDelay/fadeDuration, resting at the idle alpha when done.
---Falls back to an instant resolve when no fade is configured and nothing rests visible. The updater's
---fade branch drives the hold + interpolation + final resting state.
---@param groupKey string
local function BeginFadeOut(groupKey)
	forceHidden[groupKey] = nil
	local _, _, _, visibility = GetBarConfig(groupKey)
	local delay = (visibility and visibility.fadeDelay) or 0
	local duration = (visibility and visibility.fadeDuration) or 0
	if not IsEnabled(visibility) or IsForceHidden(visibility) or (delay <= 0 and duration <= 0 and GetIdleAlpha(visibility) <= 0) then
		fadeStart[groupKey] = nil
		ApplyInactiveState(groupKey)
	else
		fadeStart[groupKey] = GetTime()
	end
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

---Ends a unit's bar render immediately (disable / teardown); natural cast ends go through BeginFadeOut.
---@param groupKey string
local function EndRender(groupKey)
	fadeStart[groupKey] = nil
	forceHidden[groupKey] = nil
	ApplyHiddenState(groupKey)
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

---Re-resolves the idle/hidden display for every inactive bar after a settings or environment change
---(Always Show toggled, alpha edits, entering/leaving a vehicle). Active casts keep their own render.
function TRB.Functions.TargetCastbar:RefreshVisibility()
	for _, u in ipairs(UNITS) do
		local model = TRB.Data[u.modelKey]
		if (model == nil or not model:IsActive()) and fadeStart[u.groupKey] == nil then
			ApplyInactiveState(u.groupKey)
			TRB.Functions.BarVisibility:MarkDirty()
		end
	end
	SyncUpdater()
end

-- ============================================================================
-- Per-frame updater: self-heals active, fading, and idle bars (these bars aren't in ProcessBars, so a
-- render transition hides every group; only self-healing restores them). The active fill self-animates
-- via SetTimerDuration; the countdown text flows through the shared bar-text pipeline.
-- ============================================================================
updaterFrame:SetScript("OnUpdate", function(_, sinceLastUpdate)
	local anyActive = false
	local needsUpdater = false
	local now = GetTime()

	-- 20Hz throttle: the expensive per-unit work (GetBarConfig -> GetActiveSettings, the condition checks,
	-- and the color re-assert) runs on the tick; between ticks a cheap alpha/visibility self-heal keeps the
	-- native-fill bar healed against render transitions. The fade interpolation stays per-frame for
	-- smoothness (it uses the cheap cached visibility, not a settings re-resolve).
	updaterSinceLastUpdate = updaterSinceLastUpdate + (sinceLastUpdate or 0)
	local throttleTick = updaterSinceLastUpdate >= UPDATER_THROTTLE
	if throttleTick then
		updaterSinceLastUpdate = 0
	end

	for _, u in ipairs(UNITS) do
		local model = TRB.Data[u.modelKey]
		-- Resolve settings only on the throttle tick; between ticks reuse the cached visibility.
		local visibility
		if throttleTick then
			_, _, _, visibility = GetBarConfig(u.groupKey)
			cachedVisibility[u.groupKey] = visibility
		else
			visibility = cachedVisibility[u.groupKey]
		end
		if model ~= nil and model:IsActive() then
			if throttleTick and not IsStateAllowed(visibility, model.state) then
				-- Bar disabled (Never Show / nothing checked) or this cast type isn't an enabled condition:
				-- render nothing even though the model keeps tracking, so a disabled bar never flashes an
				-- empty frame while the unit casts. Mirrors BeginRender's inactive path; the updater then
				-- self-hides once no bar needs it. Evaluated on the tick; the resulting hidden/inactive state
				-- persists between ticks (cachedActiveAlpha not set, so the cheap path is skipped below).
				forceHidden[u.groupKey] = nil
				cachedActiveAlpha[u.groupKey] = nil
				ApplyInactiveState(u.groupKey)
			elseif not throttleTick and not IsStateAllowed(visibility, model.state) then
				-- Between ticks with the last tick having disabled this bar: leave it as the tick left it.
			else
				needsUpdater = true
				if throttleTick and IsForceHidden(visibility) then
					-- Hard-hide (In Vehicle) mid-cast: hide but keep tracking so it reappears when it clears.
					forceHidden[u.groupKey] = true
					cachedActiveAlpha[u.groupKey] = nil
					ApplyHiddenState(u.groupKey)
				elseif forceHidden[u.groupKey] then
					if throttleTick then
						-- Just cleared the hard-hide: rebind the native fill timer (ApplyHiddenState cleared it).
						forceHidden[u.groupKey] = nil
						anyActive = true
						ApplyVisibleState(u.groupKey, model)
					end
					-- Between ticks while still force-hidden: leave hidden until the next tick re-checks.
				elseif throttleTick then
					anyActive = true
					ReassertVisibility(u.groupKey, model)
				elseif cachedActiveAlpha[u.groupKey] ~= nil then
					-- Between ticks, bar was visible at the last tick: cheap alpha/visibility self-heal only.
					anyActive = true
					ReassertVisibilityCheap(u.groupKey)
				end
			end
		elseif fadeStart[u.groupKey] ~= nil then
			-- Fading out after a cast: hold for fadeDelay, then interpolate activeAlpha -> idleAlpha.
			needsUpdater = true
			local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
			local idleAlpha = GetIdleAlpha(visibility)
			local delay = (visibility and visibility.fadeDelay) or 0
			local duration = (visibility and visibility.fadeDuration) or 0
			local elapsed = now - fadeStart[u.groupKey]
			if elapsed >= delay + duration then
				fadeStart[u.groupKey] = nil
				ApplyInactiveState(u.groupKey)
			else
				local alpha = activeAlpha
				if elapsed > delay and duration > 0 then
					alpha = activeAlpha + (idleAlpha - activeAlpha) * ((elapsed - delay) / duration)
				end
				local group = GetGroupNode(u.groupKey)
				if group ~= nil then
					group.targetAlpha = alpha
					group.currentAlpha = alpha
					if not group.isVisible then
						group:Show()
					end
					if group.containerFrame then
						group.containerFrame:SetAlpha(alpha)
					end
				end
			end
		elseif throttleTick then
			-- Idle Always Show / inactive-alpha bar: full re-assert on the tick (resolves idle alpha, which
			-- hits the Unit condition APIs, plus the color re-assert inside ApplyIdleState). Cache the alpha so
			-- between-tick frames can cheaply self-heal without re-resolving.
			local idleAlpha = GetIdleAlpha(visibility)
			if idleAlpha > 0 and UnitExists(u.unit) then
				needsUpdater = true
				cachedIdleAlpha[u.groupKey] = idleAlpha
				ApplyIdleState(u.groupKey, idleAlpha)
			else
				cachedIdleAlpha[u.groupKey] = nil
			end
		elseif cachedIdleAlpha[u.groupKey] ~= nil then
			-- Between ticks, an idle bar was resting visible at the last tick: cheap alpha/visibility self-heal.
			needsUpdater = true
			local group, node = GetGroupNode(u.groupKey)
			local idleAlpha = cachedIdleAlpha[u.groupKey]
			if group ~= nil then
				group.targetAlpha = idleAlpha
				group.currentAlpha = idleAlpha
				if not group.isVisible then
					group:Show()
					TRB.Functions.BarVisibility:MarkDirty()
				end
				if node ~= nil then
					node:Show()
				end
				if group.containerFrame then
					group.containerFrame:SetAlpha(idleAlpha)
				end
			end
		end
	end
	if anyActive then
		-- Keep the shared bar-text pipeline refreshing so $target/$focus remaining ticks down.
		TRB.Data.lookupDirty = true
	end
	if not needsUpdater then
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
		-- Freeze the fill where it stopped BEFORE Stop() wipes the model: the native SetTimerDuration
		-- animation would otherwise keep advancing the fill (and end cap) on its own through the fade-out.
		FreezeFill(entry.groupKey, model)
		model:Stop()
		BeginFadeOut(entry.groupKey)
	elseif event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		-- The DurationObject reflects the new timing automatically; just re-assert the render -- but only
		-- when this bar + cast type is actually allowed to show, so a disabled bar stays hidden.
		local _, _, _, visibility = GetBarConfig(entry.groupKey)
		if model:IsActive() and IsStateAllowed(visibility, model.state) then
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
	fadeStart[entry.groupKey] = nil
	if UnitExists(entry.unit) and model:SyncFromUnit() then
		BeginRender(entry.groupKey, model)
	else
		-- No unit or no in-progress cast: resolve to the idle bar (Always Show) or fully hidden. No fade --
		-- there was no cast on this unit to fade out.
		ApplyInactiveState(entry.groupKey)
		TRB.Functions.BarVisibility:MarkDirty()
		SyncUpdater()
	end
	TRB.Functions.BarText:MarkLookupDirty()
end

local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnEvent", function(_, event, unit, _, spellId)
	if event == "PLAYER_TARGET_CHANGED" then
		OnUnitChanged(UNITS[1])
	elseif event == "PLAYER_FOCUS_CHANGED" then
		OnUnitChanged(UNITS[2])
	elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
		-- Player vehicle state gates the In Vehicle hard-hide condition; re-resolve idle bars (active bars
		-- pick it up on the next updater frame).
		TRB.Functions.TargetCastbar:RefreshVisibility()
	else
		OnUnitEvent(unit, event, spellId)
	end
end)

---Registers all events to begin tracking target + focus casts, then resolves the initial idle display.
function TRB.Functions.TargetCastbar:Enable()
	for _, e in ipairs({ "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_DELAYED",
		"UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_UPDATE", "UNIT_SPELLCAST_CHANNEL_STOP",
		"UNIT_SPELLCAST_EMPOWER_START", "UNIT_SPELLCAST_EMPOWER_STOP", "UNIT_SPELLCAST_INTERRUPTED" }) do
		eventFrame:RegisterUnitEvent(e, "target", "focus")
	end
	eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	eventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
	eventFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	eventFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	-- Show any Always Show idle bar immediately (e.g. a target already selected at login/spec change).
	self:RefreshVisibility()
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
