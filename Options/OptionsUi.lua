---@diagnostic disable: undefined-field, undefined-global
local _, TRB = ...
TRB.Functions = TRB.Functions or {}
TRB.Functions.OptionsUi = {}
local oUi = TRB.Data.constants.optionsUi

local L = TRB.Localization

---Ensures the bar settings table has an anchor block, synthesizing from legacy fields if needed.
---Returns the anchor block (creates it if absent).
---@param barSettings table # A bar dimensions table (e.g., spec.comboPoints, spec.healthBar, barSettings)
---@param barKey string? # The bar key of this bar (e.g., "primary", "secondary", "health"). Used to determine default anchor target.
---@return table anchor # The anchor block
local function EnsureAnchorBlock(barSettings, barKey)
	if barSettings.anchor then
		return barSettings.anchor
	end
	-- Primary bar (or no barKey) defaults to "screen"; all others default to "primary"
	local defaultTarget = (barKey == "primary") and "screen" or "primary"
	-- Synthesize from legacy fields
	local anchor = {
		barKey = defaultTarget,
		anchorPoint = "TOP",
		attachPoint = "BOTTOM",
		xOffset = barSettings.xPos or 0,
		yOffset = barSettings.yPos or 0,
		matchWidth = barSettings.fullWidth or false,
	}
	if barKey == "primary" then
		-- Primary bar: screen anchor uses absolute position, default points are CENTER/CENTER
		anchor.anchorPoint = "CENTER"
		anchor.attachPoint = "CENTER"
		anchor.xOffset = barSettings.xPos or 0
		anchor.yOffset = barSettings.yPos or -200
	elseif barSettings.relativeTo then
		local mapping = TRB.Data.constants.relativeToAnchorMap[barSettings.relativeTo]
		if mapping then
			anchor.anchorPoint = mapping.anchorPoint
			anchor.attachPoint = mapping.attachPoint
		end
	end
	barSettings.anchor = anchor
	return anchor
end

---Dual-writes anchor block values back to legacy fields for backward compatibility.
---Call after any change to barSettings.anchor so that legacy readers remain correct.
---@param barSettings table # A bar dimensions table with an anchor block
local function DualWriteAnchorToLegacy(barSettings)
	if not barSettings or not barSettings.anchor then return end
	local anchor = barSettings.anchor
	barSettings.xPos = anchor.xOffset or 0
	barSettings.yPos = anchor.yOffset or 0
	barSettings.fullWidth = anchor.matchWidth or false
	-- Best-match relativeTo from anchorPoint (only for bar-anchored bars, not screen-anchored)
	if anchor.barKey and anchor.barKey ~= "screen" then
		local reverseMap = TRB.Data.constants.anchorPointToRelativeToMap
		if reverseMap and anchor.anchorPoint then
			barSettings.relativeTo = reverseMap[anchor.anchorPoint]
			local nameMap = {
				TOPLEFT = L["PositionAboveLeft"],
				TOP = L["PositionAboveMiddle"],
				TOPRIGHT = L["PositionAboveRight"],
				BOTTOMLEFT = L["PositionBelowLeft"],
				BOTTOM = L["PositionBelowMiddle"],
				BOTTOMRIGHT = L["PositionBelowRight"],
			}
			barSettings.relativeToName = nameMap[barSettings.relativeTo] or ""
		end
	else
		-- Screen-anchored: clear stale legacy fields so MigrateBarAnchors
		-- won't incorrectly re-derive a bar-relative anchor from them on import.
		barSettings.relativeTo = nil
		barSettings.relativeToName = nil
	end
end

---Lookup table mapping 9-point anchor constants to their localized display names.
local anchorPointDisplayNames = {
	TOPLEFT     = L["AnchorPointTOPLEFT"],
	TOP         = L["AnchorPointTOP"],
	TOPRIGHT    = L["AnchorPointTOPRIGHT"],
	LEFT        = L["AnchorPointLEFT"],
	CENTER      = L["AnchorPointCENTER"],
	RIGHT       = L["AnchorPointRIGHT"],
	BOTTOMLEFT  = L["AnchorPointBOTTOMLEFT"],
	BOTTOM      = L["AnchorPointBOTTOM"],
	BOTTOMRIGHT = L["AnchorPointBOTTOMRIGHT"],
}

---Returns the localized display name for a 9-point anchor constant.
---@param point string # One of TOPLEFT, TOP, TOPRIGHT, LEFT, CENTER, RIGHT, BOTTOMLEFT, BOTTOM, BOTTOMRIGHT
---@return string
local function GetAnchorPointDisplayName(point)
	return anchorPointDisplayNames[point or "TOP"] or point or "TOP"
end

---Applies sensible defaults when changing anchor target type (screen â†” bar).
---When transitioning between screen and bar anchoring, the existing offset/point values
---are meaningless for the new context, so reset them to useful defaults.
---@param anchor table The anchor block to modify
---@param oldBarKey string The previous barKey
---@param newBarKey string The new barKey
---@return boolean changed Whether any properties besides barKey were changed
local function ApplyAnchorTransitionDefaults(anchor, oldBarKey, newBarKey)
	local wasScreen = (oldBarKey == "screen" or oldBarKey == nil)
	local goingToScreen = (newBarKey == "screen")

	if wasScreen and not goingToScreen then
		-- Screen â†’ Bar: reset to bar-to-bar defaults
		-- Attach this bar's TOP to the target bar's BOTTOM (bar appears just below target)
		anchor.anchorPoint = "BOTTOM"
		anchor.attachPoint = "TOP"
		anchor.xOffset = 0
		anchor.yOffset = 0
		anchor.matchWidth = true
		return true
	elseif not wasScreen and goingToScreen then
		-- Bar â†’ Screen: reset to screen defaults
		anchor.anchorPoint = "CENTER"
		anchor.attachPoint = "CENTER"
		anchor.xOffset = 0
		anchor.yOffset = -200
		anchor.matchWidth = false
		return true
	end
	return false
end

---Returns the RGB color values used for "Use Global Settings" checkbox label text.
---@return number r # Red component (0-1)
---@return number g # Green component (0-1)
---@return number b # Blue component (0-1)
local function GetUseGlobalSettingsColor()
	return 100/255, 225/255, 200/225
end

-- Rotation mapping: 90° CCW (horizontal → vertical / leftRight → bottomTop)
local rotateAnchorCCW = {
	LEFT = "BOTTOM", RIGHT = "TOP", TOP = "LEFT", BOTTOM = "RIGHT",
	TOPLEFT = "BOTTOMLEFT", TOPRIGHT = "TOPLEFT", BOTTOMLEFT = "BOTTOMRIGHT", BOTTOMRIGHT = "TOPRIGHT",
	CENTER = "CENTER",
}

-- Rotation mapping: 90° CW (vertical → horizontal / bottomTop → leftRight)
local rotateAnchorCW = {
	BOTTOM = "LEFT", TOP = "RIGHT", LEFT = "TOP", RIGHT = "BOTTOM",
	BOTTOMLEFT = "TOPLEFT", TOPLEFT = "TOPRIGHT", BOTTOMRIGHT = "BOTTOMLEFT", TOPRIGHT = "BOTTOMRIGHT",
	CENTER = "CENTER",
}

local anchorToLocalizedName = {
	TOPLEFT = L["PositionTopLeft"], TOP = L["PositionTop"], TOPRIGHT = L["PositionTopRight"],
	LEFT = L["PositionLeft"], CENTER = L["PositionCenter"], RIGHT = L["PositionRight"],
	BOTTOMLEFT = L["PositionBottomLeft"], BOTTOM = L["PositionBottom"], BOTTOMRIGHT = L["PositionBottomRight"],
}

---Rotates per-threshold icon override X/Y offsets for a 90° rotation between horizontal and vertical orientations.
---Global threshold icon offsets are always screen-space (horizontal/vertical) and are NOT rotated.
---@param spec table The spec settings
---@param toVertical boolean True if rotating horizontal→vertical (CCW), false for vertical→horizontal (CW)
local function RotateThresholdIconOffsets(spec, toVertical)
	if spec.thresholds and spec.thresholds.thresholdDictionary then
		for _, entry in pairs(spec.thresholds.thresholdDictionary) do
			if entry.icon then
				local oldX, oldY = entry.icon.xPos or 0, entry.icon.yPos or 0
				if toVertical then
					-- 90° CCW: newX = -oldY, newY = oldX
					entry.icon.xPos = -oldY
					entry.icon.yPos = oldX
				else
					-- 90° CW: newX = oldY, newY = -oldX
					entry.icon.xPos = oldY
					entry.icon.yPos = -oldX
				end
			end
		end
	end
end

---Rotates bar text anchor positions for a 90° rotation between horizontal and vertical orientations.
---@param spec table The spec settings
---@param toVertical boolean True if rotating horizontal→vertical (CCW), false for vertical→horizontal (CW)
---@param barGroupKey string? Optional bar group key to limit rotation to entries anchored to that bar group
---@param classId integer?
---@param specId integer?
local function RotateBarTextPositions(spec, toVertical, barGroupKey, classId, specId)
	if not spec.displayText or not spec.displayText.barText then return end
	local rotateMap = toVertical and rotateAnchorCCW or rotateAnchorCW
	for _, entry in pairs(spec.displayText.barText) do
		if entry.position and (barGroupKey == nil or TRB.Functions.BarText:IsEntryAnchoredToBarGroup(entry, barGroupKey, classId, specId)) then
			local oldX, oldY = entry.position.xPos or 0, entry.position.yPos or 0
			if toVertical then
				-- 90° CCW: newX = -oldY, newY = oldX
				entry.position.xPos = -oldY
				entry.position.yPos = oldX
			else
				-- 90° CW: newX = oldY, newY = -oldX
				entry.position.xPos = oldY
				entry.position.yPos = -oldX
			end
			local newAnchor = rotateMap[entry.position.relativeTo]
			if newAnchor then
				entry.position.relativeTo = newAnchor
				entry.position.relativeToName = anchorToLocalizedName[newAnchor] or newAnchor
			end
		end
	end
end

---Swaps the min/max bounds of two sliders (width ↔ height) when crossing orientation boundary.
---@param widthSlider table The width slider control
---@param heightSlider table The height slider control
local function SwapSliderBounds(widthSlider, heightSlider)
	local wMin, wMax = widthSlider:GetMinMaxValues()
	local hMin, hMax = heightSlider:GetMinMaxValues()
	widthSlider:SetMinMaxValues(hMin, hMax)
	widthSlider.MinLabel:SetText(tostring(hMin))
	widthSlider.MaxLabel:SetText(tostring(hMax))
	heightSlider:SetMinMaxValues(wMin, wMax)
	heightSlider.MinLabel:SetText(tostring(wMin))
	heightSlider.MaxLabel:SetText(tostring(wMax))
end

-- Global settings toggles and copy-menu implementations live in Options\OptionsUiGlobalSettings.lua.
function TRB.Functions.OptionsUi:IsEditingActiveSpec(...)
	return self.GlobalSettings:IsEditingActiveSpec(...)
end

function TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(...)
	return self.GlobalSettings:BuildBulkGlobalToggleCheckbox(...)
end

function TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox(...)
	return self.GlobalSettings:RefreshBulkGlobalToggleCheckbox(...)
end

function TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(...)
	return self.GlobalSettings:BuildUseGlobalShortcutLink(...)
end

function TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(...)
	return self.GlobalSettings:BuildUseGlobalCopyButton(...)
end

function TRB.Functions.OptionsUi:BuildGlobalBulkCopyButton(...)
	return self.GlobalSettings:BuildGlobalBulkCopyButton(...)
end

local sounds = {}
local soundsList = {}
local soundPairs = {}
local soundPairsByName = {}
---Populates the sound cache from LibSharedMedia if not already filled.
local function FillSoundCache()
	if TRB.Functions.Table:Length(sounds) == 0 then
		sounds = TRB.Details.addonData.libs.SharedMedia:HashTable("sound")
		soundsList = TRB.Details.addonData.libs.SharedMedia:List("sound")

		local x = 1
		for k, v in pairs(soundsList) do
			table.insert(soundPairs, { v, sounds[v] })
			soundPairsByName[sounds[v]] = v
			x = x + 1
		end
	end
end

local fonts = {}
local fontsList = {}
local fontPairs = {}
local fontPairsByName = {}
---Populates the font cache from LibSharedMedia if not already filled.
local function FillFontCache()
	if TRB.Functions.Table:Length(fonts) == 0 then
		fonts = TRB.Details.addonData.libs.SharedMedia:HashTable("font")
		fontsList = TRB.Details.addonData.libs.SharedMedia:List("font")

		local x = 1
		for k, v in pairs(fontsList) do
			table.insert(fontPairs, { v, fonts[v] })
			fontPairsByName[fonts[v]] = v
			x = x + 1
		end
	end
end

-- Primitive UI builders and color-picker helpers live in Options\OptionsUiPrimitives.lua.
function TRB.Functions.OptionsUi:BuildSlider(...)
	return self.Primitives:BuildSlider(...)
end

function TRB.Functions.OptionsUi:BuildPercentageSlider(...)
	return self.Primitives:BuildPercentageSlider(...)
end

function TRB.Functions.OptionsUi:BuildTextBox(...)
	return self.Primitives:BuildTextBox(...)
end

function TRB.Functions.OptionsUi:EditBoxSetTextMinMax(...)
	return self.Primitives:EditBoxSetTextMinMax(...)
end

function TRB.Functions.OptionsUi:ShowColorPicker(...)
	return self.Primitives:ShowColorPicker(...)
end

function TRB.Functions.OptionsUi:ExtractColorFromColorPicker(...)
	return self.Primitives:ExtractColorFromColorPicker(...)
end

function TRB.Functions.OptionsUi:ColorOnMouseDown(...)
	return self.Primitives:ColorOnMouseDown(...)
end

function TRB.Functions.OptionsUi:GetPrimaryBackdropFrame(...)
	return self.Primitives:GetPrimaryBackdropFrame(...)
end

function TRB.Functions.OptionsUi:GetSecondaryBackdropFrames(...)
	return self.Primitives:GetSecondaryBackdropFrames(...)
end

function TRB.Functions.OptionsUi:GetHealthBackdropFrame(...)
	return self.Primitives:GetHealthBackdropFrame(...)
end

function TRB.Functions.OptionsUi:BuildColorPicker(...)
	return self.Primitives:BuildColorPicker(...)
end

function TRB.Functions.OptionsUi:BuildGradientColorPicker(...)
	return self.Primitives:BuildGradientColorPicker(...)
end

function TRB.Functions.OptionsUi:GradientColor2OnMouseDown(...)
	return self.Primitives:GradientColor2OnMouseDown(...)
end

function TRB.Functions.OptionsUi:BuildColorPickerWithEnable(...)
	return self.Primitives:BuildColorPickerWithEnable(...)
end

function TRB.Functions.OptionsUi:BuildSectionHeader(...)
	return self.Primitives:BuildSectionHeader(...)
end

function TRB.Functions.OptionsUi:BuildDisplayTextHelpEntry(...)
	return self.Primitives:BuildDisplayTextHelpEntry(...)
end

function TRB.Functions.OptionsUi:BuildButton(...)
	return self.Primitives:BuildButton(...)
end

function TRB.Functions.OptionsUi:BuildExportButton(...)
	return self.Primitives:BuildExportButton(...)
end

-- ============================================================================
-- Profile management dropdown (Phase 2B + 2C)
-- Profile dropdown and profile popup implementations live in Options\OptionsUiProfiles.lua.
function TRB.Functions.OptionsUi:ShowProfileImportPopup(...)
	return self.Profiles:ShowProfileImportPopup(...)
end

function TRB.Functions.OptionsUi:BuildProfileDropdown(...)
	return self.Profiles:BuildProfileDropdown(...)
end

function TRB.Functions.OptionsUi:BuildSpecTitleRow(...)
	return self.Profiles:BuildSpecTitleRow(...)
end

function TRB.Functions.OptionsUi:BuildLabel(...)
	return self.Primitives:BuildLabel(...)
end

-- Tab and tab-container implementations live in Options\OptionsUiTabs.lua.
function TRB.Functions.OptionsUi:CreateScrollFrameContainer(...)
	return self.Tabs:CreateScrollFrameContainer(...)
end

function TRB.Functions.OptionsUi:CreateTabFrameContainer(...)
	return self.Tabs:CreateTabFrameContainer(...)
end

function TRB.Functions.OptionsUi:HideAllBarTextVariablesPanels(...)
	return self.Tabs:HideAllBarTextVariablesPanels(...)
end

function TRB.Functions.OptionsUi:ActivateBarTextVariablesPanel(...)
	return self.Tabs:ActivateBarTextVariablesPanel(...)
end

function TRB.Functions.OptionsUi:SwitchTab(...)
	return self.Tabs.SwitchTab(...)
end

function TRB.Functions.OptionsUi:CreateTab(...)
	return self.Tabs:CreateTab(...)
end

function TRB.Functions.OptionsUi:SwitchToTabByClassSpec(...)
	return self.Tabs:SwitchToTabByClassSpec(...)
end

function TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(...)
	return self.Tabs:SwitchToBarTextTabByClassSpec(...)
end

function TRB.Functions.OptionsUi:BuildTabGroup(...)
	return self.Tabs:BuildTabGroup(...)
end

