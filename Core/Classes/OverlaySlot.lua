---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

--[[
	OverlaySlot: A named overlay attachment on a BarNode.
	Each slot manages up to three overlay frame types (overlay, appended, inset)
	independently. Multiple slots can coexist on the same BarNode (e.g., "casting"
	on the primary bar, "absorb" on the health bar).
]]

---@class TRB.Classes.OverlaySlot
---@field public slotName string # Unique name for this slot (e.g., "casting", "absorb")
---@field public parentNode TRB.Classes.BarNode # Back-reference to the owning BarNode
---@field public texture string? # Last-applied texture path (for RefreshAppearance)
---@field public color string|TRB.Classes.Settings.ColorGradientEntry? # Last-applied color entry (for RefreshAppearance)
---@field public spendingColor string|TRB.Classes.Settings.ColorGradientEntry? # Last-applied spending color entry (for inset overlay on spend)
---@field public fullHeight boolean? # When true, the overlay extends through the bar's border area vertically
---@field public overlayFrame StatusBar? # Full-bar overlay StatusBar
---@field public appendedClipFrame Frame? # Clip container for the appended overlay
---@field public appendedOverlayFrame StatusBar? # StatusBar inside clip, anchored to fill's RIGHT edge
---@field public appendedOverlayReady boolean? # One-frame readiness guard for appended overlay
---@field public insetClipFrame Frame? # Clip container for the inset overlay
---@field public insetOverlayFrame StatusBar? # Reverse-fill StatusBar inside clip
---@field public insetOverlayReady boolean? # One-frame readiness guard for inset overlay
---@field public rangeBoundsClipFrame Frame? # Outer clip trimming the range overlays to the inner bar
---@field public rangeClipFrame Frame? # Clip container tracking the fill edge for the range overlays
---@field public rangeShutterFrames Frame[]? # Clip container per range, holding that range's gate open only while the next range's gate is shut
---@field public rangeProbeFrames StatusBar[]? # Invisible fixed-width twin of each gate, whose fill edge anchors the shutter below it
---@field public rangeOverlayFrames StatusBar[]? # Gate StatusBars inside the range clip, one per range, plus index 0 for the baseline
---@field public rangeActiveCount integer? # Number of ranges currently in use, which sets where the shutter chain ends
---@field public rangeOverlayReady boolean? # One-frame readiness guard for range overlays
---@field public rangeTexture string? # Last-applied range gate texture path (for RefreshAppearance)
---@field public rangeColors table<integer, string|TRB.Classes.Settings.ColorGradientEntry> # Last-applied color entry per range gate
---@field public endCapClipFrame Frame? # Clip container for the end cap band
---@field public endCapFrame Frame? # Fixed-width band anchored to the fill's leading edge
---@field public endCapReady boolean? # One-frame readiness guard for the end cap
---@field public endCapWidth number? # Configured fill-axis width of the end cap in pixels
---@field public _endCapOvershoot number? # Overshoot correction baked into the current anchor, for staleness checks
TRB.Classes.OverlaySlot = {}
TRB.Classes.OverlaySlot.__index = TRB.Classes.OverlaySlot

---Creates a new OverlaySlot. No frames are created until explicitly requested.
---@param parentNode TRB.Classes.BarNode # The BarNode this slot belongs to
---@param slotName string # Unique identifier for this slot
---@return TRB.Classes.OverlaySlot
function TRB.Classes.OverlaySlot:New(parentNode, slotName)
	local self = {}
	setmetatable(self, TRB.Classes.OverlaySlot)

	self.slotName = slotName
	self.parentNode = parentNode
	self.texture = nil
	self.color = nil
	self.spendingColor = nil
	self.fullHeight = false
	self.overlayFrame = nil
	self.appendedClipFrame = nil
	self.appendedOverlayFrame = nil
	self.appendedOverlayReady = nil
	self.insetClipFrame = nil
	self.insetOverlayFrame = nil
	self.insetOverlayReady = nil
	self.rangeBoundsClipFrame = nil
	self.rangeClipFrame = nil
	self.rangeShutterFrames = nil
	self.rangeProbeFrames = nil
	self.rangeOverlayFrames = nil
	self.rangeActiveCount = nil
	self.rangeOverlayReady = nil
	self.rangeTexture = nil
	self.rangeColors = {}
	self._rangeTexturePaths = {}
	self._rangeColorSigs = {}
	self._rangeGradientActive = {}
	self.endCapClipFrame = nil
	self.endCapFrame = nil
	self.endCapReady = nil
	self.endCapWidth = nil

	return self
end

---Sets whether this overlay should extend vertically through the bar border area.
---@param fullHeight boolean?
function TRB.Classes.OverlaySlot:SetFullHeight(fullHeight)
	fullHeight = fullHeight == true
	if self.fullHeight ~= fullHeight then
		self.fullHeight = fullHeight
		self:Reanchor()
	end
end

---Gets the TOPLEFT/BOTTOMRIGHT corner offsets for anchoring an overlay (or its clip frame) to the
---parent bar, honoring fill orientation and the fullHeight option. The FILL axis is always inset by
---the border so the overlay is trimmed to the inner bar (matching the visible primary fill). The
---CROSS axis (perpendicular to the fill) is inset by the border normally, or 0 when fullHeight is set,
---so the overlay overlaps the borders in the orientation opposite its fill.
---@param fillDirection trbFillDirection?
---@return number leftXOffset
---@return number topYOffset
---@return number rightXOffset
---@return number bottomYOffset
function TRB.Classes.OverlaySlot:GetAnchorInsets(fillDirection)
	local parent = self.parentNode
	local border = parent and parent.border or 0
	local crossInset = self.fullHeight and 0 or border
	fillDirection = fillDirection or (parent and parent.fillDirection) or "leftRight"
	if TRB.Functions.Bar:IsVerticalFill(fillDirection) then
		-- Fill axis vertical (top/bottom = border); cross axis horizontal (left/right = crossInset)
		return crossInset, -border, -crossInset, border
	end
	-- Fill axis horizontal (left/right = border); cross axis vertical (top/bottom = crossInset)
	return border, -crossInset, -border, crossInset
end

