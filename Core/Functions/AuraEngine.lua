---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.AuraEngine = {}

local AuraEngine = TRB.Functions.AuraEngine

-- An aura's remaining duration is secret and cannot be read or handed to a timer from addon code. An
-- aura button may hold one, so a bar borrows an invisible button and lets the engine write the fill.
local BUTTON_TEMPLATE = "TwintopAuraEngineButtonTemplate"
local CONTAINER_TEMPLATE = "CustomAuraContainerTemplate"

-- Creating an aura container in combat errors on earlier builds; those wait for the next combat drop.
local combatCreateAllowed = (tonumber((select(2, GetBuildInfo()))) or 0) > 68675

-- A button's art is painted inside its initialize window only, so a changed look needs a new button and
-- therefore a new container. Containers are cached per look and swapped back in when that look returns.
local MAX_CONTAINERS_PER_NODE = 32 -- Frames are never reclaimed, so a churning caller degrades instead of leaking

---@class TRB.AuraEngineAppearance
---@field texture string|integer?
---@field rotates boolean
---@field orientation string
---@field reverse boolean
---@field r number
---@field g number
---@field b number
---@field a number
---@field gradient1 string?
---@field gradient2 string?
---@field gradientDirection string?
---@field border number

---@class TRB.AuraEngineContainer
---@field frame table # The aura container itself
---@field key string # This container's one slot key
---@field signature string
---@field unit string
---@field filter string
---@field appearance TRB.AuraEngineAppearance # The look this container's button was painted with
---@field active boolean # False while parked: hidden, disabled and filtered to match nothing
---@field fillBar StatusBar? # The button's own bar, set once its initialize window has run
---@field fillTexture Texture? # The engine bar's texture object, needed to paint gradients
---@field wireError string? # Why the initialize window could not bind, e.g. a template that never registered

---@class TRB.AuraEngineRecord
---@field ids table<integer, integer?> # Candidate spell IDs, indices 1..idCount
---@field idCount integer
---@field containers table<string, TRB.AuraEngineContainer> # Cached one per look
---@field containerCount integer
---@field active TRB.AuraEngineContainer?
---@field capped boolean? # Budget spent, so the bar is stuck on the look it last built

---@type table<TRB.Classes.BarNode, TRB.AuraEngineRecord>
local records = {}
local slotSequence = 0
local unavailable = false
local addOnRequested = false

-- Read into a shared table every update so the steady-state compare allocates nothing.
local scratchAppearance = {}

---@param node TRB.Classes.BarNode
---@return string|integer|nil
local function SourceTexturePath(node)
	local texture = node.frame:GetStatusBarTexture()
	if texture == nil or texture.GetTexture == nil then
		return nil
	end
	return texture:GetTexture()
end

---The node's current gradient, or nil while its fill is flat.
---@param node TRB.Classes.BarNode
---@return table?
local function SourceGradient(node)
	if not node._gradientActive then
		return nil
	end
	return TRB.Data.cache.colors.gradient[node.name .. "_gradient"]
end

---Everything about the node's fill that the engine bakes in when its button is built.
---@param node TRB.Classes.BarNode
---@param into TRB.AuraEngineAppearance
---@return TRB.AuraEngineAppearance
local function ReadAppearance(node, into)
	local frame = node.frame
	local gradient = SourceGradient(node)

	into.texture = SourceTexturePath(node)
	into.rotates = TRB.Functions.Bar:IsVerticalFill(node.fillDirection or "leftRight") and true or false
	into.orientation = frame:GetOrientation()
	into.reverse = frame:GetReverseFill() and true or false
	into.r, into.g, into.b, into.a = frame:GetStatusBarColor()
	into.gradient1 = gradient and gradient.color1 or nil
	into.gradient2 = gradient and gradient.color2 or nil
	into.gradientDirection = gradient and gradient.direction or nil
	into.border = node.border or 0
	return into
end

---@param a TRB.AuraEngineAppearance
---@param b TRB.AuraEngineAppearance
---@return boolean
local function AppearanceEquals(a, b)
	return a.texture == b.texture and a.rotates == b.rotates and a.orientation == b.orientation
		and a.reverse == b.reverse and a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
		and a.gradient1 == b.gradient1 and a.gradient2 == b.gradient2
		and a.gradientDirection == b.gradientDirection and a.border == b.border
end

---@param appearance TRB.AuraEngineAppearance
---@return TRB.AuraEngineAppearance
local function CopyAppearance(appearance)
	local copy = {}
	for field, value in pairs(appearance) do
		copy[field] = value
	end
	return copy
