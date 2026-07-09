---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Castbar = {}

--[[
	Functions.Castbar: the render + event bridge for the castbar bar type.
	Drives TRB.Data.castbar (Classes/Castbar.lua) from UNIT_SPELLCAST_* events (fed by
	Functions/SpellCast.lua), places the static overlays/threshold lines (latency, pushback,
	channel ticks, empower stages) once per cast, and runs a dedicated per-frame updater for a
	smooth fill and the show/hide fade. Bar text values are exposed separately by Functions/BarText.
]]

-- Dedicated per-frame frame: drives the smooth fill + self-healing visibility while a cast is active.
-- Enabled on cast start, disabled once idle.
local castbarFrame = CreateFrame("Frame")
castbarFrame:Hide()
local isRunning = false

---Returns the active spec's settings, castbar bar settings, and castbar colors (or nils).
---@return table? settings, table? barSettings, table? colors
function TRB.Functions.Castbar:GetActiveSettings()
	local settings = TRB.Functions.Class:GetActiveDisplaySettings()
	if settings == nil then
		return nil, nil, nil
	end
	local barSettings = settings.bars and settings.bars.castbar
	local colors = settings.colors and settings.colors.bars and settings.colors.bars.castbar
	return settings, barSettings, colors
end

---Whether the castbar is enabled for the active spec. This is a simple opt-in flag independent of the
---displayBar/BarVisibility system: when enabled, the castbar shows automatically while actively
---casting/channeling/empowering and hides otherwise (see BeginRender/EndRender), with no user-configurable
---always/never/conditions since a castbar only ever makes sense while something is casting.
---@param barSettings table?
---@return boolean
function TRB.Functions.Castbar:IsEnabled(barSettings)
	return barSettings ~= nil and barSettings.enabled == true
end

---Returns the castbar BarGroup, or nil if not constructed.
---@return TRB.Classes.BarGroup?
function TRB.Functions.Castbar:GetGroup()
	local barGroups = TRB.Frames.barGroups
	return barGroups and barGroups.castbar or nil
end

---Returns the castbar's single node, or nil.
---@return TRB.Classes.BarNode?
function TRB.Functions.Castbar:GetNode()
	local group = self:GetGroup()
	return group and group:GetNode(1) or nil
end

---Resolves a channel tick profile for a spellId from the castbar settings (built-in + user edits).
---@param barSettings table?
---@param spellId integer?
---@return table?
function TRB.Functions.Castbar:GetTickProfile(barSettings, spellId)
	if barSettings == nil or spellId == nil or issecretvalue(spellId) then
		return nil
	end
	local profiles = barSettings.tickProfiles
	if type(profiles) ~= "table" then
		return nil
	end
	return profiles[spellId]
end

-- ============================================================================
-- Overlay / threshold-line texture pool (fraction-positioned, on the node frame)
-- ============================================================================

---Lazily builds (and returns) the castbar overlay texture pool bound to the current node frame.
---Rebuilt if the node frame changed (e.g., bar groups were reconstructed).
---@param node TRB.Classes.BarNode
---@return table
local function GetOverlayPool(node)
	local frame = node.frame
	---@diagnostic disable-next-line: inject-field
	local pool = frame._trbCastbarOverlays
	if pool and pool.frame == frame then
		return pool
	end
	pool = { frame = frame, ticks = {}, empower = {} }
	pool.latency = frame:CreateTexture(nil, "OVERLAY")
	pool.latency:SetColorTexture(1, 0, 0, 0.5)
	pool.latency:Hide()
	pool.pushback = frame:CreateTexture(nil, "OVERLAY")
	pool.pushback:SetColorTexture(1, 0, 1, 0.5)
	pool.pushback:Hide()
	---@diagnostic disable-next-line: inject-field
	frame._trbCastbarOverlays = pool
	return pool
end

