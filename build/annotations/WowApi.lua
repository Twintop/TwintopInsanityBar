---@meta
-- Language server annotations for WoW API the bundled annotations lack: fields newer than them (checked against the
-- 12.1.5 API docs) and FrameXML mixin members (checked against Blizzard_Menu). Never loaded in game.

---@class CooldownViewerCooldown
---@field isInvisible boolean

---@class SpellCooldownInfo
---@field isActive boolean

---@class DropdownButtonMixin
local DropdownButtonMixin = {}

---Registers the menu; the generator runs as function(dropdown, rootDescription) each time the menu opens.
---@param generator fun(owner: any, rootDescription: table)
function DropdownButtonMixin:SetupMenu(generator) end

---@class DropdownTextMixin
local DropdownTextMixin = {}

---@param text string
function DropdownTextMixin:SetText(text) end

---@class DropdownSelectionTextMixin : DropdownTextMixin
local DropdownSelectionTextMixin = {}

---@param text string
function DropdownSelectionTextMixin:SetDefaultText(text) end

---@class WowStyle1DropdownMixin : DropdownSelectionTextMixin

---The template CreateFrame resolves "WowStyle1DropdownTemplate" to.
---@class WowStyle1DropdownTemplate : DropdownButton, WowStyle1DropdownMixin
---@field Text FontString

---@class SharedMenuDescriptionProxy
local SharedMenuDescriptionProxy = {}

---A submenu parent, which Blizzard_Menu's own menus create without a callback.
---@param text string
---@return ElementMenuDescriptionProxy
function SharedMenuDescriptionProxy:CreateButton(text) end

---@class GameTooltip
local GameTooltip = {}

---Nil colors keep the tooltip's default; Blizzard's own ChatConfigFrame.xml OnEnter calls it that way.
---@param text string
---@param colorR number?
---@param colorG number?
---@param colorB number?
---@param alpha number?
---@param wrap boolean?
function GameTooltip:SetText(text, colorR, colorG, colorB, alpha, wrap) end

---ChatConfigFrame.xml's checkbox base; its OnEnter shows self.tooltip.
---@class ChatConfigBaseCheckButtonTemplate : CheckButton
---@field tooltip string?
---@field tooltipStyle boolean?

---@class ChatConfigCheckButtonTemplate : CheckButton, ChatConfigBaseCheckButtonTemplate
---@field Text FontString

---The 12.1.5 docs add ignoreGCD, which the bundled annotation lacks.
---@param spellIdentifier SpellIdentifier
---@param ignoreGCD boolean?
---@return LuaDurationObject duration
function C_Spell.GetSpellCooldownDuration(spellIdentifier, ignoreGCD) end

---In the 12.1.5 docs (Totem system); the bundled annotations lack it. Returns nil for an empty slot, in or out of
---combat, though the docs say non-nilable (docs/totem-tracker-plan.md, Appendix C).
---@param slot integer
---@return LuaDurationObject? duration
function GetTotemDuration(slot) end

---@class EditModeMagneticFrame : Frame
---@field GetScaledSelectionSides fun(self: Frame): number, number, number, number
---@field HasValidSelectionRect fun(self: Frame): boolean

---Blizzard_EditMode's snap math (EditModeUtil.lua); a frame info is { frame, point, relativePoint, distance, offset, isHorizontal }.
---@class EditModeMagnetismManager
---@field magneticFrames table<EditModeMagneticFrame, boolean>
---@field topLevelParentCenterX number?
---@field topLevelParentLeft number
---@field topLevelParentRight number
---@field topLevelParentBottom number
---@field topLevelParentTop number
EditModeMagnetismManager = {}

---@param systemFrame Frame
---@param verticalLines boolean
---@return number distance
---@return string point
---@return string relativePoint
---@return number offset
function EditModeMagnetismManager:FindClosestGridLine(systemFrame, verticalLines) end

---Returns the closer of the current info and the offered one, or the current one when the offer is out of range.
---@param currentMagneticFrameInfo table?
---@param frame Frame
---@param point string
---@param relativePoint string
---@param distance number
---@param offset number
---@param isHorizontal boolean
---@return table? magneticFrameInfo
function EditModeMagnetismManager:CheckReplaceMagneticFrameInfo(currentMagneticFrameInfo, frame, point, relativePoint, distance, offset, isHorizontal) end

---@param frame Frame
---@param relativeToFrameInfo table?
---@return table? magneticFrameInfo
function EditModeMagnetismManager:GetCornerMagneticFrameInfo(frame, relativeToFrameInfo) end
