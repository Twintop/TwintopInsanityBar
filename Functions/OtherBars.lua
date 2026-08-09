---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OtherBars = {}

--[[
	Functions.OtherBars: render + event bridge for the all-spec timer bars on the "Other Bars" screen.

	Two kinds live here, sharing one updater and one visibility model:

	  * Global Cooldown -- the fill is bound to the DurationObject for Blizzard's dummy GCD spell (61304)
	    via StatusBar:SetTimerDuration, so it animates natively even when the cooldown values are secret.
	    The cooldown API is read only on events that start a GCD or end one early; never polled.

	  * Fatigue / Breath / Feign Death -- the three mirror timers Blizzard groups under Edit Mode's
	    "Duration Bars". GetMirrorTimerInfo / GetMirrorTimerProgress are not secret, so these fill from
	    plain numbers. Pause falls out for free: a paused timer stops advancing its progress.

	Like the cast bars these are NOT in BarVisibility:ProcessBars, so the updater re-asserts
	alpha/visibility while a bar is on screen to self-heal after render transitions.
]]

-- Blizzard's dummy GCD spell. Its cooldown is the global cooldown; no real spell's cooldown may be read.
local GCD_SPELL_ID = 61304

-- Bar key -> kind + (for mirror timers) the timer name GetMirrorTimerInfo reports. The four timer names
-- are the ones in Blizzard's own MirrorTimerAtlas.
local BARS = {
	{ key = "gcd", kind = "gcd" },
	{ key = "fatigue", kind = "mirror", timerName = "EXHAUSTION" },
	{ key = "breath", kind = "mirror", timerName = "BREATH" },
	{ key = "feignDeath", kind = "mirror", timerName = "FEIGNDEATH" },
}
local BAR_BY_TIMER_NAME = {}
for _, b in ipairs(BARS) do
	if b.timerName ~= nil then
		BAR_BY_TIMER_NAME[b.timerName] = b
	end
end

-- Blizzard exposes three pooled mirror timer frames; GetMirrorTimerInfo indexes the same range.
local MIRROR_TIMER_COUNT = 3

-- Per-bar live state. `active` drives the updater; mirror bars also carry their scale (max value in
-- seconds) so the node's min/max is set once per timer rather than every frame.
local active = {}
local mirrorMax = {}
-- The DurationObject currently bound to the GCD node, or nil.
local gcdDuration = nil
-- GetTime() the running GCD is expected to end. Its length is known at the start, so this is the stop
-- signal -- no per-frame read of the cooldown API.
local gcdExpiry = nil
-- Post-timer fade timers keyed by bar key: GetTime() when the fade began, or nil when not fading.
local fadeStart = {}
-- Bars force-hidden (In Vehicle / Dead) mid-timer, so clearing the condition rebinds the native fill.
local forceHidden = {}
-- Per-bar cache of the last throttle tick's resolved idle alpha, so between-tick frames can self-heal an
-- Always Show bar without re-resolving settings. nil means nothing was resting visible at the last tick.
local cachedIdleAlpha = {}
-- Per-bar cache of the last throttle tick's resolved visibility table, reused by the between-tick frames
-- (fade interpolation, mirror fill) so settings are resolved at 20Hz rather than every frame.
local cachedVisibility = {}

local updaterFrame = CreateFrame("Frame")
updaterFrame:Hide()

-- 20Hz throttle for the expensive per-bar work (settings resolution + colors), matching the cast bars.
-- The GCD's native fill animates on its own between ticks; the mirror bars' SetValue runs every frame
-- since GetMirrorTimerProgress is a cheap, non-secret read.
local UPDATER_THROTTLE = 0.05
local updaterSinceLastUpdate = UPDATER_THROTTLE

local function ForceThrottleTick()
	updaterSinceLastUpdate = UPDATER_THROTTLE
end

---Returns the composed active display settings, or nil.
local function GetActiveSettings()
	return TRB.Functions.Class:GetActiveDisplaySettings()
end