---Gets the TOPLEFT/BOTTOMRIGHT corner offsets for a clip frame that constrains ONLY the fill axis
---(so an appended/inset overlay can't draw past the bar ends). The cross axis is left at the full
---frame extent -- the overlay's own explicit size handles the side borders (and fullHeight overlap).
---@param fillDirection trbFillDirection?
---@return number leftXOffset
---@return number topYOffset
---@return number rightXOffset
---@return number bottomYOffset
function TRB.Classes.OverlaySlot:GetClipInsets(fillDirection)
	local parent = self.parentNode
	local border = parent and parent.border or 0
	fillDirection = fillDirection or (parent and parent.fillDirection) or "leftRight"
	if TRB.Functions.Bar:IsVerticalFill(fillDirection) then
		-- Fill axis vertical (top/bottom = border); cross axis horizontal left full
		return 0, -border, 0, border
	end
	-- Fill axis horizontal (left/right = border); cross axis vertical left full
	return border, 0, -border, 0
end

---Gets the parent's current fill ratio without leaking secret values into layout math.
---@return number?
function TRB.Classes.OverlaySlot:GetParentFillRatio()
	local frame = self.parentNode and self.parentNode.frame
	if frame == nil or frame.GetMinMaxValues == nil or frame.GetValue == nil then
		return nil
	end

	local minValue, maxValue = frame:GetMinMaxValues()
	local value = frame:GetValue()
	if minValue == nil or maxValue == nil or value == nil then
		return nil
	end
	if issecretvalue(minValue) or issecretvalue(maxValue) or issecretvalue(value) then
		return nil
	end
	if maxValue == minValue then
		return nil
	end

	return math.max(0, math.min(1, (value - minValue) / (maxValue - minValue)))
end

---Recovers the fill ratio by measuring the rendered fill texture, the only source that stays live while
---a DurationObject drives the fill. Not a secret escape hatch: a secret fill makes the extent secret too.
---@return number?
function TRB.Classes.OverlaySlot:GetRenderedFillRatio()
	local parent = self.parentNode
	local frame = parent and parent.frame
	if frame == nil or frame.GetStatusBarTexture == nil then
		return nil
	end
	local fillTexture = frame:GetStatusBarTexture()
	if fillTexture == nil then
		return nil
	end

	local isVertical = TRB.Functions.Bar:IsVerticalFill(parent.fillDirection or "leftRight")
	local filled = isVertical and fillTexture:GetHeight() or fillTexture:GetWidth()
	local total = isVertical and frame:GetHeight() or frame:GetWidth()
	if filled == nil or total == nil or issecretvalue(filled) or issecretvalue(total) or total <= 0 then
		return nil
	end

	return math.max(0, math.min(1, filled / total))
end

---Returns the offset needed to translate the raw StatusBar fill edge to the
---inner fill edge used by overlay clip frames.
---@param fillDirection trbFillDirection?
---@return number xOffset
---@return number yOffset
function TRB.Classes.OverlaySlot:GetFillEdgeAnchorOffsets(fillDirection)
	local parent = self.parentNode
	local border = parent and parent.border or 0
	if border == 0 then
		return 0, 0
	end

	local fillRatio = self:GetParentFillRatio()
	if fillRatio == nil then
		return 0, 0
	end

	fillDirection = fillDirection or parent.fillDirection or "leftRight"
	if fillDirection == "rightLeft" then
		return border * ((2 * fillRatio) - 1), 0
	elseif fillDirection == "bottomTop" then
		return 0, border * (1 - (2 * fillRatio))
	elseif fillDirection == "topBottom" then
		return 0, border * ((2 * fillRatio) - 1)
	end

	return border * (1 - (2 * fillRatio)), 0
end

-- ============================================================================
-- Generic Overlay (full-bar fill from left)
-- ============================================================================

---Creates a generic overlay StatusBar on top of the parent node's primary fill.
---The overlay is anchored within the border insets and draws above the primary fill.
---Idempotent: calling this multiple times is safe.
function TRB.Classes.OverlaySlot:CreateOverlay()
	if self.overlayFrame then
		return
	end

	local parent = self.parentNode
	local frameName = parent.name .. "_" .. self.slotName .. "_Overlay"
	local overlay = CreateFrame("StatusBar", frameName, parent.frame)
	overlay:SetFrameLevel(parent.frame:GetFrameLevel() + 1)
	local lX, tY, rX, bY = self:GetAnchorInsets(parent.fillDirection)
	overlay:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", lX, tY)
	overlay:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", rX, bY)
	overlay:Hide()

	self.overlayFrame = overlay
	-- Reset memoized state so the freshly-created frame re-applies texture/color.
	self._overlayTexturePath = nil
	self._overlayColorSig = nil
end

---Sets the overlay StatusBar value. No-op if overlay has not been created.
---@param value number # The current value
function TRB.Classes.OverlaySlot:SetOverlayValue(value)
	if not self.overlayFrame then return end
	self.overlayFrame:SetValue(value)
end

---Sets the overlay StatusBar min/max values. No-op if overlay has not been created.
---@param min number
---@param max number
function TRB.Classes.OverlaySlot:SetOverlayMinMax(min, max)
	if not self.overlayFrame then return end
	self.overlayFrame:SetMinMaxValues(min, max)
end

---Sets the overlay StatusBar fill texture. No-op if overlay has not been created.
---@param texture string # Path to the texture
function TRB.Classes.OverlaySlot:SetOverlayTexture(texture)
	if not self.overlayFrame then return end
	if self._overlayTexturePath == texture then return end
	self._overlayTexturePath = texture
	-- Changing the texture resets the fill texture's vertex color, so force color re-apply.
	self._overlayColorSig = nil
	self.overlayFrame:SetStatusBarTexture(texture)
	local fillTexture = self.overlayFrame:GetStatusBarTexture()
	if fillTexture then
		fillTexture:SetDrawLayer("ARTWORK", 0)
	end
end

---Sets the overlay StatusBar fill color from an AARRGGBB hex string. No-op if overlay has not been created.
---@param colorString string # ARGB hex color string (e.g., "66FFFFFF" for semi-transparent white)
function TRB.Classes.OverlaySlot:SetOverlayColor(colorString)
	if not self.overlayFrame then return end
	local sig = "flat:" .. tostring(colorString)
	if self._overlayColorSig == sig then return end
	self._overlayColorSig = sig
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	local fillTexture = self.overlayFrame:GetStatusBarTexture()
	if fillTexture then
		-- Clear any active gradient before applying flat color
		if self._overlayGradientActive then
			local white = CreateColor(1, 1, 1, 1)
			fillTexture:SetGradient("HORIZONTAL", white, white)
			self._overlayGradientActive = false
		end
		fillTexture:SetVertexColor(r, g, b, a)
	end
end

---Applies a two-color gradient to the overlay StatusBar fill texture. No-op if overlay has not been created.
---@param color1String string # ARGB hex color string for the start color
---@param color2String string # ARGB hex color string for the end color
---@param direction string # "horizontal" or "vertical"
function TRB.Classes.OverlaySlot:SetOverlayColorGradient(color1String, color2String, direction)
	if not self.overlayFrame then return end
	local sig = "grad:" .. tostring(color1String) .. ":" .. tostring(color2String) .. ":" .. tostring(direction)
	if self._overlayColorSig == sig then return end
	self._overlayColorSig = sig
	local Color = TRB.Functions.Color
	local r1, g1, b1, a1 = Color:GetRGBAFromString(color1String, true)
	local r2, g2, b2, a2 = Color:GetRGBAFromString(color2String, true)
	self.overlayFrame:SetStatusBarColor(1, 1, 1, 1)
	local fillTexture = self.overlayFrame:GetStatusBarTexture()
	if fillTexture then
		local apiDirection = direction == "vertical" and "VERTICAL" or "HORIZONTAL"
		local minColor = CreateColor(r1, g1, b1, a1)
		local maxColor = CreateColor(r2, g2, b2, a2)
		if apiDirection == "VERTICAL" then
			minColor, maxColor = maxColor, minColor
		end
		fillTexture:SetGradient(apiDirection, minColor, maxColor)
	end
	self._overlayGradientActive = true
end

---Shows the overlay StatusBar. No-op if overlay has not been created.
function TRB.Classes.OverlaySlot:ShowOverlay()
	if not self.overlayFrame then return end
	self.overlayFrame:Show()
end

---Hides the overlay StatusBar. No-op if overlay has not been created.
function TRB.Classes.OverlaySlot:HideOverlay()
	if not self.overlayFrame then return end
	self.overlayFrame:Hide()
end

---Returns the overlay frame, or nil if not created.
---@return StatusBar?
function TRB.Classes.OverlaySlot:GetOverlayFrame()
	return self.overlayFrame
end

-- ============================================================================
-- Appended Overlay (clip-frame approach)
-- ============================================================================
-- The appended overlay anchors a child StatusBar's LEFT edge to the primary
-- fill texture's RIGHT edge, inside a clip container that prevents the
-- overlay region from extending past the bar's right boundary.

---Re-anchors the appended overlay clip frame and its child StatusBar.
---Called when border, fill texture, or fill direction changes on the parent node.
---@param force boolean? # When true, always re-anchors. When false/nil, skips when no geometry-relevant input changed.
function TRB.Classes.OverlaySlot:ReanchorAppendedOverlay(force)
	if not self.appendedClipFrame then return end

	local parent = self.parentNode
	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)

	-- Skip redundant re-anchoring when no geometry-relevant input has changed.
	-- The overlay bar is anchored to the primary fill texture's leading edge, so it
	-- already tracks the fill automatically each frame without re-anchoring. Re-anchoring
	-- every frame against a live (and possibly interpolating) StatusBar fill texture causes
	-- visible flicker, so only re-anchor when the geometry, fill texture object, or the
	-- empty/non-empty fill state actually changes.
	local fillTexture = parent.frame:GetStatusBarTexture()
	local fillRatio = self:GetParentFillRatio()
	local isEmpty = fillRatio ~= nil and fillRatio <= 0
	local sig = string.format("%s|%s|%s|%s|%s|%s|%s",
		tostring(parent.border), tostring(parent.width), tostring(parent.height),
		fillDirection, tostring(self.fullHeight), tostring(fillTexture), tostring(isEmpty))
	if force ~= true and self.appendedOverlayReady and self._appendedAnchorSig == sig then
		return
	end
	self._appendedAnchorSig = sig

	-- Re-anchor clip frame: it constrains only the FILL axis (so the appended bar can't draw past the
	-- bar ends). The cross axis is left full -- the explicit overlay size below handles the side borders.
	self.appendedClipFrame:ClearAllPoints()
	local clipLX, clipTY, clipRX, clipBY = self:GetClipInsets(fillDirection)
	self.appendedClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", clipLX, clipTY)
	self.appendedClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", clipRX, clipBY)
	self.appendedOverlayReady = true

	-- Re-anchor the overlay bar to the current fill texture's leading edge. A SINGLE edge anchor (not
	-- two corners) is used so the explicit size set below is honored and the overlay is cross-centered.
	if self.appendedOverlayFrame then
		-- Set orientation to match the parent bar
		self.appendedOverlayFrame:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
		self.appendedOverlayFrame:SetReverseFill(Bar:GetReverseFillFromFillDirection(fillDirection))
		self.appendedOverlayFrame:SetRotatesTexture(isVertical)

		if fillRatio ~= nil and fillRatio <= 0 then
			-- Empty fill: anchor the trailing edge to the bar's inner fill-start edge.
			self.appendedOverlayFrame:ClearAllPoints()
			if fillDirection == "rightLeft" then
				self.appendedOverlayFrame:SetPoint("RIGHT", parent.frame, "RIGHT", -parent.border, 0)
			elseif fillDirection == "bottomTop" then
				self.appendedOverlayFrame:SetPoint("BOTTOM", parent.frame, "BOTTOM", 0, parent.border)
			elseif fillDirection == "topBottom" then
				self.appendedOverlayFrame:SetPoint("TOP", parent.frame, "TOP", 0, -parent.border)
			else -- leftRight
				self.appendedOverlayFrame:SetPoint("LEFT", parent.frame, "LEFT", parent.border, 0)
			end
		elseif fillTexture then
			self.appendedOverlayFrame:ClearAllPoints()
			if fillDirection == "rightLeft" then
				self.appendedOverlayFrame:SetPoint("RIGHT", fillTexture, "LEFT", 0, 0)
			elseif fillDirection == "bottomTop" then
				self.appendedOverlayFrame:SetPoint("BOTTOM", fillTexture, "TOP", 0, 0)
			elseif fillDirection == "topBottom" then
				self.appendedOverlayFrame:SetPoint("TOP", fillTexture, "BOTTOM", 0, 0)
			else -- leftRight
				self.appendedOverlayFrame:SetPoint("LEFT", fillTexture, "RIGHT", 0, 0)
			end
		end

		-- Fill axis = FULL bar dimension (the primary StatusBar fill spans the whole frame, with the
		-- border drawn over its edge). CROSS axis subtracts the border on both sides (border * 2) so the
		-- overlay sits inside the side borders -- unless fullHeight, which extends it through them.
		local crossInset = self.fullHeight and 0 or (2 * parent.border)
		if isVertical then
			self.appendedOverlayFrame:SetHeight(math.max(1, parent.height))
			self.appendedOverlayFrame:SetWidth(math.max(1, parent.width - crossInset))
		else
			self.appendedOverlayFrame:SetWidth(math.max(1, parent.width))
			self.appendedOverlayFrame:SetHeight(math.max(1, parent.height - crossInset))
		end
	end
