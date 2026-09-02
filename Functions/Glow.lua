---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.Glow = TRB.Functions.Glow or {}
local L = TRB.Localization

-- Reused for the {r,g,b,a} the library wants: it reads the table without keeping it.
local colorScratch = { 1, 1, 1, 1 }

-- Lets Apply reach ApplySet without building a one-entry set per call.
local singleScratch = {}

---@class TRB.Classes.GlowTypeDef
---@field key string
---@field label string
---@field fields string[] # Setting keys this type reads, in editor order

-- `fields` drives which editor rows a style shows and which values go into its change signature.
local glowTypes = {
	{
		key = "pixel",
		label = L["GlowTypePixel"],
		fields = { "lines", "frequency", "length", "thickness", "xOffset", "yOffset", "border" }
	},
	{
		key = "autocast",
		label = L["GlowTypeAutocast"],
		fields = { "particleGroups", "frequency", "scale", "xOffset", "yOffset" }
	},
	{
		key = "button",
		label = L["GlowTypeButton"],
		fields = { "frequency" }
	},
	{
		key = "proc",
		label = L["GlowTypeProc"],
		fields = { "duration", "startAnim", "xOffset", "yOffset" }
	},
}

local glowTypeByKey = {}
for _, def in ipairs(glowTypes) do
	glowTypeByKey[def.key] = def
end

---Returns the glow style definitions, in editor order.
---@return TRB.Classes.GlowTypeDef[]
function TRB.Functions.Glow:GetTypes()
	return glowTypes
end

---Returns one glow style definition, or nil when the key is unknown.
---@param typeKey string?
---@return TRB.Classes.GlowTypeDef?
function TRB.Functions.Glow:GetTypeDefinition(typeKey)
	return typeKey and glowTypeByKey[typeKey] or nil
end

---Human-readable name of a glow style, for tables and dropdowns.
---@param typeKey string?
---@return string
function TRB.Functions.Glow:GetTypeLabel(typeKey)
	local def = self:GetTypeDefinition(typeKey)
	return def and def.label or L["GlowTypePixel"]
end

---A new glow definition carrying every field all four styles read, so switching style in the editor
---never lands on a nil. Values match LibCustomGlow's own defaults.
---@param guid string
---@param name string?
---@return table
function TRB.Functions.Glow:DefaultGlow(guid, name)
	return {
		guid = guid,
		name = name or L["GlowDefaultName"],
		type = "pixel",
		useCustomColor = true,
		color = "FFF2F252",
		lines = 8,
		particleGroups = 4,
		frequency = 0.25,
		length = 0,
		thickness = 2,
		scale = 1,
		duration = 1,
		startAnim = true,
		xOffset = 0,
		yOffset = 0,
		border = false
	}
end

---The core-scope glow definitions, keyed by guid. Created on first use so a profile saved before glows
---existed still resolves to a table.
---@return table<string, table>
function TRB.Functions.Glow:GetAll()
	local core = TRB.Data.settings and TRB.Data.settings.core
	if core == nil then
		return {}
	end
	core.glows = core.glows or {}
	return core.glows
end

---One glow definition by id, or nil when it was deleted after an indicator was pointed at it.
---@param glowId string?
---@return table?
function TRB.Functions.Glow:Get(glowId)
	if glowId == nil then
		return nil
	end
	local glow = self:GetAll()[glowId]
	return type(glow) == "table" and glow or nil
end