---Creates the bar text variables side panel with a searchable scrolling table, description pane, and add-button behavior.
---@param parent Frame # The spec's scrollChild or display panel parent
---@param name string # Unique name prefix for frame naming (e.g., "Priest_Shadow")
---@param cache table # The spec cache entry containing barTextVariables
---@param classId integer # The WoW class ID
---@param specId integer # The WoW specialization ID
---@return Frame # The outer container frame for the side panel
function TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, name, cache, classId, specId)
	local mainFrame = TRB.Frames.optionsFrame
	local panelWidth = 350

	-- Outer container frame anchored to the right of the main options frame
	local cf = CreateFrame("Frame", "TRB_" .. name .. "_BarTextVariables_Frame", mainFrame, "BackdropTemplate")
	cf:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	cf:SetBackdropColor(0, 0, 0, 0.8)
	cf:SetWidth(panelWidth)
	cf:ClearAllPoints()
	cf:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 0, 0)
	cf:SetPoint("BOTTOMLEFT", mainFrame, "BOTTOMRIGHT", 0, 0)

	-- Start hidden; SwitchTab will show it when the Bar Text tab is active
	cf:Hide()

	-- Register in the per-spec lookup table so tab/nav switching can activate the correct panel.
	TRB.Frames.barTextVariablesPanelRegistry = TRB.Frames.barTextVariablesPanelRegistry or {}
	TRB.Frames.barTextVariablesPanelRegistry[name] = cf

	-- =============================================
	-- Title
	-- =============================================
	local titleLabel = cf:CreateFontString(nil, "OVERLAY")
	titleLabel:SetFontObject(GameFontNormalLarge)
	titleLabel:SetPoint("TOPLEFT", cf, "TOPLEFT", 10, -8)
	titleLabel:SetText(L["BarTextVariablesPanelTitle"])

	-- =============================================
	-- Search box
	-- =============================================
	local searchBox = CreateFrame("EditBox", "TRB_" .. name .. "_BarTextVariables_Search", cf, "InputBoxTemplate")
	searchBox:SetSize(panelWidth - 30, 20)
	searchBox:SetPoint("TOPLEFT", cf, "TOPLEFT", 18, -30)
	searchBox:SetAutoFocus(false)
	searchBox:SetFontObject(ChatFontNormal)

	local searchPlaceholder = searchBox:CreateFontString(nil, "ARTWORK")
	searchPlaceholder:SetFontObject(GameFontDisable)
	searchPlaceholder:SetPoint("LEFT", searchBox, "LEFT", 4, 0)
	searchPlaceholder:SetText(L["BarTextVariablesPanelSearchPlaceholder"])
	searchBox:SetScript("OnEditFocusGained", function(self)
		searchPlaceholder:Hide()
	end)
	searchBox:SetScript("OnEditFocusLost", function(self)
		if self:GetText() == "" then
			searchPlaceholder:Show()
		end
	end)
	searchBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)

	-- =============================================
	-- Description pane (bottom 30% of the panel)
	-- =============================================
	local descHeight = 120
	local descFrame = CreateFrame("Frame", nil, cf, "BackdropTemplate")
	descFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 16,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	descFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
	descFrame:SetHeight(descHeight)
	descFrame:SetPoint("BOTTOMLEFT", cf, "BOTTOMLEFT", 5, 5)
	descFrame:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", -5, 5)

	local descLabel = descFrame:CreateFontString(nil, "OVERLAY")
	descLabel:SetFontObject(GameFontNormal)
	descLabel:SetPoint("TOPLEFT", descFrame, "TOPLEFT", 8, -6)
	descLabel:SetWidth(panelWidth - 30)
	descLabel:SetJustifyH("LEFT")
	descLabel:SetJustifyV("TOP")
	descLabel:SetText("")

	local descText = descFrame:CreateFontString(nil, "OVERLAY")
	descText:SetFontObject(GameFontHighlight)
	descText:SetPoint("TOPLEFT", descLabel, "BOTTOMLEFT", 0, -4)
	descText:SetPoint("BOTTOMRIGHT", descFrame, "BOTTOMRIGHT", -8, 6)
	descText:SetJustifyH("LEFT")
	descText:SetJustifyV("TOP")
	---@diagnostic disable-next-line: redundant-parameter
	descText:SetWordWrap(true)
	descText:SetText(L["BarTextVariablesPanelDescriptionDefault"])

	-- =============================================
	-- Table container (between search and description)
	-- =============================================
	local tableContainer = CreateFrame("Frame", "TRB_" .. name .. "_BarTextVariables_TableContainer", cf)
	tableContainer:SetPoint("TOPLEFT", cf, "TOPLEFT", 5, -55)
	tableContainer:SetPoint("BOTTOMRIGHT", descFrame, "TOPRIGHT", -5, 2)

	-- =============================================
	-- Build data table from cache.barTextVariables
	-- =============================================
	local allData = {}     -- flat array for LibScrollingTable
	local sectionOrder = { "values", "pipe", "icons" }
	local sectionLabels = {
		values = L["BarTextVariablesSectionValues"],
		pipe = L["BarTextVariablesSectionPipe"],
		icons = L["BarTextVariablesSectionIcons"],
	}

	---Builds a flat data array for LibScrollingTable from the spec's barTextVariables, organized by section.
	---@param barTextVariables table # The barTextVariables table with values, pipe, and icons sections
	---@return table[] # Flat array of row data for LibScrollingTable
	local function BuildDataTable(barTextVariables)
		local data = {}
		for _, sectionKey in ipairs(sectionOrder) do
			local sectionEntries = barTextVariables[sectionKey]
			if sectionEntries and #sectionEntries > 0 then
				local hasVisible = false
				for _, entry in ipairs(sectionEntries) do
					if entry.printInSettings then
						hasVisible = true
						break
					end
				end
				if hasVisible then
					-- Section header row
					table.insert(data, {
						cols = {
							{ value = "" },
							{ value = sectionLabels[sectionKey] },
						},
						isHeader = true,
						sectionKey = sectionKey,
						variable = "",
						description = "",
					})
					-- Variable rows
					for _, entry in ipairs(sectionEntries) do
						if entry.printInSettings then
							local desc = entry.description or ""
							if sectionKey == "icons" and entry.icon and entry.icon ~= "" then
								desc = entry.icon .. " " .. desc
							end
							table.insert(data, {
								cols = {
									{ value = L["BarTextVariablesAddButton"] },
									{ value = entry.variable },
								},
								isHeader = false,
								sectionKey = sectionKey,
								variable = entry.variable,
								description = desc,
							})
						end
					end
				end
			end
		end
		return data
	end

	-- Ensure barTextVariables are populated for this spec.
	-- For non-active specs, FillBarTextVariables hasn't been called yet during SwitchSpec,
	-- so we use the barTextVariablesRegistry to fill them on demand.
	local registryKey = TRB.Functions.Character:GetCompositeKeyFromIds(classId, specId)
	---Ensures the spec's barTextVariables are populated, filling them on demand from the registry if needed.
	local function EnsureBarTextVariablesPopulated()
		local vals = cache.barTextVariables.values
		if vals == nil or #vals == 0 then
			local registry = TRB.Data.barTextVariablesRegistry
			if registry and registryKey and registry[registryKey] then
				registry[registryKey](cache)
			end
		end
	end

	EnsureBarTextVariablesPopulated()
	allData = BuildDataTable(cache.barTextVariables)

	-- =============================================
	-- Calculate how many rows fit in the table area
	-- =============================================
	local rowHeight = 22
	-- Reserve space: panel top (55px for title+search) + description pane (descHeight + gap)
	-- The table container fills the remainder. Estimate available height.
	-- We use a conservative default; the table will scroll.
	local estimatedTableHeight = 400  -- Reasonable default, will be dynamically limited by anchors
	local numDisplayRows = math.max(5, math.floor(estimatedTableHeight / rowHeight))

	-- =============================================
	-- LibScrollingTable columns
	-- Column 1 = Add button (+), Column 2 = Variable name
	-- =============================================
	local columns = {
		{
			["name"] = "",
			["width"] = 18,
			["align"] = "CENTER",
			["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, st)
				if not fShow then return end
				-- Hide the default text; we use an icon texture instead
				cellFrame.text:SetText("")

				local rowData = data[realrow]
				if rowData and rowData.isHeader then
					if cellFrame._addIcon then cellFrame._addIcon:Hide() end
				else
					-- Create the icon texture once per cell, reuse thereafter
					if not cellFrame._addIcon then
						local icon = cellFrame:CreateTexture(nil, "ARTWORK")
						icon:SetSize(10, 10)
						icon:SetPoint("CENTER", cellFrame, "CENTER", 0, 0)
						-- Use a white base texture so SetVertexColor has full range
						icon:SetAtlas("communities-chat-icon-plus")
						cellFrame._addIcon = icon
					end
					local icon = cellFrame._addIcon
					icon:Show()
					local hasActiveEditBox = TRB.Frames.activeBarTextEditBox ~= nil
					if hasActiveEditBox then
						icon:SetVertexColor(0, 1, 0, 1)
					else
						icon:SetVertexColor(0.5, 0.5, 0.5, 0.6)
					end
				end
			end,
		},
		{
			["name"] = "",
			["width"] = panelWidth - 65,
			["align"] = "LEFT",
			["DoCellUpdate"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, st)
				if not fShow then return end
				local rowData = data[realrow]
				if rowData and rowData.isHeader then
					cellFrame.text:SetFontObject(GameFontNormal)
					cellFrame.text:SetTextColor(1, 0.82, 0, 1)
					cellFrame.text:SetText(rowData.cols[2].value)
				else
					cellFrame.text:SetFontObject(GameFontHighlight)
					cellFrame.text:SetTextColor(1, 1, 1, 1)
					cellFrame.text:SetText(rowData and rowData.cols[2].value or "")
				end
			end,
		},
	}

	local variablesTable = TRB.Details.addonData.libs.ScrollingTable:CreateST(columns, numDisplayRows, rowHeight, nil, tableContainer, false)
	variablesTable:EnableSelection(true)
	variablesTable.frame:SetPoint("TOPLEFT", tableContainer, "TOPLEFT", 0, 0)
	variablesTable.frame:SetPoint("TOPRIGHT", tableContainer, "TOPRIGHT", 0, 0)
	variablesTable:SetData(allData)

	-- Raise the search box above the table header frames so it remains clickable
	searchBox:SetFrameLevel(variablesTable.frame:GetFrameLevel() + 10)

	-- Dynamically resize the table when the container size changes
	tableContainer:HookScript("OnSizeChanged", function(self, w, h)
		local newRows = math.max(5, math.floor(h / rowHeight))
		if newRows ~= variablesTable.displayRows then
			variablesTable:SetDisplayRows(newRows, rowHeight)
		end
		-- Resize variable column (col 2) to fill remaining width
		columns[2].width = math.max(100, w - columns[1].width - 45)
		variablesTable:SetDisplayCols(columns)
	end)

	-- =============================================
	-- Search filtering
	-- =============================================
	local searchText = ""
	variablesTable:SetFilter(function(self, rowData)
		if searchText == "" then
			return true
		end
		if rowData.isHeader then
			-- Show header if any child in the same section passes the filter
			local started = false
			for _, d in ipairs(allData) do
				if d == rowData then
					started = true
				elseif started then
					if d.isHeader then
						break -- next section
					end
					local var = (d.variable or ""):lower()
					local desc = (d.description or ""):lower()
					if string.find(var, searchText, 1, true) or string.find(desc, searchText, 1, true) then
						return true
					end
				end
			end
			return false
		end
		local var = (rowData.variable or ""):lower()
		local desc = (rowData.description or ""):lower()
		return string.find(var, searchText, 1, true) or string.find(desc, searchText, 1, true)
	end)

	searchBox:SetScript("OnTextChanged", function(self, userInput)
		searchText = self:GetText():lower()
		variablesTable:SortData() -- Re-filters and refreshes
	end)

	-- =============================================
	-- Row click / Add button behavior
	-- =============================================
	variablesTable:RegisterEvents({
		["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, button, ...)
			if button == "LeftButton" and realrow and realrow > 0 then
				local rowData = data[realrow]
				if rowData and rowData.isHeader then
					-- Section header click â€” do nothing
					scrollingTable:ClearSelection()
					return true
				end

				if column == 1 then
					-- "Add" button column clicked â€” insert variable at cursor
					local editBox = TRB.Frames.activeBarTextEditBox
					if editBox and rowData and rowData.variable and rowData.variable ~= "" then
						local cursorPos = TRB.Frames.activeBarTextCursorPosition or editBox:GetCursorPosition()
						local currentText = editBox:GetText() or ""
						local before = string.sub(currentText, 1, cursorPos)
						local after = string.sub(currentText, cursorPos + 1)
						local varText = rowData.variable
						local newText = before .. varText .. after
						editBox:SetText(newText)
						-- Move cursor to just after inserted variable
						local newCursorPos = cursorPos + string.len(varText)
						editBox:SetCursorPosition(newCursorPos)
						TRB.Frames.activeBarTextCursorPosition = newCursorPos

						-- Fire the OnTextChanged to update working data
						if editBox:GetScript("OnTextChanged") then
							editBox:GetScript("OnTextChanged")(editBox, true)
						end
					end
					-- Don't select the row for an add-button click
					scrollingTable:ClearSelection()
					return true
				else
					-- Normal click â€” show description and select the row
					if rowData then
						descLabel:SetText(rowData.variable or "")
						descText:SetText(rowData.description or "")
						scrollingTable:SetSelection(realrow)
					end
				end
			end
			return true
		end,
		["OnEnter"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow and realrow > 0 then
				local rowData = data[realrow]
				if rowData and not rowData.isHeader then
					scrollingTable:SetHighLightColor(rowFrame, scrollingTable:GetDefaultHighlight())
					-- Tooltip for add button
					if column == 1 then
						GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
						GameTooltip:SetText(L["BarTextVariablesAddTooltip"], 1, 1, 1)
						GameTooltip:Show()
					end
				end
			end
			return true
		end,
		["OnLeave"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if realrow and realrow > 0 then
				local rowData = data[realrow]
				if not rowData or not rowData.isHeader then
					-- Only clear highlight if this row is not the current selection
					if realrow ~= scrollingTable:GetSelection() then
						scrollingTable:SetHighLightColor(rowFrame, scrollingTable:GetDefaultHighlightBlank())
					end
				end
			end
			GameTooltip:Hide()
			return true
		end,
	})

	-- Refresh data from cache on each Show (handles cases where barTextVariables
	-- were not yet populated at construction time, e.g. when spec was not active).
	cf:HookScript("OnShow", function()
		EnsureBarTextVariablesPopulated()
		local newData = BuildDataTable(cache.barTextVariables)
		if #newData > 0 and #newData ~= #allData then
			allData = newData
			variablesTable:SetData(allData)
			variablesTable:SortData()
		end
	end)

	---@diagnostic disable-next-line: inject-field
	cf.variablesTable = variablesTable
	---@diagnostic disable-next-line: inject-field
	cf.allData = allData
	---@diagnostic disable-next-line: inject-field
	cf.BuildDataTable = BuildDataTable
	---@diagnostic disable-next-line: inject-field
	cf.descLabel = descLabel
	---@diagnostic disable-next-line: inject-field
	cf.descText = descText
	---@diagnostic disable-next-line: inject-field
	cf.searchBox = searchBox

	return cf
end

---Attaches undo/redo support (Ctrl+Z / Ctrl+Y) to an EditBox.
---Text snapshots are recorded on a debounced timer so rapid typing collapses into
---a single history entry.  The public helpers `editBox:ResetUndoHistory()` and
---`editBox:ResetUndoHistory(initialText)` are added for external use (e.g. when
---the user switches to a different bar-text entry).
local UNDO_MAX_HISTORY = 50
local UNDO_DEBOUNCE_SEC = 0.4

---Attaches undo/redo keyboard support (Ctrl+Z / Ctrl+Y) to an EditBox with debounced history snapshots.
---@param editBox EditBox # The EditBox frame to attach undo/redo behavior to
local function AttachUndoRedo(editBox)
	-- Private state stored directly on the frame
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoHistory  = { editBox:GetText() or "" }
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoCursors  = { 0 }
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoIndex    = 1
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoSuppress = false  -- flag: true while we are programmatically setting text
---@diagnostic disable-next-line: undefined-field, inject-field
	editBox._undoTimer    = nil

	--- Reset the undo stack (call when loading a different entry).
	---@param initialText? string  If given, seeds the stack with this text.
---@diagnostic disable-next-line: undefined-field, inject-field
	function editBox:ResetUndoHistory(initialText)
---@diagnostic disable-next-line: undefined-field, inject-field
		if self._undoTimer then self._undoTimer:Cancel(); self._undoTimer = nil end
		local t = initialText or self:GetText() or ""
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoHistory  = { t }
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoCursors  = { self:GetCursorPosition() or 0 }
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoIndex    = 1
	end

	---Pushes the current text and cursor position onto the undo stack, trimming any redo entries beyond the current index.
	---@param self EditBox # The EditBox whose state is being recorded
	local function PushState(self)
		local text   = self:GetText()
		local cursor = self:GetCursorPosition() or 0
		-- Don't push if identical to the current entry
		if self._undoHistory[self._undoIndex] == text then return end
		-- Trim any redo entries beyond the current index
		for i = #self._undoHistory, self._undoIndex + 1, -1 do
			table.remove(self._undoHistory, i)
			table.remove(self._undoCursors, i)
		end
		-- Push
		table.insert(self._undoHistory, text)
		table.insert(self._undoCursors, cursor)
		-- Cap size
		if #self._undoHistory > UNDO_MAX_HISTORY then
			table.remove(self._undoHistory, 1)
			table.remove(self._undoCursors, 1)
		end
---@diagnostic disable-next-line: undefined-field, inject-field
		self._undoIndex = #self._undoHistory
	end

	-- Record text changes (debounced, user-input only)
	editBox:HookScript("OnTextChanged", function(self, userInput)
		if self._undoSuppress or not userInput then return end
		if self._undoTimer then self._undoTimer:Cancel() end
		self._undoTimer = C_Timer.NewTimer(UNDO_DEBOUNCE_SEC, function()
			self._undoTimer = nil
			PushState(self)
		end)
	end)

	-- Intercept Ctrl+Z (undo), Ctrl+Y / Ctrl+Shift+Z (redo)
	editBox:SetScript("OnKeyDown", function(self, key)
		local handled = false
		if IsControlKeyDown() then
			local isRedo = (key == "Y") or (key == "Z" and IsShiftKeyDown())
			if key == "Z" and not IsShiftKeyDown() then
				handled = true
				-- Flush any pending debounce so the current state is saved first
				if self._undoTimer then
					self._undoTimer:Cancel()
					self._undoTimer = nil
					PushState(self)
				end
				if self._undoIndex > 1 then
					self._undoIndex = self._undoIndex - 1
					self._undoSuppress = true
					self:SetText(self._undoHistory[self._undoIndex])
					self:SetCursorPosition(self._undoCursors[self._undoIndex] or 0)
					self._undoSuppress = false
				end
			elseif isRedo then
				handled = true
				if self._undoIndex < #self._undoHistory then
					self._undoIndex = self._undoIndex + 1
					self._undoSuppress = true
					self:SetText(self._undoHistory[self._undoIndex])
					self:SetCursorPosition(self._undoCursors[self._undoIndex] or 0)
					self._undoSuppress = false
				end
			end
		end
		-- Prevent keystrokes from leaking to game keybinds.
		-- Must be called AFTER all processing (WoW requirement).
		self:SetPropagateKeyboardInput(false)
	end)
end

---Creates a multi-line bar text input panel inside a scroll frame with undo/redo, cursor tracking, and focus management.
---@param parent Frame # The parent frame
---@param name string # Unique name prefix for frame naming
---@param text string # The initial text content
---@param width number # Width of the input panel in pixels
---@param height number # Height of the input panel in pixels
---@param xPos number # X offset from parent's TOPLEFT
---@param yPos number # Y offset from parent's TOPLEFT
---@return EditBox # The inner EditBox (scroll child)
function TRB.Functions.OptionsUi:CreateBarTextInputPanel(parent, name, text, width, height, xPos, yPos)
	local s = CreateFrame("ScrollFrame", "TRB_" .. name .. "_BarTextBox", parent, "UIPanelScrollFrameTemplate, BackdropTemplate") -- or your actual parent instead
	s:SetSize(width, height)
	s:SetPoint("TOPLEFT", parent, "TOPLEFT", xPos, yPos)

---@diagnostic disable-next-line: inject-field
	s.ScrollFrame = CreateFrame("EditBox", nil, s, "BackdropTemplate")
	local e = s.ScrollFrame
	e:SetTextInsets(4, 4, 0, 0)
	s:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = true,
		edgeSize = 1,
		tileSize = 5
	})
	s:SetBackdropColor(0, 0, 0, 1)
	s:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	e:SetScript("OnEnter", function(self)
		self:GetParent():SetBackdropBorderColor(0.4, 0.4, 0.4, 1.0)
	end)
	e:SetScript("OnLeave", function(self)
		self:GetParent():SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)
	end)
	e:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	e:SetCursorPosition(0)
	e:SetScript("OnCursorChanged", function(self, arg1, arg2, arg3, arg4)
		local vs = self:GetParent():GetVerticalScroll()
		local h  = self:GetParent():GetHeight()

		if vs+arg2 > 0 or 0 > vs+arg2-arg4+h then
			self:GetParent():SetVerticalScroll(arg2*-1)
		end
	end)

	e:SetMultiLine(true)
	e:SetFontObject(ChatFontNormal)
	e:SetWidth(width)
	e:SetText(text)
	e:SetAutoFocus(false)

	-- Track this EditBox as the active bar text editor when it gains focus.
	-- We remember both the EditBox and cursor position so the side panel
	-- "Add" button can insert variables at the right place even after focus
	-- moves away.
	e:HookScript("OnEditFocusGained", function(self)
		TRB.Frames.activeBarTextEditBox = self
	end)
	e:HookScript("OnEditFocusLost", function(self)
		TRB.Frames.activeBarTextCursorPosition = self:GetCursorPosition()
	end)

	-- Clicking anywhere in the scroll frame (not just on text) gives focus to the EditBox
	s:EnableMouse(true)
	s:SetScript("OnMouseDown", function(self)
		e:SetFocus()
	end)

	-- Keep EditBox width in sync if the ScrollFrame resizes
	s:HookScript("OnSizeChanged", function(self, w, h)
		e:SetWidth(w)
	end)

	s:SetScrollChild(e)
	return e
end

-- Texture dropdown helpers live in Options\OptionsUiTextures.lua.
function TRB.Functions.OptionsUi:CreateLsmDropdown(...)
	return self.Textures:CreateLsmDropdown(...)
end

-- Widget enable/disable helpers live in Options\OptionsUiPrimitives.lua.
function TRB.Functions.OptionsUi:ToggleCheckboxEnabled(...)
	return self.Primitives:ToggleCheckboxEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleSliderEnabled(...)
	return self.Primitives:ToggleSliderEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleDropdownEnabled(...)
	return self.Primitives:ToggleDropdownEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleColorPickerEnabled(...)
	return self.Primitives:ToggleColorPickerEnabled(...)
end

function TRB.Functions.OptionsUi:ToggleCheckboxOnOff(...)
	return self.Primitives:ToggleCheckboxOnOff(...)
end

---Applies the current spec's bar layout and appearance settings to the active bar groups, refreshing border visuals.
local function AdjustBarBorder()
	local specCacheEntry = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
	if TRB.Frames.barGroups ~= nil then
		TRB.Functions.Bar:ApplyBarGroupsLayout(specCacheEntry, TRB.Frames.barGroups)
		TRB.Functions.Bar:ApplyBarGroupsAppearance(specCacheEntry, TRB.Frames.barGroups)
	end
end

---Generates the primary bar dimensions options section: width, height, position, border, anchor controls, and global settings toggle.
---@param parent Frame # The parent scroll child frame
---@param controls table # The controls table for storing created UI elements
---@param spec table # The spec settings table (e.g., specCacheEntry.settings)
---@param classId integer? # The WoW class ID (nil for the global options panel)
---@param specId integer? # The WoW specialization ID (nil for the global options panel)
---@param yCoord number # Starting Y coordinate for layout
function TRB.Functions.OptionsUi:GenerateBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	local maxBorderHeight = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))

	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	controls.barPositionSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarPositionSize"], oUi.xCoord, yCoord)

	-- Show Edit Mode informational notice
	yCoord = yCoord - 30
	controls.editModeNotice = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	controls.editModeNotice:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	controls.editModeNotice:SetWidth(550)
	controls.editModeNotice:SetJustifyH("LEFT")
	controls.editModeNotice:SetText("|cFFCCCCCC" .. L["EditModePositionOverrideNotice"] .. "|r")

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalBarDimensions = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_barDimensions", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalBarDimensions
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "resourceBar")
		f.tooltip = L["CheckboxUseGlobalTooltip_BarDimensions"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].bar)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].bar = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("bar")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "bar")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllBarDimensions", "bar", yCoord)
	end

	yCoord = yCoord - 40
	title = L["BarWidth"]
	controls.width = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinWidth, sanityCheckValues.barMaxWidth, spec.bar.width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.width:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.width = value

		local maxBorderSize = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.bar.border)
		controls.borderWidth:SetValue(borderSize)
		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
		end
	end)

	title = L["BarHeight"]
	controls.height = TRB.Functions.OptionsUi:BuildSlider(parent, title, sanityCheckValues.barMinHeight, sanityCheckValues.barMaxHeight, spec.bar.height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.height:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.height = value

		local maxBorderSize = math.min(math.floor(spec.bar.height / TRB.Data.constants.borderWidthFactor), math.floor(spec.bar.width / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec.bar.border)

		controls.borderWidth:SetMinMaxValues(0, maxBorderSize)
		controls.borderWidth.MaxLabel:SetText(tostring(maxBorderSize))
		controls.borderWidth.EditBox:SetText(tostring(borderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end

			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
		end
	end)

	-- Primary bar anchor block (ensure it exists)
	local primaryAnchor = EnsureAnchorBlock(spec.bar, "primary")

	title = L["BarHorizontalPosition"]
	yCoord = yCoord - 60
	controls.horizontal = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), primaryAnchor.xOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.horizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		a.xOffset = value
		DualWriteAnchorToLegacy(spec.bar)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = L["BarVerticalPosition"]
	controls.vertical = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), primaryAnchor.yOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.vertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		a.yOffset = value
		DualWriteAnchorToLegacy(spec.bar)

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = L["BarBorderWidth"]
	yCoord = yCoord - 60
	controls.borderWidth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec.bar.border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.borderWidth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.bar.border = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			AdjustBarBorder()
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
		end

		local minsliderWidth = math.max((spec.bar.border)*2+1, 120)
		local minsliderHeight = math.max((spec.bar.border)*2+1, 1)

		local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
		controls.height:SetMinMaxValues(minsliderHeight, scValues.barMaxHeight)
		controls.height.MinLabel:SetText(tostring(minsliderHeight))
		controls.width:SetMinMaxValues(minsliderWidth, scValues.barMaxWidth)
		controls.width.MinLabel:SetText(tostring(minsliderWidth))
	end)

	controls.dragAndDropMessage = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	controls.dragAndDropMessage:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	controls.dragAndDropMessage:SetWidth(oUi.maxOptionsWidth - oUi.xCoord2 - oUi.xPadding2)
	controls.dragAndDropMessage:SetJustifyH("LEFT")
	controls.dragAndDropMessage:SetText(L["DragAndDropEditModeMessage"])

	-- Primary bar anchor controls (Anchor To, Match Width, Anchor Point, Attach Point)
	local anchorPoints = TRB.Data.constants.anchorPoints
	-- Forward-declare dropdown locals so closures defined before CreateFrame can reference them
	local primaryAnchorPointDropdown
	local primaryAttachPointDropdown

	---Applies the current primary bar anchor layout to the active bar groups if the spec matches.
	local function ApplyPrimaryAnchorLayout()
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	-- "Anchor To" dropdown
	yCoord = yCoord - 40
	local primaryAnchorToDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barAnchorTo", parent, "WowStyle1DropdownTemplate")
	primaryAnchorToDropdown:SetWidth(oUi.sliderWidth)
	primaryAnchorToDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["AnchorToBarLabel"], L["Resource"]), oUi.xCoord, yCoord)
	primaryAnchorToDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given barKey is the current anchor target for the primary bar.
	---@param value string # The barKey to check (e.g., "screen", "secondary", "health")
	---@return boolean
	local function PrimaryAnchorToIsSelected(value)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		return value == a.barKey
	end

	---Sets the primary bar's anchor target to a new barKey after validating that it does not create a cycle.
	---@param newValue string # The new barKey to anchor to (e.g., "screen", "secondary", "health")
	local function PrimaryAnchorToSetSelected(newValue)
		local specBarKeys = TRB.Functions.Bar:GetAllBarKeysFromSettings(spec)
		local valid, err = TRB.Functions.Bar:ValidateAnchorTree(spec, nil, "primary", newValue, specBarKeys)
		if not valid then
			print("|cffff0000TRB:|r " .. (err or L["AnchorCycleError"]))
			return
		end
		local a = EnsureAnchorBlock(spec.bar, "primary")
		local oldBarKey = a.barKey
		a.barKey = newValue
		local transitioned = ApplyAnchorTransitionDefaults(a, oldBarKey, newValue)
		DualWriteAnchorToLegacy(spec.bar)
		-- Defer UI updates to avoid taint from secure menu callback context
		C_Timer.After(0, function()
			primaryAnchorToDropdown:SetDefaultText(TRB.Functions.Bar:GetBarDisplayName(newValue))
			-- Update UI controls if anchor type changed (screen â†” bar)
			if transitioned then
				controls.horizontal:SetValue(a.xOffset)
				controls.vertical:SetValue(a.yOffset)
				controls.checkBoxes.primaryMatchWidth:SetChecked(a.matchWidth)
				controls.checkBoxes.primaryMatchHeight:SetChecked(a.matchHeight or false)
				local anchorPointText = GetAnchorPointDisplayName(a.anchorPoint)
				local attachPointText = GetAnchorPointDisplayName(a.attachPoint)
				primaryAnchorPointDropdown:SetDefaultText(anchorPointText)
				primaryAttachPointDropdown:SetDefaultText(attachPointText)
				-- Force visual refresh: SetDefaultText alone may not update the displayed
				-- text when the dropdown has internal selection state from prior interaction.
				primaryAnchorPointDropdown:SetText(anchorPointText)
				primaryAttachPointDropdown:SetText(attachPointText)
			end
			controls.checkBoxes.primaryMatchWidth:SetEnabled(newValue ~= "screen")
			getglobal(controls.checkBoxes.primaryMatchWidth:GetName() .. 'Text'):SetFontObject(newValue ~= "screen" and GameFontHighlight or GameFontDisable)
			controls.checkBoxes.primaryMatchHeight:SetEnabled(newValue ~= "screen")
			getglobal(controls.checkBoxes.primaryMatchHeight:GetName() .. 'Text'):SetFontObject(newValue ~= "screen" and GameFontHighlight or GameFontDisable)
			ApplyPrimaryAnchorLayout()
		end)
	end

	---Populates the dropdown menu with available anchor targets for the primary bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function PrimaryAnchorToGenerator(dropdown, rootDescription)
		local specBarKeys = TRB.Functions.Bar:GetAllBarKeysFromSettings(spec)
		local targets = TRB.Functions.Bar:GetAvailableAnchorTargets("primary", spec, nil, specBarKeys)
		for _, barKey in ipairs(targets) do
			rootDescription:CreateRadio(TRB.Functions.Bar:GetBarDisplayName(barKey), PrimaryAnchorToIsSelected, PrimaryAnchorToSetSelected, barKey)
		end
	end
	primaryAnchorToDropdown:SetupMenu(PrimaryAnchorToGenerator)
	primaryAnchorToDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	primaryAnchorToDropdown:SetDefaultText(TRB.Functions.Bar:GetBarDisplayName(primaryAnchor.barKey))

	-- Match Width checkbox
	controls.checkBoxes.primaryMatchWidth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_barMatchWidth", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.primaryMatchWidth
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
	getglobal(f:GetName() .. 'Text'):SetText(L["MatchAnchorWidth"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["MatchAnchorWidthTooltip"]
	f:SetChecked(primaryAnchor.matchWidth)
	f:SetEnabled(primaryAnchor.barKey ~= "screen")
	getglobal(f:GetName() .. 'Text'):SetFontObject(primaryAnchor.barKey ~= "screen" and GameFontHighlight or GameFontDisable)
	f:SetScript("OnClick", function(self, ...)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		a.matchWidth = self:GetChecked()
		DualWriteAnchorToLegacy(spec.bar)
		ApplyPrimaryAnchorLayout()
	end)

	-- Match Height checkbox
	controls.checkBoxes.primaryMatchHeight = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_barMatchHeight", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.primaryMatchHeight
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-40)
	getglobal(f:GetName() .. 'Text'):SetText(L["MatchAnchorHeight"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["MatchAnchorHeightTooltip"]
	f:SetChecked(primaryAnchor.matchHeight or false)
	f:SetEnabled(primaryAnchor.barKey ~= "screen")
	getglobal(f:GetName() .. 'Text'):SetFontObject(primaryAnchor.barKey ~= "screen" and GameFontHighlight or GameFontDisable)
	f:SetScript("OnClick", function(self, ...)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		a.matchHeight = self:GetChecked()
		ApplyPrimaryAnchorLayout()
	end)

	-- Anchor Point dropdown (point on target bar/screen)
	yCoord = yCoord - 60
	primaryAnchorPointDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barAnchorPoint", parent, "WowStyle1DropdownTemplate")
	primaryAnchorPointDropdown:SetWidth(oUi.sliderWidth)
	primaryAnchorPointDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AnchorPoint"], oUi.xCoord, yCoord)
	primaryAnchorPointDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given anchor point matches the primary bar's current anchor point.
	---@param value string The anchor point to check (e.g., "CENTER", "TOPLEFT")
	---@return boolean
	local function PrimaryAnchorPointIsSelected(value)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		return value == a.anchorPoint
	end

	---Sets the primary bar's anchor point to a new value and applies the layout change.
	---@param newValue string The new anchor point (e.g., "CENTER", "TOPLEFT")
	local function PrimaryAnchorPointSetSelected(newValue)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		a.anchorPoint = newValue
		DualWriteAnchorToLegacy(spec.bar)
		C_Timer.After(0, function()
			primaryAnchorPointDropdown:SetDefaultText(GetAnchorPointDisplayName(newValue))
			ApplyPrimaryAnchorLayout()
		end)
	end

	---Populates the dropdown menu with anchor point options for the primary bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function PrimaryAnchorPointGenerator(dropdown, rootDescription)
		for _, pt in ipairs(anchorPoints) do
			rootDescription:CreateRadio(GetAnchorPointDisplayName(pt), PrimaryAnchorPointIsSelected, PrimaryAnchorPointSetSelected, pt)
		end
	end
	primaryAnchorPointDropdown:SetupMenu(PrimaryAnchorPointGenerator)
	primaryAnchorPointDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	primaryAnchorPointDropdown:SetDefaultText(GetAnchorPointDisplayName(primaryAnchor.anchorPoint))

	-- Attach Point dropdown (point on this bar)
	primaryAttachPointDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barAttachPoint", parent, "WowStyle1DropdownTemplate")
	primaryAttachPointDropdown:SetWidth(oUi.sliderWidth)
	primaryAttachPointDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AttachPoint"], oUi.xCoord2, yCoord)
	primaryAttachPointDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given anchor point matches the primary bar's current attach point.
	---@param value string The attach point to check (e.g., "CENTER", "BOTTOM")
	---@return boolean
	local function PrimaryAttachPointIsSelected(value)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		return value == a.attachPoint
	end

	---Sets the primary bar's attach point to a new value and applies the layout change.
	---@param newValue string The new attach point (e.g., "CENTER", "TOP")
	local function PrimaryAttachPointSetSelected(newValue)
		local a = EnsureAnchorBlock(spec.bar, "primary")
		a.attachPoint = newValue
		DualWriteAnchorToLegacy(spec.bar)
		C_Timer.After(0, function()
			primaryAttachPointDropdown:SetDefaultText(GetAnchorPointDisplayName(newValue))
			ApplyPrimaryAnchorLayout()
		end)
	end

	---Populates the dropdown menu with attach point options for the primary bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function PrimaryAttachPointGenerator(dropdown, rootDescription)
		for _, pt in ipairs(anchorPoints) do
			rootDescription:CreateRadio(GetAnchorPointDisplayName(pt), PrimaryAttachPointIsSelected, PrimaryAttachPointSetSelected, pt)
		end
	end
	primaryAttachPointDropdown:SetupMenu(PrimaryAttachPointGenerator)
	primaryAttachPointDropdown:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 30)
	primaryAttachPointDropdown:SetDefaultText(GetAnchorPointDisplayName(primaryAnchor.attachPoint))

	-- Fill Direction dropdown
	yCoord = yCoord - 60
	local fillDirectionOptions = {
		{ value = "leftRight",  label = L["FillDirectionLeftRight"] },
		{ value = "rightLeft",  label = L["FillDirectionRightLeft"] },
		{ value = "bottomTop",  label = L["FillDirectionBottomTop"] },
		{ value = "topBottom",  label = L["FillDirectionTopBottom"] },
	}

	local primaryFillDirectionDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barFillDirection", parent, "WowStyle1DropdownTemplate")
	primaryFillDirectionDropdown:SetWidth(oUi.sliderWidth)
	primaryFillDirectionDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FillDirection"], oUi.xCoord, yCoord)
	primaryFillDirectionDropdown.label.font:SetFontObject(GameFontNormal)

	local function GetFillDirectionLabel(value)
		for _, opt in ipairs(fillDirectionOptions) do
			if opt.value == value then return opt.label end
		end
		return L["FillDirectionLeftRight"]
	end

	local function PrimaryFillDirectionIsSelected(value)
		return value == (spec.bar.fillDirection or "leftRight")
	end

	local function PrimaryFillDirectionSetSelected(newValue)
		local oldValue = spec.bar.fillDirection or "leftRight"
		spec.bar.fillDirection = newValue
		C_Timer.After(0, function()
			primaryFillDirectionDropdown:SetDefaultText(GetFillDirectionLabel(newValue))
			local isVert = TRB.Functions.Bar:IsVerticalFill(newValue)
			local wasVert = TRB.Functions.Bar:IsVerticalFill(oldValue)

			-- Rotation: when crossing horizontal↔vertical boundary, swap dimensions/offsets/positions
			if wasVert ~= isVert then
				-- Swap bar width ↔ height; suppress OnValueChanged during bounds swap to prevent intermediate clamping
				spec.bar.width, spec.bar.height = spec.bar.height, spec.bar.width
				local wHandler = controls.width:GetScript("OnValueChanged")
				local hHandler = controls.height:GetScript("OnValueChanged")
				controls.width:SetScript("OnValueChanged", nil)
				controls.height:SetScript("OnValueChanged", nil)
				SwapSliderBounds(controls.width, controls.height)
				controls.width:SetValue(spec.bar.width)
				controls.width.EditBox:SetText(spec.bar.width)
				controls.height:SetValue(spec.bar.height)
				controls.height.EditBox:SetText(spec.bar.height)
				controls.width:SetScript("OnValueChanged", wHandler)
				controls.height:SetScript("OnValueChanged", hHandler)

				-- Rotate per-threshold icon override X/Y offsets and redraw
				RotateThresholdIconOffsets(spec, isVert)
				TRB.Functions.Threshold:RedrawThresholdLines()

				-- Refresh per-threshold icon override X/Y sliders if currently visible
				if controls.sliders and controls.sliders.thresholdIconXPos and controls.sliders.thresholdIconXPos:IsVisible() then
					local curX = controls.sliders.thresholdIconXPos:GetValue()
					local curY = controls.sliders.thresholdIconYPos:GetValue()
					local newX, newY
					if isVert then
						newX, newY = -(curY or 0), (curX or 0)
					else
						newX, newY = (curY or 0), -(curX or 0)
					end
					controls.sliders.thresholdIconXPos:SetValue(newX)
					controls.sliders.thresholdIconXPos.EditBox:SetText(newX)
					controls.sliders.thresholdIconYPos:SetValue(newY)
					controls.sliders.thresholdIconYPos.EditBox:SetText(newY)
				end

				-- Rotate bar text positions and reposition
				RotateBarTextPositions(spec, isVert)
				TRB.Functions.BarText:CreateBarTextFrames()

				-- Refresh bar text editor X/Y sliders if currently visible
				if controls.barTextHorizontal and controls.barTextHorizontal:IsVisible() then
					local curX = controls.barTextHorizontal:GetValue()
					local curY = controls.barTextVertical:GetValue()
					local newX, newY
					if isVert then
						newX, newY = -(curY or 0), (curX or 0)
					else
						newX, newY = (curY or 0), -(curX or 0)
					end
					controls.barTextHorizontal:SetValue(newX)
					controls.barTextVertical:SetValue(newY)
				end
			end

			ApplyPrimaryAnchorLayout()
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	local function PrimaryFillDirectionGenerator(dropdown, rootDescription)
		for _, opt in ipairs(fillDirectionOptions) do
			rootDescription:CreateRadio(opt.label, PrimaryFillDirectionIsSelected, PrimaryFillDirectionSetSelected, opt.value)
		end
	end
	primaryFillDirectionDropdown:SetupMenu(PrimaryFillDirectionGenerator)
	primaryFillDirectionDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	primaryFillDirectionDropdown:SetDefaultText(GetFillDirectionLabel(spec.bar.fillDirection or "leftRight"))

	yCoord = yCoord - 30

	return yCoord
end

---Configuration for ancillary bar dimension options
---@class TRB.Classes.OptionsUi.AncillaryBarConfig
---@field settingKey string The key in spec settings (e.g., "comboPoints", "healthBar", "manaBar")
---@field displayName string The localized display name for the bar
---@field primaryResourceString string? The primary resource name (for "relative to" label)
---@field globalSettingKey string? The key in global settings (nil if no global checkbox)
---@field globalTooltip string? Localized string for global checkbox tooltip
---@field sectionHeader string? Localized string for section header (defaults to SecondaryPositionAndSize formatted)
---@field includeSpacing boolean? Whether to include spacing slider (default false)
---@field includeGrowthDirection boolean? Whether to include growth direction dropdown (default false, for multi-node bars)
---@field widthDivisor number? Divisor for max width slider (default 1, use 6 for combo points)
---@field useSmallerSanityChecks boolean? Use comboPointsMaxHeight/Width instead of barMaxHeight/Width (default false)

---Generates dimension options for an ancillary bar (combo points, health bar, mana bar, etc.)
---@param parent Frame
---@param controls table
---@param spec table
---@param classId number?
---@param specId number?
---@param yCoord number
---@param config TRB.Classes.OptionsUi.AncillaryBarConfig
---@return number yCoord
function TRB.Functions.OptionsUi:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, config)
	local settingKey = config.settingKey
	local displayName = config.displayName
	local primaryResourceString = config.primaryResourceString or L["Resource"]
	local globalSettingKey = config.globalSettingKey
	local globalTooltip = config.globalTooltip
	local sectionHeader = config.sectionHeader or string.format(L["SecondaryPositionAndSize"], displayName)
	local includeSpacing = config.includeSpacing or false
	local widthDivisor = config.widthDivisor or 1
	local useSmallerSanityChecks = config.useSmallerSanityChecks or false

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	local initAnchor = EnsureAnchorBlock(spec[settingKey])
	local initEffectiveWidth = initAnchor.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, initAnchor.barKey) or spec[settingKey].width
	local maxBorderHeight = math.min(math.floor(spec[settingKey].height / TRB.Data.constants.borderWidthFactor), math.floor(initEffectiveWidth / TRB.Data.constants.borderWidthFactor))

	local sanityCheckValues = TRB.Functions.Bar:GetSanityCheckValues(spec)

	-- Section header
	controls[settingKey .. "PositionSection"] = TRB.Functions.OptionsUi:BuildSectionHeader(parent, sectionHeader, oUi.xCoord, yCoord)

	-- Global checkbox (if applicable)
	if globalSettingKey and classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes["useGlobal" .. settingKey:gsub("^%l", string.upper)] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .."_useGlobal_" .. settingKey, parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes["useGlobal" .. settingKey:gsub("^%l", string.upper)]
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		local globalSettingDef = TRB.Functions.OptionsUi.GlobalSettings:GetGlobalSettingDefinition(globalSettingKey)
		if globalSettingDef and globalSettingDef.tabKey then
			TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, globalSettingDef.tabKey)
		end
		f.tooltip = globalTooltip or L["CheckboxUseGlobalTooltip_ComboPoints"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName][globalSettingKey])
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName][globalSettingKey] = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				C_Timer.After(0, function()
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end)
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox(globalSettingKey)
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, globalSettingKey)
	elseif globalSettingKey and classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAll" .. settingKey:gsub("^%l", string.upper), globalSettingKey, yCoord)
	end

	-- Width and Height sliders
	local maxWidthValue = TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / widthDivisor, 0, "floor")
	local maxHeightValue = sanityCheckValues.barMaxHeight

	yCoord = yCoord - 40
	title = string.format(L["SecondaryWidth"], displayName)
	controls[settingKey .. "Width"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, maxWidthValue, spec[settingKey].width, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "Width"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].width = value

		local a = EnsureAnchorBlock(spec[settingKey])
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or spec[settingKey].width
		local maxBorderSize = math.min(math.floor(spec[settingKey].height / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec[settingKey].border)
		controls[settingKey .. "BorderWidth"]:SetValue(borderSize)
		controls[settingKey .. "BorderWidth"]:SetMinMaxValues(0, maxBorderSize)
		controls[settingKey .. "BorderWidth"].MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = string.format(L["SecondaryHeight"], displayName)
	controls[settingKey .. "Height"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, 1, maxHeightValue, spec[settingKey].height, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[settingKey .. "Height"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].height = value

		local a = EnsureAnchorBlock(spec[settingKey])
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or spec[settingKey].width
		local maxBorderSize = math.min(math.floor(spec[settingKey].height / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec[settingKey].border)
		controls[settingKey .. "BorderWidth"]:SetMinMaxValues(0, maxBorderSize)
		controls[settingKey .. "BorderWidth"].MaxLabel:SetText(tostring(maxBorderSize))
		controls[settingKey .. "BorderWidth"].EditBox:SetText(tostring(borderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	-- Horizontal and Vertical offset sliders (read/write anchor block, dual-write to legacy)
	local anchor = EnsureAnchorBlock(spec[settingKey])

	title = string.format(L["SecondaryHorizontalPosition"], displayName)
	yCoord = yCoord - 60
	controls[settingKey .. "Horizontal"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxWidth/2), math.floor(sanityCheckValues.barMaxWidth/2), anchor.xOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "Horizontal"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		local a = EnsureAnchorBlock(spec[settingKey])
		a.xOffset = value
		DualWriteAnchorToLegacy(spec[settingKey])

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	title = string.format(L["SecondaryVerticalPosition"], displayName)
	controls[settingKey .. "Vertical"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, math.ceil(-sanityCheckValues.barMaxHeight/2), math.floor(sanityCheckValues.barMaxHeight/2), anchor.yOffset, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[settingKey .. "Vertical"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		local a = EnsureAnchorBlock(spec[settingKey])
		a.yOffset = value
		DualWriteAnchorToLegacy(spec[settingKey])

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	-- Border width slider
	title = string.format(L["SecondaryBorderWidth"], displayName)
	yCoord = yCoord - 60
	controls[settingKey .. "BorderWidth"] = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, maxBorderHeight, spec[settingKey].border, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[settingKey .. "BorderWidth"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec[settingKey].border = value

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end

		local aB = EnsureAnchorBlock(spec[settingKey])
		local effectiveWidth = aB.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, aB.barKey) or spec[settingKey].width
		local minsliderWidth = math.max(spec[settingKey].border*2, 1)
		local minsliderHeight = math.max(spec[settingKey].border*2, 1)

		local scValues = TRB.Functions.Bar:GetSanityCheckValues(spec)
		local scMaxHeight = useSmallerSanityChecks and scValues.comboPointsMaxHeight or scValues.barMaxHeight
		local scMaxWidth = useSmallerSanityChecks and scValues.comboPointsMaxWidth or scValues.barMaxWidth
		controls[settingKey .. "Height"]:SetMinMaxValues(minsliderHeight, scMaxHeight)
		controls[settingKey .. "Height"].MinLabel:SetText(tostring(minsliderHeight))
		if not aB.matchWidth then
			controls[settingKey .. "Width"]:SetMinMaxValues(minsliderWidth, scMaxWidth)
			controls[settingKey .. "Width"].MinLabel:SetText(tostring(minsliderWidth))
		end
	end)

	-- Spacing slider (if applicable)
	if includeSpacing then
		title = string.format(L["SecondarySpacing"], displayName)
		controls.comboPointSpacing = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, TRB.Functions.Number:RoundTo(sanityCheckValues.barMaxWidth / 6, 0, "floor"), spec.comboPoints.spacing, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.comboPointSpacing:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			spec.comboPoints.spacing = value

			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)

		-- Collapse border width checkbox (below spacing slider)
		controls.checkBoxes.collapseBorderWidth = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "CollapseBorderWidth", parent, "ChatConfigCheckButtonTemplate")
		local cbCollapse = controls.checkBoxes.collapseBorderWidth
		cbCollapse:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 40)
		getglobal(cbCollapse:GetName() .. 'Text'):SetText(L["CollapseBorderWidth"])
		---@diagnostic disable-next-line: inject-field
		cbCollapse.tooltip = L["CollapseBorderWidthTooltip"]
		cbCollapse:SetChecked(spec.comboPoints.collapseBorderWidth)
		TRB.Functions.OptionsUi:ToggleSliderEnabled(controls.comboPointSpacing, not spec.comboPoints.collapseBorderWidth)
		cbCollapse:SetScript("OnClick", function(self, ...)
			spec.comboPoints.collapseBorderWidth = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleSliderEnabled(controls.comboPointSpacing, not spec.comboPoints.collapseBorderWidth)

			if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
				if TRB.Frames.barGroups ~= nil then
					TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				end
			end
		end)
	end

	-- Anchor To dropdown + Match Width checkbox
	yCoord = yCoord - 40

	local thisBarKey = TRB.Functions.Bar:GetBarKeyFromSettingsKey(settingKey)
	local anchorPoints = TRB.Data.constants.anchorPoints

	-- Forward-declare dropdown variables referenced in callbacks
	local anchorPointDropdown, attachPointDropdown

	---Applies the current ancillary bar anchor layout to the active bar groups if the spec matches.
	local function ApplyAnchorLayout()
		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end

	-- "Anchor To" dropdown
	local anchorToDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "AnchorTo", parent, "WowStyle1DropdownTemplate")
	anchorToDropdown:SetWidth(oUi.sliderWidth)
	anchorToDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["AnchorToBarLabel"], displayName), oUi.xCoord, yCoord)
	anchorToDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given barKey is the current anchor target for this ancillary bar.
	---@param value string The barKey to check
	---@return boolean
	local function AnchorToIsSelected(value)
		local a = EnsureAnchorBlock(spec[settingKey])
		return value == a.barKey
	end

	---Sets the ancillary bar's anchor target to a new barKey after validating it does not create an anchor cycle.
	---@param newValue string The new barKey to anchor to
	local function AnchorToSetSelected(newValue)
		-- Validate no cycle
		local specBarKeys = TRB.Functions.Bar:GetAllBarKeysFromSettings(spec)
		local valid, err = TRB.Functions.Bar:ValidateAnchorTree(spec, nil, thisBarKey, newValue, specBarKeys)
		if not valid then
			print("|cffff0000TRB:|r " .. (err or L["AnchorCycleError"]))
			return
		end
		local a = EnsureAnchorBlock(spec[settingKey])
		local oldBarKey = a.barKey
		a.barKey = newValue
		local transitioned = ApplyAnchorTransitionDefaults(a, oldBarKey, newValue)
		DualWriteAnchorToLegacy(spec[settingKey])
		-- Defer UI updates to avoid taint from secure menu callback context
		C_Timer.After(0, function()
			anchorToDropdown:SetDefaultText(TRB.Functions.Bar:GetBarDisplayName(newValue))
			-- Update UI controls if anchor type changed (screen â†” bar)
			if transitioned then
				controls[settingKey .. "Horizontal"]:SetValue(a.xOffset)
				controls[settingKey .. "Vertical"]:SetValue(a.yOffset)
				controls.checkBoxes[settingKey .. "MatchWidth"]:SetChecked(a.matchWidth)
				controls.checkBoxes[settingKey .. "MatchHeight"]:SetChecked(a.matchHeight or false)
				local anchorPointText = GetAnchorPointDisplayName(a.anchorPoint)
				local attachPointText = GetAnchorPointDisplayName(a.attachPoint)
				anchorPointDropdown:SetDefaultText(anchorPointText)
				attachPointDropdown:SetDefaultText(attachPointText)
				-- Force visual refresh: SetDefaultText alone may not update the displayed
				-- text when the dropdown has internal selection state from prior interaction.
				anchorPointDropdown:SetText(anchorPointText)
				attachPointDropdown:SetText(attachPointText)
			end
			local matchWidthCb = controls.checkBoxes[settingKey .. "MatchWidth"]
			matchWidthCb:SetEnabled(newValue ~= "screen")
			getglobal(matchWidthCb:GetName() .. 'Text'):SetFontObject(newValue ~= "screen" and GameFontHighlight or GameFontDisable)
			local matchHeightCb = controls.checkBoxes[settingKey .. "MatchHeight"]
			matchHeightCb:SetEnabled(newValue ~= "screen")
			getglobal(matchHeightCb:GetName() .. 'Text'):SetFontObject(newValue ~= "screen" and GameFontHighlight or GameFontDisable)
			ApplyAnchorLayout()
		end)
	end

	---Populates the dropdown menu with available anchor targets for this ancillary bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function AnchorToGenerator(dropdown, rootDescription)
		-- Build list of valid targets
		local specBarKeys = TRB.Functions.Bar:GetAllBarKeysFromSettings(spec)
		local targets = TRB.Functions.Bar:GetAvailableAnchorTargets(thisBarKey, spec, nil, specBarKeys)
		for _, barKey in ipairs(targets) do
			rootDescription:CreateRadio(TRB.Functions.Bar:GetBarDisplayName(barKey), AnchorToIsSelected, AnchorToSetSelected, barKey)
		end
	end
	anchorToDropdown:SetupMenu(AnchorToGenerator)
	anchorToDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	anchorToDropdown:SetDefaultText(TRB.Functions.Bar:GetBarDisplayName(anchor.barKey))

	-- Match Width checkbox
	controls.checkBoxes[settingKey .. "MatchWidth"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "MatchWidth", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[settingKey .. "MatchWidth"]
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-20)
	getglobal(f:GetName() .. 'Text'):SetText(L["MatchAnchorWidth"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["MatchAnchorWidthTooltip"]
	f:SetChecked(anchor.matchWidth)
	f:SetEnabled(anchor.barKey ~= "screen")
	getglobal(f:GetName() .. 'Text'):SetFontObject(anchor.barKey ~= "screen" and GameFontHighlight or GameFontDisable)
	f:SetScript("OnClick", function(self, ...)
		local a = EnsureAnchorBlock(spec[settingKey])
		a.matchWidth = self:GetChecked()
		DualWriteAnchorToLegacy(spec[settingKey])

		-- Update border max based on new effective width
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or spec[settingKey].width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or spec[settingKey].height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec[settingKey].border)
		controls[settingKey .. "BorderWidth"]:SetValue(borderSize)
		controls[settingKey .. "BorderWidth"]:SetMinMaxValues(0, maxBorderSize)
		controls[settingKey .. "BorderWidth"].MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Data.character.classId == 11 or -- HACK: Workaround for Druids sharing settings across forms
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	-- Match Height checkbox
	controls.checkBoxes[settingKey .. "MatchHeight"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "MatchHeight", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[settingKey .. "MatchHeight"]
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-40)
	getglobal(f:GetName() .. 'Text'):SetText(L["MatchAnchorHeight"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["MatchAnchorHeightTooltip"]
	f:SetChecked(anchor.matchHeight or false)
	f:SetEnabled(anchor.barKey ~= "screen")
	getglobal(f:GetName() .. 'Text'):SetFontObject(anchor.barKey ~= "screen" and GameFontHighlight or GameFontDisable)
	f:SetScript("OnClick", function(self, ...)
		local a = EnsureAnchorBlock(spec[settingKey])
		a.matchHeight = self:GetChecked()

		-- Update border max based on new effective dimensions
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or spec[settingKey].width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or spec[settingKey].height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, spec[settingKey].border)
		controls[settingKey .. "BorderWidth"]:SetValue(borderSize)
		controls[settingKey .. "BorderWidth"]:SetMinMaxValues(0, maxBorderSize)
		controls[settingKey .. "BorderWidth"].MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Data.character.classId == 11 or
			(TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) or
			(classId == nil and specId == nil and TRB.Data.settings.core.global[TRB.Data.character.className][TRB.Data.character.specName].bar) then
			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
			end
		end
	end)

	-- Anchor Point dropdown (point on target bar)
	yCoord = yCoord - 60

	anchorPointDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "AnchorPoint", parent, "WowStyle1DropdownTemplate")
	anchorPointDropdown:SetWidth(oUi.sliderWidth)
	anchorPointDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AnchorPoint"], oUi.xCoord, yCoord)
	anchorPointDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given value matches the ancillary bar's current anchor point.
	---@param value string The anchor point to check
	---@return boolean
	local function AnchorPointIsSelected(value)
		local a = EnsureAnchorBlock(spec[settingKey])
		return value == a.anchorPoint
	end

	---Sets the ancillary bar's anchor point to a new value and applies the layout change.
	---@param newValue string The new anchor point
	local function AnchorPointSetSelected(newValue)
		local a = EnsureAnchorBlock(spec[settingKey])
		a.anchorPoint = newValue
		DualWriteAnchorToLegacy(spec[settingKey])
		C_Timer.After(0, function()
			anchorPointDropdown:SetDefaultText(GetAnchorPointDisplayName(newValue))
			ApplyAnchorLayout()
		end)
	end

	---Populates the dropdown menu with anchor point options for this ancillary bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function AnchorPointGenerator(dropdown, rootDescription)
		for _, pt in ipairs(anchorPoints) do
			rootDescription:CreateRadio(GetAnchorPointDisplayName(pt), AnchorPointIsSelected, AnchorPointSetSelected, pt)
		end
	end
	anchorPointDropdown:SetupMenu(AnchorPointGenerator)
	anchorPointDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	anchorPointDropdown:SetDefaultText(GetAnchorPointDisplayName(anchor.anchorPoint))

	-- Attach Point dropdown (point on this bar)
	attachPointDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "AttachPoint", parent, "WowStyle1DropdownTemplate")
	attachPointDropdown:SetWidth(oUi.sliderWidth)
	attachPointDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AttachPoint"], oUi.xCoord2, yCoord)
	attachPointDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given value matches the ancillary bar's current attach point.
	---@param value string The attach point to check
	---@return boolean
	local function AttachPointIsSelected(value)
		local a = EnsureAnchorBlock(spec[settingKey])
		return value == a.attachPoint
	end

	---Sets the ancillary bar's attach point to a new value and applies the layout change.
	---@param newValue string The new attach point
	local function AttachPointSetSelected(newValue)
		local a = EnsureAnchorBlock(spec[settingKey])
		a.attachPoint = newValue
		DualWriteAnchorToLegacy(spec[settingKey])
		C_Timer.After(0, function()
			attachPointDropdown:SetDefaultText(GetAnchorPointDisplayName(newValue))
			ApplyAnchorLayout()
		end)
	end

	---Populates the dropdown menu with attach point options for this ancillary bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function AttachPointGenerator(dropdown, rootDescription)
		for _, pt in ipairs(anchorPoints) do
			rootDescription:CreateRadio(GetAnchorPointDisplayName(pt), AttachPointIsSelected, AttachPointSetSelected, pt)
		end
	end
	attachPointDropdown:SetupMenu(AttachPointGenerator)
	attachPointDropdown:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 30)
	attachPointDropdown:SetDefaultText(GetAnchorPointDisplayName(anchor.attachPoint))

	-- Fill Direction dropdown
	yCoord = yCoord - 60
	local ancFillDirectionOptions = {
		{ value = "leftRight",  label = L["FillDirectionLeftRight"] },
		{ value = "rightLeft",  label = L["FillDirectionRightLeft"] },
		{ value = "bottomTop",  label = L["FillDirectionBottomTop"] },
		{ value = "topBottom",  label = L["FillDirectionTopBottom"] },
	}
	local ancFillDirectionDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "FillDirection", parent, "WowStyle1DropdownTemplate")
	ancFillDirectionDropdown:SetWidth(oUi.sliderWidth)
	ancFillDirectionDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FillDirection"], oUi.xCoord, yCoord)
	ancFillDirectionDropdown.label.font:SetFontObject(GameFontNormal)

	local function GetAncFillDirectionLabel(value)
		for _, opt in ipairs(ancFillDirectionOptions) do
			if opt.value == value then return opt.label end
		end
		return L["FillDirectionLeftRight"]
	end

	local function AncFillDirectionIsSelected(value)
		return value == (spec[settingKey].fillDirection or "leftRight")
	end

	local function AncFillDirectionSetSelected(newValue)
		local oldValue = spec[settingKey].fillDirection or "leftRight"
		spec[settingKey].fillDirection = newValue
		C_Timer.After(0, function()
			ancFillDirectionDropdown:SetDefaultText(GetAncFillDirectionLabel(newValue))
			local isVert = TRB.Functions.Bar:IsVerticalFill(newValue)
			local wasVert = TRB.Functions.Bar:IsVerticalFill(oldValue)

			-- Rotation: swap width ↔ height when crossing horizontal↔vertical boundary
			if wasVert ~= isVert then
				spec[settingKey].width, spec[settingKey].height = spec[settingKey].height, spec[settingKey].width
				local wKey = settingKey .. "Width"
				local hKey = settingKey .. "Height"
				local wHandler = controls[wKey]:GetScript("OnValueChanged")
				local hHandler = controls[hKey]:GetScript("OnValueChanged")
				controls[wKey]:SetScript("OnValueChanged", nil)
				controls[hKey]:SetScript("OnValueChanged", nil)
				SwapSliderBounds(controls[wKey], controls[hKey])
				controls[wKey]:SetValue(spec[settingKey].width)
				controls[wKey].EditBox:SetText(spec[settingKey].width)
				controls[hKey]:SetValue(spec[settingKey].height)
				controls[hKey].EditBox:SetText(spec[settingKey].height)
				controls[wKey]:SetScript("OnValueChanged", wHandler)
				controls[hKey]:SetScript("OnValueChanged", hHandler)

				RotateBarTextPositions(spec, isVert, thisBarKey, classId, specId)
				TRB.Functions.BarText:CreateBarTextFrames()
			end

			ApplyAnchorLayout()
			TRB.Functions.Character:ResetCaches()
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	local function AncFillDirectionGenerator(dropdown, rootDescription)
		for _, opt in ipairs(ancFillDirectionOptions) do
			rootDescription:CreateRadio(opt.label, AncFillDirectionIsSelected, AncFillDirectionSetSelected, opt.value)
		end
	end
	ancFillDirectionDropdown:SetupMenu(AncFillDirectionGenerator)
	ancFillDirectionDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	ancFillDirectionDropdown:SetDefaultText(GetAncFillDirectionLabel(spec[settingKey].fillDirection or "leftRight"))

	-- Growth Direction dropdown (multi-node bars only)
	local includeGrowthDirection = config.includeGrowthDirection or false
	if includeGrowthDirection then
		local ancGrowthDirectionOptions = {
			{ value = "leftRight",  label = L["GrowthDirectionLeftRight"] },
			{ value = "rightLeft",  label = L["GrowthDirectionRightLeft"] },
			{ value = "bottomTop",  label = L["GrowthDirectionBottomTop"] },
			{ value = "topBottom",  label = L["GrowthDirectionTopBottom"] },
		}
		local ancGrowthDirectionDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. settingKey .. "GrowthDirection", parent, "WowStyle1DropdownTemplate")
		controls[settingKey .. "GrowthDirectionDropdown"] = ancGrowthDirectionDropdown
		ancGrowthDirectionDropdown:SetWidth(oUi.sliderWidth)
		ancGrowthDirectionDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["GrowthDirection"], oUi.xCoord2, yCoord)
		ancGrowthDirectionDropdown.label.font:SetFontObject(GameFontNormal)

		local function GetAncGrowthDirectionLabel(value)
			for _, opt in ipairs(ancGrowthDirectionOptions) do
				if opt.value == value then return opt.label end
			end
			return L["GrowthDirectionLeftRight"]
		end

		local function AncGrowthDirectionIsSelected(value)
			return value == (spec[settingKey].growthDirection or "leftRight")
		end

		local function AncGrowthDirectionSetSelected(newValue)
			spec[settingKey].growthDirection = newValue
			C_Timer.After(0, function()
				ancGrowthDirectionDropdown:SetDefaultText(GetAncGrowthDirectionLabel(newValue))
				ApplyAnchorLayout()
				TRB.Functions.Character:ResetCaches()
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end)
		end

		local function AncGrowthDirectionGenerator(dropdown, rootDescription)
			for _, opt in ipairs(ancGrowthDirectionOptions) do
				rootDescription:CreateRadio(opt.label, AncGrowthDirectionIsSelected, AncGrowthDirectionSetSelected, opt.value)
			end
		end
		ancGrowthDirectionDropdown:SetupMenu(AncGrowthDirectionGenerator)
		ancGrowthDirectionDropdown:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 30)
		ancGrowthDirectionDropdown:SetDefaultText(GetAncGrowthDirectionLabel(spec[settingKey].growthDirection or "leftRight"))
	end

	yCoord = yCoord - 30

	return yCoord
