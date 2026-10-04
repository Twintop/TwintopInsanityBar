---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Classes = TRB.Classes or {}


---The bar a set of spell threshold lines is drawn on.
---@class TRB.Classes.ThresholdBar
---@field public node TRB.Classes.BarNode
---@field public barTarget string # Only spells whose `barTarget` matches are drawn on this bar
---@field public resourceType Enum.PowerType? # When set, spells costing another resource are hidden in place (Druid forms)
---@field public maxResource number # The bar's scale; lines costing more are hidden
---@field public barSettings table? # Dimension block of the bar; nil means `settings.bar`
TRB.Classes.ThresholdBar = {}
TRB.Classes.ThresholdBar.__index = TRB.Classes.ThresholdBar

---@param barTarget string? # Defaults to "primary"
---@return TRB.Classes.ThresholdBar
function TRB.Classes.ThresholdBar:New(barTarget)
	local self = setmetatable({}, TRB.Classes.ThresholdBar)
	self.barTarget = barTarget or "primary"
	return self
end

---Points the bar at this tick's node and scale.
---@param node TRB.Classes.BarNode
---@param maxResource number
---@param resourceType Enum.PowerType?
---@param barSettings table?
function TRB.Classes.ThresholdBar:Set(node, maxResource, resourceType, barSettings)
	self.node = node
	self.maxResource = maxResource
	self.resourceType = resourceType
	self.barSettings = barSettings
end


---The spec, form, and character state the threshold rules read. Specs add their own fields for their snowflakes.
---@class TRB.Classes.ThresholdState
---@field public settings table # The spec cache settings, or the displayed form's
---@field public snapshotData TRB.Classes.SnapshotData
---@field public isStealthed boolean # Gates spells with the `stealth` attribute
---@field public stance string? # Gates spells with a `stances` set
---@field public isPvp boolean
---@field public currentTime number
TRB.Classes.ThresholdState = {}
TRB.Classes.ThresholdState.__index = TRB.Classes.ThresholdState

---@return TRB.Classes.ThresholdState
function TRB.Classes.ThresholdState:New()
	return setmetatable({}, TRB.Classes.ThresholdState)
end

---Re-reads the live state for this tick.
---@param settings table
function TRB.Classes.ThresholdState:Refresh(settings)
	self.settings = settings
	self.snapshotData = TRB.Data.snapshotData
	self.isStealthed = IsStealthed()
	self.isPvp = TRB.Data.character.isPvp
	self.currentTime = GetTime()
end


---The spell and talent data the threshold rules are driven by.
---@class TRB.Classes.ThresholdData
---@field public thresholdSpells (TRB.Classes.SpellThreshold|TRB.Classes.SpellComboPointThreshold)[]
---@field public spells TRB.Classes.SpecializationSpellsBase # The spec's full spell set, for snowflakes that read other spells
---@field public talents TRB.Classes.Talents
---@field public requireKnown boolean # Hides spells the character has not learned, for flavors whose spells have ranks
TRB.Classes.ThresholdData = {}
TRB.Classes.ThresholdData.__index = TRB.Classes.ThresholdData

---@param requireKnown boolean?
---@return TRB.Classes.ThresholdData
function TRB.Classes.ThresholdData:New(requireKnown)
	local self = setmetatable({}, TRB.Classes.ThresholdData)
	self.requireKnown = requireKnown == true
	return self
end

---Re-reads the active spec's threshold spells for this tick.
---@param talents TRB.Classes.Talents
function TRB.Classes.ThresholdData:Refresh(talents)
	self.thresholdSpells = TRB.Data.cache.thresholdSpells
	self.spells = TRB.Data.spellsData.spells
	self.talents = talents
end


---Spec-specific threshold behavior handed to `Threshold:UpdateSpellThresholds`.
---@class TRB.Classes.ThresholdSnowflakes
---@field public spells table<string, fun(line: TRB.Classes.ThresholdLine)>? # By settingKey: replaces the generic rules for a spell flagged `isSnowflake`
---@field public before (fun(line: TRB.Classes.ThresholdLine): boolean)? # Runs first on every spell; true skips the gates, the snowflake, and the generic rules
---@field public after fun(line: TRB.Classes.ThresholdLine)? # Runs on every spell after the max check, before drawing


