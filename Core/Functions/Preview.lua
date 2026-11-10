local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.Preview = {}

-- Preview Mode: shows every bar that isn't Never Show, as Edit Mode does, and lets a bar drag its stack.
-- Session-only; nothing here is saved.

-- Above every bar overlay, threshold line, and bar text frame in the bar's strata.
local HANDLE_FRAME_LEVEL = 9000
local ANCHOR_ICON_SIZE = 16
local ANCHOR_TEXTURE = "Interface\\AddOns\\TwintopInsanityBar\\Images\\anchor64.png"
local LOCK_TEXTURE = "Interface\\AddOns\\TwintopInsanityBar\\Images\\lock64.png"
-- How far outside the bar the selection border sits, and how thick it is.
local SELECTION_OUTSET = 3
local SELECTION_THICKNESS = 2

local active = false
---@type table<string, TRB.Classes.PreviewHandle>
local handles = {}
---@type fun(active: boolean)[]
local listeners = {}
-- Position sliders by the anchor block they edit, so an open Layout tab follows a drag.
local positionSliders = setmetatable({}, { __mode = "k" })

-- The stack being dragged: its wrapper, its root bar, and where the wrapper's center started.
local dragWrapper = nil
local dragRootBarKey = nil
local dragStartX = 0
local dragStartY = 0

---@class TRB.Classes.PreviewHandle : Button
---@field kind string # What the handle moves. Only "bar" today; bar text frames come later.
---@field barKey string
---@field rootBarKey string? # The root of the stack this bar belongs to
---@field lockReason string? # Why the bar can't be dragged; nil when it can
---@field lockTexture Texture
---@field anchorIcon Texture # Marks the point the bar, or its stack, is attached by

---@return boolean
function TRB.Functions.Preview:IsActive()
	return active
end

---Calls `listener(active)` whenever Preview Mode turns on or off.
---@param listener fun(active: boolean)
function TRB.Functions.Preview:AddListener(listener)
	listeners[#listeners + 1] = listener
end

---Registers the sliders that edit an anchor block's offsets.
---@param anchor table
---@param horizontal Slider
---@param vertical Slider
function TRB.Functions.Preview:RegisterPositionSliders(anchor, horizontal, vertical)
	positionSliders[anchor] = { horizontal = horizontal, vertical = vertical }
end

---The saved bar settings table that owns an anchor block; the composed spec cache may hold an overlay of it.
---@param barKey string
---@param anchor table
---@return table?
local function FindAnchorOwner(barKey, anchor)
	local coreSettings = TRB.Functions.Bar:GetBarSettings(TRB.Data.settings.core, barKey)
	if coreSettings ~= nil and rawget(coreSettings, "anchor") == anchor then
		return coreSettings
	end
	local classSettings = TRB.Data.settings[TRB.Data.character.className]
	if type(classSettings) == "table" then
		for _, specSettings in pairs(classSettings) do
			if type(specSettings) == "table" then
				local barSettings = TRB.Functions.Bar:GetBarSettings(specSettings, barKey)
				if barSettings ~= nil and rawget(barSettings, "anchor") == anchor then
					return barSettings
				end
			end
		end
	end
	return nil
end

---@param value number
---@param limit number # The full range; the value is held to half of it either side of zero
---@return number
local function RoundAndClamp(value, limit)
	value = math.floor(value + 0.5)
	local low = math.ceil(-limit / 2)
	local high = math.floor(limit / 2)
	if value < low then
		return low
	elseif value > high then
		return high
	end
	return value
end

---Re-runs layout, which puts every stack back where its settings say.
local function ReapplyLayout()
	local barGroups = TRB.Frames.barGroups
	local cache = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.compositeKey]
	if barGroups ~= nil and cache ~= nil and cache.settings ~= nil then
		TRB.Functions.Bar:ApplyBarGroupsLayout(cache.settings, barGroups)
	end
end