end

---Legacy wrapper for combo point dimension options. Delegates to GenerateAncillaryBarDimensionsOptions.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer? Class ID (nil for global panel)
---@param specId integer? Spec ID (nil for global panel)
---@param yCoord number Starting Y coordinate
---@param primaryResourceString string? Localized primary resource name (defaults to "Energy")
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@param includeSpacing boolean? Whether to include a spacing slider (defaults to true)
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateComboPointDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, secondaryResourceString, includeSpacing)
	if primaryResourceString == nil then
		primaryResourceString = L["ResourceEnergy"]
	end

	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	if includeSpacing == nil then
		includeSpacing = true
	end

	return TRB.Functions.OptionsUi:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, {
		settingKey = "comboPoints",
		displayName = secondaryResourceString,
		primaryResourceString = primaryResourceString,
		globalSettingKey = "comboPoints",
		globalTooltip = L["CheckboxUseGlobalTooltip_ComboPoints"],
		includeSpacing = includeSpacing,
		includeGrowthDirection = true,
		widthDivisor = 6,
		useSmallerSanityChecks = true
	})
end

---Generates the optional partial-fill color controls for a secondary node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateSecondaryPartialFillColorOptions(parent, controls, spec, classId, specId, yCoord, secondaryResourceString)
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	spec.colors = spec.colors or {}
	spec.colors.comboPoints = spec.colors.comboPoints or {}
	spec.colors.comboPoints.regenerating = spec.colors.comboPoints.regenerating or TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false)

	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.checkBoxes = controls.checkBoxes or {}

	local frameName = "TwintopResourceBar_SecondaryPartialFillColor_" .. tostring(classId) .. "_" .. tostring(specId)
	controls.checkBoxes.secondaryPartialFillColor = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	local checkBox = controls.checkBoxes.secondaryPartialFillColor
	checkBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(checkBox:GetName() .. 'Text'):SetText(string.format(L["SecondaryPartialFillColorCheckbox"], secondaryResourceString))
	checkBox.tooltip = string.format(L["SecondaryPartialFillColorCheckboxTooltip"], secondaryResourceString)
	checkBox:SetChecked(spec.colors.comboPoints.regenerating.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.regenerating.enabled = self:GetChecked()
	end)

	controls.colors.comboPoints.regenerating = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["SecondaryPartialFillColorPicker"], secondaryResourceString), spec.colors.comboPoints.regenerating, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = controls.colors.comboPoints.regenerating
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "regenerating")
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.regenerating, self)
	end)

	return yCoord - 30