end

---Creates the appended overlay system: a clip container + child StatusBar.
---The child StatusBar is anchored to the primary fill texture's leading edge,
---extending in the same direction as the fill.
---Idempotent: calling this multiple times is safe.
function TRB.Classes.OverlaySlot:CreateAppendedOverlay()
	if self.appendedClipFrame then
		return
	end

	local parent = self.parentNode
	local clipName = parent.name .. "_" .. self.slotName .. "_AppendedClip"

	-- Create clip container off-screen so any initial flash is invisible to the user.
	-- It will be reanchored to the correct position after one frame.
	local clip = CreateFrame("Frame", clipName, parent.frame)
	clip:SetFrameLevel(parent.frame:GetFrameLevel() + 1)
	clip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -10000, 10000)
	clip:SetSize(1, 1)
	clip:SetClipsChildren(true)

	-- Create overlay StatusBar inside the clip frame
	local overlayBarName = parent.name .. "_" .. self.slotName .. "_AppendedOverlay"
	local overlayBar = CreateFrame("StatusBar", overlayBarName, clip)
	overlayBar:SetFrameLevel(clip:GetFrameLevel() + 1)
	overlayBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
	overlayBar:SetMinMaxValues(0, 1)
	overlayBar:SetValue(0)

	-- Set orientation to match parent bar
	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)
	overlayBar:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
	overlayBar:SetReverseFill(Bar:GetReverseFillFromFillDirection(fillDirection))
	overlayBar:SetRotatesTexture(isVertical)

	-- Anchor a SINGLE edge to the fill texture's leading edge, so the explicit size set below is honored
	-- and the overlay is centered on the cross axis.
	local fillTexture = parent.frame:GetStatusBarTexture()
	if fillTexture then
		if fillDirection == "rightLeft" then
			overlayBar:SetPoint("RIGHT", fillTexture, "LEFT", 0, 0)
		elseif fillDirection == "bottomTop" then
			overlayBar:SetPoint("BOTTOM", fillTexture, "TOP", 0, 0)
		elseif fillDirection == "topBottom" then
			overlayBar:SetPoint("TOP", fillTexture, "BOTTOM", 0, 0)
		else -- leftRight
			overlayBar:SetPoint("LEFT", fillTexture, "RIGHT", 0, 0)
		end
	end

	-- Fill axis = FULL bar dimension (the primary StatusBar fill spans the whole frame, with the border
	-- drawn over its edge). CROSS axis subtracts the border on both sides (border * 2) so the overlay
	-- sits inside the side borders -- unless fullHeight, which extends it through them.
	local crossInset = self.fullHeight and 0 or (2 * parent.border)
	if isVertical then
		overlayBar:SetHeight(math.max(1, parent.height))
		overlayBar:SetWidth(math.max(1, parent.width - crossInset))
	else
		overlayBar:SetWidth(math.max(1, parent.width))
		overlayBar:SetHeight(math.max(1, parent.height - crossInset))
	end

	self.appendedClipFrame = clip
	self.appendedOverlayFrame = overlayBar
	self.appendedOverlayReady = false
	-- Reset memoized state so the freshly-created frame re-applies anchor/texture/color.
	self._appendedAnchorSig = nil
	self._appendedTexturePath = nil
	self._appendedColorSig = nil

	-- After one frame, reanchor the clip to the correct position on the bar.
	-- Any flash from initial geometry happens off-screen during this frame.
	local slot = self
	C_Timer.After(0, function()
		if slot.appendedClipFrame then
			slot:ReanchorAppendedOverlay(true)
		end
	end)
end

---Sets the appended overlay StatusBar value. No-op if not created.
---@param value number
function TRB.Classes.OverlaySlot:SetAppendedOverlayValue(value)
	if not self.appendedOverlayFrame then return end
	self.appendedOverlayFrame:SetValue(value)
end

---Sets the appended overlay StatusBar min/max values. No-op if not created.
---@param min number
---@param max number
function TRB.Classes.OverlaySlot:SetAppendedOverlayMinMax(min, max)
	if not self.appendedOverlayFrame then return end
	self.appendedOverlayFrame:SetMinMaxValues(min, max)
end

---Enables or disables clipping on the appended overlay's clip frame.
---When clipping is disabled, the overlay can visually extend past the bar's right boundary.
---@param clip boolean # true to clip (default behavior), false to allow overflow
function TRB.Classes.OverlaySlot:SetAppendedOverlayClipping(clip)
	if not self.appendedClipFrame then return end
	self.appendedClipFrame:SetClipsChildren(clip)
end

---Sets the fill-axis dimension of the appended overlay StatusBar.
---For horizontal fill (leftRight/rightLeft), sets width. For vertical fill (bottomTop/topBottom), sets height.
---Used by overflow mode to dynamically scale the overlay bar when the overlay value exceeds max health.
---@param size number # The desired fill-axis dimension in pixels
function TRB.Classes.OverlaySlot:SetAppendedOverlayWidth(size)
	if not self.appendedOverlayFrame then return end
	local isVertical = TRB.Functions.Bar:IsVerticalFill(self.parentNode.fillDirection)
	if isVertical then
		self.appendedOverlayFrame:SetHeight(math.max(1, size))
	else
		self.appendedOverlayFrame:SetWidth(math.max(1, size))
	end
end

---Sets the appended overlay StatusBar fill texture. No-op if not created.
---@param texture string
function TRB.Classes.OverlaySlot:SetAppendedOverlayTexture(texture)
	if not self.appendedOverlayFrame then return end
	if self._appendedTexturePath == texture then return end
	self._appendedTexturePath = texture
	-- Changing the texture resets the fill texture's vertex color, so force color re-apply.
	self._appendedColorSig = nil
	self.appendedOverlayFrame:SetStatusBarTexture(texture)
	local fillTexture = self.appendedOverlayFrame:GetStatusBarTexture()
	if fillTexture then
		fillTexture:SetDrawLayer("ARTWORK", 0)
	end
end

---Sets the appended overlay StatusBar fill color from an AARRGGBB hex string. No-op if not created.
---@param colorString string
function TRB.Classes.OverlaySlot:SetAppendedOverlayColor(colorString)
	if not self.appendedOverlayFrame then return end
	local sig = "flat:" .. tostring(colorString)
	if self._appendedColorSig == sig then return end
	self._appendedColorSig = sig
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	local fillTexture = self.appendedOverlayFrame:GetStatusBarTexture()
	if fillTexture then
		-- Clear any active gradient before applying flat color
		if self._appendedGradientActive then
			local white = CreateColor(1, 1, 1, 1)
			fillTexture:SetGradient("HORIZONTAL", white, white)
			self._appendedGradientActive = false
		end
		fillTexture:SetVertexColor(r, g, b, a)
	end
end

---Applies a two-color gradient to the appended overlay fill texture. No-op if not created.
---@param color1String string # ARGB hex color string for the start color
---@param color2String string # ARGB hex color string for the end color
---@param direction string # "horizontal" or "vertical"
function TRB.Classes.OverlaySlot:SetAppendedOverlayColorGradient(color1String, color2String, direction)
	if not self.appendedOverlayFrame then return end
	local sig = "grad:" .. tostring(color1String) .. ":" .. tostring(color2String) .. ":" .. tostring(direction)
	if self._appendedColorSig == sig then return end
	self._appendedColorSig = sig
	local Color = TRB.Functions.Color
	local r1, g1, b1, a1 = Color:GetRGBAFromString(color1String, true)
	local r2, g2, b2, a2 = Color:GetRGBAFromString(color2String, true)
	self.appendedOverlayFrame:SetStatusBarColor(1, 1, 1, 1)
	local fillTexture = self.appendedOverlayFrame:GetStatusBarTexture()
	if fillTexture then
		local apiDirection = direction == "vertical" and "VERTICAL" or "HORIZONTAL"
		local minColor = CreateColor(r1, g1, b1, a1)
		local maxColor = CreateColor(r2, g2, b2, a2)
		if apiDirection == "VERTICAL" then
			minColor, maxColor = maxColor, minColor
		end
		fillTexture:SetGradient(apiDirection, minColor, maxColor)
	end
	self._appendedGradientActive = true
end

---Shows the appended overlay. No-op if not created.
function TRB.Classes.OverlaySlot:ShowAppendedOverlay()
	if not self.appendedClipFrame then return end
	self.appendedClipFrame:Show()
end

---Hides the appended overlay. No-op if not created.
function TRB.Classes.OverlaySlot:HideAppendedOverlay()
	if not self.appendedClipFrame then return end
	self.appendedClipFrame:Hide()