---Glow definitions sorted by name, for the options table and the target submenus.
---@return table[]
function TRB.Functions.Glow:GetOrdered()
	local ordered = {}
	for guid, glow in pairs(self:GetAll()) do
		if type(glow) == "table" then
			glow.guid = glow.guid or guid
			ordered[#ordered + 1] = glow
		end
	end
	table.sort(ordered, function(a, b)
		local aName, bName = a.name or "", b.name or ""
		if aName == bName then
			return (a.guid or "") < (b.guid or "")
		end
		return aName < bName
	end)
	return ordered
end

---Identifies the exact appearance a frame is currently glowing with. Start is skipped while this
---matches, which keeps the library's per-call setup (mask points, texture resizing) off the frame loop.
---@param glow table
---@param colorString string
---@return string
local function BuildSignature(glow, colorString)
	local typeDef = glowTypeByKey[glow.type]
	local signature = (glow.type or "pixel") .. "|" .. colorString
	if typeDef ~= nil then
		for _, field in ipairs(typeDef.fields) do
			signature = signature .. "|" .. tostring(glow[field])
		end
	end
	return signature
end

---Stops one running glow. Each style parks its frame on the target under its own field name, so the
---style it was started as is what decides which Stop to call.
---@param frame Frame?
---@param appliedType string?
---@param key string # The glow's id, which is the library key it was started with
local function StopApplied(frame, appliedType, key)
	local lib = TRB.Details.addonData.libs.CustomGlow
	if frame == nil or lib == nil then
		return
	end

	if appliedType == "pixel" then
		lib.PixelGlow_Stop(frame, key)
	elseif appliedType == "autocast" then
		lib.AutoCastGlow_Stop(frame, key)
	elseif appliedType == "button" then
		lib.ButtonGlow_Stop(frame)
	elseif appliedType == "proc" then
		lib.ProcGlow_Stop(frame, key)
	end
end

---Starts, restarts, or leaves alone one glow on a frame, recording what is running under its id. Does
---nothing when that id is already showing this exact appearance; a style change stops the old one first.
---@param frame Frame
---@param glow table
---@param colorString string
---@param applied table<string, table> # The frame's id -> { type, signature } record
local function StartOne(frame, glow, colorString, applied)
	local lib = TRB.Details.addonData.libs.CustomGlow
	local key = glow.guid
	local signature = BuildSignature(glow, colorString)
	local entry = applied[key]
	if entry ~= nil and entry.type == glow.type and entry.signature == signature then
		return
	end
	if entry ~= nil and entry.type ~= glow.type then
		StopApplied(frame, entry.type, key)
	end

	local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
	colorScratch[1], colorScratch[2], colorScratch[3], colorScratch[4] = r, g, b, a

	if glow.type == "autocast" then
		lib.AutoCastGlow_Start(frame, colorScratch, glow.particleGroups, glow.frequency, glow.scale,
			glow.xOffset, glow.yOffset, key)
	elseif glow.type == "button" then
		lib.ButtonGlow_Start(frame, colorScratch, glow.frequency)
	elseif glow.type == "proc" then
		lib.ProcGlow_Start(frame, {
			color = colorScratch,
			startAnim = glow.startAnim ~= false,
			duration = glow.duration,
			xOffset = glow.xOffset,
			yOffset = glow.yOffset,
			key = key
		})
	else
		-- A length of 0 is the editor's "automatic": the library sizes lines from the frame when passed nil.
		local length = (glow.length ~= nil and glow.length > 0) and glow.length or nil
		lib.PixelGlow_Start(frame, colorScratch, glow.lines, glow.frequency, length, glow.thickness,
			glow.xOffset, glow.yOffset, glow.border == true, key)
	end

	if entry == nil then
		entry = {}
		applied[key] = entry
	end
	entry.type = glow.type
	entry.signature = signature
end

---The color one glow runs in: its own when it pins one, otherwise the indicator's.
---@param glow table
---@param indicatorColor string?
---@return string
local function ResolveColor(glow, indicatorColor)
	if not glow.useCustomColor and indicatorColor ~= nil then
		return indicatorColor
	end
	return glow.color or "FFF2F252"
end

---Runs exactly the given set of glows on a frame, starting what is newly selected, stopping what is no
---longer, and leaving unchanged ones alone.
---@param frame Frame? # The frame to glow, normally a bar node's StatusBar
---@param glowIds table<string, boolean>? # Set of glow ids; nil or empty stops every glow on the frame
---@param indicatorColor string? # The Color Indicator's color, used by each glow that doesn't pin its own
function TRB.Functions.Glow:ApplySet(frame, glowIds, indicatorColor)
	local lib = TRB.Details.addonData.libs.CustomGlow
	if frame == nil or lib == nil then
		return
	end

	local applied = frame.trbGlows
	if applied == nil then
		if glowIds == nil or next(glowIds) == nil then
			return
		end
		applied = {}
		---@diagnostic disable-next-line: inject-field
		frame.trbGlows = applied
	end

	-- Drop deselected (and deleted) glows first, so a released Action Button Glow frees the frame's single
	-- slot for whichever selection claims it below.
	for guid, entry in pairs(applied) do
		if glowIds == nil or not glowIds[guid] or self:Get(guid) == nil then
			StopApplied(frame, entry.type, guid)
			applied[guid] = nil
			if frame.trbButtonGlowOwner == guid then
				---@diagnostic disable-next-line: inject-field
				frame.trbButtonGlowOwner = nil
			end
		end
	end

	if glowIds == nil then
		return
	end

	for guid in pairs(glowIds) do
		local glow = self:Get(guid)
		if glow ~= nil then
			-- LibCustomGlow parks the Action Button Glow on the frame with no key of its own, so a frame can
			-- only ever run one. The first to claim it keeps it until it is deselected.
			local canStart = true
			if glow.type == "button" then
				if frame.trbButtonGlowOwner == nil then
					---@diagnostic disable-next-line: inject-field
					frame.trbButtonGlowOwner = guid
				elseif frame.trbButtonGlowOwner ~= guid then
					canStart = false
				end
			end
			if canStart then
				StartOne(frame, glow, ResolveColor(glow, indicatorColor), applied)
			end
		end
	end
end

---Runs a single glow on a frame, stopping anything else it was showing. Used by the options preview.
---@param frame Frame? # The frame to glow
---@param glow table? # A glow definition; nil stops any glow on the frame
---@param indicatorColor string? # Stands in for the Color Indicator's color when the glow doesn't pin one
function TRB.Functions.Glow:Apply(frame, glow, indicatorColor)
	if frame == nil then
		return
	end
	if glow == nil or glow.guid == nil then
		self:Clear(frame)
		return
	end
	singleScratch[glow.guid] = true
	self:ApplySet(frame, singleScratch, indicatorColor)
	singleScratch[glow.guid] = nil
end

---Stops every glow this addon started on a frame.
---@param frame Frame?
function TRB.Functions.Glow:Clear(frame)
	if frame == nil or frame.trbGlows == nil then
		return
	end
	for guid, entry in pairs(frame.trbGlows) do
		StopApplied(frame, entry.type, guid)
	end
	---@diagnostic disable-next-line: inject-field
	frame.trbGlows = nil
	---@diagnostic disable-next-line: inject-field
	frame.trbButtonGlowOwner = nil
end

---Applies the glows a Color Indicator has claimed for a bar to one of its nodes, or clears them when
---nothing claims it. Resolved from the indicator state, so the caller only needs the node and its key.
---@param node TRB.Classes.BarNode?
---@param barKey string?
function TRB.Functions.Glow:ApplyIndicatorGlow(node, barKey)
	if node == nil then
		return
	end

	local frame = node:GetFrame()
	if frame == nil then
		return
	end

	-- A node whose bar has no indicator key this frame (a slot reused for an untargetable spell) still has
	-- to shed whatever it was glowing with before.
	local resolved = barKey ~= nil and TRB.Functions.Color:GetResolvedGlow(barKey) or nil
	if resolved == nil then
		self:Clear(frame)
		return
	end

	self:ApplySet(frame, resolved.glows, resolved.color)
end

---Releases a node's glow back to the library's pool. Called as a node is torn down, before its frame is
---orphaned -- the glow frame is a child of it and would otherwise never return to the pool.
---@param node TRB.Classes.BarNode?
function TRB.Functions.Glow:ReleaseNode(node)
	if node == nil then
		return
	end
	self:Clear(node.frame)
end
