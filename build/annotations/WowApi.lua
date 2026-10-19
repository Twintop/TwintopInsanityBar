---@meta
-- Language server annotations for WoW API the bundled annotations lack: fields newer than them (checked against the
-- 12.1.5 API docs) and FrameXML mixin members (checked against Blizzard_Menu). Never loaded in game.

---@class CooldownViewerCooldown
---@field isInvisible boolean

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