---Places a vertical (horizontal bar) or horizontal (vertical bar) line at a timeline fraction.
---@param tex table # Texture
---@param node TRB.Classes.BarNode
---@param frac number # Timeline fraction 0..1 (0 = fill start)
---@param isVertical boolean # True when the bar fills vertically
---@param thickness number
local function PlaceLine(tex, node, frac, isVertical, thickness)
	local border = node.border or 0
	local w, h = node.width, node.height
	local innerW = math.max(1, w - 2 * border)
	local innerH = math.max(1, h - 2 * border)
	local fillDirection = node.fillDirection or "leftRight"
	tex:ClearAllPoints()
	if isVertical then
		local yFromBottom
		if fillDirection == "topBottom" then
			yFromBottom = border + (1 - frac) * innerH
		else
			yFromBottom = border + frac * innerH
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", border, yFromBottom - thickness / 2)
		tex:SetSize(innerW, thickness)
	else
		local xFromLeft
		if fillDirection == "rightLeft" then
			xFromLeft = border + (1 - frac) * innerW
		else
			xFromLeft = border + frac * innerW
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", xFromLeft - thickness / 2, border)
		tex:SetSize(thickness, innerH)
	end
end

---Places a filled region spanning timeline fractions [fA, fB] (fA < fB).
---@param tex table # Texture
---@param node TRB.Classes.BarNode
---@param fA number
---@param fB number
---@param isVertical boolean
local function PlaceRegion(tex, node, fA, fB, isVertical)
	local border = node.border or 0
	local w, h = node.width, node.height
	local innerW = math.max(1, w - 2 * border)
	local innerH = math.max(1, h - 2 * border)
	local fillDirection = node.fillDirection or "leftRight"
	if fA > fB then fA, fB = fB, fA end
	tex:ClearAllPoints()
	if isVertical then
		local y1, y2
		if fillDirection == "topBottom" then
			y1 = border + (1 - fB) * innerH
			y2 = border + (1 - fA) * innerH
		else
			y1 = border + fA * innerH
			y2 = border + fB * innerH
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", border, y1)
		tex:SetSize(innerW, math.max(1, y2 - y1))
	else
		local x1, x2
		if fillDirection == "rightLeft" then
			x1 = border + (1 - fB) * innerW
			x2 = border + (1 - fA) * innerW
		else
			x1 = border + fA * innerW
			x2 = border + fB * innerW
		end
		tex:SetPoint("BOTTOMLEFT", node.frame, "BOTTOMLEFT", x1, border)
		tex:SetSize(math.max(1, x2 - x1), innerH)
	end
end

---Returns a pooled tick line texture at index i, creating it on demand.
local function GetTickTexture(pool, node, i)
	if pool.ticks[i] == nil then
		local t = node.frame:CreateTexture(nil, "OVERLAY")
		t:SetDrawLayer("OVERLAY", 2)
		pool.ticks[i] = t
	end
	return pool.ticks[i]
end

---Returns a pooled empower stage line texture at index i, creating it on demand.
local function GetEmpowerTexture(pool, node, i)
	if pool.empower[i] == nil then
		local t = node.frame:CreateTexture(nil, "OVERLAY")
		t:SetDrawLayer("OVERLAY", 3)
		pool.empower[i] = t
	end
	return pool.empower[i]
end

---Hides all pooled overlay textures.
local function HideOverlays(pool)
	if pool == nil then return end
	if pool.latency then pool.latency:Hide() end
	if pool.pushback then pool.pushback:Hide() end
	for _, t in ipairs(pool.ticks) do t:Hide() end
	for _, t in ipairs(pool.empower) do t:Hide() end
end

-- ============================================================================
-- Per-state fill color
-- ============================================================================

---Applies the fill color for the current cast state (and empower stage), honoring uninterruptible.
---@param node TRB.Classes.BarNode
---@param colors table
---@param model TRB.Classes.Castbar
local function ApplyStateFillColor(node, colors, model)
	local Color = TRB.Functions.Color
	if colors == nil then return end

	-- Empowered casts always use the empower stage colors, even when uninterruptible: stage progression
	-- is the point of the bar, so it should never be flattened to a plain "can't interrupt" color.
	if model.notInterruptible and colors.uninterruptible and model.state ~= "empower" then
		Color:ApplyFillColor(node, colors.uninterruptible)
		return
	end

	if model.state == "channel" then
		Color:ApplyFillColor(node, colors.channel or colors.bar)
	elseif model.state == "empower" then
		local stageColors = colors.empowerStages
		local stage = model:GetCurrentEmpowerStage()
		-- One line is drawn per stage completion (empowerStages of them, including the max line before the
		-- hold-at-max zone), so GetCurrentEmpowerStage returns 0..empowerStages. Max empower and the hold
		-- that follows are stage == empowerStages; the level just below it is the penultimate.
		local maxStage = model.empowerStages or 0
		local entry
		if stageColors and stage > 0 and maxStage > 0 then
			if stage >= maxStage then
				entry = stageColors.final
			elseif stage == maxStage - 1 then
				entry = stageColors.penultimate
			else
				entry = stageColors.base
			end
		end
		Color:ApplyFillColor(node, entry or colors.empowerFill or colors.bar)
	else
		Color:ApplyFillColor(node, colors.bar)
	end