end

---Returns the appended overlay frame, or nil if not created.
---@return StatusBar?
function TRB.Classes.OverlaySlot:GetAppendedOverlayFrame()
	return self.appendedOverlayFrame
end

-- ============================================================================
-- Inset Overlay (reverse-fill clip-frame approach)
-- ============================================================================
-- The inset overlay anchors a reverse-fill child StatusBar's RIGHT edge to the
-- primary fill texture's RIGHT edge, inside a clip container. The reverse fill
-- goes leftward from the fill position, showing the overlay "eating into" the fill.

---Re-anchors the inset overlay clip frame and its child StatusBar.
---Called when border, fill texture, or fill direction changes on the parent node.
---@param force boolean? # When true, always re-anchors. When false/nil, skips when no geometry-relevant input changed.
function TRB.Classes.OverlaySlot:ReanchorInsetOverlay(force)
	if not self.insetClipFrame then return end

	local parent = self.parentNode
	-- Same forbidden fill texture as the end cap: nothing of ours may anchor to an engine-driven edge.
	if parent:IsEngineDriven() then
		self.insetClipFrame:Hide()
		self.insetOverlayReady = false
		self._insetAnchorSig = nil
		return
	end

	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)

	-- Skip redundant re-anchoring when no geometry-relevant input has changed. The inset
	-- overlay tracks the fill texture's leading edge automatically once anchored, so only
	-- re-anchor when the geometry, fill texture object, or the fill-edge border-correction
	-- offset (which depends on the fill ratio) actually changes. Re-anchoring every frame
	-- against a live, interpolating fill texture causes visible flicker.
	local fillTexture = parent.frame:GetStatusBarTexture()
	local fillEdgeXOffset, fillEdgeYOffset = self:GetFillEdgeAnchorOffsets(fillDirection)
	local sig = string.format("%s|%s|%s|%s|%s|%s|%d|%d",
		tostring(parent.border), tostring(parent.width), tostring(parent.height),
		fillDirection, tostring(self.fullHeight), tostring(fillTexture),
		math.floor((fillEdgeXOffset or 0) + 0.5), math.floor((fillEdgeYOffset or 0) + 0.5))
	if force ~= true and self.insetOverlayReady and self._insetAnchorSig == sig then
		return
	end
	self._insetAnchorSig = sig

	-- Re-anchor clip frame: it constrains only the FILL axis (so the inset can't draw past the bar
	-- ends). The cross axis is left full -- the explicit overlay size below handles the side borders.
	self.insetClipFrame:ClearAllPoints()
	local clipLX, clipTY, clipRX, clipBY = self:GetClipInsets(fillDirection)
	self.insetClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", clipLX, clipTY)
	self.insetClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", clipRX, clipBY)
	self.insetOverlayReady = true

	-- Re-anchor the overlay bar with reverse-fill relative to the primary fill direction
	if self.insetOverlayFrame then
		-- The inset overlay fills OPPOSITE to the primary bar's direction
		self.insetOverlayFrame:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
		-- Reverse fill is the OPPOSITE of the parent's reverse fill
		self.insetOverlayFrame:SetReverseFill(not Bar:GetReverseFillFromFillDirection(fillDirection))
		self.insetOverlayFrame:SetRotatesTexture(isVertical)

		if fillTexture then
			self.insetOverlayFrame:ClearAllPoints()
			-- Anchor a SINGLE edge (not two corners) to the fill's leading edge, so the explicit size set
			-- below is honored and the overlay is centered on the cross axis.
			if fillDirection == "rightLeft" then
				-- Primary fills right→left, inset eats from LEFT edge of fill
				self.insetOverlayFrame:SetPoint("LEFT", fillTexture, "LEFT", fillEdgeXOffset, fillEdgeYOffset)
			elseif fillDirection == "bottomTop" then
				-- Primary fills bottom→top, inset eats from TOP edge of fill
				self.insetOverlayFrame:SetPoint("TOP", fillTexture, "TOP", fillEdgeXOffset, fillEdgeYOffset)
			elseif fillDirection == "topBottom" then
				-- Primary fills top→bottom, inset eats from BOTTOM edge of fill
				self.insetOverlayFrame:SetPoint("BOTTOM", fillTexture, "BOTTOM", fillEdgeXOffset, fillEdgeYOffset)
			else -- leftRight
				-- Primary fills left→right, inset eats from RIGHT edge of fill
				self.insetOverlayFrame:SetPoint("RIGHT", fillTexture, "RIGHT", fillEdgeXOffset, fillEdgeYOffset)
			end

			-- Fill axis = FULL bar dimension (the primary StatusBar fill spans the whole frame, with the
			-- border drawn over its edge). CROSS axis subtracts the border on both sides (border * 2) so the
			-- overlay sits inside the side borders -- unless fullHeight, which extends it through them.
			local crossInset = self.fullHeight and 0 or (2 * parent.border)
			if isVertical then
				self.insetOverlayFrame:SetHeight(math.max(1, parent.height))
				self.insetOverlayFrame:SetWidth(math.max(1, parent.width - crossInset))
			else
				self.insetOverlayFrame:SetWidth(math.max(1, parent.width))
				self.insetOverlayFrame:SetHeight(math.max(1, parent.height - crossInset))
			end
		end
	end
end

---Creates the inset overlay system: a clip container + reverse-fill child StatusBar.
---The child StatusBar fills in the opposite direction of the parent bar, starting from
---the fill's leading edge and "eating into" the primary fill.
---Idempotent: calling this multiple times is safe.
function TRB.Classes.OverlaySlot:CreateInsetOverlay()
	if self.insetClipFrame then
		return
	end

	local parent = self.parentNode
	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)
	local clipName = parent.name .. "_" .. self.slotName .. "_InsetClip"

	-- Create clip container off-screen so any initial flash is invisible to the user.
	-- It will be reanchored to the correct position after one frame.
	local clip = CreateFrame("Frame", clipName, parent.frame)
	clip:SetFrameLevel(parent.frame:GetFrameLevel() + 1)
	clip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -10000, 10000)
	clip:SetSize(1, 1)
	clip:SetClipsChildren(true)

	-- Create overlay StatusBar inside the clip frame with reverse fill relative to parent
	local overlayBarName = parent.name .. "_" .. self.slotName .. "_InsetOverlay"
	local overlayBar = CreateFrame("StatusBar", overlayBarName, clip)
	overlayBar:SetFrameLevel(clip:GetFrameLevel() + 1)
	overlayBar:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
	overlayBar:SetReverseFill(not Bar:GetReverseFillFromFillDirection(fillDirection))
	overlayBar:SetRotatesTexture(isVertical)
	overlayBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
	overlayBar:SetMinMaxValues(0, 1)
	overlayBar:SetValue(0)

	-- Anchor a SINGLE edge to the fill texture's leading edge (opposite side from the appended overlay),
	-- so the explicit size set below is honored and the overlay is centered on the cross axis.
	local fillTexture = parent.frame:GetStatusBarTexture()
	if fillTexture then
		local fillEdgeXOffset, fillEdgeYOffset = self:GetFillEdgeAnchorOffsets(fillDirection)
		if fillDirection == "rightLeft" then
			overlayBar:SetPoint("LEFT", fillTexture, "LEFT", fillEdgeXOffset, fillEdgeYOffset)
		elseif fillDirection == "bottomTop" then
			overlayBar:SetPoint("TOP", fillTexture, "TOP", fillEdgeXOffset, fillEdgeYOffset)
		elseif fillDirection == "topBottom" then
			overlayBar:SetPoint("BOTTOM", fillTexture, "BOTTOM", fillEdgeXOffset, fillEdgeYOffset)
		else -- leftRight
			overlayBar:SetPoint("RIGHT", fillTexture, "RIGHT", fillEdgeXOffset, fillEdgeYOffset)
		end
	end

	-- Fill axis = FULL bar dimension (the primary StatusBar fill spans the whole frame, with the border
	-- drawn over its edge). CROSS axis subtracts the border on both sides (border * 2) so the overlay
	-- sits inside the side borders -- unless fullHeight, which extends it through them.
	local crossInset = self.fullHeight and 0 or (2 * parent.border)
	if isVertical then
		overlayBar:SetHeight(math.max(1, parent.height))
		overlayBar:SetWidth(math.max(1, parent.width - crossInset))
	else
		overlayBar:SetWidth(math.max(1, parent.width))
		overlayBar:SetHeight(math.max(1, parent.height - crossInset))
	end

	self.insetClipFrame = clip
	self.insetOverlayFrame = overlayBar
	self.insetOverlayReady = false
	-- Reset memoized state so the freshly-created frame re-applies anchor/texture/color.
	self._insetAnchorSig = nil
	self._insetTexturePath = nil
	self._insetColorSig = nil

	-- After one frame, reanchor the clip to the correct position on the bar.
	-- Any flash from initial geometry happens off-screen during this frame.
	local slot = self
	C_Timer.After(0, function()
		if slot.insetClipFrame then
			slot.insetClipFrame:ClearAllPoints()
			local clipLX, clipTY, clipRX, clipBY = slot:GetClipInsets(slot.parentNode.fillDirection)
			slot.insetClipFrame:SetPoint("TOPLEFT", slot.parentNode.frame, "TOPLEFT", clipLX, clipTY)
			slot.insetClipFrame:SetPoint("BOTTOMRIGHT", slot.parentNode.frame, "BOTTOMRIGHT", clipRX, clipBY)
			slot.insetOverlayReady = true
		end
	end)