end

---Generates partial-fill color controls for a custom multi-node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition Custom bar definition
---@param resourceString string Localized resource/spell name for display labels
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarPartialFillColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, resourceString)
	local colorSettings = barTypeDef:GetColors(spec)
	if colorSettings == nil then
		return yCoord
	end

	colorSettings.regenerating = colorSettings.regenerating or TRB.Functions.Settings:DefaultSecondaryPartialFillColor(false)

	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	controls.checkBoxes = controls.checkBoxes or {}

	local colorControls = controls.colors.bars[barTypeDef.key]
	local frameName = "TwintopResourceBar_CustomBarPartialFillColor_" .. barTypeDef.key .. "_" .. tostring(classId) .. "_" .. tostring(specId)
	controls.checkBoxes[barTypeDef.key .. "PartialFillColor"] = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	local checkBox = controls.checkBoxes[barTypeDef.key .. "PartialFillColor"]
	checkBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(checkBox:GetName() .. 'Text'):SetText(string.format(L["SecondaryPartialFillColorCheckbox"], resourceString))
	checkBox.tooltip = string.format(L["SecondaryPartialFillColorCheckboxTooltip"], resourceString)
	checkBox:SetChecked(colorSettings.regenerating.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		colorSettings.regenerating.enabled = self:GetChecked()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) and TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	colorControls.regenerating = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["SecondaryPartialFillColorPicker"], resourceString), colorSettings.regenerating, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = colorControls.regenerating
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "regenerating", nil, nil, classId, specId)
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.regenerating, self, classId, specId)
	end)

	return yCoord - 30
end

---Generates casting overlay color controls for a secondary node bar.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer Class ID
---@param specId integer Spec ID
---@param yCoord number Starting Y coordinate
---@param secondaryResourceString string? Localized secondary resource name (defaults to "Combo Points")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateSecondaryCastingOverlayOptions(parent, controls, spec, classId, specId, yCoord, secondaryResourceString)
	if secondaryResourceString == nil then
		secondaryResourceString = L["ResourceComboPoints"]
	end

	spec.colors = spec.colors or {}
	spec.colors.comboPoints = spec.colors.comboPoints or {}
	spec.colors.comboPoints.casting = spec.colors.comboPoints.casting or TRB.Functions.Settings:DefaultSecondaryCastingOverlayColor(true)

	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.checkBoxes = controls.checkBoxes or {}

	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local frameName = "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SecondaryCastingOverlay"

	controls.colors.comboPoints.casting = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["SecondaryCastingOverlayColorPicker"], secondaryResourceString), spec.colors.comboPoints.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	local colorPicker = controls.colors.comboPoints.casting
	colorPicker.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "casting")
	end)
	colorPicker.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.casting, self, classId, specId)
	end)

	controls.checkBoxes.secondaryCastingOverlayEnabled = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	local checkBox = controls.checkBoxes.secondaryCastingOverlayEnabled
	checkBox:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(checkBox:GetName() .. 'Text'):SetText(string.format(L["SecondaryCastingOverlayCheckbox"], secondaryResourceString))
	checkBox.tooltip = string.format(L["SecondaryCastingOverlayCheckboxTooltip"], secondaryResourceString)
	checkBox:SetChecked(spec.colors.comboPoints.casting.enabled)
	controls.checkBoxes.secondaryCastingOverlayFullHeight = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SecondaryCastingOverlayFullHeight", parent, "ChatConfigCheckButtonTemplate")
	local fullHeightCheckBox = controls.checkBoxes.secondaryCastingOverlayFullHeight
	fullHeightCheckBox:SetPoint("TOPLEFT", oUi.xCoord + (oUi.xPadding * 2), yCoord - 18)
	getglobal(fullHeightCheckBox:GetName() .. 'Text'):SetText(L["OverlayFullHeightCheckbox"])
	fullHeightCheckBox.tooltip = L["OverlayFullHeightCheckboxTooltip"]
	fullHeightCheckBox:SetChecked(spec.colors.comboPoints.casting.fullHeight == true)
	fullHeightCheckBox:SetScript("OnClick", function(self)
		spec.colors.comboPoints.casting.fullHeight = self:GetChecked()
		TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
	end)
	yCoord = yCoord - 45
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.secondaryCastingOverlayFullHeight, spec.colors.comboPoints.casting.enabled)
	checkBox:SetScript("OnClick", function(self, ...)
		spec.colors.comboPoints.casting.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.secondaryCastingOverlayFullHeight, spec.colors.comboPoints.casting.enabled)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	return yCoord
end

---Legacy wrapper for health bar dimension options. Delegates to GenerateAncillaryBarDimensionsOptions.
---@param parent Frame Parent frame for the controls
---@param controls table Table to store control references
---@param spec table Spec settings table
---@param classId integer? Class ID (nil for global panel)
---@param specId integer? Spec ID (nil for global panel)
---@param yCoord number Starting Y coordinate
---@param primaryResourceString string? Localized primary resource name (defaults to "Mana")
---@return number yCoord New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateHealthBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString)
	if primaryResourceString == nil then
		primaryResourceString = L["ResourceMana"]
	end

	return TRB.Functions.OptionsUi:GenerateAncillaryBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, {
		settingKey = "healthBar",
		displayName = L["HealthBar"],
		primaryResourceString = primaryResourceString,
		globalSettingKey = "healthBar",
		globalTooltip = L["CheckboxUseGlobalTooltip_HealthBar"],
		sectionHeader = L["HealthBarPositionAndSize"],
		includeSpacing = false,
		widthDivisor = 1,
		useSmallerSanityChecks = false
	})
end

--[[
	Custom Bar Options UI Functions
	These functions work with bars stored under settings.bars.<key>, settings.colors.bars.<key>,
	and settings.textures.bars.<key> using the BarTypeDefinition system.
]]