---Returns the bar settings / colors / visibility for a bar key from composed settings.
---@param barKey string
---@return table? barSettings, table? colors, table? visibility
local function GetBarConfig(barKey)
	local settings = GetActiveSettings()
	if settings == nil then
		return nil, nil, nil
	end
	local barSettings = settings.bars and settings.bars[barKey]
	local colors = settings.colors and settings.colors.bars and settings.colors.bars[barKey]
	local visibility = settings.displayBar and settings.displayBar[barKey]
	return barSettings, colors, visibility
end

---Whether the bar is enabled at all: not Never Show, and something could still make it appear -- either
---Always Show, or the "When Active" condition that shows it while its timer runs. Mirrors the cast bars'
---IsEnabled, which counts a bar with every cast state unticked as disabled.
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
	return conditions.whenActive == true
end

---Public wrapper over IsEnabled. Layout consults this to collapse a disabled bar's reserved space.
---@param visibility table?
---@return boolean
function TRB.Functions.OtherBars:IsEnabled(visibility)
	return IsEnabled(visibility)
end

-- Environment snapshot the hide conditions are evaluated against, plus the scratch entry
-- ShouldForceHideBar reads the settings from. Both are reused rather than rebuilt per bar.
local hideContext = nil
local hideContextTime = nil
local hideEntry = {}

---Returns the shared environment snapshot, rebuilt at most once per frame. These bars evaluate the full
---standard hide-condition set (mounts, skyriding, taxi, pet battle, Druid forms, ...), which is far more
---than the cast bars' pair of live API reads, so the four bars share one build instead of each doing
---their own. GetTime() is constant within a frame, which makes it an exact cache key.
---@return TRB.Classes.BarVisibilityContext
local function GetHideContext()
	local now = GetTime()
	if hideContextTime ~= now or hideContext == nil then
		hideContext = TRB.Classes.BarVisibilityContext:NewFromGameState(false, nil)
		hideContextTime = now
	end
	return hideContext
end

---Whether a hard-hide condition currently suppresses the bar. The timer keeps running while
---force-hidden so the bar reappears mid-timer when the condition clears (mirrors the cast bars).
---@param visibility table?
---@return boolean
local function IsForceHidden(visibility)
	if visibility == nil or visibility.hideConditions == nil then
		return false
	end
	hideEntry.visibilitySettings = visibility
	return TRB.Functions.BarVisibility:ShouldForceHideBar(GetHideContext(), hideEntry)
end

---Container alpha the bar would rest at while its timer is idle, ignoring hide conditions: activeAlpha
---when Always Show, else inactiveAlpha.
---@param visibility table?
---@return number # 0..1
local function GetRestingAlpha(visibility)
	if visibility == nil or not IsEnabled(visibility) then
		return 0
	end
	if visibility.alwaysShow then
		return ((visibility.activeAlpha) or 100) / 100
	end
	return ((visibility.inactiveAlpha) or 0) / 100
end

---Container alpha to rest at while the timer is idle, 0 while a hide condition applies.
---@param visibility table?
---@return number # 0..1
local function GetIdleAlpha(visibility)
	if IsForceHidden(visibility) then
		return 0
	end
	return GetRestingAlpha(visibility)
end

---Returns the bar group + single node for a bar key, or nils.
---@param barKey string
---@return TRB.Classes.BarGroup?, TRB.Classes.BarNode?
local function GetGroupNode(barKey)
	local barGroups = TRB.Frames.barGroups
	local group = barGroups and barGroups[barKey] or nil
	local node = group and group:GetNode(1) or nil
	return group, node
end