end

---Sets the inset overlay StatusBar value. No-op if not created.
---@param value number
function TRB.Classes.OverlaySlot:SetInsetOverlayValue(value)
	if not self.insetOverlayFrame then return end
	self.insetOverlayFrame:SetValue(value)
end

---Sets the inset overlay StatusBar min/max values. No-op if not created.
---@param min number
---@param max number
function TRB.Classes.OverlaySlot:SetInsetOverlayMinMax(min, max)
	if not self.insetOverlayFrame then return end
	self.insetOverlayFrame:SetMinMaxValues(min, max)
end

---Sets the inset overlay StatusBar fill texture. No-op if not created.
---@param texture string
function TRB.Classes.OverlaySlot:SetInsetOverlayTexture(texture)
	if not self.insetOverlayFrame then return end
	if self._insetTexturePath == texture then return end
	self._insetTexturePath = texture
	-- Changing the texture resets the fill texture's vertex color, so force color re-apply.
	self._insetColorSig = nil
	self.insetOverlayFrame:SetStatusBarTexture(texture)
	local fillTexture = self.insetOverlayFrame:GetStatusBarTexture()
	if fillTexture then
		fillTexture:SetDrawLayer("ARTWORK", 0)
	end
end

---Sets the inset overlay StatusBar fill color from an AARRGGBB hex string. No-op if not created.
---@param colorString string
function TRB.Classes.OverlaySlot:SetInsetOverlayColor(colorString)
	if not self.insetOverlayFrame then return end
	local sig = "flat:" .. tostring(colorString)
	if self._insetColorSig == sig then return end
	self._insetColorSig = sig
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	local fillTexture = self.insetOverlayFrame:GetStatusBarTexture()
	if fillTexture then
		-- Clear any active gradient before applying flat color
		if self._insetGradientActive then
			local white = CreateColor(1, 1, 1, 1)
			fillTexture:SetGradient("HORIZONTAL", white, white)
			self._insetGradientActive = false
		end
		fillTexture:SetVertexColor(r, g, b, a)
	end
end

---Applies a two-color gradient to the inset overlay fill texture. No-op if not created.
---@param color1String string # ARGB hex color string for the start color
---@param color2String string # ARGB hex color string for the end color
---@param direction string # "horizontal" or "vertical"
function TRB.Classes.OverlaySlot:SetInsetOverlayColorGradient(color1String, color2String, direction)
	if not self.insetOverlayFrame then return end
	local sig = "grad:" .. tostring(color1String) .. ":" .. tostring(color2String) .. ":" .. tostring(direction)
	if self._insetColorSig == sig then return end
	self._insetColorSig = sig
	local Color = TRB.Functions.Color
	local r1, g1, b1, a1 = Color:GetRGBAFromString(color1String, true)
	local r2, g2, b2, a2 = Color:GetRGBAFromString(color2String, true)
	self.insetOverlayFrame:SetStatusBarColor(1, 1, 1, 1)
	local fillTexture = self.insetOverlayFrame:GetStatusBarTexture()
	if fillTexture then
		local apiDirection = direction == "vertical" and "VERTICAL" or "HORIZONTAL"
		local minColor = CreateColor(r1, g1, b1, a1)
		local maxColor = CreateColor(r2, g2, b2, a2)
		if apiDirection == "VERTICAL" then
			minColor, maxColor = maxColor, minColor
		end
		fillTexture:SetGradient(apiDirection, minColor, maxColor)
	end
	self._insetGradientActive = true
end

---Shows the inset overlay. No-op if not created.
function TRB.Classes.OverlaySlot:ShowInsetOverlay()
	if not self.insetClipFrame then return end
	self.insetClipFrame:Show()
end

---Hides the inset overlay. No-op if not created.
function TRB.Classes.OverlaySlot:HideInsetOverlay()
	if not self.insetClipFrame then return end
	self.insetClipFrame:Hide()
end

---Returns the inset overlay frame, or nil if not created.
---@return StatusBar?
function TRB.Classes.OverlaySlot:GetInsetOverlayFrame()
	return self.insetOverlayFrame
end

-- ============================================================================
-- Range Overlays (gated whole-fill recolor)
-- ============================================================================
-- The gate window and the fill-edge clip stand in for a threshold comparison, which is what lets
-- this recolor a SECRET count.

-- Half a step below the threshold: these bars count whole stacks, so the window can never catch a
-- value part-way and never lands within float slop of the threshold or of the bar's own maximum.
local RANGE_GATE_EPSILON = 0.5
-- Parent-relative frame level of the clip. Gates take clip + (index - 1) capped at +3, keeping the
-- whole stack above the casting/spending overlays (+1, +2) and below the end cap (+8).
local RANGE_CLIP_LEVEL_OFFSET = 4
local RANGE_MAX_LEVEL_SPREAD = 3
-- Gate 0 paints the bar's own fill color, so the range system owns every layer and the node's fill
-- texture can be left transparent rather than bleeding through a range color that has alpha.
local RANGE_BASELINE_INDEX = 0

---Re-anchors the range overlay clip frame and its gate StatusBars.
---Called when border, fill texture, or fill direction changes on the parent node.
---@param force boolean? # When true, always re-anchors. When false/nil, skips when no geometry-relevant input changed.
function TRB.Classes.OverlaySlot:ReanchorRangeOverlays(force)
	if not self.rangeClipFrame then return end

	local parent = self.parentNode
	-- The engine's fill texture is forbidden: SetPoint against it errors.
	if parent:IsEngineDriven() then
		self.rangeBoundsClipFrame:Hide()
		self.rangeOverlayReady = false
		self._rangeAnchorSig = nil
		return
	end

	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)
	local fillTexture = parent.frame:GetStatusBarTexture()

	-- The clip is anchored to the fill texture object, which resizes itself as the value changes, so
	-- it tracks the fill edge every frame with no re-anchoring. Only geometry changes need a pass.
	local sig = string.format("%s|%s|%s|%s|%s|%s|%s",
		tostring(parent.border), tostring(parent.width), tostring(parent.height),
		fillDirection, tostring(self.fullHeight), tostring(fillTexture),
		tostring(self.rangeActiveCount))
	if force ~= true and self.rangeOverlayReady and self._rangeAnchorSig == sig then
		return
	end
	self._rangeAnchorSig = sig

	if fillTexture == nil then
		return
	end

	local border = parent.border or 0
	local crossInset = self.fullHeight and 0 or border

	self.rangeBoundsClipFrame:ClearAllPoints()
	local boundsLX, boundsTY, boundsRX, boundsBY = self:GetClipInsets(fillDirection)
	self.rangeBoundsClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", boundsLX, boundsTY)
	self.rangeBoundsClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", boundsRX, boundsBY)
	self.rangeBoundsClipFrame:Show()

	-- Leading corner comes from the bar's inner edge, trailing corner from the fill texture, so the
	-- clip spans exactly the visible fill. The fill texture covers the whole frame on the cross axis
	-- (the border is drawn over it), so the cross inset applies to its corner as it does the frame's.
	self.rangeClipFrame:ClearAllPoints()
	if fillDirection == "rightLeft" then
		self.rangeClipFrame:SetPoint("TOPLEFT", fillTexture, "TOPLEFT", 0, -crossInset)
		self.rangeClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", -border, crossInset)
	elseif fillDirection == "bottomTop" then
		self.rangeClipFrame:SetPoint("TOPLEFT", fillTexture, "TOPLEFT", crossInset, 0)
		self.rangeClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", -crossInset, border)
	elseif fillDirection == "topBottom" then
		self.rangeClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", crossInset, -border)
		self.rangeClipFrame:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMRIGHT", -crossInset, 0)
	else -- leftRight
		self.rangeClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", border, -crossInset)
		self.rangeClipFrame:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMRIGHT", 0, crossInset)
	end
	self.rangeClipFrame:Show()
	self.rangeOverlayReady = true

	-- Covering the clip exactly means an open gate paints the whole fill and nothing more, with no
	-- dependence on the node's own width bookkeeping.
	local orientation = Bar:GetOrientationFromFillDirection(fillDirection)
	local reverseFill = Bar:GetReverseFillFromFillDirection(fillDirection)
	local activeCount = self.rangeActiveCount or #self.rangeOverlayFrames
	for index = RANGE_BASELINE_INDEX, #self.rangeOverlayFrames do
		local gate = self.rangeOverlayFrames[index]
		gate:SetOrientation(orientation)
		gate:SetReverseFill(reverseFill)
		gate:SetRotatesTexture(isVertical)
		gate:ClearAllPoints()
		gate:SetAllPoints(self.rangeClipFrame)

		local probe = self.rangeProbeFrames[index]
		if probe ~= nil then
			probe:SetOrientation(orientation)
			probe:SetReverseFill(reverseFill)
			probe:ClearAllPoints()
			probe:SetAllPoints(self.rangeBoundsClipFrame)
		end

		-- A shutter spans what the next range's probe does NOT cover, so only the highest open gate
		-- paints. Both corners come from non-animating frames: a shut fill edge is (right - width).
		local shutter = self.rangeShutterFrames[index]
		local higher = index + 1 <= activeCount and self.rangeProbeFrames[index + 1] or nil
		local higherFill = higher and higher:GetStatusBarTexture() or nil
		local bounds = self.rangeBoundsClipFrame
		shutter:ClearAllPoints()
		if higherFill == nil then
			shutter:SetAllPoints(bounds)
		elseif fillDirection == "rightLeft" then
			shutter:SetPoint("TOPLEFT", bounds, "TOPLEFT", 0, 0)
			shutter:SetPoint("BOTTOMRIGHT", higherFill, "BOTTOMLEFT", 0, 0)
		elseif fillDirection == "bottomTop" then
			shutter:SetPoint("TOPLEFT", bounds, "TOPLEFT", 0, 0)
			shutter:SetPoint("BOTTOMRIGHT", higherFill, "TOPRIGHT", 0, 0)
		elseif fillDirection == "topBottom" then
			shutter:SetPoint("TOPLEFT", higherFill, "BOTTOMLEFT", 0, 0)
			shutter:SetPoint("BOTTOMRIGHT", bounds, "BOTTOMRIGHT", 0, 0)
		else -- leftRight
			shutter:SetPoint("TOPLEFT", higherFill, "TOPRIGHT", 0, 0)
			shutter:SetPoint("BOTTOMRIGHT", bounds, "BOTTOMRIGHT", 0, 0)
		end
		shutter:Show()
	end
