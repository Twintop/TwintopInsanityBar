---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OtherBars = {}

--[[
	Functions.OtherBars: render + event bridge for the all-spec timer bars on the "Other Bars" screen.

	Two kinds live here, sharing one updater and one visibility model:

	  * Global Cooldown -- the fill is bound to the DurationObject for Blizzard's dummy GCD spell (TRB.Flavor.gcdSpellId)
	    via StatusBar:SetTimerDuration, so it animates natively even when the cooldown values are secret.
	    The cooldown API is read only on events that start a GCD or end one early; never polled.

	  * Fatigue / Breath / Feign Death -- the three mirror timers Blizzard groups under Edit Mode's
	    "Duration Bars". GetMirrorTimerInfo / GetMirrorTimerProgress are not secret, so these fill from
	    plain numbers. Pause falls out for free: a paused timer stops advancing its progress.

	  * Main Hand / Off Hand / Ranged Swing -- only on a flavor that fires PLAYER_SWING, whose plain swing
	    length fills them by hand. Each only shows while its slot holds a weapon.

	Like the cast bars these are NOT in BarVisibility:ProcessBars, so the updater re-asserts
	alpha/visibility while a bar is on screen to self-heal after render transitions.
]]

-- Blizzard's dummy GCD spell. Its cooldown is the global cooldown; no real spell's cooldown may be read.
local GCD_SPELL_ID = TRB.Flavor.gcdSpellId

-- Bar key -> kind + (for mirror timers) the timer name GetMirrorTimerInfo reports. The four timer names
-- are the ones in Blizzard's own MirrorTimerAtlas.
local BARS = {
	{ key = "gcd", kind = "gcd" },
	{ key = "fatigue", kind = "mirror", timerName = "EXHAUSTION" },
	{ key = "breath", kind = "mirror", timerName = "BREATH" },
	{ key = "feignDeath", kind = "mirror", timerName = "FEIGNDEATH" },
}
-- Swing bars lead, matching the tab order; `speedIndex` picks the hand's UnitAttackSpeed return.
if TRB.Flavor.swingTimers then
	local swingEntries = {
		{ key = "mainHandSwing", kind = "swing", swingType = Enum.PlayerSwingType.MainHand, slot = INVSLOT_MAINHAND, speedIndex = 1, blizzardFrame = "SwingTimerMainHandFrame" },
		{ key = "offHandSwing", kind = "swing", swingType = Enum.PlayerSwingType.OffHand, slot = INVSLOT_OFFHAND, speedIndex = 2, blizzardFrame = "SwingTimerOffHandFrame" },
		{ key = "rangedSwing", kind = "swing", swingType = Enum.PlayerSwingType.Ranged, slot = INVSLOT_RANGED, speedIndex = 3, blizzardFrame = "SwingTimerRangedFrame" },
	}
	for index, entry in ipairs(swingEntries) do
		table.insert(BARS, index, entry)
	end
end
local BAR_BY_TIMER_NAME = {}
local BAR_BY_SWING_TYPE = {}
local BAR_BY_KEY = {}
local SWING_SLOTS = {}
for _, b in ipairs(BARS) do
	BAR_BY_KEY[b.key] = b
	if b.timerName ~= nil then
		BAR_BY_TIMER_NAME[b.timerName] = b
	end
	if b.kind == "swing" then
		BAR_BY_SWING_TYPE[b.swingType] = b
		SWING_SLOTS[b.slot] = true
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
-- Same for the bar settings, which the swing fill reads its direction from between ticks.
local cachedBarSettings = {}
-- Swing bars: GetTime() the running swing started and its length in seconds.
local swingStart = {}
local swingLength = {}
-- Swing bars: whether the bar's slot holds a weapon, or nil until first asked.
local weaponEquipped = {}
-- TEMPORARY DIAGNOSTIC (/trb otherbars): echo every GCD start/stop decision to chat.
local echoGcd = false
local function GcdEcho(fmt, ...)
	if echoGcd then
		print("|cFFFF8800TRB GCD:|r " .. string.format(fmt, ...))
	end
