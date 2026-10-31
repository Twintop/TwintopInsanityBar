local _, TRB = ...
local L = TRB.Localization
TRB.Functions = TRB.Functions or {}
TRB.Functions.Totems = {}

-- The Totems bar, one node per totem slot; slot behavior is measured in docs/totem-tracker-plan.md, Appendix C.
local Totems = TRB.Functions.Totems

-- The fewest nodes the Mainline bar shows, so its width doesn't change for the first few totems.
local MIN_VISIBLE_NODES = 4
-- Element slots on a flavor whose slots are elements (Blizzard's FIRE/EARTH/WATER/AIR_TOTEM_SLOT).
local ELEMENT_SLOTS = { fire = 1, earth = 2, water = 3, air = 4 }

---@class TRB.Functions.Totems.Slot
---@field slot integer
---@field occupied boolean # The client reports a totem in the slot
---@field ended boolean # The slot's duration ran out before the update that empties it
---@field duration any? # The engine duration object; may hold secrets
---@field icon any? # Texture id; may be secret
---@field name any? # Totem name; may be secret
---@field version integer # Bumped on every read, so the bar rebinds the node showing the slot
---@field endWidget any # Hidden Cooldown frame whose OnCooldownDone is the slot's true end

---@type TRB.Functions.Totems.Slot[]
local slots = {}
local enabled = false
local eventFrame = CreateFrame("Frame")
-- Bumped whenever which slots are active changes.
local activeVersion = 0
-- What each node was last given, and each group's layout count; weak, so rebuilt bars drop theirs.
local appliedByNode = setmetatable({}, { __mode = "k" })
local layoutVersions = setmetatable({}, { __mode = "k" })

local function OnActiveChanged()
	activeVersion = activeVersion + 1
	TRB.Functions.BarVisibility:MarkDirty()
end

---@param record TRB.Functions.Totems.Slot
---@return boolean
local function IsActive(record)
	return record.occupied and not record.ended
end

---@param slot integer
---@return TRB.Functions.Totems.Slot
local function GetRecord(slot)
	local record = slots[slot]
	if record ~= nil then
		return record
	end
	local widget = CreateFrame("Cooldown", nil, UIParent, "CooldownFrameTemplate")
	-- The template fills its parent; an end widget must sit unseen.
	widget:ClearAllPoints()
	widget:SetPoint("CENTER", UIParent, "CENTER")
	widget:SetSize(1, 1)
	widget:SetAlpha(0)
	widget:SetDrawSwipe(false)
	widget:SetDrawEdge(false)
	widget:SetDrawBling(false)
	widget:SetHideCountdownNumbers(true)
	record = { slot = slot, occupied = false, ended = false, version = 0, endWidget = widget }
	widget:SetScript("OnCooldownDone", function()
		if record.occupied and not record.ended then
			record.ended = true
			OnActiveChanged()
		end
	end)
	slots[slot] = record
	return record
end

---Reads one slot. Only engine sinks and nil tests touch values that may be secret.
---@param slot integer
local function ReadSlot(slot)
	local record = GetRecord(slot)
	local wasActive = IsActive(record)
	local duration = GetTotemDuration ~= nil and GetTotemDuration(slot) or nil
	local haveTotem, name, startTime, totalDuration, icon = GetTotemInfo(slot)
	local occupied
	if haveTotem ~= nil and not issecretvalue(haveTotem) then
		occupied = haveTotem == true
	else
		-- In combat an empty slot still reads haveTotem as secret, but has no duration object.
		occupied = duration ~= nil
	end

	record.occupied = occupied
	record.duration = occupied and duration or nil
	record.icon = occupied and icon or nil
	record.name = occupied and name or nil
	record.version = record.version + 1

	local widget = record.endWidget
	widget:Clear()
	record.ended = false
	if occupied then
		if duration ~= nil then
			widget:SetCooldownFromDurationObject(duration)
		elseif not issecretvalue(startTime) and not issecretvalue(totalDuration) and type(totalDuration) == "number" and totalDuration > 0 then
			widget:SetCooldown(startTime, totalDuration)
		end
		-- A pet can be extended just after its duration ran out. An object with no time left loads hidden.
		record.ended = not widget:IsShown()
	end

	if IsActive(record) ~= wasActive then
		OnActiveChanged()
	end
end

local function ReadAllSlots()
	for slot = 1, Totems:GetSlotCount() do
		ReadSlot(slot)
	end
end

local function ClearAllSlots()
	for _, record in pairs(slots) do
		record.endWidget:Clear()
		record.occupied = false
		record.ended = false
		record.duration = nil
		record.icon = nil
		record.name = nil
		record.version = record.version + 1
	end
	OnActiveChanged()
end

eventFrame:SetScript("OnEvent", function(_, event, slot)
	if event == "PLAYER_TOTEM_UPDATE" then
		if type(slot) == "number" and slot >= 1 and slot <= Totems:GetSlotCount() then
			ReadSlot(slot)
		end
	else
		ReadAllSlots()
	end
end)

---How many totem slots the bar has nodes for: four elements on Forever and Classic, eight on Mainline.
---@return integer
function Totems:GetSlotCount()
	local definition = TRB.Classes.BarTypeRegistry:GetInstance():Get("totems")
	return definition and definition.maxNodes or MIN_VISIBLE_NODES
end

---Tracks the totem slots while the active spec has the Totems bar, and drops them otherwise. Runs on every spec change.
---@param active boolean
function Totems:SetEnabled(active)
	if active then
		if not enabled then
			enabled = true
			eventFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
			eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		end
		ReadAllSlots()
	elseif enabled then
		enabled = false
		eventFrame:UnregisterAllEvents()
		ClearAllSlots()
	end
end

---The slot a node shows: the node's own index on Mainline, and the element in that position of the node order where
---slots are elements.
---@param nodeIndex integer
---@param colorSettings table? # The bar's colors, holding the element order
---@return integer
function Totems:GetNodeSlot(nodeIndex, colorSettings)
	if not TRB.Flavor.totemElements then
		return nodeIndex
	end
	local definition = TRB.Classes.BarTypeRegistry:GetInstance():Get("totems")
	local order = definition and definition:GetOrderedNodeKeys(colorSettings)
	local key = order and order[nodeIndex]
	return key and ELEMENT_SLOTS[key] or nodeIndex
end

---Whether a slot holds a totem that hasn't run out.
---@param slot integer
---@return boolean
function Totems:IsSlotActive(slot)
	local record = slots[slot]
	return record ~= nil and IsActive(record)
end

---A slot's totem for bar text, any part of which may be secret; nil when the slot is empty or its totem ran out.
---@param slot integer
---@return any name
---@return any icon # Texture id
---@return any duration # The duration object
function Totems:GetSlotDisplay(slot)
	local record = slots[slot]
	if record == nil or not IsActive(record) then
		return nil, nil, nil
	end
	return record.name, record.icon, record.duration
end

---The active spec's Totems colors, which hold the element order.
---@return table?
local function GetActiveColors()
	local character = TRB.Data.character
	local specCache = character ~= nil and TRB.Data.specCache[character.compositeKey] or nil
	local colorBars = specCache ~= nil and specCache.settings.colors and specCache.settings.colors.bars
	return colorBars and colorBars.totems or nil
end

---The node index showing a slot, for bar text anchored to it. Read from the node order, since text anchors before the
---first render.
---@param slot integer
---@return integer
function Totems:GetSlotNodeIndex(slot)
	if not TRB.Flavor.totemElements then
		return slot
	end
	local colors = GetActiveColors()
	for nodeIndex = 1, self:GetSlotCount() do
		if self:GetNodeSlot(nodeIndex, colors) == slot then
			return nodeIndex
		end
	end
	return slot
end

---The slot whose totem a node's icon tooltip shows, or nil when that slot holds none. Read at hover time, so it
---follows the element order without a relayout.
---@param nodeIndex integer
---@return integer?
function Totems:GetNodeTooltipSlot(nodeIndex)
	local slot = self:GetNodeSlot(nodeIndex, GetActiveColors())
	if self:IsSlotActive(slot) then
		return slot
	end
	return nil
end

---Fills the tooltip with a slot's totem, the way Blizzard's totem buttons do.
---@param tooltip GameTooltip
---@param slot integer
local function SetTotemTooltip(tooltip, slot)
	tooltip:SetTotem(slot)
end

---How many slots hold a totem that hasn't run out.
---@return integer
function Totems:GetActiveCount()
	local count = 0
	for _, record in pairs(slots) do
		if IsActive(record) then
			count = count + 1
		end
	end
	return count
end

---Changes whenever a slot starts or stops being active.
---@return integer
function Totems:GetActiveVersion()
	return activeVersion
end

---How many nodes the bar shows. Where slots are elements, all four always. Otherwise every slot up to the highest
---active one, but at least four. New totems go to the lowest free slot, so a totem never moves between nodes.
---@param groupSettings table? # The bar's dimensions, holding showAllSlots
---@return integer
function Totems:GetVisibleNodeCount(groupSettings)
	local slotCount = self:GetSlotCount()
	if TRB.Flavor.totemElements or (groupSettings ~= nil and groupSettings.showAllSlots) then
		return slotCount
	end
	local highest = 0
	for slot = 1, slotCount do
		local record = slots[slot]
		if record ~= nil and IsActive(record) then
			highest = slot
		end
	end
	return math.min(slotCount, math.max(MIN_VISIBLE_NODES, highest))
end

---Lays the visible nodes out in the bar's own footprint. The bar keeps its length along the growth direction and the
---nodes share it, each node's slot holding its icon, so a changing node count never moves anything else. The layout
---pass calls it through the definition's onLayout; the tick calls it when the node count changes.
---@param group TRB.Classes.BarGroup
---@param groupSettings table
---@param colors table? # The bar's colors, which seed the icons' backdrops
function Totems:LayoutGroup(group, groupSettings, colors)
	if group == nil or groupSettings == nil or group.containerFrame == nil then
		return
	end
	local Bar = TRB.Functions.Bar
	local growth = groupSettings.growthDirection or "leftRight"
	local vertical = growth == "topBottom" or growth == "bottomTop"
	local cross = vertical and (groupSettings.width or 0) or (groupSettings.height or 0)
	local total
	if group.fullWidth then
		-- Matched to an anchor or the Cooldown Manager: the standard pass already sized the container to the match.
		total = vertical and group.layoutHeight or group.layoutWidth
	else
		total = vertical and (groupSettings.height or 0) or (groupSettings.width or 0)
	end
	if total == nil or total <= 0 or cross <= 0 then
		return
	end

	local count = self:GetVisibleNodeCount(groupSettings)
	group:SetNodeCount(count)
	count = group.nodeCount
	local spacing = Bar:GetEffectiveSpacing(groupSettings)
	local border = groupSettings.border or 0
	local slotExtent = math.max((total - spacing * (count - 1)) / count, 1)

	-- Each node's slot holds its icon: beside the node, or above or below it on a horizontal bar.
	local icon = groupSettings.icon
	local side = (icon ~= nil and icon.enabled) and (icon.side or "left") or nil
	if vertical and (side == "top" or side == "bottom") then
		side = "left"
	end
	local nodeWidth = vertical and cross or slotExtent
	local nodeHeight = vertical and slotExtent or cross
	local iconGap = 0
	local iconSize = 0
	local widthReserved = 0
	local heightReserved = 0
	if side ~= nil then
		iconGap = icon.collapseBorderWidth and -border or (icon.spacing or 0)
		if side == "left" or side == "right" then
			iconSize = nodeHeight
			widthReserved = iconSize + iconGap
		else
			iconSize = math.min(nodeWidth, nodeHeight)
			heightReserved = iconSize + iconGap
		end
	end
	local barWidth = math.max(nodeWidth - widthReserved, 1)
	-- A rebuilt icon backdrop is white and the layout pass has just wiped the color caches it restores from.
	local iconBorderColor = colors ~= nil and colors.border ~= nil and colors.border.color or nil
	local iconBackgroundColor = colors ~= nil and colors.background ~= nil and colors.background.color or nil
	local containerWidth = vertical and cross or total
	local containerHeight = vertical and total or (cross + heightReserved)

	group.containerFrame:SetSize(containerWidth, containerHeight)
	group.layoutWidth = containerWidth
	group.layoutHeight = containerHeight

	local reversed = growth == "rightLeft" or growth == "bottomTop"
	for i = 1, group.maxNodes do
		local node = group.nodes[i]
		if node ~= nil then
			if i <= count then
				local position = (i - 1) * (slotExtent + spacing)
				if reversed then
					position = total - position - slotExtent
				end
				local x = side == "left" and widthReserved or 0
				local y = side == "top" and -heightReserved or 0
				if vertical then
					y = y - position
				else
					x = x + position
				end
				node:SetDimensions(barWidth, nodeHeight, border)
				node.frame:ClearAllPoints()
				node.frame:SetPoint("TOPLEFT", group.containerFrame, "TOPLEFT", x, y)
				if side ~= nil then
					node:ApplyIconLayout(side, iconSize, iconGap, border, icon.zoom)
					node:SetIconBorderColorString(iconBorderColor)
					node:SetIconBackgroundColorString(iconBackgroundColor)
					node:SetIconVisible(true)
				else
					node:SetIconVisible(false)
				end
				-- Opt-in, since a hoverable icon blocks world mouseover over its square. No token: the tooltip's
				-- remaining time changes as it shows, so it rebuilds on every hover refresh.
				if side ~= nil and icon.showTooltip then
					local nodeIndex = i
					node:SetIconTooltipProvider(function()
						return self:GetNodeTooltipSlot(nodeIndex), nil
					end, SetTotemTooltip)
				else
					node:SetIconTooltipProvider(nil)
				end
				node:Show()
			else
				node:Hide()
				node:SetIconVisible(false)
				node:SetIconTooltipProvider(nil)
			end
		end
	end
	-- Every node rebinds on the next tick.
	layoutVersions[group] = (layoutVersions[group] or 0) + 1
end

---The Ending window in seconds, or nil when the Ending color is off.
---@param ending table?
---@return number?
local function GetEndingSeconds(ending)
	if ending == nil or not ending.enabled then
		return nil
	end
	if ending.mode == "gcd" then
		return (ending.gcdsMax or 0) * TRB.Functions.Character:GetCurrentGCDTime()
	end
	return ending.timeMax or 0
end

---The fill color for a slot: its element's color where slots are elements, else the bar's.
---@param colors table
---@param slot integer
---@return string
local function GetSlotColor(colors, slot)
	if TRB.Flavor.totemElements and colors.nodeColors ~= nil then
		for key, elementSlot in pairs(ELEMENT_SLOTS) do
			if elementSlot == slot and colors.nodeColors[key] ~= nil then
				return colors.nodeColors[key].color
			end
		end
	end
	return colors.bar and colors.bar.color or "FFFFFFFF"
end

---Draws the Totems bar. Binds a node only when its slot changed, and paints the Ending color every tick while it's on.
---@param barGroups table<string, TRB.Classes.BarGroup>?
---@param settings table # The spec cache settings
---@return boolean refreshText
function Totems:Render(barGroups, settings)
	local group = barGroups and barGroups.totems
	if group == nil or not enabled or group.nodes == nil then
		return false
	end
	local displayBar = settings.displayBar and settings.displayBar.totems
	local groupSettings = settings.bars and settings.bars.totems
	local colors = settings.colors and settings.colors.bars and settings.colors.bars.totems
	if displayBar == nil or displayBar.neverShow or groupSettings == nil or colors == nil then
		return false
	end

	if self:GetVisibleNodeCount(groupSettings) ~= group.nodeCount then
		self:LayoutGroup(group, groupSettings, colors)
	end

	local endingSeconds = GetEndingSeconds(colors.ending)
	local layoutVersion = layoutVersions[group] or 0
	local Color = TRB.Functions.Color
	local indicators = Color:GetResolvedIndicators("totemsBar")
	local borderColor = (indicators and indicators.border) or colors.border.color
	local backgroundColor = (indicators and indicators.background) or colors.background.color
	for i = 1, group.nodeCount do
		local node = group.nodes[i]
		local slot = self:GetNodeSlot(i, colors)
		local record = slots[slot]
		if node ~= nil and record ~= nil then
			local active = IsActive(record)
			-- Keyed on the frame too, so a rebuilt bar rebinds.
			local applied = appliedByNode[node]
			if applied == nil then
				applied = {}
				appliedByNode[node] = applied
			end
			if applied.frame ~= node.frame or applied.version ~= record.version or applied.active ~= active
				or applied.slot ~= slot or applied.layout ~= layoutVersion then
				applied.frame = node.frame
				applied.version = record.version
				applied.active = active
				applied.slot = slot
				applied.layout = layoutVersion
				if active and record.duration ~= nil then
					node:SetTimerDuration(record.duration, Enum.StatusBarInterpolation.Immediate, Enum.StatusBarTimerDirection.RemainingTime)
				else
					node:ClearTimerDuration()
					node:SetMinMax(0, 1)
					node:SetValue(0)
				end
				if active and record.icon ~= nil then
					node:SetIconTextureRaw(record.icon)
				elseif node.icon ~= nil then
					node:ShowIconPlaceholder()
				end
				if node.icon ~= nil then
					node:SetIconVisible(groupSettings.icon ~= nil and groupSettings.icon.enabled == true)
				end
			end

			local baseColor = GetSlotColor(colors, slot)
			if active and endingSeconds ~= nil and record.duration ~= nil then
				local curve = Color:BuildRemainingTimeCurve(endingSeconds, colors.ending.color, baseColor)
				node:SetColorCurve(record.duration:EvaluateRemainingDuration(curve))
			else
				node:SetColor(baseColor)
			end
			Color:ApplyResolvedBorderOrBackground(node, "totemsBar", "border", borderColor)
			Color:ApplyResolvedBorderOrBackground(node, "totemsBar", "background", backgroundColor)
			Color:ApplyResolvedEndCap(node, "totemsBar")
			TRB.Functions.Glow:ApplyIndicatorGlow(node, "totemsBar")
		end
	end
	return false
end

---The enable prompt's saved answer, which lives in the live saves only.
---@return table? checks # manualUpdateChecks, or nil before any saved variables exist
local function GetManualUpdateChecks()
	local checks = TRB.Data.settings and TRB.Data.settings.manualUpdateChecks
	if checks == nil then
		local saved = TRB.Flavor.GetSavedVariables()
		checks = saved ~= nil and saved.manualUpdateChecks or nil
	end
	return checks
end

---Whether the Totems bar's defaults hide it: an existing install that hasn't answered the enable prompt, or answered
---No. Reads the saved variables until the settings load, since the Global defaults are built before then.
---@return boolean
function Totems:AreBarsDeclined()
	local checks = GetManualUpdateChecks()
	if checks == nil then
		-- A fresh install, before its first save.
		return false
	end
	local prompt = checks.totemBarsPrompt
	if type(prompt) ~= "table" then
		-- An existing save not yet marked for the prompt.
		return true
	end
	return prompt.answered ~= true or prompt.hidden == true
end

---Sets the Totems bar to Never Show, or shown, on every spec the enable prompt asks for (its own tab, not built in) and
---in Global Options where it has one, in the live settings and every profile.
---@param settings table # Shaped like the saved variables
---@param hidden boolean
function Totems:SetBarsHidden(settings, hidden)
	local function SetIn(piece)
		if type(piece) ~= "table" or type(piece.displayBar) ~= "table" then
			return
		end
		for _, barKey in ipairs(TRB.Classes.BarTypeRegistry.totemBarKeys) do
			piece.displayBar[barKey] = piece.displayBar[barKey] or TRB.Functions.Settings:DefaultTotemBarVisibility()
			piece.displayBar[barKey].neverShow = hidden
		end
	end

	local function SetInScopes(scopes)
		if TRB.Classes.BarTypeRegistry:HasGlobalTotems() then
			SetIn(scopes.core)
		end
		for _, classEntry in ipairs(TRB.Data.classRegistryOrder) do
			local classPiece = scopes[classEntry.className]
			if type(classPiece) == "table" then
				for _, specEntry in ipairs(classEntry.specs) do
					local info = specEntry.descriptor ~= nil and specEntry.descriptor.totems or nil
					if info ~= nil and info.placement == "spec" and not info.builtIn then
						SetIn(classPiece[specEntry.specName])
					end
				end
			end
		end
	end

	SetInScopes(settings)
	if type(settings.profiles) == "table" and type(settings.profiles.list) == "table" then
		for _, profile in pairs(settings.profiles.list) do
			SetInScopes(profile)
		end
	end
end

---Asks an existing install, the first time it plays a spec whose Totems bar is its own tab, whether to show the bar,
---then says where to change it later.
function Totems:ShowEnablePrompt()
	local checks = TRB.Data.settings.manualUpdateChecks
	local prompt = checks ~= nil and checks.totemBarsPrompt or nil
	if type(prompt) ~= "table" or prompt.answered ~= false then
		return
	end
	local character = TRB.Data.character
	local registry = TRB.Classes.BarTypeRegistry
	if registry:GetTotemPlacement(character.classId, character.specId) ~= "spec" or registry:IsTotemBarBuiltIn(character.classId, character.specId) then
		return
	end

	---@param hidden boolean
	local function Answer(hidden)
		-- Recorded before SetBarsHidden, whose defaults follow it.
		prompt.hidden = hidden
		prompt.answered = true
		Totems:SetBarsHidden(TRB.Data.settings, hidden)
		TRB.Functions.OptionsUi.Visibility:ApplyVisibilityChangeAllSpecs()
		StaticPopup_Show("TwintopResourceBar_TotemBarsFollowUp")
	end

	StaticPopupDialogs["TwintopResourceBar_TotemBarsPrompt"] = {
		text = L["TotemBarsPromptText"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function()
			Answer(false)
		end,
		-- Blizzard also calls OnCancel, with no reason, when it can't show the popup at all.
		OnCancel = function(_, _, reason)
			if reason == "clicked" then
				Answer(true)
			end
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = false,
		preferredIndex = 3
	}
	StaticPopupDialogs["TwintopResourceBar_TotemBarsFollowUp"] = {
		text = L["TotemBarsPromptFollowUpText"],
		button1 = L["OK"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}
	StaticPopup_Show("TwintopResourceBar_TotemBarsPrompt")
end