---Moves a stack's saved position by how far it was dragged.
---@param rootBarKey string
---@param deltaX number
---@param deltaY number
local function SaveStackOffset(rootBarKey, deltaX, deltaY)
	local barGroups = TRB.Frames.barGroups
	local layoutSettings = barGroups and barGroups.layoutSettings
	local barSettings = layoutSettings and TRB.Functions.Bar:GetBarSettings(layoutSettings, rootBarKey)
	if barSettings ~= nil then
		local anchor = TRB.Functions.Bar:EnsureAnchorBlock(barSettings, rootBarKey)
		-- The offsets stay relative to the anchor the layout places the stack from, whatever point the
		-- client re-anchored the dragged frame to.
		local limits = TRB.Data.sanityCheckValues
		anchor.xOffset = RoundAndClamp((anchor.xOffset or 0) + deltaX, limits.barMaxWidth)
		anchor.yOffset = RoundAndClamp((anchor.yOffset or 0) + deltaY, limits.barMaxHeight)
		local owner = FindAnchorOwner(rootBarKey, anchor) or barSettings
		TRB.Functions.Bar:DualWriteAnchorToLegacy(owner)
		if owner ~= barSettings then
			-- A Use Global overlay carries its own copy of the legacy position.
			if rawget(barSettings, "xPos") ~= nil then
				rawset(barSettings, "xPos", owner.xPos)
			end
			if rawget(barSettings, "yPos") ~= nil then
				rawset(barSettings, "yPos", owner.yPos)
			end
		end

		local sliders = positionSliders[anchor]
		if sliders ~= nil then
			sliders.horizontal:SetValue(anchor.xOffset)
			sliders.vertical:SetValue(anchor.yOffset)
		end
	end
	ReapplyLayout()
end

---@param handle TRB.Classes.PreviewHandle
local function BeginDrag(handle)
	if dragWrapper ~= nil or handle.lockReason ~= nil or handle.rootBarKey == nil then
		return
	end
	local wrapper = TRB.Functions.EditMode:GetWrapperFrame(handle.rootBarKey)
	local x, y = nil, nil
	if wrapper ~= nil then
		x, y = wrapper:GetCenter()
	end
	if wrapper == nil or x == nil or y == nil then
		return
	end
	dragWrapper = wrapper
	dragRootBarKey = handle.rootBarKey
	dragStartX = x
	dragStartY = y
	wrapper:SetMovable(true)
	wrapper:StartMoving()
	GameTooltip:Hide()
end

local function EndDrag()
	local wrapper = dragWrapper
	local rootBarKey = dragRootBarKey
	if wrapper == nil or rootBarKey == nil then
		return
	end
	dragWrapper = nil
	dragRootBarKey = nil
	wrapper:StopMovingOrSizing()
	-- The position lives in our settings, not the client's layout cache.
	wrapper:SetUserPlaced(false)
	local x, y = wrapper:GetCenter()
	if x == nil or y == nil then
		ReapplyLayout()
		return
	end
	SaveStackOffset(rootBarKey, x - dragStartX, y - dragStartY)
end

---@param handle TRB.Classes.PreviewHandle
local function ShowTooltip(handle)
	if dragWrapper ~= nil then
		return
	end
	GameTooltip:SetOwner(handle, "ANCHOR_CURSOR")
	GameTooltip:SetText(TRB.Functions.Bar:GetBarDisplayName(handle.barKey, TRB.Data.character.classId, TRB.Data.character.specId), 1, 1, 1)
	GameTooltip:AddLine(handle.lockReason or L["PreviewModeDragTooltip"], nil, nil, nil, true)
	GameTooltip:AddLine(L["PreviewModeClickTooltip"], nil, nil, nil, true)
	GameTooltip:Show()
end

-- The border around the bar last clicked; it rides that bar's handle.
---@type Frame?
local selectionFrame = nil

---@param handle TRB.Classes.PreviewHandle
local function SelectHandle(handle)
	if selectionFrame == nil then
		selectionFrame = CreateFrame("Frame", nil, handle)
		local function Edge(point, relativePoint, width, height)
			local edge = selectionFrame:CreateTexture(nil, "OVERLAY")
			edge:SetColorTexture(1, 0.82, 0, 1)
			edge:SetPoint(point, selectionFrame, point, 0, 0)
			edge:SetPoint(relativePoint, selectionFrame, relativePoint, 0, 0)
			if width ~= nil then
				edge:SetWidth(width)
			else
				edge:SetHeight(height)
			end
		end
		Edge("TOPLEFT", "TOPRIGHT", nil, SELECTION_THICKNESS)
		Edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, SELECTION_THICKNESS)
		Edge("TOPLEFT", "BOTTOMLEFT", SELECTION_THICKNESS, nil)
		Edge("TOPRIGHT", "BOTTOMRIGHT", SELECTION_THICKNESS, nil)
	end
	selectionFrame:SetParent(handle)
	selectionFrame:ClearAllPoints()
	selectionFrame:SetPoint("TOPLEFT", handle, "TOPLEFT", -SELECTION_OUTSET, SELECTION_OUTSET)
	selectionFrame:SetPoint("BOTTOMRIGHT", handle, "BOTTOMRIGHT", SELECTION_OUTSET, -SELECTION_OUTSET)
	selectionFrame:Show()