end

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

---Whether the bar is enabled at all: not Never Show, and Always Show or some show condition is ticked.
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
	for _, ticked in pairs(conditions) do
		if ticked == true then
			return true
		end
	end
	return false
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

---Whether Always Show or a ticked environment show condition (In Combat, In Group, ...) holds right now.
---@param visibility table
---@return boolean
local function IsShownByEnvironment(visibility)
	if visibility.alwaysShow then
		return true
	end
	local conditions = visibility.conditions
	return conditions ~= nil and TRB.Functions.BarVisibility:MatchesShowConditions(GetHideContext(), conditions)
end

---Container alpha the bar would rest at while its timer is idle, ignoring hide conditions: activeAlpha
---while Always Show or an environment condition holds, else inactiveAlpha.
---@param visibility table?
---@return number # 0..1
local function GetRestingAlpha(visibility)
	if visibility == nil or not IsEnabled(visibility) then
		return 0
	end
	if IsShownByEnvironment(visibility) then
		return ((visibility.activeAlpha) or 100) / 100
	end
	return ((visibility.inactiveAlpha) or 0) / 100
end

---Container alpha while the timer runs: activeAlpha when When Active is ticked, else the resting alpha.
---@param visibility table?
---@return number # 0..1
local function GetRunningAlpha(visibility)
	if visibility ~= nil and visibility.conditions ~= nil and visibility.conditions.whenActive == true then
		return ((visibility.activeAlpha) or 100) / 100
	end
	return GetRestingAlpha(visibility)
end

---Whether a running timer's bar is held off screen: a hard-hide condition applies, or nothing shows it.
---@param visibility table?
---@return boolean
local function IsHeldHidden(visibility)
	return IsForceHidden(visibility) or GetRunningAlpha(visibility) <= 0
end

---Whether an inventory slot holds a weapon. Shields, held-in-off-hand items, and relics do not count.
---@param slot integer
---@return boolean
local function SlotHoldsWeapon(slot)
	local itemId = GetInventoryItemID("player", slot)
	if itemId == nil then
		return false
	end
	return select(6, C_Item.GetItemInfoInstant(itemId)) == Enum.ItemClass.Weapon
end

---Whether a bar can show at all: a swing bar needs a weapon in its slot, every other bar always can.
---@param barKey string
---@return boolean
local function IsAvailable(barKey)
	local entry = BAR_BY_KEY[barKey]
	if entry == nil or entry.kind ~= "swing" then
		return true
	end
	if weaponEquipped[barKey] == nil then
		weaponEquipped[barKey] = SlotHoldsWeapon(entry.slot)
	end
	return weaponEquipped[barKey]
end

---Container alpha to rest at while the timer is idle, 0 while a hide condition applies or the bar is unavailable.
---@param barKey string
---@param visibility table?
---@return number # 0..1
local function GetIdleAlpha(barKey, visibility)
	if not IsAvailable(barKey) or IsForceHidden(visibility) then
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

---Writes a swing bar's progress into its node; "fill" grows toward the next swing, "deplete" drains.
---@param node TRB.Classes.BarNode
---@param entry table # The BARS entry
---@param barSettings table?
local function UpdateSwingFill(node, entry, barSettings)
	local length = swingLength[entry.key]
	if length == nil then
		return
	end
	local elapsed = math.min(GetTime() - swingStart[entry.key], length)
	node:SetMinMax(0, length)
	if barSettings ~= nil and barSettings.timerDirection == "deplete" then
		node:SetValue(length - elapsed)
	else
		node:SetValue(elapsed)
	end
end

