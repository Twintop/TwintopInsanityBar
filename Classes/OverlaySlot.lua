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
	self.overlayFrame = nil
	self.appendedClipFrame = nil
	self.appendedOverlayFrame = nil
	self.appendedOverlayReady = nil
	self.insetClipFrame = nil
	self.insetOverlayFrame = nil
	self.insetOverlayReady = nil

	return self
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
	overlay:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", parent.border, -parent.border)
	overlay:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", -parent.border, parent.border)
	overlay:Hide()

	self.overlayFrame = overlay
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
function TRB.Classes.OverlaySlot:ReanchorAppendedOverlay()
	if not self.appendedClipFrame then return end

	local parent = self.parentNode
	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)

	-- Re-anchor clip frame to inner area
	self.appendedClipFrame:ClearAllPoints()
	self.appendedClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", parent.border, -parent.border)
	self.appendedClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", -parent.border, parent.border)
	self.appendedOverlayReady = true

	-- Re-anchor the overlay bar to the current fill texture's leading edge
	if self.appendedOverlayFrame then
		-- Set orientation to match the parent bar
		self.appendedOverlayFrame:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
		self.appendedOverlayFrame:SetReverseFill(Bar:GetReverseFillFromFillDirection(fillDirection))
		self.appendedOverlayFrame:SetRotatesTexture(isVertical)

		local fillTexture = parent.frame:GetStatusBarTexture()
		if fillTexture then
			self.appendedOverlayFrame:ClearAllPoints()
			if fillDirection == "rightLeft" then
				self.appendedOverlayFrame:SetPoint("TOPRIGHT", fillTexture, "TOPLEFT", 0, 0)
				self.appendedOverlayFrame:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMLEFT", 0, 0)
			elseif fillDirection == "bottomTop" then
				self.appendedOverlayFrame:SetPoint("BOTTOMLEFT", fillTexture, "TOPLEFT", 0, 0)
				self.appendedOverlayFrame:SetPoint("BOTTOMRIGHT", fillTexture, "TOPRIGHT", 0, 0)
			elseif fillDirection == "topBottom" then
				self.appendedOverlayFrame:SetPoint("TOPLEFT", fillTexture, "BOTTOMLEFT", 0, 0)
				self.appendedOverlayFrame:SetPoint("TOPRIGHT", fillTexture, "BOTTOMRIGHT", 0, 0)
			else -- leftRight
				self.appendedOverlayFrame:SetPoint("TOPLEFT", fillTexture, "TOPRIGHT", 0, 0)
				self.appendedOverlayFrame:SetPoint("BOTTOMLEFT", fillTexture, "BOTTOMRIGHT", 0, 0)
			end

			if isVertical then
				local innerHeight = math.max(1, parent.height - 2 * parent.border)
				self.appendedOverlayFrame:SetHeight(innerHeight)
				self.appendedOverlayFrame:SetWidth(parent.width - 2 * parent.border)
			else
				local innerWidth = math.max(1, parent.width - 2 * parent.border)
				self.appendedOverlayFrame:SetWidth(innerWidth)
			end
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

	-- Anchor to the fill texture's leading edge
	local fillTexture = parent.frame:GetStatusBarTexture()
	if fillTexture then
		if fillDirection == "rightLeft" then
			overlayBar:SetPoint("TOPRIGHT", fillTexture, "TOPLEFT", 0, 0)
			overlayBar:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMLEFT", 0, 0)
		elseif fillDirection == "bottomTop" then
			overlayBar:SetPoint("BOTTOMLEFT", fillTexture, "TOPLEFT", 0, 0)
			overlayBar:SetPoint("BOTTOMRIGHT", fillTexture, "TOPRIGHT", 0, 0)
		elseif fillDirection == "topBottom" then
			overlayBar:SetPoint("TOPLEFT", fillTexture, "BOTTOMLEFT", 0, 0)
			overlayBar:SetPoint("TOPRIGHT", fillTexture, "BOTTOMRIGHT", 0, 0)
		else -- leftRight
			overlayBar:SetPoint("TOPLEFT", fillTexture, "TOPRIGHT", 0, 0)
			overlayBar:SetPoint("BOTTOMLEFT", fillTexture, "BOTTOMRIGHT", 0, 0)
		end
	end

	-- Size = full inner bar dimension so the fill ratio matches the primary bar's scale
	if isVertical then
		local innerHeight = math.max(1, parent.height - 2 * parent.border)
		overlayBar:SetHeight(innerHeight)
		overlayBar:SetWidth(parent.width - 2 * parent.border)
	else
		local innerWidth = math.max(1, parent.width - 2 * parent.border)
		overlayBar:SetWidth(innerWidth)
	end

	self.appendedClipFrame = clip
	self.appendedOverlayFrame = overlayBar
	self.appendedOverlayReady = false

	-- After one frame, reanchor the clip to the correct position on the bar.
	-- Any flash from initial geometry happens off-screen during this frame.
	local slot = self
	C_Timer.After(0, function()
		if slot.appendedClipFrame then
			slot.appendedClipFrame:ClearAllPoints()
			slot.appendedClipFrame:SetPoint("TOPLEFT", slot.parentNode.frame, "TOPLEFT", slot.parentNode.border, -slot.parentNode.border)
			slot.appendedClipFrame:SetPoint("BOTTOMRIGHT", slot.parentNode.frame, "BOTTOMRIGHT", -slot.parentNode.border, slot.parentNode.border)
			slot.appendedOverlayReady = true
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
function TRB.Classes.OverlaySlot:ReanchorInsetOverlay()
	if not self.insetClipFrame then return end

	local parent = self.parentNode
	local fillDirection = parent.fillDirection or "leftRight"
	local Bar = TRB.Functions.Bar
	local isVertical = Bar:IsVerticalFill(fillDirection)

	-- Re-anchor clip frame to inner area
	self.insetClipFrame:ClearAllPoints()
	self.insetClipFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", parent.border, -parent.border)
	self.insetClipFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", -parent.border, parent.border)
	self.insetOverlayReady = true

	-- Re-anchor the overlay bar with reverse-fill relative to the primary fill direction
	if self.insetOverlayFrame then
		-- The inset overlay fills OPPOSITE to the primary bar's direction
		self.insetOverlayFrame:SetOrientation(Bar:GetOrientationFromFillDirection(fillDirection))
		-- Reverse fill is the OPPOSITE of the parent's reverse fill
		self.insetOverlayFrame:SetReverseFill(not Bar:GetReverseFillFromFillDirection(fillDirection))
		self.insetOverlayFrame:SetRotatesTexture(isVertical)

		local fillTexture = parent.frame:GetStatusBarTexture()
		if fillTexture then
			self.insetOverlayFrame:ClearAllPoints()
			if fillDirection == "rightLeft" then
				-- Primary fills right→left, inset eats from LEFT edge of fill
				self.insetOverlayFrame:SetPoint("TOPLEFT", fillTexture, "TOPLEFT", 0, 0)
				self.insetOverlayFrame:SetPoint("BOTTOMLEFT", fillTexture, "BOTTOMLEFT", 0, 0)
			elseif fillDirection == "bottomTop" then
				-- Primary fills bottom→top, inset eats from TOP edge of fill
				self.insetOverlayFrame:SetPoint("TOPLEFT", fillTexture, "TOPLEFT", 0, 0)
				self.insetOverlayFrame:SetPoint("TOPRIGHT", fillTexture, "TOPRIGHT", 0, 0)
			elseif fillDirection == "topBottom" then
				-- Primary fills top→bottom, inset eats from BOTTOM edge of fill
				self.insetOverlayFrame:SetPoint("BOTTOMLEFT", fillTexture, "BOTTOMLEFT", 0, 0)
				self.insetOverlayFrame:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMRIGHT", 0, 0)
			else -- leftRight
				-- Primary fills left→right, inset eats from RIGHT edge of fill
				self.insetOverlayFrame:SetPoint("TOPRIGHT", fillTexture, "TOPRIGHT", 0, 0)
				self.insetOverlayFrame:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMRIGHT", 0, 0)
			end

			if isVertical then
				local innerHeight = math.max(1, parent.height - 2 * parent.border)
				self.insetOverlayFrame:SetHeight(innerHeight)
				self.insetOverlayFrame:SetWidth(parent.width - 2 * parent.border)
			else
				local innerWidth = math.max(1, parent.width - 2 * parent.border)
				self.insetOverlayFrame:SetWidth(innerWidth)
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

	-- Anchor to the fill texture's leading edge (opposite side from the appended overlay)
	local fillTexture = parent.frame:GetStatusBarTexture()
	if fillTexture then
		if fillDirection == "rightLeft" then
			overlayBar:SetPoint("TOPLEFT", fillTexture, "TOPLEFT", 0, 0)
			overlayBar:SetPoint("BOTTOMLEFT", fillTexture, "BOTTOMLEFT", 0, 0)
		elseif fillDirection == "bottomTop" then
			overlayBar:SetPoint("TOPLEFT", fillTexture, "TOPLEFT", 0, 0)
			overlayBar:SetPoint("TOPRIGHT", fillTexture, "TOPRIGHT", 0, 0)
		elseif fillDirection == "topBottom" then
			overlayBar:SetPoint("BOTTOMLEFT", fillTexture, "BOTTOMLEFT", 0, 0)
			overlayBar:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMRIGHT", 0, 0)
		else -- leftRight
			overlayBar:SetPoint("TOPRIGHT", fillTexture, "TOPRIGHT", 0, 0)
			overlayBar:SetPoint("BOTTOMRIGHT", fillTexture, "BOTTOMRIGHT", 0, 0)
		end
	end

	-- Size = full inner bar dimension so the fill ratio matches the primary bar's scale
	if isVertical then
		local innerHeight = math.max(1, parent.height - 2 * parent.border)
		overlayBar:SetHeight(innerHeight)
		overlayBar:SetWidth(parent.width - 2 * parent.border)
	else
		local innerWidth = math.max(1, parent.width - 2 * parent.border)
		overlayBar:SetWidth(innerWidth)
	end

	self.insetClipFrame = clip
	self.insetOverlayFrame = overlayBar
	self.insetOverlayReady = false

	-- After one frame, reanchor the clip to the correct position on the bar.
	-- Any flash from initial geometry happens off-screen during this frame.
	local slot = self
	C_Timer.After(0, function()
		if slot.insetClipFrame then
			slot.insetClipFrame:ClearAllPoints()
			slot.insetClipFrame:SetPoint("TOPLEFT", slot.parentNode.frame, "TOPLEFT", slot.parentNode.border, -slot.parentNode.border)
			slot.insetClipFrame:SetPoint("BOTTOMRIGHT", slot.parentNode.frame, "BOTTOMRIGHT", -slot.parentNode.border, slot.parentNode.border)
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
		self.overlayFrame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", parent.border, -parent.border)
		self.overlayFrame:SetPoint("BOTTOMRIGHT", parent.frame, "BOTTOMRIGHT", -parent.border, parent.border)
	end

	-- Re-anchor appended overlay if it exists
	self:ReanchorAppendedOverlay()

	-- Re-anchor inset overlay if it exists
	self:ReanchorInsetOverlay()
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