end

---Cache key for a container: two nodes wanting the same look can never share one, but one node
---returning to a look it has already built always can.
---@param unit string
---@param filter string
---@param appearance TRB.AuraEngineAppearance
---@return string
local function SignatureOf(unit, filter, appearance)
	-- Tilde-separated, not pipe: the signature is printed to chat, where "|H" opens a hyperlink escape.
	return string.format("%s~%s~%s~%s~%s~%s~%.4f~%.4f~%.4f~%.4f~%s~%s~%s~%.2f",
		unit, filter, tostring(appearance.texture), tostring(appearance.rotates),
		tostring(appearance.orientation), tostring(appearance.reverse),
		appearance.r or 1, appearance.g or 1, appearance.b or 1, appearance.a or 1,
		tostring(appearance.gradient1), tostring(appearance.gradient2),
		tostring(appearance.gradientDirection), appearance.border or 0)
end

---The engine bar's fill texture, needed to paint gradients. Fetched through pcall because the button's
---regions are access-constrained: a blocked read simply costs gradients, not the whole mirror.
---@param entry TRB.AuraEngineContainer
---@param fillBar StatusBar
---@return Texture?
local function EngineFillTexture(entry, fillBar)
	if entry.fillTexture == nil then
		local ok, texture = pcall(fillBar.GetStatusBarTexture, fillBar)
		if ok then
			entry.fillTexture = texture
		end
	end
	return entry.fillTexture
end

---Repaints the engine fill's gradient to match the node's. Mirrors BarNode:SetColorGradient, including
---its vertical swap, so the two bars can never disagree on which end each color sits at.
---@param entry TRB.AuraEngineContainer
---@param fillBar StatusBar
---@param appearance TRB.AuraEngineAppearance
local function MirrorGradient(entry, fillBar, appearance)
	local texture = EngineFillTexture(entry, fillBar)
	if texture == nil then
		return
	end

	local Color = TRB.Functions.Color
	local r1, g1, b1, a1 = Color:GetRGBAFromString(appearance.gradient1, true)
	local r2, g2, b2, a2 = Color:GetRGBAFromString(appearance.gradient2, true)
	local apiDirection = appearance.gradientDirection == "vertical" and "VERTICAL" or "HORIZONTAL"
	local minColor = CreateColor(r1, g1, b1, a1)
	local maxColor = CreateColor(r2, g2, b2, a2)
	if apiDirection == "VERTICAL" then
		minColor, maxColor = maxColor, minColor
	end
	pcall(texture.SetGradient, texture, apiDirection, minColor, maxColor)
end

---Paints the recorded look onto the engine fill. Init-window only: every setter on the button's
---regions is forbidden once it returns, so this is the single chance to paint.
---@param entry TRB.AuraEngineContainer
---@param fillBar StatusBar
local function PaintAppearance(entry, fillBar)
	local appearance = entry.appearance

	if appearance.texture ~= nil then
		fillBar:SetStatusBarTexture(appearance.texture)
	end
	entry.fillTexture = nil

	fillBar:SetRotatesTexture(appearance.rotates)
	fillBar:SetOrientation(appearance.orientation)
	fillBar:SetReverseFill(appearance.reverse)
	fillBar:SetStatusBarColor(appearance.r, appearance.g, appearance.b, appearance.a)

	-- A gradient forces the node's own bar color to white and puts the real colors on its fill texture,
	-- so copying the bar color alone would paint the engine fill white.
	if appearance.gradient1 ~= nil then
		MirrorGradient(entry, fillBar, appearance)
	end
end

---Binds the button's own fill bar over the node. Only legal inside the slot's initialize window: the
---button and its regions become access-constrained the moment it returns.
---@param button table
---@param node TRB.Classes.BarNode
---@param entry TRB.AuraEngineContainer
local function WireButton(button, node, entry)
	entry.wireError = nil

	local fillBar = button.FillBar
	if fillBar == nil or button.SetDurationBar == nil then
		-- Almost always a template that failed to register: the engine still builds a button, just
		-- without our regions on it.
		entry.wireError = string.format("FillBar=%s SetDurationBar=%s", tostring(fillBar ~= nil),
			tostring(button.SetDurationBar ~= nil))
		node.engineDriven = nil
		return
	end

	-- Inset by the border instead of spanning the frame like the node's own fill: a child frame draws
	-- over every layer of its parent, so nothing else can keep the backdrop's border visible.
	local border = entry.appearance.border
	button:ClearAllPoints()
	button:SetPoint("TOPLEFT", node.frame, "TOPLEFT", border, -border)
	button:SetPoint("BOTTOMRIGHT", node.frame, "BOTTOMRIGHT", -border, border)
	button:SetFrameLevel(node.frame:GetFrameLevel() + 1)
	button:EnableMouse(false)

	button:SetDurationBar(fillBar, {
		interpolation = Enum.StatusBarInterpolation.Immediate,
		direction = Enum.StatusBarTimerDirection.RemainingTime,
	})

	-- The engine drives the value normalized, so the range is fixed and only the art is ours.
	fillBar:SetMinMaxValues(0, 1)
	fillBar:ClearAllPoints()
	fillBar:SetAllPoints(button)

	entry.fillBar = fillBar
	PaintAppearance(entry, fillBar)
	fillBar:Show()