---Advances a bar whose fill is written by hand: a mirror timer or a swing bar.
---@param node TRB.Classes.BarNode
---@param entry table # The BARS entry
---@param barSettings table?
local function UpdateManualFill(node, entry, barSettings)
	if entry.kind == "swing" then
		UpdateSwingFill(node, entry, barSettings)
	else
		UpdateMirrorFill(node, entry)
	end
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
		UpdateManualFill(node, entry, barSettings)
	end
	ApplyColors(node, colors)

	ShowAt(group, node, GetRunningAlpha(visibility))
end

---Re-asserts colors and alpha WITHOUT re-binding the GCD's native timer (re-calling SetTimerDuration
---every tick would restart the fill animation). Mirror bars refresh their value here too.
---@param entry table # The BARS entry
local function ReassertVisibility(entry)
	local group, node = GetGroupNode(entry.key)
	if group == nil or node == nil then
		return
	end
	local barSettings, colors, visibility = GetBarConfig(entry.key)
	if entry.kind ~= "gcd" then
		UpdateManualFill(node, entry, barSettings)
	end
	ApplyColors(node, colors)
	ShowAt(group, node, GetRunningAlpha(visibility))
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
	local idleAlpha = GetIdleAlpha(barKey, visibility)
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
		if IsAvailable(entry.key) and GetRestingAlpha(visibility) > 0 then
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
	if IsHeldHidden(visibility) then
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
	if not IsEnabled(visibility) or IsHeldHidden(visibility) or (delay <= 0 and duration <= 0 and GetIdleAlpha(barKey, visibility) <= 0) then
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
	elseif entry.kind == "swing" then
		-- Rest the fade-out on the swing's end state rather than the last frame's.
		local _, node = GetGroupNode(entry.key)
		if node ~= nil then
			UpdateSwingFill(node, entry, cachedBarSettings[entry.key])
		end
		swingStart[entry.key] = nil
		swingLength[entry.key] = nil
	else
		mirrorMax[entry.key] = nil
	end
	BeginFadeOut(entry.key)
end

-- ============================================================================
-- Swing timers
-- ============================================================================

---Whether a swing bar's swing is still running, from the start and length recorded by PLAYER_SWING.
---@param barKey string
---@return boolean
local function IsSwingStillRunning(barKey)
	local start = swingStart[barKey]
	return start ~= nil and GetTime() < start + swingLength[barKey]
end

---Starts or restarts a swing bar from PLAYER_SWING.
---@param swingType integer # Enum.PlayerSwingType
---@param length number # Seconds
local function StartSwing(swingType, length)
	local entry = BAR_BY_SWING_TYPE[swingType]
	-- A secret length could not drive a fill written by hand.
	if entry == nil or length == nil or issecretvalue(length) or length <= 0 or not IsAvailable(entry.key) then
		return
	end
	local _, _, visibility = GetBarConfig(entry.key)
	if not IsEnabled(visibility) then
		return
	end
	swingStart[entry.key] = GetTime()
	swingLength[entry.key] = length
	active[entry.key] = true
	BeginRender(entry)
end

---Re-reads which slots hold a weapon. A bar that loses its weapon drops its swing, and the layout re-applies
---only when a slot gains or loses one, so the stack closes up around a missing bar.
local function RefreshWeapons()
	local changed = false
	for _, entry in ipairs(BARS) do
		if entry.kind == "swing" then
			local hasWeapon = SlotHoldsWeapon(entry.slot)
			if weaponEquipped[entry.key] ~= nil and weaponEquipped[entry.key] ~= hasWeapon then
				changed = true
			end
			weaponEquipped[entry.key] = hasWeapon
			if not hasWeapon then
				active[entry.key] = false
				fadeStart[entry.key] = nil
				swingStart[entry.key] = nil
				swingLength[entry.key] = nil
			end
		end
	end
	if changed then
		local settings = GetActiveSettings()
		if settings ~= nil and TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
		end
	end
end

