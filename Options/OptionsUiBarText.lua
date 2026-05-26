---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = TRB.Functions.OptionsUi or {}
TRB.Functions.OptionsUi.BarText = TRB.Functions.OptionsUi.BarText or {}
local oUi = TRB.Data.constants.optionsUi
local L = TRB.Localization

---Returns the RGB color values used for "Use Global Settings" checkbox label text.
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/225
end

-- ============================================================================
-- Bar text editor options
-- ============================================================================

-- Bar text variables side panel lives in Options\OptionsUiBarTextVariables.lua.
function TRB.Functions.OptionsUi.BarText:CreateVariablesSidePanel(...)
	return TRB.Functions.OptionsUi.BarTextVariables:CreateVariablesSidePanel(...)
end

-- Bar text input panel lives in Options\OptionsUiBarTextInput.lua.
function TRB.Functions.OptionsUi.BarText:CreateBarTextInputPanel(...)
	return TRB.Functions.OptionsUi.BarTextInput:CreateBarTextInputPanel(...)
end

-- Delete-bar-text confirmation dialog.  Defined once (outside GenerateBarTextEditor)
-- so that every spec shares a single dialog whose OnAccept works entirely from the
-- per-invocation data payload â€” no closure references to the wrong spec's locals.
StaticPopupDialogs["TwintopResourceBar_ConfirmDeleteBarText"] = {
	text = "",
	button1 = L["Yes"],
	button2 = L["No"],
	OnShow = function(self, data)
		self:SetFormattedText(data.message)
		self.data = data
	end,
	OnAccept = function(self)
		local d = self.data
		d.btt:SetSelection()
		table.remove(d.displayText.barText, d.row)
		d.setTableValues(d.displayText, d.btt)
		-- Refresh the active spec's merged bar text list when global bar text is in use
		if d.classId == nil then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		elseif d.classId == TRB.Data.character.classId and d.specId == TRB.Data.character.specId then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		end
		if d.classId == nil or (d.classId == TRB.Data.character.classId and d.specId == TRB.Data.character.specId) then
			TRB.Data.cache.barText = {}
			TRB.Functions.BarText:ClearBarTextCacheHash()
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			TRB.Data.activeVariables = nil
			TRB.Data.lookupDirty = true
		end
		TRB.Functions.BarText:CreateBarTextFrames(d.classId, d.specId)
		d.barTextOptionsFrame:Hide()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
}

---Generates the bar text editor panel, including the scrolling table of bar text entries, add/delete controls, and per-entry editing fields for font, position, and text content.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing displayText configuration
---@param classId integer? The class ID, or nil for global bar text settings
---@param specId integer? The spec ID, or nil for global bar text settings
---@param yCoord number The current Y coordinate for layout positioning
---@param cache table The bar text variables cache used for the side panel
function TRB.Functions.OptionsUi.BarText:GenerateBarTextEditor(parent, controls, spec, classId, specId, yCoord, cache)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	-- specCache keys use lowercase class names (e.g. "priest_discipline"), but
	-- GetClassAndSpecializationNames without lowerCaseClass returns UPPERCASE (e.g. "PRIEST").
	-- Use the lowercase form for specCache lookups so ResetTableValues actually updates the runtime cache.
	local compositeKey = TRB.Functions.Character:GetCompositeKey(string.lower(className), specName)
	local namePrefix = className .. "_" .. specName .. "_barTextEditor"
	local title = ""
	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	-- Per-spec "Use Global Bar Text" checkbox (skip for the global panel itself)
	if classId ~= nil and specId ~= nil then
		local lowerClassName = string.lower(className)
		controls.checkBoxes = controls.checkBoxes or {}
		controls.checkBoxes.useGlobalBarText = CreateFrame("CheckButton", "TwintopResourceBar_" .. className .. "_" .. specName .. "_useGlobal_globalBarText", parent, "ChatConfigCheckButtonTemplate")
		local f = controls.checkBoxes.useGlobalBarText
		f:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobalBarText"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi.GlobalSettings:BuildUseGlobalShortcutLink(f, "barText")
		f.tooltip = L["CheckboxUseGlobalTooltip_GlobalBarText"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].globalBarText)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].globalBarText = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Data.cache.barText = {}
			TRB.Functions.BarText:ClearBarTextCacheHash()
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			TRB.Data.activeVariables = nil
			TRB.Functions.BarText:Hide(spec)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
			TRB.Functions.OptionsUi.GlobalSettings:RefreshBulkGlobalToggleCheckbox("globalBarText")
		end)
		yCoord = yCoord - 20
	else
		yCoord = yCoord + 10 -- Fix offset
		yCoord = TRB.Functions.OptionsUi.GlobalSettings:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllGlobalBarText", "globalBarText", yCoord, L["GlobalBarTextBulkToggleLabel"], L["GlobalBarTextBulkToggleTooltip"])
		yCoord = yCoord - 20
	end

	local columns = {
		{
			["name"] = "GUID",
			["width"] = 1,
			["align"] = "CENTER"
		},
		{
			["name"] = "Name",
			["width"] = 100,
			["align"] = "LEFT",
			--[[["color"] = {
				["r"] = 0.5,
				["g"] = 0.5,
				["b"] = 1.0,
				["a"] = 1.0
			},
			["colorargs"] = nil,
			["bgcolor"] = {
				["r"] = 1.0,
				["g"] = 0.0,
				["b"] = 0.0,
				["a"] = 1.0
			}, -- red backgrounds, eww!
			["defaultsort"] = "dsc",
			["sortnext"]= 4,
			["comparesort"] = function (cella, cellb, column)
				return cella.value < cellb.value;
			end,
			["DoCellUpdate"] = nil,]]
		},
		{
			["name"] = "Bound To",
			["width"] = 150,
			["align"] = "LEFT"
		},
		{
			["name"] = "Bar Text",
			["width"] = 320,
			["align"] = "LEFT"
		},
		{
			["name"] = "",
			["width"] = 15,--260,
			["align"] = "CENTER",
			["color"] = {
				["r"] = 1,
				["g"] = 0,
				["b"] = 0,
				["a"] = 1,
			}
		}
	}

	---@type TRB.Classes.Settings.DisplayTextEntry
	---@diagnostic disable-next-line: missing-fields
	local workingBarText = {}
	local RefreshBarTextTable

	---@param barTextEntry TRB.Classes.Settings.DisplayTextEntry|table|nil
	---@return string
	local function NormalizeBarTextEntryColor(barTextEntry)
		if barTextEntry == nil then
			return "FFFFFFFF"
		end

		if type(barTextEntry.color) == "table" then
			barTextEntry.color.color = barTextEntry.color.color or "FFFFFFFF"
			return barTextEntry.color.color
		end

		if type(barTextEntry.color) == "string" and barTextEntry.color ~= "" then
			local legacyColor = barTextEntry.color
			local mutableBarTextEntry = barTextEntry --[[@as table<string, any>]]
			mutableBarTextEntry.color = { color = legacyColor }
			return mutableBarTextEntry.color.color
		end

		local mutableBarTextEntry = barTextEntry --[[@as table<string, any>]]
		mutableBarTextEntry.color = { color = "FFFFFFFF" }
		return mutableBarTextEntry.color.color
	end

	local function GetActiveBarTextPreviewIndex()
		local activeClassId = TRB.Data.character.classId
		local activeSpecId = TRB.Data.character.specId
		local activeCompositeKey = TRB.Data.character.compositeKey
		if activeClassId == nil or activeSpecId == nil or activeCompositeKey == nil then
			return nil
		end

		local shouldPreviewActiveSpec = false
		if classId == activeClassId and specId == activeSpecId then
			shouldPreviewActiveSpec = true
		elseif classId == nil and specId == nil then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			shouldPreviewActiveSpec = charClassName ~= nil and charSpecName ~= nil and
				TRB.Data.settings.core.global[charClassName] ~= nil and
				TRB.Data.settings.core.global[charClassName][charSpecName] ~= nil and
				TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText == true
		end

		if not shouldPreviewActiveSpec or workingBarText == nil or workingBarText.guid == nil then
			return nil
		end

		local activeSettings = TRB.Data.specCache[activeCompositeKey] and TRB.Data.specCache[activeCompositeKey].settings
		local activeBarText = activeSettings and activeSettings.displayText and activeSettings.displayText.barText
		if activeBarText == nil then
			return nil
		end

		for i = 1, #activeBarText do
			if activeBarText[i].guid == workingBarText.guid then
				return i
			end
		end

		return nil
	end

	local function RefreshBarTextEditorPreview(forceRebuild)
		local previewIndex = GetActiveBarTextPreviewIndex()
		if previewIndex == nil then
			return
		end

		if not forceRebuild then
			if TRB.Functions.BarText:RepositionBarTextEntry(previewIndex, TRB.Data.character.classId, TRB.Data.character.specId) then
				return
			end
		end

		TRB.Functions.BarText:CreateBarTextFrames(TRB.Data.character.classId, TRB.Data.character.specId)
		TRB.Functions.BarText:InvalidateLookupMemoization()
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end

	controls.barTextContainer = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	local btc = controls.barTextContainer

	btc:SetPoint("TOPLEFT", parent, "TOPLEFT", oUi.xCoord, yCoord)
	btc:SetPoint("RIGHT", parent, "RIGHT", -oUi.xCoord, 0)
	btc:SetHeight(120)

	yCoord = yCoord - 105
	local btoHeight = 550
	local barTextTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, 5, 15, nil, btc, false, false)

	-- Dynamically resize "Bar Text" column (index 4) to fill available width
	btc:HookScript("OnSizeChanged", function(self, w, h)
		local fixedWidth = columns[1].width + columns[2].width + columns[3].width + columns[5].width
		local newBarTextWidth = math.max(200, w - fixedWidth - 30) -- 30 for internal padding/scrollbar
		columns[4].width = newBarTextWidth
		barTextTable:SetDisplayCols(columns)
	end)

	local addButton = TRB.Functions.OptionsUi.Primitives:BuildButton(parent, L["AddNewBarTextArea"], 0, 0, 175, 25)

	local barTextOptionsFrame = CreateFrame("Frame", "TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame", parent, "BackdropTemplate")
	barTextOptionsFrame:SetPoint("TOPLEFT", btc, "BOTTOMLEFT", 0, -10)
	barTextOptionsFrame:SetPoint("TOPRIGHT", btc, "BOTTOMRIGHT", 0, -10)
	barTextOptionsFrame:SetHeight(btoHeight)
	barTextOptionsFrame:Hide()

	-- Place addButton in the same row as Name / Enabled, anchored to top-right of barTextOptionsFrame
	addButton:ClearAllPoints()
	addButton:SetPoint("TOPRIGHT", barTextOptionsFrame, "TOPRIGHT", -5, 5)

	local oldYCoord = yCoord - btoHeight

	yCoord = 0

	local barTextName = TRB.Functions.OptionsUi.Primitives:BuildTextBox(barTextOptionsFrame, "", 200, 300, 20, oUi.xCoord, yCoord)