end

---@param record TRB.AuraEngineRecord
---@return table
local function BuildSpellIdSet(record)
	local spellIds = {}
	for index = 1, record.idCount do
		local spellId = record.ids[index]
		if spellId ~= nil then
			spellIds[spellId] = true
		end
	end
	return spellIds
end

---@param entry TRB.AuraEngineContainer
---@param spellIds table
local function PushCandidateFilters(entry, spellIds)
	entry.frame:SetAuraSlotCandidateFilters(entry.key, { includeSpellIDs = spellIds })
	if entry.frame.UpdateAllAuras ~= nil then
		entry.frame:UpdateAllAuras()
	end
end

---Parks a container so its button stops drawing. There is no unregister call, so the slot is filtered
---down to a spell ID nothing matches on top of hiding and disabling the container itself.
---@param entry TRB.AuraEngineContainer
local function Deactivate(entry)
	if not entry.active then
		return
	end
	entry.active = false

	PushCandidateFilters(entry, { [0] = true })
	entry.frame:SetEnabled(false)
	entry.frame:Hide()
end

---Brings a container back, pushing the current IDs since they may have moved while it was parked.
---@param record TRB.AuraEngineRecord
---@param entry TRB.AuraEngineContainer
local function Activate(record, entry)
	entry.frame:Show()
	entry.frame:SetEnabled(true)
	entry.active = true

	-- Shown and enabled first so the button is acquired, and its initialize window runs, against a
	-- container that is already live.
	PushCandidateFilters(entry, BuildSpellIdSet(record))
end

---Builds a container and its one slot, parked, for the caller to activate.
---@param node TRB.Classes.BarNode
---@param record TRB.AuraEngineRecord
---@param unit string
---@param filter string
---@param signature string
---@param appearance TRB.AuraEngineAppearance
---@return TRB.AuraEngineContainer?
local function CreateContainer(node, record, unit, filter, signature, appearance)
	if InCombatLockdown() and not combatCreateAllowed then
		return nil
	end

	if not addOnRequested then
		addOnRequested = true
		if C_AddOns ~= nil and not C_AddOns.IsAddOnLoaded("Blizzard_AuraContainer") then
			pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer")
		end
	end

	local created, frame = pcall(CreateFrame, "AuraContainer", nil, node.frame, CONTAINER_TEMPLATE)
	if not created or frame == nil or type(frame.AddAuraSlot) ~= "function" then
		unavailable = true
		return nil
	end

	frame:SetUnit(unit)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", node.frame, "CENTER", 0, 0)
	frame:SetSize(1, 1)
	-- Parented to the bar so it inherits every hide path the bar has.
	frame:SetEnabled(false)
	frame:Hide()

	slotSequence = slotSequence + 1
	---@type TRB.AuraEngineContainer
	local entry = {
		frame = frame,
		key = "twintopAuraEngine" .. slotSequence,
		signature = signature,
		unit = unit,
		filter = filter,
		appearance = CopyAppearance(appearance),
		active = false,
	}

	frame:AddAuraSlot(entry.key, filter, {
		candidateFilters = { includeSpellIDs = { [0] = true } },
		templateNames = { BUTTON_TEMPLATE },
		initializeFrame = function(button)
			WireButton(button, node, entry)
		end,
	})

	record.containers[signature] = entry
	record.containerCount = record.containerCount + 1
	return entry
end

---@param record TRB.AuraEngineRecord
---@return boolean
local function SameIds(record, ...)
	local count = select("#", ...)
	if record.idCount ~= count then
		return false
	end
	for index = 1, count do
		if record.ids[index] ~= select(index, ...) then
			return false
		end
	end
	return true
end

---@param record TRB.AuraEngineRecord
local function StoreIds(record, ...)
	local previousCount = record.idCount
	local count = select("#", ...)
	for index = 1, count do
		record.ids[index] = select(index, ...)
	end
	for index = count + 1, previousCount do
		record.ids[index] = nil
	end
	record.idCount = count
