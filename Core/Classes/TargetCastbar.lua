---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}

--[[
	TargetCastbar: secret-safe cast/channel/empower model for a tracked unit (target or focus).
	One instance per unit. Unlike the player Castbar, a target's timing is generally secret, so this
	model never does Lua arithmetic on times: the fill and the remaining countdown are driven by a
	DurationObject (UnitCastingDuration / UnitChannelDuration / UnitEmpoweredChannelDuration), and the
	spell name/icon/notInterruptible are stored raw (possibly secret) for display-only sinks
	(SetText / SetTexture / EvaluateColorFromBoolean). See the target-castbar feasibility notes.

	C_Secrets.ShouldUnitSpellCastingBeSecret(unit) is a plain branchable boolean captured at start, so
	later phases can render the full readable bar (real times, overlays) when a cast is NOT secret and
	fall back to this secret-safe path only when it is. numEmpowerStages / stage percentages are
	captured for empower stage rendering (a later phase).
]]

---@alias trbTargetCastbarState
---| '"none"'    # Nothing casting
---| '"cast"'    # Standard cast (fills up)
---| '"channel"' # Channel (depletes)
---| '"empower"' # Empowered cast (fills up through stages)

---@class TRB.Classes.TargetCastbar
---@field public unit string # "target" or "focus"
---@field public state trbTargetCastbarState
---@field public isSecret boolean # Whether this unit's cast queries produce secret values (branchable)
---@field public spellId any # Spell id from the event (may be a secret number; nil when unavailable)
---@field public spellName any # Spell name for bar text (string or secret string)
---@field public spellIconId any # Icon for the side icon: cast texture (arg 3) preferred, GetSpellInfo iconID fallback (may be secret)
---@field public castTimeMs any # Base cast time in ms from GetSpellInfo (may be secret); nil if unknown
---@field public notInterruptible any # Interruptible flag (secret boolean) for EvaluateColorFromBoolean
---@field public durationObject any # DurationObject driving the fill + remaining countdown
---@field public castGeneration integer # Bumped by Reset, so once per cast; the icon's hover tooltip compares this because a secret spellId cannot be compared
---@field public numEmpowerStages integer # Empower stage count (NeverSecret); 0 when not an empower
---@field public stagePercentages number[]? # Empower per-stage segment widths (charge+hold frame, sum 1.0; last is the hold-at-max segment). Accumulate for boundary positions.
TRB.Classes.TargetCastbar = {}
TRB.Classes.TargetCastbar.__index = TRB.Classes.TargetCastbar

---Creates a new TargetCastbar model bound to a unit.
---@param unit string # "target" or "focus"
---@return TRB.Classes.TargetCastbar
function TRB.Classes.TargetCastbar:New(unit)
	local self = setmetatable({}, TRB.Classes.TargetCastbar)
	self.unit = unit
	self:Reset()
	return self
end

---Resets the model to the idle (nothing casting) state.
function TRB.Classes.TargetCastbar:Reset()
	self.state = "none"
	self.isSecret = false
	self.spellId = nil
	self.spellName = nil
	self.spellIconId = nil
	self.castTimeMs = nil
	self.notInterruptible = nil
	self.durationObject = nil
	self.castGeneration = (self.castGeneration or 0) + 1
	self.numEmpowerStages = 0
	self.stagePercentages = nil
end

---Captures the spell display data (name/icon/base cast time) for a spellId. The id and results may be
---secret; they are stored raw for display sinks and never compared. Populates spellName/spellIconId/castTimeMs.
---The cast texture (UnitCastingInfo/UnitChannelInfo arg 3) is the icon Blizzard's own cast bar draws and is
---always present for the actual cast, so it wins over GetSpellInfo's iconID, which is nil for many NPC/mob
---spells the client spell database can't resolve by id.
---@param spellId any
---@param castTexture any # Cast texture from the query API (may be secret); nil to fall back to iconID
local function CaptureSpellData(self, spellId, castTexture)
	self.spellId = spellId
	self.spellName = nil
	self.spellIconId = castTexture
	self.castTimeMs = nil
	if spellId == nil then
		return
	end
	local info = C_Spell.GetSpellInfo(spellId)
	if info == nil then
		return
	end
	self.spellName = info.name
	if self.spellIconId == nil then
		self.spellIconId = info.iconID
	end
	self.castTimeMs = info.castTime
end

---Records whether this unit's spellcasting is secret (branchable boolean; safe to store and compare).
local function CaptureSecrecy(self)
	if C_Secrets ~= nil and C_Secrets.ShouldUnitSpellCastingBeSecret ~= nil then
		self.isSecret = C_Secrets.ShouldUnitSpellCastingBeSecret(self.unit) == true
	else
		self.isSecret = false
	end
end