end

-- ============================================================================
-- Setup (once per cast) and teardown
-- ============================================================================

---Returns the latency overlay fraction actually shown for the current cast/channel (0 when disabled by
---settings or when latency is zero). SetupOverlays draws the zone on the bar's ending side (high-fraction
---end for casts/empowers, low-fraction end for depleting channels). Also feeds cast pushback placement so
---the pushback region sits flush against the latency zone.
---@param model TRB.Classes.Castbar
---@param barSettings table?
---@param colors table?
---@return number
local function GetShownLatencyFraction(model, barSettings, colors)
	if not (colors and colors.latency and colors.latency.enabled and barSettings and barSettings.showLatency ~= false) then
		return 0
	end
	return model:GetLatencyFraction() or 0
end

---Places the static overlays and threshold lines for the freshly-started cast/channel/empower.
---@param model TRB.Classes.Castbar
function TRB.Functions.Castbar:SetupOverlays(model)
	local node = self:GetNode()
	if node == nil then return end
	local _, barSettings, colors = self:GetActiveSettings()
	local pool = GetOverlayPool(node)
	HideOverlays(pool)

	local isVertical = TRB.Functions.Bar:IsVerticalFill(node.fillDirection)
	local tickThickness = (barSettings and barSettings.border and barSettings.border >= 2) and 2 or 1

	-- Latency zone: the final `latency` window (safe-to-queue region), drawn on the bar's ending side. A
	-- cast/empower grows L->R and ends at fraction 1, so its zone is [1-latFrac, 1]; a channel depletes
	-- toward fraction 0, so its ending-side zone is [0, latFrac].
	local latFrac = GetShownLatencyFraction(model, barSettings, colors)
	if latFrac > 0 then
		-- latFrac > 0 implies colors.latency exists (see GetShownLatencyFraction).
		---@diagnostic disable-next-line: need-check-nil
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colors.latency.color, true)
		pool.latency:SetColorTexture(r, g, b, a)
		if model.state == "channel" then
			PlaceRegion(pool.latency, node, 0, latFrac, isVertical)
		else
			PlaceRegion(pool.latency, node, 1 - latFrac, 1, isVertical)
		end
		pool.latency:Show()
	end

	-- Channel ticks sit at each tick's bar fraction (see ComputeChannelTicks, which mirrors fixedRate for depletion).
	if colors and colors.tick and colors.tick.enabled ~= false and barSettings and barSettings.showTicks ~= false
		and model.state == "channel" and model.ticks then
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colors.tick.color, true)
		for i, tick in ipairs(model.ticks) do
			if tick.fraction >= -0.0001 and tick.fraction < 1.0001 then
				local t = GetTickTexture(pool, node, i)
				t:SetColorTexture(r, g, b, a)
				PlaceLine(t, node, tick.fraction, isVertical, tickThickness)
				t:Show()
			end
		end
	end

	-- Empower stage boundary lines.
	if barSettings and barSettings.showEmpowerStages ~= false and model.state == "empower"
		and model.empowerStageFractions then
		local lineColor = (colors and colors.tick and colors.tick.color) or "FFFFFFFF"
		local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(lineColor, true)
		for i, frac in ipairs(model.empowerStageFractions) do
			-- Skip the final boundary at ~1.0 (the bar end needs no line).
			if frac > 0.0001 and frac < 0.9999 then
				local t = GetEmpowerTexture(pool, node, i)
				t:SetColorTexture(r, g, b, a)
				PlaceLine(t, node, frac, isVertical, tickThickness)
				t:Show()
			end
		end
	end
end