end

---Creates one shutter/gate pair inside an existing range clip.
---@param slot TRB.Classes.OverlaySlot
---@param index integer # Range index, or RANGE_BASELINE_INDEX for the baseline gate
---@param fillDirection string
local function CreateRangeGate(slot, index, fillDirection)
	local Bar = TRB.Functions.Bar
	local isBaseline = index == RANGE_BASELINE_INDEX
	local prefix = slot.parentNode.name .. "_" .. slot.slotName .. "_Range"
	local suffix = isBaseline and "Baseline" or tostring(index)

	local shutter = CreateFrame("Frame", prefix .. "Shutter" .. suffix, slot.rangeClipFrame)
	shutter:SetFrameLevel(slot.rangeClipFrame:GetFrameLevel())
	shutter:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -10000, 10000)
	shutter:SetSize(1, 1)
	shutter:SetClipsChildren(true)
	slot.rangeShutterFrames[index] = shutter

	-- The baseline is never the anchor for a shutter below it, so it needs no probe.
	if not isBaseline then
		local probe = CreateFrame("StatusBar", prefix .. "Probe" .. suffix, slot.rangeBoundsClipFrame)
		probe:SetFrameLevel(slot.rangeClipFrame:GetFrameLevel())
		probe:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
		probe:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
		probe:SetReverseFill(Bar:GetReverseFillFromFillDirection(fillDirection))
		probe:SetMinMaxValues(0, 1)
---@diagnostic disable-next-line: redundant-parameter
		probe:SetValue(0, Enum.StatusBarInterpolation.Immediate)
		probe:SetAlpha(0)
		probe:Show()
		slot.rangeProbeFrames[index] = probe
	end

	local gate = CreateFrame("StatusBar", prefix .. suffix, shutter)
	-- Capped so five ranges still clear the end cap. The shutters make only one gate paint, so the
	-- ascending order only decides ties.
	gate:SetFrameLevel(slot.rangeClipFrame:GetFrameLevel() + math.min(index, RANGE_MAX_LEVEL_SPREAD))
	gate:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
	gate:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
	gate:SetReverseFill(Bar:GetReverseFillFromFillDirection(fillDirection))
	gate:SetRotatesTexture(Bar:IsVerticalFill(fillDirection))
	-- The baseline has no threshold: it is always full, and only its shutter decides whether it shows.
	gate:SetMinMaxValues(0, 1)
---@diagnostic disable-next-line: redundant-parameter
	gate:SetValue(isBaseline and 1 or 0, Enum.StatusBarInterpolation.Immediate)
	gate:Hide()
	slot.rangeOverlayFrames[index] = gate
	slot._rangeTexturePaths[index] = nil
	slot._rangeColorSigs[index] = nil
	slot._rangeGradientActive[index] = false
end

---Creates the range overlay system: one clip container, the baseline gate, plus `count` gate
---StatusBars. Idempotent for a given count; a larger count adds only the missing gates.
---@param count integer # Number of gated ranges this bar can show
function TRB.Classes.OverlaySlot:CreateRangeOverlays(count)
	local parent = self.parentNode

	if not self.rangeClipFrame then
		-- Outer clip trims the fill axis to the inner bar. The raw fill texture spans the whole frame
		-- with the border drawn over it, so near full the inner clip overshoots into the border zone.
		local outerName = parent.name .. "_" .. self.slotName .. "_RangeBoundsClip"
		local outer = CreateFrame("Frame", outerName, parent.frame)
		outer:SetFrameLevel(parent.frame:GetFrameLevel() + RANGE_CLIP_LEVEL_OFFSET)
		outer:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -10000, 10000)
		outer:SetSize(1, 1)
		outer:SetClipsChildren(true)

		local clipName = parent.name .. "_" .. self.slotName .. "_RangeClip"
		-- Created off-screen so any initial flash is invisible; the timer below anchors it.
		local clip = CreateFrame("Frame", clipName, outer)
		clip:SetFrameLevel(outer:GetFrameLevel())
		clip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -10000, 10000)
		clip:SetSize(1, 1)
		clip:SetClipsChildren(true)

		self.rangeBoundsClipFrame = outer
		self.rangeClipFrame = clip
		self.rangeShutterFrames = {}
		self.rangeProbeFrames = {}
		self.rangeOverlayFrames = {}
		self.rangeActiveCount = nil
		self.rangeOverlayReady = false
		self._rangeAnchorSig = nil
	end

	-- The shutter chain ends at the last range in use, so the count is anchor-relevant.
	local countChanged = self.rangeActiveCount ~= count
	self.rangeActiveCount = count

	local fillDirection = parent.fillDirection or "leftRight"
	local created = false
	if self.rangeOverlayFrames[RANGE_BASELINE_INDEX] == nil then
		CreateRangeGate(self, RANGE_BASELINE_INDEX, fillDirection)
		created = true
	end
	for index = #self.rangeOverlayFrames + 1, count do
		CreateRangeGate(self, index, fillDirection)
		created = true
	end

	if not self.rangeOverlayReady then
		local slot = self
		C_Timer.After(0, function()
			if slot.rangeClipFrame then
				slot:ReanchorRangeOverlays(true)
			end
		end)
	elseif created or countChanged then
		-- A gate added after the first pass has no anchor or size, and a changed count moves the end
		-- of the shutter chain. Neither shows up in the geometry signature.
		self:ReanchorRangeOverlays(true)
	end
end

---Sets the value at which a range gate opens. Below it the gate's fill is zero-width; at or above it
---the gate fills the whole bar and the clip trims it to the current fill. No-op if not created.
---@param index integer
---@param threshold number # The plain range start value, on the parent bar's own scale. Assumed to be a whole step.
function TRB.Classes.OverlaySlot:SetRangeOverlayThreshold(index, threshold)
	local gate = self.rangeOverlayFrames and self.rangeOverlayFrames[index]
	if not gate then return end
	gate:SetMinMaxValues(threshold - RANGE_GATE_EPSILON, threshold)
	local probe = self.rangeProbeFrames and self.rangeProbeFrames[index]
	if probe then
		probe:SetMinMaxValues(threshold - RANGE_GATE_EPSILON, threshold)
	end
end

---Sets a range gate's value. Accepts a secret: the StatusBar clamps it against the gate window.
---@param index integer
---@param value number
function TRB.Classes.OverlaySlot:SetRangeOverlayValue(index, value)
	local gate = self.rangeOverlayFrames and self.rangeOverlayFrames[index]
	if not gate then return end
	-- A gate is a threshold test, not a fill: easing it would slide the shutter boundary across the
	-- bar, which reads as the fill growing from the 0 end.
---@diagnostic disable-next-line: redundant-parameter
	gate:SetValue(value, Enum.StatusBarInterpolation.Immediate)
	local probe = self.rangeProbeFrames and self.rangeProbeFrames[index]
	if probe then
---@diagnostic disable-next-line: redundant-parameter
		probe:SetValue(value, Enum.StatusBarInterpolation.Immediate)
	end
end

---Sets a range gate's fill texture. No-op if not created.
---@param index integer
---@param texture string # Path to the texture
function TRB.Classes.OverlaySlot:SetRangeOverlayTexture(index, texture)
	local gate = self.rangeOverlayFrames and self.rangeOverlayFrames[index]
	if not gate then return end
	self.rangeTexture = texture
	if self._rangeTexturePaths[index] == texture then return end
	self._rangeTexturePaths[index] = texture
	-- Changing the texture resets the fill texture's vertex color, so force color re-apply.
	self._rangeColorSigs[index] = nil
	gate:SetStatusBarTexture(texture)
	local fillTexture = gate:GetStatusBarTexture()
	if fillTexture then
		fillTexture:SetDrawLayer("ARTWORK", 0)
	end
	-- This texture is what the range below anchors its shutter to, so a swap invalidates that anchor.
	self:ReanchorRangeOverlays(true)
end