---Generates dimension options for a custom bar
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@param primaryResourceString string # Primary resource name for "relative to" label
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarDimensionsOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, primaryResourceString)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil

	-- Get the bar settings from the nested structure
	local barSettings = barTypeDef:GetSettings(spec)
	if not barSettings then
		return yCoord
	end

	local displayName = barTypeDef.displayName

	-- Section header
	local headerText = string.format(L["SecondaryPositionAndSize"], displayName)
	controls[barTypeDef.key .. "DimensionsSection"] = TRB.Functions.OptionsUi:BuildSectionHeader(parent, headerText, oUi.xCoord, yCoord)

	-- Width slider
	yCoord = yCoord - 40
	local widthMin = barTypeDef.isMultiNode and 10 or 30
	local widthMax = (TRB.Data.sanityCheckValues.barMaxWidth and TRB.Data.sanityCheckValues.barMaxWidth > 0) and TRB.Data.sanityCheckValues.barMaxWidth or 300
	local widthDivisor = barTypeDef.isMultiNode and 6 or 1

	controls[barTypeDef.key .. "Width"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryWidth"], displayName),
		widthMin, math.ceil(widthMax / widthDivisor), barSettings.width, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "Width"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.width = value

		local a = EnsureAnchorBlock(barSettings)
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or barSettings.width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetValue(borderSize)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- Height slider
	controls[barTypeDef.key .. "Height"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryHeight"], displayName),
		1, (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100, barSettings.height, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[barTypeDef.key .. "Height"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.height = value

		local a = EnsureAnchorBlock(barSettings)
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or barSettings.width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))
		controls[barTypeDef.key .. "Border"].EditBox:SetText(tostring(borderSize))

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- X/Y Offset sliders (read/write anchor block, dual-write to legacy)
	yCoord = yCoord - 60
	local anchor = EnsureAnchorBlock(barSettings)

	local xPosMax = (TRB.Data.sanityCheckValues.barMaxWidth and TRB.Data.sanityCheckValues.barMaxWidth > 0) and TRB.Data.sanityCheckValues.barMaxWidth or 300
	controls[barTypeDef.key .. "XPos"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryHorizontalPosition"], displayName),
		math.ceil(-xPosMax / 2), math.floor(xPosMax / 2), anchor.xOffset, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "XPos"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		local a = EnsureAnchorBlock(barSettings)
		a.xOffset = value
		DualWriteAnchorToLegacy(barSettings)

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- Y Offset slider
	local yPosMax = (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100
	controls[barTypeDef.key .. "YPos"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryVerticalPosition"], displayName),
		math.ceil(-yPosMax / 2), math.floor(yPosMax / 2), anchor.yOffset, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls[barTypeDef.key .. "YPos"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		local a = EnsureAnchorBlock(barSettings)
		a.yOffset = value
		DualWriteAnchorToLegacy(barSettings)

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- Border slider
	yCoord = yCoord - 60
	-- When matchWidth is checked, use anchor bar dimensions for border max
	local effectiveWidthForBorder = anchor.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, anchor.barKey) or barSettings.width
	local effectiveHeightForBorder = anchor.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, anchor.barKey) or barSettings.height
	local maxBorderHeight = math.min(math.floor(effectiveHeightForBorder / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidthForBorder / TRB.Data.constants.borderWidthFactor))
	controls[barTypeDef.key .. "Border"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondaryBorderWidth"], displayName),
		0, maxBorderHeight, barSettings.border, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls[barTypeDef.key .. "Border"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		barSettings.border = value

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end

		local minSliderWidth = math.max(barSettings.border * 2 + 1, widthMin)
		local minSliderHeight = math.max(barSettings.border * 2 + 1, 1)
		local heightSliderMax = (TRB.Data.sanityCheckValues.barMaxHeight and TRB.Data.sanityCheckValues.barMaxHeight > 0) and TRB.Data.sanityCheckValues.barMaxHeight or 100

		controls[barTypeDef.key .. "Height"]:SetMinMaxValues(minSliderHeight, heightSliderMax)
		controls[barTypeDef.key .. "Height"].MinLabel:SetText(tostring(minSliderHeight))
		if not EnsureAnchorBlock(barSettings).matchWidth then
			controls[barTypeDef.key .. "Width"]:SetMinMaxValues(minSliderWidth, math.ceil(widthMax / widthDivisor))
			controls[barTypeDef.key .. "Width"].MinLabel:SetText(tostring(minSliderWidth))
		end
	end)

	-- Spacing slider (only for multi-node bars)
	if barTypeDef.hasSpacing then
		controls[barTypeDef.key .. "Spacing"] = TRB.Functions.OptionsUi:BuildSlider(parent, string.format(L["SecondarySpacing"], displayName),
			-20, 20, barSettings.spacing, 1, 0,
			oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls[barTypeDef.key .. "Spacing"]:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			barSettings.spacing = value

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)

		-- Collapse border width checkbox (below spacing slider)
		controls[barTypeDef.key .. "CollapseBorderWidth"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. barTypeDef.key .. "CollapseBorderWidth", parent, "ChatConfigCheckButtonTemplate")
		local cbCollapse = controls[barTypeDef.key .. "CollapseBorderWidth"]
		cbCollapse:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 40)
		getglobal(cbCollapse:GetName() .. 'Text'):SetText(L["CollapseBorderWidth"])
		---@diagnostic disable-next-line: inject-field
		cbCollapse.tooltip = L["CollapseBorderWidthTooltip"]
		cbCollapse:SetChecked(barSettings.collapseBorderWidth)
		TRB.Functions.OptionsUi:ToggleSliderEnabled(controls[barTypeDef.key .. "Spacing"], not barSettings.collapseBorderWidth)
		cbCollapse:SetScript("OnClick", function(self, ...)
			barSettings.collapseBorderWidth = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleSliderEnabled(controls[barTypeDef.key .. "Spacing"], not barSettings.collapseBorderWidth)

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)
	end

	-- Anchor To dropdown + Match Width checkbox
	yCoord = yCoord - 60

	local thisBarKey = barTypeDef.key
	local anchorPoints = TRB.Data.constants.anchorPoints

	-- Forward-declare dropdown variables referenced in callbacks
	local anchorPointDropdown, attachPointDropdown

	-- "Anchor To" dropdown
	local anchorToDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_AnchorTo", parent, "WowStyle1DropdownTemplate")
	anchorToDropdown:SetWidth(oUi.sliderWidth)
	anchorToDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, string.format(L["AnchorToBarLabel"], displayName), oUi.xCoord, yCoord)
	anchorToDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given barKey is the current anchor target for this custom bar.
	---@param value string The barKey to check
	---@return boolean
	local function AnchorToIsSelected(value)
		local a = EnsureAnchorBlock(barSettings)
		return value == a.barKey
	end

	---Sets the custom bar's anchor target to a new barKey after validating it does not create an anchor cycle.
	---@param newValue string The new barKey to anchor to
	local function AnchorToSetSelected(newValue)
		-- Validate no cycle
		local specBarKeys = TRB.Functions.Bar:GetAllBarKeysFromSettings(spec)
		local valid, err = TRB.Functions.Bar:ValidateAnchorTree(spec, nil, thisBarKey, newValue, specBarKeys)
		if not valid then
			print("|cffff0000TRB:|r " .. (err or L["AnchorCycleError"]))
			return
		end
		local a = EnsureAnchorBlock(barSettings)
		local oldBarKey = a.barKey
		a.barKey = newValue
		local transitioned = ApplyAnchorTransitionDefaults(a, oldBarKey, newValue)
		DualWriteAnchorToLegacy(barSettings)
		-- Defer UI updates to avoid taint from secure menu callback context
		C_Timer.After(0, function()
			anchorToDropdown:SetDefaultText(TRB.Functions.Bar:GetBarDisplayName(newValue))
			-- Update UI controls if anchor type changed (screen â†” bar)
			if transitioned then
				controls[barTypeDef.key .. "XPos"]:SetValue(a.xOffset)
				controls[barTypeDef.key .. "YPos"]:SetValue(a.yOffset)
				controls[barTypeDef.key .. "MatchWidth"]:SetChecked(a.matchWidth)
				controls[barTypeDef.key .. "MatchHeight"]:SetChecked(a.matchHeight or false)
				local anchorPointText = GetAnchorPointDisplayName(a.anchorPoint)
				local attachPointText = GetAnchorPointDisplayName(a.attachPoint)
				anchorPointDropdown:SetDefaultText(anchorPointText)
				attachPointDropdown:SetDefaultText(attachPointText)
				-- Force visual refresh: SetDefaultText alone may not update the displayed
				-- text when the dropdown has internal selection state from prior interaction.
				anchorPointDropdown:SetText(anchorPointText)
				attachPointDropdown:SetText(attachPointText)
			end
			local matchWidthCb = controls[barTypeDef.key .. "MatchWidth"]
			matchWidthCb:SetEnabled(newValue ~= "screen")
			getglobal(matchWidthCb:GetName() .. 'Text'):SetFontObject(newValue ~= "screen" and GameFontHighlight or GameFontDisable)
			local matchHeightCb = controls[barTypeDef.key .. "MatchHeight"]
			matchHeightCb:SetEnabled(newValue ~= "screen")
			getglobal(matchHeightCb:GetName() .. 'Text'):SetFontObject(newValue ~= "screen" and GameFontHighlight or GameFontDisable)

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)
	end

	---Populates the dropdown menu with available anchor targets for this custom bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function AnchorToGenerator(dropdown, rootDescription)
		local specBarKeys = TRB.Functions.Bar:GetAllBarKeysFromSettings(spec)
		local targets = TRB.Functions.Bar:GetAvailableAnchorTargets(thisBarKey, spec, nil, specBarKeys)
		for _, barKey in ipairs(targets) do
			rootDescription:CreateRadio(TRB.Functions.Bar:GetBarDisplayName(barKey), AnchorToIsSelected, AnchorToSetSelected, barKey)
		end
	end
	anchorToDropdown:SetupMenu(AnchorToGenerator)
	anchorToDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	anchorToDropdown:SetDefaultText(TRB.Functions.Bar:GetBarDisplayName(anchor.barKey))

	-- Match Width checkbox
	controls[barTypeDef.key .. "MatchWidth"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_MatchWidth", parent, "ChatConfigCheckButtonTemplate")
	f = controls[barTypeDef.key .. "MatchWidth"]
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 20)
	getglobal(f:GetName() .. 'Text'):SetText(L["MatchAnchorWidth"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["MatchAnchorWidthTooltip"]
	f:SetChecked(anchor.matchWidth)
	f:SetEnabled(anchor.barKey ~= "screen")
	getglobal(f:GetName() .. 'Text'):SetFontObject(anchor.barKey ~= "screen" and GameFontHighlight or GameFontDisable)
	f:SetScript("OnClick", function(self, ...)
		local a = EnsureAnchorBlock(barSettings)
		a.matchWidth = self:GetChecked()
		DualWriteAnchorToLegacy(barSettings)

		-- Update border max based on new effective width/height
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or barSettings.width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetValue(borderSize)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- Match Height checkbox
	controls[barTypeDef.key .. "MatchHeight"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_MatchHeight", parent, "ChatConfigCheckButtonTemplate")
	f = controls[barTypeDef.key .. "MatchHeight"]
	f:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 40)
	getglobal(f:GetName() .. 'Text'):SetText(L["MatchAnchorHeight"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["MatchAnchorHeightTooltip"]
	f:SetChecked(anchor.matchHeight or false)
	f:SetEnabled(anchor.barKey ~= "screen")
	getglobal(f:GetName() .. 'Text'):SetFontObject(anchor.barKey ~= "screen" and GameFontHighlight or GameFontDisable)
	f:SetScript("OnClick", function(self, ...)
		local a = EnsureAnchorBlock(barSettings)
		a.matchHeight = self:GetChecked()

		-- Update border max based on new effective dimensions
		local effectiveWidth = a.matchWidth and TRB.Functions.Bar:ResolveBarWidth(spec, a.barKey) or barSettings.width
		local effectiveHeight = a.matchHeight and TRB.Functions.Bar:ResolveBarHeight(spec, a.barKey) or barSettings.height
		local maxBorderSize = math.min(math.floor(effectiveHeight / TRB.Data.constants.borderWidthFactor), math.floor(effectiveWidth / TRB.Data.constants.borderWidthFactor))
		local borderSize = math.min(maxBorderSize, barSettings.border)
		controls[barTypeDef.key .. "Border"]:SetValue(borderSize)
		controls[barTypeDef.key .. "Border"]:SetMinMaxValues(0, maxBorderSize)
		controls[barTypeDef.key .. "Border"].MaxLabel:SetText(tostring(maxBorderSize))

		if TRB.Frames.barGroups ~= nil then
			TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
		end
	end)

	-- Fill Direction dropdown
	yCoord = yCoord - 60
	local fillDirectionDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_FillDirection", parent, "WowStyle1DropdownTemplate")
	fillDirectionDropdown:SetWidth(oUi.sliderWidth)
	fillDirectionDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FillDirection"], oUi.xCoord, yCoord)
	fillDirectionDropdown.label.font:SetFontObject(GameFontNormal)

	local fillDirectionOptions = {
		{ value = "leftRight", label = L["FillDirectionLeftRight"] },
		{ value = "rightLeft", label = L["FillDirectionRightLeft"] },
		{ value = "bottomTop", label = L["FillDirectionBottomTop"] },
		{ value = "topBottom", label = L["FillDirectionTopBottom"] },
	}

	local function FillDirectionIsSelected(value)
		return barSettings.fillDirection == value
	end

	local function FillDirectionSetSelected(newValue)
		local oldValue = barSettings.fillDirection or "leftRight"
		barSettings.fillDirection = newValue
		C_Timer.After(0, function()
			for _, opt in ipairs(fillDirectionOptions) do
				if opt.value == newValue then
					fillDirectionDropdown:SetDefaultText(opt.label)
					break
				end
			end
			local isVert = TRB.Functions.Bar:IsVerticalFill(newValue)
			local wasVert = TRB.Functions.Bar:IsVerticalFill(oldValue)

			-- Rotation: swap width ↔ height when crossing horizontal↔vertical boundary
			if wasVert ~= isVert then
				barSettings.width, barSettings.height = barSettings.height, barSettings.width
				local wKey = barTypeDef.key .. "Width"
				local hKey = barTypeDef.key .. "Height"
				local wHandler = controls[wKey]:GetScript("OnValueChanged")
				local hHandler = controls[hKey]:GetScript("OnValueChanged")
				controls[wKey]:SetScript("OnValueChanged", nil)
				controls[hKey]:SetScript("OnValueChanged", nil)
				SwapSliderBounds(controls[wKey], controls[hKey])
				controls[wKey]:SetValue(barSettings.width)
				controls[wKey].EditBox:SetText(barSettings.width)
				controls[hKey]:SetValue(barSettings.height)
				controls[hKey].EditBox:SetText(barSettings.height)
				controls[wKey]:SetScript("OnValueChanged", wHandler)
				controls[hKey]:SetScript("OnValueChanged", hHandler)

				RotateBarTextPositions(spec, isVert, barTypeDef.key, classId, specId)
				TRB.Functions.BarText:CreateBarTextFrames()
			end

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)
	end

	local function FillDirectionGenerator(dropdown, rootDescription)
		for _, opt in ipairs(fillDirectionOptions) do
			rootDescription:CreateRadio(opt.label, FillDirectionIsSelected, FillDirectionSetSelected, opt.value)
		end
	end
	fillDirectionDropdown:SetupMenu(FillDirectionGenerator)
	fillDirectionDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	local currentFillLabel = L["FillDirectionLeftRight"]
	for _, opt in ipairs(fillDirectionOptions) do
		if opt.value == (barSettings.fillDirection or "leftRight") then
			currentFillLabel = opt.label
			break
		end
	end
	fillDirectionDropdown:SetDefaultText(currentFillLabel)

	-- Growth Direction dropdown (only for multi-node bars)
	if barTypeDef.isMultiNode then
		local growthDirectionDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_GrowthDirection", parent, "WowStyle1DropdownTemplate")
		controls[barTypeDef.key .. "GrowthDirectionDropdown"] = growthDirectionDropdown
		growthDirectionDropdown:SetWidth(oUi.sliderWidth)
		growthDirectionDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["GrowthDirection"], oUi.xCoord2, yCoord)
		growthDirectionDropdown.label.font:SetFontObject(GameFontNormal)

		local growthDirectionOptions = {
			{ value = "leftRight", label = L["GrowthDirectionLeftRight"] },
			{ value = "rightLeft", label = L["GrowthDirectionRightLeft"] },
			{ value = "bottomTop", label = L["GrowthDirectionBottomTop"] },
			{ value = "topBottom", label = L["GrowthDirectionTopBottom"] },
		}

		local function GrowthDirectionIsSelected(value)
			return barSettings.growthDirection == value
		end

		local function GrowthDirectionSetSelected(newValue)
			barSettings.growthDirection = newValue
			C_Timer.After(0, function()
				for _, opt in ipairs(growthDirectionOptions) do
					if opt.value == newValue then
						growthDirectionDropdown:SetDefaultText(opt.label)
						break
					end
				end
				if TRB.Frames.barGroups ~= nil then
					TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
				end
			end)
		end

		local function GrowthDirectionGenerator(dropdown, rootDescription)
			for _, opt in ipairs(growthDirectionOptions) do
				rootDescription:CreateRadio(opt.label, GrowthDirectionIsSelected, GrowthDirectionSetSelected, opt.value)
			end
		end
		growthDirectionDropdown:SetupMenu(GrowthDirectionGenerator)
		growthDirectionDropdown:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 30)

		local currentGrowthLabel = L["GrowthDirectionLeftRight"]
		for _, opt in ipairs(growthDirectionOptions) do
			if opt.value == (barSettings.growthDirection or "leftRight") then
				currentGrowthLabel = opt.label
				break
			end
		end
		growthDirectionDropdown:SetDefaultText(currentGrowthLabel)
	end

	-- Anchor Point dropdown (point on target bar)
	yCoord = yCoord - 60

	anchorPointDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_AnchorPoint", parent, "WowStyle1DropdownTemplate")
	anchorPointDropdown:SetWidth(oUi.sliderWidth)
	anchorPointDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AnchorPoint"], oUi.xCoord, yCoord)
	anchorPointDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given value matches the custom bar's current anchor point.
	---@param value string The anchor point to check
	---@return boolean
	local function AnchorPointIsSelected(value)
		local a = EnsureAnchorBlock(barSettings)
		return value == a.anchorPoint
	end

	---Sets the custom bar's anchor point to a new value and applies the layout change.
	---@param newValue string The new anchor point
	local function AnchorPointSetSelected(newValue)
		local a = EnsureAnchorBlock(barSettings)
		a.anchorPoint = newValue
		DualWriteAnchorToLegacy(barSettings)
		C_Timer.After(0, function()
			anchorPointDropdown:SetDefaultText(GetAnchorPointDisplayName(newValue))

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)
	end

	---Populates the dropdown menu with anchor point options for this custom bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function AnchorPointGenerator(dropdown, rootDescription)
		for _, pt in ipairs(anchorPoints) do
			rootDescription:CreateRadio(GetAnchorPointDisplayName(pt), AnchorPointIsSelected, AnchorPointSetSelected, pt)
		end
	end
	anchorPointDropdown:SetupMenu(AnchorPointGenerator)
	anchorPointDropdown:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)
	anchorPointDropdown:SetDefaultText(GetAnchorPointDisplayName(anchor.anchorPoint))

	-- Attach Point dropdown (point on this bar)
	attachPointDropdown = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_AttachPoint", parent, "WowStyle1DropdownTemplate")
	attachPointDropdown:SetWidth(oUi.sliderWidth)
	attachPointDropdown.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["AttachPoint"], oUi.xCoord2, yCoord)
	attachPointDropdown.label.font:SetFontObject(GameFontNormal)

	---Returns whether the given value matches the custom bar's current attach point.
	---@param value string The attach point to check
	---@return boolean
	local function AttachPointIsSelected(value)
		local a = EnsureAnchorBlock(barSettings)
		return value == a.attachPoint
	end

	---Sets the custom bar's attach point to a new value and applies the layout change.
	---@param newValue string The new attach point
	local function AttachPointSetSelected(newValue)
		local a = EnsureAnchorBlock(barSettings)
		a.attachPoint = newValue
		DualWriteAnchorToLegacy(barSettings)
		C_Timer.After(0, function()
			attachPointDropdown:SetDefaultText(GetAnchorPointDisplayName(newValue))

			if TRB.Frames.barGroups ~= nil then
				TRB.Functions.Bar:ApplyBarGroupsLayout(TRB.Data.specCache[TRB.Data.character.compositeKey].settings, TRB.Frames.barGroups)
			end
		end)
	end

	---Populates the dropdown menu with attach point options for this custom bar.
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function AttachPointGenerator(dropdown, rootDescription)
		for _, pt in ipairs(anchorPoints) do
			rootDescription:CreateRadio(GetAnchorPointDisplayName(pt), AttachPointIsSelected, AttachPointSetSelected, pt)
		end
	end
	attachPointDropdown:SetupMenu(AttachPointGenerator)
	attachPointDropdown:SetPoint("TOPLEFT", oUi.xCoord2, yCoord - 30)
	attachPointDropdown:SetDefaultText(GetAnchorPointDisplayName(anchor.attachPoint))

	return yCoord
end

---Generates color options for a custom bar with simple bar/border/background colors
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, afterNodesCallback)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil

	-- Get the color settings from the nested structure
	local colorSettings = barTypeDef:GetColors(spec)
	if not colorSettings then
		return yCoord
	end

	local displayName = barTypeDef.displayName

	-- Section header
	local headerText = string.format(L["CustomBarColorHeader"], displayName)
	controls[barTypeDef.key .. "ColorSection"] = TRB.Functions.OptionsUi:BuildSectionHeader(parent, headerText, oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	local colorControls = controls.colors.bars[barTypeDef.key]

	-- For threshold-based color bars (like Stagger), use the threshold color UI
	if barTypeDef.colorCurveType == "step" or barTypeDef.colorCurveType == "linear" then
		return TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef)
	end

	-- Simple bar/border/background colors
	-- Bar Color

	if colorSettings.bar then
		if type(colorSettings.bar) == "table" and colorSettings.bar.color2 then
			colorControls.bar = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), colorSettings.bar, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
			f = colorControls.bar
			f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "bar", nil, nil, classId, specId)
			end)
			f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.bar, self, classId, specId)
			end)
		else
			local barColorValue = type(colorSettings.bar) == "table" and colorSettings.bar.color or colorSettings.bar
			colorControls.bar = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBar"], displayName), barColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = colorControls.bar
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "bar", nil, nil, classId, specId)
			end)
		end
		yCoord = yCoord - 30
	end

	-- Per-node colors (for multi-node bars like Warrior defensives)
	if barTypeDef.nodeColors and colorSettings.nodeColors then
		colorControls.nodeColors = colorControls.nodeColors or {}

		-- Build a key-to-config lookup from the definition
		local nodeConfigByKey = {}
		for _, nc in ipairs(barTypeDef.nodeColors) do
			nodeConfigByKey[nc.key] = nc
		end

		-- Get ordered keys (respects user-defined nodeOrder when hasOrdering is true)
		-- Sanitize: drop any stale/unknown keys so a single bad entry can't hide valid nodes
		local rawOrderedKeys = barTypeDef:GetOrderedNodeKeys(colorSettings)
		local orderedKeys = {}
		for _, k in ipairs(rawOrderedKeys) do
			if nodeConfigByKey[k] and colorSettings.nodeColors[k] then
				orderedKeys[#orderedKeys + 1] = k
			end
		end

		-- Track row frames so arrow callbacks can swap visual contents in-place
		local rowFrames = {} -- rowFrames[i] = { key, checkbox, colorPicker, upBtn, downBtn }

		---Refreshes the contents of a single row to reflect the node at orderedKeys[rowIndex]
		local function RefreshRow(rowIndex)
			local row = rowFrames[rowIndex]
			if not row then return end
			local nk = orderedKeys[rowIndex]
			local nc = nodeConfigByKey[nk]
			local ncs = colorSettings.nodeColors[nk]
			row.key = nk
			if row.checkbox then
				row.checkbox:SetChecked(ncs and ncs.enabled)
				getglobal(row.checkbox:GetName() .. 'Text'):SetText(nc.displayName)
				row.checkbox.tooltip = nc.tooltip or nc.displayName
			end
			if row.label then
				row.label:SetText(nc.displayName)
			end
			if row.colorPicker and ncs then
				local ncsColor = type(ncs) == "table" and ncs.color or ncs
				row.colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(ncsColor, true))
				if row.colorPicker.Swatch2 and type(ncs) == "table" and ncs.color2 then
					row.colorPicker.Swatch2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(ncs.color2, true))
					local gradDir = ncs.gradientDirection or "disabled"
					if gradDir == "disabled" then
						row.colorPicker.Swatch2:SetAlpha(0.35)
						row.colorPicker.Swatch2:EnableMouse(false)
					else
						row.colorPicker.Swatch2:SetAlpha(1.0)
						row.colorPicker.Swatch2:EnableMouse(true)
					end
				end
				if row.colorPicker.DirectionButton and type(ncs) == "table" then
					local gradDir = ncs.gradientDirection or "disabled"
					row.colorPicker.DirectionButton.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
				end
				if row.colorPicker.Font then
					row.colorPicker.Font:SetText(nc.colorLabel or nc.displayName)
				end
			end
			-- Arrow enabled state
			if row.upBtn then row.upBtn:SetEnabled(rowIndex > 1) end
			if row.downBtn then row.downBtn:SetEnabled(rowIndex < #orderedKeys) end
		end

		---Triggers bar layout + appearance rebuild after enable/order change
		local function RebuildBarAfterNodeChange()
			if barTypeDef.onChangeCallback then
				barTypeDef.onChangeCallback()
			end
			if TRB.Frames.barGroups ~= nil then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
				TRB.Functions.BarVisibility:MarkDirty()
				TRB.Functions.Bar:HideResourceBar()
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
				-- Re-parent bar text frames to reflect new node order
				TRB.Functions.BarText:CreateBarTextFrames()
				-- CreateBarTextFrames clears font strings as part of rebuilding/re-parenting.
				-- Force a repaint so enabled entries immediately repopulate on their new anchors.
				TRB.Data.lookupDirty = true
				TRB.Functions.BarText:UpdateResourceBarText(settings, true)
			end
		end

		---Swaps two adjacent entries in orderedKeys and the nodeOrder setting, then refreshes both rows
		local function SwapNodes(indexA, indexB)
			-- Swap in the live ordered keys
			orderedKeys[indexA], orderedKeys[indexB] = orderedKeys[indexB], orderedKeys[indexA]
			-- Persist to settings
			colorSettings.nodeOrder = colorSettings.nodeOrder or {}
			for i, k in ipairs(orderedKeys) do
				colorSettings.nodeOrder[i] = k
			end
			RefreshRow(indexA)
			RefreshRow(indexB)
			RebuildBarAfterNodeChange()
		end

		-- Determine if sameColor checkbox should be placed inline with a specific node
		local sameColorPlacedInline = false
		local showSameColor = barTypeDef.hasSameColor and barTypeDef.nodeColors and #barTypeDef.nodeColors >= 2
		local sameColorTargetKey = nil
		if showSameColor then
			sameColorTargetKey = barTypeDef.sameColorNodeKey or barTypeDef.nodeColors[#barTypeDef.nodeColors].key
		end

		for rowIndex, nodeKey in ipairs(orderedKeys) do
			local nodeConfig = nodeConfigByKey[nodeKey]
			local nodeDisplayName = nodeConfig.displayName
			local nodeColorLabel = nodeConfig.colorLabel or nodeDisplayName
			local nodeColorSettings = colorSettings.nodeColors[nodeKey]
			local capturedRowIdx = rowIndex

			if nodeColorSettings then
				colorControls.nodeColors[nodeKey] = colorControls.nodeColors[nodeKey] or {}
				local nodeControls = colorControls.nodeColors[nodeKey]
				local row = { key = nodeKey }

				-- Reorder arrows (if ordering is enabled and there are 2+ nodes)
				local arrowXOffset = oUi.xCoord
				if barTypeDef.hasOrdering and #orderedKeys > 1 then
					local upTooltipTitle = L["NodeOrderMoveUp"]
					local upTooltipBody = barTypeDef.orderUpTooltip
					local downTooltipTitle = L["NodeOrderMoveDown"]
					local downTooltipBody = barTypeDef.orderDownTooltip

					-- Up arrow (texture-based)
					local upBtn = CreateFrame("Button", nil, parent)
					upBtn:SetSize(20, 20)
					upBtn:SetPoint("TOPLEFT", arrowXOffset, yCoord)
					upBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
					upBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
					upBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
					upBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
					upBtn:SetEnabled(rowIndex > 1)
					upBtn:SetScript("OnClick", function()
						SwapNodes(capturedRowIdx - 1, capturedRowIdx)
					end)
					upBtn:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(upTooltipTitle, 1, 1, 1)
						if upTooltipBody then
							GameTooltip:AddLine(upTooltipBody, nil, nil, nil, true)
						end
						GameTooltip:Show()
					end)
					upBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
					row.upBtn = upBtn

					-- Down arrow (texture-based)
					local downBtn = CreateFrame("Button", nil, parent)
					downBtn:SetSize(20, 20)
					downBtn:SetPoint("TOPLEFT", arrowXOffset + 22, yCoord)
					downBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
					downBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
					downBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
					downBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
					downBtn:SetEnabled(rowIndex < #orderedKeys)
					downBtn:SetScript("OnClick", function()
						SwapNodes(capturedRowIdx, capturedRowIdx + 1)
					end)
					downBtn:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(downTooltipTitle, 1, 1, 1)
						if downTooltipBody then
							GameTooltip:AddLine(downTooltipBody, nil, nil, nil, true)
						end
						GameTooltip:Show()
					end)
					downBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
					row.downBtn = downBtn

					arrowXOffset = arrowXOffset + 46
				end

				if nodeConfig.hasEnabled then
					-- Build checkbox and color picker manually for node with enable option
					-- Create enable checkbox
					local checkboxName = "TwintopResourceBar_" .. namePrefix .. "_" .. nodeKey .. "_Enabled"
					nodeControls.enabled = CreateFrame("CheckButton", checkboxName, parent, "ChatConfigCheckButtonTemplate")
					local fCheckbox = nodeControls.enabled
					fCheckbox:SetPoint("TOPLEFT", arrowXOffset, yCoord)
					getglobal(fCheckbox:GetName() .. 'Text'):SetText(nodeDisplayName)
					fCheckbox.tooltip = nodeConfig.tooltip or nodeDisplayName
					fCheckbox:SetChecked(nodeColorSettings.enabled)
					-- Dereference via orderedKeys at click-time to survive arrow reordering
					fCheckbox:SetScript("OnClick", function(self, ...)
						local currentKey = orderedKeys[capturedRowIdx]
						colorSettings.nodeColors[currentKey].enabled = self:GetChecked()
						RebuildBarAfterNodeChange()
					end)
					row.checkbox = fCheckbox

					-- Create color picker (dereference via orderedKeys at click-time for settings, but use
					-- nodeControls for the controls table so the callback updates THIS row's swatch frame)
					if type(nodeColorSettings) == "table" and nodeColorSettings.color2 then
						nodeControls.color = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, nodeColorLabel, nodeColorSettings, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
						f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.nodeColors[currentKey], self, classId, specId)
						end)
						f.DirectionButton:SetScript("OnMouseDown", function(self, mouseButton)
							if mouseButton == "LeftButton" then
								local currentKey = orderedKeys[capturedRowIdx]
								local currentColorEntry = colorSettings.nodeColors[currentKey]
								local currentIdx = 1
								for idx, dir in ipairs(gradientDirectionCycle) do
									if dir == currentColorEntry.gradientDirection then
										currentIdx = idx
										break
									end
								end
								local nextIdx = (currentIdx % #gradientDirectionCycle) + 1
								currentColorEntry.gradientDirection = gradientDirectionCycle[nextIdx]
								local gradDir = currentColorEntry.gradientDirection
								local swatch2 = self:GetParent().Swatch2
								if gradDir == "disabled" then
									swatch2:SetAlpha(0.35)
									swatch2:EnableMouse(false)
								else
									swatch2:SetAlpha(1.0)
									swatch2:EnableMouse(true)
								end
								self.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
								TRB.Data.cache.colors.gradient = {}
								TRB.Data.cache.colors.bar = {}
								if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
									TRB.Data.lookupDirty = true
									TRB.Functions.Class:TriggerResourceBarUpdates()
								end
							end
						end)
					else
						nodeControls.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, nodeColorLabel, nodeColorSettings.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
					end
					row.colorPicker = nodeControls.color
				else
					-- Place sameColor checkbox inline on the left if this row matches the target node
					if showSameColor and not sameColorPlacedInline and (nodeKey == sameColorTargetKey) then
						local sameColorCheckboxName = "TwintopResourceBar_" .. namePrefix .. "_sameColor"
						colorControls.sameColor = CreateFrame("CheckButton", sameColorCheckboxName, parent, "ChatConfigCheckButtonTemplate")
						local fSameColor = colorControls.sameColor
						fSameColor:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
						getglobal(fSameColor:GetName() .. 'Text'):SetText(string.format(L["CustomBarCheckboxSameColor"], displayName))
						fSameColor.tooltip = string.format(L["CustomBarCheckboxSameColorTooltip"], displayName)
						fSameColor:SetChecked(colorSettings.sameColor)
						fSameColor:SetScript("OnClick", function(self, ...)
							colorSettings.sameColor = self:GetChecked()
						end)
						sameColorPlacedInline = true
					end

					-- Simple color picker without enable checkbox (dereference via orderedKeys at click-time for
					-- settings, but use nodeControls for the controls table so the callback updates THIS row's swatch)
					if type(nodeColorSettings) == "table" and nodeColorSettings.color2 then
						nodeControls.color = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, nodeColorLabel, nodeColorSettings, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
						f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings.nodeColors[currentKey], self, classId, specId)
						end)
						f.DirectionButton:SetScript("OnMouseDown", function(self, mouseButton)
							if mouseButton == "LeftButton" then
								local currentKey = orderedKeys[capturedRowIdx]
								local currentColorEntry = colorSettings.nodeColors[currentKey]
								local currentIdx = 1
								for idx, dir in ipairs(gradientDirectionCycle) do
									if dir == currentColorEntry.gradientDirection then
										currentIdx = idx
										break
									end
								end
								local nextIdx = (currentIdx % #gradientDirectionCycle) + 1
								currentColorEntry.gradientDirection = gradientDirectionCycle[nextIdx]
								local gradDir = currentColorEntry.gradientDirection
								local swatch2 = self:GetParent().Swatch2
								if gradDir == "disabled" then
									swatch2:SetAlpha(0.35)
									swatch2:EnableMouse(false)
								else
									swatch2:SetAlpha(1.0)
									swatch2:EnableMouse(true)
								end
								self.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
								TRB.Data.cache.colors.gradient = {}
								TRB.Data.cache.colors.bar = {}
								if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
									TRB.Data.lookupDirty = true
									TRB.Functions.Class:TriggerResourceBarUpdates()
								end
							end
						end)
					else
						local nodeColorValue = type(nodeColorSettings) == "table" and nodeColorSettings.color or nodeColorSettings
						nodeControls.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, nodeColorLabel, nodeColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
						f = nodeControls.color
						f:SetScript("OnMouseDown", function(self, button, ...)
							local currentKey = orderedKeys[capturedRowIdx]
							TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings.nodeColors[currentKey], nodeControls, "color", nil, nil, classId, specId)
						end)
					end
					row.colorPicker = nodeControls.color
				end
				rowFrames[rowIndex] = row
				yCoord = yCoord - 30
			end
		end

		-- Fallback: if sameColor checkbox wasn't placed inline (e.g., target node has hasEnabled), place on its own row
		if showSameColor and not sameColorPlacedInline then
			local sameColorCheckboxName = "TwintopResourceBar_" .. namePrefix .. "_sameColor"
			colorControls.sameColor = CreateFrame("CheckButton", sameColorCheckboxName, parent, "ChatConfigCheckButtonTemplate")
			local fSameColor = colorControls.sameColor
			fSameColor:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
			getglobal(fSameColor:GetName() .. 'Text'):SetText(string.format(L["CustomBarCheckboxSameColor"], displayName))
			fSameColor.tooltip = string.format(L["CustomBarCheckboxSameColorTooltip"], displayName)
			fSameColor:SetChecked(colorSettings.sameColor)
			fSameColor:SetScript("OnClick", function(self, ...)
				colorSettings.sameColor = self:GetChecked()
			end)
			yCoord = yCoord - 30
		end
	end

	-- Extra content between node colors and border (e.g., Holy Words complete cooldown)
	if afterNodesCallback then
		yCoord = afterNodesCallback(parent, yCoord)
	end

	-- Border Color
	if colorSettings.border then
		local borderColorValue = type(colorSettings.border) == "table" and colorSettings.border.color or colorSettings.border
		colorControls.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", nil, nil, classId, specId)
		end)
		yCoord = yCoord - 30
	end

	-- Background Color
	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", nil, nil, classId, specId)
		end)
		yCoord = yCoord - 30
	end

	return yCoord
end

---Generates color options for a custom bar with threshold-based colors (step/linear)
---@param parent Frame # Parent frame for the controls
---@param controls table # Table to store control references
---@param spec table # Spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Starting Y coordinate
---@param barTypeDef TRB.Classes.BarTypeDefinition # Bar type definition
---@param onChangeCallback function? # Optional callback to call after changes (overrides barTypeDef.onChangeCallback)
---@return number # New Y coordinate after adding controls
function TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(parent, controls, spec, classId, specId, yCoord, barTypeDef, onChangeCallback)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName .. "_" .. barTypeDef.key
	local f = nil

	-- Get the color settings from the nested structure
	local colorSettings = barTypeDef:GetColors(spec)
	if not colorSettings then
		return yCoord
	end

	-- Determine the callback to use (parameter overrides definition)
	local changeCallback = onChangeCallback or barTypeDef.onChangeCallback

	---Triggers a resource bar update and optional change callback after a threshold color setting is modified.
	local function triggerChange()
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
		if changeCallback then
			changeCallback()
		end
	end

	local displayName = barTypeDef.displayName

	controls.colors = controls.colors or {}
	controls.colors.bars = controls.colors.bars or {}
	controls.colors.bars[barTypeDef.key] = controls.colors.bars[barTypeDef.key] or {}
	local colorControls = controls.colors.bars[barTypeDef.key]

	-- Get localized strings from barTypeDef (resolved at registration time, with fallbacks to generic labels)
	local colorTypeLabel = barTypeDef.colorTypeLabel or L["ColorType"]
	local colorTypeStepLabel = barTypeDef.colorTypeStepLabel or L["ColorTypeStep"]
	local colorTypeLinearLabel = barTypeDef.colorTypeLinearLabel or L["ColorTypeLinear"]
	local colorTypeNoneLabel = barTypeDef.colorTypeNoneLabel or L["ColorTypeNone"]

	-- Color Transition Type dropdown
	-- Note: yCoord already positioned at header row, so dropdown label goes here
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown[barTypeDef.key .. "ColorCurveType"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_ColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetWidth(oUi.sliderWidth)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, colorTypeLabel, oUi.xCoord, yCoord)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"].label.font:SetFontObject(GameFontNormal)

	---Returns whether the given value matches the current color curve type.
	---@param value string The color curve type to check ("step", "linear", or "none")
	---@return boolean
	local function ColorCurveTypeIsSelected(value)
		return value == colorSettings.type
	end

	---Returns the localized display name for a color curve type value.
	---@param value string The color curve type ("step", "linear", or "none")
	---@return string
	local function ColorCurveTypeGetDisplayName(value)
		if value == "step" then
			return colorTypeStepLabel
		elseif value == "linear" then
			return colorTypeLinearLabel
		else
			return colorTypeNoneLabel
		end
	end

	---Sets the color curve type to a new value, updates the dropdown text, and triggers a change callback.
	---@param newValue string The new color curve type ("step", "linear", or "none")
	local function ColorCurveTypeSetSelected(newValue)
		colorSettings.type = newValue
		controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetDefaultText(ColorCurveTypeGetDisplayName(newValue))
		triggerChange()
	end

	---Populates the dropdown menu with color curve type options (step, linear, none).
	---@param dropdown DropdownButton The dropdown button being initialized
	---@param rootDescription table The root menu description to add radio items to
	local function ColorCurveTypeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(colorTypeStepLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "step")
		rootDescription:CreateRadio(colorTypeLinearLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "linear")
		rootDescription:CreateRadio(colorTypeNoneLabel, ColorCurveTypeIsSelected, ColorCurveTypeSetSelected, "none")
	end

	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetupMenu(ColorCurveTypeGenerator)
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetDefaultText(ColorCurveTypeGetDisplayName(colorSettings.type))
	controls.dropDown[barTypeDef.key .. "ColorCurveType"]:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	-- Advance yCoord past the dropdown (dropdown + its label takes about 50 units)
	yCoord = yCoord - 80

	-- Get threshold levels from definition (required for threshold-based bars)
	local thresholdLevels = barTypeDef.thresholdLevels
	if not thresholdLevels or #thresholdLevels == 0 then
		-- Early exit if no threshold levels defined
		return yCoord
	end

	-- Build threshold sliders (skip first one - no slider needed for base/low)
	-- Use percentage sliders: display percentages, store as decimals
	-- Default max is 100%, but can be overridden by barTypeDef.maxThresholdPercent (e.g., 1000 for stagger)
	local maxThresholdPercent = barTypeDef.maxThresholdPercent or 100
	for i, thresholdLevel in ipairs(thresholdLevels) do
		local thresholdKey = thresholdLevel.key
		if i > 1 and colorSettings[thresholdKey] and colorSettings[thresholdKey].threshold ~= nil then
			-- Use resolved sliderLabel string from thresholdLevel, or fall back to generic formatted label
			local sliderLabel = thresholdLevel.sliderLabel or string.format(L["CustomBarThreshold"], displayName, thresholdKey:gsub("^%l", string.upper))
			controls[barTypeDef.key .. thresholdKey .. "Threshold"] = TRB.Functions.OptionsUi:BuildPercentageSlider(parent, sliderLabel,
				0, maxThresholdPercent, colorSettings[thresholdKey].threshold, 1, 0,
				oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
			if thresholdLevel.sliderTooltip then
				controls[barTypeDef.key .. thresholdKey .. "Threshold"].tooltip = thresholdLevel.sliderTooltip
			end
			controls[barTypeDef.key .. thresholdKey .. "Threshold"]:SetScript("OnValueChanged", function(self, value)
				-- Slider value is in percentage (0-maxThresholdPercent), store as decimal
				local displayValue = TRB.Functions.Number:RoundTo(value, 0)
				self.EditBox:SetText(displayValue .. "%")
				colorSettings[thresholdKey].threshold = value / 100
				triggerChange()
			end)
			yCoord = yCoord - 60
		end
	end

	-- Build color pickers for each threshold
	local gradientTooltip = barTypeDef.gradientTooltipNote
	for _, thresholdLevel in ipairs(thresholdLevels) do
		local thresholdKey = thresholdLevel.key
		if colorSettings[thresholdKey] and colorSettings[thresholdKey].color then
			-- Use resolved colorLabel string from thresholdLevel
			local colorLabel = thresholdLevel.colorLabel
			if type(colorSettings[thresholdKey]) == "table" and colorSettings[thresholdKey].color2 then
				colorControls[thresholdKey] = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, colorLabel, colorSettings[thresholdKey], oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2, gradientTooltip)
				f = colorControls[thresholdKey]
				f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, nil, nil, classId, specId)
				end)
				f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
						TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, colorSettings[thresholdKey], self, classId, specId)
				end)
			else
				colorControls[thresholdKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, colorLabel, colorSettings[thresholdKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
				f = colorControls[thresholdKey]
				f:SetScript("OnMouseDown", function(self, button, ...)
					TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, thresholdKey, nil, nil, classId, specId)
				end)
			end
			yCoord2 = yCoord2 - 30
		end
	end

	-- Border and background colors
	if colorSettings.border then
		local borderColorValue = type(colorSettings.border) == "table" and colorSettings.border.color or colorSettings.border
		colorControls.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBorder"], displayName), borderColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.border
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "border", nil, nil, classId, specId)
		end)
		yCoord2 = yCoord2 - 30
	end

	if colorSettings.background then
		local bgColorValue = type(colorSettings.background) == "table" and colorSettings.background.color or colorSettings.background
		colorControls.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["CustomBarColorBackground"], displayName), bgColorValue, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
		f = colorControls.background
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, colorSettings, colorControls, "background", nil, nil, classId, specId)
		end)
		yCoord2 = yCoord2 - 30
	end

	return math.min(yCoord, yCoord2)
