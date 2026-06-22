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
end

---Hides all overlay frame types on this slot.
function TRB.Classes.OverlaySlot:HideAll()
	self:HideOverlay()
	self:HideAppendedOverlay()
	self:HideInsetOverlay()
end