---Repositions the pushback overlay to reflect the current accumulated pushback (called on delay events).
---@param model TRB.Classes.Castbar
function TRB.Functions.Castbar:UpdatePushbackOverlay(model)
	local node = self:GetNode()
	if node == nil then return end
	local _, barSettings, colors = self:GetActiveSettings()
	local pool = GetOverlayPool(node)
	pool.pushback:Hide()
	if colors == nil or colors.pushback == nil or colors.pushback.enabled == false then return end
	if barSettings and barSettings.showPushback == false then return end
	local pbFrac = model:GetPushbackFraction()
	if pbFrac == nil then return end
	local isVertical = TRB.Functions.Bar:IsVerticalFill(node.fillDirection)
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colors.pushback.color, true)
	pool.pushback:SetColorTexture(r, g, b, a)
	-- Pushback sits flush against the inner edge of the latency zone (or the bar end when no latency
	-- overlay is shown), since latency always occupies the final stretch of the timeline.
	local outer = 1 - GetShownLatencyFraction(model, barSettings, colors)
	PlaceRegion(pool.pushback, node, math.max(0, outer - pbFrac), outer, isVertical)
	pool.pushback:Show()
end

---Applies the full visible render state (dimensions, fill color, overlays, alpha, Show) onto the
---castbar group/node. Idempotent and cheap to call every frame; the expensive overlay/color setup is
---only re-run when the node's frame changes (i.e., bar groups were reconstructed out from under us).
---Deliberately bypasses the BarGroup fade system: render transitions and HideResourceBar zero every
---group's alpha AND hide it, but the castbar isn't part of BarVisibility:ProcessBars so nothing ever
---restores it. Re-asserting alpha/visibility directly here each frame makes the castbar self-heal.
---@param group TRB.Classes.BarGroup
---@param node TRB.Classes.BarNode
---@param colors table?
---@param model TRB.Classes.Castbar
function TRB.Functions.Castbar:ApplyVisibleState(group, node, colors, model)
	if self._renderedFrame ~= node.frame then
		-- New/rebuilt node frame: (re)place the static overlays and per-state fill color on it.
		self._renderedFrame = node.frame
		node:SetMinMax(0, 1)
		ApplyStateFillColor(node, colors, model)
		self:SetupOverlays(model)
	end
	-- Keep the shared fade fields synced to 1 so anything that consults them stays consistent, but we
	-- drive the actual container alpha directly rather than through UpdateFade.
	group.targetAlpha = 1
	group.currentAlpha = 1
	if not group.isVisible then
		group:Show()
		-- The group just transitioned hidden->visible (fresh cast, or after a render transition /
		-- reconstruction hid it). Mark visibility dirty so the next ProcessBars re-runs BarText:Show and
		-- reveals this castbar's anchored text frames (whose isVisible tracks this group's isVisible).
		TRB.Functions.BarVisibility:MarkDirty()
	end
	node:Show()
	group.containerFrame:SetAlpha(1)
end

---Begins showing the castbar for a freshly-started cast: sizes the node, applies color/overlays, shows
---it at full opacity, and starts the per-frame updater. No-op if the castbar is disabled.
function TRB.Functions.Castbar:BeginRender()
	local _, barSettings, colors = self:GetActiveSettings()
	if not self:IsEnabled(barSettings) then
		return
	end
	local group = self:GetGroup()
	local node = self:GetNode()
	if group == nil or node == nil then
		return
	end
	local model = TRB.Data.castbar

	node:SetValue(0)
	self._renderedFrame = nil -- force ApplyVisibleState to (re)place overlays for this fresh cast
	self:ApplyVisibleState(group, node, colors, model)

	-- Mark visibility dirty so the next ProcessBars pass re-evaluates and (via its castbar-active check)
	-- keeps isTracking true — that's what makes the shared, class-driven UpdateResourceBarText keep
	-- rendering this castbar's anchored bar text for the duration of the cast. Bar text is NOT rendered
	-- here or from the per-frame updater; it flows through the single existing path (no double updates).
	TRB.Functions.BarVisibility:MarkDirty()

	isRunning = true
	castbarFrame:Show()
end

---Ends the castbar render, hiding instantly and clearing overlays.
function TRB.Functions.Castbar:EndRender()
	local group = self:GetGroup()
	local node = self:GetNode()
	self._renderedFrame = nil
	if node then
		---@diagnostic disable-next-line: inject-field
		HideOverlays(node.frame._trbCastbarOverlays)
	end
	if group then
		group.targetAlpha = 0
		group.currentAlpha = 0
		if group.isVisible then
			group:Hide()
		end
		group.containerFrame:SetAlpha(0)
	end
	-- Re-evaluate visibility now the cast is over: isTracking / bar text can revert to whatever the
	-- standard bars dictate (e.g. hide out of combat), and the castbar-anchored text stops updating.
	TRB.Functions.BarVisibility:MarkDirty()
	isRunning = false
	castbarFrame:Hide()