---Sets a range gate's fill color from an AARRGGBB hex string. No-op if not created.
---@param index integer
---@param colorString string # ARGB hex color string
function TRB.Classes.OverlaySlot:SetRangeOverlayColor(index, colorString)
	local gate = self.rangeOverlayFrames and self.rangeOverlayFrames[index]
	if not gate then return end
	local sig = "flat:" .. tostring(colorString)
	if self._rangeColorSigs[index] == sig then return end
	self._rangeColorSigs[index] = sig
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	local fillTexture = gate:GetStatusBarTexture()
	if fillTexture then
		if self._rangeGradientActive[index] then
			local white = CreateColor(1, 1, 1, 1)
			fillTexture:SetGradient("HORIZONTAL", white, white)
			self._rangeGradientActive[index] = false
		end
		fillTexture:SetVertexColor(r, g, b, a)
	end
end

---Applies a two-color gradient to a range gate's fill texture. No-op if not created.
---@param index integer
---@param color1String string # ARGB hex color string for the start color
---@param color2String string # ARGB hex color string for the end color
---@param direction string # "horizontal" or "vertical"
function TRB.Classes.OverlaySlot:SetRangeOverlayColorGradient(index, color1String, color2String, direction)
	local gate = self.rangeOverlayFrames and self.rangeOverlayFrames[index]
	if not gate then return end
	local sig = "grad:" .. tostring(color1String) .. ":" .. tostring(color2String) .. ":" .. tostring(direction)
	if self._rangeColorSigs[index] == sig then return end
	self._rangeColorSigs[index] = sig
	local Color = TRB.Functions.Color
	local r1, g1, b1, a1 = Color:GetRGBAFromString(color1String, true)
	local r2, g2, b2, a2 = Color:GetRGBAFromString(color2String, true)
	gate:SetStatusBarColor(1, 1, 1, 1)
	local fillTexture = gate:GetStatusBarTexture()
	if fillTexture then
		local apiDirection = direction == "vertical" and "VERTICAL" or "HORIZONTAL"
		local minColor = CreateColor(r1, g1, b1, a1)
		local maxColor = CreateColor(r2, g2, b2, a2)
		if apiDirection == "VERTICAL" then
			minColor, maxColor = maxColor, minColor
		end
		fillTexture:SetGradient(apiDirection, minColor, maxColor)
	end
	self._rangeGradientActive[index] = true
end

---Shows a range gate. No-op if not created.
---@param index integer
function TRB.Classes.OverlaySlot:ShowRangeOverlay(index)
	local gate = self.rangeOverlayFrames and self.rangeOverlayFrames[index]
	if not gate then return end
	gate:Show()
end

---Hides a range gate. No-op if not created.
---@param index integer
function TRB.Classes.OverlaySlot:HideRangeOverlay(index)
	local gate = self.rangeOverlayFrames and self.rangeOverlayFrames[index]
	if not gate then return end
	gate:Hide()
end

---Hides every range gate on this slot.
function TRB.Classes.OverlaySlot:HideRangeOverlays()
	if not self.rangeOverlayFrames then return end
	for index = RANGE_BASELINE_INDEX, #self.rangeOverlayFrames do
		self.rangeOverlayFrames[index]:Hide()
	end
end

---Returns the gate StatusBar at the given index, or nil if not created.
---@param index integer
---@return StatusBar?
function TRB.Classes.OverlaySlot:GetRangeOverlayFrame(index)
	return self.rangeOverlayFrames and self.rangeOverlayFrames[index]
end

---Returns the index of the baseline gate, which paints the bar's own fill color.
---@return integer
function TRB.Classes.OverlaySlot:GetRangeBaselineIndex()
	return RANGE_BASELINE_INDEX
end

---Hides or restores the parent node's own fill texture. The baseline gate repaints it, so leaving it
---visible would show it through any range color that has alpha.
---@param hidden boolean
function TRB.Classes.OverlaySlot:SetParentFillHidden(hidden)
	local frame = self.parentNode and self.parentNode.frame
	local fillTexture = frame and frame.GetStatusBarTexture and frame:GetStatusBarTexture()
	if fillTexture == nil then return end
	fillTexture:SetAlpha(hidden and 0 or 1)
end

-- ============================================================================
-- End Cap (fixed-width band at the fill's leading edge, growing inward)
-- ============================================================================
-- The end cap anchors a fixed-width colored band's leading edge to the primary
-- fill texture's leading edge, extending backward into the fill, inside a clip
-- container. The clip trims the band at the bar start, so a fill narrower than
-- the cap shows a proportionally shrunken cap and an empty fill shows none.

---Distance the raw fill edge has pushed into the leading border zone, which the band must slide back by
---to stay inside the clip. Zero whenever the fill ratio cannot be read, so the cap sits flush instead.
---@return number
function TRB.Classes.OverlaySlot:GetEndCapOvershoot()
	local parent = self.parentNode
	if parent == nil or parent.border == nil or parent.border <= 0 then
		return 0
	end

	-- Rendered first: a bound DurationObject freezes GetValue at whatever was last written by hand,
	-- so the value ratio goes stale mid-cast while the texture keeps moving.
	local fillRatio = self:GetRenderedFillRatio() or self:GetParentFillRatio()
	if fillRatio == nil then
		return 0
	end

	local isVertical = TRB.Functions.Bar:IsVerticalFill(parent.fillDirection or "leftRight")
	local extent = isVertical and parent.height or parent.width
	if extent == nil then
		return 0
	end

	return math.max(0, (fillRatio * extent) - (extent - parent.border))
end

-- A fill that moves without a SetValue (a bound DurationObject, smooth interpolation settling) strands
-- the overshoot correction at the ratio it was last measured at, so those fills get watched instead.
local endCapTrackedSlots = {}
local endCapTrackerFrame = nil
local END_CAP_TRACK_IDLE_FRAMES = 6

---Stops watching a slot's fill for overshoot changes.
function TRB.Classes.OverlaySlot:StopEndCapTracking()
	endCapTrackedSlots[self] = nil
	if endCapTrackerFrame ~= nil and next(endCapTrackedSlots) == nil then
		endCapTrackerFrame:Hide()
	end
end

---Re-checks one tracked slot. Returns false when it no longer needs watching.
---@param slot TRB.Classes.OverlaySlot
---@param state table
---@return boolean
local function EndCapTrackSlot(slot, state)
	-- TEMPORARY: tick counter for /trb endcap. Remove with the probe.
---@diagnostic disable-next-line: inject-field
	slot._endCapTrackTicks = (slot._endCapTrackTicks or 0) + 1
	if slot.endCapClipFrame == nil or slot.parentNode == nil or slot.parentNode:IsEngineDriven() then
		return false
	end

	local ratio = slot:GetRenderedFillRatio()
	if ratio == nil then
		-- A secret fill stays unmeasurable for its whole life, so drop any correction left over from when
		-- the bar was last readable rather than leaving it riding along behind the fill.
		if slot._endCapOvershoot ~= 0 then
			slot:ReanchorEndCap()
		end
		return false
	end

	if state.ratio ~= nil and math.abs(ratio - state.ratio) < 0.0001 then
		state.idle = state.idle + 1
		return state.idle < END_CAP_TRACK_IDLE_FRAMES
	end
	state.ratio = ratio
	state.idle = 0

	-- ReanchorEndCap memoizes on a rounded overshoot, so let it decide whether a SetPoint is warranted.
	slot:ReanchorEndCap()
	return true
end

---Starts watching this slot's fill so the overshoot correction follows it. Idempotent.
function TRB.Classes.OverlaySlot:StartEndCapTracking()
	if self.endCapClipFrame == nil or self.endCapFrame == nil then
		return
	end

	local state = endCapTrackedSlots[self]
	if state == nil then
		endCapTrackedSlots[self] = { ratio = nil, idle = 0 }
	else
		state.idle = 0
	end

	if endCapTrackerFrame == nil then
		endCapTrackerFrame = CreateFrame("Frame")
		endCapTrackerFrame:SetScript("OnUpdate", function()
			for slot, slotState in pairs(endCapTrackedSlots) do
				if not EndCapTrackSlot(slot, slotState) then
					endCapTrackedSlots[slot] = nil
				end
			end
			if next(endCapTrackedSlots) == nil then
				endCapTrackerFrame:Hide()
			end
		end)
	end
	endCapTrackerFrame:Show()
end

---Re-anchors the end cap clip frame and its band frame.
---Called on geometry changes and whenever the overshoot correction's fill ratio moves.
---@param force boolean? # When true, always re-anchors. When false/nil, skips when no geometry-relevant input changed.
function TRB.Classes.OverlaySlot:ReanchorEndCap(force)
	if not self.endCapClipFrame then return end

	local parent = self.parentNode
	-- The engine's fill texture is forbidden: SetPoint against it errors. A cap on an engine-driven
	-- bar would have to be a region the engine's own button owns.
	if parent:IsEngineDriven() then
		self.endCapClipFrame:Hide()
		self.endCapReady = false
		self._endCapAnchorSig = nil
		self._endCapOvershoot = nil
		self:StopEndCapTracking()
		return
	end

	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)

	local overshoot = self:GetEndCapOvershoot()

	-- Skip redundant re-anchoring when no geometry-relevant input has changed. The band
	-- tracks the fill texture's leading edge automatically once anchored, so only re-anchor
	-- when the geometry, fill texture object, cap width, or the near-full overshoot correction
	-- (which depends on the fill ratio) actually changes.
	local fillTexture = parent.frame:GetStatusBarTexture()
	local sig = string.format("%s|%s|%s|%s|%s|%s|%s|%d",
		tostring(parent.border), tostring(parent.width), tostring(parent.height),
		fillDirection, tostring(self.fullHeight), tostring(fillTexture), tostring(self.endCapWidth),
		math.floor(overshoot + 0.5))
	if force ~= true and self.endCapReady and self._endCapAnchorSig == sig then
		return
	end
	self._endCapAnchorSig = sig
	self._endCapOvershoot = overshoot

	-- Both axes trim to the inner bar: the cap draws above the backdrop edge, so its sub-pixel spill
	-- would otherwise land on the border and read as a taller cap.
	self.endCapClipFrame:ClearAllPoints()
	local clipLX, clipTY, clipRX, clipBY = self:GetAnchorInsets(fillDirection)
	self.endCapClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", clipLX, clipTY)
	self.endCapClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", clipRX, clipBY)
	self.endCapReady = true

	if self.endCapFrame then
		self.endCapFrame:ClearAllPoints()
		-- Anchor a SINGLE edge (not two corners) to the fill's leading edge, so the explicit size set
		-- below is honored and the band is centered on the cross axis. The band extends backward into
		-- the fill; the overshoot slides it back toward the fill start when the raw edge is inside
		-- the border zone.
		--
		-- edgeNudge pushes the band's leading edge a half-pixel further in the growth direction. The
		-- bar renders at a fractional effective scale (non-integer widths), so the fill's leading edge
		-- lands on a sub-pixel boundary; the band frame rounds to a different boundary, leaving a thin
		-- fill sliver past the cap. Half a pixel toward the leading edge closes that seam.
		local edgeNudge = 0.5
		if fillDirection == "rightLeft" then
			self.endCapFrame:SetPoint("LEFT", fillTexture, "LEFT", overshoot - edgeNudge, 0)
		elseif fillDirection == "bottomTop" then
			self.endCapFrame:SetPoint("TOP", fillTexture, "TOP", 0, -overshoot + edgeNudge)
		elseif fillDirection == "topBottom" then
			self.endCapFrame:SetPoint("BOTTOM", fillTexture, "BOTTOM", 0, overshoot - edgeNudge)
		else -- leftRight
			self.endCapFrame:SetPoint("RIGHT", fillTexture, "RIGHT", -overshoot + edgeNudge, 0)
		end

		-- Fill axis = the configured cap width. CROSS axis subtracts the border on both sides
		-- (border * 2) so the band sits inside the side borders -- unless fullHeight, which
		-- extends it through them.
		local crossInset = self.fullHeight and 0 or (2 * parent.border)
		local capWidth = math.max(1, self.endCapWidth or 1)
		if isVertical then
			self.endCapFrame:SetHeight(capWidth)
			self.endCapFrame:SetWidth(math.max(1, parent.width - crossInset))
		else
			self.endCapFrame:SetWidth(capWidth)
			self.endCapFrame:SetHeight(math.max(1, parent.height - crossInset))
		end
	end