end

---False once the aura container intrinsic has been proven missing on this client.
---@return boolean
function AuraEngine:IsAvailable()
	return not unavailable
end

---Hands a bar node's fill to the aura engine, which owns the duration and writes the fill itself.
---Safe to call every frame: an unchanged binding costs a handful of compares and allocates nothing.
---@param node TRB.Classes.BarNode
---@param unit string # Unit the aura lands on
---@param filter string # Aura filter, e.g. "HELPFUL"
---@param ... integer|nil # Candidate spell IDs the aura can land under; nils are skipped
---@return boolean driving # False means the caller must paint the fill itself
function AuraEngine:Attach(node, unit, filter, ...)
	if node == nil or unavailable then
		return false
	end

	local record = records[node]
	if record == nil then
		record = { ids = {}, idCount = 0, containers = {}, containerCount = 0 }
		records[node] = record
	end

	local appearance = ReadAppearance(node, scratchAppearance)
	local active = record.active

	if active ~= nil and active.unit == unit and active.filter == filter
		and AppearanceEquals(active.appearance, appearance) then
		if not SameIds(record, ...) then
			-- Candidate filters are data-only, so a changed ID set never needs a new container.
			StoreIds(record, ...)
			PushCandidateFilters(active, BuildSpellIdSet(record))
		end
		return active.wireError == nil
	end

	StoreIds(record, ...)

	local signature = SignatureOf(unit, filter, appearance)
	local entry = record.containers[signature]
	if entry == nil then
		if record.containerCount >= MAX_CONTAINERS_PER_NODE then
			-- Out of budget: keep whatever is drawing rather than leaking frames we cannot reclaim.
			record.capped = true
			return active ~= nil and active.wireError == nil
		end

		entry = CreateContainer(node, record, unit, filter, signature, appearance)
		if entry == nil then
			-- Combat lockdown on an older build; the mismatch stands so the next update retries.
			return active ~= nil and active.wireError == nil
		end
	end

	if active ~= nil and active ~= entry then
		Deactivate(active)
	end
	record.active = entry
	node.engineDriven = true
	Activate(record, entry)

	-- Nothing writes the node's own fill once the engine owns the bar, so empty it here or whatever it
	-- last held shows through while the aura is down.
	node:SetMinMax(0, 1)
	node:SetValue(0)
	return entry.wireError == nil
end

---Doubles pipes so a texture path can never open an escape sequence. An unterminated "|H" wedges the
---chat renderer on every redraw, and the message survives in history, so the hang outlives a reload.
---@param text string
---@return string
local function EscapeForChat(text)
	return (text:gsub("|", "||"))
end

---Reports each node's binding state. Reached from `/trb auraengine`.
function AuraEngine:PrintDiagnostics()
	local prefix = "|cFFFF8800TRB AuraEngine:|r "
	-- The template is the usual suspect when nothing wires: a malformed XML leaves it unregistered and
	-- the engine hands back a bare button.
	local templateOk, templateInfo = pcall(function()
		return C_XMLUtil ~= nil and C_XMLUtil.GetTemplateInfo ~= nil and C_XMLUtil.GetTemplateInfo(BUTTON_TEMPLATE)
	end)
	print(prefix .. string.format("available=%s template=%s", tostring(not unavailable),
		templateOk and tostring(templateInfo ~= nil and templateInfo ~= false) or "unknown"))

	local count = 0
	for node, record in pairs(records) do
		count = count + 1
		local active = record.active
		print(prefix .. string.format("  %s containers=%d/%d%s wired=%s%s", node.name,
			record.containerCount, MAX_CONTAINERS_PER_NODE,
			record.capped and " CAPPED" or "",
			tostring(active ~= nil and active.fillBar ~= nil),
			active ~= nil and active.wireError ~= nil and (" NOT WIRED(" .. EscapeForChat(active.wireError) .. ")") or ""))
		if active ~= nil then
			print(prefix .. "    look=" .. EscapeForChat(active.signature))
		end
	end

	if count == 0 then
		print(prefix .. "No nodes attached.")
	end
end

---Releases the node's binding so its own fill takes over again.
---@param node TRB.Classes.BarNode
function AuraEngine:Detach(node)
	local record = records[node]
	if record == nil then
		return
	end

	for _, entry in pairs(record.containers) do
		Deactivate(entry)
	end

	record.active = nil
	node.engineDriven = nil
	records[node] = nil
end
