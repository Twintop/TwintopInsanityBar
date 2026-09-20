-- WoW API stubs for the smoke-load harness. Permissive by design: the goal is to catch
-- load-order/nil-index errors in addon code, not to emulate the client.
local M = {}

local unknownGlobals = {}
local timerQueue = {}
local frames = {}
local classes = {
	[1] = { "Warrior", "WARRIOR" }, [2] = { "Paladin", "PALADIN" }, [3] = { "Hunter", "HUNTER" },
	[4] = { "Rogue", "ROGUE" }, [5] = { "Priest", "PRIEST" }, [6] = { "Death Knight", "DEATHKNIGHT" },
	[7] = { "Shaman", "SHAMAN" }, [8] = { "Mage", "MAGE" }, [9] = { "Warlock", "WARLOCK" },
	[10] = { "Monk", "MONK" }, [11] = { "Druid", "DRUID" }, [12] = { "Demon Hunter", "DEMONHUNTER" },
	[13] = { "Evoker", "EVOKER" },
}

local function noop() end
local function retFalse() return false end
local function retTrue() return true end
local function retZero() return 0 end
local function retNil() return nil end
local function retEmpty() return {} end

-- A callable, indexable stub for unknown things.
local stubMeta = {}
stubMeta.__index = function(t, k) return setmetatable({ __name = tostring(rawget(t, "__name")) .. "." .. tostring(k) }, stubMeta) end
stubMeta.__call = function() return nil end
stubMeta.__concat = function(a, b) return tostring(a) .. tostring(b) end
stubMeta.__tostring = function(t) return "<stub " .. tostring(rawget(t, "__name")) .. ">" end
local function stub(name) return setmetatable({ __name = name }, stubMeta) end

-- Frame objects -------------------------------------------------------------------------------
local frameMeta = {}
local frameMethods = {}
frameMeta.__index = function(self, k)
	local m = frameMethods[k]
	if m ~= nil then return m end
	-- Widget methods are PascalCase; anything else is addon-attached data and reads as nil.
	if type(k) == "string" and k:match("^[A-Z]") then
		return noop
	end
	return nil
end