---Applies the configured fill, border, background and end cap colors. These bars are not Color
---Indicator targets (nothing declares them in a spec's barTargetDefs), so the configured colors are
---the whole story.
---@param node TRB.Classes.BarNode
---@param colors table?
local function ApplyColors(node, colors)
	if colors == nil then
		return
	end
	local fill = colors.bar
	if fill ~= nil then
		if fill.gradientDirection ~= nil and fill.gradientDirection ~= "disabled" and fill.color2 ~= nil then
			node:SetColorGradient(fill.color, fill.color2, fill.gradientDirection)
		else
			node:SetColor(fill.color)
		end
	end
	if colors.border ~= nil then
		node:SetBorderColor(colors.border.color)
	end
	if colors.background ~= nil then
		node:SetBackgroundColorFromString(colors.background.color)
	end
	node:ApplyEndCap(colors.endCap, colors.border and colors.border.color)
end

---Shows a bar's group/node at the given alpha, marking visibility dirty on a hidden->visible flip.
---@param group TRB.Classes.BarGroup
---@param node TRB.Classes.BarNode?
---@param alpha number
local function ShowAt(group, node, alpha)
	group.targetAlpha = alpha
	group.currentAlpha = alpha
	if not group.isVisible then
		group:Show()
		TRB.Functions.BarVisibility:MarkDirty()
	end
	if node ~= nil then
		node:Show()
	end
	if group.containerFrame then
		group.containerFrame:SetAlpha(alpha)
	end
end

---Binds the GCD node's fill to the live DurationObject. "deplete" (the default) drains a full bar as
---the GCD runs down; "fill" grows an empty one left to right.
---@param node TRB.Classes.BarNode
---@param barSettings table?
local function BindGcdFill(node, barSettings)
	node:SetMinMax(0, 1)
	if gcdDuration == nil or node.SetTimerDuration == nil then
		node:SetValue(0)
		return
	end
	local direction = Enum.StatusBarTimerDirection.RemainingTime
	if barSettings ~= nil and barSettings.timerDirection == "fill" then
		direction = Enum.StatusBarTimerDirection.ElapsedTime
	end
	node:SetTimerDuration(gcdDuration, Enum.StatusBarInterpolation.Immediate, direction)
end

---Writes a mirror timer's current progress into its node. Values are plain seconds (the API reports
---milliseconds), so this is ordinary arithmetic -- no secrets involved. A paused timer simply stops
---reporting new progress, which freezes the fill for free.
---@param node TRB.Classes.BarNode
---@param entry table # The BARS entry
local function UpdateMirrorFill(node, entry)
	local max = mirrorMax[entry.key]
	if max == nil then
		return
	end
	node:SetMinMax(0, max)
	local progress = GetMirrorTimerProgress(entry.timerName)
	if progress == nil then
		return
	end
	node:SetValue(progress / 1000)
end

---Applies the full visible render for a running timer: fill, colors, alpha, Show.
---@param entry table # The BARS entry
local function ApplyVisibleState(entry)
	local group, node = GetGroupNode(entry.key)
	if group == nil or node == nil then
		return
	end
	local barSettings, colors, visibility = GetBarConfig(entry.key)

	if entry.kind == "gcd" then
		BindGcdFill(node, barSettings)
	else
		UpdateMirrorFill(node, entry)
	end
	ApplyColors(node, colors)

	ShowAt(group, node, ((visibility and visibility.activeAlpha) or 100) / 100)
end

---Re-asserts colors and alpha WITHOUT re-binding the GCD's native timer (re-calling SetTimerDuration
---every tick would restart the fill animation). Mirror bars refresh their value here too.
---@param entry table # The BARS entry
local function ReassertVisibility(entry)
	local group, node = GetGroupNode(entry.key)
	if group == nil or node == nil then
		return
	end
	local _, colors, visibility = GetBarConfig(entry.key)
	if entry.kind ~= "gcd" then
		UpdateMirrorFill(node, entry)
	end
	ApplyColors(node, colors)
	ShowAt(group, node, ((visibility and visibility.activeAlpha) or 100) / 100)
end

---Applies the fully-hidden state for a bar.
---@param barKey string
local function ApplyHiddenState(barKey)
	local group, node = GetGroupNode(barKey)
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

---Rests a bar at its idle display: an empty frame at the idle alpha (Always Show), or fully hidden.
---@param barKey string
local function ApplyInactiveState(barKey)
	local group, node = GetGroupNode(barKey)
	if group == nil or node == nil then
		return
	end
	local _, colors, visibility = GetBarConfig(barKey)
	local idleAlpha = GetIdleAlpha(visibility)
	if idleAlpha <= 0 then
		ApplyHiddenState(barKey)
		return
	end
	-- Release any native timer still bound so the manual SetValue(0) actually rests the bar empty.
	if node.ClearTimerDuration ~= nil then
		node:ClearTimerDuration()
	end
	node:SetMinMax(0, 1)
	node:SetValue(0)
	ApplyColors(node, colors)
	ShowAt(group, node, idleAlpha)