end

-- ============================================================================
-- Per-frame updater
-- ============================================================================

castbarFrame:SetScript("OnUpdate", function()
	local self = TRB.Functions.Castbar
	local model = TRB.Data.castbar
	local group = self:GetGroup()
	if group == nil then
		isRunning = false
		castbarFrame:Hide()
		return
	end
	local node = group:GetNode(1)

	if model and model:IsActive() and node then
		local now = GetTime()

		-- Safety: if events were missed and the timeline elapsed, tear down.
		if model.endTime and now > model.endTime + 0.25 then
			model:Stop()
			self:EndRender()
			return
		end

		-- Yield to an active render transition: it deliberately hides ALL bars briefly during a
		-- reconstruction. We simply re-assert on the next frame after it ends, so the castbar isn't
		-- left permanently hidden (which is exactly what happened before: the transition hides + zeroes
		-- the castbar's alpha, ProcessBars restores every OTHER bar afterward, but never the castbar).
		if not TRB.Functions.Bar:IsRenderTransitionActive() then
			local _, barSettings, colors = self:GetActiveSettings()
			if self:IsEnabled(barSettings) then
				self:ApplyVisibleState(group, node, colors, model)

				local _, _, _, fill = model:GetProgress(now)
				node:SetValue(fill)

				-- Empower fill color advances with the current stage.
				if model.state == "empower" then
					ApplyStateFillColor(node, colors, model)
				end
			end
		end
	elseif not (model and model:IsActive()) then
		-- Idle: ensure hidden and stop the updater until the next cast.
		self._renderedFrame = nil
		group.targetAlpha = 0
		group.currentAlpha = 0
		if group.isVisible then
			group:Hide()
		end
		group.containerFrame:SetAlpha(0)
		isRunning = false
		castbarFrame:Hide()
	end
end)

-- ============================================================================
-- Event bridge (called from Functions/SpellCast.lua)
-- ============================================================================

---Handles a player UNIT_SPELLCAST_* event for the castbar model + render.
---@param event trbSpellCastType|string
---@param spellId integer?
function TRB.Functions.Castbar:OnSpellCastEvent(event, spellId)
	local model = TRB.Data.castbar
	if model == nil then
		return
	end
	local _, barSettings = self:GetActiveSettings()

	-- Only track when the castbar is enabled for this spec. Keeping the model idle otherwise ensures
	-- IsActive() (which ProcessBars' isTracking and UpdateResourceBarText's early-out now consult) is
	-- only ever true when the castbar is actually in use — never for every cast of every character.
	if not self:IsEnabled(barSettings) then
		if model:IsActive() then
			model:Stop()
			self:EndRender()
		end
		return
	end

	if event == "UNIT_SPELLCAST_START" then
		model:StartCast(spellId)
		self:BeginRender()
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		-- Resolve the channel spellId (event arg may be secret) before the profile lookup.
		local channelId = spellId
		if channelId == nil or issecretvalue(channelId) then
			channelId = select(8, UnitChannelInfo("player"))
			if issecretvalue(channelId) then channelId = nil end
		end
		local profile = self:GetTickProfile(barSettings, channelId)
		model:StartChannel(channelId, profile)
		self:BeginRender()
	elseif event == "UNIT_SPELLCAST_EMPOWER_START" then
		model:StartEmpower(spellId)
		self:BeginRender()
	elseif event == "UNIT_SPELLCAST_DELAYED" then
		model:Delayed()
		if isRunning then self:UpdatePushbackOverlay(model) end
	elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		model:ChannelUpdate()
		if isRunning then
			-- Channel end shifted (e.g. a chain): recompute ticks when we have a profile, then re-place
			-- overlays so the latency zone reflects the new duration. Channels carry no pushback overlay.
			local profile = self:GetTickProfile(barSettings, model.spellId)
			if profile then
				model:ComputeChannelTicks(profile, model:GetHasteMultiplier())
			end
			self:SetupOverlays(model)
		end
	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP"
		or event == "UNIT_SPELLCAST_EMPOWER_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" then
		-- Chain carry (when eligible) is banked inside Stop from state the model already tracks.
		model:Stop()
		self:EndRender()
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		-- A successful instant cast produces no bar; only tear down if the tracked cast finished.
		-- START/CHANNEL_START/STOP drive the visible lifecycle, so nothing to do here.
	end
end