---Restarts each running swing from its hand's new weapon speed, as Blizzard's bar does on a weapon swap.
local function RestartSwingsForEquippedWeapons()
	for _, entry in ipairs(BARS) do
		if entry.kind == "swing" and active[entry.key] then
			local speed = select(entry.speedIndex, UnitAttackSpeed("player"))
			-- Secret while unit stats are restricted; the running swing then stands.
			if speed ~= nil and not issecretvalue(speed) and speed > 0 then
				swingStart[entry.key] = GetTime()
				swingLength[entry.key] = speed
				BeginRender(entry)
			end
		end
	end
end

-- ============================================================================
-- Blizzard swing timer suppression
-- ============================================================================

-- Detached like Blizzard's cast bar: reparented under a hidden holder, original parents kept for restoring.
local blizzardSwingHolder = nil
local blizzardSwingOriginalParent = {}
-- Set while we drive SetParent ourselves, so the SetParent hook ignores our own calls.
local blizzardSwingReparenting = false
local blizzardSwingHooked = {}

---Whether another addon already parks this Blizzard swing bar under an anonymous hidden parent of its own.
---@param frame Frame
---@return boolean
local function IsBlizzardSwingFrameExternallyManaged(frame)
	local parent = frame:GetParent()
	if parent == nil or parent == blizzardSwingHolder then
		return false
	end
	return parent:GetName() == nil and not parent:IsVisible()
end

---Whether Blizzard's swing bars should be detached: one switch for all three, stored on every swing bar
---and read from Main Hand, while any swing bar is enabled.
---@return boolean
local function ShouldDetachBlizzardSwingBars()
	local mainHandSettings = GetBarConfig("mainHandSwing")
	if mainHandSettings == nil or mainHandSettings.disableBlizzardBar ~= true then
		return false
	end
	for _, entry in ipairs(BARS) do
		if entry.kind == "swing" and IsEnabled((select(3, GetBarConfig(entry.key)))) then
			return true
		end
	end
	return false
end

---Detaches or restores Blizzard's three swing bars together.
function TRB.Functions.OtherBars:UpdateBlizzardSwingTimerVisibility()
	local shouldDisable = ShouldDetachBlizzardSwingBars()
	for _, entry in ipairs(BARS) do
		local frame = entry.kind == "swing" and _G[entry.blizzardFrame] or nil
		if frame ~= nil then
			local currentlyDisabled = blizzardSwingHolder ~= nil and frame:GetParent() == blizzardSwingHolder
			if shouldDisable and not currentlyDisabled and not IsBlizzardSwingFrameExternallyManaged(frame) then
				if blizzardSwingHolder == nil then
					blizzardSwingHolder = CreateFrame("Frame")
					blizzardSwingHolder:Hide()
				end
				blizzardSwingOriginalParent[entry.key] = frame:GetParent()
				blizzardSwingReparenting = true
				frame:SetParent(blizzardSwingHolder)
				blizzardSwingReparenting = false
				if not blizzardSwingHooked[entry.key] then
					blizzardSwingHooked[entry.key] = true
					-- Backstop for a bar that becomes visible without a re-parent.
					frame:HookScript("OnShow", function()
						TRB.Functions.OtherBars:UpdateBlizzardSwingTimerVisibility()
					end)
					-- Re-park in the same call if Blizzard re-parents it back, before it can render a frame.
					hooksecurefunc(frame, "SetParent", function(hookedFrame)
						if blizzardSwingReparenting or blizzardSwingHolder == nil or hookedFrame:GetParent() == blizzardSwingHolder then
							return
						end
						TRB.Functions.OtherBars:UpdateBlizzardSwingTimerVisibility()
					end)
				end
			elseif not shouldDisable and currentlyDisabled then
				blizzardSwingReparenting = true
				frame:SetParent(blizzardSwingOriginalParent[entry.key] or UIParent)
				blizzardSwingReparenting = false
			end
		end
	end
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
	local entry = BAR_BY_KEY.gcd
	local _, _, visibility = GetBarConfig(entry.key)
	if not IsEnabled(visibility) then
		GcdEcho("start(fromCast=%s): bar not enabled", tostring(fromCast))
		return
	end
	local readable = IsGcdRunningReadable()
	if readable == false then
		GcdEcho("start(fromCast=%s): cooldown API says no GCD running", tostring(fromCast))
		return
	end
	-- Secret cooldown values: SPELL_UPDATE_COOLDOWN fires for every cooldown in the game and can't be
	-- read, so only a cast event is evidence that a GCD actually began.
	if readable == nil and not fromCast then
		return
	end
	local duration = ReadGcdDurationObject()
	if duration == nil then
		GcdEcho("start(fromCast=%s): readable=%s, no DurationObject", tostring(fromCast), tostring(readable))
		return
	end
	gcdDuration = duration
	gcdExpiry = GetTime() + ReadGcdLength(duration)
	if echoGcd then
		local _, node = GetGroupNode(entry.key)
		GcdEcho("start(fromCast=%s): readable=%s length=%s node=%s SetTimerDuration=%s", tostring(fromCast), tostring(readable), tostring(gcdExpiry - GetTime()), tostring(node ~= nil), tostring(node ~= nil and node.SetTimerDuration ~= nil))
	end
	active[entry.key] = true
	BeginRender(entry)