end

---Whether any bar still needs the per-frame updater. Deliberately asks GetRestingAlpha rather than
---GetIdleAlpha: a bar that rests visible but is currently force-hidden must keep the updater alive, or
---mounting would shut it down and dismounting would never bring the bar back.
---@return boolean
local function NeedsUpdater()
	for _, entry in ipairs(BARS) do
		if active[entry.key] or fadeStart[entry.key] ~= nil then
			return true
		end
		local _, _, visibility = GetBarConfig(entry.key)
		if GetRestingAlpha(visibility) > 0 then
			return true
		end
	end
	return false
end

local function SyncUpdater()
	if NeedsUpdater() then
		ForceThrottleTick()
		updaterFrame:Show()
	else
		updaterFrame:Hide()
	end
end

---Begins showing a bar for a freshly-started timer.
---@param entry table # The BARS entry
local function BeginRender(entry)
	fadeStart[entry.key] = nil
	local _, _, visibility = GetBarConfig(entry.key)
	if not IsEnabled(visibility) then
		forceHidden[entry.key] = nil
		ApplyInactiveState(entry.key)
		TRB.Functions.BarVisibility:MarkDirty()
		SyncUpdater()
		return
	end
	if IsForceHidden(visibility) then
		forceHidden[entry.key] = true
		ApplyHiddenState(entry.key)
	else
		forceHidden[entry.key] = nil
		ApplyVisibleState(entry)
	end
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

---Begins the post-timer fade-out honoring fadeDelay/fadeDuration, resting at the idle alpha when done.
---@param barKey string
local function BeginFadeOut(barKey)
	forceHidden[barKey] = nil
	local _, _, visibility = GetBarConfig(barKey)
	local delay = (visibility and visibility.fadeDelay) or 0
	local duration = (visibility and visibility.fadeDuration) or 0
	if not IsEnabled(visibility) or IsForceHidden(visibility) or (delay <= 0 and duration <= 0 and GetIdleAlpha(visibility) <= 0) then
		fadeStart[barKey] = nil
		ApplyInactiveState(barKey)
	else
		fadeStart[barKey] = GetTime()
	end
	TRB.Functions.BarVisibility:MarkDirty()
	SyncUpdater()
end

---Ends a bar's timer and starts its fade-out.
---@param entry table # The BARS entry
local function StopTimer(entry)
	if not active[entry.key] then
		return
	end
	active[entry.key] = false
	if entry.kind == "gcd" then
		gcdDuration = nil
		gcdExpiry = nil
		-- Release the native fill straight away. An expired ElapsedTime binding rests FULL, so a "grow"
		-- bar would otherwise sit at 100% for the whole fade-out; ClearTimerDuration rests it empty.
		local _, node = GetGroupNode(entry.key)
		if node ~= nil and node.ClearTimerDuration ~= nil then
			node:ClearTimerDuration()
		end
	else
		mirrorMax[entry.key] = nil
	end
	BeginFadeOut(entry.key)
end

-- ============================================================================
-- Global Cooldown
-- ============================================================================

---Reads the GCD's DurationObject handle. This is the fill source only: the handle comes back whether or
---not a cooldown is running, and a finished one still animates (an ElapsedTime binding rests FULL), so it
---can never be the signal for whether the bar should be up.
---@return any?
local function ReadGcdDurationObject()
	if C_Spell == nil or C_Spell.GetSpellCooldownDuration == nil then
		return nil
	end
	return C_Spell.GetSpellCooldownDuration(GCD_SPELL_ID)
end