end

-- Texture option generators live in Options\OptionsUiTextures.lua.
function TRB.Functions.OptionsUi:UpdateStatusbarDropdowns(...)
	return self.Textures:UpdateStatusbarDropdowns(...)
end

function TRB.Functions.OptionsUi:UpdateOverlayDropdowns(...)
	return self.Textures:UpdateOverlayDropdowns(...)
end

function TRB.Functions.OptionsUi:GenerateBarTexturesOptions(...)
	return self.Textures:GenerateBarTexturesOptions(...)
end

function TRB.Functions.OptionsUi:GenerateFlashOptions(...)
	return self.Textures:GenerateFlashOptions(...)
end

-- Bar visibility option generators live in Options\OptionsUiVisibility.lua.
function TRB.Functions.OptionsUi:CreateBarVisibilityThresholdTypes(...)
	return self.Visibility:CreateBarVisibilityThresholdTypes(...)
end

function TRB.Functions.OptionsUi:GenerateBarVisibilityOptions(...)
	return self.Visibility:GenerateBarVisibilityOptions(...)
end

-- Threshold option generators live in Options\OptionsUiThresholds.lua.
function TRB.Functions.OptionsUi:GenerateThresholdListPanel(...)
	return self.Thresholds:GenerateThresholdListPanel(...)
end

function TRB.Functions.OptionsUi:GenerateThresholdLineIconsOptions(...)
	return self.Thresholds:GenerateThresholdLineIconsOptions(...)
end

function TRB.Functions.OptionsUi:GenerateThresholdLineColorOptions(...)
	return self.Thresholds:GenerateThresholdLineColorOptions(...)
end

---Generates the consolidated "Base Colors" panel: Resource color, Casting Overlay (optional), Border, and Unfilled bar background.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param includeCastingOverlay boolean? Whether to include the casting overlay color option (default true)
---@param includeSpendingOverlay boolean? Whether to include the spending overlay color option
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateBaseColorsOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeCastingOverlay, includeSpendingOverlay)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.baseColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BaseColorsHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, primaryResourceString, spec.colors.bar.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		local barFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			barFrame = node and node.GetFrame and node:GetFrame() or nil
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base", "bar", barFrame)
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.base, self, classId, specId)
	end)

	if includeCastingOverlay ~= false then
		yCoord = yCoord - 30
		controls.colors.casting = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorCastingOverlay"], spec.colors.bar.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.casting
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.casting, self, classId, specId)
		end)

		controls.checkBoxes.castingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.castingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorCastingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorCastingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.casting.enabled)
		controls.checkBoxes.castingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.casting.fullHeight == true,
			function(self)
				spec.colors.bar.casting.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.casting.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	if includeSpendingOverlay then
		if includeCastingOverlay == false then
			yCoord = yCoord - 30
		end
		controls.colors.spending = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorSpendingOverlay"], spec.colors.bar.spending, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.spending, self, classId, specId)
		end)

		controls.checkBoxes.spendingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spendingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorSpendingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorSpendingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.spending.enabled)
		controls.checkBoxes.spendingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.spending.fullHeight == true,
			function(self)
				spec.colors.bar.spending.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.spending.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	controls.colors.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerBorder"], spec.colors.bar.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		local borderFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			borderFrame = node and node.GetFrame and node:GetFrame()
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", borderFrame)
	end)

	yCoord = yCoord - 30
	controls.colors.background = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.bar.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.background
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetPrimaryBackdropFrame())
	end)

	return yCoord
end

---Generates the complete Indicator Colors panel for a specialization.
---This centralizes the boilerplate UI for flat indicator rows, gradient indicator rows,
---optional EndOf configuration sections, and optional overcap configuration.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table (must contain colors.shared.indicatorColors, nodeOrder, gradientOrder)
---@param classId integer The class ID
---@param specId integer The spec ID
---@param yCoord number The current Y coordinate for layout positioning
---@param config TRB.Classes.OptionsUi.IndicatorColorsPanelConfig Configuration for the Indicator Colors panel
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateIndicatorColorsPanel(parent, controls, spec, classId, specId, yCoord, config)
	local indicatorDefs = config.indicatorDefs
	local gradientDefs = config.gradientDefs or {}
	local barTargetDefs = config.barTargetDefs
	local excludedElements = config.excludedElements or {}
	local gradientExcludedElements = config.gradientExcludedElements or {}
	local ddNamePrefix = config.ddNamePrefix

	local elementDefs = {
		{ key = "bar", label = L["BarElementBar"] },
		{ key = "border", label = L["BarElementBorder"] },
		{ key = "background", label = L["BarElementBackground"] },
	}

	-- Build a quick lookup from key -> indicatorDef
	local indicatorDefByKey = {}
	for _, def in ipairs(indicatorDefs) do
		indicatorDefByKey[def.key] = def
	end
	for _, def in ipairs(gradientDefs) do
		indicatorDefByKey[def.key] = def
	end

	local sharedSettings = spec.colors.shared
	local indicatorColors = sharedSettings.indicatorColors

	-- Working copy of the ordered keys (survives reordering within this panel's lifetime)
	-- Filter out any keys that have no matching indicatorDef or no indicatorColors entry
	-- to keep the row count and the up/down arrow bounds in sync.
	local orderedKeys = {}
	for _, k in ipairs(sharedSettings.nodeOrder) do
		if indicatorDefByKey[k] and indicatorColors[k] then
			orderedKeys[#orderedKeys + 1] = k
		end
	end

	-- Per-row UI element references (indexed by row position, NOT by key)
	local rows = {}

	controls.indicatorColors = controls.indicatorColors or {}
	controls.indicatorColors.rows = controls.indicatorColors.rows or {}

	-- Section header
	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["IndicatorColorPriorityHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30

	---Gets a summary string of enabled targets for a given indicator
	---@param indicatorKey string
	---@return string
	local function GetSummaryText(indicatorKey)
		local indicator = indicatorColors[indicatorKey]
		if not indicator or not indicator.targets then
			return L["BarNameDisabled"]
		end
		local parts = {}
		for _, barDef in ipairs(barTargetDefs) do
			local barTargets = indicator.targets[barDef.key]
			if barTargets then
				local elements = {}
				for _, elemDef in ipairs(elementDefs) do
					if barTargets[elemDef.key] then
						table.insert(elements, elemDef.label)
					end
				end
				if #elements > 0 then
					table.insert(parts, barDef.label .. ": " .. table.concat(elements, ", "))
				end
			end
		end
		if #parts == 0 then
			return L["BarNameDisabled"]
		end
		return table.concat(parts, "; ")
	end

	---Syncs the enabled state for an indicator based on whether any targets are selected
	---@param indicatorKey string
	---@param rowIndex number
	local function SyncEnabled(indicatorKey, rowIndex)
		local indicator = indicatorColors[indicatorKey]
		if not indicator then return end
		local anyEnabled = false
		if indicator.targets then
			for _, barDef in ipairs(barTargetDefs) do
				local barTargets = indicator.targets[barDef.key]
				if barTargets then
					for _, elemDef in ipairs(elementDefs) do
						if barTargets[elemDef.key] then
							anyEnabled = true
							break
						end
					end
				end
				if anyEnabled then break end
			end
		end
		indicator.enabled = anyEnabled
		local row = rows[rowIndex]
		if row then
			if row.colorPicker then
				TRB.Functions.OptionsUi:ToggleColorPickerEnabled(row.colorPicker, anyEnabled)
			end
		end
	end

	---Refreshes a single row's visual state from the current orderedKeys
	---@param rowIndex number
	local function RefreshRow(rowIndex)
		local row = rows[rowIndex]
		if not row then return end
		local key = orderedKeys[rowIndex]
		local def = indicatorDefByKey[key]
		local indicator = indicatorColors[key]
		if not def or not indicator then return end

		-- Update color picker
		if row.colorPicker then
			row.colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color, true))
			if row.colorPicker.Swatch2 and indicator.color2 then
				row.colorPicker.Swatch2.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color2, true))
				local gradDir = indicator.gradientDirection or "disabled"
				if gradDir == "disabled" then
					row.colorPicker.Swatch2:SetAlpha(0.35)
					row.colorPicker.Swatch2:EnableMouse(false)
				else
					row.colorPicker.Swatch2:SetAlpha(1.0)
					row.colorPicker.Swatch2:EnableMouse(true)
				end
			end
			if row.colorPicker.DirectionButton and indicator.gradientDirection then
				row.colorPicker.DirectionButton.Font:SetText(gradientDirectionAbbrevLabels[indicator.gradientDirection] or L["GradientDirectionDisabledAbbrev"])
			end
			if row.colorPicker.Font then
				row.colorPicker.Font:SetText(def.colorLabel)
			end
			TRB.Functions.OptionsUi:ToggleColorPickerEnabled(row.colorPicker, indicator.enabled)
		end
		-- Update dropdown text
		if row.dropdown then
			row.dropdown:SetText(GetSummaryText(key))
		end
		-- Arrow enabled state
		if row.upBtn then row.upBtn:SetEnabled(rowIndex > 1) end
		if row.downBtn then row.downBtn:SetEnabled(rowIndex < #orderedKeys) end
	end

	---Swaps two adjacent entries and persists to settings
	---@param indexA number
	---@param indexB number
	local function SwapNodes(indexA, indexB)
		orderedKeys[indexA], orderedKeys[indexB] = orderedKeys[indexB], orderedKeys[indexA]
		-- Rebuild the persisted nodeOrder from orderedKeys so any filtered-out
		-- orphan trailing entries don't survive the write.
		wipe(sharedSettings.nodeOrder)
		for i, k in ipairs(orderedKeys) do
			sharedSettings.nodeOrder[i] = k
		end
		RefreshRow(indexA)
		RefreshRow(indexB)
	end

	-- Build flat indicator rows
	for rowIndex, nodeKey in ipairs(orderedKeys) do
		local def = indicatorDefByKey[nodeKey]
		local indicator = indicatorColors[nodeKey]
		if def and indicator then
			local capturedRowIdx = rowIndex
			local row = {}
			rows[rowIndex] = row

			local xOffset = oUi.xCoord

			-- Up arrow
			local upBtn = CreateFrame("Button", nil, parent)
			upBtn:SetSize(20, 20)
			upBtn:SetPoint("TOPLEFT", xOffset, yCoord)
			upBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
			upBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
			upBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
			upBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
			upBtn:SetEnabled(rowIndex > 1)
			upBtn:SetScript("OnClick", function()
				SwapNodes(capturedRowIdx - 1, capturedRowIdx)
			end)
			upBtn:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(L["NodeOrderMoveUp"], 1, 1, 1)
				GameTooltip:Show()
			end)
			upBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
			row.upBtn = upBtn

			-- Down arrow
			local downBtn = CreateFrame("Button", nil, parent)
			downBtn:SetSize(20, 20)
			downBtn:SetPoint("TOPLEFT", xOffset + 22, yCoord)
			downBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
			downBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
			downBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
			downBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
			downBtn:SetEnabled(rowIndex < #orderedKeys)
			downBtn:SetScript("OnClick", function()
				SwapNodes(capturedRowIdx, capturedRowIdx + 1)
			end)
			downBtn:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(L["NodeOrderMoveDown"], 1, 1, 1)
				GameTooltip:Show()
			end)
			downBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
			row.downBtn = downBtn

			xOffset = xOffset + 46

			-- Targets dropdown
			local ddName = ddNamePrefix .. "_Indicator_" .. nodeKey .. "_Targets"
			local dd = CreateFrame("DropdownButton", ddName, parent, "WowStyle1DropdownTemplate")
			dd:SetWidth(280)
			dd:SetPoint("TOPLEFT", xOffset, yCoord)
			dd:SetScript("OnEnter", function(self)
				local currentKey = orderedKeys[capturedRowIdx]
				local currentDef = indicatorDefByKey[currentKey]
				if currentDef and currentDef.tooltip then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText(currentDef.tooltip, 1, 1, 1, 1, true)
					GameTooltip:Show()
				end
			end)
			dd:SetScript("OnLeave", function() GameTooltip:Hide() end)

			-- Hook SetText to always show our summary
			local originalSetText = dd.SetText
			dd.SetText = function(self, text)
				local currentKey = orderedKeys[capturedRowIdx]
				originalSetText(self, GetSummaryText(currentKey))
			end

			dd:SetupMenu(function(dropdown, rootDescription)
				local currentKey = orderedKeys[capturedRowIdx]
				local currentIndicator = indicatorColors[currentKey]
				if not currentIndicator then return end
				currentIndicator.targets = currentIndicator.targets or {}

				local firstBar = true
				for barIdx, barDef in ipairs(barTargetDefs) do
					local excluded = excludedElements[barDef.key]
					local allExcluded = true
					if excluded then
						for _, elemDef in ipairs(elementDefs) do
							if not excluded[elemDef.key] then
								allExcluded = false
								break
							end
						end
					else
						allExcluded = false
					end
					if not allExcluded then
						if not firstBar then
							rootDescription:CreateDivider()
						end
						firstBar = false
						rootDescription:CreateTitle(barDef.label)
						currentIndicator.targets[barDef.key] = currentIndicator.targets[barDef.key] or {}

						for _, elemDef in ipairs(elementDefs) do
							if not (excluded and excluded[elemDef.key]) then
								rootDescription:CreateCheckbox(
									elemDef.label,
									function()
										local ck = orderedKeys[capturedRowIdx]
										local ci = indicatorColors[ck]
										return ci and ci.targets and ci.targets[barDef.key] and ci.targets[barDef.key][elemDef.key] or false
									end,
									function()
										local ck = orderedKeys[capturedRowIdx]
										local ci = indicatorColors[ck]
										if not ci then return end
										ci.targets = ci.targets or {}
										ci.targets[barDef.key] = ci.targets[barDef.key] or {}
										ci.targets[barDef.key][elemDef.key] = not ci.targets[barDef.key][elemDef.key]
										SyncEnabled(ck, capturedRowIdx)
									end
								)
							end
						end
					end
				end
			end)

			dd:SetText(GetSummaryText(nodeKey))
			row.dropdown = dd

			-- Color picker
			local cp = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, def.colorLabel, indicator, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord, L["GradientBarFillOnlyTooltip"])
			---@cast cp Button
			cp.Swatch1:SetScript("OnMouseDown", function(self, button)
				local currentKey = orderedKeys[capturedRowIdx]
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, indicatorColors, { [currentKey] = rows[capturedRowIdx].colorPicker }, currentKey, "indicatorColor_" .. currentKey)
			end)
			cp.Swatch2:SetScript("OnMouseDown", function(self, button)
				local currentKey = orderedKeys[capturedRowIdx]
				TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, indicatorColors[currentKey], cp.Swatch2, classId, specId)
			end)
			cp.DirectionButton:SetScript("OnMouseDown", function(self, mouseButton)
				if mouseButton == "LeftButton" then
					local currentKey = orderedKeys[capturedRowIdx]
					local currentEntry = indicatorColors[currentKey]
					local ci = 1
					for idx, dir in ipairs(gradientDirectionCycle) do
						if dir == currentEntry.gradientDirection then ci = idx; break end
					end
					currentEntry.gradientDirection = gradientDirectionCycle[(ci % #gradientDirectionCycle) + 1]
					local gradDir = currentEntry.gradientDirection
					if gradDir == "disabled" then
						cp.Swatch2:SetAlpha(0.35); cp.Swatch2:EnableMouse(false)
					else
						cp.Swatch2:SetAlpha(1.0); cp.Swatch2:EnableMouse(true)
					end
					self.Font:SetText(gradientDirectionAbbrevLabels[gradDir] or L["GradientDirectionDisabledAbbrev"])
					TRB.Data.cache.colors.gradient = {}
					TRB.Data.cache.colors.bar = {}
					if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
						TRB.Data.lookupDirty = true
						TRB.Functions.Class:TriggerResourceBarUpdates()
					end
				end
			end)
			---@cast cp Button
			TRB.Functions.OptionsUi:ToggleColorPickerEnabled(cp, indicator.enabled)
			row.colorPicker = cp

			-- Store row controls for the color picker callback
			controls.indicatorColors.rows[rowIndex] = row

			yCoord = yCoord - 30
		end
	end

	-- Gradient Color Overrides section
	if #gradientDefs > 0 then
		yCoord = yCoord - 10
		controls.textSectionGradient = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["GradientColorOverridesHeader"], oUi.xCoord, yCoord)
		yCoord = yCoord - 30

		-- Note explaining gradient behavior
		controls.gradientNote = TRB.Functions.OptionsUi:BuildLabel(parent, L["GradientColorOverridesNote"], oUi.xCoord, yCoord, oUi.maxOptionsWidth, 28)
		yCoord = yCoord - 30

		-- Working copy of gradient ordered keys. Filter out phantom entries so
		-- the row count stays in sync with the up/down arrow bounds.
		local orderedGradientKeys = {}
		for _, k in ipairs(sharedSettings.gradientOrder) do
			if indicatorDefByKey[k] and indicatorColors[k] then
				orderedGradientKeys[#orderedGradientKeys + 1] = k
			end
		end

		local gradientRows = {}
		controls.indicatorColors.gradientRows = controls.indicatorColors.gradientRows or {}

		local function RefreshGradientRow(rowIndex)
			local row = gradientRows[rowIndex]
			if not row then return end
			local key = orderedGradientKeys[rowIndex]
			local def = indicatorDefByKey[key]
			local indicator = indicatorColors[key]
			if not def or not indicator then return end

			if row.colorPicker then
				row.colorPicker.Texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(indicator.color, true))
				if row.colorPicker.Font then
					row.colorPicker.Font:SetText(def.colorLabel)
				end
				TRB.Functions.OptionsUi:ToggleColorPickerEnabled(row.colorPicker, indicator.enabled)
			end
			if row.dropdown then
				row.dropdown:SetText(GetSummaryText(key))
			end
			if row.upBtn then row.upBtn:SetEnabled(rowIndex > 1) end
			if row.downBtn then row.downBtn:SetEnabled(rowIndex < #orderedGradientKeys) end
		end

		local function SwapGradientNodes(indexA, indexB)
			orderedGradientKeys[indexA], orderedGradientKeys[indexB] = orderedGradientKeys[indexB], orderedGradientKeys[indexA]
			wipe(sharedSettings.gradientOrder)
			for i, k in ipairs(orderedGradientKeys) do
				sharedSettings.gradientOrder[i] = k
			end
			RefreshGradientRow(indexA)
			RefreshGradientRow(indexB)
		end

		for gradIdx, gradKey in ipairs(orderedGradientKeys) do
			local gradDef = indicatorDefByKey[gradKey]
			local gradIndicator = indicatorColors[gradKey]
			if gradDef and gradIndicator then
				local capturedGradIdx = gradIdx
				local gradRow = {}
				gradientRows[gradIdx] = gradRow

				local xOffset = oUi.xCoord

				-- Up arrow
				local upBtn = CreateFrame("Button", nil, parent)
				upBtn:SetSize(20, 20)
				upBtn:SetPoint("TOPLEFT", xOffset, yCoord)
				upBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
				upBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
				upBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
				upBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
				upBtn:SetEnabled(gradIdx > 1)
				upBtn:SetScript("OnClick", function()
					SwapGradientNodes(capturedGradIdx - 1, capturedGradIdx)
				end)
				upBtn:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText(L["NodeOrderMoveUp"], 1, 1, 1)
					GameTooltip:Show()
				end)
				upBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
				gradRow.upBtn = upBtn

				-- Down arrow
				local downBtn = CreateFrame("Button", nil, parent)
				downBtn:SetSize(20, 20)
				downBtn:SetPoint("TOPLEFT", xOffset + 22, yCoord)
				downBtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
				downBtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
				downBtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
				downBtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
				downBtn:SetEnabled(gradIdx < #orderedGradientKeys)
				downBtn:SetScript("OnClick", function()
					SwapGradientNodes(capturedGradIdx, capturedGradIdx + 1)
				end)
				downBtn:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText(L["NodeOrderMoveDown"], 1, 1, 1)
					GameTooltip:Show()
				end)
				downBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
				gradRow.downBtn = downBtn

				xOffset = xOffset + 46

				-- Targets dropdown
				local ddName = ddNamePrefix .. "_Gradient_" .. gradKey .. "_Targets"
				local dd = CreateFrame("DropdownButton", ddName, parent, "WowStyle1DropdownTemplate")
				dd:SetWidth(280)
				dd:SetPoint("TOPLEFT", xOffset, yCoord)
				dd:SetScript("OnEnter", function(self)
					if gradDef.tooltip then
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(gradDef.tooltip, 1, 1, 1, 1, true)
						GameTooltip:Show()
					end
				end)
				dd:SetScript("OnLeave", function() GameTooltip:Hide() end)

				local originalSetText = dd.SetText
				dd.SetText = function(self, text)
					originalSetText(self, GetSummaryText(orderedGradientKeys[capturedGradIdx]))
				end

				dd:SetupMenu(function(dropdown, rootDescription)
					local ck = orderedGradientKeys[capturedGradIdx]
					local ci = indicatorColors[ck]
					if not ci then return end
					ci.targets = ci.targets or {}

					local firstBar = true
					for barIdx, barDef in ipairs(barTargetDefs) do
						local globalExcluded = excludedElements[barDef.key]
						local gradExcluded = gradientExcludedElements[barDef.key]
						local allExcluded = true
						for _, elemDef in ipairs(elementDefs) do
							if not ((globalExcluded and globalExcluded[elemDef.key]) or (gradExcluded and gradExcluded[elemDef.key])) then
								allExcluded = false
								break
							end
						end
						if not allExcluded then
							if not firstBar then
								rootDescription:CreateDivider()
							end
							firstBar = false
							rootDescription:CreateTitle(barDef.label)
							ci.targets[barDef.key] = ci.targets[barDef.key] or {}

							for _, elemDef in ipairs(elementDefs) do
								if not ((globalExcluded and globalExcluded[elemDef.key]) or (gradExcluded and gradExcluded[elemDef.key])) then
									rootDescription:CreateCheckbox(
										elemDef.label,
										function()
											local gk = orderedGradientKeys[capturedGradIdx]
											local indicator = indicatorColors[gk]
											return indicator and indicator.targets and indicator.targets[barDef.key] and indicator.targets[barDef.key][elemDef.key] or false
										end,
										function()
											local gk = orderedGradientKeys[capturedGradIdx]
											local indicator = indicatorColors[gk]
											if not indicator then return end
											indicator.targets = indicator.targets or {}
											indicator.targets[barDef.key] = indicator.targets[barDef.key] or {}
											indicator.targets[barDef.key][elemDef.key] = not indicator.targets[barDef.key][elemDef.key]
											-- Sync enabled state
											local anyEnabled = false
											if indicator.targets then
												for _, bd in ipairs(barTargetDefs) do
													local bt = indicator.targets[bd.key]
													if bt then
														for _, ed in ipairs(elementDefs) do
															if bt[ed.key] then anyEnabled = true; break end
														end
													end
													if anyEnabled then break end
												end
											end
											indicator.enabled = anyEnabled
											if gradRow.colorPicker then
												TRB.Functions.OptionsUi:ToggleColorPickerEnabled(gradRow.colorPicker, anyEnabled)
											end
										end
									)
								end
							end
						end
					end
				end)

				dd:SetText(GetSummaryText(gradKey))
				gradRow.dropdown = dd

				-- Color picker
				local cp = TRB.Functions.OptionsUi:BuildColorPicker(parent, gradDef.colorLabel, gradIndicator.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
				---@cast cp Button
				cp:SetScript("OnMouseDown", function(self, button)
					local gk = orderedGradientKeys[capturedGradIdx]
					TRB.Functions.OptionsUi:ColorOnMouseDown(button, indicatorColors, { [gk] = gradRow.colorPicker }, gk, "indicatorColor_" .. gk)
				end)
				TRB.Functions.OptionsUi:ToggleColorPickerEnabled(cp, gradIndicator.enabled)
				gradRow.colorPicker = cp

				controls.indicatorColors.gradientRows[gradIdx] = gradRow

				yCoord = yCoord - 30
			end
		end
	end

	-- Optional EndOf configuration sections
	if config.endOfConfigs then
		for _, endOfConfig in ipairs(config.endOfConfigs) do
			yCoord = yCoord - 10
			yCoord = TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, classId, specId, yCoord, endOfConfig)
		end
	end

	-- Optional Overcap configuration
	if config.overcapConfig then
		yCoord = yCoord - 40
		yCoord = TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, classId, specId, yCoord, config.overcapConfig.primaryResourceString, config.overcapConfig.primaryResourceMax)
	end

	return yCoord
