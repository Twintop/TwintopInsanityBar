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

---@class TRB.AuraEngineRecord
---@field container table? # Aura container owning this node's slot
---@field unit string
---@field filter string
---@field key string? # Slot key; nil while no slot is wired
---@field ids table<integer, integer?> # Candidate spell IDs, indices 1..idCount
---@field idCount integer
---@field fillBar StatusBar? # The button's own bar, set once its initialize window has run
---@field wireError string? # Why the last initialize window could not bind, e.g. a template that never registered
---@field texturePath string|integer? # Fill texture last pushed to the engine bar
---@field fillTexture Texture? # The engine bar's texture object, needed to paint gradients; dropped on a texture swap
---@field gradient1 string? # Gradient start color last mirrored; nil while the fill is flat
---@field gradient2 string?
---@field gradientDirection string?
---@field border number? # Border width the button was inset by; anchors are init-only, so a change rewires
---@field orientation string?
---@field reverse boolean?
---@field rotates boolean?
---@field r number?
---@field g number?
---@field b number?
---@field a number?

---@type table<TRB.Classes.BarNode, TRB.AuraEngineRecord>
local records = {}
local slotSequence = 0
local unavailable = false
local addOnRequested = false

---@param node TRB.Classes.BarNode
---@return string|integer|nil
local function SourceTexturePath(node)
	local texture = node.frame:GetStatusBarTexture()
	if texture == nil or texture.GetTexture == nil then
		return nil
	end
	return texture:GetTexture()
end

---The engine bar's fill texture, needed to paint gradients. Fetched through pcall because the button's
---regions are access-constrained: a blocked read simply costs gradients, not the whole mirror.
---@param record TRB.AuraEngineRecord
---@param fillBar StatusBar
---@return Texture?
local function EngineFillTexture(record, fillBar)
	if record.fillTexture == nil then
		local ok, texture = pcall(fillBar.GetStatusBarTexture, fillBar)
		if ok then
			record.fillTexture = texture
		end
	end
	return record.fillTexture
end

---Repaints the engine fill's gradient to match the node's. Mirrors BarNode:SetColorGradient, including
---its vertical swap, so the two bars can never disagree on which end each color sits at.
---@param record TRB.AuraEngineRecord
---@param fillBar StatusBar
---@param gradient table? # nil clears back to a neutral white-to-white
local function MirrorGradient(record, fillBar, gradient)
	local texture = EngineFillTexture(record, fillBar)
	if texture == nil then
		return
	end

	if gradient == nil then
		local white = CreateColor(1, 1, 1, 1)
		pcall(texture.SetGradient, texture, "HORIZONTAL", white, white)
		return
	end

	local Color = TRB.Functions.Color
	local r1, g1, b1, a1 = Color:GetRGBAFromString(gradient.color1, true)
	local r2, g2, b2, a2 = Color:GetRGBAFromString(gradient.color2, true)
	local apiDirection = gradient.direction == "vertical" and "VERTICAL" or "HORIZONTAL"
	local minColor = CreateColor(r1, g1, b1, a1)
	local maxColor = CreateColor(r2, g2, b2, a2)
	if apiDirection == "VERTICAL" then
		minColor, maxColor = maxColor, minColor
	end
	pcall(texture.SetGradient, texture, apiDirection, minColor, maxColor)
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

---Copies the node's bar art onto the engine fill and records what was applied. Init-window only: every
---setter on the button's regions is forbidden once it returns, so this is the single chance to paint.
---@param record TRB.AuraEngineRecord
---@param node TRB.Classes.BarNode
---@param fillBar StatusBar
local function ApplyFillAppearance(record, node, fillBar)
	local source = node.frame

	record.texturePath = SourceTexturePath(node)
	if record.texturePath ~= nil then
		fillBar:SetStatusBarTexture(record.texturePath)
	end
	record.fillTexture = nil

	record.rotates = TRB.Functions.Bar:IsVerticalFill(node.fillDirection or "leftRight")
	fillBar:SetRotatesTexture(record.rotates)

	record.orientation = source:GetOrientation()
	fillBar:SetOrientation(record.orientation)

	record.reverse = source:GetReverseFill()
	fillBar:SetReverseFill(record.reverse)

	record.r, record.g, record.b, record.a = source:GetStatusBarColor()
	fillBar:SetStatusBarColor(record.r, record.g, record.b, record.a)

	-- A gradient forces the node's own bar color to white and puts the real colors on its fill texture,
	-- so copying the bar color alone would paint the engine fill white.
	local gradient = SourceGradient(node)
	record.gradient1 = gradient and gradient.color1 or nil
	record.gradient2 = gradient and gradient.color2 or nil
	record.gradientDirection = gradient and gradient.direction or nil
	if gradient ~= nil then
		MirrorGradient(record, fillBar, gradient)
	end
end