---Whether a global cooldown is running, as far as the readable APIs can say. Same source the snapshot's
---GCD lock uses: plain numbers when they are readable, secret in restricted content.
---@return boolean? # true/false when readable, nil when the values are secret
local function IsGcdRunningReadable()
	if C_Spell == nil or C_Spell.GetSpellCooldown == nil then
		return nil
	end
	local cooldown = C_Spell.GetSpellCooldown(GCD_SPELL_ID)
	if cooldown == nil then
		return false
	end
	local startTime, duration = cooldown.startTime, cooldown.duration
	if issecretvalue(startTime) or issecretvalue(duration) then
		return nil
	end
	if startTime == nil or duration == nil or duration <= 0 then
		return false
	end
	return (startTime + duration) > GetTime()
end

---How long the GCD that just started runs for. Prefers the duration object's own total, which is exact,
---and falls back to the addon's tracked GCD length when that total is secret.
---@param durationObject any?
---@return number
local function ReadGcdLength(durationObject)
	if durationObject ~= nil and durationObject.GetTotalDuration ~= nil then
		local total = durationObject:GetTotalDuration()
		if not issecretvalue(total) and total ~= nil and total > 0 then
			return total
		end
	end
	return TRB.Functions.Character:GetCurrentGCDTime()
end

---Whether the GCD the bar is showing is still running, from the expiry recorded at its start. Runs on the
---updater tick, so it must stay API-free.
---@return boolean
local function IsGcdStillRunning()
	return gcdExpiry ~= nil and GetTime() < gcdExpiry
end

---Picks up a global cooldown that just started. Cheap enough to run on every cast: one API read plus a
---structural check. Re-binds unconditionally, so a fresh GCD from the next cast replaces the one still
---on screen rather than letting the old animation run out.
---@param fromCast boolean? # True when a cast event triggered this, which is itself proof a GCD started
local function CheckGcdStart(fromCast)
	-- SPELL_UPDATE_COOLDOWN fires constantly during a GCD, and nothing can start one while another runs.
	if not fromCast and IsGcdStillRunning() then
		return
	end
	local entry = BARS[1]
	local _, _, visibility = GetBarConfig(entry.key)
	if not IsEnabled(visibility) then
		return
	end
	local readable = IsGcdRunningReadable()
	if readable == false then
		return
	end
	-- Secret cooldown values: SPELL_UPDATE_COOLDOWN fires for every cooldown in the game and can't be
	-- read, so only a cast event is evidence that a GCD actually began.
	if readable == nil and not fromCast then
		return
	end
	local duration = ReadGcdDurationObject()
	if duration == nil then
		return
	end
	gcdDuration = duration
	gcdExpiry = GetTime() + ReadGcdLength(duration)
	active[entry.key] = true
	BeginRender(entry)
end

---Ends the bar early when a failed cast turns out not to have started a GCD. One API read per failure; a
---failure during a real GCD, or a secret cooldown, leaves the expiry to stand.
local function CheckGcdStop()
	local entry = BARS[1]
	if not active[entry.key] then
		return
	end
	if IsGcdRunningReadable() == false then
		StopTimer(entry)
	end
end

-- ============================================================================
-- Mirror timers (Fatigue / Breath / Feign Death)
-- ============================================================================

---Starts (or refreshes) a mirror timer bar from event/query values. Values arrive in milliseconds.
---@param timerName string
---@param maxValue number
local function StartMirrorTimer(timerName, maxValue)
	local entry = BAR_BY_TIMER_NAME[timerName]
	if entry == nil then
		return
	end
	mirrorMax[entry.key] = (maxValue or 0) / 1000
	active[entry.key] = true
	BeginRender(entry)
	TRB.Functions.OtherBars:UpdateBlizzardMirrorTimerVisibility()
end

---Picks up any mirror timer already running (zoning in mid-swim, /reload while fatigued), and drops any
---the game has stopped reporting. A STOP event can be missed across a zone change or a death, and a bar
---left active with no timer behind it would sit on screen for the rest of the session.
local function SyncMirrorTimers()
	if GetMirrorTimerInfo == nil then
		return
	end
	local running = {}
	for i = 1, MIRROR_TIMER_COUNT do
		local timerName, _, maxValue = GetMirrorTimerInfo(i)
		if timerName ~= nil and timerName ~= "UNKNOWN" then
			running[timerName] = true
			StartMirrorTimer(timerName, maxValue)
		end
	end
	for _, entry in ipairs(BARS) do
		if entry.kind == "mirror" and active[entry.key] and not running[entry.timerName] then
			StopTimer(entry)
		end
	end