end

---Whether Global Options owns a bar's position, as its Use Global setting decides.
---@param barKey string
---@return boolean
local function IsPositionedByGlobalOptions(barKey)
	local barGroups = TRB.Frames.barGroups
	local anchor = barGroups and barGroups.layoutSettings and TRB.Functions.Bar:GetBarAnchor(barGroups.layoutSettings, barKey)
	local coreSettings = TRB.Functions.Bar:GetBarSettings(TRB.Data.settings.core, barKey)
	return anchor ~= nil and coreSettings ~= nil and rawget(coreSettings, "anchor") == anchor
end

---Opens the options tab that positions a bar: Global Options' when that owns it, else the spec's.
---@param handle TRB.Classes.PreviewHandle
local function OpenPositionTab(handle)
	if IsPositionedByGlobalOptions(handle.barKey) then
		TRB.Functions.OptionsUi.Tabs:OpenBarTab(nil, nil, handle.barKey)
	else
		TRB.Functions.OptionsUi.Tabs:OpenBarTab(TRB.Data.character.classId, TRB.Data.character.specId, handle.barKey)
	end
end

---Puts a handle's icon on the point its bar is attached by: a frame-anchored Edit Mode stack's point on its wrapper, a
---screen-anchored or freely placed root's center, or an anchored bar's own attach point.
---@param handle TRB.Classes.PreviewHandle
---@param barGroups table
local function PlaceAnchorIcon(handle, barGroups)
	local EditMode = TRB.Functions.EditMode
	local barKey = handle.barKey
	local rootBarKey = handle.rootBarKey
	local frame = handle --[[@as Frame]]
	local point = "CENTER"
	local texture = ANCHOR_TEXTURE
	if barKey ~= rootBarKey then
		local anchor = barGroups.layoutSettings and TRB.Functions.Bar:GetBarAnchor(barGroups.layoutSettings, barKey)
		point = anchor and anchor.attachPoint or "CENTER"
	elseif rootBarKey ~= nil and EditMode:IsLayoutEnabled(nil, rootBarKey) then
		texture = LOCK_TEXTURE
		local wrapper = EditMode:GetWrapperFrame(rootBarKey)
		if wrapper ~= nil then
			local anchorFrameKey = EditMode:GetAnchorFrameKey(nil, rootBarKey)
			if anchorFrameKey ~= "none" and EditMode:GetAnchorFrame(anchorFrameKey, EditMode:GetCustomFrameName(nil, rootBarKey)) ~= nil then
				frame = wrapper
				point = EditMode:GetAttachPoint(nil, rootBarKey) or "CENTER"
			end
			-- A freely placed stack's saved point is only the screen region the client measured it from.
		end
	end
	handle.anchorIcon:SetTexture(texture)
	handle.anchorIcon:ClearAllPoints()
	handle.anchorIcon:SetPoint("CENTER", frame, point, 0, 0)
end