---Binds the button's own fill bar over the node. Only legal inside the slot's initialize window: the
---button and its regions become access-constrained the moment it returns.
---@param button table
---@param node TRB.Classes.BarNode
---@param record TRB.AuraEngineRecord
local function WireButton(button, node, record)
	record.wireError = nil

	local fillBar = button.FillBar
	if fillBar == nil or button.SetDurationBar == nil then
		-- Almost always a template that failed to register: the engine still builds a button, just
		-- without our regions on it.
		record.wireError = string.format("FillBar=%s SetDurationBar=%s", tostring(fillBar ~= nil),
			tostring(button.SetDurationBar ~= nil))
		return
	end

	-- Inset by the border instead of spanning the frame like the node's own fill: a child frame draws
	-- over every layer of its parent, so nothing else can keep the backdrop's border visible.
	local border = node.border or 0
	button:ClearAllPoints()
	button:SetPoint("TOPLEFT", node.frame, "TOPLEFT", border, -border)
	button:SetPoint("BOTTOMRIGHT", node.frame, "BOTTOMRIGHT", -border, border)
	button:SetFrameLevel(node.frame:GetFrameLevel() + 1)
	button:EnableMouse(false)
	record.border = border

	button:SetDurationBar(fillBar, {
		interpolation = Enum.StatusBarInterpolation.Immediate,
		direction = Enum.StatusBarTimerDirection.RemainingTime,
	})

	-- The engine drives the value normalized, so the range is fixed and only the art is ours.
	fillBar:SetMinMaxValues(0, 1)
	fillBar:ClearAllPoints()
	fillBar:SetAllPoints(button)

	record.fillBar = fillBar
	node.engineDriven = true

	ApplyFillAppearance(record, node, fillBar)
	fillBar:Show()
end

---Releases a wired slot. There is no unregister call, so it is parked on a spell ID nothing matches.
---@param record TRB.AuraEngineRecord
---@param node TRB.Classes.BarNode
local function ParkSlot(record, node)
	local container = record.container
	if container ~= nil and record.key ~= nil and container.SetAuraSlotCandidateFilters ~= nil then
		container:SetAuraSlotCandidateFilters(record.key, { includeSpellIDs = { [0] = true } })
		if container.UpdateAllAuras ~= nil then
			container:UpdateAllAuras()
		end
	end

	record.key = nil
	record.fillBar = nil
	record.texturePath = nil
	record.fillTexture = nil
	node.engineDriven = nil
end

---@param node TRB.Classes.BarNode
---@param record TRB.AuraEngineRecord
---@return table? container
local function EnsureContainer(node, record)
	if record.container ~= nil then
		return record.container
	end
	if InCombatLockdown() and not combatCreateAllowed then
		return nil
	end

	if not addOnRequested then
		addOnRequested = true
		if C_AddOns ~= nil and not C_AddOns.IsAddOnLoaded("Blizzard_AuraContainer") then
			pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer")
		end
	end

	local created, container = pcall(CreateFrame, "AuraContainer", nil, node.frame, CONTAINER_TEMPLATE)
	if not created or container == nil or type(container.AddAuraSlot) ~= "function" then
		unavailable = true
		return nil
	end

	container:SetUnit(record.unit)
	container:SetEnabled(true)
	container:ClearAllPoints()
	container:SetPoint("CENTER", node.frame, "CENTER", 0, 0)
	container:SetSize(1, 1)
	-- Parented to the bar so it inherits every hide path the bar has, and shown plus enabled so it
	-- subscribes to aura updates on its own.
	container:Show()

	record.container = container
	return container
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

---@param record TRB.AuraEngineRecord
---@param node TRB.Classes.BarNode
local function CreateSlot(record, node)
	slotSequence = slotSequence + 1
	local key = "twintopAuraEngine" .. slotSequence

	record.container:AddAuraSlot(key, record.filter, {
		candidateFilters = { includeSpellIDs = BuildSpellIdSet(record) },
		templateNames = { BUTTON_TEMPLATE },
		initializeFrame = function(button)
			WireButton(button, node, record)
		end,
	})
	record.key = key

	-- Parse auras that are already up rather than waiting on the next aura event.
	if record.container.UpdateAllAuras ~= nil then
		record.container:UpdateAllAuras()
	end
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
---Safe to call every frame: an unchanged binding costs a handful of compares.
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
		record = { unit = unit, filter = filter, ids = {}, idCount = 0 }
		records[node] = record
	end

	local unitChanged = record.unit ~= unit or record.filter ~= filter
	local idsChanged = not SameIds(record, ...)

	if record.key ~= nil and not unitChanged then
		if idsChanged then
			-- Candidate filters are data-only, so a changed ID set never needs the slot rebuilt.
			StoreIds(record, ...)
			record.container:SetAuraSlotCandidateFilters(record.key, { includeSpellIDs = BuildSpellIdSet(record) })
			if record.container.UpdateAllAuras ~= nil then
				record.container:UpdateAllAuras()
			end
		end
		return true
	end

	if unitChanged and record.container ~= nil then
		-- A slot cannot be moved between units, and the container is bound to one.
		ParkSlot(record, node)
		record.container:Hide()
		record.container = nil
	end
	record.unit, record.filter = unit, filter

	if EnsureContainer(node, record) == nil then
		return false
	end

	ParkSlot(record, node)
	StoreIds(record, ...)
	CreateSlot(record, node)

	-- Nothing writes the node's own fill once the engine owns the bar, so empty it here or whatever it
	-- last held shows through while the aura is down.
	node:SetMinMax(0, 1)
	node:SetValue(0)
	return true
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
		print(prefix .. string.format("  %s slot=%s fill=%s%s", node.name,
			tostring(record.key ~= nil), tostring(record.fillBar ~= nil),
			record.wireError ~= nil and (" NOT WIRED(" .. record.wireError .. ")") or ""))
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

	ParkSlot(record, node)
	if record.container ~= nil then
		record.container:Hide()
	end
	records[node] = nil
end