end

-- ============================================================================
-- Blizzard "Duration Bars" suppression
-- ============================================================================

-- Blizzard pools three anonymous MirrorTimer frames and hands whichever is free to whichever timer type
-- fires, so there is no per-type Edit Mode toggle to switch off. Each frame does stamp `.timer` with its
-- type in Setup, though, so post-hooking UpdateShownState lets us suppress only the types we render.
local mirrorHooksInstalled = false

---Whether we are replacing a given mirror timer type right now: the bar is enabled and its
---"hide Blizzard's" option is on.
---@param timerName string?
---@return boolean
local function ShouldSuppressBlizzardTimer(timerName)
	local entry = timerName ~= nil and BAR_BY_TIMER_NAME[timerName] or nil
	if entry == nil then
		return false
	end
	local barSettings, _, visibility = GetBarConfig(entry.key)
	return barSettings ~= nil and barSettings.disableBlizzardBar == true and IsEnabled(visibility)
end

---Re-evaluates every Blizzard mirror timer frame against the current settings. Restoring calls the
---frame's own UpdateShownState so Blizzard stays authoritative over whether it should be up at all.
function TRB.Functions.OtherBars:UpdateBlizzardMirrorTimerVisibility()
	local container = MirrorTimerContainer
	if container == nil or container.mirrorTimers == nil then
		return
	end
	for _, frame in ipairs(container.mirrorTimers) do
		if ShouldSuppressBlizzardTimer(frame.timer) then
			frame:Hide()
		elseif frame.UpdateShownState ~= nil then
			frame:UpdateShownState()
		end
	end
end

---Post-hooks each pooled Blizzard mirror timer frame so a type we have taken over stays hidden even
---after Blizzard re-shows it (a new timer starting, an Edit Mode relayout).
local function InstallMirrorTimerHooks()
	if mirrorHooksInstalled then
		return
	end
	local container = MirrorTimerContainer
	if container == nil or container.mirrorTimers == nil then
		return
	end
	for _, frame in ipairs(container.mirrorTimers) do
		if frame.UpdateShownState ~= nil then
			hooksecurefunc(frame, "UpdateShownState", function(self)
				if ShouldSuppressBlizzardTimer(self.timer) then
					self:Hide()
				end
			end)
		end
	end
	mirrorHooksInstalled = true
end