local function newFrame(ftype, name, parent, template)
	local f = setmetatable({}, frameMeta)
	f.__type = ftype or "Frame"
	f.__name = name
	f.__parent = parent
	f.__scripts = {}
	f.__events = {}
	f.__shown = true
	f.__children = {}
	f.__attrs = {}
	frames[#frames + 1] = f
	if name and type(name) == "string" then
		_G[name] = f
	end
	if template and type(template) == "string" and template:find("Backdrop") then
		f.SetBackdrop = noop
	end
	return f
end

function frameMethods:SetScript(kind, fn) self.__scripts[kind] = fn end
function frameMethods:GetScript(kind) return self.__scripts[kind] end
function frameMethods:HookScript(kind, fn)
	local prev = self.__scripts[kind]
	self.__scripts[kind] = function(...) if prev then prev(...) end fn(...) end
end
function frameMethods:HasScript() return true end
function frameMethods:RegisterEvent(ev) self.__events[ev] = true end
function frameMethods:RegisterUnitEvent(ev) self.__events[ev] = true end
function frameMethods:UnregisterEvent(ev) self.__events[ev] = nil end
function frameMethods:UnregisterAllEvents() self.__events = {} end
function frameMethods:IsEventRegistered(ev) return self.__events[ev] == true end
function frameMethods:Show() self.__shown = true end
function frameMethods:Hide() self.__shown = false end
function frameMethods:SetShown(v) self.__shown = v and true or false end
function frameMethods:IsShown() return self.__shown end
function frameMethods:IsVisible() return self.__shown end
function frameMethods:GetName() return self.__name end
function frameMethods:GetParent() return self.__parent end
function frameMethods:SetParent(p) self.__parent = p end
function frameMethods:GetObjectType() return self.__type end
function frameMethods:IsObjectType(t) return self.__type == t end
function frameMethods:GetWidth() return self.__width or 100 end
function frameMethods:GetHeight() return self.__height or 20 end
function frameMethods:SetWidth(w) self.__width = w end
function frameMethods:SetHeight(h) self.__height = h end
function frameMethods:SetSize(w, h) self.__width = w; self.__height = h end
function frameMethods:GetSize() return self.__width or 100, self.__height or 20 end
function frameMethods:GetRect() return 0, 0, self.__width or 100, self.__height or 20 end
function frameMethods:GetLeft() return 0 end
function frameMethods:GetRight() return self.__width or 100 end
function frameMethods:GetTop() return self.__height or 20 end
function frameMethods:GetBottom() return 0 end
function frameMethods:GetCenter() return 50, 10 end
function frameMethods:GetScale() return 1 end
function frameMethods:GetEffectiveScale() return 1 end
function frameMethods:GetFrameLevel() return self.__level or 1 end
function frameMethods:SetFrameLevel(l) self.__level = l end
function frameMethods:GetFrameStrata() return self.__strata or "MEDIUM" end
function frameMethods:SetFrameStrata(s) self.__strata = s end
function frameMethods:GetAlpha() return 1 end
function frameMethods:GetPoint() return "CENTER", nil, "CENTER", 0, 0 end
function frameMethods:GetNumPoints() return 1 end
function frameMethods:GetChildren() return unpack(self.__children) end
function frameMethods:GetNumChildren() return #self.__children end
function frameMethods:GetRegions() return nil end
function frameMethods:GetNumRegions() return 0 end
function frameMethods:GetValue() return self.__value or 0 end
function frameMethods:SetValue(v) self.__value = v end
function frameMethods:GetMinMaxValues() return 0, 1 end
function frameMethods:GetText() return self.__text or "" end
function frameMethods:SetText(t) self.__text = t end
function frameMethods:SetFormattedText(fmt, ...) self.__text = string.format(fmt, ...) end
function frameMethods:GetStringWidth() return 10 end
function frameMethods:GetStringHeight() return 10 end
function frameMethods:GetFont() return "Fonts\\FRIZQT__.TTF", 12, "" end
function frameMethods:GetTextColor() return 1, 1, 1, 1 end
function frameMethods:GetVertexColor() return 1, 1, 1, 1 end
function frameMethods:GetStatusBarTexture() self.__tex = self.__tex or newFrame("Texture", nil, self); return self.__tex end
function frameMethods:GetStatusBarColor() return 1, 1, 1, 1 end
function frameMethods:GetTexture() return "" end
function frameMethods:GetAtlas() return nil end
function frameMethods:GetTexCoord() return 0, 0, 0, 1, 1, 0, 1, 1 end
function frameMethods:GetChecked() return false end
function frameMethods:IsEnabled() return true end
function frameMethods:IsMouseOver() return false end
function frameMethods:IsMouseEnabled() return false end
function frameMethods:IsProtected() return false end
function frameMethods:IsForbidden() return false end
function frameMethods:GetAttribute(k) return self.__attrs[k] end
function frameMethods:SetAttribute(k, v) self.__attrs[k] = v end
function frameMethods:GetID() return self.__id or 0 end
function frameMethods:SetID(id) self.__id = id end
function frameMethods:GetOrientation() return "HORIZONTAL" end
function frameMethods:GetReverseFill() return false end
function frameMethods:GetFillStyle() return "STANDARD" end
function frameMethods:GetBackdrop() return nil end
function frameMethods:GetBackdropColor() return 0, 0, 0, 1 end
function frameMethods:GetBackdropBorderColor() return 0, 0, 0, 1 end
function frameMethods:GetHitRectInsets() return 0, 0, 0, 0 end
function frameMethods:GetMaxLetters() return 0 end
function frameMethods:GetNumber() return 0 end
function frameMethods:GetCursorPosition() return 0 end
function frameMethods:GetScrollChild() return self.__scrollChild end
function frameMethods:SetScrollChild(c) self.__scrollChild = c end
function frameMethods:GetVerticalScroll() return 0 end
function frameMethods:GetVerticalScrollRange() return 0 end
function frameMethods:GetHorizontalScrollRange() return 0 end
function frameMethods:GetElapsed() return 0 end
function frameMethods:GetDuration() return 0 end
function frameMethods:IsPlaying() return false end
function frameMethods:GetAnimations() return nil end
function frameMethods:CreateTexture(name, layer, template) local t = newFrame("Texture", name, self, template); return t end
function frameMethods:CreateMaskTexture(name) return newFrame("MaskTexture", name, self) end
function frameMethods:CreateFontString(name, layer, template) return newFrame("FontString", name, self, template) end
function frameMethods:CreateAnimationGroup(name) return newFrame("AnimationGroup", name, self) end
function frameMethods:CreateAnimation(kind, name) return newFrame(kind or "Animation", name, self) end
function frameMethods:CreateLine(name) return newFrame("Line", name, self) end
function frameMethods:GetFontObject() return nil end
function frameMethods:GetNormalTexture() return newFrame("Texture", nil, self) end
function frameMethods:GetPushedTexture() return newFrame("Texture", nil, self) end
function frameMethods:GetHighlightTexture() return newFrame("Texture", nil, self) end
function frameMethods:GetCheckedTexture() return newFrame("Texture", nil, self) end
function frameMethods:GetDisabledTexture() return newFrame("Texture", nil, self) end
function frameMethods:GetThumbTexture() return newFrame("Texture", nil, self) end
function frameMethods:GetFontString() return newFrame("FontString", nil, self) end
function frameMethods:GetEditBox() return self.__editBox or newFrame("EditBox", nil, self) end
function frameMethods:GetLeftIndent() return 0 end
function frameMethods:GetNumLines() return 1 end
function frameMethods:GetSpacing() return 0 end
function frameMethods:GetShadowOffset() return 0, 0 end
function frameMethods:GetJustifyH() return "LEFT" end
function frameMethods:GetJustifyV() return "MIDDLE" end
function frameMethods:GetWordWrap() return true end
function frameMethods:GetMotionScriptsWhileDisabled() return false end
function frameMethods:CanChangeAttribute() return true end
function frameMethods:IsUserPlaced() return false end
function frameMethods:IsMovable() return false end
function frameMethods:IsResizable() return false end
function frameMethods:GetMinResize() return 0, 0 end
function frameMethods:GetMaxResize() return 0, 0 end
function frameMethods:GetClampRectInsets() return 0, 0, 0, 0 end
function frameMethods:GetPropagateKeyboardInput() return false end
function frameMethods:IsKeyboardEnabled() return false end
function frameMethods:GetDrawLayer() return "ARTWORK", 0 end
function frameMethods:GetBlendMode() return "BLEND" end
function frameMethods:GetDesaturation() return 0 end
function frameMethods:IsDesaturated() return false end
function frameMethods:GetValueStep() return 1 end
function frameMethods:GetObeyStepOnDrag() return false end
function frameMethods:GetStepsPerPage() return 1 end
function frameMethods:GetSelectedValue() return nil end
function frameMethods:GetCooldownDuration() return 0 end
function frameMethods:GetCooldownTimes() return 0, 0 end
function frameMethods:GetDrawEdge() return false end
function frameMethods:GetReverse() return false end

-- Globals ---------------------------------------------------------------------------------------
function M.install(opts)
	local classId = opts.classId
	local metadata = opts.metadata
	local addonName = opts.addonName
	local G = _G

	G.__harness = { unknownGlobals = unknownGlobals, timerQueue = timerQueue, frames = frames }

	-- Lua extensions WoW provides
	G.wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
	G.tinsert = table.insert
	G.tremove = table.remove
	G.tContains = function(t, v) for _, x in pairs(t) do if x == v then return true end end return false end
	G.tIndexOf = function(t, v) for i, x in ipairs(t) do if x == v then return i end end return nil end
	G.tInvert = function(t) local r = {} for k, v in pairs(t) do r[v] = k end return r end
	G.tFilter = function(t, f, isIndex) local r = {} for k, v in pairs(t) do if f(v) then if isIndex then r[#r + 1] = v else r[k] = v end end end return r end
	G.CopyTable = function(t, shallow) local r = {} for k, v in pairs(t) do if type(v) == "table" and not shallow then r[k] = G.CopyTable(v) else r[k] = v end end return r end
	G.Mixin = function(obj, ...) for i = 1, select("#", ...) do local m = select(i, ...) for k, v in pairs(m) do obj[k] = v end end return obj end
	G.CreateFromMixins = function(...) return G.Mixin({}, ...) end
	G.GenerateClosure = function(f, ...) local args = { ... } local n = select("#", ...) return function(...) local a = {} for i = 1, n do a[i] = args[i] end local m = select("#", ...) for i = 1, m do a[n + i] = select(i, ...) end return f(unpack(a, 1, n + m)) end end
	G.nop = noop
	G.strsplit = function(delim, s, pieces) local r = {} for piece in (s .. delim):gmatch("(.-)" .. delim:gsub("%p", "%%%0")) do r[#r + 1] = piece end return unpack(r) end
	G.strjoin = function(delim, ...) return table.concat({ ... }, delim) end
	G.strtrim = function(s, chars) chars = chars or "%s" return (s:gsub("^[" .. chars .. "]+", ""):gsub("[" .. chars .. "]+$", "")) end
	G.strfind, G.strsub, G.strlen, G.strupper, G.strlower, G.strmatch, G.strrep, G.strbyte, G.strchar, G.gsub, G.gmatch, G.format = string.find, string.sub, string.len, string.upper, string.lower, string.match, string.rep, string.byte, string.char, string.gsub, string.gmatch, string.format
	G.strlenutf8 = string.len
	G.tostringall = function(...) local r = {} for i = 1, select("#", ...) do r[i] = tostring(select(i, ...)) end return unpack(r) end
	G.floor, G.ceil, G.abs, G.min, G.max, G.mod, G.sqrt, G.random = math.floor, math.ceil, math.abs, math.min, math.max, math.fmod, math.sqrt, math.random
	G.fastrandom = math.random
	G.date = os.date
	G.time = os.time
	G.debugstack = function() return debug.traceback() end
	G.geterrorhandler = function() return function(e) print("ERRORHANDLER: " .. tostring(e)) end end
	G.seterrorhandler = noop
	G.hooksecurefunc = function(a, b, c) if type(a) == "table" then local prev = a[b] a[b] = function(...) if prev then prev(...) end c(...) end else local prev = G[a] G[a] = function(...) if prev then prev(...) end b(...) end end end
	G.issecretvalue = retFalse
	G.canaccessvalue = retTrue
	G.issecurevariable = retFalse
	G.securecall = function(f, ...) if type(f) == "string" then f = G[f] end return f(...) end
	G.securecallfunction = function(f, ...) return f(...) end
	G.forceinsecure = noop
	G.RunNextFrame = function(f) timerQueue[#timerQueue + 1] = { 0, f } end
	G.AbbreviateNumbers = function(n) return tostring(n) end
	G.AbbreviateLargeNumbers = function(n) return tostring(n) end
	G.BreakUpLargeNumbers = function(n) return tostring(n) end
	G.SecondsToTime = function(s) return tostring(s) end
	G.Round = function(n) return math.floor(n + 0.5) end
	G.Clamp = function(v, lo, hi) return math.max(lo, math.min(hi, v)) end
	G.Lerp = function(a, b, t) return a + (b - a) * t end
	G.Saturate = function(v) return math.max(0, math.min(1, v)) end
	G.ApproximatelyEqual = function(a, b, e) return math.abs(a - b) <= (e or 0.0001) end

	-- Frames / UI
	G.CreateFrame = function(ftype, name, parent, template, id) local f = newFrame(ftype, name, parent, template) f.__id = id return f end
	G.CreateFont = function(name) return newFrame("Font", name) end
	G.UIParent = newFrame("Frame", "UIParent")
	G.WorldFrame = newFrame("Frame", "WorldFrame")
	G.GameTooltip = newFrame("GameTooltip", "GameTooltip")
	G.GameTooltip.SetOwner = noop
	G.GameTooltip.AddLine = noop
	G.GameTooltip.AddDoubleLine = noop
	G.GameTooltip.SetSpellByID = noop
	G.GameTooltip.SetItemByID = noop
	G.GameTooltip.NumLines = retZero
	G.SettingsTooltip = G.GameTooltip
	G.ColorPickerFrame = newFrame("Frame", "ColorPickerFrame")
	G.ColorPickerFrame.GetColorRGB = function() return 1, 1, 1 end
	G.ColorPickerFrame.GetColorAlpha = function() return 1 end
	G.ColorPickerFrame.SetupColorPickerAndShow = noop
	G.EditModeManagerFrame = newFrame("Frame", "EditModeManagerFrame")
	G.EditModeManagerFrame.IsEditModeActive = retFalse
	G.EditModeManagerFrame.GetActiveLayoutInfo = function() return { layoutName = "Modern", layoutType = 0 } end
	G.EditModeManagerFrame.GetLayouts = retEmpty
	G.EditModeManagerFrame.AccountSettings = newFrame("Frame")
	G.EditModeSystemSettingsDialog = newFrame("Frame", "EditModeSystemSettingsDialog")
	G.AddonCompartmentFrame = newFrame("Frame", "AddonCompartmentFrame")
	G.AddonCompartmentFrame.RegisterAddon = noop
	G.Minimap = newFrame("Frame", "Minimap")
	G.MinimapCluster = newFrame("Frame", "MinimapCluster")
	G.PlayerFrame = newFrame("Frame", "PlayerFrame")
	G.TargetFrame = newFrame("Frame", "TargetFrame")
	G.FocusFrame = newFrame("Frame", "FocusFrame")
	G.CastingBarFrame = newFrame("StatusBar", "CastingBarFrame")
	G.PlayerCastingBarFrame = newFrame("StatusBar", "PlayerCastingBarFrame")
	G.MirrorTimerContainer = newFrame("Frame", "MirrorTimerContainer")
	G.CooldownViewerSettings = newFrame("Frame", "CooldownViewerSettings")
	G.EssentialCooldownViewer = newFrame("Frame", "EssentialCooldownViewer")
	G.UtilityCooldownViewer = newFrame("Frame", "UtilityCooldownViewer")
	G.BuffIconCooldownViewer = newFrame("Frame", "BuffIconCooldownViewer")
	G.BuffBarCooldownViewer = newFrame("Frame", "BuffBarCooldownViewer")
	for _, fontName in ipairs({ "GameFontNormal", "GameFontHighlight", "GameFontHighlightSmall", "GameFontGreenSmall", "GameFontNormalSmall", "GameFontWhite", "GameFontDisableSmallLeft", "GameFontHighlightSmallLeft", "GameFontNormalSmallLeft", "GameFontNormalLarge", "GameFontHighlightLarge", "GameFontDisable", "GameFontRed", "NumberFontNormal", "ChatFontNormal", "GameTooltipText", "GameFontNormalHuge", "SystemFont_Shadow_Med1", "GameFontNormalMed3" }) do
		G[fontName] = newFrame("Font", fontName)
	end
	G.BackdropTemplateMixin = {}
	G.TooltipBackdropTemplateMixin = {}
	G.DefaultTooltipMixin = {}
	G.MinimalSliderWithSteppersMixin = { Label = { Left = 1, Right = 2, Top = 4 } }
	G.CreateMinimalSliderFormatter = function() return function(v) return tostring(v) end end
	G.DropDownMenuButtonMixin = {}
	G.StaticPopupDialogs = {}
	G.StaticPopup_Show = noop
	G.StaticPopup_Hide = noop
	G.StaticPopup_Visible = retFalse
	G.SlashCmdList = {}
	G.UISpecialFrames = {}
	G.INTERFACEOPTIONS_ADDONCATEGORIES = {}
	G.UIDROPDOWNMENU_MAXLEVELS = 3
	G.UIDropDownMenu_Initialize = noop
	G.UIDropDownMenu_SetWidth = noop
	G.UIDropDownMenu_SetText = noop
	G.UIDropDownMenu_JustifyText = noop
	G.UIDropDownMenu_CreateInfo = retEmpty
	G.UIDropDownMenu_AddButton = noop
	G.UIDropDownMenu_SetSelectedValue = noop
	G.UIDropDownMenu_GetSelectedValue = retNil
	G.CloseDropDownMenus = noop
	G.ToggleDropDownMenu = noop
	G.PanelTemplates_TabResize = noop
	G.PanelTemplates_SetTab = noop
	G.PanelTemplates_SelectTab = noop
	G.PanelTemplates_DeselectTab = noop
	G.PanelTemplates_SetNumTabs = noop
	G.PanelTemplates_UpdateTabs = noop
	G.FauxScrollFrame_Update = noop
	G.FauxScrollFrame_OnVerticalScroll = noop
	G.FauxScrollFrame_GetOffset = retZero
	G.ScrollFrame_OnLoad = noop
	G.ScrollFrame_OnScrollRangeChanged = noop
	G.ExecuteFrameScript = function(frame, script, ...) local fn = frame.__scripts and frame.__scripts[script] if fn then fn(frame, ...) end end
	G.GameTooltip_Hide = noop
	G.GameTooltip_AddErrorLine = noop
	G.GameTooltip_SetTitle = noop
	G.GameTooltip_AddNormalLine = noop
	G.SharedTooltip_SetBackdropStyle = noop
	G.ReloadUI = noop
	G.PlaySound = noop
	G.PlaySoundFile = retTrue
	G.StopSound = noop
	G.SOUNDKIT = setmetatable({}, { __index = function() return 1 end })
	G.RegisterStateDriver = noop
	G.UnregisterStateDriver = noop
	G.SetPortraitTexture = noop
	G.SetPortraitToTexture = noop
	G.getglobal = function(n) return G[n] end
	G.setglobal = function(n, v) G[n] = v end
	G.SecondsFormatter = {}
	G.CreateColor = function(r, g, b, a) return { r = r, g = g, b = b, a = a or 1, GetRGBA = function(s) return s.r, s.g, s.b, s.a end, GetRGB = function(s) return s.r, s.g, s.b end, GenerateHexColor = function(s) return string.format("%02x%02x%02x%02x", (s.a or 1) * 255, s.r * 255, s.g * 255, s.b * 255) end, GenerateHexColorMarkup = function(s) return "|cff" .. string.format("%02x%02x%02x", s.r * 255, s.g * 255, s.b * 255) end, WrapTextInColorCode = function(s, t) return t end, IsEqualTo = function(s, o) return false end } end
	G.CreateColorFromHexString = function(hex) return G.CreateColor(1, 1, 1, 1) end
	G.CreateColorFromBytes = function(r, g, b, a) return G.CreateColor(r / 255, g / 255, b / 255, (a or 255) / 255) end
	G.NORMAL_FONT_COLOR = G.CreateColor(1, 0.82, 0)
	G.HIGHLIGHT_FONT_COLOR = G.CreateColor(1, 1, 1)
	G.GRAY_FONT_COLOR = G.CreateColor(0.5, 0.5, 0.5)
	G.RED_FONT_COLOR = G.CreateColor(1, 0.1, 0.1)
	G.GREEN_FONT_COLOR = G.CreateColor(0.1, 1, 0.1)
	G.ORANGE_FONT_COLOR = G.CreateColor(1, 0.5, 0.25)
	G.TOOLTIP_DEFAULT_COLOR = G.CreateColor(1, 1, 1)
	G.TOOLTIP_DEFAULT_BACKGROUND_COLOR = G.CreateColor(0, 0, 0)
	G.COMMON_GRAY_COLOR = G.CreateColor(0.6, 0.6, 0.6)
	G.UNCOMMON_GREEN_COLOR = G.CreateColor(0.1, 1, 0.1)
	G.RARE_BLUE_COLOR = G.CreateColor(0, 0.4, 0.9)
	G.EPIC_PURPLE_COLOR = G.CreateColor(0.6, 0.2, 0.9)
	G.LEGENDARY_ORANGE_COLOR = G.CreateColor(1, 0.5, 0)
	G.ARTIFACT_GOLD_COLOR = G.CreateColor(0.9, 0.8, 0.5)
	G.HEIRLOOM_BLUE_COLOR = G.CreateColor(0, 0.8, 1)
	G.RAID_CLASS_COLORS = setmetatable({}, { __index = function() return G.CreateColor(1, 1, 1) end })
	G.CUSTOM_CLASS_COLORS = nil
	G.PowerBarColor = setmetatable({}, { __index = function() return { r = 0, g = 0, b = 1 } end })
	G.STAGGER_STATES = { RED = { r = 1, g = 0, b = 0 }, YELLOW = { r = 1, g = 1, b = 0 }, GREEN = { r = 0, g = 1, b = 0 } }
	G.CurveConstants = { ColorCurveDefaultIndex = 0, DefaultIndex = 0 }
	G.MAX_COMBO_POINTS = 5
	G.WOW_PROJECT_ID = 1
	G.WOW_PROJECT_MAINLINE = 1
	G.WOW_PROJECT_CLASSIC = 2
	G.LE_LFG_CATEGORY_LFD, G.LE_LFG_CATEGORY_RF, G.LE_LFG_CATEGORY_SCENARIO, G.LE_LFG_CATEGORY_LFR, G.LE_LFG_CATEGORY_FLEXRAID, G.LE_LFG_CATEGORY_WORLDPVP, G.LE_LFG_CATEGORY_BATTLEFIELD = 1, 2, 3, 4, 5, 6, 7
	G.RATED_SOLO_SHUFFLE_SIZE = 6
	G.NUM_CHAT_WINDOWS = 10
	G.MAX_PLAYER_LEVEL = 80
	G.Enum = setmetatable({
		PowerType = { HealthCost = -2, None = -1, Mana = 0, Rage = 1, Focus = 2, Energy = 3, ComboPoints = 4, Runes = 5, RunicPower = 6, SoulShards = 7, LunarPower = 8, HolyPower = 9, Alternate = 10, Maelstrom = 11, Chi = 12, Insanity = 13, Obsolete = 14, Obsolete2 = 15, ArcaneCharges = 16, Fury = 17, Pain = 18, Essence = 19, RuneBlood = 20, RuneFrost = 21, RuneUnholy = 22, AlternateMount = 23, AlternateQuest = 24, AlternateEncounter = 25, NumPowerTypes = 26 },
		Damageclass = { Physical = 0, Holy = 1, Fire = 2, Nature = 3, Frost = 4, Shadow = 5, Arcane = 6 },
		EditModeLayoutType = { Preset = 0, Account = 1, Character = 2 },
		EditModeSettingDisplayType = { Dropdown = 0, Slider = 1, Checkbox = 2 },
		CooldownViewerCategory = { Essential = 0, Utility = 1, TrackedBuff = 2, TrackedBar = 3 },
		CooldownViewerCooldownFlags = {},
		UIWidgetVisualizationType = {},
		TooltipDataType = {},
		SpellBookSpellBank = { Player = 0, Pet = 1 },
		SpellBookItemType = { None = 0, Spell = 1, FutureSpell = 2, PetAction = 3, Flyout = 4 },
		AuraFilter = {},
		StaggerStates = { Light = 0, Moderate = 1, Heavy = 2 },
		TraitNodeType = { Single = 0, Tiered = 1, Selection = 2, SubTreeSelection = 3 },
		TraitPointsOperationType = { None = -1, Set = 0, Multiply = 1 },
		TraitNodeEntryType = { SpendHex = 0, SpendSquare = 1, SpendCircle = 2, SpendSmallCircle = 3, DeprecatedSelect = 4, DragAndDrop = 5, SpendDiamond = 6, ProfPath = 7, ProfPerk = 8, ProfPathUnlock = 9 },
		UnitSex = { Male = 2, Female = 3 },
		SpellRangeCheckStatus = {},
		WidgetShownState = {},
		MirrorTimerType = {},
		FlightPathState = {},
		PlayerInteractionType = {},
		ChatChannelType = {},
		ItemQuality = { Poor = 0, Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Artifact = 6, Heirloom = 7 },
	}, { __index = function(t, k) local e = setmetatable({}, { __index = function() return 0 end }) rawset(t, k, e) return e end })
	G.LE_UNIT_STAT_STRENGTH, G.LE_UNIT_STAT_AGILITY, G.LE_UNIT_STAT_STAMINA, G.LE_UNIT_STAT_INTELLECT = 1, 2, 3, 4
	G.CR_HASTE_SPELL, G.CR_HASTE_MELEE, G.CR_HASTE_RANGED, G.CR_VERSATILITY_DAMAGE_DONE, G.CR_VERSATILITY_DAMAGE_TAKEN, G.CR_CRIT_SPELL, G.CR_MASTERY, G.CR_SPEED, G.CR_LIFESTEAL, G.CR_AVOIDANCE = 20, 18, 19, 29, 31, 11, 26, 14, 17, 21
	G.Settings = {
		RegisterCanvasLayoutCategory = function(frame, name) local c = { __frame = frame, __name = name, GetID = function() return name end, GetName = function() return name end, SetCategorySet = noop } return c end,
		RegisterCanvasLayoutSubcategory = function(parent, frame, name) local c = { __frame = frame, __name = name, GetID = function() return name end, GetName = function() return name end, SetCategorySet = noop } return c end,
		RegisterVerticalLayoutCategory = function(name) return { GetID = function() return name end, GetName = function() return name end } end,
		RegisterAddOnCategory = noop,
		OpenToCategory = noop,
		CreateCheckbox = noop,
		CreateSlider = noop,
		CreateDropdown = noop,
		GetCategory = retNil,
		GetValue = retNil,
		SetValue = noop,
		VarType = { Boolean = "boolean", Number = "number", String = "string" },
		Default = { True = true, False = false },
		CreateControlTextContainer = function() return { Add = noop, GetData = retEmpty } end,
		CreateSliderOptions = function() return { SetLabelFormatter = noop } end,
	}
	G.SettingsPanel = newFrame("Frame", "SettingsPanel")
	G.SettingsPanel.GetCategoryList = function() return { GetCategory = retNil } end

	-- Unit / character
	local cls = classes[classId] or classes[5]
	G.UnitClass = function() return cls[1], cls[2], classId end
	G.UnitClassBase = function() return cls[2], classId end
	G.UnitGUID = function() return "Player-1-00000001" end
	G.UnitRace = function() return "Human", "Human", 1 end
	G.UnitSex = function() return 2 end
	G.UnitName = function() return "Tester" end
	G.UnitFullName = function() return "Tester", "Realm" end
	G.UnitLevel = function() return 80 end
	G.UnitEffectiveLevel = function() return 80 end
	G.UnitExists = retFalse
	G.UnitIsUnit = retFalse
	G.UnitIsPlayer = retTrue
	G.UnitIsFriend = retFalse
	G.UnitIsEnemy = retFalse
	G.UnitCanAttack = retFalse
	G.UnitIsDeadOrGhost = retFalse
	G.UnitIsDead = retFalse
	G.UnitIsGhost = retFalse
	G.UnitAffectingCombat = retFalse
	G.UnitInVehicle = retFalse
	G.UnitHasVehicleUI = retFalse
	G.UnitOnTaxi = retFalse
	G.UnitIsAFK = retFalse
	G.UnitPower = function(u, p) return 0 end
	G.UnitPowerMax = function(u, p) return 100 end
	G.UnitPowerType = function() return 0, "MANA" end
	G.UnitPowerPercent = function() return 0 end
	G.UnitPowerDisplayMod = function() return 1 end
	G.UnitHealth = function() return 100 end
	G.UnitHealthMax = function() return 100 end
	G.UnitHealthPercent = function() return 100 end
	G.UnitGetTotalAbsorbs = retZero
	G.UnitGetTotalHealAbsorbs = retZero
	G.UnitGetIncomingHeals = retZero
	G.UnitStat = function() return 100, 100, 0, 0 end
	G.UnitAttackSpeed = function() return 2, 2 end
	G.UnitRangedDamage = function() return 2 end
	G.UnitDamage = function() return 1, 1 end
	G.UnitSpellHaste = retZero
	G.UnitCastingInfo = retNil
	G.UnitChannelInfo = retNil
	G.UnitEmpoweredChannelInfo = retNil
	G.UnitAura = retNil
	G.UnitBuff = retNil
	G.UnitDebuff = retNil
	G.UnitThreatSituation = retNil
	G.UnitGroupRolesAssigned = function() return "NONE" end
	G.UnitFactionGroup = function() return "Alliance", "Alliance" end
	G.UnitPlayerControlled = retTrue
	G.UnitIsTapDenied = retFalse
	G.UnitClassification = function() return "normal" end
	G.UnitCreatureType = function() return "Humanoid" end
	G.UnitIsOtherPlayersPet = retFalse
	G.UnitTokenFromGUID = retNil
	G.GetSpecialization = function() return 1 end
	G.GetSpecializationInfo = function(i) return 1000 + i, "Spec" .. tostring(i), "", 0, "DAMAGER", "INTELLECT" end
	G.GetSpecializationInfoByID = function(id) return id, "Spec" .. tostring(id), "", 0, "DAMAGER", "INTELLECT" end
	G.GetSpecializationInfoForClassID = function(c, i) return c * 100 + i, "Spec" .. tostring(i), "", 0, "DAMAGER", "INTELLECT" end
	G.GetNumSpecializationsForClassID = function(c) if c == 11 then return 4 end return 3 end
	G.GetNumSpecializations = function() if classId == 11 then return 4 end return 3 end
	G.GetSpecializationName = function() return "Spec" end
	G.GetSpecializationRole = function() return "DAMAGER" end
	G.GetClassColor = function(token) return 1, 1, 1, "ffffffff" end
	G.GetClassInfo = function(id) local c = classes[id] if c then return c[1], c[2], id end return nil end
	G.GetNumClasses = function() return 13 end
	G.LocalizedClassList = function() local r = {} for _, c in pairs(classes) do r[c[2]] = c[1] end return r end
	G.FillLocalizedClassList = function(t) for _, c in pairs(classes) do t[c[2]] = c[1] end return t end
	-- The interface number follows the TOC under test so each flavor's client gate sees its own client.
	local interfaceVersion = tonumber(tostring(metadata.Interface or ""):match("%d+")) or 120100
	local buildVersion = string.format("%d.%d.%d", math.floor(interfaceVersion / 10000), math.floor(interfaceVersion / 100) % 100, interfaceVersion % 100)
	G.GetBuildInfo = function() return buildVersion, "68675", "Sep 1 2026", interfaceVersion end
	G.GetTime = function() return os.clock() end
	G.GetTimePreciseSec = function() return os.clock() end
	G.GetServerTime = os.time
	G.GetLocale = function() return "enUS" end
	G.GetCVar = retNil
	G.GetCVarBool = retFalse
	G.SetCVar = noop
	G.GetScreenWidth = function() return 1920 end
	G.GetScreenHeight = function() return 1080 end
	G.GetPhysicalScreenSize = function() return 1920, 1080 end
	G.GetFramerate = function() return 60 end
	G.GetNetStats = function() return 0, 0, 30, 30 end
	G.InCombatLockdown = retFalse
	G.IsInInstance = function() return false, "none" end
	G.GetInstanceInfo = function() return "None", "none", 0, "", 0, 0, false, 0, 0 end
	G.IsInRaid = retFalse
	G.IsInGroup = retFalse
	G.GetNumGroupMembers = retZero
	G.IsMounted = retFalse
	G.IsFlying = retFalse
	G.IsFlyableArea = retFalse
	G.IsAdvancedFlyableArea = retFalse
	G.IsSwimming = retFalse
	G.IsFalling = retFalse
	G.IsStealthed = retFalse
	G.IsResting = retFalse
	G.IsShiftKeyDown = retFalse
	G.IsControlKeyDown = retFalse
	G.IsAltKeyDown = retFalse
	G.IsModifierKeyDown = retFalse
	G.GetShapeshiftForm = retZero
	G.GetShapeshiftFormID = retNil
	G.GetNumShapeshiftForms = retZero
	G.GetShapeshiftFormInfo = retNil
	G.GetHaste = retZero
	G.GetMeleeHaste = retZero
	G.GetRangedHaste = retZero
	G.GetSpellHaste = retZero
	G.GetCritChance = retZero
	G.GetSpellCritChance = retZero
	G.GetRangedCritChance = retZero
	G.GetMasteryEffect = function() return 0, 0 end
	G.GetMastery = retZero
	G.GetVersatilityBonus = retZero
	G.GetCombatRating = retZero
	G.GetCombatRatingBonus = retZero
	G.GetSpeed = retZero
	G.GetLifesteal = retZero
	G.GetAvoidance = retZero
	G.GetPowerRegen = function() return 0, 0 end
	G.GetManaRegen = function() return 0, 0 end
	-- Forever (Vanilla) character-sheet stats, with the client's return shapes.
	G.UnitDefenseSkill = function() return 300, 0 end
	G.GetDodgeChance = function() return 5 end
	G.GetParryChance = function() return 5 end
	G.GetBlockChance = function() return 5 end
	G.GetShieldBlock = function() return 20 end
	G.UnitArmor = function() return 100, 100, 100, 0 end
	G.UnitResistance = function() return 0, 0, 0, 0 end
	G.GetHitModifier = retZero
	G.GetRangedHitModifier = retZero
	G.GetSpellHitModifier = retZero
	G.GetExpertise = function() return 0, 0, 0 end
	G.GetArmorPenetration = retZero
	G.GetSpellBonusDamage = retZero
	G.GetSpellBonusHealing = retZero
	G.GetSpellPenetration = retZero
	G.UnitAttackPower = function() return 100, 0, 0 end
	G.UnitRangedAttackPower = function() return 100, 0, 0 end
	G.GetPowerRegenForPowerType = function() return 0, 0 end
	G.GetComboPoints = retZero
	G.GetRuneCooldown = function() return 0, 10, true end
	G.GetRuneType = function() return 1 end
	G.GetSpellBaseCooldown = function() return 0, 0 end
	G.GetSpellInfo = function(id) return "Spell" .. tostring(id), nil, 0, 0, 0, 0, id end
	G.GetSpellTexture = retZero
	G.GetSpellDescription = function() return "" end
	G.GetSpellLink = function(id) return "|cff71d5ff|Hspell:" .. tostring(id) .. "|h[Spell]|h|r" end
	G.IsSpellKnown = retFalse
	G.IsPlayerSpell = retFalse
	G.IsSpellKnownOrOverridesKnown = retFalse
	G.IsUsableSpell = function() return true, false end
	G.IsSpellInRange = retNil
	G.GetSpellCooldown = function() return 0, 0, 1, 1 end
	G.GetSpellCharges = function() return 0, 0, 0, 0, 1 end
	G.GetSpellCount = retZero
	G.GetPvpTalentInfoByID = function(id) return id, "PvpTalent", 0, false, false, id end
	G.GetTalentInfo = retNil
	G.GetNumTalentTabs = retZero
	G.GetInventoryItemID = retNil
	G.GetInventoryItemLink = retNil
	G.GetInventorySlotInfo = function() return 1 end
	G.GetItemInfo = retNil
	G.GetItemIcon = retZero
	G.GetItemCount = retZero
	G.GetItemCooldown = function() return 0, 0, 1 end
	G.IsEquippedItem = retFalse
	G.GetMirrorTimerInfo = function() return "UNKNOWN", 0, 0, 0, false, "" end
	G.GetMirrorTimerProgress = retZero
	G.GetUnitPowerBarInfo = retNil
	G.GetActionInfo = retNil
	G.GetMacroInfo = retNil
	G.GetNumMacros = function() return 0, 0 end
	G.GetRealmName = function() return "Realm" end
	G.GetNormalizedRealmName = function() return "Realm" end
	G.GetCurrentRegion = function() return 1 end
	G.GetAddOnMetadata = function(name, field) return metadata[field] end
	G.IsAddOnLoaded = retFalse
	G.LoadAddOn = function() return true end
	G.GetNumAddOns = retZero
	G.GetAddOnInfo = retNil
	G.EnableAddOn = noop
	G.IsLoggedIn = retTrue
	G.IsPlayerMoving = retFalse
	G.GetUnitSpeed = retZero
	G.UnitIsCharmed = retFalse
	G.UnitIsPossessed = retFalse
	G.UnitIsControlling = retFalse
	G.HasPetUI = retFalse
	G.PetHasActionBar = retFalse
	G.GetPetTalentTree = retNil
	G.GetSpellBookItemInfo = retNil
	G.GetSpellBookItemName = retNil
	G.GetNumSpellTabs = retZero
	G.GetSpellTabInfo = retNil
	G.GetItemSpell = retNil
	G.GetNumTalents = retZero
	G.IsEncounterInProgress = retFalse
	G.GetZoneText = function() return "Zone" end
	G.GetSubZoneText = function() return "" end
	G.GetMinimapZoneText = function() return "" end
	G.IsIndoors = retFalse
	G.IsOutdoors = retTrue
	G.GetMouseFocus = retNil
	G.GetCursorPosition = function() return 0, 0 end
	G.GetBindingKey = retNil
	G.GetBindingAction = retNil
	G.SetBinding = retTrue
	G.SaveBindings = noop
	G.GetCurrentBindingSet = function() return 1 end
	G.CombatLogGetCurrentEventInfo = function() return 0, "SPELL_CAST_SUCCESS", false, "", "", 0, 0, "", "", 0, 0, 0, "", 0 end
	G.CombatLogGetCurrentEntry = retNil
	G.GetGameTime = function() return 12, 0 end
	G.GetMaxLevelForPlayerExpansion = function() return 80 end
	G.GetExpansionLevel = function() return 11 end
	G.GetAccountExpansionLevel = function() return 11 end
	G.GetServerExpansionLevel = function() return 11 end
	G.GetLFGMode = retNil
	G.GetActiveSpecGroup = function() return 1 end
	G.GetNumSpecGroups = function() return 1 end

	-- Namespaces
	local function ns(t) return setmetatable(t, { __index = function(_, k) return noop end }) end
	G.C_AddOns = ns({ GetAddOnMetadata = function(name, field) return metadata[field] end, IsAddOnLoaded = retFalse, LoadAddOn = function() return true end, GetAddOnInfo = retNil, EnableAddOn = noop, DisableAddOn = noop, GetNumAddOns = retZero, DoesAddOnExist = retFalse, GetAddOnEnableState = function() return 2 end, IsAddOnLoadOnDemand = retFalse })
	G.C_Timer = ns({
		After = function(delay, fn) timerQueue[#timerQueue + 1] = { delay, fn } end,
		NewTimer = function(delay, fn) local t = { Cancel = noop, IsCancelled = retFalse, __fn = fn } timerQueue[#timerQueue + 1] = { delay, function() fn(t) end } return t end,
		NewTicker = function(delay, fn, iterations) local t = { Cancel = noop, IsCancelled = retFalse } return t end,
	})
	G.C_Spell = ns({
		GetSpellInfo = function(id) if id == nil then return nil end return { name = "Spell" .. tostring(id), iconID = 134400, originalIconID = 134400, castTime = 0, minRange = 0, maxRange = 40, spellID = tonumber(id) or 0 } end,
		GetSpellName = function(id) return "Spell" .. tostring(id) end,
		GetSpellTexture = function() return 134400 end,
		GetSpellDescription = function() return "" end,
		GetSpellLink = function(id) return "|cff71d5ff|Hspell:" .. tostring(id) .. "|h[Spell]|h|r" end,
		GetSpellCooldown = function() return { startTime = 0, duration = 0, isEnabled = true, modRate = 1 } end,
		GetSpellCharges = function() return { currentCharges = 0, maxCharges = 1, cooldownStartTime = 0, cooldownDuration = 0, chargeModRate = 1 } end,
		GetSpellCastCount = retZero,
		GetSpellPowerCost = function() return {} end,
		IsSpellUsable = function() return true, false end,
		IsSpellInRange = retNil,
		EnableSpellRangeCheck = noop,
		DoesSpellExist = retTrue,
		GetOverrideSpell = function(id) return id end,
		GetBaseSpell = function(id) return id end,
		IsSpellHarmful = retFalse,
		IsSpellHelpful = retFalse,
		IsSpellDataCached = retTrue,
		RequestLoadSpellData = noop,
		GetSpellCooldownDuration = retNil,
		GetSpellChargeDuration = retNil,
		GetSpellLossOfControlCooldown = function() return 0, 0 end,
		IsAutoRepeatSpell = retFalse,
		IsCurrentSpell = retFalse,
		GetSpellAutoCast = function() return false, false end,
		GetSpellLevelLearned = retZero,
		GetSchoolString = function() return "Physical" end,
	})
	G.C_SpellBook = ns({ IsSpellKnown = retFalse, IsSpellInSpellBook = retFalse, GetSpellBookItemInfo = retNil, GetNumSpellBookSkillLines = retZero, GetSpellBookSkillLineInfo = retNil, GetSpellBookItemName = retNil, HasPetSpells = retFalse, IsSpellKnownOrOverridesKnown = retFalse, FindSpellBookSlotForSpell = retNil })
	G.C_UnitAuras = ns({ GetPlayerAuraBySpellID = retNil, GetAuraDataByIndex = retNil, GetBuffDataByIndex = retNil, GetDebuffDataByIndex = retNil, GetAuraDataByAuraInstanceID = retNil, GetAuraSlots = retNil, GetAuraDataBySlot = retNil, GetUnitAuraBySpellID = retNil, GetAuraDataBySpellName = retNil, IsAuraFilteredOutByInstanceID = retFalse, GetAuraDurationInfo = retNil, GetCooldownAuraBySpellID = retNil, GetAuraApplicationDisplayCount = retZero, AuraIsPrivate = retFalse })
	G.C_ClassTalents = ns({ GetActiveConfigID = retNil, GetConfigIDsBySpecID = retEmpty, GetLastSelectedSavedConfigID = retNil, GetStarterBuildActive = retFalse, GetHeroTalentSpecsForClassSpec = retNil, GetActiveHeroTalentSpec = retNil })
	G.C_Traits = ns({ GetConfigInfo = retNil, GetTreeNodes = retEmpty, GetNodeInfo = retNil, GetEntryInfo = retNil, GetDefinitionInfo = retNil, GetTreeInfo = retNil, GetSubTreeInfo = retNil, GetTraitSystemFlags = retZero, GetConditionInfo = retNil, GetTreeCurrencyInfo = retEmpty, GetNodeCost = retEmpty })
	-- Exactly the namespace live retail documents (no unknown-method fallback): neither client has GetSpecializationInfoForClassID
	-- or GetSpecializationInfoForSpecID here; those are plain globals on both.
	G.C_SpecializationInfo = { GetAllSelectedPvpTalentIDs = retEmpty, GetSpecialization = function() return 1 end, GetSpecializationInfo = G.GetSpecializationInfo, GetPvpTalentSlotInfo = retNil, GetSpecIDs = retEmpty, CanPlayerUseTalentSpecUI = retTrue, IsInitialized = retTrue, GetActiveSpecGroup = function() return 1 end, GetNumSpecializationsForClassID = G.GetNumSpecializationsForClassID, GetPvpTalentInfo = G.GetPvpTalentInfoByID, GetTalentInfo = retNil, GetClassIDFromSpecID = retNil }
	-- Forever registers a smaller global surface (per the beta probe): these read as nil instead of auto-stubbing for a
	-- 1.x TOC, so a leftover call fails the way it does in that client.
	local absentGlobals = {}
	if interfaceVersion < 20000 then
		for _, name in ipairs({ "GetSpecialization", "GetSpecializationInfo", "GetNumSpecializationsForClassID", "CombatLogGetCurrentEventInfo" }) do
			G[name] = nil
			absentGlobals[name] = true
		end
	end
	G.C_PetBattles = ns({ IsInBattle = retFalse })
	G.C_PlayerInfo = ns({ GetGlidingInfo = function() return false, false, 0 end, IsPlayerNPERestricted = retFalse, GetPlayerCharacterData = retNil, UnitIsSameServer = retTrue, GetClass = function() return classId end, GetRace = function() return 1 end, GetSex = function() return 2 end, IsPlayerInGuildFromGUID = retFalse, GUIDIsPlayer = retTrue, GetContentDifficultyCreatureForPlayer = retNil, GetInstancedContentDifficulty = retNil, IsMercenary = retFalse, CanPlayerEnterChromieTime = retFalse, IsPlayerEligibleForNPE = retFalse, IsConnectionValid = retTrue })
	G.C_CooldownViewer = ns({ GetCooldownViewerCategorySet = retEmpty, GetCooldownViewerCooldownInfo = retNil, IsCooldownViewerAvailable = retTrue, GetCooldownViewerCooldownIDs = retEmpty, GetCooldownViewerCooldownList = retEmpty, GetCooldownInfoForSpellID = retNil, SetCooldownViewerCategorySet = noop })
	G.C_Item = ns({ GetItemInfo = retNil, GetItemIconByID = function() return 134400 end, GetItemIcon = function() return 134400 end, GetDetailedItemLevelInfo = retZero, GetItemInfoInstant = retNil, GetItemNameByID = retNil, GetItemCount = retZero, GetItemCooldown = function() return 0, 0, 1 end, IsEquippedItem = retFalse, DoesItemExist = retFalse, GetItemLink = retNil, GetItemSpell = retNil, IsItemDataCachedByID = retTrue, RequestLoadItemDataByID = noop, GetItemQualityByID = retZero, GetItemInventoryTypeByID = retZero, GetItemClassInfo = retNil, GetItemSubClassInfo = retNil, GetItemSetInfo = retNil, GetItemSpecInfo = retEmpty, IsItemInRange = retNil, GetItemGem = retNil, GetItemStats = retEmpty })
	local curveMeta = { __index = { AddPoint = noop, SetPoints = noop, Evaluate = function() return G.CreateColor(1, 1, 1, 1) end, EvaluateColor = function() return G.CreateColor(1, 1, 1, 1) end, ClearPoints = noop, SetType = noop, GetType = function() return 0 end, GetPoints = retEmpty, GetPointCount = retZero } }
	G.C_CurveUtil = ns({ CreateColorCurve = function() return setmetatable({}, curveMeta) end, CreateCurve = function() return setmetatable({}, curveMeta) end, EvaluateColorFromBoolean = function(b, c1, c2) return b and c1 or c2 end, EvaluateColorFromValue = function(v, curve) return G.CreateColor(1, 1, 1, 1) end, EvaluateColorCurve = function() return G.CreateColor(1, 1, 1, 1) end, CreateColorCurveFromTable = function() return setmetatable({}, curveMeta) end })
	G.C_EditMode = ns({ GetLayouts = function() return { layouts = {}, activeLayout = 1 } end, SaveLayouts = noop, GetAccountSettings = retEmpty, SetAccountSetting = noop, IsEditModeActive = retFalse, OnLayoutAdded = noop, OnLayoutDeleted = noop, ConvertLayoutInfoToString = function() return "" end, ConvertStringToLayoutInfo = retNil, OnEditModeExit = noop })
	G.C_ChatInfo = ns({ SendAddonMessage = retTrue, RegisterAddonMessagePrefix = retTrue, IsAddonMessagePrefixRegistered = retFalse, GetChannelInfoFromIdentifier = retNil })
	G.C_MountJournal = ns({ IsDragonridingUnlocked = retFalse, GetMountFromSpell = retNil, GetMountInfoByID = retNil, GetNumMounts = retZero, GetMountIDs = retEmpty })
	G.C_Map = ns({ GetBestMapForUnit = retNil, GetMapInfo = retNil })
	G.C_Container = ns({ GetContainerNumSlots = retZero, GetContainerItemInfo = retNil, GetContainerItemID = retNil })
	G.C_EquipmentSet = ns({ GetNumEquipmentSets = retZero, GetEquipmentSetIDs = retEmpty })
	G.C_UIWidgetManager = ns({ GetAllWidgetsBySetID = retEmpty, GetPowerBarWidgetSetID = retZero, GetTopCenterWidgetSetID = retZero })
	G.C_Sound = ns({ IsPlaying = retFalse })
	G.C_ChallengeMode = ns({ IsChallengeModeActive = retFalse, GetActiveKeystoneInfo = function() return 0, {}, false end })
	G.C_Scenario = ns({ IsInScenario = retFalse })
	G.C_PvP = ns({ IsWarModeDesired = retFalse, IsArena = retFalse, IsBattleground = retFalse, IsRatedSoloShuffle = retFalse, IsRatedArena = retFalse, IsRatedBattleground = retFalse, IsSoloShuffle = retFalse, IsSoloRBG = retFalse, IsRatedSoloRBG = retFalse })
	G.C_Seasons = ns({ HasActiveSeason = retFalse })
	G.C_Minimap = ns({ GetViewRadius = function() return 200 end, IsRotateMinimapIgnored = retFalse })
	G.C_LFGInfo = ns({ IsInLFGFollowerDungeon = retFalse })
	G.C_LFGList = ns({})
	G.C_MythicPlus = ns({ IsMythicPlusActive = retFalse })
	G.C_DateAndTime = ns({ GetServerTimeLocal = os.time, GetCurrentCalendarTime = function() return { year = 2026, month = 9, monthDay = 16, hour = 12, minute = 0, weekday = 4 } end })
	G.C_CVar = ns({ GetCVar = retNil, GetCVarBool = retFalse, SetCVar = noop, GetCVarDefault = retNil, RegisterCVar = noop })
	G.C_Texture = ns({ GetAtlasInfo = retNil, GetTitleIconTexture = noop })
	G.C_XMLUtil = ns({ GetTemplateInfo = retNil })
	G.C_Widget = ns({ IsFrameWidget = function(f) return type(f) == "table" and getmetatable(f) == frameMeta end, IsWidget = function(f) return type(f) == "table" and getmetatable(f) == frameMeta end })
	G.C_System = ns({ GetFrameStack = retEmpty })
	G.C_GamePad = ns({ IsEnabled = retFalse })
	G.C_Engraving = ns({ IsEngravingEnabled = retFalse })
	G.C_SpellActivationOverlay = ns({})
	G.C_ActionBar = ns({ FindSpellActionButtons = retNil, HasSpellActionButtons = retFalse })
	G.C_TooltipInfo = ns({ GetSpellByID = retNil, GetUnitAura = retNil, GetUnitBuff = retNil, GetUnitDebuff = retNil, GetInventoryItem = retNil, GetItemByID = retNil })
	G.C_UnitAuras.GetAuraDataByIndex = retNil
	G.C_NamePlate = ns({ GetNamePlates = retEmpty, GetNamePlateForUnit = retNil })
	G.C_CreatureInfo = ns({ GetClassInfo = function(id) local c = classes[id] if c then return { className = c[1], classFile = c[2], classID = id } end return nil end, GetRaceInfo = function() return { raceName = "Human", clientFileString = "Human", raceID = 1 } end, GetFactionInfo = function() return { name = "Alliance", groupTag = "Alliance" } end })
	G.C_ClassColor = ns({ GetClassColor = function() return G.CreateColor(1, 1, 1) end })
	G.C_Reputation = ns({})
	G.C_QuestLog = ns({})
	G.C_Garrison = ns({})
	G.C_Covenants = ns({ GetActiveCovenantID = retZero })
	G.C_Soulbinds = ns({ GetActiveSoulbindID = retZero })
	G.C_AzeriteEssence = ns({})
	G.C_AzeriteItem = ns({})
	G.C_AzeriteEmpoweredItem = ns({})
	G.C_Housing = ns({})
	G.C_DelvesUI = ns({})
	G.C_UnitPower = ns({})

	-- LibStub stub: returns permissive library objects
	local libs = {}
	local libMeta = { __index = function(t, k)
		if k == "IsValid" then return retTrue end
		if k == "Fetch" then return function(_, mediatype, key) return "Interface\\Buttons\\WHITE8X8" end end
		if k == "List" then return function() return {} end end
		if k == "HashTable" then return function() return {} end end
		if k == "GetGlobal" then return function() return "" end end
		if k == "GetDefault" then return function() return "" end end
		if k == "NewDataObject" then return function(_, name, def) return def or {} end end
		if k == "GetDataObjectByName" then return retNil end
		if k == "CreateST" then return function() return setmetatable({ frame = newFrame("Frame") }, { __index = function() return noop end }) end end
		if k == "GetMinimapButton" then return function() return newFrame("Button") end end
		if k == "IsRegistered" then return retFalse end
		if k == "GetVersion" then return function() return 1 end end
		-- Library methods are PascalCase; lowercase keys are data fields and read as nil.
		if type(k) == "string" and k:match("^[A-Z]") then
			return noop
		end
		return nil
	end }
	local function getLib(name, silent)
		if not libs[name] then
			libs[name] = setmetatable({ __libName = name, MediaType = { STATUSBAR = "statusbar", BORDER = "border", BACKGROUND = "background", FONT = "font", SOUND = "sound" }, callbacks = setmetatable({}, { __index = function() return noop end }) }, libMeta)
			if name == "LibEditMode-1.0" then
				libs[name].SettingType = { Checkbox = 1, Dropdown = 2, Slider = 3, Divider = 4, CheckboxGroup = 5, ColorPicker = 6 }
				libs[name].frameSelections = {}
			end
			if name == "LibSharedMedia-3.0" then
				local lsm = libs[name]
				lsm.MediaTable = { statusbar = { ["Blizzard"] = "Interface\\TargetingFrame\\UI-StatusBar" }, border = { ["None"] = "Interface\\None", ["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Border" }, background = { ["None"] = "Interface\\None", ["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Background" }, font = { ["Friz Quadrata TT"] = "Fonts\\FRIZQT__.TTF" }, sound = { ["None"] = "Interface\\Quiet.ogg" } }
				lsm.DefaultMedia = { statusbar = "Blizzard", border = "None", background = "None", font = "Friz Quadrata TT", sound = "None" }
				lsm.Register = function(self, mediatype, key, data) self.MediaTable[mediatype] = self.MediaTable[mediatype] or {} self.MediaTable[mediatype][key] = data return true end
				lsm.Fetch = function(self, mediatype, key, noDefault) local t = self.MediaTable[mediatype] or {} return t[key] or (not noDefault and t[self.DefaultMedia[mediatype]]) or nil end
				lsm.IsValid = function(self, mediatype, key) if key == nil then return self.MediaTable[mediatype] ~= nil end return self.MediaTable[mediatype] ~= nil and self.MediaTable[mediatype][key] ~= nil end
				lsm.HashTable = function(self, mediatype) return self.MediaTable[mediatype] or {} end
				lsm.List = function(self, mediatype) local r = {} for k in pairs(self.MediaTable[mediatype] or {}) do r[#r + 1] = k end table.sort(r) return r end
				lsm.GetDefault = function(self, mediatype) return self.DefaultMedia[mediatype] end
				lsm.GetGlobal = function(self, mediatype) return nil end
				lsm.SetGlobal = noop
				lsm.RegisterCallback = noop
				lsm.UnregisterCallback = noop
			end
		end
		return libs[name]
	end
	G.LibStub = setmetatable({ GetLibrary = function(self, name, silent) return getLib(name, silent) end, NewLibrary = function(self, name, ver) return getLib(name), nil end, IterateLibraries = function() return pairs(libs) end, minor = 2 }, { __call = function(self, name, silent) return getLib(name, silent) end })

	-- Saved variables declared by the TOC resolve to nil (first run) or the table provided by the runner.
	local savedVariableNames = {}
	for name in tostring(metadata.SavedVariables or ""):gmatch("[^,%s]+") do savedVariableNames[name] = true end
	for name in tostring(metadata.SavedVariablesPerCharacter or ""):gmatch("[^,%s]+") do savedVariableNames[name] = true end
	G.__harness.savedVariableNames = savedVariableNames
	if opts.savedVariables then
		for name, value in pairs(opts.savedVariables) do rawset(G, name, value) end
	end

	-- Unknown-global fallback
	setmetatable(G, {
		__index = function(t, k)
			if type(k) ~= "string" then return nil end
			if savedVariableNames[k] or absentGlobals[k] then return nil end
			if k == "arg" or k == "_PROMPT" or k == "_PROMPT2" then return nil end
			unknownGlobals[k] = (unknownGlobals[k] or 0) + 1
			if k:match("^[A-Z][A-Z0-9_]+$") then
				return k -- Blizzard global string
			end
			return stub(k)
		end,
	})

	return G
end

-- Event firing -----------------------------------------------------------------------------------
local function runTimers()
	local ran = 0
	local guard = 0
	while #timerQueue > 0 and guard < 10000 do
		guard = guard + 1
		local entry = table.remove(timerQueue, 1)
		local ok, err = xpcall(entry[2], function(e) return debug.traceback(tostring(e), 2) end)
		if not ok then
			print("TIMER ERROR\n    " .. tostring(err):gsub("\n", "\n    "))
			return ran, 1
		end
		ran = ran + 1
	end
	return ran, 0
end

function M.fireEvents(spec, addonName)
	local failures = 0
	local timerFailures = 0
	for evName in spec:gmatch("[^,]+") do
		local event, argsSpec = evName:match("^([^:]+):?(.*)$")
		local args = {}
		if event == "ADDON_LOADED" then args = { addonName }
		elseif event == "PLAYER_SPECIALIZATION_CHANGED" then args = { "player" }
		elseif event == "PLAYER_ENTERING_WORLD" then args = { true, false }
		elseif argsSpec and argsSpec ~= "" then
			for a in argsSpec:gmatch("[^;]+") do args[#args + 1] = tonumber(a) or a end
		end
		local handled = 0
		for _, f in ipairs(frames) do
			local fn = f.__scripts.OnEvent
			if fn and (f.__events[event] or next(f.__events) == nil and false) then
				handled = handled + 1
				local ok, err = xpcall(function() fn(f, event, unpack(args)) end, function(e) return debug.traceback(tostring(e), 2) end)
				if not ok then
					failures = failures + 1
					print("EVENT ERROR " .. event .. " (frame " .. tostring(f.__name) .. ")\n    " .. tostring(err):gsub("\n", "\n    "))
				end
			end
		end
		local ran, tfail = runTimers()
		timerFailures = timerFailures + tfail
		print(string.format("Fired %s -> %d handlers, %d timers, %d handler failures, %d timer failures", event, handled, ran, failures, timerFailures))
	end
	return failures, timerFailures
end

function M.finish()
	local names = {}
	for k in pairs(unknownGlobals) do names[#names + 1] = k end
	table.sort(names)
	if #names > 0 then
		print("Unknown globals touched (" .. #names .. "): " .. table.concat(names, ", "))
	end
end

return M