end

---Creates the end cap system: a clip container + fixed-width band frame.
---Idempotent: calling this multiple times is safe.
function TRB.Classes.OverlaySlot:CreateEndCap()
	if self.endCapClipFrame then
		return
	end

	local parent = self.parentNode
	local clipName = parent.name .. "_" .. self.slotName .. "_EndCapClip"

	-- Create clip container off-screen so any initial flash is invisible to the user.
	-- It will be reanchored to the correct position after one frame.
	local clip = CreateFrame("Frame", clipName, parent.frame)
	-- +8 keeps the cap above the casting/spending overlays (parent level +1) and the range
	-- overlays above them, while staying inside the bar's frame level stride.
	clip:SetFrameLevel(parent.frame:GetFrameLevel() + 8)
	clip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -10000, 10000)
	clip:SetSize(1, 1)
	clip:SetClipsChildren(true)

	local bandName = parent.name .. "_" .. self.slotName .. "_EndCap"
	local band = CreateFrame("Frame", bandName, clip)
	band:SetFrameLevel(clip:GetFrameLevel() + 1)
---@diagnostic disable-next-line: inject-field
	band.texture = band:CreateTexture(nil, "ARTWORK")
	band.texture:SetAllPoints(band)
	band.texture:SetTexture("Interface\\Buttons\\WHITE8X8")

	self.endCapClipFrame = clip
	self.endCapFrame = band
	self.endCapReady = false
	-- Reset memoized state so the freshly-created frame re-applies anchor/color.
	self._endCapAnchorSig = nil
	self._endCapOvershoot = nil
	self._endCapColorSig = nil

	-- After one frame, reanchor the clip to the correct position on the bar.
	-- Any flash from initial geometry happens off-screen during this frame.
	local slot = self
	C_Timer.After(0, function()
		if slot.endCapClipFrame then
			slot:ReanchorEndCap(true)
		end
	end)
end

---Sets the fill-axis width of the end cap band. No-op if not created.
---@param width number # The desired fill-axis width in pixels
function TRB.Classes.OverlaySlot:SetEndCapWidth(width)
	if self.endCapWidth == width then return end
	self.endCapWidth = width
	-- Before the first (off-screen) anchor pass, the creation timer applies the width instead
	if self.endCapReady then
		self:ReanchorEndCap(true)
	end
end

---Sets the end cap band color from an AARRGGBB hex string. No-op if not created.
---@param colorString string
function TRB.Classes.OverlaySlot:SetEndCapColor(colorString)
	if not self.endCapFrame then return end
	local sig = "flat:" .. tostring(colorString)
	if self._endCapColorSig == sig then return end
	self._endCapColorSig = sig
	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	self.endCapFrame.texture:SetVertexColor(r, g, b, a)
end

---Sets the end cap band color from a ColorCurve result (secret-safe; bypasses the color cache).
---@diagnostic disable-next-line: undefined-doc-name
---@param colorResult LuaCurveEvaluatedResult
function TRB.Classes.OverlaySlot:SetEndCapColorResult(colorResult)
	if not self.endCapFrame then return end
	if colorResult == nil or type(colorResult.GetRGBA) ~= "function" then
		return
	end
	self._endCapColorSig = nil
	self.endCapFrame.texture:SetVertexColor(colorResult:GetRGBA())
end

---Shows or hides the end cap. No-op if not created.
---@param shown boolean
function TRB.Classes.OverlaySlot:SetEndCapShown(shown)
	if not self.endCapClipFrame then return end
	self.endCapClipFrame:SetShown(shown)
end

---Shows the end cap. No-op if not created.
function TRB.Classes.OverlaySlot:ShowEndCap()
	self:SetEndCapShown(true)
end

---Hides the end cap. No-op if not created.
function TRB.Classes.OverlaySlot:HideEndCap()
	if not self.endCapClipFrame then return end
	self:StopEndCapTracking()
	self.endCapClipFrame:Hide()
end

---Returns the end cap band frame, or nil if not created.
---@return Frame?
function TRB.Classes.OverlaySlot:GetEndCapFrame()
	return self.endCapFrame
end

-- ============================================================================
-- Aggregate Operations
-- ============================================================================

---Re-anchors all existing overlay frame types on this slot.
---Called from BarNode:SetDimensions() and BarNode:SetTextures().
function TRB.Classes.OverlaySlot:Reanchor()
	local parent = self.parentNode

	-- Re-anchor generic overlay if it exists
	if self.overlayFrame then
		self.overlayFrame:ClearAllPoints()
		local lX, tY, rX, bY = self:GetAnchorInsets(parent.fillDirection)
		self.overlayFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", lX, tY)
		self.overlayFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", rX, bY)
	end

	-- Re-anchor appended overlay if it exists
	self:ReanchorAppendedOverlay(true)

	-- Re-anchor inset overlay if it exists
	self:ReanchorInsetOverlay(true)

	-- Re-anchor range overlays if they exist
	self:ReanchorRangeOverlays(true)

	-- Re-anchor end cap if it exists
	self:ReanchorEndCap(true)
end

---Reapplies the stored texture and color to all existing overlay frame types.
---Does NOT call Show/Hide — purely cosmetic refresh.
---Called from ApplyBarGroupsAppearance when textures/colors change in options.
function TRB.Classes.OverlaySlot:RefreshAppearance()
	local Color = TRB.Functions.Color

	if self.texture then
		if self.overlayFrame then
			self:SetOverlayTexture(self.texture)
		end
		if self.appendedOverlayFrame then
			self:SetAppendedOverlayTexture(self.texture)
		end
		if self.insetOverlayFrame then
			self:SetInsetOverlayTexture(self.texture)
		end
	end

	if self.color then
		if self.overlayFrame then
			Color:ApplyOverlayFillColor(self, self.color)
		end
		if self.appendedOverlayFrame then
			Color:ApplyOverlayFillColor(self, self.color, "appended")
		end
	end

	if self.insetOverlayFrame and (self.spendingColor or self.color) then
		Color:ApplyOverlayFillColor(self, self.spendingColor or self.color, "inset")
		end

	if self.rangeOverlayFrames then
		for index = RANGE_BASELINE_INDEX, #self.rangeOverlayFrames do
			if self.rangeTexture then
				self:SetRangeOverlayTexture(index, self.rangeTexture)
			end
			local rangeColor = self.rangeColors[index]
			if rangeColor then
				Color:ApplyRangeOverlayFillColor(self, index, rangeColor)
			end
		end
	end
end

---Hides all overlay frame types on this slot.
function TRB.Classes.OverlaySlot:HideAll()
	self:HideOverlay()
	self:HideAppendedOverlay()
	self:HideInsetOverlay()
	self:HideRangeOverlays()
	self:HideEndCap()
end