---One spell's threshold line while its rules run. Snowflakes read and change its fields.
---@class TRB.Classes.ThresholdLine
---@field public spell TRB.Classes.SpellThreshold|TRB.Classes.SpellComboPointThreshold
---@field public frame Frame
---@field public pairOffset integer
---@field public dictEntry table?
---@field public snapshot TRB.Classes.Snapshot?
---@field public resourceAmount number
---@field public isUsable boolean
---@field public show boolean
---@field public color string? # nil when a color curve owns the line's color
---@field public frameLevel integer
---@field public bar TRB.Classes.ThresholdBar
---@field public state TRB.Classes.ThresholdState
---@field public data TRB.Classes.ThresholdData
TRB.Classes.ThresholdLine = {}
TRB.Classes.ThresholdLine.__index = TRB.Classes.ThresholdLine

---@return TRB.Classes.ThresholdLine
function TRB.Classes.ThresholdLine:New()
	return setmetatable({}, TRB.Classes.ThresholdLine)
end

function TRB.Classes.ThresholdLine:Hide()
	self.show = false
end

---Colors the line with one of the spec's threshold colors at a frame level.
---@param colorKey string # Key under `colors.threshold`, e.g. "over", "special", "echoingReprimand"
---@param frameLevel integer
function TRB.Classes.ThresholdLine:SetColor(colorKey, frameLevel)
	self.color = self.state.settings.colors.threshold[colorKey].color
	self.frameLevel = frameLevel
end

function TRB.Classes.ThresholdLine:Over()
	self:SetColor("over", TRB.Data.constants.frameLevels.thresholdOver)
end

function TRB.Classes.ThresholdLine:Under()
	self:SetColor("under", TRB.Data.constants.frameLevels.thresholdUnder)
end

function TRB.Classes.ThresholdLine:Unusable()
	self:SetColor("unusable", TRB.Data.constants.frameLevels.thresholdUnusable)
end

---A high-priority color, drawn above the other lines.
---@param colorKey string
function TRB.Classes.ThresholdLine:Special(colorKey)
	self:SetColor(colorKey, TRB.Data.constants.frameLevels.thresholdHighPriority)
end

function TRB.Classes.ThresholdLine:ColorByUsable()
	if self.isUsable then
		self:Over()
	else
		self:Under()
	end
end

function TRB.Classes.ThresholdLine:ColorByCooldown()
	if self.snapshot ~= nil and self.snapshot.cooldown:IsUnusable() then
		self:Unusable()
	else
		self:ColorByUsable()
	end
end

---Whether the spell spends combo points.
---@return boolean
function TRB.Classes.ThresholdLine:IsComboPointFinisher()
	return self.spell:Is("TRB.Classes.SpellComboPointThreshold") and self.spell--[[@as TRB.Classes.SpellComboPointThreshold]].comboPoints == true
end

---A combo point finisher with no combo points can't be cast at all.
function TRB.Classes.ThresholdLine:UnusableWithoutComboPoints()
	if self:IsComboPointFinisher() and (self.state.snapshotData.attributes.resource2 or 0) == 0 then
		self:Unusable()
	end
end

---Colors the line from a curve over the live resource, which a secret value can't be compared against directly.
---Set `frameLevel` first when the curve's level isn't "over".
---@param multiplier number # Cost multiple the curve steps at, e.g. 2 for a second cast
---@param baseCost number
function TRB.Classes.ThresholdLine:ApplyCostCurve(multiplier, baseCost)
	local Threshold = TRB.Functions.Threshold
	local Color = TRB.Functions.Color
	local settings = self.state.settings
	local underColor, overColor = Threshold:ResolveThresholdCurveColors(self.spell, settings)
	local thresholdCurve = Color:BuildThresholdCurve(multiplier, baseCost, underColor, overColor)
	local iconCurve = Color:BuildIconVertexColorCurve(multiplier, baseCost)
	local resourceType = self.bar.resourceType or TRB.Data.resource
	if Threshold:ApplyThresholdCurveColor(self.spell, self.frame, thresholdCurve, resourceType, settings, iconCurve, self.frameLevel, self.pairOffset, self.isUsable) then
		self.color = nil
	else
		self.color = underColor
	end
end