end

---Builds the nested checkbox used by overlay-capable color options for the full-height behavior.
---@param parent frame The parent frame to attach the checkbox to
---@param frameName string The global frame name to use for the checkbox
---@param parentX number The X coordinate of the parent checkbox row
---@param yCoord number The Y coordinate of the parent checkbox row
---@param isChecked boolean Whether the checkbox should start checked
---@param onClick fun(self: CheckButton) The OnClick handler for the checkbox
---@return CheckButton checkbox The created checkbox
---@return number yCoord The next available Y coordinate after the child row
function TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(parent, frameName, parentX, yCoord, isChecked, onClick)
	local checkbox = CreateFrame("CheckButton", frameName, parent, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", parentX + (oUi.xPadding * 2), yCoord - 18)
	getglobal(checkbox:GetName() .. 'Text'):SetText(L["OverlayFullHeightCheckbox"])
	---@diagnostic disable-next-line: inject-field
	checkbox.tooltip = L["OverlayFullHeightCheckboxTooltip"]
	checkbox:SetChecked(isChecked == true)
	checkbox:SetScript("OnClick", onClick)

	return checkbox, yCoord - 45
end

---Refreshes active bar appearance and values after an overlay geometry setting changes.
---@param classId integer?
---@param specId integer?
function TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
	if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
		local activeSpecCache = TRB.Data.specCache and TRB.Data.specCache[TRB.Data.character.compositeKey]
		if TRB.Frames.barGroups ~= nil and activeSpecCache and activeSpecCache.settings then
			TRB.Functions.Bar:ApplyBarGroupsAppearance(activeSpecCache.settings, TRB.Frames.barGroups)
		end
	end

	if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
		TRB.Data.lookupDirty = true
		TRB.Functions.Class:TriggerResourceBarUpdates()
	end
end

---Generates the bar color and color-changing options panel, including base bar color, casting overlay color, and optional spending overlay color.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param includeOvercap boolean Whether to include overcap-related color options
---@param includeSpendingOverlay boolean Whether to include the spending overlay color option
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateBarColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap, includeSpendingOverlay)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 30
	controls.colors.base = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, primaryResourceString, spec.colors.bar.base, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.base
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		local barFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			barFrame = node and node.GetFrame and node:GetFrame() or nil
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "base", "bar", barFrame)
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.base, self, classId, specId)
	end)

	yCoord = yCoord - 30
	controls.colors.casting = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorCastingOverlay"], spec.colors.bar.casting, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.casting
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "casting")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.casting, self, classId, specId)
	end)

	controls.checkBoxes.castingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlay", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.castingOverlayEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["BarColorCastingOverlayCheckbox"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["BarColorCastingOverlayCheckboxTooltip"]
	f:SetChecked(spec.colors.bar.casting.enabled)
	controls.checkBoxes.castingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_Checkbox_CastingOverlayFullHeight",
		oUi.xCoord,
		yCoord,
		spec.colors.bar.casting.fullHeight == true,
		function(self)
			spec.colors.bar.casting.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar.casting.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.castingOverlayFullHeight, spec.colors.bar.casting.enabled)
		if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
			TRB.Data.lookupDirty = true
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	if includeSpendingOverlay then
		controls.colors.spending = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["BarColorSpendingOverlay"], spec.colors.bar.spending, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.spending
		f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "spending")
		end)
		f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.bar.spending, self, classId, specId)
		end)

		controls.checkBoxes.spendingOverlayEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlay", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.spendingOverlayEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BarColorSpendingOverlayCheckbox"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = L["BarColorSpendingOverlayCheckboxTooltip"]
		f:SetChecked(spec.colors.bar.spending.enabled)
		controls.checkBoxes.spendingOverlayFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
			parent,
			"TwintopResourceBar_" .. namePrefix .. "_Checkbox_SpendingOverlayFullHeight",
			oUi.xCoord,
			yCoord,
			spec.colors.bar.spending.fullHeight == true,
			function(self)
				spec.colors.bar.spending.fullHeight = self:GetChecked()
				TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
			end
		)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.spending.enabled = self:GetChecked()
			TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.spendingOverlayFullHeight, spec.colors.bar.spending.enabled)
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end)
	end

	return yCoord
end

---Generates the bar border color options panel, including base border color and optional overcap border color toggle and picker.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing bar border color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param includeOvercap boolean Whether to include the overcap border color option
---@param isHealer boolean? Whether the spec is a healer (reserved for future healer-specific options)
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateBarBorderColorOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, includeOvercap, isHealer)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.barColorsSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["BarBorderColorsChangingHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 25
	controls.colors.border = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["BorderColorBase"], spec.colors.bar.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.border
	f:SetScript("OnMouseDown", function(self, button, ...)
		local borderFrame = nil
		if TRB.Frames.barGroups and TRB.Frames.barGroups.primary then
			local node = TRB.Frames.barGroups.primary:GetNode(1)
			borderFrame = node and node.GetFrame and node:GetFrame()
		end
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "border", "border", borderFrame)
	end)

	if includeOvercap then
		yCoord = yCoord - 30
		controls.checkBoxes.overcapEnabled = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Border_Option_overcapBorderChange", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.overcapEnabled
		f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["BorderColorOvercapToggle"])
		---@diagnostic disable-next-line: inject-field
		f.tooltip = string.format(L["BorderColorOvercapToggleTooltip"], primaryResourceString)
		f:SetChecked(spec.colors.bar.borderOvercap.enabled)
		f:SetScript("OnClick", function(self, ...)
			spec.colors.bar.borderOvercap.enabled = self:GetChecked()
		end)

		controls.colors.borderOvercap = TRB.Functions.OptionsUi:BuildColorPicker(parent, string.format(L["BorderColorOvercap"], primaryResourceString), spec.colors.bar.borderOvercap.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
		f = controls.colors.borderOvercap
		f:SetScript("OnMouseDown", function(self, button, ...)
			TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, "borderOvercap")
		end)
	end

	if isHealer then
	end

	return yCoord
end

---Generates the health bar color options panel, including threshold-based health colors, absorb overlay settings, and incoming heal overlay settings.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing health bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateHealthBarColorOptions(parent, controls, spec, classId, specId, yCoord)
	local L = TRB.Localization or {}
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	-- Build the header
	controls.healthBarColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealthBarColorHeader"], oUi.xCoord, yCoord)

	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalHealthBarColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_healthBarColors", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalHealthBarColors
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "healthBar")
		f.tooltip = L["CheckboxUseGlobalTooltip_HealthBarColors"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].healthBarColors)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].healthBarColors = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			if (TRB.Data.character.classId == classId and TRB.Data.character.specId == specId) then
				TRB.Functions.Character:UpdateHealthValues()
				if TRB.Frames.barGroups ~= nil then
					local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
					TRB.Functions.Bar:ApplyBarGroupsAppearance(settings, TRB.Frames.barGroups)
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("healthBarColors")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "healthBarColors")
	elseif classId == nil and specId == nil then
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllHealthBarColors", "healthBarColors", yCoord)
	end

	yCoord = yCoord - 30

	-- Create a lightweight bar type definition-like object for Health Bar
	-- This allows us to use the generic threshold color function while keeping
	-- the Health Bar's settings at spec.colors.healthBar (not spec.colors.bars.health)
	-- IMPORTANT: Pass resolved localized strings, NOT localization keys
	local healthBarTypeDef = {
		key = "health",
		displayName = L["HealthBarThresholdDisplayName"],
		colorCurveType = "step",
		thresholdLevels = {
			{ key = "low", colorLabel = L["HealthBarColorLow"] },
			{ key = "medium", colorLabel = L["HealthBarColorMedium"], sliderLabel = L["HealthBarThresholdMedium"], sliderTooltip = L["HealthBarThresholdMediumTooltip"] },
			{ key = "high", colorLabel = L["HealthBarColorHigh"], sliderLabel = L["HealthBarThresholdHigh"], sliderTooltip = L["HealthBarThresholdHighTooltip"] }
		},
		colorTypeLabel = L["HealthBarColorType"],
		colorTypeStepLabel = L["HealthBarColorTypeStep"],
		colorTypeLinearLabel = L["HealthBarColorTypeLinear"],
		colorTypeNoneLabel = L["HealthBarColorTypeNone"],
		-- Custom GetColors to retrieve from spec.colors.healthBar instead of spec.colors.bars.health
		GetColors = function(self, specSettings)
			if specSettings and specSettings.colors then
				return specSettings.colors.healthBar
			end
			return nil
		end
	}

	-- Use the generic threshold color function with the Health Bar callback
	yCoord = TRB.Functions.OptionsUi:GenerateCustomBarThresholdColorOptions(
		parent, controls, spec, classId, specId, yCoord, healthBarTypeDef,
		function()
			TRB.Functions.Character:UpdateHealthValues()
		end
	)

	yCoord = yCoord - 10
	-- Absorb Display Mode dropdown
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.absorbMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_AbsorbMode", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.absorbMode:SetWidth(oUi.sliderWidth)
	controls.dropDown.absorbMode.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealthBarAbsorbMode"], oUi.xCoord, yCoord)
	controls.dropDown.absorbMode.label.font:SetFontObject(GameFontNormal)
	---@diagnostic disable-next-line: inject-field
	controls.dropDown.absorbMode.label.font.tooltip = L["HealthBarAbsorbModeTooltip"]

	local function AbsorbModeIsSelected(value)
		return value == spec.colors.healthBar.absorb.mode
	end

	local function AbsorbModeGetDisplayName(value)
		if value == "appended" then
			return L["OverlayModeAppended"]
		elseif value == "appendedOverflow" then
			return L["OverlayModeAppendedOverflow"]
		elseif value == "inset" then
			return L["OverlayModeInset"]
		else
			return L["OverlayModeOverlay"]
		end
	end

	local function AbsorbModeSetSelected(newValue)
		spec.colors.healthBar.absorb.mode = newValue
		controls.dropDown.absorbMode:SetDefaultText(AbsorbModeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function AbsorbModeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["OverlayModeAppended"], AbsorbModeIsSelected, AbsorbModeSetSelected, "appended")
		rootDescription:CreateRadio(L["OverlayModeAppendedOverflow"], AbsorbModeIsSelected, AbsorbModeSetSelected, "appendedOverflow")
		rootDescription:CreateRadio(L["OverlayModeOverlay"], AbsorbModeIsSelected, AbsorbModeSetSelected, "overlay")
		rootDescription:CreateRadio(L["OverlayModeInset"], AbsorbModeIsSelected, AbsorbModeSetSelected, "inset")
	end

	controls.dropDown.absorbMode:SetupMenu(AbsorbModeGenerator)
	controls.dropDown.absorbMode:SetDefaultText(AbsorbModeGetDisplayName(spec.colors.healthBar.absorb.mode))
	controls.dropDown.absorbMode:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	yCoord = yCoord - 10

	controls.colors = controls.colors or {}
	controls.colors.absorb = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealthBarAbsorbColor"], spec.colors.healthBar.absorb.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.absorb:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.healthBar, controls.colors, "absorb", "health")
	end)

	local absorbCheckboxY = yCoord - 20
	controls.checkBoxes.showAbsorb = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_showAbsorb", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showAbsorb
	f:SetPoint("TOPLEFT", oUi.xCoord2, absorbCheckboxY)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealthBarShowAbsorb"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["HealthBarShowAbsorbTooltip"]
	f:SetChecked(spec.colors.healthBar.absorb.enabled)
	controls.checkBoxes.showAbsorbFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_showAbsorbFullHeight",
		oUi.xCoord2,
		absorbCheckboxY,
		spec.colors.healthBar.absorb.fullHeight == true,
		function(self)
			spec.colors.healthBar.absorb.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showAbsorbFullHeight, spec.colors.healthBar.absorb.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.healthBar.absorb.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showAbsorbFullHeight, spec.colors.healthBar.absorb.enabled)
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Incoming Heal Display Mode dropdown
	controls.dropDown.incomingHealMode = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_IncomingHealMode", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.incomingHealMode:SetWidth(oUi.sliderWidth)
	controls.dropDown.incomingHealMode.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["HealthBarIncomingHealMode"], oUi.xCoord, yCoord)
	controls.dropDown.incomingHealMode.label.font:SetFontObject(GameFontNormal)
	---@diagnostic disable-next-line: inject-field
	controls.dropDown.incomingHealMode.label.font.tooltip = L["HealthBarIncomingHealModeTooltip"]

	local function IncomingHealModeIsSelected(value)
		return value == spec.colors.healthBar.incomingHeal.mode
	end

	local function IncomingHealModeGetDisplayName(value)
		if value == "appended" then
			return L["OverlayModeAppended"]
		elseif value == "appendedOverflow" then
			return L["OverlayModeAppendedOverflow"]
		elseif value == "inset" then
			return L["OverlayModeInset"]
		else
			return L["OverlayModeOverlay"]
		end
	end

	local function IncomingHealModeSetSelected(newValue)
		spec.colors.healthBar.incomingHeal.mode = newValue
		controls.dropDown.incomingHealMode:SetDefaultText(IncomingHealModeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function IncomingHealModeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["OverlayModeAppended"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "appended")
		rootDescription:CreateRadio(L["OverlayModeAppendedOverflow"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "appendedOverflow")
		rootDescription:CreateRadio(L["OverlayModeOverlay"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "overlay")
		rootDescription:CreateRadio(L["OverlayModeInset"], IncomingHealModeIsSelected, IncomingHealModeSetSelected, "inset")
	end

	controls.dropDown.incomingHealMode:SetupMenu(IncomingHealModeGenerator)
	controls.dropDown.incomingHealMode:SetDefaultText(IncomingHealModeGetDisplayName(spec.colors.healthBar.incomingHeal.mode))
	controls.dropDown.incomingHealMode:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)

	yCoord = yCoord - 10
	-- Incoming Heal Overlay
	controls.colors.incomingHeal = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["HealthBarIncomingHealColor"], spec.colors.healthBar.incomingHeal.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	controls.colors.incomingHeal:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.healthBar, controls.colors, "incomingHeal", "health")
	end)

	local incomingHealCheckboxY = yCoord - 20
	controls.checkBoxes.showIncomingHeal = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_showIncomingHeal", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.showIncomingHeal
	f:SetPoint("TOPLEFT", oUi.xCoord2, incomingHealCheckboxY)
	getglobal(f:GetName() .. 'Text'):SetText(L["HealthBarShowIncomingHeal"])
	---@diagnostic disable-next-line: inject-field
	f.tooltip = L["HealthBarShowIncomingHealTooltip"]
	f:SetChecked(spec.colors.healthBar.incomingHeal.enabled)
	controls.checkBoxes.showIncomingHealFullHeight, yCoord = TRB.Functions.OptionsUi:BuildOverlayFullHeightCheckbox(
		parent,
		"TwintopResourceBar_" .. namePrefix .. "_showIncomingHealFullHeight",
		oUi.xCoord2,
		incomingHealCheckboxY,
		spec.colors.healthBar.incomingHeal.fullHeight == true,
		function(self)
			spec.colors.healthBar.incomingHeal.fullHeight = self:GetChecked()
			TRB.Functions.OptionsUi:RefreshOverlayGeometryPreview(classId, specId)
		end
	)
	TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showIncomingHealFullHeight, spec.colors.healthBar.incomingHeal.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.healthBar.incomingHeal.enabled = self:GetChecked()
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(controls.checkBoxes.showIncomingHealFullHeight, spec.colors.healthBar.incomingHeal.enabled)
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	return yCoord - 30
end

---Generates the Brewmaster Monk stagger bar color options panel, including light/medium/heavy threshold colors, color transition type, threshold sliders, border, and background colors.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing stagger bar color configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateStaggerBarColorOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	controls.staggerBarColorSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["StaggerBarColorHeader"], oUi.xCoord, yCoord)

	-- Color Transition Type dropdown
	yCoord = yCoord - 30
	local yCoord2 = yCoord - 30
	controls.dropDown = controls.dropDown or {}
	controls.dropDown.staggerColorCurveType = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_StaggerColorCurveType", parent, "WowStyle1DropdownTemplate")
	controls.dropDown.staggerColorCurveType:SetWidth(oUi.sliderWidth)
	controls.dropDown.staggerColorCurveType.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["StaggerBarColorType"], oUi.xCoord, yCoord)
	controls.dropDown.staggerColorCurveType.label.font:SetFontObject(GameFontNormal)

	local function StaggerColorCurveTypeIsSelected(value)
		return value == spec.colors.comboPoints.type
	end

	local function StaggerColorCurveTypeGetDisplayName(value)
		if value == "step" then
			return L["StaggerBarColorTypeStep"]
		elseif value == "linear" then
			return L["StaggerBarColorTypeLinear"]
		else
			return L["StaggerBarColorTypeNone"]
		end
	end

	local function StaggerColorCurveTypeSetSelected(newValue)
		spec.colors.comboPoints.type = newValue
		controls.dropDown.staggerColorCurveType:SetDefaultText(StaggerColorCurveTypeGetDisplayName(newValue))
		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end

	local function StaggerColorCurveTypeGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["StaggerBarColorTypeStep"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "step")
		rootDescription:CreateRadio(L["StaggerBarColorTypeLinear"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "linear")
		rootDescription:CreateRadio(L["StaggerBarColorTypeNone"], StaggerColorCurveTypeIsSelected, StaggerColorCurveTypeSetSelected, "none")
	end

	controls.dropDown.staggerColorCurveType:SetupMenu(StaggerColorCurveTypeGenerator)
	controls.dropDown.staggerColorCurveType:SetDefaultText(StaggerColorCurveTypeGetDisplayName(spec.colors.comboPoints.type))
	controls.dropDown.staggerColorCurveType:SetPoint("TOPLEFT", oUi.xCoord, yCoord - 30)


	-- Medium Stagger Threshold Slider
	yCoord = yCoord - 80
	controls.staggerThresholdMedium = TRB.Functions.OptionsUi:BuildSlider(parent, L["StaggerBarThresholdMedium"], 0, 1, spec.colors.comboPoints.medium.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdMedium.tooltip = L["StaggerBarThresholdMediumTooltip"]
	controls.staggerThresholdMedium:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.medium.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.medium.threshold = spec.colors.comboPoints.heavy.threshold
			controls.staggerThresholdMedium.EditBox:SetText(spec.colors.comboPoints.medium.threshold)
			controls.staggerThresholdMedium:SetValue(spec.colors.comboPoints.medium.threshold)
		end

		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)

	-- Heavy Stagger Threshold Slider
	yCoord = yCoord - 60
	controls.staggerThresholdHeavy = TRB.Functions.OptionsUi:BuildSlider(parent, L["StaggerBarThresholdHeavy"], 0, 1, spec.colors.comboPoints.heavy.threshold, 0.01, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.staggerThresholdHeavy.tooltip = L["StaggerBarThresholdHeavyTooltip"]
	controls.staggerThresholdHeavy:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		spec.colors.comboPoints.heavy.threshold = value

		if spec.colors.comboPoints.heavy.threshold < spec.colors.comboPoints.medium.threshold then
			spec.colors.comboPoints.heavy.threshold = spec.colors.comboPoints.medium.threshold
			controls.staggerThresholdHeavy.EditBox:SetText(spec.colors.comboPoints.heavy.threshold)
			controls.staggerThresholdHeavy:SetValue(spec.colors.comboPoints.heavy.threshold)
		end

		if TRB.Functions.OptionsUi:IsEditingActiveSpec(classId, specId) then
			if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
				TRB.Data.lookupDirty = true
				TRB.Functions.Class:TriggerResourceBarUpdates()
			end
		end
	end)


	-- Light Stagger Color
	controls.colors = controls.colors or {}
	controls.colors.comboPoints = controls.colors.comboPoints or {}
	controls.colors.comboPoints.light = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["StaggerBarColorLight"], spec.colors.comboPoints.light, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.light
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "light", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.light, self)
	end)

	-- Medium Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.medium = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["StaggerBarColorMedium"], spec.colors.comboPoints.medium, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.medium
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "medium", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.medium, self)
	end)

	-- Heavy Stagger Color
	yCoord2 = yCoord2 - 30
	controls.colors.comboPoints.heavy = TRB.Functions.OptionsUi:BuildGradientColorPicker(parent, L["StaggerBarColorHeavy"], spec.colors.comboPoints.heavy, oUi.colorPickerTextWidth, oUi.gradientColorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.comboPoints.heavy
	f.Swatch1:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors.comboPoints, "heavy", "stagger")
	end)
	f.Swatch2:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:GradientColor2OnMouseDown(button, spec.colors.comboPoints.heavy, self)
	end)

	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBorder = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["StaggerBarColorBorder"], spec.colors.comboPoints.border.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBorder
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "border", "border", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord2 = yCoord2 - 30

	controls.colors.staggerColorBackground = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["ColorPickerUnfilledBarBackground"], spec.colors.comboPoints.background.color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord2)
	f = controls.colors.staggerColorBackground
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.comboPoints, controls.colors, "background", "backdrop", TRB.Functions.OptionsUi:GetSecondaryBackdropFrames())
	end)

	yCoord = yCoord2 - 20

	return yCoord
end

---Generates the overcapping configuration panel with relative offset and fixed value modes for determining the overcap threshold.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing overcap configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param primaryResourceMax number The maximum value of the primary resource
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateOvercapOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.overcappingConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["OvercappingConfigurationHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	controls.checkBoxes.overcapModeRelative = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Relative", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeRelative
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapRelativeOffset"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "relative" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(true)
		controls.checkBoxes.overcapModeFixed:SetChecked(false)
		spec.overcap.mode = "relative"
	end)

	title = string.format(L["OvercapRelativeOffsetAmount"], primaryResourceString)
	controls.overcapRelative = TRB.Functions.OptionsUi:BuildSlider(parent, title, -primaryResourceMax, 0, spec.overcap.relative, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapRelative:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.relative = value
	end)


	yCoord = yCoord - 60
	controls.checkBoxes.overcapModeFixed = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_Overcap_RadioButton_Fixed", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes.overcapModeFixed
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(string.format(L["OvercapFixedValue"], primaryResourceString))
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if spec.overcap.mode == "fixed" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes.overcapModeRelative:SetChecked(false)
		controls.checkBoxes.overcapModeFixed:SetChecked(true)
		spec.overcap.mode = "fixed"
	end)

	title = string.format(L["OvercapAbove"], primaryResourceString)
	controls.overcapFixed = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, primaryResourceMax, spec.overcap.fixed, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.overcapFixed:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.overcap.fixed = value
	end)

	return yCoord
end

---Generates the maximum resource override configuration panel with an enable checkbox and a slider for setting a custom max resource value.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing max resource configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param primaryResourceString string The localized name of the primary resource (e.g., "Insanity", "Rage")
---@param primaryResourceMin number The minimum allowed value for the max resource slider
---@param primaryResourceMax number The maximum allowed value for the max resource slider
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateMaxResourceOptions(parent, controls, spec, classId, specId, yCoord, primaryResourceString, primaryResourceMin, primaryResourceMax)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil
	local title = ""

	controls.maxResourceConfiguration = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["MaxResourceHeader"], oUi.xCoord, yCoord)

	yCoord = yCoord - 40
	title = string.format(L["MaxResourceValue"], primaryResourceString)
	controls.checkBoxes.maxResourceEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_maxResourceEnabled", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.maxResourceEnabled
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["MaxResourceEnabled"])
	f.tooltip = L["MaxResourceEnabledTooltip"]
	f:SetChecked(spec.maxResource.enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.maxResource.enabled = self:GetChecked()
	end)

	controls.maxResourceValue = TRB.Functions.OptionsUi:BuildSlider(parent, title, primaryResourceMin, primaryResourceMax, spec.maxResource.value, 1, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.maxResourceValue:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		spec.maxResource.value = value
		if (classId == nil and specId == nil) or (classId == TRB.Data.character.classId and specId == TRB.Data.character.specId) then
			if TRB.Frames.barGroups ~= nil and TRB.Data.character.compositeKey then
				local settings = TRB.Data.specCache[TRB.Data.character.compositeKey].settings
				TRB.Functions.Bar:ApplyBarGroupsLayout(settings, TRB.Frames.barGroups)
				if TRB.Functions.Class and TRB.Functions.Class.TriggerResourceBarUpdates then
					TRB.Data.lookupDirty = true
					TRB.Functions.Class:TriggerResourceBarUpdates()
				end
			end
		end
	end)

	return yCoord
end