end

---Ends the bar early when a failed cast turns out not to have started a GCD. One API read per failure; a
---failure during a real GCD, or a secret cooldown, leaves the expiry to stand.
local function CheckGcdStop()
	local entry = BAR_BY_KEY.gcd
	if not active[entry.key] then
		return
	end
	if IsGcdRunningReadable() == false then
		GcdEcho("stop: cast failed with no GCD running")
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
			local barSettings
			barSettings, _, visibility = GetBarConfig(barKey)
			cachedBarSettings[barKey] = barSettings
			cachedVisibility[barKey] = visibility
		else
			visibility = cachedVisibility[barKey]
		end

		if active[barKey] then
			-- Nothing announces the end of a GCD or a swing, so they need an expiry check -- a timestamp compare.
			if (throttleTick and entry.kind == "gcd" and not IsGcdStillRunning())
				or (entry.kind == "swing" and not IsSwingStillRunning(barKey)) then
				StopTimer(entry)
			else
				needsUpdater = true
				if throttleTick and not IsEnabled(visibility) then
					ApplyInactiveState(barKey)
				elseif throttleTick and IsHeldHidden(visibility) then
					forceHidden[barKey] = true
					ApplyHiddenState(barKey)
				elseif forceHidden[barKey] then
					if throttleTick then
						-- Hold just cleared: rebind the fill that ApplyHiddenState released.
						forceHidden[barKey] = nil
						ApplyVisibleState(entry)
					end
					-- Between ticks while still force-hidden: leave it as the tick left it.
				elseif throttleTick then
					ReassertVisibility(entry)
				elseif entry.kind ~= "gcd" then
					-- Between ticks a mirror or swing bar still advances its own fill; the GCD's is native.
					local _, node = GetGroupNode(barKey)
					if node ~= nil then
						UpdateManualFill(node, entry, cachedBarSettings[barKey])
					end
				end
			end
		elseif fadeStart[barKey] ~= nil then
			needsUpdater = true
			local activeAlpha = GetRunningAlpha(visibility)
			local idleAlpha = GetIdleAlpha(barKey, visibility)
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
			local idleAlpha = GetIdleAlpha(barKey, visibility)
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
eventFrame:SetScript("OnEvent", function(_, event, ...)
	if event == "MIRROR_TIMER_START" then
		local timerName, _, maxValue = ...
		StartMirrorTimer(timerName, maxValue)
	elseif event == "MIRROR_TIMER_STOP" then
		local entry = BAR_BY_TIMER_NAME[(...)]
		if entry ~= nil then
			StopTimer(entry)
			TRB.Functions.OtherBars:UpdateBlizzardMirrorTimerVisibility()
		end
	elseif event == "MIRROR_TIMER_PAUSE" then
		-- A paused timer stops advancing GetMirrorTimerProgress on its own, so the fill freezes without
		-- any extra bookkeeping. Nothing to do beyond keeping the bar on screen.
	elseif event == "PLAYER_SWING" then
		local length, swingType = ...
		StartSwing(swingType, length)
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		if SWING_SLOTS[(...)] then
			RefreshWeapons()
			TRB.Functions.OtherBars:RefreshVisibility()
		end
	elseif event == "WEAPON_SLOT_CHANGED" then
		RefreshWeapons()
		RestartSwingsForEquippedWeapons()
		TRB.Functions.OtherBars:RefreshVisibility()
	elseif event == "PLAYER_ENTERING_WORLD" then
		InstallMirrorTimerHooks()
		SyncMirrorTimers()
		-- The inventory can read empty before the first load screen ends.
		RefreshWeapons()
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
---and re-applies Blizzard Duration Bar and swing timer suppression. Running timers keep their own render.
function TRB.Functions.OtherBars:RefreshVisibility()
	for _, entry in ipairs(BARS) do
		if not active[entry.key] and fadeStart[entry.key] == nil then
			ApplyInactiveState(entry.key)
			TRB.Functions.BarVisibility:MarkDirty()
		end
	end
	self:UpdateBlizzardMirrorTimerVisibility()
	self:SyncEnabledState()
	SyncUpdater()
end

---Registers PLAYER_SWING only while a swing bar is enabled, so nobody else pays for it.
function TRB.Functions.OtherBars:SyncSwingEvents()
	if not TRB.Flavor.swingTimers then
		return
	end
	local anyEnabled = false
	for _, entry in ipairs(BARS) do
		if entry.kind == "swing" and IsEnabled((select(3, GetBarConfig(entry.key)))) then
			anyEnabled = true
			break
		end
	end
	if anyEnabled then
		eventFrame:RegisterEvent("PLAYER_SWING")
	else
		eventFrame:UnregisterEvent("PLAYER_SWING")
	end
end

---Applies an enabled-state change from recomposed settings: the swing event and Blizzard swing bar suppression.
function TRB.Functions.OtherBars:SyncEnabledState()
	self:SyncSwingEvents()
	self:UpdateBlizzardSwingTimerVisibility()
end

-- TEMPORARY DIAGNOSTIC (/trb otherbars), remove once the Forever mirror timers render: dumps each bar's
-- resolved state and echoes raw MIRROR_TIMER_* payloads to chat until toggled off.
local echoMirrorEvents = false
local echoFrame = CreateFrame("Frame")
echoFrame:SetScript("OnEvent", function(_, event, ...)
	local parts = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		parts[i] = issecretvalue(v) and ("<secret " .. type(v) .. ">") or tostring(v)
	end
	print("|cFFFF8800TRB OtherBars:|r " .. event .. "(" .. table.concat(parts, ", ") .. ")")
end)

function TRB.Functions.OtherBars:PrintDiagnostics()
	local settings = GetActiveSettings()
	print("|cFFFF8800TRB OtherBars:|r settings=" .. tostring(settings ~= nil) .. " compositeKey=" .. tostring(TRB.Data.character and TRB.Data.character.compositeKey) .. " updater=" .. tostring(updaterFrame:IsShown()))
	for _, entry in ipairs(BARS) do
		local barSettings, colors, visibility = GetBarConfig(entry.key)
		local group, node = GetGroupNode(entry.key)
		print(string.format("  %-10s bar=%s colors=%s vis=%s enabled=%s never=%s always=%s whenActive=%s forceHidden=%s group=%s node=%s active=%s max=%s available=%s swingLength=%s",
			entry.key, tostring(barSettings ~= nil), tostring(colors ~= nil), tostring(visibility ~= nil), tostring(IsEnabled(visibility)),
			tostring(visibility and visibility.neverShow), tostring(visibility and visibility.alwaysShow), tostring(visibility and visibility.conditions and visibility.conditions.whenActive),
			tostring(visibility ~= nil and IsForceHidden(visibility)), tostring(group ~= nil), tostring(node ~= nil), tostring(active[entry.key]), tostring(mirrorMax[entry.key]),
			tostring(IsAvailable(entry.key)), tostring(swingLength[entry.key])))
	end
	if TRB.Flavor.swingTimers then
		local mainSpeed, offSpeed, rangedSpeed = UnitAttackSpeed("player")
		local secretSpeed = function(v) return issecretvalue(v) and ("<secret " .. type(v) .. ">") or tostring(v) end
		print(string.format("  UnitAttackSpeed = %s, %s, %s PLAYER_SWING registered=%s", secretSpeed(mainSpeed), secretSpeed(offSpeed), secretSpeed(rangedSpeed), tostring(eventFrame:IsEventRegistered("PLAYER_SWING"))))
		for _, entry in ipairs(BARS) do
			if entry.kind == "swing" then
				local itemId = GetInventoryItemID("player", entry.slot)
				local frame = _G[entry.blizzardFrame]
				print(string.format("  %s slot %d item=%s classID=%s weapon=%s blizzardFrame=%s parentIsHolder=%s shown=%s", entry.key, entry.slot, tostring(itemId),
					tostring(itemId and select(6, C_Item.GetItemInfoInstant(itemId))), tostring(SlotHoldsWeapon(entry.slot)), tostring(frame ~= nil),
					tostring(frame ~= nil and blizzardSwingHolder ~= nil and frame:GetParent() == blizzardSwingHolder), tostring(frame ~= nil and frame:IsShown())))
			end
		end
	end
	if GetMirrorTimerInfo ~= nil then
		for i = 1, MIRROR_TIMER_COUNT do
			local timer, value, maxValue, scale, paused, label = GetMirrorTimerInfo(i)
			print(string.format("  GetMirrorTimerInfo(%d) = %s, %s, %s, %s, %s, %s", i, tostring(timer), tostring(value), tostring(maxValue), tostring(scale), tostring(paused), tostring(label)))
		end
		for _, entry in ipairs(BARS) do
			if entry.timerName ~= nil then
				local progress = GetMirrorTimerProgress(entry.timerName)
				print("  GetMirrorTimerProgress(" .. entry.timerName .. ") = " .. (issecretvalue(progress) and ("<secret " .. type(progress) .. ">") or tostring(progress)))
			end
		end
	end
	local container = MirrorTimerContainer
	print("  MirrorTimerContainer=" .. tostring(container ~= nil) .. " mirrorTimers=" .. tostring(container and container.mirrorTimers ~= nil) .. " hooks=" .. tostring(mirrorHooksInstalled) .. " registered=" .. tostring(eventFrame:IsEventRegistered("MIRROR_TIMER_START")))
	local function describe(v)
		return issecretvalue(v) and ("<secret " .. type(v) .. ">") or tostring(v)
	end
	print(string.format("  GCD spell %d: DoesSpellExist=%s GetSpellInfo=%s GetSpellCooldownDuration=%s", GCD_SPELL_ID,
		tostring(C_Spell.DoesSpellExist and C_Spell.DoesSpellExist(GCD_SPELL_ID)), tostring(C_Spell.GetSpellInfo(GCD_SPELL_ID) ~= nil), tostring(C_Spell.GetSpellCooldownDuration ~= nil)))
	local cooldown = C_Spell.GetSpellCooldown(GCD_SPELL_ID)
	print(string.format("  GetSpellCooldown: %s startTime=%s duration=%s isEnabled=%s modRate=%s", tostring(cooldown ~= nil),
		describe(cooldown and cooldown.startTime), describe(cooldown and cooldown.duration), describe(cooldown and cooldown.isEnabled), describe(cooldown and cooldown.modRate)))
	local durationObject = ReadGcdDurationObject()
	print(string.format("  DurationObject: %s GetTotalDuration=%s GetRemainingDuration=%s", tostring(durationObject),
		describe(durationObject and durationObject.GetTotalDuration and durationObject:GetTotalDuration()), describe(durationObject and durationObject.GetRemainingDuration and durationObject:GetRemainingDuration())))
	local _, gcdNode = GetGroupNode("gcd")
	print(string.format("  node SetTimerDuration=%s Enum.StatusBarTimerDirection=%s GetCurrentGCDTime=%s events=%s",
		tostring(gcdNode ~= nil and gcdNode.SetTimerDuration ~= nil), tostring(Enum.StatusBarTimerDirection ~= nil), describe(TRB.Functions.Character:GetCurrentGCDTime()), tostring(eventFrame:IsEventRegistered("SPELL_UPDATE_COOLDOWN"))))
	echoMirrorEvents = not echoMirrorEvents
	echoGcd = echoMirrorEvents
	local echoEvents = { "MIRROR_TIMER_START", "MIRROR_TIMER_STOP", "MIRROR_TIMER_PAUSE" }
	if TRB.Flavor.swingTimers then
		for _, event in ipairs({ "PLAYER_SWING", "WEAPON_SLOT_CHANGED", "PLAYER_EQUIPMENT_CHANGED", "PLAYER_SWING_RANGE_UPDATE" }) do
			echoEvents[#echoEvents + 1] = event
		end
	end
	for _, event in ipairs(echoEvents) do
		if echoMirrorEvents then
			echoFrame:RegisterEvent(event)
		else
			echoFrame:UnregisterEvent(event)
		end
	end
	print("  MIRROR_TIMER_*, PLAYER_SWING, and GCD echo " .. (echoMirrorEvents and "ON: cast something, swing at something, or swim underwater, then paste the lines it prints" or "OFF"))
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
	if TRB.Flavor.swingTimers then
		eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		eventFrame:RegisterEvent("WEAPON_SLOT_CHANGED")
	end
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
		swingStart[entry.key] = nil
		swingLength[entry.key] = nil
		ApplyHiddenState(entry.key)
	end
	gcdDuration = nil
	gcdExpiry = nil
	updaterFrame:Hide()
	self:UpdateBlizzardMirrorTimerVisibility()
	self:UpdateBlizzardSwingTimerVisibility()
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

---Wakes the parked updater when a bar should now rest visible: a show condition changing only marks
---visibility dirty, so ProcessBars calls this. Edit Mode previews these bars as ProcessBars entries.
function TRB.Functions.OtherBars:EnsureIdleState()
	if updaterFrame:IsShown() or TRB.Functions.EditMode:IsInEditMode() then
		return
	end
	if NeedsUpdater() then
		ForceThrottleTick()
		updaterFrame:Show()
	end
end

---Whether any Other Bar is on screen, running or resting. Its anchored bar text depends on this.
---@return boolean
function TRB.Functions.OtherBars:IsRendering()
	for _, entry in ipairs(BARS) do
		local group = GetGroupNode(entry.key)
		if group ~= nil and group.isVisible then
			return true
		end
	end
	return false
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
	local entry = BAR_BY_KEY[barKey]
	if entry ~= nil and entry.kind == "swing" then
		local length = swingLength[barKey]
		if length == nil then
			return nil, nil
		end
		return math.max(0, swingStart[barKey] + length - GetTime()), length
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

---Whether a bar holds layout space: enabled and, for a swing bar, a weapon in its slot.
---@param barKey string
---@param visibility table?
---@return boolean
function TRB.Functions.OtherBars:IsEnabledForLayout(barKey, visibility)
	return IsEnabled(visibility) and IsAvailable(barKey)
end