---@param kind string
---@param barKey string
---@return TRB.Classes.PreviewHandle
local function CreateHandle(kind, barKey)
	local handle = CreateFrame("Button", nil, UIParent) --[[@as TRB.Classes.PreviewHandle]]
	handle.kind = kind
	handle.barKey = barKey
	handle:EnableMouse(true)
	handle:RegisterForDrag("LeftButton")

	local highlight = handle:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints()
	highlight:SetColorTexture(1, 1, 1, 0.15)

	handle.lockTexture = handle:CreateTexture(nil, "ARTWORK")
	handle.lockTexture:SetAllPoints()
	handle.lockTexture:SetColorTexture(0.4, 0.4, 0.4, 0.4)
	handle.lockTexture:Hide()

	handle.anchorIcon = handle:CreateTexture(nil, "OVERLAY")
	handle.anchorIcon:SetSize(ANCHOR_ICON_SIZE, ANCHOR_ICON_SIZE)

	handle:SetScript("OnEnter", ShowTooltip)
	handle:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	handle:SetScript("OnMouseDown", SelectHandle)
	handle:SetScript("OnClick", OpenPositionTab)
	handle:SetScript("OnDragStart", BeginDrag)
	handle:SetScript("OnDragStop", EndDrag)
	handle:SetScript("OnHide", EndDrag)
	handle:Hide()
	return handle
end

---Why a stack can't be dragged, or nil when it can.
---@param barGroups table
---@param rootBarKey string
---@return string?
local function GetLockReason(barGroups, rootBarKey)
	if TRB.Functions.EditMode:IsLayoutEnabled(nil, rootBarKey) then
		return L["PreviewModeEditModeTooltip"]
	end
	local anchor = barGroups.layoutSettings and TRB.Functions.Bar:GetBarAnchor(barGroups.layoutSettings, rootBarKey)
	if anchor == nil or anchor.barKey ~= "screen" then
		return L["PreviewModeNoScreenAnchorTooltip"]
	end
	return nil
end

local function HideHandles()
	EndDrag()
	if selectionFrame ~= nil then
		selectionFrame:Hide()
	end
	for _, handle in pairs(handles) do
		handle:Hide()
	end
end

---Puts a handle over every bar of the current layout. Layout calls this each time it finishes.
function TRB.Functions.Preview:Refresh()
	if not active then
		return
	end
	local barGroups = TRB.Frames.barGroups
	local barKeyToRoot = barGroups and barGroups.barKeyToRoot
	if barGroups == nil or barKeyToRoot == nil then
		HideHandles()
		return
	end

	local lockReasons = {}
	for barKey, rootBarKey in pairs(barKeyToRoot) do
		local group = barGroups[barKey]
		if group ~= nil and group.containerFrame ~= nil then
			local handle = handles[barKey]
			if handle == nil then
				handle = CreateHandle("bar", barKey)
				handles[barKey] = handle
			end
			if lockReasons[rootBarKey] == nil then
				lockReasons[rootBarKey] = GetLockReason(barGroups, rootBarKey) or false
			end
			-- A child of the bar's container shows, hides, and fades with the bar.
			handle:SetParent(group.containerFrame)
			handle:ClearAllPoints()
			handle:SetAllPoints(group:GetAnchorFrame())
			handle:SetFrameLevel(HANDLE_FRAME_LEVEL)
			handle.rootBarKey = rootBarKey
			handle.lockReason = lockReasons[rootBarKey] or nil
			handle.lockTexture:SetShown(handle.lockReason ~= nil)
			PlaceAnchorIcon(handle, barGroups)
			handle:Show()
		end
	end
	for barKey, handle in pairs(handles) do
		if barKeyToRoot[barKey] == nil or barGroups[barKey] == nil then
			handle:Hide()
		end
	end
end

---Turns Preview Mode on or off. It can't turn on while Edit Mode is open, which shows every bar itself.
---@param enable boolean
function TRB.Functions.Preview:SetActive(enable)
	enable = enable == true
	if enable and TRB.Functions.EditMode:IsInEditMode() then
		enable = false
	end
	if enable == active then
		return
	end
	active = enable

	if active then
		local barGroups = TRB.Frames.barGroups
		if barGroups ~= nil and barGroups.primary ~= nil then
			ReapplyLayout()
			-- Fresh frames drop their unchanged-skip state, so every Bar Text Area writes its name.
			TRB.Functions.BarText:CreateBarTextFrames()
			TRB.Functions.BarText:MarkLookupDirty()
			TRB.Functions.BarVisibility:InvalidateAppliedState()
			TRB.Functions.Bar:HideResourceBar()
		end
	else
		HideHandles()
		TRB.Functions.EditMode:RestoreLiveBars()
	end

	for _, listener in ipairs(listeners) do
		listener(active)
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:SetScript("OnEvent", function()
	TRB.Functions.Preview:SetActive(false)
end)