---Generates the "End Of" buff color options UI (active buff color checkbox + color picker, ending color checkbox + color picker)
---@param parent Frame # The parent frame
---@param controls table # The controls table
---@param spec table # The spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Current Y coordinate
---@param config table # Configuration table with: endOfKey, activeColorKey, endColorKey, checkboxLabel, checkboxTooltip, activeColorLabel, endColorLabel, additionalColors (optional)
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi:GenerateEndOfColorOptions(parent, controls, spec, classId, specId, yCoord, config)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	-- Active buff color checkbox + color picker
	controls.checkBoxes = controls.checkBoxes or {}
	controls.colors = controls.colors or {}

	controls.checkBoxes[config.activeColorKey .. "BarChange"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. config.activeColorKey .. "Change", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes[config.activeColorKey .. "BarChange"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.checkboxLabel)
	f.tooltip = config.checkboxTooltip
	f:SetChecked(spec.colors.bar[config.activeColorKey].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.colors.bar[config.activeColorKey].enabled = self:GetChecked()
	end)

	controls.colors[config.activeColorKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, config.activeColorLabel, spec.colors.bar[config.activeColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.activeColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.activeColorKey)
	end)

	-- End of buff color checkbox + color picker
	yCoord = yCoord - 30
	controls.checkBoxes["endOf" .. config.endOfKey] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. config.endOfKey .. "ColorChange", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.endCheckboxLabel)
	f.tooltip = config.endCheckboxTooltip
	f:SetChecked(spec.endOf[config.endOfKey].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.endOf[config.endOfKey].enabled = self:GetChecked()
	end)

	controls.colors[config.endColorKey] = TRB.Functions.OptionsUi:BuildColorPicker(parent, config.endColorLabel, spec.colors.bar[config.endColorKey].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors[config.endColorKey]
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, config.endColorKey)
	end)

	-- Additional colors (optional)
	if config.additionalColors ~= nil then
		for _, colorConfig in ipairs(config.additionalColors) do
			yCoord = yCoord - 30
			controls.checkBoxes[colorConfig.key .. "Change"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_Bar_Option_" .. colorConfig.key .. "Change", parent, "ChatConfigCheckButtonTemplate")
			f = controls.checkBoxes[colorConfig.key .. "Change"]
			f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
			getglobal(f:GetName() .. 'Text'):SetText(colorConfig.checkboxLabel)
			f.tooltip = colorConfig.checkboxTooltip
			f:SetChecked(spec.colors.bar[colorConfig.key].enabled)
			f:SetScript("OnClick", function(self, ...)
				spec.colors.bar[colorConfig.key].enabled = self:GetChecked()
			end)

			controls.colors[colorConfig.key] = TRB.Functions.OptionsUi:BuildColorPicker(parent, colorConfig.colorLabel, spec.colors.bar[colorConfig.key].color, oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
			f = controls.colors[colorConfig.key]
			local capturedKey = colorConfig.key
			f:SetScript("OnMouseDown", function(self, button, ...)
				TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.colors.bar, controls.colors, capturedKey)
			end)
		end
	end

	return yCoord
end

---Generates the "End Of" buff configuration options UI (GCD/Time radio buttons and sliders)
---@param parent Frame # The parent frame
---@param controls table # The controls table
---@param spec table # The spec settings table
---@param classId integer # Class ID
---@param specId integer # Spec ID
---@param yCoord number # Current Y coordinate
---@param config table # Configuration table with: endOfKey, sectionHeader, gcdRadioLabel, gcdSliderLabel, timeRadioLabel, timeSliderLabel, gcdSliderMax (optional), timeSliderMax (optional)
---@return number # Updated Y coordinate
function TRB.Functions.OptionsUi:GenerateEndOfConfigurationOptions(parent, controls, spec, classId, specId, yCoord, config)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName
	local f = nil

	local endOfSettings = spec.endOf[config.endOfKey]
	local gcdSliderMax = config.gcdSliderMax or 30
	local timeSliderMax = config.timeSliderMax or 15

	controls.checkBoxes = controls.checkBoxes or {}

	controls.textSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, config.sectionHeader, oUi.xCoord, yCoord)

	yCoord = yCoord - 40

	controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_endOf" .. config.endOfKey .. "_modeGCDs", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.gcdRadioLabel)
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if endOfSettings.mode == "gcd" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]:SetChecked(true)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]:SetChecked(false)
		endOfSettings.mode = "gcd"
	end)

	controls["endOf" .. config.endOfKey .. "GCDs"] = TRB.Functions.OptionsUi:BuildSlider(parent, config.gcdSliderLabel, 0.5, gcdSliderMax, endOfSettings.gcdsMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "GCDs"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		endOfSettings.gcdsMax = value
	end)

	yCoord = yCoord - 60
	controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_endOf" .. config.endOfKey .. "_modeTime", parent, "UIRadioButtonTemplate")
	f = controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(config.timeRadioLabel)
	getglobal(f:GetName() .. 'Text'):SetFontObject(GameFontHighlight)
	if endOfSettings.mode == "time" then
		f:SetChecked(true)
	end
	f:SetScript("OnClick", function(self, ...)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeGCDs"]:SetChecked(false)
		controls.checkBoxes["endOf" .. config.endOfKey .. "ModeTime"]:SetChecked(true)
		endOfSettings.mode = "time"
	end)

	controls["endOf" .. config.endOfKey .. "Time"] = TRB.Functions.OptionsUi:BuildSlider(parent, config.timeSliderLabel, 0, timeSliderMax, endOfSettings.timeMax, 0.25, 2,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls["endOf" .. config.endOfKey .. "Time"]:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 2, nil, true)
		self.EditBox:SetText(value)
		endOfSettings.timeMax = value
	end)

	return yCoord
end

---Generates the default bar text font settings panel, including font face dropdown, default font color picker, and font size slider with optional global toggle.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing display text font configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateDefaultFontOptions(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}
	controls.dropDown.fonts = {}

	controls.textDisplayDefaultSection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DefaultBarTextFontSettingsHeader"], oUi.xCoord, yCoord)

	-- Show informational notice about how default font settings work
	yCoord = yCoord - 30
	controls.defaultFontNotice = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	controls.defaultFontNotice:SetPoint("TOPLEFT", oUi.xCoord + oUi.xPadding, yCoord)
	controls.defaultFontNotice:SetWidth(550)
	controls.defaultFontNotice:SetJustifyH("LEFT")
	controls.defaultFontNotice:SetText("|cFFCCCCCC" .. L["DefaultFontSettingsNotice"] .. "|r")

	if specId ~= nil and classId ~= nil then
		yCoord = yCoord - 30
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobal = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_displayText", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobal
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "fontText")
		f.tooltip = L["CheckboxUseGlobalTooltip_Font"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].displayText)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].displayText = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("displayText")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "displayText")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllDisplayText", "displayText", yCoord)
	end
	yCoord = yCoord - 30

	FillFontCache()

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFaceDefault", parent, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["FontFaceHeader"], oUi.xCoord, yCoord)
	barTextFontFace.label.font:SetFontObject(GameFontNormal)

	local function FontFaceIsSelected(value)
		return value == spec.displayText.default.fontFace
	end

	local function FontFaceSetSelected(newValue)
		spec.displayText.default.fontFace = newValue
		spec.displayText.default.fontFaceName = fontPairsByName[newValue]
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end

	local function FontFaceGenerator(dropdown, rootDescription)
		for k, v in pairs(fontPairs) do
			local radio = rootDescription:CreateRadio(v[1], FontFaceIsSelected, FontFaceSetSelected, v[2])
			radio:AddInitializer(function(button, description, menu)
				local font = CreateFont(v[2])
				font:SetFont(v[2], 12, spec.displayText.default.fontOutline or "OUTLINE")
				button.fontString:SetFontObject(font)
			end)
		end
		rootDescription:SetScrollMode(400)
	end
	barTextFontFace:SetupMenu(FontFaceGenerator)
	barTextFontFace:SetPoint("TOPLEFT", oUi.xCoord, yCoord-30)

	yCoord = yCoord - 10
	controls.colors.text.color = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["DefaultFontColor"], spec.displayText.default.color.color,
																		oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.color
	f:SetScript("OnMouseDown", function(self, button, ...)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, spec.displayText.default, controls.colors.text, "color")
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	-- Font Shadow section
	yCoord = yCoord - 30

	controls.colors.text.fontShadowColor = TRB.Functions.OptionsUi:BuildColorPicker(parent, L["FontSharedShadowColor"],
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.color) or "FF000000",
		oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	f = controls.colors.text.fontShadowColor
	f:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			if spec.displayText.default.fontShadow == nil then
				spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
			end
			local colorString = spec.displayText.default.fontShadow.color or "FF000000"
			local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
			TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
				local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
				controls.colors.text.fontShadowColor.Texture:SetColorTexture(r_1, g_1, b_1, a_1)
				spec.displayText.default.fontShadow.color = TRB.Functions.Color:ConvertColorDecimalToHex(r_1, g_1, b_1, a_1)
				TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			end)
		end
	end)

	yCoord = yCoord - 50
	title = L["DefaultFontSize"]
	controls.fontSizeDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, 6, 72, spec.displayText.default.fontSize, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontSizeDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		spec.displayText.default.fontSize = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	-- Font Outline dropdown
	local fontOutlineOptions = {
		{ label = L["FontOutlineNone"], value = "" },
		{ label = L["FontOutlineOutline"], value = "OUTLINE" },
		{ label = L["FontOutlineThickOutline"], value = "THICKOUTLINE" },
		{ label = L["FontOutlineMonochrome"], value = "MONOCHROME" },
		{ label = L["FontOutlineOutlineMonochrome"], value = "OUTLINE, MONOCHROME" },
		{ label = L["FontOutlineThickOutlineMonochrome"], value = "THICKOUTLINE, MONOCHROME" },
	}
	local fontOutlineLookup = {}
	for _, opt in ipairs(fontOutlineOptions) do
		fontOutlineLookup[opt.value] = opt.label
	end

	local barTextFontOutline = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontOutlineDefault", parent, "WowStyle1DropdownTemplate")
	barTextFontOutline:SetWidth(oUi.sliderWidth)
	barTextFontOutline.label = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DefaultFontOutline"], oUi.xCoord2, yCoord+25)
	barTextFontOutline.label.font:SetFontObject(GameFontNormal)

	local function FontOutlineIsSelected(value)
		return value == (spec.displayText.default.fontOutline or "OUTLINE")
	end

	local function FontOutlineSetSelected(newValue)
		spec.displayText.default.fontOutline = newValue
		spec.displayText.default.fontOutlineName = fontOutlineLookup[newValue] or L["FontOutlineOutline"]
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end

	local function FontOutlineGenerator(dropdown, rootDescription)
		for _, opt in ipairs(fontOutlineOptions) do
			rootDescription:CreateRadio(opt.label, FontOutlineIsSelected, FontOutlineSetSelected, opt.value)
		end
	end
	barTextFontOutline:SetupMenu(FontOutlineGenerator)
	barTextFontOutline:SetPoint("TOPLEFT", oUi.xCoord2, yCoord-5)

	yCoord = yCoord - 50
	title = L["FontShadowXOffset"]
	controls.fontShadowXOffsetDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, -10, 10,
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.xOffset) or 1, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.fontShadowXOffsetDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		if spec.displayText.default.fontShadow == nil then
			spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		spec.displayText.default.fontShadow.xOffset = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	title = L["FontShadowYOffset"]
	controls.fontShadowYOffsetDefault = TRB.Functions.OptionsUi:BuildSlider(parent, title, -10, 10,
		(spec.displayText.default.fontShadow and spec.displayText.default.fontShadow.yOffset) or -1, 1, 0,
		oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	controls.fontShadowYOffsetDefault:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		if spec.displayText.default.fontShadow == nil then
			spec.displayText.default.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		spec.displayText.default.fontShadow.yOffset = value
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
	end)

	return yCoord
end

---Generates the "Use Global" checkbox for text color settings, allowing a spec to inherit global text colors.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing text color configuration
---@param classId integer The class ID
---@param specId integer The spec ID
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateUseDefaultTextColors(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	local lowerClassName = string.lower(className)
	controls.checkBoxes.useGlobalTextColors = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_textColors", parent, "ChatConfigCheckButtonTemplate")
	f = controls.checkBoxes.useGlobalTextColors
	f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
	getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
	TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "fontText")
	f.tooltip = L["CheckboxUseGlobalTooltip_TextColors"]
	f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].textColors)
	f:SetScript("OnClick", function(self, ...)
		TRB.Data.settings.core.global[lowerClassName][specName].textColors = self:GetChecked()
		TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
		TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
		TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("textColors")
	end)
	TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "textColors")

	return yCoord
end

---Generates the decimal precision configuration panel with sliders for secondary resource, mana, and health display precision, plus an optional global toggle.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param spec table The spec settings table containing precision configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:GenerateUseDefaultDecimalPrecision(parent, controls, spec, classId, specId, yCoord)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	local f = nil
	local title = ""

	controls.colors.text = controls.colors.text or {}
	controls.checkBoxes = controls.checkBoxes or {}

	yCoord = yCoord - 30
	controls.textDisplaySection = TRB.Functions.OptionsUi:BuildSectionHeader(parent, L["DecimalPrecisionHeader"], oUi.xCoord, yCoord)
	if classId ~= nil and specId ~= nil then
		yCoord = yCoord - 25
		local lowerClassName = string.lower(className)
		controls.checkBoxes.useGlobalPrecision = CreateFrame("CheckButton", "TwintopResourceBar_".. namePrefix .."_useGlobal_precision", parent, "ChatConfigCheckButtonTemplate")
		f = controls.checkBoxes.useGlobalPrecision
		f:SetPoint("TOPLEFT", oUi.xCoord+oUi.xPadding, yCoord)
		getglobal(f:GetName() .. 'Text'):SetText(L["CheckboxUseGlobal"])
		getglobal(f:GetName() .. 'Text'):SetTextColor(GetUseGlobalSettingsColor())
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "fontText")
		f.tooltip = L["CheckboxUseGlobalTooltip_Precision"]
		f:SetChecked(TRB.Data.settings.core.global[lowerClassName][specName].precision)
		f:SetScript("OnClick", function(self, ...)
			TRB.Data.settings.core.global[lowerClassName][specName].precision = self:GetChecked()
			TRB.Functions.Character:FillSpecializationCacheSettings(lowerClassName, specName)
			TRB.Functions.BarText:CreateBarTextFrames(classId, specId)
			TRB.Data.snapshotData.attributes.cacheRefresh = true
			TRB.Data.lookupDirty = true
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("precision")
		end)
		TRB.Functions.OptionsUi:BuildUseGlobalCopyButton(f, classId, specId, "precision")
	else
		-- Global options panel - add bulk toggle checkbox
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllPrecision", "precision", yCoord)
		yCoord = yCoord + 25 -- Offset adjustment for consistency with per-spec layout
	end
	yCoord = yCoord - 50

	title = L["SecondaryDecimalPrecision"]
	controls.precisionSecondary = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.secondary, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionSecondary:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.secondary = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
		TRB.Data.lookupDirty = true
		TRB.Functions.Character:RecomputeFormattedValues()
	end)

	if (classId == nil and specId == nil) or -- Global
		(classId == 2) or -- Paladin
		(classId == 5) or -- Priest
		(classId == 7) or -- Shaman
		(classId == 8) or -- Mage
		(classId == 9) or -- Warlock
		(classId == 10 and specId == 2) or -- Monk Mistweaver
		(classId == 11) or -- Druid
		(classId == 13) -- Evoker
		then
		title = L["ManaDecimalPrecision"]
		controls.precisionMana = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.mana, 1, 0,
										oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
		controls.precisionMana:SetScript("OnValueChanged", function(self, value)
			value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
			value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
			self.EditBox:SetText(value)
			spec.precision.mana = value
			TRB.Data.snapshotData.attributes.cacheRefresh = true
			TRB.Data.lookupDirty = true
			TRB.Functions.Character:RecomputeFormattedValues()
		end)
	end

	yCoord = yCoord - 60

	title = L["HealthDecimalPrecision"]
	controls.precisionHealth = TRB.Functions.OptionsUi:BuildSlider(parent, title, 0, 10, spec.precision.health, 1, 0,
									oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	controls.precisionHealth:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		value = TRB.Functions.Number:RoundTo(value, 0, nil, true)
		self.EditBox:SetText(value)
		spec.precision.health = value
		TRB.Data.snapshotData.attributes.cacheRefresh = true
		TRB.Data.lookupDirty = true
		TRB.Functions.Character:RecomputeFormattedValues()
	end)


	return yCoord
end

---Creates an audio cue option row with an enable checkbox and a sound selection dropdown for a named audio trigger.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param name string The key name of the audio option in spec.audio (e.g., "overcap")
---@param spec table The spec settings table containing audio configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for layout positioning
---@param localization string The localized label text for the checkbox
---@param localizationTooltip string The localized tooltip text for the checkbox
---@param defaultValue any Reserved for future use
---@param maximumValue any Reserved for future use
---@return number yCoord The updated Y coordinate after placing all controls
function TRB.Functions.OptionsUi:CreateAudioOption(parent, controls, name, spec, classId, specId, yCoord, localization, localizationTooltip, defaultValue, maximumValue)
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	controls.checkBoxes[name] = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Checkbox", parent, "ChatConfigCheckButtonTemplate")

	local f = controls.checkBoxes[name]
	f:SetPoint("TOPLEFT", oUi.xCoord, yCoord)
	getglobal(f:GetName() .. 'Text'):SetText(localization)
	f.tooltip = localizationTooltip
	f:SetChecked(spec.audio[name].enabled)
	f:SetScript("OnClick", function(self, ...)
		spec.audio[name].enabled = self:GetChecked()
		if spec.audio[name].enabled then
			PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
		end
	end)
	TRB.Functions.OptionsUi:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)

	yCoord = yCoord - 60
	return yCoord
end

---Creates a sound file selection dropdown for a named audio trigger, populated from LibSharedMedia sound entries.
---@param parent frame The parent frame to attach controls to
---@param controls table The controls table to store created UI elements
---@param name string The key name of the audio option in spec.audio (e.g., "overcap")
---@param spec table The spec settings table containing audio configuration
---@param classId integer? The class ID, or nil for global settings
---@param specId integer? The spec ID, or nil for global settings
---@param yCoord number The current Y coordinate for vertical positioning of the dropdown
function TRB.Functions.OptionsUi:CreateAudioDropDown(parent, controls, name, spec, classId, specId, yCoord)
	FillSoundCache()
	local className, specName = TRB.Functions.Character:GetClassAndSpecializationNames(classId, specId)
	local namePrefix = className .. "_" .. specName

	controls.dropDown = controls.dropDown or {}

	controls.dropDown[name .. "Audio"] = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_" .. name .. "Audio", parent, "WowStyle1DropdownTemplate")
	local dd = controls.dropDown[name .. "Audio"]
	dd:SetWidth(oUi.sliderWidth)
	dd:SetDefaultText(spec.audio[name].soundName)
	local function IsSelected(value)
		return value == spec.audio[name].sound
	end

	local function SetSelected(newValue)
		spec.audio[name].sound = newValue
		spec.audio[name].soundName = soundPairsByName[newValue]
		dd:SetDefaultText(spec.audio[name].soundName)
		PlaySoundFile(spec.audio[name].sound, TRB.Data.settings.core.audio.channel.channel)
	end

	local function Generator(dropdown, rootDescription)
		for k, v in pairs(soundPairs) do
			rootDescription:CreateRadio(v[1], IsSelected, SetSelected, v[2])
		end
		rootDescription:SetScrollMode(400)

	end
	dd:SetupMenu(Generator)
	dd:SetPoint("TOPLEFT", oUi.xPadding2, yCoord-20)
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
function TRB.Functions.OptionsUi:GenerateBarTextEditor(parent, controls, spec, classId, specId, yCoord, cache)
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
		TRB.Functions.OptionsUi:BuildUseGlobalShortcutLink(f, "barText")
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
			TRB.Functions.OptionsUi:RefreshBulkGlobalToggleCheckbox("globalBarText")
		end)
		yCoord = yCoord - 20
	else
		yCoord = yCoord + 10 -- Fix offset
		yCoord = TRB.Functions.OptionsUi:BuildBulkGlobalToggleCheckbox(parent, controls, "enableAllGlobalBarText", "globalBarText", yCoord, L["GlobalBarTextBulkToggleLabel"], L["GlobalBarTextBulkToggleTooltip"])
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

	local addButton = TRB.Functions.OptionsUi:BuildButton(parent, L["AddNewBarTextArea"], 0, 0, 175, 25)

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

	local barTextName = TRB.Functions.OptionsUi:BuildTextBox(barTextOptionsFrame, "", 200, 300, 20, oUi.xCoord, yCoord)
---@diagnostic disable-next-line: inject-field
	barTextName.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["Name"], oUi.xCoord, yCoord+25)
	barTextName.label.font:SetFontObject(GameFontNormal)

	local barTextEntryEnabled = CreateFrame("CheckButton", "TwintopResourceBar_" .. namePrefix .. "_TextEnabled", barTextOptionsFrame, "ChatConfigCheckButtonTemplate")
	barTextEntryEnabled:SetPoint("TOPLEFT", oUi.xCoord2, yCoord)
	getglobal(barTextEntryEnabled:GetName() .. 'Text'):SetText(L["Enabled"])
---@diagnostic disable-next-line: inject-field
	barTextEntryEnabled.tooltip = L["BarTextEntryEnabledTooltip"]

	yCoord = yCoord - 30
	controls.labels = controls.labels or {}
	controls.labels.barText = TRB.Functions.OptionsUi:BuildLabel(barTextOptionsFrame, L["BarText"], oUi.xCoord, yCoord, 90, 20)

	yCoord = yCoord - 20
	local barText = TRB.Functions.OptionsUi:CreateBarTextInputPanel(barTextOptionsFrame, namePrefix .. "_Text", "",
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
	local barTextHorizontal = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxWidth), math.floor(sanityCheckValues.barMaxWidth), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	barTextHorizontal:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.position.xPos = value
		RefreshBarTextEditorPreview(false)
	end)
	controls.barTextHorizontal = barTextHorizontal

	title = L["VerticalOffset"]
	local barTextVertical = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, math.ceil(-sanityCheckValues.barMaxHeight), math.floor(sanityCheckValues.barMaxHeight), 0, 1, 2,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	barTextVertical:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		workingBarText.position.yPos = value
		RefreshBarTextEditorPreview(false)
	end)
	controls.barTextVertical = barTextVertical

	yCoord = yCoord - 40
	local barTextRelativeToFrame = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_barTextRelativeToFrame", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextRelativeToFrame:SetWidth(oUi.sliderWidth)
	barTextRelativeToFrame.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["BoundToBar"], oUi.xCoord, yCoord)
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
	barTextRelativeTo.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
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

	FillFontCache()
	local UpdateBarTextEditorInheritedControlState

	local barTextFontFace = CreateFrame("DropdownButton", "TwintopResourceBar_" .. namePrefix .. "_fontFace", barTextOptionsFrame, "WowStyle1DropdownTemplate")
	barTextFontFace:SetWidth(oUi.sliderWidth)
	barTextFontFace.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["FontFaceHeader"], oUi.xCoord, yCoord)
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
	barTextFontJustifyHorizontal.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["RelativePositionBarTextHeader"], oUi.xCoord2, yCoord)
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
	local fontSize = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, 6, 300, 18, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontSize:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
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
	controls.colors.barText.color = TRB.Functions.OptionsUi:BuildColorPicker(barTextOptionsFrame, L["FontColor"], initialBarTextColor,
																			oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord)
	local barTextColor = controls.colors.barText.color
	barTextColor:SetScript("OnMouseDown", function(self, button, ...)
		NormalizeBarTextEntryColor(workingBarText)
		TRB.Functions.OptionsUi:ColorOnMouseDown(button, workingBarText, controls.colors.barText, "color")
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
	barTextFontOutline.label = TRB.Functions.OptionsUi:BuildSectionHeader(barTextOptionsFrame, L["FontOutlineHeader"], oUi.xCoord, yCoord)
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

	controls.colors.barText.fontShadowColor = TRB.Functions.OptionsUi:BuildColorPicker(barTextOptionsFrame, L["FontShadowColor"],
		"FF000000", oUi.colorPickerTextWidth, oUi.colorPickerFrameSize, oUi.xCoord2, yCoord-10)
	local barTextShadowColor = controls.colors.barText.fontShadowColor
	barTextShadowColor:SetScript("OnMouseDown", function(self, button, ...)
		if button == "LeftButton" then
			if workingBarText.fontShadow == nil then
				workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
			end
			local colorString = workingBarText.fontShadow.color or "FF000000"
			local r, g, b, a = TRB.Functions.Color:GetRGBAFromString(colorString, true)
			TRB.Functions.OptionsUi:ShowColorPicker(r, g, b, 1-a, function(color)
				local r_1, g_1, b_1, a_1 = TRB.Functions.OptionsUi:ExtractColorFromColorPicker(color)
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
	local fontShadowXOffset = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, -10, 10, 1, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord, yCoord)
	fontShadowXOffset:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.xOffset = value
		RefreshBarTextEditorPreview(true)
	end)

	title = L["FontShadowYOffset"]
	local fontShadowYOffset = TRB.Functions.OptionsUi:BuildSlider(barTextOptionsFrame, title, -10, 10, -1, 1, 0,
								oUi.sliderWidth, oUi.sliderHeight, oUi.xCoord2, yCoord)
	fontShadowYOffset:SetScript("OnValueChanged", function(self, value)
		value = TRB.Functions.OptionsUi:EditBoxSetTextMinMax(self, value)
		if workingBarText.fontShadow == nil then
			workingBarText.fontShadow = { enabled = false, color = "FF000000", xOffset = 1, yOffset = -1 }
		end
		workingBarText.fontShadow.yOffset = value
		RefreshBarTextEditorPreview(true)
	end)

	UpdateBarTextEditorInheritedControlState = function()
		local hasWorkingBarText = workingBarText ~= nil
		TRB.Functions.OptionsUi:ToggleDropdownEnabled(barTextFontFace, hasWorkingBarText and not workingBarText.useDefaultFontFace)
		TRB.Functions.OptionsUi:ToggleSliderEnabled(fontSize, hasWorkingBarText and not workingBarText.useDefaultFontSize)
		TRB.Functions.OptionsUi:ToggleColorPickerEnabled(barTextColor, hasWorkingBarText and not workingBarText.useDefaultFontColor)
		TRB.Functions.OptionsUi:ToggleDropdownEnabled(barTextFontOutline, hasWorkingBarText and not (workingBarText.useDefaultFontOutline or false))

		local shadowControlsEnabled = hasWorkingBarText and not (workingBarText.useDefaultFontShadow or false)
		TRB.Functions.OptionsUi:ToggleCheckboxEnabled(fontShadowEnabled, shadowControlsEnabled)
		TRB.Functions.OptionsUi:ToggleColorPickerEnabled(barTextShadowColor, shadowControlsEnabled)
		TRB.Functions.OptionsUi:ToggleSliderEnabled(fontShadowXOffset, shadowControlsEnabled)
		TRB.Functions.OptionsUi:ToggleSliderEnabled(fontShadowYOffset, shadowControlsEnabled)
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
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)

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
		TRB.Functions.OptionsUi:ToggleCheckboxOnOff(barTextEntryEnabled, workingBarText.enabled, true)
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
	AttachUndoRedo(barText)

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
		TRB.Functions.OptionsUi:SwitchToBarTextTabByClassSpec(classId, specId)
	end

	controls.barTextFields = {}
	controls.barTextFields.barTextTable = barTextTable
	controls.barTextFields.ResetTableValues = ResetTableValues

	yCoord = oldYCoord
	local variablesPanel = TRB.Functions.OptionsUi:CreateVariablesSidePanel(parent, namePrefix, cache, classId, specId)
	-- Tag the scroll child's ancestor (the tabsheet parent) so SwitchTab/SelectCategory can find the right panel
	---@diagnostic disable-next-line: inject-field
	parent.barTextVariablesPanel = variablesPanel
	TRB.Options:CreateBarTextInstructions(parent, oUi.xCoord, yCoord)
end