---@diagnostic disable-next-line: inject-field
	barTextName.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["Name"], oUi.xCoord, yCoord+25)
	barTextName.label.font:SetFontObject(GameFontNormal)

	local barTextEntryEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_TextEnabled", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	barTextEntryEnabled:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(barTextEntryEnabled:GetName() .. 'Text'):SetText(L["Enabled"])
---@diagnostic disable-next-line: inject-field
	barTextEntryEnabled.tooltip = L["BarTextEntryEnabledTooltip"]

	yCoord = yCoord - 30
	controls.labels = controls.labels or {}
	controls.labels.barText = TRB.Functions.OptionsUi.Primitives:BuildLabel(barTextOptionsFrame, L["BarText"], oUi.xCoord, yCoord, 90, 20)

	yCoord = yCoord - 20
	local barText = TRB.Functions.OptionsUi.BarTextInput:CreateBarTextInputPanel(barTextOptionsFrame, namePrefix .. "_Text", "",
											590, 45, oUi.xCoord, yCoord)
	local barTextScrollFrame = barText:GetParent() --[[@as Frame]]
	barTextScrollFrame:ClearAllPoints()
	barTextScrollFrame:SetPoint("TOPLEFT", barTextOptionsFrame, "TOPLEFT", oUi.xCoord, yCoord)
	barTextScrollFrame:SetPoint("RIGHT", barTextOptionsFrame, "RIGHT", -30, 0)
	barText:SetCursorPosition(0)

	barTextOptionsFrame:HookScript("OnShow", function()
		TRB.Frames.activeBarTextEditBox = barText
		TRB.Frames.activeBarTextCursorPosition = barText:GetCursorPosition()
		if TRB.Frames.barTextVariablesPanel and TRB.Frames.barTextVariablesPanel.variablesTable then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end)

	barTextOptionsFrame:HookScript("OnHide", function()
		TRB.Frames.activeBarTextEditBox = nil
		TRB.Frames.activeBarTextCursorPosition = nil
		if TRB.Frames.barTextVariablesPanel and TRB.Frames.barTextVariablesPanel.variablesTable then
			TRB.Frames.barTextVariablesPanel.variablesTable:Refresh()
		end
	end)

	yCoord = yCoord - 75
	title = L["HorizontalOffset"]
	local barTextHorizontal = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxWidth), math.floor(sanityCheckValues.barMaxWidth), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	barTextHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		workingBarText.position.xPos = value
		RefreshBarTextEditorPreview(false)
	end)
	controls.barTextHorizontal = barTextHorizontal

	title = L["VerticalOffset"]
	local barTextVertical = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxHeight), math.floor(sanityCheckValues.barMaxHeight), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	barTextVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		workingBarText.position.yPos = value
		RefreshBarTextEditorPreview(false)
	end)
	controls.barTextVertical = barTextVertical

	yCoord = yCoord - 40
	local barTextRelativeToFrame = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeToFrame", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeToFrame:SetWidth(oUi.sliderWidth)
	barTextRelativeToFrame.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["BoundToBar"], oUi.xCoord, yCoord)
	barTextRelativeToFrame.label.font:SetFontObject(GameFontNormal)

	local relativeToFrame = {}
	relativeToFrame[L["MainResourceBar"]] = "Resource"
	relativeToFrame[L["HealthBar"]] = "HealthBar"
	relativeToFrame[L["Screen"]] = "UIParent"
	local relativeToFrameList = {
		L["MainResourceBar"],
		L["HealthBar"],
		L["Screen"],
	}

	if classId == nil then -- Global Bar Text
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 1 and specId == 2) then -- Fury Warrior
		relativeToFrame[L["WhirlwindCharge1"]] = "Whirlwind_Charge_1"
		relativeToFrame[L["WhirlwindCharge2"]] = "Whirlwind_Charge_2"
		relativeToFrame[L["WhirlwindCharge3"]] = "Whirlwind_Charge_3"
		relativeToFrame[L["WhirlwindCharge4"]] = "Whirlwind_Charge_4"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["WhirlwindCharge1"],
			L["WhirlwindCharge2"],
			L["WhirlwindCharge3"],
			L["WhirlwindCharge4"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 1 and specId == 3) then -- Protection Warrior
		relativeToFrame[L["IgnorePainTime"]] = "IgnorePain"
		relativeToFrame[L["IgnorePainAbsorb"]] = "IgnorePainAbsorb"
		relativeToFrame[L["ShieldBlock"]] = "ShieldBlock"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["IgnorePainTime"],
			L["IgnorePainAbsorb"],
			L["ShieldBlock"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 2) then -- Paladin
		relativeToFrame[L["HolyPower1"]] = "ComboPoint_1"
		relativeToFrame[L["HolyPower2"]] = "ComboPoint_2"
		relativeToFrame[L["HolyPower3"]] = "ComboPoint_3"
		relativeToFrame[L["HolyPower4"]] = "ComboPoint_4"
		relativeToFrame[L["HolyPower5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["HolyPower1"],
			L["HolyPower2"],
			L["HolyPower3"],
			L["HolyPower4"],
			L["HolyPower5"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 3 and specId == 3) then -- Survival Hunter
		relativeToFrame[L["TipOfTheSpear1"]] = "ComboPoint_1"
		relativeToFrame[L["TipOfTheSpear2"]] = "ComboPoint_2"
		relativeToFrame[L["TipOfTheSpear3"]] = "ComboPoint_3"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["TipOfTheSpear1"],
			L["TipOfTheSpear2"],
			L["TipOfTheSpear3"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 1) then -- Assassination Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 2) then -- Outlaw Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrame[L["ComboPoint7"]] = "ComboPoint_7"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["ComboPoint7"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 4 and specId == 3) then -- Subtlety Rogue
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ComboPoint6"]] = "ComboPoint_6"
		relativeToFrame[L["ComboPoint7"]] = "ComboPoint_7"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ComboPoint6"],
			L["ComboPoint7"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 5 and specId == 1) then -- Discipline Priest
		relativeToFrame[L["PowerWordRadianceCharge1"]] = "PowerWord_Radiance_1"
		relativeToFrame[L["PowerWordRadianceCharge2"]] = "PowerWord_Radiance_2"
		relativeToFrame[L["AngelicFeatherCharge1"]] = "Angelic_Feather_Charge_1"
		relativeToFrame[L["AngelicFeatherCharge2"]] = "Angelic_Feather_Charge_2"
		relativeToFrame[L["AngelicFeatherCharge3"]] = "Angelic_Feather_Charge_3"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["PowerWordRadianceCharge1"],
			L["PowerWordRadianceCharge2"],
			L["AngelicFeatherCharge1"],
			L["AngelicFeatherCharge2"],
			L["AngelicFeatherCharge3"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 5 and specId == 2) then -- Holy Priest
		relativeToFrame[L["HolyWordSerenityCharge1"]] = "HolyWord_Serenity_1"
		relativeToFrame[L["HolyWordSerenityCharge2"]] = "HolyWord_Serenity_2"
		relativeToFrame[L["HolyWordSanctifyCharge1"]] = "HolyWord_Sanctify_1"
		relativeToFrame[L["HolyWordSanctifyCharge2"]] = "HolyWord_Sanctify_2"
		relativeToFrame[L["HolyWordChastiseCharge1"]] = "HolyWord_Chastise_1"
		relativeToFrame[L["LightweaverCharge1"]] = "Lightweaver_Charge_1"
		relativeToFrame[L["LightweaverCharge2"]] = "Lightweaver_Charge_2"
		relativeToFrame[L["LightweaverCharge3"]] = "Lightweaver_Charge_3"
		relativeToFrame[L["LightweaverCharge4"]] = "Lightweaver_Charge_4"
		relativeToFrame[L["AngelicFeatherCharge1"]] = "Angelic_Feather_Charge_1"
		relativeToFrame[L["AngelicFeatherCharge2"]] = "Angelic_Feather_Charge_2"
		relativeToFrame[L["AngelicFeatherCharge3"]] = "Angelic_Feather_Charge_3"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["HolyWordSerenityCharge1"],
			L["HolyWordSerenityCharge2"],
			L["HolyWordSanctifyCharge1"],
			L["HolyWordSanctifyCharge2"],
			L["HolyWordChastiseCharge1"],
			L["LightweaverCharge1"],
			L["LightweaverCharge2"],
			L["LightweaverCharge3"],
			L["LightweaverCharge4"],
			L["AngelicFeatherCharge1"],
			L["AngelicFeatherCharge2"],
			L["AngelicFeatherCharge3"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 5 and specId == 3) then -- Shadow Priest (mana bar support)
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrame[L["AngelicFeatherCharge1"]] = "Angelic_Feather_Charge_1"
		relativeToFrame[L["AngelicFeatherCharge2"]] = "Angelic_Feather_Charge_2"
		relativeToFrame[L["AngelicFeatherCharge3"]] = "Angelic_Feather_Charge_3"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ManaBar"],
			L["AngelicFeatherCharge1"],
			L["AngelicFeatherCharge2"],
			L["AngelicFeatherCharge3"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 6 and specId == 1) then -- Blood Death Knight
		relativeToFrame[L["Rune1"]] = "ComboPoint_1"
		relativeToFrame[L["Rune2"]] = "ComboPoint_2"
		relativeToFrame[L["Rune3"]] = "ComboPoint_3"
		relativeToFrame[L["Rune4"]] = "ComboPoint_4"
		relativeToFrame[L["Rune5"]] = "ComboPoint_5"
		relativeToFrame[L["Rune6"]] = "ComboPoint_6"
		relativeToFrame[L["BoneShield1"]] = "BoneShield_1"
		relativeToFrame[L["BoneShield2"]] = "BoneShield_2"
		relativeToFrame[L["BoneShield3"]] = "BoneShield_3"
		relativeToFrame[L["BoneShield4"]] = "BoneShield_4"
		relativeToFrame[L["BoneShield5"]] = "BoneShield_5"
		relativeToFrame[L["BoneShield6"]] = "BoneShield_6"
		relativeToFrame[L["BoneShield7"]] = "BoneShield_7"
		relativeToFrame[L["BoneShield8"]] = "BoneShield_8"
		relativeToFrame[L["BoneShield9"]] = "BoneShield_9"
		relativeToFrame[L["BoneShield10"]] = "BoneShield_10"
		relativeToFrame[L["BoneShield11"]] = "BoneShield_11"
		relativeToFrame[L["BoneShield12"]] = "BoneShield_12"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Rune1"],
			L["Rune2"],
			L["Rune3"],
			L["Rune4"],
			L["Rune5"],
			L["Rune6"],
			L["BoneShield1"],
			L["BoneShield2"],
			L["BoneShield3"],
			L["BoneShield4"],
			L["BoneShield5"],
			L["BoneShield6"],
			L["BoneShield7"],
			L["BoneShield8"],
			L["BoneShield9"],
			L["BoneShield10"],
			L["BoneShield11"],
			L["BoneShield12"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 6) then -- Frost / Unholy Death Knight
		relativeToFrame[L["Rune1"]] = "ComboPoint_1"
		relativeToFrame[L["Rune2"]] = "ComboPoint_2"
		relativeToFrame[L["Rune3"]] = "ComboPoint_3"
		relativeToFrame[L["Rune4"]] = "ComboPoint_4"
		relativeToFrame[L["Rune5"]] = "ComboPoint_5"
		relativeToFrame[L["Rune6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Rune1"],
			L["Rune2"],
			L["Rune3"],
			L["Rune4"],
			L["Rune5"],
			L["Rune6"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 7 and specId == 1) then -- Elemental Shaman (mana bar support)
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ManaBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 7 and specId == 2) then -- Enhancement Shaman
		relativeToFrame[L["Maelstrom1"]] = "ComboPoint_1"
		relativeToFrame[L["Maelstrom2"]] = "ComboPoint_2"
		relativeToFrame[L["Maelstrom3"]] = "ComboPoint_3"
		relativeToFrame[L["Maelstrom4"]] = "ComboPoint_4"
		relativeToFrame[L["Maelstrom5"]] = "ComboPoint_5"
		relativeToFrame[L["Maelstrom6"]] = "ComboPoint_6"
		relativeToFrame[L["Maelstrom7"]] = "ComboPoint_7"
		relativeToFrame[L["Maelstrom8"]] = "ComboPoint_8"
		relativeToFrame[L["Maelstrom9"]] = "ComboPoint_9"
		relativeToFrame[L["Maelstrom10"]] = "ComboPoint_10"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Maelstrom1"],
			L["Maelstrom2"],
			L["Maelstrom3"],
			L["Maelstrom4"],
			L["Maelstrom5"],
			L["Maelstrom6"],
			L["Maelstrom7"],
			L["Maelstrom8"],
			L["Maelstrom9"],
			L["Maelstrom10"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 8 and specId == 1) then -- Arcane Mage
		relativeToFrame[L["ArcaneCharge1"]] = "ComboPoint_1"
		relativeToFrame[L["ArcaneCharge2"]] = "ComboPoint_2"
		relativeToFrame[L["ArcaneCharge3"]] = "ComboPoint_3"
		relativeToFrame[L["ArcaneCharge4"]] = "ComboPoint_4"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["ArcaneCharge1"],
			L["ArcaneCharge2"],
			L["ArcaneCharge3"],
			L["ArcaneCharge4"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 8 and specId == 2) then -- Fire Mage
		relativeToFrame[L["MageFireBlastCharges"]] = "FireBlastChargesBar"
		relativeToFrame[L["MageFireFireBlastCharge1"]] = "FireBlastCharge_1"
		relativeToFrame[L["MageFireFireBlastCharge2"]] = "FireBlastCharge_2"
		relativeToFrame[L["MageFireFireBlastCharge3"]] = "FireBlastCharge_3"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["MageFireBlastCharges"],
			L["MageFireFireBlastCharge1"],
			L["MageFireFireBlastCharge2"],
			L["MageFireFireBlastCharge3"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif(classId == 8 and specId == 3) then -- Frost Mage
		relativeToFrame[L["Icicle1"]] = "ComboPoint_1"
		relativeToFrame[L["Icicle2"]] = "ComboPoint_2"
		relativeToFrame[L["Icicle3"]] = "ComboPoint_3"
		relativeToFrame[L["Icicle4"]] = "ComboPoint_4"
		relativeToFrame[L["Icicle5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Icicle1"],
			L["Icicle2"],
			L["Icicle3"],
			L["Icicle4"],
			L["Icicle5"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 9) then -- Warlock
		relativeToFrame[L["SoulShard1"]] = "ComboPoint_1"
		relativeToFrame[L["SoulShard2"]] = "ComboPoint_2"
		relativeToFrame[L["SoulShard3"]] = "ComboPoint_3"
		relativeToFrame[L["SoulShard4"]] = "ComboPoint_4"
		relativeToFrame[L["SoulShard5"]] = "ComboPoint_5"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulShard1"],
			L["SoulShard2"],
			L["SoulShard3"],
			L["SoulShard4"],
			L["SoulShard5"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 10 and specId == 1) then -- Brewmaster Monk
		relativeToFrame[L["Stagger"]] = "ComboPoint_1"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Stagger"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 10 and specId == 3) then -- Windwalker Monk
		relativeToFrame[L["Chi1"]] = "ComboPoint_1"
		relativeToFrame[L["Chi2"]] = "ComboPoint_2"
		relativeToFrame[L["Chi3"]] = "ComboPoint_3"
		relativeToFrame[L["Chi4"]] = "ComboPoint_4"
		relativeToFrame[L["Chi5"]] = "ComboPoint_5"
		relativeToFrame[L["Chi6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Chi1"],
			L["Chi2"],
			L["Chi3"],
			L["Chi4"],
			L["Chi5"],
			L["Chi6"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 11 and specId == 1) then -- Balance Druid (mana bar support)
		relativeToFrame[L["AstralPowerBar"]] = "AstralPowerBar"
		relativeToFrame[L["RageBar"]] = "RageBar"
		relativeToFrame[L["EnergyBar"]] = "EnergyBar"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["AstralPowerBar"],
			L["RageBar"],
			L["EnergyBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ManaBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 11 and specId > 1 and specId <= 4) then -- Non-Balance Druid
		relativeToFrame[L["RageBar"]] = "RageBar"
		relativeToFrame[L["EnergyBar"]] = "EnergyBar"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint1"]] = "ComboPoint_1"
		relativeToFrame[L["ComboPoint2"]] = "ComboPoint_2"
		relativeToFrame[L["ComboPoint3"]] = "ComboPoint_3"
		relativeToFrame[L["ComboPoint4"]] = "ComboPoint_4"
		relativeToFrame[L["ComboPoint5"]] = "ComboPoint_5"
		relativeToFrame[L["ManaBar"]] = "ManaBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["RageBar"],
			L["EnergyBar"],
			L["ComboPoint1"],
			L["ComboPoint2"],
			L["ComboPoint3"],
			L["ComboPoint4"],
			L["ComboPoint5"],
			L["ManaBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 12 and specId == 2) then -- Vengeance Demon Hunter
		relativeToFrame[L["SoulFragment1"]] = "ComboPoint_1"
		relativeToFrame[L["SoulFragment2"]] = "ComboPoint_2"
		relativeToFrame[L["SoulFragment3"]] = "ComboPoint_3"
		relativeToFrame[L["SoulFragment4"]] = "ComboPoint_4"
		relativeToFrame[L["SoulFragment5"]] = "ComboPoint_5"
		relativeToFrame[L["SoulFragment6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulFragment1"],
			L["SoulFragment2"],
			L["SoulFragment3"],
			L["SoulFragment4"],
			L["SoulFragment5"],
			L["SoulFragment6"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 12 and specId == 3) then -- Devourer Demon Hunter
		relativeToFrame[L["SoulFragments"]] = "ComboPoint_1"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["SoulFragments"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 13 and specId == 3) then -- Augmentation Evoker
		relativeToFrame[L["Essence1"]] = "ComboPoint_1"
		relativeToFrame[L["Essence2"]] = "ComboPoint_2"
		relativeToFrame[L["Essence3"]] = "ComboPoint_3"
		relativeToFrame[L["Essence4"]] = "ComboPoint_4"
		relativeToFrame[L["Essence5"]] = "ComboPoint_5"
		relativeToFrame[L["Essence6"]] = "ComboPoint_6"
		relativeToFrame[L["EbonMightBar"]] = "EbonMightBar"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Essence1"],
			L["Essence2"],
			L["Essence3"],
			L["Essence4"],
			L["Essence5"],
			L["Essence6"],
			L["EbonMightBar"],
			L["HealthBar"],
			L["Screen"],
		}
	elseif (classId == 13) then -- Evoker
		relativeToFrame[L["Essence1"]] = "ComboPoint_1"
		relativeToFrame[L["Essence2"]] = "ComboPoint_2"
		relativeToFrame[L["Essence3"]] = "ComboPoint_3"
		relativeToFrame[L["Essence4"]] = "ComboPoint_4"
		relativeToFrame[L["Essence5"]] = "ComboPoint_5"
		relativeToFrame[L["Essence6"]] = "ComboPoint_6"
		relativeToFrameList = {
			L["MainResourceBar"],
			L["Essence1"],
			L["Essence2"],
			L["Essence3"],
			L["Essence4"],
			L["Essence5"],
			L["Essence6"],
			L["HealthBar"],
			L["Screen"],
		}
	end

	local containerAnchorOptions = TRB.Functions.BarText:GetContainerAnchorOptions(classId, specId)
	if #containerAnchorOptions > 0 then
		for _, containerAnchor in ipairs(containerAnchorOptions) do
			local insertIndex = math.max(#relativeToFrameList, 1)
			if #relativeToFrameList >= 2 then
				insertIndex = #relativeToFrameList - 1
			end

			if containerAnchor.insertBeforeLabel ~= nil then
				for i, label in ipairs(relativeToFrameList) do
					if label == containerAnchor.insertBeforeLabel then
						insertIndex = i
						break
					end
				end
			end

			relativeToFrame[containerAnchor.label] = containerAnchor.id
			table.insert(relativeToFrameList, insertIndex, containerAnchor.label)
		end
	end

	local function RelativeToFrameIsSelected(value)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			return value == workingBarText.position.relativeToFrame
		else
			return false
		end
	end

	local function RelativeToFrameSetSelected(newValue)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			workingBarText.position.relativeToFrame = newValue

			for k, v in pairs(relativeToFrame) do
				if v == newValue then
					workingBarText.position.relativeToFrameName = k
				end
			end
			barTextRelativeToFrame:SetDefaultText(workingBarText.position.relativeToFrameName)
			if RefreshBarTextTable ~= nil then
				RefreshBarTextTable()
			end
			RefreshBarTextEditorPreview(false)
		end
	end

	local function RelativeToFrameGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToFrameList) do
			rootDescription:CreateRadio(v, RelativeToFrameIsSelected, RelativeToFrameSetSelected, relativeToFrame[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
	barTextRelativeToFrame:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	local barTextRelativeTo = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeTo", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeTo:SetWidth(oUi.sliderWidth)
	barTextRelativeTo.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
	barTextRelativeTo.label.font:SetFontObject(GameFontNormal)

	local relativeTo = {}
	relativeTo[L["PositionTopLeft"]] = "TOPLEFT"
	relativeTo[L["PositionTop"]] = "TOP"
	relativeTo[L["PositionTopRight"]] = "TOPRIGHT"
	relativeTo[L["PositionLeft"]] = "LEFT"
	relativeTo[L["PositionCenter"]] = "CENTER"
	relativeTo[L["PositionRight"]] = "RIGHT"
	relativeTo[L["PositionBottomLeft"]] = "BOTTOMLEFT"
	relativeTo[L["PositionBottom"]] = "BOTTOM"
	relativeTo[L["PositionBottomRight"]] = "BOTTOMRIGHT"
	local relativeToList = {
		L["PositionTopLeft"],
		L["PositionTop"],
		L["PositionTopRight"],
		L["PositionLeft"],
		L["PositionCenter"],
		L["PositionRight"],
		L["PositionBottomLeft"],
		L["PositionBottom"],
		L["PositionBottomRight"]
	}

	local function RelativeToIsSelected(value)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			return value == workingBarText.position.relativeTo
		else
			return false
		end
	end

	local function RelativeToSetSelected(newValue)
		if workingBarText ~= nil and workingBarText.position ~= nil then
			workingBarText.position.relativeTo = newValue

			for k, v in pairs(relativeTo) do
				if v == newValue then
					workingBarText.position.relativeToName = k
				end
			end
			barTextRelativeTo:SetDefaultText(workingBarText.position.relativeToName)
			RefreshBarTextEditorPreview(false)
		end
	end

	local function RelativeToGenerator(dropdown, rootDescription)
		for k, v in pairs(relativeToList) do
			rootDescription:CreateRadio(v, RelativeToIsSelected, RelativeToSetSelected, relativeTo[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextRelativeTo:SetupMenu(RelativeToGenerator)
	barTextRelativeTo:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)

	yCoord = yCoord - 60

	controls.colors.text = controls.colors.text or {}

	local fontPairs = TRB.Functions.OptionsUi.Media:GetFontPairs()
	local fontPairsByName = TRB.Functions.OptionsUi.Media:GetFontPairsByName()
	local UpdateBarTextEditorInheritedControlState

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFace", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)

	local function FontFaceIsSelected(value)
		if workingBarText ~= nil then
			return value == workingBarText.fontFace
		else
			return false
		end
	end

	local function FontFaceSetSelected(newValue)
		if workingBarText ~= nil then
			workingBarText.fontFace = newValue
			workingBarText.fontFaceName = fontPairsByName[newValue]
			barTextFontFace:SetDefaultText(workingBarText.fontFaceName)
			RefreshBarTextEditorPreview(true)
		end
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for k, v in pairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v[2])
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				local outlineFlag = (workingBarText and workingBarText.fontOutline) or "OUTLINE"
				font:SetFont(v[2], 12, outlineFlag)
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	local useDefaultFontFace = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontFace", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontFace:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-60)
	getglobal(useDefaultFontFace:GetName() .. 'Text'):SetText(L["UseDefaultFontFace"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontFace.tooltip = L["UseDefaultFontFaceTooltip"]
	useDefaultFontFace:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontFace = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)


	local barTextFontJustifyHorizontal = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextFontJustifyHorizontal", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontJustifyHorizontal:SetWidth(oUi.sliderWidth)
	barTextFontJustifyHorizontal.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
	barTextFontJustifyHorizontal.label.font:SetFontObject(GameFontNormal)

	local fontJustifyHorizontal = {}
	fontJustifyHorizontal[L["PositionLeft"]] = "LEFT"
	fontJustifyHorizontal[L["PositionCenter"]] = "CENTER"
	fontJustifyHorizontal[L["PositionRight"]] = "RIGHT"
	local fontJustifyHorizontalList = {
		L["PositionLeft"],
		L["PositionCenter"],
		L["PositionRight"],
	}

	local function FontJustifyHorizontalIsSelected(value)
		if workingBarText ~= nil then
			return value == workingBarText.fontJustifyHorizontal
		else
			return false
		end
	end

	local function FontJustifyHorizontalSetSelected(newValue)
		if workingBarText ~= nil then
			workingBarText.fontJustifyHorizontal = newValue

			for k, v in pairs(fontJustifyHorizontal) do
				if v == newValue then
					workingBarText.fontJustifyHorizontalName = k
				end
			end
			barTextFontJustifyHorizontal:SetDefaultText(workingBarText.fontJustifyHorizontalName)
			RefreshBarTextEditorPreview(true)
		end
	end

	local function FontJustifyHorizontalGenerator(dropdown, rootDescription)
		for k, v in pairs(fontJustifyHorizontalList) do
			rootDescription:CreateRadio(v, FontJustifyHorizontalIsSelected, FontJustifyHorizontalSetSelected, fontJustifyHorizontal[v])
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontJustifyHorizontal:SetupMenu(FontJustifyHorizontalGenerator)
	barTextFontJustifyHorizontal:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)

	yCoord = yCoord - 100
	title = L["FontSize"]
	local fontSize = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, 6, 300, 18, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontSize:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		workingBarText.fontSize = value
		RefreshBarTextEditorPreview(true)
	end)

	local useDefaultFontSize = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontSize", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontSize:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-40)
	getglobal(useDefaultFontSize:GetName() .. 'Text'):SetText(L["UseDefaultFontSize"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontSize.tooltip = L["UseDefaultFontSizeTooltip"]
	useDefaultFontSize:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontSize = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	controls.colors = controls.colors or {}
	controls.colors.barText = controls.colors.barText or {}
	local initialBarTextColor = NormalizeBarTextEntryColor(workingBarText)
	controls.colors.barText.color = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(barTextOptionsFrame, L["FontColor"], initialBarTextColor,
																			oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	local barTextColor = controls.colors.barText.color
	barTextColor:SetScript("OnMouseDown", function(self, button, ...)
		NormalizeBarTextEntryColor(workingBarText)
		TRB.Functions.OptionsUi.ColorPickers:ColorOnMouseDown(button, workingBarText, controls.colors.barText, "color")
	end)

	local useDefaultFontColor = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontColor", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontColor:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-30)
	getglobal(useDefaultFontColor:GetName() .. 'Text'):SetText(L["UseDefaultFontColor"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontColor.tooltip = L["UseDefaultFontColorTooltip"]
	useDefaultFontColor:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontColor = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	-- Font Outline dropdown
	yCoord = yCoord - 60
	local perEntryFontOutlineOptions = {
		{ label = L["FontOutlineNone"], value = "" },
		{ label = L["FontOutlineOutline"], value = "OUTLINE" },
		{ label = L["FontOutlineThickOutline"], value = "THICKOUTLINE" },
		{ label = L["FontOutlineMonochrome"], value = "MONOCHROME" },
		{ label = L["FontOutlineOutlineMonochrome"], value = "OUTLINE, MONOCHROME" },
		{ label = L["FontOutlineThickOutlineMonochrome"], value = "THICKOUTLINE, MONOCHROME" },
	}
	local perEntryFontOutlineLookup = {}
	for _, opt in ipairs(perEntryFontOutlineOptions) do
		perEntryFontOutlineLookup[opt.value] = opt.label
	end

	local barTextFontOutline = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontOutline", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontOutline:SetWidth(oUi.sliderWidth)
	barTextFontOutline.label = TRB.Functions.OptionsUi.Primitives:BuildSectionHeader(barTextOptionsFrame, L["FontOutlineHeader"], oUi.xCoord, yCoord)
	barTextFontOutline.label.font:SetFontObject(GameFontNormal)

	local function PerEntryFontOutlineIsSelected(value)
		if workingBarText ~= nil then
			return value == (workingBarText.fontOutline or "OUTLINE")
		else
			return false
		end
	end

	local function PerEntryFontOutlineSetSelected(newValue)
		if workingBarText ~= nil then
			workingBarText.fontOutline = newValue
			workingBarText.fontOutlineName = perEntryFontOutlineLookup[newValue] or L["FontOutlineOutline"]
			RefreshBarTextEditorPreview(true)
		end
	end

	local function PerEntryFontOutlineGenerator(dropdown, rootDescription)
		for _, opt in ipairs(perEntryFontOutlineOptions) do
			rootDescription:CreateRadio(opt.label, PerEntryFontOutlineIsSelected, PerEntryFontOutlineSetSelected, opt.value)
		end
	end
	barTextFontOutline:SetupMenu(PerEntryFontOutlineGenerator)
	barTextFontOutline:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	local useDefaultFontOutline = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontOutline", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontOutline:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord-60)
	getglobal(useDefaultFontOutline:GetName() .. 'Text'):SetText(L["UseDefaultFontOutline"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontOutline.tooltip = L["UseDefaultFontOutlineTooltip"]
	useDefaultFontOutline:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontOutline = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	controls.colors.barText.fontShadowColor = TRB.Functions.OptionsUi.ColorPickers:BuildColorPicker(barTextOptionsFrame, L["FontShadowColor"],
		"FF000000", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord-10)
	local barTextShadowColor = controls.colors.barText.fontShadowColor
	barTextShadowColor:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			if workingBarText.fontShadow == nil then
				workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
			end
			local colorString = workingBarText.fontShadow.color or "FF000000"
			local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
			TRB.Functions.OptionsUi.ColorPickers:ShowColorPicker(r, g, b, 1-a, function(color)
				local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi.ColorPickers:ExtractColorFromColorPicker(color)
				controls.colors.barText.fontShadowColor.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
				workingBarText.fontShadow.color = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
				RefreshBarTextEditorPreview(true)
			end)
		end
	end)

	local fontShadowEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_fontShadowEnabled", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	fontShadowEnabled:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-40)
	getglobal(fontShadowEnabled:GetName() .. 'Text'):SetText(L["FontShadowEnable"])
	---@diagnostic disable-next-line: inject-field
	fontShadowEnabled.tooltip = L["FontShadowEnableTooltip"]
	fontShadowEnabled:SetScript("OnClick", function(self, ...)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.enabled = self:GetChecked()
		RefreshBarTextEditorPreview(true)
	end)

	local useDefaultFontShadow = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_useDefaultFontShadow", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	useDefaultFontShadow:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-60)
	getglobal(useDefaultFontShadow:GetName() .. 'Text'):SetText(L["UseDefaultFontShadow"])
	---@diagnostic disable-next-line: inject-field
	useDefaultFontShadow.tooltip = L["UseDefaultFontShadowTooltip"]
	useDefaultFontShadow:SetScript("OnClick", function(self, ...)
		workingBarText.useDefaultFontShadow = self:GetChecked()
		UpdateBarTextEditorInheritedControlState()
		RefreshBarTextEditorPreview(true)
	end)

	yCoord = yCoord - 100
	title = L["FontShadowXOffset"]
	local fontShadowXOffset = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, -10, 10, 1, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontShadowXOffset:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.xOffset = value
		RefreshBarTextEditorPreview(true)
	end)

	title = L["FontShadowYOffset"]
	local fontShadowYOffset = TRB.Functions.OptionsUi.Primitives:BuildSlider(barTextOptionsFrame, title, -10, 10, -1, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	fontShadowYOffset:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi.Primitives:EditBoxSetTextMinMax(self, value)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.yOffset = value
		RefreshBarTextEditorPreview(true)
	end)

	UpdateBarTextEditorInheritedControlState = function()
		local hasWorkingBarText = workingBarText ~= nil
		TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(barTextFontFace, hasWorkingBarText and not workingBarText.useDefaultFontFace)
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(fontSize, hasWorkingBarText and not workingBarText.useDefaultFontSize)
		TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(barTextColor, hasWorkingBarText and not workingBarText.useDefaultFontColor)
		TRB.Functions.OptionsUi.Primitives:ToggleDropdownEnabled(barTextFontOutline, hasWorkingBarText and not (workingBarText.useDefaultFontOutline or false))

		local shadowControlsEnabled = hasWorkingBarText and not (workingBarText.useDefaultFontShadow or false)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxEnabled(fontShadowEnabled, shadowControlsEnabled)
		TRB.Functions.OptionsUi.Primitives:ToggleColorPickerEnabled(barTextShadowColor, shadowControlsEnabled)
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(fontShadowXOffset, shadowControlsEnabled)
		TRB.Functions.OptionsUi.Primitives:ToggleSliderEnabled(fontShadowYOffset, shadowControlsEnabled)
	end

	---Populates the bar text scrolling table with rows from the displayText.barText entries.
	---@param displayText TRB.Classes.Settings.DisplayText The display text settings containing the barText array
	---@param btt table LibScrollingTable instance to populate with data rows
	local function SetTableValues(displayText, btt)
		local dataTable = {}
		local entries = TRB.Functions.Table:Length(displayText.barText)
		if entries > 0 then
			for i = 1, entries do
				NormalizeBarTextEntryColor(displayText.barText[i])
				local nameColor = nil
				if displayText.barText[i].enabled == false then
					nameColor = { r = 1, g = 0.3, b = 0.3, a = 1 }
				end
				table.insert(dataTable, {
					cols = {
						{
							value = displayText.barText[i].guid
						},
						{
							value = displayText.barText[i].name,
							color = nameColor,
						},
						{
							value = displayText.barText[i].position.relativeToFrameName,
						},
						{
							value = displayText.barText[i].text,
						},
						{
							value = "X",
						}
					}
				})
			end
		end
		btt:SetData(dataTable)
		btt:EnableSelection(true)
	end

	RefreshBarTextTable = function()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)

		if workingBarText ~= nil and workingBarText.guid ~= nil then
			local entries = TRB.Functions.Table:Length(displayText.barText)
			for i = 1, entries do
				if displayText.barText[i].guid == workingBarText.guid then
					barTextTable:SetSelection(i)
					break
				end
			end
		end
	end

	---Creates and returns a new default bar text entry with default font, position, and empty text content.
	---@return TRB.Classes.Settings.DisplayTextEntry entry A new display text entry with default values
	local function GetNewDisplayTextEntry()
		return {
			enabled = true,
			useDefaultFontFace = true,
			useDefaultFontSize = true,
			useDefaultFontColor = true,
			useDefaultFontOutline = true,
			useDefaultFontShadow = true,
			name = L["NewBarTextEntry"],
			text = "",
			guid = TRB.Functions.String:Guid(),
			fontFace = TRB.Data.constants.defaultSettings.fonts.fontFace,
			fontFaceName = TRB.Data.constants.defaultSettings.fonts.fontFaceName,
			fontJustifyHorizontal = "LEFT",
			fontJustifyHorizontalName = L["PositionLeft"],
			fontSize=14,
			color = { color = "FFFFFFFF" },
			fontOutline = "OUTLINE",
			fontOutlineName = L["FontOutlineOutline"],
			fontShadow = {
				enabled = false,
				color = "FF000000",
				xOffset = 1,
				yOffset = -1,
			},
			position = {
				xPos = 0,
				yPos = 0,
				relativeTo = "LEFT",
				relativeToName = L["PositionLeft"],
				relativeToFrame = "Resource",
				relativeToFrameName = L["MainResourceBar"]
			}
		}
	end

	---Finds the bar text entry matching the given GUID and populates the editor fields with its values.
	---@param guid string The unique identifier of the bar text entry to load
	---@param dt TRB.Classes.Settings.DisplayText The display text settings containing the barText array to search
	local function FillBarTextEditorFields(guid, dt)
		local found = false
		local e = TRB.Functions.Table:Length(dt.barText)
		if e > 0 then
			for i = 1, e do
				if dt.barText[i].guid == guid then
					workingBarText = dt.barText[i]
					found = true
					break
				end
			end
		end

		if not found then
			return
		end

		barTextName:SetText(workingBarText.name)
		barTextEntryEnabled:SetChecked(workingBarText.enabled)
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)

		barTextRelativeToFrame:SetupMenu(RelativeToFrameGenerator)
		barTextRelativeTo:SetupMenu(RelativeToGenerator)
		barTextFontFace:SetupMenu(FontFaceGenerator)
		barTextFontJustifyHorizontal:SetupMenu(FontJustifyHorizontalGenerator)
		barTextRelativeToFrame:SetDefaultText(workingBarText.position.relativeToFrameName)
		barTextRelativeTo:SetDefaultText(workingBarText.position.relativeToName)
		barTextFontFace:SetDefaultText(workingBarText.fontFaceName)
		barTextFontJustifyHorizontal:SetDefaultText(workingBarText.fontJustifyHorizontalName)

		fontSize:SetValue(workingBarText.fontSize)
		local currentBarTextColor = NormalizeBarTextEntryColor(workingBarText)
		barTextColor.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(currentBarTextColor, true))
		barText:SetText(workingBarText.text)
		-- Reset undo history so the newly loaded text is the baseline
		if barText.ResetUndoHistory then
			barText:ResetUndoHistory(workingBarText.text)
		end

		barTextHorizontal:SetValue(workingBarText.position.xPos)
		barTextVertical:SetValue(workingBarText.position.yPos)

		useDefaultFontColor:SetChecked(workingBarText.useDefaultFontColor)
		useDefaultFontFace:SetChecked(workingBarText.useDefaultFontFace)
		useDefaultFontSize:SetChecked(workingBarText.useDefaultFontSize)
		useDefaultFontOutline:SetChecked(workingBarText.useDefaultFontOutline or false)
		useDefaultFontShadow:SetChecked(workingBarText.useDefaultFontShadow or false)
		barTextFontOutline:SetupMenu(PerEntryFontOutlineGenerator)
		barTextFontOutline:SetDefaultText(workingBarText.fontOutlineName or L["FontOutlineOutline"])

		-- Restore font shadow controls
		local shadow = workingBarText.fontShadow or { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		fontShadowEnabled:SetChecked(shadow.enabled)
		barTextShadowColor.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(shadow.color or "FF000000", true))
		fontShadowXOffset:SetValue(shadow.xOffset or 1)
		fontShadowYOffset:SetValue(shadow.yOffset or -1)
		UpdateBarTextEditorInheritedControlState()

		barTextOptionsFrame:Show()
	end

	SetTableValues(spec.displayText, barTextTable)

	addButton:SetScript("OnClick", function(self, ...)
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		local newEntry = GetNewDisplayTextEntry()
		table.insert(displayText.barText, newEntry)
		SetTableValues(displayText, barTextTable)
		barTextTable:SetSelection(TRB.Functions.Table:Length(displayText.barText))
		-- Refresh the active spec's merged bar text list when global bar text is in use
		-- (the merged table is a copy, so the insert above won't be reflected without a rebuild)
		if classId == nil then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		elseif classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
			end
		end
		TRB.Data.cache.barText = {}
		TRB.Functions.BarText:ClearBarTextCacheHash()
		TRB.Data.cache.symbols = {}
		TRB.Data.cache.barTextTree = {}
		TRB.Data.activeVariables = nil
		TRB.Data.lookupDirty = true
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		FillBarTextEditorFields(newEntry.guid, displayText)
	end)

	barTextEntryEnabled:SetScript("OnClick", function(self, ...)
		workingBarText.enabled = self:GetChecked()
		TRB.Functions.OptionsUi.Primitives:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)
		TRB.Data.activeVariables = nil
		TRB.Data.lookupDirty = true
		RefreshBarTextEditorPreview(true)
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
	end)

	barTextName:SetScript("OnTextChanged", function(self, input)
		workingBarText.name = self:GetText()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
	end)

	barText:SetScript("OnTextChanged", function(self, input)
		workingBarText.text = self:GetText()
		local displayText = spec.displayText --[[@as TRB.Classes.Settings.DisplayText]]
		SetTableValues(displayText, barTextTable)
		TRB.Data.cache.barText = {}
		TRB.Functions.BarText:ClearBarTextCacheHash()
		TRB.Data.cache.symbols = {}
		TRB.Data.cache.barTextTree = {}
		TRB.Data.activeVariables = nil
		TRB.Data.lookupDirty = true
	end)

	-- Attach undo/redo AFTER SetScript("OnTextChanged") so the HookScript
	-- recording handler is guaranteed to persist.
	TRB.Functions.OptionsUi.BarTextInput:AttachUndoRedo(barText)

	barTextTable:RegisterEvents({
		OnClick = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" then
				local currentSelection = scrollingTable:GetSelection()

				if realrow ~= nil and realrow > 0 then
					local guid = data[realrow].cols[1].value

					if column == 5 then
						StaticPopup_Show("TwintopResourceBar_ConfirmDeleteBarText", nil, nil, {
							message = string.format(L["BarTextDeleteConfirmation"], data[realrow].cols[2].value),
							displayText = spec.displayText,
							row = realrow,
							btt = scrollingTable,
							classId = classId,
							specId = specId,
							barTextOptionsFrame = barTextOptionsFrame,
							setTableValues = SetTableValues,
						})
					else
						FillBarTextEditorFields(guid, spec.displayText)
						C_Timer.After(0, function()
							C_Timer.After(0.05, function()
								local newSelection = scrollingTable:GetSelection()

								if newSelection == nil then
									barTextTable:SetSelection(currentSelection)
								end
							end)
						end)
					end
				end
			end
		end
	})

	---Replaces the spec's bar text entries, updates the specCache, refreshes the scrolling table, and triggers bar text frame recreation.
	---@param barText TRB.Classes.Settings.DisplayTextEntry[] The new array of bar text entries to apply
	local function ResetTableValues(barText)
		barText = TRB.Functions.Settings:ApplySharedFontDefaultsToBarTextEntries(barText)
		spec.displayText.barText = barText
		if TRB.Data.specCache[compositeKey] then
			if not TRB.Data.specCache[compositeKey].settings.displayText then
				TRB.Data.specCache[compositeKey].settings.displayText = {}
			end
			TRB.Data.specCache[compositeKey].settings.displayText.barText = barText
		end
		SetTableValues(spec.displayText, barTextTable)
		_G["TwintopResourceBar_" .. namePrefix .. "_BarTextOptionsFrame"]:Hide()

		if classId == nil then
			-- Global bar text editor: rebuild the active spec if it uses global bar text
			local charClassName = TRB.Data.character.className
			local charSpecName = TRB.Data.character.specName
			if charClassName and charSpecName and TRB.Data.settings.core.global[charClassName] and TRB.Data.settings.core.global[charClassName][charSpecName] and TRB.Data.settings.core.global[charClassName][charSpecName].globalBarText then
				TRB.Functions.Character:FillSpecializationCacheSettings(charClassName, charSpecName)
				TRB.Data.cache.barText = {}
				TRB.Functions.BarText:ClearBarTextCacheHash()
				TRB.Data.cache.symbols = {}
				TRB.Data.cache.barTextTree = {}
				TRB.Data.activeVariables = nil
				-- Use the active spec's merged settings (not core) so frame indices match the merged barText list
				local activeCompositeKey = TRB.Functions.Character:GetCompositeKey(charClassName, charSpecName)
				local activeSettings = TRB.Data.specCache[activeCompositeKey] and TRB.Data.specCache[activeCompositeKey].settings
				TRB.Functions.BarText:Hide(activeSettings or spec)
				TRB.Functions.BarText:CreateBarTextFrames()
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		elseif classId == TRB.Data.character.classId and specId == TRB.Data.character.specId then
			TRB.Data.cache.barText = {}
			TRB.Functions.BarText:ClearBarTextCacheHash()
			TRB.Data.cache.symbols = {}
			TRB.Data.cache.barTextTree = {}
			TRB.Data.activeVariables = nil
			-- Hide all existing bar text frames before recreating to prevent stale text from persisting
			TRB.Functions.BarText:Hide(spec)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			-- Force an immediate bar text update so the new strings render right away
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
		TRB.Functions.OptionsUi.Tabs:SwitchToBarTextTabByClassSpec(classId, specId)
	end

	controls.barTextFields = {}
	controls.barTextFields.barTextTable = barTextTable
	controls.barTextFields.ResetTableValues = ResetTableValues

	yCoord = oldYCoord
	local variablesPanel = TRB.Functions.OptionsUi.BarTextVariables:CreateVariablesSidePanel(parent, namePrefix, cache, classId, specId)
	-- Tag the scroll child's ancestor (the tabsheet parent) so SwitchTab/SelectCategory can find the right panel
	---@diagnostic disable-next-line: inject-field
	parent.barTextVariablesPanel = variablesPanel
	TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
end