-- ============================================================================
-- Per-frame updater
-- ============================================================================
updaterFrame:SetScript("OnUpdate", function(_, sinceLastUpdate)
	local needsUpdater = false
	local now = GetTime()

	updaterSinceLastUpdate = updaterSinceLastUpdate + (sinceLastUpdate or 0)
	local throttleTick = updaterSinceLastUpdate >= UPDATER_THROTTLE
	if throttleTick then
		updaterSinceLastUpdate = 0
	end

	for _, entry in ipairs(BARS) do
		local barKey = entry.key
		-- Resolving settings is throttle-tick work; between ticks reuse the cached visibility so an
		-- active bar costs only its fill update.
		local visibility
		if throttleTick then
			visibility = select(3, GetBarConfig(barKey))
			cachedVisibility[barKey] = visibility
		else
			visibility = cachedVisibility[barKey]
		end

		if active[barKey] then
			-- Nothing announces the end of a GCD, so only it needs an expiry check -- a timestamp compare.
			if throttleTick and entry.kind == "gcd" and not IsGcdStillRunning() then
				StopTimer(entry)
			else
				needsUpdater = true
				if throttleTick and not IsEnabled(visibility) then
					ApplyInactiveState(barKey)
				elseif throttleTick and IsForceHidden(visibility) then
					forceHidden[barKey] = true
					ApplyHiddenState(barKey)
				elseif forceHidden[barKey] then
					if throttleTick then
						-- Hard-hide just cleared: rebind the fill that ApplyHiddenState released.
						forceHidden[barKey] = nil
						ApplyVisibleState(entry)
					end
					-- Between ticks while still force-hidden: leave it as the tick left it.
				elseif throttleTick then
					ReassertVisibility(entry)
				elseif entry.kind ~= "gcd" then
					-- Between ticks a mirror bar still advances its own fill; the GCD's is native.
					local _, node = GetGroupNode(barKey)
					if node ~= nil then
						UpdateMirrorFill(node, entry)
					end
				end
			end
		elseif fadeStart[barKey] ~= nil then
			needsUpdater = true
			local activeAlpha = ((visibility and visibility.activeAlpha) or 100) / 100
			local idleAlpha = GetIdleAlpha(visibility)
			local delay = (visibility and visibility.fadeDelay) or 0
			local duration = (visibility and visibility.fadeDuration) or 0
			local elapsed = now - fadeStart[barKey]
			if elapsed >= delay + duration then
				fadeStart[barKey] = nil
				ApplyInactiveState(barKey)
			else
				local alpha = activeAlpha
				if elapsed > delay and duration > 0 then
					alpha = activeAlpha + (idleAlpha - activeAlpha) * ((elapsed - delay) / duration)
				end
				local group, node = GetGroupNode(barKey)
				if group ~= nil then
					ShowAt(group, node, alpha)
				end
			end
		elseif throttleTick then
			-- Idle Always Show bar: re-assert on the tick so it self-heals after a render transition, and
			-- cache the resolved alpha so between-tick frames needn't re-resolve settings at all. The
			-- re-assert is unconditional because it is also what takes a resting bar off screen the moment
			-- a hide condition starts applying -- mounting up, boarding a taxi, shifting form.
			local idleAlpha = GetIdleAlpha(visibility)
			ApplyInactiveState(barKey)
			if idleAlpha > 0 then
				needsUpdater = true
				cachedIdleAlpha[barKey] = idleAlpha
			else
				cachedIdleAlpha[barKey] = nil
			end
		elseif cachedIdleAlpha[barKey] ~= nil then
			-- Between ticks with an idle bar resting visible: cheap alpha/visibility self-heal only.
			needsUpdater = true
			local group, node = GetGroupNode(barKey)
			if group ~= nil then
				ShowAt(group, node, cachedIdleAlpha[barKey])
			end
		end
	end

	-- Re-ask rather than trusting the flag: StopTimer runs INSIDE this loop and can hand a bar over to a
	-- fade-out that no branch has counted yet. Hiding on the stale flag would strand that bar at full
	-- alpha with nothing left running to fade it out -- a bar that shows once and never goes away.
	if not needsUpdater then
		SyncUpdater()
	end
end)

-- ============================================================================
-- Event routing
-- ============================================================================

local eventFrame = CreateFrame("Frame")
-- MIRROR_TIMER_START payload: timer, value, maxvalue, scale, paused, label. Only the type and the max
-- are needed; live progress comes from GetMirrorTimerProgress each frame.
eventFrame:SetScript("OnEvent", function(_, event, timerName, _, maxValue)
	if event == "MIRROR_TIMER_START" then
		StartMirrorTimer(timerName, maxValue)
	elseif event == "MIRROR_TIMER_STOP" then
		local entry = BAR_BY_TIMER_NAME[timerName]
		if entry ~= nil then
			StopTimer(entry)
			TRB.Functions.OtherBars:UpdateBlizzardMirrorTimerVisibility()
		end
	elseif event == "MIRROR_TIMER_PAUSE" then
		-- A paused timer stops advancing GetMirrorTimerProgress on its own, so the fill freezes without
		-- any extra bookkeeping. Nothing to do beyond keeping the bar on screen.
	elseif event == "PLAYER_ENTERING_WORLD" then
		InstallMirrorTimerHooks()
		SyncMirrorTimers()
		TRB.Functions.OtherBars:RefreshVisibility()
	elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
		TRB.Functions.OtherBars:RefreshVisibility()
	elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" then
		CheckGcdStop()
	else
		-- SPELL_UPDATE_COOLDOWN / UNIT_SPELLCAST_SUCCEEDED: a global cooldown may have just started.
		CheckGcdStart(event == "UNIT_SPELLCAST_SUCCEEDED")
	end
end)