---Begins tracking a standard cast on the unit. Reads the fill/countdown DurationObject and interruptible
---flag from the query API (any of which may be secret).
---@param spellId any # Spell id from the UNIT_SPELLCAST_START event (may be secret; nil falls back to the query)
function TRB.Classes.TargetCastbar:StartCast(spellId)
	self:Reset()
	self.state = "cast"
	CaptureSecrecy(self)
	local _, _, texture, _, _, _, _, notInterruptible, infoSpellId = UnitCastingInfo(self.unit)
	CaptureSpellData(self, spellId ~= nil and spellId or infoSpellId, texture)
	self.notInterruptible = notInterruptible
	self.durationObject = UnitCastingDuration and UnitCastingDuration(self.unit) or nil
end

---Begins tracking a channel on the unit.
---@param spellId any
function TRB.Classes.TargetCastbar:StartChannel(spellId)
	self:Reset()
	self.state = "channel"
	CaptureSecrecy(self)
	local _, _, texture, _, _, _, notInterruptible, infoSpellId = UnitChannelInfo(self.unit)
	CaptureSpellData(self, spellId ~= nil and spellId or infoSpellId, texture)
	self.notInterruptible = notInterruptible
	self.durationObject = (UnitChannelDuration and UnitChannelDuration(self.unit)) or nil
end

---Begins tracking an empowered cast on the unit. numEmpowerStages / isEmpowered are NeverSecret; the
---per-stage segment widths (default includeHoldAtMax frame, matching the fill) are captured for the
---stage-line render, which accumulates them into boundary positions.
---@param spellId any
function TRB.Classes.TargetCastbar:StartEmpower(spellId)
	self:Reset()
	self.state = "empower"
	CaptureSecrecy(self)
	local _, _, texture, _, _, _, notInterruptible, infoSpellId, _, numStages = UnitChannelInfo(self.unit)
	CaptureSpellData(self, spellId ~= nil and spellId or infoSpellId, texture)
	self.notInterruptible = notInterruptible
	self.numEmpowerStages = (type(numStages) == "number" and numStages) or 0
	self.durationObject = (UnitEmpoweredChannelDuration and UnitEmpoweredChannelDuration(self.unit))
		or (UnitChannelDuration and UnitChannelDuration(self.unit)) or nil
	if UnitEmpoweredStagePercentages ~= nil then
		local pct = UnitEmpoweredStagePercentages(self.unit)
		if type(pct) == "table" then
			self.stagePercentages = pct
		end
	end
end

---Detects a cast/channel/empower already in progress on the unit (e.g. right after targeting a caster)
---and begins tracking it. Returns true when a cast was picked up.
---@return boolean
function TRB.Classes.TargetCastbar:SyncFromUnit()
	if UnitCastingInfo(self.unit) ~= nil then
		self:StartCast(nil)
		return true
	end
	local _, _, _, _, _, _, _, _, isEmpowered = UnitChannelInfo(self.unit)
	if isEmpowered == true then
		self:StartEmpower(nil)
		return true
	elseif UnitChannelInfo(self.unit) ~= nil then
		self:StartChannel(nil)
		return true
	end
	return false
end

---Stops the active cast, returning to idle.
function TRB.Classes.TargetCastbar:Stop()
	self:Reset()
end

---Whether a cast/channel/empower is currently being tracked.
---@return boolean
function TRB.Classes.TargetCastbar:IsActive()
	return self.state ~= "none"
end

---Returns the spell id feeding the icon's hover tooltip, plus a plain token the refresh compares to decide
---whether to rebuild it. The id itself may be secret, so the per-cast generation stands in as that token.
---@return any spellId # May be secret; nil when nothing is casting
---@return integer? token
function TRB.Classes.TargetCastbar:GetTooltipSpellId()
	if self.state == "none" then
		return nil, nil
	end
	return self.spellId, self.castGeneration
end

---The fill animation direction for the current state: casts/empowers fill up, channels deplete.
---@return any # Enum.StatusBarTimerDirection
function TRB.Classes.TargetCastbar:GetTimerDirection()
	if self.state == "channel" then
		return Enum.StatusBarTimerDirection.RemainingTime
	end
	return Enum.StatusBarTimerDirection.ElapsedTime
end

---Returns the live remaining duration in seconds (may be secret), or nil when unavailable.
---@return any
function TRB.Classes.TargetCastbar:GetRemainingSeconds()
	if self.durationObject == nil then
		return nil
	end
	return self.durationObject:GetRemainingDuration()
end

---Returns the total duration in seconds (may be secret), or nil when unavailable.
---@return any
function TRB.Classes.TargetCastbar:GetTotalSeconds()
	if self.durationObject == nil then
		return nil
	end
	return self.durationObject:GetTotalDuration()
end