---Re-resolves the idle/hidden display for every inactive bar after a settings or environment change,
---and re-applies Blizzard Duration Bar suppression. Running timers keep their own render.
function TRB.Functions.OtherBars:RefreshVisibility()
	for _, entry in ipairs(BARS) do
		if not active[entry.key] and fadeStart[entry.key] == nil then
			ApplyInactiveState(entry.key)
			TRB.Functions.BarVisibility:MarkDirty()
		end
	end
	self:UpdateBlizzardMirrorTimerVisibility()
	SyncUpdater()
end

---Registers the events these bars need, then resolves the initial display. The GCD events are the only
---high-frequency ones, so they are registered only while that bar is enabled.
function TRB.Functions.OtherBars:Enable()
	eventFrame:RegisterEvent("MIRROR_TIMER_START")
	eventFrame:RegisterEvent("MIRROR_TIMER_STOP")
	eventFrame:RegisterEvent("MIRROR_TIMER_PAUSE")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	eventFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	self:SyncGcdEvents()

	InstallMirrorTimerHooks()
	SyncMirrorTimers()
	self:RefreshVisibility()
end

---Registers or drops the GCD-start events to match whether the GCD bar is enabled, so a user who never
---turns it on pays nothing for SPELL_UPDATE_COOLDOWN.
function TRB.Functions.OtherBars:SyncGcdEvents()
	local _, _, visibility = GetBarConfig("gcd")
	if IsEnabled(visibility) then
		eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
		eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
		eventFrame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED_QUIET", "player")
	else
		eventFrame:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
		eventFrame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		eventFrame:UnregisterEvent("UNIT_SPELLCAST_FAILED")
		eventFrame:UnregisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
	end
end

---Unregisters everything and tears down every bar.
function TRB.Functions.OtherBars:Disable()
	eventFrame:UnregisterAllEvents()
	for _, entry in ipairs(BARS) do
		active[entry.key] = false
		fadeStart[entry.key] = nil
		forceHidden[entry.key] = nil
		mirrorMax[entry.key] = nil
		ApplyHiddenState(entry.key)
	end
	gcdDuration = nil
	gcdExpiry = nil
	updaterFrame:Hide()
	self:UpdateBlizzardMirrorTimerVisibility()
end

---The bar keys this module renders, in tab order.
---@return table[]
function TRB.Functions.OtherBars:GetBars()
	return BARS
end

---Whether a given bar's timer is currently running.
---@param barKey string
---@return boolean
function TRB.Functions.OtherBars:IsBarActive(barKey)
	return active[barKey] == true
end

---Whether any Other Bar's timer is running. Bar text uses this to decide whether a per-frame refresh
---is worth doing at all.
---@return boolean
function TRB.Functions.OtherBars:HasActiveTimer()
	for _, entry in ipairs(BARS) do
		if active[entry.key] then
			return true
		end
	end
	return false
end

---Returns the live remaining and total seconds for a bar's timer, or nils when it isn't running.
---The mirror timers report plain numbers; the GCD's come from its DurationObject and may be SECRET,
---so callers must only nil-check and string.format them -- never compare or do arithmetic.
---@param barKey string
---@return any? remaining, any? total
function TRB.Functions.OtherBars:GetTimerValues(barKey)
	if not active[barKey] then
		return nil, nil
	end
	if barKey == "gcd" then
		if gcdDuration == nil then
			return nil, nil
		end
		return gcdDuration:GetRemainingDuration(), gcdDuration:GetTotalDuration()
	end
	local entry = nil
	for _, b in ipairs(BARS) do
		if b.key == barKey then
			entry = b
			break
		end
	end
	if entry == nil or entry.timerName == nil then
		return nil, nil
	end
	local progress = GetMirrorTimerProgress(entry.timerName)
	if progress == nil then
		return nil, mirrorMax[barKey]
	end
	return progress / 1000, mirrorMax[barKey]
end
